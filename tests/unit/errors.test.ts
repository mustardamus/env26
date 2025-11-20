import { describe, test, expect } from "vitest";
import { ClientResponseError } from "pocketbase";
import { errorToFlatObject } from "@/lib/errors";

describe("errorToFlatObject", () => {
  test("generic error to .general field", () => {
    const error = new Error("Something went wrong");
    const result = errorToFlatObject(error);

    expect(result).toEqual({ general: "Something went wrong" });
  });

  test("generic pocketbase client error to .general field", () => {
    const error = new ClientResponseError({
      status: 400,
      data: {
        message: "Invalid request",
        data: {},
      },
    });

    const result = errorToFlatObject(error);

    expect(result).toEqual({ general: "Invalid request" });
  });

  test("specific pocketbase client error fields to .field", () => {
    const error = new ClientResponseError({
      status: 400,
      data: {
        message: "Validation failed",
        data: {
          email: { message: "Email is required" },
          password: { message: "Password must be at least 8 characters" },
        },
      },
    });

    const result = errorToFlatObject(error);

    expect(result).toEqual({
      email: "Email is required",
      password: "Password must be at least 8 characters",
    });
  });

  test("unknown error to generic .general field", () => {
    // Force a non-Error value through the function
    // TypeScript expects Error, but we test runtime behavior
    const unknownError = "string error" as unknown as Error;
    const result = errorToFlatObject(unknownError);

    expect(result).toEqual({ general: "Unknown Error" });
  });
});
