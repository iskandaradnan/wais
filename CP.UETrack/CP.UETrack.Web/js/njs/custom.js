
var tabCountClicks = 0;

// JavaScript Document
function menu() {
    "use strict";
    var winWidth = $(window).width();
    var left = "0";
    var padLeft = "220px";
    var className = "menuHide";

    if (winWidth < 769) {
        left = "-220px";
        padLeft = "0";
        className = "menuShow";
    }
    $("#sidebar").stop().animate({ "left": left }, 300);
    $("#container").stop().animate({ "padding-left": padLeft }, 300);
    $("#menuToggle").removeClass().addClass(className);
}
function scrollbar() {
    "use strict";
    $('#menu').enscroll({
        showOnHover: false,
        verticalTrackClass: 'track',
        verticalHandleClass: 'handle',
    });
}
function containerHeight() {
    "use strict";
    var winHeight = $(window).height();
    var headerHeight = $(".headerHeight").outerHeight();
    var contanerHeight = winHeight;
    var footerHeight = $("#footer").outerHeight();
    $("#container, #dashboard").css({ 'min-height': contanerHeight, 'padding-top': headerHeight, 'padding-bottom': footerHeight });
    $("#sidebar").css("top", headerHeight);
}
function toppane() {
    "use strict";
    // hide #back-top first
    $("#back-top").hide();

    // fade in #back-top
    $(function () {
        $(window).scroll(function () {
            if ($(this).scrollTop() > 100) {
                $('#back-top').fadeIn();
            } else {
                $('#back-top').fadeOut();
            }
        });

        // scroll body to 0px on click
        $('#back-top a').click(function () {
            $('body,html').animate({
                scrollTop: 0
            }, 800);
            return false;
        });
    });
}
$(document).ready(function () {
    "use strict";

$(".dashlets ul li a").hover(function(){
			$(this).siblings(".detail-text").animate({width: '250px',padding: '20px 66px 20px 20px'});
			
	},	function(){
			$(this).siblings(".detail-text").animate({width: '0px',padding: '0'});
});
   //content
    var hidWidth;
    var scrollBarWidths = 40;

    function widthOfList() {

        var itemsWidth = 0;
        $('#myTab li').each(function () {
            var itemWidth = $(this).outerWidth();
            itemsWidth += itemWidth;
        });
        return itemsWidth;
    }

    var widthOfHidden = function () {
        return (($('.wrapper').outerWidth()) - widthOfList() - getLeftPosi()) - scrollBarWidths;
    };

    var getLeftPosi = function () {
        return $('#myTab').position().left;
    };

    var reAdjust = function () {
        if (($('.wrapper').outerWidth()) < widthOfList()) {
            $('.scroller-right').show();
        }
        else {
            $('.scroller-right').hide();
        }

        if (getLeftPosi() < 0) {
            $('.scroller-left').show();
        }
        else {
            $('.item').animate({ left: "-=" + getLeftPosi() + "px" }, 'slow');
            $('.scroller-left').hide();
        }
    }

    var isTabsExist = ($("#myTab").length > 0) ? true : false;

    if (isTabsExist) {
        reAdjust();

        $(window).on('resize', function (e) {
            reAdjust();
        });
    }

    $('.scroller-right').click(function () {

        var wrapperWidth = $('.wrapper').outerWidth();
        var tabWidth = $("#myTab").outerWidth();

        $('.scroller-left').fadeIn('slow');

        var listLeft = $("#myTab").position().left;
        var itemsWidth = $('#myTab li').eq(tabCountClicks).outerWidth();

        var left = $('#myTab li').eq(tabCountClicks).outerWidth();
        var totalLeft = left * -1;

        tabWidth = tabWidth + totalLeft;

        var diff = $("#myTab").outerWidth() - $(".wrapper").outerWidth();
        var listPadding = $("#myTab").position().left;

        var widthWithNextElement = (listPadding * -1) + $('#myTab li').eq(tabCountClicks + 1).outerWidth();
        if (widthWithNextElement > diff) {
            $('.scroller-right').fadeOut('slow');
        }


        totalLeft = totalLeft - (tabCountClicks);
        $('#myTab').animate({ left: "+=" + totalLeft + "px" }, 'slow');
        tabCountClicks = tabCountClicks + 1;

    });

    $('.scroller-left').click(function () {

        $('.scroller-right').fadeIn('slow');
        $('.scroller-left').fadeOut('slow');

        $('#myTab').animate({ left: "-=" + getLeftPosi() + "px" }, 'slow', function () {

        });

        //
        //        tabCountClicks = tabCountClicks - 1;
        //
        //        var wrapperWidth = $('.wrapper').outerWidth();
        //        var tabWidth = $("#myTab").outerWidth();
        //
        //        $('.scroller-left').fadeIn('slow');
        //
        //        var listLeft = $("#myTab").position().left;
        //        var itemsWidth = $('#myTab li').eq(tabCountClicks).outerWidth();
        //        var totalItemsWidth = 0;
        //
        //        var left = $('#myTab li').eq(tabCountClicks).outerWidth();
        //        var totalLeft = left;
        //
        //        tabWidth = tabWidth + totalLeft;
        //
        //        var diff = $("#myTab").outerWidth() - $(".wrapper").outerWidth();
        //        var listPadding = $("#myTab").position().left;
        //
        //        var widthWithNextElement = (listPadding * -1) + $('#myTab li').eq(tabCountClicks + 1).outerWidth();
        //        if (widthWithNextElement > 0) {
        //            $('.scroller-left').fadeOut('slow');
        //        }
        //
        //        totalLeft = totalLeft + (tabCountClicks);
        //        $('#myTab').animate({ left: "+=" + totalLeft + "px" }, 'slow');


    });
    //tab scroll end




    $(".searchToggle").click(function () {
        $(".search-inner").slideToggle(300);
        $(".searchToggle .glyphicon").toggleClass("glyphicon-triangle-bottom glyphicon-triangle-top");
    });

    $(document).on("click", "#menuToggle", function (e) {
        e.preventDefault();
        var winWidth = $(window).width();
        var left = "-220px";
        var padLeft = "0";
        if ($(this).hasClass("menuShow")) {
            if (winWidth > 769) {
                left = "0";
                padLeft = "220px";
            } else {
                left = "0";
                padLeft = "0";
            }
        }
        $("#sidebar").stop().animate({ "left": left }, 300);
        $("#container").stop().animate({ "padding-left": padLeft }, 300,
            function () {
                $("#menuToggle").toggleClass("menuShow menuHide");
            });
    });
    $('#menu li').click(function (e) {
        $(this).toggleClass("current").find('>ul').stop(true, true).toggleClass("show")
            .end().siblings().find('ul').removeClass("show").closest('li');
        $(this).siblings("li").removeClass("current");
        $(this).find("li").removeClass("current");
        e.stopPropagation();
    });

    $('#menu li').each(function (i, val) {
        var children = $(val).find('ul li');

        if (children.size() > 0) {
            $(val).prepend('<span class="arrow"></span>');
        }
    });
    toppane();
    menu();
    containerHeight();
    scrollbar();
    $(window).resize(function () {
       // menu();
        containerHeight();
        toppane();
    });

});
