(function($) {
  var formValidation = Class.extend({
    init: function(el) {
      this.el = el;
      this.submitEl = el.find('input[type="submit"]');
      this.minPassword = 6;
      this.minText = 4;
      this.events();
    },
    events: function() {
      this.submitEl.on('click', $.proxy(this.submit, this));
    },
    submit: function(e) {
      var validPassword = this.checkPassword(),
          validText = this.checkText(),
          validEmail = this.checkEmail();
      if (!validPassword || !validText || !validEmail) e.preventDefault();
    },
    checkPassword: function() {
      var self = this,
          els = this.el.find('input[type="password"]');
      return $.makeArray(els).every(function(el) {
        var valid = el.value.length >= self.minPassword;
        self.renderValidation(el, valid);
        return valid;
      });
    },
    checkText: function() {
      var self = this,
          els = this.el.find('input[type="text"]');
      return $.makeArray(els).every(function(el) {
        var valid = el.value.length >= self.minText;
        self.renderValidation(el, valid);
        return valid;
      });
    },
    checkEmail: function() {
      var self = this,
          els = this.el.find('input[type="email"]');
      return $.makeArray(els).every(function(el) {
        var valid = self.emailTest(el.value);
        self.renderValidation(el, valid);
        return valid;
      });
    },
    emailTest: function(email) {
      var regex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      return regex.test(email);
    },
    renderValidation: function (el, valid) {
      if (!valid) {
        $(el).closest('div.form-group').addClass('has-error');
      } else {
        $(el).closest('div.form-group').removeClass('has-error');
      }
    }
  });

  $(document).ready(function () {
    var form = $('form[data-js-validate="true"]');
    if (form.length > 0) new formValidation(form);
  });
}(jQuery));