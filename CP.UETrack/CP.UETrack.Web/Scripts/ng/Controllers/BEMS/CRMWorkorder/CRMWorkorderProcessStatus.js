
$(document).ready(function () {
    $("#btnCancelPrsSts").click(function () {

        var message = Messages.Reset_TabAlert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                window.location.href = "/bems/CRMWorkorder";
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
        
    });
});

function loadProcessStatusTab() {
    $('#myPleaseWait').modal('show');

    $("div.errormsgcenter").text("");
    $('#errorMsgAssm').css('visibility', 'hidden');

    var AssessmentTabPrimaryId = $('#hdncrmAssTabAssId').val();

    //formInputValidation("CRMAssessmentPage");

    var primaryId = $('#primaryID').val();      //Workorder Id

    $.get("/api/CRMWorkorderTab/GetProcessStatus/" + primaryId)
   .done(function (result) {
       var result = JSON.parse(result);
       //$("#jQGridCollapse1").click();
       //$.each(getResult.CRMProcessStatusData, function (index, value) {

       //if (result.CRMProcessStatusData > 0) {
               GetCRMProcessStatusBind(result)
           //}
           //else {
           //    $('#myPleaseWait').modal('hide');
           //}
      // });

       $('#myPleaseWait').modal('hide');
   })
   .fail(function (response) {
       $('#myPleaseWait').modal('hide');
       $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
       $('#errorMsgAssm').css('visibility', 'visible');
   });
    $('#myPleaseWait').modal('hide');
}


function GetCRMProcessStatusBind(getResult) {
    var primaryId = $('#primaryID').val();

    var WorkOrdNo = $('#crmWorkWorkOrdNo').val();
    var crmReqNo = $('#crmWorkReqNo').val();

    $("#CRMWorkPrsStsWrkNo").val(WorkOrdNo).prop("disabled", "disabled");
    $("#CRMWorkPrsStsReqNo").val(crmReqNo).prop("disabled", "disabled");
    $("#CRMProcessStatusBody").empty();

    $.each(getResult.CRMProcessStatusData, function (index, value) {
        AddNewRowCRMProcessSts();
        $("#CRMWorkPrsStsStatus_" + index).val(getResult.CRMProcessStatusData[index].WorkOrderStatus).prop("disabled", "disabled");
        $("#CRMWorkPrsStsStaff_" + index).val(getResult.CRMProcessStatusData[index].StaffName).prop("disabled", "disabled");
        $("#CRMWorkPrsStsDoneby_" + index).val(getResult.CRMProcessStatusData[index].DoneBy).prop("disabled", "disabled");
        $("#CRMWorkPrsStsDesig_" + index).val(getResult.CRMProcessStatusData[index].Designation).prop("disabled", "disabled");
        var a = moment.utc(getResult.CRMProcessStatusData[index].Date).toDate();
        $("#CRMWorkPrsStsDate_" + index).val(moment(a).format("DD-MMM-YYYY HH:mm")).prop("disabled", "disabled");
    });
}

function AddNewRowCRMProcessSts() {
    var inputpar = {
        inlineHTML: ProcessStatus(),
        IdPlaceholderused: "maxindexval",
        TargetId: "#CRMProcessStatusBody",
        TargetElement: ["tr"]
    }

    AddNewRowToDataGrid(inputpar);
    formInputValidation("CRMProcessStatusPage");
}

function ProcessStatus() {

    return ' <tr class="ng-scope" style=""><td width="20%" style="text-align: center;"><div> <input type="text" id="CRMWorkPrsStsStatus_maxindexval" name="SystemTypeCode" class="form-control" autocomplete="off"></div></td> \
                <td width="20%" style="text-align: center;"><div> <input id="CRMWorkPrsStsStaff_maxindexval"type="text" class="form-control" name="SystemTypeDescription" autocomplete="off" ></div></td> \
                <td width="20%" style="text-align: center;"><div> <input id="CRMWorkPrsStsDoneby_maxindexval"type="text" class="form-control" name="SystemTypeDescription" autocomplete="off" ></div></td> \
                <td width="20%" style="text-align: center;"><div> <input type="text" id="CRMWorkPrsStsDesig_maxindexval" name="SystemTypeCode" class="form-control" autocomplete="off"></div></td> \
                <td width="20%" style="text-align: center;"><div> <input id="CRMWorkPrsStsDate_maxindexval" type="text" class="form-control datatimepicker" name="SystemTypeDescription" autocomplete="off"></div></td></tr>'
}