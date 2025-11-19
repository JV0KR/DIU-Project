package Interfaces;

import java.util.List;
import modelo.Usuario;

public interface CRUD {
    public int agregarUsuario(Usuario u);
    public int actualizarUsuarios(Usuario u);
    public int eliminarUsuarios(int id);
    public Usuario listarUsuarios_Id(int id);
    public List<Usuario> listadoUsuarios();
}
