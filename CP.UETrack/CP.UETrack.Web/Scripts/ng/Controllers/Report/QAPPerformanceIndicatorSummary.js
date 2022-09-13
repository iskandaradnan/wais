$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnCancel").click(function () {
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

function getReport() {

    $('#btnFetch').attr('disabled', true);
    $("#VOVFromyear").prop("disabled", true);
    $("#VOVFrommonth").prop("disabled", true);
    $("#VOVToyear").prop("disabled", true);
    $("#VOVTomonth").prop("disabled", true);
    $("#IndicatorId").prop("disabled", true);    
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');

    // var fromdate = $('#BerFromdate').val();
    //var todate = $('#BerTodate').val();
    var isFormValid = true;
    isFormValid = formInputValidation("QAPPerFormId", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnVerificationRptFetch').attr('disabled', false);
        $("#VOVFromyear").prop("disabled", false);
        $("#VOVFrommonth").prop("disabled", false);
        $("#VOVToyear").prop("disabled", false);
        $("#VOVTomonth").prop("disabled", false);
        $("#IndicatorId").prop("disabled", false);
        return false;
    }
    else {
        $('#myPleaseWait').modal('hide');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        
    }   
    var loc = '/Report/QAPPerformanceIndicatorSummary.aspx?FromYear=' + $('#VOVFromyear').val()
        + '&FromMonth=' + $('#VOVFrommonth').val()
    + '&ToYear=' + $('#VOVToyear').val()
     +'&IndicatorId=' + $('#IndicatorId').val()
    + '&Tomonth=' + $('#VOVTomonth').val();

    document.getElementById('ReportFrame').setAttribute('src', loc);
    $("#btnVerificationRptCancel").css("visibility", "visible");
}

$('#VOVFromyear').change(function () {
    var value = $('#VOVFromyear').val();
    if (value != '' && value != "null" && value != null && value != undefined) {
        $('#VOVFromyear').parent().removeClass('has-error');
    }
});
$('#VOVFrommonth').change(function () {
    var value = $('#VOVFrommonth').val();
    if (value != '' && value != "null" && value != null && value != undefined) {
        $('#VOVFrommonth').parent().removeClass('has-error');
    }
});
$('#IndicatorId').change(function () {
    var value = $('#IndicatorId').val();
    if (value != '' && value != "null" && value != null && value != undefined) {
        $('#IndicatorId').parent().removeClass('has-error');
    }
});
$('#VOVToyear').change(function () {
    var value = $('#VOVToyear').val();
    if (value != '' && value != "null" && value != null && value != undefined) {
        $('#VOVToyear').parent().removeClass('has-error');
    }
});
$('#VOVTomonth').change(function () {
    var value = $('#VOVTomonth').val();
    if (value != '' && value != "null" && value != null && value != undefined) {
        $('#VCMmVOVTomonthonth').parent().removeClass('has-error');
    }
});
