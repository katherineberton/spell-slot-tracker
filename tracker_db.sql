--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.1

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

ALTER TABLE ONLY public.slots DROP CONSTRAINT slots_spell_type_id_fkey;
ALTER TABLE ONLY public.slots DROP CONSTRAINT slots_day_id_fkey;
ALTER TABLE ONLY public.slots DROP CONSTRAINT slots_character_id_fkey;
ALTER TABLE ONLY public.days DROP CONSTRAINT days_character_id_fkey;
ALTER TABLE ONLY public.characters DROP CONSTRAINT characters_user_id_fkey;
ALTER TABLE ONLY public.characters_spells DROP CONSTRAINT characters_spells_spell_id_fkey;
ALTER TABLE ONLY public.characters_spells DROP CONSTRAINT characters_spells_character_id_fkey;
ALTER TABLE ONLY public.characters DROP CONSTRAINT characters_class_id_fkey;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
ALTER TABLE ONLY public.spells DROP CONSTRAINT spells_pkey;
ALTER TABLE ONLY public.slots DROP CONSTRAINT slots_pkey;
ALTER TABLE ONLY public.days DROP CONSTRAINT days_pkey;
ALTER TABLE ONLY public.classes DROP CONSTRAINT classes_pkey;
ALTER TABLE ONLY public.characters_spells DROP CONSTRAINT characters_spells_pkey;
ALTER TABLE ONLY public.characters DROP CONSTRAINT characters_pkey;
ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
ALTER TABLE public.spells ALTER COLUMN spell_type_id DROP DEFAULT;
ALTER TABLE public.slots ALTER COLUMN slot_id DROP DEFAULT;
ALTER TABLE public.days ALTER COLUMN day_id DROP DEFAULT;
ALTER TABLE public.classes ALTER COLUMN class_id DROP DEFAULT;
ALTER TABLE public.characters_spells ALTER COLUMN character_spell_id DROP DEFAULT;
ALTER TABLE public.characters ALTER COLUMN character_id DROP DEFAULT;
DROP SEQUENCE public.users_user_id_seq;
DROP TABLE public.users;
DROP SEQUENCE public.spells_spell_type_id_seq;
DROP TABLE public.spells;
DROP SEQUENCE public.slots_slot_id_seq;
DROP TABLE public.slots;
DROP SEQUENCE public.days_day_id_seq;
DROP TABLE public.days;
DROP SEQUENCE public.classes_class_id_seq;
DROP TABLE public.classes;
DROP SEQUENCE public.characters_spells_character_spell_id_seq;
DROP TABLE public.characters_spells;
DROP SEQUENCE public.characters_character_id_seq;
DROP TABLE public.characters;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: characters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.characters (
    character_id integer NOT NULL,
    user_id integer,
    class_id integer,
    character_level integer,
    character_name character varying(50) NOT NULL,
    created_date timestamp without time zone
);


--
-- Name: characters_character_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.characters_character_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: characters_character_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.characters_character_id_seq OWNED BY public.characters.character_id;


--
-- Name: characters_spells; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.characters_spells (
    character_spell_id integer NOT NULL,
    character_id integer NOT NULL,
    spell_id integer NOT NULL
);


--
-- Name: characters_spells_character_spell_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.characters_spells_character_spell_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: characters_spells_character_spell_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.characters_spells_character_spell_id_seq OWNED BY public.characters_spells.character_spell_id;


--
-- Name: classes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.classes (
    class_id integer NOT NULL,
    class_slug character varying(50) NOT NULL,
    class_name character varying(50)
);


--
-- Name: classes_class_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.classes_class_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: classes_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.classes_class_id_seq OWNED BY public.classes.class_id;


--
-- Name: days; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.days (
    day_id integer NOT NULL,
    day_reference character varying(100),
    first_session_date timestamp without time zone,
    character_id integer
);


--
-- Name: days_day_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.days_day_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: days_day_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.days_day_id_seq OWNED BY public.days.day_id;


--
-- Name: slots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.slots (
    slot_id integer NOT NULL,
    slot_reference character varying(300),
    spell_type_id integer,
    day_id integer,
    character_id integer,
    slot_level integer
);


--
-- Name: slots_slot_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.slots_slot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: slots_slot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.slots_slot_id_seq OWNED BY public.slots.slot_id;


--
-- Name: spells; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spells (
    spell_type_id integer NOT NULL,
    spell_slug character varying(100) NOT NULL,
    spell_name character varying(100),
    spell_level integer,
    spell_classes character varying(500),
    ritual character varying(10),
    concentration character varying(10)
);


--
-- Name: spells_spell_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spells_spell_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spells_spell_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spells_spell_type_id_seq OWNED BY public.spells.spell_type_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    email character varying(50) NOT NULL,
    password character varying(50) NOT NULL,
    created_date timestamp without time zone,
    name character varying(100) NOT NULL
);


--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: characters character_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters ALTER COLUMN character_id SET DEFAULT nextval('public.characters_character_id_seq'::regclass);


--
-- Name: characters_spells character_spell_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters_spells ALTER COLUMN character_spell_id SET DEFAULT nextval('public.characters_spells_character_spell_id_seq'::regclass);


--
-- Name: classes class_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classes ALTER COLUMN class_id SET DEFAULT nextval('public.classes_class_id_seq'::regclass);


--
-- Name: days day_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.days ALTER COLUMN day_id SET DEFAULT nextval('public.days_day_id_seq'::regclass);


--
-- Name: slots slot_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.slots ALTER COLUMN slot_id SET DEFAULT nextval('public.slots_slot_id_seq'::regclass);


--
-- Name: spells spell_type_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spells ALTER COLUMN spell_type_id SET DEFAULT nextval('public.spells_spell_type_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: characters; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.characters (character_id, user_id, class_id, character_level, character_name, created_date) FROM stdin;
2	1	4	8	Theo	2022-04-04 16:48:36.682701
1	1	3	10	Robin	2022-04-04 16:47:41.039393
3	1	12	11	Malachi Elisar Archimonde	2022-04-06 16:08:35.828278
4	1	7	14	Galadin	2022-04-06 17:37:31.492913
7	1	4	11	Kazan Spiedog	2022-04-09 13:50:53.037416
6	1	11	12	The Guy	2022-04-07 15:44:20.514168
5	1	2	10	Shmorlock	2022-04-06 17:37:53.407652
\.


--
-- Data for Name: characters_spells; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.characters_spells (character_spell_id, character_id, spell_id) FROM stdin;
2	1	147
3	1	265
4	1	273
8	2	223
9	2	40
11	1	247
12	3	203
13	3	188
16	6	96
17	6	188
18	2	265
20	7	147
21	7	94
22	5	306
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.classes (class_id, class_slug, class_name) FROM stdin;
1	barbarian	Barbarian
2	bard	Bard
3	cleric	Cleric
4	druid	Druid
5	fighter	Fighter
6	monk	Monk
7	paladin	Paladin
8	ranger	Ranger
9	rogue	Rogue
10	sorcerer	Sorcerer
11	warlock	Warlock
12	wizard	Wizard
13	multiclass	Multiclass
\.


--
-- Data for Name: days; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.days (day_id, day_reference, first_session_date, character_id) FROM stdin;
1	\N	2022-04-04 16:47:41.062991	1
2	\N	2022-04-04 16:48:36.707619	2
3	\N	2022-04-04 17:41:40.933335	1
4	\N	2022-04-04 17:42:36.200293	1
5	\N	2022-04-06 16:08:35.858492	3
6	\N	2022-04-06 17:37:31.520549	4
7	\N	2022-04-06 17:37:53.428283	5
8	\N	2022-04-07 15:43:30.708376	1
9	\N	2022-04-07 15:44:20.536297	6
10	\N	2022-04-07 15:44:53.261812	6
11	\N	2022-04-08 13:42:40.830173	1
12	\N	2022-04-09 13:50:53.067004	7
13	\N	2022-04-09 16:52:40.518654	3
14	\N	2022-04-09 18:26:23.205294	7
15	\N	2022-04-09 18:26:29.082949	3
16	\N	2022-04-10 12:37:14.411848	1
17	\N	2022-04-11 11:31:28.944584	1
18	\N	2022-04-11 11:33:15.86359	6
19	\N	2022-04-12 14:21:43.776228	5
20	\N	2022-04-12 14:22:25.014669	5
21	\N	2022-04-12 14:55:45.095561	1
\.


--
-- Data for Name: slots; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.slots (slot_id, slot_reference, spell_type_id, day_id, character_id, slot_level) FROM stdin;
2	\N	\N	1	1	1
3	\N	\N	1	1	1
4	\N	\N	1	1	1
6	\N	\N	1	1	2
7	\N	\N	1	1	2
9	\N	\N	1	1	3
10	\N	\N	1	1	3
12	\N	\N	1	1	4
13	\N	\N	1	1	4
15	\N	\N	1	1	5
17	\N	\N	2	2	1
18	\N	\N	2	2	1
19	\N	\N	2	2	1
22	\N	\N	2	2	2
23	\N	\N	2	2	3
24	\N	\N	2	2	3
25	\N	\N	2	2	3
27	\N	\N	2	2	4
20	\N	215	2	2	2
1	\N	148	1	1	1
5	\N	149	1	1	2
8	\N	259	1	1	3
11	\N	280	1	1	4
14	\N	196	1	1	5
28	\N	247	1	1	0
29	\N	273	1	1	0
30	\N	147	1	1	0
31	\N	265	1	1	0
32	\N	147	1	1	0
33	\N	147	1	1	0
34	\N	273	1	1	0
35	\N	265	1	1	0
37	\N	\N	3	1	1
38	\N	\N	3	1	1
39	\N	\N	3	1	1
41	\N	\N	3	1	2
42	\N	\N	3	1	2
44	\N	\N	3	1	3
45	\N	\N	3	1	3
47	\N	\N	3	1	4
48	\N	\N	3	1	4
50	\N	\N	3	1	5
36	\N	148	3	1	1
40	\N	70	3	1	2
43	\N	259	3	1	3
46	\N	264	3	1	4
49	\N	47	3	1	5
52	\N	\N	4	1	1
53	\N	\N	4	1	1
54	\N	\N	4	1	1
56	\N	\N	4	1	2
57	\N	\N	4	1	2
59	\N	\N	4	1	3
60	\N	\N	4	1	3
61	\N	\N	4	1	4
62	\N	\N	4	1	4
63	\N	\N	4	1	4
65	\N	\N	4	1	5
66	\N	265	2	2	0
67	\N	265	2	2	0
68	\N	147	2	2	0
26	\N	70	2	2	4
16	\N	106	2	2	1
21	\N	161	2	2	2
69	\N	\N	5	3	1
70	\N	\N	5	3	1
71	\N	\N	5	3	1
72	\N	\N	5	3	1
73	\N	\N	5	3	2
74	\N	\N	5	3	2
75	\N	\N	5	3	2
76	\N	\N	5	3	3
77	\N	\N	5	3	3
78	\N	\N	5	3	3
79	\N	\N	5	3	4
80	\N	\N	5	3	4
81	\N	\N	5	3	4
82	\N	\N	5	3	5
83	\N	\N	5	3	5
84	\N	\N	5	3	6
85	\N	\N	6	4	1
86	\N	\N	6	4	1
87	\N	\N	6	4	1
88	\N	\N	6	4	1
89	\N	\N	6	4	2
90	\N	\N	6	4	2
91	\N	\N	6	4	2
93	\N	\N	6	4	3
94	\N	\N	6	4	3
95	\N	\N	6	4	4
96	\N	\N	7	5	1
97	\N	\N	7	5	1
98	\N	\N	7	5	1
99	\N	\N	7	5	1
100	\N	\N	7	5	2
101	\N	\N	7	5	2
102	\N	\N	7	5	2
103	\N	\N	7	5	3
104	\N	\N	7	5	3
105	\N	\N	7	5	3
106	\N	\N	7	5	4
107	\N	\N	7	5	4
108	\N	\N	7	5	4
109	\N	\N	7	5	5
110	\N	\N	7	5	5
111	\N	\N	7	5	6
51	\N	148	4	1	1
55	\N	280	4	1	2
58	\N	259	4	1	3
64	\N	196	4	1	5
112	\N	273	4	1	0
113	\N	265	4	1	0
115	\N	\N	8	1	1
116	\N	\N	8	1	1
117	\N	\N	8	1	1
119	\N	\N	8	1	2
120	\N	\N	8	1	2
122	\N	\N	8	1	3
123	\N	\N	8	1	3
125	\N	\N	8	1	4
126	\N	\N	8	1	4
128	\N	\N	8	1	5
129	\N	157	9	6	5
130	\N	82	9	6	5
131	\N	\N	9	6	5
132	\N	\N	9	6	5
114	\N	147	8	1	1
118	\N	280	8	1	2
121	\N	259	8	1	3
124	\N	279	8	1	4
127	\N	196	8	1	5
136	\N	\N	11	1	1
137	\N	\N	11	1	1
138	\N	\N	11	1	1
140	\N	\N	11	1	2
141	\N	\N	11	1	2
143	\N	\N	11	1	3
144	\N	\N	11	1	3
146	\N	\N	11	1	4
147	\N	\N	11	1	4
149	\N	\N	11	1	5
150	\N	\N	5	3	1
133	\N	277	10	6	5
134	\N	157	10	6	5
153	\N	\N	12	7	1
154	\N	\N	12	7	1
155	\N	\N	12	7	1
156	\N	\N	12	7	1
160	\N	\N	12	7	3
161	\N	\N	12	7	3
162	\N	\N	12	7	3
163	\N	\N	12	7	4
164	\N	\N	12	7	4
165	\N	\N	12	7	4
166	\N	\N	12	7	5
167	\N	\N	12	7	5
168	\N	\N	12	7	6
157	\N	215	12	7	2
158	\N	185	12	7	2
159	\N	215	12	7	2
170	\N	\N	13	3	1
171	\N	\N	13	3	1
172	\N	\N	13	3	1
173	\N	\N	13	3	2
174	\N	\N	13	3	2
175	\N	\N	13	3	2
139	\N	280	11	1	2
142	\N	259	11	1	3
145	\N	280	11	1	4
92	smite	\N	6	4	3
151	\N	60	10	6	5
152	\N	157	10	6	5
176	\N	\N	13	3	3
177	\N	\N	13	3	3
178	\N	\N	13	3	3
179	\N	\N	13	3	4
180	\N	\N	13	3	4
181	\N	\N	13	3	4
182	\N	\N	13	3	5
183	\N	\N	13	3	5
184	\N	\N	13	3	6
169	\N	142	13	3	1
185	\N	\N	14	7	1
186	\N	\N	14	7	1
187	\N	\N	14	7	1
188	\N	\N	14	7	1
189	\N	\N	14	7	2
190	\N	\N	14	7	2
191	\N	\N	14	7	2
192	\N	\N	14	7	3
193	\N	\N	14	7	3
194	\N	\N	14	7	3
195	\N	\N	14	7	4
196	\N	\N	14	7	4
197	\N	\N	14	7	4
198	\N	\N	14	7	5
199	\N	\N	14	7	5
200	\N	\N	14	7	6
201	\N	\N	15	3	1
202	\N	\N	15	3	1
203	\N	\N	15	3	1
204	\N	\N	15	3	1
205	\N	\N	15	3	2
206	\N	\N	15	3	2
207	\N	\N	15	3	2
208	\N	\N	15	3	3
209	\N	\N	15	3	3
210	\N	\N	15	3	3
211	\N	\N	15	3	4
212	\N	\N	15	3	4
213	\N	\N	15	3	4
214	\N	\N	15	3	5
215	\N	\N	15	3	5
216	\N	\N	15	3	6
135	\N	148	11	1	1
148	\N	196	11	1	5
218	\N	\N	16	1	1
219	\N	\N	16	1	1
220	\N	\N	16	1	1
222	\N	\N	16	1	2
223	\N	\N	16	1	2
225	\N	\N	16	1	3
226	\N	\N	16	1	3
228	\N	\N	16	1	4
229	\N	\N	16	1	4
231	\N	\N	16	1	5
217	\N	148	16	1	1
221	\N	148	16	1	2
224	\N	259	16	1	3
227	\N	280	16	1	4
230	\N	196	16	1	5
233	\N	\N	17	1	1
234	\N	\N	17	1	1
235	\N	\N	17	1	1
236	\N	\N	17	1	2
237	\N	\N	17	1	2
238	\N	\N	17	1	2
240	\N	\N	17	1	3
241	\N	\N	17	1	3
242	\N	\N	17	1	4
243	\N	\N	17	1	4
244	\N	\N	17	1	4
245	\N	\N	17	1	5
246	\N	\N	17	1	5
247	\N	\N	10	6	5
248	\N	\N	10	6	5
249	\N	\N	10	6	5
250	\N	\N	18	6	5
251	\N	\N	18	6	5
252	\N	\N	18	6	5
232	\N	148	17	1	1
253	\N	273	17	1	0
254	\N	273	17	1	0
255	\N	147	17	1	0
256	\N	247	17	1	0
257	\N	265	17	1	0
258	\N	265	17	1	0
259	\N	273	17	1	0
260	\N	273	17	1	0
261	\N	147	17	1	0
262	\N	265	17	1	0
263	\N	247	17	1	0
264	\N	265	17	1	0
265	\N	247	17	1	0
266	\N	265	17	1	0
267	\N	273	17	1	0
239	\N	259	17	1	3
268	\N	273	17	1	0
269	\N	265	17	1	0
270	\N	265	17	1	0
271	\N	273	17	1	0
272	\N	247	17	1	0
273	\N	147	17	1	0
274	\N	273	17	1	0
275	\N	247	17	1	0
276	\N	273	17	1	0
277	\N	265	17	1	0
278	\N	147	17	1	0
279	\N	247	17	1	0
280	\N	273	17	1	0
281	\N	265	17	1	0
282	\N	147	17	1	0
283	\N	247	17	1	0
284	\N	\N	19	5	1
285	\N	\N	19	5	1
286	\N	\N	19	5	1
287	\N	\N	19	5	1
288	\N	\N	19	5	2
289	\N	\N	19	5	2
290	\N	\N	19	5	2
291	\N	\N	19	5	3
292	\N	\N	19	5	3
293	\N	\N	19	5	3
294	\N	\N	19	5	4
295	\N	\N	19	5	4
296	\N	\N	19	5	4
297	\N	\N	19	5	5
298	\N	\N	19	5	5
299	\N	\N	19	5	6
300	\N	\N	19	5	7
301	\N	\N	19	5	8
302	\N	225	19	5	9
303	\N	\N	20	5	1
304	\N	\N	20	5	1
305	\N	\N	20	5	1
306	\N	\N	20	5	1
307	\N	\N	20	5	2
308	\N	\N	20	5	2
309	\N	\N	20	5	2
310	\N	\N	20	5	3
311	\N	\N	20	5	3
312	\N	\N	20	5	3
313	\N	\N	20	5	4
314	\N	\N	20	5	4
315	\N	\N	20	5	4
316	\N	\N	20	5	5
317	\N	\N	20	5	5
318	\N	306	20	5	0
319	\N	\N	21	1	1
320	\N	\N	21	1	1
321	\N	\N	21	1	1
322	\N	\N	21	1	1
323	\N	\N	21	1	2
324	\N	\N	21	1	2
325	\N	\N	21	1	2
326	\N	\N	21	1	3
327	\N	\N	21	1	3
328	\N	\N	21	1	3
329	\N	\N	21	1	4
330	\N	\N	21	1	4
331	\N	\N	21	1	4
332	\N	\N	21	1	5
333	\N	\N	21	1	5
334	\N	247	21	1	0
335	\N	147	21	1	0
336	\N	265	21	1	0
337	\N	265	21	1	0
338	\N	273	21	1	0
339	\N	147	14	7	0
340	\N	94	14	7	0
341	\N	265	21	1	0
\.


--
-- Data for Name: spells; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.spells (spell_type_id, spell_slug, spell_name, spell_level, spell_classes, ritual, concentration) FROM stdin;
1	acid-arrow	Acid Arrow	2	druid, wizard	no	no
2	acid-splash	Acid Splash	0	sorcerer, wizard	no	no
3	aid	Aid	2	cleric, paladin	no	no
4	alarm	Alarm	1	ranger, ritual caster, wizard	yes	no
5	alter-self	Alter Self	2	sorcerer, wizard	no	yes
6	animal-friendship	Animal Friendship	1	bard, druid, ranger, ritual caster	no	no
7	animal-messenger	Animal Messenger	2	bard, druid, ranger, ritual caster	yes	no
8	animal-shapes	Animal Shapes	8	druid	no	yes
9	animate-dead	Animate Dead	3	cleric, wizard	no	no
10	animate-objects	Animate Objects	5	bard, sorcerer, wizard	no	yes
11	antilife-shell	Antilife Shell	5	druid	no	yes
12	antimagic-field	Antimagic Field	8	cleric, wizard	no	yes
13	antipathysympathy	Antipathy/Sympathy	8	druid, wizard	no	no
14	arcane-eye	Arcane Eye	4	cleric, wizard	no	yes
15	arcane-hand	Arcane Hand	5	wizard	no	yes
16	arcane-lock	Arcane Lock	2	wizard	no	no
17	arcane-sword	Arcane Sword	7	bard, wizard	no	yes
18	arcanists-magic-aura	Arcanist's Magic Aura	2	wizard	no	no
19	astral-projection	Astral Projection	9	cleric, warlock, wizard	no	no
20	augury	Augury	2	cleric, ritual caster	yes	no
21	awaken	Awaken	5	bard, druid	no	no
22	bane	Bane	1	bard, cleric, paladin	no	yes
23	banishment	Banishment	4	cleric, paladin, sorcerer, warlock, wizard	no	yes
24	barkskin	Barkskin	2	cleric, druid, ranger	no	yes
25	beacon-of-hope	Beacon of Hope	3	cleric, paladin	no	yes
26	bestow-curse	Bestow Curse	3	bard, cleric, wizard	no	yes
27	black-tentacles	Black Tentacles	4	warlock, wizard	no	yes
28	blade-barrier	Blade Barrier	6	cleric	no	yes
29	bless	Bless	1	cleric, paladin	no	yes
30	blight	Blight	4	druid, sorcerer, warlock, wizard	no	no
31	blindnessdeafness	Blindness/Deafness	2	bard, cleric, sorcerer, warlock, wizard	no	no
32	blink	Blink	3	cleric, sorcerer, warlock, wizard	no	no
33	blur	Blur	2	druid, sorcerer, wizard	no	yes
34	branding-smite	Branding Smite	2	paladin	no	yes
35	burning-hands	Burning Hands	1	cleric, sorcerer, warlock, wizard	no	no
36	call-lightning	Call Lightning	3	cleric, druid	no	yes
37	calm-emotions	Calm Emotions	2	bard, cleric, warlock	no	yes
38	chain-lightning	Chain Lightning	6	sorcerer, wizard	no	no
39	charm-person	Charm Person	1	bard, cleric, druid, sorcerer, warlock, wizard	no	no
40	chill-touch	Chill Touch	0	sorcerer, warlock, wizard	no	no
41	circle-of-death	Circle of Death	6	sorcerer, warlock, wizard	no	no
42	clairvoyance	Clairvoyance	3	bard, cleric, sorcerer, warlock, wizard	no	yes
43	clone	Clone	8	wizard	no	no
44	cloudkill	Cloudkill	5	druid, sorcerer, wizard	no	yes
45	color-spray	Color Spray	1	sorcerer, wizard	no	no
46	command	Command	1	cleric, paladin, warlock	no	no
47	commune	Commune	5	cleric, paladin, ritual caster	yes	no
48	commune-with-nature	Commune with Nature	5	druid, paladin, ranger, ritual caster	yes	no
49	comprehend-languages	Comprehend Languages	1	bard, ritual caster, sorcerer, warlock, wizard	yes	no
50	compulsion	Compulsion	4	bard	no	yes
51	cone-of-cold	Cone of Cold	5	druid, sorcerer, wizard	no	no
52	confusion	Confusion	4	bard, cleric, druid, sorcerer, wizard	no	yes
53	conjure-animals	Conjure Animals	3	druid, ranger	no	yes
54	conjure-celestial	Conjure Celestial	7	cleric	no	yes
55	conjure-elemental	Conjure Elemental	5	druid, wizard	no	yes
56	conjure-fey	Conjure Fey	6	druid, warlock	no	yes
57	conjure-minor-elementals	Conjure Minor Elementals	4	druid, wizard	no	yes
58	conjure-woodland-beings	Conjure Woodland Beings	4	druid, ranger	no	yes
59	contact-other-plane	Contact Other Plane	5	ritual caster, warlock, wizard	yes	no
60	contagion	Contagion	5	cleric, druid	no	no
61	contingency	Contingency	6	wizard	no	no
62	continual-flame	Continual Flame	2	cleric, wizard	no	no
63	control-water	Control Water	4	cleric, druid, wizard	no	yes
64	control-weather	Control Weather	8	cleric, druid, wizard	no	yes
65	counterspell	Counterspell	3	paladin, sorcerer, warlock, wizard	no	no
66	create-food-and-water	Create Food and Water	3	cleric, druid, paladin	no	no
67	create-undead	Create Undead	6	cleric, warlock, wizard	no	no
68	create-or-destroy-water	Create or Destroy Water	1	cleric, druid	no	no
69	creation	Creation	5	sorcerer, wizard	no	no
70	cure-wounds	Cure Wounds	1	bard, cleric, druid, paladin, ranger	no	no
71	dancing-lights	Dancing Lights	0	bard, sorcerer, wizard	no	yes
72	darkness	Darkness	2	druid, sorcerer, warlock, wizard	no	yes
73	darkvision	Darkvision	2	druid, ranger, sorcerer, wizard	no	no
74	daylight	Daylight	3	cleric, druid, paladin, ranger, sorcerer	no	no
75	death-ward	Death Ward	4	cleric, paladin	no	no
76	delayed-blast-fireball	Delayed Blast Fireball	7	sorcerer, wizard	no	yes
77	demiplane	Demiplane	8	warlock, wizard	no	no
78	detect-evil-and-good	Detect Evil and Good	1	cleric, paladin	no	yes
79	detect-magic	Detect Magic	1	bard, cleric, druid, paladin, ranger, ritual caster, sorcerer, wizard	yes	yes
80	detect-poison-and-disease	Detect Poison and Disease	1	cleric, druid, paladin, ranger, ritual caster	yes	yes
81	detect-thoughts	Detect Thoughts	2	bard, sorcerer, warlock, wizard	no	yes
82	dimension-door	Dimension Door	4	bard, cleric, paladin, sorcerer, warlock, wizard	no	no
83	disguise-self	Disguise Self	1	bard, cleric, sorcerer, wizard	no	no
84	disintegrate	Disintegrate	6	sorcerer, wizard	no	no
85	dispel-evil-and-good	Dispel Evil and Good	5	cleric, paladin	no	yes
86	dispel-magic	Dispel Magic	3	bard, cleric, druid, paladin, sorcerer, warlock, wizard	no	no
87	divination	Divination	4	cleric, druid, ritual caster	yes	no
88	divine-favor	Divine Favor	1	cleric, paladin	no	yes
89	divine-word	Divine Word	7	cleric	no	no
90	dominate-beast	Dominate Beast	4	cleric, druid, sorcerer, warlock	no	yes
91	dominate-monster	Dominate Monster	8	bard, sorcerer, warlock, wizard	no	yes
92	dominate-person	Dominate Person	5	bard, cleric, sorcerer, warlock, wizard	no	yes
93	dream	Dream	5	bard, druid, warlock, wizard	no	no
94	druidcraft	Druidcraft	0	druid	no	no
95	earthquake	Earthquake	8	cleric, druid, sorcerer	no	yes
96	eldritch-blast	Eldritch Blast	0	warlock	no	no
97	enhance-ability	Enhance Ability	2	bard, cleric, druid, sorcerer	no	yes
98	enlargereduce	Enlarge/Reduce	2	sorcerer, wizard	no	yes
99	entangle	Entangle	1	druid	no	yes
100	enthrall	Enthrall	2	bard, warlock	no	no
101	etherealness	Etherealness	7	bard, cleric, sorcerer, warlock, wizard	no	no
102	expeditious-retreat	Expeditious Retreat	1	sorcerer, warlock, wizard	no	yes
103	eye-bite	Eye bite	6	bard, sorcerer, warlock, wizard	no	yes
104	eyebite	Eyebite	6	bard, sorcerer, warlock, wizard	no	yes
105	fabricate	Fabricate	4	wizard	no	no
106	faerie-fire	Faerie Fire	1	bard, cleric, druid, warlock	no	yes
107	faithful-hound	Faithful Hound	4	wizard	no	no
108	false-life	False Life	1	sorcerer, wizard	no	no
109	fear	Fear	3	bard, sorcerer, warlock, wizard	no	yes
110	feather-fall	Feather Fall	1	bard, sorcerer, wizard	no	no
111	feeblemind	Feeblemind	8	bard, druid, warlock, wizard	no	no
112	find-familiar	Find Familiar	1	wizard	yes	no
113	find-steed	Find Steed	2	paladin	no	no
114	find-traps	Find Traps	2	cleric, druid, ranger	no	no
115	find-the-path	Find the Path	6	bard, cleric, druid	no	yes
116	finger-of-death	Finger of Death	7	sorcerer, warlock, wizard	no	no
117	fire-bolt	Fire Bolt	0	sorcerer, wizard	no	no
118	fire-shield	Fire Shield	4	warlock, wizard	no	no
119	fire-storm	Fire Storm	7	cleric, druid, sorcerer	no	no
120	fireball	Fireball	3	cleric, sorcerer, warlock, wizard	no	no
121	flame-blade	Flame Blade	2	druid	no	yes
122	flame-strike	Flame Strike	5	cleric, paladin, warlock	no	no
123	flaming-sphere	Flaming Sphere	2	cleric, druid, wizard	no	yes
124	flesh-to-stone	Flesh to Stone	6	warlock, wizard	no	yes
125	floating-disk	Floating Disk	1	ritual caster, wizard	yes	no
126	fly	Fly	3	sorcerer, warlock, wizard	no	yes
127	fog-cloud	Fog Cloud	1	cleric, druid, ranger, sorcerer, wizard	no	yes
128	forbiddance	Forbiddance	6	cleric, ritual caster	yes	no
129	forcecage	Forcecage	7	bard, warlock, wizard	no	no
130	foresight	Foresight	9	bard, druid, warlock, wizard	no	no
131	freedom-of-movement	Freedom of Movement	4	bard, cleric, druid, paladin, ranger	no	no
132	freezing-sphere	Freezing Sphere	6	wizard	no	no
133	gaseous-form	Gaseous Form	3	druid, sorcerer, warlock, wizard	no	yes
134	gate	Gate	9	cleric, sorcerer, wizard	no	yes
135	geas	Geas	5	bard, cleric, druid, paladin, wizard	no	no
136	gentle-repose	Gentle Repose	2	cleric, ritual caster, wizard	yes	no
137	giant-insect	Giant Insect	4	druid	no	yes
138	glibness	Glibness	8	bard, warlock	no	no
139	globe-of-invulnerability	Globe of Invulnerability	6	sorcerer, wizard	no	yes
140	glyph-of-warding	Glyph of Warding	3	bard, cleric, wizard	no	no
141	goodberry	Goodberry	1	druid, ranger	no	no
142	grease	Grease	1	wizard	no	no
143	greater-invisibility	Greater Invisibility	4	bard, druid, sorcerer, warlock, wizard	no	yes
144	greater-restoration	Greater Restoration	5	bard, cleric, druid	no	no
145	guardian-of-faith	Guardian of Faith	4	cleric	no	no
146	guards-and-wards	Guards and Wards	6	bard, wizard	no	no
147	guidance	Guidance	0	cleric, druid	no	yes
148	guiding-bolt	Guiding Bolt	1	cleric	no	no
149	gust-of-wind	Gust of Wind	2	cleric, druid, sorcerer, wizard	no	yes
150	hallow	Hallow	5	cleric, warlock	no	no
151	hallucinatory-terrain	Hallucinatory Terrain	4	bard, druid, warlock, wizard	no	no
152	harm	Harm	6	cleric	no	no
153	haste	Haste	3	druid, paladin, sorcerer, wizard	no	yes
154	heal	Heal	6	cleric, druid	no	no
155	healing-word	Healing Word	1	bard, cleric, druid	no	no
156	heat-metal	Heat Metal	2	bard, druid	no	yes
157	hellish-rebuke	Hellish Rebuke	1	paladin, warlock	no	no
158	heroes-feast	Heroes' Feast	6	cleric, druid	no	no
159	heroism	Heroism	1	bard, paladin	no	yes
160	hideous-laughter	Hideous Laughter	1	bard, warlock, wizard	no	yes
161	hold-monster	Hold Monster	5	bard, cleric, paladin, sorcerer, warlock, wizard	no	yes
162	hold-person	Hold Person	2	bard, cleric, druid, paladin, sorcerer, warlock, wizard	no	yes
163	holy-aura	Holy Aura	8	cleric	no	yes
164	hunters-mark	Hunter's Mark	1	paladin, ranger	no	yes
165	hypnotic-pattern	Hypnotic Pattern	3	bard, sorcerer, warlock, wizard	no	yes
166	ice-storm	Ice Storm	4	cleric, druid, paladin, sorcerer, wizard	no	no
167	identify	Identify	1	bard, cleric, ritual caster, wizard	yes	no
168	illusory-script	Illusory Script	1	bard, ritual caster, warlock, wizard	yes	no
169	imprisonment	Imprisonment	9	warlock, wizard	no	no
170	incendiary-cloud	Incendiary Cloud	8	sorcerer, wizard	no	yes
171	inflict-wounds	Inflict Wounds	1	cleric	no	no
172	insect-plague	Insect Plague	5	cleric, druid, sorcerer	no	yes
173	instant-summons	Instant Summons	6	ritual caster, wizard	yes	no
174	invisibility	Invisibility	2	bard, druid, sorcerer, warlock, wizard	no	yes
175	irresistible-dance	Irresistible Dance	6	bard, wizard	no	yes
176	jump	Jump	1	druid, ranger, sorcerer, wizard	no	no
177	knock	Knock	2	bard, sorcerer, wizard	no	no
178	legend-lore	Legend Lore	5	bard, cleric, wizard	no	no
179	lesser-restoration	Lesser Restoration	2	bard, cleric, druid, paladin, ranger	no	no
180	levitate	Levitate	2	sorcerer, wizard	no	yes
181	light	Light	0	bard, cleric, sorcerer, wizard	no	no
182	lightning-bolt	Lightning Bolt	3	druid, sorcerer, wizard	no	no
183	locate-animals-or-plants	Locate Animals or Plants	2	bard, druid, ranger, ritual caster	yes	no
184	locate-creature	Locate Creature	4	bard, cleric, druid, paladin, ranger, wizard	no	yes
185	locate-object	Locate Object	2	bard, cleric, druid, paladin, ranger, wizard	no	yes
186	longstrider	Longstrider	1	bard, druid, ranger, wizard	no	no
187	mage-armor	Mage Armor	1	sorcerer, wizard	no	no
188	mage-hand	Mage Hand	0	bard, sorcerer, warlock, wizard	no	no
189	magic-circle	Magic Circle	3	cleric, paladin, warlock, wizard	no	no
190	magic-jar	Magic Jar	6	wizard	no	no
191	magic-missile	Magic Missile	1	sorcerer, wizard	no	no
192	magic-mouth	Magic Mouth	2	bard, ritual caster, wizard	yes	no
193	magic-weapon	Magic Weapon	2	cleric, paladin, wizard	no	yes
194	magnificent-mansion	Magnificent Mansion	7	bard, wizard	no	no
195	major-image	Major Image	3	bard, sorcerer, warlock, wizard	no	yes
196	mass-cure-wounds	Mass Cure Wounds	5	bard, cleric, druid	no	no
197	mass-heal	Mass Heal	9	cleric	no	no
198	mass-healing-word	Mass Healing Word	3	cleric	no	no
199	mass-suggestion	Mass Suggestion	6	bard, sorcerer, warlock, wizard	no	no
200	maze	Maze	8	wizard	no	yes
201	meld-into-stone	Meld into Stone	3	cleric, druid, ritual caster	yes	no
202	mending	Mending	0	cleric, bard, druid, sorcerer, wizard	no	no
203	message	Message	0	bard, sorcerer, wizard	no	no
204	meteor-swarm	Meteor Swarm	9	sorcerer, wizard	no	no
205	mind-blank	Mind Blank	8	bard, wizard	no	no
206	minor-illusion	Minor Illusion	0	bard, sorcerer, warlock, wizard	no	no
207	mirage-arcane	Mirage Arcane	7	bard, druid, wizard	no	no
208	mirror-image	Mirror Image	2	cleric, druid, sorcerer, warlock, wizard	no	no
209	mislead	Mislead	5	bard, wizard	no	yes
210	misty-step	Misty Step	2	druid, paladin, sorcerer, warlock, wizard	no	no
211	modify-memory	Modify Memory	5	bard, cleric, wizard	no	yes
212	moonbeam	Moonbeam	2	druid, paladin	no	yes
213	move-earth	Move Earth	6	druid, sorcerer, wizard	no	yes
214	nondetection	Nondetection	3	bard, cleric, ranger, wizard	no	no
215	pass-without-trace	Pass without Trace	2	cleric, druid, ranger	no	yes
216	passwall	Passwall	5	druid, wizard	no	no
217	phantasmal-killer	Phantasmal Killer	4	wizard	no	yes
218	phantom-steed	Phantom Steed	3	ritual caster, wizard	yes	no
219	planar-ally	Planar Ally	6	cleric	no	no
220	planar-binding	Planar Binding	5	bard, cleric, druid, wizard	no	no
221	plane-shift	Plane Shift	7	cleric, sorcerer, warlock, wizard	no	no
222	plant-growth	Plant Growth	3	bard, cleric, druid, paladin, ranger, warlock	no	no
223	poison-spray	Poison Spray	0	druid, sorcerer, warlock, wizard	no	no
224	polymorph	Polymorph	4	bard, cleric, druid, sorcerer, wizard	no	yes
225	power-word-kill	Power Word Kill	9	bard, sorcerer, warlock, wizard	no	no
226	power-word-stun	Power Word Stun	8	bard, sorcerer, warlock, wizard	no	no
227	prayer-of-healing	Prayer of Healing	2	cleric	no	no
228	prestidigitation	Prestidigitation	0	bard, sorcerer, warlock, wizard	no	no
229	prismatic-spray	Prismatic Spray	7	sorcerer, wizard	no	no
230	prismatic-wall	Prismatic Wall	9	wizard	no	no
231	private-sanctum	Private Sanctum	4	wizard	no	no
232	produce-flame	Produce Flame	0	druid	no	no
233	programmed-illusion	Programmed Illusion	6	bard, wizard	no	no
234	project-image	Project Image	7	bard, wizard	no	yes
235	protection-from-energy	Protection from Energy	3	cleric, druid, paladin, ranger, sorcerer, wizard	no	yes
236	protection-from-evil-and-good	Protection from Evil and Good	1	cleric, paladin, warlock, wizard	no	yes
237	protection-from-poison	Protection from Poison	2	cleric, druid, paladin, ranger	no	no
238	purify-food-and-drink	Purify Food and Drink	1	cleric, druid, paladin, ritual caster	yes	no
239	raise-dead	Raise Dead	5	bard, cleric, paladin	no	no
240	ray-of-enfeeblement	Ray of Enfeeblement	2	warlock, wizard	no	yes
241	ray-of-frost	Ray of Frost	0	sorcerer, wizard	no	no
242	ray-of-sickness	Ray of Sickness	1	sorcerer, wizard	no	no
243	regenerate	Regenerate	7	bard, cleric, druid	no	no
244	reincarnate	Reincarnate	5	druid	no	no
245	remove-curse	Remove Curse	3	cleric, paladin, warlock, wizard	no	no
246	resilient-sphere	Resilient Sphere	4	wizard	no	yes
247	resistance	Resistance	0	cleric, druid	no	yes
248	resurrection	Resurrection	7	bard, cleric	no	no
249	reverse-gravity	Reverse Gravity	7	druid, sorcerer, wizard	no	yes
250	revivify	Revivify	3	cleric, paladin	no	no
251	rope-trick	Rope Trick	2	wizard	no	no
252	sacred-flame	Sacred Flame	0	cleric	no	no
253	sanctuary	Sanctuary	1	cleric, paladin	no	no
254	scorching-ray	Scorching Ray	2	cleric, sorcerer, warlock, wizard	no	no
255	scrying	Scrying	5	bard, cleric, druid, paladin, warlock, wizard	no	yes
256	secret-chest	Secret Chest	4	wizard	no	no
257	see-invisibility	See Invisibility	2	bard, sorcerer, wizard	no	no
258	seeming	Seeming	5	bard, sorcerer, warlock, wizard	no	no
259	sending	Sending	3	bard, cleric, warlock, wizard	no	no
260	sequester	Sequester	7	wizard	no	no
261	shapechange	Shapechange	9	druid, wizard	no	yes
262	shatter	Shatter	2	bard, cleric, sorcerer, warlock, wizard	no	no
263	shield	Shield	1	sorcerer, wizard	no	no
264	shield-of-faith	Shield of Faith	1	cleric, paladin	no	yes
265	shillelagh	Shillelagh	0	druid	no	no
266	shocking-grasp	Shocking Grasp	0	sorcerer, wizard	no	no
267	silence	Silence	2	bard, cleric, druid, ranger, ritual caster	yes	yes
268	silent-image	Silent Image	1	bard, sorcerer, wizard	no	yes
269	simulacrum	Simulacrum	7	wizard	no	no
270	sleep	Sleep	1	bard, sorcerer, warlock, wizard	no	no
271	sleet-storm	Sleet Storm	3	cleric, druid, sorcerer, wizard	no	yes
272	slow	Slow	3	druid, sorcerer, wizard	no	yes
273	spare-the-dying	Spare the Dying	0	cleric	no	no
274	speak-with-animals	Speak with Animals	1	bard, cleric, druid, paladin, ranger, ritual caster	yes	no
275	speak-with-dead	Speak with Dead	3	bard, cleric	no	no
276	speak-with-plants	Speak with Plants	3	bard, druid, ranger	no	no
277	spider-climb	Spider Climb	2	druid, sorcerer, warlock, wizard	no	yes
278	spike-growth	Spike Growth	2	cleric, druid, ranger	no	yes
279	spirit-guardians	Spirit Guardians	3	cleric	no	yes
280	spiritual-weapon	Spiritual Weapon	2	cleric	no	no
281	stinking-cloud	Stinking Cloud	3	bard, druid, sorcerer, warlock, wizard	no	yes
282	stone-shape	Stone Shape	4	cleric, druid, wizard	no	no
283	stoneskin	Stoneskin	4	cleric, druid, paladin, ranger, sorcerer, wizard	no	yes
284	storm-of-vengeance	Storm of Vengeance	9	druid	no	yes
285	suggestion	Suggestion	2	bard, cleric, sorcerer, warlock, wizard	no	yes
286	sunbeam	Sunbeam	6	druid, sorcerer, wizard	no	yes
287	sunburst	Sunburst	8	druid, sorcerer, wizard	no	no
288	symbol	Symbol	7	bard, cleric, wizard	no	no
289	telekinesis	Telekinesis	5	sorcerer, warlock, wizard	no	yes
290	telepathic-bond	Telepathic Bond	5	wizard	yes	no
291	teleport	Teleport	7	bard, sorcerer, wizard	no	no
292	teleportation-circle	Teleportation Circle	5	bard, sorcerer, wizard	no	no
293	thaumaturgy	Thaumaturgy	0	cleric	no	no
294	thunderwave	Thunderwave	1	bard, cleric, druid, sorcerer, wizard	no	no
295	time-stop	Time Stop	9	sorcerer, wizard	no	no
296	tiny-hut	Tiny Hut	3	bard, ritual caster, wizard	yes	no
297	tongues	Tongues	3	bard, cleric, sorcerer, warlock, wizard	no	no
298	transport-via-plants	Transport via Plants	6	druid	no	no
299	tree-stride	Tree Stride	5	cleric, druid, paladin, ranger	no	yes
300	true-polymorph	True Polymorph	9	bard, warlock, wizard	no	yes
301	true-resurrection	True Resurrection	9	cleric, druid	no	no
302	true-seeing	True Seeing	6	bard, cleric, sorcerer, warlock, wizard	no	no
303	true-strike	True Strike	0	bard, sorcerer, warlock, wizard	no	yes
304	unseen-servant	Unseen Servant	1	bard, ritual caster, warlock, wizard	yes	no
305	vampiric-touch	Vampiric Touch	3	warlock, wizard	no	yes
306	vicious-mockery	Vicious Mockery	0	bard	no	no
307	wall-of-fire	Wall of Fire	4	cleric, druid, sorcerer, warlock, wizard	no	yes
308	wall-of-force	Wall of Force	5	wizard	no	yes
309	wall-of-ice	Wall of Ice	6	wizard	no	yes
310	wall-of-stone	Wall of Stone	5	druid, sorcerer, wizard	no	yes
311	wall-of-thorns	Wall of Thorns	6	druid	no	yes
312	warding-bond	Warding Bond	2	cleric	no	no
313	water-breathing	Water Breathing	3	druid, ranger, ritual caster, sorcerer, wizard	yes	no
314	water-walk	Water Walk	3	cleric, druid, ranger, ritual caster, sorcerer	yes	no
315	web	Web	2	druid, sorcerer, wizard	no	yes
316	weird	Weird	9	wizard	no	yes
317	wind-walk	Wind Walk	6	druid	no	no
318	wind-wall	Wind Wall	3	cleric, druid, ranger	no	yes
319	wish	Wish	9	sorcerer, wizard	no	no
320	word-of-recall	Word of Recall	6	cleric	no	no
321	zone-of-truth	Zone of Truth	2	bard, cleric, paladin	no	no
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (user_id, email, password, created_date, name) FROM stdin;
1	kgberton@outlook.com	test	2022-04-04 16:47:28.871848	Kat
\.


--
-- Name: characters_character_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.characters_character_id_seq', 7, true);


--
-- Name: characters_spells_character_spell_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.characters_spells_character_spell_id_seq', 23, true);


--
-- Name: classes_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.classes_class_id_seq', 13, true);


--
-- Name: days_day_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.days_day_id_seq', 21, true);


--
-- Name: slots_slot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.slots_slot_id_seq', 341, true);


--
-- Name: spells_spell_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.spells_spell_type_id_seq', 321, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_user_id_seq', 1, true);


--
-- Name: characters characters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (character_id);


--
-- Name: characters_spells characters_spells_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters_spells
    ADD CONSTRAINT characters_spells_pkey PRIMARY KEY (character_spell_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (class_id);


--
-- Name: days days_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.days
    ADD CONSTRAINT days_pkey PRIMARY KEY (day_id);


--
-- Name: slots slots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.slots
    ADD CONSTRAINT slots_pkey PRIMARY KEY (slot_id);


--
-- Name: spells spells_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spells
    ADD CONSTRAINT spells_pkey PRIMARY KEY (spell_type_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: characters characters_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(class_id);


--
-- Name: characters_spells characters_spells_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters_spells
    ADD CONSTRAINT characters_spells_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(character_id);


--
-- Name: characters_spells characters_spells_spell_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters_spells
    ADD CONSTRAINT characters_spells_spell_id_fkey FOREIGN KEY (spell_id) REFERENCES public.spells(spell_type_id);


--
-- Name: characters characters_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: days days_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.days
    ADD CONSTRAINT days_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(character_id);


--
-- Name: slots slots_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.slots
    ADD CONSTRAINT slots_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(character_id);


--
-- Name: slots slots_day_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.slots
    ADD CONSTRAINT slots_day_id_fkey FOREIGN KEY (day_id) REFERENCES public.days(day_id);


--
-- Name: slots slots_spell_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.slots
    ADD CONSTRAINT slots_spell_type_id_fkey FOREIGN KEY (spell_type_id) REFERENCES public.spells(spell_type_id);


--
-- PostgreSQL database dump complete
--

