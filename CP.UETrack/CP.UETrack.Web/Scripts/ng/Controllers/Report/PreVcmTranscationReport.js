$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnPreVcmRptCancel").click(function () {
        window.location.href = " ";
    });

});

function getPreVcmReport() {

    var loc = '/Report/PreVcmTranscationReport.aspx?Fromdate=' + $('#Assetfromdate').val() + '&Todate=' + $('#AssetTodate').val();

    document.getElementById('ReportFrame').setAttribute('src', loc);
}

