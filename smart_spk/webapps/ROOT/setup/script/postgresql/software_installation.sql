-- Table: software_installation

-- DROP TABLE software_installation;

CREATE TABLE software_installation
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  softwarename character varying(256) NOT NULL,
  filename character varying(128) DEFAULT NULL::character varying,
  filesize bigint,
  version character varying(128) DEFAULT NULL::character varying,
  description text,
  vendor character varying(128) DEFAULT NULL::character varying,
  installedpath character varying(512) DEFAULT NULL::character varying,
  installeddate date,
  CONSTRAINT "PK_SOFTWARE_INSTALLATION" PRIMARY KEY (companyid, deptcode, userid, softwarename),
  CONSTRAINT "FK_SOFTWARE_INSTALLATION_MEMBER" FOREIGN KEY (companyid, deptcode, userid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

