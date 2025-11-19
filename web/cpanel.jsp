<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="modelo.Conexion" %>

<%
    HttpSession sesion_cli = request.getSession(true);
    String nUsuario = (String) sesion_cli.getAttribute("nUsuario");

    Connection con = null;
    Statement sentencia = null;
    ResultSet resultado = null;
    String nombre = null;
    String apellido = null;
    String usu = null;
%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Panel - Inicio</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f5f5f5;
                margin: 0;
                padding: 0;
            }
            header {
                background-color: #007bff;
                color: white;
                padding: 15px;
                text-align: center;
                font-size: 24px;
                font-weight: bold;
            }
            .container {
                width: 80%;
                margin: 40px auto;
                background-color: #fff;
                padding: 25px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                border-radius: 8px;
            }
            .btn-nav {
                background-color: #dc3545;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 16px;
                margin-bottom: 20px;
            }
            .btn-nav:hover {
                background-color: #c82333;
            }
            .btn-nav2 {
                background-color: #008000;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 16px;
                margin-bottom: 20px;
            }
            .btn-nav2:hover {
                background-color: #006400;
            }            
            iframe {
                width: 100%;
                height: 600px;
                border: none;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
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
                color: #007bff;
                text-decoration: none;
            }
            a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <header>Panel de Control</header>
        <div class="container">
            <%
                try {
                    Conexion cn = new Conexion();
                    con = cn.crearConexion();
                    sentencia = con.createStatement();
                    // Consulta para obtener los detalles del usuario logueado
                    resultado = sentencia.executeQuery("SELECT * from datos WHERE usuario ='" + nUsuario + "' ");
                    while (resultado.next()) {
                        nombre = resultado.getString("nombre");
                        apellido = resultado.getString("apellido");
                        usu = resultado.getString("usuario");
                    }
                } catch (Exception e) {
                    e.printStackTrace();  // Registra cualquier error en el servidor
                } finally {
                    if (con != null) {
                        try {
                            con.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                }
            %>

            <h3>Bienvenid@, <%= nombre%> <%= apellido%> - <%= usu%></h3>
            <!-- Botón de Cerrar Sesión -->
            <form action="CerrarSesion" method="post">
                <button class="btn-nav" type="submit">Cerrar Sesión</button>
            </form>
            <form action="SubirDocumento.jsp" method="post">
                <button class="btn-nav2" type="submit">Subir Documento</button>
            </form>
            <form action="BuscarDocumentos.jsp" method="post">
                <button class="btn-nav2" type="submit">Buscar Documentos</button>
            </form>

            <!-- Iframe que carga las páginas de gestionar y registrar usuarios -->
            <iframe src="ListaUsuarios.jsp" name="adminFrame" id="adminFrame"></iframe>




        </div>
    </body>
</html>
