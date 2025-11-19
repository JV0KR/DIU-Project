<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Categoria" %>
<%@ page import="modelo.CategoriaDAO" %>

<%
    // Cargar categorías directamente desde el JSP
    CategoriaDAO catDao = new CategoriaDAO();
    List<Categoria> categorias = catDao.listar();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Subir Documento</title>

    <style>
        body { font-family: Arial; padding: 20px; }
        input, textarea, select { width: 300px; }
        label { font-weight: bold; }
    </style>
</head>

<body>

<h2>Subir Documento</h2>

<form action="ControladorDocumento" method="post" enctype="multipart/form-data">

    <label>Título:</label>
    <input type="text" name="titulo" required><br>

    <label>Descripción:</label>
    <textarea name="descripcion"></textarea><br>

    <label>Categoría:</label>
    <select name="id_categoria" required>
        <%
            for (Categoria c : categorias) {
        %>
            <option value="<%= c.getIdCategoria() %>">
                <%= c.getNombreCategoria() %>
            </option>
        <%
            }
        %>
    </select><br>

    <label>Archivo:</label>
    <input type="file" name="archivo" required><br><br>

    <button type="submit" name="action" value="insertar">
        Guardar documento
    </button>

</form>

</body>
</html>
