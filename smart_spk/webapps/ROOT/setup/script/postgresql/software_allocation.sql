-- Table: software_allocation

-- DROP TABLE software_allocation;

CREATE TABLE software_allocation
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  softwarename character varying(256) NOT NULL,
  CONSTRAINT "PK_SOFTWARE_ALLOCATION" PRIMARY KEY (companyid, deptcode, userid, softwarename),
  CONSTRAINT "FK_SOFTWARE_ALLOCATION_MEMBER" FOREIGN KEY (companyid, deptcode, userid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "FK_SOFTWARE_ALLOCATION_SOFTWARE" FOREIGN KEY (companyid, softwarename)
      REFERENCES software_licence (companyid, softwarename) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

