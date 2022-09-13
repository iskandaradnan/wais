//********************************************************************************
$(document).ready(function () {
    window.CategoryListGloabal = [];
    $('#myPleaseWait').modal('show');
    $('.btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $('#txtModel').attr('disabled', true);
    $.get("/api/CleanLinenDespatch/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#jQGridCollapse1").click();
            $(loadResult.DespatchedFrom).each(function (_index, _data) {
                $('#txtDespatchedFrom').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))
            });
            AddFirstGridRow();
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });

});

var UserAreaFetchObj = {
    SearchColumn: 'txtUserAreaCode-ReceivedBy',//Id of Fetch field
    ResultColumns: ["UserRegistrationId-Primary Key", 'ReceivedBy-ReceivedBy'],
    FieldsToBeFilled: ["hdnUserAreaId-UserRegistrationId", "txtUserAreaCode-ReceivedBy"]
};

$('#txtUserAreaCode').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divUserAreaFetch', UserAreaFetchObj, "/api/Fetch/CleanLinenDespatchTxn_FetchReceivedBy", "UlFetch2", event, 1);//1 -- pageIndex
});


$('#txtLinencode').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divUserAreaFetch', LinenCodeFetchObj, "/api/Fetch/CleanLinenDespatchTxnDet_FetchLinenCode", "UlFetch2", event, 1);//1 -- pageIndex
});

function DisplayError() {
    $('#errorMsg').css('visibility', 'visible');
    $('#myPleaseWait').modal('hide');
    $('.btnSave').attr('disabled', false);
}
$(".btnSave,.btnEdit,#btnSaveandAddNew").click(function () {
    $('#btnlogin').attr('disabled', true);
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#txtReceivedDateTime').attr('required', true);
    $('#txtDespatchedFrom').attr('required', true);
    $('#txtUserAreaCode').attr('required', true);
    $('#txtNoofPackages').attr('required', true);
    $('#txtTotalWeight').attr('required', true);
    $('#txtDespatched_').attr('required', true);
    $('#txtRecievedQuantity_').attr('required', true);
    var isFormValid = formInputValidation("FrmLinenClean", 'save');
    var CurrentbtnID = $(this).attr("value");
    var timeStamp = $("#Timestamp").val();
    //var ReceivedBy = $('#hdnUserAreaId').val();
    //var ReceivedBys = $('#txtUserAreaCode').val();
    //if (ReceivedBy == '' && ReceivedBys != '') {
    //    DisplayErrorMessage("Please enter valid ReceivedBy");
    //    $('#myPleaseWait').modal('hide');
    //    return false;
    //}
    //var rowCount = $('#ContactGrid tr:last').index();
    //for (var i = 0; i <= rowCount; i++) {
    //    LinenItemId = parseInt(document.getElementById("LinenCodeId_" + i).value);
    //    LinenItemId = isNaN(LinenItemId) ? "" : LinenItemId;

    //    if (LinenItemId == " " || LinenItemId == "" || LinenItemId == null) {
    //        DisplayErrorMessage("Please enter valid Linen Code");
    //        $('#myPleaseWait').modal('hide');
    //        return false;
    //    }
    //    else (LinenItemId != " " || LinenItemId != "" || LinenItemId != null) 
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

    var _index;       
    var result = [];
    $('#ContactGrid tr').each(function () {
        _index = $(this).index();
    });
    for (var i = 0; i <= _index; i++) {
        var active = true;
        var isDeletedcat = $('#IsDeletedCategory_' + i).prop('checked');
        var LinenInjectionDetId = $('#LinenInjectionDetId_' + i).val();
        var _tempObj = {
            CleanLinenDespatchDetId: $('#CleanLinenDespatchDetId_' + i).val(),
            LinenCode: $('#txtLinenCode_' + i).val(),
            LinenDescription: $('#txtLinenDescription_' + i).val(),
            LinenItemId: $('#LinenCodeId_' + i).val(),
            DespatchedQuantity: $('#txtDespatched_' + i).val(),
            ReceivedQuantity: $('#txtRecievedQuantity_' + i).val(),
            Variance: $('#txtVariance_' + i).val(),
            Remarks: $('#txtRemarks_' + i).val(),
            IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
        }
        result.push(_tempObj);
    }
    var timeStamp = $("#Timestamp").val();
    var MstCleanLinenDespatch = {
        DocumentNo: $('#txtDespatchDocumentNo').val(),
        DateReceived: $('#txtReceivedDateTime').val(),
        DespatchedFrom: $('#txtDespatchedFrom').val(),
        ReceivedBy: $('#hdnUserAreaId').val(),
        NoOfPackages: $('#txtNoofPackages').val(),
        TotalWeightKg: $('#txtTotalWeight').val(),
        TotalReceivedPcs: $('#txtTotaReceived').val(),
        GuId: $('#hdnAttachId').val(),
        LUserCleanLinenItemGridList: result
    };

    function chkIsDeletedRow(i, delrec) {
        if (delrec == true) {
            $('#txtLinenCode_' + i).prop("required", false);
            $('#txtLinenDescription_' + i).prop("required", false);
            //$('#LinenCodeId_' + i).prop("required", false);
            $('#txtDespatched_' + i).prop("required", false);
            $('#txtRecievedQuantity_' + i).prop("required", false);
            $('#txtVariance_' + i).prop("required", false);
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
        MstCleanLinenDespatch.CleanLinenDespatchId = primaryId;
        MstCleanLinenDespatch.Timestamp = timeStamp;
    }
    else {
        MstCleanLinenDespatch.CleanLinenDespatchId = 0;
        MstCleanLinenDespatch.Timestamp = "";
    }
    //******************************************** Save *********************************************
    var jqxhr = $.post("/api/CleanLinenDespatch/Save", MstCleanLinenDespatch, function (response) {
        var result = JSON.parse(response);
        $("#primaryID").val(result.CleanLinenDespatchId);
        $("#Timestamp").val(result.Timestamp);
        $('#SelStatus option[value="' + result.Active + '"]').prop('selected', true);
        $('#hdnStatus').val(result.Active);
        if (result != null && result.LUserCleanLinenItemGridList != null && result.LUserCleanLinenItemGridList.length > 0) {
            BindSecondGridData(result);
        }
        $("#grid").trigger('reloadGrid');
        if (result.CleanLinenDespatchId != 0) {
            $('#hdnAttachId').val(result.HiddenId);
            $('#txtDespatchDocumentNo').val(result.DocumentNo);
            $('#btnNextScreenSave').show();
            $('#btnEdit').show();
            $('#btnSave').hide();
            $('.btnDelete').hide();
        }
        $(".content").scrollTop(0);
        showMessage('CleanLinenDespatch', CURD_MESSAGE_STATUS.SS);
        $("#top-notifications").modal('show');
        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);

        $('#btnSave').attr('disabled', false);
        $('#txtDespatchDocumentNo').attr('disabled', true);
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


function DisplayErrorMessage(errorMessage) {
    $("div.errormsgcenter").text(errorMessage);
    $('#errorMsg').css('visibility', 'visible');

    $('#btnSave').attr('disabled', false);
    $('#btnEdit').attr('disabled', false);
}
//---------------------------------------- Back & Addnew Button ----------------------------------


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



// **** Query String to get ID  End****\\\
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

//********************************* Fetch *****************************************

function FetchLinenCode(event, index) {
    $('#divLinenCodeFetch_' + index).css({
        'top': $('#txtLinenCode_' + index).offset().top - $('#ppmchecklistTable').offset().top + $('#txtLinenCode_' + index).innerHeight(),
    });
    var LinenFetchObj = {
        SearchColumn: 'txtLinenCode_' + index + '-LinenCode',//Id of Fetch field
        ResultColumns: ["LinenItemId-Primary Key", 'LinenCode' + '-txtLinenCode_' + index],
        FieldsToBeFilled: ["LinenCodeId_" + index + "-LinenItemId", 'txtLinenCode_' + index + '-LinenCode', 'txtLinenDescription_' + index + '-LinenDescription']
    };

    DisplayFetchResult('divLinenCodeFetch_' + index, LinenFetchObj, "/api/Fetch/CleanLinenDespatchTxnDet_FetchLinenCode", "UlFetch3" + index + "", event, 1);//1 -- pageIndex
}


//************************************************ Getbyid bind data *************************

function BindSecondGridData(getResult) {
    var ActionType = $('#ActionType').val();
    $("#ContactGrid").empty();
    $.each(getResult.LUserCleanLinenItemGridList, function (index, value) {
        AddFirstGridRow();
        $("#CleanLinenDespatchDetId_" + index).val(getResult.LUserCleanLinenItemGridList[index].CleanLinenDespatchDetId);
        $("#txtLinenCode_" + index).val(getResult.LUserCleanLinenItemGridList[index].LinenCode).attr('disabled', true);
        $("#LinenCodeId_" + index).val(getResult.LUserCleanLinenItemGridList[index].LinenItemId).attr('disabled', true);
        $("#txtLinenDescription_" + index).val(getResult.LUserCleanLinenItemGridList[index].LinenDescription);
        $("#txtDespatched_" + index).val(getResult.LUserCleanLinenItemGridList[index].DespatchedQuantity).attr('disabled', true);
        $("#txtRecievedQuantity_" + index).val(getResult.LUserCleanLinenItemGridList[index].ReceivedQuantity);
        $("#txtVariance_" + index).val(getResult.LUserCleanLinenItemGridList[index].Variance);
        $("#txtRemarks_" + index).val(getResult.LUserCleanLinenItemGridList[index].Remarks);
        linkCliked2 = true;
        $(".content").scrollTop(0);
    });
    //************************************************ Grid Pagination *******************************************

    if ((getResult.LUserCleanLinenItemGridList && getResult.LUserCleanLinenItemGridList.length) > 0) {
        GridtotalRecords = getResult.LUserCleanLinenItemGridList[0].TotalRecords;
        TotalPages = getResult.LUserCleanLinenItemGridList[0].TotalPages;
        LastRecord = getResult.LUserCleanLinenItemGridList[0].LastRecord;
        FirstRecord = getResult.LUserCleanLinenItemGridList[0].FirstRecord;
        pageindex = getResult.LUserCleanLinenItemGridList[0].PageIndex;
        linkCliked2 = true;
        $(".content").scrollTop(0);
    }
    $('#paginationfooter').show();


   }


//**************************** Grid merging***************************//

function LinkClicked(CleanLinenDespatchId) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#FrmLinenClean :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('.btnEdit').hide();
    $('.btnDelete').show();
    var action = "";
    $('#primaryID').val(CleanLinenDespatchId);
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
        $("#FrmLinenClean :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/CleanLinenDespatch/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                $('#txtDespatchDocumentNo').val(getResult.DocumentNo);
                $('#txtReceivedDateTime').val(moment(getResult.DateReceived).format("DD-MMM-YYYY HH:mm")).attr('disabled', true);
               // $('#txtReceivedDateTime').val(getResult.DateReceived);
                $('#txtDespatchedFrom').val(getResult.LaundryPlantID);
                $('#txtUserAreaCode').val(getResult.ReceivedBy);
                $('#txtNoofPackages').val(getResult.NoOfPackages);
                $('#txtTotalWeight').val(getResult.TotalWeightKg);
                $('#txtEffectiveFormDate').val(getResult.EffectiveFromDate);
                $('#txtTotaReceived').val(getResult.TotalReceivedPcs);
                $('#hdnUserAreaId').val(getResult.ReceivedB);
                $('#primaryID').val(getResult.CleanLinenDespatchId);
                $('#hdnStatus').val(getResult.Active);
                $('#hdnAttachId').val(getResult.GuId);
                $('#myPleaseWait').modal('hide');
                $('.btnDelete').hide();
                if (getResult != null && getResult.LUserCleanLinenItemGridList != null && getResult.LUserCleanLinenItemGridList.length > 0) {
                    BindSecondGridData(getResult);
                }

                $('#txtReceivedDateTime').attr('disabled', true);
                $('#txtDespatchedFrom').attr('disabled', true);
                $('#txtUserAreaCode').attr('disabled', true);
                $('#txtNoofPackages').attr('disabled', true);
                $('#txtTotalWeight').attr('disabled', true);
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
            $.get("/api/CleanLinenDespatch/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('CleanLinenDespatch', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('CleanLinenDespatch', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}
$("#btnNextScreenSave").click(function () {
    var primaryId = $("#primaryID").val();

    var hdnStatus = $("#hdnStatus").val();

    if (hdnStatus == 0 || hdnStatus == '0') {
        bootbox.alert('Only Active CleanLinenDespatch can be navigated to Level Screen');

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
    // $('#dataTableTaskDetails').empty();
    $('#ContactGrid').empty();
    $(".content").scrollTop(0);
    $('#hdnAttachId').val('');
    $('.btnDelete').hide();
    $('#txtDespatchDocumentNo').val('');
    $('#txtReceivedDateTime').val('');
    $('#txtReceivedDateTime').prop('disabled', false);
    $('#txtDespatchedFrom').val('');
    $('#txtDespatchedFrom').prop('disabled', false);
    $('#txtReceivedBy').val('');
    $('#txtNoofPackages').val('');
    $('#txtNoofPackages').prop('disabled', false);
    $('#txtTotalWeight').val('');
    $('#txtTotalWeight').prop('disabled', false);
    $('#txtUserAreaCode').val('');
    $('#txtUserAreaCode').prop('disabled', false);
    $('#txtEffectiveFormDate').val('');
    $('#txtTotaReceived').val('');
    $('#spnActionType').text('Add');
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $('#btnSave').show();
    $('#primaryID').val('');
    $("#grid").trigger('reloadGrid');
    $("#FrmLinenClean :input:not(:button)").parent().removeClass('has-error');
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

function duplicateCheck(index) {
    var rowCount = $('#ContactGrid tr:last').index();
    var rowCount_ID = rowCount;
        allow = 0;
        for (var krows = 0; krows <= rowCount; krows++) {
            for (var krow = 0; krow <= rowCount_ID; krow++) {
                if (krows != krow) {
                    var actual = $('#txtLinenCode_' + krows).val();
                    var current = $('#txtLinenCode_' + krow).val()
                    if (actual == current) {
                        alert("Already Exist Linencode");
                        allow = 1;
                        $('#txtLinenCode_' + krow).val('');
                        $('#txtLinenDescription_' + krow).val('');
                        $('#txtDespatched_' + krow).val('');
                        $('#txtRecievedQuantity_' + krow).val('');
                        $('#txtVariance_' + krow).val('');
                    } else {

                        //alert("not found");
                    }

                } else {
                }

            }
        }
        
    }
$('#contactBtn').click(function ()
{

    var rowCount = $('#ContactGrid tr:last').index();
    var rowCount_ID = rowCount;
    var LocationCode = $('#txtLocationCode_' + rowCount).val();
    var LinenCode = $('#txtLinenCode_' + rowCount).val();
    var Par1 = $('#txtPar1_' + rowCount).val();
    var Par2 = $('#txtPar2_' + rowCount).val();
    var DefaultIssue = $('#txtDefaultIssue_' + rowCount).val();
    var allow = 0;
    if (rowCount < 0)
    {
   // AddFirstGridRow();
    }
    else if (rowCount >= "0" && (LocationCode == "" || LinenCode == "" || Par1 == "" || Par2 == "" || DefaultIssue == ""))
    {
        bootbox.alert("Please fill the last record");
    }
    else
    {
        allow = 0;
        for (var krows = 0; krows <= rowCount; krows++)
        {
            for (var krow = 0; krow <= rowCount_ID; krow++)
            {
                if (krows != krow)
                {
                    var actual = $('#txtLinenCode_' + krows).val();
                    var current = $('#txtLinenCode_' + krow).val()
                    if (actual == current) {
                        alert("Already Exist Linencode");
                        allow = 1;
                        $('#txtLinenCode_' + krow).val('');
                      
                    } else {
                        
                        //alert("not found");
                    }

                } else {
                }

            }
        }
        if (rowCount == 0)
        {
            AddFirstGridRow();
        }
        else
        {
            if (allow == 0)
            {
                AddFirstGridRow();
            } else
            {
            }
            
        }
     }
        
});
$('#chkContactDeleteAll').on('click', function () {
    var isChecked = $(this).prop("checked");
    $('#ContactGrid tr').each(function (index, value) {
        if (isChecked) {
            $('#chkContactDelete_' + index).prop('checked', true);
            $('#chkContactDelete_' + index).parent().addClass('bgDelete');
            $('#txtLocationCode_' + index).removeAttr('required');
            $('#txtLocationCode_' + index).parent().removeClass('has-error');
        }
        else {
            $('#txtLocationCode_' + index).attr('required', true);
            $('#chkContactDelete_' + index).prop('checked', false);
            $('#chkContactDelete_' + index).parent().removeClass('bgDelete');
            
        }
    });
    
});

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

$("#txtRecievedQuantity").change(function () {
    console.log(index);

    var FirstDeliver = parseFloat($('#txtRecievedQuantity_' + index).val());
    $('#txtTotaReceived').val(FirstDeliver);
});
function calculateIssued(index) {
    var rowCount = $('#ContactGrid tr:last').index();
    var totalAA = 0;
    var a = 0;
    for (var i = 0; i <= rowCount; i++) {
        a = parseInt(document.getElementById("txtRecievedQuantity_" + i).value);
        totalAA = parseInt(totalAA + a);
    }
    $('#txtTotaReceived').val(totalAA);
    console.log(totalAA);
}
var linkCliked1 = false;
window.AddFirstGridRow = function () {
    $('#chkContactDeleteAll').prop('checked', false);
    var inputpar = {
        inlineHTML: '<tr class="ng-scope" style=""> ' +
            '<td width="5%" style="text-align:center"> <input type="checkbox" value="false" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(ContactGrid,chkContactDeleteAll)" tabindex="0"></td>' +
            '<td width="10%" style="text-align: center;"><div><input type="text"  id="txtLinenCode_maxindexval" name="LinenCode" maxlength="50"   onkeyup="FetchLinenCode(event,maxindexval)" onpaste="FetchLinenCode(event,maxindexval)" change="FetchLinenCode(event,maxindexval)"oninput="FetchLinenCode(event,maxindexval)"  class="form-control" autocomplete="off" tabindex="0" required  placeholder="Please Select"><input type="hidden" id="LinenCodeId_maxindexval" required/><input type="hidden" id="LinenCodeUpdateDetId_maxindexval"/><input type="hidden" id="CleanLinenDespatchDetId_maxindexval"/> <div class="col-sm-12" id="divLinenCodeFetch_maxindexval"></div > </div></td>< td width="15%" style="text-align: center;" > <div> ' +
            '<td width="20%" style="text-align: center;"><div><input type="text" id="txtLinenDescription_maxindexval" name="LinenCode" maxlength="50" class="form-control" autocomplete="off" tabindex="0" disabled></div></td>< td width="15%" style="text-align: center;" > <div> ' +
            '<td width="20%" style="text-align: center;"><div><input type="text" onblur="duplicateCheck(maxindexval)" id="txtDespatched_maxindexval" name="LinenDescription" maxlength="50"required class="form-control" onchange="CalculateVarience(maxindexval)" autocomplete="off" tabindex="0"  ></div></td>< td width="15%" style="text-align: center;" > <div> ' +
            '<td width="15%" style="text-align: center;"><div><input type="text" id="txtRecievedQuantity_maxindexval" onblur="calculateIssued(maxindexval)" name="Par1" maxlength="50" required class="form-control" onchange="CalculateVarience(maxindexval)" autocomplete="off" tabindex="0"  ></div></td>< td width="15%" style="text-align: center;" > <div> ' +
            '<td width="15%" style="text-align: center;"><div><input type="text" id="txtVariance_maxindexval" name="Par2" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"  disabled></div></td>< td width="15%" style="text-align: center;" > <div> ' +
            '<td width="15%" style="text-align: center;"><div><input type="text" id="txtRemarks_maxindexval" onchange="getDetails(maxindexval)" class="form-control"><div></td></tr>',
        IdPlaceholderused: "maxindexval",
        TargetId: "#ContactGrid",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    //$("input[id^='txtGeneratedDemerit_'], input[id^='txtFinalDemerit_']").attr('pattern', '^[0-9]+$');
    $("input[id^='txtLinenCode_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtLinenDescription_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtDespatched_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtRecievedQuantity_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtVariance_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtRemarks_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');

    if (!linkCliked1) {
        $('#ContactGrid tr:last td:first input').focus();
    }
    else {
        linkCliked1 = false;
    }
    formInputValidation("FrmLinenClean");

}
