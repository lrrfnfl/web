-- Table: dept_decoding_approbator

-- DROP TABLE dept_decoding_approbator;

CREATE TABLE dept_decoding_approbator
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  approbatorcompanyid character varying(64) NOT NULL,
  approbatordeptcode character varying(32) NOT NULL,
  approbatoruserid character varying(32) NOT NULL,
  approbatorpriority character(1) NOT NULL,
  approbatortype character(1) NOT NULL,
  CONSTRAINT "PK_DEPT_DECODING_APPROBATOR" PRIMARY KEY (companyid, deptcode, approbatorcompanyid, approbatordeptcode, approbatoruserid),
  CONSTRAINT "FK_DEPT_DECODING_APPROBATOR_APPROBATOR" FOREIGN KEY (approbatorcompanyid, approbatordeptcode, approbatoruserid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "FK_DEPT_DECODING_APPROBATOR_DEPT" FOREIGN KEY (companyid, deptcode)
      REFERENCES dept (companyid, deptcode) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
