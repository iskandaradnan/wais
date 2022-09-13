//*Global variables decration section starts*//
var pageindex = 1, pagesize = 5;
var GridtotalRecords = 0;
var TotalPages = 0, FirstRecord = 0, LastRecord = 0;
//*Golbal variables decration section ends*//

var montharray = [];
//var weekarray = [];
//var dayarray = [];
var AssetDetails = [];
var SummaryDetails = [];

var MonthIds = [
        "CheckJan",
        "CheckFeb",
        "CheckMar",
        "CheckApr",
        "CheckMay",
        "CheckJun",
        "CheckJul",
        "CheckAug",
        "CheckSep",
        "CheckOct",
        "CheckNov",
        "CheckDec"
];

var currentYear = 0;
var currentMonth = 0;


$(function () {
    $('#Date').multiselect();
})

$(function () {

    $('#btnDelete').hide();
    $('#btnEdit').hide();
    formInputValidation("formriplanner");

    $.get("/api/PPMPlanner/Load")
         .done(function (result) {
             var loadResult = JSON.parse(result);
             $("#jQGridCollapse1").click();

             $.each(loadResult.YearList, function (index, value) {
                 $('#Year').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
             });
            
             $.each(loadResult.ScheduleList, function (index, value) {
                 $('#Schedule').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
             });
             $.each(loadResult.StatusList, function (index, value) {
                 $('#Status').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
             });

             var options = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"];
             $('#Date').empty();
             var optionHtml = "";
             $.each(options, function (i, p) {
                 optionHtml += '<option value="' + p + '">' + p + '</option>';
             });
             $("#Date").html(optionHtml);
             setTimeout(multiSelectshow, 10);

             $.each(loadResult.YearList, function (index, value) {
                 $('#SummaryYear').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
             });

             currentYear = loadResult.CurrentYear;
             currentMonth = loadResult.CurrentMonth;

             $('#Year').val(currentYear);
             DisableEnableMonthCheckBoxes();

             $('#Status').val(1);
             $('#Schedule').val(78);
             ScheduleChange();
             SummaryData();

         })
  .fail(function (response) {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
      $('#errorMsg').css('visibility', 'visible');
  });
   

    $("#btnSave,#btnEdit,#btnSaveandAddNew").click(function () {
      
        var Schedule = $('#Schedule').val();
        var MonthString = montharray.toString();
        //var WeekString = weekarray.toString();
        //var DayString = dayarray.toString();
        var TypeCodeHiddenValue = $('#hdnAssetTypeCodeId').val();
        var DateList = Multiselect($("#Date option:selected"));
        var TypeCodeValue = $('#txtAssetTypeCode').val();
        if ((Schedule == "78") && (MonthString == "" || DateList == "")) {
            bootbox.alert("Month & Date Should not be empty!")
            return false;
        }

        if (TypeCodeValue != "" && TypeCodeHiddenValue == "") {
            bootbox.alert("Valid Type Code required!");
            return false;
        }
        //if ((Schedule == "79") && (MonthString == "" || WeekString == "" || DayString == "")) {
        //    bootbox.alert("Month , Week & Day Should not be empty!")
        //    return false;
        //}

        var dummy = CheckFeb();
        var dummyDay = CheckDays();
        if (dummy == false) {
            return false;
        }
        if (dummyDay == false) {
            return false;
        }

        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var CurrentbtnID = $(this).attr("Id");
        function Multiselect(selectID) {
            var selectedCompData = $.map(selectID, function (el, i) { return $(el).val(); })
            return selectedCompData.join();
        }

        var primaryId = $("#primaryID").val();
        var ServiceId = 2;
        var WorkGroupId = 1;
        var Year = $('#Year').val();
        var UserAreaId = $('#hdnUserAreaId').val();
        var AssigneeId = $('#hdnAssigneeId').val();
        var FacRepId = $('#hdnHospitalRepresentativeId').val();
        var AssetTypeCodeId = $('#hdnAssetTypeCodeId').val();
        var AssetId = $('#hdnAssetId').val();
        var Status = $('#Status').val();
        var EngineerId = $('#hdnEngineerId').val();
        var Timestamp = $('#Timestamp').val();
        //var FacRep = $('#txtHospitalRepresentative').val();   
       
        var obj = {
            PlannerId: primaryId,
            ServiceId: ServiceId,
            WorkGroup: WorkGroupId,
            AssetRegisterId: null,
            TypeOfPlanner: 35,
            Year: Year,
            UserAreaId: UserAreaId,
            FacRepId: FacRepId,
            AssigneeId: AssigneeId,
            AssetTypeCodeId: AssetTypeCodeId,
            AssetRegisterId: AssetId,
            //HospitalRepresentativeId: HospitalRepresentativeId,
            Schedule: Schedule,
            Status: Status,
            EngineerId: null,
            Month: MonthString,
            Date: DateList,
            //Week: WeekString,
            //Day: DayString,
            WorkOrderType: 35,
            Timestamp: Timestamp,
            TaskCodeOption: null,
            FirstDate: null,
            FrequencyId: null,

            //Timestamp: (primaryId != 0 || primaryId != null) ? primaryId : 0,
        };
        var isFormValid = formInputValidation("formriplanner", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var jqxhr = $.post("/api/PPMPlanner/Add", obj, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.PlannerId);
            $("#Timestamp").val(result.Timestamp);
            $("#grid").trigger('reloadGrid');
            if (result.PlannerId != 0) {
                $('#Schedule').attr('disabled', true);
                $('#Year').attr('disabled', true);
                $('#txtUserAreaCode').attr('disabled', true);
                $('#txtAssetNo').attr('disabled', true);
                $('#spnPopup-assetNo').hide();
                $('#txtAssetTypeCode').attr('disabled', true);


                $('#CheckJan').attr('disabled', true);
                $('#CheckFeb').attr('disabled', true);
                $('#CheckMar').attr('disabled', true);
                $('#CheckApr').attr('disabled', true);
                $('#CheckMay').attr('disabled', true);
                $('#CheckJun').attr('disabled', true);
                $('#CheckJul').attr('disabled', true);
                $('#CheckAug').attr('disabled', true);
                $('#CheckSep').attr('disabled', true);
                $('#CheckOct').attr('disabled', true);
                $('#CheckNov').attr('disabled', true);
                $('#CheckDec').attr('disabled', true);

                //$('#CheckWeek1').attr('disabled', true);
                //$('#CheckWeek2').attr('disabled', true);
                //$('#CheckWeek3').attr('disabled', true);
                //$('#CheckWeek4').attr('disabled', true);
                //$('#CheckWeek5').attr('disabled', true);

                //$('#CheckSun').attr('disabled', true);
                //$('#CheckMon').attr('disabled', true);
                //$('#CheckTue').attr('disabled', true);
                //$('#CheckWed').attr('disabled', true);
                //$('#CheckThu').attr('disabled', true);
                //$('#CheckFri').attr('disabled', true);
                //$('#CheckSat').attr('disabled', true);

                $('#btnEdit').show();
                $('#btnSave').hide();
                $("#btnDelete").show();
            }

            setTimeout(function () {
                $('.multiSelectDDLwithoutSearch').multiselect('rebuild');
                $(".multiselect-container").find("input").prop("disabled", true);
            }, 500)

            $(".content").scrollTop(0);
            showMessage('RI Planner', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            if (CurrentbtnID == "btnSaveandAddNew") {
                EmptyFields();
                ScheduleChange();
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
            $('#myPleaseWait').modal('hide');
        });
    });


    //RI Planner Popup
    $("#Popup").click(function () {
        var UserAreaId = $('#hdnUserAreaId').val();
        if (UserAreaId == "")
        {
            bootbox.alert("Please choose Area!");
            return false;
        }
        $('#myPleaseWait').modal('show');
        $.get("/api/PPMPlanner/Popup/" + UserAreaId + "/" + pagesize + "/" + pageindex)
     .done(function (result) {
         var getResult = JSON.parse(result);
         AssetDetails = getResult.RIPlannerPopUPDets;
         $("#PopupId").empty();
         $.each(AssetDetails, function (index, value) {
             PopUpNewRow();
             $("#SNo_" + index).val(index+1).prop("disabled", true);
             $("#AssetNo_" + index).val(value.AssetNo).prop("disabled", true);
             $("#AssetTypeCode_" + index).val(value.AssetTypeCode).prop("disabled", true);
             $("#AssetTypeDesc_" + index).val(value.AssetTypeDescription).prop("disabled", true);
         });

         if ((AssetDetails && AssetDetails.length) > 0) {
             GridtotalRecords = AssetDetails[0].TotalRecords;
             TotalPages = AssetDetails[0].TotalPages;
             LastRecord = AssetDetails[0].LastRecord;
             FirstRecord = AssetDetails[0].FirstRecord;
             pageindex = AssetDetails[0].PageIndex;
         }

         var mapIdproperty = ["SNo-SNo_","AssetNo-AssetNo_", "AssetTypeCode-AssetTypeCode_", "AssetTypeDescription-AssetTypeDesc_"];
         var htmltext = PopUpGridHtml();//Inline Html
         var obj = { formId: "#FormPenalty", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "RIPlannerPopUPDets", tableid: '#PopupId', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/PPMPlanner/Popup/" + UserAreaId, pageindex: pageindex, pagesize: pagesize };

         CreateFooterPagination(obj);

      $('#myPleaseWait').modal('hide');
      })
     .fail(function (response) {
     $('#myPleaseWait').modal('hide');
     $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
     $('#errorMsg').css('visibility', 'visible');
     });
 });

    //fetch - user area 

    var UserAreaFetchObj = {
        SearchColumn: 'txtUserAreaCode-UserAreaCode',//Id of Fetch field
        ResultColumns: ["UserAreaId-Primary Key", 'UserAreaCode-UserAreaCode', 'UserAreaName-UserAreaName', 'AssetCount-AssetCount', 'FacRep-FacRep'],
        FieldsToBeFilled: ["hdnUserAreaId-UserAreaId", "txtUserAreaCode-UserAreaCode", "txtUserAreaName-UserAreaName", "txtTotalAsset-AssetCount","hdnHospitalRepresentativeId-FacRepId","txtHospitalRepresentative-FacRep"]
    };

    $('#txtUserAreaCode').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divUserAreaFetch', UserAreaFetchObj, "/api/Fetch/UserAreaFetch", "UlFetch2", event, 1);//1 -- pageIndex
    });

    //fetch - Assignee 
    var AssigneeFetchObj = {
        SearchColumn: 'txtAssignee-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-StaffName'],
        FieldsToBeFilled: ["hdnAssigneeId-StaffMasterId", "txtAssignee-StaffName"]
    };

    $('#txtAssignee').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divtAssigneeFetch', AssigneeFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch3", event, 1);//1 -- pageIndex
    });

    //fetch - Hospital Rep 
    //var HospitalRepFetchObj = {
    //    SearchColumn: 'txtHospitalRepresentative-StaffName',//Id of Fetch field
    //    ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-StaffName'],
    //    FieldsToBeFilled: ["hdnHospitalRepresentativeId-StaffMasterId", "txtHospitalRepresentative-StaffName"]
    //};

    //$('#txtHospitalRepresentative').on('input propertychange paste keyup', function (event) {
    //    DisplayFetchResult('divHospitalRepresentativeFetch', HospitalRepFetchObj, "/api/Fetch/FacilityStaffFetch", "UlFetch4", event, 1);//1 -- pageIndex
    //});

    //fetch - Engineer 
    var EngineerFetchObj = {
        SearchColumn: 'txtEngineer-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-StaffName'],
        FieldsToBeFilled: ["hdnEngineerId-StaffMasterId", "txtEngineer-StaffName"]
    };

    $('#txtEngineer').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divEngineerFetch', EngineerFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch6", event, 1);//1 -- pageIndex
    });

    $("#btnCancel").click(function () {
        var message = Messages.Reset_Alert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                EmptyFields();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });

    $("#SummarybtnCancel").click(function () {
        var message = Messages.Reset_TabAlert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                EmptyFields();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });

});

function DisableEnableMonthCheckBoxes()
{
    var selectedYear = $('#Year').val();
    var monthCurrent = currentMonth - 1;
    for (i = 0; i < MonthIds.length; i++)
    {
        $('#' +MonthIds[i]).prop('checked', false);
        if (selectedYear == currentYear) {
            if (i < monthCurrent) {
                $('#' + MonthIds[i]).attr('disabled', true);
            }
        } else {
            $('#' + MonthIds[i]).attr('disabled', false);
        }
    }
}                   

$('#Year').change(function () {
    DisableEnableMonthCheckBoxes();
});


function ScheduleChange() {
        var Input = $("#Schedule option:selected").text();

        if (Input === ' Monthly - Date') {
            //$('#HideWeek').hide();
            //$('#HideDay').hide();
            $('#HideDate').show();
        }
        //else if (Input === 'Monthly - Day') {
        //    $('#HideWeek').show();
        //    $('#HideDay').show();
        //    $('#HideDate').hide();
        //}
        else {
            //$('#HideWeek').show();
            //$('#HideDay').show();
            $('#HideDate').show();
        }
}

                //---------------------------------------------------------------------------//

                //----------------Load month values to save------------------------------------

function LoadMonth(MonthParam,Flag) {
    if ($('#Check' + MonthParam).prop('checked') == true) {
        var result = getmonth(MonthParam, Flag);
        montharray.push(result);
    }
    else
    {
        var result = getmonth(MonthParam, Flag);
        var index = montharray.indexOf(result);
        montharray.splice(index, 1);
    }
    
}

function getmonth(MonthName, Flag) {
    var result = null;
    var MonthList = [{ Month : "Jan" , value : 1 }, {  Month : "Feb" , value : 2 }, {  Month : "Mar" , value : 3 }, { Month : "Apr" , value : 4 }, { Month : "May" , value : 5 }, { Month : "Jun" , value : 6 },
{ Month: "Jul", value: 7 }, { Month: "Aug", value: 8 }, { Month: "Sep", value: 9 }, { Month: "Oct", value: 10 }, { Month: "Nov", value: 11 }, { Month: "Dec", value: 12 }];

if(Flag=="String")
     result = Enumerable.From(MonthList).Where("x=>x.Month =='" + MonthName + "'").Select("x=>x.value").FirstOrDefault();
else if (Flag == "Int")
     result = Enumerable.From(MonthList).Where("x=>x.value == " + MonthName).Select("x=>x.Month").FirstOrDefault();

    return result;
}


                        //----------------Load Week values to save------------------------------------

function LoadWeek(WeekParam, Flag) {
    if ($('#Check' + WeekParam).prop('checked') == true) {
        var result = getweek(WeekParam, Flag);
        weekarray.push(result);
    }
    else {
        var result = getweek(WeekParam, Flag);
        var index = weekarray.indexOf(result);
        weekarray.splice(index, 1);
    }

}

//function getweek(WeekName, Flag) {
//    var result = null;
//    var WeekList = [{ Week: "Week1", value: 1 }, { Week: "Week2", value: 2 }, { Week: "Week3", value: 3 }, { Week: "Week4", value: 4 }, { Week: "Week5", value: 5 }];
//    if (Flag == "String")
//        result = Enumerable.From(WeekList).Where("x=>x.Week =='" + WeekName + "'").Select("x=>x.value").FirstOrDefault();
//    else if (Flag == "Int")
//        result = Enumerable.From(WeekList).Where("x=>x.value == " + WeekName).Select("x=>x.Week").FirstOrDefault();

//    return result;
//}



                       //----------------Load Day values to save------------------------------------

//function LoadDay(DayParam, Flag) {
//    if ($('#Check' + DayParam).prop('checked') == true) {
//        var result = getday(DayParam, Flag);
//        dayarray.push(result);
//    }
//    else {
//        var result = getday(DayParam, Flag);
//        var index = dayarray.indexOf(result);
//        dayarray.splice(index, 1);
//    }

//}

//function getday(DayName, Flag) {
//    var result = null;
//    var DayList = [{ Day: "Sun", value: 1 }, { Day: "Mon", value: 2 }, { Day: "Tue", value: 3 }, { Day: "Wed", value: 4 }, { Day: "Thu", value: 5 }, { Day: "Fri", value: 6 }, { Day: "Sat", value: 7 }];
//    if (Flag == "String")
//        result = Enumerable.From(DayList).Where("x=>x.Day =='" + DayName + "'").Select("x=>x.value").FirstOrDefault();
//    else if (Flag == "Int")
//        result = Enumerable.From(DayList).Where("x=>x.value == " + DayName).Select("x=>x.Day").FirstOrDefault();

//    return result;
//}



                //----------------------------Month & Date Validation------------------------------

function CheckDays() {
    var message = "";
    var DateSelected = Multiselect($("#Date option:selected")).split(",");
    function Multiselect(selectID) {
        var selectedCompData = $.map(selectID, function (el, i) { return $(el).val(); })
        return selectedCompData.join();
    }  

    if (Enumerable.From(montharray).Any("$ == 4 || $ == 6 || $ == 9 || $ == 11"))
    {
        if (Enumerable.From(montharray).Any("$ == 4"))
        {
            message = "April";
        }
        if (Enumerable.From(montharray).Any("$ == 6")) {
            message = message + " " + ',' + "June";
        }
        if (Enumerable.From(montharray).Any("$ == 9")) {
            message = message + " " + ',' + "September";
        }
        if (Enumerable.From(montharray).Any("$ == 11")) {
            message = message + " " + ',' + "November";
        }
        if (Enumerable.From(DateSelected).Any("$ > 30")) {
            message = message.indexOf(',') == 1 ? message.replace(",", "") : message;
            bootbox.alert(message + " " + "has only 30 Days!")
            return false;
        }
       
    }
    
}

function CheckFeb()
{
var temp = $("#Year option:selected").text();
var Year = parseInt(temp);
var IsLeap = FindLeap(Year);
var DateSelected = Multiselect($("#Date option:selected")).split(",");
function Multiselect(selectID) {
    var selectedCompData = $.map(selectID, function (el, i) { return $(el).val(); })
    return selectedCompData.join();
}
function FindLeap(Year)
{
    var result = false;
    if (Year % 4 == 0)
        result = true;
    return result;
}

if (Enumerable.From(montharray).Any("$ == 2"))
{
    if (IsLeap == true && Enumerable.From(DateSelected).Any("$ > 29"))
    {
        bootbox.alert("February has only 29 Days!")
        return false;
    }
    if (IsLeap == false && Enumerable.From(DateSelected).Any("$ > 28"))
    {
        bootbox.alert("February has only 28 Days!")
        return false;
    }

}
}

function PopUpNewRow() {

    var inputpar = {
        inlineHTML: PopUpGridHtml(),//Inline Html
        TargetId: "#PopupId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
}

function PopUpGridHtml() {

    return '<tr>' +
          '<td width="10%" style="text-align: center;" title=""><div><input disabled id="SNo_maxindexval"  type="text" class="form-control" name="SNo" autocomplete="off"></div></td>' +
            '<td width="30%" style="text-align: center;" title=""><div><input disabled id="AssetNo_maxindexval"  type="text" class="form-control" name="AssetNo" autocomplete="off"></div></td>' +
            '<td width="30%" style="text-align: center;" title=""><div><input disabled id="AssetTypeCode_maxindexval" type="text" class="form-control" name="AssetTypeCode" autocomplete="off"></div></td>' +
            '<td width="30%" style="text-align: center;" title=""><div><input disabled id="AssetTypeDesc_maxindexval" maxindex="150" type="text" class="form-control" name="AssetTypeDesc" autocomplete="off">'
}


// Summary Tab

function SummaryData() {
    $('#myPleaseWait').modal('show');
    var ServiceId = 2;
    var WorkGroupId = 1;
    var TypeOfPlanner = 35;
    var Year = $("#SummaryYear option:selected").text();
    $.get("/api/PPMPlanner/Summary/" + ServiceId + "/" + WorkGroupId + "/" + Year + "/" + TypeOfPlanner + "/" + pagesize + "/" + pageindex)
 .done(function (result) {
     var getResult = JSON.parse(result);
     SummaryDetails = getResult.SummaryDets;
     if (SummaryDetails == null) {
         PushEmptyMessage();
     }
     else {
         $("#SummaryResultId").empty();
         $.each(SummaryDetails, function (index, value) {
             SummaryNewRow();

             $("#UserAreaCode_" + index).val(value.UserAreaCode).prop("disabled", true);
             $("#UserAreaName_" + index).val(value.UserAreaName).prop("disabled", true);
             $("#Week1_" + index).prop('checked', value.Week1);
             $("#Week2_" + index).prop('checked', value.Week2);
             $("#Week3_" + index).prop('checked', value.Week3);
             $("#Week4_" + index).prop('checked', value.Week4);
             $("#Week5_" + index).prop('checked', value.Week5);
             $("#Week6_" + index).prop('checked', value.Week6);
             $("#Week7_" + index).prop('checked', value.Week7);
             $("#Week8_" + index).prop('checked', value.Week8);
             $("#Week9_" + index).prop('checked', value.Week9);
             $("#Week10_" + index).prop('checked', value.Week10);
             $("#Week11_" + index).prop('checked', value.Week11);
             $("#Week12_" + index).prop('checked', value.Week12);
             $("#Week13_" + index).prop('checked', value.Week13);
             $("#Week14_" + index).prop('checked', value.Week14);
             $("#Week15_" + index).prop('checked', value.Week15);
             $("#Week16_" + index).prop('checked', value.Week16);
             $("#Week17_" + index).prop('checked', value.Week17);
             $("#Week18_" + index).prop('checked', value.Week18);
             $("#Week19_" + index).prop('checked', value.Week19);
             $("#Week20_" + index).prop('checked', value.Week20);
             $("#Week21_" + index).prop('checked', value.Week21);
             $("#Week22_" + index).prop('checked', value.Week22);
             $("#Week23_" + index).prop('checked', value.Week23);
             $("#Week24_" + index).prop('checked', value.Week24);
             $("#Week25_" + index).prop('checked', value.Week25);
             $("#Week26_" + index).prop('checked', value.Week26);
             $("#Week27_" + index).prop('checked', value.Week27);
             $("#Week28_" + index).prop('checked', value.Week28);
             $("#Week29_" + index).prop('checked', value.Week29);
             $("#Week30_" + index).prop('checked', value.Week30);
             $("#Week31_" + index).prop('checked', value.Week31);
             $("#Week32_" + index).prop('checked', value.Week32);
             $("#Week33_" + index).prop('checked', value.Week33);
             $("#Week34_" + index).prop('checked', value.Week34);
             $("#Week35_" + index).prop('checked', value.Week35);
             $("#Week36_" + index).prop('checked', value.Week36);
             $("#Week37_" + index).prop('checked', value.Week37);
             $("#Week38_" + index).prop('checked', value.Week38);
             $("#Week39_" + index).prop('checked', value.Week39);
             $("#Week40_" + index).prop('checked', value.Week40);
             $("#Week41_" + index).prop('checked', value.Week41);
             $("#Week42_" + index).prop('checked', value.Week42);
             $("#Week43_" + index).prop('checked', value.Week43);
             $("#Week44_" + index).prop('checked', value.Week44);
             $("#Week45_" + index).prop('checked', value.Week45);
             $("#Week46_" + index).prop('checked', value.Week46);
             $("#Week47_" + index).prop('checked', value.Week47);
             $("#Week48_" + index).prop('checked', value.Week48);
             $("#Week49_" + index).prop('checked', value.Week49);
             $("#Week50_" + index).prop('checked', value.Week50);
             $("#Week51_" + index).prop('checked', value.Week51);
             $("#Week52_" + index).prop('checked', value.Week52);
             $("#Week53_" + index).prop('checked', value.Week53);
         });
     }
     if ((SummaryDetails && SummaryDetails.length) > 0) {
         GridtotalRecords = SummaryDetails[0].TotalRecords;
         TotalPages = SummaryDetails[0].TotalPages;
         LastRecord = SummaryDetails[0].LastRecord;
         FirstRecord = SummaryDetails[0].FirstRecord;
         pageindex = SummaryDetails[0].PageIndex;
     }

     var mapIdproperty = ["UserAreaCode-UserAreaCode_", "UserAreaName-UserAreaName_",
     "Week1-Week1_-checkbox", "Week2-Week2_-checkbox", "Week3-Week3_-checkbox", "Week4-Week4_-checkbox", "Week5-Week5_-checkbox", "Week6-Week6_-checkbox", "Week7-Week7_-checkbox", "Week8-Week8_-checkbox", "Week9-Week9_-checkbox", "Week10-Week10_-checkbox",
     "Week11-Week11_-checkbox", "Week12-Week12_-checkbox", "Week13-Week13_-checkbox", "Week14-Week14_-checkbox", "Week15-Week15_-checkbox", "Week16-Week16_-checkbox", "Week17-Week17_-checkbox", "Week18-Week18_-checkbox", "Week19-Week19_-checkbox", "Week20-Week20_-checkbox",
     "Week21-Week21_-checkbox", "Week22-Week22_-checkbox", "Week23-Week23_-checkbox", "Week24-Week24_-checkbox", "Week25-Week25_-checkbox", "Week26-Week26_-checkbox", "Week27-Week27_-checkbox", "Week28-Week28_-checkbox", "Week29-Week29_-checkbox", "Week30-Week30_-checkbox",
     "Week31-Week31_-checkbox", "Week32-Week32_-checkbox", "Week33-Week33_-checkbox", "Week34-Week34_-checkbox", "Week35-Week35_-checkbox", "Week36-Week36_-checkbox", "Week37-Week37_-checkbox", "Week38-Week38_-checkbox", "Week39-Week39_-checkbox", "Week40-Week40_-checkbox",
     "Week41-Week41_-checkbox", "Week42-Week42_-checkbox", "Week43-Week43_-checkbox", "Week44-Week44_-checkbox", "Week45-Week45_-checkbox", "Week46-Week46_-checkbox", "Week47-Week47_-checkbox", "Week48-Week48_-checkbox", "Week49-Week49_-checkbox", "Week50-Week50_-checkbox",
     "Week51-Week51_-checkbox", "Week52-Week52_-checkbox", "Week53-Week53_-checkbox"];
     var htmltext = SummaryGridHtml();//Inline Html
     var obj = { formId: "#form", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "SummaryDets", tableid: '#SummaryResultId', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/PPMPlanner/Summary/" + ServiceId + "/" + WorkGroupId + "/" + Year + "/" + TypeOfPlanner, pageindex: pageindex, pagesize: pagesize };

     CreateFooterPagination(obj);

     $('#myPleaseWait').modal('hide');
 })
 .fail(function () {
     $('#myPleaseWait').modal('hide');
     $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
     $('#errorMsg').css('visibility', 'visible');
 });
}

//Summary Tab Functions
function SummaryNewRow() {

    var inputpar = {
        inlineHTML: SummaryGridHtml(),//Inline Html
        TargetId: "#SummaryResultId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
}

function PushEmptyMessage() {
    $("#SummaryResultId").empty();
    var emptyrow = '<tr><td colspan=56 ><h3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;No records to display</h3></td></tr>'
    $("#SummaryResultId ").append(emptyrow);
}

function SummaryGridHtml() {

    return '<tr>' +
            '<td " style="text-align: center;" title=""><div><input disabled id="UserAreaCode_maxindexval"  type="text" class="form-control" name="UserAreaCode" autocomplete="off"></div></td>' +
            '<td " style="text-align: center;" title=""><div><input disabled id="UserAreaName_maxindexval" type="text" class="form-control" name="UserAreaName" autocomplete="off"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week1_maxindexval"  type="checkbox" class="form-control" name="Week1_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week2_maxindexval"  type="checkbox" class="form-control" name="Week2_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week3_maxindexval"  type="checkbox" class="form-control" name="Week3_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week4_maxindexval"  type="checkbox" class="form-control" name="Week4_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week5_maxindexval"  type="checkbox" class="form-control" name="Week5_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week6_maxindexval"  type="checkbox" class="form-control" name="Week6_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week7_maxindexval"  type="checkbox" class="form-control" name="Week7_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week8_maxindexval"  type="checkbox" class="form-control" name="Week8_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week9_maxindexval"  type="checkbox" class="form-control" name="Week9_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week10_maxindexval" type="checkbox" class="form-control" name="Week10"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week11_maxindexval" type="checkbox" class="form-control" name="Week11_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week12_maxindexval" type="checkbox" class="form-control" name="Week12_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week13_maxindexval" type="checkbox" class="form-control" name="Week13_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week14_maxindexval" type="checkbox" class="form-control" name="Week14_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week15_maxindexval" type="checkbox" class="form-control" name="Week15_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week16_maxindexval" type="checkbox" class="form-control" name="Week16_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week17_maxindexval" type="checkbox" class="form-control" name="Week17_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week18_maxindexval" type="checkbox" class="form-control" name="Week18_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week19_maxindexval" type="checkbox" class="form-control" name="Week19_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week20_maxindexval" type="checkbox" class="form-control" name="Week20"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week21_maxindexval" type="checkbox" class="form-control" name="Week21_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week22_maxindexval" type="checkbox" class="form-control" name="Week22_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week23_maxindexval" type="checkbox" class="form-control" name="Week23_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week24_maxindexval" type="checkbox" class="form-control" name="Week24_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week25_maxindexval" type="checkbox" class="form-control" name="Week25_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week26_maxindexval" type="checkbox" class="form-control" name="Week26_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week27_maxindexval" type="checkbox" class="form-control" name="Week27_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week28_maxindexval" type="checkbox" class="form-control" name="Week28_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week29_maxindexval" type="checkbox" class="form-control" name="Week29_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week30_maxindexval" type="checkbox" class="form-control" name="Week30"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week31_maxindexval" type="checkbox" class="form-control" name="Week31_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week32_maxindexval" type="checkbox" class="form-control" name="Week32_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week33_maxindexval" type="checkbox" class="form-control" name="Week33_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week34_maxindexval" type="checkbox" class="form-control" name="Week34_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week35_maxindexval" type="checkbox" class="form-control" name="Week35_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week36_maxindexval" type="checkbox" class="form-control" name="Week36_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week37_maxindexval" type="checkbox" class="form-control" name="Week37_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week38_maxindexval" type="checkbox" class="form-control" name="Week38_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week39_maxindexval" type="checkbox" class="form-control" name="Week39_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week40_maxindexval" type="checkbox" class="form-control" name="Week40"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week41_maxindexval" type="checkbox" class="form-control" name="Week41_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week42_maxindexval" type="checkbox" class="form-control" name="Week42_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week43_maxindexval" type="checkbox" class="form-control" name="Week43_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week44_maxindexval" type="checkbox" class="form-control" name="Week44_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week45_maxindexval" type="checkbox" class="form-control" name="Week45_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week46_maxindexval" type="checkbox" class="form-control" name="Week46_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week47_maxindexval" type="checkbox" class="form-control" name="Week47_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week48_maxindexval" type="checkbox" class="form-control" name="Week48_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week49_maxindexval" type="checkbox" class="form-control" name="Week49_"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week50_maxindexval" type="checkbox" class="form-control" name="Week50"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week51_maxindexval" type="checkbox" class="form-control" name="Week51"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week52_maxindexval" type="checkbox" class="form-control" name="Week52"></div></td>' +
            '<td   style="text-align: center;" title=""><div><input disabled id="Week53_maxindexval" type="checkbox" class="form-control" name="Week53"></div></td>'
}

function LinkClicked(id) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formriplanner :input:not(:button)").parent().removeClass('has-error');
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
    else if (!hasEditPermission) {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#btnDelete').show();
    }

    if (action == 'View') {
        $("#formBemsBlock :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/PPMPlanner/Get/" + primaryId)
            .done(function (result) {
             
              var htmlval = "";
              var getResult = JSON.parse(result);
             // $('#Service').val(getResult.ServiceId);
              $('#Year').val(getResult.Year);
              //$('#WorkGroup').val(getResult.WorkGroup);
              $('#hdnUserAreaId').val(getResult.UserAreaId);
              $('#txtUserAreaCode').val(getResult.UserAreaCode);
              $('#txtUserAreaName').val(getResult.UserAreaName);
              $('#txtTotalAsset').val(getResult.AssetCount);
              $('#hdnAssigneeId').val(getResult.AssigneeId);
              $('#txtAssignee').val(getResult.Assignee);
              $('#hdnHospitalRepresentativeId').val(getResult.FacRepId);
              //$('#txtHospitalRepresentative').val(getResult.HospitalRepresentative);
              $('#txtHospitalRepresentative').val(getResult.FacRep);
              $('#hdnAssetId').val(getResult.AssetRegisterId);
              $('#txtAssetNo').val(getResult.AssetNo);
              $('#hdnEngineerId').val(getResult.EngineerId);
              $('#txtEngineer').val(getResult.Engineer);
              $('#txtSchedule').val(getResult.Schedule);
              $('#Status').val(getResult.Status);
              $('#primaryID').val(getResult.PlannerId);

              var Date = getResult.Date && getResult.Date.split(',');
              //$.each(Date, function (i) {
              //    $('#Date option[value="' + Date[i] + '"]').prop('selected', true);
              //});
              $('#Date').val(Date);
              $("#Date").multiselect("refresh");

              setTimeout(function () {
                  $('.multiSelectDDLwithoutSearch').multiselect('rebuild');
                  $(".multiselect-container").find("input").prop("disabled", true);
              }, 500)

              var Months = (getResult.Month).split(",");
              for (i = 0; i < Months.length; i++) {
                  var result = getmonth(parseInt(Months[i]), 'Int');
                  $('#Check' + result).prop('checked', true);
                  montharray.push(parseInt(Months[i]));
              }

              //var Weeks = (getResult.Week).split(",");
              //for (i = 0; i < Weeks.length; i++) {
              //    var result1 = getweek(parseInt(Weeks[i]), 'Int');
              //    $('#Check' + result1).prop('checked', true);
              //    weekarray.push(parseInt(Weeks[i]));
              //}

              //var Days = (getResult.Day).split(",");
              //for (i = 0; i < Days.length; i++) {
              //    var result2 = getday(parseInt(Days[i]), 'Int');
              //    $('#Check' + result2).prop('checked', true);
              //    dayarray.push(parseInt(Days[i]));
              //}

              ScheduleChange();
              $('#Schedule').attr('disabled', true);
              $('#txtUserAreaCode').attr('disabled', true);
              $('#Year').attr('disabled', true);

              $('#CheckJan').attr('disabled', true);
              $('#CheckFeb').attr('disabled', true);
              $('#CheckMar').attr('disabled', true);
              $('#CheckApr').attr('disabled', true);
              $('#CheckMay').attr('disabled', true);
              $('#CheckJun').attr('disabled', true);
              $('#CheckJul').attr('disabled', true);
              $('#CheckAug').attr('disabled', true);
              $('#CheckSep').attr('disabled', true);
              $('#CheckOct').attr('disabled', true);
              $('#CheckNov').attr('disabled', true);
              $('#CheckDec').attr('disabled', true);

              $('#CheckWeek1').attr('disabled', true);
              $('#CheckWeek2').attr('disabled', true);
              $('#CheckWeek3').attr('disabled', true);
              $('#CheckWeek4').attr('disabled', true);
              $('#CheckWeek5').attr('disabled', true);

              $('#CheckSun').attr('disabled', true);
              $('#CheckMon').attr('disabled', true);
              $('#CheckTue').attr('disabled', true);
              $('#CheckWed').attr('disabled', true);
              $('#CheckThu').attr('disabled', true);
              $('#CheckFri').attr('disabled', true);
              $('#CheckSat').attr('disabled', true);

              $('#myPleaseWait').modal('hide');
          })
         .fail(function (response) {
             $('#myPleaseWait').modal('hide');
             $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
             $('#errorMsg').css('visibility', 'visible');
         });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}

$("#btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/PPMPlanner/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('PPMPlanner', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 EmptyFields();
             })
             .fail(function () {
                 showMessage('PPMPlanner', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
        }

    });
}

function EmptyFields() {
    $(".content").scrollTop(0);
    $('#btnDelete').hide();
    $('input[type="text"], textarea').val('');
    $("#Year").val(currentYear).trigger('change');
    $("#SummaryYear").val(currentYear);
    $('#txtUserAreaCode,#Schedule').removeAttr("disabled")
    $('#WorkOrderType,#AssetClarification').val('null');
    $('#WarrentyType').val(80);
    $('#Schedule').val(78);
    $('#Status').val(1);
    $('#CheckJan,#CheckFeb,#CheckMar,#CheckApr').prop('checked', false);
    $('#CheckMay,#CheckJun,#CheckJul,#CheckAug').prop('checked', false);
    $('#CheckSep,#CheckOct,#CheckNov,#CheckDec').prop('checked', false);

    $('#CheckWeek1,#CheckWeek2,#CheckWeek3,#CheckWeek4,#CheckWeek5').prop('checked', false);

    $('#CheckSun,#CheckMon,#CheckTue,#CheckWed,#CheckThu,#CheckFri,#CheckSat').prop('checked', false);

    //$('#CheckJan').attr('disabled', false);
    //$('#CheckFeb').attr('disabled', false);
    //$('#CheckMar').attr('disabled', false);
    //$('#CheckApr').attr('disabled', false);
    //$('#CheckMay').attr('disabled', false);
    //$('#CheckJun').attr('disabled', false);
    //$('#CheckJul').attr('disabled', false);
    //$('#CheckAug').attr('disabled', false);
    //$('#CheckSep').attr('disabled', false);
    //$('#CheckOct').attr('disabled', false);
    //$('#CheckNov').attr('disabled', false);
    //$('#CheckDec').attr('disabled', false);

    $('#CheckWeek1').attr('disabled', false);
    $('#CheckWeek2').attr('disabled', false);
    $('#CheckWeek3').attr('disabled', false);
    $('#CheckWeek4').attr('disabled', false);
    $('#CheckWeek5').attr('disabled', false);

    $('#CheckSun').attr('disabled', false);
    $('#CheckMon').attr('disabled', false);
    $('#CheckTue').attr('disabled', false);
    $('#CheckWed').attr('disabled', false);
    $('#CheckThu').attr('disabled', false);
    $('#CheckFri').attr('disabled', false);
    $('#CheckSat').attr('disabled', false);
    $('#Year').attr('disabled', false);

    //$('#Date > option').prop('selected', false);
    $('#Date').val(null);
    $("#Date").multiselect("refresh");
    $('#blockCode').removeAttr("disabled")
    $('#spnActionType').text('Add');
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#primaryID').val('');
    $("#grid").trigger('reloadGrid');
    $("#formriplanner :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('.nav-tabs a:first').tab('show');
}
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

window.multiSelectshow = function () {
    $('select[name=Flag]').multiselect('destroy');
    $('select[name=Flag]').multiselect({ maxHeight: 200, maxWidth: 500, buttonWidth: '100%', includeSelectAllOption: true });

}