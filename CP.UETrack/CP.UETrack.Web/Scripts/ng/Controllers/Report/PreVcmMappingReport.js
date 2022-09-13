$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnPreVcmRpt1Cancel").click(function () {
        window.location.href = " ";
    });

});

function getPreVcmReport() {

    $('#btnPreVcmRptFetch').attr('disabled', true);
    $("#VCMyear").prop("disabled", true);
    $("#VCMmonth").prop("disabled", true);

    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');

    var isFormValid = true;
    isFormValid = formInputValidation("VcmFormId", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnPreVcmRptFetch').attr('disabled', false);
        $("#VCMyear").prop("disabled", false);
        $("#VCMmonth").prop("disabled", false);
        return false;
    }
    else {
        $('#VCMyear').parent().removeClass('has-error');
        $('#VCMmonth').parent().removeClass('has-error');
        $('#myPleaseWait').modal('hide');
    }

    var CARFromdate = $('#CARFromdate').val();
    var CARTodate = $('#CARTodate').val();
    var IndicatorId = $('#IndicatorId').val();



    var loc = '/Report/PreVcmMappingReport.aspx?VCMYear=' + $('#VCMyear').val() + '&VCMMonth=' + $('#VCMmonth').val();

    document.getElementById('ReportFrame').setAttribute('src', loc);
    $("#btnPreVcmRpt1Cancel").css("visibility", "visible");
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