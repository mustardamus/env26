// https://github.com/pocketbase/js-sdk?tab=readme-ov-file#ssr-integration

import { defineMiddleware } from "astro/middleware";
import PocketBase from "pocketbase";

const PUBLIC_ROUTES = ["/", "/login", "/register"];

export const onRequest = defineMiddleware(
  async ({ locals, request, redirect }, next) => {
    let isAuthenticated = false;
    locals.pb = new PocketBase("http://127.0.0.1:8090");

    locals.pb.authStore.loadFromCookie(request.headers.get("cookie") || "");

    try {
      if (locals.pb.authStore.isValid) {
        await locals.pb.collection("users").authRefresh();
        isAuthenticated = true;
      }
    } catch {
      locals.pb.authStore.clear();
    }

    const url = new URL(request.url);
    const isPublicRoute = PUBLIC_ROUTES.includes(url.pathname);

    if (!isPublicRoute && !isAuthenticated) {
      return redirect("/login");
    }

    locals.currentUser = locals.pb.authStore.record;
    const response = await next();

    response.headers.append("set-cookie", locals.pb.authStore.exportToCookie());

    return response;
  },
);
