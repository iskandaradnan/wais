
$('#liHistory').unbind('click');
$('#liHistory').click(function () {

    $('#errorMsgHistory').css('visibility', 'hidden');

    $('#txtCARNumberHistory').val($('#txtCARNumber').val());
    $('#selQAPIndicatorIdHistory').val($('#selQAPIndicatorId').val());
    $('#txtCARDateHistory').val($('#txtCARDate').val());
    $('#txtFailureSymptomCodeHistory').val($('#txtFailureSymptomCode').val());
    
        var primaryId = $('#primaryID').val();
        if (primaryId == 0) {
            bootbox.alert("CAR details must be saved before entering additional information");
            return false;
        } else if ($('#hdnIsAutoCarEdit').val() == 'true') {
            bootbox.alert("CAR details must be saved before entering additional information");
            return false;
        }
       
        $('#myPleaseWait').modal('show');
        $.get("/api/correctiveActionReport/GetCARHistoryDetails/" + primaryId )
              .done(function (response) {
                  var result = JSON.parse(response);
            
            $('#tableHistory > tbody').children('tr').remove();

            var tableRow = '';
            if (result != null && result.historyDetails != null) {
                $.each(result.historyDetails, function (index, value) {
                    var workOrderDate = value.WorkOrderDate == '' ? null : moment(value.WorkOrderDate).format("DD-MMM-YYYY");
                    tableRow += '<tr>' +
                                  '<td width="10%">' +
                                  '<input type="text" class="form-control" id="txtCARStatus_' + index + '"  value="' + value.StatusValue + '" disabled/></td>' +
                                  '<td width="30%"><input type="text" class="form-control" id="txtRootCause_' + index + '" value="' + value.RootCause + '" disabled /></td>' +
                                  '<td width="15%"><input type="text" class="form-control" id="txtSolution_' + index + '" value="' + value.Solution + '" disabled /></td>' +
                                  '<td width="15%"><input type="text" class="form-control" id="txtRemarks_' + index + '" value="' + value.Remarks + '" disabled/></td>' +
                                  '<td width="15%"><input type="text" class="form-control" id="txtLastModifiedBy_' + index + '" value="' + value.LastModifiedBy + '" disabled/></td>' +
                                  '<td width="15%"><input type="text" class="form-control" id="txtLastModifiedDate_' + index + '" value="' + DateFormatter(value.LastModifiedDate) + '" disabled/></td>' +
                              '</tr>';
                });
            }
            if (tableRow == '') {
                tableRow = ' <tr id="NoRecordsDiv">'+
                                    '<td colspan="4" width="100%" data-original-title="" title="">' + 
                                        '<h5 class="text-center">' +
                                            '<span style="color:black;" href="#">No Records to Display</span>' +
                                        '</h5>' +
                                    '</td>' +
                                '</tr>';
            }
           
            $('#tableHistory > tbody').append(tableRow);
            
            $('#myPleaseWait').modal('hide');
        })
     .fail(function (response) {
       
         $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
         $('#errorMsgHistory').css('visibility', 'visible');

         $('#myPleaseWait').modal('hide');
     });
});

$("#btnHistoryCancel").click(function () {
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
