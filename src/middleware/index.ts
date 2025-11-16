// https://github.com/pocketbase/js-sdk?tab=readme-ov-file#ssr-integration

import { defineMiddleware } from "astro/middleware";
import PocketBase from "pocketbase";

export const onRequest = defineMiddleware(async ({ locals, request }, next) => {
  locals.pb = new PocketBase("http://127.0.0.1:8090");

  locals.pb.authStore.loadFromCookie(request.headers.get("cookie") || "");

  try {
    if (locals.pb.authStore.isValid) {
      await locals.pb.collection("users").authRefresh();
    }
  } catch {
    locals.pb.authStore.clear();
  }

  const response = await next();

  response.headers.append("set-cookie", locals.pb.authStore.exportToCookie());

  return response;
});
