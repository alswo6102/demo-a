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

app.get("/healthz", (_req, res) => res.type("text").send("OK"));

const port = process.env.PORT || 3000;

app.listen(port, () => {
  console.log(`[demo-a] frontend listening on ${port}`);

  // 서버가 성공적으로 시작된 후에, 프록시 미들웨어를 설정합니다.
  console.log("Setting up API proxy to http://demo_api:8000");
  
  app.use("/api",
    createProxyMiddleware({
      target: "http://demo_api:8000",
      changeOrigin: false,
      xfwd: true,
      pathRewrite: { "^/api": "" },
      proxyTimeout: 5000,
      onError(err, req, res) {
        console.error("Proxy error:", err); // 터미널에 에러 로그 출력
        if (!res.headersSent) {
          res.status(502).json({ ok:false, error:"api_bad_gateway", detail:String(err?.message||err) });
        }
      }
    })
  );

  console.log("API proxy has been set up.");
});
