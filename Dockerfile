# syntax=docker/dockerfile:1

# ──────────────────────────────────────────
# Stage 1: Build
# ──────────────────────────────────────────
FROM oven/bun:1 AS build

WORKDIR /app

COPY package.json bun.lock* ./
RUN bun install --frozen-lockfile

COPY . .

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

RUN bun run build

# ──────────────────────────────────────────
# Stage 2: Serve with Caddy
# ──────────────────────────────────────────
FROM caddy:2-alpine

LABEL org.opencontainers.image.source="https://github.com/OWNER/PROJECT"
LABEL org.opencontainers.image.description="Astro static site served with Caddy"

COPY <<'EOF' /etc/caddy/Caddyfile
:80 {
    root * /srv
    file_server
    try_files {path} {path}/index.html
    encode gzip

    # Immutable hashed assets — cache aggressively
    header /assets/* Cache-Control "public, max-age=31536000, immutable"

    # HTML pages — always revalidate
    header /*.html Cache-Control "no-cache, no-store, must-revalidate"
}
EOF

COPY --from=build /app/dist /srv

RUN addgroup -S app && adduser -S app -G app && \
    chown -R app:app /srv /config /data

USER app

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -qO- http://localhost:80/ || exit 1

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]
