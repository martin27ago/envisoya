SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: deliveries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE deliveries (
    id bigint NOT NULL,
    active boolean DEFAULT false,
    provider character varying,
    uid character varying,
    name character varying,
    surname character varying,
    email character varying,
    password character varying,
    document character varying,
    "imageFacebook" character varying,
    oauth_token character varying,
    oauth_expires_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    image_file_name character varying,
    image_content_type character varying,
    image_file_size integer,
    image_updated_at timestamp without time zone,
    license_file_name character varying,
    license_content_type character varying,
    license_file_size integer,
    license_updated_at timestamp without time zone,
    papers_file_name character varying,
    papers_content_type character varying,
    papers_file_size integer,
    papers_updated_at timestamp without time zone,
    longitude character varying DEFAULT '-56.14013671875'::character varying,
    latitude character varying DEFAULT '-34.894942447397305'::character varying
);


--
-- Name: deliveries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE deliveries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deliveries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE deliveries_id_seq OWNED BY deliveries.id;


--
-- Name: discounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE discounts (
    id bigint NOT NULL,
    user_id bigint,
    "userFrom_id" bigint,
    porcent integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    used boolean DEFAULT false,
    active boolean DEFAULT false
);


--
-- Name: discounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE discounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: discounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE discounts_id_seq OWNED BY discounts.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: shippings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE shippings (
    id bigint NOT NULL,
    "latitudeFrom" character varying,
    "longitudeFrom" character varying,
    "latitudeTo" character varying,
    "longitudeTo" character varying,
    "emailTo" character varying,
    price numeric(10,2),
    status integer DEFAULT 0,
    "postalCodeFrom" character varying,
    "postalCodeTo" character varying,
    delivery_id bigint,
    user_id bigint,
    "addressFrom" character varying,
    "addressTo" character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    weight numeric,
    "paymentMedia" character varying,
    signature_file_name character varying,
    signature_content_type character varying,
    signature_file_size integer,
    signature_updated_at timestamp without time zone,
    "estimatedPrice" boolean DEFAULT false,
    discount integer DEFAULT 0
);


--
-- Name: shippings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE shippings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shippings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE shippings_id_seq OWNED BY shippings.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id bigint NOT NULL,
    provider character varying,
    uid character varying,
    name character varying,
    surname character varying,
    email character varying,
    password character varying,
    document character varying,
    "imageFacebook" character varying,
    oauth_token character varying,
    oauth_expires_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    image_file_name character varying,
    image_content_type character varying,
    image_file_size integer,
    image_updated_at timestamp without time zone,
    admin boolean DEFAULT false
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: deliveries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliveries ALTER COLUMN id SET DEFAULT nextval('deliveries_id_seq'::regclass);


--
-- Name: discounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY discounts ALTER COLUMN id SET DEFAULT nextval('discounts_id_seq'::regclass);


--
-- Name: shippings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY shippings ALTER COLUMN id SET DEFAULT nextval('shippings_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: deliveries deliveries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliveries
    ADD CONSTRAINT deliveries_pkey PRIMARY KEY (id);


--
-- Name: discounts discounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY discounts
    ADD CONSTRAINT discounts_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: shippings shippings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY shippings
    ADD CONSTRAINT shippings_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_discounts_on_userFrom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "index_discounts_on_userFrom_id" ON discounts USING btree ("userFrom_id");


--
-- Name: index_discounts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_discounts_on_user_id ON discounts USING btree (user_id);


--
-- Name: index_shippings_on_delivery_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_shippings_on_delivery_id ON shippings USING btree (delivery_id);


--
-- Name: index_shippings_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_shippings_on_user_id ON shippings USING btree (user_id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20171017150815'),
('20171017173527'),
('20171018123314'),
('20171018204109'),
('20171019004359'),
('20171021162301'),
('20171021171057'),
('20171022143046'),
('20171022210531'),
('20171026202520'),
('20171026212029'),
('20171109001925');


