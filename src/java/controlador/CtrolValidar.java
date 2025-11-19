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
    // Obtener los parámetros correctamente
    String usu = request.getParameter("cusuario");  // Debe coincidir con 'name="cusuario"' en el formulario
    String cla = request.getParameter("cclave");    // Debe coincidir con 'name="cclave"' en el formulario

    // Verificar si los valores son correctos
    System.out.println("Usuario: " + usu);
    System.out.println("Contraseña: " + cla);

    // Llamada a LoginDAO para validar los datos
    Usuario datos = logindao.Login_datos(usu, cla); // Verifica que los datos se validen correctamente

    if (datos != null && datos.getUsuario() != null) {
        // Si el usuario es válido, creamos la sesión
        HttpSession sesion_cli = request.getSession(true);
        sesion_cli.setAttribute("nUsuario", datos.getUsuario());
        sesion_cli.setAttribute("perfilUsuario", datos.getIdperfil());

        // Redirigir al panel de administración o a la página correspondiente
        response.sendRedirect("cpanel.jsp");
    } else {
        // Si el usuario no es válido, redirigir al formulario de login
        request.setAttribute("error", "Usuario o contraseña incorrectos.");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}


    @Override
    public String getServletInfo() {
        return "Controlador para validar el login del usuario";
    }
}
