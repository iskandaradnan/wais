$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnRIRptCancel").click(function () {
        window.location.href = " ";
    });

});

function getRIPlannerReport() {

    var loc = '/Report/RIPlannerReport.aspx?RIWorkGroupId=' + $('#RIworkgroupid').val() + '&RIYear=' + $('#RIyear').val();

    document.getElementById('ReportFrame').setAttribute('src', loc);
}

