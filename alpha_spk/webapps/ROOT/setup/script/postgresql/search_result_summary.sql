-- Table: search_result_summary

-- DROP TABLE search_result_summary;

CREATE TABLE search_result_summary
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  searchid character varying(15) NOT NULL,
  searchtype character(1) NOT NULL,
  searchdate date NOT NULL,
  detectfilecount bigint NOT NULL DEFAULT 0,
  notprocessfilecount bigint NOT NULL DEFAULT 0,
  encodingfilecount bigint NOT NULL DEFAULT 0,
  decodingfilecount bigint NOT NULL DEFAULT 0,
  deletefilecount bigint NOT NULL DEFAULT 0,
  sendfilecount bigint NOT NULL DEFAULT 0,
  processingfailfilecount bigint NOT NULL DEFAULT 0,
  movetovitualdiskfilecount bigint NOT NULL DEFAULT 0,
  movefromvitualdiskfilecount bigint NOT NULL DEFAULT 0,
  movetovitualdiskfilenotfoundcount bigint NOT NULL DEFAULT 0,
  movefromvitualdiskfilenotfoundcount bigint NOT NULL DEFAULT 0,
  CONSTRAINT "PK_SEARCH_RESULT_SUMMARY" PRIMARY KEY (companyid, deptcode, userid, searchid)
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_SEARCH_RESULT_SUMMARY_SEARCHDATE"

-- DROP INDEX "IDX_SEARCH_RESULT_SUMMARY_SEARCHDATE";

CREATE INDEX "IDX_SEARCH_RESULT_SUMMARY_SEARCHDATE"
  ON search_result_summary
  USING btree
  (searchdate);
