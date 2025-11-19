package modelo;

import Interfaces.CRUDCategoria;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoriaDAO implements CRUDCategoria {

    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    @Override
    public List<Categoria> listar() {
        List<Categoria> lista = new ArrayList<>();
        String sql = "SELECT * FROM categorias";

        try {
            con = cn.crearConexion();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Categoria c = new Categoria();
                c.setIdCategoria(rs.getInt("id_categoria"));
                c.setNombreCategoria(rs.getString("nombre_categoria"));
                lista.add(c);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    @Override
    public Categoria obtener(int id) {
        Categoria c = new Categoria();
        String sql = "SELECT * FROM categorias WHERE id_categoria = ?";

        try {
            con = cn.crearConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                c.setIdCategoria(rs.getInt("id_categoria"));
                c.setNombreCategoria(rs.getString("nombre_categoria"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return c;
    }

    @Override
    public int agregar(Categoria c) {
        int r = 0;
        String sql = "INSERT INTO categorias (nombre_categoria) VALUES (?)";

        try {
            con = cn.crearConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, c.getNombreCategoria());
            r = ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return r;
    }

    @Override
    public int actualizar(Categoria c) {
        int r = 0;
        String sql = "UPDATE categorias SET nombre_categoria = ? WHERE id_categoria = ?";

        try {
            con = cn.crearConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, c.getNombreCategoria());
            ps.setInt(2, c.getIdCategoria());
            r = ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return r;
    }

    @Override
    public int eliminar(int id) {
        int r = 0;
        String sql = "DELETE FROM categorias WHERE id_categoria = ?";

        try {
            con = cn.crearConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            r = ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return r;
    }
}
