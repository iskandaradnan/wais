

var TypeOfPlanner = parseInt(document.getElementById("hdnCleanLinenRequestId").value);
$(document).ready(function () {
    $('#txtContactPerson').attr('disabled', true);
    $('#EndDate_').attr('disabled', false);
    $('#myPleaseWait').modal('show');
    $('.btnDelete').hide();
    $('.btnsecondSave').hide();
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $.get("/api/CleanLinenIssue/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $.each(loadResult.DeliverySchedule, function (index, value) {
                $('#txtDeliverySchudule').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.IssuedOnTime, function (index, value) {
                $('#txtIssuedonTime').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.Priority, function (index, value) {
                $('#txtPriority').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.QCTimeliness, function (index, value) {
                $('#txtQCTimeliness').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.ShortfallQC, function (index, value) {
                $('#txtShortfallQC').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.CLIOption, function (index, value) {
                $('#txtCLIOption').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            
            //variation rate grid
            if (loadResult.cleanLinenLaundryValues != null) {
                BindVariationDetailGrid(loadResult.cleanLinenLaundryValues);
                window.VariationListGloabal = loadResult.cleanLinenLaundryValues;
            }
            if (loadResult.LLinenIssueItemGridList != null) {
                BindLinenGridData(loadResult.LLinenIssueItemGridList);
                window.VariationListGloabals = loadResult.LLinenIssueItemGridList;
            }
            
            AddFirstGridRow();
            
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });
});


//----------------Fetch

var DocumentNoFetchObj = {
    SearchColumn: 'txtUserAreaCode-DocumentNo',//Id of Fetch field 
    ResultColumns: ["CleanLinenRequestId-Primary Key", 'DocumentNo-DocumentNo', 'UserAreaName-User AreName', 'UserLocationCode-UserLocation Code', 'UserLocationName-User LocationName', 'RequestedBy-Requested By', 'Designation-Designation', 'Priority-Priority', 'LLSUserAreaId-LLSUserAreaId', 'LLSUserAreaLocationId-LLSUserAreaLocationId', 'TotalBagRequested-TotalBagRequested','TotalItemRequested-TotalItemRequested'],
    FieldsToBeFilled: ["hdnCleanLinenRequestId-CleanLinenRequestId", "txtUserAreaCode-DocumentNo", "txtUserCode-UserAreaCode", "txtUserAreaName-UserAreaName", "txtLocationcode-UserLocationCode", "txtLocationName-UserLocationName", "txtRequestedBy-RequestedBy", "txtDesignation-Designation", "txtPriority-Priority", "hdnUserAreaId-LLSUserAreaId", "hdnLevelId-LLSUserAreaLocationId", "txtTotalLinenBagsRequested-TotalBagRequested","txtTotalLinenItemsRequested-TotalItemRequested"]
 
};

$('#txtUserAreaCode').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divUserAreaFetch', DocumentNoFetchObj, "/api/Fetch/CleanLinenIssueTxn_FetchCLRDocNo", "UlFetch1", event, 1);//1 -- pageIndex
});

var FirstReceivedByFetchObj = {
    SearchColumn: 'txtBlockCode-StaffName',//Id of Fetch field
    ResultColumns: ["UserRegistrationId-Primary Key", 'StaffName-Block Code', 'BlockName-Block Name', 'Designation-Designation'],//Columns to be displayed
    FieldsToBeFilled: ["hdnBlockId-UserRegistrationId", "txtBlockCode-StaffName", "txtBlockName-BlockName", "txtDesignations-Designation"]//id of element - the model property
};
$('#txtBlockCode').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divFetch1', FirstReceivedByFetchObj, "/api/Fetch/CleanLinenIssueTxn_Fetch1stReceivedBy", "UlFetch2", event, 1);//1 -- pageIndex
});

var SecondReceivedByFetchObj = {
    SearchColumn: 'txtContactPerson-StaffName',//Id of Fetch field
    ResultColumns: ["UserRegistrationId-Primary Key", 'StaffName-StaffName', 'Designation-Designation'],
    FieldsToBeFilled: ["txtStaffMasterId-UserRegistrationId", "txtContactPerson-StaffName", "txtDesignation0-Designation"]
};

$('#txtContactPerson').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divFetchContactPerson', SecondReceivedByFetchObj, "/api/Fetch/CleanLinenIssueTxn_Fetch2ndReceivedBy", "UlFetch3", event, 1);//1 -- pageIndex
});

var VerifierFetchObj = {
    SearchColumn: 'txtTypeCode-StaffName',
    ResultColumns: ["UserRegistrationId-Primary Key", 'StaffName-StaffName', 'Designation-Designation'],
    FieldsToBeFilled: ["hdnTypeCodeId-UserRegistrationId", "txtTypeCode-StaffName", "txtDesignation1-Designation"]
};

$('#txtTypeCode').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divTypeCodeFetch', VerifierFetchObj, "/api/Fetch/CleanLinenIssueTxn_FetchVerifier", "UlFetch4", event, 1);
});

var EngineerFetchObj = {
    SearchColumn: 'txtEngineer-StaffName',//Id of Fetch field
    ResultColumns: ["UserRegistrationId-Primary Key", 'StaffName-StaffName', 'Designation-Designation'],
    FieldsToBeFilled: ["hdnEngineerId-UserRegistrationId", "txtEngineer-StaffName", "txtDesignation2-Designation"]
};

$('#txtEngineer').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divEngineerFetch', EngineerFetchObj, "/api/Fetch/CleanLinenIssueTxn_FetchDeliveredBy", "UlFetch7", event, 1);//1 -- pageIndex
});


//----------------Fetch End----------------------

function myFunction() {
    var lol = $('#hdnCleanLinenRequestId').val();
    var txtCLRDocumentNo = $('#txtUserAreaCode').val();
    console.log(txtCLRDocumentNo);
    if (lol == '') return false;
    if (txtCLRDocumentNo.length > 0) {
        console.log(txtCLRDocumentNo);
        LinenitemLinkClicked(lol);
        LinenBagLinkClicked(lol);
        console.log(txtCLRDocumentNo);
    } else {
        console.log(txtCLRDocumentNo);
        LinenitemLinkClicked(lol);
        LinenBagLinkClicked(lol);
        console.log(txtCLRDocumentNo);
    }
}


function changeFunc() {
    var delievery1 = document.getElementById('txt1stdelivrydatetime').value;
    if (delievery1 == "") {
        console.log('#txt1stdelivrydatetime');
        $('#txt1stdelivrydatetime').attr('required', true);
        var isFormValid = formInputValidation("FrmIssue", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text("Please fill DeliveryDate1st..");
            $('#errorMsg').css('visibility', 'visible');
            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }
    }
    var priority1 = document.getElementById('txtPriority').value;
    var RequestDT = document.getElementById('txtRequestDateTime').value;
    var delieveryST = document.getElementById('txtDeliverySchudule').value;
    var Location1 = document.getElementById('hdnLevelId').value;
    var IssuedonTime = {
        Delievery1: delievery1,
        //Delievery2 :delievery2,
        priority1: priority1,
        RequestDT: RequestDT,
        delieveryST: delieveryST,
        Location1: Location1
    }
    LinkGetByScheduledId(IssuedonTime);
}


$(".btnSave,.btnEdit").click(function () {
    $('#btnlogin').attr('disabled', true);
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');

    $('#txtUserAreaCode').attr('required', true);
    $('#txt1stdelivrydatetime').attr('required', true);
    $('#txtBlockCode').attr('required', true);
    $('#txtContactPerson').attr('required', false);
    $('#txtTypeCode').attr('required', true);
    $('#txtEngineer').attr('required', true);
    $('#txtDeliverySchudule').attr('required', true);
    $('#txtQCTimeliness').attr('required', true);
    $('#txtShortfallQC').attr('required', true);
   
    var _index;  // var _indexThird;
    var variationresult = [];
    $('#variationgrid tr').each(function () {
        _index = $(this).index();
    });
    for (var i = 0; i <= _index; i++) {
        var active = true;
        var _tempObj = {

            LovId: $('#LovId_' + i).val(),
            CleanLinenRequestId: $("#CleanLinenRequestId_" + i).val(),
            FieldValue: $('#LovId_' + i).val(),
            RequestedQuantity: $('#RequestedQuantity_' + i).val(),
            IssuedQuantity: $('#IssuedQuantity_' + i).val(),
            Remarks: $('#Remarks_' + i).val(),
            CLILinenBagId: $('#CLILinenBagId_' + i).val(),
            LaundryBag: $('#LaundryBag_' + i).val(),
        };
        if (_tempObj.IssuedQuantity == " " || _tempObj.IssuedQuantity == "") {
            _tempObj.IssuedQuantity = null;
        }     
        var stDt = _tempObj.RequestedQuantity;
        var endDt = _tempObj.IssuedQuantity;
        
        if (endDt != null) {
            if (endDt != "" && endDt > stDt) {
                $("div.errormsgcenter").text("Issued Quantity should be Lesser/Equal To  Requested Quantity");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }
        variationresult.push(_tempObj);
    }
    //first grid 
    var LinenIteem;        // var _indexThird;
    var result = [];
    $('#ContactGrid tr').each(function () {
        LinenIteem = $(this).index();
    });
    for (var i = 0; i <= LinenIteem; i++) {
        var active = true;
        var ssss = {
            LinenitemId: $('#LinenCodeId_' + i).val(),
            RequestedQuantity: $('#StartDate_' + i).val(),
            DeliveryIssuedQty1st: $('#EndDate_' + i).val(),
            //DeliveryIssuedQty2nd: $('#txt2ndDeliveryIssuedQty_' + i).val(),
            Remarks: $('#txtLinenRemarks_' + i).val(),
            CLILinenItemId: $('#CLILinenItemId_' + i).val(),
        };
        if (ssss.DeliveryIssuedQty1st == " " || ssss.DeliveryIssuedQty1st == "") {
            ssss.DeliveryIssuedQty1st = null;
        }
        var stDt = parseInt(ssss.RequestedQuantity);
        var endDt = parseInt(ssss.DeliveryIssuedQty1st);
        if (endDt != null) {
            if (endDt != "" && endDt > stDt)
            {
                $('#EndDate_' + i).val('');
                $('#PPMHours_' + i).val('');
                var isFormValid = formInputValidation("FrmIssue", 'save');
                if (!isFormValid) {
                    $("div.errormsgcenter").text("1st Delivery Issued Qty should be Lesser / Equal To  Requested Quantity");
                    $('#errorMsg').css('visibility', 'visible');
                    $('#btnlogin').attr('disabled', false);
                    $('#myPleaseWait').modal('hide');
                    return false;
                }
               
            }
        }
        result.push(ssss);
    }

    var CurrentbtnID = $(this).attr("value");
    var timeStamp = $("#Timestamp").val();
    var isFormValid = formInputValidation("FrmIssue", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }
    var MstCleanLinenIssue = {
        LLSUserAreaId: $('#hdnUserAreaId').val(),
        LLSUserAreaLocationId: $('#hdnLevelId').val(),
        CLINo: $('#txtCLRDocumentNo').val(),
        CleanLinenRequestId: $('#hdnCleanLinenRequestId').val(),
        DocumentNo: $('#txtUserAreaCode').val(),
        RequestDateTime: $('#txtRequestDateTime').val(),
        DeliveryDate1st: $('#txt1stdelivrydatetime').val(),
        DeliveryDate2nd: $('#txt2nddelivrydatetime').val(),
        UserAreaCode: $('#txtUserAreaCode').val(),
        UserAreaName: $('#txtUserAreaName').val(),
        LocationCode: $('#txtLocationCode').val(),
        LocationName: $('#txtLocationName').val(),
        RequestedBy: $('#txtRequestedBy').val(),
        Designation: $('#txtDesignation').val(),
        ReceivedBy1st: $('#hdnBlockId').val(),
        ReceivedBy2nd: $('#txtStaffMasterId').val(),
        Verifier: $('#hdnTypeCodeId').val(),
        DeliveredBy: $('#hdnEngineerId').val(),
        DeliveryWeight1st: $('#txt1stDeliveryWeight').val(),
        DeliveryWeight2nd: $('#txt2ndDeliveryWeight').val(),
        IssuedonTime: $('#txtIssuedonTime').val(),
        DeliverySchedule: $('#txtDeliverySchudule').val(),
        QCTimeliness: $('#txtQCTimeliness').val(),
        ShortfallQC: $('#txtShortfallQC').val(),
        CLIOption: $('#txtCLIOption').val(),
        Remarks: $('#txtRemarks').val(),
        TotalLinenItemsRequested: $('#txtTotalLinenItemsRequested').val(),
        TotalBagIssued: $('#txtTotalLinenBagsIssued').val(),
        TotalItemShortfall: $('#txtTotalLinenItemsShortfall').val(),
        TotalItemIssued: $('#txtTotalLinenItemsIssued').val(),
        GuId: $('#hdnAttachId').val(),
        cleanLinenLaundryValues: variationresult,
        LLinenIssueItemGridList: result

    };
    var primaryId = $("#primaryID").val();
    if (primaryId != null) {

        MstCleanLinenIssue.CleanLinenIssueId = primaryId;
        MstCleanLinenIssue.Timestamp = timeStamp;
    }
    else {

        MstCleanLinenIssue.CleanLinenIssueId = 0;
        MstCleanLinenIssue.Timestamp = "";
    }

    var jqxhr = $.post("/api/CleanLinenIssue/Save", MstCleanLinenIssue, function (response) {
        var result = JSON.parse(response);
        $("#primaryID").val(result.CleanLinenIssueId);
        $("#Timestamp").val(result.Timestamp);
       // $('#txtCLRDocumentNo').val(result.DocumentNo);
        $('#SelStatus option[value="' + result.Active + '"]').prop('selected', true);
        $('#hdnStatus').val(result.Active);
        if (result.cleanLinenLaundryValues != null) {
            BindVariationDetailGrid(result.cleanLinenLaundryValues);
        }
        if (result != null && result.LLinenIssueItemGridList != null && result.LLinenIssueItemGridList.length > 0) {
            BindSecondGridData(result);
        }
        $("#grid").trigger('reloadGrid');
        if (result.CleanLinenIssueId != 0) {
            $('#hdnAttachId').val(result.HiddenId);
            $('#txtCLRDocumentNo').val(result.CLINo);
            if (result.cleanLinenLaundryValues != null) {
                BindVariationDetailGrids(result.cleanLinenLaundryValues);
            }
            $('#txtTotalLinenBagsRequested').val(result.TotalBagRequested).attr('disabled', true);
            $('#txtTotalLinenItemsRequested').val(result.TotalItemRequested).attr('disabled', true);
            $('#btnNextScreenSave').show();
            $('#btnEdit').show();
            $('#btnSave').hide();
            $('.btnDelete').hide();
        }
        $(".content").scrollTop(0);
        showMessage('CleanLinenIssue', CURD_MESSAGE_STATUS.SS);
        $("#top-notifications").modal('show');
        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);
        $('#btnSave').attr('disabled', false);
        if (CurrentbtnID == "1") {
            EmptyFields();
        }
        $('#myPleaseWait').modal('hide');
        
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
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');
            $('.btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
});
/////Vadilation purpose for second time save  for Second Recieved By/////////////
//$(".btnsecondSave,.btnEdit").click(function () {
//    $('#btnlogin').attr('disabled', true);
//    $('#myPleaseWait').modal('show');
//    $("div.errormsgcenter").text("");
//    $('#errorMsg').css('visibility', 'hidden');

//    $('#txtUserAreaCode').attr('required', true);
//    $('#txt1stdelivrydatetime').attr('required', true);
//    $('#txtBlockCode').attr('required', true);
//    $('#txtContactPerson').attr('required', false);
//    $('#txtTypeCode').attr('required', true);
//    $('#txtEngineer').attr('required', true);
//    $('#txtDeliverySchudule').attr('required', true);
//    $('#txtQCTimeliness').attr('required', true);
//    $('#txtShortfallQC').attr('required', true);
//    $('#txtContactPerson').attr('required', true);
//    $('#txtStaffMasterId').attr('required', true);

//    var _index;  // var _indexThird;
//    var variationresult = [];
//    $('#variationgrid tr').each(function () {
//        _index = $(this).index();
//    });
//    for (var i = 0; i <= _index; i++) {
//        var active = true;
//        var _tempObj = {

//            LovId: $('#LovId_' + i).val(),
//            CleanLinenRequestId: $("#CleanLinenRequestId_" + i).val(),
//            FieldValue: $('#LovId_' + i).val(),
//            RequestedQuantity: $('#RequestedQuantity_' + i).val(),
//            IssuedQuantity: $('#IssuedQuantity_' + i).val(),
//            Remarks: $('#Remarks_' + i).val(),
//            CLILinenBagId: $('#CLILinenBagId_' + i).val(),
//            LaundryBag: $('#LaundryBag_' + i).val(),
//        };
//        if (_tempObj.IssuedQuantity == " " || _tempObj.IssuedQuantity == "") {
//            _tempObj.IssuedQuantity = null;
//        }
//        var stDt = _tempObj.RequestedQuantity;
//        var endDt = _tempObj.IssuedQuantity;

//        if (endDt != null) {
//            if (endDt != "" && endDt > stDt) {
//                $("div.errormsgcenter").text("Issued Quantity should be Lesser/Equal To  Requested Quantity");
//                $('#errorMsg').css('visibility', 'visible');
//                $('#myPleaseWait').modal('hide');
//                return false;
//            }
//        }
//        variationresult.push(_tempObj);
//    }
//    //first grid 
//    var LinenIteem;        // var _indexThird;
//    var result = [];
//    $('#ContactGrid tr').each(function () {
//        LinenIteem = $(this).index();
//    });
//    for (var i = 0; i <= LinenIteem; i++) {
//        var active = true;
//        var ssss = {
//            LinenitemId: $('#LinenCodeId_' + i).val(),
//            RequestedQuantity: $('#StartDate_' + i).val(),
//            DeliveryIssuedQty1st: $('#EndDate_' + i).val(),
//            //DeliveryIssuedQty2nd: $('#txt2ndDeliveryIssuedQty_' + i).val(),
//            Remarks: $('#txtLinenRemarks_' + i).val(),
//            CLILinenItemId: $('#CLILinenItemId_' + i).val(),
//        };
//        if (ssss.DeliveryIssuedQty1st == " " || ssss.DeliveryIssuedQty1st == "") {
//            ssss.DeliveryIssuedQty1st = null;
//        }
//        var stDt = parseInt(ssss.RequestedQuantity);
//        var endDt = parseInt(ssss.DeliveryIssuedQty1st);
//        console.log(stDt);
//        console.log(endDt);
//        if (endDt != null) {
//            if (endDt > stDt) {
//                $("div.errormsgcenter").text("1st Delivery Issued Qty should be Lesser/Equal To  Requested Quantity");
//                $('#errorMsg').css('visibility', 'visible');
//                $('#myPleaseWait').modal('hide');
//                return false;
//            }
//        }
//        result.push(ssss);
//    }

//    var CurrentbtnID = $(this).attr("value");
//    var timeStamp = $("#Timestamp").val();
//    var isFormValid = formInputValidation("FrmIssue", 'save');
//    if (!isFormValid) {
//        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
//        $('#errorMsg').css('visibility', 'visible');
//        $('#btnlogin').attr('disabled', false);
//        $('#myPleaseWait').modal('hide');
//        return false;
//    }
//    var MstCleanLinenIssue = {
//        LLSUserAreaId: $('#hdnUserAreaId').val(),
//        LLSUserAreaLocationId: $('#hdnLevelId').val(),
//        CLINo: $('#txtCLRDocumentNo').val(),
//        CleanLinenRequestId: $('#hdnCleanLinenRequestId').val(),
//        DocumentNo: $('#txtUserAreaCode').val(),
//        RequestDateTime: $('#txtRequestDateTime').val(),
//        DeliveryDate1st: $('#txt1stdelivrydatetime').val(),
//        DeliveryDate2nd: $('#txt2nddelivrydatetime').val(),
//        UserAreaCode: $('#txtUserAreaCode').val(),
//        UserAreaName: $('#txtUserAreaName').val(),
//        LocationCode: $('#txtLocationCode').val(),
//        LocationName: $('#txtLocationName').val(),
//        RequestedBy: $('#txtRequestedBy').val(),
//        Designation: $('#txtDesignation').val(),
//        ReceivedBy1st: $('#hdnBlockId').val(),
//        ReceivedBy2nd: $('#txtStaffMasterId').val(),
//        Verifier: $('#hdnTypeCodeId').val(),
//        DeliveredBy: $('#hdnEngineerId').val(),
//        DeliveryWeight1st: $('#txt1stDeliveryWeight').val(),
//        DeliveryWeight2nd: $('#txt2ndDeliveryWeight').val(),
//        IssuedonTime: $('#txtIssuedonTime').val(),
//        DeliverySchedule: $('#txtDeliverySchudule').val(),
//        QCTimeliness: $('#txtQCTimeliness').val(),
//        ShortfallQC: $('#txtShortfallQC').val(),
//        CLIOption: $('#txtCLIOption').val(),
//        Remarks: $('#txtRemarks').val(),
//        TotalLinenItemsRequested: $('#txtTotalLinenItemsRequested').val(),
//        TotalBagIssued: $('#txtTotalLinenBagsIssued').val(),
//        TotalItemShortfall: $('#txtTotalLinenItemsShortfall').val(),
//        TotalItemIssued: $('#txtTotalLinenItemsIssued').val(),
//        GuId: $('#hdnAttachId').val(),
//        cleanLinenLaundryValues: variationresult,
//        LLinenIssueItemGridList: result

//    };
//    var primaryId = $("#primaryID").val();
//    if (primaryId != null) {

//        MstCleanLinenIssue.CleanLinenIssueId = primaryId;
//        MstCleanLinenIssue.Timestamp = timeStamp;
//    }
//    else {

//        MstCleanLinenIssue.CleanLinenIssueId = 0;
//        MstCleanLinenIssue.Timestamp = "";
//    }

//    var jqxhr = $.post("/api/CleanLinenIssue/Save", MstCleanLinenIssue, function (response) {
//        var result = JSON.parse(response);
//        $("#primaryID").val(result.CleanLinenIssueId);
//        $("#Timestamp").val(result.Timestamp);
//        $('#SelStatus option[value="' + result.Active + '"]').prop('selected', true);
//        $('#hdnStatus').val(result.Active);
//        if (result.cleanLinenLaundryValues != null) {
//            BindVariationDetailGrid(result.cleanLinenLaundryValues);
//        }
//        if (result != null && result.LLinenIssueItemGridList != null && result.LLinenIssueItemGridList.length > 0) {
//            BindSecondGridData(result);
//        }
//        $("#grid").trigger('reloadGrid');
//        if (result.CleanLinenIssueId != 0) {
//            $('#hdnAttachId').val(result.HiddenId);
//            $('#txtCLRDocumentNo').val(result.DocumentNo);
//            if (result.cleanLinenLaundryValues != null) {
//                BindVariationDetailGrids(result.cleanLinenLaundryValues);
//            }
//            $('#txtTotalLinenBagsRequested').val(result.TotalBagRequested).attr('disabled', true);
//            $('#txtTotalLinenItemsRequested').val(result.TotalItemRequested).attr('disabled', true);
//            $('#btnNextScreenSave').show();
//            $('#btnEdit').show();
//            $('#btnSave').hide();
//            $('.btnDelete').hide();
//        }
//        $(".content").scrollTop(0);
//        showMessage('CleanLinenIssue', CURD_MESSAGE_STATUS.SS);
//        $("#top-notifications").modal('show');
//        setTimeout(function () {
//            $("#top-notifications").modal('hide');
//        }, 5000);
//        $('#btnSave').attr('disabled', false);
//        if (CurrentbtnID == "1") {
//            EmptyFields();
//        }
//        $('#myPleaseWait').modal('hide');

//    },
//        "json")
//        .fail(function (response) {
//            var errorMessage = "";
//            if (response.status == 400) {
//                errorMessage = response.responseJSON;
//            }
//            else {
//                errorMessage = Messages.COMMON_FAILURE_MESSAGE;
//            }
//            $("div.errormsgcenter").text(errorMessage);
//            $('#errorMsg').css('visibility', 'visible');
//            $('.btnSave').attr('disabled', false);
//            $('#myPleaseWait').modal('hide');
//        });
//});
/////Vadilation purpose for second time save  for Second Recieved By ??????end ??????/////////////
$(".btnCancel").click(function () {
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

function FetchLinenCode(event, index) {
    $('#divLinenCodeFetch_' + index).css({
        'top': $('#txtLinenCode_' + index).offset().top - $('#dataTableCompletion').offset().top + $('#txtLinenCode_' + index).innerHeight(),
    });
    var LinenFetchObj = {
        SearchColumn: 'txtLinenCode_' + index + '-LinenCode',//Id of Fetch field
        ResultColumns: ["LinenItemId-Primary Key", 'LinenCode' + '-txtLinenCode_' + index],
        //AdditionalConditions: ["LinenItemId-" + index +"LinenCodeId_"],
        FieldsToBeFilled: ["LinenCodeId_" + index + "-LinenItemId", 'txtLinenCode_' + index + '-LinenCode', 'txtLinenDescription_' + index + '-LinenDescription']
    };
    DisplayFetchResult('divLinenCodeFetch_' + index, LinenFetchObj, "/api/Fetch/CleanLinenDespatchTxnDet_FetchLinenCode", "UlFetch", event, 1);
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
// **** Query String to get ID  End****\\\
/********************************************* Multi Select End ***********************************************************/
window.BindVariationDetailGrid = function (list) {
    $("#variationgrid").empty();
    if (list.length > 0) {
        var html = '';
        $(list).each(function (index, data) {

            html += '<tr>';
            html += '<td width="20%" style="text-align:center;" rowspan="1">';
            html += '<input type="hidden" readonly id="LovId_' + index + '" value="' + data.LovId + '" /> ';
            html += '<input disabled type="text" value="' + data.FieldValue + '" style="text-align:left;" class="form-control"/> ';
            html += '<input type="hidden" id="LovId_' + index + '" value="' + data.LovId + '" />';
            html += '  </td>';
            html += '<td width="20%" style="text-align:center;" rowspan="1"> <div>';
            html += '<input type="text" id="RequestedQuantity_' + index + '"   style="text-align:right;" class="form-control " disabled>';
            html += '</div> </td>';
            html += '<td width="20%" style="text-align:center;" rowspan="1"> <div>';
            html += '<input type="text" id="IssuedQuantity_' + index + '"  onkeyup="Due(' + index + ')" onblur="update(' + index + ')" style="text-align:right;" class="form-control" required >';
            html += '</div> </td>';
            html += '<td width="20%" style="text-align:center;" rowspan="1"> <div>';
            html += '<input type="text" id="shortfall_' + index + '"  style="text-align:right;" onkeyup="updateDueShortfall(' + index + ')" class="form-control " disabled>';
            html += '</div> </td>';
            html += ' <td width="20%" style="text-align:center;" rowspan="1"><div>';
            html += '<input type="text" id="Remarks_' + index + '"  class="form-control " maxlength="11"/> ';
            html += '</td>';
            html += ' </tr>';

        });
        $('#variationgrid').append(html);
        formInputValidation("FrmReq");

    }
}

var lov
function Due(lov) {
    var total = parseInt(document.getElementById("RequestedQuantity_" + lov).value);
    var val2 = parseInt(document.getElementById("IssuedQuantity_" + lov).value);
    dues = total - val2;
    $("#shortfall_" + lov).val(dues);
}

window.BindVariationDetailGrids = function (list) {
    $("#variationgrid").empty();
    if (list.length > 0) {
        var html = '';
        $(list).each(function (index, data) {

            html += '<tr>';
            html += '<td width="20%" style="text-align:center;" rowspan="1">';
            html += '<input type="hidden" readonly  id="CLILinenBagId_' + index + '" value="' + data.CLILinenBagId + '" /> ';
            html += '<input type="hidden" readonly  id="LaundryBag_' + index + '" value="' + data.LaundryBag + '" /> ';
            html += '<input type="hidden" readonly id="LovId_' + index + '" value="' + data.LovId + '" /> ';
            html += '<input type="hidden" readonly id="FieldValue_' + index + '" value="' + data.FieldValue + '" /> ';
            html += '<input disabled type="text" value="' + data.FieldValue + '" style="text-align:left;" class="form-control"/> ';
            html += '<input type="hidden" id="LovId_' + index + '" value="' + data.LovId + '" />';
            html += '  </td>';
            html += '<td width="20%" style="text-align:center;" rowspan="1"> <div>';
            html += '<input type="text" id="RequestedQuantity_' + index + '" value="' + data.RequestedQuantity + '" style="text-align:right;" class="form-control " disabled>';
            html += '</div> </td>';
            html += '<td width="20%" style="text-align:center;" rowspan="1"> <div>';
            html += '<input type="text" id="IssuedQuantity_' + index + '" value="' + data.IssuedQuantity + '" onkeyup="updateDue(' + index + ')" onblur="update(' + index + ')" pattern="^[0-9]+(\.[0-9]{1,2})?$" style="text-align:right;" class="form-control " >';
            html += '</div> </td>';
            html += '<td width="20%" style="text-align:center;" rowspan="1"> <div>';
            html += '<input type="text" id="shortfall_' + index + '"  value="' + data.Shortfall + '" onkeyup="updateDueShortfall(' + index + ')" style="text-align:right;" class="form-control " disabled>';
            html += '</div> </td>';
            html += ' <td width="20%" style="text-align:center;" rowspan="1"><div>';
            html += '<input type="text" id="Remarks_' + index + '" value="' + data.Remarks + '" class="form-control " maxlength="11"/> ';
            html += '</td>';
            html += ' </tr>';

        });

        $('#variationgrid').append(html);
        formInputValidation("FrmIssue");
    }

}

var lov
function updateDue(lov) {
    var total = parseInt(document.getElementById("RequestedQuantity_" + lov).value);
    var val2 = parseInt(document.getElementById("IssuedQuantity_" + lov).value);
    due = total - val2;
    $("#shortfall_" + lov).val(due);
   
};

function calculateIssued(index) {
    var rowCount = $('#ContactGrid tr:last').index();
    var totalAA = 0;
    var a = 0;
    for (var i = 0; i <= rowCount; i++) {
        a = parseInt(document.getElementById("EndDate_" + i).value);
        totalAA = parseInt(totalAA + a);
    }
    $('#txtTotalLinenItemsIssued').val(totalAA);
    console.log(totalAA);
}

function calculatIssued(index) {
    var rowCount = $('#ContactGrid tr:last').index();
    var totalAA = 0;
    var a = 0;
    var b = 0;
    for (var i = 0; i <= rowCount; i++) {
        a = parseInt(document.getElementById("EndDate_" + i).value);
        b = 0;
        //b = parseInt(document.getElementById("txt2ndDeliveryIssuedQty_" + i).value);
        totalAA = parseInt(totalAA + a + b);
    }
    $('#txtTotalLinenItemsIssued').val(totalAA);
    console.log(totalAA);
}

function calculateLinenItemShortfall(index) {
    var b = $(txtTotalLinenItemsIssued).val();
    var a = parseInt(document.getElementById("PPMHours_" + index).value);
    b = parseInt(b);
    b = isNaN(b) ? 0 : b;
    a = isNaN(a) ? 0 : a;
    total = parseInt(b + a);
    $('#txtTotalLinenItemsIssued').val(total);
    console.log(total);
}

function update() {
    var requested1 = $('#IssuedQuantity_0').val();
    var requested2 = $('#IssuedQuantity_1').val();
    var requested3 = $('#IssuedQuantity_2').val();
    var requested4 = $('#IssuedQuantity_3').val();
    var requested5 = $('#IssuedQuantity_4').val();
    requested1 = isNaN(requested1) ? 0 : requested1;
    requested2 = isNaN(requested2) ? 0 : requested2;
    requested3 = isNaN(requested3) ? 0 : requested3;
    requested4 = isNaN(requested4) ? 0 : requested4;
    requested5 = isNaN(requested5) ? 0 : requested5;
    totalrequested = parseInt(requested1) + parseInt(requested2) + parseInt(requested3) + parseInt(requested4) + parseInt(requested5);
    console.log(totalrequested);
    $('#txtTotalLinenBagsIssued').val(totalrequested);
    console.log(totalrequested);

}


//************************************************ Getbyid bind data *************************

function CalculateRepairHours(index) {
    var RequestedQuantity = parseFloat($('#StartDate_' + index).val());
    var FirstDeliver = parseFloat($('#EndDate_' + index).val());
    //var SecondDeliver = parseFloat($('#txt2ndDeliveryIssuedQty_' + index).val());
    //var DeliveryAddition = FirstDeliver + SecondDeliver;
    var DeliveryAddition = FirstDeliver;
     Total = RequestedQuantity - DeliveryAddition;
    if (RequestedQuantity != "") {
        $('#PPMHours_' + index).val(Total);
    }
    var rowCount = $('#ContactGrid tr:last').index();
    var totalAA = 0;
    var a = 0;
    for (var i = 0; i <= rowCount; i++) {
        a = parseInt(document.getElementById("PPMHours_" + i).value);
        totalAA = parseInt(totalAA + a);
    }
    $('#txtTotalLinenItemsShortfall').val(totalAA);
    console.log(totalAA);
}

function CalculateShortfall(index) {
    var RequestedQuantity = parseFloat($('#StartDate_' + index).val());
    var FirstDeliver = parseFloat($('#EndDate_' + index).val());
    //var SecondDeliver = parseFloat($('#txt2ndDeliveryIssuedQty_' + index).val());
    var DeliveryAddition = RequestedQuantity - FirstDeliver;
    if (RequestedQuantity != "") {
        $('#PPMHours_' + index).val(DeliveryAddition);
    }

}

function CalculateWeight() {
    var RequestedQuantity = parseFloat($('#txt1stDeliveryWeight').val());
    var FirstDeliver = parseFloat($('#txt2ndDeliveryWeight').val());
    var SecondDeliver = parseFloat($('txtTotalWeight').val());
    RequestedQuantity = isNaN(RequestedQuantity) ? 0 : RequestedQuantity;
    FirstDeliver = isNaN(FirstDeliver) ? 0 : FirstDeliver;
    SecondDeliver = isNaN(SecondDeliver) ? 0 : SecondDeliver;
    totalrequested = parseFloat(RequestedQuantity) + parseFloat(FirstDeliver) + parseFloat(SecondDeliver);
    console.log(totalrequested);
    $('#txtTotalWeight').val(totalrequested);
    console.log(totalrequested);
}

$("#txtCLIOption").change(function () {
    if (this.value == 10166) {
        $('#txt2ndDeliveryWeight').prop('disabled', false);

    }
    else {
        $('#txt2ndDeliveryWeight').prop('disabled', true);
    }

});

function DeliveryIssuedQuantity(index) {
    var tableElem = window.document.getElementById("hikeTable");
    var FirstDeliver = window.document.getElementById('#EndDate_' + index).val;

    var Total = RequestedQuantity - DeliveryAddition;

    if (RequestedQuantity != "") {
        $('#PPMHours_' + index).val(Total);
    }

}


function BindSecondGridData(getResult) {
    var ActionType = $('#ActionType').val();
    $("#ContactGrid").empty();
    $.each(getResult.LLinenIssueItemGridList, function (index, value) {
        AddFirstGridRow();
        $("#CLILinenItemId_" + index).val(getResult.LLinenIssueItemGridList[index].CLILinenItemId);
        $("#LinenCodeId_" + index).val(getResult.LLinenIssueItemGridList[index].LinenitemId).attr('disabled', true);
        $("#txtLinenCode_" + index).val(getResult.LLinenIssueItemGridList[index].LinenCode).attr('disabled', true);
        $("#txtLinenDescription_" + index).val(getResult.LLinenIssueItemGridList[index].LinenDescription).attr('disabled', true);
        $("#txtAgreedShelfLevel_" + index).val(getResult.LLinenIssueItemGridList[index].AgreedShelfLevel).attr('disabled', true);
        $("txtBalanceOnShelf_" + index).val(getResult.LLinenIssueItemGridList[index].BalanceOnShelf).attr('disabled', true);
        $("#StartDate_" + index).val(getResult.LLinenIssueItemGridList[index].RequestedQuantity).attr('disabled', true);
        $("#EndDate_" + index).val(getResult.LLinenIssueItemGridList[index].DeliveryIssuedQty1st).attr('disabled', false);
        //$("#txt2ndDeliveryIssuedQty_" + index).val(getResult.LLinenIssueItemGridList[index].DeliveryIssuedQty2nd).attr('disabled', true);
        $("#PPMHours_" + index).val(getResult.LLinenIssueItemGridList[index].Shortfall).attr('disabled', true);
        $("#txtStoreBalance_" + index).val(getResult.LLinenIssueItemGridList[index].StoreBalance).attr('disabled', true);
        $("#txtRemarks_" + index).val(getResult.LLinenIssueItemGridList[index].Remarks);

        linkCliked2 = true;
        $(".content").scrollTop(0);
    });
    //************************************************ Grid Pagination *******************************************

    if ((getResult.LLinenIssueItemGridList && getResult.LLinenIssueItemGridList.length) > 0) {
        GridtotalRecords = getResult.LLinenIssueItemGridList[0].TotalRecords;
        TotalPages = getResult.LLinenIssueItemGridList[0].TotalPages;
        LastRecord = getResult.LLinenIssueItemGridList[0].LastRecord;
        FirstRecord = getResult.LLinenIssueItemGridList[0].FirstRecord;
        pageindex = getResult.LLinenIssueItemGridList[0].PageIndex;
        linkCliked2 = true;
        $(".content").scrollTop(0);
    }
    $('#paginationfooter').show();


    //************************************************ End *******************************************************
}


function BindSecondGridDataGetById(getResult) {
    var ActionType = $('#ActionType').val();
    $("#ContactGrid").empty();
    $.each(getResult.LLinenIssueItemGridList, function (index, value) {
        AddFirstGridRow();
        $("#CLILinenItemId_" + index).val(getResult.LLinenIssueItemGridList[index].CLILinenItemId);
        $("#LinenCodeId_" + index).val(getResult.LLinenIssueItemGridList[index].LinenitemId).attr('disabled', true);
        $("#txtLinenCode_" + index).val(getResult.LLinenIssueItemGridList[index].LinenCode).attr('disabled', true);
        $("#txtLinenDescription_" + index).val(getResult.LLinenIssueItemGridList[index].LinenDescription).attr('disabled', true);
        $("txtBalanceOnShelf_" + index).val(getResult.LLinenIssueItemGridList[index].BalanceOnShelf).attr('disabled', true);
        $("#txtAgreedShelfLevel_" + index).val(getResult.LLinenIssueItemGridList[index].AgreedShelfLevel).attr('disabled', true);
        $("#StartDate_" + index).val(getResult.LLinenIssueItemGridList[index].RequestedQuantity).attr('disabled', true);
        $("#EndDate_" + index).val(getResult.LLinenIssueItemGridList[index].DeliveryIssuedQty1st).attr('disabled', false);
        //$("#txt2ndDeliveryIssuedQty_" + index).val(getResult.LLinenIssueItemGridList[index].DeliveryIssuedQty2nd).attr('disabled', false);
        $("#PPMHours_" + index).val(getResult.LLinenIssueItemGridList[index].Shortfall).attr('disabled', true);
        $("#txtStoreBalance_" + index).val(getResult.LLinenIssueItemGridList[index].StoreBalance).attr('disabled', true);
        $("#txtRemarks_" + index).val(getResult.LLinenIssueItemGridList[index].Remarks);

        linkCliked2 = true;
        $(".content").scrollTop(0);
    });
    //************************************************ Grid Pagination *******************************************

    if ((getResult.LLinenIssueItemGridList && getResult.LLinenIssueItemGridList.length) > 0) {
        GridtotalRecords = getResult.LLinenIssueItemGridList[0].TotalRecords;
        TotalPages = getResult.LLinenIssueItemGridList[0].TotalPages;
        LastRecord = getResult.LLinenIssueItemGridList[0].LastRecord;
        FirstRecord = getResult.LLinenIssueItemGridList[0].FirstRecord;
        pageindex = getResult.LLinenIssueItemGridList[0].PageIndex;
        linkCliked2 = true;
        $(".content").scrollTop(0);
    }
    $('#paginationfooter').show();


    //************************************************ End *******************************************************
}


function emptySecondgrid() {
    $("#EmployeeName_" + index).val('');
    $("#txtLinenDescription_" + index).val('');
    $("#txtAgreedShelfLevel_" + index).val('');
    $("#txtRequestedQuantity_" + index).val('');
    $("#txt1stDeliveryIssuedQty_" + index).val('');
    //$("#txt2ndDeliveryIssuedQty_" + index).val('');
    $("#txtShortfall_" + index).val('');
    $("#txtStoreBalance_" + index).val('');
    $("#txtLinenRemarks_" + index).val('');
    $("#CLILinenItemId_" + index).val('');
}

function LinkClicked(CleanLinenIssueId) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#FrmIssue :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    //$("#primaty").val(CLILinenItemId);
    $('#primaryID').val(CleanLinenIssueId);
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
        $('.btnDelete').hide();
    }

    if (action == 'View') {
        $("#FrmIssue :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);


    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/CleanLinenIssue/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                $('#txtCLRDocumentNo').val(getResult.CLINo).attr('disabled', true);
                $('#txtUserAreaCode').val(getResult.DocumentNo).attr('disabled', true);
                $('#txtRequestDateTime').val(moment(getResult.RequestDateTime).format("DD-MMM-YYYY HH:mm"));
                $('#txt1stdelivrydatetime').val(moment(getResult.DeliveryDate1st).format("DD-MMM-YYYY HH:mm")).attr('disabled', false);
                $('#txt2stdelivrydatetime').val(moment(getResult.DeliveryDate2nd).format("DD-MMM-YYYY HH:mm")).attr('disabled', false);
                $('#txtUserCode').val(getResult.UserAreaCode).attr('disabled', true);
                $('#hdnCleanLinenRequestId').val(getResult.CleanLinenIssueId).attr('disabled', true);
                $('#txtUserAreaName').val(getResult.UserAreaName).attr('disabled', true);
                $('#txtPriority').val(getResult.Priority);
                $('#txtLocationcode').val(getResult.UserLocationCode).attr('disabled', true);
                $('#txtLocationName').val(getResult.UserLocationName).attr('disabled', true);
                $('#txtRequestedBy').val(getResult.RequestedBy).attr('disabled', true);
                $('#txtDesignation').val(getResult.RequestedByDesignation).attr('disabled', true);
                $('#hdnUserAreaId').val(getResult.LLSUserAreaId).attr('disabled', true);
                $('#hdnLevelId').val(getResult.LLSUserAreaLocationId).attr('disabled', true);
                $('#txtBlockCode').val(getResult.ReceivedBy1st).attr('disabled', false);
                $('#hdnBlockId').val(getResult.FirstReceivedBy).attr('disabled', true);
                $('#txtDesignations').val(getResult.ReceivedBy1stDesignation).attr('disabled', true);
                $('#txtContactPerson').val(getResult.ReceivedBy2nd).attr('disabled', false);
                $('#txtStaffMasterId').val(getResult.SecondReceivedBy).attr('disabled', false);
                $('#txtDesignation0').val(getResult.ReceivedBy2ndDesignation).attr('disabled', true);
                $('#txtTypeCode').val(getResult.Verifier).attr('disabled', true);
                $('#hdnTypeCodeId').val(getResult.Verifier).attr('disabled', true);
                $('#txtDesignation1').val(getResult.VerifierDesignation).attr('disabled', true);
                $('#txtEngineer').val(getResult.DeliveredBy).attr('disabled', true);
                $('#hdnEngineerId').val(getResult.DeliveredBy).attr('disabled', true);
                $('#txtDesignation2').val(getResult.DeliveredByDesignation).attr('disabled', true);
                $('#txt1stDeliveryWeight').val(getResult.DeliveryWeight1st).attr('disabled', false);
                $('#txt2ndDeliveryWeight').val(getResult.DeliveryWeight2nd).attr('disabled', false);
                // $('#txtIssuedonTime').val(getResult.IssuedOnTime).attr('disabled', true);
                if (getResult.IssuedOnTime != 10155) {
                    $('#txtIssuedonTime').val(10156);
                }
                else {
                    $('#txtIssuedonTime').val(10155);
                }
                $('#txtDeliverySchudule').val(getResult.DeliverySchedule).attr('disabled', false);
                $('#txtDeliveryWindow').val(getResult.DeliveryWindow).attr('disabled', true);
                $('#txtQCTimeliness').val(getResult.QCTimeliness).attr('disabled', false);
                $('#txtTotalLinenBagsRequested').val(getResult.TotalBagRequested).attr('disabled', true);
                $('#txtTotalLinenBagsIssued').val(getResult.TotalBagIssued).attr('disabled', true);
                $('LovId_').val(getResult.FieldValue).attr('disabled', true);
                $('#txtTotalLinenItemsRequested').val(getResult.TotalItemRequested).attr('disabled', true);
                $('#txtTotalLinenItemsIssued').val(getResult.TotalItemIssued).attr('disabled', true);
                $('#txtTotalLinenItemsShortfall').val(getResult.TotalItemShortfall).attr('disabled', true);
                
                $('#txtShortfallQC').val(getResult.ShortfallQC).attr('disabled', false);
                $('#txtCLIOption').val(10166).attr('disabled', true);
                $('#txtTotalWeight').val(getResult.TotalWeight).attr('disabled', true);
                $('#txtRemarks').val(getResult.Remarks).attr('disabled', false);
                $('#primaty').val(getResult.CLILinenItemId);
                $('#hdnAttachId').val(getResult.GuId);
                $('.btnDelete').hide();
                $('.btnEdit').hide();
                //$('.btnSave').hide();
                if (getResult.cleanLinenLaundryValues != null) {
                    BindVariationDetailGrids(getResult.cleanLinenLaundryValues);
                }
                if (getResult.LLinenIssueItemGridList != null && getResult.LLinenIssueItemGridList.length > 0) {
                    BindSecondGridDataGetById(getResult);
                }
                if (getResult.TotalItemShortfall != 0 && getResult.TxnStatus == '10103') {
                    $('.btnSave').show();
                    //if (getResult.ReceivedBy2nd == " " || getResult.ReceivedBy2nd == "" || getResult.ReceivedBy2nd == null) {
                    //    DisplayErrorMessage("Please Enter 2nd ReceivedBy ");
                    //    $('#myPleaseWait').modal('hide');
                    //    return false;
                    //}
                }
                else {
                    $('.btnSave').hide();
                }
                
                $('#contactBtn').hide();
                $('#txtUserAreaCode').prop('disabled', true);
                $('.btnDelete').hide();
                

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

function DisplayErrorMessage(errorMessage) {
    $("div.errormsgcenter").text(errorMessage);
    $('#errorMsg').css('visibility', 'visible');

    $('#btnSave').attr('disabled', false);
    $('#btnEdit').attr('disabled', false);
}

function LinenitemLinkClicked(CleanLinenIssueId) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#FrmIssue :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    //$("#primaty").val(CLILinenItemId);
    $('#primaryID').val(CleanLinenIssueId);
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
        $('.btnDelete').hide();
    }

    if (action == 'View') {
        $("#FrmIssue :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);


    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/CleanLinenIssue/GetByLinenItemDetails/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                if (getResult.LLinenIssueItemGridList != null && getResult.LLinenIssueItemGridList.length > 0) {
                    BindSecondGridData(getResult);
                }
                $('#contactBtn').hide();
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

function LinenBagLinkClicked(CleanLinenIssueId) {
   
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#FrmIssue :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    //$("#primaty").val(CLILinenItemId);
    $('#primaryID').val(CleanLinenIssueId);
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
        $('#btnDelete').hide();
    }

    if (action == 'View') {
        $("#FrmIssue :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);


    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        
        $.get("/api/CleanLinenIssue/GetByLinenBagDetails/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                $('#txtPriority').val(getResult.Priorityid);
                $('#txtRequestDateTime').val(moment(getResult.RequestDateTime).format("DD-MMM-YYYY HH:mm"));
                $('#RequestedQuantity_0').val(getResult.LaundrybagItemGridList[0].BL01);
                $('#RequestedQuantity_1').val(getResult.LaundrybagItemGridList[0].BL02);
                $('#RequestedQuantity_2').val(getResult.LaundrybagItemGridList[0].BL03);
                $('#RequestedQuantity_3').val(getResult.LaundrybagItemGridList[0].BL04);
                $('#RequestedQuantity_4').val(getResult.LaundrybagItemGridList[0].BL05);
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

function LinkGetByScheduledId(IssuedonTime) {
    var jqxhr = $.post("/api/CleanLinenIssue/GetByScheduledId", IssuedonTime, function (response) {
        var result = JSON.parse(response);
        $("#primaryID").val(result.CleanLinenIssueId);
        var test = result.IssuedOnTime;
        if (test == 10155)
        {
            $('#txtIssuedonTime').val(10155);
        }
        else
        {
            $('#txtIssuedonTime').val(10156);
        }
        $('#txtIssuedonTime').attr('disabled', true);

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
            $("div.errormsgcenter").text(errorMessage).css('visibility', 'visible');
            $('#errorMsg').css('visibility', 'visible');
            $('#btnAdjustmentSave').attr('disabled', false);
            $('#btnAdjustmentEdit').attr('disabled', false);

            $('#myPleaseWait').modal('hide');
            $("#grid").trigger('reloadGrid');
        });
}

$(".btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/CleanLinenIssue/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('CleanLinenIssue', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('CleanLinenIssue', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}
$("#btnNextScreenSave").click(function () {
    var primaryId = $("#primaryID").val();

    var hdnStatus = $("#hdnStatus").val();

    if (hdnStatus == 0 || hdnStatus == '0') {
        bootbox.alert('Only Active CleanLinenIssue can be navigated to Level Screen');

    }
    else if (primaryId != null && primaryId != 0 && primaryId != "0" && primaryId != '') {
        var msg = 'Do you want to proceed to Level screen?'
        bootbox.confirm(msg, function (Conform) {
            if (Conform) {
                window.location.href = "/LLS/Level/Add/" + primaryId;
            }
            else {
                bootbox.hideAll();
                return false;
            }
        });
    }

});

function EmptyFields() {
    $('#ContactGrid').empty();
    $("#variationgrid").empty();
    $('#CompletionInfoResultId').empty();
    $(".content").scrollTop(0);
    $('#hdnAttachId').val('');
    $('#btnDelete').hide();
    $('#txtCLRDocumentNo').val('');
    $('#txtRequestDateTime').val('');
    $('#txtUserAreaCode').val('').prop('disabled', false);
    $('#txtUserAreaName').val('');
    $('#txtLocationCode').val('');
    $('#txtUserCode').val('');
    $('#txtDeliverySchudule').val('null').prop('disabled', false);
    $('#txtLocationcode').val('');
    $('#txt2stdelivrydatetime').val('').prop('disabled', true);
    $('#txt1stdelivrydatetime').val('').prop('disabled', false);
    $('#txtLocationName').val('').prop('disabled', true);
    $('#txtRequestedBy').val('').prop('disabled', true);
    $('#txtDesignation').val('').prop('disabled', true);
    $('#txtBlockCode').val('').prop('disabled', false);
    $('#txtDesignations').val('').prop('disabled', true);
    $('#txtContactPerson').val('').prop('disabled', false);
    $('#txtDesignation0').val('').prop('disabled', true);
    $('#txtTypeCode').val('').prop('disabled', false);
    $('#txtDesignation1').val('').prop('disabled', true);
    $('#txtEngineer').val('').prop('disabled', false);
    $('#txtDesignation2').val('').prop('disabled', true);
    $('#txt1stDeliveryWeight').val('').prop('disabled', false);
    $('#txt2ndDeliveryWeight').val('').prop('disabled', true);
    $('#txtTotalWeight').val('').prop('disabled', true);
    $('#txtIssuedonTime').val('null').prop('disabled', false);
    $('#txtDeliveryWindow').val('').prop('disabled', false);
    $('#txtQCTimeliness').val('null').prop('disabled', false);
    $('#txtTotalLinenBagsRequested').val('').prop('disabled', true);
    $('#txtTotalLinenBagsIssued').val('').prop('disabled', true);
    $('#txtTotalLinenItemsRequested').val('').prop('disabled', true);
    $('#txtTotalLinenItemsIssued').val('').prop('disabled', true);
    $('#txtTotalLinenItemsIssued').val('').prop('disabled', true);
    $('#txtTotalLinenItemsShortfall').val('').prop('disabled', true);
    $('#txtShortfallQC').val('null').prop('disabled', false);
    $('#txtCLIOption').val('10165').prop('disabled', true);
    $('#txtRemarks').val('').prop('disabled', false);
    $('#spnActionType').text('Add');
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $('#btnSave').show();
    $('#primaryID').val('');
    $("#grid").trigger('reloadGrid');
    $("#FrmIssue :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#txtStatus').val(1);
    AddFirstGridRow();
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

////////////////////***********Add rows **************//
$('#contactBtn').click(function () {


    var rowCount = $('#CompletionInfoResultId tr:last').index();
    var LinenCode = $('#EmployeeName_' + rowCount).val();

    if (rowCount < 0)
        AddFirstGridRow();
    else if (rowCount >= "0" && (LinenCode == "")) {
        bootbox.alert("Please fill the last record");
    }
    else {
        AddFirstGridRow();
    }
});

$('#chkContactDeleteAll').on('click', function () {
    var isChecked = $(this).prop("checked");
    //var index1; $('#chkContactDeleteAll').prop('checked', true);
    // var count = 0;
    $('#ContactGrid tr').each(function (index, value) {
        // if (index == 0) return;
        // index1 = index - 1;
        if (isChecked) {
            // if(!$('#chkContactDelete_' +index1).prop('disabled'))
            // {
            $('#chkContactDelete_' + index).prop('checked', true);
            $('#chkContactDelete_' + index).parent().addClass('bgDelete');
            $('#EmployeeName_' + index).parent().removeClass('has-error');
            // count++;
            //  }
        }
        else {
            //if(!$('#chkContactDelete_' +index1).prop('disabled'))
            //{
          
            $('#chkContactDelete_' + index).prop('checked', false);
            $('#chkContactDelete_' + index).parent().removeClass('bgDelete');
            // }
        }
    });
    //if(count == 0){
    //    $(this).prop("checked", false);
    //}
});



//***********************start******************************


var linkCliked1 = false;
window.AddFirstGridRow = function () {
    $('#chkContactDeleteAll').prop('checked', false);
    var inputpar = {
        inlineHTML: '<tr class="ng-scope" style=""> ' +
            '<td width="3%" style="text-align:center"> <input type="checkbox" onchange="DeleteContact(maxindexval)" id="chkContactDelete_maxindexval" /></td>' +
            //'<td width="10%" style="text-align: center;"><div><input type="text" id="txtLinenCode_maxindexval" name="LinenCode" maxlength="50"   onkeyup="FetchLinenCode(event,maxindexval)" onpaste="FetchLinenCode(event,maxindexval)" change="FetchLinenCode(event,maxindexval)"oninput="FetchLinenCode(event,maxindexval)"  class="form-control" autocomplete="off" tabindex="0" required  placeholder="Please Select"><input type="hidden" id="LinenCodeId_maxindexval"/><input type="hidden" id="LinenCodeUpdateDetId_maxindexval"/> <div class="col-sm-12" id="divLinenCodeFetch_maxindexval"></div > </div></td>< td width="15%" style="text-align: center;" > <div> ' +
            '<td width="15%" style="text-align: center;"><div><input type="text" id="txtLinenCode_maxindexval" disabled name="LinenCode" maxlength="50"   class="form-control fetchField" onkeyup="FetchLinenCode(event,maxindexval)" onpaste="FetchLinenCode(event,maxindexval)" change="FetchLinenCode(event,maxindexval)" oninput="FetchLinenCode(event,maxindexval)" placeholder=" please select" disabled><input type="hidden" id="LinenCodeId_maxindexval" required/><input type="hidden" id="CLILinenItemId_maxindexval" /><input type="hidden" id="LinenCodeUpdateDetId_maxindexval" /><input type="hidden" id="hdnCostPerHour_maxindexval" /> <div class="col-sm-12" id="divFetch_maxindexval"></div > </div></td>< td width="15%" style="text-align: center;" > <div> ' +
            '<td width="12%" style="text-align: center;"><div><input type="text" id="txtLinenDescription_maxindexval" disabled name="LinenDescription" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" required ></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtAgreedShelfLevel_maxindexval" disabled  name="AgreedShelfLevel" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" required ></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtBalanceOnShelf_maxindexval" disabled name="BalanceOnShelf" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"  ></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="StartDate_maxindexval" disabled name="RequestedQuantity" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" required ></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="EndDate_maxindexval" onchange="CalculateRepairHours(maxindexval)" onkeyup="calculateIssued(maxindexval)" name="1stDeliveryIssuedQty" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" required ></div></td><div> ' +
            //'<td width="10%" style="text-align: center;"><div><input type="text" id="txt2ndDeliveryIssuedQty_maxindexval" disabled onchange="CalculateRepairHours(maxindexval)" onkeyup="calculatIssued(maxindexval)" name="2ndDeliveryIssuedQty" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"  ></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="PPMHours_maxindexval" onblur="calculateLinenItemShortfall(maxindexval)" name="Shortfall6" disabled maxlength="50"  class="form-control" autocomplete="off" tabindex="0"  ></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtStoreBalance_maxindexval" disabled name="Shortfall6" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"  ></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtLinenRemarks_maxindexval" name="toreBalance" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"  ></div></td><div></tr>',
        IdPlaceholderused: "maxindexval",
        TargetId: "#ContactGrid",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    //$("input[id^='txtGeneratedDemerit_'], input[id^='txtFinalDemerit_']").attr('pattern', '^[0-9]+$');
    $("input[id^='txtLinenCode_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtLinenDescription_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtAgreedShelfLevel_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtBalanceOnShelf_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtRequestedQuantity_']").attr('pattern', '^[a-zA-Z./\\(\\),\\-\\s]+$');
    $("input[id^='EndDate_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    //$("input[id^='txt2ndDeliveryIssuedQty_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtShortfall6_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtStoreBalance_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtRemarks_']").attr('pattern', '^[a-zA-Z./\\(\\),\\-\\s]+$');

    if (!linkCliked1) {
        $('#ContactGrid tr:last td:first input').focus();
    }
    else {
        linkCliked1 = false;
    }
    formInputValidation("FrmIssue");

}

////////////////////*********** End Add rows **************//