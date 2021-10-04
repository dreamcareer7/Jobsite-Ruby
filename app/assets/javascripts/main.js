/*
No space beteween // comment header means only the one function/line applies to header

  i.e.  // header for just a single behavior
        $('#woohoo').click( function(){ foo = bar; })

Double space between // comment header means multiple functions to follow

  i.e.  // header for a big block of related functionality

        $('#woohoo').click( function(){ foo = bar; })
        $('#woohoo').click( function(){
          foo = bar;
          bar = foo;
        })
*/

$( document ).on('turbolinks:load', function() {

  // Tooltips
  $('.tooltip').tooltipster({ maxWidth: 500 });

  // Datepicker
  $( '.datepicker' ).datepicker( { dateFormat: 'dd-mm-yy', changeYear: true, yearRange: '1900:2016' } );
  $( '.datepicker-future' ).datepicker( { dateFormat: 'dd-mm-yy', changeYear: true, yearRange: '2016:2025', beforeShowDay: stylePastDates });

  // Select2
  $( '.select2' ).addClass('needsclick').select2({ templateSelection: hideNone, templateResult: hideNone });

  // Fastclick
  FastClick.attach(document.body);

  // Segmented control
  $('.segmented-control__item').each(function(o) {
    $(this).click(function() {
      $('.segmented-control__item').siblings().removeClass('active');
      $(this).addClass('active');
    });
  });

  // Mobile nav
  $('.js-mobile-nav-trigger').click(function() {
    $('.js-mobile-nav').toggleClass('is-visible');
    $('.js-mobile-nav-backdrop').toggleClass('is-visible');
    $('body').toggleClass('hidden');
  });

  // Banner
  $('.banner--disappearing').delay(7000).slideUp(300);

  // How it works
  $('.js-how-it-works-trigger').click(function() {
    $('.js-how-it-works').slideToggle(300);
  });


  // Dropdown
  var dropdownDelayHandles = {}; // This associates popover buttons with their popover timeout handles. It allows us to clear only the relevant setTimeouts when a user's mouse exits a popover.
  var i = 0;
  var setPopoverTimeout = function($popover, $popoverTrigger) {
    dropdownDelayHandles[$popoverTrigger.data('popover-id')] = setTimeout(function() {
      $popover.removeClass('is-visible');
    }, 200);
  };
  var clearPopoverTimeout = function($popoverTrigger) {
    var timeoutId = dropdownDelayHandles[$popoverTrigger.data('popover-id')];
    clearTimeout(timeoutId);
    delete dropdownDelayHandles[$popoverTrigger.data('popover-id')]; // Remove the unused ID from the handle object
  };

  // Give each popover link a unique ID to use them as keys in dropdownDelayHandles
  $('.js-open-popover').each(function() {
    $(this).data('popover-id', i++);
  });

  $('.js-open-popover').mouseenter(function() {
    clearPopoverTimeout($(this));
    $(this).next('.popover').addClass('is-visible');
  });

  $('.js-open-popover').mouseleave(function() {
    setPopoverTimeout($(this).next('.popover'), $(this));
  });

  $('.popover').mouseenter(function() {
    clearPopoverTimeout($(this).prev('.js-open-popover'));
  });

  $('.popover').mouseleave(function() {
    setPopoverTimeout($(this), $(this).prev('.js-open-popover'));
  });

  $('.js-open-popover').on('touchstart', function() {
    $(this).next('.popover').toggleClass('is-visible');
  });


  // Smooth Scroll
  $(function() {
    const scroll = new SmoothScroll('a[href*="#"]:not([class*="business-tabs"]):not([class*="admin-tabs"])', {
      speed: 300
    });
  });

  // Slick Slider

  $('.js-ad-slider').slick({
    arrows: false,
    speed: 200,
    cssEase: 'ease-in-out'
  });

  $('.js-ad-slider-prev').click(function(){
    $('.js-ad-slider').slick('slickPrev');
  });

  $('.js-ad-slider-next').click(function(){
    $('.js-ad-slider').slick('slickNext');
  });


  // Sidebar expand

  $('.js-sidebar-expand').click(function() {
    var $this = $(this);

    if($this.hasClass('expanded')){
      $this.removeClass('expanded');
      $this.next('.js-sidebar-list').hide();
      return;
    }

    $(document).find('.js-sidebar-list').each(function() { $(this).hide(); });
    $(document).find('.js-sidebar-expand').each(function() { $(this).removeClass('expanded'); });
    $(this).toggleClass('expanded');
    $(this).next('.js-sidebar-list').toggle();
  });

  //Show or hide chat for a project on project#show page

  $('.js-toggle-chat').on('click', function() {
    var listingCard = $(this).parents('.js-project-listing-card');
    var chatCard = listingCard.find('.js-project-card-chat');

    if(chatCard.hasClass('u-hide')) {
      chatCard.removeClass('u-hide');
      $(this).text("Hide messages");
    } else {
      chatCard.addClass('u-hide');
      $(this).text("View messages");
    }
  });


  // Admin country switcher

  $('.js-admin-country-selector').change(function() {
    $(this).closest('form').submit();
  });

  // Submit forms with <a> tags
  $('.js-form-submit-link').click(function(e) {
    $(this).closest('form').submit();
    e.preventDefault();
  });

});

// Toggle follow
$(document).on('click', '.js-toggle-follow', function() {
  $(this).toggleClass('btn--secondary').toggleClass('btn--positive');

  if($(this).children('.js-following').hasClass('u-hide')) {
    $(this).children('.js-following').removeClass('u-hide');
    $(this).children('.js-follow').addClass('u-hide');
  } else {
    $(this).children('.js-following').addClass('u-hide');
    $(this).children('.js-follow').removeClass('u-hide');
  }
});

// Toggle section in business listing profile
$(document).on('click', '.js-section-toggle', function() {
  $('.js-section-toggle').each(function() { $(this).removeClass('is-active'); });
  $(this).addClass('is-active');

  if($(this).data('toggle') === 'overview') {
    $('.js-section').each(function() { $(this).removeClass('u-hide'); });
    $('.js-empty').each(function() { $(this).addClass('u-hide'); });
  } else {
    $('.js-section').each(function() { $(this).addClass('u-hide'); });
    $(document).find('.js-' + $(this).data('toggle')).removeClass('u-hide');

    $('.js-truncate-text').readmore({
      speed: 200,
      collapsedHeight: 100,
      moreLink: '<p class="u-text-accent"><a href="#">+ View more</a></p>',
      lessLink: '<p class="u-text-accent"><a href="#">- View less</a></p>'
    });
  }

});


// Callback - change number
$(document).on('click', '.js-change-number', function() {
  $('.js-hide-number').toggle();
  $('.js-replace-number').toggle();
  $('#user_callback_user_number').toggle();
});

// Check if business update form has been modified
function unlockBusinessForm() {
  $(this).find('input[type="submit"]').prop('disabled', false);
}

$(document).on('input', '.edit_business, .new_business', _.debounce(unlockBusinessForm, 300));

// Expand featured projects in business profile edit
$(document).on('click', '.js-toggle-featured-project', function() {
  $(this).parent('.js-featured-project').children('.js-toggle-target').toggleClass('u-hide');
});

// Mark a notification as read
$(document).on('click', '.js-mark-as-read', function() {
  $this = $(this);
  $.ajax({
    url: '/business/notifications/mark_as_read',
    method: 'PUT',
    data: { notification: $this.data() }
  });
});

// Select2 - select all
$(document).on('change', '.js-select-all', selectAll);

function selectAll() {
  var select2Target = $(this).parents('.js-select2');
  var select2Options = select2Target.find('.js-select2-options > option');

  if($(this).is(':checked')){ select2Options.prop('selected', 'selected'); }
  else { select2Options.removeAttr('selected'); }

  select2Target.find('.js-select2-options').trigger('change');
}

//Hide none from select2 results (templateSelection, templateResult)
function hideNone(data, container) {
  if(data.text === "None") {
    $(container).addClass('u-hide');
  } else {
    return data.text;
  }
}

// Datatables - Set default options
$.extend(true, $.fn.dataTable.defaults, {
  language: {
    info: "Showing _TOTAL_ entries",
    infoEmpty: "No entries to show",
    infoFiltered: "(filtered from _MAX_)"
  }
});

// Phone Number - format
$(document).on('keyup', '.js-phone', function() {
  $(this).val( $(this).val().replace(/^00/, '+') );
});

// Datepicker - style past dates

function stylePastDates(date) {
  if (moment(date).isBefore(moment().subtract(1, 'day'))) { return [false, 'past-date'] }
  return [true, '']
}

// Trim string
//
function trimString(string) {
  if (string.length < 50) { return string }

  return $.trim(string).substring(0, 50)
    .split(" ").slice(0, -1).join(" ") + "...";
}

// Open image
$(document).on('click', '.js-open-image', function() {
  window.open($(this).data().photolink)
})

$(document).on('click', '.js-open-image-inner', function(e) {
  e.stopPropagation()
})

