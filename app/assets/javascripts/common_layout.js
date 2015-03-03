function unifyHeights() {
  var maxHeight = 0;
  var tdHeight = parseFloat(window.innerHeight)  - $("#footer").height();
  var minHeight = tdHeight - 140;
  var maxHeight = tdHeight - 139;
   $("[adjustTd=true]").attr("style", 'min-height: '+ minHeight + "px; overflow: auto; height: "+ maxHeight + "px;");
}

$(document).ready(function(){
    unifyHeights();
});

$(window).resize(function() {
   unifyHeights();
});

function photoOverlay(){
   $(".group1").colorbox({rel:'group1'});
        //Example of preserving a JavaScript event for inline calls.
        $("#click").click(function(){
          $('#click').css({"background-color":"#f00", "color":"#fff", "cursor":"inherit"}).text("Open this window again and this message will still be here.");
          return false;
        });

}

 function change_chevon(c_id) {

   $("a[accord-main=accord]").each(function(){

        if($(this).attr('href') == ("#account_4")){
          if ($("a[circle_id="+c_id+"]").attr('class') != 'disabled') {
           $(this).click();
          }
          $(this).find('i').attr('class', 'icon-chevron-down');
          $(this).attr('class', 'disabled');
          $("a[circle_id="+c_id+"]").attr('class','disabled');
         };
       });
  }

