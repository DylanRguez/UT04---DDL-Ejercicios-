-- Crear la base de datos
CREATE DATABASE cine CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Modificar la collation de la base de datos
ALTER DATABASE cine COLLATE = utf8mb4_general_ci;

-- Usar la base de datos
USE cine;

-- Crear la tabla actores
CREATE TABLE actores (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Crear la tabla peliculas
CREATE TABLE peliculas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    anio_estreno YEAR NOT NULL
);

-- Crear la tabla intermedia actores_peliculas
CREATE TABLE actores_peliculas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    actor_id INT UNSIGNED,
    pelicula_id INT UNSIGNED,
    personaje VARCHAR(100) NOT NULL,
    FOREIGN KEY (actor_id) REFERENCES actores(id),
    FOREIGN KEY (pelicula_id) REFERENCES peliculas(id)
);

-- Modificar la tabla actores_peliculas para agregar la columna salario
ALTER TABLE actores_peliculas ADD COLUMN salario DECIMAL(10,2);

-- Cambiar el tamaño del campo nombre en la tabla actores
ALTER TABLE actores MODIFY nombre VARCHAR(150);

-- Eliminar la columna salario de la tabla actores_peliculas
ALTER TABLE actores_peliculas DROP COLUMN salario;

-- Añadir un índice a la columna titulo en peliculas
CREATE INDEX idx_titulo ON peliculas (titulo);

-- Insertar un actor llamado "Leonardo DiCaprio"
INSERT INTO actores (nombre) VALUES ('Leonardo DiCaprio');

-- Añadir una película llamada "Titanic"
INSERT INTO peliculas (titulo, anio_estreno) VALUES ('Titanic', 1997);

-- Registrar la participación de "Leonardo DiCaprio" en "Titanic"
INSERT INTO actores_peliculas (actor_id, pelicula_id, personaje) 
VALUES ((SELECT id FROM actores WHERE nombre='Leonardo DiCaprio'), 
        (SELECT id FROM peliculas WHERE titulo='Titanic'), 
        'Jack Dawson');

-- Insertar dos actores adicionales
INSERT INTO actores (nombre) VALUES ('Kate Winslet'), ('Tom Hanks');

-- Añadir tres películas adicionales
INSERT INTO peliculas (titulo, anio_estreno) VALUES ('Forrest Gump', 1994), ('Avatar', 2009), ('Inception', 2010);

-- Registrar la participación de actores en distintas películas
INSERT INTO actores_peliculas (actor_id, pelicula_id, personaje) VALUES
((SELECT id FROM actores WHERE nombre='Kate Winslet'), (SELECT id FROM peliculas WHERE titulo='Titanic'), 'Rose DeWitt Bukater'),
((SELECT id FROM actores WHERE nombre='Tom Hanks'), (SELECT id FROM peliculas WHERE titulo='Forrest Gump'), 'Forrest Gump'),
((SELECT id FROM actores WHERE nombre='Leonardo DiCaprio'), (SELECT id FROM peliculas WHERE titulo='Inception'), 'Dom Cobb');

-- Consultar todas las películas en las que ha trabajado "Leonardo DiCaprio"
SELECT p.titulo, p.anio_estreno 
FROM peliculas p 
JOIN actores_peliculas ap ON p.id = ap.pelicula_id 
JOIN actores a ON ap.actor_id = a.id 
WHERE a.nombre = 'Leonardo DiCaprio';

-- Consultar todos los actores que han participado en la película "Titanic"
SELECT a.nombre 
FROM actores a 
JOIN actores_peliculas ap ON a.id = ap.actor_id 
JOIN peliculas p ON ap.pelicula_id = p.id 
WHERE p.titulo = 'Titanic';

-- Eliminar la participación de un actor en una película específica
DELETE FROM actores_peliculas 
WHERE actor_id = (SELECT id FROM actores WHERE nombre='Leonardo DiCaprio') 
AND pelicula_id = (SELECT id FROM peliculas WHERE titulo='Titanic');

-- Eliminar un actor y sus registros de películas
DELETE FROM actores_peliculas WHERE actor_id = (SELECT id FROM actores WHERE nombre='Tom Hanks');
DELETE FROM actores WHERE nombre = 'Tom Hanks';

-- Eliminar la base de datos cine
DROP DATABASE cine;