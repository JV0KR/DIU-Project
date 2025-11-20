package modelo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    public static String usuario = "root";
    public static String clave = "admin1234";
    public static String servidor = "localhost:3306";
    public static String BD = "documental";

    static Connection getConexion() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public Connection crearConexion() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String URL = "jdbc:mysql://" + servidor + "/" + BD + "?useSSL=false&serverTimezone=UTC";
            con = DriverManager.getConnection(URL, usuario, clave);
        } catch (ClassNotFoundException ex) {
            System.out.println("Driver JDBC no encontrado.");
            ex.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Error al conectar con la base de datos.");
            e.printStackTrace();
        }
        return con;
    }
}
    