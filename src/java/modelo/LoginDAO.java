package modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LoginDAO {

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs;

    public LoginDAO() {
    }

    public Usuario Login_datos(String usuario, String clave) {
    Usuario datos = null;
    try {
        Conexion cn = new Conexion();
        conn = cn.crearConexion();

        String query = "SELECT * FROM datos WHERE usuario = ? AND clave = ?";
        stmt = conn.prepareStatement(query);
        stmt.setString(1, usuario);
        stmt.setString(2, clave);

        rs = stmt.executeQuery();

        if (rs.next()) {
            datos = new Usuario();
            datos.setIddato(rs.getInt("iddato"));
            datos.setIdentificacion(rs.getString("identificacion"));
            datos.setNombre(rs.getString("nombre"));
            datos.setApellido(rs.getString("apellido"));
            datos.setEmail(rs.getString("email"));
            datos.setUsuario(rs.getString("usuario"));
            datos.setClave(rs.getString("clave"));
            datos.setIdperfil(rs.getInt("idperfil"));
        }
    } catch (SQLException e) {
        System.out.println("Error al verificar usuario: " + e.getMessage());
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            System.out.println("Error al cerrar recursos: " + e.getMessage());
        }
    }
    return datos;
}
}