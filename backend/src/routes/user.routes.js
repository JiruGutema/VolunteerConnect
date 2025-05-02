const express = require("express");
const router = express.Router();
const { register, login, checkUser, updateUserRoleToVolunteer, updateUserRoleToOrg,getAllUsers, deleteUser, updateUser, getUserById } = require("../controllers/user.controller");
const { createEvent, getEventById, deleteEvent, updateEvent, getAllEvents, getOrganizationEvents } = require("../controllers/application.controller");
const authMiddleware = require("../middlewares/authMiddleware");
const adminMiddleware = require("../middlewares/adminMiddleware");

router.post("/auth/register", register);
router.post("/auth/login", login);

router.get("/user/:userId/profile", getUserById);
router.get("/checkUser",authMiddleware, checkUser);

router.post("/application/create", createEvent);

router.get("/application/myApplication", getOrganizationEvents)
router.get("/application/getAll", getEventById);
router.delete("/application/:eventId", deleteEvent);
router.put("/application/update/:eventId", updateEvent); 
router.get("/application/getallapplications", getAllEvents);    //explore


router.put("/user/update/:userId",updateUser)
router.put("/:userId/role/host", authMiddleware, updateUserRoleToOrg);  
router.put("/:userId/role/guest", authMiddleware, updateUserRoleToVolunteer); 

router.delete("/user",  deleteUser);



module.exports = router;

