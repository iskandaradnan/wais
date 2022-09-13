//*Global variables decration section starts*//

var LOVlist = {};
var UserRoleGlobal = null;
var pageindex = 1, pagesize = 5;
var GridtotalRecords = 0;
var TotalPages = 0, FirstRecord = 0, LastRecord = 0;
//*Golbal variables decration section ends*//
var CompletionDetails = [];
var PartReplacementDetails = [];
var PartReplacementPopUpDetails = [];
var TransferDetails = [];
var RescheduleDetails = [];
var CompletionInfoId = 0;
var WOTransferId = 0;
var TypeOfWorkOrder = 0;
var WorkOrderStatus = 0;
var WorkOrderStatusString = 0;
var AssetWorkingStatus = 0;
var CompletionInfoDetId = 0;
var PartReplacementId = 0;
var ListModel = [];
var GlobalWorkOrderNo = null;
var GlobalWorkOrderDate = null;
var GlobalAssetNo = null;
var GlobalAssetNoCost = null;
var GlobalAssignee = null;
var GlobalAssetDescription = null;
var GlobalTargetDate = null;
var CompInfoReScheduledDate = null;
var GlobalWOPPMCheckListId = 0;
var Submitted = 0;
var GlobalWorkOrderId = 0;


window.StatusListGloabal = [];
window.StatusListGloabalCategory = [];
window.StockTypeListGloabal = [];
var GlobalRunningHoursCapture = 0;
var WorkOrderStatusStringLoad = "";
var primaryId = $("#primaryID").val();
var IsExternal = false;
var hasApproveRolePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");
$(function () {
    $(".nav-tabs > li:not(:first-child)").click(function () {        
        var primaryId = $('#primaryID').val();
        if (primaryId == 0) {
            bootbox.alert("Save the details before moving on to Other!");
            return false;
        }
    });

    $('#txtremarks').prop('disabled', true);
    $('#txtremarks').prop('required', false);
    $('#ApproveCancelRemarks').css('visibility', 'hidden');
    $('#CancelRequestRemarks').css('visibility', 'hidden');
    $('#btnDelete').hide();
    $('#btnDelete').text('Cancel')
    $('#btnApprove').hide();
    $('#btnReject').hide();
    //$('#btnSWOPrint').hide();
    //$('#btnPPMCheckListPrint').hide();

    //$('#btnEdit').prop('disabled', true);
    //$('#btnCompletionSave').prop('disabled', true);
    $('#btnCompletionSubmitEdit').hide();
    //$('#btnPartSave').prop('disabled', true);
    //$('#btnTransferSave').prop('disabled', true);
    //$('#btnRescheduleSave').prop('disabled', true);
    //$('#btnPPMCheckListSave').prop('disabled', true);
    $('#btnSaveandAddNew').hide();
    $('#myPleaseWait').modal('show');
    formInputValidation("formScheduledWorkOrder");
    formInputValidation("tab-2");
    formInputValidation("tab-3");
    formInputValidation("tab-4");

    $.get("/api/ScheduledWorkOrder/Load")
        .done(function (result) {
           
            var loadResult = JSON.parse(result);
            //$("#jQGridCollapse1").click();
            LOVlist = loadResult;
            if (!loadResult.IsAdditionalFieldsExist) {
                $('#liAFAdditionalInfo').hide();
            }
            $.each(loadResult.TypeOfPlannerList, function (index, value) {
                $('#WorkOrderCategory').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            // $("#WorkOrderCategory option[value='35']").remove();
            $.each(loadResult.WarrentyTypeList, function (index, value) {
                $('#MaintainanceType').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
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
            $.each(loadResult.PartReplacementCostInvolvedList, function (index, value) {
                $('#PartReplacementCostInvolved').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.CustomerFeedbak, function (index, value) {
                $('#selCustomerFeedback').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            window.StatusListGloabal = loadResult.PPMCheckListStatusList;
            window.StatusListGloabalCategory = loadResult.PPMCheckListStatusCategoryList;
            window.StockTypeListGloabal = loadResult.StockTypeList;

            IsExternal = loadResult.IsExternal ? true : false;

            $('#PartReplacementCostInvolved').val(99);
            $('#PartReplacementCostHide').hide();
            //$('#PartReplacementCost').prop('required', false);
            //$('#PartReplacementCost').prop('disabled', true);
            $('#btnSWOPrint').hide();
            $('#btnPPMCheckListPrint').hide();
            $('#divAssetStatus1').hide();
            $('#btnSaveandAddNew').show();            
            var workOrderId = $('#hdnWorkOrderId').val();
            if (workOrderId != null && workOrderId != "" && workOrderId != "0") {
                var rowData1 = {};
                alert(hasApproveRolePermission);
                
                LinkClicked(workOrderId, rowData1)
            }

            if (IsExternal) {
                $('#btnSave').hide();
                $('#btnEdit').hide();
                $('#btnSaveandAddNew').hide();
            }
        })
        .fail(function (response) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            $('#errorMsg').css('visibility', 'visible');
        });

    $("#btnSave,#btnEdit,#btnSaveandAddNew").click(function () {

        var EngineerHiddenValue = $('#hdnEngineerId').val();
        var EngineerValue = $('#txtEngineer').val();
        var TargetDateValue = $('#TargetDate').val();
        //var TypeCodeValue = $('#txtAssetTypeCode').val();

        if (EngineerValue != "" && EngineerHiddenValue == "") {
            bootbox.alert("Valid Assignee required!");
            return false;
        }
        //if (TypeCodeValue != "" && TypeCodeHiddenValue == "") {
        //    bootbox.alert("Valid Type Code required!");
        //    return false;
        //}
        var TempPrimaryId = $("#primaryID").val();
        if (TargetDateValue != "" && TempPrimaryId == "0") {
            var d = new Date();
            var TempD = moment(d).format("DD-MMM-YYYY");
            if (TempD > TargetDateValue) {
                bootbox.alert("Agreed Date should not be a Past Date!");
                return false;
            }
        }
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
        var primaryId = $("#primaryID").val();
        var AssetId = $('#hdnAssetId').val();
        var EngineerId = $('#hdnEngineerId').val();
        var AssetTypeCodeId = $('#hdnAssetTypeCodeId').val();
        var MaintainanceType = $('#MaintainanceType').val();
        var MaintainanceDetails = $('#txtMaintainanceDetails').val();
        var WorkOrderNo = $('#txtWorkOrderNo').val();
        var TargetDate = $('#TargetDate').val();
        var WorkOrderCategory = $('#WorkOrderCategory').val();
        var Timestamp = $('#Timestamp').val();
        var PartWorkOrderDate = $('#partWorkOrderDate').val();

        var obj = {
            WorkOrderId: primaryId,
            WorkOrderNo: WorkOrderNo,
            AssetRegisterId: AssetId,
            EngineerId: EngineerId,
            AssetTypeCodeId: AssetTypeCodeId,
            MaintenanceType: MaintainanceType,
            TypeOfWorkOrder: TypeOfWorkOrder,
            WorkOrderStatus: WorkOrderStatus,
            MaintenanceDetails: MaintainanceDetails,
            WorkOrderType: 187,
            TargetDate: TargetDate,
            WorkOrderCategory: WorkOrderCategory,
            Timestamp: Timestamp,
            PartWorkOrderDate: CurDateTime
        };

        var jqxhr = $.post("/api/ScheduledWorkOrder/Add", obj, function (response) {
            var getResult = JSON.parse(response);
           
            $('#hdnAttachId').val(getResult.HiddenId);
            
            TypeOfWorkOrder = getResult.TypeOfWorkOrder;
            WorkOrderStatus = getResult.WorkOrderStatus;
            $('#divWOStatus').text(getResult.WorkOrderStatusValue);
            $('#hdnWoSts').val(getResult.WorkOrderStatusValue);

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
            GlobalAssetNo = getResult.AssetNo;
            GlobalAssetNoCost = getResult.AssetNoCost;
            $('#hdnAssetId').val(getResult.AssetRegisterId);
            $('#txtAssetNo').val(getResult.AssetNo);
            if (getResult.AssetNo == "") {
                $('#txtAssetNo').prop('required', false);
            }
            $('#txtAssetDescription').val(getResult.AssetDescription);
            $('#txtUserArea').val(getResult.UserArea);
            $('#txtUserLocation').val(getResult.UserLocation);
            $('#txtLevel').val(getResult.Level);
            $('#txtBlock').val(getResult.Block);
            $('#txtContractType').val(getResult.ContractTypeValue);
            $("#partWorkOrderDate").val(moment(getResult.PartWorkOrderDate).format("DD-MMM-YYYY HH:mm")).prop("disabled", true);
            $('#TargetDate').val(moment(getResult.TargetDate).format("DD-MMM-YYYY"));
            GlobalTargetDate = getResult.TargetDate;
            CompInfoReScheduledDate = getResult.TargetDate;
            $('#txtModel').val(getResult.Model);
            $('#hdnAssetTypeCodeId').val(getResult.AssetTypeCodeId);
            $('#txtAssetTypeCode').val(getResult.AssetTypeCode);
            $('#txtManufacturer').val(getResult.Manufacturer);
            $('#hdnEngineerId').val(getResult.EngineerId);
            $('#txtEngineer').val(getResult.Engineer);
            $('#txtWorkOrderNo').val(getResult.WorkOrderNo);
            GlobalWorkOrderNo = getResult.WorkOrderNo;
            GlobalWorkOrderDate = getResult.PartWorkOrderDate;
            $('#MaintainanceType').val(getResult.MaintenanceType);
            // $('#txtWorkOrderStatus').val(getResult.WorkOrderStatusValue);
            $('#txtMaintainanceDetails').val(getResult.MaintenanceDetails);
            $('#primaryID').val(getResult.WorkOrderId);
            $("#Timestamp").val(getResult.Timestamp);
            $('#WorkOrderCategory').val(getResult.WorkOrderCategory).prop('disabled', true);
            $('#TargetDate').prop('disabled', true);
            $('#txtAssetNo').prop('disabled', true);
            $('#txtEngineer').prop('disabled', true);
            $('#txtMaintainanceDetails').prop('disabled', true);
            $("#grid").trigger('reloadGrid');
            if (getResult.WorkOrderId != 0) {
                $('#btnEdit').show();
                $('#btnDelete').show();
                $('#btnSave').hide();
                //  $('#txtAssetNo').prop('disabled', true);
            }
            if (WorkOrderStatusString == "Open" || WorkOrderStatusString == "Work In Progress") {
                $('#btnSWOPrint').show();
            }
            $(".content").scrollTop(0);
            showMessage('Scheduled Work Order', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);
            $('#btnSave').attr('disabled', false);
            $('#btnEdit').prop('disabled', false);
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
    //fetch - type code 
    var typeCodeFetchObj = {
        SearchColumn: 'txtAssetTypeCode-AssetTypeCode',//Id of Fetch field
        ResultColumns: ["AssetTypeCodeId-Primary Key", 'AssetTypeCode-AssetTypeCode', 'AssetTypeDescription-AssetTypeDescription'],//Columns to be displayed
        AdditionalConditions: ["TypeOfPlanner-TypeOfPlanner", "AssetClassificationId-AssetClarification"],
        FieldsToBeFilled: ["hdnAssetTypeCodeId-AssetTypeCodeId", "txtAssetTypeCode-AssetTypeCode", "txtTypeCodeDetails-AssetTypeDescription"]//id of element - the model property
    };

    var apiUrlForTypeCodeFetch = "/api/Fetch/TypeCodeFetch";

    $('#txtAssetTypeCode').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divTypeCodeFetch', typeCodeFetchObj, apiUrlForTypeCodeFetch, "UlFetch", event, 1);//1 -- pageIndex
    });


    //fetch - Asset No 
    var AssetNoFetchObj = {
        SearchColumn: 'txtAssetNo-AssetNo',//Id of Fetch field
        ResultColumns: ["AssetId-Primary Key", 'AssetNo-AssetNo', 'AssetDescription-AssetDescription'],
        AdditionalConditions: ["TypeOfPlanner-TypeOfPlanner"],
        FieldsToBeFilled: ["hdnAssetId-AssetId", "txtAssetNo-AssetNo", "txtAssetName-AssetName", "txtAssetDescription-AssetDescription", "txtModel-Model",
            "txtManufacturer-Manufacturer", "txtUserArea-UserAreaCode", "txtUserLocation-UserLocationCode", "txtContactNumber-ContactNumber",
            "MaintainanceType-WarrentyType", "txtLevel-Level", "txtBlock-Block", "txtContractType-ContractTypeValue", 'txtAssetTypeCode-TypeCode',
            'hdnAssetTypeCodeId-TypeCodeID', 'txtTypeCodeDetails-TypeCodeDescription']
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

    ////Block Code Search
    //var BlockSearchObj = {
    //    Heading: "QC PPM Details",//Heading of the popup
    //    SearchColumns: ['BlockCode-Block Code', 'BlockName-Block Name'],//ModelProperty - Space seperated label value
    //    ResultColumns: ["BlockId-Primary Key", 'BlockCode-Block Code', 'BlockName-Block Name'],//Columns to be returned for display
    //    FieldsToBeFilled: ["hdnBlockId-BlockId", "txtBlockCode-BlockCode", "txtBlockName-BlockName"]//id of element - the model property
    //};

    //$('#spnPopup-Block').click(function () {
    //    DisplaySeachPopup('divSearchPopup', BlockSearchObj, "/api/Search/blockSearch");

    //});


    //Block Code Search
    
    var QCPPMSearchObj = {
        Heading: "QC PPM Details",//Heading of the popup
        SearchColumns: ['Description-QC PPM Code', 'CauseCode-QC PPM Name'],//ModelProperty - Space seperated label value
        ResultColumns: ["QualityCauseId-Primary Key", 'CauseCode-QC PPM Code', 'Description-QC PPM Name'],//Columns to be returned for display
        FieldsToBeFilled: ["hdnBlockId-QualityCauseId", "QCDescription-CauseCode", "txtBlockName-Description"]//id of element - the model property
    };

    $('#spnPopup-Block').click(function () {
        DisplaySeachPopup('divSearchPopup', QCPPMSearchObj, "/api/Search/QCPPMSearch");

    });



    $('#btnAddNew').click(function () {
        window.location.reload();
    });

    $("#btnCompletionCancel,#btnPartCancel,#btnTransferCancel,#btnRescheduleCancel,#btnfileCancel,#btnPPMCheckListCancel").click(function () {
        var message = Messages.Reset_TabAlert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                window.location.href = "/BEMS/ScheduledWorkOrder";
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
    var workOrderId = $('#hdnWorkOrderId').val();
    var fromOtherScreen = workOrderId != null && workOrderId != "" && workOrderId != "0";

    if (ID == null || ID == undefined || ID == 0 || ID == '' || ID == "") {
        if (!fromOtherScreen) {
            $("#jQGridCollapse1").click();
        }
    }
    else {
        if (ID != null && ID != "0") {
            $.get("/api/ScheduledWorkOrder/Get/" + ID)
                .done(function (result) {
                    var getResult = JSON.parse(result);
                    TypeOfWorkOrder = getResult.TypeOfWorkOrder;
                    var WorkOrderStatusLoad = getResult.WorkOrderStatus;
                    WorkOrderStatusStringLoad = getResult.WorkOrderStatusValue;
                    LinkClicked(ID, WorkOrderStatusStringLoad);
                })
                .fail(function (response) {
                    $('#myPleaseWait').modal('hide');
                    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                    $('#errorMsg').css('visibility', 'visible');
                });
        }
    }
    // **** Query String to get ID  End****\\\


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
});
//---------------------------2nd tab-----------------------------------------------

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
    // formInputValidation("tab-2", 'save');
    var isFormValid = formInputValidation("tab-2", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsgCompletionInfo').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        return false;
    }

    var StartDate = $('#txtStartDate').val();
    var HandoverDate = $('#txtHandoverDate').val();

    if (CompletionInfoId == 0) {
        if (StartDate != "") {
            if ((StartDate > HandoverDate)) {
                $('#myPleaseWait').modal('hide');
                bootbox.alert("Hand Over Date should be greater than Start Date!")
                return false;
            }
        }
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
            StandardTaskDetId: $('#StandardTaskDetId_' + i).val(),
            StartDate: $('#StartDate_' + i).val(),
            EndDate: $('#EndDate_' + i).val(),
            PPMHours: $('#PPMHours_' + i).val(),
            //CostPerHour: $('#hdnCostPerHour_' + i).val(),                        
            IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
        };

        if (obj.EndDate == " " || obj.EndDate == "") {
            obj.EndDate = null;
        }
        var CurrDate = new Date();
        var stDt = obj.StartDate;
        var endDt = obj.EndDate;
        var scheduleWorkTime = Date.parse($("#partWorkOrderDate").val());
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
        if (stDt < scheduleWorkTime) {
            $("div.errormsgcenter").text("Start Date / Time should be greater than Workorder Date/Time");
            $('#errorMsgCompletionInfo').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }
        resultList.push(obj);
    }

    for (var j = 0; j < resultList.length; j++) {
        if (resultList[j].EndDate != null) {
            var Sdate = new Date(resultList[j].StartDate);
            var Edate = new Date(resultList[j].EndDate);
            if (Sdate > Edate) {
                $("div.errormsgcenter").text("End Date should be greater than Start Date!");
                $('#errorMsgCompletionInfo').css('visibility', 'visible');
                //bootbox.alert("End Date should be greater than Start Date!");
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }
    }
    var TotalHoursResult = 0;

    //if (Enumerable.From(resultList).Any(x=>x.IsDeleted != true)) {
    //    resultList = Enumerable.From(resultList).Where(x=>x.IsDeleted != true).ToArray();
    //    for (var k = 0 ; k < resultList.length; k++) {
    //        var hour = $('#PPMHours_' + k).val();
    //        var txt = hour.replace(/\s:\s/g, '.');
    //        if (resultList[k].PPMHours != null) {
    //            var costperunit = resultList[k].CostPerHour == "" ? 0 : parseFloat(resultList[k].CostPerHour);
    //            var ppmhours = resultList[k].PPMHours == null ? 0 : parseFloat(txt);
    //            TotalHoursResult += costperunit * ppmhours; 
    //        }
    //    }
    //}
    //GlobalPartTotalLabourCost=TotalHoursResult;
    //alert(GlobalPartTotalLabourCost);

    function chkIsDeletedRow(i, delrec) {
        if (delrec == true) {
            $('#EmployeeName_' + i).prop("required", false);
            $('#TaskCode_' + i).prop("required", false);
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
    var hndDt = Date.parse(HandOverDate);
    var today = new Date();
    var isFormValid = formInputValidation("tab-2", 'save');

    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsgCompletionInfo').css('visibility', 'visible');

        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }
    if (hndDt != null) {
        if (hndDt < endDt) {
            $("div.errormsgcenter").text("HandOver Date / Time Must be Greater than End Date / Time");
            $('#errorMsgCompletionInfo').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }
    }

    //if (hndDt > endDt) {
    //    if (hndDt = endDt) {
    //        $("div.errormsgcenter").text("HandOver Date / Time Must be Greater than End Date / Time");
    //        $('#errorMsgCompletionInfo').css('visibility', 'visible');
    //        $('#myPleaseWait').modal('hide');
    //        return false;
    //    }
    //}
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
    var d = new Date();
    d = moment(d).format("DD-MMM-YYYY");
    GlobalTargetDate = moment(GlobalTargetDate).format("DD-MMM-YYYY");
    CompInfoReScheduledDate = moment(CompInfoReScheduledDate).format("DD-MMM-YYYY");
    if (GlobalTargetDate < d) {
        if ($('#CauseCodeDescription').val() == "0" || $('#QCDescription').val() == "0") {
            var message = "Agreed Date is exceeded! So Failure Root Cause Description & Failure Symptom Code Description are required!";
            $("div.errormsgcenter").text(message);
            $('#errorMsgCompletionInfo').css('visibility', 'visible');
            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }
    }

    var Isdeleteavailable = Enumerable.From(resultList).Where(x => x.IsDeleted).Count() > 0;
    if (Isdeleteavailable) {
        message = "Are you sure that you want to delete the record(s)?";
        bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (result) {
            if (result) {
                Completionsubmit(resultList);
            }
            else {
                $('#myPleaseWait').modal('hide');
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
        AgreedDate: $('#txtAgreedDate').val(),
        //AgreedDate: agreeddate,
        Timestamp: $('#Timestamp').val(),
        RunningHours: $('#txtRunningHours').val(),
        VendorServicecost: $('#VendorServiceCost').val(),
        IsSubmitted: Submitted,
        CustomerFeedback: $('#selCustomerFeedback').val(),
        CompletionInfoDets: result
    }

    if (obj1.CompletionInfoId == 0) {
        obj1.VerifiedById = null;
    }
    if (obj1.HandOverDate == "") {
        obj1.HandOverDate = null;
    }
    if (obj1.EndDate == "") {
        obj1.EndDate = null;
    }

    var jqxhr = $.post("/api/ScheduledWorkOrder/addCompletionInfo", obj1, function (response) {
        var result = JSON.parse(response);
        var htmlval = ""; $('#tablebody').empty();

        if (GlobalRunningHoursCapture != 0) {
            if (GlobalRunningHoursCapture == 99) {
                $('#txtRunningHours').prop('required', true);
                $('#SpanRun').show();
                $('#txtRunningHours').prop('disabled', false);
            }
            else if (GlobalRunningHoursCapture == 100) {
                $('#txtRunningHours').prop('required', false);
                $('#SpanRun').hide();
                $('#txtRunningHours').prop('disabled', true);
            }
        }
        if (result.CompletionInfoId > 0) {
            $('#txtVerifiedBy').prop('disabled', false);
            $('#txtHandoverDate').prop('disabled', false);
            $('#txtVerifiedBy').prop('required', true);
            $("#lblVerify").html("Verified By <span class='red'>*</span>");
            $("#lblHanddt").html("Handover Date / Time <span class='red'>*</span>");
            $('#txtHandoverDate').prop('required', true);
            $("#lblVerify").html("Verified By <span class='red'>*</span>");
            $('#btnCompletionSubmitEdit').show();
            $('#btnCompletionSave').hide();
        }
        if (result.HandOverDate == "0001-01-01T00:00:00") {
            result.HandOverDate = null;
        }
        if (result.EndDateMain == "0001-01-01T00:00:00" || result.EndDateMain == null) {
            result.EndDateMain = "";
        }

        CompletionInfoId = result.CompletionInfoId;
        $('.divWOStatus').text(result.WorkOrderStatusValue);
        WorkOrderStatusString = result.WorkOrderStatusValue;
        $('#txtWorkOrderNo').val(result.WorkOrderNo);
        $('#txtStartDate').val(moment(result.StartDateMain).format("DD-MMM-YYYY HH:mm"));
        if (result.EndDateMain != "") {
            $('#txtEndDate').val(moment(result.EndDateMain).format("DD-MMM-YYYY HH:mm"));
        }
        $('#hdnCompletedById').val(result.CompletedById);
        $('#txtCompletedBy').val(result.CompletedBy);

        $('#txtCompletedByDesignation').val(result.CompletedByDesignation);
        if (result.HandOverDate != null) {
            $('#txtHandoverDate').val(moment(result.HandOverDate).format("DD-MMM-YYYY HH:mm"));
        }
        if (result.Status == null) {
            result.Status = 0;
        }
        if (result.CauseCodeDescription == null) {
            result.Status = 0;
        }
        if (result.QCDescription == null) {
            result.Status = 0;
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
        //$('#hdnAssetTypeCodeId').val(getResult.AssetTypeCodeId);
        if (('#hdnAssetTypeCodeId').value != "" || ('#hdnAssetTypeCodeId').value != null) {

        }
        else {
            ('#hdnAssetTypeCodeId').text(getResult.AssetTypeCodeId);
        }

        //$('#txtAssetTypeCode').val(getResult.AssetTypeCode);
        if (('#txtAssetTypeCode').value != "" || ('#txtAssetTypeCode').value != null) {

        }
        else {
            ('#txtAssetTypeCode').text(getResult.AssetTypeCode);
        }
        $('#Status').val(result.Status);
        $('#txtDate').val(DateFormatter(result.Date));
        $('#txtAgreedDate').val(DateFormatter(result.AgreedDate));
        $('#Reason').val(result.Reason);
        $('#VendorServiceCost').val(result.VendorServicecost);
        // $('#AssetTrackingNo').val(getResult.PorteringNo);
        $("label[for='AssetTrackingNo']").text(result.PorteringNo);
        $('#AssetTrackingAssetNo').val(result.PorteringAssetNo);
        if (result.PorteringNo == null) {
            $('#PorteringDiv').hide();
        }
        else {
            $('#PorteringDiv').show();
        }
        $("#Timestamp").val(result.Timestamp);
        //$('#primaryID').val(result.WorkOrderId);

        CompletionDetails = result.CompletionInfoDets;
        if (CompletionDetails == null) {
            //  PushEmptyMessage();
            $("#CompletionInfoResultId").empty();
            AddNewRow(1);
        }
        else {
            bindDatatoDatagrid(CompletionDetails);
        }
        if (WorkOrderStatusString == " Closed") {
            $("#CompletionAddButton").hide();
            $("#formUnScheduledWorkOrder :input:not(:button)").prop("disabled", true);
            $("#tab-2 :input:not(:button)").prop("disabled", true);
            $("#tab-3 :input:not(:button)").prop("disabled", true);
            $("#tab-4 :input:not(:button)").prop("disabled", true);
            $("#tab-5 :input:not(:button)").prop("disabled", true);
            $("#divCommonAttachment :input:not(:button)").prop("disabled", true);
            $("#PPMCheckList :input:not(:button)").prop("disabled", true);
            $("#aAFAdditionalInfo :input:not(:button)").prop("disabled", true);
            $('#txtEngineer').prop('disabled', true);

            $('#btnCompletionSubmitEdit').hide();
            $('#btnCompletionSave').hide();
            $('#txtMaintainanceDetails').prop('disabled', true);
            $("btnPurchasePopUpSave").hide();
            $("btnAdditionalInfoEdit").hide();
            $('#btnSWOPrint').show();
        }

        $('#errorMsgCompletionInfo').css('visibility', 'hidden');
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
            if (response.status == 400) {
                errorMessage = response.responseJSON;
            }
            else {
                errorMessage = Messages.COMMON_FAILURE_MESSAGE;
            }
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
}

function PushEmptyMessage() {
    $("#CompletionInfoResultId").empty();
    var emptyrow = '<tr><td colspan=7 ><h3> &nbsp;&nbsp;&nbsp;&nbsp; No records to display </h3></td></tr>'
    $("#CompletionInfoResultId ").append(emptyrow);
}

function CompletionGridHtml() {
    return '<tr class="ng-scope" style=""> <td width="3%" data-original-title="" title=""><div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" value="false" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(CompletionInfoResultId,chk_CompletionInfoIsDelete)" tabindex="0"> </label></div></td><td width="19%" style="text-align: center;" data-original-title="" title=""> <div> <div> <input type="text" placeholder="Please select" required id="EmployeeName_maxindexval" autocomplete="off" value="" class="form-control fetchField" onkeyup="Fetchdata(event,maxindexval)" onpaste="Fetchdata(event,maxindexval)" change="Fetchdata(event,maxindexval)" oninput="Fetchdata(event,maxindexval)"> </div><input type="hidden" id="StaffMasterId_maxindexval"/><input type="hidden" id="CompletionInfoDetId_maxindexval"/><input type="hidden" id="hdnCostPerHour_maxindexval" /> <div class="col-sm-12" id="divFetch_maxindexval"></div></div></td><td width="19%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" placeholder="Please select" required id="TaskCode_maxindexval" value="" class="form-control fetchField" autocomplete="off" onkeyup="Fetchdata2(event,maxindexval)" onpaste="Fetchdata2(event,maxindexval)" change="Fetchdata2(event,maxindexval)" oninput="Fetchdata2(event,maxindexval)"> </div><input type="hidden" id="StandardTaskDetId_maxindexval"/> <div class="col-sm-12" id="divFetch2_maxindexval"></div></td><td width="19%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" required id="StartDate_maxindexval" autocomplete="off" value="" class="form-control datatimepickerNoFut"> </div></td><td width="20%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" data-value=" " id="EndDate_maxindexval" onchange="CalculateRepairHours(maxindexval)" value=" "  autocomplete="off" class="form-control datatimepickerNoFut" required> </div></td><td width="20%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" data-value=" " disabled id="PPMHours_maxindexval" value="" class="form-control"> </div></td></tr>';
}

function AddNewRow(param) {
    var _index;
    $('#CompletionInfoResultId tr').each(function () {
        _index = $(this).index();
    });
    var flagAllow = 0;
    for (var i = 0; i <= _index; i++) {
        var StaffMasterId = $("#StaffMasterId_" + i).val();
        var StandardTaskDetId = $("#StandardTaskDetId_" + i).val();
        var StartDate = $("#StartDate_" + i).val();

        if (StaffMasterId && StandardTaskDetId && StartDate) { }
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
        if (_index == undefined) {
            CompletionNewRow();
        }
    }
    formInputValidation("form");
}

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
   



    //$('#FileUploadTable').empty();
    //if (HiddenId != null && HiddenId != "0" && HiddenId != "" && HiddenId != 0) {

    //    $.get("/api/Document/getAttachmentDetails/" + HiddenId)
    //      .done(function (result) {
    //          debugger;
    //          var getResultForTest = JSON.parse(result);
    //          if (getResultForTest != null && getResultForTest.FileUploadList != null && getResultForTest.FileUploadList.length > 0) {
    //              $('#HdnAttachThereOrNot').val(1);
    //          }
    //          else {
    //              $('#HdnAttachThereOrNot').val(0);
    //          }
    //      })

    //    .fail(function (response) {
    //        $('#HdnAttachThereOrNot').val(0);
    //    });

    //}

    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgCompletionInfo').css('visibility', 'hidden');
    $('#txtVerifiedBy').prop('disabled', true);
    $('#txtHandoverDate').prop('disabled', true);

    var primaryId = $('#primaryID').val();
    //if (primaryId == 0 || primaryId == null)
    //{
    //    $('#formScheduledWorkOrder').show();
    //    $('#myPleaseWait').modal('hide');
    //    bootbox.alert("Save the details before moving on to Other!");
    //    return false;
    //}
    if (primaryId != null && primaryId != "0") {
        $.get("/api/ScheduledWorkOrder/GetCompletionInfo/" + primaryId + "/" + pagesize + "/" + pageindex)
            .done(function (result) {
                var htmlval = "";
                var getResult = JSON.parse(result);
                $('#txt_StartDate').text(getResult.StartDate);

                //*********************** ReSchedule Date *****************
                var RescheduleDate = getResult.ReScheduledDate;
                if (RescheduleDate == "0001-01-01T00:00:00") {
                    RescheduleDate = null;
                }
                if (RescheduleDate == null) {
                    $('#txtAgreedDate').val(moment(CompInfoReScheduledDate).format("DD-MMM-YYYY"));
                }
                else {
                    $('#txtAgreedDate').val(moment(RescheduleDate).format("DD-MMM-YYYY"));
                }
                //***************************************************

                if (GlobalRunningHoursCapture != 0) {
                    if (GlobalRunningHoursCapture == 99) {
                        $('#txtRunningHours').prop('required', true);
                        $('#SpanRun').show();
                        $('#txtRunningHours').prop('disabled', false);
                    }
                    else if (GlobalRunningHoursCapture == 100) {
                        $('#txtRunningHours').prop('required', false);
                        $('#SpanRun').hide();
                        $('#txtRunningHours').prop('disabled', true);
                    }
                }

                if (getResult.CompletionInfoId > 0) {
                    $('#txtVerifiedBy').prop('disabled', false);
                    $('#txtHandoverDate').prop('disabled', false);
                    $('#txtVerifiedBy').prop('required', true);
                    $("#lblVerify").html("Verified By <span class='red'>*</span>");
                    $("#lblHanddt").html("Handover Date / Time <span class='red'>*</span>");
                    $('#txtHandoverDate').prop('required', true);

                    $('#btnCompletionSubmitEdit').hide();
                    $('#btnCompletionSave').hide();
                }

                if (getResult.HandOverDate == "0001-01-01T00:00:00") {
                    getResult.HandOverDate = null;
                }
                if (getResult.StartDate == "0001-01-01T00:00:00") {
                    getResult.StartDate = "";
                }
                if (getResult.EndDate == "0001-01-01T00:00:00" || getResult.EndDate == null) {
                    getResult.EndDate = "";
                }
                CompletionInfoId = getResult.CompletionInfoId;
                if (CompletionInfoId != 0) {
                    $('#WorkOrderNo').val(getResult.WorkOrderNo);
                    $('#txtStartDate').val(moment(getResult.StartDate).format("DD-MMM-YYYY HH:mm"));
                    //$('#txt_StartDatess').text(moment(getResult.StartDate).format("DD-MMM-YYYY"));
                    if (getResult.EndDate != "") {
                        $('#txtEndDate').val(moment(getResult.EndDate).format("DD-MMM-YYYY HH:mm"));
                        //$('#txt_EndDatess').text(moment(getResult.EndDate).format("DD-MMM-YYYY"));
                    }

                    $('#hdnCompletedById').val(getResult.CompletedById);
                    $('#txtCompletedBy').val(getResult.CompletedBy);
                    $('#txtCompletedByDesignation').val(getResult.CompletedByDesignation);

                    if (getResult.HandOverDate != null) {
                        $('#txtHandoverDate').val(moment(getResult.HandOverDate).format("DD-MMM-YYYY HH:mm"));
                    }
                    if (getResult.Status == null) {
                        getResult.Status = 0;
                    }
                    if (getResult.CauseCodeDescription == null) {
                        getResult.CauseCodeDescription = 0;
                    }
                    if (getResult.QCDescription == null) {
                        getResult.CauseCodeDescription = 0;
                    }
                    $('#txtRunningHours').val(getResult.RunningHours);
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
                    // $('#txtAgreedDate').val(DateFormatter(getResult.AgreedDate));
                    $('#Reason').val(getResult.Reason);
                    $('#VendorServiceCost').val(getResult.VendorServicecost);
                    // $('#AssetTrackingNo').val(getResult.PorteringNo);
                    $("label[for='AssetTrackingNo']").text(getResult.PorteringNo);
                    $('#AssetTrackingAssetNo').val(getResult.PorteringAssetNo);
                    $('#txt_QCPPMRT').text(getResult.QCCodeFieldVaule);
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
                    // $('#primaryID').val(getResult.WorkOrderId);

                    CompletionDetails = getResult.CompletionInfoDets;
                    if (CompletionDetails == null) {
                        //PushEmptyMessage();
                        $('#CompletionInfoResultId').empty();
                        AddNewRow(1);
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
                }
                if (WorkOrderStatusString == "Completed") {
                    $('#btnCompletionSave').hide();
                    $('#btnCompletionSubmitEdit').show();
                    $('#btnSWOPrint').show();
                }
                else if (WorkOrderStatusString != "Completed") {
                    $('#btnCompletionSave').show();
                    $('#btnCompletionSubmitEdit').hide();
                }
                if (WorkOrderStatusString == " Closed") {

                    $('#btnCompletionSubmitEdit').hide();
                    $("#CompletionAddButton").hide();
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
                    $('#btnCompletionSave').hide();
                    $('#btnEditAttachment').hide();
                    $('#AttachRowPlus').show();
                    $('#btnSWOPrint').show();
                    $("btnPurchasePopUpSave").hide();
                    $("btnAdditionalInfoEdit").hide();

                    $('#txtHandoverDate').attr('disabled', true);
                    $('#txtVerifiedBy').attr('disabled', true);
                }

                if (WorkOrderStatusString != " Closed") {

                    $('#CompletionAddButton').show();
                    //$('#btnCompletionSave').show();
                    $('#btnEditAttachment').show();
                    $('#AttachRowPlus').show();
                    $("btnPurchasePopUpSave").show();
                    $("btnAdditionalInfoEdit").show();

                    //  $('#txtHandoverDate').attr('disabled', false);
                    //  $('#txtVerifiedBy').attr('disabled', false);
                }

                $('#myPleaseWait').modal('hide');
            })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsgCompletionInfo').css('visibility', 'visible');
            });
        $('#txtRunningHours').prop('required', false);
        $("#SpanRun").html("<span class='red'></span>");
    }
    else {
        $('#myPleaseWait').modal('hide');
    }


}

function bindDatatoDatagrid(list) {
    if (list.length > 0) {
        $('#CompletionInfoResultId').empty();
        var html = '';

        $(list).each(function (index, data) {
            data.StartDate = moment(data.StartDate).format("DD-MMM-YYYY HH:mm");
            if (data.EndDate != null) {
                data.EndDate = moment(data.EndDate).format("DD-MMM-YYYY HH:mm");
            }
            if (data.EndDate == null) {
                data.EndDate = "";
            }
            if (data.PPMHours == null) {
                data.PPMHours = "";
            }
            if (data.TaskCode == null) {
                data.TaskCode = "";
            }
            html = '<tr class="ng-scope" style=""> <td width="3%" data-original-title="" title=""> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" onchange="IsDeleteValidation(' + index + ')" id="Isdeleted_' + index + '" autocomplete="off"  tabindex="0" aria-="false" aria-checked="false" aria-invalid="false"> </label> </div></td><td width="19%" style="text-align: center;" data-original-title="" title=""> <div> <div> <input type="text" placeholder="Please select" autocomplete="off" required id="EmployeeName_' + index + '" value="' + data.EmployeeName + '" class="form-control fetchField" onkeyup="Fetchdata(event,' + index + ')" onpaste="Fetchdata(event,' + index + ')" change="Fetchdata(event,' + index + ')" oninput="Fetchdata(event,' + index + ')"> </div><input type="hidden" id="StaffMasterId_' + index + '" value="' + data.StaffMasterId + '"/><input type="hidden" id="CompletionInfoDetId_' + index + '" value="' + data.CompletionInfoDetId + '"/><input type="hidden" id="hdnCostPerHour_' + index + '" /> <div class="col-sm-12" id="divFetch_' + index + '"></div></div></td><td width="19%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" placeholder="Please select" autocomplete="off" required id="TaskCode_' + index + '" value="' + data.TaskCode + '" class="form-control fetchField" onkeyup="Fetchdata2(event,' + index + ')" onpaste="Fetchdata2(event,' + index + ')" change="Fetchdata2(event,' + index + ')" oninput="Fetchdata2(event,' + index + ')"> </div><input type="hidden" id="StandardTaskDetId_' + index + '" value="' + data.StandardTaskDetId + '" /> <div class="col-sm-12" id="divFetch2_' + index + '"></div></td><td width="19%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" required id="StartDate_' + index + '" value="' + data.StartDate + '"  autocomplete="off" class="form-control datatimepickerNoFut"> </div></td><td width="20%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" data-value=" " id="EndDate_' + index + '" onchange="CalculateRepairHours(' + index + ')" value="' + data.EndDate + '"  autocomplete="off" class="form-control datatimepickerNoFut" required> </div></td><td width="20%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" data-value=" " disabled id="PPMHours_' + index + '" value="' + data.PPMHoursTiming + '" class="form-control"> </div></td></tr>';

            $('#CompletionInfoResultId').append(html);
            GridtotalRecords = data.TotalRecords;
            TotalPages = data.TotalPages;
            LastRecord = data.LastRecord;
            FirstRecord = data.FirstRecord;
            pageindex = data.PageIndex;
        });
        var mapIdproperty = ["Isdeleted-Isdeleted_", "StaffMasterId-StaffMasterId_", "CompletionInfoDetId-CompletionInfoDetId_", "EmployeeName-EmployeeName_", "StandardTaskDetId-StandardTaskDetId_", "TaskCode-TaskCode_", "StartDate-StartDate_", "EndDate-EndDate_", "PPMHoursTiming-PPMHours_"];
        var htmltext = CompletionGridHtml();

        id = $('#primaryID').val();
        var obj = { formId: "#tab-2", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "ScheduleCompInfo", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "CompletionInfoDets", tableid: '#CompletionInfoResultId', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/ScheduledWorkOrder/GetCompletionInfo/" + id, pageindex: pageindex, pagesize: pagesize, WorkOrderStatusString: WorkOrderStatusString };

        CreateFooterPagination(obj);
        var _index;
        $('#CompletionInfoResultId tr').each(function () {
            _index = $(this).index();
        });

        if ($('#ActionType').val() == "VIEW") {
            for (var i = 0; i <= _index; i++) {
                $('#EmployeeName_' + i).prop('disabled', true);
                $('#StartDate_' + i).prop('disabled', true);
                $('#TaskCode_' + i).prop('disabled', true);
                $('#EndDate_' + i).prop('disabled', true);
                $('#Isdeleted_' + i).prop('disabled', true);
            }
        }
    }
    else {
        $('#CompletionInfoResultId').empty();
        AddNewRow(1);
    }

    formInputValidation("form");

}

function Fetchdata(event, index) {

    $('#divFetch_' + index).css({
        'top': $('#EmployeeName_' + index).offset().top - $('#dataTableCompletion').offset().top + $('#EmployeeName_' + index).innerHeight(),

    });

    var ItemMst = {
        SearchColumn: 'EmployeeName_' + index + '-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId" + "-Primary Key", 'StaffName' + '-StaffName' + index],//Columns to be displayed
        FieldsToBeFilled: ["StaffMasterId_" + index + "-StaffMasterId", 'EmployeeName_' + index + '-StaffName']//id of element - the model property
    };
    DisplayFetchResult('divFetch_' + index, ItemMst, "/api/Fetch/CompanyStaffFetch", "Ulfetch5" + index, event, 1);
}

function Fetchdata2(event, index) {
    var ItemMst = {
        SearchColumn: 'TaskCode_' + index + '-TaskCode',//Id of Fetch field
        ResultColumns: ["StandardTaskDetId" + "-Primary Key", 'TaskCode' + '-TaskCode' + index],//Columns to be displayed
        FieldsToBeFilled: ["StandardTaskDetId_" + index + "-StandardTaskDetId", 'TaskCode_' + index + '-TaskCode']//id of element - the model property
    };
    DisplayFetchResult('divFetch2_' + index, ItemMst, "/api/Fetch/FetchTaskCode", "Ulfetch6" + index, event, 1);
}

function FetchRescheduleBy(event, index) {
    var ItemMst = {
        SearchColumn: 'RescheduleApprovedBy_' + index + '-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId" + "-Primary Key", 'StaffName' + '-StaffName' + index],//Columns to be displayed
        FieldsToBeFilled: ["hdnRescheduleById_" + index + "-StaffMasterId", 'RescheduleApprovedBy_' + index + '-StaffName']//id of element - the model property
    };
    DisplayFetchResult('divRescheduleByFetch_' + index, ItemMst, "/api/Fetch/CompanyStaffFetch", "Ulfetch10" + index, event, 1);
}


//---------------------------3rd tab-----------------------------------------------

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
            // CostPerUnit: $('#CostPerUnit_' + i).val(),
            CostPerUnit: null,
            PopUpQuantityAvailable: $('#PQV_' + i).val(),
            PopUpQuantityTaken: $('#PQT_' + i).val(),
            LabourCost: $('#LabourCost_' + i).val(),
            PartReplacementCostInvolved: $('#PartReplacementCostInvolved').val(),
            PartReplacementCost: $('#PartReplacementCost').val(),
            AverageUsageHours: $('#AverageUsageHours').val(),
            IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
            EstimatedLifeSpan: $('#EstimatedLifeSpan_' + i).val(),
            EstimatedLifeSpanDate: $('#LifeSpanExpiryDate_' + i).val(),
            StockType: $('#StockType_' + i).val(),
            PartReplacementCost: $('#TotalCost_' + i).val(),
        };

        if ((obj.PartReplacementCost == '' || obj.PartReplacementCost == 0 || obj.PartReplacementCost == null) && (obj.IsDeleted == false)) {
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
    //var _Mainindex;
    //$('#PartReplacementResultId tr').each(function () {
    //    _Mainindex = $(this).index();
    //});
    //for (var i = 0; i <= _Mainindex ; i++) {
    //    if ($("#StockType_" + i).val() == "On Demand") {
    //        bootbox.alert("You need to purchase the part!")
    //        break;
    //    }
    //}

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
        if (result.PartReplacementDets != null && result.PartReplacementDets.length > 0) {
            // $('#PartReplacementCost').val(result.PartReplacementDets[0].ScheduleTotalCost == 0 ? '' : result.PartReplacementDets[0].ScheduleTotalCost);
            //$('#PartReplacementCost').val(result.ScheduleTotalCost == 0 ? '' : result.ScheduleTotalCost);
        }

        //$('#TotalSparePartCost').val(result.TotalSparePartCost);
        $('#PartReplacementCost').val(result.ScheduleTotalCost);
        $('#TotalLabourCost').val(result.ScheduleTotalLabourCost == 0 ? '' : result.ScheduleTotalLabourCost);
        $('#Totalvendorcost').val(result.TotalVendorCost == 0 ? '' : result.TotalVendorCost);
        $('#TotalCost').val(result.ScheduleTotalCost == 0 ? '' : result.ScheduleTotalCost);
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

        if ($('#ActionType').val() != "VIEW" && hasApproveRolePermission != true) {
            $('#CostHide').hide();

            $('#TotalCostSingleHide').hide();
            // $('#LabourCostHide').hide();
            $('#TotalCostHide').hide();

            var _index;
            $('#PartReplacementResultId tr').each(function () {
                _index = $(this).index();
            });

            for (var i = 0; i <= _index; i++) {
                $('#CostColumn1_' + i).hide();
                //  $('#CostColumn2_' + i).hide();
                $('#CostColumn3_' + i).hide();
                //  $('#LabourCost_' + i).prop('required', false);
                $("#QuantityPopUp_" + i).hide();
            }
        }

        if ($('#ActionType').val() == "VIEW") {
            $('#CostHide').hide();

            $('#TotalCostSingleHide').hide();
            // $('#LabourCostHide').hide();
            $('#TotalCostHide').hide();

            var _index;
            $('#PartReplacementResultId tr').each(function () {
                _index = $(this).index();
            });

            for (var i = 0; i <= _index; i++) {
                $('#CostColumn1_' + i).hide();
                // $('#CostColumn2_' + i).hide();
                $('#CostColumn3_' + i).hide();
                // $('#LabourCost_' + i).prop('required', false);
            }
        }

        $('#chk_PartReplacementIsDelete').prop('checked', false);

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
            if (response.status == 400) {
                errorMessage = response.responseJSON;
            }
            else {
                errorMessage = Messages.COMMON_FAILURE_MESSAGE;
            }
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

function GetPartReplacement() {
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgPart').css('visibility', 'hidden');

    //var sts = $('#hdnWoSts').val();
    //$('#divWOStatus').text(sts);
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
                $('#PartAssetNo').val(GlobalAssetNo);
                $('#PartAssetNoCost').val(GlobalAssetNoCost);
                // $('#TotalSparePartCost').val(getResult.TotalSparePartCost);
                if (getResult.ScheduleTotalLabourCost != null) {
                    $('#TotalLabourCost').val(getResult.ScheduleTotalLabourCost == 0 ? '' : addCommas(getResult.ScheduleTotalLabourCost));
                }
                else {
                    $('#TotalLabourCost').val(getResult.ScheduleTotalLabourCost);
                }
                if (getResult.ScheduleTotalCost != null) {
                    $('#TotalCost').val(getResult.ScheduleTotalCost == 0 ? '' : addCommas(getResult.ScheduleTotalCost));
                }
                else {
                    $('#TotalCost').val(getResult.ScheduleTotalCost);
                }
                if (getResult.ScheduleTotalCost != null) {
                    $('#PartReplacementCost').val(getResult.ScheduleTotalCost == 0 ? '' : addCommas(getResult.ScheduleTotalCost));
                }
                else {
                    $('#PartReplacementCost').val(getResult.ScheduleTotalCost);
                }
                if (getResult.TotalVendorCost != null) {
                    $('#Totalvendorcost').val(getResult.TotalVendorCost == 0 ? '' : addCommas(getResult.TotalVendorCost));
                }
                else {
                    $('#Totalvendorcost').val(getResult.TotalVendorCost);
                }
                //   $('#TotalSparePartCost').val(getResult.TotalSparePartCost);
                //  $('#TotalLabourCost').val(getResult.ScheduleTotalLabourCost);
                //   $('#TotalCost').val(getResult.ScheduleTotalCost);
                //  $('#Totalvendorcost').val(getResult.TotalVendorCost);
                //$('#divWOStatus').text(getResult.WorkOrderStatusValue);

                //$('#primaryID').val(getResult.WorkOrderId);

                PartReplacementDetails = getResult.PartReplacementDets;
                if (PartReplacementDetails == null) {
                    $('#PartWorkOrderNo').val(GlobalWorkOrderNo);
                    $('#PartWorkOrderDate').val(moment(GlobalWorkOrderDate).format("DD-MMM-YYYY HH:mm"));
                    $('#PartAssetNo').val(GlobalAssetNo);
                    $('#PartAssetNoCost').val(GlobalAssetNoCost);
                    $("#PartReplacementResultId").empty();
                    AddPartReplacementNewRow();
                    //PartReplacementPushEmptyMessage();
                    //var rowCount = $('#PartReplacementResultId tr:last').index();
                    //$.each(window.StockTypeListGloabal, function (index, value) {
                    //    $('#StockType_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                    //});
                }
                else {
                    var tempUsageHours = PartReplacementDetails[0].AverageUsageHours;
                    var tempInvolved = PartReplacementDetails[0].PartReplacementCostInvolved;
                    var tempCost = PartReplacementDetails[0].PartReplacementCost;
                    if (tempInvolved == 0)
                        tempInvolved = 100;
                    $('#AverageUsageHours').val(tempUsageHours);
                    $('#PartReplacementCostInvolved').val(tempInvolved);
                    //$('#PartReplacementCost').val(tempCost == 0 ? '' : tempCost);
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
                        $('#EstimatedLifeSpan_' + i).attr('disabled', true);

                        var LabourCost = $("#LabourCost_" + i).val();
                        LabourCost = (LabourCost == "0") ? "" : LabourCost;
                    }
                }
                CostChange();
                if ($('#ActionType').val() != "VIEW" && hasApproveRolePermission != true) {
                    $('#CostHide').hide();

                    $('#TotalCostSingleHide').hide();
                    // $('#LabourCostHide').hide();
                    $('#TotalCostHide').hide();

                    var _index;
                    $('#PartReplacementResultId tr').each(function () {
                        _index = $(this).index();
                    });

                    if (PartReplacementDetails == null) {
                        for (var i = 0; i <= _index; i++) {
                            $('#CostColumn1_' + i).hide();
                            //  $('#CostColumn2_' + i).hide();
                            $('#CostColumn3_' + i).hide();
                            //  $('#LabourCost_' + i).prop('required', false);
                        }
                    }
                    else {
                        for (var i = 0; i <= _index; i++) {
                            $('#CostColumn1_' + i).hide();
                            //  $('#CostColumn2_' + i).hide();
                            $('#CostColumn3_' + i).hide();
                            //  $('#LabourCost_' + i).prop('required', false);
                            $("#QuantityPopUp_" + i).hide();
                        }
                    }
                }

                if ($('#ActionType').val() == "VIEW") {
                    $('#CostHide').hide();

                    $('#TotalCostSingleHide').hide();
                    //  $('#LabourCostHide').hide();
                    $('#TotalCostHide').hide();

                    var _index;
                    $('#PartReplacementResultId tr').each(function () {
                        _index = $(this).index();
                    });

                    for (var i = 0; i <= _index; i++) {
                        $('#CostColumn1_' + i).hide();
                        // $('#CostColumn2_' + i).hide();
                        $('#CostColumn3_' + i).hide();
                        // $('#LabourCost_' + i).prop('required', false);
                    }
                }
                if (WorkOrderStatusString == " Closed") {

                    var _index;
                    $('#PartReplacementResultId tr').each(function () {
                        _index = $(this).index();
                    });

                    for (var i = 0; i <= _index; i++) {
                        $('#PartNo_' + i).prop('disabled', true);
                        $('#Isdeleted_' + i).prop('disabled', true);
                        $('#EstimatedLifeSpan_' + i).prop('disabled', true);
                        $('#LifeSpanExpiryDate_' + i).prop('disabled', true);
                        $('#StockType_' + i).prop('disabled', true);
                    }
                    $('#PartAddButton').hide();
                    $('#btnEditAttachment').hide();
                    $('#AttachRowPlus').show();
                    $("btnPurchasePopUpSave").hide();
                    $("btnAdditionalInfoEdit").hide();
                    $('#btnSWOPrint').show();
                    $('#btnPartSave').hide();

                }
                if (WorkOrderStatusString != " Closed") {

                    $('#PartAddButton').show();
                    $('#btnEditAttachment').show();
                    $('#AttachRowPlus').show();
                    $("btnPurchasePopUpSave").show();
                    $("btnAdditionalInfoEdit").show();
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

    var sts = $('#hdnWoSts').val();
    $('.divWOStatus').text(sts);
}

//Tab 3 Grid Functions
function PartReplacementNewRow() {

    var inputpar = {
        inlineHTML: PartReplacementGridHtml(),//Inline Html
        TargetId: "#PartReplacementResultId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);

    BindEventsForLifespan();
}

function PartReplacementPushEmptyMessage() {
    $("#PartReplacementResultId").empty();
    var emptyrow = '<tr><td colspan=8 ><h3> &nbsp;&nbsp;&nbsp;&nbsp; No records to display </h3></td></tr>'
    $("#PartReplacementResultId ").append(emptyrow);
}

function PartReplacementGridHtml() {

    //return '<tr class="ng-scope" style=""> <td width="1%" data-original-title="" title=""> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" value="false" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(PartReplacementResultId,chk_PartReplacementIsDelete)" tabindex="0"> </label> </div></td><td width="5%" style="text-align: center;" data-original-title="" title=""> <div> <div> <input type="text" placeholder="Please select" required id="PartNo_maxindexval" autocomplete="off" value="" class="form-control fetchField" onkeyup="FetchdataPartNo(event,maxindexval)" onpaste="FetchdataPartNo(event,maxindexval)" change="FetchdataPartNo(event,maxindexval)" oninput="FetchdataPartNo(event,maxindexval)"> </div><input type="hidden" id="SparePartStockRegisterId_maxindexval"/> <input type="hidden" id="PartReplacementId_maxindexval"/> <input type="hidden" id="StockUpdateDetId_maxindexval"/> <div class="col-sm-12" id="divFetchPart_maxindexval"></div></div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled id="PartDescription_maxindexval" value="" class="form-control fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" maxlength="5" id="EstimatedLifeSpan_maxindexval" disabled value="" class="form-control text-right fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="hidden" id="hdnLifeSpanOptionId_maxindexval" value=""/> <input type="text" disabled id="LifeSpanOption_maxindexval" value="" class="form-control fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" id="LifeSpanExpiryDate_maxindexval" disabled value="" class="form-control datetimeNoFuture"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <select class="form-control" required id="StockType_maxindexval" name="StockType"></select> </div></td><td width="11%" style="text-align: center;" data-original-title="" title=""> <div class="col-sm-8"> <input type="text" disabled data-value=" " id="Quantity_maxindexval" value=" " class="form-control"> </div><div class="col-sm-0"> <a data-toggle="modal" class="btn btn-sm btn-primary btn-info btn-lg" id="QuantityPopUp_maxindexval" onclick="GetQuantityPopupdetails(maxindexval)" title="Real Time History" tabindex="0" data-target="#myModalquantity"> <span class="glyphicon glyphicon-modal-window"></span> </a> </div></td><td width="10%" id="CostColumn1_maxindexval" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" data-value=" " disabled id="CostPerUnit_maxindexval" value="" class="form-control"> </div></td><td id="CostColumn3_maxindexval" width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" data-value=" " disabled id="TotalCost_maxindexval" value="" class="form-control"> </div></td></tr>';
    return '<tr class="ng-scope" style=""> <td width="1%" data-original-title="" title=""> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" value="false" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(PartReplacementResultId,chk_PartReplacementIsDelete)" tabindex="0"> </label> </div></td><td width="5%" style="text-align: center;" data-original-title="" title=""> <div> <div> <input type="text" placeholder="Please select" required id="PartNo_maxindexval" autocomplete="off" value="" class="form-control fetchField" onkeyup="FetchdataPartNo(event,maxindexval)" onpaste="FetchdataPartNo(event,maxindexval)" change="FetchdataPartNo(event,maxindexval)" oninput="FetchdataPartNo(event,maxindexval)"> </div><input type="hidden" id="SparePartStockRegisterId_maxindexval"/> <input type="hidden" id="PartReplacementId_maxindexval"/> <input type="hidden" id="StockUpdateDetId_maxindexval"/> <div class="col-sm-12" id="divFetchPart_maxindexval"></div></div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled id="PartDescription_maxindexval" value="" class="form-control fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" maxlength="5" id="EstimatedLifeSpan_maxindexval" disabled value="" class="form-control text-right fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="hidden" id="hdnLifeSpanOptionId_maxindexval" value=""/> <input type="text" disabled id="LifeSpanOption_maxindexval" value="" class="form-control fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" id="LifeSpanExpiryDate_maxindexval" disabled value="" class="form-control datetimeNoFuture"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <select class="form-control" required id="StockType_maxindexval" name="StockType"></select> </div></td><td width="20%" style="text-align: center;" data-original-title="" title=""> <div class="col-sm-8"> <input type="text" disabled data-value=" " id="Quantity_maxindexval" value=" " class="form-control"> </div><div class="col-sm-0"> <a data-toggle="modal" class="btn btn-sm btn-primary btn-info btn-lg" id="QuantityPopUp_maxindexval" onclick="GetQuantityPopupdetails(maxindexval)" title="Real Time History" tabindex="0" data-target="#myModalquantity"> <span class="glyphicon glyphicon-modal-window"></span> </a> </div></td><td id="CostColumn3_maxindexval" width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="hidden" data-value=" "  id="PQT_maxindexval" value="" class="form-control"> <input type="hidden" data-value=" "  id="PQV_maxindexval" value="" class="form-control"> <input type="text" data-value=" " disabled id="TotalCost_maxindexval" value="" class="form-control"> </div></td></tr>';

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
        //LabourCost = (LabourCost == "0") ? "" : LabourCost;
        if ($('#ActionType').val() != "VIEW" && hasApproveRolePermission == true) {
            if (SparePartStockRegisterId) { }
            else
                flagAllow++;
        }
        else {
            if (SparePartStockRegisterId) { }
            else
                flagAllow++;
        }

    }
    if (flagAllow != 0) {
        bootbox.alert("Please enter data for existing rows");
        return;

    }
    PartReplacementNewRow();
    //var tempvar = parseInt(_index) + 1;
    //$("#QuantityPopUp_" + tempvar).hide();

    if ($('#ActionType').val() != "VIEW" && hasApproveRolePermission != true) {
        $('#CostHide').hide();

        $('#TotalCostSingleHide').hide();
        // $('#LabourCostHide').hide();
        $('#TotalCostHide').hide();

        var _index;
        $('#PartReplacementResultId tr').each(function () {
            _index = $(this).index();
        });

        for (var i = 0; i <= _index; i++) {
            $('#CostColumn1_' + i).hide();
            //   $('#CostColumn2_' + i).hide();
            $('#CostColumn3_' + i).hide();
            //  $('#LabourCost_' + i).prop('required', false);           
        }

    }

    var rowCount = $('#PartReplacementResultId tr:last').index();
    $.each(window.StockTypeListGloabal, function (index, value) {
        $('#StockType_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });

    $('#chk_PartReplacementIsDelete').prop('checked', false);

    formInputValidation("form");
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
            //    $('#StockType_' + index).append('<option value="' + _data.LovId + '">' + _data.FieldValue + '</option>');

            //});
            //$('#StockType_' + index).val(data.StockType);

            //html = '<tr class="ng-scope" style=""> <td width="2%" data-original-title="" title=""> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" onchange="IsDeleteValidation(' + index + ')" id="Isdeleted_' + index + '" autocomplete="off" tabindex="0" aria-="false" aria-checked="false" aria-invalid="false"> </label> </div></td><td width="14%" style="text-align: center;" data-original-title="" title=""> <div> <div> <input type="text" disabled placeholder="Please select" required id="PartNo_' + index + '" value="' + data.PartNo + '" autocomplete="off" class="form-control fetchField" onkeyup="FetchdataPartNo(event,' + index + ')" onpaste="FetchdataPartNo(event,' + index + ')" change="FetchdataPartNo(event,' + index + ')" oninput="FetchdataPartNo(event,' + index + ')"> </div><input type="hidden" id="SparePartStockRegisterId_' + index + '" value="' + data.SparePartStockRegisterId + '"/><input type="hidden" id="PartReplacementId_' + index + '" value="' + data.PartReplacementId + '"/> <input type="hidden" id="StockUpdateDetId_' + index + '" value ="' + data.StockUpdateDetId + '"/> <div class="col-sm-12" id="divFetchPart_' + index + '"></div></div></td><td width="14%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled id="PartDescription_' + index + '" value="' + data.PartDescription + '" class="form-control fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" maxlength="5" disabled id="EstimatedLifeSpan_' + index + '" disabled value="' + data.EstimatedLifeSpan + '" class="form-control text-right fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div>'
            //+ '<input type="hidden" id="hdnLifeSpanOptionId_' + index + '" value="' + data.LifeSpanOptionId + '" />'
            //+' <input type="text" disabled id="LifeSpanOption_' + index + '" value="' + data.EstimatedLifeSpanOption + '" class="form-control fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" id="LifeSpanExpiryDate_' + index + '" disabled value="' + data.EstimatedLifeSpanDate + '" class="form-control datetimeNoFuture" > </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div><select class="form-control" required id="StockType_' + index + '" name="StockType"></select> </div></td><td width="14%" style="text-align: center;" data-original-title="" title=""> <div class="col-sm-8"> <input type="text" disabled data-value=" " id="Quantity_' + index + '" value="' + data.Quantity + ' " class="form-control"> </div> <div class="col-sm-0"><a data-toggle="modal" class="btn btn-sm btn-primary btn-info btn-lg" id="QuantityPopUp_' + index + '" onclick="GetQuantityPopupdetails(' + index + ')" title="Real Time History" tabindex="0" data-target="#myModalquantity"> <span class="glyphicon glyphicon-modal-window"></span> </a></div></td><td id="CostColumn1_' + index + '" width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" data-value=" " disabled id="CostPerUnit_' + index + '" value="' + data.CostPerUnit + '" class="form-control"> </div></td><td id="CostColumn3_' + index + '" width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" data-value=" " disabled id="TotalCost_' + index + '" value="' + data.TotalCost + '" class="form-control"> </div></td></tr>';
            html = '<tr class="ng-scope" style=""> <td width="2%" data-original-title="" title=""> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" onchange="IsDeleteValidation(' + index + ')" id="Isdeleted_' + index + '" autocomplete="off" tabindex="0" aria-="false" aria-checked="false" aria-invalid="false"> </label> </div></td><td width="14%" style="text-align: center;" data-original-title="" title=""> <div> <div> <input type="text" disabled placeholder="Please select" required id="PartNo_' + index + '" value="' + data.PartNo + '" autocomplete="off" class="form-control fetchField" onkeyup="FetchdataPartNo(event,' + index + ')" onpaste="FetchdataPartNo(event,' + index + ')" change="FetchdataPartNo(event,' + index + ')" oninput="FetchdataPartNo(event,' + index + ')"> </div><input type="hidden" id="SparePartStockRegisterId_' + index + '" value="' + data.SparePartStockRegisterId + '"/><input type="hidden" id="PartReplacementId_' + index + '" value="' + data.PartReplacementId + '"/> <input type="hidden" id="StockUpdateDetId_' + index + '" value ="' + data.StockUpdateDetId + '"/> <div class="col-sm-12" id="divFetchPart_' + index + '"></div></div></td><td width="14%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled id="PartDescription_' + index + '" value="' + data.PartDescription + '" class="form-control fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" maxlength="5" disabled id="EstimatedLifeSpan_' + index + '" disabled value="' + data.EstimatedLifeSpan + '" class="form-control text-right fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div>'
                + '<input type="hidden" id="hdnLifeSpanOptionId_' + index + '" value="' + data.LifeSpanOptionId + '" />'
                + ' <input type="text" disabled id="LifeSpanOption_' + index + '" value="' + data.EstimatedLifeSpanOption + '" class="form-control fetchField"> </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" id="LifeSpanExpiryDate_' + index + '" disabled value="' + data.EstimatedLifeSpanDate + '" class="form-control datetimeNoFuture" > </div></td><td width="10%" style="text-align: center;" data-original-title="" title=""> <div><select class="form-control" required id="StockType_' + index + '" name="StockType"></select> </div></td><td width="20%" style="text-align: center;" data-original-title="" title=""> <div class="col-sm-8"> <input type="text" disabled data-value=" " id="Quantity_' + index + '" value="' + data.Quantity + ' " class="form-control"> </div> <div class="col-sm-0"><a data-toggle="modal" class="btn btn-sm btn-primary btn-info btn-lg" id="QuantityPopUp_' + index + '" onclick="GetQuantityPopupdetails(' + index + ')" title="Real Time History" tabindex="0" data-target="#myModalquantity"> <span class="glyphicon glyphicon-modal-window"></span> </a></div></td><td id="CostColumn3_' + index + '" width="10%" style="text-align: center;" data-original-title="" title=""> <div><input type="hidden" data-value=" " disabled id="PQT_' + index + '" value="' + data.popUpQuantityTaken + '" class="form-control"> <input type="hidden" data-value=" " disabled id="PQV_' + index + '" value="' + data.PopUpQuantityAvailable + '" class="form-control"><input type="text" data-value=" " disabled id="TotalCost_' + index + '" value="' + data.PartReplacementCost + '" class="form-control"> </div></td></tr>';

            $('#PartReplacementResultId').append(html);

            BindEventsForLifespan();

            if (data.IsDeleted == true) {
                $('#Isdeleted_' + index + '').prop('checked', true);
            }

            GridtotalRecords = data.TotalRecords;
            TotalPages = data.TotalPages;
            LastRecord = data.LastRecord;
            FirstRecord = data.FirstRecord;
            pageindex = data.PageIndex;
            //$('#StockType_' + index + ' option[value="' + data.StockType + '"]').prop('selected', true);
            if (data.StockType == 37)
                $('#StockType_' + index).empty().append('<option value="' + data.StockType + '">Inventory</option>').prop('disabled', true);
            if (data.StockType == 38)
                $('#StockType_' + index).empty().append('<option value="' + data.StockType + '">On Demand</option>').prop('disabled', true);

            //$('#StockType_' + index).val(data.StockType);
        });
        var mapIdproperty = ["Isdeleted-Isdeleted_", "SparePartStockRegisterId-SparePartStockRegisterId_", "PartReplacementId-PartReplacementId_", "StockUpdateDetId-StockUpdateDetId_", "PartNo-PartNo_", "PartDescription-PartDescription_", , "EstimatedLifeSpan-EstimatedLifeSpan_", "StockType-StockType_", "Quantity-Quantity_", "LabourCost-LabourCost_", "PartReplacementCost-TotalCost_", "PopUpQuantityAvailable-PQV_", "PopUpQuantityTaken-PQT_"];
        var htmltext = PartReplacementGridHtml();

        id = $('#primaryID').val();
        var obj = { formId: "#tab-3", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "PartReplacementDets", tableid: '#PartReplacementResultId', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/ScheduledWorkOrder/GetPartReplacement/" + id, pageindex: pageindex, pagesize: pagesize };

        CreateFooterPagination(obj);
    }
    var _index;
    $('#PartReplacementResultId tr').each(function () {
        _index = $(this).index();
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
    // $('#StockType_' + rowCount)
    formInputValidation("form");

}

function FetchdataPartNo(event, index) {
    $('#divFetchPart_' + index).css({
        'top': $('#PartNo_' + index).offset().top - $('#dataTableCheckList').offset().top + $('#PartNo_' + index).innerHeight(),
        //'width': $('#partno_' + index).outerWidth()
    });
    var ItemMst = {
        SearchColumn: 'PartNo_' + index + '-PartNo',//Id of Fetch field
        ResultColumns: ["SparePartsId" + "-Primary Key", 'Partno' + '-Partno' + index, 'PartDescription' + '-PartDescription' + index, 'EstimatedLifeSpanOption' + '-EstimatedLifeSpanOption' + index],//Columns to be displayed
        FieldsToBeFilled: ["SparePartStockRegisterId_" + index + "-SparePartsId", 'PartNo_' + index + '-Partno', 'PartDescription_' + index + '-PartDescription', 'hdnLifeSpanOptionId_' + index + '-LifeSpanOptionId', 'LifeSpanOption_' + index + '-EstimatedLifeSpanOption', 'ItemNo_' + index + '-ItemCode', 'ItemDescription_' + index + '-ItemDescription']//id of element - the model property
    };
    DisplayFetchResult('divFetchPart_' + index, ItemMst, "/api/Fetch/FetchItemMstdetais", "Ulfetch7" + index, event, 1);

}
//function Isshowpopup(index) {
//    var PartId = $('#SparePartStockRegisterId_' + index).val();
//    if(PartId!="")
//        $("#QuantityPopUp_" + index).show();
//}

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
    var PartId = $('#SparePartStockRegisterId_' + element).val(); // PartReplacementDetails[element].SparePartStockRegisterId;
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

                    if (status == " Closed") {

                        $('#btnPartPopUpSave').hide();
                        $('#btnCompletionSubmitEdit').hide();
                        $('[id^=PopUpSelected_]').attr('disabled', true);
                    } else {
                        if (_index != undefined) {
                            $('#btnPartPopUpSave').show();
                        }
                        $('[id^=PopUpSelected_]').attr('disabled', false);
                    }

                    $('#myPleaseWait').modal('hide');
                    $("div.errormsgcenter").css("");
                    $('#errorMsgPart').css('visibility', 'hidden');
                    //  $('#errorMsgPart').hide();
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
    return ' <tr> <td width="12%" style="text-align: center;" title="Part No"> <div> <div> <input type="text" class="form-control" id="PopUpPartNo_maxindexval" disabled><input type="hidden" id="PopUpStockUpdateDetId_maxindexval"/><input type="hidden" id="PopUpSparePartStockregId_maxindexval"/> </div></div></td><td width="16%" style="text-align: center;" title="Part Description"> <div> <input type="text" class="form-control" id="PopUpPartDescription_maxindexval" disabled> </div></td><td  width="13%" style="text-align: center;" title="Quantity"> <div> <input type="text" class="form-control" id="PopUpQuantityAvailable_maxindexval" disabled> </div></td><td width="13%" style="text-align: center;" title="Cost (Currency)"> <div> <input type="text" class="form-control" id="PopUpCostPerUnit_maxindexval" disabled> </div></td><td width="12%" style="text-align: center;" title="Purchase Cost"> <div> <input type="text" class="form-control" id="PopUpInvoiceNo_maxindexval" disabled> </div></td><td width="15%" style="text-align: center;" title="Invoice No"> <div> <input type="text" class="form-control" id="PopUpVendorName_maxindexval" disabled> </div></td><td width="13%" style="text-align: center;" title="Vendor Name"> <div> <input type="text" class="form-control digOnly Zerofirst text-right" pattern="^((?!(0))[0-9]{1,15})$" maxlength="8" id="PopUpQuantityTaken_maxindexval" disabled> </div></td><td width="5%" data-original-title="" title=""> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" id="PopUpSelected_maxindexval" onclick="DisableSelected(maxindexval)" autocomplete="off" tabindex="0" aria-="false" aria-checked="false" aria-invalid="false"> </label> </div></td></tr> '
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


    //var isFormValid = formInputValidation("PurchaseModal", 'save');
    //if (!isFormValid) {
    //    $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
    //    $('#errorMsgPurchase').css('visibility', 'visible');

    //    $('#btnlogin').attr('disabled', false);
    //    $('#myPleaseWait').modal('hide');
    //    return false;
    //}


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
            //CostPerUnit: $('#CostPerUnit_' + j).val(),
            CostPerUnit: null,
            // LabourCost: $('#LabourCost_' + j).val(),
            PartReplacementCost: $('#TotalCost_' + j).val(),
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
        var IsTrue = 0;
        var totalSparePartsCost = 0;
        for (var m = 0; m < ArrayCount; m++) {
            SumOfQuantity = parseInt(SumOfQuantity) + parseInt(resultList[m].PopUpQuantityTaken);
            var popUpQuantityava = resultList[m].PopUpQuantityAvailable == null ? 0 : parseInt(resultList[m].PopUpQuantityAvailable);
            var popUpCostPerUnit = resultList[m].PopUpCostPerUnit == null ? 0 : parseInt(resultList[m].PopUpCostPerUnit);
            var popUpQuantityTaken = resultList[m].PopUpQuantityTaken == null ? 0 : parseInt(resultList[m].PopUpQuantityTaken);
            if (resultList[m].PopUpQuantityTaken == "") {
                popUpQuantityTaken = 0;
            }
            totalSparePartsCost += popUpCostPerUnit * popUpQuantityTaken;
            pqvq = popUpQuantityava;
            pqvt = popUpQuantityTaken;
        }
        if (ArrayCount > 0) {

            MainresultList[MainArrayCount - 1].SparePartStockRegisterId = MainresultList[MainArrayCount - 1].SparePartStockRegisterId;
            MainresultList[MainArrayCount - 1].PartReplacementId = MainresultList[MainArrayCount - 1].PartReplacementId;
            MainresultList[MainArrayCount - 1].PartNo = MainresultList[MainArrayCount - 1].PartNo;
            MainresultList[MainArrayCount - 1].PartDescription = MainresultList[MainArrayCount - 1].PartDescription;
            MainresultList[MainArrayCount - 1].ItemNo = MainresultList[MainArrayCount - 1].ItemNo;
            MainresultList[MainArrayCount - 1].ItemDescription = MainresultList[MainArrayCount - 1].ItemDescription;
            MainresultList[MainArrayCount - 1].StockUpdateDetId = resultList[0].StockUpdateDetId;
            MainresultList[MainArrayCount - 1].EstimatedLifeSpan = MainresultList[MainArrayCount - 1].EstimatedLifeSpan;
            MainresultList[MainArrayCount - 1].EstimatedLifeSpanDate = MainresultList[MainArrayCount - 1].EstimatedLifeSpanDate;
            MainresultList[MainArrayCount - 1].EstimatedLifeSpanOption = MainresultList[MainArrayCount - 1].EstimatedLifeSpanOption;
            MainresultList[MainArrayCount - 1].Quantity = SumOfQuantity; //resultList[0].PopUpQuantityTaken;
            MainresultList[MainArrayCount - 1].CostPerUnit = resultList[0].PopUpCostPerUnit;
            MainresultList[MainArrayCount - 1].InvoiceNo = resultList[0].PopUpInvoiceNo;
            MainresultList[MainArrayCount - 1].VendorName = resultList[0].PopUpVendorName;
            MainresultList[MainArrayCount - 1].PartReplacementCost = totalSparePartsCost;
            MainresultList[MainArrayCount - 1].PopUpQuantityAvailable = pqvq;
            MainresultList[MainArrayCount - 1].popUpQuantityTaken = pqvt;
        }
        for (var n = 0; n < ArrayCount; n++) {
            var QtyAvailable = parseInt(resultList[n].PopUpQuantityAvailable);
            var QtyTaken = parseInt(resultList[n].PopUpQuantityTaken);
            if (QtyAvailable < QtyTaken) {
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
                //$('#LabourCostHide').hide();
                $('#TotalCostHide').hide();

                var _index;
                $('#PartReplacementResultId tr').each(function () {
                    _index = $(this).index();
                });

                for (var i = 0; i <= _index; i++) {
                    $('#CostColumn1_' + i).hide();
                    // $('#CostColumn2_' + i).hide();
                    $('#CostColumn3_' + i).hide();
                    // $('#LabourCost_' + i).prop('required', false);
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

$("#btnTransferSave,#btnTransferEdit").click(function () {

    var AssignedPersonHiddenValue = $('#hdnTransferAssignedPersonId').val();
    var AssignedPersonValue = $('#TransferAssignedPerson').val();


    if (AssignedPersonValue != "" && AssignedPersonHiddenValue == "") {
        bootbox.alert("Valid Assigned Person required!");
        return false;
    }

    var TypeCodeHiddenValue = $('#hdnAssetTypeCodeId').val();
    var TypeCodeValue = $('#txtAssetTypeCode').val();

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
        TransferReason: 0,
        WOTransferId: WOTransferId,
        Timestamp: Timestamp,
        WorkOrderCategory: 187,
        WorkOrderNo: $('#txtWorkOrderNo').val()

    };


    var jqxhr = $.post("/api/ScheduledWorkOrder/AddTransfer", obj, function (response) {
        var getResult = JSON.parse(response);
        WOTransferId = getResult.WOTransferId;
        $('#TransferAssetNo').val(getResult.TransferAssetNo);
        $('#TransferAssetDescription').val(getResult.TransferAssetDescription);
        $('#TransferOldAssignedPerson').val(GlobalAssignee);
        $('#TransferTypeCode').val(getResult.TransferTypeCode);
        $('#TransferService').val(getResult.TransferService);
        $('#TransferAssignedPerson').val(getResult.TransferAssignedPerson);
        $('#hdnTransferAssignedPersonId').val(getResult.TransferAssignedPersonId);
        $('#primaryID').val(getResult.WorkOrderId);
        $('#Timestamp').val(getResult.Timestamp);
        $('#divWOStatus').text(getResult.WorkOrderStatusValue);
        TransferDetails = getResult.TransferDets;
        if (TransferDetails == null) {
            //TransferDetailsPushEmptyMessage();
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

function GetTransfer() {
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgTransfer').css('visibility', 'hidden');

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/ScheduledWorkOrder/GetTransfer/" + primaryId + "/" + pagesize + "/" + pageindex)
            .done(function (result) {
                var htmlval = "";
                var getResult = JSON.parse(result);
                if (getResult.StartDate == "0001-01-01T00:00:00")
                    getResult.StartDate = "";
                if (getResult.EndDate == "0001-01-01T00:00:00")
                    getResult.EndDate = "";
                if (getResult.TransferAssetNo == null)
                    getResult.TransferAssetNo = GlobalAssetNo;
                if (getResult.TransferAssetDescription == null)
                    getResult.TransferAssetDescription = GlobalAssetDescription;
                WOTransferId = getResult.WOTransferId;
                $('#TransferAssetNo').val(getResult.TransferAssetNo);
                $('#TransferAssetDescription').val(getResult.TransferAssetDescription);
                $('#TransferOldAssignedPerson').val(GlobalAssignee);
                $('#TransferTypeCode').val(getResult.TransferTypeCode);
                $('#TransferService').val(getResult.TransferService);
                $('#TransferAssignedPerson').val(getResult.TransferAssignedPerson);
                $('#hdnTransferAssignedPersonId').val(getResult.TransferAssignedPersonId);
                // $('#primaryID').val(getResult.WorkOrderId);
                $('#Timestamp').val(getResult.Timestamp);
                //$('.divWOStatus').text(getResult.WorkOrderStatusValue);
                var status = $('#divWOStatus').text();
                if (status == " Closed") {
                    $('#btnCompletionSubmitEdit').hide();
                    $('#btnTransferSave').hide();
                } else {
                    $('#btnTransferSave').show();
                }

                TransferDetails = getResult.TransferDets;
                if (TransferDetails == null) {
                    // TransferDetailsPushEmptyMessage();
                    $("#TransferResultId").empty();
                    TransferDetailsNewRow();
                }
                else {
                    bindDatatoTransfeDatagrid(TransferDetails);
                }

                $('#myPleaseWait').modal('hide');
            })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsgTransfer').css('visibility', 'visible');
            });

        var sts = $('#hdnWoSts').val();
        $('.divWOStatus').text(sts);
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}

function TransferDetailsNewRow() {

    var inputpar = {
        inlineHTML: TransferGridHtml(),//Inline Html
        TargetId: "#TransferResultId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
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


// --------------------------- 5th tab -----------------------------------------------

$("#btnRescheduleSave,#btnSaveandAddNew").click(function () {
    var AssigneeHiddenValue = $('#hdnRescheduleById_0').val();
    var AssigneeValue = $('#RescheduleApprovedBy_0').val();
    if (AssigneeValue != "" && AssigneeHiddenValue == "") {
        bootbox.alert("Valid Reschedule Approved By required!");
        return false;
    }
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgReschedule').css('visibility', 'hidden');

    var RescheduleDate = $("#RescheduleDate_0").val();
    var hdnRescheduleById = $('#hdnRescheduleById_0').val();
    var primaryId = $("#primaryID").val();
    var Timestamp = $('#Timestamp').val();

    var obj = {
        WorkOrderId: primaryId,
        RescheduleDate: RescheduleDate,
        hdnRescheduleById: hdnRescheduleById,
        Timestamp: Timestamp
    };


    var jqxhr = $.post("/api/ScheduledWorkOrder/AddReschedule", obj, function (response) {
        var getResult = JSON.parse(response);
        var htmlval = "";
        var getResult = JSON.parse(response);
        if (getResult.RescheduleWorkOrderDate == "0001-01-01T00:00:00")
            getResult.RescheduleWorkOrderDate = null;
        if (getResult.RescheduleTargetDate == "0001-01-01T00:00:00")
            getResult.RescheduleTargetDate = null;
        $('#RescheduleWorkOrderNo').val(getResult.RescheduleWorkOrderNo);
        $('#RescheduleWorkOrderDate').val(DateFormatter(getResult.RescheduleWorkOrderDate));
        $('#RescheduleAssetNo').val(getResult.RescheduleAssetNo);
        $('#RescheduleTargetDate').val(DateFormatter(getResult.RescheduleTargetDate));
        //$('#primaryID').val(getResult.WorkOrderId);

        RescheduleDetails = getResult.RescheduleDets;
        if (RescheduleDetails == null) {
            $('#RescheduleWorkOrderNo').val(GlobalWorkOrderNo);
            $('#RescheduleWorkOrderDate').val(moment(GlobalWorkOrderDate).format("DD-MMM-YYYY HH:mm"));
            //RescheduleDetailsPushEmptyMessage();
            $("#RescheduleResultId").empty();
            RescheduleDetailsNewRow();
            $("#RescheduleDate_0").prop('disabled', true);
            $("#RescheduleApprovedBy_0").prop('disabled', true);
            $("#btnRescheduleSave").hide();
        }
        else {
            bindDatatoRescheduleDatagrid(RescheduleDetails);
        }

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
            $('#errorMsgReschedule').css('visibility', 'visible');

            //  $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
});

function GetReschedule() {
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgReschedule').css('visibility', 'hidden');

    $("#btnRescheduleSave").hide();

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/ScheduledWorkOrder/GetReschedule/" + primaryId + "/" + pagesize + "/" + pageindex)
            .done(function (result) {
                var htmlval = "";
                var getResult = JSON.parse(result);
                if (getResult.RescheduleWorkOrderDate == "0001-01-01T00:00:00")
                    getResult.RescheduleWorkOrderDate = null;
                if (getResult.RescheduleTargetDate == "0001-01-01T00:00:00")
                    getResult.RescheduleTargetDate = null;
                $('#RescheduleWorkOrderNo').val(getResult.RescheduleWorkOrderNo);
                $('#RescheduleWorkOrderDate').val(DateFormatter(getResult.RescheduleWorkOrderDate));
                $('#RescheduleAssetNo').val(GlobalAssetNo);
                $('#RescheduleTargetDate').val(DateFormatter(GlobalTargetDate));
                //$('#primaryID').val(getResult.WorkOrderId);

                RescheduleDetails = getResult.RescheduleDets;
                if (RescheduleDetails == null) {
                    $('#RescheduleWorkOrderNo').val(GlobalWorkOrderNo);
                    $('#RescheduleWorkOrderDate').val(moment(GlobalWorkOrderDate).format("DD-MMM-YYYY HH:mm"));
                    //RescheduleDetailsPushEmptyMessage();
                    $("#RescheduleResultId").empty();
                    RescheduleDetailsNewRow();
                    $("#RescheduleDate_0").prop('disabled', true);
                    $("#RescheduleApprovedBy_0").prop('disabled', true);
                    $("#btnRescheduleSave").hide();
                }
                else {
                    bindDatatoRescheduleDatagrid(RescheduleDetails);
                }

                $('#myPleaseWait').modal('hide');
            })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsgReschedule').css('visibility', 'visible');
            });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}

function RescheduleDetailsNewRow() {

    var inputpar = {
        inlineHTML: RescheduleGridHtml(),//Inline Html
        TargetId: "#RescheduleResultId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
}

function RescheduleDetailsPushEmptyMessage() {
    $("#RescheduleResultId").empty();
    var emptyrow = '<tr><td colspan=4 ><h3&nbsp;&nbsp;&nbsp;&nbsp;No records to display</h3></td></tr>'
    $("#RescheduleResultId ").append(emptyrow);
}

function RescheduleGridHtml() {
    return '<tr class="ng-scope" style=""> <td width="25%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" id="RescheduleDate_maxindexval" value="" class="form-control datetime" disabled> </div></td><td width="75%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled data-value=" " id="RescheduleReason_maxindexval" value=" " class="form-control"> </div></td></tr>';
}

function bindDatatoRescheduleDatagrid(list) {
    if (list.length > 0) {
        $('#RescheduleResultId').empty()
        var html = '';

        $(list).each(function (index, data) {

            html = '<tr class="ng-scope" style=""> <td width="25%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" id="RescheduleDate_' + index + '" value="' + DateFormatter(data.RescheduleDate) + '" class="form-control datetime" disabled> </div></td> \
                    <td width="75%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled data-value=" " id="RescheduleReason_' + index + '" value="' + data.RescheduleReason + '" class="form-control"> </div></td> \
                    </tr>';


            $('#RescheduleResultId').append(html);
            GridtotalRecords = data.TotalRecords;
            TotalPages = data.TotalPages;
            LastRecord = data.LastRecord;
            FirstRecord = data.FirstRecord;
            pageindex = data.PageIndex;
        });
        var mapIdproperty = ["RescheduleDate-RescheduleDate_", "RescheduleReason-RescheduleReason_"];
        var htmltext = RescheduleGridHtml();

        id = $('#primaryID').val();
        var obj = { formId: "#tab-5", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "RescheduleDets", tableid: '#RescheduleResultId', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/ScheduledWorkOrder/GetReschedule/" + id, pageindex: pageindex, pagesize: pagesize };

        CreateFooterPagination(obj);
    }

    formInputValidation("form");

}

function LinkClicked(id, rowData) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formScheduledWorkOrder :input:not(:button)").parent().removeClass('has-error');
    $("#tab-2 :input:not(:button)").parent().removeClass('has-error');
    $("#tab-3 :input:not(:button)").parent().removeClass('has-error');
    $("#tab-4 :input:not(:button)").parent().removeClass('has-error');
    $("#tab-5 :input:not(:button)").parent().removeClass('has-error');
    $("#PPMCheckList :input:not(:button)").parent().removeClass('has-error');
    $("#CommonAttachment :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#FirstGridId').empty();
    $('#SecondGridId').empty();
    $('#CompletionInfoResultId').empty();
    $('input[type="text"], textarea').val('');
    var action = "";
    $('#primaryID').val(id);
    
    var iframe = document.getElementById('myIframe');
    

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
        $('#btnEdit').show();
        $('#btnCancel').show();
    }

    if (action == 'View') {
        $("#formScheduledWorkOrder :input:not(:button)").prop("disabled", true);
    }
    else if (action != 'View' && ((rowData.WorkOrderStatusGrid == "Cancelled" || rowData.WorkOrderStatusGrid == "Closed") || (rowData == "Cancelled" || rowData == "Closed"))) {
        $('#btnEdit').hide();
        $('#btnSave').hide();
        $('#btnDelete').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnSaveandAddNew').hide();
        $('#btnCancel').show();
        //$('#crmWorkStfAss').prop("disabled", true);
        //$('#crmWorkStfAss').prop("disabled", true);
        $("btnPurchasePopUpSave").hide();
        $("btnAdditionalInfoEdit").hide();
        $('#btnSWOPrint').show();

    }
    else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        $("btnPurchasePopUpSave").show();
        $("btnAdditionalInfoEdit").show();
        //$('#btnSaveandAddNew').hide();
        //$('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/ScheduledWorkOrder/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                var res = JSON.parse(result);
                BindHeaderData(res);
                GetCompletionInfo();
                GetCheckListDD();
                
                $('#hdnAttachId').val(getResult.HiddenId);
                $('#hdnAttachThereOrNot').val(getResult.HiddenId);
                TypeOfWorkOrder = getResult.TypeOfWorkOrder;
                WorkOrderStatus = getResult.WorkOrderStatus;
                GlobalWorkOrderNo = getResult.WorkOrderNo;
                GlobalWorkOrderDate = getResult.PartWorkOrderDate;
                GlobalRunningHoursCapture = getResult.RunningHoursCapture;
                WorkOrderStatusString = getResult.WorkOrderStatusValue;
                $('#divWOStatus').text(getResult.WorkOrderStatusValue);
                $('#hdnWoSts').val(getResult.WorkOrderStatusValue);
                $('#divAssetStatus').text(getResult.AssetWorkingStatusValue);
                WorkOrderStatusString = WorkOrderStatusString.trim();
                if (hasApprovePermission == true && WorkOrderStatusString == "Request for Cancellation") {
                    $('#btnApprove').show();
                    $('#btnReject').show();
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
                    $('#btnApprove').hide();
                    $('#btnReject').hide();
                    $('#CancelRequestRemarks').css('visibility', 'hidden');
                }

                //------ADDED BY PRANAY-----------------------------//
                ///added by sai//
                $('#txt_AssetStatus').text(getResult.AssetStatus);

                

                $('#txt_AssetCritically').text(getResult.AssetCrticality);
                $('#txt_variationstatus').text(getResult.VariationStatus);
                $('#txt_AssetCondition').text(getResult.AssetCondition);
                $('#tx_serialno').text(getResult.SerialNo);
                $('#txt_ServiceLife').text(getResult.ServiceLife);
                $('#txt_StartDatess').text(moment(getResult.WarrantyStartDate).format("DD-MMM-YYYY"));
                $('#txt_EndDatess').text(moment(getResult.WarrantyEndDate).format("DD-MMM-YYYY"));
                $('#txt_UserArea').text(getResult.UserAreaName);
                $('#txt_QCPPMRT').text(getResult.QCCodeFieldVaule);
                ///
                $('#txt_AssetDescription').text(getResult.AssetDescription);
                $('#txt_TargetDate').text(moment(getResult.TargetDate).format("DD-MMM-YYYY"));
                $('#txt_HandoverDate').text(getResult.HandOverDate);
                $('#txt_hospitalcode').text(getResult.HospitalCode);
                $('#txt_priority').text(getResult.Priority);
                $('#txt_workorderno').text(getResult.WorkOrderNo);
                $('#txt_workorderdate').text(moment(getResult.PartWorkOrderDate).format("DD-MMM-YYYY HH:mm"));
                $('#txt_category').text(getResult.WorkOrderCategory);
                $('#txt_type').text(getResult.MaintenanceType);
                $('#txt_asssetno').text(getResult.AssetNo);
                $('#txt_AssetName').text(getResult.AssetName);
                $('#txt_assettypecode').text(getResult.AssetTypeCode);
                $('#txt_assettypedesc').text(getResult.AssetDescription);
                $('#txt_manufacturer').text(getResult.Manufacturer);
                $('#txt_model').text(getResult.Model);
                $('#txt_contracttype').text(getResult.ContractTypeValue);
                $('#txt_serialno').text(getResult.SerialNo);
                $('#txt_deptcode').text(getResult.UserAreaCode);
                $('#txt_deptname').text(getResult.UserArea);
                $('#txt_locationcode').text(getResult.UserLocation);
                $('#txt_locationname').text(getResult.UserLocationName);
                //$('#txt_UserArea').text(getResult.UserArea);
                $('#txt_variationstatus').text(getResult.VariationStatus);
                $('#txt_taskcode').text(res.PPMCheckListTaskCode);
                $('#txt_frequency').text(res.PPMCheckListPPMFrequency);
                $('#txt_ppmagreeddate').text(getResult.AgreedDate);
                //$('#txt_targetdate').text(getResult.TargetDate);
                $('#txt_status').text(getResult.WorkOrderStatus);
                $('#txt_contractorname').text(getResult.ContractorName);
                $('#txt_contractorcode').text(getResult.ContractorCode);
                $('#txt_contactperson').text(getResult.ContactPerson);
                $('#txt_phoneno').text(getResult.PhoneNo);
                $('#txt_startdate').text(getResult.StartDate);
                $('#txt_enddate').text(getResult.EndDate);
                $('#empoyeename').text(getResult.CompletedBy);
                $('#txt_TaskCode').text(getResult.PPMCheckListTaskCode);
                $('#txt_startdate').text(getResult.StartDate);
                $('#txt_enddate').text(getResult.EndDate);
                $('#txt_startdatetime').text(getResult.StartDate);
                $('#txt_datetimeworkcmpltd').text(getResult.EndDate);
                $('#txt_actiontaken').text(getResult.Remarks);
                $('#txt_causecode').text(getResult.CauseCode);
                $('#txt_qccode').text(getResult.QCCode);
                $('#txt_completedby').text(getResult.CompletedBy);
                $('#txt_verifiedby').text(getResult.VerifiedBy);
                $('#txtTypeCodeDetails').val(getResult.AssetTypeDescription);
                $('#txt_Assest_Desccription').text(getResult.AssetClassificationDescription);
               
                //if ($('#ServiceId').val() == 1) {
                    

                //    iframe.src = 'https://deduction.uemedgenta.com/PPM/FEMSPPMReport_Viewer.aspx?WorkOrderNo=' + id;


                //}
                //else {

                //    iframe.src = 'https://deduction.uemedgenta.com/PPM/PPMReport_Viewer.aspx?WorkOrderNo=' + id;


                //}

                
                //if ($('#ServiceId').val() == 1) {
                //    iframe.src = '/Report/FemsPrint.aspx?Reportname=' + "RPT_SCH_WO_FEMS" + '&WorkOrderNo=' + id;

                //}
                //else {
                //    iframe.src = '/Report/BemsPrint.aspx?Reportname=' + "RPT_SCH_WO_BEMS" + '&WorkOrderNo=' + id;
                //}
                PrintRDL();
                ///-------END ----PRANAY-------------------------------//

                if (getResult.AssetWorkingStatusValue == "")
                    $('#divAssetStatus1').hide();
                else
                    $('#divAssetStatus1').show();
                //$('#divAssetStatus').text("Hai");
                $('#btnSWOPrint').hide();
                if (action != 'View' && (WorkOrderStatus == 143 || WorkOrderStatus == 142)) {
                    $('#btnEdit').hide();
                    $('#btnCompletionSave').hide();
                    $('#btnPartSave').hide();
                    $('#btnTransferSave').hide();
                    $('#btnEditAttachment').hide();
                    $('#AttachRowPlus').show();
                    $('#btnPPMCheckListSave').hide();
                    $('#btnSave').hide();
                    $('#btnDelete').hide();
                    $('#btnSaveandAddNew').hide();
                    $("btnPurchasePopUpSave").hide();
                    $("btnAdditionalInfoEdit").hide();
                    $('#btnCancel').show();
                    $('#btnSWOPrint').show();
                }
                else {
                    $('#btnEdit').show();
                    $('#btnSave').hide();
                    $('#btnCompletionSave').show();
                    $('#btnPartSave').show();
                    $('#btnTransferSave').show();
                    $('#btnEditAttachment').show();
                    $('#AttachRowPlus').show();
                    $('#btnPPMCheckListSave').show();
                    $('#btnSaveandAddNew').show();
                    $("btnPurchasePopUpSave").show();
                    $("btnAdditionalInfoEdit").show();
                }

                $('.divWOStatus').text(getResult.WorkOrderStatusValue);
                $('#hdnAssetId').val(getResult.AssetRegisterId);
                $('#txtAssetNo').val(getResult.AssetNo);
                if (getResult.AssetNo == "") {
                    $('#txtAssetNo').prop('required', false);
                }
                GlobalAssetNo = getResult.AssetNo;
                GlobalAssetNoCost = getResult.AssetNoCost;
                GlobalAssetDescription = getResult.AssetDescription;
                GlobalAssignee = getResult.WorkOrderAssignee;
                $('#txtAssetDescription').val(getResult.AssetDescription);
                $('#txtUserArea').val(getResult.UserArea);
                $('#txtUserLocation').val(getResult.UserLocation);
                $('#txtLevel').val(getResult.Level);
                $('#txtBlock').val(getResult.Block);
                $('#txtContractType').val(getResult.ContractTypeValue);
                $('#TargetDate').val(moment(getResult.TargetDate).format("DD-MMM-YYYY"));
                $('#WorkOrderCategory').val(getResult.WorkOrderCategory).prop('disabled', true);
                $("#partWorkOrderDate").val(moment(getResult.PartWorkOrderDate).format("DD-MMM-YYYY HH:mm")).prop("disabled", true);
                GlobalTargetDate = getResult.TargetDate;
                CompInfoReScheduledDate = getResult.TargetDate;
                $('#txtModel').val(getResult.Model);
                $('#txtManufacturer').val(getResult.Manufacturer);
                $('#hdnEngineerId').val(getResult.EngineerId);
                $('#txtEngineer').val(getResult.Engineer);
                $('#hdnAssetTypeCodeId').val(getResult.AssetTypeCodeId);
                $('#txtAssetTypeCode').val(getResult.AssetTypeCode);
                $('#txtWorkOrderNo').val(getResult.WorkOrderNo);
                $('#MaintainanceType').val(getResult.MaintenanceType);
                //$('#txtWorkOrderStatus').val(getResult.WorkOrderStatusValue);
                $('#txtMaintainanceDetails').val(getResult.MaintenanceDetails);
                $('#primaryID').val(getResult.WorkOrderId);
                GlobalWorkOrderId = getResult.WorkOrderId;
                $("#Timestamp").val(getResult.Timestamp);
                $('#TargetDate').prop('disabled', true);
                $('#txtAssetNo').prop('disabled', true);
                $('#txtEngineer').prop('disabled', true);
                $('#txtMaintainanceDetails').prop('disabled', true);
                $('#txtcancelreason').prop('disabled', true);
                //$('#btnCompletionSave').prop('disabled', false);
                //$('#btnPartSave').prop('disabled', false);
                //$('#btnTransferSave').prop('disabled', false);
                //$('#btnRescheduleSave').prop('disabled', false);
                //$('#btnPPMCheckListSave').prop('disabled', false);
                if (WorkOrderStatusString == "Closed") {
                    
                    $("#formScheduledWorkOrder :input:not(:button)").prop("disabled", true);
                    $("#tab-2 :input:not(:button)").prop("disabled", true);
                    $("#tab-3 :input:not(:button)").prop("disabled", true);
                    $("#tab-4 :input:not(:button)").prop("disabled", true);
                    $("#tab-5 :input:not(:button)").prop("disabled", true);
                    $("#divCommonAttachment :input:not(:button)").prop("disabled", true);
                    $("#PPMCheckList :input:not(:button)").prop("disabled", true);
                    $("#aAFAdditionalInfo :input:not(:button)").prop("disabled", true);
                    $('#txtEngineer').prop('disabled', true);
                    $('#txtMaintainanceDetails').prop('disabled', true);
                    $('#PPMChecklistNo').prop('disabled', false);
                    $('#btnEditAttachment').hide();
                    $('#AttachRowPlus').show();
                    $("btnPurchasePopUpSave").hide();
                    $("btnAdditionalInfoEdit").hide();
                    var x = document.getElementById("Blockcodepopup");
                    x.style.display = "none";
                    $('#btnSWOPrint').show();
                }
                

                //$('#btnSWOPrint').hide();

                if (WorkOrderStatusString == "Open" || WorkOrderStatusString == "Work In Progress" || WorkOrderStatusString == "Completed") {
                    $("#formScheduledWorkOrder :input:not(:button)").prop("disabled", false);
                    $("#tab-2 :input:not(:button)").prop("disabled", false);
                    $("#tab-3 :input:not(:button)").prop("disabled", false);
                    $("#tab-4 :input:not(:button)").prop("disabled", false);
                    $("#tab-5 :input:not(:button)").prop("disabled", false);

                    $('#PartReplacementCost').prop('disabled', true);
                    $('#WorkOrderCategory').prop('disabled', true);
                    $("#divCommonAttachment :input:not(:button)").prop("disabled", false);
                    $("#PPMCheckList :input:not(:button)").prop("disabled", false);
                    $("#aAFAdditionalInfo :input:not(:button)").prop("disabled", false);
                    $('#txtEngineer').prop('disabled', true);
                    $('#txtMaintainanceDetails').prop('disabled', true);
                    $('#PPMChecklistNo').prop('disabled', false);
                    $('#TargetDate').prop('disabled', true);
                    $('#txtAssetNo').prop('disabled', true);
                    $("#partWorkOrderDate").prop('disabled', true);
                    $('#txtAssetDescription').prop('disabled', true);
                    $('#txtContractType').prop('disabled', true);
                    $('#txtUserArea').prop('disabled', true);
                    $('#txtUserLocation').prop('disabled', true);
                    $('#txtModel').prop('disabled', true);
                    $('#hdnAssetTypeCodeId').prop('disabled', true);
                    $('#txtAssetTypeCode').prop('disabled', true);
                    $('#txtManufacturer').prop('disabled', true);
                    $('#txtLevel').prop('disabled', true);
                    $('#txtBlock').prop('disabled', true);
                    $('#WorkOrderNo').prop('disabled', true);
                    $('#txtWorkOrderNo').prop('disabled', true);
                    $('#MaintainanceType').prop('disabled', true);
                    $('#PartWorkOrderNo').prop('disabled', true);
                    $('#PartWorkOrderDate').prop('disabled', true);
                    $('#PartAssetNo').prop('disabled', true);
                    $('#PartAssetNoCost').prop('disabled', true);
                    $('#TotalSparePartCost').prop('disabled', true);
                    $('#Totalvendorcost').prop('disabled', true);
                    $('#TotalLabourCost').prop('disabled', true);
                    $('#TotalCost').prop('disabled', true);
                    $('#TransferOldAssignedPerson').prop('disabled', true);
                    $('#TransferAssetNo').prop('disabled', true);
                    $('#TransferAssetDescription').prop('disabled', true);
                    $('#RescheduleWorkOrderNo').prop('disabled', true);
                    $('#RescheduleWorkOrderDate').prop('disabled', true);
                    $('#RescheduleAssetNo').prop('disabled', true);
                    $('#RescheduleTargetDate').prop('disabled', true);
                    $('#PPMChecklisttxtAssetTypeCode').prop('disabled', true);
                    $('#PPMChecklistAssetTypeDescription').prop('disabled', true);
                    $('#PPMChecklistTaskcode').prop('disabled', true);
                    //  $('#PPMChecklistTaskCodeDesc').prop('disabled', true);
                    $('#PPMChecklisttxtModel').prop('disabled', true);
                    $('#PPMChecklisttxtManufacturer').prop('disabled', true);
                    $('#PPMChecklistPPMFrequency').prop('disabled', true);
                    $('#PPMChecklistPPMhours').prop('disabled', true);
                    $('#PPMChecklistSpecialPrecautions').prop('disabled', true);
                    $('#PPMChecklistRemarks').prop('disabled', true);
                    $('#btnEditAttachment').show();
                    $('#AttachRowPlus').show();
                    
                    $('#btnSWOPrint').show();
                    $("btnPurchasePopUpSave").show();
                    $("btnAdditionalInfoEdit").show();
                    document.getElementById("Blockcodepopup").style.display = 'inline';
                    $(".Blockcodepopup").show();
                }
                if (IsExternal) {
                    $('#btnEdit').hide();
                    $('#btnSaveandAddNew').hide();
                }
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

$('#AttachmentTab').click(function () {
    
    var status = $('#divWOStatus').text();
    if (status.indexOf('Closed') != -1) {
        setTimeout(function () {
            $('#btnEditAttachment').show();
            //$("#CommonAttachment :input").prop("disabled", true);
        }, 150)
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

$("#btnApprove").click(function () {
    var ID = $('#primaryID').val();
    approveReject(ID, 'Approve', 'Approve');

});
$("#btnReject").click(function () {
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
    if ($('#ServiceId').val() == 1) {


        //iframe.src = 'https://deduction.uemedgenta.com/PPM/FEMSPPMReport_Viewer.aspx?WorkOrderNo=' + id;

        // '/Report/CommonBemsReport.aspx?Reportname='
        //  '/Report/CommonBemsReport.aspx?Reportname=' + "CAMIS_BemsAssetRegistrationHistoryRpt_L1" + '&WorkOrderNo=' + id;

        //iframe.src = '/Report/CommonBemsReport.aspx?Reportname=' + "CAMIS_BemsAssetRegistrationHistoryRpt_L1" + '&WorkOrderNo=' + id;

        iframe.src = '/Report/FemsPrint.aspx?Reportname=' + "RPT_SCH_WO_FEMS" + '&WorkOrderNo=' + id;

    }
    else {

        //  iframe.src = 'https://deduction.uemedgenta.com/PPM/PPMReport_Viewer.aspx?WorkOrderNo=' + id;

        iframe.src = '/Report/BemsPrint.aspx?Reportname=' + "RPT_SCH_WO_BEMS" + '&WorkOrderNo=' + id;
         }
    }
}


function EmptyFields() {
    $('input[type="text"], textarea').val('');
    $('.ui-tabs-hide').empty();
    $('#btnEdit').show();
    $('#btnSave').show();
    $('#btnSaveandAddNew').show();
    //$('#btnEdit').prop('disabled', true);
    //$('#txtEngineer').prop('disabled', true);
    $('#btnDelete').hide();
    $('#btnApprove').hide();
    $('#btnReject').hide();
    $('#divWOStatus').text("");
    $('#btnNextScreenSave').hide();
    $('#btnCancel').show();
    $('#btnSWOCancel').show();
    //$('#btnSaveandAddNew').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#grid").trigger('reloadGrid');
    $("#formScheduledWorkOrder :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#txtAssetNo').prop('disabled', false);
    $('#TargetDate').prop('disabled', false);
    $('#WorkOrderCategory').val('null').prop('disabled', false);
    $('#txtMaintainanceDetails').prop('disabled', false);
    $('#txtEngineer').prop('disabled', false);
    $('#txtHandoverDate').prop('disabled', false);
    $('#txtCompletedBy').prop('disabled', false);
    $('#txtVerifiedBy').prop('disabled', false);
    $('#CauseCodeDescription').prop('disabled', false);
    $('#QCDescription').prop('disabled', false);
    $('#RepairDetails').prop('disabled', false);
    //$('#txtAgreedDate').prop('disabled', false);
    $('#VendorServiceCost').prop('disabled', false);
    $('#Status').prop('disabled', false);
    $('#Reason').prop('disabled', false);
    $('#txtRunningHours').prop('disabled', false);
    $('#PartReplacementCostInvolved').prop('disabled', false);
    $('#AverageUsageHours').prop('disabled', false);
    $('#TransferAssignedPerson').prop('disabled', false);
    $('#PPMChecklistNo').prop('disabled', false);
    $('#btnSWOPrint').hide();
    $('#MaintainanceType').val(0);
    $('#txtremarks').prop('disabled', true);
    $('#txtremarks').prop('required', false);
    $('#txtremarks').val('');
    $('#ApproveCancelRemarks').css('visibility', 'hidden'); 
    $('#CancelRequestRemarks').css('visibility', 'hidden');
}


/////////////////-------------------------PPM CheckList Tab------------------------////////////////////////////

$("#btnPPMCheckListSave,#btnSaveandAddNew").click(function () {
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgPPMCheckList').css('visibility', 'hidden');
    var primaryId = $("#primaryID").val();
    var checklistId = $('#PPMChecklistNo').val();
    var Timestamp = $('#Timestamp').val();


    //first grid 

    var _index;        // var _indexThird;
    var result = [];
    $('#FirstGridId tr').each(function () {
        _index = $(this).index();
    });

    for (var i = 0; i <= _index; i++) {
        var _tempObj = {
            WOPPmCategoryDetId: $('#WOPPmCategoryDetId_' + i).val(),
            PPmCategoryDetId: $('#PPmCategoryDetId_' + i).val(),
            Status: $('#PPMCheckListStatus_' + i).val(),
            Remarks: $('#PPMCheckListRemarks_' + i).val(),
        }
        result.push(_tempObj);
    }

    var _index1;        // var _indexThird;
    var result1 = [];
    $('#SecondGridId tr').each(function () {
        _index1 = $(this).index();
    });
    for (var i = 0; i <= _index1; i++) {

        var val12 = $('#PPMCheckListValue_' + i).val();
        var Value = (val12 == null || val12 == '') ? null : val12.split(',').join('');

        var _tempObj1 = {
            WOPPMCheckListQNId: $('#WOPPMCheckListQNId_' + i).val(),
            PPMCheckListQNId: $('#PPMCheckListQNId_' + i).val(),
            //Value: $('#PPMCheckListValue_' + i).val(),
            Value: Value,
            Status: $('#PPMCheckListStatus2_' + i).val(),
            Remarks: $('#PPMCheckListRemarks2_' + i).val(),
        }
        result1.push(_tempObj1);
    }

    var isFormValid = formInputValidation("PPMCheckList", 'save');
    if (!isFormValid || result1 == '' || result == '' || result1 == null || result == null) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsgPPMCheckList').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        // $('#btnSave').attr('disabled', false);
        return false;
    }



    var obj = {
        WOPPMCheckListId: GlobalWOPPMCheckListId,
        PPMCheckListId: checklistId,
        WorkOrderId: primaryId,
        Timestamp: $('#Timestamp').val(),
        PPMCheckListQuantasksMstDets: result1,
        PPmChecklistCategoryDets: result,
    };
    var jqxhr = $.post("/api/ScheduledWorkOrder/AddPPMCheckList", obj, function (response) {
        var res = JSON.parse(response);
        //$("#grid").trigger('reloadGrid');
        $('#FirstGridId').empty();
        $('#SecondGridId').empty();
        BindHeaderData(res);
        if (res.PPmChecklistCategoryDets != null && res.PPmChecklistCategoryDets.length > 0)
            BindCategoryGrid(res.PPmChecklistCategoryDets);

        if (res.PPMCheckListQuantasksMstDets != null && res.PPMCheckListQuantasksMstDets.length > 0)
            BindQuantityGrid(res.PPMCheckListQuantasksMstDets);
        $(".content").scrollTop(0);
        showMessage('PPM Checklist', CURD_MESSAGE_STATUS.SS);
        $("#top-notifications").modal('show');
        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);

        $('#btnPPMCheckListSave').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        //if (CurrentbtnID == "btnSaveandAddNew") {
        //    EmptyFields();
        //}
    },
        "json")
        .fail(function (response) {
            var errorMessage = "";
            if (response.status == 400) {
                errorMessage = response.responseJSON;
            }
            else {
                errorMessage = Messages.COMMON_FAILURE_MESSAGE;
            }
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsgPPMCheckList').css('visibility', 'visible');
            $('#btnPPMCheckListSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });

});

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
function CostChange() {
    //var CCID = $('#PartReplacementCostInvolved').val();
    //if (CCID == 99)
    //{
    //    $('#PartReplacementCostHide').show();
    //    $('#PartReplacementCost').prop('required', true);
    //    $('#PartReplacementCost').prop('disabled', false);
    //}
    //else if (CCID == 100)
    //{
    //    $('#PartReplacementCost').val("");
    //    $('#PartReplacementCostHide').hide();
    //    $('#PartReplacementCost').prop('required', false);
    //    $('#PartReplacementCost').prop('disabled', true);
    //    $("#PartReplacementCost").parent().removeClass('has-error');
    //}

}

function GetCheckListDD() {
    $("#formScheduledWorkOrder :input:not(:button)").parent().removeClass('has-error');
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgPPMCheckList').css('visibility', 'hidden');

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/ScheduledWorkOrder/GetCheckListDD/" + primaryId)
            .done(function (result) {
                var res = JSON.parse(result);
                var htmlval = "";
                $('#PPMChecklistNo').empty();
                //$('#PPMChecklistNo').append('<option value="null">Select</option>');
                $.each(res.PPMCheckListNoIdList, function (index, value) {
                    $('#PPMChecklistNo').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>').prop("disabled", true);
                });
                GetPPMCheckList();
                $('#myPleaseWait').modal('hide');
            })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsgPPMCheckList').css('visibility', 'visible');
            });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}

function GetPPMCheckList() {
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgPPMCheckList').css('visibility', 'hidden');
    var checklistId = $('#PPMChecklistNo').val();
    if (checklistId == "null") {
        $('#myPleaseWait').modal('hide');
        $("div.errormsgcenter").text("Please choose Checklist Number!");
        $('#errorMsgPPMCheckList').css('visibility', 'visible');
        $('#FirstGridId').empty();
        $('#SecondGridId').empty();
        $('input[type="text"], textarea').val('');
        return false;
    }
    if (checklistId == null) {
        $('#PPMChecklistNo').append('<option value="null">Select</option>').prop("disabled", true);
        return false;
    }
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0" && checklistId != null && checklistId != "null") {
        $.get("/api/ScheduledWorkOrder/GetPPMCheckList/" + primaryId + "/" + checklistId)
            .done(function (result) {
                var res = JSON.parse(result);
                var htmlval = "";
                $('#FirstGridId').empty();
                $('#SecondGridId').empty();
                BindHeaderData(res);

                if (res.PPmChecklistCategoryDets != null && res.PPmChecklistCategoryDets.length > 0) {
                    BindCategoryGrid(res.PPmChecklistCategoryDets);
                }
                if (res.PPMCheckListQuantasksMstDets != null && res.PPMCheckListQuantasksMstDets.length > 0) {
                    BindQuantityGrid(res.PPMCheckListQuantasksMstDets);
                }
                $('#btnPPMCheckListPrint').show();

                var sts = $('#divWOStatus').text();
                if (sts == "Closed") {
                    $('#btnCompletionSubmitEdit').hide();
                    $('#FirstGridId :input').attr('disabled', true);
                    $('#SecondGridId  :input').attr('disabled', true);
                } else {
                    var len1 = $('#FirstGridId tr').length;
                    var len2 = $('#SecondGridId tr').length;
                    for (i = 0; i < len1; i++) {
                        $('#PPMCheckListStatus_' + i).attr('disabled', false);
                        $('#PPMCheckListRemarks_' + i).attr('disabled', false);
                    }
                    for (j = 0; j < len2; j++) {
                        $('#PPMCheckListValue_' + j).attr('disabled', false);
                        $('#PPMCheckListStatus2_' + j).attr('disabled', false);
                        $('#PPMCheckListRemarks2_' + j).attr('disabled', false);
                    }
                }

                $('#myPleaseWait').modal('hide');
            })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsgPPMCheckList').css('visibility', 'visible');
            });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}

window.BindHeaderData = function (res) {
    $('#PPMChecklisttxtAssetTypeCode').val(res.PPMCheckListAssetTypeCode);
    $('#PPMChecklistAssetTypeDescription').val(res.PPMCheckListAssetTypeDescription);
    $('#PPMChecklistTaskcode').val(res.PPMCheckListTaskCode);
    $('#txt_PPMChecklistTaskcodes').text(res.PPMCheckListTaskCode);
    //$('#PPMChecklistTaskCodeDesc').val(res.PPMCheckListTaskCodeDesc);
    //$('#txt_taskcode').text(res.PPMCheckListTaskCode);
    $('#PPMChecklistPPMFrequency').val(res.PPMCheckListPPMFrequency);
    $('#PPMChecklistPPMhours').val(res.PPMCheckListPpmHours);
    $('#PPMChecklistSpecialPrecautions').val(res.PPMCheckListSpecialPrecautions);
    $('#PPMChecklistRemarks').val(res.PPMCheckListRemarks);
    $('#PPMChecklisthdnManufacturerId').val(res.PPMCheckListManufacturerId);
    $('#PPMChecklisttxtManufacturer').val(res.PPMCheckListManufacturer);
    $('#PPMChecklisthdnModelId').val(res.PPMCheckListModelId);
    $('#PPMChecklisttxtModel').val(res.PPMCheckListModel);
    $('#PPMChecklistTimestamp').val(res.PPMCheckListTimestamp);
    GlobalWOPPMCheckListId = res.WOPPMCheckListId;
    // $('#PPMChecklistNo').val(res.PPMCheckListPPMChecklistNo);
    //$('#primaryID').val(res.PPMCheckListId);
    if (res.WorkOrderStatusValue == "Closed") {
        $('#btnPPMCheckListSave').hide();
    }
}
window.BindCategoryGrid = function (list) {
    if (list.length > 0) {
        $(list).each(function (index, data) {
            AddFirstGridRow();
            $('#WOPPmCategoryDetId_' + index).val(data.WOPPmCategoryDetId);
            $('#PPmCategoryDetId_' + index).val(data.PPmCategoryDetId);

            $('#PPMCategoryId_' + index).val(data.PpmCategoryId).attr('disabled', true);
            $('#SNo_' + index).val(data.SNo).attr('disabled', true);
            $('#Description_' + index).val(data.Description).attr('disabled', true);

            $('#PpmCategoryId_' + index).attr('disabled', true);
            if (data.Status == null) {
                data.Status = 382;
            }
            $('#PPMCheckListStatus_' + index).val(data.Status);
            $('#PPMCheckListRemarks_' + index).val(data.Remarks);
        });

    }
}
window.BindQuantityGrid = function (list) {
    if (list.length > 0) {
        $(list).each(function (index, data) {
            AddSecondGridRow();
            $('#WOPPMCheckListQNId_' + index).val(data.WOPPMCheckListQNId);
            $('#PPMCheckListQNId_' + index).val(data.PPMCheckListQNId);
            $('#QuantitativeTasks_' + index).val(data.QuantitativeTasks).attr('disabled', true);
            $('#UOM_' + index).val(data.UOM).attr('disabled', true);
            $('#SetValues_' + index).val(data.SetValues).attr('disabled', true);
            $('#LimitTolerance_' + index).val(data.LimitTolerance).attr('disabled', true);
            if (data.Status == null) {
                data.Status = 340;
            }
            $('#PPMCheckListStatus2_' + index).val(data.Status);
            $('#PPMCheckListRemarks2_' + index).val(data.Remarks);

            var ppmCheckListValue = data.Value;
            if (ppmCheckListValue != null) {
                ppmCheckListValue = addCommas(ppmCheckListValue);
            }
            //$('#PPMCheckListValue_' + index).val(data.Value);
            //$('#PPMCheckListValue_' + index).attr('title', data.Value);
            $('#PPMCheckListValue_' + index).val(ppmCheckListValue);
            $('#PPMCheckListValue_' + index).attr('title', ppmCheckListValue);
        });
    }
}


window.AddFirstGridRow = function () {
    var inputpar = {
        inlineHTML: '<tr><td width="20%" style="text-align: center;"><div> ' +
            '<input type="hidden" id= "WOPPmCategoryDetId_maxindexval"/>' +
            '<input type="hidden" id= "PPmCategoryDetId_maxindexval"/>' +
            '<input type="text" readonly id="PPMCategoryId_maxindexval" name="SNo" class="form-control" autocomplete="off" tabindex="0" ></div></td><td width="20%" style="text-align: center;" ><div> ' +
            '<input type="text" readonly id="SNo_maxindexval" name="SNo" class="form-control text-right" autocomplete="off" tabindex="0" ></div></td><td width="20%" style="text-align: center;"><div> ' +
            '<input type="text" id="Description_maxindexval" name="TestApparatus" class="form-control" autocomplete="off" tabindex="0" required maxlength="100"></div></td><td width="20%" style="text-align: center;"><div> ' +
            '<select id="PPMCheckListStatus_maxindexval" class="form-control" required><option value="">Select</option> </select></div></td><td width="20%" style="text-align: center;" ><div> ' +
            '<input type="text" id="PPMCheckListRemarks_maxindexval" name="TestApparatus" class="form-control" autocomplete="off" tabindex="0" maxlength="100"></div> </td></tr>',
        IdPlaceholderused: "maxindexval",
        TargetId: "#FirstGridId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    var rowCount = $('#FirstGridId tr:last').index();
    $.each(window.StatusListGloabalCategory, function (index, value) {
        $('#PPMCheckListStatus_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });

    $('#PPMCheckListStatus_' + rowCount).val(382);
    formInputValidation("PPMCheckList");
}


window.AddSecondGridRow = function () {
    var inputpar = {
        inlineHTML: '<tr><td width="15%" style="text-align: center;" ><div> ' +
            '<input type="hidden" id= "WOPPMCheckListQNId_maxindexval" />' +
            '<input type="hidden" id= "PPMCheckListQNId_maxindexval" />' +
            ' <input type="text" id="QuantitativeTasks_maxindexval" name="Quantitative" class="form-control " autocomplete="off" maxlength="500" tabindex="0" required /></div></td><td width="15%" style="text-align: center;" ><div> ' +
            ' <input id="UOM_maxindexval" type="text" class="form-control text-right decimalCheck" name="Units" autocomplete="off" tabindex="0" maxlength="5" required></div></td><td width="15%" style="text-align: center;" ><div> ' +
            ' <input type="text"  id="SetValues_maxindexval" name="SetValues" class="form-control text-right decimalCheck" autocomplete="off" tabindex="0" maxlength="5" required></div></td><td width="15%" style="text-align: center;" ><div> ' +
            ' <input type="text" id="LimitTolerance_maxindexval" name="Tolerance" class="form-control text-right decimalCheck" autocomplete="off" tabindex="0" required maxlength="5" /></div></td><td width="10%" style="text-align: center;" ><div> ' +
            ' <input type="text" id="PPMCheckListValue_maxindexval" name="PPMCheckListValue" onchange="CalculatePassOrFail(maxindexval)" class="form-control text-right decimalCheckValue commaSeperator" autocomplete="off" tabindex="0" /></div></td><td width="15%" style="text-align: center;" ><div> ' +
            '<select id="PPMCheckListStatus2_maxindexval" class="form-control" required><option value="">Select</option> </select></div></td><td width="15%" style="text-align: center;" ><div> ' +
            '<input type="text" id="PPMCheckListRemarks2_maxindexval" name="TestApparatus" class="form-control" autocomplete="off" tabindex="0"  maxlength="100"></div> </td></tr>',
        IdPlaceholderused: "maxindexval",
        TargetId: "#SecondGridId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    var rowCount = $('#SecondGridId tr:last').index();
    $.each(window.StatusListGloabal, function (index, value) {
        $('#PPMCheckListStatus2_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
    $('#PPMCheckListStatus2_' + rowCount).val(340);
    AttachCommaEvents();
    AttachDecimalEvents();
    formInputValidation("PPMCheckList");
}

function AttachDecimalEvents() {
    $('.decimalCheckValue').each(function (index) {
        var vrate = document.getElementById(this.id);
        vrate.addEventListener('input', function (prev) {
            return function (evt) {
                if ((!/^\d{0,17}(?:\.\d{0,3})?$/.test(this.value))) {
                    this.value = prev;
                }
                else {
                    prev = this.value;
                }
            };
        }(vrate.value), false);
    });
}

function AttachCommaEvents() {
    $('.commaSeperator').focusout(function () {
        var id = $(this).attr('id');
        var x = $('#' + id).val();
        $('#hdn_' + id).val(x);
        if (parseInt(x) > 0) {
            $('#' + id).val(addCommas(x));
        }
    });

    $('.commaSeperator').on('click', function (event) {
        var id = $(this).attr('id');
        var val = $('#' + id).val();
        var result = val.split(',').join('');
        $('#' + id).val(result);
    });
}

function ClearErrorMessage() {
    $("#formScheduledWorkOrder :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#FirstGridId').empty();
    $('#SecondGridId').empty();
    $('input[type="text"], textarea').val('');
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/ScheduledWorkOrder/Get/" + primaryId)
            .done(function (result) {
                var htmlval = "";
                var getResult = JSON.parse(result);
               
                $('#hdnAttachId').val(getResult.HiddenId);
                TypeOfWorkOrder = getResult.TypeOfWorkOrder;
                WorkOrderStatus = getResult.WorkOrderStatus;
                GlobalWorkOrderNo = getResult.WorkOrderNo;
                GlobalWorkOrderDate = getResult.PartWorkOrderDate;
                GlobalRunningHoursCapture = getResult.RunningHoursCapture;
                WorkOrderStatusString = getResult.WorkOrderStatusValue;
                CompInfoReScheduledDate = getResult.TargetDate;
                $('.divWOStatus').text(getResult.WorkOrderStatusValue);
                $('#hdnAssetId').val(getResult.AssetRegisterId);
                $('#txtAssetNo').val(getResult.AssetNo);
                $('#txtAssetDescription').val(getResult.AssetDescription);
                $('#txtUserArea').val(getResult.UserArea);
                $('#txtUserLocation').val(getResult.UserLocation);
                $('#txtLevel').val(getResult.Level);
                $('#txtBlock').val(getResult.Block);
                $('#TargetDate').val(moment(getResult.TargetDate).format("DD-MMM-YYYY"));
                //$('#WorkOrderCategory').val(getResult.WorkOrderCategory).prop('disabled', true);
                if (getResult.WorkOrderCategory == 0) {
                    $('#WorkOrderCategory').val(null);
                } else {
                    $('#WorkOrderCategory').val(getResult.WorkOrderCategory).prop('disabled', true);
                }
                $("#partWorkOrderDate").val(moment(getResult.PartWorkOrderDate).format("DD-MMM-YYYY HH:mm")).prop("disabled", true);
                $('#txtModel').val(getResult.Model);
                $('#hdnAssetTypeCodeId').val(getResult.AssetTypeCodeId);
                $('#txtAssetTypeCode').val(getResult.AssetTypeCode);
                $('#txtManufacturer').val(getResult.Manufacturer);
                $('#hdnEngineerId').val(getResult.EngineerId);
                $('#txtEngineer').val(getResult.Engineer);
                $('#txtWorkOrderNo').val(getResult.WorkOrderNo);
                $('#MaintainanceType').val(getResult.MaintenanceType);
                $('#txtContractType').val(getResult.ContractTypeValue);
                //$('#txtWorkOrderStatus').val(getResult.WorkOrderStatusValue);
                $('#txtMaintainanceDetails').val(getResult.MaintenanceDetails);
                $('#primaryID').val(getResult.WorkOrderId);
                $("#Timestamp").val(getResult.Timestamp);
                $('#btnEdit').prop('disabled', false);
                $('#btnCompletionSave').prop('disabled', false);
                $('#btnPartSave').prop('disabled', false);
                $('#btnTransferSave').prop('disabled', false);
                $('#btnRescheduleSave').prop('disabled', false);
                $('#btnPPMCheckListSave').prop('disabled', false);
                $('#hdnWoSts').val(getResult.WorkOrderStatusValue);
                if (WorkOrderStatusString == "Closed") {
                    $("#formUnScheduledWorkOrder :input:not(:button)").prop("disabled", true);
                    $("#tab-2 :input:not(:button)").prop("disabled", true);
                    $("#tab-3 :input:not(:button)").prop("disabled", true);
                    $("#tab-4 :input:not(:button)").prop("disabled", true);
                    $("#tab-5 :input:not(:button)").prop("disabled", true);
                    $("#divCommonAttachment :input:not(:button)").prop("disabled", true);
                    $("#PPMCheckList :input:not(:button)").prop("disabled", true);
                    $("#aAFAdditionalInfo :input:not(:button)").prop("disabled", true);
                    $('#txtEngineer').prop('disabled', true);
                    $('#txtMaintainanceDetails').prop('disabled', true);
                    $("btnPurchasePopUpSave").hide();
                    $("btnAdditionalInfoEdit").hide();
                    $('#btnSWOPrint').show();
                }
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

// Purchase Request Popup

function PurchaseNewRow() {
    var inputpar = {
        inlineHTML: PurchaseRequestHtml(),//Inline Html
        TargetId: "#PurchaseRequestGrid",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);

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

function PurchaseRequestHtml() {

    return ' <tr class="ng-scope" style=""> <td width="20%" style="text-align: center;" data-original-title="" title=""> <div> <div> <input type="text" autocomplete="off" placeholder="Please select" required id="PurchasePartNo_maxindexval" value="" class="form-control fetchField" onkeyup="FetchdataPurchasePartNo(event,maxindexval)" onpaste="FetchdataPurchasePartNo(event,maxindexval)" change="FetchdataPurchasePartNo(event,maxindexval)" oninput="FetchdataPurchasePartNo(event,maxindexval)"> </div><input type="hidden" id="PurchaseSparePartStockRegisterId_maxindexval"/> <input type="hidden" id="PurchaseRequestId_maxindexval"/> <input type="hidden" id="PurchaseStockUpdateDetId_maxindexval"/> <div class="col-sm-12" id="divFetchPurchase_maxindexval"></div></div></td><td width="20%" style="text-align: center;"> <div> <input id="PurchasePartDescription_maxindexval" type="text" class="form-control" name="PurchasePartDescription" autocomplete="off" disabled> </div></td><td width="20%" style="text-align: center;"> <div> <input id="PurchaseItemCode_maxindexval" type="text" class="form-control" name="PurchasePartNo" autocomplete="off" disabled> </div></td><td width="20%" style="text-align: center;"> <div> <input type="text" id="PurchaseItemDescription_maxindexval" name="PurchasePartDescription" class="form-control" autocomplete="off" disabled> </div></td><td width="20%" style="text-align: center;"> <div> <input id="PurchaseQuantity_maxindexval" type="text" class="form-control Zerofirst digOnly text-right" pattern="^((?!(0))[0-9]{1,15})$" name="PurchaseQuantity" maxlength="4" required autocomplete="off"> </div></td></tr> ';
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

    for (var j = 0; j <= _index; j++) {
        var PurchasePartHiddenValue = $('#PurchaseSparePartStockRegisterId_' + j).val();
        var PurchasePartValue = $('#PurchasePartNo_' + j).val();
        if (PurchasePartValue != "" && PurchasePartHiddenValue == "") {
            $("div.errormsgcenter").text("Valid Part No. Required!");
            $('#errorMsgPurchase').css('visibility', 'visible');
            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }
    }
    var resultList = [];
    for (var i = 0; i <= _index; i++) {
        var obj = {
            PurchaseRequestId: $('#PurchaseRequestId_' + i).val(),
            PurchaseSparePartStockRegisterId: $('#PurchaseSparePartStockRegisterId_' + i).val(),
            WorkOrderId: GlobalWorkOrderId,
            PurchaseQuantity: $('#PurchaseQuantity_' + i).val()
        };
        resultList.push(obj);
    }
    PurchaseRequestsubmit(resultList);
}

function PurchaseRequestsubmit(result) {
    var obj1 = {
        WorkOrderType: 187,
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
    var wosts = $('#divWOStatus').text();
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgPurchase').css('visibility', 'hidden');

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/ScheduledWorkOrder/GetPurchaseRequest/" + primaryId)
            .done(function (result) {
                var htmlval = "";
                var sts = $('#divWOStatus').text();
                var getResult = JSON.parse(result);
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
    var sts = $('#hdnWoSts').val();
    if (wosts == "Closed") {
        $("#tab-3 :input:not(:button)").prop("disabled", true);
        $('#AddPurchaseNewRow').hide();
        $('#btnPurchasePopUpSave').hide();
    }
}

function bindDatatoPurchaseRequestgrid(list) {
    if (list.length > 0) {
        $('#PurchaseRequestGrid').empty()
        var html = '';

        $(list).each(function (index, data) {
            html = '<tr class="ng-scope" style=""> <td width="20%" style="text-align: center;" data-original-title="" title=""> <div> <div> <input type="text" autocomplete="off" placeholder="Please select" required id="PurchasePartNo_' + index + '" value="' + data.PurchasePartNo + '" class="form-control fetchField" onkeyup="FetchdataPurchasePartNo(event,' + index + ')" onpaste="FetchdataPurchasePartNo(event,' + index + ')" change="FetchdataPurchasePartNo(event,' + index + ')" oninput="FetchdataPurchasePartNo(event,' + index + ')"> </div><input type="hidden" value="' + data.PurchaseSparePartStockRegisterId + '" id="PurchaseSparePartStockRegisterId_' + index + '"/><input type="hidden" value="' + data.PurchaseRequestId + '" id="PurchaseRequestId_' + index + '"/><div class="col-sm-12" id="divFetchPurchase_' + index + '"></div></div></td><td width="20%" style="text-align: center;"><div> <input id="PurchasePartDescription_' + index + '" value="' + data.PurchasePartDescription + '" type="text" class="form-control" name="PurchasePartDescription" autocomplete="off" disabled></div></td><td width="20%" style="text-align: center;"><div> <input id="PurchaseItemCode_' + index + '" value="' + data.PurchaseItemCode + '" type="text" class="form-control" name="PurchaseItemCode" autocomplete="off" disabled></div></td><td width="20%" style="text-align: center;"><div> <input type="text" id="PurchaseItemDescription_' + index + '" value="' + data.PurchaseItemDescription + '" name="PurchasePartDescription" class="form-control" autocomplete="off" disabled></div></td><td width="20%" style="text-align: center;"><div> <input id="PurchaseQuantity_' + index + '" value="' + data.PurchaseQuantity + '" type="text" maxlength="4" class="form-control Zerofirst digOnly text-right" pattern="^((?!(0))[0-9]{1,15})$" name="PurchaseQuantity" required autocomplete="off"></div></td></tr>';
            $('#PurchaseRequestGrid').append(html);
        });
        var mapIdproperty = ["PurchasePartNo-PurchasePartNo_", "PurchasePartDescription-PurchasePartDescription_", "PurchaseItemCode-PurchaseItemCode_", "PurchaseItemDescription-PurchaseItemDescription_", "PurchaseQuantity-PurchaseQuantity_"];
        var htmltext = PurchaseRequestHtml();
    }
    formInputValidation("form");

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


//******************************* Schedule Report Print *************************

function getScheduleWorkOrderPrintReport() {
    var primaryId = $('#primaryID').val();
    if (primaryId == "" || primaryId == null || primaryId == "null" || primaryId == 0 || primaryId == "0") {
        bootbox.alert("Schedule Work Order not allow to print");
    }
    else {
        window.open("/bems/scheduleworkorderreport/index/" + primaryId, 'Scheduled Work Order Print', "height=500,width=1000");
        //window.location.href = "/bems/scheduleworkorderreport/index/" + primaryId;
    }
}

function getPPMCheckListPrintReport() {
    var primaryId = $('#primaryID').val();
    var checklistId = $('#PPMChecklistNo').val();
    if (checklistId == "" || checklistId == null || checklistId == "null" || checklistId == 0 || checklistId == "0") {
        bootbox.alert("Please select PPMCheckList No.");
    }
    else {
        // window.location.href = "/bems/PPMCheckListPrint/index/" + primaryId + "/" + checklistId;
        window.location.href = "/bems/ppmchecklistprint/index?primaryId=" + primaryId + "&checklistId=" + checklistId;
    }
}


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

function CalculatePassOrFail(index) {
    var SetValue = $('#SetValues_' + index).val();
    var Limit = $('#LimitTolerance_' + index).val();
    //var Value = $('#PPMCheckListValue_' + index).val();
    var val12 = $('#PPMCheckListValue_' + index).val();
    var Value = (val12 == null || val12 == '') ? '' : val12.split(',').join('');
    //var Value = val12.split(',').join('');
    SetValue = parseInt(SetValue);
    Limit = parseInt(Limit);
    if (Value != "") {
        //  var diff = SetValue - Limit;
        var Plusdiff = SetValue + Limit;
        var Minusdiff = SetValue - Limit;

        if (Value >= Minusdiff && Value <= Plusdiff) {
            $('#PPMCheckListStatus2_' + index).val(338);
        }
        else {
            $('#PPMCheckListStatus2_' + index).val(339);
        }
    }
    else {
        $('#PPMCheckListStatus2_' + index).val(340);
    }
}

function CheckLink() {
    window.location.replace("/bems/assettracker");
}




////print form js ////
function printDiv(divName) {
    
    // generatePDF();
    PrintRDL();
    var iframe = document.getElementById('myIframe');

    var urls = document.getElementById('myIframe').src;
    window.open(urls);
    //domtoimage.toPng(document.getElementById('divCommonHistory1'))
    //    .then(function (blob) {
    //        var pdf = new jsPDF('l', 'pt', [$('#divCommonHistory1').width(), $('#divCommonHistory1').height()]);

    //        pdf.addImage(blob, 'PNG', 0, 0, $('#divCommonHistory1').width(), $('#divCommonHistory1').height());
    //        pdf.save("Print.pdf");

    //        that.options.api.optionsChanged();
    //    });

}


$('#cmd2').click(function () {
    var options = {
        //'width': 800,
    };
    var pdf = new jspdf('p', 'pt', 'a4');
    pdf.addhtml($("#content2"), -1, 220, options, function () {
        pdf.save('admit_card.pdf');
    });
});
$('#downloadPDF').click(function () {
    // generatePDF();
    // window.open('https://play.google.com/store/apps/details?id=com.drishya');
    //domtoimage.toPng(document.getElementById('content2'))
    //    .then(function (blob) {
    //        var pdf = new jsPDF('l', 'pt', [$('#content2').width(), $('#content2').height()]);

    //        pdf.addImage(blob, 'PNG', 0, 0, $('#content2').width(), $('#content2').height());
    //        pdf.save("test.pdf");

    //        that.options.api.optionsChanged();
    //    });
});

function generatePDF() {
    // Choose the element that our invoice is rendered in.
    const element = document.getElementById("divCommonHistory11");
    // Choose the element and save the PDF for our user.
    html2pdf().from(element).save();
}

////print form js ////