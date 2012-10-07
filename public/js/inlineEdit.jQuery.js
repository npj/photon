(function($) {

  $.fn.inlineEdit = function(options) {

    var before  = null;
    var changes = false;

    function makeInput(el) {
      return '<input class="' + options.css + '" type="' + options.input.type + '" name="' + options.input.name + '" value="' + el.html() + '">';
    }

    function makeForm(el) {

      var form = $('<form class="' + options.form.css + '" action="' + options.form.action + '" method="' + options.form.method + '"></form>');
      form.append('<input type="hidden" name="_method" value="' + options.form.method + '">');
      form.append(makeInput(el));

      before = el;
      el.replaceWith(form);

      return form;
    }

    function makeNormal(form) {
      form.replaceWith(before);
      before.click(inlineEdit);
    }

    function submit(event) {
      event.preventDefault();

      if(changes) {
        var form = $(this);
        $.ajax({
          type: options.form.method,
          data: $(this).serialize(),
          success: function(data) {
            before.html(data.title);
          },
          complete: function() {
            makeNormal(form);
          }
        });
      }
      else {
        makeNormal($(this));
      }
      return false;
    }

    function inlineEdit(event) {
      var form = makeForm($(this));

      form.find('input')
        .focus()
        .keyup(function() { changes = true; })
        .blur(submit);

      form.submit(submit);
    }

    return this.each(function() {
      $(this).click(inlineEdit);
    });
  };
})(jQuery);
