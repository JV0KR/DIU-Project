<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Panel - Registrar Usuario</title>
        <style>
            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                margin: 0;
                padding: 20px;
                background: #f8f9fa;
            }
            .container {
                max-width: 800px;
                margin: 40px auto;
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
            .form-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }
            .form-group {
                margin-bottom: 20px;
            }
            label {
                display: block;
                font-weight: 600;
                margin-bottom: 8px;
                color: #495057;
            }
            input[type="text"], input[type="password"], input[type="email"], select {
                width: 100%;
                padding: 12px;
                border: 2px solid #e9ecef;
                border-radius: 8px;
                font-size: 14px;
                transition: border-color 0.3s;
                box-sizing: border-box;
            }
            input[type="text"]:focus, input[type="password"]:focus, input[type="email"]:focus, select:focus {
                outline: none;
                border-color: #667eea;
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
                margin-top: 10px;
            }
            .btn-submit:hover {
                transform: translateY(-2px);
            }
            .btn-back {
                background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
                color: white;
                padding: 12px 30px;
                border-radius: 8px;
                text-decoration: none;
                display: inline-block;
                font-weight: 600;
                transition: transform 0.2s;
                margin-bottom: 20px;
            }
            .btn-back:hover {
                transform: translateY(-2px);
                color: white;
                text-decoration: none;
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
            .full-width {
                grid-column: 1 / span 2;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>👤 Registrar Nuevo Usuario</h1>
                <p>Agregar un nuevo usuario al sistema de gestión documental</p>
            </div>

            <div class="form-section">

                <form id="form1" name="form1" method="post" action="ControladorUsuario">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="cidentificacion" class="required">🆔 Identificación</label>
                            <input type="text" id="cidentificacion" name="cidentificacion" required
                                   placeholder="Número de identificación">
                        </div>

                        <div class="form-group">
                            <label for="cnombre" class="required">👤 Nombres</label>
                            <input type="text" id="cnombre" name="cnombre" required
                                   placeholder="Nombres del usuario">
                        </div>

                        <div class="form-group">
                            <label for="capellido" class="required">👥 Apellidos</label>
                            <input type="text" id="capellido" name="capellido" required
                                   placeholder="Apellidos del usuario">
                        </div>

                        <div class="form-group">
                            <label for="cmail" class="required">📧 Email</label>
                            <input type="email" id="cmail" name="cmail" required
                                   placeholder="correo@ejemplo.com">
                        </div>

                        <div class="form-group">
                            <label for="cusuario" class="required">🔐 Usuario</label>
                            <input type="text" id="cusuario" name="cusuario" required
                                   placeholder="Nombre de usuario">
                        </div>

                        <div class="form-group">
                            <label for="cclave" class="required">🔒 Contraseña</label>
                            <input type="password" id="cclave" name="cclave" required
                                   placeholder="Contraseña segura">
                        </div>

                        <div class="form-group full-width">
                            <label for="cidperfil" class="required">🎭 Perfil</label>
                            <select id="cidperfil" name="cidperfil" required>
                                <option value="">Seleccione un perfil</option>
                                <option value="1">👑 Administrador</option>
                                <option value="2">👤 Usuario Académico</option>
                                <option value="3">👀 Invitado</option>
                            </select>
                            <div class="help-text">
                                • Administrador: Acceso completo al sistema<br>
                                • Usuario Académico: Puede subir y gestionar documentos<br>
                                • Invitado: Solo consulta de documentos
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn-submit">
                        ➕ Registrar Usuario
                    </button>
                    
                    
                </form>
            </div>
        </div>
    </body>
</html>