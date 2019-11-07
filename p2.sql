1.1.1
os nomes e anos de nascimento de cada utente usando a função YEAR sobre DataNasc.

select Nome AS Nome, YEAR(DataNasc) as Ano from UTENTE;

1.1.2
os nomes de utentes , e mês e dia do seu aniversário que tenham nascido depois do ano 2000.

select Nome as Nome, MONTH(DataNasc) as Mes, DAY(DataNasc) as Dia, YEAR(DataNasc) as Ano from UTENTE where
YEAR(DataNasc) > 2000;

1.1.3
os nomes de utentes começados por 'Pedro' ou terminados em 'Silva'.

select Nome from UTENTE where Nome like 'Pedro%' or Nome like '%Silva';

1.1.4
o ISBN, nº de cópia de livros que estejam emprestadas e respetivo utente, excepto aquelas emprestadas
ao utente 1.

select EmpUtente as Utente, COUNT(EmpUtente), ISBN as Isbn from CÓPIA where EmpUtente is not null and
EmpUtente <> 1 group by Utente, Isbn;

1.1.5
informação respeitante a cada livro numa única string com o formato 'Título, Editora, Ano, ISBN' usando
a função 'CONCAT'.

select CONCAT(Título, Editora, Ano, ISBN) as Info from LIVRO;


Actualize a BD, alterando:
1.2.1
os emails de utentes para conterem apenas letras maiúsculas ("upper-case"), usando a função UPPER;

update UTENTE set Email = UPPER(Email);

1.2.2
actualizando a arrumação de todas as cópias em estantes com código começado por 'E1'
(usando LIKE) para a estante 'E99' e ainda incrementando o número da prateleira.

update CÓPIA set Estante = 'E99', Prateleira = Prateleira+1 where Estante like 'E1%';


Usando o comando ALTER TABLE faça as seguintes alterações ao esquema da BD, verificando
posteriormente os efeitos nas tabelas envolvidas (com consultas e desc TABELA):
2.3.1
remova o atributo Editora de LIVRO;

alter table LIVRO drop COLUMN Editora;

2.3.2
adicione o atributo 'Conservação' a LIVRO com tipo enumerado ENUM('Novo','Bom','Mau') NOT NULL DEFAULT
'Bom' .

ALTER TABLE LIVRO add Conservação ENUM('Novo','Bom','Mau') NOT NULL DEFAULT 'Bom';


2.4
Usando ON UPDATE CASCADE configure o esquema da BD por forma a que a actualização do ISBN de um
livro seja propagada às tabelas AUTORES e CÓPIA.
De seguida actualize o ISBN de um livro e observe os efeitos em AUTORES e CÓPIA.

update LIVRO set ISBN=9789722709621 where Título like 'Os Lusíadas';


3.1
os nomes de autores por ordem alfabética;

select Nome from AUTORES Order by Nome;

3.2
os nomes de autores novamente mas eliminando duplicados;

select DISTINCT Nome from AUTORES Order by 1;

3.3
os utentes do sexo masculino ordenados por data de nascimento descendente
(utentes mais novos devem aparecer 1º);

select Nome from UTENTE where Sexo='M' order by DataNasc desc;

3.4
a utente do sexo feminino mais nova;

select Nome from UTENTE where Sexo='F' order by DataNasc desc Limit 1;

3.5
as cópias de livros emprestadas ordenadas por ISBN (1º critério) e nº de utente (2º critério);

select * from CÓPIA where EmpUtente is not null order by ISBN, EmpUtente;

3.6
os ISBNs de livros com cópias emprestadas sem resultados duplicados;

select distinct ISBN from CÓPIA where EmpUtente is not null;

3.7
as 3 cópias de livros com empréstimos mais recentes.

select * from CÓPIA where EmpUtente is not null order by EmpData desc limit 3;


4.1
o nº total de cópias de livros;

select COUNT(*) from CÓPIA;

4.2
o nº total de cópias emprestadas de livros;

select COUNT(*) from CÓPIA where EmpUtente is not null;

4.3
o nº de cópias emprestadas de livros agrupadas por ISBN;

select COUNT(*) from CÓPIA where EmpUtente is not null group by ISBN;

4.4
o nº total de cópias emprestadas de livros agrupadas por ISBN para livros com 2 ou
mais cópias emprestadas;

select COUNT(*), ISBN from CÓPIA where EmpUtente is not null group by ISBN having COUNT(EmpUtente)>=2;

4.5
as datas do último empréstimo de um livro (use MAX), agrupadas por ISBN, e ordenadas pela
data do último empréstimo;

select Max(EmpData), ISBN from CÓPIA where EmpData is not null group by ISBN order by 1 desc;

4.6
a média do nº de dias de empréstimos de cópias (de todos os livros) face à data corrente
(use AVG, NOW e TIMESTAMPDIFF);

select AVG(TIMESTAMPDIFF(DAY, EmpData, NOW())) from CÓPIA where EmpData is not null;

4.7
o resultado anterior agrupado por ISBN.
select AVG(TIMESTAMPDIFF(DAY, EmpData, NOW())) from CÓPIA where EmpData is not null group by ISBN;


Execute consultas sobre múltiplas tabelas, sem usar consultas encadeadas ou operadores de junção ("joins"),
para obter a:
5.1
relação de cópias emprestadas em termos de nome do utente (que emprestou a cópia), ISBN, nº da cópia,
e data de empréstimo (precisa de consultar as tabelas UTENTE e CÓPIA), ordenadas por nome do utente
(1º critério).

select U.Nome, C.ISBN, C.Num, C.EmpData from UTENTE U, CÓPIA C where U.Num = C.EmpUtente and EmpData is not null order by 1;

5.2
a mesma relação da questão anterior, mas obtendo o título do livro em vez do ISBN
(precisa de consultar adicionalmente a tabela LIVRO), ordenadas por nome do utente (1º critério),
e título do livro (2º critério).

select U.Nome, C.ISBN, C.Num, C.EmpData, L.Título from UTENTE U, CÓPIA C, LIVRO L 
where U.Num = C.EmpUtente and C.ISBN = L.ISBN order by 1;

5.3
a relação de títulos de livros e correspondentes nº total de cópias, nº de total cópias emprestadas e
nº total de cópias disponíveis, ordenada por nº total de cópias e título de livro.

select L.Título, COUNT(L.ISBN), COUNT(C.EmpUtente), COUNT(L.ISBN) - COUNT(C.EmpUtente) from LIVRO L, CÓPIA C 
where L.ISBN = C.ISBN group by Título order by 2, 1;


Execute consultas encadeadas, sem usar operadores de junção ("joins"), para obter:
6.1
títulos de livros com alguma cópia emprestada (use por ex. IN ou EXISTS);

select Título from LIVRO where ISBN in (select ISBN from CÓPIA where EmpUtente is not null);

6.2
nºs e nomes de utentes com exactamente uma cópia de livro emprestada (use 1 = (SELECT ... FROM
CÓPIA WHERE ...)).

select Num, Nome from UTENTE where Num in (select EmpUtente from CÓPIA group by 1
having COUNT(EmpUtente)=1);

6.3
nºs e nomes de utentes com mais de uma cópia de livro emprestada (use 1 < (SELECT ... FROM CÓPIA
WHERE ...)).

select Num, Nome from UTENTE where Num in (select EmpUtente from CÓPIA group by 1
having COUNT(EmpUtente)>1);

6.4
os nomes de utentes e correspondentes nº total de cópias emprestadas, usando uma consulta com o
seguinte esqueleto

select U.Nome, (select COUNT(EmpUtente) from CÓPIA where U.Num = EmpUtente) as NumCópias from UTENTE U;


Usando consultas encadeadas, proceda às seguintes alterações à BD com uma única instrução UPDATE ou
DELETE e usando os títulos de livros e nomes de autores ou utentes directamente quando necessário
(sem recorrer a ISBNs ou nº de utente). Antes e depois das alterações, consulte o estado da tabela
afectada para verificar a correção da operação.
7.1
Remova registos de UTENTE sem nenhuma cópia de livro emprestada.

delete from UTENTE where Num not in (select EmpUtente from CÓPIA where EmpUtente is not null);

7.2
Remova registos de CÓPIA para o livro 'Astérix o Gaulês' desde que se refiram a cópias não emprestadas.

delete from CÓPIA where EmpUtente is null and ISBN in (select ISBN from LIVRO where Título = 'Astérix o Gaulês');

7.3
Actualize CÓPIA de forma a registar a devolução de todos os livros por parte do utente com nome
'Pedro Costa'.

update CÓPIA set EmpUtente = NULL and EmpData = NULL where EmpUtente in (select Num from UTENTE where Nome = 'Pedro Costa');

7.4
Actualize CÓPIA por forma a que todos os livros livros com autor 'Luís de Camões' ou 'Fernando Pessoa'
sejam colocados na prateleira 3 da estante 'E12'.

UPDATE CÓPIA SET Prateleira = 3 WHERE ISBN IN  
	(SELECT ISBN FROM LIVRO WHERE ISBN IN  
		(SELECT ISBN FROM AUTORES WHERE Nome LIKE "Luís de Camões" OR Nome LIKE "Fernando Pessoa")) 
	AND Estante = 'E12';


8.1
a relação entre nomes de utentes e títulos de livros emprestados, ordenada primeiro por nome de utente
e depois por título
-- resolvido de 4 maneiras

select U.Nome, L.Título from UTENTE U, LIVRO L, CÓPIA C where C.EmpUtente = U.Num and
L.ISBN = C.ISBN order by U.Nome, L.Título;

select U.Nome, L.Título from LIVRO L join CÓPIA C on (C.ISBN = L.ISBN) join UTENTE U on (
    U.Num = C.EmpUtente) order by U.Nome, L.Título;

select U.Nome, L.Título from CÓPIA C natural join LIVRO L join UTENTE U on (
    C.EmpUtente = U.Num) order by U.Nome, L.Título;

select U.Nome, L.Título from UTENTE U join LIVRO L where L.ISBN in (select ISBN from CÓPIA
where EmpUtente is not null and U.Num = EmpUtente) order by U.Nome, L.Título;

8.2
a relação entre nomes de utentes e correspondente total de cópias de livros emprestados,
ordenada por nome de utente (note que é uma consulta agregada agrupada pelo nome de utente);

select U.Nome, COUNT(*) as NumCópias from UTENTE U join CÓPIA C on (U.Num = C.EmpUtente)
group by U.Nome order by U.Nome;

8.3
a relação entre nomes de autores e títulos de livros, ordenada primeiro por nome de autor e
depois por título;

select A.Nome, L.Título from AUTORES A natural join LIVRO L order by A.Nome, L.Título;

8.4
a relação entre nomes de autores, títulos de livros, e correspondente número de total de cópias de
livros correspondentes na biblioteca (emprestadas ou não), ordenada primeiro por nome de autor e depois
por título (note que é uma consulta agregada agrupada pelo nome do autor e título do livro);

select A.Nome, L.Título, COUNT(*) as NumCópias from AUTORES A join LIVRO L on (A.ISBN = L.ISBN)
join CÓPIA C on (L.ISBN = C.ISBN) group by A.Nome, L.Título order by A.Nome, L.Título;

8.5
a mesma relação anterior, acrescida da informação do nº de cópias emprestadas;

select A.Nome, L.Título, COUNT(*) as NumCópias, COUNT(C.EmpUtente) as Emp from AUTORES A join LIVRO L
on (A.ISBN = L.ISBN) join CÓPIA C on (L.ISBN = C.ISBN) group by A.Nome, L.Título
order by A.Nome, L.Título;

8.6
a relação entre o código da secções da biblioteca (tabela SECÇÃO) e o nº total de cópias de livros
associadas a prateleiras nessa secção

select S.Código, COUNT(*) from SECÇÃO S join ESTANTE E on (S.Código = E.Secção) join PRATELEIRA P
on (E.Código = P.Estante) JOIN CÓPIA C on (P.Estante = C.Estante and P.Num = C.Prateleira)
group by 1;

8.7
Use uma junção externa (OUTER JOIN) entre PRATELEIRA e CÓPIA para descobrir que prateleiras se encontram
vazias, i.e., não terem cópias de livros associadas (Dica: deverão aparecer valores de ISBN iguais a
NULL para estantes em causa).

select C.ISBN, P.Num, P.Estante from CÓPIA C right outer join PRATELEIRA P on
(C.Estante = P.Estante and C.Prateleira = P.Num);


9.1
create view ARRUMAÇÃO(Título, NumCópia, Estante, Prateleira) as (
	select L.Título, C.Num, C.Estante, C.Prateleira from LIVRO L join CÓPIA C on (L.ISBN = C.ISBN)
		order by L.Título );

9.2
create view LIVROS_POR_SECÇÃO(SCódigo, SDesc, Total) as (
	select S.Código, S.Descrição, COUNT(*) from SECÇÃO S join ESTANTE E on (S.Código = E.Secção)
	join PRATELEIRA P on (E.Código = P.Estante) join CÓPIA C on
	(P.Estante = C.Estante and P.Num = C.Prateleira) group by 1);
