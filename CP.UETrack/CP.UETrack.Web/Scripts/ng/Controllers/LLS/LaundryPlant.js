$(document).ready(function () {
    var primaryId = $("#primaryID").val();
    $('#myPleaseWait').modal('show');
    formInputValidation("formplant");
   // $('.btnDelete').hide();
    $('#btnEdit').hide();
    $('.btnDelete').hide();
    $.get("/api/LaundryPlant/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#jQGridCollapse1").click();
            $.each(loadResult.Ownership, function (index, value) {
                $('#txtOwnership').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.Status, function (index, value) {
                if (value.FieldValue == 'Active' || value.FieldValue == 'Inactive')
                    {
                    $('#SelStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                    }
            });
        })

        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });

    $("#btnSave, #btnEdit,#BtnSaveandAddNew").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $('#txtLaundryPlantCode').attr('required', true);
        $('#txtLaundryPlantName').attr('required', true);
        $('#txtOwnership').attr('required', true);
        $('#txtCapacityTonneDay').attr('required', true);
        $('#txtContactPerson').attr('required', true);      
        $('#SelStatus').attr('required', true);
      
        var CurrentbtnID = $(this).attr("Id");
        var timeStamp = $("#Timestamp").val();    
        var isFormValid = formInputValidation("formplant", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }
        
        var MstLaundryPlant = {
            LaundryPlantCode: $('#txtLaundryPlantCode').val(),
            LaundryPlantName: $('#txtLaundryPlantName').val(),
            Ownership: $('#txtOwnership').val(),
            Capacity: $('#txtCapacityTonneDay').val(),
            ContactPerson: $('#txtContactPerson').val(),
            Status: $("#SelStatus option:selected").val()
        };

        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            MstLaundryPlant.LaundryPlantId = primaryId;
            MstLaundryPlant.Timestamp = timeStamp;
        }
        else {
            MstLaundryPlant.LaundryPlantId = 0;
            MstLaundryPlant.Timestamp = "";
        }

        var jqxhr = $.post("/api/LaundryPlant/Save", MstLaundryPlant, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.LaundryPlantId);
            $("#Timestamp").val(result.Timestamp);
            $('#SelStatus option[value="' + result.Status + '"]').prop('selected', true);
            $("#grid").trigger('reloadGrid');
            if (result.LaundryPlantId != 0) {
                $('#hdnAttachId').val(result.HiddenId);
                $('#txtLaundryPlantCode').attr('disabled', true);
                $('#txtLaundryPlantName').attr('disabled', true);
                $('#txtOwnership').attr('disabled', true);
                $('#txtCapacityTonneDay').attr('disabled', true);
                $('#txtContactPerson').attr('disabled', true);
                //$('#SelStatus').attr('required', true);
                $('#btnEdit').hide();
                $('#btnSave').show();
                $('.btnDelete').hide();
            }
            $(".content").scrollTop(0);
            showMessage('LaundryPlant', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#btnSave').attr('disabled', false);
            if (CurrentbtnID == "BtnSaveandAddNew") {
                EmptyFields();
                $('.btnDelete').hide();
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
                    $('#myPleaseWait').modal('hide');
                });
        });

    $("#BtnCancel").click(function () {
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
});


function LinkClicked(LaundryPlantId) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formplant :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');

    var action = "";
    $('#primaryID').val(LaundryPlantId);
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
        $("#formplant :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/LaundryPlant/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                $('#txtLaundryPlantCode').val(getResult.LaundryPlantCode).attr('disabled', true);
                $('#txtLaundryPlantName').val(getResult.LaundryPlantName);
                $('#txtOwnership').val(getResult.Ownerships);
                $('#txtCapacityTonneDay').val(getResult.Capacity);
                $('#txtContactPerson').val(getResult.ContactPerson);
                $('#SelStatus option[value="' + getResult.Statuss + '"]').prop('selected', true);
                $('#BtnSaveandAddNew').hide();
                $('#btnSave').show();
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
            $.get("/api/LaundryPlant/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('LaundryPlant', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('LaundryPlant', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}

function EmptyFields() {
    $(".content").scrollTop(0);
    $('#hdnAttachId').val('');
    $('#btnDelete').hide();
    $('#txtLaundryPlantCode').val('').prop('disabled', false);
    $('#txtLaundryPlantName').val('').prop('disabled', false);
    $('#txtOwnership').val('null').prop('disabled', false);
    $('#txtCapacityTonneDay').val('').prop('disabled', false);
    $('#txtContactPerson').val('').prop('disabled', false);
    $('#SelStatus').val(1);
    $('#primaryID').val('');
    $("#grid").trigger('reloadGrid');
    $("#formplant :input:not(:button)").parent().removeClass('has-error');
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
});