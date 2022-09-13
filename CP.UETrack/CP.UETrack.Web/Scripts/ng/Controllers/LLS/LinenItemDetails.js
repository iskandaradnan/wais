$(document).ready(function () {
    var primaryId = $("#primaryID").val();
    $('.btnDelete').hide();
    $('#myPleaseWait').modal('show');
    formInputValidation("FrmUser");
    //$('#btnDelete').hide();
    $('#btnBtnSaveandAddNew').hide();
    $.get("/api/LinenItemDetails/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#jQGridCollapse1").click();
            $.each(loadResult.Status, function (index, value) {
                $('#txtStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            
            $.each(loadResult.UOM, function (index, value) {
                $('#txtUnitofMeasurement').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.Material, function (index, value) {
                $('#txtMaterial').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.Colour, function (index, value) {
                $('#txtColor').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.Standard, function (index, value) {
                $('#txtStandard').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $('#txtUnitofMeasurement').val(10084);
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });
});

    $(".Save,.BtnSaveandAddNew").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $('#SelStatus').attr('required', true);
        $('#txtLinenCode').attr('required', true);
        $('#txtLinenDescription').attr('required', true);
        $('#txtUnitofMeasurement').attr('required', true);
        $('#txtMaterial').attr('required', true); 
        $('#txtStatus').attr('required', true);
        $('#txtEffectiveDate').attr('required', true);
        $('#txtSize').attr('required', true);
        $('#txtColor').attr('required', true); 
        $('#txtStandard').attr('required', true);
        $('#txtIdentificationMark').attr('required', true);
        
        var CurrentbtnID = $(this).attr("value");
        var timeStamp = $("#Timestamp").val();

        var isFormValid = formInputValidation("FrmUser", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var MstLinenItemDetails = {
            LinenCode: $('#txtLinenCode').val(),
            LinenDescription: $('#txtLinenDescription').val(),
            UOM: $('#txtUnitofMeasurement').val(),
            Material: $('#txtMaterial').val(),
            Status: $('#SelStatus').val(),
            EffectiveDate: $('#txtEffectiveDate').val(),
            Size: $('#txtSize').val(),
            Color: $('#txtColor').val(),
            Standard: $('#txtStandard').val(),
            IdentificationMark: $('#txtIdentificationMark').val(),
            LinenPrice: $('#txtLinenPrice').val(), 
        };

        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            MstLinenItemDetails.LinenItemId = primaryId;
            MstLinenItemDetails.Timestamp = timeStamp;
        }
        else {
            MstLinenItemDetails.LinenItemId = 0;
            MstLinenItemDetails.Timestamp = "";
        }
        
        var jqxhr = $.post("/api/LinenItemDetails/Save", MstLinenItemDetails, function (response) {
            var result = JSON.parse(response);
           
            $("#primaryID").val(result.LinenItemId);
            $("#Timestamp").val(result.Timestamp);
            $("#grid").trigger('reloadGrid');
            if (result.LinenItemId != 0) {
                $('#hdnAttachId').val(result.HiddenId);
                $('#txtDespatchDocumentNo').prop('disabled', true);
                //$('#SelStatus').prop('disabled', true);
                $('#txtLinenCode').prop('disabled', true);
                $('#txtLinenDescription').prop('disabled', true);
                $('#txtUnitofMeasurement').prop('disabled', true);
                $('#txtMaterial').prop('disabled', true);
                $('#txtStatus').prop('disabled', true);
                $('#txtEffectiveDate').prop('disabled', true);
                $('#txtSize').prop('disabled', true);
                $('#txtColor').prop('disabled', true);
                $('#txtStandard').prop('disabled', true);
                $('#txtIdentificationMark').prop('disabled', true);
                $('#txtLinenPrice').prop('disabled', true);
                
                $('.BtnSaveandAddNew').show();
                $('.Save').show();
                $('.btnDelete').hide();
            }
            $(".content").scrollTop(0);
            showMessage('LinenItemDetails', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('.Save').attr('disabled', false);
            if (CurrentbtnID == "1") {
                EmptyFields();
            }
            $('.btnDelete').hide();
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
                $('#errorMsg').css('visibility', 'visible');

                $('.Save').attr('disabled', false);
               
                $('#myPleaseWait').modal('hide');
            });
    });


    $(".Cancel").click(function () {
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


function FetchLinenCode(event, index) {
    $('#divLinenCodeFetch_' + index).css({
        'top': $('#txtLinenCode_' + index).offset().top - $('#FrmUser').offset().top + $('#txtLinenCode_' + index).innerHeight(),
    });
    var LinenFetchObj = {
        SearchColumn: 'txtLinenCode_' + index + '-LinenCode',//Id of Fetch field
        ResultColumns: ["LinenItemId-Primary Key", 'LinenCode' + '-txtLinenCode_' + index],
        FieldsToBeFilled: ["LinenCodeId_" + index + "-LinenItemId", 'txtLinenCode_' + index + '-LinenCode', 'txtLinenDescription_' + index + '-LinenDescription']
    };

    DisplayFetchResult('divLinenCodeFetch_' + index, LinenFetchObj, "/api/Fetch/Cleanlinenrequestlinenitem_LinenCodeFetch", "UlFetch4", event, 1);//1 -- pageIndex
}

function LinkClicked(LinenItemId) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#FrmUser :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(LinenItemId);
    var hasBtnSaveandAddNewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='BtnSaveandAddNew'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasBtnSaveandAddNewPermission) {
        action = "BtnSaveandAddNew"

    }
    else if (!hasBtnSaveandAddNewPermission && hasViewPermission) {
        action = "View"
    }
    if (action == "BtnSaveandAddNew" && hasDeletePermission) {
        $('.btnDelete').hide();
    }

    if (action == 'View') {
        $("#FrmUser :input:not(:button)").prop("disabled", true);
    } else {
        $('.save').show();
        $('.BtnSaveandAddNew').hide();
        ////$('.SaveandAddNew').hide();
        //$('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/LinenItemDetails/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                $('#txtLinenCode').val(getResult.LinenCode).attr('disabled', true);
                $('#txtLinenDescription').val(getResult.LinenDescription);
                $('#txtSize').val(getResult.Size);
                $('#txtUnitofMeasurement').val(getResult.UOM);
                $('#txtMaterial').val(getResult.Material);
                $('#SelStatus option[value="' + getResult.Status + '"]').prop('selected', true);
                $('#txtEffectiveDate').val(moment(getResult.EffectiveDate).format("DD-MMM-YYYY"));
                $('#txtColor').val(getResult.Colour);
                $('#txtStandard').val(getResult.Standard);
                $('#txtIdentificationMark').val(getResult.IdentificationMark);
                $('#primaryID').val(getResult.LinenItemId);
                $('#hdnAttachId').val(getResult.HiddenId);
                $('#myPleaseWait').modal('hide');
                $('#txtStatus').val(getResult.Status);
                $('#hdnAttachId').val(getResult.HiddenId);
                $('#txtLinenPrice').val(getResult.LinenPrice);
                if (getResult.Status) {
                    $('#txtStatus').val(1);
                    //$("#ActiveToDate").prop('disabled', true);
                    ////$("#stopdatelabelid").html('Stop Service Date <span class="red">&nbsp;*</span>');
                }
                else {
                    $('#txtStatus').val(0);
                    //$("#ActiveToDate").prop('disabled', false);
                    //$("#stopdatelabelid").html('Stop Service Date <span class="red">&nbsp;*</span>');
                }
                $('#BtnSaveandAddNew').hide();
                $('.Save').show();
                $('.btnDelete').hide();
            })
            .fail(function () {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');
            });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}

$(".btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/LinenItemDetails/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('LinenItemDetails', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('LinenItemDetails', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }
    });
}

function EmptyFields() {
    $(".content").scrollTop(0);
    $('#hdnAttachId').val('');
    $('.btnDelete').hide();
    $('#txtLinenCode').val(' ').prop('disabled', false);
    $('#txtLinenDescription').val(' ').prop('disabled', false);
    $('#txtUnitofMeasurement').val('null').prop('disabled', false);
    $('#txtMaterial').val('null').prop('disabled', false);
    $('#SelStatus').val(1);
    $('#txtEffectiveDate').val(' ').prop('disabled', false);
    $('#txtSize').val('').prop('disabled', false);
    $('#txtColor').val('null').prop('disabled', false);
    $('#txtStandard').val('null').prop('disabled', false);
    $('#txtIdentificationMark').val(' ').prop('disabled', false);
    $('#primaryID').val('');
    $("#grid").trigger('reloadGrid');
    $("#FrmUser :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
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