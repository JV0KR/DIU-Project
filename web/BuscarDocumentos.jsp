<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Documento" %>
<%@ page import="modelo.Categoria" %>

<!DOCTYPE html>
<html>
<head>
    <title>Buscar Documentos</title>
    <style>
        body {
            font-family: Arial;
            margin: 20px;
        }
        .caja {
            background: #f9f9f9;
            padding: 20px;
            border-radius: 10px;
            max-width: 700px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 8px;
        }
        th {
            background: #eee;
        }
        input[type="text"], select {
            padding: 6px;
            width: 95%;
            margin-top: 5px;
            margin-bottom: 10px;
        }
        button {
            padding: 10px 15px;
            background: #0066cc;
            color: white;
            border: none;
            cursor: pointer;
        }
        button:hover {
            background: #004999;
        }
    </style>
</head>
<body>

<h2>🔍 Buscar Documentos</h2>

<div class="caja">
    <form action="ControladorDocumento" method="GET">
        <input type="hidden" name="action" value="realizarBusqueda"> <!-- ✅ CORREGIDO -->

        <label>Título:</label>
        <input type="text" name="titulo"
               value="<%= request.getParameter("titulo") != null ? request.getParameter("titulo") : "" %>">

        <label>Categoría:</label>
        <select name="id_categoria">
            <option value="0">Todas</option>

            <%
                List<Categoria> categorias = (List<Categoria>) request.getAttribute("categorias");
                String categoriaSel = request.getParameter("id_categoria") != null ? request.getParameter("id_categoria") : "0";

                if (categorias != null) {
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

        <button type="submit">Buscar</button>
    </form>
</div>

<h3>📄 Resultados</h3>

<table>
    <tr>
        <th>ID</th>
        <th>Título</th>
        <th>Categoría</th>
        <th>Fecha</th>
        <th>Descargar</th>
    </tr>

    <%
        List<Documento> documentos = (List<Documento>) request.getAttribute("documentos");

        if (documentos != null && !documentos.isEmpty()) {
            for (Documento d : documentos) {
    %>
        <tr>
            <td><%= d.getIdDocumento() %></td>
            <td><%= d.getTitulo() %></td>
            <td><%= d.getNombreCategoria() %></td>
            <td><%= d.getFechaCreacion() %></td>
            <td>
                <a href="ControladorDocumento?action=descargar&id=<%= d.getIdDocumento() %>">
                    Descargar
                </a>
            </td>
        </tr>

    <%
            }
        } else {
    %>
        <tr>
            <td colspan="5">No se encontraron documentos.</td>
        </tr>
    <%
        }
    %>
</table>

</body>
</html>