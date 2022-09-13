var typeCodeSearchObj = {};
var manufacturerSearchObj = {};
var modelSearchObj = {};

var modelIdGet = null;
var manufacturerIdGet = null;

$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    formInputValidation("frmAssetStandardization");
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $.get("/api/assetStandardization/Load")
    .done(function (result) {
        var loadResult = JSON.parse(result);
        $("#jQGridCollapse1").click();
        //$.each(loadResult.Services, function (index, value) {
        //    $('#selService').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        //});

        //$.each(loadResult.Statuses, function (index, value) {
        //    $('#selStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        //});
        $.each(loadResult.Services, function (index, value) {
            $('#selServices').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });

        //var primaryId = $('#hdnPrimaryID').val();
        //if (primaryId != null && primaryId != "0") {

        //    $('#spnPopup-typeCode').unbind("click").attr('disabled', true).css('cursor', 'default');
        //    $('#txtTypeCode').attr('disabled', true);

        //    $.get("/api/assetStandardization/Get/" + primaryId)
        //      .done(function (result) {
        //          var getResult = JSON.parse(result);

        //          $('#selService').val(getResult.ServiceId);
        //          $('#hdnTypeCodeId').val(getResult.AssetTypeCodeId);
        //          $('#txtTypeCode').val(getResult.AssetTypeCode);
        //          $('#hdnManufacturerId').val(getResult.ManufacturerId);
        //          $('#txtManufacturer').val(getResult.Manufacturer);
        //          $('#hdnModelId').val(getResult.ModelId);
        //          $('#txtModel').val(getResult.Model);
        //          $('#selStatus').val(getResult.StatusId);
        //          $('#hdnTimestamp').val(getResult.Timestamp);

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

    function DisplayErrorMessage(errorMessage)
    {
        $("div.errormsgcenter").text(errorMessage);
        $('#errorMsg').css('visibility', 'visible');

        $('#btnSave').attr('disabled', false);
        $('#btnEdit').attr('disabled', false);
    }

    $("#btnSave, #btnEdit,#btnSaveandAddNew").click(function () {
        $('#btnSave').attr('disabled', true);
        $('#btnEdit').attr('disabled', true);

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var CurrentbtnID = $(this).attr("Id");
        var typeCodeId = $('#hdnTypeCodeId').val();
        var typeCodeName = $('#txtTypeCode').val();
        var hdnManufacturer = $('#hdnManufacturer').val();
        var txtManufacturer = $('#txtManufacturer').val();
        hdnManufacturer=hdnManufacturer.toUpperCase()
        txtManufacturer = txtManufacturer.toUpperCase();
        if (hdnManufacturer.trim() != txtManufacturer.trim())
        {
            $('#hdnManufacturerId').val('')
        }
       
        if (typeCodeId == '' && typeCodeName != '') {
            DisplayErrorMessage("Please enter valid Type Code");
            return false;
        }

        //var manufacturerId = $('#hdnManufacturerId').val();
        //var manufacturerName = $('#txtManufacturer').val();
        //if (manufacturerId == '' && manufacturerName != '')
        //{
        //    DisplayErrorMessage("Please enter valid Manufacturer");
        //    return false;
        //}

        //var modelId = $('#hdnModelId').val();
        //var modelName = $('#txtModel').val();
        //if (modelId == '' && modelName != '') {
        //    DisplayErrorMessage("Please enter valid Model");
        //    return false;
        //}

        var isFormValid = formInputValidation("frmAssetStandardization", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            $('#btnEdit').attr('disabled', false);

            return false;
        }

        $('#myPleaseWait').modal('show');

        var saveObj = {
            AssetTypeCodeId: $('#hdnTypeCodeId').val(),
            ServiceId: $('#selServices').val(),
            ManufacturerId: $('#hdnManufacturerId').val(),
            Manufacturer: $('#txtManufacturer').val(),
            ModelId: $('#hdnModelId').val(),
            Model: $('#txtModel').val(),
            StatusId: $('#selStatus').val(),
        };

        var primaryId = $("#hdnPrimaryID").val();
        if (primaryId != null) {
            saveObj.AssetStandardizationId = primaryId;
            saveObj.Timestamp = $('#hdnTimestamp').val();
        }
        else {
            saveObj.AssetStandardizationId = 0;
            saveObj.Timestamp = "";
        }

        if (primaryId != null && (saveObj.ModelId != modelIdGet || saveObj.ManufacturerId != manufacturerIdGet)) {
            saveObj.AssetStandardizationId = null;
        }

        var jqxhr = $.post("/api/assetStandardization/Save", saveObj, function (response) {
            var result = JSON.parse(response);
            $("#hdnPrimaryID").val(result.AssetStandardizationId);
            $("#hdnTimestamp").val(result.Timestamp);

            $('#txtTypeCode').attr('disabled', true);
            $('#spnPopup-typeCode').unbind("click").attr('disabled', true).css('cursor', 'default');

            $('#hdnModelId').val(result.ModelId);
            $('#txtManufacturer').val(result.Manufacturer);
            $('#hdnManufacturer').val(result.Manufacturer);

            $('#hdnManufacturerId').val(result.ManufacturerId);
            modelIdGet = result.ModelId;
            manufacturerIdGet = result.ManufacturerId;

            $("#grid").trigger('reloadGrid');
            if (result.AssetStandardizationId != 0) {
                $('#btnNextScreenSave').show();
                $('#btnEdit').show();
                $('#btnDelete').show();
                $('#btnSave').hide();
                $('#txtManufacturer').val(result.Manufacturer).attr('disabled', true);
            }
            $(".content").scrollTop(0);
            showMessage('', CURD_MESSAGE_STATUS.SS);
           
            $('#btnSave').attr('disabled', false);
            $('#btnEdit').attr('disabled', false);

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

        //------------------------Search----------------------------
        typeCodeSearchObj = {
            Heading: "Type Code Details",
            SearchColumns: ['AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description', 'AssetClassificationCode-Asset Classification Code'],
            ResultColumns: ["AssetTypeCodeId-Primary Key", 'AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description', 'AssetClassificationCode-Asset Classification Code'],
            FieldsToBeFilled: ["hdnTypeCodeId-AssetTypeCodeId", "txtTypeCode-AssetTypeCode", "txtTypeDescription-AssetTypeDescription"]
        };

        $('#spnPopup-typeCode').click(function () {
            DisplaySeachPopup('divSearchPopup', typeCodeSearchObj, "/api/Search/TypeCodeSearch");
        });

        //manufacturerSearchObj = {
        //    Heading: "Manufacturer Details",
        //    SearchColumns: ['Manufacturer-Manufacturer'],
        //    AdditionalConditions: ["ScreenName-hdnScreenName"],
        //    ResultColumns: ["ManufacturerId-Primary Key", 'Manufacturer-Manufacturer'],
        //    FieldsToBeFilled: ["hdnManufacturerId-ManufacturerId", "txtManufacturer-Manufacturer"]
        //};

        //$('#spnPopup-manufacturer').click(function () {
        //    DisplaySeachPopup('divSearchPopup', manufacturerSearchObj, "/api/Search/ManufacturerSearch");
        //});

        modelSearchObj = {
            Heading: "Model Details",
            SearchColumns: ['Model-Model'],
            AdditionalConditions: ["ScreenName-hdnScreenName"],
            ResultColumns: ["ModelId-Primary Key", 'Model-Model', "Manufacturer-Manufacturer"],
            FieldsToBeFilled: ["hdnModelId-ModelId", "txtModel-Model", "hdnManufacturerId-ManufacturerId", "hdnManufacturer-Manufacturer", "txtManufacturer-Manufacturer"]
        };

        $('#spnPopup-model').click(function () {
            DisplaySeachPopup('divSearchPopup', modelSearchObj, "/api/Search/ModelSearch");
        });

        //----------------------------------------------------------

        //------------------------Fetch-----------------------------
        var typeCodeFetchObj = {
            SearchColumn: 'txtTypeCode-AssetTypeCode',
            ResultColumns: ["AssetTypeCodeId-Primary Key", 'AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description'],
            FieldsToBeFilled: ["hdnTypeCodeId-AssetTypeCodeId", "txtTypeCode-AssetTypeCode", "txtTypeDescription-AssetTypeDescription"]
        };

        $('#txtTypeCode').on('input propertychange paste keyup', function (event) {
            DisplayFetchResult('divTypeCodeFetch', typeCodeFetchObj, "/api/Fetch/TypeCodeFetch", "UlFetch", event, 1);
        });

        //var manufacturerFetchObj = {
        //    SearchColumn: 'txtManufacturer-Manufacturer',//Id of Fetch field
        //    AdditionalConditions: ["ScreenName-hdnScreenName"],
        //    ResultColumns: ["ManufacturerId-Primary Key", 'Manufacturer-Manufacturer'],
        //    FieldsToBeFilled: ["hdnManufacturerId-ManufacturerId", "txtManufacturer-Manufacturer"]
        //};

        //$('#txtManufacturer').on('input propertychange paste keyup', function (event) {
        //    DisplayFetchResult('divManufacturerFetch', manufacturerFetchObj, "/api/Fetch/ManufacturerFetch", "UlFetch2", event, 1);//1 -- pageIndex
        //});

        var modelFetchObj = {
            SearchColumn: 'txtModel-Model',//Id of Fetch field
            AdditionalConditions: ["ScreenName-hdnScreenName"],
            ResultColumns: ["ModelId-Primary Key", 'Model-Model'],
            FieldsToBeFilled: ["hdnModelId-ModelId", "txtModel-Model", "hdnManufacturerId-ManufacturerId", "hdnManufacturer-Manufacturer", "txtManufacturer-Manufacturer"]
        };

        $('#txtModel').on('input propertychange paste keyup', function (event) {
            DisplayFetchResult('divModelFetch', modelFetchObj, "/api/Fetch/ModelFetch", "UlFetch3", event, 1);//1 -- pageIndex
        });

    var manufacturerFetchObj = {
        SearchColumn: 'txtManufacturer-Manufacturer',//Id of Fetch field
        AdditionalConditions: ["ScreenName-hdnScreenName"],
        ResultColumns: ["ManufacturerId-Primary Key", 'Manufacturer-Manufacturer'],
        FieldsToBeFilled: [ "hdnManufacturerId-ManufacturerId", "hdnManufacturer-Manufacturer", "txtManufacturer-Manufacturer"]
    };
    $('#txtManufacturer').on('input propertychange paste keyup', function (event) {
        var ServiceId = $('#selServices').val();
        DisplayLocationCodeFetchResult('divAssetNoFetch', manufacturerFetchObj, "/api/Fetch/ManufacturerFetch", "UlFetch2", event, 1, ServiceId);//1 -- pageIndex
    });
    //--------------------------------------------------------------------
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
    var actionType = $('#hdnActionType').val();
    if (actionType == 'View') {
        $('#spnPopup-typeCode').unbind("click").attr('disabled', true).css('cursor', 'default');
        $('#spnPopup-manufacturer').unbind("click").attr('disabled', true).css('cursor', 'default');
        $('#spnPopup-model').unbind("click").attr('disabled', true).css('cursor', 'default');
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
});
function LinkClicked(id) {
    $(".content").scrollTop(1);
    $("#frmAssetStandardization :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#selService').val();
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#hdnPrimaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission && hasViewPermission) {
        action = "Edit"

    }
    else if (!hasEditPermission && hasViewPermission) {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#btnDelete').show();
    }

    if (action == 'View') {
        $('#spnPopup-typeCode').unbind("click").attr('disabled', true).css('cursor', 'default');
        $('#spnPopup-manufacturer').unbind("click").attr('disabled', true).css('cursor', 'default');
        $('#spnPopup-model').unbind("click").attr('disabled', true).css('cursor', 'default');
        $("#frmAssetStandardization :input:not(:button)").prop("disabled", true);
        
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#hdnPrimaryID').val();
    if (primaryId != null && primaryId != "0") {

        $('#spnPopup-typeCode').unbind("click").attr('disabled', true).css('cursor', 'default');
        $('#txtTypeCode').attr('disabled', true);

        $.get("/api/assetStandardization/Get/" + primaryId)
          .done(function (result) {
              var getResult = JSON.parse(result);
              $('#selServices option[value="' + getResult.ServiceId + '"]').prop('selected', true);
              //$('#selService').val(getResult.ServiceId);
              $('#hdnTypeCodeId').val(getResult.AssetTypeCodeId);
              $('#txtTypeCode').val(getResult.AssetTypeCode);
              $('#txtTypeDescription').val(getResult.AssetTypeDescription);
              $('#hdnManufacturerId').val(getResult.ManufacturerId);
              $('#txtManufacturer').val(getResult.Manufacturer).attr('disabled', true);
              $('#hdnManufacturer').val(getResult.Manufacturer);
              $('#hdnModelId').val(getResult.ModelId);
              $('#txtModel').val(getResult.Model);
              $('#selStatus').val(getResult.StatusId);
              $('#hdnTimestamp').val(getResult.Timestamp);

              modelIdGet = getResult.ModelId;
              manufacturerIdGet = getResult.ManufacturerId;

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

$("#btnDelete").click(function () {
    var ID = $('#hdnPrimaryID').val();
    confirmDelete(ID);
});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/assetstandardization/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('Asset standardization', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 EmptyFields();
             })
             .fail(function (response) {
                 showMessage('Asset standardization', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
        }

    });
}
function EmptyFields() {
    $(".content").scrollTop(0);
    $('#btnEdit').hide();
    $('#hdnManufacturer').val('');
    $('#btnSave').show();
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#hdnPrimaryID").val('');
    $("#AssetStandardizationId").val('');
    $('#selService').val('');
    $('input[type="text"], textarea').val('');

    $('#spnPopup-typeCode').attr('disabled', false).css('cursor', 'pointer');
    $('#spnPopup-typeCode').click(function () {
        DisplaySeachPopup('divSearchPopup', typeCodeSearchObj, "/api/Search/TypeCodeSearch");
    });

    $('#spnPopup-manufacturer').attr('disabled', false).css('cursor', 'pointer');
    $('#spnPopup-manufacturer').click(function () {
        DisplaySeachPopup('divSearchPopup', manufacturerSearchObj, "/api/Search/ManufacturerSearch");
    });

    $('#spnPopup-model').attr('disabled', false).css('cursor', 'pointer');
    $('#spnPopup-model').click(function () {
        DisplaySeachPopup('divSearchPopup', modelSearchObj, "/api/Search/ModelSearch");
    });

    $('#txtTypeCode').attr('disabled', false);
    $('#selService').val(2);
    $('#selStatus').val(1);
    $("#grid").trigger('reloadGrid');
    $("#frmAssetStandardization :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
}

////// validation for Model And Manufacturer/////
function myFunction() {
    var lol = $('#hdnModelId').val();
    var txtCLRDocumentNo = $('#txtModel').val();
    console.log(txtCLRDocumentNo);
    if (lol == '') {
        $("#txtManufacturer").attr('disabled', false);
    }
    else {
        $("#txtManufacturer").attr('disabled', true);
    }
}
////// end //////////