-- Table: force_search

-- DROP TABLE force_search;

CREATE TABLE force_search
(
  seqno serial NOT NULL,
  searchid character varying(15) NOT NULL,
  companyid character varying(64) NOT NULL,
  threadprioritytype character(1) NOT NULL,
  searchafternextbootingflag character(1) NOT NULL,
  jobprocessingtype character varying(2) NOT NULL,
  searchmethod character(1) NOT NULL,
  includedocsflag character(1) NOT NULL,
  includeimgsflag character(1) NOT NULL,
  includezipsflag character(1) NOT NULL,
  searchstartdatetime timestamp without time zone NOT NULL,
  searchstateflag character(1) NOT NULL,
  registerid character varying(32) NOT NULL,
  lastmodifierid character varying(32),
  lastmodifieddatetime timestamp without time zone,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_FORCE_SEARCH" PRIMARY KEY (searchid, companyid),
  CONSTRAINT "FK_FORCE_SEARCH_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
