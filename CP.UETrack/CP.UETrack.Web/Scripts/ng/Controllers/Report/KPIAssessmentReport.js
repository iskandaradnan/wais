$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnKPICancel").click(function () {
        window.location.href = " ";
    });

});

function getKPIReport() {

    $('#btnKPIRptFetch').attr('disabled', true);
    $("#VCMyear").prop("disabled", true);
    $("#VCMmonth").prop("disabled", true);

    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');

    var isFormValid = true;
    isFormValid = formInputValidation("KPIAssessmentFormId", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnKPIRptFetch').attr('disabled', false);
        $("#VCMyear").prop("disabled", false);
        $("#VCMmonth").prop("disabled", false);
        return false;
    }
    else {
        $('#VCMyear').parent().removeClass('has-error');
        $('#VCMmonth').parent().removeClass('has-error');
        $('#myPleaseWait').modal('hide');
    }
    var loc = '/Report/KPIAssessmentReport.aspx?VCMYear=' + $('#VCMyear').val() + '&VCMMonth=' + $('#VCMmonth').val();

    document.getElementById('ReportFrame').setAttribute('src', loc);
    $("#btnKPICancel").css("visibility", "visible");
}

$('#VCMyear').change(function () {
    var value = $('#VCMyear').val();
    if (value != '' && value != "null" && value != null && value != undefined) {
        $('#VCMyear').parent().removeClass('has-error');
    }


});
$('#VCMmonth').change(function () {
    var value = $('#VCMmonth').val();
    if (value != '' && value != "null" && value != null && value != undefined) {
        $('#VCMmonth').parent().removeClass('has-error');
    }


})