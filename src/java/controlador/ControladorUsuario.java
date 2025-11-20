package controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.*;

public class ControladorUsuario extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Verificar que todos los parámetros estén presentes
            String identificacion = request.getParameter("cidentificacion");
            String nombre = request.getParameter("cnombre");
            String apellido = request.getParameter("capellido");
            String email = request.getParameter("cmail");
            String usuario = request.getParameter("cusuario");
            String clave = request.getParameter("cclave");
            String perfilStr = request.getParameter("cidperfil");

            System.out.println("🔍 Parámetros recibidos:");
            System.out.println(" - Identificación: " + identificacion);
            System.out.println(" - Nombre: " + nombre);
            System.out.println(" - Apellido: " + apellido);
            System.out.println(" - Email: " + email);
            System.out.println(" - Usuario: " + usuario);
            System.out.println(" - Clave: " + clave);
            System.out.println(" - Perfil: " + perfilStr);

            // Validar parámetros requeridos
            if (identificacion == null || identificacion.trim().isEmpty() ||
                nombre == null || nombre.trim().isEmpty() ||
                apellido == null || apellido.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                usuario == null || usuario.trim().isEmpty() ||
                clave == null || clave.trim().isEmpty() ||
                perfilStr == null || perfilStr.trim().isEmpty()) {
                
                response.getWriter().println("❌ Error: Faltan parámetros requeridos en la solicitud.");
                response.getWriter().println("<br><a href='RegistrarUsuario.jsp'>Volver al formulario</a>");
                return;
            }

            int idperfil;
            try {
                idperfil = Integer.parseInt(perfilStr);
            } catch (NumberFormatException e) {
                idperfil = 2; // Valor por defecto: Usuario
            }

            Usuario u = new Usuario();
            u.setIdentificacion(identificacion.trim());
            u.setNombre(nombre.trim());
            u.setApellido(apellido.trim());
            u.setEmail(email.trim());
            u.setUsuario(usuario.trim());
            u.setClave(clave.trim());
            u.setIdperfil(idperfil);

            UsuarioDAO udao = new UsuarioDAO();
            int status = udao.agregarUsuario(u);

            if (status > 0) {
                System.out.println("✅ Usuario registrado exitosamente: " + usuario);
                response.sendRedirect("message.jsp?mensaje=Usuario registrado exitosamente");
            } else {
                System.out.println("❌ Error al registrar usuario en la base de datos");
                response.getWriter().println("❌ Error al registrar usuario en la base de datos.");
                response.getWriter().println("<br><a href='RegistrarUsuario.jsp'>Volver al formulario</a>");
            }

        } catch (Exception e) {
            System.out.println("❌ Error general en ControladorUsuario: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().println("❌ Error interno del servidor: " + e.getMessage());
            response.getWriter().println("<br><a href='RegistrarUsuario.jsp'>Volver al formulario</a>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Controlador para agregar usuario";
    }
}