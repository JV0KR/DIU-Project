package modelo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DocumentoDAO {

    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    public int insertar(Documento d) {
    int r = 0;
    String sql = "INSERT INTO documentos (titulo, descripcion, id_categoria, archivo, tipo_archivo, autor, version, id_usuario, creado_en) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";
    try {
        con = cn.crearConexion();
        ps = con.prepareStatement(sql);

        ps.setString(1, d.getTitulo());
        ps.setString(2, d.getDescripcion());
        ps.setInt(3, d.getIdCategoria());
        ps.setBlob(4, d.getArchivo());
        ps.setString(5, d.getTipoArchivo());
        ps.setString(6, d.getAutor());
        ps.setString(7, d.getVersion());
        ps.setInt(8, d.getIdUsuario()); // ✅ AÑADIR ESTO

        r = ps.executeUpdate();

    } catch (Exception e) {
        e.printStackTrace();
    }
    return r;
}

public int actualizar(Documento d) {
    int r = 0;
    
    String sql = "UPDATE documentos SET titulo=?, descripcion=?, id_categoria=?, version=?, autor=?, actualizado_en=NOW() WHERE id_documento=?";
    try {
        con = cn.crearConexion();
        ps = con.prepareStatement(sql);

        ps.setString(1, d.getTitulo());
        ps.setString(2, d.getDescripcion());
        ps.setInt(3, d.getIdCategoria());
        ps.setString(4, d.getVersion());
        ps.setString(5, d.getAutor()); // ✅ AGREGAR ESTO
        ps.setInt(6, d.getIdDocumento());

        r = ps.executeUpdate();

        System.out.println("✅ Documento actualizado - ID: " + d.getIdDocumento() + ", Autor: " + d.getAutor());

    } catch (Exception e) {
        System.out.println("❌ Error al actualizar documento: " + e.getMessage());
        e.printStackTrace();
    } finally {
        cerrarRecursos();
    }
    return r;
}

    public Documento obtenerArchivo(int id) {
        Documento d = new Documento();
        String sql = "SELECT d.*, c.nombre_categoria FROM documentos d "
                   + "LEFT JOIN categorias c ON d.id_categoria = c.id_categoria "
                   + "WHERE d.id_documento = ?";

        try {
            con = cn.crearConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                d.setIdDocumento(rs.getInt("id_documento"));
                d.setTitulo(rs.getString("titulo"));
                d.setDescripcion(rs.getString("descripcion"));
                d.setArchivo(rs.getBinaryStream("archivo"));
                d.setTipoArchivo(rs.getString("tipo_archivo"));
                d.setAutor(rs.getString("autor"));
                d.setVersion(rs.getString("version"));
                d.setFechaCreacion(rs.getTimestamp("creado_en"));
                d.setNombreCategoria(rs.getString("nombre_categoria"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return d;
    }

    public List<Documento> buscar(String nombre, int categoria) {
        return buscarAvanzado(nombre, categoria, "");
    }

    public List<Documento> buscarAvanzado(String titulo, int categoria, String autor) {
    List<Documento> lista = new ArrayList<>();

    String sql = "SELECT d.id_documento, d.titulo, d.descripcion, d.autor, d.version, d.creado_en, c.nombre_categoria " +
            "FROM documentos d INNER JOIN categorias c ON d.id_categoria = c.id_categoria " +
            "WHERE (d.titulo LIKE ? OR COALESCE(d.descripcion, '') LIKE ?) " +
            "AND (? = 0 OR d.id_categoria = ?) " +
            "AND (? = '' OR d.autor LIKE ?) " +
            "ORDER BY d.creado_en DESC";

    try {
        con = cn.crearConexion();
        ps = con.prepareStatement(sql);

        String filtroTexto = "%" + (titulo != null ? titulo : "") + "%";
        String filtroAutor = "%" + (autor != null ? autor : "") + "%";
        
        ps.setString(1, filtroTexto);
        ps.setString(2, filtroTexto);
        ps.setInt(3, categoria);
        ps.setInt(4, categoria);
        ps.setString(5, autor != null ? autor : "");
        ps.setString(6, filtroAutor);

        System.out.println("Búsqueda avanzada ejecutada:");
        System.out.println(" - Título: " + titulo);
        System.out.println(" - Categoría: " + categoria);
        System.out.println(" - Autor: " + autor);

        rs = ps.executeQuery();

        int count = 0;
        while (rs.next()) {
            count++;
            Documento d = new Documento();
            d.setIdDocumento(rs.getInt("id_documento"));
            d.setTitulo(rs.getString("titulo"));
            d.setDescripcion(rs.getString("descripcion"));
            d.setAutor(rs.getString("autor"));
            d.setVersion(rs.getString("version"));
            d.setFechaCreacion(rs.getTimestamp("creado_en"));
            d.setNombreCategoria(rs.getString("nombre_categoria"));
            lista.add(d);
        }

        System.out.println("Total documentos encontrados: " + count);

    } catch (Exception e) {
        System.out.println("Error en búsqueda avanzada: " + e.getMessage());
        e.printStackTrace();
    }
    return lista;
}

    public List<Documento> obtenerPorAutor(String usuario) {
    List<Documento> lista = new ArrayList<>();
    String sql = "SELECT d.id_documento, d.titulo, d.descripcion, d.version, d.creado_en, c.nombre_categoria, d.autor " +
                 "FROM documentos d " +
                 "INNER JOIN categorias c ON d.id_categoria = c.id_categoria " +
                 "INNER JOIN datos u ON d.id_usuario = u.iddato " +
                 "WHERE u.usuario = ? ORDER BY d.creado_en DESC";

    try {
        con = cn.crearConexion();
        ps = con.prepareStatement(sql);
        ps.setString(1, usuario);
        rs = ps.executeQuery();

        while (rs.next()) {
            Documento d = new Documento();
            d.setIdDocumento(rs.getInt("id_documento"));
            d.setTitulo(rs.getString("titulo"));
            d.setDescripcion(rs.getString("descripcion"));
            d.setVersion(rs.getString("version"));
            d.setFechaCreacion(rs.getTimestamp("creado_en"));
            d.setNombreCategoria(rs.getString("nombre_categoria"));
            d.setAutor(rs.getString("autor"));
            lista.add(d);
        }

        System.out.println("Documentos encontrados para usuario " + usuario + ": " + lista.size());

    } catch (Exception e) {
        System.out.println("Error al obtener documentos por autor: " + e.getMessage());
        e.printStackTrace();
    }
    return lista;
}
    // Agrega este método para eliminar documentos
public int eliminar(int idDocumento) {
    int r = 0;
    String sql = "DELETE FROM documentos WHERE id_documento = ?";
    
    try {
        con = cn.crearConexion();
        ps = con.prepareStatement(sql);
        ps.setInt(1, idDocumento);
        r = ps.executeUpdate();
        
        System.out.println("Documento eliminado - ID: " + idDocumento);
    } catch (Exception e) {
        System.out.println("Error al eliminar documento: " + e.getMessage());
        e.printStackTrace();
    }
    return r;
}

// Método para obtener documento por ID (sin el archivo BLOB para edición)
public Documento obtenerParaEdicion(int id) {
    Documento d = new Documento();
    String sql = "SELECT d.*, c.nombre_categoria FROM documentos d "
               + "LEFT JOIN categorias c ON d.id_categoria = c.id_categoria "
               + "WHERE d.id_documento = ?";

    try {
        con = cn.crearConexion();
        ps = con.prepareStatement(sql);
        ps.setInt(1, id);
        rs = ps.executeQuery();

        if (rs.next()) {
            d.setIdDocumento(rs.getInt("id_documento"));
            d.setTitulo(rs.getString("titulo"));
            d.setDescripcion(rs.getString("descripcion"));
            d.setIdCategoria(rs.getInt("id_categoria"));
            d.setAutor(rs.getString("autor"));
            d.setVersion(rs.getString("version"));
            d.setFechaCreacion(rs.getTimestamp("creado_en"));
            d.setNombreCategoria(rs.getString("nombre_categoria"));
            
            System.out.println("✅ Documento cargado para edición - ID: " + id + ", Título: " + d.getTitulo());
        } else {
            System.out.println("❌ Documento no encontrado en BD - ID: " + id);
        }

    } catch (Exception e) {
        System.out.println("❌ Error en obtener Para Edicion - ID: " + id + " - " + e.getMessage());
        e.printStackTrace();
    }
    return d;
}

 public Map<String, Integer> obtenerDocumentosPorCategoria() {
        Map<String, Integer> docsPorCategoria = new HashMap<>();
        String sql = "SELECT c.nombre_categoria, COUNT(d.id_documento) as cantidad " +
                    "FROM categorias c " +
                    "LEFT JOIN documentos d ON c.id_categoria = d.id_categoria " +
                    "GROUP BY c.id_categoria, c.nombre_categoria " +
                    "ORDER BY cantidad DESC";
        
        try {
            con = cn.crearConexion();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                String categoria = rs.getString("nombre_categoria");
                int cantidad = rs.getInt("cantidad");
                docsPorCategoria.put(categoria, cantidad);
            }
            
        } catch (Exception e) {
            System.out.println("Error al obtener documentos por categoría: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos();
        }
        return docsPorCategoria;
    }

    // NUEVO MÉTODO: Obtener actividad mensual de documentos (REAL)
    public Map<String, Integer> obtenerActividadMensual() {
        Map<String, Integer> actividadMensual = new HashMap<>();
        String sql = "SELECT MONTHNAME(creado_en) as mes, COUNT(*) as cantidad " +
                    "FROM documentos " +
                    "WHERE YEAR(creado_en) = YEAR(CURDATE()) " +
                    "GROUP BY MONTH(creado_en), MONTHNAME(creado_en) " +
                    "ORDER BY MONTH(creado_en)";
        
        try {
            con = cn.crearConexion();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                String mes = rs.getString("mes");
                int cantidad = rs.getInt("cantidad");
                actividadMensual.put(mes, cantidad);
            }
            
        } catch (Exception e) {
            System.out.println("Error al obtener actividad mensual: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos();
        }
        return actividadMensual;
    }

    // NUEVO MÉTODO: Obtener total de documentos
    public int obtenerTotalDocumentos() {
        int total = 0;
        String sql = "SELECT COUNT(*) as total FROM documentos";
        
        try {
            con = cn.crearConexion();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                total = rs.getInt("total");
            }
            
        } catch (Exception e) {
            System.out.println("Error al obtener total de documentos: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos();
        }
        return total;
    }

    // Método auxiliar para cerrar recursos
    private void cerrarRecursos() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}