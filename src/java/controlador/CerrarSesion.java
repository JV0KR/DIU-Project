package controlador;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class CerrarSesion extends HttpServlet {

    // Método para manejar tanto POST como GET
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

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession sesion_cli = request.getSession(false); // Recuperar la sesión existente
        try {
            if (sesion_cli != null) {
                sesion_cli.invalidate(); // Invalidar la sesión
            }
            response.sendRedirect("index.jsp"); // Redirigir al inicio después de cerrar sesión
        } catch (IOException e) {
            // Manejar error de sesión
            HttpSession ses = request.getSession(true);
            ses.setAttribute("mensaje", "Error al cerrar sesión.");
            ses.setAttribute("exc", e.toString());
            response.sendRedirect("error.jsp"); // Redirigir a una página de error si es necesario
        }
    }
}
