
$(document).ready(function () {

    var headerHtml = '<html><head><title></title><style> body{ font-size: 10px !important; } .row {  margin-left:-10px;  margin-right:-10px;} .col-sm-3 { width:25%; } .col-sm-6 { width:50%; } .table-responsive { height:970px; overflow: hidden; page-break-after: always; }  .rptHeader{ text-align: left; background-color:lightgray; color:black; border:1px solid black } .highlited {  color: red; - webkit - print - color - adjust: exact;} @media print { .highlited { color: red!important;   -webkit-print-color-adjust: exact; }} table td {  border: 0.1em solid black;   border-collapse: collapse;  padding: 1.5px;  }  table {  border-collapse: collapse; width: 100%; font-size: 10px !important; } .tblUserArea { width: 100%; } span { text-decoration: underline; }</style></head><body>';
    var rowNumber = 0;

    $.get("/api/CLSReports/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            var MonthVal = "<option value='' Selected>Select</option>"
            var YearVal = "<option value='' Selected>Select</option>"
            var RequestTypeVal = "<option value=''>Select</option><option value='Incident'>Incident</option><option value='Non-Conformance'>Non-Conformance</option><option value='User Request'>User Request</option>"

            for (var i = 0; i < loadResult.YearLovs.length; i++) {
                YearVal += "<option value=" + loadResult.YearLovs[i].LovId + ">" + loadResult.YearLovs[i].FieldValue + "</option>"
            }
            $("#ddlYear").append(YearVal);

            for (var i = 0; i < loadResult.MonthLovs.length; i++) {
                MonthVal += "<option value=" + loadResult.MonthLovs[i].LovId + ">" + loadResult.MonthLovs[i].FieldValue + "</option>"
            }
            $("#ddlMonth").append(MonthVal);
            $('#myPleaseWait').modal('hide');
            $("#ddlRequestType").append(RequestTypeVal);

        })
        .fail(function (response) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            $('#errorMsgConfigAdditionalFields').css('visibility', 'visible');
        });

    $('#ddlMonth').change(function () {
        $("div.errormsgcenter").text('');
        $('#errorMsg').css('visibility', 'hidden');        
        $('#MonthVal').removeClass('has-error');        
    });
    $('#ddlYear').change(function () {
        $("div.errormsgcenter").text('');
        $('#errorMsg').css('visibility', 'hidden');
        $('#YearVal').removeClass('has-error');
    });
    $('#ddlRequestType').change(function () {
        $("div.errormsgcenter").text('');
        $('#errorMsg').css('visibility', 'hidden');
        $('#RequestType').removeClass('has-error');
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

   

    $("#btnJointInspectionFetch").click(function () {
       
        if (validateForm("formJointInspection")) {

            $('#tdYear').html($('#ddlYear')[0].options[$('#ddlYear')[0].selectedIndex].innerHTML);
            $('#tdMonth').html($('#ddlMonth')[0].options[$('#ddlMonth')[0].selectedIndex].innerHTML);

            var obj = {
                Year: $('#ddlYear').val(),
                Month: $('#ddlMonth').val()
            }

            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');

            $.post("/api/CLSReports/JointInspectionSummaryReportFetch", obj, function (response) {

                var result = JSON.parse(response);
                var dataList = result.JISummaryReportsList;
                var data = "";

                $.each(dataList, function (index, row) {

                    rowNumber = index + 1;

                    data += "<tr>";
                    data += "<td>" + rowNumber + "</td>";
                    data += "<td>" + row.UserAreaCode + "</td>";
                    data += "<td>" + row.UserAreaName + "</td>";
                    data += "<td>" + row.InspectionScheduled + "</td>";
                    data += "<td>" + row.Compliance + "</td>";
                    data += "<td>" + row.NonCompliance + "</td>";
                    data += "<td>" + row.TotalRatings + "</td>";
                    data += "<td>" + row.NoOfUserLocationsInspected + "</td>";
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
   
    $("#btnDailyCleaningActivitytFetch").click(function () {

        if (validateForm("formDailyCleaningActivity")) {

            $('#tdYear').html($('#ddlYear')[0].options[$('#ddlYear')[0].selectedIndex].innerHTML);
            $('#tdMonth').html($('#ddlMonth')[0].options[$('#ddlMonth')[0].selectedIndex].innerHTML);

            var obj = {
                Year: $('#ddlYear').val(),
                Month: $('#ddlMonth').val()
            }

            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');

            $.post("/api/CLSReports/DailyCleaningActivitySummaryReportFetch", obj, function (response) {

                var result = JSON.parse(response);
                var dataList = result.DailyCleaningActivitySummaryReportFetchList;
                var data = "";

                $.each(dataList, function (index, row) {
                    rowNumber = index + 1;
                    data += "<tr>";
                    data += "<td>" + rowNumber + "</td>";
                    data += "<td>" + row.UserAreaCode + "</td>";
                    data += "<td>" + row.UserArea + "</td>";
                    data += "<td>" + row.A1 + "</td>";
                    data += "<td>" + row.A2 + "</td>";
                    data += "<td>" + row.A3 + "</td>";
                    data += "<td>" + row.A4 + "</td>";
                    data += "<td>" + row.B1 + "</td>";
                    data += "<td>" + row.C1 + "</td>";
                    data += "<td>" + row.D1 + "</td>";
                    data += "<td>" + row.D2 + "</td>";
                    data += "<td>" + row.D3 + "</td>";
                    data += "<td>" + row.E1 + "</td>";
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

    $("#btnPeriodicWorkRecordFetch").click(function () {

        if (validateForm("formPeriodicWorksummaryRecord")) {

            $('#tdYear').html($('#ddlYear')[0].options[$('#ddlYear')[0].selectedIndex].innerHTML);
            $('#tdMonth').html($('#ddlMonth')[0].options[$('#ddlMonth')[0].selectedIndex].innerHTML);

            var obj = {
                Year: $('#ddlYear').val(),
                Month: $('#ddlMonth').val()
            }

            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');

            $.post("/api/CLSReports/PeriodicWorkRecordSummaryReportFetch", obj, function (response) {

                var result = JSON.parse(response);
                var dataList = result.PeriodicWorkRecordSummaryReportsList;
                var data = "";

                $.each(dataList, function (index, row) {
                    rowNumber = index + 1;
                    data += "<tr>";
                    data += "<td>" + rowNumber + "</td>";
                    data += "<td>" + row.UserAreaCode + "</td>";
                    data += "<td>" + row.UserArea + "</td>";
                    data += "<td>" + row.Done + "</td>";
                    data += "<td>" + row.NotDone + "</td>";
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

    $("#btnToiletInspectionFetch").click(function () {

        if (validateForm("formToiletInspection")) {

            $('#tdYear').html($('#ddlYear')[0].options[$('#ddlYear')[0].selectedIndex].innerHTML);
            $('#tdMonth').html($('#ddlMonth')[0].options[$('#ddlMonth')[0].selectedIndex].innerHTML);

            var obj = {
                Year: $('#ddlYear').val(),
                Month: $('#ddlMonth').val()
            }

            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');

            $.post("/api/CLSReports/ToiletInspectionSummaryReportFetch", obj, function (response) {

                var result = JSON.parse(response);
                var dataList = result.ToiletInspReportList;
                var data = "";

                $.each(dataList, function (index, row) {
                    rowNumber = index + 1;
                    data += "<tr>";
                    data += "<td>" + rowNumber + "</td>";
                    data += "<td>" + row.TotalToiletLocations + "</td>";
                    data += "<td>" + row.TotalDone + "</td>";
                    data += "<td>" + row.TotalNotDone + "</td>";
                    data += "/<tr>";
                });

                if (dataList == null)
                    data = "<tr><td colspan='4' style=' text-align: center; font-weight: bold;'> No date available for the following month </td></tr>"

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

    $("#btnEquipmentReportFetch").click(function () {

        if (validateForm("formEquipmentReport")) {

            $('#tdYear').html($('#ddlYear')[0].options[$('#ddlYear')[0].selectedIndex].innerHTML);
            $('#tdMonth').html($('#ddlMonth')[0].options[$('#ddlMonth')[0].selectedIndex].innerHTML);

            var obj = {
                Year: $('#ddlYear').val(),
                Month: $('#ddlMonth').val()
            }

            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');

            $.post("/api/CLSReports/EquipmentReportFetch", obj, function (response) {

                var result = JSON.parse(response);
                var dataList = result.EquipmentReportList;
                var data = "";

                $.each(dataList, function (index, row) {
                    rowNumber = index + 1;
                    data += "<tr>";
                    data += "<td>" + rowNumber + "</td>";
                    data += "<td>" + row.EquipmentCode + "</td>";
                    data += "<td>" + row.EquipmentDescription + "</td>";
                    data += "<td>" + row.Quantity + "</td>";
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

    $("#btnChemicalUsedReportFetch").click(function () {

        if (validateForm("formChemicalUsedReport")) {

            $('#tdYear').html($('#ddlYear')[0].options[$('#ddlYear')[0].selectedIndex].innerHTML);
            $('#tdMonth').html($('#ddlMonth')[0].options[$('#ddlMonth')[0].selectedIndex].innerHTML);

            var obj = {
                Year: $('#ddlYear').val(),
                Month: $('#ddlMonth').val()
            }

            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');

            $.post("/api/CLSReports/ChemicalUsedReportFetch", obj, function (response) {

                var result = JSON.parse(response);
                var dataList = result.ChemicalReportList;
                var data = "";

                $.each(dataList, function (index, row) {
                    rowNumber = index + 1;
                    data += "<tr>";
                    data += "<td>" + rowNumber + "</td>";
                    data += "<td>" + row.ChemicalName + "</td>";
                    data += "<td>" + row.KMMNO + "</td>";
                    data += "<td>" + row.Category + "</td>";
                    data += "<td>" + row.AreaofApplication + "</td>";
                    data += "<td>" + row.Properties + "</td>";
                    data += "<td>" + row.Status + "</td>";
                    data += "<td>" + row.EffectiveDate + "</td>";
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
                });        }
    });

    $("#btnCRMReportFetch").click(function () {

        if (validateForm("formCRMReport")) {

            $('#tdYear').html($('#ddlYear')[0].options[$('#ddlYear')[0].selectedIndex].innerHTML);
            $('#tdMonth').html($('#ddlMonth')[0].options[$('#ddlMonth')[0].selectedIndex].innerHTML);

            var obj = {
                Year: $('#ddlYear').val(),
                Month: $('#ddlMonth').val()
            }

            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');

            $.post("/api/CLSReports/CRMReportFetch", obj, function (response) {

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
});
