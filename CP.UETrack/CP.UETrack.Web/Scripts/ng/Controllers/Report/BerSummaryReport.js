$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnBerSummaryRptCancel").click(function () {
        window.location.href = " ";
    });

});

function getBerSummaryReport() {
    $('#btnBerSummaryRptFetch').attr('disabled', true);
    $("#BerFromdate").prop("disabled", true);
    $("#BerTodate").prop("disabled", true);
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');

    var fromdate = $('#BerFromdate').val();
    var todate = $('#BerTodate').val();
    var isFormValid = true;
    isFormValid = formInputValidation("BerSummeryId", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnBerSummaryRptFetch').attr('disabled', false);
        $("#BerFromdate").prop("disabled", false);
        $("#BerTodate").prop("disabled", false);
        return false;
    }
    else {
        $('#myPleaseWait').modal('hide');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $('#BerTodate').parent().removeClass('has-error');
    }


    if (fromdate != null && fromdate != "" && todate != null && todate != "") {
        var ActiveFromDate = new Date(getDateToCompare($('#BerFromdate').val()));
        var ActiveToDate = new Date(getDateToCompare($('#BerTodate').val()));

        if (ActiveFromDate > ActiveToDate) {
            $('#myPleaseWait').modal('hide');
            $('#BerTodate').parent().addClass('has-error');
            $("div.errormsgcenter").text("To Date Should be greater than are equal to From Date");
            $('#errorMsg').css('visibility', 'visible');

            $('#btnBerSummaryRptFetch').attr('disabled', false);
            $("#BerFromdate").prop("disabled", false);
            $("#BerTodate").prop("disabled", false);
            return false;
        }
        else {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');
            $('#BerTodate').parent().removeClass('has-error');
        }
    }



    //var fromDate = $('#Berfromdate').val(); 
    //var toDate = $('#BerTodate').val();

    //var fromYear = getYearValue(fromDate);
    //var fromMonth = getMonthValue(fromDate);  

    //var toYear = getYearValue(toDate);
    //var toMonth = getMonthValue(toDate);
    var loc = '/Report/BerSummaryReport.aspx?BerFromdate=' + $('#BerFromdate').val()
         + '&BerTodate=' + $('#BerTodate').val();



   // var loc = '/Report/BerSummaryReport.aspx?BerSummaryFromMonth=' + fromMonth + '&BerSummaryFromYear=' + fromYear + '&BerSummaryToMonth=' + toMonth + '&BerSummaryToYear=' + toYear + '&BerSummaryMonth=' + $('#BerSummarymonth').val();

    document.getElementById('ReportFrame').setAttribute('src', loc);
    $("#btnBerSummaryRptCancel").css("visibility", "visible");
}



function  getYearValue(inputDate)
{
    var m_names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    var dateArray = inputDate.split("-");
    var Fromyear = dateArray[2];
   // var pos = getPosition(m_names, dateArray[1]);
   // var month = pos + 1;
    // var fromMonth = month;
    return Fromyear; 
}

function getMonthValue(inputDate) {
    var m_names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    var dateArray = inputDate.split("-");
    //var Fromyear = dateArray[2];
     var pos = getPosition(m_names, dateArray[1]);
     var month = pos + 1;
     var fromMonth = month;
     return fromMonth;
}