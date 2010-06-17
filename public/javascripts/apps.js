$(document).ready(function() {
  // stick a pencil in your eye and then everything looks better on Windows and IE
  if($.browser.msie) {
    var rowCount = 0;
    $(".qtable tr").each(function() {
      if(rowCount != 0) {
        var prelink = $(this).find("td:eq(1) a").attr("href");
        var link = /(.*)edit$/.exec(prelink);
        link = (link + "").split(",")[1] + "lame";
        try {
          $(this).find("td:eq(1) a").attr("href",link);
        } catch(e) {}
        try {
          $(this).find("td:eq(2) a").attr("href",link);
        } catch(e) {}
      }
      rowCount++;
    });
  }
  
  $("#find").val("CTRL + F");
  $("tr:even").css({"background-color":"#F2F2F2"});
  $(document).bind('keydown', 'ctrl+f', jumpToFind);
  $(document).bind('keydown', 'ctrl+n', newApp);
  $("#find").live("focus",activateFind);
  // initiate search indexing
  apps = [];
  searched = [];
  useSearched = false;
  indexForSearch();
  
  // NEW APP!!!
  $("#cancel").click(function() {
    $("#new-app-meta").fadeOut();
  });
  $("#i-want-a-new-app").click(function() {
    newApp();
  });
});

function newApp() {
  if( $("#new-app-meta").is(":hidden") ) {
    $("#new-app-meta").fadeIn();
    $("#new-app-name").focus();
  } else {
    $("#new-app-meta").fadeOut();
  }
}

function jumpToFind() {
  $("#find").focus();
  activateFind();
}

function activateFind() {
  $("#find").val("").live("keyup", function(e) {
    var code = (e.keyCode ? e.keyCode : e.which);
    if(code == 27) {
      clearSearch();
      $(this).blur();
    } else {
      find(code);
    }   
  });
}

function clearSearch() {
  $("#find").val("");
  // undo all hiding of apps
  $("table tr").show();
  useSearched = false;
  searched = [];
}

function indexForSearch() {
  $("table tr").each(function(index, domElem) {
    if(index != 0) {
      var temp = {};
      temp.row = index;
      temp.id = $(this).find("td:eq(1)").text();
      temp.name = $(this).find("td:eq(2)").text();
      temp.name = temp.name.toLowerCase();
      temp.role = $(this).find("td:eq(4)").text();
      apps.push(temp);
    }
  });
}

function find(code) {
  var category = $("select").val();
  if( code == 8 ) {
   $("table tr").show();
   useSearched = false;
   searched = []; 
   return true;
  }  
  var searchTerm = $("#find").val();
  // Search through all the apps
  //console.log(searchTerm);
  //console.log(useSearched);
  //console.log(searched);
  if( !useSearched ) {
    for( var i=0; i<apps.length; i++ ) {
      var score = apps[i][category].score(searchTerm);
      // hide app if it doesn't match at all
      if( score == 0 ) {
        $("table tr:eq("+apps[i].row+")").hide();
      } else {
        searched.push(apps[i]);
      }
      useSearched = true;
    }
  } else {
    var tempSearched = [];
    for( var i=0; i<searched.length; i++ ) {
      var score = searched[i][category].score(searchTerm);
      // hide app if it doesn't match at all
      if( score == 0 ) {
        $("table tr:eq("+searched[i].row+")").hide();
      } else {
        tempSearched.push(searched[i]);
      }
    }
    searched = tempSearched;
    tempSearched = [];
  }
}
















