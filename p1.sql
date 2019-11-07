2.1
Num: 8
CC: 18848333
Nome: 'Mariana Silva'
DataNasc: '2000-01-23'
Sexo: 'F'
Telefone: 227348900
Email: NULL

insert into UTENTE (Num, CC, Nome, DataNasc, Sexo, Telefone, Email)
VALUES (8, 18848333, 'Mariana Silva', '2000-01-23', 'F', 27348900, NULL);


2.2
select * from UTENTE where Num = 8;


2.3
Consulte a tabela LIVRO para obter o ISBN do livro.

select ISBN from LIVRO where Título = 'Os Lusíadas';

Consulte a tabela CÓPIA para saber que cópias do livro estão disponíveis.

select * from CÓPIA where ISBN = 9789722709620 and EmpUtente is NULL;

select * from CÓPIA where EmpUtente IS NULL and ISBN = (select ISBN from LIVRO where Título='Os Lusíadas');

Actualize a tabela CÓPIA registando o empréstimo de uma das cópia disponíveis do livro 
à Mariana Silva com a data de hoje.

update CÓPIA set EmpUtente = 8, EmpData = '2019-03-08' where ISBN = 9789722709620 and Num = 2;


2.4
Suponha que agora cópia nº 1 de 'Os Lusíadas' foi devolvida por um utente.
Qual é o utente em causa? Actualize a tabela CÓPIA para registar a devolução.

update CÓPIA set EmpUtente = NULL, EmpData = NULL where ISBN = 9789722709620 and Num = 1;


2.5
Actualize a tabela CÓPIA para reflectir a nova arrumação.

update CÓPIA set Estante = 'E13' where Estante = 'E12';

Remova de PRATELEIRA todas os registos correspondentes à estante 'E12'.

delete from PRATELEIRA where Estante = 'E12';

Remova de ESTANTE o registo da estante 'E12'.

delete from ESTANTE where Código = 'E12';


2.6
obtenha os ISBNs de livros:
que tenham ano de edição posterior a 2010.

select ISBN, Título from LIVRO where Ano > 2010;

que tenham como autor 'Fernando Pessoa' ou 'Luís de Camões'.

select ISBN from AUTORES where Nome = 'Fernando Pessoa' OR Nome = 'Luís de Camões';

que estejam arrumados na prateleira '3' da estante 'E99' e não se encontrem emprestados

select ISBN from CÓPIA where Prateleira = 3 and Estante = 'E99' AND EmpUtente is NULL;


3.1
Para esse efeito crie a tabela FUNCIONÁRIO em bd_bib.sql. A tabela deverá ter os mesmos atributos e
restrições que tabela UTENTE, e ainda os seguintes atributos:
Cargo: representável por uma "string" de 16 caracteres, não-opcional (ex. 'Bibliotecário', 'Director').
Supervisor: nº de funcionário supervisor opcional. Para este atributo defina a restrição de chave externa
(FOREIGN KEY) apropriada.

create table FUNCIONÁRIO (
    Num INT NOT NULL,
    CC INT NOT NULL,
    Nome VARCHAR(64) NOT NULL,
    DataNasc DATE NOT NULL,
    Sexo ENUM('M', 'F') NOT NULL,
    Telefone INT NOT NULL,
    Email VARCHAR(32),
    Cargo VARCHAR(16),
    Supervisor INT,
    PRIMARY KEY(Num),
    UNIQUE(CC),
    FOREIGN KEY (Supervisor) REFERENCES FUNCIONÁRIO(Num)
);

Insira de seguida 6 registos em FUNCIONÁRIO usando dados à sua escolha, por forma a que haja 2
supervisores de todos os outros funcionários (i.e., 2 supervisionados por supervisor). Use uma única
instrução INSERT para o efeito.

insert into FUNCIONARIO(Num, CC, Nome, DataNasc, Sexo, Telefone, Email, Cargo, Supervisor)
VALUES
(5, 18301622, 'Filipa Mendes', '2002-05-03', 'F', 227045560, 'filipa.mendes@gmail.com', 'Chefe', NULL),
 (6, 10521770, 'Eva Mendes',    '1975-11-18', 'F', 913434866, NULL, 'Chefe', NULL),
  (1, 10583212, 'João Pinto',    '1976-12-19', 'M', 913448748, 'azulibranco@fcp.pt', 'Rececionista', 5),
 (2, 12447555, 'Carlos Semedo',	'1985-06-02', 'M', 223774327, NULL, 'Rececionista', 6),
 (3, 16348500, 'Maria Silva',   '2005-11-17', 'F', 939939939, NULL, 'Arrumadora', 5),
 (4, 11983516, 'Pedro Costa',   '1982-01-03', 'M', 984088910, 'pc12345@xpto.com', 'Arrumadora', 6);


3.2
Cria uma tabela REVISTA com os seguintes atributos, todos não opcionais:
Num: nº interno p/identificação da revista, que deverá ser a chave primária.
Título: título da revista com até 64 caracteres. O título, embora não definido como chave primária, deverá ser único (use uma restrição UNIQUE).
Periodicidade: um atributo enumerado com valores possíveis 'S' (semanal), 'M' (mensal), e 'A' (anual).
Editora: nome da editora (até 32 caracteres).

create table REVISTA (
    Num int not null,
    Título varchar(64) not null,
    Periocidade ENUM('S', 'M', 'A') not null,
    Editora varchar(32) not null,
    PRIMARY key(Num),
    UNIQUE(Título)
);


Crie uma tabela EDIÇÃO_DE_REVISTA que para registar edições de revistas com os seguintes atributos não-opcionais:
NumR: chave externa para nº da revista;
NumEd: nº da edição;
Data: data da edição.
A chave primária de REVISTA_EDIÇÃO deverá ser formada pelo par (NumR,NumEd).

create table EDICAO_DE_REVISTA (
    NumR int not null,
    NumEd int not null,
    Data date not null,
    PRIMARY key (NumR, NumEd),
    FOREIGN key(NumR) REFERENCES REVISTA(Num)
);