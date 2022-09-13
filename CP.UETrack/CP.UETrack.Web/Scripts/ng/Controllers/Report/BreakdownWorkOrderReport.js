$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnBreakdownWorkRptCancel").click(function () {
        window.location.href = " ";
    });
    $.get("/api/ScheduledWorkOrder/Load")
       .done(function (result) {
           var loadResult = JSON.parse(result);
           //$("#jQGridCollapse1").click();
           LOVlist = loadResult;

           $.each(loadResult.WorkOrderPriorityList, function (index, value) {
               $('#WorkOrderPriorityId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
           });
           $.each(loadResult.WorkOrderCategoryList, function (index, value) {
               $('#WorkOrderCategoryId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
           });
       })
.fail(function (response) {
    $('#myPleaseWait').modal('hide');
    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
    $('#errorMsg').css('visibility', 'visible');
});
});

function getBreakdownWorkOrderReport() {


    $('#btnBreakdownWorkRptFetch').attr('disabled', true);
    $("#WorkOrderPriorityId").prop("disabled", true);
    $("#WorkOrderCategoryId").prop("disabled", true);
    $("#WOfromdate").prop("disabled", true);
    $("#WOtodate").prop("disabled", true);

    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');

    var fromdate = $('#WOfromdate').val();
    var todate = $('#WOtodate').val();
    var isFormValid = true;
    isFormValid = formInputValidation("unshceduledform", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnBreakdownWorkRptFetch').attr('disabled', false);
        $("#WorkOrderPriorityId").prop("disabled", false);
        $("#WorkOrderCategoryId").prop("disabled", false);
        $("#WOfromdate").prop("disabled", false);
        $("#WOtodate").prop("disabled", false);
        return false;
    }
    else {
        $('#myPleaseWait').modal('hide');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $('#WOtodate').parent().removeClass('has-error');
    }


    if (fromdate != null && fromdate != "" && todate != null && todate != "") {
        var ActiveFromDate = new Date(getDateToCompare($('#WOfromdate').val()));
        var ActiveToDate = new Date(getDateToCompare($('#WOtodate').val()));

        if (ActiveFromDate > ActiveToDate) {
            $('#myPleaseWait').modal('hide');
            $('#WOtodate').parent().addClass('has-error');
            $("div.errormsgcenter").text("To Date Should be greater than are equal to From Date");
            $('#errorMsg').css('visibility', 'visible');
            $('#btnBreakdownWorkRptFetch').attr('disabled', false);
            $("#WorkOrderPriorityId").prop("disabled", false);
            $("#WorkOrderCategoryId").prop("disabled", false);
            $("#WOfromdate").prop("disabled", false);
            $("#WOtodate").prop("disabled", false);
            return false;
        }
        else {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');
            $('#WOtodate').parent().removeClass('has-error');
        }
    }


    var loc = '/Report/BreakdownWorkOrderReport.aspx?WorkOrderCategoryId=' + $('#WorkOrderCategoryId').val()
    + '&WorkOrderPriorityId=' + $('#WorkOrderPriorityId').val() + '&WOFromDate=' 
    + $('#WOfromdate').val() + '&WOToDate=' + $('#WOtodate').val();
    document.getElementById('ReportFrame').setAttribute('src', loc);
    $("#btnBreakdownWorkRptCancel").css("visibility", "visible");
}

