/** FCM HTTP v1 — Firebase service account ile push gönderir. */

type ServiceAccount = {
  client_email: string;
  private_key: string;
  project_id: string;
};

function pemToArrayBuffer(pem: string): ArrayBuffer {
  const b64 = pem
    .replace(/-----BEGIN PRIVATE KEY-----/, '')
    .replace(/-----END PRIVATE KEY-----/, '')
    .replace(/\s+/g, '');
  const binary = atob(b64);
  const bytes = new Uint8Array(binary.length);
  for (let i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
  return bytes.buffer;
}

async function getAccessToken(sa: ServiceAccount): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  const header = { alg: 'RS256', typ: 'JWT' };
  const claim = {
    iss: sa.client_email,
    scope: 'https://www.googleapis.com/auth/firebase.messaging',
    aud: 'https://oauth2.googleapis.com/token',
    iat: now,
    exp: now + 3600,
  };

  const enc = new TextEncoder();
  const b64url = (data: Uint8Array | string) => {
    const str = typeof data === 'string'
      ? btoa(data)
      : btoa(String.fromCharCode(...data));
    return str.replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
  };

  const unsigned = `${b64url(JSON.stringify(header))}.${b64url(JSON.stringify(claim))}`;
  const key = await crypto.subtle.importKey(
    'pkcs8',
    pemToArrayBuffer(sa.private_key),
    { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-256' },
    false,
    ['sign'],
  );
  const sig = await crypto.subtle.sign(
    'RSASSA-PKCS1-v1_5',
    key,
    enc.encode(unsigned),
  );
  const jwt = `${unsigned}.${b64url(new Uint8Array(sig))}`;

  const res = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion: jwt,
    }),
  });
  if (!res.ok) {
    throw new Error(`FCM token alınamadı: ${await res.text()}`);
  }
  const json = await res.json();
  return json.access_token as string;
}

function loadServiceAccount(): ServiceAccount {
  const b64 = Deno.env.get('FIREBASE_SERVICE_ACCOUNT_B64');
  if (b64 && b64.trim().length > 0) {
    try {
      const decoded = atob(b64.trim());
      return JSON.parse(decoded) as ServiceAccount;
    } catch (e) {
      throw new Error(`FIREBASE_SERVICE_ACCOUNT_B64 parse hatası: ${e}`);
    }
  }

  const raw = Deno.env.get('FIREBASE_SERVICE_ACCOUNT_JSON');
  if (!raw) {
    throw new Error(
      'FIREBASE_SERVICE_ACCOUNT_B64 veya FIREBASE_SERVICE_ACCOUNT_JSON secret eksik',
    );
  }

  try {
    const cleaned = raw.replace(/^\uFEFF/, '').trim();
    const tryParse = (text: string): unknown => {
      let parsed: unknown = JSON.parse(text);
      // PowerShell / env-file bazen JSON'u çift encode eder
      if (typeof parsed === 'string') {
        parsed = JSON.parse(parsed);
      }
      return parsed;
    };
    try {
      return tryParse(cleaned) as ServiceAccount;
    } catch {
      // {\"type\":...} gibi fazla escape edilmiş değer
      return tryParse(cleaned.replace(/\\"/g, '"')) as ServiceAccount;
    }
  } catch (e) {
    throw new Error(
      `FIREBASE_SERVICE_ACCOUNT_JSON parse hatası (ilk 20: ${
        raw.slice(0, 20)
      }): ${e}`,
    );
  }
}

export async function sendFcmToTokens(opts: {
  tokens: string[];
  title: string;
  body: string;
  data?: Record<string, string>;
}): Promise<{ sent: number; failed: number }> {
  const sa = loadServiceAccount();
  const accessToken = await getAccessToken(sa);
  let sent = 0;
  let failed = 0;

  for (const token of opts.tokens) {
    const res = await fetch(
      `https://fcm.googleapis.com/v1/projects/${sa.project_id}/messages:send`,
      {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${accessToken}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          message: {
            token,
            notification: { title: opts.title, body: opts.body },
            data: opts.data ?? {},
            android: {
              priority: 'HIGH',
              notification: { channel_id: 'klinik_push' },
            },
            apns: {
              payload: { aps: { sound: 'default' } },
            },
          },
        }),
      },
    );
    if (res.ok) sent++;
    else failed++;
  }

  return { sent, failed };
}
