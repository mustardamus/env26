import { describe, it, expect } from "vitest";

describe("Browser Environment Tests", () => {
  it("should have access to window object", () => {
    expect(window).toBeDefined();
    expect(typeof window).toBe("object");
  });

  it("should have access to document object", () => {
    expect(document).toBeDefined();
    expect(document.title).toBeDefined();
  });
});
