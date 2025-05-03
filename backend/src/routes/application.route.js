const express = require("express");
const router = express.Router();
const { createEvent, getEventById, deleteEvent, updateEvent, getAllEvents, getOrganizationEvents, getUserEventApplications, getEventApplicants, applyForEvent } = require("../controllers/application.controller");
const authMiddleware = require("../middlewares/authMiddleware");
const adminMiddleware = require("../middlewares/adminMiddleware");


router.post("/events/create", createEvent); // create new event

router.get("/events/org", getOrganizationEvents) // all events by organization

router.get("/applications/:eventId", getEventById); // post details by id
router.delete("/application/:eventId", deleteEvent); // delete event by id
router.put("/application/update/:eventId", updateEvent);  // update event by id
router.get("/application/getallapplications", getAllEvents);    // explorer

router.get("/events/:eventId/applicants/",authMiddleware, getEventApplicants); // get all applicants for an event

router.get("/application/myApplication", getUserEventApplications) // get all applications by user
router.post("/application/apply/:eventId",authMiddleware, applyForEvent) // apply for event

module.exports = router;