/// <reference types="astro/client" />

declare namespace App {
  interface Locals {
    pb: import("pocketbase").default;
    currentUser: import("pocketbase").RecordModel | null;
  }
}
