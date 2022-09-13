// JavaScript Document
var body = document.getElementsByTagName('body')[0];
setHeight();

window.addEventListener('resize', setHeight);

function setHeight() {
    var winHeight = window.innerHeight;
    //if (winHeight < 600) {
    //    winHeight = 600;
    //}
    body.style.height = winHeight + 'px';
}

//smooth dropdown
$('.dropdown').on('show.bs.dropdown', function() {
    $(this).find('.dropdown-menu').first().stop(true, true).fadeIn(700);
});

// Add slideUp animation to Bootstrap dropdown when collapsing.
$('.dropdown').on('hide.bs.dropdown', function() {
    $(this).find('.dropdown-menu').first().stop(true, true).fadeOut();
});

$(document).ready(function () {
    //multiselect dropdown
    $('.multiselect').multiselect({
        enableFiltering: false
    });
})

//****************************************** tree js ****************************************//
$(function() {

    $('.tree_menu > li > a').click(function() {
        //open the main menu
        $(this).toggleClass('open');
        $(this).closest('li').siblings().find(' > a').removeClass('open');
        //set active to main menu
        $(this).toggleClass('active');
        $(this).closest('li').siblings().find(' > a').removeClass('active');
    });

    $('.sub_menu > li > a').click(function() {
        //sub menu open events
        $(this).toggleClass('open');
        //$(this).closest('li').siblings().find(' > a').removeClass('open');
        $(this).closest('ul').siblings().find('li > a').removeClass('open');
        $(this).closest('li').siblings().find(' > a').removeClass('open');
    });

});
//************************************* tree js end **************************************//

//*********************************** menu minimize js ************************************//
$(function () {
    $('.side_bar').addClass('open');
    $('.back_track').click(function () {
        $('.side_bar').toggleClass('minimized');
        $('.side_bar').toggleClass('open');
        if ($('.side_bar').hasClass('minimized')) {
            $('.tree_menu').enscroll('destroy');
            $('.tree_menu > li > ul').enscroll({
                showOnHover: true,
                verticalTrackClass: 'track',
                verticalHandleClass: 'handle'
            });
        } else {
            $('.tree_menu').enscroll({
                showOnHover: true,
                verticalTrackClass: 'track',
                verticalHandleClass: 'handle'
            });
            $('.tree_menu > li > ul').enscroll('destroy');
        }

    });

    $('.tree_menu').enscroll({
        showOnHover: true,
        verticalTrackClass: 'track',
        verticalHandleClass: 'handle'
    });



});


//*********************************** menu minimize js ************************************//


//*********************************** Media Upload *****************************************

//$("#myCarousel").owlcarousel({
//    autoplay: false,
//    loop: true,
//    dots: false,
//    nav: true,
//    navtext: ["<i class='fa fa-chevron-left'></i>", "<i class='fa fa-chevron-right'></i>"],
//    responsive: {
//        0: {
//            items: 1
//        },
//        1300: {
//            items: 1
//        }
//    }
//});

//********************************** Media Upload End *******************************************

//********************************* Login Eye open *****************************************

$(function () {
    $('.password_toogle > a').mousedown(function () {
        if ($(this).find('i').hasClass('fa-eye')) {
            $(this).find('i').removeClass('fa-eye');
            $(this).find('i').addClass('fa-eye-slash');
            $(this).closest('span').siblings('input').attr('type', 'text');
        } else {
            $(this).find('i').removeClass('fa-eye-slash');
            $(this).find('i').addClass('fa-eye');
            $(this).closest('span').siblings('input').attr('type', 'password');
        }
    })
})

//********************************* Login Eye End *****************************************