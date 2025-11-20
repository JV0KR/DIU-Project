package controlador;

import modelo.Documento;
import modelo.DocumentoDAO;
import modelo.CategoriaDAO;


import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ControladorDocumento")
@MultipartConfig(maxFileSize = 1024 * 1024 * 50)
public class ControladorDocumento extends HttpServlet {

    DocumentoDAO dao = new DocumentoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "nuevo";
        }

        switch (action) {
            case "nuevo":
                request.setAttribute("categorias", new CategoriaDAO().listar());
                request.getRequestDispatcher("SubirDocumento.jsp").forward(request, response);
                break;

            case "buscar":  
                request.setAttribute("categorias", new CategoriaDAO().listar());
                request.getRequestDispatcher("BuscarDocumentos.jsp").forward(request, response);
                break;

            case "realizarBusqueda":  
                realizarBusqueda(request, response);
                break;

            case "descargar":  
                descargarDocumento(request, response);
                break;
            case "adminDocumentos":
                 verAdminDocumentos(request, response);
                 break;
            case "adminBuscar":
                 adminBuscarDocumentos(request, response);
                 break;
            case "adminEliminar":
                 adminEliminarDocumento(request, response);
                 break;
            case "misDocumentos":
                verMisDocumentos(request, response);
                break;
            case "eliminar":
                eliminarDocumento(request, response);
                break;
            case "editar":
                cargarEdicionDocumento(request, response);
                break;
            default:
                response.sendRedirect("index.jsp");
                break;
            
                
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("message.jsp?msg=Acción inválida");
            return;
        }

        switch (action) {
            case "insertar":
                insertarDocumento(request, response);
                break;
            case "actualizar":
                actualizarDocumento(request, response);
                break;
            default:
                response.getWriter().println("Acción no reconocida");
                break;
        }
    }

   private void insertarDocumento(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    try {
        HttpSession session = request.getSession();
        String usuario = (String) session.getAttribute("nUsuario");
        Integer idUsuario = (Integer) session.getAttribute("idUsuario"); // ✅ OBTENER ID

        String titulo = request.getParameter("titulo");
        String descripcion = request.getParameter("descripcion");
        int idCategoria = Integer.parseInt(request.getParameter("id_categoria"));
        String autor = request.getParameter("autor");
        String version = request.getParameter("version");

        Part filePart = request.getPart("archivo");
        InputStream archivoStream = filePart.getInputStream();
        String tipoArchivo = filePart.getContentType();

        Documento d = new Documento();
        d.setTitulo(titulo);
        d.setDescripcion(descripcion);
        d.setIdCategoria(idCategoria);
        d.setArchivo(archivoStream);
        d.setTipoArchivo(tipoArchivo);
        d.setAutor(autor != null ? autor : usuario);
        d.setVersion(version != null ? version : "1.0");
        d.setIdUsuario(idUsuario != null ? idUsuario : 1); // ✅ ESTABLECER ID

        int saved = dao.insertar(d);

        if (saved == 1) {
            response.sendRedirect("message.jsp?msg=Documento guardado con éxito");
        } else {
            response.sendRedirect("message.jsp?msg=Error al guardar documento");
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().println("Error subiendo archivo: " + e.getMessage());
    }
}

   private void actualizarDocumento(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        int idDocumento = Integer.parseInt(request.getParameter("id_documento"));
        String titulo = request.getParameter("titulo");
        String descripcion = request.getParameter("descripcion");
        int idCategoria = Integer.parseInt(request.getParameter("id_categoria"));
        String version = request.getParameter("version");
        String autor = request.getParameter("autor"); // ✅ AGREGAR ESTO

        Documento d = new Documento();
        d.setIdDocumento(idDocumento);
        d.setTitulo(titulo);
        d.setDescripcion(descripcion);
        d.setIdCategoria(idCategoria);
        d.setVersion(version);
        d.setAutor(autor); // ✅ AGREGAR ESTO

        int updated = dao.actualizar(d);

        if (updated == 1) {
            response.sendRedirect("ControladorDocumento?action=misDocumentos&msg=Documento actualizado con éxito");
        } else {
            response.sendRedirect("ControladorDocumento?action=misDocumentos&error=Error al actualizar documento");
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("ControladorDocumento?action=misDocumentos&error=Error en actualización: " + e.getMessage());
    }
}
    private void realizarBusqueda(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String titulo = request.getParameter("titulo");
            if (titulo == null) {
                titulo = "";
            }

            int idCategoria = 0;
            try {
                idCategoria = Integer.parseInt(request.getParameter("id_categoria"));
            } catch (NumberFormatException e) {
                idCategoria = 0;
            }

            String autor = request.getParameter("autor");
            if (autor == null) {
                autor = "";
            }

            System.out.println("Búsqueda avanzada:");
            System.out.println(" - Título: '" + titulo + "'");
            System.out.println(" - Categoría ID: " + idCategoria);
            System.out.println(" - Autor: '" + autor + "'");

            List<Documento> resultados = dao.buscarAvanzado(titulo, idCategoria, autor);

            System.out.println("Resultados obtenidos: " + resultados.size() + " documentos");

            request.setAttribute("documentos", resultados);
            request.setAttribute("categorias", new CategoriaDAO().listar());

            request.getRequestDispatcher("BuscarDocumentos.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("Error en búsqueda: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("message.jsp?msg=Error en la búsqueda");
        }
    }

    private void descargarDocumento(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idDocumento = Integer.parseInt(request.getParameter("id"));
            Documento documento = dao.obtenerArchivo(idDocumento);

            if (documento.getArchivo() != null) {
                String extension = obtenerExtension(documento.getTipoArchivo(), documento.getTitulo());
                String nombreArchivo = documento.getTitulo() + extension;

                response.setContentType(documento.getTipoArchivo());
                response.setHeader("Content-Disposition",
                        "attachment; filename=\"" + nombreArchivo + "\"");

                System.out.println("📥 Descargando archivo:");
                System.out.println(" - ID: " + idDocumento);
                System.out.println(" - Título: " + documento.getTitulo());
                System.out.println(" - Tipo: " + documento.getTipoArchivo());
                System.out.println(" - Nombre archivo: " + nombreArchivo);

                InputStream is = documento.getArchivo();
                OutputStream os = response.getOutputStream();

                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = is.read(buffer)) != -1) {
                    os.write(buffer, 0, bytesRead);
                }

                is.close();
                os.flush();

            } else {
                response.sendRedirect("message.jsp?msg=Documento no encontrado");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("message.jsp?msg=Error al descargar");
        }
    }


    private void verMisDocumentos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String usuario = (String) session.getAttribute("nUsuario");
            
            List<Documento> misDocumentos = dao.obtenerPorAutor(usuario);
            request.setAttribute("misDocumentos", misDocumentos);
            request.getRequestDispatcher("MisDocumentos.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("message.jsp?msg=Error al cargar documentos");
        }
    }

    private String obtenerExtension(String tipoArchivo, String titulo) {
        switch (tipoArchivo) {
            case "application/pdf":
                return ".pdf";
            case "application/msword":
                return ".doc";
            case "application/vnd.openxmlformats-officedocument.wordprocessingml.document":
                return ".docx";
            case "application/vnd.ms-excel":
                return ".xls";
            case "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet":
                return ".xlsx";
            case "application/vnd.ms-powerpoint":
                return ".ppt";
            case "application/vnd.openxmlformats-officedocument.presentationml.presentation":
                return ".pptx";
            case "text/plain":
                return ".txt";
            case "image/jpeg":
                return ".jpg";
            case "image/png":
                return ".png";
            case "image/gif":
                return ".gif";
            default:
                if (titulo != null && titulo.contains(".")) {
                    return titulo.substring(titulo.lastIndexOf("."));
                }
                return ""; 
        }
    }
    
    private void eliminarDocumento(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        int idDocumento = Integer.parseInt(request.getParameter("id"));
        int resultado = dao.eliminar(idDocumento);
        
        if (resultado > 0) {
            response.sendRedirect("ControladorDocumento?action=misDocumentos&msg=Documento eliminado correctamente");
        } else {
            response.sendRedirect("ControladorDocumento?action=misDocumentos&error=Error al eliminar el documento");
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("ControladorDocumento?action=misDocumentos&error=Error en la eliminación");
    }
}

private void cargarEdicionDocumento(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        int idDocumento = Integer.parseInt(request.getParameter("id"));
        System.out.println("Cargando edición para documento ID: " + idDocumento);
        
        Documento documento = dao.obtenerParaEdicion(idDocumento);
        
        if (documento.getIdDocumento() == 0) {
            System.out.println("Documento no encontrado en la base de datos");
            response.sendRedirect("ControladorDocumento?action=misDocumentos&error=Documento no encontrado");
            return;
        }
        
        System.out.println("Documento encontrado: " + documento.getTitulo());
        
        request.setAttribute("documento", documento);
        request.setAttribute("categorias", new CategoriaDAO().listar());
        request.getRequestDispatcher("EditarDocumento.jsp").forward(request, response);
        
    } catch (Exception e) {
        System.out.println("Error al cargar edición: " + e.getMessage());
        e.printStackTrace();
        response.sendRedirect("ControladorDocumento?action=misDocumentos&error=Error al cargar edición: " + e.getMessage());
    }
}

private void verAdminDocumentos(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        // Verificar que sea administrador
        HttpSession session = request.getSession();
        Integer idPerfil = (Integer) session.getAttribute("idPerfil");
        
        if (idPerfil == null || idPerfil != 1) {
            response.sendRedirect("noPermission.jsp");
            return;
        }
        
        // Obtener todos los documentos
        List<Documento> documentos = dao.buscar("", 0);
        request.setAttribute("documentos", documentos);
        request.setAttribute("categorias", new CategoriaDAO().listar());
        request.getRequestDispatcher("AdminDocumentos.jsp").forward(request, response);
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("message.jsp?msg=Error al cargar administración de documentos");
    }
}

private void adminBuscarDocumentos(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        // Verificar que sea administrador
        HttpSession session = request.getSession();
        Integer idPerfil = (Integer) session.getAttribute("idPerfil");
        
        if (idPerfil == null || idPerfil != 1) {
            response.sendRedirect("noPermission.jsp");
            return;
        }

        String titulo = request.getParameter("titulo");
        if (titulo == null) titulo = "";

        int idCategoria = 0;
        try {
            idCategoria = Integer.parseInt(request.getParameter("id_categoria"));
        } catch (NumberFormatException e) {
            idCategoria = 0;
        }

        String autor = request.getParameter("autor");
        if (autor == null) autor = "";

        List<Documento> resultados = dao.buscarAvanzado(titulo, idCategoria, autor);
        
        request.setAttribute("documentos", resultados);
        request.setAttribute("categorias", new CategoriaDAO().listar());
        request.getRequestDispatcher("AdminDocumentos.jsp").forward(request, response);

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("AdminDocumentos.jsp?error=Error en la búsqueda");
    }
}

private void adminEliminarDocumento(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        // Verificar que sea administrador
        HttpSession session = request.getSession();
        Integer idPerfil = (Integer) session.getAttribute("idPerfil");
        
        if (idPerfil == null || idPerfil != 1) {
            response.sendRedirect("noPermission.jsp");
            return;
        }

        int idDocumento = Integer.parseInt(request.getParameter("id"));
        int resultado = dao.eliminar(idDocumento);
        
        if (resultado > 0) {
            response.sendRedirect("ControladorDocumento?action=adminDocumentos&msg=Documento eliminado correctamente");
        } else {
            response.sendRedirect("ControladorDocumento?action=adminDocumentos&error=Error al eliminar el documento");
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("ControladorDocumento?action=adminDocumentos&error=Error en la eliminación: " + e.getMessage());
    }
}
}
