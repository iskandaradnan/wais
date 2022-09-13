$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnVertificationApprovedRptCancel").click(function () {
        window.location.href = " ";
    });

});

function getVertificationApprovedReport() {

    var loc = '/Report/VerificationApprovedReport.aspx?VAPeriod=' + $('#VAperiod').val() + '&VAYear=' + $('#VAyear').val() + '&VAFromDate=' + $('#VAfromdate').val() + '&VAToDate=' + $('#VAtodate').val() + '&VAStatus=' + $('#VAstatus').val();

    document.getElementById('ReportFrame').setAttribute('src', loc);
}

