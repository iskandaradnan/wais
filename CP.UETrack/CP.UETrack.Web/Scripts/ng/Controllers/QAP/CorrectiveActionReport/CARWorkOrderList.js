
$('#liWorkOrderList').unbind('click');
$('#liWorkOrderList').click(function () {

    $('#errorMsgWorkOrderList').css('visibility', 'hidden');

    $('#txtCARNumber1').val($('#txtCARNumber').val());
    $('#selQAPIndicatorId2').val($('#selQAPIndicatorId').val());
    $('#txtCARDate1').val($('#txtCARDate').val());
    $('#txtFailureSymptomCode1').val($('#txtFailureSymptomCode').val());
    
        var primaryId = $('#primaryID').val();
        if (primaryId == 0) {
            bootbox.alert("CAR details must be saved before entering additional information");
            return false;
        } else if ($('#hdnIsAutoCarEdit').val() == 'true') {
            bootbox.alert("CAR details must be saved before entering additional information");
            return false;
        }
       
        $('#myPleaseWait').modal('show');
        $.get("/api/correctiveActionReport/GetWorkOrderDetails/" + primaryId )
              .done(function (response) {
                  var result = JSON.parse(response);
            
            $('#tableWorkOrderList > tbody').children('tr').remove();

            var tableRow = '';
            if (result != null && result.workOrderDetails != null) {

                var failureSymptomCodeOptions = '';
                $.each(FailureSymptomCodeLovs, function (index, value) {
                    failureSymptomCodeOptions += '<option value="' + value.LovId + '">' + value.FieldValue + '</option>';
                });

                var allFailureSymptomCodesDisabled = true;
                var allRootCausesDisabled = true;

                $.each(result.workOrderDetails, function (index, value) {
                    var failureSymptomCodeDisabled = '';
                    var rootCauseDisabled = '';

                    if (value.FailureSymptomId != null) {
                        failureSymptomCodeDisabled = 'disabled';
                    } else {
                        allFailureSymptomCodesDisabled = false;
                    }

                    var rootCauseOptions = '';
                    if (value.rootCausesList != null && value.rootCausesList.rootCauses != null) {
                        $.each(value.rootCausesList.rootCauses, function (index, value) {
                            rootCauseOptions += '<option value="' + value.RootCauseId + '">' + value.RootCauseDescription + '</option>';
                        });
                    }

                    if (value.RootCauseId != null && rootCauseOptions != '') {
                        rootCauseDisabled = 'disabled';
                    } else {
                        allRootCausesDisabled = false;
                    }

                    var workOrderDate = value.WorkOrderDate == '' ? null : moment(value.WorkOrderDate).format("DD-MMM-YYYY");
                    tableRow += '<tr>' +
                                  '<td width="20%">' +
                                  '<input type="hidden" id="hdnAdditionalInfoId_' + index + '" value="' + value.AdditionalInfoId + '"/>' +
                                  '<input type="hidden" id="hdnWorkOrderId_' + index + '" value="' + value.WorkOrderId + '"/>' +
                                  '<input type="text" onclick="RedirectToWorkOrder(' + value.WorkOrderId + ', ' + value.CategoryId + ')" class="form-control" style="color:#477ca9; cursor: pointer" title="' + value.MaintenanceWorkNo + '" id="txtCARWLWorkOrderNo_' + index + '"  value="' + value.MaintenanceWorkNo + '" readonly/></td>' +
                                  '<td width="20%"><input type="text" class="form-control" id="txtCARWLWorkOrderDate_' + index + '" value="' + workOrderDate + '" disabled /></td>' +
                                  '<td width="20%"><input type="text" class="form-control" id="txtCARWLWorkOrderAssetNo_' + index + '" value="' + value.AssetNo + '" disabled /></td>' +
                                  '<td width="20%"><select ' + failureSymptomCodeDisabled + ' class="form-control" id="selFailureSymptomCode_' + index + '" required><option value="null">Select</option>' + failureSymptomCodeOptions + '</select></td>' +
                                  '<td width="20%"><select ' + rootCauseDisabled + ' class="form-control" id="selRootCause_' + index + '" required><option value="null">Select</option>' + rootCauseOptions + '</select></td>' +
                              '</tr>';
                });
                if (allFailureSymptomCodesDisabled && allRootCausesDisabled) {
                    $('#btnWorkOrderListSave').hide();
                } else {
                    $('#btnWorkOrderListSave').show();
                }
            }
            if (tableRow == '') {
                tableRow = ' <tr id="NoRecordsDiv">'+
                                    '<td colspan="4" width="100%" data-original-title="" title="">' + 
                                        '<h5 class="text-center">' +
                                            '<span style="color:black;" href="#">No Records to Display</span>' +
                                        '</h5>' +
                                    '</td>' +
                                '</tr>';
                $('#btnWorkOrderListSave').hide();
            }
           
            $('#tableWorkOrderList > tbody').append(tableRow);

            if (result != null && result.workOrderDetails != null) {
                $.each(result.workOrderDetails, function (index1, value1) {
                    $('#selFailureSymptomCode_' + index1).val(value1.FailureSymptomId == null ? 'null' : value1.FailureSymptomId);
                    $('#selRootCause_' + index1).val(value1.RootCauseId == null || value1.rootCausesList == null || value1.rootCausesList.rootCauses == null ? 'null' : value1.RootCauseId);
                });
            }

            
            tableInputValidation('tableWorkOrderList');
            BindEventsForFailureSymptomeCode();

            var carStatus = $('#hdnCARStatus').val();
            if (carStatus == 369) {
                $('#btnWorkOrderListSave').hide();
                $("[id^='selFailureSymptomCode_']").attr('disabled', true);
                $("[id^='selRootCause_']").attr('disabled', true);
            }

            $('#myPleaseWait').modal('hide');
        })
     .fail(function (response) {
       
         $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
         $('#errorMsgWorkOrderList').css('visibility', 'visible');

         $('#myPleaseWait').modal('hide');
     });
});

function BindEventsForFailureSymptomeCode() {
    $("[id^='selFailureSymptomCode_']").on('change', function () {

        var id = $(this).attr('id');
        var index = id.substring(id.indexOf('_') + 1);
        $('#selRootCause_' + index).children('option:not(:first)').remove();

        var failureSymptomId = $('#selFailureSymptomCode_' + index).val();
        if (failureSymptomId == 'null') {
            return false;
        }
        $('#myPleaseWait').modal('show');
        $.get("/api/correctiveActionReport/GetRootCauses/" + failureSymptomId)
              .done(function (response) {
                  var result = JSON.parse(response);
                  var rootCauseOptions = '';
                  if (result != null && result.rootCauses != null) {
                      $.each(result.rootCauses, function (index1, value1) {
                          $('#selRootCause_' + index).append('<option value="' + value1.RootCauseId + '">' + value1.RootCauseDescription + '</option>');
                      });
                  }

                  $('#selRootCause_' + index).attr('disabled', false);
                  $('#myPleaseWait').modal('hide');
              })
     .fail(function (response) {
         $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
         $('#errorMsgWorkOrderList').css('visibility', 'visible');
         $('#myPleaseWait').modal('hide');
     });
 });
}
$("#btnWorkOrderListSave").click(function () {
    $('#btnWorkOrderListSave').attr('disabled', true);
    
    $("div.errormsgcenter").text('');
    $('#errorMsgWorkOrderList').css('visibility', 'hidden');

    var isFormValid = tableInputValidation('tableWorkOrderList', 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsgWorkOrderList').css('visibility', 'visible');

        $('#btnWorkOrderListSave').attr('disabled', false);
        return false;
    }

    $('#myPleaseWait').modal('show');
    var saveObj = {};
    var WorkOrderDetails = [];

    $('#tableWorkOrderList tr').each(function (index, value) {
        if (index == 0) return;
        var index1 = index - 1;

        WorkOrderDetails.push({
            AdditionalInfoId: $('#hdnAdditionalInfoId_' + index1).val(),
            WorkOrderId: $('#hdnWorkOrderId_' + index1).val(),
            FailureSymptomId : $('#selFailureSymptomCode_' + index1).val(),
            RootCauseId: $('#selRootCause_' + index1).val()
        });
    });
    saveObj.workOrderDetails = WorkOrderDetails;

    var jqxhr = $.post("/api/correctiveActionReport/SaveWorkOrderDetails", saveObj, function (response) {
        var result = JSON.parse(response);
        $('#btnWorkOrderListSave').hide();

        $('#tableWorkOrderList tr').each(function (index, value) {
            if (index == 0) return;
            var index1 = index - 1;

            $('#selFailureSymptomCode_' + index1).attr('disabled', true);
            $('#selRootCause_' + index1).attr('disabled', true);
        });
        $(".content").scrollTop(0);
        showMessage('', CURD_MESSAGE_STATUS.SS);
        $('#btnWorkOrderListSave').attr('disabled', false);
        
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
    $("div.errormsgcenter").text(errorMessage);
    $('#errorMsgWorkOrderList').css('visibility', 'visible');

    $('#btnWorkOrderListSave').attr('disabled', false);
    
    $('#myPleaseWait').modal('hide');
});
});

$("#btnWorkOrderListCancel").click(function () {
    var message = Messages.Reset_TabAlert_CONFIRMATION;
    bootbox.confirm(message, function (result) {
        if (result) {
            ClearFields();
        }
        else {
            $('#myPleaseWait').modal('hide');
        }
    });
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