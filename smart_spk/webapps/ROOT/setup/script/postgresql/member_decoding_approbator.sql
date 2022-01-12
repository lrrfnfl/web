-- Table: member_decoding_approbator

-- DROP TABLE member_decoding_approbator;

CREATE TABLE member_decoding_approbator
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  approbatorcompanyid character varying(64) NOT NULL,
  approbatordeptcode character varying(32) NOT NULL,
  approbatoruserid character varying(32) NOT NULL,
  approbatorpriority character(1) NOT NULL,
  approbatortype character(1) NOT NULL,
  CONSTRAINT "PK_MEMBER_DECODING_APPROBATOR" PRIMARY KEY (companyid, deptcode, userid, approbatorcompanyid, approbatordeptcode, approbatoruserid),
  CONSTRAINT "FK_MEMBER_DECODING_APPROBATOR_APPROBATOR" FOREIGN KEY (approbatorcompanyid, approbatordeptcode, approbatoruserid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "FK_MEMBER_DECODING_APPROBATOR_MEMBER" FOREIGN KEY (companyid, deptcode, userid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
