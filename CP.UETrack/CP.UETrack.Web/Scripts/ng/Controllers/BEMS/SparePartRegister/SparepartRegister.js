$(document).ready(function () {
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $('#myPleaseWait').modal('show');
    formInputValidation("SparepartsFormId");
    $('#txtModel').attr('disabled', true);
    $('#spnPopup-Model').hide();


    $.get("/api/SpareParts/Load")
        .done(function (result) {
           
            $("#jQGridCollapse1").click();
            var promiseLoad = JSON.parse(result);
            $.each(promiseLoad.UnitofMeasurementLovs, function (index, value) {
                $('#UnitOfMeasurement').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(promiseLoad.StockTypeLovs, function (index, value) {
                $('#SparePartType').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(promiseLoad.SparePartSourceLovs, function (index, value) {
                $('#PartSource').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(promiseLoad.SparePartStockLocationLovs, function (index, value) {
                $('#Location').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            //$.each(promiseLoad.PartCategoryList, function (index, value) {
            //    $('#PartCategory').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            //});
            $.each(promiseLoad.LifespanOptionsList, function (index, value) {
                $('#LifespanOptionsId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            // $('#IsExpirydate').val(100);
            $.each(promiseLoad.StatusLovs, function (index, value) {
                $('#Status').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $('#Status').val(1);
            $('#PartNo,#PartDescription,#txtItemNo,#txtItemDescription').prop('disabled', false);


        })
  .fail(function () {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
      $('#errorMsg').css('visibility', 'visible');
  });

    $('#SparePartImageVideoTab').on('click', function () {
        //code
        var primaryId = $('#primaryID').val();
        var HiddenId = $('#hdnAttachId').val();
        if (primaryId == 0) {
            bootbox.alert(Messages.SAVE_FIRST_TABALERT);
            return false;
        }
        else {
            if (HiddenId != null && HiddenId != "0" && HiddenId != "" && HiddenId != 0) {
                GetById(HiddenId);

            }
        }
    });



    $('#SparePartTab').on('click', function () {
        //code
        var primaryId = $('#primaryID').val();      
        if (primaryId == 0) {
            //bootbox.alert(Messages.SAVE_FIRST_TABALERT);
            //return false;
        }
        else {
            if (primaryId != null && primaryId != "0" && primaryId != "" && primaryId != 0) {
                GetSparePartData(primaryId);

            }
        }
    });



    var itemSearch = {
        Heading: "Item Code Details",
        SearchColumns: ['ItemNo-Item Code', 'ItemDescription-Item Description'],
        ResultColumns: ["ItemId-Primary Key", 'ItemNo-Item Code', 'ItemDescription-Item Description'],
        FieldsToBeFilled: ["hdnItemId-ItemId", "txtItemNo-ItemNo", "txtItemDescription-ItemDescription"],
    };
    $('#spnPopup-ItemCode').click(function () {
        DisplaySeachPopup('divSearchPopup', itemSearch, "/api/Search/ItemCodeSearch");
    });


    //Fetch and search - Asset Type Code
    var typeCodeFetchObj = {
        SearchColumn: 'txtAssetTypeCode-AssetTypeCode',//Id of Fetch field
        ResultColumns: ["AssetTypeCodeId-Primary Key", 'AssetTypeCode-Asset Type Code'],//Columns to be displayed
        FieldsToBeFilled: ["hdnAssetTypeCodeId-AssetTypeCodeId", "txtAssetTypeCode-AssetTypeCode"],//id of element - the model property
    };

    $('#txtAssetTypeCode').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch1', typeCodeFetchObj, "/api/Fetch/TypeCodeFetch", "UlFetch1", event, 1);//1 -- pageIndex
    });


    $('#hdnAssetTypeCodeId').change(function () {
        $('#txtModel').val("");
        $('#hdnModelId').val("");
        $('#hdnManufacturerId').val("");
        $('#txtManufacturer').val("");

        var hdnValue = $('#hdnAssetTypeCodeId').val();
        if (hdnValue != null && hdnValue != '') {
            $('#txtModel').attr('disabled', false);
            $('#spnPopup-Model').show();
        }
        else {
            $('#txtModel').attr('disabled', true);
            $('#spnPopup-Model').hide();
        }
    });



    var typeCodeSearchObj = {
        Heading: "Type Code Details",//Heading of the popup
        SearchColumns: ['AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description'],//ModelProperty - Space seperated label value
        ResultColumns: ["AssetTypeCodeId-Primary Key", 'AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description'],//Columns to be returned for display
        FieldsToBeFilled: ["hdnAssetTypeCodeId-AssetTypeCodeId", "txtAssetTypeCode-AssetTypeCode"], //id of element - the model property
    };
    $('#spnPopup-TypeCode').click(function () {
        DisplaySeachPopup('divSearchPopup', typeCodeSearchObj, "/api/Search/TypeCodeSearch");
    });


    //Fetch and search - Model
    var modelSearchObj = {
        Heading: "Model Details",
        SearchColumns: ['Model-Model'],

        ResultColumns: ["ModelId-Primary Key", 'Model-Model', 'Manufacturer-Manufacturer'],
        FieldsToBeFilled: ["hdnModelId-ModelId", "txtModel-Model", "hdnManufacturerId-ManufacturerId", "txtManufacturer-Manufacturer"],
        AdditionalConditions: ["TypeCodeId-hdnAssetTypeCodeId"],
    };

    $('#spnPopup-Model').click(function () {
        DisplaySeachPopup('divSearchPopup', modelSearchObj, "/api/Search/ModelSearch");
    });

    $('#hdnModelId').change(function () {
        var hdnValue = $('#hdnModelId').val();
        $('#txtManufacturer').val("");
        $('#hdnManufacturerId').val("");
    });
    var modelObj = {
        SearchColumn: 'txtModel-Model',//Id of Fetch field
        //AdditionalConditions: [],
        ResultColumns: ["ModelId-Primary Key", 'Model-Model'],//Columns to be displayed
        FieldsToBeFilled: ["hdnModelId-ModelId", "txtModel-Model", "hdnManufacturerId-ManufacturerId", "txtManufacturer-Manufacturer"],//id of element - the model property
        AdditionalConditions: ["TypeCodeId-hdnAssetTypeCodeId"],
    };

    $('#txtModel').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch3', modelObj, "/api/Fetch/ModelFetch", "UlFetch3", event, 1);//1 -- pageIndex
    });


    $('#Location').change(function () {
        DisplaySpecifyRequired();
    });

    function DisplaySpecifyRequired() {
        if ($('#Location').val() == 43) {
            $('#Specify').attr('required', true);
            $("#sparePartSpecify").html("Specify <span class='red'>*</span>");
        }
        else {
            $("#sparePartSpecify").html("Specify");
            $('#Specify').removeAttr('required');
            $('#Specify').parent().removeClass('has-error')
        }
    }


    $("#btnSave, #btnEdit,#btnSaveandAddNew").click(function () {
        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var CurrentbtnID = $(this).attr("Id");
        //remove red color border
        var primaryId = $('#primaryID').val();
        var timestamp = $('#Timestamp').val();
        var MaxUnit = $('#MaxUnit').val();
        var MinUnit = $('#MinUnit').val();
        var MinPrice = $('#MinPrice').val();
        var maxPrice = $('#MaxPrice').val();
        maxPrice = maxPrice.split(',').join('');
        //  var ExpiryAgeInMonth=$('#ExpiryAgeInMonth').val();
        var isFormValid = formInputValidation("SparepartsFormId", 'save');
        if (!isFormValid || $('#hdnAssetTypeCodeId').val() == "0" || $('#hdnAssetTypeCodeId').val() == "" || $('#hdnModelId').val() == "0" || $('#hdnModelId').val() == ""
      ) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            displayErrorMsg();
            if ($('#hdnAssetTypeCodeId').val() == "0" || $('#hdnAssetTypeCodeId').val() == "") {
                $('#txtAssetTypeCode').parent().addClass('has-error');
            }
            //if ($('#hdnManufacturerId').val() == "0" || $('#hdnManufacturerId').val() == "") {
            //    $('#txtManufacturer').parent().addClass('has-error');
            //}
            if ($('#hdnModelId').val() == "0" || $('#hdnModelId').val() == "") {
                $('#txtModel').parent().addClass('has-error');
            }

            return false;
        }


        else if (parseFloat(MaxUnit) == "0") {
            $("div.errormsgcenter").text("Max value cannot be zero");
            $('#MaxUnit').parent().addClass('has-error');
            displayErrorMsg();
            return false;
        }
        else if (MaxUnit != "" && (parseFloat(MaxUnit) < parseFloat(MinUnit))) {
            $("div.errormsgcenter").text("Max value should be greater than Min value");
            $('#MaxUnit').parent().addClass('has-error');
            displayErrorMsg(); return false;
        }
        else if (parseFloat(MinPrice) <= "0") {
            $('#MinPrice').parent().addClass('has-error');
            $("div.errormsgcenter").text("Min Price Per Unit (" + $('#hdnCurrency').val() + ")  cannot be zero");
            displayErrorMsg(); return false;
        }
        else if (MaxPrice == "" || parseFloat(MaxPrice) <= "0") {
            $('#MaxPrice').parent().addClass('has-error');
            $("div.errormsgcenter").text("Enter valid Max Price Per Unit (" + $('#hdnCurrency').val() + ")");
            displayErrorMsg();
            return false;
        }
        else if (parseFloat(MaxPrice) <= parseFloat(MinPrice)) {
            $('#MaxPrice').parent().addClass('has-error');
            $("div.errormsgcenter").text("Max Price Per Unit (" + $('#hdnCurrency').val() + ") should be greater than Min Price Per Unit (" + $('#hdnCurrency').val() + ") ");
            displayErrorMsg(); return false;
        }
        var minprice = $('#MinPrice').val();
        minprice = minprice.split(',').join('');
        var SparePartObj = {
            ServiceId: 2,
            ItemId: $('#hdnItemId').val(),
            ItemCode: $('#txtItemNo').val(),
            ItemDescription: $('#txtItemDescription').val(),
            PartNo: $('#PartNo').val(),
            PartDescription: $('#PartDescription').val(),
            AssetTypeCodeId: $('#hdnAssetTypeCodeId').val(),
            AssetTypeCode: $('#txtAssetTypeCode').val(),
            ManufacturerId: $('#hdnManufacturerId').val(),
            Manufacturer: $('#txtManufacturer').val(),
            ModelId: $('#hdnModelId').val(),
            ModelName: $('#txtModel').val(),
            UnitOfMeasurement: $('#UnitOfMeasurement').val(),
            SparePartType: $('#SparePartType').val(),
            Location: $('#Location').val(),
            Specify: $('#Specify').val(),
            PartCategory: $('#PartCategory').val(),
            MinLevel: $('#MinUnit').val(),
            MaxLevel: $('#MaxUnit').val(),
            MinPrice: minprice,
            MaxPrice: maxPrice,
            Status: $('#Status').val(),
            LifespanOptionsId: $('#LifespanOptionsId').val(),
            CurrentStockLevel: $('#CurrentStockLevel').val(),
            PartSourceId: $('#PartSource').val(),
        };

        if (primaryId != null) {
            SparePartObj.SparePartsId = primaryId;
            SparePartObj.Timestamp = timestamp;
        }
        else {
            SparePartObj.SparePartsId = 0;
            SparePartObj.Timestamp = "";
        }

        var jqxhr = $.post("/api/SpareParts/Add", SparePartObj, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.SparePartsId);
            $("#Timestamp").val(result.Timestamp);
            $('#hdnAttachId').val(result.HiddenId);
            $("#grid").trigger('reloadGrid');
            if (result.SparePartsId != 0) {
                $('#PartNo,#PartDescription,#txtItemNo,#txtItemDescription,#LifespanOptionsId').prop('disabled', true);
                $('#btnEdit').show();
                $('#btnDelete').show();
                $('#btnSave').hide();
                $('#txtAssetTypeCode,#txtModel').prop('disabled', true);
                $('#spnPopup-TypeCode').hide();
                $('#spnPopup-Model').hide();
            }
            $(".content").scrollTop(0);
            showMessage('Spare Parts', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);
            $('a.hiddenTab').css('display', 'none');
            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            if (CurrentbtnID == "btnSaveandAddNew") {
                ClearFields1();
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
            $('#PartNo,#PartDescription,#txtItemNo,#txtItemDescription').prop('disabled', false);
            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
    });


    $("#btnCancelreset1").click(function () {
        var message = Messages.Reset_Alert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                ClearFields1();
                SPimageVideoTabClear();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });

    function ClearFields1() {
        $('#spnPopup-ItemCode').show();
        $('#spnPopup-TypeCode').show();
        $(".content").scrollTop(0);
        $('#txtAssetTypeCode,#LifespanOptionsId').prop('disabled', false);
        //$('#txtManufacturer').prop('disabled', true);
        $('#spnPopup-Model').hide();
        // $('.Popdiv').show();
        $("input[type=text],textarea").val("");
        $('#UnitOfMeasurement').val('null');
        $('#PartSource').val('null');
        $('#Location').val('null');
        $('#Status').val(1);
        $('#SparePartType').val('null');
        //  $('#IsExpirydate').val(100);
        $('#LifespanOptionsId').val('null');
        $('#txtItemNo').removeAttr("disabled");
        $('#PartNo').removeAttr("disabled");
        $('#txtItemDescription').removeAttr("disabled");
        $('#PartDescription').removeAttr("disabled");
        $('#spnActionType').text('Add');
        $('#primaryID').val('');
        $('#btnEdit').hide();
        $('#btnSave').show();
        $('#btnDelete').hide();
        $("#grid").trigger('reloadGrid');
        $("#SparepartsFormId :input:not(:button)").parent().removeClass('has-error');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $('.nav-tabs a:first').tab('show');

    }


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
    function displayErrorMsg() {
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnSave').attr('disabled', false);
    }
});

$('#UnitOfMeasurement').change(function () {
    var text = $('#UnitOfMeasurement option:selected').text();

    if (text == "Kg") {
        $('#MinUnitLabel').html("Min Kg <span class='red'>*</span>");
        $('#MaxUnitLabel').html("Max Kg");

    }
    else if (text == "Nos") {
        $('#MinUnitLabel').html("Min Nos <span class='red'>*</span>");
        $('#MaxUnitLabel').html("Max Nos");
    }
    else if (text == "Boxes") {
        $('#MinUnitLabel').html("Min Boxes <span class='red'>*</span>");
        $('#MaxUnitLabel').html("Max Boxes");
    }
    else if (text == "Pcs") {
        $('#MinUnitLabel').html("Min Pcs <span class='red'>*</span>");
        $('#MaxUnitLabel').html("Max Pcs");
    }
    else {
        $('#MinUnitLabel').html("Min Unit <span class='red'>*</span>");
        $('#MaxUnitLabel').html("Max Unit");
    }
});

function LinkClicked(id) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#SparepartsFormId :input:not(:button)").parent().removeClass('has-error');
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
    else if (!hasEditPermission) {
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
        GetSparePartData(primaryId);
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}
function DisplaySpecifyRequired() {
    if ($('#Location').val() == 43) {
        $('#Specify').attr('required', true);
        $("#sparePartSpecify").html("Specify <span class='red'>*</span>");
    }
    else {
        $("#sparePartSpecify").html("Specify");
        $('#Specify').removeAttr('required');
        $('#Specify').parent().removeClass('has-error')
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
            $.get("/api/SpareParts/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('SpareParts', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 //  window.location.reload();
                 ClearFieldsondelete();
             })
             .fail(function () {
                 showMessage('SpareParts', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
        }

    });
}

function ClearFieldsondelete() {
    $('#spnPopup-ItemCode').show();
    $('#spnPopup-TypeCode').show();
    $('#txtAssetTypeCode,#LifespanOptionsId').prop('disabled', false);
    //$('#txtManufacturer').prop('disabled', true);
    $('#spnPopup-Model').hide();
    // $('.Popdiv').show();
    $("input[type=text],textarea").val("");
    $('#UnitOfMeasurement').val('null');
    $('#PartSource').val('null');
    $('#Location').val('null');
    $('#Status').val(1);
    $('#SparePartType').val('null');
    //  $('#IsExpirydate').val(100);
    $('#LifespanOptionsId').val('null');
    $('#txtItemNo').removeAttr("disabled");
    $('#PartNo').removeAttr("disabled");
    $('#txtItemDescription').removeAttr("disabled");
    $('#PartDescription').removeAttr("disabled");
    $('#spnActionType').text('Add');
    $('#primaryID').val('');
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnDelete').hide();
    $("#grid").trigger('reloadGrid');
    $("#SparepartsFormId :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('.nav-tabs a:first').tab('show');
}

window.GetSparePartData = function (primaryId)
{
    $.get("/api/SpareParts/Get/" + primaryId)
         .done(function (result) {
             var getResult = JSON.parse(result);
             $('#hdnAttachId').val(getResult.HiddenId);
             $('a.hiddenTab').css('display', 'none');
             $('#spnPopup-TypeCode').hide();
             $('#PartNo,#PartDescription,#txtItemNo,#txtItemDescription').prop('disabled', true);
             $('#txtAssetTypeCode,#txtModel').prop('disabled', true);
             //$('.Popdiv').hide();
             $('#primaryID').val(getResult.SparePartsId);
             $('#ServiceId').val(getResult.ServiceId);
             $('#hdnItemId').val(getResult.ItemId);
             $('#txtItemNo').val(getResult.ItemCode);
             $('#txtItemDescription').val(getResult.ItemDescription);
             $('#PartNo').val(getResult.PartNo);
             $('#PartDescription').val(getResult.PartDescription);
             $('#hdnAssetTypeCodeId').val(getResult.AssetTypeCodeId);
             $('#txtAssetTypeCode').val(getResult.AssetTypeCode);
             $('#hdnManufacturerId').val(getResult.ManufacturerId);
             $('#txtManufacturer').val(getResult.ManufacturerName);
             $('#hdnModelId').val(getResult.ModelId);
             $('#txtModel').val(getResult.ModelName);
             $('#UnitOfMeasurement').val(getResult.UnitOfMeasurement);
             $('#SparePartType').val(getResult.SparePartType);
             $('#Location').val(getResult.Location);
             $('#Specify').val(getResult.Specify);
             $('#PartCategory').val(getResult.PartCategory);
             $('#PartSource').val(getResult.PartSourceId);
             $('#LifespanOptionsId').val(getResult.LifespanOptionsId).prop('disabled', true);
             $('#PartDescription').attr('title', getResult.PartDescription);
             $('#ItemDescription').attr('title', getResult.ItemDescription);
             $('#Status').val(getResult.Status);
             $('#MinUnit').val(getResult.MinLevel);
             $('#MaxUnit').val(getResult.MaxLevel);
             $('#MinPrice').val(addCommas(getResult.MinPrice));
             $('#MaxPrice').val(addCommas(getResult.MaxPrice));
             $('#EstimatedLifeSpan').val(getResult.EstimatedLifeSpan);
             $('#MinUnit').val(getResult.MinLevel);
             $('#CurrentStockLevel').val(getResult.CurrentStockLevel);
             $('#Timestamp').val(getResult.Timestamp);
             $('#spnPopup-ItemCode').hide();
             DisplaySpecifyRequired();
             $('#myPleaseWait').modal('hide');
         })
        .fail(function () {
            $('#PartNo,#PartDescription,#txtItemNo').prop('disabled', false);
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });

}
