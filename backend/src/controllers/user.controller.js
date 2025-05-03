const { StatusCodes } = require("http-status-codes");
const dbConnection = require("../config/db");
const { genSalt, hash, compare } = require("bcrypt");
require("dotenv").config();
const jwt = require("jsonwebtoken");

// Register new user
async function register(req, res) {
  const { name, email, password } = req.body;
  const role = req.body.role || "volunteer"; 

  if (!email || !password || !name) {
    return res
      .status(StatusCodes.BAD_REQUEST)
      .json({ message: "All fields are required" });
  }

  if (password.length < 6) {
    return res
      .status(StatusCodes.BAD_REQUEST)
      .json({ message: "Password must be at least 6 characters" });
  }

  let connection;
  try {
    connection = await dbConnection.getConnection();
    await connection.beginTransaction();

    const [existingUser] = await connection.query(
      "SELECT email FROM users WHERE email = ?",
      [email]
    );

    if (existingUser?.length) {
      await connection.rollback();
      return res
        .status(StatusCodes.BAD_REQUEST)
        .json({ message: "Account already registered" });
    }

    const hashedPassword = await hash(password, 10);

    const [result] = await connection.query(
      "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)",
      [name, email, hashedPassword, role]
    );

    const userId = result.insertId;

    const defaultSkills = [' '];
    const defaultInterests = [' '];

    if (defaultSkills.length) {
      const skillValues = defaultSkills.map(skill => [userId, skill]);
      await connection.query(
        "INSERT INTO user_skills (user_id, skill) VALUES ?",
        [skillValues]
      );
    }

    if (defaultInterests.length) {
      const interestValues = defaultInterests.map(interest => [userId, interest]);
      await connection.query(
        "INSERT INTO user_interests (user_id, interest) VALUES ?",
        [interestValues]
      );
    }

    await connection.commit();

    const token = jwt.sign(
      { name, userId, role },
      process.env.JWT_SECRET,
      { expiresIn: "1d" }
    );

    return res.status(StatusCodes.CREATED).json({ 
      message: "Registration success", 
      token,
      user: { name, id: userId, role, email }
    });

  } catch (error) {
    if (connection) await connection.rollback();
    console.error("Registration error:", error.message);
    return res
      .status(StatusCodes.INTERNAL_SERVER_ERROR)
      .json({ message: "Registration failed, please try again" });
  } finally {
    if (connection) connection.release();
  }
}


// Login user

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

    return res.status(StatusCodes.CREATED).json({ message: "Login success", token: token, user:{ name: name, id:userid, role: role, email: email } });
  } catch (error) {
    console.error("Login error:", error.message, error.stack);
    return res
      .status(StatusCodes.INTERNAL_SERVER_ERROR)
      .json({ message: "Something went wrong, please try again later" });
  }
}

// Update user role to organization or volunteer

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


async function getUserById(req, res) {
  const { userId } = req.params;
  console.log(userId);

  try {
    const [user] = await dbConnection.query(
      "SELECT id, name, email, role FROM users WHERE id = ?",
      [userId]
    );

    if (!user || user.length === 0) {
      return res
        .status(StatusCodes.NOT_FOUND)
        .json({ message: "User not found" });
    }

    const [skills] = await dbConnection.query(
      "SELECT skill FROM user_skills WHERE user_id = ?",
      [userId]
    );

    const [interests] = await dbConnection.query(
      "SELECT interest FROM user_interests WHERE user_id = ?",
      [userId]
    );

    const userData = {
      ...user[0],
      skills: skills.map(s => s.skill),
      interests: interests.map(i => i.interest)
    };

    return res.status(StatusCodes.OK).json({ user: userData });
  } catch (error) {
    console.error("Error fetching user:", error.message);
    return res
      .status(StatusCodes.INTERNAL_SERVER_ERROR)
      .json({ message: "Something went wrong, please try again later" });
  }
}


async function updateUser(req, res) {
  const { userId } = req.params;
  const { name, email, password, city, phone, bio, skills, interests } = req.body;

  if (!name || !email || !city || !phone || !bio) {
    return res
      .status(StatusCodes.BAD_REQUEST)
      .json({ message: "Please provide all required profile information" });
  }

  let connection;
  try {
    connection = await dbConnection.getConnection();
    await connection.beginTransaction();

    const [user] = await connection.query(
      "SELECT * FROM users WHERE id = ?",
      [userId]
    );

    if (!user || user.length === 0) {
      await connection.rollback();
      return res
        .status(StatusCodes.NOT_FOUND)
        .json({ message: "User not found" });
    }

    const hashedPassword = password 
      ? await hash(password, 10) 
      : user[0].password;

    await connection.query(
      "UPDATE users SET name = ?, email = ?, password = ?, city = ?, phone = ?, bio = ? WHERE id = ?",
      [name, email, hashedPassword, city, phone, bio, userId]
    );

    await connection.query(
      "DELETE FROM user_skills WHERE user_id = ?",
      [userId]
    );

    if (skills && skills.length > 0) {
      const skillValues = skills.map(skill => [userId, skill]);
      await connection.query(
        "INSERT INTO user_skills (user_id, skill) VALUES ?",
        [skillValues]
      );
    }

    await connection.query(
      "DELETE FROM user_interests WHERE user_id = ?",
      [userId]
    );

    if (interests && interests.length > 0) {
      const interestValues = interests.map(interest => [userId, interest]);
      await connection.query(
        "INSERT INTO user_interests (user_id, interest) VALUES ?",
        [interestValues]
      );
    }

    await connection.commit();

    const [updatedUser] = await connection.query(
      "SELECT id, name, email, role, city, phone, bio FROM users WHERE id = ?",
      [userId]
    );

    const [userSkills] = await connection.query(
      "SELECT skill FROM user_skills WHERE user_id = ?",
      [userId]
    );

    const [userInterests] = await connection.query(
      "SELECT interest FROM user_interests WHERE user_id = ?",
      [userId]
    );

    const token = jwt.sign(
      { 
        name: updatedUser[0].name, 
        userid: updatedUser[0].id, 
        role: updatedUser[0].role 
      },
      process.env.JWT_SECRET,
      { expiresIn: "1d" }
    );

    return res.status(StatusCodes.OK).json({
      message: "User updated successfully",
      token,
      user: {
        id: updatedUser[0].id,
        name: updatedUser[0].name,
        email: updatedUser[0].email,
        role: updatedUser[0].role,
        city: updatedUser[0].city,
        phone: updatedUser[0].phone,
        bio: updatedUser[0].bio,
        skills: userSkills.map(s => s.skill),
        interests: userInterests.map(i => i.interest)
      }
    });

  } catch (error) {
    if (connection) await connection.rollback();
    console.error("Error updating user:", error.message);
    return res
      .status(StatusCodes.INTERNAL_SERVER_ERROR)
      .json({ message: "Something went wrong, please try again later" });
  } finally {
    if (connection) connection.release();
  }
}

async function deleteUser(req, res) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res
      .status(StatusCodes.UNAUTHORIZED)
      .json({ message: "Authorization token is required" });
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const userId = decoded.userid;

    const connection = await dbConnection.getConnection();
    await connection.beginTransaction();

    try {
      const [user] = await connection.query(
        "SELECT id FROM users WHERE id = ? FOR UPDATE",
        [userId]
      );

      if (user.length === 0) {
        await connection.rollback();
        return res
          .status(StatusCodes.NOT_FOUND)
          .json({ message: "User not found" });
      }

      await connection.query("DELETE FROM users WHERE id = ?", [userId]);

      await connection.commit();

      return res
        .status(StatusCodes.OK)
        .json({ message: "User deleted successfully" });

    } catch (error) {
      await connection.rollback();
      throw error;
    } finally {
      connection.release();
    }
    
  } catch (error) {


    if (error instanceof jwt.JsonWebTokenError) {
      return res
        .status(StatusCodes.UNAUTHORIZED)
        .json({ message: "Invalid or expired token" });
    }

    return res
      .status(StatusCodes.INTERNAL_SERVER_ERROR)
      .json({ message: "Failed to delete user, please try again later" });
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
  updateUser,
  getUserById,
  updateUserRoleToVolunteer,
  updateUserRoleToOrg,
  getAllUsers,
  deleteUser,
};