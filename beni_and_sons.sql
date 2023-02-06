--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1
-- Dumped by pg_dump version 15.1

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
-- Name: applicant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applicant (
    id integer NOT NULL,
    city character varying(25),
    birth_date date,
    family_status character varying(25),
    application_date date,
    recruiter_id integer,
    resume_url character varying(250)
);


ALTER TABLE public.applicant OWNER TO postgres;

--
-- Name: bonus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bonus (
    month integer NOT NULL,
    month_name character varying(25),
    bonus_amount integer
);


ALTER TABLE public.bonus OWNER TO postgres;

--
-- Name: departmant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departmant (
    id integer NOT NULL,
    name character varying(25)
);


ALTER TABLE public.departmant OWNER TO postgres;

--
-- Name: job; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job (
    id integer NOT NULL,
    campany character varying(25),
    roll character varying(25)
);


ALTER TABLE public.job OWNER TO postgres;

--
-- Name: recruiter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recruiter (
    id integer NOT NULL,
    city character varying(25),
    birth_date date,
    family_status character varying(25),
    base_salary integer,
    departmant_id integer
);


ALTER TABLE public.recruiter OWNER TO postgres;

--
-- Name: recruitment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recruitment (
    recruiter_id integer,
    applicant_id integer,
    recruitment_date date
);


ALTER TABLE public.recruitment OWNER TO postgres;

--
-- Data for Name: applicant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.applicant (id, city, birth_date, family_status, application_date, recruiter_id, resume_url) FROM stdin;
1	Tel Aviv	2000-01-01	Single	2022-11-01	1	www.resume1.com
2	Haifa	2000-02-02	Married	2022-11-02	1	www.resume2.com
3	Jerusalem	2000-03-03	Single	2022-11-03	1	www.resume3.com
4	Petah Tikva	2000-04-04	Married	2022-11-04	1	www.resume4.com
5	Beersheba	2000-05-05	Single	2022-11-05	1	www.resume5.com
6	Rishon Lezion	2000-06-06	Married	2022-11-06	2	www.resume6.com
7	Ashdod	2000-07-07	Single	2022-11-07	2	www.resume7.com
8	Netanya	2000-08-08	Married	2022-11-08	2	www.resume8.com
9	Holon	2000-09-09	Single	2022-11-09	2	www.resume9.com
10	Ramat Gan	2000-10-10	Married	2022-11-10	2	www.resume10.com
11	Bnei Brak	2000-11-11	Single	2022-11-11	3	www.resume11.com
12	Bat Yam	2000-12-12	Married	2022-11-12	3	www.resume12.com
13	Herzliya	2000-01-01	Single	2022-12-01	3	www.resume13.com
14	Rehovot	2000-02-02	Married	2022-12-02	3	www.resume14.com
15	Ramla	2000-03-03	Single	2022-12-03	3	www.resume15.com
16	Lod	2000-04-04	Married	2022-12-04	4	www.resume16.com
17	Nazareth	2000-05-05	Single	2022-12-05	4	www.resume17.com
18	Eilat	2000-06-06	Married	2022-12-06	4	www.resume18.com
19	Tiberias	2000-12-13	Single	2022-12-13	4	www.resume19.com
20	Tel Aviv	2000-12-14	Married	2022-12-14	4	www.resume20.com
\.


--
-- Data for Name: bonus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bonus (month, month_name, bonus_amount) FROM stdin;
1	January	1000
2	February	900
3	March	800
4	April	700
5	May	600
6	June	500
7	July	400
8	August	300
9	September	200
10	October	100
11	November	900
12	December	1000
\.


--
-- Data for Name: departmant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departmant (id, name) FROM stdin;
1	high tech
2	pharma
\.


--
-- Data for Name: job; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job (id, campany, roll) FROM stdin;
1	Company A	Manager
2	Company B	Developer
3	Company C	Salesperson
4	Company D	Designer
5	Company E	Accountant
6	Company F	Marketing Manager
7	Company G	Product Manager
8	Company H	Engineer
9	Company I	Human Resources
10	Company J	Consultant
11	Company K	Customer Service
12	Company L	Support Engineer
13	Company M	Data Analyst
14	Company N	QA Engineer
15	Company O	Content Creator
16	Company P	IT Support
17	Company Q	DevOps Engineer
18	Company R	Financial Analyst
19	Company S	Software Developer
20	Company T	Project Manager
\.


--
-- Data for Name: recruiter; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recruiter (id, city, birth_date, family_status, base_salary, departmant_id) FROM stdin;
1	Tel Aviv	1980-01-01	Married	50000	1
2	Beersheba	1985-02-02	Single	55000	1
3	Jerusalem	1990-03-03	Married	60000	2
4	Herzliya	1995-04-04	Single	65000	2
\.


--
-- Data for Name: recruitment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recruitment (recruiter_id, applicant_id, recruitment_date) FROM stdin;
1	1	2022-11-25
1	2	2022-11-27
1	5	2022-11-26
2	7	2022-11-25
2	8	2022-11-27
3	13	2022-11-26
4	20	2022-11-24
1	3	2022-12-25
1	4	2022-12-27
2	6	2022-12-26
3	11	2022-12-25
3	12	2022-12-27
3	14	2022-12-26
4	16	2022-12-24
\.


--
-- Name: bonus Bonus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bonus
    ADD CONSTRAINT "Bonus_pkey" PRIMARY KEY (month);


--
-- Name: departmant Departmant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departmant
    ADD CONSTRAINT "Departmant_pkey" PRIMARY KEY (id);


--
-- Name: job Job_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job
    ADD CONSTRAINT "Job_pkey" PRIMARY KEY (id);


--
-- Name: recruiter Recruiter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recruiter
    ADD CONSTRAINT "Recruiter_pkey" PRIMARY KEY (id);


--
-- Name: applicant applicant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant
    ADD CONSTRAINT applicant_pkey PRIMARY KEY (id);


--
-- Name: recruiter FK_Recruiter.departmant_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recruiter
    ADD CONSTRAINT "FK_Recruiter.departmant_id" FOREIGN KEY (departmant_id) REFERENCES public.departmant(id);


--
-- Name: recruitment FK_Recruitment.recruiter_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recruitment
    ADD CONSTRAINT "FK_Recruitment.recruiter_id" FOREIGN KEY (recruiter_id) REFERENCES public.recruiter(id);


--
-- Name: applicant FK_applicant.recruiter_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant
    ADD CONSTRAINT "FK_applicant.recruiter_id" FOREIGN KEY (recruiter_id) REFERENCES public.recruiter(id);


--
-- PostgreSQL database dump complete
--

