-- Crear la base de datos
CREATE DATABASE hospital CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Modificar la collation de la base de datos
ALTER DATABASE hospital COLLATE = utf8mb4_general_ci;

-- Usar la base de datos
USE hospital;

-- Crear la tabla pacientes
CREATE TABLE pacientes (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Crear la tabla historias_clinicas
CREATE TABLE historias_clinicas (
    paciente_id INT UNSIGNED PRIMARY KEY,
    diagnostico TEXT NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id)
);

-- Modificar la tabla historias_clinicas agregando la columna tratamiento
ALTER TABLE historias_clinicas ADD COLUMN tratamiento TEXT;

-- Cambiar el tamaño del campo nombre en la tabla pacientes
ALTER TABLE pacientes MODIFY nombre VARCHAR(150);

-- Agregar columna telefono
ALTER TABLE pacientes ADD COLUMN telefono VARCHAR(15) AFTER nombre;

-- Cambiar tipo de dato de telefono a BIGINT
ALTER TABLE pacientes MODIFY COLUMN telefono BIGINT;

-- Eliminar la columna telefono
ALTER TABLE pacientes DROP COLUMN telefono;

-- Insertar pacientes
INSERT INTO pacientes (nombre) VALUES ('Juan Pérez');
INSERT INTO pacientes (nombre) VALUES ('Ana Gómez');
INSERT INTO pacientes (nombre) VALUES ('Carlos Ruiz');

-- Insertar historias clínicas
INSERT INTO historias_clinicas (paciente_id, diagnostico) 
VALUES ((SELECT id FROM pacientes WHERE nombre='Juan Pérez'), 'Hipertensión'),
       ((SELECT id FROM pacientes WHERE nombre='Ana Gómez'), 'Diabetes'),
       ((SELECT id FROM pacientes WHERE nombre='Carlos Ruiz'), 'Asma');

-- Consultar historias clínicas con nombres de pacientes
SELECT p.nombre, h.diagnostico FROM pacientes p LEFT JOIN historias_clinicas h ON p.id = h.paciente_id;

-- Mostrar pacientes sin historia clínica
SELECT * FROM pacientes WHERE id NOT IN (SELECT paciente_id FROM historias_clinicas);

-- Actualizar diagnóstico de Juan Pérez
UPDATE historias_clinicas SET diagnostico = 'Hipertensión crónica' WHERE paciente_id = (SELECT id FROM pacientes WHERE nombre='Juan Pérez');

-- Eliminar la historia clínica de Carlos Ruiz
DELETE FROM historias_clinicas WHERE paciente_id = (SELECT id FROM pacientes WHERE nombre='Carlos Ruiz');

-- Ver estructura de la tabla historias_clinicas
DESCRIBE historias_clinicas;

-- Eliminar tablas y base de datos
DROP TABLE historias_clinicas;
DROP TABLE pacientes;
DROP DATABASE hospital;