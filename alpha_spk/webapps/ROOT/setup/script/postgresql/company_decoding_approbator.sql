-- Table: company_decoding_approbator

-- DROP TABLE company_decoding_approbator;

CREATE TABLE company_decoding_approbator
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  approbatorcompanyid character varying(64) NOT NULL,
  approbatordeptcode character varying(32) NOT NULL,
  approbatoruserid character varying(32) NOT NULL,
  approbatorpriority character(1) NOT NULL,
  approbatortype character(1) NOT NULL,
  CONSTRAINT "PK_COMPANY_DECODING_APPROBATOR" PRIMARY KEY (companyid, approbatorcompanyid, approbatordeptcode, approbatoruserid),
  CONSTRAINT "FK_COMPANY_DECODING_APPROBATOR_APPROBATOR" FOREIGN KEY (approbatorcompanyid, approbatordeptcode, approbatoruserid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "FK_COMPANY_DECODING_APPROBATOR_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
