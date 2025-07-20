const ASSETS_BASE_URL = process.env.NEXT_PUBLIC_ASSETS_BASE_URL || '/assets';

export function assetUrl(path) {
  if (path.startsWith('/')) path = path.slice(1);
  return `${ASSETS_BASE_URL}/${path}`;
} 