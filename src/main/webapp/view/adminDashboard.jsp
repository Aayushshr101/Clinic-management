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
    <title>Admin Dashboard - MediTrackPro</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="admin.css"> <!-- Link to the new admin.css -->
    <!-- Font Awesome for icons (if needed, ensure it's linked) -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <header class="admin-header">
        <h1>Welcome, <%= user.getName() %></h1>
        <a href="<%= request.getContextPath() %>/logout" class="logout-link">Logout <i class="fas fa-sign-out-alt"></i></a>
    </header>

    <div class="container">
        <%
            String msg = (String) session.getAttribute("msg");
            String errorMsg = (String) session.getAttribute("errorMsg"); // Assuming you might set an error message
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

        <div class="section clinic-overview">
            <h2>Clinic Overview</h2>
            <ul>
                <li>Total Doctors: <strong><%= doctors.size() %></strong></li>
                <li>Total Departments: <strong><%= departments.size() %></strong></li>
                <li>Total Patients: <strong><%= patients.size() %></strong></li>
            </ul>
        </div>

        <div class="section">
            <h2>Registered Patients</h2>
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

        <div class="section">
            <h2>Add Department</h2>
            <form action="<%= request.getContextPath() %>/addDepartment" method="post">
                <div class="form-group">
                    <label for="departmentName">Department Name</label>
                    <input type="text" id="departmentName" name="department" required>
                </div>
                <button type="submit" class="btn btn-primary">Add Department</button>
            </form>
        </div>

        <div class="section">
            <h2>Add Doctor with Availability</h2>
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

        <div class="section">
            <h2>Doctors & Availability</h2>
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
                    <!-- New availability add form - now controlled by a button -->
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
        <p style="text-align: center; margin-top: 30px;"><a href="<%= request.getContextPath() %>/view/appointments.jsp" class="btn btn-secondary">View All Appointments <i class="fas fa-calendar-check"></i></a></p>
    </div>

    <script>
        let availabilityGroupCounter = 1; // To ensure unique IDs for new inputs in "Add Doctor" section

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
    </script>
</body>
</html>
