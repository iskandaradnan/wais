
$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    //$('#btnDelete').hide();
    $('.btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $.get("/api/LinenRejectReplacement/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            AddFirstGridRow();
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });
});
function FetchCLINo(event) {    // Commonly using CompanyStaffFetch
    var ItemMst = {
        SearchColumn: 'CRMWorkCompInfoAccBy' + '-CLINo',//Id of Fetch field
        ResultColumns: ["CleanLinenIssueId" + "-Primary Key", 'CLINo' + '-CRMWorkCompInfoAccBy', 'Remarks' + '-Remarks', 'UserAreaCode-UserAreaCode', 'UserAreaName-User AreName', 'UserLocationCode-StaffName', 'UserLocationName-UserLocationName', 'LLSUserAreaId-LLSUserAreaId','LLSUserAreaLocationId-LLSUserAreaLocationId'],//Columns to be displayed
        FieldsToBeFilled: ["hdncrmCompTabAccbyId" + "-CleanLinenIssueId", 'CRMWorkCompInfoAccBy' + '-CLINo', 'txtCLIDescription' + '-Remarks', "txtUserAreaCode-UserAreaCode", "txtUserAreaName-UserAreaName", "txtHospitalRepresentative-UserLocationCode", "txtLocationName-UserLocationName", "hdnUserAreaId-LLSUserAreaId","hdnHospitalRepresentativeId-LLSUserAreaLocationId"]//id of element - the model property
    };
    DisplayFetchResult('AccptStfFetch', ItemMst, "/api/Fetch/LinenRejectReplacementTxn_FetchCLINo", "Ulfetch1", event, 1);
}
//var UserAreaCodeFetchObj = {
//    SearchColumn: 'txtUserAreaCode-UserAreaCode',//Id of Fetch field
//    ResultColumns: ["LLSUserAreaId-Primary Key", 'UserAreaCode-UserAreaCode','UserAreaName-User AreName'],
//    FieldsToBeFilled: ["hdnUserAreaId-LLSUserAreaId", "txtUserAreaCode-UserAreaCode", "txtUserAreaName-UserAreaName"]
//};

//$('#txtUserAreaCode').on('input propertychange paste keyup', function (event) {
//    DisplayFetchResult('divUserAreaFetch', UserAreaCodeFetchObj, "/api/Fetch/LinenRejectReplacementTxn_FetchUserAreaCode", "UlFetch2", event, 1);//1 -- pageIndex
//});
//var LocationFetchObj = {
//    SearchColumn: 'txtHospitalRepresentative-UserLocationCode',//Id of Fetch field
//    ResultColumns: ["LLSUserAreaLocationId-Primary Key", 'UserLocationCode-StaffName', 'FacRep-FacRep', 'UserLocationName-UserLocationName'],
//    FieldsToBeFilled: ["hdnHospitalRepresentativeId-LLSUserAreaLocationId", "txtHospitalRepresentative-UserLocationCode", "txtLocationName-UserLocationName"]
//};

$('#txtHospitalRepresentative').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divHospitalRepresentativeFetch', LocationFetchObj, "/api/Fetch/LinenRejectReplacementTxn_FetchLocCode", "UlFetch3", event, 1);//1 -- pageIndex
});


////////////
var RejectedByFetchObj = {
    SearchColumn: 'txtBlockCode-StaffName',//Id of Fetch field
    ResultColumns: ["UserRegistrationId-Primary Key", 'StaffName-Block Code', 'Designation-Designation'],//Columns to be displayed
    FieldsToBeFilled: ["hdnRejectId-UserRegistrationId", "txtBlockCode-StaffName","txtDesignation-Designation"]//id of element - the model property
};
$('#txtBlockCode').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divRejectFetch', RejectedByFetchObj, "/api/Fetch/LinenRejectReplacementTxn_FetchRejectedBy", "UlFetch4", event, 1);//1 -- pageIndex
});


var ReplacementFetchObj = {
    SearchColumn: 'txtOldBerNo-StaffName',//Id of Fetch field
    ResultColumns: ["UserRegistrationId-Primary Key", 'StaffName-BER No.', 'Designation-Designation'],
    FieldsToBeFilled: ["hdnRejectedBERReferenceId-UserRegistrationId", "txtOldBerNo-StaffName", "txtReplaceDesignation-Designation"],
   
};
$('#txtOldBerNo').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divReplacement', ReplacementFetchObj, "/api/Fetch/LinenRejectReplacementTxn_FetchReceivedBy", "UlFetch5", event, 1);
});
$(".btnSave,.btnEdit,#btnSaveandAddNew").click(function () {
    $('#btnlogin').attr('disabled', true);
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#myPleaseWait').modal('hide');
    //$('#txtCLIDescription').attr('required', true);
    $('#txtUserAreaCode').attr('required', true);
    $('#txtHospitalRepresentative').attr('required', true);
    $('#txtOldBerNo').attr('required', true);
    $('#txtReceivedDateTime').attr('required', true);
    $('#txtRemarks').attr('required', true);
    $('#txtDateTime').attr('required', true);
    $('#txtLinenCode_').attr('required', true);
    $('#txtReplacedQty_').attr('required', true);
    //first grid 

    var _index;        // var _indexThird;
    var result = [];
    $('#ContactGrid tr').each(function () {
        _index = $(this).index();
    });
    for (var i = 0; i <= _index; i++) {
        var active = true;
        var isDeletedcat = $('#IsDeletedCategory_' + i).prop('checked');
        var LinenRejectReplacementId = $('#LinenRejectReplacementId_' + i).val();
        var _tempObj = {
            LinenRejectReplacementDetId: $('#LinenRejectReplacementDetId_' + i).val(),
            LinenCode: $('#txtLinenCode_' + i).val(),
            LinenDescription: $('#txtLinenDescription_' + i).val(),
            LinenItemId: $('#LinenCodeId_' + i).val(),
            Ql01aTapeGlue: $('#txtQL01a_' + i).val(),
            Ql01bChemical: $('#txtQL01b_' + i).val(),
            Ql01cBlood: $('#txtQL01c_' + i).val(),
            Ql01dPermanentStain: $('#txtQL01d_' + i).val(),
            Ql02TornPatches: $('#txtQL02_' + i).val(),
            Ql03Button: $('#txtQL03_' + i).val(),
            Ql04String: $('#txtQL04_' + i).val(),
            Ql05Odor: $('#txtQL05_' + i).val(),
            Ql06aFaded: $('#txtQL06a_' + i).val(),
            Ql06bThinMaterial: $('#txtQLO6b_' + i).val(),
            Ql06cWornOut: $('#txtQL06c_' + i).val(),
            Ql06d3YrsOld: $('#txtQL06d_' + i).val(),
            Ql07Shrink: $('#txtQL07_' + i).val(),
            Ql08Crumple: $('#txtQL08_' + i).val(),
            Ql09Lint: $('#txtQL09_' + i).val(),
            TotalRejectedQuantity: $('#txtTotalRejectedQty_' + i).val(),
            ReplacedQuantity: $('#txtReplacedQty_' + i).val(),
            ReplacedDateTime: $('#txtReplacedDateTime_' + i).val(),
            Remarks: $('#txtRemarks_' + i).val(),
            IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
        }
       
        result.push(_tempObj);
    }
    var CurrentbtnID = $(this).attr("value");
    var timeStamp = $("#Timestamp").val();

    var isFormValid = formInputValidation("FrmReject", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }
    var MstLinenReject = {
        DocumentNo: $('#txtDocumentNo').val(),
        DateTime: $('#txtDateTime').val(),
        CleanLinenIssueId: $('#hdncrmCompTabAccbyId').val(),
        CLIDescription: $('#txtCLIDescription').val(),
        LLSUserAreaId: $('#hdnUserAreaId').val(),
        LLSUserLocationId: $('#hdnHospitalRepresentativeId').val(),
        RejectedBy: $('#hdnRejectId').val(),
        ReplacementReceivedBy: $('#hdnRejectedBERReferenceId').val(),
        EffectiveDate: $('#txtReceivedDateTime').val(),
        TotalRejectedQuantity: $('#txtTotalQuantityRejected').val(),
        TotalQuantityReplaced: $('#txtTotalQuantityReplaced').val(),
        Remarks: $('#txtRemarks').val(),
        LLinenRejectGridList: result
    };
    function chkIsDeletedRow(i, delrec) {
        if (delrec == true) {
            $('#txtLinenCode_' + i).prop("required", false);
            $('#txtLinenDescription_' + i).prop("required", false);
            //$('#LinenCodeId_' + i).prop("required", false);
            $('#txtQL01a_' + i).prop("required", false);
            $('#txtQL01b_' + i).prop("required", false);
            $('#txtQL01c_' + i).prop("required", false);
            $('#txtQL01d_' + i).prop("required", false);
            $('#txtQL02_' + i).prop("required", false);
            $('#txtQL03_' + i).prop("required", false);
            $('#txtQL04_' + i).prop("required", false);
            $('#txtQL05_' + i).prop("required", false);
            $('#txtQL06a_' + i).prop("required", false);
            $('#txtQLO6b_' + i).prop("required", false);
            $('#txtQL06c_' + i).prop("required", false);
            $('#txtQL06d_' + i).prop("required", false);
            $('#txtQL07_' + i).prop("required", false);
            $('#txtQL08_' + i).prop("required", false);
            $('#txtQL09_' + i).prop("required", false);
            $('#txtTotalRejectedQty_' + i).prop("required", false);
            $('#txtReplacedQty_' + i).prop("required", false);
            $('#txtReplacedDateTime_' + i).prop("required", false);
            $('#txtRemarks_' + i).prop("required", false);
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
            MstLinenReject.LinenRejectReplacementId = primaryId;
            MstLinenReject.Timestamp = timeStamp;
        }
        else {
            MstLinenReject.LinenRejectReplacementId = 0;
            MstLinenReject.Timestamp = "";
        }

        var jqxhr = $.post("/api/LinenRejectReplacement/Save", MstLinenReject, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.LinenRejectReplacementId);
            $("#Timestamp").val(result.Timestamp);
            // $('#blockName').val(result.BlockName);
            //$('#blockFacilityId').val(result.FacilityId);
            $('#SelStatus option[value="' + result.Active + '"]').prop('selected', true);
            $('#hdnStatus').val(result.Active);
            if (result != null && result.LLinenRejectGridList != null && result.LLinenRejectGridList.length > 0) {
                BindSecondGridData(result);
            }
            $("#grid").trigger('reloadGrid');
            if (result.LinenRejectReplacementId != 0) {
                $('#hdnAttachId').val(result.HiddenId);
                $('#txtDocumentNo').val(result.DocumentNo);
                $('#txtTotalQuantityReplaced').val(result.ReplacedQuantity);
                $('#txtTotalQuantityRejected').val(result.TotalRejectedQuantity);
                $('#txtReplacedDateTime_').val(moment(result.ReplacedDateTime).format("DD-MMM-YYYY HH:MM"));
                $('#txtDateTime').prop('disabled', true);
                $('#CRMWorkCompInfoAccBy').prop('disabled', true);
                $('#txtCLIDescription').prop('disabled', true);
                $('#txtUserAreaCode').prop('disabled', true);
                $('#txtHospitalRepresentative').prop('disabled', true);
                $('#txtBlockCode').prop('disabled', true);
                $('#txtOldBerNo').prop('disabled', true);
                $('#txtReceivedDateTime').prop('disabled', true);
                $('#btnNextScreenSave').show();
                $('#btnEdit').show();
                $('#btnSave').hide();               
                $('.btnDelete').hide();
                $('.btnEdit').hide();
            }
            $(".content").scrollTop(0);
            showMessage('LinenReject', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            if (CurrentbtnID == "1") {
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
                $("div.errormsgcenter").text(errorMessage);
                $('#errorMsg').css('visibility', 'visible');

                $('#btnSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            });
    });

$("#chk_FacWorkIsDelete").change(function () {
    var Isdeletebool = this.checked;

    if (this.checked) {
        $('#FacilityWorkshopTbl tr').map(function (i) {
            if ($("#Isdeleted_" + i).prop("disabled")) {
                $("#Isdeleted_" + i).prop("checked", false);
            }
            else {
                $("#Isdeleted_" + i).prop("checked", true);
            }
        });
    } else {
        $('#FacilityWorkshopTbl tr').map(function (i) {
            $("#Isdeleted_" + i).prop("checked", false);
        });
    }
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
        'top': $('#txtLinenCode_' + index).offset().top - $('#RejectLinenProvider').offset().top + $('#txtLinenCode_' + index).innerHeight(),
    });
    var LinenFetchObj = {
        SearchColumn: 'txtLinenCode_' + index + '-LinenCode',//Id of Fetch field
        ResultColumns: ["LinenItemId-Primary Key", 'LinenCode' + '-txtLinenCode_' + index],
        FieldsToBeFilled: ["LinenCodeId_" + index + "-LinenItemId", 'txtLinenCode_' + index + '-LinenCode', 'txtLinenDescription_' + index + '-LinenDescription']
    };

    DisplayFetchResult('divLinenCodeFetch_' + index, LinenFetchObj, "/api/Fetch/LinenRejectReplacementTxnDet_FetchLinenCode", "UlFetch6" + index + "", event, 1);//1 -- pageIndex
}


    //************************************************ Getbyid bind data *************************

function BindSecondGridData(getResult) {
        var ActionType = $('#ActionType').val();
        $("#ContactGrid").empty();
        $.each(getResult.LLinenRejectGridList, function (index, value) {
            AddFirstGridRow();
            $("#LinenRejectReplacementDetId_" + index).val(getResult.LLinenRejectGridList[index].LinenRejectReplacementDetId);
            $("#LinenCodeId_" + index).val(getResult.LLinenRejectGridList[index].LinenItemId);
            $("#txtLinenCode_" + index).val(getResult.LLinenRejectGridList[index].LinenCode).attr('disabled', true);
            $("#txtLinenDescription_" + index).val(getResult.LLinenRejectGridList[index].LinenDescription).attr('disabled', true);
            $("#txtQL01a_" + index).val(getResult.LLinenRejectGridList[index].Ql01aTapeGlue);
            $("#txtQL01b_" + index).val(getResult.LLinenRejectGridList[index].Ql01bChemical);
            $("#txtQL01c_" + index).val(getResult.LLinenRejectGridList[index].Ql01cBlood);
            $("#txtQL01d_" + index).val(getResult.LLinenRejectGridList[index].Ql01dPermanentStain);
            $("#txtQL02_" + index).val(getResult.LLinenRejectGridList[index].Ql02TornPatches);
            $("#txtQL03_" + index).val(getResult.LLinenRejectGridList[index].Ql03Button);
            $("#txtQL04_" + index).val(getResult.LLinenRejectGridList[index].Ql04String);
            $("#txtQL05_" + index).val(getResult.LLinenRejectGridList[index].Ql05Odor);
            $("#txtQL06a_" + index).val(getResult.LLinenRejectGridList[index].Ql06aFaded);
            $("#txtQLO6b_" + index).val(getResult.LLinenRejectGridList[index].Ql06bThinMaterial);
            $("#txtQL06c_" + index).val(getResult.LLinenRejectGridList[index].Ql06cWornOut);
            $("#txtQL06d_" + index).val(getResult.LLinenRejectGridList[index].Ql06d3YrsOld);
            $("#txtQL07_" + index).val(getResult.LLinenRejectGridList[index].Ql07Shrink);
            $("#txtQL08_" + index).val(getResult.LLinenRejectGridList[index].Ql08Crumple);
            $("#txtQL09_" + index).val(getResult.LLinenRejectGridList[index].Ql09Lint); 
            $("#txtTotalRejectedQty_" + index).val(getResult.LLinenRejectGridList[index].TotalRejectedQuantity);
            $("#txtReplacedQty_" + index).val(getResult.LLinenRejectGridList[index].ReplacedQuantity);
            $("#txtReplacedDateTime_" + index).val(moment(getResult.LLinenRejectGridList[index].ReplacedDateTime).format("DD-MMM-YYYY HH:MM"));
            $("#txtRemarks_" + index).val(getResult.LLinenRejectGridList[index].Remarks);
            linkCliked2 = true;
            $(".content").scrollTop(0);
        });

        //************************************************ Grid Pagination *******************************************

if ((getResult.LLinenRejectGridList && getResult.LLinenRejectGridList.length) > 0) {
            GridtotalRecords = getResult.LLinenRejectGridList[0].TotalRecords;
            TotalPages = getResult.LLinenRejectGridList[0].TotalPages;
            LastRecord = getResult.LLinenRejectGridList[0].LastRecord;
            FirstRecord = getResult.LLinenRejectGridList[0].FirstRecord;
            pageindex = getResult.LLinenRejectGridList[0].PageIndex;
            linkCliked2 = true;
            $(".content").scrollTop(0);
        }
        $('#paginationfooter').show();


        //************************************************ End *******************************************************
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



function LinkClicked(LinenRejectReplacementId) {
    $(".content").scrollTop(1);
    linkCliked1 = true;
    $('.nav-tabs a:first').tab('show');
    $("#FrmReject :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(LinenRejectReplacementId);
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
        $("#FrmReject :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/LinenRejectReplacement/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                $('#txtDocumentNo').val(getResult.DocumentNo).attr('disabled', true);
                $('#txtDateTime').val(moment(getResult.DateTime).format("DD-MMM-YYYY HH:MM")).attr('disabled', true);
                $('#CRMWorkCompInfoAccBy').val(getResult.CLINo).attr('disabled', true);
                $('#hdncrmCompTabAccbyId').val(0).attr('disabled', true);
                $('#txtCLIDescription').val(getResult.CLIDescription).attr('disabled', true);
                $('#txtUserAreaCode').val(getResult.UserAreaCode).attr('disabled', true);
                $('#txtUserAreaName').val(getResult.UserAreaName).attr('disabled', true);
                $('#txtHospitalRepresentative').val(getResult.UserLocationCode).attr('disabled', true);
                $('#txtLocationName').val(getResult.UserLocationName).attr('disabled', true);
                $('#txtBlockCode').val(getResult.RejectedBy).attr('disabled', true);
                $('#hdnRejectId').val(getResult.RejectedBy).attr('disabled', true);
                $('#txtOldBerNo').val(getResult.ReplacementReceivedBy).attr('disabled', true);
                $('#hdnRejectedBERReferenceId').val(getResult.ReplacementReceivedBy).attr('disabled', true);
                $('#txtReplaceDesignation').val(getResult.ReplacementReceivedByDesignation).attr('disabled', true);
                $('#txtDesignation').val(getResult.RejectedByDesignation).attr('disabled', true);
                // $('#txtReplacementReceivedBy').val(getResult.ReplacementReceivedBy);
                $('#txtReceivedDateTime').val(moment(getResult.ReceivedDateTime).format("DD-MMM-YYYY HH:MM")).attr('disabled', true);
                $('#txtTotalQuantityRejected').val(getResult.TotalRejectedQuantity).attr('disabled', true);
                $('#txtTotalQuantityReplaced').val(getResult.ReplacedQuantity).attr('disabled', true);
                $('#txtRemarks').val(getResult.Remarks);
                $('#primaryID').val(getResult.LinenRejectReplacementId);
                $('#hdnStatus').val(getResult.Active);
                $('#hdnAttachId').val(getResult.HiddenId);
                $('#myPleaseWait').modal('hide');
                $('.btnDelete').hide();
                $('.btnEdit').hide();
                if (getResult != null && getResult.LLinenRejectGridList != null && getResult.LLinenRejectGridList.length > 0) {
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
            $.get("/api/LinenRejectReplacement/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('LinenRejectReplacement', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('LinenRejectReplacement', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}
$("#btnNextScreenSave").click(function () {
    var primaryId = $("#primaryID").val();

    var hdnStatus = $("#hdnStatus").val();

    if (hdnStatus == 0 || hdnStatus == '0') {
        bootbox.alert('Only Active LinenReject can be navigated to Level Screen');

    }
    else if (primaryId != null && primaryId != 0 && primaryId != "0" && primaryId != '') {
        var msg = 'Do you want to proceed to Level screen?'
        bootbox.confirm(msg, function (Conform) {
            if (Conform) {
                window.location.href = "/bems/Level/Add/" + primaryId;
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
    $(".content").scrollTop(0);
    $('#hdnAttachId').val('');
    $('.btnDelete').hide();
    $('#txtDocumentNo').val('');
    $('#txtDateTime').val('').prop('disabled', false);
    $('#CRMWorkCompInfoAccBy').val('').prop('disabled', false);
    $('#txtUserAreaCode').val('').prop('disabled', false);
    $('#txtUserAreaName').val('');
    $('#txtHospitalRepresentative').val('').prop('disabled', false);
    $('#txtLocationName').val('');
    $('#txtBlockCode').val('').prop('disabled', false);
    $('#txtDesignation').val('');
    $('#txtOldBerNo').val('').prop('disabled', false);
    $('#txtReplaceDesignation').val('');
    $('#txtReceivedDateTime').val('').prop('disabled', false);
    $('#txtTotalQuantityRejected').val('');
    $('#txtTotalQuantityRejected').val('');
    $('#txtReceivedDateTime').val('');
    $('#txtCLIDescription').val('').prop('disabled', false);
    $('#txtRejectedBy').val('');
    $('#txtReplacementReceivedBy').val('').prop('disabled', false);
    $('#txtReceivedDateTime').val('').prop('disabled', false);
    $('#txtTotalQuantityRejected').val('');
    $('#txtTotalQuantityReplaced').val('');
    $('#txtRemarks').val('');
    $('#spnActionType').text('Add');
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $('#btnSave').show();
    $('#primaryID').val('');
    $("#grid").trigger('reloadGrid');
    $("#FrmReject :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#SelStatus').val(1);
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

    var rowCount = $('#ContactGrid tr:last').index();
    var LinenCode = $('#txtLinenCode_' + rowCount).val();

    if (rowCount < 0)
        AddFirstGridRow();
    else if (rowCount >= "0" && (LinenCode == "")) {
        bootbox.alert("Please fill the last record");
    }
    else {
        AddFirstGridRow();
    }
});
//$('#chkContactDeleteAll').on('click', function () {
//    var isChecked = $(this).prop("checked");
//    //var index1; $('#chkContactDeleteAll').prop('checked', true);
//    // var count = 0;
//    $('#ContactGrid tr').each(function (index, value) {
//        // if (index == 0) return;
//        // index1 = index - 1;
//        if (isChecked) {
//            // if(!$('#chkContactDelete_' +index1).prop('disabled'))
//            // {
//            $('#chkContactDelete_' + index).prop('checked', true);
//            $('#chkContactDelete_' + index).parent().addClass('bgDelete');
//            $('#txtLinenCode_' + index).removeAttr('required');
//            $('#txtLinenCode_' + index).parent().removeClass('has-error');
//            // count++;
//            //  }
//        }
//        else {
//            //if(!$('#chkContactDelete_' +index1).prop('disabled'))
//            //{
//            $('#txtLinenCode_' + index).attr('required', true);
//            $('#chkContactDelete_' + index).prop('checked', false);
//            $('#chkContactDelete_' + index).parent().removeClass('bgDelete');
//            // }
//        }
//    });
//    //if(count == 0){
//    //    $(this).prop("checked", false);
//    //}
//});

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

function adding(index) {
    var a = parseInt(document.getElementById("txtQL01a_" + index).value);
    var b = parseInt(document.getElementById("txtQL01b_" + index).value);
    var c = parseInt(document.getElementById("txtQL01c_" + index).value);
    var d = parseInt(document.getElementById("txtQL01d_" + index).value);
    var e = parseInt(document.getElementById("txtQL02_" + index).value);
    var f = parseInt(document.getElementById("txtQL03_" + index).value);
    var g = parseInt(document.getElementById("txtQL04_" + index).value);
    var h = parseInt(document.getElementById("txtQL05_" + index).value);
    var i = parseInt(document.getElementById("txtQL06a_" + index).value);
    var j = parseInt(document.getElementById("txtQLO6b_" + index).value);
    var k = parseInt(document.getElementById("txtQL06c_" + index).value);
    var l = parseInt(document.getElementById("txtQL06d_" + index).value);
    var m = parseInt(document.getElementById("txtQL07_" + index).value);
    var n = parseInt(document.getElementById("txtQL08_" + index).value);
    var o = parseInt(document.getElementById("txtQL09_" + index).value);
    a = isNaN(a) ? 0 : a;
    b = isNaN(b) ? 0 : b;
    c = isNaN(c) ? 0 : c;
    d = isNaN(d) ? 0 : d;
    e = isNaN(e) ? 0 : e;
    f = isNaN(f) ? 0 : f; 
    g = isNaN(g) ? 0 : g;
    h = isNaN(h) ? 0 : h;
    i = isNaN(i) ? 0 : i;
    j = isNaN(j) ? 0 : j;
    k = isNaN(k) ? 0 : k;
    l = isNaN(l) ? 0 : l;
    m = isNaN(m) ? 0 : m;
    n = isNaN(n) ? 0 : n;
    o = isNaN(o) ? 0 : o;
    due = a + b + c + d + e + f + g + h + i + j + k + l + m + n + o;
    console.log(due);
    $("#txtTotalRejectedQty_" + index).val(due);
    console.log(due);
}

var linkCliked1 = false;
window.AddFirstGridRow = function () {
    $('#chkContactDeleteAll').prop('checked', false);
    var inputpar = {
        inlineHTML: '<tr class="ng-scope" style=""> ' +
            '<td width="2%" style="text-align:center"> <input type="checkbox" value="false" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(ContactGrid,chkContactDeleteAll)" tabindex="0"></td>' +
            //'<td width="5%" style="text-align: center;"><div><input type="text" id="txtLinenCode_maxindexval" placeholder="Please Select" name="txtLinenCode" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="7%" style="text-align: center;"><div><input type="text" id="txtLinenCode_maxindexval" name="LinenCode" maxlength="50"   onkeyup="FetchLinenCode(event,maxindexval)" onpaste="FetchLinenCode(event,maxindexval)" change="FetchLinenCode(event,maxindexval)"oninput="FetchLinenCode(event,maxindexval)"  class="form-control" autocomplete="off" tabindex="0" required  placeholder="Please Select"><input type="hidden" id="LinenCodeId_maxindexval" required/><input type="hidden" id="LinenRejectReplacementDetId_maxindexval"/> <div class="col-sm-12" id="divLinenCodeFetch_maxindexval"></div > </div></td>< td width="15%" style="text-align: center;" > <div> ' +
            '<td width="7%" style="text-align: center;"><div><input type="text" id="txtLinenDescription_maxindexval" name="LinenDescription" maxlength="50"  class="form-control" disabled autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="4%" style="text-align: center;"><div><input type="text" id="txtQL01a_maxindexval" onblur="adding(maxindexval)" name="txtQL01a" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="4%" style="text-align: center;"><div><input type="text" id="txtQL01b_maxindexval" onblur="adding(maxindexval)" name="txtQL01b" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="4%" style="text-align: center;"><div><input type="text" id="txtQL01c_maxindexval" onblur="adding(maxindexval)" name="txtQL01c" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="4%" style="text-align: center;"><div><input type="text" id="txtQL01d_maxindexval" onblur="adding(maxindexval)" name="txtQL01d" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="4%" style="text-align: center;"><div><input type="text" id="txtQL02_maxindexval" onblur="adding(maxindexval)" name="txtQL02" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="4%" style="text-align: center;"><div><input type="text" id="txtQL03_maxindexval" onblur="adding(maxindexval)" name="txtQL03" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="4%" style="text-align: center;"><div><input type="text" id="txtQL04_maxindexval" onblur="adding(maxindexval)" name="txtQL04" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="4%" style="text-align: center;"><div><input type="text" id="txtQL05_maxindexval" onblur="adding(maxindexval)" name="txtQL05" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="4%" style="text-align: center;"><div><input type="text" id="txtQL06a_maxindexval" onblur="adding(maxindexval)" name="txtQL06a" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="4%" style="text-align: center;"><div><input type="text" id="txtQLO6b_maxindexval" onblur="adding(maxindexval)" name="txtQLO6b"  maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="4%" style="text-align: center;"><div><input type="text" id="txtQL06c_maxindexval" onblur="adding(maxindexval)" name="txtQL06c" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="4%" style="text-align: center;"><div><input type="text" id="txtQL06d_maxindexval" onblur="adding(maxindexval)" name="txtQL06d" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="4%" style="text-align: center;"><div><input type="text" id="txtQL07_maxindexval" onblur="adding(maxindexval)" name="txtQL07" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="4%" style="text-align: center;"><div><input type="text" id="txtQL08_maxindexval" onblur="adding(maxindexval)" name="txtQL08" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="4%" style="text-align: center;"><div><input type="text" id="txtQL09_maxindexval" onblur="adding(maxindexval)" name="txtQL09" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="4%" style="text-align: center;"><div><input type="text" id="txtTotalRejectedQty_maxindexval"  maxlength="50"  class="form-control" autocomplete="off" tabindex="0"  disabled><div> ' +
            '<td width="4%" style="text-align: center;"><div><input type="text" id="txtReplacedQty_maxindexval" name="txtReplacedQty" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" required></div></td><div> ' +
            '<td width="9%" style="text-align: center;"><div><input type="text" id="txtReplacedDateTime_maxindexval" name="txtReplacedDateTime" maxlength="50" class="form-control datatimepicker" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="7%" style="text-align: center;"><div><input type="text" id="txtRemarks_maxindexval" name="txtRemarks" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div></tr>',
        IdPlaceholderused: "maxindexval",
        TargetId: "#ContactGrid",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    //$("input[id^='txtGeneratedDemerit_'], input[id^='txtFinalDemerit_']").attr('pattern', '^[0-9]+$');
    $("input[id^='txtLinenCode_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtLinenDescription_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtQL01a_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtQL01b_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtQL01c_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtQL01d_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtQL02_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtQL03_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtQL04_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtQL05_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtQL06a_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtQLO6b_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtQL06c_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtQL06d_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtQL07_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtQL08_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtQL09_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtTotalRejectedQty_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtReplacedQty_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    //$("input[id^='txtReplacedDateTime_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtRemarks_']").attr('pattern', '^[a-zA-Z./\\(\\),\\-\\s]+$');

    if (!linkCliked1) {
        $('#ContactGrid tr:last td:first input').focus();
    }
    else {
        linkCliked1 = false;
    }
    formInputValidation("FrmReject");

}
////////////////////*********** End Add rows **************//