--
-- PostgreSQL database dump
--

\restrict HKUJgl5XWT9fMOMsSy7ZnOtyDP0df9Zvi4fU2lg7P2OV78Sfk2dJuQCiEkntw4A

-- Dumped from database version 16.11
-- Dumped by pg_dump version 16.11

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

ALTER TABLE IF EXISTS ONLY public.user_depots DROP CONSTRAINT IF EXISTS user_depots_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.user_depots DROP CONSTRAINT IF EXISTS user_depots_depot_id_fkey;
ALTER TABLE IF EXISTS ONLY public.scheduled_reports DROP CONSTRAINT IF EXISTS scheduled_reports_created_by_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.requests DROP CONSTRAINT IF EXISTS requests_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.requests DROP CONSTRAINT IF EXISTS requests_updated_by_fkey;
ALTER TABLE IF EXISTS ONLY public.requests DROP CONSTRAINT IF EXISTS requests_territory_id_fkey;
ALTER TABLE IF EXISTS ONLY public.requests DROP CONSTRAINT IF EXISTS requests_posm_id_fkey;
ALTER TABLE IF EXISTS ONLY public.requests DROP CONSTRAINT IF EXISTS requests_dealer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.posm_transfers DROP CONSTRAINT IF EXISTS posm_transfers_transferred_by_fkey;
ALTER TABLE IF EXISTS ONLY public.posm_transfers DROP CONSTRAINT IF EXISTS posm_transfers_to_depot_id_fkey;
ALTER TABLE IF EXISTS ONLY public.posm_transfers DROP CONSTRAINT IF EXISTS posm_transfers_posm_id_fkey;
ALTER TABLE IF EXISTS ONLY public.posm_transfers DROP CONSTRAINT IF EXISTS posm_transfers_from_depot_id_fkey;
ALTER TABLE IF EXISTS ONLY public.photos DROP CONSTRAINT IF EXISTS photos_request_id_fkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS fk_users_depot;
ALTER TABLE IF EXISTS ONLY public.requests DROP CONSTRAINT IF EXISTS fk_requests_depot;
ALTER TABLE IF EXISTS ONLY public.requests DROP CONSTRAINT IF EXISTS fk_requests_completed_by;
ALTER TABLE IF EXISTS ONLY public.posm DROP CONSTRAINT IF EXISTS fk_posm_depot;
ALTER TABLE IF EXISTS ONLY public.dealers DROP CONSTRAINT IF EXISTS fk_dealers_depot;
ALTER TABLE IF EXISTS ONLY public.dealers DROP CONSTRAINT IF EXISTS dealers_territory_id_fkey;
ALTER TABLE IF EXISTS ONLY public.audit_logs DROP CONSTRAINT IF EXISTS audit_logs_user_id_fkey;
DROP INDEX IF EXISTS public.ix_users_id;
DROP INDEX IF EXISTS public.ix_users_email;
DROP INDEX IF EXISTS public.ix_user_depots_user_id;
DROP INDEX IF EXISTS public.ix_user_depots_depot_id;
DROP INDEX IF EXISTS public.ix_territories_name;
DROP INDEX IF EXISTS public.ix_territories_id;
DROP INDEX IF EXISTS public.ix_scheduled_reports_id;
DROP INDEX IF EXISTS public.ix_requests_id;
DROP INDEX IF EXISTS public.ix_posm_transfers_id;
DROP INDEX IF EXISTS public.ix_posm_name_depot;
DROP INDEX IF EXISTS public.ix_posm_name;
DROP INDEX IF EXISTS public.ix_posm_id;
DROP INDEX IF EXISTS public.ix_photos_id;
DROP INDEX IF EXISTS public.ix_depots_name;
DROP INDEX IF EXISTS public.ix_depots_id;
DROP INDEX IF EXISTS public.ix_depots_code;
DROP INDEX IF EXISTS public.ix_dealers_id;
DROP INDEX IF EXISTS public.ix_dealers_code_depot;
DROP INDEX IF EXISTS public.ix_dealers_code;
DROP INDEX IF EXISTS public.ix_audit_logs_id;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.user_depots DROP CONSTRAINT IF EXISTS user_depots_pkey;
ALTER TABLE IF EXISTS ONLY public.territories DROP CONSTRAINT IF EXISTS territories_pkey;
ALTER TABLE IF EXISTS ONLY public.scheduled_reports DROP CONSTRAINT IF EXISTS scheduled_reports_pkey;
ALTER TABLE IF EXISTS ONLY public.requests DROP CONSTRAINT IF EXISTS requests_pkey;
ALTER TABLE IF EXISTS ONLY public.posm_transfers DROP CONSTRAINT IF EXISTS posm_transfers_pkey;
ALTER TABLE IF EXISTS ONLY public.posm DROP CONSTRAINT IF EXISTS posm_pkey;
ALTER TABLE IF EXISTS ONLY public.photos DROP CONSTRAINT IF EXISTS photos_pkey;
ALTER TABLE IF EXISTS ONLY public.depots DROP CONSTRAINT IF EXISTS depots_pkey;
ALTER TABLE IF EXISTS ONLY public.dealers DROP CONSTRAINT IF EXISTS dealers_pkey;
ALTER TABLE IF EXISTS ONLY public.audit_logs DROP CONSTRAINT IF EXISTS audit_logs_pkey;
ALTER TABLE IF EXISTS ONLY public.alembic_version DROP CONSTRAINT IF EXISTS alembic_version_pkc;
ALTER TABLE IF EXISTS public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.territories ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.scheduled_reports ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.requests ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.posm_transfers ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.posm ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.photos ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.depots ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.dealers ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.audit_logs ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.users_id_seq;
DROP TABLE IF EXISTS public.users;
DROP TABLE IF EXISTS public.user_depots;
DROP SEQUENCE IF EXISTS public.territories_id_seq;
DROP TABLE IF EXISTS public.territories;
DROP SEQUENCE IF EXISTS public.scheduled_reports_id_seq;
DROP TABLE IF EXISTS public.scheduled_reports;
DROP SEQUENCE IF EXISTS public.requests_id_seq;
DROP TABLE IF EXISTS public.requests;
DROP SEQUENCE IF EXISTS public.posm_transfers_id_seq;
DROP TABLE IF EXISTS public.posm_transfers;
DROP SEQUENCE IF EXISTS public.posm_id_seq;
DROP TABLE IF EXISTS public.posm;
DROP SEQUENCE IF EXISTS public.photos_id_seq;
DROP TABLE IF EXISTS public.photos;
DROP SEQUENCE IF EXISTS public.depots_id_seq;
DROP TABLE IF EXISTS public.depots;
DROP SEQUENCE IF EXISTS public.dealers_id_seq;
DROP TABLE IF EXISTS public.dealers;
DROP SEQUENCE IF EXISTS public.audit_logs_id_seq;
DROP TABLE IF EXISTS public.audit_logs;
DROP TABLE IF EXISTS public.alembic_version;
DROP TYPE IF EXISTS public.userrole;
DROP TYPE IF EXISTS public.requeststatus;
DROP TYPE IF EXISTS public.jobtype;
--
-- Name: jobtype; Type: TYPE; Schema: public; Owner: app
--

CREATE TYPE public.jobtype AS ENUM (
    'Montaj',
    'Demontaj',
    'Bak─▒m'
);


ALTER TYPE public.jobtype OWNER TO app;

--
-- Name: requeststatus; Type: TYPE; Schema: public; Owner: app
--

CREATE TYPE public.requeststatus AS ENUM (
    'Beklemede',
    'TakvimeEklendi',
    'Tamamland─▒',
    '─░ptal'
);


ALTER TYPE public.requeststatus OWNER TO app;

--
-- Name: userrole; Type: TYPE; Schema: public; Owner: app
--

CREATE TYPE public.userrole AS ENUM (
    'user',
    'admin',
    'tech'
);


ALTER TYPE public.userrole OWNER TO app;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO app;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.audit_logs (
    id integer NOT NULL,
    user_id integer,
    action character varying(50) NOT NULL,
    entity_type character varying(50) NOT NULL,
    entity_id integer,
    old_values json,
    new_values json,
    description text,
    ip_address character varying(45),
    user_agent character varying(500),
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.audit_logs OWNER TO app;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public.audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_logs_id_seq OWNER TO app;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- Name: dealers; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.dealers (
    id integer NOT NULL,
    territory_id integer,
    code character varying NOT NULL,
    name character varying NOT NULL,
    latitude numeric(10,8),
    longitude numeric(11,8),
    depot_id integer
);


ALTER TABLE public.dealers OWNER TO app;

--
-- Name: dealers_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public.dealers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dealers_id_seq OWNER TO app;

--
-- Name: dealers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public.dealers_id_seq OWNED BY public.dealers.id;


--
-- Name: depots; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.depots (
    id integer NOT NULL,
    name character varying NOT NULL,
    code character varying NOT NULL
);


ALTER TABLE public.depots OWNER TO app;

--
-- Name: depots_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public.depots_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.depots_id_seq OWNER TO app;

--
-- Name: depots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public.depots_id_seq OWNED BY public.depots.id;


--
-- Name: photos; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.photos (
    id integer NOT NULL,
    request_id integer NOT NULL,
    path_or_url character varying NOT NULL,
    file_name character varying NOT NULL,
    mime_type character varying,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.photos OWNER TO app;

--
-- Name: photos_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public.photos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.photos_id_seq OWNER TO app;

--
-- Name: photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public.photos_id_seq OWNED BY public.photos.id;


--
-- Name: posm; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.posm (
    id integer NOT NULL,
    name character varying NOT NULL,
    ready_count integer DEFAULT 0 NOT NULL,
    repair_pending_count integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    depot_id integer
);


ALTER TABLE public.posm OWNER TO app;

--
-- Name: posm_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public.posm_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.posm_id_seq OWNER TO app;

--
-- Name: posm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public.posm_id_seq OWNED BY public.posm.id;


--
-- Name: posm_transfers; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.posm_transfers (
    id integer NOT NULL,
    posm_id integer NOT NULL,
    from_depot_id integer NOT NULL,
    to_depot_id integer NOT NULL,
    quantity integer NOT NULL,
    transfer_type character varying(20) NOT NULL,
    notes text,
    transferred_by integer NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.posm_transfers OWNER TO app;

--
-- Name: posm_transfers_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public.posm_transfers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.posm_transfers_id_seq OWNER TO app;

--
-- Name: posm_transfers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public.posm_transfers_id_seq OWNED BY public.posm_transfers.id;


--
-- Name: requests; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.requests (
    id integer NOT NULL,
    user_id integer NOT NULL,
    dealer_id integer NOT NULL,
    territory_id integer,
    current_posm character varying,
    job_type public.jobtype NOT NULL,
    job_detail text,
    request_date timestamp with time zone DEFAULT now() NOT NULL,
    requested_date date NOT NULL,
    planned_date date,
    posm_id integer,
    status public.requeststatus DEFAULT 'Beklemede'::public.requeststatus NOT NULL,
    job_done_desc text,
    latitude numeric(10,8),
    longitude numeric(11,8),
    updated_at timestamp with time zone DEFAULT now(),
    updated_by integer,
    depot_id integer,
    completed_date date,
    completed_by integer,
    priority character varying(20) DEFAULT 'Orta'::character varying NOT NULL
);


ALTER TABLE public.requests OWNER TO app;

--
-- Name: requests_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public.requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.requests_id_seq OWNER TO app;

--
-- Name: requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public.requests_id_seq OWNED BY public.requests.id;


--
-- Name: scheduled_reports; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.scheduled_reports (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    report_type character varying(50) NOT NULL,
    cron_expression character varying(100) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    depot_ids json,
    recipient_user_ids json NOT NULL,
    status_filter json,
    job_type_filter json,
    custom_params json,
    last_sent_at timestamp with time zone,
    next_run_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
);


ALTER TABLE public.scheduled_reports OWNER TO app;

--
-- Name: scheduled_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public.scheduled_reports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.scheduled_reports_id_seq OWNER TO app;

--
-- Name: scheduled_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public.scheduled_reports_id_seq OWNED BY public.scheduled_reports.id;


--
-- Name: territories; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.territories (
    id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.territories OWNER TO app;

--
-- Name: territories_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public.territories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.territories_id_seq OWNER TO app;

--
-- Name: territories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public.territories_id_seq OWNED BY public.territories.id;


--
-- Name: user_depots; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.user_depots (
    user_id integer NOT NULL,
    depot_id integer NOT NULL
);


ALTER TABLE public.user_depots OWNER TO app;

--
-- Name: users; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying NOT NULL,
    email character varying NOT NULL,
    password_hash character varying NOT NULL,
    role character varying(20) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    depot_id integer
);


ALTER TABLE public.users OWNER TO app;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO app;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- Name: dealers id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.dealers ALTER COLUMN id SET DEFAULT nextval('public.dealers_id_seq'::regclass);


--
-- Name: depots id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.depots ALTER COLUMN id SET DEFAULT nextval('public.depots_id_seq'::regclass);


--
-- Name: photos id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.photos ALTER COLUMN id SET DEFAULT nextval('public.photos_id_seq'::regclass);


--
-- Name: posm id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.posm ALTER COLUMN id SET DEFAULT nextval('public.posm_id_seq'::regclass);


--
-- Name: posm_transfers id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.posm_transfers ALTER COLUMN id SET DEFAULT nextval('public.posm_transfers_id_seq'::regclass);


--
-- Name: requests id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.requests ALTER COLUMN id SET DEFAULT nextval('public.requests_id_seq'::regclass);


--
-- Name: scheduled_reports id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.scheduled_reports ALTER COLUMN id SET DEFAULT nextval('public.scheduled_reports_id_seq'::regclass);


--
-- Name: territories id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.territories ALTER COLUMN id SET DEFAULT nextval('public.territories_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.alembic_version (version_num) FROM stdin;
f1a2b3c4d5e6
\.


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.audit_logs (id, user_id, action, entity_type, entity_id, old_values, new_values, description, ip_address, user_agent, created_at) FROM stdin;
1	1	LOGIN	User	1	null	null	Kullan─▒c─▒ giri┼ş yapt─▒: info@dinogida.com.tr	172.18.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-16 06:29:07.213008+00
2	1	LOGIN	User	1	null	null	Kullan─▒c─▒ giri┼ş yapt─▒: info@dinogida.com.tr	172.18.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-16 06:47:24.771645+00
3	1	LOGIN	User	1	null	null	Kullan─▒c─▒ giri┼ş yapt─▒: info@dinogida.com.tr	172.18.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-16 07:19:01.689587+00
4	1	CREATE	User	7	null	{"name": "Arif YALIM", "email": "arif.yalim@dinogida.com.tr", "role": "user"}	Yeni kullan─▒c─▒ olu┼şturuldu: arif.yalim@dinogida.com.tr	172.18.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-16 07:20:09.422957+00
5	7	LOGIN	User	7	null	null	Kullan─▒c─▒ giri┼ş yapt─▒: arif.yalim@dinogida.com.tr	172.18.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-16 07:20:25.349617+00
6	1	UPDATE	User	7	{"name": "Arif YALIM", "email": "arif.yalim@dinogida.com.tr", "role": "user", "depot_id": null}	{"name": "Arif YALIM", "email": "arif.yalim@dinogida.com.tr", "role": "user"}	Kullan─▒c─▒ g├╝ncellendi: arif.yalim@dinogida.com.tr	172.18.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-16 07:20:49.837729+00
7	7	LOGIN	User	7	null	null	Kullan─▒c─▒ giri┼ş yapt─▒: arif.yalim@dinogida.com.tr	172.18.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-16 07:21:01.191713+00
8	1	UPDATE	POSM	102	{"name": "LOCAL COU", "depot_id": 2, "ready_count": 0, "repair_pending_count": 0}	{"name": "LOCAL COU", "ready_count": 5, "repair_pending_count": 0}	POSM g├╝ncellendi: LOCAL COU	172.18.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-16 07:22:41.766996+00
9	7	LOGIN	User	7	null	null	Kullan─▒c─▒ giri┼ş yapt─▒: arif.yalim@dinogida.com.tr	172.18.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-16 07:28:07.787921+00
10	1	UPDATE	User	7	{"name": "Arif YALIM", "email": "arif.yalim@dinogida.com.tr", "role": "user", "depot_id": null}	{"name": "Arif YALIM", "email": "arif.yalim@dinogida.com.tr", "role": "user"}	Kullan─▒c─▒ g├╝ncellendi: arif.yalim@dinogida.com.tr	172.18.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-16 07:28:30.133563+00
11	7	CREATE	Request	14	null	{"status": "Beklemede", "job_type": "Montaj", "dealer_id": 15932}	Yeni talep olu┼şturuldu: 14	172.18.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-16 07:48:40.775408+00
12	1	LOGIN	User	1	null	null	Kullan─▒c─▒ giri┼ş yapt─▒: info@dinogida.com.tr	172.18.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-16 07:49:20.392264+00
13	1	UPDATE	Request	14	{"status": "TakvimeEklendi", "planned_date": "2026-01-23", "priority": "Orta", "completed_date": null}	{"status": "Tamamland\\u0131", "planned_date": "2026-01-23", "priority": "Orta", "completed_date": "2026-01-24"}	Talep g├╝ncellendi: 14	172.18.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-16 07:51:10.234536+00
14	1	LOGIN	User	1	null	null	Kullan─▒c─▒ giri┼ş yapt─▒: info@dinogida.com.tr	172.18.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-16 12:32:53.247898+00
15	1	LOGIN	User	1	null	null	Kullan─▒c─▒ giri┼ş yapt─▒: info@dinogida.com.tr	172.18.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-16 13:09:50.50651+00
16	1	DELETE	User	8	{"name": "Admin Kullan\\u0131c\\u0131", "email": "admin@example.com", "role": "admin"}	null	Kullan─▒c─▒ silindi: admin@example.com	172.18.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-16 13:10:06.620552+00
\.


--
-- Data for Name: dealers; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.dealers (id, territory_id, code, name, latitude, longitude, depot_id) FROM stdin;
13672	47	D2F204358	ABDULLAH DO─ŞRUL	38.90515800	27.84445430	1
13673	47	D2F000933	ABD├£L BALOLSUN	38.90554370	27.83761640	1
13674	47	D2F001509	ADEM CANKU┼Ş	\N	\N	1
13675	47	D2F142868	AHMET ├çELEB─░	38.92111330	27.85001340	1
13676	47	D2F242699	AHMET SARA├ç	42.94838100	34.13287400	1
13677	47	D2F228767	AHMET YILMAZ	38.90904100	27.83838330	1
13678	47	D2F121862	AKHISAR PETROL ANONIM SIRKETI	38.88453700	27.76076900	1
13679	47	D2F235429	AL─░ KARAPINAR	38.91763220	27.83766440	1
13680	47	D2F004122	AL─░ ├ûNL├£	38.91988300	27.84984400	1
13681	47	D2F001053	AL─░ SERT	38.91811300	27.83788300	1
13682	47	D2F236820	ASLANLAR AKARYAKIT SANAY─░ T─░C. A.┼Ş	38.92214080	27.85703420	1
13683	47	D2F197132	ATALAY ├ûZKAN	38.91552430	27.83176610	1
13684	47	D2F034799	AYFER AYT─░MUR	38.91994400	27.83435800	1
13685	47	D2F003617	AYSUN TURHAN	38.91226510	27.83586040	1
13686	47	D2F131128	BAHAR BASUT	38.91335360	27.83929830	1
13687	47	D2F184266	BARI┼Ş ALAN	38.92231370	27.85703870	1
13688	47	D2F121688	BEK─░R KU┼Ş	38.92430930	27.85214410	1
13689	47	D2F181051	B├£LENT ERENLER	38.91662110	27.83417880	1
13690	47	D2F003869	B├£LENT G├ûYN├£	38.92179600	27.83505500	1
13691	47	D2F186281	CANDARO─ŞULLARIDERYA PETROL ├£R├£NLER─░, TARIM, ZAH─░RE, GIDA,LTD. ┼ŞT─░.	38.88070570	27.75590800	1
13692	47	D2F132846	CANSU ├çOKG├ûR	38.92021100	27.84064960	1
13693	47	D2F242492	CEMRE DAL	38.91700820	27.83548530	1
13694	47	D2F001082	CENG─░Z SA─ŞS├ûZ	38.91137300	27.84354000	1
13695	47	D2F001096	CEYHUN KIR	38.90785000	27.83880500	1
13696	47	D2F081394	CO┼ŞKUN EDREM─░T	38.91792130	27.83801990	1
13697	47	D2F215015	├çA─ŞLAR ├çALI 2	38.91664830	27.82221720	1
13698	47	D2F230877	├çA─ŞLAR HUYLU	38.91548280	27.84191500	1
13699	47	D2F209809	├çEL─░KSOY PETROL LTD.┼ŞT─░.	38.83191100	27.71064810	1
13700	47	D2F019788	DEN─░Z KARATA┼Ş	38.90512300	27.82418700	1
13701	47	D2F180122	DEN─░Z KO├çAK	38.90433530	27.84700620	1
13702	47	D2F079191	DURSUN GENCER	38.91748800	27.83640000	1
13703	47	D2F003860	ECEM MARKET├ç─░L─░K GIDA SAN.VE T─░C. LTD. ┼ŞT─░.	38.91100400	27.83688800	1
13704	47	D2F208182	EFE Y├£REKL─░	38.91338990	27.83694340	1
13705	47	D2F001925	ENG─░N ARICI	38.88690900	27.76889000	1
13706	47	020033562	ER-ABAKA AKARYAKIT OTOMOT─░V GIDA TEKST─░L PAZ.NAK.T─░C. VE SAN.LTD.┼ŞT─░.	38.91349800	27.82742400	1
13707	47	D2F216798	ERCAN S├ûYLEMEZ	38.90167670	27.80037790	1
13708	47	D2F233829	EREN AKG├£├ç	38.90565970	27.84432210	1
13709	47	D2F166595	ESAT CAN ELMALI	38.90785200	27.83874230	1
13710	47	D2F242085	ESK─░ TATLAR GIDA A.┼Ş.	38.90390400	27.83581080	1
13711	47	D2F192235	FATMA B─░LTEK─░N	38.91615700	27.85276500	1
13712	47	D2F185579	FATMA ├çUBAN	38.92014260	27.84064770	1
13713	47	D2F142151	FEYZULLAH KO├ç	38.91461340	27.84200890	1
13714	47	D2F226289	G├ûK├çEN AKSEK─░ 2	38.91078480	27.83705480	1
13715	47	D2F114857	G├£LAY O─ŞUZ	38.91186900	27.83414670	1
13716	47	D2F206437	G├£LTEN ├û─Ş├£TTAN	38.91203920	27.82596700	1
13717	47	D2F149265	HALE DERV─░┼Ş	38.91716840	27.84615670	1
13718	47	D2F234548	HAL─░L AKDO─ŞAN	38.92029580	27.84870350	1
13719	47	D2F172239	HAL─░L BAKIR	38.88091610	27.88913560	1
13720	47	D2F004432	HAL─░L ─░BRAH─░M U├çAK	38.91860100	27.84504500	1
13721	47	020033734	HAL─░S A┼ŞAR/K├û┼ŞEM TKL	38.92122300	27.83969700	1
13722	47	D2F000932	HASAN HOCAO─ŞLU	38.90721400	27.83797200	1
13723	47	D2F163984	H─░LM─░ T├£RKO─ŞLU	38.91018890	27.83681680	1
13724	47	D2F004210	H├£SEY─░N ADE┼Ş	38.91484800	27.83238800	1
13725	47	D2F122349	H├£SEY─░N DO─ŞRU	38.91417460	27.85257870	1
13726	47	D2F023558	IZFER PETROL INSAAT TURIZM TARIM GIDA SANAYI VE TICARET LIMITED SIRKET	38.87203300	27.74795700	1
13727	47	D2F037702	─░DR─░S SAYIN	38.92576600	27.85262600	1
13728	47	D2F001251	─░LHAN BULUT	38.91069600	27.84241300	1
13729	47	D2F231898	─░LYAS B─░LTEK─░N	38.91780790	27.85549280	1
13730	47	D2F233929	─░MAM CANG├£L	38.91295380	27.84824850	1
13731	47	D2F242524	─░NC─░ ALTINAY	42.94838100	34.13287400	1
13732	47	D2F081803	─░SMA─░L G├£R MAHMUT ZEYBEK A. ORT./NAZAR MARKET	38.91354800	27.83142100	1
13733	47	D2F003903	─░SM─░G├£L ├ç─░FT├ç─░	38.91504000	27.83075800	1
13734	47	D2F197738	KAD─░R YILDIZ	38.90962440	27.84626410	1
13735	47	D2F226468	KAYA KARDE┼ŞLER MARKET├ç─░L─░K T─░C. LTD. ┼ŞT─░.	38.91963500	27.83573100	1
13736	47	D2F003445	KAYALI AKARYAKIT LTD.┼ŞT─░./MUSTAFA G├ûKHAN KAYALI-1	38.90076200	27.83616300	1
13737	47	D2F165576	KEMAL AYTAN	38.88922330	27.77295410	1
13738	47	D2F207779	KEMAL B─░NG├ûL	38.90868060	27.83704340	1
13739	47	D2F003254	MEHMET CENG─░Z	38.90519300	27.82217500	1
13740	47	D2F001091	MEHMET ├çEL─░K	38.91645720	27.85092620	1
13741	47	020033418	MEHMET D. TUNALI/TUNALI K YEM─░┼Ş	38.92163900	27.83766300	1
13742	47	D2F031050	MEHMET KARAER	38.91714800	27.84466000	1
13743	47	D2F216648	MEHMET KO├ç	38.90939380	27.84221750	1
13744	47	D2F189931	MEHMET ┼ŞER─░F ├çET─░NKAYA	38.91309220	27.84710510	1
13745	47	D2F001080	MEHMET YILDIZ	38.91216950	27.84239370	1
13746	47	D2F216647	MEL─░SA AKG├£L	38.91543960	27.84366960	1
13747	47	D2F213415	MERT KARAPINAR	38.91326760	27.83583030	1
13748	47	D2F148845	MESUT ├çABUK	38.90872290	27.83688850	1
13749	47	D2F185137	MSTF AKARYAKIT GIDA NAKL─░YE ─░N┼ŞAAT LTD.┼ŞT─░. 2	38.89547230	27.78458730	1
13750	47	020033585	MUAZZEZ VER─░M/TAL─░H KU┼ŞU B├£FE	38.92122600	27.83965700	1
13751	47	D2F240283	MUHAMMED RA┼Ş─░D GAZ─░O─ŞLU	38.92189390	27.83449930	1
13752	47	D2F225700	MUHARREM YALPI	38.90688190	27.83879770	1
13753	47	D2F178227	MUSTAFA S├£R├£O─ŞLU- PAPATYA MARKET	38.90664900	27.82763900	1
13754	47	D2F221670	MUSTAFA YALPI	38.90725930	27.83941990	1
13755	47	D2F234368	M├£M─░N CAN KERT─░	38.91487730	27.83681310	1
13756	47	D2F002797	NA─░L KAPLAN	38.96214500	27.71101700	1
13757	47	D2F228728	NA─░M EMRAH G├£RKAN	38.92077670	27.83501160	1
13758	47	020033622	NECDET ├çET─░N/BABADAN TKL	38.92172400	27.83665700	1
13759	47	D2F041145	NERM─░N KAYA	38.90951800	27.82242000	1
13760	47	D2F235959	NEV─░N ├ç─░FT├ç─░	38.91921410	27.83566690	1
13761	47	D2F131055	NUR─░ AKAYKANMI┼Ş	38.91887110	27.83931350	1
13762	47	D2F003591	OKTAY K─░┼Ş─░	38.91075500	27.82210300	1
13763	47	D2F014257	OYFA MARKET ZEYT─░N OTO ALIM-SATIM TARIMSAL FAAL─░YETLER SAN.T─░C.LTD.┼ŞT─░	38.91103800	27.82879800	1
13764	47	D2F236615	OZAN KAYA	38.91870000	27.83668400	1
13765	47	D2F189070	├ûMER T├£RKO─ŞLU	38.91690620	27.83677280	1
13766	47	D2F100201	├ûRGE PETROL ├£R├£N.NAK.─░TH.─░HR.OTO.M├£T.TAAH.HAY.SAN.T─░C.LTD.┼ŞT─░.	38.90275200	27.83711700	1
13767	47	D2F131763	├ûZLEM TEPEL─░	38.91171320	27.83685530	1
13768	47	D2F107952	├ûZPOLATOGLU AKH─░SAR ─░TFA─░YE	38.91792700	27.84179500	1
13769	47	D2F118058	├ûZPOLATO─ŞLU AKH─░SAR RE┼ŞATBEY	38.92295020	27.83113750	1
13770	47	D2F107954	├ûZPOLATO─ŞLU AKH─░SAR SANAY─░	38.91385000	27.83679700	1
13771	47	D2F155815	├ûZPOLATO─ŞLU AKH─░SAR SEVG─░ YOLU	38.91896100	27.83563330	1
13772	47	D2F154887	PERENLER. PETROL SAN.VE TIC. LTD. STI	38.78700020	27.67051460	1
13773	47	D2F204443	POL─░S KANT─░N─░	\N	\N	1
13774	47	D2F141091	RAMAZAN UMUTLU	38.92152230	27.85122790	1
13775	47	D2F234611	REMZ─░ KURT	38.92099250	27.83591890	1
13776	47	D2F001343	RIZA URAN	38.91571900	27.83585800	1
13777	47	D2F132738	SABR─░ YIKILMAZ	38.91857440	27.83913150	1
13778	47	D2F114187	SAM─░ME Y├£KSEL	38.91874200	27.84724600	1
13779	47	D2F234498	SE├çK─░N TAN	38.88557560	27.76899080	1
13780	47	020033737	SE├çK─░N TEKEL MAD.GIDA TEM─░ZL─░K ME┼ŞRUBAT SAN.T─░C.LTD.┼ŞT─░.	\N	\N	1
13781	47	D2F172159	SE├çK─░NLER ALKOLL├£ ─░├çECEK GIDA AKARYAKIT TUR─░ZM ─░N┼Ş.LTD.┼ŞT─░.	\N	\N	1
13782	47	D2F228956	SEL├çUK NAR	38.91198850	27.82628480	1
13783	47	D2F205932	SEMA ├ûZKAN	38.86618960	27.74280180	1
13784	47	D2F189101	SERCAN KAHYA	38.91888970	27.83557070	1
13785	47	D2F001230	SERHAT BATUR	38.86621100	27.74214100	1
13786	47	D2F159012	SERTAN KARAKAYA	38.92200000	27.85550000	1
13787	47	D2F178849	SEV─░L PALA-M├£M─░N GIDA	38.88767910	27.77026800	1
13788	47	D2F216871	SEV─░N├ç ┼ŞAH─░N	38.91280170	27.84150160	1
13789	47	D2F241058	SIDDIKA AKBA┼Ş	38.91719070	27.84585180	1
13790	47	D2F203527	S├£LEYMAN TA┼Ş	38.90951600	27.84451500	1
13791	47	D2F233018	S├£VAR─░ AKARYAKIT SAN. VE T─░C. LTD. ┼ŞT─░	38.88837200	27.83985620	1
13792	47	D2F000696	TAHS─░N ├ç─░MEN	38.90804100	27.82553000	1
13793	47	D2F215788	TAMER ├û─Ş├£TTAN	38.89353110	27.77968490	1
13794	47	D2F156203	TARIK BURKAY	\N	\N	1
13795	47	D2F000898	TARIK ├ûVEZ	38.90573700	27.81093600	1
13796	47	D2F234616	TEK─░NLER ENERJ─░ SAN. T─░C. LTD.┼ŞT─░.	38.89638260	27.78841420	1
13797	47	D2F001252	TEVF─░K KAYAHAN	38.91383100	27.84037400	1
13798	47	D2F225787	TOLGAHAN KIS	38.91832980	27.83841390	1
13799	47	D2F143434	TUANA GRUP PETROL ├£R├£NLERI SANAYII VE TICARET LIMITED SIRKETI	38.85203540	27.73022710	1
13800	47	D2F001272	VASF─░ KAYA	38.86617200	27.74211300	1
13801	47	D2F170224	VEL─░ DO─ŞAN	38.91764580	27.83890760	1
13802	47	020033414	VOLKAN ┼ŞALAMBAR/KARDE┼ŞLER TKL	38.91865900	27.83668800	1
13803	47	D2F000700	YAKUP UYAR	38.91713700	27.83421500	1
13804	47	D2F119596	YETK─░N KIYAK	38.91591400	27.83870000	1
13805	47	D2F001495	YILDIZ U─ŞUN KIVRAK	38.91353200	27.83574600	1
13806	47	D2F000708	YUSUF YILMAZ	38.90571800	27.84698200	1
13807	47	D2F001466	ZEK─░ ARSLAN	38.91691800	27.84160400	1
13808	47	D2F238435	ZEL─░HA D├ûNMEZ	38.91532750	27.83676200	1
13809	48	D2F226288	ABDULLAH ├çALIK	39.07049570	27.89126160	1
13810	48	D24003364	ADEM Y├ûNTEM	39.17762300	27.84659900	1
13811	48	D2F179703	ADNAN ├ûNDE┼Ş	38.92424710	27.84141720	1
13812	48	D24028330	AHMET KAVRUK	39.18546600	27.72398800	1
13813	48	D2F025215	AHMET T├£RKO─ŞLU	38.83174530	28.02177230	1
13814	48	D2F218978	AHMET YA┼ŞAR 2	38.93085350	27.85279630	1
13815	48	D24002253	AHMET YILMAZ	39.11164100	27.81097100	1
13816	48	D2F184340	AKH─░SAR ├çINAR MARKET MEYVE ALIM SATIM LTD.┼ŞT─░.	38.92515920	27.84571740	1
13817	48	D2F155156	AL─░HAN ├çAVU┼Ş	38.93170280	27.84028830	1
13818	48	D2F133071	ALPER KARA	38.92104200	27.84293430	1
13819	48	D2F124620	AYDIN KARACA	38.92742470	27.84054390	1
13820	48	D2F229163	AYFA KAFETERYA VE MARKET├ç─░L─░K LTD.┼ŞT─░.	39.00531380	27.84709730	1
13821	48	D2F146697	AY┼ŞE ACUN	38.93360750	27.85262470	1
13822	48	D2F218446	BAHADIR DURGUT	38.92555600	27.84496530	1
13823	48	D2F210750	BALKES PETROL SANAY─░ VE T─░CARET L─░M─░TED ┼Ş─░RKET─░ LTD.┼ŞT─░. AKH─░SAR	38.99364940	27.84521750	1
13824	48	D2F182445	BARBAROSLAR ALETLER ZEYT─░NC─░L─░K PETROL GIDA TARIM LTD.┼ŞT─░.	38.98737880	27.86077840	1
13825	48	D2F130488	BASR─░ OKAN	38.93395690	27.84283950	1
13826	48	D2F003028	BEK─░R KARACA	39.06996760	27.89085090	1
13827	48	D2F195900	BERAT KARAKA┼Ş	38.92230970	27.83607120	1
13828	48	D2F235567	BERK DEM─░R	38.92695970	27.85536600	1
13829	48	D2F003859	B─░LGE G├£L	38.92923100	27.84759600	1
13830	48	D2F000977	BU─ŞRA MISIRLI	38.92241600	27.84115300	1
13831	48	D2F227004	BURKAY ─░├çECEK SAN. VE T─░C. LTD. ┼ŞT─░. AKH─░SAR 1	\N	\N	1
13832	48	D2F205300	B├£LENT U├çAR	38.92245480	27.84326470	1
13833	48	D24063730	B├£NYAM─░N G├ûKMEN	39.12738400	27.85499900	1
13834	48	D24003366	CEREN TUR.PETROL TUR.T─░C.LTD.┼ŞT─░	39.19294300	27.85289100	1
13835	48	D2F217554	CEYLAN ├çEL─░K	39.11470820	27.87775060	1
13836	48	D2F213031	C─░HAN AKSOY	39.11190440	27.81350870	1
13837	48	D2F231684	├çEL─░KSOY PETROL GIDA NAKL─░YE ─░N┼ŞAATSANAY─░ VE T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.99158590	27.84670130	1
13838	48	D2F180802	EBRU SERBEST	\N	\N	1
13839	48	D2F138719	EM─░NE AKT├£RK	38.92951930	27.83918020	1
13840	48	D2F065527	EMRE EM─░R	39.01421500	27.84223800	1
13841	48	D2F004390	EN─░S KURTKAYA	38.93373260	27.83805290	1
13842	48	D2F118964	ENVER ALPAY	38.93044700	27.84247600	1
13843	48	D2F001246	ERCAN ├ç├£MEN	38.92043400	27.84514400	1
13844	48	D2F001063	ERCAN ERTAN	38.92769200	27.83438000	1
13845	48	D24002347	ERS─░N BIYIK	39.16396100	27.70783900	1
13846	48	D2F138129	ES─░N ├çALI┼ŞKAN	38.92389580	27.83609750	1
13847	48	D2F070633	FAHRETT─░N ├çOBAN	39.02001600	27.91968300	1
13848	48	D2F003027	FAHRETT─░N KALBUZ	39.06997110	27.89084760	1
13849	48	D2F231171	FAT─░H ─░┼ŞB─░LEN	39.18375440	27.85147840	1
13850	48	D2F027115	FATMA KA├çAN	38.92051700	27.84446000	1
13851	48	D2F223575	FATMA ├ûZBAL	38.92171530	27.84187270	1
13852	48	D2F003297	FEVZ─░ T├£RKYILMAZ	38.96356090	27.90384490	1
13853	48	D2F085873	FEYZULLAH ├çALI	38.92595600	27.84584600	1
13854	48	D2F213308	G├£LSEM─░N ERKEK	38.92018740	27.84153470	1
13855	48	D2F211031	G├£LSEREN ├çET─░N	38.93142000	27.84532870	1
13856	48	D2F226506	G├£LS├£M G├£NER	38.92856700	27.84201600	1
13857	48	D2F216204	G├£L┼ŞEN I┼ŞIK	39.17792500	27.84615510	1
13858	48	D2F209710	HAKKI BATUR	39.16452020	27.70711770	1
13859	48	D24001831	HAL─░L ├çAMLIK	39.18577100	27.72369500	1
13860	48	D2F178996	HAL─░L ─░BRAH─░M DEM─░RCAN	38.92033070	27.84581340	1
13861	48	D2F004063	HAL─░L TEKBIYIK	38.93709000	27.84355600	1
13862	48	D2F000599	HAL─░S UZUN	39.01453200	27.84122200	1
13863	48	D2F172736	HARUN BARLIK	39.08244200	27.79349800	1
13864	48	D2F185577	HARUN CAN	38.92979190	27.84234210	1
13865	48	D2F003087	HARUN ├çET─░N	38.93006200	27.83444700	1
13866	48	D2F125193	HARUN S├ûNMEZ	38.92358640	27.84004110	1
13867	48	D2F029898	HASAN ├ç─░MEN	38.92065500	27.84343100	1
13868	48	D2F147380	HAT─░CE DE─Ş─░RMENC─░	38.92521420	27.83972540	1
13869	48	D2F202044	HAT─░CE G├ûK├çEBAK	39.01460410	27.84201260	1
13870	48	D2F003673	HAT─░CE KARANF─░L	38.92705010	27.84190410	1
13871	48	D2F203147	HAT─░CE ├ûZALP	38.92838300	27.83463500	1
13872	48	D2F003121	HAYRULLAH ├çEL─░K	38.92815200	27.83626300	1
13873	48	D2F188443	H─░SAR MARKET├ç─░L─░K GIDA PAZARLAMA LTD. ┼ŞT─░.	38.92871240	27.83520150	1
13874	48	D2F002994	H├£SEY─░N ├çATAL	38.92773560	27.83895940	1
13875	48	D2F160656	─░BRAH─░M G├ûKG├£L	38.92925710	27.84576120	1
13876	48	D2F170605	─░BRAH─░M G├£LER	39.21317150	27.78336000	1
13877	48	D2F001068	─░BRAH─░M SERT	38.92964000	27.83711300	1
13878	48	D2F000953	─░BRAH─░M UYSAL	38.92276500	27.84081700	1
13879	48	D2F231685	─░LKER UMUTLU	38.92088600	27.84331510	1
13880	48	D2F149688	─░SMA─░L ALTINDA─Ş	39.08085230	27.79433730	1
13881	48	D2F102825	─░SMA─░L KARDA┼Ş	38.93145170	27.83912550	1
13882	48	D2F221492	KAYA MOTORLU ARA├ç ─░N┼Ş.DAY.T├£K.MAL .PET.├£R.SAN .T─░C.A┼Ş AKH─░SAR	38.92350060	27.83455530	1
13883	48	D2F001204	KAZIM HAL─░S	38.92010000	27.84170000	1
13884	48	D24053198	KEMAL EREN	39.11219890	27.81238490	1
13885	48	D24002361	KEMAL UYAR	39.16623740	27.77211200	1
13886	48	D2F185580	KUTMAN KAYALI	39.12660540	27.85507450	1
13887	48	D24068237	MAYA LOJ─░ST─░K TA┼Ş. ─░N┼Ş. MAD. AKAR. GIDA SAN. VE T─░C. LTD. ┼ŞT─░.	39.19100700	27.85384900	1
13888	48	D2F235321	MEHMET ASLAN	38.92778770	27.83434740	1
13889	48	D24003371	MEHMET ├çAPA	39.17718600	27.84792300	1
13890	48	D2F164377	MEHMET DEM─░R	39.08235000	27.79338210	1
13891	48	D2F143902	MEHMET D─░LEK	38.93130440	27.84595820	1
13892	48	D2F237960	MEHMET H├£SEY─░N ERKEK	38.92470860	27.84623620	1
13893	48	D2F222864	MEHMET ISMIK	39.16902510	27.84443020	1
13894	48	D24003373	MEHMET KALBUZ	39.19367300	27.85422100	1
13895	48	D2F233196	MEHMET OKAN	38.93576720	27.83683740	1
13896	48	D2F000646	MEHMET ├ûK├ç├£N	38.92023360	27.84323360	1
13897	48	D2F197289	MUHAMMED MUSTAFA ├ûZDEM─░R	39.01450490	27.84143350	1
13898	48	D2F003896	MUH─░TT─░N YILMAZ	38.99594040	27.86749200	1
13899	48	D2F149385	MUSA K├£T├£K	39.17761500	27.84747500	1
13900	48	D2F091737	MUSTAFA AL─░ BANAK	38.93406700	27.85371000	1
13901	48	D2F135098	MUSTAFA DUR─ŞAN	38.92525700	27.83578700	1
13902	48	D2F220111	MUSTAFA OZAN	38.96300080	27.89959880	1
13903	48	D2F001284	MUSTAFA TIRMIK	38.92457900	27.84006200	1
13904	48	D24003392	NED─░M G├ûKMEN	39.12790600	27.85632400	1
13905	48	D2F000974	NURETT─░N EK─░NC─░	38.92861300	27.85501800	1
13906	48	D2F239559	├ûZGE AL┼ŞAN	38.93152050	27.84939590	1
13907	48	D2F242907	├ûZNUR KURTARAN	42.94838100	34.13287400	1
13908	48	D2F150573	PER─░HAN KAPLAN	38.92068460	27.84187240	1
13909	48	D2F226768	PINAR KAVAKLI	38.92078590	27.84226630	1
13910	48	D2F001072	RAMADAN AHMETO─ŞLU	38.92465700	27.83545880	1
13911	48	D2F143992	RAMAZAN OLCAY	38.93279100	27.84262100	1
13912	48	D2F162188	R─░ZA ├çAKIR	38.92947580	27.84429350	1
13913	48	D2F232835	RJN GIDA ─░N┼Ş. T├£T├£N ─░├çECEK SAN. VE T─░C. LTD. ┼ŞT─░.	\N	\N	1
13914	48	D2F170327	RUK─░YE KINAY	38.92184760	27.84114640	1
13915	48	D2F001257	SABR─░ BALABAN	38.92906000	27.84750000	1
13916	48	D2F001233	SAVA┼Ş TUTAL	38.92757500	27.83436100	1
13917	48	D2F001195	SERKAN ANABERK	38.92123950	27.84605990	1
13918	48	D24111241	S─░BAPET AKARYAKIT LOJ─░ST─░K TUR─░ZM ─░┼ŞLETMEC─░L─░─Ş─░ GIDA ─░N┼ŞAAT SAN.VE T─░C	39.12904300	27.84018100	1
13919	48	D2F146377	S├£LEYMAN CAN DEM─░RAYAK	38.92665960	27.83730170	1
13920	48	D2F001110	S├£LEYMAN KARANF─░L	38.92548100	27.84520500	1
13921	48	D24002632	S├£LEYMAN KARAPINAR	39.08082300	27.79451500	1
13922	48	D2F204751	┼ŞAHAPO─ŞULLARI ─░LET─░┼Ş─░M GIDA VE PETROL ├£R├£NLER─░ SANAY─░ VE T─░CARET L─░M─░T	39.04337350	27.86586180	1
13923	48	D2F001077	┼ŞEVK─░ ├£┼ŞENMEZ	38.92313800	27.83682790	1
13924	48	D2F004221	┼ŞUAY─░BE SALI	38.92762600	27.84639300	1
13925	48	D2F004316	┼ŞUHAY─░P AKKO├ç	39.00381300	27.91140400	1
13926	48	D2F180397	TANER BA─Ş	38.92531400	27.83675690	1
13927	48	D2F196656	TORBALI TUR─░ZM TA┼Ş.PET.├£RN.T─░C.LTD.┼ŞT─░.	39.16720550	27.84307490	1
13928	48	D2F038657	TUN├çAY YILDIRIM	38.96227290	27.90156620	1
13929	48	D2F209461	TURMAR MARKET├ç─░L─░K SANAY─░ VE T─░CARET LTD.┼ŞT─░.	38.93156030	27.84984600	1
13930	48	D2F210506	TURMAR MARKET├ç─░L─░K SANAY─░ VE T─░CARET LTD.┼ŞT─░. L─░SE	38.92529870	27.83589200	1
13931	48	D2F210508	TURMAR MARKET├ç─░L─░K SANAY─░ VE T─░CARET LTD.┼ŞT─░. M─░N─░	38.92286010	27.83514180	1
13932	48	D2F042731	T├£NCER AYDIN	38.92098300	27.84368200	1
13933	48	D2F092719	VAH─░DE DEM─░RG├£L	38.92533800	27.83732400	1
13934	48	D2F000959	YA┼ŞAR YAVA┼Ş	38.92497100	27.83593000	1
13935	48	D2F154810	YUSUF OYMAK	38.93281590	27.85168170	1
13936	48	020033515	ZA─ŞLI MARKET├ç─░L─░K LTD ┼ŞT─░	38.93371500	27.83486600	1
13937	48	D2F156926	ZEHRA HAL─░S	38.93235150	27.84263730	1
13938	48	D24003387	ZEKER─░YA ESER	39.11418400	27.87763500	1
13939	48	020033431	Z├£LEYHA ACARCA	38.94907900	27.83578700	1
13940	23	D2F024981	AHMET FURKAN DEVRAN	38.92694000	27.83267600	1
13941	23	D2F220283	AHMET KINDA├ç	38.92723390	27.82990960	1
13942	23	D2F197165	AHMET ORMAN	39.10313540	27.67016370	1
13943	23	D2F151405	AHMET YA─ŞMURLU	39.10662310	27.68171210	1
13944	23	020025248	AHMET YO─ŞUN	39.10536200	27.67297100	1
13945	23	D2F223732	AL─░ AKG├£L	38.92200720	27.82273590	1
13946	23	D24085346	AL─░ DO─ŞAN	39.10968650	27.67911960	1
13947	23	D2F239466	AL─░ OSMAN KAYABA┼ŞI	42.94838100	34.13287400	1
13948	23	D2F132507	AL─░M ├ûZBEK	38.68019170	27.51615780	1
13949	23	D2F233783	ASUMAN UYGUN	38.92801290	27.82191850	1
13950	23	D2F187412	ATLI PETROL ├£R├£NLER─░ SAN.T─░C.LTD.┼ŞT─░	38.68026870	27.50609200	1
13951	23	D24071328	AYHAN G├£LMEZ	39.10173900	27.67722300	1
13952	23	D2F202217	AYHAN U─ŞRA┼Ş	38.68040040	27.52375180	1
13953	23	D2F231298	AYNUR KENT	39.10901290	27.67603890	1
13954	23	D2F241477	AYSEL KIRBA┼Ş	39.10403830	27.67100790	1
13955	23	D2F002391	AY┼ŞE AVCI	38.66960070	27.47264700	1
13956	23	D2F095251	AY┼ŞE CILIZ	38.66959700	27.47261190	1
13957	23	D2F182654	AY┼ŞEN ┼ŞEN	38.92649910	27.83207600	1
13958	23	D2F236904	AYTU KOZMET─░K OTOMOT─░V ─░LET─░┼Ş─░M SAN.T─░C.LTD.┼ŞT─░.	38.67970000	27.47880800	1
13959	23	D2F224549	BAHAR AYDIN	39.10631410	27.67811370	1
13960	23	D24111421	BAHR─░YE G├£M├£┼Ş	39.08422900	27.71178800	1
13961	23	D2F143334	BANU YILDIRAK	38.68235300	27.48490600	1
13962	23	D2F145308	BARI┼Ş ├çET─░N	38.92600810	27.82966020	1
13963	23	D2F203252	B─░RG├£L KAVUNCULAR-SE├ç MARKET	38.67970340	27.51754000	1
13964	23	020033677	B├£LENT G├ûYN├£/EFES 5	38.92303400	27.83236200	1
13965	23	D2F225026	CANSU BARCA	38.94175600	27.83109700	1
13966	23	D2F192554	CEM KAYA	38.92109210	27.82942540	1
13967	23	D2F027595	CEM─░L OSEN KENT	38.92289400	27.82999700	1
13968	23	D24102800	CENNET YAL├çIN	39.10891500	27.67669500	1
13969	23	D2F193189	CO┼ŞKUN ├çEL─░K	38.92267000	27.81805700	1
13970	23	D2F223199	├çA─ŞATAY GEL─░R	38.92777720	27.82287110	1
13971	23	D2F241397	├çA─ŞLAR DO─ŞAN	38.92673230	27.83055940	1
13972	23	D2F222940	EK─░NA GIDA OTOMOT─░V SAN. VE T─░C. LTD. ┼ŞT─░.	38.93457800	27.83086870	1
13973	23	D2F235684	EKREM KARAMAN	38.91466200	27.82933000	1
13974	23	D2F231117	ELDEHA PETROL ├£R├£NLER─░ TA┼ŞIMACILIK SAN. VE T─░C. LTD.	38.68086300	27.48343500	1
13975	23	D2F211177	EL─░F ERDEM	39.10748900	27.67951710	1
13976	23	D2F031393	ENG─░N ┼Ş─░M┼ŞEK 1	38.68348800	27.48765700	1
13977	23	D2F000076	ENG─░N ┼Ş─░M┼ŞEK 2	38.67999100	27.51679200	1
13978	23	D2F083167	ERDAN BO┼ŞNAK	38.91748200	27.82771500	1
13979	23	D2F170904	ERD─░N├ç AKAT	38.91677830	27.82063330	1
13980	23	D2F144528	ERDO─ŞAN H├£SEY─░NO─ŞLU	39.10389240	27.67848010	1
13981	23	D2F068916	ERGUN ERLU	38.92644600	27.83332400	1
13982	23	D24002213	ERS─░N YO─ŞUN	39.10663400	27.67439400	1
13983	23	D24036590	FAHR─░ DEM─░R	39.10341500	27.67134900	1
13984	23	D2F026205	FATMA BOZO─ŞLU	38.68075500	27.50941800	1
13985	23	D2F224881	FATMA DALGI├ç	38.93433500	27.83073400	1
13986	23	D2F216502	FIRAT BA┼ŞER	38.93172740	27.83378180	1
13987	23	D24003083	F─░GEN DUMAN	39.10570000	27.67280000	1
13988	23	020033490	G├£L BAYRAMLAR/BAYRAMLAR TKL	38.92623720	27.83392230	1
13989	23	D2F172460	G├£LER TEZCAN	39.08016140	27.70439770	1
13990	23	D2F214213	G├£LSE ├ç─░├çEK	38.92873900	27.81896850	1
13991	23	D2F003615	G├£NAY HAKTAN	38.92773560	27.82559240	1
13992	23	D24002811	G├£VEN T─░C.KOLL.┼ŞT─░.	39.09919500	27.67679200	1
13993	23	D2F197587	HACER KAYGISIZ	38.92743100	27.83001700	1
13994	23	D24143562	HAL─░ME I┼ŞIK	39.10653770	27.67388640	1
13995	23	D24027052	HASAN YANAR	39.10238400	27.67322400	1
13996	23	D2F003134	HAT─░CE ├çIK	38.92299400	27.83112300	1
13997	23	D2F100632	HGM AKARYAKIT TASIMACILIK INSAAT MADENCILIK GIDA SAN.VE LTD.┼ŞT─░.	38.70269600	27.52460200	1
13998	23	D2F093363	HISAR ZEYTINCILIK GIDA MALLARI SANAYII TICARET VE PAZARLAMA LIMITED SI	38.94342400	27.83261200	1
13999	23	020025247	─░BRAH─░M KIVRAK	\N	\N	1
14000	23	D2F229221	─░DR─░S YILDIRIM	38.92296750	27.83072790	1
14001	23	D24002226	─░SKENDER DEM─░R	39.11067800	27.67355400	1
14002	23	D24028567	KEMAL OLU	39.11175600	27.67323400	1
14003	23	D2F219423	KER─░M ├çALAYIR	38.91526450	27.82218840	1
14004	23	D24002241	MEHMET AY	39.10618900	27.67669700	1
14005	23	D2F179901	MEHMET ├çAKIR	38.92092470	27.83162260	1
14006	23	D24002295	MEHMET KOZACI	39.10565600	27.67105400	1
14007	23	D2F236442	MEHMET ├ûMER ├ûZDEM─░R	38.92520510	27.82905450	1
14008	23	D2F239588	MEL─░KE AYDIN	38.91718190	27.82152070	1
14009	23	D2F242523	MERT SEZD─░	38.91436840	27.79892700	1
14010	23	D2F212139	MERT ULA┼Ş	39.11320240	27.66471110	1
14011	23	D2F063945	MET─░N CANTEN	38.91420200	27.79888500	1
14012	23	D2F215439	MEVLUD─░YE SA─ŞDI├ç	39.11145470	27.66837660	1
14013	23	D2F126715	MURAT AKBA┼Ş	38.91803250	27.81760140	1
14014	23	D24126397	MUSA EFE	39.17774970	27.84744940	1
14015	23	D2F225513	MUSTAFA ALKAYA	39.10309390	27.67213880	1
14016	23	D24002198	MUSTAFA ANIK	39.10508400	27.67206500	1
14017	23	D2F163087	MUSTAFA BO─ŞA	38.92292410	27.82827220	1
14018	23	D2F221128	M├£CAH─░D UYMAZ	39.10746700	27.67618600	1
14019	23	D24002354	M├£CAH─░T TEZCAN	39.08022700	27.70492300	1
14020	23	D2F001019	NALAN SARPTA┼Ş	38.93210200	27.82594000	1
14021	23	D24114123	NAZAN BEYTORUN	39.10949000	27.67311200	1
14022	23	D2F165981	NAZ─░FE PALAMAN-SE├ç MARKET	38.92648600	27.83144060	1
14023	23	D2F186313	NEVZAT ┼ŞENAY	38.93408620	27.83040920	1
14024	23	D2F092665	NURCAN CEYHAN	38.92878700	27.83112500	1
14025	23	D2F162138	NURG├£L KO├ç	38.93288400	27.82837670	1
14026	23	D2F225911	NUR─░YE G├£NAY	38.92772860	27.82505610	1
14027	23	D24002261	├ûKS├£ZO─ŞLU PETROL LTD.┼ŞT─░.	39.10110000	27.69100000	1
14028	23	D2F100490	├ûMER AKG├£L	38.93291500	27.82503500	1
14029	23	D2F201093	├ûMER PEK├£N	39.08002040	27.70458490	1
14030	23	D24003524	├ûRSSAN PETR.─░N┼Ş.GIDA.LTD.┼ŞT─░.KIRKA─ŞA├ç ┼ŞB	39.05934900	27.72789000	1
14031	23	D2F000196	├ûZCAN KAYA	38.68275000	27.48625400	1
14032	23	D24002313	├ûZGEN ├ûZBEKEN	39.10532000	27.67286200	1
14033	23	D24084195	PER─░HAN ├çEL─░K	39.10622600	27.67772600	1
14034	23	D2F224277	PKR GIDA T─░CARET LTD. ┼ŞT─░.	38.91923600	27.81862500	1
14035	23	D2F004435	REMZ─░ TOKCAN	38.92299500	27.82929600	1
14036	23	D2F242598	RUK─░YE TUR─ŞAN- SE├ç MARKET	39.10630070	27.67931580	1
14037	23	D2F000193	S.S.MERKEZ YEN─░K├ûY TARIMSAL KALKINMA KOOPERAT─░F─░	38.68407400	27.48819100	1
14038	23	D24045167	SEDAT ALTAY ZEYT─░N ├£R. PET. TUR. ─░N┼Ş. PAZ. SAN. T─░C. LTD. ┼ŞT─░.	39.08401150	27.71169650	1
14039	23	D2F238065	SEDAT BA┼ŞAK	38.91680560	27.83124810	1
14040	23	D2F001399	SERHAT ├çAKIR	38.92857600	27.82823600	1
14041	23	D24096432	SERHAT KARAKAYA	39.10186100	27.67454300	1
14042	23	D2F191273	SERP─░L AT─░LA	38.92244390	27.82491530	1
14043	23	D2F175171	SEVAL KARABIYIK	38.92103790	27.82939800	1
14044	23	D2F234094	SULTAN ─░┼ŞLER	38.92136370	27.82058070	1
14045	23	D2F003522	S├£LEYMAN GEZER	38.92287000	27.83407900	1
14046	23	D2F003054	┼ŞER─░F ├çAMKIRAN	38.92319700	27.82996200	1
14047	23	D24002763	┼ŞEVKET KOYU├ûZ	39.10467200	27.67058600	1
14048	23	D2F233017	TAHS─░N DEM─░RKAN	39.11188260	27.67038430	1
14049	23	D2F184202	TARIK F─░L─░Z	38.67887430	27.52274190	1
14050	23	D2F162567	TENNUR DO─ŞAN	39.11152630	27.67843630	1
14051	23	D2F199475	TU─Ş├çE TOKCAN	38.92242170	27.82508170	1
14052	23	D2F175772	TURAN KARA	38.92254780	27.82605210	1
14053	23	D24136894	UTKU T├ûR	39.11317570	27.68022690	1
14054	23	D2F181780	├£M├£T ERG─░YEN	38.92117430	27.83084830	1
14055	23	D2F003784	├£NL├£ PET.├£RL.TARIM Z─░R. ALET VE ─░N┼Ş.SAN. VE T─░C.LTD.┼ŞT─░.	38.69326600	27.50683100	1
14056	23	D2F197483	VEL─░ ARMA─ŞAN	38.92274380	27.82053090	1
14057	23	D2F000557	YAKUP USTA	38.92798700	27.82170400	1
14058	23	D2F188233	YEN─░ KOZA MARKET├ç─░L─░K OTOMOT─░V ─░N┼ŞAAT LTD.┼ŞT─░.	39.10628370	27.67778280	1
14059	23	D2F025079	Y─░─Ş─░T ├çENEL─░	38.91454800	27.82780200	1
14060	23	D2F162417	YUNUS CAN G├ûK	39.10588420	27.67520180	1
14061	23	D2F235851	YUSUF EFE ZENG─░N	39.10673030	27.67458810	1
14062	23	D2F003936	ZAFER ├çABUK	38.92798400	27.82098700	1
14063	23	D2F151285	ZEHRA DERV─░┼Ş	38.91795690	27.83203350	1
14064	23	D2F001490	ZEK─░YE B─░LG─░├ç	38.92288000	27.82815800	1
14065	23	D2F115489	ZEYNEP AKKU┼Ş	38.68530900	27.49086300	1
14066	23	D2F178048	ZEYNEP PARILDAR	39.10930110	27.66994630	1
14067	23	D2F049131	Z─░YA ADAG├£L├£	38.92525600	27.82888800	1
14068	57	D2F118968	AKH─░SAR T T─░P─░ CEZAEV─░	38.98741670	27.77988690	1
14069	57	D2F001105	CEZA EV─░ AKH─░SAR ─░┼Ş YURDU M├£D.	38.91101300	27.83716600	1
14070	57	D2F183636	KIRKA─ŞA├ç JANDARMA KOMANDO E─Ş─░T─░M MERKEZ─░ KOMUTANLI─ŞI KANT─░N BA┼ŞKANLI─ŞI	39.11520580	27.67165250	1
14071	57	D2F057837	MAN─░SA A├çIK CEZA ─░NFAZ KURUMU ─░┼Ş YURDU M├£D├£RL├£─Ş├£	38.73606000	27.41436600	1
14072	57	D2F001986	MAN─░SA E T─░P─░ KAPALI CEZA ─░NFAZ KURUMU ─░┼ŞYURDU M├£D├£RL├£─Ş├£	38.61173200	27.47702100	1
14073	57	D2F001987	MAN─░SA ─░L JANDARMA KOMUTANLI─ŞI KANT─░N BA┼ŞKANLI─ŞI	38.61558600	27.44836300	1
14074	57	D2F055684	MAN─░SA T T─░P─░ KAPALI CEZA EV─░	38.73606000	27.41436600	1
14075	57	D2F241536	┼Ş─░M┼ŞEKO─ŞLU SAVUNMA SANAY─░	42.94838100	34.13287400	1
14076	57	D2F229296	T├£RKER─░ OTOMAT S─░STEMLER─░ GIDA TUR─░ZM ─░N┼ŞAAT NAKL─░YAT SAN. A.┼Ş	38.61373660	27.40602400	1
14077	49	D2F002792	AB─░D─░N EREN	38.93926600	27.65687900	1
14078	49	D2F002026	ADNAN KEREM	38.80545900	27.76931400	1
14079	49	D2F235322	AHMET AKDA┼Ş	38.79068160	27.72254990	1
14080	49	D2F196310	AHMET G├ûKDEM─░R	38.79281290	27.72054520	1
14081	49	D2F229782	AHMET YAVUZ	38.67817820	27.94605650	1
14082	49	D2F003249	AL─░ AKI┼Ş	38.71436800	27.91960500	1
14083	49	D2F002990	AL─░ MERTER	38.82675740	27.67725110	1
14084	49	D2F128341	AL─░ ┼ŞAH─░N	38.83240130	27.67996390	1
14085	49	D2F014981	AL─░ UYGUN	38.87879300	27.55270200	1
14086	49	D2F241009	AL─░ YELVER	38.71343700	27.91730400	1
14087	49	D2F175730	ASLAN KARATA┼Ş	39.01550380	27.71654580	1
14088	49	D2F173262	ATAHAN ├£NAL	38.71732050	27.91618070	1
14089	49	D2F088081	ATLI PETROL ├£R├£NLER─░ SANAY─░ VE T─░CARET LTD.┼ŞT─░. - ATLI PETROL ├£R├£NLER─░	38.74115900	27.60481500	1
14090	49	D2F001909	AYDIN DEN─░Z	38.76128200	27.68225200	1
14091	49	D2F110663	AY┼ŞE D├£ZKAYA	38.71201700	27.91971750	1
14092	49	D2F043891	BAHR─░YE\tA├çAN	38.84797840	27.69457350	1
14093	49	D2F131530	BAK─░ CEYHAN	38.93965810	27.65548310	1
14094	49	D2F085252	BEK─░R KALKAN	38.70477800	27.91792900	1
14095	49	D2F002046	B─░ROL G├ûR├£N	38.70971200	27.91914100	1
14096	49	D2F211440	B─░RSEL ├ç─░├çER	38.80444040	27.77013030	1
14097	49	D2F230374	BUKET SARI	38.80429690	27.77039590	1
14098	49	D2F160095	CEYHUN YILMAZ	38.75454520	27.62959810	1
14099	49	D2F188017	DEM─░RKOL PETROL LTD.┼ŞT─░.	38.76878750	27.65648630	1
14100	49	D2F183708	ECEV─░T OSKAY	38.96615480	27.51923780	1
14101	49	D2F100427	EM─░NE BA┼ŞARAN	38.69754180	27.87031460	1
14102	49	D2F237422	EMSOBB ─░N┼ŞAAT SANAY─░ VE T─░CARET LTD ┼ŞT─░	38.75222430	27.62664080	1
14103	49	D2F234326	ENERJ─░ BENZ─░N ─░STASYONU OTO. KUY. GIDA ─░N┼Ş. TUR. SAN.T─░C. LTD.┼ŞT─░.	38.76048800	27.64196600	1
14104	49	D2F002002	ERCAN AY	38.70924600	27.91839200	1
14105	49	D2F217045	ERCAN CEREN	38.71145230	27.91957420	1
14106	49	D2F001120	ERHAN BARIN	38.80535800	27.77584600	1
14107	49	D2F127378	ERKAN PAM.├çIR.TAR.├£RN AKY.VE MAD. YAGL OTO YDK PR├ç VE LAS. SAN.TIC.LTD	38.71470500	27.92058100	1
14108	49	D2F001860	ERKAN SAN. T─░C. LTD. ┼ŞT─░.	38.64738000	27.93169400	1
14109	49	D2F234125	ERKANLAR ├£Z├£M TAR. ├£RN.GID.─░TH.─░HR.SAN.VE T─░C LTD.┼ŞT─░	38.67829800	27.94592960	1
14110	49	D2F228978	FATMA KINALI	38.71455560	27.91831430	1
14111	49	D2F095132	FIRAT KOLCU	38.71281200	27.91936300	1
14112	49	D2F173581	FUAT YILMAZ	38.87885980	27.55249090	1
14113	49	D2F151175	GAMZE F─░DAN	38.98850470	27.67636950	1
14114	49	D2F001234	G├ûKHAN TUN├ç├ûZ	38.88216470	27.59982630	1
14115	49	D2F003236	HAKAN TAYLAN	38.71340500	27.91748400	1
14116	49	D2F196191	HAL─░L BA┼ŞLI	38.77866000	27.87769480	1
14117	49	D2F001941	HAL─░L ─░BRAH─░M TOSUN	38.87270400	27.60536600	1
14118	49	D2F001413	HAL─░L ├ûZT├£RK	38.99300500	27.67452900	1
14119	49	D2F213280	HAL─░L ├£NAL	38.87273600	27.60444800	1
14120	49	D2F240577	HAMD─░ T├£RKKOL	38.80533730	27.77595900	1
14121	49	D2F025537	HASAN AKYOL	38.80459800	27.77041800	1
14122	49	D2F002798	HASAN AL─░ AKAN	38.87189200	27.60094300	1
14123	49	D2F001917	HASAN AL─░ YILDIZ	38.87168500	27.60215000	1
14124	49	D2F004426	HASAN H├£SEY─░N SARGIN	38.82578600	27.61785700	1
14125	49	D2F030727	HAT─░CE D├ûNMEZ	38.74734700	27.82445800	1
14126	49	D2F074846	H─░MMET YAPRAK	38.64052380	27.92919930	1
14127	49	D2F117863	H├£SEY─░N MALAK	38.70942500	27.83784100	1
14128	49	D2F160850	H├£SEY─░N UBUZ	38.80588540	27.77043770	1
14129	49	D2F150686	─░BRAH─░M DA─ŞLI	38.70922930	27.83782140	1
14130	49	D2F048521	─░BRAH─░M OKTAR	38.77926900	27.87712000	1
14131	49	D2F185775	─░LHAN UYKUN	38.74748010	27.82470480	1
14132	49	D2F070333	─░RFAN TUTAN	38.88622700	27.67332900	1
14133	49	D2F002045	─░SA AKI┼Ş	38.71411500	27.91896700	1
14134	49	D2F003866	─░SMA─░L ALP	38.70286750	27.97471910	1
14135	49	D2F002031	─░SMA─░L KAHRAMAN	38.71635700	27.90592300	1
14136	49	D2F188253	─░SMA─░L S├£MER	38.99151360	27.67795570	1
14137	49	D2F132524	─░ZZET ├çAKMAK	38.66467610	28.03237550	1
14138	49	D2F189195	KAD─░R DO─ŞDAN	38.75148300	27.60430800	1
14139	49	D2F224041	KADR─░YE OLGUN	38.73893100	27.83467300	1
14140	49	D2F002020	KAM─░L ─░SKE├ç	38.73902500	27.83500500	1
14141	49	D2F003839	KASIM L─░├çEN	38.71655100	27.90489700	1
14142	49	D2F003444	KAYALI AKARYAKIT LTD.┼ŞT─░./MUSTAFA G├ûKHAN KAYALI-2	38.93226100	27.78585100	1
14143	49	D2F003069	KAZIM KAZICI	38.75094800	27.60459200	1
14144	49	D2F192326	LAT─░F AYTA├ç	38.75108650	27.60381750	1
14145	49	D2F237196	L├£TF─░YE ATLAR	38.71108360	27.91906990	1
14146	49	D2F004006	MED─░NE KARACA	38.72540990	28.02984280	1
14147	49	D2F004356	MEHMET AL─░ ARSLAN	38.94499100	27.55308900	1
14148	49	D2F034626	MEHMET AL─░ Z─░YANAK	38.71755500	27.90581500	1
14149	49	D2F003692	MEHMET BOZKIR	38.96772800	27.52086600	1
14150	49	D2F203739	MEHMET ├çA─ŞIR	38.93937910	27.65729550	1
14151	49	D2F114789	MEHMET DE┼ŞEK	38.87142740	27.60247050	1
14152	49	D2F186015	MEHMET EM─░N K├ûYL├£	38.71429070	27.91891370	1
14153	49	D2F001346	MEHMET G├£LAL	38.80727900	27.66464500	1
14154	49	D2F161519	MEHMET G├£NG├ûR	38.93712950	27.69882220	1
14155	49	D2F173464	MEHMET KARAPEHL─░VAN	38.76134460	27.68292630	1
14156	49	D2F001349	MEHMET KEMAHLI	38.93929300	27.65733900	1
14157	49	D2F124925	MEL─░H G├ûRER	38.93660800	27.70052000	1
14158	49	D2F237429	MEMET UZUN	38.70805700	27.91689530	1
14159	49	D2F003752	M─░THAT G├û├çMEN	38.96633400	27.51952700	1
14160	49	D2F003279	MUAMMER DEM─░R	38.64045600	27.92927400	1
14161	49	D2F171752	MUHAMMER G├£NG├ûR TARIM GIDA VE TA┼Ş─░MACILIK OTOMOT─░V LTD.┼ŞT─░.	38.72091370	27.91930120	1
14162	49	D2F003572	MUHAMMET TAN	38.68286300	27.89471600	1
14163	49	D2F214073	MURAT ┼ŞAHANKAYA	38.80684780	27.66638810	1
14164	49	D2F203458	MUSTAFA AKYILMAZ	38.74438960	27.72706090	1
14165	49	D2F194633	MUSTAFA AL─░ SANCAK	38.80548660	27.76939250	1
14166	49	020034031	MUSTAFA D─░KEN	38.75439100	27.62984100	1
14167	49	D2F240862	MUSTAFA DO─ŞAN G├ûZTEPE	38.79274460	27.72085350	1
14168	49	D2F115484	MUSTAFA ZEYREK	38.74311500	27.72606650	1
14169	49	D2F156208	NE┼ŞE YAVRULAR	38.71430310	27.91363480	1
14170	49	D2F002018	NEV─░N HANYALIG─░L	38.73886600	27.83621700	1
14171	49	D2F120827	N─░LG├£N ├£R├£NAL	38.79550380	27.79148760	1
14172	49	D2F241823	NUR┼ŞEN ├ûZKOL	38.99415320	27.67101010	1
14173	49	D2F150577	NUSRETT─░N ─░STEK	38.88892300	27.67454470	1
14174	49	D2F240352	OKAN OKTAV	38.98871640	27.67747440	1
14175	49	D2F001499	ORHAN KUZGUN	38.99144600	27.67791300	1
14176	49	D2F001420	├ûNDER ├ûNL├£	38.79537900	27.79186600	1
14177	49	D2F001814	├ûZAY BACAK	38.71418300	27.91379400	1
14178	49	D2F196981	PER─░HAN EFE	38.83386940	27.67980760	1
14179	49	D2F195099	RAMAZAN AYDIN- SE├ç MARKET	38.71312420	27.91469570	1
14180	49	D2F002251	RECEP TAN	38.75434600	27.62883300	1
14181	49	D2F117070	RECEP YAS─░N BEKLER	38.75098300	27.60456500	1
14182	49	D2F032124	REMZ─░ ├çET─░N	38.93889000	27.65620100	1
14183	49	D2F001939	RE┼ŞAT ┼ŞEN	38.88897810	27.67443120	1
14184	49	D2F148809	SAB─░T SALMAN	38.68323350	27.89418720	1
14185	49	D2F144360	SABR─░ DEM─░R	38.77545300	27.88070700	1
14186	49	D2F131531	SAF─░YE CAN	38.75124410	27.59923000	1
14187	49	D2F204360	SAL─░M ├ûNL├£	38.79628060	27.79170510	1
14188	49	D2F209376	SARUHANLI PETROL OTOMOT─░V GIDA NAKL─░YAT SAN. VE T─░C. LTD. ┼ŞT─░	38.73777950	27.59530540	1
14189	49	D2F004324	SEBAHATT─░N KARABULUT	38.76177750	27.68327170	1
14190	49	D2F080197	SERDAR KARADA─Ş	38.80702900	27.66653300	1
14191	49	D2F236454	SERHAT G├£LTEK─░N	38.96703960	27.63366900	1
14192	49	D2F137277	SERKAN AKAR	38.95128700	27.63081530	1
14193	49	D2F241439	SEVAL TA┼ŞDEM─░R	38.99455460	27.67003530	1
14194	49	D2F003643	SEV─░M DEM─░R	38.76139300	27.68319000	1
14195	49	D2F001381	SITKI ┼ŞAH─░N	39.01401500	27.65151500	1
14196	49	D2F160093	S─░NAN DAVUTO─ŞLU	38.75110690	27.60304430	1
14197	49	D2F189017	SMF PETROL LOJ─░ST─░K TARIM ─░N┼ŞAAT LTD.┼ŞT─░.	38.81738000	27.69937100	1
14198	49	D2F003270	SUAT CO┼ŞKUN	38.87268500	27.60478400	1
14199	49	D2F232990	S├£LEYMAN YILDIRIM	38.75128020	27.60294140	1
14200	49	D2F001334	┼ŞAH─░N S├ûYKE	38.77969300	27.87658300	1
14201	49	D2F218526	┼ŞEREF KARAKULAK	38.77515500	27.88145800	1
14202	49	D2F160725	┼ŞEREF PEHL─░VAN	38.71497420	27.92067480	1
14203	49	D2F003539	┼ŞER─░F AHMET YILMAZ	38.87878400	27.55252900	1
14204	49	D2F242851	┼ŞER─░FE B─░LG─░├ç	38.70730970	27.91763220	1
14205	49	D2F002009	TAN TU─ŞRULTEK─░N	38.71140100	27.91503900	1
14206	49	D2F108483	TOLGA ATICIO─ŞLU	38.75599500	27.63085200	1
14207	49	D2F003641	TUNCAY S─░NEM	38.75386000	27.62922300	1
14208	49	D2F165203	TURGUT AVKIRAN	38.83435400	27.61502790	1
14209	49	D2F229673	U─ŞUR KU┼Ş├çU	38.84811820	27.69371490	1
14210	49	D2F182082	├£M─░T ER─░┼ŞKEN	38.74303870	27.72653580	1
14211	49	D2F003510	├£NAL ADE┼Ş	38.82180000	27.87952700	1
14212	49	D2F001384	VEYSEL KANDEM─░R	38.79287800	27.72187600	1
14213	49	D2F116242	YASIN TARI	38.68408110	27.89422630	1
14214	49	D2F000704	YA┼ŞAR ├çAKIR	38.79421980	27.90702430	1
14215	49	D2F004429	YA┼ŞAR HELEKCAN	38.87278600	27.60381500	1
14216	49	D2F216290	YA┼ŞAR KIRKAYA - SE├ç MARKET	38.77878080	27.87796890	1
14217	49	D2F187801	YAZARLAR PETROL VE TUR─░ZM ─░N┼Ş.NAK.OTO LTD.┼ŞT─░. ─░SHAK├çELEB─░	38.75750380	27.63600950	1
14218	49	D2F082777	YIKMAZLAR ZEYT─░NC─░L─░K GIDA MAD.SAN. VE T─░C.LTD.┼ŞT─░.	38.88896600	27.67516400	1
14219	49	D2F183509	YUNUS TURHAN	38.93687050	27.70031150	1
14220	49	D2F003034	ZAFER KARATA┼Ş	38.83434000	27.68047700	1
14221	49	D2F220033	ZEHRA KARACA	38.73893100	27.83520300	1
14222	49	D2F137276	ZEKA─░ KOCACIK	38.88904820	27.67588300	1
14223	49	D2F183027	ZEKAY─░ YAVUZ	38.71547370	27.91381520	1
14224	49	D2F241476	ZEYNEL AKKU┼Ş	38.82810870	27.68307670	1
14225	49	D2F003977	Z├£LF─░KAR KANDEM─░R	38.79325000	27.72129600	1
14226	37	D2F117491	ABDULLAH DEM─░R	38.45448090	27.45299370	1
14227	37	D2F225594	ABDURRAHMAN OZAN	38.41620060	27.65742920	1
14228	37	D29001736	AHMET G├£NAY	38.45397500	27.57340600	1
14229	37	D29001294	AHMET TAMT├£RK VE ORTA─ŞI/TAM├ûV KOLL.┼ŞT─░.	38.41405200	27.62261900	1
14230	37	D2F157670	AL─░ DEM─░RC─░	38.40644550	27.53486910	1
14231	37	D2F232444	AL─░ DEM─░RTA┼Ş	38.41293260	27.61248290	1
14232	37	D2F094014	AL─░ ETREN	38.39717500	27.51383800	1
14233	37	D2F201683	AL─░ G─░RASLAN	38.39730130	27.51391980	1
14234	37	D29001521	AL─░ G├£NAY	38.46392100	27.48296000	1
14235	37	D2K216333	AL─░ ├ûNGEL	38.42190910	27.46765390	1
14236	37	D2F150000	AR─░F ALTIN	38.40646170	27.53408460	1
14237	37	D2F236743	ATAKAN DEM─░RAYAK	38.40914900	27.58478750	1
14238	37	020029853	ATARLAR PETROL ┼ŞT─░. - AMBARKAVAK	38.45001700	27.49072500	1
14239	37	D2F174489	ATARLAR PETROL TURGUTLU ┼ŞUBES─░	38.49480400	27.63900000	1
14240	37	D2F095171	ATARLAR PETROL ├£R├£NLERI-├çAMBEL ┼ŞUBES─░	38.44803500	27.51720500	1
14241	37	D2F162372	AYSA PETROL ├£R├£NLER─░ T─░CARET-─░SA ├çET─░N - AYSA PETROL ├£R├£NLER─░ ├£R├£NLER─░	38.42611210	27.66458920	1
14242	37	D2F127017	AYSEL KOSTAK	38.40619140	27.53510330	1
14243	37	D2F106503	AY┼ŞE KABCIK	38.33760610	27.57240990	1
14244	37	D2F227588	AY┼ŞEG├£L ─░L─░K	38.40423770	27.53221490	1
14245	37	D2F050336	AY┼ŞEN TEK─░N	38.40850760	27.58853530	1
14246	37	D2F114186	AYTEN KARATA┼Ş	38.43958450	27.66682130	1
14247	37	D2F206291	AYTU KOZMET─░K OTOMOT─░V ─░LET─░┼Ş─░M SAN. VE T─░C.LTD.┼ŞT─░.	38.45163400	27.56530470	1
14248	37	D29000736	BA┼ŞAR HELVACI	38.40314000	27.53249100	1
14249	37	D2F073616	BOZKANLAR ENERJI SANAYI VE TICARET ANONIM SIRKETI	38.45151100	27.48483000	1
14250	37	D2F031573	BU├çKUN AVANTAJ MARKET KONFEKS─░YON SAN.VE T─░C.LTD.┼ŞT─░.	38.40649800	27.53241100	1
14251	37	D2F111047	B├£┼ŞRA TET─░K	38.46348390	27.48362220	1
14252	37	D2F232748	CANAN ├ûZBEK	38.38499750	27.49912500	1
14253	37	D2F087677	CO┼ŞKUN DEM─░REL	38.52970200	27.56539900	1
14254	37	D29000777	├çARDAKLI PETROL	38.44979400	27.50038200	1
14255	37	D29000471	DEM─░R├çAM GIDA ─░N┼ŞAAT NAKL─░YE HAYVANCILIK SANAY─░ VE T─░CARET LTD.┼ŞT─░.	38.46658000	27.51860700	1
14256	37	D2F129426	DM PETROLC├£L├£K - ─░ST	38.48791800	27.57574900	1
14257	37	D2F129425	DM PETROLC├£L├£K - ─░ZM	38.48639360	27.57304230	1
14258	37	D2F082526	DO─ŞAN TURAN	38.41482930	27.63537340	1
14259	37	D2F019603	EM─░N D─░D─░M	38.38558100	27.49715900	1
14260	37	D2F086223	EM─░N TURGUT	38.40738300	27.58592300	1
14261	37	D2F218962	EM─░RHAN USLU	38.43942850	27.66712660	1
14262	37	D2K136691	ERDO─ŞAN ALAN	38.42044580	27.46783110	1
14263	37	D2F226807	ERHAN SERT	38.51446870	27.54358590	1
14264	37	D2F180764	ERKAN ADA	38.40773150	27.53023800	1
14265	37	D2F226986	ERTAN YAL├çIN	38.44503030	27.70333110	1
14266	37	D2F169089	ESAT ├ûZ	38.49030430	27.64673130	1
14267	37	D29001238	FAD─░ME D─░N├çKURT	38.38511000	27.49849200	1
14268	37	020029361	FARUK ├çAMBEL	38.40698200	27.53241200	1
14269	37	D29000855	FAT─░H EROL	38.43998400	27.66671800	1
14270	37	D2F227472	FAT─░H SA─ŞLAM	38.40865020	27.58702960	1
14271	37	D29000666	FATMA DEDEO─ŞLU	38.45486400	27.45434200	1
14272	37	D2F237404	F─░GEN KARA	38.46269600	27.49737600	1
14273	37	D2F126996	GAMZE CEYLAN	38.50876200	27.55682100	1
14274	37	D2F115300	G├ûKHAN ┼ŞAH─░N	38.41293550	27.62988320	1
14275	37	D2F004449	G├£LS├£M KARAKAYALI	38.46020400	27.45327500	1
14276	37	D2F022146	HAKAN DURSUN	38.39662600	27.51295700	1
14277	37	D2F198369	HAL─░L DALGIN	38.41425500	27.61512200	1
14278	37	D29001019	HAM─░SE HELVACI	38.40462400	27.53478700	1
14279	37	D2F175400	HAMZA TA┼ŞKIN 2	38.50868280	27.54506680	1
14280	37	D2F232447	HARUN PARYAZ	38.43694180	27.67069900	1
14281	37	D2F175305	HAYR─░ YAVA┼ŞCAN	38.40750230	27.52770670	1
14282	37	D2F093609	HRS PETROL VE PETROL ├£R├£NLERI NAK. IN┼Ş. TURIZM GIDA SAN. T─░C.LTD.┼ŞT─░.	38.45184800	27.47369500	1
14283	37	D29002080	H├£SEY─░N BA─ŞLAN	38.40803400	27.59194100	1
14284	37	D2F232938	H├£SEY─░N DAL	38.40759500	27.53780200	1
14285	37	D2F224905	H├£SEY─░N HAN├çER	38.45868900	27.50108290	1
14286	37	D29000859	H├£SN├£ TUGAY KIYGAN	38.43330900	27.68438600	1
14287	37	D2F025071	─░BRAH─░M ATAR	38.41455200	27.65678200	1
14288	37	D29000223	─░BRAH─░M ├çAM	38.41492840	27.65718690	1
14289	37	D2F085972	─░BRAH─░M ├ûZ┼ŞEKER	38.49259800	27.53655300	1
14290	37	D2F230060	─░LHAN Y├£KSEL	38.41751280	27.47119810	1
14291	37	D2F242419	─░LKNUR ARSLAN	42.94838100	34.13287400	1
14292	37	D2F231901	─░LKNUR KARA	38.46150290	27.49888500	1
14293	37	020029357	─░LYAS AT─░K	38.41466800	27.63237600	1
14294	37	D2F073016	─░LYAS AT─░K	38.41468500	27.63356600	1
14295	37	D2F042008	─░SMA─░L AKSOY	38.40826200	27.58545600	1
14296	37	D2F215140	─░SMA─░L ─░NCE	38.46364490	27.48322960	1
14297	37	D2F238397	KAZ─░M ┼ŞEN	38.45879330	27.50039440	1
14298	37	D2F138341	KEMALEFEND─░ GIDA TARIM HAY.TUR. VE TA┼Ş. SAN.T─░C. LTD. ┼ŞT─░.	38.45434050	27.45346830	1
14299	37	D2F239891	KEMALEFEND─░ GIDA TARIM HAY.TUR. VE TA┼Ş. SAN.T─░C. LTD. ┼ŞT─░. ┼ŞE├ç MARKET	42.94838090	34.13287400	1
14300	37	D2F152559	KEZ─░BAN YA─ŞIZ UNAN	38.45431880	27.45416190	1
14301	37	D2F120267	KUTBETT─░N AYAZ	38.41303770	27.65130080	1
14302	37	D2F004344	MAHMUT NED─░M G├£ZEL	38.40762820	27.58861820	1
14303	37	D2F173160	MED─░NE SAVRAN	38.46205600	27.47963000	1
14304	37	D2F165919	MEHMET D─░R─░K	38.49222930	27.53719130	1
14305	37	D2F218444	MEHMET ─░SA BOZ	38.44805470	27.53394930	1
14306	37	D2F173514	MELTEM VEZ─░	38.46330440	27.52047360	1
14307	37	D29000807	MESUT ┼ŞAHDALI	38.41312800	27.61454800	1
14308	37	D29001637	MET─░N G├£LZEREN	38.41299120	27.61442890	1
14309	37	D2F222357	MMR UZUN AKARYAKIT ─░N┼ŞAAT SAN. T─░C. LTD.┼ŞT─░.	38.44879010	27.50300100	1
14310	37	D2F026335	MURAT ERONAY	38.40453000	27.53217100	1
14311	37	D2F202271	MUSTAFA DEDEO─ŞLU	38.45719140	27.44966930	1
14312	37	D2F205254	MUSTAFA ERCAN	38.48287720	27.65351450	1
14313	37	D29000447	MUSTAFA ERDEM	38.45460700	27.45413000	1
14314	37	D2F204041	MUSTAFA KARAKULAK	38.40224200	27.53443210	1
14315	37	D2F073102	MUSTAFA KEMAL TA┼ŞKIN	38.38517800	27.49808700	1
14316	37	D29000189	MUSTAFA ├ûZER	38.40762200	27.52479900	1
14317	37	D2F032264	MUSTAFA ├ûZKAN	38.41750680	27.47112870	1
14318	37	D2F242447	MUSTAFA YAVUZ	38.50842820	27.55685120	1
14319	37	D2F183736	MUZAFFER KE├çEC─░	38.40462300	27.53275700	1
14320	37	D2F175537	MUZAFFER URAS	38.41577900	27.63423300	1
14321	37	D29001669	NAC─░YE ACIB├£BER	38.40705700	27.52961900	1
14322	37	D29001209	NECDET KARAKULAK	38.41710150	27.66353050	1
14323	37	D29001419	NECDET ├ûZDEN	38.41462600	27.63613500	1
14324	37	D29000230	N─░HAT B─░RCAN	38.34047900	27.60846500	1
14325	37	D29000249	NUR KEP. UN VE GIDA LTD.┼ŞT─░.	38.41755100	27.46741600	1
14326	37	D2F115299	NUR─░ VAR	38.41388510	27.63958800	1
14327	37	D29001311	N├£L├£FER G─░RGEN	38.42777860	27.67546080	1
14328	37	D2F196576	ONUR ├çEL─░K	38.41897580	27.70779080	1
14329	37	D29000186	ORHAN I┼ŞIK	38.40833710	27.58515980	1
14330	37	D29000168	├ûNER KARDE┼ŞLER GIDA LPG VE PET.AMB.NAK.TURZ.TAR.├£R├£N.SAN.T─░C.LTD.┼ŞT─░.	38.41619400	27.63681100	1
14331	37	D2F216142	├ûRGE AKARYAKIT ─░N┼Ş.SAN. VE T─░C. A.┼Ş	38.48788690	27.62694600	1
14332	37	D29002045	├ûRGE PETROL ├£R├£N.NAK.─░TH.─░HR.OTO.M├£T.TAAH.HAY.SAN.T─░C.LTD.┼ŞT─░.	38.47567100	27.60369000	1
14333	37	D29000297	├ûRNEK G─░R─░┼Ş─░MC─░L─░K GIDA B─░LG─░SAYAR ─░N┼ŞAAT TEKST─░L SAN.VE T─░C.LTD.┼ŞT─░.	38.41762500	27.46683700	1
14334	37	D2K178145	├ûRNEKPET AKARYAKIT VE PETROL ├£R├£NLER─░ TUR.LTD ┼ŞT─░	38.41576280	27.47618140	1
14335	37	D2F117489	PINAR YILMAZ	38.40401700	27.53265000	1
14336	37	D2F163480	P─░LAVO─ŞLU MA─ŞAZACILIK VE TARIM SANAY─░ T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.51042580	27.53895800	1
14337	37	D2F004366	RAHM─░ BALAL	38.41473000	27.63690200	1
14338	37	D2F148666	RAHM─░ ┼ŞAHDALI	38.33701060	27.57227560	1
14339	37	D2F195514	RAMAZAN ├çEL─░K	38.32193920	27.53730210	1
14340	37	D2F242706	REMZ─░ VURGUN	38.40443350	27.53288730	1
14341	37	D2F123788	RIDVAN YANIK	38.41631900	27.66369000	1
14342	37	D2F175755	RUK─░YE KUMCU	38.49195210	27.53763990	1
14343	37	D29000659	SAL─░H T├ûREN	38.43985800	27.66681500	1
14344	37	D2F186282	SAN─░YE DIZDAR	38.40175700	27.53267600	1
14345	37	D2F170604	SELMA B─░RCAN	38.34008160	27.60874140	1
14346	37	D2F192620	SELVET ├ûNDER	38.41449670	27.63762560	1
14347	37	D2F220555	SEMRA AKTA┼Ş	38.46681210	27.51785120	1
14348	37	D2F210596	SERDAR KO├ç	38.46081920	27.50058100	1
14349	37	D2F230852	SERDAR ├ûZKIYICI	38.41410590	27.63066680	1
14350	37	D2F173851	SERKAN ├çORUH	38.40812530	27.53302430	1
14351	37	D2F213891	SEYFETT─░N AYDIN	38.46200890	27.49543030	1
14352	37	D2F187938	S─░BEL ANIK	38.40147900	27.51504680	1
14353	37	D2F199174	SULTAN KARA	38.46108920	27.48103220	1
14354	37	D2F201138	SULTAN KIRCAN	38.39681270	27.51414650	1
14355	37	D2F000303	TANER USLU	38.52970200	27.56561100	1
14356	37	D2F114558	TEPETAS PETROL SANAYI VE TICARET LIMITED	38.40848490	27.52319370	1
14357	37	D2F139960	TESL─░ME KESMEC─░	38.45736270	27.45388780	1
14358	37	D2F004202	TURAN ├ûZCAN PETROL ├£RN.SOND.─░N┼Ş. SAN. VE T─░C.LTD.┼ŞT─░.	38.41238300	27.53410700	1
14359	37	D2F168883	TURGAY KAHYA	38.45759770	27.45128690	1
14360	37	D2F241562	YA─ŞMUR KESK─░N	38.45812980	27.44970210	1
14361	37	D2F196848	YAS─░N K├ûK	38.41883050	27.70766610	1
14362	37	D2F019396	YEL─░Z AKSOY	38.38479400	27.49955900	1
14363	37	D2F124644	YEN─░ ├çUKUROVA PETROL SANAY─░ VE T─░C.LTD.┼ŞT─░.	38.45086000	27.55670800	1
14364	37	D29000800	Y├ûRPA GIDA LTD. ┼ŞT─░.	38.40780300	27.53515200	1
14365	37	D2F016717	YURDANUR VURAL	38.41521700	27.64225300	1
14366	37	D2F219120	Z├£HT├£ ├çET─░N	38.43995120	27.69430190	1
14367	41	D2F219522	ABDUL HAQ MOHAMMADI	38.61079800	27.42504290	1
14368	41	D2F227107	ABDULLAH YORUCU	38.61648000	27.43074690	1
14369	41	D2F208748	ADEM ARDAL	38.61205930	27.42339010	1
14370	41	D2F000362	AHMET ┼ŞAH─░N/EM─░N MARKET	38.61198900	27.42849600	1
14371	41	D2F138869	AKTUR ARA├ç MUAYENE ISTASYONLARI I┼ŞLETMECILI─ŞI A.┼Ş.	38.63248990	27.44336850	1
14372	41	D2F001525	AL─░ AK├çALAR/ESK─░ FISTIK├çI FIRINI	38.61705200	27.43304700	1
14373	41	D2F142778	AL─░ D─░LEK	38.61550100	27.42576400	1
14374	41	D2F000419	AL─░M KEYF	38.61446100	27.43316200	1
14375	41	D2F203456	ALPET-BEYKONAK PET. LTD.┼ŞT─░.	38.66415050	27.45031640	1
14376	41	D2F139997	ALTERNAT─░F AMB. GIDA ├£R. VE PAZ. SAN. ─░├ç VE DI┼Ş T─░C. LTD.┼ŞT─░.-MAN─░SA 1	38.61937400	27.43601500	1
14377	41	020033081	ANIL YAVUZ	38.61795400	27.42721700	1
14378	41	D2F105780	ARZU ESENTA┼Ş	38.61539400	27.43074000	1
14379	41	D2F232680	ATA BERK TEKEL ├£R├£NLER─░ T─░C. LTD.┼ŞT─░.	38.61814120	27.42460600	1
14380	41	D2F002227	ATLI PETROL ├£R├£NLER─░ SAN.T─░C.LTD.┼ŞT─░.	38.65793500	27.44731300	1
14381	41	D2F052525	AYHAN ┼ŞAK─░R BALTACI	38.61365200	27.42418800	1
14382	41	D2F178915	AYHAN TA┼ŞC─░	38.61844000	27.42560800	1
14383	41	D2F146066	B─░LGENUR SERT	38.62300120	27.43287090	1
14384	41	D2F199903	BURAK TEPEC─░KL─░	38.61262260	27.42554000	1
14385	41	D2F125274	B├£LENT ├ûZ├ûVG├£ ORT.	38.61813030	27.42495360	1
14386	41	D2F234649	CAN BURAK KANLI	38.61520430	27.43268600	1
14387	41	D2F033570	CEM GEBOLO─ŞLU	38.61805100	27.42719400	1
14388	41	D2F000397	CENK ATLI/─░STASYON B├£FE	38.62111100	27.43557200	1
14389	41	D2F197481	├çA─ŞRI ├ûZ├çAKILKAYA	38.61199400	27.43170880	1
14390	41	D2F004134	DERYA DA─ŞLI	38.61414100	27.42548700	1
14391	41	D2F219647	DO─ŞAN VURAL 2	38.61811960	27.42516770	1
14392	41	D2F001598	EMN─░YET M├£D├£RL├£─Ş├£ KANT─░N─░ MERKEZ	38.61755200	27.43356300	1
14393	41	D2F195191	ERCO┼Ş ENERJ─░ OTOMOT─░V VE OTOMOT─░V ├£R├£NLER─░ LOJ─░ST─░K T─░CARET A.S	38.62328900	27.43153420	1
14394	41	D2F003179	ERCO┼Ş PETROL ├£R├£NLER─░ SAN.T─░C.LTD.┼ŞT─░.	38.63277400	27.43941400	1
14395	41	D2F240396	ERG─░N KONUKSEVENLER	38.61150160	27.42593650	1
14396	41	D2F004262	ERKAN UYSAL	38.61622500	27.42562900	1
14397	41	D2F223939	ERL─░K TEKEL GIDA ALKOLL├£ ALKOLS├£Z ─░├çECEKLER SAN. LTD.┼ŞT─░-ERL─░K TEKEL G	38.61650200	27.43198500	1
14398	41	D2F179263	FATMA ARAS	38.61883830	27.43570670	1
14399	41	D2F216450	FATMA TOZLU	38.61256820	27.43366390	1
14400	41	D2F121649	FER─░DE ESENDA─Ş	38.61824340	27.43589660	1
14401	41	D2F062241	F─░L─░Z D├£LGER	38.61563600	27.43591200	1
14402	41	D2F212806	GAMZE AKT├£RK	38.61223160	27.42387480	1
14403	41	D2F207990	G├£LHAN ├£ZEY─░RO─ŞLU	38.61350400	27.43585900	1
14404	41	D2F230842	G├£NDO─ŞDU TEKEL GIDA PAZ. SAN. T─░C. LTD. ┼ŞT─░.	\N	\N	1
14405	41	D2F003204	HAL─░L ARSLAN	38.61000500	27.42168700	1
14406	41	D2F000232	HAL─░M ─░LDE┼Ş	38.61085900	27.42145400	1
14407	41	D2F239514	HAM─░YET ERDO─ŞAN	38.61899620	27.43499610	1
14408	41	D2F040063	HASAN AL─░ KOCABA┼Ş	38.61351310	27.42202200	1
14409	41	D2F044782	HASAN EDREM─░T	38.61523700	27.42681400	1
14410	41	D2F013358	HASAN USUL	38.61227500	27.43255370	1
14411	41	D2F000236	H├£SEY─░N P─░DEC─░O─ŞLU	38.61024600	27.42432300	1
14412	41	D2F120208	H├£SEY─░N TUMANTOZLU	38.61448200	27.42747500	1
14413	41	D2F091519	H├£SN├£ ├çEV─░K - UCZ S─░STEM	38.61190990	27.42228200	1
14414	41	D2F125191	H├£SN├£ G├ûKAY	38.61644400	27.43315700	1
14415	41	020033231	─░BRAH─░M ┼ŞERMET/KARAO─ŞLAN B├£FE	38.61916300	27.43564900	1
14416	41	020032950	─░├çENG─░L PETROL LTD ┼ŞT─░ SHELL MARKET├ç─░L─░K ─░TH.─░HR.SAN.LTD.┼ŞT─░.	38.65701000	27.44749600	1
14417	41	D2F224137	─░LAYDA D─░L┼ŞAT KIVILCIM	38.61412280	27.43035360	1
14418	41	D2F000411	─░SA SERT	38.61667840	27.43685940	1
14419	41	D2F166287	─░SAMETT─░N AYDIN	38.61789410	27.43096660	1
14420	41	D2F131572	KADR─░YE KUR┼ŞUNLU	38.61810800	27.42515700	1
14421	41	D2F213419	K├£BRA SENEM S─░VAS	38.61710120	27.42990280	1
14422	41	D2F204826	L├£TF├£ ALTAN	38.61147360	27.42798090	1
14423	41	D2F162925	MAHMUT G├£RCAN	38.61823000	27.42413500	1
14424	41	D2F233723	MAHMUT YAHYA ERZEN	38.61721590	27.42733010	1
14425	41	D2F230150	MEHMET DEM─░R	38.61812000	27.42962900	1
14426	41	D2F001975	MEHMET EM─░N TAVAS	38.61289700	27.42071300	1
14427	41	D2F004097	MEHMET ERKAN	38.61501500	27.43580200	1
14428	41	D2F003079	MEHMET KAYA	38.61657200	27.42867600	1
14429	41	D2F186751	MEHMET SARICAN	38.61691020	27.42636110	1
14430	41	D2F003916	MEHTAP ├ûZBULDUK	38.61823000	27.43460000	1
14431	41	D2F137685	MET─░N ILGAZ	38.61085700	27.42156000	1
14432	41	D2F015884	MET─░N Y├ûNTEM	38.61619900	27.42790500	1
14433	41	D2F220382	MURAD EY├£PO─ŞLU	38.61547800	27.43081400	1
14434	41	D2F168133	MURAT ├ûZO─ŞLU	38.61532070	27.43050400	1
14435	41	D2F144960	MUSTAFA EMRAH U─ŞURSALAN	38.61419600	27.43332700	1
14436	41	D2F116076	MUSTAFA KARAHAN	38.61544300	27.42434500	1
14437	41	020033811	MUSTAFA T├£FEK├ç─░O─ŞLU/T├£FEK├ç─░O─ŞLU GIDA	38.61328700	27.42759600	1
14438	41	D2F153737	M├£R┼Ş─░DE G├£LAL	38.61356800	27.42777400	1
14439	41	D2F001614	NECM─░ ├ç─░├çEK	38.62339900	27.43410300	1
14440	41	D2F003428	NERM─░N ATE┼Ş	38.61667700	27.42532400	1
14441	41	D2F219302	NERM─░N YAVA┼Ş	38.61223200	27.42066600	1
14442	41	D2F105629	N─░HAL SAYUR	38.61675100	27.43591800	1
14443	41	D2F232500	ORHAN KARAO─ŞLU	38.61418920	27.42502570	1
14444	41	D2F214219	├ûZ AYDIN MNS GIDA MOB─░LYA ─░N┼ŞAAT PAZARLAMA LTD.┼ŞT─░.	38.61245540	27.43020450	1
14445	41	D2F205629	├ûZCAN AKYOL	38.62413890	27.43494170	1
14446	41	D2F241269	├ûZDEM DENKLER	38.61757780	27.43095440	1
14447	41	D2F033234	├ûZPOLATO─ŞLU DO─ŞU CADDES─░	38.61389400	27.43510400	1
14448	41	D2F048643	├ûZPOLATO─ŞLU ERLER	38.61238200	27.42470100	1
14449	41	D2F150211	├ûZPOLATO─ŞLU PEKER	38.61701150	27.42744870	1
14450	41	D2F047021	RAMAZAN G├ûKALP	38.61752440	27.42926220	1
14451	41	D2F002566	RAMAZAN ┼ŞENER	38.61212000	27.42836800	1
14452	41	D2F137671	RECEP KURUM	38.61623320	27.43685460	1
14453	41	020033186	SADULLAH BULGULU/DOSTLAR GIDA	38.61285400	27.42882400	1
14454	41	D2F200144	SEFA MERT ├ûZEL	38.61828800	27.42854100	1
14455	41	D2F229082	SEL├çUK ME┼ŞE	38.61457830	27.43025480	1
14456	41	D2F208219	SEL─░M E┼ŞOL	38.61460170	27.43143850	1
14457	41	D2F230727	SEYD─░ SARI	38.61475470	27.43268440	1
14458	41	D2F237382	SULTAN NUR DEM─░R	38.61836680	27.42788890	1
14459	41	D2F028146	SULTAN YILDIZ	38.61267800	27.42269500	1
14460	41	D2F039625	S├£RMEL─░ TOPRAK	38.61451400	27.43337200	1
14461	41	D2F000745	┼ŞABAN ALAZ	38.62097800	27.43648900	1
14462	41	D2F003195	┼ŞENAYLAR PAMUK ├çIR├çIRLAMA PETROL ├£R├£NLER─░ SAN.T─░C.A.┼Ş.	38.66346700	27.45069400	1
14463	41	D2F240241	┼ŞENER G├£L YOLCU	38.61607330	27.42669450	1
14464	41	D2F230232	┼ŞULE ┼ŞERMET	38.61603410	27.43595170	1
14465	41	D2F158125	TARIK UYAR	38.61133110	27.42403250	1
14466	41	D2F002716	TEKO─ŞLU AKARYAKIT ─░N┼Ş.OTOMOT─░V GIDA TUR─░ZM ─░TH.─░HRC.SAN.VE T─░C.LTD.┼ŞT─░	38.63363100	27.43901600	1
14467	41	D2F241822	TEOMAN ERDO─ŞAN	38.61398630	27.43203460	1
14468	41	D2F227512	TU─ŞBA D─░LEK	38.61634040	27.42810060	1
14469	41	020033209	├£M─░T TELL─░KAVAK/ERKA MRK	38.61398900	27.42887800	1
14470	41	D2F116156	VAH─░DE TA┼ŞKINCAN	38.61677800	27.42719330	1
14471	41	D2F218056	VURAL TA┼Ş	38.61790540	27.43064630	1
14472	41	D2F092961	YAKUP DER─░NCE	38.61822000	27.43358300	1
14473	41	D2F002341	YAPKIN PETROL SAN.T─░C.LTD.┼ŞT─░./MEHMET MUSTAFA BOZYAKA	38.67151100	27.46419200	1
14474	41	D2F000038	YAZARLAR PETROL VE TUR─░ZM ─░N┼Ş.NAK.OTO LTD.┼ŞT─░. MAN─░SA	38.62541300	27.44014000	1
14475	41	D2F195832	Y─░─Ş─░T ─░KL─░MLEND─░RME ISITMA SO─ŞUTMA S─░STEMLER─░ ─░N┼ŞAAT LTD.┼ŞT─░.	38.61558460	27.42858460	1
14476	41	D2F099038	YOLCU KARDE┼ŞLER DEVLET HASTAHANES─░ ┼ŞUBE 9	38.61896800	27.43576300	1
14477	41	D2F224002	Y├£KSEL MERT G├ûRDES	38.61872740	27.43506380	1
14478	41	D2F134538	ZAH─░DE ATA	38.62071040	27.43147770	1
14479	41	020033195	ZEHRA DURGUT/├çARDAK B├£FE	38.61528000	27.43289600	1
14480	41	020033083	Z├£LCELAL ALKAN/H─░CRET BAKK	38.61479200	27.42782800	1
14481	44	D2F217567	ADEM AKBULUT	38.60726090	27.41690810	1
14482	44	D2F223709	ADEM KENEBA┼Ş	38.61154290	27.41247590	1
14483	44	D2F211567	AHMET ARIK	38.61474920	27.44591100	1
14484	44	D2F176641	AHMET ER	38.61085300	27.43411300	1
14485	44	D2F003215	AL─░ ACAR	38.60989600	27.42533400	1
14486	44	D2F168675	AL─░ ERYILMAZ	38.61585300	27.44095440	1
14487	44	D2F147481	AL─░ RIZA PAMUK├çU	38.60871010	27.42492030	1
14488	44	D2F239718	AR─░F YAL├çIN	42.94838100	34.13287400	1
14489	44	D2F000078	AS─░M G├£NDO─ŞDU	38.60729390	27.41898440	1
14490	44	D2F003442	A┼ŞKIN KO├ç/A┼ŞKIN B├£FE	38.61071400	27.43243600	1
14491	44	020033837	AY┼ŞEN ├ûVEZ	38.61382300	27.43752800	1
14492	44	D2F209459	BAK─░ KESENEK	38.60658390	27.42151770	1
14493	44	D2F140539	BEDEV─░ AYDIN	38.61158130	27.43717180	1
14494	44	D2F213032	BEK─░R BALABAN	38.60841270	27.41015350	1
14495	44	D2F237803	BENG─░SU DO─ŞAN	38.60798150	27.42293880	1
14496	44	D2F232120	BET├£L G├ûZC├£	38.61313560	27.43915410	1
14497	44	D2F215834	CANDA┼Ş ├ûZDOKUMACI	38.61375900	27.43825300	1
14498	44	D2F231727	CEHVER ULU─ŞTEK─░N	38.60694400	27.42305330	1
14499	44	D2F117473	CENG─░Z ARSLAN	38.60759610	27.42553640	1
14500	44	D2F195445	CENNET G├ûZEN	38.60852000	27.42191500	1
14501	44	D2F217484	D─░LBER KARABARUT	38.61647500	27.44027190	1
14502	44	D2F218317	D─░LBER KOCADEM─░R	38.61365510	27.44028050	1
14503	44	D2F001686	DOLGUN KARDE┼ŞLER GIDA LTD.┼ŞT─░.	38.61390900	27.43770500	1
14504	44	D2F228323	EFE MERT TEKEL─░	38.61803230	27.43790080	1
14505	44	D2F164271	EM─░NE SARIDA─Ş	38.61596700	27.44074400	1
14506	44	D2F231344	EMRULLAH TEMEL	38.61627020	27.43824470	1
14507	44	D2F240619	ENES G├£NE┼Ş	38.60766000	27.41531600	1
14508	44	D2F004215	ENVER TET─░K	38.61417700	27.44072800	1
14509	44	D2F004310	ERCAN AYG├£L	38.60780300	27.41933900	1
14510	44	D2F002557	ESMA ├çAYIRLEN	38.61197800	27.43570100	1
14511	44	D2F002491	FAD─░ME KIRAL	38.60720100	27.42257200	1
14512	44	D2F069877	FARUK ORHAN	38.60713600	27.42157360	1
14513	44	D2F236441	G├ûRKEM AYAZ	38.60997140	27.41404860	1
14514	44	D2F238072	HAB─░BULLAH OZBEK	38.61265560	27.43469100	1
14515	44	D2F228873	HACER G├ûKALP	38.61008020	27.41386410	1
14516	44	D2F032263	HAKAN KESK─░N	38.60986100	27.42010400	1
14517	44	D2F083277	HAL─░L ─░BRAH─░M OYAN	38.60896800	27.41845500	1
14518	44	D2F209768	HAL─░T ASLAN	38.60901900	27.42069600	1
14519	44	D2F216840	HASAN KAZAZ	38.60902930	27.41337400	1
14520	44	D2F095372	HAT─░CE AYDIN	38.61736800	27.43859400	1
14521	44	D2F219098	HAT─░CE ├çA─ŞLAR	38.60998500	27.41043500	1
14522	44	D2F001910	HAT─░CE DUMANLI	38.61906700	27.44272400	1
14523	44	D2F003771	HEYBET TEMTEK	38.61410900	27.44078200	1
14524	44	D2F157397	HUR┼Ş─░T ORHAN	38.60953300	27.41243700	1
14525	44	D2F215965	H├£SEY─░N ├ç─░├çEK	38.60998710	27.43795140	1
14526	44	D2F237962	─░BRAH─░M ERCAN ALTAN 2	38.61000710	27.42620410	1
14527	44	D2F181496	─░SMA─░L D├ûNMEZ	38.61725900	27.43993400	1
14528	44	D2F157948	─░SMA─░L YE┼Ş─░LDA─Ş	38.61829550	27.43905530	1
14529	44	D2F239719	KAD─░R BOZ	38.60976310	27.42450300	1
14530	44	D2F027578	KAM─░L G├£├ç	38.61834100	27.44232200	1
14531	44	D2F177075	KEMAL A┼ŞICI	38.61683400	27.44124000	1
14532	44	D2F186647	MAH─░R ├ûVEZ	38.60952420	27.42319620	1
14533	44	D2F003007	MAHMUT KARABULUT	38.61407100	27.44012100	1
14534	44	D2F209272	MEHMET AL─░ KARAKU┼Ş	38.61636600	27.44128100	1
14535	44	D2F051878	MEHMET EM─░N DER─░NCE	38.61005300	27.43697200	1
14536	44	D2F000475	MEHMET GEN├çAY	38.61140230	27.43224310	1
14537	44	D2F002544	MEHMET G├£NER	38.60849600	27.42097400	1
14538	44	020033040	MEHMET KO├ç/KO├ç GIDA	38.60933500	27.41589700	1
14539	44	D2F205499	MEHMET ┼Ş─░R─░N G├ûZC├£	38.60946460	27.42774620	1
14540	44	D2F072195	MEHMET ┼Ş─░R─░N ├ûZER	38.60789900	27.43697900	1
14541	44	D2F241792	MEHMET YILDIRIM	42.94838100	34.13287400	1
14542	44	D2F110505	MELTEM POLAT	38.60986630	27.43086500	1
14543	44	D2F225654	MEMET KADR─░ ADIG├£ZEL	38.60898760	27.42450060	1
14544	44	D2F114548	MERAL AF┼ŞAR	38.60937700	27.41021500	1
14545	44	D2F160027	MET─░N C├ûVAN - K├û┼ŞEM B├£FE	38.60902100	27.42063500	1
14546	44	D2F238432	MUHAMMET AYDIN	38.61093780	27.43397330	1
14547	44	D2F001636	MURAT AYDIN	38.61509900	27.44001400	1
14548	44	D2F163625	MURAT K├£├ç├£K	38.60944990	27.41618990	1
14549	44	D2F003990	MUSTAFA AK├çAY	38.60790100	27.41849900	1
14550	44	D2F002584	MUSTAFA ├ç─░├çEK	38.61100100	27.43623000	1
14551	44	D2F230494	MUSTAFA ├ûVEZ	38.61031180	27.41353670	1
14552	44	D2F211203	MUSTAFA TEMEL	38.60808320	27.42030310	1
14553	44	D2F194631	MUZAFFER ETYEMEZ	38.61286740	27.43837720	1
14554	44	D2F173075	M├£JGAN AKG├£N	38.61398670	27.43967800	1
14555	44	D2F082611	NAZAN KORALP	38.61074230	27.41577770	1
14556	44	D2F231391	NAZM─░YE KO├ç	38.60878910	27.41515910	1
14557	44	D2F126115	NECMEDD─░N ├ûZAY	38.60586810	27.43851090	1
14558	44	D2F158721	NESR─░N ├ûZT├£RK	38.61019060	27.42686240	1
14559	44	D2F080893	NE┼ŞET ALTIN	38.60878100	27.42335900	1
14560	44	D2F000229	NUR─░YE AKCAN	38.61117800	27.41447300	1
14561	44	D2F229672	OSMAN ┼Ş─░VAN KARADA─Ş	38.61070130	27.43116640	1
14562	44	D2F210992	├ûM├£R YAL├çIN	38.60944610	27.42329250	1
14563	44	D2F231545	├ûZG├£R DENKLER	38.61005180	27.41038830	1
14564	44	D2F195759	├ûZKAN KAKIZ	38.61666100	27.43975900	1
14565	44	D2F022764	├ûZPOLATO─ŞLU ALAYBEY	38.61607000	27.44055600	1
14566	44	D2F233299	RAMAZAN BI├çAK	38.60891890	27.42026190	1
14567	44	D2F135485	RAMAZAN ├£D├£L	38.61082980	27.43247570	1
14568	44	D2F241634	RE┼ŞAT ├çINAR	38.60905780	27.42069450	1
14569	44	D2F166135	SAADET ├ç─░├çEK	38.61786790	27.44208990	1
14570	44	D2F003066	SADIK KANAR	38.61591300	27.43815300	1
14571	44	D2F123357	SELAHATT─░N SOYAR	38.60855830	27.41239230	1
14572	44	D2F160323	SELAHATT─░N SOYAR	38.60753450	27.41449560	1
14573	44	D2F205064	SELDA AKSOY	38.61826990	27.43991100	1
14574	44	D2F003343	SEL─░M ONUK	38.61289000	27.43806000	1
14575	44	D2F160973	SEMRA PAK	38.61761560	27.43771190	1
14576	44	D2F225141	SERAP G├£LER	38.60895910	27.41419330	1
14577	44	020034420	SERVET DURMAZ	38.61110200	27.43574800	1
14578	44	D2F103476	SUPH─░ ├£D├£L	38.60812700	27.42027500	1
14579	44	D2F242769	┼ŞAD─░YE BET├£L KARAKU┼Ş	42.94838100	34.13287400	1
14580	44	D2F149644	┼ŞAH─░N ATMACA	38.60640640	27.41814840	1
14581	44	D2F097777	┼ŞER─░F G├£├ç	38.60821870	27.41721430	1
14582	44	D2F003122	TAH─░R ├çET─░N	38.60869500	27.41021300	1
14583	44	D2F241029	TEK─░N DURMAZ	38.61068680	27.41148990	1
14584	44	020033050	TURAN ┼Ş─░VECAN/D─░LEK MRK	38.60947800	27.42301300	1
14585	44	D2F191974	T├£RKAN DURSUN├£ST	38.60959400	27.42060000	1
14586	44	D2F146946	U─ŞUR CAN KAPLAN	38.61424920	27.44203900	1
14587	44	D2F151934	U─ŞUR T├£NK	38.60905520	27.42080330	1
14588	44	D2F196395	├£NAL KARABA┼Ş	38.60937100	27.42176400	1
14589	44	D2F185899	├£NL├£ ├çEREZ KURUYEM─░┼Ş GIDA SAN.VE T─░C.LTD.┼ŞT─░	38.60832580	27.41944590	1
14590	44	D2F136747	VAH─░T B├£├çG├£N	38.60875180	27.43770100	1
14591	44	D2F000473	VOLKAN SONGUR	38.61107600	27.43359900	1
14592	44	D2F192417	YAKUP ├ûMER TEMEL	38.60927110	27.41731960	1
14593	44	D2F205200	YA┼ŞAR DURAN	38.61492290	27.43855050	1
14594	44	D2F076084	YEMEN K├ûSE	38.60899900	27.42722000	1
14595	44	D2F187524	YILMAZ ACAR	38.60822600	27.43762400	1
14596	44	020033121	YOLCU KARDE┼ŞLER AKMESC─░T ┼ŞUBE 7	38.60984400	27.41039800	1
14597	44	D2F003251	YOLCU KARDE┼ŞLER KARAK├ûY ┼ŞUBE 1	38.60864100	27.41922300	1
14598	44	020044361	YOLCU KARDE┼ŞLER SULTAN├ûN├£ ┼ŞUBE 2	38.61037200	27.42732600	1
14599	44	D2F124350	YUNTDA─ŞI BEREKET MANDIRA GIDA LTD. ┼ŞT─░.	38.61015000	27.41354220	1
14600	44	D2F073652	YUSUF ├çA─ŞLAR	38.60925800	27.40925000	1
14601	44	D2F182400	Y├£CEL AYDIN	38.60814660	27.41331550	1
14602	44	D2F226864	ZEYNEP KARABULUT	38.60442020	27.43924800	1
14603	44	D2F161934	ZEYNEP TA┼ŞER	38.60745600	27.41444800	1
14604	44	D2F167040	Z─░YA UN─ŞAN	38.60962290	27.43421710	1
14605	46	D2F210745	ABDULLAH ACAR	38.62089630	27.40879300	1
14606	46	D2F149269	ABDURRAHMAN DER─░NCE	38.62081800	27.41021600	1
14607	46	D2F199589	AHMET AL─░ ARSLAN	38.61817240	27.41840220	1
14608	46	D2F199371	ALAADD─░N KUR┼ŞUN	38.61754620	27.42205200	1
14609	46	D2F098867	AL─░ KATAR	38.61385090	27.41968290	1
14610	46	D2F125798	AL─░ KUZU	38.62356200	27.41576100	1
14611	46	D2F210823	AYHAN ├ç─░├çEK	38.62705470	27.42961730	1
14612	46	D2F201630	AY┼ŞE ALTAN	38.61358900	27.41907400	1
14613	46	D2F240315	AY┼ŞE G├£L ALPTEK─░N	38.62184990	27.41667630	1
14614	46	D2F210012	AY┼ŞE NUR ├çANTAL	38.61907000	27.41983600	1
14615	46	D2F004395	AY┼ŞE SAYAR	38.62309910	27.42334200	1
14616	46	D2F003231	AY┼ŞE YILDIRIM	38.61554200	27.41057100	1
14617	46	D2F238092	AY┼ŞE Y├£KSEL	38.62523090	27.42885930	1
14618	46	D2F136971	AY┼ŞEG├£L DURMAZ	38.61550600	27.42288680	1
14619	46	D2F165525	AZ─░ME ORAL	38.61998100	27.41554500	1
14620	46	D2F142257	BARI┼Ş OL─ŞUN	38.61916300	27.40308600	1
14621	46	D2F230285	BOZOKLAR TAAHH├£T GIDA ─░N┼ŞAAT SAN. T─░C. LTD.┼ŞT─░.	38.61768080	27.42173880	1
14622	46	D2F004298	CEVDET KONUK	38.61947800	27.41160000	1
14623	46	D2F104678	CO┼ŞKUN MATRACI	38.62916110	27.43088620	1
14624	46	D2F004030	C├£NEYT G├£LSOY	38.62214060	27.42063200	1
14625	46	D2F002726	C├£NEYT USLU	38.61523300	27.41997800	1
14626	46	D2F159652	D─░LBER BI├çAK	38.61769400	27.41959400	1
14627	46	D2F043466	EBRU S├ûZER	38.61797700	27.40265100	1
14628	46	D2F215097	EM─░N ┼Ş─░PAL	38.61246420	27.41842370	1
14629	46	D2F188181	EMRE G├ûVDETA┼ŞAN	38.61809140	27.40995020	1
14630	46	D2F159378	ERAY Y├ûNETIM DANISMANLIGI GIDA SAN.TIC.LTD.STI - ERAY MARKET	38.62055440	27.41217000	1
14631	46	D2F234768	ERBAY HAYVANCILIK GIDA OTO. TUR. LOJ. SAN. VE T─░C. LTD. ┼ŞT─░.	38.61249900	27.41158900	1
14632	46	D2F216394	ERS─░N AYDIN	38.63062210	27.42614610	1
14633	46	D2F145837	ERTURUL KUR┼ŞUN	38.61773600	27.42192300	1
14634	46	D2F159137	FAT─░H SEPET├ç─░LER	38.62338340	27.41918840	1
14635	46	D2F002383	FATMA OKTAR	38.61860790	27.40523050	1
14636	46	D2F230590	FATMA ├ûZMEN	38.61985410	27.40744560	1
14637	46	D2F241604	FER─░DE MISIRCIO─ŞLU	38.61717240	27.41885320	1
14638	46	D2F235317	FERZANE AYINGER	38.61721300	27.42135390	1
14639	46	D2F000277	FEZA─░R ZENC─░R	38.61439100	27.42142200	1
14640	46	D2F204290	F─░LE45 GIDA T─░CARET A.┼Ş	38.62307800	27.41613500	1
14641	46	D2F203144	F─░L─░Z KOCAEL	38.62405460	27.41917800	1
14642	46	D2F210742	FURKAN ─░LHAN	38.61849130	27.41417670	1
14643	46	D2F205304	GE├ç─░T TEKEL ├£R├£NLER─░ T─░CARET L─░M─░TED ┼Ş─░RKET─░-	38.61772830	27.42216060	1
14644	46	D2F003439	G├£LHAN ├çALI┼ŞKAN	38.62830900	27.43089100	1
14645	46	D2F016415	G├£L┼ŞEN OZAN	38.62484710	27.41279190	1
14646	46	D2F000243	HARUN ├çALI┼ŞKAN	38.61060800	27.41890000	1
14647	46	D2F003096	HARUN PALALI	38.61174570	27.41863620	1
14648	46	D2F168052	HASAN ERSOY	38.62265470	27.41890820	1
14649	46	D2F187427	HASAN H├£SEY─░N BECER─░K├ç─░	38.61737680	27.40376050	1
14650	46	D2F090439	HASAN UYAR	38.62469700	27.42700700	1
14651	46	D2F226985	HAT─░CE AYINGER	38.61916960	27.41908660	1
14652	46	D2F002172	HAT─░CE D─░L─░K	38.62368800	27.41302200	1
14653	46	D2F212844	HAT─░PO─ŞLU PAZARLAMA PETROL ├£R├£NLER─░ SAN.VE T─░C.LTD.┼ŞT─░.MAN─░SA ┼ŞUBES─░	38.61932590	27.42168810	1
14654	46	020033399	H─░LM─░ BENG─░ER/BERK B├£FE	38.61315200	27.41644900	1
14655	46	D2F004296	H─░MMET KARTAL	38.62345200	27.41784900	1
14656	46	D2F002335	H─░ZRET AYDIN	38.62033300	27.42213400	1
14657	46	D2F003909	H├£SEY─░N ALEVO─ŞLU	38.61851550	27.41367540	1
14658	46	D2F002170	H├£SEY─░N AL─░ KUR┼ŞUN	38.62364900	27.42303100	1
14659	46	D2F004070	H├£SEY─░N DURMAZ-C├£NEYT DURMAZ ORT.	38.61830800	27.40285800	1
14660	46	D2F234809	H├£SEY─░N ERKARA	38.61832820	27.41177290	1
14661	46	D2F116430	─░BRAH─░M ERCAN ALTAN	38.61516200	27.42324200	1
14662	46	D2F236032	─░BRAH─░M KO├ç	38.62244660	27.41905430	1
14663	46	D2F216106	─░HS GIDA ─░N┼ŞAAT T─░C.LTD.┼ŞT─░.	38.61783460	27.40666370	1
14664	46	D2F230329	─░LHAN YILDIRIM	38.62261840	27.40694870	1
14665	46	D2F189453	─░RFAN G├£LTEK─░N	38.61873500	27.41912200	1
14666	46	D2F222563	─░SA CANPOLAT	38.62420430	27.42880380	1
14667	46	D2F003548	KAD─░R SOYBA┼Ş	38.61460810	27.41546690	1
14668	46	D2F026547	KER─░M G├ûKTEPE	38.61744190	27.42315870	1
14669	46	D2F002270	LALEL─░ POL─░S KANT─░N─░	\N	\N	1
14670	46	D2F003764	L├£TF─░YE ESER	38.61563500	27.42259100	1
14671	46	D2F195512	L├£TF├£ ├ûZDEM─░R	38.61499490	27.41871810	1
14672	46	D2F003519	MEHMET ACAR	38.62383000	27.42197000	1
14673	46	D2F130347	MEHMET AL─░ ORU├ç	38.62216000	27.41350370	1
14674	46	D2F070847	MEHMET AL─░ ├ûZT├£RK	38.61854200	27.41300000	1
14675	46	D2F132082	MEHMET ATE┼Ş	38.62118060	27.41065430	1
14676	46	D2F237854	MEHMET CALAY	38.63106890	27.42694820	1
14677	46	D2F127356	MEHMET EM─░N NAL├çAKAN	38.61447200	27.42285000	1
14678	46	D2F201137	MEHMET ERDAL U├çAR	38.61395300	27.42034600	1
14679	46	D2F209456	MEHMET ZENUN KALAY	38.61750820	27.41188310	1
14680	46	D2F150271	MELEK ARSLAN	38.62271540	27.41776240	1
14681	46	D2F242426	MERT BORAZAN	38.61643460	27.41558220	1
14682	46	D2F004214	MET─░N DEL─░KAN	38.61238600	27.41102900	1
14683	46	D2F205215	MET─░N KARACAN	38.62099310	27.41409740	1
14684	46	D2F229784	MUAMMER DEM─░R	38.62468620	27.41499520	1
14685	46	D2F221696	MUHAMMED ├çAKIRGEN├ç	38.61373470	27.41116900	1
14686	46	D2F003131	MURAT YILDIRIM	38.63237010	27.42674210	1
14687	46	D2F001714	MUSA G├£├ç	38.61077200	27.41971900	1
14688	46	D2F001961	MUSTAFA BABATAN/BABATAN BAK.	38.62598140	27.41397210	1
14689	46	D2F168055	MUSTAFA ├çET─░N	38.62290940	27.41647640	1
14690	46	D2F214298	MUSTAFA TUNA	38.61483380	27.42128550	1
14691	46	D2F106081	NAG─░HAN AKTA┼Ş	38.61378800	27.41963200	1
14692	46	D2F040114	NALAN KAYA	38.62155570	27.40998770	1
14693	46	D2F149585	NAZAN PAK	38.61494400	27.41237300	1
14694	46	D2F150858	N─░ZAMETT─░N AYINGER	38.62208300	27.40716700	1
14695	46	D2F240139	NOYAN ARIKAN	38.61420160	27.42137940	1
14696	46	D2F222861	├ûMER AK├çAY	38.61717140	27.41330530	1
14697	46	D2F002743	├ûMER DO─ŞAN	38.61365600	27.41520200	1
14698	46	D2F229539	├ûMER ERKAN	38.61727990	27.41992050	1
14699	46	D2F240780	├ûMER KARA├çULHA	38.61892320	27.41129300	1
14700	46	D2F099705	├ûMER TEKSARI	38.62617100	27.42926000	1
14701	46	D2F143980	├ûZPOLATO─ŞLU AYNAL─░	38.61403400	27.42201300	1
14702	46	D2F066128	├ûZPOLATO─ŞLU HAFSA SULTAN	38.61786900	27.40773300	1
14703	46	D2F053024	├ûZPOLATO─ŞLU KU┼ŞLUBAH├çE	38.62627300	27.42928100	1
14704	46	D2F023182	├ûZPOLATO─ŞLU MERKEZ EFEND─░	38.61529800	27.41237600	1
14705	46	D2F051865	├ûZPOLATO─ŞLU YEN─░ MAHALLE	38.61720900	27.40436500	1
14706	46	D2F236577	RA┼Ş─░T BAL	38.61902100	27.42078590	1
14707	46	D2F199904	REF─░K ECE	38.61442200	27.42338800	1
14708	46	D2F147896	RESUL KARATA┼Ş - MNS KONAK KURUYEM─░┼Ş	38.61777690	27.42208810	1
14709	46	020034503	RIZA DURAN	38.61819100	27.41567600	1
14710	46	D2F184639	SAVA┼Ş BA┼Ş	38.61647880	27.41602450	1
14711	46	D2F141449	SELIM ALKOLL├£ ALKOLS├£Z I├çE.GIDA PAZ.DAG.SAN.VE TIC.LTD STI	38.62116150	27.41224490	1
14712	46	D2F114690	SERDAR YILMAZ	38.61716840	27.41612070	1
14713	46	D2F002611	SERVET KARATA┼Ş	38.61592000	27.41230500	1
14714	46	D2F118963	S─░BEL DURMU┼Ş	38.61374000	27.41709300	1
14715	46	D2F003581	SULTAN AL─░ ├ûZT├£RK	38.61868100	27.41344700	1
14716	46	D2F213374	S├£LEYMAN ├çAM	38.62304910	27.41627770	1
14717	46	020033120	S├£LEYMAN G├£RCAN/YUNTDA─ŞLI ├çRZ	38.61731670	27.42342590	1
14718	46	D2F211254	TUGAY ├ûZMEN	38.61663480	27.42217170	1
14719	46	D2F237126	TUNCAY U├çGUN	38.62114940	27.40293430	1
14720	46	D2F002199	TURHAN ─░NAN	38.61024600	27.41751700	1
14721	46	D2F155155	UMUT BOYAN	38.61376670	27.41092990	1
14722	46	D2F239370	├£M─░T ERTAN	38.61653690	27.42133240	1
14723	46	D2F188004	VENORSA GIDA LTD.┼ŞT─░.-VOLKAN KURUYEM─░┼Ş	38.61318040	27.41691980	1
14724	46	D2F162187	YAHYA BAYDO─ŞAN	38.62295920	27.42208500	1
14725	46	D2F000011	YAHYA YORGANCI	38.61661620	27.42198620	1
14726	46	D2F236151	YANARO─ŞLU OTOMOT─░V TUR─░ZM GIDA SANAY─░ VE T─░C.LTD.┼ŞT─░.	38.61759640	27.40205140	1
14727	46	D2F163628	YANARO─ŞLU TUR─░ZM LOJ─░ST─░K TA┼ŞIMACILIK GIDA SANAY─░ VE T─░CARET L─░M─░TED ┼Ş	38.61749790	27.40176060	1
14728	46	020034550	YAS─░N ├çET─░N/ARDA TKL	38.61718600	27.42165100	1
14729	46	D2F030399	YEL─░Z TUTUMLU	38.62871100	27.43052300	1
14730	46	D2F111242	YOLCU KARDE┼ŞLER AYN-I AL─░	38.61355400	27.41907500	1
14731	46	D2F003938	YOLCU KARDE┼ŞLER LALEL─░ ┼ŞUBE 4	38.61818800	27.40270200	1
14732	46	D2F221168	Y├£KSEL SA─ŞLAM	38.62540420	27.42893110	1
14733	46	D2F003950	ZAFER ADA	38.61688500	27.41781100	1
14734	43	D2F188088	ABDULSEM─░H AYINGER	38.62330160	27.40747290	1
14735	43	020033821	ADEM B─░├çAKCI/├çA─ŞRI MRK	38.61847900	27.39517100	1
14736	43	D2F004019	ADUL ASLAN	38.63184700	27.39585980	1
14737	43	D2F219888	AKYAR AKARYAKIT ─░N┼ŞAAT TAAHH├£T SAN.VE.T─░C.A.┼Ş.	38.61396890	27.39135200	1
14738	43	D2F171832	AL─░ AMAN	38.60618970	27.38677180	1
14739	43	D2F106766	AL─░ I┼ŞIK	38.62458780	27.39550050	1
14740	43	D2F146403	AL─░ ─░─ŞRET	38.62911360	27.39988160	1
14741	43	020034383	ANEMON PETROL A.┼Ş.	38.60709800	27.36252700	1
14742	43	D2F240692	ATAKAN KERTER	38.62860200	27.40333940	1
14743	43	D2F216339	AYFER G├ûKMEN	38.62890990	27.40414170	1
14744	43	D2F242548	AYI┼ŞI─ŞI TEKEL MADDELER─░ HED─░YEL─░K E┼ŞYA E─Ş─░T─░M GIDA T─░C.LTD.┼ŞT─░.	42.94838100	34.13287400	1
14745	43	D2F228871	AYMAR YEN─░ MA─ŞAZACILIK GIDA TA┼ŞIMACILIK SAN.T─░C. LTD.┼ŞT─░. HOROZK├ûY	38.62762700	27.40362200	1
14746	43	D2F048355	AYNUR GEN├ç	38.61681700	27.37854800	1
14747	43	D2F132848	BARI┼Ş AKINER	38.62378000	27.38922000	1
14748	43	D2F162190	BED─░R KARAKAYA	38.63642080	27.39452100	1
14749	43	020034188	BEK─░R FEY─░Z/MERT B├£FE	38.61547900	27.37985000	1
14750	43	D2F217972	BEK─░R ─░BA	38.61016580	27.36677970	1
14751	43	D2F035179	BELG─░N K├ûK	38.62765100	27.39398100	1
14752	43	D2F192427	BE┼Ş─░RE ZA─ŞLI	38.61052980	27.36920070	1
14753	43	D2F131769	BOZK├ûY POL─░S KANT─░N─░	\N	\N	1
14754	43	D2F058913	BURCU AKG├£NE┼Ş	38.61393700	27.37513500	1
14755	43	D2F230737	BUSE DA─ŞDEV─░REN	38.61008970	27.38618940	1
14756	43	D2F151614	BUSE MET─░N	38.61425140	27.39356180	1
14757	43	D2F220798	CAFER TIRA┼Ş	38.63430450	27.39422250	1
14758	43	020033018	CEMAL DALDAL/DAL B├£FE	38.62141500	27.40149000	1
14759	43	D2F242415	C─░HAN G├£RKAN	38.63128950	27.38763750	1
14760	43	D2F215821	├çA─ŞATAY DENKTA┼Ş	38.61465920	27.37192380	1
14761	43	D2F182040	├çA─ŞLIYANLAR AKARYAKIT LTD.┼ŞTi	38.63404200	27.39198400	1
14762	43	D2F176651	├çINARARDI AKARYAKIT VE ─░N┼ŞAAT LTD.┼ŞT─░.	38.63811300	27.38432600	1
14763	43	D2F194649	EM─░NE KARADA─Ş	38.62630590	27.39140400	1
14764	43	D2F233275	EM─░R AY─░NGER	38.62752580	27.40476000	1
14765	43	D2F003319	ERHAN YILMAZ	38.62105900	27.37712000	1
14766	43	D2F000079	EROL AYDEM─░R	38.62050100	27.38052500	1
14767	43	D2F037133	ERSAN ─░S─░MBAY	38.62096900	27.39775800	1
14768	43	D2F142147	ERTU─ŞRUL KARAHAN	38.61496300	27.37513440	1
14769	43	D2F199630	EYY├£P AYCAN	38.62536550	27.39598570	1
14770	43	D2F177122	FATMA BOZTA┼Ş	38.63524700	27.39621700	1
14771	43	D2F229589	FECR─░ ARPA├ç	38.62678000	27.39869000	1
14772	43	D2F002194	FERHAT YILMAZ	38.61670000	27.37449100	1
14773	43	D2F180258	FEVZULLAH ARSLANTA┼Ş	38.61646410	27.37685890	1
14774	43	D2F129173	FEYZA KABAK	38.61588900	27.38369900	1
14775	43	D2F235722	FOND─░P ALCOHOL CENTER GIDA LTD.┼ŞT─░.	38.61091900	27.38832000	1
14776	43	D2F182967	GEN├ç AYDINLAR ─░N┼Ş.TURZ.GIDA LTD.┼ŞT─░.	38.63602940	27.39384720	1
14777	43	D2F206133	G├ûKHAN KOYUNLU	38.61524530	27.37630890	1
14778	43	D2F233406	HACER E─Ş─░LMEZ	38.63060250	27.40050230	1
14779	43	D2F057006	HAD─░ YILMAZ	38.62426200	27.39851200	1
14780	43	D2F226771	HAKAN ├ûZ├çEL─░K	38.62279900	27.41173800	1
14781	43	D2F062242	HAKAN ┼ŞAH─░N	38.61196670	27.37581820	1
14782	43	D2F230840	HALE AKSOY	38.62138980	27.39526110	1
14783	43	D2F003640	HAL─░L BARTU	38.61467100	27.38006800	1
14784	43	D2F114514	HAL─░L ─░BRAH─░M TATLI	38.61896440	27.38436260	1
14785	43	020033291	HAL─░L O─ŞULGANMI┼Ş/D─░LEK MRK	38.61354000	27.38963100	1
14786	43	D2F233982	HAMZA YILMAZ	38.61999140	27.37775030	1
14787	43	D2F049729	H─░MMET TA┼ŞDEM─░R	38.62274800	27.41089200	1
14788	43	D2F002192	HUR─░YE YILDIRIM	38.61499500	27.37848500	1
14789	43	D2F160728	H├£SEY─░N CO┼ŞAR	38.63026830	27.40211810	1
14790	43	D2F152554	H├£SEY─░N ERAY	38.62094370	27.39194850	1
14791	43	D2F132106	H├£SEY─░N TEK─░N	38.63605000	27.39300800	1
14792	43	D2F239527	I┼ŞIK POL─░SAJ M├£HEND─░SL─░K SAN.T─░C.LTD.┼ŞT─░. I┼ŞIKLAR ┼ŞUB.	38.62235700	27.37776000	1
14793	43	D2F237213	─░BRAH─░M YAK┼Ş─░	38.62237360	27.39767730	1
14794	43	D2F000735	─░RFAN AYDEM─░R	38.63506200	27.38898000	1
14795	43	D2F013359	─░RFAN YILMAZ	38.62615130	27.40041630	1
14796	43	D2F230373	─░SMA─░L AYHAN	38.62282230	27.40975590	1
14797	43	020034483	─░ZC─░ PETROL A ┼Ş PETROL OF─░S─░	38.61411000	27.39032500	1
14798	43	D2F133232	KAD─░R ├çEL─░K	38.62403100	27.40748410	1
14799	43	D2F183737	KAM─░L Y─░─Ş─░TER	38.62812800	27.38751250	1
14800	43	D2F150436	KEMAL KUR┼ŞUN	38.62984550	27.39764250	1
14801	43	D2F223563	KEVSER YAL├çIN	38.63396870	27.39406180	1
14802	43	D2F240765	L├£TF─░ KAPLAN	38.62196660	27.38080810	1
14803	43	D2F200008	MEHMET AR─░K	38.62444740	27.39725330	1
14804	43	D2F002339	MEHMET DEDE┼Ş	38.61882050	27.38829470	1
14805	43	D2F229118	MEHMET D├£ZL├£K	38.63471810	27.39425970	1
14806	43	D2F231498	MEHMET ─░NCE	38.63173430	27.40269460	1
14807	43	D2F230123	MEHMET KARTAL	38.63090000	27.40340650	1
14808	43	D2F196180	MESUT ANG─░	38.62622350	27.39798570	1
14809	43	D2F190357	MESUT ├ûZER	38.60974480	27.38783540	1
14810	43	D2F216897	METE HAN DAMAR	38.61073640	27.38813770	1
14811	43	D2F224686	MUHAMMED ERSOY	38.63031400	27.40214500	1
14812	43	D2F182097	MURAT TEK─░N	38.62688020	27.39857460	1
14813	43	D2F163982	MURAT UZUN	38.62461760	27.40611310	1
14814	43	D2F000149	MUSA G├£NEYSU	38.62997900	27.40234100	1
14815	43	D2F038933	MUZAFFER S├ûNMEZ	38.63725600	27.39477100	1
14816	43	020033007	NAMIK ─░PL─░K├ç─░/ONUR B├£FE	38.61678600	27.37979300	1
14817	43	D2F151283	NESL─░HAN ASLAN	38.63775070	27.39220820	1
14818	43	D2F197660	N─░LAY AYVAR	38.62936600	27.40300700	1
14819	43	D2F195649	NURETT─░N OMAK	38.62201180	27.38599860	1
14820	43	D2F210746	OG├£N ┼ŞEN	38.62145320	27.38996290	1
14821	43	D2F213738	├ûMER G├ûRKEM ┼ŞENER	38.61061000	27.38305100	1
14822	43	D2F003543	├ûMER SOLAK	38.61233700	27.39175400	1
14823	43	D2F147104	├ûZAL AKBO─ŞA	38.63528360	27.39588460	1
14824	43	D2F143871	├ûZPOLATO─ŞLU CUMHUH─░R─░YET	38.62740700	27.39589300	1
14825	43	D2F002375	├ûZPOLATO─ŞLU UNCUBOZK├ûY	38.61100900	27.39022800	1
14826	43	D2F182607	├ûZPOLATO─ŞLU VAL─░ AZ─░Z BEY	38.61993080	27.38491470	1
14827	43	D2F003920	RECEP ARPACIK/Y├ûREM ┼ŞARK├£TER─░	38.61038100	27.38798900	1
14828	43	D2F032909	SADETT─░N ├ûZKAN	38.61190370	27.38142090	1
14829	43	D2F198625	SA─░ME YILDIRIM	38.63135060	27.40351470	1
14830	43	D2F000119	SAL─░H K├£├ç├£KA─ŞA	38.61673000	27.39113400	1
14831	43	D2F002338	SAL─░HE DO─ŞAN	38.63871970	27.39515610	1
14832	43	D2F222086	SAM─░ AYKUT	38.63625800	27.39149200	1
14833	43	D2F119043	SAVA┼Ş CAN KU┼ŞKULU	38.62252430	27.39085600	1
14834	43	D2F209659	SED─░YA TUR	38.62493180	27.39926830	1
14835	43	D2F157542	SERAP DA┼Ş	38.61852620	27.37699490	1
14836	43	D2F149270	SEYFETT─░N ASLAN	38.63466300	27.39266600	1
14837	43	D2F002367	SEYF─░ G├£LER	38.61230500	27.39039300	1
14838	43	D2F124853	SEYFUN ASLAN	38.63289140	27.39424790	1
14839	43	D2F161574	SEY─░THAN KEREKL─░	38.62957100	27.40191600	1
14840	43	D2F030394	S─░BEL KARABEY	38.60743900	27.38687700	1
14841	43	D2F185369	SUAT G├£NYER	38.62513810	27.40145990	1
14842	43	020034252	S├£LEYMAN S├ûNMEZ	38.61890920	27.37869680	1
14843	43	D2F003770	┼ŞEHR─░ZADE T├£Z├£N	38.62373100	27.39947800	1
14844	43	D2F154734	┼ŞEVKET YILMAZ	38.63644030	27.39461570	1
14845	43	D2F177450	TAH─░R BATUR	38.61712650	27.37442700	1
14846	43	D2F228640	TAHS─░N AYKUT	38.63888340	27.39514510	1
14847	43	D2F002169	TUNCAY KAYA	38.60929900	27.39010500	1
14848	43	D2F000147	U─ŞUR TA┼Ş	38.63030000	27.40273000	1
14849	43	D2F002438	├£NAL KARDE┼ŞLER AKARYAKIT ├£RL.TURZ.SAN. VE T─░C.A.┼Ş.	38.59063730	27.35470280	1
14850	43	D2F003901	VEDAT YILMAZ	38.62080200	27.38502100	1
14851	43	020033011	YAPEK LTD. ┼ŞT─░.	38.61827200	27.39522900	1
14852	43	D2F125474	YA┼ŞAR TA┼ŞTEK─░N	38.62505240	27.39246070	1
14853	43	D2F223403	YAVUZ BOZTA┼Ş	38.62272500	27.41174210	1
14854	43	D2F202042	YILDIRIM I┼ŞIKLI	38.62316710	27.40099190	1
14855	43	D2F027584	YOLCU KARDE┼ŞLER GIDA 75.YIL ┼ŞUBE 5	38.61678800	27.38395100	1
14856	43	D2F052751	YOLCU KARDE┼ŞLER HOROZK├ûY ┼ŞUBE 6	38.63027900	27.40290100	1
14857	43	D2F224739	YUSUF ─░SLAM ERG├£L	38.61125670	27.38675080	1
14858	43	D2F222806	ZEYNEP TURANLI	38.62370950	27.38638210	1
14859	43	D2F239138	ZEYNEP YILDIRIM	38.62358070	27.38289860	1
14860	45	D2F003229	ABBAS ENG─░NDERE	38.62495500	27.37182600	1
14861	45	D2F216143	ADEM UYANIK	38.66001410	27.33721210	1
14862	45	D2F133183	AHMET AYTEN	38.63362230	27.34700130	1
14863	45	D2F000796	AHMET BOZKAPLAN	38.76109400	27.42721800	1
14864	45	D2F186821	AHMET ESENT├£RK	38.65950880	27.33752530	1
14865	45	D2F232030	AKKANLI PETROL ├£R├£NLER─░ NAK.─░N┼Ş.VE MLZ.GIDA MAD.PAZ.SAN.T─░C.LTD.┼ŞT─░	38.64917990	27.35618710	1
14866	45	D2F237333	AL─░ R─░ZA BOZARSLAN- SE├ç MARKET	38.75812830	27.42757440	1
14867	45	D2F043338	AL─░ U─ŞUZEL	38.65585900	27.33612800	1
14868	45	D2F147253	AR─░F AK├çAMAN	38.73277290	27.36109870	1
14869	45	D2F239825	ARZU ├ûNG├£N	38.64369370	27.33630400	1
14870	45	D2F238926	AY┼ŞE BOZ	38.65579890	27.34124530	1
14871	45	D2F002183	AYTEN KO├çAK	38.63378900	27.37980100	1
14872	45	D2F201190	BADO PERAKENDE GIDA ─░N┼ŞAAT OTOMOT─░V LTD.┼ŞT─░.	38.65518150	27.33881630	1
14873	45	D2F242650	BARI┼Ş ALTAN	42.94838100	34.13287400	1
14874	45	D2F157035	BARI┼Ş MALAK	38.62959950	27.27103310	1
14875	45	D2F002055	BEDR─░ SEV─░ML─░	38.65784700	27.33961400	1
14876	45	D2F132737	BEK─░R ─░BA - KE├ç─░L─░K├ûY	38.61017900	27.36312600	1
14877	45	D2F203554	BERAT BAKKAL	38.65274800	27.33033200	1
14878	45	D2F236646	BERAT YILMAZ	38.65556290	27.33893580	1
14879	45	D2F119691	B─░LAL DURMAZ	38.65778350	27.33953930	1
14880	45	D2F161487	B─░LAL ORHAN DEM─░R	38.76375870	27.44754780	1
14881	45	D2F218109	B─░LGE SEV─░ML─░	38.65380020	27.33849100	1
14882	45	D2F150267	CANER TATLICILAR	38.64493210	27.34907740	1
14883	45	D2F087207	CAN─░P KAYA-1	38.65015300	27.32859300	1
14884	45	D2F208603	CAV─░T BOZ	38.68114390	27.30242470	1
14885	45	D2F134235	C├£NEYT SEV─░ML─░	38.65857960	27.34579050	1
14886	45	D2F179503	DUYGU BA┼ŞAR	38.65515510	27.33883280	1
14887	45	D2F153434	EBRU BA┼ŞBO─ŞA	38.65208700	27.33050600	1
14888	45	D2F180322	ECE ─░PL─░K├ç─░	38.64393600	27.34918500	1
14889	45	D2F241440	EL─░F LEYLA B─░LGE	42.94838100	34.13287400	1
14890	45	D2F219855	EM─░NE AYDIN	38.65840000	27.33883800	1
14891	45	D2F183217	EMRAH KO├ç	38.62978590	27.27801900	1
14892	45	D2F226048	EMRE ERBAY	38.65711320	27.34099890	1
14893	45	D2F232925	EMRE KAYA	38.64436340	27.33195430	1
14894	45	D2F126312	ERAY ─░LBEY	38.65245300	27.33048100	1
14895	45	D2F163594	ERCO┼Ş LOJ─░ST─░K H─░ZMETLER─░ OSB	38.63416100	27.35799800	1
14896	45	D2F002345	ERG├£N AK├çAMAN	38.73276500	27.36267200	1
14897	45	D2F235621	FAT─░H ERT├£RK	38.71366560	27.32676750	1
14898	45	D2F230056	FATMA TOPAL	38.63724560	27.27909720	1
14899	45	D2F188146	FIRAT KAYA	38.64941810	27.32757300	1
14900	45	D2F231170	FUNDA G─░RG─░N	38.65771280	27.33973280	1
14901	45	D2F052526	GAMZE D─░N├ç	38.65244300	27.32976800	1
14902	45	D2F238046	G├ûKHAN ALTINMAKAS	38.65641100	27.33600000	1
14903	45	D2F171855	HACER KUR┼ŞUNLU	38.62849810	27.27913900	1
14904	45	020033072	HAKAN G├£RSAF	38.65961500	27.33753800	1
14905	45	D2F230532	HAKAN YILMAZ	38.61478900	27.32608900	1
14906	45	D2F193191	HAKTAN DENL─░	38.65514590	27.33895710	1
14907	45	D2F127291	HAL─░L ABALIO─ŞLU	38.65796900	27.33578700	1
14908	45	D2F031442	HAL─░L ├ûKDEM	38.75917200	27.42821200	1
14909	45	D2F230677	H─░CRAN MUTU├ç	38.65513810	27.33803520	1
14910	45	D2F155760	H─░KMET ├£NAL	38.62874030	27.37649840	1
14911	45	D2F242452	H├£SEY─░N HAS├çEL─░K	42.94838100	34.13287400	1
14912	45	D2F163037	─░BRAH─░M ZEYBEK	38.67139300	27.29193330	1
14913	45	D2F241193	─░REM ABALIO─ŞLU	38.65504700	27.33650700	1
14914	45	D2F155190	─░SMA─░L U├çAR	38.74914350	27.39479620	1
14915	45	020034247	JET-PET AKARYAKIT SAN.T─░C.LTD.┼ŞT─░.	38.64986500	27.32220400	1
14916	45	D2F192726	KAD─░R B─░L─░R	38.65286400	27.33029300	1
14917	45	D2F233099	KAD─░R ┼ŞAKRAK	38.64533970	27.33171070	1
14918	45	D2F229935	K─░BAR ISTAMBUL	38.66171380	27.33608650	1
14919	45	D2F173065	MAH─░R AKKAYA	38.65806200	27.33586100	1
14920	45	D2F000204	MEHMET ELB─░RL─░K	38.65935500	27.33744800	1
14921	45	D2F207162	MEHMET ENGER	38.73187410	27.36144850	1
14922	45	D2F189458	MEHMET KU┼ŞULUO─ŞLU	38.64426020	27.34464690	1
14923	45	D2F159807	MEHMET ├ûZYOL	38.65280710	27.33451700	1
14924	45	D2F239340	MEHMET U├çTU	38.65987700	27.33923280	1
14925	45	D2F212553	MENDUH AKKU┼Ş	38.65238720	27.33283170	1
14926	45	D2F233855	MENEK┼ŞE BOZKURT	38.62906610	27.27853980	1
14927	45	D2F237536	MERT EV─░RGEN	38.64913600	27.32812500	1
14928	45	D2F225359	MESUT ├ûZER 2	38.67366200	27.30953700	1
14929	45	D2F112915	MOS PETROL	38.61986900	27.35694700	1
14930	45	D2F197952	MOS PETROL 2	38.62817650	27.33039750	1
14931	45	D2F232320	MUHAMMET FER─░T DEM─░R	38.62504430	27.37631370	1
14932	45	D2F127184	MUHARREM AK├ç─░N	38.65929000	27.33756100	1
14933	45	D2F186955	MUHARREM G├ûKMENER	38.65740590	27.34025230	1
14934	45	D2F003177	MURAT BACAK	38.76214800	27.39943000	1
14935	45	D2F180951	MUSTAFA G├ûK├çE	38.61540710	27.34521410	1
14936	45	D2F140591	NAZ─░F ABALIO─ŞLU	38.66016170	27.34231890	1
14937	45	D2F189911	N─░OBE PETROL ─░N┼ŞAAT OTOMOT─░V SANAY─░ VE T─░CARET A.┼Ş	38.64682400	27.35450900	1
14938	45	D2F241625	NURAN ARSLAN	38.65928200	27.34097840	1
14939	45	D2F228267	OG├£N ┼ŞEN  3	38.65673680	27.33378310	1
14940	45	D2F198980	ONUR GEN├çOLER	38.60983860	27.36198230	1
14941	45	D2F106645	ORK├ûY YUNTDA─ŞI MANDIRA	38.62969400	27.38014700	1
14942	45	D2F003621	OSMAN GEN├ç	38.73251350	27.36100870	1
14943	45	D2F233636	├ûMER AK├çAY 2	38.65585700	27.33891900	1
14944	45	D2F155404	├ûZCAN YILDIZ	38.64905980	27.32871110	1
14945	45	D2F086030	├ûZPOLATO─ŞLU G├£ZELYURT	38.63748700	27.37079100	1
14946	45	D2F079083	├ûZPOLATO─ŞLU MURAD─░YE	38.65700150	27.34083540	1
14947	45	D2F126952	├ûZPOLATO─ŞLU MURAD─░YE 2. ┼ŞUBE	38.65392400	27.33123200	1
14948	45	D2F068922	PER─░ ─░NANLI K─░RAZ	38.65973800	27.34086200	1
14949	45	D2F000832	SAADET K├£NTA┼Ş	38.71939800	27.38747900	1
14950	45	D2F002504	SAL─░H T├£KENMEZER	38.65576600	27.33245500	1
14951	45	D2F127377	SAVA┼Ş MALAK	38.62875060	27.27884860	1
14952	45	D2F227536	SERCAN ERSOY	38.63254250	27.37428940	1
14953	45	D2F229225	SEVDA ├çEKCEN	38.65621250	27.33284980	1
14954	45	D2F144029	SEV─░NUR DEM─░REL	38.65773990	27.34589230	1
14955	45	D2F167836	SITT─░ DURBAK	38.65311640	27.33172910	1
14956	45	D2F130853	SONG├£L ├ûZEN	38.64289600	27.31982390	1
14957	45	D2F198623	SP─░L PETROL GIDA SANAY─░ LTD.┼ŞT─░.	38.65036770	27.35246040	1
14958	45	D2F182763	┼ŞAFAK ALTINKIRAN	38.63393370	27.36853050	1
14959	45	D2F096753	┼ŞENG├£L G├£RCAN	38.71430400	27.32788400	1
14960	45	D2F163834	TAL─░P BALKAR	38.61540360	27.34610600	1
14961	45	D2F223005	TURAN SOYU├ûZ	38.64732100	27.34863100	1
14962	45	D2F231732	TURUN├ç KAHVE KURUYEM─░┼Ş-BRM SEBZE MEYVE VE KURU GIDA SANAY─░ T─░CARET L─░M	38.64615800	27.34072200	1
14963	45	D2F109822	ULA┼Ş MALAK	38.68029700	27.30397500	1
14964	45	D2F002280	YA┼ŞAR KIZIL	38.71798000	27.35076400	1
14965	45	D2F135380	YEDI EMIN OTOPARK OTOM.TAS.INS. VE INS. MLZ.SAN.TIC. LTD.STI. - G├£VEN	38.63275430	27.37279300	1
14966	45	D2F002618	YEL─░Z ERTEM	38.65910600	27.33711200	1
14967	45	D2F002419	YILDIRIM ├ûZ	38.73361010	27.47817100	1
14968	45	D2F127125	YOLCU KARDE┼ŞLER TOK─░	38.63571940	27.37592420	1
14969	45	D2F242531	YUNUS EMRE KAPLAN	38.63465040	27.27326680	1
14970	45	D2F074466	ZAFER ─░PEK	38.61643400	27.36438900	1
14971	42	D2F170746	ABDULKER─░M SA─ŞIR	38.63492590	27.55959310	1
14972	42	D2F176339	ABDULLAH G├£VEN├ç	38.68993870	27.67897570	1
14973	42	D2F147677	ABDULLAH RA┼Ş─░T HA├ç─░N	38.70812680	27.51173510	1
14974	42	D2F170338	AHMET AL─░ S├£VAR─░	38.73213900	27.55966610	1
14975	42	D2F000072	AHMET BA┼ŞARAN	38.77317200	27.52688300	1
14976	42	D2F136082	AHMET G├£LTEN	38.68921400	27.67953800	1
14977	42	D2F201695	AHMET KA┼ŞAN-SE├ç MARKET	38.60437310	27.60002240	1
14978	42	D2F209527	AL─░ ECEVET	38.73474300	27.56081300	1
14979	42	D2F003672	AL─░ ERB─░L	38.63022900	27.65347100	1
14980	42	D2F119204	AL─░ ├ûZSOY	38.73728660	27.55136750	1
14981	42	D2F002259	AL─░ PALALI	38.68726010	27.68056180	1
14982	42	D2F000136	AL─░ ┼ŞENG├£L	38.72977700	27.54575100	1
14983	42	D2F190524	AL─░ ┼Ş─░M┼ŞEK	38.68041270	27.58453370	1
14984	42	D2F040043	AL─░HAN DEN─░ZL─░	38.73013300	27.58019600	1
14985	42	D2F000066	AR─░F AKTA┼Ş/AR─░F B├£FE	38.73297790	27.56412030	1
14986	42	D2F002295	AYET CANDIR	38.68044000	27.58172600	1
14987	42	D2F218592	AYNUR PALALI	38.62241380	27.61790200	1
14988	42	D2F233270	BAYRAM AL─░ ALSAY	38.72937720	27.57559630	1
14989	42	D2F002133	B├£LENT G├ûV┼ŞEN	38.64089500	27.81798400	1
14990	42	D2F013272	CANER B─░LG─░N	38.73495600	27.56915800	1
14991	42	D2F239855	CENG─░Z ─░NCE	38.84821940	27.46642880	1
14992	42	D29001852	C├£NEYT ├ûZKAN	38.60308120	27.67712120	1
14993	42	D2F154159	├çALI┼ŞKANLAR MNS PETROL ├£R.SAN.VE T─░C.L─░M─░TED ┼ŞT─░.	38.69664350	27.51307130	1
14994	42	D2F209568	├ç─░├çEK DO─ŞANER	38.64394140	27.81660750	1
14995	42	D2F231680	D─░LAVER YAZICI	38.68502210	27.58243840	1
14996	42	D2F000113	DURBAY ─░N┼Ş. GIDA SAN.T─░C.LTD.┼ŞT─░.	38.65735350	27.63363810	1
14997	42	D2F232685	EBRU ┼Ş─░M┼ŞEK	38.78109680	27.22267870	1
14998	42	D2F000056	EFRAH─░M AKTA┼Ş/├ûZLEM TEKEL	38.73448500	27.56556000	1
14999	42	D2F000820	EL─░F TUN├ç	38.87613460	27.29131000	1
15000	42	D2F236741	EM─░NE ATT─░LA	38.62291580	27.62054550	1
15001	42	D2F229588	EMRAH SONKAYA	38.73290000	27.57900000	1
15002	42	D2F182469	EMRE ├çOKER	\N	\N	1
15003	42	D2F236482	EMRE SERT	38.73398950	27.56201190	1
15004	42	D2F212137	ERAY TOBACCO SHOP T├£T├£N VE T├£T├£N ├£R├£NLER─░ AKARYAKIT ─░N┼Ş. SAN. LTD.┼ŞT─░.	38.73550970	27.56683210	1
15005	42	D2F159295	ERDO─ŞAN TURGUT	38.77264700	27.15703290	1
15006	42	D2F209751	ERKAN CO┼ŞKUN	38.73497770	27.57249060	1
15007	42	D2F166682	ERSAN LEVENT	38.65449350	27.63735160	1
15008	42	D2F003976	ERSAS OTO NAK.GIDA ─░N┼Ş.TEM.SAN. VE DI┼Ş T─░C.LTD.┼ŞT─░.	38.73240700	27.58709900	1
15009	42	D2F146065	ERTAN BAYRAK	38.63015650	27.65277270	1
15010	42	D2F209122	ESMA ACARKO├ç	38.86304040	27.26429320	1
15011	42	D2F223327	FAD─░ME ERG├£NEN	38.64105550	27.81774020	1
15012	42	D2F002241	FAHR─░YE K├£R┼ŞAT	38.77299700	27.52902800	1
15013	42	D2F198953	FA─░K SOYSAL	38.63177330	27.53532680	1
15014	42	D2F146063	FAT─░H ┼ŞAH─░N	38.68507720	27.67839330	1
15015	42	D2F003380	FATMA DUMANLI	38.84500500	27.27835300	1
15016	42	D2F126264	FATMA ERSELV─░	38.64348070	27.82118270	1
15017	42	D2F148766	FAZLI KOCACIK	38.73298050	27.57513930	1
15018	42	D2F229301	FERHAT ├ûZSOY	38.73695280	27.55279830	1
15019	42	D2F056169	FER─░T EBRET	38.73749000	27.54987800	1
15020	42	D2F137585	FEYYAZ DEM─░R	38.82545250	27.57683680	1
15021	42	D2F154525	FEYYAZ IRMAK	38.73544180	27.56594650	1
15022	42	D2F120209	G├ûKSEL AKARYAKIT ├£R├£NLERI SAN. VE TIC. LTD. STI.	38.72690700	27.57557000	1
15023	42	D2F114452	G├ûKSELLER PETROL ├£R├£N TUR─░ZM SAN VE T─░C LTD ┼ŞT─░.	38.72967500	27.57446500	1
15024	42	D2F004368	G├ûN├£L G├û├çER	38.70871000	27.51050700	1
15025	42	D2F228687	G├£L├ç─░N ERYILMAZ 2	38.73667650	27.56850030	1
15026	42	D2F133357	G├£L├£MSER G├£NG├ûR	38.64089320	27.81811140	1
15027	42	D2F076282	HAKAN ├çALI┼ŞKAN	38.73145000	27.57369300	1
15028	42	D2F002121	HAKAN Y├£CE	38.73367200	27.56904200	1
15029	42	D2F183547	HAKAN Y├£CE 2	38.73295300	27.56737000	1
15030	42	D2F234370	HAL─░L KESK─░N	38.74957940	27.31256600	1
15031	42	D2F146173	HAL─░L KUR┼ŞUNLU	38.77308860	27.52862630	1
15032	42	D2F153230	HAL─░L T├£NALP	38.68663850	27.68097050	1
15033	42	D2F182582	HAL─░L ├£ST├£NDA─Ş	38.65667920	27.63556130	1
15034	42	D2F003746	HAL─░L YUMURTA┼Ş	38.87590620	27.29075520	1
15035	42	D2F002334	HAL─░SE ABACI	38.73245770	27.57140160	1
15036	42	D2F002429	HARUN KARAKAYI┼Ş	38.68516700	27.67930100	1
15037	42	D2F003987	HASAN AL─░ ├çET─░R	38.86318440	27.25370770	1
15038	42	D2F000101	HASAN ├çAKIR	38.63081200	27.65446400	1
15039	42	D2F000097	HASAN ├çELEMEN	38.68818900	27.67967800	1
15040	42	D2F237507	HASAN ─░NCE	38.78477380	27.29479740	1
15041	42	D2F133186	HASAN SARIDA─Ş	38.72908150	27.57532320	1
15042	42	D2F236639	HAT─░CE KANTARCIO─ŞLU	38.60481220	27.60016740	1
15043	42	D2F003140	H─░LM─░ KILIN├ç	38.64028900	27.81957700	1
15044	42	D2F000496	H├£SEY─░N BEKTA┼Ş(M─░N─░ MARKET )	38.70119600	27.63629400	1
15045	42	D2F002395	H├£SEY─░N G├ûKSEL	38.75620950	27.55119120	1
15046	42	D2F120221	H├£SEY─░N G├£RCAN	38.75891710	27.16412970	1
15047	42	D2F241635	H├£SEY─░N ┼ŞEKER	38.73257750	27.55808450	1
15048	42	D2F003418	─░BRAH─░M DEDE┼Ş	38.66379200	27.77666300	1
15049	42	D2F222576	─░BRAH─░M G├£LER	38.68209110	27.72194340	1
15050	42	D2F000105	─░DR─░S DEM─░RLENK	38.65392800	27.63667800	1
15051	42	D2F194201	─░HSAN G├£├çL├£	38.64091100	27.81821400	1
15052	42	D2F197970	─░LHAN ├ûZSOY	38.73259700	27.56939200	1
15053	42	D2F001358	─░SMA─░L AKKOCA	38.82562100	27.57710300	1
15054	42	D2F049726	─░SMA─░L BAYSAL	38.75364680	27.31099350	1
15055	42	D2F000098	─░SMA─░L KARAKULAK	38.68771100	27.67777800	1
15056	42	D2F120225	─░SMA─░L KARAKULAK-1	38.68661660	27.67959230	1
15057	42	D2F002101	─░SMA─░L SARDO─ŞAN	38.65669000	27.63449600	1
15058	42	D2F175925	─░SMA─░L TURAN	38.73512220	27.56455120	1
15059	42	D2F000789	─░SMAYIL HAKKI ER─░┼Ş─░R	38.77179400	27.19197800	1
15060	42	D2F002376	KAD─░R ORU├ç	38.73211430	27.57174670	1
15061	42	D2F206077	KAD─░R UZUN	38.79288950	27.56817080	1
15062	42	D2F139006	K─░RE├ç├ç─░LER GIDA-┼ŞUBE 1	38.73316490	27.55602360	1
15063	42	D2F139005	K─░RE├ç├ç─░LER GIDA-┼ŞUBE 2	38.73579300	27.56756500	1
15064	42	D2F139004	K─░RE├ç├ç─░LER GIDA-┼ŞUBE 3	38.73507890	27.57355160	1
15065	42	D2F123767	K─░RE├ç├ç─░LER GIDA-┼ŞUBE 4	38.73123100	27.57981800	1
15066	42	D2F092101	K─░RE├ç├ç─░LER GIDA-┼ŞUBE 5	38.73374620	27.56739370	1
15067	42	D2F126478	K─░RE├ç├ç─░LER GIDA-┼ŞUBE 6	38.73267990	27.56378780	1
15068	42	D2F002238	KORAY DEN─░ZHAN	38.65675000	27.63431800	1
15069	42	D2F131674	MEHMET D─░NEKL─░	38.73832700	27.54911160	1
15070	42	D2F003274	MEHMET EM─░N YAZILI	38.81037500	27.50364900	1
15071	42	D2F211090	MEHMET G├£NG├ûR	38.63817060	27.81977480	1
15072	42	D2F242703	MEHMET ─░REG├ûR	42.94838100	34.13287400	1
15073	42	D2F002642	MEHMET KA├çAR	38.58036990	27.61098980	1
15074	42	D2F002165	MEHMET KARAKAYI┼Ş	38.68501900	27.67992300	1
15075	42	020032962	MEHMET K─░R─░┼Ş	38.73506300	27.57003800	1
15076	42	D2F002258	MEHMET KO├ç	38.73025200	27.58172300	1
15077	42	D2F207411	MEHMET NAR─░N	38.76007380	27.25298880	1
15078	42	D2F229868	MEHMET NARL─░	38.67817520	27.68614940	1
15079	42	D2F225197	MEHMET SAVA┼Ş├çI- SE├ç MARKET	38.73687630	27.56578910	1
15080	42	D2F024543	MEHMET SERDAL ULUTA┼Ş	38.73222800	27.54952000	1
15081	42	D2F004433	MEHMET S─░VR─░	38.85142900	27.43590800	1
15082	42	D2F173853	MEHMET TOZAN	38.73843590	27.54892170	1
15083	42	D2F000059	MENK├£LER GID. ─░N┼Ş. TURZ. T─░C.VE SAN.LTD.┼ŞT─░	38.72867400	27.54537400	1
15084	42	D2F100553	MERT ├ûZY├ûR├£K	38.62335400	27.62115900	1
15085	42	D2F000107	MNS ├ûZLEM GIDA VE ─░HT─░YA├ç MAD.G├£BRE VE YAK.MALZ.PAZ.SAN.T─░C.LTD. ┼ŞT─░.	38.65649200	27.63418400	1
15086	42	D2F002269	MURAT D─░KER	38.68251400	27.72145200	1
15087	42	D2F158065	MUSTAFA AL─░ D├£Z├£NGEN	38.68240760	27.72258150	1
15088	42	D2F210995	MUSTAFA AVCI	38.70891810	27.50761800	1
15089	42	D2F003537	MUSTAFA GEN├ç	38.73501650	27.56903600	1
15090	42	D2F000801	MUSTAFA ├ûKDEM	38.84906340	27.34940120	1
15091	42	D2F226178	MUSTAFA USLU	38.86314710	27.25334510	1
15092	42	D2F227288	MUSTAFA YAVA┼Ş	38.85281810	27.32961550	1
15093	42	D2F237013	NAG─░HAN ALSAN	38.73380980	27.56986940	1
15094	42	D2F002158	NAZIM KARACAR	38.65454090	27.63750480	1
15095	42	D2F003164	NAZ─░F ├£ST├£N	38.88583800	27.48853640	1
15096	42	D2F208935	NESL─░HAN BELL─░	38.64040560	27.82144210	1
15097	42	D2F183711	NEZ─░HA G├ûR	38.68252490	27.72215610	1
15098	42	D2F112352	NURETT─░N ENG─░N	38.65723860	27.63692850	1
15099	42	D2F218152	NURTEN TALAN	38.76008550	27.25301920	1
15100	42	D2F133726	O─ŞUZHAN URTEK─░N	38.73205220	27.54715370	1
15101	42	D2F117212	├ûMER AKTAY	38.91678050	27.34618700	1
15102	42	D2F238884	├ûMER DERYA	38.73372600	27.57476090	1
15103	42	D2F002125	├ûZGAN TOPEL	38.77286470	27.52625110	1
15104	42	D2F216033	├ûZLEM ERKELET	38.73643300	27.56869100	1
15105	42	D2F187554	├ûZLEM G├£RSOY	38.88609210	27.48810870	1
15106	42	D2F137496	RAMAZAN AYAZ	38.83351590	27.34156430	1
15107	42	D2F000813	RAMAZAN BARAK	38.85241400	27.32970200	1
15108	42	D2F208359	RAMAZAN ERARSLAN	38.74916860	27.21485430	1
15109	42	D2F003382	RAMAZAN ORTA	38.75076540	27.21463000	1
15110	42	D2F201857	RAMAZAN PEL─░T	38.85250220	27.32886610	1
15111	42	D2F079318	RUK─░YE G├£├çL├£	38.84435800	27.27854400	1
15112	42	D2F000819	SABAHATT─░N KORLU	38.80802000	27.23171100	1
15113	42	D2F004213	SABR─░YE SA─ŞIR	38.63561770	27.55979440	1
15114	42	D2F000794	SAL─░H SATICI	38.77236800	27.15720900	1
15115	42	D2F003717	SAL─░M AYKA├ç	38.64413800	27.87069300	1
15116	42	D2F000092	SAMET YAL├çINKAYA	38.68292800	27.72107000	1
15117	42	D2F044451	SELAHATT─░N ┼ŞAH─░NTEPE	38.64097100	27.81803200	1
15118	42	D2F002294	SERDAR G├£LTEN	38.68498660	27.68018420	1
15119	42	D2F002156	SEVD─░YE I┼ŞIK	38.63078870	27.53402300	1
15120	42	D2F193898	S─░BEL AKTA┼Ş	38.73528330	27.56897240	1
15121	42	D2F236644	S─░NEM METE	38.58038950	27.61103820	1
15122	42	D2F222092	SULTAN ├çAKIRKAPLAN	38.77508890	27.34261480	1
15123	42	D2F002137	S├£LEYMAN DAMATUT	38.65657320	27.63470920	1
15124	42	D2F019080	S├£LEYMAN SAVRAN	38.84935000	27.34954600	1
15125	42	020032970	┼ŞABAN AKTA┼Ş/AKTA┼Ş GIDA	38.73475200	27.56797300	1
15126	42	D2F004051	┼ŞENG├£L ├£NAL	38.77218000	27.53061600	1
15127	42	D2F146059	TU─ŞBA ├ûKTEM	38.68238340	27.58291880	1
15128	42	D2F153840	T├£RKAN B─░LG─░N	38.73174140	27.57843970	1
15129	42	D2F183522	U─ŞUR CAN KARA	38.73336100	27.55124900	1
15130	42	D2F223808	U─ŞUR DUMAN	38.68213970	27.58170600	1
15131	42	D2F166888	U─ŞURCAN ├ûZDEM─░R	38.73555100	27.56752600	1
15132	42	D2F003538	UMMAHAN ENG─░N	38.75759580	27.55212140	1
15133	42	D2F169235	UMUT CAN AYDIN	38.73520400	27.56469800	1
15134	42	D2F003258	├£LK├£ KAPAN	38.73390700	27.55512300	1
15135	42	D2F217158	YAS─░N AKKO├ç	38.58047000	27.61055270	1
15136	42	D2F000115	YAS─░N BAYRAKTAR	38.68225600	27.58202000	1
15137	42	D2F001526	YUSUF Z─░YA DER─░STAN	38.68505600	27.67925300	1
15138	22	D2F230311	AKBULUT TUR─░ST─░K D─░NLENME TES─░SLER─░ T─░C.LTD.┼ŞT─░. BATI	39.18053160	27.67620540	1
15139	22	D2F230310	AKBULUT TUR─░ST─░K D─░NLENME TES─░SLER─░ T─░C.LTD.┼ŞT─░. DO─ŞU	39.18081520	27.67771900	1
15140	22	D2F164558	AKMAR MADENC─░L─░K SAN T─░C LTD.┼ŞT─░	39.16173700	27.66609100	1
15141	22	D24036738	AKSU T─░C. KOLL. ┼ŞT─░.	39.17456900	27.50609840	1
15142	22	D24002818	AL─░ KAYAN	39.17356500	27.51004100	1
15143	22	D24003145	AL─░ KEMAL ARI	39.17228130	27.50585730	1
15144	22	D2F163775	AL─░ VURMAZ	39.18538420	27.59068620	1
15145	22	D2F156104	ARMB GIDA SANAYI VE TICARET LIMITED SIRKETI - ARMB GIDA	39.18116590	27.61640970	1
15146	22	D24067362	AT─░LLA ├ûZER	39.18612000	27.59722930	1
15147	22	D2F236118	AYG├£N EMRE ERDENK	39.18103490	27.61009660	1
15148	22	D24015614	AY┼ŞE ├ûZDEN	39.18048200	27.60798900	1
15149	22	D2F241485	AZ─░Z AKIN	39.17780310	27.60391430	1
15150	22	D24016308	B─░RG├£L KAYGI	39.14999700	27.48008700	1
15151	22	D2F168911	BURCU D─░N├çER-BATI	38.92986060	27.70294400	1
15152	22	D2F168864	BURCU D─░N├çER-DO─ŞU	38.92882830	27.70462100	1
15153	22	D2F216291	CAFER YILDIZ	39.18491490	27.59879540	1
15154	22	D24003190	CENNET CAMBAL	39.17417200	27.51184100	1
15155	22	D2F218162	CHIKMET KARA AMET	39.17984860	27.61523080	1
15156	22	D2F182807	C─░HAN KURNAZ	39.18260160	27.60803610	1
15157	22	D2F178264	C─░HAN UYGE├ç	39.14876170	27.47943780	1
15158	22	D2F196568	CUMA ─░NCE	39.05512000	27.54357580	1
15159	22	020019175	├çAKIRO─ŞULLARI GIDA VE ─░HT. MAD. PAZ. LTD. ┼ŞT─░.	39.18823540	27.58244470	1
15160	22	D24041255	DAVUT AKTA┼Ş	39.18481700	27.60937200	1
15161	22	D24130425	DURSUN EL─░PEK	\N	\N	1
15162	22	D24021110	DURSUN METAN	39.18570610	27.59119220	1
15163	22	D24022050	EGEHAN AKAR. ─░N┼Ş.NAK.K├ûM.OTO.KIR.GIDA TUR.─░TH.─░HR. SAN. T─░C. LTD ┼ŞT─░.	39.18420500	27.54848200	1
15164	22	D24003566	ELK─░N OZAN ├çAY	39.18493900	27.60893900	1
15165	22	D2F163822	EM─░R CAN DEM─░R	39.18117050	27.61409600	1
15166	22	D2F186232	ENES AFACAN	39.18498900	27.60098720	1
15167	22	D2F235568	ERDAL SEZER	39.18142680	27.61156880	1
15168	22	D24082522	ERKAN ├çALI┼ŞKAN	39.18664900	27.60587600	1
15169	22	D2F238330	ESMA KO├çY─░─Ş─░T	39.18410370	27.60817500	1
15170	22	D24012318	FARUK AVCU	39.18111900	27.60981500	1
15171	22	D2F232582	FERHAT H─░┼Ş─░R	39.18005940	27.60572650	1
15172	22	D2F208021	FURKAN CO┼ŞKUN	39.18680390	27.60497480	1
15173	22	D2F239029	GAMZE B─░├çER	39.18120040	27.61222350	1
15174	22	D24003347	G├£NG├ûR KAVUN	39.17798880	27.60671520	1
15175	22	D2F226263	HAKAN EVDE─Ş─░┼Ş	39.18703700	27.59217000	1
15176	22	D2F238399	HAYAT─░ ├£NL├£	39.18755560	27.57909720	1
15177	22	020019247	HAYR─░ ├çIPLAK	39.18628350	27.60638550	1
15178	22	D2F239616	H─░LAL SEZEN	39.18962090	27.58128050	1
15179	22	D24028254	H├£SEY─░N AVCI	39.18284600	27.59902500	1
15180	22	020025124	I┼ŞIK PETROL K├ûM├£R ├£R.NAK.LTD.┼ŞT─░.	39.18970700	27.58827900	1
15181	22	D24003503	─░BRAH─░M A├çAR	39.18487230	27.60248380	1
15182	22	D2F238300	─░BRAH─░M B─░RAL	39.18663720	27.58783970	1
15183	22	D2F210573	─░LHAN EL─░PEK	39.18161840	27.60107960	1
15184	22	D2F170324	─░LKER ─░NAN-┼ŞE├ç MARKET	39.19023100	27.58806900	1
15185	22	D2F206162	─░MRAN SEZG─░N	39.18321830	27.60304540	1
15186	22	D2F234977	─░SMA─░L HAKKI G├ûKT├£RK	39.17754120	27.61083810	1
15187	22	D24001979	KARDELEN MRK.SAN.LTD.┼ŞT─░.	39.18658400	27.60441700	1
15188	22	D24001921	KEMAL ├ûZEN	39.18086880	27.60344680	1
15189	22	D2F242785	KER─░M ONAT	39.18348620	27.59107610	1
15190	22	D24028331	KIVAN├ç TURAN	39.18059200	27.61965100	1
15191	22	D24001474	KOCAMAN GIDA BAK.LTD.┼ŞT─░.	39.17975300	27.60560600	1
15192	22	D24082975	KOCAMAN GIDA BAK.VE MES.TOP.PER.SAT.PAZ.K├ûM.PET.LAS.SAN.T─░C.LTD.┼ŞT─░.	39.18166230	27.61244540	1
15193	22	D2F197698	L├£TF─░YE YILDIRIM	39.19110810	27.58782930	1
15194	22	D24001893	MEHMET AFACAN	39.17449100	27.51219000	1
15195	22	D24098750	MEHMET AL─░ KILI├ç	39.18506600	27.60858800	1
15196	22	D2F166935	MEHMET ├çA─ŞMAN	39.18516450	27.59174440	1
15197	22	D2F226293	MEHMET ├çET─░NKAYA	39.18607480	27.60368980	1
15198	22	D2F226369	MEHMET DEM─░RCAN	39.18971100	27.58233300	1
15199	22	D2F147362	MEHMET EM─░N KARA	39.18968840	27.58263810	1
15200	22	D2F170882	MEHMET G├£ZEL	39.18450600	27.60803700	1
15201	22	D2F159374	MEHMET S├ûZENER	39.18464550	27.60819700	1
15202	22	D24053998	MEHMET U─ŞUR KARABIYIK	39.18193810	27.60732800	1
15203	22	D24018475	MET─░N D├£BEK	39.18528300	27.47875300	1
15204	22	D24001494	MUHARREM GEZEKL─░	39.18143400	27.60745790	1
15205	22	D24001663	MUSTAFA K├ûSE	39.18192530	27.61041050	1
15206	22	D24001756	MUSTAFA ORAL	39.17905400	27.61386200	1
15207	22	D24001938	MUSTAFA YAYLA	39.18382300	27.60651700	1
15208	22	D24091564	MUZAFFER ├çINAR	39.18669400	27.60400900	1
15209	22	D2F190667	M├£ESSER G├£L	39.18504600	27.59201700	1
15210	22	020024935	M├£KERREM KAYA	39.15097600	27.48047400	1
15211	22	D2F220035	M├£RVET G├£LC├£	39.18348430	27.60771940	1
15212	22	D2F236103	NA─░L ├ûZP─░R─░N├çC─░ -ADALET	39.18310500	27.60115910	1
15213	22	020024940	NA─░L ├ûZP─░R─░N├ç├ç─░- ├çANDARLI	39.18053000	27.61117700	1
15214	22	D2F240254	NECAT─░ U├çAR	39.18602420	27.60547980	1
15215	22	D2F234424	NECEDD─░N KARADA─Ş	39.18025190	27.60472350	1
15216	22	D24054253	ORHAN ├ûZER	39.18333000	27.59861500	1
15217	22	D2F225846	├ûNDER BAYRAM 2	39.18676080	27.60368870	1
15218	22	D2F219966	├ûNDER ├ûZ├çET─░N	39.18467400	27.59288230	1
15219	22	020019251	├ûZKESK─░N GIDA LTD.┼ŞT─░.	39.18285940	27.60564740	1
15220	22	D24093378	RAK─░P SEZEN	39.18616300	27.59414900	1
15221	22	D2F159375	SAM─░YE G├£VEND─░REN	39.17857760	27.60884600	1
15222	22	D2F218238	SAVA┼Ş KARADA─Ş	39.18087550	27.60456060	1
15223	22	D24087930	SAY─░DE ├çOBAN	39.18905320	27.58182590	1
15224	22	D24096257	SEDAT KANT─░N	39.17965550	27.61019500	1
15225	22	D2F235379	SEL├çUK KARADA─Ş	39.18115240	27.61586880	1
15226	22	D2F225456	SEL─░M DUVARCI	39.18296650	27.60191890	1
15227	22	D24132038	SEMRA NALBANT	39.18641140	27.58850720	1
15228	22	D2F149516	SERAP R├£STEM	39.15183670	27.48145410	1
15229	22	D2F175654	SERAP R├£STEM 2	39.15023230	27.47998790	1
15230	22	D24003060	SERHAT ER	39.18097260	27.61345320	1
15231	22	D2F137910	SHELL PETROL (AKH─░SAR OHT BATI - 6270)	38.92825000	27.70119800	1
15232	22	D2F137909	SHELL PETROL (AKH─░SAR OHT DO─ŞU - 6271)	38.92977500	27.70584700	1
15233	22	D24030375	SOMA ├ûNC├£ NAKL─░YAT HAFR─░YAT YEDEK PAR├çA AKARYAKIT A.┼Ş BERGAMA/SOMA	39.14952800	27.47526800	1
15234	22	D2F215010	SOMA ├ûNC├£ NAKL─░YAT HAFR─░YAT YEDEK PAR├çA AKARYAKIT A.┼Ş CENK YER─░	39.14881800	27.47873300	1
15235	22	D2F238071	SUDE YA─ŞIZ	39.18105170	27.60626930	1
15236	22	D24061978	┼ŞENO─ŞLU HAR─░TA EMLAK PETROL ─░N┼ŞAAT MAD. NAK. T─░C. LTD. ┼ŞT─░.	39.18751900	27.58326700	1
15237	22	D2F214078	TAL─░YE G├£NAY	39.18733800	27.47810250	1
15238	22	D2F229959	TU─ŞBA G├£DERO─ŞLU	39.18311020	27.60426160	1
15239	22	D24136523	TURAN YILDIRIM	39.18588880	27.59291580	1
15240	22	D2F238299	├£MM├£G├£LS├£M EREN	39.18452480	27.60540830	1
15241	22	D24121794	V─░LDAN TUFAN	39.18710770	27.58563500	1
15242	22	D2F176140	YASEM─░N ┼ŞEN├ûZ	39.18374350	27.60725790	1
15243	22	D2F214928	YA┼ŞAR DEM─░R	39.18559300	27.59067400	1
15244	22	D24001856	Y├£CEL UYAR	39.06196100	27.54568400	1
15245	22	D2F211820	ZEK─░ ├ûZGEN	39.18426840	27.59038620	1
15246	54	D24001955	AHMET AKBULUT	39.19879720	27.62035080	1
15247	54	D2F162089	AHMET BULUT	39.19293120	27.60018540	1
15248	54	D2F236899	AHMET G├£DEN	42.94838100	34.13287400	1
15249	54	D24001527	AHMET TA┼Ş	39.20275900	27.62440700	1
15250	54	D2F180394	AHMET YALVARMAZ	39.18950800	27.57398100	1
15251	54	D2F238146	AL─░ BARAN KO├çY─░─Ş─░T	39.18906890	27.60208110	1
15252	54	D2F131452	AL─░ K├ûKSAL	38.98431180	27.77503340	1
15253	54	D2F154611	AL─░ ┼ŞAH─░N	39.20437600	27.62537600	1
15254	54	D2F225699	ASRIN ├ç─░FTC─░O─ŞLU	39.18566900	27.62331710	1
15255	54	D2F206568	AYDIN AKARCA	38.96094860	27.81755600	1
15256	54	D24076186	AYFER AK├çARAN	39.20441200	27.61679200	1
15257	54	D24113428	AYG├£L KAYA	39.18843600	27.61261100	1
15258	54	D2F233354	AY┼ŞE ARSLAN	39.18883550	27.59587880	1
15259	54	D24100008	AY┼ŞE DURMAZ	39.25567600	27.60219900	1
15260	54	D2F232177	AY┼ŞEG├£L POYRAZ	39.19947650	27.61810220	1
15261	54	D2F241626	AZ─░Z KURT AKARYAKIT ├£R├£NLER─░ SAN.T─░C.LTD.┼ŞT─░.	39.19794290	27.56679620	1
15262	54	D2F168633	BESTA AKARYAKIT SAN.T─░C.A.┼Ş	39.18690390	27.56504500	1
15263	54	D2F233100	BET├£L ─░┼ŞB─░LEN	39.18433330	27.61375370	1
15264	54	D24001923	B─░LAL BA┼ŞAK	39.20117000	27.62720800	1
15265	54	D2F003989	BOD-ROOM TUR.AKAR.TA┼Ş.─░N┼Ş.TAAH.GIDA TEKS.YAT.LTD.┼ŞT─░.	38.96612300	27.80812100	1
15266	54	D24001415	B├£LENT KU┼Ş├çU	39.19145500	27.60908500	1
15267	54	D24001827	CEMAL G├£L	39.18801400	27.61683200	1
15268	54	D2F231899	CEMAL G├£LE├ç	39.18759870	27.60180370	1
15269	54	D2F182412	├çAKIR ENERJ─░ AKARYAKIT SANAY─░ T─░CARET LTD.┼ŞT─░.	38.98631470	27.78361620	1
15270	54	D2F174490	D─░KMELER ALI┼ŞVER─░┼ŞMERKEZ─░ GIDA LTD.┼ŞT─░.	39.18846500	27.56787000	1
15271	54	D2F185422	EBRU BA┼ŞTU─Ş	38.98629870	27.77709460	1
15272	54	D2F227227	EBRU TEPE	39.20137820	27.61187540	1
15273	54	D24003056	EGE YILDIRIM GIDA K├ûM.NAK.HAY.TAR.─░N┼Ş.LTD.┼ŞT─░	39.20637300	27.62747900	1
15363	36	D2F215071	AL─░ ER─░K	38.49718270	27.71003240	1
15274	54	D2F160951	EGECE PETROL ─░N┼ŞAAT SANAY─░ VE T─░CARET L─░M─░TED ┼Ş─░RKET─░	39.18026590	27.64086330	1
15275	54	D24001609	EM─░N BENL─░	39.27168360	27.55873200	1
15276	54	D2F215711	EM─░NE AKKUZU	39.18628510	27.61989500	1
15277	54	D2F184577	EM─░NE KARAKA┼Ş	39.18682350	27.60105100	1
15278	54	D2F238117	EM─░R CAN DEM─░R 2	39.18798280	27.59571600	1
15279	54	D2F241277	EMRE CANER	38.98456500	27.77708200	1
15280	54	D2F235758	EMRE ┼ŞAKRAK	39.19016320	27.60252670	1
15281	54	D2F199680	END├£L├£S AKARYAKIT SANAY─░ VE T─░CARET LTD.┼ŞT─░.	39.18284830	27.62575490	1
15282	54	D24086210	ENG─░N BOZKURT	39.18935800	27.61397200	1
15283	54	D2F003291	ERDAL BIYIK	39.01812900	27.81548400	1
15284	54	D24002842	ERHAN T├£RKMEN	39.18638220	27.61090260	1
15285	54	D24068472	F─░KRET YA─ŞCI	39.20077800	27.62315100	1
15286	54	D2F226154	FURKAN U├çAR	39.18892160	27.57060170	1
15287	54	D2F238688	G├ûKHAN BEYTEK─░N	39.18734990	27.61279400	1
15288	54	D2F189391	G├ûKHAN KIRDUDU	39.19534170	27.59835580	1
15289	54	D24103500	G├£L B─░RL─░K OTO.TA┼Ş.MADEN.SAN.VE T─░C.A.┼Ş	39.18933800	27.57278800	1
15290	54	D24097652	G├£LL├£ZAR UYSAL	39.20039020	27.61670330	1
15291	54	D24114308	G├£LS├£M AVCI	39.18669200	27.59479100	1
15292	54	D24143635	G├£NAYLAR MARKET├çILIK VE GIDA LIMITED SIRKETI	39.18662600	27.61086000	1
15293	54	D2F001220	G├£NDO─ŞDU S├£PERMARKET GIDA SAN.VE T─░C.LTD.┼ŞT─░.	38.96207900	27.82251400	1
15294	54	D24002775	HAL─░T DANACI	39.18292300	27.62952700	1
15295	54	D24001814	HASAN SEMERC─░	39.20365200	27.61155400	1
15296	54	D24085280	HAS─░BE ├çAM	39.20735370	27.62137380	1
15297	54	D2F198507	HAYR─░YE KAP─░TAN	39.19315430	27.60719150	1
15298	54	D24127393	H├£LYA ├çET─░N	39.18922800	27.57267700	1
15299	54	D24051719	H├£SEY─░N ┼ŞAH─░N	39.18687030	27.56663380	1
15300	54	D2F147360	─░SMA─░L DEVEC─░	39.24595700	27.51770000	1
15301	54	D2F213232	KADER G├ûLC├£K	39.18802550	27.60597920	1
15302	54	D24003339	KAN─░ YALIM	39.18825700	27.61540500	1
15303	54	D2F236976	KAYA MOTORLU ARA├ç ─░N┼Ş.DAY.T├£K.MAL .PET.├£R.SAN .T─░C.A┼Ş  SOMA KIRKA─ŞA├ç	39.13920200	27.67039700	1
15304	54	D24014213	KE├çEC─░LER AKARYAKIT SAN. VE T─░C. LTD. ┼ŞT─░.	39.32528570	27.63201400	1
15305	54	D2F235203	KIVAN├ç TURAN 2	39.18638050	27.61006310	1
15306	54	D2F234257	K├£BRA DANA	39.20636890	27.61448560	1
15307	54	D24001774	K├£├ç├£KLER K├ûM├£R ├£R.PETROL NAK.T─░C.LTD.┼ŞT─░	39.22526400	27.56411100	1
15308	54	D24128889	MEHMET AL─░ A─ŞIR	39.19221500	27.61220830	1
15309	54	D24014288	MEHMET AL─░ DAV┼ŞAN	39.18892500	27.60465500	1
15310	54	D2F125030	MEHMET AL─░ PEHLEVAN	39.01869610	27.81500540	1
15311	54	D24002867	MEHMET EM─░N KARAKO├ç	39.18558300	27.61610200	1
15312	54	D2F206218	MEHMET G├£M├£┼Ş	39.28296530	27.47937970	1
15313	54	D2F211646	MEHMET ┼ŞAKRAK	39.19257070	27.59933630	1
15314	54	D24131982	MEL─░HA ├ûZKAYA	39.18604100	27.60989500	1
15315	54	D2F180477	MERVE ├ç─░├çEKL─░	39.18996450	27.60714070	1
15316	54	D2F204291	MUHARREM K├ûKSAL- SE├ç MARKET	38.98612090	27.77604180	1
15317	54	D24105988	MUHARREM SEV─░N├ç	39.19019200	27.61476800	1
15318	54	D2F203685	MURAT AKBOLAT	39.20411310	27.61814520	1
15319	54	D24001436	MUSTAFA NAZM─░ ALTINSOY	39.19182900	27.61481600	1
15320	54	D24001832	MUSTAFA ┼ŞEN	39.19795400	27.62338000	1
15321	54	D24003255	MUTLU ├ûM├£R	39.18954700	27.62310400	1
15322	54	D24002655	MUZAFFER AK	39.18775200	27.59560480	1
15323	54	D2F179848	M├£ZEYYEN ┼ŞANCI	38.98562820	27.77926940	1
15324	54	D2F173360	NED─░M KESK─░N	39.33324240	27.67081180	1
15325	54	D2F138718	NURETT─░N AKARCA	38.96114930	27.81539890	1
15326	54	D2F207128	NURULLAH DEM─░RAY	39.19080040	27.62105080	1
15327	54	D2F205735	O─ŞUZ TA┼ŞKIN	39.20337500	27.62452800	1
15328	54	D24143563	ONUR YILDIRIM	39.18988870	27.60601180	1
15329	54	D24025348	OSMAN G├£NDO─ŞAN	39.17965600	27.63801500	1
15330	54	D24001649	OSMAN YAVA┼Ş	39.19385300	27.67178900	1
15331	54	D2F166494	POP├£LER AVM HAYVANCILIK TARIM GIDA  LTD.┼ŞT─░.	39.20215900	27.62418800	1
15332	54	D2F000680	SADULLAH YEN─░	39.01751000	27.81575800	1
15333	54	D2F171055	SAL─░HA A├çAR	39.18637600	27.56052120	1
15334	54	D2F233198	SAL─░HA G├£NG├ûR	39.19411270	27.67084790	1
15335	54	D24122368	SELAHETT─░N UYSAL	39.26721880	27.49262060	1
15336	54	D24001606	SELAM─░ BOZALAN	39.32820400	27.66408800	1
15337	54	D2F201343	SERAP KARAMAN	39.18762690	27.62068250	1
15338	54	D24001698	SERCAN G├£LC├£	39.19781900	27.62331500	1
15339	54	D2F003290	SERDAR ├ûZT├£RK	39.03912800	27.79093600	1
15340	54	D2F208169	SERKAN KARABACAK	39.19013200	27.59856440	1
15341	54	D2F210285	S─░BEL ├ûZMEN	39.18625360	27.62005020	1
15342	54	D24013876	SOMA KARDE┼ŞLER MARKET PAZ. T─░C. LTD. ┼ŞT─░.	39.18796800	27.56730700	1
15343	54	D2F215539	SOMA ├ûNC├£ NAKL─░YAT HAFR─░YAT YEDEK PAR├çA AKARYAKIT A.┼Ş MERKEZ	39.18544500	27.62393240	1
15344	54	D2F220052	┼ŞABAN G├£NG├ûR	38.96076870	27.82096590	1
15345	54	D24003058	┼ŞAK─░R ┼Ş─░M┼ŞEK	39.20331200	27.61151900	1
15346	54	D24003171	┼ŞENNUR DAYIO─ŞLU	39.19248800	27.60328800	1
15347	54	D2F230171	┼ŞER─░F ├çEL─░K	39.18813350	27.61392370	1
15348	54	D2F225433	┼ŞEVKET YAZICI	39.19330020	27.61561480	1
15349	54	D2F220010	TU─ŞBA BAYLAS	39.18417640	27.61435900	1
15350	54	D2F226177	U─ŞUR ├£NL├£ER	39.19223790	27.61777450	1
15351	54	D2F227765	U─ŞUR ├£NL├£ER 2	39.18696600	27.60162300	1
15352	54	D2F216667	VOLKAN G├£RLEYEN	39.19260510	27.60308640	1
15353	54	D2F001952	YILDIRAY YILMAZ	39.01569900	27.75584200	1
15354	54	D24136118	YILMAZ NALSIZ	39.18793590	27.59271470	1
15355	54	D24001545	YUSUF GEZG─░N	39.18750300	27.60267900	1
15356	36	D28085583	ABDURRAHMAN AYKA├ç	38.50422520	27.70580480	1
15357	36	D2F211318	ABDURRAHMAN GEZER	38.49680320	27.70859040	1
15358	36	D2F215729	ADEM KERP─░├ç	38.50142200	27.71780580	1
15359	36	D2F225434	AD─░L ALAN	38.50207410	27.71293270	1
15360	36	D2F203084	AHMET DAVUTO─ŞLU	38.50104640	27.70288710	1
15361	36	D2F002998	AHMET T─░LKAT	38.55950300	27.56577800	1
15362	36	D29001425	AL─░ ERG├£LE├ç	38.49860400	27.70846000	1
15364	36	D2F227108	AL─░ KILI├çKAYA	38.49259590	27.70394480	1
15365	36	D29000010	AL─░ SA─ŞLAM	38.49725800	27.71239700	1
15366	36	D2F240909	AYB ┼ŞAMP─░YON B├£FE GIDA T─░CARET LTD. ┼ŞT─░.	38.49554610	27.71112080	1
15367	36	D2F158483	AYDIN ├ûTER	38.50414570	27.70574480	1
15368	36	D2F181050	AYSUN ADIYAMAN	38.49923500	27.70716500	1
15369	36	D2F242527	AYSUN ALTUNDA─Ş	42.94838100	34.13287400	1
15370	36	020029216	AYTEN KO├çY─░─Ş─░T	38.49921300	27.70782600	1
15371	36	D28057655	BARI┼Ş ├çET─░NER	38.49467300	27.70663200	1
15372	36	D2F193787	BERKAY M├£EZ─░NLER	38.49246300	27.69989500	1
15373	36	D2F226409	B─░G G─░R─░┼Ş─░M GIDA ANON─░M ┼Ş─░RKET─░	38.49590100	27.70273100	1
15374	36	020029213	B─░RSEN ARSLANKE├çEC─░O─ŞLU	38.49793200	27.70695800	1
15375	36	D2F182290	BURHAN ERDEN	38.49510040	27.70541480	1
15376	36	D2F000027	CAH─░T G├ûKARSLAN	38.56761100	27.56966600	1
15377	36	D2F192813	CEBRA─░L DO─ŞAN	38.49983050	27.70422490	1
15378	36	D29001939	CEMAL ├ûZDO─ŞAN	38.49185290	27.69867190	1
15379	36	D2F174010	CO┼ŞKUN GEN├çEL	38.49557500	27.71136700	1
15380	36	020029512	CUMA ZENG─░N	38.49492400	27.70401800	1
15381	36	D2F109453	├çALI┼ŞKAN PETROL SAN.T─░C.LTD.┼ŞT─░.	38.56116300	27.55699400	1
15382	36	D2F215669	DO─ŞAN D─░N├çER	38.50524350	27.70656460	1
15383	36	D2F236648	DO─ŞAN ├ûZ	38.49635760	27.70980510	1
15384	36	D2F209813	EM─░N ├ûZPAMUK├çU	38.50441790	27.71206130	1
15385	36	D28063990	EMRAH TUKMAK	38.49361900	27.70643800	1
15386	36	D2F199069	EMRE ─░NC─░R	38.50029910	27.70754710	1
15387	36	D2F225850	ERCAN B─░RDAL	38.50620950	27.70599240	1
15388	36	D2F199706	ERCO┼Ş ENERJ─░ OTOMOT─░V VE OTOMOT─░V ├£RN.LOJ.T.A.┼Ş.	38.55648660	27.56450700	1
15389	36	020029212	ERGUN ARSLANKE├çEC─░O─ŞLU	38.49762000	27.70676300	1
15390	36	D2F000026	ERKAN ├çARIK├çI	38.56680900	27.57080700	1
15391	36	D2F224867	ERS─░N DURNAG├ûL	38.49861440	27.71322680	1
15392	36	D2F177646	ESEN YILMAZ	38.49816410	27.70160800	1
15393	36	D28064930	EVR─░M YILDIRIM	38.49562000	27.70395100	1
15394	36	D29000007	FARUK ┼ŞENNERG─░Z	38.49238800	27.70451700	1
15395	36	D2F176946	FATMA DEM─░R	38.49596360	27.71045010	1
15396	36	D2F201696	G├ûK├çE N─░┼ŞL─░	38.50016680	27.70783200	1
15397	36	D29000011	G├£LS├£M ├çUBUK	38.49551600	27.70603600	1
15398	36	D29000341	G├£RSU GIDA SAN. T─░C. LTD. ┼ŞT─░	38.49500000	27.70480000	1
15399	36	D29000349	H.H├£SEY─░N ├ûZG├£LER	38.49984900	27.70471100	1
15400	36	D2F235605	HACER ├ûZSOY	38.49538580	27.70392660	1
15401	36	D2F225788	HACI AHMET SEYHAN	38.50697360	27.70624880	1
15402	36	D29002043	HACI MURAT ORDU	38.50554100	27.71162100	1
15403	36	D28035823	HAKAN IRGAT	38.49832900	27.70805600	1
15404	36	D2F004075	HAL─░ME AKSOY	38.55793500	27.56193900	1
15405	36	D28028434	HASAN AKTAM	38.50150000	27.71120000	1
15406	36	D2F199707	HASAN ERUZUN	38.49663870	27.70146870	1
15407	36	D2F237061	HAT─░CE K├£BRA YET─░MLER	42.94838100	34.13287400	1
15408	36	D2F242702	H├£RR─░YET ─░ZM─░R	42.94838100	34.13287400	1
15409	36	D28024468	H├£SEY─░N YAGLICA	38.50521200	27.70749600	1
15410	36	D2F166288	H├£SEY─░N YILMAZ	38.50134160	27.71288730	1
15411	36	D2F149677	─░HT─░MAL KOVA	38.55968600	27.56589200	1
15412	36	D2F201290	─░SMA─░L AKCA	\N	\N	1
15413	36	D2F233693	─░SMA─░L SAMTA┼Ş	38.50093350	27.70245740	1
15414	36	D2F172835	KEMAL F─░L─░Z	38.50166190	27.70861380	1
15415	36	D28082109	KER─░ME BA┼ŞBALIK├çI	38.49942800	27.71357500	1
15416	36	D2F198317	M.EM─░N ├ûZBEK	38.49845020	27.70907480	1
15417	36	D28036924	MEHMET AL─░ ├çEL─░K	38.50187600	27.71023300	1
15418	36	D28124742	MEHMET B─░RDAL	38.50455020	27.71416220	1
15419	36	D2F219962	MEHMET ├ç─░├çEK	38.49965360	27.70110360	1
15420	36	D29002017	MEHMET OZMAN	38.50261840	27.71287840	1
15421	36	D2F216740	MEHMET ┼ŞAH DEN─░Z	38.50315630	27.71441220	1
15422	36	D2F225678	MERVE AZMAK	38.49011290	27.69877240	1
15423	36	D2F203682	MET─░N ─░┼ŞLEYEN	38.49798390	27.70275480	1
15424	36	D28072129	MURAT AL─░ BA┼ŞKURT	38.49797990	27.70271460	1
15425	36	D2F237400	MURAT KIRAN	38.50333220	27.70538150	1
15426	36	D29001348	MUSA ┼ŞAKAR	38.50360000	27.70620000	1
15427	36	D2F190525	M├£NEVVER KARAVARDAR	38.50656500	27.70843300	1
15428	36	D2F233298	NAZ─░FE KARASULU	38.50525280	27.70937720	1
15429	36	D29000302	NECAT─░ Y├£KSEL	38.49213530	27.69891420	1
15430	36	D2F182656	NEZL─░┼ŞAH DEN─░Z	38.50009980	27.70696730	1
15431	36	D2F242392	N─░LAY YA┼ŞAR	38.49587000	27.71086010	1
15432	36	D2F229420	NURULLAH KOZAK	38.49622350	27.70671660	1
15433	36	D29001121	O─ŞUZ MERA├ç	38.50193510	27.70342940	1
15434	36	D2F215597	ORHAN KAYGISIZ	38.49975070	27.70321560	1
15435	36	D2F000025	OSMAN G├ûKARSLAN	38.56708900	27.57073600	1
15436	36	D2F237806	OSMAN ─░NCE	38.49870000	27.70800000	1
15437	36	D2F236783	├ûM├£R TURAN	38.50044760	27.70772460	1
15438	36	D2F182838	├ûNDER SARIBEY	38.49948900	27.71145100	1
15439	36	D2F228870	├ûZ AKTA┼Ş TURGUTLU GIDA ─░N┼Ş.SAN. T─░C.LTD.┼ŞT─░.	38.49747760	27.70268710	1
15440	36	D2F169972	├ûZCAN BA┼ŞAYAG├£L	38.49560890	27.69969640	1
15441	36	D29001955	├ûZCAN KOSTAK	38.49902600	27.70913900	1
15442	36	D28053411	├ûZGE AYDINLI	38.49840000	27.70505800	1
15443	36	D28104520	RAM─░S S├£KMEN	38.50079700	27.71919100	1
15444	36	D2F203459	RECEP DEM─░RC─░	38.50122640	27.71025080	1
15445	36	D2F147623	RECEP ERALP - ├çAVU┼ŞO─ŞLU MARKET	38.50162660	27.71092670	1
15446	36	D2F162254	RECEP ├ûNCEL	38.50033710	27.70732180	1
15447	36	D2F150570	RESUL MALGAZ	38.49809680	27.70757920	1
15448	36	D28077819	SAMET K├ûPR├£L├£	38.49574300	27.71103100	1
15449	36	D2F168910	SEFA ├ûZT├£RK	38.50464550	27.71146760	1
15450	36	D29001279	SEMA DA─Ş	38.49284100	27.69820700	1
15451	36	020029217	SEMAHAT ├£NEL	38.49963300	27.70821900	1
15452	36	D2F239720	SEMRA ─░RK	38.50774720	27.71448730	1
15453	36	D29001686	SEMRA ZENG─░N	38.49426100	27.70265100	1
15454	36	D29000743	SERDAR ├ûZKEN	38.50035400	27.70777800	1
15455	36	D2F236115	SEVDA TOKKA┼Ş	38.50330000	27.71260000	1
15456	36	D2F241309	SEVG─░ ├çALI┼ŞKAN	38.56308540	27.55558720	1
15457	36	D29002027	SUNA ARAS	38.50529800	27.70572800	1
15458	36	D2F189400	S├£LEYMAN AKSOY	38.49622840	27.71007810	1
15459	36	D29001013	S├£LEYMAN ├û├çAL	38.50480300	27.71506100	1
15460	36	D2F233656	┼ŞAH─░N ADAK	38.50701360	27.71087440	1
15461	36	D2F166464	┼ŞAK─░R KAYRA	38.50441500	27.70813800	1
15462	36	D29001898	┼ŞULE Y├£KSEL TURAN	38.49908900	27.70340500	1
15463	36	D2F198982	TABANO─ŞLU GIDA LTD. ┼ŞT─░.	38.49850040	27.71282250	1
15464	36	D29000729	TAHS─░N YILMAZ	38.49999800	27.70566200	1
15465	36	D2F146382	TUFAN G├£M├£┼Ş	38.50256300	27.70888300	1
15466	36	D2F227513	TU─ŞBA KARATA┼Ş	38.49861600	27.70748100	1
15467	36	020029413	TURGUT G├£RKA┼Ş	38.49625000	27.70434500	1
15468	36	D29001418	TURGUTLU SEMERKANT K─░TAP GIDA ─░N┼Ş.HAYV.TEKS.─░TH.─░HR.SAN.VE T─░C.LTD.┼ŞT─░	38.50313800	27.70903900	1
15469	36	D29000844	├£NAL HO┼ŞCO┼ŞKUN	38.50024100	27.70875300	1
15470	36	D2F177076	VEDAT ├ûT├£N	38.50639190	27.70800350	1
15471	36	D2F209812	YA┼ŞAR TUTAN	38.49142890	27.69876530	1
15472	40	D2F001545	ABDULLAH ARSLAN	38.62103700	27.46134900	1
15473	40	D28031966	ABDULLAH T─░K	38.50330800	27.70072500	1
15474	40	D29001774	ADEM PETROL TERMAL ─░N┼Ş.TUR.MAD.ENR.─░TH.─░HR.SAN.T─░C.LTD.┼ŞT─░	38.48080800	27.69441100	1
15475	40	D2F203249	AHMET ├çEL─░K	38.60786630	27.47113150	1
15476	40	D2F217997	AKN AKARYAKIT ─░N┼Ş. SAN.VE T─░C. LTD.┼ŞT─░.	38.50849090	27.68767540	1
15477	40	D2F234802	ALEYNA KAYA	38.62330750	27.45541510	1
15478	40	D2F000855	AL─░ ├ç─░L	38.62034290	27.45194800	1
15479	40	D2F178550	AL─░ OSMAN G├£LMEZ	38.49714820	27.69697690	1
15480	40	D2F234363	AL─░ TA┼Ş	38.49591800	27.69841200	1
15481	40	D2F000394	AYDIN KARDE┼ŞLER MARKET	38.61892100	27.45049400	1
15482	40	D2F216467	AYDIN T├£RKO─ŞLU	38.50113340	27.69325220	1
15483	40	D28119942	AYSEL T─░MURTA┼Ş	38.50470150	27.69392190	1
15484	40	D28138497	AYSUN AKAKIN	38.50151240	27.70024820	1
15485	40	D2F200759	AYTEK─░N YILMAZ	38.61991630	27.45803360	1
15486	40	D28059446	AZ─░ZE ├ûZER	38.50928000	27.70289500	1
15487	40	D2F185809	AZ─░ZE TANYER─░	38.57489970	27.74398640	1
15488	40	D2F241821	BATUHAN TURAN	42.94838100	34.13287400	1
15489	40	D2F233698	B─░RCAN AYHAN	38.51256500	27.70549000	1
15490	40	D2F211937	BUKET GE├çG─░L	38.48955470	27.68699590	1
15491	40	D2F223450	BURAK G├£NG├ûR	38.49300330	27.69677550	1
15492	40	D2F237066	B├£┼ŞRA KARTAL	38.50800610	27.69864770	1
15493	40	D2F205473	CANER BA─Ş├çEC─░	38.49392360	27.68847420	1
15494	40	D29000306	CENG─░Z TEZCAN	38.49088900	27.69769700	1
15495	40	D2F135819	├çA─ŞRI ASLAN	38.62117610	27.44641360	1
15496	40	D2F192974	├çET─░N ├£R├£N	38.48189500	27.69534700	1
15497	40	D2F015207	DEN─░Z KO┼ŞAPINAR	38.61906700	27.45575600	1
15498	40	D2F241008	EGECE TADIM GIDA TARIM SAN.VE T─░C. LTD.┼ŞT─░	42.94838100	34.13287400	1
15499	40	D2F216894	ERENPET ENERJ─░ OTO.T─░C.A.┼Ş- SE├ç MARKET	38.51543280	27.70353920	1
15500	40	D2F242394	ERG─░N ├çO┼ŞKUN	42.94838100	34.13287400	1
15501	40	D2F231202	ERHAN KARGA	38.61602550	27.45820210	1
15502	40	D2F002351	ESMAN VERG├£L	38.61826500	27.46297000	1
15503	40	D28139391	ESMER SAPAN	38.51496810	27.70366670	1
15504	40	D2F241523	EY├£P AVC─░L	42.94838100	34.13287400	1
15505	40	D28141484	EYY├£P DALM─░┼Ş	38.50108400	27.70105800	1
15506	40	D29002140	FARUK ATASAYAR	38.49681100	27.68864500	1
15507	40	D2F174355	FARUK SARIALTUN	38.62075840	27.44632320	1
15508	40	D2F229418	FAYSAL AKIN	38.50027920	27.69694650	1
15509	40	D2F003556	FAYSAL BA┼ŞAK├ç─░	38.62297900	27.45704000	1
15510	40	D2F002371	FEHM─░ KAYA	38.61738900	27.45774800	1
15511	40	D2F231039	FIRAT BALCI	38.61626080	27.46080720	1
15512	40	D2F188927	HACI EL├ç─░BO─ŞA	38.50950720	27.70851910	1
15513	40	D28084644	HAC─░RE G├£LMEZ	38.50464100	27.69864800	1
15514	40	D2F229290	HAL─░L K─░┼ŞE├çOK	38.49870700	27.69927500	1
15515	40	D2F003208	HAL─░L ├ûZKAN	38.61751240	27.45877220	1
15516	40	D2F230169	HAMD─░YE O├çAL	38.51355350	27.70505720	1
15517	40	D2F227282	HAN─░F─░ G├£NE┼Ş	38.50916570	27.69423250	1
15518	40	D2F215124	HASAN AKDA─Ş	38.51041650	27.70709810	1
15519	40	D2F181509	HAYRETT─░N Y├£KSELTEN	38.50128870	27.69804540	1
15520	40	D28072316	H─░MMET DORUK	38.49132290	27.69547270	1
15521	40	D29000102	H├£SEY─░N KAYA	38.51332940	27.70345670	1
15522	40	D2F168236	─░BRAH─░M A─ŞAYA	38.50580720	27.69230080	1
15523	40	D2F194016	─░LKER YILMAZLAR	38.49049300	27.69323100	1
15524	40	D2F215442	─░LKNUR G├£LEN├ç	38.50887530	27.70528630	1
15525	40	D28116449	─░SMA─░L UNUTMAZ	38.50873800	27.70069500	1
15526	40	D2F178612	KADR─░ OK	38.50545400	27.70205600	1
15527	40	D2F109064	KAHRAMAN B─░RG├£L	38.62077750	27.46360640	1
15528	40	D28061093	KARAO─ŞLU PETROL ├£R├£NLER─░	38.49237100	27.66507400	1
15529	40	D2F221510	KAYA MOTORLU ARA├ç ─░N┼Ş.DAY.T├£K.MAL .PET.├£R.SAN .T─░C.A┼Ş TURGUTLU	38.49233300	27.67545940	1
15530	40	D2F004330	KAYA MOTORLU ARA├çLAR A.┼Ş	38.61589300	27.46682200	1
15531	40	D28061012	KAYIKLAR AKARYAKIT	38.49506540	27.67223180	1
15532	40	D29001828	KAYNAKLI AKARYAKIT SANAYI VE TICARET LIMITED ┼Ş─░RKET─░	38.48741000	27.69447300	1
15533	40	D29002108	KAZIM G├£LMEZ	38.50644300	27.70196200	1
15534	40	D2F230122	KEREM SELETL─░	38.50349670	27.69351600	1
15535	40	D29001931	KEVSER ├ûNER	38.50418490	27.69224170	1
15536	40	D2F242368	KIBRISLI ALCOHOL CENTER GIDA LTD.┼ŞT─░.	42.94838100	34.13287400	1
15537	40	D2F117337	KIYASETT─░N ├ûZMEN	38.61603410	27.46105940	1
15538	40	D29002113	K─░┼ŞE├çOK D─░LRUBA G├ûL LTD. ┼ŞT─░.	38.49479110	27.69485220	1
15539	40	D29000874	L─░M L─░K─░T PETROL GIDA MAD.SAN.T─░C.LTD.┼ŞT─░.	38.49583000	27.69551300	1
15540	40	D2F215443	MEHMET AKITAN	38.51067100	27.70965260	1
15541	40	D2F223734	MEHMET ATA DEM─░R	38.51087360	27.70955760	1
15542	40	D2F216876	MEHMET ATAN	38.50364360	27.69675390	1
15543	40	020029665	MEHMET AYDIN ├çIKIK├çI AKAR.OTO.T─░C. VE SAN. A.┼Ş.	38.48892200	27.69236200	1
15544	40	D2F208909	MEHMET EM─░N DAL├ç─░N	38.50626900	27.70293600	1
15545	40	D2F146384	MEHMET SA─░T Y├£KLER	38.50621050	27.70324920	1
15546	40	D2F242121	MEHMET T├£┼ŞER	42.94838100	34.13287400	1
15547	40	D28092648	MET─░N SEYCAN	38.49867600	27.69707600	1
15548	40	D28034262	MEVL├£T EROL	38.49711400	27.69721500	1
15549	40	D2F213238	MOHAMMAD ALKHEDER	38.50102300	27.69553300	1
15550	40	D2F217658	MURAT DA─Ş	38.51132280	27.70768620	1
15551	40	D2F234557	MUSA SEM─░Z	38.50441490	27.69683390	1
15552	40	D2F182253	MUSTAFA AKSOY	38.49816300	27.69918800	1
15553	40	D29001250	MUZAFFER POLATLAR	38.50559500	27.69635790	1
15554	40	D2F151579	NAF─░Z ├çET─░NKAYA	38.48642220	27.69546570	1
15555	40	D2F225872	NAG─░HAN G├ûKALP	38.50865520	27.70530440	1
15556	40	D2F199591	NEC─░P SA─ŞLAM	38.61821110	27.45232620	1
15557	40	D2F216984	NEJDET TURMU┼Ş	38.62016570	27.46099360	1
15558	40	D2F217032	N─░MET ├çEL─░K	38.50724010	27.69481700	1
15559	40	D29002171	N─░METULLAH G├£RKAN	38.50664110	27.69112610	1
15560	40	D2F233928	O─ŞUZHAN KO├çAK	38.50227240	27.69505540	1
15561	40	D2F219322	OLKAN SEV─░ML─░	38.61731180	27.46026530	1
15562	40	D2F193190	OSMAN OK	38.57379070	27.71074420	1
15563	40	D2F208090	├ûM├£R ZEYBEK	38.49243990	27.69528880	1
15564	40	D2F115684	RAB─░YE ┼ŞEN	38.61792800	27.45304700	1
15565	40	D2F115019	RAMAZAN AKKAYA	38.62213210	27.46093220	1
15566	40	D2F235827	RE─░S EK─░Z	38.62132800	27.46430500	1
15567	40	D2F004023	SABAHATT─░N SEV─░ML─░	38.62124900	27.46698900	1
15568	40	D28074321	SADIK SEMEN	38.51290600	27.70556100	1
15569	40	D2F218185	SEDAT SUMAR	38.57490710	27.71129490	1
15570	40	D2F153438	SEL─░M BAYANAY	38.50283440	27.70155600	1
15571	40	D2F197867	SERGEN G├£LMEZ	38.49659450	27.69462090	1
15572	40	D2F188730	SERKAN AYDEM─░R	38.62188530	27.45674580	1
15573	40	D29000287	SERKAN ISSI	38.49459200	27.69562800	1
15574	40	D2F204359	SEV─░N├ç KESK─░N	38.49709760	27.69442890	1
15575	40	D2F134809	SEY─░THAN YAL├çIN	38.62196430	27.44682080	1
15576	40	D2F148817	SONG├£L ALABALIK	38.50986470	27.69158250	1
15577	40	D2F242700	SS LUNA E─ŞLENCE VE TUR─░ZM LTD.┼ŞT─░.	42.94838100	34.13287400	1
15578	40	D2F208690	SULHATT─░N DEM─░R	38.50629150	27.70303700	1
15579	40	D29000096	SULTAN C─░R─░T	38.50232600	27.69724800	1
15580	40	D2F129992	S├£REYYA BALKIZ	38.61406380	27.46678690	1
15581	40	D2F225012	SYLVAN CO PARTNERS GIDA EKS.─░┼ŞL.LTD.┼ŞT─░-	38.50993900	27.70862500	1
15582	40	D2F215235	┼ŞAHABETT─░N G├£RKAN	38.50174370	27.69934580	1
15583	40	D2F184232	┼ŞENAY ACAR	38.50105550	27.69601840	1
15584	40	D2F166771	┼ŞEYHMUS YILMAZ	38.50675980	27.69305060	1
15585	40	D2F238707	TANZER ┼ŞEN	38.49321810	27.69622530	1
15586	40	D29001073	TAR-PET LTD ┼ŞT─░	38.49645870	27.68533970	1
15587	40	D2F231098	TU─ŞRUL SOYSALO─ŞLU	38.49237440	27.69540970	1
15588	40	D2F220643	VEYS─░ POLAT	38.60776570	27.47390230	1
15589	40	D2F239729	YA─ŞMUR TANI┼Ş	38.62249420	27.45681850	1
15590	40	D2F209769	YAHYA MOHAMMAD	38.50372020	27.69985500	1
15591	40	D2F229145	YASAKLAR PETROL VE PETROL ├£R├£NLER─░ MAD. YA─Ş GIDA ─░N┼Ş.NAK.LTD.┼ŞT─░	38.51573400	27.70367500	1
15592	40	D2F224795	YASEM─░N ORDU	38.49860600	27.69522200	1
15593	40	D2F209166	YAS─░ME G├£M├£┼Ş	38.49839120	27.68657210	1
15594	40	D2F154729	YILMAZ ├çEKER	\N	\N	1
15595	40	D2F171131	YILMAZ DALMI┼Ş	38.50713070	27.69036110	1
15596	40	D2F146006	ZEK─░ BECER─░KL─░	38.50082200	27.69909500	1
15597	40	D2F146948	ZEYNEP SEM─░Z	38.50458510	27.69432870	1
15598	40	D2F215810	Z─░LAN ULU─Ş	38.50747900	27.70220000	1
15599	38	D2F207412	AHMET B─░NG├ûL	38.47374420	27.66961370	1
15600	38	D2F167359	AHMET FELEK	38.34401420	27.80513010	1
15601	38	D28062529	AHMET KANAR	38.49090500	27.70833500	1
15602	38	D2F159135	AHMET KAYA OTAY	38.48347200	27.70168300	1
15603	38	D2F206224	AHMET UYSAL	38.45986000	27.71088290	1
15604	38	D2F191623	AKIN GRUP AKARYAKIT DA─ŞITIM A.┼Ş	38.49526600	27.73739020	1
15605	38	D2F210357	AL─░ CANBALIK	38.48551500	27.70154400	1
15606	38	D28138721	AL─░ ─░HSAN KADAN	38.48489070	27.70146500	1
15607	38	D28103848	AL─░ O─ŞUR	38.49472200	27.76268900	1
15608	38	D29002134	AL─░ T├£RKMEN	38.52171500	27.83748500	1
15609	38	D2F220436	AY┼ŞE YENER	38.48829110	27.78591540	1
15610	38	020029651	AYVAZ KALKANCI	38.49494300	27.71837600	1
15611	38	D2F150311	BADAY GROUP ENERJI YATIRIM ANONIM SIRKETI	38.49405390	27.78324890	1
15612	38	D2F209232	BARI┼Ş DURMAZ	38.49606850	27.71903810	1
15613	38	D2F233704	BARMANLAR M├£H.─░N┼Ş.MAL.NAK.─░TH.HR.T─░C.LTD.┼ŞT─░. TURGUTLU ┼ŞUB.	38.49522750	27.73166570	1
15614	38	D2F192480	BA┼Ş├çILAR PETROL ─░N┼ŞAAT LTD.┼ŞT─░.	38.49520700	27.75173800	1
15615	38	D2F166683	BATTAL KAVAK	38.48866630	27.70747250	1
15616	38	D2F178767	BURHAN ERDEN	38.49303480	27.70658540	1
15617	38	D29001830	CANKAR AKARYAKIT  - TURGUTLU	38.49550500	27.73418900	1
15618	38	D29000252	CEMAL AYKUT	38.49384300	27.71212600	1
15619	38	D2F210418	CEMAL TURAN	38.48811610	27.70180160	1
15620	38	D2F216373	CENG─░Z YA─ŞIZ	38.49078230	27.72580490	1
15621	38	D28132457	DO─ŞA AKARYAKIT PETROL ├£R├£NLER─░ SANAT─░ VE T─░CARET LTD. ┼ŞT─░	38.49116350	27.70646750	1
15622	38	D28003119	EBRU ERD─░N├ç	38.49195700	27.70749600	1
15623	38	D2F233828	EDA TA┼ŞDELEN T├£RKMENO─ŞLU	38.48988340	27.71689430	1
15624	38	D28089633	EL─░F DEM─░R	38.48923200	27.70487000	1
15625	38	D28110225	EMEL ├ç─░MEN	38.51622830	27.83997150	1
15626	38	D29000676	EM─░N PAMUK	38.56485200	27.78610900	1
15627	38	D2F222089	EM─░NE BAHADIR	38.48290480	27.70419500	1
15628	38	D2F225827	EMRAH AYDIN	38.49480710	27.70778070	1
15629	38	D29002015	ENG─░N CUTUK	38.49497600	27.71641700	1
15630	38	D29000723	ENG─░N SEZG─░N	38.49893300	27.71642400	1
15631	38	D28003107	ERG├£N ├çOLAK	\N	\N	1
15632	38	D29001636	EROL TORLAK	38.46892700	27.81946700	1
15633	38	D2F176132	EVREN ─░R─░	38.49739830	27.71654020	1
15634	38	D2F234450	FADIL KARADA─Ş	38.49097010	27.79019240	1
15635	38	D29000719	FAT─░H S├£R├£C├£	38.49558300	27.71592000	1
15636	38	D28106446	FATMA AYDIN	38.48537900	27.70505600	1
15637	38	D29000705	FATMA BARMAN	38.49285150	27.71144610	1
15638	38	D2F165532	FEH─░ME AKYOL	38.35724170	27.81968360	1
15639	38	D2F219857	FURKAN ├çAKIR	38.52597710	27.78396290	1
15640	38	D2F205862	HAKAN MEM─░┼Ş	38.47022070	27.81791530	1
15641	38	D2F161901	HAL─░L ├çULHA	38.49545960	27.76499490	1
15642	38	D29001224	HAL─░L ─░BRAH─░M AYDIN	38.42366040	27.80755370	1
15643	38	D28046516	Halil Pekdemir-Manisa09-Turgutlu	38.49470000	27.72110000	1
15644	38	D2F159136	HAL─░ME ZORLU PEHL─░VAN	38.49533130	27.76179360	1
15645	38	D29002135	HAN─░FE B─░LG─░├ç	38.34173400	27.81881400	1
15646	38	D2F147778	HASAN G├ûKTEN	38.47361960	27.66871990	1
15647	38	D2F232960	HAT─░CE T├£RK	38.48562750	27.83099700	1
15648	38	D2F146381	H─░MMET Y├ûR├£K	38.49042850	27.71713960	1
15649	38	D2F224181	H├£SEY─░N ─░NCESU	38.49068000	27.72892300	1
15650	38	D29001829	H├£SN─░YE KESK─░N	38.49489300	27.76335800	1
15651	38	D29000155	H├£SN├£ ALTAN	38.52025900	27.83795200	1
15652	38	D29001719	─░BRAH─░M ACAR	38.49003400	27.84212700	1
15653	38	D2F162374	─░BRAH─░M DO─ŞAN	38.49678830	27.71640120	1
15654	38	D2F213068	─░BRAH─░M KARADUMAN	38.49494870	27.77760390	1
15655	38	D28100915	─░HSAN KO├ç	38.49376700	27.76446700	1
15656	38	D2F162564	─░RFAN G├£ND├£Z	38.49472460	27.76184900	1
15657	38	D28206125	─░RFAN KAYA	38.51853870	27.83878790	1
15658	38	D29001964	─░RFAN YA┼ŞAR	38.35763300	27.82797700	1
15659	38	D28105036	─░SMA─░L ├çOLAK	38.49019200	27.73018300	1
15660	38	D29001228	KAD─░R AK├çAKAYA	38.52478100	27.83432790	1
15661	38	D2F219953	KAYIKLAR AKARYAKIT ─░N┼Ş.TUR.GIDA OTO. ─░TH.─░HR.SAN.T─░C.LTD.┼ŞT─░.  SELV─░L─░	38.49057420	27.70647200	1
15662	38	D2F242369	KAZIM PARLAK	38.48784750	27.70236840	1
15663	38	D28050703	KENAN AKCAN	38.52117080	27.83753880	1
15664	38	D29001100	LEYLA O─ŞUZ	38.48633100	27.70163000	1
15665	38	D29000009	MAHMUT ├çAKIR	38.52611000	27.78398700	1
15666	38	D29000014	MAKSUT ┼ŞENDERBENT	38.49320500	27.70852200	1
15667	38	D2F222867	MEHMET AKAY	38.49177240	27.78765360	1
15668	38	D29001595	MEHMET ARI	38.34119900	27.81755700	1
15669	38	D2F175729	MEHMET DA─Ş	38.48946140	27.70832400	1
15670	38	D28060975	MEHMET EM─░N DO─ŞU	38.49437200	27.73809100	1
15671	38	D2F232895	MEHMET KARAMAN	38.48378430	27.70335720	1
15672	38	D2F229419	MEHMET KARASU	38.49368100	27.70903300	1
15673	38	D2F232888	MEHMET K├ûM├£RC├£	38.48408400	27.70157660	1
15674	38	D29001596	MEHMET SAKA	38.34526700	27.80505400	1
15675	38	D2F146498	MEHMET TEKG├£L	38.47022900	27.81778200	1
15676	38	D28227427	MEHMET T├£RK	38.49038210	27.83987170	1
15677	38	D28048340	MEHMET Z─░BEK	38.52258700	27.83692700	1
15678	38	D2F226966	MEL─░H AKSABANCI	38.49205240	27.71858330	1
15679	38	D2F166198	M─░KAY─░L O─ŞULTARHAN	38.48890270	27.70853740	1
15680	38	D28121725	M─░NE AKORAL	38.45906800	27.71207400	1
15681	38	D28129036	M─░NE SA─ŞLAM	38.49542800	27.71631700	1
15682	38	D28058588	MUH─░TT─░N ERCAN	38.48340600	27.70553200	1
15683	38	D28226505	MURAT ALGU	38.52200270	27.83678300	1
15684	38	D28049760	MUSTAFA ERDO─ŞAN	38.35787200	27.82765500	1
15685	38	D28101086	MUZAFFERO─ŞULLARI AKARYAKIT ─░N┼Ş.MLZ.ORMAN ├£RN.GIDA NAK.─░TH.─░HR.SAN.T─░C.	38.48424600	27.82301300	1
15686	38	D2F224042	NEJLA YILMAZ	38.49341040	27.71065550	1
15687	38	D2F217996	NUR─░YE ├ûNER	38.40861100	27.79779710	1
15688	38	D2F159651	O─ŞUZ KASABA	38.44283890	27.72461750	1
15689	38	020029448	ONUR ORBAY	38.49236800	27.71575900	1
15690	38	D28025852	ONUR ├ûZKAN	38.49137300	27.72581200	1
15691	38	D29000768	├ûMER BALABAN	38.56445890	27.78692300	1
15692	38	D2F236106	PETRA ENERJ─░ AKARYAKIT SANAY─░ T─░CARET ANON─░M ┼Ş─░RKET─░	38.48860980	27.79932780	1
15693	38	D29002145	RECEP ─░┼ŞLEYEN	38.49225170	27.71371170	1
15694	38	D28116734	RIZA KOYUN	38.48820100	27.71512700	1
15695	38	D2F228757	RUMEYSA NORMAN	38.49548400	27.71327800	1
15696	38	D2F222595	SELAHATT─░N G├£NG├ûR	38.49310220	27.70616340	1
15697	38	D2F211936	SERAP KO├çY─░─Ş─░T	38.49201480	27.78718990	1
15698	38	D2F163027	SEVDAG├£L├£ BAYRAM	38.49444710	27.76460640	1
15699	38	D2F158354	SEV─░M YILDIZ	38.48983300	27.70639100	1
15700	38	D28085035	SEZER D─░N├çER	\N	\N	1
15701	38	D2F168603	S├£LEYMAN ├ç─░FTC─░	38.48759490	27.70726090	1
15702	38	D29001239	S├£LEYMAN YILDIRIM	38.49112800	27.78974200	1
15703	38	D2F204684	┼ŞULE SEYCAN	38.49547700	27.71689270	1
15704	38	D28114525	TAHS─░N KUR┼ŞUN	38.48753860	27.70483690	1
15705	38	D2F227285	TUNAHAN ALP	38.35619130	27.82530010	1
15706	38	D29000474	TUR-PET LTD.┼ŞT─░.	38.49524200	27.72374000	1
15707	38	D29000963	├£NAL YILDIRIM	38.49538900	27.76236100	1
15708	38	D2F188438	YAZARLAR PETROL VE TUR─░ZM ─░N┼Ş.NAK.OTO LTD.┼ŞT─░. TURGUTLU	38.49591620	27.72870000	1
15709	38	D2F151510	ZEHRA G├ûKALP	38.48984000	27.70681200	1
15710	38	D2F230992	ZEK─░ KOYUN	38.47339190	27.66967180	1
15711	38	D28132828	ZEK─░ K├£YMEN	38.48928300	27.70242900	1
15712	38	D28126108	ZEYNEP UZUN	38.48604560	27.70164610	1
19062	32	D28208597	ADEM SARI-2	38.34797010	28.53339470	3
19063	32	D28000532	ALA┼ŞEH─░R CEZAEV─░ ─░┼ŞYURDU	38.35410000	28.54590000	3
19064	32	D28143979	AL─░ KARAHAN	38.35626800	28.54455550	3
19065	32	D28001065	AL─░ SARI	38.34749000	28.53204700	3
19066	32	D28221751	ASUMAN GEZMAN	38.34633910	28.52006820	3
19067	32	D28216706	AY G├£N MOTORLU ARA├çLAR OTO.PET. LTD.┼ŞT─░.	38.34460950	28.54171350	3
19068	32	D28240461	AYSEL ├çOKAN	38.35110890	28.52580840	3
19069	32	D28000300	AY┼ŞE CAN	38.34543950	28.52949620	3
19070	32	D28240284	AY┼ŞE ONUK	38.47429980	28.27066220	3
19071	32	D28233016	AY┼ŞENUR B─░┼ŞK─░N	38.35108280	28.52644020	3
15723	7	020007688	ABDULLAH ALP - ALP BAKKAL	38.36821600	27.12301200	2
15724	7	D2K090096	ABD├£LSELAM AKYOL - AKMAR	38.36297290	27.13170300	2
15725	7	020000407	AHMET KILIN├ç - BAKKAL	38.36420300	27.12586900	2
19072	32	D28001704	BAHATT─░N KESK─░N	38.38079800	28.48720800	3
15726	7	D2K237275	AHMET METE	38.37004760	27.13380470	2
15727	7	D2K089455	AHMET Y├£CEDA─Ş - M─░RZA MARKET	38.35758000	27.12920200	2
15728	7	D2K188150	AKIN I┼ŞIK	38.36452990	27.11781410	2
15729	7	D2K229742	AR─░F YAKLAV	38.34211500	27.14016600	2
15730	7	020048173	ASLAN TAYAR-TAYARLAR BAKKAL─░YES─░	38.36515600	27.11848200	2
15731	7	D2K144358	AYHAN ELB─░L	38.37044140	27.12007120	2
15732	7	020051278	AY┼ŞE ├çE┼ŞMEC─░	38.36527700	27.11744400	2
15733	7	D2H000397	BURHAN KARAHAN	38.34010000	27.14200000	2
15734	7	D2H002265	CANER AKG├£L	38.34454300	27.14426800	2
15735	7	D2K149032	CEM─░L ASLAN	38.35140020	27.13635370	2
15736	7	D2K075737	CEYHAN ERKAN	38.33682700	27.13687000	2
15737	7	D2K170745	C─░HAN ERDEM - MAV─░┼Ş MARKET	38.35174800	27.13955800	2
15738	7	D2K205402	CUMA ASLAN	38.35665280	27.13682440	2
15739	7	D2K196133	DADA MARKET-DADA 35 GIDA ─░N┼ŞAAT ─░THALAT LTD.┼ŞT─░.	38.37016950	27.12230980	2
15740	7	020053332	DAVUT ARSLAN	38.37085800	27.12394500	2
15741	7	D2K191085	D─░LEK YE┼Ş─░L	38.34069020	27.14439610	2
15742	7	D2K230696	ECE TURGUT	38.36153070	27.12418620	2
15743	7	D2K118933	ECEM PETROL AKARYAKIT MARKET VE NAKLIYE TIC.A.S.	38.36070400	27.13632350	2
15744	7	D2K219277	EFSANE PREST─░J GIDA ├£R├£NLER─░ T─░C.LTD.┼ŞT─░.	38.35423850	27.13064010	2
15745	7	D2K234895	EKREM TEK─░N	38.36730850	27.13346400	2
15746	7	D2K130795	EMEL CANK─░	38.35774950	27.13071290	2
15747	7	D2K185743	EM─░N KAYABA┼Ş	38.35732900	27.13876400	2
15748	7	D2K175733	EM─░NE CAN	38.35345110	27.12796220	2
15749	7	D2K132580	EM─░NE D├ûNERTA┼Ş	38.32830960	27.14216460	2
15750	7	D2K126938	ERCAN ASLAN	38.35969420	27.12543850	2
15751	7	D2K165684	ERHAN AKTA┼Ş	38.35121470	27.13952350	2
15752	7	020053133	ERKAN DEM─░R	38.36957700	27.13061300	2
15753	7	D2K208918	ERKAN KARAHAN	38.36810250	27.12657290	2
15754	7	D2K199685	EROL ┼ŞAH─░N	38.36230800	27.12408010	2
15755	7	D2K231433	EYL├£L ASLAN	38.34934660	27.14371920	2
15756	7	D2K216438	FAD─░ME ├çET─░N	38.35115230	27.12795320	2
15757	7	D2K196392	FATMA BOZKURT	38.37039440	27.11980660	2
15758	7	D2K169704	FERHAT ├ûZER	38.35923680	27.14060280	2
15759	7	020018815	FETTULLAH BALIK├çI-SARICAN GIDA	38.36278700	27.12146200	2
15760	7	D2K223501	FURKAN ARTU├ç	38.36861250	27.12572710	2
15761	7	D2K200782	G├£LAY ├ç─░FT├ç─░LER	38.36857000	27.13434100	2
15762	7	D2K196784	G├£L┼ŞAH KILI├ç	38.35371850	27.13584970	2
15763	7	D2K240408	HAKAN AKENG─░N	38.36718140	27.12575050	2
15764	7	020047601	HAKAN AYDEM─░R	38.36590860	27.12643500	2
15765	7	D2K227382	HAL─░D GIDA PAZARLAMA OTOMOT─░V SANAY─░ VE T─░CARET L─░M─░TED ┼Ş─░RKET─░-HAL─░D	38.35540650	27.14363490	2
15766	7	D2K118621	HAL─░S G├£NAYDIN	38.36116190	27.13110040	2
15767	7	020019050	HAL─░T TURAN	38.36777480	27.12882120	2
15768	7	020051609	HAT─░CE ALTA┼Ş	38.35723500	27.14175400	2
15769	7	D2K087865	HAT─░CE KAHRAMAN - KAHRAMAN MARKET	38.36025600	27.12359600	2
15770	7	020005121	H├£SEY─░N KIZIL	38.34848050	27.13931950	2
15771	7	D2K142963	H├£SEY─░N KUTLU	38.36361200	27.12183400	2
15772	7	D2K089729	─░BRAH─░M ASLAN	38.35340300	27.13873400	2
15773	7	020000976	─░BRAH─░M AVHAN	38.34840000	27.14070000	2
15774	7	D2K230841	─░BRAH─░M E┼ŞME	38.32185230	27.14165010	2
15775	7	020048725	─░HSAN YILDIZ	38.37083700	27.12124300	2
15776	7	D2K105130	─░SMA─░L HAKKI AYDO─ŞDU	38.34913400	27.14228300	2
15777	7	D2K233286	─░SMET KANAK	38.35455540	27.14050700	2
15778	7	D2K221290	KAD─░R ├ûGE	38.36932810	27.12396220	2
15779	7	D2K151578	LALE UZUN	38.32222100	27.14143300	2
15780	7	020044714	M.SIDDIK AZAR- S├£T GIDA VE TELEK ├£R├£NLER	38.34823620	27.13926110	2
15781	7	D2K198303	MEHMET AKSOY	38.36699580	27.13004550	2
15782	7	D2K147134	MEHMET AL─░ TAYAR	38.36454680	27.11925930	2
15783	7	020006585	MEHMET ├çIPLAK- ENG─░N B├£FE	38.34830000	27.14000000	2
15784	7	D2K227680	MEHMET H├£SEY─░N DALBUDAK	38.36665990	27.12042400	2
15785	7	D2K210568	MEHMET I┼ŞIK	38.35671300	27.12801000	2
15786	7	D2K207378	MERKAR GRUP TUR─░ZM SANAY─░ VE T─░CARET A.┼Ş	38.35609800	27.13400280	2
15787	7	D2K156352	MET─░N ├ûNDER	38.36714830	27.11705610	2
15788	7	D2K238232	M─░KA─░L KARADA─ŞLI	38.36224580	27.12513140	2
15789	7	020011326	M─░SSA GIDA PAZ. PASTA ─░MALAT SANAY─░ VE T	38.36803400	27.13585200	2
15790	7	D2K075069	MUAMMER TUTAK	38.37060620	27.13499290	2
15791	7	D2K120574	MUHAMMET MUSTAFA ARSLANALP	38.35898870	27.13016380	2
15792	7	D2K104929	MURAT ─░PEK─░┼ŞEN	38.36541200	27.13248600	2
15793	7	D2K173486	MUSTAFA ├ûZG├£R E┼ŞME	38.32242700	27.14127800	2
15794	7	020051414	MUSTAFA ├ûZTEMEL	38.35093400	27.14291600	2
15795	7	D2K158784	M├£┼ŞEREF B─░LG─░	38.36610480	27.11738630	2
15796	7	D2K104716	NAC─░ AVCI	38.33683300	27.13699400	2
15797	7	D2K191822	N─░HAT KEMER	38.35738710	27.14101040	2
15798	7	020052169	N─░ZAMETT─░N TAYAR	38.36283000	27.13276200	2
15799	7	D2K148112	OSMANLI GIDA VE ELEKTRONIK HEDIYELIK ESYA KOZM.SAN.TIC.LTD.STI	38.36889870	27.12967820	2
15800	7	D2K230330	├ûMER AKTA┼Ş	38.36020740	27.12372200	2
15801	7	D2K187305	├ûMER FARUK DEM─░R	38.34249580	27.14342970	2
15802	7	D2K132995	├ûZG├£R AY├çAKAL	38.32829130	27.14209240	2
15803	7	D2K198744	PELDA TOPUZ	38.35590960	27.13056550	2
15804	7	D2K194386	PETROL OF─░S─░ A.┼Ş. (KARABA─ŞLAR - M019)	38.35749500	27.13525100	2
15805	7	D2H000455	RAMAZAN KARAYEL	38.33697800	27.13757600	2
15806	7	D2K228868	RAMAZAN MERCAN	38.35316900	27.13181800	2
15807	7	D2K143049	RECEP HARMANKAYA	38.36956540	27.12411310	2
15808	7	D2H000828	SABR─░ SARIG├£L	38.35260000	27.12800000	2
15809	7	D2K094120	SADIK TURANLI  - ┼ŞAFAK GIDA TEKEL	38.34718000	27.14019600	2
15810	7	D2K175981	SA─░ME TA┼Ş├çI	38.36403910	27.12886130	2
15811	7	D2K079239	SELMA YAKLAV	38.34876650	27.14382060	2
15812	7	D2K234919	SERDAR KO─ŞMAZ	38.36765640	27.11885580	2
15813	7	D2K092259	SEVG─░ FAR─░ZO─ŞLU - KARDELEN MARKET	38.35934000	27.14114600	2
15895	19	D2H174204	MEHMET ZEK─░ ├ûZTEK─░N	38.43696180	27.15300580	2
15814	7	D2K194005	┼Ş─░RVAN PETROL ├£R.SAN.VE T─░C.LTD.┼ŞT─░.	38.35487490	27.13332440	2
15815	7	D2K236311	TURAN KO├çAR	38.35263840	27.12220430	2
15816	7	D2K211263	U─ŞUR KARA	38.36802730	27.11815290	2
15817	7	020051120	Y-EREN PETROL VE PET.├£R├£N.TA┼Ş.OTO.GIDA T	38.35106000	27.13422000	2
15818	7	020001006	YUSUF AKKO├ç	38.35472900	27.14262700	2
15819	7	D2K233059	YUSUF BAYIK	38.36623730	27.12024510	2
15820	7	D2K166075	YUSUF ENES ERG├£L	38.36490000	27.12059600	2
15821	7	D2K233766	ZAFER ├çET─░N	38.35815150	27.14152260	2
15822	7	D2K210757	ZERDE┼ŞT TEM─░RO─ŞLU	38.36839410	27.13534230	2
15823	7	D2K088296	ZEYNEP KOCAMAN	38.35649800	27.14232200	2
15824	7	D2H026602	ZEYNEP ├ûZT├£RKLER	38.35215900	27.12704600	2
15825	19	D2K241796	URM─░A TUR─░ZM GIDA SANAY─░ VE T─░CARET LTD.┼ŞT─░	42.94838100	34.13287400	2
15826	19	D2H158794	ABDULLAH ├ûZO─ŞUL	38.43466980	27.14435110	2
15827	19	020050863	AHMET DEM─░R	38.43902900	27.14650800	2
15828	19	D2H163835	AHMET TURSUN	38.43299970	27.13896740	2
15829	19	D2H145770	ALATLI SANS OYUNLARI GIDA VE TURIZM SANAYI TICARET LIMITED SIRKETI - P	38.43490850	27.14022490	2
15830	19	020017555	AL─░ YAYAY├£R├£YEN	38.43215000	27.14126100	2
15831	19	D2H163530	AS─░L AD─░L GIDA TUR─░Z─░M HAYVANCILIK TARIM ─░N┼ŞAAT TAAH├£T OTOMOT─░V ┼ŞANS O	38.43183610	27.13682860	2
15832	19	020010993	AVN─░ ├çOLAK L─░MAN B├£FE	38.44312660	27.14661250	2
15833	19	020046565	AYDEDE TURIZM GIDA INSAAT BILISIM SAN VE TIC LTDSTI - AYDEDE	38.42571800	27.13248900	2
15834	19	020006578	AYDIN KOZAN - AYDIN MARKET	38.43500970	27.14412420	2
15835	19	D2H189858	AYHAN GE├ç─░T	38.43938900	27.14233900	2
15836	19	020055271	BARI┼Ş KARA	38.43600600	27.14116800	2
15837	19	020050218	BED─░RYE YILDIZ	38.43951150	27.14656010	2
15838	19	D2H180189	BELG─░N TUNA	38.43495250	27.14225200	2
15839	19	020058351	B─░LAL BED─░R	38.43192200	27.14978300	2
15840	19	D2H164279	B─░NOM GIDA TEKST─░L OTO.SAN.─░HR.─░TH.SAN. VE T─░C.LTD.┼ŞT─░.	38.44028640	27.14404560	2
15841	19	D2K232530	BM├ç TUR.GIDA TEK.REK.TEM.HIZ.INS.NAK.ELE.ILT.SAN.TIC.LTD.STI.	38.43356850	27.14438640	2
15842	19	020049950	BORA MUSTAFA T├£RKER	38.43860600	27.14217900	2
15843	19	D2K227572	BR─░F─░NG TUR─░ZM VE T─░CARET A.┼Ş	38.43786530	27.15921240	2
15844	19	D2H158873	B├£LENT SEZEN	38.43968700	27.14388600	2
15845	19	D2H185574	CEM DEM─░R	38.44000120	27.14270240	2
15846	19	020004064	CEM─░L ├çAKMAK├çI	38.44142490	27.14394950	2
15847	19	020008042	CESUR KAYA -CESUR MARKET	38.43842500	27.15631100	2
15848	19	020058250	DEDE BILISIM TUR. GIDA INS. LTD.STI. - DEDE B─░L─░┼Ş─░M TUR. GIDA ─░N┼Ş. LTD	38.43616400	27.14064800	2
15849	19	D2H158706	DEM─░RALAY GIDA LIMITED SIRKETI - AREN TOBACCO VE ALCHOL SHOP	38.43222600	27.13756600	2
15850	19	D2K202717	D─░CLE 35 GIDA OTO.T─░C.V SAN.LTD.┼ŞT─░.	38.43917300	27.14658900	2
15851	19	020058172	DURSUN YAZICI	38.43915900	27.14714500	2
15852	19	020057376	ED─░Z SAM─░ EK─░Z	38.43663270	27.14438020	2
15853	19	020004129	EGE ├ç─░FTL─░K ├£R├£N. GIDA LTD.┼ŞT─░	38.43161400	27.14034360	2
15854	19	020017509	EMEKO─ŞLU GIDA PAZ.END.VE T─░C.LTD.┼ŞT─░.	38.43187730	27.14054010	2
15855	19	D2H166223	EM─░NE ├ûNER KARATA┼Ş	38.43014320	27.13598690	2
15856	19	D2K225522	EMS─░AR-EMS─░AR TUR─░ZM OTELC─░L─░K GAYR─░MENKUL YATIRIM ─░N┼ŞAAT SANAY─░ T─░CAR	38.42479700	27.13188100	2
15857	19	D2K202282	ERG─░O─ŞUZ ─░N┼ŞAAT TAAHH├£T TUR─░ZM KAFETERYA SAN.T─░C.LTD.┼ŞT─░.	38.43651140	27.14086500	2
15858	19	D2K213019	ERG├£N KALE├ûZ├£	38.43472800	27.14078400	2
15859	19	020058381	ERNIS INSAAT OTO KIRALAMA SANS OYUNLARI SANAYI TICARET LIMITED SIRKETI	38.43411900	27.14698300	2
15860	19	D2K226470	ESEN ├ûZSINMAZ	38.43744850	27.14167110	2
15861	19	D2H193276	EV─░N TU─ŞAL	38.43024700	27.14208000	2
15862	19	D2K228001	FERHAT ARTAN	38.43149970	27.15003760	2
15863	19	020002322	FER─░DE DO─ŞAN	38.43536300	27.14419600	2
15864	19	D2K202413	FURKAN TU─ŞBERK SEVENCAN	38.43567600	27.14648800	2
15865	19	D2K232381	G├ûL POYRAZ GIDA ─░NAAAT TEKST─░L TUR─░ZM SANAY─░ VE T─░CARET L─░M─░TET ┼Ş─░RKET	38.43574860	27.14318330	2
15866	19	020017326	H.NEYYAN ELB─░RL─░K	38.43740000	27.15810000	2
15867	19	020002875	HAL─░T YAVRUO─ŞLU	38.43981200	27.14473800	2
15868	19	D2H146706	HASAN TOPAL	38.43886930	27.14471500	2
15869	19	020049802	HASAN UFAK ─░N┼ŞAAT SAN.VE T─░C.LTD.┼ŞT─░.	38.43867500	27.14243800	2
15870	19	020056989	HAT─░CE JALE H├ûKE	38.43238090	27.14123020	2
15871	19	D2H186339	HAT─░KE KAPLAN	38.43486100	27.14241500	2
15872	19	020046030	HED─░YE DEM─░R	38.43742030	27.14197400	2
15873	19	D2K228158	H├£LYA TURSUN	38.42636900	27.13267300	2
15874	19	D2H188189	H├£SEY─░N ERCAN ─░ZM─░RL─░O─ŞLU-2	38.43596200	27.14044700	2
15875	19	D2K237910	─░.B.B. GRAND PLAZA GIDA OTELC─░L─░K VE TUR─░ZM ─░┼ŞLETMELER─░ A.┼Ş	38.42880100	27.14759900	2
15876	19	D2K226565	─░BRAH─░M KILI├ç	38.43528100	27.14087500	2
15877	19	D2H182049	─░BRAH─░M MERT KER├çEK	38.43065100	27.15056900	2
15878	19	D2K237505	─░ZM─░R B├£Y├£K┼ŞEH─░R BELED─░YES─░ GRAND PLAZA GIDA OTELC─░L─░K VE TUR─░ZM ─░┼ŞLET	38.44012300	27.15189600	2
15879	19	D2K219214	KAD─░R AKAR	38.43047770	27.13975720	2
15880	19	D2H191370	KAM─░LE ─░ZANCI	38.43485170	27.14262480	2
15881	19	D2K223144	KEMAL ATALI	38.43314500	27.14902100	2
15882	19	D2H189888	KEMAL D─░NLER	38.43668600	27.14492200	2
15883	19	020045123	KORDON BOYU TUR─░ZM TEKST─░L GIDA SAN.VE T─░C. LTD.┼ŞT─░.	38.43398400	27.13884200	2
15884	19	D2H173442	LEMAN DURAK	38.43357330	27.14761350	2
15885	19	020017429	LEVENT AKSAKAL	38.43733100	27.15884600	2
15886	19	D2K232655	LOKMAN ─░LTER	38.43584440	27.14249960	2
15887	19	020002608	MEHMET BA┼ŞAK├ç─░	38.42701310	27.13413350	2
15888	19	020004550	MEHMET DEM─░RC─░	38.44007500	27.14616600	2
15889	19	020044911	MEHMET EREN	38.43414200	27.14482500	2
15890	19	D2H185265	MEHMET HAKSEVER-2	38.43462000	27.14208600	2
15891	19	020052887	MEHMET KAYA	38.42885980	27.13878710	2
15892	19	D2K229616	MEHMET KAZAN	38.43883690	27.14667560	2
15893	19	D2H189721	MEHMET KONG├£L	38.43592800	27.14128800	2
15894	19	D2K227149	MEHMET SIDDIK YE┼Ş─░LTA┼Ş	38.43539900	27.14149100	2
15896	19	020056159	MEL─░H Y├ûR├£K	38.43844100	27.15281200	2
15897	19	020053331	MESUT YILMAZ	38.43780890	27.14202200	2
15898	19	D2K198875	MUYESSER KESEL	38.43929300	27.14555970	2
15899	19	D2H193202	MUZAFFER G├£├çL├£ -+1 SHOP	38.44004500	27.14267500	2
15900	19	D2K202227	MUZAFFER G├£├çL├£ -SEFA MARKET	38.44005460	27.14267150	2
15901	19	D2K229140	MUZAFFER G├£├çL├£-3	38.43992200	27.14291900	2
15902	19	D2K237763	NABB GIDA SANAY─░ VE T─░CARET ANON─░M ┼Ş─░RKET─░	38.43225060	27.13883840	2
15903	19	020006757	NAD─░YE BURTUL	38.43307200	27.13799800	2
15904	19	020017713	NEC─░P EROL TEKEL BAY─░─░	38.43405600	27.14424730	2
15905	19	D2H189762	NEC─░P SAMSA	38.43070300	27.13981300	2
15906	19	020057217	NOW TEKEL GIDA SANAYI VE TICARET LIMITED ┼ŞIRKETI	38.42848720	27.13711970	2
15907	19	020004165	NUR├çAY GIDA SAN. VE T─░C.LTD.┼ŞT─░.	38.44033360	27.14386760	2
15908	19	020056742	NUR─░YE UYSAL	38.44158300	27.14331200	2
15909	19	020006108	OGN GIDA M─░LL─░ P─░Y. VE ┼ŞANS OY.BAY.MARKET ─░┼ŞL.SAN.T─░C.LTD.┼ŞT─░.	38.42833200	27.13480090	2
15910	19	020017604	├ûZCAN YURDAKAN GIDA ┼ŞRK. P.S T─░C. LTD.┼ŞT─░.	38.43262200	27.14964400	2
15911	19	020057777	├ûZG├£R ├ûZD─░L─░	38.43889100	27.14431200	2
15912	19	020047660	PETROLYA─Ş PETROL YA─ŞLARI T─░C. VE SAN. A.┼Ş.	38.43690600	27.16236100	2
15913	19	D2K225818	PINAR EMRE ALTUN GIDA T─░CARET VE SANAY─░ L─░M─░TED ┼Ş─░RKET─░-MAV─░ TEKEL	38.43784250	27.14412490	2
15914	19	020004261	RIDVAN KURT	38.43882300	27.14193400	2
15915	19	020006418	SEMRA KARAKAYA - BAKKAL VE TEKEL BAY─░	38.43797100	27.14695300	2
15916	19	020017531	SERKAN G├£LESER	38.42814000	27.13472300	2
15917	19	020056865	SEVAL NARG─░Z	38.42735090	27.13371090	2
15918	19	020003606	S─░NAN A─ŞA├çE	38.43652000	27.14617500	2
15919	19	D2H167826	S├£LEYMAN KILIN├ç	38.43950590	27.14465050	2
15920	19	020052021	┼ŞER─░F KARATAY - KERVAN KURUYEM─░┼Ş TEKEL BAY─░─░	38.43416500	27.14455800	2
15921	19	D2K205996	┼ŞIMARIK TEKEL GIDA T─░C.LTD.┼ŞT─░.	38.43563850	27.14103240	2
15922	19	020046777	TAMER MAV─░DEN─░Z	38.43917100	27.14700100	2
15923	19	D2K220453	TEK─░N AK├çAY	38.43315520	27.14381890	2
15924	19	020002967	TEK─░N GE├ç─░T- GE├ç─░T TEKEL VE GIDA ├£R├£NLER─░ SATI┼Ş	38.43789200	27.14579000	2
15925	19	020057413	T├£LAY TUR─ŞUT	38.43584160	27.14508380	2
15926	19	D2H196507	VECIHI KAFE TUR ORG REK AJANS SAN TIC LTD ┼ŞT─░	38.43728990	27.14215990	2
15927	19	020058277	YA┼ŞAR SUBA┼ŞI	38.43331300	27.13948600	2
15928	19	020003732	YEN─░ ERDEM -ALSANCAK DRINK CENTER	38.43662700	27.14302770	2
15929	19	D2H145049	ZEYNEP ├£┼ŞENT─░	38.43512460	27.14245160	2
15930	5	D2K168489	ABD├£LKAD─░R ├çAKMAK	38.42505300	27.20239770	2
15931	5	D2K191667	ADEM ARSLAN	38.41746400	27.20174520	2
15932	5	D2K136637	AHMET TURAN HARMAN	38.42268630	27.19406500	2
15933	5	D2K206119	AHMET YET─░┼ŞK─░N	38.41138930	27.18041310	2
15934	5	D2K224679	AL─░ RIZA KO├ç	38.41252170	27.18097150	2
15935	5	020015720	AL─░ UZUN	38.41980500	27.19890200	2
15936	5	020054245	AL─░YE TOY	38.42227800	27.19666600	2
15937	5	D2K238830	ARZU UZUNDA─Ş	38.41508160	27.17827170	2
15938	5	D2K144486	ATiLLA TURAN	38.42340610	27.20493650	2
15939	5	020010198	AY┼ŞE GAZ─░	38.42358170	27.20474120	2
15940	5	020018546	AY┼ŞE SAK - MARTI MARKET	38.40891700	27.16201300	2
15941	5	020055710	BAHATT─░N YURTHAN	38.41604450	27.18098580	2
15942	5	020054520	BARI┼Ş MARKET -ALTINDA─Ş 2	38.42590200	27.19681900	2
15943	5	D2K209639	BERKAN KAYA	38.40797900	27.16700000	2
15944	5	D2K170955	BESTE AL├çALAR	38.41251160	27.16655290	2
15945	5	020052609	B─░RL─░K MARKET├ç─░L─░K T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.41459300	27.17646000	2
15946	5	020015837	B├ûL├£KLER MARKET├ç─░L─░K TP GD PR TC LTD. ┼ŞT	38.42387000	27.19140800	2
15947	5	020001251	B├£LENT ├çAKIR	38.41678630	27.20189990	2
15948	5	020005395	CAN KAHRAMAN	38.41353800	27.18712500	2
15949	5	D2K164128	CAN YAYLALI	38.42171900	27.19389490	2
15950	5	D2K128193	├çABA GIDA TURIZM INSAAT TAAHH├£T SANAYI VE TICARET LIMITED SIRKETI	38.40760000	27.18659200	2
15951	5	D2K202104	DEM─░RO─ŞULLARI NAK.GIDA.TEM.─░N┼Ş.SAN.T─░C.LTD.┼ŞT─░.	38.40994270	27.17382960	2
15952	5	020046566	D─░LEK ┼ŞENT├£RK	38.41648500	27.17376700	2
15953	5	020053004	EKREM ASLAN	38.42270500	27.19506200	2
15954	5	D2K218753	ELEEDD─░N KORKMAZ	38.40899430	27.17945180	2
15955	5	D2K209023	EMRE KALAN	38.42244510	27.20501740	2
15956	5	020047620	ENVER YILDIRIM	38.41814000	27.17859400	2
15957	5	D2K227637	EROL CAN NERG─░Z	38.42521880	27.19982640	2
15958	5	D2K212492	ERSEN TURAN	38.42024610	27.19210770	2
15959	5	D2K201401	ERS─░N TURGUT	38.41411420	27.17799460	2
15960	5	020048645	ERTAN ALTINOK	38.41065100	27.17363100	2
15961	5	020015536	ETEM YILDIRIM - ENG─░N MARKET	38.41309500	27.16626800	2
15962	5	D2K083465	FA─░ZE KARADA─Ş - KARADA─Ş MARKET	38.40764800	27.18151000	2
15963	5	D2K173076	FATMA TURAN	38.41423730	27.17648140	2
15964	5	D2K149676	F─░L─░Z G├£LCE	38.40864800	27.16740000	2
15965	5	D2K215846	GAL─░P PINAR	38.41363760	27.16816850	2
15966	5	D2K202261	G├ûRKEM ├ç─░├çEK	38.41296720	27.17634150	2
15967	5	D2K203982	G├£L┼ŞEN POLAT	38.40994160	27.17057070	2
15968	5	D2K140956	HACI SALCACI	38.42486900	27.20073800	2
15969	5	D2K088628	HACILAR MARKET├ç─░L─░K ─░N┼Ş. OTO. SAN. T─░C. LTD. ┼ŞT─░.	38.41088200	27.16103000	2
15970	5	020048764	HAKKI URGEN	38.41298650	27.18879380	2
15971	5	020016274	HAL─░L ESEN - K├û┼ŞE ├çEREZ	38.41615700	27.17268500	2
15972	5	020005604	HASAN ├çEKEN	38.40874600	27.17238700	2
15973	5	020055255	HASAN MERCAN	38.42261040	27.20343370	2
15974	5	D2K172514	HEJAR KALENDER	38.42064000	27.18740400	2
15975	5	020004074	H─░KMET G├£NE┼Ş - G├£NE┼Ş MARKET	38.41018260	27.17126300	2
15976	5	020046633	H├£LYA B─░NG├ûL - B─░NG├ûL KARDE┼ŞLER DOLL─░	38.41228640	27.17766430	2
15977	5	D2K140955	H├£LYA ├ç─░├çEK	38.41321140	27.17519560	2
15978	5	D2K130465	H├£SEY─░N KORKMAZ	38.41098600	27.16726880	2
15979	5	D2K085597	─░BRAH─░M G├£LE├ç  - 2	38.41051630	27.17328880	2
15980	5	D2K077581	─░BRAH─░M ─░PEK	38.41601500	27.17278900	2
15981	5	020058000	─░KRAM ├ûZMEN	38.41428840	27.19462620	2
15982	5	D2K128189	─░SHAK TA┼ŞKESEN	38.41132050	27.16492470	2
15983	5	D2K149157	─░SMA─░L AKTI	38.41468180	27.17337500	2
15984	5	D2K157179	─░SMET YILDIRIM	38.41479300	27.18379200	2
15985	5	D2K093804	KADER ATMACA - R├£YA MARKET	38.40996300	27.18123800	2
15986	5	D2K166144	KAM─░L A─ŞKURT	38.40628430	27.18454870	2
15987	5	D2K076463	KAM─░L A─ŞKURT	38.40755800	27.18638700	2
15988	5	020052851	KA┼Ş─░F G├£VEN	38.42105210	27.19603160	2
15989	5	020015918	KA┼Ş─░F G├£VEN - G├£VEN MARKET1	38.42300000	27.19316940	2
15990	5	020049467	KEZBAN ERC─░RE	38.41255900	27.16650200	2
15991	5	D2K191176	LEYLA DURDABAK	38.42138860	27.18533370	2
15992	5	020009819	MAH─░DE SAYI┼Ş - MAH─░DE BAKKAL	38.41406560	27.17698490	2
15993	5	D2K173077	MAVU┼Ş YILDIZ	38.41267260	27.18352510	2
15994	5	020015782	MEHMET DUMAN - DUMAN KARDE┼ŞLER	38.42288270	27.19553690	2
15995	5	020047181	MEHMET EN─░S ERO─ŞLU	38.41083800	27.17472900	2
15996	5	020048089	MEHMET HAN─░F─░ G├£NBEY─░	38.41427200	27.18778300	2
15997	5	020004878	MEHMET KAZIM BAYRAM	38.40973940	27.17588550	2
15998	5	D2K240650	MEHMET OKCU	38.41468460	27.17476360	2
15999	5	D2K212649	MELEK U├çURAN	38.41672500	27.17790730	2
16000	5	D2K242687	MET─░N ATLAMAZ	42.94838100	34.13287400	2
16001	5	020049635	MUAMMER ATICI	38.41210700	27.16527000	2
16002	5	D2K217668	MUHAMMED CAN PEKER	38.40853550	27.17822080	2
16003	5	020044159	MUHARREM KARADEM─░R - PARK TEKEL BAY─░─░	38.42038340	27.20303460	2
16004	5	D2K196623	MURAT ├ç─░F├ç─░	38.41414310	27.17781240	2
16005	5	D2K209771	MURAT TA┼ŞBA┼Ş	38.41419620	27.18618680	2
16006	5	D2K153986	MUSTAFA G├ûKKAYA	38.40907260	27.16998680	2
16007	5	020015783	MUZAFFER I┼ŞIK	38.42466900	27.20204500	2
16008	5	020045124	MUZAFFER TUN├ç	38.40751100	27.18345600	2
16009	5	D2K129936	NAZ─░K ALLAHVERD─░	38.41510110	27.18420420	2
16010	5	020016324	NAZL─░YE ATAKAN -ATAKAN MARKET	38.41856680	27.17990170	2
16011	5	D2K232808	NECLA SUSGUN	38.42055730	27.20560260	2
16012	5	020051689	NER─░MAN KAHRAMAN	38.42399320	27.19754260	2
16013	5	D2K134796	NERM─░N AL─░CAN	38.41565870	27.18224840	2
16014	5	020054107	NURAY SUCU	38.41674200	27.20167700	2
16015	5	D2K225742	O─ŞULCAN MUH─░TT─░N KULA	38.41071030	27.17977570	2
16016	5	D2K163440	ONUR BAL	38.42124800	27.20502600	2
16017	5	D2K077946	ONUR HAYDARO─ŞLU	38.40798000	27.17932600	2
16018	5	020006363	ORHAN KAHRAMAN	38.41572550	27.18680210	2
16019	5	020046995	├ûZKAN ┼ŞENEL, ┼ŞENEL BAKKAL─░YES─░	38.42117620	27.20257730	2
16020	5	D2K160322	├ûZNUR D─░N├çER	38.41677600	27.20140200	2
16021	5	020003480	├ûZT├£RKKAR GIDA SERV. NAK. SAN. VE TIC. LTD. STI.	38.42578880	27.20021480	2
16022	5	020052256	REYHAN ├ûZTOP	38.42373650	27.19875110	2
16023	5	020015871	SAF─░YE KALAFAT - HACIO─ŞLU MARKET	38.42111560	27.19889050	2
16024	5	D2K076094	SAVA┼Ş AK├çAY	38.40651110	27.18533140	2
16025	5	D2K205608	SEL─░MCAN POLAT	38.41097540	27.17490270	2
16026	5	020018736	SEVG├£L ├ûZT├£RK	38.41657680	27.18768630	2
16027	5	020055497	SEZA─░ TOP├çU	38.42026650	27.19646090	2
16028	5	020050860	S─░NAN TANDO─ŞAN - TANDO─ŞAN TEKEL	38.42572340	27.19773820	2
16029	5	020000668	S─░NEM YAKUT	38.41448770	27.19641400	2
16030	5	D2K208201	SONG├£L TOZLU	38.41553540	27.18423660	2
16031	5	020055798	SULHETT─░N TURAN	38.41241500	27.17936810	2
16032	5	020015922	S├£HEDA ├çAT	38.42337680	27.19941270	2
16033	5	020057174	┼ŞABAN ┼ŞEN	38.41868200	27.17894500	2
16034	5	D2K123492	┼ŞENOL ORBE─Ş─░	38.41215710	27.16981630	2
16035	5	D2K219929	┼ŞENT├£RK TA┼Ş	38.41472240	27.18672590	2
16036	5	020018647	┼ŞER─░T GIDA PAZ. T─░C.LTD.┼ŞT─░.	38.41425300	27.17275300	2
16037	5	D2K237158	┼ŞEYHMUS AKSOY	38.40899410	27.16147070	2
16038	5	020050601	TAH─░R SARI	38.41178700	27.19028500	2
16039	5	020000195	TAL─░P SA─ŞIRTA┼Ş	38.40802100	27.18530900	2
16040	5	D2K158286	TANAYDIN ALI┼Ş VER─░┼Ş MERKEZ─░ PAZARLAMA VE T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.41630550	27.17961740	2
16041	5	020012071	TANAYDIN GIDA VE KUNDURA SAN.T─░C.LTD.┼ŞT─░.	38.41504110	27.18204970	2
16042	5	D2K201402	TOLGA USLU	38.41736240	27.17548800	2
16043	5	D2K142068	VOLKAN HANO	38.41610600	27.18793700	2
16044	5	D2K131488	YASER HAYDARO─ŞLU-2	38.40643810	27.18367960	2
16045	5	D2K232739	YAS─░N ┼Ş─░R─░N	38.41555550	27.18889550	2
16046	5	D2K163726	YILDIZ GEN├ç	38.41190410	27.18367510	2
16047	5	020047893	YUNUS BALLI	38.41615340	27.18883260	2
16048	5	D2K234295	ZAR─░FE ACAR	38.42337200	27.20497800	2
16049	5	D2K130586	ZEL─░HA ├çALI┼ŞAN	38.41658950	27.18577800	2
16050	5	D2K238973	ZEL─░HA G├£LER	38.41329250	27.17588300	2
16051	5	D2K124213	ZEYNEP KEKL─░K	38.41658400	27.20199200	2
16052	12	020055606	4M GIDA SANS OYUNLARI TURIZM INS. TAAH. SAN. VE TIC. LTD.STI. - 4M GID	38.39392600	27.05144100	2
16053	12	020054932	AL─░ AT─░K	38.39620700	27.06880010	2
16054	12	D2K232721	AL─░ME AKBA┼Ş	38.38530430	27.05827360	2
16055	12	D2K209419	ARZU ├ç─░MEN YILMAZ	38.39095000	27.05674800	2
16056	12	D2K220227	AS─░L TUR GIDA LTD.┼ŞT─░.	38.39578560	27.06210490	2
16057	12	D2K225682	ASYA YOKU┼Ş	38.38540700	27.05570600	2
16058	12	020003318	AYNUL HAYAT DEM─░RTA┼Ş	38.38970900	27.07334900	2
16059	12	D2K227978	AYSUN ERS├ûZ	38.38956660	27.07163390	2
16060	12	D2K229261	BAHATT─░N ER├ûD├£L	38.38553220	27.05977460	2
16061	12	020056942	BAL├çOVA BUR├çAK GIDA INSAAT SANAYI VE TICARET LIMITED SIRKETI	38.38518100	27.05627000	2
16062	12	020054304	BARI┼Ş MARKET -BAL├çOVA 1	38.38350200	27.05809000	2
16063	12	020052135	BARI┼Ş MARKET -BAL├çOVA 2	38.39283900	27.05813200	2
16064	12	020054417	BARI┼Ş MARKET -├£├çKUYULAR	38.39729900	27.06828400	2
16065	12	020050245	BA┼ŞDA┼Ş MARKET - BAL├çOVA	38.38489800	27.05763300	2
16066	12	020052651	CEBRA─░L KARADEN─░Z	38.39005590	27.05832930	2
16067	12	020009149	CEM YILMAZ	38.39483500	27.06369900	2
16068	12	020054096	CEMRE GEM─░C─░	38.39487800	27.07598900	2
16069	12	D2K229663	├ç─░├çEK TUN├ç	38.39103000	27.05638400	2
16070	12	D2K225549	├çOBAN TEKEL GIDA ─░N┼ŞAAT SANAY─░ VE T─░CARET LTD.┼ŞT─░.	38.38816380	27.05872460	2
16071	12	D2H192752	DA─ŞLI GURME GIDA SAN.T─░C.LTD.┼ŞT─░	38.39650100	27.07018400	2
16072	12	D2K205739	DEN─░Z ─░MUR AKY├£REK	38.39188860	27.07762240	2
16073	12	D2H152571	DEN─░Z PAM─░K	38.39076500	27.05737700	2
16074	12	020058020	D─░YAD─░N KIRAN	38.39554600	27.07436600	2
16075	12	D2K240216	DO─ŞU TUNA DAL	38.39334000	27.05805000	2
16076	12	D2K229736	DOP GIDA MARKET SANAY─░ VE T─░CARET L─░M─░TED ┼Ş─░RKET	38.39490100	27.06980000	2
16077	12	020046658	DURAL─░ DO─ŞAN	38.39362700	27.02339100	2
16078	12	020054150	DURAN CEYLAN	38.39425500	27.06621600	2
16079	12	D2K239763	EKREM CEMRE TUGAY KURDA┼Ş	38.39603700	27.06897800	2
16080	12	020012459	ELIT53 GIDA SANS OYUNLARI TUR. INS.SAN.TIC.LTD.STI. - A├çIL GIDA PAZARI	38.39400000	27.07810000	2
16081	12	020047485	EL─░FE Y─░─Ş─░T	38.39245100	27.06365100	2
16082	12	D2K221400	EM─░NE YAMAN	38.38135050	27.05915460	2
16083	12	020046093	ENG─░N ALTINOK	38.38373990	27.05825220	2
16084	12	020045808	ERSEN ├£ZG├£N-KARDE┼ŞLER ALI┼Ş-VER─░┼Ş MERKEZ─░	38.38637100	27.05230500	2
16085	12	D2K233717	ERT├£RK Y├£CEDA─Ş	38.39194720	27.07908160	2
16086	12	020049452	ESAS PETROL MADENC─░L─░K NAK. ─░N┼Ş. GIDA SAN.VE T─░C.A.┼Ş. BAL├çOVA ┼ŞB.	38.37614900	27.07357700	2
16087	12	020049453	ESAS PETROL MADENC─░L─░K NAK. ─░N┼Ş. GIDA SAN.VE T─░C.A.┼Ş. BAL├çOVA ┼ŞB.	38.37474500	27.07541100	2
16088	12	D2K231972	ESRA BALTAN	38.39578100	27.06955200	2
16089	12	D2K227366	FERHAT YURTSEVER	38.39670500	27.07085370	2
16090	12	D2H156935	FI├çI GIDA I├çECEK OTO. TEM. MALZ. TURZ. SAN. VE TIC. LMD. SIRKETI	38.38679400	27.05162500	2
16091	12	020002948	F─░KRET AKTA┼Ş - BAKKAL─░YE	38.39260900	27.07829400	2
16092	12	020004298	FUAT BALTAN	38.39706000	27.06936300	2
16093	12	D2H129914	G─░ZEM ├ûL├çAR	38.39652610	27.07153840	2
16094	12	020058034	G├ûKMEN TA┼Ş	38.39078200	27.06094300	2
16095	12	020015056	G├£LCAN GIDA LTD.┼ŞT─░.	38.39217130	27.05795120	2
16096	12	020015105	HAN─░FE YEN─░├çIRAK	38.39455600	27.07649500	2
16097	12	020004120	HASAN ─░NAK- SELV─░ TEKEL	38.38609200	27.05311300	2
16098	12	D2H151701	HASAN KIRAN	38.39038600	27.05878000	2
16099	12	020044960	HAYDAR AL─░ DAYAN├ç	38.39460650	27.05666700	2
16100	12	020014994	HEYBEL─░ MARKET├ç─░L─░K SAN.T─░C.LTD.┼ŞT─░.	38.38603110	27.05387130	2
16101	12	D2K219072	H├£SEY─░N ├çA─ŞDA┼Ş ├£LKE	38.38954400	27.06012000	2
16102	12	D2H186341	H├£SEY─░N DORUKCAN ESEN	38.39157670	27.05817520	2
16103	12	D2H185241	─░LK─░N BAKKAL─░YE GIDA TEKST─░L TUR─░ZM OTO ─░TH ─░HR SAN T─░C LTD ┼ŞT─░	38.39082160	27.05727260	2
16104	12	D2K236737	─░SMA─░L ─░BR─░┼Ş─░M	38.39107400	27.08158500	2
16105	12	020050622	─░SMA─░L KUT-AZ─░Z B├£FE	38.39597900	27.07070700	2
16106	12	020018280	─░SMET AKBUDAK	38.38682600	27.05839000	2
16107	12	020010723	─░SMET ├çANKAYA	38.38454000	27.05356200	2
16108	12	020055980	KEMAL ├ûZT├£RK	38.37758700	27.07271300	2
16109	12	020057346	KENAN G├£L	38.38487400	27.05686340	2
16110	12	D2K236738	KEVSER D├£NDAR	38.38522900	27.05610800	2
16111	12	020054619	K─░BARO─ŞLU POL─░GON	38.39533600	27.07534300	2
16112	12	020055973	K─░BARO─ŞLU ├£├çKUYULAR	38.39587300	27.07391700	2
16113	12	020053251	KUZEY MARKET GIDA INSAAT SANAYI VE TICARET LIMITED SIRKETI - KOMTA┼Ş TE	38.39714900	27.06816100	2
16114	12	D2K231068	K├£R┼ŞAT TOKMAK	38.39218800	27.05807300	2
16115	12	D2K233252	MEHMET D─░YAD─░N ├çEL─░K	38.39503200	27.07576400	2
16116	12	020006130	MEHMET ERG├£N-LEVENT GIDA	38.39508100	27.07363900	2
16117	12	D2K232603	MEHMET KUZU	38.39698510	27.06625750	2
16118	12	020052954	MEHMET YO─ŞURT├çU	38.38678900	27.05862100	2
16119	12	020015098	MEHT─░ G├ûYL├£S├£N-├çINAR MARKET	38.38572020	27.05478650	2
16120	12	D2K210858	MENDERES KAYGISIZ	38.39519430	27.05901750	2
16121	12	D2K209925	MERAL S├û─Ş├£TL├£ -A BLOK	38.39478600	27.05393100	2
16122	12	D2K210937	MERAL S├û─Ş├£TL├£ -B BLOK	38.39471400	27.05263000	2
16123	12	020051083	MURAT G├£NE┼Ş	38.38698630	27.05906700	2
16124	12	D2K234756	MUSTAFA BEN	38.38406900	27.05354500	2
16125	12	D2H171520	MUSTAFA YILDIRIM	38.39605490	27.06959670	2
16126	12	020045478	M├£STAK─░M ├ûZKAYA	38.39409830	27.06009600	2
16127	12	D2H160698	MYLA GIDA TEKST─░L ─░N┼ŞAAT TUR─░ZM VE SAN.─░HR.─░TH.LTD.┼ŞT─░.	38.39487300	27.05787600	2
16128	12	D2H161803	NAD─░RE ┼Ş─░M┼ŞEK	38.39653860	27.06590630	2
16129	12	020001078	NA─░F Y─░TER	38.38643200	27.06043600	2
16130	12	020046856	NAZ─░F Y─░TER	38.38678370	27.06125790	2
16131	12	020002123	NECLAN KARAKA┼Ş	38.38340230	27.05567680	2
16132	12	D2K204753	NEH─░R ─░K─░ZTEPE GIDA MARKET T─░C.LTD.┼ŞT─░.	38.39648250	27.06534160	2
16133	12	D2H193768	N─░HAL SUBA┼ŞI	38.38569420	27.05825420	2
16134	12	D2H126550	NUMAN KURUYEM─░┼Ş BAHARAT GIDA MAD. LTD.┼ŞT─░.	38.39338940	27.07799320	2
16135	12	D2H186342	NURCAN AYDIN	38.39474310	27.06075780	2
16136	12	020053442	O─ŞUZ RAHAT	38.39542000	27.06740800	2
16137	12	020054217	├ûZBOY GIDA SANS OYUNLARI TURIZM INSAAT TAAHH├£T SANAYI VE TICARET LIMIT	38.39386750	27.05198200	2
16138	12	020053972	├ûZG├ûK GIDA INSAAT OTOMOTIV SANAYI VE TICARET LIMITED SIRKETI - BAYKU┼Ş	38.39612400	27.07341800	2
16139	12	020050874	PER─░HAN D─░N├ç	38.38027820	27.05628990	2
16140	12	D2H158968	RAH┼ŞAN KARAKURT	38.38884820	27.07634300	2
16141	12	D2H148528	RA┼Ş─░T ├çET─░N	38.38838880	27.07872060	2
16142	12	D2H195481	SEDAT DA┼ŞLI	38.38570890	27.05449970	2
16143	12	020004536	SEDAT G├£NG├ûRD├£	38.39521700	27.07469900	2
16144	12	020052144	SERHAT K├£├ç├£KALP	38.38662100	27.05188900	2
16145	12	D2H078105	SEV─░N├ç ┼ŞA─ŞBAN	38.39196900	27.07253300	2
16146	12	D2H183665	S─░DAR KAYA	38.39540680	27.07264850	2
16147	12	020004461	SOLMAZ ANGIN	38.39408900	27.06964100	2
16148	12	020058166	SUPER SANSLI SANS OYUNLARI MARKET TURZ.INS.GIDA ITH.VE IHR.SAN.VE TIC.	38.39645820	27.07212620	2
16149	12	020052883	S├£LEYMAN ├çALI┼ŞKAN	38.37839400	27.05979000	2
16150	12	020046739	S├£REYYA MUNGAN	38.39630900	27.06906400	2
16151	12	020050873	┼Ş├£KRAN D─░N├ç-D─░N├ç MARKET	38.38171600	27.05685400	2
16152	12	D2H167193	┼Ş├£KR├£ KAAN ├çATAL	38.38570120	27.05855950	2
16153	12	D2H075265	TARIK ├ûZLEN─░R	38.39058700	27.07323000	2
16154	12	D2H148547	T├£LAY SEZERBU─ŞDAYCI	38.38541970	27.06020850	2
16155	12	020052401	U─ŞUR ERD─░├ç	38.39300990	27.05666650	2
16156	12	020053530	VEL─░T AKBA┼Ş	38.39630100	27.07258400	2
16157	12	020046198	YA┼ŞAR BED─░R	38.39558100	27.06879700	2
16158	12	D2K230976	YEN─░ EKONOM─░ GIDA SANAY─░ T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.38685800	27.05057900	2
16159	12	020014934	YUNUS EMRE K├£├ç├£K┼ŞALVARCI	38.39291100	27.05610400	2
16160	12	D2H120274	YUSUF ARUN	38.38629500	27.07870100	2
16161	12	D2H180571	YUSUF ├çALIKU┼ŞU	38.39210270	27.08143070	2
16162	12	020000638	YUSUF DEM─░R	38.38635300	27.07668800	2
16163	12	D2K221715	YUSUF TAYFUN TA┼ŞKIN	38.39406070	27.06556640	2
16164	12	D2H112722	Y├£KSEL AKBULUT	38.38890600	27.08106000	2
16165	12	020012672	Y├£KSELEN MARKET GIDA SAN.T─░C.LTD.┼ŞT─░.	38.38983500	27.08066800	2
16166	12	020051892	Z├£BEYDE AKAL─░N	38.39380040	27.07623140	2
16167	13	020058355	ABDULHAK─░M DEM─░R	38.41868400	27.13355600	2
16168	13	020003404	ABDULLAH S├ûNMEZ	38.42250960	27.13674080	2
16169	13	D2K205168	AK─░F TURGUT	38.42308230	27.13501450	2
16170	13	020008415	AKME┼ŞELER KAFETERYA B├£FE ─░┼ŞL.SAN.TUR.LTD.┼ŞT─░.	38.42343060	27.13770700	2
16171	13	D2H176721	AL─░ EFE S├ûKMEN	38.41800890	27.12928060	2
16172	13	020014756	AL─░ HAYDAR ├ûZBAY	38.42165590	27.14157600	2
16173	13	020017389	AL─░ KILI├ç B├£FE ─░┼ŞLETMES─░	38.41968100	27.13028400	2
16174	13	020046221	AL─░ YE┼Ş─░L	38.42145600	27.13266000	2
16175	13	020055222	ALPER YOLCU	38.42091150	27.13739550	2
16176	13	020012172	ALTAYO─ŞULLARI ┼ŞANS LTD.┼ŞT─░.	38.41717300	27.13176100	2
16177	13	020053992	ALTU─Ş S─░LAY	38.42462490	27.14835700	2
16178	13	020009052	ANFAR GIDA ┼ŞANS OYUN. T─░C. VE SAN. LTD. ┼ŞT─░.	38.42327560	27.14303030	2
16179	13	D2H154946	ASKER ├ûZ─░STER	38.42551570	27.13512830	2
16180	13	020053370	AY┼ŞE DE─Ş─░RMENC─░O─ŞLU	38.42144300	27.13512700	2
16181	13	020058548	BAHT─░YAR DEM─░RC─░	38.41968220	27.13204400	2
16182	13	D2H172785	BAK─░YE YILDIRIM	38.42689300	27.15074800	2
16183	13	D2K230328	BARREL TUR─░ZM GIDA VE ─░N┼ŞAAT L─░M─░TED ┼Ş─░RKET─░	38.42789620	27.15151630	2
16184	13	020002895	BA┼ŞAKCILAR B├£FE	38.42431850	27.13365560	2
16185	13	020014851	BAYMAR LOK.TAB.GIDA ┼ŞARK.├£R.PAZ.SAN.T─░C.LTD.┼ŞT─░.	38.42395360	27.14766690	2
16186	13	020050728	BE┼ŞER G├ûK	38.42254500	27.13214500	2
16187	13	020058307	B├£LENT ASLAN	38.41495400	27.12997500	2
16188	13	020003601	CEMDAG GIDA INS.TUR.NAK.SAN.VE TIC.LTD.STI. - CEMDA─Ş GIDA	38.41643550	27.13034720	2
16189	13	D2H158708	├ç─░─ŞDEM G├£VEN	38.42059830	27.12982920	2
16190	13	D2H146262	DEMET KISA	38.41965400	27.13381100	2
16191	13	D2H111152	DERYA DO─ŞRUOL	38.42197700	27.13965300	2
16192	13	020006110	D─░LEK ├ç─░MEN	38.41964920	27.13162550	2
16193	13	D2K242073	DOSK─░ TUR─░ZM ─░N┼ŞAAT EMLAK GIDA KIRTAS─░YE OTO ALIM SATIM SANAY─░ VE T─░CA	42.94838100	34.13287400	2
16194	13	020013433	DTS TUR─░ZM GIDA T─░C.LTD.┼ŞT─░.	38.42642180	27.13616140	2
16195	13	D2H148939	D├£ZG├£N VURAL	38.42638350	27.13843230	2
16196	13	020009976	EBRU TOPRAK	38.42331100	27.14321400	2
16197	13	D2K204453	ED─░Z TOP├çU	38.42588070	27.13761430	2
16198	13	020049234	EE─░ TUR─░ZM GIDA SAAT T─░C. SAN.LTD.┼ŞT─░.	38.42218300	27.12961100	2
16199	13	020002283	EFOR GIDA UNLU MAM├£LLER─░ SAN. T─░C.LTD.┼ŞT─░.	38.42622140	27.13538530	2
16200	13	D2H197961	EGE TOBACCO T├£T├£N MAMULLER─░ SANAY─░ VE T─░CARET LTD.┼ŞT─░.	38.42335180	27.14341200	2
16201	13	020017553	EL─░F ├çAMLICA	38.41879710	27.13382630	2
16202	13	020006500	EM─░NE TATAR	38.42326070	27.14154350	2
16203	13	D2H147940	EMRAH ACAT	38.42248900	27.14192700	2
16204	13	020014721	ENDER ├ûNER	38.42207510	27.14073770	2
16205	13	020052770	ENG─░N I┼ŞIKADALI	38.41830980	27.13030570	2
16206	13	D2K207981	ERDAL ARPA├ç YAPI OTOM.GIDA VE TARIM ├£R├£NLER─░ PAZ.SAN.T─░C.LTD.┼ŞT─░.	38.42531100	27.13693810	2
16207	13	D2H167820	ESRA S├ûYLEMEZ	38.41824610	27.13185670	2
16208	13	020014647	EYLEM GIDA ├£R├£NLER─░ TURZ.VE T─░C.LTD.┼ŞT─░.	38.42272800	27.14380300	2
16209	13	D2K202414	FARUK ERTU─ŞRUL ARVAS	38.42153220	27.13251280	2
16210	13	D2K241319	FECR─░ ├ûZDEM─░R	38.42152740	27.13409670	2
16211	13	020002291	FERHAT HAYIRLI	38.41716270	27.13094910	2
16212	13	020045805	F─░LETO TRZ.LTD.┼ŞT─░.	38.41886000	27.12550400	2
16213	13	020056470	FUAT ARTAN	38.42542700	27.14950900	2
16214	13	020050320	G├ûKHAN G├ûKY├£Z├£	38.42225950	27.14405450	2
16215	13	020014811	G├ûLLERL─░ ┼ŞARK├£TER─░ GIDA ─░N┼Ş.SAN. VE T─░C.LTD.┼ŞT─░.	38.42421900	27.13864800	2
16216	13	D2K211496	HAKKIM ─░N┼Ş.TUR─░ZM GIDA LTD.┼ŞT─░.	38.42238300	27.13500850	2
16217	13	020058027	HAL─░M DENER	38.42254590	27.14256040	2
16218	13	020045963	HAL─░ME YEL	38.42772800	27.14978700	2
16219	13	020003652	HAT─░CE ├ç─░FT├ç─░-B├£FE	38.42262050	27.13326530	2
16220	13	D2K226679	H─░KMET YILMAZ	38.41641730	27.12778340	2
16221	13	D2H179483	H├£SEY─░N DEM─░R	38.42565000	27.15062470	2
16222	13	D2H146552	INCI LIFE GIDA TURIZM INSAAT SANAYI VE TICARET LIMITED SIRKETI - ─░NC─░	38.41911000	27.13405500	2
16223	13	020052301	─░NAN KURTULDU	38.42461000	27.13938200	2
16224	13	020012376	─░STANBUL LAST─░K T─░C.SAN.LTD.┼ŞT─░.	38.42358200	27.14656460	2
16225	13	020053528	KENAN ALPTEK─░N	38.42518500	27.14980800	2
16226	13	020050966	LEVENT KURUKOL	38.41919200	27.13227400	2
16227	13	020049874	MEHMET DUMAN	38.41989700	27.13479800	2
16228	13	D2K210859	MEHMET FEDAY─░ AKTA┼Ş	38.42085300	27.13705500	2
16229	13	020051896	MEHMET G├£VEN	38.42403270	27.14214480	2
16230	13	020005293	MEHMET SAMALAR	38.41750800	27.13331200	2
16231	13	020047252	MEHMET TURGAY KURUYEMIS GIDA TEKSTIL INSAAT TAAH. ELEKTRONIK SAN VE TI	38.41910900	27.13446200	2
16232	13	020007531	MEHMET ZEK─░ UNLU MAM. SAN.T─░C.LTD.┼ŞT─░.	38.42197850	27.14352180	2
16233	13	020058508	MESUT ERGEN	38.42140240	27.13597640	2
16234	13	D2H146429	MET─░N G├ûKSU	38.42317160	27.14170680	2
16235	13	D2K207054	MUHAMMED ENES A├çMA	38.42502700	27.13488100	2
16236	13	020053875	MUHAMMED MUSTAFA ├£NL├£	38.42183700	27.13523700	2
16237	13	020053509	MUHAMMET MUSTAFA TOM - G├£NE┼Ş TEKEL BAY─░	38.42377200	27.14360400	2
16238	13	D2H186165	MUHARREM BEKMEZC─░	38.42477600	27.13548300	2
16239	13	D2K202103	MURAT BENZERL─░	38.42916900	27.15313600	2
16240	13	D2K219071	MURAT ├çAYGER	38.42166280	27.13227340	2
16241	13	020052913	MURAT KO├ç ┼ŞANS OYUNLARI GIDA ─░N┼ŞAAT TURZSAN VE T─░C LTD ┼ŞT─░.	38.42229900	27.13737800	2
16242	13	020017508	MUSTAFA AKBULUT	38.42053600	27.13344200	2
16243	13	020017354	NAD─░  S├ûNMEZTEK─░N  BAKKAL	38.42878350	27.15139620	2
16244	13	020017488	NUR─░ ERDEN ├ûZEK -KUYUMCULAR TEKEL BAY─░─░	38.42083860	27.13615880	2
16245	13	D2K201940	OKTAY BAYRAM	38.42091900	27.13084900	2
16246	13	020055534	PINAR T├£T├£N SANS OYUNLARI GIDA INSAAT SANAYI VE TICARET LIMITED SIRKET	38.42262640	27.13935710	2
16247	13	020017539	PRESTIJ SANS OYUNLARI VE GIDA SANAYI TICARET LIMITED SIRKETI - ─░DDAA,S	38.42509200	27.13335010	2
16248	13	020014806	RAMAZAN AV┼ŞAR	38.42560630	27.14023460	2
16249	13	D2K230923	RAZ─░YE ─░LCAN	38.41990700	27.13437800	2
16250	13	D2H164605	RECEP KINALI	38.42829500	27.14989000	2
16251	13	020014663	SAVCI GAZ. DA─Ş. VE PAZ. T─░C. LTD. ┼ŞT─░.	38.42207050	27.14331910	2
16252	13	020000718	SELAHATT─░N ESER	38.42010500	27.13022100	2
16253	13	020053848	SERKAN B─░LAL	38.42616130	27.14991880	2
16254	13	D2H191350	SEVAL BULGURCU	38.42281600	27.13290800	2
16255	13	020054165	SEYF─░ ARTUT	38.42784400	27.15161100	2
16256	13	020052321	S─░MYA KANT─░N KAFETERYA OTOPARK ─░┼ŞL. TAM.H─░Z.T─░C.LTD.┼ŞT─░.	38.42729710	27.13926950	2
16257	13	020057737	SKY OTOMOTIV SANS OYUNLARI GIDA INSAAT TURIZM SANAYI VE TICARET LIMITE	38.42346420	27.13952640	2
16258	13	D2H160104	┼ŞEHMUS DURAN	38.41671090	27.12832960	2
16259	13	D2K228773	┼ŞER─░F DAMAR	38.42168640	27.13473330	2
16260	13	020051420	┼ŞEYHMUS SUNAR	38.42511900	27.13433900	2
16261	13	020058421	┼Ş├£KR├£ KUMRAL	38.41949200	27.13501700	2
16262	13	D2K238989	TU─Ş├çE TEK─░N	38.42323120	27.14165010	2
16263	13	D2H146553	TURGUT KARATA┼Ş	38.42558220	27.14747820	2
16264	13	020047237	T├£LAY KILIN├ç	38.42448350	27.13906850	2
16265	13	020002673	ULUYOL GIDA MARKET├ç─░L─░K LTD.┼ŞT─░.	38.41682000	27.12919800	2
16266	13	020057378	UMUT AYDIN REST.KAFE B├£FE ─░┼ŞL.─░N┼Ş.NAK.SAN VE T─░C LTD:┼ŞT─░	38.41882400	27.12583200	2
16267	13	020013037	VEDAT ├ûZMUTAF-G├£L GIDA	38.41559560	27.13005120	2
16268	13	020046773	VEL─░T BABAY─░─Ş─░T	38.42751480	27.14933240	2
16269	13	020014830	VEL─░T BABAY─░─Ş─░T - MANAV / BAKKAL	38.42947020	27.15051130	2
16270	13	020017568	YAS─░N AYKUT UZAY	38.42805100	27.15078300	2
16271	13	D2K202832	YA┼ŞAR ├çEL─░K -TURKUAZ B├£FE	38.42049000	27.13662800	2
16272	13	D2H161034	YUNUS ─░┼ŞCANER	38.42981200	27.15454210	2
16273	13	020048129	Z├£BEYRE EROL	38.42517560	27.14032540	2
16274	10	D2H155970	AHMET ETL─░LER	38.42321400	27.16839200	2
16275	10	D2H170893	AHMET ├ûZY├ûR├£K	38.41886480	27.15794020	2
16276	10	020006093	AKINLAR T─░C.LTD.┼ŞT─░. - B.P.─░STASYONU	38.42211370	27.15160580	2
16277	10	D2K241244	AL─░ BAYRAKDAR	38.41961880	27.16730860	2
16278	10	020050018	ARZU  ERGEZG─░N	38.42038600	27.16425300	2
16279	10	D2H108477	ATARLAR PETROL  ( ├çINARLI )	38.43808400	27.17023600	2
16280	10	D2K237174	AYAR GIDA TUR─░ZM B─░L─░┼Ş─░M TEKST─░L ─░N┼ŞAAT SANAY─░ VE T─░CARET L─░M─░TET ┼Ş─░RK	42.94838100	34.13287400	2
16281	10	D2H165506	AYDIN AKME┼ŞE	38.42575880	27.17083400	2
16282	10	D2H161201	AYHAN HONCA	38.41955470	27.17090720	2
16283	10	020004969	AYNUR ├çO┼ŞKUN- BAKKAL	38.41541500	27.16921100	2
16284	10	D2K199400	AY┼ŞE EKSEN	38.43148350	27.17499720	2
16285	10	D2K236455	AYTU KOZMET─░K OTOMOT─░V ─░LET─░┼Ş─░M SAN. VE T─░C.LTD.┼ŞT─░.	38.42238700	27.14993400	2
16286	10	020006716	AZER─░ GIDA TARIM TUR. ├£R├£N SAN. T─░C. LTD. ┼ŞT─░.	38.42925000	27.16652300	2
16287	10	020055223	BALGASUN TURIZM GIDA AMBALAJ ITH.IHR.PAZ.SAN.TIC.LTD.STI. - BALGASUN T	38.43724600	27.17673500	2
16288	10	020001464	BATINAK TRANS─░T TA┼Ş.PET.VE SAN T─░C.LTD.┼ŞT─░.	38.43283700	27.17006700	2
16289	10	D2K241021	BAYRAM ├ûZER	38.42762010	27.17101640	2
16290	10	020049016	BEH├çET G├£RE	38.42930960	27.18170190	2
16291	10	D2K225250	BENG├£L BOZKURT	38.44737100	27.17864480	2
16292	10	D2K234574	B─░NNAZ KARACA	42.94838100	34.13287400	2
16293	10	D2H184955	B─░RG├£L B─░LGE├ç	38.41347240	27.15769750	2
16294	10	020004887	B├£LENT ├ûZLEM	38.43088600	27.17772000	2
16295	10	D2K068802	B├£NYAM─░N S├£MB├£L	38.41615300	27.16787180	2
16296	10	D2K203980	CENTER VEGA TUR─░ZM GIDA SAN.T─░C.LTD.┼ŞT─░.	38.43344700	27.16145900	2
16297	10	D2H167947	C─░HAN ULU├ç	38.42168910	27.15456270	2
16298	10	D2K134199	├çA─ŞLAYAN ANADOLU	38.41679010	27.16904710	2
16299	10	020056041	DAMLA AKARYAKIT OTOMOTIV VE YED.PAR├ç. SAN.TIC.LTD.STI.	38.44619040	27.17400670	2
16300	10	D2K228752	DUYGU KARA	38.42389980	27.15754730	2
16301	10	D2K242583	EFE ─░RDEN	42.94838100	34.13287400	2
16302	10	D2K208258	EFSANE TEKEL GIDA. ─░N┼Ş.T─░C.LTD. ┼ŞT─░.	38.42246240	27.14646470	2
16303	10	D2H161617	EGE YUNUS GIDA TEM─░ZL─░K KOZMAT─░K SAN.VE T─░C.LTD.┼ŞT─░.	\N	\N	2
16304	10	D2H186275	EM─░N DEM─░R	38.43038410	27.16896290	2
16305	10	020000589	EM─░NE ├ûZCAN	38.41569150	27.16472800	2
16306	10	020045263	EM─░RCANLAR PETROL ─░N┼Ş. GIDA TUR. SAN. T─░	38.43767300	27.16843800	2
16307	10	020048240	ENG─░N G├£LER	38.41668400	27.17174000	2
16308	10	D2H195330	ENG─░N TEK─░N	38.42249200	27.14554100	2
16309	10	020002527	ERDA─ŞILAR GIDA ─░N┼ŞAAT ELEKTR─░K ELEKTRON─░K PAZ. SAN. VE T─░C.LTD.┼ŞT─░.	38.42952450	27.16554610	2
16310	10	D2K234577	ERD─░N├ç ├ûZER	38.42648340	27.16389320	2
16311	10	020054046	ERTAN ─░LHAN	38.43139100	27.17613300	2
16312	10	D2K230512	FAHR─░YE TERLEMEZ	38.41701210	27.15992520	2
16313	10	020054958	FATMA ┼ŞAH─░N	38.42872900	27.16584300	2
16314	10	D2H149346	FATMA ┼ŞUMLU	38.42209700	27.14851200	2
16315	10	020015542	FATMA T├£FEK├ç─░ -KARDE┼ŞLER BAKKAL─░YES─░	38.42153300	27.15534600	2
16316	10	D2H129961	FEDA─░ T├£RKO─ŞLU-2	38.41572040	27.16583900	2
16317	10	020050923	FELM─░YE DURAK	38.43802600	27.17573800	2
16318	10	D2K227451	FERRUH SE├çK─░N	38.42624600	27.16612700	2
16319	10	D2K233473	GLASS-N─░┼ŞMAR ─░├ç VE DI┼Ş T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.43476800	27.16268100	2
16320	10	020003403	G├ûK├çEN U─ŞU┼Ş	38.41362570	27.15999560	2
16321	10	020015513	G├ûKHAN KORKMAZ	\N	\N	2
16322	10	020001194	G├ûKHAN S├£MER	38.43730700	27.17450720	2
16323	10	D2H176987	G├ûKHAN UYSAL	38.42022230	27.17049650	2
16324	10	D2K213249	G├ûRKEM FIRAT	38.43775200	27.16961000	2
16325	10	020054016	G├£RAY YE─Ş─░NT├£RK	38.42228700	27.14478400	2
16326	10	D2K230608	HAMD─░ KANAT	38.42640510	27.16655300	2
16327	10	020001250	HASAN BEKTA┼Ş	38.42540870	27.18550650	2
16328	10	D2K068803	HASAN ├çALI┼ŞKAN	38.41714900	27.16845800	2
16329	10	020047772	HASAN KARAY	38.41452600	27.16430900	2
16330	10	020007111	HAT─░CE ALTAN	38.42761890	27.16720180	2
16331	10	020050720	HAT─░CE ├ûZB─░LGE-├ûZ├£M TEKEL	38.43891200	27.18049180	2
16332	10	020004322	HAT─░P Y├£ZER	38.42249200	27.14827090	2
16333	10	020015482	H├£SEY─░N ALTIER	38.42682600	27.16618980	2
16334	10	020008016	─░BRAH─░M YILMAZ	38.41883200	27.16670630	2
16335	10	D2K209797	─░SMA─░L ─░NAM	38.42831500	27.18041200	2
16336	10	D2K210035	─░SMET EGEMEN AYDIN II	38.43184730	27.16146070	2
16337	10	020011207	KADR─░ BA─ŞCI	38.41960500	27.17115800	2
16338	10	020050379	KASIM ADIG├£ZEL	38.41767400	27.16551200	2
16339	10	020050954	MASUM F─░DAN	38.42194570	27.15221150	2
16340	10	020054522	MEHMET EM─░N ORAK	38.42248300	27.14762800	2
16341	10	020050031	MEHMET G├£LHAN D─░ZMAN	38.42555560	27.15818590	2
16342	10	020051029	MEHMET ┼ŞAH KAYMAZ	38.42099600	27.14598800	2
16343	10	D2H191456	MEHMET ┼Ş─░R─░N AYDO─ŞDU	38.42303220	27.16288520	2
16344	10	D2K207980	MEHMET ├£ST├£NEL GIDA SAN. VE T─░C.LTD.┼ŞT─░.	38.43839510	27.17020760	2
16345	10	020048045	MEHMET YOLDA┼Ş	38.42210070	27.14398190	2
16346	10	D2H192502	MERS─░NL─░ AKARYAKIT SANAY─░ VE T─░CARET ANON─░M ┼Ş─░RKET─░	38.42940200	27.17998100	2
16347	10	D2K240759	MERT ORHAN	38.42232340	27.14770260	2
16348	10	020050685	MET─░N SERTO─ŞLU	38.43106290	27.17952370	2
16349	10	D2K232675	MTT GIDA LOJ─░ST─░K B─░LG─░SAYAR OTOMOT─░V HAYVANCILIK ─░N┼ŞAAT TEM─░ZL─░K SAN.	38.42831100	27.16271000	2
16350	10	D2H136803	MUHAMMET DUMLUPINAR	38.41820680	27.16191570	2
16351	10	020049477	MURAT TEOMETE	38.41452140	27.15761730	2
16352	10	D2K076095	MURAT YA┼Ş─░N	38.41401100	27.16262000	2
16353	10	020054117	MUSTAFA KARA	38.42516800	27.16833200	2
16354	10	020044504	M├£STEHL─░K GIDA VE ┼ŞARK├£TER─░ ├£R. SAN.T─░C.	38.42209000	27.15032900	2
16355	10	D2K216260	N─░MET CAN	38.42156130	27.16345570	2
16356	10	020052825	OKTAY EG─░N	38.42189700	27.15408760	2
16357	10	020001423	OKUTAN PETROL LTD. ┼ŞT─░. - PETROL OF─░S─░	38.42541520	27.18286850	2
16358	10	D2H109853	ONUR S.BAKIR UNLU MAM├£LLER GIDA MAD.PAZ.SAN. VE T─░C.LTD.┼ŞT─░.	38.42753200	27.16910700	2
16359	10	D2H183682	OYA HEPA─ŞARTAN	38.42516100	27.16099250	2
16360	10	D2H135947	├ûKY GIDA TEKST─░L ─░N┼ŞAAT OTOMOT─░V TEM.SAN T─░C.LTD.┼ŞT─░.	38.42431350	27.16727460	2
16361	10	020015751	├ûMER AKG├£N	38.42025150	27.16631820	2
16362	10	020054997	├ûMR├£YE ├ûZT├£RK	38.41852500	27.16653700	2
16363	10	020049757	├ûNCEL GIDA TUR.─░N┼Ş.SAN.T─░C.LTD.┼ŞT─░	\N	\N	2
16364	10	D2K219760	├ûZD─░L KAFE VE REST.─░┼ŞL.GIDA.SAN.T─░C.LTD.┼ŞT─░.	38.44727100	27.17426500	2
16365	10	D2H168556	RAH─░ME KARAO─ŞLAN	38.42045310	27.16810250	2
16366	10	D2H138958	RAMAZAN ULU├ç	38.42226470	27.15443410	2
16367	10	D2K210386	REMZ─░ B─░LG─░N	38.42859800	27.18007500	2
16368	10	D2K204737	SA─░T ASAR	38.42960080	27.17977090	2
16369	10	020047157	SAVA┼Ş BOZKURT	38.41693270	27.15914320	2
16370	10	D2H138417	SAVA┼Ş BOZKURT (┼ŞUBE)	38.42024690	27.15557760	2
16371	10	020006580	SEBAHATT─░N ├çAKIR	38.42559180	27.17378940	2
16372	10	D2H134074	SEDAT D─░N├çER	38.43249340	27.17966380	2
16373	10	020055725	SERHAN CELHAN	38.42484000	27.15633000	2
16374	10	020046052	SERKAN ALGIN - SAYGIN B├£FE	38.43116500	27.17960600	2
16375	10	D2K229969	SEVG─░ ├£NER	38.42692650	27.16358850	2
16376	10	020014676	SEY─░T AL─░ SIDAL	38.42237500	27.14705300	2
16377	10	020015445	SEY─░THAN ┼ŞAKAR	38.41818090	27.15905120	2
16378	10	020006249	┼ŞEREF CANDA┼Ş	38.43586300	27.16780600	2
16379	10	D2K202562	┼Ş─░H─░ TUMBUL	38.42733670	27.18067210	2
16380	10	020054278	TANER LAKA	38.43137700	27.17843800	2
16381	10	020001946	TANER TU├çGAN	38.43269500	27.18015200	2
16382	10	D2H178979	TANJU TA┼ŞAL	38.42293680	27.15642330	2
16383	10	D2K165135	TANKAR OTOMOT─░V PETROL GIDA TEKST─░L H─░ZMET ─░N┼ŞAAT SANAY─░ VE T─░CARET LT	38.42534400	27.18320200	2
16384	10	020001350	TOKAYLAR GIDA LTD.┼ŞT─░.	38.42322800	27.16068400	2
16385	10	D2H115749	UFUK ERGEN	38.42553200	27.17249100	2
16386	10	020015692	VAHDETT─░N KAYA BAKKAL	38.41637950	27.15770230	2
16387	10	020046486	YAMAN PETROL LTD.	38.43129900	27.18026600	2
16388	10	020014702	YA┼ŞAR G├ûNEN	38.42245800	27.14670300	2
16389	10	D2K218377	YAYLABEY ─░NCE	38.42901400	27.16371300	2
16390	10	D2K204457	Y─░─Ş─░T DEM─░RL─░	38.41674500	27.16922200	2
16391	10	020019107	YUSUF ONAY	38.43246100	27.17868700	2
16392	10	D2K215648	YUSUF POYRAZ	38.42203900	27.15399200	2
16393	10	020003973	YUSUF TA┼ŞYA─ŞAN GIDA LTD.┼ŞT─░.	38.41879600	27.15920000	2
16394	1	D2K135271	ABD├£LAZ─░Z Y├£KSEKDA─Ş	38.38488810	27.12493660	2
16395	1	020054801	ACEM GIDA ─░N┼Ş.TUR.SAN.T─░C.LTD.┼ŞT─░. - ├çi├ğekevler	38.39207900	27.09727300	2
16396	1	020054394	ADNAN AVRAN	38.39134800	27.11494190	2
16397	1	D2K164711	AHMET AY	38.38437910	27.12179440	2
16398	1	020009371	AHMET AYDIN	38.39019500	27.10719900	2
16399	1	D2K240750	AHMET HAKAN ALU├ç	38.38608080	27.12656390	2
16400	1	D2K206562	AKIN AY	38.39284900	27.09809800	2
16401	1	020010376	AKME┼ŞELER SANAY─░ T─░CARET LTD. ┼ŞT─░.	38.38982400	27.13442200	2
16402	1	D2K072941	AKME┼ŞELER TEKS. ─░N┼Ş.SAN. T─░C. LTD.┼ŞT─░.	38.38921400	27.13422600	2
16403	1	020048636	AKME┼ŞELER TEKST─░L TUR─░ZM GIDA ─░N┼Ş.SAN VE T─░C.LTD.┼ŞT─░.	38.38674060	27.13462620	2
16404	1	D2K223634	AL─░ AKSOY	38.39028410	27.12031470	2
16405	1	D2K100288	AL─░ DEN─░Z	38.39173900	27.11898500	2
16406	1	D2K205545	AL─░ G─░R─░┼ŞKEN	38.38617980	27.12304350	2
16407	1	020050457	AL─░ G├£NG├ûRMEZ	38.38783610	27.11245450	2
16408	1	D2K134554	AL─░ ┼ŞE┼ŞEN	38.39567800	27.10508100	2
16409	1	020000030	ARZU UCA	38.39105500	27.12546400	2
16410	1	020001521	AS─░L G├£VEN	38.38618260	27.13194420	2
16411	1	020002314	AVCI MARKET├çILIK GIDA TURIZM HAYVANCILIK INS.SAN.VETIC.AS	38.39159700	27.11892600	2
16412	1	020052271	AVCI MARKET├çILIK GIDA TURIZM HAYVANCILIK INS.SAN.VETIC.AS	38.39430000	27.10280000	2
16413	1	D2K226333	AYSER B─░TG─░N	38.38489200	27.11445600	2
16414	1	020052608	AY┼ŞE ERTEM	38.39209600	27.11978500	2
16415	1	020019002	AY┼ŞE KURT	38.38688800	27.11225400	2
16416	1	D2K196898	BAHAR ZENG─░N	38.39013600	27.12900000	2
16417	1	D2K140252	BA┼ŞDA┼Ş MARKET - AKEVLER	38.39419100	27.10532530	2
16418	1	D2K186011	CENG─░Z ├ûZT├£RK	38.39578190	27.12204690	2
16419	1	020054122	CEYLAN ├çET─░N - DEN─░Z GROSSMARKET	38.39286300	27.12745900	2
16420	1	D2K225989	C─░VAN AKME┼ŞE	38.38773540	27.13085690	2
16421	1	D2K119748	D─░LBER ├çALI┼ŞKAN	38.39206620	27.12153120	2
16422	1	D2K139320	EDA DO─ŞAN	38.38675840	27.10280090	2
16423	1	D2K117714	ED─░P DALMI┼Ş	38.39500530	27.13092980	2
16424	1	D2K234896	EKREM TEK─░N	38.38998130	27.12561270	2
16425	1	D2K197353	EL─░F KAYA	38.38823400	27.12479100	2
16426	1	020047991	EMRE TUNCA	38.39071300	27.13221410	2
16427	1	020017045	ENG─░N SOYDAN	38.39531700	27.12699200	2
16428	1	D2K148321	ENG─░N TURHAN	38.38564300	27.11587900	2
16429	1	D2K204755	EREN TANRIVERD─░	38.38758400	27.11058900	2
16430	1	D2K087561	FATMA DEM─░R - DEM─░R MARKET	38.38856800	27.12119100	2
16431	1	D2K202489	G├ûKHAN YAVUZ	38.38858500	27.12860000	2
16432	1	D2K159569	G├£L├ç─░N YILMAZ	38.38586370	27.12788940	2
16433	1	D2K242331	G├£LNAR─░N SATIK	42.94838100	34.13287400	2
16434	1	020008633	G├£RSEL MENEN	38.39371600	27.13093400	2
16435	1	D2H142412	HACI H├£SEY─░N ER┼ŞAN	38.39495300	27.10082500	2
16436	1	D2K242461	HAKAN D─░N├ç	42.94838100	34.13287400	2
16437	1	020052101	HAKAN YEN─░YURT	38.38929600	27.11914300	2
16438	1	D2K178192	HAL─░ME TA┼Ş	38.38879470	27.12264670	2
16439	1	020050405	HALUK G├£L├£MSER - EGE MARKET	38.38561700	27.11504500	2
16440	1	D2K211662	HAMDULLAH TA┼Ş	38.39229600	27.12554000	2
16441	1	D2K227058	HUR─░YE KURT	38.39173700	27.11010460	2
16442	1	D2K223927	H├£SEY─░N ├ûZBA┼ŞLI	38.38772220	27.11608430	2
16443	1	D2K164696	H├£SEY─░N TOSUN	38.39343080	27.12564470	2
16444	1	020052822	─░BRAH─░M KARAKA┼Ş	38.39776760	27.13026620	2
16445	1	D2K236726	─░BRAH─░M TURGUT	38.39033720	27.09884220	2
16446	1	020005577	─░LYAS ┼ŞEND├ûL	38.39300600	27.10302800	2
16447	1	D2K197267	─░RFAN─░ KAYA	38.38883220	27.11029050	2
16448	1	020013628	─░SMA─░L AYDIN GIDA SAN. VE T─░C. LTD. ┼ŞT─░.	38.39098800	27.12415200	2
16449	1	020006908	─░ZM─░R KAL-PET PETROL ─░N┼ŞAAT TUR─░ZM VE GI	38.38620000	27.13430000	2
16450	1	D2K174322	KADR─░YE YILDIRIM	38.38959410	27.12067390	2
16451	1	D2H161586	KAMER KEND─░RL─░K	38.39623940	27.09989510	2
16452	1	020053930	KAN─░ ATALAY	38.38821800	27.12948500	2
16453	1	020054164	KUDRET YILMAZ	38.39720890	27.12394650	2
16454	1	D2K160318	MED─░NE CANBAZ	38.39473900	27.12488700	2
16455	1	D2K196151	MEHMET BAYLAN	38.38586410	27.13027670	2
16456	1	020004008	MEHMET EM─░N KO├çY─░─Ş─░T	38.38419900	27.12361800	2
16457	1	D2K239716	MEHMET SA─░T ─░LDEM	38.39590160	27.12716160	2
16458	1	D2K094540	MEL─░KE KALBURCU	38.39144500	27.13129000	2
16459	1	D2K209024	MERYEM AYDIN	38.38640050	27.11472990	2
16460	1	D2K098534	M─░NE SER─░N	38.39443400	27.12935500	2
16461	1	D2K193968	MUHAMMED G├£├çL├£	38.39229070	27.11740810	2
16462	1	D2K102814	MUSTAFA ├çAPANO─ŞLU	38.38799000	27.12723200	2
16463	1	D2K066757	MUSTAFA YA─ŞLICIO─ŞLU	38.39631300	27.12728100	2
16464	1	020011462	MUSTAFA YERL─░	38.38919040	27.12992810	2
16465	1	D2K176640	N─░YAZ─░ TOP	38.39440800	27.12106700	2
16466	1	D2K239531	NUR─░ G├£NENER	42.94838100	34.13287400	2
16467	1	D2K136848	O─ŞUZ YILMAZ	38.39060520	27.10727910	2
16468	1	020013077	ORHAN K├ûRO─ŞLU	38.39103500	27.11177800	2
16469	1	020048085	├ûNDER ┼ŞEN├çAMLAR TEKEL BAY─░	38.38922600	27.11863200	2
16470	1	D2K229706	├ûZDENLER TUR─░ZM TOPTAN ALKOL GIDA SANAY─░ VE T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.38964490	27.11379630	2
16471	1	D2K229876	├ûZG├£VENLER ─░├ç VE DI┼Ş T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.38866920	27.11864520	2
16472	1	D2K242477	PER─░HAN ERKO├ç	38.39600170	27.09912730	2
16473	1	D2K233861	PETROL OF─░S─░ A.┼Ş  (BOZKAYA - M068 )	38.39822600	27.12931600	2
16474	1	020044097	R.F.S. GIDA PAZ. ─░N┼Ş. LTD. ┼ŞT─░.	38.39079700	27.11471000	2
16475	1	D2K242707	REVA SO─ŞANLI	38.38784090	27.10865030	2
16476	1	D2K142071	RIZA YA┼ŞAR	38.38529010	27.12933400	2
16477	1	D2K211663	SA─░TO─ŞULLARI MARKET├ç─░L─░K GIDA LTD.┼ŞT─░.	38.38948400	27.11989700	2
16478	1	020047011	SEDAT ├£M─░T	38.39528100	27.13204400	2
16479	1	D2K136198	SELAHATT─░N ├ç─░├çEK	38.39274000	27.13040400	2
16480	1	020052460	SERDAR AKBALIK	38.38877200	27.11332400	2
16481	1	D2K145150	SEV─░M KURAL	38.38653280	27.11954370	2
16482	1	D2K224611	S─░BEL ├ûZMEN	38.38565720	27.11406170	2
16483	1	D2H163836	SUAT SARIHAN	38.39461940	27.10092630	2
16484	1	D2K087388	S├£LEYMAN KILIN├ç - KILIN├ç MARKET	38.39105900	27.12540000	2
16485	1	020002957	┼ŞAHABEDD─░N TOPRAK	38.39337900	27.10171000	2
16486	1	020004580	┼ŞAH─░N AYDIN - ROZA MARKET	38.39166010	27.10709620	2
16487	1	D2K205198	┼ŞAK─░R SERTER	38.39219500	27.12980900	2
16488	1	D2K140191	┼ŞEHMUS TA┼ŞAN	38.39412560	27.12909360	2
16489	1	D2K124936	TALAT AYTAR	38.39658740	27.12286340	2
16490	1	020001043	TANKAR OTOMOT─░V PETROL GIDA H─░Z.SAN.T─░C.LTD.┼ŞT─░.	38.38780000	27.13420000	2
16491	1	D2K236041	TOPRAKLAR GRUP GIDA VE PAZ. LTD. ┼ŞT─░.	38.38803150	27.12966320	2
16492	1	020048244	TU─ŞRUL DUYAR-BAKKAL	38.39036800	27.12719300	2
16493	1	D2K157834	TURGUT TA┼Ş	38.39401100	27.12424000	2
16494	1	D2K177202	├£M─░T DO─ŞAN	38.39629870	27.12719070	2
16495	1	D2K114645	├£NZ├£LE PAMUK	38.38980050	27.12127660	2
16496	1	D2K203475	VAH─░T KORKMAZ	38.39037200	27.12868000	2
16497	1	D2K220793	YALVA├çLAR MADENC─░L─░K LOJ─░ST─░K PETROLC├£L├£K ─░N┼Ş. A┼Ş.	38.39683860	27.13101270	2
16498	1	020010663	YAS─░N ASLANKAYA	38.38944200	27.11596500	2
16499	1	020008510	YA┼ŞAR YA─ŞMUR	38.39240500	27.10426100	2
16500	1	020002320	YUNUS SAKA- SAKANLAR GIDA	38.38778980	27.12316600	2
16501	1	D2K240145	YUSUF ALKI┼Ş	38.39142870	27.12089250	2
16502	1	D2K201531	YUSUF CAN CEPE	38.39172500	27.11157300	2
16503	1	D2K221289	YUSUF ULUS	38.38678380	27.12855350	2
16504	1	020001146	Y├£KSEL T├£MER	38.39680900	27.12734100	2
16505	1	020054140	ZEHRA KISACIK	38.39380400	27.09971300	2
16506	1	D2K113614	ZEK─░ AKAR	38.38785740	27.12160600	2
16507	11	020054196	9 EYL├£L SANS OYUNLARI GIDA INSAAT OTOMOTIV TURIZM SANAYI TICARET LIMIT	38.38427000	27.18305400	2
16508	11	D2K191517	ABDULLAH KO├ç	38.39292400	27.19316970	2
16509	11	D2K157864	ACEM GIDA ─░N┼Ş.TUR.SAN.T─░C.LTD.┼ŞT─░. - BEGOS	38.39515500	27.20441300	2
16510	11	020048529	ACEM GIDA ─░N┼Ş.TUR.SAN.T─░C.LTD.┼ŞT─░. - Mevlana	38.39245900	27.18043100	2
16511	11	020045088	ACEM GIDA ─░N┼Ş.TUR.SAN.T─░C.LTD.┼ŞT─░. - Yedig├Âller	38.39915300	27.19172900	2
16512	11	020003799	AHMET ASLAN - ASLAN MARKET	38.39210000	27.17303100	2
16513	11	D2K214757	AHMET DURMU┼Ş	38.38539710	27.18492860	2
16514	11	D2K218818	AHMET K─░TAP├çIO─ŞLU	38.39225200	27.18926880	2
16515	11	D2K109423	ANIL EYR─░CE	38.38570100	27.18354600	2
16516	11	020053919	AR─░F ├ûZ├çOBAN	38.38546900	27.17880400	2
16517	11	020048779	ARPA├ç YAPI ├£RET─░M TAAH.TUR.TEKS.LTD.┼ŞT─░.	38.38304600	27.18139100	2
16518	11	D2K233504	ASENA ERTEM	38.39438160	27.17517870	2
16519	11	D2K169928	AY┼ŞEG├£L C─░NG├ûZ	38.38801530	27.17961100	2
16520	11	D2K212879	AY┼ŞENUR T├£RKER	38.38512220	27.18751170	2
16521	11	020052503	BARI┼Ş MARKET BUCA TOK─░	38.39933800	27.20589400	2
16522	11	D2K168327	BEK─░R BEKTA┼Ş	38.39882620	27.17806860	2
16523	11	D2K227031	B─░LGEN AYDO─ŞAN	38.39526910	27.17723190	2
16524	11	D2K236937	B─░Z─░M ─░HRACAT VE ─░THALAT PAZARLAMA TEKST─░L GIDA ─░N┼ŞAAT TUR─░ZM ELEKTR─░K	38.39276080	27.17144650	2
16525	11	D2K196859	BUSE KAHR─░MAN	38.39909020	27.18237500	2
16526	11	020050649	B├£LENT APA	38.38951800	27.17624000	2
16527	11	020049623	CELAL K├ûK / D─░YAR TEKEL	38.38606700	27.19169200	2
16528	11	D2K209421	CEM─░LE Y─░─Ş─░T	38.38817830	27.17986610	2
16529	11	D2K163926	CEVAT ASLAN	38.39349400	27.17050800	2
16530	11	020045068	├çA─ŞLAYAN YAYLACIK	38.38722890	27.18158650	2
16531	11	020051292	DEKORAY ├çEL─░K KONSTR├£KS─░YON GIDA SAN VE T─░C LTD ┼ŞT─░	38.38415000	27.18452300	2
16532	11	D2K235231	DEKORAY ├çEL─░K KONSTR├£KS─░YON ─░N┼Ş.GIDA SAN.VE T─░C.LTD.┼ŞT─░. 2	42.94838100	34.13287400	2
16533	11	D2K106706	DURSUN AL─░ KURKUT	38.39721650	27.18666310	2
16534	11	D2K241217	DUYGU DEM─░R	42.94838100	34.13287400	2
16535	11	020052899	EMRAH DEN─░Z	38.39384160	27.17585360	2
16536	11	D2K205607	EMRAH M─░LL─░T├£RK	38.38412100	27.19000000	2
16537	11	020002143	ENG─░N DEM─░R - ├£├çLER GIDA	38.38913800	27.16851200	2
16538	11	D2K218901	ENSAR ┼ŞENG├£N	38.39355680	27.17036620	2
16539	11	D2K198345	ENVER ┼ŞENLETEN	38.39970260	27.19815860	2
16540	11	020018535	ERCAN YILDIRIMKANLI	38.39085900	27.18105200	2
16541	11	D2K203034	ERHAN G├£R	38.40183700	27.19337100	2
16542	11	D2K225921	ERSEN GEZER	38.39369970	27.17926310	2
16543	11	D2K083934	ESAT ORAL	38.39989300	27.19099500	2
16544	11	D2K218491	EVO TEKNOLOJ─░ G├£VENL─░K S─░STEMLER─░ B─░L─░┼Ş─░M ─░N┼Ş.MALZ.SAN. VE T─░C.LTD.┼ŞT─░	38.38406770	27.18795380	2
16545	11	D2K205170	FEVZ─░YE T─░KVE┼ŞL─░ -URAS TEKEL	38.38807500	27.17515100	2
16546	11	D2K223115	F─░DAN AYIK	38.39579510	27.19147690	2
16547	11	020002878	G├ûKMAR GIDA VE TEM. MAD. ─░N┼Ş.TUR.SAN. T─░C.LTD.┼ŞT─░.	38.39653900	27.17967900	2
16548	11	D2K177043	G├ûNEN MARKET KURUYEM─░┼Ş LTD.┼ŞT─░.	38.38791690	27.17449410	2
16549	11	D2K216261	G├£L├ç─░N YILMAZ	38.38888310	27.17723600	2
16550	11	D2K216385	G├£L─░STAN Y─░─Ş─░T	38.38524430	27.19115580	2
16551	11	020001567	G├£RCAN KAHRAMAN	38.38548000	27.17882200	2
16552	11	D2K198753	G├£RCAN KAHRAMAN (DE─Ş─░RMEN)	38.40278200	27.19871310	2
16553	11	020003872	HEYKEL B├£FE ┼ŞANS OYUNLARI GIDA T─░C.LTD. ┼ŞT─░	38.38816600	27.17369600	2
16554	11	D2K211463	H├£SEY─░N ASLAN	38.39051600	27.17496000	2
16555	11	020050716	H├£SEY─░N AYDO─ŞAN	38.39429000	27.17843000	2
16556	11	020044265	I┼ŞIKLI KARDE┼ŞLER GIDA TEM.MAD.PAZ.LTD.┼ŞT	38.38960000	27.17400000	2
16557	11	D2K133687	─░SMA─░L G├£M├£┼Ş	38.40584300	27.20285400	2
16558	11	D2K132362	─░SMA─░L TURAN	38.39668290	27.19175920	2
16559	11	020045405	KENAN G├ûRM├£┼Ş-BABACAN MARKET	38.39050000	27.17000000	2
16560	11	020018847	KON-MAR S├£PER DAY.T├£K.MAL.T─░C.PAZ.LTD.┼ŞT─░.	38.39757000	27.19615900	2
16561	11	020051095	LEYLA BARAN - ├ûzlem Market	38.38987300	27.18469100	2
16562	11	D2K146621	LEYLA BELEK	38.38711500	27.18382100	2
16563	11	D2K213251	L├£TF├£ AZAMLI	38.39727980	27.18849150	2
16564	11	020014344	MEHMET BOZDA─Ş GIDA - BOZDA─Ş ALI┼ŞVER─░┼Ş	38.38343300	27.18360100	2
16565	11	020049794	MEHMET F─░DAN	38.39953800	27.20585200	2
16566	11	D2K155730	MEHMET YAZICI	38.39259300	27.17352300	2
16567	11	D2K217335	MENAS CO┼ŞKUN	38.38653780	27.17120520	2
16568	11	D2K196345	MERT ├çET─░N	38.38195270	27.18880550	2
16569	11	D2K093201	MURAT BAKAY - TOPRAK AVM	38.39429530	27.17258760	2
16570	11	D2K133686	MUSTAFA AKDEN─░Z	38.39201600	27.17077200	2
16571	11	D2K132776	MUZAFFER BAHADIR MANSURO─ŞLU	38.39064020	27.18824910	2
16572	11	020055434	NAZ─░FE ├ûZDEM─░R	38.38286900	27.17250800	2
16573	11	D2K173728	N─░LG├£N USLU	38.38471950	27.18495150	2
16574	11	020054940	NURCAN DEM─░R	38.38317800	27.16793700	2
16575	11	D2K079031	NURHAN K─░REM─░T├ç─░LER	38.39613100	27.18644700	2
16576	11	D2K210159	OKAN KALE	38.39066740	27.18105910	2
16577	11	D2K238311	OSMAN KAZMA	38.38980610	27.18127600	2
16578	11	D2K201147	OZAN ULA┼Ş SAYMAN	38.40192410	27.19646290	2
16579	11	D2K197646	├ûMER KARAYILAN 1	38.38948700	27.16805800	2
16580	11	020000615	├ûYK├£MAR GIDA SAN T─░C.LTD.┼ŞT─░.	38.39430160	27.17868590	2
16581	11	D2K241600	├ûZER KAYNAK	42.94838100	34.13287400	2
16582	11	D2K149259	├ûZG├£R ├çAKIR	38.38511100	27.16962900	2
16583	11	D2K128045	├ûZKAN KESK├£N	38.38947970	27.18100370	2
16584	11	D2K088874	PAK─░ZE TUNA - OZAN GIDA	38.39464100	27.17527100	2
16585	11	D2K233305	PETROL OF─░S─░ A.┼Ş. ( BEGOS M065)	38.39479900	27.20381300	2
16586	11	D2K186122	RAMAZAN CO┼ŞACAK	38.38442920	27.18814870	2
16587	11	020050135	RAMAZAN ERAT	38.38220000	27.18650000	2
16588	11	D2K224101	RAMAZAN SERT	38.38104800	27.18316200	2
16589	11	D2K218490	RECEP SARI	38.38850900	27.16992380	2
16590	11	020018633	SALURLAR MARKET├ç─░L─░K GIDA VE ─░HT. MAD. T─░C.VE SAN.LTD.┼ŞT─░.	38.39575700	27.18553800	2
16591	11	D2K169708	SEDAT ERTEM	38.38172270	27.18717330	2
16592	11	020054119	SERKAN BALTA	38.38382600	27.17484400	2
16593	11	D2K096094	SEV─░M B─░LEN-HASTANE MARKET	38.38515200	27.16633400	2
16594	11	D2K218143	┼ŞAH─░N G├ûZG├£RMEZ	38.38490100	27.16965400	2
16595	11	020002711	┼ŞENT├£RK ULUDA┼ŞDEM─░R - CAN MARKET	38.38911500	27.18326600	2
16596	11	D2K230993	┼ŞEYMUS ├çEV─░REN	38.38411200	27.16807900	2
16597	11	D2K234906	TULU─ŞHAN G─░RAY AK├ûZDO─ŞAN	38.39397700	27.19339140	2
16598	11	D2K216639	TUTKU KAY─░M	38.38962000	27.17690400	2
16599	11	020001711	VES─░LE ├çEK─░├çC─░	38.38592500	27.17948500	2
16600	11	D2K139587	YAS─░N PEPEO─ŞLU	38.39224500	27.17029200	2
16601	11	D2K128805	YE┼Ş─░L EL─░T ELL─░├£├ç ALKOLL├£ VE ALKOLS├£Z ─░├çECEKLER TUR─░ZM ─░N┼ŞAAT SANAY─░ T	38.38202100	27.18214400	2
16602	11	020046096	YETK─░N KARAKA┼Ş - ─░REM TEKEL	38.39615400	27.17590300	2
16603	11	D2K070885	YUSUF DEM─░R	38.38926000	27.17668200	2
16604	11	020003047	ZAH─░DE ├ûZNUR DA─ŞLI	38.38495700	27.17342600	2
16605	17	D2K162301	ABDULHAM─░T F─░DAN	38.38109500	27.12450600	2
16606	17	D2K098624	ABDURREZZAK SIRTLAN	38.38220090	27.11591700	2
16607	17	D2K104827	AHMET AYDEM─░R	38.38025600	27.11525900	2
16608	17	020045041	AHMET BA─ŞCI	38.36958000	27.12572100	2
16609	17	020017057	AHMET B├£LB├£L MARKET	38.38096400	27.11308000	2
16610	17	D2K123422	AHMET ├ûZDEM─░R	38.37652690	27.12574830	2
16611	17	D2K093012	AL─░ YILMAZ - YILMAZ TEKEL	38.37617200	27.13100700	2
16612	17	D2K228964	ALP EREN ├ûZG├£N	38.38206660	27.12608450	2
16613	17	D2K218900	AT─░YE DURU┼Ş	38.37003120	27.12938540	2
16614	17	D2K240164	AVN─░ TOPALO─ŞLU	38.37190820	27.12879270	2
16615	17	020052632	AYKUT YILMAZ	38.37797450	27.13269540	2
16616	17	D2K207058	AY┼ŞE ANLAR	38.37074380	27.11199790	2
16617	17	D2K187087	AY┼ŞE G├£L G├£NG├ûR	38.37403900	27.12971400	2
16618	17	020002302	BARI┼Ş TERTEM─░Z GIDA VE GID.MAD.MOB.┼ŞANS OY.SAN.VE T─░C.LTD.┼ŞT─░.	38.38448420	27.13316280	2
16619	17	020054434	BARI┼Ş YILDIZ	38.38076700	27.11289400	2
16620	17	020050803	BAYRAM AY	38.37210200	27.11252100	2
16621	17	020054293	BEK─░R TEK─░N GIDA TARIM HAY. ─░N┼Ş. VE MALZ. TUR─░ZM SAN. T─░C. LTD. ┼ŞT─░.	38.37631700	27.12621500	2
16622	17	D2K214047	B─░LAL O─ŞUZ	38.38022790	27.11232720	2
16623	17	D2K207380	CEM FELEK	38.37763080	27.12182550	2
16624	17	D2K180544	CENG─░Z KILI├ç├çI	38.37560540	27.12591010	2
16625	17	020018878	├çA─ŞDA┼Ş T├£RK	38.37716200	27.12470800	2
16626	17	D2K239179	├çET─░N TO─ŞAN	38.38194620	27.13298870	2
16627	17	D2K201214	├ç─░─ŞDEM AY├çA ─░NCE	38.37324690	27.12960430	2
16628	17	D2K130583	DAVUT ARSLAN	38.37632800	27.12854500	2
16629	17	020046131	ERCAN BATO	38.37983200	27.12547700	2
16630	17	020052421	ERHAN YOKU┼Ş	38.37410000	27.12950000	2
16631	17	D2K073864	EROL CANBAZ	38.37775700	27.12686800	2
16632	17	D2K163538	ES TOKAYLAR GIDA SANAYI VE TICARET LIMITED ┼ŞIRKETI	38.38065840	27.11494950	2
16633	17	D2K197918	ESRA ─░PEK─░┼ŞEN	38.37156930	27.12976230	2
16634	17	020053924	FER─░YA BATTALO─ŞLU	38.37395500	27.13236800	2
16635	17	D2K089194	F├£S├£N YILMAZ	38.37473000	27.13051600	2
16636	17	020011554	GAL─░P BARIN	38.37495900	27.12895500	2
16637	17	D2K218815	G├ûKHAN TURAN	38.38086220	27.11291680	2
16638	17	D2K222147	G├ûRKEM S─░VAR─░	38.37474210	27.12811450	2
16639	17	D2K093466	G├£LE DENL─░ - ENG─░N MARKET	38.38150600	27.12754600	2
16640	17	D2K210301	G├£LS├£N ─░├çELL─░	38.37383090	27.13011500	2
16641	17	020050926	HACIAL─░ ALTUNDA─Ş	38.37835800	27.11856400	2
16642	17	020051567	HAKAN KARAD─░KEN	38.37972200	27.12832200	2
16643	17	D2K183597	HAL─░L AYDIN	38.37995100	27.11830800	2
16644	17	020007036	HAL─░T ARAS	38.37584300	27.12282000	2
16645	17	D2K226276	HASAN ACAY	38.37651500	27.13156800	2
16646	17	D2K238336	HASAN AKSOY	38.37468290	27.12979560	2
16647	17	020001586	HASAN H├£SEY─░NO─ŞLU	38.38190700	27.12240300	2
16648	17	D2K238515	H├£LYA D├£ZG├ûREN	38.37706920	27.11941840	2
16649	17	D2K079372	H├£SEY─░N DEM─░R	38.38418600	27.12983500	2
16650	17	D2K130595	H├£SEY─░N DEM─░R	38.37830360	27.13343600	2
16651	17	D2K112464	H├£SEY─░N ┼ŞENT├£RK	38.37924360	27.13103920	2
16652	17	D2K195259	─░BRAH─░M K─░RAZO─ŞLU	38.37855670	27.12769860	2
16653	17	D2K230042	─░HSAN TA┼Ş	38.37587510	27.12610760	2
16654	17	020004150	─░SHAK KUTLU	38.36973800	27.12680500	2
16655	17	D2K210567	─░SMA─░L G├£L	38.38201910	27.12607140	2
16656	17	020003649	─░SMA─░L UYANIK- BAKKAL─░YE	38.37462160	27.12164400	2
16657	17	020051299	KENAN ├çARDAK	38.38131300	27.11845800	2
16658	17	020005438	LAT─░FE BOZDO─ŞAN	38.38222600	27.11322600	2
16659	17	020008872	LEVENT BA─ŞARASI	38.38463800	27.13248900	2
16660	17	020050976	L├£TF─░ KANGAL	38.37938120	27.13370690	2
16661	17	D2K132778	MAHMOUD HALLAK	38.37939900	27.12944390	2
16662	17	D2K196393	MAV─░┼ŞE UYANIK	38.37612960	27.11978640	2
16663	17	D2K149103	MEHMET AKBALIK	38.38325350	27.12282290	2
16664	17	D2K242496	MEHMET AL─░ AVUT	42.94838100	34.13287400	2
16665	17	020011570	MEHMET AL─░ G├ûKPINAR	38.37032250	27.12962230	2
16666	17	D2K187186	MEHMET BOZKURT	38.37295060	27.11851480	2
16667	17	D2K163129	MEHMET DA┼Ş	38.36963800	27.12645700	2
16668	17	D2K235724	MEHMET KAMURAN ERY─░─Ş─░T	38.37587290	27.12076200	2
16669	17	D2K182544	MEHMET YILDIRIM	38.37620470	27.11367510	2
16670	17	D2K220082	MERYEM AK	38.38188830	27.13070000	2
16671	17	D2K145018	MET─░N AYTEK─░N	38.37958490	27.12539640	2
16672	17	D2K154346	MTYZ GIDA MARK.SAN.VE T─░C.LTD.┼ŞT─░.	38.37230670	27.13439850	2
16673	17	020052486	MURAT K├ûSE	38.37568520	27.11291950	2
16674	17	D2K135895	MURAT K├ûSEDA─Ş	38.37463060	27.12352320	2
16675	17	D2K227867	MURAT ZENG─░N	38.37463600	27.11799050	2
16676	17	020049492	NAG─░HAN ERO─ŞLU	38.38248600	27.12900400	2
16677	17	D2K212037	NERG─░Z KAYA	38.37915970	27.12674370	2
16678	17	020048896	N─░HAT TANRIKULU	38.37846600	27.11740400	2
16679	17	D2K216528	NUSRET BULUT	38.38048410	27.13143250	2
16680	17	D2K222620	O─ŞUZ ├çALI┼ŞKAN	38.38444420	27.12639420	2
16681	17	D2K225628	OKTAY AYGIN	38.37767370	27.13246140	2
16682	17	D2K234276	OSMAN TOSUN	38.37143650	27.11866090	2
16683	17	020010168	├ûZER ┼ŞANLIDERE	38.37331200	27.11633500	2
16684	17	D2K136638	├ûZG├£L KELE┼Ş	38.37961960	27.12250270	2
16685	17	020052446	├ûZLEM ┼ŞEN	38.38051400	27.12043100	2
16686	17	D2K191120	PERV─░N DEM─░RCAN	38.37142140	27.11157380	2
16687	17	020018799	PINAR KARDE┼ŞLER GIDA PAZ.TUR.─░N┼Ş.SAN.T─░C	38.37304700	27.11646100	2
16688	17	020051024	REMZ─░ DEM─░R	38.37372200	27.11994900	2
16689	17	D2K230646	REMZ─░ Y├£KSEL	38.37461320	27.12545610	2
16690	17	020052889	SADIK ├çAKIR	38.37663700	27.13470700	2
16691	17	020004609	SAL─░H ALP AYDIN- AYDIN GIDA PAZARI	38.37206200	27.11270900	2
16692	17	D2K229211	SAN─░YE KARAHAN	38.38076220	27.11632310	2
16693	17	020053805	SEDAT ├£M─░T	38.37930000	27.12380000	2
16694	17	D2K186156	SELV─░ G├£NG├ûR	38.38114960	27.13401860	2
16695	17	D2K205060	SEMRA ORU├ç	38.38316560	27.12782530	2
16696	17	D2K091455	SEN─░HA ASLAN - KENT TEKEL	38.37859970	27.12747970	2
16697	17	D2K145181	SERGEN ACAR	38.37675190	27.13157950	2
16698	17	D2K241375	SERHAT KAYA	38.37487720	27.12184070	2
16699	17	D2K130926	SERKAN KARABOZ	38.37479250	27.12760600	2
16700	17	D2K133456	SERKAN YILDIRIM	38.37994060	27.11167780	2
16701	17	020053208	S─░BEL AYTEK─░N	38.37267900	27.11339900	2
16702	17	D2K219129	SONG├£L AKG├£N	38.37625050	27.12829060	2
16703	17	020050488	SULTAN DEM─░RC─░	38.37570100	27.12559300	2
16704	17	D2K216439	S├£LEYMAN ├ûZKAN	38.37351980	27.13115880	2
16705	17	D2K209876	┼ŞAH─░N POLAT	38.38366270	27.11364110	2
16706	17	020003205	┼ŞER─░FE ├çEL─░K	38.38206100	27.12616100	2
16707	17	D2K087906	┼ŞEYHMUS ├çELEB─░ - ├çELEB─░ AVM	38.37796000	27.12079200	2
16708	17	D2K142069	UFUK CANKURT	38.38278750	27.13264570	2
16709	17	020052530	UMMAHAN DEM─░R	38.38244100	27.11924200	2
16710	17	D2K188148	├£NAL ERCAN GIDA ─░N┼ŞAAT OTOMOT─░V TUR─░ZM LTD.┼Ş─░T.	38.36973420	27.12711410	2
16711	17	020053175	├£NL├£O─ŞLU GIDA T─░C.LTD. ┼ŞT─░.	38.38320000	27.12840000	2
16712	17	D2K222918	VEHB─░ ATE┼Ş	38.37848680	27.12505770	2
16713	17	D2K129398	VEYS─░ ARSLAN	38.37582300	27.12755500	2
16714	17	D2K240420	V─░LDAN ALTUN	38.38487800	27.13047920	2
16715	17	D2K136043	YAS─░N BOZKURT	38.37456900	27.12660200	2
16716	17	020054139	YA┼ŞAR KILI├ç	38.38298300	27.11214600	2
16717	17	020051042	YILMAZ AKAN	38.37473500	27.13332200	2
16718	17	D2K208832	Y─░─Ş─░TCAN AYDEM─░R	38.38213720	27.11208740	2
16719	17	D2K207229	Y├£KSEL YAL─ŞI	38.37392890	27.12839480	2
16720	17	020049036	Y├£KSELEN YAPI MALZ.GIDA SAN.T─░C.LTD.┼ŞT─░.	38.37186000	27.12917400	2
16721	17	D2K237954	ZEREK PETROL ─░N┼ŞAAT TAAHH├£T SANAY─░ VE T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.37971820	27.11322270	2
16722	27	D2H173596	ACARO─ŞULLARI PETROL ├£R├£NLER─░ TUR─░ZM ┼ŞANS OYUNLARI E─ŞLENCE VE ─░N┼ŞAAT SA	38.31849100	26.33365400	2
16723	27	D2H155273	ADEM KARATEK─░R	38.31699100	26.33918400	2
16724	27	D26000452	AL─░ SAATL─░	38.29958230	26.37035960	2
16725	27	D2H135083	ALTINKUM GIDA TUR─░ZM T─░C.LTD.┼ŞT─░.	38.29082100	26.28153560	2
16726	27	D2H122103	ARZU OKTAY	38.35587500	26.31248500	2
16727	27	D2K236421	ATAKAN TABAK	38.30676310	26.36302460	2
16728	27	D2H034206	AYDIN KURT	38.29456000	26.38367800	2
16729	27	D2K224144	BARI┼Ş DO─ŞAN	38.30586220	26.36619130	2
16730	27	D2H191289	BAYIR OTOMOT─░V AKARYAKIT PETROL ─░N┼ŞAAT TUR─░ZM NAKL─░YE SANAY─░ VE T─░CARE	38.30190960	26.37002290	2
16731	27	D2K228928	BERKAN ALTINKAYA	38.32403360	26.30660100	2
16732	27	D2K207141	BUR├ç─░N KARAKET─░R	38.29905720	26.38291160	2
16733	27	D2K227875	BURHAN ├çET─░N	38.29322700	26.38324000	2
16734	27	D2H154101	CUMHUR AKYILDIZ-2	38.32050680	26.30431090	2
16735	27	D26000591	├çE┼ŞME ARAS PETROL LTD.┼ŞT─░	38.31206800	26.34511500	2
16736	27	D26000670	├çE┼ŞME GENCERLER  P─░L─░├ç TAR.HAY IN┼Ş.TUR.GID.SAN.TIC	38.32546200	26.30467000	2
16737	27	D2H169535	DAMLA KIRAN ├çARPAN	38.32598500	26.30731600	2
16738	27	D2H148715	DEN─░Z ORAL	38.31672480	26.30808620	2
16739	27	D2H174317	D─░LEK BALA-2	38.35578290	26.31296960	2
16740	27	020026743	D─░N├çER AKYOL	38.32281300	26.30817200	2
16741	27	D26000580	DO─ŞRULUK OTO AKARYAKIT T─░C.SAN.LTD.┼ŞT─░.II.	38.30190000	26.36950000	2
16742	27	020026671	DO─ŞRULUK OTO PETROL T─░C. LTD. ┼ŞT─░.	38.30330000	26.36550000	2
16743	27	D2H156261	D├£ZG├£N KARA	38.32172830	26.29775760	2
16744	27	D2K234963	EBRU DALAY	38.30583610	26.36639860	2
16745	27	D2H106936	EM─░N YA─ŞCI	38.32822100	26.31299100	2
16746	27	D2H010671	ERG├£L TOPRAKTEPE	38.32530000	26.30870000	2
16747	27	D2H151815	ERKAN ARLI	38.30769370	26.35924740	2
16748	27	D2H127540	ERKAN EL─░BUL	38.32652260	26.32224280	2
16749	27	D2H163335	EYLEM AYRILMAZ	38.32595530	26.30567900	2
16750	27	D2H060779	FA─░K ├çA─ŞLAYIK	38.32561800	26.32259200	2
16751	27	020026709	FERAY KARADA─ŞLI	38.32504000	26.30354500	2
16752	27	020026714	FIRAT MERT MARKET LTD,STI./FIRAT MERT MARKET	38.32570000	26.30841500	2
16753	27	D2H114423	FURKAN ├çAPKIN	38.35600620	26.31365790	2
16754	27	D2K242891	FURKAN R├£ZGAR	42.94838100	34.13287400	2
16755	27	D2H126855	G├ûKHAN D─░N├ç	38.30333410	26.36194630	2
16756	27	D2H190899	GULNARA CHEVIK	38.31887400	26.30240400	2
16757	27	D2H158965	G├£L┼ŞEN YILDIZ	38.33658700	26.30349100	2
16758	27	D2H187935	HAKAN KARATA┼Ş	38.30595010	26.36423550	2
16759	27	D2H161686	HALUK BOZO─ŞLU	38.35504300	26.30433180	2
16760	27	D26000912	HASAN CEVAH─░R	38.24033300	26.31379500	2
16761	27	020026646	HASAN PEKER/PEKER MARKET	38.32315300	26.30663300	2
16762	27	D2K217337	H├£LYA NAZLI	38.29274190	26.27690970	2
16763	27	D26000423	H├£SEY─░N BULUT	38.32460000	26.30670000	2
16764	27	D2K208045	H├£SEY─░N OKTAY	38.31522760	26.34708510	2
16765	27	D2H082223	H├£SEY─░N OLGUN	38.31567700	26.30567400	2
16766	27	D26000989	─░BRAH─░M DEM─░RTA┼Ş	38.28859600	26.31231200	2
16767	27	D2H120149	─░BRAH─░M HAL─░L AKAN	38.30626680	26.37369370	2
16768	27	D2K214914	─░LAYDA ├ûZBAYLAN	38.29108300	26.31192200	2
16769	27	D2H001891	─░RFAN ├çET─░NKAYA	38.31777800	26.30366800	2
16770	27	D2H148688	─░RFAN SERT	38.35680270	26.31175560	2
16771	27	D2K226888	KAD─░R KARAYILAN	38.29063250	26.28017540	2
16772	27	D2H121024	KADR─░ AKTA┼Ş	38.29427000	26.37492700	2
16773	27	D2H194800	KARAKET─░R GIDA TUR─░ZM SANAY─░ VE T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.30764700	26.36192700	2
16774	27	D2K213005	K├£BRA DEM─░R CO┼ŞKUN	38.29342100	26.27826200	2
16775	27	020026657	LEVENT HAL─░T BAYKAL	38.30598000	26.37346500	2
16776	27	020026752	MEHMET YAZICIO─ŞLU	38.31869870	26.34518080	2
16777	27	D2K201213	MELEK BOSTANCI	38.33205220	26.30454270	2
16778	27	D2H074817	MEL─░HA SABR─░ CANLAR	38.32576700	26.30701800	2
16779	27	D26000849	MUAMMER ├£NVER	38.32608700	26.32343000	2
16780	27	D2K204459	MURAT E┼ŞEN	38.35599440	26.31107100	2
16781	27	D26000619	MURAT S├£RER - MAV─░ AY MARKET	38.36653200	26.28669600	2
16782	27	D2H002217	MUSA KURT─░PEK	38.32222200	26.32322900	2
16783	27	D26000432	MUSTAFA BA┼ŞT├£RK	38.32750000	26.29910000	2
16784	27	D2K203833	MUSTAFA G├£ZEL	38.32594700	26.30139100	2
16785	27	D2H175411	NAZLI YILMAZ	38.33036790	26.30611960	2
16786	27	D2H062440	NECAT BARAKAZ─░	38.32485300	26.30260300	2
16787	27	D2H105726	OBJEKT B─░L─░┼Ş─░M B─░LG─░ VE ├ûL├ç├£ S─░STEMLER─░ ─░N┼ŞAAT T─░C. A┼Ş.	38.33936000	26.30261200	2
16788	27	D2K213004	O─ŞUZ VURAL	38.32926910	26.30565840	2
16789	27	D2H173445	O─ŞUZHAN ASUTAY	38.31735100	26.30386220	2
16790	27	D2K217419	SEM─░H ATAL	38.32471300	26.30343300	2
16791	27	D2H069790	SERKAN KURU	38.32758900	26.30621200	2
16792	27	D2H106471	SERKAN MUSAO─ŞLU	38.32543700	26.30237000	2
16793	27	D2H167899	SERKAN TA┼ŞDELEN	38.32431120	26.30676780	2
16794	27	020026724	SEV─░L G├ûREN/G├ûREN MARKET	38.32607000	26.30671000	2
16795	27	D2H049298	SEYRAN CANLAR	38.32577800	26.30495000	2
16796	27	D2K242276	SUADA GIDA TURIZM SANAYI TIC. LTD. ┼ŞTI.	42.94838100	34.13287400	2
16797	27	D2K234181	┼Şeref ├Âzk├╝├ğ├╝kler g─▒da sanayi ve ticaret limited ┼şirketi	38.30783440	26.35930730	2
16798	27	D2H082225	┼ŞER─░F ┼Ş─░M┼ŞEK	38.32526000	26.30391500	2
16799	27	D26000424	TUSEM PETROL ├£R├£NLER─░ ─░N─░┼Ş.SAN.T─░C.LTD.┼Ş	38.31589600	26.30381000	2
16800	27	D26000470	UZUN OTO K─░RALAMA EML. MARKET ─░┼ŞLETME SAN. T─░C. LTD. ┼ŞT─░.	38.28695300	26.31417200	2
16801	27	D2H089618	├£NAL ├çOBAN	38.32038800	26.30439700	2
16802	27	D2H189648	├£NSAL TURAN	38.30643120	26.36427650	2
16803	27	D2H140246	VEYSEL KAMER TA┼ŞTEK─░N VE ORT. -KAMER PETROL	38.29931680	26.38369100	2
16804	27	D2H101000	ZEYNEP AYDEM─░R	38.32469900	26.30344600	2
16805	27	D2K211980	Z├£HAL BAKIR ZENC─░R	38.30252900	26.36701700	2
16806	52	020035285	ADEM A─ŞDAN	38.30745700	27.13989100	2
16807	52	D2H001796	ADEM DO─ŞAN	38.32848400	27.13263700	2
16808	52	D2K188203	AHMET AKG├£L	38.31090400	27.13803200	2
16809	52	D2H000353	AHMET G├£RSEL	38.32185500	27.12796300	2
16810	52	D2H015188	AHMET HACIO─ŞLU	38.32658300	27.13421500	2
16811	52	D2H000426	AHMET TOPALO─ŞLU	38.32955800	27.12604800	2
16812	52	D2K127977	AKMAR SANS OYUNLARI GIDA SARK├£TERI MARKET├çILIK SANAYI VE TICARET LIMIT	38.31660700	27.13105400	2
16813	52	D2H056066	ALAADD─░N EREN	38.31853800	27.12725330	2
16814	52	D2K208372	ALEYNA AKDEM─░R	38.31947500	27.13191700	2
16815	52	D2K215196	AL─░ ├ûZT├£RK	38.33154160	27.13174290	2
16816	52	D2K087334	AR─░FE YE─Ş─░NER - AKIN M─░N─░ MARKET	38.31246500	27.13877500	2
16817	52	D2H001756	ASUMAN DEM─░RBA┼Ş	38.31191300	27.13888400	2
16818	52	D2K086107	AT─░K PETROL T─░C. A.┼Ş	38.32969600	27.13549300	2
16819	52	D2K111130	AVCI MARKET├çILIK GIDA TURIZM HAYVANCILIK INS.SAN.VETIC.AS	38.32088830	27.13644840	2
16820	52	D2K130796	AY┼ŞE KARAMENDERES	38.32952620	27.13746360	2
16821	52	D2K226501	AY┼ŞE SAVA┼Ş KO├çASLAN	38.31080850	27.13756730	2
16822	52	D2H022914	BA┼ŞDA┼Ş MARKET - GAZ─░EM─░R	38.32589800	27.13166100	2
16823	52	D2H043206	BA┼ŞDA┼Ş MARKET - GAZ─░EM─░R 2	38.31744260	27.13325080	2
16824	52	D2K070032	BA┼ŞDA┼Ş MARKET - GAZ─░EM─░R 3	38.32328200	27.12179200	2
16825	52	D2K080922	BA┼ŞDA┼Ş MARKET - GAZ─░EM─░R 4	38.32361400	27.12860700	2
16826	52	D2K112201	BA┼ŞDA┼Ş MARKET - GAZ─░EM─░R 5	38.32813400	27.11959100	2
16827	52	D2K189809	BA┼ŞDA┼Ş MARKET - GAZ─░EM─░R 6	38.31748310	27.13034080	2
16828	52	D2K226275	BA┼ŞDA┼Ş MARKET - GAZ─░EM─░R 7	38.32198200	27.13101900	2
16829	52	D2K220990	BES─░ KO├ç	38.31365100	27.13172500	2
16830	52	D2K062638	BTA HAVAL─░MANLARI Y─░.─░├ç.H─░Z. A.┼Ş ─░ZM─░R ┼ŞUBES─░-KANT─░N	38.29185730	27.14798720	2
16831	52	D2H032979	BUKET KARSLI	38.32432900	27.13249600	2
16832	52	D2K233407	CAN KARDE┼ŞLER MARKET├ç─░L─░K GIDA TEKST─░L OTOMOT─░V SANAY─░ VE T─░CARET L─░M─░	38.32294300	27.13353000	2
16833	52	D2K227153	CEREN BOZKU┼Ş	38.33519230	27.10513830	2
16834	52	D2H001804	CEVDET SATAN	38.32419900	27.13548400	2
16835	52	D2K144784	CEYLAN D├ûNMEZ	38.31813830	27.12954910	2
16836	52	D2K128478	ECEM PETROL AKARYAKIT MARKET VE NAKLIYE TICARET ANONIM SIRKETI GAZIEMI	38.33076700	27.13576530	2
16837	52	D2K190322	EDA SOYLU	38.32378860	27.13317970	2
16838	52	D2H037665	ELENUR AKKILIN├ç - B├£LENT ├çET─░N ORTAKLI─ŞI	38.31166900	27.14069000	2
16839	52	D2K173633	EMRE BALKAYA	38.33654000	27.13534400	2
16840	52	D2K227180	EMRE FAT─░H GIDA OTOMOT─░V TUR─░ZM ─░N┼ŞAAT TAAHH├£D├£ ─░THALAT ─░HRACAT SANAY─░	38.31930300	27.12807600	2
16841	52	D2K191458	ERDAL ┼ŞERAN	38.32467500	27.12938350	2
16842	52	D2K155471	ERDENK PROFESYONEL Y├ûN DAN HIZM MARKET GIDA OTO SAN VE TIC LTD STI - D	38.32529660	27.13614530	2
16843	52	D2K104239	EREN BOZKU┼Ş	38.32494300	27.12156600	2
16844	52	D2H000795	ERHAN KAP├çAK	38.32067200	27.12596800	2
16845	52	D2H001098	FAD─░ME DO─ŞAN	38.31579000	27.13519500	2
16846	52	D2K128082	FAT─░H ARSLAN	38.32301700	27.13590660	2
16847	52	D2K175963	FATMA BOZAR	38.32132010	27.12903430	2
16848	52	D2K063587	GALAKS─░ HED─░YEL─░K E┼ŞYA-1 PAZARLAMA LTD.ST─░	38.29141410	27.14824140	2
16849	52	D2K081093	GALAKS─░ HED─░YEL─░K E┼ŞYA-2 PAZARLAMA LTD. ┼ŞT─░	38.29216100	27.14705600	2
16850	52	D2K182056	HAKAN SOYLU	38.32895940	27.12305910	2
16851	52	D2K236610	HAT─░CE G├£N├£┼ŞEN	38.32229380	27.12555060	2
16852	52	D2H000384	HAT─░CE KIRMIZIG├£L	38.31295700	27.13261200	2
16853	52	D2H000114	HED─░YE KAHYA	38.33735400	27.10414300	2
16854	52	D2K060752	H├£SEY─░N KOKAL - MAV─░ EGE	38.30788400	27.13960400	2
16855	52	D2K184269	─░BRAH─░M DABAN	38.31630760	27.13536000	2
16856	52	D2K158351	─░BRAH─░M E┼ŞME	38.31619520	27.12941980	2
16857	52	D2K125046	─░BRAH─░M ─░├ç├ûZ	38.32329800	27.13330400	2
16858	52	D2K061995	─░BRAH─░M MERT	38.32220600	27.13953600	2
16859	52	D2H000477	─░ZM─░RL─░LER OTELC─░L─░K YAT.A.┼Ş.	38.29631900	27.14356200	2
16860	52	D2K189169	JOKER MARKET LOKANTACILIK ─░N┼ŞAAT E-T─░CARET LTD.┼ŞT─░.	38.31927820	27.13105910	2
16861	52	D2K169046	KAD─░R OLUKLUPINAR	38.31724100	27.12876900	2
16862	52	D2H000343	KADR─░YE ARSLAN	38.32341500	27.12182300	2
16863	52	D2K195725	KAMSA GIDA MEYVE SEBZE ALIM SATIM PAKETLEME VE T─░C. LTD. ┼ŞT─░	38.31780510	27.13009060	2
16864	52	D2K098361	KOZLUK DOGAN GIDA INSAAT NAK.PET.VE TEKS.TRZ.SAN VE TIC.LTD.STI - KOZL	38.33035100	27.12693100	2
16865	52	D2K193818	MAHMUT ERTA┼Ş	38.32577160	27.13951850	2
16866	52	D2H052755	MED─░NE DO─ŞAN	38.31668410	27.13206090	2
16867	52	D2K202043	MEHMET AZ─░Z ORAL	38.31916440	27.12874370	2
16868	52	020035365	MERCANLAR PETROL	38.31966200	27.13790900	2
16869	52	D2H000358	MERT ENES LTD.┼ŞT─░.	38.32155800	27.12708400	2
16870	52	D2K144853	MERYEM SUNAY	38.31941500	27.13163500	2
16871	52	D2K219188	METE KARA	38.32546740	27.13698620	2
16872	52	D2H032267	MEYREM ├çEL─░K	38.32269600	27.13934500	2
16873	52	D2K195195	MUHAMMED YUSUF HENEK	38.32515250	27.13209140	2
16874	52	D2K099517	MURAT EL├ç─░KOCA	38.31866800	27.12901500	2
16875	52	D2K103749	MUSTAFA KIVIR	38.32701200	27.12726000	2
16876	52	D2K241715	NUR─░ DEL─░BA┼Ş	38.33168760	27.12844770	2
16877	52	D2H000376	NUR─░ ─░LER─░	38.32048080	27.12701250	2
16878	52	D2K136309	ONUR D├ûNMEZ	38.32759800	27.13090350	2
16879	52	D2K225640	OSAN TURIZM TASIMACILIK TEMIZLIK HIZMETLERI GIDA INSAAT SAN. VE TIC.LT	38.29169430	27.14719160	2
16880	52	D2K107605	OSMAN YANARDA─Ş	38.32055900	27.13004100	2
16881	52	D2K240904	OZAN GIDA-HAKTAN PERAKENDE VE TOPTAN GIDA L─░M─░TED ┼Ş─░RKET─░ GAZ─░EM─░R ┼ŞUB	38.30700840	27.13618970	2
16882	52	D2K143624	├ûMER TOK MARKETCILIK SAN VE TIC LTD.┼ŞT─░.	38.31989170	27.13678330	2
16883	52	D2K168501	├ûYK├£ KARA	38.31937700	27.13256490	2
16884	52	D2K219110	├ûZKAN TUN├çB─░LEK	38.33127200	27.13261600	2
16885	52	D2K113118	├ûZYILDIZ INS.MALZ.TURZ VE GIDA SAN.TIC.LTD.STI	38.32242560	27.13373150	2
16886	52	D2K215466	PETROL OF─░S─░ A.┼Ş (AK├çAY - M044)	38.31627020	27.14143530	2
16887	52	D2K232038	POLAT S├£LEYMAN T├£Z├£N	38.32665850	27.13705270	2
16888	52	D2K232422	PORT ALCOHOL GIDA SAN. VE T─░C. LTD. ┼ŞT─░.	38.31581200	27.13530200	2
16889	52	D2K225341	RAMAZAN ALYURT	38.32169480	27.13591370	2
16890	52	D2H000382	SELVET HEPBERK	38.32648600	27.13920500	2
16891	52	D2K237206	SERHAT ULUBAH┼Ş─░	38.32151270	27.13116150	2
16892	52	D2H000390	SERKAN SEZMEN	38.32105800	27.12523100	2
16893	52	D2H002097	SEVEN D─░┼Ş├ç─░	38.32559900	27.13469800	2
16894	52	D2K224295	S─░MA TUR─░ZM TA┼ŞIMACILIK TEM─░ZL─░K VE GIDA SAN.T─░C.LTD.┼ŞT─░.	38.29179540	27.14734990	2
16895	52	D2H024430	S├£LEYMAN ├ç─░├çEK	38.32226300	27.12890700	2
16896	52	020035264	S├£LEYMAN ├ç─░├çEK	38.32508900	27.13524100	2
16897	52	D2K145163	┼ŞER─░FE TOPSAKAL	38.32481770	27.13864630	2
16898	52	D2K197953	┼Ş├£KR├£ EK─░C─░	38.32000400	27.12720300	2
16899	52	D2K242865	TAHA G├£LTEK─░N	42.94838100	34.13287400	2
16900	52	D2K179898	TU─ŞBA KIRINDI	38.32294840	27.13024470	2
16901	52	D2K196189	TU─ŞBA KIRINDI 2	38.32655200	27.12813100	2
16902	52	D2H001346	TUZCUO─ŞLU PET.SAN.T─░C.LTD.┼ŞT─░.	38.33157500	27.13553500	2
16903	52	D2K241924	U─ŞUR ├ûZDA┼Ş	42.94838100	34.13287400	2
16904	52	D2K171693	YETER ADIG├£ZEL	38.30209850	27.13003950	2
16905	16	D2K208919	ABDULBAK─░ D─░LBER	38.35753900	27.14678650	2
16906	16	020052636	ABDULLAH KO├çAK GIDA -BUCA	38.36744300	27.14867400	2
16907	16	D2K239800	ABDURRAHMAN AYDO─ŞAN	38.37557760	27.16894880	2
16908	16	D2K104515	ADEM CENG─░Z	38.35694950	27.15137170	2
16909	16	D2K087390	ADNAN S├ûNMEZ - S├ûNMEZ MARKET	38.36114600	27.15066200	2
16910	16	D2K086922	AHMET G├£NDO─ŞDU - KARDE┼ŞLER MARKET	38.36104000	27.15059400	2
16911	16	D2K145717	AHMET KAHRAMAN	38.35954260	27.14369690	2
16912	16	D2K133940	AL─░ B─░L─░R	38.36269610	27.15649550	2
16913	16	D2K199686	AL─░ KARAG├ûZ	38.36784500	27.16781390	2
16914	16	D2K114680	ASIM AKKAYA	38.36793610	27.16291840	2
16915	16	020046036	AYDA ├ûZDEM─░R	38.36097200	27.14431500	2
16916	16	D2K222053	AYTEK─░N ├ûKMEN	38.37452840	27.17359570	2
16917	16	D2K239453	BARI┼Ş GROSS GED─░Z	38.36009740	27.14798250	2
16918	16	D2K234315	BARI┼Ş G├£NDEM	38.37547440	27.16875290	2
16919	16	D2K189457	BERGHAN OYAN	38.36172830	27.14399350	2
16920	16	D2K107076	BE┼Ş─░R KOTAN	38.36149430	27.14013510	2
16921	16	D2K128774	BURHAN YARDIMCI	38.36485170	27.14833380	2
16922	16	020048164	CANER PA┼ŞAO─ŞLU	38.36923510	27.16713760	2
16923	16	D2K189323	CEM KARTAL	38.36723010	27.16946810	2
16924	16	D2K197484	CEMALETT─░N GER├çEK	38.36694300	27.15257700	2
16925	16	D2K202564	CEM─░L ─░SP─░R	38.35815900	27.14531500	2
16926	16	020050121	CEVDET YILMAZ	38.36938590	27.16616880	2
16927	16	020051801	CEVDET YILMAZ	38.36108500	27.14522200	2
16928	16	D2K150758	├çINAR TOSUN	38.36992110	27.15304180	2
16929	16	D2K146825	├ç─░─ŞDEM HACIO─ŞLU	38.35526000	27.15048100	2
16930	16	D2K233678	DAMLA ERDURAN	38.37134530	27.17030420	2
16931	16	020049111	DUDU ALKI┼Ş	38.35441400	27.14803600	2
16932	16	D2K194149	EBRU T─░RYAK─░	38.36393970	27.14586710	2
16933	16	D2K169703	ED─░P POLAT	38.36902250	27.16382870	2
16934	16	D2K226334	EMRE ├çET─░NER	38.37201500	27.16619600	2
16935	16	D2K145545	EMRE SERT	38.37441800	27.17361330	2
16936	16	D2K203748	EMRULLAH Y├£CESOY	38.36838270	27.14283170	2
16937	16	020002191	ERDAL AKTA┼Ş	38.36340780	27.14333330	2
16938	16	D2K173914	EREN MERT GIDA  LTD.┼ŞT─░.	38.36760470	27.16265840	2
16939	16	020006724	ERKAN ARTU├ç-├£NALDI MARKET	38.36757800	27.14177600	2
16940	16	D2K237583	E┼ŞREF ├çET─░N	38.36970280	27.14312530	2
16941	16	D2K240111	FADIL AKTAR	38.36651620	27.14599490	2
16942	16	D2K160847	FARUK ├çEL─░K	38.36259540	27.14888610	2
16943	16	020049484	FATME G├£NG├ûR	38.36755400	27.16485900	2
16944	16	D2K082634	FAZ─░LET ACAR - MEVLANA MARKET	38.36912000	27.15029400	2
16945	16	D2K200275	F─░KR─░YE ├çET─░N	38.36771140	27.16380680	2
16946	16	D2K228234	GAMZE GAN─░ME KIRCEYLAN	38.36250890	27.14923800	2
16947	16	D2K240235	G├£LTEN BOZKURT	38.36963500	27.15798900	2
16948	16	D2K228096	HAL─░L G├ûNL├£BOL	38.36827900	27.15056700	2
16949	16	D2K236926	HAL─░M ALTUN	38.36679210	27.15428710	2
16950	16	D2K178415	HAMZA BULUT	38.36956500	27.14409100	2
16951	16	D2K240964	HASAN KANSU	38.37394510	27.16824480	2
16952	16	D2K187451	HASAN K├ûK	38.36846700	27.14776900	2
16953	16	D2K218816	HASAN K├ûK II	38.36829930	27.14259560	2
16954	16	020001852	HAYR─░ G├£REL	38.35786800	27.14641800	2
16955	16	D2K139739	HAYR─░YE KAYA	38.36436600	27.14119300	2
16956	16	D2K219396	H├£LYA ├çANKAYA	38.37520340	27.17385700	2
16957	16	D2K224218	─░BRAH─░M KIRICI	38.37737430	27.17062480	2
16958	16	D2K224225	─░BRAH─░M LA├ç─░N	38.36160010	27.14451160	2
16959	16	020049137	─░BRAH─░M ├ûZDO─ŞAN-─░D─░L MARKET	38.36956670	27.17349690	2
16960	16	D2K135390	─░HSAN S├ûNMEZ	38.36691900	27.14752100	2
16961	16	020046522	─░LYAS ├çANKAYA-KONYA BAKKAL	38.35731990	27.14934350	2
16962	16	D2K238137	─░REM EK─░N	38.36340060	27.14154880	2
16963	16	D2K222146	─░ZTEK GIDA OTOMOT─░V SAN.T─░C.A┼Ş.	38.37077240	27.17226650	2
16964	16	D2K233842	KAD─░R TEMEL	38.37810010	27.17185600	2
16965	16	020002070	KAYHAN AKKA┼Ş	38.36305200	27.14996800	2
16966	16	D2K172899	KENAN AYAZ	38.36809500	27.14191300	2
16967	16	D2K201852	KESER YILDIRIM	38.36733000	27.14992900	2
16968	16	020005671	KUZUCUO─ŞLU ─░N┼Ş. MALZ. LTD. ┼ŞT─░.	38.35810000	27.14740000	2
16969	16	D2K203983	MAHMUD HAJ KASSEM	38.36865920	27.15006900	2
16970	16	D2K096472	MAHMUT A─ŞAN	38.36010440	27.15285420	2
16971	16	D2K130924	MAHMUT YAL├çIN	38.36169400	27.14180990	2
16972	16	D2K229740	MAZHAR KARA├çAL	38.36467500	27.15258300	2
16973	16	D2K157180	MAZLUM KARADA┼Ş	38.37280930	27.16505880	2
16974	16	020004686	MEHMET DEM─░R-HACERO─ŞLU MARKET	38.37272300	27.16757900	2
16975	16	D2K160990	MEHMET SIDIK EK─░N	38.36838970	27.14572060	2
16976	16	D2K229873	MELEK K├ûM├£RC├£	38.36741410	27.15001340	2
16977	16	D2K164054	MELEK YILDIZ	38.37589650	27.17418620	2
16978	16	020018583	MEL─░K KAPLAN	38.36711410	27.16221690	2
16979	16	D2K212568	MEL─░S ├ûZGAN	38.36553400	27.15292400	2
16980	16	020051426	MERK─░M K─░MYASAL MED.DAY.T├£K.MALLARI GIDA TAR.─░N┼Ş.SAN.T─░C.LTD.┼ŞT─░.	38.35639400	27.15254400	2
16981	16	D2K190489	MET─░N K├ûSALI	38.36048730	27.14714870	2
16982	16	D2K227275	MUAMMER ERDENLER	38.36432220	27.15049470	2
16983	16	D2K170065	MUHAMMET U├çAR	38.36368540	27.14937080	2
16984	16	D2K240896	MUH─░YETT─░N TA┼ŞDEM─░R	38.37093130	27.17119550	2
16985	16	020048595	MUSTAFA TUN├ç	38.37065200	27.17243700	2
16986	16	D2K226328	NED─░M YOLDA┼Ş	38.36747030	27.16094610	2
16987	16	D2K095601	NUR─░YE KASIRGA-YILDIZ MARKET	38.36725800	27.17059300	2
16988	16	D2K087563	NURTEN ├çEL─░K - EGE MARKET	38.36409600	27.14808800	2
16989	16	D2K213993	OKAN AHI	38.37292610	27.17199470	2
16990	16	D2K205540	OPET (BUCA - 9000001924)	38.36299270	27.14987970	2
16991	16	D2K236086	├ûMER AYDO─ŞAN	38.36312140	27.14824430	2
16992	16	D2K154406	├ûZ BIR IZ GIDA YAPI NAKLIYAT SANAYI TICARET VE LIMITED SIRKETI	38.35581640	27.15106750	2
16993	16	D2K175728	├ûZER YILD─░Z	38.35715310	27.14590330	2
16994	16	D2K146508	RAMAZAN AKKO├ç	38.36701210	27.15496980	2
16995	16	020001442	RAMAZAN DEDE	38.37750960	27.17327630	2
16996	16	020002863	RAY─░F YALUR	38.36966500	27.15144300	2
16997	16	D2K209112	RIFAT ACAR	38.36632100	27.14462370	2
16998	16	D2K204101	R─░FA─░ ├çELEB─░	38.36451720	27.14461290	2
16999	16	D2K235734	SAADET YALNIZ CAN	38.37328510	27.17233530	2
17000	16	D2K215947	SADIK DEM─░R	38.35965710	27.14318600	2
17001	16	020054994	SADIK DUMLU	38.37044500	27.16526680	2
17002	16	D2K178857	SAMET S├ûNMEZ	38.36214050	27.14678180	2
17003	16	020048151	SAN─░YE ├çEL─░K	38.36326300	27.14438800	2
17004	16	D2K199687	SEDAT ASLAN	38.36991300	27.16797100	2
17005	16	D2K237227	SEHER DEM─░R	38.37381720	27.17270390	2
17006	16	D2K138743	SERAP ┼ŞENG├£L ERTATI┼Ş	38.37211290	27.17119720	2
17007	16	020011194	┼ŞAH─░N GANYAN BAY─░ KIRT. GIDA  TEKEL MAD.	38.36201500	27.14580500	2
17008	16	020002176	┼ŞEMSEDD─░N FURAN	38.37457400	27.17204300	2
17009	16	020054376	┼ŞERAFETT─░N ├£NL├£	38.36505300	27.14459700	2
17010	16	020002259	TACETT─░N YOLCU	38.36584700	27.14620900	2
17011	16	D2K092698	TAL─░P YILMAZ - CANSU KURUYEM─░┼Ş	38.37360900	27.16796500	2
17012	16	D2K234777	TAYFUR ─░YEM	38.37304200	27.16970420	2
17013	16	020001204	TURAL YOLCU	38.36362940	27.15344280	2
17014	16	D2K105174	TURAN KILI├ç	38.35231900	27.14984600	2
17015	16	D2K229702	UBEYDULLAH ├£NL├£	38.36843010	27.14399220	2
17016	16	D2K133182	U─ŞUR ├çEL─░K	38.36717350	27.14817540	2
17017	16	D2K173226	UMUT DA┼ŞDEM─░R	38.37012170	27.16825100	2
17018	16	D2K233071	UMUT DA┼ŞDEM─░R 2	38.36800140	27.17255080	2
17019	16	D2K181904	UMUTCAN HO┼ŞG├ûR	38.35290460	27.14800490	2
17020	16	D2K225732	VEDAT KARA├çAL	38.36793290	27.15109500	2
17021	16	D2K222099	YAD─░GAR D─░NAR LALE	38.36593070	27.14141920	2
17022	16	D2K232569	YAHYA YAL├çIN	38.36147030	27.14265240	2
17023	16	020001626	YETER KOCAKURT	38.36827400	27.14788000	2
17024	16	D2K232191	YUB─░ ALI┼ŞVER─░┼Ş MERKEZ─░-emir toprak oto kiralama turizm ta┼ş─▒mac─▒l─▒k san	38.36064700	27.14540360	2
17025	16	D2K091248	Y├£KSEL YILDIZ	38.36140900	27.14966280	2
17026	16	D2K153955	Z├£BEYDE POLAT	38.36755160	27.16019540	2
17027	6	D2K242239	8RA TUR─░ZM T─░C.L─░M. ┼ŞT─░	42.94838100	34.13287400	2
17028	6	D2H152209	ADEM HASAN TURAN	38.39585000	27.09334500	2
17029	6	020053363	ADNAN KOSANO─ŞLU	38.39334500	27.08204700	2
17030	6	020012579	ALESTA PET.GIDA KOM.TUR─░ZM ─░N┼Ş.TA┼Ş.HY.PAZ.LTD.┼ŞT─░.	38.39843800	27.09084570	2
17031	6	020000940	AL─░ DUYMAZ	38.39703400	27.07980100	2
17032	6	020004425	AL─░ SAVA┼Ş	38.39259900	27.08764900	2
17033	6	D2K218902	AL─░ UMUT DUMAN	38.39339700	27.08872750	2
17034	6	020057345	AYDIN KARTAL	38.40823400	27.11154700	2
17035	6	D2K237617	AY┼ŞE ODABA┼Ş	38.39343760	27.08716750	2
17036	6	020049827	AY┼ŞE SA─ŞLAM	38.40809100	27.11750700	2
17037	6	020009874	AY┼ŞE ┼ŞENOCAK-S├ûNMEZ OCAK B├£FE	38.39741380	27.08199240	2
17038	6	D2H149583	AY┼ŞE UZUN	38.40720030	27.10545100	2
17039	6	020056000	BARI┼Ş MARKET -G├£ZELYALI	38.39890800	27.08067200	2
17040	6	D2K239189	BA┼ŞDA┼Ş MARKET G├ûZTEPE	38.40130720	27.09342800	2
17041	6	D2K210569	BATINAK TRANS─░T TA┼ŞIMACILIK PETROL VE TUR─░ZM T─░C.LTD.┼ŞT─░.	38.39326800	27.08401900	2
17042	6	020000275	BEDRAN AYDEM─░R	38.40850100	27.12166700	2
17043	6	020051316	BEDR─░YE KILIN├ç	38.40508900	27.09874600	2
17044	6	D2K224615	BY STOP GIDA SANAY─░ VE T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.39354450	27.08219500	2
17045	6	D2H170866	CAN CAN ALKOLL├£ ─░├çECEKLER VE GIDA SANAY─░ T─░C.L─░M─░TED ┼Ş─░RKET─░	38.39754990	27.08559430	2
17046	6	020050823	CENG─░Z ├çAKIREL	38.40695140	27.10410490	2
17047	6	D2K201637	CENG─░Z KARATA┼Ş	38.40803570	27.11705030	2
17048	6	020017360	CENG─░Z TANKUT ORT. KARDE┼ŞLER MARKET	38.41189290	27.12189230	2
17049	6	D2K234955	C─░HAN ┼ŞEKER	38.39917200	27.09151900	2
17050	6	D2H106133	C─░HAN ┼ŞEN	38.39249700	27.09158500	2
17051	6	020012404	DALKILI├ç ┼ŞANS OYUNLARI GIDA TUR.T─░C.LTD.	38.39815360	27.08886280	2
17052	6	D2K228841	DAVUT G├ûREN	38.40743220	27.11606570	2
17053	6	020058094	EFSANE MARKET├ç─░L─░K GIDA ├£R├£NLER─░ SAN. VE T─░C. LTD. ┼ŞT─░.	38.39566300	27.09374200	2
17054	6	D2K199988	EMEL G├ûREN	38.40749100	27.11826200	2
17055	6	D2K239072	EM─░R ERKILI├ç	38.40955300	27.11877900	2
17056	6	020012480	ENSAR ├ûZT├£RK - ROSE SAYISAL TEKEL	38.39880400	27.07680600	2
17057	6	D2K209339	ERDAL ZEYT├£NL├£	38.40898840	27.11048590	2
17058	6	D2K227778	FARUK KO├ç	38.40988200	27.12564700	2
17059	6	D2K226091	FERD─░ ├ûZDEM─░R	38.39787900	27.08433000	2
17060	6	D2K228650	FERD─░ ├ûZDEM─░R-2	38.39796400	27.08398200	2
17061	6	D2K240494	FERD─░ ├ûZDEM─░R-3	42.94838100	34.13287400	2
17062	6	020003819	F├£SUN YAL├çINKAYA-CEREN TEKEL	38.39887100	27.08127100	2
17063	6	020056185	G─░ZEM NUR S├£NCAK	38.39829240	27.08296130	2
17064	6	020003213	G├£LCAN DO─ŞAN-ECEM MARKET	38.40694350	27.10395800	2
17065	6	020015934	G├£LSEN K├ûSE	38.40768900	27.11929500	2
17066	6	D2K231555	G├£ZELYALIM ┼ŞARK├£TER─░ SANAY─░ VE T─░CARET L─░M─░TET ┼Ş─░RKET─░	38.39784700	27.08721900	2
17067	6	020052782	HARUN DEL─░G├ûZ	38.41111400	27.12156500	2
17068	6	020007254	HASAN ┼ŞENKURT-HAS GIDA	38.39401000	27.08206100	2
17069	6	020011913	HAS├çAG GIDA SANAYI TICARET LIMITED SIRKETI - FORZA G├ûZTEPE	38.39606900	27.08443400	2
17070	6	020051404	HAT─░CE SARI	38.40720000	27.10520000	2
17071	6	020016180	H├£DAVERD─░ ┼Ş─░M┼ŞEK-KORKMAZ MARKET	38.39451600	27.09015600	2
17072	6	D2H161587	II.┼ŞEMSETT─░N ┼Ş─░LE	38.39368100	27.09472500	2
17073	6	D2H190472	─░BRAH─░M ERTU─ŞRUL	38.40569590	27.09930770	2
17074	6	020058206	─░NAN CAN KO├ç	38.39904600	27.07873400	2
17075	6	020012728	─░PEK KAVUT	38.39659800	27.07998600	2
17076	6	D2H160540	─░SMA─░L ALPTEK─░N	38.39537080	27.09290160	2
17077	6	020045538	─░SMA─░L ALPTEK─░N-├ûZKO├çLAR MARKET	38.41044800	27.12104100	2
17078	6	020017592	─░SMA─░L SARIO─ŞLAN -MARKET ─░┼ŞLETMES─░	38.41067400	27.12128500	2
17079	6	D2K215842	─░┼ŞT─░HAR D├£┼ŞK├£N	38.40689370	27.10592770	2
17080	6	020006013	KADIO─ŞLU MARKET GIDA TUR.─░N┼Ş.SAN. T─░C .LTD.┼ŞT─░.	38.39894410	27.08016860	2
17081	6	020045045	LEVENT DURAN-GAYE MARKET	38.39249830	27.08436800	2
17082	6	D2H178938	MAYDANOZ TUR─░ZM OTEL.OR.─░N┼Ş.GIDA DAN. VE T─░C.LTD.┼ŞT─░.	38.40592520	27.06662350	2
17083	6	020057430	MED─░HA KAD─░M	38.40199960	27.09523890	2
17084	6	D2K242794	MEHMET EM─░N YAMAN	42.94838100	34.13287400	2
17085	6	020011842	MEHMET NUR SAMANCI-KARDE┼ŞLER MARKET	38.40845200	27.11443400	2
17086	6	020051717	MEHMET REMZ─░ KILIN├ç	38.39575400	27.08089600	2
17087	6	D2K237870	MEHMET SAVA┼Ş KASAPLAR	38.40168170	27.09409680	2
17088	6	020049152	MERDAN ├ûZDEM─░R	38.39566850	27.08413160	2
17089	6	D2H183195	MER─░ KAYMAK	38.40653780	27.10273040	2
17090	6	020056321	MERT AYTU─Ş	38.39760300	27.07474200	2
17091	6	020056533	MITOS GIDA ILETISIM TUR.KIRTASIYE HAFRIYAT VE SAN.TIC.LTD.STI - M─░TOS	38.39316300	27.08614900	2
17092	6	020012502	M─░N─░ MARKET GIDA SANS OYUNLARI TUR.TIC.LTD.STI.	38.39517800	27.09202800	2
17093	6	020054162	MUHAMMET AYDIN	38.39376400	27.09469200	2
17094	6	020058412	MUSTAFA ├çAPRAZ	38.39607600	27.08749000	2
17095	6	020054197	MUSTAFA ER┼ŞAN ESAN	38.39735400	27.09217500	2
17096	6	D2K239342	MUSTAFA KALINDAMAR	38.40928370	27.11270550	2
17097	6	020048184	MUSTAFA YEN─░├çIRAK-EZG─░ MARKET	38.39777600	27.07645500	2
17098	6	D2K238681	NACARO─ŞLU TEKEL GIDA T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.39353820	27.08398920	2
17099	6	D2H172676	NAC─░YE DEM─░R	38.40790410	27.11291030	2
17100	6	D2H157021	NALAN KURTEL	38.39175700	27.08827800	2
17101	6	020052340	NER─░MAN SEZG─░N	38.39609160	27.08234470	2
17102	6	020058561	N─░L├£FER KURTKAN	38.40875400	27.11028100	2
17103	6	D2H194799	NKT T├£KET─░M MALLARI GIDA VE SANAY─░ T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.39311410	27.08774740	2
17104	6	D2K217333	OKS─░JEN MARKET├ç─░L─░K GIDA ├£R├£NLER─░ SAN. VE T─░C. LTD. ┼ŞT─░.	38.39182260	27.08834640	2
17105	6	020012582	OKTAY YA─ŞCIER	38.39672240	27.09265200	2
17106	6	D2H152610	├ûZDEN─░Z A.V.M. PAZ.DA─Ş.SAN.VE T─░C.LTD.┼ŞT─░.	38.40691900	27.10613100	2
17107	6	D2K208831	├ûZKAN KALENDER	38.39517430	27.09213740	2
17108	6	D2H186359	├ûZLEM TOZAN	38.39879880	27.07914980	2
17109	6	020049632	PERV─░N YILDIRIM	38.39745900	27.08081100	2
17110	6	D2H176044	PINAR DA┼ŞDEM─░R	38.40839930	27.10944390	2
17111	6	D2K210860	P─░LOT B├£FE GIDA ─░┼ŞLETMEC─░L─░─Ş─░ SAN.VE T─░C LTD.┼ŞT─░.	38.39148620	27.08877810	2
17112	6	020053863	RAHMETULLAH TEPE	38.39871740	27.09077250	2
17113	6	D2K225046	RAMA MARKET├ç─░L─░K GIDA PAZARLAMA T─░CARET L─░M─░TED ┼Ş─░RKET─░ - SE├ç MARKET	38.40791100	27.11390300	2
17114	6	020052784	RAMAZAN DA┼ŞDEM─░R	38.39892990	27.08128900	2
17115	6	020003192	RAMAZAN ESEN	38.40973200	27.11971900	2
17116	6	020050970	RAMAZAN OR├çUN ERKEN	38.39842600	27.07503500	2
17117	6	020048120	S JUVENA TEKSTIL YAPI INSAAT TURIZM GIDA ITH. IHR. SAN. VE TIC. LTD. S	38.39765830	27.07078590	2
17118	6	D2K215843	SA─░ME G├£├çL├£	38.39878180	27.07891870	2
17119	6	020050452	SELAM ├ûZKUL	38.39340000	27.08400000	2
17120	6	020012465	SEL─░ME ├çAKMAK	38.39326300	27.08450300	2
17121	6	020018889	SEMA CEYNAKLI	38.40875900	27.12340400	2
17122	6	020058407	SEMA SUBAY	38.39724800	27.08573700	2
17123	6	020055676	SERHAT ACAR	38.40978550	27.12564150	2
17124	6	020048524	SEV─░M KARAASLAN	38.40787400	27.11651300	2
17125	6	020012476	SHELL PETROL (G├£ZELYALI - 3033)	38.39855900	27.07772000	2
17126	6	020056081	S─░MGO GIDA MARKET├ç─░L─░K ─░N┼ŞAAT TURZ─░M TEKST─░L SANAY─░ VE T─░CARET L─░M─░TED	38.40929000	27.11375870	2
17127	6	D2K219448	┼ŞEYHMUS ─░NAN├ç	38.39549800	27.09488400	2
17128	6	D2H174339	TAM 35 GIDA OTOMOT─░V ─░N┼ŞAAT TUR─░ZM SANAY─░ VE T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.39880600	27.07750700	2
17129	6	D2H149247	T├£LAY ├çALGIN	38.39640300	27.07495900	2
17130	6	020058140	T├£L─░N ┼ŞAH─░N	38.39545420	27.07757260	2
17131	6	020013254	UFUK AKARYAKIT TICARET VE TURIZM LIMITED SIRKETI - UFUK AKARYAKIT T─░CA	38.39744620	27.06633030	2
17132	6	D2K205059	UFUK G─░RG─░NER	38.39684700	27.08191100	2
17133	6	020002186	UFUK MET─░N	38.39513200	27.09556200	2
17134	6	D2H189909	U─ŞUR ─░┼Ş├ç─░MEN	38.40835750	27.11949730	2
17135	6	020001861	├£M─░T KESK─░N	38.41095400	27.12140000	2
17136	6	020047038	YAD─░GAR PARLAR-YAD─░GAR MARKET	38.40860100	27.11113300	2
17137	6	020009958	YAL├çIN KUZUCU	38.40800800	27.11420500	2
17138	6	D2K234781	YALI35 GD. OTO. ─░N┼Ş. TURZ. SAN. VE T─░C. LTD. ┼ŞT─░	38.39889200	27.08012900	2
17139	6	020053870	YA┼ŞAR TEPE	38.39891920	27.09109500	2
17140	6	020057332	YILMAZ SE├çER	38.39338210	27.08677240	2
17141	6	D2K199292	Y├£KSEK MARKET GIDA T─░CARET LTD.┼ŞT─░.	38.39704390	27.09094380	2
17142	6	020053968	ZEYNEL CAFCAV	38.40920880	27.11389300	2
17143	2	020050587	AD─░LE ├çEL─░K - CAN TOBACCO	\N	\N	2
17144	2	D2K177198	ADNAN G├£LG├£N	38.39443030	27.16068030	2
17145	2	D2K184998	AHMET KIZILBO─ŞA	38.39871320	27.17008300	2
17146	2	D2K231974	AL─░ DARTAR	38.39621080	27.15278630	2
17147	2	D2K155001	AL─░ G├£NDO─ŞDU	38.39902350	27.15284320	2
17148	2	020001642	AYDIN ERDO─ŞAN	38.39701000	27.16425600	2
17149	2	D2K118467	AYSEL ├çELEB─░ BENT	38.39487200	27.15584400	2
17150	2	020049086	BA┼ŞDA┼Ş MARKET - ┼Ş─░R─░NYER 1	38.39936400	27.15528400	2
17151	2	D2K235426	BA┼ŞDA┼Ş MARKET BUCA 2 - G├£LTEPE	38.39464500	27.14831100	2
17152	2	D2K166139	BATMAR GIDA TUR─░ZM ─░N┼ŞAAT SANAY─░VE T─░C.LTD.┼ŞT─░.	38.39508650	27.15631740	2
17153	2	D2K083463	BED─░R ├çEL─░K - ├çEL─░K MARKET	38.40483200	27.16116400	2
17154	2	D2K211378	BET├£L ATALAY	38.39510600	27.16460600	2
17155	2	020049855	B─░MAR-─░┼Ş├ç─░EVLER─░ ┼ŞB.	38.40320000	27.16430000	2
17156	2	D2K071469	BURHAN S├ûYLEMEZ	38.39843100	27.16356400	2
17157	2	D2K238834	BUSE ESAN SAKLAK	38.39629850	27.16516200	2
17158	2	020018584	B├£LENT AKKU┼Ş	38.40000200	27.14953700	2
17159	2	D2K214610	CANAN ├ûZGEN├ç	38.39864720	27.15412290	2
17160	2	D2K184713	CANER ERDO─ŞAN	38.40036760	27.15587990	2
17161	2	D2K230080	CANSEVER AV┼ŞAR	38.40028620	27.16756480	2
17162	2	020004733	CEMAL HAFIZO─ŞLU	38.40026000	27.16930700	2
17163	2	D2K242018	CEMAL UZUNO─ŞLU	38.39813470	27.14814810	2
17164	2	D2K194920	CEMALETT─░N TEK─░N	38.39569030	27.16079870	2
17165	2	D2K237218	C├£NEYT BAHC─░VAN	38.40440470	27.15525530	2
17166	2	D2K206510	C├£NEYT D├£RA├çE	38.39326790	27.14671130	2
17167	2	D2K239618	├ç─░├çEK KARDE┼ŞLER ALI┼ŞVER─░┼Ş MERKEZ─░ TA┼ŞIMACILIK SERV─░S VE T─░. LTD. ┼ŞT─░.	38.40537100	27.16786750	2
17168	2	D2K206716	DEMET D├û─ŞER	38.40365600	27.16500400	2
17169	2	D2K216330	DEM─░R├ç─░V─░ GIDA ─░N┼ŞAAT SANAY─░ TUR─░ZM VE T─░C.LTD.┼ŞT─░.	38.39979980	27.15854580	2
17170	2	D2K146511	D─░LEK KONCA	38.40130800	27.16505140	2
17171	2	D2K233235	DORUK MARKET├ç─░L─░K GIDA MADDELER─░ SAN.VE T─░C.LTD.┼ŞT─░.	38.39709040	27.15730000	2
17172	2	D2K159525	DUYGU PINAR ARSLAN	38.39522750	27.16707000	2
17173	2	D2K093311	EGEHAS GIDA ┼ŞANS OYUNLARI	38.39644800	27.14861500	2
17174	2	D2K236847	EL─░F NAZ ┼Ş─░M┼ŞEK	38.40310270	27.16889400	2
17175	2	D2K100849	ERDAL DEM─░R	38.40203710	27.15344200	2
17176	2	020053105	EROL EDEBAL─░	38.40293400	27.16962700	2
17177	2	D2K218903	FARUK ├çA─ŞLAR	38.39992310	27.14965820	2
17178	2	D2K237947	FATMA K├ûRO─ŞLU	38.39790380	27.15276810	2
17179	2	020002470	FERHAT KARAG├£L	38.40361800	27.16267400	2
17180	2	D2K241083	F─░KRET ABLAY	38.39656280	27.16230390	2
17181	2	D2K135388	F─░RDEVS BOZO─ŞLU	38.40029020	27.15581680	2
17182	2	D2K134763	F├£SUN EVYAPAR	38.39715300	27.16967480	2
17183	2	D2K092336	G├ûKHAN AKKU┼Ş - AL─░A─ŞA MARKET	38.39477300	27.15611700	2
17184	2	020014099	G├ûN├£L KILI├ç	38.39633500	27.16007300	2
17185	2	020049948	G├£LTEN KO├çT├£RK - BAHAR GIDA	38.39611100	27.15825400	2
17186	2	D2K241070	HALUK G├ûRG├£L├£	38.39719820	27.14485800	2
17187	2	020000558	HASAN ALPASLAN-ONUR MARKET	38.39525900	27.16307700	2
17188	2	020047224	HASAN ALTINBA┼ŞAK - HASAN BAKKAL	38.40736960	27.15164740	2
17189	2	D2K124382	HA┼Ş─░M KORKMAZ	38.40079100	27.16164800	2
17190	2	020002766	HAT─░CE DURULU	38.39693100	27.15111100	2
17191	2	D2K227317	H─░MMET SARI	38.39709450	27.15238350	2
17192	2	020007497	H├£SEY─░N DO─ŞAN	38.39317500	27.14830200	2
17193	2	D2K241225	H├£SEY─░N ORTATEPE	42.94838100	34.13287400	2
17194	2	D2K208542	H├£SEY─░N SUAT YE─ŞEN	38.40076300	27.17017100	2
17195	2	D2K227495	II.DUYGU PINAR ARSLAN	38.39628050	27.16732740	2
17196	2	D2K154488	─░LKCAN S├ûZEN	38.39681560	27.14889560	2
17197	2	D2K241448	KAMURAN BAYRAM	38.39645480	27.15704380	2
17198	2	D2K218442	L├£TF─░ DA─ŞCI	38.39393100	27.16004200	2
17199	2	020044978	MEHMET BAYRAM - MINI MARKET	38.40466800	27.16360700	2
17200	2	020017855	MEHMET GENCER	38.40435600	27.15152400	2
17201	2	D2K170956	MEHMET GENCER-2	38.40484740	27.15207410	2
17202	2	020046558	MEHMET ─░NHAL - IRMAK AVM	38.40436200	27.15143800	2
17203	2	D2K165814	MEHMET ├ûZKAN	38.40360560	27.16713610	2
17204	2	D2K139416	MEHMET ULUTATI┼Ş	38.40313620	27.16518740	2
17205	2	020004220	MET─░N SUNER	38.39388400	27.14851500	2
17206	2	020047127	MET─░N YILDIRIM	38.40366100	27.16502400	2
17207	2	D2K146517	MUAMMER G├£RE┼Ş├ç─░	38.39457110	27.16893680	2
17208	2	020048083	MUHARREM EMREM	38.40220000	27.15820000	2
17209	2	D2K233400	MURAT TERZ─░	38.39599950	27.16112730	2
17210	2	D2K216332	MUSTAFA ERTA┼Ş	38.39687050	27.14678570	2
17211	2	D2K226595	MUSTAFA G├£LMEZ	38.39541200	27.15647400	2
17212	2	D2K117685	MUSTAFA ├ûZDO─ŞAN	38.39517110	27.15799510	2
17213	2	D2K231459	MUZAFFER BOZDA─Ş	38.39465370	27.16469070	2
17214	2	020004281	M├£M─░N ERAK	38.40230000	27.16250000	2
17215	2	D2K147978	NATUREL ├ç─░FTL─░K ├£R├£NLER─░ GIDA PAZ. SAN.T.C.LTD.┼ŞT─░.	38.39403900	27.16056400	2
17216	2	D2K084095	NAVDAR SULTAN YILDIRIM - MY TEKEL MARKET	38.39622000	27.14859000	2
17217	2	020017976	NERG─░Z B├ûL├£K -KARDE┼ŞLER SPM.	38.40330500	27.15964600	2
17218	2	020054472	NERM─░N DEM─░R	38.39620400	27.15262900	2
17219	2	D2K119625	NESIM MARKET├çILIK SANAYI TICARET LIMITED SIRKETI - AKBA┼Ş MARKET	38.39802300	27.16345500	2
17220	2	D2K205169	NES─░M ERG├£L	38.40270330	27.14794040	2
17221	2	020014144	N─░YAZ─░ ├çET─░N - ├çET─░N ─░DDAA	38.40423400	27.16366800	2
17222	2	D2K205478	NURG├£L F─░L─░Z	38.39587710	27.14856990	2
17223	2	D2K167719	OSMAN AKKAYA	38.39744270	27.15998360	2
17224	2	020013604	OSMAN G├ûKSU	38.39328700	27.14827000	2
17225	2	020054630	├ûMER HATISARU	38.40420900	27.16542000	2
17226	2	D2K241204	├ûZLEM AKT├£RK	38.39593330	27.16450900	2
17227	2	D2K228290	PARANORMAL ┼ŞANS OYUNLARI.VE GIDA SAN.T─░C.LTD.┼ŞT─░.	38.40248740	27.16283420	2
17228	2	D2K135275	PA┼ŞA BALTA	38.40439700	27.15527370	2
17229	2	D2K227553	PEMBEG├£L KERDANLI	38.40043810	27.14949670	2
17230	2	020051483	RAMAZAN AYKIN	38.39310000	27.16820000	2
17231	2	D2K194510	RAMAZAN SO─ŞANCI	38.40269040	27.14646990	2
17232	2	D2K106906	RAS─░M ├ûZHALA├ç	38.39953600	27.15023100	2
17233	2	D2K217087	RUH─░ AKTA┼Ş	38.39417190	27.14643490	2
17234	2	D2K150630	R├£STEM AKAR	38.40319850	27.16116170	2
17235	2	020000239	SABR─░YE KEL	38.40384600	27.15667100	2
17236	2	D2K216331	SARI KARDE┼ŞLER GIDA TUR─░ZM ─░N┼Ş.OTOM. SAN. VE T─░C.LTD.┼ŞT─░.	38.40250470	27.16596830	2
17237	2	020054447	SELM─░YE B─░LG─░N	38.39506700	27.14821900	2
17238	2	D2K172777	SERDAL ├ûZDEM─░R	38.40489270	27.14831030	2
17239	2	D2K236413	SERHAN FIRAT	38.39862000	27.14861300	2
17240	2	D2K230079	SERHAT AYDIN	38.39496400	27.16240120	2
17241	2	D2K239948	SEVG─░ TA┼ŞKIN	38.39960380	27.14947960	2
17242	2	D2K230599	SEY AKARYAKIT ENERJ─░ SANAY─░ VE T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.40171940	27.14899680	2
17243	2	D2K199418	S─░MGO GIDA MARKET├ç─░L─░K ─░N┼ŞAAT TUR─░ZM TEKST─░L LTD.┼ŞT─░.	38.39333930	27.14841540	2
17244	2	D2K144732	S─░NAN AK├çAY	38.39619100	27.15474000	2
17245	2	D2K180441	S├£HEYLA ACAR	38.40244100	27.15331700	2
17246	2	D2K189557	┼ŞAD─░YE DE─Ş─░RMENC─░	38.40158600	27.16097540	2
17247	2	D2K128358	┼ŞEYDA KAPAR	38.39876770	27.15823540	2
17248	2	020017685	TANIL KAPTANCIK - KRAL TEKEL	38.39408920	27.14849730	2
17249	2	D2K201850	TOLUNAY YILMAZ	38.40605700	27.16744500	2
17250	2	D2K241376	U─ŞUR OYMAK	38.39898860	27.16974890	2
17251	2	020053269	VOLKAN A┼ŞICI, HUL├£S├£ MARKET	38.39824300	27.15335000	2
17252	2	D2K241057	VURAL YANARDA─Ş	42.94838100	34.13287400	2
17253	2	D2K210619	YAMANS GIDA SANAY─░ VE T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.39760700	27.15236200	2
17254	2	D2K149686	YASER HAYDARO─ŞLU	38.39813080	27.16327290	2
17255	2	020052657	YETER ├çEL─░K	38.40637700	27.16063200	2
17256	2	020001000	YUNUS ALTUN-BAKKAL─░YE	38.39932830	27.16362340	2
17257	2	020000060	YUSUF YAZAR - YAZAR MARKET	38.40283200	27.16992800	2
17258	2	020052922	ZEYCAN DEM─░RB├£KEN	38.40234500	27.16241500	2
17259	51	D2H000090	ABDULLAH G├ûKSU	38.07060700	27.21136500	2
17260	51	D2K209420	ABDULLAH SALAH─░ DEM─░RTA┼Ş	38.14090760	26.82547170	2
17261	51	D2K232217	ABDURRAHMAN BOTAN DA─Ş	38.07821500	26.95451200	2
17262	51	D2H197582	ADNAN KAZAN├çLI	38.01942000	27.09814700	2
17263	51	D2H146448	AHMET ├ç─░L─░NG─░R	38.06194570	27.00671820	2
17264	51	D2H187808	AHMET ├ûZKARADA─Ş	38.06032800	27.01288800	2
17265	51	D2K218492	AK─░F YORULMAZ	38.04948830	27.05569320	2
17266	51	D2H117847	ALAATT─░N KONUR	38.02168600	27.09004540	2
17267	51	D2H114662	ALDI MARKET ISLETMECILIGI HAY.TAR.GIDA INS.TUR.SAN.VE TIC.LTD.STI.BIR.	38.07528080	26.93013660	2
17268	51	D2K203808	AL─░ ├çINAR VE O─ŞULLARI GIDA ─░N┼Ş.TUR.TA┼Ş.SAN.T─░C.LDT.┼ŞT─░.	38.04990600	27.05170700	2
17269	51	D2H000744	AL─░ ENER	38.16661000	26.95203200	2
17270	51	D2H144819	ALPTEK─░N ─░N┼ŞAAT SANAY─░ VE T─░CARET ANON─░M ┼Ş─░RKET─░	38.08037100	26.96803800	2
17271	51	D2H107724	ALTERNAT─░F AMB. GIDA ├£R. VE PAZ. SAN. ─░├ç VE DI┼Ş T─░C. LTD.┼ŞT─░.-├ûZDERE	38.05301900	27.04737100	2
17272	51	D2H107725	ALTERNAT─░F AMB. GIDA ├£R. VE PAZ. SAN. ─░├ç VE DI┼Ş T─░C. LTD.┼ŞT─░.-├£RKMEZ	38.07837200	26.95068100	2
17273	51	D2H146315	AY┼ŞE ATIZ	38.07451780	27.01784580	2
17274	51	D2H182130	BA┼ŞDA┼Ş MARKET - ├ûZDERE	38.02612900	27.08347900	2
17275	51	D2K202229	BAYRAM ├ûZEL	37.99458460	27.18804590	2
17276	51	D2H000331	BEK─░R YE┼Ş─░LOVA	38.21641620	27.04409390	2
17277	51	D2K204991	B─░RG├£L ARTU├ç	38.07266700	27.01745100	2
17278	51	D2H001876	BURAK GEM─░C─░	38.02932860	27.08083190	2
17279	51	D20001705	CEMAL AKBULUT	37.98797500	27.23919600	2
17280	51	D2H142593	CEM─░L PELTEK	38.17967300	26.83483700	2
17281	51	D2K216905	CEVAT DEM─░RKANAT	38.07945430	26.96011370	2
17282	51	D2K233788	├çA─ŞRI ├çALI┼ŞKAN	38.10264060	27.15517190	2
17283	51	020035639	DEMAR GIDA TRUZ.─░N┼Ş.NAK.T─░C.LTD.┼ŞT─░.	38.07416900	26.98430000	2
17284	51	D2K201146	DORUK T─░KEN	38.06247200	27.00946700	2
17285	51	D2K241958	EGE CAN LANLAN	38.07925890	26.95801550	2
17286	51	D2K205920	EM─░N SARPA┼ŞAN	38.17568800	26.80333360	2
17287	51	D2H097604	EM─░N ├£├çTEPE	38.11466300	27.13980100	2
17288	51	D2H000207	ERCAN ├çOBAN	38.09177800	27.16625500	2
17289	51	D2K230435	ERKAN DERE	38.10249340	27.15633190	2
17290	51	D2K219273	ERKAN I┼ŞIK	38.11422060	27.13933480	2
17291	51	D2H000800	ETHEM PEK├çAKAR	38.18478700	26.96875500	2
17292	51	D2H112725	EY├£P K─░RAZ	38.15007100	27.17927490	2
17293	51	D2K226230	FATMA TORUN	38.13231490	27.23668640	2
17294	51	D2H000147	FAY─░KA TAY┼Ş─░	38.07382700	27.01824800	2
17295	51	D2H111673	FERDAN AYDIN	38.12216740	27.14117330	2
17296	51	D2H156119	FERHAT TUTMU┼Ş	38.14994000	27.17959500	2
17297	51	D2H135498	FIRAT E─Ş─░N	38.12717700	27.14373500	2
17298	51	D2H174424	F─░L─░Z TANI┼ŞMAN	38.07813400	26.95585300	2
17299	51	D2H041709	GAMZE ├çELG─░N	38.05086200	27.05415400	2
17300	51	D2H129114	GAMZE ├çELG─░N-2	38.02155980	27.09357250	2
17301	51	D2K224517	G├ûKHAN D├£ZDA┼ŞLIK	38.10258360	27.16174950	2
17302	51	D2H036528	G├ûKSEL SARIKAYA	38.13793610	27.16129600	2
17303	51	D2K220908	G├£M├£LD├£R ET PAZARI GIDA HAYVANCILIK ─░N┼Ş.TUR.NAK.SAN VE T─░C.LTD.┼ŞT─░.	38.07085340	27.01638830	2
17304	51	020035700	G├£RCAN LANLAN	38.07928930	26.95828040	2
17305	51	D2H043473	HAKKI PEK├çAKAR	38.16799900	26.95387800	2
17306	51	D2H027835	HAL─░L ├çELG─░N	38.15018100	27.17936900	2
17307	51	D2H001143	HAL─░L ─░BRAH─░M HAMARAT	38.16759840	26.95312980	2
17308	51	D2K228026	HAL─░L YAN├ç	38.07203300	26.91978100	2
17309	51	D2K238583	HAL─░L─░BRAH─░M KAYA	37.99777000	27.18877100	2
17310	51	D2H000229	HASAN SEVER	38.14981500	27.17921400	2
17311	51	D2H096842	HAS─░BE AKG├£L	38.05341130	27.04686040	2
17312	51	D2H193355	HAT─░CE G├£LTEK─░N G├£R─ŞAN	38.16039750	26.82345720	2
17313	51	D2H000669	HAT─░CE KALALI	38.05882000	27.01191600	2
17314	51	D2H000155	H├£LYA ERS├ûZ	38.15147500	27.15331200	2
17315	51	D2H001932	H├£LYA KAVRAN	38.07448900	26.93053300	2
17316	51	D2H002165	H├£SEY─░N B─░LG─░	38.07639020	26.95722140	2
17317	51	D2H025868	H├£SEY─░N ERDO─ŞAN	38.01564470	27.10238880	2
17318	51	D2K212563	H├£SEY─░N ├ûZL├£	38.13193700	27.23645600	2
17319	51	D2H025869	II.ABDULLAH KO├çAK GIDA ─░N┼Ş.TURZ.─░TH.─░HR.NAK.SAN.T─░C.LTD.┼ŞT─░.	38.07165700	27.01657400	2
17320	51	D2H149049	II.GIDACI DAYANIKLI T├£KET─░M MAL.─░N┼Ş.GIDA.TUR─░ZM. HAY.SAN.VET─░C.LTD. ┼ŞT	38.07258360	27.01758720	2
17321	51	D2H035325	II.NURULLAH ERTEK PETROL VE PETROL ├£R├£NLER─░ LTD.┼ŞT─░.	38.08780900	27.18360000	2
17322	51	D2K229917	II.┼ŞAFAK AKHARMAN	38.05887200	26.88752100	2
17323	51	D2K232066	─░BRAH─░M G├ûK├çE	38.01791400	27.09216500	2
17324	51	D2H000870	─░BRAH─░M KESK─░N	38.06223030	27.00651850	2
17325	51	D2H049600	─░BRAH─░M MURAT G├£LC├£	38.03207000	27.24239200	2
17326	51	D2H125452	─░LYAZ YILMAZ	38.10260200	27.16110000	2
17327	51	D2H168078	─░SMA─░L DUYAR	38.07659400	26.93412400	2
17328	51	D2H180207	─░SMA─░L TOKATLI	37.99418680	27.18789660	2
17329	51	D2H000872	KADR─░ BARDAK├çI	38.07580000	26.96790000	2
17330	51	D2H057092	KAM─░L ├çOKGEN├ç	38.16116400	26.82359600	2
17331	51	D2H000182	KASAPO─ŞULLARI LTD.┼ŞT─░.	37.99227300	27.18862400	2
17332	51	D2H172182	KIRLIO─ŞLU ─░N┼Ş. NAK. GIDA TARIM OYUN SAL. B─░LG. H─░Z. SAN. T─░C. LTD.	38.09916850	27.16397740	2
17333	51	020035632	M.SAL─░H YILMAZ	38.06135510	27.00762600	2
17334	51	D2H000694	MEHMET AL─░ DO─ŞRU	38.07605500	26.96830200	2
17335	51	D2K198876	MEHMET ATIZ	38.07806920	26.94942750	2
17336	51	D2H000700	MEHMET FAHRETT─░N BOYNUKALIN	38.07553370	26.92761940	2
17337	51	D2H011454	MEHMET MET─░N HEZER	38.18802850	26.97127630	2
17338	51	D2K201097	MEHMET SOYUCAK	38.11471310	27.13982270	2
17339	51	D2H013295	MEHMET ┼ŞERENL─░	38.14997000	27.17980000	2
17340	51	D2H186104	MENDERES YLC AKARYAKIT GIDA ─░N┼ŞAAT SANAY─░ VE T─░CARET LTD. ┼ŞT─░	38.16381980	27.15698170	2
17341	51	D2H118192	MESUT ├çA─ŞLAR	38.07954840	27.01712740	2
17342	51	D2H045155	MUAMMER G├£LMEZ	37.98731500	27.17822700	2
17343	51	D2H000186	MUAMMER ULUKAYA	38.07282000	26.98870500	2
17344	51	D2H193179	MUHAMMET G├£LTA┼Ş	38.06500100	26.90710500	2
17345	51	D2H121451	MUHARREM ├ûZT├£RK	38.07268220	26.92425370	2
17346	51	D2K241052	MURAT DO─ŞAN	42.94838100	34.13287400	2
17347	51	D2H089621	MUSTAFA I┼ŞIK	38.06585860	26.85578950	2
17348	51	D2H082990	MUSTAFA MIZRAK	38.07680700	27.02169800	2
17349	51	D2H002284	MUZAFFER C─░HAY	38.16833200	26.80877000	2
17350	51	D2H083670	M├£M─░M CAN G├ûN├£LTA┼Ş	38.09370700	27.16711400	2
17351	51	D2H000315	NAZIM ┼ŞEN	38.07667400	26.98879700	2
17352	51	D2H001551	NECDET REN├çBER	38.14244000	27.16733500	2
17353	51	D2H000688	NES─░BE S─░YER	38.15589500	26.82600900	2
17354	51	D2K203981	N─░DA TOKLU	38.08012350	26.95608330	2
17355	51	D2H155061	NURBEN G├£NG├ûR	38.07406290	26.91656760	2
17356	51	D2H160700	O─ŞUZ KARAN	38.02163280	27.09398030	2
17357	51	D2H016324	OZAN S├£R├£C├£O─ŞLU	38.07623500	26.94352500	2
17358	51	D2H120273	├ûMER ORMAN	38.02357820	27.18616540	2
17359	51	D2H000221	├ûZDERE ├ç─░├çEK PETROL LTD.┼ŞT─░.	38.00340000	27.12240000	2
17360	51	020035103	├ûZDERE ├ûZKANLAR PETROL SAN.TIC.LTD.STI.	38.04750500	27.05592600	2
17361	51	D2K232253	PARAMOUNT GIDA ├£R├£NLER─░ OTOMOT─░V ─░N┼Ş.KOZMET─░K MED─░KAL SAN.VE T─░C.LTD.┼Ş	38.07978900	26.95701500	2
17362	51	D2H147393	RAMAZAN KAYAN	38.09136100	27.16631500	2
17363	51	D2H041102	RECEP KORKMAZ	38.07207250	26.91687460	2
17364	51	D2H031195	RIZA KAYA	38.07426900	26.98406700	2
17365	51	D2H187552	SAADET YETK─░N	38.16105130	26.82308430	2
17366	51	D2K233506	SAL─░M ARPACIKLI	38.09177060	27.16621800	2
17367	51	D2K216440	SAM─░ SAYGIN	38.08938430	27.22756150	2
17368	51	D2H022144	SARIKAYA AKARYAKIT ├£R├£NLER─░ VE GIDA T─░CARET LTD. ┼ŞT─░.	38.15773400	27.15626900	2
17369	51	D2H149470	SEDAT ├çEL─░KUS	38.15189800	26.83033380	2
17370	51	D2H000225	SELAM─░ Y├£CE	38.11450600	27.13954300	2
17371	51	D2K214347	SELVET ├çAKIRCA	38.08578600	26.86615000	2
17372	51	D2H001866	SEMAHAR POLAT	38.06837500	26.90048400	2
17373	51	D2K233794	SENEM ├ûZ	38.04854060	27.05341580	2
17374	51	D2H135601	SERHAT D├£ZG├£N	38.04691870	27.19337110	2
17375	51	D2H166447	SERHAT SARI	38.07889200	26.96112960	2
17376	51	D2K235913	SEVAL E┼ŞS─░Z	38.10252100	27.15562170	2
17377	51	020035109	SEVG─░ TELL─░	38.01510100	27.12754000	2
17378	51	D2K232713	SEV─░L AYDEM─░R 2	38.14763680	26.82643730	2
17379	51	D2H174633	SEZG─░N ERYILMAZ	38.02574750	27.08364260	2
17380	51	D2K236260	SULTAN DEM─░RC─░	38.14463300	26.82721000	2
17381	51	D2H141593	SULTAN ├û─ŞMEN	38.01592500	27.12848100	2
17382	51	020035704	SUNA GIDA ├£R├£NLER─░ NAKL─░YAT TUR.SAN.T─░C.LTD.┼ŞT─░.	38.07810400	26.95663600	2
17383	51	D2K230473	S├£MRAN EVC─░MENSOY ├çAY	38.07464740	27.01762330	2
17384	51	D2H185151	┼ŞENG├£L DURAN	38.08570230	27.01444820	2
17385	51	D2H000807	TAH─░R DUR─ŞA├ç	38.21637900	27.04443200	2
17386	51	D2K234413	TAYFUN AYTEK─░N	38.07382300	26.92687000	2
17387	51	D2K218667	TU─Ş├çE BORA	38.05586100	27.02077300	2
17388	51	D2H036481	T├£L─░N BA┼Ş	38.10295700	27.16070000	2
17389	51	020035588	U├çAK KARDESLER BENZIN IST.	38.17747700	26.83147800	2
17390	51	D2K240602	U─ŞUR CANKILI├ç	38.13508100	26.83467600	2
17391	51	D2K217418	├£M─░T BACAKSIZ	38.01373800	27.12608500	2
17392	51	D2H041340	VOLKAN U├çMAZ	38.05955440	27.01249840	2
17393	51	D2K242446	YARDIMCIO─ŞLU ─░N┼ŞAAT TAAH.TARIM VE GIDA ├£R.PAZ.SAN.VE T─░C. LTD. ┼ŞT─░.	42.94838100	34.13287400	2
17394	51	D2H184605	YA┼ŞAR G├£LTA┼Ş	38.08594240	26.86700350	2
17395	51	D2H088733	YAVUZ TURAL	38.07376610	26.98608290	2
17396	51	020035686	YEL─░Z HO┼Ş	38.07927500	26.95728300	2
17397	3	020051327	ABDULBAS─░T DO─ŞAN	38.40592500	27.12188100	2
17398	3	020003483	ABDULLAH TATI┼Ş	38.40609900	27.11880900	2
17399	3	D2H152615	ABUBEK─░R BALTAKESEN	38.41292900	27.12856100	2
17400	3	020046182	ACEM GIDA ─░N┼Ş.TUR.SAN.T─░C.LTD.┼ŞT─░. - Bah├ğelievler-	38.40406800	27.12179700	2
17401	3	020052759	ACEM GIDA ─░N┼Ş.TUR.SAN.T─░C.LTD.┼ŞT─░. - Hatay-	38.40150360	27.10330710	2
17402	3	D2H191252	ADEM KIRMIZITA┼Ş	38.40234400	27.10484900	2
17403	3	020003285	ADNAN AYDIN- MARKET ─░┼ŞLETMES─░	38.40064300	27.10880100	2
17404	3	020054738	AHMET G├£NDOGDU GIDA LTD.STI. - AHMET G├£NDO─ŞDU GIDA LTD.┼ŞT─░.	38.40649520	27.11532310	2
17405	3	020012500	AHMET YALGIN-NEZ─░H YALGIN AD─░ ORTAKLI─ŞI	38.40135940	27.10505610	2
17406	3	D2H165555	AL─░ ER─░CEK	38.40358800	27.12018080	2
17407	3	D2H121474	AL─░ OSMAN YA┼ŞAR	38.40731000	27.12397800	2
17408	3	020016068	AL─░ TEVF─░K KARADEN─░Z	38.40293990	27.10558440	2
17409	3	D2H164695	ALTINCEZVE ALKOLL├£ VE ALKOLS├£Z ─░├çECEKLER K.YEM─░┼Ş GIDA MAD.PAZ.T─░C.LTD.	38.40606720	27.11918200	2
17410	3	020045226	ASUMAN G├ûKMEN	38.40393580	27.11841240	2
17411	3	020005763	AT─░LLA ├çULHA-├çITIR B├£FE	38.40169420	27.10106070	2
17412	3	D2K201594	AYNUR MU┼ŞTU	38.40036800	27.10605000	2
17413	3	D2H154442	BA┼ŞDA┼Ş MARKET - HATAY	38.40160950	27.10122460	2
17414	3	D2K233694	BA┼ŞDA┼Ş MARKET-─░ZM─░RSPOR	38.40401620	27.11907690	2
17415	3	D2H192979	BROTHERS MARKET INSAAT SANAYI TICARET LIMITED SIRKETI	38.40311360	27.10827380	2
17416	3	D2H195447	BURAK ┼ŞAHNA	38.41053700	27.12539100	2
17417	3	020005040	CANAN ATE┼Ş	38.40300130	27.09761560	2
17418	3	020000699	C├£NEYT ARAL	38.40135500	27.11349300	2
17419	3	D2H196821	├çA─ŞLAR KIRIM┼ŞEL─░O─ŞLU	38.40665300	27.12093800	2
17420	3	020016144	DELF─░N MARKET├ç─░L─░K TUR.DAY.T├£K.MAL.T─░C.LTD.┼ŞT─░.	38.40311260	27.10542410	2
17421	3	D2K222972	DEMET ALTINCEZVE	38.40606100	27.11524060	2
17422	3	D2H196350	DEN─░Z CO┼ŞAN	38.40251500	27.11429310	2
17423	3	020052014	DEN─░Z EGE ├ûZDEM─░R	38.40609300	27.11861700	2
17424	3	020058405	DEN─░Z KAYA	38.40837400	27.12657800	2
17425	3	D2H193178	D─░LARA KAYA	38.40526900	27.11177100	2
17426	3	D2K199293	DO─ŞA KURT	38.41048000	27.12737400	2
17427	3	D2K226168	EBRU AKIN	38.40173790	27.11058730	2
17428	3	D2H146460	EM─░NE SA─ŞLAM	38.40390200	27.10232700	2
17429	3	D2K229906	EM─░NE ┼ŞULE EL├ç─░	38.40065410	27.10618640	2
17430	3	020052397	ERCAN I┼ŞIKHAN	38.40471100	27.12143600	2
17431	3	020013399	ERG─░N ├çA─ŞRI AKTA┼Ş-├çA─ŞRI MARKET	38.40535000	27.10831700	2
17432	3	020016045	ERKAN AKPINAR -G├£LCEYLAN ┼ŞARK├£TER─░	38.40289700	27.12030300	2
17433	3	020018437	FATMA G├£LER	38.40142350	27.10562830	2
17434	3	020058365	FERD─░ KONU┼Ş	38.40355820	27.11735580	2
17435	3	020054087	FERHAT ARATLI	38.40939540	27.12381570	2
17436	3	D2K242753	FEYYAZ NERG─░S	38.40920780	27.12728970	2
17437	3	D2K242709	F─░L─░Z H─░SAR	42.94838100	34.13287400	2
17438	3	D2K228507	G├ûK SEN─░N GIDA LTD. ┼ŞT─░. - CAFERO─ŞLU ┼ŞUBES─░	38.40366540	27.10441140	2
17439	3	020045523	G├ûKHAN ERDEM	38.40660800	27.12265400	2
17440	3	D2K202060	G├£LER ATILGAN	38.40890470	27.12533620	2
17441	3	020055307	G├£LER ├çALI┼ŞKAN	38.40485100	27.11184800	2
17442	3	D2H175795	G├£LS├£M D├£NDAR	38.40409750	27.10790610	2
17443	3	020049039	HAL─░T DA┼Ş	38.40446800	27.11917400	2
17444	3	D2K211421	HARUN BUHURCU	38.40064310	27.09746750	2
17445	3	D2H169376	HASAN AKSAL	38.40822700	27.12594000	2
17446	3	D2K240643	HASAN ┼ŞEN├ûZH├£R 2	38.40243320	27.10546950	2
17447	3	020048245	HAT─░CE BOMBAY-─░LKADIM MARKET	38.40617670	27.11790490	2
17448	3	020053144	HAYRETT─░N SARIKAYA / SEDEF MARKET	38.39805510	27.09341860	2
17449	3	D2K242006	H─░LAL ─░G├£S	38.40325870	27.11638040	2
17450	3	020016165	H├£SEY─░N G├£RKAN	38.40100100	27.10422400	2
17451	3	020058308	H├£SEY─░N ┼ŞENG├£L	38.40458100	27.11872600	2
17452	3	D2K204102	H├£SN├£ DERMENC─░O─ŞLU	38.40603560	27.11417960	2
17453	3	D2H179997	II.SAKUR ORGAN─░ZASYON GIDA TUR─░ZM SAN.VE T─░C.LTD.┼ŞT─░.	38.40748950	27.12525000	2
17454	3	020000108	─░BRAH─░M KALAYCIO─ŞLU	38.40343820	27.10374920	2
17455	3	D2K234694	─░BRAH─░M KARABAY	38.41219830	27.12921910	2
17456	3	020004621	─░MAM DO─ŞAN	38.40393280	27.11070210	2
17457	3	D2K234673	─░SA BOR	38.40173260	27.10886370	2
17458	3	D2H169832	─░SMA─░L ├ûZG─░RESUN	38.40143570	27.10545990	2
17459	3	020046681	KADIO─ŞLU MARKET GIDA TUR─░ZM LTD. ┼ŞT─░. (┼ŞB)	38.40154000	27.11142500	2
17460	3	020048596	KADR─░ BARDAK├çI-BARDAK├çI GIDA AMBALAJ	38.40464500	27.12084000	2
17461	3	D2K212815	KAMER EREL	38.40625760	27.12006370	2
17462	3	020052341	KEVSER ├ûZKAPU	38.40566600	27.11000600	2
17463	3	D2K211422	KOCAERLER AKARYAKIT ─░N┼Ş.OTO.NAKL─░YE A┼Ş.	38.40268350	27.11356210	2
17464	3	D2H170549	KULE RESTORAN ─░┼ŞLETMEC─░L─░─Ş─░ SANAY─░ T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.39993210	27.09783500	2
17465	3	D2H185081	LAM─░A MACAR	38.40906100	27.12755900	2
17466	3	020002855	MAKBULE BULUT	38.40612100	27.11715500	2
17467	3	D2K234324	MAZLUM AKSOY	38.40472800	27.11794300	2
17468	3	D2K225251	MEHMET AD─░L YALMAN	38.40539880	27.11915250	2
17469	3	020016135	MEHMET ├çORUH	38.40388830	27.10342200	2
17470	3	020057214	MEHMET EM─░N ├ûTGEN	38.40623300	27.11949100	2
17471	3	D2K205552	MEHMET FEDAY─░ AKTA┼Ş	38.40176100	27.10970000	2
17472	3	020050869	MEHMET KILI├ç	38.41098770	27.12406380	2
17473	3	D2K234049	MEHMET TA┼Ş	38.40584710	27.10557050	2
17474	3	D2H134999	MERTCAN TOK	38.40791910	27.12558080	2
17475	3	D2K207879	MERYEM DUMAN	38.40857800	27.12675100	2
17476	3	D2K233511	M─░HD─░YE S─░NCAR	38.40772490	27.12492120	2
17477	3	020051479	MTL TEM─░ZL─░K GIDA TEKS.TURZ.SAN.VE T─░C.LTD.┼ŞT─░.	38.40603000	27.11732700	2
17478	3	D2K207829	MUHAMMET BURAK KAYRAN	38.39780200	27.09456700	2
17479	3	020056682	MUHAMMET ESER	38.40216750	27.10411260	2
17480	3	020004836	MUHAMMET HAT─░PO─ŞLU-HAT─░PO─ŞLU MARKET	38.40032280	27.09659040	2
17481	3	D2K237478	MUHARREM BEKMEZC─░	38.40184600	27.09861650	2
17482	3	D2K223909	MUSTAFA ├ûZT├£RKO─ŞLU	38.40308530	27.11342660	2
17483	3	020000184	MUSTAFA S├£RG─░T-─░K─░ZLER MARKET	38.40618390	27.11508430	2
17484	3	020053681	NAZM─░YE KARAG├ûZ	38.41056400	27.12668900	2
17485	3	020052357	NECAT─░ ├ûZDEM─░R	38.40660200	27.10985900	2
17486	3	020054690	NER─░MAN AKAR	38.40539220	27.10130750	2
17487	3	D2K234780	N─░HAT CAFCAV	38.40433580	27.10861340	2
17488	3	D2K229042	NOKTA PROMIL TEKEL GIDA VE DANISMANLIK SANAYI TICARET LIMITED SIRKETI	38.40104490	27.10666330	2
17489	3	020007792	NURULLAH SATAN-ALPER B├£FE	38.40201610	27.11220110	2
17490	3	D2K219449	O─ŞUZHAN MUSLU	38.40576080	27.12100080	2
17491	3	020053829	ORHAN ├ûZT├£RK	38.40331700	27.11670900	2
17492	3	020057366	OSMAN AHMET	38.40268500	27.10559500	2
17493	3	020058367	PELDA KAYA	38.40186500	27.11087900	2
17494	3	D2K234865	REMZ─░YE OKATAN	38.40797900	27.12563820	2
17495	3	D2H163829	ROTTERDAM GIDA T├£T├£N VE ALKOLL├£ ─░├çECEKLER SANAY─░ T─░CARET L─░M─░TED ┼Ş─░RKE	38.40405040	27.11683730	2
17496	3	020015981	SAB─░T KALAY-BAHAR ├çEREZ	38.40244430	27.10554970	2
17497	3	D2K232214	SEDAT YILDIRIM	38.39859730	27.09508290	2
17498	3	020015936	SELAHATT─░N ALKI┼Ş -SE├çK─░N ┼ŞARK├£TER─░	38.40089300	27.10857000	2
17499	3	D2K242002	SELEN KIRANTEPE KARAKA┼Ş	38.40112770	27.10878870	2
17500	3	020046640	SER KIRTAS─░YE GIDA LTD. ┼ŞT─░.	38.40610200	27.12103800	2
17501	3	020044640	┼ŞER─░F TANBO─ŞA-MAV─░┼Ş B├£FE	38.40590400	27.12063600	2
17502	3	D2H164978	TAMER S├£R├£C├£O─ŞLU	38.40633110	27.10566900	2
17503	3	D2K242041	UMUT SASA	38.40426050	27.11350460	2
17504	3	D2K211420	UYGAR ULA┼Ş ├ûZEN	38.40147090	27.10155780	2
17505	3	020046519	├£MRAN G├ûRG├£	38.40122350	27.11002910	2
17506	3	D2H176369	VEYS─░ AKG├£ND├£Z	38.40585500	27.12213700	2
17507	3	020045039	YA┼ŞAR BARI┼Ş	38.40117400	27.09930300	2
17508	3	020050750	ZAFER ARIKAN - KARDE┼ŞLER GIDA	38.40161150	27.10178540	2
17509	3	020056305	ZEK─░ ARAL	38.40217430	27.10623220	2
17510	8	020014687	ABDULKAD─░R ├ûZTEK─░N	38.41937600	27.14223600	2
17511	8	020050510	ABDURRAHMAN AK├çEKOCE	38.40068800	27.12911300	2
17512	8	D2K230998	ABD├£LSELAM AKALAN	38.40694390	27.13568460	2
17513	8	020044737	AD─░L ACAR	38.41587300	27.13684700	2
17514	8	D2K221986	AHMAD ─░B─░┼ŞKO	38.41084140	27.13658830	2
17515	8	020015238	AHMET ─░LHAN	38.41562500	27.14667400	2
17516	8	D2K212941	AHMET KAVAK	38.40525570	27.13716730	2
17517	8	D2H114983	AHMET KIRBA├ç	38.40067100	27.13060100	2
17518	8	D2H172128	AHMET YILDIRIM	38.40779640	27.13767710	2
17519	8	020052983	AL─░ MO─ŞUL	38.42116160	27.13944760	2
17520	8	D2H181491	AT─░LLA ERG─░N	38.40950870	27.12952190	2
17521	8	D2H069204	AYSUN D─░KEN	38.39727220	27.13352060	2
17522	8	D2K235828	AZ─░Z BALIN	38.41509020	27.14790790	2
17523	8	D2H148757	AZ─░Z B─░R├çEK	38.40391900	27.13754300	2
17524	8	020051683	BAKKALLA┼Ş GIDA ─░N┼Ş.T├£T├£N VE T├£T├£N MAM.ALKOLL├£ VE ALKOLS├£Z ─░├ç. PAZ.SAN.	\N	\N	2
17525	8	020012264	BA┼ŞDA┼Ş MARKET - YAPICIO─ŞLU	38.41182100	27.13591000	2
17526	8	D2H135370	BEHCET ├çEL─░K	38.41568100	27.13775600	2
17527	8	020006014	BEH─░YE NOHUT	38.40520400	27.13664600	2
17528	8	020052746	B─░LAL KERELT─░	38.41840100	27.13588000	2
17529	8	020015213	B─░LG─░NO─ŞLU GIDA T─░CARET VE ─░N┼Ş.SAN.LTD.┼ŞT─░.	38.40828500	27.12786900	2
17530	8	D2H148765	B─░RL─░K MARKET├ç─░L─░K T─░C.LTD.┼ŞT─░.-2	38.40751070	27.13620820	2
17531	8	020015298	CANAN SANS OYUNLARI TIC. LTD. STI.	38.40803400	27.12841900	2
17532	8	020044733	CEMAL ERTAN	38.40717400	27.13969300	2
17533	8	020018992	CEM─░L S├£L├£MBOZ	38.41599300	27.14077900	2
17534	8	D2K211419	C─░HANG─░R TOPRAKCI	38.42033110	27.13887860	2
17535	8	020047731	├çELEB─░ BARI┼Ş	38.40688670	27.13019750	2
17536	8	D2H179601	ED─░P DEM─░R	38.42131920	27.14883970	2
17537	8	D2H069676	EM─░NE YEN─░G├£N	38.41993900	27.14968300	2
17538	8	D2H125942	EMRAH ACAR	38.40158000	27.13042200	2
17539	8	020052455	ERDO─ŞAN BALA	38.39949200	27.13124500	2
17540	8	020046742	ERDO─ŞAN DALMI┼Ş	38.40782400	27.14250300	2
17541	8	D2H092091	ERHAN U─ŞUR	38.40772200	27.13513500	2
17542	8	020014685	ETHEM YILMAZ BAY─░─░	38.42054400	27.14290600	2
17543	8	D2H079332	FEDA─░ DAYAR	38.41191200	27.13669900	2
17544	8	020007242	FEHM─░ AKSARI	38.41002000	27.13925400	2
17545	8	020046775	F─░L─░Z ├çEL─░KKANAT	38.40765200	27.12981300	2
17546	8	D2H163853	HAB─░B D├£Z	38.41286520	27.13574590	2
17547	8	D2K218304	HACER ├ûZYURT	38.40759300	27.13164130	2
17548	8	D2H142941	HACI MURAT AKDEM─░R	38.41318250	27.13728700	2
17549	8	D2H124641	HAKKI ├ûZCAN	38.40910500	27.14896900	2
17550	8	D2K227881	HAL─░L YELKEN	38.41968740	27.14533160	2
17551	8	020014645	HAL─░T YILMAZ	38.42070000	27.14355100	2
17552	8	D2K227057	HAM─░T TUN├ç	38.41857860	27.13950000	2
17553	8	D2H111285	HASAN KAYA	38.40707200	27.14027800	2
17554	8	020008804	HASAN YILMAZ	38.40812400	27.14160500	2
17555	8	020007922	HAVVA G├£REL	38.41299090	27.13901130	2
17556	8	D2K235986	HEDEF GROUP OTO K─░RALAMA OTOMOT─░V TA┼Ş.NAK.TUR.─░N┼Ş.TEKST─░L SAN. VE T─░C.	38.39821170	27.13158650	2
17557	8	020004784	HIDIR BARUT	38.41399600	27.15299800	2
17558	8	020006933	H├£SEY─░N O─ŞUL	38.41799600	27.14938700	2
17559	8	D2H134963	II.MEHMET KAYMAZ	38.40505420	27.13875770	2
17560	8	D2H135567	II.MURAT ALTO─Ş	38.40398400	27.13469700	2
17561	8	020049826	─░BRAH─░M AYDEN─░Z	38.40335910	27.13549220	2
17562	8	D2H130594	─░BRAH─░M AYHAN	38.40440200	27.13329600	2
17563	8	D2H139877	─░BRAH─░M AYHAN-2	38.41119550	27.13240850	2
17564	8	D2K233478	─░BRAH─░M KAMALI	38.39802580	27.13398420	2
17565	8	D2H083043	─░BRAH─░M ├ûZ┼ŞENLER	38.40843000	27.12869900	2
17566	8	020050550	─░MREN TEM─░Z	38.40223800	27.13416000	2
17567	8	D2H092476	─░SMA─░L KARACA	38.40444840	27.12933430	2
17568	8	020003806	─░SMA─░L KARACA- B─░Z─░M MARKET	38.40741900	27.14371840	2
17569	8	D2H099684	KAD─░R DEDER	38.41498400	27.13579000	2
17570	8	D2K208024	KAD─░R GE├çER	38.42132210	27.14041580	2
17571	8	D2H116039	KADR─░ ATA┼Ş	38.41587000	27.13811400	2
17572	8	D2H132664	KAM─░L D─░LEK	38.40784320	27.12822580	2
17573	8	D2H182834	KEMAL TEK─░N	38.40377120	27.13379280	2
17574	8	020009358	M.ZEK─░ ├ûZTEK─░N	38.41745900	27.13830600	2
17575	8	020054939	MAHSUM AKA	38.41053300	27.13320600	2
17576	8	020004664	MEHMET AL─░ OSKAN	38.41763920	27.14725820	2
17577	8	020052336	MEHMET AL─░ ├ûTGEN	38.41959310	27.13669700	2
17578	8	020047283	MEHMET ARI	38.41909200	27.14606200	2
17579	8	D2H133883	MEHMET AYDEM─░R	38.41347720	27.13773540	2
17580	8	D2K207979	MEHMET BEK─░R SEV─░M	38.41182050	27.13339280	2
17581	8	D2H198312	MEHMET BULU┼Ş	38.41765000	27.14614700	2
17582	8	020000414	MEHMET CEM─░L AKTA┼Ş	38.41345000	27.14327500	2
17583	8	D2H160638	MEHMET EM─░N AKAN	38.40838400	27.13560200	2
17584	8	D2H197682	MEHMET EM─░N AYDIN	38.40486440	27.13424220	2
17585	8	020000441	MEHMET KAYMAZ	38.40671400	27.13471700	2
17586	8	020052142	MEHMET SA─░T AY	38.41715300	27.14911500	2
17587	8	020006479	MEHMET SEL─░M TOKAY	38.41370300	27.14362700	2
17588	8	020049312	MEHMET SEVDAN	38.41609800	27.13578200	2
17589	8	020006552	MEHMET SEV─░ND─░	38.41190100	27.13699200	2
17590	8	020010181	MEHMET ┼Ş├£KR├£ AY	38.42052640	27.14193090	2
17591	8	020052884	MELEK BI├çAK	38.40754200	27.13708000	2
17592	8	D2K211984	MEL─░SA NUR KULA	38.41724440	27.14754910	2
17593	8	D2H136804	MERTCAN NURALEV	38.42181150	27.13739210	2
17594	8	D2H145154	MESUT YAVUZ	38.40580770	27.12936610	2
17595	8	D2H153801	M─░RAY ├ûZKAVAN├ç	38.41908390	27.15291340	2
17596	8	020045060	MUAMMER YORULMAZ	38.40031200	27.13093800	2
17597	8	020015224	MUHAMMET ├çINARCIK	38.41531600	27.13765100	2
17598	8	D2H175297	MUHTEREM MEDEN─░	38.40807700	27.12843400	2
17599	8	D2H071064	MURAT KARAHAN	38.41657000	27.15171100	2
17600	8	D2H160430	MUSA TANBO─ŞA	38.40642600	27.13961400	2
17601	8	020010691	MUSTAFA KILI├ç	38.41433200	27.15183800	2
17602	8	020004309	NED─░M DO─ŞANER	38.40881200	27.12998400	2
17603	8	D2K214889	NESL─░HAN ALBAYRAK	38.42069530	27.14704340	2
17604	8	020002945	NURAY AKY├£Z	38.41737870	27.13639110	2
17605	8	D2H120583	NURAY D├ûNMEZ	38.40251100	27.13057200	2
17606	8	D2H126130	NURSEL ALPA─ŞAT	38.40940250	27.13801210	2
17607	8	D2K210861	O─ŞUZ ├ûZDEM─░R	38.40091000	27.12901700	2
17608	8	D2H082577	OSMAN H├£LAK├£	38.41071100	27.13602300	2
17609	8	020014858	├ûMER YEN─░G├£N	38.41858490	27.14162080	2
17610	8	D2H100411	RAMAZAN SA─ŞLAM	38.42111520	27.15208780	2
17611	8	D2H184341	SAB─ŞATULLAH TUN├ç	38.41041280	27.13225080	2
17612	8	D2H175973	SAB─░HA ATE┼ŞO─ŞLU	38.41314130	27.15441410	2
17613	8	D2H088330	SADAT AZ─░ZO─ŞLU	38.42214100	27.13803100	2
17614	8	020047259	SARIKAYA MA─Ş. LTD. ┼ŞT─░.	38.40222800	27.12920600	2
17615	8	020010637	SELEHATT─░N SA─░T	38.41634200	27.15102600	2
17616	8	020047622	SEL─░M YEN─░G├£N	38.41505310	27.13563060	2
17617	8	020052705	SEM─░RA ├ûTGEN	38.41599700	27.13525400	2
17618	8	020044869	SERKAN K├ûK├ç├£	38.40146100	27.13047100	2
17619	8	020014716	SEZ-KAR GIDA SAN.T─░C.LTD. ┼ŞT─░.	38.42060740	27.14308900	2
17620	8	D2H161319	SONG├£L BOMBAY	38.40254340	27.13000870	2
17621	8	D2H088325	SUZAN DE─Ş─░RMENC─░	38.41199300	27.15501400	2
17622	8	D2K239322	┼ŞABAN ├çAKICI	38.40426930	27.13621490	2
17623	8	D2H139271	┼Ş├£KR├£ ACAR	38.40855830	27.13579170	2
17624	8	D2K205550	TAKAK GIDA A.┼Ş	38.40510580	27.13209150	2
17625	8	D2H111670	TANKAR OTOMOT─░V PETROL GIDA H─░Z.SAN.T─░C.LTD.┼ŞT─░.-YE┼Ş─░LDERE	38.39574400	27.13529600	2
17626	8	020009651	TEK─░N GIDA ├£R├£NLER─░ SAN. VE T─░C. LTD.┼ŞT─░.	38.41429800	27.13780700	2
17627	8	D2H132996	VEHB─░YE AKBALIK	38.40910580	27.13832030	2
17628	8	D2K239334	YAS─░N BUDAK	38.41353120	27.13534110	2
17629	8	D2H081707	YAS─░N YILDIRIM	38.40677200	27.12834800	2
17630	8	020017541	YE┼Ş─░M ├çIKMAN - YE┼Ş─░M GIDA PAZARI	38.41134600	27.13483800	2
17631	8	D2H179995	YILMAZ UN├£S	38.40801180	27.13178850	2
17632	8	D2H070982	YUNUS EMRE KONU	38.41556500	27.15012700	2
17633	8	D2H131510	YUSUF KAYA	38.40903710	27.13162690	2
17634	8	020002025	YUSUF KURKUN├ç	38.42040410	27.14063240	2
17635	8	020053917	Y├£KSEL YILDIZ	38.42079600	27.14354400	2
17636	8	D2K201939	ZEYNEP DA─Ş	38.39824450	27.13180540	2
17637	18	D2K192068	ABDURAHMAN DURAK	38.38322150	27.15339760	2
17638	18	020048837	ABD├£LGAN─░ EL├çEK─░N	38.37054200	27.13902000	2
17639	18	D2K152117	ADEM ├çEL─░K	38.36967700	27.16080910	2
17640	18	D2K178176	AHMET BASKIN	38.37287100	27.13702700	2
17641	18	D2K236570	AHMET YILMAZ	38.38109790	27.16165940	2
17642	18	D2K236081	AL─░ DURDU	38.37013750	27.14637540	2
17643	18	D2K191115	AL─░ HIDIR ├ûK	38.37678560	27.16342190	2
17644	18	D2K183599	AL─░ SA─ŞLAM	38.37882330	27.13669670	2
17645	18	020054422	AL─░RIZA KILI├çASLAN	38.37851700	27.14414400	2
17646	18	D2K136935	ALTERNAT─░F AMB. GIDA ├£R. VE PAZ. SAN. ─░├ç VE DI┼Ş T─░C. LTD.┼ŞT─░.-GED─░Z BU	38.37250950	27.16278290	2
17647	18	020052425	A┼ŞKIN TOKAT	38.37770000	27.16910000	2
17648	18	D2K239959	AYKUT PALA	38.38013490	27.13597530	2
17649	18	020054015	AY┼ŞE BAYRAKTAR	38.37548500	27.15158600	2
17650	18	D2K075038	AYTA├ç BA┼Ş├çI	38.36648500	27.13805900	2
17651	18	D2K070228	AYTEN ├ûZT├£RK	38.37311930	27.16314660	2
17652	18	D2K212962	AZ─░ME KOL	38.36801420	27.13958290	2
17653	18	D2K220795	BAHR─░ KO├çY─░─Ş─░T	38.37337490	27.13981690	2
17654	18	020049197	BA┼ŞAR ├çIRAKO─ŞLU	38.37699660	27.14784120	2
17655	18	D2K105747	BA┼ŞDA┼Ş MARKET - BUCA	38.37281800	27.15031100	2
17656	18	D2K171646	BA┼ŞDA┼Ş MARKET - GED─░Z	38.37068530	27.15961150	2
17657	18	D2K230467	BAYRAM G├£RE┼Ş	38.37159800	27.13755600	2
17658	18	D2K136307	BEHR─░VAN KAYA	38.37776520	27.14671830	2
17659	18	D2K234803	DEMET POLATO─ŞLU	38.38243600	27.14483020	2
17660	18	D2K186292	DEVR─░M AL─░O─ŞLU	38.37855770	27.16278160	2
17661	18	020048776	EGEDOST GIDA PAZ. DA─Ş.SAN VE T─░C.	38.37604600	27.16344800	2
17662	18	D2K185746	EMRE U─ŞUR	38.37083530	27.15472480	2
17663	18	D2K235280	EN─░S TAFLAR	38.38039380	27.16419730	2
17664	18	D2K242663	ERD─░ ├ûZCAN	38.37150110	27.15400950	2
17665	18	D2K229069	ERGUN BAH┼Ş─░	38.38110410	27.16562600	2
17666	18	D2K168769	ERKAN AKAN	38.37887180	27.13497350	2
17667	18	020049792	ERKAN YILDIRIM	38.36942200	27.14689400	2
17668	18	D2K204629	EY├£P ARTU├ç	38.37059430	27.14519760	2
17669	18	D2K200149	EY├£PHAN SER─░N	38.37404330	27.14943240	2
17670	18	020011330	FAHRETT─░N B─░┼Ş─░RGEN-┼ŞEN BAKKAL─░YES─░	38.37483200	27.13681600	2
17671	18	020048293	FAHR─░ P─░LG─░R	38.38163630	27.13766190	2
17672	18	D2K132566	FATMA ELMASCAN	38.37428830	27.14981590	2
17673	18	D2K164207	GHAZI ALHUSSEIN	38.38014500	27.14545600	2
17674	18	020050033	G├ûKHAN CANLI	38.37753100	27.14255100	2
17675	18	D2K103084	G├ûKHAN ├çIRAK-1	38.37708700	27.14804600	2
17676	18	D2K229076	G├ûKHAN TA┼ŞPINAR	38.36925170	27.13989900	2
17677	18	D2K155261	G├ûKHAN YILMAZ	38.37904570	27.15858110	2
17678	18	D2K102752	G├ûN├£L G├£NE┼Ş	38.37235200	27.14074100	2
17679	18	020008011	G├£NER G├£NE┼Ş	38.37041300	27.15899400	2
17680	18	D2K230773	HACI G├£RE┼Ş	38.37198290	27.14140240	2
17681	18	020011283	HAD─░CE M─░NS─░N	38.37560800	27.14058500	2
17682	18	D2K227707	HAL─░L BURAK KARAHAN	38.37436800	27.16544000	2
17683	18	D2K178756	HAL─░L ─░BRAH─░M ALTAN	38.37098000	27.14845700	2
17684	18	020006017	HAL─░ME ALTI	38.37941600	27.14272170	2
17685	18	D2K239958	HAMDULLAH EKEN	38.37558980	27.13650990	2
17686	18	D2K241938	HAM─░DE ACAR	38.37348190	27.16383410	2
17687	18	D2K179608	HAM─░DE ACAR	38.37979460	27.14958500	2
17688	18	020050629	HASAN ├ûZG├£R AKORAL	38.36962300	27.14664900	2
17689	18	020002217	HASB─░YE MUTLU	38.37775700	27.14869600	2
17690	18	D2K226144	HAS─░BE BAYAZIT	38.37004580	27.15659780	2
17691	18	D2K115813	HAT─░CE U├çAR	38.37658780	27.16917870	2
17692	18	D2K117351	HED─░YE K├ûKEN	38.37519250	27.13499480	2
17693	18	D2K130623	─░SMET ├ûCAL	38.37864060	27.13951850	2
17694	18	020054215	─░ZZETT─░N DO─ŞAN	38.37611300	27.13930800	2
17695	18	D2K211112	KADR─░ ├ç─░├çEK	38.37805790	27.13636460	2
17696	18	D2K230347	KAHRAMAN ├ûZKAN	38.37387520	27.16274970	2
17697	18	020055015	KAM─░L HASK├ûY	38.37731530	27.13709120	2
17698	18	D2K242581	KEMAL KAPAN	38.37256190	27.13843230	2
17699	18	D2K209251	KEMAL T─░KVE┼ŞL─░	38.37872500	27.15990510	2
17700	18	020002416	KENAN AYTAR- KENAN BAKKAL	38.37975900	27.13876700	2
17701	18	020048266	MEHMET BAH├çA	38.37444500	27.13724300	2
17702	18	D2K233936	MEHMET D├ûNMEZ	38.37141510	27.14262620	2
17703	18	D2K175001	MEHMET EM─░N YILDIRIM	38.37871640	27.15882190	2
17704	18	D2K221716	MEHMET G├£ZEY	38.37707670	27.14061710	2
17705	18	020044993	MEHMET ORTATEPE	38.37260700	27.15280300	2
17706	18	D2K207381	MEHMET TATLI	38.36911230	27.14696500	2
17707	18	020053685	MEHMET YASA	38.36974480	27.13828130	2
17708	18	D2K225891	MEN─░Z ├ûZYILDIRIM	38.38229170	27.16415470	2
17709	18	020049559	MES-HAT GIDA TEM─░ZL─░K MAD. VE ┼ŞANS OY. P	38.37856130	27.16463040	2
17710	18	D2K227232	MUHAMMED AL─░ G├£LER	38.38206780	27.16721150	2
17711	18	020051006	MUSTAFA KILI├ç	38.37568460	27.14738600	2
17712	18	D2K176010	MUSTAFA KILI├ç	38.37206310	27.15117520	2
17713	18	D2K229189	MUZAFFER B─░LEN	38.37473560	27.14305560	2
17714	18	020051139	NAZ─░KAR ├çOKGEN├ç	38.37120200	27.15406800	2
17715	18	D2K186412	N─░HAT ├çEP─░├ç	38.37116900	27.14030650	2
17716	18	D2K209927	ONUR TEPEBA─Ş	38.37826950	27.16580380	2
17717	18	D2K168234	├ûMER ARSLAN	38.36874700	27.13884300	2
17718	18	D2K232953	├ûMER SIDDIK	38.37556610	27.14564910	2
17719	18	020054566	PERRFEKT MARKET GIDA	38.37508600	27.15106700	2
17720	18	020045810	RE─░S ┼Ş─░M┼ŞEK - BERF─░N TEKEL BAY─░─░	38.37845400	27.14060200	2
17721	18	D2K117004	SABR─░YE G├£NAY	38.37615250	27.16096640	2
17722	18	D2K087905	SAFURE GEZG─░N - ├ûZDEN AVM	38.37265800	27.14628900	2
17723	18	020018343	SEHER BAYRAK - YA─ŞMUR MARKET	38.38343000	27.15350900	2
17724	18	020053854	SERDAR Y├£REK	38.37091500	27.14228700	2
17725	18	020052442	SERG├£LEN VURAL	38.37859400	27.14538900	2
17726	18	D2K132845	SERKAN KOSKA	38.37498100	27.16650540	2
17727	18	D2K214915	SERMET ├ûZKAYA	38.37181260	27.14503230	2
17728	18	D2K132639	SERVET YA┼ŞAR	38.37716200	27.16956900	2
17729	18	D2K235518	SEVG─░ BAL	38.37656970	27.16896040	2
17730	18	D2K229188	SEZAN ES─░RDEN	38.37442190	27.13600390	2
17731	18	D2K142743	SEZEN ALTINTA┼Ş	38.37289930	27.14809720	2
17732	18	020001677	SIRMA T├£RKMEN	38.38264900	27.15309300	2
17733	18	020046567	┼ŞER─░FE G├£L KURTULAN	38.38189300	27.13727900	2
17734	18	020019029	TUNCER SOLUCU - ┼ŞAFAK B├£FE	38.37370400	27.14183900	2
17735	18	D2K134594	UFUK NAS	38.37263800	27.13994800	2
17736	18	020050519	U─ŞUR S├£ER	38.37751600	27.13595200	2
17737	18	D2K207016	U─ŞURCAN KIZIL	38.37183260	27.14590010	2
17738	18	020052940	VEL─░ BAYANDUR	38.38174900	27.13903800	2
17739	18	020018876	VEL─░ ├ûZCAN	38.36869100	27.13802900	2
17740	18	D2K072725	YEL─░Z KO┼ŞARMAZ	38.37137700	27.14047200	2
17741	18	020051022	YUSUF KIRGIZ	38.37840000	27.14230000	2
17742	18	D2K239704	ZAR─░FE DOYDU	38.37897180	27.16488660	2
17743	18	D2K129777	ZEHN─░ G├£NE┼Ş	38.37253260	27.15879890	2
17744	26	D2H172132	A BUSINESS INTERNATIONAL DI┼Ş T─░CARET L─░M─░TED ┼Ş─░RKET─░ URLA ┼ŞUBES─░	38.37757020	26.67952770	2
17745	26	D2H001858	ABD─░ SERHAT T├£REL	38.28589000	26.37443200	2
17746	26	D26000954	ABDULHAD─░  KALKAN	38.31551700	26.41738400	2
17747	26	D2H010852	ABDULLAH AKKU┼Ş	38.31170900	26.41482300	2
17748	26	D2H001718	ABDURRAHMAN CANTEM├£R	38.32585000	26.41152000	2
17749	26	D2K204052	ADEM AL─░ G├£ND├£Z	38.28907380	26.37764030	2
17750	26	D2K230575	AHMET KAYA	38.28436540	26.56144090	2
17751	26	D26000595	ALA├çATI ├ûZTA┼Ş AKARYAKIT ─░N┼Ş.SAN. VE T─░C.LTD.┼ŞT─░.	38.28850000	26.38130000	2
17752	26	D2H195332	ALAHETT─░N BULUT	38.33561370	26.64431400	2
17753	26	D2K236300	AL─░ CEM ├ûZDEN─░Z	38.31111350	26.40978610	2
17754	26	D2H161933	AL─░ ├çAMUR	38.56852100	26.36984900	2
17755	26	D2H002202	ATALAY ALDEM─░R	38.19731900	26.49334400	2
17756	26	D2H129368	AYKUT KARAKET─░R	38.28854850	26.36901390	2
17757	26	D26000601	BANU ERSAN	38.32365400	26.58019600	2
17758	26	D2H182686	BARBAROS TOPRAKTEPE	38.28447800	26.37584200	2
17759	26	D26000311	BAYRAM ├ûZKANLI	38.56309730	26.37255270	2
17760	26	D2K226548	BERNA DEM─░RKIRAN	38.64188450	26.52134380	2
17761	26	D2H157767	B─░RCAN AKBALIK	38.28862000	26.37752100	2
17762	26	020026715	CEYHAN ┼ŞEN	38.28891950	26.37991200	2
17763	26	D2H016700	C─░HAN HUNT├£RK	38.43288900	26.51299600	2
17764	26	020026491	CUMHUR SAAT├çI/SAAT├çIOGLU MARKET	38.51888100	26.62561600	2
17765	26	D26000098	DAVUT Z─░YA SARAYK├ûYL├£	38.30881200	26.68059100	2
17766	26	D2H181189	DOLUNAY G├£ND├£Z	38.28659500	26.37496900	2
17767	26	D2H183407	D├£ZG├£N SAL	38.31392820	26.41617180	2
17768	26	D2H077637	EGEAY GIDATUR.KUY.SAN.VE T─░C.L─░M─░TED ┼ŞT.	38.64826100	26.51697600	2
17769	26	D26000149	E─ŞLEN HOCA KALKINMA KOOP	38.54287200	26.56948900	2
17770	26	D2H062444	EMEKO─ŞLU GIDA PAZ. END. VE T─░C. LTD.┼ŞT─░.	38.29487500	26.36709500	2
17771	26	020026735	ERSEN YAVUZ	38.38309600	26.47662600	2
17772	26	D26000182	ERSOY Y├£KSEL	38.34909000	26.68648800	2
17773	26	D2H074420	FAT─░H ├ûZEN	38.27714500	26.37346200	2
17774	26	D26000306	FEH─░M ├ûZLEM	38.38182150	26.62685850	2
17775	26	D26000667	FERD─░ TUNCEL	38.27951060	26.37286530	2
17776	26	D26000109	F─░KRET UMUTLU	38.34962700	26.68391700	2
17777	26	D2H180319	G─░ZEM ├çINAR	38.52524320	26.61334060	2
17778	26	020026732	G├ûNEN PETROL ├£R├£N.─░N┼Ş VE DAY.T├£K.MAL.T─░C.LTD.┼ŞT─░.	38.32813200	26.64470300	2
17779	26	D2H015445	G├£├çYIL TUR. GIDA OTO ─░N┼Ş. SAN. LTD. ┼ŞT─░.	38.63625900	26.52296200	2
17780	26	D2K201941	G├£L┼ŞAH SARA├ç	38.24324400	26.50507300	2
17781	26	D26000898	G├£NAY G├£L	38.32126400	26.70888400	2
17782	26	D2H146747	HAKAN ─░┼Ş─░T	38.27533700	26.37539600	2
17783	26	D2H077544	HAKAN SUNAY	38.28943500	26.38279900	2
17784	26	D26000071	HAL─░L EREN	38.28401890	26.56257270	2
17785	26	D2H192353	HAMD─░ AKTOLUN	38.27663090	26.37373570	2
17786	26	D2H135890	HANDE S├£ER	38.32950900	26.64357500	2
17787	26	D2K200238	HASAN HEPER	38.28458560	26.55163470	2
17788	26	020026605	HASAN KARABATAK/ONUR B├£FE	38.63590900	26.51060100	2
17789	26	D26000617	HASAN SAATL─░	38.28526100	26.37951600	2
17790	26	D2K199808	HDM TUR─░ZM ─░N┼Ş. GIDA VE OTOMOT─░V SAN.T─░C.LTD.┼ŞT─░.	38.28316590	26.37604300	2
17791	26	D2H136092	HED─░YE G├£NER	38.28293600	26.37384700	2
17792	26	D2H167938	H─░KMET BOSTANCI	38.32257130	26.40155420	2
17793	26	D26000134	H─░KMET SAKA	38.51862800	26.62569800	2
17794	26	D26000302	HOGET PETROL AKY. GID.TUR.TIC.LTD.┼ŞT─░.	38.51040000	26.61630000	2
17795	26	D26000160	H├£SEY─░N KARACA	38.54732020	26.55303650	2
17796	26	D2K221460	II.KEMAL CEBEC─░ GIDA ─░N┼Ş.TUR─░ZM SAN.VE T─░C.A┼Ş.	38.28089920	26.37705610	2
17797	26	D2H001903	II.S├£LEYMAN RAMADANO─ŞLU	38.31048580	26.70483500	2
17798	26	D2H129544	─░BRAH─░M HAKAN URAN	38.51529400	26.62054500	2
17799	26	020026483	─░BRAH─░M KAM	38.34213800	26.64143300	2
17800	26	D26000649	─░BRAH─░M ├ûZGEN	38.28484200	26.55595400	2
17801	26	D2K234201	irem t├╝ketim maddeleri turizim in┼şaat otomativ sanayi ve ticaret limit	38.31554030	26.40888920	2
17802	26	D26000644	─░SLAM KAYA	38.32916800	26.42280000	2
17803	26	D2K216138	─░SMA─░L ├ç─░FT├ç─░	38.51511430	26.61753160	2
17804	26	D2H134962	─░SMET KAAN TERZ─░	38.51866690	26.62540160	2
17805	26	D26000382	─░ZM─░R GAZ PET.├£R├£N.SAN. VE T─░C.LTD.┼ŞT─░.	38.63742300	26.51307000	2
17806	26	D2H113835	JALE BULDANLIO─ŞLU	38.56131000	26.56855800	2
17807	26	D2K198988	KARMEN ALA├çATI GIDA SANAY─░ VE T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.28481090	26.37431490	2
17808	26	D2H181163	KEMAL CEBEC─░ GIDA ─░N┼Ş.TUR─░ZM SAN.VE T─░C.A┼Ş.	38.25466170	26.38107630	2
17809	26	D2H056374	KENAN BURSALI	38.64729200	26.51549200	2
17810	26	D2H179788	KUB─░LAY TOPRAKTEPE	38.28858600	26.38205700	2
17811	26	D2H172525	LOKMAN YAL├çIN	38.28501400	26.37710500	2
17812	26	D26000316	L├£TF├£ TU─ŞRUL	38.34287500	26.55356200	2
17813	26	D2K234697	MAGIC TUR─░ZM TA┼ŞIMACILIK OTOMOT─░V ─░N┼ŞAAT T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.27788860	26.37835160	2
17814	26	D2H152448	MEHMET G├£NAY	38.63566300	26.50967100	2
17815	26	D26000152	MEHMET HASKAN	38.67140000	26.43962900	2
17816	26	D26000506	MEHMET KAYA	38.31549800	26.41713500	2
17817	26	020026614	MEHMET LEVENT ARIKAN/ARIKAN MARKET	38.51865600	26.62622700	2
17818	26	D2K208199	MEHMET LOKMACI	38.28286520	26.37864270	2
17819	26	D2H120023	MEHTAP KOZAN	38.37299430	26.48287270	2
17820	26	D26000503	MELEK ├çEK─░N	38.38296900	26.47684200	2
17821	26	D2H163412	MEL─░S S├ûNMEZ	38.28523400	26.37901900	2
17822	26	D2K240812	MERAL ├çOBAN	38.50678100	26.62180700	2
17823	26	D26000662	M─░ZRAP BABA	38.51865790	26.59847150	2
17824	26	020026506	MORDOGAN ├ûZKANLAR PETROL LTD.STI./PETL─░NE	38.50335400	26.61689500	2
17825	26	D2H123495	MURAT ADAK	38.67106520	26.43942410	2
17826	26	D2K217558	MURAT CANBAZ	38.51518640	26.62050970	2
17827	26	020026710	MURAT G├£RSES/G├£RSES TEKEL BAYII	38.28659500	26.37496900	2
17828	26	020026706	MUSA ASLAN	38.28904400	26.38317000	2
17829	26	D2H112721	MUSA ATASOY	38.32058670	26.39803650	2
17830	26	D26000833	NAH─░T ERMAN	38.33605800	26.42990900	2
17831	26	D26000144	NA─░ME G├£NG├ûR	38.63503500	26.50995800	2
17832	26	D26000247	NECMETT─░N KAYA	38.41774000	26.58977300	2
17833	26	D2K227779	N─░DA ER	38.31482540	26.41635230	2
17834	26	D2H072617	OSMAN K├£├ç├£KAL─░	38.42841700	26.58378900	2
17835	26	D26000065	OZANBEY LTD.┼ŞT─░	38.28862400	26.55274400	2
17836	26	020026540	├ûMER BASUT	38.31827700	26.71050200	2
17837	26	D2K222453	├ûMER KARAYILAN II	38.28844020	26.37698800	2
17838	26	D26000496	├ûZ─░MEREK GIDA SAN.T─░C.LTD.┼ŞT─░.	38.34356400	26.44344600	2
17839	26	D2H136731	├ûZKAN YILMAZ ACAR GIDA TURIZM SAN. VE TIC. LTD. STI. - ACAR MARKET	38.37892810	26.67806570	2
17840	26	D2H140302	RAMAZAN ├ûZEN	38.30658050	26.38101110	2
17841	26	D26000531	RAMAZAN TUNCEL	38.29004200	26.38206800	2
17842	26	020026694	RECEP ALBAYRAK/MARKET ─░┼ŞLETMES─░	38.32946700	26.42196800	2
17843	26	020026517	SAL─░H PARTAL	38.42780910	26.58375250	2
17844	26	D2H173557	SEDA ALAKU┼Ş	38.32584400	26.40965200	2
17845	26	020026481	SELAHATTIN BEKTAS GIDA LTD./G├£LBAH├çE S├£PERMARKET	38.33141400	26.64263800	2
17846	26	D2H174338	SERDAR ┼Ş─░M┼ŞEK	38.28709630	26.37061360	2
17847	26	D26000390	S├£LEYMAN YILDIZ	38.32375830	26.58032840	2
17848	26	D2K221371	┼ŞAH─░N YALAP	38.50871040	26.61675880	2
17849	26	D2K234507	tekelika turizm san ve tic. ltd. ┼şti.	38.27923920	26.37190860	2
17850	26	D2H185208	TUNCAY DA─ŞDELEN	38.56314300	26.37250000	2
17851	26	020026482	├£M─░T ANAR	38.33413700	26.64490500	2
17852	26	D2H085064	├£M─░T ├çALI┼ŞKAN	38.30878500	26.68099000	2
17853	26	D2H148814	YARIMADA TOPTAN GIDA - MURAT I┼ŞIL ERASLAN ORTAKLI─ŞI	38.63604550	26.51054980	2
17854	26	D2H136713	YILDIRIM 05 GIDA L─░M─░TED ┼Ş─░RKET─░	38.30858930	26.38094150	2
17855	26	D2K237410	YILMAZ ├ûZLEK	38.63806200	26.51941400	2
17856	26	020026487	Y├£CEL BUDAK	38.50813230	26.62569780	2
17857	26	D26000518	ZAFER ├çIRAK	38.31517300	26.46501800	2
17858	26	D2H114154	ZAFER YILDIRIM	38.43249500	26.51403700	2
17859	26	D2K227305	ZEYNEP ├çALIK	38.54292480	26.56913240	2
17860	26	D26000303	Z─░YA ├ûZMEN	38.34292700	26.64120000	2
17861	39	D2K229115	4ERAKARYAKIT ─░N┼ŞAAT TUR─░ZM SANAY─░ VE T─░CARET A.┼Ş.-4ER AKARYAKIT ─░N┼ŞAAT	38.45449200	27.44416620	2
17862	39	D2K187214	ADEM ├ûZ─░LLER	38.42670710	27.42570640	2
17863	39	D2K198666	AHMET ACAR	38.42550000	27.42922900	2
17864	39	D2K143801	AHMET CAN G├£LEN	38.33846900	27.45508800	2
17865	39	D2K114166	AHMET ├çOBAN	38.43012820	27.40993120	2
17866	39	D2K068705	AHMET ├çORUH	38.42797000	27.42663600	2
17867	39	D2F027468	AL─░ ├çORUH	38.42510700	27.41594100	2
17868	39	D2K106765	AL─░ SOLAK	38.47271410	27.35460000	2
17869	39	D2K117748	AMSTERDAM GIDA TEKEL MADDELERI TICARET LIMITED SIRKETI	38.47504250	27.35530670	2
17870	39	D2K139796	ANILLAR GIDA IHTIYA├ç MADDELERI INSAAT SANAYI VE TICARET LIMITED SIRKET	38.43244070	27.41014420	2
17871	39	D2K130590	ANILLAR GIDA STI. - ANILLAR GIDA ┼ŞT─░	38.43136010	27.41380250	2
17872	39	020029619	ANILLAR GIDA VE ─░HT.SAN.T─░C.LTD.┼ŞT─░	38.42820000	27.42060000	2
17873	39	020029454	ASIM SEB.MEYV.LTD.┼ŞT─░.	38.42816800	27.41506800	2
17874	39	D29002035	ASUMAN DEL─░BALTA	38.43028100	27.41951100	2
17875	39	D2F049141	ATA ├çEL─░K SAN. VE T─░C.LTD.┼ŞT─░.	38.46323000	27.36009200	2
17876	39	D29001750	ATAR AKARYAKIT N─░HAT ATAR	38.42800000	27.41560000	2
17877	39	D2K118758	AT─░LA KULA	38.43476940	27.40259320	2
17878	39	D2K075331	AT─░LLA ARSLAN	38.43347400	27.40866500	2
17879	39	D2K125957	AY┼ŞE BODUR	38.42417530	27.42618020	2
17880	39	D2K226179	AY┼ŞEG├£L UYSAL	38.41900760	27.43653770	2
17881	39	D2F004237	BAHATT─░N ├ûZT├£RK	38.43467400	27.40475300	2
17882	39	D2K230909	BARI┼Ş ATA	38.48239300	27.35464710	2
17883	39	D2K075754	BATINAK TRANS─░T TA┼ŞMACILIK PETR. VE TUR. T─░C. LTD. ┼ŞT─░.	38.42392600	27.43189500	2
17971	39	D29000509	VAROL PI├çAK├çI	38.34144300	27.39750900	2
17884	39	D2K230165	BEST AVM MARKET├ç─░L─░K TOPTAN VE PERAKENDE T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.47895800	27.35679880	2
17885	39	D2K199874	BURCU YILDIRIM	38.42883330	27.40878310	2
17886	39	D2K219278	CANAN TA┼Ş├çI	38.48188690	27.40427450	2
17887	39	D29001937	CO┼ŞKUN G├£ND├£Z	38.42681900	27.41970700	2
17888	39	D2K188254	├çA─ŞLA CEVAH─░R	38.43033300	27.41858300	2
17889	39	D2K234966	DERYA ├£NL├£OVA	38.43206830	27.40345270	2
17890	39	D29001949	EBRU HAYIR	38.45863600	27.43853100	2
17891	39	D2K236337	ECE ├çET─░NDALAN	38.42871260	27.42406360	2
17892	39	D2F041141	EKREM ├çAKMAK	38.42397400	27.41668700	2
17893	39	D29002081	EL─░F AYDINLAR GIDA ─░N┼Ş.SAN.VE T─░C.LTD.┼ŞT─░.1.┼ŞUBES─░	38.42580000	27.42140000	2
17894	39	020029460	EL─░F AYDINLAR GIDA ─░N┼Ş.SAN.VE T─░C.LTD.┼ŞT─░.2.┼ŞUBES─░	38.42623300	27.42042100	2
17895	39	D2K084920	EMRAH ACAR - MISRAM MARKET	38.43109710	27.41052370	2
17896	39	D2K166493	ERDAL SARI	38.42658140	27.41612760	2
17897	39	D29001176	ERDEM YILMAZ	38.42962200	27.42105600	2
17898	39	D2K223344	ERHAN KUYUMCU	38.48275060	27.35644140	2
17899	39	D2K233397	ESEN KAVU┼ŞAN	38.43164960	27.40710100	2
17900	39	D2K234991	ESKA I├çECEK GIDA HAYVANCILIK OTOMOTIV TASIMACILIK SANAYI TICARET LIMIT	38.43294490	27.40893820	2
17901	39	D2K231236	EVREN BURAK H├£SEY─░NO─ŞLU	38.45817780	27.37105450	2
17902	39	D2F016543	FATMA AKZOR	38.42595030	27.42667940	2
17903	39	D2K232776	FERHAN KARAKOYUN	38.43045200	27.40965180	2
17904	39	D2K126072	F─░L─░Z PARLAK	38.42534420	27.42213560	2
17905	39	D2K240419	GOFRETTE TEDAR─░K L─░M─░TED ┼Ş─░RKET─░	38.46169570	27.36566620	2
17906	39	D2K066323	G├ûKHAN ARAS	38.48116900	27.36376150	2
17907	39	D2K104407	G├£L─░ZAR DUMAN	38.42511580	27.42266410	2
17908	39	D2K110854	G├£Z─░N G├£RE┼Ş├ç─░	38.47877620	27.35634600	2
17909	39	D2K212609	HAKKI ─░├çECEK GIDA OTOMOT─░V LTD.┼ŞT─░.	38.42964620	27.42174970	2
17910	39	D2K064943	HAL─░L HAYIR 2 - ├çOLAKO─ŞLU BAKKAL	38.48607000	27.42830200	2
17911	39	D2K184855	HAL─░L YET─░M	38.42875730	27.40995500	2
17912	39	D2K187574	HASAN A┼ŞAN	38.42720700	27.42063400	2
17913	39	D29000557	HASAN YAZAR	38.42845700	27.41459300	2
17914	39	D2K074031	HAT─░CE TAHTALI	38.42840020	27.41760090	2
17915	39	D2K186946	HEL─░ME ATMACA	38.42515040	27.42607740	2
17916	39	D2K132307	H├£LYA M─░D─░LL─░L─░	38.42411690	27.42515650	2
17917	39	D29000465	H├£SEY─░N KOCABIYIK	38.48840200	27.39057900	2
17918	39	D2F004175	─░BRAH─░M ATE┼Ş	38.42405500	27.41653700	2
17919	39	D2K211982	─░BRAH─░M ERDEM	38.47984940	27.35750060	2
17920	39	D2K235942	─░BRAH─░M HAKKI K├ûSE	38.42372240	27.42920160	2
17921	39	D2K167053	─░NC─░LAY CAYAR	38.42322670	27.42971540	2
17922	39	D29002173	─░PEK KARABULUT	38.48065800	27.36060700	2
17923	39	D2K134637	─░SKONTO ─░├çECEK INSAAT SANAYI TICARET LIMITED SIRKETI	38.42871900	27.42431500	2
17924	39	D29000428	─░SMA─░L TAMER	38.42459100	27.42391300	2
17925	39	D2K200834	KAD─░R KUL	38.47777500	27.35424900	2
17926	39	D2K068447	KAMILA KARAPINAR	38.42505200	27.41783400	2
17927	39	D2K237459	KAVU┼ŞAN MARKET├ç─░L─░K GIDA VE ─░N┼ŞAAT T─░CARET PAZARLAMA L─░M─░TED ┼Ş─░RKET─░	38.47988090	27.35417730	2
17928	39	D29002118	KEMAL MURAT	38.42881900	27.41858100	2
17929	39	D2K214043	KORO─ŞLU PETROL ─░N┼ŞAAT GALER─░ TUR─░ZM E─Ş─░T─░M SAN. VE T─░C.LTD.┼ŞT─░.	38.44919560	27.37502090	2
17930	39	D2K169979	MAR─░FET K─░┼Ş─░N	38.42514030	27.42356530	2
17931	39	D29000753	MEHMET AYBEY	38.33854100	27.45542400	2
17932	39	D2K183695	MEHMET ─░SA BOZ	38.43114220	27.41474560	2
17933	39	D2K157166	MEHMET KOCABIYIK	38.48230400	27.40445900	2
17934	39	D2K131262	MEHMET ├ûNL├£	38.47997890	27.35808500	2
17935	39	D2K205318	MEHMET S├£R	38.38567700	27.44304280	2
17936	39	D29001452	MEHMET Y├ûR├£K	38.48857000	27.39111300	2
17937	39	D2K202162	MEL─░H MER─░├ç -BALCI MARKET	38.42702990	27.41802190	2
17938	39	D2K218613	MEL─░H ├ûZ	38.47999100	27.35844100	2
17939	39	D2K240330	MENEK┼ŞE ├çAKAR	38.47954790	27.36402800	2
17940	39	D2K238860	MERYEM AKA	38.48154990	27.36300320	2
17941	39	D2K113082	MERYEM GILIR	38.48579130	27.42870840	2
17942	39	D2F004264	MUSTAFA DEM─░REL	38.43044270	27.40930490	2
17943	39	D29001627	MUSTAFA G├£VEN TOHUMCU	38.42340000	27.42970000	2
17944	39	D2K081474	MUSTAFA TAYYEL─░	38.43361290	27.40690740	2
17945	39	D2K227251	NA─░F MEDETO─ŞLU	38.48301900	27.36040400	2
17946	39	D2K220650	NEV─░N G├£NDO─ŞDU	38.42911090	27.41190670	2
17947	39	D29001330	N─░YAZ─░ ARSLAN	38.42900000	27.42320000	2
17948	39	D2K241005	OKTAY BE┼ŞL─░LER	38.43449910	27.40342940	2
17949	39	D29001352	OLCAYTO TOKER PETROL VE PETROL ├£R├£NLER─░ DA─ŞITIM VE T─░CARET	38.44480000	27.37900000	2
17950	39	D2K242567	ONUR KIRA├ç	38.43179130	27.41662260	2
17951	39	D2K119795	├ûZKAN AYDEM─░R	38.48247130	27.35890980	2
17952	39	D2K115105	PINAR ├ûZDEM─░R	38.43258800	27.40811300	2
17953	39	D2F004256	RAMAZAN AV┼ŞAR	38.47298030	27.35462490	2
17954	39	D2K229077	RECEP KARATA┼ŞLI	38.43048100	27.41806650	2
17955	39	D2K217872	ROS─░ T─░CARET GIDA PAZ.LTD.┼ŞT─░.	38.43397050	27.40557280	2
17956	39	D2K148412	SAL─░H AKSOY	38.42482050	27.42005570	2
17957	39	D2K237952	SAL─░H KARA	38.47897420	27.35651320	2
17958	39	D2K087993	SAL─░HA S─░VAZ - SERAY MARKET	38.34138600	27.39689100	2
17959	39	D2K071471	SEMANUR KARABULUT	38.49894300	27.37790700	2
17960	39	D2K230212	SERAP KARAKULAK	38.42687720	27.41852720	2
17961	39	D2K233171	SERKAN DAVET	38.43277130	27.41310000	2
17962	39	D2K241108	SERKAN ├ûZT├£RK	38.42801090	27.41835470	2
17963	39	D2K239529	S─░BEL S├ûNMEZ	38.32741720	27.46034810	2
17964	39	D2K216057	SONG├£L AKBA┼Ş	38.42436880	27.41624450	2
17965	39	D2K097453	SULTAN OKUMU┼Ş	38.42632100	27.42518900	2
17966	39	D29002150	S├£LEYMAN YILMAZ	38.38528000	27.44368700	2
17967	39	D2K226970	S├£LEYMAN Y├£CEL	38.47822530	27.36266230	2
17968	39	D2K159294	┼ŞABAN DO─ŞANLAR	38.42398540	27.42509650	2
17969	39	D2K191359	┼ŞER─░FE GEN├ç	38.48085170	27.35418550	2
17970	39	D2F013967	TANKAR OTOMOT─░V PETROL GIDA H─░Z.SAN.T─░C.LTD.┼ŞT─░.	38.46190000	27.37840000	2
17972	39	D2K198368	VEL─░ AKMANSOY	38.48305200	27.36258500	2
17973	39	D2F050138	Y.D.├ç METAL MAK.OTO NAK.─░N┼Ş.TUR.─░TH.─░HR. SAN. VE T─░C.LTD.┼ŞT─░.	38.45417560	27.44693300	2
17974	39	D29001704	YA─ŞHANEC─░ PETROL VE PETROL ├£R. TUR. SAN. VE T─░C. LTD. ┼ŞT─░.	38.43713400	27.39912700	2
17975	39	D2K213436	YAKUP ├çAKMAK	38.43111020	27.41649720	2
17976	39	020029481	YAMAN PETROL SAN.T─░C.LTD.┼ŞT─░.	38.45786930	27.41067370	2
17977	39	D2K220301	YAS─░N BUDAK	38.42886010	27.41209120	2
17978	39	D2K179600	YA┼ŞAR SARIKAYA	38.43418210	27.41132490	2
17979	39	D2F034632	YA┼ŞAR TEKDEM─░R	38.42780500	27.41892200	2
17980	39	D2K088339	YAVUZ ARTU─Ş	38.42841700	27.40745100	2
17981	39	D2K229661	YUSUF KENAN AYDEM─░R	38.47781970	27.35842170	2
17982	39	D2K183570	ZEYNEP CEYLAN	38.42955600	27.41731600	2
17983	25	D2H000820	44. BAKIM FABR─░KA M├£D├£RL├£─Ş├£	38.42611300	27.17815800	2
17984	25	D2H035770	ADEM AKG├£N	38.24085300	27.22467800	2
17985	25	D2H076612	AHMET AYKUT KAN├çEL─░K	38.22938480	26.92598890	2
17986	25	D2H119592	AL─░ CANER─░	38.18677880	27.18749130	2
17987	25	D2K186285	ATACAN ALTIPARMAK	38.31206500	27.28168600	2
17988	25	D21167980	AYKAN KARA	38.21306010	27.22954210	2
17989	25	D2H104391	AYNUR KOCA─░R─░	38.18734200	27.19079800	2
17990	25	D2K241627	BAYMET TOPTAN GIDA SAN. VE T─░C. LTD. ┼ŞT─░.	42.94838100	34.13287400	2
17991	25	D2K209928	BERK BED─░RHAN G├£NBEY	38.26050700	27.23991200	2
17992	25	D2K130561	BORNOVA JANDARMA KOMANDO TUGAY KOMUTANLI─ŞI KANT─░N BA┼ŞKANLI─ŞI	38.44424890	27.29138870	2
17993	25	D2K194552	BUCA Y├£KSEK G├£VENL─░KL─░ KAPALI CEZA ─░NFAZ KURUMU ─░┼ŞYURDU M├£D├£RL├£─Ş├£	38.30728400	27.30014500	2
17994	25	D2H001728	CENG─░Z KARABACAK	38.28056600	26.96929400	2
17995	25	D2H134433	EGE DO─ŞU┼Ş GIDA SAN. VE T─░C.LTD.┼ŞT─░.	38.38615860	26.95539810	2
17996	25	D26000111	EGE ORDU ILIKSU YER.E─ŞT.	38.41096300	26.68885360	2
17997	25	020026521	EGE ORDU ─░ST─░HKAM SAVA┼Ş TABURU	38.41673800	26.69845700	2
17998	25	D2H067382	EGE ORDUSU KOMUTANLI─ŞI KANT─░N─░	38.38944400	26.95782600	2
17999	25	D2K161085	EM─░NE SALTIK	38.31020140	27.28126260	2
18000	25	D2K221186	EMRE ├ûZDEM─░R	38.23911400	27.22399200	2
18001	25	D2H012005	ERS─░N ERG─░N	38.31756600	26.92428700	2
18002	25	D2K225992	FARUK G├£VEN	38.28541070	27.26747070	2
18003	25	D2H000690	FATMA ─░NCE	38.21557500	27.22625700	2
18004	25	D2K222619	F─░L─░Z AKA	38.21550080	27.22976890	2
18005	25	D2H000785	G├ûDENCE TARIMSAL KALKINMA KOOP.	38.26997000	26.91859000	2
18006	25	D2K235010	G├ûKHAN DURAK	38.18723870	27.18984890	2
18007	25	020035742	G├£NEY DEN─░Z SAHA KOMUTANLI─ŞI	38.41410000	27.01800000	2
18008	25	D21165031	HARUN TOKLUO─ŞLU	38.24112630	27.22314660	2
18009	25	D2H000817	HAVA E─Ş─░T─░M KOMUTANLI─ŞI KANT─░N BA┼ŞK.	38.39796400	27.07017900	2
18010	25	D2H001083	HAVA RADAR MEVZ─░─░ KOMUTANLI─ŞI	38.33442150	26.99664670	2
18011	25	020035730	HAVA TEKN─░K OKULU	38.30874200	27.15653400	2
18012	25	D2K217652	HAYRETT─░N ─░LHAN	38.31815800	27.31659540	2
18013	25	D2H141933	III.NAG─░HAN ├çOPUR	38.24028500	27.22446000	2
18014	25	D2H083544	─░BRAH─░M YABAN	38.18621600	27.18980200	2
18015	25	D2H134249	─░BRAH─░M YAL├çIN	38.31059570	26.95812650	2
18016	25	D2H001157	─░L JANDARMA KOMUTANLI─ŞI KANT─░N─░	38.40390000	27.20510000	2
18017	25	D2H000815	─░ZM─░R 1 NOLU F T─░P─░ CEZAEV─░ ─░┼ŞYURDU	38.30836900	27.30381000	2
18018	25	D2H000818	─░ZM─░R 2 NOLU F T─░P─░ CEZAEV─░	38.30716300	27.30040300	2
18019	25	D2K179319	iZM─░R BUCA A├çIK CEZA ─░NFAZKURUMU ─░┼ŞYURDU M├£D├£RL├£─Ş├£	38.30441600	27.29821000	2
18020	25	D2H001156	─░ZM─░R MERKEZ KOMUTANLI─ŞI KANT─░N BA┼ŞKANLI─ŞI	38.39590000	27.14020000	2
18021	25	D2H001769	─░ZM─░R ORDU EV─░	38.41550000	27.12410000	2
18022	25	D2H017364	JANDARMA MUHABERE E─Ş─░T─░M MERKEZ─░ KOMUTANLI─ŞI	38.20433400	26.83329800	2
18023	25	D26000054	KHO ATAT B├ûLGE B─░RL─░K KOMUTANLI─ŞI	38.40697800	26.73076000	2
18024	25	D2H000326	KOCA─░R─░ PETROL SAN.VE T─░├ç.LTD.┼ŞT─░.	38.18630400	27.19393400	2
18025	25	D2K138007	MERYEM T├£RKER	38.31278600	27.28129900	2
18026	25	020035597	MS├£ KHO MALTEPE YERLE┼ŞKES─░ KOMUTANLI─ŞI KANT─░N BA┼ŞKANLI─ŞI	38.38005900	26.92354900	2
18027	25	D21179744	MUAZZEZ YILMAZ├çEL─░K	38.24097030	27.22452500	2
18028	25	D2H001828	MUHAMMET KURBAN	38.27860800	26.97263900	2
18029	25	D2H001095	NATO KARA KOMUTANLI─ŞI T├£RK KIDEML─░ SUBAYLI─ŞI	38.38867100	27.14207200	2
18030	25	D2H000045	NURETT─░N ┼ŞENCAN	38.31425600	27.28080300	2
18031	25	D2K203254	OLGUN D├ûNMEZ	38.24128390	27.22458780	2
18032	25	D2H000120	OSMAN KARABIYIK	38.28728800	27.28168100	2
18033	25	D2K238377	├ûMER DEM─░RT├£RK	38.22965430	26.92610150	2
18034	25	D2H104728	├ûZDERE ├ûZEL E─Ş─░T─░M MERKEZ─░ KOMUTANLI─ŞI	38.03398400	27.07139800	2
18035	25	D2H127897	├ûZLEM ├çELG─░N	38.18452190	27.18803680	2
18036	25	D2K163415	RA┼Ş─░T BECER	38.31845700	27.31810100	2
18037	25	D2K206169	SAHA-BED PETROL ├£R├£NLER─░ VE L─░K─░T PETROL GAZI GIDA TA┼ŞIMACILIK OTOMOT─░	38.27208600	27.23080260	2
18038	25	D2H134449	SA─░ME EFE	38.21477310	27.22711170	2
18039	25	D2H000784	SELAHATT─░N DEREL─░	38.22941550	26.92594120	2
18040	25	D21186504	SEVDA KAYA	38.24185500	27.22470800	2
18041	25	D21169880	S─░BEL AKA	38.21486510	27.22913960	2
18042	25	D2H000137	S├£LEYMAN ┼ŞENCAN	38.31057400	27.28147500	2
18043	25	D2K227624	┼ŞABAN G├£D├£C├£	38.21562180	27.22897850	2
18044	25	D2H000028	┼ŞAH─░N ELMACI	38.21346700	27.22969200	2
18045	25	D2K165535	┼Ş├£KR├£ S─░VASLI	38.30501400	27.30479800	2
18046	25	D2K233714	T.C TORBALI A├çIK CEZA ─░NFAZ KURUMU ─░┼ŞYURDU M├£D├£RL├£─Ş├£	38.44342200	27.17968400	2
18047	25	D2H000178	TO-PET PETROL ├£R├£N.DA─Ş.VE PAZ.SAN.T─░├ç. A.┼Ş.	38.18539900	27.20496500	2
18048	25	020035731	ULA┼ŞTIRMA PERSONEL OKUL KOMUTANLI─ŞI	38.33489000	27.14818200	2
18049	25	020026440	UZUNADA DEN─░Z KOMUTANLI─ŞI ASKER─░ KANT─░N─░	38.40002900	26.75336500	2
18050	25	D2K223541	VEND─░NG WORLD GIDA SANAY─░ T─░CARET LTD.┼ŞT─░.	38.38641760	27.08307530	2
18051	25	D2H001572	VEYSEL G├û├çEN	38.23836400	27.22517100	2
18052	25	D2H151700	YASEM─░N YE┼Ş─░LYAYLA	38.18723760	27.19352450	2
18053	25	D2H029116	YA┼ŞAR ALTIPARMAK	38.31614200	27.27865900	2
18054	25	D2H000052	YILDIZ PETROL LTD.┼ŞT─░.	38.27262930	27.23119070	2
18055	25	D2K113058	YUNUS EMRE ├ûZKAN	38.28820720	27.28320000	2
18056	14	020007360	ABBAS ASLAN- CEM GIDA	38.36293570	27.10151780	2
18057	14	020045900	ABBAS OKULMU┼Ş-M─░RKAN MARKET	38.36264400	27.10805100	2
18058	14	020050006	ABDULFETTAH YAMAN	38.36989500	27.10181000	2
18059	14	D2K199256	ABDULLAH AKAN	38.37406120	27.10769340	2
18060	14	D2K223924	ABDULLAH KARAHAN	38.37917170	27.10885430	2
18061	14	020053329	ABDURRAH─░M BATAN	38.39107760	27.09663810	2
18062	14	D2K208977	ADEM ASARARDI	38.36327060	27.10503720	2
18063	14	D2K135846	ADEM ├ûZDEM─░R	38.38547720	27.10095780	2
18064	14	D2K235897	Adem ├ûzdemir TOK─░	38.35178290	27.08622010	2
18065	14	D2K186016	A─ŞKAYA GIDA ─░N┼ŞAAT TUR─░ZM SANAY─░ T─░CARET LTD.┼ŞT─░.	38.37900080	27.10041600	2
18066	14	020046039	AHMET KILD─░┼Ş	38.37511700	27.09769900	2
18067	14	020045036	AHMET K├ûKSOY	38.38656400	27.09622700	2
18068	14	D2K105388	AK─░F PI├çAK├çI	38.36530700	27.10502600	2
18069	14	D2K220252	AL─░ EKBER AKBA┼Ş	38.37170650	27.10103290	2
18070	14	D2K199258	AL─░ TANYER─░	38.37090320	27.10668840	2
18071	14	020004853	ALTIN B─░RADERLER MARKET├ç─░L─░K T─░C.LTD.┼ŞT─░.	38.36970100	27.09671900	2
18072	14	020052725	ALTIN B─░RADERLER MARKET├ç─░L─░K T─░C.LTD.┼ŞT─░.	38.37058900	27.09665700	2
18073	14	D2K104560	ARSIN GIDA ├£R├£NLERI SANAYI VE TICARET LIMITED SIRKETI	38.37347400	27.10763100	2
18074	14	D2K082494	ARSLAN ALNIDEL─░K- ARSLAN MARKET	38.35913200	27.09675800	2
18075	14	D2K208026	ARZU AL	38.37296080	27.10670680	2
18076	14	D2K183596	ARZU SAN	38.38402500	27.11053500	2
18077	14	D2K211261	AT─░LA TUFAN	38.38113550	27.09683910	2
18078	14	D2K148116	AYDIN KOYUNCU	38.37398560	27.10479200	2
18079	14	020001258	AYHAN EMEN	38.36140600	27.08689300	2
18080	14	D2K184642	AY┼ŞE ARAS	38.36341850	27.10275580	2
18081	14	020052129	AY┼ŞE G├ûKTEPE	38.36224200	27.09075300	2
18082	14	020007865	AZ─░ZE AYDO─ŞAN	38.38783800	27.09176300	2
18083	14	D2K210300	BAHAR DUR─ŞUN	38.36294420	27.09315120	2
18084	14	020044223	BARI┼Ş MARKET ESK─░─░ZM─░R	38.37368800	27.10760400	2
18085	14	D2H033531	BARI┼Ş MARKET UZUNDERE TOK─░	38.35466700	27.08224300	2
18086	14	D2K151748	BA┼ŞDA┼Ş MARKET - ESK─░─░ZM─░R	38.37459100	27.10809700	2
18087	14	020000973	BA┼ŞPINARLAR GIDA MAD. SAN. T─░C.LTD.┼ŞT─░.	38.37495600	27.10442000	2
18088	14	D2K216056	B─░LENT YAPTITEREK	38.36395010	27.10785240	2
18089	14	D2K076322	B─░┼ŞAR AKIN	38.36648260	27.09637640	2
18090	14	D2K218946	BLACK WOLF GIDA ─░N┼Ş TUR OTOM SAN VE T─░C LTD ┼ŞT─░	38.37815190	27.10453840	2
18091	14	D2K230471	B├£┼ŞRANUR ┼ŞEN	38.37701710	27.10683730	2
18092	14	D2H184167	CAH─░T ERYILMAZ	38.38998250	27.09592920	2
18093	14	D2K218899	CANPOLAT BARAN	38.36100870	27.10220900	2
18094	14	D2K191637	CENK G├£NG├ûR	38.36103180	27.11893960	2
18095	14	D2K214735	D─░DEM G├£├çTEK─░N	38.38951450	27.09276390	2
18096	14	D2K214048	EGEL─░O─ŞLU PETROL ─░N┼ŞAAT GAYR─░MENKUL SAN.T─░C.A.┼Ş.	38.37137670	27.10866180	2
18097	14	D2K142641	EM─░N AYDIN	38.37725590	27.11070280	2
18098	14	D2H105721	EM─░N ├ûZDEM─░R	38.39066400	27.09277300	2
18099	14	D2K240603	EM─░NE ├ûNCEL	42.94838100	34.13287400	2
18100	14	D2K138463	EM─░NE ├ûZHAN	38.38593300	27.09328900	2
18101	14	D2K159431	EM─░R HASAN	38.37061400	27.09720700	2
18102	14	D2K147135	ENG─░N AYTEK─░N	38.36073420	27.09430190	2
18103	14	020048775	ERCAN BALTA	38.38211450	27.10360210	2
18104	14	D2K240370	ERG├£N ORHAN	38.38456130	27.10357840	2
18105	14	D2K196627	ERHAN SIZDIRICI	38.36286870	27.10506060	2
18106	14	020054423	EROL ONAY	38.36947300	27.09650000	2
18107	14	D2K204454	FELEMEZ YILDIZ	38.38281820	27.10532530	2
18108	14	020053286	F├£SUN KILIN├çASLAN	38.38924900	27.09548900	2
18109	14	020050824	G├£LSEREN KESG─░N	38.38734900	27.08991400	2
18110	14	D2H049470	G├£L┼ŞEN ─░─ŞDE	38.35214300	27.09764700	2
18111	14	020048134	G├£NE┼Ş MARKET GIDA KAFET. SAN. T─░C. LTD. ┼ŞT─░.	38.37028700	27.08265000	2
18112	14	020010486	G├£VEN AV┼ŞAR	38.37641100	27.10824700	2
18113	14	020046983	G├£VEN AV┼ŞAR-KARADEN─░Z MARKET	38.36604300	27.10645600	2
18114	14	D2K091123	HAT─░CE ├ûZDEM─░R - ├ûZDEM─░R GIDA	38.35872400	27.09180000	2
18115	14	D2H074957	HAYRULLAH TURAN	38.38784470	27.09351030	2
18116	14	D2K106113	H├£SEY─░N SAYGILI	38.37889500	27.11111700	2
18117	14	020047196	─░BRAH─░M KARTAL	38.37130700	27.10731000	2
18118	14	D2K231110	─░BRAH─░M YALINSU	38.36539220	27.10635900	2
18119	14	D2K226099	─░DR─░S AYDIN	38.37258390	27.10457100	2
18120	14	D2K217336	─░DR─░S Y├£KSEKDA─Ş	38.37317480	27.09730350	2
18121	14	D2K138053	KEMAL ├ûT├£N	38.36952200	27.09804200	2
18122	14	D2K239995	K─░NYAS B─░NG├ûL	38.37144750	27.09815500	2
18123	14	020008260	K─░PAY GIDA TEKS. KUYUMCULUK SAN. T─░C. LTD. ┼ŞT─░.	38.36506800	27.09341100	2
18124	14	D2K194325	K├ûY BAKKAL GIDA PAZ.END.VE TIC.LTD.┼ŞT─░.	38.37811900	27.11094020	2
18125	14	D2H000838	KULA├ç KIRAN	38.35307400	27.09890800	2
18126	14	D2K170968	LAV─░VA ─░N┼ŞAAT SANAY─░ VE T─░CARET A.┼Ş	38.36043770	27.09530310	2
18127	14	D2H161620	LEYLA ZENG─░N	38.39064370	27.09468840	2
18128	14	020050952	MAZLUM B─░LEN - B─░LEN MARKET	38.36780000	27.10050000	2
18129	14	D2K116917	MEC─░T DUMAN	38.38286050	27.11004490	2
18130	14	D2K233977	MEHMET S─░RA├ç AK├çEKOCE	38.37593130	27.10923830	2
18131	14	020044245	MEHMET ┼Ş─░R─░N B─░LEN	38.36254200	27.09621600	2
18132	14	D2K209683	MERKAR GRUP TUR─░ZM SANAY─░ VE T─░CARET A.┼Ş	38.37757900	27.10962060	2
18133	14	D2K241658	MEVL├£T ├ûNCEL	38.36950290	27.10849240	2
18134	14	D2K150492	MUHAMMED KARAO─ŞLAN	38.37401200	27.10666300	2
18135	14	D2K234055	MUHAMMED KIZILKAYA	38.38407370	27.09316720	2
18136	14	020009221	MUSTAFA AL─░ AY-TEKKE BAKKAL─░YES─░	38.36317200	27.09938200	2
18137	14	020005148	MUSTAFA EFET├£RK	38.36357540	27.09802040	2
18138	14	D2K212881	MUSTAFA TAN	38.36086890	27.10242540	2
18139	14	D2K135672	M├£SL├£M YILMAZ	38.36368310	27.09416630	2
18140	14	020017183	NAD─░R BELGE	38.37733800	27.09814400	2
18141	14	D2K129155	NAZLI S─░L─░SER─░	38.37525000	27.10771350	2
18142	14	020046450	NECMETT─░N ULUS	38.36475400	27.09331900	2
18143	14	D2K240585	NESR─░N A├çAR	42.94838100	34.13287400	2
18144	14	D2K129659	NURAN DO─ŞRU	38.37156240	27.09822180	2
18145	14	D2K232761	OSMAN AKSAK	38.36941980	27.10502860	2
18146	14	020046399	OSMAN G├£LTEK─░N	38.36918000	27.09622200	2
18147	14	D2K214573	├ûMER AYDO─ŞDU	38.37804410	27.11098500	2
18148	14	020001686	├ûNER BORAN	38.36280000	27.10440000	2
18149	14	020005654	RA─░F YILDIRIM - YILDIRIM MARKET	38.36878400	27.10820400	2
18150	14	D2K169926	RECEP ├çAKICI	38.38315550	27.09486270	2
18151	14	D2H185289	SAK─░NE ├ûZTA┼Ş	38.38665050	27.09130490	2
18152	14	D2K218614	SARI KARDE┼ŞLER GIDA TEKST─░L ─░N┼Ş.TURZ.YAKACAK ├£R├£N.SAN.VE T─░C.LTD.┼ŞT─░.	38.35961860	27.10393010	2
18153	14	D2K187416	SEDAT AKAY	38.36223630	27.08496130	2
18154	14	D2K242494	SELAT─░N ├ûZM├£┼Ş	42.94838100	34.13287400	2
18155	14	D2K230333	SEV─░M VURAL	38.35306140	27.09893710	2
18156	14	D2K163772	SEYFETT─░N ├ûNDER	38.36841360	27.10020090	2
18157	14	D2K173329	┼ŞAHBAZ DALMI┼Ş	38.36044590	27.10383660	2
18158	14	D2K175253	┼ŞEHMUS TA┼ŞAN	38.36277330	27.10515440	2
18159	14	020003200	┼ŞEMSETT─░N BOZY─░─Ş─░T-KARDE┼ŞLER MARKET	38.36058580	27.09278450	2
18160	14	D2K115617	TAH─░R BALABAN	38.38760760	27.09575180	2
18161	14	020052322	TANKAR OTOMOT─░V PETROL GIDA H─░Z.SAN.T─░C.LTD.┼ŞT─░.	38.38151600	27.10498400	2
18162	14	020049955	TOLGA Y├£CE	38.39035000	27.09632400	2
18163	14	D2K109811	TUNCAY KO├ç	38.38430400	27.10909900	2
18164	14	D2K180396	U─ŞUR BALTA	38.38607500	27.09849000	2
18165	14	020017257	U─ŞUR TURGUT MARKET├ç─░L─░K SAN.T─░C.LTD.┼ŞT─░.	38.36757800	27.09787900	2
18166	14	D2K232775	VURAL KARADEN─░Z	38.36179720	27.08971950	2
18167	14	020008391	YAHYA CEYLAN	38.38576900	27.09465600	2
18168	14	D2K179180	YA┼ŞAR AKSU	38.38225990	27.09726980	2
18169	14	D2K161658	YETER S─░VR─░	38.36439800	27.10116000	2
18170	14	D2K208428	YILDIRIM ├ûZCAN	38.38371690	27.09605970	2
18171	14	D2K237796	YUSUF DALGIN	38.38720840	27.09237000	2
18172	14	020004964	ZAFER MARKET├ç─░L─░K GIDA ┼ŞANS OYUNLARI SAN. T─░C. LTD ┼ŞT─░.	38.38876070	27.09586210	2
18173	50	D2H159160	ABDULLAH KO├çAK GIDA -├çAR┼ŞI	38.24976600	27.13398600	2
18174	50	D2H186853	ABDULLAH KO├çAK GIDA -SA─ŞLIK OCA─ŞI	38.25577660	27.13097720	2
18175	50	D2H186024	ABS GIDA SANAY─░ VE T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.25701190	27.14076210	2
18176	50	D2K240890	ACEM GIDA ─░N┼Ş. TUR. SAN VE T─░C. LTD. ┼ŞT─░.  - MENDERES	38.25294690	27.13602150	2
18177	50	D2H000087	ADEM YILDIRIM	38.25452320	27.16443360	2
18178	50	D2K212745	AD─░L D─░LEK GIDA G─░Y─░M ─░N┼Ş.SAN.VE T─░C.LTD.┼ŞT─░.	38.25061870	27.13150350	2
18179	50	D2H069164	ADNAN ─░LTERS	38.25783600	27.14198590	2
18180	50	D2H000053	AHMET AKBULUT	38.27257300	27.19227100	2
18181	50	D2H105107	AHMET AZAR	38.27654100	27.13065600	2
18182	50	020035119	AHMET ESEN	38.24873500	27.12408000	2
18183	50	D2H140460	AHMET TAN	38.20982400	27.14138100	2
18184	50	D2K233877	AK─░F VAR├ç─░N	38.24145950	27.13567200	2
18185	50	D2K233525	ALEYNA BA┼ŞE─ŞMEZ	38.25599930	27.13389120	2
18186	50	D2H018386	AL─░ KAYA	38.29115600	27.13001700	2
18187	50	D2H001894	AL─░ ├£Z├£ML├£	38.27663700	27.12969400	2
18188	50	D2H175849	A┼ŞKIN T├£RKER	38.24970380	27.13186290	2
18189	50	D2H184385	A┼ŞKIN T├£RKER II	38.25101940	27.13210410	2
18190	50	D2H134540	AT─░LLA ┼ŞEN	38.25005700	27.13207800	2
18191	50	D21187752	AYL─░N ├ûZBULUT	38.27370040	27.19161940	2
18192	50	D2H108821	AYSEL KESK─░N	38.27559500	27.13863000	2
18193	50	D2K232377	AYSUN YILDIZ	38.27130250	27.19553740	2
18194	50	D2H000300	BADEM├ûZ├£ GIDA TUR.SAN.VE T─░C.LTD.┼ŞT─░.	38.26986100	27.19131200	2
18195	50	D2H000152	BA─ŞDAT NAZLI DEM─░REL	38.24934100	27.12703900	2
18196	50	D2K234671	BA┼ŞDA┼Ş MARKET - MENDERES	38.26051540	27.12573070	2
18197	50	D2H196202	BATUHAN M─░NKARA	38.24852100	27.13698900	2
18198	50	D2H025924	BAYRAM ├£NAL	38.27750610	27.18671100	2
18199	50	D2H018206	B─░RG├£L ERBA┼Ş	38.24885400	27.13196500	2
18200	50	D2H161687	BURAK TARIM	38.24981790	27.13605460	2
18201	50	D2K212494	BUSE MUTLU	38.25696100	27.13639450	2
18202	50	D2H131705	B├£LENT AK	38.17972500	27.11377900	2
18203	50	D2K219276	CANER KARAKURT	38.26109120	27.14414780	2
18204	50	D2K237452	CENG─░ZCAN ├çEL─░K GIDA ─░├çECEK VE ┼ŞANS OYUNLARI T─░C. LTD. ┼ŞT─░.	38.28979170	27.12678190	2
18205	50	D2H169494	CO┼ŞKUN HASAN AK	38.18055120	27.11540710	2
18206	50	D2K209773	D─░LEK ┼ŞEN	38.24616000	27.11306600	2
18207	50	D2H156287	DURKADIN KARAKUZU	38.25740420	27.13151630	2
18208	50	D2H132316	DURSUN KISA	38.20658100	27.16870100	2
18209	50	D2H139700	EDA AKBULUT	38.25960000	27.07024000	2
18210	50	D2H134494	EL─░F UGUZ	38.19876520	27.13383950	2
18211	50	D2H068159	EM─░NE DUDU ├çAKAR	38.24575750	27.11303600	2
18212	50	D2H044593	EMRAH KILI├ç	38.24715500	27.13642700	2
18213	50	D2H189460	ERKAN BOZDA─ŞLI	38.20664450	27.16888870	2
18214	50	D2H128596	ERKAN ├ûZ├çELIK INS. TURIZM HARFIYAT SAN. VE TIC. LTD. STI	38.25557100	27.13918500	2
18215	50	D2H103200	EROL MUTLU	38.26655050	27.14624170	2
18216	50	D2H079392	FAT─░H G├£NE┼Ş	38.25167200	27.13548000	2
18217	50	D2K210001	FATMA D├£ZDA┼ŞLIK	38.25172270	27.13744500	2
18218	50	D2H011456	FEH─░M VATANSEVER	38.29007300	27.13214800	2
18219	50	D2H136323	FERDA D─░LEK	38.21630810	27.13848700	2
18220	50	020035216	F─░KRET G├£RE-G├£RPET PETROL	38.23751110	27.13611600	2
18221	50	D2H065764	FS SARIKAYA ─░N┼ŞAAT TAAHH├£T GIDA TUR─░ZM TA┼ŞIMACILIK SAN.T─░C.LTD.┼ŞT─░.	38.25396400	27.13130500	2
18222	50	D2H081705	G├ûRKEM ONUR G├ûKER	38.24959500	27.13302700	2
18223	50	D2H043818	G├£LAY┼ŞE G├£M├£┼Ş	38.26416900	27.13761400	2
18224	50	D2H000145	G├£LS├£M TOPSOY	38.27438800	27.19538100	2
18225	50	D21191335	G├£L┼ŞAH ┼ŞENKUL	38.26914490	27.19228600	2
18226	50	D2H000165	G├£LTEN D├ûNMEZ	38.28987900	27.12705900	2
18227	50	D2H000262	G├£REL PETROL T─░C. KOLL.┼ŞT─░.	38.22187100	27.13758400	2
18228	50	D2K205058	G├£RLER SARUCAN	38.25123320	27.13668080	2
18229	50	D2H052124	HAF─░ZE ├ûZG├£R	38.26639100	27.14347100	2
18230	50	D2H193354	HAKKI BAL	38.24478250	27.13508380	2
18231	50	D2H001806	HARUN KOPARAN	38.26046800	27.13031900	2
18232	50	D2H060133	HASAN YILMAZ	38.25879800	27.13481600	2
18233	50	D2H145516	HASAN Y├£KSEL	38.24421160	27.13490730	2
18234	50	D2H000108	HAVVA G├£NER	38.21063800	27.12841000	2
18235	50	D2H160403	HAYDAR FIRAT T├£ZEN	38.25423080	27.13720480	2
18236	50	D2K233973	H├£LYA KARABEL	38.26082970	27.13026640	2
18237	50	D2K231085	II.HASAN Y├£KSEL	38.25580750	27.13540240	2
18238	50	D2H001533	III.MERCANLAR PETROL ├£R.SAN.T─░C.LTD.┼ŞT─░.	38.27055500	27.15429100	2
18239	50	D2H000876	─░BRAH─░M ├ç├£MEN	38.26127200	27.14665000	2
18240	50	D2H000106	─░BRAH─░M DO─ŞAN	38.25856100	27.12738900	2
18241	50	D2H033447	─░LYAS ESEN	38.24862840	27.12083900	2
18242	50	D2H019103	─░LYAS ├ûR├£KER	38.26071200	27.13870200	2
18243	50	D2H000253	KADR─░YE KALKAN	38.24790800	27.13456700	2
18244	50	D2H143506	K├ûKSAL AK├çAY	38.24953000	27.12816200	2
18245	50	020035155	MEHMET KARBEL	38.24657900	27.13433400	2
18246	50	D2H000325	MEHMET ├£NAL ECE	38.20375800	27.16696400	2
18247	50	D2K224113	MERT TANATTI	38.25886280	27.10118780	2
18248	50	D2K212105	METE TOPDEM─░R	38.25518320	27.13809140	2
18249	50	D2H175150	METEHAN REN├çBER	38.25511930	27.13562250	2
18250	50	D2K239244	MET─░N YAMUK	38.25757460	27.14182540	2
18251	50	020035080	MNT-PET PETROL ├£R.TURZ.SAN.T─░C.LTD.┼ŞT─░.	38.27985060	27.19918800	2
18252	50	D2H086444	MUALLA KARADUMAN	38.25670800	27.14081800	2
18253	50	D2H154920	MUALLE YILDIZ	38.26180400	27.12731100	2
18254	50	D2H134651	MUSMUTLU GIDA B─░LG─░SAYAR T─░C.LTD.┼ŞT─░.-G─░RAY MARKET	38.26491130	27.13621170	2
18255	50	D2K233976	MUSTAFA DO─ŞAN	38.25688600	27.10195100	2
18256	50	D2K217060	MUSTAFA KASAPCI	38.26538500	27.14295340	2
18257	50	D2H042217	MUSTAFA ┼ŞAKAR	38.25040000	27.13120000	2
18258	50	D2H158407	NESR─░N ATALAYIN	38.25963750	27.14560680	2
18259	50	D2H041253	OKTAY KARAMAN	38.25280000	27.13600000	2
18260	50	D2K229332	ORDEN GIDA TEM─░ZL─░K MED─░KAL REKLAM MATBAA KIRTAS─░YE PEYSAJ ORG. SAN. V	38.28056240	27.12440600	2
18261	50	D2H000269	OSMAN G├£VEN	38.25151000	27.13300300	2
18262	50	D2H186852	├ûMER AKTA┼Ş	38.21707410	27.13825710	2
18263	50	D21156827	├ûZALTINDA─Ş AKARYAKIT SANAY─░ VE T─░CARET A.┼Ş.	38.27979190	27.21128720	2
18264	50	D2H078869	├ûZER TOYGARTEPE	38.27489400	27.19442000	2
18265	50	D2K219187	├ûZNUR UGUZ	38.25217130	27.13267570	2
18266	50	D2H126287	PAYIDAR RESTAURANT GIDA TURIZM SAN. VE TIC.LTD.STI	38.24076410	27.09875600	2
18267	50	D21088672	REF─░K MET─░N	38.27677350	27.18663810	2
18268	50	D2K203196	RUK─░YE AKKAYA	38.25988200	27.06995200	2
18269	50	D2H189443	SAL─░H ─░BRAH─░M ├ûZG├£R	38.26703210	27.14316490	2
18270	50	D2H187118	SAN─░YE BOZKURT	38.25406670	27.13484200	2
18271	50	D2H144774	SARI├çALI GIDA PAZARLAMA SANAY─░ VE T─░CARET LIMITED ┼Ş─░RKET─░	38.26592820	27.13318330	2
18272	50	D2H001550	SEFA YAL├çIN	38.26041500	27.12567800	2
18273	50	D2H157736	SENYA KAPLAN	38.25605300	27.13169200	2
18274	50	D2H000097	SERKAN KAN	38.27838200	27.12292500	2
18275	50	D2K242683	SONG├£L ├çEL─░K	38.21104420	27.12795530	2
18276	50	D2H129401	SON─░KA GIDA VE SANS OYUNLARI INS. TUR.VE BILG. SAN.VE T─░C.LTD.┼ŞT─░.	38.28941800	27.13058300	2
18277	50	D2H182452	SULTAN ELSEN	38.26042500	27.12997200	2
18278	50	D2H058046	S├£LEYMAN KILI├çASLAN	38.27412330	27.15153700	2
18279	50	D2H184891	TAH─░R ARSLANKO├ç	38.20435660	27.16652450	2
18280	50	D2K221325	TAH─░R BAYY─░─Ş─░T	38.18152000	27.10981580	2
18281	50	D2H128728	U─ŞUR T├£LGAY	38.25438840	27.13087750	2
18282	50	D2H155591	UMUT KARATA┼Ş	38.26734400	27.14545100	2
18283	50	D2H176034	UTKU KARAKO├ç	38.26509890	27.13473400	2
18284	50	D2H100161	├£NAL G├£NE┼Ş	38.25123800	27.14189100	2
18285	50	D2H183249	YEL─░Z VOLKMANN	38.25584550	27.13380030	2
18286	50	D2K229703	YUSUF PINARLI	38.27856100	27.12283500	2
18287	20	D2H000526	ABDULVAHAP G├£├çS├£Z	38.38972200	27.01768000	2
18288	20	D2K199112	AHMET I┼ŞIRCAN	38.39345280	27.00916160	2
18289	20	D2H081708	AKALAR GROS GIDA ─░N┼ŞAAT NAKL─░YE OTOMOT─░V T─░C.LTD.┼ŞT─░.	38.39404900	27.00151100	2
18290	20	D2K230557	AKIN ALVER	38.39266620	27.00817470	2
18291	20	020002743	AL─░ EKBER YILDIZ	38.38758200	27.05806600	2
18292	20	020055216	AL─░ KEMAL AYDIN	38.39115650	27.05145520	2
18293	20	D2H088707	AL─░CAN ├çANGAR	38.39452700	27.00494800	2
18294	20	D2H170787	ASOS KURYEM─░┼Ş SAN. T─░C. A.┼Ş	38.39464800	27.00470000	2
18295	20	D2K235911	AT─░LLA MERMERC─░	38.39040620	27.04160150	2
18296	20	020056526	AYDO─ŞDU DO─ŞAN	38.39401200	27.03884900	2
18297	20	D2H001788	AYSEL SEV─░N	38.39009300	27.01413500	2
18298	20	D2H154099	AYTA├ç KAYA	38.39110700	27.04009200	2
18299	20	D2H179850	AZN GIDA HAYV.─░N┼Ş.SAN. VE T─░C.LTD.┼ŞT─░.	38.39415970	27.00912260	2
18300	20	D2H161813	BAHR─░ SARA├ç	38.40073610	27.05006240	2
18301	20	D2K227640	BAKIR DAYAN	38.39316910	27.01038400	2
18302	20	020035434	BARI┼Ş MARKET -NARLIDERE 1	38.39469000	27.00410800	2
18303	20	D2H117521	BARI┼Ş MARKET -NARLIDERE 3	38.39436580	27.00764360	2
18304	20	D2H192016	BA┼ŞDA┼Ş MARKET - NARLIDERE	38.39272370	27.00625530	2
18305	20	D2H115443	BAYRAM\tAKTA┼Ş	38.38990930	27.01403660	2
18306	20	D2K218098	BURAK GAR─░P KAYA	38.39260200	27.00481400	2
18307	20	D2K212958	B├£LENT ├çELEB─░	38.39422300	27.00981000	2
18308	20	D2K213250	CARNOVA OTOMOT─░V SAN. VE T─░C.LTD.┼ŞT─░.	38.39095660	27.02724060	2
18309	20	D2H131841	├çA─ŞMER GIDA ─░├çECEK SANAYI T─░CARET L─░MITED ┼Ş─░RKETI	38.39253910	27.02604590	2
18310	20	D2H090044	├ç─░─ŞDEM ARDI├ç	38.37779000	27.01159100	2
18311	20	D2K227471	├çOBAN 1 GIDA T─░CARET VE L─░M─░TED ┼Ş─░RKET─░	38.39516410	27.00151080	2
18312	20	020035450	DEDE ARSLAN GIDA MAD. PAZ.T─░C.LTD.┼ŞT─░.	38.39415300	27.01243700	2
18313	20	D2K208834	DERYA TA┼Ş	38.39262440	27.00451010	2
18314	20	D2K225761	DERYA YILDIRIM ┼Ş─░P┼ŞAK	38.39354200	27.01803400	2
18315	20	D2K242474	DOKUZ EYL├£L MARKET SANAY─░ VE T─░CARET L─░M─░TED ┼Ş─░RKET─░	42.94838100	34.13287400	2
18316	20	D2H000510	DURSUN BAYRAK	38.39357600	27.02291800	2
18317	20	D2H167140	DVC SOSYAL H─░ZMETLER ─░N┼ŞAAT GIDA TUR─░ZM OTOMOT─░V MED─░KAL SANAY─░ VE T─░C	38.40675010	27.03537960	2
18318	20	020054076	EGEGROS TEM─░ZL─░K B─░L─░┼Ş─░M ─░HT─░YA├ç MADDELER─░ OTO ORG. H─░Z. SAN T─░C LTD.	38.39050700	27.05049200	2
18319	20	D2K203807	EMRAH KILIN├ç	38.39249240	27.01787360	2
18320	20	D2K199873	EMRE KARATA┼Ş	38.39187100	27.04076300	2
18321	20	020049661	ERD─░N├ç POLAT-ERG├£L MARKET	38.39120000	27.05440000	2
18322	20	D2K227304	ERTAN KESK─░N	38.38445200	27.00866300	2
18323	20	020035496	ESER KURUYEMIS GID.INS.TAS.PEY.BIL.TEM.SAN.LTD.STI	38.39443200	27.00595800	2
18324	20	D2H158558	EYY├£P ├ûZALDIKA├çTI	38.38774970	27.05209890	2
18325	20	D2H000557	FAT─░H G├ûL	38.39017880	27.00624210	2
18326	20	020035481	FEVZ─░ ADITATAR	38.39248900	27.02293900	2
18327	20	D2K204840	F─░L─░Z FIRAT	38.38870770	27.05437960	2
18328	20	020035501	FO├çALILAR PETROL	38.39428590	27.01072470	2
18329	20	020058360	GER├çEK KIYAK	38.39299300	27.04563700	2
18330	20	D2K234757	G├ûKHAN ERAM─░L	38.39182030	27.04183170	2
18331	20	D2H191774	G├ûKHAN ├£NC├£	38.38880410	27.05139310	2
18332	20	D2H001105	HAL─░L ├çEL─░K	38.38881100	26.99973600	2
18333	20	D2H053839	HAL─░L ├û─ŞREN	38.40076600	27.05004900	2
18334	20	020050205	HAL─░L ├ûZCAN-K├£├ç├£─Ş├£M MARKET	38.39307400	27.04113900	2
18335	20	020008364	HAL─░T ┼Ş─░M┼ŞEK-MEL─░S MARKET	38.39338600	27.04485200	2
18336	20	D2H054624	HALUK FO├çALI PETROLC├£L├£K LOJ.─░N┼Ş.OTO. GIDA LTD.┼ŞT─░.	38.39287500	27.02264000	2
18337	20	D2H053836	HAM─░T HARLAK	38.41015900	27.03399200	2
18338	20	020014869	HANDAN ├çINAR	38.38569100	27.05670100	2
18339	20	D2H098246	HASAN ├ç─░L	38.39453600	26.99137200	2
18340	20	D2H053837	HASAN DEV	38.41055200	27.03380100	2
18341	20	D2K233533	HATAY LOKANTA ORG. GIDA SPOR FAAL─░YET UNLU MAM. SAN. VE T─░C. LTD. ┼ŞT─░.	38.39356100	27.03792420	2
18342	20	020010317	H├£SEY─░N BAYATBALA─Ş	38.38901480	27.04680880	2
18343	20	D2H145811	H├£SEY─░N ┼ŞENG├£L	38.39468170	27.01444630	2
18344	20	D2K222891	II.MEHMET ┼Ş─░R─░N YILDIRIM	38.39339930	27.02032370	2
18345	20	D2H197131	─░BRAH─░M HAL─░L TANBAY	38.39125630	27.05355590	2
18346	20	D2H162848	─░FFET BARAN	38.38969280	27.01773130	2
18347	20	D2H000479	KARASU PETROL ├£R.─░N┼Ş.SAN.VE T─░C.LTD.┼ŞT─░.	38.39683300	27.02458100	2
18348	20	D2H182786	KAYA KAYA	38.39023300	27.04031800	2
18349	20	D2H018101	KAYA TURISTIK TESISLERI TITREYENG├ûL OTELCILIK A.S - KAYA IZMIR THERMAL	38.38802990	27.03107340	2
18350	20	D2H152953	KER─░M RAD	38.39505730	27.01309800	2
18351	20	020002794	KIZILTU─Ş KAFE ─░┼ŞLETME GIDA TURSAN T─░C.LTD.┼ŞT─░.	38.38753850	27.04363610	2
18352	20	D2K242308	K├û┼ŞEM CENTER GIDA KUYUMCULUK OTOMOT─░V AKARYAKIT TUR─░ZM ─░N┼ŞAAT EMLAK TE	38.39536810	27.00130430	2
18353	20	D2H002022	LAT─░F SOYDAN MARKET├ç─░L─░K TA┼ŞIMACILIK TUR─░ZM SEYAHAT SAN.T─░C.LTD.┼ŞT─░.	38.39323300	27.03430400	2
18354	20	D2H183049	MARCA CAFE GIDA SAN.VE T─░C. LTD.┼ŞT─░.	38.40699800	27.03529800	2
18355	20	D2K232003	MEHMET BALL─░	38.38973870	27.00130870	2
18356	20	D2H000481	MEHMET DALGIN	38.39355700	27.01227100	2
18357	20	020013333	MEHMET K─░ND─░K- AKIN ├çEREZ	38.38637300	27.05532400	2
18358	20	D2H000539	MEHMET SAL─░H YUMU┼ŞAK	38.39389900	27.01556200	2
18359	20	D2H145716	MEHMET SARSILMAZ	38.38955300	27.05644310	2
18360	20	D2H171448	MEHMET ┼Ş─░R─░N YILDIRIM	38.39303900	27.02224800	2
18361	20	D2H195985	MEL─░H KARAG├ûZ	38.38943600	27.04325200	2
18362	20	D2H196853	MEL─░S KALKAN	38.39147250	27.05300160	2
18363	20	020051176	MEM─░┼Ş ├çEL─░K	38.38757310	27.05659910	2
18364	20	020018604	MERAL AKTA┼Ş-DEN─░Z MARKET	38.39246700	27.04266700	2
18365	20	020048999	MESARET K├£LL├£O─ŞLU	38.38892200	27.04094900	2
18366	20	D2H041492	MET─░N ADIG├£ZEL	38.39163600	27.00369900	2
18367	20	D2H193815	MET─░N ZENG─░L	38.38989430	27.01414050	2
18368	20	D2K223639	MURAT G├ûKSU	38.38948740	27.05688380	2
18369	20	020004702	MURAT TOPER CEYLAN	38.38759990	27.05217730	2
18370	20	D2K219007	MUSTAFA ├ûZY├£REK	38.39371730	27.01480180	2
18371	20	D2H113221	MUSTAFA YURTER─░	38.39305030	27.00630620	2
18372	20	D2K229396	M├£NEVVER TANRIVERD─░	38.38884560	27.05326470	2
18373	20	020035436	N─░HAT AVCI	38.39602790	26.99828560	2
18374	20	D2H001777	N─░YAZ─░ A─ŞIN	38.39416300	27.00826100	2
18375	20	D2H021369	NUH C─░HANG─░R DURGUN	38.38715580	27.03583420	2
18376	20	D2H106134	NURETT─░N D─░K─░C─░	38.39509470	27.00216470	2
18377	20	D2H189408	O─ŞUZHAN TUR─░ST─░K.─░┼ŞL.─░N┼Ş.SAN. VE T─░C. LTD. ┼ŞT─░.	38.41015720	27.03686340	2
18378	20	D2H001593	OLU┼Ş ALACAN	38.39565000	27.01014700	2
18379	20	020018578	├ûZG├£L D─░┼Ş├ç─░-O─ŞUZHAN ┼ŞARK├£TER─░	38.38755500	27.05760200	2
18380	20	020003862	RECA─░ ├çOLAK	38.39206300	27.03817200	2
18381	20	020052211	RECEP AKKOYUNLU	38.38906330	27.05085180	2
18382	20	D2K232790	REMZ─░ TEK─░N	38.39491100	27.00240930	2
18383	20	D2K227315	SAN─░YE URHAN	38.39418080	27.04082390	2
18384	20	020009972	SELAHATT─░N B─░LG─░	38.38789000	27.04488400	2
18385	20	020057428	SELVER VURAL	38.38833500	27.04911800	2
18386	20	D2H000542	SERP─░L YET─░M	38.40465700	27.01010800	2
18387	20	D2H105162	SEZG─░N KARAKA┼Ş	38.40974700	27.03427600	2
18388	20	020052821	S─░NEM YAVA┼Ş	38.39047000	27.04954900	2
18389	20	D2H002263	┼ŞAD─░YE RE─░S	38.39196520	27.02759010	2
18390	20	D2H073853	┼ŞAH─░N ASLAN	38.38310100	27.01180600	2
18391	20	020035470	┼ŞAH─░N DEM─░R LTD ┼ŞT─░	38.39374900	27.01131800	2
18392	20	D2K233468	┼ŞEHMUS KARTI	38.40847930	27.03550690	2
18393	20	D2H066087	┼Ş├£KR─░YE ASLANTA┼Ş	38.39319800	27.02322300	2
18394	20	D2H000490	TELAT EKER	38.39026570	27.00343370	2
18395	20	D2H002112	TURAN G├£NER─░	38.39120500	27.01153400	2
18396	20	D2K240429	UFUK TAN	38.38859000	27.05626200	2
18397	20	D2H065225	ULA┼Ş DEM─░R	38.41032100	27.03384700	2
18398	20	020004040	ULA┼Ş KARGIN	38.38770000	27.05580000	2
18399	20	020053728	YEL─░Z DEM─░RC─░GED─░─Ş─░ - YAREN GIDA VE TEKEL BAY─░	38.39392420	27.04426270	2
18400	20	D2H194051	YILDIZ ─░LDO─ŞAN	38.38903240	27.05284230	2
18401	20	D2H153653	YILMAZ KIZIL	38.39498800	27.04230300	2
18402	20	D2H000511	Y─░Y─░T GIDA ├£R├£N SAN.VE T─░C.LTD.┼ŞT─░.	38.38999200	27.02653500	2
18403	20	D2H079632	YUNUS EMRE ERDEM	38.40789600	27.00042500	2
18404	20	D2H000509	YUSUF KIRAN	38.38856100	27.01556500	2
18405	20	D2K239099	ZERDE┼Ş ERKU┼Ş	38.38841600	27.01354100	2
18406	20	020013343	Z─░NNET UTKU	38.38634670	27.05535540	2
18407	21	D2K154238	ABDULCEBBAR YILDIZ	38.45361460	27.27121030	2
18408	21	D2K240369	ABDULLAH ERHAN ├çOLAK	42.94838100	34.13287400	2
18409	21	D2H000449	ABDURRAH─░M NURSOY	38.29606600	27.18171000	2
18410	21	D2H030509	ABDURRAH─░M NURSOY	38.30631700	27.17634800	2
18411	21	D2H046164	ABDURRAH─░M NURSOY	38.29863200	27.17862500	2
18412	21	D2K103657	ABDURRAH─░M NURSOY	38.30820700	27.15863500	2
18413	21	D2K131797	ADEM UYGUN	38.45880300	27.27555110	2
18414	21	D2K085683	AHMET BAKI┼Ş - BAKI┼Ş MARKET	38.45842900	27.26983100	2
18415	21	D2K059116	AKTUR ARA├ç MUAYENE ─░STASYONLARI ─░┼ŞLETMEC─░L─░─Ş─░ A.┼Ş.	38.31275200	27.16405300	2
18416	21	D2K226931	AL─░ ─░NCE	38.45340710	27.26932260	2
18417	21	D2K197419	ATANAN BUDAK	38.37952220	27.24063510	2
18418	21	D2K223581	AT─░LLA YILMAZ	38.44691200	27.30269700	2
18419	21	D2K232676	AYDIN KARAARSLAN	38.29387600	27.17057800	2
18420	21	D2K078345	AYDIN SEVER	38.29997200	27.17542900	2
18421	21	D2K161029	AY┼ŞE B├£Y├£KBO─ŞA	38.42041000	27.25098200	2
18422	21	020048067	AY┼ŞE ─░┼ŞYAPAR	38.45222900	27.25014900	2
18423	21	D2K207508	BARI┼Ş ├ç─░├çEK	38.45841280	27.27076400	2
18424	21	D2K221592	BA┼ŞT├£RK ┼ŞANS OYUNLARI VE MARKET T─░CARET LTD.┼ŞT─░.	38.30043230	27.16642840	2
18425	21	D2K223456	BAYRAM ├£R├£N	38.45603700	27.26877290	2
18426	21	D2K171058	B─░Z─░M ─░HRACAT VE ─░THALAT GIDA ─░N┼ŞAAT LTD.┼ŞT─░.	38.29841440	27.17789160	2
18427	21	D2K231556	CENG─░ZCAN ├çEL─░K GIDA ─░├çECEK VE ┼ŞANS OYUNLARI T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.29789990	27.17641660	2
18428	21	020018597	CUMA ├ûZG├£R	38.45331200	27.25274300	2
18429	21	020029313	├çALIYURT GIDA LTD.┼ŞT─░	38.45270000	27.26620000	2
18430	21	020035090	DEN─░Z ├çETIN	38.35454800	27.23522900	2
18431	21	D2K156099	DO─ŞUKAN AYDIN	38.44724940	27.29947840	2
18432	21	D2K223636	EBUBEK─░R AYKUT	38.29395970	27.17396560	2
18433	21	D2K158039	EMINERLER GIDA TEMIZLIK MAD PAZARLAMA TASIMACILIK LTD STI - KAYMAZLAR	38.34987310	27.22486870	2
18434	21	D2F032133	EM─░NE AKKA┼Ş	38.51188670	27.32095560	2
18435	21	D2K183496	ERAY YALDIZ	38.36400810	27.27281290	2
18436	21	D2K217954	ERC─░VAN GIDA TUR─░ZM EMLAK ─░N┼ŞAAT OTO SAN VE T─░C.LTD.┼ŞT─░.	38.45535700	27.26902100	2
18437	21	D2H001820	ERHAN ├ûZKAN	38.29880700	27.17920700	2
18438	21	D2K153981	ESAT G├£LER	38.30431320	27.17802170	2
18439	21	D2K240634	ESENG├£L G├£ZEL	42.94838100	34.13287400	2
18440	21	D2K233752	FER─░T ├çET─░NKAYA	38.44927710	27.31693940	2
18441	21	D2H035596	G├£LTEN PARLAS	38.30108500	27.17821700	2
18442	21	D2H044206	HACER KARAN	38.29595680	27.17026920	2
18443	21	020056908	HACI KAYA	38.44789800	27.26356110	2
18444	21	D2F046271	HAF─░ZE G├£N├£VAR	38.44925900	27.31431400	2
18445	21	D2H018226	HAL─░L ├ûNDER	38.29986600	27.17546000	2
18446	21	D2K182304	HARUN S├ûK├£TL├£	38.45520970	27.26868490	2
18447	21	D2K182609	HAT─░POGLU PAZ.PET.├£R├£N.GIDA SAN.VE TIC.LTD.STI.NALD├ûK├ûN SB 2.	38.45354900	27.26148300	2
18448	21	D2K182608	HAT─░POGLU PAZ.PET.├£R├£N.GIDA SAN.VE TIC.LTD.STI.NALD├ûK├ûN SB.	38.45417650	27.25954090	2
18449	21	020029903	HMS PETROL ├£R├£NLER─░ TUR─░ZM TA┼ŞIMACILIK ─░N┼ŞAAT SANAY─░ VE T─░C. LMT.┼ŞT─░	38.46229700	27.33867900	2
18450	21	D2K241912	─░REM MAV─░ B├£Y├£KKAMBAK	42.94838100	34.13287400	2
18451	21	D2K145312	─░SMA─░L SOY	38.29460050	27.16956100	2
18452	21	D2K148978	─░SMA─░L SOY	38.29833490	27.17334130	2
18453	21	D2F044450	KADER NESL─░HAN ├ûZALP	38.45045470	27.31574730	2
18454	21	D2K228358	KAYHAN ALTUN	38.44721500	27.29646900	2
18455	21	D2K153435	KOZLUK DOGAN GIDA INSAAT NAKLIYAT PETROL VE TEKS. TURIZ. SAN. VE TIC.L	38.29921920	27.16704070	2
18456	21	D2H001831	KOZLUK DO─ŞAN GIDA ─░N┼Ş.NAK.PET.TEKS.TUR.SAN.T─░C.LTD.┼ŞT─░.	38.30107300	27.16567160	2
18457	21	D29001926	LEYLA ├çEL─░K	38.45546300	27.26914500	2
18458	21	D2K118757	MEHMET MUTLU	38.30207600	27.17398900	2
18459	21	D29001869	MEHMET ZEK─░ ├çEL─░K	38.45752700	27.26887200	2
18460	21	D2K234465	MERYEM BOZKURT	38.37749120	27.23998830	2
18461	21	D2K216582	MURAT ├çET─░N	38.45717510	27.27267550	2
18462	21	D2H000429	MURAT FIRAT	38.30993500	27.16505300	2
18463	21	D2K113338	MURAT G├£L	38.50012460	27.28509650	2
18464	21	D2K202051	MURAT ┼Ş─░M┼ŞEK	38.30397360	27.16318340	2
18465	21	D2F024435	MUSTAFA ERKO├ç	38.49931400	27.28678500	2
18466	21	D2K199871	M├£NEVVER YILMAZ	38.53370600	27.29254600	2
18467	21	D2K176317	NALD├ûKEN PETROL OTOMOT─░V SANAY─░ VE T─░CARET A.┼Ş	38.45436580	27.25925870	2
18468	21	D2K122222	NEZ─░R ELMAS	38.29358380	27.17189690	2
18469	21	D2K241906	N─░DA ATALAY-TEKER MARKET	42.94838100	34.13287400	2
18470	21	D2K184237	N─░HAT ELTER	38.45658000	27.27322100	2
18471	21	D2H000438	N─░LG├£N ├çALI┼ŞKAN	38.29599200	27.18322600	2
18472	21	D2K160559	N─░ZAMETT─░N ├çEV─░K	38.29883170	27.17078110	2
18473	21	D2K218752	NURULLAH KUTLUAY	38.44718270	27.29903150	2
18474	21	D2H001833	OKTAY CESUR	38.30107600	27.17168600	2
18475	21	D2F003483	ORMAN PETROL ─░N┼Ş.TUR.SAN.T─░C.LTD.┼ŞT─░	38.50835400	27.26952800	2
18476	21	D2H040247	OSMAN TULUM	38.36346520	27.28401920	2
18477	21	D2K217955	├ûZG├£R DO─ŞAN	38.45298600	27.26624200	2
18478	21	D2H001073	PAK─░ZE EKER	38.29278000	27.16989400	2
18479	21	D2H027058	RAB─░A ER	38.36423200	27.27199500	2
18480	21	D2K085297	RUK─░YE BAYCAN - BAYCAN MARKET	38.45189200	27.31380100	2
18481	21	D2K160482	RUK─░YE KARATA┼Ş	38.51739600	27.27064300	2
18482	21	D2K107018	SAF─░YE KESK─░N	38.37779800	27.24052500	2
18483	21	020029588	SARITA┼Ş TUR─░ZM ─░N┼Ş.T─░C.NAK.LTD.┼ŞT─░.	38.46184600	27.33947700	2
18484	21	D2K238836	SATI KANDEM─░R	38.29249500	27.17403100	2
18485	21	D2K206810	SE MARKET ─░┼ŞLETMES─░	38.30790090	27.15697320	2
18486	21	D2K167065	SEDAT ALTAY ZEYT─░N YA─Ş ZEYT─░N ├£R├£NLER─░ GIDA PETROL TUR─░ZM ─░N┼Ş PAZ.SAN	38.51983130	27.27541110	2
18487	21	D2K231411	SEDAT ├ûZG├£R	38.29491260	27.18432840	2
18488	21	D2K241417	SEL─░N T├£TENK	42.94838100	34.13287400	2
18489	21	D2K175312	SERAY35 GIDA TURIZM INSAAT SANAYI VE TICARET LTD.┼ŞT─░.	38.30510310	27.17841350	2
18490	21	D2K218751	SERDAR ─░HT─░YA├ç MAD.GIDA VE ─░N┼Ş.SAN.T─░C.LTD.┼ŞT─░.	38.41645500	27.24068000	2
18491	21	020057990	SERDAR KARABULUT	38.41987860	27.24690470	2
18492	21	D2K239536	SERVET ESEN	38.44622120	27.29741650	2
18493	21	D2K239105	SEVAL KARAKA┼Ş YILMAZ	42.94838100	34.13287400	2
18494	21	D2K237782	SEVG─░ DUMAN	38.41955620	27.25155090	2
18495	21	D2H000472	SEV─░NAL S├ûNMEZ	38.30530060	27.16286100	2
18496	21	D29001685	SEY─░THAN KARAKA┼Ş	38.45686100	27.27103500	2
18497	21	D2K113718	S─░BEL KARAK├ûSE	38.44749300	27.30068300	2
18498	21	D2K235752	S─░MGE YILDIRIM	42.94838100	34.13287400	2
18499	21	D2K173205	SMYRA END├£STR─░YEL GER─░ D├ûN├£┼Ş├£M ─░N┼ŞAAT GIDA LTD.┼ŞT─░.	38.35535100	27.23743800	2
18500	21	D2H002135	SUAT ┼ŞALLI	38.36370000	27.27110000	2
18501	21	D2K106902	┼ŞAK─░R KARADEN─░Z	38.45516200	27.27099200	2
18502	21	D2K146884	TANER BA┼ŞT├£RK	38.30376720	27.17324610	2
18503	21	D2K125729	TEMSA AKARYAKIT INSAAT NAKLIYAT MADENCILIK SANAYI VE TICARET LIMITED S	38.51473300	27.27687850	2
18504	21	D2K131153	TURAN TANGA├ç	38.44678840	27.30052040	2
18505	21	D2K175283	TURHAN RESTAURANT GIDA INSAAT SANAYI VE TICARET LTD.┼ŞT─░.	38.30740790	27.17821240	2
18506	21	D2K124098	UMUT BA─ŞI┼Ş	38.36342800	27.28253400	2
18507	21	D2K231235	VAROL S─░VR─░KAYA	38.29292610	27.17392900	2
18508	21	D2F003486	VEBA┼Ş AKARYAKIT TUR.T─░C.LTD.┼ŞT─░.(MERKEZ)	38.48210400	27.24242800	2
18509	21	020035162	VEL─░ BAKIR GIDA SAN T─░C LTD ┼ŞT─░	38.35655600	27.22951300	2
18510	21	D2H002100	VEYSEL KORKMAZ	38.36341600	27.28379200	2
18511	21	D2K175341	YAKAMAR MARKET├ç─░L─░K SANAY─░ VE T─░CARET LTD.┼ŞT─░.	38.51189190	27.32219510	2
18512	21	D29000860	YA┼ŞAR DA┼Ş	38.44708200	27.29845300	2
18513	21	D2K189407	Y├ûR├£K OBASI RESTORAN E─ŞLENCE TUR─░ZM VE SERV─░S ─░┼ŞLETMEC─░L─░─Ş─░ LTD.┼ŞT─░.	38.34997200	27.23859800	2
18514	21	D2K226584	YUSUF AYCAN	38.35425790	27.22815810	2
18515	21	D2K227821	Y├£CEL YILMAZ	38.44767540	27.29346690	2
18516	21	D2K098802	ZAFER ─░NCE	38.29777000	27.17564400	2
18517	53	D2H069006	ABDULLAH YILDIZ	38.34227200	26.86612900	2
18518	53	D2H134210	ADA7 GIDA TUR─░ZM SAN. VE T─░C.LTD.┼ŞT─░.	38.37856400	26.89758300	2
18519	53	D2K242576	ALAADD─░N ├çINAR	42.94838100	34.13287400	2
18520	53	D2K228117	AL─░ KANPAKO─ŞLU	38.21251500	26.80521400	2
18521	53	D2H000803	AL─░ UYGUR	38.25881400	26.80730500	2
18522	53	D2H179981	AL─░ YAVUZ	38.21074900	26.82716400	2
18523	53	D2K220228	ARZU BEYAZ	38.36156040	26.89530410	2
18524	53	D2K239810	ASYA PREMIUM ALCOHOL CENTER ALKOL TICARET LIMITED SIRKETI	38.37829550	26.89388460	2
18525	53	D2H001252	AY┼ŞE CANDAN	38.31411900	26.85950800	2
18526	53	D2H028665	BARI┼Ş MARKET -G├£ZELBAH├çE	38.37772100	26.88922300	2
18527	53	D2H171381	BARI┼Ş PELTEK	38.19402900	26.83842600	2
18528	53	D2K225814	BA┼ŞDA┼Ş MARKET - SEFER─░H─░SAR	38.19498840	26.83525360	2
18529	53	D2K230414	BERKER AYSAL	38.37920050	26.90367220	2
18530	53	D2H000699	B─░RSEN UTMA	38.31398500	26.86001200	2
18531	53	D2H147237	BURAK AVKIRAN	38.35896930	26.88704100	2
18532	53	D2K240840	BURAK ├çITAK	38.20095140	26.84245260	2
18533	53	D2K204177	CANAN AKCURA  AMBARCI	38.33638400	26.86366800	2
18534	53	D2K224164	Carrefour ─░zmir Seferihisar S─▒─şac─▒k S├╝pe (7122)	38.19217430	26.78549110	2
18535	53	D2H143241	CELALETT─░N YE┼Ş─░LBA─Ş	38.38144070	26.91339840	2
18536	53	D2K242587	CEM─░L ERASLAN MARKET GIDA TOPTAN VE PERAKENDE T─░CARET LTD.┼ŞT─░.	38.19629090	26.83964780	2
18537	53	D2K203984	CEM─░L KILI├çASLAN ERASLAN	38.19631140	26.83966830	2
18538	53	D2H091599	CEM─░LE ├ç─░FT├ç─░O─ŞLU	38.38305200	26.93659100	2
18539	53	D2K211225	CENG─░Z AKSU	38.19619200	26.83896400	2
18540	53	D2H175798	CENG─░Z ├çANGAR	38.19248220	26.78650600	2
18541	53	D2H192218	CENK BULUT	38.22591100	26.82222300	2
18542	53	D2K211981	CEVR─░YE ALTIPARMAK	38.19894840	26.84066340	2
18543	53	D2H000617	C─░HAN YE┼Ş─░LKAYA	38.24686800	26.84225600	2
18544	53	D2H192474	CUMAL─░ KESK─░N	38.19651210	26.83607710	2
18545	53	D2K237354	├çA─ŞDA┼Ş ├çEL─░K	38.19542880	26.83719810	2
18546	53	D2H155382	├çAVUSOGLU PAZARLAMA GIDA INSAAT NAKLIYE TURIZM SANAYI VE TICARET LIMIT	38.19509950	26.84140640	2
18547	53	D2H117128	├çIFTLIK TOPSA GIDA TAR. HAYV.INS.NAK.SAN. VE TIC. - ├ç─░FTL─░K GROSS	38.34330000	26.86419600	2
18548	53	020035721	DEDEO─ŞULLARI PETROL SO─ŞUK HAVA DEP.GID.SAN─░T─░C.LTD.┼ŞT─░	38.33070000	26.86270000	2
18549	53	D2K242586	DEN─░Z ├ûZEN MARKET GIDA TOPTAN VE PERAKENDE T─░CARET LTD.┼ŞT─░.	42.94838100	34.13287400	2
18550	53	D2K237523	DUYGU K├£├ç├£K	38.19591700	26.83823500	2
18551	53	D2H001353	EDA EKEN	38.37756100	26.88536500	2
18552	53	D2H052307	EDA KAYA	38.28563700	26.85016600	2
18553	53	D2K222145	EGENAR AKARYAKIT LTD.┼ŞT─░.	38.22379200	26.82830240	2
18554	53	D2K231094	EL─░F G├£L┼ŞAH SEFERO─ŞLU	38.21268060	26.80855320	2
18555	53	D2H178563	EL─░FE DEM─░R	38.19832490	26.84311530	2
18556	53	D2K226534	EREN KAYA	38.19272580	26.78592240	2
18557	53	D2K221880	ERG├£N KEM─░K II	38.19950520	26.84353140	2
18558	53	D2H137904	ERKAN BEKAR	38.35828570	26.88750450	2
18559	53	D2H150321	ER┼ŞAN ERDO─ŞAN	38.19783830	26.83622310	2
18560	53	D2H001136	ERTEMO─ŞULLARI GIDA PAZ.SAN.VE T─░C.LTD.┼ŞT─░.	38.24690500	26.84200500	2
18561	53	D2H099940	ESAT TURHAN	38.36045500	26.88608100	2
18562	53	D2H000636	E┼ŞREF ┼ŞENG├£L	38.27457400	26.82932300	2
18563	53	D2H037413	FA─░K ├çAVDARCI	38.24894600	26.83374700	2
18564	53	D2K205551	FARUK ALADA─Ş	38.37805200	26.89270200	2
18565	53	D2H031100	FAT─░H ERB─░L	38.20179000	26.83883800	2
18566	53	020035437	FATMA KUTLU	38.37793900	26.89173000	2
18567	53	D2H152839	FATMA TA┼ŞDEM─░R	38.37815050	26.89197610	2
18568	53	D2H001936	FEHM─░ ONUR HARMAN	38.19542070	26.83887660	2
18569	53	D2H023112	FEYZAN ├ûZDER	38.19344700	26.78464200	2
18570	53	D2K199290	G├ûKHAN GEN├çTEM	38.19034630	26.83778620	2
18571	53	D2H193163	G├£LBEN BUDAK	38.19700620	26.84039320	2
18572	53	D2K241714	HACER ├ûZL├£DERE	38.21070160	26.82739050	2
18573	53	D2K211003	HAKAN UYSUN	38.19940900	26.83970100	2
18574	53	D2H067833	HAKKI OKTAY VARICIO─ŞLU	38.26375300	26.83594400	2
18575	53	D2H047793	HALE UMAY	38.37587500	26.87736800	2
18576	53	D2H000775	HANYALI PETROL TUR.SAN.LTD.┼ŞT─░.	38.36042500	26.87288000	2
18577	53	D2K217059	HASAN ERDAL G├£ZEL	38.38305800	26.92937760	2
18578	53	D2H012495	HASAN FEHM─░ ABACI	38.19496900	26.83500400	2
18579	53	D2H161691	HASAN H├£SEY─░N ATILGAN	38.19988500	26.84255500	2
18580	53	D2K241191	HASAN H├£SEY─░N ├ûZMEN	38.34530760	26.86431800	2
18581	53	D2H092563	HAT─░CE ALACALI	38.34270900	26.86580500	2
18582	53	D2H158350	HAT─░CE KURT	38.19385400	26.78846940	2
18583	53	020035563	H├£RPET PETROL LTD. ┼ŞT─░.	38.27500000	26.83780000	2
18584	53	D2H000683	H├£SEY─░N KAN	38.19006400	26.78520600	2
18585	53	D2K224536	H├£SEY─░N K├ûSE	38.21393530	26.80617690	2
18586	53	D2K227352	H├£SEY─░N S├ûNMEZ	38.24517690	26.81212750	2
18587	53	D2H030555	H├£SEY─░N ZEYBEKO─ŞLU	38.19501100	26.83780700	2
18588	53	D2K228315	II.HAT─░CE KURT	38.19074560	26.78472160	2
18589	53	D2H073082	II.MET─░N AYKOL	38.19194700	26.78539900	2
18590	53	D2H040881	II.MUHARREM ├çANGAR	38.19496300	26.83663400	2
18591	53	020035642	IRMAKLAR SU ├£R.TURZ.GIDA.PET.SAN.T─░C.LTD.┼ŞT─░.	38.20895600	26.83055300	2
18592	53	D2K234700	─░PEK O─ŞUZ	38.19429120	26.83967920	2
18593	53	D2H001596	─░SMA─░L DA┼ŞDEM─░R	38.24995440	26.83202370	2
18594	53	D2K218441	KEMAL G├£VEN	38.20970200	26.82645160	2
18595	53	D2H185626	KERAMETT─░N S├ûB├£	38.38315900	26.92890900	2
18596	53	D2K234042	KUB─░LAY TEKEL─░	38.32910330	26.81979730	2
18597	53	D2H034058	LEYLA BA─ŞBA┼ŞI	38.35865600	26.85958200	2
18598	53	D2H000726	L├£TF├£ POLAT	38.35776700	26.88829400	2
18599	53	D2H000759	M.VEDAT ├ûZER	38.34209100	26.87128900	2
18600	53	D2H056413	MARSE TUR─░ZM ─░N┼Ş. PETROL ├£R├£N. GIDA SAN.VE T─░C.LTD.┼ŞT─░.	38.31815200	26.86104300	2
18601	53	D2K210758	MAT TEOS GIDA T─░C.LTD.┼ŞT─░.	38.21641520	26.82203840	2
18602	53	D2H146185	MEHMET AR─░F ├£NER	38.38047090	26.90948280	2
18603	53	D2K240118	MEMA PAZARLAMA GIDA TUR─░ZM T─░CARET LTD.┼ŞT─░.	38.19508540	26.83906810	2
18604	53	D2H161932	MERCAN Y├£CEL	38.33973080	26.86616500	2
18605	53	D2H144459	MERTCAN ├çET─░N	38.31519780	26.85962570	2
18606	53	D2H000737	MERYEM YANAR┼ŞAVK	38.24730300	26.83354500	2
18607	53	D2K224994	METEHAN KURTULU┼Ş	38.37534620	26.89207270	2
18608	53	D2K225730	MET─░N AYKOL	38.19272490	26.78587500	2
18609	53	020035717	MUHARREM ├çANGAR	38.19473400	26.83295100	2
18610	53	D2K237435	MURAT G├£LER	38.20014920	26.84623970	2
18611	53	D2H197848	MURAT TEDAR─░K MARKET├ç─░L─░K ─░N┼ŞAAT OTOMOT─░V SANAY─░ DI┼Ş T─░CARET L─░M─░TED ┼Ş	38.38009810	26.90777140	2
18612	53	D2H000588	MUSTAFA HANYALI PETROL LTD.┼ŞT─░.	38.35788700	26.87110700	2
18613	53	D2H001917	MUSTAFA ├ûZDEM─░R	38.35728900	26.88699400	2
18614	53	D2K204455	M├£BECCEL ├ûZDEM─░R	38.21023730	26.82738600	2
18615	53	D2H000154	NURETT─░N S├ûZKESEN	38.19062000	26.83751700	2
18616	53	D2H109652	OGULHAN GIDA TUR─░ZM ─░N┼Ş. SAN. VE T─░C.LTD.┼ŞT─░.	38.34433710	26.87537290	2
18617	53	D2H000608	ORHAN SOYCAN	38.36022500	26.88527200	2
18618	53	D2H182783	ORU├ç EK─░M	38.37765080	26.88913110	2
18619	53	D2H000603	OSMAN CANBULAT	38.34089100	26.86757700	2
18620	53	D2H066794	├ûZLEM TOP├çU	38.34134900	26.86651700	2
18621	53	D2K237293	PINAR KARAZEYBEK	38.19457200	26.83826300	2
18622	53	D2K210072	RAMAZAN URTEK─░N	38.37826570	26.89232950	2
18623	53	D2H034782	REMZ─░ YAVUZ	38.19264200	26.78579600	2
18624	53	D2H001694	REYHAN NAZLI ATASOY	38.35844600	26.88758700	2
18625	53	D2K241015	REZZAN G├£L┼ŞEN	38.24212100	26.80060450	2
18626	53	D2H177156	R├£STEM ├ûZEN II.	38.19264190	26.84170740	2
18627	53	D2H001839	SARDADA┼Ş PETROL SAN.T─░C.LTD.┼ŞT─░.	38.36681100	26.87339500	2
18628	53	D2H002261	SATILMI┼Ş ALTUNKAYNAK	38.33249100	26.86299300	2
18629	53	D2K241178	SEDEF ├ûZSU	38.19404100	26.83962900	2
18630	53	D2H069677	SEMRA DEM─░R	38.18714800	26.83517500	2
18631	53	D2H149486	SERP─░L KO├ç	38.24439700	26.81588700	2
18632	53	D2K235008	SEVDA AYDIN	38.19774560	26.84133320	2
18633	53	D2K236530	SEZG─░N KILIN├ç	38.19568660	26.84069890	2
18634	53	D2H046160	SHELL PETROL (G├£ZELBAH├çE - 4164)	38.37837800	26.89491900	2
18635	53	D2H169451	SONG├£L SALMAN	38.37676800	26.88204600	2
18636	53	D2K240910	SONG├£L UZ	38.21212550	26.82719190	2
18637	53	D2H077313	SUZAN ├ûZBEK	38.38330600	26.92129600	2
18638	53	D2H000606	SUZAN ├£Z├£M	38.35658950	26.88882200	2
18639	53	D2H000732	┼ŞAFAK EM─░R	38.19309600	26.78424200	2
18640	53	D2K201552	┼ŞEHR─░BAN KURAN	38.27351220	26.82929360	2
18641	53	D2H000277	┼ŞEHZAT ┼ŞENER	38.27510600	26.83033700	2
18642	53	D2K207430	┼ŞER─░F DEM─░R	38.37495850	26.88328660	2
18643	53	D2H024758	TARIK ├û─ŞS├£Z	38.36518950	26.87946220	2
18644	53	D2H140396	TEOS AKARYAKIT NAKL─░YE TUR─░ZM ─░N┼ŞAAT GIDA SANAY─░ VE T─░CARET L─░M─░TED ┼Ş─░	38.20884690	26.83071710	2
18645	53	D2H169119	TRN PETROL OTOMOT─░V VE E─Ş─░T─░M H─░ZMETLER─░ SANAY─░ VE T─░CARET LTD.┼ŞT─░.	38.34235820	26.86338360	2
18646	53	D2H121201	TURAN KARAKAYA	38.19546710	26.84156670	2
18647	53	D2H000605	VEYSEL G├£LCAN	38.35701300	26.88814700	2
18648	53	D2H169450	YEN─░ ERDEM -YELK─░ DRINK CENTER	38.33920880	26.86356360	2
18649	53	D2K229078	YILDIZ ├ç─░FT├ç─░	38.20145820	26.84455800	2
18650	53	D2H104355	Y├£CEL ├çAPKAN	38.18595000	26.83552900	2
18651	9	D2K219681	ABDULKAD─░R AYKA├ç	38.39364630	27.16147230	2
18652	9	D2K121210	AHMET ├çEL─░K	38.38925550	27.15773600	2
18653	9	D2K226176	AHMET ENG─░N B─░L─░C─░	38.39153400	27.14752420	2
18654	9	D2K085001	AHMET ┼ŞAH YAVUZ - YAVUZ MARKET	38.38408060	27.13967930	2
18655	9	D2K229495	ANADOL AKARYAKIT T─░C.A┼Ş.-ANADOL AKARYAKIT TICARET ANONiM ┼ŞiRKETi	38.39052200	27.16517100	2
18656	9	D2K210618	ANILCAN ALP	38.39270390	27.14858210	2
18657	9	D2K216906	ARDA KANER	38.38518700	27.13484000	2
18658	9	D2K164559	ASRAK GIDA E T─░CARET LTD.┼ŞT─░	38.39110050	27.15208530	2
18659	9	D2K201211	ATALAN PAZARLAMA ─░├ç VE DI┼Ş T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.39066380	27.15981810	2
18660	9	D2K146026	AY├çA Y├£CE	38.39434490	27.14070440	2
18661	9	020054010	AYDIN AKTA┼Ş	38.38455400	27.13657200	2
18662	9	D2K211248	AYFER AKTA┼Ş	38.38758180	27.15373030	2
18663	9	D2K233587	AYFER AKTA┼Ş	38.38895440	27.15564650	2
18664	9	020003667	AY┼ŞE AVCI	38.39012800	27.14100900	2
18665	9	D2K222454	AY┼ŞE VURAL	38.39382960	27.15100980	2
18666	9	D2K231158	AZ─░Z KA├çAR	38.38573010	27.14677740	2
18667	9	020008663	BAH├çE GIDA SANAYI VE TICARET LIMITED SIRKETI - BAH├çE GIDA SANAY─░ VE T─░	38.38444100	27.14639290	2
18668	9	D2K231376	BA┼ŞDA┼Ş MARKET - ┼Ş─░R─░NYER 2	38.39097000	27.15101100	2
18669	9	D2K157546	BAYRAM ERDO─ŞAN	38.38897960	27.15891490	2
18670	9	020002663	B├£LENT UZUN- D─░LARA GIDA	38.38436600	27.14045800	2
18671	9	020005781	CENG─░Z ERDO─ŞAN	38.39317900	27.14490800	2
18672	9	D2K222026	CEVAH─░R K├ûKSAL	38.38980460	27.13631580	2
18673	9	D2K188635	├çET─░N C├ûMERT	38.39432530	27.14470550	2
18674	9	D2K133763	├çET─░N ├çAKMAK├çI	38.39164340	27.14702490	2
18675	9	020006254	├ç├£NG├£┼ŞL├£ PETROL ├£R├£NLER─░ SAN. T─░C. LTD. ┼ŞT─░.	38.39240600	27.15122200	2
18676	9	D2K124172	D─░LEK SEV─░N├ç Y├£KSEL	38.39447370	27.15115980	2
18677	9	020018932	DO─ŞAN AKTA┼Ş	38.38361900	27.13770800	2
18678	9	020008906	ELVAN KUYUMCULUK TUR. GIDA VE BOY.SAN. VE TIC.LTD.STI.	38.39028600	27.16371500	2
18679	9	D2K156097	ERHAN ┼Ş─░M┼ŞEK	38.38470870	27.14586010	2
18680	9	D2K172244	ERKAN KESK├£N	38.39186120	27.15142760	2
18681	9	D2K233529	FATMA G─░ZEM B─░NG├ûL	38.39158370	27.15995990	2
18682	9	020008892	FETTAH ├ûZDER	38.39259100	27.14577700	2
18683	9	D2K199419	G─░ZEM BAYRAM	38.39555110	27.14443930	2
18684	9	D2K227862	G├ûKHAN B├£Y├£KTA┼Ş	38.39496250	27.14374570	2
18685	9	D2K162923	G├ûKHAN KILI├ç	38.38773300	27.14625500	2
18686	9	D2K183277	G├ûRKEM ├çAM	38.39487370	27.15092570	2
18687	9	020014095	G├£LSEN KO├çAN - AD─░L MARKET	38.39142300	27.16616300	2
18688	9	D2K208096	HAKTAN PERAKENDE VE TOPTAN GIDA LTD.┼ŞT─░.	38.38785930	27.15537130	2
18689	9	D2K212415	HAMZA S─░YAHKO├ç	38.38778300	27.15453660	2
18690	9	020045448	HASAN AKTA┼Ş	38.38700000	27.16150000	2
18691	9	D2K230106	HASAN TO─ŞRUL	38.39028560	27.16334010	2
18692	9	D2K211113	HAYR─░YE ELMA	38.38870590	27.16028440	2
18693	9	D2K221937	HEBUN A┼ŞURO─ŞLU	38.39084870	27.15565870	2
18694	9	020017784	H├£MEYRA AKT├£RK	38.39201000	27.15706100	2
18695	9	D2K179439	H├£SEY─░N ERGUN	38.38270400	27.13664600	2
18696	9	020009246	─░BRAH─░M ├çEL─░K	38.38918200	27.13631600	2
18697	9	D2K177706	─░BRAH─░M TORLAK	38.38452000	27.13931100	2
18698	9	D2K239595	─░LKER ENG├£R	38.39119800	27.15989190	2
18699	9	020054734	─░SMET PALA├ç	38.39233900	27.15239200	2
18700	9	020007831	KAM─░L VURAL - KEMAL ├çEREZ	38.39140300	27.15620100	2
18701	9	020054592	KARIS ┼ŞANS OY. GIDA MD.─░N┼Ş.OTO.TRZ.SAN.T─░C.LTD.┼ŞT─░.	38.39298200	27.16027000	2
18702	9	D2K087874	KATA METRO B├£FE - KATA ─░N┼Ş. MADEN.T─░C. LTD.┼ŞT─░.	38.39289900	27.14715900	2
18703	9	020017749	KENAN YAMAN - KURUYEM─░┼Ş VE TEKEL	38.39249200	27.15509700	2
18704	9	D2K149512	KEREM KANMAZ	38.38388500	27.14437300	2
18705	9	020004515	KISMET GIDA MAD. T├£K.MAL.─░N┼Ş.MAD.T─░C.LTD.┼ŞT─░.	38.38663200	27.14350100	2
18706	9	D2K227699	LEVENT KAYA	38.39343690	27.15263190	2
18707	9	D2K236625	MEHMET ├çA─ŞLAR	38.38645330	27.15837870	2
18708	9	020006943	MEHMET ├ç─░F├ç─░LER	38.38970300	27.15116000	2
18709	9	D2K211336	MEHMET G├ûKTEK─░N	38.39181100	27.15338800	2
18710	9	020000437	MET─░N Y├ûR├£K	38.38890000	27.15950000	2
18711	9	D2K184146	MUHARREM DENL─░	38.39236170	27.16023500	2
18712	9	020052116	MURAT YILMAZ	38.39137500	27.14850800	2
18713	9	D2K143206	MUSTAFA G├£LBAHAR	38.38759900	27.14240900	2
18714	9	D2K164044	MUSTAFA KABASAKAL	38.39093870	27.15400980	2
18715	9	D2K214325	NAC─░YE ┼Ş─░┼ŞMAN	38.39305200	27.15541100	2
18716	9	020005845	NAZ─░RE AYIKBABA - D─░LEK MARKET	38.39048700	27.15673400	2
18717	9	D2K216259	N─░HAT ERTA┼Ş	38.38848320	27.16056640	2
18718	9	D2K215479	NURULLAH ABDAN	38.38793700	27.16208300	2
18719	9	D2K240584	ORHAN KARAG├ûZ	38.38716470	27.13452090	2
18720	9	D2K179497	OSMAN YAVUZ	38.39104400	27.13599800	2
18721	9	D2K200576	├ûMER FARUK KANYILMAZ	38.39180060	27.16006420	2
18722	9	D2K230450	├ûMER G├£NERKAN	38.39225230	27.14848730	2
18723	9	D2K157545	├ûMER KARAYILAN 2	38.38995030	27.16641920	2
18724	9	020053187	├ûZGEBERKE ─░N┼Ş.GIDA SAN.VE T─░C.LTD.┼ŞT─░.	38.38776400	27.14461300	2
18725	9	D2K182789	RAM─░S G├£LER	38.39357290	27.15564260	2
18726	9	020012123	RECEB─░YE TURAN - U─ŞUR ├çEREZ	38.39066330	27.16114440	2
18727	9	020010713	SAADET AYAZMAN - ├ûZG├£├ç GIDA	38.39008900	27.16550600	2
18728	9	D2K082711	SAD─░YE BANU ├çET─░N - ├çET─░N MARKET	38.39652500	27.14236300	2
18729	9	D2K214734	SALUTEM TUR─░ZM.GIDA SAN.VE T─░C.LTD.┼ŞT─░.	38.39090100	27.15961800	2
18730	9	D2K204099	SELAHATT─░N AYDEM─░R	38.39131490	27.15113410	2
18731	9	020004173	SELAM─░ YOLCU	38.38740000	27.15280000	2
18732	9	020055109	SERAP PEHL─░VANLAR ├çOCEN	38.39075500	27.14840700	2
18733	9	D2K154408	SEV─░L YILDIZ	38.39227230	27.16012510	2
18734	9	D2K229492	SULTAN DEM─░R	38.39164230	27.14703240	2
18735	9	D2K213380	S├£CAHATT─░N ├ûZSUCAH	38.39420580	27.14345040	2
18736	9	D2K086508	S├£LEYMAN AYDUGAN	38.38833700	27.15134500	2
18737	9	D2K121843	S├£LEYMAN G├£C─░N	38.38990190	27.15538450	2
18738	9	D2K232455	TEK─░N BULUT	38.38937470	27.15600200	2
18739	9	D2K199369	TEVF─░K ├çET─░N	38.39053790	27.16221860	2
18740	9	D2K130592	UGUR G├ûKSU GIDA TURIZM SANAYI VE TICARET LIMITED SIRKETI	38.39186150	27.15224230	2
18741	9	D2K210085	YAREN HORASAN	38.38698400	27.13584300	2
18742	9	020000631	YAVUZ POLAT	38.38423490	27.14697600	2
18743	9	D2K234095	YEL─░Z A┼ŞKIN	38.39063440	27.16552390	2
18744	9	D2K134762	YENiNESiL TEMIZLIK MADDELERI PAZARLAMA INSAAT GIDA ITHALAT IHRACAT SAN	38.38767940	27.14225700	2
18745	9	D2K086333	YE┼Ş─░M ┼Ş─░M┼ŞEK - BEL─░NAY MARKET	38.38483500	27.14088700	2
18746	9	D2K221507	YUSUF ─░BRAH─░M KAYADELEN	38.38767200	27.15435500	2
18747	9	020054328	ZAH─░DE AKTEKE	38.38692400	27.13835500	2
18748	9	020008238	ZEK─░ K├ûZ - SERCAN MARKET	38.39021300	27.16655400	2
18749	9	D2K160655	Z─░YAETT─░N AYAZTEK─░N	38.39000680	27.15433470	2
18750	4	020002345	ACEM GIDA ─░N┼Ş.TUR.SAN.T─░C.LTD.┼ŞT─░. - Buca	38.37707700	27.18886800	2
18751	4	D2K175249	AHBEK GIDA ─░N┼ŞAAT VE TUR─░ZM LTD.┼ŞT─░.	38.36650880	27.19095190	2
18752	4	020001529	AHMET DURSUN	38.36916700	27.18397500	2
18753	4	020046569	AL─░ ASKER AK├çAY	38.36702900	27.17993700	2
18754	4	D2K195348	AL─░ EREN TURAN	38.36838300	27.19310590	2
18755	4	D2K149904	AL─░ ├ûZDEM─░R	38.38069320	27.18171800	2
18756	4	020049143	AL─░┼ŞAN ├ç─░├çEK	38.37420700	27.17660100	2
18757	4	D2K221505	ASELA KURUYEM─░┼Ş SAN. VE T─░C.LTD.┼ŞT─░.	38.38141380	27.17621260	2
18758	4	D2K237654	ATS ALI┼ŞVER─░┼Ş MERKEZ─░ SANAY─░ VE T─░CARET L─░M─░TET ┼Ş─░RKET─░	38.36800450	27.18738590	2
18759	4	D2K117005	AYHAN ├çEL─░K	38.37944250	27.17400780	2
18760	4	020054792	AYTA├ç ALP	38.37435900	27.18418800	2
18761	4	D2K140520	BAYRAM ATAY- SE├ç MARKET	38.37705680	27.18443980	2
18762	4	D2K127322	BEK─░R ALTUNSULU-B─░ NOKTA MARKET	38.37662960	27.18609210	2
18763	4	020048289	BEYHAN KILI├ç-├çA─ŞDA┼Ş MARKET	38.37135100	27.17857800	2
18764	4	D2K140606	BiZDE GIDA NAKLIYAT VE INSAAT ITHALAT SANAYI VE TICARET LIMITED SIRKET	38.37227700	27.19105100	2
18765	4	020000164	B├£LENT UZUNGET	38.37050400	27.18106000	2
18766	4	020001385	CEYLAN AYG├£ZER	38.36868600	27.18731400	2
18767	4	D2K171549	CO┼ŞKUN U─ŞUR	38.37944110	27.17635590	2
18768	4	D2K223285	├çA─ŞDA┼Ş KARABA┼Ş	38.36849590	27.18532900	2
18769	4	020006999	D─░LEK KAYA-Z├£CCAC─░YE MARKET GIDA SAN. T─░C. LTD.┼ŞTI.	38.36770500	27.19647800	2
18770	4	020052130	ENG─░N SEY─░TAL─░DEDEO─ŞLU	38.37738400	27.18826500	2
18771	4	020014240	EN─░S DA─ŞISTANLI	38.38171600	27.17033200	2
18772	4	D2K194152	ERDAL ATE┼Ş	38.36753720	27.18272420	2
18773	4	D2K148918	EYL├£L ALKOLL├£ ─░├çK─░LER GIDA MADDELER─░ SAN. VE T─░C. LTD. ┼ŞT─░.	38.37255300	27.18860900	2
18774	4	D2K229603	FAD─░ME ALTAY	38.37827610	27.18070090	2
18775	4	D2K237864	FAT─░H TA├çYILDIZ	38.37336640	27.18637110	2
18776	4	020050324	FAT─░H USLU	38.38180500	27.17731700	2
18777	4	D2K225870	FATMA TA┼ŞAN	38.37170570	27.19162750	2
18778	4	020008516	FELEYTUN G├£VEND─░R	38.38065100	27.17561100	2
18779	4	D2K192467	FIRAT ─░HT─░YA├ç MADDELER─░ GIDA VE ─░N┼ŞAAT LTD.┼ŞT─░.-┬áBUCA┬á┼ŞB.	38.37687470	27.18063670	2
18780	4	D2K216216	GAMZE GAN─░ME KIRCEYLAN	38.37427620	27.18438370	2
18781	4	D2K099697	G├£LAY DEM─░REL	38.36789580	27.19259590	2
18782	4	020014245	G├£LCAN KO┼ŞAL	38.37775800	27.17593300	2
18783	4	D2K143856	G├£L┼ŞAH YILMAZ	38.36813680	27.19362060	2
18784	4	D2K233256	G├£NER KILI├ç AKAL─░N	38.37663650	27.18301920	2
18785	4	D2K213077	HAKAN Y├£CE	38.37202520	27.18583470	2
18786	4	D2K196388	HASRET ZELAL ├çELENK	38.37004680	27.19364330	2
18787	4	D2K235080	HAZAL G├£NE┼Ş	38.37740980	27.18412600	2
18788	4	D2K093290	H├£LYA DEM─░REL - EGEMAR BUCA	38.36913000	27.17883800	2
18789	4	D2K095479	H├£SEY─░N BATU┼Ş	38.36612600	27.19632100	2
18790	4	020050658	H├£SEY─░N KARAPINAR	38.38124900	27.17578600	2
18791	4	D2K158722	─░LKNUR ├ûZTEM─░Z	38.37940470	27.18555480	2
18792	4	D2K162916	─░SKENDER TAL─░	38.37863100	27.17291650	2
18793	4	020053312	─░ZM─░R PARK GIDA SAN T─░C LTD.┼ŞT─░ - BUCA ┼ŞB - ─░ZM─░R PARK A.V.M	38.37969300	27.18362600	2
18794	4	D2K230365	KADR─░YE NAZAN G├ûKKAYA	38.37041320	27.18153410	2
18795	4	D2K218101	LEYLA YILDIRIM	38.38211600	27.17643900	2
18796	4	020014193	MARSAN GIDA SAN.T─░C.LTD.┼ŞT─░.	38.38125550	27.17982610	2
18797	4	D2K149991	MARSAN GIDA VE MARKET├çILIK ├ûGRENCI YURDU ISLETMECILIGI HAY.INS.SAN.VE	38.36993100	27.18964770	2
18798	4	020047469	MEHMET NUR─░ YILDIRIM	38.37670200	27.18981900	2
18799	4	D2K235858	MERT AL─░ YORULMAZ	38.37384360	27.17836090	2
18800	4	D2K238231	MERTCAN ALBUZ	38.36918510	27.19575890	2
18801	4	D2K225944	MUHAMMED AL─░ G├£CL├£	38.37980390	27.17633650	2
18802	4	D2K180766	MUHAMMED GEN├ç	38.37685200	27.17802100	2
18803	4	D2K094175	MUHAMMET ├çEL─░K	38.37395200	27.18880800	2
18804	4	020019075	MUHAMMET DO─ŞAN	38.37545400	27.18957400	2
18805	4	D2K164210	MURAT KARAKELLEC─░	38.36970690	27.19340750	2
18806	4	D2K081035	MUSTAFA KO├ç - MANDOL─░N TEKEL	38.37532600	27.18985900	2
18807	4	D2K219008	MUSTAFA YE┼Ş─░L├ûZ II	38.36721000	27.18988720	2
18808	4	D2K180564	M├£GE ┼ŞAHAN	38.37420860	27.18137680	2
18809	4	020005476	N─░HAT BETU┼Ş- OZAN BAKKAL─░YES─░	38.37443500	27.18403400	2
18810	4	D2K129959	NiL MARKET├çILIK GIDA VE HAYVANCILIK TIC. LTD. STI.	38.37600120	27.18749390	2
18811	4	D2K206715	NURCAN KALAYCI	38.37258300	27.18343900	2
18812	4	D2K231431	ONUR ├ûRS	38.36979440	27.18850290	2
18813	4	D2K237725	OSMAN AKMAN	38.38152450	27.17033960	2
18814	4	D2K200274	├ûMER DA┼ŞKARA	38.37319850	27.18456250	2
18815	4	D2K185528	├ûM├£R KIRMIZI	38.37213300	27.19184690	2
18816	4	D2K182222	RECEP KILI├ç-t─▒nastepe	38.37507490	27.18194780	2
18817	4	020052972	SAB─░HA ULUTA┼Ş	38.37065220	27.18816900	2
18818	4	020007091	SAL─░H SELV─░	38.38172500	27.17439400	2
18819	4	D2K157836	SALMAN ALP	38.36840700	27.19312600	2
18820	4	D2K203638	SEDAT ├ûZDEN	38.37564360	27.17702870	2
18821	4	D2K229010	SEL─░N ┼ŞEN	38.37105070	27.19301500	2
18822	4	D2K188263	SEV─░LAY KIRMIZI	38.37273230	27.18306270	2
18823	4	D2K225868	S─░BEL ├çET─░N	38.36891170	27.18861420	2
18824	4	D2K079259	┼ŞAHS─░ AYDO─ŞMU┼Ş - AYDO─ŞMU┼Ş MARKET	38.37166500	27.18764300	2
18825	4	D2K174656	┼ŞEHMUS ─░D─░Z	38.36809640	27.17752800	2
18826	4	020000572	┼ŞENOL ┼Ş─░M┼ŞEK	38.37880000	27.17710000	2
18827	4	D2K196279	TAYLAN MARKET VE GIDA LTD.┼ŞT─░.	38.37011330	27.17923790	2
18828	4	D2K110737	TINAZTEPE MARKET	38.37519000	27.19163200	2
18829	4	D2K226648	UBEYDULLAH YILDIRAK	38.37601100	27.18044600	2
18830	4	D2K217617	U─ŞUR KORKMAZ	38.36811700	27.19446600	2
18831	4	D2K235079	UMUTCAN HO┼ŞG├ûR 2	38.38036850	27.17635290	2
18832	4	D2K155765	UZMAN TARTI SISTEMLERI GIDA INSAAT OTOMOTIV TARIM HAYVANCILIK SAN.TIC.	38.36571970	27.19546550	2
18833	4	D2K123848	├£NAL ├ûZ├£NL├£	38.38159930	27.17531740	2
18834	4	D2K240879	VAH─░T CAN ERYILDIRIM	42.94838100	34.13287400	2
18835	4	D2K114997	WOW GIDA I├çECEK PAZARLAMA LIMITED SIRKETI	38.37080700	27.19294000	2
18836	4	020001532	YA┼ŞAR D├£ZEN	38.36886700	27.19610100	2
18837	4	D2K140243	YAVUZ ALTUN	38.37921110	27.17351140	2
18838	4	D2K173381	YAVUZ G├£NAY	38.37171600	27.19296400	2
18839	4	D2K114139	YETER ├ûZ┼Ş─░M┼ŞEK	38.36788660	27.19018940	2
18840	4	020055458	YILMAZ KARASUNGUR	38.36661510	27.19476320	2
18841	4	D2K232956	YUSUF KORKMAZ	38.37529910	27.18565750	2
18842	4	D2K127103	Y├£KSEL─░┼Ş GROUP I├çECEK VE GIDA MADDELERI INSAAT OTOMOTIV ANONIM SIRKETI	38.37227300	27.19416200	2
18843	4	D2K193640	Z├£HAL KESK─░N	38.38076200	27.17308300	2
18844	24	D2K205542	ABDULLAH ├ûZDEM─░R	38.37228000	26.85754120	2
18845	24	D2K226313	ADA MAR─░N GIDA SAN. VE T─░C. LTD. ┼ŞT─░.	38.27913550	26.74140120	2
18846	24	D2K231637	AHMET KAYAALP	38.35847750	26.81417190	2
18847	24	D2K232853	AL─░ YE┼Ş─░L	38.32818480	26.76330210	2
18848	24	D2H119576	ARCTEK MIM. INS. TUR. PETROL ├£RN. SAN. VE TIC. LTD. STI. URLA PETROL I	38.37029900	26.84558500	2
18849	24	D2K241245	AR─░A MARKET GIDA TEM.VE T─░C.LTD.┼ŞT─░.	38.37338840	26.86395790	2
18850	24	D2H093261	ARZU ├ûZ├çAM	38.32294300	26.75901200	2
18851	24	020026426	AYHAN HAYTAO─ŞLU/S─░TE MARKET	38.32509700	26.75442200	2
18852	24	D2H113938	AY┼ŞEG├£L ├ûZSOY	38.36791600	26.83683800	2
18853	24	D2K233306	AYTA├ç CANBAZ	38.36249980	26.84248520	2
18854	24	D2K237513	AYTEM─░Z PETROLC├£L├£K (URLA-AY740)	38.33471900	26.76708000	2
18855	24	D2K229079	BABACANLI PETROL ├£R├£NLER─░ TUR─░ZM SAN.VE T─░C.LTD.┼ŞT─░.	38.32420550	26.75151880	2
18856	24	D2H185652	BARI┼Ş MARKET - URLA 2	38.39456400	26.74423360	2
18857	24	D2H002087	BARI┼Ş MARKET -URLA ─░SKELE	38.36230000	26.77190000	2
18858	24	D2H066021	BENAN AL├ç─░N	38.32367300	26.76460800	2
18859	24	D2H172486	BERKE TANRISEVER	38.32482600	26.76692000	2
18860	24	D2K242036	BET├£L ODABA┼ŞI	38.32217200	26.75391400	2
18861	24	D2H187358	BORA KO├çTA┼Ş	38.31902990	26.75762540	2
18862	24	D2H109662	BRL TUR─░ZM GIDA ─░N┼Ş.SAN. VE T─░C.LTD.┼ŞT─░.	38.36501080	26.76978430	2
18863	24	D2K223971	CAN BERK YE┼Ş─░L	38.32422890	26.75164570	2
18864	24	D2H171699	CAN S├ûNMEZ	38.32355100	26.76843100	2
18865	24	D2H187913	CANT├£RK ─░N┼ŞAAT SANAY─░ T─░CARET L─░M─░TED ┼Ş─░RKET─░ YEN─░KENT ┼ŞUBES─░	38.33622400	26.77105300	2
18866	24	D26000349	CEMAL CANER BALIK├çI	38.39471700	26.74531000	2
18867	24	D26000101	├çET─░N BALKAN	38.25806400	26.68069600	2
18868	24	D2K229208	D─░LEK AKPINAR GIDA TUR─░ZM ─░N┼Ş.SAN. VE T─░C.LTD.┼ŞT─░.	38.36283210	26.77202790	2
18869	24	D2H044326	EM─░N IRAK	38.35467900	26.80433600	2
18870	24	D2K219683	EMRE I┼ŞIL	38.39859590	26.74130410	2
18871	24	D26000015	ENDER KIPKIP	38.32237200	26.76769500	2
18872	24	D2H002039	ERCAN KIRMIZILAR	38.32156300	26.76334300	2
18873	24	020026414	ERTU─ŞRUL KARANF─░L	38.32110000	26.76010000	2
18874	24	D2H162079	FARUK KAYA	38.32499670	26.74954780	2
18875	24	D2H001896	FAT─░H S├£T ├£R├£N.GIDA FOTO.SAN.VE.T─░C.LTD.┼ŞT─░.	38.30798300	26.73062900	2
18876	24	D2K225943	FEDA─░ TURAN	38.32315180	26.76184080	2
18877	24	D2H147282	G├£LTEN KIRAN SA─░ME KIRAN ORTAKLI─ŞI	38.31873200	26.76213900	2
18878	24	D2H053001	HAL─░L TUFAN KAMAZ	38.38604500	26.75464500	2
18879	24	D2K222102	HAL─░M G├£LTEN	38.32259380	26.76731350	2
18880	24	D2H096365	HASSOY ENERJ─░ PETROL GIDA ─░N┼ŞAAT TURZ─░ZM NAKL─░YAT ─░TH.─░HR.T─░C. VE SAN.	38.34556700	26.78819400	2
18881	24	020026444	HAT─░CE AKDEM─░R	38.39513000	26.74689600	2
18882	24	D2H179665	HAYRETT─░N ERDEM SEZER	38.32491740	26.76859430	2
18883	24	D2K203640	HIDIR ─░LAY	38.37216500	26.76162100	2
18884	24	020026461	H├£SEYIN ├£NAL	38.36751600	26.83898100	2
18885	24	D26000933	H├£SEY─░N ALTEN	38.32162900	26.76371400	2
18886	24	D2H002002	H├£SEY─░N ERDEM ATAY	38.32779200	26.76656400	2
18887	24	D2H167361	H├£SEY─░N ILDIZ	38.36873830	26.84409810	2
18888	24	D2H023846	H├£SEY─░N TAYLAN	38.32033100	26.75554500	2
18889	24	D2H017567	H├£SEY─░N TEK─░N	38.36488300	26.76828500	2
18890	24	D2K221882	II.HAL─░L ├çALIN	38.22334200	26.71938250	2
18891	24	D2H001519	II.MERCANLAR PETROL ├£R├£NLER─░ T─░C.LTD.┼ŞT─░.	38.34005600	26.77921100	2
18892	24	D26000387	─░BRAH─░M KAYA	38.40090800	26.74614900	2
18893	24	D2H168554	─░MDAT DEM─░R	38.32601800	26.76401300	2
18894	24	D2H171581	─░SMET EGEMEN AYDIN	38.40532310	26.73766200	2
18895	24	D2K220253	KADR─░YE DOKUMACI-UMUT U─ŞURLU AD─░ ORTAKLI─ŞI	38.36231880	26.77211880	2
18896	24	020026418	KAYGUSUZERLER GIDA SAN.VE TIC.LTD.STI.	38.32240000	26.76660000	2
18897	24	D2K233223	MAC─░DE CANT├£RK	38.33716570	26.77165960	2
18898	24	D2H036166	MAHBUP KARAKO├ç	38.37017200	26.83987400	2
18899	24	D2H147139	MAZHAR ├ûZYURT	38.38999760	26.74412670	2
18900	24	D2H185078	MEHMET ADA	38.32644950	26.76703670	2
18901	24	D2K231992	MEHMET ├ûNAL	38.32230240	26.75167580	2
18902	24	D2K233639	MEHMET TOPAL	38.36155840	26.77806260	2
18903	24	D2H144838	MEL─░S ├çOKS├ûYLER	38.36270590	26.77199010	2
18904	24	D2H192666	MET─░N TAYLAN	38.32349880	26.76803460	2
18905	24	D2H188449	MEVL├£DE OK	38.32055200	26.76944500	2
18906	24	D2H185116	MUHAMMET EREN ER├ûZ	38.31821900	26.75832550	2
18907	24	D2K238440	MUSTAFA D─░REK	38.32312050	26.75986220	2
18908	24	D2H141003	MUSTAFA G─░RG─░N	38.36886200	26.84808290	2
18909	24	020026455	MUSTAFA ├ûNEN	38.32971600	26.77444500	2
18910	24	D2H191255	NEJLA ELKIRAN	38.37196400	26.84970100	2
18911	24	D2K217820	NUMAY GIDA SAN.VE T─░C.LTD.┼ŞT─░.	38.35984100	26.78196940	2
18912	24	D26000005	NURAL ─░SK─░T	38.32123400	26.76024700	2
18913	24	D2K221714	NURDAN YA┼ŞAR	38.32098690	26.77019950	2
18914	24	D2H112911	NURULLAH ERTEK PETROL VE PETROL ├£R├£NLER─░ TURZ. SAN. VE T─░C.LTD.┼ŞT─░.	38.33446000	26.76798500	2
18915	24	D2H080686	O─ŞUZ G├£NG├ûR	38.35517200	26.79434600	2
18916	24	D2K234236	OKAN YURDAKUL	38.32157200	26.76295970	2
18917	24	D26000388	OKTAY ASLAN	38.29937300	26.75012000	2
18918	24	020026554	OR├çUN ERG├ûN├£L/SEV─░N├ç MARKET	38.35625100	26.79038100	2
18919	24	020026545	├ûZCAN ├ûZSAN	38.36988800	26.83899500	2
18920	24	D2K242898	├ûZG├£R CAN KAPLAN	42.94838100	34.13287400	2
18921	24	D2K210755	├ûZKAN G├£DEK	38.28866500	26.75287400	2
18922	24	D26000242	├ûZKAN G├£RCAN	38.32045300	26.76917700	2
18923	24	D2H098029	├ûZLEM ├çEV─░K	38.32192200	26.76753500	2
18924	24	D2K226020	├ûZNUR KARAZEYBEKO─ŞLU	38.32589200	26.76742000	2
18925	24	D2H161037	PR─░ME MOB─░LE ELEKTRON─░K LTD.┼ŞT─░.	38.37120600	26.85152300	2
18926	24	D2K222755	RECEP KIRDAL	38.32611450	26.76231030	2
18927	24	D2K199109	RIDVAN SAK─░N	38.32535370	26.74950630	2
18928	24	D2H177282	R├£┼ŞAN A─ŞCAYAZI	38.39307250	26.74859280	2
18929	24	D26000341	SABR─░YE KAHRAMAN	38.32279470	26.77137670	2
18930	24	D2H054146	SAKIP TAYFUN T├£RKER	38.32085900	26.75240100	2
18931	24	D2H143342	SAL─░HA DAMYAN	38.36623710	26.83869080	2
18932	24	D2H180498	SE├çK─░N BASUT	38.32272960	26.75168320	2
18933	24	D2K214239	SEL├çUK ADIG├£ZEL	38.32721150	26.76646280	2
18934	24	D26000921	SELDA YURDAKUL	38.32510300	26.76065100	2
18935	24	D2H112266	SEMA ALTINOVA	38.32092200	26.75826300	2
18936	24	D2H156950	SERCAN ├£ST├£N	38.32560100	26.74899400	2
18937	24	D2H119491	SEV─░L YURDAKUL	38.32444810	26.76587760	2
18938	24	D2K240791	SHELL PETROL (├çE┼ŞME OHT G├£NEY - 5572)	38.34986560	26.85239690	2
18939	24	D2K240790	SHELL PETROL (├çE┼ŞME OHT KUZEY - 5571)	38.35530900	26.85618000	2
18940	24	D2K227819	S─░BEL BOZKURT	38.37320300	26.86308500	2
18941	24	D2K231511	SUHEYLA D─░R─░	38.36715200	26.83732000	2
18942	24	D2K234665	sumpet akaryak─▒t istasyonlar─▒ sanayi tic. a.┼ş.	38.34298600	26.78541700	2
18943	24	D2K234515	TELAT EKER	38.39520380	26.74721420	2
18944	24	D2H109649	U─ŞUR ┼ŞAH─░N	38.36143500	26.77788000	2
18945	24	D2H148847	UTKU B─░RTAN KARA	38.39479080	26.74663260	2
18946	24	D2H033232	├£MMET D─░REK	38.22582280	26.68688020	2
18947	24	D2H186247	YAKUP ├çET─░N	38.32423800	26.75430400	2
18948	24	D26000336	YEL─░Z B─░NAY - DO─ŞAL GIDA ┼ŞARK├£TER─░	38.32240700	26.76773700	2
18949	24	D2H188497	YEN─░ ERDEM -URLA DRINK CENTER	38.33416500	26.76849900	2
18950	24	D2H093262	YUSUF TUNCER	38.31895500	26.76216900	2
18951	24	D2H074337	ZEK─░ F─░DAN	38.32068040	26.75313010	2
18952	24	D2K242417	ZEK─░YE DEREBA─Ş├çE	42.94838100	34.13287400	2
18953	15	D2K228069	AKDEN─░Z GIDA-EGH MARKET ─░┼ŞLETMEC─░L─░─Ş─░ GIDA OTOMOT─░V TEKST─░L ├£R├£NLER─░ ─░	38.39805980	27.11623380	2
18954	15	D2K212878	AKIN CAN FIRAT	38.39560000	27.11290000	2
18955	15	D2H158182	AK─░F G├£NG├ûR	38.39526500	27.11349500	2
18956	15	020006516	AL─░ KARACA	38.39734300	27.11082200	2
18957	15	D2H190652	AL─░ KARACAOLUK	38.39858780	27.12359620	2
18958	15	D2K209924	AL─░ KAYA	38.39882830	27.10782950	2
18959	15	D2K086920	AL─░ VURHAN - ├£Z├£MC├£ MARKET	38.39265460	27.11671200	2
18960	15	D2K240729	ALTERNAT─░F AMBALAJLAMA GIDA ├£RET─░M PAZ. SAN. T─░C. LTD. ┼ŞT─░.	38.39725280	27.11081480	2
18961	15	D2H174049	ALTIKANAT GIDA MARKET├ç─░L─░K TUR─░ZM SANAY─░ VE T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.39870400	27.10018900	2
18962	15	D2K233172	ARDA ├ûZKAN	38.39680000	27.10640000	2
18963	15	D2K222240	ARES TIBB─░ C─░HAZLAR BASIN YAYIN ─░N┼ŞAAT TEKST─░L KUYUMCULUK GIDA TEM─░ZL─░	38.39642730	27.11675820	2
18964	15	D2H096127	AT─░YE D─░LEK ─░NAN	38.40146460	27.12618510	2
18965	15	D2H134583	AYDAN KARAKAYA	38.39688500	27.11612200	2
18966	15	020013165	AYSEL TERZ─░ -G├£VEN MARKET	38.40208600	27.12599600	2
18967	15	020054954	AY┼ŞE DEM─░REL	38.39610000	27.11720000	2
18968	15	D2K225419	AY┼ŞE ERC─░HAN	38.39849880	27.12312710	2
18969	15	D2K237817	BARAN G├£M├£┼Ş	38.39750000	27.11610000	2
18970	15	D2H177743	BARI┼Ş ├ûZT├£RK	38.39584300	27.11381400	2
18971	15	D2K236085	B─░LGEN SA─ŞIR	38.39729320	27.11951440	2
18972	15	D2H131588	B─░NMAR MARKET├ç─░L─░K GIDA TURIZM HAYVANCILIK ─░N┼ŞAAT SANAY─░ VE T─░CARET LT	38.39500000	27.11970000	2
18973	15	D2K211111	BUKET SEZER B─░T─░M	38.39535530	27.11621330	2
18974	15	D2K240810	BUKET ┼ŞENGELD─░	38.40086500	27.11889410	2
18975	15	D2H187496	BULUT ALTINSAK	38.39450180	27.11303370	2
18976	15	020046246	CANJAN GIDA TARIM HAYVANCILIK OTOMOTIV SANAYI VE TIC.LTD.STI	38.39343700	27.11860300	2
18977	15	D2H070046	CEM─░L DUYAN	38.39524200	27.11621000	2
18978	15	D2H077048	C─░HAN TARHAN	38.39901500	27.10096000	2
18979	15	D2H081174	├ç─░─ŞDEM SARIKAYA	38.39644900	27.11029200	2
18980	15	D2H098427	├ç─░─ŞDEM SERDAR	38.40229840	27.12330470	2
18981	15	020009396	DEN─░Z MARKET├ç─░L─░K TA┼ŞIMACILIK LTD.┼ŞT─░	38.40357800	27.12476400	2
18982	15	D2K138615	DEPOM MARKET├çILIK TOPTAN VE PERAKENDE TICARET LIMITED SIRKETI	38.39256490	27.11282060	2
18983	15	D2H108717	DO─ŞAN Y─░─Ş─░T	38.39629500	27.11039400	2
18984	15	D2K209136	EFE UZUNER	38.40080000	27.12040000	2
18985	15	D2H114949	EKEL GIDA ─░N┼ŞAAT T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.39523470	27.11392010	2
18986	15	D2H152414	EL─░F ├ûZT├£RK	38.40353380	27.12343940	2
18987	15	D2K241553	EMRE D├ûNEN	38.39528920	27.11405940	2
18988	15	D2K199461	ENVER SUVAYDA┼Ş	38.40099180	27.12738340	2
18989	15	D2K229612	ERCAN ABAYLI	38.39754070	27.10905270	2
18990	15	D2H141137	ERCAN DEDER	38.40500700	27.12553200	2
18991	15	020001153	ERCAN SEZG─░N	38.39830000	27.10580000	2
18992	15	D2K226203	ERD─░N├ç KURT	38.39366660	27.11018960	2
18993	15	020055308	ERS─░N ├çEV─░RME	38.39804800	27.10544700	2
18994	15	D2H071264	EYY├£P ├çEL─░K	38.40398380	27.12365660	2
18995	15	D2K240625	FAHR─░ K├ûKL├£	38.40030000	27.12370000	2
18996	15	020002603	FEYZ─░ C─░HAN	38.39756600	27.12065300	2
18997	15	D2K240751	FURKAN TA┼ŞCI	38.39344530	27.11385850	2
18998	15	020052892	G├£LTEN ERDEM	38.39677600	27.10645500	2
18999	15	020055526	G├£NHAN SOYUCAK	38.39459000	27.11037800	2
19000	15	D2H171485	G├£RKAN K├ûSE	38.40244600	27.12349300	2
19001	15	D2H068811	G├£RKAY G├ûK	38.39843300	27.12715300	2
19002	15	D2K230376	HAB─░BE KO├çKESEN	38.39593220	27.11529370	2
19003	15	D2H130377	HACER SANLISOY	38.39774610	27.10781020	2
19004	15	D2H112178	HAL─░L TUN├çER	38.39771700	27.11505300	2
19005	15	D2H195943	HANDAN CENG─░Z	38.39475220	27.11190200	2
19006	15	D2H115864	HAT─░CE KARADUMAN	38.40176420	27.11869350	2
19007	15	D2H143636	HAT─░CE ┼ŞENSOY	38.39479180	27.11710560	2
19008	15	020052365	HAT─░CE TA┼Ş	38.39523700	27.11037000	2
19009	15	D2H185094	HAT─░CE UYANIK	38.39584930	27.11030220	2
19010	15	020047533	HAVVA ┼ŞENER	38.40083070	27.12352560	2
19011	15	D2H135836	HAYDAR U─ŞUR	38.39723700	27.12184500	2
19012	15	D2K205919	H├£LYA ┼ŞAH─░N	38.39429500	27.11607400	2
19013	15	D2K230964	H├£SEY─░N KAYA	38.39414470	27.11808400	2
19014	15	D2K235641	III.M─░RAN S─░NCAR GIDA ├£R├£NLER─░ TUR─░ZM ─░N┼ŞAAT OTOMOT─░V REKLAMCILIK ┼ŞANS	38.39588960	27.11844820	2
19015	15	D2K206511	─░BRAH─░M B─░RCAN	38.40778800	27.12737800	2
19016	15	020051041	─░LHAM─░ K├£├ç├£K	38.39557100	27.11037200	2
19017	15	D2K224367	─░LHAN CO┼ŞKUN	38.39887070	27.10871560	2
19018	15	D2K233819	KARBEL IZMIR KARABA─ŞLAR BELEDIYESI IN┼Ş.TEM.TAN.TUR.SAN.VE TIC.A.┼Ş.	38.40199100	27.11706800	2
19019	15	D2H197486	KER─░M DEM─░R	38.40398090	27.12633730	2
19020	15	020045381	K─░BARIM BOZYAKA	38.39734900	27.12206800	2
19021	15	D2K229865	KO├çMAR MARKET├ç─░L─░K GIDA ─░N┼ŞAAT Z├£CCAC─░YE TARIM OTOMOT─░V SANAT─░ VE T─░CA	38.39273100	27.11335880	2
19022	15	D2K231198	MAHMUT MANTU	38.39627490	27.11030800	2
19023	15	D2H164944	M─░RAN S─░NCAR GIDA ├£R├£N TUR.─░N┼Ş.OTO.REK.┼ŞANS OYUNLARI SAN.T─░C.LTD.┼ŞT─░.	38.39493600	27.11437400	2
19024	15	D2H110934	M─░RAN S─░NCAR GIDA ├£R├£NLER─░ TUR─░ZM ─░N┼Ş.SAN.T─░C.LTD.┼ŞT─░.	38.39647900	27.11437790	2
19025	15	D2K223923	MUHAMMED BERAT ├ûZO─ŞURLU	38.40063490	27.12075030	2
19026	15	020012176	MURAT G├£M├£┼Ş - G├£LERY├£Z MARKET	38.40684100	27.12468870	2
19027	15	D2H195531	MURAT HACIFAZLIO─ŞLU	38.39837900	27.10721300	2
19028	15	D2K236731	MUSTAFA ├ç─░YAN┼ŞEN	38.39681640	27.11314830	2
19029	15	020013620	M├£M─░N K├ûRO─ŞLU GIDA VE ─░N┼Ş.SAN.T─░C.LTD.┼ŞT─░.	38.39535300	27.11826500	2
19030	15	020017241	NAC─░ KARAARSLAN BAKKAL	38.39460000	27.11310000	2
19031	15	020048566	N─░HAT AYG├£N-AYG├£N MARKET	38.40575300	27.12595200	2
19032	15	020018781	NURETT─░N ├ûZYAPI	38.39357800	27.11319800	2
19033	15	D2K238110	NUR┼Ş─░N ORHAN	38.40634090	27.12714760	2
19034	15	D2K222756	NURTEN ┼ŞEH─░R	38.40100980	27.12539240	2
19035	15	D2H130092	ORHAN DEM─░R	38.39823270	27.11270850	2
19036	15	D2K231906	├ûZ KANMAZ MARKET├ç─░L─░K GIDA SAN.T─░C.LTD.┼ŞT─░.	38.39303280	27.11071470	2
19037	15	020018729	├ûZCAN OCAK	38.39733700	27.10976180	2
19038	15	020017247	├ûZLEM MANSURO─ŞLU	38.39655900	27.11415500	2
19039	15	020050394	PRENSES YA─ŞMUR GIDA ┼ŞANS. OY.─░N┼Ş.TUR.VE	\N	\N	2
19040	15	D2H098091	RAM─░Z OKULMU┼Ş	38.39745200	27.10548200	2
19041	15	D2H189404	RESUL TAYLANHAN	38.39564220	27.11571020	2
19042	15	D2K231346	SEDAT SUNAL	38.39640820	27.10985180	2
19043	15	020010453	SEMRA HAN─░FE ├çOKAL ├çEREZC─░ VE TEKEL BAY─░─░	38.39704500	27.11345300	2
19044	15	D2H158123	SEMRA YOKU┼Ş	38.39978600	27.11190900	2
19045	15	D2H185410	SERAP O─ŞUZ	38.39560440	27.11233530	2
19046	15	D2K221713	SERCAN KURTULU┼Ş	38.39776050	27.11163960	2
19047	15	D2H132559	SERDAL DABAKO─ŞLU	38.39988930	27.12216670	2
19048	15	020052927	SERHAT MERAL	38.40559400	27.12384600	2
19049	15	020053362	SERP─░L SOYUCAK	38.39330000	27.11740000	2
19050	15	020048275	SULTAN TURAN-YEN─░ ├£M─░T	38.39925700	27.09853800	2
19051	15	020052865	S├£LEYMAN BARI┼Ş ─░PEK	38.40377370	27.12480080	2
19052	15	D2K234469	┼ŞAH─░N BO─ŞA	38.39734650	27.10978930	2
19053	15	D2K242701	┼ŞAK─░R SERTER	42.94838100	34.13287400	2
19054	15	020016000	TANKAR ENERJ─░ PETROL OTO.─░N┼Ş.GIDATA┼Ş. SAN.T─░C.LTD.┼ŞT─░.-K├ûSTENCE	38.40185300	27.12448900	2
19055	15	D2K209490	T├£RKAN KAYTAN	38.39986390	27.12215700	2
19056	15	020053218	UMUT ├ûZS├£ER	38.39899010	27.10639160	2
19057	15	D2H157383	VEYSEL ├çORUH	38.39729840	27.11047440	2
19058	15	D2K219109	VUSLET YURDAKUL	38.39274800	27.11342060	2
19059	15	D2H107536	YAS─░N AYDINALP	38.40615910	27.12791760	2
19060	15	D2H166227	YEN─░NES─░L TEM─░ZL─░K MADDELER─░ PAZARLAMA ─░N┼ŞAAT GIDA ─░THALAT ─░HRACAT SAN	38.39667680	27.10815480	2
19061	15	020017052	YUSUF KUYUKAN	38.39688600	27.10715600	2
19073	32	D28000342	CAFER ├ûZCAN	38.47081700	28.21314400	3
19074	32	D28001239	CEVDET ER─░M	38.42927300	28.35800200	3
19075	32	020028259	├çET─░N GIDA ─░TH.MAD.TOP.MAH.KOM.NAK.BES.LTD.┼ŞT─░	38.34355240	28.52204420	3
19076	32	D28215549	D─░DEM SULTAN AG─░T	38.34168050	28.52326590	3
19077	32	D28177193	EBRU BATI	38.35152600	28.52522300	3
19078	32	D28152056	EL├ç─░N ┼ŞAH─░N	38.37758570	28.53296110	3
19079	32	D28056093	EL─░F ALTAY	38.34205500	28.52305300	3
19080	32	D28000526	EL─░F ELAG├ûZ	38.34578880	28.53037210	3
19081	32	D28216487	ERCAN DA┼ŞKIN	38.35705270	28.53919530	3
19082	32	D28000258	ERDAL AKBA┼Ş	38.42536700	28.35491300	3
19083	32	D28147900	ERDAL G├£NE├ç	38.38462800	28.44192100	3
19084	32	D28165403	ERSAN ├ûZYILDIZ	38.34540370	28.52058860	3
19085	32	D28047987	FAD─░ME EFE	38.45383600	28.26941500	3
19086	32	D28000471	FAT─░H ERS├ûZ	38.34262680	28.52568470	3
19087	32	D28002597	FATMA ANA SOLAK	38.45567340	28.29869010	3
19088	32	D28200214	FEYAZ UNAL	38.42824760	28.35677910	3
19089	32	D28095342	G├ûKHAN ├ûZKAN	38.41957300	28.35033100	3
19090	32	D28075812	G├ûVER PETROL LTD.┼ŞT─░.	38.35898300	28.53810500	3
19091	32	D28186224	G├ûZDE 2 AKARYAKIT VE PETROL ├£R├£NLER─░ ─░N┼ŞAAT LTD.┼ŞT─░.	38.35782730	28.54409040	3
19092	32	D28195091	G├£LNUR TA┼ŞLIK	38.34352810	28.51717230	3
19093	32	D28001613	G├£NG├ûR ├çAKMAK	38.41780400	28.34893200	3
19094	32	D28155882	G├£NSEL BULUT	38.34730450	28.53504050	3
19095	32	D28002989	HAKAN AYANA	38.45423100	28.26800500	3
19096	32	D28141083	HAKAN KARAKUYUN	38.34882690	28.53084050	3
19097	32	D28036366	Halil Pekdemir-Manisa03-Ala┼şehir-3	38.34879100	28.53267400	3
19098	32	D28000270	HAL─░L SARI	38.42163410	28.35154420	3
19099	32	D28031448	HANIM ARSLAN	38.34555300	28.52970500	3
19100	32	D28227590	HASAN H├£SEY─░N T├£RKEN	38.40445840	28.43549510	3
19101	32	D28019547	HA┼Ş─░M ALMI┼Ş	38.41913100	28.35012700	3
19102	32	D28166038	HAT─░CE ├çAKI	38.34493940	28.52870940	3
19103	32	D28176879	HAT─░CE E─ŞE	38.46784270	28.19785220	3
19104	32	D28000478	H├£SEY─░N ┼ŞAH─░N	38.34979600	28.53404500	3
19105	32	D28195031	H├£SEY─░N TA┼ŞD├ûNER	38.35425010	28.53778790	3
19106	32	D28116539	─░BRAH─░M ─░ZL─░	38.45772300	28.29806300	3
19107	32	D28231173	─░BRAH─░M KANIK	38.40498350	28.43743140	3
19108	32	D28241062	─░BRAH─░M SEZEK	38.45771560	28.29837320	3
19109	32	D28242943	─░NC─░ AITALIEVA	42.94838100	34.13287400	3
19110	32	D28132911	─░SKENDER ERK	38.46335200	28.25701700	3
19111	32	D28090622	─░SMA─░L ├çET─░N	38.46912720	28.21357320	3
19112	32	D28232180	KENAN ASLAN	38.34323030	28.52201680	3
19113	32	D28066490	KEZ─░BAN BA┼ŞT├£RK	38.35690870	28.54291810	3
19114	32	D28194973	KOCATA┼Ş MOTORLU ARA├çLAR SAN.VE T─░C.LTD.┼ŞT─░	38.34353100	28.54357800	3
19115	32	D28146496	KUB─░LAY BATUHAN	38.34463200	28.52128800	3
19116	32	D28002868	MEHMET A─ŞIRBA┼Ş	38.35389800	28.54480200	3
19117	32	D28223521	MEHMET ├çINAR	38.34247650	28.52276080	3
19118	32	D28002119	MEHMET D─░KBAKAN	38.34997800	28.53444450	3
19119	32	D28000185	MEHMET ERDAL	38.41773120	28.34886110	3
19120	32	D28000470	MEHMET KOPARAN	38.34383470	28.52647750	3
19121	32	D28234652	MEHMET KURU	38.34287950	28.52225970	3
19122	32	D28000544	MEHMET ├ûZD─░L	38.37790690	28.53538380	3
19123	32	D28034582	MEHMET ┼Ş─░R─░N VURAL	38.42367900	28.35367300	3
19124	32	D28071553	MEHMET Y─░─Ş─░T OKCU	38.36044700	28.53263230	3
19125	32	D28143430	MELEK SEVEN	38.35653630	28.53873350	3
19126	32	D28087801	MEMET KO├çO─ŞLU	38.35580230	28.53922150	3
19127	32	D28166016	MERYEM AF┼ŞAR	38.34868680	28.53008420	3
19128	32	D28061750	MUHAMMET EM─░N ERT├£RK	38.40429210	28.43705450	3
19129	32	D28000457	MUHTEREM DALKILI├ç	38.34999100	28.52620390	3
19130	32	D28002340	MUSTAFA AL─░ KAYA	38.46720990	28.19581810	3
19131	32	D28181344	MUSTAFA DEM─░RKAP	38.43003720	28.34478300	3
19132	32	D28000255	MUSTAFA D─░KBAKAN	38.34919900	28.53343600	3
19133	32	D28002140	MUSTAFA ├ûZDEM─░R	38.37917060	28.53622390	3
19134	32	D28047252	MUSTAFA ├ûZD─░L	38.34693750	28.53175020	3
19135	32	D28002609	MUSTAFA TOLAN	38.35341800	28.54073800	3
19136	32	D28199681	NA─░L ALKAN	38.46700790	28.25831240	3
19137	32	D28214666	N─░LG├£N Y├ûR├£K	38.34736170	28.53180330	3
19138	32	D28102521	N─░METULLAH K├ûSE	38.34995100	28.52520600	3
19139	32	D28218921	NURAY KARADEN─░Z	38.42587090	28.35655930	3
19140	32	D28157076	NURETT─░N AKDA─Ş	38.38168380	28.48671340	3
19141	32	D28216032	OZAN T├£RK	38.37910800	28.53406400	3
19142	32	D28165184	├ûZDEM─░R ─░N┼ŞAAT EMLAK OTOMOT─░V MEZBAHA HAYVANCILIK VE AKARYAKIT SAN DI┼Ş	38.37084200	28.50440300	3
19143	32	D28112429	├ûZ-KAR ─░N┼Ş.NAK.TAR.├£RN.K├ûM.G├£B.SAN.VE T─░C.LTD.┼ŞT─░. YEN─░MAHLLE ┼ŞUBES─░	38.34967400	28.52920000	3
19144	32	D28000225	RAMAZAN A┼ŞAR	38.42918000	28.35728100	3
19145	32	D28153321	RUK─░YE ├£NL├£T├£RK	38.35742950	28.53833800	3
19146	32	D28154555	SABR─░NAZ BAYSAK	38.46876070	28.17186900	3
19147	32	D28003083	SELMA ATE┼Ş	38.40231300	28.43393900	3
19148	32	D28001074	SEMRA ALMAS	38.34393290	28.53139010	3
19149	32	020028171	SERTTA┼Ş LTD.┼ŞT─░.	38.43411300	28.39156200	3
19150	32	D28231303	S─░BEL BACI	38.34816780	28.53296790	3
19151	32	D28134761	S─░NAN DEM─░R	38.34775220	28.53377350	3
19152	32	D28189609	SULTAN BAYRAM	38.45782350	28.29955430	3
19153	32	D28223462	S├£LEYMAN EME├ç	38.37145800	28.52753100	3
19154	32	D28217018	┼ŞENY├£CELER GIDA ├£R├£NLER─░ ─░N┼ŞAAT TUR. SAN. T─░C.LTD.┼ŞT─░.	38.37685400	28.55843300	3
19155	32	D28069776	┼ŞER─░FE DUMAN	38.47231400	28.27000500	3
19156	32	D28203301	┼ŞEVKET SER─░NER	38.37769060	28.53522330	3
19157	32	D28220205	┼Ş├£KR├£YE YA─ŞARCIK	38.41971340	28.35043450	3
19158	32	D28195032	TU─ŞBA ├ûZKAYA	38.35059540	28.52892810	3
19159	32	D28000314	TUNCAY KILI├ç	38.46794300	28.20999450	3
19160	32	D28161490	VEYSEL A├çAR	38.45755110	28.29945410	3
19161	32	D28206845	YA─ŞIZ DA┼ŞKIN	38.35685270	28.53900630	3
19162	32	D28155982	YE┼Ş─░M DOYMAZ	38.47351200	28.26986930	3
19163	32	D28001403	YUSUF FIRTINA	38.47243500	28.16737100	3
19164	32	D28178750	YUSUF YILDIRIM	38.41981320	28.35057270	3
19165	32	D28002334	ZEHRA AYYILDIZ	38.34585500	28.52146600	3
19166	32	D28045588	ZEK─░YE SOYG├£R	38.34835000	28.52922000	3
19167	31	D28184648	AD─░L G├ûN├ç	38.35728080	28.51514120	3
19168	31	D28000413	AHMET G├ûKDA─Ş	38.35009770	28.51776810	3
19169	31	D28146815	AHMET KILI├ç	38.35754140	28.50636720	3
19170	31	D28035275	AHMET Y├£CEL	38.35901400	28.51361500	3
19171	31	D28123054	AKG├£LLER AKARYAKIT TARM ├£R├£N UN YEM HAY.S├£T VE S├£T ├£R├£N.SAN.VE DI┼Ş TIC	38.35897100	28.51947800	3
19172	31	D28000403	AKG├£LLER A┼Ş.	38.36472700	28.51514100	3
19173	31	D28219438	AK┼ŞEN KURUYEM─░┼Ş- YASEM─░N AK┼ŞEN	38.35925660	28.51752420	3
19174	31	D28230991	AL─░ SELBES	38.35365290	28.51762420	3
19175	31	D28219617	AL─░ YILDIRIM	38.35999250	28.51134720	3
19176	31	D28085190	AYHAN GER─░┼Ş	38.35580050	28.51148900	3
19177	31	D28218216	AYL─░N SEZG─░N	38.36196680	28.51311400	3
19178	31	D28166012	AY┼ŞE ├çET─░NKAYA	38.34895130	28.51957810	3
19179	31	D28215761	BALKIR PET.├£R├£N. GIDA SAN.VE T─░C.LTD.┼ŞT─░.-BALKIR PET.├£R├£N. GIDA SAN.VE	38.34822610	28.51194530	3
19180	31	D28188926	BELKIS ARGIN	38.35339230	28.50786940	3
19181	31	D28231021	BET├£L AKT├£RK	38.34992840	28.51405240	3
19182	31	D28149361	B─░M-TA┼Ş GIDA MAD.MOT.AR├ç.TEM.VE PAZ.SAN.VE T─░C.LTF ┼ŞT─░.	38.34720100	28.51949900	3
19183	31	D28172629	B─░RCAN T├£RKEKUL	38.36120300	28.51117400	3
19184	31	D28002427	CANKAR AKARYAKIT - ALA┼ŞEH─░R	38.35148300	28.52294400	3
19185	31	D28153779	CANSU AKBULUT	38.35375400	28.52178400	3
19186	31	D28083823	CEM─░LE TA┼ŞPINAR	38.35206720	28.51310370	3
19187	31	020028263	CENK ORAL	38.35211400	28.51735200	3
19188	31	D28194648	CENNET AKBULUT	38.35277600	28.51544700	3
19189	31	D28189558	CENNET ARSLAN	38.34946840	28.51309420	3
19190	31	D28177105	CEVDET ├ûZYILDIZ	38.34956480	28.51505890	3
19191	31	020028153	DERMAN ├ûZDEM─░R	38.34969900	28.51481800	3
19192	31	D28215037	D─░LARA KIRBA┼Ş	38.35913660	28.51789060	3
19193	31	D28201985	EMRAH AKBA┼Ş	38.35157480	28.50584290	3
19194	31	020028209	ERCAN BALIKCI	38.35300330	28.51709800	3
19195	31	D28204935	ERCAN SA─ŞLAM	38.35704600	28.50530400	3
19196	31	D28136340	ERTAN TA┼Ş├çI	38.35959800	28.50926700	3
19197	31	D28000432	E┼ŞREF AKY├£Z	38.35686000	28.52164300	3
19198	31	D28217741	FAD─░ME ERTA┼Ş	38.35136470	28.51445340	3
19199	31	D28003114	FERD─░ CANBAZ	38.35708200	28.51503000	3
19200	31	D28067704	FERUDUN SARICA	38.34938200	28.51430800	3
19201	31	D28199586	G├ûKHAN BOZYEL	38.35393580	28.51703020	3
19202	31	D28003030	G├ûKHAN G├ûKSU	38.35257400	28.51116800	3
19203	31	D28238140	G├ûKMEN ├ûZKAYA	38.35175260	28.51616710	3
19204	31	D28109437	G├ûN├£L ├çAM	38.35846800	28.51247000	3
19205	31	D28199248	G├£LS├£M G├£NDO─ŞDU	38.35562200	28.51216760	3
19206	31	D28201522	G├£RSEL SA─ŞLAM	38.35140600	28.50657700	3
19207	31	D28233458	HAL─░DE Y├£CEL	38.36010870	28.51515290	3
19208	31	D28144967	HAL─░L ─░BRAH─░M G├£RGEN	38.35684920	28.51841210	3
19209	31	D28000518	HAL─░L ─░BRAH─░M KAVRUK	38.34490800	28.51917100	3
19210	31	D28160809	HAL─░L ├ûZASLAN	38.34954300	28.50910100	3
19211	31	D28021240	Halil Pekdemir-Manisa01-Ala┼şehir-1	38.35712300	28.51866400	3
19212	31	D28029185	Halil Pekdemir-Manisa02-Ala┼şehir-2	38.35079600	28.51457800	3
19213	31	D28088478	Halil Pekdemir-Manisa04-Ala┼şehir-4	38.36035300	28.51972600	3
19214	31	D28105111	Halil Pekdemir-Manisa05-Ala┼şehir-5	38.35605400	28.51075600	3
19215	31	D28171981	Halil Pekdemir-Manisa12-Ala┼şehir-6	38.35565890	28.52273140	3
19216	31	D28002959	HAL─░T ├ûZB─░R	38.35397900	28.51614400	3
19217	31	D28180865	HASANCAN LOP├çU	38.34754000	28.51933200	3
19218	31	D28077225	HAT─░CE AKBULUT	38.35155610	28.50566340	3
19219	31	D28029452	HAT─░CE DALKILIN├ç	38.36187400	28.51336000	3
19220	31	D28173600	HAT─░CE ├ûZT├£RK	38.35374850	28.51615050	3
19221	31	D28000377	HAT─░CE S─░NE	38.34750280	28.51838970	3
19222	31	D28227388	HAT─░CE ULA┼Ş	38.35561480	28.51306730	3
19223	31	D28000401	HAT─░PO─ŞLU LTD. ┼ŞT─░.	38.35128200	28.51713900	3
19224	31	D28002450	H├£SEY─░N DO─ŞANLI	38.31524100	28.40650300	3
19225	31	D28000313	H├£SEY─░N ├ûREN	38.34817100	28.51645400	3
19226	31	D28216468	H├£SN├£ KARACA	38.35466100	28.50883900	3
19227	31	D28003034	─░BRAH─░M ├çAM	38.35856800	28.51316000	3
19228	31	D28163650	─░NC─░ BA┼ŞTAN BALIKCI	38.35455090	28.52284920	3
19229	31	D28212798	─░SA BA┼Ş├çAM	38.35190870	28.51773630	3
19230	31	D28028659	KADR─░YE G├£NAY	38.35284790	28.51371470	3
19231	31	D28172628	KAM─░L TURGUT	38.35146620	28.51768990	3
19232	31	D28209223	KAZIM ATILGAN	38.35061800	28.51619100	3
19233	31	D28104377	KEMAL CAN ├ûZKAN	38.36349100	28.51080100	3
19234	31	D28217476	KEVSER KAYA	38.36091800	28.51010200	3
19235	31	D28207954	KIVAN├ç KESK─░N	38.34985650	28.51452810	3
19236	31	D28231417	K├ûYL├£M ┼ŞARK├£TER─░	38.35966190	28.51670550	3
19237	31	D28241663	MAHMUT ├çANDIR	38.35355580	28.50678370	3
19238	31	D28203205	MEHMET AL─░ KAZAN	38.35098740	28.51431210	3
19239	31	D28157271	MEHMET KARATA┼Ş	38.34466900	28.51966500	3
19240	31	D28228599	MUHABET G├£LTEPE	38.36089240	28.52015500	3
19241	31	D28234651	MUHAMMET AKBA┼Ş	38.35782610	28.50551490	3
19242	31	D28200333	MUSTAFA ├ûZKURT	38.35754980	28.51452750	3
19243	31	D28154307	MUSTAFA SA─░D ATAK	38.35630230	28.52104150	3
19244	31	D28236443	MUZAFFER URAL	38.36048670	28.51016160	3
19245	31	D28156790	NAZAN CURA	38.35265800	28.51709100	3
19246	31	D28028431	NURAY G├ûZBABA	38.35516900	28.51961500	3
19247	31	D28237692	N├£KHET ├£NL├£ BALIKCI	38.35683540	28.51851190	3
19248	31	D28003157	OLCAY YILMAZ	38.34992700	28.51516000	3
19249	31	D28045075	OSMAN G├£ND├£Z	38.35403500	28.51680700	3
19250	31	D28076698	├ûMER KARAKA┼Ş	38.34962200	28.51364400	3
19251	31	D28139533	├ûM├£R KO├ç	38.35181700	28.51461900	3
19252	31	D28000412	├ûZCAN ├çAKIR	38.35032800	28.51968900	3
19253	31	020028223	├ûZG├£R MAT	38.34969900	28.51825400	3
19254	31	D28204939	PINAR DANACI	38.35309390	28.50779070	3
19255	31	D28002413	PINAR KARACA	38.35235300	28.51514700	3
19256	31	D28153436	RAMAZAN UYSAL	38.35473620	28.52231700	3
19257	31	D28086614	RAMAZAN UYSAL	38.36197500	28.51315800	3
19258	31	D28210100	RECEP K├ûSE	38.34870830	28.51851510	3
19259	31	D28111568	RUK─░YE KOCATA┼Ş PETROL ├£R├£NLER─░ L─░M─░TED ┼Ş─░RKET─░	38.35124700	28.52266400	3
19260	31	D28201592	R├£┼ŞT├£ G├ûKDEM─░R	38.35027750	28.51584670	3
19261	31	D28000452	SABR─░ ULUSU	38.34513300	28.51928300	3
19262	31	D28233072	SAVA┼Ş BALCI	38.35605550	28.51782440	3
19263	31	D28076462	SAVA┼Ş DURAL	38.35708500	28.51845700	3
19264	31	D28026111	SEMA B─░LER	38.35447500	28.51258900	3
19265	31	D28001803	SEM─░H G├ûK	38.35686800	28.50827700	3
19266	31	D28231353	SEMRA KIRMIZIKAN	38.35774570	28.51402710	3
19267	31	D28229037	SERKAN KAYNAR	38.35186380	28.51295350	3
19268	31	D28191042	S├£LEYMAN BOZDEM─░R TORUNLARI KOL.┼ŞT─░.	38.34903890	28.51277670	3
19269	31	D28160107	S├£LEYMAN CURA	38.35404100	28.50870000	3
19270	31	D28208708	┼Ş├£KR─░YE KULA	38.35223310	28.52065750	3
19271	31	D28200332	TAH─░R S├ûNMEZ	38.34929660	28.51291440	3
19272	31	D28230730	TAH─░R S├ûNMEZ 2	38.35055500	28.51193960	3
19273	31	D28171762	TOTAL 99 UNLU MAM├£LLER,TUR─░Z─░M,AKAR.SAN.T─░C.LTD.┼ŞT─░	38.36557820	28.51377680	3
19274	31	D28098985	├£MMET G├£RMEN	38.35061100	28.51384900	3
19275	31	D28233817	YASEM─░N ERDO─ŞAN	38.36303270	28.51497700	3
19276	31	D28198750	YA┼ŞAR AKKU┼Ş	38.35281300	28.51740100	3
19277	31	020028251	YA┼ŞAR SAMUR	38.35074810	28.51571810	3
19278	31	D28180021	YAVUZ CAN KARAG├ûZ	38.36064620	28.51996970	3
19279	31	D28000431	YILDIRIM LTD.┼ŞT─░.	38.35130900	28.51030000	3
19280	31	D28002558	ZENG─░NLER GIDA LTD.┼ŞT─░.	38.35007500	28.51734000	3
19281	55	D28087228	ADN PETROL ├£R├£N.OTEL SAN.VE T─░C.LTD.┼ŞT─░	38.32628390	28.57294550	3
19282	55	D28002647	AHMET TOSUN	38.43486800	28.52674720	3
19283	55	D28125781	AKIN ERKAN	38.17402930	28.51251750	3
19284	55	D28001214	AL─░ U├çMAZ	38.27285100	28.60967800	3
19285	55	D28039874	AYFER BELER	38.34092450	28.65844640	3
19286	55	D28200675	AYFER ├çAKMAK	38.32939060	28.56941690	3
19287	55	D28203246	AY┼ŞE AYAN	38.30263400	28.57042400	3
19288	55	D28017292	AY┼ŞE KARAMAN	38.48708600	28.30427900	3
19289	55	D28000297	BARI┼Ş G├£LC├£	38.34037370	28.66150420	3
19290	55	D28204688	BAYRAM ILGIN	38.40744480	28.72611130	3
19291	55	D28079434	BED─░HA ARAL	38.34108550	28.65878320	3
19292	55	D28228742	BEK─░R YILDIRIM	38.18034400	28.52890160	3
19293	55	D28221218	BEKTA┼Ş ATMACA	38.47548630	28.33847890	3
19294	55	D28000928	B─░RCANO─ŞLU GIDA TEM.─░N┼Ş.MAL.TAR.├£R.LTD. ┼ŞT─░.	38.28335630	28.61306010	3
19295	55	D28000892	B├£LENT ERDO─ŞAN	38.34039690	28.66172280	3
19296	55	D28062775	CEM KAYA	38.37892700	28.61687800	3
19297	55	D28002151	CENG─░Z ─░┼ŞSEVEN	38.18040990	28.54086980	3
19298	55	D28184432	CENNET BO─ŞA	38.36327800	28.64911700	3
19299	55	D28003136	├çET─░N TARIM	38.41349400	28.55737400	3
19300	55	D28003031	├çET─░NLER TUR─░ZM LTD.┼ŞT─░	38.18141100	28.53979900	3
19301	55	D28224442	DKM ATIK Y├ûNET─░M─░ LOJ─░ST─░K H─░Z. SAN. VE T─░C.A.┼Ş.	38.18226520	28.53732030	3
19302	55	D28002431	DO─ŞAN AKARYAKIT LTD.┼ŞT─░.	38.33798700	28.65829200	3
19303	55	D28001709	EM─░NE YAVUZ	38.33978000	28.66313700	3
19304	55	D28204040	EMRAH AKT├£RK	38.24418160	28.55022070	3
19305	55	D28057206	EMRE SERT	38.37905470	28.62369310	3
19306	55	D28166018	ENG─░N CEYLAN	38.18179940	28.54024440	3
19307	55	D28130799	ENVER BALIK	38.29956720	28.63310860	3
19308	55	D28188881	ERG├£N UYAR	38.33941000	28.66275800	3
19309	55	D28184421	ESRA KO├ç	38.37860900	28.61749510	3
19310	55	D28212787	FATMA CEYLAN	38.18161250	28.53994780	3
19311	55	D28152137	FATMA G─░RG─░N	38.45441590	28.45554160	3
19312	55	D28208614	FEVZ─░ ERT├£RK	38.34189110	28.65221420	3
19313	55	D28184309	G├£LAY KO├ç	38.14820510	28.48218990	3
19314	55	D28168998	G├£LSEREN ├çEL─░K	38.14846540	28.47971450	3
19315	55	D28199251	HAKAN ERSOY	38.48734900	28.30418100	3
19316	55	D28000005	HAL─░L G├£LMEZ	38.47701500	28.33349900	3
19317	55	D28000304	HAL─░L ZEYBEK	38.37496500	28.62526700	3
19318	55	D28002870	HAMZA PULAT	38.41121460	28.72396100	3
19319	55	D28095737	HANIM ERT├£RK	38.34040300	28.66121000	3
19320	55	D28239545	HASAN AKKU┼Ş	38.41670300	28.73520220	3
19321	55	D28000092	HASAN G├£NEN	38.46272840	28.42724940	3
19322	55	D28216401	HASAN TOPUK	38.34013830	28.66357940	3
19323	55	D28190505	HAT─░CE CO┼ŞKUN	38.43593890	28.52726930	3
19324	55	D28056748	HAT─░CE ORU├ç	38.33782740	28.66109190	3
19325	55	D28173699	HAT─░CE SIR├çAK	38.25016100	28.57496500	3
19326	55	D28135057	HAT─░CE VARDAR	38.44493600	28.49936200	3
19327	55	D28235566	HEB─░BE SERT	38.37698660	28.62183710	3
19328	55	D28000960	H─░MMET KATAR	38.18050550	28.54066550	3
19329	55	D28177237	H├£SEY─░N AKZEYBEK	38.20346480	28.52057950	3
19330	55	D28002321	H├£SEY─░N ALTINAY	38.36298100	28.64880200	3
19331	55	D28229466	H├£SEY─░N GEN├çER	38.46300380	28.42627410	3
19332	55	D28167789	H├£SEY─░N G├£VEN	38.28215560	28.61493310	3
19333	55	D28226421	H├£SEY─░N KAYA	38.41232850	28.55612620	3
19334	55	D28002214	H├£SEY─░N TURGUT	38.44133110	28.49542040	3
19335	55	D28000686	H├£SN├£ TURCAN	38.37705840	28.62135490	3
19336	55	D28038127	─░BRAH─░M ├çOBAN	38.28101760	28.58961460	3
19337	55	D28002293	─░BRAH─░M Y├ûNTEM	38.20654000	28.51951190	3
19338	55	D28053381	─░SA ARIKAN	38.38004680	28.61504780	3
19339	55	D28202215	─░SA UYSAL	38.24723470	28.58196650	3
19340	55	D28000888	─░SMA─░L G├£LC├£	38.34059490	28.65905820	3
19341	55	D28001272	─░SMA─░L SOLAK	38.18068340	28.54025620	3
19342	55	D28140950	KAHRAMAN A┼Ş├çI	38.33764800	28.66525900	3
19343	55	D28204170	KAZIM AY	38.30048410	28.63363860	3
19344	55	D28001618	KIYMET KARAMAN	38.48719400	28.30399000	3
19345	55	D28165575	KOCAHIDIR PETROL LTD.┼ŞT─░	38.28098790	28.61003290	3
19346	55	D28173349	MADANO─ŞLU SO─ŞUK HAVA DEPOSU LTD.┼ŞT─░	38.33155020	28.56501790	3
19347	55	D28230878	MEHMET AL─░ BA┼ŞKAYA	38.18253390	28.50593870	3
19348	55	D28002131	MEHMET ├çAKAL	38.33945060	28.66265660	3
19349	55	D28002497	MEHMET ├çILGIN	38.18276740	28.46778540	3
19350	55	D28000850	MEHMET DA─ŞDELEN	38.18031500	28.54130700	3
19351	55	D28001167	MEHMET EM─░N G├£NE┼Ş	38.46291480	28.42676840	3
19352	55	D28165560	MEHMET ├ûZER	38.46328320	28.42590710	3
19353	55	D28002560	MEHMET SEZG─░N	38.24971700	28.57583200	3
19354	55	D28076980	MEHMET TA┼Ş	38.41246300	28.55617300	3
19355	55	D28002907	MESUT CEYLAN	38.39860000	28.58255000	3
19356	55	D28002172	MUHAMMET DEM─░REL	38.29806300	28.57104000	3
19357	55	D28001951	MUHARREM T├£RKYILMAZ	38.27351700	28.60862200	3
19358	55	D28081888	MURAT TARIM	38.41156990	28.55546290	3
19359	55	D28188864	MUSTAFA YILMAZ	38.31035370	28.58310820	3
19360	55	D28001234	MUTLU ERDEM	38.34052780	28.65930730	3
19361	55	D28227826	N─░HAT DERE	38.30669180	28.63673510	3
19362	55	D28231019	NURULLAH KON	38.20659990	28.51937730	3
19363	55	D28179161	OKTAY ZENG─░N	38.46265400	28.42715100	3
19364	55	D28000965	OSMAN KILLI 1	38.33798900	28.66508900	3
19365	55	D28199252	OSMAN S├ûNMEZ	38.41352750	28.55746640	3
19366	55	D28056049	├ûMER KOCABA┼Ş	38.41381400	28.55747000	3
19367	55	D28001204	├ûMER K├£L├ç├£R	38.37813850	28.62293960	3
19368	55	D28002582	├ûV├£N├ç AKSOY	38.47569720	28.33899820	3
19369	55	D28000900	├ûZER YILDIRIM	38.37721050	28.62151190	3
19370	55	D28183626	├ûZG├£R ├ûZDEM─░R	38.33613340	28.66554680	3
19371	55	D28082470	├ûZG├£R YILMAZ	38.47576400	28.34113370	3
19372	55	D28000039	RAKUP AKTA┼Ş	38.41513740	28.55863960	3
19373	55	D28033070	RAMAZAN YURTTA┼Ş	38.41017100	28.72903900	3
19374	55	D28184851	RA┼Ş─░T B─░LG─░N	38.14820580	28.47839240	3
19375	55	D28067367	RAZ─░YE YILDIRIM	38.37821380	28.61488070	3
19376	55	D28110205	SARIKIZ PETROL	38.40328900	28.54496400	3
19377	55	D28199373	SELAHATT─░N ERDEM	38.17500860	28.50888960	3
19378	55	D28232892	SEL├çUK G├£ZEL	38.28405990	28.61208650	3
19379	55	D28168008	S─░NAN AKKU┼Ş	38.41510760	28.73342740	3
19380	55	D28242793	SUAT ┼ŞEN	42.94838100	34.13287400	3
19381	55	D28000264	S├£LEYMAN G├£LE├ç	38.46401580	28.42663860	3
19382	55	D28092753	S├£LEYMAN T├£RKYILMAZ	38.39342100	28.59099600	3
19383	55	D28000096	┼ŞAD─░ AK├çAY	38.47540820	28.34100610	3
19384	55	D28002608	TEVF─░K B─░RCAN	38.41238380	28.55797060	3
19385	55	D28000939	U─ŞUR TOPRAK	38.37686580	28.62148810	3
19386	55	D28002205	├£ZEY─░R USTA	38.34004200	28.66376800	3
19387	55	D28069850	YAHYA UYSAL	38.45509460	28.45642370	3
19388	55	D28206326	YANIKLAR GIYIM PETROL ├£R├£NLERI TEKEL MADD. AV MALZ. MOT. LTD.┼ŞT─░.	38.27381230	28.62108450	3
19389	55	D28166744	YAS─░N AKDA─Ş	38.27218800	28.62372800	3
19390	55	D28076930	YA┼ŞAR ALTILI	38.20409390	28.51790600	3
19391	55	D28000089	YAVUZ CENG─░Z	38.41441790	28.55800020	3
19392	55	D28058978	YILDIZ D─░NDAR	38.33797500	28.66793300	3
19393	55	D28148662	YUNUS TUZAK	38.18062740	28.54006390	3
19394	55	D28122290	YUSUF A┼ŞKIN	38.45428500	28.45558900	3
19395	55	D28230865	ZAFER G├£RLEK	38.20404200	28.51781580	3
19396	55	D28002402	ZEHRA AY	38.30051470	28.63396940	3
19397	35	D28000449	AD─░L ALTUNBA┼Ş	38.75196200	28.46965900	3
19398	35	D2F000718	AHMET AFACAN	38.99031670	28.13669200	3
19399	35	D28172459	AHMET AVCI	38.98810100	28.13929740	3
19400	35	D28000782	AHMET ├çEL─░K	39.03219200	28.88871900	3
19401	35	D28205500	AHMET G├ûKKAYA	39.04171160	28.65911080	3
19402	35	D2F016684	AHMET UYSAL	38.93530000	28.28688600	3
19403	35	D28193718	AKIN ─░┼ŞC─░	38.74823400	28.40309700	3
19404	35	D28224302	AL─░ Y├£KSEL	38.92358310	28.29596470	3
19405	35	D2F003905	AL─░ Z─░YA TANRISEVER	38.95195730	28.12449800	3
19406	35	D28155165	AR─░FE ├çET─░NTA┼Ş	39.03290260	28.65546950	3
19407	35	D28000747	A┼ŞIKLAR DAY. T├£K. MALLARI ─░N┼Ş. TUR.TEKST─░L GIDA SAN. VE T─░C. LTD. ┼ŞT─░	39.04700400	28.65696400	3
19408	35	020029083	AYNUR ├çEV─░RGEN	39.04487800	28.65435300	3
19409	35	D2F135528	AYNUR G├£NDO─ŞDU	39.01302380	28.26513010	3
19410	35	D28151021	AY┼ŞE ├çET─░N	38.74908690	28.40279510	3
19411	35	D2F001729	AY┼ŞE D─░LBAZ	38.93541730	28.28878880	3
19412	35	D28206804	AY┼ŞE DUDU TURAN	38.94773750	28.10115180	3
19413	35	D28003063	AY┼ŞE HANIM G├£NE┼Ş	38.79394100	28.59458200	3
19414	35	D28147957	AY┼ŞE KARAARSLAN	38.79426870	28.59531150	3
19415	35	D2F127652	AY┼ŞE YILDIZ	38.93561700	28.28861700	3
19416	35	D28204825	BAKKAL-AYKANAT KARDESLIR SANAYI VE TICARET LTD.┼ŞT─░.	38.93314300	28.28985400	3
19417	35	D28189477	BAYRAM SEV─░M	39.03837690	28.20931800	3
19418	35	D28224166	BEK─░R KARABIYIK	38.95342580	28.22786440	3
19419	35	D28227386	BU─ŞRA ER├çET─░N	38.74827100	28.40320100	3
19420	35	D28000632	B├£LENT AKKUZU	39.03493200	28.65744300	3
19421	35	D28000708	B├£NYAM─░N DO─ŞAN	38.75194900	28.46915400	3
19422	35	D28227385	CAH─░DE AKDERE	38.86372550	28.64606920	3
19423	35	D28159340	CAN─░P ├ûRM├£┼Ş	38.93650220	28.28787990	3
19424	35	D28171117	CENG─░Z ├çAKMAK	38.82303670	28.21680530	3
19425	35	D28034631	CO┼ŞAR PETROL.NAK.TEM.H─░Z.OTEL.SAN.VE T─░C.LTD.┼ŞT─░	39.03608670	28.65371630	3
19426	35	D2F120511	DAGDERE YILMAZ PETROL ├£R├£NLERI OTO. GIDA SAN. VE TIC. LMD. SIRKETI	38.99413600	28.14162200	3
19427	35	D28121030	DEDE PETROL TUR─░ZM OTOMOT─░V TEKST─░L NAKL─░YE GIDA SAN. VE T─░C. LTD. ┼ŞT─░	39.03068800	28.64267400	3
19428	35	D28187905	DEM─░RC─░ A├çIK CEZA ─░NFAZ KURUMU ─░┼ŞYURDU M├£D├£RL├£─Ş├£	39.05038870	28.67678360	3
19429	35	D28181265	DEM─░RC─░ ├çOMAK PETROL T─░CARET LTD.┼ŞT─░	39.05536090	28.67894660	3
19430	35	D28168954	DEM─░RULUS AKARYAKIT LTD.┼ŞT─░.	38.97267090	28.23931660	3
19431	35	D28224441	DEM─░RULUS AKARYAKIT LTD.┼ŞT─░.	39.02954450	28.41102530	3
19432	35	D2F004065	DEM─░RULUS ME┼ŞRUBAT GIDA LTD.┼ŞT─░.	39.03335180	28.42385720	3
19433	35	D28237984	DEVR─░M DAL	38.74821540	28.40245940	3
19434	35	D28224792	D─░LAY ├ûREN	39.03958640	28.65796770	3
19435	35	020029077	DO─ŞAN UYGUN	39.03709000	28.65771500	3
19436	35	D28114951	D├ûNE ATALAY	39.03598020	28.66128260	3
19437	35	D2F121268	D├ûNMEZLER AKARYAKIT, LPG, GIDA, TOPRAK MAHS├£LLERI, HARFIYAT,TASIMACILI	39.00351270	28.09576640	3
19438	35	D28207609	EKREM AYDIN	38.75218300	28.46860800	3
19439	35	D28192882	EM─░NE ├çIRACI	39.09410190	28.61199600	3
19440	35	D28061996	ERKAN AK├çELEB─░	39.01027300	28.84819300	3
19441	35	D28002440	ERKAN DEM─░R	38.79346620	28.31179920	3
19442	35	D28214947	ERKAN KAHYA	38.93324600	28.28941280	3
19443	35	D2F003887	ERTEM ├çOLAK	39.02705200	28.24733000	3
19444	35	D28000704	ERTU─ŞRUL YARI┼Ş	38.75196800	28.46927500	3
19445	35	D28000770	FAD─░ME UYAR	38.74979400	28.40053900	3
19446	35	D28231559	FAHRETD─░N SARI	38.81908010	28.63003840	3
19447	35	D28064285	FAHR─░ ALTUN	39.02458400	28.84765100	3
19448	35	D28146956	FAT─░H ├çEV─░RGEN	39.04636430	28.65637060	3
19449	35	D2F000602	FATMA AKDA─Ş	38.94713690	28.10075410	3
19450	35	D28172329	FATMA BULUT	38.95296160	28.12392800	3
19451	35	D28058909	FATMA ├ûNGEL	39.04996500	28.66220900	3
19452	35	D28203552	FATMA UYSAL	38.74801650	28.40378430	3
19453	35	D28188490	FELAMURLAR B─░Z─░M K├ûY MARKET ┼ŞARK├£TER─░ A.┼Ş	38.74809620	28.40101760	3
19454	35	D28232467	FEYZA KAZAK	38.93312290	28.28892530	3
19455	35	D28001787	G.MET─░N ├çET─░N	39.04488300	28.65486900	3
19456	35	D28189393	GAN─░ KOCAY─░Y─░T	39.04505340	28.65474130	3
19457	35	D28179085	G├£LS├£M UZUN	38.99018060	28.13677560	3
19458	35	D28146375	G├£L┼ŞEN EROL	38.93683890	28.28425020	3
19459	35	D28002355	HAKAN BEK	38.88719800	28.76587200	3
19460	35	D28186020	HAKKI KORAL	38.83917380	28.13005020	3
19461	35	D2F003886	HAL─░L DEM─░RARSLAN	39.06133100	28.21530900	3
19462	35	D2F001852	HAL─░L K├£├ç├£K	38.93667400	28.28496500	3
19463	35	D28203362	HAL─░L U─ŞURLU	39.04448740	28.65209740	3
19464	35	D28001521	HAL─░ME KARATA┼Ş	38.87374000	28.69301800	3
19465	35	D28159061	HASAN BASR─░ KAVAK	38.99038700	28.13584800	3
19466	35	D28000748	HASAN B─░LG─░L─░	39.03435600	28.65779600	3
19467	35	D28205114	HAT─░CE AKIN	39.04245070	28.64922680	3
19468	35	D28001836	HAT─░CE AKYOL	39.04709770	28.65269100	3
19469	35	D28191514	H─░DAYET ├çET─░NKAYA	38.93302600	28.28859640	3
19470	35	D28185367	H─░KMET UYAN	38.81013160	28.33815930	3
19471	35	D28002585	H─░MMET AKG├£N	38.75275700	28.46701300	3
19472	35	D2F004080	H├£SAMETT─░N D├ûNMEZ	38.93223200	28.28947600	3
19473	35	D28233471	H├£SEY─░N B─░LG─░N	39.03183450	28.89315790	3
19474	35	D28222800	H├£SEY─░N EREN	38.81140000	28.33848900	3
19475	35	D28219674	H├£SEY─░N ER-SE├ç MARKET	38.74777040	28.40270370	3
19476	35	D2F000707	H├£SEY─░N KENAR	38.98275920	28.15054690	3
19477	35	D28200540	─░BRAH─░M AKYOL	38.74826450	28.40236500	3
19478	35	D2F003789	─░BRAH─░M KAHYA	38.92837100	28.28795900	3
19479	35	D28001775	─░BRAH─░M KAMA	39.04486800	28.65426800	3
19480	35	D28174607	─░BRAH─░M KAYAHAN	38.87103610	28.22212900	3
19481	35	D2F001724	─░LYAS ABA / GARAJ MARKET	38.93564300	28.28638100	3
19482	35	D28205933	─░SMA─░L AKINCI	39.04567740	28.65584030	3
19483	35	D28002761	─░SMA─░L ERCEYLAN	38.95388140	28.51197020	3
19484	35	D28000811	─░SMA─░L ├ûZ├çEL─░K	38.95571830	28.51249230	3
19485	35	D28012464	─░SMA─░L ┼ŞAH─░N	39.01428200	28.50008000	3
19486	35	D28188544	─░SMA─░L YILDIRIM	39.02415900	28.84771450	3
19487	35	D28165833	─░SMET KAZCIO─ŞLU OTOMOT─░V LTD.┼ŞT─░.	39.16721680	28.59939530	3
19488	35	D28219160	KARACA KUYUMCULUK T─░C. VE SAN. LTD. ┼ŞT─░.	39.04724930	28.65736530	3
19489	35	D28180967	K├£BRA TA┼Ş	39.03352100	28.65834990	3
19490	35	020029050	M.EM─░N AKBIYIK	38.74817100	28.40276900	3
19491	35	D28144327	MAHMUT AKKU┼Ş	38.79347150	28.31183700	3
19492	35	D2F128321	MAHMUT HARUN ├ûZCAN	38.93355930	28.28917480	3
19493	35	D28002282	MEHMET ACAR	39.04487850	28.65526210	3
19494	35	D28231168	MEHMET AKKU┼Ş	39.15682590	28.61393520	3
19495	35	D28017776	MEHMET ARSLAN	39.00986800	28.84823200	3
19496	35	D2F111046	MEHMET BABAY─░─Ş─░T	38.93322400	28.28876100	3
19497	35	D28061527	MEHMET ├çEL─░KKAYA	38.96053170	28.79506120	3
19498	35	D2F003461	MEHMET ├ç─░├çEK	38.86066590	28.21059420	3
19499	35	D28026693	MEHMET DEM─░R	39.04757200	28.65851300	3
19500	35	D2F003397	MEHMET DEM─░RARSLAN	39.06389640	28.21815800	3
19501	35	D28009990	MEHMET ERS├ûZ	38.75207500	28.46885300	3
19502	35	D28238504	MEHMET G├£LE├ç	39.03343860	28.42367640	3
19503	35	D2F118570	MEHMET G├£M├£┼Ş	38.93327300	28.28838700	3
19504	35	D2F003400	MEHMET G├£VEN	39.03880420	28.21314170	3
19505	35	D28001750	MEHMET I┼ŞIK	38.74845700	28.40296100	3
19506	35	D28221952	MEHMET KULTA┼Ş	38.74826200	28.40225510	3
19507	35	D2F026694	MEHMET ├ûZELL─░	38.90804500	28.17791900	3
19508	35	D28001835	MEHMET SANDAL	39.05476800	28.66212800	3
19509	35	D28001753	MEHMET TOPAK	38.74722900	28.40380500	3
19510	35	D28156165	MEHMET ULUSOY 2	38.93732390	28.28345450	3
19511	35	D28000796	MEHMET ├£LKER	39.04486690	28.65568360	3
19512	35	D28098668	MEHMET YAS─░N KARAG├£L	39.12402390	28.51597690	3
19513	35	D28183918	MEHMET YAVUZ	39.03480540	28.42490250	3
19514	35	D28000768	MESUT C─░N	38.79424100	28.31336400	3
19515	35	D28225971	ME┼Ş─░NO─ŞLU BAKKAL─░YE GIDA VE ─░HT─░YA├ç MADDELER─░ T─░C.LTD.┼ŞT─░.	38.93302770	28.28768190	3
19516	35	D2F001755	MET─░N KURT	38.93309900	28.28787800	3
19517	35	D2F113824	MET─░N ├ûZDEM─░R	38.93012080	28.28872330	3
19518	35	D28239888	MEYSER ┼ŞAH─░N	38.93304200	28.28827810	3
19519	35	D28157482	MURAT YILDIZ	38.93634000	28.29161210	3
19520	35	D28197777	MUSTAFA ASLANT├£RK	38.93319830	28.28927260	3
19521	35	D28000754	MUSTAFA ATALAY	39.04131000	28.65885400	3
19522	35	D2F095629	MUSTAFA ENES UZUNER	38.93316400	28.28869300	3
19523	35	D2F001812	MUSTAFA ERTAN	38.93607310	28.29078000	3
19524	35	D2F003410	MUSTAFA ERTA┼Ş	38.86059600	28.21100200	3
19525	35	D28091947	MUSTAFA KAVAL	39.03810000	28.65773700	3
19526	35	D28192142	MUSTAFA K├ûSEM	38.91715760	28.36482840	3
19527	35	D28001861	MUSTAFA S├ûNMEZ	39.05197200	28.66017200	3
19528	35	D28226338	MUSTAFA T├£RKER	38.82115100	28.16865830	3
19529	35	D28192324	MUSTAFA YILMAZ	38.93325760	28.28958740	3
19530	35	D28001820	MUZAFFER AK├ç─░├çEK	38.74915400	28.40210100	3
19531	35	D28185738	NAF─░Z KANDIRMI┼Ş	38.88715230	28.76587430	3
19532	35	D28201262	NAZAN ARICI	39.03365430	28.65790430	3
19533	35	D2F132967	NEBAHAT ├ûZER	39.03322910	28.42309530	3
19534	35	D28164410	NECAT─░ G├£M├£┼Ş	39.03225390	28.88865460	3
19535	35	D28030404	NEJDET BOZKURT	38.75227800	28.46848600	3
19536	35	D28061517	NESL─░HAN DUMAN	39.15680000	28.61282500	3
19537	35	D2F122387	OKAN ARI	38.93470100	28.28702600	3
19538	35	D28200087	OLCAY MARKET ─░N┼ŞAAT T─░C.VE SAN.LTD.┼ŞT─░.	39.04080900	28.65875700	3
19539	35	D2F003612	OSMAN G├£NG├ûR	38.85501260	28.16496220	3
19540	35	D2F001858	├ûMER AYDIN	38.99709000	28.44217600	3
19541	35	D28217680	├ûNDER ULU	39.03505490	28.42560410	3
19542	35	D28117249	├ûZEL AYAZ	38.81265880	28.33882520	3
19543	35	D2F105341	├ûZG├£R SIVACI	38.92811800	28.28816300	3
19544	35	D28148448	├ûZKAN ONAN	38.95562720	28.51241500	3
19545	35	D28140779	RAB─░YE AK├ç─░├çEK	38.74807000	28.40244200	3
19546	35	D2F001841	RECA─░ CENG─░Z	38.90859720	28.17836200	3
19547	35	D28186612	RECEP S├ûNMEZ	39.05458050	28.66577790	3
19548	35	D28002696	S.S. K├ûYL├£CE K├ûY├£ TARIMSAL KALKINMA KOOP.	38.88173700	28.58682800	3
19549	35	D28239139	SAADET NUR OVALI	39.03458300	28.64941300	3
19550	35	D28215098	SEDAT YA─ŞCI	38.93585600	28.29022000	3
19551	35	D28003016	SEFA UYSAL	38.74808900	28.40296300	3
19552	35	D28153064	SEFER ACAR	39.09421550	28.61202890	3
19553	35	D2F003704	SELMA ULUTA┼Ş	38.93451800	28.28762400	3
19554	35	D2F003547	SUAT DORUK	38.85547260	28.16478010	3
19555	35	D2F001735	S├£LEYMAN CANDAN	38.99021500	28.13545000	3
19556	35	D2F001834	S├£LEYMAN DURSUN	39.03464440	28.42639390	3
19557	35	D28159341	S├£LEYMAN G├£LTEK─░N	38.93763450	28.28231090	3
19558	35	D2F001869	S├£LEYMAN KOCA├çAKIR	38.92196380	28.28470150	3
19559	35	D28002510	S├£LEYMAN SARI┼ŞIN	39.12441060	28.51512090	3
19560	35	D28187342	S├£LEYMAN YILDIZ	38.98975810	28.13781490	3
19561	35	D28001809	┼ŞAH─░N UYAR	38.79278300	28.59585000	3
19562	35	D28003070	┼ŞER─░F AKIN	38.87368300	28.69289100	3
19563	35	D28155769	┼Ş├£KR├£ KO├ç	38.79459510	28.59560910	3
19564	35	D28055709	TALAT KAYA	38.75177900	28.46949900	3
19565	35	D2F003573	TAYFUR ├£RE	38.92910000	28.28850000	3
19566	35	D28234816	TEND─░R─░S RESTORAN E-T─░CARET ─░TH. VE ─░HR. LTD. ┼ŞT─░	38.93347310	28.28873260	3
19567	35	D28210452	TUNCAY ├çAPRAK	38.85488450	28.16507340	3
19568	35	D28238204	UMUT K├£├ç	38.74801340	28.40287040	3
19569	35	D28002779	├£M─░T G├£NCAN	39.04516100	28.65521800	3
19570	35	D28209373	├£MM├£ ├£RE	38.92287030	28.28369790	3
19571	35	D28182042	VAROL K├£NK├ç├£-PROM─░L B├£FE	39.03382200	28.64827300	3
19572	35	D28002780	YAS─░N BOZKURT	38.75233900	28.46831200	3
19573	35	D2F069878	YAS─░N ├û─ŞRET─░C─░	38.93371300	28.29145600	3
19574	35	D28000775	YA┼ŞAR AKKAYA	39.04454900	28.65476800	3
19575	35	D2F001741	YA┼ŞAR Y─░─Ş─░T	38.93431200	28.28766200	3
19576	35	D28174045	YE─Ş─░N T─░CARET SANAY─░ VE T─░CARET LTD.┼ŞT─░.	39.03138350	28.41645360	3
19577	35	D2F133088	YUSUF KAYA	39.02619510	28.35845980	3
19578	35	D28164574	Y├£CEL BAYAT	38.75210900	28.46878000	3
19579	35	D2F001756	Y├£KSEL KURT	38.93341800	28.28762000	3
19580	35	D28037995	Y├£KSELLER PET.├£R.PAZ.HAR.OTO KOM.TAR.├£R.TEKS.SAN.VE T─░C.LTD.┼ŞT─░.	38.95067700	28.51242200	3
19581	35	D2F037798	Y├£KSELLER PET.├£R.PAZ.HARF.OTO KOM.TAR.├£R.TEKS.SAN. VE T─░C.LTD.┼ŞT─░.	39.02719580	28.42773260	3
19582	35	D28195717	ZEKER─░YA UYSAL	38.74845590	28.40299640	3
19583	35	D28100362	ZEKER─░YA YILDIRIM	39.04470000	28.65387110	3
19584	34	D28169793	ABD─░O─ŞLU GRUP AKY. SAN. T─░C. LTD. ┼ŞT─░.	38.54428400	28.66239100	3
19585	34	D28215537	ABDULLAH B─░LMEZ	38.54586280	28.63031100	3
19586	34	D28166181	ADEM DO─ŞAN	38.53981700	28.64200000	3
19587	34	D28001117	ADEM KANYILMAZ	38.74566190	28.86861110	3
19588	34	D28240711	AHMET EK─░M	38.74267070	28.86773970	3
19589	34	D28001131	AHMET G├£LMEZ	38.74574360	28.86919410	3
19590	34	020028568	AHMET UYANIK	\N	\N	3
19591	34	D28002759	AKDO─ŞAN LTD.┼ŞT─░.	38.54930030	28.67509190	3
19592	34	D28001025	ALAETT─░N TOPCAN	38.54827720	28.64288950	3
19593	34	D28066022	AL─░ ARIK	38.54817250	28.64317550	3
19594	34	D28000640	AL─░ BODUR	38.74292650	28.86817320	3
19595	34	D28184735	AL─░ KOPARAN	\N	\N	3
19596	34	D28242903	AL─░ SARI	42.94838100	34.13287400	3
19597	34	D28092834	AL─░ ┼ŞENT├£RK	38.54573800	28.63000500	3
19598	34	D28200335	AR─░F ├ûZDEM─░R	38.54249930	28.61454940	3
19599	34	D28207428	ARZU TURATUTUK	38.54633730	28.64655340	3
19600	34	D28002817	AYDIN YILMAZ	38.54603090	28.67246450	3
19601	34	D28155578	AYDIN YILMAZ	38.54595800	28.66549500	3
19602	34	D28188126	AYKUT G├ûNDE├ç	38.55052830	28.65035400	3
19603	34	D28070404	AYSU GIDA SAN.T─░C.LTD.┼ŞT─░.	38.74179600	28.86256500	3
19604	34	D28177530	AY┼ŞE YAVUZ	38.76645240	28.72914000	3
19605	34	D28221216	BEK─░R BAYHAN	38.50972820	28.58168640	3
19606	34	D28002359	CEM─░L ├çAY	38.76639200	28.72906500	3
19607	34	D28239014	├çAL─░ KARAZ PETROL ─░N┼ŞAAT TUR─░ZM GIDA SAN. T─░C. LTD.┼ŞT─░.	38.56626050	28.58218780	3
19608	34	D28001070	├ç─░MENLER LTD.┼ŞT─░.	38.74566400	28.86884500	3
19609	34	D28089256	DAVUT ZEYBEK	38.54236420	28.63645390	3
19610	34	D28222474	DAVUT ZEYBEK 2	38.54884700	28.64246500	3
19611	34	D28002311	EL─░F YE┼Ş─░LKULA	38.74609000	28.86903000	3
19612	34	D28241310	ELVAN ERO─ŞLU	38.54668670	28.67153360	3
19613	34	D28080575	EMM─░O─ŞLU NAK.OTO.M├£T.VE ─░N┼Ş.MAL.YAK.GIDA DAY.T├£K.MAL. A┼Ş.	38.74292970	28.86741180	3
19614	34	D28218841	ENG─░N CANSEVEN	38.54119240	28.64665030	3
19615	34	D28216838	ERCAN GACAR	38.53930050	28.64619000	3
19616	34	D28001863	ERDAL YILDIZ	38.74602100	28.86899800	3
19617	34	D28001668	ERG├£N ┼ŞAH─░N	38.74117950	28.86090510	3
19618	34	D28059089	ERHAN S├£NB├£L	38.71303880	28.61959040	3
19619	34	D28001150	ERKAN ERCAN	38.74278860	28.86501190	3
19620	34	D28003088	ERKAN ├ûKS├£Z	38.54662360	28.64550570	3
19621	34	D28054136	EROL YILMAZ	38.54315500	28.65443300	3
19622	34	D28068350	ERTAN KAHRAMAN	38.74184200	28.86358600	3
19623	34	D28221215	ETHEM KAYRAK├çI	38.54317600	28.64426800	3
19624	34	D28185138	FAD─░ME KILI├ç	38.74083900	28.85951100	3
19625	34	D28150685	FARUK EMRAH MALKO├ç	38.54498680	28.63469350	3
19626	34	D28211647	FATMA KARABA┼Ş	38.54552930	28.64489220	3
19627	34	D28232323	FATMA KARAKU┼Ş	38.54302640	28.65508150	3
19628	34	D28208951	FERHAT KARAG├ûZ	38.54618470	28.64703740	3
19629	34	D28002320	FUAT DABAN	38.54716650	28.63926300	3
19630	34	D28185163	G├£LTEN ├çAKMAK	38.53805730	28.63996760	3
19631	34	D28003037	G├£L├£MSER EROL	38.74308190	28.86905710	3
19632	34	D28241479	G├£NDO─ŞDU ULA┼ŞIM H─░ZMETLER─░ GIDA SAN.T─░C.LTD.┼ŞT─░.	38.56426630	28.58992600	3
19633	34	D28174523	G├£ZELSOY PETROL TA┼ŞIMACILIK LTD.┼ŞT─░.	38.56739900	28.57222100	3
19634	34	D28220700	HAL─░L AKYILDIZ	38.83408260	29.02823200	3
19635	34	D28001064	HAL─░L ALKAN	38.74525900	28.86931700	3
19636	34	D28002562	HAL─░L G├ûN├£LAL	38.54622200	28.64556000	3
19637	34	D28001134	HAL─░L KIRLI	38.54546440	28.64491300	3
19638	34	D28002587	HAL─░T G├£LGEN	38.54551700	28.64527190	3
19639	34	D28002372	HAMZA ARI	38.78901900	28.73133000	3
19640	34	D28225201	HAMZA SERT	38.54358400	28.66018700	3
19641	34	D28042656	HAN─░FE A├çIKG├ûZ	38.74600150	28.86898990	3
19642	34	D28041081	HASAN SOYBA┼Ş	38.54378300	28.65508600	3
19643	34	D28111749	HAT─░CE KARAK├£R	38.54096840	28.65027320	3
19644	34	D28224383	HAT─░CE S├ûNMEZ	38.54743000	28.64496000	3
19645	34	D28097218	H─░MMET AYTAN	38.55153280	28.65534710	3
19646	34	D28204605	H─░MMET KAHVEC─░	38.74268210	28.87395030	3
19647	34	D28068349	H├£LYA D─░N├çER	38.54565830	28.64626250	3
19648	34	020028547	H├£LYA G├£LMEZ	38.54453410	28.64472830	3
19649	34	D28047564	H├£SEY─░N CAN KALE	38.54503210	28.63206320	3
19650	34	D28002111	H├£SEY─░N KARAG├ûZ	38.74204200	28.86677100	3
19651	34	D28219618	H├£SEY─░N LEBLEB─░C─░	38.54628560	28.64549120	3
19652	34	D28239112	─░BRAH─░M G├£NG├ûR	38.57575050	28.57183730	3
19653	34	D28196856	─░BRAH─░M ─░M─░R	38.54544060	28.64517150	3
19654	34	D28148663	─░BRAH─░M KAYA	38.54624000	28.64249320	3
19655	34	D28010073	─░LKER G├ûNDE├ç	38.55069400	28.64399400	3
19656	34	D28001056	─░MAMO─ŞLU KOLLEKT─░F ┼Ş─░RKET─░ NAF─░Z EKREM ─░MAMO─ŞLU VE ORTA─ŞI	38.55722400	28.60801900	3
19657	34	D28000995	─░MDAT ├çAKAR	38.54301510	28.65480650	3
19658	34	D28001671	─░MDAT EK─░M	38.74571100	28.86915200	3
19659	34	D28083749	─░SA KARATA┼Ş	38.78828730	28.85201900	3
19660	34	020028558	─░SA MERT VE CENG─░Z MERT AD─░ ORT.	38.54072590	28.64050640	3
19661	34	D28002490	─░SMA─░L BA┼ŞY─░─Ş─░T	38.83384760	29.02828920	3
19662	34	D28115836	─░SMA─░L ├çAYIR	38.84833720	28.89485800	3
19663	34	D28232926	KAD─░R AKKAYA	38.54677540	28.64656820	3
19664	34	D28002284	KAM─░L AKARSU	38.74694400	28.86885000	3
19665	34	D28002484	KAM─░L KOCADEM─░R	38.74592810	28.86921320	3
19666	34	D28191241	KASAP PETROL LTD.STI.	38.74203990	28.87138080	3
19667	34	D28221484	KAYA MOTORLU ARA├ç ─░N┼Ş.DAY.T├£K.MAL.PET.├£R.TEKST.GIDA MOB.SAN .T─░C.A┼Ş KU	38.54019200	28.64022600	3
19668	34	D28232542	KAZIM KAPTAN	38.56480700	28.72527700	3
19669	34	D28110104	KEMAL HARMANDALI	38.54846600	28.65343000	3
19670	34	D28002109	MAHMUT AK├ç─░N	38.54277300	28.65572700	3
19671	34	D28112964	MAHMUT G├ûKDERE	38.54523550	28.63128650	3
19672	34	D28094161	MA┼Ş─░DE Y─░─Ş─░T	38.74387700	28.86728800	3
19673	34	D28002533	MEHMET AKME┼ŞE	38.54421960	28.62406570	3
19674	34	D28200088	MEHMET ├ç├£R├£K	38.54640450	28.65229320	3
19675	34	D28001640	MEHMET KARABULUT	38.83496070	28.80083870	3
19676	34	D28067031	MEHMET ├ûZDEM─░R	38.54294100	28.64500800	3
19677	34	D28009554	MEHR─░BAN AYTAN	38.54292200	28.63817000	3
19678	34	D28215667	MERYEM DABAN	38.74317310	28.86969960	3
19679	34	D28189710	MESUT K├ûSE	38.74284590	28.87262380	3
19680	34	D28185645	M─░SAR ├ûZ├çAYIR 2	38.74117100	28.86137400	3
19681	34	D28106805	MOY OTOMOT─░V SAN.VE T─░C. LTD.┼ŞT─░	38.54526860	28.64671990	3
19682	34	D28232448	MUHAMMED EM─░N S├£MEN	38.54226510	28.63642930	3
19683	34	D28099299	MUHAMMET ERDO─ŞAN VE EM─░NE ERDO─ŞAN AD─░ ORTAKLI─Ş	38.54658440	28.64748510	3
19684	34	D28221941	MUSTAFA ├çEL─░K	38.79474670	28.85361770	3
19685	34	D28238228	MUSTAFA DEM─░RD├û─ŞEN	38.54516280	28.64575390	3
19686	34	D28204746	MUSTAFA KIZILDA┼Ş	38.73994970	29.00962640	3
19687	34	D28001933	MUSTAFA YILMAZ	38.54913440	28.64521910	3
19688	34	D28143006	MUZAFFER BA┼ŞT├£RK	38.54157430	28.64631730	3
19689	34	D28008937	NAF─░Z ├çET─░NTA┼Ş	38.89090700	28.82744900	3
19690	34	D28230375	NA─░LE ├çA─ŞILCI	38.55258700	28.64439670	3
19691	34	D28087522	NECAT─░ CEYLAN	38.74265920	28.86906530	3
19692	34	D28209233	NECMETT─░N HELVA	38.71319710	28.62009050	3
19693	34	D28232236	NEJDET DO─ŞAN 2	38.53929170	28.64056050	3
19694	34	D28192765	N─░L─░FER KARA ARKAN	38.54557650	28.64633160	3
19695	34	D28179194	NURULLAH KUTLUAY	38.53986100	28.64432400	3
19696	34	D28110761	OZAN BEDEZ	38.54764660	28.64324870	3
19697	34	D28242588	OZAN ├ûZ├çAYIR	38.74397360	28.86718720	3
19698	34	D28216369	├ûZG├£R ARIKAN	38.79972980	28.83319840	3
19699	34	D28205879	├ûZG├£R PETROL-├ûZ-G├£R AKARYAKIT TARIM TUR─░ZM ─░N┼ŞAAT TAAHH├£T GIDA NAKL─░YE	38.71855140	28.85060510	3
19700	34	D28001029	├ûZYAMAN LTD.┼ŞT─░.	38.54368200	28.64063400	3
19701	34	D28118139	RAMAZAN AKME┼ŞE	38.63105420	28.58902240	3
19702	34	D28237563	RAMAZAN KARAKOYUN	38.54494350	28.63871410	3
19703	34	D28110075	RAMAZAN KOVA	38.74310100	28.86872600	3
19704	34	D28181458	RAZ─░YE BEDEZ-SE├ç MARKET	38.54310990	28.64475130	3
19705	34	D28217156	REF─░KA DEM─░RC─░	38.57850600	28.57319700	3
19706	34	D28002244	RESUL G├£├çL├£	38.46626100	28.73841400	3
19707	34	D28001012	R├£STEM B├ûREK├ç─░	38.54606900	28.64630950	3
19708	34	D28002488	SAB─░T Y├ûR├£K	38.83402570	29.02682350	3
19709	34	D28238113	SA─░T KAAN ├çAPAR	38.54358380	28.64416860	3
19710	34	D28209504	SELMAR GROOS-SELMAR GIDA SANAY─░ VE LTD.┼ŞT─░.	38.74296640	28.86832560	3
19711	34	D28169240	SELTA┼Ş AKARYAKIT A.┼Ş	38.74306530	28.86968250	3
19712	34	D28238119	SERTAN BA┼ŞT├£RK	38.48132990	28.80044390	3
19713	34	020028565	STR A.┼Ş.	38.57685810	28.75274700	3
19714	34	D28143673	SURA ALISVERIS MERKEZI SAN.TIC.LTD.STI	38.54194000	28.64301940	3
19715	34	D28208593	S├£LEYMAN KAHRAMAN	38.54322130	28.63848610	3
19716	34	D28053561	┼ŞABAN KARADA┼Ş	38.54908010	28.67682780	3
19717	34	D28087526	┼ŞABAN KARADA┼Ş	38.75339700	28.86578300	3
19718	34	D28166471	┼ŞEF─░KA AKDEM─░R	38.54216060	28.63075380	3
19719	34	D28000858	┼ŞER─░F ERD─░L	38.54599650	28.64591100	3
19720	34	D28216549	┼ŞER─░F SEYLAN	38.54751800	28.64746900	3
19721	34	D28085400	┼ŞER─░FE AYG├£N	38.54776990	28.65528640	3
19722	34	D28214467	┼ŞEYMA ESMA ┼ŞANLI	38.55675100	28.63869200	3
19723	34	D28221939	┼Ş├£KR─░YE ERYILDIRIM	38.74456200	28.86689900	3
19724	34	D28000722	TAHS─░N ├£NL├£	38.89507820	28.86751570	3
19725	34	D28193910	TEVF─░K DOLMA	38.54131100	28.64249810	3
19726	34	D28236573	TEVF─░K DOLMA 2	38.54263090	28.63747120	3
19727	34	D28122931	TOME PETROL ─░N┼Ş.HAYVANCILIK YEM KUYUMCULUK GIDA TURUZM TA┼ŞIMACILIK SAN	38.54108260	28.63875780	3
19728	34	D28074596	TUBA B├ûREK├ç─░	38.54733870	28.64230320	3
19729	34	D28002967	ULA┼Ş ┼Ş─░M┼ŞEK	38.74191060	28.87911160	3
19730	34	D28207455	UMMAHAN YILMAZ	38.53952380	28.64804650	3
19731	34	D28219887	VEL─░ KARAKO├ç	38.85207670	29.00012560	3
19732	34	D28233300	YAS─░N ├çORUK	38.54840040	28.64283090	3
19733	34	D28002637	YA┼ŞAR KARAKO├ç	38.85236400	28.99995300	3
19734	34	D28002391	YA┼ŞAR KARATA┼Ş	38.89295200	28.91963600	3
19735	34	D28070896	YET─░┼Ş D├ûNMEZ	38.57727940	28.70065310	3
19736	34	D28144273	YILMAZ ─░┼ŞLEK	38.74282980	28.86824100	3
19737	34	D28157192	YILMAZLAR RME ─░N┼Ş.MAL.TAS.TUR.OT.PET.GIDA.K├ûM.SAN.T─░C.LTD ┼ŞT─░	38.59218190	28.81257250	3
19738	34	D28002384	YUNUS ERT├£RK	38.49278100	28.71148800	3
19739	34	D28063746	YUSUF ULUSOY	38.54390520	28.64474330	3
19740	34	D28170911	ZEK─░ Y├ûR├£K	38.83372840	29.02690690	3
19741	34	D28116537	ZEK─░YE KAHRAMAN	38.89177470	28.91247370	3
19742	34	D28106093	ZEK─░YE ├ûZDEM─░R	38.54552240	28.64635970	3
19743	34	D28179842	Z─░YA G├£RB├£Z	38.54775020	28.64341890	3
19744	34	D28116284	Z├£MR├£T ANKA AKARYAKIT PET.├£RN.SAN.TIC.LTD.STI	38.56785900	28.57261500	3
19745	28	D28071930	ADNAN TOGAY	38.48524600	28.13736800	3
19746	28	D28002937	AHMET AKKUZU	38.48308410	28.14012440	3
19747	28	D28187157	AHMET ├ûZG├£R	38.48739870	28.13494530	3
19748	28	D28208089	AHMET ├ûZG├£R	38.48690810	28.13429830	3
19749	28	020027939	AHMET ┼ŞAK─░R Y─░─Ş─░T	38.48114400	28.13446400	3
19750	28	D28000051	AHMET TAYFUR	38.48206850	28.13181730	3
19751	28	D28213282	AL─░ ├çOBAN	38.47860690	28.14016600	3
19752	28	D28002988	AL─░ G├ûKKAYA	38.47679620	28.13334990	3
19753	28	D28184335	AL─░ SERDAR KAPAN	38.47730600	28.13112080	3
19754	28	D28115286	AL─░ S├ûYLEMEZ	38.48737400	28.13998800	3
19755	28	D28003064	AT─░LLA ┼ŞAH─░N	38.47983200	28.13596200	3
19756	28	020028846	AY┼ŞE G├£LMEZ	38.48504500	28.13725600	3
19757	28	D28183618	B─░LG─░┼ŞAH G├£LTEK─░N	38.48688400	28.14231500	3
19758	28	D28213979	BURAK ├ûZDA┼Ş-SE├ç MARKET	38.48407190	28.13287950	3
19759	28	D28001697	B├£LENT G├£LDER	38.47988020	28.12918720	3
19760	28	020028888	CANAN DO─ŞRUYOL	38.48530030	28.13897380	3
19761	28	D28002366	CEMAL ORAN	38.48540200	28.13437000	3
19762	28	D28000261	CEMG─░L U├çAN	38.48021300	28.12742700	3
19763	28	020028809	CEM─░L KAYGISIZ	38.48661200	28.13855900	3
19764	28	D28082108	CEVR─░YE DANACI	38.48546000	28.14027300	3
19765	28	D28000025	C─░HAN KES─░C─░	38.48128600	28.12920500	3
19766	28	D28223355	DEFNE BOZKURT	38.48551100	28.13081000	3
19767	28	D28001322	DEREK├ûY PAZARI LTD. ┼ŞT─░.	38.48643580	28.13685840	3
19768	28	D28000081	DURMU┼Ş KANAT	38.48285370	28.14308670	3
19769	28	D28238301	EKREM AYG├£N	38.48323470	28.13755020	3
19770	28	D28132270	ELVAN KAYA	38.47846700	28.14224800	3
19771	28	D28020166	EM─░NE G├£N	38.48293790	28.14185020	3
19772	28	D28155718	ERD─░N├ç ─░┼Ş─░TMEZ	38.48123310	28.13189790	3
19773	28	D28108055	ESMA SARIKAYA	38.48620000	28.13644600	3
19774	28	D28242525	ESRA TANRIKULU	38.48299810	28.14167830	3
19775	28	D28001347	F─░KRET ALATLI	38.48714500	28.13821800	3
19776	28	020027968	F─░L─░Z KARASU	38.48166600	28.13277090	3
19777	28	D28099829	F─░L─░Z ZEYBEK	38.47962270	28.13700740	3
19778	28	D28201984	GARB─░ AYG├£N	38.48405410	28.13459180	3
19779	28	D28239390	GAR-SAL─░HL─░ GIDA OTOMOT─░V ─░N┼ŞAAT SAN.T─░C.LTD.┼ŞT─░.	38.48293370	28.13260410	3
19780	28	D28049664	G─░RG─░NLER LTD. ┼ŞT─░. - KOCA├çE┼ŞME ┼ŞUBE	38.48282600	28.14359400	3
19781	28	020027983	G─░RG─░NLER LTD. ┼ŞT─░. - SA─ŞLIK ┼ŞUBE	38.47953000	28.13867500	3
19782	28	D28090134	G─░RG─░NLER LTD.┼ŞT─░.-├çAR┼ŞI ┼ŞUBE	38.48623700	28.13530300	3
19783	28	D28124439	G─░RG─░NLER LTD.┼ŞT─░.-┼ŞEH─░TLER ┼ŞUBE	38.48084200	28.12575900	3
19784	28	D28222562	G├ûKAN YERTEP	38.47700000	28.13727600	3
19785	28	D28193848	G├ûN├£L KARACA	38.47817590	28.12879370	3
19786	28	D28228171	G├£LCAN AKSOY	38.48564310	28.14217320	3
19787	28	D28222672	G├£LER CENG─░Z	38.47848600	28.13690300	3
19788	28	D28001559	G├£NAY BECERO─ŞLU	38.48541200	28.14161800	3
19789	28	D28000156	HAL─░L ─░BRAH─░M KARAKAYA	38.47800210	28.12206470	3
19790	28	D28117115	HAL─░L NARMAN	38.48484700	28.13608800	3
19791	28	D28189118	HAL─░L Y├£KSEL	38.47718900	28.13896500	3
19792	28	D28211578	HAT─░CE SERHAN ├ûZAKCA	38.48123300	28.13423000	3
19793	28	D28000210	H├£SEY─░N EREL	38.48297600	28.13908600	3
19794	28	D28166540	─░BRAH─░M ├ûNEL	38.48613450	28.14104280	3
19795	28	D28093532	─░LKNUR TOKER	38.48362070	28.13322270	3
19796	28	D28001683	─░MDAT SAPMAZ	38.48098010	28.13467810	3
19797	28	D28217376	─░MREN TEKER	38.48363860	28.13461900	3
19798	28	D28000037	─░SMA─░L DEM─░RB─░LEK	38.48351910	28.13561420	3
19799	28	D28001730	─░SMA─░L ZEYBEK	38.48231700	28.15050000	3
19800	28	D28002792	KAZIM G├ûDE	38.48392300	28.14452600	3
19801	28	D28108125	KIYMET DEM─░R	38.48653100	28.14001350	3
19802	28	D28158288	L├£TF─░ ERDO─ŞAN	38.48115840	28.14432100	3
19803	28	D28219022	MAHZEN CENTER ALKOLL├£ ALKOLS├£Z ─░├çECEKLER OTO. SAN.T─░C.LTD.┼ŞT─░.	38.48774860	28.14165930	3
19804	28	D28149525	MEHMET AL─░ D├ûNMEZ	38.48337570	28.13755140	3
19805	28	D28147199	MEHMET AL─░ Y├£KSEL	38.48114750	28.12503260	3
19806	28	D28239136	MEHMET C─░HAN	38.48235620	28.13927650	3
19807	28	D28073930	MEHMET FA─░K ├ûZDEM─░R	38.48327200	28.13292900	3
19808	28	020028022	MEHMET KAYA	38.48146100	28.14057800	3
19809	28	D28146073	MEHMET SEL─░M ┼Ş─░R─░N	38.47745010	28.13036890	3
19810	28	020028783	MEHMET SER─░N	38.48824450	28.14187000	3
19811	28	D28213535	MELTEM KUYUCU	38.47560260	28.14100980	3
19812	28	D28194461	MERTCAN TURAN	38.48202240	28.13235970	3
19813	28	D28201186	MURAT RAHM─░ AKSOY	38.48724600	28.14154590	3
19814	28	D28240240	MURAT SEZER	38.47956060	28.12095080	3
19815	28	D28000247	MUSTAFA ERHAN TURHAN	38.47486800	28.13990500	3
19816	28	D28124315	MUSTAFA KORKMAZ	38.48486770	28.13503330	3
19817	28	D28162209	M├£RSEL ┼ŞAH─░NCAN	38.47861690	28.12485370	3
19818	28	D28144925	NAZM─░ TOLGA YILDIZ	38.48460350	28.13659620	3
19819	28	D28174604	N─░LG├£N KU┼ŞCU	38.47632070	28.13517090	3
19820	28	D28002292	NURCAN G├£LDEN	38.47695600	28.14222790	3
19821	28	D28067334	NURTEN PEKER	38.47907900	28.14073800	3
19822	28	D28188394	ONUR AKDEN─░Z	38.47578310	28.13751090	3
19823	28	D28210598	ONUR ERS├ûZ	38.47815940	28.14369400	3
19824	28	D28166586	ORHAN ├ûNEL	38.48387570	28.13523050	3
19825	28	D28151137	├ûMER ┼ŞAH─░N	38.47897600	28.13045900	3
19826	28	D28001338	├ûZCAN G├ûK├çEN	38.48743400	28.14010600	3
19827	28	D28156601	├ûZGE ├ç─░├çEK	38.48395670	28.13910860	3
19828	28	D28217007	RAB─░A KARATEK─░N	38.47649440	28.14387390	3
19829	28	D28001298	RE┼ŞAT G├£R	38.48752300	28.14048100	3
19830	28	D28157195	R├£STEM AKG├£ND├£Z	38.48161800	28.13938600	3
19831	28	D28242665	SAL─░HL─░ G├û├çMENO─ŞLU GIDA SANAY─░ T─░C.LTD.┼ŞT─░.	38.47826920	28.12006860	3
19832	28	D28239908	SAN─░YE KILIN├çASLAN	38.47752320	28.13442650	3
19833	28	D28054118	SEMRA GEZER	38.47955500	28.13397600	3
19834	28	D28200944	SEVDA SARP	38.48699460	28.13814950	3
19835	28	020028839	SEVG─░ YOLU ┼ŞANS OYUNLARI GIDA SANAY─░. VE T─░C. LTD. ┼ŞT─░.	38.48522300	28.13692300	3
19836	28	D28002663	SEYFETT─░N TOKER	38.47851970	28.12382930	3
19837	28	D28142015	SEYF─░ Z├£LYEZEN KAYIHAN	38.48236600	28.14438900	3
19838	28	D28002259	SEZA─░ TAYLAN	38.48428690	28.13513490	3
19839	28	020028385	SEZG─░N ORTA├ç	38.48193670	28.13922710	3
19840	28	020028928	SULTAN ERKISA	38.48759200	28.13521700	3
19841	28	D28218714	SULTAN SEYREK	38.48529350	28.13367610	3
19842	28	D28138265	┼ŞEF─░KA TAK	38.48583500	28.13541300	3
19843	28	D28001427	┼ŞENOL UYSAL	38.48766400	28.13957800	3
19844	28	D28061485	┼Ş├£KRAN CANDAN	38.48546400	28.13787400	3
19845	28	D28105559	TUBA DEM─░R	38.48302100	28.14215050	3
19846	28	D28003163	TU─ŞBA TUNAY	38.48603600	28.13675500	3
19847	28	D28040515	TU─ŞRUL TARIM VE PETROL ├£R├£NLER─░ T─░C.VE SAN.A.┼Ş ZAFER MAH	38.48697200	28.13182300	3
19848	28	D28232756	TUNCAY ─░MRAL BEKSEK	38.48472390	28.13483390	3
19849	28	D28229587	U─ŞUR G─░RG─░N	38.47813720	28.11872790	3
19850	28	D28223733	VEL─░ ANIL KESK─░N	38.48238500	28.14639610	3
19851	28	D28238848	YA─ŞMUR G├£├çL├£	38.48013220	28.12721440	3
19852	28	020028874	YAKUP TOPTAMI┼Ş	38.48572100	28.13821300	3
19853	28	D28181105	YA┼ŞAR AY├ç─░├çEK	38.47599400	28.13997300	3
19854	28	D28127525	YA┼ŞAR DEM─░RC─░	38.48242470	28.14810890	3
19855	28	D28000108	YILDIZ KAYGISIZ	38.48398300	28.13272500	3
19856	28	D28219735	YUSUF G├£REV─░N	38.48656970	28.13329680	3
19857	28	D28001275	Z─░YA YILANCI	38.48578930	28.13711290	3
19858	56	D28192507	AD─░LE G├£NAL	38.48785100	28.14619500	3
19859	56	D28222248	AHMET G├£RLEK	38.48046900	28.15930100	3
19860	56	D28114157	AHMET S├£MER	38.47024960	28.15964240	3
19861	56	D28150460	AL─░ F─░DAN	38.48434940	28.15093520	3
19862	56	D28167905	AL─░SA NAKL─░YE GIDA YEMEK├ç─░L─░K SAN.T─░C.LTD ┼ŞT─░  AVAR	38.48139000	28.16092800	3
19863	56	D28176477	AL─░SA NAKL─░YE GIDA YEMEK├ç─░L─░K SAN.T─░C.LTD ┼ŞT─░. -2 AKSOY	38.47668400	28.15031300	3
19864	56	D28220179	AL─░SA NAKL─░YE GIDA YEMEK├ç─░L─░K SAN.T─░C.LTD.┼ŞT─░. ├çINARLI ┼ŞUB.	38.48201340	28.15195210	3
19865	56	D28229472	ASLI A┼ŞKIN	38.48548700	28.16109200	3
19866	56	D28210930	ASLI NUR ├ûZDEM─░R	38.47580850	28.16352770	3
19867	56	D28189501	AYCAN Y─░─Ş─░T	38.48163600	28.15245400	3
19868	56	D28187454	BAHADIR ULUDA─Ş	38.48121210	28.15624150	3
19869	56	D28190339	BERAY G├£├çL├£	38.48529300	28.16108900	3
19870	56	D28082552	B├£LENT ECEV─░T ULA┼Ş	38.47748500	28.14661600	3
19871	56	D28213305	B├£LENT KAFALI	38.48783430	28.14520300	3
19872	56	D28233479	CAN BULUT AKDA─Ş	38.48050940	28.14964430	3
19873	56	D28220386	CANSI ├ûZEL	38.48159540	28.16609660	3
19874	56	D28225512	DEN─░Z G├ûKMEN	38.47963700	28.16282500	3
19875	56	D28135557	DEN─░Z T├£RKYILMAZ	38.47630800	28.15667400	3
19876	56	D28229083	DERYA CANDEM─░R	38.48275720	28.16075510	3
19877	56	D28240515	EFKAN AVCI 2	38.48423610	28.16101930	3
19878	56	D28056394	EFKAR ┼ŞEN	38.48312400	28.14796100	3
19879	56	D28176986	ELHAM SARIKAYA	38.47674210	28.15361820	3
19880	56	D28102513	EMEL ├ûZKUL	38.47997500	28.14945800	3
19881	56	D28209234	EM─░N AKDEN─░Z	38.47235330	28.15502400	3
19882	56	D28241401	EM─░N EM─░R	38.48483940	28.16114850	3
19883	56	D28002108	ENDER ORAN	38.47890000	28.14930000	3
19884	56	D28223917	ENVER ELMAS	38.48413100	28.15832900	3
19885	56	D28229779	ERHAN C─░HAN	38.48092800	28.15780400	3
19886	56	D28173695	EROL AKYOL	38.48776030	28.14924000	3
19887	56	D28224956	EROL AYDO─ŞDU	38.47756530	28.16121780	3
19888	56	D28199553	E┼ŞREF AK─░┼Ş	38.48777890	28.14793070	3
19889	56	D28232389	FAD─░ME BAYINDIR	38.48158960	28.15040740	3
19890	56	D28185235	FAHRETT─░N S├£NER	38.48384180	28.16390460	3
19891	56	D28166704	FAHR─░ AKYILDIZ	38.48995800	28.16207000	3
19892	56	D28191460	FAT─░H DO─ŞAN	38.47604910	28.16042050	3
19893	56	D28212449	FATMA ARI	38.48879390	28.15700280	3
19894	56	D28001483	FATMA HAST├£RK	38.47601040	28.16055100	3
19895	56	D28060674	G─░RG─░NLER LTD ┼ŞT─░. - KURTULU┼Ş ┼ŞUBE	38.47639100	28.15555200	3
19896	56	D28080182	G─░RG─░NLER LTD. ┼ŞT─░. - AKSOY ┼ŞUBE	38.47675800	28.14859200	3
19897	56	D28050816	G─░RG─░NLER LTD. ┼ŞT─░. - AVAR ┼ŞUBE	38.48352390	28.16067890	3
19898	56	D28018772	G├ûKHAN MEN─Ş─░	38.47595500	28.16155700	3
19899	56	D28158383	G├£LAY KAHYA	38.48700300	28.15719700	3
19900	56	D28201380	HACER ERSOY	38.48507310	28.14959360	3
19901	56	D28165503	HAF─░ZE DEM─░RPOLAT	38.47720800	28.16147000	3
19902	56	D28218749	HAKAN KARDA┼Ş	38.48124720	28.15467910	3
19903	56	D28213114	HAL─░L EK─░NC─░	38.47215800	28.15954700	3
19904	56	D28025033	Halil Pekdemir-Manisa07-Salihli-2	38.48466400	28.15111100	3
19905	56	D28082658	Halil Pekdemir-Manisa08-Salihli-3	38.48022900	28.16159200	3
19906	56	D28153951	HAL─░ME HALE HALDEN	38.48143500	28.15394400	3
19907	56	D28002969	HAM─░ HAKAN YILDIZ	38.48191200	28.15165500	3
19908	56	D28227272	HASAN AKSU 2	38.48152950	28.15312830	3
19909	56	D28123166	HASAN H├£SEY─░N BAYINDIR	38.48842390	28.16543570	3
19910	56	D28178177	HAVVA KARAMAN	38.48901500	28.15754200	3
19911	56	D28220751	H├£LYA AYDIN	38.47627610	28.15627420	3
19912	56	D28203534	H├£LYA Y├ûR├£KO─ŞLU	38.48672080	28.16340110	3
19913	56	D28159949	H├£SEY─░N ALTINKESER	38.48749900	28.14977200	3
19914	56	D28001396	IRAZ ESENT├£RK	38.48910750	28.16419360	3
19915	56	D28001518	─░MDAT KARTAL	38.47819300	28.16155400	3
19916	56	D28074358	─░SLAM YILMAZ	38.48264500	28.15143900	3
19917	56	D28216501	KAD─░R DARICI	38.48341880	28.15515160	3
19918	56	D28141768	LETSMAR	38.47644260	28.15101970	3
19919	56	D28001401	M.EM─░N ┼ŞAH─░N	38.48575200	28.15292200	3
19920	56	D28217753	MEHMET AKG├£N	38.48222320	28.15497430	3
19921	56	D28105190	MEHMET AL─░ DEM─░R	38.48557600	28.15105600	3
19922	56	D28237732	MEHMET DEN─░Z	38.48275160	28.15052420	3
19923	56	D28233695	MEHMET ELBEY	38.48839590	28.14236870	3
19924	56	D28186348	MERVE K├ûKL├£	38.47290440	28.15425610	3
19925	56	D28235204	M─░KA─░L YOLCU	38.48469500	28.15961700	3
19926	56	D28241402	MUHAMMED MUSTAFA O─ŞUZ	38.48179470	28.16098140	3
19927	56	D28067363	MURAT BATUR	38.47943390	28.16173040	3
19928	56	D28127777	MURAT T─░R─░L	38.47643080	28.15526650	3
19929	56	D28235815	MURAT ULUSU	38.48847450	28.15633710	3
19930	56	D28187937	MUSTAFA KARAKAYA	38.47265100	28.15448700	3
19931	56	D28002911	NAD─░RE G├£LTEK─░N	38.48506600	28.14689400	3
19932	56	D28223757	NA─░M BEDEZ	38.48796330	28.15493890	3
19933	56	D28040294	NALAN B─░RCAN	38.48510700	28.15119000	3
19934	56	D28148398	NECMETT─░N TANI┼Ş	38.47594710	28.16133080	3
19935	56	D28002339	NESL─░HAN ├ûZMEN	38.48461700	28.15851600	3
19936	56	D28000627	NESL─░HAN Y├£KSEL	38.48097700	28.15711200	3
19937	56	D28215999	N─░HAT TURAN	38.48870510	28.15717550	3
19938	56	D28237793	NURDAN KARAMAN-SE├ç MARKET	38.47234270	28.15833620	3
19939	56	D28177874	NURG├£L AYDEM─░R	38.48029400	28.15913700	3
19940	56	D28002416	NURHAN ┼ŞANAL	38.48789430	28.15238300	3
19941	56	D28236906	OKTAY DALMAZ	38.48319890	28.16672230	3
19942	56	D28095014	OSMAN G├ûL	38.47607300	28.15549300	3
19943	56	D28231343	├ûNDER BAYSAL	38.47622400	28.15873390	3
19944	56	D28092107	├ûZCAN ├çET─░N	38.48387380	28.15080510	3
19945	56	D28232182	├ûZLEM ├ûZDEM─░R	38.47601070	28.16048080	3
19946	56	D28196625	├ûZLEM TEK─░NER	38.48475000	28.16728050	3
19947	56	D28050857	RAFET CESUR	38.47621300	28.15788300	3
19948	56	D28175629	RIFAT SAPMAZ	38.47477250	28.15911230	3
19949	56	D28053146	RUK─░YE G├£LER	38.48606100	28.15782700	3
19950	56	D28233157	SAL─░H ├ûN├£RME	38.48469830	28.15530410	3
19951	56	D28110367	SAL─░HL─░ SALMAR MARKET GIDA INSAAT SANAYI VE TICARET LIMITED SIRKETI -	38.48774060	28.14884040	3
19952	56	D28001767	SAL─░HL─░ T T─░P─░ KAPALI VE A├çIK CEZA ─░NFAZ KURUMU ─░┼Ş YUR. M├£D.	38.50611200	28.24939600	3
19953	56	D28220144	SEHER B─░RCAN	38.48434360	28.16062290	3
19954	56	D28239684	┼ŞABAN UYGUN	38.48153990	28.16457610	3
19955	56	D28201589	┼ŞENAY KO├çY─░─Ş─░T	38.48147500	28.15015600	3
19956	56	D28210929	┼ŞENOL D─░N├çER	38.47710230	28.15540390	3
19957	56	D28205085	TAHS─░N ├çET─░N	38.48060300	28.16140300	3
19958	56	D28001419	TAHS─░N UYGUN	38.47444680	28.15770370	3
19959	56	D28207299	TARIK AKTA┼Ş	38.48547700	28.16126800	3
19960	56	D28139221	TARIK YILDIRIM	38.48145650	28.15384260	3
19961	56	D28143314	TAYFUN KARA	38.48809980	28.15106960	3
19962	56	D28219265	U─ŞUR AK├çA	38.47951520	28.14915930	3
19963	56	D28231481	UMUT KARAMAN	38.48658730	28.15146640	3
19964	56	D28241227	UMUT TEKTA┼Ş	38.48759400	28.14408720	3
19965	56	D28069681	├£LK├£ KALAYCI	38.48784500	28.14416000	3
19966	56	D28185683	├£MRA G├£RLER	38.48056100	28.14736600	3
19967	56	D28149087	VEYSEL G├£NE┼Ş	38.48052900	28.16489100	3
19968	56	D28197309	YA─ŞMUR CEREN KACAR	38.48708550	28.14767010	3
19969	56	D28149781	YASEM─░N ESK─░	38.48941600	28.14423960	3
19970	56	D28227157	YILMAZ ├ûNDER	38.48466900	28.16714400	3
19971	56	D28158386	YONUS CANSEVEN	38.47853000	28.14993770	3
19972	56	D28222172	YUNUS EMRE AKCA	38.48405960	28.16092940	3
19973	56	D28233637	YUNUS ├ûNAL	38.48792850	28.14481350	3
19974	56	D28209016	YUSUF DEN─░Z	38.48751700	28.14986600	3
19975	56	D28240707	ZEL─░HA ├ç─░L	38.48924230	28.16161790	3
19976	56	D28229126	ZEYNEP YALMA├ç ├çET─░N	38.48460600	28.15840200	3
19977	30	D28189815	7 KITA PETROLC├£L├£K-I┼ŞIK BENZ─░N ─░STASYONU NAKL─░YE GIDA ─░N┼ŞAAT OTOMOT─░V	38.50960800	28.29316000	3
19978	30	D28001868	AD─░LE CAN	38.68983600	28.14486600	3
19979	30	D28198301	AL─░ ├çEL─░K	38.49100300	28.13883000	3
19980	30	D28207298	AL─░ ├çEL─░K 2	38.49121540	28.13962230	3
19981	30	D28001161	AL─░ KARAMAN	38.52322460	28.45084080	3
19982	30	D28241662	AL─░ SEZEN	38.59005320	27.98848310	3
19983	30	D28230287	AL─░ YA┼ŞA	38.58029040	28.19160070	3
19984	30	D28217902	AL─░ YE┼Ş─░LTA┼Ş	38.52016600	28.19980250	3
19985	30	D28001937	AL─░CAN ASLAN	38.57909200	28.27074400	3
19986	30	020028061	ALKENT OTELC─░L─░K VE TURIZM T─░C.LTD.┼ŞT─░	38.49413000	28.17790300	3
19987	30	D28238127	ARZUNUR G├£LMEZ	38.53223020	28.04427830	3
19988	30	D28001456	AY┼ŞE KAHRAMAN	38.62067900	28.13942300	3
19989	30	D28001906	AYTEN KAPTI	38.52576900	28.11940800	3
19990	30	D28150269	BAHR─░ KAYMAK	38.60896440	28.22686120	3
19991	30	D28003015	BARI┼Ş AK├çA	38.51501580	28.24693320	3
19992	30	D28182471	BAYRAM YA┼ŞAR ALADA─Ş	38.52052430	28.20014040	3
19993	30	D28238342	BERAT AKTA┼Ş	38.57242620	28.28106200	3
19994	30	D28076205	B├£LENT DEM─░RTA┼Ş	38.50866100	28.31715500	3
19995	30	D28001046	B├£NYAM─░N KAYA	38.57332940	28.49112900	3
19996	30	D28059380	CAFER Y├£KSEL	38.52603900	28.12000200	3
19997	30	D28069128	CELALETT─░N TOKYAY	38.51582480	28.24788590	3
19998	30	D28001511	DAVUT MENG─░RKAON	38.51639910	28.24831740	3
19999	30	D28237255	DEVR─░M ERCAN	38.48759780	28.16887670	3
20000	30	D28238354	D─░LEK ├ç─░FT├ç─░	38.49201450	28.19827800	3
20001	30	D28108202	D├ûND├£ ERT├£RK	38.48736100	28.17023500	3
20002	30	D28140316	EFKAN AVCI	38.49062250	28.16294250	3
20003	30	D28074247	EL─░F MORBEL	38.51827690	28.19828390	3
20004	30	D28165608	EL─░F ├ûZ	38.51398320	28.23799930	3
20005	30	D28002840	EM─░NE PULAT	38.52099900	28.37162800	3
20006	30	D28054248	EM─░NE UYSAL	38.53312800	28.04572700	3
20007	30	D28155788	EMRAH AL─░ YILDIZ	38.48748700	28.13130300	3
20008	30	D28100364	ESRA N─░─ŞDEM CAN	38.51281000	28.18959100	3
20009	30	020028992	FAD─░ME AYDINTEK─░N	38.54882500	28.13672100	3
20010	30	D28241315	FAD─░ME KARCIO─ŞLU	38.57389540	28.48990090	3
20011	30	D28010998	FARUK DO─ŞAN	38.49470590	28.13536830	3
20012	30	D28071556	FER─░T BARCA	38.49402100	28.14092400	3
20013	30	D28216160	FER─░T BARCA 2	38.53997100	28.10112960	3
20014	30	D28112381	G├ûKHAN ├ûNDER	38.51634610	28.24916610	3
20015	30	D28002938	G├ûKHAN SEV─░N├ç	38.57311000	28.16304400	3
20016	30	D28001440	G├£LDEREN PET.LTD.┼ŞT─░.	38.52576400	28.12857100	3
20017	30	D28125783	G├£LS├£M YA┼ŞAR	38.68579200	28.19688320	3
20018	30	D28147200	G├£LVAN AYDINTEK─░N	38.54990120	28.13671500	3
20019	30	D28176941	G├£R ├çEL─░K AKARYAKIT SANAY─░ VE T─░CARET A.┼Ş	38.53572070	28.10305970	3
20020	30	D28235072	HAB─░P SEYHAN	38.52536500	28.13167200	3
20021	30	D28229119	HACI ├çOBAN	38.49539620	28.13349860	3
20022	30	D28188542	HAL─░L ─░BRAH─░M KARABACAK	38.58025400	28.19142120	3
20023	30	D28230332	HAL─░S ├ûVET	38.49677620	28.19149590	3
20024	30	D28002676	HAL─░T ├çEL─░K	38.73375900	28.19288800	3
20025	30	D28221817	HAMZAO─ŞLU PETROL ├£R├£NLER─░ SAN.T─░C.LTD.┼ŞT─░.	38.49054250	28.14484240	3
20026	30	D28214936	HANIM NERK─░Z	38.50953260	28.24913240	3
20027	30	D28226988	HAYDARO─ŞULLARI PETROL SAN. T─░C.LTD.┼ŞT─░. 2. ┼ŞUBE	38.52392800	28.38247500	3
20028	30	D28183627	HAYDARO─ŞULLARI PETROL SANAY─░ VE T─░CARET LTD.┼ŞT─░.	38.50901700	28.26086900	3
20029	30	D28050157	H─░MMET AYDO─ŞMU┼Ş	38.62129000	28.13937400	3
20030	30	D28240041	H├£LYA CENG─░Z	38.57347950	28.49034200	3
20031	30	D28120954	H├£LYA ├çOBAN	38.53437570	28.04727150	3
20032	30	D28077895	H├£SEY─░N ABAYLI	38.53450900	28.04693300	3
20033	30	D28000191	H├£SEY─░N KIZILCAN	38.56953100	28.27858900	3
20034	30	D28000176	─░BRAH─░M G├ûKSAL	38.57659660	28.26740680	3
20035	30	D28195441	─░BRAH─░M HAL─░L YILDIRIM	38.49614780	28.13641730	3
20036	30	D28002935	─░LHAN CENG─░Z	38.57263600	28.16299200	3
20037	30	D28170458	─░RFAN YILMAZ	38.54339770	28.11596410	3
20038	30	D28000165	─░SA AKDEM─░R	38.51599000	28.24892400	3
20039	30	D28229473	─░SA AYDO─ŞAN	38.69248050	28.28114010	3
20040	30	D28229224	─░SMA─░L ┼ŞEN	38.63461090	28.10360900	3
20041	30	D28091630	─░SMET BEK	38.49165900	28.16917200	3
20042	30	D28002326	KAD─░R DEN─░Z	38.49171600	28.14268800	3
20043	30	D28221486	KAYA MOTORLU ARA├ç ─░N┼Ş.DAY.T├£K.MAL.PET.├£R.SAN .T─░C.A┼Ş SAL─░HL─░	38.49022600	28.13516470	3
20044	30	D28209661	KE GRUP PETROL T─░CARET LTD.┼ŞT─░	38.50849600	28.25977400	3
20045	30	D28239762	KEMAL ├ûZGEN	38.57338210	28.49137520	3
20046	30	020028060	KUZUCUK PETROL VE TARIM ├£R├£NLER─░ T─░C.SAN.LTD.┼ŞT─░.	38.49376120	28.17785220	3
20047	30	D28185736	LEVENT HELVA	38.49035200	28.16922500	3
20048	30	D28001548	MAHMUT AZAK	38.62304200	28.13652100	3
20049	30	D28055267	MEHMET AL─░ KUZUCU	38.54824120	28.32481590	3
20050	30	D28100363	MEHMET CANBULAT	38.52089880	28.37129210	3
20051	30	D28001041	MEHMET DEM─░RC─░	38.57342460	28.49028610	3
20052	30	D28083990	MEHMET DO─ŞRU	38.69066680	28.28218080	3
20053	30	D28073788	MEHMET KURT	38.63312650	28.10182040	3
20054	30	D28230788	MEHMET ┼ŞER─░F ASLAN	38.57280290	28.28177690	3
20055	30	D28212766	MEMDUH CANG├£L	38.53023890	28.15586330	3
20056	30	D28219594	MERYEM KAYA	38.49429800	28.13334240	3
20057	30	D28071831	MUHAMMET T├£RK	38.52990100	28.15482200	3
20058	30	D28068690	MUHAMMET YELMAN	38.52119810	28.37130820	3
20059	30	D28043314	MURAT KARABIYIK	38.49356700	28.13878700	3
20060	30	D28027267	MUSA PALAS	38.60883200	28.22699900	3
20061	30	D28172316	MUSTAFA ERZ─░	38.49129700	28.14253400	3
20062	30	D28002255	MUSTAFA G├ûDE	38.57350020	28.49082810	3
20063	30	D28018066	MUSTAFA KEMAL ┼ŞENER	38.59030420	27.98893590	3
20064	30	D28223004	NAC─░ G├£RB├£Z	38.51603710	28.24932040	3
20065	30	D28204607	NASIF ARTA├ç	38.69104900	28.28139700	3
20066	30	D28182442	NERM─░N ├çEL─░K	38.62102400	28.13945600	3
20067	30	D28241260	N─░KOMEDYA AKARYAKIT SAN.T─░C.A.┼Ş	38.51429400	28.32749900	3
20068	30	D28053204	OG├£N ├ç─░FT├ç─░	38.49233300	28.13895930	3
20069	30	D28213981	O─ŞUZHAN DEM─░RKOL	38.57989610	28.27448440	3
20070	30	D28001871	├ûMER FARUK ├çER├ç─░	38.57302020	28.49146720	3
20071	30	D28216293	├ûZAY S├£MER	38.54680040	28.32256350	3
20072	30	D28238141	├ûZLEM VATANSEVER	38.51172490	28.25017860	3
20073	30	D28001864	RAMAZAN ARI	38.68983600	28.14486600	3
20074	30	D28229464	RAMAZAN ├çEK─░N	38.69200640	28.28139580	3
20075	30	D28001844	RA┼Ş─░T ├ûZDER	38.69227970	28.28111800	3
20076	30	D28001365	RUH─░ CAN AKARY. MOT. ARA├çL. NAK. LTD. ┼ŞT─░.	38.48993600	28.15140100	3
20077	30	D28002992	RUK─░YE NERK─░Z	38.52335390	28.45071570	3
20078	30	D28028432	SA─░P AKG├£N	38.72177200	28.13843100	3
20079	30	D28162968	SAL─░HL─░ PETROL ├£R├£NLER─░ GIDA ─░N┼ŞAAT NAKL─░YE SANAY─░ T─░CARET L─░TED ┼Ş─░RKE	38.49530010	28.18050350	3
20080	30	D28236293	SAL─░ME SABANCI	38.62091160	28.13931020	3
20081	30	D28183707	SAM─░ G├ûKCEN	38.57998810	28.19114800	3
20082	30	D28224118	SEDA G├ûK├çENO─ŞLU	38.51201580	28.24358750	3
20083	30	D28195382	SEDAT DURNA	38.69058050	28.09294080	3
20084	30	D28068225	SEHER SAVRIM	38.52203000	28.37461100	3
20085	30	D28001531	SEL├çUK KARAOLUK	38.49178600	28.14270200	3
20086	30	D28000196	SERDAR KARATA┼Ş	38.57814600	28.26967600	3
20087	30	D28027348	SEYFETT─░N OKTAR	38.51859800	28.19819700	3
20088	30	D28216941	SEZG─░N ACAR	38.57764630	28.26929780	3
20089	30	D28151138	S─░NAN TURAN	38.62119360	28.13961630	3
20090	30	D28235755	S├£LEYMAN B─░LG─░N	38.49052270	28.14848530	3
20091	30	D28227676	┼ŞAH─░ZER AKIN	38.48700580	28.12765270	3
20092	30	D28001515	┼ŞER─░F KARABO─ŞA	38.51548700	28.24830880	3
20093	30	D28216708	TAYFUN ├çOBAN	38.49712280	28.13462750	3
20094	30	D28001525	TU─ŞRUL TARIM VE PETROL ├£R├£NLER─░ T─░C.VE SAN.A.┼Ş  AKH─░SAR YOLU	38.52132800	28.13274700	3
20095	30	D28093408	TU─ŞRUL TARIM VE PETROL ├£R├£NLER─░ T─░C.VE SAN.A.┼Ş \tDURASILLI MAH	38.50892100	28.24098200	3
20096	30	D28002578	TURGUT CENG─░Z	38.57345650	28.49054160	3
20097	30	020028921	U─ŞUR SAKARYA	38.49001800	28.13526600	3
20098	30	D28001148	U─ŞURKAYA AKARYAKIT SAN VE T─░C LTD ┼ŞT─░	38.52581110	28.38427240	3
20099	30	D28194320	ULUHAN AKARYAKITGIDA ─░N┼ŞAAT SANAY─░ VE T─░CARET LTD. ┼ŞT─░.	38.49652200	28.14091700	3
20100	30	D28233119	UMMAHAN ┼ŞAFAK	38.49138880	28.14245340	3
20101	30	D28003123	VEL─░ UYAR	38.58027000	28.08137600	3
20102	30	D28221219	V─░LDAN ATI┼Ş	38.54853380	28.13688470	3
20103	30	D28165505	YILMAZ ERSOY	38.51516600	28.24701500	3
20104	30	D28177955	ZEKER─░YA DEM─░RAY	38.69331150	28.28414360	3
20105	30	D28001920	ZEK─░YE GERMEN	38.62244300	28.13935400	3
20106	29	D29000734	ABDURRAHMAN ├çABUK	38.51231760	27.93393490	3
20107	29	D28117528	AHMET AYDIN	38.56794780	27.88933740	3
20108	29	D28196962	AHMET EREN	38.45525600	28.04892600	3
20109	29	D28192482	AHMET ┼ŞAH─░N	38.47121100	28.07426500	3
20110	29	D28134288	AHMET TANRIVERD─░	38.52029390	27.92956650	3
20111	29	D28095216	AHMET U├çDU- SE├ç MARKET	38.48797440	28.12671070	3
20112	29	D28212338	AL─░ ├çAVDAR	38.47497580	28.10442220	3
20113	29	D28149114	AL─░ RIZA KULAKO─ŞLU	38.49347740	27.89603400	3
20114	29	D28219328	AL─░ ULA┼Ş	38.45839590	27.96330810	3
20115	29	D28000642	ALPET-ALKENT PET. VE TUR. TES. LTD. ┼ŞT─░.	38.49692600	28.02266700	3
20116	29	D28108778	AS─░YE PULAT	38.52316300	27.93871300	3
20117	29	D28001778	ASLAN TEK─░N	38.48591830	28.11282900	3
20118	29	D28242633	ASLIHAN ATASOY	42.94838100	34.13287400	3
20119	29	D28002746	ATAKAN O─ŞUZ	38.45527300	28.04868800	3
20120	29	D28166414	AY┼ŞE ALAY├ûR├£K	38.47239450	28.10482680	3
20121	29	D28239215	AY┼ŞE YILMAZ	38.49410090	28.11400760	3
20122	29	D28215208	AY┼ŞE YURTSEVER	38.48602230	28.11735410	3
20123	29	D29000135	BAHR─░ ├ûZDO─ŞAN	38.52086000	27.93835400	3
20124	29	D28167765	BAK─░ BEGTA┼Ş	38.48576600	28.11504000	3
20125	29	D28234721	BKS PETROL GRUP SAN. VE T─░C. LTD. ┼ŞT─░.	38.50925260	27.89884530	3
20126	29	D28235812	CAFER CELEN	38.52219150	27.93861350	3
20127	29	D28024782	CAH─░T KILAVUZ	38.51725500	27.93876900	3
20128	29	D28062373	CANER PETROL ├£R.GIDA MAD.VE TUR─░Z─░M SAN.T─░C.LTD ┼ŞT─░. AHMETL─░	38.51306500	27.92333200	3
20129	29	D28157903	CANER PETROL ├£R.GIDA MAD.VE TUR─░Z─░M SAN.T─░C.LTD ┼ŞT─░. SAL─░HL─░	38.47917800	28.07943700	3
20130	29	D28200334	CANER YILDIRIM	38.49406310	28.11469740	3
20131	29	D28085432	CANKAR AKARYAKIT - SAL─░HL─░	38.48002700	28.11910600	3
20132	29	D28026829	CEL─░L UYSAL	38.60769000	27.87223300	3
20133	29	D29000145	CEVAT ├ûZDEM─░R	38.51824300	27.93921000	3
20134	29	D28024620	CEVDET YILDIZ	38.49602000	28.04289900	3
20135	29	D28199310	C├£NEYT B├£LB├£L	38.47074440	28.07444010	3
20136	29	D28171504	├çNTY GRUP PETROL ├£R├£NLER─░ SANAY─░ VE T─░CARET LTD.┼ŞT─░.	38.51564200	27.95566900	3
20137	29	D28218920	D─░LBER KAVAL	38.50364030	28.09858260	3
20138	29	D28168575	DURKADIN BARUT	38.49698840	28.04804530	3
20139	29	D28237050	DUYGU EROL	38.51682080	27.93669740	3
20140	29	020028032	EFES BLOK TU─ŞLA A┼Ş.	38.48127100	28.06819000	3
20141	29	D28172737	EL─░F ├ûZKAN	38.51898330	27.93822580	3
20142	29	D28036562	EM─░NE KARADA─Ş	38.47627900	28.11317900	3
20143	29	D28218120	EMRE ├ûZT├£RK	38.48599000	28.03115000	3
20144	29	D28207901	EMSOBB ─░N┼ŞAAT LTD.┼ŞT─░.	38.50778190	27.99158210	3
20145	29	D28196276	ENES AKDA─Ş	38.51522070	27.93793900	3
20146	29	D28055494	ERCAN KAYA	38.51364980	27.93646260	3
20147	29	D28143555	ERDAL ├ç─░FT├ç─░	38.50281450	27.99904970	3
20148	29	D28003079	ERTAN BAYRAKTAR	38.51562200	27.93800400	3
20149	29	D28208175	FARUK ├çELEN	38.48582060	28.11281890	3
20150	29	D28054797	FAT─░H DURAN	38.49557540	27.89688840	3
20151	29	D28190825	FATMA KAVAS	38.49035500	28.03524540	3
20152	29	D28237602	G├£LBAHAR KARADA─Ş	38.46451600	28.11038000	3
20153	29	D28001977	G├£LSER AYSEL	38.48640600	28.03110200	3
20154	29	D29000277	HAKAN AKARSU	38.51650000	27.93779600	3
20155	29	D28233357	HAL─░M YILDIRIM	38.45755300	28.11456800	3
20156	29	D28083243	HAMZA ├ûZBEK	38.50043900	27.87053800	3
20157	29	D28143431	HARUN KOCA─░HT─░YAR	38.47360280	28.10453220	3
20158	29	D28062744	HASAN AKSU	38.49652960	28.04308370	3
20159	29	D28166554	HED─░YE BARI┼Ş	38.50212900	28.10384650	3
20160	29	D28166762	H├£SEY─░N CAN	38.52055400	27.93334600	3
20161	29	D28199865	─░BRAH─░M ETHEM KABAK	38.48733320	28.12123940	3
20162	29	D29000240	─░BRAH─░M ZEVREK	38.54605480	27.93791050	3
20163	29	D28072033	─░MADD─░N ERKO├ç	38.51360700	27.93676100	3
20164	29	D28145973	─░PEK TOLU	38.50348960	27.99933550	3
20165	29	D28221372	─░SA KARAMUK	38.51828380	27.93847960	3
20166	29	D29001920	─░SMA─░L ┼ŞENT├£RK	38.49746900	27.87033800	3
20167	29	D28144638	─░ZMAR PETROL LOJ─░ST─░K TUR─░ZM VE GIDA SANAY─░ T─░CARET L─░M─░TED ┼Ş─░RKET─░	38.50235750	27.87374900	3
20168	29	D28002845	KAHRAMAN YILDIRIM	38.49867700	28.10466300	3
20169	29	D28209191	KAYIK ENERJ─░ AKARYAKIT GIDA ─░N┼ŞAAT LTD.┼ŞT─░.	38.50307360	27.87834810	3
20170	29	D28000207	M.KEMAL AYDO─ŞAN	38.51153700	28.04435200	3
20171	29	D28229318	MAV─░Z KARAHAN	38.51949500	27.93832430	3
20172	29	D28110173	MEHMET AL─░ ORDU	38.51388100	27.93114700	3
20173	29	D28002915	MEHMET ALTINTA┼Ş	38.48939200	28.03683600	3
20174	29	D28061098	MEHMET ECE	38.49327160	27.89593180	3
20175	29	D28025589	MEHMET ERSOY	38.40080940	27.95635200	3
20176	29	D29001739	MEHMET KARAASLAN	38.50899000	27.98117500	3
20177	29	D28155470	MEHMET TANYER─░	38.49493500	28.04206100	3
20178	29	D28094693	MERT ├çEL─░KEL	38.51157970	28.04454450	3
20179	29	D28203081	MERYEM BOZYEL	38.48899090	28.12113130	3
20180	29	D28189544	MERYEM ├ûZDEM─░R	38.44339370	28.06884470	3
20181	29	D28175357	MSTF AKARYAKIT GIDA NAKL─░YE ─░N┼ŞAAT LTD.┼ŞT─░.	38.50890500	27.90240500	3
20182	29	D28194326	MUHAMMET ER	38.51712600	27.93865100	3
20183	29	D29001160	MUSTAFA G├£NAYDIN	38.52012900	27.93817200	3
20184	29	D28103386	MUSTAFA KAYIN	38.51823000	27.93849100	3
20185	29	D28188143	MUSTAFA MEM─░┼Ş	38.54616540	27.93797820	3
20186	29	D28229970	MUTLU G├£LER	38.50298670	27.99919240	3
20187	29	D28000148	M├£F─░T BAYTAN	38.49850360	28.10445300	3
20188	29	D29002101	N─░LG├£N TEKER	38.52302700	27.93872000	3
20189	29	D28195462	NUR─░ ALACA	38.51678100	27.94167100	3
20190	29	D28176280	ORHAN ARAZ	38.48993700	28.03525800	3
20191	29	D28182911	OSMAN BALTA	38.48919570	28.03693200	3
20192	29	D28093850	OSMAN KURT	38.49406620	27.87309050	3
20193	29	D28002472	├ûMER BAK─░┼Ş	38.45817530	27.96335610	3
20194	29	D28185971	├ûMER KAHRAMAN	38.49013400	28.11947900	3
20195	29	D28228900	├ûZY├£REK EXPRESS MARKET TARIM VE HAYVANCILIK TIC.LTD.┼ŞT─░.	38.50490100	28.00003840	3
20196	29	D28177938	RA─░F SA─ŞLIK	38.51331670	27.93322900	3
20197	29	D28209662	RAK─░BE YED─░VEREN	38.44164860	28.09243030	3
20198	29	D28155434	RAMAZAN SOLAK	38.49588700	28.10343000	3
20199	29	D28158292	RAMAZAN YA┼ŞAR	38.52040940	27.93805420	3
20200	29	D29000235	RECEP MERCAN	38.51878300	27.93840800	3
20201	29	D28208591	REMZ─░YE TUL─ŞAR	38.48461250	28.11205630	3
20202	29	D28193797	RE┼Ş─░TO─ŞULLARI AKARYAKIT ─░LET─░┼Ş─░M TEM.H─░Z.GIDA ─░N┼Ş.LTD	38.49867900	27.86642900	3
20203	29	D28079436	ROSTEMO─ŞLU LTD.┼ŞT─░.	38.49388000	28.11590300	3
20204	29	D28179499	SABR─░ ├ûZPINAR	38.49843300	28.10376400	3
20205	29	D28000618	SAL─░HL─░ EGEMEN PETROLC├£L├£K LTD. ┼ŞT─░.	38.48698100	28.06009300	3
20206	29	D28203684	SANPA OTOMOT─░V,TUR─░Z─░M SAN. LTD.┼ŞT─░. SAL─░HL─░ ┼ŞUBES─░	38.48185670	28.06807860	3
20207	29	D28000206	SARI PETROL MADEN─░ YA─Ş NAKL─░YE GAZ VE GIDA MALLARI T─░C. LTD. ┼ŞT─░	38.47809200	28.09006800	3
20208	29	D28200568	SELAM─░ ├ûZDEM─░R	38.51399850	27.92817550	3
20209	29	D28017542	SERAP ALTAY	38.44836000	28.11447200	3
20210	29	D28074441	SERGEN PETROL LTD.┼ŞT─░.	38.52659680	27.93938800	3
20211	29	D28147850	SERKAN KAHRAMAN	38.49754830	28.10361620	3
20212	29	D28087949	SEVG─░ KAYGISIZ	38.48483600	28.12228000	3
20213	29	D28000126	S─░NAN ├çEL─░KEL	38.51152400	28.04499600	3
20214	29	D28002185	S├ûNMEZ PETROL LTD ┼ŞT─░	38.47659900	28.10041800	3
20215	29	D28213890	SULTAN ERKAN	38.50679940	27.99135480	3
20216	29	D28187940	S├£LEYMAN ┼ŞENKAL	38.44183770	28.09264600	3
20217	29	D29001366	S├£LEYMAN UZBAY	38.51111200	27.93502000	3
20218	29	D28060205	S├£LEYMAN YILMAZ	38.51160400	28.04414300	3
20219	29	D28028670	┼ŞABAN YAKUT	38.51388050	27.93093210	3
20220	29	D28000286	┼ŞER─░F S├ûNMEZ	38.49748600	28.04526900	3
20221	29	D28211340	┼ŞEVKET ONUR	38.47506290	28.10362130	3
20222	29	D28223218	┼ŞEVVAL AYDIN	38.51511340	27.93213930	3
20223	29	D28069158	TU─ŞRUL TARIM VE PETROL ├£R├£NLER─░ T─░C.VE SAN.A.┼Ş \tSART MH.	38.49675400	28.02125300	3
20224	29	D29000134	TURGUT ├ûZDO─ŞAN	38.52051100	27.93805200	3
20225	29	D28000132	T├£L─░N SARIKAYA	38.49758060	28.04216330	3
20226	29	D28076382	├£M─░T KOCABIYIK	38.50113700	27.99818190	3
20227	29	D28150341	VEYSEL ├çELEN	38.49913200	28.10296900	3
20228	29	D28139656	ZEK─░YE KAPLAN	38.49712580	28.10358090	3
20229	29	D28237470	ZEYNEP AYDIN	38.56806840	27.89031740	3
20230	33	D28217033	ACK Z─░RAAT L─░M─░TED ┼Ş─░RKET─░	38.24331690	28.70123180	3
20231	33	D28232889	ADEM KE┼ŞKEKO─ŞLU	38.23578500	28.70174700	3
20232	33	D28000374	AHMET ├çAKAR	38.35999590	28.54417410	3
20233	33	020028657	AHMET ├ç─░NKILI├ç	38.24101500	28.69826350	3
20234	33	D28001060	AHMET SOYER	38.22746320	28.77170920	3
20235	33	D28200145	AL─░ OSMAN ┼ŞAH─░N	38.16741330	28.70809000	3
20236	33	D28002319	AL─░ ├ûZD─░L	38.25937100	28.70792400	3
20237	33	D28056054	AL─░ UZ	38.28526200	28.69758000	3
20238	33	D28000856	AL─░ME ADAK	38.31116910	28.66940690	3
20239	33	D28130760	AYNUR BA┼Ş	38.23717320	28.68823690	3
20240	33	D28083939	AYSUN KARAKA┼Ş	38.23983420	28.69271250	3
20241	33	D28196250	AY┼ŞE BULUT	38.28721810	28.69764250	3
20242	33	D28053782	AY┼ŞE ├çET─░N	38.12290900	28.69353700	3
20243	33	D28001111	AY┼ŞE G├ûK	38.33084000	28.60706300	3
20244	33	D28002231	AY┼ŞE ─░SEM	38.13255330	28.59003850	3
20245	33	D28017881	AYTA├ç BAYER	38.24345100	28.70126800	3
20246	33	D28136151	AYTA├ç BAYER 2	38.22627100	28.72194200	3
20247	33	D28199730	AYTA├ç EFE	38.23449600	28.70431500	3
20248	33	D28124448	B─░LAL B─░LEN	38.24034240	28.69253680	3
20249	33	D28213202	B├£LENT ALTINKUM	38.23683140	28.69286270	3
20250	33	D28000959	CENG─░Z OKUMU┼Ş	38.24057690	28.69926600	3
20251	33	D28002407	CEYLANLAR AKARYAKIT TOPRAK MAH.NAK.TOP.PER.GIDA T─░C.LTD.┼ŞT─░	38.30452500	28.70104100	3
20252	33	D28242902	DEMET YET─░┼Ş	42.94838100	34.13287400	3
20253	33	D28062181	DEN─░ZL─░ NALBUR─░YE PETROL	38.15262100	28.70730600	3
20254	33	D28112863	D├ûND├£ KIRER	38.24581800	28.61038180	3
20255	33	D28002159	ELMAS ─░N┼ŞAAT VE T─░CARET LTD.┼ŞT─░.	38.23863600	28.66805400	3
20256	33	020028521	ERCAN ├çEL─░K 1	38.25843800	28.70710100	3
20257	33	D28014881	ERCAN ├çEL─░K 2	38.23734500	28.69611400	3
20258	33	D28065053	ERCAN ├çEL─░K 3	38.24052360	28.68920510	3
20259	33	D28065054	ERCAN ├çEL─░K 4	38.24382000	28.67992500	3
20260	33	D28104240	ERCAN ├çEL─░K 5	38.23946500	28.69387500	3
20261	33	D28128098	ERDAL KARAO─ŞLAN	38.24501800	28.67660900	3
20262	33	D28151834	ERS─░N ├ûZL├£	38.23986060	28.69563030	3
20263	33	D28002947	ERSOY ERDO─ŞAN	38.30919700	28.73346700	3
20264	33	D28166128	ERT├£RK TOPTAN GIDA-H├£SEY─░N ERT├£RK ─░N┼ŞAAT GIDA TARIM ├£R├£NLER─░ LTD. ┼ŞT─░.	38.24203380	28.69949430	3
20265	33	D28002751	ESAT SEV├£K	38.15384480	28.70260290	3
20266	33	D28167520	EY├£P SAFA KAYACIK	38.24238600	28.69565400	3
20267	33	D28000945	FARUK SAYDAM	38.29219800	28.71993200	3
20268	33	D28124337	FEDA─░ DO─ŞRUL	38.14379720	28.63985820	3
20269	33	D28056050	GAMZE ASLAN	38.30858600	28.73383600	3
20270	33	D28002956	G├£LTEK─░N KARTAL	38.12285630	28.60459550	3
20271	33	D28231046	G├£NERLER AKARYAKIT GIDA .TURZ VESAN.VE T─░C.LTD.┼ŞT─░.	38.25398100	28.65978900	3
20272	33	D28067229	G├£RKAN G├£RB├£Z	38.23658400	28.70042200	3
20273	33	D28197118	HAL─░L DANACI	38.24212900	28.68359000	3
20274	33	D28000904	HAL─░L ─░BRAH─░M UYSAL	38.12277600	28.69357300	3
20275	33	D28002999	HAL─░L KANAR	38.25787800	28.64908200	3
20276	33	D28132983	Halil Pekdemir-Manisa10-Sar─▒g├Âl1	38.23984190	28.69302280	3
20277	33	D28001236	HAL─░ME ├£LKER	38.21832600	28.71364500	3
20278	33	D28002285	HAL─░T ├ûZATA	38.23582900	28.69542400	3
20279	33	D28001165	HASAN ├çEL─░K	38.23704680	28.68845580	3
20280	33	D28001071	HASAN ├çOLAK	38.14557100	28.64143300	3
20281	33	D28192462	HASAN KARABA┼Ş	38.20295690	28.76332410	3
20282	33	D28145157	HASAN ├ûKTEM	38.32837200	28.60651890	3
20283	33	D28230059	HASAN YANIK	38.23888920	28.68822120	3
20284	33	D28137816	HASAN YILMAZ	38.22492010	28.76894250	3
20285	33	D28002211	HAT─░CE AKDEN─░Z	38.23135200	28.71103900	3
20286	33	D28209774	H├£SEY─░N ACAR	38.23961600	28.69701500	3
20287	33	D28195904	H├£SEY─░N ├çET─░NKAYA	38.23759930	28.68699440	3
20288	33	D28000842	H├£SEY─░N ERDEN	38.23841700	28.69633100	3
20289	33	D28033032	H├£SEY─░N KALKAN PET.─░N┼Ş.TUR.GID.TA┼Ş.SAN.VE T─░C.LTD.┼ŞT─░	38.24176900	28.68406000	3
20290	33	D28077600	H├£SEY─░N KALKAN PET.─░N┼Ş.TUR.GID.TA┼Ş.SAN.VE T─░C.LTD.┼ŞT─░-1	38.16563500	28.69325000	3
20291	33	D28136150	H├£SEY─░N KALKAN PETROLC├£L├£K ─░N┼ŞAAT TURZ─░M GIDA TA┼Ş.SAN.VE T─░C.LT	38.24397300	28.68046200	3
20292	33	D28001243	H├£SEY─░N YAKUT	38.23992330	28.69564840	3
20293	33	D28002946	─░.S ERT├£RK PETROL DELEMENLER	38.27470900	28.61994400	3
20294	33	D28003172	─░.S ERT├£RK PETROL SARIG├ûL 1	38.24410000	28.67080000	3
20295	33	D28175672	─░.S ERT├£RK PETROL SARIG├ûL 2	38.24429700	28.67199200	3
20296	33	D28001129	─░BRAH─░M ATLI─Ş	38.22112400	28.62472000	3
20297	33	D28002239	─░BRAH─░M BAYDAR	38.13341700	28.58727700	3
20298	33	D28026276	─░BRAH─░M ├çET─░NKOL	38.25647700	28.65457700	3
20299	33	D28083294	─░BRAH─░M VAROL	38.15607770	28.60511840	3
20300	33	D28115574	─░BRAH─░M YILDIZ	38.25400120	28.65091180	3
20301	33	D28176767	─░BRAH─░M YILMAZ	38.24060370	28.69836140	3
20302	33	D28000966	─░DR─░S KE┼ŞKEKO─ŞLU	38.22521400	28.76858100	3
20303	33	D28212328	─░RFAN ├çAL	38.23724510	28.68820330	3
20304	33	D28048605	─░SA SARI	38.24098200	28.69828000	3
20305	33	D28092852	KAM─░L ─░B─░K	38.24252260	28.70018100	3
20306	33	D28002480	KENAN SA├çAN	38.13339800	28.58706400	3
20307	33	D28111382	LEVENT G├£NAY	38.25074500	28.74511300	3
20308	33	D28148258	MEHMET AL─░ ALTA┼Ş	38.14206240	28.64104200	3
20309	33	D28001191	MEHMET AL─░ AY	38.12314580	28.69296290	3
20310	33	D28000869	MEHMET ERDO─ŞAN	38.24024500	28.69644600	3
20311	33	D28115074	MEHMET G├£M├£┼ŞL├£	38.25819600	28.70693600	3
20312	33	D28000899	MEHMET ─░─ŞDEL─░	38.33160100	28.70642800	3
20313	33	D28137302	MEHMET VURAL	38.20449910	28.76448170	3
20314	33	D28186578	MEHMET YAVA┼Ş	38.16458100	28.70568100	3
20315	33	D28186648	MERYEM AKIN	38.29208200	28.71896900	3
20316	33	D28100246	MEVH─░BE ├çAVU┼ŞLU	38.23920500	28.69502700	3
20317	33	D28115572	M─░THAT ├çIRACI	38.28650100	28.69670800	3
20318	33	D28002834	MURAT KUZU	38.24329100	28.68117500	3
20319	33	D28237558	MURAT USLU	38.24078800	28.69890400	3
20320	33	D28002646	MUSTAFA AL─░ CAVLAK	38.19667000	28.61164900	3
20321	33	D28000979	MUSTAFA B─░NG├£L	38.33133500	28.70790800	3
20322	33	D28001242	MUSTAFA G├£LSOY	38.22528700	28.76865200	3
20323	33	D28224273	MUSTAFA G├£NG├ûR	38.22552470	28.76883070	3
20324	33	D28001008	MUSTAFA T├£RKER	38.24133200	28.70008000	3
20325	33	D28221797	MUSTAFA YATA─ŞAN	38.23954250	28.69816130	3
20326	33	D28117798	M├£B─░N KANYILMAZ	38.12489790	28.69165490	3
20327	33	D28232667	M├£RSEL KIR	38.23913530	28.69925540	3
20328	33	D28001128	NAH─░T COF	38.23257090	28.70878490	3
20329	33	D28001088	NEB─░ G├£M├£┼ŞL├£	38.24783400	28.70174600	3
20330	33	D28055210	NEB─░ KUZUCU	38.23534300	28.69520100	3
20331	33	D28002561	NEB─░YE TA┼Ş├çI	38.23108740	28.71146690	3
20332	33	D28002379	NE┼ŞE SEZEN	38.23783100	28.69795700	3
20333	33	D28227953	OKAN UR	38.12292700	28.69337300	3
20334	33	D28001193	OSMAN BAYDAR	38.13346310	28.58833420	3
20335	33	D28209895	OSMAN EMRE AYTEM├£R	38.17346560	28.64550270	3
20336	33	D28207261	OSMAN KAYA	38.14011890	28.64153000	3
20337	33	D28176642	OSMAN SARITA┼Ş	38.12179290	28.60409590	3
20338	33	D28196572	├ûNDER ER─░M	38.24062540	28.69923520	3
20339	33	D28227422	RAMAZAN M├£SL├£M BOZKURT	38.31101270	28.66980570	3
20340	33	D28176331	RAS─░M BAYDAR	38.13344530	28.58848730	3
20341	33	D28001173	SA─░M YURTTA┼Ş	38.14245100	28.64123200	3
20342	33	D28237792	SEHER A┼ŞIR	38.24165800	28.68466260	3
20343	33	D28014570	SEHER SARIKAYA	38.24128400	28.69845900	3
20344	33	D28001849	SEMRA SEZEN	38.23901500	28.69793400	3
20345	33	D28123398	SONER S├ûZER	38.16815500	28.70796600	3
20346	33	D28078536	S├£LEYMAN EMER	38.23821000	28.69274300	3
20347	33	D28002841	S├£LEYMAN KAPLAN	38.13343400	28.58719100	3
20348	33	D28000967	S├£LEYMAN UYAR	38.22114900	28.62478100	3
20349	33	D28130618	┼ŞAFAK KIZILTEPE	38.18963800	28.66894100	3
20350	33	D28001103	┼ŞAH AYVERD─░	38.28717500	28.69735200	3
20351	33	D28208595	┼ŞAH─░N ESENT├£RK	38.15166670	28.60557450	3
20352	33	D28000849	┼ŞENG├£N INSAAT MALZ.MAHR.NAK.HURD.GIDA KIRT IHR.ITH.TIC.LTD.STI	38.23953540	28.69818950	3
20353	33	D28001260	UYSALLAR GIDA SAN.T─░C.LTD.┼ŞT─░	38.24054400	28.69754900	3
20354	33	D28207708	YA┼ŞAR TUN├ç	38.23717530	28.69594160	3
20355	33	D28001059	YAVUZ ├£NL├£	38.29202600	28.71941400	3
20356	33	D28144598	YEK M├£T.INS G.O.HAY.E.MAD.IT.IH.SAN.VE TIC.LIMT.SIR. - SE├ç MARKET	38.23506000	28.69295800	3
20357	33	D28232322	YEK M├£T.INS G.O.HAY.E.MAD.IT.IH.SAN.VE TIC.LIMT.SIR.-SE├ç MARKET KO├çAK	38.23232600	28.70919010	3
20358	33	D28002314	ZAFER ULU	38.23835600	28.69647200	3
\.


--
-- Data for Name: depots; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.depots (id, name, code) FROM stdin;
1	Manisa	MANISA
2	─░zmir	IZMIR
3	Salihli	SALIHLI
\.


--
-- Data for Name: photos; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.photos (id, request_id, path_or_url, file_name, mime_type, created_at) FROM stdin;
13	14	/uploads/797f51c3-a2b5-469d-8b03-7f3adaf4b6d2.png	Turizm.png	image/png	2026-01-16 07:48:40.874509+00
14	14	/uploads/aa7bee4f-5cab-472e-86a7-3a5e57a1e6aa.png	Turizm.png	image/png	2026-01-16 07:49:59.386404+00
15	14	/uploads/4b9391b1-fb3d-4de8-a24f-9112a27ebe9c.png	logo-1 (1).png	image/png	2026-01-16 07:51:08.90282+00
\.


--
-- Data for Name: posm; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.posm (id, name, ready_count, repair_pending_count, created_at, updated_at, depot_id) FROM stdin;
1	POS'a Ait ├£nite	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
2	Multiplex	5	2	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
3	100X35 ATLAS	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
4	Smart Unit	10	4	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
5	100X50 ATLAS	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
6	AF 12'li	9	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
7	130X50 ATLAS	8	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
8	Armada 100x35	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
9	Mini Atlas 88-100'l├╝k	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
10	INOVA 100x100/ 100x85	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
11	Armada 100x50	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
12	Armada 90x35	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
13	Armada 130x35	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
14	Secondary Stok Alan─▒	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
15	88X35 ATLAS	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
16	AF 8'li	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
17	Armada 130x50	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
18	Mini Atlas 130'luk	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
19	Millenium	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
20	130X35 ATLAS	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
21	PMI ├ûzel ├£retim ├£nite-B├╝y├╝k	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
22	PMI ├ûzel ├£retim ├£nite-Orta	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
23	Mini Armada	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
24	MCOU	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
25	PMI ├ûzel ├£retim ├£nite-K├╝├ğ├╝k	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
27	Arcadia	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
28	Armada 170x35	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
31	Sehpa	10	5	2026-01-15 10:13:05.949452+00	2026-01-15 10:13:05.949452+00	\N
26	MIDWAY 12'li	10	6	2026-01-15 10:13:05.949452+00	2026-01-15 11:39:36.679945+00	\N
29	C4 COU	10	6	2026-01-15 10:13:05.949452+00	2026-01-15 13:14:58.66422+00	\N
30	LOCAL COU	8	5	2026-01-15 10:13:05.949452+00	2026-01-15 13:15:27.257269+00	\N
32	88X35 ATLAS	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
33	88X35 ATLAS	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
34	88X35 ATLAS	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
35	MIDWAY 12'li	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
36	MIDWAY 12'li	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
37	MIDWAY 12'li	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
38	POS'a Ait ├£nite	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
39	POS'a Ait ├£nite	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
40	POS'a Ait ├£nite	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
41	AF 12'li	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
42	AF 12'li	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
43	AF 12'li	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
44	C4 COU	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
45	C4 COU	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
46	C4 COU	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
47	Multiplex	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
48	Multiplex	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
49	Multiplex	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
50	Armada 130x35	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
51	Armada 130x35	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
52	Armada 130x35	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
53	Sehpa	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
54	Sehpa	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
55	Sehpa	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
56	Armada 100x50	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
57	Armada 100x50	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
58	Armada 100x50	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
59	Arcadia	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
60	Arcadia	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
61	Arcadia	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
62	100X35 ATLAS	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
63	100X35 ATLAS	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
64	100X35 ATLAS	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
65	Mini Atlas 88-100'l├╝k	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
66	Mini Atlas 88-100'l├╝k	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
67	Mini Atlas 88-100'l├╝k	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
68	PMI ├ûzel ├£retim ├£nite-B├╝y├╝k	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
69	PMI ├ûzel ├£retim ├£nite-B├╝y├╝k	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
70	PMI ├ûzel ├£retim ├£nite-B├╝y├╝k	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
71	MCOU	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
72	MCOU	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
73	MCOU	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
74	130X50 ATLAS	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
75	130X50 ATLAS	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
76	130X50 ATLAS	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
77	INOVA 100x100/ 100x85	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
78	INOVA 100x100/ 100x85	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
79	INOVA 100x100/ 100x85	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
80	Armada 100x35	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
81	Armada 100x35	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
82	Armada 100x35	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
83	Mini Armada	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
84	Mini Armada	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
85	Mini Armada	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
86	PMI ├ûzel ├£retim ├£nite-Orta	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
87	PMI ├ûzel ├£retim ├£nite-Orta	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
88	PMI ├ûzel ├£retim ├£nite-Orta	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
89	Millenium	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
90	Millenium	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
91	Millenium	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
92	PMI ├ûzel ├£retim ├£nite-K├╝├ğ├╝k	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
93	PMI ├ûzel ├£retim ├£nite-K├╝├ğ├╝k	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
94	PMI ├ûzel ├£retim ├£nite-K├╝├ğ├╝k	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
95	AF 8'li	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
96	AF 8'li	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
97	AF 8'li	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
98	Armada 90x35	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
99	Armada 90x35	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
100	Armada 90x35	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
101	LOCAL COU	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
103	LOCAL COU	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
104	Armada 130x50	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
105	Armada 130x50	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
106	Armada 130x50	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
107	130X35 ATLAS	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
108	130X35 ATLAS	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
109	130X35 ATLAS	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
110	Secondary Stok Alan─▒	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
111	Secondary Stok Alan─▒	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
112	Secondary Stok Alan─▒	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
113	100X50 ATLAS	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
114	100X50 ATLAS	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
115	100X50 ATLAS	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
116	Smart Unit	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
117	Smart Unit	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
118	Smart Unit	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
119	Mini Atlas 130'luk	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
120	Mini Atlas 130'luk	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
121	Mini Atlas 130'luk	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
122	Armada 170x35	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	1
123	Armada 170x35	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	2
124	Armada 170x35	0	0	2026-01-15 13:37:40.354151+00	2026-01-15 13:37:40.354151+00	3
125	Pusher	0	0	2026-01-16 06:25:24.819595+00	2026-01-16 06:25:24.819595+00	1
126	Pusher	0	0	2026-01-16 06:25:27.192486+00	2026-01-16 06:25:27.192486+00	2
127	Pusher	0	0	2026-01-16 06:25:27.192486+00	2026-01-16 06:25:27.192486+00	3
102	LOCAL COU	4	0	2026-01-15 13:37:40.354151+00	2026-01-16 07:51:10.220193+00	2
\.


--
-- Data for Name: posm_transfers; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.posm_transfers (id, posm_id, from_depot_id, to_depot_id, quantity, transfer_type, notes, transferred_by, created_at) FROM stdin;
\.


--
-- Data for Name: requests; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.requests (id, user_id, dealer_id, territory_id, current_posm, job_type, job_detail, request_date, requested_date, planned_date, posm_id, status, job_done_desc, latitude, longitude, updated_at, updated_by, depot_id, completed_date, completed_by, priority) FROM stdin;
14	7	15932	5	\N	Montaj	\N	2026-01-16 07:48:40.76422+00	2026-01-17	2026-01-23	102	Tamamland─▒		38.42268630	27.19406500	2026-01-16 07:51:10.220193+00	1	2	2026-01-24	1	Orta
\.


--
-- Data for Name: scheduled_reports; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.scheduled_reports (id, name, report_type, cron_expression, is_active, depot_ids, recipient_user_ids, status_filter, job_type_filter, custom_params, last_sent_at, next_run_at, created_at, updated_at, created_by_user_id) FROM stdin;
1	Manisa Tamamlanan ─░┼şler	weekly_completed	4 08 20	t	null	[1]	null	null	null	2026-01-16 08:20:01.353387+00	\N	2026-01-16 05:13:19.631599+00	2026-01-16 08:20:00.002115+00	1
2	Manisa	pending_requests	4 08 19	t	null	[1]	null	null	null	2026-01-16 13:10:27.205384+00	\N	2026-01-16 05:19:00.699902+00	2026-01-16 13:10:27.192111+00	1
\.


--
-- Data for Name: territories; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.territories (id, name) FROM stdin;
1	Bozyaka
2	G├╝ltepe
3	Hatay
4	TINAZTEPE
5	Alt─▒nda─ş
6	G├Âztepe
7	Aktepe
8	Kadifekale
9	┼Şirinyer
10	Bo─şazi├ği
11	BUCA
12	Bal├ğova
13	Basmane
14	Limontepe
15	Ye┼şilyurt
16	GED─░Z
17	├çaml─▒k
18	KARABAGLAR
19	Alsancak
20	Narl─▒dere
21	Sarn─▒├ğ
22	Soma 1
23	Akhisar K─▒rka─şa├ğ
24	Urla
25	K─▒s─▒kk├Ây
26	Karaburun
27	├çe┼şme
28	Salihli 1
29	Salihli K├Âyler Ahmeli
30	Salihli 3 ve K├Âyler
31	Ala┼şehir 1
32	Ala┼şahir 2 ve K├Âyler
33	Sar─▒g├Âl
34	Kula - Selendi
35	Demirci - K├Âpr├╝ba┼ş─▒ - G├Ârdes
36	Turgutlu 1
37	Kemalpa┼şa K├Âyler
38	Turgutlu 3 ve K├Âyler
39	Kemalpa┼şa
40	Turgutlu 2 - Manisa
41	Manisa ├çar┼ş─▒
42	Saruhanl─▒
43	Manisa Sanayi
44	Manisa Karak├Ây
45	Muradiye
46	Manisa Merkez
47	Akhisar 1
48	Akhisar 2 ve K├Âyler
49	G├Âlmarmara-Akhisar
50	Menderes
51	G├╝m├╝ld├╝r
52	GAZ─░EM─░R
53	Seferihisar
54	Soma 2
55	Ala┼şehir 3 ve K├Âyler
56	Salihli 2
57	Askeri Birlik ÔÇô Cezaevi
\.


--
-- Data for Name: user_depots; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.user_depots (user_id, depot_id) FROM stdin;
6	1
5	1
1	2
1	3
1	1
7	2
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public.users (id, name, email, password_hash, role, created_at, updated_at, depot_id) FROM stdin;
3	oguz	oguz@oguz.com	$2b$12$lq7F8zBdkRj2i2QHcA4Kh.T9mP/bpLgXLgShcxC3V.dX4UMksh6TG	user	2026-01-15 10:16:38.570173+00	2026-01-15 10:24:26.64888+00	\N
4	Oguz	teknik@dinogida.com.tr	$2b$12$8fbpFwpyL5c8FIvnbmclI.dVPLnCrGXg/BanfIgMHbYO4I/t.474m	tech	2026-01-15 10:16:38.769251+00	2026-01-15 10:24:26.840163+00	\N
6	sads	test@example.com	$2b$12$c5zn6zFvyIqTzAhzBNzxSeFjbadS9vhUqClZecM3Dc5asu9Cw9J2G	user	2026-01-15 11:20:59.817591+00	2026-01-15 11:20:59.817591+00	1
1	Admin Kullan─▒c─▒	info@dinogida.com.tr	$2b$12$k3rOApfD.R6XHMy9u.SjwOGvO4NcVDVjRI2jocDMVuYP0EoPTzmq2	admin	2026-01-15 09:13:27.605035+00	2026-01-15 12:25:43.730388+00	\N
5	Tunahan ├ûKDEM	oguzemul@gmail.com	$2b$12$RLD/FuXClQ9FrNIxjO3VXeW4ZrhakBRSCIg/lQmOeWrs8lWlAEtvu	tech	2026-01-15 10:16:38.964621+00	2026-01-15 12:26:19.828318+00	1
7	Arif YALIM	arif.yalim@dinogida.com.tr	$2b$12$wo2MxrkDU.ZB8G2r2w.GAORst9eHKDpU8iz3FXAvke8ftoGEvcpNq	user	2026-01-16 07:20:09.165976+00	2026-01-16 07:20:09.165976+00	\N
\.


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.audit_logs_id_seq', 16, true);


--
-- Name: dealers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.dealers_id_seq', 20358, true);


--
-- Name: depots_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.depots_id_seq', 3, true);


--
-- Name: photos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.photos_id_seq', 15, true);


--
-- Name: posm_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.posm_id_seq', 127, true);


--
-- Name: posm_transfers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.posm_transfers_id_seq', 1, false);


--
-- Name: requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.requests_id_seq', 14, true);


--
-- Name: scheduled_reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.scheduled_reports_id_seq', 2, true);


--
-- Name: territories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.territories_id_seq', 57, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public.users_id_seq', 8, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: dealers dealers_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.dealers
    ADD CONSTRAINT dealers_pkey PRIMARY KEY (id);


--
-- Name: depots depots_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.depots
    ADD CONSTRAINT depots_pkey PRIMARY KEY (id);


--
-- Name: photos photos_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.photos
    ADD CONSTRAINT photos_pkey PRIMARY KEY (id);


--
-- Name: posm posm_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.posm
    ADD CONSTRAINT posm_pkey PRIMARY KEY (id);


--
-- Name: posm_transfers posm_transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.posm_transfers
    ADD CONSTRAINT posm_transfers_pkey PRIMARY KEY (id);


--
-- Name: requests requests_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_pkey PRIMARY KEY (id);


--
-- Name: scheduled_reports scheduled_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.scheduled_reports
    ADD CONSTRAINT scheduled_reports_pkey PRIMARY KEY (id);


--
-- Name: territories territories_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.territories
    ADD CONSTRAINT territories_pkey PRIMARY KEY (id);


--
-- Name: user_depots user_depots_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.user_depots
    ADD CONSTRAINT user_depots_pkey PRIMARY KEY (user_id, depot_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: ix_audit_logs_id; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX ix_audit_logs_id ON public.audit_logs USING btree (id);


--
-- Name: ix_dealers_code; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX ix_dealers_code ON public.dealers USING btree (code);


--
-- Name: ix_dealers_code_depot; Type: INDEX; Schema: public; Owner: app
--

CREATE UNIQUE INDEX ix_dealers_code_depot ON public.dealers USING btree (code, depot_id);


--
-- Name: ix_dealers_id; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX ix_dealers_id ON public.dealers USING btree (id);


--
-- Name: ix_depots_code; Type: INDEX; Schema: public; Owner: app
--

CREATE UNIQUE INDEX ix_depots_code ON public.depots USING btree (code);


--
-- Name: ix_depots_id; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX ix_depots_id ON public.depots USING btree (id);


--
-- Name: ix_depots_name; Type: INDEX; Schema: public; Owner: app
--

CREATE UNIQUE INDEX ix_depots_name ON public.depots USING btree (name);


--
-- Name: ix_photos_id; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX ix_photos_id ON public.photos USING btree (id);


--
-- Name: ix_posm_id; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX ix_posm_id ON public.posm USING btree (id);


--
-- Name: ix_posm_name; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX ix_posm_name ON public.posm USING btree (name);


--
-- Name: ix_posm_name_depot; Type: INDEX; Schema: public; Owner: app
--

CREATE UNIQUE INDEX ix_posm_name_depot ON public.posm USING btree (name, depot_id);


--
-- Name: ix_posm_transfers_id; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX ix_posm_transfers_id ON public.posm_transfers USING btree (id);


--
-- Name: ix_requests_id; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX ix_requests_id ON public.requests USING btree (id);


--
-- Name: ix_scheduled_reports_id; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX ix_scheduled_reports_id ON public.scheduled_reports USING btree (id);


--
-- Name: ix_territories_id; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX ix_territories_id ON public.territories USING btree (id);


--
-- Name: ix_territories_name; Type: INDEX; Schema: public; Owner: app
--

CREATE UNIQUE INDEX ix_territories_name ON public.territories USING btree (name);


--
-- Name: ix_user_depots_depot_id; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX ix_user_depots_depot_id ON public.user_depots USING btree (depot_id);


--
-- Name: ix_user_depots_user_id; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX ix_user_depots_user_id ON public.user_depots USING btree (user_id);


--
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: app
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- Name: ix_users_id; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX ix_users_id ON public.users USING btree (id);


--
-- Name: audit_logs audit_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: dealers dealers_territory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.dealers
    ADD CONSTRAINT dealers_territory_id_fkey FOREIGN KEY (territory_id) REFERENCES public.territories(id);


--
-- Name: dealers fk_dealers_depot; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.dealers
    ADD CONSTRAINT fk_dealers_depot FOREIGN KEY (depot_id) REFERENCES public.depots(id);


--
-- Name: posm fk_posm_depot; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.posm
    ADD CONSTRAINT fk_posm_depot FOREIGN KEY (depot_id) REFERENCES public.depots(id);


--
-- Name: requests fk_requests_completed_by; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT fk_requests_completed_by FOREIGN KEY (completed_by) REFERENCES public.users(id);


--
-- Name: requests fk_requests_depot; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT fk_requests_depot FOREIGN KEY (depot_id) REFERENCES public.depots(id);


--
-- Name: users fk_users_depot; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_depot FOREIGN KEY (depot_id) REFERENCES public.depots(id);


--
-- Name: photos photos_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.photos
    ADD CONSTRAINT photos_request_id_fkey FOREIGN KEY (request_id) REFERENCES public.requests(id);


--
-- Name: posm_transfers posm_transfers_from_depot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.posm_transfers
    ADD CONSTRAINT posm_transfers_from_depot_id_fkey FOREIGN KEY (from_depot_id) REFERENCES public.depots(id);


--
-- Name: posm_transfers posm_transfers_posm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.posm_transfers
    ADD CONSTRAINT posm_transfers_posm_id_fkey FOREIGN KEY (posm_id) REFERENCES public.posm(id);


--
-- Name: posm_transfers posm_transfers_to_depot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.posm_transfers
    ADD CONSTRAINT posm_transfers_to_depot_id_fkey FOREIGN KEY (to_depot_id) REFERENCES public.depots(id);


--
-- Name: posm_transfers posm_transfers_transferred_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.posm_transfers
    ADD CONSTRAINT posm_transfers_transferred_by_fkey FOREIGN KEY (transferred_by) REFERENCES public.users(id);


--
-- Name: requests requests_dealer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_dealer_id_fkey FOREIGN KEY (dealer_id) REFERENCES public.dealers(id);


--
-- Name: requests requests_posm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_posm_id_fkey FOREIGN KEY (posm_id) REFERENCES public.posm(id);


--
-- Name: requests requests_territory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_territory_id_fkey FOREIGN KEY (territory_id) REFERENCES public.territories(id);


--
-- Name: requests requests_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- Name: requests requests_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: scheduled_reports scheduled_reports_created_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.scheduled_reports
    ADD CONSTRAINT scheduled_reports_created_by_user_id_fkey FOREIGN KEY (created_by_user_id) REFERENCES public.users(id);


--
-- Name: user_depots user_depots_depot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.user_depots
    ADD CONSTRAINT user_depots_depot_id_fkey FOREIGN KEY (depot_id) REFERENCES public.depots(id) ON DELETE CASCADE;


--
-- Name: user_depots user_depots_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public.user_depots
    ADD CONSTRAINT user_depots_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict HKUJgl5XWT9fMOMsSy7ZnOtyDP0df9Zvi4fU2lg7P2OV78Sfk2dJuQCiEkntw4A

