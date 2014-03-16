(function($) {
  var form,
  sendStripeRequest = function () {
    Stripe.createToken({
      number: form.find('*[data-stripe="card-number"]').val(),
      cvc: form.find('*[data-stripe="card-cvc"]').val(),
      exp_month: form.find('*[data-stripe="card-expire-month"]').val(),
      exp_year: form.find('*[data-stripe="card-expire-year"]').val()
    }, stripeResponseHandler);
  },
  stripeResponseHandler = function(status, response) {
    if (response.error) {
      renderStripeError(response.error.message);
      form.find('input[type="submit"]').prop('disabled', false);
    } else {
      form.append($('<input type="hidden" name="stripeToken" />').val(response.id))
      form.get(0).submit();
    }
  },
  renderStripeError = function(message) {
    var section = $('section.content')
    if (section.find('.alert').length === 0) {
      section.prepend([
        '<div class="alert alert-danger">',
          '<div class="close" data-dismiss="alert">×</a></div>',
          '<div id="flash_danger">' + message + '</div>',
        '</div>'
      ].join(''));
    } else {
      section.find('.alert').html('<div class="close" data-dismiss="alert">×</a></div>' +
        '<div id="flash_danger">' + message + '</div>');
    }
  };

  $(document).ready(function () {
    form = $('form[data-stripe-form="true"]');
    new ld.myFlixFormValidation(form, function (e) {
      e.preventDefault();
      form.find('input[type="submit"]').prop('disabled', true);
      sendStripeRequest();
    });
  });
})(jQuery);