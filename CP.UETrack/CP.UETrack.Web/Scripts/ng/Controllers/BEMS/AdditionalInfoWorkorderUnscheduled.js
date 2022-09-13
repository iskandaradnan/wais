var WorkOrderStatusString = 0;


$('#liAFAdditionalInfo').click(function () {

    var primaryId = $('#primaryID').val();
    if (primaryId == 0 || primaryId == undefined) {
        bootbox.alert("Unscheduled Work Order must be Saved before entering additional information");
        return false;
    }

    $("div.errormsgcenter").text("");
    $('#errorMsgAdditionalInfoTab').css('visibility', 'hidden');

    if (WorkOrderStatusString == "Closed") {
        $("#btnAdditionalInfoEdit").hide();
        $("#Field1").prop('disabled', true);
        $("#Field2").prop('disabled', true);

    }
    else {
        $("#btnAdditionalInfoEdit").show();
    }

    //formInputValidation("frmAdditionalInfo");
    $.get("/api/additionalFields/LoadAdditionalInfo/" + 337)
     .done(function (result) {
         var loadResult = JSON.parse(result);
         CreateAdditionalControls(loadResult.additionalFields);
         //$("#jQGridCollapse1").click();
         var primaryId = $('#primaryID').val();
         if (primaryId != null && primaryId != "0") {
             $.get("/api/additionalFields/GetAdditionalInfoForWorkorder/" + primaryId)
               .done(function (result1) {
                   var result = JSON.parse(result1);
                   if (result.Field1 != null)
                       $('#Field1').val(result.Field1);
                   if (result.Field2 != null)
                       $('#Field2').val(result.Field2);
                   if (result.Field3 != null)
                       $('#Field3').val(result.Field3);
                   if (result.Field4 != null)
                       $('#Field4').val(result.Field4);
                   if (result.Field5 != null)
                       $('#Field5').val(result.Field5);
                   if (result.Field6 != null)
                       $('#Field6').val(result.Field6);
                   if (result.Field7 != null)
                       $('#Field7').val(result.Field7);
                   if (result.Field8 != null)
                       $('#Field8').val(result.Field8);
                   if (result.Field9 != null)
                       $('#Field9').val(result.Field9);
                   if (result.Field10 != null)
                       $('#Field10').val(result.Field10);

                   var status = $('#divWOStatus').text();
                   if (status == 'Completed' && IsExternal) {
                       $("#frmAdditionalInfo :input:not(:button)").prop("disabled", true);
                       $('#btnAdditionalInfoEdit').hide();
                   } else {
                       $('#btnAdditionalInfoEdit').show();
                   }

                   if (WorkOrderStatusString == "Closed") {
                       $("#btnAdditionalInfoEdit").hide();
                       $("#Field1").prop('disabled', true);
                       $("#Field2").prop('disabled', true);

                   }
                   else {
                       $("#btnAdditionalInfoEdit").show();
                       
                   }

                   $('#myPleaseWait').modal('hide');
               })
              .fail(function (response) {
                  $('#myPleaseWait').modal('hide');
                  $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                  $('#errorMsgAdditionalInfoTab').css('visibility', 'visible');
              });
         }
         else {
             $('#myPleaseWait').modal('hide');
         }
     })
   .fail(function (response) {
       $('#myPleaseWait').modal('hide');
       $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
       $('#errorMsgAdditionalInfoTab').css('visibility', 'visible');
   });

    
});

function CreateAdditionalControls(result) {
    var textboxString = '<input type="text" id="FieldName" class="form-control textRight" pattern="patternString" maxlength="maxLen" required/>';
    //var textboxNumericString = '<input type="text" id="FieldName" class="form-control text-right" pattern="patternString" maxlength="maxLen" required/>';
    var selectString = '<select class="form-control" id="FieldName" required><option value="null">Select</option>DropdownValues</select>';
    var str = '';
    $.each(result, function (index, value) {
        var controlString = '';
        var requierdString = '';
        if (value.FieldTypeLovId == 325) {//Textbox
            controlString = textboxString;
        }
            //else if (value.FieldTypeLovId == 325) {//Numeric Textbox
            //    controlString = textboxNumericString;
            //}
        else if (value.FieldTypeLovId == 324) {//Dropdown
            controlString = selectString;
        }

        if (index % 2 == 0) {
            str += '<div class="row">';
        }
        var textRight = '';
        if (value.FieldTypeLovId != 324) {
            if (value.PatternLovId == 328) {
                textRight = 'text-right';
            }
            controlString = controlString.replace('textRight', textRight);
        }
        if (value.FieldTypeLovId != 324 && value.PatternValue != null && value.PatternValue != '') {
            controlString = controlString.replace('patternString', value.PatternValue);
        }
        controlString = controlString.replace('FieldName', value.FieldName);
        if (value.RequiredLovId == 100) {
            controlString = controlString.replace('required', '');
        }
        else {
            requierdString = '<span class="red"> *</span>';
        }
        if (value.FieldTypeLovId != 324) {
            controlString = controlString.replace('maxLen', value.MaxLength);
        }
        if (value.FieldTypeLovId == 324) {
            var dropdownValues = value.DropDownValues.split(',');
            var dropdownString = '';
            $.each(dropdownValues, function (index, value) {
                dropdownString += '<option value="' + value + '">' + value + '</option>'
            });
            controlString = controlString.replace('DropdownValues', dropdownString);
        }
        var labelName = value.Name;

        str += '<div class="col-sm-6">' +
                        '<div class="form-group">' +
                            '<label class="col-sm-6 control-label">' + labelName + '' + requierdString + '</label>' +
                            '<div class="col-sm-6">' +
                                '<div>' +
                                    controlString +
                                '</div>' +
                            '</div>' +
                   '</div>' +
               '</div>';

        if (index % 2 == 1) {
            str += '</div>';
        }
    });
    //if (result.length % 2 == 1) {
    //    str += '</div>';
    //}
    //var test = str;
    //debugger;
    $('#divAdditionalFieldsContainer').html(str);
    formInputValidation("frmAdditionalInfo");
}

$('#btnAdditionalInfoEdit').click(function () {

    $("div.errormsgcenter").text("");
    $('#errorMsgAdditionalInfoTab').css('visibility', 'hidden');
    $('#btnAdditionalInfoEdit').attr('disabled', true);

    var isFormValid = formInputValidation("frmAdditionalInfo", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsgAdditionalInfoTab').css('visibility', 'visible');

        $('#btnAdditionalInfoEdit').attr('disabled', false);
        return false;
    }

    $('#myPleaseWait').modal('show');

    var saveObj = {
        WorkOrderId: $('#primaryID').val(),
        Field1: $('#Field1').val(),
        Field2: $('#Field2').val(),
        Field3: $('#Field3').val(),
        Field4: $('#Field4').val(),
        Field5: $('#Field5').val(),
        Field6: $('#Field6').val(),
        Field7: $('#Field7').val(),
        Field8: $('#Field8').val(),
        Field9: $('#Field9').val(),
        Field10: $('#Field10').val()
    };

    var jqxhr = $.post("/api/additionalFields/SaveAdditionalInfoWorkorder", saveObj, function (response) {
        var result = JSON.parse(response);

        $('#btnAdditionalInfoEdit').attr('disabled', false);
        $(".content").scrollTop(0);
        showMessage('Additional Info', CURD_MESSAGE_STATUS.SS);
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
    $('#errorMsgAdditionalInfoTab').css('visibility', 'visible');
    $('#btnAdditionalInfoEdit').attr('disabled', false);
    $('#myPleaseWait').modal('hide');
});
});

$("#btnAdditionalInfoCancel").click(function () {
    window.location.replace("/bems/unscheduledworkorder");
});
