$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnOthersRptCancel").click(function () {
        window.location.href = " ";
    });

});

function getOthersPlannerReport() {

    var loc = '/Report/OthersPlannerReport.aspx?OtherWorkGroupId=' + $('#Otherworkgroupid').val() + '&OtherYear=' + $('#Otheryear').val() + '&OtherTypePlanner=' + $('#Othertypeplanner').val();

    document.getElementById('ReportFrame').setAttribute('src', loc);
}
