-- Table: drm_permission_settings_log

-- DROP TABLE drm_permission_settings_log;

CREATE TABLE drm_permission_settings_log
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  filepath character varying(512) NOT NULL,
  filename character varying(128) NOT NULL,
  policyid character varying(64) NOT NULL,
  policyname character varying(64) NOT NULL,
  readpermission character(1) NOT NULL,
  writepermission character(1) NOT NULL,
  printpermission character(1) NOT NULL,
  expirationdate date NOT NULL,
  readlimitcount integer NOT NULL,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_DRM_PERMISSION_SETTINGS_LOG" PRIMARY KEY (seqno)
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_DRM_PERMISSION_SETTINGS_LOG_CREATEDATETIME"

-- DROP INDEX "IDX_DRM_PERMISSION_SETTINGS_LOG_CREATEDATETIME";

CREATE INDEX "IDX_DRM_PERMISSION_SETTINGS_LOG_CREATEDATETIME"
  ON drm_permission_settings_log
  USING btree
  (createdatetime);
ALTER TABLE drm_permission_settings_log CLUSTER ON "IDX_DRM_PERMISSION_SETTINGS_LOG_CREATEDATETIME";

-- Index: "IDX_DRM_PERMISSION_SETTINGS_LOG_MEMBER"

-- DROP INDEX "IDX_DRM_PERMISSION_SETTINGS_LOG_MEMBER";

CREATE INDEX "IDX_DRM_PERMISSION_SETTINGS_LOG_MEMBER"
  ON drm_permission_settings_log
  USING btree
  (companyid, deptcode, userid);

-- Index: "IDX_DRM_PERMISSION_SETTINGS_LOG_POLICY"

-- DROP INDEX "IDX_DRM_PERMISSION_SETTINGS_LOG_POLICY";

CREATE INDEX "IDX_DRM_PERMISSION_SETTINGS_LOG_POLICY"
  ON drm_permission_settings_log
  USING btree
  (policyid);
