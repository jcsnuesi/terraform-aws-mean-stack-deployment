"use strict";
import jwt from "jwt-simple";
import moment from "moment";
const secret = "clave-nueva-para-stack-mean-2025";

export function authentication(req, res, next) {
  if (req.headers.authorization) {
    const token = req.headers.authorization.replace(/['"]+/g, "");
    try {
      const payload = jwt.decode(token, secret);
      if (payload.exp <= moment().unix()) {
        return res.status(401).send({ message: "Token has expired" });
      }
      req.user = payload;
    } catch (error) {
      return res.status(401).send({ message: "Invalid token" });
    }
  }

  next();
}
