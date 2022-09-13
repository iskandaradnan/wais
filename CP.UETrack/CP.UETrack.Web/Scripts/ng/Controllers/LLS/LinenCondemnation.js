$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    $('.btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $.get("/api/LinenCondemnation/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $.each(loadResult.LocationofCondemnation, function (index, value) {
                $('#txtLocationofCondemnation').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            AddFirstGridRow();
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });
});

var SecondReceivedByFetchObj = {
    SearchColumn: 'txtContactPerson-StaffName',//Id of Fetch field
    ResultColumns: ["UserRegistrationId-Primary Key", 'StaffName-StaffName', 'Designation-Designation'],
    FieldsToBeFilled: ["txtStaffMasterId-UserRegistrationId", "txtContactPerson-StaffName", "txtDesignation-Designation"]
};

$('#txtContactPerson').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divFetchContactPerson', SecondReceivedByFetchObj, "/api/Fetch/LinenCondemnationTxn_FetchInspectedBy", "UlFetch3", event, 1);//1 -- pageIndex
});

var LevelCodeFetchObj = {
    SearchColumn: 'txtUserLevelCode-StaffName',//Id of Fetch field
    ResultColumns: ["UserRegistrationId-Primary Key", 'StaffName-StaffName'],//Columns to be displayed
    FieldsToBeFilled: ["hdnLevelId-UserRegistrationId", "txtUserLevelCode-StaffName"],
};


$('#txtUserLevelCode').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divFetch2', LevelCodeFetchObj, "/api/Fetch/LinenCondemnationTxn_FetchVerifiedBy", "UlFetch2", event, 1);//1 -- pageIndex
});
$(".btnSave,.btnEdit").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');        
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $('#txtDocumentDate').attr('required', true);    
        $('#txtLinenCode_').attr('required', true);  
        
        var _index;      
        var result = [];
        $('#ContactGrid tr').each(function () {
            _index = $(this).index();
        });       
        for (var i = 0; i <= _index; i++) {
            var active = true;
            var isDeletedcat = $('#IsDeletedCategory_' + i).prop('checked');           
            var _tempObj = {
                LinenCondemnationDetId: $('#LinenCondemnationDetId_' + i).val(),
                LinenCode: $('#txtLinenCode_' + i).val(),
                LinenDescription: $('#txtLinenDescription_' + i).val(),
                LinenItemId: $('#LinenCodeId_' + i).val(),
                BatchNo: $('#txtBatchNo_' + i).val(),
                Total: $('#txtTotal_' + i).val(),
                Torn: $('#txtTorn_' + i).val(),
                Stained: $('#txtStained_' + i).val(),
                Faded: $('#txtFaded_' + i).val(),
                Vandalism: $('#txtVandalism_' + i).val(),
                WearTear: $('#txtWearTear_' + i).val(),
                StainedByChemical: $('#txtStainedbyChemical_' + i).val(),
                IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
            }
            result.push(_tempObj);
    }
        var CurrentbtnID = $(this).attr("value");
        var timeStamp = $("#Timestamp").val();

    var isFormValid = formInputValidation("FrmCon", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }
        var MstLInenCondmenation = {
            DocumentNo: $('#txtDocumentNo').val(),
            DocumentDate: $('#txtDocumentDate ').val(),
            InspectedBy: $('#txtStaffMasterId').val(),
            VerifiedBy: $('#hdnLevelId ').val(),
            TotalCondemns: $('#txtTotalCondemns').val(),
            LocationOfCondemnation: $('#txtLocationofCondemnation').val(),
            Value: $('#txtValue').val(),
            Remarks: $('#txtRemarks').val(),
            LLinenCondemnationGridList: result
        };
    function chkIsDeletedRow(i, delrec) {
        if (delrec == true) {
            $('#txtLinenCode_' + i).prop("required", false);
            $('#txtLinenDescription_' + i).prop("required", false);
            $('#txtBatchNo_' + i).prop("required", false);
            $('#txtTotal_' + i).prop("required", false);
            $('#txtTorn_' + i).prop("required", false);
            $('#txtStained_' + i).prop("required", false);
            $('#txtFaded_' + i).prop("required", false);
            $('#txtVandalism_' + i).prop("required", false);
            $('#txtWearTear_' + i).prop("required", false);
            $('#txtStainedbyChemical_' + i).prop("required", false);
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
            MstLInenCondmenation.LinenCondemnationId = primaryId;
            MstLInenCondmenation.Timestamp = timeStamp;
        }
        else {
            MstLInenCondmenation.LinenCondemnationId = 0;
            MstLInenCondmenation.Timestamp = "";
        }

        var jqxhr = $.post("/api/LinenCondemnation/Save", MstLInenCondmenation, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.LinenCondemnationId);
            $("#Timestamp").val(result.Timestamp);
            $('#SelStatus option[value="' + result.Active + '"]').prop('selected', true);
            $('#hdnStatus').val(result.Active);
            if (result != null && result.LLinenCondemnationGridList != null && result.LLinenCondemnationGridList.length > 0) {
                BindSecondGridData(result);
            }
            $("#grid").trigger('reloadGrid');
            if (result.LInenCondmenationId != 0) {
                $('#hdnAttachId').val(result.HiddenId);
                $('#txtDocumentNo').val(result.DocumentNo);
                $('#txtTotalCondemns').val(result.TotalCondemns);
                $('#txtValue').val(result.Value);
                $('#btnNextScreenSave').show();
                $('.btnEdit').hide();
                $('#btnSave').hide();
                $('.btnDelete').hide();
            }
            $(".content").scrollTop(0);
            showMessage('LinenCondemnation', CURD_MESSAGE_STATUS.SS);
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

    //************************************************ Getbyid bind data *************************

function FetchLinenCode(event, index) {
    $('#divLinenCodeFetch_' + index).css({
        'top': $('#txtLinenCode_' + index).offset().top - $('#LinenConProvider').offset().top + $('#txtLinenCode_' + index).innerHeight(),
    });
    var LinenFetchObj = {
        SearchColumn: 'txtLinenCode_' + index + '-LinenCode',//Id of Fetch field
        ResultColumns: ["LinenItemId-Primary Key", 'LinenCode' + '-txtLinenCode_' + index],
        FieldsToBeFilled: ["LinenCodeId_" + index + "-LinenItemId", 'txtLinenCode_' + index + '-LinenCode', 'txtLinenDescription_' + index + '-LinenDescription']
    };

    DisplayFetchResult('divLinenCodeFetch_' + index, LinenFetchObj, "/api/Fetch/LinenCondemnationTxnDet_FetchLinenCode", "UlFetch1" + index + "", event, 1);//1 -- pageIndex
}

function BindSecondGridData(getResult) {
        var ActionType = $('#ActionType').val();
        $("#ContactGrid").empty();
        $.each(getResult.LLinenCondemnationGridList, function (index, value) {
            AddFirstGridRow();
            $("#LinenCondemnationDetId_" + index).val(getResult.LLinenCondemnationGridList[index].LinenCondemnationDetId);
            $("#LinenCodeId_" + index).val(getResult.LLinenCondemnationGridList[index].LinenCondemnationDetId);
            $("#txtLinenCode_" + index).val(getResult.LLinenCondemnationGridList[index].LinenCode).attr('disabled', true);
            $("#txtLinenDescription_" + index).val(getResult.LLinenCondemnationGridList[index].LinenDescription).attr('disabled', true);
            $("#txtBatchNo_" + index).val(getResult.LLinenCondemnationGridList[index].BatchNo).attr('disabled', true);
            $("#txtTotal_" + index).val(getResult.LLinenCondemnationGridList[index].Total).attr('disabled', true);
            $("#txtTorn_" + index).val(getResult.LLinenCondemnationGridList[index].Torn).attr('disabled', true);
            $("#txtFaded_" + index).val(getResult.LLinenCondemnationGridList[index].Faded).attr('disabled', true);
            $("#txtStained_" + index).val(getResult.LLinenCondemnationGridList[index].Stained).attr('disabled', true);
            $("#txtVandalism_" + index).val(getResult.LLinenCondemnationGridList[index].Vandalism).attr('disabled', true);
            $("#txtWearTear_" + index).val(getResult.LLinenCondemnationGridList[index].WearTear).attr('disabled', true);
            $("#txtStainedbyChemical_" + index).val(getResult.LLinenCondemnationGridList[index].StainedByChemical).attr('disabled', true);
            linkCliked2 = true;
            $(".content").scrollTop(0);
        });

        //************************************************ Grid Pagination *******************************************

        if ((getResult.LLinenCondemnationGridList && getResult.LLinenCondemnationGridList.length) > 0) {
            GridtotalRecords = getResult.LLinenCondemnationGridList[0].TotalRecords;
            TotalPages = getResult.LLinenCondemnationGridList[0].TotalPages;
            LastRecord = getResult.LLinenCondemnationGridList[0].LastRecord;
            FirstRecord = getResult.LLinenCondemnationGridList[0].FirstRecord;
            pageindex = getResult.LLinenCondemnationGridList[0].PageIndex;
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

function LinkClicked(LinenCondemnationId) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#FrmCon :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(LinenCondemnationId);
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
        $("#FrmCon :input:not(:button)").prop("disabled", true);
    } else {
        $('.btnEdit').hide();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/LinenCondemnation/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                $('#txtDocumentNo').val(getResult.DocumentNo).attr('disabled', true);
                $('#txtDocumentNo').val(getResult.DocumentNo);
                $('#txtDocumentDate').val(moment(getResult.DocumentDate).format("DD-MMM-YYYY")).attr('disabled', true);         
                $('#txtContactPerson').val(getResult.InspectedBy).attr('disabled', true);
                $('#txtStaffMasterId').val(getResult.InspectedBy).attr('disabled', true);            
                $('#txtUserLevelCode').val(getResult.VerifiedBy).attr('disabled', true);
                $('#hdnLevelId').val(getResult.VerifiedBy).attr('disabled', true);
                $('#txtTotalCondemns').val(getResult.TotalCondemns).attr('disabled', true);
                $('#txtTotalCondemns').val(getResult.TotalCondemns);
                $('#txtLocationofCondemnation').val(getResult.LocationOfCondemnation).attr('disabled', true);
                $('#txtValue').val(getResult.Value).attr('disabled', true);
                $('#txtValue').val(getResult.Value);
                $('#txtRemarks').val(getResult.Remarks);
                $('#primaryID').val(getResult.LinenCondemnationId);
                $('#hdnStatus').val(getResult.Active);
                $('#hdnAttachId').val(getResult.HiddenId);
                $('#myPleaseWait').modal('hide');
                $('.btnDelete').hide();
                if (getResult != null && getResult.LLinenCondemnationGridList != null && getResult.LLinenCondemnationGridList.length > 0) {
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
            $.get("/api/LinenCondemnation/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('LinenCondemnation', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('LinenCondemnation', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}
$("#btnNextScreenSave").click(function () {
    var primaryId = $("#primaryID").val();

    var hdnStatus = $("#hdnStatus").val();

    if (hdnStatus == 0 || hdnStatus == '0') {
        bootbox.alert('Only Active LinenCondemnation can be navigated to Level Screen');

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
    $('#txtContactPerson').val('').prop('disabled', false);
    $('#txtUserLevelCode').val('').prop('disabled', false);
    $('#txtTotalCondemns').val('');
    $('#txtLocationofCondemnation').val('null').prop('disabled', false);
    $('#txtValue').val('');
    $('#txtRemarks').val('');
    $('#spnActionType').text('Add');
    $('.btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $('#btnSave').show();
    $('#primaryID').val('');
    $("#grid").trigger('reloadGrid');
    $("#FrmCon :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#SelStatus').val(1);
    $('#txtContactPerson').val('');
    $('#txtUserLevelCode').val('');
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
            //'<td width="10%" style="text-align: center;"><div><input type="text" id="txtLinenCode_maxindexval"  placeholder="Please Select" name="txtLinenCode" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" required ></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text"  id="txtLinenCode_maxindexval" required name="LinenCode" maxlength="50"   onkeyup="FetchLinenCode(event,maxindexval)" onpaste="FetchLinenCode(event,maxindexval)" change="FetchLinenCode(event,maxindexval)" oninput="FetchLinenCode(event,maxindexval)"  class="form-control" autocomplete="off" tabindex="0" required  placeholder="Please Select"><input type="hidden" id="LinenCodeId_maxindexval" required/><input type="hidden" id="LinenCondemnationDetId_maxindexval"/><input type="hidden" id="LinenCodeUpdateDetId_maxindexval"/> <div class="col-sm-12" id="divLinenCodeFetch_maxindexval"></div > </div></td>< td width="15%" style="text-align: center;" > <div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" disabled id="txtLinenDescription_maxindexval" name="LinenDescription" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" ></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtBatchNo_maxindexval" name="txtBatchNo" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"  ></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text"  disabled id="txtTotal_maxindexval" name="txtTotal" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="5%"  style="text-align: center;"><div><input type="text" id="txtTorn_maxindexval" name="txtTorn" maxlength="50"  class="form-control" autocomplete="off"></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtFaded_maxindexval" name="txtFaded" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtStained_maxindexval" name="txtStained" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtVandalism_maxindexval" name="txtVandalism" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtWearTear_maxindexval" name="txtWearTear" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtStainedbyChemical_maxindexval" name="txtStainedbyChemical" maxlength="50"  class="form-control" autocomplete="off" tabindex="0"></div></td><div></tr>',
        IdPlaceholderused: "maxindexval",
        TargetId: "#ContactGrid",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    //$("input[id^='txtGeneratedDemerit_'], input[id^='txtFinalDemerit_']").attr('pattern', '^[0-9]+$');
    $("input[id^='txtLinenCode_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtLinenDescription_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtBatchNo_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtTotal_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtTorn_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtFaded_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtStained_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtVandalism_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtWearTear_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtStainedbyChemical_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    
    if (!linkCliked1) {
        $('#ContactGrid tr:last td:first input').focus();
    }
    else {
        linkCliked1 = false;
    }
    formInputValidation("FrmCon");

}
////////////////////*********** End Add rows **************//