<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediTrackPro Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
 
    
    <style>
        /* Global box-sizing reset */
        * {
            box-sizing: border-box;
        }

        body.login-page {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: #f0f2f5; /* Light gray background */
            padding: 20px;
            font-family: "Inter", -apple-system, BlinkMacSystemFont, sans-serif;
            color: #333;
            position: relative;
            overflow: hidden; /* Hide overflowing diagonal shapes */
        }

        /* Diagonal background shapes */
        .page-background-shapes {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            overflow: hidden;
        }

        .page-background-shapes::before {
            content: "";
            position: absolute;
            top: -100px; /* Adjust to control visibility */
            left: -100px; /* Adjust to control visibility */
            width: 300px;
            height: 300px;
            background-color: #4a90e2; /* Blue from your theme */
            transform: rotate(45deg);
            transform-origin: top left;
            z-index: 0;
        }

        .page-background-shapes::after {
            content: "";
            position: absolute;
            bottom: -100px; /* Adjust to control visibility */
            right: -100px; /* Adjust to control visibility */
            width: 300px;
            height: 300px;
            background-color: #6a5acd; /* Purple from your theme */
            transform: rotate(45deg);
            transform-origin: bottom right;
            z-index: 0;
        }

        .main-login-wrapper {
            display: flex;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 900px; /* Adjusted max-width for the split layout */
            overflow: hidden;
            z-index: 1; /* Ensure it's above background shapes */
        }

        .login-image-section {
            flex: 1;
            min-width: 350px; /* Minimum width for the image section */
            background-color: #e0e0e0; /* Placeholder background */
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
        }

        .login-image-section img {
            width: 100%;
            height: 100%;
            object-fit: cover; /* Cover the area without distortion */
            display: block;
        }

        .login-form-section {
            flex: 1;
            min-width: 350px; /* Minimum width for the form section */
            position: relative;
            background-color: #f0f8f8; /* Light background for form section */
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
        }

        .login-form-background-pattern {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: repeating-linear-gradient(
                -45deg,
                rgba(255, 255, 255, 0.1),
                rgba(255, 255, 255, 0.1) 10px,
                transparent 10px,
                transparent 20px
            );
            opacity: 0.5;
            z-index: 0;
        }

        .login-form-content {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 300px; /* Constrain form width within its section */
        }

        .logo {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-bottom: 30px;
        }

        .logo-icon {
            width: 40px;
            height: 40px;
            background-color: #4a90e2; /* Blue from your theme */
            border-radius: 50%; /* Circular icon */
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem; /* Placeholder for actual icon */
        }

        .logo-text {
            font-size: 1.8rem;
            font-weight: 600;
            color: #4a90e2; /* Blue from your theme */
        }

        .login-form-section h2 {
            font-size: 2rem;
            font-weight: 700;
            color: #212529;
            margin-bottom: 25px;
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .form-group label {
            display: block;
            font-size: 0.95rem;
            font-weight: 500;
            color: #495057;
            margin-bottom: 8px;
        }

        .form-group input[type="email"],
        .form-group input[type="password"] {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ced4da;
            border-radius: 8px;
            font-size: 1rem;
            color: #495057;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }

        .form-group input:focus {
            outline: none;
            border-color: #4a90e2;
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.25);
        }

        .btn-primary {
            width: 100%;
            padding: 12px 15px;
            font-size: 1.1rem;
            margin-top: 10px;
            background: linear-gradient(45deg, #4a90e2, #6a5acd); /* Blue to Purple */
            color: white;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.3);
            border-radius: 8px;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(74, 144, 226, 0.4);
        }

        .login-form-content p { /* Targeting paragraphs inside the form content */
            font-size: 0.95rem;
            color: #6c757d;
            margin-top: 20px;
        }

        .login-form-content p a { /* Targeting links inside the form content */
            color: #4a90e2;
            font-weight: 600;
            transition: color 0.3s ease;
            text-decoration: none;
        }

        .login-form-content p a:hover {
            color: #3a7bd5;
            text-decoration: underline;
        }

        .message-box {
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 0.95rem;
            font-weight: 500;
            text-align: left;
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

        .bottom-left-text {
            position: absolute;
            bottom: 20px;
            left: 20px;
            z-index: 1;
            color: #212529; /* Dark text color */
        }

        .bottom-left-text h2 {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 0;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .main-login-wrapper {
                flex-direction: column;
                max-width: 400px; /* Stacked layout, narrower container */
            }

            .login-image-section {
                min-height: 200px; /* Give image some height on small screens */
                min-width: auto;
            }

            .login-form-section {
                padding: 30px;
                min-width: auto;
            }

            .bottom-left-text {
                position: static; /* Remove absolute positioning */
                margin-top: 20px;
                text-align: center;
            }

            .bottom-left-text h2 {
                font-size: 2rem;
            }

            .page-background-shapes::before,
            .page-background-shapes::after {
                width: 200px;
                height: 200px;
            }
        }

        @media (max-width: 480px) {
            body.login-page {
                padding: 10px;
            }

            .main-login-wrapper {
                border-radius: 8px;
            }

            .login-form-section {
                padding: 20px;
            }

            .login-form-section h2 {
                font-size: 1.8rem;
            }

            .logo-text {
                font-size: 1.5rem;
            }

            .logo-icon {
                width: 30px;
                height: 30px;
            }

            .btn-primary {
                font-size: 1rem;
                padding: 10px 15px;
            }

            .bottom-left-text h2 {
                font-size: 1.8rem;
            }
        }
        
       .message-box.success {
    background-color: #d4edda;
    color: #155724;
    border: 1px solid #c3e6cb;
    padding: 12px 20px;
    border-radius: 8px;
    margin-bottom: 20px;
    font-size: 0.95rem;
    font-weight: 500;
    text-align: left;
}

.message-box.error {
    background-color: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
    padding: 12px 20px;
    border-radius: 8px;
    margin-bottom: 20px;
    font-size: 0.95rem;
    font-weight: 500;
    text-align: left;
}
  
    </style>
</head>
<body class="login-page">
  

    <div class="main-login-wrapper">
        <div class="login-image-section">
            <!-- Placeholder for the doctor image -->
            <img src="https://media.istockphoto.com/id/1394762016/photo/doctor-consoling-disabled-man-on-wheelchair-with-daughter-by-his-side-at-the-hospital.jpg?s=612x612&w=0&k=20&c=QHDmpEt3hi4DCeGReGiBf06LbZrshccJb2G6yWhkHJA=" alt="Doctor consulting patient" class="doctor-image" />
        </div>
        <div class="login-form-section">
            <div class="login-form-background-pattern"></div>
            <div class="login-form-content">
                
                <h2>Login to MediHub</h2>
              <%
    String sessionMsg = (String) session.getAttribute("msg");
    if (sessionMsg != null) {
%>
    <div class="message-box success"><%= sessionMsg %></div>
<%
        session.removeAttribute("msg");
    }

    String requestMsg = (String) request.getAttribute("msg");
    if (requestMsg != null) {
%>
    <div class="message-box error"><%= requestMsg %></div>
<% } %>


                <form action="<%= request.getContextPath() %>/login" method="post">
                    <div class="form-group">
                        <label for="email">Email id</label>
                        <input type="email" id="email" name="email" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Login</button>
                </form>
                <p>New patient? <a href="register.jsp">Register here</a></p>
                <p>Are you a doctor? <a href="doctorSetPassword.jsp">Set your password here</a></p>
            </div>
        </div>
    </div>

   
</body>
</html>
