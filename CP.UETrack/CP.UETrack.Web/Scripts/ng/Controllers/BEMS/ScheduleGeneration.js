//*Global variables decration section starts*//
var pageindex = 1, pagesize = 5;
var GridtotalRecords = 0;
var TotalPages = 0, FirstRecord = 0, LastRecord = 0;
//*Golbal variables decration section ends*//
var ScheduleDetails = [];
var fileinfo = [];
formInputValidation("formppmplanner");
$(function () {
   
    $('#myPleaseWait').modal('show');
    formInputValidation("formScheduleGeneration");
    const urlParams = new URLSearchParams(window.location.search);
    var TypeOfPlannerId = urlParams.get('TypeOfPlannerId');
    var YearId = urlParams.get('YearId');
      $.get("/api/ScheduleGeneration/Load")
         .done(function (result) {
             var loadResult = JSON.parse(result);
             $("#jQGridCollapse1").click();
                 
             $.each(loadResult.YearList, function (index, value) {
                 $('#Year').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
             });
             if (YearId)
             {
                 $('#Year').val(YearId);
             }
             
             $.each(loadResult.YearList, function (index, value) {
                 $('#Year_PPM').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
             });
             $.each(loadResult.TypeOfPlannerList, function (index, value) {
                 $('#TypeOfPlanner').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                 $('#TypeOfPlanner_PPM').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
             });

             $.each(loadResult.WorkGroup, function (index, value) {
                     $('#selWorkGroupfems').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
             });
             $.each(loadResult.WorkGroup, function (index, value) {
                 $('#Class_PPM').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
             });

             //$('#Service').val(2);
             //$('#WorkGroup').val(1);
           
             if (TypeOfPlannerId) {
                 var tp= parseInt(TypeOfPlannerId);

                 $('#TypeOfPlanner').val(tp);
             }
             else
             {
                 $('#TypeOfPlanner').val(34);
             }
             $('#btnSaveGenerate').attr('disabled', true);
             $('#btnAddNew').attr('disabled', true);
             GetWeekNo();
         })
  .fail(function (response) {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
      $('#errorMsg').css('visibility', 'visible');
  });


    $('#btnAddNew').click(function () {
        // deepak added
        //var weekno = parseInt( $('#WeekNo').val());
        //var Sdate = $('#EndDate').val();
        //var Edate = $('#EndDate').val();
        //var Sdates = new Date(Sdate);   
        //var Edates = new Date(Edate);      
        //     Sdate = Sdates.addDays(1);
        //     Edate = Edates.addDays(7);
        //var y1 = Sdates.getFullYear();
        //var y2 = Edates.getFullYear();
        //if (y2 > y1) {
        //    weekno =1;
        //} else {
        //    weekno = weekno + 1;
        //}
        ////var ed = DateFormatter(Edates);          
        //$('#StartDate').val(DateFormatter(Sdate));
        //$('#EndDate').val(DateFormatter(Edates)); 
       
        //$('#WeekNo').val(weekno);
        //$('#btnAddNew').attr('disabled', true);


        //  window.location.reload(); removed



        bootbox.confirm({
            message: "If Selected Week Skiped once it cannot be Re-Generated again do you wish to Continue?",
            buttons: {
                confirm: {
                    label: 'Yes and Skip to Next Week',
                    className: 'btn-success'
                },
                cancel: {
                    label: 'No',
                    className: 'btn-danger'
                }
            },
            callback: function (result) {
                if (result) {

                    $('#myPleaseWait').modal('show');
                   // $('#btnAddNew').prop('disabled', true);
                    SkipNextWeek();
                    //GetWeekNo();
                   
                    //$('#myPleaseWait').modal('hide');
                    //$('#btnAddNew').prop('disabled', false);
                }
                else {
                    $('#myPleaseWait').modal('hide');
                    //$('#btnAddNew').prop('disabled', false);
                }
            }
        });

      

      });

    $("#btnCancel").click(function () {
        var service_screen = $('#ServiceId').val();
        if (service_screen == 1) {
            window.location.href = "/FEMS/ScheduleGeneration/add";
        } else {
            window.location.href = "/BEMS/ScheduleGeneration/add";
        }
          
      });
});

// Load Week No

function GetWeekNo() {
    $("#btnSaveFetch").attr('disabled', false);
    var ServiceId = 2;
    var service_screen = $('#ServiceId').val();
    var WorkGroupId = 1;
    if (service_screen==1)
    { ServiceId =1;;
        WorkGroupId = $('#selWorkGroupfems').val();
    } else
    {
        WorkGroupId = 1;
    }
    if (WorkGroupId == "null") {
        WorkGroupId = 1;
    } else {
    }
   
    var TypeOfPlanner = $('#TypeOfPlanner').val();
    if(TypeOfPlanner == "null")
    {
        $('#WeekNo').val(null);
        $('#StartDate').val(null);
        $('#EndDate').val(null);
        return false;
    }
    var Year = $("#Year option:selected").text();
    $.get("/api/ScheduleGeneration/GetWeekNo/" + ServiceId + "/" + WorkGroupId + "/" + Year + "/" + TypeOfPlanner)
 .done(function (result) {
     var getResult = JSON.parse(result);
     var weekno = getResult.WeekNo;
     if (Year != '2020') {
         //weekno = weekno - 1;
     }
     if (weekno == 99) {
         weekno = getResult.WeekLogId;
         bootbox.alert("Year " + Year + " Shedule Generation has been Completed for all Weeks.Please Select Next Year and proceed furter...");
         $("#btnSaveFetch").attr('disabled', true);

     }
     $('#WeekNo').val(weekno);
//$('#WeekNo').val(getResult.WeekNo);
     $('#StartDate').val(DateFormatter(getResult.StartDate));
     $('#EndDate').val(DateFormatter(getResult.EndDate));
     $('#myPleaseWait').modal('hide');
 })
 .fail(function (response) {
     $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
     $('#errorMsg').css('visibility', 'visible');
 });
}

// Fetch User Area & Location

var UserAreaFetchObj = {
    SearchColumn: 'txtUserAreaCode-UserAreaCode',//Id of Fetch field
    ResultColumns: ["UserAreaId-Primary Key", 'UserAreaName-User Area Name', 'UserAreaCode-UserAreaCode'],
    FieldsToBeFilled: ["hdnUserAreaId-UserAreaId", "txtUserAreaCode-UserAreaName"]
};

$('#txtUserAreaCode').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divUserAreaFetch', UserAreaFetchObj, "/api/Fetch/UserAreaFetch", "UlFetch1", event, 1);//1 -- pageIndex
});

var UserLocationFetchObj = {
    SearchColumn: 'txtUserLocCode-UserLocationCode',//Id of Fetch field
    ResultColumns: ["UserLocationId-Primary Key", 'UserLocationName-User Location Name', 'UserLocationCode-UserLocationCode'],
    AdditionalConditions: ["UserAreaId-hdnUserAreaId"],
    FieldsToBeFilled: ["hdnUserLocId-UserLocationId", "txtUserLocCode-UserLocationName"]
};

$('#txtUserLocCode').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divUserLocFetch', UserLocationFetchObj, "/api/Fetch/LocationCodeFetch", "UlFetch2", event, 1);//1 -- pageIndex
});

// Fetch & Generate Function

function Fetch_Generate(Type) {
    $("#errorMessage1").text('');
    $('#errorMsg1').css('visibility', 'hidden');
    $('#myPleaseWait').modal('show');
    //Added by sai//
    $('#selWorkGroupfems').attr('required', true);
    var isFormValid = formInputValidation("formppmplanner", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg1').css('visibility', 'visible');
        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }
    /// END
    var ServiceId = 2;
    var WorkGroupId = $('#selWorkGroupfems option:selected').val();
    if (WorkGroupId == "null") {
      
        WorkGroupId = 1;
    } else {
    }
    pagesize = 5;
    var TypeOfPlanner = $('#TypeOfPlanner option:selected').text();
    var UserAreaId = $('#hdnUserAreaId').val();
    var UserLocationId = $('#hdnUserLocId').val();
    var Year = $("#Year option:selected").text();
    var WeekNo = $("#WeekNo").val();
    var StartDate = $("#StartDate").val();
    var EndDate = $("#EndDate").val();
    var userAreaName = $('#txtUserAreaCode').val();
    if (UserAreaId == '' && userAreaName != '') {
        $("#errorMessage1").text("Area Name is invalid");
        $('#errorMsg1').css('visibility', 'visible');

        $('#myPleaseWait').modal('hide');
        return false;
    }

    var userLocationName = $('#txtUserLocCode').val();
    if (UserLocationId == '' && userLocationName != '') {
        $("#errorMessage1").text("Location Name is invalid");
        $('#errorMsg1').css('visibility', 'visible');

        $('#myPleaseWait').modal('hide');
        return false;
    }

    if (UserAreaId == "")
    {
        UserAreaId = null;
    }

    if (UserLocationId == "") {

        UserLocationId = null;
    }

    if (TypeOfPlanner == "Select ") {
        $('#myPleaseWait').modal('hide');
        bootbox.alert("Please choose Type Of Planner!")
        return false;
    }
    var service_screen = $('#ServiceId').val();
    if (service_screen == 1)
    {
        WorkGroupId = $('#selWorkGroupfems').val();
    } else {
        
    }
   
    var wek = Number(WeekNo);
    //wek = wek + 1;
    WeekNo = wek;
    $.get("/api/ScheduleGeneration/Fetch/" + ServiceId + "/" + WorkGroupId + "/" + Year + "/" + TypeOfPlanner + "/" + StartDate + "/" + EndDate + "/" + WeekNo + "/" + Type + "/" + UserAreaId + "/" + UserLocationId + "/" + pagesize + "/" + pageindex)
   .done(function (result) {
    var TypeOfPlanner = $('#TypeOfPlanner option:selected').text();
    var getResult = JSON.parse(result);
    var TempFlag = null;
    pagesize = 5;
    if (getResult.skipweek == 1) {
        $('#btnAddNew').attr('disabled', false);
    }
    ScheduleDetails = getResult.ScheduleDets;
    if (ScheduleDetails == null) {
        if (TypeOfPlanner == "PPM" || TypeOfPlanner == "PDM" || TypeOfPlanner == "Calibration" || TypeOfPlanner == "Radiology QC"){
            $('#RIHeadHide').hide();
            $('#PPMHeadHide1').show();
            $('#PPMHeadHide').show();
            $("#PPMHeadHide").attr('width', "28%");
        }       
        else if (TypeOfPlanner == "RI")
        {
            $('#RIHeadHide').show();
            $('#PPMHeadHide1').hide();
            $('#PPMHeadHide').hide();
            $('#RIHeadHide').attr('width', "42%");
        }
        PushEmptyMessage();
        $("#paginationfooter").hide();
    }
    else {
        $("#paginationfooter").show();
        TempFlag = getResult.ScheduleDets[0].IsParentChildAvailable;
        if (Type == "Fetch") {
            $('#btnSaveGenerate').attr('disabled', false);
            $('#btnAddNew').attr('disabled', true);
        }
        else if (Type == "Generate")
        {
           
            $('#btnSaveGenerate').attr('disabled', true);
            $('#btnSaveFetch').attr('disabled', false);
            GetWeekNo();
        }
        $("#ScheduleResultId").empty();
        $.each(ScheduleDetails, function (index, value) {
            ScheduleNewRow();
            $("#AssetNo_" + index).val(value.AssetNo).prop("disabled", true);
            $("#UserArea_" + index).val(value.UserArea).prop("disabled", true);
            $("#WorkOrder_" + index).val(value.WorkOrder).prop("disabled", true);
           // $("#WorkGroupCode_" + index).val(value.WorkGroupCode).prop("disabled", true);
            $("#WorkOrderDate_" + index).val(DateFormatter(value.WorkOrderDate)).prop("disabled", true);
            $("#TargetDate_" + index).val(DateFormatter(value.TargetDate)).prop("disabled", true);
            $("#TypeOfPlanner_" + index).val(value.TypeOfPlanner).prop("disabled", true);
            $("#AssetType_" + index).val(value.AssetType).prop("disabled", true);
            if (TypeOfPlanner == "PPM" || TypeOfPlanner == "PDM" || TypeOfPlanner == "Calibration" || TypeOfPlanner == "Radiology QC")
            {
                $('#RIHeadHide').hide();                
                $("#RIBodyHide_" + index).hide();
           
                $('#PPMHeadHide').show();
                $('#PPMHeadHide1').show();
                $("#PPMBodyHide1_" + index).show();
                $("#PPMBodyHide_" + index).show();

                $("#PPMHeadHide").attr('width', "28%");
                $("#PPMBodyHide_" + index).attr('width', "28%");
            }           
            else if (TypeOfPlanner == "RI")
            {
                $('#PPMHeadHide').hide();
                $("#PPMBodyHide_" + index).hide();
                $('#PPMHeadHide1').hide();
                $("#PPMBodyHide1_" + index).hide();

                $('#RIHeadHide').show();
                $("#RIBodyHide_" + index).show();

                $('#RIHeadHide').attr('width', "42%");
                $("#RIBodyHide_" + index).attr('width', "42%");

            }
        });
        
    }
    if ((ScheduleDetails && ScheduleDetails.length) > 0) {
        GridtotalRecords = ScheduleDetails[0].TotalRecords;
        TotalPages = ScheduleDetails[0].TotalPages;
        LastRecord = ScheduleDetails[0].LastRecord;
        FirstRecord = ScheduleDetails[0].FirstRecord;
        pageindex = ScheduleDetails[0].PageIndex;
    }

    var mapIdproperty = ["AssetNo-AssetNo_", "UserArea-UserArea_", "WorkOrder-WorkOrder_", "WorkGroupCode-WorkGroupCode_", "WorkOrderDate-WorkOrderDate_", "TargetDate-TargetDate_", "TypeOfPlanner-TypeOfPlanner_", "AssetType-AssetType_"];
    var PageSize = $('#Id_PageSize').val();
    var htmltext = ScheduleGridHtml();//Inline Html
    var obj = { formId: "#form", TOP:TypeOfPlanner , IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "ScheduleResultId", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "ScheduleDets", tableid: '#ScheduleResultId', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/ScheduleGeneration/Fetch/" + ServiceId + "/" + WorkGroupId + "/" + Year + "/" + TypeOfPlanner + "/" + StartDate + "/" + EndDate + "/" + WeekNo + "/" + Type + "/" + UserAreaId + "/" + UserLocationId };

    CreateFooterPagination(obj);

    $('#TypeOfPlanner').prop('disabled', true);
    $('#txtUserAreaCode').prop('disabled', true);
    $('#txtUserLocCode').prop('disabled', true);
    $("#Year").prop('disabled', true);

    if ((Type == "Generate"))
    {
        $('#errorMsg').css('visibility', 'hidden');
        $(".content").scrollTop(0);
        showMessage('Schedule Generation', CURD_MESSAGE_STATUS.SS);
        $("#top-notifications").modal('show');
        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);
    }
    if (Type == "Fetch" && TempFlag == true)
    {
        bootbox.alert("Child / Parent Asset Available!");
    }
    
    $('#myPleaseWait').modal('hide');
})
.fail(function (response) {
    $('#myPleaseWait').modal('hide');
    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
    $('#errorMsg').css('visibility', 'visible');
});
}

//Fetch Functionality Functions
function ScheduleNewRow() {

    var inputpar = {
        inlineHTML: ScheduleGridHtml(),//Inline Html
        TargetId: "#ScheduleResultId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
}

function PushEmptyMessage() {
    $("#ScheduleResultId").empty();
    var emptyrow = '<tr><td colspan=10 width="100%" ><h3> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; No records to display </h3></td></tr>'
    $("#ScheduleResultId ").append(emptyrow);
}

function ScheduleGridHtml() {

    return '<tr>' +
            '<td "  width="14%" style="text-align: center;" id="PPMBodyHide_maxindexval" title=""><div><input disabled id="AssetNo_maxindexval"  type="text" class="form-control" name="AssetNo" autocomplete="off"></div></td>' +
            '<td "  width="14%" style="text-align: center;" id="RIBodyHide_maxindexval" title=""><div><input disabled id="UserArea_maxindexval"  type="text" class="form-control" name="AssetNo" autocomplete="off"></div></td>' +
            '<td "  width="15%" style="text-align: center;" title=""><div><input disabled id="WorkOrder_maxindexval" type="text" class="form-control" name="WorkOrder" autocomplete="off"></div></td>' +
            '<td "  width="15%" style="text-align: center;" title=""><div><input disabled id="WorkOrderDate_maxindexval" maxindex="150" type="text" class="form-control" name="WorkOrderDate" autocomplete="off"></div></td>' +
            '<td "  width="14%" style="text-align: center;" title=""><div><input disabled id="TargetDate_maxindexval" maxindex="150" type="text" class="form-control" name="TargetDate" autocomplete="off"></div></td>' +
            '<td "  width="14%" style="text-align: center;" title=""><div><input disabled id="TypeOfPlanner_maxindexval" maxindex="150" type="text" class="form-control" name="TypeOfPlanner" autocomplete="off"></div></td>' +
            '<td "  width="14%" style="text-align: center;" id="PPMBodyHide1_maxindexval" title=""><div><input disabled id="AssetType_maxindexval" type="text" class="form-control" name="AssetType" autocomplete="off"></div></td>'
}
function downloadfiless(index)
{
    var DocumentId = fileinfo[index];
    var FileCatName = "download";
    var DocumentExtension = "application/pdf";
    var $downloadForm = $("<form method='POST'>").attr("action", "/bems/AttachmentPartialView/CommonDownLoad").append($("<input name='FileName' type='text'>").val(FileCatName)).append($("<input name='ContentType' type='text'>").val(DocumentExtension)).append($("<input name='FilePath' type='text'>").val(DocumentId))

    $("body").append($downloadForm);
    var status = $downloadForm.submit();
    $downloadForm.remove();
}
// on change year










function SkipNextWeek() {
   
    /// END
    var ServiceId = $('#ServiceId').val();
   // var ServiceId = 2;
    var WorkGroupId = $('#selWorkGroupfems option:selected').val();
    if (WorkGroupId == "null") {
      
        WorkGroupId = 1;
    } else
    {

    }
    var TypeOfPlannerId = $('#TypeOfPlanner').val();
    var YearId = $("#Year").val();
    var TypeOfPlanner = $('#TypeOfPlanner option:selected').text();
    var UserAreaId = $('#hdnUserAreaId').val();
    var UserLocationId = $('#hdnUserLocId').val();
    var Year = $("#Year option:selected").text();
    var WeekNo = $("#WeekNo").val();
    var StartDate = $("#StartDate").val();
    var EndDate = $("#EndDate").val();
    var userAreaName = $('#txtUserAreaCode').val();
    if (UserAreaId == '' && userAreaName != '') {
        $("#errorMessage1").text("Area Name is invalid");
        $('#errorMsg1').css('visibility', 'visible');

        $('#myPleaseWait').modal('hide');
        return false;
    }

    var userLocationName = $('#txtUserLocCode').val();
   

    if (UserAreaId == "")
    {
        UserAreaId = null;
    }

    if (UserLocationId == "") {

        UserLocationId = null;
    }

   
    var service_screen = $('#ServiceId').val();
    if (service_screen == 1)
    {
        WorkGroupId = $('#selWorkGroupfems').val();
    } else {
        
    }
   
    var wek = Number(WeekNo);
    //wek = wek + 1;
    WeekNo = wek;
    $.get("/api/ScheduleGeneration/Fetch/" + ServiceId + "/" + WorkGroupId + "/" + Year + "/" + TypeOfPlanner + "/" + StartDate + "/" + EndDate + "/" + WeekNo + "/" + "Skip" + "/" + UserAreaId + "/" + UserLocationId + "/" + 5 + "/" + 1)
   .done(function (result) {
       var service_screen = $('#ServiceId').val();
       if (service_screen == 1) {
           window.location.href = "/FEMS/ScheduleGeneration/add?TypeOfPlannerId=" + TypeOfPlannerId + "&YearId=" + YearId + "";
       } else {
           window.location.href = "/BEMS/ScheduleGeneration/add?TypeOfPlannerId=" + TypeOfPlannerId + "&YearId="+YearId+"";
       }
    $('#myPleaseWait').modal('hide');
})
.fail(function (response) {
    $('#myPleaseWait').modal('hide');
    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
    $('#errorMsg').css('visibility', 'visible');
});
}












//-Start---------------------------------------Bulk Print----------------------------------------//

$("#Year_PPM").change(function ()
{
    var Workingg = 0;
    var service_screen = $('#ServiceId').val();
    if (service_screen == 1) {
        Workingg = $('#Class_PPM').val();
    } else {
        
        Workingg = 0;
    }
    var primaryId = $('#Year_PPM').val();
    var typeofPlanner = $('#TypeOfPlanner_PPM').val();
 
    $.get("/api/ScheduleGeneration/getby_year/" + primaryId + "/" + Workingg + "/" + Workingg + "/" + service_screen + "/" + typeofPlanner).done(function (result)
    {
        var getResult = JSON.parse(result);
        BulkPrintTableCreation(getResult);
        //$('#myTable').empty();
        //$.each(getResult, function (index, value) {
        //    index = index + 1;
        //    fileinfo[index] = value.file_name;
        //    var startingdate = moment(value.WeekStartDate).format("DD-MMM-YYYY HH:mm");
        //    var endingdate = moment(value.WeekEndDate).format("DD-MMM-YYYY HH:mm");
        //    var vreated = moment(value.CreatedDate).format("DD-MMM-YYYY HH:mm");
        //    $('#myTable').append('<tr><td width = "9%" style = "text-align: center;" data - original - title="" title = "" ><div><div></div></div>' + index + '</td><td width="13%" style="text-align: center;" data-original-title="" title="">' + value.type_of_planning + '</td><td width="13%" style="text-align: center;" data-original-title="" title=""><div><div>' + value.Year + '</div></div></td><td width="10%" style="text-align: center;" data-original-title="" title="">' + value.WeekNo + '</td><td width="13%" style="text-align: center;" data-original-title="" title=""><div><div>' + startingdate + '</div></div></td><td width="13%" style="text-align: center;" data-original-title="" title="">' + endingdate + '</td><td width="13%" style="text-align: center;" data-original-title="" title="">' + vreated + '</td><td width="13%" style="text-align: center;" data-original-title="" title=""><a href="#" onclick="downloadfiless(' +index+')"><span id="' + value.file_name + '">DOWNLOAD</span></a></td></tr >');
        //});
      
    })
    .fail(function () {
        $('#myPleaseWait').modal('hide');
        $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
    });

});
$("#Class_PPM").change(function () {
    var Workingg = 0;
    var service_screen = $('#ServiceId').val();
    if (service_screen == 1) {
        Workingg = $("#Class_PPM").val();
    } else {
        Workingg = 0;
    }
    var primaryId = $("#Year_PPM").val();
    var typeofPlanner = $("#TypeOfPlanner_PPM").val()
    //  alert($("#Year_PPM").val());
    $.get("/api/ScheduleGeneration/getby_year/" + primaryId + "/" + Workingg + "/" + Workingg + "/" + service_screen + "/" + typeofPlanner).done(function (result)
    {
            var getResult = JSON.parse(result);
            $('#myTable').empty();
            BulkPrintTableCreation(getResult);
            //$.each(getResult, function (index, value) {
            //    index = index + 1;
            //    fileinfo[index] = value.file_name;
            //    var startingdate = moment(value.WeekStartDate).format("DD-MMM-YYYY HH:mm");
            //    var endingdate = moment(value.WeekEndDate).format("DD-MMM-YYYY HH:mm");
            //    var vreated = moment(value.CreatedDate).format("DD-MMM-YYYY HH:mm");
            //    $('#myTable').append('<tr><td width = "9%" style = "text-align: center;" data - original - title="" title = "" ><div><div></div></div>' + index + '</td><td width="13%" style="text-align: center;" data-original-title="" title="">' + value.type_of_planning + '</td><td width="13%" style="text-align: center;" data-original-title="" title=""><div><div>' + value.Year + '</div></div></td><td width="10%" style="text-align: center;" data-original-title="" title="">' + value.WeekNo + '</td><td width="13%" style="text-align: center;" data-original-title="" title=""><div><div>' + startingdate + '</div></div></td><td width="13%" style="text-align: center;" data-original-title="" title="">' + endingdate + '</td><td width="13%" style="text-align: center;" data-original-title="" title="">' + vreated + '</td><td width="13%" style="text-align: center;" data-original-title="" title=""><a href="#" onclick="downloadfiless(' + index + ')"><span id="' + value.file_name + '">DOWNLOAD</span></a></td></tr >');
            //});

        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });

});

$("#TypeOfPlanner_PPM").change(function () {
    var Workingg = 0;
    var service_screen = $('#ServiceId').val();
    if (service_screen == 1) {
        Workingg = $('#Class_PPM').val();
    } else {

        Workingg = 0;
    }
    var primaryId = $('#Year_PPM').val();
    var typeofPlanner = $('#TypeOfPlanner_PPM').val();

    $.get("/api/ScheduleGeneration/getby_year/" + primaryId + "/" + Workingg + "/" + Workingg + "/" + service_screen + "/" + typeofPlanner).done(function (result) {
        var getResult = JSON.parse(result);
        BulkPrintTableCreation(getResult);
        //$('#myTable').empty();
        //$.each(getResult, function (index, value) {
        //    index = index + 1;
        //    fileinfo[index] = value.file_name;
        //    var startingdate = moment(value.WeekStartDate).format("DD-MMM-YYYY HH:mm");
        //    var endingdate = moment(value.WeekEndDate).format("DD-MMM-YYYY HH:mm");
        //    var vreated = moment(value.CreatedDate).format("DD-MMM-YYYY HH:mm");
        //    $('#myTable').append('<tr><td width = "9%" style = "text-align: center;" data - original - title="" title = "" ><div><div></div></div>' + index + '</td><td width="13%" style="text-align: center;" data-original-title="" title="">' + value.type_of_planning + '</td><td width="13%" style="text-align: center;" data-original-title="" title=""><div><div>' + value.Year + '</div></div></td><td width="10%" style="text-align: center;" data-original-title="" title="">' + value.WeekNo + '</td><td width="13%" style="text-align: center;" data-original-title="" title=""><div><div>' + startingdate + '</div></div></td><td width="13%" style="text-align: center;" data-original-title="" title="">' + endingdate + '</td><td width="13%" style="text-align: center;" data-original-title="" title="">' + vreated + '</td><td width="13%" style="text-align: center;" data-original-title="" title=""><a href="#" onclick="downloadfiless(' + index + ')"><span id="' + value.file_name + '">DOWNLOAD</span></a></td></tr >');
        //});

    })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });

});

    

function BulkPrintTableCreation(getResult) {
    $('#myTable').empty();
    $.each(getResult, function (index, value) {
        index = index + 1;
        fileinfo[value.WeekLogId] = value.file_name;
        var startingdate = moment(value.WeekStartDate).format("DD-MMM-YYYY HH:mm");
        var endingdate = moment(value.WeekEndDate).format("DD-MMM-YYYY HH:mm");
        var vreated = moment(value.CreatedDate).format("DD-MMM-YYYY HH:mm");
        var downloadstatus = value.Status == ("NA") ? "" : "DOWNLOAD";
        var printStatus = value.Status == "NA" ? "'Print'" : "'RePrint'";
        var printStatusDisplay = value.Status == "NA" ? "Print" : "RePrint";


        $('#myTable').append(

            '<tr><td width = "5%" style = "text-align: center;" data - original - title="" title = "" id=#BPId' + index + '><div><div></div></div>' + index
            + '</td><td width="10%" style="text-align: center;" data-original-title="" title="">' + value.type_of_planning

            + '</td><td width="10%" style="display:none;" data-original-title="" title="">' + value.WeekLogId //Hidden Column

            + '</td><td width="7%" style="text-align: center;" data-original-title="" title=""><div><div>' + value.Year
            + '</div></div>'
            + '</td><td width="7%" style="text-align: center;" data-original-title="" title="">' + value.WeekNo
            + '</td><td width="12%" style="text-align: center;" data-original-title="" title=""><div><div>' + startingdate
            + '</div></div>'
            + '</td><td width="12%" style="text-align: center;" data-original-title="" title="">' + endingdate
            + '</td><td width="10%" style="text-align: center;" data-original-title="" title="">' + vreated
            + '</td><td width="10%" style="text-align: center;" data-original-title="" title="">' + '<span id="BPStatusId' + value.WeekLogId + '">' + value.Status + '</span>' // value.Status
            + '</td><td width="13%" style="text-align: center;" data-original-title="" title="" ><div id=BPDivdownloadfilessId' + value.WeekLogId + '><a id=BPdownloadfilessId' + value.WeekLogId + ' href="#" onclick="downloadfiless(' + value.WeekLogId + ')"><span id="' + value.file_name + '">' + downloadstatus + '</span></a></div>'
            + '</td><td width="14%" style="text-align: center;" data-original-title="" title="" ><div id=BPDivprintFunctionId' + value.WeekLogId + '> <button type="button" id=BPprintFunctionId' + value.WeekLogId + ' onclick="printFunction(' + printStatus + ',' + value.WeekLogId + ')" class="btn  btn-info  btn-sm " tabindex="5">' + printStatusDisplay + '</button> </div></td></tr >');
    });
}


function printFunction(printstatus, WeekLogId) {
    year = $('#Year_PPM').val();
    typeofPlanner = $('#TypeOfPlanner_PPM').val();



    $("#BPStatusId" + WeekLogId).text("Please Wait PDF Generation is Processing");



    var ScheduleGen = {

        PrintActionType: printstatus,
        WeekLogId: WeekLogId,
        Year: year,
        TypeOfPlanner: typeofPlanner
    };




    var jqxhr = $.post("/api/ScheduleGeneration/Print", ScheduleGen, function (response)
    {


        var getResult = JSON.parse(response);
        if (typeof getResult != "undefined" && getResult != null)
        {
            var list = getResult.Pprintlist;
            var PrintList = list;
            if (typeof PrintList != "undefined" && PrintList != null && PrintList.length > 0) {
                RefreshUpdates(PrintList);
            }


        }

    },
       "json")
        .fail(function (response) {
            var errorMessage = "";
            if (response.status == 400) {
                errorMessage = response.statusText;
            }
            else if (response.status == 404) {
                var responses = response.responseJSON.split("&");
                var msg = responses[0];
                var WeekLogId = responses[1];

                $("#BPStatusId" + parseInt(WeekLogId)).text(msg);
                TerminateJob();
            }

          
        });


    RefreshPerformAction();
  


}


var AutoRefreshId = null;

function RefreshPerformAction() {

    RefershPrintList();
    AutoRefreshId = setInterval(function () {
        RefershPrintList()
        //code goes here that will be run every 5 seconds.    
    }, 5000);



}




function RefershPrintList() {

    var year = 0;
    var typeofPlanner = 0;


    WeekLogId = 0;
    year = $('#Year_PPM').val();
    typeofPlanner = $('#TypeOfPlanner_PPM').val();


    var ScheduleGen = {

        PrintActionType: "Print",
        WeekLogId: WeekLogId,
        Year: year,
        TypeOfPlanner: typeofPlanner
    };


    var jqxhr = $.post("/api/ScheduleGeneration/PrintRefresh", ScheduleGen, function (response) {

        var getResult = JSON.parse(response);
        if (typeof getResult != "undefined" && getResult != null) {
            var list = getResult.Pprintlist;
            var PrintList = list;
            if (typeof PrintList != "undefined" && PrintList != null && PrintList.length > 0) {


                RefreshUpdates(PrintList);
                

            }
        }

    },
              "json")
               .fail(function (response) {
                   var errorMessage = "";
                   if (response.status == 400) {
                       errorMessage = response.responseJSON;
                       TerminateJob();
                   }


               


               });








}


function PostRequest(url, obj) {


    //var jqxhr = $.post("/api/ICTassetRegister/Save", saveObj, function (response)
    var jqxhr = $.post(url, obj, function (response) {
        var result = JSON.parse(response);
        return result;

    },
       "json")
        .fail(function (response) {
            var errorMessage = "";
            if (response.status == 400) {
                errorMessage = response.responseJSON;
            }

        });
}



function RefreshUpdates(PrintList) {
    $.each(PrintList, function (index, value) {
        //Status Value Change
        $("#BPStatusId" + value.WeekLogId).html(value.Status);

        if (value.Status == "Completed") {

            //Remove Existing Button & Add New
            //Remove Existing ahref & Add New




            var printStatus = value.Status == "NA" ? "'Print'" : "'RePrint'";
            var printStatusDisplay = value.Status == "NA" ? "Print" : "RePrint";
            var downloadstatus = "DOWNLOAD";


            $("#BPdownloadfilessId" + value.WeekLogId).remove();
            $("#BPprintFunctionId" + value.WeekLogId).remove();




            var rr = $('<a href="#" id=BPdownloadfilessId' + value.WeekLogId + ' onclick="downloadfiless(' + value.WeekLogId + ')"><span id="' + value.file_name + '">' + downloadstatus + '</span></a>');
            $("#BPDivdownloadfilessId" + value.WeekLogId).append(rr);
            var r = $('<button type="button" id=BPprintFunctionId' + value.WeekLogId + ' onclick="printFunction(' + printStatus + ',' + value.WeekLogId + ')" class="btn  btn-info  btn-sm " tabindex="5">' + printStatusDisplay + '</button>');
            $("#BPDivprintFunctionId" + value.WeekLogId).append(r);




            fileinfo[value.WeekLogId] = value.file_name;



            //Add Status

            $("#BPStatusId" + value.WeekLogId).text(value.Status);

            //TerminateJob();

        }

    });
}




function TerminateJob() {
    clearInterval(AutoRefreshId);
}

//----------------------------------------Bulk Print------------------------------------End----//