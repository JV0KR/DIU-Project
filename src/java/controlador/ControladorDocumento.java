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
            default:
                response.getWriter().println("Acción no reconocida");
                break;
        }
    }

    private void insertarDocumento(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String titulo = request.getParameter("titulo");
            String descripcion = request.getParameter("descripcion");
            int idCategoria = Integer.parseInt(request.getParameter("id_categoria"));

            Part filePart = request.getPart("archivo");
            InputStream archivoStream = filePart.getInputStream();
            String tipoArchivo = filePart.getContentType();

            Documento d = new Documento();
            d.setTitulo(titulo);
            d.setDescripcion(descripcion);
            d.setIdCategoria(idCategoria);
            d.setArchivo(archivoStream);
            d.setTipoArchivo(tipoArchivo);

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

    // Metodo para realizar búsqueda
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

            System.out.println("Iniciando búsqueda:");
            System.out.println(" - Título: '" + titulo + "'");
            System.out.println(" - Categoría ID: " + idCategoria);

            List<Documento> resultados = dao.buscar(titulo, idCategoria);

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

    // Metodo para descargar documentos
    private void descargarDocumento(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idDocumento = Integer.parseInt(request.getParameter("id"));
            Documento documento = dao.obtenerArchivo(idDocumento);

            if (documento.getArchivo() != null) {
                // Obtener la extensión del archivo
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

// Metodo para obtener extensión del archivo
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
}
