window.BookingStatus = [];
window.AssetBookingList = [];
window.GlobalFacilityLovs = [];
$(document).ready(function () {
    // added by pravin
    $('#txtUserLocationCode').prop('disabled', true);
    $('#spnPopup-Location').hide();
    $('#myPleaseWait').modal('show');
    formInputValidation("bookingFormId");
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnVerify').hide();
    $('#btnReject').hide();
    $('#btnApprove').hide();
    $('#btnNextScreenSave').hide();    // ;
    $('#btnApprovePortering').hide();
    $('#txtMaintenanceWorkNo').prop('disabled', true);
    $('#WonDiv').hide();
    $('#ToLocation_1').attr('disabled', true);
    var hasAddPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Add'");
    var hasVerifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Verify'");
    var hasApprovePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");

    if (hasAddPermission) {
        $('#btnSave').show();
        $('#btnSaveandAddNew').show();
        $('#btnCancel').show();
    }
    //// removed by deepak
    //if (hasVerifyPermission || hasApprovePermission) {
    //    $('#btnCancel').hide();
    //    $('#btnSave').hide();
    //    $('#btnSaveandAddNew').hide();
    //}
       

    $.get("/api/Booking/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $.each(loadResult.PorteringStatusLovs, function (index, value) {
                $('#BookingStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            $.each(loadResult.MovementCategoryLovs, function (index, value) {
                $('#MovementCategory').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.RequestTypeLovs, function (index, value) {
                $('#RequestTypeLovId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            window.GlobalFacilityLovs = loadResult.FromFacilityLovs;
            $.each(loadResult.FromFacilityLovs, function (index, value) {
                $('#ToLocation_1').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $('#CurrentDate').val(DateFormatter(loadResult.CurrentDate));
            $('#hdnFacilityId').val(loadResult.ToFacilityId);
            var primaryId = $('#primaryID').val();

        })
  .fail(function () {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
      $('#errorMsg').css('visibility', 'visible');
  });


    function zeroPad(num, places) {
        var zero = places - num.toString().length + 1;
        return Array(+(zero > 0 && zero)).join("0") + num;
    }

    $('.bookingDate').datetimepicker({
        minDate: Date(),
        format: 'd-M-Y',
        timepicker: false,
        step: 15,
        onChangeDateTime: function (dp, $input) {
            if ($input.val() !== "")
                $($input).parent().removeClass('has-error');
            //$($input).css('color', 'none');
        },
        scrollInput: false,
        beforeShowDay: function (date) {
            var theday = zeroPad(date.getMonth() + 1, 2) + '/' +
                            zeroPad(date.getDate(), 2) + '/' +
                        date.getFullYear();
            return [true, $.inArray(theday, window.AssetBookingList) >= 0 ? "specialDate specialTextDate" : ''];
        }//, addDisabledDates: $.inArray(theday, window.AssetBookingList)
    });

    function DisplayErrors() {
        $('#errorMsg').css('visibility', 'visible');
        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
    }

    $(".bookButton").click(function () {

        var buttonName = $(this).attr('Id');

        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');
        var CurrentbtnID = $(this).attr("Id");
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var primaryId = $("#primaryID").val();
        var BookingStartFromDate = $('#BookingStartFromDate').val();
        var BookingEndDate = $('#BookingEndDate').val();
        var timeStamp = $("#Timestamp").val();

        //booking status 
        var bookingstatus;
        if (buttonName == "btnSave" || buttonName == "btnSaveandAddNew") {
            bookingstatus = 246;
        }
        else if (buttonName == "btnApprove") {
            bookingstatus = 247;

        }
        else if (buttonName == "btnReject") {
            bookingstatus = 248;

        }
        else if (buttonName == "btnVerify") {
            bookingstatus = 309;

        }
        else if (buttonName == "btnEdit") { //extention
            bookingstatus = 246;
        }

        // within facility no need of approval process 
        if ($('#MovementCategory').val() == 239 || $('#MovementCategory').val() == "239") {
            if ($('#hdnTypeOfAsset').val() != "190" && $('#hdnTypeOfAsset').val() != 190) {
                bookingstatus = 247;
            }

        }

        var Obj = {
            AssetId: $('#hdnAssetId').val(),
            AssetNo: $('#txtAssetNo').val(),
            WorkOrderId: $('#hdnWorkOrderId').val(),
            BookingStartFrom: BookingStartFromDate,
            BookingEnd: $('#BookingEndDate').val(),
            MovementCategory: $('#MovementCategory').val(),
            ToFacilityId: $("#ToLocation_1").val(),
            ToBlockId: $('#ToLocation_2').val(),
            ToLevelId: $('#ToLocation_3').val(),
            ToUserAreaId: $('#ToLocation_4').val(),
            ToUserLocationId: $('#ToLocation_5').val(),
            RequestorId: $('#hdnCompanyStaffId').val(),
            BookingStatus: bookingstatus,
            RequestType: $('#RequestTypeLovId').val(),
            LoanerTestEquipmentBookingId: primaryId != null ? primaryId : 0,
            Timestamp: primaryId != null ? $('#Timestamp').val() : "",
            CompanyRepEmail: $('#hdnCompRepEmail').val(),
            CompanyRepId: $('#hdnCompRepId').val()
        }

        var isFormValid = formInputValidation("bookingFormId", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            DisplayErrors();
            return false;
        }
        else if ($('#hdnAssetId').val() == 0 || $('#hdnAssetId').val() == "0") {
            $('#hdnAssetId').parent().addClass('has-error');
            $("div.errormsgcenter").text("Valid Loaner / Test Equipment No. is required ");
            DisplayErrors();
            return false;
        }
        else if ($('#hdnCompanyStaffId').val() == 0 || $('#hdnCompanyStaffId').val() == "0") {
            $('#hdnCompanyStaffId').parent().addClass('has-error');
            $("div.errormsgcenter").text("Valid Requestor Name is required ");
            DisplayErrors();
            return false;
        }

        var jqxhr = $.post("/api/Booking/add", Obj, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.LoanerTestEquipmentBookingId);
            $("#Timestamp").val(result.Timestamp);
            $('#hdnAttachId').val(result.HiddenId);
            BindData(result);
            $("#grid").trigger('reloadGrid');
            $(".content").scrollTop(0);
            showMessage('Booking', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);
            $('#spnPopup-Location').hide();
            $('#btnSave').hide();
            $('#btnEdit').hide();
            $('#btnSaveandAddNew').hide()
            $('#btnVerify').hide();
            $('#btnReject').hide();
            $('#btnApprove').hide();


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
                errorMessage = "Booking Start Date cannot be Past Date";
                $('#BookingStartFromDate').parent().addClass('has-error');
            }
            else if (errorMessage == "2") {
                errorMessage = "Booking End Date cannot be Past Date";
                $('#BookingEndDate').parent().addClass('has-error');
            }
            else if (errorMessage == "3") {
                errorMessage = "Booking End Date should be greater than or equal to Booking Start Date";
                $('#BookingEndDate').parent().addClass('has-error');
            }
            else if (errorMessage == "4" || errorMessage == "5" || errorMessage == "6") {
                errorMessage = Messages.COMMON_FAILURE_MESSAGE;
                if (errorMessage == "4") {
                    $('#BookingStartFromDate').parent().addClass('has-error');
                    $('#BookingEndDate').parent().addClass('has-error');
                }
                if (errorMessage == "5") {
                    $('#BookingEndDate').parent().addClass('has-error');
                }
                if (errorMessage == "6") {
                    $('#BookingStartFromDate').parent().addClass('has-error');
                }
            }
            else if (errorMessage == "7") {
                errorMessage = "Booking End Date should be greater than Booking Start From Date";
                $('#BookingEndDate').parent().addClass('has-error');
                $('#BookingStartFromDate').parent().addClass('has-error');
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
                EmptyFields();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
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


    // **** Query String to get ID Begin****\\\

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
    // **** Query String to get ID  End****\\\


    $('#btnEditPortering').click(function () {
        var CurrentDate = getDateToCompare($('#CurrentDate').val());
        var BookingEndDate = getDateToCompare($('#BookingEndDate').val());
        var primaryId = $('#primaryID').val();
        if (CurrentDate - BookingEndDate === 0) {
            bootbox.alert('Porteing is not allowed if the Current Date equal to Booking End Date');
        }
        else {
            window.location.href = "/bems/assettracker/Add/" + primaryId;
        }
    });

    //******************************************* When Asset Id Changed *********************************************// 

    $('#hdnAssetId').change(function () {
        var AssetId = $('#hdnAssetId').val();

        window.AssetBookingList = [];
        if (AssetId != 0 && AssetId != '' && AssetId != null && AssetId != undefined && AssetId != '0') {
            $('#txtUserLocationCode').prop('disabled', false);
            $('#spnPopup-Location').show();
            $('#txtMaintenanceWorkNo').prop('disabled', false);
            $('#WonDiv').show();
            $.get("/api/Booking/GetBookingDates/" + AssetId)
         .done(function (result) {
             var res = JSON.parse(result);
             $('#AssetFacilityId').val(res.AssetFacilityId);
             var assetFacilityId = res.AssetFacilityId;
             var currentFacilityId = $('#hdnFacilityId').val();
             if (assetFacilityId == currentFacilityId) {
                 $('#MovementCategory').val(239);
                 AssetMovement(239, AssetId);
             }
             else {
                 $('#MovementCategory').val(240);
                 AssetMovement(240, AssetId);
             }

             if (res.BookedDateList != null && res.BookedDateList.length > 0) {
                 $.each(res.BookedDateList, function (index, data) {
                     var datepart = data.split('T')[0];
                     var bookeddate = datepart.split('-');
                     var year = bookeddate[0];
                     var month = bookeddate[1];
                     var day = bookeddate[2];
                     var bookeddate1 = month + "/" + day + "/" + year;
                     //window.AssetBookingList.push('08/19/2018');
                     //window.AssetBookingList.push('08/15/2018');
                     //window.AssetBookingList.push('08/16/2018');
                     window.AssetBookingList.push(bookeddate1.toString());
                 });
                 //debugger;  getbookingDate();
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
            $('#ToLocation_1').val('null');
            $('#ToLocation_2').val('');
            $('#ToLocation_3').val('');
            $('#ToLocation_4').val('');
            $('#ToLocation_5').val('');

            $('#txtUserLocationCode').val('');
            $('#txtUserLocationName').val('');
            $('#txtUserAreaCode').val('');
            $('#txtUserAreaName').val('');
            $('#txtUserLevelCode').val('');
            $('#txtUserLevelName').val('');
            $('#txtBlockCode').val('');
            $('#txtBlockName').val('');
            $('#MovementCategory').val('null');
            $('#txtUserLocationCode').prop('disabled', true);
            $('#spnPopup-Location').hide();
            $('#txtMaintenanceWorkNo').prop('disabled', true);
            $('#WonDiv').hide();
        }
    });

    //******************************************* When Asset Id Changed *********************************************// 
    $('#MovementCategory').change(function () {
        var movementType = $('#MovementCategory').val();
        var AssetId = $('#hdnAssetId').val();

        if (AssetId == null || AssetId == 0 || AssetId == "0" || AssetId == "null" || AssetId == undefined) {
            bootbox.alert("Please Select Loaner Test Equipment No. / Work Order No.");
            $('#MovementCategory').val("null");
        }
        else {
            AssetMovement(movementType, AssetId);
        }

    });

    function AssetMovement(movementType, AssetId) {
        ClearDropDownFields(6);
        if (movementType == 239 || movementType == 240) {

            $('#ToLocation_1').attr('disabled', false);
            $('#ToLocation_1').val($('#hdnFacilityId').val());
            $('#ToLocation_1').prop('disabled', true);
            GetLocationList(1);
        }
        else {
            $('#ToLocation_1').attr('disabled', true);
            ClearDropDownFields(6);
        }

    }



    /******************************************************* Fetch and Search Start ******************************************************/
    var AssetNoFetch = {
        SearchColumn: 'txtAssetNo-AssetNo',//Id of Fetch field
        ResultColumns: ["AssetId-Primary Key", 'AssetNo-Asset No.'],
        FieldsToBeFilled: ["hdnAssetId-AssetId", "txtAssetNo-AssetNo", "hdnTypeOfAsset-TypeOfAsset", "hdnCompRepId-CompanyRepId", "hdnCompRepEmail-CompanyRepEmail"]
    };

    $('#txtAssetNo').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch', AssetNoFetch, "/api/Fetch/BookingAssetNoFetch", "UlFetch", event, 1);//1 -- pageIndex
    });

    var AssetSearchObj = {
        Heading: "Asset Details",
        SearchColumns: ['AssetNo-Asset No.', 'AssetTypeCode-Type Code', 'AssetTypeDescription-Asset Type Description'],
        //ModelProperty - Space seperated label value
        ResultColumns: ['AssetId-Primary Key', 'AssetNo-Asset No.', 'AssetTypeCode-Type Code', 'AssetTypeDescription-Asset Type Description', 'Model-Model', 'Manufacturer-Manufacturer', 'FacilityName-Facility Name', "BookingStartDate- Booking Start Date", "BookingEndDate-Booking End Date", "NumberofDays-No. of Days", "CalibrationdueDate-Calibration Due Date"],
        FieldsToBeFilled: ["hdnAssetId-AssetId", "txtAssetNo-AssetNo", "hdnTypeOfAsset-TypeOfAsset"]
    };
    $('#spnPopup-asset').click(function () {
        DisplaySeachPopup('divSearchPopup', AssetSearchObj, "/api/Search/BookingAssetNoSearch");
    });


    var WorkOrderNoFetch = {
        SearchColumn: 'txtMaintenanceWorkNo-MaintenanceWorkNo',//Id of Fetch field
        ResultColumns: ["WorkOrderId-Primary Key", 'MaintenanceWorkNo-Maintenance Work No.'],
        FieldsToBeFilled: ["hdnWorkOrderId-WorkOrderId", "txtMaintenanceWorkNo-MaintenanceWorkNo", "hdnTypeOfAsset-TypeOfAsset"],
        AdditionalConditions: ["AssetId-hdnAssetId"],
    };
    $('#txtMaintenanceWorkNo').on('input propertychange paste keyup', function (event) {
        $('#divFetch2').css({
            'width': $('#BookingEndDate').outerWidth()
        });

        DisplayFetchResult('divFetch2', WorkOrderNoFetch, "/api/Fetch/BookingWorkOrderNoFetch", "UlFetch2", event, 1);//1 -- pageIndex
    });

    var WorkorderSearchObj = {
        Heading: "Work Order Details",
        SearchColumns: ['MaintenanceWorkNo-Work Order No.'],//ModelProperty - Space seperated label value
        ResultColumns: ["WorkOrderId-Primary Key", 'MaintenanceWorkNo-Work Order No.', 'AssetNo-Asset No', 'FacilityName-Facility Name', "BookingStartDate- Booking Start Date", "BookingEndDate-Booking End Date"],
        FieldsToBeFilled: ["hdnWorkOrderId-WorkOrderId", "txtMaintenanceWorkNo-MaintenanceWorkNo", "hdnTypeOfAsset-TypeOfAsset"],
        AdditionalConditions: ["AssetId-hdnAssetId"],
    };
    $('#spnPopup-won').click(function () {
        DisplaySeachPopup('divSearchPopup', WorkorderSearchObj, "/api/Search/BookingWorkOrderNoSearch");
    });
    var CompanyStaffFetchObj = {
        SearchColumn: 'txtCompanyStaffName-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name', 'Designation-Designation'],
        FieldsToBeFilled: ["hdnCompanyStaffId-StaffMasterId", "txtCompanyStaffName-StaffName", "txtDesignation-Designation"]
    };
    $('#txtCompanyStaffName').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch3', CompanyStaffFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch3", event, 1);//1 -- pageIndex
    });

    var CompanySearchObj = {
        Heading: "Requestor Details",//Heading of the popup
        SearchColumns: ['StaffName-Requestor Name'],//ModelProperty - Space seperated label value
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Requestor Name', 'Designation-Designation'],//Columns to be returned for display
        FieldsToBeFilled: ["hdnCompanyStaffId-StaffMasterId", "txtCompanyStaffName-StaffName", "txtDesignation-Designation"]
    };

    $('#spnPopup-compStaff').click(function () {
        DisplaySeachPopup('divSearchPopup', CompanySearchObj, "/api/Search/CompanyStaffSearch");
    });
    
    // User Area Code fetch
    var UserLocationFetchObj = {
        SearchColumn: 'txtUserLocationCode-UserLocationCode',//Id of Fetch field
        ResultColumns: ["UserLocationId-Primary Key", 'UserLocationCode- Location Code', 'UserLocationName-Location Name'],//Columns to be displayed
        FieldsToBeFilled: ["ToLocation_5-UserLocationId", "txtUserLocationCode-UserLocationCode", "txtUserLocationName-UserLocationName",
                                "ToLocation_4-UserAreaId", "txtUserAreaCode-UserAreaCode", "txtUserAreaName-UserAreaName",
                                "ToLocation_3-LevelId", "txtUserLevelCode-LevelCode", "txtUserLevelName-LevelName",
                                "ToLocation_2-BlockId", "txtBlockCode-BlockCode", "txtBlockName-BlockName"


        ],//id of element - the model property
        AdditionalConditions: ["FacilityId-ToLocation_1"]
    };
    $('#txtUserLocationCode').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch7', UserLocationFetchObj, "/api/Fetch/BookingLocationFetch", "UlFetch7", event, 1);//1 -- pageIndex
    });
    // User Area Code Search

    var UserLocationSearchhObj = {
        Heading: "To Location Details",//Heading of the popup
        SearchColumns: ['UserLocationCode-User Location Code', 'UserLocationName-User Location Name'],//ModelProperty - Space seperated label value
        ResultColumns: ["UserLocationId-Primary Key", 'UserLocationCode-Location Code', 'UserLocationName-Location Name',
                         'UserAreaCode-Area Code', 'UserAreaName-Area Name',
                         'LevelCode-Level Code', 'LevelName-Level Name',
                         'BlockCode-Block Code', 'BlockName-Block Name'
        ],//Columns to be returned for display
        FieldsToBeFilled: ["ToLocation_5-UserLocationId", "txtUserLocationCode-UserLocationCode", "txtUserLocationName-UserLocationName",
                               "ToLocation_4-UserAreaId", "txtUserAreaCode-UserAreaCode", "txtUserAreaName-UserAreaName",
                               "ToLocation_3-LevelId", "txtUserLevelCode-LevelCode", "txtUserLevelName-LevelName",
                               "ToLocation_2-BlockId", "txtBlockCode-BlockCode", "txtBlockName-BlockName"
        ],
        AdditionalConditions: ["FacilityId-ToLocation_1"]
    };

    $('#spnPopup-Location').click(function () {
        DisplaySeachPopup('divSearchPopup', UserLocationSearchhObj, "/api/Search/BookingLocationSearch");
    });


    /******************************************************* Fetch and Search End ******************************************************/

    $('[id^=ToLocation_]').change(function () {
        var id = $(this).attr('id');
        var locationNo = id.substring(id.indexOf('_') + 1);
        GetLocationList(locationNo);
    });



});

function LinkClicked(id) {
    $(".content").scrollTop(1);
    $("#bookingFormId :input:not(:button)").parent().removeClass('has-error');
    $('#btnEditPortering').hide();
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasAddPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Add'");
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
        $("#bookingFormId :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        $('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/Booking/Get/" + primaryId)
          .done(function (result) {
              var res = JSON.parse(result);

              //}
              $('#hdnAttachId').val(res.HiddenId);
              BindData(res);
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
            $.get("/api/Booking/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('Booking', CURD_MESSAGE_STATUS.DS);
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
$("#btnNextScreenSave").click(function () {
    window.location.href = "/bems/userarea";
});
function EmptyFields() {
    $('#txtUserLocationCode').prop('disabled', true);
    $('#spnPopup-Location').hide();
    $('#ToLocation_1').val('null');
    $('#LocationInchargeId').val('');
    $('#CurrentLoginId').val('');
    $('#AssetFacilityId').val('')
    $('#txtMaintenanceWorkNo').prop('disabled', true);
    $('#WonDiv').hide();
    $('input[type="text"], textarea').val('');
    $('#txtAssetNo,#BookingStartFromDate,#txtCompanyStaffName,#RequestTypeLovId,#BookingEndDate').attr('disabled', false);
    $('#AssetNoDiv,#companypopup,#spnPopup-compStaff').show();
    ClearDropDownFields(6);
    $('#BookingStartFromDate').val('');
    $('#BookingEndDate').val('');
    $('#Timestamp').val('');
    $('#hdnAssetId').val('');
    $('#txtAssetNo').val('');
    $('#hdnWorkOrderId').val('');
    $('#txtMaintenanceWorkNo').val('');
    $('#MovementCategory').val("null");
    $('#primaryID').val('');
    $('#hdnCompanyStaffId').val('');
    $('#txtCompanyStaffName').val('');
    $('#txtDesignation').val('');
    $('#RequestTypeLovId').val('null');
    $('#BookingStatus').val('null');
    $('#hdnBookingStatus').val('');
    $('.status').html("");
    $('#btnNextScreenSave').hide();    // ;
    $('#btnEditPortering').hide();
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnVerify').hide();
    $('#btnReject').hide();
    $('#btnApprove').hide();
    $('#btnDelete').hide();

    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    var hasAddPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Add'");

    if (hasAddPermission) {
        $('#btnSaveandAddNew').show();
        $('#btnSave').show();
        $('#btnCancel').show();
    }
    else {
        $('#btnSave').hide();
        $('#btnSaveandAddNew').hide();
        $('#btnCancel').hide();
    }
    $("#grid").trigger('reloadGrid');
    $("#bookingFormId :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
}

window.GetLocationList = function (locationNo) {
    ClearDropDownFields(locationNo);
    if (locationNo != 5 && locationNo != "5" && $('#ToLocation_' + locationNo).val() != "null") {

        var locationObj = {
            ToFacilityId: $('#ToLocation_1').val(),
            ToBlockId: $('#ToLocation_2').val(),
            ToLevelId: $('#ToLocation_3').val(),
            ToUserAreaId: $('#ToLocation_4').val(),
            locationNo: locationNo
        }
        var ind = parseInt(locationNo) + 1;
        var jqxhr = $.post("/api/Portering/GetLocationList", locationObj, function (response) {
            var result = JSON.parse(response);
            $.each(result.CascadeLocationLovs, function (index, value) {
                $('#ToLocation_' + ind).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
        },
     "json")
      .fail(function (response) {
          $('#myPleaseWait').modal('hide');
      });
    }
}

window.ClearDropDownFields = function (locationNo) {
    if (locationNo == "1" || locationNo == 1) {
        //  $("#ToLocation_2,#ToLocation_3,#ToLocation_4,#ToLocation_5").find("option:not(:first)").remove();
    }
    else if (locationNo == "6" || locationNo == 6) {
        //$("#ToLocation_2,#ToLocation_3,#ToLocation_4,#ToLocation_5").find("option:not(:first)").remove();
        $("#ToLocation_1").val('null');
    }

}

window.BindData = function (res) {
    $('#spnPopup-Location').hide();
    $('#btnEditPortering').hide();
    $('#txtAssetNo,#txtMaintenanceWorkNo').attr('disabled', true);
    $('#AssetNoDiv,#WonDiv').hide();
    $('#Timestamp').val(res.Timestamp);
    $('#hdnAssetId').val(res.AssetId);
    $('#txtAssetNo').val(res.AssetNo);
    $('#hdnWorkOrderId').val(res.hdnWorkOrderId);
    $('#txtMaintenanceWorkNo').val(res.WorkOrderNo);
    $('#BookingStartFromDate').val(DateFormatter(res.BookingStartFrom));
    $('#BookingEndDate').val(DateFormatter(res.BookingEnd));
    $('#MovementCategory').val(res.MovementCategory);
    $('#primaryID').val(res.LoanerTestEquipmentBookingId);
    $('#ToLocation_1').val(res.ToFacilityId);
    $('#IsPorteringDone').val(res.IsPorteringDone);
    $('#ToLocation_2').val(res.ToBlockId);
    $('#ToLocation_3').val(res.ToLevelId);
    $('#ToLocation_4').val(res.ToUserAreaId);
    $('#ToLocation_5').val(res.ToUserLocationId);
    $('#txtUserLocationCode').val(res.UserLocationCode);
    $('#txtUserLocationName').val(res.UserLocationName);
    $('#txtUserAreaCode').val(res.UserAreaCode);
    $('#txtUserAreaName').val(res.UserAreaName);
    $('#txtUserLevelCode').val(res.LevelCode);
    $('#txtUserLevelName').val(res.LevelName);
    $('#txtBlockCode').val(res.BlockCode);
    $('#txtBlockName').val(res.BlockName);
    $('#LocationInchargeId').val(res.LocationInchargeId);
    $('#CurrentLoginId').val(res.CurrentLoginId);

    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasAddPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Add'");
    var hasVerifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Verify'");
    var hasApprovePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");
    var bookingStatus = res.BookingStatus;

    if (hasAddPermission) {
        $('#btnEditPortering').hide();
        if (bookingStatus == 246 || bookingStatus == "246" || bookingStatus == "247" || bookingStatus == 247 || bookingStatus == 309 || bookingStatus == "309" || bookingStatus == "248" || bookingStatus == 248) {
            $('#btnSave').hide();
            $('#btnEdit').hide();
            $('#btnSaveandAddNew').hide()
            $('#btnVerify').hide();
            $('#btnReject').hide();
            $('#btnApprove').hide();
            $('#btnEdit').hide();

        }
        $('#btnCancel').show();
    }

    else if (hasVerifyPermission || hasApprovePermission) {
        $('#btnSave').hide();
        $('#btnEdit').hide();
        $('#btnSaveandAddNew').hide();
        $('#btnCancel').hide();
        $('#btnEditPortering').hide();
        if (bookingStatus == 246 || bookingStatus == "246") {

            if (hasVerifyPermission) {
                $('#btnVerify').show();
                $('#btnReject').show();
            }
            else {
                $('#btnVerify').hide();
                $('#btnReject').hide();
            }

            $('#btnApprove').hide();
        }

        else if (bookingStatus == 309 || bookingStatus == "309") {


            $('#btnVerify').hide();

            if (hasApprovePermission) {
                $('#btnReject').show();
                $('#btnApprove').show();
            }
            else {
                $('#btnReject').hide();
                $('#btnApprove').hide();
            }
        }
        else if (bookingStatus == "247" || bookingStatus == 247) {

            
            //if (!res.IsPorteringDone) {
            //    $('#btnEditPortering').show();
            //}
        }

        else {
            $('#btnVerify').hide();
            $('#btnReject').hide();
            $('#btnApprove').hide();
        }
    }

    if ((bookingStatus == "247" || bookingStatus == 247)) {
        $('#btnSave').hide();
        $('#btnEdit').hide();
        $('#btnSaveandAddNew').hide()
        $('#btnVerify').hide();
        $('#btnReject').hide();
        $('#btnApprove').hide();
        //$('#btnCancel').hide();
    }

    if ((bookingStatus == "247" || bookingStatus == 247) && !res.IsPorteringDone) {

        var LocationInchargeId = $('#LocationInchargeId').val();
        var CurrentLoginId = $('#CurrentLoginId').val();
        if ( hasApprovePermission) {
            $('#btnEditPortering').show();
        }
        else if (LocationInchargeId == CurrentLoginId)
        {
            $('#btnEditPortering').show();
        }
        else {
            $('#btnEditPortering').hide();
        }

    }
    //*************************** Attachment button hide **************************

    if ((bookingStatus == "247" || bookingStatus == 247 || bookingStatus == "248" || bookingStatus == 248 || bookingStatus == "309" || bookingStatus == 309)) {
        $('#AttachRowPlus').hide();
        $('#btnEditAttachment').hide();
    }
    else {
        $('#AttachRowPlus').show();
        $('#btnEditAttachment').show();
    }

  

    $('#hdnCompanyStaffId').val(res.RequestorId);
    $('#txtCompanyStaffName').val(res.RequestorName);
    $('#txtDesignation').val(res.Position);
    $('#RequestTypeLovId').val(res.RequestType);
    $('#BookingStatus').val(res.BookingStatus);
    $('#hdnBookingStatus').val(res.BookingStatus);
    $('#ToLocation_1').attr('disabled', true);
    $('#BookingStartFromDate').attr('disabled', true);

    if (hasAddPermission) {
        if (res.BookingStatus == 246 || res.BookingStatus == "246") {
            $("#bookingFormId :input:not(:button)").prop("disabled", true);
            $('#spnPopup-compStaff').hide();
            //$('#btnCancel').show();

        }
    }
    else if (hasVerifyPermission || hasApprovePermission) {

        $("#bookingFormId :input:not(:button)").prop("disabled", true);
        $('#spnPopup-compStaff').hide();
        $('#btnDelete').hide();
        // $('#btnCancel').hide();
        $('#btnDelete').hide();
        $('#btnEdit').hide();
    }
    //else if (hasApprovePermission) {
    //    $("#bookingFormId :input:not(:button)").prop("disabled", true);
    //    $('#spnPopup-compStaff').hide();

    //}

    // status 
    if (hasAddPermission && !hasVerifyPermission && !hasApprovePermission) {
        $('#btnCancel').show();
    }
    else {
        $('#btnCancel').hide();
    }

    if (res.BookingStatus == 246 || res.BookingStatus == "246") {
        $('.status').html("Draft");

    }
    else if (res.BookingStatus == 309 || res.BookingStatus == "309") {
        $('.status').html("Submitted");

    }
    else if (res.BookingStatus == 247 || res.BookingStatus == "247") {
        $('.status').html("Approved");

    }
    else if (res.BookingStatus == 248 || res.BookingStatus == "248") {
        $('.status').html("Rejected");
    }

    if (res.BookingStatus == 248 || res.BookingStatus == "248" || res.BookingStatus == 247 || res.BookingStatus == "247" || res.BookingStatus == 309 || res.BookingStatus == "309") {
        $("#bookingFormId :input:not(:button)").prop("disabled", true);
        $('#spnPopup-compStaff').hide();

        $('#btnDelete').hide();
    }
    // EXTENTION LOGIC 
    if (hasAddPermission && res.IsExtension && (res.BookingStatus == 247 || res.BookingStatus == "247")) {
        $('#BookingEndDate').attr('disabled', false);
        //$('#BookingEndDate').val('');
        $('#btnEdit').show();
    }

    if (res.BookingStatus == 247) {
        $('#BookingEndDate').attr('disabled', false);
    } else {
        $('#BookingEndDate').attr('disabled', true);
    }
}