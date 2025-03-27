const { StatusCodes } = require("http-status-codes");
const dbConnection = require("../config/db");
const { genSalt, hash, compare } = require("bcrypt");
const jwt = require("jsonwebtoken");

const SECRET_KEY = process.env.JWT_SECRET;

// ✅ Register User (volunteer or org_admin)
async function registerUser(req, res) {
    const { username, email, password, role } = req.body;

    if (!username || !email || !password) {
        return res.status(StatusCodes.BAD_REQUEST).json({ message: "Username, email, and password are required" });
    }

    try {
        // Check if user exists
        const [existingUser] = await dbConnection.query(
            "SELECT user_id FROM Users WHERE username = ? OR email = ?",
            [username, email]
        );

        if (existingUser.length > 0) {
            return res.status(StatusCodes.BAD_REQUEST).json({ message: "Username or email already exists" });
        }

        // Hash password
        const salt = await genSalt(10);
        const hashedPassword = await hash(password, salt);

        // Insert into Users table
        await dbConnection.query(
            "INSERT INTO Users (username, email, password_hash, role) VALUES (?, ?, ?, ?)",
            [username, email, hashedPassword, role || 'volunteer']
        );

        return res.status(StatusCodes.CREATED).json({ message: "User registered successfully" });
    } catch (error) {
        console.error("User Registration error:", error);
        return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ message: "Server error" });
    }
}

// ✅ Register Organization

async function registerOrganization(req, res) {
    const { name, description, website, contact_email, password, contact_phone } = req.body;

    if (!password || !contact_email) {
        return res.status(StatusCodes.BAD_REQUEST).json({ message: "Organization password and contact email are required" });
    }

    try {
        // Check if organization exists
        const [existingOrg] = await dbConnection.query(
            "SELECT organization_id FROM Organizations WHERE contact_email = ?",
            [contact_email]
        );

        if (existingOrg.length > 0) {
            return res.status(StatusCodes.BAD_REQUEST).json({ message: "Organization already exists" });
        }

        // Hash the password
        const salt = await genSalt(10);
        const hashedPassword = await hash(password, salt);

        // Insert into Organizations table (including the hashed password)
        await dbConnection.query(
            "INSERT INTO Organizations (name, description, website, contact_email, contact_phone, password_hash) VALUES (?, ?, ?, ?, ?, ?)",
            [name, description, website, contact_email, contact_phone, hashedPassword]
        );

        return res.status(StatusCodes.CREATED).json({ message: "Organization registered successfully" });
    } catch (error) {
        console.error("Organization Registration error:", error);
        return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ message: "Server error" });
    }
}

// ✅ Login for Users & Organizations
async function login(req, res) {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(StatusCodes.BAD_REQUEST).json({ message: "Email and password are required" });
    }

    try {
        // Check if it's a user login
        const [users] = await dbConnection.query(
            "SELECT user_id, username, email, password_hash, role FROM Users WHERE email = ?",
            [email]
        );

        if (users.length > 0) {
            const user = users[0];

            // Compare password
            const validPassword = await compare(password, user.password_hash);
            if (!validPassword) {
                return res.status(StatusCodes.UNAUTHORIZED).json({ message: "Invalid email or password" });
            }

            // Generate JWT
            const token = jwt.sign(
                { id: user.user_id, username: user.username, email: user.email, role: user.role, type: "user" },
                SECRET_KEY,
                { expiresIn: "1d" }
            );

            return res.status(StatusCodes.OK).json({ message: "Login successful", token, username: user.username, role: user.role });
        }

        // Check if it's an organization login
        const [orgs] = await dbConnection.query(
            "SELECT organization_id, name, contact_email, password_hash FROM Organizations WHERE contact_email = ?",
            [email]
        );

        if (orgs.length > 0) {
            const org = orgs[0];

            // Compare password for organization
            const validPassword = await compare(password, org.password_hash);
            if (!validPassword) {
                return res.status(StatusCodes.UNAUTHORIZED).json({ message: "Invalid email or password" });
            }

            // Generate JWT (for organization)
            const token = jwt.sign(
                { id: org.organization_id, name: org.name, email: org.contact_email, type: "organization" },
                SECRET_KEY,
                { expiresIn: "1d" }
            );

            return res.status(StatusCodes.OK).json({id:org.organization_id, message: "Organization login successful", token, name: org.name });
        }

        return res.status(StatusCodes.UNAUTHORIZED).json({ message: "Invalid email or password" });
    } catch (error) {
        console.error("Login error:", error);
        return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ message: "Server error" });
    }
}


// ✅ JWT Middleware for protected routes
function checkAuth(req, res, next) {
    const token = req.headers.authorization?.split(" ")[1];
    if (!token) return res.status(StatusCodes.FORBIDDEN).json({ message: "No token provided" });

    jwt.verify(token, SECRET_KEY, (err, decoded) => {
        if (err) return res.status(StatusCodes.UNAUTHORIZED).json({ message: "Unauthorized" });
        req.user = decoded;
        next();
    });
}

// ✅ Check Authentication Status
function check(req, res) {
    if (!req.user) {
        return res.status(StatusCodes.UNAUTHORIZED).json({ message: "Unauthorized" });
    }
    return res.status(StatusCodes.OK).json({ user: req.user });
}

module.exports = { registerUser, registerOrganization, login, checkAuth, check };
