$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnSummaryRptCancel").click(function () {
        window.location.href = " ";
    });

});

function getSummaryReport() {

    $('#btnSummaryRptFetch').attr('disabled', true);
    $("#VOVFromyear").prop("disabled", true);
    $("#VOVFrommonth").prop("disabled", true);
    $("#VOVToyear").prop("disabled", true);
    $("#VOVTomonth").prop("disabled", true);

    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');

    // var fromdate = $('#BerFromdate').val();
    //var todate = $('#BerTodate').val();
    var isFormValid = true;
    isFormValid = formInputValidation("VMSummaryFormId", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnSummaryRptFetch').attr('disabled', false);
        $("#VOVFromyear").prop("disabled", false);
        $("#VOVFrommonth").prop("disabled", false);
        $("#VOVToyear").prop("disabled", false);
        $("#VOVTomonth").prop("disabled", false);
        return false;
    }
    else {
        $('#myPleaseWait').modal('hide');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        //$('#BerTodate').parent().removeClass('has-error');
    }


    //if (fromdate != null && fromdate != "" && todate != null && todate != "") {
    //    var ActiveFromDate = new Date(getDateToCompare($('#BerFromdate').val()));
    //    var ActiveToDate = new Date(getDateToCompare($('#BerTodate').val()));

    //    if (ActiveFromDate > ActiveToDate) {
    //        $('#myPleaseWait').modal('hide');
    //        $('#BerTodate').parent().addClass('has-error');
    //        $("div.errormsgcenter").text("To Date Should be greater than are equal to From Date");
    //        $('#errorMsg').css('visibility', 'visible');

    //        $('#btnBerAnalysisRptFetch').attr('disabled', false);
    //        $("#BerFromdate").prop("disabled", false);
    //        $("#BerTodate").prop("disabled", false);
    //        return false;
    //    }
    //    else {
    //        $('#myPleaseWait').modal('hide');
    //        $("div.errormsgcenter").text("");
    //        $('#errorMsg').css('visibility', 'hidden');
    //        $('#BerTodate').parent().removeClass('has-error');
    //    }
    //}
  


    var loc = '/Report/SummaryReportOnVariations.aspx?VOVFromYear=' + $('#VOVFromyear').val()
        + '&VOVFromMonth=' + $('#VOVFrommonth').val()
    + '&VOVToYear=' + $('#VOVToyear').val()
    + '&VOVTomonth=' + $('#VOVTomonth').val();

    document.getElementById('ReportFrame').setAttribute('src', loc);
    $("#btnSummaryRptCancel").css("visibility", "visible");
    
}

