/*****************************************************************************
 * 서버로의 요청을 위한 통신 전문 생성 루틴
 ****************************************************************************/

/*****************************************************************************
 * 테이블 삭제 요청
 ****************************************************************************/
getRequestDropTableParam = function(tableName) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DROP_TABLE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<TABLENAME>' + tableName + '</TABLENAME>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 뷰 삭제 요청
 ****************************************************************************/
getRequestDropViewParam = function(viewName) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DROP_VIEW</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<VIEWNAME>' + viewName + '</VIEWNAME>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 테이블 생성 요청
 ****************************************************************************/
getRequestCreateTableParam = function(tableName) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_TABLE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<TABLENAME>' + tableName + '</TABLENAME>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 뷰 생성 요청
 ****************************************************************************/
getRequestCreateViewParam = function(viewName) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_VIEW</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<VIEWNAME>' + viewName + '</VIEWNAME>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 테이블 초기화 요청
 ****************************************************************************/
getRequestInitTableParam = function(tableName) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_INIT_TABLE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<TABLENAME>' + tableName + '</TABLENAME>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 서버 설정 정보 요청
 ****************************************************************************/
getRequestServerConfigInfoParam = function() {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SERVER_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 서버 설정 저장 요청
 ****************************************************************************/
getRequestSaveServerConfigParam = function(serverType,
		version,
		oem,
		forcedLoginFlag,
		loginTrialLimitCount,
		reloginDelaySecondAfterLock,
		adminAccessableAddressMaxCount,
		representativeCompanyId) {

	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_SERVER_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SERVERTYPE>' + serverType + '</SERVERTYPE>';
	paramData += '<VERSION>' + version + '</VERSION>';
	paramData += '<OEM>' + oem + '</OEM>';
	paramData += '<FORCEDLOGINFLAG>' + forcedLoginFlag + '</FORCEDLOGINFLAG>';
	paramData += '<LOGINTRIALLIMITCOUNT>' + loginTrialLimitCount + '</LOGINTRIALLIMITCOUNT>';
	paramData += '<RELOGINDELAYSECONDAFTERLOCK>' + reloginDelaySecondAfterLock + '</RELOGINDELAYSECONDAFTERLOCK>';
	paramData += '<ADMINACCESSABLEADDRESSMAXCOUNT>' + adminAccessableAddressMaxCount + '</ADMINACCESSABLEADDRESSMAXCOUNT>';
	paramData += '<REPRESENTATIVECOMPANYID>' + representativeCompanyId + '</REPRESENTATIVECOMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * Theme 변경 요청
 ****************************************************************************/
getRequestChangeThemeParam = function(themeName) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CHANGE_THEME</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<THEMENAME>' + themeName + '</THEMENAME>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 유형 목록 요청
 ****************************************************************************/
getRequestTypeListParam = function(typeName) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_TYPE_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<TYPENAME>' + typeName + '</TYPENAME>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 폰트 목록 요청
 ****************************************************************************/
getRequestFontListParam = function() {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_FONT_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 관리자 로그인 요청
 ****************************************************************************/
getRequestAdminLoginParam = function(adminId, password, forcedLoginFlag) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_ADMIN_LOGIN</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<ADMINID>' + adminId + '</ADMINID>';
	paramData += '<PASSWORD>' + password + '</PASSWORD>';
	paramData += '<FORCEDLOGINFLAG>' + forcedLoginFlag + '</FORCEDLOGINFLAG>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 서비스 등록 요청
 ****************************************************************************/
getRequestApplicationServiceParam = function(operatorId, companyId, companyName,
		companyPostalCode, companyAddress, companyDetailAddress, managerName,
		managerEmail, managerPhone, managerMobilePhone, autoCreateDeptCodeFlag,
		adminId, password, adminName, email, phone, mobilePhone, licenceType,
		licenceStartDate, licenceEndDate, licenceCount, paymentType, approvalNo,
		paymentAmount, paymentDate) {

	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_APPLICATION_SERVICE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<COMPANYNAME>' + companyName + '</COMPANYNAME>';
	paramData += '<COMPANYPOSTALCODE>' + companyPostalCode + '</COMPANYPOSTALCODE>';
	paramData += '<COMPANYADDRESS>' + companyAddress + '</COMPANYADDRESS>';
	paramData += '<COMPANYDETAILADDRESS>' + companyDetailAddress + '</COMPANYDETAILADDRESS>';
	paramData += '<MANAGERNAME>' + managerName + '</MANAGERNAME>';
	paramData += '<MANAGEREMAIL>' + managerEmail + '</MANAGEREMAIL>';
	paramData += '<MANAGERPHONE>' + managerPhone + '</MANAGERPHONE>';
	paramData += '<MANAGERMOBILEPHONE>' + managerMobilePhone + '</MANAGERMOBILEPHONE>';
	paramData += '<AUTOCREATEDEPTCODEFLAG>' + autoCreateDeptCodeFlag + '</AUTOCREATEDEPTCODEFLAG>';
	paramData += '<ADMINID>' + adminId + '</ADMINID>';
	paramData += '<PASSWORD>' + password + '</PASSWORD>';
	paramData += '<ADMINNAME>' + adminName + '</ADMINNAME>';
	paramData += '<EMAIL>' + email + '</EMAIL>';
	paramData += '<PHONE>' + phone + '</PHONE>';
	paramData += '<MOBILEPHONE>' + mobilePhone + '</MOBILEPHONE>';
	paramData += '<LICENCETYPE>' + licenceType + '</LICENCETYPE>';
	paramData += '<LICENCESTARTDATE>' + licenceStartDate + '</LICENCESTARTDATE>';
	paramData += '<LICENCEENDDATE>' + licenceEndDate + '</LICENCEENDDATE>';
	paramData += '<LICENCECOUNT>' + licenceCount + '</LICENCECOUNT>';
	paramData += '<PAYMENTTYPE>' + paymentType + '</PAYMENTTYPE>';
	paramData += '<APPROVALNO>' + approvalNo + '</APPROVALNO>';
	paramData += '<PAYMENTAMOUNT>' + paymentAmount + '</PAYMENTAMOUNT>';
	paramData += '<PAYMENTDATE>' + paymentDate + '</PAYMENTDATE>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 서비스 연장 요청
 ****************************************************************************/
getRequestUpdateServiceParam = function(operatorId, companyId, licenceType,
		licenceStartDate, licenceEndDate, licenceCount, paymentType, approvalNo,
		paymentAmount, paymentDate) {

	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_UPDATE_SERVICE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<LICENCETYPE>' + licenceType + '</LICENCETYPE>';
	paramData += '<LICENCESTARTDATE>' + licenceStartDate + '</LICENCESTARTDATE>';
	paramData += '<LICENCEENDDATE>' + licenceEndDate + '</LICENCEENDDATE>';
	paramData += '<LICENCECOUNT>' + licenceCount + '</LICENCECOUNT>';
	paramData += '<PAYMENTTYPE>' + paymentType + '</PAYMENTTYPE>';
	paramData += '<APPROVALNO>' + approvalNo + '</APPROVALNO>';
	paramData += '<PAYMENTAMOUNT>' + paymentAmount + '</PAYMENTAMOUNT>';
	paramData += '<PAYMENTDATE>' + paymentDate + '</PAYMENTDATE>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 트리 노드 요청
 ****************************************************************************/
getRequestCompanyTreeNodesParam = function(treeViewType, categoryCode, companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_COMPANY_TREE_NODES</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<TREEVIEWTYPE>' + treeViewType + '</TREEVIEWTYPE>';
	paramData += '<CATEGORYCODE>' + categoryCode + '</CATEGORYCODE>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 목록 요청
 ****************************************************************************/
getRequestCompanyListParam = function(companyId, companyName, serviceState, 
		orderByName, orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_COMPANY_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<COMPANYNAME>' + companyName + '</COMPANYNAME>';
	paramData += '<SERVICESTATE>' + serviceState + '</SERVICESTATE>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 정보 요청
 ****************************************************************************/
getRequestCompanyInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_COMPANY_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 정보 요청 - By Id
 ****************************************************************************/
getRequestCompanyInfoByIdParam = function(companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_COMPANY_INFO_BY_ID</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 등록 요청
 ****************************************************************************/
getRequestInsertCompanyParam = function(operatorId, companyId, companyName,
		companyPostalCode, companyAddress, companyDetailAddress, managerName,
		managerEmail, managerPhone, managerMobilePhone, autoCreateDeptCodeFlag,
		htCompanySetupConfigData, arrPatternList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_INSERT_COMPANY</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<COMPANYNAME>' + companyName + '</COMPANYNAME>';
	paramData += '<COMPANYPOSTALCODE>' + companyPostalCode + '</COMPANYPOSTALCODE>';
	paramData += '<COMPANYADDRESS>' + companyAddress + '</COMPANYADDRESS>';
	paramData += '<COMPANYDETAILADDRESS>' + companyDetailAddress + '</COMPANYDETAILADDRESS>';
	paramData += '<MANAGERNAME>' + managerName + '</MANAGERNAME>';
	paramData += '<MANAGEREMAIL>' + managerEmail + '</MANAGEREMAIL>';
	paramData += '<MANAGERPHONE>' + managerPhone + '</MANAGERPHONE>';
	paramData += '<MANAGERMOBILEPHONE>' + managerMobilePhone + '</MANAGERMOBILEPHONE>';
	paramData += '<AUTOCREATEDEPTCODEFLAG>' + autoCreateDeptCodeFlag + '</AUTOCREATEDEPTCODEFLAG>';
	paramData += '<SETUPCONFIG>';
	if (!htCompanySetupConfigData.isEmpty()) {
		htCompanySetupConfigData.each( function(name, value) {
			paramData += '<' + name.toUpperCase() + '>';
			paramData += value;
			paramData += '</' + name.toUpperCase() + '>';
		});
	}
	paramData += '</SETUPCONFIG>';
	paramData += '<PATTERNLIST>';
	if ($.isArray(arrPatternList) ) {
		$.each(arrPatternList, function(rowIdx, arrPattern) {
			paramData += '<PATTERN>';
			paramData += '<PATTERNID>' + arrPattern[0] + '</PATTERNID>';
			paramData += '<PATTERNSUBID>' + arrPattern[1] + '</PATTERNSUBID>';
			paramData += '</PATTERN>';
		});
	}
	paramData += '</PATTERNLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 정보 수정 요청
 ****************************************************************************/
getRequestUpdateCompanyParam = function(operatorId, companyId, companyName,
		companyPostalCode, companyAddress, companyDetailAddress, managerName,
		managerEmail, managerPhone, managerMobilePhone, autoCreateDeptCodeFlag,
		htCompanySetupConfigData, arrPatternList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_UPDATE_COMPANY</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<COMPANYNAME>' + companyName + '</COMPANYNAME>';
	paramData += '<COMPANYPOSTALCODE>' + companyPostalCode + '</COMPANYPOSTALCODE>';
	paramData += '<COMPANYADDRESS>' + companyAddress + '</COMPANYADDRESS>';
	paramData += '<COMPANYDETAILADDRESS>' + companyDetailAddress + '</COMPANYDETAILADDRESS>';
	paramData += '<MANAGERNAME>' + managerName + '</MANAGERNAME>';
	paramData += '<MANAGEREMAIL>' + managerEmail + '</MANAGEREMAIL>';
	paramData += '<MANAGERPHONE>' + managerPhone + '</MANAGERPHONE>';
	paramData += '<MANAGERMOBILEPHONE>' + managerMobilePhone + '</MANAGERMOBILEPHONE>';
	paramData += '<AUTOCREATEDEPTCODEFLAG>' + autoCreateDeptCodeFlag + '</AUTOCREATEDEPTCODEFLAG>';
	paramData += '<SETUPCONFIG>';
	if (!htCompanySetupConfigData.isEmpty()) {
		htCompanySetupConfigData.each( function(name, value) {
			paramData += '<' + name.toUpperCase() + '>';
			paramData += value;
			paramData += '</' + name.toUpperCase() + '>';
		});
	}
	paramData += '</SETUPCONFIG>';
	paramData += '<PATTERNLIST>';
	if ($.isArray(arrPatternList) ) {
		$.each(arrPatternList, function(rowIdx, arrPattern) {
			paramData += '<PATTERN>';
			paramData += '<PATTERNID>' + arrPattern[0] + '</PATTERNID>';
			paramData += '<PATTERNSUBID>' + arrPattern[1] + '</PATTERNSUBID>';
			paramData += '</PATTERN>';
		});
	}
	paramData += '</PATTERNLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 서비스 상태 변경 요청
 ****************************************************************************/
getRequestChangeCompanyServiceStateParam = function(operatorId, companyId, serviceStateFlag) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CHANGE_COMPANY_SERVICE_STATE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<SERVICESTATEFLAG>' + serviceStateFlag + '</SERVICESTATEFLAG>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 삭제 요청
 ****************************************************************************/
getRequestDeleteCompanyParam = function(operatorId, companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DELETE_COMPANY</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 라이센스 목록 요청
 ****************************************************************************/
getRequestLicenceListParam = function(licenceType, licenceEndDate,
		orderByName, orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_LICENCE_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<LICENCETYPE>' + licenceType + '</LICENCETYPE>';
	paramData += '<LICENCEENDDATE>' + licenceEndDate + '</LICENCEENDDATE>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 라이센스 정보 요청
 ****************************************************************************/
getRequestLicenceInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_LICENCE_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 라이센스 정보 요청 - By Id
 ****************************************************************************/
getRequestLicenceInfoByIdParam = function(companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_LICENCE_INFO_BY_ID</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 라이센스 등록 요청
 ****************************************************************************/
getRequestInsertLicenceParam = function(operatorId, companyId,
		licenceType, licenceStartDate, licenceEndDate, licenceCount, dbProtectionLicenceCount) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_INSERT_LICENCE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<LICENCETYPE>' + licenceType + '</LICENCETYPE>';
	paramData += '<LICENCESTARTDATE>' + licenceStartDate + '</LICENCESTARTDATE>';
	paramData += '<LICENCEENDDATE>' + licenceEndDate + '</LICENCEENDDATE>';
	paramData += '<LICENCECOUNT>' + licenceCount + '</LICENCECOUNT>';
	paramData += '<DBPROTECTIONLICENCECOUNT>' + dbProtectionLicenceCount + '</DBPROTECTIONLICENCECOUNT>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 라이센스 정보 수정 요청
 ****************************************************************************/
getRequestUpdateLicenceParam = function(operatorId, companyId,
		licenceType, licenceStartDate, licenceEndDate, licenceCount,
		dbProtectionLicenceCount, paymentType, approvalNo, paymentAmount,
		paymentDate, comments) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_UPDATE_LICENCE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<LICENCETYPE>' + licenceType + '</LICENCETYPE>';
	paramData += '<LICENCESTARTDATE>' + licenceStartDate + '</LICENCESTARTDATE>';
	paramData += '<LICENCEENDDATE>' + licenceEndDate + '</LICENCEENDDATE>';
	paramData += '<LICENCECOUNT>' + licenceCount + '</LICENCECOUNT>';
	paramData += '<DBPROTECTIONLICENCECOUNT>' + dbProtectionLicenceCount + '</DBPROTECTIONLICENCECOUNT>';
	paramData += '<PAYMENTTYPE>' + paymentType + '</PAYMENTTYPE>';
	paramData += '<APPROVALNO>' + approvalNo + '</APPROVALNO>';
	paramData += '<PAYMENTAMOUNT>' + paymentAmount + '</PAYMENTAMOUNT>';
	paramData += '<PAYMENTDATE>' + paymentDate + '</PAYMENTDATE>';
	paramData += '<COMMENTS><![CDATA[' + comments + ']]></COMMENTS>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 라이센스 삭제 요청
 ****************************************************************************/
getRequestDeleteLicenceParam = function(operatorId, companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DELETE_LICENCE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 라이센스 변경 목록 요청
 ****************************************************************************/
getRequestLicenceRenewalHistoryListParam = function(companyId,
		searchDateFrom, searchDateTo, orderByName, orderByDirection,
		readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_LICENCE_RENEWAL_HISTORY_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 라이센스 변경 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateLicenceRenewalHistoryListFileParam = function(companyId,
		searchDateFrom, searchDateTo, orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_LICENCE_RENEWAL_HISTORY_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 라이센스 변경 정보 요청
 ****************************************************************************/
getRequestLicenceRenewalHistoryInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_LICENCE_RENEWAL_HISTORY_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 결제 내역 목록 요청
 ****************************************************************************/
getRequestPaymentListParam = function(companyId, approvalNo,
		paymentType, searchDateFrom, searchDateTo, orderByName,
		orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_PAYMENT_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<APPROVALNO>' + approvalNo + '</APPROVALNO>';
	paramData += '<PAYMENTTYPE>' + paymentType + '</PAYMENTTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 결제 내역 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreatePaymentListFileParam = function(companyId, approvalNo,
		paymentType, searchDateFrom, searchDateTo, orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_PAYMENT_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<APPROVALNO>' + approvalNo + '</APPROVALNO>';
	paramData += '<PAYMENTTYPE>' + paymentType + '</PAYMENTTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 결제 내역 정보 요청
 ****************************************************************************/
getRequestPaymentInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_PAYMENT_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 관리자 트리 노드 요청
 ****************************************************************************/
getRequestAdminTreeNodesParam = function(adminType, companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_ADMIN_TREE_NODES</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<ADMINTYPE>' + adminType + '</ADMINTYPE>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 관리자 목록 요청
 ****************************************************************************/
getRequestAdminListParam = function(adminName, adminType, companyId,
		orderByName, orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_ADMIN_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<ADMINNAME>' + adminName + '</ADMINNAME>';
	paramData += '<ADMINTYPE>' + adminType + '</ADMINTYPE>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 관리자 정보 요청
 ****************************************************************************/
getRequestAdminInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_ADMIN_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 관리자 정보 요청 - By Id
 ****************************************************************************/
getRequestAdminInfoByIdParam = function(adminId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_ADMIN_INFO_BY_ID</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<ADMINID>' + adminId + '</ADMINID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 관리자 등록 요청
 ****************************************************************************/
getRequestInsertAdminParam = function(operatorId, adminId,
		password, adminName, email, phone, mobilePhone,
		adminType, companyId, passwordExpirationFlag, passwordExpirationPeriod) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_INSERT_ADMIN</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<ADMINID>' + adminId + '</ADMINID>';
	paramData += '<PASSWORD>' + password + '</PASSWORD>';
	paramData += '<ADMINNAME>' + adminName + '</ADMINNAME>';
	paramData += '<EMAIL>' + email + '</EMAIL>';
	paramData += '<PHONE>' + phone + '</PHONE>';
	paramData += '<MOBILEPHONE>' + mobilePhone + '</MOBILEPHONE>';
	paramData += '<ADMINTYPE>' + adminType + '</ADMINTYPE>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<PASSWORDEXPIRATIONFLAG>' + passwordExpirationFlag + '</PASSWORDEXPIRATIONFLAG>';
	paramData += '<PASSWORDEXPIRATIONPERIOD>' + passwordExpirationPeriod + '</PASSWORDEXPIRATIONPERIOD>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 관리자 정보 수정 요청
 ****************************************************************************/
getRequestUpdateAdminParam = function(operatorId, adminId,
		adminName, email, phone, mobilePhone, adminType,
		companyId, passwordExpirationFlag, passwordExpirationPeriod) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_UPDATE_ADMIN</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<ADMINID>' + adminId + '</ADMINID>';
	paramData += '<ADMINNAME>' + adminName + '</ADMINNAME>';
	paramData += '<EMAIL>' + email + '</EMAIL>';
	paramData += '<PHONE>' + phone + '</PHONE>';
	paramData += '<MOBILEPHONE>' + mobilePhone + '</MOBILEPHONE>';
	paramData += '<ADMINTYPE>' + adminType + '</ADMINTYPE>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<PASSWORDEXPIRATIONFLAG>' + passwordExpirationFlag + '</PASSWORDEXPIRATIONFLAG>';
	paramData += '<PASSWORDEXPIRATIONPERIOD>' + passwordExpirationPeriod + '</PASSWORDEXPIRATIONPERIOD>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 관리자 잠김 해제 요청
 ****************************************************************************/
getRequestUnlockAdminParam = function(operatorId, adminId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_UNLOCK_ADMIN</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<ADMINID>' + adminId + '</ADMINID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 관리자 비밀번호 변경 요청
 ****************************************************************************/
getRequestChangeAdminPasswordParam = function(operatorId,
		adminId, oldPassword, password) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CHANGE_ADMIN_PASSWORD</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<ADMINID>' + adminId + '</ADMINID>';
	paramData += '<OLDPASSWORD>' + oldPassword + '</OLDPASSWORD>';
	paramData += '<PASSWORD>' + password + '</PASSWORD>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 관리자 비밀번호 초기화 요청
 ****************************************************************************/
getRequestResetAdminPasswordParam = function(operatorId,
		adminId, password) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_RESET_ADMIN_PASSWORD</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<ADMINID>' + adminId + '</ADMINID>';
	paramData += '<PASSWORD>' + password + '</PASSWORD>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 관리자 삭제 요청
 ****************************************************************************/
getRequestDeleteAdminParam = function(operatorId, adminId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DELETE_ADMIN</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<ADMINID>' + adminId + '</ADMINID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 관리자 접속 제한 주소 정보 요청
 ****************************************************************************/
getRequestAdminAccessableAddressInfoParam = function(adminId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_ADMIN_ACCESSABLE_ADDRESS_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<ADMINID>' + adminId + '</ADMINID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 관리자 접속 제한 주소 적용 요청
 ****************************************************************************/
getRequestApplyAdminAccessableAddressParam = function(operatorId, 
		adminId, accessableAddressType, accessableAddressList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_APPLY_ADMIN_ACCESSABLE_ADDRESS</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<ADMINID>' + adminId + '</ADMINID>';
	paramData += '<ACCESSABLEADDRESSTYPE>' + accessableAddressType + '</ACCESSABLEADDRESSTYPE>';
	paramData += '<ACCESSABLEADDRESSLIST>';
	if ($.isArray(accessableAddressList) ) {
		$.each(accessableAddressList, function(rowIdx, colVal) {
			paramData += '<ACCESSABLEADDRESS>';
			paramData += '<IPADDRESS>' + colVal + '</IPADDRESS>';
			paramData += '</ACCESSABLEADDRESS>';
		});
	}
	paramData += '</ACCESSABLEADDRESSLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 관리자 로그 목록 요청
 ****************************************************************************/
getRequestAdminLogListParam = function(adminId, adminType,
		companyId, jobType,	jobCategory, searchDateFrom,
		searchDateTo, orderByName, orderByDirection,
		readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_ADMIN_LOG_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<ADMINID>' + adminId + '</ADMINID>';
	paramData += '<ADMINTYPE>' + adminType + '</ADMINTYPE>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<JOBTYPE>' + jobType + '</JOBTYPE>';
	paramData += '<JOBCATEGORY>' + jobCategory + '</JOBCATEGORY>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 관리자 로그 정보 요청
 ****************************************************************************/
getRequestAdminLogInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_ADMIN_LOG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 패턴 트리 노드 요청
 ****************************************************************************/
getRequestPatternTreeNodesParam = function(patternId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_PATTERN_TREE_NODES</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<PATTERNID>' + patternId + '</PATTERNID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 패턴 목록 요청
 ****************************************************************************/
getRequestPatternListParam = function(patternId, patternName, defaultSearchFlag,
		orderByName, orderByDirection, readRecordCount,
		readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_PATTERN_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<PATTERNID>' + patternId + '</PATTERNID>';
	paramData += '<PATTERNNAME>' + patternName + '</PATTERNNAME>';
	paramData += '<DEFAULTSEARCHFLAG>' + defaultSearchFlag + '</DEFAULTSEARCHFLAG>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 패턴 정보 요청
 ****************************************************************************/
getRequestPatternInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_PATTERN_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 패턴 정보 요청 - By Id
 ****************************************************************************/
getRequestPatternInfoByIdParam = function(patternId, patternSubId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_PATTERN_INFO_BY_ID</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<PATTERNID>' + patternId + '</PATTERNID>';
	paramData += '<PATTERNSUBID>' + patternSubId + '</PATTERNSUBID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 패턴 등록 요청
 ****************************************************************************/
getRequestInsertPatternParam = function(operatorId, patternId, patternCategoryName,
		patternSubId, patternName, patternText, defaultSearchFlag) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_INSERT_PATTERN</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<PATTERNID>' + patternId + '</PATTERNID>';
	paramData += '<PATTERNCATEGORYNAME>' + patternCategoryName + '</PATTERNCATEGORYNAME>';
	paramData += '<PATTERNSUBID>' + patternSubId + '</PATTERNSUBID>';
	paramData += '<PATTERNNAME>' + patternName + '</PATTERNNAME>';
	paramData += '<PATTERNTEXT><![CDATA[' + patternText + ']]></PATTERNTEXT>';
	paramData += '<DEFAULTSEARCHFLAG>' + defaultSearchFlag + '</DEFAULTSEARCHFLAG>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 패턴 정보 수정 요청
 ****************************************************************************/
getRequestUpdatePatternParam = function(operatorId, patternId, patternCategoryName,
		patternSubId, patternName, patternText, defaultSearchFlag) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_UPDATE_PATTERN</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<PATTERNID>' + patternId + '</PATTERNID>';
	paramData += '<PATTERNCATEGORYNAME>' + patternCategoryName + '</PATTERNCATEGORYNAME>';
	paramData += '<PATTERNSUBID>' + patternSubId + '</PATTERNSUBID>';
	paramData += '<PATTERNNAME>' + patternName + '</PATTERNNAME>';
	paramData += '<PATTERNTEXT><![CDATA[' + patternText + ']]></PATTERNTEXT>';
	paramData += '<DEFAULTSEARCHFLAG>' + defaultSearchFlag + '</DEFAULTSEARCHFLAG>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 패턴 삭제 요청
 ****************************************************************************/
getRequestDeletePatternParam = function(operatorId, patternId, patternSubId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DELETE_PATTERN</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<PATTERNID>' + patternId + '</PATTERNID>';
	paramData += '<PATTERNSUBID>' + patternSubId + '</PATTERNSUBID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 네트워크 서비스 제어 프로그램 목록 요청
 ****************************************************************************/
getRequestNetworkServiceControlProgramListParam = function(programName, programType,
		orderByName, orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_NETWORK_SERVICE_CONTROL_PROGRAM_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<PROGRAMNAME>' + programName + '</PROGRAMNAME>';
	paramData += '<PROGRAMTYPE>' + programType + '</PROGRAMTYPE>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 네트워크 서비스 제어 프로그램 정보 요청
 ****************************************************************************/
getRequestNetworkServiceControlProgramInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_NETWORK_SERVICE_CONTROL_PROGRAM_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 네트워크 서비스 제어 프로그램 정보 요청 - By FileName
 ****************************************************************************/
getRequestNetworkServiceControlProgramInfoByFileNameParam = function(fileName) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_NETWORK_SERVICE_CONTROL_PROGRAM_INFO_BY_FILENAME</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<FILENAME>' + fileName + '</FILENAME>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 네트워크 서비스 제어 프로그램 등록 요청
 ****************************************************************************/
getRequestInsertNetworkServiceControlProgramParam = function(operatorId,
		programName, fileName, programType) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_INSERT_NETWORK_SERVICE_CONTROL_PROGRAM</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<PROGRAMNAME>' + programName + '</PROGRAMNAME>';
	paramData += '<FILENAME>' + fileName + '</FILENAME>';
	paramData += '<PROGRAMTYPE>' + programType + '</PROGRAMTYPE>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 네트워크 서비스 제어 프로그램 정보 수정 요청
 ****************************************************************************/
getRequestUpdateNetworkServiceControlProgramParam = function(operatorId,
		programName, fileName, programType) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_UPDATE_NETWORK_SERVICE_CONTROL_PROGRAM</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<PROGRAMNAME>' + programName + '</PROGRAMNAME>';
	paramData += '<FILENAME>' + fileName + '</FILENAME>';
	paramData += '<PROGRAMTYPE>' + programType + '</PROGRAMTYPE>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 네트워크 서비스 제어 프로그램 삭제 요청
 ****************************************************************************/
getRequestDeleteNetworkServiceControlProgramParam = function(operatorId, fileName) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DELETE_NETWORK_SERVICE_CONTROL_PROGRAM</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<FILENAME>' + fileName + '</FILENAME>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 랜섬웨어 신뢰정보 예외 파일 목록 요청
 ****************************************************************************/
getRequestRansomwareCredentialExceptionFileListParam = function(
		categoryName, fileName, orderByName, orderByDirection,
		readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_RANSOMWARE_CREDENTIAL_EXCEPTION_FILE_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<CATEGORYNAME>' + categoryName + '</CATEGORYNAME>';
	paramData += '<FILENAME>' + fileName + '</FILENAME>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 랜섬웨어 신뢰정보 예외 파일 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateRansomwareCredentialExceptionFileListFileParam = function(
		categoryName, fileName, orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_RANSOMWARE_CREDENTIAL_EXCEPTION_FILE_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<CATEGORYNAME>' + categoryName + '</CATEGORYNAME>';
	paramData += '<FILENAME>' + fileName + '</FILENAME>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 랜섬웨어 신뢰정보 예외 파일 등록 요청
 ****************************************************************************/
getRequestInsertRansomwareCredentialExceptionFileParam = function(
		operatorId, fileName) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_INSERT_RANSOMWARE_CREDENTIAL_EXCEPTION_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<FILENAME>' + fileName + '</FILENAME>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 랜섬웨어 신뢰정보 예외 파일 삭제 요청
 ****************************************************************************/
getRequestDeleteRansomwareCredentialExceptionFileParam = function(
		operatorId, arrFileList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DELETE_RANSOMWARE_CREDENTIAL_EXCEPTION_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<FILELIST>';
	if ($.isArray(arrFileList) ) {
		$.each(arrFileList, function(rowIdx, colVal) {
			paramData += '<FILE>';
			paramData += '<FILENAME>' + colVal + '</FILENAME>';
			paramData += '</FILE>';
		});
	}
	paramData += '</FILELIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 랜섬웨어 행위분석 예외 파일 목록 요청
 ****************************************************************************/
getRequestRansomwareBehaviorProfileExceptionFileListParam = function(
		categoryName, fileName, orderByName, orderByDirection,
		readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_RANSOMWARE_BEHAVIOR_PROFILE_EXCEPTION_FILE_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<CATEGORYNAME>' + categoryName + '</CATEGORYNAME>';
	paramData += '<FILENAME>' + fileName + '</FILENAME>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 랜섬웨어 행위분석 예외 파일 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateRansomwareBehaviorProfileExceptionFileListFileParam = function(
		categoryName, fileName, orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_RANSOMWARE_BEHAVIOR_PROFILE_EXCEPTION_FILE_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<CATEGORYNAME>' + categoryName + '</CATEGORYNAME>';
	paramData += '<FILENAME>' + fileName + '</FILENAME>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 랜섬웨어 행위분석 예외 파일 등록 요청
 ****************************************************************************/
getRequestInsertRansomwareBehaviorProfileExceptionFileParam = function(
		operatorId, fileName) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_INSERT_RANSOMWARE_BEHAVIOR_PROFILE_EXCEPTION_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<FILENAME>' + fileName + '</FILENAME>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 랜섬웨어 행위분석 예외 파일 삭제 요청
 ****************************************************************************/
getRequestDeleteRansomwareBehaviorProfileExceptionFileParam = function(
		operatorId, arrFileList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DELETE_RANSOMWARE_BEHAVIOR_PROFILE_EXCEPTION_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<FILELIST>';
	if ($.isArray(arrFileList) ) {
		$.each(arrFileList, function(rowIdx, colVal) {
			paramData += '<FILE>';
			paramData += '<FILENAME>' + colVal + '</FILENAME>';
			paramData += '</FILE>';
		});
	}
	paramData += '</FILELIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * API 호출 가능 주소 목록 요청
 ****************************************************************************/
getRequestAPICallableAddressListParam = function(ipAddress,
		orderByName, orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_API_CALLABLE_ADDRESS_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<IPADDRESS>' + ipAddress + '</IPADDRESS>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * API 호출 가능 주소 정보 요청
 ****************************************************************************/
getRequestAPICallableAddressInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_API_CALLABLE_ADDRESS_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * API 호출 가능 주소 등록 요청
 ****************************************************************************/
getRequestInsertAPICallableAddressParam = function(operatorId,
		ipAddress, callerName) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_INSERT_API_CALLABLE_ADDRESS</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<IPADDRESS>' + ipAddress + '</IPADDRESS>';
	paramData += '<CALLERNAME>' + callerName + '</CALLERNAME>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * API 호출 가능 주소 정보 수정 요청
 ****************************************************************************/
getRequestUpdateAPICallableAddressParam = function(operatorId,
		ipAddress, callerName) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_UPDATE_API_CALLABLE_ADDRESS</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<IPADDRESS>' + ipAddress + '</IPADDRESS>';
	paramData += '<CALLERNAME>' + callerName + '</CALLERNAME>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * API 호출 가능 주소 삭제 요청
 ****************************************************************************/
getRequestDeleteAPICallableAddressParam = function(operatorId, ipAddress) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DELETE_API_CALLABLE_ADDRESS</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<IPADDRESS>' + ipAddress + '</IPADDRESS>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 에이전트 업데이트 다운로드 경로 목록 요청
 ****************************************************************************/
getRequestAgentUpdateDownloadPathListParam = function() {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_AGENT_UPDATE_DOWNLOAD_PATH_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 에이전트 업데이트 정보 파일 목록 요청
 ****************************************************************************/
getRequestAgentUpdateInfoFileListParam = function(downloadPath) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_AGENT_UPDATE_INFO_FILE_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<DOWNLOADPATH>' + downloadPath + '</DOWNLOADPATH>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 에이전트 업데이트 목록 요청
 ****************************************************************************/
getRequestAgentUpdateListParam = function(title, content,
		distributeState, searchDateFrom, searchDateTo, orderByName, 
		orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_AGENT_UPDATE_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<TITLE>' + title + '</TITLE>';
	paramData += '<CONTENT>' + content + '</CONTENT>';
	paramData += '<DISTRIBUTESTATE>' + distributeState + '</DISTRIBUTESTATE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 에이전트 업데이트 정보 요청
 ****************************************************************************/
getRequestAgentUpdateInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_AGENT_UPDATE_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 에이전트 업데이트 등록 요청
 ****************************************************************************/
getRequestInsertAgentUpdateParam = function(operatorId, version, title,
		content, companyId, downloadPath, infoFileName) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_INSERT_AGENT_UPDATE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<VERSION>' + version + '</VERSION>';
	paramData += '<TITLE>' + title + '</TITLE>';
	paramData += '<CONTENT>' + content + '</CONTENT>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DOWNLOADPATH>' + downloadPath + '</DOWNLOADPATH>';
	paramData += '<INFOFILENAME>' + infoFileName + '</INFOFILENAME>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 에이전트 업데이트 정보 수정 요청
 ****************************************************************************/
getRequestUpdateAgentUpdateParam = function(operatorId, version, title,
		content, companyId, downloadPath, infoFileName) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_UPDATE_AGENT_UPDATE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<VERSION>' + version + '</VERSION>';
	paramData += '<TITLE>' + title + '</TITLE>';
	paramData += '<CONTENT>' + content + '</CONTENT>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DOWNLOADPATH>' + downloadPath + '</DOWNLOADPATH>';
	paramData += '<INFOFILENAME>' + infoFileName + '</INFOFILENAME>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 에이전트 업데이트 배포 상태 변경 요청
 ****************************************************************************/
getRequestChangeAgentUpdateDistributeStateParam = function(operatorId, version,
		distributeState) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CHANGE_AGENT_UPDATE_DISTRIBUTE_STATE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<VERSION>' + version + '</VERSION>';
	paramData += '<DISTRIBUTESTATE>' + distributeState + '</DISTRIBUTESTATE>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 에이전트 업데이트 삭제 요청
 ****************************************************************************/
getRequestDeleteAgentUpdateParam = function(operatorId, version) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DELETE_AGENT_UPDATE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<VERSION>' + version + '</VERSION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서 트리 노드 요청
 ****************************************************************************/
getRequestDeptTreeNodesParam = function(companyId, parentDeptCode, includeUserNodes) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DEPT_TREE_NODES</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<PARENTDEPTCODE>' + parentDeptCode + '</PARENTDEPTCODE>';
	paramData += '<INCLUDEUSERNODES>' + includeUserNodes + '</INCLUDEUSERNODES>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서 목록 요청
 ****************************************************************************/
getRequestDeptListParam = function(companyId, deptName, 
		orderByName, orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DEPT_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTNAME>' + deptName + '</DEPTNAME>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서 정보 요청
 ****************************************************************************/
getRequestDeptInfoParam = function(companyId, deptCode) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DEPT_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서 등록 요청
 ****************************************************************************/
getRequestInsertDeptParam = function(operatorId, companyId,
		deptCode, deptName, parentDeptCode) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_INSERT_DEPT</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '<DEPTNAME>' + deptName + '</DEPTNAME>';
	paramData += '<PARENTDEPTCODE>' + parentDeptCode + '</PARENTDEPTCODE>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서 정보 수정 요청
 ****************************************************************************/
getRequestUpdateDeptParam = function(operatorId, companyId,
		deptCode, deptName, parentDeptCode) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_UPDATE_DEPT</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '<DEPTNAME>' + deptName + '</DEPTNAME>';
	paramData += '<PARENTDEPTCODE>' + parentDeptCode + '</PARENTDEPTCODE>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서 삭제 요청
 ****************************************************************************/
getRequestDeleteDeptParam = function(operatorId, companyId,
		deptCode) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DELETE_DEPT</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 목록 요청
 ****************************************************************************/
getRequestUserListParam = function(companyId, arrDeptList, userName,
		userType, installFlag, serviceState, orderByName, orderByDirection,
		readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_USER_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERNAME>' + userName + '</USERNAME>';
	paramData += '<USERTYPE>' + userType + '</USERTYPE>';
	paramData += '<INSTALLFLAG>' + installFlag + '</INSTALLFLAG>';
	paramData += '<SERVICESTATE>' + serviceState + '</SERVICESTATE>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateUserListFileParam = function(companyId, arrDeptList, userName,
		userType, installFlag, serviceState, orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_USER_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERNAME>' + userName + '</USERNAME>';
	paramData += '<USERTYPE>' + userType + '</USERTYPE>';
	paramData += '<INSTALLFLAG>' + installFlag + '</INSTALLFLAG>';
	paramData += '<SERVICESTATE>' + serviceState + '</SERVICESTATE>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 정보 요청
 ****************************************************************************/
getRequestUserInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_USER_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 등록 요청
 ****************************************************************************/
getRequestInsertUserParam = function(operatorId, companyId, userId,
		password, userName, email, phone, mobilePhone, deptCode, userType) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_INSERT_USER</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<PASSWORD>' + password + '</PASSWORD>';
	paramData += '<USERNAME>' + userName + '</USERNAME>';
	paramData += '<EMAIL>' + email + '</EMAIL>';
	paramData += '<PHONE>' + phone + '</PHONE>';
	paramData += '<MOBILEPHONE>' + mobilePhone + '</MOBILEPHONE>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '<USERTYPE>' + userType + '</USERTYPE>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 정보 수정 요청
 ****************************************************************************/
getRequestUpdateUserParam = function(operatorId, companyId, userId,
		userName, email, phone, mobilePhone, deptCode, userType) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_UPDATE_USER</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<USERNAME>' + userName + '</USERNAME>';
	paramData += '<EMAIL>' + email + '</EMAIL>';
	paramData += '<PHONE>' + phone + '</PHONE>';
	paramData += '<MOBILEPHONE>' + mobilePhone + '</MOBILEPHONE>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '<USERTYPE>' + userType + '</USERTYPE>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 서비스 상태 변경 요청
 ****************************************************************************/
getRequestChangeUserServiceStateParam = function(operatorId, companyId, userId,
		serviceStateFlag) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CHANGE_USER_SERVICE_STATE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<SERVICESTATEFLAG>' + serviceStateFlag + '</SERVICESTATEFLAG>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 부서 일괄 변경 요청
 ****************************************************************************/
getRequestBatchUpdateUserDeptParam = function(operatorId, companyId,
		targetType, targetDeptCode, arrTargetUserList, deptCode) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_BATCH_UPDATE_USER_DEPT</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<TARGETTYPE>' + targetType + '</TARGETTYPE>';
	paramData += '<TARGETDEPTCODE>' + targetDeptCode + '</TARGETDEPTCODE>';
	paramData += '<TARGETUSERLIST>';
	if ($.isArray(arrTargetUserList) ) {
		$.each(arrTargetUserList, function(rowIdx, colVal) {
			paramData += '<USER>';
			paramData += '<USERID>' + colVal + '</USERID>';
			paramData += '</USER>';
		});
	}
	paramData += '</TARGETUSERLIST>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 비밀번호 초기화 요청
 ****************************************************************************/
getRequestResetUserPasswordParam = function(operatorId, companyId,
		userId, password) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_RESET_USER_PASSWORD</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<PASSWORD>' + password + '</PASSWORD>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 삭제 요청
 ****************************************************************************/
getRequestDeleteUserParam = function(operatorId, companyId, userId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DELETE_USER</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 일괄 삭제 요청
 ****************************************************************************/
getRequestBatchDeleteUserParam = function(operatorId, arrUserList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_BATCH_DELETE_USER</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<USERLIST>';
	if ($.isArray(arrUserList) ) {
		$.each(arrUserList, function(rowIdx, arrTargetUser) {
			paramData += '<USER>';
			$.each(arrTargetUser, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<USERID>' + colVal + '</USERID>';
				}
			});
			paramData += '</USER>';
		});
	}
	paramData += '</USERLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 배치 등록 형식 파일 생성 요청
 ****************************************************************************/
getRequestCreateBatchUserRegistFormatFileParam = function(companyId,
		orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_BATCH_USER_REGIST_FORMAT_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 배치 등록을 위한 사용자 목록 요청
 ****************************************************************************/
getRequestUserListForBatchRegistParam = function(fileName) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_USER_LIST_FOR_BATCH_REGIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<FILENAME>' + fileName + '</FILENAME>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 동기화 설정 정보 요청
 ****************************************************************************/
getRequestUserSynchronizationConfigInfoParam = function(companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_USER_SYNCHRONIZATION_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 동기화 설정 저장 요청
 ****************************************************************************/
getRequestSaveUserSynchronizationConfigParam = function(operatorId, companyId,
		dbType, dbIp, dbPort, dbSid, dbAccountId, dbAccountPassword,
		sqlQuery, exceptionUserList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_USER_SYNCHRONIZATION_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DBTYPE>' + dbType + '</DBTYPE>';
	paramData += '<DBIP>' + dbIp + '</DBIP>';
	paramData += '<DBPORT>' + dbPort + '</DBPORT>';
	paramData += '<DBSID>' + dbSid + '</DBSID>';
	paramData += '<DBACCOUNTID>' + dbAccountId + '</DBACCOUNTID>';
	paramData += '<DBACCOUNTPASSWORD>' + dbAccountPassword + '</DBACCOUNTPASSWORD>';
	paramData += '<SQLQUERY><![CDATA[' + sqlQuery + ']]></SQLQUERY>';
	paramData += '<EXCEPTIONUSERLIST><![CDATA[' + exceptionUserList + ']]></EXCEPTIONUSERLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 동기화 준비 요청
 ****************************************************************************/
getRequestUserSynchronizationPreparationParam = function(companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_USER_SYNCHRONIZATION_PREPARATION</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 동기화 실행 요청
 ****************************************************************************/
getRequestUserSynchronizationExecutionParam = function(companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_USER_SYNCHRONIZATION_EXECUTION</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 동기화에 필요한 추가된 부서 코드 조회 요청
 ****************************************************************************/
getRequestUserSynchronizationAddedDeptListParam = function(companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_USER_SYNCHRONIZATION_ADDED_DEPT_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 랜딩페이지 설정 정보 요청
 ****************************************************************************/
getRequestLandingSetupConfigInfoParam = function(companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_LANDING_SETUP_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 랜딩페이지 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveLandingSetupConfigParam = function(operatorId, 
		companyId, htConfigData) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_LANDING_SETUP_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<CONFIGDATA>';
	if (!htConfigData.isEmpty()) {
		htConfigData.each( function(name, value) {
			paramData += '<' + name.toUpperCase() + '>';
			paramData += value;
			paramData += '</' + name.toUpperCase() + '>';
		});
	}
	paramData += '</CONFIGDATA>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 기본 설정 정보 요청
 ****************************************************************************/
getRequestCompanyDefaultConfigInfoParam = function(companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_COMPANY_DEFAULT_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 기본 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveCompanyDefaultConfigParam = function(operatorId, 
		arrCompanyList, htDefaultConfigData, arrExclusionSearchFolderList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_COMPANY_DEFAULT_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYLIST>';
	if ($.isArray(arrCompanyList) ) {
		$.each(arrCompanyList, function(rowIdx, colVal) {
			paramData += '<COMPANY>';
			paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
			paramData += '</COMPANY>';
		});
	}
	paramData += '</COMPANYLIST>';
	paramData += '<CONFIGDATA>';
	if (!htDefaultConfigData.isEmpty()) {
		htDefaultConfigData.each( function(name, value) {
			paramData += '<' + name.toUpperCase() + '>';
			paramData += value;
			paramData += '</' + name.toUpperCase() + '>';
		});
	}
	paramData += '</CONFIGDATA>';
	paramData += '<EXCLUSIONSEARCHFOLDERLIST>';
	if ($.isArray(arrExclusionSearchFolderList) ) {
		$.each(arrExclusionSearchFolderList, function(rowIdx, colVal) {
			paramData += '<FOLDER>';
			paramData += '<PATH>' + colVal + '</PATH>';
			paramData += '</FOLDER>';
		});
	}
	paramData += '</EXCLUSIONSEARCHFOLDERLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서 기본 설정 정보 요청
 ****************************************************************************/
getRequestDeptDefaultConfigInfoParam = function(companyId, deptCode) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DEPT_DEFAULT_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서 기본 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveDeptDefaultConfigParam = function(operatorId, arrDeptList, 
		htDefaultConfigData, arrExclusionSearchFolderList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_DEPT_DEFAULT_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, arrDept) {
			paramData += '<DEPT>';
			$.each(arrDept, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
				}
			});
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<CONFIGDATA>';
	if (!htDefaultConfigData.isEmpty()) {
		htDefaultConfigData.each( function(name, value) {
			paramData += '<' + name.toUpperCase() + '>';
			paramData += value;
			paramData += '</' + name.toUpperCase() + '>';
		});
	}
	paramData += '</CONFIGDATA>';
	paramData += '<EXCLUSIONSEARCHFOLDERLIST>';
	if ($.isArray(arrExclusionSearchFolderList) ) {
		$.each(arrExclusionSearchFolderList, function(rowIdx, colVal) {
			paramData += '<FOLDER>';
			paramData += '<PATH>' + colVal + '</PATH>';
			paramData += '</FOLDER>';
		});
	}
	paramData += '</EXCLUSIONSEARCHFOLDERLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 기본 설정 정보 요청
 ****************************************************************************/
getRequestUserDefaultConfigInfoParam = function(companyId, userId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_USER_DEFAULT_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 기본 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveUserDefaultConfigParam = function(operatorId, arrUserList, 
		htDefaultConfigData, arrExclusionSearchFolderList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_USER_DEFAULT_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<USERLIST>';
	if ($.isArray(arrUserList) ) {
		$.each(arrUserList, function(rowIdx, arrUser) {
			paramData += '<USER>';
			$.each(arrUser, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<USERID>' + colVal + '</USERID>';
				}
			});
			paramData += '</USER>';
		});
	}
	paramData += '</USERLIST>';
	paramData += '<CONFIGDATA>';
	if (!htDefaultConfigData.isEmpty()) {
		htDefaultConfigData.each( function(name, value) {
			paramData += '<' + name.toUpperCase() + '>';
			paramData += value;
			paramData += '</' + name.toUpperCase() + '>';
		});
	}
	paramData += '</CONFIGDATA>';
	paramData += '<EXCLUSIONSEARCHFOLDERLIST>';
	if ($.isArray(arrExclusionSearchFolderList) ) {
		$.each(arrExclusionSearchFolderList, function(rowIdx, colVal) {
			paramData += '<FOLDER>';
			paramData += '<PATH>' + colVal + '</PATH>';
			paramData += '</FOLDER>';
		});
	}
	paramData += '</EXCLUSIONSEARCHFOLDERLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 패턴 설정 정보 요청
 ****************************************************************************/
getRequestCompanyPatternConfigInfoParam = function(companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_COMPANY_PATTERN_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 패턴 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveCompanyPatternConfigParam = function(operatorId, 
		arrCompanyList, arrPatternConfigData) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_COMPANY_PATTERN_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYLIST>';
	if ($.isArray(arrCompanyList) ) {
		$.each(arrCompanyList, function(rowIdx, colVal) {
			paramData += '<COMPANY>';
			paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
			paramData += '</COMPANY>';
		});
	}
	paramData += '</COMPANYLIST>';
	paramData += '<PATTERNLIST>';
	if ($.isArray(arrPatternConfigData) ) {
		$.each(arrPatternConfigData, function(rowIdx, arrPattern) {
			paramData += '<PATTERN>';
			$.each(arrPattern, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<PATTERNID>' + colVal + '</PATTERNID>';
				} else if (colIdx == 1) {
					paramData += '<PATTERNSUBID>' + colVal + '</PATTERNSUBID>';
				} else if (colIdx == 2) {
					paramData += '<DEFAULTSEARCHFLAG>' + colVal + '</DEFAULTSEARCHFLAG>';
				} else if (colIdx == 3) {
					paramData += '<JOBPROCESSINGACTIVECOUNT>' + colVal + '</JOBPROCESSINGACTIVECOUNT>';
				}
			});
			paramData += '</PATTERN>';
		});
	}
	paramData += '</PATTERNLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서 패턴 설정 정보 요청
 ****************************************************************************/
getRequestDeptPatternConfigInfoParam = function(companyId, deptCode) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DEPT_PATTERN_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서 패턴 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveDeptPatternConfigParam = function(operatorId, 
		arrDeptList, arrPatternConfigData) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_DEPT_PATTERN_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, arrDept) {
			paramData += '<DEPT>';
			$.each(arrDept, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
				}
			});
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<PATTERNLIST>';
	if ($.isArray(arrPatternConfigData) ) {
		$.each(arrPatternConfigData, function(rowIdx, arrPattern) {
			paramData += '<PATTERN>';
			$.each(arrPattern, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<PATTERNID>' + colVal + '</PATTERNID>';
				} else if (colIdx == 1) {
					paramData += '<PATTERNSUBID>' + colVal + '</PATTERNSUBID>';
				} else if (colIdx == 2) {
					paramData += '<DEFAULTSEARCHFLAG>' + colVal + '</DEFAULTSEARCHFLAG>';
				} else if (colIdx == 3) {
					paramData += '<JOBPROCESSINGACTIVECOUNT>' + colVal + '</JOBPROCESSINGACTIVECOUNT>';
				}
			});
			paramData += '</PATTERN>';
		});
	}
	paramData += '</PATTERNLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 패턴 설정 정보 요청
 ****************************************************************************/
getRequestUserPatternConfigInfoParam = function(companyId, userId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_USER_PATTERN_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 패턴 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveUserPatternConfigParam = function(operatorId, 
		arrUserList, arrPatternConfigData) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_USER_PATTERN_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<USERLIST>';
	if ($.isArray(arrUserList) ) {
		$.each(arrUserList, function(rowIdx, arrUser) {
			paramData += '<USER>';
			$.each(arrUser, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<USERID>' + colVal + '</USERID>';
				}
			});
			paramData += '</USER>';
		});
	}
	paramData += '</USERLIST>';
	paramData += '<PATTERNLIST>';
	if ($.isArray(arrPatternConfigData) ) {
		$.each(arrPatternConfigData, function(rowIdx, arrPattern) {
			paramData += '<PATTERN>';
			$.each(arrPattern, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<PATTERNID>' + colVal + '</PATTERNID>';
				} else if (colIdx == 1) {
					paramData += '<PATTERNSUBID>' + colVal + '</PATTERNSUBID>';
				} else if (colIdx == 2) {
					paramData += '<DEFAULTSEARCHFLAG>' + colVal + '</DEFAULTSEARCHFLAG>';
				} else if (colIdx == 3) {
					paramData += '<JOBPROCESSINGACTIVECOUNT>' + colVal + '</JOBPROCESSINGACTIVECOUNT>';
				}
			});
			paramData += '</PATTERN>';
		});
	}
	paramData += '</PATTERNLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 출력 제어 설정 정보 요청
 ****************************************************************************/
getRequestCompanyPrintControlConfigInfoParam = function(companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_COMPANY_PRINT_CONTROL_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 출력 제어 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveCompanyPrintControlConfigParam = function(operatorId, 
		arrCompanyList, htPrintControlConfigData) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_COMPANY_PRINT_CONTROL_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYLIST>';
	if ($.isArray(arrCompanyList) ) {
		$.each(arrCompanyList, function(rowIdx, colVal) {
			paramData += '<COMPANY>';
			paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
			paramData += '</COMPANY>';
		});
	}
	paramData += '</COMPANYLIST>';
	paramData += '<CONFIGDATA>';
	if (!htPrintControlConfigData.isEmpty()) {
		htPrintControlConfigData.each( function(name, value) {
			paramData += '<' + name.toUpperCase() + '>';
			paramData += value;
			paramData += '</' + name.toUpperCase() + '>';
		});
	}
	paramData += '</CONFIGDATA>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서 출력 제어 설정 정보 요청
 ****************************************************************************/
getRequestDeptPrintControlConfigInfoParam = function(companyId, deptCode) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DEPT_PRINT_CONTROL_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서 출력 제어 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveDeptPrintControlConfigParam = function(operatorId, arrDeptList, 
		htPrintControlConfigData) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_DEPT_PRINT_CONTROL_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, arrDept) {
			paramData += '<DEPT>';
			$.each(arrDept, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
				}
			});
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<CONFIGDATA>';
	if (!htPrintControlConfigData.isEmpty()) {
		htPrintControlConfigData.each( function(name, value) {
			paramData += '<' + name.toUpperCase() + '>';
			paramData += value;
			paramData += '</' + name.toUpperCase() + '>';
		});
	}
	paramData += '</CONFIGDATA>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 출력 제어 설정 정보 요청
 ****************************************************************************/
getRequestUserPrintControlConfigInfoParam = function(companyId, userId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_USER_PRINT_CONTROL_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 출력 제어 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveUserPrintControlConfigParam = function(operatorId, arrUserList, 
		htPrintControlConfigData) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_USER_PRINT_CONTROL_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<USERLIST>';
	if ($.isArray(arrUserList) ) {
		$.each(arrUserList, function(rowIdx, arrUser) {
			paramData += '<USER>';
			$.each(arrUser, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<USERID>' + colVal + '</USERID>';
				}
			});
			paramData += '</USER>';
		});
	}
	paramData += '</USERLIST>';
	paramData += '<CONFIGDATA>';
	if (!htPrintControlConfigData.isEmpty()) {
		htPrintControlConfigData.each( function(name, value) {
			paramData += '<' + name.toUpperCase() + '>';
			paramData += value;
			paramData += '</' + name.toUpperCase() + '>';
		});
	}
	paramData += '</CONFIGDATA>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 워터마크 설정 정보 요청
 ****************************************************************************/
getRequestCompanyWaterMarkConfigInfoParam = function(companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_COMPANY_WATERMARK_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 워터마크 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveCompanyWaterMarkConfigParam = function(operatorId, 
		arrCompanyList, htWaterMarkConfigData) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_COMPANY_WATERMARK_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYLIST>';
	if ($.isArray(arrCompanyList) ) {
		$.each(arrCompanyList, function(rowIdx, colVal) {
			paramData += '<COMPANY>';
			paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
			paramData += '</COMPANY>';
		});
	}
	paramData += '</COMPANYLIST>';
	paramData += '<CONFIGDATA>';
	if (!htWaterMarkConfigData.isEmpty()) {
		htWaterMarkConfigData.each( function(name, value) {
			paramData += '<' + name.toUpperCase() + '>';
			paramData += value;
			paramData += '</' + name.toUpperCase() + '>';
		});
	}
	paramData += '</CONFIGDATA>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서 워터마크 설정 정보 요청
 ****************************************************************************/
getRequestDeptWaterMarkConfigInfoParam = function(companyId, deptCode) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DEPT_WATERMARK_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서 워터마크 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveDeptWaterMarkConfigParam = function(operatorId, 
		arrDeptList, htWaterMarkConfigData) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_DEPT_WATERMARK_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, arrDept) {
			paramData += '<DEPT>';
			$.each(arrDept, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
				}
			});
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<CONFIGDATA>';
	if (!htWaterMarkConfigData.isEmpty()) {
		htWaterMarkConfigData.each( function(name, value) {
			paramData += '<' + name.toUpperCase() + '>';
			paramData += value;
			paramData += '</' + name.toUpperCase() + '>';
		});
	}
	paramData += '</CONFIGDATA>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 워터마크 설정 정보 요청
 ****************************************************************************/
getRequestUserWaterMarkConfigInfoParam = function(companyId, userId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_USER_WATERMARK_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 워터마크 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveUserWaterMarkConfigParam = function(operatorId, 
		arrUserList, htWaterMarkConfigData) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_USER_WATERMARK_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<USERLIST>';
	if ($.isArray(arrUserList) ) {
		$.each(arrUserList, function(rowIdx, arrUser) {
			paramData += '<USER>';
			$.each(arrUser, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<USERID>' + colVal + '</USERID>';
				}
			});
			paramData += '</USER>';
		});
	}
	paramData += '</USERLIST>';
	paramData += '<CONFIGDATA>';
	if (!htWaterMarkConfigData.isEmpty()) {
		htWaterMarkConfigData.each( function(name, value) {
			paramData += '<' + name.toUpperCase() + '>';
			paramData += value;
			paramData += '</' + name.toUpperCase() + '>';
		});
	}
	paramData += '</CONFIGDATA>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 워터마크 배경 이미지 리스트 요청
 ****************************************************************************/
getRequestWaterMarkBackgroundImageListParam = function(companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_WATERMARK_BACKGROUND_IMAGE_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 워터마크 배경 이미지 삭제 요청
 ****************************************************************************/
getRequestDeleteWaterMarkBackgroundImagesParam = function(operatorId, 
		companyId, arrTargetFileList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DELETE_WATERMARK_BACKGROUND_IMAGE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<FILELIST>';
	if ($.isArray(arrTargetFileList) ) {
		$.each(arrTargetFileList, function(rowIdx, colVal) {
			paramData += '<FILE>';
			paramData += '<FILENAME>' + colVal + '</FILENAME>';
			paramData += '</FILE>';
		});
	}
	paramData += '</FILELIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 매체 제어 설정 정보 요청
 ****************************************************************************/
getRequestCompanyMediaControlConfigInfoParam = function(companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_COMPANY_MEDIA_CONTROL_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 매체 제어 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveCompanyMediaControlConfigParam = function(operatorId, 
		arrCompanyList, htMediaControlConfigData) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_COMPANY_MEDIA_CONTROL_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYLIST>';
	if ($.isArray(arrCompanyList) ) {
		$.each(arrCompanyList, function(rowIdx, colVal) {
			paramData += '<COMPANY>';
			paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
			paramData += '</COMPANY>';
		});
	}
	paramData += '</COMPANYLIST>';
	paramData += '<CONFIGDATA>';
	if (!htMediaControlConfigData.isEmpty()) {
		htMediaControlConfigData.each( function(name, value) {
			paramData += '<' + name.toUpperCase() + '>';
			paramData += value;
			paramData += '</' + name.toUpperCase() + '>';
		});
	}
	paramData += '</CONFIGDATA>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서 매체 제어 설정 정보 요청
 ****************************************************************************/
getRequestDeptMediaControlConfigInfoParam = function(companyId, deptCode) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DEPT_MEDIA_CONTROL_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서 매체 제어 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveDeptMediaControlConfigParam = function(operatorId, arrDeptList, 
		htMediaControlConfigData) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_DEPT_MEDIA_CONTROL_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, arrDept) {
			paramData += '<DEPT>';
			$.each(arrDept, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
				}
			});
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<CONFIGDATA>';
	if (!htMediaControlConfigData.isEmpty()) {
		htMediaControlConfigData.each( function(name, value) {
			paramData += '<' + name.toUpperCase() + '>';
			paramData += value;
			paramData += '</' + name.toUpperCase() + '>';
		});
	}
	paramData += '</CONFIGDATA>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 매체 제어 설정 정보 요청
 ****************************************************************************/
getRequestUserMediaControlConfigInfoParam = function(companyId, userId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_USER_MEDIA_CONTROL_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 매체 제어 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveUserMediaControlConfigParam = function(operatorId, arrUserList, 
		htMediaControlConfigData) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_USER_MEDIA_CONTROL_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<USERLIST>';
	if ($.isArray(arrUserList) ) {
		$.each(arrUserList, function(rowIdx, arrUser) {
			paramData += '<USER>';
			$.each(arrUser, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<USERID>' + colVal + '</USERID>';
				}
			});
			paramData += '</USER>';
		});
	}
	paramData += '</USERLIST>';
	paramData += '<CONFIGDATA>';
	if (!htMediaControlConfigData.isEmpty()) {
		htMediaControlConfigData.each( function(name, value) {
			paramData += '<' + name.toUpperCase() + '>';
			paramData += value;
			paramData += '</' + name.toUpperCase() + '>';
		});
	}
	paramData += '</CONFIGDATA>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 네트워크 서비스 제어 설정 정보 요청
 ****************************************************************************/
getRequestCompanyNetworkServiceControlConfigInfoParam = function(companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_COMPANY_NETWORK_SERVICE_CONTROL_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 네트워크 서비스 제어 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveCompanyNetworkServiceControlConfigParam = function(operatorId, 
		arrCompanyList, htNetworkServiceControlConfigData,
		arrEmailControlProgramList, arrFtpControlProgramList,
		arrP2pControlProgramList, arrMessengerControlProgramList,
		arrCaptureControlProgramList, arrEtcControlProgramList,
		arrBlockSpecificUrlsList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_COMPANY_NETWORK_SERVICE_CONTROL_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYLIST>';
	if ($.isArray(arrCompanyList) ) {
		$.each(arrCompanyList, function(rowIdx, colVal) {
			paramData += '<COMPANY>';
			paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
			paramData += '</COMPANY>';
		});
	}
	paramData += '</COMPANYLIST>';
	paramData += '<CONFIGDATA>';
	if (!htNetworkServiceControlConfigData.isEmpty()) {
		htNetworkServiceControlConfigData.each( function(name, value) {
			paramData += '<' + name.toUpperCase() + '>';
			paramData += value;
			paramData += '</' + name.toUpperCase() + '>';
		});
	}
	paramData += '</CONFIGDATA>';
	paramData += '<CONTROLPROGRAMLIST>';
	paramData += '<EMAILPROGRAMLIST>';
	if ($.isArray(arrEmailControlProgramList) ) {
		$.each(arrEmailControlProgramList, function(rowIdx, arrProgram) {
			paramData += '<PROGRAM>';
			$.each(arrProgram, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<PROGRAMNAME>' + colVal + '</PROGRAMNAME>';
				} else if (colIdx == 1) {
					paramData += '<FILENAME>' + colVal + '</FILENAME>';
				} else if (colIdx == 2) {
					paramData += '<CONTROLTYPE>' + colVal + '</CONTROLTYPE>';
				}
			});
			paramData += '</PROGRAM>';
		});
	}
	paramData += '</EMAILPROGRAMLIST>';
	paramData += '<FTPPROGRAMLIST>';
	if ($.isArray(arrFtpControlProgramList) ) {
		$.each(arrFtpControlProgramList, function(rowIdx, arrProgram) {
			paramData += '<PROGRAM>';
			$.each(arrProgram, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<PROGRAMNAME>' + colVal + '</PROGRAMNAME>';
				} else if (colIdx == 1) {
					paramData += '<FILENAME>' + colVal + '</FILENAME>';
				} else if (colIdx == 2) {
					paramData += '<CONTROLTYPE>' + colVal + '</CONTROLTYPE>';
				}
			});
			paramData += '</PROGRAM>';
		});
	}
	paramData += '</FTPPROGRAMLIST>';
	paramData += '<P2PPROGRAMLIST>';
	if ($.isArray(arrP2pControlProgramList) ) {
		$.each(arrP2pControlProgramList, function(rowIdx, arrProgram) {
			paramData += '<PROGRAM>';
			$.each(arrProgram, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<PROGRAMNAME>' + colVal + '</PROGRAMNAME>';
				} else if (colIdx == 1) {
					paramData += '<FILENAME>' + colVal + '</FILENAME>';
				} else if (colIdx == 2) {
					paramData += '<CONTROLTYPE>' + colVal + '</CONTROLTYPE>';
				}
			});
			paramData += '</PROGRAM>';
		});
	}
	paramData += '</P2PPROGRAMLIST>';
	paramData += '<MESSENGERPROGRAMLIST>';
	if ($.isArray(arrMessengerControlProgramList) ) {
		$.each(arrMessengerControlProgramList, function(rowIdx, arrProgram) {
			paramData += '<PROGRAM>';
			$.each(arrProgram, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<PROGRAMNAME>' + colVal + '</PROGRAMNAME>';
				} else if (colIdx == 1) {
					paramData += '<FILENAME>' + colVal + '</FILENAME>';
				} else if (colIdx == 2) {
					paramData += '<CONTROLTYPE>' + colVal + '</CONTROLTYPE>';
				}
			});
			paramData += '</PROGRAM>';
		});
	}
	paramData += '</MESSENGERPROGRAMLIST>';
	paramData += '<CAPTUREPROGRAMLIST>';
	if ($.isArray(arrCaptureControlProgramList) ) {
		$.each(arrCaptureControlProgramList, function(rowIdx, arrProgram) {
			paramData += '<PROGRAM>';
			$.each(arrProgram, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<PROGRAMNAME>' + colVal + '</PROGRAMNAME>';
				} else if (colIdx == 1) {
					paramData += '<FILENAME>' + colVal + '</FILENAME>';
				} else if (colIdx == 2) {
					paramData += '<CONTROLTYPE>' + colVal + '</CONTROLTYPE>';
				}
			});
			paramData += '</PROGRAM>';
		});
	}
	paramData += '</CAPTUREPROGRAMLIST>';
	paramData += '<ETCPROGRAMLIST>';
	if ($.isArray(arrEtcControlProgramList) ) {
		$.each(arrEtcControlProgramList, function(rowIdx, arrProgram) {
			paramData += '<PROGRAM>';
			$.each(arrProgram, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<PROGRAMNAME>' + colVal + '</PROGRAMNAME>';
				} else if (colIdx == 1) {
					paramData += '<FILENAME>' + colVal + '</FILENAME>';
				} else if (colIdx == 2) {
					paramData += '<CONTROLTYPE>' + colVal + '</CONTROLTYPE>';
				}
			});
			paramData += '</PROGRAM>';
		});
	}
	paramData += '</ETCPROGRAMLIST>';
	paramData += '</CONTROLPROGRAMLIST>';
	paramData += '<BLOCKSPECIFICURLSLIST>';
	if ($.isArray(arrBlockSpecificUrlsList) ) {
		$.each(arrBlockSpecificUrlsList, function(rowIdx, colVal) {
			paramData += '<BLOCKSPECIFICURLS>';
			paramData += '<BLOCKURL>' + colVal + '</BLOCKURL>';
			paramData += '</BLOCKSPECIFICURLS>';
		});
	}
	paramData += '</BLOCKSPECIFICURLSLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서 네트워크 서비스 제어 설정 정보 요청
 ****************************************************************************/
getRequestDeptNetworkServiceControlConfigInfoParam = function(companyId, deptCode) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DEPT_NETWORK_SERVICE_CONTROL_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서 네트워크 서비스 제어 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveDeptNetworkServiceControlConfigParam = function(operatorId,
		arrDeptList, htNetworkServiceControlConfigData,
		arrEmailControlProgramList, arrFtpControlProgramList,
		arrP2pControlProgramList, arrMessengerControlProgramList,
		arrCaptureControlProgramList, arrEtcControlProgramList,
		arrBlockSpecificUrlsList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_DEPT_NETWORK_SERVICE_CONTROL_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, arrDept) {
			paramData += '<DEPT>';
			$.each(arrDept, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
				} else if (colIdx == 2) {
					paramData += '<CONTROLTYPE>' + colVal + '</CONTROLTYPE>';
				}
			});
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<CONFIGDATA>';
	if (!htNetworkServiceControlConfigData.isEmpty()) {
		htNetworkServiceControlConfigData.each( function(name, value) {
			paramData += '<' + name.toUpperCase() + '>';
			paramData += value;
			paramData += '</' + name.toUpperCase() + '>';
		});
	}
	paramData += '</CONFIGDATA>';
	paramData += '<CONTROLPROGRAMLIST>';
	paramData += '<EMAILPROGRAMLIST>';
	if ($.isArray(arrEmailControlProgramList) ) {
		$.each(arrEmailControlProgramList, function(rowIdx, arrProgram) {
			paramData += '<PROGRAM>';
			$.each(arrProgram, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<PROGRAMNAME>' + colVal + '</PROGRAMNAME>';
				} else if (colIdx == 1) {
					paramData += '<FILENAME>' + colVal + '</FILENAME>';
				} else if (colIdx == 2) {
					paramData += '<CONTROLTYPE>' + colVal + '</CONTROLTYPE>';
				}
			});
			paramData += '</PROGRAM>';
		});
	}
	paramData += '</EMAILPROGRAMLIST>';
	paramData += '<FTPPROGRAMLIST>';
	if ($.isArray(arrFtpControlProgramList) ) {
		$.each(arrFtpControlProgramList, function(rowIdx, arrProgram) {
			paramData += '<PROGRAM>';
			$.each(arrProgram, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<PROGRAMNAME>' + colVal + '</PROGRAMNAME>';
				} else if (colIdx == 1) {
					paramData += '<FILENAME>' + colVal + '</FILENAME>';
				} else if (colIdx == 2) {
					paramData += '<CONTROLTYPE>' + colVal + '</CONTROLTYPE>';
				}
			});
			paramData += '</PROGRAM>';
		});
	}
	paramData += '</FTPPROGRAMLIST>';
	paramData += '<P2PPROGRAMLIST>';
	if ($.isArray(arrP2pControlProgramList) ) {
		$.each(arrP2pControlProgramList, function(rowIdx, arrProgram) {
			paramData += '<PROGRAM>';
			$.each(arrProgram, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<PROGRAMNAME>' + colVal + '</PROGRAMNAME>';
				} else if (colIdx == 1) {
					paramData += '<FILENAME>' + colVal + '</FILENAME>';
				} else if (colIdx == 2) {
					paramData += '<CONTROLTYPE>' + colVal + '</CONTROLTYPE>';
				}
			});
			paramData += '</PROGRAM>';
		});
	}
	paramData += '</P2PPROGRAMLIST>';
	paramData += '<MESSENGERPROGRAMLIST>';
	if ($.isArray(arrMessengerControlProgramList) ) {
		$.each(arrMessengerControlProgramList, function(rowIdx, arrProgram) {
			paramData += '<PROGRAM>';
			$.each(arrProgram, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<PROGRAMNAME>' + colVal + '</PROGRAMNAME>';
				} else if (colIdx == 1) {
					paramData += '<FILENAME>' + colVal + '</FILENAME>';
				} else if (colIdx == 2) {
					paramData += '<CONTROLTYPE>' + colVal + '</CONTROLTYPE>';
				}
			});
			paramData += '</PROGRAM>';
		});
	}
	paramData += '</MESSENGERPROGRAMLIST>';
	paramData += '<CAPTUREPROGRAMLIST>';
	if ($.isArray(arrCaptureControlProgramList) ) {
		$.each(arrCaptureControlProgramList, function(rowIdx, arrProgram) {
			paramData += '<PROGRAM>';
			$.each(arrProgram, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<PROGRAMNAME>' + colVal + '</PROGRAMNAME>';
				} else if (colIdx == 1) {
					paramData += '<FILENAME>' + colVal + '</FILENAME>';
				} else if (colIdx == 2) {
					paramData += '<CONTROLTYPE>' + colVal + '</CONTROLTYPE>';
				}
			});
			paramData += '</PROGRAM>';
		});
	}
	paramData += '</CAPTUREPROGRAMLIST>';
	paramData += '<ETCPROGRAMLIST>';
	if ($.isArray(arrEtcControlProgramList) ) {
		$.each(arrEtcControlProgramList, function(rowIdx, arrProgram) {
			paramData += '<PROGRAM>';
			$.each(arrProgram, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<PROGRAMNAME>' + colVal + '</PROGRAMNAME>';
				} else if (colIdx == 1) {
					paramData += '<FILENAME>' + colVal + '</FILENAME>';
				} else if (colIdx == 2) {
					paramData += '<CONTROLTYPE>' + colVal + '</CONTROLTYPE>';
				}
			});
			paramData += '</PROGRAM>';
		});
	}
	paramData += '</ETCPROGRAMLIST>';
	paramData += '</CONTROLPROGRAMLIST>';
	paramData += '<BLOCKSPECIFICURLSLIST>';
	if ($.isArray(arrBlockSpecificUrlsList) ) {
		$.each(arrBlockSpecificUrlsList, function(rowIdx, colVal) {
			paramData += '<BLOCKSPECIFICURLS>';
			paramData += '<BLOCKURL>' + colVal + '</BLOCKURL>';
			paramData += '</BLOCKSPECIFICURLS>';
		});
	}
	paramData += '</BLOCKSPECIFICURLSLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 네트워크 서비스 제어 설정 정보 요청
 ****************************************************************************/
getRequestUserNetworkServiceControlConfigInfoParam = function(companyId, userId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_USER_NETWORK_SERVICE_CONTROL_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 네트워크 서비스 제어 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveUserNetworkServiceControlConfigParam = function(operatorId,
		arrUserList, htNetworkServiceControlConfigData,
		arrEmailControlProgramList, arrFtpControlProgramList,
		arrP2pControlProgramList, arrMessengerControlProgramList,
		arrCaptureControlProgramList, arrEtcControlProgramList,
		arrBlockSpecificUrlsList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_USER_NETWORK_SERVICE_CONTROL_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<USERLIST>';
	if ($.isArray(arrUserList) ) {
		$.each(arrUserList, function(rowIdx, arrUser) {
			paramData += '<USER>';
			$.each(arrUser, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<USERID>' + colVal + '</USERID>';
				}
			});
			paramData += '</USER>';
		});
	}
	paramData += '</USERLIST>';
	paramData += '<CONFIGDATA>';
	if (!htNetworkServiceControlConfigData.isEmpty()) {
		htNetworkServiceControlConfigData.each( function(name, value) {
			paramData += '<' + name.toUpperCase() + '>';
			paramData += value;
			paramData += '</' + name.toUpperCase() + '>';
		});
	}
	paramData += '</CONFIGDATA>';
	paramData += '<CONTROLPROGRAMLIST>';
	paramData += '<EMAILPROGRAMLIST>';
	if ($.isArray(arrEmailControlProgramList) ) {
		$.each(arrEmailControlProgramList, function(rowIdx, arrProgram) {
			paramData += '<PROGRAM>';
			$.each(arrProgram, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<PROGRAMNAME>' + colVal + '</PROGRAMNAME>';
				} else if (colIdx == 1) {
					paramData += '<FILENAME>' + colVal + '</FILENAME>';
				} else if (colIdx == 2) {
					paramData += '<CONTROLTYPE>' + colVal + '</CONTROLTYPE>';
				}
			});
			paramData += '</PROGRAM>';
		});
	}
	paramData += '</EMAILPROGRAMLIST>';
	paramData += '<FTPPROGRAMLIST>';
	if ($.isArray(arrFtpControlProgramList) ) {
		$.each(arrFtpControlProgramList, function(rowIdx, arrProgram) {
			paramData += '<PROGRAM>';
			$.each(arrProgram, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<PROGRAMNAME>' + colVal + '</PROGRAMNAME>';
				} else if (colIdx == 1) {
					paramData += '<FILENAME>' + colVal + '</FILENAME>';
				} else if (colIdx == 2) {
					paramData += '<CONTROLTYPE>' + colVal + '</CONTROLTYPE>';
				}
			});
			paramData += '</PROGRAM>';
		});
	}
	paramData += '</FTPPROGRAMLIST>';
	paramData += '<P2PPROGRAMLIST>';
	if ($.isArray(arrP2pControlProgramList) ) {
		$.each(arrP2pControlProgramList, function(rowIdx, arrProgram) {
			paramData += '<PROGRAM>';
			$.each(arrProgram, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<PROGRAMNAME>' + colVal + '</PROGRAMNAME>';
				} else if (colIdx == 1) {
					paramData += '<FILENAME>' + colVal + '</FILENAME>';
				} else if (colIdx == 2) {
					paramData += '<CONTROLTYPE>' + colVal + '</CONTROLTYPE>';
				}
			});
			paramData += '</PROGRAM>';
		});
	}
	paramData += '</P2PPROGRAMLIST>';
	paramData += '<MESSENGERPROGRAMLIST>';
	if ($.isArray(arrMessengerControlProgramList) ) {
		$.each(arrMessengerControlProgramList, function(rowIdx, arrProgram) {
			paramData += '<PROGRAM>';
			$.each(arrProgram, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<PROGRAMNAME>' + colVal + '</PROGRAMNAME>';
				} else if (colIdx == 1) {
					paramData += '<FILENAME>' + colVal + '</FILENAME>';
				} else if (colIdx == 2) {
					paramData += '<CONTROLTYPE>' + colVal + '</CONTROLTYPE>';
				}
			});
			paramData += '</PROGRAM>';
		});
	}
	paramData += '</MESSENGERPROGRAMLIST>';
	paramData += '<CAPTUREPROGRAMLIST>';
	if ($.isArray(arrCaptureControlProgramList) ) {
		$.each(arrCaptureControlProgramList, function(rowIdx, arrProgram) {
			paramData += '<PROGRAM>';
			$.each(arrProgram, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<PROGRAMNAME>' + colVal + '</PROGRAMNAME>';
				} else if (colIdx == 1) {
					paramData += '<FILENAME>' + colVal + '</FILENAME>';
				} else if (colIdx == 2) {
					paramData += '<CONTROLTYPE>' + colVal + '</CONTROLTYPE>';
				}
			});
			paramData += '</PROGRAM>';
		});
	}
	paramData += '</CAPTUREPROGRAMLIST>';
	paramData += '<ETCPROGRAMLIST>';
	if ($.isArray(arrEtcControlProgramList) ) {
		$.each(arrEtcControlProgramList, function(rowIdx, arrProgram) {
			paramData += '<PROGRAM>';
			$.each(arrProgram, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<PROGRAMNAME>' + colVal + '</PROGRAMNAME>';
				} else if (colIdx == 1) {
					paramData += '<FILENAME>' + colVal + '</FILENAME>';
				} else if (colIdx == 2) {
					paramData += '<CONTROLTYPE>' + colVal + '</CONTROLTYPE>';
				}
			});
			paramData += '</PROGRAM>';
		});
	}
	paramData += '</ETCPROGRAMLIST>';
	paramData += '</CONTROLPROGRAMLIST>';
	paramData += '<BLOCKSPECIFICURLSLIST>';
	if ($.isArray(arrBlockSpecificUrlsList) ) {
		$.each(arrBlockSpecificUrlsList, function(rowIdx, colVal) {
			paramData += '<BLOCKSPECIFICURLS>';
			paramData += '<BLOCKURL>' + colVal + '</BLOCKURL>';
			paramData += '</BLOCKSPECIFICURLS>';
		});
	}
	paramData += '</BLOCKSPECIFICURLSLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 시스템 제어 설정 정보 요청
 ****************************************************************************/
getRequestCompanySystemControlConfigInfoParam = function(companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_COMPANY_SYSTEM_CONTROL_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 시스템 제어 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveCompanySystemControlConfigParam = function(operatorId, 
		arrCompanyList, htSystemControlConfigData) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_COMPANY_SYSTEM_CONTROL_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYLIST>';
	if ($.isArray(arrCompanyList) ) {
		$.each(arrCompanyList, function(rowIdx, colVal) {
			paramData += '<COMPANY>';
			paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
			paramData += '</COMPANY>';
		});
	}
	paramData += '</COMPANYLIST>';
	paramData += '<CONFIGDATA>';
	if (!htSystemControlConfigData.isEmpty()) {
		htSystemControlConfigData.each( function(name, value) {
			paramData += '<' + name.toUpperCase() + '>';
			paramData += value;
			paramData += '</' + name.toUpperCase() + '>';
		});
	}
	paramData += '</CONFIGDATA>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서 시스템 제어 설정 정보 요청
 ****************************************************************************/
getRequestDeptSystemControlConfigInfoParam = function(companyId, deptCode) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DEPT_SYSTEM_CONTROL_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서 시스템 제어 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveDeptSystemControlConfigParam = function(operatorId, arrDeptList, 
		htSystemControlConfigData) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_DEPT_SYSTEM_CONTROL_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, arrDept) {
			paramData += '<DEPT>';
			$.each(arrDept, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
				}
			});
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<CONFIGDATA>';
	if (!htSystemControlConfigData.isEmpty()) {
		htSystemControlConfigData.each( function(name, value) {
			paramData += '<' + name.toUpperCase() + '>';
			paramData += value;
			paramData += '</' + name.toUpperCase() + '>';
		});
	}
	paramData += '</CONFIGDATA>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 시스템 제어 설정 정보 요청
 ****************************************************************************/
getRequestUserSystemControlConfigInfoParam = function(companyId, userId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_USER_SYSTEM_CONTROL_CONFIG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 시스템 제어 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveUserSystemControlConfigParam = function(operatorId, arrUserList, 
		htSystemControlConfigData) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_USER_SYSTEM_CONTROL_CONFIG</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<USERLIST>';
	if ($.isArray(arrUserList) ) {
		$.each(arrUserList, function(rowIdx, arrUser) {
			paramData += '<USER>';
			$.each(arrUser, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<USERID>' + colVal + '</USERID>';
				}
			});
			paramData += '</USER>';
		});
	}
	paramData += '</USERLIST>';
	paramData += '<CONFIGDATA>';
	if (!htSystemControlConfigData.isEmpty()) {
		htSystemControlConfigData.each( function(name, value) {
			paramData += '<' + name.toUpperCase() + '>';
			paramData += value;
			paramData += '</' + name.toUpperCase() + '>';
		});
	}
	paramData += '</CONFIGDATA>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 에이전트 설정 현황 목록 요청
 ****************************************************************************/
getRequestAgentConfigStatusListParam = function(companyId,
		arrDeptList, userId, jobProcessingType, forcedTerminationFlag,
		decordingPermissionFlag, contentCopyPreventionFlag,
		realtimeObservationFlag, passwordExpirationFlag, wmPrintMode,
		usbControlFlag, cdromControlFlag, networkServiceControlFlag,
		systemPasswordSetupFlag, systemPasswordExpirationFlag,
		screenSaverActivationFlag,
		orderByName, orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_AGENT_CONFIG_STATUS_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<JOBPROCESSINGTYPE>' + jobProcessingType + '</JOBPROCESSINGTYPE>';
	paramData += '<FORCEDTERMINATIONFLAG>' + forcedTerminationFlag + '</FORCEDTERMINATIONFLAG>';
	paramData += '<DECORDINGPERMISSIONFLAG>' + decordingPermissionFlag + '</DECORDINGPERMISSIONFLAG>';
	paramData += '<CONTENTCOPYPREVENTIONFLAG>' + contentCopyPreventionFlag + '</CONTENTCOPYPREVENTIONFLAG>';
	paramData += '<REALTIMEOBSERVATIONFLAG>' + realtimeObservationFlag + '</REALTIMEOBSERVATIONFLAG>';
	paramData += '<PASSWORDEXPIRATIONFLAG>' + passwordExpirationFlag + '</PASSWORDEXPIRATIONFLAG>';
	paramData += '<WMPRINTMODE>' + wmPrintMode + '</WMPRINTMODE>';
	paramData += '<USBCONTROLFLAG>' + usbControlFlag + '</USBCONTROLFLAG>';
	paramData += '<CDROMCONTROLFLAG>' + cdromControlFlag + '</CDROMCONTROLFLAG>';
	paramData += '<NETWORKSERVICECONTROLFLAG>' + networkServiceControlFlag + '</NETWORKSERVICECONTROLFLAG>';
	paramData += '<SYSTEMPASSWORDSETUPFLAG>' + systemPasswordSetupFlag + '</SYSTEMPASSWORDSETUPFLAG>';
	paramData += '<SYSTEMPASSWORDEXPIRATIONFLAG>' + systemPasswordExpirationFlag + '</SYSTEMPASSWORDEXPIRATIONFLAG>';
	paramData += '<SCREENSAVERACTIVATIONFLAG>' + screenSaverActivationFlag + '</SCREENSAVERACTIVATIONFLAG>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 에이전트 설정 현황 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateAgentConfigStatusListFileParam = function(companyId,
		arrDeptList, userId, jobProcessingType, forcedTerminationFlag,
		decordingPermissionFlag, contentCopyPreventionFlag,
		realtimeObservationFlag, passwordExpirationFlag, wmPrintMode,
		usbControlFlag, cdromControlFlag, networkServiceControlFlag,
		systemPasswordSetupFlag, systemPasswordExpirationFlag,
		screenSaverActivationFlag, orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_AGENT_CONFIG_STATUS_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<JOBPROCESSINGTYPE>' + jobProcessingType + '</JOBPROCESSINGTYPE>';
	paramData += '<FORCEDTERMINATIONFLAG>' + forcedTerminationFlag + '</FORCEDTERMINATIONFLAG>';
	paramData += '<DECORDINGPERMISSIONFLAG>' + decordingPermissionFlag + '</DECORDINGPERMISSIONFLAG>';
	paramData += '<CONTENTCOPYPREVENTIONFLAG>' + contentCopyPreventionFlag + '</CONTENTCOPYPREVENTIONFLAG>';
	paramData += '<REALTIMEOBSERVATIONFLAG>' + realtimeObservationFlag + '</REALTIMEOBSERVATIONFLAG>';
	paramData += '<PASSWORDEXPIRATIONFLAG>' + passwordExpirationFlag + '</PASSWORDEXPIRATIONFLAG>';
	paramData += '<WMPRINTMODE>' + wmPrintMode + '</WMPRINTMODE>';
	paramData += '<USBCONTROLFLAG>' + usbControlFlag + '</USBCONTROLFLAG>';
	paramData += '<CDROMCONTROLFLAG>' + cdromControlFlag + '</CDROMCONTROLFLAG>';
	paramData += '<NETWORKSERVICECONTROLFLAG>' + networkServiceControlFlag + '</NETWORKSERVICECONTROLFLAG>';
	paramData += '<SYSTEMPASSWORDSETUPFLAG>' + systemPasswordSetupFlag + '</SYSTEMPASSWORDSETUPFLAG>';
	paramData += '<SYSTEMPASSWORDEXPIRATIONFLAG>' + systemPasswordExpirationFlag + '</SYSTEMPASSWORDEXPIRATIONFLAG>';
	paramData += '<SCREENSAVERACTIVATIONFLAG>' + screenSaverActivationFlag + '</SCREENSAVERACTIVATIONFLAG>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 에이전트 설정 현황 정보 요청
 ****************************************************************************/
getRequestAgentConfigStatusInfoParam = function(companyId, userId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_AGENT_CONFIG_STATUS_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 문서보안 권한 정책 트리 노드 요청
 ****************************************************************************/
getRequestDrmPermissionPolicyTreeNodesParam = function(companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DRM_PERMISSION_POLICY_TREE_NODES</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 문서보안 권한 정책 설정 정보 요청
 ****************************************************************************/
getRequestDrmPermissionPolicyInfoParam = function(companyId, policyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DRM_PERMISSION_POLICY_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<POLICYID>' + policyId + '</POLICYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 문서보안 권한 정책 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveDrmPermissionPolicyParam = function(operatorId,
		companyId, policyId, policyName, readPermission, writePermission,
		printPermission, expirationDate, readLimitCount, arrUserList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_DRM_PERMISSION_POLICY</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<POLICYID>' + policyId + '</POLICYID>';
	paramData += '<POLICYNAME>' + policyName + '</POLICYNAME>';
	paramData += '<READPERMISSION>' + readPermission + '</READPERMISSION>';
	paramData += '<WRITEPERMISSION>' + writePermission + '</WRITEPERMISSION>';
	paramData += '<PRINTPERMISSION>' + printPermission + '</PRINTPERMISSION>';
	paramData += '<EXPIRATIONDATE>' + expirationDate + '</EXPIRATIONDATE>';
	paramData += '<READLIMITCOUNT>' + readLimitCount + '</READLIMITCOUNT>';
	paramData += '<USERLIST>';
	if ($.isArray(arrUserList) ) {
		$.each(arrUserList, function(rowIdx, colVal) {
			paramData += '<USER>';
			var htUserInfo = colVal;
			paramData += '<DEPTCODE>' + htUserInfo.get("deptcode") + '</DEPTCODE>';
			paramData += '<USERID>' + htUserInfo.get("userid") + '</USERID>';
			paramData += '</USER>';
		});
	}
	paramData += '</USERLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 문서보안 권한 정책 설정 정보 삭제 요청
 ****************************************************************************/
getRequestDeleteDrmPermissionPolicyParam = function(operatorId,
		companyId, policyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DELETE_DRM_PERMISSION_POLICY</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<POLICYID>' + policyId + '</POLICYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자별 소속 문서보안 권한 정책 현황 목록 요청
 ****************************************************************************/
getRequestUserBelongsDrmPermissionPolicyStatusListParam = function(
		companyId, userId, policyName,
		orderByName, orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_USER_BELONGS_DRM_PERMISSION_POLICY_STATUS_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<POLICYNAME>' + policyName + '</POLICYNAME>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 공지 목록 요청
 ****************************************************************************/
getRequestUserNoticeListParam = function(companyId, title, searchDateFrom, searchDateTo,
		orderByName, orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_USER_NOTICE_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<TITLE>' + title + '</TITLE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 공지 정보 요청
 ****************************************************************************/
getRequestUserNoticeInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_USER_NOTICE_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 공지 대상 사용자 목록 요청
 ****************************************************************************/
getRequestUserNoticeMemberListParam = function(noticeId, companyId, arrDeptList,
		orderByName, orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_USER_NOTICE_MEMBER_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<NOTICEID>' + noticeId + '</NOTICEID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 전체 사용자 공지 등록 요청
 ****************************************************************************/
getRequestInsertUserNoticeAllParam = function(operatorId, title, contents) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_INSERT_USER_NOTICE_ALL</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<TITLE><![CDATA[' + title + ']]></TITLE>';
	paramData += '<CONTENTS><![CDATA[' + contents + ']]></CONTENTS>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 공지 등록 요청
 ****************************************************************************/
getRequestInsertUserNoticeParam = function(operatorId, title, contents,
		arrCompanyList, arrUserList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_INSERT_USER_NOTICE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<TITLE><![CDATA[' + title + ']]></TITLE>';
	paramData += '<CONTENTS><![CDATA[' + contents + ']]></CONTENTS>';
	paramData += '<COMPANYLIST>';
	if ($.isArray(arrCompanyList) ) {
		$.each(arrCompanyList, function(rowIdx, colVal) {
			paramData += '<COMPANY>';
			paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
			paramData += '</COMPANY>';
		});
	}
	paramData += '</COMPANYLIST>';
	paramData += '<USERLIST>';
	if ($.isArray(arrUserList) ) {
		$.each(arrUserList, function(rowIdx, arrUser) {
			paramData += '<USER>';
			$.each(arrUser, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
				} else if (colIdx == 2) {
					paramData += '<USERID>' + colVal + '</USERID>';
				}
			});
			paramData += '</USER>';
		});
	}
	paramData += '</USERLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 공지 정보 수정 요청
 ****************************************************************************/
getRequestUpdateUserNoticeParam = function(operatorId, noticeId, 
		title, contents, companyId, arrUserList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_UPDATE_USER_NOTICE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<NOTICEID>' + noticeId + '</NOTICEID>';
	paramData += '<TITLE><![CDATA[' + title + ']]></TITLE>';
	paramData += '<CONTENTS><![CDATA[' + contents + ']]></CONTENTS>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<USERLIST>';
	if ($.isArray(arrUserList) ) {
		$.each(arrUserList, function(rowIdx, arrUser) {
			paramData += '<USER>';
			$.each(arrUser, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
				} else if (colIdx == 2) {
					paramData += '<USERID>' + colVal + '</USERID>';
				}
			});
			paramData += '</USER>';
		});
	}
	paramData += '</USERLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 공지 삭제 요청
 ****************************************************************************/
getRequestDeleteUserNoticeParam = function(operatorId, noticeId, companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DELETE_USER_NOTICE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<NOTICEID>' + noticeId + '</NOTICEID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 로그 목록 요청
 ****************************************************************************/
getRequestUserLogListParam = function(companyId, arrDeptList, userId,
		logType, searchDateFrom, searchDateTo, orderByName,
		orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_USER_LOG_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<LOGTYPE>' + logType + '</LOGTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 로그 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateUserLogListFileParam = function(companyId, arrDeptList, userId,
		logType, searchDateFrom, searchDateTo, orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_USER_LOG_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<LOGTYPE>' + logType + '</LOGTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 로그 정보 요청
 ****************************************************************************/
getRequestUserLogInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_USER_LOG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 강제검사 목록 요청
 ****************************************************************************/
getRequestForceSearchListParam = function(searchId, companyId, 
		searchDateFrom, searchDateTo, orderByName,
		orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_FORCE_SEARCH_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEARCHID>' + searchId + '</SEARCHID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 강제검사 정보 요청
 ****************************************************************************/
getRequestForceSearchInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_FORCE_SEARCH_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 강제검사 대상 사용자 목록 요청
 ****************************************************************************/
getRequestForceSearchMemberListParam = function(searchId, companyId, arrDeptList,
		orderByName, orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_FORCE_SEARCH_MEMBER_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEARCHID>' + searchId + '</SEARCHID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 강제검사 패턴 요청
 ****************************************************************************/
getRequestForceSearchPatternParam = function(searchId, companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_FORCE_SEARCH_PATTERN</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEARCHID>' + searchId + '</SEARCHID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 강제검사 등록 요청
 ****************************************************************************/
getRequestInsertForceSearchParam = function(operatorId, threadPriorityType, 
		searchAfterNextBootingFlag, jobProcessingType, searchMethod, 
		includeDocsFlag, includeImgsFlag, includeZipsFlag, searchStartDatetime, 
		arrCompanyList, arrUserList, arrPatternList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_INSERT_FORCE_SEARCH</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<THREADPRIORITYTYPE>' + threadPriorityType + '</THREADPRIORITYTYPE>';
	paramData += '<SEARCHAFTERNEXTBOOTINGFLAG>' + searchAfterNextBootingFlag + '</SEARCHAFTERNEXTBOOTINGFLAG>';
	paramData += '<JOBPROCESSINGTYPE>' + jobProcessingType + '</JOBPROCESSINGTYPE>';
	paramData += '<SEARCHMETHOD>' + searchMethod + '</SEARCHMETHOD>';
	paramData += '<INCLUDEDOCSFLAG>' + includeDocsFlag + '</INCLUDEDOCSFLAG>';
	paramData += '<INCLUDEIMGSFLAG>' + includeImgsFlag + '</INCLUDEIMGSFLAG>';
	paramData += '<INCLUDEZIPSFLAG>' + includeZipsFlag + '</INCLUDEZIPSFLAG>';
	paramData += '<SEARCHSTARTDATETIME>' + searchStartDatetime + '</SEARCHSTARTDATETIME>';
	paramData += '<COMPANYLIST>';
	if ($.isArray(arrCompanyList) ) {
		$.each(arrCompanyList, function(rowIdx, colVal) {
			paramData += '<COMPANY>';
			paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
			paramData += '</COMPANY>';
		});
	}
	paramData += '</COMPANYLIST>';
	paramData += '<USERLIST>';
	if ($.isArray(arrUserList) ) {
		$.each(arrUserList, function(rowIdx, arrUser) {
			paramData += '<USER>';
			$.each(arrUser, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
				} else if (colIdx == 2) {
					paramData += '<USERID>' + colVal + '</USERID>';
				}
			});
			paramData += '</USER>';
		});
	}
	paramData += '</USERLIST>';
	paramData += '<PATTERNLIST>';
	if ($.isArray(arrPatternList) ) {
		$.each(arrPatternList, function(rowIdx, arrPattern) {
			paramData += '<PATTERN>';
			paramData += '<PATTERNID>' + arrPattern[0] + '</PATTERNID>';
			paramData += '<PATTERNSUBID>' + arrPattern[1] + '</PATTERNSUBID>';
			paramData += '</PATTERN>';
		});
	}
	paramData += '</PATTERNLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 강제검사 정보 수정 요청
 ****************************************************************************/
getRequestUpdateForceSearchParam = function(operatorId, searchId, 
		threadPriorityType, searchAfterNextBootingFlag, jobProcessingType, 
		searchMethod, includeDocsFlag, includeImgsFlag, includeZipsFlag, 
		searchStartDatetime, companyId, arrDeptList, arrUserList, arrPatternList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_UPDATE_FORCE_SEARCH</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<SEARCHID>' + searchId + '</SEARCHID>';
	paramData += '<THREADPRIORITYTYPE>' + threadPriorityType + '</THREADPRIORITYTYPE>';
	paramData += '<SEARCHAFTERNEXTBOOTINGFLAG>' + searchAfterNextBootingFlag + '</SEARCHAFTERNEXTBOOTINGFLAG>';
	paramData += '<JOBPROCESSINGTYPE>' + jobProcessingType + '</JOBPROCESSINGTYPE>';
	paramData += '<SEARCHMETHOD>' + searchMethod + '</SEARCHMETHOD>';
	paramData += '<INCLUDEDOCSFLAG>' + includeDocsFlag + '</INCLUDEDOCSFLAG>';
	paramData += '<INCLUDEIMGSFLAG>' + includeImgsFlag + '</INCLUDEIMGSFLAG>';
	paramData += '<INCLUDEZIPSFLAG>' + includeZipsFlag + '</INCLUDEZIPSFLAG>';
	paramData += '<SEARCHSTARTDATETIME>' + searchStartDatetime + '</SEARCHSTARTDATETIME>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERLIST>';
	if ($.isArray(arrUserList) ) {
		$.each(arrUserList, function(rowIdx, arrUser) {
			paramData += '<USER>';
			$.each(arrUser, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
				} else if (colIdx == 2) {
					paramData += '<USERID>' + colVal + '</USERID>';
				}
			});
			paramData += '</USER>';
		});
	}
	paramData += '</USERLIST>';
	paramData += '<PATTERNLIST>';
	if ($.isArray(arrPatternList) ) {
		$.each(arrPatternList, function(rowIdx, arrPattern) {
			paramData += '<PATTERN>';
			paramData += '<PATTERNID>' + arrPattern[0] + '</PATTERNID>';
			paramData += '<PATTERNSUBID>' + arrPattern[1] + '</PATTERNSUBID>';
			paramData += '</PATTERN>';
		});
	}
	paramData += '</PATTERNLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 강제검사 상태 변경 요청
 ****************************************************************************/
getRequestChangeForceSearchStateParam = function(operatorId, searchId, 
		companyId, searchstateflag) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CHANGE_FORCE_SEARCH_STATE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<SEARCHID>' + searchId + '</SEARCHID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<SEARCHSTATEFLAG>' + searchstateflag + '</SEARCHSTATEFLAG>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 강제검사 삭제 요청
 ****************************************************************************/
getRequestDeleteForceSearchParam = function(operatorId, searchId, companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DELETE_FORCE_SEARCH</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<SEARCHID>' + searchId + '</SEARCHID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 강제검사 진행 상황 목록 요청
 ****************************************************************************/
getRequestForceSearchStatusListParam = function(searchId, companyId,
		deptCode, completeFlag, orderByName,
		orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_FORCE_SEARCH_STATUS_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEARCHID>' + searchId + '</SEARCHID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '<COMPLETEFLAG>' + completeFlag + '</COMPLETEFLAG>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 예약검사 정보 요청
 ****************************************************************************/
getRequestReserveSearchInfoParam = function(companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_RESERVE_SEARCH_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 예약검사 정보 저장 요청
 ****************************************************************************/
getRequestSaveReserveSearchParam = function(operatorId, companyId, arrPolicyList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_RESERVE_SEARCH</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<POLICYLIST>';
	if ($.isArray(arrPolicyList) ) {
		$.each(arrPolicyList, function(rowIdx, colVal) {
			paramData += '<POLICY>';
			var htPolicyInfo = colVal;

			var searchScheduleType = htPolicyInfo.get("searchscheduletype");
			if ((searchScheduleType == null) || (searchScheduleType.length <= 0)) {
				searchScheduleType = "";
			}
			var nthWeekForMonth = htPolicyInfo.get("nthweekformonth");
			if ((nthWeekForMonth == null) || (nthWeekForMonth.length <= 0)) {
				nthWeekForMonth = "";
			}
			var dayOfWeekForMonth = htPolicyInfo.get("dayofweekformonth");
			if ((dayOfWeekForMonth == null) || (dayOfWeekForMonth.length <= 0)) {
				dayOfWeekForMonth = "";
			}
			var searchHoursForMonth = htPolicyInfo.get("searchhoursformonth");
			if ((searchHoursForMonth == null) || (searchHoursForMonth.length <= 0)) {
				searchHoursForMonth = "";
			}
			var searchMinutesForMonth = htPolicyInfo.get("searchminutesformonth");
			if ((searchMinutesForMonth == null) || (searchMinutesForMonth.length <= 0)) {
				searchMinutesForMonth = "";
			}
			var dayOfWeekForWeek = htPolicyInfo.get("dayofweekforweek");
			if ((dayOfWeekForWeek == null) || (dayOfWeekForWeek.length <= 0)) {
				dayOfWeekForWeek = "";
			}
			var searchHoursForWeek = htPolicyInfo.get("searchhoursforweek");
			if ((searchHoursForWeek == null) || (searchHoursForWeek.length <= 0)) {
				searchHoursForWeek = "";
			}
			var searchMinutesForWeek = htPolicyInfo.get("searchminutesforweek");
			if ((searchMinutesForWeek == null) || (searchMinutesForWeek.length <= 0)) {
				searchMinutesForWeek = "";
			}
			var searchHoursForDay = htPolicyInfo.get("searchhoursforday");
			if ((searchHoursForDay == null) || (searchHoursForDay.length <= 0)) {
				searchHoursForDay = "";
			}
			var searchMinutesForDay = htPolicyInfo.get("searchminutesforday");
			if ((searchMinutesForDay == null) || (searchMinutesForDay.length <= 0)) {
				searchMinutesForDay = "";
			}
			var searchSpecifiedDate = htPolicyInfo.get("searchspecifieddate");
			if ((searchSpecifiedDate == null) || (searchSpecifiedDate.length <= 0)) {
				searchSpecifiedDate = "";
			}
			var searchHoursForSpecifiedDate = htPolicyInfo.get("searchhoursforspecifieddate");
			if ((searchHoursForSpecifiedDate == null) || (searchHoursForSpecifiedDate.length <= 0)) {
				searchHoursForSpecifiedDate = "";
			}
			var searchMinutesForSpecifiedDate = htPolicyInfo.get("searchminutesforspecifieddate");
			if ((searchMinutesForSpecifiedDate == null) || (searchMinutesForSpecifiedDate.length <= 0)) {
				searchMinutesForSpecifiedDate = "";
			}

			paramData += '<SEARCHSCHEDULETYPE>' + searchScheduleType + '</SEARCHSCHEDULETYPE>'; 
			paramData += '<NTHWEEKFORMONTH>' + nthWeekForMonth + '</NTHWEEKFORMONTH>';
			paramData += '<DAYOFWEEKFORMONTH>' + dayOfWeekForMonth + '</DAYOFWEEKFORMONTH>';
			paramData += '<SEARCHHOURSFORMONTH>' + searchHoursForMonth + '</SEARCHHOURSFORMONTH>';
			paramData += '<SEARCHMINUTESFORMONTH>' + searchMinutesForMonth + '</SEARCHMINUTESFORMONTH>';
			paramData += '<DAYOFWEEKFORWEEK>' + dayOfWeekForWeek + '</DAYOFWEEKFORWEEK>';
			paramData += '<SEARCHHOURSFORWEEK>' + searchHoursForWeek + '</SEARCHHOURSFORWEEK>';
			paramData += '<SEARCHMINUTESFORWEEK>' + searchMinutesForWeek + '</SEARCHMINUTESFORWEEK>';
			paramData += '<SEARCHHOURSFORDAY>' + searchHoursForDay + '</SEARCHHOURSFORDAY>';
			paramData += '<SEARCHMINUTESFORDAY>' + searchMinutesForDay + '</SEARCHMINUTESFORDAY>';
			paramData += '<SEARCHSPECIFIEDDATE>' + searchSpecifiedDate + '</SEARCHSPECIFIEDDATE>';
			paramData += '<SEARCHHOURSFORSPECIFIEDDATE>' + searchHoursForSpecifiedDate + '</SEARCHHOURSFORSPECIFIEDDATE>';
			paramData += '<SEARCHMINUTESFORSPECIFIEDDATE>' + searchMinutesForSpecifiedDate + '</SEARCHMINUTESFORSPECIFIEDDATE>';

			var arrUserList = htPolicyInfo.get("userlist");
			paramData += '<USERLIST>';
			if ($.isArray(arrUserList) ) {
				$.each(arrUserList, function(rowIdx, arrUser) {
					paramData += '<USER>';
					$.each(arrUser, function(colIdx, colVal) {
						paramData += '<USERID>' + colVal + '</USERID>';
					});
					paramData += '</USER>';
				});
			}
			paramData += '</USERLIST>';

			paramData += '</POLICY>';
		});
	}
	paramData += '</POLICYLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 결재자 설정 정보 요청
 ****************************************************************************/
getRequestCompanyDecodingApprobatorInfoParam = function(companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_COMPANY_DECODING_APPROBATOR_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사업장 결재자 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveCompanyDecodingApprobatorParam = function(operatorId, 
		arrCompanyList, arrDecodingApprobatorData) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_COMPANY_DECODING_APPROBATOR</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYLIST>';
	if ($.isArray(arrCompanyList) ) {
		$.each(arrCompanyList, function(rowIdx, colVal) {
			paramData += '<COMPANY>';
			paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
			paramData += '</COMPANY>';
		});
	}
	paramData += '</COMPANYLIST>';
	paramData += '<APPROBATORLIST>';
	if ($.isArray(arrDecodingApprobatorData) ) {
		$.each(arrDecodingApprobatorData, function(rowIdx, arrDecodingApprobator) {
			paramData += '<APPROBATOR>';
			$.each(arrDecodingApprobator, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<APPROBATORCOMPANYID>' + colVal + '</APPROBATORCOMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<APPROBATORDEPTCODE>' + colVal + '</APPROBATORDEPTCODE>';
				} else if (colIdx == 2) {
					paramData += '<APPROBATORUSERID>' + colVal + '</APPROBATORUSERID>';
				} else if (colIdx == 3) {
					paramData += '<APPROBATORPRIORITY>' + colVal + '</APPROBATORPRIORITY>';
				} else if (colIdx == 4) {
					paramData += '<APPROBATORTYPE>' + colVal + '</APPROBATORTYPE>';
				}
			});
			paramData += '</APPROBATOR>';
		});
	}
	paramData += '</APPROBATORLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서 결재자 설정 정보 요청
 ****************************************************************************/
getRequestDeptDecodingApprobatorInfoParam = function(companyId, deptCode) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DEPT_DECODING_APPROBATOR_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서 결재자 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveDeptDecodingApprobatorParam = function(operatorId, 
		arrDeptList, arrDecodingApprobatorData) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_DEPT_DECODING_APPROBATOR</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, arrDept) {
			paramData += '<DEPT>';
			$.each(arrDept, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
				}
			});
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<APPROBATORLIST>';
	if ($.isArray(arrDecodingApprobatorData) ) {
		$.each(arrDecodingApprobatorData, function(rowIdx, arrDecodingApprobator) {
			paramData += '<APPROBATOR>';
			$.each(arrDecodingApprobator, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<APPROBATORCOMPANYID>' + colVal + '</APPROBATORCOMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<APPROBATORDEPTCODE>' + colVal + '</APPROBATORDEPTCODE>';
				} else if (colIdx == 2) {
					paramData += '<APPROBATORUSERID>' + colVal + '</APPROBATORUSERID>';
				} else if (colIdx == 3) {
					paramData += '<APPROBATORPRIORITY>' + colVal + '</APPROBATORPRIORITY>';
				} else if (colIdx == 4) {
					paramData += '<APPROBATORTYPE>' + colVal + '</APPROBATORTYPE>';
				}
			});
			paramData += '</APPROBATOR>';
		});
	}
	paramData += '</APPROBATORLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 결재자 설정 정보 요청
 ****************************************************************************/
getRequestUserDecodingApprobatorInfoParam = function(companyId, deptCode, userId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_USER_DECODING_APPROBATOR_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 결재자 설정 정보 저장 요청
 ****************************************************************************/
getRequestSaveUserDecodingApprobatorParam = function(operatorId, 
		arrUserList, arrDecodingApprobatorData) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAVE_USER_DECODING_APPROBATOR</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<USERLIST>';
	if ($.isArray(arrUserList) ) {
		$.each(arrUserList, function(rowIdx, arrUser) {
			paramData += '<USER>';
			$.each(arrUser, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
				} else if (colIdx == 2) {
					paramData += '<USERID>' + colVal + '</USERID>';
				}
			});
			paramData += '</USER>';
		});
	}
	paramData += '</USERLIST>';
	paramData += '<APPROBATORLIST>';
	if ($.isArray(arrDecodingApprobatorData) ) {
		$.each(arrDecodingApprobatorData, function(rowIdx, arrDecodingApprobator) {
			paramData += '<APPROBATOR>';
			$.each(arrDecodingApprobator, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<APPROBATORCOMPANYID>' + colVal + '</APPROBATORCOMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<APPROBATORDEPTCODE>' + colVal + '</APPROBATORDEPTCODE>';
				} else if (colIdx == 2) {
					paramData += '<APPROBATORUSERID>' + colVal + '</APPROBATORUSERID>';
				} else if (colIdx == 3) {
					paramData += '<APPROBATORPRIORITY>' + colVal + '</APPROBATORPRIORITY>';
				} else if (colIdx == 4) {
					paramData += '<APPROBATORTYPE>' + colVal + '</APPROBATORTYPE>';
				}
			});
			paramData += '</APPROBATOR>';
		});
	}
	paramData += '</APPROBATORLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 결재 목록 요청
 ****************************************************************************/
getRequestDecodingApprovalListParam = function(companyId, arrDeptList, userId,
		approvalKind, approvalType, approvalState, searchDateFrom,
		searchDateTo, orderByName, orderByDirection, readRecordCount,
		readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DECODING_APPROVAL_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<APPROVALKIND>' + approvalKind + '</APPROVALKIND>';
	paramData += '<APPROVALTYPE>' + approvalType + '</APPROVALTYPE>';
	paramData += '<APPROVALSTATE>' + approvalState + '</APPROVALSTATE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 결재 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateDecodingApprovalListFileParam = function(companyId, arrDeptList, userId,
		approvalKind, approvalType, approvalState, searchDateFrom,
		searchDateTo, orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_DECODING_APPROVAL_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<APPROVALKIND>' + approvalKind + '</APPROVALKIND>';
	paramData += '<APPROVALTYPE>' + approvalType + '</APPROVALTYPE>';
	paramData += '<APPROVALSTATE>' + approvalState + '</APPROVALSTATE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 결재 정보 요청
 ****************************************************************************/
getRequestDecodingApprovalInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DECODING_APPROVAL_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 결재 요청 파일 리스트
 ****************************************************************************/
getRequestDecodingApprovalFileListParam = function(companyId, deptCode, userId,
		approvalId, orderByName, orderByDirection, readRecordCount, readPageNo) {

	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DECODING_APPROVAL_FILELIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<APPROVALID>' + approvalId + '</APPROVALID>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 결재 상황 요청
 ****************************************************************************/
getRequestDecodingApprovalStatusInfoParam = function(companyId, deptCode, userId,
		approvalId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DECODING_APPROVAL_STATUS_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<APPROVALID>' + approvalId + '</APPROVALID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 결재 요청 내역
 ****************************************************************************/
getRequestDecodingApprovalHistoryParam = function(companyId, deptCode, userId,
		approvalId, orderByName, orderByDirection, readRecordCount, readPageNo) {

	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DECODING_APPROVAL_HISTORY</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<APPROVALID>' + approvalId + '</APPROVALID>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * DB 보안 설정 정보 요청
 ****************************************************************************/
getRequestDbProtectionInfoParam = function(companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DB_PROTECTION_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * DB 보안 설정 정보 변경 요청
 ****************************************************************************/
getRequestUpdateDbProtectionParam = function(operatorId, companyId, useFlag,
		arrProgramList, arrAddressList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_UPDATE_DB_PROTECTION</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<USEFLAG>' + useFlag + '</USEFLAG>';
	paramData += '<PROGRAMLIST>';
	if ($.isArray(arrProgramList) ) {
		$.each(arrProgramList, function(rowIdx, arrProgram) {
			paramData += '<PROGRAM>';
			$.each(arrProgram, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<PROGRAMNAME>' + colVal + '</PROGRAMNAME>';
				} else if (colIdx == 1) {
					paramData += '<FILENAME>' + colVal + '</FILENAME>';
				}
			});
			paramData += '</PROGRAM>';
		});
	}
	paramData += '</PROGRAMLIST>';
	paramData += '<ADDRESSLIST>';
	if ($.isArray(arrAddressList) ) {
		$.each(arrAddressList, function(rowIdx, colVal) {
			paramData += '<ADDRESS>';
			paramData += '<IPADDRESS>' + colVal + '</IPADDRESS>';
			paramData += '</ADDRESS>';
		});
	}
	paramData += '</ADDRESSLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * DB 보안 로그 목록 요청
 ****************************************************************************/
getRequestDbProtectionLogListParam = function(companyId, ipAddress,
		logType, searchDateFrom, searchDateTo, orderByName,
		orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DB_PROTECTION_LOG_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<IPADDRESS>' + ipAddress + '</IPADDRESS>';
	paramData += '<LOGTYPE>' + logType + '</LOGTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * DB 보안 로그 정보 요청
 ****************************************************************************/
getRequestDbProtectionLogInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DB_PROTECTION_LOG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 검사 목록 요청
 ****************************************************************************/
getRequestSearchLogListParam = function(companyId, arrDeptList,
		userId, searchId, searchType, userType, detectStatus,
		searchDateFrom, searchDateTo, orderByName, orderByDirection,
		readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SEARCH_LOG_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<SEARCHID>' + searchId + '</SEARCHID>';
	paramData += '<SEARCHTYPE>' + searchType + '</SEARCHTYPE>';
	paramData += '<USERTYPE>' + userType + '</USERTYPE>';
	paramData += '<DETECTSTATUS>' + detectStatus + '</DETECTSTATUS>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 검사 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateSearchLogListFileParam = function(companyId, arrDeptList,
		userId, searchId, searchType, userType, detectStatus,
		searchDateFrom, searchDateTo, orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_SEARCH_LOG_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<SEARCHID>' + searchId + '</SEARCHID>';
	paramData += '<SEARCHTYPE>' + searchType + '</SEARCHTYPE>';
	paramData += '<USERTYPE>' + userType + '</USERTYPE>';
	paramData += '<DETECTSTATUS>' + detectStatus + '</DETECTSTATUS>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 검사 정보 요청
 ****************************************************************************/
getRequestSearchLogInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SEARCH_LOG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 검출 목록 요청
 ****************************************************************************/
getRequestDetectLogListParam = function(companyId, arrDeptList,
		userId, searchId, searchType, userType, detectStatus, result,
		searchDateFrom, searchDateTo, orderByName, orderByDirection,
		readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DETECT_LOG_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<SEARCHID>' + searchId + '</SEARCHID>';
	paramData += '<SEARCHTYPE>' + searchType + '</SEARCHTYPE>';
	paramData += '<USERTYPE>' + userType + '</USERTYPE>';
	paramData += '<DETECTSTATUS>' + detectStatus + '</DETECTSTATUS>';
	paramData += '<RESULT>' + result + '</RESULT>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 검출 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateDetectLogListFileParam = function(companyId, arrDeptList,
		userId, searchId, searchType, userType, detectStatus, result,
		searchDateFrom, searchDateTo, orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_DETECT_LOG_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<SEARCHID>' + searchId + '</SEARCHID>';
	paramData += '<SEARCHTYPE>' + searchType + '</SEARCHTYPE>';
	paramData += '<USERTYPE>' + userType + '</USERTYPE>';
	paramData += '<DETECTSTATUS>' + detectStatus + '</DETECTSTATUS>';
	paramData += '<RESULT>' + result + '</RESULT>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 검출 정보 요청
 ****************************************************************************/
getRequestDetectLogInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DETECT_LOG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 실시간 감시 목록 요청
 ****************************************************************************/
getRequestRealtimeObservationLogListParam = function(companyId, arrDeptList,
		userId, userType, observationType, detectKeywordCount, searchDateFrom,
		searchDateTo, orderByName, orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_REALTIMEOBSERVATION_LOG_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<USERTYPE>' + userType + '</USERTYPE>';
	paramData += '<OBSERVATIONTYPE>' + observationType + '</OBSERVATIONTYPE>';
	paramData += '<DETECTKEYWORDCOUNT>' + detectKeywordCount + '</DETECTKEYWORDCOUNT>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 실시간 감시 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateRealtimeObservationLogListParam = function(companyId, arrDeptList,
		userId, userType, observationType, detectKeywordCount, searchDateFrom, 
		searchDateTo, orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_REALTIMEOBSERVATION_LOG_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<USERTYPE>' + userType + '</USERTYPE>';
	paramData += '<OBSERVATIONTYPE>' + observationType + '</OBSERVATIONTYPE>';
	paramData += '<DETECTKEYWORDCOUNT>' + detectKeywordCount + '</DETECTKEYWORDCOUNT>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 실시간 감시 정보 요청
 ****************************************************************************/
getRequestRealtimeObservationLogInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_REALTIMEOBSERVATION_LOG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 출력 로그 목록 요청
 ****************************************************************************/
getRequestPrintLogListParam = function(companyId, arrDeptList,
		userId, printerName, searchDateFrom, searchDateTo,
		orderByName, orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_PRINT_LOG_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<PRINTERNAME>' + printerName + '</PRINTERNAME>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 출력 로그 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreatePrintLogListFileParam = function(companyId, arrDeptList,
		userId, printerName, searchDateFrom, searchDateTo,
		orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_PRINT_LOG_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<PRINTERNAME>' + printerName + '</PRINTERNAME>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 출력 로그 정보 요청
 ****************************************************************************/
getRequestPrintLogInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_PRINT_LOG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 매체 제어 목록 요청
 ****************************************************************************/
getRequestMediaControlLogListParam = function(companyId, arrDeptList,
		userId, userType, mediaType, controlType, searchDateFrom, searchDateTo,
		orderByName, orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_MEDIA_CONTROL_LOG_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<USERTYPE>' + userType + '</USERTYPE>';
	paramData += '<MEDIATYPE>' + mediaType + '</MEDIATYPE>';
	paramData += '<CONTROLTYPE>' + controlType + '</CONTROLTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 매체 제어 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateMediaControlLogListFileParam = function(companyId, arrDeptList,
		userId, userType, mediaType, controlType, searchDateFrom, searchDateTo,
		orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_MEDIA_CONTROL_LOG_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<USERTYPE>' + userType + '</USERTYPE>';
	paramData += '<MEDIATYPE>' + mediaType + '</MEDIATYPE>';
	paramData += '<CONTROLTYPE>' + controlType + '</CONTROLTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 매체 제어 정보 요청
 ****************************************************************************/
getRequestMediaControlLogInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_MEDIA_CONTROL_LOG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * URL 차단 목록 요청
 ****************************************************************************/
getRequestUrlBlockLogListParam = function(companyId, arrDeptList,
		userId, blockUrl, searchDateFrom, searchDateTo,
		orderByName, orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_URL_BLOCK_LOG_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<BLOCKURL>' + blockUrl + '</BLOCKURL>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * URL 차단 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateUrlBlockLogListFileParam = function(companyId, arrDeptList,
		userId, blockUrl, searchDateFrom, searchDateTo,
		orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_URL_BLOCK_LOG_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<BLOCKURL>' + blockUrl + '</BLOCKURL>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * URL 차단 정보 요청
 ****************************************************************************/
getRequestUrlBlockLogInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_URL_BLOCK_LOG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 안전반출 목록 요청
 ****************************************************************************/
getRequestSafeExportListParam = function(companyId, arrDeptList,
		userId, receiver, decodeStatus, searchDateFrom, searchDateTo, 
		orderByName, orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAFE_EXPORT_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<RECEIVER>' + receiver + '</RECEIVER>';
	paramData += '<DECODESTATUS>' + decodeStatus + '</DECODESTATUS>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 안전반출 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateSafeExportListFileParam = function(companyId, arrDeptList,
		userId, receiver, decodeStatus, searchDateFrom, searchDateTo, 
		orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_SAFE_EXPORT_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<RECEIVER>' + receiver + '</RECEIVER>';
	paramData += '<DECODESTATUS>' + decodeStatus + '</DECODESTATUS>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 안전반출 정보 요청
 ****************************************************************************/
getRequestSafeExportInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAFE_EXPORT_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 랜섬웨어 검출 로그 목록 요청
 ****************************************************************************/
getRequestRansomwareDetectLogListParam = function(companyId, arrDeptList,
		userId, fileName, searchDateFrom, searchDateTo,
		orderByName, orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_RANSOMWARE_DETECT_LOG_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<FILENAME>' + fileName + '</FILENAME>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 랜섬웨어 검출 로그 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateRansomwareDetectLogListFileParam = function(companyId, arrDeptList,
		userId, fileName, searchDateFrom, searchDateTo,
		orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_RANSOMWARE_DETECT_LOG_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<FILENAME>' + fileName + '</FILENAME>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 랜섬웨어 검출 로그 정보 요청
 ****************************************************************************/
getRequestRansomwareDetectLogInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_RANSOMWARE_DETECT_LOG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 문서보안 권한 설정 내역 요청
 ****************************************************************************/
getRequestDrmPermissionSettingsLogListParam = function(companyId, arrDeptList,
		userId, fileName, policyName, searchDateFrom, searchDateTo,
		orderByName, orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DRM_PERMISSION_SETTINGS_LOG_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<FILENAME>' + fileName + '</FILENAME>';
	paramData += '<POLICYNAME>' + policyName + '</POLICYNAME>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 문서보안 권한 설정 정보 요청
 ****************************************************************************/
getRequestDrmPermissionSettingsLogInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DRM_PERMISSION_SETTINGS_LOG_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 기간별 검사 현황 요청
 ****************************************************************************/
getRequestSearchStatusPerTermsParam = function(companyId, arrDeptList, userId,
		termType, searchDateFrom, searchDateTo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SEARCH_STATUS_PER_TERMS</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<TERMTYPE>' + termType + '</TERMTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 기간별 검사 현황 파일 생성 요청
 ****************************************************************************/
getRequestCreateSearchStatusPerTermsFileParam = function(companyId, 
		arrDeptList, userId, termType, searchDateFrom, searchDateTo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_SEARCH_STATUS_PER_TERMS_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<TERMTYPE>' + termType + '</TERMTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 기간별 검출 현황 요청
 ****************************************************************************/
getRequestDetectStatusPerTermsParam = function(companyId, arrDeptList, userId,
		termType, searchDateFrom, searchDateTo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DETECT_STATUS_PER_TERMS</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<TERMTYPE>' + termType + '</TERMTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 기간별 검출 현황 파일 생성 요청
 ****************************************************************************/
getRequestCreateDetectStatusPerTermsFileParam = function(companyId, arrDeptList, userId,
		termType, searchDateFrom, searchDateTo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_DETECT_STATUS_PER_TERMS_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<TERMTYPE>' + termType + '</TERMTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 조직별 Agent 설치 현황 요청
 ****************************************************************************/
getRequestAgentInstallStatusParam = function(companyId, arrDeptList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_AGENT_INSTALL_STATUS</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 조직별 Agent 설치 현황 파일 생성 요청
 ****************************************************************************/
getRequestCreateAgentInstallStatusFileParam = function(companyId, arrDeptList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_AGENT_INSTALL_STATUS_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 조직별 패턴 검출 현황 요청
 ****************************************************************************/
getRequestPatternDetectStatusPerOrganizationParam = function(companyId,
		arrDeptList, userId, searchType, searchDateFrom, searchDateTo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_PATTERN_DETECT_STATUS_PER_ORGANIZATION</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<SEARCHTYPE>' + searchType + '</SEARCHTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 조직별 패턴 검출 현황 파일 생성 요청
 ****************************************************************************/
getRequestCreatePatternDetectStatusPerOrganizationFileParam = function(companyId,
		arrDeptList, userId, searchType, searchDateFrom, searchDateTo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_PATTERN_DETECT_STATUS_PER_ORGANIZATION_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<SEARCHTYPE>' + searchType + '</SEARCHTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 조직별 파일 유형 검출 현황 요청
 ****************************************************************************/
getRequestFileTypeDetectStatusPerOrganizationParam = function(companyId,
		arrDeptList, userId, searchType, searchDateFrom, searchDateTo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_FILETYPE_DETECT_STATUS_PER_ORGANIZATION</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<SEARCHTYPE>' + searchType + '</SEARCHTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 조직별 파일 유형 검출 현황 파일 생성 요청
 ****************************************************************************/
getRequestCreateFileTypeDetectStatusPerOrganizationFileParam = function(companyId,
		arrDeptList, userId, searchType, searchDateFrom, searchDateTo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_FILETYPE_DETECT_STATUS_PER_ORGANIZATION_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<SEARCHTYPE>' + searchType + '</SEARCHTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 패턴별 사업장 검출 현황 요청
 ****************************************************************************/
getRequestCompanyDetectStatusPerPatternParam = function(patternId,
		patternSubId, searchType, searchDateFrom, searchDateTo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_COMPANY_DETECT_STATUS_PER_PATTERN</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<PATTERNID>' + patternId + '</PATTERNID>';
	paramData += '<PATTERNSUBID>' + patternSubId + '</PATTERNSUBID>';
	paramData += '<SEARCHTYPE>' + searchType + '</SEARCHTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 패턴별 사업장 검출 현황 파일 생성 요청
 ****************************************************************************/
getRequestCreateCompanyDetectStatusPerPatternFileParam = function(patternId,
		patternSubId, searchType, searchDateFrom, searchDateTo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_COMPANY_DETECT_STATUS_PER_PATTERN_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<PATTERNID>' + patternId + '</PATTERNID>';
	paramData += '<PATTERNSUBID>' + patternSubId + '</PATTERNSUBID>';
	paramData += '<SEARCHTYPE>' + searchType + '</SEARCHTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 패턴별 부서 검출 현황 요청
 ****************************************************************************/
getRequestDeptDetectStatusPerPatternParam = function(patternId,
		patternSubId, companyId, searchType, searchDateFrom, searchDateTo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DEPT_DETECT_STATUS_PER_PATTERN</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<PATTERNID>' + patternId + '</PATTERNID>';
	paramData += '<PATTERNSUBID>' + patternSubId + '</PATTERNSUBID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<SEARCHTYPE>' + searchType + '</SEARCHTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 패턴별 부서 검출 현황 파일 생성 요청
 ****************************************************************************/
getRequestCreateDeptDetectStatusPerPatternFileParam = function(patternId,
		patternSubId, companyId, searchType, searchDateFrom, searchDateTo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_DEPT_DETECT_STATUS_PER_PATTERN_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<PATTERNID>' + patternId + '</PATTERNID>';
	paramData += '<PATTERNSUBID>' + patternSubId + '</PATTERNSUBID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<SEARCHTYPE>' + searchType + '</SEARCHTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 파일 유형별 사업장 검출 현황 요청
 ****************************************************************************/
getRequestCompanyDetectStatusPerFileTypeParam = function(fileTye,
		searchType, searchDateFrom, searchDateTo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_COMPANY_DETECT_STATUS_PER_FILETYPE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<FILETYPE>' + fileTye + '</FILETYPE>';
	paramData += '<SEARCHTYPE>' + searchType + '</SEARCHTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 파일 유형별 사업장 검출 현황 파일 생성 요청
 ****************************************************************************/
getRequestCreateCompanyDetectStatusPerFileTypeFileParam = function(fileTye,
		searchType, searchDateFrom, searchDateTo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_COMPANY_DETECT_STATUS_PER_FILETYPE_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<FILETYPE>' + fileTye + '</FILETYPE>';
	paramData += '<SEARCHTYPE>' + searchType + '</SEARCHTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 파일 유형별 부서 검출 현황 요청
 ****************************************************************************/
getRequestDeptDetectStatusPerFileTypeParam = function(fileTye,
		companyId, searchType, searchDateFrom, searchDateTo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DEPT_DETECT_STATUS_PER_FILETYPE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<FILETYPE>' + fileTye + '</FILETYPE>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<SEARCHTYPE>' + searchType + '</SEARCHTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 파일 유형별 부서 검출 현황 파일 생성 요청
 ****************************************************************************/
getRequestCreateDeptDetectStatusPerFileTypeFileParam = function(fileTye,
		companyId, searchType, searchDateFrom, searchDateTo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_DEPT_DETECT_STATUS_PER_FILETYPE_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<FILETYPE>' + fileTye + '</FILETYPE>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<SEARCHTYPE>' + searchType + '</SEARCHTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 기간별 출력 현황 요청
 ****************************************************************************/
getRequestPrintStatusPerTermsParam = function(companyId,
		arrDeptList, userId, termType, searchDateFrom, searchDateTo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_PRINT_STATUS_PER_TERMS</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<TERMTYPE>' + termType + '</TERMTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 기간별 출력 현황 파일 생성 요청
 ****************************************************************************/
getRequestCreatePrintStatusPerTermsFileParam = function(companyId,
		arrDeptList, userId, termType, searchDateFrom, searchDateTo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_PRINT_STATUS_PER_TERMS_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<TERMTYPE>' + termType + '</TERMTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 기간별 반출 현황 요청
 ****************************************************************************/
getRequestSafeExportStatusPerTermsParam = function(companyId,
		arrDeptList, userId, termType, searchDateFrom, searchDateTo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAFE_EXPORT_STATUS_PER_TERMS</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<TERMTYPE>' + termType + '</TERMTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 기간별 랜섬웨어 검출 현황 요청
 ****************************************************************************/
getRequestRansomwareDetectStatusPerTermsParam = function(companyId,
		arrDeptList, userId, termType, searchDateFrom, searchDateTo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_RANSOMWARE_DETECT_STATUS_PER_TERMS</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<TERMTYPE>' + termType + '</TERMTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 기간별 랜섬웨어 검출 현황 파일 생성 요청
 ****************************************************************************/
getRequestCreateRansomwareDetectStatusPerTermsFileParam = function(companyId,
		arrDeptList, userId, termType, searchDateFrom, searchDateTo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_RANSOMWARE_DETECT_STATUS_PER_TERMS_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<TERMTYPE>' + termType + '</TERMTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 검사 미실행 사용자 목록 요청
 ****************************************************************************/
getRequestUserNotExecutedSearchListParam = function(companyId,
		arrDeptList, searchDateFrom, orderByName, orderByDirection,
		readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_USER_NOT_EXECUTED_SEARCH_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 검사 미실행 사용자 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateUserNotExecutedSearchListFileParam = function(companyId,
		arrDeptList, searchDateFrom, orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_USER_NOT_EXECUTED_SEARCH_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자별 검출 현황 목록 요청
 ****************************************************************************/
getRequestDetectStatusPerUserListParam = function(companyId, arrDeptList,
		searchType, searchDateFrom, searchDateTo, orderByName,
		orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DETECT_STATUS_PER_USER_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<SEARCHTYPE>' + searchType + '</SEARCHTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자별 검출 현황 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateDetectStatusPerUserListFileParam = function(companyId,
		arrDeptList, searchType, searchDateFrom, searchDateTo,
		orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_DETECT_STATUS_PER_USER_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<SEARCHTYPE>' + searchType + '</SEARCHTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서별 검출 현황 목록 요청
 ****************************************************************************/
getRequestDetectStatusPerDeptListParam = function(companyId, searchType,
		searchDateFrom, searchDateTo, orderByName, orderByDirection,
		readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DETECT_STATUS_PER_DEPT_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<SEARCHTYPE>' + searchType + '</SEARCHTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서별 검출 현황 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateDetectStatusPerDeptListFileParam = function(companyId,
		searchType, searchDateFrom, searchDateTo, orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_DETECT_STATUS_PER_DEPT_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<SEARCHTYPE>' + searchType + '</SEARCHTYPE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 검출 파일 목록 요청
 ****************************************************************************/
getRequestDetectFileListParam = function(companyId, arrDeptList, userId,
		fileType, fileCategory, result,
		searchDateFrom, searchDateTo, orderByName, orderByDirection,
		readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DETECT_FILE_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<FILETYPE>' + fileType + '</FILETYPE>';
	paramData += '<FILECATEGORY>' + fileCategory + '</FILECATEGORY>';
	paramData += '<RESULT>' + result + '</RESULT>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 검출 파일 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateDetectFileListFileParam = function(companyId, arrDeptList, userId,
		fileType, fileCategory, result,
		searchDateFrom,	searchDateTo, orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_DETECT_FILE_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<FILETYPE>' + fileType + '</FILETYPE>';
	paramData += '<FILECATEGORY>' + fileCategory + '</FILECATEGORY>';
	paramData += '<RESULT>' + result + '</RESULT>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 검출 파일 정보 요청
 ****************************************************************************/
getRequestDetectFileInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DETECT_FILE_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 검출 파일 정보 변경 요청
 ****************************************************************************/
getRequestUpdateDetectFileParam = function(operatorId, companyId, deptCode,
		userId, searchId, searchSeqNo, fileCategory, fileCreationDate) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_UPDATE_DETECT_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<SEARCHID>' + searchId + '</SEARCHID>';
	paramData += '<SEARCHSEQNO>' + searchSeqNo + '</SEARCHSEQNO>';
	paramData += '<FILECATEGORY>' + fileCategory + '</FILECATEGORY>';
	paramData += '<FILECREATIONDATE>' + fileCreationDate + '</FILECREATIONDATE>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 검출 파일 보관 만료일 연장 요청
 ****************************************************************************/
getRequestDetectFileExtendExpirationParam = function(companyId, 
		userId, searchId, searchSeqNo, requesterType, requestId, 
		reason, extendDate) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>EXTEND_FILE_EXPIRATION</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<SEARCHID>' + searchId + '</SEARCHID>';
	paramData += '<SEARCHSEQNO>' + searchSeqNo + '</SEARCHSEQNO>';
	paramData += '<REQUESTERTYPE>' + requesterType + '</REQUESTERTYPE>';
	paramData += '<REQUESTERID>' + requestId + '</REQUESTERID>';
	paramData += '<REASON>' + reason + '</REASON>';
	paramData += '<EXTENDDATE>' + extendDate.replace(new RegExp('-', 'g'), '') + '</EXTENDDATE>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 검출 파일 보관 만료일 연장 내역 목록 요청
 ****************************************************************************/
getRequestDetectFileExpirationExtendHistoryParam = function(companyId, 
		deptCode, userId, searchId, searchSeqNo, orderByName,
		orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DETECT_FILE_EXPIRATION_EXTEND_HISTORY</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<SEARCHID>' + searchId + '</SEARCHID>';
	paramData += '<SEARCHSEQNO>' + searchSeqNo + '</SEARCHSEQNO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자별 검출 파일 처리 현황 목록 요청
 ****************************************************************************/
getRequestDetectFileProcessStatusPerUserListParam = function(companyId,
		arrDeptList, orderByName, orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DETECT_FILE_PROCESSING_STATUS_PER_USER_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자별 검출 파일 처리 현황 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateDetectFileProcessStatusPerUserListFileParam = function(companyId,
		arrDeptList, orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_DETECT_FILE_PROCESSING_STATUS_PER_USER_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서별 검출 파일 처리 현황 목록 요청
 ****************************************************************************/
getRequestDetectFileProcessStatusPerDeptListParam = function(companyId,
		orderByName, orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DETECT_FILE_PROCESSING_STATUS_PER_DEPT_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서별 검출 파일 처리 현황 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateDetectFileProcessStatusPerDeptListFileParam = function(companyId,
		orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_DETECT_FILE_PROCESSING_STATUS_PER_DEPT_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자별 검출 순위 요청
 ****************************************************************************/
getRequestDetectRankingPerUserListParam = function(companyId, deptCode,
		searchDateFrom, searchDateTo, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DETECT_RANKING_PER_USER_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자별 검출 순위 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateDetectRankingPerUserListFileParam = function(companyId,
		deptCode, searchDateFrom, searchDateTo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_DETECT_RANKING_PER_USER_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTCODE>' + deptCode + '</DEPTCODE>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서별 검출 순위 요청
 ****************************************************************************/
getRequestDetectRankingPerDeptListParam = function(companyId,
		searchDateFrom, searchDateTo, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DETECT_RANKING_PER_DEPT_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서별 검출 순위 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateDetectRankingPerDeptListFileParam = function(companyId,
		searchDateFrom, searchDateTo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_DETECT_RANKING_PER_DEPT_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자별 출력 현황 목록 요청
 ****************************************************************************/
getRequestPrintStatusPerUserListParam = function(companyId, arrDeptList,
		searchDateFrom, searchDateTo, orderByName, orderByDirection,
		readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_PRINT_STATUS_PER_USER_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자별 출력 현황 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreatePrintStatusPerUserListFileParam = function(companyId,
		arrDeptList, searchDateFrom, searchDateTo,
		orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_PRINT_STATUS_PER_USER_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서별 출력 현황 목록 요청
 ****************************************************************************/
getRequestPrintStatusPerDeptListParam = function(companyId,
		searchDateFrom, searchDateTo, orderByName, orderByDirection,
		readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_PRINT_STATUS_PER_DEPT_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서별 출력 현황 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreatePrintStatusPerDeptListFileParam = function(companyId,
		searchDateFrom, searchDateTo, orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_PRINT_STATUS_PER_DEPT_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자별 반출 현황 목록 요청
 ****************************************************************************/
getRequestSafeExportStatusPerUserListParam = function(companyId, arrDeptList,
		searchDateFrom, searchDateTo, orderByName, orderByDirection,
		readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAFE_EXPORT_STATUS_PER_USER_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자별 반출 현황 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateSafeExportStatusPerUserListFileParam = function(companyId,
		arrDeptList, searchDateFrom, searchDateTo,
		orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_SAFE_EXPORT_STATUS_PER_USER_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서별 반출 현황 목록 요청
 ****************************************************************************/
getRequestSafeExportStatusPerDeptListParam = function(companyId,
		searchDateFrom, searchDateTo, orderByName, orderByDirection,
		readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SAFE_EXPORT_STATUS_PER_DEPT_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 부서별 반출 현황 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateSafeExportStatusPerDeptListFileParam = function(companyId,
		searchDateFrom, searchDateTo, orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_SAFE_EXPORT_STATUS_PER_DEPT_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 월별 레포트 목록 요청
 ****************************************************************************/
getRequestMonthlyReportListParam = function(companyId, searchMonth,
		orderByName, orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_MONTHLY_REPORT_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<SEARCHMONTH>' + searchMonth + '</SEARCHMONTH>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 메일 전송 대상 레포트 목록 요청
 ****************************************************************************/
getRequestSendMailReportListParam = function(companyId, searchMonth) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SEND_MAIL_REPORT_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<SEARCHMONTH>' + searchMonth + '</SEARCHMONTH>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 월별 레포트 생성 요청
 ****************************************************************************/
getRequestCreateMonthlyReportParam = function(companyId, searchMonth) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_MONTHLY_REPORT_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<SEARCHMONTH>' + searchMonth + '</SEARCHMONTH>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 사용자 접속 현황 요청
 ****************************************************************************/
getRequestUserConnectionStatusParam = function(companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_USER_CONNECTION_STATUS</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 에이전트 모니터 목록 요청
 ****************************************************************************/
getRequestAgentMonitorListParam = function(companyId, arrDeptList,
		installFlag, serviceState, orderByName, orderByDirection, readRecordCount,
		readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_AGENT_MONITOR_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<INSTALLFLAG>' + installFlag + '</INSTALLFLAG>';
	paramData += '<SERVICESTATE>' + serviceState + '</SERVICESTATE>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 에이전트 시스템 현황 목록 요청
 ****************************************************************************/
getRequestAgentSystemStatusListParam = function(companyId, arrDeptList,
		installFlag, serviceState, orderByName, orderByDirection, readRecordCount,
		readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_AGENT_SYSTEM_STATUS_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<INSTALLFLAG>' + installFlag + '</INSTALLFLAG>';
	paramData += '<SERVICESTATE>' + serviceState + '</SERVICESTATE>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 에이전트 시스템 현황 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateAgentSystemStatusListFileParam = function(companyId, arrDeptList,
		installFlag, serviceState, orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_AGENT_SYSTEM_STATUS_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<INSTALLFLAG>' + installFlag + '</INSTALLFLAG>';
	paramData += '<SERVICESTATE>' + serviceState + '</SERVICESTATE>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 에이전트 시스템 현황 정보 요청
 ****************************************************************************/
getRequestAgentSystemStatusInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_AGENT_SYSTEM_STATUS_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 저작권 목록 요청
 ****************************************************************************/
getRequestSoftwareCopyrightListParam = function(softwareName, softwareType,
		manufacturer, vendor, orderByName, orderByDirection, readRecordCount,
		readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SOFTWARE_COPYRIGHT_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SOFTWARENAME><![CDATA[' + softwareName + ']]></SOFTWARENAME>';
	paramData += '<SOFTWARETYPE>' + softwareType + '</SOFTWARETYPE>';
	paramData += '<MANUFACTURER><![CDATA[' + manufacturer + ']]></MANUFACTURER>';
	paramData += '<VENDOR><![CDATA[' + vendor + ']]></VENDOR>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 저작권 정보 요청
 ****************************************************************************/
getRequestSoftwareCopyrightInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SOFTWARE_COPYRIGHT_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 소프트웨어 라이센스 Tree 정보 요청
 ****************************************************************************/
getRequestSoftwareLicenceTreeInfoParam = function(companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SOFTWARE_LICENCE_TREE_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 소프트웨어 라이센스 목록 요청
 ****************************************************************************/
getRequestSoftwareLicenceListParam = function(companyId, softwareName, 
		searchDateFrom, searchDateTo, orderByName, orderByDirection,
		readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SOFTWARE_LICENCE_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<SOFTWARENAME><![CDATA[' + softwareName + ']]></SOFTWARENAME>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 소프트웨어 라이센스 정보 요청
 ****************************************************************************/
getRequestSoftwareLicenceInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SOFTWARE_LICENCE_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 소프트웨어 라이센스 등록 요청
 ****************************************************************************/
getRequestInsertSoftwareLicenceParam = function(operatorId, companyId,
		softwareName, licenceKey, licenceCount, manufacturer, vendor, vendorEmail,
		vendorPhone, vendorFax) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_INSERT_SOFTWARE_LICENCE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<SOFTWARENAME><![CDATA[' + softwareName + ']]></SOFTWARENAME>';
	paramData += '<LICENCEKEY>' + licenceKey + '</LICENCEKEY>';
	paramData += '<LICENCECOUNT>' + licenceCount + '</LICENCECOUNT>';
	paramData += '<MANUFACTURER><![CDATA[' + manufacturer + ']]></MANUFACTURER>';
	paramData += '<VENDOR><![CDATA[' + vendor + ']]></VENDOR>';
	paramData += '<VENDOREMAIL>' + vendorEmail + '</VENDOREMAIL>';
	paramData += '<VENDORPHONE>' + vendorPhone + '</VENDORPHONE>';
	paramData += '<VENDORFAX>' + vendorFax + '</VENDORFAX>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 소프트웨어 라이센스 정보 수정 요청
 ****************************************************************************/
getRequestUpdateSoftwareLicenceParam = function(operatorId, seqNo, licenceKey,
		licenceCount, manufacturer, vendor, vendorEmail, vendorPhone, vendorFax) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_UPDATE_SOFTWARE_LICENCE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '<LICENCEKEY>' + licenceKey + '</LICENCEKEY>';
	paramData += '<LICENCECOUNT>' + licenceCount + '</LICENCECOUNT>';
	paramData += '<MANUFACTURER><![CDATA[' + manufacturer + ']]></MANUFACTURER>';
	paramData += '<VENDOR><![CDATA[' + vendor + ']]></VENDOR>';
	paramData += '<VENDOREMAIL>' + vendorEmail + '</VENDOREMAIL>';
	paramData += '<VENDORPHONE>' + vendorPhone + '</VENDORPHONE>';
	paramData += '<VENDORFAX>' + vendorFax + '</VENDORFAX>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 소프트웨어 라이센스 삭제 요청
 ****************************************************************************/
getRequestDeleteSoftwareLicenceParam = function(operatorId, seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_DELETE_SOFTWARE_LICENCE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 소프트웨어 배정 대상 사용자 목록 요청
 ****************************************************************************/
getRequestSoftwareAllocationTargetUserListParam = function(companyId, arrDeptList,
		softwareName, orderByName, orderByDirection, readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SOFTWARE_ALLOCATION_TARGET_USER_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<SOFTWARENAME><![CDATA[' + softwareName + ']]></SOFTWARENAME>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 소프트웨어 배정 목록 요청
 ****************************************************************************/
getRequestSoftwareAllocationListParam = function(companyId, arrDeptList, 
		softwareName, installState, allocateState, orderByName, orderByDirection,
		readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SOFTWARE_ALLOCATION_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<SOFTWARENAME><![CDATA[' + softwareName + ']]></SOFTWARENAME>';
	paramData += '<INSTALLSTATE>' + installState + '</INSTALLSTATE>';
	paramData += '<ALLOCATESTATE>' + allocateState + '</ALLOCATESTATE>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 소프트웨어 배정 요청
 ****************************************************************************/
getRequestAllocateSoftwareParam = function(operatorId, companyId, softwareName,
		arrTargetDeptList, arrUserList) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_ALLOCATE_SOFTWARE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<OPERATORID>' + operatorId + '</OPERATORID>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<SOFTWARENAME><![CDATA[' + softwareName + ']]></SOFTWARENAME>';
	paramData += '<TARGETDEPTLIST>';
	if ($.isArray(arrTargetDeptList) ) {
		$.each(arrTargetDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</TARGETDEPTLIST>';
	paramData += '<USERLIST>';
	if ($.isArray(arrUserList) ) {
		$.each(arrUserList, function(rowIdx, arrUser) {
			paramData += '<USER>';
			$.each(arrUser, function(colIdx, colVal) {
				if (colIdx == 0) {
					paramData += '<COMPANYID>' + colVal + '</COMPANYID>';
				} else if (colIdx == 1) {
					paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
				} else if (colIdx == 2) {
					paramData += '<USERID>' + colVal + '</USERID>';
				}
			});
			paramData += '</USER>';
		});
	}
	paramData += '</USERLIST>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 소프트웨어 설치 Tree 정보 요청
 ****************************************************************************/
getRequestSoftwareInstallationTreeInfoParam = function(companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SOFTWARE_INSTALLATION_TREE_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 소프트웨어 설치 트리 노드 요청
 ****************************************************************************/
getRequestSoftwareInstallationTreeNodesParam = function(companyId) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SOFTWARE_INSTALLATION_TREE_NODES</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 소프트웨어 설치 목록 요청
 ****************************************************************************/
getRequestSoftwareInstallationListParam = function(companyId, arrDeptList, userId,
		softwareName, searchDateFrom, searchDateTo, orderByName, orderByDirection,
		readRecordCount, readPageNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SOFTWARE_INSTALLATION_LIST</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<SOFTWARENAME><![CDATA[' + softwareName + ']]></SOFTWARENAME>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '<READRECORDCOUNT>' + readRecordCount + '</READRECORDCOUNT>';
	paramData += '<READPAGENO>' + readPageNo + '</READPAGENO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 소프트웨어 설치 목록 파일 생성 요청
 ****************************************************************************/
getRequestCreateSoftwareInstallationListFileParam = function(companyId,
		arrDeptList, userId, softwareName, searchDateFrom, searchDateTo,
		orderByName, orderByDirection) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_CREATE_SOFTWARE_INSTALLATION_LIST_FILE</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<COMPANYID>' + companyId + '</COMPANYID>';
	paramData += '<DEPTLIST>';
	if ($.isArray(arrDeptList) ) {
		$.each(arrDeptList, function(rowIdx, colVal) {
			paramData += '<DEPT>';
			paramData += '<DEPTCODE>' + colVal + '</DEPTCODE>';
			paramData += '</DEPT>';
		});
	}
	paramData += '</DEPTLIST>';
	paramData += '<USERID>' + userId + '</USERID>';
	paramData += '<SOFTWARENAME><![CDATA[' + softwareName + ']]></SOFTWARENAME>';
	paramData += '<SEARCHDATEFROM>' + searchDateFrom + '</SEARCHDATEFROM>';
	paramData += '<SEARCHDATETO>' + searchDateTo + '</SEARCHDATETO>';
	paramData += '<ORDERBYNAME>' + orderByName + '</ORDERBYNAME>';
	paramData += '<ORDERBYDIRECTION>' + orderByDirection + '</ORDERBYDIRECTION>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};

/*****************************************************************************
 * 소프트웨어 설치 정보 요청
 ****************************************************************************/
getRequestSoftwareInstallationInfoParam = function(seqNo) {
	var paramData = '';

	paramData += '<?xml version="1.0" encoding="utf-8" ?>';
	paramData += '<ZAVAWARE>';
	paramData += '<COMMAND>REQUEST_SOFTWARE_INSTALLATION_INFO</COMMAND>';
	paramData += '<REQUEST>';
	paramData += '<SEQNO>' + seqNo + '</SEQNO>';
	paramData += '</REQUEST>';
	paramData += '</ZAVAWARE>';

	return paramData;
};


