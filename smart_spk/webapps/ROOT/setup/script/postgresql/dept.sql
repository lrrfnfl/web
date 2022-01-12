-- Table: dept

-- DROP TABLE dept;

CREATE TABLE dept
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  deptname character varying(128) NOT NULL,
  parentdeptcode character varying(32),
  CONSTRAINT "PK_DEPT" PRIMARY KEY (companyid, deptcode),
  CONSTRAINT "FK_DEPT_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
