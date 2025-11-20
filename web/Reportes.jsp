<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="modelo.DocumentoDAO" %>
<%@ page import="modelo.UsuarioDAO" %>
<%@ page import="modelo.CategoriaDAO" %>
<%@ page import="modelo.Categoria" %>

<%
    // Verificar permisos - SOLO ADMINISTRADORES
    HttpSession sesion = request.getSession(false);
    Integer idPerfil = (Integer) sesion.getAttribute("idPerfil");
    
    // Si no es administrador, redirigir a noPermission
    if (idPerfil == null || idPerfil != 1) {
        response.sendRedirect("noPermission.jsp");
        return;
    }

    // Obtener datos REALES para las estadísticas
    DocumentoDAO docDao = new DocumentoDAO();
    UsuarioDAO userDao = new UsuarioDAO();
    CategoriaDAO catDao = new CategoriaDAO();
    
    // Datos REALES de la base de datos
    int totalDocumentos = docDao.obtenerTotalDocumentos();
    int totalUsuarios = userDao.obtenerTotalUsuariosActivos();
    List<Categoria> categorias = catDao.listar();
    
    // Obtener estadísticas REALES
    Map<String, Integer> docsPorCategoria = docDao.obtenerDocumentosPorCategoria();
    Map<String, Integer> actividadMensual = docDao.obtenerActividadMensual();
    Map<String, Integer> usuariosPorMes = userDao.obtenerUsuariosPorMes();
    
    // Calcular promedios
    double promedioDocsPorUsuario = totalUsuarios > 0 ? (double) totalDocumentos / totalUsuarios : 0;
%>

<!DOCTYPE html>
<html>
<head>
    <title>Reportes y Estadísticas</title>
    <style>
        .reports-container { 
            padding: 20px; 
            max-width: 1200px; 
            margin: 0 auto;
        }
        .metrics-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); 
            gap: 20px; 
            margin: 20px 0;
        }
        .metric-card { 
            background: white; 
            padding: 25px; 
            border-radius: 10px; 
            text-align: center;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            border-left: 4px solid #667eea;
        }
        .metric-number {
            font-size: 2.5em;
            font-weight: 700;
            color: #2c3e50;
            margin: 10px 0;
        }
        .metric-label {
            color: #7f8c8d;
            font-size: 1.1em;
            font-weight: 600;
        }
        .chart-container { 
            background: white; 
            padding: 25px; 
            margin: 25px 0; 
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        .chart-title {
            color: #2c3e50;
            margin-bottom: 20px;
            border-bottom: 2px solid #f8f9fa;
            padding-bottom: 10px;
        }
        .bar-chart {
            display: flex;
            align-items: end;
            justify-content: space-around;
            height: 200px;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
        }
        .bar {
            background: #3498db;
            width: 40px;
            border-radius: 4px 4px 0 0;
            position: relative;
            transition: height 0.3s ease;
        }
        .bar:hover {
            background: #2980b9;
        }
        .bar-label {
            position: absolute;
            bottom: -25px;
            left: 0;
            right: 0;
            text-align: center;
            font-size: 12px;
            color: #7f8c8d;
        }
        .users-bar {
            background: #9b59b6;
        }
        .users-bar:hover {
            background: #8e44ad;
        }
        .activity-bar {
            background: #e74c3c;
        }
        .activity-bar:hover {
            background: #c0392b;
        }
        .table-container {
            overflow-x: auto;
            margin-top: 20px;
        }
        .stats-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }
        .stats-table th {
            background: #667eea;
            color: white;
            padding: 12px;
            text-align: left;
            font-weight: 600;
        }
        .stats-table td {
            padding: 12px;
            border-bottom: 1px solid #e9ecef;
        }
        .stats-table tr:hover {
            background: #f8f9fa;
        }
        .no-data {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
            font-style: italic;
        }
        .admin-badge {
            background: #dc3545;
            color: white;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            margin-left: 10px;
        }
    </style>
</head>
<body>
    <div class="reports-container">
        <h2>📈 Reportes y Estadísticas del Sistema <span class="admin-badge">Solo Administrador</span></h2>
        
        <!-- Métricas principales -->
        <div class="metrics-grid">
            <div class="metric-card">
                <div>📚</div>
                <div class="metric-number"><%= totalDocumentos %></div>
                <div class="metric-label">Total de Documentos</div>
            </div>
            
            <div class="metric-card">
                <div>👥</div>
                <div class="metric-number"><%= totalUsuarios %></div>
                <div class="metric-label">Usuarios Registrados</div>
            </div>
            
            <div class="metric-card">
                <div>📊</div>
                <div class="metric-number"><%= String.format("%.1f", promedioDocsPorUsuario) %></div>
                <div class="metric-label">Promedio por Usuario</div>
            </div>
            
            <div class="metric-card">
                <div>📂</div>
                <div class="metric-number"><%= categorias.size() %></div>
                <div class="metric-label">Categorías</div>
            </div>
        </div>
        
        <!-- Usuarios por Mes -->
        <div class="chart-container">
            <h3 class="chart-title">👥 Usuarios Registrados por Mes</h3>
            <% if (!usuariosPorMes.isEmpty()) { %>
                <div class="bar-chart">
                    <%
                        int maxUsers = usuariosPorMes.values().stream().max(Integer::compare).orElse(1);
                        for (Map.Entry<String, Integer> entry : usuariosPorMes.entrySet()) {
                            String mes = entry.getKey();
                            int cantidad = entry.getValue();
                            int altura = maxUsers > 0 ? (cantidad * 160) / maxUsers : 0;
                    %>
                    <div class="bar users-bar" style="height: <%= altura %>px;" title="<%= mes %>: <%= cantidad %> usuarios">
                        <div class="bar-label"><%= mes.substring(0, 3) %></div>
                    </div>
                    <% } %>
                </div>
                
                <!-- Tabla de usuarios por mes -->
                <div class="table-container">
                    <table class="stats-table">
                        <thead>
                            <tr>
                                <th>Mes</th>
                                <th>Usuarios Registrados</th>
                                <th>Porcentaje</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int totalUsuariosAnual = usuariosPorMes.values().stream().mapToInt(Integer::intValue).sum();
                                for (Map.Entry<String, Integer> entry : usuariosPorMes.entrySet()) {
                                    String mes = entry.getKey();
                                    int cantidad = entry.getValue();
                                    double porcentaje = totalUsuariosAnual > 0 ? (cantidad * 100.0) / totalUsuariosAnual : 0;
                            %>
                            <tr>
                                <td><strong><%= mes %></strong></td>
                                <td><%= cantidad %> usuarios</td>
                                <td><%= String.format("%.1f", porcentaje) %>%</td>
                            </tr>
                            <% } %>
                            <tr style="background: #f8f9fa; font-weight: bold;">
                                <td>Total Anual</td>
                                <td><%= totalUsuariosAnual %> usuarios</td>
                                <td>100%</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div class="no-data">
                    <p>📭 No hay datos de usuarios registrados por mes</p>
                </div>
            <% } %>
        </div>
        
        <!-- Documentos por Categoría -->
        <div class="chart-container">
            <h3 class="chart-title">📚 Documentos por Categoría</h3>
            <% if (!docsPorCategoria.isEmpty()) { %>
                <div class="bar-chart">
                    <%
                        int maxDocs = docsPorCategoria.values().stream().max(Integer::compare).orElse(1);
                        for (Map.Entry<String, Integer> entry : docsPorCategoria.entrySet()) {
                            String categoria = entry.getKey();
                            int cantidad = entry.getValue();
                            int altura = maxDocs > 0 ? (cantidad * 160) / maxDocs : 0;
                    %>
                    <div class="bar" style="height: <%= altura %>px;" title="<%= categoria %>: <%= cantidad %> documentos">
                        <div class="bar-label"><%= categoria.length() > 8 ? categoria.substring(0, 8) + "..." : categoria %></div>
                    </div>
                    <% } %>
                </div>
                
                <!-- Tabla de documentos por categoría -->
                <div class="table-container">
                    <table class="stats-table">
                        <thead>
                            <tr>
                                <th>Categoría</th>
                                <th>Documentos</th>
                                <th>Porcentaje</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (Map.Entry<String, Integer> entry : docsPorCategoria.entrySet()) {
                                    String categoria = entry.getKey();
                                    int cantidad = entry.getValue();
                                    double porcentaje = totalDocumentos > 0 ? (cantidad * 100.0) / totalDocumentos : 0;
                            %>
                            <tr>
                                <td><strong><%= categoria %></strong></td>
                                <td><%= cantidad %> documentos</td>
                                <td><%= String.format("%.1f", porcentaje) %>%</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div class="no-data">
                    <p>📭 No hay documentos registrados por categoría</p>
                </div>
            <% } %>
        </div>
        
        <!-- Actividad Mensual de Documentos -->
        <div class="chart-container">
            <h3 class="chart-title">📅 Actividad Mensual de Documentos</h3>
            <% if (!actividadMensual.isEmpty()) { %>
                <div class="bar-chart">
                    <%
                        int maxActividad = actividadMensual.values().stream().max(Integer::compare).orElse(1);
                        for (Map.Entry<String, Integer> entry : actividadMensual.entrySet()) {
                            String mes = entry.getKey();
                            int cantidad = entry.getValue();
                            int altura = maxActividad > 0 ? (cantidad * 160) / maxActividad : 0;
                    %>
                    <div class="bar activity-bar" style="height: <%= altura %>px;" title="<%= mes %>: <%= cantidad %> documentos">
                        <div class="bar-label"><%= mes.substring(0, 3) %></div>
                    </div>
                    <% } %>
                </div>
                
                <!-- Tabla de actividad mensual -->
                <div class="table-container">
                    <table class="stats-table">
                        <thead>
                            <tr>
                                <th>Mes</th>
                                <th>Documentos Subidos</th>
                                <th>Porcentaje</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int totalDocumentosAnual = actividadMensual.values().stream().mapToInt(Integer::intValue).sum();
                                for (Map.Entry<String, Integer> entry : actividadMensual.entrySet()) {
                                    String mes = entry.getKey();
                                    int cantidad = entry.getValue();
                                    double porcentaje = totalDocumentosAnual > 0 ? (cantidad * 100.0) / totalDocumentosAnual : 0;
                            %>
                            <tr>
                                <td><strong><%= mes %></strong></td>
                                <td><%= cantidad %> documentos</td>
                                <td><%= String.format("%.1f", porcentaje) %>%</td>
                            </tr>
                            <% } %>
                            <tr style="background: #f8f9fa; font-weight: bold;">
                                <td>Total Anual</td>
                                <td><%= totalDocumentosAnual %> documentos</td>
                                <td>100%</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div class="no-data">
                    <p>📭 No hay actividad de documentos este año</p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
