# Especificación Técnica: SIPMG API v2 (Python Flask)

## 1. Descripción del Proyecto
SIPMG API v2 es la evolución del "Sistema de Información de la Policía Municipal de Guaicaipuro". Se desplaza de una arquitectura monolítica en PHP hacia una API RESTful construida con Flask, diseñada para integrarse con clientes modernos y garantizar la integridad de datos sensibles mediante una normalización estricta.

## 2. Definición de la Base de Datos (PostgreSQL)
La base de datos v2 utiliza PostgreSQL para aprovechar su soporte avanzado de tipos de datos, llaves foráneas y atomicidad.

### 2.1. Entidades Principales
- **Detenidos**: Registro central de ciudadanos vinculados a un proceso penal (Cédula única).
- **Detalle de Detenidos**: Información filiatoria dinámica (Nombres, apellidos, edad, sexo, foto).
- **Detenciones**: Cabecera de la detención, vincula delito y organismo remitente.
- **Detalle de Detenciones**: Logística del hecho (Fecha de ingreso, lugar, descripción).
- **Direcciones**: Entidad normalizada que gestiona la ubicación de residencias, hechos y sedes.
- **Geografía**: Tablas de `estados` y `municipios` para evitar redundancia de texto.
- **Egresos**: Gestión de la salida del detenido (Tipo de egreso, descripción, fecha).
- **Auditoría y Roles**: Gestión de usuarios y permisos basada en roles.

### 2.2. Atributos de Control
- **`oculto` (Boolean)**: Implementación de borrado lógico (Soft Delete) en todas las tablas maestras.
- **Llaves Foráneas**: Cascada restringida por defecto para asegurar la trazabilidad.

## 3. Arquitectura del Sistema
- **Backend Framework**: Python Flask.
- **ORM**: SQLAlchemy (para abstracción de base de datos).
- **Seguridad**:
    - Hasheo de contraseñas (Werkzeug/Bcrypt).
    - Roles de usuario (Administrador, Consultor).
- **Formato de Respuesta**: JSON.

## 4. Diferencias con la Versión 1 (PHP)
| Característica | SIPMG v1 (Legacy) | SIPMG v2 (Modern) |
| :--- | :--- | :--- |
| Lenguaje | PHP 7.x | Python 3.x |
| Framework | Ninguno (Monolítico) | Flask (API) |
| DB Engine | MySQL / MariaDB | PostgreSQL |
| Normalización | Baja (Direcciones en tablas planas) | Alta (Entidades geográficas independientes) |
| Borrado | Físico | Lógico (`oculto` flag) |

## 5. Requerimientos de Instalación
- Python 3.8+
- PostgreSQL 12+
- Dependencias (pip): `flask`, `flask-sqlalchemy`, `psycopg2-binary`.

---
*Documento generado para el portafolio de Daniel José Pacheco Rodríguez.*
