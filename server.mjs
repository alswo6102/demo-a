import express from "express";
import { createProxyMiddleware } from "http-proxy-middleware";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
app.disable("x-powered-by");

// 정적 파일(바닐라 JS)
app.use(express.static(path.join(__dirname, "public")));

// 내부 API 프록시: /api/* -> http://demo_api:8000
app.use("/api",
  createProxyMiddleware({
    target: "http://demo_api:8000",
    changeOrigin: false,
    xfwd: true,
    pathRewrite: { "^/api": "/api" },
    proxyTimeout: 5000,
    onError(err, req, res) {
      res.status(502).json({ ok:false, error:"api_bad_gateway", detail:String(err?.message||err) });
    }
  })
);

app.get("/healthz", (_req, res) => res.type("text").send("OK"));

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`[demo-a] frontend listening on ${port}`));
