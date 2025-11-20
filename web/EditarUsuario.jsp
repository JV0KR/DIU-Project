<%@ page import="modelo.UsuarioDAO" %>
<%@ page import="modelo.Usuario" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Panel - Editar Usuario</title>
        <style>
            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                margin: 0;
                padding: 20px;
                background: #f8f9fa;
            }
            .container {
                max-width: 800px;
                margin: 40px auto;
                background: white;
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0,0,0,0.1);
                overflow: hidden;
            }
            .header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 30px;
                text-align: center;
            }
            .form-section {
                padding: 30px;
            }
            .form-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }
            .form-group {
                margin-bottom: 20px;
            }
            label {
                display: block;
                font-weight: 600;
                margin-bottom: 8px;
                color: #495057;
            }
            input[type="text"], input[type="password"], input[type="email"], select {
                width: 100%;
                padding: 12px;
                border: 2px solid #e9ecef;
                border-radius: 8px;
                font-size: 14px;
                transition: border-color 0.3s;
                box-sizing: border-box;
            }
            input[type="text"]:focus, input[type="password"]:focus, input[type="email"]:focus, select:focus {
                outline: none;
                border-color: #667eea;
            }
            .btn-submit {
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                color: white;
                border: none;
                padding: 15px 40px;
                border-radius: 8px;
                cursor: pointer;
                font-size: 16px;
                font-weight: 600;
                transition: transform 0.2s;
                width: 100%;
                margin-top: 10px;
            }
            .btn-submit:hover {
                transform: translateY(-2px);
            }
            .btn-back {
                background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
                color: white;
                padding: 12px 30px;
                border-radius: 8px;
                text-decoration: none;
                display: inline-block;
                font-weight: 600;
                transition: transform 0.2s;
                margin-bottom: 20px;
                text-align: center;
                width: 100%;
                box-sizing: border-box;
            }
            .btn-back:hover {
                transform: translateY(-2px);
                color: white;
                text-decoration: none;
            }
            .required::after {
                content: " *";
                color: #dc3545;
            }
            .help-text {
                font-size: 12px;
                color: #6c757d;
                margin-top: 5px;
            }
            .full-width {
                grid-column: 1 / span 2;
            }
            .password-container {
                position: relative;
            }
            .toggle-password {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                background: none;
                border: none;
                cursor: pointer;
                color: #6c757d;
            }
            .user-avatar {
                text-align: center;
                margin-bottom: 20px;
            }
            .avatar-circle {
                width: 80px;
                height: 80px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border-radius: 50%;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 32px;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <%
            UsuarioDAO udao = new UsuarioDAO();
            int id = Integer.parseInt(request.getParameter("id"));
            Usuario a = udao.listarUsuarios_Id(id);
            
            // Obtener inicial para el avatar
            String inicial = a.getNombre().substring(0, 1).toUpperCase();
        %>

        <div class="container">
            <div class="header">
                <h1>?? Editar Usuario</h1>
                <p>Actualizar información del usuario del sistema</p>
            </div>

            <div class="form-section">
                <div class="user-avatar">
                    <div class="avatar-circle">
                        <%= inicial %>
                    </div>
                </div>

                <a href="ListaUsuarios.jsp" class="btn-back">
                    ?? Volver a la Lista de Usuarios
                </a>

                <form method="post" action="editarUsuario">
                    <input type="hidden" name="cidd" value="<%= id %>"/>
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="cid" class="required">? Identificación</label>
                            <input type="text" id="cid" name="cid" value="<%= a.getIdentificacion() %>" required
                                   placeholder="Número de identificación">
                        </div>

                        <div class="form-group">
                            <label for="cnombre" class="required">? Nombres</label>
                            <input type="text" id="cnombre" name="cnombre" value="<%= a.getNombre() %>" required
                                   placeholder="Nombres del usuario">
                        </div>

                        <div class="form-group">
                            <label for="capellido" class="required">? Apellidos</label>
                            <input type="text" id="capellido" name="capellido" value="<%= a.getApellido() %>" required
                                   placeholder="Apellidos del usuario">
                        </div>

                        <div class="form-group">
                            <label for="cmail" class="required">? Email</label>
                            <input type="email" id="cmail" name="cmail" value="<%= a.getEmail() %>" required
                                   placeholder="correo@ejemplo.com">
                        </div>

                        <div class="form-group">
                            <label for="cusuario" class="required">? Usuario</label>
                            <input type="text" id="cusuario" name="cusuario" value="<%= a.getUsuario() %>" required
                                   placeholder="Nombre de usuario">
                        </div>

                        <div class="form-group">
                            <label for="cclave" class="required">? Contraseña</label>
                            <div class="password-container">
                                <input type="password" id="cclave" name="cclave" value="<%= a.getClave() %>" required
                                       placeholder="Contraseña segura">
                                <button type="button" class="toggle-password" onclick="togglePassword()">
                                    ??
                                </button>
                            </div>
                        </div>

                        <div class="form-group full-width">
                            <label for="cperfil" class="required">? Perfil</label>
                            <select id="cperfil" name="cperfil" required>
                                <option value="">Seleccione un perfil</option>
                                <option value="1" <%= a.getIdperfil() == 1 ? "selected" : "" %>>? Administrador</option>
                                <option value="2" <%= a.getIdperfil() == 2 ? "selected" : "" %>>? Usuario Académico</option>
                                <option value="3" <%= a.getIdperfil() == 3 ? "selected" : "" %>>? Invitado</option>
                            </select>
                            <div class="help-text">
                                ? Administrador: Acceso completo al sistema<br>
                                ? Usuario Académico: Puede subir y gestionar documentos<br>
                                ? Invitado: Solo consulta de documentos
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn-submit">
                        ? Actualizar Usuario
                    </button>
                </form>
            </div>
        </div>

        <script>
            function togglePassword() {
                const passwordField = document.getElementById('cclave');
                const toggleButton = document.querySelector('.toggle-password');
                
                if (passwordField.type === 'password') {
                    passwordField.type = 'text';
                    toggleButton.textContent = '?';
                } else {
                    passwordField.type = 'password';
                    toggleButton.textContent = '??';
                }
            }

            // Validación del formulario
            document.querySelector('form').addEventListener('submit', function(e) {
                const identificacion = document.getElementById('cid').value.trim();
                const nombre = document.getElementById('cnombre').value.trim();
                const apellido = document.getElementById('capellido').value.trim();
                const email = document.getElementById('cmail').value.trim();
                const usuario = document.getElementById('cusuario').value.trim();
                const clave = document.getElementById('cclave').value.trim();
                const perfil = document.getElementById('cperfil').value;

                if (!identificacion || !nombre || !apellido || !email || !usuario || !clave || !perfil) {
                    alert('Por favor, complete todos los campos requeridos');
                    e.preventDefault();
                    return;
                }

                // Validación básica de email
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    alert('Por favor, ingrese un email válido');
                    e.preventDefault();
                    return;
                }

                if (!confirm('¿Está seguro de que desea actualizar este usuario?')) {
                    e.preventDefault();
                }
            });
        </script>
    </body>
</html>
