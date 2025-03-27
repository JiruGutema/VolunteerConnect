const express = require("express");
const router = express.Router();
const { registerUser, registerOrganization, login, checkAuth, check  } = require("../controllers/user.controller");

// router.post("/register",authMiddleware, register);
router.post("/registerUser", registerUser);
router.post("/registerOrganization", registerOrganization);
router.get("/check", checkAuth, check);
router.post("/login", login);

module.exports = router;
