//********************************************************************************

window.UOMGloabal = [];
$(document).ready(function () {
    window.CategoryListGloabal = [];
    $('#myPleaseWait').modal('show');
    formInputValidation("Departmentform");
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $('#spnPopup-Model').hide();
    $('#txtModel').attr('disabled', true);
    var UserAreaId = $("#UserAreaId").val();
    $('#ChilddivArea').css('visibility', 'hidden');
    $('#ChilddivArea').hide();
    $('#btnFirstSave').hide();
    

    $.get("/api/Department/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#jQGridCollapse1").click();
            $(loadResult.StatusList).each(function (_index, _data) {
                $('#txtstatus').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))
            });
            $(loadResult.OperatingDayList).each(function (_index, _data) {
                $('#txtOperatingDays').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))
            });
            $(loadResult.DayList).each(function (_index, _data) {
                $('#selectDay').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))
            });
            window.CategoryListGloabal = loadResult.PpmCategoryList;
            window.UOMGloabal = loadResult.FrequencyList;
            AddNewRowStkAdjustment();

            AddFirstGridRow();

        })

        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });
});
var UserAreaFetchObj = {
    
    SearchColumn: 'txtUserAreaCode-UserAreaCode',//Id of Fetch field
    ResultColumns: ["UserAreaId-Primary Key", 'UserAreaCode-UserAreaCode', 'UserAreaName-UserAreaName', 'ActiveFromDate-ActiveFromDate', 'ActiveToDate-ActiveToDate'],
    FieldsToBeFilled: ["hdnUserAreaId-UserAreaId", "txtUserAreaCode-UserAreaCode", "txtUserAreaName-UserAreaName", "txtEffectiveFormDate-ActiveFromDate", /*"txtEffectiveToDate-ActiveToDate",*/]
};

$('#txtUserAreaCode').on('input propertychange paste keyup', function (event) {
    DeptDisplayFetchResult('divFetch1', UserAreaFetchObj, "/api/Fetch/DepartmentCascCodeFetch", "UlFetch1", event, 1);//1 -- pageIndex
});
//fetch - Hospital Rep 
var HospitalRepFetchObj = {
    SearchColumn: 'txtHospitalRepresentative-StaffName',//Id of Fetch field
    ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-StaffName', 'FacRep-FacRep'],
    FieldsToBeFilled: ["hdnHospitalRepresentativeId-StaffMasterId", "txtHospitalRepresentative-StaffName", "txtHospitalRepresentativeDesignation-StaffName"]
};

$('#txtHospitalRepresentative').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divHospitalRepresentativeFetch', HospitalRepFetchObj, "/api/Fetch/FacilityStaffFetch", "UlFetch2", event, 1);//1 -- pageIndex
});
$('#hdnUserAreaId').change(function () {
    $('#txtUserLevelName').val('');
    $('#txtEffectiveFormDate').val('');
    $('#txtEffectiveToDate').val('');
});

$('#hdnHospitalRepresentativeId').change(function () {
    $('#txtHospitalRepresentativeDesignation').val('');
});

function DisplayError() {
    $('#errorMsg').css('visibility', 'visible');
    $('#myPleaseWait').modal('hide');
    $('#btnSave').attr('disabled', false);
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
if (ID == null || ID == 0 || ID == '') {
    $("#jQGridCollapse1").click();
}
else {
    LinkClicked(ID, {});
    FromNotification = true;
}
// **** Query String to get ID  End****\\\

//******************************************** Save *********************************************
$("#btnSave,#btnEdit,#btnSaveandAddNew").click(function () {
    $('#btnlogin').attr('disabled', true);
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('txtUserAreaCode').attr('required', true);
    $('#txtHospitalRepresentative').attr('required', true);
    $('#txtstatus').attr('required', true);
    $('#txtOperatingDays').attr('required', true);
    $('#txtWhiteBag').attr('required', true);
    $('#txtRedBag').attr('required', true);
    $('#txtGreenBag').attr('required', true);
    $('#txtBrownBag').attr('required', true);
    $('#txtAlginateBag').attr('required', true);
    $('#txtSoiledLinenBagHolder').attr('required', true);
    $('#txtRejectLinenBagHolder').attr('required', true);
    $('#txtsoiledLinenRack').attr('required', true);
    $('#txtStatus').attr('required', true);
    $('#txtPar2_').attr('required', true);
    $('#UOM_').attr('required', true);
    $('#txtSchedule1_').attr('required', true);
    $('#startTime').attr('required', true);
    $('#selectDay').attr('required', true);
    $('#PpmCategoryId_').attr('required', true);
    $('#startTime_').attr('required', true);
    var _index;
    $('#StkAdjustmentTbl tr').each(function () {
        _index = $(this).index();
    });

    var result = [];
    var primaryId = $('#primaryID').val();
    for (var i = 0; i <= _index; i++) {
        var _StkAdjustmentWO = {
            StockAdjustmentId: primaryId,
            LLSUserAreaId: $('#SparePartsId_' + i).val(),
            UserLocationCode: $('#partno_' + i).val(),
            UserLocationName: $('#partdesc_' + i).val(),
            LinenSchedule: $('#UOM_' + i).val(),
            UserLocationId: $("#hdnStkAdjustmentId_" + i).val(),
            FirstScheduleStartTime: $("#txtSchedule1_" + i).val(),
            FirstScheduleEndTime: $("#txtSchedule11_" + i).val(),
            SecondScheduleStartTime: $("#txtSchedule2_" + i).val(),
            SecondScheduleEndTime: $("#txtSchedule21_" + i).val(),
            ThirdScheduleStartTime: $("#txtSchedule3_" + i).val(),
            ThirdScheduleEndTime: $("#txtSchedule31_" + i).val(),
            StockUpdateDetId: $("#StockUpdateDetId_" + i).val(),
            LLSUserAreaLocationId: $("#LLSUserAreaLocationId_" + i).val(),
            IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
            ItemId: 1,
        }
        result.push(_StkAdjustmentWO);
    }
    
    
    var deletedCount = Enumerable.From(result).Where(x => x.IsDeleted).Count();
    if (deletedCount == result.length) {
        bootbox.alert("Sorry!. You cannot delete all rows");
        $('#btnAdjustmentSave').attr('disabled', false);
        $('#btnAdjustmentEdit').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }
    var LLSUserAreaId = $('#LLSUserAreaId').val(); 
    var UserAreaId = $('#hdnUserAreaId').val();
    var UserAreaCode = $('#txtUserAreaCode').val();
    var UserAreaName = $('#txtUserAreaName').val();
    var FacilityId = $('#FacilityId').val();
    var CustomerId = $('#CustomerId').val();
    var Active = $('#Active').val();
    var Staffmaster = $('#hdnHospitalRepresentativeId').val();
    var HospitalRep = $('#txtHospitalRepresentative').val();
    var HospitalRepresentativeDesignation = $('#txtHospitalRepresentativeDesignation').val();
    var EffectiveFormDate = $('#txtEffectiveFormDate').val();
    var EffectiveToDate = $('#txtEffectiveToDate').val();
    var ActiveToDate = $('#ActiveToDate').val();
    var timeStamp = $('#Timestamp').val();
    var WhiteBag = $('#txtWhiteBag').val();
    var RedBag = $('#txtRedBag').val();
    var GreenBag = $('#txtGreenBag').val();
    var BrownBag = $('#txtBrownBag').val();
    var AlginateBag = $('#txtAlginateBag').val();
    var SoiledLinenBagHolder = $('#txtSoiledLinenBagHolder').val();
    var RejectLinenBagHolder = $('#txtRejectLinenBagHolder').val();
    var SoiledLinenRack = $('#txtsoiledLinenRack').val();
    var LaadStartTime = $('#startTime').val();
    var CleaningSanitizing = $('#selectDay').val();
    var Test = $('#selectDay').val();
    var LAADEndTime = $('#EndTime').val();
    var strUser = $('#txtstatus').val();
    if (strUser == "") {
        var Statu = document.getElementById("txtstatus");
        strUser = Statu.options[Statu.selectedIndex].value;
    }
    else {

    
    }
    var OperatingDays = $('#txtOperatingDays').val();
    if (OperatingDays == "") {
        var OperatingDays = document.getElementsByTagName("txtOperatingDays");
        OperatingDays = oper.options[oper.selectedIndex].value;
    }
    var ActiveFromDate = $('#ActiveFromDate').val();
    if (ActiveFromDate == "") {
        var ActiveFromDate = document.getElementsByTagName("ActiveFromDate");
        ActiveFromDate = oper.options[oper.selectedIndex].value;
    }


    var CurrentbtnID = $(this).attr("Id");
    var timeStamp = $("#Timestamp").val();

    var isFormValid = formInputValidation("Departmentform", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }

    var obj = {
        EffectiveFromDate: EffectiveFormDate,
        EffectiveToDate: EffectiveToDate,
        ActiveFromDate: ActiveFromDate,
        ActiveToDate: ActiveToDate,
        CurrentbtnID: CurrentbtnID,
        UserAreaCode: UserAreaCode,
        UserAreaName: UserAreaName,
        LLSUserAreaId: LLSUserAreaId,
        UserAreaID: UserAreaId,
        FacilityId: FacilityId,
        CustomerId: CustomerId,
        Status: strUser,
        HospitalRepresentative: Staffmaster,
        HospitalRepresentativeDesignation: HospitalRepresentativeDesignation,
        RedBag: RedBag,
        WhiteBag: WhiteBag,
        GreenBag: GreenBag,
        BrownBag: BrownBag,
        AlginateBag: AlginateBag,
        SoiledLinenBagHolder: SoiledLinenBagHolder,
        RejectLinenBagHolder: RejectLinenBagHolder,
        SoiledLinenRack: SoiledLinenRack,
        LAADStartTimess: LaadStartTime,
        LAADEndTime: LAADEndTime,
        CleaningSanitizing: CleaningSanitizing,
        OperatingDays: OperatingDays,
        UserAreaDetailsLocationGridList: result
        
    }

    var primaryId = $("#primaryID").val();
    if (primaryId != null) {
        obj.LLSUserAreaId = primaryId;
        obj.Timestamp = timeStamp;
    }
    else {
        obj.LLSUserAreaId = 0;
        obj.Timestamp = "";
    }
    SaveStkAdjustment(obj);
});
function SaveStkAdjustment(obj) {
    var jqxhr = $.post("/api/Department/Save", obj, function (response) {
        var result = JSON.parse(response);
        $("#primaryID").val(result.LLSUserAreaId);
        if (result != null && result.UserAreaDetailsLocationGridList != null && result.UserAreaDetailsLocationGridList.length > 0) {
            BindGridData(result);
        }
       
        $(".content").scrollTop(0);
        showMessage('Stock Adjustment', CURD_MESSAGE_STATUS.SS);

        $('#btnAdjustmentSave').attr('disabled', false);
        $('#btnAdjustmentEdit').attr('disabled', false);
        $('#btnAdjustmentVerify').show();
        $('#myPleaseWait').modal('hide');
        $("#grid").trigger('reloadGrid');
        if (obj.CurrentbtnID == "btnSaveandAddNew") {
            EmptyFields();
        }
        $('#ChilddivArea').css('visibility', 'visible');
        $('#ChilddivArea').show();
        $('#btnFirstSave').show();
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

$("#btnFirstSave").click(function () {
    $('#btnlogin').attr('disabled', true);
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#myPleaseWait').modal('hide');
    $('#txtPar2_').attr('required', true);
    $('#UOM_').attr('required', true);
    $('#txtSchedule1_').attr('required', true);
    $('#startTime').attr('required', true);
    $('#selectDay').attr('required', true);
    $('#PpmCategoryId_').attr('required', true);
    $('#startTime_').attr('required', true);
    $('#hdnLLSUserAreaId_').attr('required', true);
    $('#LinenCodeId_').attr('required', true);
    var isFormValid = formInputValidation("Departmentform", 'save');
    var CurrentbtnID = $(this).attr("Id");
    var timeStamp = $("#Timestamp").val();
    //var rowCount = $('#FirstGridId tr:last').index();
    //for (var i = 0; i <= rowCount; i++) {
    //    LocationCode = parseInt(document.getElementById("hdnLLSUserAreaId_" + i).value);
    //    LocationCode = isNaN(LocationCode) ? "" : LocationCode;

    //    if (LocationCode == " " || LocationCode == "" || LocationCode == null) {
    //        DisplayErrorMessage("Some fields are incorrect or have not been filled in. Please correct this to proceed.");
    //        $('#myPleaseWait').modal('hide');
    //        return false;
    //    }
    //    else (LocationCode != " " || LocationCode != "" || LocationCode != null)
    //    {

    //    }
    //}
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }


    var _Leninindex;
    $('#FirstGridId tr').each(function () {
        _Leninindex = $(this).index();
    });

    var result = [];
    var Lresult = [];
    var primaryId = $('#hdnUserAreaId').val();

    for (var i = 0; i <= _Leninindex; i++) {
        var _LLSUserAreaDetailsLinen = {

            LLSUserAreaLinenItemId: $('#LLSUserAreaLinenItemId_' + i).val(),
            UserLocationId: $('#LocationCodeId_' + i).val(),
            UserLocationCode: $('#txtLocationCode_' + i).val(),
            LinenItemId: $('#LinenCodeId_' + i).val(),
            LinenCode: $('#txtLinenCode_' + i).val(),
            LinenSchedule: $('#txtLinenDescription' + i).val(),
            Par1: $("#txtPar1_" + i).val(),
            Par2: $("#txtPar2_" + i).val(),
            DefaultIssue: $("#PpmCategoryId_" + i).val(),
            AgreedShelfLevel: $("#txtAgreedShelfLevel_" + i).val(),
            IsDelete: chkIsSecondDeletedRow(i, $('#Isdelete_' + i).is(":checked")),
            LLSUserAreaLocationId: $("#hdnLLSUserAreaId_" + i).val(),
            LLSUserAreaId: $("#LocationCodeId_" + i).val(),
            ItemId: 1,
            //LLSUserAreaLinenItemId:
        }

        Lresult.push(_LLSUserAreaDetailsLinen);
    }
    var deletedCount = Enumerable.From(Lresult).Where(x => x.IsDeleted).Count();
    var Isdeleteavailable = deletedCount > 0;
    //  if (deletedCount == result.length && TotalPages == 1) {
    if (deletedCount == Lresult.length) {
        bootbox.alert("Sorry!. You cannot delete all rows");
        $('#btnAdjustmentSave').attr('disabled', false);
        $('#btnAdjustmentEdit').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }
  
    var UserAreaId = $('#hdnUserAreaId').val();
    var UserAreaCode = $('#txtUserAreaCode').val();
    var UserAreaName = $('#txtUserAreaName').val();
    var FacilityId = $('#FacilityId').val();
    var CustomerId = $('#CustomerId').val();
    var Active = $('#Active').val();

    var ActiveFromDate = $('#ActiveFromDate').val();
    if (ActiveFromDate == "") {
        var ActiveFromDate = document.getElementsByTagName("ActiveFromDate");
        ActiveFromDate = oper.options[oper.selectedIndex].value;
    }

    var obj = {
        CurrentbtnID: CurrentbtnID,
        UserAreaCode: UserAreaCode,
        UserAreaName: UserAreaName,
        LLSUserAreaId: LLSUserAreaId,
        FacilityId: FacilityId,
        CustomerId: CustomerId,
        LUserAreaDetailsLinenItemGridList: Lresult
    }
    
    if (primaryId != null) {
        obj.LLSUserAreaId = primaryId;
        obj.Timestamp = timeStamp;
    }
    else {
        Obj.Timestamp = "";
    }
    ItemSave(obj);

});
function ItemSave(obj) {
  
    var jqxhr = $.post("/api/Department/LinenItemSave", obj, function (response) {
        var result = JSON.parse(response);
        $("#primaryID").val(result.LLSUserAreaId);
       
        if (result != null && result.LUserAreaDetailsLinenItemGridList != null && result.LUserAreaDetailsLinenItemGridList.length > 0) {
            BindSecondGridData(result);
        }
        $(".content").scrollTop(0);
        showMessage('Stock Adjustment', CURD_MESSAGE_STATUS.SS);

        $('#btnAdjustmentSave').attr('disabled', false);
        $('#btnAdjustmentEdit').attr('disabled', false);
        $('#btnAdjustmentVerify').show();
        $('#myPleaseWait').modal('hide');
        $("#grid").trigger('reloadGrid');
        
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
function DisplayErrorMessage(errorMessage) {
    $("div.errormsgcenter").text(errorMessage);
    $('#errorMsg').css('visibility', 'visible');

    $('#btnSave').attr('disabled', false);
    $('#btnEdit').attr('disabled', false);
}
//************************************ Grid Delete 

$("#chk_stkadjustmentdet").change(function () {
    var Isdeletebool = this.checked;

    if (this.checked) {
        $('#StkAdjustmentTbl tr').map(function (i) {
            if ($("#Isdeleted_" + i).prop("disabled")) {
                $("#Isdeleted_" + i).prop("checked", false);
            }
            else {
                $("#Isdeleted_" + i).prop("checked", true);
            }
        });
    } else {
        $('#StkAdjustmentTbl tr').map(function (i) {
            $("#Isdeleted_" + i).prop("checked", false);
        });
    }
});

$("#chk_FacWorkIsDelete").change(function () {
    var Isdeletebool = this.checked;

    if (this.checked) {
        $('#FirstGridId tr').map(function (i) {
            if ($("#Isdelete_" + i).prop("disabled")) {
                $("#Isdelete_" + i).prop("checked", false);
            }
            else {
                $("#Isdelete_" + i).prop("checked", true);
            }
        });
    } else {
        $('#FirstGridId tr').map(function (i) {
            $("#Isdelete_" + i).prop("checked", false);
        });
    }
});
function myFunctionSchedule(index) {
    var x = $("#txtSchedule1_" + index).val();
    var currentVal = moment(x, 'HH-mm').add(2, 'h');
    console.log(currentVal);
    if (!x) {
        ($("#txtSchedule11_" + index).val() = x);
    } else {
        var total = currentVal.format('HH:mm')
        console.log(currentVal);
        ($("#txtSchedule11_" + index).val(total));
        console.log(currentVal);
    }

}

function myFunctionss(index) {
    var x = $("#txtSchedule2_" + index).val();
    //if (x = " " || '00:00:00') {
    //    var currentVal = moment(x, 'HH-mm').add(0, 'h');
    //}
    //else {
        var currentVal = moment(x, 'HH-mm').add(2, 'h');
    //}
   
    console.log(currentVal);
    if (!x) {
        ($("#txtSchedule21_" + index).val() = x);
    } else {
        var total = currentVal.format('HH:mm')
        console.log(currentVal);
        ($("#txtSchedule21_" + index).val(total));
        console.log(currentVal);
    }

}

function myFunctionsss(index) {
    var x = $("#txtSchedule3_" + index).val();
    //if (x = " " || '00:00:00') {
    //    var currentVal = moment(x, 'HH-mm').add(0, 'h');
    //}
    //else {
        var currentVal = moment(x, 'HH-mm').add(2, 'h');
    //}
    console.log(currentVal);
    if (!x) {
        ($("#txtSchedule31_" + index).val() = x);
    } else {
        var total = currentVal.format('HH:mm')
        console.log(currentVal);
        ($("#txtSchedule31_" + index).val(total));
        console.log(currentVal);
    }

}



function Schedule(index) {
    var total = parseInt(document.getElementById("txtPar2_" + index).value);
    var val2 = parseInt(document.getElementById("txtAgreedShelfLevel_" + index).value);
    console.log(total);
    due = total * 2;
    console.log(due);
    $("#txtAgreedShelfLevel_" + index).val(due);
    console.log(due);
}

function myFunction() {

    var x = document.getElementById("startTime").value;
    var y = "02:00";
    var currentVal = moment(x, 'HH-mm').add(2, 'h');
    if (!x) {
        document.getElementById("EndTime").innerHTML = x;
    } else {
        document.getElementById("EndTime").value = currentVal.format('HH:mm');
    }
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


function FetchPartNodataStockAdjustment(event, index) {
    $('#divFetch_' + index).css({
        'top': $('#partno_' + index).offset().top - $('#StockadjustmentdataTable').offset().top + $('#partno_' + index).innerHeight(),
    });
    var StockAdjustmentFetchObj = {
        SearchColumn: 'partno_' + index + '-UserLocationCode',    //Id of Fetch field
        ResultColumns: ["UserLocationId" + "-Primary Key", 'UserLocationCode' + '-partno_' + index],
        FieldsToBeFilled: ["hdnStkAdjustmentId_" + index + "-UserLocationId", 'partno_' + index + '-UserLocationCode', 'partdesc_' + index + '-UserLocationName', 'UOM_' + index + '-UOM']//id of element - the model property
    };
    var UserAreaId = $('#hdnUserAreaId').val();
    DisplayLocationCodeFetchResult('divFetch_' + index, StockAdjustmentFetchObj, "/api/Fetch/LLSUserAreaDetailsLocationMstDet_FetchLocCode", "UlFetch3" + index, event, 1, UserAreaId);

}

function FetchLocationCode(event, index) {

    $('#divLocationCodeFetch_' + index).css({
        'top': $('#txtLocationCode_' + index).offset().top - $('#ppmchecklistTable').offset().top + $('#txtLocationCode_' + index).innerHeight(),
    });
    var LinenFetchObj = {
        SearchColumn: 'txtLocationCode_' + index + '-UserLocationCode',//Id of Fetch field
        ResultColumns: ["LLSUserAreaLocationId-Primary Key", 'UserLocationCode' + '-txtLocationCode_' + index],
        FieldsToBeFilled: ["hdnLLSUserAreaId_" + index + "-LLSUserAreaLocationId", 'LocationCodeId_' + index + '-LLSUserAreaId','txtLocationCode_' + index + '-UserLocationCode']
    };
    var UserAreaId = $('#hdnUserAreaId').val();
    DisplayLocationCodeFetchResult('divLocationCodeFetch_' + index, LinenFetchObj, "/api/Fetch/LocationCascCodeFetch", "UlFetch4" + index, event, 1, UserAreaId);//1 -- pageIndex
}

function FetchLinenCode(event, index) {
    $('#divLinenCodeFetch_' + index).css({
        'top': $('#txtLinenCode_' + index).offset().top - $('#ppmchecklistTable').offset().top + $('#txtLinenCode_' + index).innerHeight(),
    });
    var LinenFetchObj = {
        SearchColumn: 'txtLinenCode_' + index + '-LinenCode',//Id of Fetch field
        ResultColumns: ["LinenItemId-Primary Key", 'LinenCode' + '-txtLinenCode_' + index],
        FieldsToBeFilled: ["LinenCodeId_" + index + "-LinenItemId", 'txtLinenCode_' + index + '-LinenCode', 'txtLinenDescription_' + index + '-LinenDescription']
    };

    DisplayFetchResult('divLinenCodeFetch_' + index, LinenFetchObj, "/api/Fetch/LinenItemCascCodeFetch", "UlFetch5" + index, event, 1);//1 -- pageIndex
}

//****************************** AddNewRow **********************************************

var linkCliked1 = false;
function AddNewRowStkAdjustment() {

    var inputpar = {
        inlineHTML: BindNewRowHTML(),

        IdPlaceholderused: "maxindexval",
        TargetId: "#StkAdjustmentTbl",
        TargetElement: ["tr"]

    }
    AddNewRowToDataGrid(inputpar);
    ckNewRowPaginationValidation = true;
    $('#chk_stkadjustmentdet').prop("checked", false);
    if (!linkCliked1) {
        $('#StkAdjustmentTbl tr:last td:first input').focus();
    }
    else {
        linkCliked1 = false;
    }
    var rowCount = $('#StkAdjustmentTbl tr:last').index();
    $.each(window.UOMGloabal, function (index, value) {
        $('#UOM_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });

    formInputValidation("StockAdjustmentFrom");

}

function BindNewRowHTML() {
    return ' <tr> <td width="3%" title="Select All"> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(StkAdjustmentTbl,chk_stkadjustmentdet)"> </label> </div></td><td width="7%" style="text-align: center;" title=""> <div> <input type="text" id="partno_maxindexval" value="" placeholder="Please Select" onkeyup="FetchPartNodataStockAdjustment(event,maxindexval)" onpaste="FetchPartNodataStockAdjustment(event,maxindexval)" change="FetchPartNodataStockAdjustment(event,maxindexval)" oninput="FetchPartNodataStockAdjustment(event,maxindexval)" class="form-control" maxlength="25" required> <input type="hidden" id="SparePartsId_maxindexval"/> <input type="hidden" id="hdnStkAdjustmentId_maxindexval" required/><input type="hidden" id="LLSUserAreaLocationId_maxindexval"/><div class="col-sm-12" id="divFetch_maxindexval"></div></div></td><td width="7%" style="text-align: center;" title=""> <div> <input type="text" id="partdesc_maxindexval" maxlength="100" class="form-control" readonly disabled> </div></td><td width="6%" style="text-align: center;" title=""> <div> <select id="UOM_maxindexval" name="Linenschudule"  class="form-control" required><option value="null">Select</option></select> </div></td><td width="7%" style="text-align: center;" title=""> <div> <input  type="time" /*min="00:00" max="23:59"*/  id="txtSchedule1_maxindexval" name="Schedule1" maxlength="50"  class="form-control"  required onblur="myFunctionSchedule(maxindexval)"></div></td><td width="5%" style="text-align: center;" title=""> <div> <input type="time" /*min="00:00" max="23:59"*/ id="txtSchedule11_maxindexval" name="Schedule11" class="form-control" readonly="readonly"></div></td><td width="9%" style="text-align: center;" title=""> <div><input type="time" /*min="00:00" max="23:59"*/ id="txtSchedule2_maxindexval" name="Schedule2" class="form-control" onblur="myFunctionss(maxindexval)"> </div></td><td width="8%" style="text-align: center;" title=""> <div> <input type="time" min="00:00" max="23:59" id="txtSchedule21_maxindexval" name="Schedule21"  class="form-control " readonly="readonly"></div></td><td width="8%" style="text-align: center;" title=""> <div> <input type="time" min="00:00" max="23:59" id="txtSchedule3_maxindexval" name="Schedule21" maxlength="50"  class="form-control " onblur="myFunctionsss(maxindexval)"></div></td><td width="8%" style="text-align: center;" title=""> <div> <input type="time" min="00:00" max="23:59" id="txtSchedule31_maxindexval" name="Schedule31" maxlength="50"  class="form-control" readonly="readonly"></div></td></tr>'

}


//*********************** Empty Row Validation **************************************

function AddNewRow() {
    //$('#txtSchedule2_maxindexval').addClass('.timepicker');
    //$('#txtSchedule2_maxindexval').addClass('timepicker timepicker-with-dropdown text-center');
    $("div.errormsgcenter1").text("");
    $('#errorMsg1').css('visibility', 'hidden');
    var rowCount = $('#StkAdjustmentTbl tr:last').index();
    var PartNo = $('#partno_' + rowCount).val();
    if (rowCount < 0)
        AddNewRowStkAdjustment();
    else if (rowCount >= "0" && PartNo == "") {
        bootbox.alert("All fields are mandatory. Please enter details in existing row");
        //  $("div.errormsgcenter1").text();
        // $('#errorMsg1').css('visibility', 'visible');
    }
    else {
        AddNewRowStkAdjustment();
    }
}


function BindGridData(getResult) {
    var ActionType = $('#ActionType').val();
    $("#StkAdjustmentTbl").empty();
    $.each(getResult.UserAreaDetailsLocationGridList, function (index, value) {
        AddNewRowStkAdjustment();
        $("#LLSUserAreaLocationId_" + index).val(getResult.UserAreaDetailsLocationGridList[index].LLSUserAreaLocationId);
        $("#SparePartsId_" + index).val(getResult.UserAreaDetailsLocationGridList[index].LLSUserAreaId);
        $("#hdnStkAdjustmentId_" + index).val(getResult.UserAreaDetailsLocationGridList[index].UserLocationId);
        $("#partno_" + index).attr('title', getResult.UserAreaDetailsLocationGridList[index].UserLocationCode);
        $("#partno_" + index).val(getResult.UserAreaDetailsLocationGridList[index].UserLocationCode).prop("disabled", "disabled");
        $("#partdesc_" + index).val(getResult.UserAreaDetailsLocationGridList[index].UserLocationName).attr('title', getResult.UserAreaDetailsLocationGridList[index].UserLocationName);
        $("#UOM_" + index).val(getResult.UserAreaDetailsLocationGridList[index].LinenSchedule);
        $("#txtSchedule1_" + index).val(getResult.UserAreaDetailsLocationGridList[index].FirstScheduleStartTime);
        $("#txtSchedule11_" + index).val(getResult.UserAreaDetailsLocationGridList[index].FirstScheduleEndTime);
        if (getResult.UserAreaDetailsLocationGridList[index].SecondScheduleStartTime == getResult.UserAreaDetailsLocationGridList[index].SecondScheduleEndTime) {
        }
        else {
            $("#txtSchedule2_" + index).val(getResult.UserAreaDetailsLocationGridList[index].SecondScheduleStartTime);
            $("#txtSchedule21_" + index).val(getResult.UserAreaDetailsLocationGridList[index].SecondScheduleEndTime);
        }
        if (getResult.UserAreaDetailsLocationGridList[index].ThirdScheduleStartTime == getResult.UserAreaDetailsLocationGridList[index].ThirdScheduleEndTime) {
        }
        else {
            $("#txtSchedule3_" + index).val(getResult.UserAreaDetailsLocationGridList[index].ThirdScheduleStartTime);
            $("#txtSchedule31_" + index).val(getResult.UserAreaDetailsLocationGridList[index].ThirdScheduleEndTime);
        }

       
        linkCliked1 = true;
        $(".content").scrollTop(0);
    });

    //************************************************ Grid Pagination *******************************************
    ckNewRowPaginationValidation = false;
    if ((getResult.UserAreaDetailsLocationGridList && getResult.UserAreaDetailsLocationGridList.length) > 0) {
        //StockAdjustmentId = result.UserAreaDetailsLocationGridList[0].StockAdjustmentId;
        GridtotalRecords = getResult.UserAreaDetailsLocationGridList[0].TotalRecords;
        TotalPages = getResult.UserAreaDetailsLocationGridList[0].TotalPages;
        LastRecord = getResult.UserAreaDetailsLocationGridList[0].LastRecord;
        FirstRecord = getResult.UserAreaDetailsLocationGridList[0].FirstRecord;
        pageindex = getResult.UserAreaDetailsLocationGridList[0].PageIndex;
        linkCliked1 = true;
        $(".content").scrollTop(0);
    }

    //************************************************ End *******************************************************
}


//************************************************ Getbyid bind data *************************

function BindSecondGridData(getResult) {
    var ActionType = $('#ActionType').val();
    $("#FirstGridId").empty();
    //debugger;
    $.each(getResult.LUserAreaDetailsLinenItemGridList, function (index, value) {
        AddFirstGridRow();
        $("#LLSUserAreaLinenItemId_" + index).val(getResult.LUserAreaDetailsLinenItemGridList[index].LLSUserAreaLinenItemId);
        $("#hdnLinenItemID" + index).val(getResult.LUserAreaDetailsLinenItemGridList[index].LinenItemId);
        $("#LocationCodeId_" + index).val(getResult.LUserAreaDetailsLinenItemGridList[index].UserLocationId);
        $("#txtLocationCode_" + index).attr('title', getResult.LUserAreaDetailsLinenItemGridList[index].UserLocationCode);
        $("#txtLocationCode_" + index).val(getResult.LUserAreaDetailsLinenItemGridList[index].UserLocationCode).prop("disabled", "disabled");
        $("#txtLinenCode_" + index).attr('title', getResult.LUserAreaDetailsLinenItemGridList[index].LinenCode);
        $("#txtLinenCode_" + index).val(getResult.LUserAreaDetailsLinenItemGridList[index].LinenCode).prop("disabled", "disabled");
        $("#LinenCodeId_" + index).val(getResult.LUserAreaDetailsLinenItemGridList[index].LinenItemId).prop("disabled", "disabled");
        $("#txtLinenDescription_" + index).val(getResult.LUserAreaDetailsLinenItemGridList[index].LinenDescription);
        $("#txtPar1_" + index).val(getResult.LUserAreaDetailsLinenItemGridList[index].Par1);
        $("#txtPar2_" + index).val(getResult.LUserAreaDetailsLinenItemGridList[index].Par2);
        $("#PpmCategoryId_" + index).val(getResult.LUserAreaDetailsLinenItemGridList[index].DefaultIssue);
        $("#txtAgreedShelfLevel_" + index).val(getResult.LUserAreaDetailsLinenItemGridList[index].AgreedShelfLevel);
        linkCliked2 = true;
        $("#chk_FacWorkIsDelete").prop("checked", false);
        $(".content").scrollTop(0);
    });
    //************************************************ Grid Pagination *******************************************

    if ((getResult.LUserAreaDetailsLinenItemGridList && getResult.LUserAreaDetailsLinenItemGridList.length) > 0) {
        GridtotalRecords = getResult.LUserAreaDetailsLinenItemGridList[0].TotalRecords;
        TotalPages = getResult.LUserAreaDetailsLinenItemGridList[0].TotalPages;
        LastRecord = getResult.LUserAreaDetailsLinenItemGridList[0].LastRecord;
        FirstRecord = getResult.LUserAreaDetailsLinenItemGridList[0].FirstRecord;
        pageindex = getResult.LUserAreaDetailsLinenItemGridList[0].PageIndex;
        linkCliked2 = true;
        $(".content").scrollTop(0);
    }
    $('#paginationfooter').show();


    //************************************************ End *******************************************************
}

//************************************************* Delete ****************************************

function chkIsDeletedRow(i, delrec) {
    if (delrec == true) {
        $('#hdnStkAdjustmentId_' + i).prop("required", false);
        $('#partno_' + i).prop("required", false);
        $('#partdesc_' + i).prop("required", false);
        $('#UOM_' + i).prop("required", false);
        $('#txtSchedule1_' + i).prop("required", false);
        $('#txtSchedule11_' + i).prop("required", false);
        $("#txtSchedule2_" + i).prop("required", false);
        $("#txtSchedule21_" + i).prop("required", false);
        $("#txtSchedule3_" + i).prop("required", false);
        $("#txtSchedule31_" + i).prop("required", false);
        $("#txtSchedule31_" + i).prop("required", false);
        $("#StockUpdateDetId_" + i).prop("required", false);
        return true;
    }
    else {
        return false;
    }
}
function chkIsSecondDeletedRow(i, deleteRow) {
    if (deleteRow == true) {
        $('#LLSUserAreaLinenItemId_' + i).prop("required", false);
        $('#LocationCodeId_' + i).prop("required", false);
        $('#txtLocationCode_' + i).prop("required", false);
        $('#LinenCodeId_' + i).prop("required", false);
        $('#txtLinenCode_' + i).prop("required", false);
        $('#txtLinenDescription' + i).prop("required", false);
        $("#txtPar1_" + i).prop("required", false);
        $("#txtPar2_" + i).prop("required", false);
        $("#PpmCategoryId_" + i).prop("required", false);
        $("#txtAgreedShelfLevel_" + i).prop("required", false);
        return true;
    }
    else {
        return false;
    }
}

function fetchValidation() {
    var _index;
    $('#StkAdjustmentTbl tr').each(function () {
        _index = $(this).index();
    });

    for (var i = 0; i <= _index; i++) {
        var SparePartsId = $("#SparePartsId_" + i).val();

        if (SparePartsId == null || SparePartsId == 0 || SparePartsId == "") {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#partno_' + i).parent().addClass('has-error');
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnAdjustmentSave').attr('disabled', false);
            $('#btnAdjustmentEdit').attr('disabled', false);
            return false;
        }
    }
}

//**************************** Grid merging***************************//

function LinkClicked(UserAreaId) {
    //debugger;
    linkCliked1 = true;
    linkCliked2 = true;
    //alert(LLSUserAreaId);
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#Departmentform :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(UserAreaId);
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
        $("#Departmentform :input:not(:button)").prop("disabled", true);
        $('#levlcodepopup,#hospStaffpopup,#companypopup').hide();
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();

    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/Department/Get/" + UserAreaId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                $('#btnDelete').show();
                $('#LLSUserAreaId').val(getResult.LLSUserAreaId);
                $('#UserAreaCode').val(getResult.UserAreaCode);
                $('#UserAreaName').val(getResult.UserAreaName);
                $('#hdnUserAreaId').val(getResult.UserAreaID);
                $('#txtUserAreaCode').val(getResult.UserAreaCode);
                $('#txtUserAreaName').val(getResult.UserAreaName);
                //$('#hdnLevelId').val(getResult.LevelId);
                $('#txtHospitalRepresentative').val(getResult.HospitalRepresentative);
                $('#hdnHospitalRepresentativeId').val(getResult.hdnHospitalRepresentativeId);
                $('#txtEffectiveFormDate').val(moment(getResult.EffectiveFromDate).format("DD-MMM-YYYY"));
               // $('#txtEffectiveToDate').val(getResult.EffectiveToDate);
               // $('#txtEffectiveToDate').val(moment(getResult.EffectiveToDate).format("DD-MMM-YYYY"));
                $('#txtWhiteBag').val(getResult.WhiteBag);
                $('#txtRedBag').val(getResult.RedBag);
                $('#txtGreenBag').val(getResult.GreenBag);
                $('#txtBrownBag').val(getResult.BrownBag);
                $('#txtAlginateBag').val(getResult.AlginateBag);
                $('#txtSoiledLinenBagHolder').val(getResult.SoiledLinenBagHolder);
                $('#txtRejectLinenBagHolder').val(getResult.RejectLinenBagHolder);
                $('#txtsoiledLinenRack').val(getResult.SoiledLinenRack);
                $('#selectDay').val(getResult.DayList);
                $('#txtstatus').val(getResult.Status);
                $('#txtOperatingDays').val(getResult.OperatingDays);
                $('#txtHospitalRepresentativeDesignation').val(getResult.HospitalRepresentativeDesignation);
                $('#Active').val(getResult.Active);
                $('#hdnAttachId').val(getResult.HiddenId);
                $('#Active').val(getResult.Active);
                $('#hdnAttachId').val(getResult.HiddenId);
                $('#startTime').val(getResult.LAADStartTime);
                $('#EndTime').val(getResult.LAADEndTime);
                $('#selectDay').val(getResult.CleaningSanitizing);
                $('#btnSave').show();
                if (getResult != null && getResult.UserAreaDetailsLocationGridList != null && getResult.UserAreaDetailsLocationGridList.length > 0) {
                    BindGridData(getResult);
                    //$("#grid").trigger('reloadGrid');
                    //$('#ChilddivArea').css('visibility', 'visible');
                    //$('#ChilddivArea').show();
                }
                if (getResult != null && getResult.LUserAreaDetailsLinenItemGridList != null && getResult.LUserAreaDetailsLinenItemGridList.length > 0) {
                    $('#ChilddivArea').css('visibility', 'visible');
                    $('#ChilddivArea').show();
                    $('#btnFirstSave').show();
                    
                    BindSecondGridData(getResult);
                }
                $('#btnEdit').hide();
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
/////////////////////////////////////////////


function FunctionUserAreaCodeCheck(UserAreaCode, UserAreaId) {
    var UserAreaCode = UserAreaCode;
    var UserAreaId = UserAreaId;
    var obj1 = {
        UserAreaCode: UserAreaCode
       
    }
    
    $.get("/api/Department/CheckUserAreaCode/" + UserAreaCode)
        .done(function (result) {
            var getResult = JSON.parse(result);
           
            if (getResult != "") {
                alert(getResult)
                $("div.errormsgcenter").text(getResult);
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');

               
            }
            else {
                
                $('#errorMsg').css('visibility', 'hidden');
               
            }

   
    })
        .fail(function (response) {
            var errorMessage = "";
            if (response.status == 400) {
                errorMessage = response.responseJSON;
                $("div.errormsgcenter").text(errorMessage);
                $('#errorMsg').css('visibility', 'visible');

                $('#btnSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            }
            else {
                errorMessage = Messages.COMMON_FAILURE_MESSAGE;
                $("div.errormsgcenter").text(errorMessage);
                $('#errorMsg').css('visibility', 'visible');

                $('#btnSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            }
            if (errorMessage = "")
            {
                //$("div.errormsgcenter").text(errorMessage);
                $('#errorMsg').css('visibility', 'hidden');
                $('#myPleaseWait').modal('hide');
            }
        });
}


function CheckUserAreaCode(obj1) {
    debugger;
    linkCliked1 = true;
    linkCliked2 = true; 
    //alert(LLSUserAreaId);
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#Departmentform :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(UserAreaId);
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
        $("#Departmentform :input:not(:button)").prop("disabled", true);
        $('#levlcodepopup,#hospStaffpopup,#companypopup').hide();
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/Department/CheckUserAreaCode/" + obj1)
            .done(function (result) {
                var getResult = JSON.parse(result);
                $('#btnDelete').show();
                $('#UserAreaCode').val(getResult.UserAreaCode);
                $('#UserAreaName').val(getResult.UserAreaName);
                $('#hdnUserAreaId').val(getResult.UserAreaID);
                $('#txtUserAreaCode').val(getResult.UserAreaCode);
                $('#txtUserAreaName').val(getResult.UserAreaName);
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

////////////////////////////////////////////////
$("#btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/Department/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('Stock Adjustment', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    $("#grid").trigger('reloadGrid');
                    EmptyFields();
                })
                .fail(function (response) {
                    showMessage('Level', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                    $("#grid").trigger('reloadGrid');
                });
        }
    });
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
});

var linkCliked2 = false;

window.AddFirstGridRow = function () {

    var inputpar = {
        inlineHTML: '<tr><td width="5%" id="PPMCheckListDel" ><div class="checkbox text-center"> <label for="checkboxes-0"> ' +
            '<input type="hidden" id= "PPmCategoryDetId_maxindexval"/> ' +
            '<input type="checkbox" class="CategoryClass"  name="TestApparatusDelete" onchange="IsDeleteCheckAll(FirstGridId,chk_FacWorkIsDelete)" id="Isdelete_maxindexval" value="false" autocomplete="off" tabindex="0"> </label></div>' +
            '<td width="10%" style="text-align: center;"><div><input type="text" required id="txtLocationCode_maxindexval" name="LocationCode" maxlength="50" onkeyup="FetchLocationCode(event,maxindexval)" onpaste="FetchLocationCode(event,maxindexval)" change="FetchLocationCode(event,maxindexval)" oninput="FetchLocationCode(event,maxindexval)" class="form-control" autocomplete="off" tabindex="0" required placeholder="Please Select"><input type="hidden" id="LocationCodeId_maxindexval" required/><input type="hidden" id="hdnLLSUserAreaId_maxindexval" required/><input type="hidden" id= "LLSUserAreaLinenItemId_maxindexval"/> <div class="col-sm-12" id="divLocationCodeFetch_maxindexval"></div > </div></td>< td width="15%" style="text-align: center;" > <div> ' +
            '<td width="15%" style="text-align: center;"><div><input type="text" id="txtLinenCode_maxindexval" name="LinenCode" maxlength="50" onkeyup="FetchLinenCode(event,maxindexval)" onpaste="FetchLinenCode(event,maxindexval)" change="FetchLinenCode(event,maxindexval)"oninput="FetchLinenCode(event,maxindexval)"  class="form-control" autocomplete="off" tabindex="0" required  placeholder="Please Select"><input type="hidden" id="LinenCodeId_maxindexval" required/><input type="hidden" id="LinenCodeUpdateDetId_maxindexval"/> <div class="col-sm-12" id="divLinenCodeFetch_maxindexval"></div > </div></td>< td width="15%" style="text-align: center;" > <div> ' +
            '<td width="15%" style="text-align: center;"><div><input type="text" id="txtLinenDescription_maxindexval" name="LinenDescription" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" disabled ></div></td>< td width="15%" style="text-align: center;" > <div> ' +
            '<td width="15%" style="text-align: center;"><div><input type="text" id="txtPar1_maxindexval" name="Par1" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"  ></div></td>< td width="15%" style="text-align: center;" > <div> ' +
            '<td width="15%" style="text-align: center;"><div><input type="text" id="txtPar2_maxindexval" name="Par2" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" onblur="Schedule(maxindexval)"></div></td>< td width="15%" style="text-align: center;" > <div> ' +
            '<td width="15%" style="text-align: center;"><div><select id="PpmCategoryId_maxindexval" name="txtDefaultIssue" class="form-control"  required><option value="null">Select</option> </select><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtAgreedShelfLevel_maxindexval" name="AgreedShelfLevel" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" disabled ></div></td></tr>',
        IdPlaceholderused: "maxindexval",
        TargetId: "#FirstGridId",
        TargetElement: ["tr"],
    }
    AddNewRowToDataGrid(inputpar);
    if (!linkCliked2) {
        $('#FirstGridId tr:last td:first input').focus();
    }
    else {
        linkCliked2 = false;
    }
    var rowCount = $('#FirstGridId tr:last').index();
    $.each(window.CategoryListGloabal, function (index, value) {
        $('#PpmCategoryId_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });

    $("input[id^='Description_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');

    formInputValidation("ppmchecklistFormId");
}


$('#FirstGrid').click(function () {

    var rowCount = $('#FirstGridId tr:last').index();
    if (rowCount < 0)
        AddFirstGridRow();
    else {
        AddFirstGridRow();
    }
});

$('#chkCategory1DeleteAll').on('click', function () {
    var isChecked = $(this).prop("checked");
    $('#FirstGridId tr').each(function (index, value) {
        if (isChecked) {
            $('#IsDeletedCategory_' + index).prop('checked', true);
            // $('#IsDeletedCategory_' + index).parent().addClass('bgDelete');
            $('#PpmCategoryId_' + index).removeAttr('required');
            $('#Description_' + index).removeAttr('required');
            $('#PpmCategoryId_' + index).parent().removeClass('has-error');
            $('#Description_' + index).parent().removeClass('has-error');

        }
        else {
            $('#PpmCategoryId_' + index).attr('required', true);
            $('#Description_' + index).attr('required', true);
            $('#IsDeletedCategory_' + index).prop('checked', false);
        }
    });
});

function EmptyFields() {
    $('#FirstGridId').empty();
    $('#StkAdjustmentTbl').empty();
    $(".content").scrollTop(0);
    $('#hdnAttachId').val('');
    $('.btnDelete').hide();
    $('#txtDocumentNo').val('');
    $('#txtInjectionDate').val('');
    $('#txtRemarks').val('');
    $('#spnActionType').text('Add');
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $('#btnSave').show();
    $('#primaryID').val('');
    $("#grid").trigger('reloadGrid');
    $("#Departmentform :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#SelStatus').val(1);
    $('#txtUserAreaCode').val('');
    $('#txtUserAreaName').val('');
    $('#txtHospitalRepresentative').val('');
    $('#txtHospitalRepresentativeDesignation').val('');
    $('#txtEffectiveFormDate').val('');
    $('#txtEffectiveToDate').val('');
    $('#txtstatus').val('1');
    $('#txtOperatingDays').val('null');
    $('#txtWhiteBag').val('');
    $('#txtRedBag').val('');
    $('#txtGreenBag').val('');
    $('#txtBrownBag').val('');
    $('#txtAlginateBag').val('');
    $('#txtSoiledLinenBagHolder').val('');
    $('#txtRejectLinenBagHolder').val('');
    $('#txtsoiledLinenRack').val('');
    $('#PpmCategoryId_').val('null');
    $('#startTime').val('');
    $('#EndTime').val('');
    $('#selectDay').val('null');
    AddFirstGridRow();
    AddNewRowStkAdjustment();
};



