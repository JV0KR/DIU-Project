<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Documento" %>
<%@ page import="modelo.Categoria" %>
<%@ page import="modelo.CategoriaDAO" %>

<%
    // Verificar permisos
    HttpSession sesion = request.getSession(false);
    Integer idPerfil = (Integer) sesion.getAttribute("idPerfil");
    
    if (idPerfil != null && idPerfil == 3) {
        response.sendRedirect("noPermission.jsp");
        return;
    }

    // Cargar categorías
    CategoriaDAO catDao = new CategoriaDAO();
    List<Categoria> categorias = catDao.listar();
    
    Documento documento = (Documento) request.getAttribute("documento");
    if (documento == null) {
        response.sendRedirect("ControladorDocumento?action=misDocumentos&error=Documento no encontrado");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Editar Documento</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background: #f8f9fa;
        }
        .container {
            max-width: 800px;
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
        .form-section {
            padding: 30px;
        }
        .form-group {
            margin-bottom: 25px;
        }
        label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #495057;
        }
        input[type="text"], textarea, select {
            width: 100%;
            padding: 12px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s;
            box-sizing: border-box;
        }
        input[type="text"]:focus, textarea:focus, select:focus {
            outline: none;
            border-color: #667eea;
        }
        textarea {
            height: 100px;
            resize: vertical;
        }
        .btn-container {
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin-top: 20px;
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
            text-align: center;
            text-decoration: none;
            display: block;
            box-sizing: border-box;
        }
        .btn-cancel {
            background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
            color: white;
            border: none;
            padding: 15px 40px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: transform 0.2s;
            width: 100%;
            text-align: center;
            text-decoration: none;
            display: block;
            box-sizing: border-box;
        }
        .btn-submit:hover, .btn-cancel:hover {
            transform: translateY(-2px);
            text-decoration: none;
            color: white;
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
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
            <h1>✏️ Editar Documento</h1>
            <p>Actualiza la información de tu documento académico</p>
        </div>

        <div class="form-section">
            <%-- Mostrar mensajes --%>
            <%
                String msg = request.getParameter("msg");
                String error = request.getParameter("error");
                
                if (msg != null) {
            %>
                <div class="message success">
                    ✅ <%= msg %>
                </div>
            <%
                }
                if (error != null) {
            %>
                <div class="message error">
                    ❌ <%= error %>
                </div>
            <%
                }
            %>

            <form action="ControladorDocumento" method="post">
                <input type="hidden" name="action" value="actualizar">
                <input type="hidden" name="id_documento" value="<%= documento.getIdDocumento() %>">

                <div class="form-row">
                    <div class="form-group">
                        <label class="required">📝 Título del Documento</label>
                        <input type="text" name="titulo" value="<%= documento.getTitulo() != null ? documento.getTitulo() : "" %>" required 
                               placeholder="Ingrese el título del documento...">
                    </div>

                    <div class="form-group">
                        <label class="required">👤 Autor</label>
                        <input type="text" name="autor" value="<%= documento.getAutor() != null ? documento.getAutor() : "" %>" required
                               placeholder="Nombre del autor...">
                    </div>
                </div>

                <div class="form-group">
                    <label>📄 Descripción</label>
                    <textarea name="descripcion" 
                              placeholder="Proporcione una descripción del documento..."><%= documento.getDescripcion() != null ? documento.getDescripcion() : "" %></textarea>
                    <div class="help-text">Opcional: describa el contenido y propósito del documento</div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="required">📂 Categoría</label>
                        <select name="id_categoria" required>
                            <option value="">Seleccione una categoría</option>
                            <%
                                for (Categoria c : categorias) {
                            %>
                                <option value="<%= c.getIdCategoria() %>" 
                                    <%= (documento.getIdCategoria() == c.getIdCategoria()) ? "selected" : "" %>>
                                    <%= c.getNombreCategoria() %>
                                </option>
                            <%
                                }
                            %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>🔢 Versión</label>
                        <input type="text" name="version" value="<%= documento.getVersion() != null ? documento.getVersion() : "1.0" %>"
                               placeholder="Ej: 1.0, 2.1, etc.">
                        <div class="help-text">Versión del documento (opcional)</div>
                    </div>
                </div>

                <div class="btn-container">
                    <button type="submit" class="btn-submit">
                        💾 Guardar Cambios
                    </button>
                    
                    <a href="ControladorDocumento?action=misDocumentos" class="btn-cancel">
                        ↩️ Cancelar y Volver
                    </a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
