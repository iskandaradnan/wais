var currentYear = '';
$(document).ready(function () {

    $('#errorMsgReportsAndRecords').css('visibility', 'hidden');
    $('#errorMsg1').css('visibility', 'hidden');

    $('#chkReportsAndRecordsDeleteAll').prop('checked', false).attr('disabled', false);
    $('#chkSubmittedAll, #chkVerifiedAll').prop('checked', false).attr('disabled', false);

    $('#chkSubmittedAll').prop('checked', false).attr('disabled', false);
    $('#chkVerifiedAll').prop('checked', false).attr('disabled', false);

    $('#chkReportsAndRecordsDelete_0').parent().removeClass('bgDelete');

    $('#divReportAddNew').hide();
    $('#btnReportsCancel').show();
    formInputValidation('frmReportsAndRecordsHeader');

    $("#selYear").change(function () {
        var LoadData = GetYearMonth(this.value);

        $('#selMonth').empty();
        $('#selMonth').append('<option value="null">Select</option>');
        $.each(LoadData.MonthData, function (index, value) {
            $('#selMonth').append('<option value="' + (index + 1) + '">' + value[index + 1] + '</option>');
        });

    });

    var LoadData = GetYearMonth();
    $.each(LoadData.MonthData, function (index, value) {
        $('#selMonth').append('<option value="' + (index + 1) + '">' + value[index + 1] + '</option>');
    });

    $.each(LoadData.YearData, function (index, value) {
        $('#selYear').append('<option value="' + value + '">' + value + '</option>');
    });

    $('#myPleaseWait').modal('show');
    $.get("/api/reportsAndRecords/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#jQGridCollapse1").click();

            //$.each(loadResult.Years, function (index, value) {
            //    $('#selYear').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            //});
            //$.each(loadResult.Months, function (index, value) {
            //    $('#selMonth').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            //});

            $('#selYear').val(loadResult.CurrentYear);
            // $('#selMonth').val(result.CurrentMonth);
            currentYear = loadResult.CurrentYear;
            $('#myPleaseWait').modal('hide');
        })
        .fail(function (response) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            $('#errorMsg1').css('visibility', 'visible');
        });

    $('#btnAddEditFetch').unbind('click');
    $('#btnAddEditFetch').click(function () {
        $('#btnAddEditFetch').attr('disabled', true);

        $("div.errormsgcenter").text("");
        $('#errorMsg1').css('visibility', 'hidden');
        $('#errorMsgReportsAndRecords').css('visibility', 'hidden');

        var isFormValid = formInputValidation('frmReportsAndRecordsHeader', 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg1').css('visibility', 'visible');

            $('#btnAddEditFetch').attr('disabled', false);
            return false;
        }

        //var customerId = $('#selCustomerLayout').val();
        //var facilityId = $('#selFacilityLayout').val();

        var year = $('#selYear').val();
        var month = $('#selMonth').val();

        $('#tblReportsAndRecords > tbody').children('tr').remove();

        $('#myPleaseWait').modal('show');
        $.get("/api/reportsAndRecords/FetchRecords/" + year + "/" + month)
            .done(function (result) {
                var loadResult = JSON.parse(result);
                var status = '';
                if (loadResult != null && loadResult.ReportsAndRecords != null && loadResult.ReportsAndRecords.length > 0) {
                    $.each(loadResult.ReportsAndRecords, function (index1, value1) {
                        //var notSubmitted = value1.RecordSubmitted == null || !value1.RecordSubmitted;
                        //var notVerified = value1.RecordVerified == null || !value1.RecordVerified;
                        status = value1.Status;

                        var submitDisabled = '';
                        var verifyDisabled = '';
                        var remarksDisabled = '';

                        if (status == '') {
                            verifyDisabled = 'disabled';
                        } else if (status == 'Submitted') {
                            submitDisabled = 'disabled';
                        } else if (status == 'Verified') {
                            submitDisabled = 'disabled';
                            verifyDisabled = 'disabled';
                            remarksDisabled = 'disabled';
                        }

                        if (submitDisabled) {
                            $('#chkSubmittedAll').attr('disabled', true);
                        } else {
                            $('#chkSubmittedAll').attr('disabled', false);
                        }

                        if (verifyDisabled) {
                            $('#chkVerifiedAll').attr('disabled', true);
                        } else {
                            $('#chkVerifiedAll').attr('disabled', false);
                        }

                        var tableRow = '<tr>' +
                                '<td width="3%" style="text-align:center"><input type="checkbox" id="chkReportsAndRecordsDelete_' + index1 + '" disabled/></td>' +
                                '<td width="7%" style="text-align:center"><input type="hidden" id="hdnCustomerReportId_' + index1 + '" value="" />' +
                                '<input type="hidden" id="hdnReportsandRecordTxnId_' + index1 + '" value="" />' +
                                '<input type="hidden" id="hdnReportsandRecordTxnDetId_' + index1 + '" value="" />' +
                                '<span id="spnSerialNo_' + index1 + '"></span></td>' +
                                '<td width="36%"><input type="text" id="txtReportName_' + index1 + '" pattern="^[a-zA-Z0-9\-\(\)\/\\s\@\&]+$" maxlength="100" class="form-control" style="max-width:100%" disabled/></td>' +
                                '<td width="8%" style="text-align:center"><input type="checkbox" ' + submitDisabled + ' id="chkSubmitted_' + index1 + '"/></td>' +
                                '<td width="8%" style="text-align:center"><input type="checkbox" ' + verifyDisabled + ' id="chkVerified_' + index1 + '" /></td>' +
                                '<td width="38%"><input type="text" id="txtRemarks_' + index1 + '" ' + remarksDisabled + ' maxlength="500" class="form-control" style="max-width:100%" /></td>' +
                                '</tr>';
                        $('#tblReportsAndRecords > tbody').append(tableRow);
                        $('#hdnCustomerReportId_' + index1).val(value1.CustomerReportId);
                        $('#hdnReportsandRecordTxnId_' + index1).val(value1.ReportsandRecordTxnId);
                        $('#hdnReportsandRecordTxnDetId_' + index1).val(value1.ReportsandRecordTxnDetId);

                        $('#spnSerialNo_' + index1).text(index1 + 1);
                        $('#txtReportName_' + index1).val(value1.ReportName).attr('title', value1.ReportName);
                        $('#chkSubmitted_' + index1).prop('checked', value1.Submitted);
                        $('#chkVerified_' + index1).prop('checked', value1.Verified);
                        $('#txtRemarks_' + index1).val(value1.Remarks).attr('title', value1.Remarks);

                        $('#txtRemarks_' + index1).attr('pattern', '^[a-zA-Z0-9\'.\'\",:;/\\(\\),\\-\\s!@#$%*"&]+$');
                    });
                    BindEventsForSubmitVerifyCheckBox();
                    $('#divStatus').text(status);
                    if (status == '') {
                        $('#divReportAddNew').show();
                        $('#btnAddReports').show();
                        $('#btnVerifyReports').hide();
                    } else if (status == 'Submitted') {
                        $('#divReportAddNew').hide();
                        $('#btnAddReports').hide();
                        $('#btnVerifyReports').show();
                    } else {
                        $('#divReportAddNew').hide();
                        $('#btnAddReports').hide();
                        $('#btnVerifyReports').hide();
                        $('#selYear, #selMonth').attr("disabled", true);
                    }

                    BindEvensForCheckBox();
                    tableInputValidation('tblReportsAndRecords');
                }
                else {
                    $("div.errormsgcenter").text('There are no records to display');
                    $('#errorMsg1').css('visibility', 'visible');
                }

                //$('#btnAddEditFetch').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            })
        .fail(function (response) {
            $('#btnAddEditFetch').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            $('#errorMsg1').css('visibility', 'visible');
        });
    });

    $('#selYear, #selMonth').change(function () {
        $('#errorMsgReportsAndRecords').css('visibility', 'hidden');
        $('#errorMsg1').css('visibility', 'hidden');

        $('#chkReportsAndRecordsDeleteAll').prop('checked', false).attr('disabled', false);
        $('#chkReportsAndRecordsDelete_0').parent().removeClass('bgDelete');
        $('#tblReportsAndRecords > tbody').children('tr').remove();

        $('#divReportAddNew').hide();
        $('#btnAddEditFetch').attr('disabled', false);

        $('#chkSubmittedAll, #chkVerifiedAll').prop('checked', false).attr('disabled', false);
    })

    $("#btnAddReports, #btnVerifyReports").unbind('click');
    $("#btnAddReports, #btnVerifyReports").click(function () {
        $('#btnAddReports, #btnVerifyReports').attr('disabled', true);


        $("div.errormsgcenter").text("");
        $('#errorMsgReportsAndRecords').css('visibility', 'hidden');

        var isFormValid = formInputValidation('frmReportsAndRecordsHeader', 'save');
        var isTableValid = tableInputValidation('tblReportsAndRecords', 'save', 'chkReportsAndRecordsDelete')
        if (!isFormValid || !isTableValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsgReportsAndRecords').css('visibility', 'visible');

            $('#btnAddReports, #btnVerifyReports').attr('disabled', false);
            return false;
        }

        var allChecked = true
        $("#tblReportsAndRecords tr").each(function (index, value) {
            if (index == 0) return;
            var index1 = index - 1;
            if (!$('#chkReportsAndRecordsDelete_' + index1).prop('checked')) {
                allChecked = false;
            }
        });
        if (allChecked) {
            bootbox.alert(Messages.CAN_NOT_DELETE_ALL_RECORDS);
            $('#btnAddReports, #btnVerifyReports').attr('disabled', false);
            return false;
        }

        var status = $('#divStatus').text();
        var verified = status != '' ? true : false;
        var ReportsAndRecordsList = {
            ReportsandRecordTxnId: $('#hdnReportsandRecordTxnId_0').val(),
            Year: $('#selYear').val(),
            Month: $('#selMonth').val(),
            Submitted: true,
            Verified: verified
        };
        var reportsAndRecordsList = [];

        var recordsSelectedForDeletion = false;
        var deletedRowNumber = '';

        $("#tblReportsAndRecords tr").each(function (index, value) {
            if (index == 0) return;
            var index1 = index - 1;

            var isDeleted = $('#chkReportsAndRecordsDelete_' + index1).prop('checked')
            var isDisabled = $('#chkReportsAndRecordsDelete_' + index1).prop('disabled')

            //if (isDeleted) {
            //    deletedRowNumber += index + ',';
            //}


            var reportsandRecordTxnDetId = $('#hdnCustomerReportId_' + index1).val();
            if (!isDeleted || (isDeleted && (reportsandRecordTxnDetId != null && reportsandRecordTxnDetId != '' && reportsandRecordTxnDetId != 0))) {
                var additionalFieldsObj = {
                    ReportsandRecordTxnDetId: $('#hdnReportsandRecordTxnDetId_' + index1).val(),
                    CustomerReportId: $('#hdnCustomerReportId_' + index1).val(),
                    ReportName: $('#txtReportName_' + index1).val(),
                    Submitted: $('#chkSubmitted_' + index1).prop('checked'),
                    Verified: $('#chkVerified_' + index1).prop('checked'),
                    Remarks: $('#txtRemarks_' + index1).val(),
                    IsDeleted: isDeleted,
                }

                reportsAndRecordsList.push(additionalFieldsObj);
            }
            if (isDeleted) {
                recordsSelectedForDeletion = true;
            }
            ReportsAndRecordsList.ReportsAndRecords = reportsAndRecordsList;
        });

        var count = 0;
        var length = reportsAndRecordsList["length"];

        $.each(reportsAndRecordsList, function (index, value) {            
            if ((ReportsAndRecordsList.Submitted == true) && (ReportsAndRecordsList.Verified == false)) {
                if (reportsAndRecordsList[index].Submitted == false) {
                    count += 1;                    
                }                
            }
            else if (ReportsAndRecordsList.Verified == true) {
                if (reportsAndRecordsList[index].Verified == false) {
                    count += 1;
                }
            }
        });

        if (length == count) {
            bootbox.alert("Please select records to submit/verify");
            count = 0;
            $('#btnAddReports, #btnVerifyReports').attr('disabled', false);
            return false;
        }               

        if (recordsSelectedForDeletion) {
            bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (result) {
                if (result) {
                    SaveReportsAndRecords(ReportsAndRecordsList)
                }
                else {
                    $('#btnAddReports, #btnVerifyReports').attr('disabled', false);
                }
            });
        }
        else {
            SaveReportsAndRecords(ReportsAndRecordsList);
        }
    });

    $('#anchorReportAddEditNew').unbind('click');
    $('#anchorReportAddEditNew').click(function () {
        $('#errorMsgReportsAndRecords').css('visibility', 'hidden');

        var errorMessage = '';

        $('#tblReportsAndRecords tr').each(function (index, value) {
            if (index == 0) return;
            var index1 = index - 1;

            //$('#selYear').removeAttr('required');
            //$('#selMonth').removeAttr('required');


            if (!tableInputValidation('frmReportsAndRecords', 'save', 'chkReportsAndRecordsDelete')) {
                errorMessage = Messages.ENTER_VALUES_EXISTING_ROW;
            }

            //$('#selYear').attr('required', true);
            //$('#selMonth').attr('required', true);
        });
        if (errorMessage != '') {
            bootbox.alert(errorMessage);
            return false;
        }
        else {
            var status = $('#divStatus').text();
            var verified = status != '' ? true : false;
            var submitted = status == '' ? false : true;

            var index1 = $('#tblReportsAndRecords tr').length - 1;
            var serialNo = index1 + 1;
            var tableRow = '<tr>' +
                            '<td width="3%" style="text-align:center"><input type="checkbox" id="chkReportsAndRecordsDelete_' + index1 + '"/></td>' +
                            '<td width="7%" style="text-align:center"><input type="hidden" id="hdnCustomerReportId_' + index1 + '" value="" />' +
                            '<input type="hidden" id="hdnReportsandRecordTxnDetId_' + index1 + '" value="" />' +
                            '<span id="spnSerialNo_' + index1 + '">' + serialNo + '</span></td>' +
                            '<td width="36%"><input type="text" id="txtReportName_' + index1 + '" pattern="^[a-zA-Z0-9\-\(\)\/\\s\@\&]+$" maxlength="100" class="form-control" style="max-width:100%" required/></td>' +
                            '<td width="8%" style="text-align:center"><input type="checkbox" id="chkSubmitted_' + index1 + '"/></td>' +
                            '<td width="8%" style="text-align:center"><input type="checkbox" id="chkVerified_' + index1 + '" disabled/></td>' +
                            '<td width="38%"><input type="text" id="txtRemarks_' + index1 + '" maxlength="500" class="form-control" style="max-width:100%" /></td>' +
                            '</tr>';
            $('#tblReportsAndRecords > tbody').append(tableRow);
            BindEventsForSubmitVerifyCheckBox();
            BindEvensForCheckBox();
            tableInputValidation('tblReportsAndRecords');
            $('#txtReportName_' + index1).focus();
        }
    });

    $('#chkReportsAndRecordsDeleteAll').on('click', function () {
        var isChecked = $(this).prop("checked");
        var index1;
        var count = 0;
        $('#tblReportsAndRecords tr').each(function (index, value) {
            if (index == 0) return;
            index1 = index - 1;
            if (isChecked) {
                if (!$('#chkReportsAndRecordsDelete_' + index1).prop('disabled')) {
                    $('#chkReportsAndRecordsDelete_' + index1).prop('checked', true);
                    $('#chkReportsAndRecordsDelete_' + index1).parent().addClass('bgDelete');
                    $('#txtReportName_' + index1).removeAttr('required');
                    count++;
                }
            }
            else {
                if (!$('#chkReportsAndRecordsDelete_' + index1).prop('disabled')) {
                    $('#chkReportsAndRecordsDelete_' + index1).prop('checked', false);
                    $('#chkReportsAndRecordsDelete_' + index1).parent().removeClass('bgDelete');
                    $('#txtReportName_' + index1).attr('required', true);
                }
            }
        });
        if (count == 0) {
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

    $('#chkSubmittedAll, #chkVerifiedAll').on('click', function () {
        var id = $(this).attr('id');
        var chkId = '';
        if (id == 'chkSubmittedAll') {
            chkId = 'chkSubmitted_';
        } else if (id == 'chkVerifiedAll') {
            chkId = 'chkVerified_';
        }

        var isChecked = $(this).prop("checked");
        var index1;
        var count = 0;
        $('#tblReportsAndRecords tr').each(function (index, value) {
            if (index == 0) return;
            index1 = index - 1;
            if (isChecked) {
                if (!$('#' + chkId + index1).prop('disabled')) {
                    $('#' + chkId + index1).prop('checked', true);
                    count++;
                }
            }
            else {
                if (!$('#' + chkId + index1).prop('disabled')) {
                    $('#' + chkId + index1).prop('checked', false);
                }
            }
        });
        if (count == 0) {
            $(this).prop("checked", false);
        }
    });

});

    function SaveReportsAndRecords(ReportsAndRecordsList) {
            
        $('#myPleaseWait').modal('show');
        var jqxhr = $.post("/api/reportsAndRecords/Save", ReportsAndRecordsList, function (response) {
            var result = JSON.parse(response);
            $('#chkReportsAndRecordsDeleteAll').prop('checked', false).attr('disabled', false);
            $('#chkSubmittedAll, #chkVerifiedAll').prop('checked', false).attr('disabled', false);

            $('#chkSubmittedAll').prop('checked', false).attr('disabled', false);
            $('#chkVerifiedAll').prop('checked', false).attr('disabled', false);

            $('#tblReportsAndRecords > tbody').children('tr').remove();
            var status = '';
            if (result != null && result.ReportsAndRecords != null && result.ReportsAndRecords.length > 0) {
                $('#tblReportsAndRecords > tbody').children('tr').remove();
                $.each(result.ReportsAndRecords, function (index1, value1) {
                    //var notSubmitted = value1.RecordSubmitted == null || !value1.RecordSubmitted;
                    //var notVerified = value1.RecordVerified == null || !value1.RecordVerified;

                    status = value1.Status;

                    var submitDisabled = '';
                    var verifyDisabled = '';
                    var remarksDisabled = '';

                    if (status == '') {
                        verifyDisabled = 'disabled';
                    } else if (status == 'Submitted') {
                        submitDisabled = 'disabled';
                    } else if (status == 'Verified') {
                        submitDisabled = 'disabled';
                        verifyDisabled = 'disabled';
                        remarksDisabled = 'disabled';
                    }

                    if (submitDisabled) {
                        $('#chkSubmittedAll').attr('disabled', true);
                    } else {
                        $('#chkSubmittedAll').attr('disabled', false);
                    }

                    if (verifyDisabled) {
                        $('#chkVerifiedAll').attr('disabled', true);
                    } else {
                        $('#chkVerifiedAll').attr('disabled', false);
                    }

                    var tableRow = '<tr>' +
                            '<td width="3%" style="text-align:center"><input type="checkbox" id="chkReportsAndRecordsDelete_' + index1 + '" disabled/></td>' +
                            '<td width="7%" style="text-align:center"><input type="hidden" id="hdnCustomerReportId_' + index1 + '" value="" />' +
                            '<input type="hidden" id="hdnReportsandRecordTxnId_' + index1 + '" value="" />' +
                            '<input type="hidden" id="hdnReportsandRecordTxnDetId_' + index1 + '" value="" />' +
                            '<span id="spnSerialNo_' + index1 + '"></span></td>' +
                            '<td width="36%"><input type="text" id="txtReportName_' + index1 + '" pattern="^[a-zA-Z0-9\-\(\)\/\\s\@\&]+$" maxlength="100" class="form-control" style="max-width:100%" disabled/></td>' +
                            '<td width="8%" style="text-align:center"><input type="checkbox" ' + submitDisabled + ' id="chkSubmitted_' + index1 + '"/></td>' +
                            '<td width="8%" style="text-align:center"><input type="checkbox" ' + verifyDisabled + ' id="chkVerified_' + index1 + '" /></td>' +
                            '<td width="38%"><input type="text" id="txtRemarks_' + index1 + '" ' + remarksDisabled + ' maxlength="500" class="form-control" style="max-width:100%" /></td>' +
                            '</tr>';
                    $('#tblReportsAndRecords > tbody').append(tableRow);
                    $('#hdnCustomerReportId_' + index1).val(value1.CustomerReportId);
                    $('#hdnReportsandRecordTxnId_' + index1).val(value1.ReportsandRecordTxnId);
                    $('#hdnReportsandRecordTxnDetId_' + index1).val(value1.ReportsandRecordTxnDetId);

                    $('#spnSerialNo_' + index1).text(index1 + 1);
                    $('#txtReportName_' + index1).val(value1.ReportName).attr('title', value1.ReportName);
                    $('#chkSubmitted_' + index1).prop('checked', value1.Submitted);
                    $('#chkVerified_' + index1).prop('checked', value1.Verified);
                    $('#txtRemarks_' + index1).val(value1.Remarks).attr('title', value1.Remarks);

                    $('#txtRemarks_' + index1).attr('pattern', '^[a-zA-Z0-9\'.\'\",:;/\\(\\),\\-\\s!@#$%*"&]+$');
                });
                BindEventsForSubmitVerifyCheckBox();
                $('#divStatus').text(status);
                if (status == 'Submitted') {
                    $('#divReportAddNew').show();
                    $('#btnAddReports').hide();
                    $('#btnVerifyReports').show();
                } else if(status == 'Verified') {
                    $('#divReportAddNew').hide();
                    $('#btnAddReports').hide();
                    $('#btnVerifyReports').hide();
                    $('#selYear, #selMonth').attr("disabled", true);
                }
                $('#divReportAddNew').hide();
                $('#chkReportsAndRecordsDeleteAll').attr('disabled', true);
                tableInputValidation('tblReportsAndRecords');
                $("#grid").trigger('reloadGrid');
            }
            showMessage('', CURD_MESSAGE_STATUS.SS);
            $('#btnAddReports, #btnVerifyReports').attr('disabled', false);
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

        $('#btnAddReports, #btnVerifyReports').attr('disabled', false);

        $('#myPleaseWait').modal('hide');
    });
    }

    function BindEvensForCheckBox() {
        $("input[id^='chkReportsAndRecordsDelete_']").unbind('click');
        $("input[id^='chkReportsAndRecordsDelete_']").on('click', function () {
            var allChecked = true;
            var isChecked = $(this).prop('checked');
            var index = $(this).attr('id').split('_')[1];
            if (isChecked) {
                $(this).parent().addClass('bgDelete');
                $('#txtReportName_' + index).removeAttr('required');
            }
            else {
                $(this).parent().removeClass('bgDelete');
                $('#txtReportName_' + index).attr('required', true);
            }
            var id = $(this).attr('id');
            var index1;
            $('#tblReportsAndRecords tr').each(function (index, value) {
                if (index == 0) return;
                index1 = index - 1;
                if (!$('#chkReportsAndRecordsDelete_' + index1).prop('checked') && !$('#chkReportsAndRecordsDelete_' + index1).attr('disabled')) {
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

    function ClearFieldsReportsAndRecords() {       
        $('#selYear').val(currentYear);
        $('#selMonth').val('null');
        $('#tblReportsAndRecords > tbody').children('tr').remove();
        $('#divStatus').text('');
        $('#btnAddReports').hide();
        $('#btnVerifyReports').hide();
        $('#divReportAddNew').hide();
        $('#chkReportsAndRecordsDeleteAll').prop('checked', false).attr('disabled', false);
        $('#btnAddEditFetch').attr('disabled', false);
        $('#chkSubmittedAll, #chkVerifiedAll').prop('checked', false).attr('disabled', false);
        $('#selYear, #selMonth').attr("disabled", false);
    }

    function LinkClicked(id) {
        $(".content").scrollTop(1);
        $("#frmReportsAndRecordsHeader :input:not(:button)").parent().removeClass('has-error');
        $("#frmReportsAndRecords :input:not(:button)").parent().removeClass('has-error');

        $("div.errormsgcenter").text("");
        $('#errorMsg1').css('visibility', 'hidden');
        $('#errorMsgReportsAndRecords').css('visibility', 'hidden');

        $('#btnAddEditFetch').attr('disabled', true);

        $('#myPleaseWait').modal('show');
        $.get("/api/reportsAndRecords/Get/" + id)
              .done(function (response) {
                  var result = JSON.parse(response);

                  $('#tblReportsAndRecords > tbody').children('tr').remove();
                  var status = '';
                  var year = null;
                  var month = null;

                  if (result != null && result.ReportsAndRecords != null && result.ReportsAndRecords.length > 0) {
                      $('#tblReportsAndRecords > tbody').children('tr').remove();
                      year = result.ReportsAndRecords[0].Year;
                      month = result.ReportsAndRecords[0].Month;
                      $.each(result.ReportsAndRecords, function (index1, value1) {
                          
                          status = value1.Status;

                          var submitDisabled = '';
                          var verifyDisabled = '';
                          var remarksDisabled = '';

                          if (status == '') {
                              verifyDisabled = 'disabled';
                          } else if (status == 'Submitted') {
                              submitDisabled = 'disabled';
                          } else if (status == 'Verified') {
                              submitDisabled = 'disabled';
                              verifyDisabled = 'disabled';
                              remarksDisabled = 'disabled';
                          }

                          if (submitDisabled) {
                              $('#chkSubmittedAll').attr('disabled', true);
                          } else {
                              $('#chkSubmittedAll').attr('disabled', false);
                          }

                          if (verifyDisabled) {
                              $('#chkVerifiedAll').attr('disabled', true);
                          } else {
                              $('#chkVerifiedAll').attr('disabled', false);
                          }

                          var tableRow = '<tr>' +
                                  '<td width="3%" style="text-align:center"><input type="checkbox" id="chkReportsAndRecordsDelete_' + index1 + '" disabled/></td>' +
                                  '<td width="7%"><input type="hidden" id="hdnCustomerReportId_' + index1 + '" value="" />' +
                                  '<input type="hidden" id="hdnReportsandRecordTxnId_' + index1 + '" value="" />' +
                                  '<input type="hidden" id="hdnReportsandRecordTxnDetId_' + index1 + '" value="" />' +
                                  '<span id="spnSerialNo_' + index1 + '"></span></td>' +
                                  '<td width="36%"><input type="text" id="txtReportName_' + index1 + '" pattern="^[a-zA-Z0-9\-\(\)\/\\s\@\&]+$" maxlength="100" class="form-control" style="max-width:100%" disabled/></td>' +
                                  '<td width="8%" style="text-align:center"><input type="checkbox" ' + submitDisabled + ' id="chkSubmitted_' + index1 + '"/></td>' +
                                  '<td width="8%" style="text-align:center"><input type="checkbox" ' + verifyDisabled + ' id="chkVerified_' + index1 + '" /></td>' +
                                  '<td width="38%"><input type="text" id="txtRemarks_' + index1 + '" ' + remarksDisabled + ' maxlength="500" class="form-control" style="max-width:100%" /></td>' +
                                  '</tr>';
                          $('#tblReportsAndRecords > tbody').append(tableRow);
                          $('#hdnCustomerReportId_' + index1).val(value1.CustomerReportId);
                          $('#hdnReportsandRecordTxnId_' + index1).val(value1.ReportsandRecordTxnId);
                          $('#hdnReportsandRecordTxnDetId_' + index1).val(value1.ReportsandRecordTxnDetId);

                          $('#spnSerialNo_' + index1).text(index1 + 1);
                          $('#txtReportName_' + index1).val(value1.ReportName).attr('title', value1.ReportName);
                          $('#chkSubmitted_' + index1).prop('checked', value1.Submitted);
                          $('#chkVerified_' + index1).prop('checked', value1.Verified);
                          $('#txtRemarks_' + index1).val(value1.Remarks).attr('title', value1.Remarks);

                          $('#txtRemarks_' + index1).attr('pattern', '^[a-zA-Z0-9\'.\'\",:;/\\(\\),\\-\\s!@#$%*"&]+$');
                      });
                      BindEventsForSubmitVerifyCheckBox();
                      $('#selYear').val(year);
                      $('#selMonth').val(month);

                      $('#divStatus').text(status);
                      if (status == 'Submitted') {
                          $('#btnAddReports').hide();
                          $('#btnVerifyReports').show();
                      } else if (status == 'Verified') {
                          $('#btnAddReports').hide();
                          $('#btnVerifyReports').hide();
                          $('#selYear, #selMonth').attr("disabled", true);
                      }
                      $('#btnReportsCancel').show();
                      $('#divReportAddNew').hide();
                      $('#chkReportsAndRecordsDeleteAll').attr('disabled', true);
                      tableInputValidation('tblReportsAndRecords');
                  }
                  
                  $('#btnAddReports, #btnVerifyReports').attr('disabled', false);
                  $('#myPleaseWait').modal('hide');

              })
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

                 $('#btnAddReports, #btnVerifyReports').attr('disabled', false);

                 $('#myPleaseWait').modal('hide');
             });
    }

    function BindEventsForSubmitVerifyCheckBox()
    {
    $("input[id^='chkSubmitted_'], input[id^='chkVerified_']").unbind('click');
    $("input[id^='chkSubmitted_'], input[id^='chkVerified_']").on('click', function () {
        var allChecked = true;
        var isChecked = $(this).prop('checked');
        var index = $(this).attr('id').split('_')[1];
       
        var id = $(this).attr('id');
        var idWithoutIndex = '';
        var index1;
        var checkAllId = '';

        if (id.indexOf('chkSubmitted_') != -1) {
            checkAllId = 'chkSubmittedAll';
            idWithoutIndex = 'chkSubmitted_';
        } else if (id.indexOf('chkVerified_') != -1) {
            checkAllId = 'chkVerifiedAll';
            idWithoutIndex = 'chkVerified_';
        }

        $('#tblReportsAndRecords tr').each(function (index, value) {
            if (index == 0) return;
            index1 = index - 1;
            if (!$('#' + idWithoutIndex + index1).prop('checked')) {// && !$('#' + id +  index1).attr('disabled')
                allChecked = false;
            }
        });
        if (allChecked) {
            $('#' + checkAllId).prop('checked', true);
        }
        else {
            $('#' + checkAllId).prop('checked', false);
        }
    });
}