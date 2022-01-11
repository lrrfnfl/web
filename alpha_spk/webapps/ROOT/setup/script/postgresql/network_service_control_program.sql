-- Table: network_service_control_program

-- DROP TABLE network_service_control_program;

CREATE TABLE network_service_control_program
(
  seqno serial NOT NULL,
  programname character varying(128) NOT NULL,
  filename character varying(128) NOT NULL,
  programtype character(1) NOT NULL,
  CONSTRAINT "PK_NETWORK_SERVICE_CONTROL_PROGRAM" PRIMARY KEY (filename)
)
WITH (
  OIDS=FALSE
);
