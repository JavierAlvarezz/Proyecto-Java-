CREATE database lp1;
USE lp1;

CREATE TABLE tb_menu(
  cod_men int(11) NOT NULL AUTO_INCREMENT,
  des_men varchar(30),
  url_men varchar(400),
  PRIMARY KEY (cod_men)
) ;

/* ADMINISTRADO */
INSERT INTO tb_menu VALUES (1,'Trámites','tramite.jsp'),(2,'Consultas','ServletAdministradoConsultas?accion=LISTAR');
/* ASESOR LEGAL */
INSERT INTO tb_menu VALUES (3,'TRAMITES PENDIENTES','ServletTablaCodigos?accion=LISTAR'), (4, 'TRAMITES A/D', 'ServletTablaCodigos?accion=LISTAR2Y3'), (5, 'TRAMITES ANULADOS', 'ServletTablaCodigos?accion=LISTAR4');
/* TECNICO ADMINISTRATIVO */
INSERT INTO tb_menu VALUES (6,'TRAMITES PENDIENTES','ServletTecnicoAdministrativo?accion=LISTAR'),(7,'TRAMITES APROBADOS','ServletTecnicoAdministrativo?accion=LISTAR2AD');
/* SUBGERENTE */
INSERT INTO tb_menu VALUES (8,'TRAMITES PENDIENTES','ServletSubgerente?accion=LISTAR'),(9,'TRAMITES FIRMADOS','ServletSubgerente?accion=LISTAR2Y3');


CREATE TABLE tb_usuario (
  cod_usu INT(11) NOT NULL AUTO_INCREMENT,
  log_usu VARCHAR(15) DEFAULT NULL,
  pas_usu VARCHAR(15) DEFAULT NULL,
  nom_usu VARCHAR(30) DEFAULT NULL,
  ape_usu VARCHAR(50) DEFAULT NULL,
  email VARCHAR(100) NOT NULL,
  reg_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (cod_usu),
  UNIQUE (email, log_usu)
);

/*
INSERT INTO tb_usuario VALUES (1,'Miguel','Miguel','Miguel','Jaime Gomero', 'xxx@hotmail.com'),(2,'Claudia','Claudia','Claudia','Sifuentes Zevallos', 'xx@hotmail.com'),(3,'Fabrizio','Fabrizio','Fabrizio','Olano Farfan', 'x@hotmail.com'),(4,'Javier','Javier','Javier','Alvarez Cervera', 'gremco@hotmail.com');
*/
INSERT INTO tb_usuario (log_usu, pas_usu, nom_usu, ape_usu, email, reg_timestamp)
VALUES
('Miguel', 'asd', 'Miguel', 'Jaime Gomero', 'xxx@hotmail.com', CURRENT_TIMESTAMP),
('Claudia', 'asd', 'Claudia', 'Sifuentes Zevallos', 'xx@hotmail.com', CURRENT_TIMESTAMP),
('Fabrizio', 'asd', 'Fabrizio', 'Olano Farfan', 'x@hotmail.com', CURRENT_TIMESTAMP),
('Angelo', 'asd', 'Angelo', 'Hilario Lipe', 'gremco@hotmail.com', CURRENT_TIMESTAMP);


CREATE TABLE tb_acceso (
  cod_men int(11) NOT NULL,
  cod_usu int(11) NOT NULL,
  PRIMARY KEY (cod_men,cod_usu),
  KEY cod_usu (cod_usu),
  CONSTRAINT tb_acceso_ibfk_1 FOREIGN KEY (cod_men) REFERENCES tb_menu (cod_men),
  CONSTRAINT tb_acceso_ibfk_2 FOREIGN KEY (cod_usu) REFERENCES tb_usuario (cod_usu)
);

-- Insertar los valores iniciales en la tabla tb_acceso
INSERT INTO tb_acceso (cod_men, cod_usu)
VALUES
  (1, 1), (2, 1), (3, 2), (4,2), (5,2), (6, 3), (7, 3), (8,4), (9, 4);
-- Crear un trigger para asignar automáticamente el acceso a los nuevos usuarios
DELIMITER $$
CREATE TRIGGER asignar_acceso_nuevo_usuario AFTER INSERT ON tb_usuario
FOR EACH ROW
BEGIN
  INSERT INTO tb_acceso (cod_men, cod_usu)
  VALUES (1, NEW.cod_usu), (2, NEW.cod_usu);
END$$
DELIMITER ;


CREATE TABLE tramite_cambio_razon_social (
  cod_tramite int primary key auto_increment,
  nom varchar (100),
  raz varchar (100),
  nuraz varchar (100),
  dni varchar (100),
  email varchar (100),
  tlf varchar (100),
  ruc varchar (100),
  direccion varchar (100),
  renom varchar (100),
  redni varchar (100),
  reemail varchar (100),
  retlf varchar (100),
  retlfm varchar (100),
  esdireccion varchar (100),
  esurbanizacion varchar (100),
  escod_Ciiu varchar (100),
  esgiro varchar (100),
  esareal varchar (100),
  esareac varchar (100),
  esareaOcu varchar (100),
  esareaCalcu varchar (100),
  esnivelocu varchar (100),
  esnomCome varchar (100),
  ophorarios varchar (100),
  opmaquinas varchar (100),
  opempleado varchar (100),
  oppropios varchar (100),
  opalquilados varchar (100),
  num_tarjet_pago varchar(25),
  nom_tarjet_pago varchar(50),
  expiracion varchar(2),
  anio varchar(4),
  ccv varchar(3)
);


-- CESE DE LA LICENCIA DE FUNCIONAMIENTO
create table tramite_cese_de_actividades(
cod_tramite int auto_increment primary key,
nom2 varchar (100),
mot varchar (100),
dni2 varchar (100),
ema2 varchar (100),
tel2 varchar (100),
ruc2 varchar (100),
direc2 varchar (100),
renom2  varchar (100),
redni2 varchar (100),
reema2 varchar (100),
tlf2 varchar (100),
tlm2 varchar (100),
direcc2 varchar (100),
nro varchar (100),
mz varchar (100),
lt varchar (100),
urb2 varchar (100),
gir2 varchar (100),
certificado varchar (100),
resolucion varchar (100),
expediente  varchar (100),
comercial2 varchar (100),
num_tarjet_pago2 varchar(25),
nom_tarjet_pago2 varchar(50),
expiracion2 varchar(2),
anio2 varchar(4),
ccv2 varchar(3)
);

-- TABLA ESTADO
CREATE TABLE tb_estado (
  cod_estado INT PRIMARY KEY AUTO_INCREMENT,
  nom_estado VARCHAR(20)
);

INSERT INTO tb_estado VALUES (NULL, 'PENDIENTE');
INSERT INTO tb_estado VALUES (NULL, 'Con Observaciones');
INSERT INTO tb_estado VALUES (NULL, 'Sin Observaciones');
INSERT INTO tb_estado VALUES (NULL, 'ANULADO');

-- tabla donde se guardarán los códigos
CREATE TABLE tabla_codigos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  codigo INT,
  nombre VARCHAR(50),
  cod_estado INT DEFAULT 1
);

ALTER TABLE tabla_codigos ADD CONSTRAINT FK01 FOREIGN KEY (cod_estado) REFERENCES tb_estado (cod_estado);

-- desencadenador para la tabla "tramite_cambio_razon_social"
DELIMITER $$
CREATE TRIGGER guardar_codigo_razon_social AFTER INSERT ON tramite_cambio_razon_social
FOR EACH ROW
BEGIN
  INSERT INTO tabla_codigos (codigo, nombre, cod_estado) VALUES (NEW.cod_tramite, 'Cambio de razón social', 1);
END$$
DELIMITER ;

-- desencadenador para la tabla "tramite_cese_de_actividades"
DELIMITER $$
CREATE TRIGGER guardar_codigo_cese_actividades AFTER INSERT ON tramite_cese_de_actividades
FOR EACH ROW
BEGIN
  INSERT INTO tabla_codigos (codigo, nombre, cod_estado) VALUES (NEW.cod_tramite, 'Cese de la Licencia de Funcionamiento', 1);
END$$
DELIMITER ;

SELECT c.id, c.codigo, c.nombre, e.nom_estado
FROM tabla_codigos c JOIN tb_estado e ON c.cod_estado = e.cod_estado ORDER BY c.id;


-- TABLA VERIFICASAO
CREATE TABLE tb_verificasao (
  cod_ver INT PRIMARY KEY AUTO_INCREMENT,
  nom_estado VARCHAR(20)
);

INSERT INTO tb_verificasao VALUES (1, 'PENDIENTE');
INSERT INTO tb_verificasao VALUES (2, 'Firma RSG');
INSERT INTO tb_verificasao VALUES (3, 'Firma RLIC');

-- TABLA DOCUMENTO
CREATE TABLE tb_documento (
  codigo_doc INT PRIMARY KEY AUTO_INCREMENT,
  id INT,
  codigo INT,
  nombre VARCHAR(50),
  estado_descripcion VARCHAR(10),
  cod_ver INT
);

ALTER TABLE tb_documento ADD CONSTRAINT FK02 FOREIGN KEY (cod_ver) REFERENCES tb_verificasao (cod_ver);

-- desencadenador para actualizar tb_documento cuando se actualice cod_estado en tabla_codigos
DELIMITER $$
CREATE TRIGGER actualizar_tb_documento
AFTER UPDATE ON tabla_codigos
FOR EACH ROW
BEGIN
  IF NEW.cod_estado IN (2, 3) AND OLD.cod_estado = 1 THEN
    INSERT INTO tb_documento (id, codigo, nombre, estado_descripcion, cod_ver)
    VALUES (NEW.id, NEW.codigo, NEW.nombre,
      CASE NEW.cod_estado
        WHEN 2 THEN 'RSG'
        WHEN 3 THEN 'RLIC'
      END, 1);
  ELSEIF NEW.cod_estado = 1 AND OLD.cod_estado IN (2, 3) THEN
    DELETE FROM tb_documento WHERE id = NEW.id;
  END IF;
END$$
DELIMITER ;

-- Seleccionar datos de tb_documento
SELECT d.codigo_doc, d.id, d.codigo, d.nombre, d.estado_descripcion, v.nom_estado
FROM tb_documento d JOIN tb_verificasao v ON d.cod_ver = v.cod_ver;





-- TABLA VERIFICASAO2
CREATE TABLE tb_verificasao2 (
  cod_ver INT PRIMARY KEY AUTO_INCREMENT,
  nom_estado VARCHAR(10)
);

INSERT INTO tb_verificasao2 VALUES (1, 'PENDIENTE');
INSERT INTO tb_verificasao2 VALUES (2, 'APROBADO');

-- TABLA DOCUMENTO2
CREATE TABLE tb_documento2 (
  codigo_doc INT PRIMARY KEY AUTO_INCREMENT,
  id INT,
  codigo INT,
  nombre VARCHAR(50),
  estado_descripcion VARCHAR(10),
  cod_ver INT DEFAULT 1,
  CONSTRAINT FK03 FOREIGN KEY (cod_ver) REFERENCES tb_verificasao2 (cod_ver)
);

-- Insertar valores iniciales en tb_documento2
INSERT INTO tb_documento2 (id, codigo, nombre, estado_descripcion, cod_ver)
SELECT id, codigo, nombre,
  CASE
    WHEN cod_ver = 2 THEN 'RSG'
    WHEN cod_ver = 3 THEN 'RLIC'
    ELSE 'PENDIENTE' -- Asigna el valor predeterminado a 1 para los nuevos registros
  END AS estado_descripcion,
  1 AS cod_ver -- Establece cod_ver a 1 para los nuevos registros
FROM tb_documento
WHERE cod_ver IN (2, 3);

-- desencadenador para actualizar tb_documento2 cuando se actualice cod_ver en tb_documento
DELIMITER $$
CREATE TRIGGER actualizar_tb_documento2
AFTER UPDATE ON tb_documento
FOR EACH ROW
BEGIN
  IF NEW.cod_ver IN (2, 3) THEN
    INSERT INTO tb_documento2 (id, codigo, nombre, estado_descripcion, cod_ver)
    VALUES (NEW.id, NEW.codigo, NEW.nombre,
      CASE
        WHEN NEW.cod_ver = 2 THEN 'RSG'
        WHEN NEW.cod_ver = 3 THEN 'RLIC'
        ELSE 'PENDIENTE' -- Asigna el valor predeterminado a 1 para los nuevos registros
      END,
      1) -- Establece cod_ver a 1 para los nuevos registros
    ON DUPLICATE KEY UPDATE
    nombre = VALUES(nombre),
    estado_descripcion = VALUES(estado_descripcion);
  END IF;
END$$
DELIMITER ;

-- Seleccionar datos de tb_documento2
SELECT d.codigo_doc, d.id, d.codigo, d.nombre, d.estado_descripcion, v.nom_estado
FROM tb_documento2 d JOIN tb_verificasao2 v ON d.cod_ver = v.cod_ver;

























CREATE OR REPLACE VIEW tabla_datos AS
SELECT tc.codigo, tc.nombre, 
  CASE
    WHEN tc.nombre = 'Cambio de razón social' THEN CONCAT(
      '|-----------------------------------------------------------------------|\n\n',
      '|----------------------------SOLICITANTE--------------------------------|\n',
      '|-----------------------------------------------------------------------|\n',
      '| NOMBRE COMPLETO | ', tcr.nom, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| RAZÓN SOCIAL    | ', tcr.raz, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| NUEVA RAZÓN S.  | ', tcr.nuraz, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| DNI             | ', tcr.dni, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| EMAIL           | ', tcr.email, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| TELÉFONO        | ', tcr.tlf, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| RUC             | ', tcr.ruc, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| DIRECCIÓN       | ', tcr.direccion, '\n',
      '|-----------------------------------------------------------------------|\n',
      '|----------------------------REPRESENTANTE------------------------------|\n',
      '|-----------------------------------------------------------------------|\n',
      '| NOMBRE COMPLETO | ', tcr.renom, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| DNI             | ', tcr.redni, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| EMAIL           | ', tcr.reemail, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| TELÉFONO FIJO   | ', tcr.retlf, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| TELÉFONO MÓVIL  | ', tcr.retlfm, '\n',
      '|-----------------------------------------------------------------------|\n',
      '|----------------------------ESTABLECIMIENTO----------------------------|\n',
      '|-----------------------------------------------------------------------|\n',
      '| DIRECCIÓN       | ', tcr.esdireccion, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| URBANIZACIÓN    | ', tcr.esurbanizacion, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| CÓDIGO CIIU     | ', tcr.escod_Ciiu, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| GIRO DE EMPRESA | ', tcr.esgiro, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| ÁREA LIBRE      | ', tcr.esareal, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| Á. CONSTRUIDA   | ', tcr.esareac, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| Á. A OCUPAR     | ', tcr.esareaOcu, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| ESTACIONAMIENTO | ', tcr.esareaCalcu, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| NIV. OCUPADOS   | ', tcr.esnivelocu, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| NOM. COMERCIAL  | ', tcr.esnomCome, '\n',               
      '|-----------------------------------------------------------------------|\n',
      '|----------------------------NIV. OPERACIONALES-------------------------|\n',
      '|-----------------------------------------------------------------------|\n',
      '| HORARIO TRABAJO | ', tcr.ophorarios, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| N. DE MÁQUINAS  | ', tcr.opmaquinas, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| N. DE EMPLEADOS | ', tcr.opempleado, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| N. ESTAC. PROP. | ', tcr.oppropios, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| N. ESTAC. ALQUI.| ', tcr.opalquilados, '\n',
      '|-----------------------------------------------------------------------|\n',
      '|----------------------------MÉTODO DE PAGO-----------------------------|\n',
      '|-----------------------------------------------------------------------|\n',
      '| NÚM TARJ PAGO   | ', tcr.num_tarjet_pago, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| NOM TARJ PAGO   | ', tcr.nom_tarjet_pago, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| EXPIRACIÓN      | ', tcr.expiracion, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| AÑO             | ', tcr.anio, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| CCV             | ', tcr.ccv, '\n',
      '|-----------------------------------------------------------------------|'
    )
    WHEN tc.nombre = 'Cese de la Licencia de Funcionamiento' THEN CONCAT(
	  '|-----------------------------------------------------------------------|\n\n',
      '|----------------------------SOLICITANTE--------------------------------|\n',
      '|-----------------------------------------------------------------------|\n',
      '| NOMBRE COMPLETO | ', tca.nom2, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| MOTIVO          | ', tca.mot, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| DNI             | ', tca.dni2, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| EMAIL           | ', tca.ema2, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| TELÉFONO        | ', tca.tel2, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| RUC             | ', tca.ruc2, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| DIRECCIÓN       | ', tca.direc2, '\n',
      '|-----------------------------------------------------------------------|\n',
      '|----------------------------REPRESENTANTE------------------------------|\n',
      '|-----------------------------------------------------------------------|\n',
      '| NOMBRE COMPLETO | ', tca.renom2, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| DNI             | ', tca.redni2, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| EMAIL           | ', tca.reema2, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| TELÉFONO FIJO   | ', tca.tlf2, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| TELÉFONO MÓVIL  | ', tca.tlm2, '\n',
      '|-----------------------------------------------------------------------|\n',
      '|---------------------DIRECCION DEL ESTABLECIMIENTO---------------------|\n',
      '|-----------------------------------------------------------------------|\n',
      '| DIRECCIÓN       | ', tca.direcc2, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| NRO             | ', tca.nro, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| MZ              | ', tca.mz, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| LT              | ', tca.lt, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| URBANIZACIÓN    | ', tca.urb2, '\n',
      '|-----------------------------------------------------------------------|\n',
      '|-----------------------DATOS DEL ESTABLECIMIENTO-----------------------|\n',
      '|-----------------------------------------------------------------------|\n',
      '| GIRO DE EMPRESA | ', tca.gir2, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| CERTIFICADO     | ', tca.certificado, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| RESOLUCIÓN      | ', tca.resolucion, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| EXPEDIENTE      | ', tca.expediente, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| NOM. COMERCIAL  | ', tca.comercial2, '\n',
      '|-----------------------------------------------------------------------|\n',
      '|----------------------------MÉTODO DE PAGO-----------------------------|\n',
      '|-----------------------------------------------------------------------|\n',
      '| NÚM TARJ PAGO   | ', tca.num_tarjet_pago2, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| NOM TARJ PAGO   | ', tca.nom_tarjet_pago2, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| EXPIRACIÓN      | ', tca.expiracion2, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| AÑO             | ', tca.anio2, '\n',
      '|-----------------------------------------------------------------------|\n',
      '| CCV             | ', tca.ccv2, '\n',
      '|-----------------------------------------------------------------------|'
    )
    ELSE NULL
  END AS datos
FROM tabla_codigos tc
LEFT JOIN tramite_cambio_razon_social tcr ON tc.codigo = tcr.cod_tramite
LEFT JOIN tramite_cese_de_actividades tca ON tc.codigo = tca.cod_tramite;



/*
select *from tb_acceso;
select *from tb_usuario;
SELECT * FROM tramite_cambio_razon_social;
SELECT * FROM tramite_cese_de_actividades;
SELECT * FROM tb_estado;
SELECT * FROM tabla_codigos;
SELECT * FROM tb_verificasao;
SELECT * FROM tb_documento;
SELECT * FROM tb_verificasao2;
SELECT * FROM tb_documento2;
SELECT * FROM tabla_datos;
*/
/*

drop table tb_acceso;
drop table tb_usuario;
drop table tb_menu;
drop table tramite_cambio_razon_social;
drop table tramite_cese_de_actividades;
DROP TRIGGER IF EXISTS guardar_codigo_razon_social;
DROP TRIGGER IF EXISTS guardar_codigo_cese_actividades;
drop table tb_estado;
drop table tabla_codigos;

drop table tb_verificasao;
drop table tb_documento;

drop table tb_verificasao2;
drop table tb_documento2;
DROP TRIGGER IF EXISTS actualizar_tb_documento;
DROP TRIGGER IF EXISTS actualizar_tb_documento2;

drop table tabla_datos;
*/