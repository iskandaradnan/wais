$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnBer1PrintRptCancel").click(function () {
        window.location.href = " ";
    });

});

function getBer1PrintReport() {

    var loc = '/Report/Ber1PrintReport.aspx?BERPrintAppId=' + $('#BERPrintappid').val();

    document.getElementById('ReportFrame').setAttribute('src', loc);
}

