-- Table: company_watermark_config

-- DROP TABLE company_watermark_config;

CREATE TABLE company_watermark_config
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  wmprintmode character varying(6),
  wm3stepwatermark character(1),
  wmtextrepeatsize character(2),
  wmoutlinemode character(1),
  wmprinttime character(1),
  wmtextmain character varying(256),
  wmtextsub character varying(256),
  wmtexttopleft character varying(256),
  wmtexttopright character varying(256),
  wmtextbottomleft character varying(256),
  wmtextbottomright character varying(256),
  wmmainfontname character varying(64),
  wmmainfontsize character varying(2),
  wmmainfontstyle character(1),
  wmsubfontname character varying(64),
  wmsubfontsize character varying(2),
  wmsubfontstyle character(1),
  wmtextfontname character varying(64),
  wmtextfontsize character varying(2),
  wmtextfontstyle character(1),
  wmfontmainangle character varying(3),
  wmfontdensitymain character varying(2),
  wmfontdensitytext character varying(2),
  wmbackgroundmode character(1),
  wmbackgroundimage character varying(256),
  wmbackgroundpositionx character varying(4),
  wmbackgroundpositiony character varying(4),
  wmbackgroundimagewidth character varying(4),
  wmbackgroundimageheight character varying(4),
  lastmodifieddatetime timestamp without time zone,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_COMPANY_WATERMARK_CONFIG" PRIMARY KEY (companyid),
  CONSTRAINT "FK_COMPANY_WATERMARK_CONFIG_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
