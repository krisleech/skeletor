$(document).ready(function() {

	  // add class to current link
		$("a[href='" + location.pathname + "']").addClass("current");


    // All attribute to all Flash 
    // FireFox
    $("embed").attr("wmode", "transparent");   

    // IE
    var embedTag;
    $("embed").each(function(i) {
        embedTag = $(this).attr("outerHTML");
        if ((embedTag != null) && (embedTag.length > 0)) {
            embedTag = embedTag.replace(/embed /gi, "embed wmode=\"transparent\" ");
            $(this).attr("outerHTML", embedTag);
        }
        // This "else" was added
        else {
            $(this).wrap("<div></div>");
        }
    });

     $('#search #criteria').focus(function(){
        $(this).attr('value', '');
    });
   

    $('#flash-notice a').click(function(){
        $('#flash-notice').hide('slide');
    });
});



