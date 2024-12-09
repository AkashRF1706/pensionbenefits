<%@ page language="java" contentType="text/csv; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%
    String csvFileName = "employee_template.csv";
    response.setContentType("text/csv");
    response.setHeader("Content-Disposition", "attachment;filename=" + csvFileName);

    String header = "First Name,Last Name,Email, NI Number,Annual Salary\n";
    OutputStream outputStream = response.getOutputStream();
    outputStream.write(header.getBytes());
    outputStream.flush();
    outputStream.close();
%>
