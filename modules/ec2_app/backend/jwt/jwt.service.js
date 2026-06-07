"use strict";
import moment from "moment";
import jwt from "jwt-simple";

var secret = "clave-nueva-para-stack-mean-2025";

export function createToken(user) {
  var payload = {
    sub: user._id,
    email: user.email,
    role: user.role,
    iat: moment().unix(),
    exp: moment().add(1, "days").unix,
  };

  return jwt.encode(payload, secret);
}
