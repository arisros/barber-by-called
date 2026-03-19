# Barber by Called

## Stack
- **Framework:** Astro 4+
- **Styling:** TailwindCSS v4
- **Components:** Astro + optional React islands
- **CMS Integration:** Strapi (headless) or Markdown/MDX
- **Deploy:** Static (Netlify/Vercel) or SSR (Node adapter)

## Quick Start
```bash
bun install
bun dev
```

## Project Structure
```
.
├── src/
│   ├── components/   # Reusable Astro/React components
│   ├── layouts/      # Page layouts
│   ├── pages/        # File-based routing
│   ├── content/      # MDX/Markdown content (if using content collections)
│   └── styles/       # Global CSS
├── public/           # Static assets
├── astro.config.mjs
├── tailwind.config.mjs
├── .env.example
├── Makefile
└── README.md
```

## Key Commands
```bash
bun dev           # Dev server (localhost:4321)
bun run build     # Static build → dist/
bun run preview   # Preview production build
```
