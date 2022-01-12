-- Table: admin_accessable_address

-- DROP TABLE admin_accessable_address;

CREATE TABLE admin_accessable_address
(
  seqno serial NOT NULL,
  adminid character varying(32) NOT NULL,
  ipaddress character varying(64) NOT NULL,
  CONSTRAINT "PK_ADMIN_ACCESSABLE_ADDR" PRIMARY KEY (adminid, ipaddress),
  CONSTRAINT "FK_ADMIN_ACCESSABLE_ADDR_ADMIN" FOREIGN KEY (adminid)
      REFERENCES admin (adminid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
