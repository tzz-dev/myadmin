import { Hono } from "hono";
import { cors } from "hono/cors";
import { createDb, eq, users } from "@myadmin/db";

const db = createDb();

const app = new Hono()
  .use(
    "*",
    cors({
      origin: (process.env.CORS_ORIGINS ?? "http://localhost:3000,http://localhost:3001").split(","),
    }),
  )
  .get("/health", (c) => c.json({ ok: true }))
  .get("/users", async (c) => c.json(await db.select().from(users)))
  .get("/users/:id", async (c) => {
    const [user] = await db
      .select()
      .from(users)
      .where(eq(users.id, Number(c.req.param("id"))));
    return user ? c.json(user) : c.json({ error: "not found" }, 404);
  });

export default app;
// web / admin 可 import type { AppType } 配合 hono/client 获得端到端类型
export type AppType = typeof app;
