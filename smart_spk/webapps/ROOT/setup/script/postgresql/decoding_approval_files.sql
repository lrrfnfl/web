-- Table: decoding_approval_files

-- DROP TABLE decoding_approval_files;

CREATE TABLE decoding_approval_files
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  approvalid character varying(16) NOT NULL,
  filepath character varying(512) NOT NULL,
  CONSTRAINT "PK_DECODING_APPROVAL_FILES" PRIMARY KEY (companyid, deptcode, userid, approvalid, filepath),
  CONSTRAINT "FK_DECODING_APPROVAL_FILES" FOREIGN KEY (companyid, deptcode, userid, approvalid)
      REFERENCES decoding_approval (companyid, deptcode, userid, approvalid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "FK_DECODING_APPROVAL_FILES_MEMBER" FOREIGN KEY (companyid, deptcode, userid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_DECODING_APPROVAL_FILES_SEQNO"

-- DROP INDEX "IDX_DECODING_APPROVAL_FILES_SEQNO";

CREATE INDEX "IDX_DECODING_APPROVAL_FILES_SEQNO"
  ON decoding_approval_files
  USING btree
  (seqno);

