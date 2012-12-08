var Photon = (Photon || { });

Photon.Photos = (Photon.Photos || { });

Photon.Photos.Upload = function() {

  function progressFor(index) {
    return $('div.progress-proto').filter(function() {
      return $(this).data('index') == index;
    });
  }

  function setProgress(index, percent) {
    progressFor(index).find('div.bar').css({ width : percent + '%' });
  }

  var self = {
    init : function() {
      return self;
    },

    Queued : function(name, index) {
      var container = $('div.progress-container');
      var progress  = container.find('div.progress-proto.orig').clone();

      container.removeClass('hidden');

      progress.data('index', index);
      progress.removeClass('hidden');
      progress.removeClass('orig');

      progress.find("span").html("<strong>" + name + "</strong>");

      container.append(progress);
    },

    Started: function(name, index) {
      console.log('Started: ', name, index);
      setProgress(index, 0);
    },

    Complete : function(name, index, code) {

      console.log("Complete: ", name, index, code);

      $("li.empty-album").remove();

      console.log("progressFor(" + index + "): ", progressFor(index));

      progressFor(index).remove();

      $('[data-refresh]').trigger('refresh', "/" + code + "?thumb=true");
    },

    AllComplete: function() {
      $('div.progress-container').addClass('hidden');
    },

    Progress : function(name, index, percent) {
      setProgress(index, percent);
    }
  };

  return self.init();
};

$(document).ready(function() {
  var upload = new Photon.Photos.Upload();
  $('form.photo-upload').multiUpload({
    queued      : upload.Queued,
    started     : upload.Started,
    complete    : upload.Complete,
    allComplete : upload.AllComplete,
    progress    : upload.Progress
  });
})
