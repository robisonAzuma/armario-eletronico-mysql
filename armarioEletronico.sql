

/*
### EXCLUSÃO DE TABELAS
*/
drop table if exists retirarChaveMaster;
DROP TABLE IF EXISTS masterusuario;
DROP TABLE IF EXISTS permissao;
DROP TABLE IF EXISTS AberturaMaster;
drop table if exists AberturaUsuarioNormal;
DROP TABLE IF EXISTS retirarChave;
DROP TABLE IF EXISTS armario;
DROP TABLE IF EXISTS chave;
DROP TABLE IF EXISTS marca;
DROP TABLE IF EXISTS tipochave;
DROP TABLE IF EXISTS usuario;
DROP TABLE IF EXISTS nivelusuario;

SET SQL_SAFE_UPDATES=0;
/*
@autor: Larissa V. Benedet e Robison A. Rodrigues
@Data de Criação: 01/05/2020
@Data da Última Atualização: 29/04/2020
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



select usuario.id, usuario.nome, nivelusuario.nivel from usuario 
inner join nivelusuario on nivelusuario.id = usuario.nivel;

create table MasterUsuario(
id int not null primary key auto_increment,
Nome int,
SenhaMaster int not null,
constraint fk_NomeMaster foreign key (Nome) references usuario(id)
) engine = InnoDB;

select * from MasterUsuario;

/*traz o nome dos usuarios Master*/
select MasterUsuario.id,usuario.nome from MasterUsuario 
inner join usuario on usuario.id = MasterUsuario.nome; 
select * from MasterUsuario;

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

create table retirarChaveMaster (
id int not null primary key,
usuarioMaster int not null,
armario int not null,
AberturaMaster boolean, 
constraint fk_armarioRetirar_master FOREIGN KEY (armario) REFERENCES armario(id),
constraint fk_usuarioRetirar_master FOREIGN KEY (usuarioMaster) REFERENCES MasterUsuario(id)
) ENGINE = InnoDB;
select * from retirarChaveMaster;
/*tras o nome dos usuario master q abriu forcado o armario*/

select retirarChaveMaster.id,usuario.nome from retirarChaveMaster 
inner join MasterUsuario on (MasterUsuario.id = retirarChaveMaster.usuarioMaster)
inner join usuario on usuario.id = MasterUsuario.nome; 

create table permissao (
nivel int not null,
chave int not null,
constraint fk_nivelPermissao FOREIGN KEY (nivel) REFERENCES nivelusuario(id),
constraint fk_chavePermissao FOREIGN KEY (chave) REFERENCES chave(id)
) ENGINE = InnoDB;


create table AberturaUsuarioNormal(
id int not null primary key AUTO_INCREMENT,
usuarioCOMchave int, 
dataretirada datetime,
entregaDAchave datetime,
constraint fk_ABERTURA_usuario FOREIGN KEY (usuarioCOMchave) REFERENCES retirarChave(usuario)
)engine = innodb;


create table AberturaMaster(
id int not null primary key AUTO_INCREMENT,
usuarioCOMchaveMaster int, 
dataretiradaMaster datetime,
constraint fk_ABERTURAMaster_usuario FOREIGN KEY (usuarioCOMchaveMaster) REFERENCES retirarChave(usuario)
)engine = innoDB;

/*tras qual e a hora que master abriu*/ 
select AberturaMaster.id,usuario.nome,AberturaMaster.dataretiradaMaster from AberturaMaster 
inner join MasterUsuario on (MasterUsuario.id = AberturaMaster.usuarioCOMchaveMaster)
inner join usuario on usuario.id = MasterUsuario.nome; 

select * from AberturaMaster;




/* tabela retirada */

