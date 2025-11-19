package modelo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DocumentoDAO {

    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    public int insertar(Documento d) {
        int r = 0;
        String sql = "INSERT INTO documentos (titulo, descripcion, id_categoria, archivo, tipo_archivo, creado_en) "
                + "VALUES (?, ?, ?, ?, ?, NOW())";
        try {
            con = cn.crearConexion();
            ps = con.prepareStatement(sql);

            ps.setString(1, d.getTitulo());
            ps.setString(2, d.getDescripcion());
            ps.setInt(3, d.getIdCategoria());
            ps.setBlob(4, d.getArchivo());
            ps.setString(5, d.getTipoArchivo());

            r = ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return r;
    }

    public Documento obtenerArchivo(int id) {
        Documento d = new Documento();
        String sql = "SELECT titulo, archivo, tipo_archivo FROM documentos WHERE id_documento = ?";

        try {
            con = cn.crearConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                d.setTitulo(rs.getString("titulo"));
                d.setArchivo(rs.getBinaryStream("archivo"));
                d.setTipoArchivo(rs.getString("tipo_archivo"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return d;
    }

    public List<Documento> buscar(String nombre, int categoria) {
        List<Documento> lista = new ArrayList<>();

        String sql = "SELECT d.id_documento, d.titulo, d.creado_en, c.nombre_categoria "
                + "FROM documentos d INNER JOIN categorias c ON d.id_categoria = c.id_categoria "
                + "WHERE (d.titulo LIKE ? OR COALESCE(d.descripcion, '') LIKE ?) "
                + "AND (? = 0 OR d.id_categoria = ?) "
                + "ORDER BY d.id_documento DESC";

        try {
            con = cn.crearConexion();
            ps = con.prepareStatement(sql);

            String filtroTexto = "%" + nombre + "%";
            ps.setString(1, filtroTexto);
            ps.setString(2, filtroTexto);

            ps.setInt(3, categoria);
            ps.setInt(4, categoria);

            System.out.println("Ejecutando búsqueda:");
            System.out.println(" - Texto: " + nombre);
            System.out.println(" - Categoría: " + categoria);
            System.out.println(" - SQL: " + sql);

            rs = ps.executeQuery();

            int count = 0;
            while (rs.next()) {
                count++;
                Documento d = new Documento();
                d.setIdDocumento(rs.getInt("id_documento"));
                d.setTitulo(rs.getString("titulo"));
                d.setFechaCreacion(rs.getTimestamp("creado_en")); // ✅ Cambiado aquí también
                d.setNombreCategoria(rs.getString("nombre_categoria"));
                lista.add(d);

                System.out.println("Documento encontrado: " + d.getTitulo());
            }

            System.out.println("Total documentos encontrados: " + count);

        } catch (Exception e) {
            System.out.println("Error en búsqueda: " + e.getMessage());
            e.printStackTrace();
        }

        return lista;
    }
}
