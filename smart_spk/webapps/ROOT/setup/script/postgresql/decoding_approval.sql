-- Table: decoding_approval

-- DROP TABLE decoding_approval;

CREATE TABLE decoding_approval
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
  originfileipaddress character varying(64),
  requestdatetime timestamp without time zone NOT NULL,
  priorityinprogress character(1) NOT NULL,
  approvalstate character(1),
  lastmodifieddatetime timestamp without time zone,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_DECODING_APPROVAL" PRIMARY KEY (companyid, deptcode, userid, approvalid),
  CONSTRAINT "FK_DECODING_APPROVAL_MEMBER" FOREIGN KEY (companyid, deptcode, userid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_DECODING_APPROVAL_CREATEDATETIME"

-- DROP INDEX "IDX_DECODING_APPROVAL_CREATEDATETIME";

CREATE INDEX "IDX_DECODING_APPROVAL_CREATEDATETIME"
  ON decoding_approval
  USING btree
  (createdatetime);
ALTER TABLE decoding_approval CLUSTER ON "IDX_DECODING_APPROVAL_CREATEDATETIME";

-- Index: "IDX_DECODING_APPROVAL_SEQNO"

-- DROP INDEX "IDX_DECODING_APPROVAL_SEQNO";

CREATE INDEX "IDX_DECODING_APPROVAL_SEQNO"
  ON decoding_approval
  USING btree
  (seqno);

