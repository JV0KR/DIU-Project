<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="modelo.DocumentoDAO" %>
<%@ page import="modelo.UsuarioDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Usuario" %>
<%
    DocumentoDAO docDao = new DocumentoDAO();
    UsuarioDAO userDao = new UsuarioDAO();
    
    // Obtener estadísticas
    int totalDocumentos = docDao.buscar("", 0).size();
    int totalUsuarios = userDao.listadoUsuarios().size();
    List<Usuario> usuariosRecientes = userDao.listadoUsuarios().subList(0, Math.min(5, userDao.listadoUsuarios().size()));
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Plataforma de Gestión Documental</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .dashboard-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .welcome-container { 
            text-align: center; 
            padding: 50px 30px; 
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            backdrop-filter: blur(10px);
        }
        .welcome-container h1 { 
            color: #2c3e50; 
            margin-bottom: 20px;
            font-size: 2.5em;
        }
        .welcome-container p { 
            color: #7f8c8d; 
            font-size: 18px;
            line-height: 1.6;
            max-width: 800px;
            margin: 0 auto;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        .stat-card {
            background: white;
            padding: 30px 25px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            border-left: 5px solid #667eea;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }
        .stat-icon {
            font-size: 3em;
            margin-bottom: 15px;
        }
        .stat-number {
            font-size: 2.5em;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        .stat-label {
            color: #7f8c8d;
            font-size: 1.1em;
            font-weight: 600;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
        }
        .info-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        .info-card h3 {
            color: #2c3e50;
            margin-top: 0;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f8f9fa;
            font-size: 1.3em;
        }
        .user-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .user-item {
            display: flex;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #f8f9fa;
        }
        .user-item:last-child {
            border-bottom: none;
        }
        .user-avatar {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            margin-right: 15px;
        }
        .user-info {
            flex: 1;
        }
        .user-name {
            font-weight: 600;
            color: #2c3e50;
        }
        .user-role {
            font-size: 0.85em;
            color: #7f8c8d;
        }
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 30px;
        }
        .action-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 20px;
            text-decoration: none;
            border-radius: 10px;
            transition: all 0.3s;
            font-weight: 600;
            text-align: center;
        }
        .action-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
            color: white;
            text-decoration: none;
        }
        .system-status {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #d4edda;
            color: #155724;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 600;
        }
        .feature-list {
            list-style: none;
            padding: 0;
        }
        .feature-list li {
            padding: 8px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .feature-list li::before {
            content: "✅";
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="welcome-container">
            <h1>👋 ¡Bienvenido a la Plataforma de Gestión Documental!</h1>
            <p>Sistema integral para la organización, almacenamiento y recuperación de documentos académicos departamentales.</p>
            
            <div style="margin: 30px 0;">
                <span class="system-status">✅ Sistema Activo y Operativo</span>
            </div>
        </div>

        <div class="info-grid">
            <!-- Información del Usuario -->
            <div class="info-card">
                <h3>👤 Información del Usuario</h3>
                <p><strong>Usuario activo:</strong> <%= session.getAttribute("nUsuario") %></p>
                <p><strong>Perfil ID:</strong> <%= session.getAttribute("idPerfil") %></p>
                <p><strong>Nombre:</strong> <%= session.getAttribute("nombreUsuario") %></p>
                <p><strong>Fecha de acceso:</strong> <%= new java.util.Date() %></p>
            </div>
            
            <!-- Permisos del Perfil -->
            <div class="info-card">
                <h3>🎭 Permisos del Perfil</h3>
                <%
                    Integer idPerfil = (Integer) session.getAttribute("idPerfil");
                    if (idPerfil != null) {
                        switch(idPerfil) {
                            case 1: 
                                out.print("<p><strong>Tipo:</strong> Administrador</p>");
                                out.print("<p><strong>Permisos:</strong> Acceso total al sistema</p>");
                                out.print("<ul class='feature-list'>");
                                out.print("<li>Gestión completa de usuarios</li>");
                                out.print("<li>Administración de documentos</li>");
                                out.print("<li>Control de permisos</li>");
                                out.print("<li>Reportes del sistema</li>");
                                out.print("</ul>");
                                break;
                            case 2: 
                                out.print("<p><strong>Tipo:</strong> Usuario Académico</p>");
                                out.print("<p><strong>Permisos:</strong> Gestión de documentos</p>");
                                out.print("<ul class='feature-list'>");
                                out.print("<li>Subir documentos</li>");
                                out.print("<li>Buscar y descargar</li>");
                                out.print("<li>Gestionar mis documentos</li>");
                                out.print("<li>Control de versiones</li>");
                                out.print("</ul>");
                                break;
                            case 3: 
                                out.print("<p><strong>Tipo:</strong> Invitado</p>");
                                out.print("<p><strong>Permisos:</strong> Consulta limitada</p>");
                                out.print("<ul class='feature-list'>");
                                out.print("<li>Búsqueda de documentos</li>");
                                out.print("<li>Descarga de archivos públicos</li>");
                                out.print("</ul>");
                                break;
                        }
                    }
                %>
            </div>
            
            <!-- Usuarios Recientes -->
            <div class="info-card">
                <h3>👥 Usuarios Recientes</h3>
                <ul class="user-list">
                    <%
                        for (Usuario usuario : usuariosRecientes) {
                            String inicial = usuario.getNombre().substring(0, 1).toUpperCase();
                    %>
                    <li class="user-item">
                        <div class="user-avatar"><%= inicial %></div>
                        <div class="user-info">
                            <div class="user-name"><%= usuario.getNombre() %> <%= usuario.getApellido() %></div>
                            <div class="user-role">
                                <%
                                    switch(usuario.getIdperfil()) {
                                        case 1: out.print("Administrador"); break;
                                        case 2: out.print("Usuario Académico"); break;
                                        case 3: out.print("Invitado"); break;
                                    }
                                %>
                            </div>
                        </div>
                    </li>
                    <%
                        }
                    %>
                </ul>
            </div>
        </div>
    </div>
</body>
</html>
