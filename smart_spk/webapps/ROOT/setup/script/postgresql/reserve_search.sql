-- Table: reserve_search

-- DROP TABLE reserve_search;

CREATE TABLE reserve_search
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  policyno integer NOT NULL,
  searchscheduletype character(1) NOT NULL,
  nthweekformonth character(1),
  dayofweekformonth character(1),
  searchhoursformonth character(2),
  searchminutesformonth character(2),
  dayofweekforweek character(1),
  searchhoursforweek character(2),
  searchminutesforweek character(2),
  searchhoursforday character(2),
  searchminutesforday character(2),
  searchspecifieddate date,
  searchhoursforspecifieddate character(2),
  searchminutesforspecifieddate character(2),
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_RESERVE_SEARCH" PRIMARY KEY (companyid, policyno),
  CONSTRAINT "FK_RESERVE_SEARCH_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
