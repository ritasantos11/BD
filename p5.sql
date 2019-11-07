Forneça uma definição em SQL e também na forma de sequência de operações em àlgebra relacional para as
seguintes relações (consultas) à BD (ignore no caso de àlgebra relacional os critérios de ordenação de
resultados):

1
Os registos (todos os atributos) de clientes que vivem em França (Country = 'France'), ordenados por
nome.

select * from CUSTOMER where Country = 'France' order by Name;


2
Os títulos e anos de filmes, contendo a sequência 'Spider-Man' no título, ordenados por ano.

select Title, Year from MOVIE where Title like '%Spider-Man%' order by Year;


3
Os países de origem de clientes e respectivo nº de clientes, ordenados de forma decrescente pelo nº de
clientes. O valor do campo de contagem na relação deverá chamar-se NumClients (use o operador de
renomeação ρ em àlgebra relacional).

select Country, COUNT(*) as NumClientes from CUSTOMER group by 1 order by 2 desc;

4
O nome de cada departamento e o nome do funcionário gestor desse departamento nomeados na relação por
Department e Manager respectivamente, ordenados por nome de departamento

select D.Name as Department, S.Name as Manager from DEPARTMENT D inner join STAFF S 
on (StaffId = Manager) order by D.Name;


5
Género de filmes e correspondente nº de filmes classificados no género identificado pelo atributo
NumMovies, ordenado por género.

select Label, COUNT(*) as NumMovies from GENRE natural join MOVIE_GENRE group by 1 order by 1;


6
O título e ano de filme do ano 2010 ou posteriores e em
que entra o actor 'Brad Pitt', ordenados por ano.

select Title, Year from MOVIE natural join MOVIE_ACTOR natural join ACTOR where
Year >= 2010 and Name = 'Brad Pitt' order by Year;


7

A informação anterior, acrescida do nº de visionamentos por clientes para cada filme e
da soma dos valores cobrados (atributo STREAM.Charge) a clientes pelos visionamenentos, estes dois atributos
identificados por Views e Revenue.

select Title, Year, COUNT(CustomerId) as Views, SUM(Charge) as Revenue from MOVIE natural join
MOVIE_ACTOR natural join ACTOR natural join STREAM
where Year >= 2010 and Name = 'Brad Pitt' group by 1,2 order by Year;

8

O título e ano de filmes classificados com o género 'Musical', ordenados por ano.

select Title, Year from MOVIE natural join MOVIE_GENRE natural join GENRE
where Label = 'Musical' order by Year;


9
O nome de cada região geográfica e o nome do funcionário 
gestor dessa região nomeados na relação por Region e Manager
respectivamente, ordenados por nome de região geográfica.

select R.Name as Region, S.Name as Manager from REGION R join STAFF S on (RegionManager = StaffId)
order by 1;
