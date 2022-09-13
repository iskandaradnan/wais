$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    formInputValidation("FrmLicense");
    $('.btnDelete').hide();
    $('.btnLicEdit').show();
    $('#btnNextScreenSave').hide();
    window.ClassGradeListGlobal = [];
    $.get("/api/LicenseType/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $.each(loadResult.LicenseType, function (index, value) {
                $('#txtCentralCleanLinenStore').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            window.ClassGradeListGlobal = loadResult.IssuingBody;
          
            AddNewRowStkAdjustment();
            
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });
});
$(".btnSave,.btnLicEdit").click(function () {
    $('#btnlogin').attr('disabled', true);
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#myPleaseWait').modal('hide');
    $('#txtCentralCleanLinenStore').attr('required', true);
    $('#LicenseCode_').attr('required', true);
    $('#LicenseDescription_').attr('required', true);
    $('#IssuingBody_').attr('required', true);

    var _index;   
    var result = [];
    $('#SummaryResultId tr').each(function () {
        _index = $(this).index();
    });

    for (var i = 0; i <= _index; i++) {
        var active = true;
        var _tempObj = {
            LicenseTypeId: $('#LicenseTypeId_' + i).val(),
            LicenseTypeDetId: $('#LicenseTypeDetId_' + i).val(),
            LicenseCode: $('#LicenseCode_' + i).val(),
            LicenseDescription: $('#LicenseDescription_' + i).val(),
            IssuingBody: $('#IssuingBody_' + i).val(),
            IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
        }
        result.push(_tempObj);
    }

    var CurrentbtnID = $(this).attr("value");
    var timeStamp = $("#Timestamp").val();

    var isFormValid = formInputValidation("FrmLicense", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }

    function chkIsDeletedRow(i, delrec) {
        if (delrec == true) {
            $('#LicenseTypeId_' + i).prop("required", false);
            $('#LicenseTypeDetId_' + i).prop("required", false);
            $('#LicenseCode_' + i).prop("required", false);
            $('#LicenseDescription_' + i).prop("required", false);
            $('#IssuingBody_' + i).prop("required", false);
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
    var MstLicenseType = {
        LicenseType: $('#txtCentralCleanLinenStore').val(),
        LicenseTypeModelListData: result
    };
    var primaryId = $("#primaryID").val();
    if (primaryId != null) {
        MstLicenseType.LicenseTypeId = primaryId;
        MstLicenseType.Timestamp = timeStamp;
    }
    else {
        MstLicenseType.LicenseTypeId = 0;
        MstLicenseType.Timestamp = "";
    }
    var jqxhr = $.post("/api/LicenseType/Save", MstLicenseType, function (response) {
        var result = JSON.parse(response);
        $("#primaryID").val(result.LicenseTypeId);
        if (result != null && result.LicenseTypeModelListData != null && result.LicenseTypeModelListData.length > 0) {
            BindGridData(result);
        }
        $("#Timestamp").val(result.Timestamp);
        $("#txtCentralCleanLinenStore").val(result.LicenseType);
        $('#hdnStatus').val(result.Active);
        $("#grid").trigger('reloadGrid');
        if (result.LicenseTypeId != 0) {
            $('#hdnAttachId').val(result.HiddenId);
            $('#txtCentralCleanLinenStore').prop('disabled', true);
            $('#LicenseCode_').prop('disabled', true);
            $('#SummaryResultId').prop('disabled', true);
            $('#IssuingBody_').prop('disabled', true);
            $('#btnNextScreenSave').hide();
            $('#btnEdit').hide();
            $('.btnSave').show();
            $('.btnDelete').hide();
        }
        $(".content").scrollTop(0);
        showMessage('LaundryPlant', CURD_MESSAGE_STATUS.SS);
        $("#top-notifications").modal('show');
        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);
        $('.btnDelete').hide();
        $('.btnSave').attr('disabled', false);
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
 

$("#chk_FacWorkIsDelete").change(function () {
                var Isdeletebool = this.checked;
                if (this.checked) {
                    $('#SummaryResultId tr').map(function (i) {
                        if ($("#Isdeleted_" + i).prop("disabled")) {
                            $("#Isdeleted_" + i).prop("checked", false);
                        }
                        else {
                            $("#Isdeleted_" + i).prop("checked", true);
                        }
                    });
                } else {
                    $('#SummaryResultId tr').map(function (i) {
                        $("#Isdeleted_" + i).prop("checked", false);
                    });
                }
            });

$(".btnDepCancel").click(function () {
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


function BindGridData(getResult) { 
    var ActionType = $('#ActionType').val();
    $("#SummaryResultId").empty();
    $.each(getResult.LicenseTypeModelListData, function (index, value) {
        AddNewRowStkAdjustment();
        $("#LicenseTypeDetId_" + index).val(getResult.LicenseTypeModelListData[index].LicenseTypeDetId);
        $("#LicenseCode_" + index).val(getResult.LicenseTypeModelListData[index].LicenseCode).attr("disabled", true)
        $("#LicenseDescription_" + index).val(getResult.LicenseTypeModelListData[index].LicenseDescription);
        $("#IssuingBody_" + index).val(getResult.LicenseTypeModelListData[index].IssuingBody);
        $("#LicenseType_" + index).val(getResult.LicenseType);
        linkCliked1 = true;
        $("#chk_FacWorkIsDelete").prop("checked", false);
        $(".content").scrollTop(0);
    });

    //************************************************ Grid Pagination *******************************************
    ckNewRowPaginationValidation = false;
    if ((getResult.LicenseTypeModelListData && getResult.LicenseTypeModelListData.length) > 0) {
        GridtotalRecords = getResult.LicenseTypeModelListData[0].TotalRecords;
        TotalPages = getResult.LicenseTypeModelListData[0].TotalPages;
        LastRecord = getResult.LicenseTypeModelListData[0].LastRecord;
        FirstRecord = getResult.LicenseTypeModelListData[0].FirstRecord;
        pageindex = getResult.LicenseTypeModelListData[0].PageIndex;
        linkCliked1 = true;
        $(".content").scrollTop(0);
    }

    //************************************************ End *******************************************************
}
var linkCliked1 = false;
function AddNewRowStkAdjustment() {
    var inputpar = {
        inlineHTML: SummaryGridHtml(),
        IdPlaceholderused: "maxindexval",
        TargetId: "#SummaryResultId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    if (!linkCliked1) {
        $('#SummaryResultId tr:last td:first input').focus();
    }
    else {
        linkCliked1 = false;
    }
    var rowCount = $('#SummaryResultId tr:last').index();
    
    $.each(window.ClassGradeListGlobal, function (index, value) {
        $('#IssuingBody_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });

    formInputValidation("FrmLicense");
}

function PushEmptyMessage() {
    $("#SummaryResultId").empty();
    var emptyrow = '<tr><td colspan=57 ><h3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;No records to display</h3></td></tr>'
    $("#SummaryResultId ").append(emptyrow);
}

function SummaryGridHtml() {
    return '<tr>' +
        '<td width="10%" style="text-align:center"> <input type="checkbox" onchange="IsDeleteCheckAll(SummaryResultId,chk_FacWorkIsDelete)" id="Isdeleted_maxindexval" /></td>' +
        '<td " style="text-align: center; width:30%;" title=""><div><input  id="LicenseCode_maxindexval"  type="text" class="form-control" name="LicenseCode" autocomplete="off" required><input type="hidden" id="LicenseTypeDetId_maxindexval"/></div></td>' +
        '<td " style="text-align: center;  width:30%;" title=""><div><input  id="LicenseDescription_maxindexval" type="text" class="form-control" name="LicenseDescription" autocomplete="off" required></div></td>' +
        '<td " style="text-align: center;  width:30%;" title=""><div><select  id="IssuingBody_maxindexval"maxindex="150" type="text" class="form-control" name="IssuingBody" autocomplete="off" required ><option value="null" >Select</option></select></div></td>'
}
$("#chk_FacWorkIsDelete").prop("checked", false); 
function SummaryNewRow() {

    var inputpar = {
        inlineHTML: SummaryGridHtml(),//Inline Html
        TargetId: "#SummaryResultId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
   
}



function LinkClicked(LicenseTypeId) {
    linkCliked1 = true;
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#FrmLicense :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(LicenseTypeId);
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
        $("#FrmLicense :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnSave').show();
        $('#btnNextScreenSave').hide();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") 
        $.get("/api/LicenseType/Get/" + primaryId)
        .done(function (result) {
            var getResult = JSON.parse(result);
            $('#txtCentralCleanLinenStore').val(getResult.LicenseType).attr("disabled", true);
            // $('#txtCentralCleanLinenStore').val(getResult.LicenseType);
            $('#LicenseCode_').val(getResult.LicenseCode);
            $('#LicenseDescription_').val(getResult.LicenseDescription);
            $('#IssuingBody_').val(getResult.IssuingBody);
            $('#primaryID').val(getResult.LicenseTypeId);
            if (getResult != null && getResult.LicenseTypeModelListData != null && getResult.LicenseTypeModelListData.length > 0) {
                BindGridData(getResult);
            }
            $('.btnLicEdit').hide();
            $('.btnDelete').hide();
        })
            .fail(function () {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');
            });
}
    



//***********************End****************************

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




$(".btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/LicenseType/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('LicenseType', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('LicenseType', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}


function EmptyFields() {
    debugger;
    $('#txtCentralCleanLinenStore').val('null').prop('disabled', false);
    $(".content").scrollTop(0);
    $('#hdnAttachId').val('');
    $('.btnDelete').show();
    $('#SummaryResultId').empty();
    //$('#txtCentralCleanLinenStore').val('1');
    $('#spnActionType').text('Add');
    $('#btnEdit').show();
    $('.btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#btnSave').show();
    $('#primaryID').val('');
    $("#grid").trigger('reloadGrid');
    $("#FrmLicense :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#SelStatus').val(1);
    $('#txtLicenseTypeCode_0').val('');
    $('#txtLicenseDescription_0').val('');
    $('#txtIssuingBody_0').val('');
    SummaryGridHtml();
    $("#chk_FacWorkIsDelete").prop("checked", false);
    AddNewRowStkAdjustment();
  
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

    var rowCount = $('#SummaryResultId tr:last').index();
    var LicenseCode = $('#LicenseCode_' + rowCount).val();
    var LicenseDescription = $('#LicenseDescription_' + rowCount).val();
    var IssuingBody = $('#IssuingBody_' + rowCount).val();
   

    if (rowCount < 0)
        AddNewRowStkAdjustment();
    else if (rowCount >= "0" && (LicenseCode == "" || LicenseDescription == "" || IssuingBody == "")) {
        bootbox.alert("Please fill the last record");
    }
    else {
        AddNewRowStkAdjustment();
    }
});

////////////////////*********** End Add rows **************//