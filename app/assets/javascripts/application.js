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

// ---------------------- VIDEO SETUP ----------------------

  $('.submit-upload').hide();
  $("video.recorder").hide();
  
  // hide all buttons
  $('#record-button').hide();
  $('#stop-recording-button').hide();
  $('#upload-button').hide();
  $('#cancel-button').hide();

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

// ------------------- MOBILE DISPLAY CHANGES ---------------

  var mobile = onMobileDevice();

  if (mobile) {
    $('#video-upload').children('h4').html("Upload or Take a Video");
    $('#video-capture').hide();
  }

  function onMobileDevice() { 
   if( navigator.userAgent.match(/Android/i)
   || navigator.userAgent.match(/webOS/i)
   || navigator.userAgent.match(/iPhone/i)
   || navigator.userAgent.match(/iPad/i)
   || navigator.userAgent.match(/iPod/i)
   || navigator.userAgent.match(/BlackBerry/i)
   || navigator.userAgent.match(/Windows Phone/i)
   ){
      return true;
    }
   else {
      return false;
    }
  }

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
  var videoWidth = 380;
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
      $("video.recorder").removeAttr("controls");

      video.src = window.URL.createObjectURL(stream);
      video.width = videoWidth;
      video.height = videoHeight;

      // init recorder
      // video_recorder = RecordRTC(stream, videoOptions);

      // show player
      $("video.recorder").show();

      // show start and cancel buttons
      $('.video-control-buttons').show();
      $('#record-button').show();
      $('#cancel-button').show();

      // hide stop and upload buttons
      $('#stop-recording-button').hide();
      $('#upload-button').hide();

    }, function(){})
  };

  var startRecording = function() {
    // init recorder
    video_recorder = RecordRTC(stream, videoOptions);
    
    // remove prior recorded video if one is shown
    $("#video-player").remove();

    // display video recorder with timer controls
    $("video.recorder").show();
    $("video.recorder").attr("controls", "controls");
    
    // hide record button
    $("#record-button").hide();

    // show stop button
    $('#stop-recording-button').show();

    // start recording
    video_recorder.startRecording();
    recording = true;
  }

  var stopRecording = function() {
    // stop recording and turn off camera stream
    video_recorder.stopRecording();
    stream.stop();
    recording = false;

    // set form data
    formData = new FormData();
    var video_blob = video_recorder.getBlob();
    formData.append("video", video_blob);

    // add player for recorded video
    var video_player = document.createElement("video");
    video_player.id = "video-player";
    video_player.src = URL.createObjectURL(video_blob);
    video_player.controls = "controls";
    $("#player").append(video_player);

    // hide recorder
    $("video.recorder").hide();

    // hide stop button
    $("#stop-recording-button").hide();

    // show upload button
    $("#upload-button").show();
  }

  var cancelVideo = function() {
    // stop recording & turn off stream
    if (recording) {
      video_recorder.stopRecording();
      recording = false; 
    }

    stream.stop();

    // hide recorder and clear player
    $("video.recorder").hide();
    $("#video-player").remove();

    // hide all buttons
    $('#record-button').hide();
    $('#stop-recording-button').hide();
    $('#upload-button').hide();
    $('#cancel-button').hide();
  }

// Event Handlers ----------------------------------

  // Set up video stream
  $('#video-capture').click(function() {
    setUpVideo();
  });

  // Start recording
  $('#record-button').click(function() {
    startRecording();
  });

  // Stop recording
  $('#stop-recording-button').click(function() {
    stopRecording();
  });

  // Upload video (FROM SAMPLE DEMO)
  // $("#upload-button").click(function(){
  //   var request = new XMLHttpRequest();

  //   request.onreadystatechange = function () {
  //     if (request.readyState == 4 && request.status == 200) {
  //       window.location.href = "/video/"+request.responseText;
  //     }
  //   };

  //   request.open('POST', "/playlist");
  //   request.send(formData);
  // });

  var postVideo = function(form_data) {
    console.log(form_data);

    $.ajax({
      type: "POST",
      url: '/playlist',
      video: form_data,
      success: function(data) {
        console.log(data);
      }
    });
  }

  $('#upload-button').click(function() {
    // submit the video to upload_video controller application
    postVideo(formData);
  });

  $('#cancel-button').click(function() {
    cancelVideo();
  });
})