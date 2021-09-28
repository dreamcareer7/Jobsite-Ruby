$(function () {
  $('#new_message').on('ajax:success', function (a, b, c) {
    console.log('HELLLLLOOOOOOOO!!!!!');
    $(this).find('input')[0].form.reset();
    $('div.string.optional').text('');
  });
});
