import tsParser from "@typescript-eslint/parser";
import tsPlugin from "@typescript-eslint/eslint-plugin";
import astroPlugin from "eslint-plugin-astro";
import jsoncPlugin from "eslint-plugin-jsonc";

export default [
  {
    ignores: ["node_modules/**", ".astro/**", "dist/**", "bun.lock"],
  },
  {
    files: ["**/*.{js,mjs,cjs,jsx}"],
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
    },
    rules: {
      "no-unused-vars": "warn",
      "no-undef": "error",
    },
  },
  {
    files: ["**/*.{ts,tsx}"],
    languageOptions: {
      parser: tsParser,
      parserOptions: {
        ecmaVersion: "latest",
        sourceType: "module",
      },
    },
    plugins: {
      "@typescript-eslint": tsPlugin,
    },
    rules: {
      "@typescript-eslint/no-unused-vars": "warn",
      "@typescript-eslint/no-explicit-any": "warn",
    },
  },
  ...astroPlugin.configs.recommended,
  ...jsoncPlugin.configs["flat/recommended-with-json"],
];
