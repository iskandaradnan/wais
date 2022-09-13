//*Global variables decration section starts*//
var pageindex = 1, pagesize = 5;
var GridtotalRecords = 0;
var TotalPages = 0, FirstRecord = 0, LastRecord = 0;
//*Golbal variables decration section ends*//
var CompletionDetails = [];
var PartReplacementDetails = [];
var PartReplacementPopUpDetails = [];
var TransferDetails = [];
var CompletionInfoId = 0;
var WOTransferId = 0;
var TypeOfWorkOrder = 0;
var WorkOrderNo = null;
var WorkOrderStatus = 0;
var WorkOrderStatusString = 0;
var CompletionInfoDetId = 0;
var AssessmentId = 0;
var PartReplacementId = 0;
var ListModel = [];
var GlobalWorkOrderNo = null;
var GlobalWorkOrderDate = null;
var Submitted = 0;

$(function () {
    $('#btnEdit').hide();
    $('#btnCancel').hide();
    $('#myPleaseWait').modal('show');
    formInputValidation("formmanualassign");
  //  $("#formmanualassign :input").prop("disabled", true);
    $("#txtAssignee").prop("disabled", true);
    $.get("/api/Manualassign/Load")
         .done(function (result) {
             $('#errorMsg').css('visibility', 'hidden');
             var loadResult = JSON.parse(result);
             $("#jQGridCollapse1").click();
             $.each(loadResult.WorkOrderCategoryList, function (index, value) {
                 $('#WorkOrderCategory').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
             });
             $.each(loadResult.WorkOrderPriorityList, function (index, value) {
                 $('#WorkOrderPriority').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
             });

             //var primaryId = $('#primaryID').val();
             //if (primaryId != null && primaryId != "0") {
             //    $.get("/api/ScheduledWorkOrder/Get/" + primaryId)
             //      .done(function (result) {
             //          var htmlval = "";
             //          var getResult = JSON.parse(result);
             //          TypeOfWorkOrder = getResult.TypeOfWorkOrder;
             //          WorkOrderStatus = getResult.WorkOrderStatus
             //          GlobalWorkOrderNo = getResult.WorkOrderNo;
             //          GlobalWorkOrderDate = getResult.PartWorkOrderDate;
             //          WorkOrderStatusString = getResult.WorkOrderStatusValue;
             //          $("label[for='WOStatus']").html(getResult.WorkOrderStatusValue);
             //          $('#hdnAssetId').val(getResult.AssetRegisterId);
             //          $('#txtAssetNo').val(getResult.AssetNo);
             //          $('#txtModel').val(getResult.Model);
             //          $('#txtManufacturer').val(getResult.Manufacturer);
             //          $('#hdnRequestorId').val(getResult.RequestorId);
             //          $('#txtRequestor').val(getResult.Requestor);
             //          WorkOrderNo=getResult.WorkOrderNo;
             //          $('#WorkOrderCategory').val(getResult.MaintenanceType);
             //          $('#WorkOrderPriority').val(getResult.WorkOrderPriority);
             //         // $('#txtWorkOrderStatus').val(getResult.WorkOrderStatusValue);
             //          $('#txtMaintainanceDetails').val(getResult.MaintenanceDetails);
             //          $('#primaryID').val(getResult.WorkOrderId);
             //          $("#Timestamp").val(getResult.Timestamp);
             //          $('#txtAssetNo').prop('disabled', true);
             //          $('#myPleaseWait').modal('hide');
             //      })
             //     .fail(function (response) {
             //         $('#myPleaseWait').modal('hide');
             //         $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
             //         $('#errorMsg').css('visibility', 'visible');
             //     });
             //}
             //else {
             //    $('#myPleaseWait').modal('hide');
             //}
         })
  .fail(function (response) {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
      $('#errorMsg').css('visibility', 'visible');
  });

    $("#btnSave,#btnEdit,#btnSaveandAddNew").click(function () {
        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var CurrentbtnID = $(this).attr("Id");
        var isFormValid = formInputValidation("formmanualassign", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var primaryId = $("#primaryID").val();
        var AssetId = $('#hdnAssetId').val();
        var AssingnId = $('#hdnAssingnId').val();
        var RequestorId = $('#hdnRequestorId').val();
        var MaintainanceType = $('#WorkOrderCategory').val();
        //var WorkOrderPriority = $('#WorkOrderPriority').val();
        var MaintainanceDetails = $('#txtMaintainanceDetails').val();
        //var WorkOrderNo = $('#txtWorkOrderNo').val();

        var Timestamp = $('#Timestamp').val();
        
        var obj = {
            WorkOrderId: primaryId,          
            AssetRegisterId: AssetId,
            AssingnId:AssingnId,
            RequestorId: RequestorId,
            MaintenanceDetails: MaintainanceDetails,
            WorkOrderType: 188,
            Timestamp: Timestamp,
        };


        var jqxhr = $.post("/api/Manualassign/Add", obj, function (response) {
            var getResult = JSON.parse(response);
            TypeOfWorkOrder = getResult.TypeOfWorkOrder;
            WorkOrderStatus = getResult.WorkOrderStatus;           
            $('#btnEdit').hide();
            $('#btnCancel').hide();
            $("label[for='WOStatus']").html(getResult.WorkOrderStatusValue);
            $("#primaryID").val(getResult.WorkOrderId);
            $('#hdnAssetId').val(getResult.AssetRegisterId);
            $('#hdnAssingnId').val(getResult.AssignedUserId);
            $('#txtAssignee').val(getResult.Assignee);
            $('#txtAssetNo').val(getResult.AssetNo);
            $('#txtModel').val(getResult.Model);
            $('#txtManufacturer').val(getResult.Manufacturer);
            $('#hdnRequestorId').val(getResult.RequestorId);
            $('#txtRequestor').val(getResult.Requestor);
            WorkOrderNo = getResult.WorkOrderNo;
            $('#WorkOrderCategory').val(getResult.MaintenanceType);
            $('#WorkOrderPriority').val(getResult.WorkOrderPriority);
            //$('#txtWorkOrderStatus').val(getResult.WorkOrderStatusValue);
            $('#txtMaintainanceDetails').val(getResult.MaintenanceDetails);           
            $("#Timestamp").val(getResult.Timestamp);
            $("#grid").trigger('reloadGrid');
            if (getResult.WorkOrderId != 0) {
                $('#btnEdit').show();
                $('#txtAssetNo').prop('disabled', true);
            }
            $(".content").scrollTop(0);
            showMessage('Manualassign', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            if (CurrentbtnID == "btnSaveandAddNew") {
                EmptyFields();
            }
        },
       "json")
        .fail(function (response) {
            var errorMessage = "";
            if (response.status == 400) {
                errorMessage = response.responseJSON;
            }
            else {
                errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
            }
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
    });


    //fetch - Assignee   
var ManualFetchObj = {
    SearchColumn: 'txtAssignee-StaffName',
    ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-StaffName'],
    FieldsToBeFilled: ["hdnAssingnId-StaffMasterId", "txtAssignee-StaffName"]
    };

    $('#txtAssignee').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divAssigneeFetch', ManualFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetchAssignee", event, 1);
    });


    //fetch - Requestor 
    //var RequestorFetchObj = {
    //    SearchColumn: 'txtRequestor-Requestor',//Id of Fetch field
    //    ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-StaffName'],
    //    FieldsToBeFilled: ["hdnRequestorId-StaffMasterId", "txtRequestor-StaffName"]
    //};

    //$('#txtRequestor').on('input propertychange paste keyup', function (event) {
    //    DisplayFetchResult('divRequestorFetch', RequestorFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch2", event, 1);//1 -- pageIndex
    //});


    $("#btnCancel").click(function () {
        var message = Messages.Reset_Alert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                EmptyFields();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });

    });
    $("#jQGridCollapse1").click(function () {
        // $(".jqContainer").toggleClass("hide_container");
        var pro = new Promise(function (res, err) {
            $(".jqContainer").toggleClass("hide_container");
            res(1);
        })
        pro.then(
            function resposes() {
                setTimeout(() => $(".content").scrollTop(3000), 1);
            })
    })

    $('.wt-resize').on('paste input', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^&*_+=|\\{}\[\]?<>/\^]/g, ''));
        }, 5);
    });

   
});

//fetch - Assigned Person 
var AssignedPersonFetchObj = {
    SearchColumn: 'TransferAssignedPerson-TransferAssignedPerson',//Id of Fetch field
    ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-StaffName'],
    FieldsToBeFilled: ["hdnTransferAssignedPersonId-StaffMasterId", "TransferAssignedPerson-StaffName"]
};

function LinkClicked(id, rowData) {
    $(".content").scrollTop(1);
    $('#btnEdit').show();
    $("#txtAssignee").prop("disabled", false);
    $('.nav-tabs a:first').tab('show');
    $("#formmanualassign :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission ) {
        action = "Edit"

    }
    else if (!hasEditPermission && hasViewPermission) {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#btnEdit').show();
        $('#btnCancel').show();
    }

    if (action == 'View') {
        $("#formBemsLevel :input:not(:button)").prop("disabled", true);
    }
    else if (action != 'View' && (rowData.WorkOrderStatus == "Cancelled" || rowData.WorkOrderStatus == "Closed")) {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnSaveandAddNew').hide();
        $('#btnCancel').show();
        //$('#crmWorkStfAss').prop("disabled", true);
        //$('#crmWorkStfAss').prop("disabled", true);


    }
    else {
        $('#btnEdit').show();
        $('#btnSave').hide();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/Manualassign/Get/" + primaryId)
          .done(function (result) {
              var htmlval = "";
              var getResult = JSON.parse(result);
              TypeOfWorkOrder = getResult.TypeOfWorkOrder;
              WorkOrderStatus = getResult.WorkOrderStatus
              GlobalWorkOrderNo = getResult.WorkOrderNo;
              GlobalWorkOrderDate = getResult.PartWorkOrderDate;
              WorkOrderStatusString = getResult.WorkOrderStatusValue;
              $("label[for='WOStatus']").html(getResult.WorkOrderStatusValue);
              $('#hdnAssetId').val(getResult.AssetRegisterId);
              $('#hdnAssingnId').val(getResult.AssignedUserId);
              $('#txtAssignee').val(getResult.Assignee);
              $('#txtAssetNo').val(getResult.AssetNo);
              $('#WorkOrderId').val(primaryId);
              $('#txtModel').val(getResult.Model);
              $('#txtManufacturer').val(getResult.Manufacturer);
              $('#hdnRequestorId').val(getResult.RequestorId);
              $('#txtRequestor').val(getResult.Requestor);
              WorkOrderNo = getResult.WorkOrderNo;
              $('#WorkOrderCategory').val(getResult.MaintenanceType);
              $('#WorkOrderPriority').val(getResult.WorkOrderPriority);
              // $('#txtWorkOrderStatus').val(getResult.WorkOrderStatusValue);
              $('#txtMaintainanceDetails').val(getResult.MaintenanceDetails);
              //$('#primaryID').val(getResult.WorkOrderId);
              $("#Timestamp").val(getResult.Timestamp);
              $('#txtAssetNo').prop('disabled', true);
              $('#myPleaseWait').modal('hide');
          })
         .fail(function (response) {
             $('#myPleaseWait').modal('hide');
             $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
             $('#errorMsg').css('visibility', 'visible');
         });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}

function EmptyFields() {
    $(".content").scrollTop(0);
    $('input[type="text"], textarea').val('');
    $('.ui-tabs-hide').empty();
    $('#btnEdit').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#WorkOrderCategory").val('null');
    $("#WorkOrderPriority").val('null');
    $("#grid").trigger('reloadGrid');
    $("#formmanualassign :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
}




