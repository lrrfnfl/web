INSERT INTO admin (adminid, pwd, adminname, email, phone, mobilephone, admintype, companyid, accessableaddresstype, changefirstpasswordflag, passwordexpirationflag, passwordexpirationperiod, lastchangedpassworddatetime, loginflag, loginsessionid, lastlogindatetime, lockflag, lockdatetime, failedpasswordattemptcount, lastmodifieddatetime, createdatetime) VALUES ('spk_admin', ENCODE(DIGEST('tpdlvm@1234','sha256'),'hex'), 'SPK 관리자', NULL, NULL, NULL, '0', NULL, '0', '1', '0', 180, NULL, '0', NULL, NULL, '0', NULL, 0, NULL, date_trunc('minute', CURRENT_TIMESTAMP::timestamp without time zone));