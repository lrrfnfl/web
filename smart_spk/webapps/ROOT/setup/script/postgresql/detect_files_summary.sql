-- Table: detect_files_summary

-- DROP TABLE detect_files_summary;

CREATE TABLE detect_files_summary
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
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
  CONSTRAINT "PK_DETECT_FILES_SUMMARY" PRIMARY KEY (companyid, deptcode, userid)
)
WITH (
  OIDS=FALSE
);
