SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: heroku_ext; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA heroku_ext;


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: initial_schemas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.initial_schemas (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: initial_schemas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.initial_schemas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: initial_schemas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.initial_schemas_id_seq OWNED BY public.initial_schemas.id;


--
-- Name: kingdoms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.kingdoms (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    start_on date,
    end_on date
);


--
-- Name: monarchs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.monarchs (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    abbreviation character varying(20) NOT NULL,
    date_of_birth date NOT NULL,
    date_of_death date,
    wikidata_id character varying(20) NOT NULL
);


--
-- Name: parliament_periods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.parliament_periods (
    id integer NOT NULL,
    number integer NOT NULL,
    start_on date NOT NULL,
    end_on date,
    wikidata_id character varying(20)
);


--
-- Name: regnal_years; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regnal_years (
    id integer NOT NULL,
    number integer NOT NULL,
    start_on date NOT NULL,
    end_on date,
    monarch_id integer NOT NULL
);


--
-- Name: regnal_years_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regnal_years_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regnal_years_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regnal_years_id_seq OWNED BY public.regnal_years.id;


--
-- Name: reigns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reigns (
    id integer NOT NULL,
    start_on date NOT NULL,
    end_on date,
    kingdom_id integer NOT NULL,
    monarch_id integer NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: session_regnal_years; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.session_regnal_years (
    id integer NOT NULL,
    session_id integer NOT NULL,
    regnal_year_id integer NOT NULL
);


--
-- Name: session_regnal_years_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.session_regnal_years_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: session_regnal_years_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.session_regnal_years_id_seq OWNED BY public.session_regnal_years.id;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id integer NOT NULL,
    number integer NOT NULL,
    start_on date NOT NULL,
    end_on date,
    wikidata_id character varying(20),
    calendar_years_citation character varying(50) NOT NULL,
    regnal_years_citation character varying(50),
    parliament_period_id integer NOT NULL
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- Name: initial_schemas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.initial_schemas ALTER COLUMN id SET DEFAULT nextval('public.initial_schemas_id_seq'::regclass);


--
-- Name: regnal_years id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regnal_years ALTER COLUMN id SET DEFAULT nextval('public.regnal_years_id_seq'::regclass);


--
-- Name: session_regnal_years id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_regnal_years ALTER COLUMN id SET DEFAULT nextval('public.session_regnal_years_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: initial_schemas initial_schemas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.initial_schemas
    ADD CONSTRAINT initial_schemas_pkey PRIMARY KEY (id);


--
-- Name: kingdoms kingdoms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kingdoms
    ADD CONSTRAINT kingdoms_pkey PRIMARY KEY (id);


--
-- Name: monarchs monarchs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.monarchs
    ADD CONSTRAINT monarchs_pkey PRIMARY KEY (id);


--
-- Name: parliament_periods parliament_periods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parliament_periods
    ADD CONSTRAINT parliament_periods_pkey PRIMARY KEY (id);


--
-- Name: regnal_years regnal_years_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regnal_years
    ADD CONSTRAINT regnal_years_pkey PRIMARY KEY (id);


--
-- Name: reigns reigns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reigns
    ADD CONSTRAINT reigns_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: session_regnal_years session_regnal_years_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_regnal_years
    ADD CONSTRAINT session_regnal_years_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: reigns fk_kingdom; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reigns
    ADD CONSTRAINT fk_kingdom FOREIGN KEY (kingdom_id) REFERENCES public.kingdoms(id);


--
-- Name: reigns fk_monarch; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reigns
    ADD CONSTRAINT fk_monarch FOREIGN KEY (monarch_id) REFERENCES public.monarchs(id);


--
-- Name: regnal_years fk_monarch; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regnal_years
    ADD CONSTRAINT fk_monarch FOREIGN KEY (monarch_id) REFERENCES public.monarchs(id);


--
-- Name: sessions fk_parliament_period; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT fk_parliament_period FOREIGN KEY (parliament_period_id) REFERENCES public.parliament_periods(id);


--
-- Name: session_regnal_years fk_regnal_year; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_regnal_years
    ADD CONSTRAINT fk_regnal_year FOREIGN KEY (regnal_year_id) REFERENCES public.regnal_years(id);


--
-- Name: session_regnal_years fk_session; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_regnal_years
    ADD CONSTRAINT fk_session FOREIGN KEY (session_id) REFERENCES public.sessions(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20250307170734');

