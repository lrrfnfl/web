-- Table: company_network_service_control_program

-- DROP TABLE company_network_service_control_program;

CREATE TABLE company_network_service_control_program
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  programname character varying(128) NOT NULL,
  filename character varying(128) NOT NULL,
  programtype character(1) NOT NULL,
  controltype character(1) NOT NULL,
  CONSTRAINT "PK_COMPANY_NETWORK_SERVICE_CONTROL_PROGRAM" PRIMARY KEY (companyid, filename),
  CONSTRAINT "FK_COMPANY_NETWORK_SERVICE_CONTROL_PROGRAM_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
