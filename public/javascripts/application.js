// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


// Functions used for quick_table helper to show altrow.
function closeRow(element) {
	row = ($(element).parent().parent().parent())
	row.hide();
}

function showAltRow(element) {
	row = ($(element).parent().parent()).next();
	row.show();
}

$(document).ready(function() {
  $("#edit-nav a:last img").click(function() {
    $("#distribute-dropdown").slideToggle();
    return false;
  });
})