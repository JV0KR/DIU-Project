package modelo;

import java.io.InputStream;
import java.sql.Timestamp;

public class Documento {
    
    private int idUsuario;
    private int idDocumento;
    private String titulo;
    private String descripcion;
    private int idCategoria;
    private InputStream archivo;
    private String tipoArchivo;
    private Timestamp fechaCreacion;
    private String nombreCategoria;
    private String autor;
    private String version;
    private Timestamp fechaActualizacion;

    // Constructores
    public Documento() {}

    public Documento(int idDocumento, String titulo, String descripcion, int idCategoria, 
                    String autor, String version, Timestamp fechaCreacion) {
        this.idDocumento = idDocumento;
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.idCategoria = idCategoria;
        this.autor = autor;
        this.version = version;
        this.fechaCreacion = fechaCreacion;
    }

    // Getters / Setters
    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }
    
    public int getIdDocumento() { return idDocumento; }
    public void setIdDocumento(int idDocumento) { this.idDocumento = idDocumento; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public int getIdCategoria() { return idCategoria; }
    public void setIdCategoria(int idCategoria) { this.idCategoria = idCategoria; }

    public InputStream getArchivo() { return archivo; }
    public void setArchivo(InputStream archivo) { this.archivo = archivo; }

    public String getTipoArchivo() { return tipoArchivo; }
    public void setTipoArchivo(String tipoArchivo) { this.tipoArchivo = tipoArchivo; }

    public Timestamp getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(Timestamp fechaCreacion) { this.fechaCreacion = fechaCreacion; }

    public String getNombreCategoria() { return nombreCategoria; }
    public void setNombreCategoria(String nombreCategoria) { this.nombreCategoria = nombreCategoria; }

    public String getAutor() { return autor; }
    public void setAutor(String autor) { this.autor = autor; }

    public String getVersion() { return version; }
    public void setVersion(String version) { this.version = version; }

    public Timestamp getFechaActualizacion() { return fechaActualizacion; }
    public void setFechaActualizacion(Timestamp fechaActualizacion) { this.fechaActualizacion = fechaActualizacion; }
}