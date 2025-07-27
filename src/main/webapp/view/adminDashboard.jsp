<%@ page session="true" import="model.User" %>
<%@ page import="dao.DepartmentDAO, dao.DoctorDAO, dao.UserDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Department, model.Doctor, model.User, model.DoctorAvailability" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    DepartmentDAO deptDao = new DepartmentDAO();
    DoctorDAO docDao = new DoctorDAO();
    UserDAO userDao = new UserDAO();
    List<Department> departments = deptDao.getAllDepartments();
    List<Doctor> doctors = docDao.getAllDoctors();
    List<User> patients = userDao.getAllPatients();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - MediHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="view/admin.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="dashboard-wrapper">
        <!-- Sidebar -->
        <aside class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <i class="fas fa-hospital-alt sidebar-logo-icon"></i>
                <span class="sidebar-logo-text">MediHub</span>
                <button class="sidebar-toggle-btn" onclick="toggleSidebar()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <nav class="sidebar-nav">
                <div class="sidebar-group">
                    <div class="sidebar-group-label">Main</div>
                    <ul>
                        <li class="sidebar-menu-item active">
                            <a href="#overview" class="sidebar-menu-button" onclick="showSection('overview')">
                                <i class="fas fa-tachometer-alt"></i>
                                <span>Dashboard</span>
                            </a>
                        </li>
                        <li class="sidebar-menu-item">
                            <a href="#patients" class="sidebar-menu-button" onclick="showSection('patients')">
                                <i class="fas fa-users"></i>
                                <span>Patients</span>
                            </a>
                        </li>
                        <li class="sidebar-menu-item">
                            <a href="#doctors" class="sidebar-menu-button" onclick="showSection('doctors')">
                                <i class="fas fa-user-md"></i>
                                <span>Doctors</span>
                            </a>
                        </li>
                        <li class="sidebar-menu-item">
                            <a href="#departments" class="sidebar-menu-button" onclick="showSection('departments')">
                                <i class="fas fa-building"></i>
                                <span>Departments</span>
                            </a>
                        </li>
                    </ul>
                </div>
                
                <div class="sidebar-group">
                    <div class="sidebar-group-label">Management</div>
                    <ul>
                        <li class="sidebar-menu-item">
                            <a href="#add-doctor" class="sidebar-menu-button" onclick="showSection('add-doctor')">
                                <i class="fas fa-plus-circle"></i>
                                <span>Add Doctor</span>
                            </a>
                        </li>
                        <li class="sidebar-menu-item">
                            <a href="<%= request.getContextPath() %>/view/appointments.jsp" class="sidebar-menu-button">
                                <i class="fas fa-calendar-check"></i>
                                <span>Appointments</span>
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="main-content" id="mainContent">
            <!-- Top Navigation -->
            <div class="top-navbar">
                <div class="search-bar">
                    <i class="fas fa-search search-icon"></i>
                    <input type="text" class="search-input" placeholder="Search...">
                </div>
                
                <div class="top-nav-right">
                   
                    
                    <div class="user-profile">
                        
                        <div class="user-info">
                            <span class="user-name"><%= user.getName() %></span>
                            <span class="user-status">Administrator</span>
                        </div>
                        <a href="<%= request.getContextPath() %>/logout" class="logout-link-top">
                            <i class="fas fa-sign-out-alt"></i>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Dashboard Content -->
            <div class="dashboard-content-area">
                <%
                    String msg = (String) session.getAttribute("msg");
                    String errorMsg = (String) session.getAttribute("errorMsg");
                    if (msg != null) {
                %>
                    <div class="message-box success">
                        <%= msg %>
                    </div>
                <%
                        session.removeAttribute("msg");
                    }
                    if (errorMsg != null) {
                %>
                    <div class="message-box error">
                        <%= errorMsg %>
                    </div>
                <%
                        session.removeAttribute("errorMsg");
                    }
                %>

                <!-- Overview Section -->
                <div id="overview" class="content-section active">
                    <div class="overview-cards-grid">
                        <div class="overview-card">
                            <div class="card-indicator blue"></div>
                            <div class="card-content">
                                <span class="card-date">Total Count</span>
                                <h3 class="card-title"><%= doctors.size() %></h3>
                                <p class="card-subtitle">Registered Doctors</p>
                            </div>
                        </div>
                        
                        <div class="overview-card">
                            <div class="card-indicator red"></div>
                            <div class="card-content">
                                <span class="card-date">Total Count</span>
                                <h3 class="card-title"><%= departments.size() %></h3>
                                <p class="card-subtitle">Active Departments</p>
                            </div>
                        </div>
                        
                        <div class="overview-card">
                            <div class="card-indicator orange"></div>
                            <div class="card-content">
                                <span class="card-date">Total Count</span>
                                <h3 class="card-title"><%= patients.size() %></h3>
                                <p class="card-subtitle">Registered Patients</p>
                            </div>
                        </div>
                        
                        
                    </div>

                    <div class="main-dashboard-grid">
                        <div class="dashboard-card profile-card">
                            <div class="card-header">
                                <h4>Admin Profile</h4>
                            </div>
                            
                            <h3 class="profile-name"><%= user.getName() %></h3>
                            <p class="profile-title">System Administrator</p>
                            <p class="profile-description">Managing the MediHub healthcare system with full administrative privileges.</p>
                            
                            
                            <div class="profile-stats">
                                <div class="stat-item">
                                    <span class="stat-value"><%= doctors.size() %></span>
                                    <span class="stat-label">Doctors</span>
                                </div>
                                <div class="stat-item">
                                    <span class="stat-value"><%= patients.size() %></span>
                                    <span class="stat-label">Patients</span>
                                </div>
                                <div class="stat-item">
                                    <span class="stat-value"><%= departments.size() %></span>
                                    <span class="stat-label">Departments</span>
                                </div>
                            </div>
                        </div>

                        
                    </div>
                </div>

                <!-- Patients Section -->
                <div id="patients" class="content-section">
                    <div class="dashboard-card full-width-card">
                        <div class="card-header">
                            <h2>Registered Patients</h2>
                        </div>
                        <table>
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Update</th>
                                    <th>Delete</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    int p = 1;
                                    for (User patient : patients) {
                                %>
                                <tr>
                                    <form action="<%= request.getContextPath() %>/updatePatient" method="post">
                                        <td data-label="#"><%= p++ %></td>
                                        <td data-label="Name"><input type="text" name="name" value="<%= patient.getName() %>" required></td>
                                        <td data-label="Email"><input type="email" name="email" value="<%= patient.getEmail() %>" required></td>
                                        <td data-label="Update">
                                            <input type="hidden" name="id" value="<%= patient.getId() %>">
                                            <button type="submit" class="btn btn-primary">Update</button>
                                        </td>
                                    </form>
                                    <td data-label="Delete">
                                        <form action="<%= request.getContextPath() %>/deletePatient" method="post" onsubmit="return confirm('Delete this patient?');">
                                            <input type="hidden" name="id" value="<%= patient.getId() %>">
                                            <button type="submit" class="btn btn-danger">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Departments Section -->
                <div id="departments" class="content-section">
                    <div class="dashboard-card">
                        <div class="card-header">
                            <h2>Add Department</h2>
                        </div>
                        <form action="<%= request.getContextPath() %>/addDepartment" method="post">
                            <div class="form-group">
                                <label for="departmentName">Department Name</label>
                                <input type="text" id="departmentName" name="department" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Add Department</button>
                        </form>
                    </div>
                </div>

                <!-- Add Doctor Section -->
                <div id="add-doctor" class="content-section">
                    <div class="dashboard-card">
                        <div class="card-header">
                            <h2>Add Doctor with Availability</h2>
                        </div>
                        <form action="<%= request.getContextPath() %>/addDoctor" method="post">
                            <div class="form-group">
                                <label for="doctorName">Name</label>
                                <input type="text" id="doctorName" name="name" required>
                            </div>
                            <div class="form-group">
                                <label for="doctorEmail">Email</label>
                                <input type="email" id="doctorEmail" name="email" required>
                            </div>
                            <div class="form-group">
                                <label for="doctorDepartment">Department</label>
                                <select id="doctorDepartment" name="departmentId" required>
                                    <% for (Department d : departments) { %>
                                        <option value="<%= d.getId() %>"><%= d.getName() %></option>
                                    <% } %>
                                </select>
                            </div>
                            <h3>Availability Slots</h3>
                            <div id="availability-section">
                                <div class="availability-group">
                                    <div class="form-group">
                                        <label for="dayOfWeek1">Day of Week</label>
                                        <select id="dayOfWeek1" name="dayOfWeek" required>
                                            <option value="">Select Day</option>
                                            <option>Monday</option>
                                            <option>Tuesday</option>
                                            <option>Wednesday</option>
                                            <option>Thursday</option>
                                            <option>Friday</option>
                                            <option>Saturday</option>
                                            <option>Sunday</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label for="startTime1">Start Time</label>
                                        <input type="time" id="startTime1" name="startTime" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="endTime1">End Time</label>
                                        <input type="time" id="endTime1" name="endTime" required>
                                    </div>
                                </div>
                            </div>
                            <button type="button" onclick="addAvailability()" class="btn btn-secondary" style="margin-top: 15px;">+ Add More Availability</button><br><br>
                            <button type="submit" class="btn btn-primary">Add Doctor</button>
                        </form>
                    </div>
                </div>

                <!-- Doctors Section -->
                <div id="doctors" class="content-section">
                    <div class="dashboard-card full-width-card">
                        <div class="card-header">
                            <h2>Doctors & Availability</h2>
                        </div>
                        <table>
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Department</th>
                                    <th>Update</th>
                                    <th>Delete</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    int i = 1;
                                    for (Doctor d : doctors) {
                                %>
                                <tr>
                                    <td data-label="#"><%= i++ %></td>
                                    <form action="<%= request.getContextPath() %>/updateDoctor" method="post">
                                        <td data-label="Name"><input type="text" name="name" value="<%= d.getName() %>" required></td>
                                        <td data-label="Email"><input type="email" name="email" value="<%= d.getEmail() %>" required></td>
                                        <td data-label="Department">
                                            <select name="departmentId">
                                                <% for (Department dept : departments) { %>
                                                    <option value="<%= dept.getId() %>" <%= dept.getName().equals(d.getDepartmentName()) ? "selected" : "" %>>
                                                        <%= dept.getName() %>
                                                    </option>
                                                <% } %>
                                            </select>
                                        </td>
                                        <td data-label="Update">
                                            <input type="hidden" name="id" value="<%= d.getId() %>">
                                            <button type="submit" class="btn btn-primary">Update</button>
                                        </td>
                                    </form>
                                    <td data-label="Delete">
                                        <form action="<%= request.getContextPath() %>/deleteDoctor" method="get" onsubmit="return confirm('Delete doctor and all their availability?');">
                                            <input type="hidden" name="id" value="<%= d.getId() %>">
                                            <button type="submit" class="btn btn-danger">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                                <% if (d.getAvailabilityList() != null && !d.getAvailabilityList().isEmpty()) { %>
                                    <tr>
                                        <td colspan="6" class="nested-table-cell">
                                            <strong>Availability:</strong>
                                            <table class="nested-table">
                                                <thead>
                                                    <tr>
                                                        <th>Day</th>
                                                        <th>Start Time</th>
                                                        <th>End Time</th>
                                                        <th>Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <% for (DoctorAvailability av : d.getAvailabilityList()) { %>
                                                        <tr>
                                                            <form action="<%= request.getContextPath() %>/updateAvailability" method="post">
                                                                <td data-label="Day"><input type="text" name="dayOfWeek" value="<%= av.getDayOfWeek() %>" required></td>
                                                                <td data-label="Start Time"><input type="time" name="startTime" value="<%= av.getStartTime() %>" required></td>
                                                                <td data-label="End Time"><input type="time" name="endTime" value="<%= av.getEndTime() %>" required></td>
                                                                <td data-label="Action">
                                                                    <input type="hidden" name="availabilityId" value="<%= av.getId() %>">
                                                                    <button type="submit" class="btn btn-primary">Update</button>
                                                                    <a href="<%= request.getContextPath() %>/deleteAvailability?id=<%= av.getId() %>" onclick="return confirm('Delete this slot?');" class="btn btn-danger">Delete</a>
                                                                </td>
                                                            </form>
                                                        </tr>
                                                    <% } %>
                                                </tbody>
                                            </table>
                                        </td>
                                    </tr>
                                <% } %>
                                <tr>
                                    <td colspan="6" class="nested-table-cell">
                                        <button type="button" onclick="toggleAddAvailabilityForm('add-availability-form-<%= d.getId() %>')" class="btn btn-secondary" style="margin-bottom: 15px;">+ Add New Availability Slot</button>
                                        <div id="add-availability-form-<%= d.getId() %>" style="display: none;">
                                            <strong>Add New Availability Slot:</strong>
                                            <form action="<%= request.getContextPath() %>/addAvailability" method="post" style="margin-top:10px;">
                                                <input type="hidden" name="doctorId" value="<%= d.getId() %>">
                                                <div class="form-group">
                                                    <label>Day</label>
                                                    <select name="dayOfWeek" required>
                                                        <option value="">Select Day</option>
                                                        <option>Monday</option>
                                                        <option>Tuesday</option>
                                                        <option>Wednesday</option>
                                                        <option>Thursday</option>
                                                        <option>Friday</option>
                                                        <option>Saturday</option>
                                                        <option>Sunday</option>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label>Start Time</label>
                                                    <input type="time" name="startTime" required>
                                                </div>
                                                <div class="form-group">
                                                    <label>End Time</label>
                                                    <input type="time" name="endTime" required>
                                                </div>
                                                <button type="submit" class="btn btn-primary">Add Slot</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>

  
    <script>
        let availabilityGroupCounter = 1;

        // Sidebar toggle functionality
        function toggleSidebar() {
            const sidebar = document.getElementById('sidebar');
            const mainContent = document.getElementById('mainContent');
            sidebar.classList.toggle('collapsed');
            mainContent.classList.toggle('sidebar-collapsed');
        }

        // Section navigation
        function showSection(sectionId) {
            // Hide all sections
            const sections = document.querySelectorAll('.content-section');
            sections.forEach(section => section.classList.remove('active'));
            
            // Show selected section
            document.getElementById(sectionId).classList.add('active');
            
            // Update sidebar active state
            const menuItems = document.querySelectorAll('.sidebar-menu-item');
            menuItems.forEach(item => item.classList.remove('active'));
            
            // Find and activate the corresponding menu item
            const activeLink = document.querySelector(`[onclick="showSection('${sectionId}')"]`);
            if (activeLink) {
                activeLink.closest('.sidebar-menu-item').classList.add('active');
            }
        }

        // Function for "Add Doctor" section to add multiple availability fields
        function addAvailability() {
            availabilityGroupCounter++;
            const section = document.getElementById("availability-section");
            const newGroup = document.createElement("div");
            newGroup.className = "availability-group";
            newGroup.innerHTML = `
                <div class="form-group">
                    <label for="dayOfWeek${availabilityGroupCounter}">Day of Week</label>
                    <select id="dayOfWeek${availabilityGroupCounter}" name="dayOfWeek" required>
                        <option value="">Select Day</option>
                        <option>Monday</option>
                        <option>Tuesday</option>
                        <option>Wednesday</option>
                        <option>Thursday</option>
                        <option>Friday</option>
                        <option>Saturday</option>
                        <option>Sunday</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="startTime${availabilityGroupCounter}">Start Time</label>
                    <input type="time" id="startTime${availabilityGroupCounter}" name="startTime" required>
                </div>
                <div class="form-group">
                    <label for="endTime${availabilityGroupCounter}">End Time</label>
                    <input type="time" id="endTime${availabilityGroupCounter}" name="endTime" required>
                </div>
                <button type="button" onclick="removeAvailability(this)" class="btn btn-danger" style="width: auto;">Remove</button>
            `;
            section.appendChild(newGroup);
        }

        // Function to remove dynamically added availability fields
        function removeAvailability(button) {
            button.closest('.availability-group').remove();
        }

        // Updated function to toggle visibility of "Add New Availability Slot" form for existing doctors
        function toggleAddAvailabilityForm(formId) {
            const formDiv = document.getElementById(formId);
            if (formDiv.style.display === 'none' || formDiv.style.display === '') {
                formDiv.style.display = 'block';
            } else {
                formDiv.style.display = 'none';
            }
        }

        // Mobile sidebar toggle
        document.addEventListener('DOMContentLoaded', function() {
            const sidebarToggle = document.querySelector('.sidebar-toggle-btn');
            if (sidebarToggle) {
                sidebarToggle.addEventListener('click', toggleSidebar);
            }
            // Initialize the dashboard to show the overview section
            showSection('overview');
        });
    </script>

    <style>
        /* These styles are for the dynamic section display */
        .content-section {
            display: none;
        }
        
        .content-section.active {
            display: block;
        }
        
        .full-width-card {
            grid-column: 1 / -1;
        }
        
        @media (max-width: 992px) {
            .main-dashboard-grid {
                grid-template-columns: 1fr;
            }
        }
        
        /* Global box-sizing reset */
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: "Inter", -apple-system, BlinkMacSystemFont, sans-serif;
  line-height: 1.6;
  color: #333;
  background-color: #f0f2f5; /* Light background for the entire page */
  overflow-x: hidden; /* Prevent horizontal scroll */
}

/* Dashboard Layout */
.dashboard-wrapper {
  display: flex;
  min-height: 100vh;
  background-color: #f0f2f5; /* Background for the main content area */
}

/* Sidebar */
.sidebar {
  width: 250px; /* Fixed width for sidebar */
  background-color: #347dc4; /* Blue theme for sidebar */
  color: white;
  flex-shrink: 0;
  box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
  transition: width 0.3s ease, transform 0.3s ease;
  position: sticky; /* Make sidebar sticky */
  top: 0;
  height: 100vh; /* Full height */
  overflow-y: auto; /* Enable scrolling for long sidebars */
  z-index: 1000; /* Ensure it's above other content */
}

.sidebar.collapsed {
  width: 0; /* Collapse sidebar on mobile */
  transform: translateX(-100%);
}

.sidebar-header {
  display: flex;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  gap: 10px;
}

.sidebar-logo-icon {
  font-size: 2.2rem;
  color: #ffffff; /* White for logo icon on blue background */
}

.sidebar-logo-text {
  font-family: "Poppins", sans-serif;
  font-size: 1.8rem;
  font-weight: 700;
  color: white;
}

.sidebar-toggle-btn {
  display: none; /* Hidden on desktop */
  background: none;
  border: none;
  color: white;
  font-size: 1.5rem;
  cursor: pointer;
  margin-left: auto; /* Push to the right */
}

.sidebar-nav {
  padding: 20px 0;
}

.sidebar-group {
  margin-bottom: 20px;
}

.sidebar-group-label {
  font-size: 0.75rem;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.7); /* Slightly lighter white for labels */
  text-transform: uppercase;
  padding: 10px 20px;
  margin-bottom: 10px;
}

.sidebar-nav ul {
  list-style: none;
  padding: 0;
}

.sidebar-menu-item {
  margin-bottom: 5px;
}

.sidebar-menu-button {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 12px 20px;
  color: white;
  text-decoration: none;
  font-size: 0.95rem;
  font-weight: 500;
  transition: background-color 0.2s ease, color 0.2s ease;
  border-radius: 0 25px 25px 0; /* Rounded right edge */
}

.sidebar-menu-button i {
  font-size: 1.1rem;
  width: 20px; /* Fixed width for icons */
  text-align: center;
}

.sidebar-menu-button .sidebar-arrow {
  margin-left: auto; /* Push arrow to the right */
  font-size: 0.8rem;
}

.sidebar-menu-item.active .sidebar-menu-button,
.sidebar-menu-button:hover {
  background-color: #e6f2ff; /* Light blue background for active/hover */
  color: #347dc4; /* Blue text for active/hover */
}

.sidebar-menu-item.active .sidebar-menu-button i,
.sidebar-menu-button:hover i {
  color: #347dc4; /* Blue icon for active/hover */
}

/* Main Content Area */
.main-content {
  flex-grow: 1;
  padding: 30px;
  transition: margin-left 0.3s ease;
}

/* Top Navigation Bar */
.top-navbar {
  background-color: white;
  padding: 20px 30px;
  border-radius: 12px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
  flex-wrap: wrap;
  gap: 20px;
}

.search-bar {
  position: relative;
  flex-grow: 1;
  max-width: 400px;
}

.search-input {
  width: 100%;
  padding: 12px 15px 12px 40px; /* Left padding for icon */
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  font-size: 0.95rem;
  color: #333;
  background-color: #f8f8f8;
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

.search-input:focus {
  outline: none;
  border-color: #4a90e2;
  box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
}

.search-icon {
  position: absolute;
  left: 15px;
  top: 50%;
  transform: translateY(-50%);
  color: #999;
  font-size: 1rem;
}

.top-nav-right {
  display: flex;
  align-items: center;
  gap: 25px;
}

.language-dropdown {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 0.95rem;
  color: #555;
  cursor: pointer;
}

.flag-icon {
  width: 20px;
  height: auto;
  border-radius: 2px;
}

.top-nav-icon {
  font-size: 1.1rem;
  color: #555;
  cursor: pointer;
  transition: color 0.2s ease;
}

.top-nav-icon:hover {
  color: #4a90e2;
}

.user-profile {
  display: flex;
  align-items: center;
  gap: 10px;
  background-color: #e6f2ff; /* Light blue background for profile */
  padding: 8px 15px;
  border-radius: 25px;
}

.user-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  object-fit: cover;
}

.user-info {
  display: flex;
  flex-direction: column;
  line-height: 1.2;
}

.user-name {
  font-weight: 600;
  color: #347dc4; /* Blue text */
  font-size: 0.9rem;
}

.user-status {
  font-size: 0.75rem;
  color: #5a9ee6; /* Slightly lighter blue */
}

.logout-link-top {
  color: #347dc4;
  font-size: 0.9rem;
  margin-left: 10px;
  text-decoration: none;
  transition: color 0.2s ease;
}

.logout-link-top:hover {
  color: #4a90e2;
}

/* Dashboard Content Area */
.dashboard-content-area {
  padding: 0; /* No extra padding here, cards will have their own */
}

/* Overview Cards Grid */
.overview-cards-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); /* Flexible columns */
  gap: 25px;
  margin-bottom: 30px;
}

.overview-card {
  background-color: white;
  border-radius: 12px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  display: flex;
  overflow: hidden; /* Hide overflow for indicator */
}

.card-indicator {
  width: 10px; /* Vertical colored bar */
  flex-shrink: 0;
}

.card-indicator.blue {
  background-color: #4a90e2;
}

.card-indicator.red {
  background-color: #dc3545;
}

.card-indicator.orange {
  background-color: #fd7e14;
}

.overview-card .card-content {
  padding: 20px;
  flex-grow: 1;
}

.overview-card .card-date {
  font-size: 0.8rem;
  color: #999;
  margin-bottom: 5px;
  display: block;
}

.overview-card .card-title {
  font-size: 1.2rem;
  font-weight: 600;
  color: #333;
  margin-bottom: 5px;
}

.overview-card .card-subtitle {
  font-size: 0.9rem;
  color: #666;
}

.overview-card.full-image-card {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0;
}

.overview-card.full-image-card .card-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 12px; /* Ensure image corners match card */
}

/* Main Dashboard Grid (for profile, chart, tables) */
.main-dashboard-grid {
  display: grid;
  grid-template-columns: 1fr 2fr; /* Profile card on left, chart on right */
  gap: 25px;
}

.dashboard-card {
  background-color: white;
  border-radius: 12px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  padding: 25px;
}

.dashboard-card .card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 1px solid #eee;
}

.dashboard-card .card-header h2,
.dashboard-card .card-header h4 {
  font-size: 1.2rem;
  font-weight: 600;
  color: #333;
  margin: 0; /* Reset default margins */
  border-bottom: none; /* Remove border from h2 in card header */
  padding-bottom: 0; /* Remove padding from h2 in card header */
}

/* Profile Card */
.profile-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
}

.profile-avatar {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  object-fit: cover;
  margin-bottom: 20px;
  border: 4px solid #e6f2ff; /* Light blue border */
}

.profile-name {
  font-size: 1.5rem;
  font-weight: 700;
  color: #333;
  margin-bottom: 5px;
}

.profile-title {
  font-size: 0.95rem;
  color: #666;
  margin-bottom: 15px;
}

.profile-description {
  font-size: 0.9rem;
  color: #777;
  margin-bottom: 25px;
  max-width: 250px;
}

.btn-assign {
  background-color: #e6f2ff; /* Light blue background */
  color: #347dc4; /* Blue text */
  padding: 10px 25px;
  border-radius: 20px;
  font-weight: 600;
  font-size: 0.9rem;
  transition: background-color 0.2s ease, color 0.2s ease;
}

.btn-assign:hover {
  background-color: #347dc4;
  color: white;
}

.profile-stats {
  display: flex;
  justify-content: space-around;
  width: 100%;
  margin-top: 30px;
  padding-top: 20px;
  border-top: 1px solid #eee;
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.stat-value {
  font-size: 1.5rem;
  font-weight: 700;
  color: #4a90e2; /* Blue accent */
  margin-bottom: 5px;
}

.stat-label {
  font-size: 0.8rem;
  color: #777;
  text-transform: uppercase;
}

/* Health Curve Card */
.health-curve-card .chart-controls {
  display: flex;
  gap: 15px;
  color: #999;
  font-size: 1rem;
}

.health-curve-card .chart-controls i {
  cursor: pointer;
  transition: color 0.2s ease;
}

.health-curve-card .chart-controls i:hover {
  color: #4a90e2;
}

.chart-placeholder {
  min-height: 250px; /* Ensure space for the chart */
  background-color: #f8f8f8; /* Light background for chart area */
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden; /* Ensure image fits */
}

/* Full Width Card (for tables) */
.full-width-card {
  grid-column: 1 / -1; /* Span across all columns */
}

/* General Table Styling (adapted for dashboard cards) */
table {
  width: 100%;
  border-collapse: separate;
  border-spacing: 0;
  margin-top: 0; /* Remove top margin as it's inside a card */
  background-color: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: none; /* Remove shadow as card has it */
  border: 1px solid #e9ecef; /* Consistent border */
}

th,
td {
  padding: 14px 15px;
  text-align: left;
  border-bottom: 1px solid #f1f1f1;
}

th {
  background-color: #f8f8f8; /* Lighter header background */
  color: #555; /* Darker text for headers */
  font-weight: 600;
  text-transform: uppercase;
  font-size: 0.85rem;
}

tr:last-child td {
  border-bottom: none;
}

tbody tr:hover {
  background-color: #fcfcfc; /* Very light hover effect */
}

/* Specific table input/select styling */
table input[type="text"],
table input[type="email"],
table input[type="time"],
table select {
  width: 100%;
  padding: 8px 10px;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 0.9rem;
  background-color: #ffffff;
}

table button {
  padding: 8px 12px;
  font-size: 0.85rem;
  border-radius: 6px;
  margin-right: 5px;
}

table a.btn-danger {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 8px 12px;
  font-size: 0.85rem;
  border-radius: 6px;
  background-color: #dc3545;
  color: white;
  text-decoration: none;
  transition: all 0.3s ease;
}

table a.btn-danger:hover {
  background-color: #c82333;
  transform: translateY(-1px);
}

/* Form Group Styling (adapted for dashboard cards) */
.form-group {
  margin-bottom: 18px;
  text-align: left;
}

.form-group label {
  display: block;
  font-size: 0.9rem;
  font-weight: 500;
  color: #495057;
  margin-bottom: 8px;
}

.form-group input[type="text"],
.form-group input[type="email"],
.form-group input[type="password"],
.form-group input[type="time"],
.form-group select {
  width: 100%;
  padding: 12px 15px;
  border: 1px solid #e0e0e0; /* Lighter border */
  border-radius: 8px;
  font-size: 1rem;
  color: #495057;
  transition: border-color 0.3s ease, box-shadow 0.3s ease;
  background-color: #f8f8f8; /* Light background for inputs */
}

.form-group input:focus,
.form-group select:focus {
  outline: none;
  border-color: #4a90e2;
  box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
}

/* Buttons (adapted for dashboard cards) */
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.8rem 1.6rem;
  font-size: 0.95rem;
  font-weight: 600;
  border-radius: 8px;
  transition: all 0.3s ease;
  cursor: pointer;
  border: none;
  text-decoration: none;
}

.btn-primary {
  background: linear-gradient(45deg, #4a90e2, #6a5acd);
  color: white;
  box-shadow: 0 3px 10px rgba(74, 144, 226, 0.3);
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(74, 144, 226, 0.4);
}

.btn-danger {
  background-color: #dc3545;
  color: white;
  box-shadow: 0 3px 10px rgba(220, 53, 69, 0.3);
}

.btn-danger:hover {
  background-color: #c82333;
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(220, 53, 69, 0.4);
}

.btn-secondary {
  background-color: #6c757d;
  color: white;
  box-shadow: 0 3px 10px rgba(108, 117, 125, 0.3);
}

.btn-secondary:hover {
  background-color: #5a6268;
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(108, 117, 125, 0.4);
}

.btn-sm {
  padding: 0.5rem 1rem;
  font-size: 0.8rem;
  border-radius: 6px;
}

/* Add spacing and centering for buttons that might appear directly after a form group */
.form-group + .btn,
.form-group + button {
  margin-top: 15px;
  display: block;
  margin-left: auto;
  margin-right: auto;
  width: fit-content;
}

/* Doctor Availability Section (for Add Doctor form) */
#availability-section {
  margin-top: 20px;
  border: 1px dashed #d0d0d0;
  padding: 20px;
  border-radius: 8px;
  background-color: #fcfcfc;
}

.availability-group {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 15px;
  margin-bottom: 15px;
  align-items: end;
  padding-bottom: 15px;
  border-bottom: 1px dashed #eee;
}

.availability-group:last-child {
  border-bottom: none;
  margin-bottom: 0;
  padding-bottom: 0;
}

.availability-group .form-group {
  margin-bottom: 0;
}

/* Message Box Styles */
.message-box {
  padding: 15px 20px;
  border-radius: 8px;
  margin-bottom: 25px;
  font-size: 0.95rem;
  font-weight: 500;
  text-align: left;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
}

.message-box.success {
  background-color: #d4edda;
  color: #155724;
  border: 1px solid #c3e6cb;
}

.message-box.info {
  background-color: #e2e3e5;
  color: #383d41;
  border: 1px solid #d6d8db;
}

.message-box.error {
  background-color: #f8d7da;
  color: #721c24;
  border: 1px solid #f5c6cb;
}

/* Floating Settings Button */
.floating-settings-btn {
  position: fixed;
  right: 20px;
  top: 50%;
  transform: translateY(-50%);
  background-color: #fd7e14; /* Orange color from screenshot */
  color: white;
  width: 50px;
  height: 50px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  box-shadow: 0 5px 15px rgba(253, 126, 20, 0.4);
  border: none;
  cursor: pointer;
  z-index: 999;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.floating-settings-btn:hover {
  transform: translateY(-50%) scale(1.05);
  box-shadow: 0 8px 20px rgba(253, 126, 20, 0.6);
}

/* Responsive Adjustments */
@media (max-width: 992px) {
  .sidebar {
    position: fixed; /* Make sidebar truly fixed for mobile overlay */
    height: 100vh;
    width: 250px;
    transform: translateX(0); /* Show by default */
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.2);
  }
  .sidebar.collapsed {
    transform: translateX(-100%); /* Hide when collapsed */
  }
  .sidebar-toggle-btn {
    display: block; /* Show toggle button on mobile */
  }
  .main-content {
    margin-left: 0; /* No margin on mobile, sidebar overlays */
    padding: 20px;
  }
  .main-content.sidebar-collapsed {
    /* No specific style needed here, as sidebar overlays */
  }
  .top-navbar {
    padding: 15px 20px;
    flex-direction: column;
    align-items: flex-start;
    gap: 15px;
  }
  .search-bar {
    width: 100%;
    max-width: none;
  }
  .top-nav-right {
    width: 100%;
    justify-content: space-between;
    gap: 10px;
  }
  .user-profile {
    padding: 5px 10px;
  }
  .overview-cards-grid {
    grid-template-columns: 1fr; /* Stack overview cards */
    gap: 20px;
  }
  .main-dashboard-grid {
    grid-template-columns: 1fr; /* Stack main dashboard sections */
    gap: 20px;
  }
  .dashboard-card {
    padding: 20px;
  }
  .dashboard-card .card-header h2,
  .dashboard-card .card-header h4 {
    font-size: 1.1rem;
  }
  /* Table responsiveness for smaller screens */
  table {
    display: block;
    width: 100%;
    overflow-x: auto; /* Allow horizontal scroll for tables */
    white-space: nowrap; /* Prevent content from wrapping */
  }
  th,
  td {
    display: table-cell; /* Revert to table-cell for horizontal scroll */
    width: auto; /* Allow cells to size naturally */
    min-width: 100px; /* Ensure minimum width for readability */
  }
  thead {
    display: table-header-group; /* Show table header */
  }
  tr {
    display: table-row; /* Show table rows */
    margin-bottom: 0;
    border: none;
    box-shadow: none;
  }
  td:before {
    content: none; /* Hide data-label on mobile tables */
  }
  /* Specific adjustments for nested tables (availability) */
  table .nested-table-cell {
    padding: 10px;
  }
  table .nested-table {
    box-shadow: none;
    border: none;
    margin-top: 10px;
    background-color: #fcfcfc;
  }
  table .nested-table th,
  table .nested-table td {
    padding: 8px 10px;
    font-size: 0.9rem;
  }
  table .nested-table tr {
    margin-bottom: 0;
    border: none;
  }
}

@media (max-width: 576px) {
  .sidebar {
    width: 220px; /* Slightly smaller sidebar on very small screens */
  }
  .main-content {
    padding: 15px;
  }
  .top-navbar {
    padding: 10px 15px;
  }
  .search-input {
    padding: 10px 15px 10px 35px;
    font-size: 0.85rem;
  }
  .search-icon {
    left: 10px;
    font-size: 0.9rem;
  }
  .top-nav-right {
    flex-wrap: wrap;
    justify-content: center;
    gap: 10px;
  }
  .language-dropdown,
  .top-nav-icon {
    font-size: 0.85rem;
  }
  .user-profile {
    padding: 5px 10px;
  }
  .user-name {
    font-size: 0.8rem;
  }
  .user-status {
    font-size: 0.7rem;
  }
  .floating-settings-btn {
    width: 40px;
    height: 40px;
    font-size: 1.2rem;
    right: 10px;
  }
}
        
    </style>
</body>
</html>
