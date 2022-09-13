$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnDeductionRptCancel").click(function () {
        window.location.href = " ";
    });

});

function getDeductionReport() {

    var loc = '/Report/DeductionSummaryReport.aspx?DedSummaryFromMonth=' + $('#DedSummaryfrommonth').val() + '&DedSummaryToMonth=' + $('#DedSummarytomonth').val() + '&DedSummaryYear=' + $('#DedSummaryyear').val();

    document.getElementById('ReportFrame').setAttribute('src', loc);
}

