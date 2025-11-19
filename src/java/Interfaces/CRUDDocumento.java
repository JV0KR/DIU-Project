package Interfaces;

import java.util.List;
import modelo.Documento;

public interface CRUDDocumento {
    public List<Documento> listar();
    public Documento obtener(int id);
    public boolean agregar(Documento doc);
    public boolean actualizar(Documento doc);
    public boolean eliminar(int id);
}
