CREATE TABLE Organizations (
    organization_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    website VARCHAR(255),
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('volunteer', 'org_admin') DEFAULT 'volunteer',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Volunteer_Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    organization_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255),
    start_time DATETIME,
    end_time DATETIME,
    is_recurring BOOLEAN DEFAULT FALSE,
    recurrence_pattern VARCHAR(50),
    requirements TEXT,
    benefits TEXT,
    signup_deadline DATETIME,
    file_url VARCHAR(255),
    status ENUM('open', 'closed', 'draft') DEFAULT 'open',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (organization_id) REFERENCES Organizations(organization_id)
);

CREATE TABLE Signups (
    signup_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    signup_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'confirmed', 'cancelled') DEFAULT 'pending',
    FOREIGN KEY (post_id) REFERENCES Volunteer_Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


    -- Unique ID for each organization, auto-incremented
    -- Name of the organization, required
    -- Brief mission or purpose of the organization
    -- Optional URL to the organization’s website
    -- Email for inquiries
    -- Optional phone number for contact
    -- Timestamp when the organization was added
    -- Unique ID for each user, auto-incremented
    -- Unique username for the user, required
    -- User’s email, required and unique
    -- Hashed password for security, required
    -- Role of the user, either volunteer or org_admin, defaults to volunteer
    -- Timestamp when the user registered
    -- Unique ID for each volunteer post, auto-incremented
    -- ID of the organization posting the opportunity, links to Organizations table
    -- Headline of the post, required (e.g., "Be a Mentor for Teens")
    -- Detailed description of the role and its impact, required
    -- Physical address or "Remote" for the opportunity
    -- Date and time the opportunity starts
    -- Date and time the opportunity ends, optional for ongoing roles
    -- Indicates if the opportunity repeats, defaults to false
    -- Pattern for recurring events, e.g., "Weekly on Tuesdays", optional
    -- Skills or qualifications needed for the role
    -- Benefits or incentives for volunteers (e.g., "Earn service hours")
    -- Last date to sign up, optional
    -- URL to an image or file for the post (e.g., stored in cloud storage), optional
    -- Status of the post, defaults to open (options: open, closed, draft)
    -- Timestamp when the post was created
    -- Timestamp of the last update to the post
    -- Foreign key linking to the Organizations table
    -- Unique ID for each signup, auto-incremented
    -- ID of the volunteer post, links to Volunteer_Posts table
    -- ID of the user signing up, links to Users table
    -- Timestamp when the user signed up
    -- Status of the signup, defaults to pending (options: pending, confirmed, cancelled)
    -- Foreign key linking to the Volunteer_Posts table
    -- Foreign key linking to the Users table