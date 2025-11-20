<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String mensaje = request.getParameter("mensaje");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Panel - Mensaje</title>
        <style>
            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                margin: 0;
                padding: 20px;
                background: #f8f9fa;
            }
            .container {
                max-width: 600px;
                margin: 100px auto;
                background: white;
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0,0,0,0.1);
                overflow: hidden;
                text-align: center;
            }
            .header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 30px;
            }
            .content {
                padding: 40px;
            }
            .success {
                color: #28a745;
                font-size: 24px;
                margin-bottom: 20px;
            }
            .error {
                color: #dc3545;
                font-size: 24px;
                margin-bottom: 20px;
            }
            .btn-nav {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 12px 30px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-size: 16px;
                font-weight: 600;
                text-decoration: none;
                display: inline-block;
                margin: 10px;
                transition: transform 0.2s;
            }
            .btn-nav:hover {
                transform: translateY(-2px);
                color: white;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>📢 Sistema de Mensajes</h1>
            </div>
            <div class="content">
                <% if (mensaje != null) { %>
                    <div class="success">✅ <%= mensaje %></div>
                <% } %>
                <% if (error != null) { %>
                    <div class="error">❌ <%= error %></div>
                <% } %>
                
                <div style="margin-top: 30px;">
                    <a href="front.jsp" class="btn-nav">🏠 Volver al panel</a>
                </div>
            </div>
        </div>
    </body>
</html>