import express from "express";
import userController from "../controller/user.controller.js";
import multiparty from "connect-multiparty";

const router = express.Router();
const multipartyMiddleware = multiparty({ uploadDir: "./upload/users" });

router.get("/avatar/:avatar", userController.getAvatar);
router.post("/create", multipartyMiddleware, userController.createUser);
router.post("/login", userController.login);

export default router;
