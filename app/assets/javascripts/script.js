$('document').ready(function(){

	// Init Tabs
	$('#nav-tabs a').click(function (e) {
		e.preventDefault()
		$(this).tab('show')
	});

	// Init livevalidate
	$('.livevalidate').livevalidate()

});
