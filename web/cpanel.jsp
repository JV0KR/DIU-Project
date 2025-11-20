<%@page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="modelo.Conexion" %>

<%
    HttpSession sesion_cli = request.getSession(true);
    String nUsuario = (String) sesion_cli.getAttribute("nUsuario");
    Integer idPerfil = (Integer) sesion_cli.getAttribute("idPerfil");
    String nombreCompleto = (String) sesion_cli.getAttribute("nombreUsuario");

    // Redirigir si no hay sesión
    if (nUsuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>Dashboard - Plataforma de Gestión Documental</title>
    <style>
        body { 
            margin: 0; 
            padding: 0; 
            font-family: 'Segoe UI', Arial, sans-serif; 
            background-color: #f8f9fa;
        }
        .header { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; 
            padding: 20px 30px; 
            display: flex; 
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .user-info { 
            background: white; 
            padding: 25px; 
            margin: 0 0px 0px 0px; 
            border-radius: 0px; 
            border-bottom: 1px solid #dee2e6;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            
        }
        .dashboard-container {
            display: flex;
            min-height: calc(100vh - 140px);
        }
        .menu-lateral { 
            width: 300px; 
            padding: 25px; 
            background: white; 
            border-right: 1px solid #dee2e6;
            box-shadow: 2px 0 10px rgba(0,0,0,0.05);
        }
        .content-area {
            flex: 1;
            padding: 25px;
            background: #f8f9fa;
        }
        iframe { 
            width: 100%; 
            height: 700px; 
            border: none; 
            border-radius: 10px; 
            background: white;
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
        }
        .menu-item { 
            padding: 15px 20px; 
            margin: 10px 0; 
            background: white; 
            border-radius: 8px; 
            border-left: 4px solid #4CAF50; 
            transition: all 0.3s ease;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .menu-item a { 
            text-decoration: none; 
            color: #333; 
            display: block; 
            font-weight: 500;
            font-size: 14px;
        }
        .menu-item:hover { 
            background: #667eea; 
            transform: translateX(5px);
        }
        .menu-item:hover a {
            color: white;
        }
        .menu-section { 
            margin: 30px 0 15px 0; 
            padding-bottom: 10px; 
            border-bottom: 2px solid #667eea; 
            color: #2c3e50; 
            font-weight: bold;
            font-size: 16px;
        }
        .dashboard-link { 
            display: block; 
            text-align: center; 
            margin-top: 30px; 
            padding: 15px; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; 
            text-decoration: none; 
            border-radius: 8px; 
            font-weight: 600;
            transition: transform 0.2s;
        }
        .dashboard-link:hover { 
            transform: translateY(-2px);
            text-decoration: none;
            color: white;
        }
        .btn-logout {
            background: #e74c3c;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            transition: background 0.3s;
        }
        .btn-logout:hover {
            background: #c0392b;
            color: white;
            text-decoration: none;
        }
        .profile-badge {
            background: rgba(255,255,255,0.2); 
            padding: 8px 15px; 
            border-radius: 20px; 
            font-size: 14px;
            margin-left: 15px;
            backdrop-filter: blur(10px);
        }
        .welcome-user {
            font-size: 16px;
            margin-bottom: 10px;
            color: #2c3e50;
            font-weight: 600;
        }
        .system-name {
            font-size: 24px;
            font-weight: 700;
        }
        .menu-item.disabled {
            border-left-color: #95a5a6;
            background: #f8f9fa;
        }
        .menu-item.disabled a {
            color: #95a5a6;
            cursor: not-allowed;
        }
        .access-denied {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 10px 15px;
            margin: 10px 0;
            border-radius: 5px;
            font-size: 12px;
            color: #856404;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div>
            <div class="system-name">📚 Gestión Documental Académica</div>
            <div style="font-size: 14px; opacity: 0.9;">Plataforma de gestión de documentos departamentales</div>
        </div>
        <div style="text-align: right;">
           
            <div>
                <span class="profile-badge">
                    🎭 
                    <%
                        if (idPerfil != null) {
                            switch(idPerfil) {
                                case 1: out.print("Administrador"); break;
                                case 2: out.print("Usuario Académico"); break;
                                case 3: out.print("Invitado"); break;
                                default: out.print("No definido");
                            }
                        }
                    %>
                </span>
                <a href="CerrarSesion" class="btn-logout" style="margin-left: 15px;">🚪 Cerrar Sesión</a>
            </div>
        </div>
    </div>

    <!-- User Info -->
    <div class="user-info">
        <div class="welcome-user">👋 ¡Hola, <%= nombreCompleto != null ? nombreCompleto.split(" ")[0] : nUsuario %>! Bienvenido a la plataforma</div>
        <div>
            <strong>Usuario:</strong> <%= nUsuario %> | 
            <strong>Perfil ID:</strong> <%= idPerfil != null ? idPerfil : "No asignado" %> |
            <strong>Privilegios:</strong> 
            <%
                if (idPerfil != null) {
                    switch(idPerfil) {
                        case 1: out.print("Administrador"); break;
                        case 2: out.print("Usuario Académico"); break;
                        case 3: out.print("Invitado"); break;
                        default: out.print("No definido");
                    }
                }
            %>
        </div>
    </div>

    <!-- Dashboard Container -->
    <div class="dashboard-container">
        <!-- Menú lateral dinámico por perfil -->
        <div class="menu-lateral">
            <h3>🧭 Navegación Principal</h3>
            
            <!-- Dashboard - Acceso para todos -->

            <!-- Gestión de Documentos -->
            <div class="menu-section">📚 Gestión de Documentos</div>
            
            <!-- Subir Documento - Solo Admin y Usuarios Académicos -->
            <% if (idPerfil != null && (idPerfil == 1 || idPerfil == 2)) { %>
            <div class="menu-item">
                <a href="SubirDocumento.jsp" target="marcoDatos">
                    📤 Subir Nuevo Documento
                </a>
            </div>
            <% } %>
            
            <!-- Búsqueda Avanzada - Acceso para todos -->
            <div class="menu-item">
                <a href="ControladorDocumento?action=buscar" target="marcoDatos">
                    🔍 Búsqueda Avanzada
                </a>
            </div>
            
            <!-- Mis Documentos - Solo Admin y Usuarios Académicos -->
            <% if (idPerfil != null && (idPerfil == 1 || idPerfil == 2)) { %>
            <div class="menu-item">
                <a href="ControladorDocumento?action=misDocumentos" target="marcoDatos">
                    📁 Mis Documentos
                </a>
            </div>
            <% } %>
            
            <!-- Gestión de Usuarios (Solo Admin) -->
            <% if (idPerfil != null && idPerfil == 1) { %>
                        <div class="menu-section">👥 Administración</div>

                    <div class="menu-item">
                                  <a href="RegistrarUsuario.jsp" target="marcoDatos">
                                                👤 Registrar Usuario
                                    </a>
                                </div>

                                <div class="menu-item">
                                 <a href="ListaUsuarios.jsp" target="marcoDatos">
                                         📋 Listar Usuarios
                                    </a>
                                        </div>

<!-- NUEVO: Administración de Documentos -->
                    <div class="menu-item">
                     <a href="ControladorDocumento?action=adminDocumentos" target="marcoDatos">
        🗂️ Gestionar Documentos
             </a>
            </div>
                <% } %>
            
            <!-- Reportes y Estadísticas (Solo Admin) -->
            <% if (idPerfil != null && idPerfil == 1) { %>
            <div class="menu-section">📈 Reportes</div>
            <div class="menu-item">
                <a href="Reportes.jsp" target="marcoDatos">
                    📊 Estadísticas del Sistema
                </a>
            </div>
            <% } %>

            <!-- Mensaje de acceso limitado para Invitados -->
            <% if (idPerfil != null && idPerfil == 3) { %>
            <div class="access-denied">
                <strong>⚠️ Acceso Limitado</strong><br>
                Tu perfil de Invitado tiene acceso restringido a algunas funcionalidades.
            </div>
            <% } %>

            <!-- Enlace para volver al dashboard -->
            <a href="front.jsp" target="marcoDatos" class="dashboard-link">
                🏠 Volver al Dashboard Principal
            </a>

        </div>

        <!-- Área de contenido -->
        <div class="content-area">
            <iframe name="marcoDatos" src="front.jsp" frameborder="0"></iframe>
        </div>
    </div>

    <!-- Script para bloquear el retroceso -->
    <script>
        history.pushState(null, null, location.href);
        window.onpopstate = function () {
            history.go(1);
        };
    </script>
</body>
</html>
