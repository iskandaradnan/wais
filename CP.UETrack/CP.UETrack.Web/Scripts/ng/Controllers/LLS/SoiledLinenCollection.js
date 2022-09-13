window.UOMGloabal = [];
$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    $('.btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $.get("/api/SoiledLinenCollection/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $.each(loadResult.Ownership, function (index, value) {
                $('#txtOwnership').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.LaundryPlant, function (index, value) {
                $('#txtLaundryPlantFacilit').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            
            window.CategoryListGloabal = loadResult.CollectionSchedule;
            window.OnTime = loadResult.OnTime;
            AddFirstGridRow();
          

        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });
});
//Dont remove////

//function changeFunc(index) {
//    debugger;
   
//    var locationid = document.getElementById('LocationCodeId_' + index).value;
//    console.log(locationid);
//    var schedule = document.getElementById('PpmCategoryId_' + index).value;
//    console.log(schedule);
//            var sai = {
//                SoiledLinenCollectionDetId: locationid,
//                CollectionSchedule: schedule,

//    }
//    //var selectBox = parseInt(document.getElementById("PpmCategoryId_" + index).value);
//    //var selectedValue = selectBox.options[sa.selectedIndex].value;
//    ScheduledLinkClicked(sai);
//    ScheduledClicked(sai)
//}
//Dont remove////


$(".btnSave,.btnEdit").click(function () {
    $('#btnlogin').attr('disabled', true);
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#txtCollectionDate').attr('required', true);
    $('#txtLaundryPlantFacilit').attr('required', true);
    $('#txtDespatchDateTime').attr('required', true);
    $('#txtUserAreaCode_').attr('required', true);
    $('#txtLocationCode_').attr('required', true);
    $('#PpmCategoryId_').attr('required', true);
    $('#txtCollectionTime_').attr('required', true);
    $('#partno_').attr('required', false);


    var CurrentbtnID = $(this).attr("value");
    var timeStamp = $("#Timestamp").val();
    var isFormValid = formInputValidation("FrmSoiled", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
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
        var _tempObj = {
            SoiledLinenCollectionDetId: $('#SoiledLinenCollectionDetId_' + i).val(),
            // SoiledLinenCollectionDetId: primaryId, 
            LLSUserAreaId: $('#LinenCodeId_' + i).val(),
            LLSUserAreaLocationId: $('#LocationCodeId_' + i).val(),
            //LicenseDescription: $('#LLSUserAreaLocationId_' + i).val(),
            Weight: $('#txtWeight_' + i).val(),
            TotalWhiteBag: $('#txtTotalWhiteBag_' + i).val(),
            TotalRedBag: $('#txtTotalRedBag_' + i).val(),
            TotalGreenBag: $('#txtTotalGreenBag_' + i).val(),
            TotalBrownBag: $('#txtTotalBrownBag_' + i).val(),
            TotalQuantity: $('#txtTotalQuantity_' + i).val(),
            CollectionSchedule: $('#PpmCategoryId_' + i).val(),
            CollectionStartTime: $('#txtCollectionStartTime_' + i).val(),
            CollectionEndTime: $('#txtCollectionEndTime_' + i).val(),
            CollectionTime: $('#txtCollectionTime_' + i).val(),
            OnTime: $('#UOM_' + i).val(),
            //VerifiedBy: $('#partno_' + i).val(),
            VerifiedBy: $('#SparePartsId_' + i).val(),
            Verified: $('#SparePartsId_' + i).val(),
            VerifiedDate: $('#txtVerifiedDateTime_' + i).val(),
            Remarks: $('#txtRemarks_' + i).val(),
            IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
        }
        result.push(_tempObj);
    }
    var MstSoiled = {
       
        DocumentNo: $('#txtDocumentNo').val(),
        CollectionDate: $('#txtCollectionDate').val(),
        DespatchDate: $('#txtDespatchDateTime').val(),
        LaundryPlantID: $('#txtLaundryPlantFacilit').val(),
        Weight: $('#txtTotalSoiledWeight').val(),
        Ownership: $('#txtOwnership').val(),
        TotalWhiteBag: $('#txtTotalWhiteBag').val(),
        TotalRedBag: $('#txtTotalRedBag').val(),
        TotalGreenBag: $('#TotalGreenBag').val(),
        LSoiledLinenItemGridList: result,
        GuId: $('#hdnAttachId').val(),
    };
    function chkIsDeletedRow(i, delrec) {
        if (delrec == true) {
            $('#txtUserAreaCode_' + i).prop("required", false);
            $('#txtLocationCode_' + i).prop("required", false);
            $('#txtWeight_' + i).prop("required", false);
            $('#txtTotalWhiteBag_' + i).prop("required", false);
            $('#txtTotalRedBag_' + i).prop("required", false);
            $('#txtTotalGreenBag_' + i).prop("required", false);
            $('#txtTotalBrownBag_' + i).prop("required", false);
            $('#txtTotalQuantity_' + i).prop("required", false);
            $('#PpmCategoryId_' + i).prop("required", false);
            $('#txtCollectionStartTime_' + i).prop("required", false);
            $('#txtCollectionEndTime_' + i).prop("required", false);
            $('#txtCollectionTime_' + i).prop("required", false);
            $('#UOM_' + i).prop("required", false);
            $('#partno_' + i).prop("required", false);
            $('#txtVerifiedDateTime_0' + i).prop("required", false);
            $('#txtRemarks_0' + i).prop("required", false);
            return true;
        }
        else {
            return false;
        }
    }
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        DisplayError();
        return false;
    }
    if (MstSoiled.DespatchDate == " " || MstSoiled.DespatchDate == "") {
        MstSoiled.DespatchDate = null;
    }
    var CurrDate = new Date();

    var stDt = MstSoiled.CollectionDate;
    var endDt = MstSoiled.DespatchDate;

    stDt = Date.parse(stDt);
    if (endDt != "") {
        endDt = Date.parse(endDt);
    }

    
    if (endDt != null) {
        if (endDt != "" && endDt < stDt) {
            $("div.errormsgcenter").text("Despatch Date should be Greater/Equal To Collection Date");
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }
    }

        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            MstSoiled.SoiledLinenCollectionId = primaryId;
            MstSoiled.Timestamp = timeStamp;
        }
        else {
            MstSoiled.SoiledLinenCollectionId = 0;
            MstSoiled.Timestamp = "";
        }

        var jqxhr = $.post("/api/SoiledLinenCollection/Save", MstSoiled, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.SoiledLinenCollectionId);
            $("#Timestamp").val(result.Timestamp); if (result != null && result.LSoiledLinenItemGridList != null && result.LSoiledLinenItemGridList.length > 0) {
                BindSecondGridData(result);
            }
            $('#SelStatus option[value="' + result.Active + '"]').prop('selected', true);
            $('#hdnStatus').val(result.Active);
            $("#grid").trigger('reloadGrid');
            if (result.SoiledLinenCollectionId != 0) {
                //$('#hdnAttachId').val(result.HiddenId);
                $('#txtDocumentNo').val(result.DocumentNo);
                $('#txtOwnership').val(result.Ownership)
                $('#txtTotalWhiteBag').val(result.TotalWhiteBag);
                $('#txtTotalGreenBag').val(result.TotalGreenBag);
                $('#txtTotalBrownBag').val(result.TotalBrownBag);
                $('#txtTotalRedBag').val(result.TotalRedBag);
                $('#txtTotalSoiledWeight').val(result.Weight);
                $('#hdnAttachId').val(result.GuId);
                $('#txtDocumentNo').prop('disabled', true);
                $('#txtCollectionDate').prop('disabled', true);
                $('#txtLaundryPlantFacilit').prop('disabled', true);
                $('#txtDespatchDateTime').prop('disabled', true);
                $('#btnNextScreenSave').show();
                $('.btnEdit').hide();
                $('#btnSave').show();
                $('.btnDelete').hide();
            }
            $(".content").scrollTop(0);
            showMessage('solid', CURD_MESSAGE_STATUS.SS);
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

        $('.Submit').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
    });
});

  
//************************************************ Getbyid bind data *************************

function BindSecondGridData(getResult) {
    var ActionType = $('#ActionType').val();
    $("#ContactGrid").empty();
    $.each(getResult.LSoiledLinenItemGridList, function (index, value) {
        AddFirstGridRow();
        $("#SoiledLinenCollectionDetId_" + index).val(getResult.LSoiledLinenItemGridList[index].SoiledLinenCollectionDetId);
        $("#txtUserAreaCode_" + index).val(getResult.LSoiledLinenItemGridList[index].UserAreaCode);
        $("#txtLocationCode_" + index).val(getResult.LSoiledLinenItemGridList[index].UserLocationCode);
        $("#LinenCodeId_" + index).val(getResult.LSoiledLinenItemGridList[index].LLSUserAreaId);
        $("#LocationCodeId_" + index).val(getResult.LSoiledLinenItemGridList[index].LLSUserAreaLocationId);
        $("#txtWeight_" + index).val(getResult.LSoiledLinenItemGridList[index].Weight);
        $("#txtTotalWhiteBag_" + index).val(getResult.LSoiledLinenItemGridList[index].TotalWhiteBag);
        $("#txtTotalRedBag_" + index).val(getResult.LSoiledLinenItemGridList[index].TotalRedBag);
        $("#txtTotalGreenBag_" + index).val(getResult.LSoiledLinenItemGridList[index].TotalGreenBag);
        $("#txtTotalBrownBag_" + index).val(getResult.LSoiledLinenItemGridList[index].TotalBrownBag);
        $("#txtTotalQuantity_" + index).val(getResult.LSoiledLinenItemGridList[index].TotalQuantity).attr('disabled', true);
        $("#PpmCategoryId_" + index).val(getResult.LSoiledLinenItemGridList[index].CollectionSchedule);
        $("#txtCollectionSchedule_" + index).val(getResult.LSoiledLinenItemGridList[index].CollectionSchedule);
        $("#txtCollectionStartTime_" + index).val(getResult.LSoiledLinenItemGridList[index].CollectionStartTime).attr('disabled', true);
        $("#txtCollectionEndTime_" + index).val(getResult.LSoiledLinenItemGridList[index].CollectionEndTime).attr('disabled', true);
        $("#txtCollectionTime_" + index).val(getResult.LSoiledLinenItemGridList[index].CollectionTime)
        $("#UOM_" + index).val(getResult.LSoiledLinenItemGridList[index].OnTime).attr('disabled', true);
        $("#SparePartsId_" + index).val(getResult.LSoiledLinenItemGridList[index].Verified);
        $("#partno_" + index).val(getResult.LSoiledLinenItemGridList[index].VerifiedBy);     
        $("#txtVerifiedDateTime_" + index).val(moment(getResult.LSoiledLinenItemGridList[index].VerifiedDate).format("DD-MMM-YYYY HH:mm"));
        $("#txtRemarks_" + index).val(getResult.LSoiledLinenItemGridList[index].Remarks);
        linkCliked2 = true;

        $(".content").scrollTop(0);
    });

    //************************************************ Grid Pagination *******************************************

    if ((getResult.LSoiledLinenItemGridList && getResult.LSoiledLinenItemGridList.length) > 0) {
        GridtotalRecords = getResult.LSoiledLinenItemGridList[0].TotalRecords;
        TotalPages = getResult.LSoiledLinenItemGridList[0].TotalPages;
        LastRecord = getResult.LSoiledLinenItemGridList[0].LastRecord;
        FirstRecord = getResult.LSoiledLinenItemGridList[0].FirstRecord;
        pageindex = getResult.LSoiledLinenItemGridList[0].PageIndex;
        linkCliked2 = true;
        $(".content").scrollTop(0);
    }
    $('#paginationfooter').show();


    //************************************************ End *******************************************************
}

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

function FetchUserAreaCode(event, index) {
    $('#divLinenCodeFetch_' + index).css({
        'top': $('#txtUserAreaCode_' + index).offset().top - $('#SolidLinenProvider').offset().top + $('#txtUserAreaCode_' + index).innerHeight(),
    });
    var LinenFetchObj = {
        SearchColumn: 'txtUserAreaCode_' + index + '-UserAreaCode',//Id of Fetch field
        ResultColumns: ["LLSUserAreaId-Primary Key", 'UserAreaCode' + '-txtUserAreaCode_' + index],
        //AdditionalConditions: ["LinenItemId-" + index +"LinenCodeId_"],
        FieldsToBeFilled: ["LinenCodeId_" + index + "-LLSUserAreaId", 'txtUserAreaCode_' + index + '-UserAreaCode']
    };

    DisplayFetchResult('divLinenCodeFetch_' + index, LinenFetchObj, "/api/Fetch/SoiledLinenCollectionTxnDet_FetchUserAreaCode", "UlFetch1" + index + "", event, 1);//1 -- pageIndex
}

function FetchUserLocationCode(event, index) {
    $('#divLocationCodeFetch_' + index).css({
        'top': $('#txtLocationCode_' + index).offset().top - $('#SolidLinenProvider').offset().top + $('#txtLocationCode_' + index).innerHeight(),
    });
    var LinenFetchObj = {
        SearchColumn: 'txtLocationCode_' + index + '-UserLocationCode',//Id of Fetch field
        ResultColumns: ["LLSUserAreaLocationId-Primary Key", 'UserLocationCode' + '-txtLocationCode_' + index, 'FirstScheduleStartTime' + '-txtCollectionStartTime_' + index, 'SecondScheduleEndTime' + '-txtCollectionEndTime_' + index,],
        FieldsToBeFilled: ["LocationCodeId_" + index + "-LLSUserAreaLocationId", 'txtLocationCode_' + index + '-UserLocationCode', 'txtCollectionStartTime_' + index + '-FirstScheduleStartTime', 'txtCollectionEndTime_' + index + '-SecondScheduleEndTime']
    };
    var User = document.getElementById('txtUserAreaCode_' + index).value;
    DisplayLocationCodeFetchResult('divLocationCodeFetch_' + index, LinenFetchObj, "/api/Fetch/SoiledLinenCollectionTxnDet_FetchLocCode", "UlFetch2" + index + "" , event, 1, User);//1 -- pageIndex
}

   
 
function verifiedBy(event, index) {
    $('#divFetch2_' + index).css({
        'top': $('#partno_' + index).offset().top - $('#SolidLinenProvider').offset().top + $('#partno_' + index).innerHeight(),
    });
    var FetchObj = {
        SearchColumn: 'partno_' + index + '-StaffName',    //Id of Fetch field
        ResultColumns: ["UserRegistrationId-Primary Key", 'StaffName' + '-partno_' + index],
        FieldsToBeFilled: ["SparePartsId_" + index + "-UserRegistrationId", 'partno_' + index + '-StaffName']//id of element - the model property
    };
    DisplayFetchResult('divFetch2_' + index, FetchObj, "/api/Fetch/SoiledLinenCollectionTxnDet_FetchVerifiedBy", "UlFetch3" + index + "", event, 1);

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

function LinkClicked(SoiledLinenCollectionId) {
    $(".content").scrollTop(1);
    linkCliked1 = true;
    $('.nav-tabs a:first').tab('show');
    $("#FrmSoiled :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(SoiledLinenCollectionId);
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
        $("#FrmSoiled :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/SoiledLinenCollection/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                $('#txtDocumentNo').val(getResult.DocumentNo).attr('disabled', true);
                $('#txtCollectionDate').val(moment(getResult.CollectionDate).format("DD-MMM-YYYY")).attr('disabled', true);
                $('#txtDespatchDateTime').val(moment(getResult.DespatchDate).format("DD-MMM-YYYY HH:MM")).attr('disabled', true);
                $('#txtOwnership').val(getResult.Ownership).attr('disabled', true);
                $('#txtTotalSoiledWeight').val(getResult.Weight);
                $('#txtTotalWhiteBag').val(getResult.TotalWhiteBag).attr('disabled', true);
                $('#txtLaundryPlantFacilit').val(getResult.LaundryPlantName).attr('disabled', true);
                $('#txtTotalRedBag').val(getResult.TotalRedBag);
                $('#txtTotalGreenBag').val(getResult.TotalGreenBag);
                $('#txtTotalBrownBag').val(getResult.TotalBrownBag);
                $('#primaryID').val(getResult.SoiledLinenCollectionId);
                $('#hdnStatus').val(getResult.Active);
                //$('#hdnAttachId').val(getResult.HiddenId);
                $('#hdnAttachId').val(getResult.GuId);
                $('#myPleaseWait').modal('hide');
                $('.btnDelete').hide();              
                $('.btnEdit').hide();
                if (getResult != null && getResult.LSoiledLinenItemGridList != null && getResult.LSoiledLinenItemGridList.length > 0) {
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
//Dont remove////

//function ScheduledLinkClicked(sai) {
//    var jqxhr = $.post("/api/SoiledLinenCollection/GetBySchedule", sai, function (response) {
//        var result = JSON.parse(response);
//        $("#primaryID").val(result.SoiledLinenCollectionId);
       
         

//    },
//        "json")
//        .fail(function (response) {
//            var errorMessage = "";
//            if (response.status == 400) {
//                errorMessage = response.responseJSON;
//            }
//            else {
//                errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
//            }
//            $("div.errormsgcenter").text(errorMessage).css('visibility', 'visible');
//            $('#errorMsg').css('visibility', 'visible');
//            $('#btnAdjustmentSave').attr('disabled', false);
//            $('#btnAdjustmentEdit').attr('disabled', false);

//            $('#myPleaseWait').modal('hide');
//            $("#grid").trigger('reloadGrid');
//        });
//}
//function ScheduledClicked(sai) {
//    $.get("/api/SoiledLinenCollection/GetBy/" + sai)
//        .done(function (result) {
//            var getResult = JSON.parse(result);
//            debugger;
//            $('#txtCollectionStartTime_').val(getResult.SoiledLinenCollectionDetId).attr('disabled', true);
//            $('#txtCollectionEndTime_').val(getResult.CollectionSchedule).attr('disabled', true);
//        })
//        .fail(function () {
//            $('#myPleaseWait').modal('hide');
//            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
//            $('#errorMsg').css('visibility', 'visible');
//        });

//}

//Dont remove////
$(".btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/SoiledLinenCollection/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('SoiledLinenCollection', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                   EmptyFields();
                })
                .fail(function () {
                    showMessage('SoiledLinenCollection', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}
$("#btnNextScreenSave").click(function () {
    var primaryId = $("#primaryID").val();

    var hdnStatus = $("#hdnStatus").val();

    if (hdnStatus == 0 || hdnStatus == '0') {
        bootbox.alert('Only Active SoiledLinenCollection can be navigated to Level Screen');

    }
    else if (primaryId != null && primaryId != 0 && primaryId != "0" && primaryId != '') {
        var msg = 'Do you want to proceed to Level screen?'
        bootbox.confirm(msg, function (Conform) {
            if (Conform) {
                window.location.href = "/LLs/Level/Add/" + primaryId;
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
    $('#txtCollectionDate').val('').prop('disabled', false);
    $('#txtDespatchDateTime').val('').prop('disabled', false);
    $('#txtOwnership').val('');
    $('#txtTotalWhiteBag').val('');
    $('#txtTotalRedBag').val('');
    $('#spnActionType').text('Add');
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $('#btnSave').show();
    $('#primaryID').val('');
    $("#grid").trigger('reloadGrid');
    $("#FrmSoiled :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#txtStatus').val(1);
    $('#txtTotalSoiledWeight').val('');
    $('#txtLaundryPlantFacilit').val('null').prop('disabled', false);
    $('#txtTotalGreenBag').val('');
    $('#txtUserAreaCode_0').val('');
    $('#txtLocationCode_0').val('');
    $('#txtWeight_0').val('');
    $('#txtTotalWhiteBag_0').val('');
    $('#txtTotalRedBag_0').val('');
    $('#txtTotalGreenBag_0').val('');
    $('#txtTotalBrownBag_0').val('');
    $('#txtTotalQuantity_0').val('');
    $('#PpmCategoryId_0').val('');
    $('#txtCollectionStartTime_0').val('');
    $('#txtCollectionEndTime_0').val('');
    $('#txtCollectionTime_0').val('');
    $('#UOM_0').val('');
    $('#partno_0').val('');
    $('#txtVerifiedDateTime_0').val('');
    $('#txtRemarks_0').val('');
    $('#spnActionType').text('Add');
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $('#btnSave').show();
    $('#primaryID').val('');
    $("#grid").trigger('reloadGrid');
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
$('#contactBtn').click(function () {

    var rowCount = $('#ContactGrid tr:last').index();
    var LinenCode = $('#txtUserAreaCode_' + rowCount).val();
    var Locationcode = $('#txtLocationCode_' + rowCount).val();
    var verified  = $('#partno_' + rowCount).val();
    if (rowCount < 0)
        AddFirstGridRow();
    else if (rowCount >= "0" && (LinenCode == "" || Locationcode == "" || verified == "")) {
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
            $('#txtUserAreaCode_' + index).removeAttr('required');
            $('#txtUserAreaCode_' + index).parent().removeClass('has-error');
        }
        else {
            $('#txtUserAreaCode_' + index).attr('required', true);
            $('#chkContactDelete_' + index).prop('checked', false);
            $('#chkContactDelete_' + index).parent().removeClass('bgDelete');
        }
    });
    
});
function completion(index) {
    var x = $("#txtCollectionTime_" + index).val();
    var currentVal = moment(x, 'HH-mm');
    console.log(currentVal);
    var y = document.getElementById("txtCollectionEndTime_" + index).value;
    var value = moment(y, 'HH-mm');
    console.log(value);
    if (x > y) {
        document.getElementById("UOM_" + index).value = 10081
    }
    else {
        document.getElementById("UOM_" + index).value = 10080
    }
}

function myFunctionss(index) {
    var x = $("#txtSchedule2_" + index).val();
    var currentVal = moment(x, 'HH-mm').add(2, 'h');
    console.log(currentVal);
    if (!x) {
        ($("#txtSchedule21_" + index).val()) = x;
    } else {
        var total = currentVal.format('HH:mm')
        console.log(currentVal);
        ($("#txtSchedule21_" + index).val(total));
        console.log(currentVal);
    }



}
/////Duplicate Location Code/////////
function duplicateCheck(index) {
    var rowCount = $('#ContactGrid tr:last').index();
    var rowCount_ID = rowCount;
    allow = 0;
    for (var krows = 0; krows <= rowCount; krows++) {
        for (var krow = 0; krow <= rowCount_ID; krow++) {
            if (krows != krow) {
                var actual = $('#txtLocationCode_' + krows).val();
                var current = $('#txtLocationCode_' + krow).val()
                if (actual == current) {
                    alert("Already Exist Location Code");
                    allow = 1;
                    $('#txtUserAreaCode_' + krow).val('');
                    $('#txtLocationCode_' + krow).val('');
                    $('#partno_' + krow).val('');
                    $('#txtCollectionStartTime_' + krow).val('');
                    $('#txtCollectionEndTime_' + krow).val('');
                } else {

                    //alert("not found");
                }

            } else {
            }

        }
    }

}

////////
function Schedule(index) {
    var WhiteBag = parseInt(document.getElementById("txtTotalWhiteBag_" + index).value);
    var TotalRedBag = parseInt(document.getElementById("txtTotalRedBag_" + index).value);
    var GreenBag = parseInt(document.getElementById("txtTotalGreenBag_" + index).value);
    var BrownBag = parseInt(document.getElementById("txtTotalBrownBag_" + index).value);
    //console.log(WhiteBag);
    due = WhiteBag + TotalRedBag + GreenBag + BrownBag;
    console.log(due);
    $("#txtTotalQuantity_" + index).val(due);
    console.log(due);
}


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
var linkCliked1 = false;
window.AddFirstGridRow = function () {
    $('#chkContactDeleteAll').prop('checked', false);
    var inputpar = {
        inlineHTML: '<tr class="ng-scope" style=""> ' +
             '<td width="3%" style="text-align:center"> <input type="checkbox" value="false" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(ContactGrid,chkContactDeleteAll)" /></td>' +
            //'<td width="10%" style="text-align: center;"><div><input id="txtUserAreaCode_maxindexval" type="text" class="form-control fetchField " name="UserAreaCode" placeholder="please select"></div></td><div> ' +
            '<td width="8%" style="text-align: center;"><div><input type="text" id="txtUserAreaCode_maxindexval" name="LinenCode" maxlength="50"   onkeyup="FetchUserAreaCode(event,maxindexval)" onpaste="FetchUserAreaCode(event,maxindexval)" change="FetchUserAreaCode(event,maxindexval)" oninput="FetchUserAreaCode(event,maxindexval)"  class="form-control" autocomplete="off" tabindex="0" required  placeholder="Please Select"><input type="hidden" id="LinenCodeId_maxindexval" required/><div class="col-sm-12" id="divLinenCodeFetch_maxindexval"></div > </div></td> <div> ' +
            '<td width="8%" style="text-align: center;"><div><input type="text" id="txtLocationCode_maxindexval" name="LocationCode" maxlength="50"   onkeyup="FetchUserLocationCode(event,maxindexval)" onpaste="FetchUserLocationCode(event,maxindexval)" change="FetchUserLocationCode(event,maxindexval)"oninput="FetchUserLocationCode(event,maxindexval)"  class="form-control" autocomplete="off" tabindex="0" required  placeholder="Please Select"><input type="hidden" id="LocationCodeId_maxindexval" required/><input type="hidden" id="LocationCodeUpdateDetId_maxindexval"/><input type="hidden" id="SoiledLinenCollectionDetId_maxindexval"/><div class="col-sm-12" id="divLocationCodeFetch_maxindexval"></div > </div></td></td> <div> ' +
            '<td width="8%" style="text-align: center;"><div><input type="text" onblur="duplicateCheck(maxindexval)" id="partno_maxindexval" name="partno" maxlength="50"  onkeyup="verifiedBy(event,maxindexval)" onpaste="verifiedBy(event,maxindexval)" change="verifiedBy(event,maxindexval)" oninput="verifiedBy(event,maxindexval)" class="form-control" class="form-control" autocomplete="off" placeholder="Please Select" required><input type="hidden" id="SparePartsId_maxindexval" required/><div class="col-sm-12" id="divFetch2_maxindexval"></div></div></td><div> ' +
            '<td width="7%" style="text-align: center;"><div><input id="txtVerifiedDateTime_maxindexval" type="text" class="form-control datatimepicker" name="VerifiedDateTime" ></div></td><div> ' +
            '<td width="4%" style="text-align: center;"><div><input id="txtWeight_maxindexval" type="text" class="form-control fetchField"  name="Weight" ></div></td><div> ' +
            '<td width="4%" style="text-align: center;"><div><input id="txtTotalWhiteBag_maxindexval" type="text" class="form-control"  name="TotalWhiteBag"></div></td><div> ' +
            '<td width="4%" style="text-align: center;"><div><input id="txtTotalRedBag_maxindexval" type="text" class="form-control"  name="TotalRedBag"></div></td><div> ' +
            '<td width="4%" style="text-align: center;"><div><input id="txtTotalGreenBag_maxindexval" onblur="Schedule(maxindexval)" type="text" class="form-control"  name="TotalGreenBag" ></div></td><div> ' +
            '<td width="4%" style="text-align: center;"><div><input id="txtTotalBrownBag_maxindexval" onblur="Schedule(maxindexval)" type="text" class="form-control"  name="TotalBrownBag" ></div></td><div> ' +
            '<td width="4%" style="text-align: center;"><div><input id="txtTotalQuantity_maxindexval"   type="text" class="form-control" name="TotalQuantity" disabled></div></td><div> ' +
            //'<td width="10%" style="text-align: center;"><div><select id="txtCollectionSchedule_maxindexval" type="text" class="form-control  " name="CollectionSchedule"></select></div></td><div> ' +
            '<td width="6%" style="text-align: center;"><div><select id="PpmCategoryId_maxindexval" onchange="changeFunc(maxindexval)" name="txtDefaultIssue" required class="form-control" ><option value="null">Select</option> </select><div> </td> <div> ' +
            '<td width="8%" style="text-align: center;"><div><input type="time" min="00:00" max="23:59" id="txtCollectionStartTime_maxindexval" type="text" class="form-control" name="CollectionStartTime" disabled></div></td><div> ' +
            '<td width="8%" style="text-align: center;"><div><input type="time" min="00:00" max="23:59" id="txtCollectionEndTime_maxindexval" type="text" class="form-control" name="CollectionEndTime" disabled></div></td><div> ' + 
            '<td width="8%" style="text-align: center;"><div><input type="time" min="00:00" max="23:59" id="txtCollectionTime_maxindexval" onchange="completion(maxindexval)" type="text" class="form-control" name="CollectionTime" required></div></td><div>'+
            '<td width="6%" style="text-align: center;" title=""> <div> <select id="UOM_maxindexval"  name="Linenschudule"  class="form-control" required disabled><option value="0">Select</option></select> </div></td></td> <div> ' +
            '<td width="6%" style="text-align: center;"><div><input id="txtRemarks_maxindexval" type="text" class="form-control  " name="Remarks"></div></td><div></tr>',

        IdPlaceholderused: "maxindexval",
        TargetId: "#ContactGrid",
        TargetElement: ["tr"]
    }
   
    AddNewRowToDataGrid(inputpar);
    var rowCount = $('#ContactGrid tr:last').index();
    $.each(window.CategoryListGloabal, function (index, value) {
        $('#PpmCategoryId_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
    var rowCount = $('#ContactGrid tr:last').index();
    $.each(window.OnTime, function (index, value) {
        $('#UOM_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
    
    $("input[id^='txtUserAreaCode_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtLocationCode_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    //$("input[id^='txtWeight_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtTotalWhiteBag_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtTotalRedBag_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtTotalGreenBag_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtTotalBrownBag_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtTotalQuantity_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtCollectionSchedule_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtCollectionStartTime_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtCollectionEndTime_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    //$("input[id^='txtCollectionTime_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtOnTime_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='partno_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    //$("input[id^='txtVerifiedDateTime_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtRemarks_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');

    
    if (!linkCliked1) {
        $('#ContactGrid tr:last td:first input').focus();
    }
    else {
        linkCliked1 = false;
    }
    
    formInputValidation("FrmSoiled");

}