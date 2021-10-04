$( document ).on('turbolinks:load', function() {
  $('.custom_carousel').slick({
    dots:true,
    centerMode: false,
    rtl: $("html").hasClass("rtl")
  });


  $(".gallery-category-menu-and-dropdown select").change(function() {
    window.location = $(this).find("option:selected").val();
  });
})
