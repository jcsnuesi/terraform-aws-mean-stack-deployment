"use strict";
import mongoose from "mongoose";

const mongooseSchema = mongoose.Schema;
const userSchema = new mongooseSchema(
  {
    avatar: {
      type: String,
      required: true,
    },
    username: {
      type: String,
      required: true,
      unique: true,
    },
    email: {
      type: String,
      required: true,
      unique: true,
    },
    password: {
      type: String,
      required: true,
    },
    createdAt: {
      type: Date,
      default: Date.now,
    },
    role: { type: String, default: "user", enum: ["user", "admin"] },
  },
  {
    timestamps: true,
  }
);
export default mongoose.model("User", userSchema);
