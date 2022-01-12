//**************************************************************************************
// 작업 유형
//**************************************************************************************
var MODE_INSERT = 0;
var MODE_UPDATE = 1;
var MODE_DELETE = 2;

//**************************************************************************************
// 입력 파라미터 유형 상수 선언
//**************************************************************************************
var PARAM_TYPE_NUMBER										= 0;
var PARAM_TYPE_SIGNED_INTEGER								= 1;
var PARAM_TYPE_ALPHANUMERIC									= 2;
var PARAM_TYPE_BASE64										= 3;
var PARAM_TYPE_ID											= 4;
var PARAM_TYPE_PWD											= 5;
var PARAM_TYPE_NAME											= 6;
var PARAM_TYPE_ORDER_BY_NAME								= 7;
var PARAM_TYPE_EMAIL										= 8;
var PARAM_TYPE_POSTAL_CODE									= 9;
var PARAM_TYPE_ADDRESS										= 10;
var PARAM_TYPE_PHONE										= 11;
var PARAM_TYPE_MOBILE_PHONE									= 12;
var PARAM_TYPE_IPV4_ADDRESS									= 13;
var PARAM_TYPE_DOMAIN										= 14;
var PARAM_TYPE_CLIENTID										= 15;
var PARAM_TYPE_FILEID										= 16;
var PARAM_TYPE_DATE											= 17;
var PARAM_TYPE_DATETIME										= 18;
var PARAM_TYPE_SERIAL_DATE									= 19;
var PARAM_TYPE_SERIAL_DATETIME								= 20;
var PARAM_TYPE_COMPANYID									= 21;
var PARAM_TYPE_LICENCEID									= 22;
var PARAM_TYPE_DEPT_CODE									= 23;
var PARAM_TYPE_NOTICEID										= 24;
var PARAM_TYPE_SEARCHID										= 25;
var PARAM_TYPE_SEARCH_KEYWORD								= 26;
var PARAM_TYPE_SERVER_VERSION								= 27;
var PARAM_TYPE_SOFTWARE_LICENCE_KEY							= 28;


//**************************************************************************************
// 입력 파라미터 유형별 최소/최대 길이 상수 선언
//**************************************************************************************
var PARAM_LEN_1												= 1;
var PARAM_LEN_4												= 4;
var PARAM_LEN_8												= 8;
var PARAM_LEN_16											= 16;
var PARAM_LEN_32											= 32;
var PARAM_LEN_64											= 64;
var PARAM_LEN_128											= 128;
var PARAM_LEN_256											= 256;
var PARAM_LEN_512											= 512;

var PARAM_ID_MIN_LEN										= 3;
var PARAM_ID_MAX_LEN										= 30;
var PARAM_PWD_MIN_LEN										= 8;
var PARAM_PWD_MAX_LEN										= 18;
var PARAM_PLAIN_PWD_MIN_LEN									= 1;
var PARAM_PLAIN_PWD_MAX_LEN									= 18;
var PARAM_NAME_MIN_LEN										= 1;
var PARAM_NAME_MAX_LEN										= 128;
var PARAM_EMAIL_MIN_LEN										= 1;
var PARAM_EMAIL_MAX_LEN										= 128;
var PARAM_POSTAL_CODE_MIN_LEN								= 5;
var PARAM_POSTAL_CODE_MAX_LEN								= 7;
var PARAM_ADDRESS_MIN_LEN									= 1;
var PARAM_ADDRESS_MAX_LEN									= 256;
var PARAM_DETAIL_ADDRESS_MIN_LEN							= 1;
var PARAM_DETAIL_ADDRESS_MAX_LEN							= 512;
var PARAM_PHONE_MIN_LEN										= 10;
var PARAM_PHONE_MAX_LEN										= 13;
var PARAM_MOBILE_PHONE_MIN_LEN								= 11;
var PARAM_MOBILE_PHONE_MAX_LEN								= 13;
var PARAM_SERIAL_DATE_MIN_LEN								= 8;
var PARAM_SERIAL_DATE_MAX_LEN								= 8;
var PARAM_SERIAL_DATETIME_MIN_LEN							= 14;
var PARAM_SERIAL_DATETIME_MAX_LEN							= 14;
var PARAM_DATE_MIN_LEN										= 10;
var PARAM_DATE_MAX_LEN										= 10;
var PARAM_DATETIME_MIN_LEN									= 19;
var PARAM_DATETIME_MAX_LEN									= 19;
var PARAM_FLAG_MIN_LEN										= 1;
var PARAM_FLAG_MAX_LEN										= 2;
var PARAM_IPV4_ADDRESS_MIN_LEN								= 7;
var PARAM_IPV4_ADDRESS_MAX_LEN								= 15;
var PARAM_DOMAIN_MIN_LEN									= 7;
var PARAM_DOMAIN_MAX_LEN									= 63;
var PARAM_NUMBER_MIN_LEN									= 1;
var PARAM_NUMBER_MAX_LEN									= 10;
var PARAM_FILE_PATH_MIN_LEN									= 1;
var PARAM_FILE_PATH_MAX_LEN									= 512;
var PARAM_SEARCH_KEYWORD_MIN_LEN							= 1;
var PARAM_SEARCH_KEYWORD_MAX_LEN							= 128;

var PARAM_COMPANYID_MIN_LEN									= 1;
var PARAM_COMPANYID_MAX_LEN									= 32;
var PARAM_LICENCEID_MIN_LEN									= 1;
var PARAM_LICENCEID_MAX_LEN									= 32;
var PARAM_DEPT_CODE_MIN_LEN									= 1;
var PARAM_DEPT_CODE_MAX_LEN									= 32;
var PARAM_JOB_PROCESSING_TYPE_MIN_LEN						= 1;
var PARAM_JOB_PROCESSING_TYPE_MAX_LEN						= 2;
var PARAM_RESULT_MIN_LEN									= 1;
var PARAM_RESULT_MAX_LEN									= 2;
var PARAM_PATTERNID_MIN_LEN									= 1;
var PARAM_PATTERNID_MAX_LEN									= 4;
var PARAM_NOTICEID_MIN_LEN									= 17;
var PARAM_NOTICEID_MAX_LEN									= 17;
var PARAM_NOTICE_TITLE_MIN_LEN								= 1;
var PARAM_NOTICE_TITLE_MAX_LEN								= 512;
var PARAM_NOTICE_CONTENTS_MIN_LEN							= 1;
var PARAM_NOTICE_CONTENTS_MAX_LEN							= 65535;
var PARAM_CLIENTID_MIN_LEN									= 17;
var PARAM_CLIENTID_MAX_LEN									= 64;
var PARAM_FILEID_MIN_LEN									= 1;
var PARAM_FILEID_MAX_LEN									= 64;
var PARAM_SEARCHID_MIN_LEN									= 15;
var PARAM_SEARCHID_MAX_LEN									= 15;
var PARAM_LOG_DATA_MIN_LEN									= 1;
var PARAM_LOG_DATA_MAX_LEN									= 4096;
var PARAM_TEXT_MIN_LEN										= 1;
var PARAM_TEXT_MAX_LEN										= 65535;

var PARAM_SERVER_VERSION_MIN_LEN							= 7;
var PARAM_SERVER_VERSION_MAX_LEN							= 10;

var PARAM_SOFTWARE_LICENCE_KEY_MIN_LEN						= 1;
var PARAM_SOFTWARE_LICENCE_KEY_MAX_LEN						= 128;


resultMessage = function() {
	this.message = "";
};

isValidParam = function(objElement, paramType, paramName, minLength, maxLength, objTips) {
	var objResultMessage = new resultMessage();
	var result = false;

	if (!$.isEmptyObject(objElement)) {
		if ((objElement.val().length < minLength) || (objElement.val().length > maxLength)) {
			objResultMessage.message = "[" + paramName + "] 의 길이는 " + minLength + "~" + maxLength + " 자리여야 합니다.";
			//objElement.addClass('ui-state-error');
			objElement.focus();
			if ((typeof(objTips) == 'object') && (objTips != null)) {
				updateTips(objTips, objResultMessage.message);
			} else {
				if (paramType == PARAM_TYPE_SEARCH_KEYWORD ) {
					displayAlertDialog("입력 파라미터 오류", "유효하지 않은 검색어 입니다.", objResultMessage.message);
				} else {
					displayAlertDialog("입력 파라미터 오류", "유효하지 않은 입력 파라미터 입니다.", objResultMessage.message);
				}
			}
		} else {
			result = checkParam(paramType, paramName, objElement.val(), objResultMessage);
			if (!result) {
				//objElement.addClass('ui-state-error');
				objElement.focus();
				if (!$.isEmptyObject(objTips)) {
					updateTips(objTips, objResultMessage.message);
				} else {
					if (paramType == PARAM_TYPE_SEARCH_KEYWORD ) {
						displayAlertDialog("입력 파라미터 오류", "유효하지 않은 검색어 입니다.", objResultMessage.message);
					} else {
						displayAlertDialog("입력 파라미터 오류", "유효하지 않은 입력 파라미터 입니다.", objResultMessage.message);
					}
				}
			} else {
				if (objElement.hasClass('ui-state-error'))
					objElement.removeClass('ui-state-error');
				if (!$.isEmptyObject(objTips)) {
					objTips.hide();
				}
			}
		}
	}

	return result;
};

checkParam = function(paramType, paramName, paramData, objResultMessage) {
	var regExPattern;
	var errorMessage;
	var result;

	switch (paramType) {
		case PARAM_TYPE_NUMBER :
			regExPattern = /^[0-9,]*$/;
			errorMessage = "[" + paramName + "]은(는) 기호없는 숫자로만 입력해 주세요.";
			break;
		case PARAM_TYPE_SIGNED_INTEGER :
			regExPattern = /^-?[0-9,]*$/;
			errorMessage = "[" + paramName + "]은(는) 부호있는 정수로만 입력해 주세요.";
			break;
		case PARAM_TYPE_ALPHANUMERIC :
			regExPattern = /^[A-Za-z0-9]*$/;
			errorMessage = "[" + paramName + "]은(는) 영문자/숫자로만 입력해 주세요.";
			break;
		case PARAM_TYPE_BASE64 :
			regExPattern = new RegExp("^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{4})$");
			errorMessage = "[" + paramName + "]은(는) 해당 포멧이 아닙니다.";
			break;
		case PARAM_TYPE_ID :
			regExPattern = /^[A-Za-z0-9]([A-Za-z0-9_\-])+$/;
			errorMessage = "[" + paramName + "]은(는) 영문자/숫자/'_'/'-' 의 조합으로 구성되어야 합니다.";
			break;
/*			
		case PARAM_TYPE_PWD :
			if (paramData.length >= 10) {
				regExPattern = /^(?=.*[a-zA-Z])(?=.*[\d])[a-zA-Z0-9!@#$^*]{10,18}$/;
			} else {
				regExPattern = /^(?=.*[a-zA-Z])(?=.*[\d])(?=.*[!@#$^*])[a-zA-Z0-9!@#$^*]{8,18}$/;
			}
			errorMessage = "[" + paramName + "]은(는) 8~18 자리 영문자/숫자/사용가능 특수문자가 한자리 이상 포함된 조합, 또는 10-18 자리 영문자/숫자가 한자리 이상 포함된 조합으로 구성되어야 합니다. (사용가능 특수문자 : '!', '@', '#', '$', '^', '*')";
			break;
*/
		case PARAM_TYPE_NAME :
			regExPattern = /^[A-Za-z0-9\u3131-\u318E\uAC00-\uD7A3\s\(\)_\-\.]*$/;
			errorMessage = "[" + paramName + "]은(는) 한글, 영문자, 숫자, 공백, 사용가능 특수문자로만 구성되어야 합니다. (사용가능 특수문자 : '(', ')', '_', '-', '.')";
			break;
		case PARAM_TYPE_ORDER_BY_NAME :
			regExPattern = /^[A-Za-z0-9\s,]*$/;
			errorMessage = "[" + paramName + "]은(는) 영문자, 숫자, 공백, ',' 로만 구성되어야 합니다.";
			break;
		case PARAM_TYPE_EMAIL :
			regExPattern = /^[-a-z0-9~!$%^&*_=+}{\'?]+(\.[-a-z0-9~!$%^&*_=+}{\'?]+)*@([a-z0-9_][-a-z0-9_]*(\.[-a-z0-9_]+)*\.(aero|arpa|biz|com|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?$/i;
			errorMessage = "[" + paramName + "]에 올바른 EMAIL을 입력해 주세요.";
			break;
		case PARAM_TYPE_POSTAL_CODE :
			regExPattern = /^[0-9\-]*$/;
			errorMessage = "[" + paramName + "]은(는) 숫자, 특수문자로만 구성되어야 합니다. (사용가능 특수문자 : '-')";
			break;
		case PARAM_TYPE_ADDRESS :
			regExPattern = /^[A-Za-z0-9\u3131-\u318E\uAC00-\uD7A3\s\.,_\-\(\)]*$/;
			errorMessage = "[" + paramName + "]은(는) 한글/영문자, 숫자, 공백, 사용가능 특수문자로만 구성되어야 합니다. (사용가능 특수문자 : '.', ',', '_', '-', '(', ')')";
			break;
		case PARAM_TYPE_PHONE :
			regExPattern = /^(070|02|031|032|033|041|042|043|044|051|052|053|054|055|061|062|063|064)-\d{3,4}-\d{4}$/;
			errorMessage = "[" + paramName + "]은(는) \"02-1234-1234\" 의 형식으로 입력해 주세요.";
			break;
		case PARAM_TYPE_MOBILE_PHONE :
			regExPattern = /^(010|011|016|017|018|019)-\d{3,4}-\d{4}$/;
			errorMessage = "[" + paramName + "]은(는) \"010-1234-1234\" 의 형식으로 입력해 주세요.";
			break;
		case PARAM_TYPE_IPV4_ADDRESS :
			regExPattern = /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
			errorMessage = "[" + paramName + "]에 숫자로된 올바른 IP주소를 입력해 주세요.";
			break;
		case PARAM_TYPE_DOMAIN :
			regExPattern = /^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}$|^localhost$|^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
			errorMessage = "[" + paramName + "]에 올바른 도메인(IP)을 입력해 주세요.";
			break;
		case PARAM_TYPE_CLIENTID :
			regExPattern = /^([0-9A-F]{2}\:)+[0-9A-F]{2}$/;
			errorMessage = "[" + paramName + "]의 값은 올바른 형식이 아닙니다.";
			break;
		case PARAM_TYPE_FILEID :
			regExPattern = /^[A-Za-z0-9\-]*$/;
			errorMessage = "[" + paramName + "]의 값은 올바른 형식이 아닙니다.";
			break;
		case PARAM_TYPE_DATE :
			regExPattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;
			errorMessage = "[" + paramName + "]은(는) \"2000-01-01\" 의 형식으로 입력해 주세요.";
			break;
		case PARAM_TYPE_DATETIME :
			regExPattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])\s[0-2][0-9]:[0-5][0-9]:[0-5][0-9]$/;
			errorMessage = "[" + paramName + "]은(는) \"2000-01-01 12:30:00\" 의 형식으로 입력해 주세요.";
			break;
		case PARAM_TYPE_SERIAL_DATE :
			regExPattern = /^(19|20)\d{2}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[0-1])$/;
			errorMessage = "[" + paramName + "]은(는) \"20000101\" 의 형식으로 입력해 주세요.";
			break;
		case PARAM_TYPE_SERIAL_DATETIME :
			regExPattern = /^(19|20)\d{2}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[0-1])[0-2][0-9][0-5][0-9][0-5][0-9]$/;
			errorMessage = "[" + paramName + "]은(는) \"20000101123000\" 의 형식으로 입력해 주세요.";
			break;
		case PARAM_TYPE_COMPANYID :
			regExPattern = /^[A-Za-z0-9_\-]*$/;
			errorMessage = "[" + paramName + "]은(는) 영문, 숫자, 사용가능 특수문자로 구성되어야 합니다. (사용가능 특수문자: '_', '-')";
			break;
		case PARAM_TYPE_LICENCEID :
			regExPattern = /^[A-Za-z0-9_\-]*$/;
			errorMessage = "[" + paramName + "]은(는) 영문, 숫자, 사용가능 특수문자로 구성되어야 합니다. (사용가능 특수문자: '_', '-')";
			break;
		case PARAM_TYPE_DEPT_CODE :
			regExPattern = /^[A-Za-z0-9]*$/;
			errorMessage = "[" + paramName + "]은(는) 영문, 숫자, 사용가능 특수문자로 구성되어야 합니다. (사용가능 특수문자: '_', '-')";
			break;
		case PARAM_TYPE_NOTICEID :
			regExPattern = /^[A-Z]{3}(19|20)\d{2}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[0-1])[0-2][0-9][0-5][0-9][0-5][0-9]$/;
			errorMessage = "[" + paramName + "]의 값은 올바른 형식이 아닙니다.";
			break;
		case PARAM_TYPE_SEARCHID :
			regExPattern = /^[A-Z](19|20)\d{2}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[0-1])[0-2][0-9][0-5][0-9][0-5][0-9]$/;
			errorMessage = "[" + paramName + "]의 값은 올바른 형식이 아닙니다.";
			break;
		case PARAM_TYPE_SEARCH_KEYWORD :
			regExPattern = /^[A-Za-z0-9\u3131-\u318E\uAC00-\uD7A3\s_.\-\(\)]*$/;
			errorMessage = "[" + paramName + "] 검색어는 한글/영문자, 숫자, 공백, 사용가능 특수문자로만 구성되어야 합니다. (사용가능 특수문자 :  '.', '_', '-', '(', ')')";
			break;
		case PARAM_TYPE_SERVER_VERSION :
			regExPattern = /^[1-9]\.[0-9]\.[0-9]\.\d{1,4}$/;
			errorMessage = "[" + paramName + "]은(는) \"x.x.x.x\" 의 형식으로 입력해 주세요. (처음 x는 1-9, 나버지 x는 0-9)";
			break;
		case PARAM_TYPE_SOFTWARE_LICENCE_KEY :
			regExPattern = /^[A-Za-z0-9\-]*$/;
			errorMessage = "[" + paramName + "]은(는) 영문자, 숫자, 사용가능 특수문자로만 구성되어야 합니다. (사용가능 특수문자 : '-')";
			break;
		default:
			regExPattern = /^[A-Za-z0-9\u3131-\u318E\uAC00-\uD7A3\s\.,_\-\(\)]*$/;
			errorMessage = "[" + paramName + "]은(는) 한글/영문자, 숫자, 공백, 사용가능 특수문자로만 구성되어야 합니다. (사용가능 특수문자 : '.', ',', '_', '-', '(', ')')";
	}

	if (paramType == PARAM_TYPE_PWD) {
		result = isValidPassword(paramData);
		errorMessage = "[" + paramName + "]는 \"영문 소문자/영문 대문자/숫자/사용가능 특수문자\"를 포함할 수 있으며, 8~18 자리 비밀번호는 최소 3 종류 이상, 10-18 자리 비밀번호는 최소 2 종류 이상 포함된 조합으로 구성되어야 합니다. (사용가능 특수문자 : '!', '@', '#', '$', '^', '*')";
	} else {
		result =  regExPattern.test(paramData);
	}

	if (!result) {
		objResultMessage.message = errorMessage;
	}

	return result;
};

isValidPassword = function(paramData) {
	var result = false;
	var includeTypeCount = 0;

	if (/^[a-zA-Z0-9!@#$^*]*$/.test(paramData)) {
		if (/^(?=.*?[a-z]).*$/.test(paramData)) includeTypeCount++;
		if (/^(?=.*?[A-Z]).*$/.test(paramData)) includeTypeCount++;
		if (/^(?=.*?[0-9]).*$/.test(paramData)) includeTypeCount++;
		if (/^(?=.*?[!@#$^*]).*$/.test(paramData)) includeTypeCount++;

		if (paramData.length >= 10) {
			if (includeTypeCount >= 2) result = true;
		} else {
			if (includeTypeCount >= 3) result = true;
		}
	}

	return result;
};

updateTips = function(objTips, message) {
	objTips.find('#validateMsg').text(message);
	objTips.addClass('ui-state-error');
	objTips.show();
};

