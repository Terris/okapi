// Plip - used to add/remove students from rosters
(function ( $ ) {
	$.fn.plip = function() {
		// Iterate for each trigger
		return this.each(function( index ) {
			var o = $(this);
		});
	};
}( jQuery ));

// Stripe Validations
(function ( $ ) {
	$.fn.livevalidate = function() {
		// Iterate for each trigger
		return this.each(function( index ) {
			var o = $(this);

			// Stripe Form formats with jQuery.Payment
			$('input#card_number').payment('formatCardNumber');
			$('input#monthyear').payment('formatCardExpiry');
			$('input#cvc').payment('formatCardCVC');

		});
	};
}( jQuery ));