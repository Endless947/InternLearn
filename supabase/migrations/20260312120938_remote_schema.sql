drop extension if exists "pg_net";

create sequence "public"."subject_id_seq";

create sequence "public"."subtopic_id_seq";


  create table "public"."chapter" (
    "id" integer generated always as identity not null,
    "subject_id" integer not null,
    "chapter_number" character varying(10) not null,
    "name" text not null
      );



  create table "public"."slide" (
    "id" integer generated always as identity not null,
    "subtopic_id" integer not null,
    "title" text not null,
    "order" integer not null,
    "body_md" jsonb not null,
    "key_points" jsonb not null
      );



  create table "public"."slide_match" (
    "id" integer generated always as identity not null,
    "question" text,
    "left_items" jsonb,
    "right_items" jsonb,
    "correct_pairs" jsonb,
    "explanation_md" text not null,
    "order" bigint,
    "subtopic_id" integer
      );



  create table "public"."slide_mcq" (
    "id" integer generated always as identity not null,
    "question_md" text not null,
    "option_a" text not null,
    "option_b" text not null,
    "option_c" text not null,
    "option_d" text not null,
    "correct_option" character(1) not null,
    "explanation_md" text not null,
    "order" integer not null,
    "subtopic_id" integer not null
      );



  create table "public"."subject" (
    "id" integer not null default nextval('public.subject_id_seq'::regclass),
    "name" character varying(255) not null,
    "description" text
      );



  create table "public"."subtopic" (
    "id" integer not null default nextval('public.subtopic_id_seq'::regclass),
    "title" character varying(255) not null,
    "topic_id" integer not null,
    "order" integer
      );



  create table "public"."topic" (
    "id" integer generated always as identity not null,
    "chapter_id" integer not null,
    "title" text not null
      );


alter sequence "public"."subject_id_seq" owned by "public"."subject"."id";

alter sequence "public"."subtopic_id_seq" owned by "public"."subtopic"."id";

CREATE UNIQUE INDEX chapter_pkey ON public.chapter USING btree (id);

CREATE UNIQUE INDEX slide_match_pkey ON public.slide_match USING btree (id);

CREATE UNIQUE INDEX slide_mcq_pkey ON public.slide_mcq USING btree (id);

CREATE UNIQUE INDEX slide_pkey ON public.slide USING btree (id);

CREATE UNIQUE INDEX subject_pkey ON public.subject USING btree (id);

CREATE UNIQUE INDEX subtopic_pkey ON public.subtopic USING btree (id);

CREATE UNIQUE INDEX topic_pkey ON public.topic USING btree (id);

alter table "public"."chapter" add constraint "chapter_pkey" PRIMARY KEY using index "chapter_pkey";

alter table "public"."slide" add constraint "slide_pkey" PRIMARY KEY using index "slide_pkey";

alter table "public"."slide_match" add constraint "slide_match_pkey" PRIMARY KEY using index "slide_match_pkey";

alter table "public"."slide_mcq" add constraint "slide_mcq_pkey" PRIMARY KEY using index "slide_mcq_pkey";

alter table "public"."subject" add constraint "subject_pkey" PRIMARY KEY using index "subject_pkey";

alter table "public"."subtopic" add constraint "subtopic_pkey" PRIMARY KEY using index "subtopic_pkey";

alter table "public"."topic" add constraint "topic_pkey" PRIMARY KEY using index "topic_pkey";

alter table "public"."chapter" add constraint "chapter_subject_fk" FOREIGN KEY (subject_id) REFERENCES public.subject(id) ON DELETE CASCADE not valid;

alter table "public"."chapter" validate constraint "chapter_subject_fk";

alter table "public"."slide" add constraint "slide_subtopic_fk" FOREIGN KEY (subtopic_id) REFERENCES public.subtopic(id) ON DELETE CASCADE not valid;

alter table "public"."slide" validate constraint "slide_subtopic_fk";

alter table "public"."slide_match" add constraint "slide_match_subtopic_id_fkey" FOREIGN KEY (subtopic_id) REFERENCES public.subtopic(id) not valid;

alter table "public"."slide_match" validate constraint "slide_match_subtopic_id_fkey";

alter table "public"."slide_mcq" add constraint "slide_mcq_correct_option_check" CHECK ((correct_option = ANY (ARRAY['a'::bpchar, 'b'::bpchar, 'c'::bpchar, 'd'::bpchar]))) not valid;

alter table "public"."slide_mcq" validate constraint "slide_mcq_correct_option_check";

alter table "public"."slide_mcq" add constraint "slide_mcq_subtopic_id_fkey" FOREIGN KEY (subtopic_id) REFERENCES public.subtopic(id) not valid;

alter table "public"."slide_mcq" validate constraint "slide_mcq_subtopic_id_fkey";

alter table "public"."subtopic" add constraint "subtopic_topic_id_fkey" FOREIGN KEY (topic_id) REFERENCES public.topic(id) not valid;

alter table "public"."subtopic" validate constraint "subtopic_topic_id_fkey";

alter table "public"."topic" add constraint "topic_chapter_fk" FOREIGN KEY (chapter_id) REFERENCES public.chapter(id) ON DELETE CASCADE not valid;

alter table "public"."topic" validate constraint "topic_chapter_fk";

grant delete on table "public"."chapter" to "anon";

grant insert on table "public"."chapter" to "anon";

grant references on table "public"."chapter" to "anon";

grant select on table "public"."chapter" to "anon";

grant trigger on table "public"."chapter" to "anon";

grant truncate on table "public"."chapter" to "anon";

grant update on table "public"."chapter" to "anon";

grant delete on table "public"."chapter" to "authenticated";

grant insert on table "public"."chapter" to "authenticated";

grant references on table "public"."chapter" to "authenticated";

grant select on table "public"."chapter" to "authenticated";

grant trigger on table "public"."chapter" to "authenticated";

grant truncate on table "public"."chapter" to "authenticated";

grant update on table "public"."chapter" to "authenticated";

grant delete on table "public"."chapter" to "service_role";

grant insert on table "public"."chapter" to "service_role";

grant references on table "public"."chapter" to "service_role";

grant select on table "public"."chapter" to "service_role";

grant trigger on table "public"."chapter" to "service_role";

grant truncate on table "public"."chapter" to "service_role";

grant update on table "public"."chapter" to "service_role";

grant delete on table "public"."slide" to "anon";

grant insert on table "public"."slide" to "anon";

grant references on table "public"."slide" to "anon";

grant select on table "public"."slide" to "anon";

grant trigger on table "public"."slide" to "anon";

grant truncate on table "public"."slide" to "anon";

grant update on table "public"."slide" to "anon";

grant delete on table "public"."slide" to "authenticated";

grant insert on table "public"."slide" to "authenticated";

grant references on table "public"."slide" to "authenticated";

grant select on table "public"."slide" to "authenticated";

grant trigger on table "public"."slide" to "authenticated";

grant truncate on table "public"."slide" to "authenticated";

grant update on table "public"."slide" to "authenticated";

grant delete on table "public"."slide" to "service_role";

grant insert on table "public"."slide" to "service_role";

grant references on table "public"."slide" to "service_role";

grant select on table "public"."slide" to "service_role";

grant trigger on table "public"."slide" to "service_role";

grant truncate on table "public"."slide" to "service_role";

grant update on table "public"."slide" to "service_role";

grant delete on table "public"."slide_match" to "anon";

grant insert on table "public"."slide_match" to "anon";

grant references on table "public"."slide_match" to "anon";

grant select on table "public"."slide_match" to "anon";

grant trigger on table "public"."slide_match" to "anon";

grant truncate on table "public"."slide_match" to "anon";

grant update on table "public"."slide_match" to "anon";

grant delete on table "public"."slide_match" to "authenticated";

grant insert on table "public"."slide_match" to "authenticated";

grant references on table "public"."slide_match" to "authenticated";

grant select on table "public"."slide_match" to "authenticated";

grant trigger on table "public"."slide_match" to "authenticated";

grant truncate on table "public"."slide_match" to "authenticated";

grant update on table "public"."slide_match" to "authenticated";

grant delete on table "public"."slide_match" to "service_role";

grant insert on table "public"."slide_match" to "service_role";

grant references on table "public"."slide_match" to "service_role";

grant select on table "public"."slide_match" to "service_role";

grant trigger on table "public"."slide_match" to "service_role";

grant truncate on table "public"."slide_match" to "service_role";

grant update on table "public"."slide_match" to "service_role";

grant delete on table "public"."slide_mcq" to "anon";

grant insert on table "public"."slide_mcq" to "anon";

grant references on table "public"."slide_mcq" to "anon";

grant select on table "public"."slide_mcq" to "anon";

grant trigger on table "public"."slide_mcq" to "anon";

grant truncate on table "public"."slide_mcq" to "anon";

grant update on table "public"."slide_mcq" to "anon";

grant delete on table "public"."slide_mcq" to "authenticated";

grant insert on table "public"."slide_mcq" to "authenticated";

grant references on table "public"."slide_mcq" to "authenticated";

grant select on table "public"."slide_mcq" to "authenticated";

grant trigger on table "public"."slide_mcq" to "authenticated";

grant truncate on table "public"."slide_mcq" to "authenticated";

grant update on table "public"."slide_mcq" to "authenticated";

grant delete on table "public"."slide_mcq" to "service_role";

grant insert on table "public"."slide_mcq" to "service_role";

grant references on table "public"."slide_mcq" to "service_role";

grant select on table "public"."slide_mcq" to "service_role";

grant trigger on table "public"."slide_mcq" to "service_role";

grant truncate on table "public"."slide_mcq" to "service_role";

grant update on table "public"."slide_mcq" to "service_role";

grant delete on table "public"."subject" to "anon";

grant insert on table "public"."subject" to "anon";

grant references on table "public"."subject" to "anon";

grant select on table "public"."subject" to "anon";

grant trigger on table "public"."subject" to "anon";

grant truncate on table "public"."subject" to "anon";

grant update on table "public"."subject" to "anon";

grant delete on table "public"."subject" to "authenticated";

grant insert on table "public"."subject" to "authenticated";

grant references on table "public"."subject" to "authenticated";

grant select on table "public"."subject" to "authenticated";

grant trigger on table "public"."subject" to "authenticated";

grant truncate on table "public"."subject" to "authenticated";

grant update on table "public"."subject" to "authenticated";

grant delete on table "public"."subject" to "service_role";

grant insert on table "public"."subject" to "service_role";

grant references on table "public"."subject" to "service_role";

grant select on table "public"."subject" to "service_role";

grant trigger on table "public"."subject" to "service_role";

grant truncate on table "public"."subject" to "service_role";

grant update on table "public"."subject" to "service_role";

grant delete on table "public"."subtopic" to "anon";

grant insert on table "public"."subtopic" to "anon";

grant references on table "public"."subtopic" to "anon";

grant select on table "public"."subtopic" to "anon";

grant trigger on table "public"."subtopic" to "anon";

grant truncate on table "public"."subtopic" to "anon";

grant update on table "public"."subtopic" to "anon";

grant delete on table "public"."subtopic" to "authenticated";

grant insert on table "public"."subtopic" to "authenticated";

grant references on table "public"."subtopic" to "authenticated";

grant select on table "public"."subtopic" to "authenticated";

grant trigger on table "public"."subtopic" to "authenticated";

grant truncate on table "public"."subtopic" to "authenticated";

grant update on table "public"."subtopic" to "authenticated";

grant delete on table "public"."subtopic" to "service_role";

grant insert on table "public"."subtopic" to "service_role";

grant references on table "public"."subtopic" to "service_role";

grant select on table "public"."subtopic" to "service_role";

grant trigger on table "public"."subtopic" to "service_role";

grant truncate on table "public"."subtopic" to "service_role";

grant update on table "public"."subtopic" to "service_role";

grant delete on table "public"."topic" to "anon";

grant insert on table "public"."topic" to "anon";

grant references on table "public"."topic" to "anon";

grant select on table "public"."topic" to "anon";

grant trigger on table "public"."topic" to "anon";

grant truncate on table "public"."topic" to "anon";

grant update on table "public"."topic" to "anon";

grant delete on table "public"."topic" to "authenticated";

grant insert on table "public"."topic" to "authenticated";

grant references on table "public"."topic" to "authenticated";

grant select on table "public"."topic" to "authenticated";

grant trigger on table "public"."topic" to "authenticated";

grant truncate on table "public"."topic" to "authenticated";

grant update on table "public"."topic" to "authenticated";

grant delete on table "public"."topic" to "service_role";

grant insert on table "public"."topic" to "service_role";

grant references on table "public"."topic" to "service_role";

grant select on table "public"."topic" to "service_role";

grant trigger on table "public"."topic" to "service_role";

grant truncate on table "public"."topic" to "service_role";

grant update on table "public"."topic" to "service_role";


