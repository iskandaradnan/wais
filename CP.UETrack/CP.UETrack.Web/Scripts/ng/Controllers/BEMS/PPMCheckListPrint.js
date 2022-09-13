var WOID = $("#hdnPPMWorkOrderID").val();
var ID = $('#hdnPPMCheckListID').val();

$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $('#btnPPMCheckListRptCancel').click(function () {
        window.location.href = "/bems/scheduledworkorder";
    });

    var loc = '/Report/PPMCheckListPrint.aspx?PPMWOId=' + WOID + '&PPMCheckListId=' + ID;
    $('#ReportFrame').attr('src', loc);
    //  document.getElementById('ReportFrame').setAttribute('src', loc);
    //Fromdate=' + $('#Assetfromdate').val() + '&Todate=' + $('#AssetTodate').val();
});