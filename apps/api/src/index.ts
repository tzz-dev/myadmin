import { serve } from "@hono/node-server";
import app from "./app";

const port = Number(process.env.API_PORT ?? 3002);
serve({ fetch: app.fetch, port }, () => console.log(`api listening on http://localhost:${port}`));
