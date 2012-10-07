$(document).ready(function() {
  var editable = $('.title.editable');
  editable.inlineEdit({
    input: {
      type: 'text',
      name: 'album[title]',
      css:  'input-small'
    },
    form: {
      action: "/a/" + editable.data('url'),
      method: 'PUT',
      css:    'form-inline no-margin'
    }
  });
});
