drop table if exists session_regnal_years;
drop table if exists sessions;
drop table if exists parliament_periods;
drop table if exists regnal_years;
drop table if exists reigns;
drop table if exists monarchs;
drop table if exists kingdoms;

create table kingdoms (
	id int not null,
	name varchar(255) not null,
	start_on date,
	end_on date,
	primary key (id)
);

create table monarchs (
	id int not null,
	title varchar(255) not null,
	abbreviation varchar(20) not null,
	date_of_birth date not null,
	date_of_death date,
	wikidata_id varchar(20) not null,
	primary key (id)
);

create table reigns (
	id int not null,
	start_on date not null,
	end_on date,
	kingdom_id int not null,
	monarch_id int not null,
	constraint fk_monarch foreign key (monarch_id) references monarchs(id),
	constraint fk_kingdom foreign key (kingdom_id) references kingdoms(id),
	primary key (id)
);

create table regnal_years (
	id serial not null,
	number int not null,
	start_on date not null,
	end_on date,
	monarch_id int not null,
	constraint fk_monarch foreign key (monarch_id) references monarchs(id),
	primary key (id)
);

create table parliament_periods (
	id int not null,
	number int not null,
	start_on date not null,
	end_on date,
	wikidata_id varchar(20) not null,
	primary key (id)
);

create table sessions (
	id serial not null,
	number int not null,
	start_on date not null,
	end_on date,
	calendar_years_citation varchar(50) not null,
	regnal_years_citation varchar(50),
	parliament_period_id int not null,
	constraint fk_parliament_period foreign key (parliament_period_id) references parliament_periods(id),
	primary key (id)
);

create table session_regnal_years (
	id serial not null,
	session_id int not null,
	regnal_year_id int not null,
	constraint fk_session foreign key (session_id) references sessions(id),
	constraint fk_regnal_year foreign key (regnal_year_id) references regnal_years(id),
	primary key (id)
);