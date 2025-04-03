-- Crear la base de datos
CREATE DATABASE biblioteca CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Modificar la collation de la base de datos
ALTER DATABASE biblioteca COLLATE = utf8mb4_general_ci;

-- Usar la base de datos
USE biblioteca;

-- Crear la tabla bibliotecas
CREATE TABLE bibliotecas (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Crear la tabla libros
CREATE TABLE libros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    biblioteca_id INT UNSIGNED,
    titulo VARCHAR(255) NOT NULL,
    autor VARCHAR(100) NOT NULL,
    anio_publicacion YEAR NOT NULL,
    FOREIGN KEY (biblioteca_id) REFERENCES bibliotecas(id)
);

-- Modificar la tabla libros agregando la columna genero
ALTER TABLE libros ADD COLUMN genero VARCHAR(50);

-- Cambiar el tamaño de nombre en bibliotecas
ALTER TABLE bibliotecas MODIFY nombre VARCHAR(150);

-- Eliminar la columna genero de libros
ALTER TABLE libros DROP COLUMN genero;

-- Añadir una nueva columna isbn
ALTER TABLE libros ADD COLUMN isbn VARCHAR(20) AFTER titulo;

-- Cambiar el tipo de dato de isbn
ALTER TABLE libros MODIFY COLUMN isbn CHAR(13);

-- Insertar una biblioteca
INSERT INTO bibliotecas (nombre) VALUES ('Biblioteca Central');

-- Añadir un libro
INSERT INTO libros (biblioteca_id, titulo, autor, anio_publicacion) 
VALUES ((SELECT id FROM bibliotecas WHERE nombre='Biblioteca Central'), 'El Quijote', 'Miguel de Cervantes', 1605);

-- Insertar más libros
INSERT INTO libros (biblioteca_id, titulo, autor, anio_publicacion) 
VALUES ((SELECT id FROM bibliotecas WHERE nombre='Biblioteca Central'), 'Don Juan Tenorio', 'Tirso de Molina', 1630),
       ((SELECT id FROM bibliotecas WHERE nombre='Biblioteca Central'), 'Cien años de soledad', 'Gabriel García Márquez', 1967);

-- Consultar libros con bibliotecas
SELECT l.titulo, l.autor, b.nombre FROM libros l LEFT JOIN bibliotecas b ON l.biblioteca_id = b.id;

-- Mostrar bibliotecas sin libros
SELECT * FROM bibliotecas WHERE id NOT IN (SELECT biblioteca_id FROM libros);

-- Actualizar año de publicación
UPDATE libros SET anio_publicacion = 1950 WHERE titulo = '1984';

-- Eliminar un libro
DELETE FROM libros WHERE id = 1;

-- Eliminar la Biblioteca Central y todos sus libros
DELETE FROM libros WHERE biblioteca_id = (SELECT id FROM bibliotecas WHERE nombre='Biblioteca Central');
DELETE FROM bibliotecas WHERE nombre='Biblioteca Central';

-- Ver estructura de la tabla libros
DESCRIBE libros;

-- Eliminar tablas y base de datos
DROP TABLE libros;
DROP TABLE bibliotecas;
DROP DATABASE biblioteca;