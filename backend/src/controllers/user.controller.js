const { StatusCodes } = require("http-status-codes");
const dbConnection = require("../config/db");
const { genSalt, hash, compare } = require("bcrypt");
require("dotenv").config();
const jwt = require("jsonwebtoken");

async function register(req, res) {
  const { name, email, password, role } = req.body;

  if (!email || !password || !name) {
    console.log("Missing fields in registration");
    return res
      .status(StatusCodes.BAD_REQUEST)
      .json({ message: "All fields are required" });
  }

  try {
    const [existingUser] = await dbConnection.query(
      "SELECT email FROM users WHERE email = ?",
      [email]
    );

    if (existingUser && existingUser.length) {
      console.log(existingUser);
      console.log("User already exists");
      return res
        .status(StatusCodes.BAD_REQUEST)
        .json({ message: "Account already registered" });
    }

    if (password.length < 6) {
      return res
        .status(StatusCodes.BAD_REQUEST)
        .json({ message: "Password must be at least 6 characters" });
    }

    const salt = await genSalt(10);
    const hashedPassword = await hash(password, salt);

    await dbConnection.query(
      "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)",
      [name, email, hashedPassword, role]
    );

    const [user] = await dbConnection.query(
      "SELECT id, name, password, role FROM users WHERE email = ?",
      [email]
    );
    const userData = user[0];
    const userid = userData.id;
    const token = jwt.sign({ name, userid, role }, process.env.JWT_SECRET, { expiresIn: "1d" });

    return res.status(StatusCodes.CREATED).json({ msg: "Registration success", token, name, userid, role });
  } catch (error) {
    console.error("Registration error:", error.message);
    return res
      .status(StatusCodes.INTERNAL_SERVER_ERROR)
      .json({ message: "Something went wrong, please try again later" });
  }
}

async function editUser(req, res) {
  const { id } = bod.params;
  const { name, password, email, city, phone, bio, skills, interest } = req.body;
  console.log(name, email, password);

  if (!phone || !name || !city || !skills || interest || !bio) {
    return res
      .status(StatusCodes.BAD_REQUEST)
      .json({ message: "You are expected to complete the profile information" });
  }

  try {
    const [user] = await dbConnection.query(
      "SELECT * from users where id = ?",
      [id]
    );
  } catch (error) {
    console.error("Edit User Error:", error.message, error.stack);
    return res
      .status(StatusCodes.INTERNAL_SERVER_ERROR)
      .json({ message: "Something went wrong, please try again later" });
  }
}

async function login(req, res) {
  const { email, password } = req.body;
  console.log(email, password);

  if (!email || !password) {
    return res
      .status(StatusCodes.BAD_REQUEST)
      .json({ message: "Email and password are required" });
  }

  try {
    const [user] = await dbConnection.query(
      "SELECT id, name, password, role FROM users WHERE email = ?",
      [email]
    );

    if (!user || user.length === 0) {
      console.log("Invalid email or password - no user found");
      return res
        .status(StatusCodes.UNAUTHORIZED)
        .json({ message: "Invalid email or password" });
    }

    const userData = user[0];
    console.log("userdata", userData);

    const validPassword = await compare(password, userData.password);
    console.log(password, userData.password, validPassword);

    if (!validPassword) {
      console.log("Invalid email or password - password mismatch");
      return res
        .status(StatusCodes.UNAUTHORIZED)
        .json({ message: "Invalid email or password" });
    }

    const name = userData.name;
    const userid = userData.id;
    const role = userData.role;

    const token = jwt.sign({ name, userid, role }, process.env.JWT_SECRET, { expiresIn: "1d" });

    return res.status(StatusCodes.OK).json({ msg: "Login success", token, name, userid, role });
  } catch (error) {
    console.error("Login error:", error.message, error.stack);
    return res
      .status(StatusCodes.INTERNAL_SERVER_ERROR)
      .json({ message: "Something went wrong, please try again later" });
  }
}

async function updateUserRoleToOrg(req, res) {
  const { userId } = req.params;
  console.log(userId);
  try {
    const [user] = await dbConnection.query(
      "SELECT id FROM users WHERE id = ?",
      [userId]
    );

    if (!user || user.length === 0) {
      return res
        .status(StatusCodes.NOT_FOUND)
        .json({ message: "User not found" });
    }

    await dbConnection.query(
      "UPDATE users SET role = ? WHERE id = ?",
      ["organization", userId]
    );

    return res
      .status(StatusCodes.OK)
      .json({ message: "User role updated to host successfully" });
  } catch (error) {
    console.error("Error updating user role to host:", error.message);
    return res
      .status(StatusCodes.INTERNAL_SERVER_ERROR)
      .json({ message: "Something went wrong, please try again later" });
  }
}

async function updateUserRoleToVolunteer(req, res) {
  const { userId } = req.params;
  console.log(userId);
  try {
    const [user] = await dbConnection.query(
      "SELECT id FROM users WHERE id = ?",
      [userId]
    );

    if (!user || user.length === 0) {
      return res
        .status(StatusCodes.NOT_FOUND)
        .json({ message: "User not found" });
    }

    await dbConnection.query(
      "UPDATE users SET role = ? WHERE id = ?",
      ["volunteer", userId]
    );

    return res
      .status(StatusCodes.OK)
      .json({ message: "User role updated to host successfully" });
  } catch (error) {
    console.error("Error updating user role to host:", error.message);
    return res
      .status(StatusCodes.INTERNAL_SERVER_ERROR)
      .json({ message: "Something went wrong, please try again later" });
  }
}

async function getAllUsers(req, res) {
  try {
    const [users] = await dbConnection.query(
      "SELECT id, name, email, role FROM users"
    );

    if (users.length === 0) {
      return res
        .status(StatusCodes.NOT_FOUND)
        .json({ message: "No users found" });
    }

    return res.status(StatusCodes.OK).json({ users });
  } catch (error) {
    console.error("Error fetching users:", error.message);
    return res
      .status(StatusCodes.INTERNAL_SERVER_ERROR)
      .json({ message: "Something went wrong, please try again later" });
  }
}

async function deleteUser(req, res) {
  const { id } = req.params;

  try {
    const [user] = await dbConnection.query(
      "SELECT id FROM users WHERE id = ?",
      [id]
    );

    if (user.length === 0) {
      return res
        .status(StatusCodes.NOT_FOUND)
        .json({ message: "User not found" });
    }

    await dbConnection.query("DELETE FROM users WHERE id = ?", [id]);

    return res
      .status(StatusCodes.OK)
      .json({ message: "User deleted successfully" });
  } catch (error) {
    console.error("Error deleting user:", error.message);
    return res
      .status(StatusCodes.INTERNAL_SERVER_ERROR)
      .json({ message: "Something went wrong, please try again later" });
  }
}

async function checkUser(req, res) {
  const name = req.user.name;
  const userid = req.user.userid;
  res.status(StatusCodes.OK).json({ message: "valid user", name, userid });
}

module.exports = {
  register,
  login,
  checkUser,
  editUser,
  updateUserRoleToVolunteer,
  updateUserRoleToOrg,
  getAllUsers,
  deleteUser,
};
