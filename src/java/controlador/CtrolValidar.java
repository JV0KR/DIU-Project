package controlador;

import modelo.LoginDAO;
import modelo.Usuario;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class CtrolValidar extends HttpServlet {

    LoginDAO logindao = new LoginDAO();
    Usuario datos = new Usuario();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    String usu = request.getParameter("cusuario");
    String cla = request.getParameter("cclave");

    System.out.println("Usuario: " + usu);
    System.out.println("Contraseña: " + cla);

    Usuario datos = logindao.Login_datos(usu, cla);

    if (datos != null && datos.getUsuario() != null) {
        HttpSession sesion_cli = request.getSession(true);
        sesion_cli.setAttribute("nUsuario", datos.getUsuario());
        sesion_cli.setAttribute("idPerfil", datos.getIdperfil());
        sesion_cli.setAttribute("idUsuario", datos.getIddato()); // ✅ AÑADIR ESTO
        sesion_cli.setAttribute("nombreUsuario", datos.getNombre() + " " + datos.getApellido());

        response.sendRedirect("cpanel.jsp");
    } else {
        request.setAttribute("error", "Usuario o contraseña incorrectos.");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}

    @Override
    public String getServletInfo() {
        return "Controlador para validar el login del usuario";
    }
}
