-- Table: user_notice

-- DROP TABLE user_notice;

CREATE TABLE user_notice
(
  seqno serial NOT NULL,
  noticeid character varying(32) NOT NULL,
  companyid character varying(64) NOT NULL,
  title character varying(512) NOT NULL,
  contents text,
  registerid character varying(32) NOT NULL,
  lastmodifierid character varying(32),
  lastmodifieddatetime timestamp without time zone,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_USER_NOTICE" PRIMARY KEY (noticeid, companyid),
  CONSTRAINT "FK_USER_NOTICE_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
