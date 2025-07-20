FROM node:lts-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .

ARG NEXT_PUBLIC_ASSETS_BASE_URL
ENV NEXT_PUBLIC_ASSETS_BASE_URL=$NEXT_PUBLIC_ASSETS_BASE_URL

RUN npm run build

FROM node:lts-alpine AS runner
WORKDIR /app

# Create non-root user for security
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy built application
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

# Set ownership
RUN chown -R nextjs:nodejs /app
USER nextjs

# Set production environment
ENV NODE_ENV=production
ENV PORT=3030
ENV HOSTNAME="0.0.0.0"

ARG NEXT_PUBLIC_ASSETS_BASE_URL
ENV NEXT_PUBLIC_ASSETS_BASE_URL=$NEXT_PUBLIC_ASSETS_BASE_URL

EXPOSE 3030

CMD ["node", "server.js"] 