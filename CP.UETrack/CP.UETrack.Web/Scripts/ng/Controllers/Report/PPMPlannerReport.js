$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnPPMRptCancel").click(function () {
        window.location.href = " ";
    });

});

function getPPMPlannerReport() {

    var loc = '/Report/PPMPlannerReport.aspx?WorkGroupid=' + $('#workgroupid').val() + '&PlannerYear=' + $('#plannerYear').val();

    document.getElementById('ReportFrame').setAttribute('src', loc);
}

