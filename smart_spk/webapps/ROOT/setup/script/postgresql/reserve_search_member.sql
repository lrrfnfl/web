-- Table: reserve_search_member

-- DROP TABLE reserve_search_member;

CREATE TABLE reserve_search_member
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  policyno integer NOT NULL,
  CONSTRAINT "PK_RESERVE_SEARCH_MEMBER" PRIMARY KEY (companyid, deptcode, userid, policyno),
  CONSTRAINT "FK_RESERVE_SEARCH_MEMBER_MEMBER" FOREIGN KEY (companyid, deptcode, userid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "FK_RESERVE_SEARCH_MEMBER_POLICYNO" FOREIGN KEY (companyid, policyno)
      REFERENCES reserve_search (companyid, policyno) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
