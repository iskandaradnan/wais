var IsDeductionGeneratedGlobal = false;

$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    
    formInputValidation("frmkpiGeneration");

    var allMonths = null;
    var currentYear = null;
    var currentYearMonths = null;
    //var IsDeductionGenerated = null;
    $('#divKPIGeneration').hide();
    //$('#btnSave').css('visibility', 'hidden');
    //$('#btnAddNew').css('visibility', 'hidden');
    //$('#btnCancel').css('visibility', 'hidden');
    //$('#divButtons').hide();
    //$('#divGenerationResult').hide();

    $.get("/api/kpiGeneration/Load")
    .done(function (result) {
        var loadResult = JSON.parse(result);
        $.each(loadResult.Years, function (index, value) {
            $('#selYear').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        //$.each(loadResult.Services, function (index, value) {
        //    $('#selService').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        //});
        $.each(loadResult.CurrentYearMonths, function (index, value) {
            $('#selMonth').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });

        allMonths = loadResult.Months;
        currentYearMonths = loadResult.CurrentYearMonths;
        currentYear = loadResult.CurrentYear;
        $('#selYear').val(loadResult.CurrentYear);
        //$('#selService').val(2);

        $('#myPleaseWait').modal('hide');
    })
.fail(function (response) {
    $('#myPleaseWait').modal('hide');
    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
    $('#errorMsg1').css('visibility', 'visible');
});

    $('#selMonth').change(function () {
        $("div.errormsgcenter").text('');
        $('#errorMsg1').css('visibility', 'hidden');

        $('#txtMonthlyServiceFee').val(null);
        var selectedMonth = $('#selMonth').val();
        if (selectedMonth == "null")
        {
            return false;
        }
        $('#myPleaseWait').modal('show');
      
        var fetchObj = {
            Year:$('#selYear').val(),
            Month:selectedMonth
        };

            var jqxhr = $.post("/api/kpiGeneration/GetMonthlyServiceFee", fetchObj, function (response) {
                var result = JSON.parse(response);
                var monthlyServiceFee = result.MonthlyServiceFee;
                if (result.MonthlyServiceFee != null) {
                    $('#txtMonthlyServiceFee').val(addCommas(result.MonthlyServiceFee));
                }
                else
                {
                    $('#txtMonthlyServiceFee').val(result.MonthlyServiceFee);
                }
              
                $('#txtMonthlyServiceFee').parent().removeClass('has-error');

                var buttonText = '';
                //IsDeductionGenerated = result.IsDeductionGenerated;
                if (result.IsDeductionGenerated == 0) {
                    IsDeductionGeneratedGlobal = false;
                    //$('#btnSave').show();
                    buttonText = 'Generate';
                } else if (result.IsDeductionGenerated == 1) {
                    IsDeductionGeneratedGlobal = true;
                    //$('#btnSave').hide();
                    buttonText = 'Fetch';
                }
                $('#btnAddGenerate').text(buttonText);
           
                $('#myPleaseWait').modal('hide');
         },
   "json")
    .fail(function (response) {
       
        $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            $('#errorMsg1').css('visibility', 'visible');

            $('#myPleaseWait').modal('hide');
        });
    });

    $('#selYear').change(function () {
        $('#txtMonthlyServiceFee').val(null);
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

    $("#btnAddGenerate").click(function () {
        $('#btnAddGenerate').attr('disabled', true);
        $("div.errormsgcenter").text("");
        $('#errorMsg1').css('visibility', 'hidden');
        $('#errorMsg').css('visibility', 'hidden');

        var isFormValid = formInputValidation("frmkpiGeneration", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg1').css('visibility', 'visible');

            $('#btnAddGenerate').attr('disabled', false);
            return false;
        }

        var monthlyServiceFee = parseFloat($('#txtMonthlyServiceFee').val());
        if (monthlyServiceFee == 0)
        {
            bootbox.alert('Monthly Service Fee value required.');
            $('#btnAddGenerate').attr('disabled', false);
            return false;
        }
        $('#selYear').attr('disabled', true);
        $('#selMonth').attr('disabled', true);
        //$('#myPleaseWait').modal('show');
        var saveObj = {
            Year: $('#selYear').val(),
            Month: $('#selMonth').val(),
            ServiceId: 2
            //FacilityId: $('#selFacilityLayout').val(),
        };
        var currency = $('#hdnCurrency').val();
        //genarateGrid(saveObj, currency);
        $('#divGenerationResult').show();
        $('#btnAddGenerate').css('visibility', 'hidden');
        //$('#divButtons').css('display', 'block');
        
        //--------------------
        $('#myPleaseWait').modal('show');
        var jqxhr = $.post("/api/kpiGeneration/GetAllRecords", saveObj, function (response) {
            $('#tableKPIGeneration > tbody').empty()
            var result = JSON.parse(response);
            var tableRow = '';
            if (result != null && result.length > 0) {
                $.each(result, function (index, value) {
                    var indicatorName = value.IndicatorName == null ? '' : value.IndicatorName.toString()
                    var demeritPointsLink = '';
                    var deductionValueLink = '';

                    if (value.TotalDemeritPoints > 0 && value.IndicatorNo != 'Total') {
                        demeritPointsLink = "<span id='spnDemeritPoint_" + value.IndicatorNo + "' style='color:blue;  text-decoration:underline;cursor: pointer;'>" + value.TotalDemeritPoints + "</span>";
                    } else if (value.IndicatorNo == 'Total' || value.TotalDemeritPoints == 0) {
                        demeritPointsLink = "<span>" + value.TotalDemeritPoints + "</span>";
                    }

                    if (value.DeductionValue > 0 && value.IndicatorNo != 'Total') {
                        if (value.IndicatorNo != 'B.6') {
                            deductionValueLink = "<span id='DeductionValuet_" + value.IndicatorNo + "' style='color:blue;  text-decoration:underline;cursor: pointer;'>" + value.DeductionValue + "</span>";
                        } else {
                            deductionValueLink = "<span>" +value.DeductionValue + "</span>";
                        }
                    } else if (value.IndicatorNo == 'Total' || value.DeductionValue == 0) {
                        deductionValueLink = "<span>" +value.DeductionValue + "</span>";
                    }

                    tableRow += '<tr>' 
                                        +'<td style="text-align: left;" width="10%">' + value.IndicatorNo.toString() + '</td>' 
                                        +'<td style="text-align: left;" width="60%">' + indicatorName + '</td>' 
                                        + '<td style="text-align: right;" width="10%">' + demeritPointsLink + '</td>'
                                        + '<td style="text-align: right;" width="10%">' +addCommas(deductionValueLink) + '</td>'
                                        +'<td style="text-align: right;" width="10%">' + value.DeductionPer.toString() + '</td>' 
                                    + '</tr>';
                    //tableRow += '<tr>' 
                    //                   +'<td style="text-align: left;" width="10%"></td>' 
                    //                   +'<td style="text-align: left;" width="60%"></td>' 
                    //                   +'<td style="text-align: right;" width="10%"></td>' 
                    //                   +'<td style="text-align: right;" width="10%"></td>' 
                    //                   +'<td style="text-align: right;" width="10%"></td>' 
                    //               + '</tr>';
                });
            }
            if (tableRow == '') {
                tableRow = ' <tr id="NoRecordsDiv">' +
                                    '<td colspan="5" width="100%" data-original-title="" title="">' +
                                        '<h5 class="text-center">' +
                                            '<span style="color:black;" href="#">No Records to Display</span>' +
                                        '</h5>' +
                                    '</td>' +
                                '</tr>';
            } else {
                if (!IsDeductionGeneratedGlobal) {
                    $('#btnSave').show();
                } else {
                    $('#btnSave').hide();
                }
                
                $('#btnKPIGenExport').show();
                $('#divButtons').css('display', 'block');
                $('#btnCancel').show();
            }
            $('#divKPIGeneration').show();
            $('#tableKPIGeneration > tbody').append(tableRow);
            

            $('[id^=spnDemeritPoint_]').click(function () {
                var id = $(this).attr('id');
                var indicatorNo = id.substring(id.indexOf('_') + 1);
                GetDemeritPointList(indicatorNo);
            });
            $('[id^=DeductionValuet_]').click(function () {
                var id = $(this).attr('id');
                var indicatorNo = id.substring(id.indexOf('_') + 1);
                GetDeductionValueList(indicatorNo);
            });            
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
        $('#errorMsg').css('visibility', 'visible');
        $('#btnCancelReset').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
    });
        //---------------------
    });

    $("#btnSave").click(function () {
        $('#btnSave').attr('disabled', true);
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var isFormValid = formInputValidation("frmkpiGeneration", 'save');
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
            ServiceId: 2
        };

        var jqxhr = $.post("/api/kpiGeneration/Save", saveObj, function (response) {
            var result = JSON.parse(response);
            $('#btnSave').hide();
            $('#btnAddGenerate').css('visibility', 'visible');
            $('#btnAddGenerate').text('Fetch');
            $(".content").scrollTop(0);
            showMessage('Asset Register', CURD_MESSAGE_STATUS.SS);            
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
        $('#errorMsg').css('visibility', 'visible');
        $('#btnSave').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
       });
    });
        
    $("#btnCancel").click(function () {
        var message = Messages.Reset_Alert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                $('#selYear').val(currentYear);
                $('#selMonth').val('null');
                $('#btnAddGenerate').attr('disabled', false);
                $('#btnAddGenerate').text('Generate');
                $('#btnAddGenerate').css('visibility', 'visible');
                $('#btnKPIGenExport').hide();
                $('#divKPIGeneration').hide();
                $("#btnCancel").hide();
                $("#btnSave").hide();
                $('#selYear').attr('disabled', false);
                $('#selMonth').attr('disabled', false);
                $('#txtMonthlyServiceFee').val('');
                //IsDeductionGenerated = null;
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });

    $("#btnCancelReset").click(function () {
        var message = Messages.Reset_Alert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                window.location.href = "/kpi/kpigeneration";
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });


    function GetDemeritPointList(indicatorNo) {
    
    if (indicatorNo == "B.1" || indicatorNo == "B.2"
                        || indicatorNo == "B.3" || indicatorNo == "B.4") {
        var demeritPointObj = {
            Heading: "Indicator: " + indicatorNo,
            ResultColumns: ['SerialNo-Serial No.', 'ServiceWorkNo-Work Order No.', 'ServiceWorkDateTime-Work Order Date/Time','AssetNo-Asset No.', 'AssetDescription-Asset Description', 'AssetTypeCode-Asset Type Code', 'UnderWarranty-Under Warranty', 'ResponseDateTime-Response Date/Time', 'RepsonseDurationHrs-Response Duration Hours', 'StartDateTime-Start Date/Time','EndDateTime-End Date/Time', 'WorkOrderStatus-WorkOrder Status', 'DowntimeHrs-Downtime Hours', 'DemeritPoint-Demerit Point'],
            Year: $('#selYear').val(),
            Month: $('#selMonth').val(),
            ServiceId: $('#selService').val(),
            IndicatorNo: indicatorNo
        };
    }else if (indicatorNo == "B.5" ){
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
            Heading: "Indicator: " +indicatorNo,
            ResultColumns: ['SerialNo-Serial No.', 'Report-Report', 'Remarks-Remarks', 'DemeritPoint-Demerit Point'],
            Year: $('#selYear').val(),
            Month: $('#selMonth').val(),
            ServiceId: $('#selService').val(),
            IndicatorNo: indicatorNo
            };
    }
    DisplayEditablePopup('divPopupResult', demeritPointObj, "/api/kpiGeneration/GetDemeritPoints", indicatorNo, true, false);
}

    function GetDeductionValueList(indicatorNo) {
    var currency = $('#hdnCurrency').val();
    var demeritPointObj = {
        Heading: "Indicator: " + indicatorNo,
        ResultColumns: ['SerialNo-Serial No.', 'AssetNo-Asset No.', 'PurchaseCostRM-Purchase Cost (' + currency + ')',
            'DemeritValue1-Demerit Value (' + currency + ')', 'DemeritPoint-Demerit Point', 'DeductionValue-KPI Value (' + currency + ')'],
        Year: $('#selYear').val(),
        Month: $('#selMonth').val(),
        ServiceId: $('#selService').val(),
        IndicatorNo: indicatorNo
    };
        DisplayEditablePopup('divPopupResult', demeritPointObj, "/api/kpiGeneration/GetDeductionValues", indicatorNo, false, true);
    }

    $('#btnKPIGenExport').click(function () {
        var $downloadForm = $("<form method='POST'>")
          .attr("action", "/api/common/Export")
           .append($("<input name='filters' type='text'>").val(""))
           .append($("<input name='sortOrder' type='text'>").val(""))
            .append($("<input name='sortColumnName' type='text'>").val(""))
           .append($("<input name='screenName' type='text'>").val("KPI_Generation"))
           .append($("<input name='exportType' type='text'>").val("CSV"))
           .append($("<input name='Year' type='text'>").val($('#selYear').val()))
           .append($("<input name='Month' type='text'>").val($('#selMonth').val()))
           .append($("<input name='ServiceId' type='text'>").val($('#selService').val()))
           .append($("<input name='IndicatorNo' type='text'>").val(indicatorNo1))
           .append($("<input name='KPIExportType' type='text'>").val("KPIGeneration"))
           .append($("<input name='spName' type='text'>").val(""))

        $("body").append($downloadForm);
        var status = $downloadForm.submit();
        $downloadForm.remove();
    });


});