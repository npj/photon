var Photon = (Photon || { });

Photon.Photos = (Photon.Photos || { });

Photon.Photos.Upload = function() {

  function progressFor(index) {
    return $('div.progress-proto[data-index="' + index + '"]');
  }

  function setProgress(index, percent) {
    progressFor(index).find('div.bar').css({ width : percent + '%' });
  }

  var self = {
    init : function() {
      return self;
    },

    Started : function(name, index) {
      var container = $('div.progress-container');
      var progress  = container.find('div.progress-proto.orig').clone();

      container.removeClass('hidden');

      progress.attr('data-index', index);
      progress.removeClass('hidden');
      progress.removeClass('orig');

      progress.find("span").html("<strong>" + name + "</strong>");

      container.append(progress);
    },

    Complete : function(name, index, code) {

      $("li.empty-album").remove();

      progressFor(index).remove();

      $('[data-refresh]').trigger('refresh', "/" + code + "?thumb=true");

      if($('div.progress[data-index]').length == 0) {
        $('div.progress-container').addClass('hidden');
      }
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
    started  : upload.Started,
    complete : upload.Complete,
    progress : upload.Progress
  });
})
