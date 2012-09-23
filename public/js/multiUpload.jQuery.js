(function($) {

  $.fn.multiUpload = function(options) {

    function upload(file, url, method, index) {

      var xhr = new XMLHttpRequest();

      xhr.open(method, url, true);

      if(options && options.started) {
        xhr.onloadstart = function() {
          options.started(file.name, index);
        }
      }

      if(options && options.complete) {
        xhr.onload = function() {
          options.complete(file.name, index);
        }
      }

      if(options && options.progress) {
        xhr.upload.onprogress = function(e) {
          if(e.lengthComputable) {
            options.progress(file.name, index, (e.loaded / e.total) * 100);
         }
       }
      }

      xhr.setRequestHeader('Content-type', file.type);
      xhr.setRequestHeader('X_FILE_NAME', file.name);
      xhr.send(file);
    }

    function submit(e) {
      var form  = $(this);
      var input = $(this).find('input[type=file]');

      e.preventDefault();

      if(input.length > 0) {
        $.each(input, function(i, input) {
          $.each(input.files, function(index, file) {
            upload(file, $(form).attr("action"), $(form).attr("method"), index);
          })
        });
      }

      return false;
    }

    return this.each(function() {
      $(this).submit(submit);
    });
  };
})(jQuery);
