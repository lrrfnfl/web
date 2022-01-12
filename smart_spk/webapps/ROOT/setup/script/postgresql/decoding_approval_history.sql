-- Table: decoding_approval_history

-- DROP TABLE decoding_approval_history;

CREATE TABLE decoding_approval_history
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  approvalid character varying(16) NOT NULL,
  approvalkind character(1) NOT NULL,
  approvaltype character(1) NOT NULL,
  approvalpriority character(1) NOT NULL,
  reason text,
  requestdatetime timestamp without time zone NOT NULL,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_DECODING_APPROVAL_HISTORY" PRIMARY KEY (seqno),
  CONSTRAINT "FK_DECODING_APPROVAL_HISTORY" FOREIGN KEY (companyid, deptcode, userid, approvalid)
      REFERENCES decoding_approval (companyid, deptcode, userid, approvalid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "FK_DECODING_APPROVAL_HISTORY_MEMBER" FOREIGN KEY (companyid, deptcode, userid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_DECODING_APPROVAL_HISTORY_MEMBER"

-- DROP INDEX "IDX_DECODING_APPROVAL_HISTORY_MEMBER";

CREATE INDEX "IDX_DECODING_APPROVAL_HISTORY_MEMBER"
  ON decoding_approval_history
  USING btree
  (companyid, deptcode, userid);
ALTER TABLE decoding_approval_history CLUSTER ON "IDX_DECODING_APPROVAL_HISTORY_MEMBER";

