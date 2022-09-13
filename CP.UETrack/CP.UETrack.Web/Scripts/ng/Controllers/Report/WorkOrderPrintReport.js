$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnWorkOrderPrintRptCancel").click(function () {
        window.location.href = " ";
    });

});

function getWorkOrderPrintReport() {

    var loc = '/Report/WorkOrderPrintReport.aspx?PrintWorkOrderId=' + $('#Printworkorderid').val();

    document.getElementById('ReportFrame').setAttribute('src', loc);
}

