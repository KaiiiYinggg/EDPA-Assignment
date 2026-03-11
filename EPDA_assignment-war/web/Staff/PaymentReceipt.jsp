<%-- 
    Document   : PaymentReceipt
    Created on : 9 Mar 2026, 12:41:42 pm
    Author     : Kai Ying
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head><title>Generate Receipt</title></head>
<body>
    <h2>Service Receipt</h2>
    <div style="border: 1px solid black; padding: 20px; width: 400px;">
        <h3>APU Automotive Service Centre</h3>
        <p>Receipt No: ${receiptId}</p>
        <p>Customer: ${custName}</p>
        <hr>
        <p>Service Type: ${serviceType}</p>
        <p>Price: RM ${price} [cite: 128]</p>
        <hr>
        <h4>Total Amount Paid: RM ${price}</h4>
    </div>
    <br>
    <button onclick="window.print()">Print Receipt</button>
    <a href="staff_dashboard.jsp">Back to Home</a>
</body>
</html>