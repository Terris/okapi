// HANDLE RESPONSE FROM STRIPE
var stripeResponseHandler = function(status, response) {
  var $form = $("#stripe-form");
  if (response.error) {
    // Show the errors on the form
    $form.find('.payment-errors').html("<p>" + response.error.message + "</p>").addClass('mod alert alert-error');
    $form.find('input#submit-btn').prop('disabled', false);
  } else {
    // token contains id, last4, and card type
    var token = response.id;
    // Insert the token into the form so it gets submitted to the server
    $form.append($('<input type="hidden" name="stripeToken" />').val(token));
    // and submit
    $form.get(0).submit();
  }
};

$('document').ready(function(){
  
  // Handle Charge Form
  $('#stripe-form').submit(function(event) {
    var $form = $(this);

    // Disable the submit button to prevent repeated clicks
    $form.find('input#submit-btn').prop('disabled', true);

    // Get and split month/year fields
    var exp = $form.find('input#monthyear').val().replace(" / ", "/").split("/");

    // Add exp[month] to Month field
    $form.find('input#month').val(exp[0]);

    // Add exp[year] to Month field
    $form.find('input#year').val(exp[1]);

    console.log(exp)

    // Create Stripe token and handle response
    Stripe.card.createToken($form, stripeResponseHandler);

    // Prevent the form from submitting with the default action
    return false;
  });

});