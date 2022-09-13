$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    formInputValidation("Ulform");
    $('#btnDelete').hide();
    $('#btnEdit').hide();

    var UserAreaId = $("#UserAreaId").val();
    if (UserAreaId != null && UserAreaId != '' && UserAreaId != 0 && UserAreaId != "0") {
    }
    else {
        $("#jQGridCollapse1").click();
    }

    $("#ActiveToDate").prop('disabled', true);
    var ActionType = $("#ActionType").val();

    var UserAreaId = $("#UserAreaId").val();
    if (UserAreaId != null && UserAreaId != '' && UserAreaId != 0 && UserAreaId != "0") {
        $.get("/api/UserLocation/Load/" + UserAreaId)
       .done(function (result) {
           var loadResult = JSON.parse(result);
           //$("#jQGridCollapse1").click();
           $('#hdnUserAreaId').val(loadResult.UserAreaId);
           $('#txtUserAreaCode').val(loadResult.UserAreaCode);
           $('#txtUserAreaName').val(loadResult.UserAreaName);
           $('#hdnBlockId').val(loadResult.BlockId);
           $('#hdnLevelId').val(loadResult.LevelId);
           $('#txtBlockCode').val(loadResult.BlockCode);
           $('#txtBlockName').val(loadResult.BlockName);
           $('#txtUserLevelCode').val(loadResult.LevelCode);
           $('#txtUserLevelName').val(loadResult.LevelName);
           $('#txtUserAreaCode').attr('disabled', true);
           $('#txtBlockCode').attr('disabled', true);
           $('#txtUserLevelCode').attr('disabled', true);
           $('#spnPopup-userarea').hide();
           $('#spnPopup-Block').hide();
           $('#spnPopup-Level').hide();
       })
 .fail(function () {
     $('#myPleaseWait').modal('hide');
     $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
     $('#errorMsg').css('visibility', 'visible');
 });
    }

    $("#btnSave,#btnEdit,#btnSaveandAddNew").click(function () {
        $('#myPleaseWait').modal('show');
        $('#ActiveFromDate').parent().removeClass('has-error');
        $('#ActiveToDate').parent().removeClass('has-error');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var CurrentbtnID = $(this).attr("Id");
        var BlockId = $('#hdnBlockId').val();
        var LevelId = $('#hdnLevelId').val();
        var UserAreaId = $('#hdnUserAreaId').val();
        var UserAreaCode = $('#txtUserAreaCode').val();
        var UserAreaName = $('#txtUserAreaName').val();
        var CompanyStaffId = $('#hdnCompanyStaffId').val();
        var CompanyStaffName = $('#txtCompanyStaffName').val();
        var UserLocationCode = $('#UserLocationCode').val();
        var UserLocationName = $('#UserLocationName').val();
        var Active = $('#Active').val();
        // var checkBox = document.getElementById("Active");
        var status = true;
        if (Active == 1) {
            status = true;
        } else {
            status = false;
        }
        var ActiveFromDate = $('#ActiveFromDate').val();
        var ActiveToDate = $('#ActiveToDate').val();
        var AuthorizedStaffId = $('#hdnHospitalStaffId').val();
        var AuthorizedStaffName = $('#txtHospitalStaffName').val();
        var timeStamp = $("#Timestamp").val();

        var isFormValid = formInputValidation("Ulform", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            // $('#ActiveToDate').parent().addClass('has-error');
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            //$('#btnEdit').attr('disabled', false);
            return false;
        }
        else if (BlockId == 0 || BlockId == "0") {
            $("div.errormsgcenter").text("Valid Block is required");
            $('#txtBlockCode').parent().addClass('has-error');
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            return false;
        }
        else if (LevelId == 0 || LevelId == "0") {
            $("div.errormsgcenter").text("Valid Level is required");
            $('#txtUserLevelCode').parent().addClass('has-error');
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            return false;
        }
        else if (UserAreaId == 0 || UserAreaId == "0") {
            $("div.errormsgcenter").text("Valid Area Code is required");
            $('#txtUserAreaCode').parent().addClass('has-error');
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            return false;
        }

        else if (AuthorizedStaffId == 0 || AuthorizedStaffId == "0") {
            $("div.errormsgcenter").text("Valid Location Incharge is required");
            $('#txtHospitalStaffName').parent().addClass('has-error');
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            return false;
        }
        else if (CompanyStaffId == 0 || CompanyStaffId == "0") {
            $("div.errormsgcenter").text("Valid Company Representative is required");
            $('#txtCompanyStaffName').parent().addClass('has-error');
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            return false;
        }
        else if (status == false && (ActiveToDate == null || ActiveToDate == "")) {
            $("div.errormsgcenter").text("Stop Service Date is Mandatory");
            $('#ActiveToDate').parent().addClass('has-error');
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            return false;
        }
        else if (ActiveFromDate != null && ActiveFromDate != "" && ActiveToDate != null && ActiveToDate != "") {
            var fromDate = getDateToCompare($('#ActiveFromDate').val());
            var toDate = getDateToCompare($('#ActiveToDate').val());
            if (toDate < fromDate) {
                $("div.errormsgcenter").text("Stop Service Date Should be greater than Start Service Date ");
                $('#ActiveFromDate').parent().addClass('has-error');
                $('#errorMsg').css('visibility', 'visible');
                $('#btnlogin').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }
        var Obj = {};
        Obj.UserLocationCode = UserLocationCode;
        Obj.UserLocationName = UserLocationName;
        Obj.UserAreaCode = UserAreaCode;
        Obj.UserAreaName = UserAreaName;
        Obj.Active = status;
        Obj.UserAreaId = UserAreaId;
        Obj.BlockId = BlockId;
        Obj.LevelId = LevelId;
        Obj.ActiveFromDate = ActiveFromDate;
        Obj.ActiveToDate = ActiveToDate;
        Obj.AuthorizedStaffId = AuthorizedStaffId;
        Obj.AuthorizedStaffName = AuthorizedStaffName;
        Obj.CompanyStaffId = CompanyStaffId;
        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            Obj.UserLocationId = primaryId;
            Obj.Timestamp = timeStamp;
        }
        else {
            Obj.UserLocationId = 0;
            Obj.Timestamp = "";
        }
        
        var jqxhr = $.post("/api/UserLocation/Add", Obj, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.UserLocationId);
            $("#Timestamp").val(result.Timestamp);
            $("#grid").trigger('reloadGrid');
            $('#ActiveFromDate').parent().removeClass('has-error');
            if (result.UserLocationId != 0) {
                $('#hdnAttachId').val(result.HiddenId);
                //$("#txtUserAreaCode,#txtUserAreaName,#UserLocationCode,#UserLocationName").attr("disabled", "disabled");
                $("#txtUserAreaCode,#txtUserAreaName,#UserLocationCode,#txtBlockCode,#txtUserLevelCode").attr("disabled", true);
                if (result.isStartDateFuture) {
                    $("#UserLocationName").attr("disabled", false);
                }
                else {
                    $("#UserLocationName").attr("disabled", true);
                }


                $('#spnPopup-userarea').hide();
                $('#spnPopup-Block').hide();
                $('#spnPopup-Level').hide();
                $('#btnEdit').show();
                $('#btnSave').hide();
                $('#btnDelete').show();
            }
            $(".content").scrollTop(0);
            showMessage('User Location', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            if (CurrentbtnID == "btnSaveandAddNew") {
                ClearFields();
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

            //if (errorMessage == "1") {
            //    errorMessage = "Active To Date cannot be Future Date";
            //    // $('#ActiveToDate').parent().addClass('has-error');
            //}
            else if (errorMessage == "2") {
                errorMessage = "Location Start Service Date should be greater than or equal to Area Start Service Date";
                $('#ActiveFromDate').parent().addClass('has-error');
            }
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');

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
                ClearFields();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });

    $('#hdnBlockId').change(function () {


        $('#hdnLevelId').val('');
        $('#txtUserLevelCode').val('');
        $('#txtUserLevelName').val('');

        $('#txtUserAreaCode').val('');
        $('#txtUserAreaName').val('');
        $('#hdnUserAreaId').val('');
    });

    $('#hdnLevelId').change(function () {

        $('#txtUserAreaCode').val('');
        $('#txtUserAreaName').val('');
        $('#hdnUserAreaId').val('');
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
        ResultColumns: ["BlockId-Primary Key",  'BlockCode-Block Code', 'BlockName-Block Name'],//Columns to be returned for display
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

    // User Area Code fetch
    var UserAreaFetchObj = {
        SearchColumn: 'txtUserAreaCode-UserAreaCode',//Id of Fetch field
        ResultColumns: ["UserAreaId-Primary Key", 'UserAreaCode-User Area Code', 'UserAreaName-User Area Name'],//Columns to be displayed
        FieldsToBeFilled: ["hdnUserAreaId-UserAreaId", "txtUserAreaCode-UserAreaCode", "txtUserAreaName-UserAreaName"],//id of element - the model property
        AdditionalConditions: ["LevelId-hdnLevelId"]
    };
    $('#txtUserAreaCode').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch3', UserAreaFetchObj, "/api/Fetch/AreaCascCodeFetch", "UlFetch3", event, 1);//1 -- pageIndex
    });
    // User Area Code Search

    var UserAreaSearchObj = {
        Heading: "Area Details",//Heading of the popup
        SearchColumns: ['UserAreaCode-User Area Code', 'UserAreaName-User Area Name'],//ModelProperty - Space seperated label value
        ResultColumns: ["UserAreaId-Primary Key", 'UserAreaCode-User Area Code', 'UserAreaName-User Area Name'],//Columns to be returned for display
        FieldsToBeFilled: ["hdnUserAreaId-UserAreaId", "txtUserAreaCode-UserAreaCode", "txtUserAreaName-UserAreaName"],
        AdditionalConditions: ["LevelId-hdnLevelId"],
    };

    $('#spnPopup-userarea').click(function () {
        DisplaySeachPopup('divSearchPopup', UserAreaSearchObj, "/api/Search/AreaCascCodeSearch");
    });

    // Hospital Staff fetch
    var HosptialStaffFetchObj = {
        SearchColumn: 'txtHospitalStaffName-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name'],//Columns to be displayed
        FieldsToBeFilled: ["hdnHospitalStaffId-StaffMasterId", "txtHospitalStaffName-StaffName"]//id of element - the model property
    };
    $('#txtHospitalStaffName').on('input  propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch4', HosptialStaffFetchObj, "/api/Fetch/FacilityStaffFetch", "UlFetch4", event, 1);//1 -- pageIndex
    });



    // Hospital Staff Search
    var HospSearchObj = {
        Heading: "Location Incharge",//Heading of the popup
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
        DisplayFetchResult('divFetch5', CompanyStaffFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch5", event, 1);//1 -- pageIndex
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


});
$('#Active').click(function () {
    var value = $('#Active').val();
    if (value == 1) {
        $("#ActiveToDate").prop('disabled', true);
        $('#ActiveToDate').val(null);
        $("#stopdatelabelid").html('Stop Service Date');
        $('#ActiveToDate').parent().removeClass('has-error');
    }
    else {
        $("#stopdatelabelid").html('Stop Service Date <span class="red">&nbsp;*</span>');
        $("#ActiveToDate").prop('disabled', false);
    }
});

function LinkClicked(id) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    var action = "";
    $("#Ulform :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#primaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission ) {
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

        $("#UAform :input:not(:button)").prop("disabled", false);
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/UserLocation/Get/" + primaryId)
          .done(function (result) {
              var getResult = JSON.parse(result);
              $('#hdnBlockId').val(getResult.BlockId);
              $('#hdnLevelId').val(getResult.LevelId);
              $('#txtBlockCode').val(getResult.BlockCode);
              $('#txtBlockName').val(getResult.BlockName);
              $('#txtUserLevelCode').val(getResult.LevelCode);
              $('#txtUserLevelName').val(getResult.LevelName);
              $('#txtUserAreaCode').attr('disabled', true);
              $('#txtBlockCode').attr('disabled', true);
              $('#txtUserLevelCode').attr('disabled', true);
              $('#hdnUserAreaId').val(getResult.UserAreaId);
              $('#txtUserAreaCode').val(getResult.UserAreaCode);
              $('#txtUserAreaName').val(getResult.UserAreaName);
              $('#UserLocationCode').val(getResult.UserLocationCode);
              $('#UserLocationName').val(getResult.UserLocationName);
              $('#hdnAttachId').val(getResult.HiddenId);
              if (getResult.Active) {
                  $('#Active').val(1);
                  $("#Active").prop('checked', true);
                  $("#ActiveToDate").prop('disabled', true);
                  $("#ActiveToDate").val('');
                  $("#stopdatelabelid").html('Stop Service Date');
              }
              else {
                  $('#Active').val(0);
                  $("#ActiveToDate").prop('disabled', false);
                  $("#stopdatelabelid").html('Stop Service Date <span class="red">&nbsp;*</span>');
              }
              $('#spnPopup-userarea').hide();
              $('#spnPopup-Block').hide();
              $('#btnDelete').show();
              $('#spnPopup-Level').hide();
              $('#hdnCompanyStaffId').val(getResult.CompanyStaffId);
              $('#txtCompanyStaffName').val(getResult.CompanyStaffName);
              if (getResult.ActiveFromDate != null) {
                  $('#ActiveFromDate').val(DateFormatter(getResult.ActiveFromDate));
              }
              if (getResult.ActiveToDate != null) {
                  $('#ActiveToDate').val(DateFormatter(getResult.ActiveToDate));
              }
              if (ActionType == "View") {
                  $("#ActiveToDate").prop('disabled', true);
              }
              // var dates = moment(getResult.ActiveFromDate).format("DD-MMM-YYYY HH:mm")
              $('#txtHospitalStaffName').val(getResult.AuthorizedStaffName);
              $('#hdnHospitalStaffId').val(getResult.AuthorizedStaffId);
              $('#Timestamp').val(getResult.Timestamp);
              $("#txtUserAreaCode,#txtUserAreaName,#UserLocationCode,#txtBlockCode,#txtUserLevelCode").attr("disabled", true);
              if (getResult.isStartDateFuture) {
                  $("#UserLocationName").attr("disabled", false);
              }
              else {
                  $("#UserLocationName").attr("disabled", true);
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
        $("#txtUserAreaCode,#txtUserAreaName,#UserLocationCode,#UserLocationName").removeAttr("disabled");
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
            $.get("/api/UserLocation/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('User Location', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 $('#btnDelete').hide();
                 ClearFields();
             })
             .fail(function () {
                 showMessage('User Location', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
            $("#grid").trigger('reloadGrid');
        }
    });
}

function ClearFields() {
    $(".content").scrollTop(0);
    var UserAreaId = $("#UserAreaId").val();
    $('#hdnUserAreaId').val('');
    $('#hdnAttachId').val('');
    $('#btnDelete').hide();
    $('#txtUserAreaCode').val('');
    $('#txtUserAreaName').val('');
    $('#hdnBlockId').val('');
    $('#hdnLevelId').val('');
    $('#txtBlockCode').val('');
    $('#txtBlockName').val('');
    $('#txtUserLevelCode').val('');
    $('#txtUserLevelName').val('');
    $('#txtUserAreaCode').removeAttr("disabled");
    $('#spnPopup-userarea').show();
    $('#hdnCompanyStaffId').val('');
    $('#txtCompanyStaffName').val('');
    $('#UserLocationCode').val('');
    $('#UserLocationName').val('');
    $('#spnPopup-Block').show();
    $('#spnPopup-Level').show();
    $('#txtBlockCode').removeAttr("disabled")
    $('#txtUserLevelCode').removeAttr("disabled")

    $('#UserLocationCode').removeAttr("disabled")
    $('#UserLocationName').removeAttr("disabled")
    $('#txtHospitalStaffName').val('');
    $('#ActiveFromDate').val('');
    $('#ActiveToDate').val('');
    $('#Active').val(1);
    $('#spnActionType').text('Add');
    $('#primaryID').val('');
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnDelete').hide();
    $("#grid").trigger('reloadGrid');
    $("#Ulform :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#divCommonPagination').html(null);
    $('#errorMsg').css('visibility', 'hidden');
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