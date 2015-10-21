// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require bootstrap-sprockets

$(document).ready( function() {

  var accepted_vid_formats = 
    [
      "video/avi",          // .avi
      "video/msvideo",      // .avi
      "video/x-msvideo",    // .avi
      "video/quicktime",    // .mov
      "video/mp4",          // .mp4
      "audio/mpeg",         // .mpg
      "audio/x-ms-wmv",     // .wmv
    ]

  $('input:file').change(function() {

      var empty = false;
      
      if ($('input[type="file"]').val() == '') {
        empty = true;
      };

      var file_type = $('input[type="file"]')[0].files[0].type
      var file_size = $('input[type="file"]')[0].files[0].size
      var max_size = 31457280
      var min_size = 8200000

      // if no file is selected
      if (empty) {
        $('.submit-upload').attr('disabled', 'disabled'); 

      // if the file is not the correct format
      } else if ($.inArray(file_type, accepted_vid_formats) < 0) {
        console.log('wrong file type');
        console.log(file_type);
        $('.submit-upload').attr('disabled', 'disabled');
        $('.error-message').html('Incorrect file type');
      
      // if the file is not the correct size
      } else if (file_size < min_size || file_size > max_size) {
        console.log('wrong file size');
        console.log(file_size)
        $('.submit-upload').attr('disabled', 'disabled');
        $('.error-message').html('Incorrect file size');
      
      // file is ok for upload
      } else {
        console.log('file okay');
        console.log(file_type);
        console.log(file_size);
        $('.submit-upload').removeAttr('disabled'); 
        $('.error-message').html('');
      }

  });

})