PGDMP  :                    }            EletechTrack    17.4    17.4 X    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            �           1262    33497    EletechTrack    DATABASE     t   CREATE DATABASE "EletechTrack" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en-US';
    DROP DATABASE "EletechTrack";
                     postgres    false            �            1255    33552 x   safe_insert_student(character varying, character varying, character varying, date, character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.safe_insert_student(p_first_name character varying, p_last_name character varying, p_gender character varying, p_birthdate date, p_contact_number character varying, p_course_name character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_course_id INTEGER;
    v_student_id INTEGER;
BEGIN
    -- Get course_id from course_name
    SELECT course_id INTO v_course_id 
    FROM courses 
    WHERE course_name = p_course_name;
    
    -- Check if course exists
    IF v_course_id IS NULL THEN
        RAISE EXCEPTION 'Course "%" does not exist', p_course_name;
    END IF;
    
    -- Insert student
    INSERT INTO students (first_name, last_name, gender, birthdate, contact_number, course_id)
    VALUES (p_first_name, p_last_name, p_gender, p_birthdate, p_contact_number, v_course_id)
    RETURNING student_id INTO v_student_id;
    
    RETURN v_student_id;
END;
$$;
 �   DROP FUNCTION public.safe_insert_student(p_first_name character varying, p_last_name character varying, p_gender character varying, p_birthdate date, p_contact_number character varying, p_course_name character varying);
       public               postgres    false            �            1255    33550    set_course_id_from_student()    FUNCTION       CREATE FUNCTION public.set_course_id_from_student() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.course_id IS NULL THEN
        SELECT course_id INTO NEW.course_id FROM students WHERE student_id = NEW.student_id;
    END IF;
    RETURN NEW;
END;
$$;
 3   DROP FUNCTION public.set_course_id_from_student();
       public               postgres    false            �            1255    33618    update_updated_at_column()    FUNCTION     �   CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$;
 1   DROP FUNCTION public.update_updated_at_column();
       public               postgres    false            �            1259    33594    assessments    TABLE     �  CREATE TABLE public.assessments (
    assessment_id integer NOT NULL,
    student_id integer NOT NULL,
    course_id integer NOT NULL,
    assessment_title character varying(255) NOT NULL,
    date_conducted date NOT NULL,
    status character varying(50) NOT NULL,
    result character varying(50),
    score character varying(50),
    assessor character varying(255),
    tries character varying(10),
    remarks text,
    certification_status character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT assessments_certification_status_check CHECK (((certification_status)::text = ANY ((ARRAY['Issued'::character varying, 'Not Issued'::character varying, 'Pending'::character varying])::text[]))),
    CONSTRAINT assessments_result_check CHECK (((result)::text = ANY ((ARRAY['COMPETENT'::character varying, 'NOT YET COMPETENT'::character varying, 'N/A'::character varying, 'To be assessed'::character varying])::text[]))),
    CONSTRAINT assessments_status_check CHECK (((status)::text = ANY ((ARRAY['Scheduled'::character varying, 'Completed'::character varying, 'Cancelled'::character varying, 'To be assessed'::character varying])::text[]))),
    CONSTRAINT assessments_tries_check CHECK (((tries)::text = ANY ((ARRAY['1st'::character varying, '2nd'::character varying, '3rd'::character varying])::text[])))
);
    DROP TABLE public.assessments;
       public         heap r       postgres    false            �            1259    33593    assessments_assessment_id_seq    SEQUENCE     �   CREATE SEQUENCE public.assessments_assessment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.assessments_assessment_id_seq;
       public               postgres    false    228            �           0    0    assessments_assessment_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.assessments_assessment_id_seq OWNED BY public.assessments.assessment_id;
          public               postgres    false    227            �            1259    33522 
   attendance    TABLE     �  CREATE TABLE public.attendance (
    attendance_id integer NOT NULL,
    student_id integer NOT NULL,
    course_id integer NOT NULL,
    attendance_date date NOT NULL,
    status character varying(20) NOT NULL,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT attendance_status_check CHECK (((status)::text = ANY ((ARRAY['Present'::character varying, 'Absent'::character varying, 'Late'::character varying])::text[])))
);
    DROP TABLE public.attendance;
       public         heap r       postgres    false            �            1259    33521    attendance_attendance_id_seq    SEQUENCE     �   CREATE SEQUENCE public.attendance_attendance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.attendance_attendance_id_seq;
       public               postgres    false    222            �           0    0    attendance_attendance_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.attendance_attendance_id_seq OWNED BY public.attendance.attendance_id;
          public               postgres    false    221            �            1259    33656    certifications    TABLE     ;  CREATE TABLE public.certifications (
    certification_id integer NOT NULL,
    student_id integer NOT NULL,
    course_id integer NOT NULL,
    certificate_number character varying(50) NOT NULL,
    certification_date date NOT NULL,
    status character varying(20) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT certifications_status_check CHECK (((status)::text = ANY ((ARRAY['Issued'::character varying, 'Pending'::character varying])::text[])))
);
 "   DROP TABLE public.certifications;
       public         heap r       postgres    false            �            1259    33655 #   certifications_certification_id_seq    SEQUENCE     �   CREATE SEQUENCE public.certifications_certification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 :   DROP SEQUENCE public.certifications_certification_id_seq;
       public               postgres    false    232            �           0    0 #   certifications_certification_id_seq    SEQUENCE OWNED BY     k   ALTER SEQUENCE public.certifications_certification_id_seq OWNED BY public.certifications.certification_id;
          public               postgres    false    231            �            1259    33499    courses    TABLE     �   CREATE TABLE public.courses (
    course_id integer NOT NULL,
    course_name character varying(255) NOT NULL,
    course_description text
);
    DROP TABLE public.courses;
       public         heap r       postgres    false            �            1259    33498    courses_course_id_seq    SEQUENCE     �   CREATE SEQUENCE public.courses_course_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.courses_course_id_seq;
       public               postgres    false    218            �           0    0    courses_course_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.courses_course_id_seq OWNED BY public.courses.course_id;
          public               postgres    false    217            �            1259    33554    modules    TABLE     :  CREATE TABLE public.modules (
    module_id integer NOT NULL,
    course_id integer NOT NULL,
    module_name character varying(255) NOT NULL,
    module_description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.modules;
       public         heap r       postgres    false            �            1259    33553    modules_module_id_seq    SEQUENCE     �   CREATE SEQUENCE public.modules_module_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.modules_module_id_seq;
       public               postgres    false    224            �           0    0    modules_module_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.modules_module_id_seq OWNED BY public.modules.module_id;
          public               postgres    false    223            �            1259    33627 	   registrar    TABLE     �   CREATE TABLE public.registrar (
    registrar_id integer NOT NULL,
    username character varying(100),
    password character varying(100)
);
    DROP TABLE public.registrar;
       public         heap r       postgres    false            �            1259    33626    registrar_registrar_id_seq    SEQUENCE     �   CREATE SEQUENCE public.registrar_registrar_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.registrar_registrar_id_seq;
       public               postgres    false    230            �           0    0    registrar_registrar_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.registrar_registrar_id_seq OWNED BY public.registrar.registrar_id;
          public               postgres    false    229            �            1259    33572    student_module_progress    TABLE     a  CREATE TABLE public.student_module_progress (
    progress_id integer NOT NULL,
    student_id integer NOT NULL,
    module_id integer NOT NULL,
    is_completed boolean DEFAULT false,
    completion_date date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
 +   DROP TABLE public.student_module_progress;
       public         heap r       postgres    false            �            1259    33571 '   student_module_progress_progress_id_seq    SEQUENCE     �   CREATE SEQUENCE public.student_module_progress_progress_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 >   DROP SEQUENCE public.student_module_progress_progress_id_seq;
       public               postgres    false    226            �           0    0 '   student_module_progress_progress_id_seq    SEQUENCE OWNED BY     s   ALTER SEQUENCE public.student_module_progress_progress_id_seq OWNED BY public.student_module_progress.progress_id;
          public               postgres    false    225            �            1259    33508    students    TABLE     $  CREATE TABLE public.students (
    student_id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    gender character varying(20) NOT NULL,
    birthdate date NOT NULL,
    contact_number character varying(12),
    course_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT students_gender_check CHECK (((gender)::text = ANY ((ARRAY['Male'::character varying, 'Female'::character varying, 'Other'::character varying])::text[])))
);
    DROP TABLE public.students;
       public         heap r       postgres    false            �            1259    33507    students_student_id_seq    SEQUENCE     �   CREATE SEQUENCE public.students_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.students_student_id_seq;
       public               postgres    false    220            �           0    0    students_student_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.students_student_id_seq OWNED BY public.students.student_id;
          public               postgres    false    219            �           2604    33597    assessments assessment_id    DEFAULT     �   ALTER TABLE ONLY public.assessments ALTER COLUMN assessment_id SET DEFAULT nextval('public.assessments_assessment_id_seq'::regclass);
 H   ALTER TABLE public.assessments ALTER COLUMN assessment_id DROP DEFAULT;
       public               postgres    false    227    228    228            �           2604    33525    attendance attendance_id    DEFAULT     �   ALTER TABLE ONLY public.attendance ALTER COLUMN attendance_id SET DEFAULT nextval('public.attendance_attendance_id_seq'::regclass);
 G   ALTER TABLE public.attendance ALTER COLUMN attendance_id DROP DEFAULT;
       public               postgres    false    221    222    222            �           2604    33659    certifications certification_id    DEFAULT     �   ALTER TABLE ONLY public.certifications ALTER COLUMN certification_id SET DEFAULT nextval('public.certifications_certification_id_seq'::regclass);
 N   ALTER TABLE public.certifications ALTER COLUMN certification_id DROP DEFAULT;
       public               postgres    false    232    231    232            �           2604    33502    courses course_id    DEFAULT     v   ALTER TABLE ONLY public.courses ALTER COLUMN course_id SET DEFAULT nextval('public.courses_course_id_seq'::regclass);
 @   ALTER TABLE public.courses ALTER COLUMN course_id DROP DEFAULT;
       public               postgres    false    218    217    218            �           2604    33557    modules module_id    DEFAULT     v   ALTER TABLE ONLY public.modules ALTER COLUMN module_id SET DEFAULT nextval('public.modules_module_id_seq'::regclass);
 @   ALTER TABLE public.modules ALTER COLUMN module_id DROP DEFAULT;
       public               postgres    false    224    223    224            �           2604    33630    registrar registrar_id    DEFAULT     �   ALTER TABLE ONLY public.registrar ALTER COLUMN registrar_id SET DEFAULT nextval('public.registrar_registrar_id_seq'::regclass);
 E   ALTER TABLE public.registrar ALTER COLUMN registrar_id DROP DEFAULT;
       public               postgres    false    230    229    230            �           2604    33575 #   student_module_progress progress_id    DEFAULT     �   ALTER TABLE ONLY public.student_module_progress ALTER COLUMN progress_id SET DEFAULT nextval('public.student_module_progress_progress_id_seq'::regclass);
 R   ALTER TABLE public.student_module_progress ALTER COLUMN progress_id DROP DEFAULT;
       public               postgres    false    225    226    226            �           2604    33511    students student_id    DEFAULT     z   ALTER TABLE ONLY public.students ALTER COLUMN student_id SET DEFAULT nextval('public.students_student_id_seq'::regclass);
 B   ALTER TABLE public.students ALTER COLUMN student_id DROP DEFAULT;
       public               postgres    false    220    219    220            �          0    33594    assessments 
   TABLE DATA           �   COPY public.assessments (assessment_id, student_id, course_id, assessment_title, date_conducted, status, result, score, assessor, tries, remarks, certification_status, created_at, updated_at) FROM stdin;
    public               postgres    false    228   �       �          0    33522 
   attendance 
   TABLE DATA           v   COPY public.attendance (attendance_id, student_id, course_id, attendance_date, status, notes, created_at) FROM stdin;
    public               postgres    false    222   ��       �          0    33656    certifications 
   TABLE DATA           �   COPY public.certifications (certification_id, student_id, course_id, certificate_number, certification_date, status, created_at, updated_at) FROM stdin;
    public               postgres    false    232   ��       �          0    33499    courses 
   TABLE DATA           M   COPY public.courses (course_id, course_name, course_description) FROM stdin;
    public               postgres    false    218   Ԃ       �          0    33554    modules 
   TABLE DATA           p   COPY public.modules (module_id, course_id, module_name, module_description, created_at, updated_at) FROM stdin;
    public               postgres    false    224   l�       �          0    33627 	   registrar 
   TABLE DATA           E   COPY public.registrar (registrar_id, username, password) FROM stdin;
    public               postgres    false    230   �       �          0    33572    student_module_progress 
   TABLE DATA           �   COPY public.student_module_progress (progress_id, student_id, module_id, is_completed, completion_date, created_at, updated_at) FROM stdin;
    public               postgres    false    226   1�       �          0    33508    students 
   TABLE DATA              COPY public.students (student_id, first_name, last_name, gender, birthdate, contact_number, course_id, created_at) FROM stdin;
    public               postgres    false    220   N�       �           0    0    assessments_assessment_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.assessments_assessment_id_seq', 4, true);
          public               postgres    false    227            �           0    0    attendance_attendance_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.attendance_attendance_id_seq', 1, true);
          public               postgres    false    221            �           0    0 #   certifications_certification_id_seq    SEQUENCE SET     R   SELECT pg_catalog.setval('public.certifications_certification_id_seq', 16, true);
          public               postgres    false    231            �           0    0    courses_course_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.courses_course_id_seq', 7, true);
          public               postgres    false    217            �           0    0    modules_module_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.modules_module_id_seq', 2, true);
          public               postgres    false    223            �           0    0    registrar_registrar_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.registrar_registrar_id_seq', 1, true);
          public               postgres    false    229            �           0    0 '   student_module_progress_progress_id_seq    SEQUENCE SET     V   SELECT pg_catalog.setval('public.student_module_progress_progress_id_seq', 1, false);
          public               postgres    false    225            �           0    0    students_student_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.students_student_id_seq', 7, true);
          public               postgres    false    219            �           2606    33607    assessments assessments_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.assessments
    ADD CONSTRAINT assessments_pkey PRIMARY KEY (assessment_id);
 F   ALTER TABLE ONLY public.assessments DROP CONSTRAINT assessments_pkey;
       public                 postgres    false    228            �           2606    33531    attendance attendance_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (attendance_id);
 D   ALTER TABLE ONLY public.attendance DROP CONSTRAINT attendance_pkey;
       public                 postgres    false    222            �           2606    33533 >   attendance attendance_student_id_course_id_attendance_date_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_student_id_course_id_attendance_date_key UNIQUE (student_id, course_id, attendance_date);
 h   ALTER TABLE ONLY public.attendance DROP CONSTRAINT attendance_student_id_course_id_attendance_date_key;
       public                 postgres    false    222    222    222            �           2606    33666 4   certifications certifications_certificate_number_key 
   CONSTRAINT     }   ALTER TABLE ONLY public.certifications
    ADD CONSTRAINT certifications_certificate_number_key UNIQUE (certificate_number);
 ^   ALTER TABLE ONLY public.certifications DROP CONSTRAINT certifications_certificate_number_key;
       public                 postgres    false    232            �           2606    33664 "   certifications certifications_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.certifications
    ADD CONSTRAINT certifications_pkey PRIMARY KEY (certification_id);
 L   ALTER TABLE ONLY public.certifications DROP CONSTRAINT certifications_pkey;
       public                 postgres    false    232            �           2606    33506    courses courses_course_name_key 
   CONSTRAINT     a   ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_course_name_key UNIQUE (course_name);
 I   ALTER TABLE ONLY public.courses DROP CONSTRAINT courses_course_name_key;
       public                 postgres    false    218            �           2606    33504    courses courses_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (course_id);
 >   ALTER TABLE ONLY public.courses DROP CONSTRAINT courses_pkey;
       public                 postgres    false    218            �           2606    33565 )   modules modules_course_id_module_name_key 
   CONSTRAINT     v   ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_course_id_module_name_key UNIQUE (course_id, module_name);
 S   ALTER TABLE ONLY public.modules DROP CONSTRAINT modules_course_id_module_name_key;
       public                 postgres    false    224    224            �           2606    33563    modules modules_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_pkey PRIMARY KEY (module_id);
 >   ALTER TABLE ONLY public.modules DROP CONSTRAINT modules_pkey;
       public                 postgres    false    224            �           2606    33632    registrar registrar_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.registrar
    ADD CONSTRAINT registrar_pkey PRIMARY KEY (registrar_id);
 B   ALTER TABLE ONLY public.registrar DROP CONSTRAINT registrar_pkey;
       public                 postgres    false    230            �           2606    33580 4   student_module_progress student_module_progress_pkey 
   CONSTRAINT     {   ALTER TABLE ONLY public.student_module_progress
    ADD CONSTRAINT student_module_progress_pkey PRIMARY KEY (progress_id);
 ^   ALTER TABLE ONLY public.student_module_progress DROP CONSTRAINT student_module_progress_pkey;
       public                 postgres    false    226            �           2606    33582 H   student_module_progress student_module_progress_student_id_module_id_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.student_module_progress
    ADD CONSTRAINT student_module_progress_student_id_module_id_key UNIQUE (student_id, module_id);
 r   ALTER TABLE ONLY public.student_module_progress DROP CONSTRAINT student_module_progress_student_id_module_id_key;
       public                 postgres    false    226    226            �           2606    33515    students students_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);
 @   ALTER TABLE ONLY public.students DROP CONSTRAINT students_pkey;
       public                 postgres    false    220            �           1259    33547    idx_attendance_course_id    INDEX     T   CREATE INDEX idx_attendance_course_id ON public.attendance USING btree (course_id);
 ,   DROP INDEX public.idx_attendance_course_id;
       public                 postgres    false    222            �           1259    33548    idx_attendance_date    INDEX     U   CREATE INDEX idx_attendance_date ON public.attendance USING btree (attendance_date);
 '   DROP INDEX public.idx_attendance_date;
       public                 postgres    false    222            �           1259    33549    idx_attendance_student_date    INDEX     t   CREATE INDEX idx_attendance_student_date ON public.attendance USING btree (student_id, course_id, attendance_date);
 /   DROP INDEX public.idx_attendance_student_date;
       public                 postgres    false    222    222    222            �           1259    33546    idx_attendance_student_id    INDEX     V   CREATE INDEX idx_attendance_student_id ON public.attendance USING btree (student_id);
 -   DROP INDEX public.idx_attendance_student_id;
       public                 postgres    false    222            �           1259    33544    idx_students_course_id    INDEX     P   CREATE INDEX idx_students_course_id ON public.students USING btree (course_id);
 *   DROP INDEX public.idx_students_course_id;
       public                 postgres    false    220            �           1259    33545    idx_students_last_name    INDEX     P   CREATE INDEX idx_students_last_name ON public.students USING btree (last_name);
 *   DROP INDEX public.idx_students_last_name;
       public                 postgres    false    220            �           2620    33551    attendance trg_set_course_id    TRIGGER     �   CREATE TRIGGER trg_set_course_id BEFORE INSERT ON public.attendance FOR EACH ROW EXECUTE FUNCTION public.set_course_id_from_student();
 5   DROP TRIGGER trg_set_course_id ON public.attendance;
       public               postgres    false    233    222            �           2620    33623 )   assessments update_assessments_updated_at    TRIGGER     �   CREATE TRIGGER update_assessments_updated_at BEFORE UPDATE ON public.assessments FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
 B   DROP TRIGGER update_assessments_updated_at ON public.assessments;
       public               postgres    false    235    228            �           2620    33621 !   modules update_modules_updated_at    TRIGGER     �   CREATE TRIGGER update_modules_updated_at BEFORE UPDATE ON public.modules FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
 :   DROP TRIGGER update_modules_updated_at ON public.modules;
       public               postgres    false    235    224            �           2620    33622 A   student_module_progress update_student_module_progress_updated_at    TRIGGER     �   CREATE TRIGGER update_student_module_progress_updated_at BEFORE UPDATE ON public.student_module_progress FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
 Z   DROP TRIGGER update_student_module_progress_updated_at ON public.student_module_progress;
       public               postgres    false    226    235            �           2606    33613 &   assessments assessments_course_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.assessments
    ADD CONSTRAINT assessments_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE RESTRICT;
 P   ALTER TABLE ONLY public.assessments DROP CONSTRAINT assessments_course_id_fkey;
       public               postgres    false    4809    228    218            �           2606    33608 '   assessments assessments_student_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.assessments
    ADD CONSTRAINT assessments_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.assessments DROP CONSTRAINT assessments_student_id_fkey;
       public               postgres    false    4813    220    228            �           2606    33539 $   attendance attendance_course_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE RESTRICT;
 N   ALTER TABLE ONLY public.attendance DROP CONSTRAINT attendance_course_id_fkey;
       public               postgres    false    222    218    4809            �           2606    33534 %   attendance attendance_student_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.attendance DROP CONSTRAINT attendance_student_id_fkey;
       public               postgres    false    4813    222    220            �           2606    33672 ,   certifications certifications_course_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.certifications
    ADD CONSTRAINT certifications_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE RESTRICT;
 V   ALTER TABLE ONLY public.certifications DROP CONSTRAINT certifications_course_id_fkey;
       public               postgres    false    4809    232    218            �           2606    33667 -   certifications certifications_student_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.certifications
    ADD CONSTRAINT certifications_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public.certifications DROP CONSTRAINT certifications_student_id_fkey;
       public               postgres    false    4813    232    220            �           2606    33566    modules modules_course_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE RESTRICT;
 H   ALTER TABLE ONLY public.modules DROP CONSTRAINT modules_course_id_fkey;
       public               postgres    false    4809    218    224            �           2606    33588 >   student_module_progress student_module_progress_module_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.student_module_progress
    ADD CONSTRAINT student_module_progress_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.modules(module_id) ON DELETE CASCADE;
 h   ALTER TABLE ONLY public.student_module_progress DROP CONSTRAINT student_module_progress_module_id_fkey;
       public               postgres    false    4825    226    224            �           2606    33583 ?   student_module_progress student_module_progress_student_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.student_module_progress
    ADD CONSTRAINT student_module_progress_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.student_module_progress DROP CONSTRAINT student_module_progress_student_id_fkey;
       public               postgres    false    220    226    4813            �           2606    33516     students students_course_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE RESTRICT;
 J   ALTER TABLE ONLY public.students DROP CONSTRAINT students_course_id_fkey;
       public               postgres    false    220    4809    218            �   �   x�m��
�0 痯x?P}���͠`�!��ڇ6Ii�����E�醻� �[l�]o'To��fᔼ}�pI�*�*$�1�y�����U<��N��ն$�s6��L4���y�/�2��)�܏߲�O)=��o��?��s�B| ��1�      �      x������ � �      �      x������ � �      �   �   x�3�t��-(-I-R�,.I�UN-*�L��KW�sV�����2�t)J-.�M�F6���L�IIMQ�M-I�Qp,JV
�Ti�:�k��Ԛ��ؘ�5'5��(?/3Y!�(?�4��X���857)�Å\1z\\\ %�>Z      �   �   x�}���0���)�h����ݘad9�+DJs�K��=aad���v�5���rH��{���H�9��~s%p�� ?�0G9���z�JL*;�2֊#��3P$WgR=AZ�qoUozۘccF0v2��mo;3��D��j�?�6�      �      x�3�LL��̃��F�\1z\\\ J
�      �      x������ � �      �   q   x�}�;�0 ��9p�O�OG�1��d��H�!��EY���"\G�ox����Vw!bdFQ�Rr�6�0��"����¼�MES�����;l�p?��o�H	�Έ~���9�>� R     