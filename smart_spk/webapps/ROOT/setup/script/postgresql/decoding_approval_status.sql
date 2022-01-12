-- Table: decoding_approval_status

-- DROP TABLE decoding_approval_status;

CREATE TABLE decoding_approval_status
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  approvalid character varying(16) NOT NULL,
  approbatorcompanyid character varying(64) NOT NULL,
  approbatordeptcode character varying(32) NOT NULL,
  approbatoruserid character varying(32) NOT NULL,
  approbatorpriority character(1) NOT NULL,
  approbatortype character(1) NOT NULL,
  approvalstate character(1) NOT NULL,
  comment text,
  completedatetime timestamp without time zone,
  CONSTRAINT "PK_DECODING_APPROVAL_STATUS" PRIMARY KEY (companyid, deptcode, userid, approvalid, approbatorcompanyid, approbatordeptcode, approbatoruserid),
  CONSTRAINT "FK_DECODING_APPROVAL_STATUS" FOREIGN KEY (companyid, deptcode, userid, approvalid)
      REFERENCES decoding_approval (companyid, deptcode, userid, approvalid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "FK_DECODING_APPROVAL_STATUS_MEMBER" FOREIGN KEY (companyid, deptcode, userid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_DECODING_APPROVAL_STATUS_SEQNO"

-- DROP INDEX "IDX_DECODING_APPROVAL_STATUS_SEQNO";

CREATE INDEX "IDX_DECODING_APPROVAL_STATUS_SEQNO"
  ON decoding_approval_status
  USING btree
  (seqno);

