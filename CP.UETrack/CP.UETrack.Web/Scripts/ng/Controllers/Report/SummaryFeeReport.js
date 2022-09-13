$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnSummaryFeeRptCancel").click(function () {
        window.location.href = " ";
    });

});

function getSummaryFeeReport() {

    var loc = '/Report/SummaryFeeReport.aspx?Fromdate=' + $('#Assetfromdate').val() + '&Todate=' + $('#AssetTodate').val();

    document.getElementById('ReportFrame').setAttribute('src', loc);
}

