import { defineConfig, devices } from "@playwright/test";

export default defineConfig({
  testDir: "./tests/e2e",
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [["html", { outputFolder: "playwright-report", open: "never" }]],
  use: {
    baseURL: "http://localhost:8080",
    trace: "on-first-retry",
  },
  projects: [
    {
      name: "chromium",
      use: {
        ...devices["Desktop Chrome"],
        launchOptions: {
          executablePath: "/usr/bin/chromium",
        },
      },
    },
  ],

  /* Run your local dev server before starting the tests */
  // webServer: {
  // 	command: "bun run dist/index.html --port=8080",
  // 	url: "http://localhost:8080",
  // 	// reuseExistingServer: !process.env.CI,
  // },
});
