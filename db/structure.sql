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
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


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
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comments (
    id bigint NOT NULL,
    task_id bigint NOT NULL,
    user_id bigint NOT NULL,
    value text DEFAULT ''::text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: contests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contests (
    id bigint NOT NULL,
    display_name character varying,
    content text,
    registration_open boolean DEFAULT false NOT NULL,
    task_open boolean DEFAULT false NOT NULL,
    upload_open boolean DEFAULT false NOT NULL,
    archived boolean DEFAULT false NOT NULL,
    registration_secret public.citext,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    cities character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    contest_sites character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    judge_password character varying NOT NULL,
    archive_open boolean DEFAULT false NOT NULL,
    institutions character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    statistic_open boolean DEFAULT false NOT NULL,
    main_judge character varying DEFAULT ''::character varying NOT NULL,
    head_of_organizing_committee character varying DEFAULT ''::character varying NOT NULL,
    secretary_of_organizing_committee character varying DEFAULT ''::character varying NOT NULL,
    head_of_appeal_commission character varying DEFAULT ''::character varying NOT NULL,
    info text DEFAULT ''::text NOT NULL,
    orgcom_password character varying NOT NULL
);


--
-- Name: contests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contests_id_seq OWNED BY public.contests.id;


--
-- Name: criterion_user_results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.criterion_user_results (
    id bigint NOT NULL,
    criterion_id bigint NOT NULL,
    user_id bigint NOT NULL,
    value double precision DEFAULT 0.0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: criterion_user_results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.criterion_user_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: criterion_user_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.criterion_user_results_id_seq OWNED BY public.criterion_user_results.id;


--
-- Name: criterions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.criterions (
    id bigint NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    "position" integer NOT NULL,
    "limit" double precision DEFAULT 0.0 NOT NULL,
    task_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: criterions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.criterions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: criterions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.criterions_id_seq OWNED BY public.criterions.id;


--
-- Name: results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.results (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    task_id bigint NOT NULL,
    score double precision DEFAULT 0.0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.results_id_seq OWNED BY public.results.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: solutions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solutions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    task_id bigint NOT NULL,
    ips inet[] DEFAULT '{}'::inet[] NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    upload_number integer DEFAULT 1 NOT NULL,
    device_id uuid
);


--
-- Name: solutions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solutions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solutions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solutions_id_seq OWNED BY public.solutions.id;


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tasks (
    id bigint NOT NULL,
    display_name character varying,
    file_names character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    upload_limit integer DEFAULT 1 NOT NULL,
    contest_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    criterions_count integer DEFAULT 0 NOT NULL,
    scoring_open boolean DEFAULT true NOT NULL,
    judges character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    result_multiplier character varying DEFAULT '1'::character varying NOT NULL
);


--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    contest_id bigint NOT NULL,
    name public.citext,
    email public.citext,
    region character varying,
    city character varying,
    institution character varying,
    contest_site character varying,
    grade integer,
    secret public.citext,
    registration_ips inet[] DEFAULT '{}'::inet[] NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    device_id uuid,
    judge_secret character varying NOT NULL,
    absent boolean DEFAULT false NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: contests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contests ALTER COLUMN id SET DEFAULT nextval('public.contests_id_seq'::regclass);


--
-- Name: criterion_user_results id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.criterion_user_results ALTER COLUMN id SET DEFAULT nextval('public.criterion_user_results_id_seq'::regclass);


--
-- Name: criterions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.criterions ALTER COLUMN id SET DEFAULT nextval('public.criterions_id_seq'::regclass);


--
-- Name: results id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.results ALTER COLUMN id SET DEFAULT nextval('public.results_id_seq'::regclass);


--
-- Name: solutions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solutions ALTER COLUMN id SET DEFAULT nextval('public.solutions_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: contests contests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contests
    ADD CONSTRAINT contests_pkey PRIMARY KEY (id);


--
-- Name: criterion_user_results criterion_user_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.criterion_user_results
    ADD CONSTRAINT criterion_user_results_pkey PRIMARY KEY (id);


--
-- Name: criterions criterions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.criterions
    ADD CONSTRAINT criterions_pkey PRIMARY KEY (id);


--
-- Name: criterions criterions_position_and_task_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.criterions
    ADD CONSTRAINT criterions_position_and_task_id_unique UNIQUE ("position", task_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: results results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT results_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: solutions solutions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT solutions_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_comments_on_task_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_task_id ON public.comments USING btree (task_id);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_user_id ON public.comments USING btree (user_id);


--
-- Name: index_comments_on_user_id_and_task_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_comments_on_user_id_and_task_id ON public.comments USING btree (user_id, task_id);


--
-- Name: index_criterion_user_results_on_criterion_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_criterion_user_results_on_criterion_id ON public.criterion_user_results USING btree (criterion_id);


--
-- Name: index_criterion_user_results_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_criterion_user_results_on_user_id ON public.criterion_user_results USING btree (user_id);


--
-- Name: index_criterion_user_results_on_user_id_and_criterion_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_criterion_user_results_on_user_id_and_criterion_id ON public.criterion_user_results USING btree (user_id, criterion_id);


--
-- Name: index_criterions_on_task_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_criterions_on_task_id ON public.criterions USING btree (task_id);


--
-- Name: index_results_on_task_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_results_on_task_id ON public.results USING btree (task_id);


--
-- Name: index_results_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_results_on_user_id ON public.results USING btree (user_id);


--
-- Name: index_results_on_user_id_and_task_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_results_on_user_id_and_task_id ON public.results USING btree (user_id, task_id);


--
-- Name: index_solutions_on_task_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_task_id ON public.solutions USING btree (task_id);


--
-- Name: index_solutions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_user_id ON public.solutions USING btree (user_id);


--
-- Name: index_solutions_on_user_id_and_task_id_and_upload_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solutions_on_user_id_and_task_id_and_upload_number ON public.solutions USING btree (user_id, task_id, upload_number);


--
-- Name: index_tasks_on_contest_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tasks_on_contest_id ON public.tasks USING btree (contest_id);


--
-- Name: index_users_on_contest_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_contest_id ON public.users USING btree (contest_id);


--
-- Name: index_users_on_contest_id_and_judge_secret; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_contest_id_and_judge_secret ON public.users USING btree (contest_id, judge_secret);


--
-- Name: index_users_on_contest_id_and_secret; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_contest_id_and_secret ON public.users USING btree (contest_id, secret);


--
-- Name: comments fk_rails_03de2dc08c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_rails_03de2dc08c FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: users fk_rails_433e96af6f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_433e96af6f FOREIGN KEY (contest_id) REFERENCES public.contests(id);


--
-- Name: comments fk_rails_6bd05453df; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_rails_6bd05453df FOREIGN KEY (task_id) REFERENCES public.tasks(id);


--
-- Name: results fk_rails_7f0d5a2cd6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT fk_rails_7f0d5a2cd6 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: results fk_rails_844020b6a3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT fk_rails_844020b6a3 FOREIGN KEY (task_id) REFERENCES public.tasks(id);


--
-- Name: solutions fk_rails_8f3c6a6975; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT fk_rails_8f3c6a6975 FOREIGN KEY (task_id) REFERENCES public.tasks(id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: criterion_user_results fk_rails_cd859372af; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.criterion_user_results
    ADD CONSTRAINT fk_rails_cd859372af FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: criterions fk_rails_d96b0f1290; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.criterions
    ADD CONSTRAINT fk_rails_d96b0f1290 FOREIGN KEY (task_id) REFERENCES public.tasks(id);


--
-- Name: criterion_user_results fk_rails_ddb05f7bb3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.criterion_user_results
    ADD CONSTRAINT fk_rails_ddb05f7bb3 FOREIGN KEY (criterion_id) REFERENCES public.criterions(id);


--
-- Name: tasks fk_rails_edc6cc160a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT fk_rails_edc6cc160a FOREIGN KEY (contest_id) REFERENCES public.contests(id);


--
-- Name: solutions fk_rails_f83c42cef4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT fk_rails_f83c42cef4 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20250119185329'),
('20250119125736'),
('20250113065202'),
('20240211194031'),
('20240203172343'),
('20231110173126'),
('20230930203405'),
('20230902145309'),
('20230902145308'),
('20230902145307'),
('20230630172057'),
('20230630170753'),
('20230121191926'),
('20221019173456'),
('20221017111524'),
('20221017055914'),
('20220622205527'),
('20220622205515'),
('20220217094714'),
('20220209182545'),
('20220206140244'),
('20220206140046'),
('20220205114432'),
('20220205113405'),
('20220202205558'),
('20220129173742'),
('20220129165359'),
('20220129140422'),
('20220115134157'),
('20220115123114'),
('20220115120555'),
('20211017195715'),
('20211017194323'),
('20211009212035'),
('20211009162515'),
('20211009111745'),
('20211009111010'),
('20211009105457'),
('20211009105135'),
('20211009104015'),
('20211009102612'),
('20211009102503');
