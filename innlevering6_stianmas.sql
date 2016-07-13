create table Kunde(
Kundenummer int  primary  key,
Kundenavn varchar (40) not  null,
Kundeadresse varchar (50) not  null,
Kundefakturaadresse varchar (50) not null
);

create table Offentlig_etat(
Kundenummer int  primary  key not null references Kunde (Kundenummer),
Departement varchar (40) not  null
);

create table Firma(
Kundenummer int primary key references Kunde (Kundenummer),
Org_nummer int,

unique (Org_nummer)
);

create table Telefonnummer(
Nummer int primary key,
Kundenummer int not null references Kunde (Kundenummer)
);

create table Prosjekt(
Prosjektnummer int not null primary  key,
Prosjektleder int references Ansatt (Ansattnr),
Prosjektnavn varchar (20) not null,
Kundenummer int references Kunde (Kundenummer)
);

create table Ansatt  (
Ansattnr int not null primary key,
Gruppenavn varchar (30) not null references gruppe (gruppenavn),

unique (Gruppenavn)
);

create table AnsattDeltarIProsjekt  (
Ansattnr int references Ansatt (Ansattnr),
Prosjektnr int references Prosjekt (Prosjektnummer),
unique(Ansattnr, Prosjektnr)
);

create table Gruppe (
Gruppenavn varchar (30) primary key,
timelonn int
);

-- 1
select kundenummer, kundenavn, kundeadresse from Kunde;
-- 2
select nummer, kundenummer from telefonnummer order by kundenummer desc;
-- 3
select distinct prosjektleder from prosjekt;
-- 4
select ansattnr from ansattdeltariprosjekt
where prosjektnr = 
(select prosjektnummer from prosjekt
where prosjektnavn = 'Ruter app');
-- 5 
select ansattnr, timelonn from ansatt, gruppe
where gruppenavn (ansatt) = gruppenavn (gruppe);

-- 6
select org_nummer, kundenavn from firma, kunde 
where kundenummer (firma) = kundenummer (kunde);

