$('#liReportsAndRecords').click(function loadSNFTab() {

    var FieldTypeValues = null;
    var YesNoValues = null;
    var ConfigPatternValues = null;

var primaryId = $('#primaryID').val();
    if (primaryId == 0) {
        bootbox.alert("Customer details must be saved before entering additional information");
        return false;
    }
    else {
        
        //------------------------------------------------------------------------------------------------------------
        $('#errorMsgReportsAndRecords').css('visibility', 'hidden');
        $('#errorMsg').css('visibility', 'hidden');

        $('#chkReportsAndRecordsDeleteAll').prop('checked', false).attr('disabled', false);
        $('#chkReportsAndRecordsDelete_0').parent().removeClass('bgDelete');

        $('#myPleaseWait').modal('show');
        $.get("/api/Customer/GetReportsAndRecords/" + primaryId)
               .done(function (response) {
                   var result = JSON.parse(response);
                   if (result != null && result.ReportsAndRecords != null && result.ReportsAndRecords.length > 0) {
                       $('#tblReportsAndRecords > tbody').children('tr').remove();
                       $.each(result.ReportsAndRecords, function (index1, value1) {
                           var tableRow = ' <tr><td width="3%" style="text-align:center"><input type="checkbox" id="chkReportsAndRecordsDelete_' + index1 + '" /></td>' +
                                   '<td width="97%"><div><input type="hidden" id="hdnCustomerReportId_' + index1 + '" value="" />' +
                                   '<input type="text" id="txtReportName_' + index1 + '" maxlength="100" pattern="^[a-zA-Z0-9\\-\\(\\)\\/\\s]+$" class="form-control" style="max-width:100%" required/></div></td>' +
                                   '</tr>';
                           $('#tblReportsAndRecords > tbody').append(tableRow);
                           $('#hdnCustomerReportId_' + index1).val(value1.CustomerReportId);
                           $('#txtReportName_' + index1).val(value1.ReportName);
                       });

                       BindEvensForCheckBox();
                       formInputValidation('tblReportsAndRecords');
                   }else
                   {
                       $('#tblReportsAndRecords > tbody').children('tr:not(:first)').remove();
                       //$('#chkReportsAndRecordsDeleteAll').prop('checked', false).attr('disabled', false);
                       $('#chkReportsAndRecordsDelete_0').prop('checked', false).attr('disabled', false);
                       //$('#chkReportsAndRecordsDelete_0').parent().removeClass('bgDelete');

                       $('#hdnCustomerReportId_0').val('');
                       $('#txtReportName_0').val(null).attr('disabled', false);
                       $('#txtReportName_0').parent().removeClass('has-error');
                   }

                   //$('#chkReportsAndRecordsDeleteAll').prop('checked', false).attr('disabled', false);
                   //$('#chkReportsAndRecordsDelete_0').parent().removeClass('bgDelete');

                   BindEvensForCheckBox();
                   formInputValidation("frmReportsAndRecords");

                   $('#myPleaseWait').modal('hide');
               })
           .fail(function (response) {
               $('#myPleaseWait').modal('hide');
               $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
               $('#errorMsgReportsAndRecords').css('visibility', 'visible');
           });
//----------------------------------------------------------------------------------------------------------
        
    $("#btnAddEditReportsSave").unbind('click');
    $("#btnAddEditReportsSave").click(function () {
    $('#btnAddEditReportsSave').attr('disabled', true);


    $("div.errormsgcenter").text("");
    $('#errorMsgReportsAndRecords').css('visibility', 'hidden');

    var isFormValid = tableInputValidation('frmReportsAndRecords', 'save', 'chkReportsAndRecordsDelete');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsgReportsAndRecords').css('visibility', 'visible');

        $('#btnAddEditReportsSave').attr('disabled', false);
        return false;
        }

        var allChecked = true
        $("#tblReportsAndRecords tr").each(function (index, value) {
            if (index == 0) return;
            var index1 = index -1;
            if (!$('#chkReportsAndRecordsDelete_' +index1).prop('checked')) {
                allChecked = false;
        }
        });
             if (allChecked) {
                bootbox.alert(Messages.CAN_NOT_DELETE_ALL_RECORDS);
                $('#btnAddEditReportsSave').attr('disabled', false);
                return false;
                }

            var ReportsAndRecordsList = { 
        };
            var reportsAndRecordsList = [];

            //var totalRecords = 0;
            var recordsSelectedForDeletion = false;
            var deletedRowNumber = '';

            $("#tblReportsAndRecords tr").each(function (index, value) {
            if (index == 0) return;
            var index1 = index - 1;

            var isDeleted = $('#chkReportsAndRecordsDelete_' + index1).prop('checked')
            var isDisabled = $('#chkReportsAndRecordsDelete_' + index1).prop('disabled')

            if (isDeleted) {
                deletedRowNumber += index + ',';
            }
            
             
            var customerReportId = $('#hdnCustomerReportId_' + index1).val();
            if (!isDeleted || (isDeleted && (customerReportId != null && customerReportId != '' && customerReportId != 0))) {//if (!isDeleted && !isDisabled) 
            var additionalFieldsObj = {
                CustomerReportId: customerReportId,
                CustomerId: $('#primaryID').val(),
                ReportName : $('#txtReportName_' + index1).val(),
                IsDeleted : isDeleted
            }

             reportsAndRecordsList.push(additionalFieldsObj);
            }
            if (isDeleted) {
                recordsSelectedForDeletion = true;
            }
                ReportsAndRecordsList.ReportsAndRecords = reportsAndRecordsList;
           });

            //if (ReportsAndRecordsList.ReportsAndRecords.length == 0) {

            //    $("div.errormsgcenter").text("There are no records to save");
            //    $('#errorMsgReportsAndRecords').css('visibility', 'visible');

            //    if (deletedRowNumber != '') {
            //        var deletedIndexes = deletedRowNumber.split(',');
            //        $.each(deletedIndexes, function (index4, value4) {
            //            if (value4 != '') {
            //                $('#tblReportsAndRecords tr:nth-child(' + value4 + ')').remove();
            //            }
            //        });
            //    }

            //    $('#btnAddEditReportsSave').attr('disabled', false);
            //    return false;
            //}

            if (recordsSelectedForDeletion) {
                bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (result) {
                    if (result) {
                        SaveAdditionalFields(ReportsAndRecordsList)
                    }
                    else {
                        $('#btnAddEditReportsSave').attr('disabled', false);
                    }
                });
            }
            else {
                SaveAdditionalFields(ReportsAndRecordsList);
            }
});

function SaveAdditionalFields(ReportsAndRecordsList)
{
    $('#myPleaseWait').modal('show');
    var jqxhr = $.post("/api/Customer/SaveReportsAndRecords", ReportsAndRecordsList, function (response) {
        var result = JSON.parse(response);

        $('#tblReportsAndRecords > tbody').children('tr').remove();

        if (result != null && result.ReportsAndRecords.length > 0) {
            $.each(result.ReportsAndRecords, function (index1, value1) {
                var tableRow = ' <tr><td width="3%" style="text-align:center"><input type="checkbox" id="chkReportsAndRecordsDelete_' + index1 + '" /></td>' +
                        '<td width="97%"><div><input type="hidden" id="hdnCustomerReportId_' + index1 + '" value="" />' +
                        '<input type="text" id="txtReportName_' +index1 + '" maxlength="100" pattern="^[a-zA-Z0-9\\-\\(\\)\\/\\s]+$" class="form-control" style="max-width:100%" required/></div></td>' +
                        '</tr>';
                $('#tblReportsAndRecords > tbody').append(tableRow);
                $('#hdnCustomerReportId_' + index1).val(value1.CustomerReportId);
                $('#txtReportName_' + index1).val(value1.ReportName);
            });

            BindEvensForCheckBox();
            formInputValidation('tblReportsAndRecords');
        }
        $(".content").scrollTop(0);
        showMessage('', CURD_MESSAGE_STATUS.SS);
        $('#btnAddEditReportsSave').attr('disabled', false);
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
    $('#errorMsgReportsAndRecords').css('visibility', 'visible');

    $('#btnAddEditReportsSave').attr('disabled', false);

    $('#myPleaseWait').modal('hide');
});
}
}

    $('#anchorReportAddEditNew').unbind('click');
    $('#anchorReportAddEditNew').click(function () {
        $('#errorMsgReportsAndRecords').css('visibility', 'hidden');

        var errorMessage = '';

        $('#tblReportsAndRecords tr').each(function (index, value) {
            if (index == 0) return;
            var index1 = index - 1;

            if (!tableInputValidation('frmReportsAndRecords', 'save', 'chkReportsAndRecordsDelete'))
            {
                errorMessage = Messages.ENTER_VALUES_EXISTING_ROW;
            }
        });
        if (errorMessage != '') {
            bootbox.alert(errorMessage);
            return false;
        }
        else {

            var index1 = $('#tblReportsAndRecords tr').length - 1;
            var tableRow = ' <tr><td width="3%" style="text-align:center"><input type="checkbox" id="chkReportsAndRecordsDelete_' +index1 + '" /></td>' +
                           '<td width="97%"><div><input type="hidden" id="hdnCustomerReportId_' + index1 + '" value="" />' +
                           '<input type="text" id="txtReportName_' + index1 + '" maxlength="100" pattern="^[a-zA-Z0-9\\-\\(\\)\\/\\s]+$" class="form-control" style="max-width:100%" required/></div></td>' +
                           '</tr>';
            $('#tblReportsAndRecords > tbody').append(tableRow);

            BindEvensForCheckBox();
            formInputValidation('tblReportsAndRecords');
            $('#txtReportName_' + index1).focus();
        }
    });

    function BindEvensForCheckBox() {
        $("input[id^='chkReportsAndRecordsDelete_']").unbind('click');
        $("input[id^='chkReportsAndRecordsDelete_']").on('click', function () {
            var allChecked = true;
            var isChecked = $(this).prop('checked');
            if (isChecked) {
                $(this).parent().addClass('bgDelete');
            }
            else {
                $(this).parent().removeClass('bgDelete');
            }
            var id = $(this).attr('id');
            var index1;
            $('#tblReportsAndRecords tr').each(function (index, value) {
                if (index == 0) return;
                index1 = index - 1;
                if (!$('#chkReportsAndRecordsDelete_' + index1).prop('checked')) {
                    allChecked = false;
                }
            });
            if (allChecked) {
                $('#chkReportsAndRecordsDeleteAll').prop('checked', true);
            }
            else {
                $('#chkReportsAndRecordsDeleteAll').prop('checked', false);
            }
        });
    }

    $('#chkReportsAndRecordsDeleteAll').on('click', function () {
        var isChecked = $(this).prop("checked");
        var index1;
        var count = 0;
        $('#tblReportsAndRecords tr').each(function (index, value) {
            if (index == 0) return;
            index1 = index - 1;
            if (isChecked) {
                if(!$('#chkReportsAndRecordsDelete_' +index1).prop('disabled'))
            {
                    $('#chkReportsAndRecordsDelete_' +index1).prop('checked', true);
                    $('#chkReportsAndRecordsDelete_' +index1).parent().addClass('bgDelete');
                    count++;
                }
            }
            else {
                    if(!$('#chkReportsAndRecordsDelete_' +index1).prop('disabled'))
                    {
                        $('#chkReportsAndRecordsDelete_' + index1).prop('checked', false);
                        $('#chkReportsAndRecordsDelete_' + index1).parent().removeClass('bgDelete');
                    }
            }
        });
            if(count == 0){
                $(this).prop("checked", false);
            }
    });

    $("#btnReportsCancel").unbind('click');
    $("#btnReportsCancel").click(function () {
        var message = Messages.Reset_Alert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                ClearFieldsReportsAndRecords();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });

    function ClearFieldsReportsAndRecords() {
        $('#ContactGrid').empty();
        AddFirstGridRow();
        $('input[type="text"], textarea').val('');
        $('#btnEdit').hide();
        $(".content").scrollTop(0);
        $('#btnSave').show();
        $('#btnDelete').hide();
        $('#btnNextScreenSave').hide();
        $('#spnActionType').text('Add');
        $('#TypeOfContractLovId').val('null');
        $("#primaryID").val('');
        $('#CustomerName').attr("disabled", false);
        $("#grid").trigger('reloadGrid');
        $("#Custform :input:not(:button)").parent().removeClass('has-error');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $('#errorMsgCustomer').css('visibility', 'hidden');
        $('#errorMsgReportsAndRecords').css('visibility', 'hidden');

        $("#selDateFormat").val('null');
        $("#selCurrencyFormat").val('null');
        $('#TypeOfContractLovId').val('null');
        $('#chkQAPIndicatorB1,#chkQAPIndicatorB2,#chkKPIIndicatorB1,#chkKPIIndicatorB2').prop('checked', false);
        $('#chkKPIIndicatorB3,#chkKPIIndicatorB4,#chkKPIIndicatorB5,#chkKPIIndicatorB6').prop('checked', false);
        
        $('#tblReportsAndRecords > tbody').children('tr:not(:first)').remove();
        $('#chkReportsAndRecordsDeleteAll').prop('checked', false).attr('disabled', false);
        $('#chkReportsAndRecordsDelete_0').prop('checked', false).attr('disabled', false);
        $('#chkReportsAndRecordsDelete_0').parent().removeClass('bgDelete');
        $('#txtReportName_0').val('').attr('disabled', false).parent().removeClass('has-error');
        $('#showModalImg').hide();
        $('.nav-tabs a:first').tab('show');

        $('#hdnAttachId').val('')
    }
});