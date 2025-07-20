/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    domains: ['assets.aceternity.com', 'devops-next-japan-assets.s3.ap-southeast-1.amazonaws.com'],
    unoptimized: true,
  },
  output: 'standalone',
};

export default nextConfig;
