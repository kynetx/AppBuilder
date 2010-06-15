// WHEN DOM IS READY
$(document).ready(function() {
  $("textarea, #control-tray").height($(window).height()-90);
  $("textarea").width($(window).width()-55);
  
  $("textarea").tabby();
  
  // cookies!
  hideErrorTray = 0;
  checkAndSetDefoults();

  
  // control buttons
  $("img#save").click(saveApp);
  $("img#settings").click(changeSettings);
  
  // keyboard shortcuts
  $(document).bind('keydown', 'ctrl+s', saveApp);
  $(document).bind('keydown', 'ctrl+e', toggleErrorTray);
  lastkey = 0;
  $(document).bind('keydown', function(e) {
    var code = (e.keyCode ? e.keyCode : e.which);
    if( code == 224 ) {
      lastkey = 224; 
    } else if( code == 83 ) {
      if( lastkey == 224 ) {
        lastkey = 0;
        saveApp();
        return false;
      } else {
        lastkey = 0;
      }
    } else {
      lastkey = 0;
    }
  });
  
  window.onresize = resizeMe;
});

function resizeMe() {
  var width = $(window).width();
  width = (width < 700) ? 700 : width;
  $("textarea, #control-tray").height($(window).height()-90);
  $("textarea").width(width-55);
}

////////////////////////////
//  CONTROL TRAY FUNCTIONS
////////////////////////////
$("#close-error-tray, #warning").live("click", toggleErrorTray);

function saveApp() {
  // insert spinner here
  $("#saving").show();
  var appid = $("#editor").attr("appid");
  var krl = $("textarea").val();
  //console.log(krl);
  $.ajax({
    url: "/applications/" + appid + "/update",
    type: "PUT",
    data: {"krl":krl},
    success: function(msg) {
      $("#saving, #fail, #success, #warning, #error-tray, #close-error-tray").hide();
      $("#success").show().fadeOut(3000);
      $("#good").show();
      $("#unknown-error").html("");
      var currentTime = new Date();
      var hours = currentTime.getHours();
      hours = (hours < 10) ? "0"+hours : hours;
      var minutes = currentTime.getMinutes();
      minutes = (minutes < 10) ? "0"+minutes : minutes;
      $("#last-save").show().text(hours+":"+minutes);
    },
    error: function(x, s, e) {
      $("#saving, #success, #good").hide();
      $("#fail").show().fadeOut(3000);
      $("#warning").show();
      if(hideErrorTray == 0) {
        $("#error-tray, #close-error-tray").fadeIn();
      }
      $("unknown-error").html("");
      //console.log(x.responseText);
      if(!/^655:/.test(x.responseText)) {
        var kline = [];
        var kerror = [];
        var kmeta = [];
        var rt = x.responseText;
        var splitErrors = rt.split(/(Line [0-9]:)/);
        for( var i=1; i<splitErrors.length; i++) {
          // errors are in odd positions of array
          if( i % 2 != 0 ) {
            kline.push(splitErrors[i]);
          } else {
            var errorMeta = /([a-z,A-Z,\s]+:)(.*)/.exec(splitErrors[i]);
            kerror.push(errorMeta[1]);
            kmeta.push(errorMeta[2]);
          }
        }
        for( var i=0; i<kline.length; i++ ) {
          var output = "<tr><td class='error'>" + kerror[i] + "</td>";
          output += "<td class='line'>" + kline[i] + "</td>";
          output += "<td class='meta'></td></tr>";
          $("#error-tray table").append(output).find(".meta:last").text(kmeta[i]);
        }
      } else {
        // errors other than syntax errors
        onerror("Saving app failed. App ID: " + $("#editor").attr("appid") + ". Length of app: " + krl.length, document.location.href, 573649);
        $("#unknown-error").html("There has been an error in saving your app. This error has been logged so we can try to fix it. If this error continues, please notify us with details at <a href='mailto:support@kynetx.com'>support@kynetx.com</a>");
        toggleErrorTray();
      }
    }
  });
  return false;
}

function toggleErrorTray() {
  if( $("#error-tray").is(":visible") ) {
    $("#error-tray, #close-error-tray").fadeOut();
  } else {
    $("#error-tray, #close-error-tray").fadeIn();
  }
}

function changeSettings() {
//  alert("In the future you will be able to save preferences with this.");
  alert("Contactless Not!!! Swipe Again Please.");
}

function createCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function checkAndSetDefoults() {
  var cookie = readCookie("appbuilderPreferences");
  if( cookie == null ) {
    // hide error tray, error tray height, tabstop, syntax
    createCookie("appbuilderPreferences","0,450,2",365);
  } else {
    var prefs = cookie.split(",");
    // hide error tray on errors?
    hideErrorTray  = prefs[0];
    // height of error tray
   // errorTrayHeight = prefs[1];
  }
}











