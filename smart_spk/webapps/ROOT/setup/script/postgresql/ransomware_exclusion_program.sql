-- Table: ransomware_exclusion_program

-- DROP TABLE ransomware_exclusion_program;

CREATE TABLE ransomware_exclusion_program
(
  seqno serial NOT NULL,
  programname character varying(128) NOT NULL,
  filename character varying(128) NOT NULL,
  CONSTRAINT "PK_RANSOMWARE_EXCLUSION_PROGRAM" PRIMARY KEY (filename)
)
WITH (
  OIDS=FALSE
);
