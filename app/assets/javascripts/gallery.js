$( document ).on('turbolinks:load', function() {
  $('.custom_carousel').slick({
    dots:true,
    centerMode: false,
  });
  $("<select />").appendTo(".gallery-category-menu-and-dropdown");


         $("<option />", {
            "selected": "selected",
            "value"   : "",
            "text"    : "Select Category..."
         }).appendTo(".gallery-category-menu-and-dropdown select");


         $(".gallery-category-menu-and-dropdown a").each(function() {
          var el = $(this);
          $("<option />", {
              "value"   : el.attr("href"),
              "text"    : el.text()
          }).appendTo(".gallery-category-menu-and-dropdown select");
         });

         $(".gallery-category-menu-and-dropdown select").change(function() {
           window.location = $(this).find("option:selected").val();
         });
})
