
-- ============================================================================
-- Esquema de Base de Datos para SIPMG
-- Descripcion: Proyecto de registro y gestión de detenciones
-- Autor: Daniel José Pacheco Rodríguez
-- ============================================================================

```sql


SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Estructura de la tabla `roles`
--
CREATE TABLE `roles` (
  `rol_id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_rol` varchar(50) NOT NULL,
  PRIMARY KEY (`rol_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `roles`
--
INSERT INTO `roles` (`rol_id`, `nombre_rol`) VALUES
(1, 'Administrador'),
(2, 'Consultor');

--
-- Estructura de la tabla `usuarios`
--
CREATE TABLE `usuarios` (
  `usuario_id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `correo` varchar(150) NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `rol_idfk` int(11) NOT NULL,
  PRIMARY KEY (`usuario_id`),
  UNIQUE KEY `correo` (`correo`),
  UNIQUE KEY `usuario` (`usuario`),
  KEY `rol_idfk` (`rol_idfk`),
  CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`rol_idfk`) REFERENCES `roles` (`rol_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Estructura de la tabla `ciudadanos`
--
CREATE TABLE `ciudadanos` (
  `ciudadano_id` int(11) NOT NULL AUTO_INCREMENT,
  `nacionalidad` varchar(10) NOT NULL COMMENT 'Ej: V, E',
  PRIMARY KEY (`ciudadano_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `ciudadanos`
--
INSERT INTO `ciudadanos` (`ciudadano_id`, `nacionalidad`) VALUES
(1, 'V'),
(2, 'E');

--
-- Estructura de la tabla `direcciones`
--
CREATE TABLE `direcciones` (
  `direccion_id` int(11) NOT NULL AUTO_INCREMENT,
  `estado` varchar(255) NOT NULL,
  `municipio` varchar(255) NOT NULL,
  `direccion` text NOT NULL,
  PRIMARY KEY (`direccion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Estructura de la tabla `detenidos`
--
CREATE TABLE `detenidos` (
  `detenido_id` int(11) NOT NULL AUTO_INCREMENT,
  `cedula` varchar(20) NOT NULL,
  `ciudadano_idfk` int(11) NOT NULL,
  PRIMARY KEY (`detenido_id`),
  UNIQUE KEY `cedula` (`cedula`),
  KEY `ciudadano_idfk` (`ciudadano_idfk`),
  CONSTRAINT `detenidos_ibfk_1` FOREIGN KEY (`ciudadano_idfk`) REFERENCES `ciudadanos` (`ciudadano_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Estructura de la tabla `detalle_detenidos`
--
CREATE TABLE `detalle_detenidos` (
  `detalle_detenido_id` int(11) NOT NULL AUTO_INCREMENT,
  `primer_nombre` varchar(100) NOT NULL,
  `segundo_nombre` varchar(100) DEFAULT NULL,
  `primer_apellido` varchar(100) NOT NULL,
  `segundo_apellido` varchar(100) DEFAULT NULL,
  `fecha_nacimiento` varchar(10) NOT NULL,
  `edad` int(11) NOT NULL,
  `sexo` int(11) NOT NULL COMMENT '1: Masculino, 2: Femenino',
  `nombre_foto` varchar(255) DEFAULT NULL,
  `ruta_foto` varchar(255) DEFAULT NULL,
  `detenido_idfk` int(11) NOT NULL,
  `direccion_idfk` int(11) NOT NULL,
  PRIMARY KEY (`detalle_detenido_id`),
  KEY `detenido_idfk` (`detenido_idfk`),
  KEY `direccion_idfk` (`direccion_idfk`),
  CONSTRAINT `detalle_detenidos_ibfk_1` FOREIGN KEY (`detenido_idfk`) REFERENCES `detenidos` (`detenido_id`) ON DELETE CASCADE,
  CONSTRAINT `detalle_detenidos_ibfk_2` FOREIGN KEY (`direccion_idfk`) REFERENCES `direcciones` (`direccion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Estructura de la tabla `organismos`
--
CREATE TABLE `organismos` (
  `organismo_id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo_organismo` varchar(20) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `telefono` varchar(50) DEFAULT NULL,
  `correo` varchar(150) DEFAULT NULL,
  `estado` varchar(255) DEFAULT NULL,
  `municipio` varchar(255) DEFAULT NULL,
  `direccion` text DEFAULT NULL,
  PRIMARY KEY (`organismo_id`),
  UNIQUE KEY `codigo_organismo` (`codigo_organismo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Estructura de la tabla `delitos`
--
CREATE TABLE `delitos` (
  `delito_id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo_delito` varchar(20) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`delito_id`),
  UNIQUE KEY `codigo_delito` (`codigo_delito`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Estructura de la tabla `detenciones`
--
CREATE TABLE `detenciones` (
  `detencion_id` int(11) NOT NULL AUTO_INCREMENT,
  `numero` varchar(50) NOT NULL COMMENT 'Nro. de Expediente',
  `estatus` varchar(50) NOT NULL COMMENT 'Ej: DETENIDO, EGRESADO',
  `oculto` tinyint(1) NOT NULL DEFAULT 0,
  `organismo_idfk` int(11) NOT NULL,
  `delito_idfk` int(11) NOT NULL,
  `detenido_idfk` int(11) NOT NULL,
  PRIMARY KEY (`detencion_id`),
  UNIQUE KEY `numero` (`numero`),
  KEY `organismo_idfk` (`organismo_idfk`),
  KEY `delito_idfk` (`delito_idfk`),
  KEY `detenido_idfk` (`detenido_idfk`),
  CONSTRAINT `detenciones_ibfk_1` FOREIGN KEY (`organismo_idfk`) REFERENCES `organismos` (`organismo_id`),
  CONSTRAINT `detenciones_ibfk_2` FOREIGN KEY (`delito_idfk`) REFERENCES `delitos` (`delito_id`),
  CONSTRAINT `detenciones_ibfk_3` FOREIGN KEY (`detenido_idfk`) REFERENCES `detenidos` (`detenido_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Estructura de la tabla `detalle_detenciones`
--
CREATE TABLE `detalle_detenciones` (
  `detalle_detencion_id` int(11) NOT NULL AUTO_INCREMENT,
  `fecha_ingreso` varchar(10) NOT NULL,
  `descripcion` text NOT NULL,
  `lugar` varchar(255) NOT NULL,
  `direccion_idfk` int(11) NOT NULL,
  `detencion_idfk` int(11) NOT NULL,
  PRIMARY KEY (`detalle_detencion_id`),
  KEY `direccion_idfk` (`direccion_idfk`),
  KEY `detencion_idfk` (`detencion_idfk`),
  CONSTRAINT `detalle_detenciones_ibfk_1` FOREIGN KEY (`direccion_idfk`) REFERENCES `direcciones` (`direccion_id`),
  CONSTRAINT `detalle_detenciones_ibfk_2` FOREIGN KEY (`detencion_idfk`) REFERENCES `detenciones` (`detencion_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Estructura de la tabla `tipo_egresos`
--
CREATE TABLE `tipo_egresos` (
  `tipoegreso_id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  PRIMARY KEY (`tipoegreso_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Estructura de la tabla `egreso_detenciones`
--
CREATE TABLE `egreso_detenciones` (
  `egreso_id` int(11) NOT NULL AUTO_INCREMENT,
  `fecha_egreso` varchar(10) NOT NULL,
  `descripcion` text NOT NULL,
  `tipoegreso_idfk` int(11) NOT NULL,
  `detencion_idfk` int(11) NOT NULL,
  PRIMARY KEY (`egreso_id`),
  KEY `tipoegreso_idfk` (`tipoegreso_idfk`),
  KEY `detencion_idfk` (`detencion_idfk`),
  CONSTRAINT `egreso_detenciones_ibfk_1` FOREIGN KEY (`tipoegreso_idfk`) REFERENCES `tipo_egresos` (`tipoegreso_id`),
  CONSTRAINT `egreso_detenciones_ibfk_2` FOREIGN KEY (`detencion_idfk`) REFERENCES `detenciones` (`detencion_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

COMMIT;
