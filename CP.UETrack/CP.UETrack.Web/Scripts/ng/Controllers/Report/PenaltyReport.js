$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnPenaltyRptCancel").click(function () {
        window.location.href = " ";
    });

});

function getPenaltyReport() {

    var loc = '/Report/PenaltyReport.aspx?Fromdate=' + $('#Assetfromdate').val() + '&Todate=' + $('#AssetTodate').val();

    document.getElementById('ReportFrame').setAttribute('src', loc);
}

