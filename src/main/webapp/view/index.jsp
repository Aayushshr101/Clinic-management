<%@ page import="java.util.*, dao.DoctorDAO, model.Doctor, model.User" %>
<%
    DoctorDAO docDao = new DoctorDAO();
    List<Doctor> doctors = docDao.getAllDoctors();
    User user = (User) session.getAttribute("user");
    boolean isLoggedIn = (user != null && "patient".equals(user.getRole()));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Health Care</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
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
            background: #ffffff;
        }

        html {
            scroll-behavior: smooth;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* Header Styles */
        header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid #ced4da;
            position: sticky;
            top: 0;
            z-index: 1000;
            transition: all 0.3s ease;
        }

        header.scrolled {
            background: rgba(255, 255, 255, 0.98);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            color: #212529;
            text-decoration: none;
        }

        .logo i {
            font-size: 2rem;
            color: #4a90e2;
        }

        .logo-text h1 {
            font-family: 'Poppins', sans-serif;
            font-size: 1.5rem;
            font-weight: 700;
            color: #212529;
        }

        .logo-text span {
            font-size: 0.75rem;
            color: #6c757d;
            font-weight: 500;
        }

        /* Navigation */
        nav {
            display: flex;
            gap: 30px;
        }

        nav a {
            color: #495057;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.95rem;
            padding: 8px 0;
            position: relative;
            transition: all 0.3s ease;
        }

        nav a:hover {
            color: #4a90e2;
        }

        nav a::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 2px;
            background: #4a90e2;
            transition: width 0.3s ease;
        }

        nav a:hover::after {
            width: 100%;
        }

        .auth-buttons {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .welcome-text {
            color: #212529;
            font-weight: 500;
            font-size: 0.9rem;
            margin-right: 15px;
        }

        /* Button Styles */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px 20px;
            font-size: 0.95rem;
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.3s ease;
            cursor: pointer;
            border: none;
            text-decoration: none;
            font-family: inherit;
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

        .btn-secondary {
            background: #6a5acd;
            color: white;
            box-shadow: 0 3px 10px rgba(106, 90, 205, 0.3);
        }

        .btn-secondary:hover {
            background: #5a4fcf;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(106, 90, 205, 0.4);
        }

        .btn-outline {
            background: transparent;
            color: #4a90e2;
            border: 2px solid #4a90e2;
        }

        .btn-outline:hover {
            background: #4a90e2;
            color: white;
            transform: translateY(-2px);
        }

        .btn-large {
            padding: 15px 30px;
            font-size: 1.1rem;
        }

        /* Hero Section */
        .hero {
            background: linear-gradient(135deg, #4a90e2 0%, #6a5acd 100%);
            color: white;
            min-height: 80vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            position: relative;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image: url('https://images.unsplash.com/photo-1559757148-5c350d0d3c56?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80');
            background-size: cover;
            background-position: center;
            opacity: 0.1;
        }

        .hero-content {
            position: relative;
            z-index: 2;
            max-width: 800px;
        }

        .hero h1 {
            font-family: 'Poppins', sans-serif;
            font-size: clamp(2.5rem, 5vw, 3.5rem);
            font-weight: 700;
            margin-bottom: 25px;
            line-height: 1.2;
        }

        .hero p {
            font-size: 1.2rem;
            font-weight: 400;
            margin-bottom: 40px;
            opacity: 0.95;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        .hero-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn-white {
            background: white;
            color: #4a90e2;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .btn-white:hover {
            background: #f8f9fa;
            transform: translateY(-2px);
        }

        /* Section Styles */
        .section {
            padding: 80px 0;
        }

        .section-header {
            text-align: center;
            margin-bottom: 50px;
        }

        .section-header h2 {
            font-family: 'Poppins', sans-serif;
            font-size: clamp(2rem, 4vw, 2.5rem);
            font-weight: 700;
            color: #212529;
            margin-bottom: 15px;
        }

        .section-header p {
            font-size: 1.1rem;
            color: #6c757d;
            max-width: 600px;
            margin: 0 auto;
        }

        /* Cards Grid */
        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }

        .card {
            background: white;
            padding: 40px 30px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border: 1px solid #ced4da;
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(45deg, #4a90e2, #6a5acd);
        }

        .card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }

        .card-icon {
            width: 70px;
            height: 70px;
            margin: 0 auto 25px;
            background: linear-gradient(45deg, #4a90e2, #6a5acd);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.75rem;
            color: white;
            box-shadow: 0 3px 10px rgba(74, 144, 226, 0.3);
        }

        .card h3 {
            font-family: 'Poppins', sans-serif;
            font-size: 1.25rem;
            font-weight: 600;
            color: #212529;
            margin-bottom: 15px;
        }

        .card p {
            font-size: 0.95rem;
            color: #495057;
            line-height: 1.6;
            margin-bottom: 25px;
        }

        /* Doctor Cards */
        .doctor-card::before {
            background: #6a5acd;
        }

        .doctor-card .card-icon {
            background: #6a5acd;
            box-shadow: 0 3px 10px rgba(106, 90, 205, 0.3);
        }

        .doctor-card p strong {
            color: #212529;
            font-weight: 600;
        }

        /* Services Section */
        .services-section {
            background: #f8f9fa;
        }

        /* About Section */
        .about-content {
            display: grid;
            grid-template-columns: 1fr 1.2fr;
            gap: 60px;
            align-items: center;
            margin-top: 50px;
        }

        .about-text h3 {
            font-family: 'Poppins', sans-serif;
            font-size: 1.75rem;
            font-weight: 600;
            color: #212529;
            margin-bottom: 15px;
        }

        .about-text p {
            font-size: 1.1rem;
            color: #495057;
            margin-bottom: 25px;
            line-height: 1.7;
        }

        .about-image img {
            width: 100%;
            height: auto;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .features-list {
            list-style: none;
            padding: 0;
        }

        .features-list li {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
            font-size: 1.1rem;
            color: #495057;
        }

        .features-list li i {
            color: #6a5acd;
            font-size: 1.25rem;
            width: 24px;
            text-align: center;
        }

        /* Contact Section */
        .contact-section {
            background: #f8f9fa;
        }

        .contact-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            margin-top: 50px;
        }

        .contact-card {
            background: white;
            padding: 40px 30px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border: 1px solid #ced4da;
            transition: all 0.3s ease;
        }

        .contact-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }

        .contact-card i {
            font-size: 2.5rem;
            color: #4a90e2;
            margin-bottom: 20px;
        }

        .contact-card h4 {
            font-family: 'Poppins', sans-serif;
            font-size: 1.25rem;
            font-weight: 600;
            color: #212529;
            margin-bottom: 12px;
        }

        .contact-card p {
            font-size: 1rem;
            color: #6c757d;
        }

        /* Footer */
        footer {
            background: #212529;
            color: white;
            text-align: center;
            padding: 40px 0;
        }

        footer p {
            font-size: 1rem;
            opacity: 0.8;
        }

        /* Mobile Responsive */
        @media (max-width: 768px) {
            .container {
                padding: 0 15px;
            }

            .header-content {
                flex-direction: column;
                gap: 15px;
            }

            nav {
                flex-wrap: wrap;
                justify-content: center;
                gap: 15px;
            }

            .hero {
                min-height: 70vh;
                padding: 30px 0;
            }

            .hero-buttons {
                flex-direction: column;
                align-items: center;
            }

            .section {
                padding: 50px 0;
            }

            .about-content {
                grid-template-columns: 1fr;
                gap: 30px;
                text-align: center;
            }

            .cards-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .auth-buttons {
                flex-direction: column;
                gap: 10px;
                width: 100%;
            }
        }

        @media (max-width: 480px) {
            .card {
                padding: 30px 20px;
            }

            .hero h1 {
                font-size: 2rem;
            }

            .hero p {
                font-size: 1rem;
            }
        }

        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .hero-content {
            animation: fadeInUp 1s ease;
        }

        .card {
            animation: fadeInUp 0.6s ease both;
        }

        .card:nth-child(2) { animation-delay: 0.2s; }
        .card:nth-child(3) { animation-delay: 0.4s; }
        .card:nth-child(4) { animation-delay: 0.6s; }

        /* Message Box Styles */
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
    </style>
</head>
<body>
    <!-- Header -->
    <header id="header">
        <div class="container">
            <div class="header-content">
                <a href="#home" class="logo">
                    <i class="fas fa-heartbeat"></i>
                    <div class="logo-text">
                        <h1>Health Care</h1>
                        <span>Your health, our priority</span>
                    </div>
                </a>
                
                <nav>
                    <a href="#home">Home</a>
                    <a href="#doctors">Doctors</a>
                    <a href="#services">Services</a>
                    <a href="#about">About</a>
                    <a href="#contact">Contact</a>
                </nav>
                
                <div class="auth-buttons">
                    <% if (user == null) { %>
                        <a href="login.jsp" class="btn btn-outline">
                            <i class="fas fa-sign-in-alt"></i>
                            Login
                        </a>
                        <a href="register.jsp" class="btn btn-primary">
                            <i class="fas fa-user-plus"></i>
                            Register
                        </a>
                    <% } else { %>
                        <span class="welcome-text">
                            <i class="fas fa-user-circle"></i>
                            Welcome, <%= user.getName() %>
                        </span>
                        <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline">
                            <i class="fas fa-sign-out-alt"></i>
                            Logout
                        </a>
                    <% } %>
                </div>
            </div>
        </div>
    </header>

    <!-- Hero Section -->
    <section class="hero" id="home">
        <div class="container">
            <div class="hero-content">
                <h1>Your Health, Simplfied</h1>
                <p>Experience seamless healthcare with our advanced clinic management system. Book appointments, manage health records, and connect with medical professionals.</p>
                
                <div class="hero-buttons">
                    <a href="<%= isLoggedIn ? "patientDashboard.jsp" : "view/login.jsp" %>" class="btn btn-white btn-large">
                        <i class="fas fa-calendar-check"></i>
                        Book Appointment
                    </a>
                    <a href="view/register.jsp" class="btn btn-secondary btn-large">
                        <i class="fas fa-rocket"></i>
                        Get Started
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Doctors Section -->
    <section class="section" id="doctors">
        <div class="container">
            <div class="section-header">
                <h2>Meet Our Expert Doctors</h2>
                <p>Our dedicated team of healthcare professionals is committed to providing exceptional medical care</p>
            </div>
            
            <div class="cards-grid">
                <% for (Doctor d : doctors) { %>
                    <div class="card doctor-card">
                        <div class="card-icon">
                            <i class="fas fa-user-md"></i>
                        </div>
                        <h3>Dr. <%= d.getName() %></h3>
                        <p><strong>Department:</strong> <%= d.getDepartmentName() %></p>
                        <p><strong>Available:</strong> <%= d.getAvailableTimeSummary() %></p>
                        <a href="<%= isLoggedIn ? ("patientDashboard.jsp?doctorId=" + d.getId()) : "view/login.jsp" %>" class="btn btn-secondary">
                            <i class="fas fa-calendar-plus"></i>
                            Get Appointment
                        </a>
                    </div>
                <% } %>
            </div>
        </div>
    </section>

    <!-- Services Section -->
    <section class="section services-section" id="services">
        <div class="container">
            <div class="section-header">
                <h2>Our Healthcare Services</h2>
                <p>Comprehensive healthcare solutions designed for modern patient needs</p>
            </div>
            
            <div class="cards-grid">
                <div class="card">
                    <div class="card-icon">
                        <i class="fas fa-user-plus"></i>
                    </div>
                    <h3>Patient Registration</h3>
                    <p>Quick and secure patient registration with advanced data protection and easy account management</p>
                    <a href="view/register.jsp" class="btn btn-primary">Register Now</a>
                </div>
                
                <div class="card">
                    <div class="card-icon">
                        <i class="fas fa-calendar-alt"></i>
                    </div>
                    <h3>Smart Appointment Booking</h3>
                    <p>Intelligent scheduling system with real-time availability and automated reminders</p>
                    <a href="<%= isLoggedIn ? "patientDashboard.jsp" : "view/login.jsp" %>" class="btn btn-primary">Book Now</a>
                </div>
                
                <div class="card">
                    <div class="card-icon">
                        <i class="fas fa-clipboard-list"></i>
                    </div>
                    <h3>Health Records Management</h3>
                    <p>Secure access to your complete medical history and health records with 24/7 availability</p>
                    <a href="<%= isLoggedIn ? "patientDashboard.jsp" : "view/login.jsp" %>" class="btn btn-primary">View Records</a>
                </div>
            </div>
        </div>
    </section>

    <!-- About Section -->
    <section class="section" id="about">
        <div class="container">
            <div class="section-header">
                <h2>About MediTrackPro</h2>
                <p>Leading healthcare innovation with technology and compassionate care</p>
            </div>
            
            <div class="about-content">
                <div class="about-text">
                    <h3>Our Mission</h3>
                    <p>MediTrackPro is revolutionizing healthcare delivery through cutting-edge technology and patient-centered care. We believe exceptional healthcare should be accessible, efficient, and personalized.</p>
                    
                    <h3>Why Choose Us?</h3>
                    <ul class="features-list">
                        <li>
                            <i class="fas fa-check-circle"></i>
                            Advanced medical technology and equipment
                        </li>
                        <li>
                            <i class="fas fa-check-circle"></i>
                            Board-certified specialists across departments
                        </li>
                        <li>
                            <i class="fas fa-check-circle"></i>
                            Secure patient data protection
                        </li>
                        <li>
                            <i class="fas fa-check-circle"></i>
                            24/7 patient support services
                        </li>
                    </ul>
                </div>
                
                <div class="about-image">
                    <img src="https://i.pinimg.com/originals/0f/e1/0f/0fe10fd48a518e1d9cb271b7fd8812eb.jpg" alt="Modern Medical Facility">
                </div>
            </div>
        </div>
    </section>

    <!-- Contact Section -->
    <section class="section contact-section" id="contact">
        <div class="container">
            <div class="section-header">
                <h2>Contact Us</h2>
                <p>Get in touch with our healthcare team for appointments and support</p>
            </div>
            
            <div class="contact-grid">
                <div class="contact-card">
                    <i class="fas fa-map-marker-alt"></i>
                    <h4>Our Location</h4>
                    <p>Kathmandu, Nepal</p>
                </div>
                
                <div class="contact-card">
                    <i class="fas fa-phone"></i>
                    <h4>Call Us</h4>
                    <p>=+977<br>Emergency: 97675459088</p>
                </div>
                
                <div class="contact-card">
                    <i class="fas fa-envelope"></i>
                    <h4>Email Support</h4>
                    <p>info@meditrackpro.com<br>support@meditrackpro.com</p>
                </div>
                
                <div class="contact-card">
                    <i class="fas fa-clock"></i>
                    <h4>Working Hours</h4>
                    <p>Mon-Fri: 8:00 AM - 6:00 PM<br>Sat-Sun: 9:00 AM - 4:00 PM</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container">
            <p>&copy; 2025 MediTrackPro. All rights reserved. | Modern Healthcare Management System</p>
        </div>
    </footer>

    <script>
        // Header scroll effect
        window.addEventListener('scroll', function() {
            const header = document.getElementById('header');
            if (window.scrollY > 100) {
                header.classList.add('scrolled');
            } else {
                header.classList.remove('scrolled');
            }
        });

        // Smooth scrolling for navigation links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Card hover effects
        document.querySelectorAll('.card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-15px) scale(1.02)';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });
        });

        // Intersection Observer for scroll animations
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);

        // Observe cards for animations
        document.querySelectorAll('.card, .contact-card').forEach(element => {
            element.style.opacity = '0';
            element.style.transform = 'translateY(30px)';
            element.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            observer.observe(element);
        });
    </script>
</body>
</html>