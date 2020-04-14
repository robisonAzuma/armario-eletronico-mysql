drop database if exists SA;
create database SA;
use SA;

/*
### EXCLUSÃO DE TABELAS
*/

DROP TABLE IF EXISTS usuario;
DROP TABLE IF EXISTS nivelusuario;
DROP TABLE IF EXISTS chave;
DROP TABLE IF EXISTS tipochave;
DROP TABLE IF EXISTS marca;
DROP TABLE IF EXISTS retirarChave;
DROP TABLE IF EXISTS permissao;
DROP TABLE IF EXISTS armario;

/*
@autor: Larissa V. Benedet e Robison A. Rodrigues
@Data de Criação: 17/02/2020
@Data da Última Atualização: 13/04/2020

* Criação da tabela de nível de usuário  
*/

CREATE TABLE nivelusuario (
id INT NOT NULL PRIMARY KEY,
descricao VARCHAR(60) NOT NULL,
nivel FLOAT
) ENGINE = InnoDB;

INSERT INTO nivelusuario VALUES 
(1,'Desenvolvedor',1),
(2,'Administrador',2),
(3,'Colaborador',3),
(4,'Gerente',2.1),
(5,'Contratante',1.2); 

/* Criação da tabela de usuário  
*/

CREATE TABLE usuario (
id INT NOT NULL PRIMARY KEY,
nome VARCHAR(60) NOT NULL,
login VARCHAR(50) NOT NULL,
senha VARCHAR(128) NOT NULL,
nivel INT NOT NULL,
biometria mediumblob,
CONSTRAINT uk_login UNIQUE (login),
CONSTRAINT fk_nivel FOREIGN KEY (nivel) REFERENCES nivelusuario(id) 
) ENGINE = InnoDB;


INSERT INTO usuario VALUES (1,'Edilson Bitencourt','edilsonb','e10adc3949ba59abbe56e057f20f883e',1," ");
INSERT INTO usuario VALUES (2,'Larissa Benedet','larissavb','12345',1," ");
INSERT INTO usuario VALUES (3,'Robison Azuma','robisonaz','123456',1," ");
INSERT INTO usuario VALUES (4,'Bruno Fialho','brunofialho','1234',3," ");

/* Criação da tabela de tipo de chave
*/

CREATE TABLE tipochave (
id INT NOT NULL PRIMARY KEY,
descricao VARCHAR(50)
) ENGINE = InnoDB;

INSERT INTO tipochave  VALUES 
(1,'Chave Gorje'),
(2,'Chave Yale'),
(3,'Chave tetra'),
(4,'Chave multiponto'),
(5,'Chave tubular'),
(6,'Chave pantográfica');

/* Criação da tabela de marca da chave */

CREATE TABLE marca (
id INT NOT NULL PRIMARY KEY,
nome VARCHAR(50)
) ENGINE = InnoDB;

INSERT INTO marca  VALUES 
(1,'Gedore'),
(2,'Belzer'),
(3,'Snap on'),
(4,'Tramontina Pro');

/* Criação da tabela chave */

CREATE TABLE chave (
id INT NOT NULL PRIMARY KEY,
descricao VARCHAR(120),
marca INT NULL,
tipo INT NOT NULL,
CONSTRAINT fk_marca FOREIGN KEY (marca) REFERENCES marca(id),
CONSTRAINT fk_tipo FOREIGN KEY (tipo) REFERENCES tipochave(id)
) ENGINE = InnoDB;

INSERT INTO chave VALUES (1,'Chave do armário 1', 1,1);
INSERT INTO chave VALUES (2,'Chave do armário 2', 2,2);
INSERT INTO chave VALUES (3,'Chave do armário 3', 3,3);

create table armario (
id int not null primary key,
chave int not null,
usuario int not null,
CONSTRAINT uk_chave UNIQUE (chave), /* cada armario só pode ter uma chave */
CONSTRAINT fk_usuario FOREIGN KEY (usuario) REFERENCES usuario(id),
CONSTRAINT fk_chave FOREIGN KEY (chave) REFERENCES chave(id)
) ENGINE = InnoDB;

INSERT INTO armario VALUES (1, 1, 1);
INSERT INTO armario VALUES (2, 2, 2);
INSERT INTO armario VALUES (3, 3, 3);

/* tabela retirarChave e permissão */

create table retirarChave (
id int not null primary key,
usuario int not null,
armario int not null,
chave int not null,
dataHoraRetirada datetime,
dataHoraEntrega datetime,
entregue boolean not null,
CONSTRAINT uk_chave UNIQUE (chave), /* cada armario só pode ter uma chave */
CONSTRAINT uk_armario UNIQUE (armario), /* um armario por usuario */
constraint fk_armarioRetirar FOREIGN KEY (armario) REFERENCES armario(id),
constraint fk_usuarioRetirar FOREIGN KEY (usuario) REFERENCES usuario(id),
constraint fk_chaveRetirar FOREIGN KEY (chave) REFERENCES chave(id)
) ENGINE = InnoDB;

insert into retirarChave (id,usuario,armario,chave,dataHoraRetirada,dataHoraEntrega,entregue) VALUES (1,1,1,1,'2020-04-14 20:09:00',null,false);
insert into retirarChave (id,usuario,armario,chave,dataHoraRetirada,dataHoraEntrega,entregue) VALUES (2,2,2,2,'2020-04-16 20:17:00',null,false);
insert into retirarChave (id,usuario,armario,chave,dataHoraRetirada,dataHoraEntrega,entregue) VALUES (3,3,3,3,'2020-04-20 20:20:00',null,false);

create table permissao (
nivel int not null,
chave int not null,
constraint fk_nivelPermissao FOREIGN KEY (nivel) REFERENCES nivelusuario(id),
constraint fk_chavePermissao FOREIGN KEY (chave) REFERENCES chave(id)
) ENGINE = InnoDB;

insert into permissao VALUES (1,1);
insert into permissao VALUES (5,2);
