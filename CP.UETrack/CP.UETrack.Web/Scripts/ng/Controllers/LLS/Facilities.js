$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    formInputValidation("formFacilities");
    $('.btnDelete').hide();
    var fcc = $("#FETCId").val();
    $('#txtEffectiveTo').val('').prop('disabled', true);
    $.get("/api/Facilities/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#jQGridCollapse1").click();
            $.each(loadResult.ItemType, function (index, value) {
                if (value.FieldValue != 'ItemTypeValues') {
                    $('#txtItemType').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                }
            });
           
        })

        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });
});
$("#btnSave, #btnEdit,#btnSaveandAddNew").click(function () {
    $('#btnlogin').attr('disabled', true);
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#myPleaseWait').modal('hide');
    $('#txtItemCode').attr('required', true);
    $('#txtItemDescription').attr('required', true);
    $('#txtItemType').attr('required', true);
    $('#SelStatus').attr('required', true);
    $('#txtEffectiveFrom').attr('required', true);
   
        var CurrentbtnID = $(this).attr("Id");
        var timeStamp = $("#Timestamp").val();

        var isFormValid = formInputValidation("formFacilities", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }
        var MstFacilities = {
            ItemCode: $('#txtItemCode').val(),
            ItemDescription: $('#txtItemDescription').val(),
            ItemType: $('#txtItemType').val(),
            Status: $('#SelStatus').val(),
            EffectiveFromDate: $('#txtEffectiveFrom').val(),
            EffectiveToDate: $('#txtEffectiveTo').val(),
        };

        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            MstFacilities.FETCId = primaryId;
            MstFacilities.Timestamp = timeStamp;
        }
        else {
            MstFacilities.FETCId = 0;
            MstFacilities.Timestamp = "";
        }

        var jqxhr = $.post("/api/Facilities/Save", MstFacilities, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.FETCId);
            $("#Timestamp").val(result.Timestamp);
            $("#grid").trigger('reloadGrid');
            if (result.FETCId != 0) {
                $('#hdnAttachId').val(result.HiddenId);
                $('#txtItemCode').prop('disabled', true);
                $('#btnEdit').show();
                $('#btnSave').hide();
                $('.btnDelete').hide();
            }
            $(".content").scrollTop(0);
            showMessage('FETC', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);
            $('#btnSave').attr('disabled', false);
            if (CurrentbtnID == "btnSaveandAddNew") {
                EmptyFields();
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
                    errorMessage = Messages.COMMON_FAILURE_MESSAGE;
                }
                $("div.errormsgcenter").text(errorMessage);
                $('#errorMsg').css('visibility', 'visible');
                $('#btnSave').attr('disabled', false);
                if (CurrentbtnID == "btnSaveandAddNew") {
                    EmptyFields();
                }
                $('#myPleaseWait').modal('hide');
               
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

function LinkClicked(FETCId) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formFacilities :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(FETCId);
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
        $('.btnDelete').hide();
    }

    if (action == 'View') {
        $("#formFacilities :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        $('#spnActionType').text(action);

        var primaryId = $('#primaryID').val();
        if (primaryId != null && primaryId != "0") {
            $.get("/api/Facilities/Get/" + primaryId)
                .done(function (result) {
                    var getResult = JSON.parse(result);
                    $('#txtItemCode').val(getResult.ItemCode).attr('disabled', true);
                    $('#txtItemDescription').val(getResult.ItemDescription);
                    $('#txtItemType').val(getResult.ItemType);
                    $('#txtEffectiveFrom').val(moment(getResult.EffectiveFromDate).format("DD-MMM-YYYY"));
                    $('#txtEffectiveTo').val(moment(getResult.EffectiveToDate).format("DD-MMM-YYYY")).prop("disabled", true);
                    $('#SelStatus option[value="' + getResult.Statuss + '"]').prop('selected', true);
                    $('#hdnAttachId').val(getResult.HiddenId);
                    $('#btnSaveandAddNew').hide();
                    $('#btnEdit').show();
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
            $.get("/api/Facilities/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('LaundryPlant', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('Facilities', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}

function EmptyFields() {
    $(".content").scrollTop(0);
    $('#hdnAttachId').val('');
    $('.btnDelete').hide();
    $('#txtItemCode').val('').prop('disabled', false);
    $('#txtItemDescription').val('').prop('disabled', false);
    $('#txtItemType').val('null').prop('disabled', false);
    $('#txtEffectiveFrom').val('').prop('disabled', false);
    $('#txtEffectiveTo').val('').prop('disabled', false);
    $('#SelStatus').val(1).prop('disabled', false);
    $('#primaryID').val('');
    $("#grid").trigger('reloadGrid');
    $("#formFacilities :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
}

    $("#jQGridCollapse1").click(function () {
        var pro = new Promise(function (res, err) {
            $(".jqContainer").toggleClass("hide_container");
            res(1);
        })
        pro.then(
            function resposes() {
                setTimeout(() => $(".content").scrollTop(3000), 1);
            })
    })