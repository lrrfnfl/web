-- Table: ransomware_credential_exception_files

-- DROP TABLE ransomware_credential_exception_files;

CREATE TABLE ransomware_credential_exception_files
(
  seqno serial NOT NULL,
  filename character varying(128) NOT NULL,
  CONSTRAINT "PK_RANSOMWARE_CREDENTIAL_EXCEPTION_FILES" PRIMARY KEY (filename)
)
WITH (
  OIDS=FALSE
);
