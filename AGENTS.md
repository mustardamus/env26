# Agent Guidelines

## Philosophy

**CRITICAL: Use ONLY native web technologies - vanilla HTML, CSS, and
JavaScript/TypeScript. NO frameworks, NO libraries, NO dependencies beyond build
tooling. Astro is used ONLY as a static site generator - output must be pure
HTML/CSS/JS.**

## Commands

- **Build**: `bun run build` - Build Astro project for production
- **Dev**: `bun run dev` - Start development server
- **Lint**: `make lint` (changed files) or `make lint_all` (all files)
- **Format**: `make format` (changed files) or `make format_all` (all files)
- **Test all**: `bun test` - Run unit and e2e tests
- **Test unit**: `bun run test:unit` or `vitest run` - Run single test with
  `vitest run tests/unit/browser.test.ts`
- **Test e2e**: `bun run test:e2e` or `playwright test` - Run single test with
  `playwright test tests/e2e/homepage.spec.ts`

## Code Style

- **Philosophy**: Native web platform only - vanilla HTML5, CSS3, ES6+
  JavaScript/TypeScript
- **NO frameworks/libraries**: No React, Vue, Svelte, jQuery, Lodash, etc. Use
  native Web APIs (fetch, DOM, etc.)
- **Runtime**: Bun (not Node.js) - use Bun APIs where available
- **Imports**: Use ES modules, prefer explicit imports, use `@/` alias for src
  directory
- **Types**: TypeScript strict mode enabled (astro/tsconfigs/strict), avoid
  `any`, prefer explicit types
- **Naming**: camelCase for variables/functions, PascalCase for components/types
- **Formatting**: Prettier enforced (double quotes for YAML per
  eslint.config.mjs:59, 2-space indentation)
- **Linting**: ESLint with TypeScript, Astro, JSONC, YAML, and JSX a11y plugins
  - warn on unused vars, error on undefined
- **Error handling**: Use proper TypeScript error types, avoid silent failures
- **Components**: Astro components (.astro) with TypeScript frontmatter,
  semantic HTML, accessibility rules enforced
- **CSS**: Custom CSS (no frameworks), imports in global.css, stylelint enforced
  for validity
