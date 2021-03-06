/**
 * ui 관련 Util
 */

/**
 * USAGE: 
 * $('MyTabSelector').disableTab(0);        // Disables the first tab
 * $('MyTabSelector').disableTab(1, true);  // Disables & hides the second tab
 * $('MyTabSelector').enableTab(1);         // Enables & shows the second tab
 * 
 * For the hide option to work, you need to define the following css
 *   li.ui-state-default.ui-state-hidden[role=tab]:not(.ui-tabs-active) {
 *     display: none;
 *   }
 */
$.fn.disableTab = function (tabIndex, hide) {

	// Get the array of disabled tabs, if any
	var disabledTabs = this.tabs("option", "disabled");

	if ($.isArray(disabledTabs)) {
		var pos = $.inArray(tabIndex, disabledTabs);

		if (pos < 0) {
			disabledTabs.push(tabIndex);
		}
	}
	else {
		disabledTabs = [tabIndex];
	}

	this.tabs("option", "disabled", disabledTabs);

	if (hide === true) {
		$(this).find('li:eq(' + tabIndex + ')').addClass('ui-state-hidden');
	}

	// Enable chaining
	return this;
};

$.fn.enableTab = function (tabIndex) {

	// Remove the ui-state-hidden class if it exists
	$(this).find('li:eq(' + tabIndex + ')').removeClass('ui-state-hidden');

	// Use the built-in enable function
	this.tabs("enable", tabIndex);

	// Enable chaining
	return this;

};

resizeDialogElement = function(objDialog, objElement) {

	var elementHeight;
	if (objElement.is('.scroll-table')) {
		elementHeight = objElement.find('.st-body').height();
	} else {
		elementHeight = objElement.height();
	}
	var contentsHeight = objDialog.find(".dialog-contents").outerHeight(true);
	var elementNewHeight = elementHeight + (objDialog.height() - contentsHeight);

	if (objElement.is('.scroll-table')) {
		objElement.scrolltable('destroy');
		objElement.scrolltable({
			stripe: true,
			oddClass: 'odd',
			height: elementNewHeight
		});
	} else if (objElement.is('.treeview-pannel')) {
		objElement.height(elementNewHeight);
	} else {
		objElement.height(elementNewHeight);
	}
};
