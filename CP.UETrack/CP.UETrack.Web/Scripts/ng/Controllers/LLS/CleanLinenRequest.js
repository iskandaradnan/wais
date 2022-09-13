$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    $('.btnDelete').hide();
    $('#txtLocationName').prop('disabled', true);
    $('#txtUserAreaName').prop('disabled', true);
    $('#txtDesignation').prop('disabled', true);
    $('#txtIssuedonTime').prop('disabled', true);
    $('#txtQCTimeliness').prop('disabled', true);
    $('#txtShortfallQC').prop('disabled', true);
    $('#txtIssueStatus').prop('disabled', true);
    $.get("/api/CleanLinenRequest/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $.each(loadResult.DeliveryWindow, function (index, value) {
                $('#txtDeliveryWindow').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.IssuedonTime, function (index, value) {
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
            $.each(loadResult.IssueStatus, function (index, value) {
                $('#txtIssueStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
           
            //variation rate grid
            if (loadResult.cleanLinenLaundryValue != null) {
                BindVariationDetailGrid(loadResult.cleanLinenLaundryValue);
                window.VariationListGloabal = loadResult.cleanLinenLaundryValue;
            }
            AddFirstGridRow();

        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });
});

//----------------Fetch----------------------

var UserAreaFetchObj = {
    SearchColumn: 'txtUserAreaCode-UserAreaCode',//Id of Fetch field
    ResultColumns: ["LLSUserAreaId-Primary Key", 'UserAreaCode-UserAreaCode', 'UserAreaName-UserAreaName'],//Columns to be displayed
    FieldsToBeFilled: ["hdnUserAreaId-LLSUserAreaId", "txtUserAreaCode-UserAreaCode", "txtUserAreaName-UserAreaName"],//id of element - the model property
   
};
$('#txtUserAreaCode').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divFetch3', UserAreaFetchObj, "/api/Fetch/Cleanlinenrequest_UserareaCodeFetch", "UlFetch1", event, 1);//1 -- pageIndex
});


var LocationCodeFetchObj = {
    SearchColumn: 'txtUserLevelCode-UserLocationCode',//Id of Fetch field
    ResultColumns: ["LLSUserAreaLocationId-Primary Key", 'UserLocationCode-UserLocationCode', 'UserLocationName-UserLocationName'],//Columns to be displayed
    FieldsToBeFilled: ["hdnLevelId-LLSUserAreaLocationId", "txtUserLevelCode-UserLocationCode", "txtLocationName-UserLocationName"],

};

$('#txtUserLevelCode').on('input propertychange paste keyup', function (event) {
    var UserAreaCode = $('#hdnUserAreaId').val();
    DisplayLocationCodeFetchResult('divFetch2', LocationCodeFetchObj, "/api/Fetch/CleanLinenRequestTxn_FetchLocCode", "UlFetch2", event, 1, UserAreaCode);//1 -- pageIndex
});


var BlockCodeFetchObj = {
    SearchColumn: 'txtBlockCode-StaffName',//Id of Fetch field
    ResultColumns: ["UserRegistrationId-Primary Key", 'StaffName-StaffName', 'Designation-Designation'],//Columns to be displayed
    FieldsToBeFilled: ["hdnBlockId-UserRegistrationId", "txtBlockCode-StaffName", "txtDesignation-Designation"]//id of element - the model property
};
$('#txtBlockCode').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divFetch1', BlockCodeFetchObj, "/api/Fetch/Cleanlinenrequest_FetchrequestBy", "UlFetch3", event, 1);//1 -- pageIndex
});

//----------------Fetch End----------------------

$(".btnSave,.btnSaveandAddNew").click(function () {
    $('#btnlogin').attr('disabled', true);
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('txtLinenCode_').attr('required', true);
    $('txtRequestedQuantity_').attr('required', true);
    $('#txtRequestDateTime').attr('required', true);
    $('#txtUserAreaCode').attr('required', true);
    $('#txtUserLevelCode').attr('required', true);
    $('#txtBlockCode').attr('required', true);
    //$('#txtDeliveryWindow').attr('required', true);
    $('#txtPriority').attr('required', true);   

    var _index;      
    var variationresult = [];
    $('#variationgrid tr').each(function () {
        _index = $(this).index();
    });  
    for (var i = 0; i <= _index; i++) {
        var active = true;
        var _tempObj = {
            CLRLinenBagId: $('#CLRLinenBagId_' + i).val(),
            LovId: $('#LovId_' + i).val(),
            CleanLinenRequestId: $("#LovId_" + i).val(),
            FieldValue: $('#LovId_' + i).val(),
            RequestedQuantity: $('#RequestedQuantity_' + i).val(),
            Remarks: $('#Remarks_' + i).val(),
           
           
        }
        variationresult.push(_tempObj);
    }
    //first grid 

    var _index;        // var _indexThird;
    var result = [];
    $('#ContactGrid tr').each(function () {
        _index = $(this).index();
    });
    for (var i = 0; i <= _index; i++) {
        var active = true;
        var isDeletedcat = $('#IsDeletedCategory_' + i).prop('checked');
        var LinenCondemnationDetId = $('#LinenCondemnationDetId' + i).val();
        var _tempObj = {
            LinenItemId: $('#LinenItemId_' + i).val(),
            CLRLinenItemId: $('#CLRLinenItemId_' + i).val(),
            //LinenCondemnationId: $('#LinenCondemnationId_' + i).val(),
            LinenCode: $('#txtLinenCode_' + i).val(),
            LinenDescription: $('#txtLinenDescription_' + i).val(),
            AgreedShelfLevel: $('#txtAgreedShelfLevel_' + i).val(),
            BalanceOnShelf: $('#txtBalanceOnShelf_' + i).val(),
            RequestedQuantity: $('#txtRequestedQuantity_' + i).val(),
            DeliveryIssuedQty1st: $('#txt1stDeliveryIssuedQty_' + i).val(),
            DeliveryIssuedQty2nd: $('#txt2ndDeliveryIssuedQty_' + i).val(),
            Shortfall: $('#txtShortfall6_' + i).val(),
            StoreBalance: $('#txtStoreBalance_' + i).val(),
            IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
        }
        duplicateLinenCheck(_index);
        result.push(_tempObj);
    } 

    var CurrentbtnID = $(this).attr("value");
    var timeStamp = $("#Timestamp").val();
    var isFormValid = formInputValidation("FrmReq", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }
    var MstCleanLinenRequest = {
        DocumentNo: $('#txtCLRDocumentNo').val(),
        RequestDateTime: $('#txtRequestDateTime').val(),
        UserAreaCode: $('#txtUserAreaCode').val(),
        LLSUserAreaId: $('#hdnUserAreaId').val(),
        LLSUserAreaLocationId: $('#hdnLevelId').val(),
        LocationCode: $('#txtLocationCode').val(),
        LocationName: $('#txtLocationName').val(),
        RequestedBy: $('#hdnBlockId').val(),
        Designation: $('#txtDesignation').val(),
        IssuedonTime: $('#txtIssuedonTime').val(),
        DeliveryWindow: $('#txtDeliveryWindow').val(),
        Priority: $('#txtPriority').val(),
        QCTimeliness: $('#txtQCTimeliness').val(),
        ShortfallQC: $('#txtShortfallQC').val(),
        IssueStatus: $('#txtIssueStatus').val(),
        Remarks: $('#txtRemarks').val(),
        TotalItemRequested: $('#txtTotalLinenItemsRequestedQuantity').val(),
        TotalLinenItemsIssued: $('#txtTotalLinenItemsIssued').val(),
        TotalLinenItemsShortfall: $('#txtTotalLinenItemsShortfall').val(),
        cleanLinenLaundryValue: variationresult,
        LLinenRequestItemGridList: result,
        GuId: $('#hdnAttachId').val(),
        CurrentbtnID:CurrentbtnID
    }
    //////////vadilation ///////////////
    //if (MstCleanLinenRequest.LLSUserAreaId == " " || MstCleanLinenRequest.LLSUserAreaId == "") {
    //    MstCleanLinenRequest.LLSUserAreaId = null;
    //}
    //var endDt = MstCleanLinenRequest.LLSUserAreaId;
    //if (endDt == null) {
    //    $("div.errormsgcenter").text("Valid UserAreaCode required");
    //    $('#errorMsg').css('visibility', 'visible');
    //    $('#myPleaseWait').modal('hide');
    //    return false;
    //}
    //if (MstCleanLinenRequest.LLSUserAreaLocationId == " " || MstCleanLinenRequest.LLSUserAreaLocationId == "") {
    //    MstCleanLinenRequest.LLSUserAreaLocationId = null;
    //}
    //var EndDt = MstCleanLinenRequest.LLSUserAreaLocationId;
    //if (EndDt == null) {
    //    $("div.errormsgcenter").text("Valid Location Code required");
    //    $('#errorMsg').css('visibility', 'visible');
    //    $('#myPleaseWait').modal('hide');
    //    return false;
    //}
    //if (MstCleanLinenRequest.RequestedBy == " " || MstCleanLinenRequest.RequestedBy == "") {
    //    MstCleanLinenRequest.RequestedBy = null;
    //}
    //var ndDt = MstCleanLinenRequest.RequestedBy;
    //if (ndDt == null) {
    //    $("div.errormsgcenter").text("Valid RequestedBy required");
    //    $('#errorMsg').css('visibility', 'visible');
    //    $('#myPleaseWait').modal('hide');
    //    return false;
    //}

    //////////vadilation ///////////////
    function chkIsDeletedRow(i, delrec) {
        if (delrec == true) {
            $('#txtLinenCode_' + i).prop("required", false);
            $('#txtLinenDescription_' + i).prop("required", false);
            $('#txtAgreedShelfLevel_' + i).prop("required", false);
            $('#txtBalanceOnShelf_' + i).prop("required", false);
            $('#txtRequestedQuantity_' + i).prop("required", false);
            $('#txt1stDeliveryIssuedQty_' + i).prop("required", false);
            $('#txt2ndDeliveryIssuedQty_' + i).prop("required", false);
            $('#txtShortfall6_' + i).prop("required", false);
            $('#txtStoreBalance_' + i).prop("required", false);
           
            return true;
        }
        else {
            return false;
        }
    }

    var deletedCount = Enumerable.From(result).Where(x => x.IsDeleted).Count();
    var Isdeleteavailable = deletedCount > 0;
    if (deletedCount == result.length && TotalPages == 1) {
        bootbox.alert("Sorry!. You cannot delete all rows");
        $('#myPleaseWait').modal('hide');
        return false;
    }
    var primaryId = $("#primaryID").val();
    if (primaryId != null) {
        MstCleanLinenRequest.CleanLinenRequestId = primaryId;
        MstCleanLinenRequest.Timestamp = timeStamp;
    }
    else {
        MstCleanLinenRequest.CleanLinenRequestId = 0;
        MstCleanLinenRequest.Timestamp = "";
    }

    var jqxhr = $.post("/api/CleanLinenRequest/Save", MstCleanLinenRequest, function (response) {
        var result = JSON.parse(response);
        $("#primaryID").val(result.CleanLinenRequestId);
        $("#Timestamp").val(result.Timestamp);
        if (result.cleanLinenLaundryValue != null) {
            BindVariationDetailGrid(result.cleanLinenLaundryValue);
        }
        if (result != null && result.LLinenRequestItemGridList != null && result.LLinenRequestItemGridList.length > 0) {
            BindSecondGridData(result);
        }
        $("#grid").trigger('reloadGrid');
        if (result.CleanLinenRequestId != 0) {
            $('#hdnAttachId').val(result.HiddenId);
            $('#txtCLRDocumentNo').val(result.DocumentNo).prop('disabled', true);
            if (result.cleanLinenLaundryValue != null) {
                BindVariationDetailGrids(result.cleanLinenLaundryValue);
            }
            $('#txtTotalLinenItemsShortfall').val(result.TotalLinenItemShortfall).attr('disabled', true);
            $('#txtTotalLinenItemsIssuedQuantity').val(result.TotalItemIssued).attr('disabled', true);
            $('#btnEdit').show();
            $('#btnSave').hide();
            $('.btnDelete').hide();
        }
        $(".content").scrollTop(0);
        showMessage('CleanLinenRequest', CURD_MESSAGE_STATUS.SS);
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

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
});


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
        'top': $('#txtLinenCode_' + index).offset().top - $('#ContractorVendorList').offset().top + $('#txtLinenCode_' + index).innerHeight(),
    });
    var LinenFetchObj = {
        SearchColumn: 'txtLinenCode_' + index + '-LinenCode',//Id of Fetch field
        ResultColumns: ["LinenItemId-Primary Key", 'LinenCode' + '-txtLinenCode_' + index, 'LinenDescription' + '-txtLinenDescription_' + index, 'AgreedShelfLevel' + '-txtAgreedShelfLevel_' + index, 'StoreBalance' + '-txtStoreBalance_' + index],
        FieldsToBeFilled: ["LinenItemId_" + index + "-LinenItemId", 'txtLinenCode_' + index + '-LinenCode', 'txtLinenDescription_' + index + ' -LinenDescription', 'txtAgreedShelfLevel_' + index + '-AgreedShelfLevel', 'txtStoreBalance_' + index + '-StoreBalance']
    };
    var UserLocationCode = $('#txtUserLevelCode').val();
    LLSDisplayLocationCodeFetchResult('divLinenCodeFetch_' + index, LinenFetchObj, "/api/Fetch/Cleanlinenrequestlinenitem_LinenCodeFetch", "UlFetch4" + index + "", event, 1, UserLocationCode);
}

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

//************************************************ Getbyid bind data *************************

function BindSecondGridData(getResult) {
    var ActionType = $('#ActionType').val();
    $("#ContactGrid").empty();
    $.each(getResult.LLinenRequestItemGridList, function (index, value) {
        AddFirstGridRow();
        $("#LinenItemId_" + index).val(getResult.LLinenRequestItemGridList[index].LinenItemId);
        $("#CLRLinenItemId_" + index).val(getResult.LLinenRequestItemGridList[index].CLRLinenItemId);
        $("#txtLinenCode_" + index).val(getResult.LLinenRequestItemGridList[index].LinenCode).attr('disabled', true);
        $("#txtLinenDescription_" + index).val(getResult.LLinenRequestItemGridList[index].LinenDescription).attr('disabled', true);
        $("#txtAgreedShelfLevel_" + index).val(getResult.LLinenRequestItemGridList[index].AgreedShelfLevel).attr('disabled', true);
        $("#txtBalanceOnShelf_" + index).val(getResult.LLinenRequestItemGridList[index].BalanceOnShelf).attr('disabled', true);
        $("#txtRequestedQuantity_" + index).val(getResult.LLinenRequestItemGridList[index].RequestedQuantity);
        $("#txt1stDeliveryIssuedQty_" + index).val(getResult.LLinenRequestItemGridList[index].DeliveryIssuedQty1st).attr('disabled', true);
        $("#txt2ndDeliveryIssuedQty_" + index).val(getResult.LLinenRequestItemGridList[index].DeliveryIssuedQty2nd).attr('disabled', true);
        $("#txtShortfall6_" + index).val(getResult.LLinenRequestItemGridList[index].Shortfall).attr('disabled', true);
        $("#txtStoreBalance_" + index).val(getResult.LLinenRequestItemGridList[index].StoreBalance).attr('disabled', true);
        $("#Remarks_" + index).val(getResult.LLinenRequestItemGridList[index].Remarks);
        linkCliked2 = true;
        $(".content").scrollTop(0);
    });
    //************************************************ Grid Pagination *******************************************

    if ((getResult.LLinenRequestItemGridList && getResult.LLinenRequestItemGridList.length) > 0) {
        GridtotalRecords = getResult.LLinenRequestItemGridList[0].TotalRecords;
        TotalPages = getResult.LLinenRequestItemGridList[0].TotalPages;
        LastRecord = getResult.LLinenRequestItemGridList[0].LastRecord;
        FirstRecord = getResult.LLinenRequestItemGridList[0].FirstRecord;
        pageindex = getResult.LLinenRequestItemGridList[0].PageIndex;
        linkCliked2 = true;
        $(".content").scrollTop(0);
    }
    $('#paginationfooter').show();


    //************************************************ End *******************************************************
}


function LinkClicked(CleanLinenRequestId) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#FrmReq :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(CleanLinenRequestId);
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
        $('.btnDelete').show();
    }

    if (action == 'View') {
        $("#FrmReq :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        ////$('#btnSaveandAddNew').hide();
        //$('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/CleanLinenRequest/Get/" + primaryId)
            .done(function (result) {                         
                var getResult = JSON.parse(result);
                $('#primaryID').val(getResult.CleanLinenRequestId);
                $('#txtCLRDocumentNo').val(getResult.DocumentNo).attr('disabled', true);
                $('#txtRequestDateTime').val(moment(getResult.RequestDateTime).format("DD-MMM-YYYY HH:mm")).attr('disabled', true);
                $('#txtUserAreaCode').val(getResult.UserAreaCode).attr('disabled', true);
                $('#hdnUserAreaId').val(getResult.UserAreaCode).attr('disabled', true);
                $('#txtUserAreaName').val(getResult.UserAreaName).attr('disabled', true);
                $('#txtUserLevelCode').val(getResult.UserLocationCode).attr('disabled', true);
                $('#hdnLevelId').val(getResult.UserLocationCode).attr('disabled', true);
                $('#txtLocationName').val(getResult.UserLocationName).attr('disabled', true);
                $('#hdnBlockId').val(getResult.RequestedBy).attr('disabled', true);
                $('#txtBlockCode').val(getResult.RequestedBy).attr('disabled', true);
                $('#txtIssuedonTime').val(getResult.IssuedonTime).attr('disabled', true);
                $('#txtDeliveryWindow').val(getResult.DeliverySchedule).attr('disabled', true);
                $('#txtPriority').val(getResult.Priority).attr('disabled', true);
                $('#txtQCTimeliness').val(getResult.QCTimeliness).attr('disabled', true);
                $('#txtShortfallQC').val(getResult.ShortfallQC).attr('disabled', true);
                $('#txtIssueStatus').val(getResult.IssueStatus).attr('disabled', true);
                $('#txtTotalLinenItemsRequestedQuantity').val(getResult.TotalItemRequested).attr('disabled', true);
                $('#txtTotalLinenItemsIssued').val(getResult.TotalItemIssued).attr('disabled', true);
                $('#txtTotalLinenItemsShortfall').val(getResult.TotalLinenItemShortfall).attr('disabled', true);
                $('#txtRemark').val(getResult.Remarks);
                $('#txtTotalLinenItemsIssuedQuantity').val(getResult.TotalItemIssued);
                $('#hdnAttachId').val(getResult.GuId);
                if (getResult.TxnStatus == 10103) {
                    $('.btnSave').show();
                } else {
                    $('.btnSave').hide();
                }
               
                $('.btnDelete').hide();
                $('.btnSaveandAddNew').hide();                              
                if (getResult.cleanLinenLaundryValue != null) {                   
                    BindVariationDetailGrids(getResult.cleanLinenLaundryValue);
                }
                if (getResult.LLinenRequestItemGridList != null && getResult.LLinenRequestItemGridList.length > 0) {               
                    BindSecondGridData(getResult);
                }
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

$(".btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/CleanLinenRequest/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('CleanLinenRequest', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('CleanLinenRequestt', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}

function EmptyFields() {
    $('#ContactGrid').empty();
    $("#variationgrid").empty();
    $(".content").scrollTop(0);
    $('#hdnAttachId').val('');
    $('.btnDelete').hide();
    $('#txtDespatchDocumentNo').val('');
    $('#txtReceivedDateTime').val('');
    $('#txtDespatchedFrom').val('');
    $('#txtReceivedBy').val('');
    $('#txtNoofPackages').val('');
    $('#txtTotalWeight').val('');
    $('#txtTotaReceived').val('');
    $('#txtLinenCode').val('');
    $('#txtLinenDescription').val('');
    $('#txtDespatchedQuantity').val('');
    $('#txtReceivedQuantity').val('');
    $('#txtVariance').val('');
    $('#txtCLRDocumentNo').val('');
    $('#txtRequestDateTime').val('');
    $('#txtUserAreaCode').val('');
    $('#txtUserAreaCode').prop('disabled', false);
    $('#txtUserAreaName').val('');
    $('#txtUserAreaName').prop('disabled', false);
    $('#txtUserLevelCode').val('');
    $('#txtUserLevelCode').prop('disabled', false);
    $('#txtLocationName').val('');
    $('#txtLocationName').prop('disabled', false);
    $('#txtBlockCode').val('');
    $('#txtBlockCode').prop('disabled', false);
    $('#txtDesignation').val('');
    $('#txtIssuedonTime').val('null');
    $('#txtIssuedonTime').prop('disabled', false);
    $('#txtDeliveryWindow').val('null').prop('disabled', false);
    $('#txtPriority').val('null');
    $('#txtPriority').prop('disabled', false);
    $('#txtQCTimeliness').val('null');
    $('#txtQCTimeliness').prop('disabled', false);
    $('#txtTotalLinenItemsRequestedQuantity').prop('disabled', false);
    $('#txtTotalLinenItemsRequestedQuantity').val('');
    $('#txtTotalLinenItemsIssuedQuantity').prop('disabled', false);
    $('#txtTotalLinenItemsIssuedQuantity').val('');
    $('#txtTotalLinenItemsShortfall').val('');
    $('#txtTotalLinenItemsShortfall').prop('disabled', false);
    $('#txtShortfallQC').prop('disabled', false);
    $('#txtShortfallQC').val('null');
    $('#txtIssueStatus').val('10103').prop('disabled', true);    
    $('#txtRemarks').val('');  
    $("#FrmReq :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    AddFirstGridRow();
    $("#grid").trigger('reloadGrid');
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
})
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
            html += '<input type="text" id="RequestedQuantity_' + index + '" onkeyup="Due(' + index + ')"  style="text-align:right;" class="form-control" required pattern="[0-9]+">';
            html += '</div> </td>';
            html += '<td width="20%" style="text-align:center;" rowspan="1"> <div>';
            html += '<input type="text" id="IssuedQuantity_' + index + '"   style="text-align:right;" class="form-control "" pattern="[0-9]+" disabled>';
            html += '</div> </td>';
            html += '<td width="20%" style="text-align:center;" rowspan="1"> <div>';
            html += '<input type="text" id="shortfall_' + index + '" style="text-align:right;" class="form-control " " pattern="[0-9]+" disabled>';
            html += '</div> </td>';
            html += ' <td width="20%" style="text-align:center;" rowspan="1"><div>'; 
            html += '<input type="text" id="Remarks_' + index + '" class="form-control " /> ';
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
}
window.BindVariationDetailGrids = function (list) {
    $("#variationgrid").empty();
    if (list.length > 0) {
        var html = '';
        $(list).each(function (index, data) {

            html += '<tr>';
            html += '<td width="20%" style="text-align:center;" rowspan="1">';
            html += '<input type="hidden" readonly id="CLRLinenBagId_' + index + '" value="' + data.CLRLinenBagId + '" /> ';
            html += '<input type="hidden" readonly id="LovId_' + index + '" value="' + data.LovId + '" /> ';
            html += '<input disabled type="text" value="' + data.FieldValue + '" style="text-align:left;" class="form-control"/> ';
            html += '<input type="hidden" id="LovId_' + index + '" value="' + data.LovId + '" />';
            html += '  </td>';
            html += '<td width="20%" style="text-align:center;" rowspan="1"> <div>';
            html += '<input type="text" id="RequestedQuantity_' + index + '" value="' + data.RequestedQuantity + '" onkeyup="updateDue(' + index + ')"  style="text-align:right;" class="form-control" "pattern="[0-9]+">';
            html += '</div> </td>';
            html += '<td width="20%" style="text-align:center;" rowspan="1"> <div>';
            html += '<input type="text" id="IssuedQuantity_' + index + '"  value="' + data.IssuedQuantity + '" disabled style="text-align:right;" class="form-control" "pattern="[0-9]+">';
            html += '</div> </td>';
            html += '<td width="20%" style="text-align:center;" rowspan="1"> <div>';
            html += '<input type="text" id="shortfall_' + index + '"  value="' + data.Shortfall + '" disabled style="text-align:right;" class="form-control" " pattern="[0-9]+">';
            html += '</div> </td>';
            html += ' <td width="20%" style="text-align:center;" rowspan="1"><div>';
            html += '<input type="text" id="Remarks_' + index + '" value="' + data.Remarks + '"  class="form-control" /> ';
            html += '</td>';
            html += ' </tr>';

        });

        $('#variationgrid').append(html);
        formInputValidation("FrmReq");

    }
}

var lov
function updateDue(lov) {
    var total = parseInt(document.getElementById("RequestedQuantity_" + lov).value);
    var val2 = parseInt(document.getElementById("IssuedQuantity_" + lov).value);
    due = total - val2;
    $("#shortfall_" + lov).val(due);
}
////////////////////***********Add rows **************//

//***********Duplicate Validation **************//

function duplicateLinenCheck(index) {
    var rowCount = $('#ContactGrid tr:last').index();
    var rowCount_ID = rowCount;
    allow = 0;
    for (var Linen = 0; Linen <= rowCount; Linen++) {
        for (var LinenCode = 0; LinenCode <= rowCount_ID; LinenCode++) {
            if (Linen != LinenCode) {
                var actual = $('#txtLinenCode_' + Linen).val();
                var current = $('#txtLinenCode_' + LinenCode).val()
                if (actual == current) {
                    alert("Already Exist Linencode");
                    allow = 1;
                    $("#ContactGrid tr").eq(index).remove();
                    //$('#txtLinenCode_' + LinenCode).val('');
                    //$('#txtLinenDescription_' + LinenCode).val('');
                    //$('#txtRequestedQuantity_' + LinenCode).val('');
                    //$('#txtBalanceOnShelf_' + LinenCode).val('');
                    //$('#txtAgreedShelfLevel_' + LinenCode).val('');
                    //$('#txt1stDeliveryIssuedQty_' + LinenCode).val('');
                    //$('#txt2ndDeliveryIssuedQty_' + LinenCode).val('');
                    //$('#txtShortfall6_' + LinenCode).val('');
                    //$('#txtStoreBalance_' + LinenCode).val('');

                    
                } else {

                    //alert("not found");
                }

            } else {
            }

        }
    }

}

////////////////////***********End Duplicate Validation **************//


$('#contactBtn').click(function () {
    var rowCount = $('#ContactGrid tr:last').index();
    var LinenCode = $('#txtLinenCode_' + rowCount).val();
    var RequestedQuantity = $('#txtRequestedQuantity_' + rowCount).val();
    if (rowCount < 0)
        AddFirstGridRow();
    else if (rowCount >= "0" && (LinenCode == "" || RequestedQuantity == "")) {
        bootbox.alert("Please fill the last record");
    }
    else {

        AddFirstGridRow();
    }
});
$('#chkContactDeleteAll').on('click', function () {
    var isChecked = $(this).prop("checked");
    $('#ContactGrid tr').each(function (index, value) {
        if (isChecked) {
            $('#chkContactDelete_' + index).prop('checked', true);
            $('#chkContactDelete_' + index).parent().addClass('bgDelete');
            $('#txtLinenCode_' + index).removeAttr('required');
            $('#txtLinenCode_' + index).parent().removeClass('has-error');
            
        }
        else {
           
            $('#txtLinenCode_' + index).attr('required', true);
            $('#chkContactDelete_' + index).prop('checked', false);
            $('#chkContactDelete_' + index).parent().removeClass('bgDelete');
            // }
        }
    });
    
});
$("#chkContactDeleteAll").change(function () {
    var Isdeletebool = this.checked;
    if (this.checked) {
        $('#ContactGrid tr').map(function (i) {
            if ($("#Isdeleted_" + i).prop("disabled")) {
                $("#Isdeleted_" + i).prop("checked", false);
            }
            else {
                $("#Isdeleted_" + i).prop("checked", true);
            }
        });
    } else {
        $('#ContactGrid tr').map(function (i) {
            $("#Isdeleted_" + i).prop("checked", false);
        });
    }
});

function calculateIssued(index) {
    var rowCount = $('#ContactGrid tr:last').index();
    var totalAA = 0;
    var a = 0;
    for (var i = 0; i <= rowCount; i++) {
        a = parseInt(document.getElementById("txtRequestedQuantity_" + i).value);
        totalAA = parseInt(totalAA + a);
    }
    $('#txtTotalLinenItemsRequestedQuantity').val(totalAA);
    console.log(totalAA);
}

var linkCliked1 = false;
window.AddFirstGridRow = function () {
    $('#chkContactDeleteAll').prop('checked', false);
    var inputpar = {
        inlineHTML: '<tr class="ng-scope" style=""> ' +
            '<td width="5%" style="text-align:center"> <input type="checkbox"value="false" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(ContactGrid,chkContactDeleteAll)" tabindex="0"></td>' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtLinenCode_maxindexval" name="LinenCode" maxlength="50"   onkeyup="FetchLinenCode(event,maxindexval)" onpaste="FetchLinenCode(event,maxindexval)" change="FetchLinenCode(event,maxindexval)"oninput="FetchLinenCode(event,maxindexval)"  class="form-control" autocomplete="off" tabindex="0" placeholder="Please Select" required><input type="hidden" id="LinenItemId_maxindexval" required/><input type="hidden" id="CLRLinenItemId_maxindexval"/><div class="col-sm-12" id="divLinenCodeFetch_maxindexval"></div > </div></td>< td width="15%" style="text-align: center;" > <div> ' +
            '<td width="15%" style="text-align: center;"><div><input type="text" id="txtLinenDescription_maxindexval" name="LinenDescription" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" disabled ></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtAgreedShelfLevel_maxindexval" name="AgreedShelfLevel" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" "pattern="[0-9]+" disabled ></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtBalanceOnShelf_maxindexval" name="BalanceOnShelf" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" "pattern="[0-9]+"  ></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtRequestedQuantity_maxindexval" onblur="duplicateLinenCheck(maxindexval)"  onkeyup="calculateIssued(maxindexval)" name="RequestedQuantity" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" "pattern="[0-9]+" required></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txt1stDeliveryIssuedQty_maxindexval" name="1stDeliveryIssuedQty" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" disabled ></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txt2ndDeliveryIssuedQty_maxindexval" name="2ndDeliveryIssuedQty" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" disabled ></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtShortfall6_maxindexval" name="Shortfall6" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" disabled ></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtStoreBalance_maxindexval" name="toreBalance" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" disabled ></div></td><div></tr>',
        IdPlaceholderused: "maxindexval",
        TargetId: "#ContactGrid",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    //$("input[id^='txtGeneratedDemerit_'], input[id^='txtFinalDemerit_']").attr('pattern', '^[0-9]+$');
    $("input[id^='txtLinenCode_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtLinenDescription_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    //$("input[id^='txtAgreedShelfLevel_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtBalanceOnShelf_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtRequestedQuantity_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txt1stDeliveryIssuedQty_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txt2ndDeliveryIssuedQty_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtShortfall6_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtStoreBalance_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');

    if (!linkCliked1) {
        $('#ContactGrid tr:last td:first input').focus();
    }
    else {
        linkCliked1 = false;
    }
    formInputValidation("FrmReq");

}

////////////////////*********** End Add rows **************//