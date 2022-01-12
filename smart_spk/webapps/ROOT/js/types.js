loadTypeList = function(typeName) {
	var htType = new Hashtable();

	var postData = getRequestTypeListParam(typeName);

	$.ajax({
		type: "POST",
		url: "/CommandService",
		data: $.param({sendmsg : postData}),
		dataType: "xml",
		cache: false,
		async: false,
		beforeSend:function(x){
			if(x && x.overrideMimeType) {
				x.overrideMimeType("application/xml;charset=UTF-8");
			}
		},
		success: function(data, textStatus, jqXHR) {
			if ($(data).find('errorcode').text() == "0000") {
				$(data).find('type').each(function() {
					var typeValue = $(this).find('value').text();
					var typeName = $(this).find('name').text();
					htType.put(typeValue, typeName);
				});
			}
		},
		error: function(jqXHR, textStatus, errorThrown) {
			if (jqXHR.status != 0 && jqXHR.readyState != 0) {
				alert(textStatus + " "+jqXHR.statusText + "(" + jqXHR.status + ")");
			}
		}
	});

	return htType;
};

fillDropdownList = function(objTarget, htType, selectedValue, initName) {

	objTarget.empty();

	if ( initName != null ) {
		objTarget.append('<option value="" selected>' + initName + '</option>');
	}

	if (htType != null) {
		if (!htType.isEmpty()) {
			htType.each( function(value, name) {
				if (value == selectedValue) {
					objTarget.append('<option value="' + value + '" selected>' + name + '</option>');
				} else {
					objTarget.append('<option value="' + value + '">' + name + '</option>');
				}
			});
		}
	}
};

fillOptionList = function(objTarget, objName, htType, selectedValue) {

	var innerHtml = "";
	
	if (htType != null) {
		if (!htType.isEmpty()) {
			htType.each( function(value, name) {
				if (value == selectedValue) {
					innerHtml += '<label class="radio"><input type="radio" name="' + objName + '" value="' + value + '" checked>' + name + '</label>';
				} else {
					innerHtml += '<label class="radio"><input type="radio" name="' + objName + '" value="' + value + '">' + name + '</label>';
				}
				innerHtml += '&nbsp;&nbsp;&nbsp;&nbsp;';
			});
		}
	}

	objTarget.html(innerHtml);
};

