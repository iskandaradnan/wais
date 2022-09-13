var RealTimeStatusClicked = null;
var AssetStatusClicked = null;
var parentAssetNoSearchObj = null;
FromNotification = false;
var authorization = 0;
$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    formInputValidation("frmAssetRegister");
    var actionType = $('#hdnARActionType').val();
    $('#btnDelete').hide();
    $('#btnAREdit').hide();
    $('#btnNextScreenSave').hide();
    $('#exportbtn').hide();

    var softwareObjList = [];

    $.get("/api/assetRegister/Load")
        .done(function (result) {
        var loadResult = JSON.parse(result);
        if (!loadResult.IsAdditionalFieldsExist) {
            $('#liAFAdditionalInfo').hide();
        }
        $.each(loadResult.AssetClassifications, function (index, value) {
            $('#selARAssetClassification').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(loadResult.Facilities, function (index, value) {
            $('#selARFacilityId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(loadResult.RealTimeStatusValues, function (index, value) {
            $('#selARRealTimeStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(loadResult.AppliedPartTypeValues, function (index, value) {
            $('#selARAppliedPartType').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(loadResult.EquipmentClassValues, function (index, value) {
            $('#selAREquipmentClass').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(loadResult.PowerSpecificationValues, function (index, value) {
            $('#selARSpecificationUnitType').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(loadResult.PurchaseCategoryValues, function (index, value) {
            $('#selARPurchaseCategory').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(loadResult.StatusValues, function (index, value) {
            $('#selARAssetStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(loadResult.AssetTransferModeValues, function (index, value) {
            $('#selARAssetTransferMode').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(loadResult.YesNoValues, function (index, value) {
            $('#selARPPM').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(loadResult.YesNoValues, function (index, value) {
            $('#selAROther').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(loadResult.YesNoValues, function (index, value) {
            $('#selARRI').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(loadResult.RiskRatings, function (index, value) {
            $('#selARRiskRating').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(loadResult.YesNoValues, function (index, value) {
            $('#selRunningHoursCapture').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(loadResult.ContractTypes, function (index, value) {
            $('#selContractType').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
            $.each(loadResult.Asset_Category, function (index, value) {
                $('#selAssetCategoryid').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        //$.each(loadResult.WorkGroup, function (index, value) {
        //    $('#selWorkGroup').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        //});
        //    $.each(loadResult.WorkGroup, function (index, value) {
        //        $('#selWorkGroupfems').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        //    });
            $.each(loadResult.BatchNo, function (index, value) {
                $('#selBatchNo').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

        $('#selARAssetClassification').val("null");
        $('#selARServiceId,.selARServiceId').val(2);
        $('#selARAssetStatus').val(1);
        $('#selARRiskRating').val(113);
        $('#selRunningHoursCapture').val(100);

        var testingAndCommissioningId = $('#hdnTestingAndCommissioningId').val();
        if (testingAndCommissioningId != null && testingAndCommissioningId != "" && testingAndCommissioningId != "0") {
            $.get("/api/assetRegister/GetTestingAndCommissioningDetails/" + testingAndCommissioningId)
                  .done(function (result) {
                      var getResult = JSON.parse(result);
                      $('#btnAREdit').removeClass('hider');
                      $("#btnAREdit").show();

                      $('#hdnARAssetPreRegistrationNoId').val(getResult.TestingandCommissioningDetId);
                      $('#txtARAssetPreRegistrationNo').val(getResult.AssetPreRegistrationNo);
                      $('#txtARAssetNo').val(getResult.AssetNo); 
                      $('#hdnARTypeCodeId').val(getResult.AssetTypeCodeId);
                      $('#txtARTypeCode,.txtARTypeCode').val(getResult.AssetTypeCode);
                      $('#txtARTypeDescription').val(getResult.AssetTypeDescription);//, #txtARAssetDescription
                      $(".txtARAssetDescription").val(getResult.AssetTypeDescription);
                      $('#hdnARModelId').val(getResult.Model);
                      $('#txtARModel').val(getResult.ModelName);
                      $('#hdnARManufacturerId').val(getResult.Manufacturer);
                      $('#txtARManufacturer').val(getResult.ManufacturerName);

                      $('#txtARAssetAge').val(getResult.AssetAge);
                      $('#txtARYearInService').val(getResult.YearsInService);
                      $('#txtARCommissioningDate').val(getResult.TandCDate == null ? null : moment(getResult.TandCDate).format("DD-MMM-YYYY"));
                      $('#txtARServiceStartDate, #txtServiceStartDate').val(getResult.ServiceStartDate == null ? null : moment(getResult.ServiceStartDate).format("DD-MMM-YYYY"));
                      if (getResult.PurchaseCost != null) {
                          $('#txtARPurchaseCost').val(addCommas(getResult.PurchaseCost));
                      }
                      else {
                          $('#txtARPurchaseCost').val('');
                      }
                      $('#txtARPurchaseDate').val(getResult.PurchaseDate == null ? null : moment(getResult.PurchaseDate).format("DD-MMM-YYYY"));
                      $('#txtARWarrantyDuration').val(getResult.WarrantyDuration);
                      $('#txtARWarrantyStartDate').val(getResult.WarrantyStartDate == null ? null : moment(getResult.WarrantyStartDate).format("DD-MMM-YYYY"));

                      $('#txtARWarrantyEndDate').val(getResult.WarrantyEndDate == null ? null : moment(getResult.WarrantyEndDate).format("DD-MMM-YYYY"));
                      $('#txtARPurchaseOrderNumber').val(getResult.PurchaseOrderNo);
                      $('#selARAssetClassification').val(getResult.AssetClassificationId);

                      $('#txtARSerialNo').val(getResult.SerialNo);
                      $('#hdnARInstalledLocationId').val(getResult.InstalledLocationCodeId);
                      $('#txtARInstalledLocationName').val(getResult.InstalledLocationName);
                      $('#txtARInstalledLocationCode').val(getResult.InstalledLocationCode);
                      $('#txtARBlockName').val(getResult.BlockName);
                      $('#txtARBlockCode').val(getResult.BlockCode);
                      $('#txtARLevelName').val(getResult.LevelName);
                      $('#txtARLevelcode').val(getResult.LevelCode);
                      $('#hdnARUserAreaId').val(getResult.UserAreaId);
                      $('#txtARUserAreaName').val(getResult.UserAreaName);
                      $('#txtARUserAreaCode').val(getResult.UserAreaCode);
                      $('#hdnARLocationId').val(getResult.UserLocationId);
                      $('#txtARUserLocationName').val(getResult.UserLocationName);
                      $('#txtARUserLocationCode').val(getResult.UserLocationCode);

                      $('#txtARCurrentAreaName').val(getResult.CurrentAreaName);
                      $('#txtARCurrentAreaCode').val(getResult.CurrentAreaCode);

                      $('#selARPPM').val(getResult.PpmPlannerId == 0 || getResult.PpmPlannerId == null ? "null" : getResult.PpmPlannerId);
                      $('#selARRI').val(getResult.RiPlannerId == 0 || getResult.RiPlannerId == null ? "null" : getResult.RiPlannerId);
                      $('#selAROther').val(getResult.OtherPlannerId == 0 || getResult.OtherPlannerId == null ? "null" : getResult.OtherPlannerId);
                      $('#txtExpectedLifespan').val(getResult.ExpectedLifeSpan == null ? '' : getResult.ExpectedLifeSpan);

                      //var ppm = getResult.PpmPlannerId;
                      //var ri = getResult.RiPlannerId;
                      //var other = getResult.OtherPlannerId;

                      //if(ppm == "99") {
                      //     $('#anchorARPPM').show();
                      //  } else {
                      //      $('#anchorARPPM').hide();
                      //}
                      //if (other == "99") {
                      //$('#anchorARCalibration').show();
                      //} else {
                      //  $('#anchorARCalibration').hide();
                      //}
                      //if(ri == "99") {
                      //      $('#anchorARRI').show();
                      //} else {
                      //  $('#anchorARRI').hide();
                      //}
                      $('#anchorARPPM').hide();
                      $('#anchorARCalibration').hide();
                      $('#anchorARRI').hide();
                      $('#selARAssetClassification').attr('disabled', true);
                      $('#txtARAssetPreRegistrationNo').attr('disabled', true);
                      $('#txtARTypeCode').attr('disabled', true);
                      $('#txtARManufacturer').attr('disabled', true);
                      $('#txtARModel').attr('disabled', true);

                      $('#spnPopup-assetPreRegistration').unbind("click").attr('disabled', true).css('cursor', 'default');
                      $('#spnPopup-typeCode').unbind("click").attr('disabled', true).css('cursor', 'default');
                      $('#spnPopup-manufacturer').unbind("click").attr('disabled', true).css('cursor', 'default');
                      $('#spnPopup-model').unbind("click").attr('disabled', true).css('cursor', 'default');

                      $('#anchorARAssetStatus').attr('disabled', true).unbind('click').css('cursor', 'default');
                      $('#anchorARRealTimeStatus').attr('disabled', true).unbind('click').css('cursor', 'default');
                      $('#anchorARDefectList').attr('disabled', true);

                      $(".content").scrollTop(1);
                  })
                 .fail(function (response) {
                     $('#myPleaseWait').modal('hide');
                     var errorMessage = "";
                     if (response.status == 400) {
                         errorMessage = response.responseJSON;
                     }
                     else {
                         errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
                     }
                     if (errorMessage != 'Asset Pre Registration No. already used') {
                         $("div.errormsgcenter").text(errorMessage);
                         $('#errorMsg').css('visibility', 'visible');
                     }
                 });
        }
        else {
            //$("#jQGridCollapse1").click();
            //$("#frmAssetRegister :input:not(:button)").prop("disabled", true);

            $('#txtARAssetPreRegistrationNo').attr('disabled', true);
            $('#txtARTypeCode').attr('disabled', true);
            $('#txtARManufacturer').attr('disabled', true);
            $('#txtARModel').attr('disabled', true);

            $('#spnPopup-assetPreRegistration').unbind("click").attr('disabled', true).css('cursor', 'default');
            $('#spnPopup-typeCode').unbind("click").attr('disabled', true).css('cursor', 'default');

            $('#spnPopup-manufacturer').unbind("click").attr('disabled', true).css('cursor', 'default');
            $('#spnPopup-model').unbind("click").attr('disabled', true).css('cursor', 'default');
            $('#anchorARAssetStatus').attr('disabled', true).unbind('click').css('cursor', 'default');
            $('#anchorARRealTimeStatus').attr('disabled', true).unbind('click').css('cursor', 'default');
            $('#anchorARDefectList').attr('disabled', true);

            $('#anchorARPPM').hide();
            $('#anchorARCalibration').hide();
            $('#anchorARRI').hide();

            $('#btnARSave').hide();

            DisableFields();
        }
    })
.fail(function (response) {
    $('#myPleaseWait').modal('hide');
    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
    $('#errorMsg').css('visibility', 'visible');
});

    $('#liAssetRegister').click(function () {
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
    });

    $('.decimalCheck').each(function (index) {
        var vrate = document.getElementById(this.id);
        vrate.addEventListener('input', function (prev) {
            return function (evt) {
                if ((!/^\d{0,4}(?:\.\d{0,2})?$/.test(this.value))) {
                    this.value = prev;
                }
                else {
                    prev = this.value;
                }
            };
        }(vrate.value), false);
    });

    $("#btnARSave, #btnAREdit, #btnARApprove").click(function () {
        $('#btnARSave').attr('disabled', true);
        $('#btnAREdit').attr('disabled', true);

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var CurrentbtnID = $(this).attr("Id");
        var isFormValid = formInputValidation("AssetRegister", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnARSave').attr('disabled', false);
            $('#btnAREdit').attr('disabled', false);
            return false;
        }
        if ($('#txtARParentAsset').val() != '' && ($('#hdnARParentAssetId').val() == '' || $('#hdnARParentAssetId').val() == 'null')) {
            $("div.errormsgcenter").text('Please enter valid Parent Asset');
            $('#errorMsg').css('visibility', 'visible');

            $('#txtARParentAsset').parent().addClass('has-error');

            $('#btnARSave').attr('disabled', false);
            $('#btnAREdit').attr('disabled', false);
            return false;
        }
        var buttonId = $(this).attr("Id");

        if (buttonId == 'btnARApprove') {
            authorization = 199;
        }
        var Id = $('#hdnARPrimaryID').val();
        if (buttonId == 'btnAREdit' && authorization == 199 && Id != 0) {
            authorization = 200;
        }
        $('#myPleaseWait').modal('show');
        var purchaseCostRM = $('#txtARPurchaseCost').val();
        purchaseCostRM = purchaseCostRM.split(',').join('');
        //var purchaseCostRM = $('#txtWCPurchaseCost').val();
        //purchaseCostRM = purchaseCostRM.split(',').join('');       
        var cumulativeLabourCost = $('#txtARCumulativeLabourCost').val();
        cumulativeLabourCost = cumulativeLabourCost.split(',').join('');
        var cumulativeContractCost = $('#txtARCumulativeContractCost').val();
        cumulativeContractCost = cumulativeContractCost.split(',').join('');
        var cumulativePartCost = $('#txtARCumulativePartsCost').val();
        cumulativePartCost = cumulativePartCost.split(',').join('');
      //  var WorkGroupss= $('#selWorkGroupfems option:selected').val();
        var saveObj = {
            AssetNo: $('#txtARAssetNo').val(),
            TestingandCommissioningDetId: $('#hdnARAssetPreRegistrationNoId').val(),
            AssetPreRegistrationNo: $('#txtARAssetPreRegistrationNo').val(),
            AssetTypeCodeId: $('#hdnARTypeCodeId').val(),
            AssetClassification: $('#selARAssetClassification').val(),
            AssetDescription: $('#txtARTypeDescription').val(),
            CommissioningDate: $('#txtARCommissioningDate').val(),
            AssetParentId: $('#hdnARParentAssetId').val(),
            ServiceStartDate: $('#txtARServiceStartDate').val(),
            EffectiveDate: $('#txtAREffectiveDate').val(),
            ExpectedLifespan: $('#txtExpectedLifespan').val(),
            RealTimeStatusLovId: $('#selARRealTimeStatus').val(),
            AssetStatusLovId: $('#selARAssetStatus').val(),
            OperatingHours: $('#txtAROperatingHours').val(),
            UserLocationId: $('#hdnARLocationId').val(),
            UserAreaId: $('#hdnARUserAreaId').val(),
            Manufacturer: $('#hdnARManufacturerId').val(),
            NamePlateManufacturer: $('#txtARNamePlateManufacturer').val(),
            ChassisNo: $('#txtARChassisNo').val(),
            EngineNo: $('#txtAREngineNo').val(),
            Model: $('#hdnARModelId').val(),
            AppliedPartTypeLovId: $('#selARAppliedPartType').val(),
            EquipmentClassLovId: $('#selAREquipmentClass').val(),
            Specification: $('#selARSpecification').val(),
            SerialNo: $('#txtARSerialNo').val(),
            RiskRating: $('#selARRiskRating').val(),
            TransferFacilityName: $('#txtARFacilityName').val(),
            TransferRemarks: $('#txtARRemarks').val(),
            PreviousAssetNo: $('#txtARPreviousAssetNo').val(),
            PurchaseOrderNo: $('#txtARPurchaseOrderNumber').val(),
            InstalledLocationId: $('#hdnARInstalledLocationId').val(),
            SoftwareVersion: $('#txtARSoftwareVersion').val(),
            SoftwareKey: $('#txtARSoftwareKey').val(),
            OtherTransferDate: $('#txtARTransferDate2').val(),
            TransferMode: $('#selARAssetTransferMode').val(),
            MainsFuseRating: $('#txtARMainFuseRating').val(),
            MainSupplier: $('#txtARMainSupplier').val(),
            ManufacturingDate: $('#txtARManufacturingDate').val(),
            PowerSpecification: $('#selARSpecificationUnitType').val(),
            PowerSpecificationWatt: $('#txtARSpecificationUnitWatt').val(),
            PowerSpecificationAmpere: $('#txtARSpecificationUnitAmpere').val(),
            Volt: $('#txtARVolt').val(),
            PpmPlannerId: $('#selARPPM').val(),
            RiPlannerId: $('#selARRI').val(),
            OtherPlannerId: $('#selAROther').val(),
            PurchaseCostRM: purchaseCostRM,
            PurchaseDate: $('#txtARPurchaseDate').val(),
            PurchaseCategory: $('#selARPurchaseCategory').val(),
            WarrantyDuration: $('#txtARWarrantyDuration').val(),
            WarrantyStartDate: $('#txtARWarrantyStartDate').val(),
            WarrantyEndDate: $('#txtARWarrantyEndDate').val(),
            CumulativePartCost: cumulativePartCost,
            CumulativeLabourCost: cumulativeLabourCost,
            CumulativeContractCost: cumulativeContractCost,
            Authorization: authorization,
            RunningHoursCapture: $('#selRunningHoursCapture').val(),
            ContractType: $('#selContractType').val(),
          //  WorkGroup: WorkGroupss,
            Asset_Category: $('#selAssetCategoryid').val(),
            BatchNo: $('#selBatchNo').val(),
            Asset_Name:$('#txtAsset_Name').val(),
        };

        var primaryId = $("#hdnARPrimaryID").val();
        if (primaryId != null) {
            saveObj.AssetId = primaryId;
            saveObj.Timestamp = $('#hdnARTimestamp').val();
        }
        else {
            saveObj.AssetId = 0;
            saveObj.Timestamp = "";
        }

        if (softwareObjList.length > 0) {
            saveObj.SoftwareDetails = softwareObjList;
        }

        var jqxhr = $.post("/api/assetRegister/Save", saveObj, function (response) {
            var result = JSON.parse(response);
            $('#txtARAssetNo').val(result.AssetNo);
            $('#exportbtn').show();
            $('#txtARTypeCode').attr('disabled', true);
            $('#txtARAssetPreRegistrationNo').attr('disabled', true);
            $('#spnPopup-assetPreRegistration').unbind("click").attr('disabled', true).css('cursor', 'default');
            $('#spnPopup-typeCode').unbind("click").attr('disabled', true).css('cursor', 'default');
            $('#txtARTypeCode').attr('disabled', true);
            $('#selARAssetClassification').attr('disabled', true);

            if (result.Authorization == 199) {
                $('.AssetAuthorizeStatus').text('Authorized');
                $('#btnARApprove').hide();
                authorization = 199;

            }
            else if (result.Authorization == 200) {
                $('.AssetAuthorizeStatus').text('Unauthorized');
                authorization = 200;
                $('#btnARApprove').show();
            }
            else {
                $('#btnARApprove').show();
            }

            $("#hdnARPrimaryID").val(result.AssetId);
            $("#hdnARTimestamp").val(result.Timestamp);
            $('#hdnAttachId').val(result.HiddenId);
            $("#grid").trigger('reloadGrid');
            if (result.AssetId != 0) {
                $('#LevelCode').prop('disabled', true);
                $('#btnNextScreenSave').show();
                $('#btnAREdit').show();
                $('#btnARSave').hide();
                $('#btnDelete').show();
            }

            $('#anchorARAssetStatus').unbind('click');
            $('#anchorARAssetStatus').click(AssetStatusClicked).attr('disabled', false).css('cursor', 'pointer');

            $('#anchorARRealTimeStatus').unbind('click');
            $('#anchorARRealTimeStatus').click(RealTimeStatusClicked).attr('disabled', false).css('cursor', 'pointer');
            $('#anchorARDefectList').attr('disabled', false);

            $(".txtARAssetNo").val(result.AssetNo);
            $(".txtARAssetDescription").val(result.AssetDescription);
            $(".txtARTypeCode").val($('#txtARTypeCode').val());
            $(".content").scrollTop(0);
            showMessage('Asset Register', CURD_MESSAGE_STATUS.SS);

            $('#btnARSave').attr('disabled', false);
            $('#btnAREdit').attr('disabled', false);
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
                errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
            }
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnARSave').attr('disabled', false);
            $('#btnAREdit').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
    });

    //------------------------Search----------------------------
    var typeCodeSearchObj = {
        Heading: "Type Code Details",//Heading of the popup
        SearchColumns: ['AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description', 'AssetClassificationCode-Asset Classification Code'],//ModelProperty - Space seperated label value
        ResultColumns: ["AssetTypeCodeId-Primary Key", 'AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description', 'AssetClassificationCode-Asset Classification Code'],//Columns to be returned for display
        AdditionalConditions: ["AssetClassificationId-selARAssetClassification"],
        FieldsToBeFilled: ["hdnARTypeCodeId-AssetTypeCodeId", "txtARTypeCode-AssetTypeCode", "txtARTypeDescription-AssetTypeDescription", "selARPPM-PPM", "selAROther-Other", "selARRI-RI"]//id of element - the model property--, , 
    };

    $('#spnPopup-typeCode').click(function () {
        DisplaySeachPopup('divARSearchPopup', typeCodeSearchObj, "/api/Search/TypeCodeSearch");
    });

    var locationCodeSearchObj = {
        Heading: "Location Code Details",
        SearchColumns: ['UserLocationCode-User Location Code', 'UserLocationName-User Location Name', 'UserAreaCode-User Area Code', 'UserAreaName-User Area Name'],
        ResultColumns: ["UserLocationId-Primary Key", 'UserLocationCode-User Location Code', 'UserLocationName-User Location Name', 'UserAreaCode-User Area Code', 'UserAreaName-User Area Name'],
        FieldsToBeFilled: ["hdnARLocationId-UserLocationId", "txtARUserLocationCode-UserLocationCode", "txtARUserLocationName-UserLocationName",
                         "txtARUserAreaCode-UserAreaCode", "txtARUserAreaName-UserAreaName", "hdnARUserAreaId-UserAreaId", "hdnARInstalledLocationId-UserLocationId",
                         "txtARInstalledLocationCode-UserLocationCode", "txtARInstalledLocationName-UserLocationName",
                         "txtARLevelName-LevelName", "txtARLevelcode-LevelCode", "txtARBlockName-BlockName", "txtARBlockCode-BlockCode"]
    };

    $('#spnPopup-userLocation').click(function () {
        DisplaySeachPopup('divARSearchPopup', locationCodeSearchObj, "/api/Search/LocationCodeSearch");
    });

    var manufacturerSearchObj = {
        Heading: "Manufacturer Details",
        SearchColumns: ['Manufacturer-Manufacturer'],
        ResultColumns: ["ManufacturerId-Primary Key", 'Manufacturer-Manufacturer'],
        AdditionalConditions: ["TypeCodeId-hdnARTypeCodeId", "ModelId-hdnARModelId"],
        FieldsToBeFilled: ["hdnARManufacturerId-ManufacturerId", "txtARManufacturer-Manufacturer"]
    };

    $('#spnPopup-manufacturer').click(function () {
        DisplaySeachPopup('divARSearchPopup', manufacturerSearchObj, "/api/Search/ManufacturerSearch");
    });

    var modelSearchObj = {
        Heading: "Model Details",
        SearchColumns: ['Model-Model'],
        ResultColumns: ["ModelId-Primary Key", 'Model-Model'],
        AdditionalConditions: ["TypeCodeId-hdnARTypeCodeId"],
        FieldsToBeFilled: ["hdnARModelId-ModelId", "txtARModel-Model"]
    };

    $('#spnPopup-model').click(function () {
        DisplaySeachPopup('divARSearchPopup', modelSearchObj, "/api/Search/ModelSearch");
    });

    var preRegistrationNoSearchObj = {
        Heading: "Asset Pre Registration No Details",
        SearchColumns: ['AssetPreRegistrationNo-Asset Pre Registration No.'],
        ResultColumns: ["TestingandCommissioningDetId-Primary Key", 'AssetPreRegistrationNo-Asset Pre Registration No.', 'PurchaseOrderNo-Purchase Order No.'],
        AdditionalConditions: ["AssetClassificationId-selARAssetClassification", "IsLoaner-hdnIsLoaner"],
        FieldsToBeFilled: ["hdnARAssetPreRegistrationNoId-TestingandCommissioningDetId", "txtARAssetAge-AssetAge",
            "txtARYearInService-YearsInService", "txtARAssetPreRegistrationNo-AssetPreRegistrationNo",
            "hdnTandCDate-TandCDate", "hdnARServiceStartDate-ServiceStartDate", "txtARMainSupplier-MainSupplierName",
            "SNFContractor-MainSupplierName", "txtARPurchaseCost-PurchaseCost", "hdnARPurchaseDate-PurchaseDate",
            "txtARWarrantyDuration-WarrantyDuration", "hdnARWarrantyStartDate-WarrantyStartDate",
            "hdnARWarrantyEndDate-WarrantyEndDate", "txtARPurchaseOrderNumber-PurchaseOrderNo"]
    };

    $('#spnPopup-assetPreRegistration').click(function () {
        DisplaySeachPopup('divARSearchPopup', preRegistrationNoSearchObj, "/api/Search/AssetPreRegistrationNoSearch");
    });

    parentAssetNoSearchObj = {
        Heading: "Parent Asset No Details",
        SearchColumns: ['AssetNo-Asset No.', 'AssetDescription-Asset Description'],
        ResultColumns: ["AssetId-Primary Key", 'AssetNo-Asset No.', 'AssetDescription-Asset Description'],
        AdditionalConditions: ["CurrentAssetId-hdnARPrimaryID", "IsFromAssetRegister-hdnIsFromAssetRegister"],
        FieldsToBeFilled: ["hdnARParentAssetId-AssetId", "txtARParentAsset-AssetNo"]
    };
    $('#spnPopup-parentAsset').unbind('click');
    $('#spnPopup-parentAsset').click(function () {
        DisplaySeachPopup('divARSearchPopup', parentAssetNoSearchObj, "/api/Search/ParentAssetNoSearch");
    }).attr('disabled', false).css('cursor', 'pointer');
    //----------------------------------------------------------

    //------------------------Fetch-----------------------------
    var typeCodeFetchObj = {
        SearchColumn: 'txtARTypeCode-AssetTypeCode',//Id of Fetch field
        ResultColumns: ["AssetTypeCodeId-Primary Key", 'AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description'],//Columns to be displayed
        AdditionalConditions: ["AssetClassificationId-selARAssetClassification"],
        FieldsToBeFilled: ["hdnARTypeCodeId-AssetTypeCodeId", "txtARTypeCode-AssetTypeCode", "txtARTypeDescription-AssetTypeDescription", "selARPPM-PPM", "selAROther-Other", "selARRI-RI"]
    };

    $('#txtARTypeCode').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divARTypeCodeFetch', typeCodeFetchObj, "/api/Fetch/TypeCodeFetch", "UlFetch", event, 1);//1 -- pageIndex
    });

    var locationCodeFetchObj = {
        SearchColumn: 'txtARUserLocationName-UserLocationCode',//Id of Fetch field
        ResultColumns: ["UserLocationId-Primary Key", 'UserLocationCode-User Location Code', 'UserLocationName-User Location Name', 'UserAreaCode-User Area Code', 'UserAreaName-User Area Name'],
        FieldsToBeFilled: ["hdnARLocationId-UserLocationId", "txtARUserLocationCode-UserLocationCode",
                          "txtARUserLocationName-UserLocationName", "txtARUserAreaCode-UserAreaCode",
                         "txtARUserAreaName-UserAreaName", "hdnARUserAreaId-UserAreaId",
                         "txtARInstalledLocationCode-UserLocationCode", "txtARInstalledLocationName-UserLocationName",
                         "txtARLevelName-LevelName", "txtARLevelcode-LevelCode", "txtARBlockName-BlockName", "txtARBlockCode-BlockCode"]
    };

    $('#txtARUserLocationName').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divARLocationCodeFetch', locationCodeFetchObj, "/api/Fetch/LocationCodeFetch", "UlFetch1", event, 1);//1 -- pageIndex
    });
      //ADDDED by deepak
    var locationCodeFetchObjs = {
        SearchColumn: 'txtARUserLocationCode-UserLocationCode',//Id of Fetch field
        ResultColumns: ["UserLocationId-Primary Key", 'UserLocationCode-User Location Code', 'UserLocationName-User Location Name', 'UserAreaCode-User Area Code', 'UserAreaName-User Area Name'],
        FieldsToBeFilled: ["hdnARInstalledLocationId-UserLocationId", "txtARUserLocationCode-UserLocationCode",
            "txtARUserLocationCode-UserLocationCode", "txtARCurrentAreaCode-UserAreaCode",
             "hdnARUserAreaId-UserAreaId"]
    };

    $('#txtARUserLocationCode').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divARLocationCodeFetch', locationCodeFetchObjs, "/api/Fetch/LocationCodeFetch", "UlFetch1", event, 1);//1 -- pageIndex
    });

      ///////----------------end
    var manufacturerFetchObj = {
        SearchColumn: 'txtARManufacturer-Manufacturer',//Id of Fetch field
        ResultColumns: ["ManufacturerId-Primary Key", 'Manufacturer-Manufacturer'],
        AdditionalConditions: ["TypeCodeId-hdnARTypeCodeId", "ModelId-hdnARModelId"],
        FieldsToBeFilled: ["hdnARManufacturerId-ManufacturerId", "txtARManufacturer-Manufacturer"]
    };

    $('#txtARManufacturer').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divARManufacturerFetch', manufacturerFetchObj, "/api/Fetch/ManufacturerFetch", "UlFetch2", event, 1);//1 -- pageIndex
    });

    var modelFetchObj = {
        SearchColumn: 'txtARModel-Model',//Id of Fetch field
        ResultColumns: ["ModelId-Primary Key", 'Model-Model'],
        AdditionalConditions: ["TypeCodeId-hdnARTypeCodeId"],
        FieldsToBeFilled: ["hdnARModelId-ModelId", "txtARModel-Model"]
    };

    $('#txtARModel').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divARModelFetch', modelFetchObj, "/api/Fetch/ModelFetch", "UlFetch3", event, 1);//1 -- pageIndex
    });

    var preRegistrationNoFetchObj = {
        SearchColumn: 'txtARAssetPreRegistrationNo-AssetPreRegistrationNo',//Id of Fetch field
        ResultColumns: ["TestingandCommissioningDetId-Primary Key", 'AssetPreRegistrationNo-Asset Pre Registration No.'],
        AdditionalConditions: ["AssetClassificationId-selARAssetClassification", "IsLoaner-hdnIsLoaner"],
        FieldsToBeFilled: ["hdnARAssetPreRegistrationNoId-TestingandCommissioningDetId", "txtARAssetAge-AssetAge",
            "txtARYearInService-YearsInService", "txtARAssetPreRegistrationNo-AssetPreRegistrationNo",
            "hdnTandCDate-TandCDate", "hdnARServiceStartDate-ServiceStartDate", "txtARMainSupplier-MainSupplierName",
            "SNFContractor-MainSupplierName", "txtARPurchaseCost-PurchaseCost", "hdnARPurchaseDate-PurchaseDate",
            "txtARWarrantyDuration-WarrantyDuration", "hdnARWarrantyStartDate-WarrantyStartDate",
            "hdnARWarrantyEndDate-WarrantyEndDate", "txtARPurchaseOrderNumber-PurchaseOrderNo"]
    };

    $('#txtARAssetPreRegistrationNo').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divARAssetPreRegistrationNoFetch', preRegistrationNoFetchObj, "/api/Fetch/AssetPreRegistrationNoFetch", "UlFetch4", event, 1);//1 -- pageIndex
    });

    var parentAssetFetchObj = {
        SearchColumn: 'txtARParentAsset-AssetNo',
        ResultColumns: ["AssetId-Primary Key", 'AssetNo-Asset No.', 'AssetDescription-Asset Description'],
        AdditionalConditions: ["CurrentAssetId-hdnARPrimaryID", "IsFromAssetRegister-hdnIsFromAssetRegister"],
        FieldsToBeFilled: ["hdnARParentAssetId-AssetId", "txtARParentAsset-AssetNo"]
    };

    $('#txtARParentAsset').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divARParentAssetFetch', parentAssetFetchObj, "/api/Fetch/ParentAssetNoFetch", "UlFetch5", event, 1);//1 -- pageIndex
    });

    //----------------------------------------------------------

    $('#hdnTandCDate, #hdnARServiceStartDate, #hdnARPurchaseDate, #hdnARWarrantyStartDate, #hdnARWarrantyEndDate').change(function () {
        var date = $(this).val();
        var id = $(this).attr('id');

        var id1 = '';
        switch (id) {
            case 'hdnTandCDate': id1 = 'txtARCommissioningDate'; break;
            case 'hdnARServiceStartDate': id1 = 'txtARServiceStartDate'; break;
            case 'hdnARPurchaseDate': id1 = 'txtARPurchaseDate'; break;
            case 'hdnARWarrantyStartDate': id1 = 'txtARWarrantyStartDate'; break;
            case 'hdnARWarrantyEndDate': id1 = 'txtARWarrantyEndDate'; break;
        }

        $('#' + id1).val(date == null || date == "" ? null : moment(date).format("DD-MMM-YYYY"));
        $('#' + id1).parent().removeClass('has-error');
    });

    //$('#btnARAddNew').click(function () {
    //    window.location.reload();
    //});

    $("#btnTab1Cancel").click(function () {
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

    //$('#selARSpecificationUnitType').change(function () {
    //    $('#txtARSpecificationUnitWatt').val(null);
    //    $('#txtARSpecificationUnitAmpere').val(null);
    //    $('#txtARVolt').val(null);

    //    var specificationType = $('#selARSpecificationUnitType').val();
    //    if (specificationType == 63) {//ampere
    //        $('#txtARSpecificationUnitWatt').attr('disabled', true);
    //        $('#txtARSpecificationUnitAmpere').attr('disabled', false);
    //        $('#txtARVolt').attr('disabled', false);
    //        $('.removeRequired').css('visibility', 'hidden');
    //        $('#txtARSpecificationUnitWatt').attr('required', false);
    //        $('#txtARSpecificationUnitWatt').parent().removeClass('has-error');
    //    }
    //    else if (specificationType == 64) {//watt
    //        $('#txtARSpecificationUnitWatt').attr('disabled', false);
    //        $('#txtARSpecificationUnitAmpere').attr('disabled', true);
    //        $('#txtARVolt').attr('disabled', true);
    //        $('.removeRequired').css('visibility', 'visible');
    //        $('#txtARSpecificationUnitWatt').attr('required', true);
    //    }
    //});

    //$('#txtARSpecificationUnitAmpere, #txtARVolt').on('input propertychange paste keyup', function (event) {
    //    var regExAmpere = $('#txtARSpecificationUnitAmpere').prop('pattern');
    //    var regExVolt = $('#txtARVolt').prop('pattern');

    //    var ampere = $('#txtARSpecificationUnitAmpere').val();
    //    var volt = $('#txtARVolt').val();

    //    if (ampere.match(regExAmpere) && volt.match(regExVolt) && $.isNumeric(ampere) && $.isNumeric(volt)) {
    //        $('#txtARSpecificationUnitWatt').val((ampere * volt).toFixed(2));
    //    }
    //    else {
    //        $('#txtARSpecificationUnitWatt').val(null);
    //    }
    //});

    //$('#anchorARAssetStatus').click(AssetStatusClicked);

    AssetStatusClicked = function () {
        var primaryId = $('#hdnARPrimaryID').val();
        if (primaryId == null || primaryId == "0") {
            return false;
        }

        $('#myPleaseWait').modal('show');
        var tableString = '<div class="table-responsive">'
                + '<table id="dataTable" class="table table-fixedheader table-bordered" style="border: 1px solid rgb(222, 218, 218);">'
                + '<thead class="tableHeading">'
                + '<tr>'
                + '<th style="text-align: center;" width="10%">Asset Status</th>'
                + '<th style="text-align: center;" width="19%">SNF No.</th>'
                + '<th style="text-align: center;" width="11%">Variation Status </th>'
                + '<th style="text-align: center;" width="20%">SNF Raised Date</th>'
                + '<th style="text-align: center;" width="20%">Service Start Date</th>'
                + '<th style="text-align: center;" width="20%">Service Stop Date</th>'
                + '</tr>'
                + '</thead>'
                + '<tbody>';

        var tableStringEnd = '</tbody>'
                + '</table>'
                + '</div>';

        $('#txtARAssetStatusHistoryAssetNo').val($('#txtARAssetNo').val());
        $('#txtARAssetStatusHistoryAssetDescription').val($('#txtARTypeDescription').val());

        $.get("/api/assetRegister/GetAssetStatusDetails/" + primaryId)
        .done(function (result) {
            var getResult = JSON.parse(result);
            var trString = '';
            $.each(getResult, function (index, value) {
                var snfRaisedDate = value.SNFRaisedDate == null ? "" : moment(value.SNFRaisedDate).format("DD-MMM-YYYY");
                var serviceStartDate = value.ServiceStartDate == null ? "" : moment(value.ServiceStartDate).format("DD-MMM-YYYY");
                var serviceEndDate = value.ServiceEndDate == null ? "" : moment(value.ServiceEndDate).format("DD-MMM-YYYY");
                trString += '<tr>'
                                + '<td width="10%" style="text-align: center;" data-original-title="" title="">'
                                + '<div><input type="text" style="max-width:100%" class="form-control" disabled value="' + value.AssetStatus + '">'
                                + '</div></td>';
                trString += '<td width="20%" style="text-align: center;" data-original-title="" title="">'
                                + '<div><input type="text" style="max-width:100%" class="form-control" disabled value="' + value.SNFNumber + '">'
                                + '</div></td>';
                trString += '<td width="10%" style="text-align: center;" data-original-title="" title="">'
                                + '<div><input type="text" style="max-width:100%" class="form-control" disabled value="' + value.VariationStatus + '">'
                                + '</div></td>';
                trString += '<td width="20%" style="text-align: center;" data-original-title="" title="">'
                                + '<div><input type="text" style="max-width:100%" class="form-control" disabled value="' + snfRaisedDate + '">'
                                + '</div></td>';
                trString += '<td width="20%" style="text-align: center;" data-original-title="" title="">'
                                + '<div><input type="text" class="form-control" disabled value="' + serviceStartDate + '">'
                                + '</div></td>';
                trString += '<td width="20%" style="text-align: center;" data-original-title="" title="">'
                                + '<div><input type="text" style="max-width:100%" class="form-control" disabled value="' + serviceEndDate + '">'
                                + '</div></td></tr>';
            });
            tableString += trString;

            tableString += tableStringEnd;

            $('#divARAssetStatusPopupTable').html(null);
            $('#divARAssetStatusPopupTable').append(tableString);
            $('#divARModalAssetStatus').modal('show');
            $('#myPleaseWait').modal('hide');
        })
        .fail(function () {
            tableString += '<tr><td colspan="6" class="NoRecords">No records to display</td></tr>';
            tableString += tableStringEnd;
            $('#divARAssetStatusPopupTable').html(null);
            $('#divARAssetStatusPopupTable').append(tableString);
            $('#divARModalAssetStatus').modal('show');
            $('#myPleaseWait').modal('hide');
        });
    }

    $('#btnARModalAssetStatusCancel, #btnARModalAssetStatusCancel1').click(function () {
        $('#divARModalAssetStatus').modal('hide');
    });

    //$('#anchorARRealTimeStatus').click(RealTimeStatusClicked);

    RealTimeStatusClicked = function () {
        var primaryId = $('#hdnARPrimaryID').val();
        if (primaryId == null || primaryId == "0") {
            return false;
        }

        $('#myPleaseWait').modal('show');

        var tableString = '<div class="table-responsive">'
                + '<table id="dataTable" class="table table-fixedheader table-bordered" style="border: 1px solid rgb(222, 218, 218);">'
                + '<thead class="tableHeading">'
                + '<tr>'
                + '<th style="text-align: center;" width="40%">Work Order No.</th>'
                + '<th style="text-align: center;" width="30%">Work Order Date</th>'
                + '<th style="text-align: center;" width="30%">Real Time Status</th>'
                + '</tr>'
                + '</thead>'
                + '<tbody>';

        var tableStringEnd = '</tbody>'
              + '</table>'
              + '</div>';

        $('#txtARAssetRealTimeStatusHistoryAssetNo').val($('#txtARAssetNo').val());
        $('#txtARAssetRealTimeStatusHistoryAssetDescription').val($('#txtARTypeDescription').val());

        $.get("/api/assetRegister/GetAssetRealTimeStatusDetails/" + primaryId)
        .done(function (result) {
            var getResult = JSON.parse(result);

            var trString = '';

            $.each(getResult, function (index, value) {
                var serviceWorkDate = value.ServiceWorkDate == null ? "" : moment(value.ServiceWorkDate).format("DD-MMM-YYYY");

                trString += '<tr>'
                                + '<td width="40%" style="text-align: center;" data-original-title="" title="">'
                                + '<div><input type="text" style="max-width:100%" class="form-control" disabled value="' + value.ServiceWorkNo + '">'
                                + '</div></td>';
                trString += '<td width="30%" style="text-align: center;" data-original-title="" title="">'
                                + '<div><input type="text" style="max-width:100%" class="form-control" disabled value="' + serviceWorkDate + '">'
                                + '</div></td>';
                trString += '<td width="30%" style="text-align: center;" data-original-title="" title="">'
                                + '<div><input type="text" style="max-width:100%" class="form-control" disabled value="' + value.RealTimeStatus + '">'
                                + '</div></td></tr>';
            });
            tableString += trString;
            tableString += tableStringEnd;

            $('#divARAssetRealTimeStatusPopupTable').html(null);
            $('#divARAssetRealTimeStatusPopupTable').append(tableString);
            $('#divARModalAssetRealTimeStatus').modal('show');
            $('#myPleaseWait').modal('hide');
        })
        .fail(function () {
            tableString += '<tr><td colspan="3" class="NoRecords">No records to display</td></tr>';
            tableString += tableStringEnd;
            $('#divARAssetRealTimeStatusPopupTable').html(null);
            $('#divARAssetRealTimeStatusPopupTable').append(tableString);
            $('#divARModalAssetRealTimeStatus').modal('show');
            $('#myPleaseWait').modal('hide');
        });
    }

    $('#btnARRealTimeStatusPopupCancel, #btnARRealTimeStatusPopupCancel1').click(function () {
        $('#divARModalAssetRealTimeStatus').modal('hide');
    });

    $('#anchorARSoftwareVersion').click(function () {
        var primaryId = $('#hdnARPrimaryID').val();
        $('#tblARSoftwarePopup > tbody').children('tr:not(:first)').remove();
        $('#chkARSoftwareDeleteAll').prop('checked', false);
        $('#chkARSoftwareDelete_0').prop('checked', false);
        $('#chkARSoftwareDelete_0').parent().removeClass('bgDelete');
        $('#txtARSoftwareKey_0').val(null);
        $('#txtARSoftwareVersion_0').val(null);

        $('#txtARSoftwareVersionHistoryAssetNo').val($('#txtARAssetNo').val());
        $('#txtARSoftwareVersionHistoryAssetDescription').val($('#txtARTypeDescription').val());

        if (softwareObjList.length != 0) {
            var trString = '';
            var index1;
            //var i = -1;
            $.each(softwareObjList, function (index, value) {
                //i++;
                //if (!value.IsDeleted) {
                if (index == 0) {
                    $('#hdnARSoftwareId_0').val(value.AssetSoftwareId);
                    $('#txtARSoftwareKey_0').val(value.SoftwareKey);
                    $('#txtARSoftwareVersion_0').val(value.SoftwareVersion);
                }
                else {
                    trString += '<tr>'
                                    + '<td width="5%" style="text-align:center"><input type="checkbox" id="chkARSoftwareDelete_' + index.toString() + '"/></td>'
                                    + '<td width="47%" style="text-align: center;" data-original-title="" title="">'
                                    + '<div><input type="hidden" id="hdnARSoftwareId_' + index.toString() + '" value="' + value.AssetSoftwareId + '"/><input type="text" id="txtARSoftwareKey_' + index.toString() + '" style="max-width:100%" class="form-control" value="' + value.SoftwareKey + '">'
                                    + '</div></td>';
                    trString += '<td width="48%" style="text-align: center;" data-original-title="" title="">'
                                    + '<div><input type="text" id="txtARSoftwareVersion_' + index.toString() + '" style="max-width:100%" class="form-control" value="' + value.SoftwareVersion + '">'
                                    + '</div></td></tr>';
                }
                //}
            });


            $('#tblARSoftwarePopup > tbody').append(trString);
            BindEvensForCheckBox();
        }
        else if (primaryId != null && primaryId != "0") {
            $('#myPleaseWait').modal('show');
            $.get("/api/assetRegister/GetSoftwareDetails/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);

                var trString = '';
                var index1;
                $.each(getResult, function (index, value) {
                    if (index == 0) {
                        $('#hdnARSoftwareId_0').val(value.AssetSoftwareId);
                        $('#txtARSoftwareKey_0').val(value.SoftwareKey);
                        $('#txtARSoftwareVersion_0').val(value.SoftwareVersion);
                    }
                    else {
                        trString += '<tr>'
                                        + '<td width="5%" style="text-align:center"><input type="checkbox" id="chkARSoftwareDelete_' + index.toString() + '"/></td>'
                                        + '<td width="47%" style="text-align: center;" data-original-title="" title="">'
                                        + '<div><input type="hidden" id="hdnARSoftwareId_' + index.toString() + '" value="' + value.AssetSoftwareId + '"/><input type="text" id="txtARSoftwareKey_' + index.toString() + '" style="max-width:100%" class="form-control" value="' + value.SoftwareKey + '">'
                                        + '</div></td>';
                        trString += '<td width="48%" style="text-align: center;" data-original-title="" title="">'
                                        + '<div><input type="text" id="txtARSoftwareVersion_' + index.toString() + '" style="max-width:100%" class="form-control" value="' + value.SoftwareVersion + '">'
                                        + '</div></td></tr>';
                    }
                });


                $('#tblARSoftwarePopup > tbody').append(trString);
                BindEvensForCheckBox();
                $('#myPleaseWait').modal('hide');
            })
            .fail(function () {
                $('#myPleaseWait').modal('hide');
            });
        }

        $('#tblARSoftwarePopup tr').each(function (index, value) {
            var softwareKeyId = 'txtARSoftwareKey_' + index.toString();
            var softwareVersionId = 'txtARSoftwareVersion_' + index.toString();
            $('#' + softwareKeyId).parent().removeClass('has-error');
            $('#' + softwareVersionId).parent().removeClass('has-error');
        });

        $("div.errorMsgCenterPopup").text('');
        $('#divErrorMsgSoftwarePopup').css('visibility', 'hidden');

        $('#divARModalSoftwareVersion').modal('show');
        formInputValidation('tblARSoftwarePopup');
        BindEvnetForSoftwareKey();
        BindEvnetForSoftwareVersion();
        BindEvensForCheckBox();
    });

    $('#btnARSoftwareCloseCancel, #btnARSoftwareCloseCancel1').click(function () {
        $('#divARModalSoftwareVersion').modal('hide');
    });

    $('#anchorARDefectList').click(function () {
        var primaryId = $('#hdnARPrimaryID').val();
        if (primaryId == null || primaryId == "0") {
            return false;
        }

        $('#myPleaseWait').modal('show');

        var tableString = '<div class="table-responsive">'
                + '<table id="dataTable" class="table table-fixedheader table-bordered" style="border: 1px solid rgb(222, 218, 218);">'
                + '<thead class="tableHeading">'
                + '<tr>'
                + '<th style="text-align: center;" width="20%">Defect No</th>'
                + '<th style="text-align: center;" width="20%">Defect Date</th>'
                + '<th style="text-align: center;" width="20%">Start Date</th>'
                + '<th style="text-align: center;" width="20%">Completion Date</th>'
                + '<th style="text-align: center;" width="20%">Action Taken</th>'
                + '</tr>'
                + '</thead>'
                + '<tbody>';

        var tableStringEnd = '</tbody>'
              + '</table>'
              + '</div>';

        $('#txtARDefectListAssetNo').val($('#txtARAssetNo').val());
        $('#txtARDefectListAssetDescription').val($('#txtARTypeDescription').val());

        $.get("/api/assetRegister/GetDefectDetails/" + primaryId)
        .done(function (result) {
            var getResult = JSON.parse(result);

            var trString = '';

            $.each(getResult, function (index, value) {
                var defectDate = value.DefectDate == null ? "" : moment(value.DefectDate).format("DD-MMM-YYYY");
                var startDate = value.StartDate == null ? "" : moment(value.StartDate).format("DD-MMM-YYYY");
                var completionDate = value.CompletionDate == null ? "" : moment(value.CompletionDate).format("DD-MMM-YYYY");
                trString += '<tr>'
                                + '<td width="20%" style="text-align: center;" data-original-title="" title="">'
                                + '<div><input type="text" style="max-width:100%" class="form-control" disabled value="' + value.DefectNo + '">'
                                + '</div></td>';
                trString += '<td width="20%" style="text-align: center;" data-original-title="" title="">'
                                + '<div><input type="text" style="max-width:100%" class="form-control" disabled value="' + defectDate + '">'
                                + '</div></td>';
                trString += '<td width="20%" style="text-align: center;" data-original-title="" title="">'
                                + '<div><input type="text" style="max-width:100%" class="form-control" disabled value="' + startDate + '">'
                                + '</div></td>';
                trString += '<td width="20%" style="text-align: center;" data-original-title="" title="">'
                                + '<div><input type="text" style="max-width:100%" class="form-control" disabled value="' + completionDate + '">'
                                + '</div></td>';
                trString += '<td width="20%" style="text-align: center;" data-original-title="" title="">'
                                + '<div><input type="text" style="max-width:100%" class="form-control" disabled value="' + value.ActionTaken + '">'
                                + '</div></td></tr>';
            });

            tableString += trString;
            tableString += tableStringEnd;

            $('#divARDefectListPopupTable').html(null);
            $('#divARDefectListPopupTable').append(tableString);
            $('#divARModalDefectList').modal('show');
            $('#myPleaseWait').modal('hide');
        })
        .fail(function () {
            tableString += '<tr><td colspan="5" class="NoRecords">No records to display</td></tr>';
            tableString += tableStringEnd;
            $('#divARDefectListPopupTable').html(null);
            $('#divARDefectListPopupTable').append(tableString);
            $('#divARModalDefectList').modal('show');
            $('#myPleaseWait').modal('hide');
        });
    });

    $('#btnARDefectListPopupCancel, #btnARDefectListPopupCancel1').click(function () {
        $('#divARModalDefectList').modal('hide');
    });


    $(".nav-tabs > li:not(:first-child)").click(function () {
        var primaryId = $('#hdnARPrimaryID').val();
        if (primaryId == 0) {
            bootbox.alert("Asset Register details must be Saved before entering additional information");
            return false;
        }
    });

    $('#anchorARPPM, #anchorARCalibration, #anchorARRI').click(function () {
        var id = $(this).attr('id');
        var message = '';
        var url = '';
        switch (id) {
            case 'anchorARPPM':
                message = 'You will be redirected to the PPM Planner screen. Are you sure you want to proceed?';
                url = '/bems/ppmplanner/add';
                break;
            case 'anchorARCalibration':
                message = 'You will be redirected to the Other Planner screen. Are you sure you want to proceed?';
                url = '/bems/otherplanner/add';
                break;
            case 'anchorARRI':
                message = 'You will be redirected to the RI Planner screen. Are you sure you want to proceed?';
                url = '/bems/riplanner/add';
                break;
        }
        bootbox.confirm(message, function (result) {
            if (result) {
                window.location.href = url;
            }
        });
    });

    $('#aCollapse1, #aCollapseTwo, #aCollapseThree, #aCollapse4, #aCollapse5, #aCollapse6').on('click', function () {
        var iId = '';
        switch ($(this).attr('id')) {
            case 'aCollapse1': iId = 'iIndicator1'; break;
            case 'aCollapseTwo': iId = 'iIndicator2'; break;
            case 'aCollapseThree': iId = 'iIndicator3'; break;
            case 'aCollapse4': iId = 'iIndicator4'; break;
            case 'aCollapse5': iId = 'iIndicator5'; break;
            case 'aCollapse6': iId = 'iIndicator6'; break;
        }
        var plus = $('#' + iId).hasClass('glyphicon-plus');
        var minus = $('#' + iId).hasClass('glyphicon-minus');

        $(".indicator").each(function (index, value) {
            if ($(this).attr('id') == iId) {
                if (plus) {
                    $(this).addClass('glyphicon-minus').removeClass('glyphicon-plus');
                }
                if (minus) {
                    $(this).addClass('glyphicon-plus').removeClass('glyphicon-minus');
                }
            } else {
                $(this).addClass('glyphicon-plus').removeClass('glyphicon-minus');
            }
        });
    });

    $('#hdnARTypeCodeId').change(function () {
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var typeCodeId = $('#hdnARTypeCodeId').val();

        setTimeout(function () {
            var ppm = $('#selARPPM').val();
            var other = $('#selAROther').val();
            var ri = $('#selARRI').val();

            if (ppm == "99") {
                $('#anchorARPPM').show();
            } else {
                $('#anchorARPPM').hide();
            }
            if (other == "99") {
                $('#anchorARCalibration').show();
            } else {
                $('#anchorARCalibration').hide();
            }
            if (ri == "99") {
                $('#anchorARRI').show();
            } else {
                $('#anchorARRI').hide();
            }
        }, 1000)



        $('#txtARManufacturer').val(null);
        $('#hdnARManufacturerId').val(null);
        $('#spnPopup-model').unbind("click");

        $('#txtARModel').val(null);
        $('#hdnARModelId').val(null);

        if (typeCodeId == "" || typeCodeId == "null") {
            $('#txtARManufacturer').attr('disabled', true);
            $('#spnPopup-manufacturer').unbind("click").attr('disabled', true).css('cursor', 'default');
            $('#txtARModel').attr('disabled', true);
            $('#spnPopup-model').unbind("click").attr('disabled', true).css('cursor', 'default');
            return false;
        }
        else {
            $('#txtARModel').attr('disabled', false);
            $('#spnPopup-model').bind("click", function () {
                DisplaySeachPopup('divARSearchPopup', modelSearchObj, "/api/Search/ModelSearch")
            }).attr('disabled', false).css('cursor', 'pointer');
        }

        //$('#myPleaseWait').modal('show');
        //$.get("/api/assetRegister/GetAssetSpecification/" + typeCodeId)
        //  .done(function (result) {
        //      var getResult = JSON.parse(result);
        //      if (getResult.AssetSpecifications != null) {
        //          $.each(getResult.AssetSpecifications, function (index, value) {
        //              $('#selARSpecification').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        //          });
        //      }
        //      $('#myPleaseWait').modal('hide');
        //  })
        //.fail(function (response) {
        //    $('#myPleaseWait').modal('hide');
        //    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
        //    $('#errorMsg').css('visibility', 'visible');
        //});
    });

    $('#selARAssetClassification').change(function () {
        var assetClassificationId = $('#selARAssetClassification').val();

        $('#txtARAssetPreRegistrationNo').val(null);
        $('#hdnARAssetPreRegistrationNoId').val(null);
        $('#spnPopup-assetPreRegistration').unbind("click");


        $('#txtARTypeCode').val(null);
        $('#hdnARTypeCodeId').val(null);
        $('#spnPopup-typeCode').unbind("click");

        if (assetClassificationId == "null") {
            $('#txtARAssetPreRegistrationNo').attr('disabled', true);
            $('#spnPopup-assetPreRegistration').unbind("click").attr('disabled', true).css('cursor', 'default');

            $('#txtARTypeCode').attr('disabled', true);
            $('#spnPopup-typeCode').unbind("click").attr('disabled', true).css('cursor', 'default');

            return false;
        }
        else {
            $('#txtARAssetPreRegistrationNo').attr('disabled', false);
            $('#spnPopup-assetPreRegistration').bind("click", function () {
                DisplaySeachPopup('divARSearchPopup', preRegistrationNoSearchObj, "/api/Search/AssetPreRegistrationNoSearch");
            }).attr('disabled', false).css('cursor', 'pointer');

            $('#txtARTypeCode').attr('disabled', false);
            $('#spnPopup-typeCode').bind("click", function () {
                DisplaySeachPopup('divARSearchPopup', typeCodeSearchObj, "/api/Search/TypeCodeSearch");
            }).attr('disabled', false).css('cursor', 'pointer');
        }
    });

    $('#hdnARModelId').change(function () {
        var modelId = $('#hdnARModelId').val();

        $('#txtARManufacturer').val(null);
        $('#hdnARManufacturerId').val(null);
        $('#spnPopup-manufacturer').unbind("click");

        if (modelId == "" || modelId == "null") {
            $('#txtARManufacturer').attr('disabled', true);
            $('#spnPopup-manufacturer').unbind("click").attr('disabled', true).css('cursor', 'default');
            return false;
        }
        else {
            $('#txtARManufacturer').attr('disabled', false);
            $('#spnPopup-manufacturer').bind("click", function () {
                DisplaySeachPopup('divARSearchPopup', manufacturerSearchObj, "/api/Search/ManufacturerSearch");
            }).attr('disabled', false).css('cursor', 'pointer');
        }
    });

    $('#btnARAddEditSoftware').click(function () {
        $("div.errorMsgCenterPopup").text('');
        $('#divErrorMsgSoftwarePopup').css('visibility', 'hidden');

        //var isFormValid = formInputValidation("tblARSoftwarePopup", 'save');
        var isFormValid = tableInputValidation("tblARSoftwarePopup", 'save', 'chkARSoftwareDelete');
        if (!isFormValid) {
            $("div.errorMsgCenterPopup").text(Messages.INVALID_INPUT_MESSAGE);
            $('#divErrorMsgSoftwarePopup').css('visibility', 'visible');
            return false;
        }

        softwareObjList = [];
        var softwareKeyId = '';
        var softwareVersionId = '';
        var softwareKey = '';
        var softwareVersion = '';
        var bothFieldsEmpty = false;
        var softwareKeyInvalid = false;
        var softwareVersionInvalid = false;

        $("#tblARSoftwarePopup tr").each(function (index, value) {
            if (index == 0) return;
            var index1 = index - 1;
            var isDeleted = $('#chkARSoftwareDelete_' + index1).prop('checked')
            softwareKeyId = 'txtARSoftwareKey_' + index1.toString();
            softwareVersionId = 'txtARSoftwareVersion_' + index1.toString();
            softwareKey = $('#' + softwareKeyId).val();
            softwareVersion = $('#' + softwareVersionId).val();
            bothFieldsEmpty = (softwareKey == '' || softwareKey == null) && (softwareVersion == '' || softwareVersion == null);
            softwareKeyInvalid = (softwareKey == '' || softwareKey == null) && (softwareVersion != '' && softwareVersion != null);
            softwareVersionInvalid = (softwareVersion == '' || softwareVersion == null) && (softwareKey != '' && softwareKey != null);

            if (!isDeleted && !bothFieldsEmpty) {
                var softwareObj = {
                    AssetSoftwareId: $('#hdnARSoftwareId_' + index1).val(),
                    SoftwareKey: $('#txtARSoftwareKey_' + index1).val(),
                    SoftwareVersion: $('#txtARSoftwareVersion_' + index1).val(),
                    IsDeleted: 0
                }
                softwareObjList.push(softwareObj);
            }
            //if (isDeleted) {
            //    var softwareId = $('#hdnARSoftwareId_' + index1).val();
            //    if (softwareId != '' && softwareId != null) {
            //        var softwareObj = {
            //            AssetSoftwareId: $('#hdnARSoftwareId_' + index1).val(),
            //            SoftwareKey: $('#txtARSoftwareKey_' + index1).val(),
            //            SoftwareVersion: $('#txtARSoftwareVersion_' + index1).val(),
            //            IsDeleted: 1
            //        }
            //        softwareObjList.push(softwareObj);
            //    }
            //}
        });
        //console.log(softwareObjList);
        //if (softwareObjList.length == 0) {
        //    $("div.errorMsgCenterPopup").text('No records to save');
        //    $('#divErrorMsgSoftwarePopup').css('visibility', 'visible');
        //}
        //else {
        $('#divARModalSoftwareVersion').modal('hide');
        //}
    });

    $('#anchorARSoftwareAddNew').click(function () {
        var softwareKeyId = '';
        var softwareVersionId = '';
        var softwareKey = '';
        var softwareVersion = '';
        var bothFieldsEmpty = false;
        var softwareKeyInvalid = false;
        var softwareVersionInvalid = false;
        var errorMessage = '';

        $('#tblARSoftwarePopup tr').each(function (index, value) {
            if (index == 0) return;
            var index1 = index - 1;
            softwareKeyId = 'txtARSoftwareKey_' + index1.toString();
            softwareVersionId = 'txtARSoftwareVersion_' + index1.toString();

            softwareKey = $('#' + softwareKeyId).val();
            softwareVersion = $('#' + softwareVersionId).val();
            bothFieldsEmpty = (softwareKey == '' || softwareKey == null) && (softwareVersion == '' || softwareVersion == null);
            softwareKeyInvalid = (softwareKey == '' || softwareKey == null) && (softwareVersion != '' && softwareVersion != null);
            softwareVersionInvalid = (softwareVersion == '' || softwareVersion == null) && (softwareKey != '' && softwareKey != null);

            if (bothFieldsEmpty || softwareKeyInvalid || softwareVersionInvalid) {
                if (softwareKey == '' || softwareKey == null) {
                    $('#' + softwareKeyId).parent().addClass('has-error');
                }
                if (softwareVersion == '' || softwareVersion == null) {
                    $('#' + softwareVersionId).parent().addClass('has-error');
                }
                errorMessage = Messages.ENTER_VALUES_EXISTING_ROW;
            }

        });
        $("div.errorMsgCenterPopup").text(errorMessage);
        if (errorMessage != '') {
            $('#divErrorMsgSoftwarePopup').css('visibility', 'visible');
        }
        else {
            var index = $('#tblARSoftwarePopup tr').length - 1;
            var tableRow = '<tr><td width="5%" style="text-align:center"><input type="checkbox" id="chkARSoftwareDelete_' + index + '"/></td>'
                            + '<td width="47%"><div><input type="text" pattern="^[a-zA-Z0-9\\s]+$" class="form-control" style="max-width:100%" id="txtARSoftwareKey_' + index + '"/></div></td>'
                            + '<td width="48%"><div><input type="text" pattern="^[a-zA-Z0-9\\s\\.]+$" class="form-control" style="max-width:100%" id="txtARSoftwareVersion_' + index + '"/></div></td></tr>';
            $('#tblARSoftwarePopup > tbody').append(tableRow);
            BindEvnetForSoftwareKey();
            BindEvnetForSoftwareVersion();
            BindEvensForCheckBox();
            formInputValidation('tblARSoftwarePopup');
            $('#divErrorMsgSoftwarePopup').css('visibility', 'hidden');
        }
    });

    function BindEvensForCheckBox() {
        $("input[id^='chkARSoftwareDelete_']").on('click', function () {
            var allChecked = true;
            var isChecked = $(this).prop('checked');
            if (isChecked) {
                $(this).parent().addClass('bgDelete');
            }
            else {
                $(this).parent().removeClass('bgDelete');
            }
            var id = $(this).attr('id');
            var index1;
            $('#tblARSoftwarePopup tr').each(function (index, value) {
                if (index == 0) return;
                index1 = index - 1;
                if (!$('#chkARSoftwareDelete_' + index1).prop('checked')) {
                    allChecked = false;
                }
            });
            if (allChecked) {
                $('#chkARSoftwareDeleteAll').prop('checked', true);
            }
            else {
                $('#chkARSoftwareDeleteAll').prop('checked', false);
            }
        });
    }

    function BindEvnetForSoftwareKey() {
        $("input[id^='txtARSoftwareKey_']").on('input propertychange paste', function () {
            var id = $(this).attr('id');
            var index = id.substring(id.indexOf('_') + 1);
            if ($(this).val() != null && $(this).val() != '') {
                $('#txtARSoftwareVersion_' + index).attr('required', true);
            }
            else {
                $('#txtARSoftwareVersion_' + index).removeAttr('required');
                //$('#txtARSoftwareVersion_' + index).parent().removeClass('has-error');
            }
        });
    }

    function BindEvnetForSoftwareVersion() {
        $("input[id^='txtARSoftwareVersion_']").on('input propertychange paste', function () {
            var id = $(this).attr('id');
            var index = id.substring(id.indexOf('_') + 1);
            if ($(this).val() != null && $(this).val() != '') {
                $('#txtARSoftwareKey_' + index).attr('required', true);
            }
            else {
                $('#txtARSoftwareKey_' + index).removeAttr('required');
                //$('#txtARSoftwareKey_' + index).parent().removeClass('has-error');
            }
        });
    }

    $('#chkARSoftwareDeleteAll').on('click', function () {
        var isChecked = $(this).prop("checked");
        var index1;
        $('#tblARSoftwarePopup tr').each(function (index, value) {
            if (index == 0) return;
            index1 = index - 1;
            if (isChecked) {
                $('#chkARSoftwareDelete_' + index1).prop('checked', true);
                $('#chkARSoftwareDelete_' + index1).parent().addClass('bgDelete');
            }
            else {
                $('#chkARSoftwareDelete_' + index1).prop('checked', false);
                $('#chkARSoftwareDelete_' + index1).parent().removeClass('bgDelete');
            }
        });
    });

    if (actionType == 'View') {
        $('#anchorARPPM, #anchorARCalibration, #anchorARRI').unbind("click").css('cursor', 'default');
        $('#spnPopup-assetPreRegistration').unbind("click").attr('disabled', true).css('cursor', 'default');
        $('#spnPopup-typeCode').unbind("click").attr('disabled', true).css('cursor', 'default');
        $('#spnPopup-parentAsset').unbind("click").attr('disabled', true).css('cursor', 'default');
        $('#spnPopup-userLocation').unbind("click").attr('disabled', true).css('cursor', 'default');
        $('#spnPopup-manufacturer').unbind("click").attr('disabled', true).css('cursor', 'default');
        $('#spnPopup-model').unbind("click").attr('disabled', true).css('cursor', 'default');

        $("#AssetAccessoriesTabForm :input:not(:button)").prop("disabled", true);
        $("#assetregWarrantyprovider :input:not(:button)").prop("disabled", true);
        $("#frmAssetRegisterAttachment :input:not(:button)").prop("disabled", true);
        $("#frmContractorAndVendor :input:not(:button)").prop("disabled", true);
        $("#frmLicenseAndCertifiacte :input:not(:button)").prop("disabled", true);
        $("#frmAssetProcessStatus :input:not(:button)").prop("disabled", true);
        $("#frmChildAsset :input:not(:button)").prop("disabled", true);
        $("#frmVariationDetails :input:not(:button)").prop("disabled", true);
        $("#frmMaintenanceHistory :input:not(:button)").prop("disabled", true);
    }
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
    //var ID = getUrlParameter('id');
    var ID = $('#hdnAssetId').val();
    var tAndCId = $('#hdnTestingAndCommissioningId').val();
    var fromTAndC = tAndCId != null && tAndCId != "" && tAndCId != "0";

    if (ID == null || ID == undefined || ID == 0 || ID == '' || ID == "") {
        if (!fromTAndC) {
            $("#jQGridCollapse1").click();
        }
    }
    else {
        LinkClicked(ID);
        FromNotification = true;
    }
    // **** Query String to get ID  End****\\\

    window.location.hash = "no-back-button";
    window.location.hash = "Again-No-back-button";//again because google chrome don't insert first hash into history
    window.onhashchange = function () { window.location.hash = "no-back-button"; }


});


//***** Grid Merging ********\\

function LinkClicked(id) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show')
    $("#assetRegister :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#hdnARPrimaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");
    var hasAuthorizePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");

    if (hasEditPermission) {
        action = "Edit"

    }
    else if (!hasEditPermission && !hasAuthorizePermission && hasViewPermission) {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#btnDelete').show();
    }
    $('#exportbtn').show();
    if (action == 'View') {
        $("#assetRegister :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnAREdit').show();
        //$('#btnSaveandAddNew').show();
        $('#btnARSave').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#hdnARPrimaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/assetRegister/Get/" + primaryId)
          .done(function (result) {
              var getResult = JSON.parse(result);

              if (getResult.AssetSpecifications != null) {
                  $.each(getResult.AssetSpecifications, function (index, value) {
                      $('#selARSpecification').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                  });
              }
              $('#txtARSerialNo').prop("disabled", false);
              $('#selBatchNo').val(getResult.BatchNo),
              $('#hdnAttachId').val(getResult.HiddenId);
              $('#txtARAssetNo').attr('disabled', true);
              $('#txtARAssetPreRegistrationNo').attr('disabled', true);
              $('#spnPopup-assetPreRegistration').unbind("click").attr('disabled', true).css('cursor', 'default');

              $('#spnPopup-typeCode').unbind("click").attr('disabled', true).css('cursor', 'default');
              $('#txtARTypeCode').attr('disabled', true);
              $('#selARAssetClassification').attr('disabled', true);
              //----Added by Pranay-----------------//
              $('#txtARAssetNoS').text(getResult.AssetNo); 
              $('#txtAsset_NameS').text(getResult.Asset_Name);
              $('#txtARPackageS').text(getResult.Package_Code);
              $('#txtAsset_Typecode').text(getResult.AssetTypeCode);
              $('#txtARAsset_itemcode').text(getResult.Item_Code);
              $('#txtAsset_itemdesc').text(getResult.Item_Description);
              $('#txtARAsset_services').text(getResult.ServicesID);
              $('#txtAsset_dept').text(getResult.UserAreaName);
              $('#txtARAsset_manufacturer').text(getResult.ManufacturerName);
              $('#txtAsset_location').text(getResult.UserLocationCode);
              $('#txtARAsset_model').text(getResult.ModelName);
              $('#txtAsset_serialno').text(getResult.SerialNo);
              $('#txtARAsset_country').text(getResult.Country);
              $('#txtAsset_engineNo').text(getResult.EngineNo);
              $('#txtARAsset_classtype').text(getResult.ClassType);
              $('#txtARAsset_softwareversion').text(getResult.softwareVersion);
              $('#txtAsset_chassis').text(getResult.ChasisNo);
              $('#txtARAsset_Lifespan').text(getResult.ExpectedLifespan);
              $('#txtARAsset_supplier').text(getResult.MainSupplier);
              $('#txtARAsset_contactperson').text(getResult.ContactPerson);
              $('#txtAsset_MobileNo').text(getResult.MobileNo);
              $('#txtARAsset_address').text(getResult.Address);
              $('#txtAsset_contact').text(getResult.ContactNo);
              $('#txtAsset_authservice').text(getResult.ContractorName);
              $('#txtAsset_contactpersonname').text(getResult.ContactPerson);
              $('#txtARAsset_addresS').text(getResult.Address);
              $('#txtAsset_contactNO').text(getResult.ContactNo);
              $('#txtARAsset_mobile').text(getResult.MobileNo);
              $('#txtARAsset_purchaseorderNo').text(getResult.PurchaseOrderNo);
              $('#txtAsset_Purchaseprice').text(getResult.PurchaseCostRM);
              $('#txtARAsset_purchasedate').text(getResult.PurchaseDate);
              $('#txtAsset_ppmfrequency').text(getResult.PPMCheckList);
              $('#txtARAsset_manufacturedate').text(getResult.ManufacturingDate);
              $('#txtARAsset_tandcDate').text(getResult.TandCDate);
              $('#txtARAsset_warrantystartdate').text(getResult.WarrantyStartDate);
              $('#txtARAsset_warrantyenddate').text(getResult.WarrantyEndDate);

              //---------END-------------------------------/////////////
              $('#txtARAssetNo,.txtARAssetNo, #txtSNFAssetNo,.AN').val(getResult.AssetNo);

              $('#hdnARAssetPreRegistrationNoId').val(getResult.TestingandCommissioningDetId);
              $('#txtARAssetPreRegistrationNo').val(getResult.AssetPreRegistrationNo);
              $('#hdnARTypeCodeId').val(getResult.AssetTypeCodeId);
              $('#txtARTypeCode,.txtARTypeCode').val(getResult.AssetTypeCode);
              $('#txtARTypeDescription').val(getResult.AssetTypeDescription);
              $('#selARAssetClassification').val(getResult.AssetClassification);
              //$('.txtARAssetDescription').val(getResult.AssetTypeDescription);//#txtARAssetDescription,
              $('#txtARCommissioningDate').val(moment(getResult.CommissioningDate).format("DD-MMM-YYYY"));
              $('#hdnARParentAssetId').val(getResult.AssetParentId);
              $('#txtARParentAsset').val(getResult.ParentAssetNo);
              $('#txtARServiceStartDate, #txtServiceStartDate').val(moment(getResult.ServiceStartDate).format("DD-MMM-YYYY"));
              $('#txtAREffectiveDate').val(getResult.EffectiveDate == null ? null : moment(getResult.EffectiveDate).format("DD-MMM-YYYY"));
              $('#txtExpectedLifespan').val(getResult.ExpectedLifespan);
              $('#selARRealTimeStatus').val(getResult.RealTimeStatusLovId == 0 || getResult.RealTimeStatusLovId == null ? "null" : getResult.RealTimeStatusLovId);
              $('#selARAssetStatus').val(getResult.AssetStatusLovId == 0 || getResult.AssetStatusLovId == null ? "null" : getResult.AssetStatusLovId);
              $('#txtARAssetAge').val(getResult.AssetAge == 0 ? null : getResult.AssetAge);
              $('#txtARYearInService').val(getResult.YearsInService == 0 ? null : getResult.YearsInService);
              $('#txtAROperatingHours').val(getResult.OperatingHours == 0 ? null : getResult.OperatingHours);

              $('#txtARTransferToUserLocation').val(getResult.TransferUserLocation);
              $('#txtARTransferDate').val(getResult.TransferDate == null ? null : moment(getResult.TransferDate).format("DD-MMM-YYYY"));
              $('#txtARTransferDate2').val(getResult.OtherTransferDate == null ? null : moment(getResult.OtherTransferDate).format("DD-MMM-YYYY"));
              $('#selARFacilityId').val(getResult.OtherFacilityId == 0 || getResult.OtherFacilityId == null ? "null" : getResult.OtherFacilityId);
              $('#txtARIfOthers').val(getResult.OtherSpecify);
              $('#txtARPreviousAssetNo').val(getResult.OtherPreviousAssetNo);

              $('#hdnARLocationId').val(getResult.UserLocationId);
              $('#txtARUserLocationCode').val(getResult.UserLocationCode);
              $('#txtARUserLocationName').val(getResult.UserLocationName);
              $('#hdnARInstalledLocationId').val(getResult.InstalledLocationId);
              $('#txtARCurrentAreaName').val(getResult.CurrentAreaName);
              $('#txtARCurrentAreaCode').val(getResult.CurrentAreaCode);

              $('#txtARUserAreaCode').val(getResult.UserAreaCode);
              $('#txtARUserAreaName').val(getResult.UserAreaName);
              $('#hdnARUserAreaId').val(getResult.UserAreaId);
              $('#hdnARManufacturerId').val(getResult.Manufacturer);
              $('#txtARManufacturer').val(getResult.ManufacturerName);
              $('#txtARNamePlateManufacturer').val(getResult.NamePlateManufacturer);
              $('#txtARChassisNo').val(getResult.ChassisNo);
              $('#txtAREngineNo').val(getResult.EngineNo);
              $('#hdnARModelId').val(getResult.Model);
              $('#txtARModel').val(getResult.ModelName);
              $('#selARAppliedPartType').val(getResult.AppliedPartTypeLovId == 0 || getResult.AppliedPartTypeLovId == null ? "null" : getResult.AppliedPartTypeLovId);
              $('#selAREquipmentClass').val(getResult.EquipmentClassLovId == 0 || getResult.EquipmentClassLovId == null ? "null" : getResult.EquipmentClassLovId);
              $('#selARSpecification').val(getResult.Specification == 0 || getResult.Specification == null ? "null" : getResult.Specification);
              $('#txtARSerialNo').val(getResult.SerialNo);
              $('#selARRiskRating').val(getResult.RiskRating);
              $('#txtARMainSupplier').val(getResult.MainSupplier);
              $('#SNFContractor').val(getResult.MainSupplier);
              $('#txtARManufacturingDate').val(getResult.ManufacturingDate == null ? null : moment(getResult.ManufacturingDate).format("DD-MMM-YYYY"));
              $('#selARSpecificationUnitType').val(getResult.PowerSpecification == 0 || getResult.PowerSpecification == null ? "null" : getResult.PowerSpecification);
              $('#txtARSpecificationUnitWatt').val(getResult.PowerSpecificationWatt == 0 ? null : getResult.PowerSpecificationWatt);
              $('#txtARSpecificationUnitAmpere').val(getResult.PowerSpecificationAmpere == 0 ? null : getResult.PowerSpecificationAmpere);
              $('#txtARVolt').val(getResult.Volt == 0 ? null : getResult.Volt);

              $('#selARPPM').val(getResult.PpmPlannerId == 0 || getResult.PpmPlannerId == null ? "null" : getResult.PpmPlannerId);
              $('#selARRI').val(getResult.RiPlannerId == 0 || getResult.RiPlannerId == null ? "null" : getResult.RiPlannerId);
              $('#selAROther').val(getResult.OtherPlannerId == 0 || getResult.OtherPlannerId == null ? "null" : getResult.OtherPlannerId);
              $('#txtExpectedLifespan').val(getResult.ExpectedLifespan == null ? '' : getResult.ExpectedLifespan);
              $('#txtAsset_Name').val(getResult.Asset_Name);
              $('#txtItem_Code').val(getResult.Item_Code);
              $('#txtPackage_Description').val(getResult.Item_Description);
              $('#txtPackage_Code').val(getResult.Package_Code);
              $('#txtPackage_Description').val(getResult.Package_Description);
             // $('#selWorkGroup').val(getResult.WorkGroup);
             // $('#selWorkGroupfems').val(getResult.WorkGroup);
              if (getResult.ServicesID == 2) {
              }
              else {
                  $('#selAssetCategoryid').val(getResult.Asset_Category);
              }
           

              var ppm = $('#selARPPM').val();
              var other = $('#selAROther').val();
              var ri = $('#selARRI').val();

              if (ppm == "99") {
                  $('#anchorARPPM').show();
              } else {
                  $('#anchorARPPM').hide();
              }
              if (other == "99") {
                  $('#anchorARCalibration').show();
              } else {
                  $('#anchorARCalibration').hide();
              }
              if (ri == "99") {
                  $('#anchorARRI').show();
              } else {
                  $('#anchorARRI').hide();
              }

              $('#txtARLastWorkOrderNo').val(getResult.LastSchduledWorkOrderNo);
              $('#txtARLasetWorkOrderDate').val(getResult.LastSchduledWorkOrderDateTime == null ? null : moment(getResult.LastSchduledWorkOrderDateTime).format("DD-MMM-YYYY"));

              //$('#txtARTotalDownTime').val(getResult.SchduledTotDowntimeHoursMinYTD == 0 ? null: getResult.SchduledTotDowntimeHoursMinYTD);
              ShowDownTime(getResult.SchduledTotDowntimeHoursMinYTD, 'txtARTotalDownTime');

              $('#txtARLastServiceWorkNo').val(getResult.LastUnSchduledWorkOrderNo);
              $('#txtARLastServiceWorkDate').val(getResult.LastUnSchduledWorkOrderDateTime == null ? null : moment(getResult.LastUnSchduledWorkOrderDateTime).format("DD-MMM-YYYY"));
              $('#txtARDefectList').val(getResult.DefectList);
              if (getResult.PurchaseCostRM != null) {
                  $('#txtARPurchaseCost, #txtSNFPurchaseCost, #txtWCPurchaseCost').val(addCommas(getResult.PurchaseCostRM));
              }
              else {
                  $('#txtARPurchaseCost, #txtSNFPurchaseCost, #txtWCPurchaseCost').val(getResult.PurchaseCostRM);
              }
              $('#txtARPurchaseDate, #txtSNFPurchaseDate').val(getResult.PurchaseDate == null ? null : moment(getResult.PurchaseDate).format("DD-MMM-YYYY"));
              $('#selARPurchaseCategory').val(getResult.PurchaseCategory == 0 || getResult.PurchaseCategory == null ? "null" : getResult.PurchaseCategory);
              $('#txtARWarrantyDuration, #txtWCWarrantyDuration').val(getResult.WarrantyDuration);
              $('#txtARWarrantyStartDate, #txtWCWarrantyStartDate').val(getResult.WarrantyStartDate == null ? null : moment(getResult.WarrantyStartDate).format("DD-MMM-YYYY"));
              $('#txtARWarrantyEndDate, #txtWCWarrantyEndDate').val(getResult.WarrantyEndDate == null ? null : moment(getResult.WarrantyEndDate).format("DD-MMM-YYYY"));
              if (getResult.CumulativeLabourCost != null) {
                  $('#txtARCumulativePartsCost').val(addCommas(getResult.CumulativePartCost == 0 ? '' : getResult.CumulativePartCost));
              }
              else {
                  $('#txtARCumulativePartsCost').val(getResult.CumulativePartCost == 0 ? '' : getResult.CumulativePartCost);
              }

              if (getResult.CumulativeLabourCost != null) {
                  $('#txtARCumulativeLabourCost').val(addCommas(getResult.CumulativeLabourCost == 0 ? '' : getResult.CumulativeLabourCost));
              }
              else {
                  $('#txtARCumulativeLabourCost').val(getResult.CumulativeLabourCost == 0 ? '' : getResult.CumulativeLabourCost);
              }
              if (getResult.CumulativeContractCost != null) {
                  $('#txtARCumulativeContractCost').val(addCommas(getResult.CumulativeContractCost == 0 ? '' : getResult.CumulativeContractCost));
              }
              else {
                  $('#txtARCumulativeContractCost').val(getResult.CumulativeContractCost == 0 ? '' : getResult.CumulativeContractCost);
              }

              if (getResult.CalculatedFeeDW != null && getResult.CalculatedFeeDW != 0) {
                  $('#txtMonthlyDWFee').val(addCommas(getResult.CalculatedFeeDW));
              }
              else {
                  $('#txtMonthlyDWFee').val('');
              }
              if (getResult.CalculatedFeePW != null && getResult.CalculatedFeePW != 0) {
                  $('#txtMonthlyPWFee').val(addCommas(getResult.CalculatedFeePW));
              }
              else {
                  $('#txtMonthlyPWFee').val('');
              }
              //$('#txtTotalWarrantyDownTime').val(getResult.TotalWarrantyDownTime);
              ShowDownTime(getResult.TotalWarrantyDownTime, 'txtTotalWarrantyDownTime')

              $('#selARRiskRating').val(getResult.RiskRating == 0 || getResult.RiskRating == null ? "null" : getResult.RiskRating);
              $('#txtARFacilityName').val(getResult.TransferFacilityName);
              $('#txtARRemarks').val(getResult.TransferRemarks);
              $('#txtARPreviousAssetNo').val(getResult.PreviousAssetNo);
              $('#txtARPurchaseOrderNumber').val(getResult.PurchaseOrderNo);
              $('#txtARInstalledLocationName').val(getResult.InstalledLocationName);
              $('#txtARInstalledLocationCode').val(getResult.InstalledLocationCode);
              $('#txtARSoftwareVersion').val(getResult.SoftwareVersion);
              $('#txtARSoftwareKey').val(getResult.SoftwareKey);
              $('#selARAssetTransferMode').val(getResult.TransferMode == 0 || getResult.TransferMode == null ? "null" : getResult.TransferMode);
              $('#txtARLevelName').val(getResult.LevelName);
              $('#txtARLevelcode').val(getResult.LevelCode);
              $('#txtARBlockName').val(getResult.BlockName);
              $('#txtARBlockCode').val(getResult.BlockCode);
              $('#txtARMainFuseRating').val(getResult.MainsFuseRating);
              $('#selRunningHoursCapture').val(getResult.RunningHoursCapture);
              $('#selContractType').val(getResult.ContractType == 0 || getResult.ContractType == null ? 'null' : getResult.ContractType);

              if (getResult.AuthorizationName == null || getResult.AuthorizationName == '') {
                  $('#btnARApprove').show();
              } else if (getResult.AuthorizationName == 'Authorized') {
                  $('#btnARApprove').hide();
                  authorization = 199;
              }
              else if (getResult.AuthorizationName == 'Unauthorized') {
                  authorization = 200;
                  $('#btnARApprove').show();
              }

              var assetWorkingStatusValue = getResult.AssetWorkingStatusValue == null ? '' : getResult.AssetWorkingStatusValue;
              var authorizationName = getResult.AuthorizationName == null ? '' : getResult.AuthorizationName;
              var hyphon = '';
              if (assetWorkingStatusValue != '' && authorizationName != '')
                  hyphon += ' - ';

              var assetOverallStatus = '<span style="color:red">' + assetWorkingStatusValue + hyphon + '</span>';

              assetOverallStatus += authorizationName;

              //$('.AssetAuthorizeStatus').text(getResult.AuthorizationName);
              $('.AssetAuthorizeStatus').html(assetOverallStatus);
              $('#hdnARTimestamp').val(getResult.Timestamp);
              $('#txtARServiceStartDate').attr('disabled', true);

              $('#anchorARAssetStatus').unbind('click');
              $('#anchorARAssetStatus').click(AssetStatusClicked).attr('disabled', false).css('cursor', 'pointer');

              $('#anchorARRealTimeStatus').unbind('click');
              $('#anchorARRealTimeStatus').click(RealTimeStatusClicked).attr('disabled', false).css('cursor', 'pointer');

              EnableFields();
              $('#myPleaseWait').modal('hide');
          })
         .fail(function (response) {
             $('#myPleaseWait').modal('hide');
             $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
             $('#errorMsg').css('visibility', 'visible');
         });
    }
    else {
        $('#txtARAssetPreRegistrationNo').attr('disabled', true);
        $('#txtARManufacturer').attr('disabled', true);
        $('#txtARModel').attr('disabled', true);

        $('#spnPopup-assetPreRegistration').unbind("click").attr('disabled', true).css('cursor', 'default');
        $('#spnPopup-manufacturer').unbind("click").attr('disabled', true).css('cursor', 'default');
        $('#spnPopup-model').unbind("click").attr('disabled', true).css('cursor', 'default');

        $('#anchorARAssetStatus').attr('disabled', true).unbind('click').css('cursor', 'default');
        $('#anchorARRealTimeStatus').attr('disabled', true).unbind('click').css('cursor', 'default');
        $('#anchorARDefectList').attr('disabled', true);

        $('#myPleaseWait').modal('hide');
    }
}

function ShowDownTime(DownTimeHours, Id) {
    if (DownTimeHours != null && DownTimeHours != 0) {
        var hours = Math.floor(DownTimeHours / 60);
        var minutes = parseInt(DownTimeHours % 60);

        var hoursStr = hours.toString();
        var minutesStr = minutes.toString();

        hoursStr = hoursStr.length == 1 ? '0' + hoursStr : hoursStr;
        minutesStr = minutesStr.length == 1 ? '0' + minutesStr : minutesStr;

        var downtimeString = hoursStr + ':' + minutesStr;
        //$('#txtARTotalDownTime').val(downtimeString);
        $('#' + Id).val(downtimeString);
    } else {
        $('#' + Id).val('');
    }
}

$("#btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/assetRegister/Delete/" + ID)
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
    $('#selARAssetClassification').val("null");
    $('#selARServiceId,.selARServiceId').val(2);
    $('#selARAssetStatus').val(1);
    $('#selARRiskRating').val(113);
    $('#selARPurchaseCategory').val("null");
    $('#selARAppliedPartType').val("null");
    $('#selAREquipmentClass').val("null");
    $('#selARPPM').val("null");
    $('#selAROther').val("null");
    $('#selARRI').val("null");
    $('#selARAssetTransferMode').val("null");
  //  $('#selWorkGroup').val('');
   // $('#selWorkGroupfems').val('');
    $('#selAssetCategoryid').val('');

    $('#txtARAssetNo').attr('disabled', false);

    $('#txtARTypeCode').attr('disabled', false);
    $('#txtARAssetPreRegistrationNo').attr('disabled', false);
    $('#spnPopup-assetPreRegistration').unbind("click").attr('disabled', false).css('cursor', 'default');
    $('#spnPopup-typeCode').unbind("click").attr('disabled', false).css('cursor', 'default');
    $('#btnAREdit').hide();
    //$('#btnARSave').show();
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#hdnARPrimaryID").val('');
    $("#grid").trigger('reloadGrid');
    $("#assetRegister :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('.AssetAuthorizeStatus').text('');
}
$("#exportbtn").click(function () {

    var primaryId = $('#hdnARPrimaryID').val();
    if (primaryId != null && primaryId != '' && primaryId != 0 && primaryId != '0') {
        var id = 0;
        var grid = $('#grid');
        var filters = JSON.stringify({
            groupop: "and",
            rules: [
                { field: "AssetId", op: "eq", data: $('#hdnARPrimaryID').val() }
            ]
        });
        var headerColumnNames = ['Hospital', 'Service', 'Asset No.', 'Type Code', 'Type Description',
                                 'Classification Code', 'Requester', 'Target Date', 'Request Description', 'Remarks',
                                 'Assignee', 'T&C Date', 'T&C Completed Date', 'Variation Status', 'Hand Over Date',
                                 'Company Representative', 'Facility Representative', ' Asset Pre Registration No.', 'Contract Type', 'User Department',
                                 'Department Name', 'Location No.', 'Location Name', 'Model', 'Serial No.',
                                 'Manufacturer','Purchase Cost','Purchase Order No.', 'Purchase Date','Service Statrt Date',
                                 'Warranty Start Date', 'Warranty Duration (In Months)', 'Warranty Remarks', 'Commissioning Date',  'Cumulative Parts Cost (RM)',
                                  'Vendor', 'Telephone No.', 'Fax No.', 'Email', 'Asset Age'];
        var mymodel = [
                         { key: true, label: 'Hospital', name: 'Hospital', width: '10%' },
                         { key: true, label: 'Service', name: 'Service', width: '10%' },
                         { key: true, label: 'Asset No.', name: 'AssetNo', width: '10%' },                         
                         { key: true, label: 'Type Code', name: 'TypeCode', width: '10%' },
                         { key: true, label: 'AssetDescription', name: 'AssetDescription', width: '10%' },
                         { key: true, label: 'ClassificationCode', name: 'ClassificationCode', width: '10%' },
                         { key: true, label: 'RequesterName', name: 'RequesterName', width: '10%' },
                         { key: true, label: 'TargetDate', name: 'TargetDate', width: '10%' },
                         { key: true, label: 'RequestDescription', name: 'RequestDescription', width: '10%' },                       
                         { key: true, label: 'Remarks', name: 'Remarks', width: '10%' },
                         { key: true, label: 'Assignee', name: 'Assignee', width: '10%' },
                         { key: true, label: 'TnCDate', name: 'TnCDate', width: '10%' },
                         { key: true, label: 'TnCCompletedDate', name: 'TnCCompletedDate', width: '10%' },
                         { key: true, label: 'VariationStatus', name: 'VariationStatus', width: '10%' }, 
                         { key: true, label: 'HandOverDate', name: 'HandOverDate', width: '10%' },
                         { key: true, label: 'CompanyRepresentative', name: 'CompanyRepresentative', width: '10%' },
                         { key: true, label: 'FacilityRepresentative', name: 'FacilityRepresentative', width: '10%' },
                         { key: true, label: 'AssetPreRegistrationNo', name: 'AssetPreRegistrationNo', width: '10%' },
                         { key: true, lab0el: 'ContractTypeName', name: 'ContractTypeName', width: '10%' },
                         { key: true, label: 'User Department', name: 'UserDepartment', width: '10%' },
                         { key: true, label: 'Department Name', name: 'DepartmentName', width: '10%' },
                         { key: true, label: 'Location No.', name: 'LocationNo', width: '10%' },
                         { key: true, label: 'Location Name', name: 'LocationName', width: '10%' },
                         { key: true, label: 'Model', name: 'Model', width: '10%' },
                         { key: true, label: 'Serial No.', name: 'SerialNo', width: '10%' },
                         { key: true, label: 'Manufacturer', name: 'Manufacturer', width: '10%' },
                         { key: true, label: 'PurchaseCost', name: 'PurchaseCost', width: '10%' },
                         { key: true, label: 'PurchaseOrderNo', name: 'PurchaseOrderNo', width: '10%' },
                         { key: true, label: 'Purchase Date', name: 'PurchaseDate', width: '10%' },
                         { key: true, label: 'ServiceStatrtDate', name: 'ServiceStatrtDate', width: '10%' },                         
                         { key: true, label: 'Warranty Start Date', name: 'WarrantyStartDate', width: '10%' },
                         { key: true, label: 'WarrantyDuration', name: 'WarrantyDuration', width: '10%' },
                         { key: true, label: 'WarrantyRemarks', name: 'WarrantyRemarks', width: '10%' }, 
                         { key: true, label: 'Commissioning Date', name: 'CommissioningDate', width: '10%' },
                         { key: true, label: 'Cumulative Parts Cost', name: 'CumulativePartsCost', width: '10%' },
                         { key: true, label: 'Vendor', name: 'Vendor', width: '10%' },
                         { key: true, label: 'Telephone No.', name: 'TelephoneNo', width: '10%' },
                         { key: true, label: 'Fax No.', name: 'FaxNo', width: '10%' },
                         { key: true, label: 'Email', name: 'Email', width: '10%' },
                         { key: true, label: 'AssetAge', name: 'AssetAge', width: '10%' },                         
        ];
        var columnNames = [];
        $.each(mymodel, function (i) {
            if (this.hidden != true) {
                columnNames.push(this.name);
            }
        });
        var sortColumnName = "ModifiedDateUTC";
        var sortOrder = "desc";

        var screenTitle = $("#menu").find("li.active:last").text();
        var $downloadForm = $("<form method='POST'>")
             .attr("action", "/api/common/Export")
             .append($("<input name='filters' type='text'>").val(filters))
             .append($("<input name='sortOrder' type='text'>").val(sortOrder))
             .append($("<input name='columnNames' type='text'>").val(columnNames))
             .append($("<input name='sortColumnName' type='text'>").val(sortColumnName))
             .append($("<input name='headerColumnNames' type='text'>").val(headerColumnNames))
             .append($("<input name='screenName' type='text'>").val("AssetRegister"))
             .append($("<input name='spName' type='text'>").val("uspFM_AssetRegisterTxn_Export"))
             .append($("<input name='exportType' type='text'>").val("CSV"))
             .append($("<input name='AssetId' type='text'>").val($('#hdnARPrimaryID').val()));

        $("body").append($downloadForm);
        var status = $downloadForm.submit();
        $downloadForm.remove();

    }
});


$("#Exportbtnsss").click(function () {
    //$("#fileUpLoad").val("");
    $("#fileUpLoadCSV").click();
});

function getFileUploadDetailsCSV(e, index) {
    var _index;

    for (var i = 0; i < e.files.length; i++) {
        var f = e.files[i];
        var extension = f.name.split(".");
        if (extension.length > 0) {
            if ((extension[1] == 'csv')) {
                var maxSize = 8388608;//7340032 - 7MB 8388608 - 8Mb;
                var fileSize = f.size; // in bytes
                if (fileSize > maxSize) {
                    alert('file size is more then' + maxSize + ' bytes' + fileSize);
                    $("#fileUpLoad").replaceWith($("#fileUpLoad").val('').clone(true));
                    return false;
                }
                else {
                    var blob = e.files[i].slice();
                    filetype = "application/csv"; //f.type
                    filesize = f.size;
                    filename = f.name;
                    var reader = new FileReader();
                    function getB64Str(buffer) {
                        var binary = '';
                        var bytes = new Uint8Array(buffer);
                        var len = bytes.byteLength;
                        for (var i = 0; i < len; i++) {
                            binary += String.fromCharCode(bytes[i]);
                        }
                        return window.btoa(binary);
                    }

                    reader.onload = function (evt) {

                        if (evt.target.readyState == FileReader.DONE) {
                            var cont = evt.target.result;
                            base64String = getB64Str(cont);
                        }
                    };
                    reader.readAsArrayBuffer(blob);
                }
            }
            else {
                bootbox.alert("Please Upload csv File");
                $(e).val('');
            }
        }
    }

    reader.onloadend = function () {
        $("#myPleaseWait").modal("show");
        console.log(base64String);
        var obj1 = {
            contentType: filetype,
            contentAsBase64String: base64String,
            fileResponseName: filename
        };
        console.log(obj1);

        var jqxhr = $.post("/api/assetRegister/Upload", obj1, function (response) {
            $('#errorMsg').css('visibility', 'hidden');
            $(".content").scrollTop(0);
            showMessage('PPM Planner', CURD_MESSAGE_STATUS.IM);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);
            $('#myPleaseWait').modal('hide');
        }, "json")
                 .fail(function (response) {
                     var errorMessage = "";
                     if (response.responseJSON == "[object Object]")
                         response.responseJSON = "Please Upload Valid CSV File!";
                     errorMessage = response.responseJSON;//Messages.COMMON_FAILURE_MESSAGE(response);
                     $("div.errormsgcenter").text(errorMessage);
                     $('#errorMsg').css('visibility', 'visible');
                     $('#btnSave').attr('disabled', false);
                     $('#myPleaseWait').modal('hide');
                 });
    };
}

$("#jQGridCollapse1").click(function () {
    // $(".jqContainer").toggleClass("hide_container");
    var pro = new Promise(function (res, err) {
        $(".jqContainer1").toggleClass("hide_container");
        res(1);
    })
    pro.then(
        function resposes() {
            setTimeout(() => $(".content").scrollTop(3000), 1);
        })
});

RedirectToWorkOrder = function (workOrderId, categoryId) {
    var message = '';
    if (categoryId == 187) {
        message = 'You will be redirected to the Scheduled Work Order screen. Are you sure you want to proceed?'
    } else {
        message = 'You will be redirected to the Unscheduled Work Order screen. Are you sure you want to proceed?'
    }
    bootbox.confirm(message, function (result) {
        if (result) {
            var url = '';
            if (categoryId == 187) {
                url = "/bems/scheduledworkorder/Index/" + workOrderId;
            } else {
                url = "/bems/unscheduledworkorder/Index/" + workOrderId;
            }
            window.location.href = url;
        }
    });
}

function DisableFields() {
    $('#txtARNamePlateManufacturer').attr('disabled', true);
    $('#selContractType').attr('disabled', true);
    $('#selARPurchaseCategory').attr('disabled', true);
    $('#txtARParentAsset').attr('disabled', true); //, spnPopup-parentAsset
    $('#spnPopup-parentAsset').unbind("click").attr('disabled', true).css('cursor', 'default');
    $('#txtAROperatingHours').attr('disabled', true);
    $('#selRunningHoursCapture').attr('disabled', true);
    $('#txtARManufacturingDate').attr('disabled', true);
    $('#selARAppliedPartType').attr('disabled', true);
    $('#selAREquipmentClass').attr('disabled', true);
    $('#selARRiskRating').attr('disabled', true);
    $('#txtARSoftwareVersion').attr('disabled', true);
    $('#txtARSoftwareKey').attr('disabled', true);
    $('#txtARSpecificationUnitWatt').attr('disabled', true);
    $('#txtARVolt').attr('disabled', true);
    $('#txtARSpecificationUnitAmpere').attr('disabled', true);
    $('#txtARMainFuseRating').attr('disabled', true);
    $('#selARAssetTransferMode').attr('disabled', true);
    $('#txtARTransferDate2').attr('disabled', true);
    $('#txtARFacilityName').attr('disabled', true);
    $('#txtARPreviousAssetNo').attr('disabled', true);
    $('#txtARRemarks').attr('disabled', true);
}
function EnableFields() {
    $('#txtARNamePlateManufacturer').attr('disabled', false);
    var hasAuthorizePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");
    if (hasAuthorizePermission) {
        $('#selContractType').attr('disabled', false);
    }
    else {
        $('#selContractType').attr('disabled', true);
    }
    //$('#selContractType').attr('disabled', false);
    $('#selARPurchaseCategory').attr('disabled', false);
    $('#txtARParentAsset').attr('disabled', false); //, spnPopup - parentAsset

    $('#spnPopup-parentAsset').unbind("click");
    $('#spnPopup-parentAsset').click(function () {
        DisplaySeachPopup('divARSearchPopup', parentAssetNoSearchObj, "/api/Search/ParentAssetNoSearch");
    }).attr('disabled', false).css('cursor', 'pointer');

    $('#txtAROperatingHours').attr('disabled', false);
    $('#selRunningHoursCapture').attr('disabled', false);
    $('#txtARManufacturingDate').attr('disabled', false);
    $('#selARAppliedPartType').attr('disabled', false);
    $('#selAREquipmentClass').attr('disabled', false);
    $('#selARRiskRating').attr('disabled', false);
    $('#txtARSoftwareVersion').attr('disabled', false);
    $('#txtARSoftwareKey').attr('disabled', false);
    $('#txtARSpecificationUnitWatt').attr('disabled', false);
    $('#txtARVolt').attr('disabled', false);
    $('#txtARSpecificationUnitAmpere').attr('disabled', false);
    $('#txtARMainFuseRating').attr('disabled', false);
    $('#selARAssetTransferMode').attr('disabled', false);
    $('#txtARTransferDate2').attr('disabled', false);
    $('#txtARFacilityName').attr('disabled', false);
    $('#txtARPreviousAssetNo').attr('disabled', false);
    $('#txtARRemarks').attr('disabled', false);
}

function printDiv(divName)
{
    generatePDF();
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
    generatePDF();
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

////-------------------------------------------------------------fetch location-------------------


function FetchUserLocation(event) {
    var ItemMst = {
        SearchColumn: 'txtARUserLocationCode' + '-UserLocationCode',//Id of Fetch field
        ResultColumns: ["UserLocationId" + "-Primary Key", 'UserLocationCode' + '-CrmReqUsrLocCde'],//Columns to be displayed
        AdditionalConditions: ["UserAreaId-hdnCrmReqUsrAreaCdId"],
        FieldsToBeFilled: ["hdnARInstalledLocationId" + "-UserLocationId", 'txtARUserLocationCode' + '-UserLocationCode', 'txtARUserLocationName' + '-UserLocationName',  'txtARCurrentAreaName' + '-UserAreaName', 'CrmReqUsrBlockNam' + '-BlockName', 'CrmReqUsrBlockCd' + '-BlockCode', 'CrmReqUsrLevelCd' + '-LevelCode', 'CrmReqUsrLevelNam' + '-LevelName']//id of element - the model property
    };
    DisplayFetchResult('UserLocFetch', ItemMst, "/api/Fetch/LocationCodeFetch", "Ulfetch4", event, 1);
}

    ////-----------------------------------END FETCH





function myFunction() {
  var popup = document.getElementById("myPopup");
  popup.classList.toggle("show");
}