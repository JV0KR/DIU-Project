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
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String identificacion = request.getParameter("cidentificacion");
        String nombre = request.getParameter("cnombre");
        String apellido = request.getParameter("capellido");
        String email = request.getParameter("cmail");
        String usuario = request.getParameter("cusuario");
        String clave = request.getParameter("cclave");
        String perfilStr = request.getParameter("cidperfil");

        if (identificacion == null || nombre == null || apellido == null ||
            email == null || usuario == null || clave == null || perfilStr == null) {
            response.getWriter().println("Faltan parámetros en la solicitud.");
            return;
        }

        int idperfil;
        try {
            idperfil = Integer.parseInt(perfilStr);
        } catch (NumberFormatException e) {
            idperfil = 2; 
        }

        Usuario u = new Usuario();
        u.setIdentificacion(identificacion);
        u.setNombre(nombre);
        u.setApellido(apellido);
        u.setEmail(email);
        u.setUsuario(usuario);
        u.setClave(clave);
        u.setIdperfil(idperfil);

        UsuarioDAO udao = new UsuarioDAO();
        int status = udao.agregarUsuario(u);

        if (status > 0) {
            response.sendRedirect("message.jsp");
        } else {
            response.getWriter().println("Error al registrar usuario");
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
