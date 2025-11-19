package controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import modelo.Categoria;
import modelo.CategoriaDAO;

@WebServlet(name = "ControladorCategoria", urlPatterns = {"/ControladorCategoria"})
public class ControladorCategoria extends HttpServlet {

    CategoriaDAO categoriaDAO = new CategoriaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        switch (accion) {

            case "listar":
                request.setAttribute("categorias", categoriaDAO.listar());
                request.getRequestDispatcher("ListaCategorias.jsp").forward(request, response);
                break;

            case "eliminar":
                int idEliminar = Integer.parseInt(request.getParameter("id"));
                categoriaDAO.eliminar(idEliminar);
                response.sendRedirect("ControladorCategoria?accion=listar");
                break;

            case "editar":
                int idEditar = Integer.parseInt(request.getParameter("id"));
                Categoria cat = categoriaDAO.obtener(idEditar);
                request.setAttribute("categoria", cat);
                request.getRequestDispatcher("EditarCategoria.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect("ControladorCategoria?accion=listar");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        switch (accion) {

            case "agregar":
                Categoria nueva = new Categoria();
                nueva.setNombreCategoria(request.getParameter("nombre"));
                categoriaDAO.agregar(nueva);
                response.sendRedirect("ControladorCategoria?accion=listar");
                break;

            case "actualizar":
                Categoria actualizar = new Categoria();
                actualizar.setIdCategoria(Integer.parseInt(request.getParameter("id")));
                actualizar.setNombreCategoria(request.getParameter("nombre"));
                categoriaDAO.actualizar(actualizar);
                response.sendRedirect("ControladorCategoria?accion=listar");
                break;

            default:
                response.sendRedirect("ControladorCategoria?accion=listar");
                break;
        }
    }
}
