const express = require("express");
const router = express.Router();
const { register, login, checkUser, updateUserRoleToVolunteer, updateUserRoleToOrg,getAllUsers, deleteUser } = require("../controllers/user.controller");
const authMiddleware = require("../middlewares/authMiddleware");
const adminMiddleware = require("../middlewares/adminMiddleware");

router.post("/register", register);
router.post("/login", login);
router.get("/checkUser",authMiddleware, checkUser);
router.get("/getAllUsers",authMiddleware, getAllUsers);
router.put("/:userId/role/host", authMiddleware, updateUserRoleToOrg);  
router.put("/:userId/role/guest", authMiddleware, updateUserRoleToVolunteer); 
router.delete("/user/:id",  deleteUser); 
// router.delete("/user/:id", authMiddleware, deleteUser); 

module.exports = router;

