// server.js
import express from "express";

const app = express();
const PORT = parseInt(process.env.PORT || "8080", 10);

// 기본 페이지
app.get("/", (req, res) => {
  res.send(`✅ Hello from demo app! (PORT=${PORT})`);
});

// 헬스체크 엔드포인트 (CI/CD 검증용)
app.get("/health", (req, res) => res.status(200).send("ok"));

// 서버 시작
app.listen(PORT, "0.0.0.0", () => {
  console.log(`🚀 Server listening on port ${PORT}`);
});
