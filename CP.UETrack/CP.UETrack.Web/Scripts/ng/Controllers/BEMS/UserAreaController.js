
$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    formInputValidation("UAform");
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();

    var LevelId = $("#LevelId").val();
    if (LevelId != null && LevelId != '' && LevelId != 0 && LevelId != "0") {
        // 
    }
    else {
        $("#jQGridCollapse1").click();
    }


    var primaryId = $('#primaryID').val();
    var ActionType = $("#ActionType").val();
    $("#ActiveToDate").prop('disabled', true);

    var LevelId = $("#LevelId").val();
    if (LevelId != null && LevelId != '' && LevelId != 0 && LevelId != "0") {
        $.get("/api/UserArea/Load/" + LevelId)
       .done(function (result) {

           var loadResult = JSON.parse(result);
           $('#hdnLevelId').val(loadResult.LevelId);
           $('#txtUserLevelCode').val(loadResult.LevelCode);
           $('#txtUserLevelName').val(loadResult.LevelName);
           $('#hdnBlockId').val(loadResult.BlockId);
           $('#txtBlockCode').val(loadResult.BlockCode);
           $('#txtBlockName').val(loadResult.BlockName);
           $('#spnPopup-Level').hide();
           $('#spnPopup-Block').hide();
           $('#txtUserLevelCode,#txtBlockCode').attr('disabled', true);
       })
 .fail(function () {
     $('#myPleaseWait').modal('hide');
     $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
     $('#errorMsg').css('visibility', 'visible');
 });


    }


    // Hospital Staff fetch
    var HosptialStaffFetchObj = {
        SearchColumn: 'txtHospitalStaffName-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name'],//Columns to be displayed
        FieldsToBeFilled: ["hdnHospitalStaffId-StaffMasterId", "txtHospitalStaffName-StaffName"]//id of element - the model property
    };
    $('#txtHospitalStaffName').on('input  propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch3', HosptialStaffFetchObj, "/api/Fetch/FacilityStaffFetch", "UlFetch3", event, 1);//1 -- pageIndex
    });



    // Hospital Staff Search
    var HospSearchObj = {
        Heading: "Department Incharge",//Heading of the popup
        SearchColumns: ['StaffName-Staff Name'],//ModelProperty - Space seperated label value
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name'],//Columns to be returned for display
        FieldsToBeFilled: ["hdnHospitalStaffId-StaffMasterId", "txtHospitalStaffName-StaffName"]//id of element - the model property
    };

    $('#spnPopup-hospStaff').click(function () {
        DisplaySeachPopup('divSearchPopup', HospSearchObj, "/api/Search/FacilityStaffSearch");
    });

    // Company Staff fetch
    var CompanyStaffFetchObj = {
        SearchColumn: 'txtCompanyStaffName-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name'],//Columns to be displayed
        FieldsToBeFilled: ["hdnCompanyStaffId-StaffMasterId", "txtCompanyStaffName-StaffName"]//id of element - the model property
    };
    $('#txtCompanyStaffName').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch4', CompanyStaffFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch4", event, 1);//1 -- pageIndex
    });

    // Hospital Staff Search
    var CompanySearchObj = {
        Heading: "Company Representative",//Heading of the popup
        SearchColumns: ['StaffName-Staff Name'],//ModelProperty - Space seperated label value
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name'],//Columns to be returned for display
        FieldsToBeFilled: ["hdnCompanyStaffId-StaffMasterId", "txtCompanyStaffName-StaffName"]//id of element - the model property
    };

    $('#spnPopup-compStaff').click(function () {
        DisplaySeachPopup('divSearchPopup', CompanySearchObj, "/api/Search/CompanyStaffSearch");
    });



    // Block Code fetch
    var BlockCodeFetchObj = {
        SearchColumn: 'txtBlockCode-BlockCode',//Id of Fetch field
        ResultColumns: ["BlockId-Primary Key", 'BlockCode-Block Code', 'BlockName-Block Name'],//Columns to be displayed
        FieldsToBeFilled: ["hdnBlockId-BlockId", "txtBlockCode-BlockCode", "txtBlockName-BlockName"]//id of element - the model property
    };
    $('#txtBlockCode').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch1', BlockCodeFetchObj, "/api/Fetch/BlockCascCodeFetch", "UlFetch1", event, 1);//1 -- pageIndex
    });
    // Block Code Search
    var BlockSearchObj = {
        Heading: "Block Details",//Heading of the popup
        SearchColumns: ['BlockCode-Block Code', 'BlockName-Block Name'],//ModelProperty - Space seperated label value
        ResultColumns: ["BlockId-Primary Key", 'BlockCode-Block Code', 'BlockName-Block Name'],//Columns to be returned for display
        FieldsToBeFilled: ["hdnBlockId-BlockId", "txtBlockCode-BlockCode", "txtBlockName-BlockName"]//id of element - the model property
    };

    $('#spnPopup-Block').click(function () {
        DisplaySeachPopup('divSearchPopup', BlockSearchObj, "/api/Search/blockSearch");
    });

    // Leveel Code fetch
    var LevelCodeFetchObj = {
        SearchColumn: 'txtUserLevelCode-LevelCode',//Id of Fetch field
        ResultColumns: ["LevelId-Primary Key", 'LevelCode-Level Code', 'LevelName-Level Name'],//Columns to be displayed
        FieldsToBeFilled: ["hdnLevelId-LevelId", "txtUserLevelCode-LevelCode", "txtUserLevelName-LevelName"],
        AdditionalConditions: ["BlockId-hdnBlockId"],
    };

    $('#hdnBlockId').change(function () {
        $('#hdnLevelId').val('');
        $('#txtUserLevelCode').val('');
        $('#txtUserLevelName').val('');
    });
    $('#txtUserLevelCode').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch2', LevelCodeFetchObj, "/api/Fetch/LevelCascCodeFetch", "UlFetch2", event, 1);//1 -- pageIndex
    });
    // Leveel Code Search
    var LevelCodeSearchObj = {
        Heading: "Level Details",//Heading of the popup
        SearchColumns: ['LevelCode-Level Code', 'LevelName-Level Name'],//ModelProperty - Space seperated label value
        ResultColumns: ["LevelId-Primary Key", 'LevelCode-Level Code', 'LevelName-Level Name'],//Columns to be returned for display
        FieldsToBeFilled: ["hdnLevelId-LevelId", "txtUserLevelCode-LevelCode", "txtUserLevelName-LevelName"],
        AdditionalConditions: ["BlockId-hdnBlockId"],
    };

    var apiUrlForTypeCodeSearch = "/api/Search/LevelCscSearch";

    $('#spnPopup-Level').click(function () {
        DisplaySeachPopup('divSearchPopup', LevelCodeSearchObj, apiUrlForTypeCodeSearch);
    });

    function DisplayError() {
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnSave').attr('disabled', false);
    }

    $("#btnSave, #btnEdit,#btnSaveandAddNew").click(function () {
        $('#myPleaseWait').modal('show');
        $('#ActiveFromDate').parent().removeClass('has-error')
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var CurrentbtnID = $(this).attr("Id");
        var UserAreaCode = $('#UserAreaCode').val();
        var UserAreaName = $('#UserAreaName').val();
        var BlockId = $('#hdnBlockId').val();
        var FacilityId = $('#FacilityId').val();
        var CustomerId = $('#CustomerId').val();
        var LevelId = $('#hdnLevelId').val();
        var UserLevelCode = $('#txtUserLevelCode').val();
        var Active = $('#Active').val();
        var status = true;
        if (Active == 1) {
            status = true;
        }
        else {
            status = false;
        }
        var HospitalStaffName = $('#txtHospitalStaffName').val();
        var CompanyStaffId = $('#hdnCompanyStaffId').val();
        var CompanyStaffName = $('#txtCompanyStaffName').val();
        var HospitalStaffId = $('#hdnHospitalStaffId').val();
        var Remarks = $('#Remarks').val();
        var ActiveFromDate = $('#ActiveFromDate').val();
        var ActiveToDate = $('#ActiveToDate').val();
        var timeStamp = $("#Timestamp").val();

        var isFormValid = formInputValidation("UAform", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            if (BlockId == null || BlockId == 0) {
                $('#hdnBlockId').parent().addClass('has-error');
            }
            else {
                $('#hdnBlockId').parent().removeAttr('has-error');
            }
            if (LevelId == null || LevelId == 0) {
                $('#hdnLevelId').parent().addClass('has-error');
            }
            else {
                $('#hdnLevelId').parent().removeAttr('has-error');
            }
            if (CompanyStaffId == null || CompanyStaffId == 0) {
                $('#hdnCompanyStaffId').parent().addClass('has-error');
            }
            else {
                $('#hdnCompanyStaffId').parent().removeAttr('has-error');
            }
            if (HospitalStaffId == null || HospitalStaffId == 0) {
                $('#hdnHospitalStaffId').parent().addClass('has-error');
            }
            else {
                $('#hdnHospitalStaffId').parent().removeAttr('has-error');
            }
            DisplayError();
            //$('#btnEdit').attr('disabled', false);
            return false;
        }
        else if (BlockId == null || BlockId == 0 || LevelId == null || LevelId == 0 || CompanyStaffId == null || CompanyStaffId == 0 || HospitalStaffId == null || HospitalStaffId == 0) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            if (BlockId == null || BlockId == 0) {
                $('#hdnBlockId').parent().addClass('has-error');
            }
            else {
                $('#hdnBlockId').parent().removeAttr('has-error');
            }
            if (LevelId == null || LevelId == 0) {
                $('#hdnLevelId').parent().addClass('has-error');
            }
            else {
                $('#hdnLevelId').parent().removeAttr('has-error');
            }
            if (CompanyStaffId == null || CompanyStaffId == 0) {
                $('#hdnCompanyStaffId').parent().addClass('has-error');
            }
            else {
                $('#hdnCompanyStaffId').parent().removeAttr('has-error');
            }
            if (HospitalStaffId == null || HospitalStaffId == 0) {
                $('#hdnHospitalStaffId').parent().addClass('has-error');
            }
            else {
                $('#hdnHospitalStaffId').parent().removeAttr('has-error');
            }
            DisplayError();
            return false;
        }
        else if (status == false && (ActiveToDate == null || ActiveToDate == "")) {
            // $("div.errormsgcenter").text("Stop Service Date is Mandatory");
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#ActiveToDate').parent().addClass('has-error');
            $('#ActiveToDate').parent().addClass('has-error');
            DisplayError();
            return false;
        }
        else if (ActiveFromDate != null && ActiveFromDate != "" && ActiveToDate != null && ActiveToDate != "") {
            var fromDate = getDateToCompare($('#ActiveFromDate').val());
            var toDate = getDateToCompare($('#ActiveToDate').val());

            if (toDate < fromDate) {
                $('#ActiveFromDate').parent().addClass('has-error');
                $("div.errormsgcenter").text("Stop Service Date Should be greater than Start Service Date ");
                DisplayError();
                return false;
            }
        }
        var Obj = {};
        Obj.UserAreaCode = UserAreaCode;
        Obj.UserAreaName = UserAreaName;
        Obj.BlockId = BlockId;
        Obj.FacilityId = FacilityId;
        Obj.CustomerId = CustomerId;
        Obj.LevelId = LevelId;
        Obj.Active = status;
        Obj.UserLevelCode = UserLevelCode;
        Obj.HospitalStaffName = HospitalStaffName;
        Obj.HospitalStaffId = HospitalStaffId;
        Obj.CompanyStaffName = CompanyStaffName;
        Obj.ActiveFromDate = ActiveFromDate;
        Obj.ActiveToDate = ActiveToDate;
        Obj.CompanyStaffId = CompanyStaffId;
        Obj.Remarks = Remarks;
        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            Obj.UserAreaId = primaryId;
            Obj.Timestamp = timeStamp;
        }
        else {
            Obj.UserAreaId = 0;
            Obj.Timestamp = "";
        }
        var jqxhr = $.post("/api/UserArea/Add", Obj, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.UserAreaId);
            $("#Timestamp").val(result.Timestamp);
            $("#grid").trigger('reloadGrid');
            if (result.UserAreaId != 0) {
                if (result.isStartDateFuture) {
                    $("#UserAreaName").attr("disabled", false);
                }
                else {
                    $("#UserAreaName").attr("disabled", true);
                }

                $('#hdnAttachId').val(result.HiddenId);
                $("#UserAreaCode").attr("disabled", "disabled");
                $('#txtUserLevelCode,#txtBlockCode').attr('disabled', true);
                $('#Blockcodepopup').hide();
                $('#levlcodepopup').hide();
                $('#btnNextScreenSave').show();
                $('#btnEdit').show();
                $('#btnSave').hide();
                $('#btnDelete').show();
            }
            $(".content").scrollTop(0);
            showMessage('User Área', CURD_MESSAGE_STATUS.SS);
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
            }
            else {
                errorMessage = Messages.COMMON_FAILURE_MESSAGE;
            }

            if (errorMessage == "1") {
                errorMessage = "Stop Service Date cannot be Future Date";
                $('#ActiveToDate').parent().addClass('has-error');
            }
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
    });


});


$('#Active').change(function () {
    var value = $('#Active').val();
    if (value == 1) {
        //  $("#ActiveFromDate").val('');
        $("#ActiveToDate").prop('disabled', true);
        $('#ActiveToDate').val(null);
        $("#stopdatelabelid").html('Stop Service Date');
    }
    else {

        $("#stopdatelabelid").html('Stop Service Date <span class="red">&nbsp;*</span>');
        $("#ActiveToDate").prop('disabled', false);
    }
});
function LinkClicked(id) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#UAform :input:not(:button)").parent().removeClass('has-error');
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
        $("#UAform :input:not(:button)").prop("disabled", true);
        $('#levlcodepopup,#hospStaffpopup,#companypopup').hide();
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/UserArea/Get/" + primaryId)
          .done(function (result) {
              var getResult = JSON.parse(result);
              $('#btnDelete').show();

              $('#UserAreaCode').val(getResult.UserAreaCode);
              $('#UserAreaName').val(getResult.UserAreaName);
              $('#hdnBlockId').val(getResult.BlockId);
              $('#txtBlockCode').val(getResult.BlockCode);
              $('#txtBlockName').val(getResult.BlockName);
              $('#hdnLevelId').val(getResult.LevelId);
              $('#txtUserLevelCode').val(getResult.UserLevelCode);
              $('#txtUserLevelCode,#txtBlockCode').attr('disabled', true);
              $('#levlcodepopup,#Blockcodepopup').hide();
              $('#txtUserLevelName').val(getResult.UserLevelName);
              $('#Active').val(getResult.Active);
              $('#hdnAttachId').val(getResult.HiddenId);
              if (getResult.Active) {
                  $('#Active').val(1);
                  $("#ActiveToDate").prop('disabled', true);
                  //$("#stopdatelabelid").html('Stop Service Date <span class="red">&nbsp;*</span>');
              }
              else {
                  $('#Active').val(0);
                  $("#ActiveToDate").prop('disabled', false);
                  $("#stopdatelabelid").html('Stop Service Date <span class="red">&nbsp;*</span>');
              }
              if (getResult.ActiveFromDate != null) {
                  $('#ActiveFromDate').val(DateFormatter(getResult.ActiveFromDate));
              }
              if (getResult.ActiveToDate != null) {

                  $('#ActiveToDate').val(DateFormatter(getResult.ActiveToDate));
              }
              if (ActionType == "View") {
                  $("#ActiveToDate").prop('disabled', true);
              }
              $('#hdnCompanyStaffId').val(getResult.CompanyStaffId);
              $('#txtCompanyStaffName').val(getResult.CompanyStaffName);
              $('#hdnHospitalStaffId').val(getResult.HospitalStaffId);
              $('#txtHospitalStaffName').val(getResult.HospitalStaffName);
              $('#Remarks').val(getResult.Remarks);
              $('#Timestamp').val(getResult.Timestamp);
              $('#UserAreaCode').prop('title', $('#UserAreaCode').val());
              $('#UserAreaName').prop('title', $('#UserAreaName').val());
              $('#txtUserLevelCode').prop('title', $('#txtUserLevelCode').val());
              $('#txtUserLevelName').prop('title', $('#txtUserLevelName').val());

              $("#UserAreaCode").attr("disabled", "disabled");
              if (getResult.isStartDateFuture) {
                  $("#UserAreaName").attr("disabled", false);
              }
              else {
                  $("#UserAreaName").attr("disabled", true);
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
        $("#UserAreaCode,#UserAreaName").removeAttr("disabled");
        $('#myPleaseWait').modal('hide');
    }
}

$("#btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/UserArea/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('User Area', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 EmptyFields();
             })
             .fail(function () {
                 showMessage('User Area', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
        }

    });
}

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
function EmptyFields() {
    $(".content").scrollTop(0);
    //  $('input[type="text"], textarea').val('');
    var LevelId = $("#LevelId").val();
    $('#hdnAttachId').val('');
    $('#hdnBlockId').val('');
    $('#txtBlockCode').val('');
    $('#txtBlockName').val('');
    $('#hdnLevelId').val('');
    $('#txtUserLevelCode').val('');
    $('#txtUserLevelName').val('');
    $('#txtUserLevelCode,#txtBlockCode').attr('disabled', false);
    $('#spnPopup-Level').show();
    $('#spnPopup-Block').show();
    //  }
    $('#UserAreaCode').val('');
    $('#UserAreaName').val('');
    $('#ActiveFromDate').val('');
    $('#ActiveToDate').val('');
    $('#Active').val(1);
    $('#levlcodepopup,#Blockcodepopup').show();
    $('#hdnCompanyStaffId').val('');
    $('#txtCompanyStaffName').val('');
    $('#hdnHospitalStaffId').val('');
    $('#txtHospitalStaffName').val('');
    $('#Remarks').val('');


    $('#UserAreaCode').prop("disabled", false);
    $('#UserAreaName').prop("disabled", false);
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#UserAreaId").val('');
    $("#grid").trigger('reloadGrid');
    $("#UAform :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
}


$("#btnNextScreenSave").click(function () {
    var msg = 'Do you want to proceed to Location screen?';
    var primaryId = $("#primaryID").val();
    var hdnStatus = $("#Active").val();

    if (hdnStatus == 0 || hdnStatus == '0' || hdnStatus == 'null') {
        bootbox.alert('Only Active Area can be navigated to Location Screen');

    }
   else if (primaryId != null && primaryId != 0 && primaryId != "0" && primaryId != '') {
        bootbox.confirm(msg, function (Conform) {
            if (Conform) {
                window.location.href = "/bems/userlocation/Add/" + primaryId;
            }
            else {
                bootbox.hideAll();
                return false;
            }
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