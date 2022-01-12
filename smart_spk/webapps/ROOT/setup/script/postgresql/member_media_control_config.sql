-- Table: member_media_control_config

-- DROP TABLE member_media_control_config;

CREATE TABLE member_media_control_config
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  usbcontrolflag character(1) NOT NULL,
  usbcontroltype character(1) NOT NULL,
  cdromcontrolflag character(1) NOT NULL,
  cdromcontroltype character(1) NOT NULL,
  publicfoldercontrolflag character(1) NOT NULL,
  publicfoldercontroltype character(1) NOT NULL,
  lastmodifieddatetime timestamp without time zone,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_MEMBER_MEDIA_CONTROL_CONFIG" PRIMARY KEY (companyid, deptcode, userid),
  CONSTRAINT "FK_MEMBER_MEDIA_CONTROL_CONFIG_MEMBER" FOREIGN KEY (companyid, deptcode, userid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
