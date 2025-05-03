const express = require("express");
const router = express.Router();
const { register, login, checkUser, updateUserRoleToVolunteer, updateUserRoleToOrg,getAllUsers, deleteUser, updateUser, getUserById } = require("../controllers/user.controller");
const { createEvent, getEventById, deleteEvent, updateEvent, getAllEvents, getOrganizationEvents } = require("../controllers/application.controller");
const authMiddleware = require("../middlewares/authMiddleware");
const adminMiddleware = require("../middlewares/adminMiddleware");

router.post("/auth/register", register); //register
router.post("/auth/login", login); //login

router.get("/user/:userId/profile", getUserById); // get user profile
router.get("/checkUser",authMiddleware, checkUser); // check user authentication

router.post("/application/create", createEvent); // create new event

router.get("/application/myApplication", getOrganizationEvents) // get all events created by the org
router.get("/application/:eventId", getEventById); // get event by id
router.delete("/application/:eventId", deleteEvent); // delete event by id
router.put("/application/update/:eventId", updateEvent);  // update event by id
router.get("/application/getallapplications", getAllEvents);    //explore


router.put("/user/update/:userId",updateUser) // update user profile
router.put("/:userId/role/host", authMiddleware, updateUserRoleToOrg);  
router.put("/:userId/role/guest", authMiddleware, updateUserRoleToVolunteer); 

router.delete("/user",  deleteUser);



module.exports = router;

