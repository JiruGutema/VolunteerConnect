# VolunteerConnect

## Project Overview
VolunteerConnect is a local volunteering hub that connects volunteers with organizations seeking assistance. The platform allows organizations to post volunteer opportunities, and users can browse and apply for them. This project includes a REST API backend, authentication, and a mobile frontend built with Jetpack Compose and Flutter.

## 👥 Team Members
| Full Name        |   Student ID   | Section
|------------------|----------------|--------
| Jiru Gutema      |  UGR/5902/15   |    4
| Abigiya Daniel   |  UGR/5110/15   |    4
| Ashenafi Godana  |  UGR/7906/14   |    4
| Blen Debebe      |  UGR/5297/15   |    4
| Anansi Sime      |  UGR/9691/15   |    2

## Features
### 1. Volunteer Opportunities (CRUD)
- Organizations can **Create, Read, Update, and Delete** volunteer opportunities.
- Volunteers can view available events and apply.

### 2. Volunteer Applications (CRUD)
- Volunteers can **Apply, View, Update, and Cancel** their applications.
- Organizations can manage applications for their events.

### 3. Authentication & Authorization
- **User Roles:**
  - **Volunteers**: Can browse and apply for opportunities.
  - **Organizations**: Can post and manage volunteer events.
  - **Admins (Optional)**: Can manage users and events.
- Secure authentication using **JWT/OAuth**.

### 4. Backend (REST API)
- Developed using **Django**.
- Serves the mobile front end.
- Implements authentication, authorization, and CRUD operations.

### 5. Testing
- **Widget Testing** (Jetpack Compose & Flutter UI components)
- **Unit Testing** (API endpoints and logic)
- **Integration Testing** (Ensuring API and frontend work together)

## Tech Stack
### Backend
- **Django** (REST API)
- **MySQL** (Database)
- **JWT/OAuth** (Authentication)

### Frontend
- **Jetpack Compose (Kotlin)** (First mobile version)
- **Flutter (Dart)** (Recreated mobile version)


## 🛠 Backend Setup & Installation
### 1️⃣ Clone the Repository
```bash
git clone https://github.com/AshenafiTech/VolunteerConnect.git
cd VolunteerConnect
```

### 2️⃣ Create a Virtual Environment
```bash
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
```

### 3️⃣ Install Dependencies
```bash
pip install -r requirements.txt
```

### 4️⃣ Configure Environment Variables
Create a `.env` file in the root directory:
```ini
SECRET_KEY=your-secret-key
DEBUG=True
DATABASE_URL=mysql://user:password@localhost:3306/volunteerconnect
```

### 5️⃣ Apply Migrations & Start Server
```bash
python manage.py migrate
python manage.py runserver
```
Access the API at: `http://127.0.0.1:8000/`

## 📜 API Documentation
Run the server and visit `http://127.0.0.1:8000/docs/` to see the Swagger UI.