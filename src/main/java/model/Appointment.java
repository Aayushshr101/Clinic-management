package model;

import java.sql.Date;
import java.sql.Time;

public class Appointment {
    private int id;
    private int patientId;
    private int doctorId;
    private Date appointmentDate;
    private Time appointmentTime;
    private String timeSlot;
    private Date date;
    private Time endTime;

   

    // Extra fields for viewing
    private String patientName;
    private String doctorName;
    private String department;
    private String status;
    
   

    // Additional fields to collect during booking
    private String contact;
    private int age;
    private String gender;

    // --- Getters ---
    public int getId() {
        return id;
    }

    public int getPatientId() {
        return patientId;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }
public String getTimeSlot() {
    return timeSlot;
}

public void setTimeSlot(String timeSlot) {
    this.timeSlot = timeSlot;
}
    public int getDoctorId() {
        return doctorId;
    }

    public Date getAppointmentDate() {
        return appointmentDate;
    }

    public Time getAppointmentTime() {
        return appointmentTime;
    }

    public String getPatientName() {
        return patientName;
    }

    public String getDoctorName() {
        return doctorName;
    }

    public String getDepartment() {
        return department;
    }

    public String getStatus() {
        return status;
    }

    public String getContact() {
        return contact;
    }

    public int getAge() {
        return age;
    }

    public String getGender() {
        return gender;
    }

    // --- Setters ---
    public void setId(int id) {
        this.id = id;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }

    public void setAppointmentDate(Date appointmentDate) {
        this.appointmentDate = appointmentDate;
    }

    public void setAppointmentTime(Time appointmentTime) {
        this.appointmentTime = appointmentTime;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }

    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }
    
    public Time getEndTime() {
        return endTime;
    }

    public void setEndTime(Time endTime) {
        this.endTime = endTime;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }
}
