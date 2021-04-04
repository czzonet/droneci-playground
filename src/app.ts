import express from "express";
import http from "http";

export const app = async () => {
  const expressApp = express();

  expressApp.get("/", (req, res, next) => res.send("Hello."));

  const httpServer = http
    .createServer(expressApp)
    .listen(5544, "127.0.0.1", () => console.log("Server start."));
};
