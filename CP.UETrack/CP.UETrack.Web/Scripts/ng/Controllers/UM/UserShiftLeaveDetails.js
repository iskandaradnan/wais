var TotalPages = 1;
var UserworkdurationTime;
$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    formInputValidation("UserShiftLeave");
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $.get("/api/UserShiftLeave/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            UserworkdurationTime = loadResult.UserworkShiftTime;
            $("#jQGridCollapse1").click();      
            //$.each(loadResult.ShiftLunchTime, function (index, value) {
            //    $('#UserShiftLunchTime').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            //});
            //$.each(loadResult.ShiftTime, function (index, value) {
            //    $('#UserShiftWrkShftTime').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            //});

            //var returnedData = $.grep(loadResult.ShiftLunchTime, function (element, index) {
            //    return element.DefaultValue == true;
               
            //});
            
            //if (returnedData.length > 0) {
            //    $('#selGender').val(returnedData[0].LovId);
            //}
            //DefaultLov =(returnedData[0].LovId);
            //$('#UserShiftLunchTime').val(DefaultLov);         
           
 //----------------------------------------------------------------------------------changing Dropdown Values--------------------------------------------------------------------------------------------------------------------------//
            //$("#UserShiftWrkShftTime").change(function () {
            //    if (this.value == '') {

            //        $("#UserShiftLunchTime").val('').empty().append('<option value="">Select</option>').prop("disabled", "disabled");
            //    }
            //    else if (this.value == 359) {

            //        $("#UserShiftLunchTime").empty().append('<option value="">Select</option>');
            //        $.each(loadResult.ShiftLunchTime, function (index, value) {
            //            if (value.LovId == 310 || value.LovId == 311 || value.LovId == 312 || value.LovId == 313 || value.LovId == 370)
            //                $('#UserShiftLunchTime').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>').prop("disabled", false);
            //        });
            //    }
            //    else if (this.value == 360) {
            //        $("#UserShiftLunchTime").empty().append('<option value="">Select</option>');
            //        $.each(loadResult.ShiftLunchTime, function (index, value) {
            //            if (value.LovId == 310 || value.LovId == 311 || value.LovId == 312 || value.LovId == 370)
            //                $('#UserShiftLunchTime').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>').prop("disabled", false);
            //        });
            //    }
            //    else if (this.value == 361) {
            //        $("#UserShiftLunchTime").empty().append('<option value="">Select</option>');
            //        $.each(loadResult.ShiftLunchTime, function (index, value) {
            //            if (value.LovId == 312 || value.LovId == 313 || value.LovId == 370)
            //                $('#UserShiftLunchTime').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>').prop("disabled", false);
            //        });
            //    }
            //    else if (this.value == 362) {
            //        $("#UserShiftLunchTime").empty().append('<option value="">Select</option>');
            //        $.each(loadResult.ShiftLunchTime, function (index, value) {
            //            if (value.LovId == 370 )
            //                $('#UserShiftLunchTime').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>').prop("disabled", false);
            //        });
            //    }
            //});



//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
            //var UserRegistrationId = $('#hdnRegistrationId').val();
            //var primaryId = $('#primaryID').val();
            //if (primaryId != null && primaryId != "0" && primaryId !== "") {
            //    $.get("/api/UserShiftLeave/Get/" + primaryId)

            //                      .done(function (result) {
            //                          var getResult = JSON.parse(result);
            //                          GetUserShiftsBind(getResult);
            //                          $('#myPleaseWait').modal('hide');

            //                      })
            //         .fail(function () {
            //             $('#myPleaseWait').modal('hide');
            //             $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            //             $('#errorMsg').css('visibility', 'visible');
            //         });
            //}
            //else {
            //        $('#myPleaseWait').modal('hide');
            //    }

            //$('#ShiftStartTime').on('change', function () {
               

                

            //    //var ResSelShiftStartTime = SelShiftStartTime.concat(SelShiftStartTimeMin);
            //    //ResSelShiftStart = parseInt(ResSelShiftStartTime);
            //    //alert(SelShiftStartTime);

            //    if(SelShiftStartTime)
            //     var b = 12 + SelShiftStartTime;
            //   //alert(b);
            //    var c;
            //   $("#ShiftEndTime").empty().append('<option value="">HH</option>');
            //   for (i = SelShiftStartTime; i < b; i++) {
                   
            //       if (i < 24) {
            //           c = i + 1;
            //           $('#ShiftEndTime').append('<option value="' + c + '">' + i + '</option>').prop("disabled", false);
            //       }
            //      else if (i >= 24) {
                             
            //               var x = 0;
            //               var y = i + 1;
            //               $('#ShiftEndTime').append('<option value="' + y + '">' + x + '</option>').prop("disabled", false);

            //           }
            //   }
                

              
            //    //$.each(loadResult.CategoryLovs, function (index, value) {
            //    //    if (value.LovId == 104 || value.LovId == 105 || value.LovId == 106)
            //    //        $('#FacilityworkCategory').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>').prop("disabled", false);
            //    //});


            //});

            })
            
  .fail(function () {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
      $('#errorMsg').css('visibility', 'visible');
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

//****************************************************************************** Save ****************************************************************************************************************************


    $("#btnSave, #btnEdit,#btnSaveandAddNew").click(function () {
    $('#btnlogin').attr('disabled', true);
    $('#myPleaseWait').modal('show');
    var CurrentbtnID = $(this).attr("Id");
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');


    var _index;
    $('#UserShiftLeaveDetailstable tr').each(function () {
        _index = $(this).index();
    });


    var UserShiftsId = $('#primaryID').val();
    var UserRegistrationId = $('#hdnRegistrationId').val();
    var StaffName = $('#UserShiftStaffName').val();
    var MobileNumber = $('#UserShiftMobileNo').val();
    var UserType = $('#UserShiftUserType').val();
    var AccessLevel = $('#UserShiftAccessLevel').val();
    var Role = $('#UserShiftRole').val();
    var Designation = $('#UserShiftDesignation').val();
    var ShiftStartTime = $('#ShiftStartTime option:selected').text();
    var ShiftStartTimeMin = $('#ShiftStartTimeMin option:selected').text();
    var ShiftEndTime = $('#ShiftEndTime option:selected').text();
    var ShiftEndTimeMin = $('#ShiftEndTimeMin option:selected').text();
    var ShiftBreakStartTime = $('#ShiftBreakStartTime option:selected').text();
    var ShiftBreakStartTimeMin = $('#ShiftBreakStartTimeMin option:selected').text();
    var ShiftBreakEndTime = $('#ShiftBreakEndTime option:selected').text();
    var ShiftBreakEndTimeMin = $('#ShiftBreakEndTimeMin option:selected').text();
    var shiftTime = $('#UserShiftWrkShftTime').val();
    var timeStamp = $("#Timestamp").val();
    var LeaveFrom = $("#UserShiftLeaveFrom").val();
    var LeaveTo = $("#UserShiftLeaveTo").val();
    var LunchTimeLovId = $('#UserShiftLunchTime').val();
    var result = [];
  
  
    
            var today = GetCurrentDate();
            var Currentdate = Date.parse(today);
    for (var i = 0; i <= _index; i++) {
        var _UserShiftsGrid = {
            UserShiftDetId: $('#hdnUserShiftId_' + i).val(),
            LeaveFromGrid: $('#LeaveFromGrid_' + i).val(),
            LeaveToGrid: $('#LeaveToGrid_' + i).val(),           
            NoOfDays: $('#NoOfDays_' + i).val(),
            IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),   
        }
        if ((_UserShiftsGrid.IsDeleted)&&((Date.parse(_UserShiftsGrid.LeaveFromGrid) < Currentdate) || (Date.parse(_UserShiftsGrid.LeaveToGrid) < Currentdate))) {
            bootbox.alert("Sorry!. You cannot delete Past Records");
            $('#btneSave').attr('disabled', false);
            $('#btnEdit').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            for (i = 0; i <= _index; i++) {
                $('#Isdeleted_' + i).prop('checked', false);
            }
           
            $('#chk_UserShiftdet').prop('checked', false);
            return false;
        }
        result.push(_UserShiftsGrid);
       
    }

    //var deletedCount = Enumerable.From(result).Where(x=>x.IsDeleted).Count();
    var Isdeleteavailable = deletedCount = 0;   
    var isFormValid = formInputValidation("UserShiftLeave", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnSave').attr('disabled', false);
     
        return false;
    }


 //-------------------------------------------------------------------------------dropdown change condition---------------------------------------------------------------------------------------------------------------------//
    var SelShiftStartTime = $('#ShiftStartTime option:selected').text();
    var SelShiftStartTimeMin = $('#ShiftStartTimeMin option:selected').text();
  
     
    var SelShiftStartTimeDuration = parseInt(SelShiftStartTime) + parseInt(SelShiftStartTimeMin);
        
    var SelShiftEndTime = $('#ShiftEndTime option:selected').text();
    var SelShiftEndTimeMin = $('#ShiftEndTimeMin option:selected').text();
    if (SelShiftEndTime == 00) {
        SelShiftEndTime = 24;
    }

  
    var SelShiftEndTimeDuration = parseInt(SelShiftEndTime) + parseInt(SelShiftEndTimeMin);

       var UserSftTimeDrtion = parseInt(SelShiftStartTimeDuration) - parseInt(SelShiftEndTimeDuration);

        var totMin = 0;
        var diffMin = (new Date("1970-1-1 " + " " + SelShiftEndTime + ":" + SelShiftEndTimeMin) - new Date("1970-1-1 " + " " + SelShiftStartTime + ":" + SelShiftStartTimeMin)) / 1000 / 60;
        if (diffMin < 0) {
            var totMinNitShift = UserworkdurationTime + diffMin;
            totMin = (totMinNitShift * 2) - diffMin;
        } else {
            totMin = diffMin;
        }

    //if (UserSftTimeDrtion >720 || UserSftTimeDrtion < -720) {
        if (totMin > UserworkdurationTime) {

            $("div.errormsgcenter").text("Please Enter a Shift Time  Maximum " +UserworkdurationTime /60+ " hours.");
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        return false;

    }
        SelShiftStartTime = (SelShiftStartTime * 60);
        var SelShiftStartTimeDurationMin = parseInt(SelShiftStartTime) + parseInt(SelShiftStartTimeMin);
        SelShiftEndTime = (SelShiftEndTime * 60);
        var SelShiftEndTimeDurationMin = parseInt(SelShiftEndTime) + parseInt(SelShiftEndTimeMin);
    var SelShiftBreakStartTime = $('#ShiftBreakStartTime option:selected').text();
    var SelShiftBreakStartTimeMin = $('#ShiftBreakStartTimeMin option:selected').text();
    SelShiftBreakStartTime = (SelShiftBreakStartTime * 60);
    var SelShiftBreakStartTimeDuration = parseInt(SelShiftBreakStartTime) + parseInt(SelShiftBreakStartTimeMin);

    if (SelShiftStartTime < SelShiftEndTime)
    {
        if (SelShiftStartTimeDurationMin <= SelShiftBreakStartTimeDuration && SelShiftEndTimeDurationMin >= SelShiftBreakStartTimeDuration) {
            var SelShiftBreakEndTime = $('#ShiftBreakEndTime option:selected').text();
            var SelShiftBreakEndTimeMin = $('#ShiftBreakEndTimeMin option:selected').text();
            SelShiftBreakEndTime = (SelShiftBreakEndTime * 60);
            var SelShiftBreakEndTimeDuration = parseInt(SelShiftBreakEndTime) + parseInt(SelShiftBreakEndTimeMin);

      
            if (SelShiftStartTimeDurationMin < SelShiftBreakEndTimeDuration && SelShiftEndTimeDurationMin >= SelShiftBreakEndTimeDuration) {
                if (SelShiftBreakStartTimeDuration > SelShiftBreakEndTimeDuration) {
                    $("div.errormsgcenter").text("Please Enter a valid Shift Break End Time. ");
                    $('#errorMsg').css('visibility', 'visible');
                    $('#myPleaseWait').modal('hide');
                    return false;
                }
            }
            else {
                $("div.errormsgcenter").text("Please Enter a valid Shift Break End Time. ");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
                 
        }

        else {

            $("div.errormsgcenter").text("Please Enter a valid Shift Break Start Time. ");
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }
    }
    else {
        if (SelShiftStartTimeDurationMin >= SelShiftBreakStartTimeDuration && SelShiftEndTimeDurationMin >= SelShiftBreakStartTimeDuration)
        {
            var SelShiftBreakEndTime = $('#ShiftBreakEndTime option:selected').text();
            var SelShiftBreakEndTimeMin = $('#ShiftBreakEndTimeMin option:selected').text();
            SelShiftBreakEndTime = (SelShiftBreakEndTime * 60);
            var SelShiftBreakEndTimeDuration = parseInt(SelShiftBreakEndTime) + parseInt(SelShiftBreakEndTimeMin);

            if (SelShiftStartTimeDurationMin > SelShiftBreakEndTimeDuration && SelShiftEndTimeDurationMin >= SelShiftBreakEndTimeDuration) {
                if (SelShiftBreakStartTimeDuration > SelShiftBreakEndTimeDuration) {
                    $("div.errormsgcenter").text("Please Enter a valid Shift Break End Time. ");
                    $('#errorMsg').css('visibility', 'visible');
                    $('#myPleaseWait').modal('hide');
                    return false;
                }
            }
            else {
                $("div.errormsgcenter").text("Please Enter a valid Shift Break End Time. ");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
                 
        }

        else {

            $("div.errormsgcenter").text("Please Enter a valid Shift Break Start Time. ");
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        
        }

    }
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
   
    var obj = {
        UserShiftsId: UserShiftsId,
        UserShiftLeaveGridData: result,
        UserRegistrationId: UserRegistrationId,
        LunchTimeLovId: LunchTimeLovId,
        ShiftTime: shiftTime,
        Timestamp: timeStamp,
        StaffName: StaffName,
        MobileNumber: MobileNumber,
        UserType: UserType,
        AccessLevel: AccessLevel,
        Role: Role,
        Designation: Designation,
        LeaveFrom: LeaveFrom,
        LeaveTo: LeaveTo,
        ShiftStartTime: ShiftStartTime,
        ShiftStartTimeMin: ShiftStartTimeMin,
        ShiftEndTime: ShiftEndTime,
        ShiftEndTimeMin: ShiftEndTimeMin,
        ShiftBreakStartTime: ShiftBreakStartTime,
        ShiftBreakStartTimeMin: ShiftBreakStartTimeMin,
        ShiftBreakEndTime: ShiftBreakEndTime,
        ShiftBreakEndTimeMin: ShiftBreakEndTimeMin,
    }

    //if (obj.UserShiftLeaveGridData == 0)
    //{
    //    $("div.errormsgcenter").text("Please Enter the Leave Details into Table");
    //    $('#errorMsg').css('visibility', 'visible');
    //    $('#myPleaseWait').modal('hide');
    //    return false;      
    //}
      




    if ((LeaveFrom) || (LeaveTo) > 0) {
        $("div.errormsgcenter").text("Please Click + Icon to add Leave Details into the above table");
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        return false;
    }
        
    //if (Date.parse(LeaveFrom) < (Currentdate) || (Date.parse(LeaveFrom) < (Currentdate))) {
    //    $("div.errormsgcenter").text("Please Enter a Valid Leave Details");
    //    $('#errorMsg').css('visibility', 'visible');
    //    $('#myPleaseWait').modal('hide');
    //    return false;
    //}

    if (Isdeleteavailable == true) {
        $('#myPleaseWait').modal('hide');
        bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (result) {
            if (result) {
                SaveUserShift(obj,CurrentbtnID);
            }
            else {
                $('#myPleaseWait').modal('hide');
                $('#btnSave').attr('disabled', false);
                $('#btnEdit').attr('disabled', false);
            }
        });
    }
    else {
       SaveUserShift(obj, CurrentbtnID);
    }

    function SaveUserShift(obj, CurrentbtnID) {
        var jqxhr = $.post("/api/UserShiftLeave/Save", obj, function (response) {
            var result = JSON.parse(response);
            $('#spnPopup-UserShift').hide();
            GetUserShiftsBind(result);
            $("#hdnRegistrationId").val(result.UserRegistrationId);
            $("#primaryID").val(result.UserShiftsId);
            $("#Timestamp").val(result.Timestamp);
            $("#grid").trigger('reloadGrid');
            if (result.UserShiftsId != 0) {               
                $('#btnEdit').show();
                $('#btnSave').hide();
                $('#btnDelete').show();
            }
            $(".content").scrollTop(0);
            showMessage('UserShiftLeave', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);


            $('#btnSave').attr('disabled', false);

            $('#myPleaseWait').modal('hide');
            if (CurrentbtnID == "btnSaveandAddNew") {
                EmptyFields();
            }
        },
       "json")
        .fail(function (response) {
            var errorMessage = "";
            if (response.status == 400) {
                errorMessage = response.responseJSON;
                if (errorMessage == "Leave Already Applied for that day") {
                    var rowCount = $('#UserShiftLeaveDetailstable tr:last').index();
                    $('#Isdeleted_' + rowCount).closest('tr').remove();
                }

            }
            else {
                errorMessage = Messages.COMMON_FAILURE_MESSAGE;
            }
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
    }
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
});
//-------------------------------------------------------------------------------Grid Delete------------------------------------------------------------------------------------//
$("#chk_UserShiftdet").change(function () {
    var Isdeletebool = this.checked;

    if (this.checked) {
        $('#UserShiftLeaveDetailstable tr').map(function (i) {
            if ($("#Isdeleted_" + i).prop("disabled")) {
                $("#Isdeleted_" + i).prop("checked", false);
            }
            else {
                $("#Isdeleted_" + i).prop("checked", true);
            }
        });
    } else {
        $('#UserShiftLeaveDetailstable tr').map(function (i) {
            $("#Isdeleted_" + i).prop("checked", false);
        });
    }
});

//------------------------------------------------------------------------------------Get--------------------------------------------------------------------------------------------------------------------------//

function RemoveSelected()
{
    $("#ShiftStartTime > option").each(function () {
        $(this).removeAttr('selected');
    });
    $("#ShiftStartTimeMin > option").each(function () {
        $(this).removeAttr('selected');
    });
    $("#ShiftEndTime > option").each(function () {
        $(this).removeAttr('selected');
    });
    $("#ShiftEndTimeMin > option").each(function () {
        $(this).removeAttr('selected');
    });
    $("#ShiftBreakStartTime > option").each(function () {
        $(this).removeAttr('selected');
    });
    $("#ShiftBreakStartTimeMin > option").each(function () {
        $(this).removeAttr('selected');
    });
    $("#ShiftBreakEndTime > option").each(function () {
        $(this).removeAttr('selected');
    });
    $("#ShiftBreakEndTimeMin > option").each(function () {
        $(this).removeAttr('selected');
    });

    $('#ShiftStartTime, #ShiftStartTimeMin, #ShiftEndTime, #ShiftEndTimeMin, #ShiftBreakStartTime, #ShiftBreakStartTimeMin, \
        #ShiftBreakEndTime, #ShiftBreakEndTimeMin').val('');
 
}

function GetUserShiftsBind(getResult) {
   
    var primaryId = $('#primaryID').val();
    $("#UserShiftStaffName").val(getResult.StaffName).prop("disabled","disabled");
    $("#UserShiftMobileNo").val(getResult.MobileNumber);
    $("#UserShiftUserType").val(getResult.UserType);
    $("#UserShiftAccessLevel").val(getResult.AccessLevel);
    $("#UserShiftRole").val(getResult.Role);
    $("#UserShiftDesignation").val(getResult.Designation);
    //$("#ShiftStartTime").text(getResult.ShiftStartTime);

    RemoveSelected();


    if (getResult.ShiftStartTime != null && getResult.ShiftStartTime != '') {
        $("#ShiftStartTime").val(parseInt(getResult.ShiftStartTime) + 1);
        $("#ShiftEndTime").val(parseInt(getResult.ShiftEndTime) + 1);
        $("#ShiftBreakStartTime").val(parseInt(getResult.ShiftBreakStartTime) + 1);
        $("#ShiftBreakEndTime").val(parseInt(getResult.ShiftBreakEndTime) + 1);
        $("#ShiftStartTimeMin").val(chkQrtr(parseInt(getResult.ShiftStartTimeMin)));
        $("#ShiftEndTimeMin").val(chkQrtr(parseInt(getResult.ShiftEndTimeMin)));
        $("#ShiftBreakStartTimeMin").val(chkQrtr(parseInt(getResult.ShiftBreakStartTimeMin)));
        $("#ShiftBreakEndTimeMin").val(chkQrtr(parseInt(getResult.ShiftBreakEndTimeMin)));
    }
   
    //$("#ShiftStartTimeMin").text(getResult.ShiftStartTimeMin);
    //$("#ShiftEndTime").text(getResult.ShiftEndTime);
    //$("#ShiftEndTimeMin").text(getResult.ShiftEndTimeMin);
    //$("#ShiftBreakStartTime").text(getResult.ShiftBreakStartTime);
    //$("#ShiftBreakStartTimeMin").text(getResult.ShiftBreakStartTimeMin);
    //$("#ShiftBreakEndTime").text(getResult.ShiftBreakEndTime);
    //$("#ShiftBreakEndTimeMin").text(getResult.ShiftBreakEndTimeMin);
    $('#hdnUserShiftsId').val(getResult.UserShiftsId);
    $('#hdnRegistrationId').val(getResult.UserRegistrationId);
    $('#UserShiftLunchTime').val(getResult.LunchTimeLovId);
    $("#UserShiftLeaveDetailstable").empty();
    $('#chk_UserShiftdet').prop("checked", false);
  
    $.each(getResult.UserShiftLeaveGridData, function (index, value) {
        AddNewRowUserShift();
        $("#hdnUserShiftId_" + index).val(getResult.UserShiftLeaveGridData[index].UserShiftDetId);
        $("#LeaveFromGrid_" + index).val(DateFormatter(getResult.UserShiftLeaveGridData[index].LeaveFromGrid));
        $("#LeaveToGrid_" + index).val(DateFormatter(getResult.UserShiftLeaveGridData[index].LeaveToGrid));
        $("#NoOfDays_" + index).val(getResult.UserShiftLeaveGridData[index].NoOfDays);
       
    });
    
}


    
function AddNewRow() {

    var LeaveFrom = "";
    var LeaveTo = "";
    $('#chk_UserShiftdet').prop("checked", false);
    var _index;
    var rowCount = $('#UserShiftLeaveDetailstable tr:last').index();
    if (rowCount == -1) {
        rowCount = 0;
    } else {
        rowCount = rowCount + 1;
    }
         
         LeaveFrom = ($("#UserShiftLeaveFrom").val());
         LeaveTo = ($("#UserShiftLeaveTo").val());

         if ((LeaveFrom != "") && (LeaveTo != "")) {

            var date1 = Date.parse($("#UserShiftLeaveFrom").val());
            var date2 = Date.parse($("#UserShiftLeaveTo").val());;

            var diffDays = (date2 - date1);
            var days = diffDays / 1000 / 60 / 60 / 24;

            if (date2 < date1) {
                $("div.errormsgcenter").text("Leave From Date should be greater than Leave To Date");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
           
            var today = GetCurrentDate();
            var Currentdate = Date.parse(today);
            if (Date.parse(LeaveFrom) < (Currentdate) || (Date.parse(LeaveTo) < (Currentdate))) {
                $("div.errormsgcenter").text("Please Enter a Valid Leave Details");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
            else {
                AddNewRowUserShift();
                $('#errorMsg').css('visibility', 'hidden');
                $("#LeaveFromGrid_" + rowCount).val(LeaveFrom);
                $("#LeaveToGrid_" + rowCount).val(LeaveTo);
                $("#NoOfDays_" + rowCount).val(days + 1);       
                $("#UserShiftLeaveFrom").prop('required', false);
                $("#UserShiftLeaveTo").prop('required', false);
                $("#ShiftLeaveFrom").html("Leave From");
                $("#ShiftLeaveTo").html("Leave To");
            }
 
            $("#UserShiftLeaveFrom").val("");
            $("#UserShiftLeaveTo").val("");
            
        }
        if ((LeaveFrom == "") || (LeaveTo == "")) {
            bootbox.alert("Please provide a Leave From And Leave To")
        }
      

    }

function AddNewUserShiftHtml() {

    return '<tr><td  width="5%"><div title="Select"><div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" name="UsershiftCheckboxes" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(UserShiftLeaveDetailstable,chk_UserShiftdet)"> </label></div></div></td>\
                <td width="35%"><div> <input type="hidden" id="hdnUserShiftId_maxindexval" /> <input type="text" id="LeaveFromGrid_maxindexval" name="LeaveFromGrid" class="form-control" autocomplete="off" required disabled></div></td>\
                <td width="35%"><div> <input type="text" id="LeaveToGrid_maxindexval" name="LeaveToGrid" class="form-control" autocomplete="off" required disabled></div></td>\
                <td width="25%"><div> <input type="text" id="NoOfDays_maxindexval" name="NoOfDays" class="form-control" autocomplete="off" required disabled></div></td></tr>'
}
function AddNewRowUserShift() {
    var inputpar = {
        inlineHTML: AddNewUserShiftHtml(),
        IdPlaceholderused: "maxindexval",
        TargetId: "#UserShiftLeaveDetailstable",
        TargetElement: ["tr"]
    }

    AddNewRowToDataGrid(inputpar);
    $('#UserShiftLeaveDetailstable tr:last td:first input').focus();
    
}
 //--------------------------------------------------------------search--------------------------------------------------------------------------------------------------//

var FetchRegisterationObj = {
    Heading: "Staff Name Details",//Heading of the popup
    SearchColumns: ['StaffName-Staff Name', 'Designation-Designation', ],//ModelProperty - Space seperated label value
    ResultColumns: ["UserRegistrationId-Primary Key", 'StaffName-Staff Name', "UserType-User Type", "Designation-Designation", ],//Columns to be returned for display
    FieldsToBeFilled: ["hdnRegistrationId-UserRegistrationId", "UserShiftStaffName-StaffName", "UserShiftMobileNo-MobileNumber", "UserShiftUserType-UserType", "UserShiftAccessLevel-AccessLevel", "UserShiftRole-Role", "UserShiftDesignation-Designation"]//id of element - the model property--, , 
};
$('#spnPopup-UserShift').click(function () {
    DisplaySeachPopup('divSearchPopup', FetchRegisterationObj, "/api/Search/UserShiftLeaveDetailsSearch");
});
//--------------------------------------------------------------Fetch--------------------------------------------------------------------------------------------------//


function FetchRegisteration(event) {    // Commonly using CompanyStaffFetch
    var ItemMst = {
        SearchColumn: 'UserShiftStaffName-StaffName',//Id of Fetch field
        ResultColumns: ["UserRegistrationId-Primary Key", 'StaffName-Staff Name', 'Designation-UserShiftDesignation'],//Columns to be displayed
        FieldsToBeFilled: ["hdnRegistrationId-UserRegistrationId", 'UserShiftStaffName-StaffName', 'UserShiftMobileNo-MobileNumber', 'UserShiftUserType-UserType', 'UserShiftRole-Role', 'UserShiftDesignation-Designation']//id of element - the model property
    };
    DisplayFetchResult('divFetch', ItemMst, "/api/Fetch/UserShiftLeaveDetailsFetch", "Ulfetch", event, 1);
   
}


$('#hdnRegistrationId').change(function () {
    var UserRegistrationId = $('#hdnRegistrationId').val();
   
    $("#ShiftStartTime").val('');
    $("#ShiftStartTimeMin").val('');
    $("#ShiftEndTime").val('');
    $("#ShiftEndTimeMin").val('');
    $("#ShiftBreakStartTime").val('');
    $("#ShiftBreakStartTimeMin").val('');
    $("#ShiftBreakEndTime").val('');
    $("#ShiftBreakEndTimeMin").val('');
   getVal= $("#ShiftStartTime").val()

   if (getVal != "") {
        $("#UserShiftLeave :input:not(:button)").parent().removeClass('has-error');
    }
    
    if (UserRegistrationId != null && UserRegistrationId != "0" && UserRegistrationId !== "") {
        $.get("/api/UserShiftLeave/GetLeaveDetails/" + UserRegistrationId)

                          .done(function (result) {
                              var getResult = JSON.parse(result);
                             // $('#spnPopup-UserShift').hide();
                              //GetUserShiftsBind(getResult);LunchTimeLovId
                              $('#primaryID').val(getResult.UserShiftsId);
                              if (getResult.LunchTimeLovId != 0) {
                                  $("#UserShiftLunchTime").val(getResult.LunchTimeLovId);
                              }
                              $('#UserShiftWrkShftTime').val(getResult.ShiftTime)

                             RemoveSelected();
                             if (getResult.ShiftStartTime != null && getResult.ShiftStartTime != '') {
                                 $("#ShiftStartTime").val(parseInt(getResult.ShiftStartTime) + 1);
                                 $("#ShiftEndTime").val(parseInt(getResult.ShiftEndTime) + 1);
                                 $("#ShiftBreakStartTime").val(parseInt(getResult.ShiftBreakStartTime) + 1);
                                 $("#ShiftBreakEndTime").val(parseInt(getResult.ShiftBreakEndTime) + 1);
                                 $("#ShiftStartTimeMin").val(chkQrtr(parseInt(getResult.ShiftStartTimeMin)));
                                 $("#ShiftEndTimeMin").val(chkQrtr(parseInt(getResult.ShiftEndTimeMin)));
                                 $("#ShiftBreakStartTimeMin").val(chkQrtr(parseInt(getResult.ShiftBreakStartTimeMin)));
                                 $("#ShiftBreakEndTimeMin").val(chkQrtr(parseInt(getResult.ShiftBreakEndTimeMin)));
                             }
                              
                          
                              $("#UserShiftLeaveDetailstable").empty();

                              $.each(getResult.UserShiftLeaveGridData, function (index, value) {
                                  AddNewRowUserShift();
                                  $("#hdnUserShiftId_" + index).val(getResult.UserShiftLeaveGridData[index].UserShiftDetId);
                                  $("#LeaveFromGrid_" + index).val(DateFormatter(getResult.UserShiftLeaveGridData[index].LeaveFromGrid));
                                  $("#LeaveToGrid_" + index).val(DateFormatter(getResult.UserShiftLeaveGridData[index].LeaveToGrid));
                                  $("#NoOfDays_" + index).val(getResult.UserShiftLeaveGridData[index].NoOfDays);

                              });

                              $('#myPleaseWait').modal('hide');
                          })
            .fail(function () {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');
            });
    }
    else {
        $("#UserShiftLeaveDetailstable").empty();
        $('#spnPopup-UserShift').show();
    }
});

function chkQrtr(mnt) {
    if (mnt == 00) {
        var QtrVal = 1;
    }
    else if (mnt == 15) {
        var QtrVal = 2;
    }
    else if (mnt ==30) {
        var QtrVal = 3;
    }
    else if (mnt ==45) {
        var QtrVal = 4;
    }
    return QtrVal;
}

function chkIsDeletedRow(i, delrec) {
    if (delrec == true) {
        $('#LeaveFromGrid_' + i).prop("required", false);
        $('#LeaveToGrid_' + i).prop("required", false);
        $('#NoOfDays_' + i).prop("required", false);
        return true;
       
    }
    else {
        return false;
    }
}


function LinkClicked(id) {
    $(".content").scrollTop(1);
    EmptyFields();
    $("#UserShiftLeave :input:not(:button)").parent().removeClass('has-error');
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
        $("#UserShiftLeave :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0" && primaryId !== "") {
        $.get("/api/UserShiftLeave/Get/" + primaryId)

                          .done(function (result) {
                              var getResult = JSON.parse(result);
                               $('#spnPopup-UserShift').hide();
                             // $("#ShiftLeaveFrom").html("Leave From <span class='red'>*</span>");
                             // $("#ShiftLeaveTo").html("Leave To <span class='red'>*</span>");
                              GetUserShiftsBind(getResult);
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

$("#btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/Level/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('Level', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 EmptyFields();
             })
             .fail(function () {
                 showMessage('Level', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
        }

    });
}
function EmptyFields() {
    $(".content").scrollTop(0);
    $('input[type="text"], textarea').val('');
    //  $('#LevelFacility').val("null");
    $('#UserShiftLunchTime').val("null");
    $('#UserShiftStaffName').prop('disabled', false);
    $('#UserShiftWrkShftTime').val("null");   
    $("#UserShiftLeaveDetailstable").empty();
    $('#btnEdit').hide();
    $('#btnSave').show();
    RemoveSelected();
    //$('#ShiftStartTime').val('');
    //$('#ShiftStartTimeMin').val('');
    //$('#ShiftEndTime').val('');
    //$('#ShiftEndTimeMin').val('');
    //$('#ShiftBreakStartTime').val('');
    //$('#ShiftBreakStartTimeMin').val('');
    //$('#ShiftBreakEndTime').val('');
    //$('#ShiftBreakEndTimeMin').val('');
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $('#spnPopup-UserShift').hide();
    $("#grid").trigger('reloadGrid');
    $("#UserShiftLeave :input:not(:button)").parent().removeClass('has-error');
    $('#spnPopup-UserShift').show();
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
}
