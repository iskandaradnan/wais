
$(document).ready(function () {
    $('#MaintenanceFlag').multiselect();
});
window.GlobalPopupList = [];
window.VariationListGloabal = [];
window.EngAssetTypeCodeFlagLovsGloabal = [];

$(document).ready(function () {

    $('.qap').hide();
    $(window).scroll(function () {
        $('.datetimeVariation').hide().fadeIn(800);
    });
    var MinimumStock1 = document.getElementById("TRPILessThan5YrsPerc");
    MinimumStock1.addEventListener('input', function (prev) {
        return function (evt) {
            if (!/^\d{0,3}(?:\.\d{0,2})?$/.test(this.value)) {
                this.value = prev;
            }
            else {
                prev = this.value;
            }
        };
    }(MinimumStock1.value), false);
    var MinimumStock2 = document.getElementById("TRPI5to10YrsPerc");
    MinimumStock2.addEventListener('input', function (prev) {
        return function (evt) {
            if (!/^\d{0,3}(?:\.\d{0,2})?$/.test(this.value)) {
                this.value = prev;
            }
            else {
                prev = this.value;
            }
        };
    }(MinimumStock2.value), false);

    var MinimumStock3 = document.getElementById("QAPUptimeTargetPerc");
    MinimumStock3.addEventListener('input', function (prev) {
        return function (evt) {
            if (!/^\d{0,3}(?:\.\d{0,2})?$/.test(this.value)) {
                this.value = prev;
            }
            else {
                prev = this.value;
            }
        };
    }(MinimumStock3.value), false);

    var MinimumStock4 = document.getElementById("TRPIGreaterThan10YrsPerc");
    MinimumStock4.addEventListener('input', function (prev) {
        return function (evt) {
            if (!/^\d{0,3}(?:\.\d{0,2})?$/.test(this.value)) {
                this.value = prev;
            }
            else {
                prev = this.value;
            }
        };
    }(MinimumStock4.value), false);

    $('#myPleaseWait').modal('show');
    $('#searchPOPup').show();
    formInputValidation("tdform");
    setTimeout(multiSelectshow, 10);
    $("#PopupGridId").empty();
    $("#variationgrid").empty();
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $("#QapVariation").prop('checked', true);
    $('#btnNextScreenSave').hide();
    $.get("/api/TypeCode/Load")
        .done(function (result) {
            $('#txtAssetClassificationCode,#AssetTypeCode,#AssetTypeDescription').prop('disabled', false);
            var loadResult = JSON.parse(result);
            $("#jQGridCollapse1").click();
            //$.each(loadResult.TypeOfContractValueLovs, function (index, value) {
            //    $('#TypeofContractLovId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            //});
            $.each(loadResult.LifeExpectancyValueLovs, function (index, value) {
                $('#LifeExpectancyId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.EquipmentFunctionCatagoryLovs, function (index, value) {
                $('#EquipmentFunctionCatagoryLovId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $('#EquipmentFunctionCatagoryLovId').val(116);
            $.each(loadResult.StatusLovs, function (index, value) {
                $('#LicenceAndCertificateApplicableId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.StatusLovs, function (index, value) {
                $('#QAPAssetTypeB1').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $('#QAPAssetTypeB1').val(99); // default to yes 
            $.each(loadResult.StatusLovs, function (index, value) {
                $('#QAPServiceAvailabilityB2').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.Services, function (index, value) {
                $('#selServices').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.CriticalityList, function (index, value) {
                $('#Criticality').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $('#QAPServiceAvailabilityB2').val(100);// default to no 
            $('#QAPUptimeTargetPerc').prop('disabled', true);
            $('#EffectiveFrom').prop('disabled', true);
            $('#EffectiveTo').prop('disabled', true);

            //variation rate grid
            if (loadResult.EngAssetTypeCodeVariationRates != null) {
                BindVariationDetailGrid(loadResult.EngAssetTypeCodeVariationRates);
                window.VariationListGloabal = loadResult.EngAssetTypeCodeVariationRates;
            }
            // multi select drop down binding 
            var optionHtml = "";
            for (var i = 0; i < loadResult.EngAssetTypeCodeFlagLovs.length; i++) {
                optionHtml += '<option value="' + loadResult.EngAssetTypeCodeFlagLovs[i].LovId + '">' + loadResult.EngAssetTypeCodeFlagLovs[i].FieldValue + '</option>';
            }
            $("#MaintenanceFlag").html(optionHtml);
            $("#MaintenanceFlag").val(94);
            setTimeout(multiSelectshow, 10);
            window.EngAssetTypeCodeFlagLovsGloabal = loadResult.EngAssetTypeCodeFlagLovs;
            $('#ServiceId').val(2);
            $('.vRateDisable').prop('disabled', false);
            $('.vRateDisable').val('');
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });


    function DisplayError() {
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnSave').attr('disabled', false);
    }

    $('#TRPILessThan5YrsPerc').on('input propertychange paste keyup', function (event) {
        var TRPILessThan5YrsPerc = parseFloat($('#TRPILessThan5YrsPerc').val());
        if (TRPILessThan5YrsPerc > 100 || TRPILessThan5YrsPerc <= 0) {
            $('#TRPILessThan5YrsPerc').parent().addClass('has-error');
        }
        else {
            $('#TRPILessThan5YrsPerc').parent().removeClass('has-error');
        }
    });

    $('#TRPI5to10YrsPerc').on('input propertychange paste keyup', function (event) {

        var TRPI5to10YrsPerc = parseFloat($('#TRPI5to10YrsPerc').val());
        if (TRPI5to10YrsPerc > 100 || TRPI5to10YrsPerc <= 0) {
            $('#TRPI5to10YrsPerc').parent().addClass('has-error');
        }
        else {
            $('#TRPI5to10YrsPerc').parent().removeClass('has-error');
        }
    });

    $('#TRPIGreaterThan10YrsPerc').on('input propertychange paste keyup', function (event) {

        var TRPIGreaterThan10YrsPerc = parseFloat($('#TRPIGreaterThan10YrsPerc').val());
        if (TRPIGreaterThan10YrsPerc > 100 || TRPIGreaterThan10YrsPerc <= 0) {
            $('#TRPIGreaterThan10YrsPerc').parent().addClass('has-error');
        }
        else {
            $('#TRPIGreaterThan10YrsPerc').parent().removeClass('has-error');
        }
    });

    $('#QAPUptimeTargetPerc').on('input propertychange paste keyup', function (event) {
        var QAPUptimeTargetPerc = parseFloat($('#QAPUptimeTargetPerc').val());
        if (QAPUptimeTargetPerc > 100 || QAPUptimeTargetPerc <= 0 && $('#QAPServiceAvailabilityB2 option:selected').text() == "Yes") {
            $('#QAPUptimeTargetPerc').parent().addClass('has-error');
        }
        else {
            $('#QAPUptimeTargetPerc').parent().removeClass('has-error');
        }
    });


    function ValidateVRate(list) {
        var isValid = true;
        for (var i = 0; i < list.length; i++) {
            if (parseFloat(list[i].VariationRate) <= 0 || parseFloat(list[i].VariationRate) > 100) {
                $('#VariationRate_' + i).parent().addClass('has-error');
                isValid = false;
                break;
            }
            else {
                $('#VariationRate_' + i).parent().removeClass('has-error');
            }
        }
        return isValid;
    }

    function ValidateVarationTab(vList) {
        var primaryID = $('#primaryID').val();
        var result = 0;
        var vRateCount = 0;
        var effectiveCount = 0;
        var QapVariation = $('#QapVariation').prop('checked');
        var d = new Date();
        var currentDate = new Date(d.getFullYear(), d.getMonth(), d.getDate());
        $.each(vList, function (ind, data) {
            var efdate = new Date(data.EffectiveFromDate);
            var effectiveFromDate = new Date(efdate.getFullYear(), efdate.getMonth(), efdate.getDate());
            var peffDate = new Date(data.PreviousEffectiveFromDate);
            var previousEffDate = new Date(peffDate.getFullYear(), peffDate.getMonth(), peffDate.getDate());

            if (QapVariation) {
                if (parseFloat(data.VariationRate) <= 0 || parseFloat(data.VariationRate) > 100 || data.VariationRate == '') {
                    vRateCount++;
                }
            }
            else {
                if (parseFloat(data.VariationRate) < 0 || parseFloat(data.VariationRate) > 100 || data.VariationRate == '') {
                    vRateCount++;
                }
            }
            if ((primaryID == null || primaryID == 0 || primaryID == "0")) {
                if (effectiveFromDate < currentDate) {
                    effectiveCount++;
                }
            }
            else {

                if (data.EffectiveFromDate != data.PreviousEffectiveFromDate) { //&& effectiveFromDate < currentDate
                    if (effectiveFromDate < currentDate) {
                        effectiveCount++;
                    }
                }
            }
        });
        if (vRateCount > 0 || effectiveCount > 0) {
            result = 1;
        }
        else
            result = 0;
        return result;

    }

    // Variation rate 
    $("#QapVariation").change(function () {
        if (this.checked) {
            $('.vRateDisable').attr('disabled', false);
        }
        else {
            var message = "Variation Rate will be reset to ZERO. Do you want to proceed?";
            bootbox.confirm(message, function (result) {
                if (result) {
                    $('#VariationRate_0,#VariationRate_1,#VariationRate_2,#VariationRate_3,#VariationRate_4,#VariationRate_5').parent().removeClass('has-error');
                    $('#VariationRate_6,#VariationRate_7,#VariationRate_8,#VariationRate_9,#VariationRate_10,#VariationRate_11,#VariationRate_12').parent().removeClass('has-error');
                    $('.vRateDisable').attr('disabled', true);
                    $('.vRateDisable').val(0);
                }
                else {
                    $("#QapVariation").prop('checked', true);
                    bootbox.hideAll();
                    return false;
                }
            });
        }
    });




    //Save Startd
    $("#btnSave,#btnEdit,#btnSaveandAddNew").click(function ()
    {
       // $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var CurrentbtnID = $(this).attr("Id");
        var primaryId = $("#primaryID").val();
        var AssetClassificationCode = $("#txtAssetClassificationCode").val();
        var AssetTypeCode = $("#AssetTypeCode").val();
        var AssetTypeDescription = $("#AssetTypeDescription").val();
        var timestamp = $("#Timestamp").val();
        var MaintenanceFlag = $("#MaintenanceFlag").val();
        var TRPILessThan5YrsPerc = $('#TRPILessThan5YrsPerc').val();
        var TRPI5to10YrsPerc = $('#TRPI5to10YrsPerc').val();
        var TRPIGreaterThan10YrsPerc = $('#TRPIGreaterThan10YrsPerc').val();
        var ActiveFromDate = new Date($('#EffectiveFrom').val());
        var ActiveFromDate = getDateToCompare($('#EffectiveFrom').val());
        var ActiveToDate = getDateToCompare($('#EffectiveTo').val());
        // var ActiveToDate = getDateToCompare($('#ActiveTo').val());
        // var ActiveToDate = new Date($('#EffectiveTo').val());
        var QAPServiceAvailabilityB2 = $('#QAPServiceAvailabilityB2').val();
        var expLifeSpan = $('#ExpectedLifeSpan').val();
        var criticality = $('#Criticality').val();
        //variation grid 
        var _index;        // var _indexThird;
        var variationresult = [];
        $('#variationgrid tr').each(function () {
            _index = $(this).index();
        });
        for (var i = 0; i <= _index; i++)
        {
            var _tempObj = {
                AssetTypeCodeVariationId: $('#AssetTypeCodeVariationId_' + i).val(),
                TypeCodeParameterId: $("#TypeCodeParameterId_" + i).val(),
                VariationRate: $('#VariationRate_' + i).val(),
                EffectiveFromDate: $('#EffectiveFromDate_' + i).val(),
                PreviousEffectiveFromDate: $('#PreviousEffectiveFromDate_' + i).val(),
                EffectiveFromDateUTC: $('#EffectiveFromDateUTC_' + i).val(),
                AssetTypeCodeId: (primaryId != null && primaryId != 0) ? primaryId : 0
            }
            variationresult.push(_tempObj);
        }

        var typecodeObj = {
            AssetTypeCodeId: (primaryId != null && primaryId != 0) ? primaryId : 0,
            ServiceId: $('#selServices').val(),
            Criticality: $('#Criticality').val(),
            AssetClassificationId: $('#hdnAssetClassificationId').val(),
            AssetClassificationCode: AssetClassificationCode,
            AssetTypeCode: AssetTypeCode,
            AssetTypeDescription: AssetTypeDescription,
            EquipmentFunctionCatagoryLovId: $('#EquipmentFunctionCatagoryLovId').val(),
            LifeExpectancyId: $('#LifeExpectancyId').val(),
            QAPAssetTypeB1: $('#QAPAssetTypeB1').val() == 99 ? true : false,
            QAPServiceAvailabilityB2: $('#QAPServiceAvailabilityB2').val() == 99 ? true : false,
            QAPUptimeTargetPerc: $('#QAPUptimeTargetPerc').val(),
            EffectiveFrom: $('#EffectiveFrom').val(),
            EffectiveFromUTC: $('#EffectiveFrom').val(),
            EffectiveTo: $('#EffectiveTo').val(),
            EffectiveToUTC: $('#EffectiveTo').val(),
            TRPILessThan5YrsPerc: $('#TRPILessThan5YrsPerc').val(),
            TRPI5to10YrsPerc: $('#TRPI5to10YrsPerc').val(),
            TRPIGreaterThan10YrsPerc: $('#TRPIGreaterThan10YrsPerc').val(),
            Timestamp: primaryId != null ? timestamp : "",
            EngAssetTypeCodeVariationRates: variationresult,
            ExpectedLifeSpan: $('#ExpectedLifeSpan').val(),
            MaintainanceFlagList: MaintenanceFlag
        }
        var result;
        if (variationresult != null && variationresult.length > 0) {
            result = ValidateVarationTab(variationresult);
        }
        var isFormValid = formInputValidation("tdform", 'save');

        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            DisplayError();
            return false;
        }
        else if ($("#hdnAssetClassificationId").val() == '0' || $("#hdnAssetClassificationId").val() == 0) {
            $('#txtAssetClassificationCode').parent().addClass('has-error');
            $("div.errormsgcenter").text("Valid Asset Classification Code is required ");
            DisplayError();
            return false;
        }
        else if ($('#ExpectedLifeSpan').val() == '0' || parseInt(expLifeSpan) <= 0) {
            $('#ExpectedLifeSpan').parent().addClass('has-error');
            $("div.errormsgcenter").text("Expected Life Span should be greater than 0 ");
            DisplayError();
            return false;
        }
        else if (TRPILessThan5YrsPerc <= 0 || TRPI5to10YrsPerc <= 0 ) {

            if ($('#TRPILessThan5YrsPerc').val() <= 0)
                $('#TRPILessThan5YrsPerc').parent().addClass('has-error');
            if ($('#TRPI5to10YrsPerc').val() <= 0)
                $('#TRPI5to10YrsPerc').parent().addClass('has-error');
            if ($('#TRPIGreaterThan10YrsPerc').val() <= 0)
                $('#TRPIGreaterThan10YrsPerc').parent().addClass('has-error');
            $("div.errormsgcenter").text("Uptime Target Cannot be 0");
            DisplayError();
            return false;
        }
        else if (parseFloat(TRPILessThan5YrsPerc) > 100 || parseFloat(TRPI5to10YrsPerc) > 100 ) {
            if ($('#TRPILessThan5YrsPerc').val() > 100)
                $('#TRPILessThan5YrsPerc').parent().addClass('has-error');
            if ($('#TRPI5to10YrsPerc').val() > 100)
                $('#TRPI5to10YrsPerc').parent().addClass('has-error');
            if ($('#TRPIGreaterThan10YrsPerc').val() > 100)
                $('#TRPIGreaterThan10YrsPerc').parent().addClass('has-error');
            $("div.errormsgcenter").text("Uptime Target Cannot be more than 100%");
            DisplayError();
            return false;
        }
        else if (parseFloat(TRPILessThan5YrsPerc) <= parseFloat(TRPI5to10YrsPerc) ) {
            $("div.errormsgcenter").text("Asset Age < 5 Yrs should be greater than Asset Age >10 Yrs  and Asset Age 5 - 10 Yrs.");
            DisplayError();
            return false;
        }
        //else if (parseFloat(TRPI5to10YrsPerc) <= parseFloat(TRPIGreaterThan10YrsPerc)) {

        //    $("div.errormsgcenter").text("Asset Age 5 - 10 Yrs should be greater than Asset Age >10 Yrs.");
        //    DisplayError();
        //    return false;
        //}

        else if (result == 1)
        {

            $.each(variationresult, function (index, data) {
                var d = new Date();
                var QapVariation = $('#QapVariation').prop('checked');
                var currentDate = new Date(d.getFullYear(), d.getMonth(), d.getDate());
                var efdate = new Date(data.EffectiveFromDate);
                var effectiveFromDate = new Date(efdate.getFullYear(), efdate.getMonth(), efdate.getDate());
                var peffDate = new Date(data.PreviousEffectiveFromDate);
                var previousEffDate = new Date(peffDate.getFullYear(), peffDate.getMonth(), peffDate.getDate());
                if (QapVariation) {

                    if (data.VariationRate <= 0 || data.VariationRate > 100 || data.VariationRate == '') {
                        $('#VariationRate_' + index).parent().addClass('has-error');
                    }
                    else {
                        $('#VariationRate_' + index).parent().removeClass('has-error');
                    }
                }
                else {
                    if (data.VariationRate < 0 || data.VariationRate > 100 || data.VariationRate == '') {
                        $('#VariationRate_' + index).parent().addClass('has-error');
                    }
                    else {
                        $('#VariationRate_' + index).parent().removeClass('has-error');
                    }
                }


                if ((primaryId == null || primaryId == 0 || primaryId == "0")) {
                    if (effectiveFromDate < currentDate) {
                        $('#EffectiveFromDate_' + index).parent().addClass('has-error');
                    }
                }
                else {

                    if (data.EffectiveFromDate != data.PreviousEffectiveFromDate) { //&& effectiveFromDate < currentDate
                        if (effectiveFromDate < currentDate) {
                            $('#EffectiveFromDate_' + index).parent().addClass('has-error');
                        }
                    }
                }
            });
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);

            DisplayError();
            return false;
        }
        else {
            var jqxhr = $.post("/api/TypeCode/Add", typecodeObj, function (response)
            {
                var result = JSON.parse(response);
                $('#assetsearchPopup').hide();
                $("#variationgrid").empty();
                $("#PopupGridId").empty();
                $('#Criticality').val(result.Criticality);
                $("#primaryID").val(result.AssetTypeCodeId);
                $("#Timestamp").val(result.Timestamp);
                BindTypeCodeDetails(result);
                if (result.EngAssetTypeCodeVariationRates != null)
                {
                    BindVariationDetailGrid(result.EngAssetTypeCodeVariationRates);

                    var count = Enumerable.From(result.EngAssetTypeCodeVariationRates).Where('x => x.VariationRate > 0').Count()
                    if (count > 0) {
                        $("#QapVariation").prop('checked', true);
                        $('.vRateDisable').prop('disabled', false);
                    }
                    else {
                        $("#QapVariation").prop('checked', false);
                        $('.vRateDisable').prop('disabled', true);
                    }
                }
                $("#grid").trigger('reloadGrid');
                if (result.AssetTypeCodeId != 0) {
                    $('#btnNextScreenSave').show();
                    $('#btnEdit').show();
                    $('#btnSave').hide();
                    $('#btnDelete').show();
                }
                $(".content").scrollTop(0);
                showMessage('Type Code Details', CURD_MESSAGE_STATUS.SS);
                $("#top-notifications").modal('show');
                setTimeout(function () {
                    $("#top-notifications").modal('hide');
                }, 5000);

                $('#btnSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
                if (CurrentbtnID == "btnSaveandAddNew")
                {
                    EmptyFields();
                }
            },"json").fail(function (response) {
                    var errorMessage = "";
                    if (response.status == 400) {
                        errorMessage = response.responseJSON;
                    }
                    else {
                        errorMessage = Messages.COMMON_FAILURE_MESSAGE;
                    }
                    if (errorMessage == '1') {
                        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
                        if ($('#EffectiveFrom').val() == "" || $('#EffectiveFrom').val() == null) {
                            $('#EffectiveFrom').parent().addClass('has-error');
                        }
                        if ($('#EffectiveTo').val() == "" || $('#EffectiveTo').val() == null) {
                            $('#EffectiveTo').parent().addClass('has-error');
                        }
                        if ($('#QAPUptimeTargetPerc').val() == "" || parseFloat($('#QAPUptimeTargetPerc').val()) == 0) {
                            $('#QAPUptimeTargetPerc').parent().addClass('has-error');
                        }
                        if (parseFloat($('#QAPUptimeTargetPerc').val()) > 100 || parseFloat($('#QAPUptimeTargetPerc').val()) <= 0) {

                            $('#QAPUptimeTargetPerc').parent().addClass('has-error');
                        }
                    }
                    else if (errorMessage == '2') {
                        $("div.errormsgcenter").text("Effective To Should be greater than or equal to Effective From Date");
                        $('#EffectiveTo').parent().addClass('has-error');
                    }
                    else {
                        $("div.errormsgcenter").text(errorMessage);
                    }

                    $('#errorMsg').css('visibility', 'visible');

                    $('#btnSave').attr('disabled', false);
                    // $('#assetsearchPopup').show();
                    $('#myPleaseWait').modal('hide');
                });
        }

    });

    /********************************** Fetch and Search Classification Code  Start********************************************/
    var classificationObj = {
        SearchColumn: 'txtAssetClassificationCode-AssetClassificationCode',//Id of Fetch field
        ResultColumns: ["AssetClassificationId-Primary Key", 'AssetClassificationCode-Asset Classification Code', 'AssetClassificationDescription-Asset Classification Description'],//Columns to be displayed
        FieldsToBeFilled: ["hdnAssetClassificationId-AssetClassificationId", "txtAssetClassificationCode-AssetClassificationCode", "txtAssetClassificationDescription-AssetClassificationDescription"]//id of element - the model property
    };

    $('#txtAssetClassificationCode').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch', classificationObj, "/api/Fetch/AssetClassificationCodeFetch", "UlFetch3", event, 1);//1 -- pageIndex

    });


    var searchObj = {
        Heading: "Asset Classification Details",//Heading of the popup
        SearchColumns: ['AssetClassificationCode-Asset Classification Code', 'AssetClassificationDescription-Asset Classification Description'],//ModelProperty - Space seperated label value
        ResultColumns: ["AssetClassificationId-Primary Key", 'AssetClassificationCode-Asset Classification Code', 'AssetClassificationDescription-Asset Classification Description'],//Columns to be returned for display
        FieldsToBeFilled: ["hdnAssetClassificationId-AssetClassificationId", "txtAssetClassificationCode-AssetClassificationCode", "txtAssetClassificationDescription-AssetClassificationDescription"],

    };

    $('#spnPopup-acc').click(function () {

        var Services = $("#selServices").val();

        var searchObjs = {
            Heading: "Asset Classification Details",//Heading of the popup
            SearchColumns: ['AssetClassificationCode-Asset Classification Code', 'AssetClassificationDescription-Asset Classification Description'],//ModelProperty - Space seperated label value
            ResultColumns: ["AssetClassificationId-Primary Key", 'AssetClassificationCode-Asset Classification Code', 'AssetClassificationDescription-Asset Classification Description'],//Columns to be returned for display
            FieldsToBeFilled: ["hdnAssetClassificationId-AssetClassificationId", "txtAssetClassificationCode-AssetClassificationCode", "txtAssetClassificationDescription-AssetClassificationDescription"],
            TypeOfServices: Services,

        };

        DisplaySeachPopup('divSearchPopup', searchObjs, "/api/Search/AssetClassificationCodeSearch");
    });

    /********************************** Fetch and Search Classification Code  End********************************************/

    $('#btnAddNew').click(function () {
        window.location.reload();
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
});


$('#QAPServiceAvailabilityB2').change(function () {
    var value = $('#QAPServiceAvailabilityB2 option:selected').text();

    if (value == "No") {
        $('.qap').hide();
        $('#QAPUptimeTargetPerc').val("");
        $('#QAPUptimeTargetPerc').prop('disabled', true);
        $('#EffectiveFrom').val(null);
        $('#EffectiveTo').val(null);
        $('#EffectiveFrom').prop('disabled', true);
        $('#EffectiveTo').prop('disabled', true);
        $('#EffectiveFrom').parent().removeClass('has-error');
        $('#EffectiveTo').parent().removeClass('has-error');
        $('#QAPUptimeTargetPerc').parent().removeClass('has-error');
    }
    else {
        $('.qap').show();
        $('#QAPUptimeTargetPerc').prop('disabled', false);
        $('#EffectiveFrom').prop('disabled', false);
        $('#EffectiveTo').prop('disabled', false);
    }

});
function BindTypeCodeDetails(getResult) {
    //debugger;
    var ActionType = $('#ActionType').val();
    $('#txtAssetClassificationCode,#AssetTypeCode,#AssetTypeDescription').prop('disabled', true);
    $('#searchPOPup').show();
    $('#btnDelete').show();
    $('#primaryID').val(getResult.AssetTypeCodeId);
    $('#selServices').val(getResult.ServiceId);
    $('#hdnAssetClassificationId').val(getResult.AssetClassificationId);
    $('#txtAssetClassificationCode').val(getResult.AssetClassificationCode);
    $('#txtAssetClassificationDescription').val(getResult.AssetClassificationDescription);
    $('#AssetTypeCode').val(getResult.AssetTypeCode);
    $('#AssetTypeDescription').val(getResult.AssetTypeDescription);
    $('#Criticality').val(getResult.Criticality);
    //  $('#TypeofContractLovId').val(getResult.TypeofContractLovId);
    $('#ExpectedLifeSpan').val(getResult.ExpectedLifeSpan);
    if (getResult.LifeExpectancyId != null && getResult.LifeExpectancyId != 0) {
        $('#LifeExpectancyId').val(getResult.LifeExpectancyId);
    }
    else {
        $('#LifeExpectancyId').val('null');
    }

    $('#EquipmentFunctionCatagoryLovId').val(getResult.EquipmentFunctionCatagoryLovId);
    if (getResult.QAPAssetTypeB1) {
        $('#QAPAssetTypeB1').val(99);
    }
    else {
        $('#QAPAssetTypeB1').val(100);
    }

    var QAPUptimeTargetPerc = getResult.QAPUptimeTargetPerc;
    if (QAPUptimeTargetPerc != "" && QAPUptimeTargetPerc != "0" && QAPUptimeTargetPerc != 0 && QAPUptimeTargetPerc != undefined) {
        if (QAPUptimeTargetPerc % 1 === 0 && QAPUptimeTargetPerc != 0) {
            QAPUptimeTargetPerc = QAPUptimeTargetPerc + ".00";
        }
        else {
            if (QAPUptimeTargetPerc.toString().split(".")[1].length == 1) {
                QAPUptimeTargetPerc = QAPUptimeTargetPerc + "0";
            }
        }
    }
    if (QAPUptimeTargetPerc == 0)
        QAPUptimeTargetPerc = "";
    $('#QAPUptimeTargetPerc').val(QAPUptimeTargetPerc);
    if (getResult.EffectiveFrom != null) {
        $('#EffectiveFrom').val(DateFormatter(getResult.EffectiveFrom));
    }
    if (getResult.EffectiveTo != null) {
        $('#EffectiveTo').val(DateFormatter(getResult.EffectiveTo));
    }
    if (getResult.QAPServiceAvailabilityB2) {
        $('#QAPServiceAvailabilityB2').val(99);
        $('.qap').show();
        $('#EffectiveTo').attr('disabled', false);
        $('#EffectiveFrom').attr('disabled', false);
        $('#QAPUptimeTargetPerc').attr('disabled', false);
    }
    else {
        $('#EffectiveTo').val('');
        $('#EffectiveTo').attr('disabled', true);
        $('#EffectiveFrom').attr('disabled', true);
        $('#QAPUptimeTargetPerc').attr('disabled', true);
        $('#QAPUptimeTargetPerc').val('');
        $('#EffectiveFrom').val('');
        $('.qap').hide();
        $('#QAPServiceAvailabilityB2').val(100);
    }
    var TRPILessThan5YrsPerc = getResult.TRPILessThan5YrsPerc;
    if (TRPILessThan5YrsPerc != "" && TRPILessThan5YrsPerc != "0" && TRPILessThan5YrsPerc != 0 && TRPILessThan5YrsPerc != undefined) {
        if (TRPILessThan5YrsPerc % 1 === 0 && TRPILessThan5YrsPerc != 0) {
            TRPILessThan5YrsPerc = TRPILessThan5YrsPerc + ".00";
        }
        else {
            if (TRPILessThan5YrsPerc.toString().split(".")[1].length == 1) {
                TRPILessThan5YrsPerc = TRPILessThan5YrsPerc + "0";
            }
        }
    }
    $('#TRPILessThan5YrsPerc').val(TRPILessThan5YrsPerc);
    var TRPI5to10YrsPerc = getResult.TRPI5to10YrsPerc;
    if (TRPI5to10YrsPerc != "" && TRPI5to10YrsPerc != "0" && TRPI5to10YrsPerc != 0 && TRPI5to10YrsPerc != undefined) {
        if (TRPI5to10YrsPerc % 1 === 0 && TRPI5to10YrsPerc != 0) {
            TRPI5to10YrsPerc = TRPI5to10YrsPerc + ".00";
        }
        else {
            if (TRPI5to10YrsPerc.toString().split(".")[1].length == 1) {
                TRPI5to10YrsPerc = TRPI5to10YrsPerc + "0";
            }
        }
    }
    $('#TRPI5to10YrsPerc').val(TRPI5to10YrsPerc);
    var TRPIGreaterThan10YrsPerc = getResult.TRPIGreaterThan10YrsPerc;
    if (TRPIGreaterThan10YrsPerc != "" && TRPIGreaterThan10YrsPerc != "0" && TRPIGreaterThan10YrsPerc != 0 && TRPIGreaterThan10YrsPerc != undefined) {
        if (TRPIGreaterThan10YrsPerc % 1 === 0 && TRPIGreaterThan10YrsPerc != 0) {
            TRPIGreaterThan10YrsPerc = TRPIGreaterThan10YrsPerc + ".00";
        }
        else {
            if (TRPIGreaterThan10YrsPerc.toString().split(".")[1].length == 1) {
                TRPIGreaterThan10YrsPerc = TRPIGreaterThan10YrsPerc + "0";
            }
        }
    }
    $('#TRPIGreaterThan10YrsPerc').val(TRPIGreaterThan10YrsPerc);
    $('#Timestamp').val(getResult.Timestamp);
    $('#popupAssetTypeCode').val($('#AssetTypeCode').val());
    $('#popupAssetTypeDescription').val($('#AssetTypeDescription').val());
    //if ($('#QAPServiceAvailabilityB2 option:selected').text() == "Yes" && ActionType != "View") {
    //    $('#QAPUptimeTargetPerc,#EffectiveFrom,#EffectiveTo').removeAttr('disabled');
    //}

    //binding multi select 

}
//variation grid binding 


function BindAssetSpecificationPopup(SpeciList) {

    var ActionType = $('#ActionType').val();
    window.popupGlobalList = SpeciList;
    window.GlobalPopupList = SpeciList;
    $.each(SpeciList, function (index, data) {
        AddNewRow();
        $('#SpecificationTypeId_' + index).val(data.SpecificationType);
        $("#SpecificationUnitId_" + index).val(data.SpecificationUnit);
        $("#AssetTypeCodeAddSpecId_" + index).val(data.AssetTypeCodeAddSpecId);
        if (ActionType == "View") {
            $('#Active_' + index).prop('disabled', true);
            $('#SpecificationTypeId_' + index).prop('disabled', true);

        }


    });


}


function OnSpecificationTypeChange(maxindexval) {
    var rowCount = $('#PopupGridId tr:last').index();
    var SpecificationTypeId = $('#SpecificationTypeId_' + maxindexval).val();

    if (SpecificationTypeId == 120 || SpecificationTypeId == 121) {
        $('#SpecificationTypeId_' + maxindexval).parent().removeClass('has-error');
    }

    if (rowCount > 0 && isSpecTypeCombinationExists()) {
        bootbox.alert("This Specification Type already selected");
        $('#SpecificationTypeId_' + maxindexval).val("null");
        return false;
    }
    else {
        if (SpecificationTypeId == 120) {
            $('#SpecificationUnitId_' + maxindexval).val(118);
        }
        else if (SpecificationTypeId == 121) {
            $('#SpecificationUnitId_' + maxindexval).val(119);
        }
        else {
            $('#SpecificationUnitId_' + maxindexval).val("null");
        }
    }
}






$('#popupCloseBtn').click(function () {

    $('#Additional').modal("hide");
});


function LinkClicked(id) {
    $(".content").scrollTop(1);
    $("#tdform :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
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
        $("#assetclassFormid :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/TypeCode/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                $('#assetsearchPopup').hide();
                BindTypeCodeDetails(getResult);
                if (getResult.EngAssetTypeCodeVariationRates != null) {
                    BindVariationDetailGrid(getResult.EngAssetTypeCodeVariationRates);
                    var count = Enumerable.From(getResult.EngAssetTypeCodeVariationRates).Where('x => x.VariationRate > 0').Count()
                    if (count > 0) {
                        $("#QapVariation").prop('checked', true);
                        $('.vRateDisable').prop('disabled', false);
                    }
                    else {
                        $("#QapVariation").prop('checked', false);
                        $('.vRateDisable').prop('disabled', true);
                    }


                }
                //if (getResult.EngAssetTypeCodeAddSpecifications != null) {
                //    BindAssetSpecificationPopup(getResult.EngAssetTypeCodeAddSpecifications);
                //}
                setTimeout(multiSelectshow, 10);
                $("#MaintenanceFlag").val(getResult.MaintainanceFlagList);
                $('#myPleaseWait').modal('hide');
            })
            .fail(function () {
                $('#myPleaseWait').modal('hide');

                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');
            });
    }
    else {
        $('#assetsearchPopup').show();
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
            $.get("/api/TypeCode/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}

function EmptyFields() {
    $(".content").scrollTop(0);
    $("#variationgrid").empty();
    $("#QapVariation").prop('checked', true);
    $('input[type="text"], textarea').val('');
    $('#txtAssetClassificationCode,#AssetTypeCode,#AssetTypeDescription').prop('disabled', false);
    // $('#RiskRatingLovId').val("null");
    $('#LicenceAndCertificateApplicableId').val("null");
    $('#QAPAssetTypeB1').val(99);
    // $('#RiskRatingLovId').val("null"); 
    $('#QAPServiceAvailabilityB2').val("null");
    $('#LifeExpectancyId').val("null");
    //$('#TypeofContractLovId').val("null");
    $('#Active').val(1);
    $('#AssetCode').prop("disabled", false);
    $('#AssetDesc').prop("disabled", false);
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#ExpectedLifeSpan').val('');
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#AssetClassificationId").val('');
    $('#assetsearchPopup').show();
    $('#searchPOPup').show();
    $("#PopupGridId").empty();
    $('#Criticality').val();


    $('#QAPServiceAvailabilityB2').val(100);// default to no 
    $('#QAPUptimeTargetPerc').prop('disabled', true);
    $('#EffectiveFrom').prop('disabled', true);
    $('#EffectiveTo').prop('disabled', true);
    $("#grid").trigger('reloadGrid');
    $("#tdform :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#EquipmentFunctionCatagoryLovId').val(116);
    $('#errorMsg').css('visibility', 'hidden');
    var optionHtml = "";
    // $('#MaintenanceFlag').empty();
    for (var i = 0; i < window.EngAssetTypeCodeFlagLovsGloabal.length; i++) {
        optionHtml += '<option value="' + window.EngAssetTypeCodeFlagLovsGloabal[i].LovId + '">' + window.EngAssetTypeCodeFlagLovsGloabal[i].FieldValue + '</option>';
    }
    $("#MaintenanceFlag").html(optionHtml);
    $("#MaintenanceFlag").val(94);
    setTimeout(multiSelectshow, 10);
    $('#ServiceId').val(2);
    window.GlobalPopupList = [];
    //window.VariationListGloabal = [];   
    BindVariationDetailGrid(window.VariationListGloabal);
    $(".content").scrollTop(1);
    $('.vRateDisable').prop('disabled', false);
    $('.vRateDisable').val('');
}


//$('#TypeofContractLovId').click(function () {
//    var id = $('#TypeofContractLovId').val();
//    var list;
//    if (id == "279" || id == 279) {
//        list = Enumerable.From(window.VariationListGloabal).Where(function (x) { return (x.TypeCodeParameterId == 1 || x.TypeCodeParameterId == 2 || x.TypeCodeParameterId == 3) }).ToArray();

//    }
//    else if (id == "280" || id == 280) {
//        list = Enumerable.From(window.VariationListGloabal).Where(function (x) { return (x.TypeCodeParameterId == 4 || x.TypeCodeParameterId == 5 || x.TypeCodeParameterId == 6) }).ToArray();
//    }
//    else if (id == "281" || id == 281) {
//        list = Enumerable.From(window.VariationListGloabal).Where(function (x) { return (x.TypeCodeParameterId == 7 || x.TypeCodeParameterId == 8 || x.TypeCodeParameterId == 9 ) }).ToArray();
//    }
//    else if (id == "282" || id == 282) {
//        list = Enumerable.From(window.VariationListGloabal).Where(function (x) { return (x.TypeCodeParameterId == 10 || x.TypeCodeParameterId == 11 || x.TypeCodeParameterId == 12 ) }).ToArray();
//    }
//    BindVariationDetailGrid(list);
//});



/***************************************** Multi Select Start***********************************************************/
window.multiSelectshow = function () {
    $('select[name=Flag]').multiselect('destroy');
    $('select[name=Flag]').multiselect({ maxHeight: 200, maxWidth: 500, buttonWidth: '100%', includeSelectAllOption: true });

}
/********************************************* Multi Select End ***********************************************************/
window.BindVariationDetailGrid = function (list) {
    $("#variationgrid").empty();
    if (list.length > 0) {
        //debugger;
        var html = '';
        $(list).each(function (index, data) {
            data.EffectiveFromDate = (data.EffectiveFromDate != null && data.EffectiveFromDate != "") ? DateFormatter(data.EffectiveFromDate) : "";
            // data.VariationRate = data.VariationRate == 0 ? "" : data.VariationRate;
            data.VariationRate = data.VariationRate == 0 ? 0 : data.VariationRate;
            var vrate = data.VariationRate;
            if (vrate != "" && vrate != undefined && vrate != 0) {
                if (vrate % 1 === 0 && vrate != 0) {
                    vrate = vrate + ".00";
                }
                else {
                    if (vrate.toString().split(".")[1].length == 1) {
                        vrate = vrate + "0";
                    }
                }
            }
            html += '<tr>';
            html += '<td width="40%" style="text-align:center;" rowspan="1">';
            html += '<input type="hidden" readonly id="AssetTypeCodeVariationId_' + index + '" value="' + data.AssetTypeCodeVariationId + '" /> ';
            html += '<input disabled type="text" value="' + data.TypeCodeParameter + '" style="text-align:left;" class="form-control"/> ';
            html += '<input type="hidden" id="TypeCodeParameterId_' + index + '" value="' + data.TypeCodeParameterId + '" />';
            html += '  </td>';
            html += '<td width="25%" style="text-align:center;" rowspan="1"> <div>';
            html += '<input type="text" id="VariationRate_' + index + '"   value="' + vrate + '" style="text-align:right;" class="form-control decimalValidation variationrate vRateDisable"     maxlength="8"/>';
            html += '</div> </td>';
            html += ' <td width="25%" style="text-align:center;" rowspan="1"> <input type = "hidden" id="PreviousEffectiveFromDate_' + index + '" value="' + data.EffectiveFromDate + '" />     ';
            html += '<input type="text" id="EffectiveFromDate_' + index + '" value="' + data.EffectiveFromDate + '" required class="form-control datetimeVariation" maxlength="11"/> ';
            html += '</td>';
            html += ' </tr>';
            //debugger;
        });

        $('#variationgrid').append(html);
        formInputValidation("tdform");



        $('.datetimeVariation').datetimepicker({
            format: 'd-M-Y',
            minDate: 0,
            timepicker: false,
            step: 15,
            scrollInput: false,
            onChangeDateTime: function (dp, $input) {
                if ($input.val() !== "")
                    $($input).parent().removeClass('has-error');
            },
        });
        $('.decimalValidation').each(function (index) {
            $(this).attr('id', 'VariationRate_' + index);
            var vrate = document.getElementById(this.id);
            vrate.addEventListener('input', function (prev) {
                return function (evt) {
                    if ((!/^\d{0,3}(?:\.\d{0,2})?$/.test(this.value)) || this.value.length > 11) {
                        this.value = prev;
                    }
                    else {
                        prev = this.value;
                    }
                };
            }(vrate.value), false);
        });

        $('.variationrate').on('input propertychange paste keyup', function (event) {
            var id = $(this).attr('id');
            var index = id.substring(id.indexOf('_') + 1);
            var variationRate = parseFloat($('#VariationRate_' + index).val());
            if (variationRate > 100 || variationRate < 0) {
                $('#VariationRate_' + index).parent().addClass('has-error');
            }
            else {
                $('#VariationRate_' + index).parent().removeClass('has-error');
            }
        });

        var ActionType = $('#ActionType').val();
        if (ActionType == "View") {
            $(list).each(function (index, data) {
                $("#VariationRate_" + index).prop('disabled', true);
                $("#EffectiveFromDate_" + index).prop('disabled', true);
            });
        }
    }
}


///////////************sai dropdown****************//////////

var selects = document.querySelectorAll('select[name="selServices"]');

selects[0].addEventListener('change', function () {
    for (var i = 0; i < selects.length; i++) {
        selects[i].value = selects[0].value;
    }
});

////////////*************end*****************//////////