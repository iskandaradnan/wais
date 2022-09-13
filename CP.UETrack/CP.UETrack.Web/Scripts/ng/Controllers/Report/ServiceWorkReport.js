$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnServiceWorkRptCancel").click(function () {
        window.location.href = " ";
    });

});

function getServiceWorkReport() {

    var loc = '/Report/ServiceWorkReport.aspx?ServiceFromDate=' + $('#Servicefromdate').val() + '&ServiceToDate=' + $('#Servicetodate').val() + '&ServiceStatus=' + $('#Servicestatus').val();

    document.getElementById('ReportFrame').setAttribute('src', loc);
}

