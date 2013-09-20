// Footer fix
$(window).load(function() {
    var total_height = $('.container').outerHeight() + $('#footer').outerHeight();
    if (total_height < window.innerHeight) {
        $('#footer').addClass('navbar-fixed-bottom');
    }
})