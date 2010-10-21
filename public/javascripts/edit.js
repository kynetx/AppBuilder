// WHEN DOM IS READY
$(document).ready(function() {
  
    window.editor = CodeMirror.fromTextArea("unadulterated-source", {
		parserfile: ["tokenizejavascript.js", "parsejavascript.js"],
		path: "/CodeMirror-0.8/js/",
		stylesheet: "/CodeMirror-0.8/css/jscolors.css",
		lineNumbers:true,
		textWrapping:true,
		tabMode:"shift",
		enterMode:"keep",
		electricChars:false,
		width:"100%",
		height:"100%",
		saveFunction: saveApp
	});
  
  
  // cookies!
  hideErrorTray = 0;
  //errorTrayHeight = 250;
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
  
});

////////////////////////////
//  CONTROL TRAY FUNCTIONS
////////////////////////////

function saveApp() {
  hideError();
  $("#error").html("");
  // insert spinner here
  $("#saving").show();
  var appid = $("#editor").attr("appid");
  var krl = window.editor.getCode();
  $.ajax({
    url: "/applications/" + appid + "/update",
    type: "PUT",
    data: {"krl":krl},
    success: function(msg) {
      $("#saving, #fail, #success, #warning").hide();
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
      // Hide stuff now that save attempt is complete
      $("#saving, #success, #good").hide();
      // show indicator for save failure
      $("#fail").show().fadeOut(3000);
      $("#warning").show();
      showError();

      $("#error-tray #error").append(x.responseText);
    }
  });
  return false;
}

function toggleErrorTray() {
  if( $("#error-tray").is(":visible") ) {
    hideError();
  } else {
    showError();
  }
}

function hideError(){
	$("#editor").removeClass("showerror");
	$("#error-tray").hide();
}

function showError(){
	$("#editor").addClass("showerror");
	$("#error-tray").show();
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

