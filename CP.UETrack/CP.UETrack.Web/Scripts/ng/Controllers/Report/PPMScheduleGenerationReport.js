$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnPPMScheduleRptCancel").click(function () {
        window.location.href = " ";
    });

});

function getPPMScheduleGenerationReport() {

    var loc = '/Report/PPMScheduleGenerationReport.aspx?PPMScheduleWorkOrderId=' + $('#PPMScheduleworkorderid').val();

    document.getElementById('ReportFrame').setAttribute('src', loc);
}

