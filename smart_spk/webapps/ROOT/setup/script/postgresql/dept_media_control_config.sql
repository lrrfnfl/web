-- Table: dept_media_control_config

-- DROP TABLE dept_media_control_config;

CREATE TABLE dept_media_control_config
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  usbcontrolflag character(1) NOT NULL,
  usbcontroltype character(1) NOT NULL,
  cdromcontrolflag character(1) NOT NULL,
  cdromcontroltype character(1) NOT NULL,
  publicfoldercontrolflag character(1) NOT NULL,
  publicfoldercontroltype character(1) NOT NULL,
  lastmodifieddatetime timestamp without time zone,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_DEPT_MEDIA_CONTROL_CONFIG" PRIMARY KEY (companyid, deptcode),
  CONSTRAINT "FK_DEPT_MEDIA_CONTROL_CONFIG_DEPT" FOREIGN KEY (companyid, deptcode)
      REFERENCES dept (companyid, deptcode) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
