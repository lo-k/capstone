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

  // Upload Video Button Triggers Input Select

  $('#video-upload').click(function() {
    var fileInput = $('input:file');
    fileInput.click();
  });

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
      
      // if the file is not the correct size
      } else if (file_size < min_size || file_size > max_size) {
        console.log('wrong file size');
        console.log(file_size)
        $('.submit-upload').attr('disabled', 'disabled');
      
      // file is ok for upload
      } else {
        console.log('file okay');
        console.log(file_type);
        console.log(file_size);
        $('.submit-upload').removeAttr('disabled'); 
      }

  });

  // ---------------------- WEBCAM VIDEO ----------------------

  // config
  var videoWidth = 640;
  var videoHeight = 480;

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

  // record the video
  var recordVideo = function() { 
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
      $("#record_button").show();
    }, function(){})
  };

  // start recording
  var startRecording = function() {
    video_recorder.startRecording();

    // update the UI
    $("#play_button").hide();
    $("#upload_button").hide();
    $("video.recorder").show();
    $("#video-player").remove();
    $("#record_button").text("Stop recording");

    // toggle boolean
    recording = true;
  }

  // stop recording
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
    $("#players").append(video_player);

    // update UI
    $("video.recorder").hide();
    $("#play_button").show();
    $("#upload_button").show();
    $("#record_button").text("Start recording");

    // toggle boolean
    recording = false;
  }

  // handle recording
  $("#record_button").click(function(){
    if (recording) {
      stopRecording();
    } else {
      startRecording();
    }
  });

  // stop playback
  var stopPlayback = function() {
    // controlling
    video = $("#video-player")[0];
    video.pause();
    video.currentTime = 0;

    // update ui
    $("#play_button").text("Play");

    // toggle boolean
    playing = false;
  }

  // start playback
  var startPlayback = function() {
    video = $("#video-player")[0];
    video.play();
    $("#video-player").bind("ended", stopPlayback);

    // Update UI
    $("#play_button").text("Stop");

    // toggle boolean
    playing = true;
  }

  $('#record-video').click(function() {
    $('video.recorder').show();
    recordVideo();
  })

  // handle playback
  $("#play_button").click(function(){
    if (playing) {
      stopPlayback();
    } else {
      startPlayback();
    }
  });

  // Upload button
  $("#upload_button").click(function(){
    var request = new XMLHttpRequest();

    request.onreadystatechange = function () {
      if (request.readyState == 4 && request.status == 200) {
        window.location.href = "/video/"+request.responseText;
      }
    };

    request.open('POST', "/upload");
    request.send(formData);
  });

  $('#turn-off').click(function() {
    stream.stop();
  })


})