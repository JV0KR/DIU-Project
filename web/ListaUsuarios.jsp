<%@ page import="java.util.List" %>
<%@ page import="modelo.UsuarioDAO" %>
<%@ page import="modelo.Usuario" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Panel - Lista de Usuarios</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f5f5f5;
                margin: 0;
                padding: 0;
            }
            
            .container {
                width: 90%;
                margin: 40px auto;
                background-color: #fff;
                padding: 25px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                border-radius: 8px;
            }
            table {
                border-collapse: collapse;
                width: 100%;
                background-color: #fff;
                border: 1px solid #ccc;
            }
            th, td {
                padding: 10px;
                border: 1px solid #ddd;
                text-align: center;
            }
            th {
                background-color: #007bff;
                color: white;
            }
            a {
                text-decoration: none;
                color: #007bff;
            }
            a:hover {
                text-decoration: underline;
            }
            .btn-nav {
                background-color: #007bff;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 15px;
                margin-bottom: 15px;
            }
            .btn-nav:hover {
                background-color: #0056b3;
            }

            .password-cell {
                position: relative;
                cursor: pointer;
            }
            .blurred {
                filter: blur(6px);
                user-select: none;
            }
            .password-cell::after {
                content: '-click para ver-';
                position: absolute;
                left: 0;
                right: 0;
                top: 0;
                bottom: 0;
                display: flex;
                align-items: center;
                justify-content: center;
                background: rgba(255,255,255,0.8);
                color: #007bff;
                font-size: 12px;
                opacity: 0;
                transition: opacity 0.2s ease-in-out;
            }
            .password-cell:hover::after {
                opacity: 1;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <form action="RegistrarUsuario.jsp" method="get">
                <button class="btn-nav" type="submit">Registrar nuevo usuario</button>
            </form>


            <h2>Listado de Usuarios</h2>
            <table>
                <tr>
                    <th>Identificación</th>
                    <th>Nombres</th>
                    <th>Apellidos</th>
                    <th>E-mail</th>
                    <th>Usuario</th>
                    <th>Contraseña</th>
                    <th>ID de Perfil</th>
                    <th>Acción</th>
                </tr>
                <%
                    UsuarioDAO udao = new UsuarioDAO();
                    List<Usuario> lista = udao.listadoUsuarios();
                    for (Usuario a : lista) {
                %>
                <tr>
                    <td><%=a.getIdentificacion()%></td>
                    <td><%=a.getNombre()%></td>
                    <td><%=a.getApellido()%></td>
                    <td><%=a.getEmail()%></td>
                    <td><%=a.getUsuario()%></td>

                    <!-- Celda de contraseña con blur -->
                    <td class="password-cell" onclick="togglePassword(this)">
                        <span class="blurred"><%=a.getClave()%></span>
                    </td>

                    <td><%=a.getIdperfil()%></td>
                    <td>
                        <a href="EditarUsuario.jsp?id=<%=a.getIddato()%>">Editar</a> |
                        <a href="EliminarUsuario?id=<%=a.getIddato()%>">Eliminar</a>
                    </td>
                </tr>
                <%
                    }
                %>
            </table>
        </div>

        <script>
            function togglePassword(cell) {
                const span = cell.querySelector("span");
                if (span.classList.contains("blurred")) {
                    span.classList.remove("blurred");
                    cell.querySelector("::after");
                    cell.style.background = "#eef6ff";
                } else {
                    span.classList.add("blurred");
                    cell.style.background = "transparent";
                }
            }
        </script>
    </body>
</html>
