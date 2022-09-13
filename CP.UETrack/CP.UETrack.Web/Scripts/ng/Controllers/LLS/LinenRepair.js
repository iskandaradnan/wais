$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    $('.btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $.get("/api/LinenRepair/Load")
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
    var SecondReceivedByFetchObj = {
        SearchColumn: 'txtContactPerson-StaffName',//Id of Fetch field
        ResultColumns: ["UserRegistrationId-Primary Key", 'StaffName-StaffName', 'Designation-Designation'],
        FieldsToBeFilled: ["txtStaffMasterId-UserRegistrationId", "txtContactPerson-StaffName", "txtDesignation-Designation"]
    };

    $('#txtContactPerson').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetchContactPerson', SecondReceivedByFetchObj, "/api/Fetch/CleanLinenIssueTxn_Fetch2ndReceivedBy", "UlFetch3", event, 1);//1 -- pageIndex
    });

    var LevelCodeFetchObj = {
        SearchColumn: 'txtUserLevelCode-StaffName',//Id of Fetch field
        ResultColumns: ["UserRegistrationId-Primary Key", 'StaffName-StaffName'],//Columns to be displayed
        FieldsToBeFilled: ["hdnLevelId-UserRegistrationId", "txtUserLevelCode-StaffName"],
    };

   
    $('#txtUserLevelCode').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch2', LevelCodeFetchObj, "/api/Fetch/LinenRepairTxn_FetchCheckedBy", "UlFetch2", event, 1);//1 -- pageIndex
    });

$(".btnSave, .btnEdit,#btnSaveandAddNew").click(function () {
    $('#btnlogin').attr('disabled', true);
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#myPleaseWait').modal('hide');
        $('#txtDocumentDate').attr('required', true);
        $('#txtContactPerson').attr('required', true);
        $('#txtUserLevelCode').attr('required', true);           
        $('#txtLinenCode_').attr('required', true);
        $('#txtRepairQuantity_').attr('required', true);
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
            LinenRepairDetId: $('#LinenRepairDetId_' + i).val(),
            LinenItemId: $('#LinenCodeId_' + i).val(),
            LinenCode: $('#txtLinenCode_' + i).val(),
            LinenDescription: $('#txtLinenDescription_' + i).val(),
            RepairQuantity: $('#txtRepairQuantity_' + i).val(),
            RepairCompletedQuantity: $('#txtRepairCompletedQuantity_' + i).val(),
            BalanceRepairQuantity: $('#txtBalanceRepairQuantity_' + i).val(),
            DescriptionOfProblem: $('#txtDescriptionofProblem_' + i).val(),
            IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
        };
        if (_tempObj.RepairCompletedQuantity == " " || _tempObj.RepairCompletedQuantity == "") {
            _tempObj.RepairCompletedQuantity = null;
        }

        var stDt = _tempObj.RepairQuantity;
        var endDt = _tempObj.RepairCompletedQuantity;

       
        if (endDt != null) {
            if (endDt != "" && endDt > stDt) {
                $("div.errormsgcenter").text("Repair Completed Quantity should be Lesser/Equal To Repair Quantity");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }
        result.push(_tempObj);
    } 

    var CurrentbtnID = $(this).attr("Value");
    var timeStamp = $("#Timestamp").val();

    var isFormValid = formInputValidation("FrmLinenRepair", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }
        var MstLinenRepair = {
            DocumentNo: $('#txtDocumentNo').val(),
            DocumentDate: $('#txtDocumentDate').val(),
            RepairedBy: $('#txtStaffMasterId').val(),
            CheckedBy: $('#hdnLevelId').val(),
            Remarks: $('#txtRemarks').val(),
            RepairQuantity: $('#txtRepairQuantity').val(),
            RepairCompletedQuantity: $('#txtRepairCompletedQuantity').val(),
            DescriptionOfProblem: $('#txtDescriptionofProblem').val(),
            LLinenRepairItemGridList: result
    };
    function chkIsDeletedRow(i, delrec) {
        if (delrec == true) {
            $('#txtLinenCode_' + i).prop("required", false);
            $('#txtLinenDescription_' + i).prop("required", false);
            $('#txtRepairQuantity_' + i).prop("required", false);
            $('#txtRepairCompletedQuantity_' + i).prop("required", false);
            $('#txtBalanceRepairQuantity_' + i).prop("required", false);
            $('#txtDescriptionofProblem_' + i).prop("required", false);
            
            return true;
        }
        else {
            return false;
        }
    }
    
    
        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            MstLinenRepair.LinenRepairId = primaryId;
            MstLinenRepair.Timestamp = timeStamp;
        }
        else {
            MstLinenRepair.LinenRepairId = 0;
            MstLinenRepair.Timestamp = "";
        }

        var jqxhr = $.post("/api/LinenRepair/Save", MstLinenRepair, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.LinenRepairId);
            $("#Timestamp").val(result.Timestamp);
            // $('#blockName').val(result.BlockName);
            //$('#blockFacilityId').val(result.FacilityId);
            $('#SelStatus option[value="' + result.Active + '"]').prop('selected', true);
            $('#hdnStatus').val(result.Active);
            if (result != null && result.LLinenRepairItemGridList != null && result.LLinenRepairItemGridList.length > 0) {
                BindSecondGridData(result);
            }
            $("#grid").trigger('reloadGrid');
            if (result.LinenRepairId != 0) {
                $('#hdnAttachId').val(result.HiddenId);
                $('#txtDocumentNo').val(result.DocumentNo);
                $('#txtDocumentDate').prop('disabled', true);
                $('#txtContactPerson').prop('disabled', true);
                $('#txtUserLevelCode').prop('disabled', true);
                $('#btnNextScreenSave').show();
                $('#btnEdit').hide();
                $('#btnSave').hide();
                $('.btnDelete').hide();


            }
            $(".content").scrollTop(0);
            showMessage('LinenRepair', CURD_MESSAGE_STATUS.SS);
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

//************************************************ Getbyid bind data *************************

function BindSecondGridData(getResult) {
    var ActionType = $('#ActionType').val();
    $("#ContactGrid").empty();
    $.each(getResult.LLinenRepairItemGridList, function (index, value) {
        AddFirstGridRow();
        $("#LinenRepairDetId_" + index).val(getResult.LLinenRepairItemGridList[index].LinenRepairDetId);
        $("#LinenCodeId_" + index).val(getResult.LLinenRepairItemGridList[index].LinenItemId);
        $("#txtLinenCode_" + index).val(getResult.LLinenRepairItemGridList[index].LinenCode).attr('disabled', true);
        $("#txtLinenDescription_" + index).val(getResult.LLinenRepairItemGridList[index].LinenDescription).attr('disabled', true);
        $("#txtRepairQuantity_" + index).val(getResult.LLinenRepairItemGridList[index].RepairQuantity).attr('disabled', true);
        $("#txtRepairCompletedQuantity_" + index).val(getResult.LLinenRepairItemGridList[index].RepairCompletedQuantity);
        $("#txtBalanceRepairQuantity_" + index).val(getResult.LLinenRepairItemGridList[index].BalanceRepairQuantity).attr('disabled', true);
        $("#txtDescriptionofProblem_" + index).val(getResult.LLinenRepairItemGridList[index].DescriptionOfProblem);
        linkCliked2 = true;
        $("#chkContactDeleteAll").prop("checked", false);
        $(".content").scrollTop(0);
    });

    //************************************************ Grid Pagination *******************************************

    if ((getResult.LLinenRepairItemGridList && getResult.LLinenRepairItemGridList.length) > 0) {
        GridtotalRecords = getResult.LLinenRepairItemGridList[0].TotalRecords;
        TotalPages = getResult.LLinenRepairItemGridList[0].TotalPages;
        LastRecord = getResult.LLinenRepairItemGridList[0].LastRecord;
        FirstRecord = getResult.LLinenRepairItemGridList[0].FirstRecord;
        pageindex = getResult.LLinenRepairItemGridList[0].PageIndex;
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
        'top': $('#txtLinenCode_' + index).offset().top - $('#LinenRepairProvider').offset().top + $('#txtLinenCode_' + index).innerHeight(),
    });
    var LinenFetchObj = {
        SearchColumn: 'txtLinenCode_' + index + '-LinenCode',//Id of Fetch field
        ResultColumns: ["LinenItemId-Primary Key", 'LinenCode' + '-txtLinenCode_' + index],
        FieldsToBeFilled: ["LinenCodeId_" + index + "-LinenItemId", 'txtLinenCode_' + index + '-LinenCode', 'txtLinenDescription_' + index + '-LinenDescription']
    };

    DisplayFetchResult('divLinenCodeFetch_' + index, LinenFetchObj, "/api/Fetch/LinenRepairTxnDet_FetchLinenCode", "UlFetch1" + index + "", event, 1);//1 -- pageIndex
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



function LinkClicked(LinenRepairId) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#FrmLinenRepair :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(LinenRepairId);
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
        $("#FrmLinenRepair :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/LinenRepair/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                $('#txtDocumentNo').val(getResult.DocumentNo).attr('disabled', true);
                $('#txtDocumentDate').val(moment(getResult.DocumentDate).format("DD-MMM-YYYY")).attr('disabled', true);
                $('#txtContactPerson').val(getResult.RepairedBy).attr('disabled', true);
                $('#txtStaffMasterId').val(getResult.RepairedBy).attr('disabled', true);
                $('#txtUserLevelCode').val(getResult.CheckedBy).attr('disabled', true);
                $('#hdnLevelId').val(getResult.CheckedBy).attr('disabled', true);
                $('#txtRemarks').val(getResult.Remarks);
                $('#txtRepairQuantity').val(getResult.RepairQuantity);
                $('#txtRepairCompletedQuantity').val(getResult.RepairQuantity);
                $('#txtDescriptionofProblem').val(getResult.DescriptionOfProblem);

                $('#primaryID').val(getResult.LinenRepairId);
                $('#hdnStatus').val(getResult.Active);
                $('#hdnAttachId').val(getResult.HiddenId);
                $('#myPleaseWait').modal('hide');
                $('.btnDelete').hide();
                $('.btnDelete').hide();
                $('.btnEdit').hide();

                if (getResult != null && getResult.LLinenRepairItemGridList != null && getResult.LLinenRepairItemGridList.length > 0) {
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
            $.get("/api/LinenRepair/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('LinenRepair', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('LinenRepair', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}
$("#btnNextScreenSave").click(function () {
    var primaryId = $("#primaryID").val();

    var hdnStatus = $("#hdnStatus").val();

    if (hdnStatus == 0 || hdnStatus == '0') {
        bootbox.alert('Only Active LinenRepair can be navigated to Level Screen');

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
    $('#txtRepairedBy').val('').prop('disabled', false);
    $('#txtCheckedBy').val('').prop('disabled', false);
    $('#txtRemarks').val('');
    $('#txtContactPerson').val('');
    $('#txtUserLevelCode').val('');
    $('#txtLinenCode_0').val('');
    $('#txtLinenDescription_0').val('');
    $('#txtRepairQuantity_0').val('');
    $('#txtRepairCompletedQuantity_0').val('');
    $('#txtDescriptionofProblem_0').val('');
    $('#txtRepairQuantity').val('');
    $('#txtRepairCompletedQuantity').val('');
    $('#txtDescriptionofProblem').val('');
    $('#spnActionType').text('Add');
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $('#btnSave').show();
    $('#primaryID').val('');
    $("#grid").trigger('reloadGrid');
    $("#FrmLinenRepair :input:not(:button)").parent().removeClass('has-error');
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
$('#contactBtn').click(function () {

    var rowCount = $('#ContactGrid tr:last').index();
    var LinenCode = $('#txtLinenCode_' + rowCount).val();
    var RepairQuantity = $('#txtRepairQuantity_' + rowCount).val();
    var ClassGrade = $('#txtClassGrade_' + rowCount).val();
    var IssuedDate = $('#txtIssuedDate_' + rowCount).val();
    var ExpiryDate = $('#txtExpiryDate_' + rowCount).val();


    if (rowCount < 0)
        AddFirstGridRow();
    else if (rowCount >= "0" && (LinenCode == "" || RepairQuantity == "" || ClassGrade == "" || IssuedDate == "" || ExpiryDate == "")) {
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
            $('#txtLicenseCode_' + index).removeAttr('required');
            $('#txtLicenseCode_' + index).parent().removeClass('has-error');
            // count++;
            //  }
        }
        else {
            //if(!$('#chkContactDelete_' +index1).prop('disabled'))
            //{
            $('#txtLicenseCode_' + index).attr('required', true);
            $('#chkContactDelete_' + index).prop('checked', false);
            $('#chkContactDelete_' + index).parent().removeClass('bgDelete');
            // }
        }
    });
    //if(count == 0){
    //    $(this).prop("checked", false);
    //}
});

var lov
function RepairCompleted(lov) {
    var RepairQuantity = parseInt(document.getElementById("txtRepairQuantity_" + lov).value);
    var RepairCompletedQuantity = parseInt(document.getElementById("txtRepairCompletedQuantity_" + lov).value);
    due = RepairQuantity - RepairCompletedQuantity;
    $("#txtBalanceRepairQuantity_" + lov).val(due);
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
            '<td width="5%" style="text-align:center"><input type="checkbox"value="false" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(ContactGrid,chkContactDeleteAll)" tabindex="0"></td>' +
            //'<td width="15%" style="text-align: center;"><div><input type="text" id="txtLinenCode_maxindexval" name="LinenCode" maxlength="50" onkeyup="FetchLinenCode(event,maxindexval)" onpaste="FetchLinenCode(event,maxindexval)" change="FetchLinenCode(event,maxindexval)"oninput="FetchLinenCode(event,maxindexval)"  class="form-control" autocomplete="off" tabindex="0" required  placeholder="Please Select"><input type="hidden" id="LinenCodeId_maxindexval"/><input type="hidden" id="LinenCodeUpdateDetId_maxindexval"/> <div class="col-sm-12" id="divLinenCodeFetch_maxindexval"></div > </div></td>< td width="15%" style="text-align: center;" > <div> ' +
            '<td width="15%" style="text-align: center;"><div><input type="text" id="txtLinenCode_maxindexval" name="LinenCode" required maxlength="50"   onkeyup="FetchLinenCode(event,maxindexval)" onpaste="FetchLinenCode(event,maxindexval)" change="FetchLinenCode(event,maxindexval)"oninput="FetchLinenCode(event,maxindexval)"  class="form-control" autocomplete="off" tabindex="0" required  placeholder="Please Select"><input type="hidden" id="LinenCodeId_maxindexval" required/><input type="hidden" id="LinenRepairDetId_maxindexval"/> <div class="col-sm-12" id="divLinenCodeFetch_maxindexval"></div > </div></td>< td width="15%" style="text-align: center;" > <div> ' +
            '<td width="15%" style="text-align: center;"><div><input id="txtLinenDescription_maxindexval" type="text" class="form-control"  name="LinenDescription" readonly="readonly"></div></td><div> ' +
            '<td width="15%" style="text-align: center;"><div><input id="txtRepairQuantity_maxindexval" type="text" class="form-control"  name="RepairQuantity" required ></div></td><div> ' +
            '<td width="15%" style="text-align: center;"><div><input id="txtRepairCompletedQuantity_maxindexval" onkeyup="RepairCompleted(maxindexval)" type="text" class="form-control"  name="RepairCompletedQuantity"><div> </td><div>' +
            '<td width="15%" style="text-align: center;"><div><input id="txtBalanceRepairQuantity_maxindexval" type="text" class="form-control " name="DescriptionofProblem" disabled><div> </td><div>' +
            '<td width="20%" style="text-align: center;"><div><input id="txtDescriptionofProblem_maxindexval" type="text" class="form-control " name="DescriptionofProblem"></div></td><div> ',
        IdPlaceholderused: "maxindexval",
        TargetId: "#ContactGrid",
        TargetElement: ["tr"]
    }
    $('#chkContactDeleteAll').prop('checked', false);
    AddNewRowToDataGrid(inputpar);
    //$("input[id^='txtGeneratedDemerit_'], input[id^='txtFinalDemerit_']").attr('pattern', '^[0-9]+$');
    $("input[id^='txtLinenCode_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    //$("input[id^='txtLinenDescription_']").attr('pattern', '^[a-zA-Z./\\(\\),\\-\\s]+$');
    $("input[id^='txtRepairQuantity_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtRepairCompletedQuantity_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtBalanceRepairQuantity_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtDescriptionofProblem_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');

   
   
    if (!linkCliked1) {
        $('#ContactGrid tr:last td:first input').focus();
    }
    else {
        linkCliked1 = false;
    }

    var rowCount = $('#ContactGrid tr:last').index();
    $.each(window.ClassGradeListGlobal, function (index, value) {
        $('#txtClassGrade_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
    $.each(window.IssuedByListGlobal, function (index, value) {
        $('#txtIssuedBy_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
    formInputValidation("FrmLinenRepair");

}
////////////////////*********** End Add rows **************//