--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2 (Ubuntu 12.2-2.pgdg18.04+1)
-- Dumped by pg_dump version 12.2 (Ubuntu 12.2-2.pgdg18.04+1)

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
-- Name: art_image; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.art_image (
    article_id integer,
    image_id integer
);


ALTER TABLE public.art_image OWNER TO root;

--
-- Name: article_tags; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.article_tags (
    tag_id integer,
    article_id integer
);


ALTER TABLE public.article_tags OWNER TO root;

--
-- Name: articles; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.articles (
    article_id integer NOT NULL,
    created_date timestamp without time zone,
    author character varying,
    last_modify timestamp without time zone DEFAULT '2020-02-26 18:45:47.000421'::timestamp without time zone
);


ALTER TABLE public.articles OWNER TO root;

--
-- Name: articles_article_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.articles_article_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.articles_article_id_seq OWNER TO root;

--
-- Name: articles_article_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.articles_article_id_seq OWNED BY public.articles.article_id;


--
-- Name: articles_text; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.articles_text (
    article_id integer NOT NULL,
    article_title character varying,
    article_text text
);


ALTER TABLE public.articles_text OWNER TO root;

--
-- Name: images; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.images (
    image_id integer NOT NULL,
    image_filename character varying
);


ALTER TABLE public.images OWNER TO root;

--
-- Name: images_image_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.images_image_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.images_image_id_seq OWNER TO root;

--
-- Name: images_image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.images_image_id_seq OWNED BY public.images.image_id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.tags (
    tag_id integer NOT NULL,
    tag_name character varying
);


ALTER TABLE public.tags OWNER TO root;

--
-- Name: tags_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.tags_tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tags_tag_id_seq OWNER TO root;

--
-- Name: tags_tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.tags_tag_id_seq OWNED BY public.tags.tag_id;


--
-- Name: articles article_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.articles ALTER COLUMN article_id SET DEFAULT nextval('public.articles_article_id_seq'::regclass);


--
-- Name: images image_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.images ALTER COLUMN image_id SET DEFAULT nextval('public.images_image_id_seq'::regclass);


--
-- Name: tags tag_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.tags ALTER COLUMN tag_id SET DEFAULT nextval('public.tags_tag_id_seq'::regclass);


--
-- Data for Name: art_image; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.art_image (article_id, image_id) FROM stdin;
\.


--
-- Data for Name: article_tags; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.article_tags (tag_id, article_id) FROM stdin;
\.


--
-- Data for Name: articles; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.articles (article_id, created_date, author, last_modify) FROM stdin;
\.


--
-- Data for Name: articles_text; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.articles_text (article_id, article_title, article_text) FROM stdin;
\.


--
-- Data for Name: images; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.images (image_id, image_filename) FROM stdin;
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.tags (tag_id, tag_name) FROM stdin;
\.


--
-- Name: articles_article_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.articles_article_id_seq', 1, false);


--
-- Name: images_image_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.images_image_id_seq', 1, false);


--
-- Name: tags_tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.tags_tag_id_seq', 1, false);


--
-- Name: articles articles_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (article_id);


--
-- Name: articles_text articles_text_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.articles_text
    ADD CONSTRAINT articles_text_pkey PRIMARY KEY (article_id);


--
-- Name: images images_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_pkey PRIMARY KEY (image_id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (tag_id);


--
-- Name: art_image art_image_article_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.art_image
    ADD CONSTRAINT art_image_article_id_fkey FOREIGN KEY (article_id) REFERENCES public.articles(article_id);


--
-- Name: art_image art_image_article_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.art_image
    ADD CONSTRAINT art_image_article_id_fkey1 FOREIGN KEY (article_id) REFERENCES public.articles(article_id);


--
-- Name: art_image art_image_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.art_image
    ADD CONSTRAINT art_image_image_id_fkey FOREIGN KEY (image_id) REFERENCES public.images(image_id);


--
-- Name: art_image art_image_image_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.art_image
    ADD CONSTRAINT art_image_image_id_fkey1 FOREIGN KEY (image_id) REFERENCES public.images(image_id);


--
-- Name: article_tags article_tags_article_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.article_tags
    ADD CONSTRAINT article_tags_article_id_fkey FOREIGN KEY (article_id) REFERENCES public.articles(article_id);


--
-- Name: article_tags article_tags_article_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.article_tags
    ADD CONSTRAINT article_tags_article_id_fkey1 FOREIGN KEY (article_id) REFERENCES public.articles(article_id);


--
-- Name: article_tags article_tags_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.article_tags
    ADD CONSTRAINT article_tags_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tags(tag_id);


--
-- Name: article_tags article_tags_tag_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.article_tags
    ADD CONSTRAINT article_tags_tag_id_fkey1 FOREIGN KEY (tag_id) REFERENCES public.tags(tag_id);


--
-- Name: articles_text articles_text_article_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.articles_text
    ADD CONSTRAINT articles_text_article_id_fkey FOREIGN KEY (article_id) REFERENCES public.articles(article_id);


--
-- Name: articles_text articles_text_article_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.articles_text
    ADD CONSTRAINT articles_text_article_id_fkey1 FOREIGN KEY (article_id) REFERENCES public.articles(article_id);


--
-- PostgreSQL database dump complete
--

