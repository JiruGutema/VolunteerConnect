// In your server file (app.js or server.js)
require("dotenv").config();
const express = require("express");
const path = require('path');

const app = express();
const port = process.env.PORT || 5500;
const cors = require("cors");
app.use(express.json());
app.use(cors());
app.use(express.urlencoded({ extended: true }));
app.use("/uploads", express.static(path.join(__dirname, "./src/uploads")));


// Fixed route path
const userRoutes = require("./src/routes/user.routes")
app.use("/api", userRoutes); // Should start with "/api/admin"


// Starting the server and database connection
async function start() {
  try {
    // const result = await dbConnection.execute("select 'test' ");
    app.listen(port, () => {
      console.log(`Listening on port http://localhost:${port}`);
    });
    console.log("Database connection established");
  } catch (error) {
    console.log(error.message);
  }
}
start();
