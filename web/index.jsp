<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Plataforma de Gestión Documental - Iniciar Sesión</title>
        <style>
            body { 
                margin: 0; 
                padding: 0; 
                font-family: 'Segoe UI', Arial, sans-serif; 
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
            }
            .header { 
                background: rgba(255, 255, 255, 0.1);
                color: white; 
                padding: 20px 30px; 
                width: 100%;
                text-align: center;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                backdrop-filter: blur(10px);
                position: absolute;
                top: 0;
            }
            .system-name { 
                font-size: 28px; 
                font-weight: 700; 
                margin-bottom: 5px;
            }
            .system-subtitle {
                font-size: 14px; 
                opacity: 0.9;
            }
            .login-container {
                width: 400px;
                background-color: #fff;
                padding: 40px;
                border-radius: 10px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
                margin-top: 50px;
            }
            .login-title {
                text-align: center;
                color: #2c3e50;
                margin-bottom: 30px;
                font-size: 24px;
                font-weight: 600;
            }
            form {
                display: flex;
                flex-direction: column;
                gap: 20px;
            }
            .form-group {
                display: flex;
                flex-direction: column;
            }
            form label {
                font-weight: 600;
                margin-bottom: 8px;
                color: #2c3e50;
                font-size: 14px;
            }
            form input {
                padding: 12px 15px;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                font-size: 14px;
                transition: all 0.3s;
            }
            form input:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                outline: none;
            }
            input[type="submit"] {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 15px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-size: 16px;
                font-weight: 600;
                transition: transform 0.2s;
                margin-top: 10px;
            }
            input[type="submit"]:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            }

            .error-message {
                background: #fff3cd;
                border-left: 4px solid #ffc107;
                padding: 12px 15px;
                border-radius: 5px;
                font-size: 14px;
                color: #856404;
                margin-bottom: 20px;
            }
            
            .login-footer {
                text-align: center;
                margin-top: 30px;
                color: rgba(255, 255, 255, 0.8);
                font-size: 14px;
            }
        </style>
    </head>
    <body>
        <div class="header">
            <div class="system-name">📚 Gestión Documental Académica</div>
            <div class="system-subtitle">Plataforma de gestión de documentos departamentales</div>
        </div>

        <div class="login-container">
            <div class="login-title">Iniciar Sesión</div>

            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="error-message"><%= error %></div>
            <% } %>

            <form id="form1" name="form1" method="post" action="ctrolValidar">
                <div class="form-group">
                    <label for="cusuario">Usuario:</label>
                    <input type="text" name="cusuario" id="cusuario" required />
                </div>
                
                <div class="form-group">
                    <label for="cclave">Contraseña:</label>
                    <input type="password" name="cclave" id="cclave" required />
                </div>

                <input type="submit" value="Ingresar" />
            </form>
        </div>
    </body>
</html>
