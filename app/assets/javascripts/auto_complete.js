var ready = function() {

  var autoComplete = $( '.search' ).autocomplete({
    delay: 0,
    autoFocus: true,
    source: '/auto_complete',
    open: function(e, ui) {
      // Make space between the dropdown and the input field
      var $autoComplete = $(autoComplete.menu.element[0]);
      $autoComplete.css('top', $autoComplete.position().top + 16 + 'px');
    },
    select: function(e, ui){ followResultLinkOnEnter(e); },
    response: function(e, ui) { 
      if(ui.content.length < 1) { 
        $('.js-autocomplete-results-ul').empty();
        $('.js-no-results').addClass('is-visible');
      } else {
        $('.js-no-results').removeClass('is-visible');
      }
    }
  }).data( 'ui-autocomplete' );

  autoComplete._renderItem = formatResult;

  autoComplete._renderMenu = function( container, items ) {
    var that = this;

    container.addClass('popover u-box-shadow is-visible list list--unstyled js-autocomplete-results-ul');
    container.css('top', '1233px');

    result_sort = "";

    $.each( items, function( index, item ) {
      //sort results into two subheadings
      if( item.result_sort != result_sort) {

        if(item.result_sort === "Business") {
          var sortHeader = $('body').data('locale') === "ar" ? "الأعمال" : "Businesses"
          var itemResultSort = { type_header: sortHeader  }
        } else {
          var sortHeader = $('body').data('locale') === "ar" ? "الفئات" : "Categories"
          var itemResultSort = { type_header: sortHeader }
        }

        result_sort = item.result_sort;

        that._renderItemData( container, itemResultSort );
      }

      that._renderItemData( container, item );

    });
  };

  function followResultLinkOnEnter(e) {
    e.stopPropagation();
    var autocompleteOptions = e.currentTarget;
    var selectedElement = $(autocompleteOptions).find('.ui-state-focus');
    var link = selectedElement.attr('href');

    //only check link when using keyboard to select -- prevent undefined on mobile
    if(e.keyCode === 13 && typeof link === 'undefined') { return e.preventDefault() };

    window.location.href = link;
  }

  function formatResult( container, item ) {
    if (item.type_header){
      formattedResult = $( '<span class="autocomplete-category">' + item.type_header.replace('_', ' ') + '</span>' );
    } else if (item.sub_category) {
      formattedResult = $( '<a href="/' + $('body').data('current-city') + '/' + item.result_type + "/" + item.id + '" class="popover__link">' + '<span>' + item.name + '</span>' + ' - ' + item.sub_category + '</a>' );
    } else {
      formattedResult = $( '<a href="/' + $('body').data('current-city') + '/' + item.result_type + "/" + item.id + '" class="popover__link">' + '<span>' + item.name + '</span>' + '</a>' );
    }

    if(item.result_type == "services") {
      formattedResult.find('span').addClass('u-text-dark');
    }

    return formattedResult
    .attr( 'data-value', item.id )
    .appendTo( container );
  }
}

//prevent submit if nothing entered
$('.search').parent('form').on('submit', function(e) {
  if($(this).val() === '' ) { e.preventDefault() };
});

$( document ).on( 'turbolinks:load', ready);
