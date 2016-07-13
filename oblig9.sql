-- Et par kommentarer til oppgaven:
-- Strukturen er endret noe fra tegningen/relasjonsskjemaet. Endret på at universitet ikke vet om
-- fakulteter og fakulteter ikke vet om institutt. Dette var nødvendig for å få db'en til å fungere.
-- På grunn av de endringene, endret jeg noen av spørsmålene (se kommentar lengre nede for detaljer) for
-- å i det hele tatt gi mening. Vanskelighetsgraden og kravene til spørsmålene satt i oblig 5 skal 
-- fortsatt være gyldige. Resten skal fungere som tegningen/relasjonsskjemaet.


create table Student(

	brukernavn varchar(8),
	primary key(brukernavn)
);

create table Emneansvarlig(

	e_id int,
	navn varchar(40) not null,
	primary key(e_id)
);


create table Adresse(

	gateaddr varchar(30),
	primary key(gateaddr)
);

create table Universitet(

	navn varchar(50),
	u_gateaddr varchar(30) not null,

	foreign key (u_gateaddr) references Adresse(gateaddr),
	primary key(navn)
);

create table Fakultet(

	f_orgnr int,
	fak_navn varchar(50),
	u_navn varchar(50) not null,

	foreign key (u_navn) references Universitet(navn),
	primary key(f_orgnr)
);

create table Institutt(

	i_orgnr int,
	ins_navn varchar(50) not null,
	fak_orgnr int not null,

	foreign key (fak_orgnr) references Fakultet(f_orgnr),
	primary key(i_orgnr)
);

create table Emne(

	emnekode varchar(10),
	kursholder int not null,
	ins_nr int not null,

	foreign key (kursholder) references Emneansvarlig(e_id),
	foreign key (ins_nr) references Institutt(i_orgnr),
	primary key (emnekode)
);

create table Semesteravgift(

	avgift_id varchar(5),
	belop int not null,
	student_bnavn varchar(8) not null,
	for_universitet varchar(50) not null,
	betalt boolean,
	foreign key (student_bnavn) references Student(brukernavn),
	foreign key (for_universitet) references Universitet(navn),
	primary key(avgift_id)
);

create table Studieprogram(

	prog_navn varchar(20),
	tilhorer_ins int not null,

	foreign key (tilhorer_ins) references Institutt(i_orgnr),
	primary key (prog_navn)
);

create table Emner_i_studieprogram(

	stud_prog varchar(20),
	emner_i_prog varchar(10),

	foreign key (stud_prog) references Studieprogram(prog_navn),
	foreign key (emner_i_prog) references Emne(emnekode),
	primary key (stud_prog, emner_i_prog)
);

create table Gar_studie(

	stud_prog varchar(20),
	student_bnavn varchar(8),

	foreign key (student_bnavn) references Student(brukernavn),
	foreign key (stud_prog) references Studieprogram(prog_navn),
	primary key (stud_prog, student_bnavn)
);

create table Student_tar_emne(

	student_bnavn varchar(8),
	emnenavn varchar(10),
	semester varchar(3) not null,
	karakter int,

	foreign key (student_bnavn) references Student(brukernavn),
	foreign key (emnenavn) references emne(emnekode),
	primary key (student_bnavn, emnenavn, semester)
);

-- Innsetting i tabellene
insert into student values ('stianmas');
insert into student values ('mazahash');
insert into student values ('kenmasse');
insert into student values ('namrahha');
insert into student values ('sidcrosb');
insert into student values ('matszucc');
insert into adresse values ('Gaustadaleen 23b');
insert into adresse values ('Gloeshaugen 1');
insert into adresse values ('Pilestredet');

PREPARE hoppa (text, text) AS
        INSERT into universitet (navn, u_gateaddr)
        SELECT $1 , g.gateaddr
        FROM adresse g
        WHERE g.gateaddr = $2;
EXECUTE hoppa ('UiO', 'Gaustadaleen 23b');

PREPARE l2 (text, text) AS
        INSERT into universitet (navn, u_gateaddr)
        SELECT $1 , g.gateaddr
        FROM adresse g
        WHERE g.gateaddr = $2;
EXECUTE l2 ('HIOA', 'Pilestredet');
insert into universitet (navn, u_gateaddr)
values ('NTNU', 'Gloeshaugen 1');

insert into fakultet(f_orgnr, fak_navn, u_navn)
values ('1101', 'Matnat', 'UiO');
insert into institutt(i_orgnr, ins_navn, fak_orgnr)
values ('2132', 'Informatikk', 1101);
insert into institutt(i_orgnr, ins_navn, fak_orgnr)
values ('2154', 'Fysikk', 1101);
insert into emneansvarlig values ('1', 'Arne Maus');
insert into emneansvarlig values ('2', 'Jan Tore Sanner');
insert into emneansvarlig values ('3', 'Yoshi');
insert into emneansvarlig values ('4', 'Espen Lie');
insert into emneansvarlig values ('5', 'Ole Johan Dahl');
insert into emne values ('INF220', '1', '2132');
-- Update
update emne set emnekode = 'INF2220' where emnekode = 'INF220';
insert into emne values ('INF1050', '2', '2132');
insert into emne values ('INF1500', '3', '2132');
insert into emne values ('INF1010', '4', '2132');
insert into emne values ('INF3331', '5', '2132');
insert into studieprogram values ('Prog og nettverk','2132');
insert into studieprogram values ('Interaksjonsdesigner','2132');
insert into studieprogram values('Astrofysikk', '2154');
insert into gar_studie values ('Prog og nettverk', 'stianmas');
insert into gar_studie values ('Prog og nettverk', 'kenmasse');
insert into gar_studie values ('Prog og nettverk', 'matszucc');
insert into gar_studie values ('Interaksjonsdesigner', 'mazahash');
insert into gar_studie values ('Interaksjonsdesigner', 'sidcrosb');
insert into student_tar_emne values('stianmas','INF3331','H15', '4');
insert into student_tar_emne values('stianmas','INF2220','H14','4');
insert into student_tar_emne values('stianmas','INF1010','H14','3');
insert into student_tar_emne values('kenmasse','INF3331','H15','5');
insert into student_tar_emne values('matszucc','INF3331','H15','2');
insert into emner_i_studieprogram values('Interaksjonsdesigner','INF1010');
insert into emner_i_studieprogram values('Interaksjonsdesigner','INF2220');
insert into emner_i_studieprogram values('Prog og nettverk','INF1010');
insert into emner_i_studieprogram values('Prog og nettverk','INF2220');
insert into emner_i_studieprogram values('Prog og nettverk','INF3331');
insert into semesteravgift values('8880', '650', 'stianmas', 'UiO', 'TRUE');
insert into semesteravgift values('8881', '650', 'kenmasse', 'UiO', 't');
insert into semesteravgift values('8882', '650', 'matszucc', 'UiO', 'f');
insert into semesteravgift values('58783', '700', 'sidcrosb', 'NTNU', 't');

-- Spørringer basert på oblig 5

--Hva er gjennomsnittskarakter ved et gitt emne? 
select emnenavn, AVG(karakter) as snitt_INF3331 from student_tar_emne where emnenavn = 'INF3331' group by emnenavn;

--Hvilken karakter fikk studenten i et gitt emne? 
select karakter, student_bnavn from student_tar_emne where emnenavn = 'INF3331' and student_bnavn = 'stianmas' group by student_bnavn, karakter;

-- Hvilke emner hører til et studieprogram ved et institutt (var opprinnelig universitet, håper det er ok at jeg endret det)? 
select stud_prog, emner_i_prog, ins_navn from emner_i_studieprogram, studieprogram, institutt 
where stud_prog = studieprogram.prog_navn and ins_navn = 'Informatikk';

-- Hvor mange studieprogrammer har et gitt institutt (var opprinnelig universitet, håper det er ok at jeg endret det)? 
select ins_navn, count(prog_navn) as Antall_prog from institutt, studieprogram where studieprogram.tilhorer_ins = institutt.i_orgnr group by ins_navn;

-- Hvor mange institutter har et gitt fakultet?
select count(i_orgnr) as antall, fak_navn from institutt i, fakultet 
where i.fak_orgnr = '1101' group by fak_navn;

-- Har alle studenter på et emne betalt semesteravgift?
select avgift_id, s.student_bnavn, betalt, st.emnenavn 
from semesteravgift s inner join student_tar_emne st
on s.student_bnavn = st.student_bnavn and st.emnenavn = 'INF3331';

-- Hvem er emneansvarlig for et gitt emne?
select emnekode, ea.navn as Kursholder from emne, emneansvarlig ea 
where emnekode = 'INF3331' and ea.e_id = kursholder;

-- Ved hvilken adresse tilhører universitetet (endret fra instituttet siden institutt ikke har noen 
-- adresse. Vanskelighetsgraden og poenget med spørsålet blir det samme)?
select gateaddr, navn as Universitet from adresse a, universitet uv where uv.u_gateaddr = a.gateaddr;

-- Ved hvilke universtitet har flest studenter betalt semesteravgift?
select navn as Universitet, count(avgift_id) as betalt_semesterafgift from universitet uv, semesteravgift s
where uv.navn = s.for_universitet and s.betalt = 't' group by navn;

-- Byttet ut siste spørsmål for å ha med et med having.
select student_bnavn, karakter as Student from student_tar_emne 
where emnenavn = 'INF3331' group by student_bnavn, karakter having karakter > 2 order by student_bnavn;









