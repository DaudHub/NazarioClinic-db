DROP SCHEMA public cascade;

CREATE SCHEMA public AUTHORIZATION nazario;
-- public.estudios definition

-- Drop table

-- DROP TABLE public.estudios;

CREATE TABLE public.estudios (
	id uuid DEFAULT gen_random_uuid() NOT NULL,
	codigo varchar(20) NOT NULL,
	nombre text NOT NULL,
	descripcion text NOT NULL,
	duracion interval NOT NULL,
	activo bool DEFAULT true NOT NULL,
	CONSTRAINT estudios_codigo_key UNIQUE (codigo),
	CONSTRAINT estudios_pkey PRIMARY KEY (id)
);


-- public.gruposusuario definition

-- Drop table

-- DROP TABLE public.gruposusuario;

CREATE TABLE public.gruposusuario (
	id uuid DEFAULT gen_random_uuid() NOT NULL,
	nombre text NOT NULL,
	CONSTRAINT gruposusuario_pkey PRIMARY KEY (id)
);


-- public.pacientes definition

-- Drop table

-- DROP TABLE public.pacientes;

CREATE TABLE public.pacientes (
	id uuid DEFAULT gen_random_uuid() NOT NULL,
	documento varchar(20) NOT NULL,
	nombre text NOT NULL,
	telefono varchar(20) NULL,
	mail text not null,
	CONSTRAINT pacientes_documento_key UNIQUE (documento),
	CONSTRAINT pacientes_pkey PRIMARY KEY (id)
);


-- public.profesionales definition

-- Drop table

-- DROP TABLE public.profesionales;

CREATE TABLE public.profesionales (
	id uuid DEFAULT gen_random_uuid() NOT NULL,
	nombre text NOT NULL,
	mail text NOT NULL,
	rut varchar(12) NULL,
	CONSTRAINT profesionales_pkey PRIMARY KEY (id)
);


-- public.sedes definition

-- Drop table

-- DROP TABLE public.sedes;

CREATE TABLE public.sedes (
	id uuid DEFAULT gen_random_uuid() NOT NULL,
	codigo varchar(20) NOT NULL,
	nombre text NOT NULL,
	direccion text NOT NULL,
	x numeric(8, 5) NOT NULL,
	y numeric(8, 5) NOT NULL,
	habilitada bool DEFAULT true NOT NULL,
	turnos_simultaneos int4 DEFAULT 1 NOT NULL,
	CONSTRAINT sedes_codigo_key UNIQUE (codigo),
	CONSTRAINT sedes_pkey PRIMARY KEY (id)
);


-- public.usuarios definition

-- Drop table

-- DROP TABLE public.usuarios;

CREATE TABLE public.usuarios (
	id uuid DEFAULT gen_random_uuid() NOT NULL,
	usuario text NOT NULL,
	nombre text NOT NULL,
	mail text NOT NULL,
	passwd text NOT NULL,
	sys_admin bool DEFAULT false NOT NULL,
	CONSTRAINT usuarios_mail_key UNIQUE (mail),
	CONSTRAINT usuarios_pkey PRIMARY KEY (id),
	CONSTRAINT usuarios_usuario_key UNIQUE (usuario)
);


-- public.atributoscheckbox definition

-- Drop table

-- DROP TABLE public.atributoscheckbox;

CREATE TABLE public.atributoscheckbox (
	id_estudio uuid NOT NULL,
	id uuid DEFAULT gen_random_uuid() NOT NULL,
	nombre text NOT NULL,
	tiempo_extra interval NOT NULL,
	CONSTRAINT atributoscheckbox_pkey PRIMARY KEY (id_estudio, id),
	CONSTRAINT atributoscheckbox_id_estudio_fkey FOREIGN KEY (id_estudio) REFERENCES public.estudios(id)
);


-- public.atributostextbox definition

-- Drop table

-- DROP TABLE public.atributostextbox;

CREATE TABLE public.atributostextbox (
	id_estudio uuid NOT NULL,
	id uuid DEFAULT gen_random_uuid() NOT NULL,
	id_atributo_checkbox uuid NULL,
	descripcion text NOT NULL,
	obligatorio bool DEFAULT false NOT NULL,
	CONSTRAINT atributostextbox_pkey PRIMARY KEY (id_estudio, id),
	CONSTRAINT atributostextbox_id_estudio_fkey FOREIGN KEY (id_estudio) REFERENCES public.estudios(id),
	CONSTRAINT atributostextbox_id_estudio_id_atributo_checkbox_fkey FOREIGN KEY (id_estudio,id_atributo_checkbox) REFERENCES public.atributoscheckbox(id_estudio,id)
);


-- public.equipos definition

-- Drop table

-- DROP TABLE public.equipos;

CREATE TABLE public.equipos (
	id uuid DEFAULT gen_random_uuid() NOT NULL,
	id_sede uuid NOT NULL,
	nombre text NOT NULL,
	modelo text NOT NULL,
	nro_serie text NOT NULL,
	activo bool DEFAULT true NOT NULL,
	CONSTRAINT equipos_nro_serie_key UNIQUE (nro_serie),
	CONSTRAINT equipos_pkey PRIMARY KEY (id_sede, id),
	CONSTRAINT equipos_id_sede_fkey FOREIGN KEY (id_sede) REFERENCES public.sedes(id)
);


-- public.equiposxestudio definition

-- Drop table

-- DROP TABLE public.equiposxestudio;

CREATE TABLE public.equiposxestudio (
	id_sede uuid NOT NULL,
	id_equipo uuid NOT NULL,
	id_estudio uuid NOT NULL,
	CONSTRAINT equiposxestudio_pkey PRIMARY KEY (id_sede, id_estudio, id_equipo),
	CONSTRAINT equiposxestudio_id_estudio_fkey FOREIGN KEY (id_estudio) REFERENCES public.estudios(id),
	CONSTRAINT equiposxestudio_id_sede_id_equipo_fkey FOREIGN KEY (id_sede,id_equipo) REFERENCES public.equipos(id_sede,id)
);


-- public.estudiosxsede definition

-- Drop table

-- DROP TABLE public.estudiosxsede;

CREATE TABLE public.estudiosxsede (
	id_estudio uuid NOT NULL,
	id_sede uuid NOT NULL,
	CONSTRAINT estudiosxsede_pkey PRIMARY KEY (id_estudio, id_sede),
	CONSTRAINT estudiosxsede_id_estudio_fkey FOREIGN KEY (id_estudio) REFERENCES public.estudios(id),
	CONSTRAINT estudiosxsede_id_sede_fkey FOREIGN KEY (id_sede) REFERENCES public.sedes(id)
);


-- public.horariosxsede definition

-- Drop table

-- DROP TABLE public.horariosxsede;

CREATE TABLE public.horariosxsede (
	id_sede uuid NOT NULL,
	dia int4 NOT NULL,
	apertura time NOT NULL,
	cierre time NOT NULL,
	CONSTRAINT horariosxsede_dia_check CHECK (((dia >= 0) AND (dia <= 6))),
	CONSTRAINT horariosxsede_pkey PRIMARY KEY (id_sede, dia),
	CONSTRAINT horariosxsede_id_sede_fkey FOREIGN KEY (id_sede) REFERENCES public.sedes(id)
);


-- public.refreshtokens definition

-- Drop table

-- DROP TABLE public.refreshtokens;

CREATE TABLE public.refreshtokens (
	id_usuario uuid NOT NULL,
	"token" text NOT NULL,
	fec_venc timestamp NOT NULL,
	CONSTRAINT refreshtokens_pkey PRIMARY KEY (id_usuario),
	CONSTRAINT refreshtokens_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id)
);


-- public.salas definition

-- Drop table

-- DROP TABLE public.salas;

CREATE TABLE public.salas (
	id uuid DEFAULT gen_random_uuid() NOT NULL,
	id_sede uuid NOT NULL,
	nombre text NOT NULL,
	capacidad int4 NOT NULL,
	activa bool DEFAULT true NOT NULL,
	CONSTRAINT salas_capacidad_check CHECK ((capacidad > 0)),
	CONSTRAINT salas_pkey PRIMARY KEY (id_sede, id),
	CONSTRAINT salas_id_sede_fkey FOREIGN KEY (id_sede) REFERENCES public.sedes(id)
);


-- public.salasxestudio definition

-- Drop table

-- DROP TABLE public.salasxestudio;

CREATE TABLE public.salasxestudio (
	id_sede uuid NOT NULL,
	id_sala uuid NOT NULL,
	id_estudio uuid NOT NULL,
	CONSTRAINT salasxestudio_pkey PRIMARY KEY (id_sede, id_estudio, id_sala),
	CONSTRAINT salasxestudio_id_estudio_fkey FOREIGN KEY (id_estudio) REFERENCES public.estudios(id),
	CONSTRAINT salasxestudio_id_sede_id_sala_fkey FOREIGN KEY (id_sede,id_sala) REFERENCES public.salas(id_sede,id)
);

-- public.turnos definition

-- Drop table

-- DROP TABLE public.turnos;

CREATE TABLE public.turnos (
	id uuid DEFAULT gen_random_uuid() NOT NULL,
	id_sede uuid NOT NULL,
	id_sala uuid NOT NULL,
	horario timestamp NOT NULL,
	duracion interval NOT NULL,
	estudio uuid NOT NULL,
	precio numeric(14, 2) NOT NULL,
	id_paciente uuid NOT NULL,
	id_profesional uuid NULL,
	usuario_alta uuid NOT NULL,
	usuario_mod uuid NOT NULL,
	CONSTRAINT turnos_pkey PRIMARY KEY (id),
	CONSTRAINT turnos_id_paciente_fkey FOREIGN KEY (id_paciente) REFERENCES public.pacientes(id),
	CONSTRAINT turnos_id_profesional_fkey FOREIGN KEY (id_profesional) REFERENCES public.profesionales(id),
	CONSTRAINT turnos_id_sede_id_sala_fkey FOREIGN KEY (id_sede,id_sala) REFERENCES public.salas(id_sede,id)
);


-- public.usuariosxgrupo definition

-- Drop table

-- DROP TABLE public.usuariosxgrupo;

CREATE TABLE public.usuariosxgrupo (
	id_grupo uuid NOT NULL,
	id_usuario uuid NOT NULL,
	CONSTRAINT usuariosxgrupo_pkey PRIMARY KEY (id_grupo, id_usuario),
	CONSTRAINT usuariosxgrupo_id_grupo_fkey FOREIGN KEY (id_grupo) REFERENCES public.gruposusuario(id),
	CONSTRAINT usuariosxgrupo_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id)
);


-- public.usuariosxsede definition

-- Drop table

-- DROP TABLE public.usuariosxsede;

CREATE TABLE public.usuariosxsede (
	id_usuario uuid NOT NULL,
	id_sede uuid NOT NULL,
	CONSTRAINT usuariosxsede_pkey PRIMARY KEY (id_usuario, id_sede),
	CONSTRAINT usuariosxsede_id_sede_fkey FOREIGN KEY (id_sede) REFERENCES public.sedes(id),
	CONSTRAINT usuariosxsede_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id)
);


create table public.disponibilidadsede (
	id_sede uuid NOT NULL,
	desde timestamp not null,
	hasta timestamp not null,
	tecnico uuid,
	usuario_alta uuid not null,
	check (desde < hasta),
	foreign key (id_sede) references sedes (id),
	foreign key (tecnico) references usuarios (id),
	foreign key (usuario_alta) references usuarios (id),
	primary key (id_sede, desde)
);

