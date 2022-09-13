$(document).ready(function () {

    $('#myPleaseWait').modal('show');
    $('.btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $.get("/api/LinenInventory/Load")
        .done(function (result) {

            var loadResult = JSON.parse(result);
            $.each(loadResult.StoreType, function (index, value) {
                $('#txtStoreType').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $('#divUserAreaDept').show();
            $('#btntwo').hide();
            $('#contactBtn').show();
            $('#UserAreaIdName').hide();

            $('#divCleanCenterLinenStore').hide();
            AddFirstGridRow();
            AddFirstGridRows();

        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });
});


var UserAreaFetchObj = {
    SearchColumn: 'txtUserAreaCode-UserAreaCode',//Id of Fetch field
    ResultColumns: ["LLSUserAreaId-Primary Key", 'UserAreaCode-UserAreaCode', 'UserAreaName-UserAreaName'],
    FieldsToBeFilled: ["hdnUserAreaId-LLSUserAreaId", "txtUserAreaCode-UserAreaCode", "txtUserAreaName-UserAreaName"]
};

$('#txtUserAreaCode').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divUserAreaFetch', UserAreaFetchObj, "/api/Fetch/Cleanlinenrequest_UserareaCodeFetch", "UlFetch", event, 1);//1 -- pageIndex
});


function FetchPartNodataStockAdjustment(event, index) {
    $('#divFetch_' + index).css({
        'top': $('#partno_' + index).offset().top - $('#ppmchecklistTable').offset().top + $('#partno_' + index).innerHeight(),
    });
    var StockAdjustmentFetchObj = {
        SearchColumn: 'partno_' + index + '-UserLocationCode',    //Id of Fetch field
        ResultColumns: ["LLSUserAreaLocationId" + "-Primary Key", 'UserLocationCode' + '-partno_' + index],
        FieldsToBeFilled: ["hdnStkAdjustmentId_" + index + "-LLSUserAreaLocationId", 'partno_' + index + '-UserLocationCode', 'partdesc_' + index + '-UserLocationName', 'UOM_' + index + '-UOM']//id of element - the model property
    };
    var UserAreaId = $('#hdnUserAreaId').val();
    DisplayLocationCodeFetchResult('divFetch_' + index, StockAdjustmentFetchObj, "/api/Fetch/CleanLinenRequestTxn_FetchLocCode", "UlFetch5" + index, event, 1, UserAreaId);

}

var HospitalRepFetchObj = {
    SearchColumn: 'txtHospitalRepresentative-StaffName',//Id of Fetch field
    ResultColumns: ["UserRegistrationId-Primary Key", 'StaffName-ReceivedBy'],
    FieldsToBeFilled: ["hdnHospitalRepresentativeId-UserRegistrationId", "txtHospitalRepresentative-StaffName", "txtHospitalRepresentativeDesignation-StaffName"]
};

$('#txtHospitalRepresentative').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divHospitalRepresentativeFetch', HospitalRepFetchObj, "/api/Fetch/LLSLinenInventoryTxn_FetchVerifiedBy", "UlFetch1", event, 1);//1 -- pageIndex
});

function FetchUserLocationCode(event, index) {
    $('#divLocationCodeFetch_' + index).css({
        'top': $('#txtLocationCode_' + index).offset().top - $('#SolidLinenProvider').offset().top + $('#txtLocationCode_' + index).innerHeight(),
    });
    var LinenFetchObj = {
        SearchColumn: 'txtLocationCode_' + index + '-UserLocationCode',//Id of Fetch field
        ResultColumns: ["LLSUserAreaLocationId-Primary Key", 'UserLocationCode' + '-txtLocationCode_' + index],
        FieldsToBeFilled: ["LocationCodeId_" + index + "-LLSUserAreaLocationId", 'txtLocationCode_' + index + '-UserLocationCode']
    };
    var User = document.getElementById('txtUserAreaCode_' + index).value;
    DisplayLocationCodeFetchResult('divLocationCodeFetch_' + index, LinenFetchObj, "/api/Fetch/SoiledLinenCollectionTxnDet_FetchLocCode", "UlFetch2" + index + "", event, 1, User);//1 -- pageIndex
}

$(".btnSave,.btnSaveAddNew,#btnSaveandAddNew").click(function () {
    $('#btnlogin').attr('disabled', true);
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');

    //if (this.value == 10172) {
    //    $('#txtStoreType').attr('required', true);
    //    $('#txtDate').attr('required', true);
    //    $('#txtUserAreaCode').attr('required', true);
    //    $('#txtHospitalRepresentative').attr('required', true);
    //    $('#txtLinenCode_').attr('required', true);

    //}
    //else {
    //    $('#txtStoreType').attr('required', true);
    //    $('#txtDate').attr('required', true);
    //    $('#txtHospitalRepresentative').attr('required', true);
    //    $('#txtLocationCode_').attr('required', true);

    //}

    var CurrentbtnID = $(this).attr("value");
    var timeStamp = $("#Timestamp").val();

    //first grid 

    var _index;        // var _indexThird;
    var result = [];
    var _StoreType = $('#txtStoreType').val();
    if (_StoreType == '10172') {
        $('#ContactGrid tr').each(function () {
            _index = $(this).index();
        });
    }
    else {
        $('#contact tr').each(function () {
            _index = $(this).index();
        });

    }

    for (var i = 0; i <= _index; i++) {
        var active = true;
        var isDeletedcat = $('#IsDeletedCategory_' + i).prop('checked');
        var StoreType = $('#txtStoreType').val();
        var LinenFetch = '';
        if (StoreType == '10171') {
            LinenFetch = '#LocationCodeId_'
        }
        else {
            LinenFetch = '#LinenCodeId_'
        }
        var _tempObj = {
            LinenInventoryId: $('#LinenInventoryId_' + i).val(),
            LlsLinenInventoryTxnDetId: $('#LinenCodeUpdateDetId_' + i).val(),
            LinenItemId: $(LinenFetch + i).val(),
            LinenCode: $('#txtLinenCode_' + i).val(),
            LLSUserAreaLocationId: $('#hdnStkAdjustmentId_' + i).val(),
            LocationCode: $('#partno_' + i).val(),
            LinenDescription: $('#txtLinenDescription_' + i).val(),
            InUse: $('#txtInUse_' + i).val(),
            Shelf: $('#txtShelf_' + i).val(),
            TotalPcs: $('#txtTotalPcs_' + i).val(),

            CCLSLinenCode: $('#txtLocationCode_' + i).val(),
            CCLSLinenDescription: $('#txtLinen_' + i).val(),
            CCLSInUse: $('#txtInUsee_' + i).val(),
            CCLSShelf: $('#txtShelff_' + i).val(),
            TotalPcsA: $('#txtTotalPcsA_' + i).val(),
            TotalPcsB: $('#txtUserDepartAreaB_' + i).val(),
            TotalPcsAB: $('#txtTotalPcsA_B_' + i).val(),
            StoreBalance: $('#txtCCLSStoreBalance_' + i).val(),
            Variance: $('#txtVariance_' + i).val(),
            IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
            IsDelete: chkIsDeletedRow1(i, $('#Isdelete_' + i).is(":checked")),
        }
        result.push(_tempObj);
    }
    var timeStamp = $("#Timestamp").val();
    var MstLinenInventory = {
        StoreType: $('#txtStoreType').val(),
        DocumentNo: $('#txtDocumentNo').val(),
        Date: $('#txtDate').val(),
        //UserAreaId: $('#txtUserAreaCode').val(),
        LLSUserAreaId: $('#hdnUserAreaId').val(),
        VerifiedById: $('#hdnHospitalRepresentativeId').val(),
        TotalPcs: $('#txtTotalPcs').val(),
        TotalInUse: $('#txtTotalatCleanLinenStore').val(),
        TotalShelf: $('#txtTotalSoiled').val(),
        // UserAreaId: $('#txtUserAreaId').val(),
        Remarks: $('#txtRemarks').val(),
        LLinenInventoryLinenItemListGrid: result,
        LLinenInventoryCCLSListGrid: result

    };
    if (StoreType == '10171') {
        MstLinenInventory.LLinenInventoryLinenItemListGrid = null;
        $('#partno_').attr('required', false);
        $('#txtLinenCode_').attr('required', true);
        $('#LinenCodeId_').attr('required', false);
        $('#hdnStkAdjustmentId_').attr('required', false);

        $('#contact tr').each(function (index, value) {
            
            $('#txtLocationCode_' + index).prop('required', true);
            $('#LocationCodeId_' + index).prop('required', true);
           
        });
        $('#ContactGrid tr').each(function (index, value) {

            $('#partno_' + index).prop('required', false);
            $('#txtLinenCode_' + index).prop('required', false);

        });
    }
    else {
        MstLinenInventory.LLinenInventoryCCLSListGrid = null;
        $('#txtUserAreaCode').attr('required', true);
        $('#hdnUserAreaId').attr('required', true);
        $('#txtDate').attr('required', true);
        $('#hdnStkAdjustmentId_').attr('required', true);
        $('#LinenCodeId_').attr('required', true);

        //$('#partno_').prop("required", true);
        $('#ContactGrid tr').each(function (index, value) {

            $('#partno_' + index).prop('required', true);
            $('#txtLinenCode_' + index).prop('required', true);
            $('#hdnStkAdjustmentId_' + index).prop('required', true);
            $('#LinenCodeId_' + index).prop('required', true);
        });

        $('#contact tr').each(function (index, value) {

            $('#txtLocationCode_' + index).prop('required', false);

        });
    }
    var isFormValid = formInputValidation("FrmINV", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }

    function chkIsDeletedRow(i, delrec) {
        if (delrec == true) {
            $('#LinenCodeId_' + i).prop("required", false);
            $('#txtLinenCode_' + i).prop("required", false);
            $('#txtLinenDescription_' + i).prop("required", false);
            $('#txtInUse_' + i).prop("required", false);
            $('#txtShelf_' + i).prop("required", false);
            $('#txtTotalPcs_' + i).prop("required", false);
            $('#partno_' + i).prop("required", false);
            //$('#txtLinen_' + i).prop("required", false);
            //$('#txtInUsee_' + i).prop("required", false);
            //$('#txtShelff_' + i).prop("required", false);
            //$('#txtTotalPcsA_' + i).prop("required", false);
            //$('#txtUserDepartAreaB_' + i).prop("required", false);
            //$('#txtTotalPcsA_B_' + i).prop("required", false);
            //$('#txtCCLSStoreBalance_' + i).prop("required", false);
            //$('#txtVariance_' + i).prop("required", false);
            return true;
        }
        else {
            return false;
        }
    }

    function chkIsDeletedRow1(i, delrec) {
        if (delrec == true) {
            //$('#LinenCodeId_' + i).prop("required", false);
            //$('#txtLinenCode_' + i).prop("required", false);
            //$('#txtLinenDescription_' + i).prop("required", false);
            //$('#txtInUse_' + i).prop("required", false);
            //$('#txtShelf_' + i).prop("required", false);
            //$('#txtTotalPcs_' + i).prop("required", false);
            $('#txtLocationCode_' + i).prop("required", false);
            $('#txtLinen_' + i).prop("required", false);
            $('#txtInUsee_' + i).prop("required", false);
            $('#txtShelff_' + i).prop("required", false);
            $('#txtTotalPcsA_' + i).prop("required", false);
            $('#txtUserDepartAreaB_' + i).prop("required", false);
            $('#txtTotalPcsA_B_' + i).prop("required", false);
            $('#txtCCLSStoreBalance_' + i).prop("required", false);
            $('#txtVariance_' + i).prop("required", false);
            return true;
        }
        else {
            return false;
        }
    }

    var primaryId = $("#primaryID").val();
    if (primaryId != null) {
        MstLinenInventory.LinenInventoryId = primaryId;
        MstLinenInventory.Timestamp = timeStamp;
    }
    else {
        MstLinenInventory.LinenInventoryId = 0;
        MstLinenInventory.Timestamp = "";
    }
    var jqxhr = $.post("/api/LinenInventory/Save", MstLinenInventory, function (response) {
        var result = JSON.parse(response);
        $("#primaryID").val(result.LinenInventoryId);
        $("#Timestamp").val(result.Timestamp);
        // $('#blockName').val(result.BlockName);
        //$('#blockFacilityId').val(result.FacilityId);
        $('#SelStatus option[value="' + result.Active + '"]').prop('selected', true);
        $('#hdnStatus').val(result.Active);
        if (result != null && result.LLinenInventoryLinenItemListGrid != null && result.LLinenInventoryLinenItemListGrid.length > 0) {
            BindSecondGridData(result);
        }
        if (result != null && result.LLinenInventoryCCLSListGrid != null && result.LLinenInventoryCCLSListGrid.length > 0) {
            BindGridData(result);
        }
        $("#grid").trigger('reloadGrid');
        if (result.LinenInventoryId != 0) {
            $('#txtDocumentNo').val(result.DocumentNo);
            if (result.StoreType == '10171') {
                $('#txtTotalPcs').val(result.TotalPcs);
            }
            else {
                $('#txtTotalPcs').val(result.TotalPcs);
            }
            $('#txtTotalSoiled').val(result.TotalShelf);
            $('#txtTotalatCleanLinenStore').val(result.TotalInUse);
            $('#hdnAttachId').val(result.HiddenId);

            $('#btnNextScreenSave').hide();
            $('#btnEdit').show();
            $('#btnSave').hide();
            $('.btnDelete').show();
            $('#txtStoreType').prop('disabled', true);
            $('#txtDate').prop('disabled', true);
            $('#txtUserAreaCode').prop('disabled', true);
            $('.btnSaveAddNew').hide();
            $('.btnDelete').hide(); 
        }
        $(".content").scrollTop(0);
        showMessage('LinenInventory', CURD_MESSAGE_STATUS.SS);
        $("#top-notifications").modal('show');
        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);

        $('#btnSave').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        if (CurrentbtnID == "1") {
            EmptyFields();
            $('#txtDate').prop('disabled', false);
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

function compute1(index) {
    var a = $("#txtInUse_" + index).val();
    if (a.length > 0) {
        a = parseInt(a);
    }
    else
        a = 0;
    var b = $("#txtShelf_" + index).val();
    if (b.length > 0) {
        b = parseInt(b);
    } else
        b = 0;
    var total = a + b;
    $("#txtTotalPcs_" + index).val(total);
}
function compute(index) {
    var a = $("#txtTotalPcsA_" + index).val();
    if (a.length > 0) {
        a = parseInt(a);
    }
    else
        a = 0;
    var b = $("#txtUserDepartAreaB_" + index).val();
    if (b.length > 0) {
        b = parseInt(b);
    } else
        b = 0;
    var total = a + b;
    $("#txtTotalPcsA_B_" + index).val(total);
}
function compute2(index) {
    var a = $("#txtInUsee_" + index).val();
    if (a.length > 0) {
        a = parseInt(a);
    }
    else
        a = 0;
    var b = $("#txtShelff_" + index).val();
    if (b.length > 0) {
        b = parseInt(b);
    } else
        b = 0;
    var total = a + b;
    $("#txtTotalPcsA_" + index).val(total);
}

function CalculateVarience(index) {
    console.log(index);
    var RequestedQuantity = parseFloat($('#txtDespatched_' + index).val());
    var FirstDeliver = parseFloat($('#txtRecievedQuantity_' + index).val());
    var SecondDeliver = parseFloat($('#txtVariance_' + index).val());



    Total = RequestedQuantity - FirstDeliver;
    $('#txtTotaReceived').val(FirstDeliver);
    if (RequestedQuantity != "") {
        console.log(Total);
        $('#txtVariance_' + index).val(Total);
    }



}

function FetchLinenCode(event, index) {
    $('#divLinenCodeFetch_' + index).css({
        'top': $('#txtLinenCode_' + index).offset().top - $('#ppmchecklistTable').offset().top + $('#txtLinenCode_' + index).innerHeight(),
    });
    var LinenFetchObj = {
        SearchColumn: 'txtLinenCode_' + index + '-LinenCode',//Id of Fetch field
        ResultColumns: ["LinenItemId-Primary Key", 'LinenCode' + '-txtLinenCode_' + index],
        //AdditionalConditions: ["LinenItemId-" + index +"LinenCodeId_"],
        FieldsToBeFilled: ["LinenCodeId_" + index + "-LinenItemId", 'txtLinenCode_' + index + '-LinenCode', 'txtLinenDescription_' + index + '-LinenDescription']
    };
    var UserAreaId = document.getElementById('partno_' + index).value;
  //  var UserAreaId = $('#txtLocationCode_' + index).val();
    DisplayLocationCodeFetchResult('divLinenCodeFetch_' + index, LinenFetchObj, "/api/Fetch/LLSLinenInventoryTxnDet_FetchLinenCodeUserArea", "UlFetch2" + index, event, 1, UserAreaId);//1 -- pageIndex
}

function FetchLocationCode(event, index) {

    $('#divLocationCodeFetch_' + index).css({
        'top': $('#txtLocationCode_' + index).offset().top - $('#LinenINVProviders').offset().top + $('#txtLocationCode_' + index).innerHeight(),
    });
    var LocationFetchObj = {
        SearchColumn: 'txtLocationCode_' + index + '-LinenCode',//Id of Fetch field
        ResultColumns: ["LinenItemId-Primary Key", 'LinenCode' + '-txtLocationCode_' + index, 'LinenDescription' + '-txtLinen' + index],
        FieldsToBeFilled: ["LocationCodeId_" + index + "-LinenItemId", 'txtLocationCode_' + index + '-LinenCode', 'txtLinen_' + index + '-LinenDescription']
    };
    DisplayFetchResult('divLocationCodeFetch_' + index, LocationFetchObj, "/api/Fetch/LLSLinenInventoryTxnDet_FetchLinenCode", "UlFetch4" + index, event, 1);//1 -- pageIndex
}


//************************************************ Getbyid bind data *************************

function BindSecondGridData(getResult) {
    var ActionType = $('#ActionType').val();
    $("#ContactGrid").empty();
    $.each(getResult.LLinenInventoryLinenItemListGrid, function (index, value) {
        AddFirstGridRow();
        $("#LinenCodeUpdateDetId_" + index).val(getResult.LLinenInventoryLinenItemListGrid[index].LlsLinenInventoryTxnDetId);
        $("#LinenInventoryId_" + index).val(getResult.LLinenInventoryLinenItemListGrid[index].LinenInventoryId);
        $("#LinenCodeId_" + index).val(getResult.LLinenInventoryLinenItemListGrid[index].LinenItemId);
        $("#hdnStkAdjustmentId_" + index).val(getResult.LLinenInventoryLinenItemListGrid[index].LLSUserAreaLocationId);
        $("#LLSUserAreaLocationId_" + index).val(getResult.LLinenInventoryLinenItemListGrid[index].LLSUserAreaLocationId);
        $("#partno_" + index).attr('title', getResult.LLinenInventoryLinenItemListGrid[index].LocationCode);
        $("#partno_" + index).val(getResult.LLinenInventoryLinenItemListGrid[index].LocationCode).prop("disabled", "disabled");
        //$("#LocationCodeId_" + index).val(getResult.LLinenInventoryLinenItemListGrid[index].LinenItemId);
        $("#txtLinenCode_" + index).val(getResult.LLinenInventoryLinenItemListGrid[index].LinenCode);
        $("#txtLinenDescription_" + index).val(getResult.LLinenInventoryLinenItemListGrid[index].LinenDescription);
        $("#txtInUse_" + index).val(getResult.LLinenInventoryLinenItemListGrid[index].InUse);
        $("#txtShelf_" + index).val(getResult.LLinenInventoryLinenItemListGrid[index].Shelf);
        $("#txtTotalPcs_" + index).val(getResult.LLinenInventoryLinenItemListGrid[index].UserAreaTotalPcs);
        linkCliked2 = true;
        $(".content").scrollTop(0);
    });
    //************************************************ Grid Pagination *******************************************

    if ((getResult.LLinenInventoryLinenItemListGrid && getResult.LLinenInventoryLinenItemListGrid.length) > 0) {
        GridtotalRecords = getResult.LLinenInventoryLinenItemListGrid[0].TotalRecords;
        TotalPages = getResult.LLinenInventoryLinenItemListGrid[0].TotalPages;
        LastRecord = getResult.LLinenInventoryLinenItemListGrid[0].LastRecord;
        FirstRecord = getResult.LLinenInventoryLinenItemListGrid[0].FirstRecord;
        pageindex = getResult.LLinenInventoryLinenItemListGrid[0].PageIndex;
        linkCliked2 = true;
        $(".content").scrollTop(0);
    }
    $('#paginationfooter').show();


    //************************************************ End *******************************************************
}
function BindGridData(getResult) {
    var ActionType = $('#ActionType').val();
    $("#contact").empty();
    $.each(getResult.LLinenInventoryCCLSListGrid, function (index, value) {
        AddFirstGridRows();
        $("#LinenCodeUpdateDetId_" + index).val(getResult.LLinenInventoryCCLSListGrid[index].LlsLinenInventoryTxnDetId);
        $("#LinenInventoryId_" + index).val(getResult.LLinenInventoryCCLSListGrid[index].LinenInventoryId);
        $("#LocationCodeId_" + index).val(getResult.LLinenInventoryCCLSListGrid[index].LinenItemId);
        $("#txtLocationCode_" + index).val(getResult.LLinenInventoryCCLSListGrid[index].LinenCode);
        $("#txtLinen_" + index).val(getResult.LLinenInventoryCCLSListGrid[index].LinenDescription);
        $("#txtInUsee_" + index).val(getResult.LLinenInventoryCCLSListGrid[index].CCLSInUse);
        $("#txtShelff_" + index).val(getResult.LLinenInventoryCCLSListGrid[index].CCLSShelf);
        $("#txtTotalPcsA_" + index).val(getResult.LLinenInventoryCCLSListGrid[index].CCLSTotalPcs);
        $("#txtUserDepartAreaB_" + index).val(getResult.LLinenInventoryCCLSListGrid[index].TotalPcsB);
        $("#txtTotalPcsA_B_" + index).val(getResult.LLinenInventoryCCLSListGrid[index].TotalPcsAB);
        $("#txtCCLSStoreBalance_" + index).val(getResult.LLinenInventoryCCLSListGrid[index].StoreBalance);
        $("#txtVariance_" + index).val(getResult.LLinenInventoryCCLSListGrid[index].Variance);

        linkCliked1 = true;
        $(".content").scrollTop(0);
    });
    //**
    if ((getResult.LLinenInventoryCCLSListGrid && getResult.LLinenInventoryCCLSListGrid.length) > 0) {
        GridtotalRecords = getResult.LLinenInventoryCCLSListGrid[0].TotalRecords;
        TotalPages = getResult.LLinenInventoryCCLSListGrid[0].TotalPages;
        LastRecord = getResult.LLinenInventoryCCLSListGrid[0].LastRecord;
        FirstRecord = getResult.LLinenInventoryCCLSListGrid[0].FirstRecord;
        pageindex = getResult.LLinenInventoryCCLSListGrid[0].PageIndex;
        linkCliked1 = true;
        $(".content").scrollTop(0);
    }
    $('#paginationfooter').show();
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
function LinkClicked(LinenInventoryId) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#FrmINV :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(LinenInventoryId);
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
        $("#FrmINV :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/LinenInventory/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                $('#txtStoreType').val(getResult.StoreType).attr("disabled", true);
                if (getResult.StoreType == 10172) {
                    $('#UserAreaIdName').show();
                }
                else {
                    $('#UserAreaIdName').hide();
                }
                $('#txtDocumentNo').val(getResult.DocumentNo);
                $('#txtDate').val(moment(getResult.Date).format("DD-MMM-YYYY")).attr("disabled", true);
                $('#txtUserAreaCode').val(getResult.UserAreaCode).attr("disabled", true);
                $('#txtUserAreaName').val(getResult.UserAreaName).attr("disabled", true);
                $('#txtHospitalRepresentative').val(getResult.VerifiedBy);
                $('#hdnHospitalRepresentativeId').val(getResult.VerifiedById);
                $('#txtTotalPcs').val(getResult.TotalPcs);
                $('#hdnUserAreaId').val(getResult.LLSUserAreaId);
                $('#txtTotalSoiled').val(getResult.TotalShelf);
                $('#txtTotalatCleanLinenStore').val(getResult.TotalInUse);
                $('#txtRemarks').val(getResult.Remarks);
                //$('#txtLocationCode_').val(getResult.LinenCode);
                //$('#txtLinenDescription_').val(getResult.LinenDescription);
                //$('#txtInUse_').val(getResult.CCLSInUse);
                //$('#txtShelf_').val(getResult.CCLSShelf);
                //$('#txtInUse_0').val(getResult.InUse);
                //$('#txtShelf_0').val(getResult.Shelf);
                //$('#txtTotalPcsA_').val(getResult.TotalpcsA);
                //$('#txtUserDepartAreaB_').val(getResult.TotalpcsB);
                //$('#txtTotalPcsA_B_').val(getResult.TotalPcs);
                //$('#txtVariance_').val(getResult.StoreBalance);
                $('#hdnStatus').val(getResult.Active);
                $('#hdnAttachId').val(getResult.HiddenId);
                 
                $('.btnSaveAddNew').hide();
                $('.btnDelete').hide(); 
                $('#myPleaseWait').modal('hide');

                if (getResult != null && getResult.LLinenInventoryCCLSListGrid != null && getResult.LLinenInventoryCCLSListGrid.length > 0) {
                    BindGridData(getResult);
                    $('#divUserAreaDept').hide();
                    $('#divCleanCenterLinenStore').show();

                }
               
                if (getResult != null && (getResult.LLinenInventoryLinenItemListGrid != null) &&( getResult.LLinenInventoryLinenItemListGrid.length > 0)) {
                    BindSecondGridData(getResult);
                    $('#divUserAreaDept').show();
                    $('#divCleanCenterLinenStore').hide();
                }

                if (getResult.StoreType == 10171) {
                    $('#contactBtn').hide();
                    $('#btntwo').show();
                }
                else {
                    $('#contactBtn').show();
                    $('#btntwo').hide();
                }
            })
       
        $(".btnDelete").show()
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
            $.get("/api/LinenInventory/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('LinenInventory', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('LinenInventory', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}
$("#btnNextScreenSave").click(function () {
    var primaryId = $("#primaryID").val();

    var hdnStatus = $("#hdnStatus").val();

    if (hdnStatus == 0 || hdnStatus == '0') {
        bootbox.alert('Only Active LinenInventory can be navigated to Level Screen');

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
    $('#contact').empty();
    $(".content").scrollTop(0);
    $('#hdnAttachId').val('');
    $('.btnDelete').hide();
    $('#txtStoreType').val('null').prop('disabled', false);
    $('#txtDocumentNo').val('');
    $('#txtDate').val('').attr("disabled", false);
    $('#txtVerifiedBy').val('');
    $('#txtTotalPcs').val('');
    $('#txtLocationCode_').val('');
    $('#txtLinen_').val('');
    $('#txtInUsee_').val('');
    $('#txtHospitalRepresentative').val('');
    $('#txtTotalSoiled').val('');
    $('#txtTotalatCleanLinenStore').val('');
    $('#txtUserAreaId').val('');
    $('#txtRemarks').val('');
    $('#txtUserAreaCode').val('');
    $('#spnActionType').text('Add');
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $('#btnSave').show();
    $('#primaryID').val('');
    $("#grid").trigger('reloadGrid');
    $("#FrmINV :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#SelStatus').val(1);
    AddFirstGridRow();
    AddFirstGridRows();
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
    // AddFirstGridRows();
    else if (rowCount >= "0" && (LinenCode == "")) {
        bootbox.alert("Please fill the last record");
    }
    else {
        AddFirstGridRow();
        // AddFirstGridRows();
    }
});
$("#chk_FacWorkIsDelete").change(function () {
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
$("#chk_FacWorkIsDeleted").change(function () {
    var Isdeletebool = this.checked;

    if (this.checked) {
        $('#contact tr').map(function (i) {
            if ($("#Isdelete_" + i).prop("disabled")) {
                $("#Isdelete_" + i).prop("checked", false);
            }
            else {
                $("#Isdelete_" + i).prop("checked", true);
            }
        });
    } else {
        $('#contact tr').map(function (i) {
            $("#Isdeleted_" + i).prop("checked", false);
        });
    }
});
var linkCliked1 = false;
window.AddFirstGridRow = function () {
    $('#chkContactDeleteAll').prop('checked', false);
    var inputpar = {
        inlineHTML: '<tr class="ng-scope" style="">'+
            '<td width="5%" style="text-align:center"> <input type="checkbox" onchange="IsDeleteCheckAll(ContactGrid,chk_FacWorkIsDelete)" id="Isdeleted_maxindexval" tabindex="0"></td>'+
            '<td width="20%" style="text-align: center;"><div> <input type="text" id="partno_maxindexval" value="" placeholder="Please Select" onkeyup="FetchPartNodataStockAdjustment(event,maxindexval)" onpaste="FetchPartNodataStockAdjustment(event,maxindexval)"change="FetchPartNodataStockAdjustment(event,maxindexval)"oninput="FetchPartNodataStockAdjustment(event,maxindexval)" class="form-control" maxlength="25" ><input type="hidden" id="SparePartsId_maxindexval" /><input type="hidden" id="hdnStkAdjustmentId_maxindexval" /><input type="hidden" id="LLSUserAreaLocationId_maxindexval" /><div class="col-sm-12" id="divFetch_maxindexval"></div></div></td >' +
            '<td width="20%" style="text-align: center;"><div><input type="text" id="txtLinenCode_maxindexval" name="LinenCode" maxlength="50"   onkeyup="FetchLinenCode(event,maxindexval)" onpaste="FetchLinenCode(event,maxindexval)" change="FetchLinenCode(event,maxindexval)"oninput="FetchLinenCode(event,maxindexval)"  class="form-control" autocomplete="off" tabindex="0"   placeholder="Please Select"><input type="hidden" id="LinenCodeId_maxindexval" /><input type="hidden" id="LinenCodeUpdateDetId_maxindexval"/> <div class="col-sm-12" id="divLinenCodeFetch_maxindexval"></div > </div></td>< td width="15%" style="text-align: center;" > <div> ' +
            '<td width="20%" style="text-align: center;"><div><input type="text" id="txtLinenDescription_maxindexval" name="LinenDescription" maxlength="50"  class="form-control" autocomplete="off"  tabindex="0" disabled ></div></td><div>'+
           // <input type="text" id="partno_maxindexval" value="" placeholder="Please Select" onkeyup="FetchPartNodataStockAdjustment(event,maxindexval)" onpaste="FetchPartNodataStockAdjustment(event,maxindexval)" change="FetchPartNodataStockAdjustment(event,maxindexval)" oninput="FetchPartNodataStockAdjustment(event,maxindexval)" class="form-control" maxlength="25" required> <input type="hidden" id="SparePartsId_maxindexval" /> <input type="hidden" id="hdnStkAdjustmentId_maxindexval" /><input type="hidden" id="LLSUserAreaLocationId_maxindexval" /><div class="col-sm-12" id="divFetch_maxindexval"></div></div></td> <td width="7%" style="text-align: center;" title=""> 
          //  '<td width="20%" style="text-align: center;"><div> <input type="text" id="partno_maxindexval" value="" placeholder="Please Select" onkeyup="FetchPartNodataStockAdjustment(event,maxindexval)" onpaste="FetchPartNodataStockAdjustment(event,maxindexval)"change="FetchPartNodataStockAdjustment(event,maxindexval)"oninput="FetchPartNodataStockAdjustment(event,maxindexval)" class="form-control" maxlength="25" ><input type="hidden" id="SparePartsId_maxindexval" /><input type="hidden" id="hdnStkAdjustmentId_maxindexval" /><input type="hidden" id="LLSUserAreaLocationId_maxindexval" /><div class="col-sm-12" id="divFetch_maxindexval"></div></div></td >'+
            //'<td width="20%" style="text-align: center;"><div><input type="text" id="txtLocation_maxindexval" name="Locationname" maxlength="50" class="form-control" value="" placeholder="Please Select" onkeyup="FetchPartNodataStockAdjustment(event,maxindexval)" onpaste="FetchPartNodataStockAdjustment(event,maxindexval)" change="FetchPartNodataStockAdjustment(event,maxindexval) /*" oninput="FetchPartNodataStockAdjustment(event,maxindexval)" */class="form-control" ></div><div class="col-sm-12" id="divFetch_maxindexval"><input type="hidden" id="hdnStkAdjustmentId_maxindexval"/></div></td><div>' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtInUse_maxindexval" name="TotalatCentralCleanLinenStore" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" onblur="compute1(maxindexval)" ></div></td><div>'+
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtShelf_maxindexval" name="txtTotalSoiled" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"  onblur="compute1(maxindexval)"></div></td><div>'+
            '<td width="15%" style="text-align: center;"><div><input type="text" id="txtTotalPcs_maxindexval"  name="txtStainedbyChemical" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" disabled ></div></td><div></tr>',
        IdPlaceholderused: "maxindexval",
        TargetId: "#ContactGrid",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    //$("input[id^='txtGeneratedDemerit_'], input[id^='txtFinalDemerit_']").attr('pattern', '^[0-9]+$');
    $("input[id^='txtLinenCode_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    //$("input[id^='txtLinenDescription_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtInUse_']").attr('pattern', "[0-9]+");
    $("input[id^='txtShelf_']").attr('pattern', "[0-9]+");
    $("input[id^='txtTotalPcs_']").attr('pattern', "[0-9]+");

    if (!linkCliked1) {
        $('#ContactGrid tr:last td:first input').focus();
    }
    else {
        linkCliked1 = false;
    }
    formInputValidation("FrmINV");

}
/////SecondChildRow

$('#btntwo').click(function () {


    var rowCount = $('#contact tr:last').index();
    var LinenCode = $('#txtLocationCode_' + rowCount).val();

    if (rowCount < 0)
        AddFirstGridRows();
    else if (rowCount >= "0" && (LinenCode == "")) {
        bootbox.alert("Please fill the last record");
    }
    else {
        AddFirstGridRows();
    }
});
$('#chkContactDeleteAll2').on('click', function () {
    var isChecked = $(this).prop("checked");
    //var index1; $('#chkContactDeleteAll').prop('checked', true);
    // var count = 0;
    $('#contact tr').each(function (index, value) {
        // if (index == 0) return;
        // index1 = index - 1;
        if (isChecked) {
            // if(!$('#chkContactDeletee_' +index1).prop('disabled'))
            // {
            $('#chkContactDeletee_' + index).prop('checked', true);
            $('#chkContactDeletee_' + index).parent().addClass('bgDelete');
            $('#txtLocationCode_' + index).removeAttr('required');
            $('#txtLocationCode_' + index).parent().removeClass('has-error');
            // count++;
            //  }
        }
        else {
            //if(!$('#chkContactDeletee_' +index1).prop('disabled'))
            //{
            $('#txtLocationCode_' + index).attr('required', true);
            $('#chkContactDeletee_' + index).prop('checked', false);
            $('#chkContactDeletee_' + index).parent().removeClass('bgDelete');
            // }
        }
    });
    //if(count == 0){
    //    $(this).prop("checked", false);
    //}
});
var linkCliked1 = false;
window.AddFirstGridRows = function () {
    $('#chkContactDeleteAll2').prop('checked', false);
    var inputpar = {
        inlineHTML: '<tr class="ng-scope" style=""> ' +
            '<td width="5%" style="text-align:center"> <input type="hidden" id="LinenCodeUpdateDetId_maxindexval"/><input type="checkbox"  onchange="IsDeleteCheckAll(contact,chk_FacWorkIsDeleted)" id="Isdelete_maxindexval" /></td>' +
            //'<td width="20%" style="text-align: center;"><div><input type="text" id="txtLinenCode_maxindexval" name="LinenCode" maxlength="50"   onkeyup="FetchLinenCode(event,maxindexval)" onpaste="FetchLinenCode(event,maxindexval)" change="FetchLinenCode(event,maxindexval)"oninput="FetchLinenCode(event,maxindexval)"  class="form-control" autocomplete="off" tabindex="0"   placeholder="Please Select"><input type="hidden" id="LinenCodeId_maxindexval"/><input type="hidden" id="LinenCodeUpdateDetId_maxindexval"/> <div class="col-sm-12" id="divLinenCodeFetch_maxindexval"></div > </div></td>< td width="15%" style="text-align: center;" > <div> ' +
            //'<td width="20%" style="text-align: center;"><div><input type="text" id="txtLinenCode_maxindexval" disabled placeholder="Please Select" name="txtLinenCode" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" required ></div></td><div> ' +
            '<td width="20%" style="text-align: center;"><div><input type="text"  id="txtLocationCode_maxindexval" name="LocationCode" maxlength="50" onkeyup="FetchLocationCode(event,maxindexval)" onpaste="FetchLocationCode(event,maxindexval)" change="FetchLocationCode(event,maxindexval)" oninput="FetchLocationCode(event,maxindexval)" class="form-control" autocomplete="off" tabindex="0"  placeholder="Please Select"><input type="hidden" id="LocationCodeId_maxindexval"/><div class="col-sm-12" id="divLocationCodeFetch_maxindexval"></div > </div></td>< td width="15%" style="text-align: center;" > <div> ' +
            '<td width="25%" style="text-align: center;"><div><input type="text" id="txtLinen_maxindexval" name="Linen" maxlength="50"  class="form-control" autocomplete="off"  tabindex="0" disabled ></div></td><div> ' +
            '<td width="15%" style="text-align: center;"><div><input type="text" id="txtInUsee_maxindexval" name="TotalatCentralCleanLinenStore" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" onblur="compute2(maxindexval)"></div></td><div> ' +
            '<td width="15%" style="text-align: center;"><div><input type="text" id="txtShelff_maxindexval" name="txtTotalSoiled" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" pattern="^[0-9]*$" onblur="compute2(maxindexval)"></div></td><div>' +
            '<td width="20%" style="text-align: center;"><div><input type="text" id="txtTotalPcsA_maxindexval"  name="txtStainedbyChemical" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" onblur="compute(maxindexval)" disabled ></div></td><div>' ,
            //'<td width="15%" style="text-align: center;"><div><input type="text" id="txtUserDepartAreaB_maxindexval"  name="txtStainedbyChemical" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" onblur="compute(maxindexval)" disabled ></div></td><div>' +
            //'<td width="10%" style="text-align: center;"><div><input type="text" id="txtTotalPcsA_B_maxindexval"  name="txtStainedbyChemical" maxlength="50"  class="form-control"  pattern="^[0-9]*$" autocomplete="off" tabindex="0"  disabled ></div></td><div>' +
            //'<td width="10%" style="text-align: center;"><div><input type="text" id="txtCCLSStoreBalance_maxindexval"  name="txtStainedbyChemical" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" disabled ></div></td><div>' +
            //'<td width="10%" style="text-align: center;"><div><input type="text" id="txtVariance_maxindexval"  name="txtStainedbyChemical" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" disabled ></div></td><div></tr > ',
        IdPlaceholderused: "maxindexval",
        TargetId: "#contact",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    //$("input[id^='txtGeneratedDemerit_'], input[id^='txtFinalDemerit_']").attr('pattern', '^[0-9]+$');
    $("input[id^='txtLinenCodes_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtLinenDescription_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtInUsee_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtShelff_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtTotalPcsA_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtUserDepartAreaB_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtTotalPcsA+B_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtCCLSStoreBalance_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtVariance_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');

    if (!linkCliked1) {
        $('#contact tr:last td:first input').focus();
    }
    else {
        linkCliked1 = false;
    }
    formInputValidation("FrmINV");

}

//ChangeEventStrat

$("#txtStoreType").change(function () {
    $("#form :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#btnSave').prop('disabled', false);
    $('#btnSaveandAddNew').prop('disabled', false);
    // EmptyFields();

    if (this.value == 10171) {
        $('#txtStoreType').focus();
        $('#divCleanCenterLinenStore').show();
        $('#divUserAreaDept').hide();
        $('#contactBtn').hide();
        $('#btntwo').show()
        $('#btnSave').prop('disabled', true);
        $('#btnSaveandAddNew').prop('disabled', true);
        $('#CrmAssetGrid').css('visibility', 'hidden');
        $('#CrmAssetGrid').hide();
        $('#RequestDescription').prop('required', false);
        $("#lblcrmReqDesc").html("Request Description");
        $('#UserAreaIdName').hide();
        $('#txtStoreType').attr('required', true);
        $('#txtDate').attr('required', true);
        $('#txtHospitalRepresentative').attr('required', true);
        // $('#txtLocationCode_').attr('required', true);
        //$('#txtDate').attr('required', false);
        //$('#txtUserAreaCode').attr('required', false);
        //$('#txtHospitalRepresentative').attr('required', false);
        //$('#txtLinenCode_').attr('required', false);
    }
    if (this.value == 10172) {
        $('#divCleanCenterLinenStore').hide();
        $('#divUserAreaDept').show();
        $('#btntwo').hide();
        $('#contact').show();
        $('#contactBtn').show();
        $('#chkContactDeleteAll2').hide();
        $('#UserAreaIdName').show();
        $('#txtStoreType').attr('required', true);
        $('#txtDate').attr('required', true);
        $('#txtUserAreaCode').attr('required', false);
        $('#txtHospitalRepresentative').attr('required', true);
        // $('#txtLinenCode_').attr('required', true);
        // $('#txtStoreType').attr('required', false);
        // $('#txtDate').attr('required', false);
        // $('#txtHospitalRepresentative').attr('required', false);
        // $('#txtLocationCode_').attr('required', false);
    }



});

////////////////////*********** End Add rows **************//