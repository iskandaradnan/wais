$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    var primaryId = $('#primaryID').val();
    var ActionType = $('#ActionType').val();
    formInputValidation("QAPIndicatorMasterForm");
    $("#qapIndicatorStandard").prop("disabled", true);
    $('#btnQapIndicatorEdit').hide();
    $('#btnCancel').hide();
    //******************************** Load DropDown ***************************************

    $.get("/api/QAPIndicatorMaster/Load")
   .done(function (result) {
       var loadResult = JSON.parse(result);
       $("#jQGridCollapse1").click();
       $.each(loadResult.IndicatorServiceTypeData, function (index, value) {
           $('#qapIndicatorService').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
       });       

       //var primaryId = $('#primaryID').val();
       //if (primaryId != null && primaryId != "0") {
       //    getById(primaryId)
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


    ////************************************** GetById ****************************************

    //function getById(primaryId) {
    //    $.get("/api/QAPIndicatorMaster/get/" + primaryId)
    //            .done(function (result) {
    //                var result = JSON.parse(result);

    //                if (ActionType == "View") {
    //                    $('#qapIndicatorStandard').val(result.IndicatorStandard).prop("disabled", "disabled");
    //                }

    //                $('#primaryID').val(result.QAPIndicatorId);
    //                $('#qapIndicatorService' + ' option[value="' + result.ServiceId + '"]').prop('selected', true);
    //                $('#qapIndicatorService').prop("disabled", "disabled");                    
    //                $('#qapIndicatorCode').val(result.IndicatorCode);
    //                $('#qapIndicatorName').val(result.IndicatorDescription);
    //                $('#qapIndicatorStandard').val(result.IndicatorStandard);
    //                $('#Timestamp').val(result.Timestamp);
    //                $('#myPleaseWait').modal('hide');


    //            })
    //            .fail(function () {
    //                $('#myPleaseWait').modal('hide');
    //                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
    //                $('#errorMsg').css('visibility', 'visible');
    //            });
    //}


    //****************************************** Save *********************************************

    $("#btnQapIndicatorSave, #btnQapIndicatorEdit").click(function () {
        $('#btnQapIndicatorSave').attr('disabled', true);
        $('#btnQapIndicatorEdit').attr('disabled', true);
        $('#myPleaseWait').modal('show');

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');     

        var primaryId = $('#primaryID').val();
        var Timestamp= $("#Timestamp").val();
        if (primaryId != null) {
            QAPIndicatorId = primaryId;
            Timestamp = Timestamp;
        }
        else {
            QAPIndicatorId = 0;
            Timestamp = "";
        }

        var obj = {

            QAPIndicatorId: primaryId,
            ServiceId: $('#qapIndicatorService').val(),
            IndicatorCode: $('#qapIndicatorCode').val(),
            IndicatorDescription: $("#qapIndicatorName").val(),
            IndicatorStandard: $("#qapIndicatorStandard").val(),
            Timestamp: Timestamp,
        }
        var isFormValid = formInputValidation("QAPIndicatorMasterForm", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnQapIndicatorSave').attr('disabled', false);
            $('#btnQapIndicatorEdit').attr('disabled', false);
            return false;
        }

        var jqxhr = $.post("/api/QAPIndicatorMaster/Save", obj, function (response) {
            var result = JSON.parse(response);            
            $("#primaryID").val(result.QAPIndicatorId);
            $("#Timestamp").val(result.Timestamp);            
            $('#qapIndicatorStandard').val(result.IndicatorStandard);
            $(".content").scrollTop(0);
            showMessage('QAPIndicator Master', CURD_MESSAGE_STATUS.SS);
            $("#grid").trigger('reloadGrid');
            if (result.QAPIndicatorId != 0) {
                $('#LevelCode').prop('disabled', true);               
            }
            //$("#top-notifications").modal('show');
            //setTimeout(function () {
            //    $("#top-notifications").modal('hide');
            //}, 5000);

            $('#btnQapIndicatorSave').attr('disabled', false);
            $('#btnQapIndicatorEdit').attr('disabled', false);
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
            $("div.errormsgcenter").text(errorMessage).css('visibility', 'visible');
            $('#errorMsg').css('visibility', 'visible');

            $('#btnQapIndicatorSave').attr('disabled', false);
            $('#btnQapIndicatorEdit').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
    });

    //******************** Back****************

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



//********************************* Validation *********************************************
function LinkClicked(id) {
    $(".content").scrollTop(1);
    $("#QAPIndicatorMasterForm :input:not(:button)").parent().removeClass('has-error');
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
        $("#QAPIndicatorMasterForm :input:not(:button)").prop("disabled", true);
        $('#btnCancel').show();
    } else {
        $('#btnQapIndicatorEdit').show();
        $('#btnCancel').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        //$('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        getById(primaryId)
    }
    else {
        $('#myPleaseWait').modal('hide');

    }
   
}
function EmptyFields() {
    $(".content").scrollTop(0);
    $('input[type="text"], textarea').val('');    
    $('#LevelCode').prop('disabled', false);
    $('#btnQapIndicatorEdit').hide();
    $('#btnCancel').hide();    
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#grid").trigger('reloadGrid');
    $("#QAPIndicatorMasterForm :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#qapIndicatorStandard').prop("disabled", "disabled");
}

//************************************** GetById ****************************************

function getById(primaryId) {
    $.get("/api/QAPIndicatorMaster/get/" + primaryId)
            .done(function (result) {
                var result = JSON.parse(result);
                
                if (ActionType == "View") {
                    $('#qapIndicatorStandard').val(result.IndicatorStandard).prop("disabled", "disabled");
                } else {
                    $("#qapIndicatorStandard").prop("disabled", false);
                }

                $('#primaryID').val(result.QAPIndicatorId);
                $('#qapIndicatorService' + ' option[value="' + result.ServiceId + '"]').prop('selected', true);
                $('#qapIndicatorService').prop("disabled", "disabled");
                $('#qapIndicatorCode').val(result.IndicatorCode);
                $('#qapIndicatorName').val(result.IndicatorDescription);
                $('#qapIndicatorStandard').val(result.IndicatorStandard);
                $('#Timestamp').val(result.Timestamp);
                $('#myPleaseWait').modal('hide');


            })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsg').css('visibility', 'visible');
            });
}

// get database based on service 
function ChangeService() { 
    var ServiceId = $('#qapIndicatorService').val();
    $.get("/api/QAPIndicatorMaster/ChangeService/" + ServiceId)
 .done(function (result) {
     debugger;
      $("#grid").trigger('reloadGrid');
     var getResult = JSON.parse(result);
    
 })
 .fail(function (response) {
     $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
     $('#errorMsg').css('visibility', 'visible');
 });
}