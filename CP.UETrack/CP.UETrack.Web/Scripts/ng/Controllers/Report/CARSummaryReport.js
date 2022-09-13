$(document).ready(function () {
    var LOVlist = {};
    $('#myPleaseWait').modal('show');

    $("#btnCARRptCancel").click(function () {
        window.location.href = " ";
    });
    $.get("/api/correctiveActionReport/Load")
             .done(function (result) {
                 var loadResult = JSON.parse(result);
                 $.each(loadResult.Indicators, function (index, value) {
                     $('#IndicatorId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                 });
             })
   .fail(function (response) {
       $('#myPleaseWait').modal('hide');
       $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
       $('#errorMsg').css('visibility', 'visible');
   });
});

function getCARReport() {


    $('#btnCARptFetch').attr('disabled', true);
    $("#CARFromdate").prop("disabled", true);
    $("#CARTodate").prop("disabled", true);
    $("#IndicatorId").prop("disabled", true);

    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');

    var isFormValid = true;
    isFormValid = formInputValidation("CARReortId", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnCARptFetch').attr('disabled', false);
        $("#CARFromdate").prop("disabled", false);
        $("#CARTodate").prop("disabled", false);
        $("#IndicatorId").prop("disabled", false);
        return false;
    }


    var CARFromdate = $('#CARFromdate').val();
    var CARTodate = $('#CARTodate').val();
    var IndicatorId = $('#IndicatorId').val();

    if (CARFromdate != null && CARFromdate != "" && CARTodate != null && CARTodate != "") {
        var ActiveFromDate = new Date(getDateToCompare($('#CARFromdate').val()));
        var ActiveToDate = new Date(getDateToCompare($('#CARTodate').val()));

        if (ActiveFromDate > ActiveToDate) {
            $('#myPleaseWait').modal('hide');
            $('#CARTodate').parent().addClass('has-error');
            $("div.errormsgcenter").text("To Date Should be greater than are equal to From Date");
            $('#errorMsg').css('visibility', 'visible');
            $('#btnCARptFetch').attr('disabled', false);
            $("#CARFromdate").prop("disabled", false);
            $("#CARTodate").prop("disabled", false);
            $("#IndicatorId").prop("disabled", false);
            return false;
        }
        else {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');
            $('#CARTodate').parent().removeClass('has-error');

        }
    }

    var loc = '/Report/CARSummaryReport.aspx?CARFromdate=' + $('#CARFromdate').val() + '&CARTodate=' + $('#CARTodate').val()
    + '&IndicatorId=' + $('#IndicatorId').val();

    document.getElementById('ReportFrame').setAttribute('src', loc);
    $("#btnCARRptCancel").css("visibility", "visible");
    
}


