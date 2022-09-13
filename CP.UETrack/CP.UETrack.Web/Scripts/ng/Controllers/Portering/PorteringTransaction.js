window.PorteringStatusGlobal = [];
window.GlobalFacilityLovs = [];
window.GlobalMovementCategoryLovs = [];
var CurrentDateGloabl;
$(document).ready(function () {
    $('#txtUserLocationCode').prop('disabled', true);
    $('#MovementCategory').prop('disabled', true);
    $('#spnPopup-Location,.locReq').hide();
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnVerify').hide();
    $('#btnReject').hide();
    $('#btnApprove').hide();
    $('#myPleaseWait').modal('show');
    $('.location,.supplier').hide();
    $('#ToLocation_1,#txtUserLocationCode').removeAttr('required');
    $('#VendorTypeId,#VendorNameId').removeAttr('required');
    $('#txtMaintenanceWorkNo').prop('disabled', true);
    $('#WonDiv').hide();
    $('#movementlavelid').html("Movement Category <span class='red'>*</span>");
    var hasVerifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Verify'");
    var hasApprovePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");
    if (hasVerifyPermission || hasApprovePermission) {
        $('#btnCancel').hide();
       // $('#btnApprove').show();
    }
    else {
        $('#btnCancel').show();
    }
    DisbaleToLocations();
    formInputValidation("PorteringFormId");
    var CurDate = GetCurrentDate();
    CurrentDateGloabl = CurDate;
    $('#Adjustdate').val(CurDate);
    $.get("/api/Portering/Load")
    .done(function (result) {
        var loadResult = JSON.parse(result);
        // $('#PorteringDate').val(DateFormatter(loadResult.PorteringDate));
        $('#PorteringDate').val(CurDate);
        window.GlobalMovementCategoryLovs = loadResult.MovementCategoryLovs;
        var MovementCatList = Enumerable.From(loadResult.MovementCategoryLovs).Where(function (x) { return (x.LovId != 240) }).ToArray();

        $.each(MovementCatList, function (index, value) {
            $('#MovementCategory').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(loadResult.RequestTypeLovs, function (index, value) {
            $('#RequestTypeLovId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(loadResult.WorkFlowStatusLovs, function (index, value) {
            $('#CurrentWorkFlowId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        window.PorteringStatusGlobal = loadResult.PorteringStatusLovs;
        $.each(loadResult.ModeOfTransportLovs, function (index, value) {
            $('#ModeOfTransport,#MvmtModeOfTransport').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        window.GlobalFacilityLovs = loadResult.FromFacilityLovs;
        $.each(loadResult.FromFacilityLovs, function (index, value) {
            $('#ToLocation_1').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(loadResult.WarrantyCategoryLovs, function (index, value) {
            $('#VendorTypeId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });

        $('#CurrentFacilityId').val(loadResult.FacilityId);
        var bookingId = $('#hdnLoanerTestEquipmentBookingId').val();

        if (bookingId != "0" && bookingId != null && bookingId != undefined && bookingId != "" && bookingId != 0) {
            $.get("/api/Portering/GetLoanerBookingRecord/" + bookingId)
         .done(function (result) {
             var res = JSON.parse(result);
             $('#MovementCategory').empty();
             $('#MovementCategory').append('<option value="' + "null" + '">' + "Select" + '</option>');
             $.each(window.GlobalMovementCategoryLovs, function (index, value) {
                 $('#MovementCategory').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
             });
             $('#btnEdit').show();
             $('#btnDelete,#btnSave,#btnVerify,#btnSaveandAddNew,#btnReject,#btnApprove').hide();
             $('#txtAssetNo,#txtMaintenanceWorkNo,#ModeOfTransport,#txtCompanyStaffName').attr('disabled', true);
             $('#AssetNoDiv,#WonDiv,#companypopup').hide();
             $('#FromCustomerId').val(res.FromCustomerId);
             $('#FromFacilityId').val(res.FromFacilityId);
             $('#FromBlockId').val(res.FromBlockId);
             $('#FromLevelId').val(res.FromLevelId);
             $('#FromUserAreaId').val(res.FromUserAreaId);
             $('#FromUserLocationId').val(res.FromUserLocationId);
             $('#FromFacilityName').val(res.FacilityName);
             $('#FromBlockName').val(res.BlockName);
             $('#FromLevelName').val(res.LevelName);
             $('#FromUserAreaName').val(res.UserAreaName);
             $('#FromUserLocationName').val(res.UserLocationName);
             $('#MovementCategory').val(res.MovementCategory);
             $('#hdnAssetId').val(res.AssetId);
             $('#txtAssetNo').val(res.AssetNo);
             $('#hdnWorkOrderId').val(res.hdnWorkOrderId);
             $('#txtMaintenanceWorkNo').val(res.WorkOrderNo);
             $('#ToLocation_1').val(res.ToFacilityId);

             if (res.MovementCategory == "242" || MovementCategory == 242) {
                 $('#VendorTypeId').val(res.SupplierLovId);
                 $.each(res.VendorNameLovs, function (index, value) {
                     $('#VendorNameId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                 });
                 $('#VendorNameId').val(res.SupplierId);
                 $('.supplier').show();
                 $('.location').hide();
             }
             else {
                 $('.supplier').hide();
                 $('.location').show();
                 $('#ToLocation_2').val(res.ToBlockId);
                 $('#ToLocation_3').val(res.ToLevelId);
                 $('#ToLocation_4').val(res.ToUserAreaId);
                 $('#ToLocation_5').val(res.ToUserLocationId);
                 $('#txtUserLocationCode').val(res.ToUserLocationCode);
                 $('#txtUserLocationName').val(res.ToUserLocationName);
                 $('#txtUserAreaCode').val(res.ToUserAreaCode);
                 $('#txtUserAreaName').val(res.ToUserAreaName);
                 $('#txtUserLevelCode').val(res.ToLevelCode);
                 $('#txtUserLevelName').val(res.ToLevelName);
                 $('#txtBlockCode').val(res.ToBlockCode);
                 $('#txtBlockName').val(res.ToBlockName);
                 $('#VendorTypeId,#VendorNameId').attr('disabled', true);
                 $('#ToLocation_1').attr('disabled', true);
                 $('#MovementCategory,#RequestTypeLovId').attr('disabled', true);
             }
             $('#hdnCompanyStaffId').val(res.RequestorId);
             $('#txtCompanyStaffName').val(res.RequestorName);
             $('#txtDesignation').val(res.Position);
             $('#RequestTypeLovId').val(243);
             $('#CurrentWorkFlowId').val(247);
             $('#ModeOfTransport').val(217);
         }).fail(function () {
             $('#myPleaseWait').modal('hide');
             $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
             $('#errorMsg').css('visibility', 'visible');
         });
        }
        $('#myPleaseWait').modal('hide');
    })
  .fail(function (response) {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
      $('#errorMsg').css('visibility', 'visible');
  });

    //------------------------Cascading List for toList ----------------------------
    $('[id^=ToLocation_]').change(function () {
        var id = $(this).attr('id');
        var locationNo = id.substring(id.indexOf('_') + 1);
        GetLocationList(locationNo);
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
    if (ID == null || ID == undefined || ID == 0 || ID == '' || ID == "") {
        $("#jQGridCollapse1").click();
    }
    else {
        LinkClicked(ID);
    }
    // **** Query String to get ID  End****\\\

    $('#PorteringStatusId').click(function () {
        if ($('#PorteringStatusId').val() != "null") {
            $('#PorteringStatusId').parent().removeClass('has-error');
        }
    });

    $('#MovementCategory').change(function () {
        var movementType = $('#MovementCategory').val();
        var AssetId = $('#hdnAssetId').val();
        $('#ToLocation_2,#ToLocation_3,#ToLocation_4,#ToLocation_5').val('');
        $('#txtUserLocationCode').val('');
        $('#txtUserLocationCode').parent().removeClass('has-error');
        $('#VendorNameId,#VendorTypeId').parent().removeClass('has-error');
        $('#txtUserLocationName').val('');
        $('#txtUserAreaCode').val('');
        $('#txtUserAreaName').val('');
        $('#txtUserLevelCode').val('');
        $('#txtUserLevelName').val('');
        $('#txtBlockCode').val('');
        $('#txtBlockName').val('');
        $("#ToLocation_1").find("option:not(:first)").remove();
        if (AssetId == null || AssetId == 0 || AssetId == "0" || AssetId == "null" || AssetId == undefined) {
            bootbox.alert("Please select Asset No. / Loaner / Test Equipment No. / Work Order No.");
            $('#MovementCategory').val("null");
        }
        else {
            AssetMovement(movementType, AssetId);
        }
    });

    function AssetMovement(movementType, AssetId) {
        ClearDropDownFields(6);
        if (movementType == 242 || movementType == "242") {
            $('#txtUserLocationCode').prop('disabled', true);
            $('#spnPopup-Location').hide();
            $('#VendorTypeId,#VendorNameId').attr('disabled', false);
            $('#ToLocation_1').attr('disabled', true);
            $('#ToLocation_1').val("null");
            $('#ToLocation_1').removeAttr('required');
            $('#txtUserLocationCode').removeAttr('required');
            $('#VendorTypeId,#VendorNameId').attr('required', true);
            $('.supplier').show();
            $('.location').hide();
        }
        else if (movementType == 239 || movementType == 240 || movementType == 241 || movementType == 327) {

            $('#VendorTypeId,#VendorNameId').val('null');
            $('#ToLocation_1').attr('disabled', false);
            $('#VendorTypeId,#VendorNameId').attr('disabled', true);
            $('#ToLocation_1').attr('required', true);
            $('#txtUserLocationCode').attr('required', true);
            $('#VendorTypeId,#VendorNameId').removeAttr('required');
            $('#VendorTypeId').parent().removeClass('has-error');
            $('.supplier').hide();
            $('.location').show();
            if (movementType == 239 || movementType == 327 || movementType == 240) {
                $('#txtUserLocationCode').prop('disabled', false);
                $('#txtUserLocationCode').attr('required', true);
                $('#spnPopup-Location').show();
                $('#ToLocation_1').empty();
                $('#ToLocation_1').append('<option value="' + "null" + '">' + "Select" + '</option>');
                $.each(window.GlobalFacilityLovs, function (index, value) {
                    $('#ToLocation_1').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                });
                $('#ToLocation_1').val($('#CurrentFacilityId').val());
                $('#ToLocation_1').prop('disabled', true);
                GetLocationList(1);
            }
            else if (movementType == 241) {
                $('#ToLocation_1').empty();
                $('#ToLocation_1').append('<option value="' + "null" + '">' + "Select" + '</option>');
                $.each(window.GlobalFacilityLovs, function (index, value) {
                    $('#ToLocation_1').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                });
                $('#txtUserLocationCode').prop('disabled', true);
                $('#spnPopup-Location').hide();
                $('#ToLocation_1').val("null");
                $('#ToLocation_1').prop('disabled', false);
            }
            else {
                $('#txtUserLocationCode').prop('disabled', true);
                $('#spnPopup-Location').hide();
                $('#ToLocation_1').val("null");
                $('#ToLocation_1').prop('disabled', false);
            }
        }
        else {
            DisbaleToLocations();
            $('#txtUserLocationCode').removeAttr('required');
            $('#ToLocation_1').removeAttr('required');
            $('#VendorTypeId,#VendorNameId').removeAttr('required');
            $('.supplier').hide();
            $('.location').hide();
            ClearDropDownFields(6);
        }
    }

    function DisbaleToLocations() {
        $('#txtUserLocationCode').prop('disabled', true);
        $('#spnPopup-Location').hide();
        $('#ToLocation_1').attr('disabled', true);
        $('#VendorTypeId,#VendorNameId').attr('disabled', true);
    }

    $('#VendorTypeId').on('change', function () {
        var SupplierCategoryid = $('#VendorTypeId').val();
        var AssetId = $('#hdnAssetId').val();
        if (SupplierCategoryid != null && SupplierCategoryid != 0 && SupplierCategoryid != undefined && SupplierCategoryid != "0" && AssetId != null && AssetId != "0" && AssetId != 0 && AssetId != undefined) {
            $("#VendorNameId").find("option:not(:first)").remove();
            $.get("/api/Portering/GetVendorInfo/" + SupplierCategoryid + "/" + AssetId)
               .done(function (result) {
                   var getResult = JSON.parse(result);
                   $.each(getResult.VendorNameLovs, function (index, value) {
                       $('#VendorNameId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                   });
                   $('#myPleaseWait').modal('hide');
               })
              .fail(function () {
                  $('#myPleaseWait').modal('hide');
              });
        }
        else {
            $("#VendorNameId").find("option:not(:first)").remove();
        }
    });


    $('#PorteringStatusId').on('change', function () {
        var PorteringStatusId = $('#PorteringStatusId').val();
        var transportMode = $('#ModeOfTransport').val();
        if (PorteringStatusId != null && PorteringStatusId != 0 && PorteringStatusId != "null" && (transportMode == "217" || transportMode == 217)) {
            $('#AssignPorteringStatusId').val(PorteringStatusId);
        }
        else {
            $('#AssignPorteringStatusId').val("null");
        }
    });

    //------------------------------------------------------------------

    //********************************************************************** Save ************************************************************************// 
    $(".bookButton").click(function () {
        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $("div.errormsgcenter1").text("");
        $("div.errormsgcenter3").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $('#errorMsg1').css('visibility', 'hidden');
        $('#errorMsg3').css('visibility', 'hidden');
        var movementCategoryId = $('#MovementCategory').val();
        var hdnLoanerTestEquipmentBookingId = $('#hdnLoanerTestEquipmentBookingId').val();

        var buttonName = $(this).attr('Id');
        var workflowStatus;
        if (buttonName == "btnSave" || buttonName == "btnSaveandAddNew") {
            workflowStatus = 246;
        }
        else if (buttonName == "btnApprove" || buttonName == "btnEditMvmt" || buttonName == "btnEditreceipt") {
            workflowStatus = 247;
        }
        else if (buttonName == "btnReject") {
            workflowStatus = 248;
        }
        else if (buttonName == "btnVerify") {

            if (movementCategoryId == "239" || movementCategoryId == 239) {
                workflowStatus = 247;
            }
            else {
                workflowStatus = 309;
            }
        }
        else if (buttonName == "btnEdit") { //extention

            if (hdnLoanerTestEquipmentBookingId != null && hdnLoanerTestEquipmentBookingId != '' && hdnLoanerTestEquipmentBookingId != 0 && hdnLoanerTestEquipmentBookingId != '0') {
                workflowStatus = 247;
            }
            else {
                workflowStatus = 246;
            }
        }
        var id = $(this).attr('id');
        if (id == "btnSave" || id == "btnEdit" || id == "btnSaveandAddNew") {
            var isFormValid = formInputValidation("PorteringFormId", 'save');
            if (!isFormValid || ($('#hdnAssetId').val() == 0 || $('#hdnAssetId').val() == "0")) {
                if ($('#hdnAssetId').val() == 0 || $('#hdnAssetId').val() == "0") {
                    $('#txtAssetNo').parent().addClass('has-error');
                }
                $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');
                $('#btnSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
                return false;
            }
            else if ($('#hdnAssetId').val() == 0 || $('#hdnAssetId').val() == "0") {
                $("div.errormsgcenter").text("Valid Asset No. is required");
                $('#txtAssetNo').parent().addClass('has-error');
                $('#errorMsg').css('visibility', 'visible');
                $('#btnSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
                return false;
            }
            else if ($('#hdnCompanyStaffId').val() == 0 || $('#hdnCompanyStaffId').val() == "0") {
                $("div.errormsgcenter").text("Valid Requestor Name is required");
                $('#txtCompanyStaffName').parent().addClass('has-error');
                $('#errorMsg').css('visibility', 'visible');
                $('#btnSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }
        else if (id == "btnEditMvmt") {
            var isFormValid = formInputValidation("MovementFormId", 'save');
            if (!isFormValid) {
                $("div.errormsgcenter1").text(Messages.INVALID_INPUT_MESSAGE);
                $('#errorMsg1').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
            if (($('#ModeOfTransport').val() == "217" || $('#ModeOfTransport').val() == 217) && ($('#hdnAssignPorterId').val() == 0 || $('#hdnAssignPorterId').val() == "0")) {
                $('#txtAssignPorter').parent().addClass('has-error');
                $("div.errormsgcenter1").text("Valid Assign Porter is required");
                $('#errorMsg1').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }
        else if (id == "btnEditreceipt") {

            var isFormValid = formInputValidation("ReceiptFormId", 'save');
            if (!isFormValid) {
                $("div.errormsgcenter3").text(Messages.INVALID_INPUT_MESSAGE);
                $('#errorMsg3').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
            if ($('#hdnReceivedById').val() == 0 || $('#hdnReceivedById').val() == "0") {
                $('#txtReceivedBy').parent().addClass('has-error');
                $("div.errormsgcenter3").text("Valid Received By  is required");
                $('#errorMsg3').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }

        if (movementCategoryId == "327" || movementCategoryId == 327) {
            var msg = "Are you sure you want to update the Current location?";
            bootbox.confirm(msg, function (Confirm) {
                if (Confirm) {
                    workflowStatus = 247;
                    Submit(workflowStatus, buttonName);
                }
                else {
                    bootbox.hideAll();
                    return false;
                }
            });
        }
        else {
            Submit(workflowStatus, buttonName);
        }
    });


    function Submit(workflowStatus, buttonName) {
        var primaryId = $("#primaryID").val();
        var SaveObj = {
            PorteringId: primaryId != null ? primaryId : 0,
            AssetId: $('#hdnAssetId').val(),
            AssetNo: $('#txtAssetNo').val(),
            WorkOrderId: $('#hdnWorkOrderId').val(),
            FromCustomerId: $('#FromCustomerId').val(),
            FromFacilityId: $('#FromFacilityId').val(),
            FromBlockId: $('#FromBlockId').val(),
            FromLevelId: $('#FromLevelId').val(),
            FromUserAreaId: $('#FromUserAreaId').val(),
            FromUserLocationId: $('#FromUserLocationId').val(),
            RequestorId: $('#hdnCompanyStaffId').val(),
            RequestTypeLovId: $('#RequestTypeLovId').val(),
            MovementCategory: $('#MovementCategory').val(),
            ModeOfTransport: $('#ModeOfTransport').val(),
            ToCustomerId: $('#FromCustomerId').val(),
            ToFacilityId: $('#ToLocation_1').val(),
            ToBlockId: $('#ToLocation_2').val(),
            ToLevelId: $('#ToLocation_3').val(),
            ToUserAreaId: $('#ToLocation_4').val(),
            ToUserLocationId: $('#ToLocation_5').val(),
            AssignPorterId: $('#hdnAssignPorterId').val(),
            ConsignmentNo: $('#ConsignmentNo').val(),
            PorteringStatus: $('#PorteringStatusId').val(),
            CurrentWorkFlowId: workflowStatus,
            Timestamp: primaryId != null ? $('#Timestamp').val() : "",
            PorteringDate: $('#PorteringDate').val(),
            IsLoaner: $('#IsLoaner').val(),
            Remarks: $('#Remarks').val(),
            ReceivedBy: $('#hdnReceivedById').val(),
            SupplierId: $('#VendorNameId').val(),
            SupplierLovId: $('#VendorTypeId').val(),
            ConsignmentDate: $('#ConsignmentDate').val(),
            WFStatusApprovedDate: $('#WFStatusApprovedDate').val(),
            ScanAsset: $('#ScanAsset').val(),
            CourierName: $('#CourierName').val(),
            LoanerTestEquipmentBookingId: $('#hdnLoanerTestEquipmentBookingId').val(),
        };


        var jqxhr = $.post("/api/Portering/add", SaveObj, function (response) {
            var result = JSON.parse(response);
            $('#txtAssetNo,#txtMaintenanceWorkNo,#ModeOfTransport').attr('disabled', true);
            $('#AssetNoDiv,#WonDiv').hide();
            $('#primaryID').val(result.PorteringId);
            $('#Timestamp').val(result.Timestamp);
            $('#hdnAttachId').val(result.HiddenId);
            $("#grid").trigger('reloadGrid');
            $('#PorteringNo').val(result.PorteringNo);
            $('#btnSave').hide();
            $('#btnEdit').hide();
            $('#btnSaveandAddNew').hide()
            $('#btnVerify').hide();
            $('#btnReject').hide();
            $('#btnApprove').hide();
            BindPorteringDate(result);
            var MovementCategory = $('#MovementCategory').val();
            var hdnPorteringStatus = $('#hdnPorteringStatusId').val();
            if (MovementCategory != 241 && MovementCategory != "241") {
                if (hdnPorteringStatus == '' || hdnPorteringStatus == null || hdnPorteringStatus == '0') {
                    $('#PorteringStatusId,#AssignPorteringStatusId').val(250);
                }
                else {
                    $('#PorteringStatusId,#AssignPorteringStatusId').val(hdnPorteringStatus);
                }
                if (hdnPorteringStatus == '' || hdnPorteringStatus == null) {

                    $('#btnEditMvmt').show();
                    $('#btnCancelMvmt').show();
                }
                else {
                    $('#btnEditMvmt').hide();
                    $('#btnCancelMvmt').hide();
                    $('#spnPopup-assignporter').hide();
                    $("#MovementFormId :input:not(:button)").prop("disabled", true);
                }
            }
            else {
                if (hdnPorteringStatus == '' || hdnPorteringStatus == null || hdnPorteringStatus == '0') {
                    $('#PorteringStatusId,#AssignPorteringStatusId').val(252);
                }
                else {
                    $('#PorteringStatusId,#AssignPorteringStatusId').val(hdnPorteringStatus);
                }
                if (hdnPorteringStatus == '' || hdnPorteringStatus == null) {

                    $('#btnEditMvmt').show();
                    $('#btnCancelMvmt').show();
                }
                else {
                    $('#btnEditMvmt').hide();
                    $('#btnCancelMvmt').hide();
                    $('#spnPopup-assignporter').hide();
                    $("#MovementFormId :input:not(:button)").prop("disabled", true);
                }
            }

            $(".content").scrollTop(0);
            showMessage('Portering', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);
            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            if (buttonName == "btnSaveandAddNew") {
                ClearFields();
            }
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
    if (errorMessage == 'Portering Date cannot be Future Date') {
        $('#PorteringDate').parent().addClass('has-error');
    }
    if (errorMessage == "Consignment Date should be greater than Asset Tracker Date") {
        $("div.errormsgcenter1").text("Consignment Date should be greater than Proposed Date");
        $('#errorMsg1').css('visibility', 'visible');
    }
    else {
        $("div.errormsgcenter").text(errorMessage);
        $('#errorMsg').css('visibility', 'visible');
    }
    $('#btnSave').attr('disabled', false);
    $('#myPleaseWait').modal('hide');
});
    }

    //------------------------Fetch----------------------------//
    var AssetNoFetch = {
        SearchColumn: 'txtAssetNo-AssetNo',//Id of Fetch field
        ResultColumns: ["AssetId-Primary Key", 'AssetNo-Asset No.', 'FacilityName-Facility Name'],
        FieldsToBeFilled: ["hdnAssetId-AssetId", "IsLoaner-IsLoaner", "txtAssetNo-AssetNo", "FromCustomerId-CustomerId", "FromFacilityId-FacilityId", "FromBlockId-BlockId", "FromLevelId-LevelId", "FromUserAreaId-UserAreaId", "FromUserLocationId-UserLocationId", "FromFacilityName-FacilityName", "FromBlockName-BlockName", "FromLevelName-LevelName", "FromUserAreaName-UserAreaName", "FromUserLocationName-UserLocationName", ]
    };

    $('#txtAssetNo').on('input propertychange paste keyup', function (event) {
        $('#hdnWorkOrderId').val('');
        $('#txtMaintenanceWorkNo').val('');
        DisplayFetchResult('divFetch1', AssetNoFetch, "/api/Fetch/PorteringAssetNoFetch", "UlFetch1", event, 1);//1 -- pageIndex
    });

    var WorkOrderNoFetch = {
        SearchColumn: 'txtMaintenanceWorkNo-MaintenanceWorkNo',//Id of Fetch field
        ResultColumns: ["WorkOrderId-Primary Key", 'MaintenanceWorkNo-Maintenance Work No.'],
        FieldsToBeFilled: ["IsLoaner-IsLoaner", "hdnWorkOrderId-WorkOrderId", "txtMaintenanceWorkNo-MaintenanceWorkNo", "FromCustomerId-CustomerId", "FromFacilityId-FacilityId", "FromBlockId-BlockId", "FromLevelId-LevelId", "FromUserAreaId-UserAreaId", "FromUserLocationId-UserLocationId", "FromFacilityName-FacilityName", "FromBlockName-BlockName", "FromLevelName-LevelName", "FromUserAreaName-UserAreaName", "FromUserLocationName-UserLocationName"],
        AdditionalConditions: ["AssetId-hdnAssetId"],
    };

    $('#txtMaintenanceWorkNo').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch2', WorkOrderNoFetch, "/api/Fetch/PorteringWorkOrderNoFetch", "UlFetch2", event, 1);//1 -- pageIndex
    });


    var CompanyStaffFetchObj = {
        SearchColumn: 'txtCompanyStaffName-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name', 'Designation-Designation'],
        FieldsToBeFilled: ["hdnCompanyStaffId-StaffMasterId", "txtCompanyStaffName-StaffName", "txtDesignation-Designation"]
    };
    $('#txtCompanyStaffName').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch3', CompanyStaffFetchObj, "/api/Fetch/FetchRecords", "UlFetch3", event, 1);//1 -- pageIndex
    });



    var PorterObj = {
        SearchColumn: 'txtAssignPorter-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Porter Name'],
        FieldsToBeFilled: ["hdnAssignPorterId-StaffMasterId", "txtAssignPorter-StaffName"]
    };
    $('#txtAssignPorter').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch4', PorterObj, "/api/Fetch/CompanyStaffFetch", "UlFetch4", event, 1);//1 -- pageIndex
    });

    var ReceivedByObj = {
        SearchColumn: 'txtReceivedBy-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Porter Name', 'Designation-Designation'],
        FieldsToBeFilled: ["hdnReceivedById-StaffMasterId", "txtReceivedBy-StaffName", "ReceivedPosition-Designation"]
    };
    $('#txtReceivedBy').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch5', ReceivedByObj, "/api/Fetch/FetchRecords", "UlFetch5", event, 1);//1 -- pageIndex
    });
    //--------------------------------------------------------------------
    //------------------------Search----------------------------

    // User Area Code fetch
    var UserLocationFetchObj = {
        SearchColumn: 'txtUserLocationCode-UserLocationCode',//Id of Fetch field
        ResultColumns: ["UserLocationId-Primary Key", 'UserLocationCode- Location Code', 'UserLocationName-Location Name'],//Columns to be displayed
        FieldsToBeFilled: ["ToLocation_5-UserLocationId", "txtUserLocationCode-UserLocationCode", "txtUserLocationName-UserLocationName",
                                "ToLocation_4-UserAreaId", "txtUserAreaCode-UserAreaCode", "txtUserAreaName-UserAreaName",
                                "ToLocation_3-LevelId", "txtUserLevelCode-LevelCode", "txtUserLevelName-LevelName",
                                "ToLocation_2-BlockId", "txtBlockCode-BlockCode", "txtBlockName-BlockName"


        ],//id of element - the model property
        AdditionalConditions: ["FacilityId-ToLocation_1"]
    };
    $('#txtUserLocationCode').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch7', UserLocationFetchObj, "/api/Fetch/BookingLocationFetch", "UlFetch7", event, 1);//1 -- pageIndex
    });
    // User Area Code Search

    var UserLocationSearchhObj = {
        Heading: "To Location Details",//Heading of the popup
        SearchColumns: ['UserLocationCode-User Location Code', 'UserLocationName-User Location Name'],//ModelProperty - Space seperated label value
        ResultColumns: ["UserLocationId-Primary Key", 'UserLocationCode-Location Code', 'UserLocationName-Location Name',
                         'UserAreaCode-Area Code', 'UserAreaName-Area Name',
                         'LevelCode-Level Code', 'LevelName-Level Name',
                         'BlockCode-Block Code', 'BlockName-Block Name'
        ],//Columns to be returned for display
        FieldsToBeFilled: ["ToLocation_5-UserLocationId", "txtUserLocationCode-UserLocationCode", "txtUserLocationName-UserLocationName",
                               "ToLocation_4-UserAreaId", "txtUserAreaCode-UserAreaCode", "txtUserAreaName-UserAreaName",
                               "ToLocation_3-LevelId", "txtUserLevelCode-LevelCode", "txtUserLevelName-LevelName",
                               "ToLocation_2-BlockId", "txtBlockCode-BlockCode", "txtBlockName-BlockName"
        ],
        AdditionalConditions: ["FacilityId-ToLocation_1"]
    };

    $('#spnPopup-Location').click(function () {
        DisplaySeachPopup('divSearchPopup', UserLocationSearchhObj, "/api/Search/BookingLocationSearch");
    });

    var AssetSearchObj = {
        Heading: "Asset Details",
        SearchColumns: ['AssetNo-Asset No'],
        //ModelProperty - Space seperated label value
        ResultColumns: ['AssetId-Primary Key', 'FacilityName-Facility Name', 'AssetNo-Asset No.', "BookingStartDate- Booking Start Date", "BookingEndDate-Booking End Date"],
        FieldsToBeFilled: ["hdnAssetId-AssetId", "IsLoaner-IsLoaner", "txtAssetNo-AssetNo", "FromCustomerId-CustomerId", "FromFacilityId-FacilityId", "FromBlockId-BlockId", "FromLevelId-LevelId", "FromUserAreaId-UserAreaId", "FromUserLocationId-UserLocationId", "FromFacilityName-FacilityName", "FromBlockName-BlockName", "FromLevelName-LevelName", "FromUserAreaName-UserAreaName", "FromUserLocationName-UserLocationName", ]
    };
    $('#spnPopup-asset').click(function () {
        $('#hdnWorkOrderId').val('');
        $('#txtMaintenanceWorkNo').val('');
        DisplaySeachPopup('divSearchPopup', AssetSearchObj, "/api/Search/PorteringAssetNoSearch");
    });
    var WorkorderSearchObj = {
        Heading: "Work Order Details",
        SearchColumns: ['MaintenanceWorkNo-Work Order No.'],//ModelProperty - Space seperated label value
        ResultColumns: ["WorkOrderId-Primary Key", 'MaintenanceWorkNo-Work Order No.', 'AssetNo-Asset No', 'FacilityName-Facility Name', "BookingStartDate- Booking Start Date", "BookingEndDate-Booking End Date"],
        FieldsToBeFilled: ["IsLoaner-IsLoaner", "hdnWorkOrderId-WorkOrderId", "txtMaintenanceWorkNo-MaintenanceWorkNo", "FromCustomerId-CustomerId", "FromFacilityId-FacilityId", "FromBlockId-BlockId", "FromLevelId-LevelId", "FromUserAreaId-UserAreaId", "FromUserLocationId-UserLocationId", "FromFacilityName-FacilityName", "FromBlockName-BlockName", "FromLevelName-LevelName", "FromUserAreaName-UserAreaName", "FromUserLocationName-UserLocationName"],
        AdditionalConditions: ["AssetId-hdnAssetId"],
    };

    $('#spnPopup-won').click(function () {
        DisplaySeachPopup('divSearchPopup', WorkorderSearchObj, "/api/Search/PorteringWorkOrderNoSearch");
    });

    var CompanySearchObj = {
        Heading: "Requestor Name",//Heading of the popup
        SearchColumns: ['StaffName-Staff Name'],//ModelProperty - Space seperated label value
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name', 'Designation-Designation'],//Columns to be returned for display
        FieldsToBeFilled: ["hdnCompanyStaffId-StaffMasterId", "txtCompanyStaffName-StaffName", "txtDesignation-Designation"]
    };

    $('#spnPopup-compStaff').click(function () {
        DisplaySeachPopup('divSearchPopup', CompanySearchObj, "/api/Search/PopupSearch");
    });

    var PorterearchObj = {
        Heading: "Assign Porter",//Heading of the popup
        SearchColumns: ['StaffName-Assign Porter Name'],//ModelProperty - Space seperated label value
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Porter Name'],
        FieldsToBeFilled: ["hdnAssignPorterId-StaffMasterId", "txtAssignPorter-StaffName"]
    };

    $('#spnPopup-assignporter').click(function () {
        DisplaySeachPopup('divSearchPopup', PorterearchObj, "/api/Search/CompanyStaffSearch");
    });

    var ReceivedSearchObj = {
        Heading: "Received By",//Heading of the popup
        SearchColumns: ['StaffName-Received By'],//ModelProperty - Space seperated label value
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Porter Name', 'Designation-Designation'],
        FieldsToBeFilled: ["hdnReceivedById-StaffMasterId", "txtReceivedBy-StaffName", "ReceivedPosition-Designation"]
    };

    $('#spnPopup-received').click(function () {
        DisplaySeachPopup('divSearchPopup', ReceivedSearchObj, "/api/Search/PopupSearch");
    });

    //calls click event after a certain time
    $('#hdnAssetId').change(function () {
        var CurrentFacilityId = $('#CurrentFacilityId').val();
        var assetFacilityID;
        var assetId = $('#hdnAssetId').val();
        if (assetId != '' && assetId != 0 && assetId != '0') {
            $('#MovementCategory').prop('disabled', false);
            $('#txtUserLocationCode').prop('disabled', false);
            $('#spnPopup-Location').show();
            $('#txtMaintenanceWorkNo').prop('disabled', false);
            $('#WonDiv').show();
            setTimeout(function () {
                assetFacilityID = $('#FromFacilityId').val();
                if (assetFacilityID == CurrentFacilityId) {
                    $('#MovementCategory').val(239);
                    $('#movementlavelid').html("Movement Category");
                    AssetMovement(239, assetId);
                }
                else {
                    $('#movementlavelid').html("Movement Category <span class='red'>*</span>");
                    $('#MovementCategory').val(240);
                    AssetMovement(240, assetId);
                }
            }, 100);
        }
        else {
            $('#txtUserLocationCode').prop('disabled', true);
            $('#MovementCategory').prop('disabled', true);
            $('#spnPopup-Location').hide();
            $('#MovementCategory').val('null');
            $('#ToLocation_1').val('null');
            $('#ToLocation_2,#ToLocation_3,#ToLocation_4,#ToLocation_5').val('');
            $('#txtUserLocationCode').val('');
            $('#txtUserLocationName').val('');
            $('#txtUserAreaCode').val('');
            $('#txtUserAreaName').val('');
            $('#txtUserLevelCode').val('');
            $('#txtUserLevelName').val('');
            $('#txtBlockCode').val('');
            $('#txtBlockName').val('');
            $('#txtMaintenanceWorkNo').prop('disabled', true);
            $('#WonDiv').hide();
        }
    });

    //--------------------------------------------------------------------
    $('#btnAddNew').click(function () {
        window.location.reload();
    });
    $('#hdnUserAreaId').change(function () {
        $('#hdnUserLocationId').val(null);
        $('#txtUserLocation').val(null);
    });

    $('#btnCancel,#btnCancelreceipt,#btnCancelMvmt').click(function () {
        var message = Messages.Reset_Alert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                ClearFields();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });

    $("#btnmvmtCancel,#btnreceiptCancel,#btnCancelHist").click(function () {
        window.location.href = "/bems/Portering";
    });


    $('#btnCancelMvmt').click(function () {
        $("#MovementFormId :input:not(:button)").parent().removeClass('has-error');
        $('#ConsignmentNo').val('');
        $('#CourierName').val('');
        $('#ConsignmentDate').val('');
    });

    $("#movementTab").click(function () {
        $("#MovementFormId :input:not(:button)").parent().removeClass('has-error');
        $('.porterStatus').html('');
        $('#PorteringStatusId,#AssignPorteringStatusId').empty();
        $("div.errormsgcenter1").text("");
        $('#errorMsg1').css('visibility', 'hidden');
        formInputValidation("MovementFormId");
        var transportMode = $('#ModeOfTransport').val();
        var currentWorkflowId = $('#CurrentWorkFlowId').val();
        var MovementCategory = $('#MovementCategory').val();
        var hdnPorteringStatus = $('#hdnPorteringStatusId').val();
        $.each(window.PorteringStatusGlobal, function (index, value) {
            $('#PorteringStatusId,#AssignPorteringStatusId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });

        var primaryId = $('#primaryID').val();
        if (primaryId == 0) {
            bootbox.alert(Messages.SAVE_FIRST_TABALERT);
            return false;
        }
        else if (MovementCategory == 327 || MovementCategory == "327") {
            bootbox.alert("Temporary Movement already completed");
            return false;
        }
        else if (currentWorkflowId != 247 || currentWorkflowId != "247") {
            bootbox.alert("Asset Tracker Approval Status should be Approved");
            return false;
        }
        else {
            $('#MvmtModeOfTransport').val(transportMode);
            if (transportMode == 217 || transportMode == "217") {
                $('#ConsignmentNo,#ConsignmentDate,#CourierName').attr('disabled', true);
                $('#txtAssignPorter,#ScanAsset').removeAttr('disabled');
                $('#ConsignmentNo').removeAttr('required');
                $('#CourierName').removeAttr('required');
                $('#ConsignmentDate').removeAttr('required');
                $('.person').show();
                $('.courier').hide();
            }
            else {
                $('.person').hide();
                $('.courier').show();
                $('#AssignPorterDiv').hide();
                $('#txtAssignPorter').removeAttr('required');
                $('#AssignPorteringStatusId').removeAttr('required');
                $('#txtAssignPorter,#ScanAsset').attr('disabled', true);
                $('#ConsignmentNo,#ConsignmentDate,#CourierName').removeAttr('disabled');
            }

            if (MovementCategory != 241 && MovementCategory != "241") {
                if (hdnPorteringStatus == '' || hdnPorteringStatus == null || hdnPorteringStatus == '0') {
                    $('#PorteringStatusId,#AssignPorteringStatusId').val(250);
                }
                else {
                    $('#PorteringStatusId,#AssignPorteringStatusId').val(hdnPorteringStatus);
                }

                if (hdnPorteringStatus == '' || hdnPorteringStatus == null) {

                    $('#btnEditMvmt').show();
                    $('#btnCancelMvmt').show();
                }
                else {
                    $('#btnEditMvmt').hide();
                    $('#btnCancelMvmt').hide();
                    $('#spnPopup-assignporter').hide();
                    $("#MovementFormId :input:not(:button)").prop("disabled", true);
                }
            }
            else {
                if (hdnPorteringStatus == '' || hdnPorteringStatus == null || hdnPorteringStatus == '0') {
                    $('#PorteringStatusId,#AssignPorteringStatusId').val(252);
                }
                else {
                    $('#PorteringStatusId,#AssignPorteringStatusId').val(hdnPorteringStatus);
                }
                if (hdnPorteringStatus == '' || hdnPorteringStatus == null) {

                    $('#btnEditMvmt').show();
                    $('#btnCancelMvmt').show();
                }
                else {
                    $('#btnEditMvmt').hide();
                    $('#btnCancelMvmt').hide();
                    $('#spnPopup-assignporter').hide();
                    $("#MovementFormId :input:not(:button)").prop("disabled", true);
                }
            }
            if ($('#ActionType').val() == "View") {
                $('#AssignPorterDiv').hide();
            }
        }
    });

    $("#ReceiptTab").click(function () {
        formInputValidation("ReceiptFormId");
        var primaryId = $('#primaryID').val();
        var PorteringStatusId = $('#hdnPorteringStatusId').val();
        if (primaryId == 0) {
            bootbox.alert(Messages.SAVE_FIRST_TABALERT);
            return false;
        }
        else if (PorteringStatusId == 363 || PorteringStatusId == '363') {
            if ($('#hdnReceivedById').val() > 0) {

                $('#btnEditreceipt').hide();
            } else {
           
            $('#txtReceivedBy').attr('disabled', false);
            $('#ReceivedPosition').attr('disabled', false);
            $('#Remarks').attr('disabled', false);
            $('#btnEditreceipt').show();
            }
        }
        else {
            bootbox.alert("Asset Tracker Status should be Completed");
            return false;
        }

        if ($('#ActionType').val() == "View") {
            $("#ReceiptFormId :input:not(:button)").prop("disabled", true);
            $('#ReceivedByDiv').hide();
        }
    });

    $("#Histab").click(function () {
        var primaryId = $('#primaryID').val();
        $('#HistPorteringNo').val($('#PorteringNo').val());

        $("div.errormsgcenter4").text("");
        $('#errorMsg4').css('visibility', 'hidden');
        if (primaryId == 0) {
            bootbox.alert(Messages.SAVE_FIRST_TABALERT);
            return false;
        }
        else {
            $.get("/api/Portering/GetPorteringHistory/" + primaryId)
           .done(function (result) {

               var getHistory = JSON.parse(result);
               $("#HistoryId").empty();
               if (getHistory != null && getHistory.PorteringHistoryDets != null && getHistory.PorteringHistoryDets.length > 0) {
                   var html = '';
                   $(getHistory.PorteringHistoryDets).each(function (index, data) {
                       data.WFDoneByDate = (data.WFDoneByDate != null) ? DateFormatter(data.WFDoneByDate) : "";
                       data.PorterigDonebyDate = (data.PorterigDonebyDate != null) ? DateFormatter(data.PorterigDonebyDate) : "";
                       data.LastUpdatedDate = (data.LastUpdatedDate != null) ? DateFormatter(data.LastUpdatedDate) : "";                      

                       html += '<tr class="ng-scope" style=""><td width="20%" style="text-align: center;"><div> ' +
                              ' <input type="text" class="form-control" id="WorkFlowStatusIdValue_' + index + '" value="' + data.WorkFlowStatusIdValue + '" readonly /></div></td><td width="10%" style="text-align: center;"><div> ' +
                              ' <input type="text" class="form-control" id="WFDoneByDate_' + index + '" value="' + data.WFDoneByDate + '" readonly /></div></td><td width="15%" style="text-align: center;"><div> ' +
                               '<input type="text" class="form-control" id="WFDoneByValue_' + index + '" value="' + data.WFDoneByValue + '" readonly /></div></td><td width="15%" style="text-align: center;"><div> ' +
                               ' <input type="text" class="form-control" id="PorteringStatusLovIdValue_' + index + '" value="' + data.PorteringStatusLovIdValue + '" readonly /></div></td><td width="10%" style="text-align: center;"><div> ' +
                               ' <input type="text" class="form-control" id="PorterigDonebyDate_' + index + '" value="' + data.PorterigDonebyDate + '" readonly /></div></td><td width="15%" style="text-align: center;"><div> ' +
                               '<input type="text" class="form-control" id="PorteringStatusDoneByValue_' + index + '" value="' + data.PorteringStatusDoneByValue + '" readonly /></div></td>   <td width="15%" style="text-align: center;"><div>  ' +
                               '<input type="text" class="form-control" id="LastUpdatedDate_' + index + '" value="' + data.LastUpdatedDate + '" readonly /></div></td> ' +
                               '  </tr>';
                   });
                   $("#HistoryId").append(html);
                   $('#myPleaseWait').modal('hide');
               }
               else {
                   $('#myPleaseWait').modal('hide');
                   $("div.errormsgcenter4").text(Messages.NO_RECORD_FOUND);
                   $('#errorMsg4').css('visibility', 'visible');
               }

           })
       .fail(function () {
           $('#myPleaseWait').modal('hide');
           $("div.errormsgcenter1").text(Messages.COMMON_FAILURE_MESSAGE);
           $('#errorMsg1').css('visibility', 'visible');
       });
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
});

function LinkClicked(id) {
    $('#hdnReceivedById').val(0) ;
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show')
    var action = "";
    $("#PorteringFormId :input:not(:button)").parent().removeClass('has-error');
    $("#MovementFormId :input:not(:button)").parent().removeClass('has-error');
    $("#ReceiptFormId :input:not(:button)").parent().removeClass('has-error');
    $('#hdnPorteringStatusId').val('')
    $('#PorteringStatusId').val('null');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#primaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission) {
        action = "Edit"

    }
    else if (!hasEditPermission && hasViewPermission) {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#btnDelete').show();
    }

    if (action == 'View') {
        $("#UAform :input:not(:button)").prop("disabled", true);
        $('#levlcodepopup,#hospStaffpopup,#companypopup').hide();
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();

        $("#UAform :input:not(:button)").prop("disabled", false);
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/Portering/Get/" + primaryId)
          .done(function (result) {

              var res = JSON.parse(result);
              $('#hdnAttachId').val(res.HiddenId);
              BindPorteringDate(res);
              $('#myPleaseWait').modal('hide');
          })
         .fail(function () {
             $('#myPleaseWait').modal('hide');
             $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
             $('#errorMsg').css('visibility', 'visible');
         });
    }
    else {

        $('#hdnApplicantStaffId').val(loadResult.ApplicantStaffId);
        $('#ApplicantName').val(loadResult.ApplicantStaffName);
        $('#ApplicantDesignation').val(loadResult.ApplicantDesignation);
        $('#myPleaseWait').modal('hide');
        $("#AssetCode,#AssetDesc").removeAttr("disabled");
    }
}
$("#btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/Portering/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('Portering', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 $('#btnDelete').hide();
                 ClearFields();
             })
             .fail(function () {
                 showMessage('Portering', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });

        }
    });
}

window.BindPorteringDate = function (res) {

    $('#MovementCategory').empty();
    // var alist = Enumerable.From(window.GlobalMovementCategoryLovs).Where(function (x) { return (x.LovId != 240) }).ToArray();
    $('#MovementCategory').append('<option value="' + "null" + '">' + "Select" + '</option>');
    $.each(window.GlobalMovementCategoryLovs, function (index, value) {
        $('#MovementCategory').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasAddPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Add'");
    var hasVerifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Verify'");
    var hasApprovePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");

    var bookingStatus = res.CurrentWorkFlowId;

    if (hasAddPermission) {
        if (bookingStatus == 246 || bookingStatus == "246" || bookingStatus == "247" || bookingStatus == 247 || bookingStatus == 309 || bookingStatus == "309" || bookingStatus == "248" || bookingStatus == 248) {
            $('#btnSave').hide();
            $('#btnEdit').hide();
            $('#btnSaveandAddNew').hide()
            $('#btnVerify').hide();
            $('#btnReject').hide();
            $('#btnApprove').hide();
        }
        if (bookingStatus == 246 && hasApprovePermission) 
        {
            $('#btnApprove').show();
        }
    }
    else if (hasVerifyPermission || hasApprovePermission) {
        $('#btnSave').hide();
        $('#btnEdit').hide();
        $('#btnSaveandAddNew').hide();
        if (bookingStatus == 246 || bookingStatus == "246") {

            if (hasVerifyPermission) {
                $('#btnVerify').show();
                $('#btnReject').show();
            }
            else {
                $('#btnVerify').hide();
                $('#btnReject').hide();
            }
            $('#btnApprove').hide();
        }
        else if (bookingStatus == 309 || bookingStatus == "309") {
            $('#btnVerify').hide();
            if (hasApprovePermission) {
                $('#btnReject').show();
                $('#btnApprove').show();
            }
            else {
                $('#btnReject').hide();
                $('#btnApprove').hide();
            }
        }
        else {
            $('#btnVerify').hide();
            $('#btnReject').hide();
            $('#btnApprove').hide();
        }
    }

    //*************************** Attachment button hide **************************

    if ((bookingStatus == "247" || bookingStatus == 247 || bookingStatus == "248" || bookingStatus == 248 || bookingStatus == "309" || bookingStatus == 309)) {
        $('#AttachRowPlus').hide();
        $('#btnEditAttachment').hide();
    }
    else {
        $('#AttachRowPlus').show();
        $('#btnEditAttachment').show();
    }
    $('#txtUserLocationCode').prop('disabled', true);
    $('#spnPopup-Location').hide();
    $('#txtAssetNo,#txtMaintenanceWorkNo,#ModeOfTransport,#PorteringDate,#txtCompanyStaffName').attr('disabled', true);
    $('#AssetNoDiv,#WonDiv,#companypopup').hide();
    $('#primaryID').val(res.PorteringId);
    $('#Timestamp').val(res.Timestamp);
    $('#hdnAssetId').val(res.AssetId);
    $('#MovementCategory').val(res.MovementCategory);
    $('#txtAssetNo').val(res.AssetNo);
    $('#hdnWorkOrderId').val(res.hdnWorkOrderId);
    $('#txtMaintenanceWorkNo').val(res.WorkOrderNo);
    $('#PorteringNo').val(res.PorteringNo);
    $('#PorteringDate').val(DateFormatter(res.PorteringDate));
    $('#FromCustomerId').val(res.FromCustomerId);
    $('#FromFacilityId').val(res.FromFacilityId);
    $('#FromBlockId').val(res.FromBlockId);
    $('#FromLevelId').val(res.FromLevelId);
    $('#FromUserAreaId').val(res.FromUserAreaId);
    $('#FromUserLocationId').val(res.FromUserLocationId);
    $('#FromFacilityName').val(res.FacilityName);
    $('#WFStatusApprovedDate').val(res.WFStatusApprovedDate);
    $('#FromBlockName').val(res.BlockName);
    $('#FromLevelName').val(res.LevelName);
    $('#FromUserAreaName').val(res.UserAreaName);
    $('#FromUserLocationName').val(res.UserLocationName);
    $('#LocationInchargeId').val(res.LocationInchargeId);
    $('#LocationInchargeName').val(res.LocationInchargeName);

    if (res.ToFacilityId != null && res.ToFacilityId != '' && res.ToFacilityId != 0) {
        $('#ToLocation_1').val(res.ToFacilityId);
    }
    else {
        $('#ToLocation_1').val('null');
    }
    if (res.MovementCategory == "242" || MovementCategory == 242) {
        $('#VendorTypeId').val(res.SupplierLovId);
        $.each(res.VendorNameLovs, function (index, value) {
            $('#VendorNameId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $('#VendorNameId').val(res.SupplierId);
        $('.supplier').show();
        $('.location').hide();
        $('#MovementCategory').attr('disabled', true);
        $('#RequestTypeLovId').attr('disabled', true);
    }
    else {
        $('.supplier').hide();
        $('.location').show();       
        $('#ToLocation_2').val(res.ToBlockId);
        $('#ToLocation_3').val(res.ToLevelId);
        $('#ToLocation_4').val(res.ToUserAreaId);
        $('#ToLocation_5').val(res.ToUserLocationId);
        $('#txtUserLocationCode').val(res.ToUserLocationCode);
        $('#txtUserLocationName').val(res.ToUserLocationName);
        $('#txtUserAreaCode').val(res.ToUserAreaCode);
        $('#txtUserAreaName').val(res.ToUserAreaName);
        $('#txtUserLevelCode').val(res.ToLevelCode);
        $('#txtUserLevelName').val(res.ToLevelName);
        $('#txtBlockCode').val(res.ToBlockCode);
        $('#txtBlockName').val(res.ToBlockName);
        $('#VendorTypeId').attr('disabled', true);
        $('#VendorNameId').attr('disabled', true);
        $('#ToLocation_1').attr('disabled', true);       
        $('#MovementCategory').attr('disabled', true);
        $('#RequestTypeLovId').attr('disabled', true);
    }
    $('#hdnCompanyStaffId').val(res.RequestorId);
    $('#txtCompanyStaffName').val(res.RequestorName);
    $('#txtDesignation').val(res.Position);
    $('#RequestTypeLovId').val(res.RequestTypeLovId);
    $('#CurrentWorkFlowId').val(res.CurrentWorkFlowId);
    $('#ModeOfTransport').val(res.ModeOfTransport);

    if (res.PorteringStatus != null && res.PorteringStatus != 0) {
        $('#hdnPorteringStatusId').val(res.PorteringStatus);
        $('#PorteringStatusId').val(res.PorteringStatus);
        $('#AssignPorteringStatusId').val(res.PorteringStatus);
    }

    if (res.ModeOfTransport == 217 || res.ModeOfTransport == '217')// Person
    {
        if (res.PorteringStatus != null && res.PorteringStatus != 0) {
            $('#hdnAssignPorterId').val(res.AssignPorterId);
            $('#txtAssignPorter').val(res.AssignPorterName);
        }
        else {
            $('#hdnAssignPorterId').val(res.LocationInchargeId);
            $('#txtAssignPorter').val(res.LocationInchargeName);
        }
    }
    $('#ConsignmentDate').val(DateFormatter(res.ConsignmentDate));
    $('#ScanAsset').val(res.ScanAsset);
    $('#CourierName').val(res.CourierName);
    $('#ConsignmentNo').val(res.ConsignmentNo);
    $('#Remarks').val(res.Remarks);
    if (res.ReceivedBy > 0) {
        $('#txtReceivedBy').attr('disabled', true);
        $('#ReceivedPosition').attr('disabled', true);
        $('#Remarks').attr('disabled', true);
    }
    else {
    }
    $('#hdnReceivedById').val(res.ReceivedBy);
    $('#txtReceivedBy').val(res.ReceivedByName);
    $('#ReceivedPosition').val(res.ReceivedByPosition);

    if (hasAddPermission) {//
        $('#btnCancel').show();
        if (res.CurrentWorkFlowId == 246 || res.CurrentWorkFlowId == "246") {            
            $('#btnDelete').show();
        }
        else if (res.CurrentWorkFlowId == 247 || res.CurrentWorkFlowId == 247) {

        }
    }
    else if (hasVerifyPermission) {

        $("#bookingFormId :input:not(:button)").prop("disabled", true);
        $('#spnPopup-compStaff').hide();
        $('#btnDelete').hide();
        $('#btnCancel').hide();
    }
    else if (hasApprovePermission) {
        $("#bookingFormId :input:not(:button)").prop("disabled", true);
        $('#spnPopup-compStaff').hide();
        $('#btnDelete').hide();
        $('#btnCancel').hide();
    }

    // status 

    if (res.CurrentWorkFlowId == 246 || res.CurrentWorkFlowId == "246") {
        $('.status').html("Draft");
    }
    else if (res.CurrentWorkFlowId == 309 || res.CurrentWorkFlowId == "309") {
        $('.status').html("Submitted");
    }
    else if (res.CurrentWorkFlowId == 247 || res.CurrentWorkFlowId == "247") {
        $('.status').html("Approved");
    }
    else if (res.CurrentWorkFlowId == 248 || res.CurrentWorkFlowId == "248") {
        $('.status').html("Rejected");
    }

    if (res.CurrentWorkFlowId == 248 || res.CurrentWorkFlowId == "248" || res.CurrentWorkFlowId == 247 || res.CurrentWorkFlowId == "247" || res.CurrentWorkFlowId == 309 || res.CurrentWorkFlowId == "309") {
        $("#bookingFormId :input:not(:button)").prop("disabled", true);
        $('#spnPopup-compStaff').hide();
        $('#btnDelete').hide();
    }
    if (res.CurrentWorkFlowId == 247 || res.CurrentWorkFlowId == "247") {
        $('#btnSave').show();
        $('#btnEdit').hide();
        $('#btnSaveandAddNew').hide()
        $('#btnVerify').hide();
        $('#btnReject').hide();
        $('#btnApprove').hide();
    }
    $('#VendorTypeId').attr('disabled', true);
    $('#VendorNameId').attr('disabled', true);
}


window.GetLocationList = function (locationNo) {
    ClearDropDownFields(locationNo);

    var mvmtCategory = $('#MovementCategory').val();
    if (mvmtCategory == 241 || mvmtCategory == '241') {
        $('#txtUserLocationCode').prop('disabled', false);
        $('#spnPopup-Location').show();
    }
    if (locationNo != 5 && locationNo != "5" && $('#ToLocation_' + locationNo).val() != "null") {

        var locationObj = {
            ToFacilityId: $('#ToLocation_1').val(),
            ToBlockId: $('#ToLocation_2').val(),
            ToLevelId: $('#ToLocation_3').val(),
            ToUserAreaId: $('#ToLocation_4').val(),
            locationNo: locationNo
        }
        var ind = parseInt(locationNo) + 1;
        var jqxhr = $.post("/api/Portering/GetLocationList", locationObj, function (response) {
            var result = JSON.parse(response);
            $.each(result.CascadeLocationLovs, function (index, value) {
                $('#ToLocation_' + ind).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
        },
     "json")
      .fail(function (response) {
          $('#myPleaseWait').modal('hide');
      });
    }
}

window.ClearDropDownFields = function (locationNo) {
    if (locationNo == "1" || locationNo == 1 || locationNo == "2" || locationNo == 2 || locationNo == "3" || locationNo == 3 || locationNo == "4" || locationNo == 4) {
        $('#ToLocation_2,#ToLocation_3,#ToLocation_4,#ToLocation_5').val('');
        $('#txtUserLocationCode').val('');
        $('#txtUserLocationName').val('');
        $('#txtUserAreaCode').val('');
        $('#txtUserAreaName').val('');
        $('#txtUserLevelCode').val('');
        $('#txtUserLevelName').val('');
        $('#txtBlockCode').val('');
        $('#txtBlockName').val('');        
    }
    else if (locationNo == "5" || locationNo == 5) {
        $("#VendorNameId").find("option:not(:first)").remove();
    }
    else if (locationNo == "6" || locationNo == 6) {
        $("#ToLocation_2,#ToLocation_3,#ToLocation_4,#ToLocation_5").find("option:not(:first)").remove();
        $("#VendorNameId").find("option:not(:first)").remove();
    }
    else {
        $('#ToLocation_2,#ToLocation_3,#ToLocation_4,#ToLocation_5').val('');
        $('#txtUserLocationCode').val('');
        $('#txtUserLocationName').val('');
        $('#txtUserAreaCode').val('');
        $('#txtUserAreaName').val('');
        $('#txtUserLevelCode').val('');
        $('#txtUserLevelName').val('');
        $('#txtBlockCode').val('');
        $('#txtBlockName').val('');
        $("#ToLocation_1").find("option:not(:first)").remove();
    }
}


window.ClearFields = function () {
    $('#MovementCategory').prop('disabled', true);
    var alist = Enumerable.From(window.GlobalMovementCategoryLovs).Where(function (x) { return (x.LovId != 240) }).ToArray();
    $('#MovementCategory').empty();
    $('#MovementCategory').append('<option value="' + "null" + '">' + "Select" + '</option>');
    $.each(alist, function (index, value) {
        $('#MovementCategory').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
    $(".content").scrollTop(0);
    $('#ToLocation_1').empty();
    $('#LocationInchargeId').val('');
    $('#LocationInchargeName').val('');
    $('#ToLocation_1').append('<option value="' + 'null' + '">' + 'Select' + '</option>');
    $.each(window.GlobalFacilityLovs, function (index, value) {
        $('#ToLocation_1').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
    $('#ToLocation_1').val('null');
    $('#movementlavelid').html("Movement Category <span class='red'>*</span>");
    $("#primaryID").val('');
    $('.status').html('');
    $('#txtAssetNo,#txtMaintenanceWorkNo,#ModeOfTransport,#txtCompanyStaffName,#RequestTypeLovId').attr('disabled', false);
    $('#AssetNoDiv,#WonDiv,#companypopup').show();
    $('.location,.supplier').hide();
    $('#ToLocation_1').removeAttr('required');
    $('#txtUserLocationCode').removeAttr('required');
    $('#VendorTypeId').removeAttr('required');
    $('#VendorNameId').removeAttr('required');
    $('input[type="text"], textarea').val('');
    $('#PorteringDate').val(CurrentDateGloabl);
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnDelete').hide();
    $('#btnSaveandAddNew').show();
    $('#spnActionType').text('Add');
    $("#grid").trigger('reloadGrid');
    $("#MovementCategory,#ToLocation_1").val('null');
    $("#ToLocation_2,#ToLocation_3,#ToLocation_4,#ToLocation_5").val('');
    $("#VendorTypeId,#VendorNameId,#RequestTypeLovId,#CurrentWorkFlowId,#ModeOfTransport").val('null');
    $('.nav-tabs a:first').tab('show')
}


