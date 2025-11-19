<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Panel - Registrar Usuario</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f5f5f5;
                margin: 0;
                padding: 0;
            }
            .container {
                width: 50%;
                margin: 40px auto;
                background-color: #fff;
                padding: 25px 40px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                border-radius: 8px;
            }

            form {
                display: grid;
                grid-template-columns: 150px 1fr;
                gap: 12px 15px;
                align-items: center;
            }

            form label {
                text-align: right;
                font-weight: bold;
            }

            form input, form select {
                width: 100%;
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 4px;
                font-size: 14px;
            }

            input[type="submit"] {
                grid-column: 1 / span 2;
                background-color: #007bff;
                color: white;
                padding: 12px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 16px;
                margin-top: 10px;
            }

            input[type="submit"]:hover {
                background-color: #0056b3;
            }

            .nav-link {
                margin-bottom: 20px;
            }

            .btn-nav {
                background-color: #007bff;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 15px;
            }

            .btn-nav:hover {
                background-color: #0056b3;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="nav-link">
                <form action="ListaUsuarios.jsp" method="get">
                    <button class="btn-nav" type="submit">Regresar</button>
                </form>

            </div>

            <h2>Registrar Usuario</h2>
            <form id="form1" name="form1" method="post" action="controladorUsuario">
                <label for="cidentificacion">Identificación:</label>
                <input type="text" id="cidentificacion" name="cidentificacion" required>

                <label for="cnombre">Nombre:</label>
                <input type="text" id="cnombre" name="cnombre" required>

                <label for="capellido">Apellido:</label>
                <input type="text" id="capellido" name="capellido" required>

                <label for="cmail">Email:</label>
                <input type="email" id="cmail" name="cmail" required>

                <label for="cusuario">Usuario:</label>
                <input type="text" id="cusuario" name="cusuario" required>

                <label for="cclave">Clave:</label>
                <input type="password" id="cclave" name="cclave" required>

                <label for="cidperfil">Perfil:</label>
                <select id="cidperfil" name="cidperfil" required>
                    <option value="1">Administrador</option>
                    <option value="2">Usuario</option>
                </select>

                <input type="submit" value="Registrar Usuario">
            </form>
        </div>
    </body>
</html>
