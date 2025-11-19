package modelo;

import Interfaces.CRUD;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO implements CRUD {

    // INSERTAR
    @Override
    public int agregarUsuario(Usuario u) {
        Conexion cn = new Conexion();
        int estatus = 0;

        String q = "INSERT INTO datos (identificacion, nombre, apellido, email, usuario, clave, idperfil) VALUES (?,?,?,?,?,?,?)";

        try (Connection con = cn.crearConexion();
             PreparedStatement ps = (con != null) ? con.prepareStatement(q) : null) {

            if (con == null || ps == null) {
                System.out.println("No se pudo establecer conexión a la base de datos");
                return 0;
            }

            ps.setString(1, u.getIdentificacion());
            ps.setString(2, u.getNombre());
            ps.setString(3, u.getApellido());
            ps.setString(4, u.getEmail());
            ps.setString(5, u.getUsuario());
            ps.setString(6, u.getClave());
            ps.setInt(7, u.getIdperfil());

            estatus = ps.executeUpdate();

            System.out.println("REGISTRO GUARDADO DE FORMA EXITOSA");
        } catch (SQLException ex) {
            System.out.println("ERROR AL REGISTRAR LA ACTIVIDAD");
            ex.printStackTrace();
        }
        return estatus;
    }

    // ACTUALIZAR
    @Override
    public int actualizarUsuarios(Usuario u) {
        Conexion cn = new Conexion();
        int estatus = 0;

        String q = "UPDATE datos SET identificacion=?, nombre=?, apellido=?, email=?, usuario=?, clave=?, idperfil=? WHERE iddato=?";

        try (Connection con = cn.crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {

            ps.setString(1, u.getIdentificacion());
            ps.setString(2, u.getNombre());
            ps.setString(3, u.getApellido());
            ps.setString(4, u.getEmail());
            ps.setString(5, u.getUsuario());
            ps.setString(6, u.getClave());
            ps.setInt(7, u.getIdperfil());
            ps.setInt(8, u.getIddato());

            estatus = ps.executeUpdate();
            System.out.println("REGISTRO ACTUALIZADO DE FORMA EXITOSA");
        } catch (SQLException ex) {
            System.out.println("ERROR AL ACTUALIZAR EL REGISTRO");
            ex.printStackTrace();
        }
        return estatus;
    }

    // ELIMINAR
    @Override
    public int eliminarUsuarios(int id) {
        Conexion cn = new Conexion();
        int estatus = 0;

        try (Connection con = cn.crearConexion();
             PreparedStatement ps = con.prepareStatement("DELETE FROM datos WHERE iddato = ?")) {

            ps.setInt(1, id);
            estatus = ps.executeUpdate();

            System.out.println("REGISTRO ELIMINADO DE FORMA EXITOSA");
        } catch (SQLException ex) {
            System.out.println("ERROR AL ELIMINAR EL REGISTRO");
            ex.printStackTrace();
        }
        return estatus;
    }

    // BUSCAR POR ID
    @Override
    public Usuario listarUsuarios_Id(int id) {
        Conexion cn = new Conexion();
        Usuario u = new Usuario();

        try (Connection con = cn.crearConexion();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM datos WHERE iddato = ?")) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    u.setIddato(rs.getInt("iddato"));
                    u.setIdentificacion(rs.getString("identificacion"));
                    u.setNombre(rs.getString("nombre"));
                    u.setApellido(rs.getString("apellido"));
                    u.setEmail(rs.getString("email"));
                    u.setUsuario(rs.getString("usuario"));
                    u.setClave(rs.getString("clave"));
                    u.setIdperfil(rs.getInt("idperfil"));
                }
            }
            System.out.println("REGISTRO ENCONTRADO CORRECTAMENTE");
        } catch (SQLException ex) {
            System.out.println("ERROR AL BUSCAR EL REGISTRO");
            ex.printStackTrace();
        }
        return u;
    }

    // LISTAR TODOS
    @Override
    public List<Usuario> listadoUsuarios() {
        List<Usuario> lista = new ArrayList<>();
        Conexion cn = new Conexion();

        try (Connection con = cn.crearConexion();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM datos");
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Usuario u = new Usuario();
                u.setIddato(rs.getInt("iddato"));
                u.setIdentificacion(rs.getString("identificacion"));
                u.setNombre(rs.getString("nombre"));
                u.setApellido(rs.getString("apellido"));
                u.setEmail(rs.getString("email"));
                u.setUsuario(rs.getString("usuario"));
                u.setClave(rs.getString("clave"));
                u.setIdperfil(rs.getInt("idperfil"));
                lista.add(u);
            }
            System.out.println("REGISTROS ENCONTRADOS DE FORMA EXITOSA");
        } catch (SQLException ex) {
            System.out.println("ERROR AL BUSCAR LOS REGISTROS");
            ex.printStackTrace();
        }
        return lista;
    }
}
