<%@ page import="java.util.*, modelo.DocumentoDAO, modelo.Documento, modelo.CategoriaDAO, modelo.Categoria" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    String nombre = request.getParameter("buscar");
    if (nombre == null) nombre = "";

    int categoria = 0;
    try { categoria = Integer.parseInt(request.getParameter("categoria")); }
    catch (Exception e) {}

    DocumentoDAO dao = new DocumentoDAO();
    List<Documento> documentos = dao.buscar(nombre, categoria);

    CategoriaDAO cdao = new CategoriaDAO();
    List<Categoria> categorias = cdao.listar();
%>

<html>
<head>
    <title>Lista de Documentos</title>
</head>
<body>

<h2>Documentos</h2>

<form method="get" action="ControladorDocumento">
    <input type="hidden" name="accion" value="buscar">

    <input type="text" name="buscar" placeholder="Buscar por título" value="<%= nombre %>">

    <select name="categoria">
        <option value="0">Todas las categorías</option>
        <% for (Categoria c : categorias) { %>
            <option value="<%= c.getIdCategoria() %>" <%= (c.getIdCategoria() == categoria) ? "selected" : "" %>>
                <%= c.getNombreCategoria() %>
            </option>
        <% } %>
    </select>

    <button type="submit">Buscar</button>
</form>

<hr>

<table border="1">
    <tr>
        <th>ID</th>
        <th>Título</th>
        <th>Categoría</th>
        <th>Fecha</th>
        <th>Acciones</th>
    </tr>

    <% for (Documento d : documentos) { %>
        <tr>
            <td><%= d.getIdDocumento() %></td>
            <td><%= d.getTitulo() %></td>
            <td><%= d.getNombreCategoria() %></td>
            <td><%= d.getFechaCreacion() %></td>
            <td>
                <a href="ControladorDocumento?accion=descargar&id=<%= d.getIdDocumento() %>">Descargar</a>
            </td>
        </tr>
    <% } %>

</table>

</body>
</html>
