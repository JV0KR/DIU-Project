<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Panel - Iniciar Sesión</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f5f5f5;
                margin: 0;
                padding: 0;
            }
            header {
                background-color: #007bff;
                color: white;
                padding: 15px;
                text-align: center;
                font-size: 24px;
                font-weight: bold;
            }
            .container {
                width: 40%;
                margin: 100px auto;
                background-color: #fff;
                padding: 30px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                border-radius: 8px;
            }
            form {
                display: grid;
                grid-template-columns: 150px 1fr;
                gap: 15px 10px;
                align-items: center;
            }
            form label {
                font-weight: bold;
                text-align: right;
            }
            form input {
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 4px;
                font-size: 14px;
                width: 100%;
            }
            input[type="submit"] {
                grid-column: 1 / span 2;
                background-color: #007bff;
                color: white;
                padding: 12px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 16px;
                margin-top: 10px;
            }
            input[type="submit"]:hover {
                background-color: #0056b3;
            }

            /* Estilo para el mensaje de error */
            .error-message {
                color: red;
                font-size: 14px;
                text-align: center;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <header>Inicio de Sesión</header>
        <div class="container">
            <h2>Iniciar Sesión</h2>

            <!-- Mostrar mensaje de error si existe -->
            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="error-message"><%= error %></div>
            <% } %>

            <form id="form1" name="form1" method="post" action="ctrolValidar">
                <label for="cusuario">Usuario:</label>
                <input type="text" name="cusuario" id="cusuario" required />

                <label for="cclave">Contraseña:</label>
                <input type="password" name="cclave" id="cclave" required />

                <input type="submit" value="Ingresar" />
            </form>
        </div>
    </body>
</html>
