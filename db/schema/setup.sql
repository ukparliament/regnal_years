drop table if exists sessions;
drop table if exists parliament_periods;
drop table if exists regnal_years;
drop table if exists reigns;
drop table if exists monarchs;



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
	monarch_id int not null,
	constraint fk_monarch foreign key (monarch_id) references monarchs(id),
	primary key (id)
);

create table regnal_years (
	id serial not null,
	number int not null,
	start_on date not null,
	end_on date not null,
	reign_id int not null,
	constraint fk_reign foreign key (reign_id) references reigns(id),
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
	citation varchar(20) not null,
	parliament_period_id int not null,
	constraint fk_parliament_period foreign key (parliament_period_id) references parliament_periods(id),
	primary key (id)
);