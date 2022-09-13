
$(document).ready(function () {

    $("#btnSave, #btnSaveandAddNew").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');

        var isFormValid = formInputValidation("formIndicatorMaster", 'save');
        if (!isFormValid) {

            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }
        var primaryId = 0;
        if ($("#primaryID").val() != null) {
            primaryId = $("#primaryID").val();
        }
        var Obj = {
            IndicatorMsterId: primaryId,
            CustomerId: $('#selCustomerLayout').val(),
            FacilityId: $('#selFacilityLayout').val(),
            IndicatorNo: $('#txtIndicatorNo').val(),
            IndicatorName: $('#txtIndicatorName').val(),
            IndicatorStandard: $('#txtIndicatorStandard').val(),

        };
        $.post("/Api/IndicatorMasterHWMS/Save", Obj, function (response) {

            var result = JSON.parse(response);
            $("#primaryID").val(result.IndicatorMasterId);  
            showMessage('Indicator Master', CURD_MESSAGE_STATUS.SS);
            $("#grid").trigger('reloadGrid');
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
});

function LinkClicked(id) {

    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formBemsBlock :input:not(:button)").parent().removeClass('has-error');
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
        $("#formBemsBlock :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/IndicatorMasterHWMS/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);

                $('#primaryID').val(getResult.IndicatorMsterId);
                $('#txtIndicatorNo').val(getResult.IndicatorNo);
                $('#txtIndicatorName').val(getResult.IndicatorName);

                var IndicatorSd = getResult.IndicatorStandard;
                if (IndicatorSd != "") {
                    $('#txtIndicatorStandard').prop("disabled", false);
                    $('#txtIndicatorStandard').val(IndicatorSd);
                    $('#txtIndicatorName').prop("disabled", false);
                }
                else {
                    $('#txtIndicatorStandard').prop("disabled", true);
                    $('#txtIndicatorName').prop("disabled", true);
                }



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

function EmptyFields() {

    $('#formIndicatorMaster')[0].reset();
    $('#txtIndicatorStandard').prop("disabled", true);
    $('#txtIndicatorName').prop("disabled", true);
    //$('#indicatorno').removeClass('has-error');
    //$('#Standard').removeClass('has-error');
    //$('#errorMsg').css('visibility', 'hidden');
}


