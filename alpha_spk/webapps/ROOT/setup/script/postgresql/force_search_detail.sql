-- Table: force_search_detail

-- DROP TABLE force_search_detail;

CREATE TABLE force_search_detail
(
  seqno serial NOT NULL,
  searchid character varying(15) NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  completeflag character(1),
  startdatetime timestamp without time zone,
  enddatetime timestamp without time zone,
  CONSTRAINT "PK_FORCE_SEARCH_DETAIL" PRIMARY KEY (searchid, companyid, deptcode, userid),
  CONSTRAINT "FK_FORCE_SEARCH_DETAIL_MEMBER" FOREIGN KEY (companyid, deptcode, userid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "FK_FORCE_SEARCH_DETAIL_SEARCHID" FOREIGN KEY (searchid, companyid)
      REFERENCES force_search (searchid, companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
