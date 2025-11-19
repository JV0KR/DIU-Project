<%@ page import="modelo.UsuarioDAO" %>
<%@ page import="modelo.Usuario" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Panel - Editar Usuario</title>
        <style>
            body { font-family: Arial, sans-serif; background-color: #f5f5f5; margin: 40px; }
            table { border-collapse: collapse; width: 70%; background-color: #fff; border: 1px solid #ccc; }
            td { padding: 10px; border: 1px solid #ddd; }
            input[type=text], input[type=password] { width: 95%; padding: 6px; }
            input[type=submit] { padding: 8px 16px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; }
            input[type=submit]:hover { background-color: #0056b3; }
        </style>
    </head>
    <body>
        <%
            UsuarioDAO udao = new UsuarioDAO();
            int id = Integer.parseInt(request.getParameter("id"));
            Usuario a = udao.listarUsuarios_Id(id);
        %>

        <h2>Editar Usuario</h2>
        <form method="post" action="editarUsuario">
            <input type="hidden" name="cidd" value="<%=id%>"/>
            <table>
                <tr>
                    <td>Identificación</td>
                    <td><input type="text" name="cid" value="<%=a.getIdentificacion()%>"/></td>
                </tr>
                <tr>
                    <td>Nombres</td>
                    <td><input type="text" name="cnombre" value="<%=a.getNombre()%>"/></td>
                </tr>
                <tr>
                    <td>Apellidos</td>
                    <td><input type="text" name="capellido" value="<%=a.getApellido()%>"/></td>
                </tr>
                <tr>
                    <td>E-mail</td>
                    <td><input type="text" name="cmail" value="<%=a.getEmail()%>"/></td>
                </tr>
                <tr>
                    <td>Usuario</td>
                    <td><input type="text" name="cusuario" value="<%=a.getUsuario()%>"/></td>
                </tr>
                <tr>
                    <td>Clave</td>
                    <td><input type="password" name="cclave" value="<%=a.getClave()%>"/></td>
                </tr>
                <tr>
                    <td>Perfil</td>
                    <td><input type="text" name="cperfil" value="<%=a.getIdperfil()%>"/></td>
                </tr>
            </table>
            <p><input type="submit" value="Actualizar"/></p>
        </form>
    </body>
</html>
