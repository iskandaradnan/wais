var ID = $('#hdnScheduleWOID').val();
$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $('#btnScheduleWORptPrintCancel').click(function () {
        window.location.href = "/bems/scheduledworkorder";
    });
   
    var loc = '/Report/ScheduleWorkOrderPrint.aspx?ScheduleWorkorderId=' + ID;
    $('#ReportFrame').attr('src', loc);
    //  document.getElementById('ReportFrame').setAttribute('src', loc);
});