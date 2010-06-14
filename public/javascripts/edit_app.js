var app = "";

$(document).ready(function() {  
  
  appID = $("#app-id").attr("appid");
  
  // EDIT AREA EXPANSION CONTROLS
  $(".section-header img").live("click", function() {
    $(this).parents(".app-section").find(".section-edit").slideToggle();
  });
  $("#expand-all").live("click", function() {
    $(".section-edit").slideDown();
  })
  $("#collapse-all").live("click", function() {
    $(".section-edit").slideUp();
  })

  // SORTING RULES
  $("#rules").sortable({
    handle : $(".handle")
  });
  
  // CREATE NEW RULE ON TOP
  $("#new-rule").click(function() {
    $("#rules").append( $("#app-section-template").html() );
  });
  
  // DELETE RULE
  $(".delete-rule").live("click", function() {
    var deleteRule = confirm("You really want to banish this rule to the outer regions of the code kingdom and remove it from your app?");
    if( deleteRule ) $(this).parents(".app-section").remove();
  });


  // SAVE APP
  $("#save-app").click(function() {
    if(!started) {
      startSavedSince();
      started = true;
    }
    resetSavedSince();
    // var source = $("textarea").text();
    //     console.log(source);
    //     $.ajax({
    //       url: "/save/" + appID,
    //       type: "POST",
    //       data: { "source" : source },
    //       success: function(msg) {
    //         alert(msg);
    //       },
    //       error: function(xmlhttprequest, status, error) {
    //         alert("fail");
    //       }
    //     });
  });
  
});


/////////////////////////////
//  SAVE TIMER
////////////////////////////
started = false;
seconds = 0;
minutes = 0;
hours = 0;
function startSavedSince() {
  setInterval("updateSavedSince()", 1000);
}

function updateSavedSince() {
  seconds++;
  // roll over! : )
  if(seconds > 59) {
    minutes++;
    seconds = 0;
  }
  if(minutes > 59) {
    hours++;
    minutes = 0;
  }
  var update = (hours < 10 ? "0"+hours : hours) + ":" + (minutes < 10 ? "0"+minutes : minutes) + ":" + (seconds < 10 ? "0"+seconds : seconds);
  $("#time").text(update);
  
}

function resetSavedSince() {
  seconds = 0;
  minutes = 0;
  hours = 0;
}






