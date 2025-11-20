<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Categoria" %>
<%@ page import="modelo.CategoriaDAO" %>
<%
    // Verificar permisos
    HttpSession sesion = request.getSession(false);
    Integer idPerfil = (Integer) sesion.getAttribute("idPerfil");
    Integer idUsuario = (Integer) sesion.getAttribute("idUsuario");
    String usuario = (String) sesion.getAttribute("nUsuario");
    
    // Si es invitado, redirigir a noPermission
    if (idPerfil != null && idPerfil == 3) {
        response.sendRedirect("noPermission.jsp");
        return;
    }
    
    // Si no hay sesión, redirigir al login
    if (usuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Cargar categorías
    CategoriaDAO catDao = new CategoriaDAO();
    List<Categoria> categorias = catDao.listar();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Subir Documento Académico</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background: #f8f9fa;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
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
        .form-group {
            margin-bottom: 25px;
        }
        label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #495057;
        }
        input[type="text"], textarea, select {
            width: 100%;
            padding: 12px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s;
            box-sizing: border-box;
        }
        input[type="text"]:focus, textarea:focus, select:focus {
            outline: none;
            border-color: #667eea;
        }
        textarea {
            height: 100px;
            resize: vertical;
        }
        .file-upload {
            border: 2px dashed #dee2e6;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            background: #f8f9fa;
            transition: border-color 0.3s;
            position: relative;
        }
        .file-upload:hover {
            border-color: #667eea;
        }
        .file-upload input[type="file"] {
            margin: 10px 0;
            width: 100%;
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
        }
        .btn-submit:hover {
            transform: translateY(-2px);
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
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
        .file-info {
            margin-top: 10px;
            padding: 10px;
            background: #e9ecef;
            border-radius: 5px;
            display: none;
        }
        .file-selected {
            border-color: #28a745 !important;
            background: #f8fff9 !important;
        }
        .file-selected-message {
            color: #28a745;
            font-weight: 600;
            margin: 10px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📤 Subir Documento Académico</h1>
            <p>Comparte documentos con la comunidad académica</p>
        </div>

        <div class="form-section">
            <form action="ControladorDocumento" method="post" enctype="multipart/form-data" id="documentForm">
                <div class="form-row">
                    <div class="form-group">
                        <label class="required">📝 Título del Documento</label>
                        <input type="text" name="titulo" required 
                               placeholder="Ingrese el título del documento...">
                    </div>

                    <div class="form-group">
                        <label class="required">👤 Autor</label>
                        <input type="text" name="autor" value="<%= usuario %>" required
                               placeholder="Nombre del autor...">
                    </div>
                </div>

                <div class="form-group">
                    <label>📄 Descripción</label>
                    <textarea name="descripcion" 
                              placeholder="Proporcione una descripción del documento..."></textarea>
                    <div class="help-text">Opcional: describa el contenido y propósito del documento</div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="required">📂 Categoría</label>
                        <select name="id_categoria" required>
                            <option value="">Seleccione una categoría</option>
                            <%
                                for (Categoria c : categorias) {
                            %>
                                <option value="<%= c.getIdCategoria() %>">
                                    <%= c.getNombreCategoria() %>
                                </option>
                            <%
                                }
                            %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>🔢 Versión</label>
                        <input type="text" name="version" value="1.0"
                               placeholder="Ej: 1.0, 2.1, etc.">
                        <div class="help-text">Versión del documento (opcional)</div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="required">📎 Archivo</label>
                    <div class="file-upload" id="fileUploadArea">
                        <div id="uploadMessage">
                            <p>🔼 Arrastra y suelta tu archivo aquí o haz clic para seleccionar</p>
                        </div>
                        <input type="file" name="archivo" id="archivoInput" required accept=".pdf,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.txt">
                        <div class="help-text">
                            Formatos permitidos: PDF, Word, Excel, PowerPoint, TXT (Máx. 50MB)
                        </div>
                    </div>
                    <div class="file-info" id="fileInfo">
                        <strong>✅ Archivo seleccionado:</strong> <span id="fileName"></span><br>
                        <strong>Tamaño:</strong> <span id="fileSize"></span>
                    </div>
                </div>

                <button type="submit" name="action" value="insertar" class="btn-submit">
                    💾 Guardar Documento
                </button>
            </form>
        </div>
    </div>

    <script>
        // Mejorar la experiencia de subida de archivos
        document.addEventListener('DOMContentLoaded', function() {
            const fileInput = document.getElementById('archivoInput');
            const fileUploadArea = document.getElementById('fileUploadArea');
            const fileInfo = document.getElementById('fileInfo');
            const fileName = document.getElementById('fileName');
            const fileSize = document.getElementById('fileSize');
            const uploadMessage = document.getElementById('uploadMessage');
            
            // Función para actualizar la interfaz cuando se selecciona un archivo
            function updateFileInfo(file) {
                if (file) {
                    fileName.textContent = file.name;
                    fileSize.textContent = (file.size / 1024 / 1024).toFixed(2) + ' MB';
                    fileInfo.style.display = 'block';
                    
                    fileUploadArea.classList.add('file-selected');
                    
                    // Crear el mensaje usando métodos DOM en lugar de template literals
                    uploadMessage.innerHTML = '';
                    
                    const message1 = document.createElement('p');
                    message1.className = 'file-selected-message';
                    message1.innerHTML = '✅ Archivo seleccionado: <strong>' + file.name + '</strong>';
                    uploadMessage.appendChild(message1);
                    
                    const message2 = document.createElement('p');
                    message2.textContent = 'Tamaño: ' + (file.size / 1024 / 1024).toFixed(2) + ' MB';
                    uploadMessage.appendChild(message2);
                    
                    const message3 = document.createElement('p');
                    message3.textContent = 'Haz clic para cambiar el archivo';
                    uploadMessage.appendChild(message3);
                }
            }
            
            // Event listener para cuando se selecciona un archivo
            fileInput.addEventListener('change', function(e) {
                if (this.files.length > 0) {
                    updateFileInfo(this.files[0]);
                }
            });

            // Drag and drop functionality
            fileUploadArea.addEventListener('dragover', function(e) {
                e.preventDefault();
                this.style.borderColor = '#667eea';
                this.style.background = '#f0f4ff';
            });

            fileUploadArea.addEventListener('dragleave', function(e) {
                e.preventDefault();
                if (!this.classList.contains('file-selected')) {
                    this.style.borderColor = '#dee2e6';
                    this.style.background = '#f8f9fa';
                }
            });

            fileUploadArea.addEventListener('drop', function(e) {
                e.preventDefault();
                const files = e.dataTransfer.files;
                if (files.length > 0) {
                    fileInput.files = files;
                    updateFileInfo(files[0]);
                    
                    // Disparar el evento change manualmente
                    const event = new Event('change');
                    fileInput.dispatchEvent(event);
                }
            });

            // Validación del formulario
            document.getElementById('documentForm').addEventListener('submit', function(e) {
                const titulo = this.querySelector('input[name="titulo"]').value.trim();
                const autor = this.querySelector('input[name="autor"]').value.trim();
                const categoria = this.querySelector('select[name="id_categoria"]').value;
                const archivoInput = this.querySelector('input[name="archivo"]');
                const archivo = archivoInput.files[0];
                
                // Validar campos requeridos
                if (!titulo) {
                    alert('Por favor, ingrese un título para el documento');
                    e.preventDefault();
                    return;
                }
                
                if (!autor) {
                    alert('Por favor, ingrese el autor del documento');
                    e.preventDefault();
                    return;
                }
                
                if (!categoria) {
                    alert('Por favor, seleccione una categoría');
                    e.preventDefault();
                    return;
                }
                
                if (!archivo) {
                    alert('Por favor, seleccione un archivo');
                    e.preventDefault();
                    return;
                }
                
                // Validar tamaño del archivo (50MB máximo)
                if (archivo.size > 50 * 1024 * 1024) {
                    alert('El archivo es demasiado grande. El tamaño máximo permitido es 50MB.');
                    e.preventDefault();
                    return;
                }
                
                // Validar tipo de archivo
                const allowedTypes = [
                    'application/pdf',
                    'application/msword',
                    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                    'application/vnd.ms-excel',
                    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                    'application/vnd.ms-powerpoint',
                    'application/vnd.openxmlformats-officedocument.presentationml.presentation',
                    'text/plain'
                ];
                
                if (!allowedTypes.includes(archivo.type)) {
                    alert('Tipo de archivo no permitido. Por favor, suba un archivo PDF, Word, Excel, PowerPoint o texto.');
                    e.preventDefault();
                    return;
                }
                
                // Si todo está bien, mostrar mensaje de confirmación
                if (!confirm('¿Está seguro de que desea subir este documento?')) {
                    e.preventDefault();
                    return;
                }
            });

            // Prevenir que el formulario se envíe si hay campos inválidos
            document.getElementById('documentForm').addEventListener('formdata', function(e) {
                console.log('Formulario enviado con datos:', e.formData);
            });
        });
    </script>
</body>
</html>
