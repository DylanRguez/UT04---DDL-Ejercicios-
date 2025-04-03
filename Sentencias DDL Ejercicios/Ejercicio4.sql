-- Crear la base de datos
CREATE DATABASE universidad CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Modificar la collation de la base de datos
ALTER DATABASE universidad COLLATE = utf8mb4_general_ci;

-- Usar la base de datos
USE universidad;

-- Crear la tabla alumnos
CREATE TABLE alumnos (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Crear la tabla asignaturas
CREATE TABLE asignaturas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Crear la tabla intermedia matriculas
CREATE TABLE matriculas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    alumno_id INT UNSIGNED,
    asignatura_id INT UNSIGNED,
    fecha_matricula DATE NOT NULL,
    FOREIGN KEY (alumno_id) REFERENCES alumnos(id),
    FOREIGN KEY (asignatura_id) REFERENCES asignaturas(id)
);

-- Modificar la tabla matriculas para agregar una columna nota
ALTER TABLE matriculas ADD COLUMN nota DECIMAL(4,2);

-- Cambiar el tamaño del campo nombre en la tabla asignaturas
ALTER TABLE asignaturas MODIFY nombre VARCHAR(150);

-- Eliminar la columna nota de la tabla matriculas
ALTER TABLE matriculas DROP COLUMN nota;

-- Añadir un índice a la columna nombre en asignaturas
CREATE INDEX idx_nombre ON asignaturas (nombre);

-- Insertar un alumno
INSERT INTO alumnos (nombre) VALUES ('Luis Gómez');

-- Añadir una asignatura
INSERT INTO asignaturas (nombre) VALUES ('Matemáticas');

-- Matricular al alumno
INSERT INTO matriculas (alumno_id, asignatura_id, fecha_matricula) 
VALUES ((SELECT id FROM alumnos WHERE nombre='Luis Gómez'), (SELECT id FROM asignaturas WHERE nombre='Matemáticas'), CURDATE());

-- Insertar más alumnos
INSERT INTO alumnos (nombre) VALUES ('María Fernández'), ('Carlos Ruiz');

-- Añadir más asignaturas
INSERT INTO asignaturas (nombre) VALUES ('Física'), ('Historia'), ('Química');

-- Matricular a los alumnos en distintas asignaturas
INSERT INTO matriculas (alumno_id, asignatura_id, fecha_matricula) 
VALUES ((SELECT id FROM alumnos WHERE nombre='María Fernández'), (SELECT id FROM asignaturas WHERE nombre='Física'), CURDATE()),
       ((SELECT id FROM alumnos WHERE nombre='Carlos Ruiz'), (SELECT id FROM asignaturas WHERE nombre='Historia'), CURDATE());

-- Consultar asignaturas de un alumno
SELECT a.nombre, asg.nombre FROM alumnos a 
JOIN matriculas m ON a.id = m.alumno_id
JOIN asignaturas asg ON m.asignatura_id = asg.id 
WHERE a.nombre = 'Luis Gómez';

-- Consultar alumnos inscritos en una asignatura
SELECT al.nombre FROM alumnos al 
JOIN matriculas m ON al.id = m.alumno_id
JOIN asignaturas asg ON m.asignatura_id = asg.id 
WHERE asg.nombre = 'Matemáticas';

-- Eliminar una inscripción
DELETE FROM matriculas WHERE alumno_id = (SELECT id FROM alumnos WHERE nombre='Luis Gómez') AND asignatura_id = (SELECT id FROM asignaturas WHERE nombre='Matemáticas');

-- Eliminar un alumno y sus matrículas
DELETE FROM matriculas WHERE alumno_id = (SELECT id FROM alumnos WHERE nombre='Carlos Ruiz');
DELETE FROM alumnos WHERE nombre='Carlos Ruiz';

-- Eliminar la base de datos universidad
DROP DATABASE universidad;