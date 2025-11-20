
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Documento" %>
<%
    // Mostrar mensajes
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Mis Documentos</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background: #f8f9fa;
        }
        .container {
            max-width: 1000px;
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
        .content {
            padding: 30px;
        }
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        .stat-number {
            font-size: 32px;
            font-weight: 700;
            color: #667eea;
            margin-bottom: 5px;
        }
        .stat-label {
            font-size: 14px;
            color: #6c757d;
        }
        .document-grid {
            display: grid;
            gap: 20px;
        }
        .document-card {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 20px;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .document-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .document-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 10px;
        }
        .document-title {
            font-size: 18px;
            font-weight: 600;
            color: #2c3e50;
            margin: 0;
        }
        .document-meta {
            display: flex;
            gap: 15px;
            font-size: 12px;
            color: #6c757d;
            margin-bottom: 10px;
        }
        .document-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        .btn-action {
            padding: 8px 15px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        .btn-download {
            background: #28a745;
            color: white;
        }
        .btn-edit {
            background: #ffc107;
            color: #212529;
        }
        .btn-delete {
            background: #dc3545;
            color: white;
        }
        .category-badge {
            background: #667eea;
            color: white;
            padding: 4px 8px;
            border-radius: 15px;
            font-size: 11px;
            font-weight: 600;
        }
        .no-documents {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }
        .upload-promt {
            text-align: center;
            margin-top: 20px;
        }
        .btn-upload {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            text-decoration: none;
            display: inline-block;
            font-weight: 600;
            transition: transform 0.2s;
        }
        .btn-upload:hover {
            transform: translateY(-2px);
            color: white;
            text-decoration: none;
        }
        .message {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
        }
        .success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📚 Mis Documentos</h1>
            <p>Gestiona los documentos que has subido a la plataforma</p>
        </div>

        <div class="content">
            <!-- Mostrar mensajes -->
            <% if (msg != null) { %>
                <div class="message success">
                    ✅ <%= msg %>
                </div>
            <% } %>
            <% if (error != null) { %>
                <div class="message error">
                    ❌ <%= error %>
                </div>
            <% } %>

            <%
                List<Documento> misDocumentos = (List<Documento>) request.getAttribute("misDocumentos");
                
                if (misDocumentos != null && !misDocumentos.isEmpty()) {
            %>
                <div class="stats">
                    <div class="stat-card">
                        <div class="stat-number"><%= misDocumentos.size() %></div>
                        <div class="stat-label">Total de Documentos</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <%= misDocumentos.stream().filter(d -> d.getVersion() != null && !d.getVersion().equals("1.0")).count() %>
                        </div>
                        <div class="stat-label">Documentos Actualizados</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <%= misDocumentos.stream().map(d -> d.getNombreCategoria()).distinct().count() %>
                        </div>
                        <div class="stat-label">Categorías Diferentes</div>
                    </div>
                </div>

                <div class="document-grid">
                    <%
                        for (Documento d : misDocumentos) {
                    %>
                        <div class="document-card">
                            <div class="document-header">
                                <h3 class="document-title"><%= d.getTitulo() %></h3>
                                <span class="category-badge"><%= d.getNombreCategoria() %></span>
                            </div>
                            
                            <div class="document-meta">
                                <span>📅 <%= d.getFechaCreacion() != null ? d.getFechaCreacion().toString().substring(0, 16) : "Fecha no disponible" %></span>
                                <span>🔢 Versión <%= d.getVersion() != null ? d.getVersion() : "1.0" %></span>
                                <span>👤 <%= d.getAutor() != null ? d.getAutor() : "Autor no especificado" %></span>
                            </div>

                            <% if (d.getDescripcion() != null && !d.getDescripcion().isEmpty()) { %>
                                <p><%= d.getDescripcion() %></p>
                            <% } %>

                            <div class="document-actions">
                                <a href="ControladorDocumento?action=descargar&id=<%= d.getIdDocumento() %>" 
                                   class="btn-action btn-download">📥 Descargar</a>
                                <a href="ControladorDocumento?action=editar&id=<%= d.getIdDocumento() %>" 
                                   class="btn-action btn-edit">✏️ Editar</a>
                                <a href="ControladorDocumento?action=eliminar&id=<%= d.getIdDocumento() %>" 
                                   class="btn-action btn-delete" 
                                   onclick="return confirm('¿Estás seguro de eliminar este documento?')">🗑️ Eliminar</a>
                            </div>
                        </div>
                    <%
                        }
                    %>
                </div>
            <%
                } else {
            %>
                <div class="no-documents">
                    <h3>📭 Aún no has subido documentos</h3>
                    <p>Comienza compartiendo tu primer documento académico</p>
                    <div class="upload-promt">
                        <a href="SubirDocumento.jsp" class="btn-upload">📤 Subir Mi Primer Documento</a>
                    </div>
                </div>
            <%
                }
            %>
        </div>
    </div>
</body>
</html>
