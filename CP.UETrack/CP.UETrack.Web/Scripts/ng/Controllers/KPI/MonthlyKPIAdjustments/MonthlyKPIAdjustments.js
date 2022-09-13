$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    formInputValidation("frmMonthlyKPIAdjustments");

    var allMonths = null;
    var currentYear = null;
    var currentYearMonths = null;

    $.get("/api/monthlyKPIAdjustments/Load")
    .done(function (result) {
        var loadResult = JSON.parse(result);
        $("#jQGridCollapse1").click();
        $.each(loadResult.Years, function (index, value) {
            $('#selYear').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        //$.each(loadResult.Services, function (index, value) {
        //    $('#selService').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        //});
        $.each(loadResult.CurrentYearMonths, function (index, value) {
            $('#selMonth').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(loadResult.Indicators, function (index, value) {
            $('#selIndicator').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });

        allMonths = loadResult.Months;
        currentYearMonths = loadResult.CurrentYearMonths;

        currentYear = loadResult.CurrentYear;
        $('#selYear').val(loadResult.CurrentYear);
        //$('#selService').val(2);
        //$('#txtFacility').val($('#selFacilityLayout  option:selected').text());
    })
.fail(function () {
    $('#myPleaseWait').modal('hide');
    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
    $('#errorMsg1').css('visibility', 'visible');
});

    $('#selYear').change(function () {
        $('#txtMonthlyServiceFee').val("");
        var selectedYear = $('#selYear').val();
        if (selectedYear == currentYear) {
            $('#selMonth').children('option:not(:first)').remove();
            $.each(currentYearMonths, function (index, value) {
                $('#selMonth').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
        }
        else if (selectedYear == "null") {
            $('#selMonth').children('option:not(:first)').remove();
        }
        else {
            $('#selMonth').children('option:not(:first)').remove();
            $.each(allMonths, function (index, value) {
                $('#selMonth').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
        }
    });

    $('#selMonth').change(function () {
        $("div.errormsgcenter").text('');
        $('#errorMsg1').css('visibility', 'hidden');

        $('#txtMonthlyServiceFee').val(null);
        var selectedMonth = $('#selMonth').val();
        if (selectedMonth == "null") {
            return false;
        }
        $('#myPleaseWait').modal('show');

        var fetchObj = {
            Year: $('#selYear').val(),
            Month: selectedMonth
        };

        var jqxhr = $.post("/api/kpiGeneration/GetMonthlyServiceFee", fetchObj, function (response) {
            var result = JSON.parse(response);
            var monthlyServiceFee = result.MonthlyServiceFee;
            if (result.MonthlyServiceFee != null) {
                $('#txtMonthlyServiceFee').val(addCommas(result.MonthlyServiceFee));
                $('#txtMonthlyServiceFee').parent().removeClass('has-error');
            }
            else {
                $('#txtMonthlyServiceFee').val(result.MonthlyServiceFee);
                $('#txtMonthlyServiceFee').parent().removeClass('has-error');
            }


            $('#myPleaseWait').modal('hide');
        },
    "json")
    .fail(function (response) {

        $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
        $('#errorMsg1').css('visibility', 'visible');

        $('#myPleaseWait').modal('hide');
    });
    });

    $('#btnAddFetch').click(function () {
        $('#btnAddFetch').attr('disabled', true);

        $("div.errormsgcenter").text("");
        $('#errorMsg1').css('visibility', 'hidden');
        $('#errorMsg2').css('visibility', 'hidden');

        var isFormValid = formInputValidation("frmMonthlyKPIAdjustments", 'save');

        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg1').css('visibility', 'visible');

            $('#btnAddFetch').attr('disabled', false);
            return false;
        }

        $('#myPleaseWait').modal('show');

        var fetchObj = {
            Year: $('#selYear').val(),
            Month: $('#selMonth').val(),
            ServiceId: 2
        };

        var jqxhr = $.post("/api/monthlyKPIAdjustments/FetchRecords", fetchObj, function (response) {
            var result = JSON.parse(response);

            var firstObject = $.grep(result, function (value0, index0) {
                return index0 == 0;
            });

            BindData(result);
            var isAdjustmentSaved = firstObject[0].IsAdjustmentSaved;
            if (isAdjustmentSaved == 1) {
                $('#btnPrint, #btnAddNew, #btnCancel').css('visibility', 'visible');
                $('#btnSave').hide();
            } else {
                $('#btnSave, #btnAddNew, #btnCancel').css('visibility', 'visible');
                $('#btnPrint').hide();
                $('#txaRemarks').attr('disabled', false);
            }

            $('#txtDocumentNo').val(firstObject[0].DocumentNo);
            $('#txaRemarks').val(firstObject[0].Remarks);

            $('#btnAddFetch').hide();

            $('#selYear').attr('disabled', true);
            $('#selMonth').attr('disabled', true);

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
            $('#errorMsg1').css('visibility', 'visible');

            $('#btnAddFetch').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
    });

    function BindData(result) {
        var trString = '';
        for (i = 0; i < result.length; i++) {
            var styleStrTotalDM = result[i].TotalDemeritPoints == '0' ? '' : 'style="color:blue;  text-decoration:underline;cursor: pointer;"';
            var styleStrPostDM = result[i].PostDemeritPoints == '0' ? '' : 'style="color:blue;  text-decoration:underline;cursor: pointer;"';

            result[i].ServiceWorkDate = result[i].ServiceWorkDate == null ? '' : moment(result[i].ServiceWorkDate).format("DD-MMM-YYYY");
            result[i].DeductionValue = (result[i].DeductionValue == '0' ? result[i].DeductionValue : addCommas(result[i].DeductionValue));
            result[i].PostDeductionValue = (result[i].PostDeductionValue == '0' ? result[i].PostDeductionValue : addCommas(result[i].PostDeductionValue));            trString += ' <tr>'
                            + '<td width="2%"><div id="divIndicatorNo_' + i + '">' + result[i].IndicatorNo + '</div></td>'
                            + '<td width="14%"><div id="divIndicatorName_' + i + '">' + result[i].IndicatorName + '</div></td>'
                            + '<td width="6%"><div id="divTotalDemeritPoints_' + result[i].IndicatorNo + '" class="text-right" ' + styleStrTotalDM + '>' + result[i].TotalDemeritPoints + '</div></td>'
                            + '<td width="6%"><div id="divDeductionValue_' + i + '" class="text-right">' + result[i].DeductionValue + '</div></td>'
                            + '<td width="4%"><div id="divDeductionPer_' + i + '" class="text-right">' + result[i].DeductionPer + '</div></td>'
                            + '<td width="6%"><div id="divPostDemeritPoints_' + result[i].IndicatorNo + '" class="text-right" ' + styleStrPostDM + '>' + result[i].PostDemeritPoints + '</div></td>'
                            + '<td width="6%"><div id="divPostDeductionValue_' + i + '" class="text-right">' + result[i].PostDeductionValue + '</div></td>'
                            + '<td width="4%"><div id="divPostDeductionPer_' + i + '" class="text-right">' + result[i].PostDeductionPer + '</div></td>'
                        + '</tr>';
        }
        $('#tblAdjustmentResult > tbody').empty();
        $('#tblAdjustmentResult > tbody').append(trString);
        $('#divAdjustmentResult').css('display', 'block');

        $('[id^=divTotalDemeritPoints_]').click(function () {
            if ($(this).text() == '0') {
                return false;
            }
            var id = $(this).attr('id');
            var indicatorNo = id.substring(id.indexOf('_') + 1);
            GetToalDemeritPointList(indicatorNo);
        });

        $('[id^=divPostDemeritPoints_]').click(function () {
            if ($(this).text() == '0') {
                return false;
            }
            var id = $(this).attr('id');
            var indicatorNo = id.substring(id.indexOf('_') + 1);
            GetPostDemeritPointsList(indicatorNo);
        });

    }

    function GetToalDemeritPointList(indicatorNo) {

        //var demeritPointObj = {
        //    Heading: "Indicator: " + indicatorNo,
        //    ResultColumns: ['SerialNo-Serial No.', 'ServiceWorkNo-Service Work No.', 'AssetNo-Asset No.', 'AssetDescription-Asset Description', 'AssetTypeCode-Asset Type Code',
        //        'UnderWarranty-Under Warranty', 'ResponseDateTime-Response Date Time', 'RepsonseDurationHrs-Response Duration Hours', 'StartDateTime-Start Date Time',
        //        'EndDateTime-End Date Time', 'WorkOrderStatus-Work Order Status', 'DowntimeHrs-Downtime Hours', 'DemeritPoint-Demerit Point'],
        //    Year: $('#selYear').val(),
        //    Month: $('#selMonth').val(),
        //    ServiceId:2,
        //    IndicatorNo: indicatorNo
        //};
        //DisplayEditablePopup('divPopupResult', demeritPointObj, "/api/kpiGeneration/GetDemeritPoints", indicatorNo, true, false);

        if (indicatorNo == "B.1" || indicatorNo == "B.2"
                            || indicatorNo == "B.3" || indicatorNo == "B.4") {
            var demeritPointObj = {
                Heading: "Indicator: " + indicatorNo,
                ResultColumns: ['SerialNo-Serial No.', 'ServiceWorkNo-Work Order No.', 'ServiceWorkDateTime-Work Order Date/Time', 'AssetNo-Asset No.', 'AssetDescription-Asset Description', 'AssetTypeCode-Asset Type Code', 'UnderWarranty-Under Warranty', 'ResponseDateTime-Response Date/Time', 'RepsonseDurationHrs-Response Duration Hours', 'StartDateTime-Start Date/Time', 'EndDateTime-End Date/Time', 'WorkOrderStatus-WorkOrder Status', 'DowntimeHrs-Downtime Hours', 'DemeritPoint-Demerit Point'],
                Year: $('#selYear').val(),
                Month: $('#selMonth').val(),
                ServiceId: $('#selService').val(),
                IndicatorNo: indicatorNo
            };
        } else if (indicatorNo == "B.5") {
            var demeritPointObj = {
                Heading: "Indicator: " + indicatorNo,
                ResultColumns: ['SerialNo-Serial No.', 'TCDate-T&C Date', 'TCDocumentNo-T&C Document No.', 'RequiredDateTime-Required Date',
                    'TCCompletedDate-T&C Completed Date', 'TCStatus-T&C Status'],
                Year: $('#selYear').val(),
                Month: $('#selMonth').val(),
                ServiceId: $('#selService').val(),
                IndicatorNo: indicatorNo
            };
        } else if (indicatorNo == "B.6") {
            var demeritPointObj = {
                Heading: "Indicator: " + indicatorNo,
                ResultColumns: ['SerialNo-Serial No.', 'Report-Report', 'Remarks-Remarks', 'DemeritPoint-Demerit Point'],
                Year: $('#selYear').val(),
                Month: $('#selMonth').val(),
                ServiceId: $('#selService').val(),
                IndicatorNo: indicatorNo
            };
        }
        DisplayEditablePopup('divPopupResult', demeritPointObj, "/api/kpiGeneration/GetDemeritPoints", indicatorNo, true, false);
    }

    function GetPostDemeritPointsList(indicatorNo) {
        var demeritPointObj = {
            Heading: "Mapping Transaction Details",
            ResultColumns: ['DocumentNo-Document No.', 'FinalDemeritPoint-Final Demerit Point.'],
            Year: $('#selYear').val(),
            Month: $('#selMonth').val(),
            ServiceId: 2,
            IndicatorNo: indicatorNo
        };
        DisplayEditablePopup('divPopupResult', demeritPointObj, "/api/monthlyKPIAdjustments/GetPostDemeritPoints", indicatorNo, false, true);
    }

    $("#btnSave").click(function () {
        $('#btnSave').attr('disabled', true);

        $("div.errormsgcenter").text("");
        $('#errorMsg1').css('visibility', 'hidden');
        $('#errorMsg2').css('visibility', 'hidden');

        var isFormValid = formInputValidation("frmMonthlyKPIAdjustments", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            return false;
        }

        $('#myPleaseWait').modal('show');

        var saveObj = {
            Year: $('#selYear').val(),
            Month: $('#selMonth').val(),
            ServiceId: 2,
            Remarks: $('#txaRemarks').val()
        };

        var jqxhr = $.post("/api/monthlyKPIAdjustments/Save", saveObj, function (response) {
            var result = JSON.parse(response);
            $('#txtDocumentNo').val(result.DocumentNo);
            $(".content").scrollTop(0);
            showMessage('', CURD_MESSAGE_STATUS.SS);
            $('#btnSave').hide();
            $('#txaRemarks').attr('disabled', true);
            $('#btnPrint').show();
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
        $('#errorMsg2').css('visibility', 'visible');

        $('#btnSave').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
    });
    });

    $('#btnAddNew').click(function () {
        window.location.reload();

    });

    $("#btnCancel").click(function () {
        var message = Messages.Reset_Alert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                window.location.href = "/kpi/kpiadjustments";
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });
});