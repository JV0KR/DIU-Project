<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Permiso Denegado</title>
    <style>
        .no-permission { 
            text-align: center; 
            padding: 60px 40px; 
            background: #fff3cd; 
            border: 1px solid #ffeaa7; 
            border-radius: 10px; 
            margin: 40px auto;
            max-width: 600px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        .no-permission h2 { 
            color: #856404; 
            margin-bottom: 20px;
        }
        .no-permission p { 
            color: #856404; 
            font-size: 16px;
            line-height: 1.6;
            margin-bottom: 30px;
        }
        .back-btn {
            display: inline-block;
            background: #3498db;
            color: white;
            padding: 12px 30px;
            text-decoration: none;
            border-radius: 6px;
            font-size: 16px;
            transition: 0.3s;
        }
        .back-btn:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }
        .icon {
            font-size: 64px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="no-permission">
        <div class="icon">🚫</div>
        <h2>Acceso Denegado</h2>
        <p>Lo sentimos, tu perfil de <strong>Invitado</strong> no tiene permisos para acceder a esta funcionalidad.</p>
        <p>Si necesitas acceso a estas funciones, contacta al administrador del sistema.</p>
        <a href="front.jsp" target="marcoDatos" class="dashboard-link">
                🏠 Volver al Dashboard
            </a>
    </div>
</body>
</html>