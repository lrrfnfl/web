-- Table: member_network_service_control_program

-- DROP TABLE member_network_service_control_program;

CREATE TABLE member_network_service_control_program
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  programname character varying(128) NOT NULL,
  filename character varying(128) NOT NULL,
  programtype character(1) NOT NULL,
  controltype character(1) NOT NULL,
  CONSTRAINT "PK_MEMBER_NETWORK_SERVICE_CONTROL_PROGRAM" PRIMARY KEY (companyid, deptcode, userid, filename),
  CONSTRAINT "FK_MEMBER_NETWORK_SERVICE_CONTROL_PROGRAM_MEMBER" FOREIGN KEY (companyid, deptcode, userid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
