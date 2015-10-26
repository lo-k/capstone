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

  $('.submit-upload').hide();
  $("video.recorder").hide();
  $('.video-control-buttons').hide();

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

// ---------------------- UPLOADING A VIDEO ----------------------

  // "Upload Video" Button Triggers Input Select

  $('#video-upload').click(function() {
    var fileInput = $('input:file');
    fileInput.click();
  });

  // File Input Validations

  $('input:file').change(function() {

      var empty = false;
      
      if ($('input[type="file"]').val() == '') {
        empty = true;
      };

      var file_type = $('input[type="file"]')[0].files[0].type
      var file_size = $('input[type="file"]')[0].files[0].size
      var max_size = 31457280

      // if no file is selected
      if (empty) {
        $('.submit-upload').attr('disabled', 'disabled'); 
        $('.submit-upload').hide();

      // if the file is not the correct format
      } else if ($.inArray(file_type, accepted_vid_formats) < 0) {
        console.log('wrong file type');
        console.log(file_type);
        $('.submit-upload').attr('disabled', 'disabled');
        $('.error-message').html('Incorrect file type');
        $('.submit-upload').hide();
      
      // if the file is not the correct size
      } else if (file_size > max_size) {
        console.log('file too large');
        console.log(file_size)
        $('.submit-upload').attr('disabled', 'disabled');
        $('.error-message').html('File too large');
  
      // file is ok for upload
      } else {
        console.log('file okay');
        console.log(file_type);
        console.log(file_size);
        $('.submit-upload').removeAttr('disabled');
        $('.submit-upload').show(); 
        $('.error-message').html('');
      }

  });

// ---------------------- WEBCAM VIDEO ----------------------

  // config
  var videoWidth = 440;
  var videoHeight = 280;

  // setup
  var stream;
  var video_recorder = null;
  var recording = false;
  var playing = false;
  var formData = null;

  // set the video options
  var videoOptions = {
    type: "video",
    video: {
      width: videoWidth,
      height: videoHeight
    },
    canvas: {
      width: videoWidth,
      height: videoHeight
    }
  };

  var setUpVideo = function() { 
    navigator.getUserMedia({audio: false, video: { mandatory: {}, optional: []}}, function(pStream) {

      stream = pStream;
      // setup video
      video = $("video.recorder")[0];

      video.src = window.URL.createObjectURL(stream);
      video.width = videoWidth;
      video.height = videoHeight;

      // init recorder
      video_recorder = RecordRTC(stream, videoOptions);

      // update UI
      $("video.recorder").show();
      $('.video-control-buttons').show();
    }, function(){})
  };

  var startRecording = function() {
    video_recorder.startRecording();

    // update the UI
    $("#play-button").hide();
    $("#upload-button").hide();
    $("#video-player").remove();
    $("#record-button").children('h4').text("Stop recording");

    // toggle boolean
    recording = true;
  }

  var stopRecording = function() {
    video_recorder.stopRecording();

    // set form data
    formData = new FormData();
    var video_blob = video_recorder.getBlob();
    formData.append("video", video_blob);

    // add player
    var video_player = document.createElement("video");
    video_player.id = "video-player";
    video_player.src = URL.createObjectURL(video_blob);
    video_player.controls = "controls";
    $("#player").append(video_player);

    // update UI
    $("video.recorder").hide();
    $("#play-button").show();
    $("#upload-button").show();
    $("#record-button").text("Start recording");

    // toggle boolean
    recording = false;
  }

  var startPlayback = function() {
    video = $("#video-player")[0];
    video.play();
    $("#video-player").bind("ended", stopPlayback);

    // Update UI
    $("#play-button").text("Stop");

    // toggle boolean
    playing = true;
  }

  var stopPlayback = function() {
    video = $("#video-player")[0];
    video.pause();
    video.currentTime = 0;

    // update ui
    $("#play-button").text("Play");

    // toggle boolean
    playing = false;
  }


// Event Handlers ----------------------------------

  // Set up video stream
  $('#video-capture').click(function() {
    setUpVideo();
  });

  // Start/Stop recording
  $('#record-button').click(function() {
    if (recording) {
      stopRecording();
    } else {
      startRecording();
    }
  });

  // Play back recorded video
  $("#play-button").click(function(){
    if (playing) {
      stopPlayback();
    } else {
      startPlayback();
    }
  });

  // Upload video
  $("#upload-button").click(function(){
    var request = new XMLHttpRequest();

    request.onreadystatechange = function () {
      if (request.readyState == 4 && request.status == 200) {
        window.location.href = "/video/"+request.responseText;
      }
    };

    request.open('POST', "/upload");
    request.send(formData);
  });

  // Turn off camera (resets everything also)
  $('#turn-off').click(function() {
    stream.stop();
  })
})