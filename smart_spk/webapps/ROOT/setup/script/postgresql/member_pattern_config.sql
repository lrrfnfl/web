-- Table: member_pattern_config

-- DROP TABLE member_pattern_config;

CREATE TABLE member_pattern_config
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  patternid integer NOT NULL,
  patternsubid integer NOT NULL,
  defaultsearchflag character(1) NOT NULL,
  jobprocessingactivecount integer NOT NULL DEFAULT 1,
  CONSTRAINT "PK_MEMBER_PATTERN_CONFIG" PRIMARY KEY (companyid, deptcode, userid, patternid, patternsubid),
  CONSTRAINT "FK_MEMBER_PATTERN_CONFIG_MEMBER" FOREIGN KEY (companyid, deptcode, userid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "FK_MEMBER_PATTERN_CONFIG_PATTERN" FOREIGN KEY (patternid, patternsubid)
      REFERENCES pattern (patternid, patternsubid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
