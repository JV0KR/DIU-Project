package modelo;

public class Usuario {

    int iddato;
    String identificacion;
    String nombre;
    String apellido;
    String email;
    String usuario;
    String clave;
    int idperfil;

    public Usuario() {
    }

    public Usuario(int iddato, String identificacion, String nombre, String apellido, String email, String usuario,
            String clave, int idperfil) {
        this.iddato = iddato;
        this.identificacion = identificacion;
        this.nombre = nombre;
        this.apellido = apellido;
        this.email = email;
        this.usuario = usuario;
        this.clave = clave;
        this.idperfil = idperfil;
    }

    public int getIddato() {
        return iddato;
    }

    public void setIddato(int iddato) {
        this.iddato = iddato;
    }

    public String getIdentificacion() {
        return identificacion;
    }

    public void setIdentificacion(String identificacion) {
        this.identificacion = identificacion;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellido() {
        return apellido;
    }

    public void setApellido(String apellido) {
        this.apellido = apellido;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getUsuario() {
        return usuario;
    }

    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }

    public String getClave() {
        return clave;
    }

    public void setClave(String clave) {
        this.clave = clave;
    }

    public int getIdperfil() {
        return idperfil;
    }

    public void setIdperfil(int idperfil) {
        this.idperfil = idperfil;
    }
}
