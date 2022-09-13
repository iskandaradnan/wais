$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    $('.btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $.get("/api/LinenInjection/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $.each(loadResult.LinenInjection, function (index, value) {
               // $('#txtCentralCleanLinenStore').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
             window.ClassGradeListGlobal = loadResult.IssuingBody;
             AddFirstGridRow();
        })

        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });

});
var LinenCodeFetchObj = {
    SearchColumn: 'txtLinencode-UserAreaCode',//Id of Fetch field
    ResultColumns: ["UserAreaId-Primary Key", 'UserAreaCode-UserAreaCode', 'UserAreaName-UserAreaName', 'ActiveFromDate-ActiveFromDate', 'ActiveToDate-ActiveToDate'],
    FieldsToBeFilled: ["hdnUserAreaId-UserAreaId", "txtLinencode-UserAreaCode", "txtUserAreaName-UserAreaName", "txtEffectiveFormDate-ActiveFromDate", "txtEffectiveToDate-ActiveToDate",]
};

//$('#txtLinencode').on('input propertychange paste keyup', function (event) {
//    DisplayFetchResult('divUserAreaFetch', LinenCodeFetchObj, "/api/Fetch/LinenInjectionTxnDet_FetchLinenCode", "UlFetch2", event, 1);//1 -- pageIndex
//});

//var UserAreaFetchObj = {
//    SearchColumn: 'txtDonoId-DONO',//Id of Fetch field
//    ResultColumns: ["DOId-Primary Key", 'DONO-DONO', 'PONO-PONO','DODATE-DODATE'],
//    FieldsToBeFilled: ["hdnDonoId-DOId", "txtDonoId-DONO", "txtPoNo-PONO", "txtDoDate-DODATE"]
//};

//$('#txtDonoId').on('input propertychange paste keyup', function (event) {
//    DisplayFetchResult('divDonoFetch', UserAreaFetchObj, "/api/Fetch/LLSLinenInjectionTxn_FetchDONo", "UlFetch1", event, 1);//1 -- pageIndex
//});

$(".btnSave,.btnEdit,#btnSaveandAddNew").click(function () { 
    $('#btnlogin').attr('disabled', true);
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');

    $('#txtInjectionDate').attr('required', true);
    $('#txtDoNo').attr('required', true);
    $('#txtLinenCode_').attr('required', true);
    $('#txtQuantityInjected_').attr('required', true);
   
    var CurrentbtnID = $(this).attr("value");
    var timeStamp = $("#Timestamp").val();
    var isFormValid = formInputValidation("FrmLinenInjection", 'save');
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
        var LinenInjectionDetId = $('#LinenInjectionDetId_' + i).val();
        var _tempObj = {
            LinenInjectionDetId: $('#LinenInjectionDetId_' + i).val(),
            LinenCode: $('#txtLinenCode_' + i).val(),
            LinenDescription: $('#txtLinenDescription_' + i).val(),
            LinenPrice: $('#txtLinenPrice_' + i).val(),
            LinenItemId: $('#LinenCodeId_' + i).val(), 
            QuantityInjected: $('#txtQuantityInjected_' + i).val(),           
            LifeSpanValidity: $('#txtLifeSpanValidity_' + i).val(),   
            IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
        }
        result.push(_tempObj);
    }
    var timeStamp = $("#Timestamp").val();
    var MstLinenInjection = {
        DocumentNo: $('#txtDocumentNo').val(),
        InjectionDate: $('#txtInjectionDate').val(),
        DONo: $('#txtDonoId').val(),
        DODate: $('#txtDoDate').val(),
        PONo: $('#txtPoNo').val(),
        Remarks: $('#txtRemarks').val(),
        GuId: $('#hdnAttachId').val(),
        LLinenInjectionLinenItemListGrid: result
    };

    function chkIsDeletedRow(i, delrec) {
        if (delrec == true) {
            $('#txtLinenCode_' + i).prop("required", false);
            $('#txtLinenDescription_' + i).prop("required", false);
            $('#txtLinenPrice_' + i).prop("required", false);
            $('#txtQuantityInjected_' + i).prop("required", false);
            $('#txtTestReport_' + i).prop("required", false);
            $('#txtLifeSpanValidity_' + i).prop("required", false);
           
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
        MstLinenInjection.LinenInjectionId = primaryId;
        MstLinenInjection.Timestamp = timeStamp;
    }
    else {
        MstLinenInjection.LinenInjectionId = 0;
        MstLinenInjection.Timestamp = "";
    }
    var deletedCount = Enumerable.From(result).Where(x => x.IsDeleted).Count();
    var Isdeleteavailable = deletedCount > 0;
    if (deletedCount == result.length && TotalPages == 1) {
        bootbox.alert("Sorry!. You cannot delete all rows");
        $('#myPleaseWait').modal('hide');
        return false;
    }

    var jqxhr = $.post("/api/LinenInjection/Save", MstLinenInjection, function (response) {
        var result = JSON.parse(response);
        $("#primaryID").val(result.LinenInjectionId);
        $("#Timestamp").val(result.Timestamp);
        if (result != null && result.LLinenInjectionLinenItemListGrid != null && result.LLinenInjectionLinenItemListGrid.length > 0) {
            BindSecondGridData(result);
        }
        $('#hdnStatus').val(result.Active);

        $("#grid").trigger('reloadGrid');
        if (result.LinenInjectionId != 0) {
            $('#hdnAttachId').val(result.HiddenId);          
            $('#txtDocumentNo').val(result.DocumentNo);
            $('#txtDonoId').val(result.DONo);
            $('#txtDoDate').val(moment(result.DODate).format("DD-MMM-YYYY"));
            $('#txtPoNo').val(result.PONo);
            $('#btnNextScreenSave').show();
            $('.btnEdit').hide();
            $('#btnSave').hide();
            $('.btnDelete').hide();
        }
        $(".content").scrollTop(0);
        showMessage('LinenInjection', CURD_MESSAGE_STATUS.SS);
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

//************************************************ Getbyid bind data *************************

function BindSecondGridData(getResult) {
    var ActionType = $('#ActionType').val();
    $("#ContactGrid").empty();
    $.each(getResult.LLinenInjectionLinenItemListGrid, function (index, value) {
        AddFirstGridRow();
       // $("#txtTestReport_" + index).val(getResult.LLinenInjectionLinenItemListGrid[index].Guid);
        $("#LinenCodeId_" + index).val(getResult.LLinenInjectionLinenItemListGrid[index].LinenInjectionDetId);
        $("#LinenInjectionDetId_" + index).val(getResult.LLinenInjectionLinenItemListGrid[index].LinenInjectionDetId);
        $("#txtLinenCode_" + index).val(getResult.LLinenInjectionLinenItemListGrid[index].LinenCode);
        $("#txtLinenDescription_" + index).val(getResult.LLinenInjectionLinenItemListGrid[index].LinenDescription);
        $("#txtLinenPrice_" + index).val(getResult.LLinenInjectionLinenItemListGrid[index].LinenPrice);
        $("#txtQuantityInjected_" + index).val(getResult.LLinenInjectionLinenItemListGrid[index].QuantityInjected);
        $("#txtDONo_" + index).val(getResult.LLinenInjectionLinenItemListGrid[index].DONo);
        $("#txtTestReport_" + index).val(getResult.LLinenInjectionLinenItemListGrid[index].TestReport);
        $("#txtLifeSpanValidity_" + index).val(moment(getResult.LLinenInjectionLinenItemListGrid[index].LifeSpanValidity).format("DD-MMM-YYYY"))
        linkCliked2 = true;
        $(".content").scrollTop(0);
        
    });

    //************************************************ Grid Pagination *******************************************

    if ((getResult.LLinenInjectionLinenItemListGrid && getResult.LLinenInjectionLinenItemListGrid.length) > 0) {
        GridtotalRecords = getResult.LLinenInjectionLinenItemListGrid[0].TotalRecords;
        TotalPages = getResult.LLinenInjectionLinenItemListGrid[0].TotalPages;
        LastRecord = getResult.LLinenInjectionLinenItemListGrid[0].LastRecord;
        FirstRecord = getResult.LLinenInjectionLinenItemListGrid[0].FirstRecord;
        pageindex = getResult.LLinenInjectionLinenItemListGrid[0].PageIndex;
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
        FieldsToBeFilled: ["LinenCodeId_" + index + "-LinenItemId", 'txtLinenCode_' + index + '-LinenCode', 'txtLinenDescription_' + index + '-LinenDescription', 'txtLinenPrice_' + index + '-LinenPrice']
    };

    DisplayFetchResult('divLinenCodeFetch_' + index, LinenFetchObj, "/api/Fetch/LinenInjectionTxnDet_FetchLinenCode", "UlFetch2" + index + "", event, 1);//1 -- pageIndex
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


function LinkClicked(LinenInjectionId) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#FrmLinenInjection :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(LinenInjectionId);
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
        $("#FrmLinenInjection :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/LinenInjection/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                $('#txtDocumentNo').val(getResult.DocumentNo).attr('disabled', true);
                $('#txtDocumentNo').val(getResult.DocumentNo);
                $('#txtInjectionDate').val(moment(getResult.InjectionDate).format("DD-MMM-YYYY"));
                $('#txtDonoId').val(getResult.DONo);
                //$('#hdnDonoId').val(getResult.DOId);
                $('#txtDoDate').val(moment(getResult.DODate).format("DD-MMM-YYYY"));
                $('#txtPoNo').val(getResult.PONo);
                $('#txtRemarks').val(getResult.Remarks);
                $('#primaryID').val(getResult.LinenInjectionId);
                $('#hdnStatus').val(getResult.Active);              
                $('#hdnAttachId').val(getResult.GuId);
                $('#myPleaseWait').modal('hide');
                $('.btnEdit').hide();
                $('.btnDelete').hide();
                if (getResult != null && getResult.LLinenInjectionLinenItemListGrid != null && getResult.LLinenInjectionLinenItemListGrid.length > 0) {
                    BindSecondGridData(getResult);
                }
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

$(".btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/LinenInjection/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('LinenInjection', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('LinenInjection', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}
$("#btnNextScreenSave").click(function () {
    var primaryId = $("#primaryID").val();

    var hdnStatus = $("#hdnStatus").val();

    if (hdnStatus == 0 || hdnStatus == '0') {
        bootbox.alert('Only Active LinenInjection can be navigated to Level Screen');

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
    var QuantityInjected = $('#txtQuantityInjected_' + rowCount).val();
    if (rowCount < 0)
        AddFirstGridRow();
    else if (rowCount >= "0" && (LinenCode == "" || QuantityInjected== "")) {
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
            $('#txtLinenCode_' + index).removeAttr('required');
            $('#txtLinenCode_' + index).parent().removeClass('has-error');
            // count++;
            //  }
        }
        else {
            //if(!$('#chkContactDelete_' +index1).prop('disabled'))
            //{
            $('#txtLinenCode_' + index).attr('required', true);
            $('#chkContactDelete_' + index).prop('checked', false);
            $('#chkContactDelete_' + index).parent().removeClass('bgDelete');
            // }
        }
    });
    //if(count == 0){
    //    $(this).prop("checked", false);
    //}
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
            '<td width="5%" style="text-align:center"> <input type="checkbox"  value="false" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(ContactGrid,chkContactDeleteAll)" tabindex="0"></td>' +
            '<td width="20%" style="text-align: center;"><div><input type="text" id="txtLinenCode_maxindexval" name="LinenCode" required maxlength="50"   onkeyup="FetchLinenCode(event,maxindexval)" onpaste="FetchLinenCode(event,maxindexval)" change="FetchLinenCode(event,maxindexval)"oninput="FetchLinenCode(event,maxindexval)"  class="form-control" autocomplete="off" tabindex="0" required  placeholder="Please Select"><input type="hidden" id="LinenCodeId_maxindexval" required/><input type="hidden" id="LinenCodeUpdateDetId_maxindexval"/> <input type="hidden" id="LinenInjectionDetId_maxindexval"/><div class="col-sm-12" id="divLinenCodeFetch_maxindexval"></div></div></td>< td width="15%" style="text-align: center;"><div> ' +
            //'<td width="15%" style="text-align: center;"><div><input type="text" id="txtLinenCode_maxindexval"  placeholder="Please Select" name="txtLinenCode" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" required ></div></td><div> ' +
            //'<td width="15%" style="text-align: center;"><div><input type="text" id="txtLinenCode_maxindexval" name="LinenCode" required maxlength="50"   onkeyup="FetchLinenCode(event,maxindexval)" onpaste="FetchLinenCode(event,maxindexval)" change="FetchLinenCode(event,maxindexval)"oninput="FetchLinenCode(event,maxindexval)"  class="form-control" autocomplete="off" tabindex="0" required  placeholder="Please Select"><input type="hidden" id="LinenInjectionDetId_maxindexval"/><input type="hidden" id="LinenCodeUpdateDetId_maxindexval"/> <div class="col-sm-12" id="divLinenCodeFetch_maxindexval"></div > </div></td>< td width="15%" style="text-align: center;" > <div> ' +
            '<td width="21%" style="text-align: center;"><div><input type="text" id="txtLinenDescription_maxindexval" disabled name="LinenDescription" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="14%" style="text-align: center;"><div><input type="text" id="txtLinenPrice_maxindexval"  name="LinenPrice" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="20%" style="text-align: center;"><div><input type="text" id="txtQuantityInjected_maxindexval" name="txtQuantityInjected" required maxlength="50"  class="form-control" autocomplete="off" tabindex="0" required ></div></td><div> ' +
            //'<td width="20%" style="text-align: center;"><div><input type="file" id="txtTestReport_maxindexval" name="txtTestReport" maxlength="50" class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="20%" style="text-align: center;"><div><input type="text" id="txtLifeSpanValidity_maxindexval"  name="txtLifeSpanValidity" class="form-control datetime" disabled autocomplete="off" tabindex="0"></div></td><div></tr>',
        IdPlaceholderused: "maxindexval",
        TargetId: "#ContactGrid",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    //$("input[id^='txtGeneratedDemerit_'], input[id^='txtFinalDemerit_']").attr('pattern', '^[0-9]+$');
    $("input[id^='txtLinenCode_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtLinenDescription_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtLinenPrice_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtQuantityInjected_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtDONo_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    //$("input[id^='txtTestReport_']").attr('pattern', '^[a-zA-Z./\\(\\),\\-\\s]+$');
    //$("input[id^='txtLifeSpanValidity_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');


    if (!linkCliked1) {
        $('#ContactGrid tr:last td:first input').focus();
    }
    else {
        linkCliked1 = false;
    }
    formInputValidation("FrmLinenInjection");

}
function EmptyFields() {
    $('#ContactGrid').val('');
    $(".content").scrollTop(0);
    $('#hdnAttachId').val('');
    $('.btnDelete').hide();
    $('#txtDocumentNo').val('');
    $('#txtInjectionDate').val('');
    $('#txtRemarks').val('');
    $('#SelStatus').val(1);
    $('#txtDonoId').val('');
    $('#txtDoDate').val('');
    $('#txtPoNo').val('');
    $('#ContactGrid').empty();
    $('#spnActionType').text('Add'); 
    $('#btnEdit').hide();
    $('#txtLinenCode_').val('');
    $('#txtLinenDescription_').val('');
    $('#txtLinenPrice_').val('');
    $('#txtQuantityInjected_').val('');
    $('#txtTestReport_').val('');
    $('#txtLifeSpanValidity_').val('');
    $('#btnNextScreenSave').hide();
    $('#btnSave').show();
    $('#primaryID').val('');
    $("#grid").trigger('reloadGrid');
    // $("#FrmLinenInjection :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    AddFirstGridRow();

}

////////////////////*********** End Add rows ************//