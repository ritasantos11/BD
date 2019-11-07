create table REVISTA (
    Num int not null,
    Título varchar(64) not null,
    Periocidade ENUM('S', 'M', 'A') not null,
    Editora varchar(32) not null,
    PRIMARY key(Num),
    UNIQUE(Título)
);

create table EDICAO_DE_REVISTA (
    NumR int not null,
    NumEd int not null,
    Data date not null,
    PRIMARY key (NumR, NumEd),
    FOREIGN key(NumR) REFERENCES REVISTA(Num)
);