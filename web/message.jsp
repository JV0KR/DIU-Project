<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Panel - Mensaje</title>
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
                width: 50%;
                margin: 100px auto;
                background-color: #fff;
                padding: 30px;
                text-align: center;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                border-radius: 8px;
            }
            h1 {
                color: #28a745;
                font-size: 22px;
            }
            .btn-nav {
                background-color: #007bff;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 15px;
                text-decoration: none;
                display: inline-block;
                margin-top: 20px;
            }
            .btn-nav:hover {
                background-color: #0056b3;
            }
        </style>
    </head>
    <body>
        <header>Formulario</header>
        <div class="container">
            <h1>La información fue registrada con éxito</h1>
            <a href="index.jsp" class="btn-nav">Registrar otro usuario</a>
            <a href="ListaUsuarios.jsp" class="btn-nav">Ver lista de usuarios</a>
        </div>
    </body>
</html>
