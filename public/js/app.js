// create top-level namespace
var Photon = (Photon || { });

// global functions go here
Photon.Global = (Photon.Global || { });

Photon.Global.onMethodLink = function(event) {
  var form    = $("<form>");
  var hidden  = $("<input>");
  var method  = $(this).data('method').toUpperCase();
  var conf    = $(this).data('confirm');

  event.preventDefault();

  if(!conf || (conf && confirm(conf))) {
    form.attr("action", $(this).attr("href"));
    form.attr("method", method);
    form.attr("accept-charset", "UTF-8");

    hidden.attr("type", "hidden");
    hidden.attr("name", "_method");
    hidden.attr("value", method);

    $("body").append(form);
    form.append(hidden);

    form.submit();
  }

  return false;
};

Photon.Global.onRefresh = function(event, fragment) {

  var el       = $(this);
  var url      = el.data('refresh') + (fragment || "");
  var strategy = el.data('strategy');

  $.get(url, function(response) {
    if(strategy == 'replace') {
      el.html(response);
    }
    else if(strategy == 'append') {
      el.append(response);
    }
  });
};

$(document).ready(function() {
  $('a[data-method]').click(Photon.Global.onMethodLink);
  $('[data-refresh]').on('refresh', Photon.Global.onRefresh);
  $('.help').tooltip();
});
