(function($) {

  function UploadQueue(form, options) {

    var url       = options.url;
    var method    = options.method;
    var callbacks = options.callbacks;

    var uploaded = 0;
    var files    = [ ];

    function upload(file) {

      var xhr = new XMLHttpRequest();

      xhr.open(method, url, true);

      if(callbacks.started) {
        xhr.onloadstart = function() {
          callbacks.started(file.name, uploaded);
        }
      }

      if(callbacks.progress) {
        xhr.upload.onprogress = function(e) {
          if(e.lengthComputable) {
            callbacks.progress(file.name, uploaded, (e.loaded / e.total) * 100);
          }
        }
      }

      xhr.onload = function() {
        if(callbacks.complete) {
          callbacks.complete(file.name, uploaded, this.responseText);
        }
        ++uploaded;
        form.trigger('next.upload-queue');
      }


      xhr.setRequestHeader('Content-type', file.type);
      xhr.setRequestHeader('X_FILE_NAME', file.name);
      xhr.send(file);
    }

    var self = {
      add: function(file) {
        var index = files.length;
        files.push(file);
        if(callbacks.queued) {
          callbacks.queued(file.name, index);
        }
      },

      next: function() {
        if(files.length > 0) {
          upload(files.shift());
        }
        else if(callbacks.allComplete) {
          callbacks.allComplete();
        }
      },

      start: function() { form.trigger('next.upload-queue'); }
    };

    form.data('upload-queue', this);
    form.on('next.upload-queue', self.next);

    return self;
  }

  $.fn.multiUpload = function(options) {

    function submit(e) {

      var form  = $(this);
      var input = $(this).find('input[type="file"]');

      var queue = new UploadQueue(form, {
        url: form.attr('action'),
        method: form.attr('method'),
        callbacks: {
          queued:      options.queued,
          started:     options.started,
          progress:    options.progress,
          complete:    options.complete,
          allComplete: options.allComplete
        }
      });

      e.preventDefault();

      if(input.length > 0) {
        $.each(input.get(0).files, function(index, file) {
          queue.add(file);
        });
      }

      queue.start();

      return false;
    }

    return this.each(function() {
      $(this).submit(submit);
    });
  };
})(jQuery);
