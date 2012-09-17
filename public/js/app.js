// create top-level namespace
var Photon = (Photon || { });

// global functions go here
Photon.Global = (Photon.Global || { });

Photon.Global.onDeleteLink = function(event) {
  var form   = $("<form>");
  var hidden = $("<input>");

  event.preventDefault();

  form.attr("action", $(this).attr("href"));
  form.attr("method", "POST");
  form.attr("accept-charset", "UTF-8");

  hidden.attr("type", "hidden");
  hidden.attr("name", "_method");
  hidden.attr("value", "DELETE");

  $("body").append(form);
  form.append(hidden);

  form.submit();

  return false;
}

$(document).ready(function() {
  $('a[data-method=delete]').click(Photon.Global.onDeleteLink);
});
