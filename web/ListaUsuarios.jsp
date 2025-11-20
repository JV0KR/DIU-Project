<%@ page import="java.util.List" %>
<%@ page import="modelo.UsuarioDAO" %>
<%@ page import="modelo.Usuario" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Panel - Lista de Usuarios</title>
        <style>
            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                margin: 0;
                padding: 20px;
                background: #f8f9fa;
            }
            .container {
                max-width: 1200px;
                margin: 0 auto;
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
            .content-section {
                padding: 30px;
            }
            .btn-primary {
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                color: white;
                padding: 12px 30px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-size: 16px;
                font-weight: 600;
                text-decoration: none;
                display: inline-block;
                transition: transform 0.2s;
                margin-bottom: 20px;
            }
            .btn-primary:hover {
                transform: translateY(-2px);
                color: white;
                text-decoration: none;
            }
            .table-container {
                overflow-x: auto;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            table {
                width: 100%;
                border-collapse: collapse;
                background: white;
            }
            th {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 15px;
                text-align: left;
                font-weight: 600;
            }
            td {
                padding: 15px;
                border-bottom: 1px solid #e9ecef;
            }
            tr:hover {
                background: #f8f9fa;
            }
            .actions {
                display: flex;
                gap: 10px;
            }
            .btn-edit {
                background: #ffc107;
                color: #212529;
                padding: 8px 15px;
                border-radius: 6px;
                text-decoration: none;
                font-size: 12px;
                font-weight: 600;
                transition: all 0.2s;
            }
            .btn-delete {
                background: #dc3545;
                color: white;
                padding: 8px 15px;
                border-radius: 6px;
                text-decoration: none;
                font-size: 12px;
                font-weight: 600;
                transition: all 0.2s;
            }
            .btn-edit:hover, .btn-delete:hover {
                transform: translateY(-1px);
                text-decoration: none;
            }
            .password-cell {
                position: relative;
                cursor: pointer;
            }
            .blurred {
                filter: blur(6px);
                user-select: none;
            }
            .password-cell::after {
                content: '-click para ver-';
                position: absolute;
                left: 0;
                right: 0;
                top: 0;
                bottom: 0;
                display: flex;
                align-items: center;
                justify-content: center;
                background: rgba(255,255,255,0.8);
                color: #007bff;
                font-size: 12px;
                opacity: 0;
                transition: opacity 0.2s ease-in-out;
            }
            .password-cell:hover::after {
                opacity: 1;
            }
            .profile-badge {
                padding: 4px 8px;
                border-radius: 15px;
                font-size: 11px;
                font-weight: 600;
                text-align: center;
            }
            .admin-badge {
                background: #dc3545;
                color: white;
            }
            .user-badge {
                background: #28a745;
                color: white;
            }
            .guest-badge {
                background: #6c757d;
                color: white;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>? Lista de Usuarios Registrados</h1>
                <p>Gestión completa de usuarios del sistema</p>
            </div>

            <div class="content-section">
                <a href="RegistrarUsuario.jsp" class="btn-primary">? Registrar Nuevo Usuario</a>

                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>? Identificación</th>
                                <th>? Nombres</th>
                                <th>? Apellidos</th>
                                <th>? Email</th>
                                <th>? Usuario</th>
                                <th>? Contraseña</th>
                                <th>? Perfil</th>
                                <th>? Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                UsuarioDAO udao = new UsuarioDAO();
                                List<Usuario> lista = udao.listadoUsuarios();
                                for (Usuario a : lista) {
                                    String badgeClass = "";
                                    String perfilText = "";
                                    switch(a.getIdperfil()) {
                                        case 1: 
                                            badgeClass = "admin-badge";
                                            perfilText = "Administrador";
                                            break;
                                        case 2: 
                                            badgeClass = "user-badge";
                                            perfilText = "Usuario";
                                            break;
                                        case 3: 
                                            badgeClass = "guest-badge";
                                            perfilText = "Invitado";
                                            break;
                                    }
                            %>
                            <tr>
                                <td><%= a.getIdentificacion() %></td>
                                <td><%= a.getNombre() %></td>
                                <td><%= a.getApellido() %></td>
                                <td><%= a.getEmail() %></td>
                                <td><%= a.getUsuario() %></td>

                                <!-- Celda de contraseña con blur -->
                                <td class="password-cell" onclick="togglePassword(this)">
                                    <span class="blurred"><%= a.getClave() %></span>
                                </td>

                                <td>
                                    <span class="profile-badge <%= badgeClass %>">
                                        <%= perfilText %>
                                    </span>
                                </td>
                                <td>
                                    <div class="actions">
                                        <a href="EditarUsuario.jsp?id=<%= a.getIddato() %>" class="btn-edit">?? Editar</a>
                                        <a href="EliminarUsuario?id=<%= a.getIddato() %>" class="btn-delete" 
                                           onclick="return confirm('¿Estás seguro de eliminar al usuario <%= a.getNombre() %>?')">?? Eliminar</a>
                                    </div>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script>
            function togglePassword(cell) {
                const span = cell.querySelector("span");
                if (span.classList.contains("blurred")) {
                    span.classList.remove("blurred");
                    cell.style.background = "#eef6ff";
                } else {
                    span.classList.add("blurred");
                    cell.style.background = "transparent";
                }
            }
        </script>
    </body>
</html>