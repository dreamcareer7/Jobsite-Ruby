$( document ).on('turbolinks:load', function() {
$(".project-thumb-actions").on("click", function(e){
    console.log("clicked");
var that = $(this),
actionList = that.next(".project-actions-list");
actionList.toggle();
});
});