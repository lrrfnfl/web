// DO NOT put these inside $(document).ready or they are not 'global'
var outerLayout, innerDefaultLayout, innerMainLayout; 

var outerLayoutOptions = {
		name: 					"outerLayout"
	,	size:					"auto"
	,	resizable:				false
	,	closable:				false
	,	spacing_open:			0
	,	north__size:			92
	,	center__onresize:		resizeInnerLayout
	,	resizeWhileDragging:	true
	,	triggerEventsWhileDragging: false
	,	showOverflowOnHover:	true
	};

	var innerLayoutOptions = {
		center__paneSelector:	".inner-center" 
	,	west__paneSelector:		".inner-west" 
	,	east__paneSelector:		".inner-east" 
	,	spacing_open:			4  // ALL panes 
	,	spacing_closed:			4  // ALL panes 
	,	resizeWhileDragging:	true
	,	west__size:				.20 
	,	west__minSize:			200 
	,	west__maxSize:			.50 
	,	west__fxSpeed_open:		500
};

// EXAMPLES - customize default options
var outerMainLayoutOptions = outerLayoutOptions; // no extra settings
var outerDefaultLayoutOptions = $.extend( {}, outerLayoutOptions, { // customize...
	north__size:			92 
});
var outerMinLayoutOptions = $.extend( {}, outerLayoutOptions, { // customize...
	north__size:			56 
});
var innerDefaultLayoutOptions = $.extend( {}, innerLayoutOptions, { // customize...
	west__initHidden:		true
,	onresize_end:		function () { if (typeof(reloadDefaultLayout) === 'function') { reloadDefaultLayout(); } }
});
var innerMainLayoutOptions = $.extend( {}, innerLayoutOptions, { // customize...
	resizable:				true
,	closable:				true
,	west__size:				.32 
,	east__size:				.34
,	west__childOptions:	{
	size:					'auto'
,	resizable:				true
,	closable:				true
,	spacing_open:			4  // ALL panes 
,	spacing_closed:			4  // ALL panes 
,	north__size:			0
,	south__size:			'50%'
}
,	center__childOptions:	{
	size:					'auto'
,	resizable:				true
,	closable:				true
,	spacing_open:			4  // ALL panes 
,	spacing_closed:			4  // ALL panes 
,	north__size:			0
,	south__size:			'50%'
}
,	east__childOptions:	{
	size:					'auto'
,	resizable:				true
,	closable:				true
,	spacing_open:			4  // ALL panes 
,	spacing_closed:			4  // ALL panes 
,	north__size:			.30
,	south__size:			.35
}
,	onresize_end:		function () { if (typeof(reloadMainLayout) === 'function') { reloadMainLayout(); } }
,	onclose:		function () { if (typeof(reloadMainLayout) === 'function') { reloadMainLayout(); } }
});

function toggleInnerLayout () {
	if (innerDefaultLayout && $("#innerDefault").is(":visible"))
		showInnerLayout("innerMain");
	else
		showInnerLayout("innerDefault");
	return false; // cancel hyperlink
}

function showInnerLayout ( name ) {
	var altName = name=="innerDefault" ? "innerMain" : "innerDefault";
	$( "#"+ altName ).hide();	// hide OTHER layout container
	$( "#"+ name ).show();		// show THIS layout container
	// if layout is already initialized, then just resize it
	if (window[ name +"Layout" ])
		window[ name +"Layout" ].resizeAll();
	// otherwise init the layout the FIRST TIME
	else
		window[ name +"Layout" ] = $("#"+ name).layout( window[ name +"LayoutOptions" ] ); // use per-layout options
		//window[ name +"Layout" ] = $("#"+ name).layout( innerLayoutOptions ); // use common options

	resizeInnerLayout();
};

function resizeInnerLayout () {
	if (innerDefaultLayout && $("#innerDefault").is(":visible")) {
		innerDefaultLayout.resizeAll();
	} else if (innerMainLayout && $("#innerMain").is(":visible")) {
		innerMainLayout.resizeAll();
	}
};
