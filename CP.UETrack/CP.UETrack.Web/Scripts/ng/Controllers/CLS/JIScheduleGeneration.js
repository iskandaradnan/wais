var Dropdownvalues = "";


$(document).ready(function () {

    
    //***************************Year*********************************//    
    var obj = {
        Year: 2020
    }

    $.get("/api/JIScheduleGeneration/GetYear", obj, function (response) {

        var result = JSON.parse(response);
        var Dropdownvalues = "<option value=''>" + "Select" + "</option>";

        if (result.YearValues.length > 0) {
            for (var i = 0; i < result.YearValues.length; i++) {
                Dropdownvalues += "<option value=" + result.YearValues[i].LovId + ">" + result.YearValues[i].FieldValue + "</option>"
            }
        }
        $("#ddlYear").html(Dropdownvalues);
    });


    //****************Month fetch*****************//
    $('#ddlMonth').append(" <option value=''>" + "Select" + "</option>");
    $('#ddlYear').change(function () {
        var Year = $('#ddlYear').val();
        $('#ddlWeek').val('');
        if (Year != '') {
            
            Dropdownvalues = '<option value="">Select</option>';
            $.get("/api/JIScheduleGeneration/GetMonth/" + Year, function (response) {
                var result = JSON.parse(response);
                if (result.MonthValues.length > 0) {
                    for (var i = 0; i < result.MonthValues.length; i++) {
                        Dropdownvalues += "<option value=" + result.MonthValues[i].LovId + ">" + result.MonthValues[i].FieldValue + "</option>"
                    }
                }
                $('#ddlMonth').html(Dropdownvalues);

            })
        }
    });

    //**********************Week fetch************************// 
    $('#ddlWeek').append(" <option value=''>" + "Select" + "</option>");
    $('#ddlMonth').change(function () {

        var YearMonth = $('#ddlYear').val() + '_' + $("#ddlMonth option:selected").text();


        $.get("/api/JIScheduleGeneration/GetWeek/" + YearMonth, function (response) {

            var result = JSON.parse(response);
            var Dropdownvalues = " <option value=''>" + "Select" + "</option>";

            if (result.WeekValues.length > 0) {
                for (var i = 0; i < result.WeekValues.length; i++) {
                    Dropdownvalues += "<option value=" + result.WeekValues[i].LovId + ">" + result.WeekValues[i].FieldValue + "</option>"
                }
            }
            $('#ddlWeek').html(Dropdownvalues);
        },
        )
    });

    $.get("/api/JIScheduleGeneration/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            Status = "";
            for (var i = 0; i < loadResult.StatusValues.length; i++) {               
                    Status += "<option value=" + loadResult.StatusValues[i].LovId + " >" + loadResult.StatusValues[i].FieldValue + "</option>";  
            }
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });


    $("#btnSave, #btnSaveandAddNew").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');

        var isFormValid = formInputValidation("formJIScheduleGeneration", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }

        var obj = {
            JIId: $("#primaryID").val(),
            CustomerId: $('#selCustomerLayout').val(),
            FacilityId: $('#selFacilityLayout').val(),
            Year: $('#ddlYear').val(),
            Month: $('#ddlMonth').val(),
            Week: $('#ddlWeek').val(),
            ScheduleList: []
        }

        $("#table1 tbody tr").each(function () {

            var row = $(this);
            var JIScheduleGenerationObj = {};
            JIScheduleGenerationObj.DocumentNo = row.find("td").eq(1).html();
            JIScheduleGenerationObj.UserAreaCode = row.find("td").eq(2).html();
            JIScheduleGenerationObj.UserAreaName = row.find("td").eq(3).html();
            JIScheduleGenerationObj.Day = row.find("td").eq(4).html();
            JIScheduleGenerationObj.TargetDate = row.find("td").eq(5).html();
            JIScheduleGenerationObj.status = $(this).children("td").find("select").children("option:selected").val();

            obj.ScheduleList.push(JIScheduleGenerationObj);
        });
      

        $.post("/Api/JIScheduleGeneration/Save", obj, function (response) {

            var result = JSON.parse(response);
            showMessage('JI Schedule Generation', CURD_MESSAGE_STATUS.SS);
            $("#primaryID").val(result.JIId);
            $("#grid").trigger('reloadGrid');

            if (CurrentbtnID == "btnSaveandAddNew") {

                EmptyFields();
                $('#tbodyResult').hide();
                $('#table_data').show();
                $('#daily').hide();

            }
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
    });

    $("#btnCancel").click(function () {
        bootbox.confirm({
            message: Messages.Reset_Alert_CONFIRMATION,
            buttons: {
                confirm: {
                    label: 'Yes',
                    className: 'btn-primary'
                },
                cancel: {
                    label: 'No',
                    className: 'btn-default'
                }
            },
            callback: function (result) {
                if (result) {
                    EmptyFields();
                    $('#tbodyResult').hide();
                    $('#table_data').show();
                    $('#daily').hide();
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            }
        });
    });
    
    $("#btnFetch").click(function () {

        var Year = $('#ddlYear').val();
        var Month = $('#ddlMonth').val();
        var Week = $('#ddlWeek').val();

        var obj = {
            Year: Year,
            Month: Month,
            Week: Week
        }
        if (Year != "" && Month != null && Week != "") {

            $.post("/api/JIScheduleGeneration/UserFetch/", obj, function (response) {

                var result = JSON.parse(response);
                $('#table_data').hide();
                $('#tbodyResult').show();
                $('#tbodyResult').html('');

                //**************Fetched data from Master page in Dept*****************//
                var trStru = "";
                for (var i = 0; i < result.ScheduleList.length; i++) {                  

                    //************Auto Generated Code**************//
                    var Docu = 'WAC/';
                    Docu = Docu + result.ScheduleList[i].UserAreaCode + '/';
                    Docu = Docu + 'JI' + '/';
                    Docu = Docu + $('#ddlYear').val() + '/';
                    Docu = Docu + $('#ddlMonth').val() + '/';
                    Docu = Docu + $('#ddlWeek').val();
                    var j = i + 1;

                    trStru = "<tr><td>" + j + " <input type='hidden' value ='" + result.ScheduleList[i].UserAreaLocations + "'/></td>"
                        + "<td>" + Docu + "</td>"
                        + "<td>" + result.ScheduleList[i].UserAreaCode + "</td>"
                        + "<td>" + result.ScheduleList[i].UserAreaName + "</td>"
                        + "<td>" + result.ScheduleList[i].Day + "</td>"
                        + "<td>" + result.ScheduleList[i].TargetDate + "</td>"
                        + "<td>" + "<select disabled id='Status" + j + "'>" + Status + "</select></td></tr>"

                    $('#tbodyResult').append(trStru);
                    $('#Status' + j).val(result.ScheduleList[i].Status);

                   
                }

                
                $('#tbodyResult').find("select").addClass("form-control");

                
            },"json")
                .fail(function (response) {
                    var errorMessage = "";
                    if (response.status == 400) {
                        errorMessage = response.responseJSON;
                    }
                    else {
                        errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
                    }
                });
        }
        else {
            bootbox.alert("Please fill the above fields");
        }
    });

    //******************************PRINT BUTTON***********************************//
    $("#btnPrint").click(function () {
        
        var printWindow = window.open('', '', 'height=400,width=800');
        var tblHeader = '';
        var tblUserArea = '';
       
        var tblReportHeader = '<div class="table-responsive" > <table> <tr> <td style="border:0px;"> <img alt="Portal Rasmi Kementerian Kesihatan Malaysia" class="n3VNCb" src="../images/prohawk.png" data-noaft="1" jsname="HiaYvf" jsaction="load:XAeZkd;" style="height: 26px; margin: 1px 0px;"> </td> <td style="border:0px;">  <h5 style="text-align:center; font-size:11.5px;  margin-top: 10px; margin-bottom:1px; margin-right: 10px;  margin-left: 10px;" > <b>JOINT INSPECTION CHECKLIST</b></h5> </td> <td style="border:0px;">  <img alt="UEM Edgenta Berhad | LinkedIn" class="n3VNCb" src="../images/report_logo.png" data-noaft="1" jsname="HiaYvf" jsaction="load:XAeZkd;" style="height: 50px; margin: 1px 0px;float:right ">	 </td> </tr> </table>';
                
        var tblInspected = '<table> <tr> <td> Inspected by Hospital / Institution </td> <td> Inspected by Concession Company / Date Verification Officer 1 (DVO1) </td> </tr> <tr><td>Signature: <br><br> Name: <br><br> </td>  <td> Signature: <br><br>  Name: <br><br> </td></tr>   <tr> <td>Date Inspected:</td> <td></td></tr> </table > ';

        var tblQualityRating = '<table style="text-align:center;"><tr> <td colspan="3"> Quality Rating for items inspected </td> </tr> <tr><td> Rating </td> <td> Total </td> <td> Deduction Formula Rating</td> </tr> <tr><td> NO (N) </td> <td></td> <td> Unsatisfactory</td> </tr> <tr><td> YES (Y) </td> <td></td> <td> Satisfactory </td> </tr> <tr><td> STUBBORN STRAIN (S) </td> <td></td> <td> Unsatisfactory </td> </tr> <tr><td> NOT Applicable (NA) </td> <td></td> <td> NOT Applicable</td> </tr> <tr><td> Grand Total </td> <td colspan="2"></td>  </tr></table>';

        var tblNotes = '<b> Notes: </b><table><tr> <td rowspan="2"> NO (N) </td>  <td> Visible any Surface strains, dust, oobweb, algae/fungus, litter, blocked drains</td> </tr> <tr> <td> Bad odour </td> </tr> <tr>  <td>S</td> <td>  Stubborn strain <br> - The condition Appraisal must be produced by the Company and shall acceptable by Hospital Directors </td></tr> </table>';
                
        var tblDate = '<table><tbody><tr><td rowspan="4" style="width:32%; text-align:center;">  Date Verification Officer 2 (DVO2): </td></tr> <tr> <td> Signature: <br><br> </td> </tr> <tr> <td>Name: <br><br></td></tr><tr><td> Date: <br><br></td> </tr> </tbody></table>';

        var divRemarks = '<div> Remarks: <br> 1) State Cause beside every Unsatisfactory rating <br> 2) QAP Cause Code: <br> |QH1 - Surface strain |QH2 - Dust |QH3: Litter  |QH4 - Bad Odour |QH5 - Cobweb |QH6 - Algae/Fungus <br> |QH7 - Blocked drains |QH8 - FEMS related |QH9 - Permanent strain |QH10 - Manpower <br> |QH11 - Equipment/Tools   |QH12 - Uncontrolled environment |QH13 - Vendor related |QH14 - Vandalism </div>';

        var tblFooter = '<table><tr><td style="border:0px; width:28%;">' + tblInspected + '</td><td style="border:0px;  width:7%;"></td><td style="border:0px;">' + tblQualityRating + '</td><td style="border:0px; width:25%;">' + tblNotes + '</td></tr>';

        tblFooter += '<tr><td style="border:0px;">' + tblDate + '</td><td style="border:0px; width:7%;""></td><td colspan="2" style="border:0px;">' + divRemarks + '</td></tr></table>';

        printWindow.document.write('<html><head><title></title>');
        printWindow.document.write('<style> body{ font-size: 10px !important; } .table-responsive { height:970px; overflow: hidden; page-break-after: always; }  .rptHeader{ text-align: left; background-color:lightgray; color:black; border:1px solid black } .highlited {  color: red; - webkit - print - color - adjust: exact;} @media print { .highlited { color: red!important;-webkit - print - color - adjust: exact; }} table td {  border: 0.1em solid black;   border-collapse: collapse;  padding: 1.5px;  }  table {  border-collapse: collapse; width: 100%; font-size: 10px !important; } .tblUserArea { width: 100%; } span { text-decoration: underline; }</style >');

        printWindow.document.write('</head><body>');

        tblHeader = '<table class="tblLocations"><tr><td style="width:1%;">No</td><td style="width:15%;text-align: center;">User Location Code</td><td style="width:30%;text-align: center;">User Location</td><td style="width:5%;text-align: center;">Floor</td><td style="width:5%;text-align: center;">Walls</td><td style="width:5%;text-align: center;">Ceilings</td><td style="width:5%;text-align: center;">Windows &amp; Doors</td><td style="width:5%;text-align: center;">Receptacles &amp; Containers</td><td style="width:5%;text-align: center;">Furniture, Fixtures &amp; Equipments</td><td style="width:24%;text-align: center;">Comments</td></tr>';

         
        $('#tbodyResult tr').each(function () {

            var varTr = $(this);
            
            if (varTr[0].children[6].children[0].selectedOptions[0].innerHTML == "Open") {

                var UserAreaLocations = varTr[0].children[0].children[0].value;

                tblUserArea = '<table class="tblUserArea"><tr>';
                tblUserArea += '<td style="border: 0px;">Hospital / Institution:  <span> Hospital Tunku Azizah </span> </td>';
                tblUserArea += '<td style="border: 0px;"> Document No:  <span> ' + varTr[0].children[1].innerText + '</span></td></tr>';

                tblUserArea += '<tr><td style="border: 0px;"> User Area:  <span> ' + varTr[0].children[3].innerText + '</span> </td>';
                tblUserArea += '<td style="border: 0px;"> Calendar Week:  <span> ' + $('#ddlWeek').val() + '</span></td>';
                tblUserArea += '</tr></table>';

                printWindow.document.write(tblReportHeader);
                printWindow.document.write(tblUserArea);
                printWindow.document.write(tblHeader);

                var locations = [];
                var locationLength = 0;
                var idNum = 1;
                var tblLocations = "";

                if (UserAreaLocations != '') {

                    locations = jQuery.parseJSON(UserAreaLocations);

                    locationLength = locations.length;                   

                    $.each(locations, function (index) {

                        tblLocations += "<tr><td style='height: 28px;'>" + idNum + "</td>";
                        tblLocations += "<td>" + locations[index].UserLocationCode + "</td>";
                        tblLocations += "<td>" + locations[index].UserLocationName + "</td>";
                        tblLocations += "<td style='text-align:center;'>" + locations[index].F + "</td>";
                        tblLocations += "<td style='text-align:center;'>" + locations[index].W + "</td>";
                        tblLocations += "<td style='text-align:center;'>" + locations[index].C + "</td>";
                        tblLocations += "<td style='text-align:center;'>" + locations[index].WD + "</td>";
                        tblLocations += "<td style='text-align:center;'>" + locations[index].R + "</td>";
                        tblLocations += "<td style='text-align:center;'>" + locations[index].FF + "</td><td></td></tr>";

                        idNum += 1;

                        if (idNum == 24 || idNum == 47 || idNum == 70 || idNum == 95) {

                            printWindow.document.write(tblLocations);
                            printWindow.document.write("</table>");
                            printWindow.document.write(tblFooter);

                            tblLocations = "";
                            printWindow.document.write("</div>");
                            printWindow.document.write(tblReportHeader);
                            printWindow.document.write(tblUserArea);
                            printWindow.document.write(tblHeader);

                            locationLength = locationLength - 23;
                        }

                    });
                }

                if (locationLength < 23) {

                    var i = 0;
                    for (i = locationLength; i < 23; i++) {

                        tblLocations += "<tr><td style='height: 28px;'>" + idNum + "</td>";
                        tblLocations += "<td></td>";
                        tblLocations += "<td></td>";
                        tblLocations += "<td></td>";
                        tblLocations += "<td></td>";
                        tblLocations += "<td></td>";
                        tblLocations += "<td></td>";
                        tblLocations += "<td></td>";
                        tblLocations += "<td><td></tr>";

                        idNum += 1;
                    }
                }

                printWindow.document.write(tblLocations);
                printWindow.document.write("</table>");
                printWindow.document.write(tblFooter);
            }

            printWindow.document.write("</div>");
        });



        printWindow.document.write('</body></html>');        
        printWindow.document.print();
        printWindow.document.close();



    });


    var getUrlParameter = function getUrlParameter(sParam) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');
            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : sParameterName[1];
            }
        }
    };
    var ID = getUrlParameter('id');
    if (ID == null || ID == undefined || ID == 0 || ID == '' || ID == "") {
        $("#jQGridCollapse1").click();
    }
    else {
        LinkClicked(ID);
    }

    var getUrlParameter = function getUrlParameter(sParam) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');
            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : sParameterName[1];
            }
        }
    };
    var ID = getUrlParameter('id');
    if (ID == null || ID == undefined || ID == 0 || ID == '' || ID == "") {
        $("#jQGridCollapse1").click();
    }
    else {
        LinkClicked(ID);
    }
});

function EmptyFields() {

    $('#formJIScheduleGeneration')[0].reset();
    $('#errorMsg').css('visibility', 'hidden');
    $('#Yeardiv').removeClass('has-error');
    $('#Month').removeClass('has-error');
    $('#Week').removeClass('has-error');
    $(".content").scrollTop(0);
    $('#ddlYear').val('');
    $('#ddlMonth').val('');
    $('#ddlWeek').val('');

    $('#tbodyResult').html('');
    //$('#JiDocumentNo').val('');
    //$('#JiUserAreaCode').val('');
    //$('#JiUserAreaName').val('');
    //$('#JiDay').val('');
    //$('#JiTargetDate').val('');
    //$('#JiStatus').val('');
}

function LinkClicked(id) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formJIScheduleGeneration :input:not(:button)").parent().removeClass('has-error');
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
        $("#formJIScheduleGeneration :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    $('#myPleaseWait').modal('show');
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/JIScheduleGeneration/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
               
                if (getResult != undefined) {
                    //$('#ddlMonth').html(Dropdownvalues);
                    var Year = getResult.Year;
                    var Month = getResult.Month;
                    var Week = getResult.Week;

                    $('#ddlYear').val(Year);

                    $.get("/api/JIScheduleGeneration/GetMonth/" + Year, function (response) {
                        var result = JSON.parse(response);

                        Dropdownvalues = " <option value=''>" + "Select" + "</option>";

                        if (result.MonthValues.length > 0) {
                            for (var i = 0; i < result.MonthValues.length; i++) {
                                Dropdownvalues += "<option value=" + result.MonthValues[i].LovId + ">" + result.MonthValues[i].FieldValue + "</option>"
                            }
                        }
                        $('#ddlMonth').html(Dropdownvalues);
                        $('#ddlMonth').val(Month);


                        var YearMonth = Year + '_' + $("#ddlMonth option:selected").text();

                        $.get("/api/JIScheduleGeneration/GetWeek/" + YearMonth, function (response) {

                            var result = JSON.parse(response);
                            var Dropdownvalues = " <option value=''>" + "Select" + "</option>";

                            if (result.WeekValues.length > 0) {
                                for (var i = 0; i < result.WeekValues.length; i++) {
                                    Dropdownvalues += "<option value=" + result.WeekValues[i].LovId + ">" + result.WeekValues[i].FieldValue + "</option>"
                                }
                            }
                            $('#ddlWeek').html(Dropdownvalues);
                            $('#ddlWeek').val(Week);
                        });


                    });                                    
              
                }


                if (getResult.ScheduleList != null) {

                    $('#tbodyResult').show();
                    $('#tbodyResult').html('');
                    var rowlength = getResult.ScheduleList.length;
                    var trStruGrid = "";
                    for (var i = 0; i < rowlength; i++) {
                        var j = i + 1;
                        trStruGrid = "<tr><td>" + j + " <input type='hidden' value='" + getResult.ScheduleList[i].UserAreaLocations + "' /> </td>"
                            + "<td>" + getResult.ScheduleList[i].DocumentNo + "</td>"
                            + "<td>" + getResult.ScheduleList[i].UserAreaCode + "</td>"
                            + "<td>" + getResult.ScheduleList[i].UserAreaName + "</td>"
                            + "<td>" + getResult.ScheduleList[i].Day + "</td>"
                            + "<td>" + getResult.ScheduleList[i].TargetDate + "</td>"
                            + "<td>" + "<select disabled id='Status" + j + "'>" + Status + "</select ></td ></tr>"


                        $('#tbodyResult').append(trStruGrid);
                        $('#Status' + j).val(getResult.ScheduleList[i].Status);

                    }
                    $('#table_data').hide();
                   
                    $('#tbodyResult').find("select").addClass("form-control");
                }
                else {
                    $('#tbodyResult').html('');
                }
                $('#myPleaseWait').modal('hide');

                

            })
            .fail(function () {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');
            });



    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}

$("#jQGridCollapse1").click(function () {
    var pro = new Promise(function (res, err) {
        $(".jqContainer").toggleClass("hide_container");
        res(1);
    })
    pro.then(
        function resposes() {
            setTimeout(() => $(".content").scrollTop(3000), 1);
        })
});



function locationDetails() {

    var count = 1;

    var tblLocations = '';

    $('#tbodyResult tr').each(function () {

        

        var varTr = $(this);
        var deptAreaId = varTr[0].children[0].children[0].value;

        $.ajax({
            url: "/api/DeptAreaDetails/Get/" + deptAreaId,
            type: 'GET',
            async: false,
            cache: false,
            timeout: 30000,
            fail: function () {
                return '';
            },
            done: function (result) {

                var getResult = JSON.parse(result);

                tblLocations += "<table>";

                if (getResult.LocationDetailsList != null) {

                    for (i = 0; i < getResult.LocationDetailsList.length; i++) {

                        var idNum = i + 1;

                        tblLocations += "<tr><td>" + idNum + "</td>";
                        tblLocations += "<td>" + getResult.LocationDetailsList[i].LocationCode + "</td>";
                        tblLocations += "<td></td>";
                        tblLocations += "<td></td>";
                        tblLocations += "<td></td>";
                        tblLocations += "<td></td>";
                        tblLocations += "<td></td>";
                        tblLocations += "<td></td>";
                        tblLocations += "<td></td>";
                        tblLocations += "<td><td></tr>";
                    }
                }

                tblLocations += "</table>";


            }

        });

        

    });
    
    
}





