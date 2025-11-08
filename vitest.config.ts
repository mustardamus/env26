import { defineConfig } from "vitest/config";
import { playwright } from "@vitest/browser-playwright";

export default defineConfig({
  resolve: {
    alias: {
      "@": new URL("./src/", import.meta.url).pathname,
    },
  },
  test: {
    include: ["tests/unit/**/*.{test,spec}.{js,ts}"],
    exclude: ["tests/e2e/**/*"],
    browser: {
      enabled: true,
      provider: playwright({
        launchOptions: {
          executablePath: "/usr/bin/chromium",
        },
      }),
      headless: true,
      instances: [
        {
          browser: "chromium",
        },
      ],
    },
  },
});
