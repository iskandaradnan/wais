//
//var hdnUserRoleName = $("#hdnUserRoleName").val();
//if (hdnUserRoleName == "Hospital Director")
//{
//    $('#divSave').hide();
//}
//else {
//    $('#divSave').show();
//}

var typeCodeSearchObj = {};
var crmRequestNoSearchObj = { };
var locationNameSearchObj = { };
var companyRepresentativeSearchObj = { };
var hospitalRepresentativeSearchObj = { };
var contractorSearchObj = { };

var KeepInViewTCCompletedDate = null;
var KeepInViewHandoverDate = null;

FromNotification = false;
ScreenRolePermissionChecking()
$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    //$('#txtRequiredCompletionDate').attr('disabled', true);
    //$('#spnRequiredCompletionDate').hide();
    //$('#txtRequiredCompletionDate').removeAttr('required');

    formInputValidation("frmTestingAndCommissioning");
    formInputValidation("frmSNF");
    $('#btnEdit').hide();
    $('#btnEditVerifyRejectApproveClone').hide();

    var actionType = $('#hdnActionType').val();
    $('#btnSaveEditVerifyRejectApproveConvetToAsset, #btnSaveEditVerifyRejectApproveConvetToAsset1').hide();

    $('#txtManufacturer').attr('disabled', true);
    $('#spnPopup-manufacturer').unbind("click").attr('disabled', true).css('cursor', 'default');
    //$('#txtModel').attr('disabled', true);
    $('#spnPopup-model').unbind("click").attr('disabled', true).css('cursor', 'default');

    //if (actionType == 'Approve' || actionType == 'Reject') {
    //    $.each($('#frmSNF :input:not(:button)'), function (index, value) {
    //        if ($(this).attr('id') != 'txaSNFRemarks') {
    //            $(this).attr('disabled', true);
    //        }
    //    });
    //    $('#txaSNFRemarks').attr('disabled', false);
    //}

    $.get("/api/testingAndCommissioning/Load")
    .done(function (result) {
       
        $('#btnEdit').hide();
        var loadResult = JSON.parse(result);
       //$("#jQGridCollapse1").click();
        if (!loadResult.IsAdditionalFieldsExist) {
            $('#liAFAdditionalInfo').hide();
        }

        $.each(loadResult.TAndCTypes, function (index, value) {
            $('#selAssetCategory').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(loadResult.VariationStatus, function (index, value) {
            $('#selVariationStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(loadResult.YesNoValues, function (index, value) {
            $('#selWarrantyStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(loadResult.TAndCStatusValues, function (index, value) {
            $('#selTandCStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        //$.each(loadResult.TypeOfService, function (index, value) {
        //    $('#selServiceType').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        //});
        $.each(loadResult.BatchNo, function (index, value) {
            $('#selBatchNo').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $('#selAssetCategory').val(73);
        $('#selTandCStatus').val(71);
        $('#selBatchNo').attr('required', true).attr('disabled', false);
    })
.fail(function (response) {
    $('#myPleaseWait').modal('hide');
    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
    $('#errorMsg').css('visibility', 'visible');
});

    $('.decimalCheck').each(function (index) {
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

    $("#btnSave, #btnEdit,#btnSaveandAddNew").click(function () {
        var Currentbtnclicked = $(this).attr("Id");

        $('#btnSave').attr('disabled', true);
        $('#btnEdit').attr('disabled', true);
        var CurrentbtnID = $(this).attr("Id");
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        //var actionType = $('#hdnActionType').val();
        var isFormValid = formInputValidation("frmTestingAndCommissioning", 'save');
        var isSNFFormValid = true;

        var tandCStatus = $("#selTandCStatus").val();

        var crmRequestId = $('#hdnCRMRequestId').val();
        var crmRequestNo = $('#txtCRMRequestNo').val();
        if (crmRequestId == '' && crmRequestNo != '') {
            DisplayErrorMessage("Please enter valid CRM Request No.");
            return false;
        }

        var typeCodeId = $('#hdnTypeCodeId').val();
        var typeCodeName = $('#txtTypeCode').val();
        if (typeCodeId == '' && typeCodeName != '') {
            DisplayErrorMessage("Please enter valid Type Code");
            return false;
        }

        var modelId = $('#hdnModelId').val();
        var modelName = $('#txtModel').val();
        if (modelId == '' && modelName != '') {
            DisplayErrorMessage("Please enter valid Model");
            return false;
        }

        var manufacturerId = $('#hdnManufacturerId').val();
        var manufacturerName = $('#txtManufacturer').val();
        if (manufacturerId == '' && manufacturerName != '') {
            DisplayErrorMessage("Please enter valid Manufacturer");
            return false;
        }

        var locationId = $('#hdnLocationId').val();
        var locationName = $('#txtLocationName').val();
        if (locationId == '' && locationName != '') {
            DisplayErrorMessage("Please enter valid Location Name");
            return false;
        }

        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            $('#btnEdit').attr('disabled', false);

            return false;
        }

        var requiredCompletionDate = $('#txtRequiredCompletionDate').val();
        if (requiredCompletionDate == null || requiredCompletionDate == '') {
            $("div.errormsgcenter").text('Required Completion Date cannot be empty');
            $('#errorMsg').css('visibility', 'visible');
            $('#btnSave').attr('disabled', false);
            $('#btnEdit').attr('disabled', false);
            return false;
        }

        $('#myPleaseWait').modal('show');

        //var requiredCompletionDate = null;

        var tandCStatus = $("#selTandCStatus").val();
        var statusName = $('#divTandCStatus').text();

        //if (tandCStatus == 285) {
            //requiredCompletionDate = $('#txtRequiredCompletionDate').val();
        //}
        //else if (statusName == 'Keep in view') {
        //    requiredCompletionDate = $('#hdnRequiredCompletionDate').val();
        //} else {
        //    requiredCompletionDate = $('#txtTCDate').val();
        //}

        var saveObj = {
            ServiceId: 2,
            AssetCategoryLovId: $('#selAssetCategory').val(),
            //TypeOfService:$('#selServiceType').val(),
            BatchNo:$('#selBatchNo').val(),
            RequestDate: $('#txtCRMRequestDate').val(),
            TandCDate: $('#txtTCDate').val(),
            CRMRequestId: $('#hdnCRMRequestId').val(),
            CRMRequesterId: $('#hdnCRMRequesterId').val(),
            CRMRequestNo: $('#txtCRMRequestNo').val(),
            RequesterEmail: $('#hdnCRMRequesterEmail').val(),
            AssetTypeCodeId: $('#hdnTypeCodeId').val(),
            TandCStatus: $("#selTandCStatus").val(),
            RequiredCompletionDate: $('#txtRequiredCompletionDate').val(),
            ModelId: $('#hdnModelId').val(),
            ManufacturerId: $('#hdnManufacturerId').val(),
            SerialNo: $('#txtSerialNo').val(),
            AssetNoOld: $('#txtOldAssetNumber').val(),
            UserLocationId: $('#hdnLocationId').val(),
            UserAreaId: $('#hdnAreaId').val(),
            AssetPreRegistrationNo: $('#txtARAssetPreRegistrationNo').val(),

            TandCCompletedDate: $('#txtTCCompletedDate').val(),
            HandoverDate: $('#txtHandoverDate').val(),

            VariationStatus: $('#selVariationStatus').val(),
            TandCContractorRepresentative: $('#txtContractorRepresentative').val(),
            FmsCustomerRepresentativeId: $('#hdnCompanyRepresentative').val(),
            FmsFacilityRepresentativeId: $('#hdnHospitalRepresentative').val(),
            Remarks: $('#txaRemarks').val(),

        };

        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            saveObj.TestingandCommissioningId = primaryId;
            saveObj.Timestamp = $('#hdnTimestamp').val();
            switch (Currentbtnclicked) {
                case 'btnSave':
                    if (tandCStatus == "71") {
                        saveObj.Status = 286;
                    } else if (tandCStatus == "72") {
                        saveObj.Status = 287;
                    } else if (tandCStatus == "285") {
                        saveObj.Status = 288;
                }
                    break;
                case 'btnSaveandAddNew':
                    if (tandCStatus == "71") {
                        saveObj.Status = 286;
                    } else if (tandCStatus == "72") {
                        saveObj.Status = 287;
                    } else if (tandCStatus == "285") {
                        saveObj.Status = 288;
                }
                    break;
                case 'btnEdit':
                    if (tandCStatus == "71") {
                        saveObj.Status = 286;
                    } else if (tandCStatus == "72") {
                        saveObj.Status = 287;
                    } else if (tandCStatus == "285") {
                        saveObj.Status = 288;
                }
                    break;
        }
        }
        else {
            saveObj.TestingandCommissioningId = 0;
            saveObj.Timestamp = "";
            if (tandCStatus == "71") {
                saveObj.Status = 286;
            } else if (tandCStatus == "72") {
                saveObj.Status = 287;
            } else if (tandCStatus == "285") {
                saveObj.Status = 288;
        }
    }

        var jqxhr = $.post("/api/testingAndCommissioning/Save", saveObj, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.TestingandCommissioningId);
            $("#hdnTimestamp").val(result.Timestamp);
            $('#txtTCDocumnetNo').val(result.TandCDocumentNo);
            $('#txtAppointmentDate').val(result.TandCDocumentNo);
            $('#txtARAssetPreRegistrationNo').val(result.AssetPreRegistrationNo);
            $('.TandCStatusName').text(result.StatusName);
            $('#hdnAttachId').val(result.HiddenId);
            //$('#txtRequiredCompletionDate').val(result.RequiredCompletionDate == null ? null : moment(result.RequiredCompletionDate).format("DD-MMM-YYYY"));
            //$('#hdnRequiredCompletionDate').val(result.RequiredCompletionDate == null ? null: moment(result.RequiredCompletionDate).format("DD-MMM-YYYY"));
            $('#txtCRMRequestNo').attr('disabled', true);
            $('#btnSave').attr('disabled', false);
            $('#btnEdit').attr('disabled', false);

            //if (tandCStatus != "285") {
                $.each($('#frmTestingAndCommissioning :input:not(:button)'), function (index, value) {
                    $(this).attr('disabled', true);
                });
                $('#spnPopup-typeCode').unbind("click").attr('disabled', true).css('cursor', 'default');
                $('#spnPopup-crmrequestno').unbind("click").attr('disabled', true).css('cursor', 'default');
                $('#spnPopup-CompanyRepresentative').unbind("click").attr('disabled', true).css('cursor', 'default');
                $('#spnPopup-hospitalRepresentative').unbind("click").attr('disabled', true).css('cursor', 'default');
                $('#spnPopup-model').unbind("click").attr('disabled', true).css('cursor', 'default');
                $('#spnPopup-manufacturer').unbind("click").attr('disabled', true).css('cursor', 'default');
                $('#spnPopup-locationName').unbind("click").attr('disabled', true).css('cursor', 'default');

                $("#anchorCreateTypeCode").unbind("click");
                $("#anchorCreateTypeCode").css('cursor', 'default');
                $('#btnSave').hide();
                $('#btnEdit').hide();

                $("#anchorCreateTypeCode").unbind("click");
                $("#anchorCreateTypeCode").css('cursor', 'default');
            //}

            if (tandCStatus == "285") {
                $('#btnSave').hide();
                $('#btnEdit').show();

                $('#selTandCStatus').attr('disabled', false);
                $('#txtTCCompletedDate').attr('disabled', false);
                $('#txtHandoverDate').attr('disabled', false);
                $('#txaRemarks').attr('disabled', false);

                KeepInViewTCCompletedDate = saveObj.TandCCompletedDate;
                KeepInViewHandoverDate = saveObj.HandoverDate;
            }

            var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
            var hasApprovePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");
            var hasVerifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Verify'");
            var hasRejectPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Reject'");

            if (hasEditPermission || hasApprovePermission || hasVerifyPermission || hasRejectPermission)
            {
                $('#btnEditVerifyRejectApproveClone').show();
            }

            $("#grid").trigger('reloadGrid');
            if (result.TestingandCommissioningId != 0) {
                $('#btnSaveandAddNew').hide();
            }
            $(".content").scrollTop(0);
            showMessage('Asset Register', CURD_MESSAGE_STATUS.SS);

            //$('#btnSave').attr('disabled', false);
            //$('#btnEdit').attr('disabled', false);

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
        $('#btnEdit').attr('disabled', false);

        $('#myPleaseWait').modal('hide');
    });
    });

    function DisplayErrorMessage(errorMessage) {
        $("div.errormsgcenter").text(errorMessage);
        $('#errorMsg').css('visibility', 'visible');

        $('#btnSave').attr('disabled', false);
        $('#btnEdit').attr('disabled', false);
    }

    function DisplayErrorMessageForSNF(message) {
        $("div.errormsgcenter").text(message);
        $('#errorMsgSNF').css('visibility', 'visible');

        $('#btnVerify').attr('disabled', false);
        $('#btnApprove').attr('disabled', false);
        $('#btnReject').attr('disabled', false);
    }
    $("#btnVerify, #btnApprove, #btnReject").click(function () {
        $('#btnVerify').attr('disabled', true);
        $('#btnApprove').attr('disabled', true);
        $('#btnReject').attr('disabled', true);
        var Currentbtnclicked = $(this).attr("Id");
        $("div.errormsgcenter").text("");
        $('#errorMsgSNF').css('visibility', 'hidden');

        var actionType = $('#hdnActionType').val();

        var tandCStatus = $("#selTandCStatus").val();
        var isSNFFormValid = formInputValidation("frmSNF", 'save');

        if (!isSNFFormValid) {
            DisplayErrorMessageForSNF(Messages.INVALID_INPUT_MESSAGE)
            //$("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            //$('#errorMsgSNF').css('visibility', 'visible');

            //$('#btnVerify').attr('disabled', false);
            //$('#btnApprove').attr('disabled', false);
            //$('#btnReject').attr('disabled', false);
            return false;
        }
        if (Currentbtnclicked == 'btnVerify') {
            if (parseInt($('#txtPurchaseCost').val()) == "0") {
                DisplayErrorMessageForSNF('Purchase Cost cannot be zero');
                return false;
            }
            if (parseInt($('#txtWarrantyDuration').val()) == "0") {
                DisplayErrorMessageForSNF('Warranty Duration cannot be zero');
                return false;
            }
        }

        $('#myPleaseWait').modal('show');
        var purchaseCost = $('#txtPurchaseCost').val();
        purchaseCost = purchaseCost.split(',').join('');

        var saveObj = {
            TandCDocumentNo: $('#txtTCDocumnetNo').val(),
            PurchaseOrderNo: $('#txtPurchaseOrderNo').val(),
            PurchaseDate: $('#txtPurchaseDate').val(),
            PurchaseCost: purchaseCost,
            ContractLPONo: $('#txtContractNo').val(),
            TandCCompletedDate: $('#txtTCCompletedDate').val(),
            ServiceStartDate: $('#txtServiceStartDate').val(),
            ServiceEndDate: $('#txtServiceEndtDate').val(),
            ContractorId: $('#hdnContractorId').val(),
            WarrantyStartDate: $('#txtWarrantyStartDate').val(),
            WarrantyDuration: $('#txtWarrantyDuration').val(),
            WarrantyEndDate: $('#txtWarrantyEndDate').val(),
            SNFRemarks: $('#txaSNFRemarks').val(),
            //TypeOfService: ('#selServiceType').val(),
            BatchNo:$('#selBatchNo').val(),
        };

        var primaryId = $("#primaryID").val();
        saveObj.TestingandCommissioningId = primaryId;
        saveObj.Timestamp = $('#hdnTimestamp').val();
        switch (Currentbtnclicked) {
            case 'btnVerify': saveObj.Status = 289; break;
            case 'btnApprove': saveObj.Status = 290; break;
            case 'btnReject': saveObj.Status = 291; break;
        }

        var jqxhr = $.post("/api/testingAndCommissioning/SaveSNF", saveObj, function (response) {
            var result = JSON.parse(response);
            $("#hdnTimestamp").val(result.Timestamp);
            //$('#selWarrantyStatus').val(result.WarrantyStatus == null ? "null" : result.WarrantyStatus);
            $('.TandCStatusName').text(result.StatusName);
            $('#txtWarrantyEndDate').val(result.WarrantyEndDate == null ? null : moment(result.WarrantyEndDate).format("DD-MMM-YYYY"));
            $('#selWarrantyStatus').val(result.WarrantyStatus);

            var hasApprovePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");
            var hasVerifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Verify'");
            var hasRejectPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Reject'");

            if (Currentbtnclicked == 'btnVerify') {
                $('#btnVerify').hide();
                $('#btnApprove').hide();
                $('#btnReject').hide();
                $('#btnSave').hide();
                $('#btnEdit').hide();
                $('#btnSaveandAddNew').hide();
                $('#btnCancel').show();
                if (hasApprovePermission)
                {
                    $('#btnApprove').show();
                }
                if (hasRejectPermission) {
                    $('#btnReject').show();
                }
                $.each($('#frmSNF :input:not(:button)'), function (index, value) {
                    if ($(this).attr('id') != 'txaSNFRemarks') {
                        $(this).attr('disabled', true);
                    }
                });
                $('#spnPopup-contractor').unbind("click").attr('disabled', true).css('cursor', 'default');
                $('#txaSNFRemarks').val('').attr('disabled', false);
            }
            else if (Currentbtnclicked == 'btnApprove') {
                $('#btnSaveEditVerifyRejectApproveConvetToAsset, #btnSaveEditVerifyRejectApproveConvetToAsset1').show();
                $('#btnVerify').hide();
                $('#btnApprove').hide();
                $('#btnReject').hide();
                $('#btnSave').hide();
                $('#btnEdit').hide();
                $('#btnSaveandAddNew').hide();
                $('#btnCancel').show();
                $.each($('#frmSNF :input:not(:button)'), function (index, value) {
                    if ($(this).attr('id') != 'txaSNFRemarks') {
                        $(this).attr('disabled', true);
                    }
                });
                $('#txaSNFRemarks').attr('disabled', true);
            }
            else if (Currentbtnclicked == 'btnReject') {
                $('#btnVerify').hide();
                $('#btnApprove').hide();
                $('#btnReject').hide();
                $('#btnSave').hide();
                $('#btnEdit').hide();
                $('#btnSaveandAddNew').hide();
                $('#btnCancel').show();
                $.each($('#frmSNF :input:not(:button)'), function (index, value) {
                    if ($(this).attr('id') != 'txaSNFRemarks') {
                        $(this).attr('disabled', true);
                    }
                });
                $('#txaSNFRemarks').attr('disabled', true);
            }

            $("#grid").trigger('reloadGrid');
            $(".content").scrollTop(0);
            showMessage('Asset Register', CURD_MESSAGE_STATUS.SS);

            $('#btnVerify').attr('disabled', false);
            $('#btnApprove').attr('disabled', false);
            $('#btnReject').attr('disabled', false);
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
        $('#errorMsgSNF').css('visibility', 'visible');

        $('#btnVerify').attr('disabled', false);
        $('#btnApprove').attr('disabled', false);
        $('#btnReject').attr('disabled', false);

        $('#myPleaseWait').modal('hide');
    });
    });


    //    //------------------------Search----------------------------

    var modelSearchObj = {
        Heading: "Model Details",
        SearchColumns: ['Model-Model'],
        ResultColumns: ["ModelId-Primary Key", 'Model-Model'],
        AdditionalConditions: ["TypeCodeId-hdnTypeCodeId"],
        FieldsToBeFilled: ["hdnModelId-ModelId", "txtModel-Model", "hdnManufacturerId-ManufacturerId", "txtManufacturer-Manufacturer"]
    };

    //$('#spnPopup-model').click(function () {
    //    DisplaySeachPopup('divSearchPopup', modelSearchObj, "/api/Search/ModelSearch");
    //});

    var manufacturerSearchObj = {
        Heading: "Manufacturer Details",
        SearchColumns: ['Manufacturer-Manufacturer'],
        ResultColumns: ["ManufacturerId-Primary Key", 'Manufacturer-Manufacturer'],
        AdditionalConditions: ["TypeCodeId-hdnTypeCodeId", "ModelId-hdnModelId"],
        FieldsToBeFilled: ["hdnManufacturerId-ManufacturerId", "txtManufacturer-Manufacturer"]
    };

    //$('#spnPopup-manufacturer').click(function () {
    //    DisplaySeachPopup('divSearchPopup', manufacturerSearchObj, "/api/Search/ManufacturerSearch");
    //});

    typeCodeSearchObj = {
        Heading: "Asset Type Code Details",//Heading of the popup
        SearchColumns: ['AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description', 'AssetClassificationDescription-Asset Classification Description'],//ModelProperty - Space seperated label value
        ResultColumns: ["AssetTypeCodeId-Primary Key", 'AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description', 'AssetClassificationDescription-Asset Classification Description'],//Columns to be returned for display
        AdditionalConditions: ["CheckEquipmentFunctionDescription-hdnCheckEquipmentFunctionDescription"],
        FieldsToBeFilled: ["hdnTypeCodeId-AssetTypeCodeId", "txtTypeCode-AssetTypeCode", "txtTypeDescription-AssetTypeDescription", "hdnAssetClassificationId-AssetClassificationId"]//id of element - the model property--, , 
    };

    $('#spnPopup-typeCode').click(function () {
        DisplaySeachPopup('divSearchPopup', typeCodeSearchObj, "/api/Search/TypeCodeSearch");
    });

    crmRequestNoSearchObj = {
        Heading: "CRM Request No. Details",//Heading of the popup
        SearchColumns: ['RequestNo-Request No.', 'RequestDescription-Request Description'],
        ResultColumns: ["CRMRequestId-Primary Key", 'RequestNo-Request No', 'RequestDescription-Request Description'],
        FieldsToBeFilled: ["hdnCRMRequestId-CRMRequestId", "txtCRMRequestNo-RequestNo", "txtRequiredCompletionDate-TargetDate", "hdnLocationId-UserLocationId", "txtLocationName-UserLocationName", "hdnAreaId-UserAreaId", "txtAreaName-UserAreaName", "txtLevlName-LevelName", "txtBlockName-BlockName", "txtCRMRequestDate-RequestDate", "hdnCRMRequesterId-CRMRequesterId", "hdnCRMRequesterEmail-RequesterEmail"]
    };

    $('#spnPopup-crmrequestno').click(function () {
        DisplaySeachPopup('divSearchPopup', crmRequestNoSearchObj, "/api/Search/TAndCCRMRequestNoSearch");
    });

    companyRepresentativeSearchObj = {
        Heading: "Company Representative Details",//Heading of the popup
        SearchColumns: ['StaffName-Company Representative'],//ModelProperty - Space seperated label value
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Company Representative'],//Columns to be returned for display
        FieldsToBeFilled: ["hdnCompanyRepresentative-StaffMasterId", "txtCompanyRepresentative-StaffName"]//id of element - the model property--, , 
    };

    $('#spnPopup-CompanyRepresentative').click(function () {
        DisplaySeachPopup('divSearchPopup', companyRepresentativeSearchObj, "/api/Search/CompanyStaffSearch");
    });

    hospitalRepresentativeSearchObj = {
        Heading: "Facility Representative Details",//Heading of the popup
        SearchColumns: ['StaffName-Facility Representative'],//ModelProperty - Space seperated label value
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Facility Representative'],//Columns to be returned for display
        FieldsToBeFilled: ["hdnHospitalRepresentative-StaffMasterId", "txtHospitalRepresentative-StaffName", "txtDesignation -Designation"]//id of element - the model property--, , 
    };

    $('#spnPopup-hospitalRepresentative').click(function () {
        DisplaySeachPopup('divSearchPopup', hospitalRepresentativeSearchObj, "/api/Search/FacilityStaffSearch");
    });

    var preRegistrationNoSearchObj = {
        Heading: "Asset Pre Registration No Details",
        SearchColumns: ['AssetPreRegistrationNo-Asset Pre Registration No.'],
        ResultColumns: ["TestingandCommissioningDetId-Primary Key", 'AssetPreRegistrationNo-Asset Pre Registration No.'],
        FieldsToBeFilled: ["hdnARAssetPreRegistrationNoId-TestingandCommissioningDetId", "txtARAssetPreRegistrationNo-AssetPreRegistrationNo", "hdnTandCDate-TandCDate"]
    };

    $('#spnPopup-assetPreRegistration').click(function () {
        DisplaySeachPopup('divSearchPopup', preRegistrationNoSearchObj, "/api/Search/AssetPreRegistrationNoSearch");
    });

    locationNameSearchObj = {
        Heading: "Location Name Details",
        SearchColumns: ['UserLocationCode-Location Code', 'UserLocationName-Location Name', 'UserAreaCode-Area Code', 'UserAreaName-Area Name'],
        ResultColumns: ["UserLocationId-Primary Key", 'UserLocationCode-Location Code', 'UserLocationName-Location Name', 'UserAreaCode-Area Code', 'UserAreaName-Area Name'],
        FieldsToBeFilled: ["hdnLocationId-UserLocationId", "txtLocationName-UserLocationName", "txtAreaName-UserAreaName", "hdnAreaId-UserAreaId", 'txtLevlName-LevelName', 'txtBlockName-BlockName']
    };

    $('#spnPopup-locationName').click(function () {
        DisplaySeachPopup('divSearchPopup', locationNameSearchObj, "/api/Search/LocationCodeSearch");
    });

    contractorSearchObj = {
        Heading: "Contractor Details",
        SearchColumns: ["ContractorName-Contractor / Vendor Name", "SSMRegistrationCode-Contractor / Vendor Registration Number"],
        ResultColumns: ["ContractorId-Primary Key", "ContractorName-Contractor / Vendor Name", "SSMRegistrationCode-Contractor / Vendor Registration Number"],
        FieldsToBeFilled: ["hdnContractorId-ContractorId", "txtMainSupplierName-ContractorName", "txtMainSupplierCode-SSMRegistrationCode"]
    };

    $('#spnPopup-contractor').click(function () {
        DisplaySeachPopup('divSearchPopup', contractorSearchObj, "/api/Search/ContractorNameSearch");
    });

    //----------------------------------------------------------

    //------------------------Fetch-----------------------------

    var modelFetchObj = {
        SearchColumn: 'txtModel-Model',//Id of Fetch field
        ResultColumns: ["ModelId-Primary Key", 'Model-Model'],
        AdditionalConditions: ["TypeCodeId-hdnTypeCodeId"],
        FieldsToBeFilled: ["hdnModelId-ModelId", "txtModel-Model", "hdnManufacturerId-ManufacturerId", "txtManufacturer-Manufacturer"]
    };

    $('#txtModel').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divModelFetch', modelFetchObj, "/api/Fetch/ModelFetch", "UlFetch6", event, 1);//1 -- pageIndex
    });

    var manufacturerFetchObj = {
        SearchColumn: 'txtManufacturer-Manufacturer',//Id of Fetch field
        ResultColumns: ["ManufacturerId-Primary Key", 'Manufacturer-Manufacturer'],
        AdditionalConditions: ["TypeCodeId-hdnTypeCodeId", "ModelId-hdnModelId"],
        FieldsToBeFilled: ["hdnManufacturerId-ManufacturerId", "txtManufacturer-Manufacturer"]
    };

    $('#txtManufacturer').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divManufacturerFetch', manufacturerFetchObj, "/api/Fetch/ManufacturerFetch", "UlFetch7", event, 1);//1 -- pageIndex
    });

    var typeCodeFetchObj = {
        SearchColumn: 'txtTypeCode-AssetTypeCode',
        ResultColumns: ["AssetTypeCodeId-Primary Key", 'AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description'],
        AdditionalConditions: ["CheckEquipmentFunctionDescription-hdnCheckEquipmentFunctionDescription"],
        FieldsToBeFilled: ["hdnTypeCodeId-AssetTypeCodeId", "txtTypeCode-AssetTypeCode", "txtTypeDescription-AssetTypeDescription", "hdnAssetClassificationId-AssetClassificationId"]
    };

    $('#txtTypeCode').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divTypeCodeFetch', typeCodeFetchObj, "/api/Fetch/TypeCodeFetch", "UlFetch", event, 1);
    });

    var crmRequestNoFetchObj = {
        SearchColumn: 'txtCRMRequestNo-RequestNo',
        ResultColumns: ["CRMRequestId-Primary Key", 'RequestNo-Request No'],
        FieldsToBeFilled: ["hdnCRMRequestId-CRMRequestId", "txtCRMRequestNo-RequestNo", "txtRequiredCompletionDate-TargetDate", "hdnLocationId-UserLocationId", "txtLocationName-UserLocationName", "hdnAreaId-UserAreaId", "txtAreaName-UserAreaName", "txtLevlName-LevelName", "txtBlockName-BlockName", "txtCRMRequestDate-RequestDate", "hdnCRMRequesterId-CRMRequesterId", "hdnCRMRequesterEmail-RequesterEmail"]
    };

    $('#txtCRMRequestNo').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divCRMRequestNoFetch', crmRequestNoFetchObj, "/api/Fetch/TAndCCRMRequestNoFetch", "UlFetch8", event, 1);
    });

    var companyRepresentativeFetchObj = {
        SearchColumn: 'txtCompanyRepresentative-StaffName',
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Company Representative'],
        FieldsToBeFilled: ["hdnCompanyRepresentative-StaffMasterId", "txtCompanyRepresentative-StaffName"]
    };

    $('#txtCompanyRepresentative').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divCompanyRepresentativeFetch', companyRepresentativeFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch1", event, 1);//1 -- pageIndex
    });

    var hospitalRepresentativeFetchObj = {
        SearchColumn: 'txtHospitalRepresentative-StaffName',
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Facility Representative'],
        FieldsToBeFilled: ["hdnHospitalRepresentative-StaffMasterId", "txtHospitalRepresentative-StaffName"]
    };

    $('#txtHospitalRepresentative').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divhdnHospitalRepresentativeFetch', hospitalRepresentativeFetchObj, "/api/Fetch/FacilityStaffFetch", "UlFetch2", event, 1);
    });

    var preRegistrationNoFetchObj = {
        SearchColumn: 'txtARAssetPreRegistrationNo-AssetPreRegistrationNo',
        ResultColumns: ["TestingandCommissioningDetId-Primary Key", 'AssetPreRegistrationNo-Asset Pre Registration No.'],
        FieldsToBeFilled: ["hdnARAssetPreRegistrationNoId-TestingandCommissioningDetId", "txtARAssetPreRegistrationNo-AssetPreRegistrationNo", "hdnTandCDate-TandCDate"]
    };

    $('#txtARAssetPreRegistrationNo').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divARAssetPreRegistrationNoFetch', preRegistrationNoFetchObj, "/api/Fetch/AssetPreRegistrationNoFetch", "UlFetch4", event, 1);
    });

    var locationNameFetchObj = {
        SearchColumn: 'txtLocationName-UserLocationCode',//Id of Fetch field
        ResultColumns: ["UserLocationId-Primary Key", 'UserLocationName-User Location Name', 'UserLocationCode-User Location Code', 'UserAreaCode-User Area Code', 'UserAreaName-User Area Name', 'UserAreaId-User Area Id', 'LevelName-Level Name', 'BlockName-Block Name'],
        FieldsToBeFilled: ["hdnLocationId-UserLocationId", "txtLocationName-UserLocationName", "txtAreaName-UserAreaName", "hdnAreaId-UserAreaId", 'txtLevlName-LevelName', 'txtBlockName-BlockName']
    };

    $('#txtLocationName').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divLocationNameFetch', locationNameFetchObj, "/api/Fetch/LocationCodeFetch", "UlFetch5", event, 1);//1 -- pageIndex
    });

    var contractorFetchObj = {
        SearchColumn: "txtMainSupplierName-ContractorName",//Id of Fetch field
        ResultColumns: ["ContractorId-Primary Key", "ContractorName-ContractorName", "SSMRegistrationCode-SSMRegistrationCode"],
        FieldsToBeFilled: ["hdnContractorId-ContractorId", "txtMainSupplierName-ContractorName", "txtMainSupplierCode-SSMRegistrationCode"]
    };

    $('#txtMainSupplierName').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divContractorFetch', contractorFetchObj, "/api/Fetch/ContractorNameFetch", "UlFetch3", event, 1);//1 -- pageIndex
    });
    //--------------------------------------------------------------------

    //$('#txtWarrantyStartDate, #txtWarrantyDuration').change(function () {
    //    $("div.errormsgcenter").text("");
    //    $('#errorMsgSNF').css('visibility', 'hidden');

    //    var warrantyStartDate = $('#txtWarrantyStartDate').val();
    //    var warrantyDuration = $('#txtWarrantyDuration').val();
    //    if (warrantyStartDate == null || warrantyStartDate == "" || warrantyDuration == null || warrantyDuration == "") {
    //        $('#txtWarrantyEndDate').val(null);
    //        $('#selWarrantyStatus').val('null');
    //        return false;
    //    }
    //    else {
    //        if (warrantyDuration <= 0) {
    //            $('#txtWarrantyEndDate').val(null);
    //            $('#selWarrantyStatus').val('null');
    //            return false;
    //        }
    //        $('#myPleaseWait').modal('show');
    //        var obj = {
    //            WarrantyStartDate: warrantyStartDate,
    //            WarrantyDuration: warrantyDuration
    //        };
    //        var jqxhr = $.post("/api/testingAndCommissioning/GetWarrantyEndDate", obj, function (response) {
    //            var result = JSON.parse(response);
    //            $('#txtWarrantyEndDate').val(result.WarrantyEndDate == null ? null : moment(result.WarrantyEndDate).format("DD-MMM-YYYY"));
    //            $('#selWarrantyStatus').val(result.WarrantyStatus);
    //            $('#myPleaseWait').modal('hide');
    //        },
    //       "json")
    //        .fail(function (response) {
    //            var errorMessage = "";
    //            errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
    //            $("div.errormsgcenter").text(errorMessage);
    //            $('#errorMsgSNF').css('visibility', 'visible');
    //            $('#myPleaseWait').modal('hide');
    //        });
    //    }
    //});

    $("#anchorCreateTypeCode").unbind("click");
    $('#anchorCreateTypeCode').click(function () {
        bootbox.confirm('You will be redirected to the Type Code screen. Are you sure you want to proceed?', function (result) {
            if (result) {
                window.location.href = "/bems/typecodedetails/add";
            }
        });
    });

    $("#btnCancelSNF").click(function () {
        var message = Messages.Reset_TabAlert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                EmptyFields();
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

    //if (actionType != 'Add' && actionType != 'Edit') {
    //    $('#spnPopup-typeCode').unbind("click").attr('disabled', true).css('cursor', 'default');
    //    $('#spnPopup-model').unbind("click").attr('disabled', true).css('cursor', 'default');
    //    $('#spnPopup-manufacturer').unbind("click").attr('disabled', true).css('cursor', 'default');
    //    $('#spnPopup-locationName').unbind("click").attr('disabled', true).css('cursor', 'default');
    //    $('#spnPopup-CompanyRepresentative').unbind("click").attr('disabled', true).css('cursor', 'default');
    //    $('#spnPopup-hospitalRepresentative').unbind("click").attr('disabled', true).css('cursor', 'default');
    //}

    $('#liAttachementTab').click(function () {//'#liSNFTab, 
        var primaryId = $('#primaryID').val();
        if (primaryId == 0) {
            bootbox.alert("T&C details must be Saved before entering additional information");
            return false;
        }
    });

    $('#liSNFTab').click(function () {//'#liSNFTab, 
        var primaryId = $('#primaryID').val();
        var actionType = $('#hdnActionType').val();
        var assetCategory = $('#selAssetCategory').val();
        if (primaryId == 0) {
            bootbox.alert("T&C details must be Saved before entering additional information");
            return false;
        }
        $('#txtTypeDescription1').val($('#txtTypeDescription').val());
        $("#frmSNF :input:not(:button)").parent().removeClass('has-error');
        $("div.errormsgcenter").text("");
        $('#errorMsgSNF').css('visibility', 'hidden');
        //else if (actionType == 'Add' || actionType == 'Edit') {
        //    //bootbox.alert("T&C Status should be 'Submitted' for entering SNF details");
        //    return false;
        //}
        //else if (assetCategory != 73) {
        //    bootbox.alert("Asset category must be 'Asset' for entering SNF details");
        //    return false;
        //}
        //else 
        if ($('#selTandCStatus').val() != 71) {
            bootbox.alert("T&C Status must be 'Passed' for entering SNF details");
            return false;
        }
        var hasApprovePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");
        var hasVerifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Verify'");
        var hasRejectPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Reject'");
        //var hasClarifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Clarify'");
        var Statusdiv = $('#divTandCStatus').text();
        var info = " Submitted";
        if (Statusdiv == info && hasVerifyPermission) {
            $('#btnVerify').show();
            $('#btnApprove').hide();
            $('#btnReject').hide();
            $('#btnSave').hide();
            $('#btnEdit').hide();
            $('#btnSaveandAddNew').hide();
            $('#btnCancel').show();
            //Enable all fields.
            $.each($('#frmSNF :input:not(:button)'), function (index, value) {
                $(this).attr('disabled', false);
            });
            $('#txtTypeDescription1').attr('disabled', true);
            $('#txtWarrantyEndDate').attr('disabled', true);
            $('#selWarrantyStatus').attr('disabled', true);
            $('#spnPopup-contractor').unbind('click');
            $('#spnPopup-contractor').click(function () {
                DisplaySeachPopup('divSearchPopup', contractorSearchObj, "/api/Search/ContractorNameSearch");
            }).attr('disabled', false).css('cursor', 'pointer');
            $('#txtMainSupplierCode').prop('disabled', true);

        }
        else if (Statusdiv == "Verified") {
            $('#btnVerify').hide();
            if (hasApprovePermission) {
                $('#btnApprove').show();
            }
            if (hasRejectPermission) {
                $('#btnReject').show();
            }
            $.each($('#frmSNF :input:not(:button)'), function (index, value) {
                $(this).attr('disabled', true);
            });
            $('#spnPopup-contractor').unbind("click").attr('disabled', true).css('cursor', 'default');
            $('#txaSNFRemarks').attr('disabled', false);

            $('#btnSave').hide();
            $('#btnEdit').hide();
            $('#btnSaveandAddNew').hide();
            $('#btnCancel').show();
        }
        else {
            $('#btnVerify').hide();
            $('#btnApprove').hide();
            $('#btnReject').hide();
            $('#btnSave').hide();
            $('#btnEdit').hide();
            $('#btnSaveandAddNew').hide();
            $('#btnCancel').show();
            $.each($('#frmSNF :input:not(:button)'), function (index, value) {
                $(this).attr('disabled', true);
            });
            $('#spnPopup-contractor').unbind("click").attr('disabled', true).css('cursor', 'default');
            $('#txaSNFRemarks').attr('disabled', true);
        }
        //$.each($('#frmTestingAndCommissioning :input:not(:button)'), function (index, value) {
        //    $(this).attr('disabled', true);
        //});
    });

    $('#hdnTypeCodeId').change(function () {
        var typeCodeId = $('#hdnTypeCodeId').val();

        $('#txtManufacturer').val(null);
        $('#hdnManufacturerId').val(null);

        $('#txtModel').val(null);
        $('#hdnModelId').val(null);

        if (typeCodeId == "" || typeCodeId == "null") {
            $('#txtManufacturer').attr('disabled', true);
            $('#spnPopup-manufacturer').unbind("click").attr('disabled', true).css('cursor', 'default');
            $('#txtModel').attr('disabled', true);
            $('#spnPopup-model').unbind("click").attr('disabled', true).css('cursor', 'default');
            return false;
        }
        else {
            $('#txtModel').attr('disabled', false);
            $('#spnPopup-model').bind("click", function () {
                DisplaySeachPopup('divSearchPopup', modelSearchObj, "/api/Search/ModelSearch")
            }).attr('disabled', false).css('cursor', 'pointer');
        }
    });

    $('#hdnModelId').change(function () {
        var modelId = $('#hdnModelId').val();

        $('#txtManufacturer').val(null);
        $('#hdnManufacturerId').val(null);

        if (modelId == "" || modelId == "null") {
            $('#txtManufacturer').attr('disabled', true);
            $('#spnPopup-manufacturer').unbind("click").attr('disabled', true).css('cursor', 'default');
            return false;
        }
        else {
            $('#txtManufacturer').attr('disabled', true);
            $('#spnPopup-manufacturer').bind("click", function () {
                DisplaySeachPopup('divSearchPopup', manufacturerSearchObj, "/api/Search/ManufacturerSearch");
            }).attr('disabled', false).css('cursor', 'pointer');
        }
    });

    $('#btnSaveEditVerifyRejectApproveConvetToAsset, #btnSaveEditVerifyRejectApproveConvetToAsset1').click(function () {
        var primaryId = $('#primaryID').val();
        var category = $('#selAssetCategory').val();
        var Servicesids = $('#ServiceIDs').val();
        if (category == 73) {
            if (Servicesids == 1) {
                window.location.href = "/bems/assetregister/Index/" + primaryId;
            } else {
                window.location.href = "/fems/assetregister/Index/" + primaryId;
            }
        } else {
            if (Servicesids == 1) {
                window.location.href = "/bems/loanerequipment/Index/" + primaryId;
            } else {
                window.location.href = "/fems/loanerequipment/Index/" + primaryId;
            }
        }
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

    $('#selTandCStatus').change(function () {
        var tAndCStatus = $('#selTandCStatus').val();
        var statusName = $('#divTandCStatus').text();

        if (tAndCStatus == 72) {
            $('#txtTCCompletedDate').val('').attr('disabled', false).removeAttr('required');
            $('#txtHandoverDate').val('').attr('disabled', true).removeAttr('required');

            $('#txtTCCompletedDate').parent().removeClass('has-error');
            $('#txtHandoverDate').parent().removeClass('has-error');

            $('#spnTAndCCompletedDate').hide();
            $('#spnHandoverDate').hide();
        } else if(tAndCStatus == 285){
            $('#txtTCCompletedDate').removeAttr('required');
            $('#txtHandoverDate').removeAttr('required');

            $('#txtTCCompletedDate').attr('disabled', false);
            $('#txtHandoverDate').attr('disabled', false);

            $('#txtTCCompletedDate').parent().removeClass('has-error');
            $('#txtHandoverDate').parent().removeClass('has-error');

            $('#spnTAndCCompletedDate').hide();
            $('#spnHandoverDate').hide();

            $('#txtTCCompletedDate').val(KeepInViewTCCompletedDate == null ? null : moment(KeepInViewTCCompletedDate).format("DD-MMM-YYYY"));
            $('#txtHandoverDate').val(KeepInViewHandoverDate == null ? null : moment(KeepInViewHandoverDate).format("DD-MMM-YYYY"));
        }
        else {
            $('#txtTCCompletedDate').attr('required', true).attr('disabled', false);
            $('#txtHandoverDate').attr('required', true).attr('disabled', false);
            $('#spnTAndCCompletedDate').show();
            $('#spnHandoverDate').show();

            $('#txtTCCompletedDate').val(KeepInViewTCCompletedDate == null ? null : moment(KeepInViewTCCompletedDate).format("DD-MMM-YYYY"));
            $('#txtHandoverDate').val(KeepInViewHandoverDate == null ? null : moment(KeepInViewHandoverDate).format("DD-MMM-YYYY"));
        }

        //if (tAndCStatus == 285) {
        //    if (statusName == 'Keep in view') {
        //        $('#txtRequiredCompletionDate').val($('#hdnRequiredCompletionDate').val()).attr('disabled', false);
        //    } else {
        //        $('#txtRequiredCompletionDate').val('').attr('disabled', false);
        //    }
            
        //    $('#txtRequiredCompletionDate').attr('required', true);
        //    $('#spnRequiredCompletionDate').show();
        //} else {
        //    if (statusName == 'Keep in view') {
        //        $('#txtRequiredCompletionDate').val($('#hdnRequiredCompletionDate').val()).attr('disabled', true);
        //    } else { 
        //        $('#txtRequiredCompletionDate').val('').attr('disabled', true);
        //    }
        //    $('#txtRequiredCompletionDate').removeAttr('required');
        //    $('#spnRequiredCompletionDate').hide();
        //}

    })

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

    //var ID = getUrlParameter('id');

    //if (ID != null && ID != 0 && ID != '') {
    //    LinkClicked(ID, 'Passed');
    //    FromNotification = true;
    //}
    

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
        LinkClicked(ID, 'Passed');
        FromNotification = true;
    }
    // **** Query String to get ID  End****\\\


    });

$('#btnEditVerifyRejectApproveClone').click(function () {
    $("#primaryID").val('');
    $('#txtSerialNo').val('');
    $('#txtOldAssetNumber').val('');
    $('#txtTCDocumnetNo').val('');
    $('#txtAppointmentDate').val('');
    $('.TandCStatusName').text('');
    $('#txtARAssetPreRegistrationNo').val('');
    $('#btnEditVerifyRejectApproveClone').hide();
    $('#btnSaveEditVerifyRejectApproveConvetToAsset, #btnSaveEditVerifyRejectApproveConvetToAsset1').hide();
    $('#btnSave').attr('disabled', false);
    $('#btnSave').show();
    $('#btnEdit').hide();
    EnableFields();
});


//***** Grid Merging*********\\

function LinkClicked(id, rowData) {
   
    debugger;

    //$(".content").scrollTop(1);
    
    $('.nav-tabs a:first').tab('show')
    $("#frmTestingAndCommissioning :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    //var action = "";
    
    $('#primaryID').val(id);
    $('#UserRoleName').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");
    var hasApprovePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");
    var hasVerifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Verify'");
    var hasRejectPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Reject'");
    //var hasClarifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Clarify'");


    //if (hasEditPermission && hasViewPermission) {
    //    action = "Edit"
    //}
    //else if (!hasEditPermission && hasViewPermission) {
    //    action = "View"
    //}
  
    if (hasEditPermission || hasApprovePermission || hasVerifyPermission || hasRejectPermission)
    {
        $('#btnEditVerifyRejectApproveClone').show();
    }
    //if (action == 'View') {
    //    $("#frmTestingAndCommissioning :input:not(:button)").prop("disabled", true);
    //    } else {
    //        // $('#btnEdit').show();
    //         $('#btnSave').hide();
    //        //$('#btnSaveandAddNew').hide();
    //        $('#btnNextScreenSave').show();
    //}
    
    var status = rowData.TandCStatusName;
    //if (status == "Keep in view") // Edit btn only to be shown
    //{
    //    $('#btnVerify').hide();
    //    $('#btnApprove').hide();
    //    $('#btnReject').hide();
    //    $('#btnSave').hide();
    //    $('#btnEdit').show();////
    //    $('#btnSaveandAddNew').hide(); 
    //    $('#btnCancel').show();

    //    EnableFields();
    //    //$.each($('#frmTestingAndCommissioning :input:not(:button)'), function (index, value) {
    //    //    $(this).attr('disabled', false);
    //    //});

    //    //$('#').attr('disabled', true);
    //    //$('#').attr('disabled', true);
    //}
    //else

     if (status == "Failed" || status == "Passed" || status == "Keep in view") // only view
        {
        $('#btnVerify').hide();
        $('#btnApprove').hide();
        $('#btnReject').hide();
        $('#btnSave').hide();
        $('#btnEdit').hide();
        $('#btnSaveandAddNew').hide();
        $('#btnCancel').show();
        $.each($('#frmTestingAndCommissioning :input:not(:button)'), function (index, value) {
            $(this).attr('disabled', true);
        });
        $('#spnPopup-typeCode').unbind("click").attr('disabled', true).css('cursor', 'default');
        $('#spnPopup-crmrequestno').unbind("click").attr('disabled', true).css('cursor', 'default');
        $('#spnPopup-CompanyRepresentative').unbind("click").attr('disabled', true).css('cursor', 'default');
        $('#spnPopup-hospitalRepresentative').unbind("click").attr('disabled', true).css('cursor', 'default');
        $('#spnPopup-model').unbind("click").attr('disabled', true).css('cursor', 'default');
        $('#spnPopup-manufacturer').unbind("click").attr('disabled', true).css('cursor', 'default');
        $('#spnPopup-locationName').unbind("click").attr('disabled', true).css('cursor', 'default');

        $("#anchorCreateTypeCode").unbind("click");
        $("#anchorCreateTypeCode").css('cursor', 'default');
    }
    //else if ((status == "Passed")) // No Edit--- Verify/Approve/Reject  to be shown
    //{
    //    $('#btnVerify').show();
    //    $('#btnApprove').show();
    //    $('#btnReject').show();
    //    $('#btnSave').hide();
    //    $('#btnEdit').hide();
    //    $('#btnSaveandAddNew').hide();
    //    $('#btnCancel').show();

    //    $("#anchorCreateTypeCode").unbind("click");
    //    $("#anchorCreateTypeCode").css('cursor', 'default');
    //} 
     if (status == "Keep in view") {
         $('#btnEdit').show();
         $('#selTandCStatus').attr('disabled', false);
         $('#txtTCCompletedDate').attr('disabled', false);
         $('#txtHandoverDate').attr('disabled', false);
         $('#txaRemarks').attr('disabled', false);
     }
    
    //$('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/testingAndCommissioning/Get/" + primaryId)
          .done(function (result) {
              var getResult = JSON.parse(result);
              $('#txtTCDocumnetNo').val(getResult.TandCDocumentNo);
              $('#txtAppointmentDate').val(getResult.RequestDate == null ? '' : moment(getResult.RequestDate).format("DD-MMM-YYYY"));
              $('#txtCRMRequestDate').val(getResult.RequestDate == null ? '' : moment(getResult.RequestDate).format("DD-MMM-YYYY"));
              $('#txtTCDate').val(moment(getResult.TandCDate).format("DD-MMM-YYYY"));
              $('#selAssetCategory').val(getResult.AssetCategoryLovId);
              $('#hdnCRMRequestId').val(getResult.CRMRequestId),
              $('#txtCRMRequestNo').val(getResult.CRMRequestNo),
              //$('#selServiceType').val(getResult.TypeOfService),
              $('#selBatchNo').val(getResult.BatchNo),
              $('#hdnTypeCodeId').val(getResult.AssetTypeCodeId);
              $('#txtTypeCode').val(getResult.AssetTypeCode);
              $('#txtTypeDescription').val(getResult.AssetTypeDescription);
              $('#selTandCStatus').val(getResult.TandCStatus);
              $('#txtCRMRequestNo').attr('disabled', true);

              var tAndCStatus = getResult.TandCStatus;
              if (tAndCStatus == 72) {
                  $('#txtTCCompletedDate').val('').removeAttr('required');
                  $('#txtHandoverDate').val('').removeAttr('required');
                  $('#spnTAndCCompletedDate').hide();
                  $('#spnHandoverDate').hide();
              }
              else if (tAndCStatus == 285) {
                  $('#txtTCCompletedDate').removeAttr('required');
                  $('#txtHandoverDate').removeAttr('required');
                  $('#spnTAndCCompletedDate').hide();
                  $('#spnHandoverDate').hide();
              }
              else {
                      $('#txtTCCompletedDate').attr('required', true);
                      $('#txtHandoverDate').attr('required', true);
                      $('#spnTAndCCompletedDate').show();
                      $('#spnHandoverDate').show();
                }
              

              //if (tAndCStatus == 285) {
              //    $('#txtRequiredCompletionDate').attr('disabled', false);
              //    $('#txtRequiredCompletionDate').attr('required', true);
              //    $('#spnRequiredCompletionDate').show();
                  
              //} else {
              //  $('#txtRequiredCompletionDate').val('').attr('disabled', true);
              //  $('#txtRequiredCompletionDate').removeAttr('required');
              //  $('#spnRequiredCompletionDate').hide();
              //}

            //  if (action != 'Edit') {
            //      $.each($('#frmTestingAndCommissioning :input:not(:button)'), function (index, value) {
            //          $(this).attr('disabled', true);
            //  });
            //      $("#anchorCreateTypeCode").unbind("click");
            //      $("#anchorCreateTypeCode").css('cursor', 'default');
            //}

              $('#txtARAssetPreRegistrationNo').val(getResult.AssetPreRegistrationNo);
              $('#txtTCCompletedDate').val(getResult.TandCCompletedDate == null ? null : moment(getResult.TandCCompletedDate).format("DD-MMM-YYYY"));
              $('#txtHandoverDate').val(getResult.HandoverDate == null ? null : moment(getResult.HandoverDate).format("DD-MMM-YYYY"));

              KeepInViewTCCompletedDate = getResult.TandCCompletedDate;
              KeepInViewHandoverDate = getResult.HandoverDate;

              $('#txtPurchaseCost').val(getResult.PurchaseCost == 0 ? null : getResult.PurchaseCost);
              $('#txtContract').val(getResult.ContractLPONo);
              $('#selVariationStatus').val(getResult.VariationStatus);
              $('#txtContractorRepresentative').val(getResult.TandCContractorRepresentative);
              $('#hdnCompanyRepresentative').val(getResult.FmsCustomerRepresentativeId);
              $('#txtCompanyRepresentative').val(getResult.CustomerRepresentativeName);
              $('#hdnHospitalRepresentative').val(getResult.FmsFacilityRepresentativeId);
              $('#txtHospitalRepresentative').val(getResult.FacilityRepresentativeName);
              $('#txtDesignation').val(getResult.Designation);
              $('#txaRemarks').val(getResult.Remarks);

              $('#txtRequiredCompletionDate').val(moment(getResult.RequiredCompletionDate).format("DD-MMM-YYYY"));
              //$('#hdnRequiredCompletionDate').val(moment(getResult.RequiredCompletionDate).format("DD-MMM-YYYY"));
              $('#hdnModelId').val(getResult.ModelId);
              $('#txtModel').val(getResult.Model);
              $('#hdnManufacturerId').val(getResult.ManufacturerId);
              $('#txtManufacturer').val(getResult.Manufacturer);
              $('#txtSerialNo').val(getResult.SerialNo);
              $('#txtOldAssetNumber').val(getResult.AssetNoOld);
              //$('#txtPONumber').val(getResult.PONo);
              $('#hdnLocationId').val(getResult.UserLocationId);
              $('#txtLocationName').val(getResult.UserLocationName);
              $('#hdnAreaId').val(getResult.UserAreaId);
              $('#txtAreaName').val(getResult.UserAreaName);
              $('#txtLevlName').val(getResult.LevelName);
              $('#txtBlockName').val(getResult.BlockName);

              $('#txtPurchaseOrderNo').val(getResult.PurchaseOrderNo);
              $('#txtPurchaseDate').val(getResult.PurchaseDate == null ? null : moment(getResult.PurchaseDate).format("DD-MMM-YYYY"));
              if (getResult.PurchaseCost != null) {
                   $('#txtPurchaseCost').val(addCommas(getResult.PurchaseCost));
              }
              else {
                  $('#txtPurchaseCost').val(getResult.PurchaseCost);
              }
             
              $('#txtContractNo').val(getResult.ContractLPONo);
              $('#txtServiceStartDate').val(getResult.ServiceStartDate == null ? null : moment(getResult.ServiceStartDate).format("DD-MMM-YYYY"));
              $('#txtServiceEndtDate').val(getResult.ServiceEndDate == null ? null : moment(getResult.ServiceEndDate).format("DD-MMM-YYYY"));

              $('#hdnContractorId').val(getResult.ContractorId);
              $('#txtMainSupplierCode').val(getResult.MainSupplierCode);
              $('#txtMainSupplierName').val(getResult.MainSupplierName);
              $('#txtWarrantyStartDate').val(getResult.WarrantyStartDate == null ? null : moment(getResult.WarrantyStartDate).format("DD-MMM-YYYY"));
              $('#txtWarrantyDuration').val(getResult.WarrantyDuration);
              $('#txtWarrantyEndDate').val(getResult.WarrantyEndDate == null ? null : moment(getResult.WarrantyEndDate).format("DD-MMM-YYYY"));
              $('#selWarrantyStatus').val(getResult.WarrantyStatus == null ? "null" : getResult.WarrantyStatus);

              $('#txaSNFRemarks').val(getResult.SNFRemarks);

              $('.TandCStatusName').text(getResult.StatusName);
              
              if (getResult.StatusName == "Approved" && !getResult.IsUsed) {
                  $('#btnSaveEditVerifyRejectApproveConvetToAsset, #btnSaveEditVerifyRejectApproveConvetToAsset1').show();
                 
              }
              else {
                  $('#btnSaveEditVerifyRejectApproveConvetToAsset, #btnSaveEditVerifyRejectApproveConvetToAsset1').hide();
                
              }

             
              $('#hdnTimestamp').val(getResult.Timestamp);
              $('#hdnAttachId').val(getResult.HiddenId);

              formInputValidation("frmTestingAndCommissioning");
              $(".content").scrollTop(1);
              $('#myPleaseWait').modal('hide');
          })
         .fail(function (response) {
             $('#myPleaseWait').modal('hide');
             $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
             $('#errorMsg').css('visibility', 'visible');
         });
    }
    else {
        $('#txtManufacturer').attr('disabled', true);
        $('#spnPopup-manufacturer').unbind("click").attr('disabled', true).css('cursor', 'default');
        $('#txtModel').attr('disabled', true);
        $('#spnPopup-model').unbind("click").attr('disabled', true).css('cursor', 'default');
        $('#myPleaseWait').modal('hide');
    }
  //  ScreenRolePermissionChecking()
}

function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/testingandcommissioning/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('User Registration', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 EmptyFields();
             })
             .fail(function () {
                 showMessage('User Registration', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
        }

    });
}
function EmptyFields() {
    $(".content").scrollTop(0);
    $('.nav-tabs a:first').tab('show')
    $('input[type="text"], textarea').val('');
    $('#LevelFacility').val("null");
    $('#selVariationStatus').val("null");
    $('#LevelCode').prop('disabled', false);
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $('#selServiceType').val('');
    $('#selBatchNo').val(''),
    $("#grid").trigger('reloadGrid');
    $('#txtCRMRequestNo').attr('disabled', false);
    $("#frmTestingAndCommissioning :input:not(:button)").parent().removeClass('has-error');
    $("#frmSNF :input:not(:button)").parent().removeClass('has-error');
    $("#frmAdditionalInfo :input:not(:button)").parent().removeClass('has-error');

    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#errorMsgSNF').css('visibility', 'hidden');
    $('#errorMsgAdditionalInfoTab').css('visibility', 'hidden');

    // To make not disable
    $.each($('#frmTestingAndCommissioning :input:not(:button)'), function (index, value) {
        $(this).attr('disabled', false);
    });
    $.each($('#frmSNF :input:not(:button)'), function (index, value) {
        $(this).attr('disabled', false);
    });
    $('#txaSNFRemarks').attr('disabled', false);

    $('#spnPopup-typeCode').attr('disabled', false).css('cursor', 'pointer');
    $('#spnPopup-typeCode').click(function () {
        DisplaySeachPopup('divSearchPopup', typeCodeSearchObj, "/api/Search/TypeCodeSearch");
    });
    $('#spnPopup-crmrequestno').attr('disabled', false).css('cursor', 'pointer');
    $('#spnPopup-crmrequestno').click(function () {
        DisplaySeachPopup('divSearchPopup', crmRequestNoSearchObj, "/api/Search/TAndCCRMRequestNoSearch");
    });
    $('#spnPopup-CompanyRepresentative').attr('disabled', false).css('cursor', 'pointer');
    $('#spnPopup-CompanyRepresentative').click(function () {
        DisplaySeachPopup('divSearchPopup', companyRepresentativeSearchObj, "/api/Search/CompanyStaffSearch");
    });
    $('#spnPopup-hospitalRepresentative').attr('disabled', false).css('cursor', 'pointer');
     $('#spnPopup-hospitalRepresentative').click(function () {
        DisplaySeachPopup('divSearchPopup', hospitalRepresentativeSearchObj, "/api/Search/FacilityStaffSearch");
    });
    $('#spnPopup-locationName').attr('disabled', false).css('cursor', 'pointer');
    $('#spnPopup-locationName').click(function () {
        DisplaySeachPopup('divSearchPopup', locationNameSearchObj, "/api/Search/LocationCodeSearch");
    });

    $("#anchorCreateTypeCode").css('cursor', 'pointer');
    $("#anchorCreateTypeCode").unbind("click");
    $('#anchorCreateTypeCode').click(function () {
        bootbox.confirm('You will be redirected to the Type Code screen. Are you sure you want to proceed?', function (result) {
            if (result) {
                window.location.href = "/bems/typecodedetails/add";
            }
        });
    });


    $('#spnPopup-model').unbind("click").attr('disabled', true).css('cursor', 'default');
    $('#spnPopup-manufacturer').unbind("click").attr('disabled', true).css('cursor', 'default');
    $('#txtModel').attr('disabled', true);
    $('#txtManufacturer').attr('disabled', true);

    $('#selAssetCategory').val(73);
    $('#selTandCStatus').val(71);

    $('#txtTCDocumnetNo').prop('disabled', true);
    $('#txtAppointmentDate').prop('disabled', true);
    $('#txtARAssetPreRegistrationNo').prop('disabled', true);
    $('#txtCRMRequestDate').prop('disabled', true);
    $('#txtLocationName').prop('disabled', true);
    $('#txtAreaName').prop('disabled', true);
    $('#txtLevlName').prop('disabled', true);
    $('#txtBlockName').prop('disabled', true);
    $('.TandCStatusName').text('');
    $('#btnEditVerifyRejectApproveClone').hide();

    KeepInViewTCCompletedDate = null;
    KeepInViewHandoverDate = null;
    ScreenRolePermissionChecking()
}


function EnableFields(){

    $("#frmTestingAndCommissioning :input:not(:button)").parent().removeClass('has-error');
    $("#frmSNF :input:not(:button)").parent().removeClass('has-error');
    $("#frmAdditionalInfo :input:not(:button)").parent().removeClass('has-error');

    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#errorMsgSNF').css('visibility', 'hidden');
    $('#errorMsgAdditionalInfoTab').css('visibility', 'hidden');

    $.each($('#frmTestingAndCommissioning :input:not(:button)'), function (index, value) {
        $(this).attr('disabled', false);
    });
    $.each($('#frmSNF :input:not(:button)'), function (index, value) {
        $(this).attr('disabled', false);
    });
    $('#txaSNFRemarks').attr('disabled', false);

    $('#spnPopup-typeCode').attr('disabled', false).css('cursor', 'pointer');
    $('#spnPopup-typeCode').click(function () {
        DisplaySeachPopup('divSearchPopup', typeCodeSearchObj, "/api/Search/TypeCodeSearch");
    });

    $('#spnPopup-crmrequestno').attr('disabled', false).css('cursor', 'pointer');
    $('#spnPopup-crmrequestno').click(function () {
        DisplaySeachPopup('divSearchPopup', crmRequestNoSearchObj, "/api/Search/TAndCCRMRequestNoSearch");
    });

    $('#spnPopup-CompanyRepresentative').attr('disabled', false).css('cursor', 'pointer');
    $('#spnPopup-CompanyRepresentative').click(function () {
        DisplaySeachPopup('divSearchPopup', companyRepresentativeSearchObj, "/api/Search/CompanyStaffSearch");
    });
    $('#spnPopup-hospitalRepresentative').attr('disabled', false).css('cursor', 'pointer');
     $('#spnPopup-hospitalRepresentative').click(function () {
        DisplaySeachPopup('divSearchPopup', hospitalRepresentativeSearchObj, "/api/Search/FacilityStaffSearch");
    });
    $('#spnPopup-locationName').attr('disabled', false).css('cursor', 'pointer');
    $('#spnPopup-locationName').click(function () {
        DisplaySeachPopup('divSearchPopup', locationNameSearchObj, "/api/Search/LocationCodeSearch");
    });

    $("#anchorCreateTypeCode").css('cursor', 'pointer');
    $("#anchorCreateTypeCode").unbind("click");
    $('#anchorCreateTypeCode').click(function () {
        bootbox.confirm('You will be redirected to the Type Code screen. Are you sure you want to proceed?', function (result) {
            if (result) {
                window.location.href = "/bems/typecodedetails/add";
            }
        });
    });


    $('#spnPopup-model').unbind("click").attr('disabled', true).css('cursor', 'default');
    $('#spnPopup-manufacturer').unbind("click").attr('disabled', true).css('cursor', 'default');
    $('#txtModel').attr('disabled', true);
    $('#txtManufacturer').attr('disabled', true);

    $('#txtCRMRequestNo').val('');
    $('#hdnCRMRequestId').val('');
    $('#txtRequiredCompletionDate').val('');
    $('#txtRequiredCompletionDate').attr('disabled', true);

    $('#txtTCDocumnetNo').prop('disabled', true);
    $('#txtAppointmentDate').prop('disabled', true);
    $('#txtARAssetPreRegistrationNo').prop('disabled', true);
    $('#txtAreaName').prop('disabled', true);
    $('#txtLevlName').prop('disabled', true);
    $('#txtBlockName').prop('disabled', true);
    $('.TandCStatusName').text('');
    $('#txtCRMRequestDate').val('').attr('disabled', true);
    ScreenRolePermissionChecking()
}

function ScreenRolePermissionChecking() {
    debugger;
    var roleId = $("#hdnUserRoleId").val();
    var moduleId = $("#hdnModuleId").val();

    if (roleId == ! "null" || moduleId == "null") {
    }
    else {
        $('#myPleaseWait').modal('show');

        $.get("/api/roleScreenPermission/Fetch/" + roleId + "/" + moduleId)
        .done(function (result) {            
            var fetchResultNew = JSON.parse(result);
            $.each(fetchResultNew, function (index, value) {
                if (value.ScreenDescription == "Testing & Commissioning") {
                    var screenPermissionArr = value.Permissions.split('');
                    $.each(screenPermissionArr, function (index1, value1) {
                        debugger;
                        switch (index1) {
                            case 0:
                                if (value1 == 1) {
                                    $('#btnSave').show();
                                    $('#btnSaveandAddNew').show();
                                }
                                else {
                                    $('#btnSave').hide();
                                    $('#btnSaveandAddNew').hide();
                                }

                                case 1:
                                    if (value1 == 1) {
                                        $('#btnEdit').show();
                                    }
                                    else {
                                        $('#btnEdit').hide();
                                    }

                            case 5:
                                if (value1 == 1) {
                                    $('#btnApprove').show();
                                }
                                else {
                                    $('#btnApprove').hide();
                                }

                            case 6:
                                if (value1 == 1) {
                                    $('#btnReject').show();
                                }
                                else {
                                    $('#btnReject').hide();
                                }
                        }
                    });

                }

            });

            $('#myPleaseWait').modal('hide');
        })
        .fail(function (response) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            $('#errorMsg').css('visibility', 'visible');
        });
    }

}


