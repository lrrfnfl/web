-- Table: dept_pattern_config

-- DROP TABLE dept_pattern_config;

CREATE TABLE dept_pattern_config
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  patternid integer NOT NULL,
  patternsubid integer NOT NULL,
  defaultsearchflag character(1) NOT NULL,
  jobprocessingactivecount integer NOT NULL DEFAULT 1,
  CONSTRAINT "PK_DEPT_PATTERN_CONFIG" PRIMARY KEY (companyid, deptcode, patternid, patternsubid),
  CONSTRAINT "FK_DEPT_PATTERN_CONFIG_DEPT" FOREIGN KEY (companyid, deptcode)
      REFERENCES dept (companyid, deptcode) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "FK_DEPT_PATTERN_CONFIG_PATTERN" FOREIGN KEY (patternid, patternsubid)
      REFERENCES pattern (patternid, patternsubid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
