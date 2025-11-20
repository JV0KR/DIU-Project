
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Documento" %>
<%@ page import="modelo.Categoria" %>
<%@ page import="modelo.CategoriaDAO" %>
<%@ page import="modelo.DocumentoDAO" %>

<%
    // Verificar permisos - SOLO ADMINISTRADORES
    HttpSession sesion = request.getSession(false);
    Integer idPerfil = (Integer) sesion.getAttribute("idPerfil");
    
    if (idPerfil == null || idPerfil != 1) {
        response.sendRedirect("noPermission.jsp");
        return;
    }

    // Cargar categorías
    CategoriaDAO catDao = new CategoriaDAO();
    List<Categoria> categorias = catDao.listar();
    
    // Obtener documentos (todos los documentos del sistema)
    DocumentoDAO docDao = new DocumentoDAO();
    List<Documento> documentos = docDao.buscar("", 0);
    
    // Mostrar mensajes
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Administración de Documentos</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background: #f8f9fa;
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .search-section {
            padding: 30px;
            background: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
        }
        .results-section {
            padding: 20px;
        }
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr auto;
            gap: 15px;
            align-items: end;
        }
        .form-group {
            display: flex;
            flex-direction: column;
        }
        label {
            font-weight: 600;
            margin-bottom: 5px;
            color: #495057;
        }
        input[type="text"], select {
            padding: 12px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        input[type="text"]:focus, select:focus {
            outline: none;
            border-color: #dc3545;
        }
        .btn-search {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: transform 0.2s;
        }
        .btn-search:hover {
            transform: translateY(-2px);
        }
        .document-card {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
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
        .document-description {
            color: #495057;
            margin: 10px 0;
            line-height: 1.5;
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
            transition: all 0.2s;
        }
        .btn-download {
            background: #28a745;
            color: white;
        }
        .btn-download:hover {
            background: #218838;
            color: white;
            text-decoration: none;
        }
        .btn-delete {
            background: #dc3545;
            color: white;
        }
        .btn-delete:hover {
            background: #c82333;
            color: white;
            text-decoration: none;
        }
        .category-badge {
            background: #dc3545;
            color: white;
            padding: 4px 8px;
            border-radius: 15px;
            font-size: 11px;
            font-weight: 600;
        }
        .no-results {
            text-align: center;
            padding: 40px;
            color: #6c757d;
        }
        .stats {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            padding: 15px;
            background: #f8d7da;
            border-radius: 8px;
            border-left: 4px solid #dc3545;
        }
        .stat-item {
            text-align: center;
        }
        .stat-number {
            font-size: 24px;
            font-weight: 700;
            color: #dc3545;
        }
        .stat-label {
            font-size: 12px;
            color: #721c24;
        }
        .admin-badge {
            background: #dc3545;
            color: white;
            padding: 4px 8px;
            border-radius: 15px;
            font-size: 11px;
            font-weight: 600;
            margin-left: 10px;
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
        .user-info {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }
        /* Modal de confirmación */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        .modal-content {
            background-color: white;
            margin: 15% auto;
            padding: 30px;
            border-radius: 10px;
            width: 400px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }
        .modal-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 25px;
        }
        .btn-confirm {
            background: #dc3545;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
        }
        .btn-cancel {
            background: #6c757d;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
        }
        .btn-confirm:hover {
            background: #c82333;
        }
        .btn-cancel:hover {
            background: #5a6268;
        }
        .warning-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🛡️ Administración de Documentos</h1>
            <p>Gestión completa de todos los documentos del sistema <span class="admin-badge">Solo Administrador</span></p>
        </div>

        <div class="search-section">
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

            <form action="ControladorDocumento" method="GET">
                <input type="hidden" name="action" value="adminBuscar">

                <div class="form-grid">
                    <div class="form-group">
                        <label>📝 Título del Documento</label>
                        <input type="text" name="titulo" 
                               value="<%= request.getParameter("titulo") != null ? request.getParameter("titulo") : "" %>"
                               placeholder="Buscar por título...">
                    </div>

                    <div class="form-group">
                        <label>📂 Categoría</label>
                        <select name="id_categoria">
                            <option value="0">Todas las categorías</option>
                            <%
                                String categoriaSel = request.getParameter("id_categoria") != null ? request.getParameter("id_categoria") : "0";
                                
                                if (categorias != null && !categorias.isEmpty()) {
                                    for (Categoria c : categorias) {
                            %>
                                <option value="<%= c.getIdCategoria() %>"
                                        <%= categoriaSel.equals(String.valueOf(c.getIdCategoria())) ? "selected" : "" %>>
                                    <%= c.getNombreCategoria() %>
                                </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>👤 Autor</label>
                        <input type="text" name="autor" 
                               value="<%= request.getParameter("autor") != null ? request.getParameter("autor") : "" %>"
                               placeholder="Buscar por autor...">
                    </div>

                    <button type="submit" class="btn-search">🔍 Buscar</button>
                </div>
            </form>
        </div>

        <div class="results-section">
            <div class="stats">
                <div class="stat-item">
                    <div class="stat-number"><%= documentos.size() %></div>
                    <div class="stat-label">Total de Documentos</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">
                        <%= documentos.stream().map(d -> d.getAutor()).distinct().count() %>
                    </div>
                    <div class="stat-label">Autores Diferentes</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">
                        <%= categorias.size() %>
                    </div>
                    <div class="stat-label">Categorías</div>
                </div>
            </div>

            <%
                if (!documentos.isEmpty()) {
                    for (Documento d : documentos) {
            %>
                <div class="document-card">
                    <div class="document-header">
                        <h3 class="document-title"><%= d.getTitulo() %></h3>
                        <span class="category-badge"><%= d.getNombreCategoria() %></span>
                    </div>
                    
                    <div class="document-meta">
                        <span>👤 <strong><%= d.getAutor() != null ? d.getAutor() : "Autor no especificado" %></strong></span>
                        <span>📅 <%= d.getFechaCreacion() != null ? d.getFechaCreacion().toString().substring(0, 16) : "Fecha no disponible" %></span>
                        <span>🔢 Versión <%= d.getVersion() != null ? d.getVersion() : "1.0" %></span>
                        <span>🆔 ID: <%= d.getIdDocumento() %></span>
                    </div>

                    <% if (d.getDescripcion() != null && !d.getDescripcion().isEmpty()) { %>
                        <div class="document-description">
                            <%= d.getDescripcion() %>
                        </div>
                    <% } %>

                    <div class="document-actions">
                        <a href="ControladorDocumento?action=descargar&id=<%= d.getIdDocumento() %>" 
                           class="btn-action btn-download">📥 Descargar</a>
                        
                        <button type="button" 
                                class="btn-action btn-delete" 
                                onclick="confirmarEliminacion(<%= d.getIdDocumento() %>, '<%= d.getTitulo().replace("'", "\\'") %>', '<%= d.getAutor() != null ? d.getAutor().replace("'", "\\'") : "Autor desconocido" %>')">
                            🗑️ Eliminar
                        </button>
                    </div>
                </div>
            <%
                    }
                } else {
            %>
                <div class="no-results">
                    <h3>📭 No hay documentos en el sistema</h3>
                    <p>Los documentos aparecerán aquí cuando los usuarios los suban</p>
                </div>
            <%
                }
            %>
        </div>
    </div>

    <!-- Modal de confirmación -->
    <div id="confirmModal" class="modal">
        <div class="modal-content">
            <div class="warning-icon">⚠️</div>
            <h3 style="color: #dc3545; margin-bottom: 10px;">Confirmar Eliminación</h3>
            <p id="modalMessage" style="color: #495057; line-height: 1.5;">
                ¿Está seguro de que desea eliminar este documento?
            </p>
            <div class="modal-buttons">
                <button type="button" class="btn-cancel" onclick="cancelarEliminacion()">Cancelar</button>
                <button type="button" class="btn-confirm" onclick="procederEliminacion()">Sí, Eliminar</button>
            </div>
        </div>
    </div>

    <script>
        let documentoAEliminar = null;
        let tituloDocumento = '';
        let autorDocumento = '';

        function confirmarEliminacion(id, titulo, autor) {
            documentoAEliminar = id;
            tituloDocumento = titulo;
            autorDocumento = autor;
            
            const modalMessage = document.getElementById('modalMessage');
            modalMessage.innerHTML = `
                <strong>"${titulo}"</strong><br>
                <small>Autor: ${autor}</small><br><br>
                <span style="color: #dc3545; font-weight: bold;">
                    ⚠️ Esta acción no se puede deshacer
                </span>
            `;
            
            document.getElementById('confirmModal').style.display = 'block';
        }

        function cancelarEliminacion() {
            documentoAEliminar = null;
            tituloDocumento = '';
            autorDocumento = '';
            document.getElementById('confirmModal').style.display = 'none';
        }

        function procederEliminacion() {
            if (documentoAEliminar) {
                window.location.href = `ControladorDocumento?action=adminEliminar&id=${documentoAEliminar}`;
            }
        }

        // Cerrar modal si se hace clic fuera del contenido
        window.onclick = function(event) {
            const modal = document.getElementById('confirmModal');
            if (event.target === modal) {
                cancelarEliminacion();
            }
        }

        // Cerrar modal con tecla ESC
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                cancelarEliminacion();
            }
        });
    </script>
</body>
</html>
