(function($) {
  var formValidation = Class.extend({
    init: function(el) {
      this.el = el;
      this.submitEl = el.find('input[type="submit"]');
      this.blank = 0;
      this.events();
    },
    events: function() {
      this.submitEl.on('click', $.proxy(this.submit, this));
    },
    submit: function(e) {
      if (!this.formValidity()) e.preventDefault();
    },
    formValidity: function(e) {
      var validInputs = [],
          validTexts = [],
          self = this,
          els = this.el.find('input[type="text"], input[type="email"], input[type="password"], input[type="url"]'),
          textareas = this.el.find('textarea');
      if (els.length > 0) {
        validInputs = $.makeArray(els).map(function(el) {
          return self.processEachInput(el);
        });
      }
      if (textareas.length > 0) {
        validTexts = $.makeArray(textareas).map(function(el) {
          return self.processEachText(el);
        });
      }
      return validInputs.concat(validTexts).every(function(boolean) { return boolean });
    },
    processEachInput: function(el) {
      var valid, attr = $(el).attr('type');
      if (attr === 'text' || attr === 'password') {
        valid = this.checkText(el);
      } else if (attr === 'email') {
        valid = this.checkEmail(el.value);
      } else if (attr === 'url') {
        valid = this.checkUrl(el.value);
      }
      this.renderValidation($(el), !valid, attr);
      return valid;
    },
    processEachText: function(el) {
      valid = this.checkText(el);
      this.renderValidation($(el), !valid);
      return valid;
    },
    checkText: function(el) {
      return el.value.length > this.blank;
    },
    checkEmail: function(email) {
      var regex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      return regex.test(email);
    },
    checkUrl: function(url) {
      var regex = /^(ht|f)tps?:\/\/[a-z0-9-\.]+\.[a-z]{2,4}\/?([^\s<>\#%"\,\{\}\\|\\\^\[\]`]+)?$/
      return regex.test(url);
    },
    renderValidation: function (el, invalid, type) {
      el.siblings().remove();
      if (invalid) {
        el.closest('div.form-group').addClass('has-error');
        if (type === 'email') {
          el.after('<span class="help-block">not a valid email address</span>');
        } else if (type === 'url') {
          el.after('<span class="help-block">not a valid url</span>');
        } else if (type === 'text' || type === 'password') {
          el.after('<span class="help-block">can\'t be blank</span>');
        }
      } else {
        el.closest('div.form-group').removeClass('has-error');
      }
    }
  });

  $(document).ready(function () {
    var form = $('form[data-js="true"]');
    if (form.length > 0) new formValidation(form);
  });
}(jQuery));