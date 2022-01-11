-- Table: dept_network_service_control_program

-- DROP TABLE dept_network_service_control_program;

CREATE TABLE dept_network_service_control_program
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  programname character varying(128) NOT NULL,
  filename character varying(128) NOT NULL,
  programtype character(1) NOT NULL,
  controltype character(1) NOT NULL,
  CONSTRAINT "PK_DEPT_NETWORK_SERVICE_CONTROL_PROGRAM" PRIMARY KEY (companyid, deptcode, filename),
  CONSTRAINT "FK_DEPT_NETWORK_SERVICE_CONTROL_PROGRAM_DEPT" FOREIGN KEY (companyid, deptcode)
      REFERENCES dept (companyid, deptcode) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
