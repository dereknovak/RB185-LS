--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3 (Homebrew)
-- Dumped by pg_dump version 16.3 (Homebrew)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: expenses; Type: TABLE; Schema: public; Owner: dereknovak
--

CREATE TABLE public.expenses (
    id integer NOT NULL,
    amount numeric(6,2) NOT NULL,
    memo text NOT NULL,
    created_on date NOT NULL,
    CONSTRAINT expenses_amount_check CHECK ((amount >= 0.01))
);


ALTER TABLE public.expenses OWNER TO dereknovak;

--
-- Name: expenses_id_seq; Type: SEQUENCE; Schema: public; Owner: dereknovak
--

CREATE SEQUENCE public.expenses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.expenses_id_seq OWNER TO dereknovak;

--
-- Name: expenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dereknovak
--

ALTER SEQUENCE public.expenses_id_seq OWNED BY public.expenses.id;


--
-- Name: expenses id; Type: DEFAULT; Schema: public; Owner: dereknovak
--

ALTER TABLE ONLY public.expenses ALTER COLUMN id SET DEFAULT nextval('public.expenses_id_seq'::regclass);


--
-- Data for Name: expenses; Type: TABLE DATA; Schema: public; Owner: dereknovak
--

COPY public.expenses (id, amount, memo, created_on) FROM stdin;
1	14.56	Pencils	2024-06-19
2	3.29	Coffee	2024-06-19
3	49.99	Text Editor	2024-06-19
4	4.25	Test	2024-06-19
5	6.74	Test2	2024-06-19
6	10.85	Test3	2024-06-19
\.


--
-- Name: expenses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dereknovak
--

SELECT pg_catalog.setval('public.expenses_id_seq', 6, true);


--
-- Name: expenses expenses_pkey; Type: CONSTRAINT; Schema: public; Owner: dereknovak
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

