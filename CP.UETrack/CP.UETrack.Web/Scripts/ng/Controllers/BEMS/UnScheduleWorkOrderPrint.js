var ID = $('#hdnUnScheduleWOID').val();
$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $('#btnUnScheduleWORptCancel').click(function () {
        window.location.href = "/bems/unscheduledworkorder";
    });

    var loc = '/Report/UnScheduleWorkOrderPrint.aspx?UnScheduleWorkorderId=' + ID;
    $('#ReportFrame').attr('src', loc);
    //  document.getElementById('ReportFrame').setAttribute('src', loc);
});