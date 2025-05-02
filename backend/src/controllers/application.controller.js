const dbConnection = require("../config/db");
const { StatusCodes } = require("http-status-codes");
const jwt = require("jsonwebtoken");
const { v4: uuidv4 } = require("uuid");

async function createEvent(req, res) {
  const authHeader = req.headers.authorization;
  
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(StatusCodes.UNAUTHORIZED).json({ message: "Authorization required" });
  }

  const token = authHeader.split(" ")[1];
  
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const org_id = decoded.userid; 
    const org_role = decoded.role; 
    console.log(org_role)

    if (org_role !== 'organization') {
      return res.status(StatusCodes.FORBIDDEN).json({ message: "Only organizations can create events" });
    }

    const { 
      title, subtitle, category, date, time, location,
      spotsLeft, image, description, requirements,
      additionalInfo, contactPhone, contactEmail, contactTelegram
    } = req.body;

    if (!title || !date || !time || !location) {
      return res.status(StatusCodes.BAD_REQUEST).json({ 
        message: "Title, date, time, and location are required" 
      });
    }

    const uuid = uuidv4();
    const parsedRequirements = requirements ? JSON.stringify(requirements) : null;
    const parsedAdditionalInfo = additionalInfo ? JSON.stringify(additionalInfo) : null;

    const [result] = await dbConnection.query(
      `INSERT INTO events (
        uuid, org_id, title, subtitle, category, date, time, location,
        spotsLeft, image, description, requirements, additionalInfo,
        contactPhone, contactEmail, contactTelegram
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        uuid, org_id, title, subtitle, category, date, time, location,
        spotsLeft || 0, image, description, parsedRequirements, parsedAdditionalInfo,
        contactPhone, contactEmail, contactTelegram
      ]
    );

    const [newEvent] = await dbConnection.query(
      "SELECT * FROM events WHERE uuid = ?", 
      [uuid]
    );

    return res.status(StatusCodes.CREATED).json({
      message: "Event created successfully",
      event: {
        ...newEvent[0],
        requirements: newEvent[0].requirements ? JSON.parse(newEvent[0].requirements) : null,
        additionalInfo: newEvent[0].additionalInfo ? JSON.parse(newEvent[0].additionalInfo) : null
      }
    });

  } catch (error) {
    console.error("Create Event Error:", error.message);
    
    if (error instanceof jwt.JsonWebTokenError) {
      return res.status(StatusCodes.UNAUTHORIZED).json({ message: "Invalid token" });
    }

    return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ 
      message: "Failed to create event" 
    });
  }
}

async function updateEvent(req, res) {
  const { eventId } = req.params;
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(StatusCodes.UNAUTHORIZED).json({ message: "Authorization required" });
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const org_id = decoded.userid;
    const org_role = decoded.role;

    if (org_role !== 'organization') {
      return res.status(StatusCodes.FORBIDDEN).json({ message: "Only organizations can update events" });
    }

    const [event] = await dbConnection.query(
      "SELECT org_id FROM events WHERE id = ?", 
      [eventId]
    );

    if (!event || event.length === 0) {
      return res.status(StatusCodes.NOT_FOUND).json({ message: "Event not found" });
    }

    if (event[0].org_id !== org_id) {
      return res.status(StatusCodes.FORBIDDEN).json({ 
        message: "You can only update your organization's events" 
      });
    }

    const {
      title, subtitle, category, date, time, location,
      spotsLeft, image, description, requirements,
      additionalInfo, contactPhone, contactEmail, contactTelegram
    } = req.body;

    const parsedRequirements = requirements ? JSON.stringify(requirements) : null;
    const parsedAdditionalInfo = additionalInfo ? JSON.stringify(additionalInfo) : null;

    await dbConnection.query(
      `UPDATE events SET
        title = COALESCE(?, title),
        subtitle = COALESCE(?, subtitle),
        category = COALESCE(?, category),
        date = COALESCE(?, date),
        time = COALESCE(?, time),
        location = COALESCE(?, location),
        spotsLeft = COALESCE(?, spotsLeft),
        image = COALESCE(?, image),
        description = COALESCE(?, description),
        requirements = COALESCE(?, requirements),
        additionalInfo = COALESCE(?, additionalInfo),
        contactPhone = COALESCE(?, contactPhone),
        contactEmail = COALESCE(?, contactEmail),
        contactTelegram = COALESCE(?, contactTelegram)
      WHERE id = ?`,
      [
        title, subtitle, category, date, time, location,
        spotsLeft, image, description, parsedRequirements, parsedAdditionalInfo,
        contactPhone, contactEmail, contactTelegram,
        eventId
      ]
    );

    const [updatedEvent] = await dbConnection.query(
      "SELECT * FROM events WHERE id = ?",
      [eventId]
    );

    return res.status(StatusCodes.OK).json({
      message: "Event updated successfully",
      event: {
        ...updatedEvent[0],
        requirements: updatedEvent[0].requirements ? JSON.parse(updatedEvent[0].requirements) : null,
        additionalInfo: updatedEvent[0].additionalInfo ? JSON.parse(updatedEvent[0].additionalInfo) : null
      }
    });

  } catch (error) {
    console.error("Update Event Error:", error.message);
    
    if (error instanceof jwt.JsonWebTokenError) {
      return res.status(StatusCodes.UNAUTHORIZED).json({ message: "Invalid token" });
    }

    return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ 
      message: "Failed to update event" 
    });
  }
}

async function deleteEvent(req, res) {
  const { eventId } = req.params;
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(StatusCodes.UNAUTHORIZED).json({ message: "Authorization required" });
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const org_id = decoded.userid;
    const org_role = decoded.role;

    if (org_role !== 'organization') {
      return res.status(StatusCodes.FORBIDDEN).json({ message: "Only organizations can delete events" });
    }

    const [event] = await dbConnection.query(
      "SELECT org_id FROM events WHERE id = ?", 
      [eventId]
    );

    if (!event || event.length === 0) {
      return res.status(StatusCodes.NOT_FOUND).json({ message: "Event not found" });
    }

    if (event[0].org_id !== org_id) {
      return res.status(StatusCodes.FORBIDDEN).json({ 
        message: "You can only delete your organization's events" 
      });
    }

    await dbConnection.query(
      "DELETE FROM events WHERE id = ?",
      [eventId]
    );

    return res.status(StatusCodes.OK).json({ 
      message: "Event deleted successfully" 
    });

  } catch (error) {
    console.error("Delete Event Error:", error.message);
    
    if (error instanceof jwt.JsonWebTokenError) {
      return res.status(StatusCodes.UNAUTHORIZED).json({ message: "Invalid token" });
    }

    return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ 
      message: "Failed to delete event" 
    });
  }
}

async function getEventById(req, res) {
  const { eventId } = req.params;

  try {
    const [event] = await dbConnection.query(
      "SELECT * FROM events WHERE id = ?", 
      [eventId]
    );

    if (!event || event.length === 0) {
      return res.status(StatusCodes.NOT_FOUND).json({ message: "Event not found" });
    }

    return res.status(StatusCodes.OK).json({
      event: {
        ...event[0],
        requirements: event[0].requirements ? JSON.parse(event[0].requirements) : null,
        additionalInfo: event[0].additionalInfo ? JSON.parse(event[0].additionalInfo) : null
      }
    });

  } catch (error) {
    console.error("Get Event Error:", error.message);
    return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ 
      message: "Failed to retrieve event" 
    });
  }
}

async function getAllEvents(req, res) {
    try {
        const [events] = await dbConnection.query("SELECT * FROM events");
    
        const parsedEvents = events.map(event => ({
        ...event,
        requirements: event.requirements ? JSON.parse(event.requirements) : null,
        additionalInfo: event.additionalInfo ? JSON.parse(event.additionalInfo) : null
        }));
    
        return res.status(StatusCodes.OK).json({ events: parsedEvents });
    
    } catch (error) {
        console.error("Get All Events Error:", error.message);
        return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ 
        message: "Failed to retrieve events" 
        });
    }
    }


async function getOrganizationEvents(req, res) {
  const authHeader = req.headers.authorization;
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(StatusCodes.UNAUTHORIZED).json({
      error: "Authorization token required"
    });
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    if (decoded.role !== 'organization') {
      return res.status(StatusCodes.FORBIDDEN).json({
        error: "Only organizations can access this endpoint"
      });
    }

    const orgId = decoded.userid; // Get organization ID from token

    const [events] = await dbConnection.query(`
      SELECT 
        id,
        uuid,
        title,
        subtitle,
        category,
        DATE_FORMAT(date, '%Y-%m-%d') AS date,
        DATE_FORMAT(time, '%h:%i %p') AS time,
        location,
        spotsLeft,
        image
      FROM events
      WHERE org_id = ?
      ORDER BY date DESC
    `, [orgId]);

    return res.status(StatusCodes.OK).json({
      events: events.map(event => ({
        id: event.id,
        uuid: event.uuid,
        title: event.title,
        subtitle: event.subtitle,
        category: event.category,
        date: event.date,
        time: event.time,
        location: event.location,
        spotsLeft: event.spotsLeft,
        image: event.image
      }))
    });

  } catch (error) {
    if (error instanceof jwt.JsonWebTokenError) {
      return res.status(StatusCodes.UNAUTHORIZED).json({
        error: "Invalid or expired token"
      });
    }

    console.error("Error fetching organization events:", error);
    return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({
      error: "Failed to fetch organization events"
    });
  }
}

module.exports = {
    createEvent,
    updateEvent,
    deleteEvent,
    getEventById,
    getAllEvents,
    getOrganizationEvents
    };
