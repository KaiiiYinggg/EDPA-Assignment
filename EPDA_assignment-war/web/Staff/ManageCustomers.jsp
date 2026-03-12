<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Customers</title>
    <style>
        /* 弹窗样式 */
        .modal { display: none; position: fixed; z-index: 10; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.4); }
        .modal-content { background-color: #fefefe; margin: 10% auto; padding: 25px; border-radius: 8px; width: 30%; box-shadow: 0 4px 8px rgba(0,0,0,0.2); }
        
        /* 表格样式优化 */
        table { border-collapse: collapse; margin-top: 15px; }
        th { background-color: #f2f2f2; padding: 10px; }
        td { padding: 10px; border-bottom: 1px solid #ddd; }
        
        /* 让整行看起来可以点击 */
        .clickable-row { cursor: pointer; transition: background 0.2s; }
        .clickable-row:hover { background-color: #f1f7ff; } /* 鼠标移上去变淡蓝色 */
        
        /* 复选框单元格不需要手型 */
        .checkbox-cell { cursor: default; }
    </style>
    <script>
        // 弹出修改窗口
        function openUpdateModal(id, name, phone, email) {
            document.getElementById('updateId').value = id;
            document.getElementById('updateUsername').value = name;
            document.getElementById('updatePhone').value = phone;
            document.getElementById('updateEmail').value = email;
            document.getElementById('myModal').style.display = "block";
        }
        
        function closeModal() { 
            document.getElementById('myModal').style.display = "none"; 
        }

        // 点击窗口外部关闭窗口
        window.onclick = function(event) {
            var modal = document.getElementById('myModal');
            if (event.target == modal) {
                closeModal();
            }
        }
    </script>
</head>
<body>

<h2>Customer Management</h2>

<form action="ManageCustomers" method="GET">
    <input type="hidden" name="action" value="list">
    <input type="text" name="searchQuery" placeholder="Search Name/Email/Phone" value="${param.searchQuery}" style="padding: 5px; width: 250px;">
    <button type="submit" style="padding: 5px 15px;">Search</button>
</form>

<hr>

<form action="ManageCustomers" method="POST" onsubmit="return confirm('Delete selected?')">
    <input type="hidden" name="action" value="deleteMultiple">
    
    <table width="100%">
        <thead>
            <tr>
                <th>Select</th>
                <th>ID</th>
                <th>Username</th>
                <th>Gender</th>
                <th>Phone</th>
                <th>Email</th>
                <th>Role</th>
                </tr>
        </thead>
        <tbody>
            <c:forEach var="c" items="${customerList}">
                <tr class="clickable-row" onclick="openUpdateModal('${c.id}', '${c.username}', '${c.phoneNumber}', '${c.email}')">
                    <td class="checkbox-cell" onclick="event.stopPropagation();">
                        <input type="checkbox" name="selectedIds" value="${c.id}">
                    </td>
                    <td>${c.id}</td>
                    <td>${c.username}</td>
                    <td>${c.gender}</td>
                    <td>${c.phoneNumber}</td>
                    <td>${c.email}</td>
                    <td>${c.role}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <br>
    <button type="submit" style="background-color: #ff4d4d; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer;">
        Delete Selected
    </button>
    <span style="color: #666; font-size: 0.9em; margin-left: 10px;">(Tip: Click any row to update user info)</span>
</form>

<div id="myModal" class="modal">
    <div class="modal-content">
        <h3 style="margin-top: 0;">Update Customer Info</h3>
        <form action="ManageCustomers" method="POST">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" id="updateId">
            
            <p>Username:<br>
                <input type="text" name="username" id="updateUsername" required style="width: 90%; padding: 5px;">
            </p>
            <p>Phone:<br>
                <input type="number" name="phoneNumber" id="updatePhone" required style="width: 90%; padding: 5px;">
            </p>
            <p>Email:<br>
                <input type="email" name="email" id="updateEmail" required style="width: 90%; padding: 5px;">
            </p>
            
            <p style="color: gray; font-size: 0.8em;">* Gender and Role are not editable here.</p>
            
            <div style="text-align: right; margin-top: 20px;">
                <button type="button" onclick="closeModal()" style="padding: 8px 15px; margin-right: 5px;">Cancel</button>
                <button type="submit" style="padding: 8px 15px; background-color: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer;">
                    Save Changes
                </button>
            </div>
        </form>
    </div>
</div>

<br>
<hr>
<a href="StaffDashboard.jsp" style="text-decoration: none; color: #007bff;">&larr; Back to Dashboard</a>

</body>
</html>