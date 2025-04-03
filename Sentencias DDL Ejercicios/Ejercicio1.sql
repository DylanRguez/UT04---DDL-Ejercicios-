-- Crear la base de datos
CREATE DATABASE usuarios_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Modificar la collation de la base de datos
ALTER DATABASE usuarios_db COLLATE = utf8mb4_general_ci;

-- Usar la base de datos
USE usuarios_db;

-- Crear la tabla usuarios
CREATE TABLE usuarios (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Crear la tabla direcciones sin id AUTO_INCREMENT
CREATE TABLE direcciones (
    usuario_id INT UNSIGNED PRIMARY KEY,  -- usuario_id es clave primaria directamente
    direccion VARCHAR(255) NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Cambiar el tamaño del campo nombre
ALTER TABLE usuarios MODIFY nombre VARCHAR(150);

-- Agregar columna telefono
ALTER TABLE usuarios ADD COLUMN telefono VARCHAR(15) AFTER nombre;

-- Cambiar tipo de telefono a BIGINT
ALTER TABLE usuarios MODIFY COLUMN telefono BIGINT;

-- Eliminar la columna telefono
ALTER TABLE usuarios DROP COLUMN telefono;

-- Insertar usuarios
INSERT INTO usuarios (nombre) VALUES ('Juan Pérez');
INSERT INTO usuarios (nombre) VALUES ('Ana Gómez');
INSERT INTO usuarios (nombre) VALUES ('Carlos Ruiz');

-- Insertar direcciones asegurando que usuario_id existe en usuarios
INSERT INTO direcciones (usuario_id, direccion) VALUES 
    ((SELECT id FROM usuarios WHERE nombre='Juan Pérez'), 'Calle Mayor 123'),
    ((SELECT id FROM usuarios WHERE nombre='Ana Gómez'), 'Avenida 456'),
    ((SELECT id FROM usuarios WHERE nombre='Carlos Ruiz'), 'Calle 789');

-- Consultar direcciones con nombres de usuarios
SELECT u.nombre, d.direccion FROM usuarios u LEFT JOIN direcciones d ON u.id = d.usuario_id;

-- Mostrar usuarios sin dirección
SELECT * FROM usuarios WHERE id NOT IN (SELECT usuario_id FROM direcciones);

-- Actualizar la dirección de Juan Pérez
UPDATE direcciones SET direccion = 'Avenida Central 456' WHERE usuario_id = (SELECT id FROM usuarios WHERE nombre='Juan Pérez');

-- Eliminar la dirección de Carlos Ruiz
DELETE FROM direcciones WHERE usuario_id = (SELECT id FROM usuarios WHERE nombre='Carlos Ruiz');

-- Ver estructura de la tabla direcciones
DESCRIBE direcciones;

-- Eliminar tablas y base de datos
DROP TABLE direcciones;
DROP TABLE usuarios;
DROP DATABASE usuarios_db;