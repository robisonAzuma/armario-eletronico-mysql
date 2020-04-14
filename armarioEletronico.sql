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

/* Criação da tabela chave */

CREATE TABLE chave (
id INT NOT NULL PRIMARY KEY,
descricao VARCHAR(120),
marca INT NULL,
tipo INT NOT NULL,
CONSTRAINT fk_marca FOREIGN KEY (marca) REFERENCES marca(id),
CONSTRAINT fk_tipo FOREIGN KEY (tipo) REFERENCES tipochave(id)
) ENGINE = InnoDB;

create table armario (
id int not null primary key,
chave int not null,
usuario int not null,
CONSTRAINT fk_usuario FOREIGN KEY (usuario) REFERENCES usuario(id),
CONSTRAINT fk_chave FOREIGN KEY (chave) REFERENCES chave(id)
) ENGINE = InnoDB;

/* tabela retirarChave e permissão */

create table retirarChave (
id int not null primary key,
usuario int not null,
armario int not null,
chave int not null,
dataHoraRetirada datetime,
dataHoraEntrega datetime,
entregue boolean not null,
constraint fk_armarioRetirar FOREIGN KEY (armario) REFERENCES armario(id),
constraint fk_usuarioRetirar FOREIGN KEY (usuario) REFERENCES usuario(id),
constraint fk_chaveRetirar FOREIGN KEY (chave) REFERENCES chave(id)
) ENGINE = InnoDB;

create table permissao (
nivel int not null,
chave int not null,
constraint fk_nivelPermissao FOREIGN KEY (nivel) REFERENCES nivelusuario(id),
constraint fk_chavePermissao FOREIGN KEY (chave) REFERENCES chave(id)
) ENGINE = InnoDB;

/* teste de trigger automatiza o datetime de entrega e retirada, quando der um update no entregue ele atualiza sozinho */

delimiter $$
CREATE DEFINER='root'@'localhost' TRIGGER 'retirarChave_AFTER_UPDATE' AFTER UPDATE ON 'retirarChave' FOR EACH ROW BEGIN
if new.entregue = 0 then
insert into retirarChave  values (null,null,null,null,now(),null,0);
if new.entregue = 1 then
insert into retirarChave  values (null,null,null,null,,null,now(),1);
END if;
end if;
end
delimiter ;