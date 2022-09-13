//*Global variables decration section starts*//
var pageindex = 1, pagesize = 5;
var GridtotalRecords = 0;
var UserRoleGlobal = null;
var TotalPages = 0, FirstRecord = 0, LastRecord = 0;
//*Golbal variables decration section ends*//
var CompletionDetails = [];
var PurchaseRequestDetails = [];
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
var EngineerId = 0;
var PartReplacementId = 0;
var ListModel = [];
var GlobalWorkOrderNo = null;
var GlobalWorkOrderDate = null;
var GlobalAssetNo = null;
var GlobalAssignee = null;
var GlobalAssetDescription = null;
var Submitted = 0;
window.StockTypeListGloabal = [];
var GlobalRunningHoursCapture = 0;
var GlobalWorkOrderId = 0;
var GlobalDownTime = null;
FromNotification = false;
var IsExternal = false;
var hasApproveRolePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");

$(function () {
    //$(".nav-tabs > li:not(:first-child)").click(function () {
    //    var primaryId = $('#primaryID').val();
    //    if (primaryId == 0) {
    //        bootbox.alert("Save the details before moving on to Other!");
    //        return false;
    //    }
    //});   
    $('#btnDelete').text('Cancel');
    $('#btnCancelApprove').hide();
    $('#btnCancelReject').hide();
    $('#txtremarks').prop('disabled', true);
    $('#txtremarks').prop('required', false);
    $('#ApproveCancelRemarks').css('visibility', 'hidden');
    $('#CancelRequestRemarks').css('visibility', 'hidden');
    if (AssessmentId != 0 || AssessmentId != "" || AssessmentId != "0") {
        $('#WorkOrderPriority').prop('disabled', true);
        $('#txtRequestor').prop('disabled', true);
        $('#txtEngineer').prop('disabled', true);
        $('#WorkOrderCategory').prop('disabled', true);
        $('#txtMaintainanceDetails').prop('disabled', true);
    }
    //$('#txtRunningHours').val("00:00");
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    //$('#btnUnSWOPrint').hide();
    $("textarea[id^='txtMaintainanceDetails']").attr('pattern', '^[a-zA-Z0-9&quot;,:;/\(\),\.\\\\-\\s\!&#64;\#\$\%\&\*]+$');
    $('#myPleaseWait').modal('show');
    formInputValidation("formScheduledWorkOrder");
    formInputValidation("tab-2");
    formInputValidation("tab-3");
    formInputValidation("tab-4");
    formInputValidation("tab-5");

    $.get("/api/ScheduledWorkOrder/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            if (!loadResult.IsAdditionalFieldsExist) {
                $('#liAFAdditionalInfo').hide();
            }
            $.each(loadResult.WorkOrderCategoryList, function (index, value) {
                $('#WorkOrderCategory').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.WorkOrderPriorityList, function (index, value) {
                $('#WorkOrderPriority').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.ReasonList, function (index, value) {
                $('#Reason').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.StatusList, function (index, value) {
                $('#Status').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.QCCodeList, function (index, value) {
                $('#QCDescription').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.CauseCodeList, function (index, value) {
                $('#CauseCodeDescription').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.TransferReasonList, function (index, value) {
                $('#TransferReason').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.RealTimeStatusList, function (index, value) {
                $('#RealTimeStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.PartReplacementCostInvolvedList, function (index, value) {
                $('#ChangeToVendor').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.CustomerFeedbak, function (index, value) {
                $('#selCustomerFeedback').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.WorkGroupVaule, function (index, value) {
                $('#selWorkGroupfems').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            window.StockTypeListGloabal = loadResult.StockTypeList;
            IsExternal = loadResult.IsExternal ? true : false;
            $('#ChangeToVendor').val(100);
            $('#VendorHide').hide();
            $('#txtVendor').prop('required', false);
            $('#txtVendor').prop('disabled', false);


            $('#ReasonStarHide').hide();
            $('#Reason').prop('required', false);
            $('#btnUnSWOPrint').hide();
            $('#divAssetStatus1').hide();
            var workOrderId = $('#hdnWorkOrderId').val();
            if (workOrderId != null && workOrderId != "" && workOrderId != "0") {
                var rowData1 = {};
                LinkClicked(workOrderId, rowData1)
            } else {
                $("#jQGridCollapse1").click();
            }
            if (IsExternal) {
                $('#btnSave').hide();
                $('#btnSaveandAddNew').hide();
            }
            $('#WorkOrderPriority').val(227);
        })
        .fail(function (response) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            $('#errorMsg').css('visibility', 'visible');
        });

    $("#btnSave,#btnSaveandAddNew",).click(function () {
        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var CurrentbtnID = $(this).attr("Id");
        var isFormValid = formInputValidation("formScheduledWorkOrder", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var primaryId = $("#primaryID").val();
        var AssetId = $('#hdnAssetId').val();
        var RequestorId = $('#hdnRequestorId').val();
        var MaintainanceType = $('#WorkOrderCategory').val();
        var WorkGroupVaule = $('#selWorkGroupfems').val();
        var WorkOrderPriority = $('#WorkOrderPriority').val();
        var MaintainanceDetails = $('#txtMaintainanceDetails').val();
        EngineerId = $('#hdnEngineerId').val();
        //var today = GetCurrentDate();
        //var Currentdate = Date.parse(today);  
        //alert(Currentdate);
        //var WorkOrderNo = $('#txtWorkOrderNo').val();

        var today = new Date();
        var CurDate = GetCurrentDate();
        var hour = today.getHours();
        var time = today.getMinutes();
        var time = time.toString();

        if (time.length == 1) {
            time = 0 + '' + time;
        }

        var gettime = hour + ":" + time;

        var CurDateTime = CurDate + " " + gettime;

        var Timestamp = $('#Timestamp').val();

        var obj = {
            WorkOrderId: primaryId,
            WorkOrderNo: WorkOrderNo,
            AssetRegisterId: AssetId,
            EngineerId: EngineerId,
            RequestorId: RequestorId,
            MaintenanceType: MaintainanceType,
            WorkOrderPriority: WorkOrderPriority,
            TypeOfWorkOrder: TypeOfWorkOrder,
            WorkOrderStatus: WorkOrderStatus,
            MaintenanceDetails: MaintainanceDetails,
            WorkOrderType: 188,
            WorkGroupVaule: WorkGroupVaule,
            TargetDate: null,
            Timestamp: Timestamp,
            PartWorkOrderDate: CurDateTime

        };


        var jqxhr = $.post("/api/ScheduledWorkOrder/Add", obj, function (response) {
            var getResult = JSON.parse(response);
            TypeOfWorkOrder = getResult.TypeOfWorkOrder;
            WorkOrderStatus = getResult.WorkOrderStatus;
            GlobalWorkOrderDate = moment(getResult.PartWorkOrderDate).format("DD-MMM-YYYY HH:mm");
            $('#hdnAttachId').val(getResult.HiddenId);
            //$("label[for='WOStatus']").html(getResult.WorkOrderStatusValue);
            $('.divWOStatus').text(getResult.WorkOrderStatusValue);
            WorkOrderStatusString = getResult.WorkOrderStatusValue;
            $('#divAssetStatus').text(getResult.AssetWorkingStatusValue);
            if (getResult.AssetWorkingStatusValue == "") {
                $('#divAssetStatus1').hide();
            }
            else {
                $('#divAssetStatus1').show();
            }
            $("#primaryID").val(getResult.WorkOrderId);
            GlobalWorkOrderId = getResult.WorkOrderId;
            $('#hdnAssetId').val(getResult.AssetRegisterId);
            $('#txtAsset_Name').val(getResult.AssetName);
            $('#txtUserArea').val(getResult.UserArea);
            $('#txtUserLocation').val(getResult.UserLocation);
            $('#txtAssetNo').val(getResult.AssetNo);
            $('#txtModel').val(getResult.Model);
            $('#txtContractType').val(getResult.ContractTypeValue);
            $('#txtManufacturer').val(getResult.Manufacturer);
            $('#hdnRequestorId').val(getResult.RequestorId);
            $('#txtRequestor').val(getResult.Requestor);
            $('#hdnEngineerId').val(getResult.EngineerId);
            $('#txtEngineer').val(getResult.Engineer);
            GlobalAssignee = getResult.WorkOrderAssignee;
            $('#UnscheduledAssignee').val(getResult.WorkOrderAssignee);
            WorkOrderNo = getResult.WorkOrderNo;
            GlobalWorkOrderNo = getResult.WorkOrderNo;
            GlobalAssetNo = getResult.AssetNo;
            GlobalAssetDescription = getResult.AssetDescription;
            $('#txtWorkOrderNo').val(getResult.WorkOrderNo);
            $('#txtWorkOrderDate').val(moment(getResult.PartWorkOrderDate).format("DD-MMM-YYYY HH:mm"));
            //  var a = moment.utc((getResult.PartWorkOrderDate).Date).toDate();
            // $("#txtWorkOrderDate").val(moment(a).format("DD-MMM-YYYY HH:mm"));
            $('#WorkOrderCategory').val(getResult.MaintenanceType);
            $('#selWorkGroupfems').val(getResult.WorkGroupVaule);
            $('#WorkOrderPriority').val(getResult.WorkOrderPriority);
            //$('#txtWorkOrderStatus').val(getResult.WorkOrderStatusValue);
            $('#txtMaintainanceDetails').val(getResult.MaintenanceDetails);
            $("#Timestamp").val(getResult.Timestamp);
            $("#grid").trigger('reloadGrid');
            if (getResult.WorkOrderId != 0) {
                $('#btnSave').show();
                $('#btnDelete').show();
                $('#txtAssetNo').prop('disabled', true);
            }
         if (WorkOrderStatusString == "Open" || WorkOrderStatusString == "Work In Progress") {
                $('#btnUnSWOPrint').show();
            }

          if ((WorkOrderStatusString = "Complete") || (WorkOrderStatusString = "closed")) {
                $('#btnCompletionSave').hide();
                $("#btnDelete").hide();
            }
            else {
                $("#btnDelete").show();
            }
            $(".content").scrollTop(0);
            showMessage('Scheduled Work Order', CURD_MESSAGE_STATUS.SS);
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

    //fetch - Asset No 
    var AssetNoFetchObj = {
        SearchColumn: 'txtAssetNo-AssetNo',//Id of Fetch field
        ResultColumns: ["AssetId-Primary Key", 'AssetNo-AssetNo'],
        FieldsToBeFilled: ["hdnAssetId-AssetId", "txtAssetNo-AssetNo", "txtModel-Model", "txtManufacturer-Manufacturer", "txtContractType-ContractTypeValue",
            "txtUserArea-UserAreaCode", "txtUserLocation-UserLocationCode", "txtAsset_Name-Asset_Name"]
    };

    $('#txtAssetNo').on('input propertychange paste keyup', function (event) {
        AssetNoFetchObj.TypeCode = $('#hdnAssetTypeCodeId').val();
        DisplayFetchResult('divAssetNoFetch', AssetNoFetchObj, "/api/Fetch/ParentAssetNoFetch", "UlFetch1", event, 1);//1 -- pageIndex
    });

    //fetch - Engineer 
    var EngineerFetchObj = {
        SearchColumn: 'txtEngineer-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-StaffName'],
        FieldsToBeFilled: ["hdnEngineerId-StaffMasterId", "txtEngineer-StaffName", "txtContactNumber-ContactNumber"]
    };

    $('#txtEngineer').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divEngineerFetch', EngineerFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch2", event, 1);//1 -- pageIndex
    });

    //fetch - Requestor 
    var RequestorFetchObj = {
        SearchColumn: 'txtRequestor-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-StaffName'],
        FieldsToBeFilled: ["hdnRequestorId-StaffMasterId", "txtRequestor-StaffName"]
    };

    $('#txtRequestor').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divRequestorFetch', RequestorFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch15", event, 1);//1 -- pageIndex
    });

    //fetch - Completed By 
    var CompletedByFetchObj = {
        SearchColumn: 'txtCompletedBy-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-StaffName', 'Designation-Designation'],
        FieldsToBeFilled: ["hdnCompletedById-StaffMasterId", "txtCompletedBy-StaffName", "txtCompletedByDesignation-Designation"]
    };

    $('#txtCompletedBy').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divCompletedByFetch', CompletedByFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch3", event, 1);//1 -- pageIndex
    });

    //fetch - Verified By 
    var VerifiedByFetchObj = {
        SearchColumn: 'txtVerifiedBy-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-StaffName', 'Designation-Designation'],
        FieldsToBeFilled: ["hdnVerifiedById-StaffMasterId", "txtVerifiedBy-StaffName", "txtVerifiedByDesignation-Designation"]
    };

    $('#txtVerifiedBy').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divVerifiedByFetch', VerifiedByFetchObj, "/api/Fetch/FetchRecords", "UlFetch4", event, 1);//1 -- pageIndex
    });

    //fetch - Vendor 
    var VendorFetchObj = {
        SearchColumn: 'txtVendor-SSMNo',//Id of Fetch field
        ResultColumns: ["ContractorId-Primary Key", 'SSMNo-SSMNo', 'ContractorName-ContractorName'],
        FieldsToBeFilled: ["hdnVendorId-ContractorId", "txtVendor-ContractorName"]
    };

    $('#txtVendor').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divVendorFetch', VendorFetchObj, "/api/Fetch/FetchWarrantyProvider", "UlFetch10", event, 1);//1 -- pageIndex
    });

    $('#btnAddNew').click(function () {
        window.location.reload();
    });

    $("#btnCompletionCancel,#btnPartCancel,#btnTransferCancel,#btnAssessmentCancel,#btnHistoryCancel,#btnfileCancel").click(function () {
        var message = Messages.Reset_TabAlert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                if ($('#ServiceId').val() == "1") {
                    window.location.href = "/FEMS/UnScheduledWorkOrder";
                }
                else {
                    window.location.href = "/BEMS/UnScheduledWorkOrder";
                }

            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });

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
            $this.val($this.val().replace(/[~`!@#$%^*_+=|\\{}\[\]?<>/\^]/g, ''));
        }, 5);
    });

    $("#chk_CompletionInfoIsDelete").change(function () {
        var Isdeletebool = this.checked;

        if (this.checked) {
            $('#CompletionInfoResultId tr').map(function (i) {
                if ($("#Isdeleted_" + i).prop("disabled")) {
                    $("#Isdeleted_" + i).prop("checked", false);
                }
                else {
                    $("#Isdeleted_" + i).prop("checked", true);
                }
            });
        } else {
            $('#CompletionInfoResultId tr').map(function (i) {
                $("#Isdeleted_" + i).prop("checked", false);
            });
        }
    });

});

function disableForExternalComplete() {
    if (IsExternal) {
        $("#formUnScheduledWorkOrder :input:not(:button)").prop("disabled", true);
        $("#tab-2 :input:not(:button)").prop("disabled", true);
        $("#tab-3 :input:not(:button)").prop("disabled", true);
        $("#tab-4 :input:not(:button)").prop("disabled", true);
        $("#tab-5 :input:not(:button)").prop("disabled", true);
        $("#tab-7 :input:not(:button)").prop("disabled", true);
        $("#AssetEquipmentAttachment :input:not(:button)").prop("disabled", true);
        //$("#frmAdditionalInfo :input:not(:button)").prop("disabled", true);
        HideButtons();
    }
}

function HideButtons() {

    $('#btnEdit, #btnSaveandAddNew, #btnUnSWOPrint, #btnDelete, #btnAssessmentSave, #btnTransferSave, #btnPartSave, #CompletionAddButton, #btnCompletionSave').hide();
}
//function ShowButtons() {
//    $('#btnEdit, #btnSaveandAddNew, #btnUnSWOPrint, #btnDelete, #btnAssessmentSave, #btnTransferSave, #btnPartSave, #CompletionAddButton, #btnCompletionSave, #btnAdditionalInfoEdit').show();
//}

$('#AttachmentTab').click(function () {

    var status = $('#divWOStatus').text();
    if ((status == 'Completed' && IsExternal) || status == 'Closed') {
        $('#btnEditAttachmentAddNew, #btnEditAttachment').hide();
        setTimeout(function () {
            $("#CommonAttachment :input").prop("disabled", true);
        }, 50)

    } else {
        $('#btnEditAttachmentAddNew, #btnEditAttachment').show();
        setTimeout(function () {
            $("#CommonAttachment :input").prop("disabled", false);
        }, 50)
    }

});
// **** Query String to get ID Begin****\\\

var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
};

var ID = getUrlParameter('id');
if (ID == null || ID == 0 || ID == '') {
    $("#jQGridCollapse1").click();
}
else {
    LinkClicked(ID, {});
    FromNotification = true;
}
// **** Query String to get ID  End****\\\


//---------------------------2nd tab-----------------------------------------------

$("#UnWOCompletionInfoTab").click(function () {
    var primaryId = $('#primaryID').val();
    if (primaryId == 0 || primaryId == null || primaryId == undefined || primaryId == "" || primaryId == "0") {
        bootbox.alert(Messages.SAVE_FIRSTTAB_TABALERT);
        return false;
    }
    else if (AssessmentId == 0 || AssessmentId == null || AssessmentId == undefined || AssessmentId == "" || AssessmentId == "0") {
        bootbox.alert(Messages.SAVE_FIRSTTAB_TABALERT);
        return false;
    }
    else {
        GetCompletionInfo();
    }
});
$("#History1").click(function () {
    var primaryId = $('#primaryID').val();
    if (primaryId == 0 || primaryId == null || primaryId == undefined || primaryId == "" || primaryId == "0") {
        bootbox.alert(Messages.SAVE_FIRSTTAB_TABALERT);
        return false;
    }
    else if (AssessmentId == 0 || AssessmentId == null || AssessmentId == undefined || AssessmentId == "" || AssessmentId == "0") {
        bootbox.alert(Messages.SAVE_FIRSTTAB_TABALERT);
        return false;
    }
    else {
        GetCompletionInfo();
    }
});


function GetCompletionInfo() {


       $('#hdnAttachThereOrNot1').val(0);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/ScheduledWorkOrder/Get/" + primaryId)
                    .done(function (result) {
                        var getResult = JSON.parse(result);
                        $('#hdnAttachThereOrNot').val(getResult.HiddenId);
                        
                        var HiddenId = $('#hdnAttachThereOrNot').val();

                        if (HiddenId != null && HiddenId != "0" && HiddenId != "" && HiddenId != 0) {

                            $.get("/api/Document/getAttachmentDetails/" + HiddenId)
                              .done(function (result) {

                                  var getResult = JSON.parse(result);
                                  $('#FileUploadTable').empty();

                                  if (getResult != null && getResult.FileUploadList != null && getResult.FileUploadList.length > 0) {
                                      $('#hdnAttachThereOrNot1').val(1);
                                  }
                                  else {
                                      $('#hdnAttachThereOrNot1').val(0);

                                  }
                                  $('#myPleaseWait').modal('hide');
                              })
                             .fail(function () {
                                 $('#myPleaseWait').modal('hide');
                                 $("div.errorMsgcenterAttachment").text(Messages.COMMON_FAILURE_MESSAGE);
                                 $('#errorMsgAttachment').css('visibility', 'visible');
                             });
                        }
                    })
    }
   



    $('#btnCompletionSave').show();

    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgCompletionInfo').css('visibility', 'hidden');
    $('#txtVerifiedBy').prop('disabled', true);
    $('#txtHandoverDate').prop('disabled', true);
    pageindex = 1;

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/ScheduledWorkOrder/GetCompletionInfo/" + primaryId + "/" + pagesize + "/" + pageindex)
            .done(function (result) {

                var htmlval = "";
                var getResult = JSON.parse(result);
                var MaintainanceType = $('#WorkOrderCategory').val();
                if (('#txt_OrderNoWork').value != "" || ('#txt_OrderNoWork').value != null) {

                }
                else {
                    ('#txt_OrderNoWork').text(getResult.WorkOrderNo);
                }
                if (MaintainanceType == "273") {
                    $('#DownTimeLabelHide').show();
                    $('#DownTime').show();
                }
                else {
                    $('#DownTimeLabelHide').hide();
                    $('#DownTime').hide();
                }
                if (GlobalRunningHoursCapture != 0) {
                    if (GlobalRunningHoursCapture == 99) {
                        $('#txtRunningHours').prop('required', false);
                        $('#SpanRun').show();
                        $('#txtRunningHours').prop('disabled', false);
                    }
                    else if (GlobalRunningHoursCapture == 100) {
                        $('#txtRunningHours').prop('required', false);
                        $('#SpanRun').hide();
                        $('#txtRunningHours').prop('disabled', true);
                    }

                }
                if (MaintainanceType == "273") {

                    $('#txtRunningHours').prop('required', false);
                    $("#SpanRun").html("<span class='red'></span>");
                } else {
                    $("#SpanRun").html("<span class='red'>*</span>");
                }

                $('#txtRunningHours').prop('required', false);
                $("#SpanRun").html("<span class='red'></span>");
                if (getResult.CompletionInfoId > 0) {
                    $('#txtVerifiedBy').prop('disabled', false);
                    $('#txtHandoverDate').prop('disabled', false);
                    $('#txtVerifiedBy').prop('required', true);
                    $("#lblVerify").html("Verified By <span class='red'>*</span>");
                    $("#lblHanddt").html("Handover Date / Time <span class='red'>*</span>");
                    $('#txtHandoverDate').prop('required', true);
                }
                if (getResult.HandOverDate == "0001-01-01T00:00:00") {
                    getResult.HandOverDate = null;
                }
                if (getResult.EndDateMain == "0001-01-01T00:00:00" || getResult.EndDateMain == null) {
                    getResult.EndDateMain = "";
                }
                CompletionInfoId = getResult.CompletionInfoId;
                if (CompletionInfoId != 0) {
                    CompletionInfoId = getResult.CompletionInfoId;
                    $('.divWOStatus').text(getResult.WorkOrderStatusValue);
                    WorkOrderStatusString = getResult.WorkOrderStatusValue;
                    $('#WorkOrderNo').val(getResult.WorkOrderNo);
                    $('#txtStartDate').val(moment(getResult.StartDateMain).format("DD-MMM-YYYY HH:mm"));
                    if (getResult.EndDateMain != "") {
                        $('#txtEndDate').val(moment(getResult.EndDateMain).format("DD-MMM-YYYY HH:mm"));
                    }
                    //if (getResult.EndDate != "") {
                    //var startdate = new Date(GlobalWorkOrderDate);
                    //var endDate = new Date(getResult.EndDate);
                    //var diff = endDate - startdate;

                    //var diffSeconds = diff / 1000;
                    //var HH = Math.floor(diffSeconds / 3600);
                    //var MM = Math.floor(diffSeconds % 3600) / 60;
                    //MM = parseInt(MM);
                    //var formatted = ((HH < 10) ? ("0" + HH) : HH) + " : " + ((MM < 10) ? ("0" + MM) : MM)
                    //$('#DownTime').val(formatted);
                    ShowDownTime(getResult.DownTimeHours);
                    //}
                    GlobalDownTime = result.DownTimeHours;
                    $('#txtRunningHours').val(getResult.RunningHours);
                    $('#hdnCompletedById').val(getResult.CompletedById);
                    $('#txtCompletedBy').val(getResult.CompletedBy);
                    $('#txtCompletedByDesignation').val(getResult.CompletedByDesignation);
                    if (getResult.HandOverDate != null) {
                        $('#txtHandoverDate').val(moment(getResult.HandOverDate).format("DD-MMM-YYYY HH:mm"));
                    }
                    if (getResult.Status == null) {
                        getResult.Status = 0;
                    }
                    if (getResult.Reason == null) {
                        getResult.Reason = 0;
                    }
                    $('#hdnVerifiedById').val(getResult.VerifiedById);
                    $('#txtVerifiedBy').val(getResult.VerifiedBy);
                    $('#txtVerifiedByDesignation').val(getResult.VerifiedByDesignation);
                    $('#CauseCodeDescription').val(getResult.CauseCodeDescription);
                    $('#txtCauseCode').val(getResult.CauseCode);
                    $('#QCDescription').val(getResult.QCDescription);
                    $('#txtQCCode').val(getResult.QCCode);
                    $('#RepairDetails').val(getResult.RepairDetails);
                    $('#Status').val(getResult.Status);
                    $('#txtDate').val(DateFormatter(getResult.Date));
                    $('#Reason').val(getResult.Reason);
                    $('#VendorServiceCost').val(getResult.VendorServicecost);
                    $("label[for='AssetTrackingNo']").text(getResult.PorteringNo);
                    $('#AssetTrackingAssetNo').val(getResult.PorteringAssetNo);
                    if (getResult.PorteringNo == null || getResult.PorteringNo == "") {
                        $('#PorteringDiv').hide();
                    }
                    else {
                        $('#PorteringDiv').show();
                    }


                    if (getResult.Base64StringSignature != "" && getResult.Base64StringSignature != null) {
                        ListModel = getResult.Base64StringSignature;
                        $('#SignatureCompletionHide').show();
                        var strimg = 'data:image/jpeg;base64,' + getResult.Base64StringSignature;

                        document.getElementById('imgSignature2').setAttribute('src', strimg);
                    }
                    else {
                        $('#SignatureCompletionHide').hide();
                    }

                    CompletionDetails = getResult.CompletionInfoDets;
                    if (CompletionDetails == null) {
                        $("#CompletionInfoResultId").empty();
                        //PushEmptyMessage();
                    }
                    else {
                        bindDatatoDatagrid(CompletionDetails);
                    }
                    $('#selCustomerFeedback').val(getResult.CustomerFeedback == null ? 'null' : getResult.CustomerFeedback);
                    $('#selCustomerFeedback').attr('disabled', false);
                }
                else {
                    $('#WorkOrderNo').val(GlobalWorkOrderNo);
                    $('#PorteringDiv').hide();
                    AddNewRow(1);
                    $('#paginationfooter').hide();
                }
                if (WorkOrderStatusString == "Completed") {

                    $('#btnCompletionSave').show();
                    $('#btnCompletionSubmitEdit').show();
                    // $('#CompletionAddButton').hide();
                    //   $('#btnUnSWOPrint').show();
                }
                else if (WorkOrderStatusString != "Completed") {
                    $('#btnCompletionSave').show();
                    $('#btnCompletionSubmitEdit').hide();
                    $('#CompletionAddButton').show()
                    $('#btnCompletionSave').prop('disabled', false);
                    $('#btnCompletionSave').prop('aria-hidden', false);
                }
                if (WorkOrderStatusString == "Closed") {

                    $('#txtVerifiedBy').prop('disabled', true);
                    $('#txtHandoverDate').prop('disabled', true);
                    $('#btnCompletionSave').hide();
                    var _index;
                    $('#CompletionInfoResultId tr').each(function () {
                        _index = $(this).index();
                    });

                    for (var i = 0; i <= _index; i++) {
                        $('#EmployeeName_' + i).prop('disabled', true);
                        $('#StartDate_' + i).prop('disabled', true);
                        $('#TaskCode_' + i).prop('disabled', true);
                        $('#EndDate_' + i).prop('disabled', true);
                        $('#Isdeleted_' + i).prop('disabled', true);
                    }
                    $('#CompletionAddButton').hide();

                    //$('#btnCompletionSave').show();
                    $('#btnCompletionSubmitEdit').hide();
                    // $('#btnUnSWOPrint').show();

                }
                if (WorkOrderStatusString != "Closed" && WorkOrderStatusString != "Completed") {

                    $('#CompletionAddButton').show();
                    $('#btnCompletionSave').show();
                }
                if (WorkOrderStatusString == "Closed") {

                    $('#btnCompletionSave').hide();
                }
                if (WorkOrderStatusString == "Completed" && IsExternal) {

                    $('#CompletionAddButton').hide();
                    //$('#btnCompletionSave').hide();
                    $('#btnCompletionSubmitEdit').hide();
                    $('#btnCompletionSave').show();
                    $('#btnCompletionSave').prop('disabled', false);
                    $('#txtVerifiedBy').prop('disabled', true);
                    $('#txtHandoverDate').prop('disabled', true);
                    $("#dataTableCompletion :input:not(:button)").prop("disabled", true);
                    $('#btnUnSWOPrint').hide();
                }

                if (result.AccessLevel == 4) {
                    $('#btnCompletionSubmitEdit').hide();
                    $("#lblVerify").html("Verified By");
                    $("#lblHanddt").html("Handover Date / Time");
                }
                $('#txt_Designations').text(getResult.CompletedByDesignation);
                $('#txt_CompletedByDesignations').text(getResult.Designation);
                //$('#txt_StaffDesignation').text(getResult.Designation);
                $('#myPleaseWait').modal('hide');
            })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsgCompletionInfo').css('visibility', 'visible');
            });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}

function CompletionInfoSave(Parameter) {
   
   var status = $('#divWOStatus').text();
    if (status == " Completed") {
        var HdnAttachThereOrNot = $('#hdnAttachThereOrNot1').val();
        if (HdnAttachThereOrNot == 1) {          
        }
        else {
            $('#myPleaseWait').modal('hide');
            bootbox.alert("Atleast one attachment is mandatory to close the work order!");
            return;
        }
    }

    Submitted = Parameter;
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgCompletionInfo').css('visibility', 'hidden');

    var isFormValid = formInputValidation("tab-2", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsgCompletionInfo').css('visibility', 'visible');

        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }

    var _index;
    $('#CompletionInfoResultId tr').each(function () {
        _index = $(this).index();
    });

    var resultList = [];
    for (var i = 0; i <= _index; i++) {
        var obj = {
            CompletionInfoDetId: $('#CompletionInfoDetId_' + i).val(),
            StaffMasterId: $('#StaffMasterId_' + i).val(),
            StandardTaskDetId: null, //$('#StandardTaskDetId_' + i).val(),
            StartDate: $('#StartDate_' + i).val(),
            EndDate: $('#EndDate_' + i).val(),
            PPMHours: $('#PPMHours_' + i).val(),
            IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
        };
        if (obj.EndDate == " " || obj.EndDate == "") {
            obj.EndDate = null;
        }
        var CurrDate = new Date();

        var stDt = obj.StartDate;
        var endDt = obj.EndDate;

        stDt = Date.parse(stDt);
        if (endDt != "") {
            endDt = Date.parse(endDt);
        }

        if (stDt > CurrDate) {
            $("div.errormsgcenter").text("Start Date / Time should be lesser than current Date/Time");
            $('#errorMsgCompletionInfo').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }

        if (endDt != "" && endDt > CurrDate) {
            $("div.errormsgcenter").text("End Date / Time should be lesser than current Date/Time");
            $('#errorMsgCompletionInfo').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }

        if (endDt != null) {
            if (endDt != "" && endDt < stDt) {
                $("div.errormsgcenter").text("End Date / Time should be greater than Start Date/Time");
                $('#errorMsgCompletionInfo').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }


        resultList.push(obj);
    }

    var MaintainanceType = $('#WorkOrderCategory').val();
    if (MaintainanceType == "273") {
        for (var k = 0; k == _index; k++) {
            if ($('#EndDate_' + k).val() != "") {
                var startdate = new Date(GlobalWorkOrderDate);
                var endDate = new Date($('#EndDate_' + k).val());
                var diff = endDate - startdate;

                var diffSeconds = diff / 1000;
                var HH = Math.floor(diffSeconds / 3600);
                var MM = Math.floor(diffSeconds % 3600) / 60;
                // MM = parseInt(MM);
                //  var formatted = ((HH < 10) ? ("0" + HH) : HH) + " : " + ((MM < 10) ? ("0" + MM) : MM)
                GlobalDownTime = (HH * 60) + MM;
            }
        }
    }

    for (var j = 0; j < resultList.length; j++) {
        if (resultList[j].EndDate != null) {
            var Sdate = new Date(resultList[j].StartDate);
            var Edate = new Date(resultList[j].EndDate);
            if (Sdate > Edate) {
                $("div.errormsgcenter").text("End Date should be greater than Start Date!");
                $('#errorMsgCompletionInfo').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }
    }
    var end_actual_time = $('#AssessmentResponseDate').val();
    for (var k = 0; k < resultList.length; k++) {
        if (resultList[k].StartDate != null) {
            var Sdate = new Date(resultList[k].StartDate);
            var Edate = new Date(end_actual_time);
            if (Sdate < Edate) {
                $("div.errormsgcenter").text("Start Date should be greater than or equal to Response Date!");
                $('#errorMsgCompletionInfo').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }
    }
    var end_actual_time = $('#AssessmentResponseDate').val();
    function chkIsDeletedRow(i, delrec) {
        if (delrec == true) {
            $('#EmployeeName_' + i).prop("required", false);
            //$('#TaskCode_' + i).prop("required", false);
            $('#StartDate_' + i).prop("required", false);
            return true;
        }
        else {
            return false;
        }
    }


    var endDate = $("#txtEndDate").val();
    var endDt = Date.parse(endDate);
    var HandOverDate = $('#txtHandoverDate').val();
    var hndDt = Date.parse(HandOverDate);
    var today = new Date();

    if (hndDt != null) {
        if (hndDt < endDt) {
            $("div.errormsgcenter").text("HandOver Date / Time Must be Greater than End Date / Time");
            $('#errorMsgCompletionInfo').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }
    }

    if (hndDt > today) {
        $("div.errormsgcenter").text("HandOver Date / Time Must be lesser than than current Date / Time");
        $('#errorMsgCompletionInfo').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        return false;
    }

    var deletedCount = Enumerable.From(resultList).Where(x => x.IsDeleted).Count();
    var Isdeleteavailable = deletedCount > 0;
    if (deletedCount == resultList.length && TotalPages == 1) {
        bootbox.alert("Sorry!. You cannot delete all rows");
        $('#myPleaseWait').modal('hide');
        return false;
    }

    var Isdeleteavailable = Enumerable.From(resultList).Where(x => x.IsDeleted).Count() > 0;
    if (Isdeleteavailable) {
        message = "Are you sure that you want to delete the record(s)?";

        bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (result) {
            if (result) {
                Completionsubmit(resultList);
            }
            else {

            }
        });
    }
    else {
        Completionsubmit(resultList);
    }
}

function Completionsubmit(result) {

    var obj1 = {
        CompletionInfoId: CompletionInfoId,
        WorkOrderId: $("#primaryID").val(),
        CompletedById: $('#hdnCompletedById').val(),
        StartDate: $('#StartDate_' + 0).val(),
        EndDate: $('#EndDate_' + 0).val(),
        HandOverDate: $('#txtHandoverDate').val(),
        VerifiedById: $('#hdnVerifiedById').val(),
        CauseCodeDescription: $('#CauseCodeDescription').val(),
        QCDescription: $('#QCDescription').val(),
        RepairDetails: $('#RepairDetails').val(),
        Status: $('#Status').val(),
        Reason: $('#Reason').val(),
        Date: $('#txtDate').val(),
        Timestamp: $('#Timestamp').val(),
        RunningHours: $('#txtRunningHours').val(),
        VendorServicecost: $('#VendorServiceCost').val(),
        IsSubmitted: Submitted,
        DownTimeHours: GlobalDownTime,
        CustomerFeedback: $('#selCustomerFeedback').val(),
        CompletionInfoDets: result
    }
    if (obj1.CompletionInfoId == 0) {
        obj1.VerifiedById = null;
    }

    if (obj1.HandOverDate == "") {
        obj1.HandOverDate = null;
    }
    if (obj1.EndDate == "" || obj1.EndDate == " ") {
        obj1.EndDate = null;
    }

    var jqxhr = $.post("/api/ScheduledWorkOrder/addCompletionInfo", obj1, function (response) {
        var result = JSON.parse(response);
        var htmlval = ""; $('#tablebody').empty();
        var WorkGroupVaule = $('#selWorkGroupfems').val();
        var MaintainanceType = $('#WorkOrderCategory').val();
        if (MaintainanceType == "273") {
            $('#DownTimeLabelHide').show();
            $('#DownTime').show();
        }
        else {
            $('#DownTimeLabelHide').hide();
            $('#DownTime').hide();
        }

        if (result.CompletionInfoId > 0) {

            $('#txtVerifiedBy').prop('disabled', false);
            $('#txtHandoverDate').prop('disabled', false);
            $('#txtVerifiedBy').prop('required', true);
            $("#lblVerify").html("Verified By <span class='red'>*</span>");
            $("#lblHanddt").html("Handover Date / Time <span class='red'>*</span>");
            $('#txtHandoverDate').prop('required', true);
            if (result.WorkOrderStatusValue == " Completed") {
                $('#btnCompletionSubmitEdit').show();
                // $('#btnUnSWOPrint').show();
                $('#btnCompletionSave').hide();

            }
            if (result.WorkOrderStatusValue == " Closed") {
                $('#btnCompletionSubmitEdit').hide();
            }
            // btnCompletionSubmitEdit
            $('#btnCompletionSave').hide();
        }

        if (GlobalRunningHoursCapture != 0) {
            if (GlobalRunningHoursCapture == 99) {
                $('#txtRunningHours').prop('required', false);
                $('#SpanRun').show();
                $('#txtRunningHours').prop('disabled', false);
            }
            else if (GlobalRunningHoursCapture == 100) {
                $('#txtRunningHours').prop('required', false);
                $('#SpanRun').hide();
                $('#txtRunningHours').prop('disabled', true);
            }

        }
        if (result.HandOverDate == "0001-01-01T00:00:00")
            result.HandOverDate = null;
        if (result.EndDateMain == "0001-01-01T00:00:00" || result.EndDateMain == null)
            result.EndDateMain = "";
        CompletionInfoId = result.CompletionInfoId;
        $('.divWOStatus').text(result.WorkOrderStatusValue);
        WorkOrderStatusString = result.WorkOrderStatusValue;
        $('#txtWorkOrderNo').val(result.WorkOrderNo);
        $('#txtStartDate').val(moment(result.StartDateMain).format("DD-MMM-YYYY HH:mm"));
        if (result.EndDateMain != "") {
            $('#txtEndDate').val(moment(result.EndDateMain).format("DD-MMM-YYYY HH:mm"));
        }

        ShowDownTime(result.DownTimeHours);

        GlobalDownTime = result.DownTimeHours;
        $('#hdnCompletedById').val(result.CompletedById);
        $('#txtCompletedBy').val(result.CompletedBy);
        $('#txtCompletedByDesignation').val(result.CompletedByDesignation);
        if (result.HandOverDate != null) {
            $('#txtHandoverDate').val(moment(result.HandOverDate).format("DD-MMM-YYYY HH:mm"));
        }
        if (result.Status == null) {
            result.Status = 0;
        }
        if (result.Reason == null) {
            result.Reason = 0;
        }
        $('#txtRunningHours').val(result.RunningHours);
        $('#hdnVerifiedById').val(result.VerifiedById);
        $('#txtVerifiedBy').val(result.VerifiedBy);
        $('#txtVerifiedByDesignation').val(result.VerifiedByDesignation);
        $('#CauseCodeDescription').val(result.CauseCodeDescription);
        $('#txtCauseCode').val(result.CauseCode);
        $('#QCDescription').val(result.QCDescription);
        $('#txtQCCode').val(result.QCCode);
        $('#RepairDetails').val(result.RepairDetails);
        $('#Status').val(result.Status);
        $('#txtDate').val(DateFormatter(result.Date));
        $('#Reason').val(result.Reason);
        $('#VendorServiceCost').val(result.VendorServicecost);
        $("label[for='AssetTrackingNo']").text(result.PorteringNo);
        $('#AssetTrackingAssetNo').val(result.PorteringAssetNo);
        if (result.PorteringNo == null) {
            $('#PorteringDiv').hide();
        }
        else {
            $('#PorteringDiv').show();
        }
        $("#Timestamp").val(result.Timestamp);
        $('#primaryID').val(result.WorkOrderId);

        CompletionDetails = result.CompletionInfoDets;
        if (CompletionDetails == null) {
            PushEmptyMessage();
        }
        else {
            bindDatatoDatagrid(CompletionDetails);
        }
        if (WorkOrderStatusString == "Closed") {

            $("#formUnScheduledWorkOrder :input:not(:button)").prop("disabled", true);
            $("#tab-2 :input:not(:button)").prop("disabled", true);
            $("#tab-3 :input:not(:button)").prop("disabled", true);
            $("#tab-4 :input:not(:button)").prop("disabled", true);
            $("#tab-5 :input:not(:button)").prop("disabled", true);
            $("#tab-7 :input:not(:button)").prop("disabled", true);
            $("#divCommonAttachment :input:not(:button)").prop("disabled", true);
            $("#PPMCheckList :input:not(:button)").prop("disabled", true);
            $("#aAFAdditionalInfo :input:not(:button)").prop("disabled", true);
            $('#txtEngineer').prop('disabled', true);
            $('#txtMaintainanceDetails').prop('disabled', true);
            $('#btnCompletionSubmitEdit').hide();
            //   $('#btnUnSWOPrint').show();
            $('#CompletionAddButton').hide();

            $('#btnCompletionSave').hide();
        }

        if (WorkOrderStatusString == "Completed" && IsExternal) {
            disableForExternalComplete();
        }
        if (result.AccessLevel == 4) {
            $('#btnCompletionSubmitEdit').hide();
            $("#lblVerify").html("Verified By");
            $("#lblHanddt").html("Handover Date / Time");
        }

        $('#errorMsg').css('visibility', 'hidden');
        $(".content").scrollTop(0);
        showMessage('Completion Info', CURD_MESSAGE_STATUS.SS);
        $("#top-notifications").modal('show');
        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);
        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);

        $('#btnCompletionSave').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        $("#grid").trigger('reloadGrid');
    },
        "json")
        .fail(function (response) {
            var errorMessage = "";
            errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsgCompletionInfo').css('visibility', 'visible');
            $('#btnCompletionSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
}

//Tab 2 Grid Functions
function CompletionNewRow() {

    var inputpar = {
        inlineHTML: CompletionGridHtml(),//Inline Html
        TargetId: "#CompletionInfoResultId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    $('#chk_CompletionInfoIsDelete').prop("checked", false);
    $('#CompletionInfoResultId tr:last td:first input').focus();
}

function PushEmptyMessage() {
    $("#CompletionInfoResultId").empty();
    var emptyrow = '<tr><td colspan=7 ><h3&nbsp;&nbsp;&nbsp;&nbsp;No records to display</h3></td></tr>'
    $("#CompletionInfoResultId ").append(emptyrow);
}

function CompletionGridHtml() {

    return '<tr class="ng-scope" style=""> <td width="3%" data-original-title="" title=""><div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" value="false" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(CompletionInfoResultId,chk_CompletionInfoIsDelete)" tabindex="0"> </label></div></td><td width="25%" style="text-align: center;" data-original-title="" title=""> <div> <div> <input type="text" placeholder="Please select" required id="EmployeeName_maxindexval" autocomplete="off" value="" class="form-control fetchField" onkeyup="Fetchdata(event,maxindexval)" onpaste="Fetchdata(event,maxindexval)" change="Fetchdata(event,maxindexval)" oninput="Fetchdata(event,maxindexval)"> </div><input type="hidden" id="StaffMasterId_maxindexval"/><input type="hidden" id="CompletionInfoDetId_maxindexval"/> <div class="col-sm-12" id="divFetch_maxindexval"></div></div></td><td width="25%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" required id="StartDate_maxindexval" autocomplete="off" value="" class="form-control datatimepickerNoFut"> </div></td><td width="25%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" data-value=" " id="EndDate_maxindexval" onchange="CalculateRepairHours(maxindexval)" value=" "  autocomplete="off" class="form-control datatimepickerNoFut"> </div></td><td width="22%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" data-value=" " disabled id="PPMHours_maxindexval" value="" class="form-control"> </div></td></tr>';

}

function AddNewRow(param) {
    var _index;
    $('#CompletionInfoResultId tr').each(function () {
        _index = $(this).index();

    });
    var flagAllow = 0;
    for (var i = 0; i <= _index; i++) {
        var StaffMasterId = $("#StaffMasterId_" + i).val();
        //var StandardTaskDetId = $("#StandardTaskDetId_" + i).val();
        var StartDate = $("#StartDate_" + i).val();

        if (StaffMasterId && StartDate) { }
        else
            flagAllow++;

    }
    if (flagAllow != 0) {
        if (param != 1)
            bootbox.alert("Please enter data for existing rows");
        return;
    }
    if (param != 1) {
        CompletionNewRow();
    }
    else if (param == 1) {
        var _index;
        $('#CompletionInfoResultId tr').each(function () {
            _index = $(this).index();
        });
        if (_index == undefined)
            CompletionNewRow();
    }
    formInputValidation("form");
}

function ShowDownTime(DownTimeHours) {
    if (DownTimeHours != null && DownTimeHours != 0) {
        var hours = Math.floor(DownTimeHours / 60);
        var minutes = parseInt(DownTimeHours % 60);

        var hoursStr = hours.toString();
        var minutesStr = minutes.toString();

        hoursStr = hoursStr.length == 1 ? '0' + hoursStr : hoursStr;
        minutesStr = minutesStr.length == 1 ? '0' + minutesStr : minutesStr;

        var downtimeString = hoursStr + ':' + minutesStr;
        $('#DownTime').val(downtimeString);
    } else {
        $('#DownTime').val('');
    }
}

function bindDatatoDatagrid(list) {
    if (list.length > 0) {
        $('#paginationfooter').show();
        $('#CompletionInfoResultId').empty()
        var html = '';

        $(list).each(function (index, data) {
            data.StartDate = moment(data.StartDate).format("DD-MMM-YYYY HH:mm");
            if (data.EndDate != null)
                data.EndDate = moment(data.EndDate).format("DD-MMM-YYYY HH:mm");
            if (data.EndDate == null)
                data.EndDate = "";

            if (data.PPMHours == null)
                data.PPMHours = "";
            if (data.TaskCode == null)
                data.TaskCode = "";

            html = '<tr class="ng-scope" style=""> <td width="3%" data-original-title="" title=""> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" onchange="IsDeleteValidation(' + index + ')" id="Isdeleted_' + index + '" autocomplete="off"  tabindex="0" aria-="false" aria-checked="false" aria-invalid="false"> </label> </div></td><td width="25%" style="text-align: center;" data-original-title="" title=""> <div> <div> <input type="text" placeholder="Please select" required  autocomplete="off" id="EmployeeName_' + index + '" value="' + data.EmployeeName + '" class="form-control fetchField" onkeyup="Fetchdata(event,' + index + ')" onpaste="Fetchdata(event,' + index + ')" change="Fetchdata(event,' + index + ')" oninput="Fetchdata(event,' + index + ')"> </div><input type="hidden" id="StaffMasterId_' + index + '" value="' + data.StaffMasterId + '"/><input type="hidden" id="CompletionInfoDetId_' + index + '" value="' + data.CompletionInfoDetId + '"/> <div class="col-sm-12" id="divFetch_' + index + '"></div></div></td><td width="25%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" autocomplete="off" required id="StartDate_' + index + '" value="' + data.StartDate + '" class="form-control datatimepickerNoFut"> </div></td><td width="25%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" data-value=" " id="EndDate_' + index + '" onchange="CalculateRepairHours(' + index + ')" value="' + data.EndDate + '" class="form-control datatimepickerNoFut"> </div></td><td width="22%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" data-value=" " disabled id="PPMHours_' + index + '" value="' + data.PPMHoursTiming + '" class="form-control"> </div></td></tr>';


            $('#CompletionInfoResultId').append(html);
            GridtotalRecords = data.TotalRecords;
            TotalPages = data.TotalPages;
            LastRecord = data.LastRecord;
            FirstRecord = data.FirstRecord;
            pageindex = data.PageIndex;
        });
        var mapIdproperty = ["Isdeleted-Isdeleted_", "StaffMasterId-StaffMasterId_", "CompletionInfoDetId-CompletionInfoDetId_", "EmployeeName-EmployeeName_", "StartDate-StartDate_", "EndDate-EndDate_", "PPMHoursTiming-PPMHours_"];
        var htmltext = CompletionGridHtml();

        id = $('#primaryID').val();
        var obj = { formId: "#tab-2", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "UnScheduleCompInfo", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "CompletionInfoDets", tableid: '#CompletionInfoResultId', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/ScheduledWorkOrder/GetCompletionInfo/" + id, pageindex: pageindex, pagesize: pagesize, WorkOrderStatusString: WorkOrderStatusString };

        CreateFooterPagination(obj);


        var _index;
        $('#CompletionInfoResultId tr').each(function () {
            _index = $(this).index();
        });

        if ($('#ActionType').val() == "VIEW") {
            for (var i = 0; i <= _index; i++) {
                $('#EmployeeName_' + i).prop('disabled', true);
                $('#StartDate_' + i).prop('disabled', true);
                //$('#TaskCode_' + i).prop('disabled', true);
                $('#EndDate_' + i).prop('disabled', true);
                $('#Isdeleted_' + i).prop('disabled', true);
            }
        }


    }

    formInputValidation("form");

}

function Fetchdata(event, index) {
    var ItemMst = {
        SearchColumn: 'EmployeeName_' + index + '-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId" + "-Primary Key", 'StaffName' + '-StaffName' + index],//Columns to be displayed
        FieldsToBeFilled: ["StaffMasterId_" + index + "-StaffMasterId", 'EmployeeName_' + index + '-StaffName']//id of element - the model property
    };
    DisplayFetchResult('divFetch_' + index, ItemMst, "/api/Fetch/CompanyStaffFetch", "Ulfetch5" + index, event, 1);
}

//function Fetchdata2(event, index) {
//    var ItemMst = {
//        SearchColumn: 'TaskCode_' + index + '-TaskCode',//Id of Fetch field
//        ResultColumns: ["StandardTaskDetId" + "-Primary Key", 'TaskCode' + '-TaskCode' + index],//Columns to be displayed
//        FieldsToBeFilled: ["StandardTaskDetId_" + index + "-StandardTaskDetId", 'TaskCode_' + index + '-TaskCode']//id of element - the model property
//    };
//    DisplayFetchResult('divFetch2_' + index, ItemMst, "/api/Fetch/FetchTaskCode", "Ulfetch6" + index, event, 1);
//}

function GetQC() {
    var QCID = $('#QCDescription').val();
    if (QCID != null && QCID != "0") {
        $.get("/api/ScheduledWorkOrder/GetQC/" + QCID)
            .done(function (result) {
                var res = JSON.parse(result);
                var htmlval = "";
                $('#txtQCCode').val(res.QCCode);
                $('#CauseCodeDescription').empty();
                $('#CauseCodeDescription').append('<option value="0">Select</option>');
                $.each(res.QCCodeListBased, function (index, value) {
                    $('#CauseCodeDescription').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                });
                $('#txtCauseCode').val("");
            })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsgCompletionInfo').css('visibility', 'visible');
            });
    }
    else {
        $('#txtQCCode').val("");
        $('#CauseCodeDescription').empty();
        $('#CauseCodeDescription').append('<option value="0">Select</option>');
        $('#myPleaseWait').modal('hide');
    }
}

function GetCC() {
    var CCID = $('#CauseCodeDescription').val();
    if (CCID != null && CCID != "0") {
        $.get("/api/ScheduledWorkOrder/GetCC/" + CCID)
            .done(function (result) {
                var res = JSON.parse(result);
                var htmlval = "";
                $('#txtCauseCode').val(res.CauseCode);
            })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsgCompletionInfo').css('visibility', 'visible');
            });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}

function VendorChange() {
    var CCID = $('#ChangeToVendor').val();
    if (CCID == 99) {
        $('#VendorHide').show();
        $('#txtVendor').prop('required', true);
        $('#txtVendor').prop('disabled', false);
    }
    else if (CCID == 100) {
        $('#VendorHide').hide();
        $('#txtVendor').prop('required', false);
        $('#txtVendor').prop('disabled', true);
        $("#txtVendor").parent().removeClass('has-error');
    }

}
//---------------------------3rd tab-----------------------------------------------

$("#UnWOPartReplacementTab").click(function () {
    var primaryId = $('#primaryID').val();
    if (primaryId == 0 || primaryId == null || primaryId == undefined || primaryId == "" || primaryId == "0") {
        bootbox.alert(Messages.SAVE_FIRSTTAB_TABALERT);
        return false;
    }
    else if (AssessmentId == 0 || AssessmentId == null || AssessmentId == undefined || AssessmentId == "" || AssessmentId == "0") {
        bootbox.alert(Messages.SAVE_FIRSTTAB_TABALERT);
        return false;
    }
    else {
        GetPartReplacement();
    }
});

function GetPartReplacement() {
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgPart').css('visibility', 'hidden');
    pageindex = 1;
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/ScheduledWorkOrder/GetPartReplacement/" + primaryId + "/" + pagesize + "/" + pageindex)
            .done(function (result) {
                var htmlval = "";
                var getResult = JSON.parse(result);
                UserRoleGlobal = getResult.UserRole;
                // PartReplacemenId = getResult.PartReplacemenId;
                $('#PartWorkOrderNo').val(getResult.WorkOrderNo);
                $('#PartWorkOrderDate').val(moment(getResult.PartWorkOrderDate).format("DD-MMM-YYYY HH:mm"));
                if (getResult.TotalSparePartCost != null) {
                    $('#TotalSparePartCost').val(addCommas(getResult.TotalSparePartCost));
                }
                else {
                    $('#TotalSparePartCost').val(getResult.TotalSparePartCost);
                }

                if (getResult.TotalLabourCost != null) {
                    $('#TotalLabourCost').val(addCommas(getResult.TotalLabourCost));
                }
                else {
                    $('#TotalLabourCost').val(getResult.TotalLabourCost);
                }
                if (getResult.TotalCost != null) {
                    $('#TotalCost').val(addCommas(getResult.TotalCost));
                }
                else {
                    $('#TotalCost').val(getResult.TotalCost);
                }
                // $('#primaryID').val(getResult.WorkOrderId);

                PartReplacementDetails = getResult.PartReplacementDets;
                if (PartReplacementDetails == null) {
                    $('#PartWorkOrderNo').val(GlobalWorkOrderNo);
                    $('#PartWorkOrderDate').val(moment(GlobalWorkOrderDate).format("DD-MMM-YYYY HH:mm"));
                    //PartReplacementPushEmptyMessage();
                    $("#PartReplacementResultId").empty();
                    AddPartReplacementNewRow();


                    //var rowCount = $('#PartReplacementResultId tr:last').index();
                    //$.each(window.StockTypeListGloabal, function (index, value) {
                    //    $('#StockType_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                    //});
                }
                else {
                    bindDatatoPartReplacementDatagrid(PartReplacementDetails);

                    var _Mainindex;
                    $('#PartReplacementResultId tr').each(function () {
                        _Mainindex = $(this).index();
                    });
                    for (var i = 0; i <= _Mainindex; i++) {
                        if ((PartReplacementDetails[i].StockUpdateDetId != 0 || PartReplacementDetails[i].StockUpdateDetId != "") && (PartReplacementDetails[i].PartReplacementId != 0 || PartReplacementDetails[i].PartReplacementId != "")) {
                            $("#QuantityPopUp_" + i).hide();
                        }
                        var optionId = $('#hdnLifeSpanOptionId_' + i).val();
                        EnableDisableForLifeSpanOption(i, optionId)
                        $("#EstimatedLifeSpan_" + i).prop('disabled', true);
                        var LabourCost = $("#LabourCost_" + i).val();
                        LabourCost = (LabourCost == "0") ? "" : LabourCost;
                    }
                }

                if ($('#ActionType').val() != "VIEW" && hasApproveRolePermission != true) {
                    $('#CostHide').hide();

                    $('#TotalCostSingleHide').hide();
                    $('#LabourCostHide').hide();
                    $('#TotalCostHide').hide();

                    var _index;
                    $('#PartReplacementResultId tr').each(function () {
                        _index = $(this).index();
                    });
                    if (PartReplacementDetails == null) {
                        for (var i = 0; i <= _index; i++) {
                            $('#CostColumn1_' + i).hide();
                            $('#CostColumn2_' + i).hide();
                            $('#CostColumn3_' + i).hide();
                            $('#LabourCost_' + i).prop('required', false);
                        }
                    }
                    else {
                        for (var i = 0; i <= _index; i++) {
                            $('#CostColumn1_' + i).hide();
                            $('#CostColumn2_' + i).hide();
                            $('#CostColumn3_' + i).hide();
                            $('#LabourCost_' + i).prop('required', false);
                            $("#QuantityPopUp_" + i).hide();
                        }
                    }
                }

                if ($('#ActionType').val() == "VIEW") {
                    $('#CostHide').hide();

                    $('#TotalCostSingleHide').hide();
                    $('#LabourCostHide').hide();
                    $('#TotalCostHide').hide();

                    var _index;
                    $('#PartReplacementResultId tr').each(function () {
                        _index = $(this).index();
                    });

                    for (var i = 0; i <= _index; i++) {
                        $('#CostColumn1_' + i).hide();
                        $('#CostColumn2_' + i).hide();
                        $('#CostColumn3_' + i).hide();
                        $('#LabourCost_' + i).prop('required', false);
                    }
                }

                if (WorkOrderStatusString == "Closed") {
                    var _index;
                    $('#PartReplacementResultId tr').each(function () {
                        _index = $(this).index();
                    });

                    for (var i = 0; i <= _index; i++) {
                        $('#PartNo_' + i).prop('disabled', true);
                        //$('#Isdeleted_' + i).prop('disabled', true);

                        $('#EstimatedLifeSpan_' + i).prop('disabled', true);
                        $('#LifeSpanExpiryDate_' + i).prop('disabled', true);
                        $('#StockType_' + i).prop('disabled', true);
                    }
                    $('[id^=Isdeleted_]').attr('disabled', true);
                    $('#PartAddButton').hide();
                    $('#btnPartSave').hide();
                    //   $('#btnUnSWOPrint').show();
                }
                if (WorkOrderStatusString != "Closed") {
                    $('#PartAddButton').show();
                    $('#btnPartSave').show();
                    $('#btnEditAttachment').show();
                    $('#AttachRowPlus').show();
                    $('#aRequestForPurchase').show();
                    //$("input[id^='QuantityPopUp_']").show();
                }

                if (WorkOrderStatusString == "Completed" && IsExternal) {
                    $('#PartAddButton').hide();
                    $('#btnPartSave').hide();
                    $("#dataTableCheckList :input:not(:button)").prop("disabled", true);
                    $('#aRequestForPurchase').hide();
                    $("a[id^='QuantityPopUp_']").hide();
                }

                $('#myPleaseWait').modal('hide');
            })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsgPart').css('visibility', 'visible');
            });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}

$("#btnPartSave,#btnPartEdit").click(function () {
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgPart').css('visibility', 'hidden');

    var isFormValid = formInputValidation("tab-3", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsgPart').css('visibility', 'visible');

        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }

    var _index;
    $('#PartReplacementResultId tr').each(function () {
        _index = $(this).index();
    });

    var resultList = [];
    for (var i = 0; i <= _index; i++) {
        var obj = {
            PartReplacementId: $('#PartReplacementId_' + i).val(),
            WorkOrderId: $("#primaryID").val(),
            SparePartStockRegisterId: $('#SparePartStockRegisterId_' + i).val(),
            StockUpdateDetId: $('#StockUpdateDetId_' + i).val(),
            Quantity: $('#Quantity_' + i).val(),
            CostPerUnit: $('#CostPerUnit_' + i).val(),
            PopUpQuantityAvailable: $('#PQV_' + i).val(),
            PopUpQuantityTaken: $('#PQT_' + i).val(),
            LabourCost: $('#LabourCost_' + i).val(),
            IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
            EstimatedLifeSpan: $('#EstimatedLifeSpan_' + i).val(),
            EstimatedLifeSpanDate: $('#LifeSpanExpiryDate_' + i).val(),
            StockType: $('#StockType_' + i).val(),
            TotalCost: $('#TotalCost_' + i).val(),
        };

        if ((obj.CostPerUnit == '' || obj.CostPerUnit == 0 || obj.CostPerUnit == null) && (obj.IsDeleted == false)) {
            $("div.errormsgcenter").text("Select atleast one Quantity for particular Part No.");
            $('#errorMsgPart').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        resultList.push(obj);
    }

    function chkIsDeletedRow(i, delrec) {
        if (delrec == true) {
            $('#PartNo_' + i).prop("required", false);
            $('#LabourCost_' + i).prop("required", false);
            return true;
        }
        else {
            return false;
        }
    }

    var deletedCount = Enumerable.From(resultList).Where(x => x.IsDeleted).Count();
    var Isdeleteavailable = deletedCount > 0;
    if (deletedCount == resultList.length && TotalPages == 1) {
        bootbox.alert("Sorry!. You cannot delete all rows");
        $('#myPleaseWait').modal('hide');
        return false;
    }

    var isFormValid = formInputValidation("tab-3", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsgPart').css('visibility', 'visible');

        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }

    var _Mainindex;
    $('#PartReplacementResultId tr').each(function () {
        _Mainindex = $(this).index();
    });
    for (var i = 0; i <= _Mainindex; i++) {
        if ($("#StockType_" + i).val() == "On Demand") {
            bootbox.alert("You need to purchase the part!")
            break;
        }
    }


    var Isdeleteavailable = Enumerable.From(resultList).Where(x => x.IsDeleted).Count() > 0;
    if (Isdeleteavailable) {
        message = "Are you sure that you want to delete the record(s)?";

        bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (result) {
            if (result) {
                submit(resultList);
            }
            else {

            }
        });
    }
    else {
        submit(resultList);
    }
});

function submit(result) {
    var obj1 = {
        WorkOrderId: $("#primaryID").val(),
        PartReplacementDets: result
    }
    var isFormValid = formInputValidation("tab-3", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsgPart').css('visibility', 'visible');

        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }

    var jqxhr = $.post("/api/ScheduledWorkOrder/addPartReplacement", obj1, function (response) {
        var result = JSON.parse(response);
        var htmlval = ""; $('#tablebody').empty();
        $('#primaryID').val(result.WorkOrderId);
        PartReplacementDetails = result.PartReplacementDets;
        UserRoleGlobal = result.UserRole;
        if (PartReplacementDetails == null) {
            PartReplacementPushEmptyMessage();
        }
        else {
            bindDatatoPartReplacementDatagrid(PartReplacementDetails);
            var _Mainindex;
            $('#PartReplacementResultId tr').each(function () {
                _Mainindex = $(this).index();
            });
            for (var i = 0; i <= _Mainindex; i++) {
                if ((PartReplacementDetails[i].StockUpdateDetId != 0 || PartReplacementDetails[i].StockUpdateDetId != "") && (PartReplacementDetails[i].PartReplacementId != 0 || PartReplacementDetails[i].PartReplacementId != "")) {
                    $("#QuantityPopUp_" + i).hide();
                }
                var LabourCost = $("#LabourCost_" + i).val();
                LabourCost = (LabourCost == "0") ? "" : LabourCost;
                var optionId = $('#hdnLifeSpanOptionId_' + i).val();
                EnableDisableForLifeSpanOption(i, optionId);
            }

        }
        $('#TotalSparePartCost').val(result.TotalSparePartCost);
        $('#TotalLabourCost').val(result.TotalLabourCost);
        $('#TotalCost').val(result.TotalCost);

        if ($('#ActionType').val() != "VIEW" && hasApproveRolePermission != true) {
            $('#CostHide').hide();

            $('#TotalCostSingleHide').hide();
            $('#LabourCostHide').hide();
            $('#TotalCostHide').hide();

            var _index;
            $('#PartReplacementResultId tr').each(function () {
                _index = $(this).index();
            });

            for (var i = 0; i <= _index; i++) {
                $('#CostColumn1_' + i).hide();
                $('#CostColumn2_' + i).hide();
                $('#CostColumn3_' + i).hide();
                $('#LabourCost_' + i).prop('required', false);
            }
        }

        if ($('#ActionType').val() == "VIEW") {
            $('#CostHide').hide();

            $('#TotalCostSingleHide').hide();
            $('#LabourCostHide').hide();
            $('#TotalCostHide').hide();

            var _index;
            $('#PartReplacementResultId tr').each(function () {
                _index = $(this).index();
            });

            for (var i = 0; i <= _index; i++) {
                $('#CostColumn1_' + i).hide();
                $('#CostColumn2_' + i).hide();
                $('#CostColumn3_' + i).hide();
                $('#LabourCost_' + i).prop('required', false);
                $("#QuantityPopUp_" + i).hide();
            }
        }

        $('#errorMsgPart').css('visibility', 'hidden');
        $(".content").scrollTop(0);
        showMessage('Part Replacement', CURD_MESSAGE_STATUS.SS);
        $("#top-notifications").modal('show');
        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);
        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);

        $('#btnCompletionSave').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
    },
        "json")
        .fail(function (response) {
            var errorMessage = "";
            errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsgPart').css('visibility', 'visible');

            $('#btnCompletionSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
}

$("#chk_PartReplacementIsDelete").change(function () {
    var Isdeletebool = this.checked;

    if (this.checked) {
        $('#PartReplacementResultId tr').map(function (i) {
            if ($("#Isdeleted_" + i).prop("disabled")) {
                $("#Isdeleted_" + i).prop("checked", false);
            }
            else {
                $("#Isdeleted_" + i).prop("checked", true);
            }
        });
    } else {
        $('#PartReplacementResultId tr').map(function (i) {
            $("#Isdeleted_" + i).prop("checked", false);
        });
    }
});

//Tab 3 Grid Functions
function PartReplacementNewRow() {

    var inputpar = {
        inlineHTML: PartReplacementGridHtml(),//Inline Html
        TargetId: "#PartReplacementResultId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    $('#chk_PartReplacementIsDelete').prop("checked", false);
    $('#PartReplacementResultId tr:last td:first input').focus();
    BindEventsForLifespan();
}

function PartReplacementPushEmptyMessage() {
    $("#PartReplacementResultId").empty();
    var emptyrow = '<tr><td colspan=8 ><h3> &nbsp;&nbsp;&nbsp;&nbsp; No records to display</h3></td></tr>'
    $("#PartReplacementResultId ").append(emptyrow);
}

function PartReplacementGridHtml() {

    return '<tr class="ng-scope" style=""> <td width="1%" data-original-title="" title=""> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" value="false" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(PartReplacementResultId,chk_PartReplacementIsDelete)" tabindex="0"> </label> </div></td><td width="5%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" placeholder="Please select" required id="PartNo_maxindexval" autocomplete="off" value="" class="form-control fetchField" onkeyup="FetchdataPartNo(event,maxindexval)" onpaste="FetchdataPartNo(event,maxindexval)" change="FetchdataPartNo(event,maxindexval)" oninput="FetchdataPartNo(event,maxindexval)"> </div><input type="hidden" id="SparePartStockRegisterId_maxindexval"/> <input type="hidden" id="PartReplacementId_maxindexval"/> <input type="hidden" id="StockUpdateDetId_maxindexval"/> <div class="col-sm-12" id="divFetchPart_maxindexval"></div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled id="PartDescription_maxindexval" value="" class="form-control fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" maxlength="5" id="EstimatedLifeSpan_maxindexval" disabled value="" class="form-control text-right fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="hidden" id="hdnLifeSpanOptionId_maxindexval" value=""/> <input type="text" disabled id="LifeSpanOption_maxindexval" value="" class="form-control fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" id="LifeSpanExpiryDate_maxindexval" disabled value="" class="form-control datetimeNoFuture"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <select class="form-control" required id="StockType_maxindexval" name="StockType"></select> </div></td><td width="12%" style="text-align: center;" data-original-title="" title=""> <div class="col-sm-8"> <input type="text" disabled data-value=" " id="Quantity_maxindexval" value=" " class="form-control"> </div><div class="col-sm-0"> <a data-toggle="modal" class="btn btn-sm btn-primary btn-info btn-lg" id="QuantityPopUp_maxindexval" onclick="GetQuantityPopupdetails(maxindexval)" title="Real Time History" tabindex="0" data-target="#myModalquantity"> <span class="glyphicon glyphicon-modal-window"></span> </a> </div></td><td width="10%" id="CostColumn1_maxindexval" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" data-value=" " disabled id="CostPerUnit_maxindexval" value="" class="form-control"> </div></td><td id="CostColumn2_maxindexval" width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" data-value=" "id="LabourCost_maxindexval" value=""  class="form-control decimalPointonly text-right" maxlength="11" required pattern="^[0-9]+(\.[0-9]{1,2})?$" onchange="TotalCostValidation()" oninput="TotalCostValidation()"> </div></td><td id="CostColumn3_maxindexval" width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="hidden" data-value=" "  id="PQT_maxindexval" value="" class="form-control"> <input type="hidden" data-value=" "  id="PQV_maxindexval" value="" class="form-control"> <input type="text" data-value=" " disabled id="TotalCost_maxindexval" value="" class="form-control"> </div></td></tr>';


}


function TotalCostValidation() {
    var _index;
    $('#PartReplacementResultId tr').each(function () {
        _index = $(this).index();
    });
    for (var i = 0; i <= _index; i++) {
        var CostUnitvaild = $('#CostPerUnit_' + i).val();
        var LabourCostvaild = $('#LabourCost_' + i).val();
        var CostUnit = parseInt($('#CostPerUnit_' + i).val());
        var LabourCost = parseInt($("#LabourCost_" + i).val());
        var TotalCost = document.getElementById("#TotalCost_" + i);
        if (CostUnitvaild == "") {
            CostUnit = 0;
        }
        if (LabourCostvaild == "") {
            LabourCost = 0;
        }
        TotalCost = parseInt(CostUnit) + parseInt(LabourCost);
        $('#TotalCost_' + i).val(TotalCost);
    }
}


function TotalCostValidationpop(m) {
    var _index;
    $('#PartReplacementResultId tr').each(function () {
        _index = $(this).index();
    });
    //for (var i = 0; i <= _index; i++) {
    //    var CostUnitvaild = $('#CostPerUnit_' + i).val();
    //    var CostUnit = parseInt($('#CostPerUnit_' + i).val());
    //    var LabourCost = parseInt($("#LabourCost_" + i).val());
    //    var TotalCost = document.getElementById("#TotalCost_" + i);
    //    if (CostUnitvaild == "") {
    //        CostUnit = 0;
    //    }
    //    TotalCost = parseInt(CostUnit) + parseInt(LabourCost);
    //    $('#TotalCost_' + i).val(TotalCost);
    //}

    var CostUnit = parseInt($('#CostPerUnit_' + m).val());
    var LabourCost = parseInt($("#LabourCost_" + m).val());
    TotalCost = parseInt(CostUnit) + parseInt(LabourCost);
    $('#TotalCost_' + m).val(TotalCost);
}

function AddPartReplacementNewRow() {
    var _index;
    $('#PartReplacementResultId tr').each(function () {
        _index = $(this).index();

    });
    var flagAllow = 0;
    for (var i = 0; i <= _index; i++) {
        var SparePartStockRegisterId = $("#SparePartStockRegisterId_" + i).val();
        var LabourCost = $("#LabourCost_" + i).val();
        // LabourCost = (LabourCost == "0") ? "" : LabourCost;
        if ($('#ActionType').val() != "VIEW" && hasApproveRolePermission != true) {
            if (SparePartStockRegisterId) { }
            else
                flagAllow++;
        }
        else {
            if (SparePartStockRegisterId && LabourCost) { }
            else
                flagAllow++;
        }

    }
    if (flagAllow != 0) {
        bootbox.alert("Please enter data for existing rows");
        return;

    }
    PartReplacementNewRow();
    if ($('#ActionType').val() != "VIEW" && hasApproveRolePermission != true) {
        $('#CostHide').hide();

        $('#TotalCostSingleHide').hide();
        $('#LabourCostHide').hide();
        $('#TotalCostHide').hide();

        var _index;
        $('#PartReplacementResultId tr').each(function () {
            _index = $(this).index();
        });

        for (var i = 0; i <= _index; i++) {
            $('#CostColumn1_' + i).hide();
            $('#CostColumn2_' + i).hide();
            $('#CostColumn3_' + i).hide();
            $('#LabourCost_' + i).prop('required', false);
        }

    }
    var rowCount = $('#PartReplacementResultId tr:last').index();
    $.each(window.StockTypeListGloabal, function (index, value) {
        $('#StockType_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
    formInputValidation("form");
    $('.decimalPointonly').each(function (index) {
        //$(this).attr('id', 'ParamMapMin_' + index);
        var vrate = document.getElementById(this.id);
        vrate.addEventListener('input', function (prev) {
            return function (evt) {
                if ((!/^\d{0,8}(?:\.\d{0,2})?$/.test(this.value))) {
                    this.value = prev;
                }
                else {
                    prev = this.value;
                }
            };
        }(vrate.value), false);
    });

}

function bindDatatoPartReplacementDatagrid(list) {

    if (list.length > 0) {
        $('#PartReplacementResultId').empty()
        var html = '';

        $(list).each(function (index, data) {
            if (data.EstimatedLifeSpanDate == null)
                data.EstimatedLifeSpanDate = "";
            if (data.EstimatedLifeSpanOption == null)
                data.EstimatedLifeSpanOption = "";
            if (data.EstimatedLifeSpan == null)
                data.EstimatedLifeSpan = "";
            //if (data.StockType == null)
            //    data.StockType = "";
            if (data.EstimatedLifeSpanDate != "")
                data.EstimatedLifeSpanDate = moment(data.EstimatedLifeSpanDate).format("DD-MMM-YYYY");
            //$(window.StockTypeListGloabal).each(function (_index, _data) {
            //    $('#StockType_' + index + '').append('<option value="' + _data.LovId + '">' + _data.FieldValue + '</option>');

            //});
            // $('#StockType_' + index).val(data.StockType);

            html = '<tr class="ng-scope" style=""> <td width="2%" data-original-title="" title=""> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" onchange="IsDeleteValidation(' + index + ')" id="Isdeleted_' + index + '" autocomplete="off" tabindex="0" aria-="false" aria-checked="false" aria-invalid="false"> </label> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" placeholder="Please select" required disabled id="PartNo_' + index + '" value="' + data.PartNo + '" class="form-control fetchField" onkeyup="FetchdataPartNo(event,' + index + ')" onpaste="FetchdataPartNo(event,' + index + ')" change="FetchdataPartNo(event,' + index + ')" oninput="FetchdataPartNo(event,' + index + ')"> </div><input type="hidden" id="SparePartStockRegisterId_' + index + '" value="' + data.SparePartStockRegisterId + '"/> <input type="hidden" id="PartReplacementId_' + index + '" value="' + data.PartReplacementId + '"/> <input type="hidden" id="StockUpdateDetId_' + index + '" value="' + data.StockUpdateDetId + '"/> <div class="col-sm-12" id="divFetchPart_' + index + '"></div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled id="PartDescription_' + index + '" value="' + data.PartDescription + '" class="form-control fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" maxlength="5" id="EstimatedLifeSpan_' + index + '" disabled value="' + data.EstimatedLifeSpan + '" class="form-control text-right fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="hidden" id="hdnLifeSpanOptionId_' + index + '" value="' + data.LifeSpanOptionId + '"/> <input type="text" disabled id="LifeSpanOption_' + index + '" value="' + data.EstimatedLifeSpanOption + '" class="form-control fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" id="LifeSpanExpiryDate_' + index + '" disabled class="form-control datetimeNoFuture" value="' + data.EstimatedLifeSpanDate + '"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <select class="form-control" required id="StockType_' + index + '" name="StockType"></select> </div></td><td width="14%" style="text-align: center;" data-original-title="" title=""> <div class="col-sm-8"> <input type="text" disabled data-value=" " id="Quantity_' + index + '" value="' + data.Quantity + ' " class="form-control"> </div><div class="col-sm-0"> <a data-toggle="modal" class="btn btn-sm btn-primary btn-info btn-lg" id="QuantityPopUp_' + index + '" onclick="GetQuantityPopupdetails(' + index + ')" title="Real Time History" tabindex="0" data-target="#myModalquantity"> <span class="glyphicon glyphicon-modal-window"></span> </a> </div></td><td id="CostColumn1_' + index + '" width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" data-value=" " disabled id="CostPerUnit_' + index + '" value="' + data.CostPerUnit + '" class="form-control"> </div></td><td id="CostColumn2_' + index + '" width="7%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" required data-value=" " id="LabourCost_' + index + '" pattern="^[0-9]+(.[0-9]{1,2})?$" class="form-control decimalPointonly text-right" int-length="10" decimal-length="2" comma required number onchange="TotalCostValidation()" oninput="TotalCostValidation()"> </div></td><td id="CostColumn3_' + index + '" width="7%" style="text-align: center;" data-original-title="" title=""> <div><input type="hidden" data-value=" " disabled id="PQT_' + index + '" value="' + data.popUpQuantityTaken + '" class="form-control"> <input type="hidden" data-value=" " disabled id="PQV_' + index + '" value="' + data.PopUpQuantityAvailable + '" class="form-control"> <input type="text" data-value=" " disabled id="TotalCost_' + index + '" value="' + data.TotalCost + '" class="form-control"> </div></td></tr>';

            $('#PartReplacementResultId').append(html);

            BindEventsForLifespan();

            if (data.IsDeleted == true) {
                $('#Isdeleted_' + index + '').prop('checked', true);
            }

            $('#LabourCost_' + index + '').val(data.LabourCost);
            TotalCostValidation();
            GridtotalRecords = data.TotalRecords;
            TotalPages = data.TotalPages;
            LastRecord = data.LastRecord;
            FirstRecord = data.FirstRecord;
            pageindex = data.PageIndex;
            if (data.StockType == 37)
                $('#StockType_' + index).empty().append('<option value="' + data.StockType + '">Inventory</option>').prop('disabled', true);
            if (data.StockType == 38)
                $('#StockType_' + index).empty().append('<option value="' + data.StockType + '">On Demand</option>').prop('disabled', true);

        });
        var mapIdproperty = ["Isdeleted-Isdeleted_", "SparePartStockRegisterId-SparePartStockRegisterId_", "PartReplacementId-PartReplacementId_", "StockUpdateDetId-StockUpdateDetId_", "PartNo-PartNo_", "PartDescription-PartDescription_", "ItemNo-ItemNo_", "ItemDescription-ItemDescription_", "StockType-StockType_", "Quantity-Quantity_", "CostPerUnit-CostPerUnit_", "InvoiceNo-InvoiceNo_", "VendorName-VendorName_", "LabourCost-LabourCost_", "TotalCost-TotalCost_", "PopUpQuantityAvailable-PQV_", "PopUpQuantityTaken-PQT_"];
        var htmltext = PartReplacementGridHtml();



        id = $('#primaryID').val();
        var obj = { formId: "#tab-3", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "PartReplacementDets", tableid: '#PartReplacementResultId', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/ScheduledWorkOrder/GetPartReplacement/" + id, pageindex: pageindex, pagesize: pagesize };

        CreateFooterPagination(obj);
    }
    var _index;
    $('#PartReplacementResultId tr').each(function () {
        _index = $(this).index();
    });
    $('.decimalPointonly').each(function (index) {
        //$(this).attr('id', 'ParamMapMin_' + index);
        var vrate = document.getElementById(this.id);
        vrate.addEventListener('input', function (prev) {
            return function (evt) {
                if ((!/^\d{0,8}(?:\.\d{0,2})?$/.test(this.value))) {
                    this.value = prev;
                }
                else {
                    prev = this.value;
                }
            };
        }(vrate.value), false);
    });

    if ($('#ActionType').val() == "VIEW") {
        for (var i = 0; i <= _index; i++) {
            $('#PartNo_' + i).prop('disabled', true);
            $('#LabourCost_' + i).prop('disabled', true);
            $('#Isdeleted_' + i).prop('disabled', true);
        }
    }
    var rowCount = $('#PartReplacementResultId tr:last').index();
    $.each(window.StockTypeListGloabal, function (index, value) {
        $('#StockType_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });

    formInputValidation("form");

}

function FetchdataPartNo(event, index) {

    if (index > 0) {
        $('#divFetchPart_' + index).css({
            'top': $('#PartNo_' + index).offset().top - $('#dataTableCheckList').offset().top + $('#PartNo_' + index).innerHeight(),
            //'width': $('#PartNo_' + index).outerWidth()
        });
    }

    else {
        $('#divFetchPart_' + index).css({
            // 'width': $('#PartNo_' + index).outerWidth()
        });
    }


    var ItemMst = {
        SearchColumn: 'PartNo_' + index + '-PartNo',//Id of Fetch field
        ResultColumns: ["SparePartsId" + "-Primary Key", 'Partno' + '-Partno' + index, 'PartDescription' + '-PartDescription' + index, 'EstimatedLifeSpanOption' + '-EstimatedLifeSpanOption' + index],//Columns to be displayed
        FieldsToBeFilled: ["SparePartStockRegisterId_" + index + "-SparePartsId", 'PartNo_' + index + '-Partno', 'PartDescription_' + index + '-PartDescription', 'hdnLifeSpanOptionId_' + index + '-LifeSpanOptionId', 'LifeSpanOption_' + index + '-EstimatedLifeSpanOption', 'ItemNo_' + index + '-ItemCode', 'ItemDescription_' + index + '-ItemDescription']//id of element - the model property
    };
    DisplayFetchResult('divFetchPart_' + index, ItemMst, "/api/Fetch/FetchItemMstdetais", "Ulfetch7" + index, event, 1);
}


//---------------------------3rd tab Quantity Popup-----------------------------------------------

function BindEventsForLifespan() {
    $("input[id^='hdnLifeSpanOptionId_']").unbind('change');
    $("input[id^='hdnLifeSpanOptionId_']").change(function () {
        var id = $(this).attr('id');
        var index = id.split('_')[1];
        var optionId = $(this).val();
        EnableDisableForLifeSpanOption(index, optionId);
    });
}

function EnableDisableForLifeSpanOption(index, optionId) {
    if (optionId == 357) {
        $('#LifeSpanExpiryDate_' + index).attr('disabled', false);
        $('#EstimatedLifeSpan_' + index).attr('disabled', false);
    }
    else if (optionId == 358) {
        $('#LifeSpanExpiryDate_' + index).val('').attr('disabled', true);
        $('#EstimatedLifeSpan_' + index).val('').attr('disabled', true);
    } else {
        $('#LifeSpanExpiryDate_' + index).val('').attr('disabled', true);
        $('#EstimatedLifeSpan_' + index).attr('disabled', false);
    }
}

function GetQuantityPopupdetails(element) {
    var PartId = $('#SparePartStockRegisterId_' + element).val() // PartReplacementDetails[element].SparePartStockRegisterId;
    if (PartId == "") {
        //$('#myModalquantity').hide();
        //$('.modal-backdrop').fadeOut(100);
        //bootbox.alert("Please choose the quantity with in the available count!");
        $("#QuantityPopupGrid").empty();
        $("#btnPartPopUpSave").hide();
        return false;
    }
    else {
        var result = [];
        var jqxhr =
            $.get("/api/ScheduledWorkOrder/PartReplacementPopUp/" + PartId)
                .done(function (response) {
                    var result = JSON.parse(response);
                    PartReplacementPopUpDetails = result.PartReplacementPopUpDets;
                    $("#QuantityPopupGrid").empty();
                    $.each(result.PartReplacementPopUpDets, function (index, value) {
                        AddNewRowQuantityPopUp();
                        $("#PopUpPartNo_" + index).val(result.PartReplacementPopUpDets[index].PopUpPartNo).prop("disabled", "disabled").attr('title', result.PartReplacementPopUpDets[index].PopUpPartNo);
                        $("#PopUpStockUpdateDetId_" + index).val(result.PartReplacementPopUpDets[index].StockUpdateDetId);
                        $("#PopUpSparePartStockRegisterId_" + index).val(result.PartReplacementPopUpDets[index].SparePartStockRegisterId);
                        $("#PopUpPartDescription_" + index).val(result.PartReplacementPopUpDets[index].PopUpPartDescription).prop("disabled", "disabled").attr('title', result.PartReplacementPopUpDets[index].PopUpPartDescription);
                        $("#PopUpQuantityAvailable_" + index).val(result.PartReplacementPopUpDets[index].PopUpQuantityAvailable).prop("disabled", "disabled").attr('title', result.PartReplacementPopUpDets[index].PopUpQuantityAvailable);
                        $("#PopUpCostPerUnit_" + index).val(result.PartReplacementPopUpDets[index].PopUpCostPerUnit).prop("disabled", "disabled").attr('title', result.PartReplacementPopUpDets[index].PopUpCostPerUnit);
                        $("#PopUpInvoiceNo_" + index).val(result.PartReplacementPopUpDets[index].PopUpInvoiceNo).prop("disabled", "disabled").attr('title', result.PartReplacementPopUpDets[index].PopUpInvoiceNo);
                        $("#PopUpVendorName_" + index).val(result.PartReplacementPopUpDets[index].PopUpVendorName).prop("disabled", "disabled").attr('title', result.PartReplacementPopUpDets[index].PopUpVendorName);
                        $("#PopUpQuantityTaken_" + index).val(result.PartReplacementPopUpDets[index].PopUpQuantityTaken).attr('title', result.PartReplacementPopUpDets[index].PopUpQuantityTaken);
                        $("#PopUpSelected_" + index).val(result.PartReplacementPopUpDets[index].PopUpSelected);

                    });

                    //************************************************ Grid Pagination *******************************************

                    //if (result.PartReplacementPopUpDets.length > 0) {
                    //    GridtotalRecords = result.MonthlyStockRegisterModalData[0].TotalRecords;
                    //    TotalPages = result.MonthlyStockRegisterModalData[0].TotalPages;
                    //    LastRecord = result.MonthlyStockRegisterModalData[0].LastRecord;
                    //    FirstRecord = result.MonthlyStockRegisterModalData[0].FirstRecord;
                    //    pageindex = result.MonthlyStockRegisterModalData[0].PageIndex;
                    //}

                    var mapIdproperty = ["PopUpPartNo-PopUpPartNo_", "PopUpPartDescription-PopUpPartDescription_", "PopUpQuantityAvailable-PopUpQuantityAvailable_", "PopUpCostPerUnit-PopUpCostPerUnit_", "PopUpInvoiceNo-PopUpInvoiceNo_", "PopUpVendorName-PopUpVendorName_", "PopUpQuantityTaken-PopUpQuantityTaken_", "PopUpSelected-PopUpSelected_"];

                    var htmltext = BindNewRowQuantityPopUp();//Inline Html

                    //var objModal = {
                    //    formId: "#form", IsView: ($('#ActionType').val() == ""), PageNumber: pageindex, flag: "", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "MonthlyStockRegisterModalData", tableid: '#MonthlyStockRegisterModalTbl', destionId: "#paginationfooterModal", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/MonthlyStockRegister/GetModal/" + _MStkRegisterWO
                    //};

                    //CreateFooterPagination(objModal)

                    //************************************************ End *******************************************************
                    var _index;
                    $('#QuantityPopupGrid tr').each(function () {
                        _index = $(this).index();
                    });
                    if (_index == undefined)
                        $("#btnPartPopUpSave").hide();
                    else
                        $("#btnPartPopUpSave").show();
                    var status = $('#divWOStatus').text();
                    if (status == "Closed") {
                        $('#btnPartPopUpSave').hide();

                        $('#btnCompletionSave').hide();
                        $('[id^=PopUpSelected_]').attr('disabled', true);
                    } else {
                        if (_index != undefined) {
                            $('#btnPartPopUpSave').show();
                            $('#btnCompletionSave').show();
                        }
                        $('[id^=PopUpSelected_]').attr('disabled', false);
                    }

                    $('#myPleaseWait').modal('hide');
                    $("div.errormsgcenter").css("");
                    $('#errorMsgPart').css('visibility', 'hidden');
                })
                .fail(function (response) {
                    $('#myPleaseWait').modal('hide');
                    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                    $('#errorMsgPart').css('visibility', 'visible');
                });
    }

}

function AddNewRowQuantityPopUp() {
    var inputpar = {
        inlineHTML: BindNewRowQuantityPopUp(),

        IdPlaceholderused: "maxindexval",
        TargetId: "#QuantityPopupGrid",
        TargetElement: ["tr"]

    }
    AddNewRowToDataGrid(inputpar);
    $('#QuantityPopupGrid tr:last td:first input').focus();

    $('.digOnly').keypress(function (e) {
        var regex = new RegExp(/[^.a-zA-Z]/, '');
        var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
        if (regex.test(str)) {
            return true;
        }
        e.preventDefault();
        return false;
    });
    $('.digOnly').on('paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[a-zA-Z0-9~`!@.#$%^&*_+|\\:{}\[\];-?<>\^\"\']/g, ''));
        }, 5);
    });

    $('.Zerofirst').on('input propertychange paste', function (e) {
        var reg = /^0+/gi;
        if (this.value.match(reg)) {
            this.value = this.value.replace(reg, '');
        }
    });
}

function BindNewRowQuantityPopUp() {
    return ' <tr> <td width="12%" style="text-align: center;" title=""> <div> <div> <input type="text" class="form-control" id="PopUpPartNo_maxindexval" disabled><input type="hidden" id="PopUpStockUpdateDetId_maxindexval"/><input type="hidden" id="PopUpSparePartStockregId_maxindexval"/> </div></div></td><td width="16%" style="text-align: center;" title=""> <div> <input type="text" class="form-control" id="PopUpPartDescription_maxindexval" disabled> </div></td><td  width="13%" style="text-align: center;" title=""> <div> <input type="text" class="form-control" id="PopUpQuantityAvailable_maxindexval" disabled> </div></td><td width="13%" style="text-align: center;" title="Cost (Currency)"> <div> <input type="text" class="form-control" id="PopUpCostPerUnit_maxindexval" disabled> </div></td><td width="12%" style="text-align: center;" title=""> <div> <input type="text" class="form-control" id="PopUpInvoiceNo_maxindexval" disabled> </div></td><td width="15%" style="text-align: center;" title=""> <div> <input type="text" class="form-control" id="PopUpVendorName_maxindexval" disabled> </div></td><td width="13%" style="text-align: center;" title=""> <div> <input type="text" class="form-control digOnly Zerofirst text-right" pattern="^((?!(0))[0-9]{1,15})$" maxlength="8" id="PopUpQuantityTaken_maxindexval" disabled> </div></td><td width="5%" data-original-title="" title=""> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" id="PopUpSelected_maxindexval" onclick="DisableSelected(maxindexval)"  autocomplete="off" tabindex="0" aria-="false" aria-checked="false" aria-invalid="false"> </label> </div></td></tr> '
}

function DisableSelected(element) {
    var _index;
    $('#QuantityPopupGrid tr').each(function () {
        _index = $(this).index();

    });

    if ($("#PopUpSelected_" + element).prop('checked') == true) {
        $("#PopUpQuantityTaken_" + element).prop('disabled', false);
        $("#PopUpQuantityTaken_" + element).prop('required', true);
        //for (var i = 0; i <= _index ; i++) {
        //    $("#PopUpSelected_" + i).prop('checked', false);
        //    $("#PopUpSelected_" + i).prop('disabled', true);
        //}
        //$("#PopUpSelected_" + element).prop('checked', true);
        //var value = $("#FieldValue_" + element).val();
        //$("#DefaultValue").val(value).prop("disabled", "disabled");
    }
    if ($("#PopUpSelected_" + element).prop('checked') == false) {
        $("#PopUpQuantityTaken_" + element).prop('disabled', true);
        $("#PopUpQuantityTaken_" + element).prop('required', false);

        $("#PopUpQuantityTaken_" + element).val('');

        //for (var i = 0; i <= _index ; i++) {
        //    $("#PopUpSelected_" + i).prop('checked', false);
        //    $("#PopUpSelected_" + i).prop('disabled', false);
        //}
    }
}

$("#btnPartPopUpSave").click(function () {
    //$('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgPart').css('visibility', 'hidden');

    var _index;
    $('#QuantityPopupGrid tr').each(function () {
        _index = $(this).index();
    });
    var resultList = [];
    for (var i = 0; i <= _index; i++) {
        var obj = {
            SparePartStockRegisterId: $('#PopUpSparePartStockRegisterId_' + i).val(),
            StockUpdateDetId: $('#PopUpStockUpdateDetId_' + i).val(),
            PopUpPartNo: $('#PopUpPartNo_' + i).val(),
            PopUpPartDescription: $('#PopUpPartDescription_' + i).val(),
            PopUpQuantityAvailable: $('#PopUpQuantityAvailable_' + i).val(),
            PopUpCostPerUnit: $('#PopUpCostPerUnit_' + i).val(),
            PopUpInvoiceNo: $('#PopUpInvoiceNo_' + i).val(),
            PopUpVendorName: $('#PopUpVendorName_' + i).val(),
            PopUpInvoiceNo: $('#PopUpInvoiceNo_' + i).val(),
            PopUpQuantityTaken: $('#PopUpQuantityTaken_' + i).val(),
            PopUpSelected: $('#PopUpSelected_' + i).is(":checked"),
        };
        resultList.push(obj);
    }

    var _Mainindex;
    $('#PartReplacementResultId tr').each(function () {
        _Mainindex = $(this).index();
    });
    var MainresultList = [];
    for (var j = 0; j <= _Mainindex; j++) {
        var Mainobj = {
            StockUpdateDetId: $('#StockUpdateDetId_' + j).val(),
            PartReplacementId: $('#PartReplacementId_' + j).val(),
            PartNo: $('#PartNo_' + j).val(),
            PartDescription: $('#PartDescription_' + j).val(),
            ItemNo: $('#ItemNo_' + j).val(),
            ItemDescription: $('#ItemDescription_' + j).val(),
            StockType: $('#StockType_' + j).val(),
            WorkOrderId: $("#primaryID").val(),
            SparePartStockRegisterId: $('#SparePartStockRegisterId_' + j).val(),
            EstimatedLifeSpan: $('#EstimatedLifeSpan_' + j).val(),
            EstimatedLifeSpanOption: $('#LifeSpanOption_' + j).val(),
            EstimatedLifeSpanDate: $('#LifeSpanExpiryDate_' + j).val(),
            Quantity: $('#Quantity_' + j).val(),
            PopUpQuantityAvailable: $('#PQV_' + j).val(),
            PopUpQuantityTaken: $('#PQT_' + j).val(),
            InvoiceNo: $('#InvoiceNo_' + j).val(),
            VendorName: $('#VendorName_' + j).val(),
            CostPerUnit: $('#CostPerUnit_' + j).val(),
            LabourCost: $('#LabourCost_' + j).val(),
            TotalCost: $('#TotalCost_' + j).val(),
            IsDeleted: $('#Isdeleted_' + j).is(":checked"),
        };
        MainresultList.push(Mainobj);
    }

    var isFormValid = formInputValidation("myModalquantity", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsgPurchase').css('visibility', 'visible');

        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }

    if (Enumerable.From(resultList).Any(x => x.PopUpSelected == true)) {
        resultList = Enumerable.From(resultList).Where(x => x.PopUpSelected == true).ToArray();
        //     MainresultList = Enumerable.From(MainresultList).Where(x=>x.SparePartStockRegisterId == PartReplacementPopUpDetails[0].SparePartStockRegisterId).ToArray();
        var MainArrayCount = MainresultList.length;
        var ArrayCount = resultList.length;
        var SumOfQuantity = 0;
        var SumOfCostUnit = 0;
        var TotalQtyTaken = 0;

        var IsTrue = 0;
        for (var m = 0; m < ArrayCount; m++) {
            SumOfQuantity = parseInt(SumOfQuantity) + parseInt(resultList[m].PopUpQuantityTaken);
            //SumOfCostUnit = parseInt(SumOfCostUnit) + parseInt(resultList[m].PopUpCostPerUnit);
            var popUpQuantityava = resultList[m].PopUpQuantityAvailable == null ? 0 : parseInt(resultList[m].PopUpQuantityAvailable);
            SumOfCostUnit = parseInt(resultList[m].PopUpQuantityTaken) * parseInt(resultList[m].PopUpCostPerUnit);
            TotalQtyTaken = parseInt(TotalQtyTaken) + parseInt(SumOfCostUnit);
            pqvq = popUpQuantityava;
            // TotalCostValidationpop(m);

        }
        // TotalCostUnit = parseInt(SumOfQuantity) * parseInt(SumOfCostUnit);

        if (ArrayCount > 0) {
            MainresultList[MainArrayCount - 1].SparePartStockRegisterId = MainresultList[MainArrayCount - 1].SparePartStockRegisterId;
            MainresultList[MainArrayCount - 1].PartReplacementId = MainresultList[MainArrayCount - 1].PartReplacementId;
            MainresultList[MainArrayCount - 1].PartNo = MainresultList[MainArrayCount - 1].PartNo;
            MainresultList[MainArrayCount - 1].PartDescription = MainresultList[MainArrayCount - 1].PartDescription;
            MainresultList[MainArrayCount - 1].ItemNo = MainresultList[MainArrayCount - 1].ItemNo;
            MainresultList[MainArrayCount - 1].ItemDescription = MainresultList[MainArrayCount - 1].ItemDescription;
            MainresultList[MainArrayCount - 1].StockUpdateDetId = resultList[0].StockUpdateDetId;
            MainresultList[MainArrayCount - 1].EstimatedLifeSpan = MainresultList[MainArrayCount - 1].EstimatedLifeSpan;
            if (MainresultList[MainArrayCount - 1].EstimatedLifeSpanDate == undefined) {
                MainresultList[MainArrayCount - 1].EstimatedLifeSpanDate = "";
            }
            MainresultList[MainArrayCount - 1].EstimatedLifeSpanDate = MainresultList[MainArrayCount - 1].EstimatedLifeSpanDate;
            MainresultList[MainArrayCount - 1].EstimatedLifeSpanOption = MainresultList[MainArrayCount - 1].EstimatedLifeSpanOption;
            MainresultList[MainArrayCount - 1].Quantity = SumOfQuantity;        //resultList[0].PopUpQuantityTaken;
            MainresultList[MainArrayCount - 1].CostPerUnit = TotalQtyTaken;     //resultList[0].PopUpCostPerUnit;
            MainresultList[MainArrayCount - 1].InvoiceNo = resultList[0].PopUpInvoiceNo;
            MainresultList[MainArrayCount - 1].VendorName = resultList[0].PopUpVendorName;
            MainresultList[MainArrayCount - 1].TotalCost = "";
            MainresultList[MainArrayCount - 1].PopUpQuantityAvailable = pqvq;
            MainresultList[MainArrayCount - 1].IsDeleted = MainresultList[MainArrayCount - 1].IsDeleted;
        }
        for (var n = 0; n < ArrayCount; n++) {
            var UnQtyAvailable = parseInt(resultList[n].PopUpQuantityAvailable);
            var UnQtyTaken = parseInt(resultList[n].PopUpQuantityTaken);
            if (UnQtyAvailable < UnQtyTaken) {
                IsTrue = IsTrue + 1;
            }
        }

        if (IsTrue != 0) {
            bootbox.alert("Please choose the quantity with in the available count!");
            return false;
        }
        else {
            bindDatatoPartReplacementDatagrid(MainresultList);
            var _MainHideindex;
            $('#PartReplacementResultId tr').each(function () {
                _MainHideindex = $(this).index();
            });
            for (var i = 0; i < _Mainindex; i++) {
                $("#QuantityPopUp_" + i).hide();
            }
            if ($('#ActionType').val() != "VIEW" && hasApproveRolePermission != true) {
                $('#CostHide').hide();

                $('#TotalCostSingleHide').hide();
                $('#LabourCostHide').hide();
                $('#TotalCostHide').hide();

                var _index;
                $('#PartReplacementResultId tr').each(function () {
                    _index = $(this).index();
                });

                for (var i = 0; i <= _index; i++) {
                    $('#CostColumn1_' + i).hide();
                    $('#CostColumn2_' + i).hide();
                    $('#CostColumn3_' + i).hide();
                    $('#LabourCost_' + i).prop('required', false);
                    $("#QuantityPopUp_" + i).hide();
                }
            }
            $('#myModalquantity').hide();
            $('.modal-backdrop').fadeOut(100);
        }
    }
    else {
        bootbox.alert("Please select checkbox after that adjust quantity");
        return false;
    }
    //$('#myPleaseWait').modal('hide');

});


//---------------------------4th tab-----------------------------------------------

$("#UnscheduledWOReassign").click(function () {
    var primaryId = $('#primaryID').val();
    if (primaryId == 0 || primaryId == null || primaryId == undefined || primaryId == "" || primaryId == "0") {
        bootbox.alert(Messages.SAVE_FIRSTTAB_TABALERT);
        return false;
    }
    else if (AssessmentId == 0 || AssessmentId == null || AssessmentId == undefined || AssessmentId == "" || AssessmentId == "0") {
        bootbox.alert(Messages.SAVE_FIRSTTAB_TABALERT);
        return false;
    }
    else {
        GetTransfer()
    }
});

function GetTransfer() {
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgTransfer').css('visibility', 'hidden');
    pageindex = 1;
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/ScheduledWorkOrder/GetTransfer/" + primaryId + "/" + pagesize + "/" + pageindex)
            .done(function (result) {
                var htmlval = "";
                var getResult = JSON.parse(result);
                WOTransferId = getResult.WOTransferId;
                if (getResult.TransferAssetNo == null)
                    getResult.TransferAssetNo = GlobalAssetNo;
                if (getResult.TransferAssetDescription == null)
                    getResult.TransferAssetDescription = GlobalAssetDescription;
                $('#TransferAssetNo').val(getResult.TransferAssetNo);
                $('#TransferAssetDescription').val(getResult.TransferAssetDescription);
                $('#TransferOldAssignedPerson').val(GlobalAssignee);
                $('#TransferTypeCode').val(getResult.TransferTypeCode);
                $('#TransferService').val(getResult.TransferService);
                $('#TransferAssignedPerson').val(getResult.TransferAssignedPerson);
                $('#hdnTransferAssignedPersonId').val(getResult.TransferAssignedPersonId);
                if (getResult.TransferReason != null) {
                    $('#TransferReason').val(getResult.TransferReason);
                }
                $("#Timestamp").val(getResult.Timestamp);
                //  $('#divWOStatus').text(getResult.WorkOrderStatusValue);
                // $('#primaryID').val(getResult.WorkOrderId);

                TransferDetails = getResult.TransferDets;
                if (TransferDetails == null) {
                    //TransferDetailsPushEmptyMessage();
                    $("#TransferResultId").empty();
                    TransferDetailsNewRow();
                }
                else {
                    bindDatatoTransfeDatagrid(TransferDetails);
                }
                if (WorkOrderStatusString == "Closed") {
                    $('#btnTransferSave').hide();
                    $('#btnEditAttachment').hide();
                    $('#AttachRowPlus').hide();
                    //   $('#btnUnSWOPrint').show();
                    $('#btnCompletionSave').hide();
                }
                else {
                    $('#btnTransferSave').show();
                    $('#btnEditAttachment').show();
                    $('#AttachRowPlus').show();
                }
                if (WorkOrderStatusString == "Completed" && IsExternal) {
                    $('#btnTransferSave').show();
                    $('#btnCompletionSave').show();
                }
                $('#myPleaseWait').modal('hide');
            })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsgTransfer').css('visibility', 'visible');
            });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}

$("#btnTransferSave,#btnTransferEdit").click(function () {
    var AssignedPersonHiddenValue = $('#hdnTransferAssignedPersonId').val();
    var AssignedPersonValue = $('#TransferAssignedPerson').val();


    if (AssignedPersonValue != "" && AssignedPersonHiddenValue == "") {
        bootbox.alert("Valid New Assignee required!");
        return false;
    }
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgTransfer').css('visibility', 'hidden');

    var isFormValid = formInputValidation("tab-4", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsgTransfer').css('visibility', 'visible');

        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }

    var primaryId = $("#primaryID").val();
    var Timestamp = $('#Timestamp').val();

    var obj = {
        WorkOrderId: primaryId,
        TransferAssignedPersonId: $('#hdnTransferAssignedPersonId').val(),
        TransferReason: $('#TransferReason').val(),
        Timestamp: $("#Timestamp").val(),
        WOTransferId: WOTransferId,
        Timestamp: Timestamp,
        WorkOrderCategory: 188,
        WorkOrderNo: $('#txtWorkOrderNo').val()
    };


    var jqxhr = $.post("/api/ScheduledWorkOrder/AddTransfer", obj, function (response) {
        var getResult = JSON.parse(response);
        WOTransferId = getResult.WOTransferId;
        $('#TransferAssetNo').val(getResult.TransferAssetNo);
        $('#divWOStatus').text(getResult.WorkOrderStatusValue);
        $('#TransferAssetDescription').val(getResult.TransferAssetDescription);
        $('#TransferOldAssignedPerson').val(GlobalAssignee);
        $('#TransferTypeCode').val(getResult.TransferTypeCode);
        $('#TransferService').val(getResult.TransferService);
        $('#TransferAssignedPerson').val(getResult.TransferAssignedPerson);
        $('#hdnTransferAssignedPersonId').val(getResult.TransferAssignedPersonId);
        if (getResult.TransferReason != null) {
            $('#TransferReason').val(getResult.TransferReason);
        }
        $("#Timestamp").val(getResult.Timestamp);
        $('#primaryID').val(getResult.WorkOrderId);

        TransferDetails = getResult.TransferDets;
        if (TransferDetails == null) {
            $("#TransferResultId").empty();
            TransferDetailsNewRow();
        }
        else {
            bindDatatoTransfeDatagrid(TransferDetails);
        }
        $(".content").scrollTop(0);
        showMessage('Scheduled Work Order Transfer', CURD_MESSAGE_STATUS.SS);
        $("#top-notifications").modal('show');
        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);

        $('#btnSave').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
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
            $('#errorMsgTransfer').css('visibility', 'visible');

            $('#btnTransferSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
});

function TransferDetailsNewRow() {

    var inputpar = {
        inlineHTML: TransferGridHtml(),//Inline Html
        TargetId: "#TransferResultId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    $('#TransferResultId tr:last td:first input').focus();
}

function TransferDetailsPushEmptyMessage() {
    $("#TransferResultId").empty();
    var emptyrow = '<tr><td colspan=5 ><h3&nbsp;&nbsp;&nbsp;&nbsp;No records to display</h3></td></tr>'
    $("#TransferResultId ").append(emptyrow);
}

function TransferGridHtml() {

    return '<tr class="ng-scope" style=""> <td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled id="TransferWorkOrderNo_maxindexval" value="" class="form-control fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled id="TransferWorkOrderDate_maxindexval" value="" class="form-control fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled id="TransferWorkOrderCategory_maxindexval" value="" class="form-control fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled data-value=" " id="TransferGridAssignedPerson_maxindexval" value=" " class="form-control"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled data-value=" " id="TransferAssignedDate_maxindexval" value=" " class="form-control"> </div></td></tr>';

}

function bindDatatoTransfeDatagrid(list) {
    if (list.length > 0) {
        $('#TransferResultId').empty()
        var html = '';

        $(list).each(function (index, data) {

            html = '<tr class="ng-scope" style=""> <td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled id="TransferWorkOrderNo_' + index + '" value="' + data.TransferWorkOrderNo + '" class="form-control fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled id="TransferWorkOrderDate_' + index + '" value="' + DateFormatter(data.TransferWorkOrderDate) + '" class="form-control fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled id="TransferWorkOrderCategory_' + index + '" value="' + data.TransferWorkOrderCategory + '" class="form-control fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled data-value=" " id="TransferGridAssignedPerson_' + index + '" value="' + data.TransferGridAssignedPerson + '" class="form-control"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled data-value=" " id="TransferAssignedDate_' + index + '" value="' + DateFormatter(data.TransferAssignedDate) + '" class="form-control"> </div></td></tr>';


            $('#TransferResultId').append(html);
            GridtotalRecords = data.TotalRecords;
            TotalPages = data.TotalPages;
            LastRecord = data.LastRecord;
            FirstRecord = data.FirstRecord;
            pageindex = data.PageIndex;
        });
        var mapIdproperty = ["TransferWorkOrderNo-TransferWorkOrderNo_", "TransferWorkOrderDate-TransferWorkOrderDate_", "TransferWorkOrderCategory-TransferWorkOrderCategory_", "TransferGridAssignedPerson-TransferGridAssignedPerson_", "TransferAssignedDate-TransferAssignedDate_"];
        var htmltext = TransferGridHtml();

        id = $('#primaryID').val();
        var obj = { formId: "#tab-4", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "TransferDets", tableid: '#TransferResultId', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/ScheduledWorkOrder/GetTransfer/" + id, pageindex: pageindex, pagesize: pagesize };

        CreateFooterPagination(obj);
    }

    formInputValidation("form");

}

//fetch - Assigned Person 
var AssignedPersonFetchObj = {
    SearchColumn: 'TransferAssignedPerson-StaffName',//Id of Fetch field
    ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-StaffName'],
    FieldsToBeFilled: ["hdnTransferAssignedPersonId-StaffMasterId", "TransferAssignedPerson-StaffName"]
};

$('#TransferAssignedPerson').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divAssignedPersonFetch', AssignedPersonFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch8", event, 1);//1 -- pageIndex
});


//---------------------------5th tab-----------------------------------------------

$("#UnWOAssessmentTab").click(function () {
    var primaryId = $('#primaryID').val();
    if (primaryId == 0 || primaryId == null || primaryId == undefined || primaryId == "" || primaryId == "0") {
        bootbox.alert(Messages.SAVE_FIRST_TABALERT);
        return false;
    }
    else {
        GetAssessment()
    }
});



function GetAssessment() {
    //$('#btnAssessmentSave').show();
    //$('#btnSaveandAddNew').show();
    $('#btnAssessmentEdit').show();
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgAssessment').css('visibility', 'hidden');
    $('#btnApprove').show();
    $('#btnReject').show();


    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/ScheduledWorkOrder/GetAssessment/" + primaryId)
            .done(function (result) {
                var htmlval = "";
                var getResult = JSON.parse(result);
                AssessmentId = getResult.AssessmentId;
                // $("#primaryID").val(getResult.WorkOrderId);
                if (getResult.RealTimeStatus == null)
                    getResult.RealTimeStatus = 55;
                $('#AssessmentFeedback').val(getResult.AssessmentFeedBack);
                $('#AssessmentResponseDuration').val(getResult.AssessmentResponseDuration);

                if (getResult.AssessmentResponsedate == "0001-01-01T00:00:00") {
                    //var d = new Date();
                    //$('#AssessmentResponseDate').val(moment(d).format("DD-MMM-YYYY HH:mm"));
                    //RenewAction();
                    getResult.AssessmentResponsedate = null;
                }

                if (getResult.AssessmentResponsedate != null) {
                    if (getResult.AssessmentResponsedate == 'Invalid date') {
                        $('#txt_AssessmentResponseDate').text('');
                    }
                    $('#txt_AssessmentResponseDate').text(moment(getResult.AssessmentResponsedate).format("DD-MMM-YYYY HH:mm"));
                    // $('#AssessmentResponseDate').val(DateFormatter(getResult.AssessmentResponsedate));
                    $('#AssessmentResponseDate').val(moment(getResult.AssessmentResponsedate).format("DD-MMM-YYYY HH:mm"));
                }

                if (getResult.AssessmentResponsedate == null) {
                    $('#txt_AssessmentResponseDate').text('');

                    $('#AssessmentResponseDate').val('');
                }
                if (getResult.AssessmentTargetDate == "0001-01-01T00:00:00")
                    getResult.AssessmentTargetDate = null;
                if (getResult.AssessmentTargetDate != null) {
                    $('#AssessmentTargetDate').val(moment(getResult.AssessmentTargetDate).format("DD-MMM-YYYY HH:mm"));
                }
                if (getResult.IsAssignedToVendor == 0)
                    getResult.IsAssignedToVendor = 100;
                $('#RealTimeStatus').val(getResult.RealTimeStatus);
                $('#AssessmentStaffName').val(getResult.WorkOrderAssignee);
                $("#Timestamp").val(getResult.Timestamp);
                if (getResult.IsAssignedToVendor == null)
                    getResult.IsAssignedToVendor = 99;
                $('#ChangeToVendor').val((getResult.IsAssignedToVendor));
                var CCID = $('#ChangeToVendor').val();
                if (CCID == 99) {
                    $('#VendorHide').show();
                    $('#txtVendor').prop('required', true);
                    $('#txtVendor').prop('disabled', false);
                }
                else if (CCID == 100) {
                    $('#VendorHide').hide();
                    $('#txtVendor').prop('required', false);
                    $('#txtVendor').prop('disabled', true);
                    $("#txtVendor").parent().removeClass('has-error');
                }
                $('#hdnVendorId').val((getResult.AssignedVendor));
                $('#txtVendor').val((getResult.AssignedVendorName));

                if (WorkOrderStatusString == "Closed" || WorkOrderStatusString == " Closed") {
                    $('#btnAssessmentSave').hide();
                    // $('#btnUnSWOPrint').show();
                }
                else {
                    $('#btnAssessmentSave').show();
                }
                if ((WorkOrderStatusString == "Completed") || (WorkOrderStatusString == "Closed") || (WorkOrderStatusString == " Completed") || (WorkOrderStatusString == " Closed")) {
                    $("#AssessmentResponseDate").prop("disabled", true);
                }
                if ((WorkOrderStatusString == "Completed" && IsExternal) || (WorkOrderStatusString == " Completed" && IsExternal)) {
                    $('#btnAssessmentSave').hide();
                    $('#btnCompletionSave').show();
                }

                if (getResult.VendorProStatus == "Approve" || getResult.VendorProStatus == "Reject" || getResult.VendorProStatus == null || getResult.VendorProStatus == " Approve" || getResult.VendorProStatus == " Reject") {
                    $('#btnApprove').hide();
                    $('#btnReject').hide();
                }

                if (getResult.AssignedVendor > 0 && (getResult.VendorProStatus == "" || getResult.VendorProStatus == null)) {
                    $('#btnApprove').show();
                    $('#btnReject').show();
                }

                if (getResult.VendorProStatus == "Approve") {
                    $("#ChangeToVendor").prop('disabled', true);
                    $("#txtVendor").prop('disabled', true);
                    $("#RealTimeStatus").prop('disabled', true);
                }
                if (getResult.VendorProStatus == "Reject" || getResult.VendorProStatus == null) {
                    $("#ChangeToVendor").prop('disabled', false);
                    $("#txtVendor").prop('disabled', false);
                }
                $('#txt_AssessmentDetails').text(getResult.AssessmentFeedBack);
                $('#myPleaseWait').modal('hide');
            })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsgAssessment').css('visibility', 'visible');
            });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}

$("#btnAssessmentSave,#btnAssessmentEdit").click(function () {
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgAssessment').css('visibility', 'hidden');

    var isFormValid = formInputValidation("tab-5", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsgAssessment').css('visibility', 'visible');

        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }

    var obj = {
        AssessmentId: AssessmentId,
        WorkOrderId: $("#primaryID").val(),
        AssessmentFeedback: $('#AssessmentFeedback').val(),
        AssessmentResponseDate: $('#AssessmentResponseDate').val(),
        AssessmentTargetDate: null,
        AssessmentResponseDuration: $('#AssessmentResponseDuration').val(),
        AssessmentResponseDurationTime: $('#AssessmentResponseDuration').val(),
        RealTimeStatus: $('#RealTimeStatus').val(),
        Timestamp: $('#Timestamp').val(),
        IsAssignedToVendor: $('#ChangeToVendor').val(),
        AssignedVendor: $('#hdnVendorId').val(),
        WorkOrderCategory: 188,
        WorkOrderNo: $('#txtWorkOrderNo').val(),
        EngineerId: $('#hdnEngineerId').val()
    };



    var CompareWrkOrdDat = Date.parse($('#txtWorkOrderDate').val());
    var CompareSrtDat = Date.parse($('#AssessmentResponseDate').val());
    var CurrDate = new Date();

    if (CompareSrtDat < CompareWrkOrdDat) {
        $("div.errormsgcenter").text("Response Date / Time should be greater than or equal to Work Order Date / Time");
        $('#errorMsgAssessment').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        return false;
    }

    if (CompareSrtDat > CurrDate) {
        $("div.errormsgcenter").text("Response Date / Time should be lesser than or equal to current Date / Time");
        $('#errorMsgAssessment').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        return false;
    }

    var jqxhr = $.post("/api/ScheduledWorkOrder/AddAssessment", obj, function (response) {
        var getResult = JSON.parse(response);
        AssessmentId = getResult.AssessmentId;
        $("#primaryID").val(getResult.WorkOrderId);
        $('#AssessmentFeedback').val(getResult.AssessmentFeedBack);
        $('#AssessmentTargetDate').val(moment(getResult.AssessmentTargetDate).format("DD-MMM-YYYY HH:mm"));
        $('#AssessmentResponseDate').val(moment(getResult.AssessmentResponsedate).format("DD-MMM-YYYY HH:mm"));
        $('#RealTimeStatus').val(getResult.RealTimeStatus);
        $('#AssessmentResponseDuration').val(getResult.AssessmentResponseDuration);
        $('#AssessmentStaffName').val(GlobalAssignee);
        if (getResult.IsAssignedToVendor == null)
            getResult.IsAssignedToVendor = 100;
        $('#ChangeToVendor').val((getResult.IsAssignedToVendor));
        $('#hdnVendorId').val((getResult.AssignedVendor));
        $('#txtVendor').val((getResult.AssignedVendorName));

        if (getResult.AssignedVendor > 0) {
            $('#btnApprove').show();
            $('#btnReject').show();
        }

        if (getResult.VendorProStatus == "Approve" || getResult.VendorProStatus == "Reject") {
            $('#btnApprove').hide();
            $('#btnReject').hide();
        }


        $('#selWorkGroupfems').prop('disabled', true);
        $('#WorkOrderCategory').prop('disabled', true);
        $('#txtEngineer').prop('disabled', true);
        $('#WorkOrderPriority').prop('disabled', true);
        $("#Timestamp").val(getResult.Timestamp);
        $('#divWOStatus').text(getResult.WorkOrderStatusValue);
        $(".content").scrollTop(0);
        showMessage('Scheduled Work Order', CURD_MESSAGE_STATUS.SS);
        $("#top-notifications").modal('show');
        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);

        $('#btnAssessmentSave').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
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
            $('#errorMsgAssessment').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
});


$("#btnApprove").click(function () {
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgAssessment').css('visibility', 'hidden');

    var isFormValid = formInputValidation("tab-5", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsgAssessment').css('visibility', 'visible');

        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }

    var WorkOrderId = $("#primaryID").val();
    var WorkOrderNo = $('#txtWorkOrderNo').val();
    var AssignedToVendor = $('#ChangeToVendor').val();
    var vendorId = $('#hdnVendorId').val();
    var vendorEmail = $('#hdnVendorEmail').val();
    var flag = "Approve";

    var obj = {
        AssessmentId: AssessmentId,
        WorkOrderId: WorkOrderId,
        IsAssignedToVendor: AssignedToVendor,
        AssignedVendor: vendorId,
        AssignedVendorEmail: vendorEmail,
        EngineerId: $('#hdnEngineerId').val(),
        VendorProFlag: flag
    };


    var jqxhr = $.post("/api/ScheduledWorkOrder/VendorAssessProcess", obj, function (response) {
        var getResult = JSON.parse(response);
        $('#divWOStatus').text(getResult.WorkOrderStatusValue);
        if (getResult.VendorProStatus == "Approve") {
            $('#btnApprove').hide();
            $('#btnReject').hide();
            $("#ChangeToVendor").prop('disabled', true);
            $("#txtVendor").prop('disabled', true);
            $("#RealTimeStatus").prop('disabled', true);
        }

        AssessmentId = getResult.AssessmentId;

        $(".content").scrollTop(0);
        showMessage('Scheduled Work Order', CURD_MESSAGE_STATUS.SS);
        $("#top-notifications").modal('show');
        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);

        $('#btnAssessmentSave').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
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
            $('#errorMsgAssessment').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
});

$("#btnReject").click(function () {
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgAssessment').css('visibility', 'hidden');

    var isFormValid = formInputValidation("tab-5", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsgAssessment').css('visibility', 'visible');

        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }

    var WorkOrderId = $("#primaryID").val();
    var WorkOrderNo = $('#txtWorkOrderNo').val();
    var AssignedToVendor = $('#ChangeToVendor').val();
    var vendorId = $('#hdnVendorId').val();
    var vendorEmail = $('#hdnVendorEmail').val();
    var flag = "Reject";

    var obj = {
        AssessmentId: AssessmentId,
        WorkOrderId: WorkOrderId,
        IsAssignedToVendor: AssignedToVendor,
        AssignedVendor: vendorId,
        AssignedVendorEmail: vendorEmail,
        EngineerId: $('#hdnEngineerId').val(),
        VendorProFlag: flag
    };


    var jqxhr = $.post("/api/ScheduledWorkOrder/VendorAssessProcess", obj, function (response) {
        var getResult = JSON.parse(response);

        if (getResult.VendorProStatus == "Reject") {
            $('#btnApprove').hide();
            $('#btnReject').hide();
        }
        if (getResult.VendorProStatus == "Reject" || getResult.VendorProStatus == null) {
            $("#ChangeToVendor").prop('disabled', false);
            $("#txtVendor").prop('disabled', false);
        }
        AssessmentId = getResult.AssessmentId;
        $('#txtVendor').val(getResult.AssignedVendorName);
        $("#Timestamp").val(getResult.Timestamp);

        $(".content").scrollTop(0);
        showMessage('Scheduled Work Order', CURD_MESSAGE_STATUS.SS);
        $("#top-notifications").modal('show');
        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);

        $('#btnAssessmentSave').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
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
            $('#errorMsgAssessment').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
});


function LinkClicked(id, rowData) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    EmptyFields();
    $("#formScheduledWorkOrder :input:not(:button)").parent().removeClass('has-error');
    $("#tab-2 :input:not(:button)").parent().removeClass('has-error');
    $("#tab-3 :input:not(:button)").parent().removeClass('has-error');
    $("#tab-4 :input:not(:button)").parent().removeClass('has-error');
    $("#tab-5 :input:not(:button)").parent().removeClass('has-error');
    $("#tab-7 :input:not(:button)").parent().removeClass('has-error');
    $("#CommonAttachment :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(id);
    var iframe = document.getElementById('myIframe');
    //iframe.src = 'https://deductionuat.uemedgenta.com/PPM/PPMReport_Viewer.aspx?WorkOrderNo=' + id;
    
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");
    var hasApprovePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");

    if (hasEditPermission) {
        action = "Edit"

    }
    else if (!hasEditPermission) {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#btnDelete').show();
        $('#btnSaveandAddNew').show();
        $('#btnEdit').show();
        $('#btnCancel').show();
    }

    if (action == 'View') {
        $("#formUnScheduledWorkOrder :input:not(:button)").prop("disabled", true);
    }
    else if (action != 'View' && (rowData.WorkOrderStatus == "Cancelled" || rowData.WorkOrderStatus == "Closed")) {
        $('#btnEdit').hide();
        $('#btnAssessmentSave').hide();
        $('#btnCompletionSave').hide();
        $('#btnPartSave').hide();
        $('#btnTransferSave').hide();
        $('#btnEditAttachment').hide();
        $('#AttachRowPlus').hide();
        $('#btnPPMCheckListSave').hide();
        $('#btnSave').hide();
        $('#btnDelete').hide();
        $('#btnSaveandAddNew').hide();
        $('#btnCancel').show();
        // $('#btnUnSWOPrint').show();
    }
    else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        $('#btnAssessmentSave').show();

        $('#btnCompletionSave').hide();
        $('#btnPartSave').show();
        $('#btnTransferSave').show();
        $('#btnEditAttachment').show();
        $('#AttachRowPlus').show();
        $('#btnPPMCheckListSave').show();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/ScheduledWorkOrder/Get/" + primaryId)
            .done(function (result) {
                var htmlval = "";
                var getResult = JSON.parse(result);
                // alert(getResult.WorkOrderPriority);              
                $('#WorkOrderPriority').val(getResult.WorkOrderPriority);
                $('#hdnAttachId').val(getResult.HiddenId);
                TypeOfWorkOrder = getResult.TypeOfWorkOrder;
                WorkOrderStatus = getResult.WorkOrderStatus;

                //if ($('#ServiceId').val() == 1) {
                //    iframe.src = 'https://deductionuat.uemedgenta.com/PPM/FEMSUnscheduledWOReport_Viewer.aspx?WorkOrderId=' + id;
                //} else {
                //    iframe.src = 'https://deductionuat.uemedgenta.com/PPM/UnscheduledWOReport_Viewer.aspx?WorkOrderId=' + id;
                //}

                //if ($('#ServiceId').val() == 1) {
                //    iframe.src = '/Report/FemsPrint.aspx?Reportname=' + "RPT_UNSCH_WO_FEMS" + '&WorkOrderId=' + id;
                //} else {
                //    iframe.src = '/Report/BemsPrint.aspx?Reportname=' + "RPT_UNSCH_WO_BEMS" + '&WorkOrderId=' + id;
                //}
                PrintRDL();
                if (WorkOrderStatus == 192) {

                    $('#txtEngineer').prop('disabled', false);

                } else {



                }
                AssessmentId = getResult.AssessmentId;
                ///sai
                GetAssessment();
                GetCompletionInfo();
                $('#txt_AssessmentDetails').text(getResult.AssessmentFeedBack);
                $('#txt_UserLocationNames').text(getResult.UserLocationName);
                $('#txt_Assest').text(getResult.AssetName);
                $('#txt_AssestNames').text(getResult.AssetName);
                $('#txt_assestname').text(getResult.AssetName);
                $('#txt_EngineerId').text(getResult.EngineerId);
                $('#txt_Dates').text(moment(getResult.PartWorkOrderDate).format("DD-MMM-YYYY HH:mm"));
                $('#txt_WorkOrderDate').text(moment(getResult.PartWorkOrderDate).format("DD-MMM-YYYY HH:mm"));
                $('#txt_workorderno').text(getResult.WorkOrderNo);
                $('#workorderno').text(getResult.WorkOrderNo);
                $('#workReferenceno').text(getResult.WorkOrderNo);
                $('#txt_Manufacturers').text(getResult.Engineer);
                $('#txt_WorkOrderCategory').text(getResult.MaintenanceType);
                $('#txt_priority').text(getResult.WorkOrderPriorityValue);
                $('#txt_WorkOrderCategory').text(WorkOrderCategory);
                $('#txt_workgroup').text(getResult.WorkGroup);
                $('#Requestor').text(getResult.Requestor);
                $('#txt_Requestor').text(getResult.Requestor);
                $('#txt_UserLocation').text(getResult.UserLocation);
                $('#txt_UserArea').text(getResult.UserAreaName);
                $('#UserArea').text(getResult.UserArea);
                $('#txt_AssetNos').text(getResult.AssetNo);
                $('#txt_CompletedByDesignations').text(getResult.RequesterDesignation);
                $('#txt_StaffDesignation').text(getResult.AssigneeDesignation);
                $('#AssetNos').text(getResult.AssetNo);
                $('#txtUserLocationName').text(getResult.UserLocationName);
                $('#UserLocationName').text(getResult.UserLocationName);
                $('#txt_MaintainanceDetails').text(getResult.MaintenanceDetails);
                $('#txt_ContactNo').text(getResult.MobileNumber);
                // $('#txt_AssessmentResponseDate').text(getResult.AssessmentResponsedate);
                $('#txt_AssestClassification').text(getResult.AssetClassificationDescription);
                $('#txt_RepairDetails').text(getResult.RepairDetails);
                $('#txt_WorkOrderCategory').text(getResult.MaintenanceTypeVaule);
                if (getResult.WorkOrderPriority = 228) {
                    $('#WorkOrderCategory').val(275);
                    
                }
                WorkOrderStatusString = getResult.WorkOrderStatusValue;
                WorkOrderStatusString = WorkOrderStatusString.trim();
                if (hasApprovePermission == true && WorkOrderStatusString == "Request for Cancellation") {
                    $('#btnCancelApprove').show();
                    $('#btnCancelReject').show();
                    $('#btnDelete').hide();
                    $('#CancelRequestRemarks').css('visibility', 'visible');
                    $('#txtcancelreason').val(getResult.PPMCheckListRemarks);
                    $('#txtcancelreason').prop('disabled', true);
                }
                else if (WorkOrderStatusString == "Open" || WorkOrderStatusString == "Work In Progress")
                {
                    var rejectremarks = getResult.PPMCheckListRemarks;
                    if (getResult.PPMCheckListRemarks != '' || getResult.PPMCheckListRemarks != null)
                    {
                        $('#txtcancelreason').val(getResult.PPMCheckListRemarks);
                        $('#txtcancelreason').prop('disabled', true);
                        $('#CancelRequestRemarks').css('visibility', 'visible');
                    }
                }
                else {
                    $('#btnCancelApprove').hide();
                    $('#btnCancelReject').hide();
                    $('#CancelRequestRemarks').css('visibility', 'hidden');
                }



                //if (getResult.MaintenanceType = 273) {
                //    WorkOrderCategory1 = "Breakdown"
                //    $('#txt_WorkOrderCategory').text(WorkOrderCategory1);
                //}
                //else if (getResult.MaintenanceType = 270) {
                //    WorkOrderCategory2 = "Corrective"
                //    $('#txt_WorkOrderCategory').text(WorkOrderCategory2);
                //}
                //else if (getResult.MaintenanceType = 272) {
                //    WorkOrderCategory3 = "Insurance"
                //    $('#txt_WorkOrderCategory').text(WorkOrderCategory3);
                //}
                //else if (getResult.MaintenanceType = 274) {
                //    WorkOrderCategory4 = "Others"
                //    $('#txt_WorkOrderCategory').text(WorkOrderCategory4);
                //}
                //else if (getResult.MaintenanceType = 271) {
                //    WorkOrderCategory5 = "RW work"
                //    $('#txt_WorkOrderCategory').text(WorkOrderCategory5);
                //}
                //if (getResult.WorkOrderPriority = 228) {
                //    WorkOrderPriority1 = "Critical"
                //    $('#txt_priority').text(WorkOrderPriority1);
                //}
                //else if (getResult.WorkOrderPriority = 227) {
                //    WorkOrderPriority2 = " Normal"
                //    $('#txt_priority').text(WorkOrderPriority2);
                //}

                ////end sai
                $('#btnUnSWOPrint').hide();
                if (action != 'View' && (getResult.WorkOrderStatus == 143 || getResult.WorkOrderStatusValue == 142)) {
                    $('#btnEdit').hide();
                    $('#btnSave').hide();
                    $('#btnDelete').hide();
                    $('#btnSaveandAddNew').hide();
                    $('#btnCancel').show();
                    //   $('#btnUnSWOPrint').show();
                    $('#btnCompletionSave').hide();
                }
                else {
                    //$('#btnEdit').show();
                    //$('#btnSave').hide();
                    $('#btnEdit').hide();
                    $('#btnSave').show();
                }
                if (action != 'View' && (getResult.WorkOrderStatusValue == "Completed")) {
                    $('#btnDelete').hide();
                    $('#btnCompletionSave').show();
                }
                else if (action != 'View' && (getResult.WorkOrderStatusValue == "Closed")) {
                    $('#btnDelete').hide();
                    $('#btnCompletionSave').hide();
                    $('#btnSave').hide();
                    $('#btnSaveandAddNew').hide();

                }
                else {
                    $('#btnDelete').show();
                }
                GlobalWorkOrderNo = getResult.WorkOrderNo;
                GlobalWorkOrderDate = getResult.PartWorkOrderDate;
                WorkOrderStatusString = getResult.WorkOrderStatusValue;
                GlobalRunningHoursCapture = getResult.RunningHoursCapture;
                $('.divWOStatus').text(getResult.WorkOrderStatusValue);
                $('#divAssetStatus').text(getResult.AssetWorkingStatusValue);
                if (getResult.AssetWorkingStatusValue == "") {
                    $('#divAssetStatus1').hide();
                }
                else {
                    $('#divAssetStatus1').show();
                }

                $('#hdnAssetId').val(getResult.AssetRegisterId);
                GlobalAssetNo = getResult.AssetNo;
                GlobalAssetDescription = getResult.AssetDescription;
                GlobalAssignee = getResult.WorkOrderAssignee;
                $('#AssestClassification').val(getResult.AssetClassificationDescription);
                $('#UnscheduledAssignee').val(getResult.WorkOrderAssignee);
                $('#txtAssetNo').val(getResult.AssetNo);
                $('#txtAsset_Name').val(getResult.AssetName);
                $('#txtUserArea').val(getResult.UserArea);
                $('#txtUserLocation').val(getResult.UserLocation);
                $('#txtModel').val(getResult.Model);
                $('#txtContractType').val(getResult.ContractTypeValue);
                $('#txtManufacturer').val(getResult.Manufacturer);
                $('#hdnRequestorId').val(getResult.RequestorId);
                $('#txtRequestor').val(getResult.Requestor);
                $('#hdnEngineerId').val(getResult.EngineerId);
                $('#txtEngineer').val(getResult.Engineer);
                WorkOrderNo = getResult.WorkOrderNo;
                $('#txtWorkOrderNo').val(getResult.WorkOrderNo);
                $('#txtWorkOrderDate').val(moment(getResult.PartWorkOrderDate).format("DD-MMM-YYYY HH:mm"));
                $('#WorkOrderCategory').val(getResult.TypeOfWorkOrder);
                $('#selWorkGroupfems').val(getResult.WorkGroupVaule);
                $('#txtMaintainanceDetails').val(getResult.MaintenanceDetails);
                $('#primaryID').val(getResult.WorkOrderId);
                GlobalWorkOrderId = getResult.WorkOrderId;
                $("#Timestamp").val(getResult.Timestamp);
                //----Added by Pranay-----//
                $("#txt_assetno").text(getResult.AssetNo);
                $("#txt_assetname").text(getResult.AssetName);
                $("#txt_workorderno").text(getResult.WorkOrderNo);
                $("#txt_servicereqdesc").text(getResult.MaintenanceDetails);
                //-----END--------//
                $('#txtAssetNo').prop('disabled', true);
                $('#myPleaseWait').modal('hide');
                if (WorkOrderStatusString == "Closed") {
                    $("#formUnScheduledWorkOrder :input:not(:button)").prop("disabled", true);
                    $("#tab-2 :input:not(:button)").prop("disabled", true);
                    $("#tab-3 :input:not(:button)").prop("disabled", true);
                    $("#tab-4 :input:not(:button)").prop("disabled", true);
                    $("#tab-5 :input:not(:button)").prop("disabled", true);
                    $("#tab-7 :input:not(:button)").prop("disabled", true);
                    $("#divCommonAttachment :input:not(:button)").prop("disabled", true);
                    $("#PPMCheckList :input:not(:button)").prop("disabled", true);
                    $("#aAFAdditionalInfo :input:not(:button)").prop("disabled", true);
                    $('#txtEngineer').prop('disabled', true);
                    $('#txtMaintainanceDetails').prop('disabled', true);
                    $('#btnEditAttachment').hide();
                    $('#AttachRowPlus').hide();
                    //  $('#btnUnSWOPrint').show();
                    $('#btnCompletionSave').hide();
                }

                if (WorkOrderStatusString == "Open" || WorkOrderStatusString == "Work In Progress" || WorkOrderStatusString == "Completed") {
                    $("#formUnScheduledWorkOrder :input:not(:button)").prop("disabled", false);
                    $("#tab-2 :input:not(:button)").prop("disabled", false);
                    $("#tab-3 :input:not(:button)").prop("disabled", false);
                    $("#tab-4 :input:not(:button)").prop("disabled", false);
                    $("#tab-5 :input:not(:button)").prop("disabled", false);
                    $("#tab-7 :input:not(:button)").prop("disabled", false);
                    $("#divCommonAttachment :input:not(:button)").prop("disabled", false);
                    $("#PPMCheckList :input:not(:button)").prop("disabled", false);
                    $("#aAFAdditionalInfo :input:not(:button)").prop("disabled", false);
                    $('#txtEngineer').prop('disabled', false);
                    $('#txtMaintainanceDetails').prop('disabled', false);
                    $('#txtWorkOrderNo').prop('disabled', true);
                    $('#txtWorkOrderDate').prop('disabled', true);
                    $('#txtAssetNo').prop('disabled', true);
                    $('#txtModel').prop('disabled', true);
                    $('#txtManufacturer').prop('disabled', true);
                    $('#txtContractType').prop('disabled', true);
                    $('#WorkOrderNo').prop('disabled', true);
                    $('#PartWorkOrderNo').prop('disabled', true);
                    $('#PartWorkOrderDate').prop('disabled', true);
                    $('#TotalSparePartCost').prop('disabled', true);
                    $('#TotalLabourCost').prop('disabled', true);
                    $('#TotalCost').prop('disabled', true);
                    $('#AssessmentStaffName').prop('disabled', true);
                    $('#txtVendor').prop('disabled', true);
                    $('#TransferOldAssignedPerson').prop('disabled', true);
                    $('#TransferAssetNo').prop('disabled', true);
                    $('#TransferAssetDescription').prop('disabled', true);
                    $('#HistoryWorkOrderNo').prop('disabled', true);
                    $('#HistoryWorkOrderDate').prop('disabled', true);
                    $('#HistoryAssetNo').prop('disabled', true);
                    $('#btnEditAttachment').show();
                    $('#AttachRowPlus').show();
                    // $('#btnUnSWOPrint').show();
                    $('#btnCompletionSave').show();
                }
                if (WorkOrderStatusString == "Open") {

                    $('#txtEngineer').prop('disabled', false);

                } else {
                }
                //*********************** Image Video Start ****************************
                // FYI
                if (getResult.Base64StringImage != "" && getResult.Base64StringImage != null) {
                    ListModel = getResult.Base64StringImage;
                    $('#showModalImg').show();
                    var strimg = 'data:image/jpeg;base64,' + getResult.Base64StringImage;

                    document.getElementById('imgvid1').setAttribute('src', strimg);
                }
                else {
                    $('#showModalImg').hide();
                }
                if (getResult.Base64StringVideo != "" && getResult.Base64StringVideo != null) {
                    ListModel = getResult.Base64StringVideo;
                    $('#showModalVid').show();
                    var strvid = 'data:video/mp4;base64,' + getResult.Base64StringVideo;

                    document.getElementById('imgvid2').setAttribute('src', strvid);
                    $("#divVideo video")[0].load();
                }
                else {
                    $('#showModalVid').hide();
                }
                if (getResult.Base64StringSignature != "" && getResult.Base64StringSignature != null) {
                    ListModel = getResult.Base64StringSignature;
                    $('#SignatureHide').show();
                    var strimg = 'data:image/jpeg;base64,' + getResult.Base64StringSignature;

                    document.getElementById('imgSignature1').setAttribute('src', strimg);
                }
                else {
                    $('#SignatureHide').hide();
                }

                //*********************** Image Video End ****************************

                if (getResult.AssessmentId != 0 || getResult.AssessmentId != "" || getResult.AssessmentId != "0") {
                    $('#WorkOrderPriority').prop('disabled', true);
                    $('#txtRequestor').prop('disabled', true);
                    $('#txtEngineer').prop('disabled', true);
                    $('#WorkOrderCategory').prop('disabled', true);
                    $('#txtMaintainanceDetails').prop('disabled', true);
                }
                if (WorkOrderStatusString == "Completed" && IsExternal) {

                    disableForExternalComplete();
                    $('#btnCompletionSave').show();
                }
                if (IsExternal) {
                    $('#btnEdit').hide();
                    $('#btnSaveandAddNew').hide();
                }
                if (WorkOrderStatus == 194) {

                    $('#btnSave').hide();
                    $('#btnDelete').hide();
                }
                else {
                }
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


$("#WorkOrderPriority").change(function () {
    var WorkOrderPriority = $("#WorkOrderPriority").val();
    if (WorkOrderPriority == 228) {
        $('#WorkOrderCategory').val(275);
    }

});

$("#btnDelete").click(function () {
    var ID = $('#primaryID').val();
    var remarks = $('#txtremarks').val();
    if (remarks == "") {
        $('#txtremarks').prop('disabled', false);
        $('#txtremarks').prop('required', true);
        $('#ApproveCancelRemarks').css('visibility', 'visible');
        $("div.errormsgcenter").text('Please Enter the Remarks...');
        $('#errorMsg').css('visibility', 'visible');
    }
    else{
        // confirmDelete(ID);
        approveReject(ID, remarks, 'Cancel');
    }

});

function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/ScheduledWorkOrder/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('ScheduledWorkOrder', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('ScheduledWorkOrder', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}

$("#btnCancelApprove").click(function () {
    var ID = $('#primaryID').val();
    approveReject(ID, 'Approve', 'Approve');

});
$("#btnCancelReject").click(function () {
    var ID = $('#primaryID').val();
    var remarks = $('#txtremarks').val();

    if (remarks == "")
    {
        $('#txtremarks').prop('disabled', false);
        $('#txtremarks').prop('required', true);
        $('#ApproveCancelRemarks').css('visibility', 'visible');
        $("div.errormsgcenter").text('Please Enter the Remarks...');
        $('#errorMsg').css('visibility', 'visible');
    }
    else
    {
        approveReject(ID, remarks,'Reject');
    }

});
function approveReject(ID,remarks,Type) {
    var message = 'Are you sure to proceed?';
    var pageId = $('.ui-pg-input').val();
    var msg = '';
    if (Type == 'Approve') {
        msg = CURD_MESSAGE_STATUS.CNS;
    }
    else if (Type == 'Cancel') {
        msg = CURD_MESSAGE_STATUS.RQS;
    }
    else {
        msg = CURD_MESSAGE_STATUS.RJS;
    }
    bootbox.confirm(message, function (result) { 
        if (result) {
            $.get("/api/ScheduledWorkOrder/ApproveReject/" + ID + "/" + remarks + "/" + Type)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    $('#errorMsg').css('visibility', 'hidden');
                    showMessage('ScheduledWorkOrder', msg);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('ScheduledWorkOrder', CURD_MESSAGE_STATUS.DF);
                    $('#errorMsg').css('visibility', 'hidden');
                    $('#myPleaseWait').modal('hide');
                });
            $('#txtremarks').prop('disabled', true);
            $('#txtremarks').prop('required', false);
            $('#txtremarks').val('');
            $('#ApproveCancelRemarks').css('visibility', 'hidden');
            $('#CancelRequestRemarks').css('visibility', 'hidden');
            
        }

    });
}


function PrintRDL()
{
    
    var iframe = document.getElementById('myIframe');
    var id = $('#primaryID').val();
    if (id != null)
        {
        //if ($('#ServiceId').val() == 1) {
        //    iframe.src = 'https://deductionuat.uemedgenta.com/PPM/FEMSUnscheduledWOReport_Viewer.aspx?WorkOrderId=' + id;
        //} else {
        //    iframe.src = 'https://deductionuat.uemedgenta.com/PPM/UnscheduledWOReport_Viewer.aspx?WorkOrderId=' + id;
        //}

        if ($('#ServiceId').val() == 1) {
            iframe.src = '/Report/FemsPrint.aspx?Reportname=' + "RPT_UNSCH_WO_FEMS" + '&WorkOrderId=' + id;
        } else {
            iframe.src = '/Report/BemsPrint.aspx?Reportname=' + "RPT_UNSCH_WO_BEMS" + '&WorkOrderId=' + id;
        }
    }
}


function EmptyFields() {
    $('#hdnEngineerId').val('');
    $('#txtEngineer').val('');
    $(".content").scrollTop(0);
    $('input[type="text"], textarea').val('');
    $('.ui-tabs-hide').empty();
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnSaveandAddNew').show();
    $('#btnDelete').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#grid").trigger('reloadGrid');
    $("#formScheduledWorkOrder :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#txtAssetNo').removeAttr("disabled");
    $('#errorMsg').css('visibility', 'hidden');
    $('#WorkOrderPriority').val(227);
    $('#WorkOrderCategory').val("null");
    $('#selWorkGroupfems').val("null");
    $('#txtRequestor').prop('disabled', false);
    $('#WorkOrderPriority').prop('disabled', false);
    $('#WorkOrderCategory').prop('disabled', false);
    $('#selWorkGroupfems').prop('disabled', false);
    $('#txtMaintainanceDetails').prop('disabled', false);
    $('#AssessmentFeedback').prop('disabled', false);
    $('#AssessmentResponseDate').prop('disabled', false);
    $('#RealTimeStatus').prop('disabled', false);
    $('#ChangeToVendor').prop('disabled', false);
    $('#txtHandoverDate').prop('disabled', false);
    $('#txtCompletedBy').prop('disabled', false);
    $('#txtVerifiedBy').prop('disabled', false);
    $('#CauseCodeDescription').prop('disabled', false);
    $('#QCDescription').prop('disabled', false);
    $('#RepairDetails').prop('disabled', false);
    $('#txtAgreedDate').prop('disabled', false);
    $('#VendorServiceCost').prop('disabled', false);
    $('#Status').prop('disabled', false);
    $('#Reason').prop('disabled', false);
    $('#txtRunningHours').prop('disabled', false);
    $('#TransferReason').prop('disabled', false);
    $('#TransferAssignedPerson').prop('disabled', false);
    $('#btnUnSWOPrint').hide();
    $("#txtStartDate").val('');
    $("#txtEndDate").val('');
    $("#txtCompletedBy").val('');
    $("#txtCompletedByDesignation").val('');
    $("#QCDescription").val('null');
    $("#txtQCCode").val('');

    $("#CauseCodeDescription").val('null');
    $("#txtCauseCode").val('');
    $("#RepairDetails").val('');
    $("#Status").val(0);
    $("#Reason").val(0);
    $("#txtRunningHours").val('');
    $("#txtHandoverDate").val('');
    $("#txtVerifiedBy").val('');
    $("#txtVerifiedByDesignation").val('');
    $("#VendorServiceCost").val('');
    $("#CompletionInfoResultId").empty();

    $('#txtVerifiedBy').prop('disabled', true);
    $('#txtHandoverDate').prop('disabled', true);
    $('#txtVerifiedBy').prop('required', false);
    $("#lblVerify").html("Verified By");
    $("#lblHanddt").html("Handover Date / Time ");
    $('#txtHandoverDate').prop('required', false);
    $('#txtEngineer').prop('disabled', false);
    $('#divWOStatus, #divAssetStatus').text('');
    // AddNewRowArea();
    $('#txtremarks').prop('disabled', true);
    $('#txtremarks').prop('required', false);
    $('#txtremarks').val('');
    $('#ApproveCancelRemarks').css('visibility', 'hidden'); 
    $('#CancelRequestRemarks').css('visibility', 'hidden');
    $('#btnCancelApprove').hide();
    $('#btnCancelReject').hide();
}

//************************************* 7th Tab *******************************

$("#UnWOHistory").click(function () {
    var primaryId = $('#primaryID').val();
    if (primaryId == 0 || primaryId == null || primaryId == undefined || primaryId == "" || primaryId == "0") {
        bootbox.alert(Messages.SAVE_FIRSTTAB_TABALERT);
        return false;
    }
        //else if (AssessmentId == 0 || AssessmentId == null || AssessmentId == undefined || AssessmentId == "" || AssessmentId == "0") {
        //    bootbox.alert(Messages.SAVE_FIRSTTAB_TABALERT);
        //    return false;
        //}
    else {
        GetHistory()
    }
});


function GetHistory() {
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgHistory').css('visibility', 'hidden');
    pageindex = 1;
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/ScheduledWorkOrder/GetHistory/" + primaryId + "/" + pagesize + "/" + pageindex)
            .done(function (result) {
                var htmlval = "";
                var getResult = JSON.parse(result);
                if (getResult.HistoryWorkOrderDate == "0001-01-01T00:00:00")
                    getResult.HistoryWorkOrderDate = null;
                if (getResult.HistoryTargetDate == "0001-01-01T00:00:00")
                    getResult.HistoryTargetDate = null;
                $('#HistoryWorkOrderNo').val(getResult.HistoryWorkOrderNo);
                $('#HistoryWorkOrderDate').val(DateFormatter(getResult.HistoryWorkOrderDate));
                $('#HistoryAssetNo').val(getResult.HistoryAssetNo);
                $('#HistoryTargetDate').val(DateFormatter(getResult.HistoryTargetDate));
                //$('#primaryID').val(getResult.WorkOrderId);

                HistoryDetails = getResult.HistoryDets;
                if (HistoryDetails == null) {
                    $('#HistoryWorkOrderNo').val(GlobalWorkOrderNo);
                    $('#HistoryWorkOrderDate').val(moment(GlobalWorkOrderDate).format("DD-MMM-YYYY HH:mm"));
                    //RescheduleDetailsPushEmptyMessage();
                    $("#HistoryResultId").empty();
                    HistoryDetailsNewRow();
                }
                else {
                    bindDatatoHistoryDatagrid(HistoryDetails);
                }

                $('#myPleaseWait').modal('hide');
            })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsgHistory').css('visibility', 'visible');
            });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}

function HistoryDetailsNewRow() {

    var inputpar = {
        inlineHTML: HistoryGridHtml(),//Inline Html
        TargetId: "#HistoryResultId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    $('#HistoryResultId tr:last td:first input').focus();
}

function HistoryDetailsPushEmptyMessage() {
    $("#HistoryResultId").empty();
    var emptyrow = '<tr><td colspan=3 ><h3&nbsp;&nbsp;&nbsp;&nbsp;No records to display</h3></td></tr>'
    $("#HistoryResultId ").append(emptyrow);
}

function HistoryGridHtml() {

    return '<tr class="ng-scope" style=""> <td width="25%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled id="HistoryAssignedPerson_maxindexval" value="" class="form-control fetchField"> </div></td><td width="25%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled id="HistoryAssignedPersonDesig_maxindexval" value="" class="form-control fetchField"> </div></td><td width="25%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled id="HistoryStatus_maxindexval" value="" class="form-control fetchField"> </div></td><td width="25%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled data-value=" " id="HistoryDate_maxindexval" value=" " class="form-control"> </div></td></tr>';
}

function bindDatatoHistoryDatagrid(list) {
    if (list.length > 0) {
        $('#HistoryResultId').empty()
        var html = '';

        $(list).each(function (index, data) {

            html = '<tr class="ng-scope" style=""> <td width="25%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled id="HistoryAssignedPerson_' + index + '" value="' + data.HistoryAssignedPerson + '" class="form-control fetchField"> </div></td><td width="25%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled id="HistoryAssignedPersonDesig' + index + '" value="' + data.HistoryAssignedPersonDesig + '" class="form-control fetchField"> </div></td><td width="25%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled id="HistoryStatus_maxindexval" value="' + data.HistoryStatus + '" class="form-control fetchField"> </div></td><td width="25%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled data-value=" " id="HistoryDate_maxindexval" value="' + moment(data.HistoryDate).format(" DD-MMM-YYYY HH:mm ") + '" class="form-control"> </div></td></tr>';

            $('#HistoryResultId').append(html);
            GridtotalRecords = data.TotalRecords;
            TotalPages = data.TotalPages;
            LastRecord = data.LastRecord;
            FirstRecord = data.FirstRecord;
            pageindex = data.PageIndex;
        });
        var mapIdproperty = ["HistoryAssignedPerson-HistoryAssignedPerson_", "HistoryStatus-HistoryStatus_", "HistoryDate-HistoryDate_"];
        var htmltext = HistoryGridHtml();

        id = $('#primaryID').val();
        var obj = { formId: "#tab-7", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "HistoryDets", tableid: '#HistoryResultId', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/ScheduledWorkOrder/GetHistory/" + id, pageindex: pageindex, pagesize: pagesize };

        CreateFooterPagination(obj);
    }

    formInputValidation("form");

}

function RenewAction() {
    
    $(".errormsgcenter").text("");
    $('#errorMsgAssessment').css('visibility', 'hidden');
    // var startdate = new Date(GlobalWorkOrderDate);
    var startdate = Date.parse($("#txtWorkOrderDate").val());
    var RespDatetime = Date.parse($("#AssessmentResponseDate").val());
    //var endDate = new Date(firedate);
    var currentdate = new Date();
    //if (endDate < startdate)
    //{
    //    $(".errormsgcenter").text("Response Date should be greater than or equal to Work Order Date!");
    //    $('#errorMsgAssessment').css('visibility', 'visible');
    //    $("#AssessmentResponseDuration").val(null);
    //    return false;
    //}

    //var diff = new Date(RespDatetime - startdate);

    //get minutes
    //var days = diff / 1000 / 60 / 60;

    var diff = RespDatetime - startdate;

    var diffSeconds = diff / 1000;
    var HH = Math.floor(diffSeconds / 3600);
    var MM = Math.floor(diffSeconds % 3600) / 60;

    var formatted = ((HH < 10) ? ("0" + HH) : HH) + " : " + ((MM < 10) ? ("0" + MM) : MM)

    if (RespDatetime >= startdate) {
        $("#AssessmentResponseDuration").val(formatted);
    }
    else {
        $("#AssessmentResponseDuration").val('');
        $("div.errormsgcenter").text("Response Date / Time should be greater than or equal to Work Order Date / Time");
        $('#errorMsgAssessment').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        return false;
    }

    //$("#AssessmentResponseDuration").val(formatted);
}

function ClearErrorMessage() {
    $("#formUnScheduledWorkOrder :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/ScheduledWorkOrder/Get/" + primaryId)
            .done(function (result) {
                var htmlval = "";
                var getResult = JSON.parse(result);
                $('#WorkOrderPriority').val(getResult.WorkOrderPriority);
                $('#hdnAttachId').val(getResult.HiddenId);
                TypeOfWorkOrder = getResult.TypeOfWorkOrder;
                WorkOrderStatus = getResult.WorkOrderStatus
                GlobalWorkOrderNo = getResult.WorkOrderNo;
                GlobalWorkOrderDate = getResult.PartWorkOrderDate;
                WorkOrderStatusString = getResult.WorkOrderStatusValue;
                GlobalRunningHoursCapture = getResult.RunningHoursCapture;
                AssessmentId = getResult.AssessmentId;
                ///sai

                $('#txt_RepairDetails').text(getResult.RepairDetails);
                $('#txt_UserLocationNames').text(getResult.UserLocationName);
                $('#txt_AssestNames').text(getResult.AssetName);
                $('#txt_assestname').text(getResult.AssetName);
                $('#txt_EngineerId').text(getResult.EngineerId);
                $('#txt_Dates').text(moment(getResult.PartWorkOrderDate).format("DD-MMM-YYYY HH:mm"));
                $('#txt_WorkOrderDate').text(moment(getResult.PartWorkOrderDate).format("DD-MMM-YYYY HH:mm"));
                $('#txt_workorderno').text(getResult.WorkOrderNo);
                $('#workorderno').text(getResult.WorkOrderNo);
                $('#workReferenceno').text(getResult.WorkOrderNo);
                $('#txt_Manufacturers').text(getResult.Engineer);
                $('#txt_WorkOrderCategory').text(getResult.MaintenanceType);
                
                $('#txt_priority').text(WorkOrderPriority);
                $('#txt_workgroup').text(getResult.WorkGroup);
                $('#Requestor').text(getResult.Requestor);
                $('#txt_Requestor').text(getResult.Requestor);
                $('#txt_UserLocation').text(getResult.UserLocation);
                $('#txt_UserArea').text(getResult.UserAreaName);
                $('#UserArea').text(getResult.UserArea);
                $('#txt_AssetNos').text(getResult.AssetNo);
                $('#AssetNos').text(getResult.AssetNo);
                $('#txtUserLocationName').text(getResult.UserLocationName);
                $('#UserLocationName').text(getResult.UserLocationName);
                $('#txt_MaintainanceDetails').text(getResult.MaintenanceDetails);
                $('#txt_Engineer').text(getResult.Engineer);
                $('#txt_MDetails').text(getResult.MaintenanceDetails);
                $('#txt_AssestClassification').text(getResult.AssetClassificationDescription);
                if (getResult.MaintenanceType = 273) {
                    WorkOrderCategory1 = "Breakdown"
                    $('#txt_WorkOrderCategory').text(WorkOrderCategory1);
                }
                else if (getResult.MaintenanceType = 270) {
                    WorkOrderCategory2 = "Corrective"
                    $('#txt_WorkOrderCategory').text(WorkOrderCategory2);
                }
                else if (getResult.MaintenanceType = 272) {
                    WorkOrderCategory3 = "Insurance"
                    $('#txt_WorkOrderCategory').text(WorkOrderCategory3);
                }
                else if (getResult.MaintenanceType = 274) {
                    WorkOrderCategory4 = "Others"
                    $('#txt_WorkOrderCategory').text(WorkOrderCategory4);
                }
                else if (getResult.MaintenanceType = 271) {
                    WorkOrderCategory5 = "RW work"
                    $('#txt_WorkOrderCategory').text(WorkOrderCategory5);
                }
                if (getResult.WorkOrderPriority = 228) {
                    WorkOrderPriority1 = "Critical"
                    $('#txt_priority').text(WorkOrderPriority1);
                }
                else if (getResult.WorkOrderPriority = 227) {
                    WorkOrderPriority2 = " Normal"
                    $('#txt_priority').text(WorkOrderPriority2);
                }
                ////end sai

                //$("label[for='WOStatus']").html(getResult.WorkOrderStatusValue);
                $('#AssestClassification').val(getResult.AssetClassificationDescription);
                $('#AssessmentFeedback').val(getResult.AssessmentFeedBack);
                $('.divWOStatus').text(getResult.WorkOrderStatusValue);
                $('#hdnAssetId').val(getResult.AssetRegisterId);
                $('#txtAssetNo').val(getResult.AssetNo);
                $('#txtModel').val(getResult.Model);
                $('#txtManufacturer').val(getResult.Manufacturer);
                $('#hdnRequestorId').val(getResult.RequestorId);
                $('#txtRequestor').val(getResult.Requestor);
                //WorkOrderNo = getResult.WorkOrderNo;
                $('#txt_WorkOrderNo').val(getResult.WorkOrderNo);
                $('#hdnEngineerId').val(getResult.EngineerId);
                $('#txtWorkOrderDate').val(moment(getResult.PartWorkOrderDate).format("DD-MMM-YYYY HH:mm"));
                $('#WorkOrderCategory').val(getResult.TypeOfWorkOrder);
                //$('#WorkOrderPriority').val(getResult.WorkOrderPriority);
                $('#WorkOrderPriorityValue').val(getResult.WorkOrderPriorityValue);
                // $('#txtWorkOrderStatus').val(getResult.WorkOrderStatusValue);
                $('#txtMaintainanceDetails').val(getResult.MaintenanceDetails);
                $('#primaryID').val(getResult.WorkOrderId);
                $("#Timestamp").val(getResult.Timestamp);
                $('#txtEngineer').val(getResult.Engineer);
                $('#hdnEngineerId').val(getResult.EngineerId);

                $("#txt_assetno").val(getResult.AssetNo);
                $("#txt_assetname").val(getResult.AssetName);
                $("#txt_workorderno").val(getResult.WorkOrderNo);
                $("#txt_servicereqdesc").val(getResult.MaintainanceDetails);

                $('#txtAssetNo').prop('disabled', true);
                $('#myPleaseWait').modal('hide');

                if (getResult.AssetWorkingStatusValue == "") {
                    $('#divAssetStatus1').hide();
                }
                else {
                    $('#divAssetStatus1').show();
                }

                if (WorkOrderStatusString == "Closed") {
                    $("#formUnScheduledWorkOrder :input:not(:button)").prop("disabled", true);
                    $("#tab-2 :input:not(:button)").prop("disabled", true);
                    $("#tab-3 :input:not(:button)").prop("disabled", true);
                    $("#tab-4 :input:not(:button)").prop("disabled", true);
                    $("#tab-5 :input:not(:button)").prop("disabled", true);
                    $("#tab-7 :input:not(:button)").prop("disabled", true);
                    $("#divCommonAttachment :input:not(:button)").prop("disabled", true);
                    $("#PPMCheckList :input:not(:button)").prop("disabled", true);
                    $("#aAFAdditionalInfo :input:not(:button)").prop("disabled", true);
                    $('#txtEngineer').prop('disabled', true);
                    $('#txtMaintainanceDetails').prop('disabled', true);
                    /// $('#btnUnSWOPrint').show();
                }
                //*********************** Image Video Start ****************************

                if (getResult.Base64StringImage != "" && getResult.Base64StringImage != null) {
                    ListModel = getResult.Base64StringImage;
                    $('#showModalImg').show();
                    var strimg = 'data:image/jpeg;base64,' + getResult.Base64StringImage;

                    document.getElementById('imgvid1').setAttribute('src', strimg);
                }
                else {
                    $('#showModalImg').hide();
                }
                if (getResult.Base64StringVideo != "" && getResult.Base64StringVideo != null) {
                    ListModel = getResult.Base64StringVideo;
                    $('#showModalVid').show();
                    var strvid = 'data:video/mp4;base64,' + getResult.Base64StringVideo;

                    document.getElementById('imgvid2').setAttribute('src', strvid);
                    $("#divVideo video")[0].load();
                }
                else {
                    $('#showModalVid').hide();
                }

                //*********************** Image Video End ****************************

                if (getResult.AssessmentId != 0 || getResult.AssessmentId != "" || getResult.AssessmentId != "0") {
                    $('#WorkOrderPriority').prop('disabled', true);
                    $('#txtRequestor').prop('disabled', true);
                    $('#txtEngineer').prop('disabled', true);
                    $('#WorkOrderCategory').prop('disabled', true);
                    $('#txtMaintainanceDetails').prop('disabled', true);
                }

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

function GetFeedbackPopupdetails() {
    var result = [];
    var jqxhr =
        $.get("/api/ScheduledWorkOrder/FeedbackPopUp/" + AssessmentId)
            .done(function (response) {
                var result = JSON.parse(response);
                FeedbackPopUpDetails = result.FeedbackPopUpDets;
                $("#CrmReqRemarksGrid").empty();
                $.each(FeedbackPopUpDetails, function (index, value) {
                    AddNewRowRemarksHistory();
                    $("#CRMReqRemHisSNo_" + index).val(index + 1);
                    $("#CRMReqRemHisRemarks_" + index).val(FeedbackPopUpDetails[index].Remarks);
                    $("#CRMReqRemHisRemarks_" + index).attr('title', FeedbackPopUpDetails[index].Remarks);
                    $("#CRMReqRemHisEntby_" + index).val(FeedbackPopUpDetails[index].DoneBy);
                    $("#CRMReqRemHisDate_" + index).val(moment(FeedbackPopUpDetails[index].Date).format("DD-MMM-YYYY"));
                    $("#CRMReqRemHisStatus_" + index).val(FeedbackPopUpDetails[index].DoneByDesignation);

                });
                //************************************************ Grid Pagination *******************************************

                //if (result.PartReplacementPopUpDets.length > 0) {
                //    GridtotalRecords = result.MonthlyStockRegisterModalData[0].TotalRecords;
                //    TotalPages = result.MonthlyStockRegisterModalData[0].TotalPages;
                //    LastRecord = result.MonthlyStockRegisterModalData[0].LastRecord;
                //    FirstRecord = result.MonthlyStockRegisterModalData[0].FirstRecord;
                //    pageindex = result.MonthlyStockRegisterModalData[0].PageIndex;
                //}

                //var mapIdproperty = ["PopUpPartNo-PopUpPartNo_", "PopUpPartDescription-PopUpPartDescription_", "PopUpQuantityAvailable-PopUpQuantityAvailable_", "PopUpCostPerUnit-PopUpCostPerUnit_", "PopUpInvoiceNo-PopUpInvoiceNo_", "PopUpVendorName-PopUpVendorName_", "PopUpQuantityTaken-PopUpQuantityTaken_", "PopUpSelected-PopUpSelected_"];

                //var htmltext = BindNewRowQuantityPopUp();
                //Inline Html

                //var objModal = {
                //    formId: "#form", IsView: ($('#ActionType').val() == ""), PageNumber: pageindex, flag: "", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "MonthlyStockRegisterModalData", tableid: '#MonthlyStockRegisterModalTbl', destionId: "#paginationfooterModal", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/MonthlyStockRegister/GetModal/" + _MStkRegisterWO
                //};

                //CreateFooterPagination(objModal)

                //************************************************ End *******************************************************

                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").css('dispaly', 'none');
                $('#errorMsgAssessment').hide();
            })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsgAssessment').css('visibility', 'visible');
            });
}

function AddNewRowRemarksHistory() {
    var inputpar = {
        inlineHTML: RemarksHistoryHtml(),
        IdPlaceholderused: "maxindexval",
        TargetId: "#CrmReqRemarksGrid",
        TargetElement: ["tr"]
    }

    AddNewRowToDataGrid(inputpar);

    var rowCount = $('#CRMRequestGrid tr:last').index();
    //$('#CrmreqAssetNo_' + rowCount).focus();
    formInputValidation("form");
}

function RemarksHistoryHtml() {

    return ' <tr class="ng-scope" style=""> <td width="5%" style="text-align: center;"> <div> <input type="text" id="CRMReqRemHisSNo_maxindexval" name="SystemTypeCode" class="form-control" autocomplete="off" disabled> </div></td><td width="35%" style="text-align: center;"> <div> <input id="CRMReqRemHisRemarks_maxindexval" type="text" class="form-control" name="SystemTypeDescription" autocomplete="off" disabled> </div></td><td width="20%" style="text-align: center;"> <div> <input id="CRMReqRemHisEntby_maxindexval" type="text" class="form-control" name="SystemTypeDescription" autocomplete="off" disabled> </div></td><td width="20%" style="text-align: center;"> <div> <input type="text" id="CRMReqRemHisDate_maxindexval" name="SystemTypeCode" class="form-control datatimepicker" autocomplete="off" disabled> </div></td><td width="20%" style="text-align: center;"> <div> <input type="text" id="CRMReqRemHisStatus_maxindexval" class="form-control datatimepicker" name="SystemTypeDescription" autocomplete="off" disabled> </div></td></tr> ';
}

// Purchase Request Popup

function PurchaseNewRow() {
    var inputpar = {
        inlineHTML: PurchaseRequestHtml(),//Inline Html
        TargetId: "#PurchaseRequestGrid",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    $('#PurchaseRequestGrid tr:last td:first input').focus();

    $('.digOnly').keypress(function (e) {
        var regex = new RegExp(/[^.a-zA-Z]/, '');
        var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
        if (regex.test(str)) {
            return true;
        }
        e.preventDefault();
        return false;
    });
    $('.digOnly').on('paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[a-zA-Z0-9~`!@#.$%^&*_+|\\:{}\[\];-?<>\^\"\']/g, ''));
        }, 5);
    });

    $('.Zerofirst').on('input propertychange paste', function (e) {
        var reg = /^0+/gi;
        if (this.value.match(reg)) {
            this.value = this.value.replace(reg, '');
        }
    });

}

function PurchaseRequestHtml() {
    return ' <tr class="ng-scope" style=""> <td width="20%" style="text-align: center;" data-original-title="" title=""> <div> <div> <input type="text" autocomplete="off" placeholder="Please select" required id="PurchasePartNo_maxindexval" value="" class="form-control fetchField" onkeyup="FetchdataPurchasePartNo(event,maxindexval)" onpaste="FetchdataPurchasePartNo(event,maxindexval)" change="FetchdataPurchasePartNo(event,maxindexval)" oninput="FetchdataPurchasePartNo(event,maxindexval)"> </div><input type="hidden" id="PurchaseSparePartStockRegisterId_maxindexval"/> <input type="hidden" id="PurchaseRequestId_maxindexval"/> <div class="col-sm-12" id="divFetchPurchase_maxindexval"></div></div></td><td width="20%" style="text-align: center;"> <div> <input id="PurchasePartDescription_maxindexval" type="text" class="form-control" name="PurchasePartDescription" autocomplete="off" disabled> </div></td><td width="20%" style="text-align: center;"> <div> <input id="PurchaseItemCode_maxindexval" type="text" class="form-control" name="PurchasePartNo" autocomplete="off" disabled> </div></td><td width="20%" style="text-align: center;"> <div> <input type="text" id="PurchaseItemDescription_maxindexval" name="PurchasePartDescription" class="form-control" autocomplete="off" disabled> </div></td><td width="20%" style="text-align: center;"> <div> <input id="PurchaseQuantity_maxindexval" type="text" class="form-control digOnly Zerofirst text-right" pattern="^((?!(0))[0-9]{1,15})$" name="PurchaseQuantity" maxlength="4" required autocomplete="off"> </div></td></tr> ';
}

function AddPurchaseNewRow() {
    var _index;
    $('#PurchaseRequestGrid tr').each(function () {
        _index = $(this).index();

    });
    var flagAllow = 0;
    for (var i = 0; i <= _index; i++) {
        var SparePartStockRegisterId = $("#PurchaseSparePartStockRegisterId_" + i).val();
        var Quantity = $("#PurchaseQuantity_" + i).val();
        Quantity = (Quantity == "0") ? "" : Quantity;

        if (SparePartStockRegisterId && Quantity) { }
        else
            flagAllow++;
    }
    if (flagAllow != 0) {
        bootbox.alert("Please enter data for existing rows");
        return;

    }
    PurchaseNewRow();

    formInputValidation("form");
}

function FetchdataPurchasePartNo(event, index) {

    var ItemMst = {
        SearchColumn: 'PurchasePartNo_' + index + '-PartNo',//Id of Fetch field
        ResultColumns: ["SparePartsId" + "-Primary Key", 'Partno' + '-Partno' + index, 'PartDescription' + '-PartDescription' + index, 'ItemCode' + '-ItemCode' + index, 'ItemDescription' + '-ItemDescription' + index],//Columns to be displayed
        FieldsToBeFilled: ["PurchaseSparePartStockRegisterId_" + index + "-SparePartsId", 'PurchasePartNo_' + index + '-Partno', 'PurchasePartDescription_' + index + '-PartDescription', 'PurchaseItemCode_' + index + '-ItemCode', 'PurchaseItemDescription_' + index + '-ItemDescription']//id of element - the model property
    };
    DisplayFetchResult('divFetchPurchase_' + index, ItemMst, "/api/Fetch/FetchItemMstdetais", "Ulfetch11" + index, event, 1);
}

function PurchaseRequestSave() {
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgPurchase').css('visibility', 'hidden');

    var isFormValid = formInputValidation("PurchaseModal", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsgPurchase').css('visibility', 'visible');

        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }

    var _index;
    $('#PurchaseRequestGrid tr').each(function () {
        _index = $(this).index();
    });

    var resultList = [];
    for (var i = 0; i <= _index; i++) {
        var obj = {
            PurchaseRequestId: $('#PurchaseRequestId_' + i).val(),
            PurchaseSparePartStockRegisterId: $('#PurchaseSparePartStockRegisterId_' + i).val(),
            WorkOrderId: GlobalWorkOrderId,
            PurchaseQuantity: $('#PurchaseQuantity_' + i).val(),
        };

        if ((obj.PurchaseSparePartStockRegisterId == null) || (obj.PurchaseSparePartStockRegisterId == "") || (obj.PurchaseSparePartStockRegisterId == undefined)) {

            $("div.errormsgcenter").text("Valid Part No. Required");
            $('#errorMsgPurchase').css('visibility', 'visible');
            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }
        resultList.push(obj);
    }
    PurchaseRequestsubmit(resultList);
}

function PurchaseRequestsubmit(result) {
    var obj1 = {
        WorkOrderType: 188,
        WorkOrderId: GlobalWorkOrderId,
        PurchaseRequestDets: result,
        EngineerId: $('#hdnEngineerId').val(),
        WorkOrderNo: $('#PartWorkOrderNo').val(),
        Assignee: $('#txtEngineer').val(),
        PartWorkOrderDate: $('#PartWorkOrderDate').val(),
        AssetNo: $('#txtAssetNo').val(),
        Model: $('#txtModel').val(),
        Manufacturer: $('#txtManufacturer').val(),
    }

    var jqxhr = $.post("/api/ScheduledWorkOrder/AddPurchaseRequest", obj1, function (response) {
        var result = JSON.parse(response);
        var htmlval = ""; $('#tablebody').empty();

        PurchaseRequestDetails = result.PurchaseRequestDets;
        if (PurchaseRequestDetails == null) {
            PushEmptyMessage();
        }
        else {
            bindDatatoPurchaseRequestgrid(PurchaseRequestDetails);
        }

        $('#errorMsgPurchase').css('visibility', 'hidden');
        $("#top-notificationspopup").modal('show');
        $('#msg5').removeClass("fa fa-times"); //SUCCESS
        $('#msg5').addClass("fa fa-check");
        $('#hdr5').html("Data saved successfully");
        setTimeout(function () {
            $("#top-notificationspopup").modal('hide');
        }, 1000);

        //showMessage('Purchase Request', CURD_MESSAGE_STATUS.SS);

        $('#myPleaseWait').modal('hide');

    },
        "json")
        .fail(function (response) {
            var errorMessage = "";
            errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsgPurchase').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
        });
}

function GetPurchaseRequest() {
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgPurchase').css('visibility', 'hidden');

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/ScheduledWorkOrder/GetPurchaseRequest/" + primaryId)
            .done(function (result) {
                var htmlval = "";
                var getResult = JSON.parse(result);
                var sts = $('#divWOStatus').text();
                PurchaseRequestDetails = getResult.PurchaseRequestDets;
                if (PurchaseRequestDetails == null) {
                    $("#PurchaseRequestGrid").empty();
                    PurchaseNewRow();
                }
                else {
                    bindDatatoPurchaseRequestgrid(PurchaseRequestDetails);
                }

                $('#myPleaseWait').modal('hide');

                if (sts == "Closed") {
                    $("#tab-3 :input:not(:button)").prop("disabled", true);
                    $('#AddPurchaseNewRow').hide();
                    $('#btnPurchasePopUpSave').hide();
                } else {
                    var len = $('#dataTablePart tr').length - 1;
                    for (i = 0; i < len; i++) {
                        $('#PurchasePartNo_' + i).attr('disabled', false);
                        $('#PurchaseQuantity_' + i).attr('disabled', false);
                    }
                    $('#AddPurchaseNewRow').show();
                    $('#btnPurchasePopUpSave').show();
                }
            })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsgPurchase').css('visibility', 'visible');
            });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}

function bindDatatoPurchaseRequestgrid(list) {
    if (list.length > 0) {
        $('#PurchaseRequestGrid').empty()
        var html = '';

        $(list).each(function (index, data) {
            html = '<tr class="ng-scope" style=""> <td width="20%" style="text-align: center;" data-original-title="" title=""> <div> <div> <input type="text" autocomplete="off" placeholder="Please select" required id="PurchasePartNo_' + index + '" value="' + data.PurchasePartNo + '" class="form-control fetchField" onkeyup="FetchdataPurchasePartNo(event,' + index + ')" onpaste="FetchdataPurchasePartNo(event,' + index + ')" change="FetchdataPurchasePartNo(event,' + index + ')" oninput="FetchdataPurchasePartNo(event,' + index + ')"> </div><input type="hidden" value="' + data.PurchaseSparePartStockRegisterId + '" id="PurchaseSparePartStockRegisterId_' + index + '"/><input type="hidden" value="' + data.PurchaseRequestId + '" id="PurchaseRequestId_' + index + '"/><div class="col-sm-12" id="divFetchPurchase_' + index + '"></div></div></td><td width="20%" style="text-align: center;"><div> <input id="PurchasePartDescription_' + index + '" value="' + data.PurchasePartDescription + '" type="text" class="form-control" name="PurchasePartDescription" autocomplete="off" disabled></div></td><td width="20%" style="text-align: center;"><div> <input id="PurchaseItemCode_' + index + '" value="' + data.PurchaseItemCode + '" type="text" class="form-control" name="PurchaseItemCode" autocomplete="off" disabled></div></td><td width="20%" style="text-align: center;"><div> <input type="text" id="PurchaseItemDescription_' + index + '" value="' + data.PurchaseItemDescription + '" name="PurchasePartDescription" class="form-control" autocomplete="off" disabled></div></td><td width="20%" style="text-align: center;"><div> <input id="PurchaseQuantity_' + index + '" value="' + data.PurchaseQuantity + '" type="text" maxlength="4" class="form-control digOnly text-right" pattern="^((?!(0))[0-9]{1,15})$" name="PurchaseQuantity" required autocomplete="off"></div></td></tr>';
            $('#PurchaseRequestGrid').append(html);
        });
        var mapIdproperty = ["PurchasePartNo-PurchasePartNo_", "PurchasePartDescription-PurchasePartDescription_", "PurchaseItemCode-PurchaseItemCode_", "PurchaseItemDescription-PurchaseItemDescription_", "PurchaseQuantity-PurchaseQuantity_"];
        var htmltext = PurchaseRequestHtml();

        //id = $('#primaryID').val();
        //var obj = { formId: "#tab-3", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "PartReplacementDets", tableid: '#PartReplacementResultId', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/ScheduledWorkOrder/GetPartReplacement/" + id, pageindex: pageindex, pagesize: pagesize };

        //CreateFooterPagination(obj);
    }
    formInputValidation("form");
}

function ReasonOperation() {
    var CCID = $('#Status').val();
    if (CCID == 197) {
        $('#ReasonStarHide').show();
        $('#Reason').prop('required', true);
    }
    else {
        $('#ReasonStarHide').hide();
        $('#Reason').prop('required', false);
        $("#Reason").parent().removeClass('has-error');
    }

}

function CalculateRepairHours(index) {
    var start_actual_time = $('#StartDate_' + index).val();
    var end_actual_time = $('#EndDate_' + index).val();

    start_actual_time = new Date(start_actual_time);
    end_actual_time = new Date(end_actual_time);

    var diff = end_actual_time - start_actual_time;

    var diffSeconds = diff / 1000;
    var HH = Math.floor(diffSeconds / 3600);
    var MM = Math.floor(diffSeconds % 3600) / 60;

    var formatted = ((HH < 10) ? ("0" + HH) : HH) + " : " + ((MM < 10) ? ("0" + MM) : MM)

    if (end_actual_time != "") {
        $('#PPMHours_' + index).val(formatted);
    }
    //$('#PPMHours_' + index).val(formatted);
}

//********************** UnSchedule Report Print ***********************

function getUnScheduleWorkOrderPrintReport() {
    var WorkOrderId = $("#primaryID").val();
    if (WorkOrderId == "" || WorkOrderId == null || WorkOrderId == "null" || WorkOrderId == 0 || WorkOrderId == "0") {
        bootbox.alert("UnSchedule Work Order not allow to print");
    }
    else {
        window.open("/bems/unscheduleworkorderprint/index/" + WorkOrderId, 'UnScheduled Work Order Print', "height=500,width=1000");
        //window.location.href = "/bems/unscheduleworkorderprint/index/" + WorkOrderId;
    }
}




function printDivs(divName) {
    generatePDFs();

    //var iframe = document.getElementById('myIframe');

    //var urls = document.getElementById('myIframe').src;
    //window.open(urls);

}
function printDiv(divName) {
    // generatePDF();
    PrintRDL();
    var iframe = document.getElementById('myIframe');

    var urls = document.getElementById('myIframe').src;
    window.open(urls);


}




function generatePDF() {
    // Choose the element that our invoice is rendered in.
    const element = document.getElementById("divPrintHistory11");
    // Choose the element and save the PDF for our user.
    //==new
    //var options = {
    //    filename: 'Download.pdf',
    //    margin: [1, 1, 1, 1],       
    //    image: { type: 'PDF', quality: 0.98 },
    //    html2canvas: { scale: 1, logging: true, dpi: 192, letterRendering: true },
    //    jsPDF: { unit: 'mm', format: 'a4', orientation: 'p' }
    //};

    //// Create instance of html2pdf class
    //var exporter = new html2pdf(element, options);

    // Download the PDF or...
    //exporter.getPdf(true).then((pdf) => {
    //    console.log('pdf file downloaded');
    //});

    //// Get the jsPDF object to work with it
    //exporter.getPdf(false).then((pdf) => {
    //    console.log('doing something before downloading pdf file');
    //    pdf.save();
    //});

    //options.source = element;
    //options.download = true;
    //html2pdf.getPdf(options);
    html2pdf().from(element).save();
}



function generatePDFs() {
    // Choose the element that our invoice is rendered in.
    const element = document.getElementById("divPrintHistory112");
    // Choose the element and save the PDF for our user.

    //---new 
    //var options = {
    //    filename: 'my-file.pdf'
    //};

    //// Create instance of html2pdf class
    //var exporter = new html2pdf(element, options);

    //// Download the PDF or...
    //exporter.getPdf(true).then((pdf) => {
    //    console.log('pdf file downloaded');
    //});

    html2pdf().from(element).save();

}




