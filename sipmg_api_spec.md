# Especificaciones Técnicas del Proyecto SIPMG

## 1. Resumen del Proyecto

El "Sistema de Información de la Policía Municipal de Guaicaipuro" (SIPMG) es una aplicación web diseñada para digitalizar y centralizar la gestión de registros de detenidos. Proporciona funcionalidades para el manejo de datos filiatorios, historial de detenciones, procesos de egreso y generación de reportes, todo ello controlado por un sistema de roles y permisos.

## 2. Stack Tecnológico

-   **Frontend:**
    -   **Lenguajes:** HTML5, CSS3, JavaScript (ES5)
    -   **Librerías:** jQuery 3.x, Materialize CSS
-   **Backend:**
    -   **Lenguaje:** PHP 7.x / Python 3.x
    -   **Servidor:** Apache (recomendado)
-   **Base de Datos:**
    -   **SGBD:** MySQL / MariaDB / PostgreSQL
-   **Herramientas Adicionales:**
    -   **Generación de PDF:** Dompdf

## 3. Arquitectura de la Aplicación

El proyecto sigue una arquitectura monolítica con una clara separación entre el cliente (frontend) y el servidor (backend), aunque no es una SPA (Single Page Application).

-   **Frontend:** Se encarga de la presentación de la interfaz de usuario y la interacción inicial. Utiliza jQuery para la manipulación del DOM, peticiones AJAX para comunicarse con el backend y Materialize CSS para el diseño y los componentes visuales.
-   **Backend:** Escrito en PHP y Python (nueva versión), gestiona la lógica de negocio, el acceso a la base de datos y la seguridad. Expone una serie de scripts (ej. `backend.php`, `backend_detencion.php`) que actúan como endpoints para las peticiones AJAX del frontend.
-   **Base de Datos:** Almacena toda la información de la aplicación de forma relacional.

## 4. Esquema de la Base de Datos

La base de datos es el núcleo del sistema y está diseñada para relacionar de manera eficiente la información de los detenidos con sus respectivos eventos.

### Diagrama Entidad-Relación (Mermaid)

```mermaid
erDiagram
    ROLES {
        int rol_id PK
        varchar nombre_rol
    }
    USUARIOS {
        int usuario_id PK
        varchar nombre
        varchar apellido
        varchar correo
        varchar usuario
        varchar password_hash
        int rol_idfk FK
    }
    CIUDADANOS {
        int ciudadano_id PK
        varchar nacionalidad
    }
    DIRECCIONES {
        int direccion_id PK
        varchar estado
        varchar municipio
        text direccion
    }
    DETENIDOS {
        int detenido_id PK
        varchar cedula
        int ciudadano_idfk FK
    }
    DETALLE_DETENIDOS {
        int detalle_detenido_id PK
        varchar primer_nombre
        varchar segundo_nombre
        varchar primer_apellido
        varchar segundo_apellido
        date fecha_nacimiento
        int edad
        int sexo
        varchar nombre_foto
        varchar ruta_foto
        int detenido_idfk FK
        int direccion_idfk FK
    }
    ORGANISMOS {
        int organismo_id PK
        varchar codigo_organismo
        varchar nombre
        text descripcion
    }
    DELITOS {
        int delito_id PK
        varchar codigo_delito
        varchar nombre
        text descripcion
    }
    DETENCIONES {
        int detencion_id PK
        varchar numero
        varchar estatus
        boolean oculto
        int organismo_idfk FK
        int delito_idfk FK
        int detenido_idfk FK
    }
    DETALLE_DETENCIONES {
        int detalle_detencion_id PK
        date fecha_ingreso
        text descripcion
        varchar lugar
        int direccion_idfk FK
        int detencion_idfk FK
    }
    TIPO_EGRESOS {
        int tipoegreso_id PK
        varchar nombre
    }
    EGRESO_DETENCIONES {
        int egreso_id PK
        date fecha_egreso
        text descripcion
        int tipoegreso_idfk FK
        int detencion_idfk FK
    }

    USUARIOS ||--o{ ROLES : "tiene un"
    DETENIDOS ||--o{ CIUDADANOS : "tiene"
    DETALLE_DETENIDOS ||--o{ DETENIDOS : "es detalle de"
    DETALLE_DETENIDOS ||--o{ DIRECCIONES : "reside en"
    DETENCIONES ||--o{ DETENIDOS : "asociada a"
    DETENCIONES ||--o{ ORGANISMOS : "realizada por"
    DETENCIONES ||--o{ DELITOS : "por el"
    DETALLE_DETENCIONES ||--o{ DETENCIONES : "es detalle de"
    DETALLE_DETENCIONES ||--o{ DIRECCIONES : "ocurrió en"
    EGRESO_DETENCIONES ||--o{ DETENCIONES : "es egreso de"
    EGRESO_DETENCIONES ||--o{ TIPO_EGRESOS : "es de tipo"
