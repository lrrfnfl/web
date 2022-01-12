-- Table: user_notice_member

-- DROP TABLE user_notice_member;

CREATE TABLE user_notice_member
(
  seqno serial NOT NULL,
  noticeid character varying(32) NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  CONSTRAINT "PK_USER_NOTICE_MEMBER" PRIMARY KEY (noticeid, companyid, deptcode, userid),
  CONSTRAINT "FK_USER_NOTICE_MEMBER_MEMBER" FOREIGN KEY (companyid, deptcode, userid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "FK_USER_NOTICE_MEMBER_NOTICEID" FOREIGN KEY (noticeid, companyid)
      REFERENCES user_notice (noticeid, companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
