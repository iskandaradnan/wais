$(document).ready(function () {
    $('.btnDelete').hide();
    $.get("/api/LinenAdjustments/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            AddFirstGridRow();
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });
})
var AuthorisedByFetchObj = {
    SearchColumn: 'txtTypeCode-StaffName',
    ResultColumns: ["UserRegistrationId-Primary Key", 'StaffName-StaffName'],
    FieldsToBeFilled: ["hdnTypeCodeId-UserRegistrationId", "txtTypeCode-StaffName"]
};

$('#txtTypeCode').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divTypeCodeFetch', AuthorisedByFetchObj, "/api/Fetch/LinenAdjustmentTxn_FetchAuthorisedBy", "UlFetch1", event, 1);
});

var InventoryDocNoFetchObj = {
    SearchColumn: 'txtContactPerson-DocumentNo',//Id of Fetch field
    ResultColumns: ["LinenInventoryIds-Primary Key", 'DocumentNo-DocumentNo','Date-Date'],
    FieldsToBeFilled: ["txtStaffMasterId-LinenInventoryIds", "txtContactPerson-DocumentNo","txtDate-Date"]
};

$('#txtContactPerson').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divFetchContactPerson', InventoryDocNoFetchObj, "/api/Fetch/LinenAdjustmentTxn_FetchInventoryDocNo", "UlFetch2", event, 1);//1 -- pageIndex
});
$(".btnSave,.btnEdit").click(function () {    
    $('#btnlogin').attr('disabled', true);
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#txtDocumentDate').attr('required', true);
    $('#txtTypeCode').attr('required', true);
    $('#LinenCodeId_').attr('required', true);
    $('#txtActualQuantity_').attr('required', true);
    $('#txtJustification_').attr('required', true);

    var _index;     
    var result = [];
    $('#ContactGrid tr').each(function () {
        _index = $(this).index();
    });
    
    for (var i = 0; i <= _index; i++) {
        var active = true;
        var isDeletedcat = $('#IsDeletedCategory_' + i).prop('checked');
        var LinenAdjustmentDetId = $('#LinenAdjustmentDetId_' + i).val();
        var _tempObj = {
            LinenAdjustmentDetId: $('#LinenAdjustmentDetId_' + i).val(),
            LinenCode: $('#txtLinenCode_' + i).val(),
            LinenItemId: $('#LinenCodeId_' + i).val(),
            ActualQuantity: $('#txtActualQuantity_' + i).val(),
            StoreBalance: $('#txtStoreBalance_' + i).val(),
            AdjustQuantity: $('#txtAdjustQuantity_' + i).val(),
            Justification: $('#txtJustification_' + i).val(),
            IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
        }
        result.push(_tempObj);
    }
    var CurrentbtnID = $(this).attr("value");
    var timeStamp = $("#Timestamp").val();

    var isFormValid = formInputValidation("FrmADJ", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }
    var MstLinenAdjust = {
        DocumentNo: $('#txtDocumentNo').val(),
        DocumentDate: $('#txtDocumentDate').val(),
        AuthorisedBy: $('#hdnTypeCodeId').val(),
        AuthorisedById: $('#hdnTypeCodeId').val(),
        LinenInventoryIds: $('#txtStaffMasterId').val(),
        Status: $("#txtStatus option:selected").val(),
        Date: $('#txtDate').val(),
        Remarks: $('#txtRemarks').val(),
        LLinenAdjustmentLinenItemListGrid: result
    };

    function chkIsDeletedRow(i, delrec) {
        if (delrec == true) {
            $('#txtLinenCode_' + i).prop("required", false);
            $('#txtLinenDescription_' + i).prop("required", false);
            $('#txtActualQuantity_' + i).prop("required", false);
            $('#txtStoreBalance_' + i).prop("required", false);
            $('#txtAdjustQuantity_' + i).prop("required", false);
            $('#txtJustification_' + i).prop("required", false);
           
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
        MstLinenAdjust.LinenAdjustmentId = primaryId;
        MstLinenAdjust.Timestamp = timeStamp;
    }
    else {
        MstLinenAdjust.LinenAdjustmentId = 0;
        MstLinenAdjust.Timestamp = "";
    }

    var jqxhr = $.post("/api/LinenAdjustments/Save", MstLinenAdjust, function (response) {
        var result = JSON.parse(response);
        $("#primaryID").val(result.LinenAdjustmentId);
        if (result != null && result.LLinenAdjustmentLinenItemListGrid != null && result.LLinenAdjustmentLinenItemListGrid.length > 0) {
            BindSecondGridData(result);
        }
        $("#Timestamp").val(result.Timestamp);
        $('#hdnStatus').val(result.Active);
        $("#grid").trigger('reloadGrid');
        if (result.LinenAdjustmentId != 0) {
            $('#hdnAttachId').val(result.HiddenId);
            $('#txtDocumentNo').val(result.DocumentNo);
            $('#txtDocumentDate').prop('disabled', true);
            $('#txtTypeCode').prop('disabled', true);
            $('#txtContactPerson').prop('disabled', true);
            $('#btnNextScreenSave').show();
            $('.btnEdit').hide();
            $('.btnSave').show();
            $('.btnDelete').hide();
        }
        $(".content").scrollTop(0);
        showMessage('LinenAdjustments', CURD_MESSAGE_STATUS.SS);
        $("#top-notifications").modal('show');
        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);

        $('.btnSave').attr('disabled', false);
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

            $('.btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
});


//************************************************ Getbyid bind data *************************

function BindSecondGridData(getResult) {
    var ActionType = $('#ActionType').val();
    $("#ContactGrid").empty();
    $.each(getResult.LLinenAdjustmentLinenItemListGrid, function (index, value) {
        AddFirstGridRow();
        $("#LinenAdjustmentDetId_" + index).val(getResult.LLinenAdjustmentLinenItemListGrid[index].LinenAdjustmentDetId);
        $("#LinenCodeId_" + index).val(getResult.LLinenAdjustmentLinenItemListGrid[index].LinenAdjustmentDetId);
        $("#txtLinenCode_" + index).val(getResult.LLinenAdjustmentLinenItemListGrid[index].LinenCode).attr('disabled', true);
        $("#txtLinenDescription_" + index).val(getResult.LLinenAdjustmentLinenItemListGrid[index].LinenDescription).attr('disabled', true);
        $("#txtActualQuantity_" + index).val(getResult.LLinenAdjustmentLinenItemListGrid[index].ActualQuantity).attr('disabled', true);
        $("#txtStoreBalance_" + index).val(getResult.LLinenAdjustmentLinenItemListGrid[index].StoreBalance).attr('disabled', true);
        $("#txtAdjustQuantity_" + index).val(getResult.LLinenAdjustmentLinenItemListGrid[index].AdjustQuantity).attr('disabled', true);
        $("#txtJustification_" + index).val(getResult.LLinenAdjustmentLinenItemListGrid[index].Justification);
        linkCliked2 = true;
        $(".content").scrollTop(0);
    });

    //************************************************ Grid Pagination *******************************************

    if ((getResult.LLinenAdjustmentLinenItemListGrid && getResult.LLinenAdjustmentLinenItemListGrid.length) > 0) {
        GridtotalRecords = getResult.LLinenAdjustmentLinenItemListGrid[0].TotalRecords;
        TotalPages = getResult.LLinenAdjustmentLinenItemListGrid[0].TotalPages;
        LastRecord = getResult.LLinenAdjustmentLinenItemListGrid[0].LastRecord;
        FirstRecord = getResult.LLinenAdjustmentLinenItemListGrid[0].FirstRecord;
        pageindex = getResult.LLinenAdjustmentLinenItemListGrid[0].PageIndex;
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

function FetchLinenCode(event, index) {
    $('#divLinenCodeFetch_' + index).css({
        'top': $('#txtLinenCode_' + index).offset().top - $('#LinenADJProvider').offset().top + $('#txtLinenCode_' + index).innerHeight(),
    });
    var LinenFetchObj = {
        SearchColumn: 'txtLinenCode_' + index + '-LinenCode',//Id of Fetch field
        ResultColumns: ["LinenItemId-Primary Key", 'LinenCode' + '-txtLinenCode_' + index],
        FieldsToBeFilled: ["LinenCodeId_" + index + "-LinenItemId", 'txtLinenCode_' + index + '-LinenCode', 'txtLinenDescription_' + index + '-LinenDescription']
    };

    DisplayFetchResult('divLinenCodeFetch_' + index, LinenFetchObj, "/api/Fetch/LinenAdjustmentTxnDet_FetchLinenCode", "UlFetch3" + index + "", event , 1);//1 -- pageIndex
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



function LinkClicked(LinenAdjustmentId) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#FrmADJ :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(LinenAdjustmentId);
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
        $("#FrmADJ :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('.btnSave').show();
        //$('.btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/LinenAdjustments/Get/" + primaryId)
            .done(function (result) {               
                var getResult = JSON.parse(result);
                $('#txtDocumentNo').val(getResult.DocumentNo).attr('disabled', true);
                $('#txtDocumentNo').val(getResult.DocumentNo);
                $('#txtDocumentDate').val(moment(getResult.DocumentDate).format("DD-MMM-YYYY")).attr('disabled', true);           
                $('#txtTypeCode').val(getResult.AuthorisedBy);
                $('#hdnTypeCodeId').val(getResult.AuthorisedById);
                $('#txtContactPerson').val(getResult.LinenInventoryId).attr('disabled', true);
                $('#txtStaffMasterId').val(getResult.LinenInventoryId).attr('disabled', true);
                if (getResult.Date != 0)
                {

                }
                else
                {
                    $('#txtDate').val(moment(getResult.Date).format("DD-MMM-YYYY")).attr('disabled', true);
                }
                
                $('#txtStatus').val(getResult.Status).attr('disabled', true);
                $('#txtRemarks').val(getResult.Remarks);
                $('#primaryID').val(getResult.LinenAdjustmentId);              
                $('#hdnAttachId').val(getResult.HiddenId);
                $('.btnDelete').hide();
                $('.btnEdit').hide();
                $('#myPleaseWait').modal('hide');
                if (getResult != null && getResult.LLinenAdjustmentLinenItemListGrid != null && getResult.LLinenAdjustmentLinenItemListGrid.length > 0) {
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
            $.get("/api/LinenAdjustments/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    EmptyFields();
                    $(".content").scrollTop(0);
                    showMessage('LinenAdjustments', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                   
                })
                .fail(function () {
                    showMessage('LinenAdjustments', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                });
        }

    });
}
$("#btnNextScreenSave").click(function () {
    var primaryId = $("#primaryID").val();

    var hdnStatus = $("#hdnStatus").val();

    if (hdnStatus == 0 || hdnStatus == '0') {
        bootbox.alert('Only Active LinenAdjust can be navigated to Level Screen');

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
    $('#txtDocumentDate').val('').prop('disabled', false);
    $('#txtStatus ').val('1');
    $('#txtAuthorisedBy').val('').prop('disabled', false);
    $('#txtLinenInventoryDocumentNo').val('').prop('disabled', false);
    $('#txtDate').val('');
    $('#txtTypeCode').val('').prop('disabled', false);
    $('#txtContactPerson').val('').prop('disabled', false);
    $('#txtRemarks').val('');
    $('#spnActionType').text('Add');
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $('.btnSave').show();
    $('#primaryID').val('');
    $("#grid").trigger('reloadGrid');
    //$("#FrmADJ :input:not(:button)").parent().removeClass('has-error');
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
    var ActualQuantity = $('#txtActualQuantity_' + rowCount).val();
    var Justification = $('#txtJustification_' + rowCount).val();
    if (rowCount < 0)
        AddFirstGridRow();
    else if (rowCount >= "0" && (LinenCode == "" || ActualQuantity == "" || Justification == "")) {
        bootbox.alert("Please fill the last record");
    }
    else {
        AddFirstGridRow();
    }
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
var linkCliked1 = false;
window.AddFirstGridRow = function () {
    $('#chkContactDeleteAll').prop('checked', false);
    var inputpar = {
        inlineHTML: '<tr class="ng-scope" style=""> ' +
            '<td width="5%" style="text-align:center"> <input type="checkbox" value="false" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(ContactGrid,chkContactDeleteAll)" tabindex="0"></td>' +
            //'<td width="10%" style="text-align: center;"><div><input type="hidden" id= "LinenAdjustmentDetId_maxindexval"> <input type="text" id="txtLinenCode_maxindexval"  placeholder="Please Select" name="txtLinenCode" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" required ></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtLinenCode_maxindexval" name="LinenCode" required maxlength="50"   onkeyup="FetchLinenCode(event,maxindexval)" onpaste="FetchLinenCode(event,maxindexval)" change="FetchLinenCode(event,maxindexval)"oninput="FetchLinenCode(event,maxindexval)"  class="form-control" autocomplete="off" tabindex="0" required  placeholder="Please Select"><input type="hidden" id="LinenCodeId_maxindexval" required/><input type="hidden" id="LinenCodeUpdateDetId_maxindexval"/> <input type="hidden" id="LinenAdjustmentDetId_maxindexval"/><div class="col-sm-12" id="divLinenCodeFetch_maxindexval"></div></div></td>< td width="15%" style="text-align: center;"><div> ' +
            '<td width="20%" style="text-align: center;"><div><input type="text" id="txtLinenDescription_maxindexval" disabled name="LinenDescription" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"  ></div></td><div> ' +
            '<td width="20%" style="text-align: center;"><div><input type="text" id="txtActualQuantity_maxindexval" name="txtActualQuantity" required maxlength="50"  class="form-control" autocomplete="off" tabindex="0" required ></div></td><div> ' +
            '<td width="15%" style="text-align: center;"><div><input type="text" id="txtStoreBalance_maxindexval" disabled name="txtStoreBalance" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"  ></div></td><div> ' +
            '<td width="15%" style="text-align: center;"><div><input type="text" id="txtAdjustQuantity_maxindexval" disabled name="txtAdjustQuantity" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"  ></div></td><div> ' +
            '<td width="15%" style="text-align: center;"><div><input type="text" id="txtJustification_maxindexval" name="txtJustification" required maxlength="50"  class="form-control" autocomplete="off" tabindex="0" required ></div></td><div></tr>',
        IdPlaceholderused: "maxindexval",
        TargetId: "#ContactGrid",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    //$("input[id^='txtGeneratedDemerit_'], input[id^='txtFinalDemerit_']").attr('pattern', '^[0-9]+$');
    $("input[id^='txtLinenCode_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtLinenDescription_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtActualQuantity_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtStoreBalance_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtAdjustQuantity_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtJustification_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');

    if (!linkCliked1) {
        $('#ContactGrid tr:last td:first input').focus();
    }
    else {
        linkCliked1 = false;
    }
    formInputValidation("FrmADJ");

}

////////////////////*********** End Add rows **************//