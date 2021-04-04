import { app } from "./app";

const main = async () => {
  await app();
};

main()
  .then()
  .catch((err) => console.error("[E]", err));
