var Photon = (Photon || { });

Photon.Photos = (Photon.Photos || { });

Photon.Photos.Upload = function() {

  function progressFor(index) {
    return $('div.progress[data-index=' + index + ']');
  }

  function setProgress(index, percent) {
    console.log(progressFor(index));
    progressFor(index).find('div.bar').css({ width : percent + '%' });
  }

  var self = {
    init : function() {
      return self;
    },

    Started : function(name, index) {
      var container = $('div.progress-container');
      var progress  = container.find('div.progress-prototype').clone();

      progress.attr('data-index', index);
      progress.removeClass('hidden');
      progress.removeClass('progress-prototype');
      container.append(progress);
    },

    Complete : function(name, index) {
      var progress = progressFor(index)
      progress.addClass('progress-success');
      progress.removeClass('progress-info');
      progress.removeClass('progress-striped');
      progress.removeClass('active');
      //$('div[data-refresh]').refresh();
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
