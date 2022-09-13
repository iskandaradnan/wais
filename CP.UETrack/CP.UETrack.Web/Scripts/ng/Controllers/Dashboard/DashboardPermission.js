$(document).ready(function () {

    //$("#ChartLevel").text("Month to Date");
   var level = $("#SelLevel").val();
   $("#ChartLevel").text(level);

   $('#ChartLevel').css("font-family", "OpenSans-SemiBold");
   $('#ChartLevel').css("font-size", 20 + "px");
   $("#ChartLevel").css("color", "#5e5e5e");

    //$('#ChartLevel').css({ "font-family": "OpenSans-SemiBold" });

   if (level == "Month to Date") {
       $('#YTDsave').css('visibility', 'visible');
       $('#YTDsave').show();
       $('#YTDsave').css("margin-right", 10 + "px");
       $('#MTDView').css('visibility', 'hidden');
       $('#MTDView').hide();
   }
   else if (level == "Year to Date") {
       $('#YTDsave').css('visibility', 'hidden');
       $('#YTDsave').hide();
       $('#MTDView').css('visibility', 'visible');
       $('#MTDView').show();
       $('#MTDView').css("margin-right", 10 + "px");
   }

    $("#YTDsave").on('click', function () {       
        window.location.href = "/home/dashboardYtd";

       // $("#ChartLevel").text("");
     //   $("#ChartLevel").text("Year to Date");
    });

    $("#MTDView").on('click', function () {
        window.location.href = "/home/dashboard";

      //  $("#ChartLevel").text("");
      //  $("#ChartLevel").text("Month to Date");
    });
});