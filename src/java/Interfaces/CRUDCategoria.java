package Interfaces;

import java.util.List;
import modelo.Categoria;

public interface CRUDCategoria {
    public List<Categoria> listar();
    public Categoria obtener(int id);
    public int agregar(Categoria c);
    public int actualizar(Categoria c);
    public int eliminar(int id);
}
