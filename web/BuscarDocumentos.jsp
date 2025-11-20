<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Documento" %>
<%@ page import="modelo.Categoria" %>
<%@ page import="modelo.CategoriaDAO" %>

<%
    // Cargar categorías al inicio de la página
    CategoriaDAO catDao = new CategoriaDAO();
    List<Categoria> categorias = catDao.listar();
    
    getServletContext().log("Categorías cargadas: " + (categorias != null ? categorias.size() : "null"));
%>

<!DOCTYPE html>
<html>
<head>
    <title>Búsqueda Avanzada de Documentos</title>
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
            border-color: #667eea;
        }
        .btn-search {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
        }
        .btn-download {
            background: #28a745;
            color: white;
        }
        .btn-history {
            background: #17a2b8;
            color: white;
        }
        .btn-edit {
            background: #ffc107;
            color: #212529;
        }
        .category-badge {
            background: #667eea;
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
            background: #e9ecef;
            border-radius: 8px;
        }
        .stat-item {
            text-align: center;
        }
        .stat-number {
            font-size: 24px;
            font-weight: 700;
            color: #667eea;
        }
        .stat-label {
            font-size: 12px;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🔍 Búsqueda Avanzada de Documentos</h1>
            <p>Encuentra documentos académicos utilizando múltiples criterios de búsqueda</p>
        </div>

        <div class="search-section">
            <form action="ControladorDocumento" method="GET">
                <input type="hidden" name="action" value="realizarBusqueda">

                <div class="form-grid">
                    <div class="form-group">
                        <label>📝 Título del Documento</label>
                        <input type="text" name="titulo" 
                               value="<%= request.getParameter("titulo") != null ? request.getParameter("titulo") : "" %>"
                               placeholder="Ingrese palabras clave...">
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
                                } else {
                            %>
                                <option value="0">No hay categorías disponibles</option>
                            <%
                                }
                            %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>👤 Autor</label>
                        <input type="text" name="autor" 
                               value="<%= request.getParameter("autor") != null ? request.getParameter("autor") : "" %>"
                               placeholder="Nombre del autor...">
                    </div>


                    <button type="submit" class="btn-search">🔍 Buscar</button>
                </div>
            </form>
        </div>

        <div class="results-section">
            <%
                List<Documento> documentos = (List<Documento>) request.getAttribute("documentos");

                if (documentos != null) {
            %>
                <div class="stats">
                    <div class="stat-item">
                        <div class="stat-number"><%= documentos.size() %></div>
                        <div class="stat-label">Documentos encontrados</div>
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
                            <span>👤 <%= d.getAutor() != null ? d.getAutor() : "Autor no especificado" %></span>
                            <span>📅 <%= d.getFechaCreacion() != null ? d.getFechaCreacion().toString().substring(0, 16) : "Fecha no disponible" %></span>
                            <span>🔢 Versión <%= d.getVersion() != null ? d.getVersion() : "1.0" %></span>
                        </div>

                        <% if (d.getDescripcion() != null && !d.getDescripcion().isEmpty()) { %>
                            <div class="document-description">
                                <%= d.getDescripcion() %>
                            </div>
                        <% } %>

                        <div class="document-actions">
                            <a href="ControladorDocumento?action=descargar&id=<%= d.getIdDocumento() %>" 
                               class="btn-action btn-download">📥 Descargar</a>
                            
                        </div>
                    </div>
                <%
                        }
                    } else {
                %>
                    <div class="no-results">
                        <h3>📭 No se encontraron documentos</h3>
                        <p>Intenta ajustar los criterios de búsqueda</p>
                    </div>
                <%
                    }
                } else {
                %>
                    <div class="no-results">
                        <h3>🔍 Realiza una búsqueda para ver resultados</h3>
                        <p>Utiliza los filtros arriba para encontrar documentos específicos</p>
                    </div>
                <%
                }
            %>
        </div>
    </div>
</body>
</html>
