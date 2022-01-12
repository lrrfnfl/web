-- Table: detect_files_expiration_extend_history

-- DROP TABLE detect_files_expiration_extend_history;

CREATE TABLE detect_files_expiration_extend_history
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  searchpathhash character varying(64) NOT NULL,
  requestertype character(1) NOT NULL,
  requesterid character varying(32) NOT NULL,
  reason text,
  extenddate date NOT NULL,
  reportingdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_DETECT_FILES_EXPIRATION_EXTEND_HISTORY" PRIMARY KEY (seqno),
  CONSTRAINT "FK_DETECT_FILES_EXPIRATION_EXTEND_HISTORY" FOREIGN KEY (companyid, deptcode, userid, searchpathhash)
      REFERENCES detect_files (companyid, deptcode, userid, searchpathhash) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
