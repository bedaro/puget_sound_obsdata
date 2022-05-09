--
-- PostgreSQL database dump
--

-- Dumped from database version 13.5 (Debian 13.5-1.pgdg110+1)
-- Dumped by pg_dump version 14.2 (Ubuntu 14.2-1.pgdg20.04+1+b1)

-- Started on 2022-05-06 21:27:16 PDT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3899 (class 1262 OID 19625)
-- Name: puget_sound_obsdata; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE puget_sound_obsdata WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE puget_sound_obsdata OWNER TO postgres;

\connect puget_sound_obsdata

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 28936)
-- Name: obsdata; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA obsdata;


ALTER SCHEMA obsdata OWNER TO postgres;

--
-- TOC entry 2 (class 3079 OID 19626)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- TOC entry 3900 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- TOC entry 1380 (class 1247 OID 20657)
-- Name: unit; Type: TYPE; Schema: obsdata; Owner: postgres
--

CREATE TYPE obsdata.unit AS ENUM (
    'mgl',
    'umol',
    'deg_c',
    'psu',
    'ugl',
    'ph'
);


ALTER TYPE obsdata.unit OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 210 (class 1259 OID 20682)
-- Name: observations; Type: TABLE; Schema: obsdata; Owner: postgres
--

CREATE TABLE obsdata.observations (
    id bigint NOT NULL,
    source_id bigint NOT NULL,
    datetime timestamp with time zone NOT NULL,
    location_id character varying(50) NOT NULL,
    parameter_id character varying(10) NOT NULL,
    depth double precision NOT NULL,
    value double precision NOT NULL,
    cast_id uuid
);


ALTER TABLE obsdata.observations OWNER TO postgres;

--
-- TOC entry 3901 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN observations.depth; Type: COMMENT; Schema: obsdata; Owner: postgres
--

COMMENT ON COLUMN obsdata.observations.depth IS 'in meters';


--
-- TOC entry 211 (class 1259 OID 20689)
-- Name: observation_pk_seq; Type: SEQUENCE; Schema: obsdata; Owner: postgres
--

CREATE SEQUENCE obsdata.observation_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE obsdata.observation_pk_seq OWNER TO postgres;

--
-- TOC entry 3902 (class 0 OID 0)
-- Dependencies: 211
-- Name: observation_pk_seq; Type: SEQUENCE OWNED BY; Schema: obsdata; Owner: postgres
--

ALTER SEQUENCE obsdata.observation_pk_seq OWNED BY obsdata.observations.id;


--
-- TOC entry 208 (class 1259 OID 20665)
-- Name: parameters; Type: TABLE; Schema: obsdata; Owner: postgres
--

CREATE TABLE obsdata.parameters (
    key character varying(10) NOT NULL,
    name character varying(50) NOT NULL,
    unit obsdata.unit NOT NULL
);


ALTER TABLE obsdata.parameters OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 20677)
-- Name: sources; Type: TABLE; Schema: obsdata; Owner: postgres
--

CREATE TABLE obsdata.sources (
    id bigint NOT NULL,
    agency character varying(50) NOT NULL,
    study character varying(50)
);


ALTER TABLE obsdata.sources OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 20693)
-- Name: source_pk_seq; Type: SEQUENCE; Schema: obsdata; Owner: postgres
--

CREATE SEQUENCE obsdata.source_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE obsdata.source_pk_seq OWNER TO postgres;

--
-- TOC entry 3903 (class 0 OID 0)
-- Dependencies: 212
-- Name: source_pk_seq; Type: SEQUENCE OWNED BY; Schema: obsdata; Owner: postgres
--

ALTER SEQUENCE obsdata.source_pk_seq OWNED BY obsdata.sources.id;


--
-- TOC entry 207 (class 1259 OID 20648)
-- Name: stations; Type: TABLE; Schema: obsdata; Owner: postgres
--

CREATE TABLE obsdata.stations (
    name character varying(50) NOT NULL,
    description text,
    geom public.geometry(Point,32610)
);


ALTER TABLE obsdata.stations OWNER TO postgres;

--
-- TOC entry 3738 (class 2604 OID 20701)
-- Name: observations id; Type: DEFAULT; Schema: obsdata; Owner: postgres
--

ALTER TABLE ONLY obsdata.observations ALTER COLUMN id SET DEFAULT nextval('obsdata.observation_pk_seq'::regclass);


--
-- TOC entry 3737 (class 2604 OID 20698)
-- Name: sources id; Type: DEFAULT; Schema: obsdata; Owner: postgres
--

ALTER TABLE ONLY obsdata.sources ALTER COLUMN id SET DEFAULT nextval('obsdata.source_pk_seq'::regclass);


--
-- TOC entry 3750 (class 2606 OID 20770)
-- Name: observations date_depth_param_loc_uniq; Type: CONSTRAINT; Schema: obsdata; Owner: postgres
--

ALTER TABLE ONLY obsdata.observations
    ADD CONSTRAINT date_depth_param_loc_uniq UNIQUE (datetime, depth, parameter_id, location_id);


--
-- TOC entry 3755 (class 2606 OID 20686)
-- Name: observations observations_pkey; Type: CONSTRAINT; Schema: obsdata; Owner: postgres
--

ALTER TABLE ONLY obsdata.observations
    ADD CONSTRAINT observations_pkey PRIMARY KEY (id);


--
-- TOC entry 3744 (class 2606 OID 20762)
-- Name: parameters parameters_pk; Type: CONSTRAINT; Schema: obsdata; Owner: postgres
--

ALTER TABLE ONLY obsdata.parameters
    ADD CONSTRAINT parameters_pk PRIMARY KEY (key);


--
-- TOC entry 3746 (class 2606 OID 20681)
-- Name: sources sources_pkey; Type: CONSTRAINT; Schema: obsdata; Owner: postgres
--

ALTER TABLE ONLY obsdata.sources
    ADD CONSTRAINT sources_pkey PRIMARY KEY (id);


--
-- TOC entry 3742 (class 2606 OID 20730)
-- Name: stations stations_pkey; Type: CONSTRAINT; Schema: obsdata; Owner: postgres
--

ALTER TABLE ONLY obsdata.stations
    ADD CONSTRAINT stations_pkey PRIMARY KEY (name);


--
-- TOC entry 3748 (class 2606 OID 20721)
-- Name: sources study_uniq; Type: CONSTRAINT; Schema: obsdata; Owner: postgres
--

ALTER TABLE ONLY obsdata.sources
    ADD CONSTRAINT study_uniq UNIQUE (study);


--
-- TOC entry 3751 (class 1259 OID 20736)
-- Name: fki_location_fk; Type: INDEX; Schema: obsdata; Owner: postgres
--

CREATE INDEX fki_location_fk ON obsdata.observations USING btree (location_id);


--
-- TOC entry 3752 (class 1259 OID 20768)
-- Name: fki_parameter_fk; Type: INDEX; Schema: obsdata; Owner: postgres
--

CREATE INDEX fki_parameter_fk ON obsdata.observations USING btree (parameter_id);


--
-- TOC entry 3753 (class 1259 OID 20719)
-- Name: fki_source_fk; Type: INDEX; Schema: obsdata; Owner: postgres
--

CREATE INDEX fki_source_fk ON obsdata.observations USING btree (source_id);


--
-- TOC entry 3756 (class 2606 OID 20731)
-- Name: observations location_fk; Type: FK CONSTRAINT; Schema: obsdata; Owner: postgres
--

ALTER TABLE ONLY obsdata.observations
    ADD CONSTRAINT location_fk FOREIGN KEY (location_id) REFERENCES obsdata.stations(name) NOT VALID;


--
-- TOC entry 3757 (class 2606 OID 20763)
-- Name: observations parameter_fk; Type: FK CONSTRAINT; Schema: obsdata; Owner: postgres
--

ALTER TABLE ONLY obsdata.observations
    ADD CONSTRAINT parameter_fk FOREIGN KEY (parameter_id) REFERENCES obsdata.parameters(key) NOT VALID;


--
-- TOC entry 3758 (class 2606 OID 20714)
-- Name: observations source_fk; Type: FK CONSTRAINT; Schema: obsdata; Owner: postgres
--

ALTER TABLE ONLY obsdata.observations
    ADD CONSTRAINT source_fk FOREIGN KEY (source_id) REFERENCES obsdata.sources(id) NOT VALID;


-- Completed on 2022-05-06 21:27:26 PDT

--
-- PostgreSQL database dump complete
--

