$(document).ready(function () {

    var headerHtml = '<html><head><title></title><style> body{ font-size: 10px !important; } .row {  margin-left:-10px;  margin-right:-10px;} .col-sm-3 { width:25%; } .col-sm-6 { width:50%; } .table-responsive { height:970px; overflow: hidden; page-break-after: always; }  .rptHeader{ text-align: left; background-color:lightgray; color:black; border:1px solid black } .highlited {  color: red; - webkit - print - color - adjust: exact;} @media print { .highlited { color: red!important;   -webkit-print-color-adjust: exact; }} table td {  border: 0.1em solid black;   border-collapse: collapse;  padding: 1.5px;  }  table {  border-collapse: collapse; width: 100%; font-size: 10px !important; } .tblUserArea { width: 100%; } span { text-decoration: underline; }</style></head><body>';
    var rowNumber = 0;

    $.get("/api/HWMSReports/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            var MonthVal = "<option value='' Selected>" + "Select" + "</option>"
            var YearVal = "<option value='' Selected>" + "Select" + "</option>"
            var requestType = "<option value='' Selected>" + "Select" + "</option>"
            var wasteCategory = "<option value='' Selected>" + "Select" + "</option>"

            for (var i = 0; i < loadResult.YearLovs.length; i++) {
                YearVal += "<option value=" + loadResult.YearLovs[i].LovId + ">" + loadResult.YearLovs[i].FieldValue + "</option>"
            }
            $("#ddlYear").append(YearVal);

            for (var i = 0; i < loadResult.MonthLovs.length; i++) {
                MonthVal += "<option value=" + loadResult.MonthLovs[i].LovId + ">" + loadResult.MonthLovs[i].FieldValue + "</option>"
            }
            $("#ddlMonth").append(MonthVal);

            if (loadResult.RequestType != null) {

                for (var i = 0; i < loadResult.RequestType.length; i++) {
                    requestType += "<option value=" + loadResult.RequestType[i].LovId + ">" + loadResult.RequestType[i].FieldValue + "</option>"
                }
                $("#ddlRequestType").append(requestType);
            }

            if (loadResult.WasteCategory != null) {

                for (var i = 0; i < loadResult.WasteCategory.length; i++) {
                    wasteCategory += "<option value=" + loadResult.WasteCategory[i].LovId + ">" + loadResult.WasteCategory[i].FieldValue + "</option>"
                }
                $("#ddlWasteCategory").append(wasteCategory);
            }

            $('#myPleaseWait').modal('hide');
        })
        .fail(function (response) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            $('#errorMsgConfigAdditionalFields').css('visibility', 'visible');
        });

    $('#ddlMonth').change(function () {
        $('#MonthVal').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });
    $('#ddlYear').change(function () {
        $('#errorMsg').css('visibility', 'hidden');
        $('#YearVal').removeClass('has-error');
    });

    function validateForm(formName) {

        var isFormValid = formInputValidation(formName, 'save');
        if (isFormValid) {
            return true;
        }
        else {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }
    };

    $("#btnLicenseReportFetch").click(function () {

        if (validateForm("formLicenseReport")) {            

            var obj = {
                Year: 2000,
                Month: 11
            }

            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');

            $.post("/api/HWMSReports/LicenseReportFetch", obj, function (response) {

                var result = JSON.parse(response);
                var dataList = result.LicenseReportList;
                var data = "";               

                $.each(dataList, function (index, row) {

                    rowNumber = index + 1;
                    data += "<tr>";
                    data += "<td>" + rowNumber + "</td>";
                    data += "<td>" + row.LicenseNo + "</td>";
                    data += "<td>" + row.LicenseDescription + "</td>";
                    data += "<td>" + row.LicenseType + "</td>";                  
                    data += "/<tr>";
                });

                $("#tbodyReport").html(data);

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
        }
    });


    $("#btnWeighingSummaryReportFetch").click(function () {

        if (validateForm("formWeighingSummaryReport")) {

            $('#tdYear').html($('#ddlYear')[0].options[$('#ddlYear')[0].selectedIndex].innerHTML);
            $('#tdMonth').html($('#ddlMonth')[0].options[$('#ddlMonth')[0].selectedIndex].innerHTML);
            $('#tdWasteCategory').html($('#ddlWasteCategory')[0].options[$('#ddlWasteCategory')[0].selectedIndex].innerHTML);
            $('#tdWastetype').html('Clinical Waste');

            var obj = {
                Year: $('#ddlYear').val(),
                Month: $('#ddlMonth').val(),
                WasteCategory: $('#ddlWasteCategory').val()
            }

            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');

            $.post("/api/HWMSReports/WeighingSummaryReportFetch", obj, function (response) {

                var result = JSON.parse(response);
                var dataList = result.WeighingSummaryReportList;
                var data = "";
                
                $.each(dataList, function (index, row) {

                    rowNumber = index + 1;
                    data += "<tr>";
                    data += "<td>" + rowNumber + "</td>";                   
                    data += "<td>" + row.ConsignmentNo + "</td>";
                    data += "<td>" + row.TotalWeight + "</td>";
                    data += "<td>" + row.NoofBins + "</td>";
                    data += "<td>" + row.Date + "</td>";                  
                    data += "/<tr>";
                });

                $("#tbodyReport").html(data);

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
        }
    });

    $("#btnTransportationReportFetch").click(function () {

        if (validateForm("formTransportationReport")) {

            $('#tdYear').html($('#ddlYear')[0].options[$('#ddlYear')[0].selectedIndex].innerHTML);
            $('#tdMonth').html($('#ddlMonth')[0].options[$('#ddlMonth')[0].selectedIndex].innerHTML);

            var obj = {
                Year: $('#ddlYear').val(),
                Month: $('#ddlMonth').val()
            }

            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');

            $.post("/api/HWMSReports/TransportationReportFetch", obj, function (response) {

                var result = JSON.parse(response);
                var dataList = result.TransportationReportList;
                var data = "";

                $.each(dataList, function (index, row) {
                    rowNumber = index + 1;
                    data += "<tr>";
                    data += "<td>" + rowNumber + "</td>";
                    data += "<td>" + row.ConsignmentNote + "</td>";
                    data += "<td>" + row.Date + "</td>";
                    data += "<td>" + row.QCValue + "</td>";
                    data += "<td>" + row.VehicleNumber + "</td>";
                    data += "<td>" + row.DriverName + "</td>";
                    data += "<td>" + row.ONSchedule + "</td>";                   
                    data += "/<tr>";
                });

                $("#tbodyReport").html(data);

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
        }
    });

    $("#btnSafetyDataSheetReportFetch").click(function () {

        if (validateForm("formSafetyDataSheetReport")) {

            $('#tdYear').html($('#ddlYear')[0].options[$('#ddlYear')[0].selectedIndex].innerHTML);
            $('#tdMonth').html($('#ddlMonth')[0].options[$('#ddlMonth')[0].selectedIndex].innerHTML);

            var obj = {
                Year: $('#ddlYear').val(),
                Month: $('#ddlMonth').val()
            }

            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');

            $.post("/api/HWMSReports/SafetyDataSheetReportFetch", obj, function (response) {

                var result = JSON.parse(response);
                var dataList = result.SafetyDataSheetReportList;
                var data = "";

                $.each(dataList, function (index, row) {
                    rowNumber = index + 1;
                    data += "<tr>";
                    data += "<td>" + rowNumber + "</td>";
                    data += "<td>" + row.ChemicalName + "</td>";
                    data += "<td>" + row.DocumentNo + "</td>";
                    data += "<td>" + row.DocumentDate + "</td>";
                    data += "<td>" + row.Category + "</td>";
                    data += "<td>" + row.AreaOfApplication + "</td>";                 
                    data += "/<tr>";
                });

                $("#tbodyReport").html(data);

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
        }
    });

    $("#btnRecordSheetWithoutCNReportFetch").click(function () {

        if (validateForm("formRecordSheetWithoutCN")) {

            $('#tdYear').html($('#ddlYear')[0].options[$('#ddlYear')[0].selectedIndex].innerHTML);
            $('#tdMonth').html($('#ddlMonth')[0].options[$('#ddlMonth')[0].selectedIndex].innerHTML);

            $('#tdMonthYear').html($('#ddlMonth')[0].options[$('#ddlMonth')[0].selectedIndex].innerHTML + ' ' + $('#ddlYear')[0].options[$('#ddlYear')[0].selectedIndex].innerHTML);

            var obj = {
                Year: $('#ddlYear').val(),
                Month: $('#ddlMonth').val()
            }

            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');

            $.post("/api/HWMSReports/RecordSheetWithoutCNFetch", obj, function (response) {

                var result = JSON.parse(response);
                var dataList = result.RecordSheetWithoutCNList;
                var data = "";

                var grandTotalWeight = 0.00;
                var grandRM = 0.00;

                $.each(dataList, function (index, row) {
                    rowNumber = index + 1;
                    grandTotalWeight += parseFloat(row.TotalWeight);
                    grandRM += parseFloat(row.RM);

                    data += "<tr>";
                    data += "<td>" + rowNumber + "</td>";
                    data += "<td>" + row.DateOfConsignmentNote + "</td>";
                    data += "<td>" + row.ConsignmentNo + "</td>";
                    data += "<td>" + parseFloat(row.TotalWeight).toFixed(2) + "</td>";
                    data += "<td>" + parseFloat(row.RM).toFixed(2) + "</td>";                   
                    data += "/<tr>";
                });

                data += "<tr><td colspan='3' style='text-align:center;'>Grand Total</td><td>" + parseFloat(grandTotalWeight).toFixed(2) + "</td><td>" + parseFloat(grandRM).toFixed(2) + "</td></tr>";
                data += "<tr><td colspan='5' style='text-align:center;'>Total Weight(Kg) in words: <b> " + inWords(grandTotalWeight) + "</b></td></tr>";

                $("#tbodyReport").html(data);

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
        }
    });

    $("#btnWasteGenerationMonthlyReportFetch").click(function () {

        if (validateForm("formWasteGenerationMonthlyReport")) {

           

            $('#tdMonthYear').html($('#ddlMonth')[0].options[$('#ddlMonth')[0].selectedIndex].innerHTML + ' ' + $('#ddlYear')[0].options[$('#ddlYear')[0].selectedIndex].innerHTML);
            var obj = {
                Year: $('#ddlYear').val(),
                Month: $('#ddlMonth').val()
            }

            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');

            $.post("/api/HWMSReports/WasteGenerationMonthlyReportFetch", obj, function (response) {

                var result = JSON.parse(response);
                var dataList = result.WasteGenerationMonthlyReportList;
                var data = "";

                var grandTotalWeight = 0.00;
                var grandRM = 0.00;
                
                $.each(dataList, function (index, row) {
                    rowNumber = index + 1;
                    grandTotalWeight += parseFloat(row.TotalWeight);
                    grandRM += parseFloat(row.RM);

                    data += "<tr>";                 
                    data += "<td>" + rowNumber + "</td>";
                    data += "<td>" + row.DateOfConsignmentNote + "</td>";
                    data += "<td>" + row.ConsignmentNo + "</td>";
                    data += "<td>" + parseFloat(row.TotalWeight).toFixed(2) + "</td>";
                    data += "<td>" + parseFloat(row.RM).toFixed(2) + "</td>";
                    data += "/<tr>";
                });

                data += "<tr><td colspan='3' style='text-align:center;'>Grand Total</td><td>" + parseFloat(grandTotalWeight).toFixed(2) + "</td><td>" + parseFloat(grandRM).toFixed(2) +"</td></tr>";
                data += "<tr><td colspan='5' style='text-align:center;'>Total Weight(Kg) in words: <b> " + inWords(grandTotalWeight) +"</b></td></tr>";

                $("#tbodyReport").html(data);

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
        }
    });

    $("#btnCRMReportFetch").click(function () {

        if (validateForm("formCRMReport")) {

            $('#tdYear').html($('#ddlYear')[0].options[$('#ddlYear')[0].selectedIndex].innerHTML);
            $('#tdMonth').html($('#ddlMonth')[0].options[$('#ddlMonth')[0].selectedIndex].innerHTML);

            var obj = {
                Year: $('#ddlYear').val(),
                Month: $('#ddlMonth').val(),
                RequestType: $('#ddlRequestType').val()
            }

            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');

            $.post("/api/HWMSReports/CRMReportFetch", obj, function (response) {

                var result = JSON.parse(response);
                var dataList = result.CRMReportList;
                var data = "";

                $.each(dataList, function (index, row) {
                    rowNumber = index + 1;
                    data += "<tr>";
                    data += "<td>" + rowNumber + "</td>";
                    data += "<td>" + row.RequestNo + "</td>";
                    data += "<td>" + row.RequestDate + "</td>";
                    data += "<td>" + row.RequestDetails + "</td>";
                    data += "<td>" + row.UserArea + "</td>";
                    data += "<td>" + row.Requester + "</td>";
                    data += "<td>" + row.TypeOfRequest + "</td>";
                    data += "<td>" + row.Status + "</td>";
                    data += "<td>" + row.Completion + "</td>";
                    data += "<td>" + row.Ageing + "</td>";
                    data += "/<tr>";
                });

                $("#tbodyReport").html(data);

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
        }
    });

    $("#btnPrint").click(function () {

        var printWindow = window.open('', '', 'height=400,width=780');
        printWindow.document.write(headerHtml);

        var Content = $("#divReportData").html();
        printWindow.document.write(Content);
        printWindow.document.write('</body></html>');
        printWindow.document.print();
        printWindow.document.close();
    });

   
    function inWords(num) {

        var a = ['', 'One ', 'Two ', 'Three ', 'Four ', 'Five ', 'Six ', 'Seven ', 'Eight ', 'Nine ', 'Ten ', 'Eleven ', 'Twelve ', 'Thirteen ', 'Fourteen ', 'Fifteen ', 'Sixteen ', 'Seventeen ', 'Eighteen ', 'Nineteen '];
        var b = ['', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'];

        if ((num = num.toString()).length > 9) return 'overflow';
        n = ('000000000' + num).substr(-9).match(/^(\d{2})(\d{2})(\d{2})(\d{1})(\d{2})$/);
        if (!n) return;
        var str = '';
        str += (n[1] != 0) ? (a[Number(n[1])] || b[n[1][0]] + ' ' + a[n[1][1]]) + 'crore ' : '';
        str += (n[2] != 0) ? (a[Number(n[2])] || b[n[2][0]] + ' ' + a[n[2][1]]) + 'lakh ' : '';
        str += (n[3] != 0) ? (a[Number(n[3])] || b[n[3][0]] + ' ' + a[n[3][1]]) + 'thousand ' : '';
        str += (n[4] != 0) ? (a[Number(n[4])] || b[n[4][0]] + ' ' + a[n[4][1]]) + 'hundred ' : '';
        str += (n[5] != 0) ? ((str != '') ? 'and ' : '') + (a[Number(n[5])] || b[n[5][0]] + ' ' + a[n[5][1]]) + 'only ' : '';

        return str;
    }
});

