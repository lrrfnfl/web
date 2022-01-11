-- Table: tmp_member

-- DROP TABLE tmp_member;

CREATE TABLE tmp_member
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  deptname character varying(128) NOT NULL,
  userid character varying(32),
  username character varying(128),
  pwd character varying(128),
  CONSTRAINT "PK_TMP_MEMBER" PRIMARY KEY (seqno)
)
WITH (
  OIDS=FALSE
);
