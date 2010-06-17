// WHEN DOM IS READY
$(document).ready(function() {
  // REDIRECT IF INCOMPATIBLE BROWSER
  if($.browser.msie || $.browser.opera) {
    window.location.href = /(.*)edit$/.exec(window.location.href)[1] + "lame";
  }
  
  // set bespin window sizes before bespin loads
  $("#bespin-to-be, #control-tray").height($(window).height()-90);
  $("#bespin-to-be").width($(window).width()-51);
  
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
  
  window.onresize = resizeMe;
});

function resizeMe() {
  $("#bespin-to-be, #control-tray").height($(window).height()-80);
  $("#bespin-to-be").width($(window).width()-50);
}

// WHEN PAGE HAS FINISHED LOADING
$(window).load(function() {
  window.bespin = document.getElementById("bespin-to-be").bespin;
  window.bespin.value = $("textarea").text();
});

////////////////////////////
//  CONTROL TRAY FUNCTIONS
////////////////////////////
$("#close-error-tray, #warning").live("click", toggleErrorTray);

function saveApp() {
  $("#error-tray").hide();
  $("#error").html("");
  // insert spinner here
  $("#saving").show();
  var appid = $("#editor").attr("appid");
  var krl = window.bespin.value;
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
      // Hide stuff now that save attempt is complete
      $("#saving, #success, #good").hide();
      // show indicator for save failure
      $("#fail").show().fadeOut(3000);
      $("#warning").show();
      if(hideErrorTray==0) {
        $("#error-tray, #close-error-tray").fadeIn();
      }
      $("unknown-error").html("");
      try {
        //console.log(x.responseText);
      } catch(e) {
        
      }
      console.log(x.responseText);
      $("#error-tray #error").append(x.responseText);
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
    
    // tab stops
    var bespinOptions = $(".bespin").attr("data-bespinoptions");
    var bespinOptions = bespinOptions.replace(/"tabstop":\s[0-9]/,"\"tabstop\": "+ prefs[2]);
    $(".bespin").attr("data-bespinoptions",bespinOptions);
  }
}











