import User from "../model/user.js";
import bcrypt from "bcryptjs";
import fs from "fs";
import path from "path";
import * as fd from "../jwt/jwt.service.js";

const userController = {
  createUser: async (req, res) => {
    try {
      const { username, email, password } = req.body;

      // avatar name
      const avatarName = req.files ? req.files.avatar.name : null;
      if (!avatarName) {
        return res.status(400).json({ message: "Avatar is required" });
      }
      const avatar_split = req.files.avatar.path.split("\\");
      const avatar = avatar_split[avatar_split.length - 1];
      // Check if user already exists
      const existingUser = await User.find({ email });
      if (existingUser.length > 0) {
        return res.status(400).json({ message: "User already exists" });
      }
      const user = new User({
        username,
        email,
        password: bcrypt.hashSync(password, 10),
        avatar: avatar,
      });
      await user.save();
      user.password = undefined; // Remove password from response
      return res.status(200).send({
        status: "success",
        message: "User created successfully",
        data: user,
      });
    } catch (error) {
      console.error("Error checking existing user:", error);
      return res.status(500).json({ message: "Internal server error" });
    }
  },
  login: async (req, res) => {
    console.log("Login request received:", req.body);
    const { email, password, token } = req.body;
    try {
      // Find user by email
      const user = await User.findOne({ email });
      if (!user) {
        return res.status(404).json({ message: "User not found" });
      }
      bcrypt.compare(password, user.password, (err, isMatch) => {
        if (err) {
          console.error("Error comparing passwords:", err);
          return res.status(500).json({ message: "Internal server error" });
        }
        if (!isMatch) {
          return res.status(401).json({ message: "Invalid credentials" });
        }

        user.password = undefined; // Remove password from response
        if (Boolean(token === "true")) {
          const token_generated = fd.createToken(user);
          return res.status(200).send({
            status: "success",
            message: "Login successfully",
            data: token_generated,
          });
        } else {
          return res.status(200).send({
            status: "success",
            message: "Login successfully",
            data: user,
          });
        }
      });
    } catch (error) {
      console.error("Error during login:", error);
      return res.status(500).json({ message: "Internal server error" });
    }
  },
  getAvatar: async (req, res) => {
    try {
      const { filename } = req.params.avatar;
      const filePath = path.join("./upload/users", filename);

      if (fs.existsSync(filePath)) {
        res.sendFile(filePath);
      } else {
        return res.status(404).json({ message: "Avatar not found" });
      }
    } catch (error) {
      console.error("Error retrieving avatar:", error);
      return res.status(500).json({ message: "Internal server error" });
    }
  },
};

export default userController;
