import { createServer } from "node:http";

const port = Number(process.env.PORT ?? 3001);

const server = createServer((req, res) => {
  if (req.url === "/health" && req.method === "GET") {
    res.writeHead(200, { "content-type": "application/json" });
    res.end(JSON.stringify({
      status: "ok",
      service: "patient-queue-api",
      version: "0.1.0"
    }));
    return;
  }

  res.writeHead(404, { "content-type": "application/json" });
  res.end(JSON.stringify({
    success: false,
    error: {
      code: "NOT_FOUND",
      message: "Route not found."
    }
  }));
});

server.listen(port, () => {
  console.log(`patient-queue-api listening on :${port}`);
});
