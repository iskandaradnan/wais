//********************************************* Pagination Grid ********************************************

var pageindex = 1, pagesize = 5;
var TotalPages = 1;

//********************************************************************************

$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    var ActionType = $('#ActionType').val();
    var primaryId = $('#primaryID').val();
    $('#jQGridCollapse1').click();
    $("#addrowplus").show();
    AddNewDeptSearchRow();
    $('#chk_DepartmentQRCodePrintdet').prop("disabled", true);
    $("#DeptSearchTbl").on('click', '.btnDelete', function () {
        $(this).closest('tr').remove();
    });
    formInputValidation("DepartmentQRCodePrintingForm");

    //******************************************** Getby Search ****************************************************

    $('#btnDeptQRSearch').click(function () {

        var strstring = "";
        var totalstring = [];
        var _index;

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var rowcount = $("#DepartmentQRCodePrintTbl tr:last").index();
        $('#QRDeptUserDept_' + rowcount).parent().removeClass('has-error');

        $('#DeptSearchTbl tr').each(function () {
            _index = $(this).index();
        });

        var searchcondition = $("#DeptQRCodeSearchCondition").val();
        for (var i = 0; i <= _index; i++) {
            var ModelVal = $("#GridList_" + i).val();
            var ConditionVal = $("#FilterList_" + i).val();
            var TextVal = $("#UserValue_" + i).val();

            var querystr = {
                ModelName: ModelVal,
                ConditionName: ConditionVal,
                TextName: TextVal,
                GroupOp: searchcondition,
            };

            totalstring.push(querystr);

        }
        var Result = {            
            sqlQueryExpressionListData: totalstring,            
        }
        BindGetByIdVal(Result);
        
        });

    //******************************************** Getby Reset ****************************************************

    $('#btnDeptQRReset').click(function () {
        $('#DeptSearchTbl').empty();
        $("#DepartmentQRCodePrintTbl").empty();
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        AddNewDeptSearchRow();
        $("#addrowplus").show();
        $('#btnDepartmentQRPrint').attr('disabled', true);
        $('#chk_DepartmentQRCodePrintdet').prop("checked", false);
        $('#chk_DepartmentQRCodePrintdet').prop("disabled", true);
    });

    //****************************************** print **************************************

    $("#btnDepartmentQRPrint").click(function () {
        $('#btnDepartmentQRPrint').attr('disabled', true);
        $('#myPleaseWait').modal('show');

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var primaryId = $('#primaryID').val();
        var _index;        
        var result = [];

        $('#DepartmentQRCodePrintTbl tr').each(function () {
            _index = $(this).index();
        });              
        
        for (var i = 0; i <= _index; i++) {
            var IsDeleted = $('#Isdeleted_' + i).is(":checked");
            if (IsDeleted) {
                var _DeptQRCodeWO = {
                    BlockId: $('#hdndeptblocknameId_' + i).val(),
                    BlockName: $('#QRDeptBlock_' + i).val(),
                    LevelId: $('#hdndeptLevelId_' + i).val(),
                    LevelName: $('#QRDeptLevel_' + i).val(),
                    UserAreaId: $('#hdndeptUserDeptId_' + i).val(),
                    UserAreaName: $('#QRDeptUserDept_' + i).val(),
                    DeptQRCode: $('#hdnDeptQRCodeId_' + i).val(),
                    IsDeleted: $('#Isdeleted_' + i).is(":checked"),
                }
                result.push(_DeptQRCodeWO);
            }           
        }
        
        var obj = {
            DeptQRCodeListData: result
        }        
        if (obj.DeptQRCodeListData.length == 0) {
            $("div.errormsgcenter").text("Select records to print");
            $('#errorMsg').css('visibility', 'visible');
            //formInputValidation("DepartmentQRCodePrintingForm");           
            $('#btnDepartmentQRPrint').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }
        var ckfalse = 0;
        var cktrue = 0;
        for (var j = 0; j <= _index; j++) {
            var IsDeleted = $('#Isdeleted_' + j).is(":checked");
            var DeptQRCode = $('#hdnDeptQRCodeId_' + j).val();
            var UserAreaName = $('#QRDeptUserDept_' + j).val();

            if (IsDeleted) {
                if (UserAreaName == "") {
                    $("div.errormsgcenter").text("Some fields are incorrect or have not been filled in. Please correct this to proceed.");
                    $('#QRDeptUserDept_' + j).parent().addClass('has-error');
                    $('#errorMsg').css('visibility', 'visible');
                    $('#myPleaseWait').modal('hide');
                    $('#btnDepartmentQRPrint').attr('disabled', false);
                    ckfalse += 1;                    
                }
                else {
                    $('#QRDeptUserDept_' + j).parent().removeClass('has-error');
                }
            }
            else {
                $('#QRDeptUserDept_' + j).parent().removeClass('has-error');
            }
        }
        if (ckfalse > 0)  {
            return false;
        }
        for (var k = 0; k <= _index; k++) {
            var IsDeleted = $('#Isdeleted_' + k).is(":checked");
            var DeptQRCode = $('#hdnDeptQRCodeId_' + k).val();
            var UserAreaName = $('#QRDeptUserDept_' + k).val();

            if (IsDeleted) {                
                 if (DeptQRCode == "" || DeptQRCode == null || DeptQRCode == 0) {
                    $("div.errormsgcenter").text("QR Code not generated for that Area Name");
                    $('#QRDeptUserDept_' + k).parent().addClass('has-error');
                    $('#errorMsg').css('visibility', 'visible');
                    $('#myPleaseWait').modal('hide');
                    $('#btnDepartmentQRPrint').attr('disabled', false);
                    cktrue += 1;
                 }
                 else {
                     $('#QRDeptUserDept_' + k).parent().removeClass('has-error');
                 }
            }
            else {
                $('#QRDeptUserDept_' + k).parent().removeClass('has-error');
            }
        }
        if (cktrue > 0) {
            return false;
        }
           
        SaveDeptQRCodeMST(obj);

        function SaveDeptQRCodeMST(obj) {           
            var jqxhr = $.post("/api/DepartmentQRCode/Save", obj, function (response) {
                var result = JSON.parse(response);
                var QRCodeId = [];
                $.each(result.DeptQRCodeListData, function (index, value) {
                    QRCodeId = result.DeptQRCodeListData[index].QRCodeUserAreaId;
                });
                if (QRCodeId != 0) {
                    //showMessage('Department QRCode', CURD_MESSAGE_STATUS.SS);
                    $('#myPleaseWait').modal('show');
                    window.location.href = "/bems/departmentqrcodereport";
                }

                $('#btnDepartmentQRPrint').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
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
                $('#btnDepartmentQRPrint').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            });
        }

    });

    //************************************ Grid Delete 

    $("#chk_DepartmentQRCodePrintdet").change(function () {
        var Isdeletebool = this.checked;

        if (this.checked) {
            $('#DepartmentQRCodePrintTbl tr').map(function (i) {
                if ($("#Isdeleted_" + i).prop("disabled")) {
                    $("#Isdeleted_" + i).prop("checked", false);
                }
                else {
                    $("#Isdeleted_" + i).prop("checked", true);
                }
            });
        } else {
            $('#DepartmentQRCodePrintTbl tr').map(function (i) {
                $("#Isdeleted_" + i).prop("checked", false);
            });
        }
    });

    

    $("#btnAddNew").click(function () {
        window.location.href = window.location.href;
    });
    $("#btnCancel").click(function () {
        window.location.href = "";
    });

    $("#btnDeptReportCancel").click(function () {
        window.location.href = "/bems/departmentqrcodeprinting";
    });

});

//******************************************** AddNewRow Grid ****************************************************

function AddNewRowDepartmentQRCodePrint() {

    var inputpar = {
        inlineHTML: BindNewRowHTML(),

        IdPlaceholderused: "maxindexval",
        TargetId: "#DepartmentQRCodePrintTbl",
        TargetElement: ["tr"]

    }
    AddNewRowToDataGrid(inputpar);
    $('#DepartmentQRCodePrintTbl tr:last td:first input').focus();
    $('#chk_DepartmentQRCodePrintdet').prop("checked", false);
    $('#chk_DepartmentQRCodePrintdet').prop("disabled", false);
    formInputValidation("DepartmentQRCodePrintingForm");
    $('#btnDepartmentQRPrint').attr('disabled', false);    
}

function BindNewRowHTML() {
    return '<tr> <td width="3%" title="Select"> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" name="DepartmentQRCodePrintCheckboxes" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(DepartmentQRCodePrintTbl,chk_DepartmentQRCodePrintdet)"> </label> </div></td><td width="27%" style="text-align: center;" title=""> <div> <input id="QRDeptUserDept_maxindexval" type="text" placeholder="Please Select" class="form-control" onkeyup="FetchDeptBlockNameQRCode(event,maxindexval)" onpaste="FetchDeptBlockNameQRCode(event,maxindexval)" change="FetchDeptBlockNameQRCode(event,maxindexval)" oninput="FetchDeptBlockNameQRCode(event,maxindexval)" required/> <div class="col-sm-12" id="divFetch_maxindexval"></div><input type="hidden" id="hdndeptUserDeptId_maxindexval" value=0> <input type="hidden" id="hdnDeptQRCodeId_maxindexval" value=0> </div></td><td width="35%" style="text-align: center;" title=""> <div> <input type="text" id="QRDeptBlock_maxindexval" class="form-control" disabled readonly/> <input type="hidden" id="hdndeptblocknameId_maxindexval" value=0> </div></td><td width="35%" style="text-align: center;" title=""> <div> <input id="QRDeptLevel_maxindexval" type="text" class="form-control" disabled readonly/> <input type="hidden" id="hdndeptLevelId_maxindexval" value=0> </div></td></tr>';
}

//******************************************** AddNewRow Fetch ****************************************************

function AddNewRow() {
    $("div.errormsgcenter1").text("");
    $('#errorMsg1').css('visibility', 'hidden');
    var rowCount = $('#DepartmentQRCodePrintTbl tr:last').index();
    var DeptBlock = $('#QRDeptBlock_' + rowCount).val();
    if (rowCount < 0)
        AddNewRowDepartmentQRCodePrint();
    else if (rowCount >= "0" && DeptBlock == "") {
        bootbox.alert("All fields are mandatory. Please enter details in existing row");        
    }
    else {
        AddNewRowDepartmentQRCodePrint();
    }
}

//******************************************** Fetch ****************************************************

function FetchDeptBlockNameQRCode(event, index) {

    $('#divFetch_' + index).css({
        'top': $('#QRDeptUserDept_' + index).offset().top - $('#DepartmentQRCodePrintingdataTable').offset().top + $('#QRDeptUserDept_' + index).innerHeight(),
        'width': $('#QRDeptUserDept_' + index).outerWidth()
    });

    var DeptQRCodeFetchObj = {
        SearchColumn: 'QRDeptUserDept_' + index + '-UserAreaName',//Id of Fetch field
        ResultColumns: ["UserAreaId" + "-Primary Key", 'UserAreaName' + '-QRDeptUserDept_' + index],//Columns to be displayed
        FieldsToBeFilled: ['QRDeptBlock_' + index + '-BlockName', "QRDeptLevel_" + index + "-LevelName", 'QRDeptUserDept_' + index + '-UserAreaName', 'hdndeptblocknameId_' + index + '-BlockId', 'hdndeptLevelId_' + index + '-LevelId', 'hdndeptUserDeptId_' + index + '-UserAreaId', 'hdnDeptQRCodeId_' + index + '-DeptQRCode']//id of element - the model property
    };
    DisplayFetchResult('divFetch_' + index, DeptQRCodeFetchObj, "/api/Fetch/UserAreaQRCodePrintingFetchModel", "UlFetch" + index, event, 1);
}

//******************************************** AddNewRow Search ****************************************************

function AddNewDeptSearchRow() {
    var inputpar = {
        inlineHTML: BindNewDeptSearchRowHTML(),

        IdPlaceholderused: "maxindexval",
        TargetId: "#DeptSearchTbl",
        TargetElement: ["tr"]

    }
    AddNewRowToDataGrid(inputpar);
}

function BindNewDeptSearchRowHTML() {
    return ' <tr id="Delrow_maxindexval"> <td class="col-sm-1"> <div class="form-group"> <div class="col-sm-12"> <select class="custom_search" id="GridList_maxindexval"> <option value="UserAreaName" selected="selected">Department Name</option><option value="BlockName" >Block Name</option> <option value="LevelName">Level Name</option>  </select> </div></div></td><td class="col-sm-1"> <div class="form-group"> <div class="col-sm-12"> <select class="custom_search" id="FilterList_maxindexval"> <option value="cn" selected="selected">contains</option> <option value="eq">equal</option> <option value="ne">not equal</option> <option value="bw">begins with</option> <option value="ew">ends with</option> </select> </div></div></td><td class="col-sm-1"> <div class="form-group"> <div class="col-sm-12"> <input type="text" class="custom_search" id="UserValue_maxindexval" placeholder=""> </div></div></td><td class="col-sm-5"> <div class="form-group"> <div class="col-sm-12"> <a class="btn btn-primary btnDelete">-</a> </div></div></td></tr> ';
}

function PushEmptyMessage() {
    $("#DepartmentQRCodePrintTbl").empty();
    var emptyrow = '<tr id="emptymsg"><td width="100%"><h5 class="text-center">No records to display</h5></td></tr>'
    $("#DepartmentQRCodePrintTbl").append(emptyrow);
    $("#addrowplus").hide();
    $('#chk_DepartmentQRCodePrintdet').prop("disabled", "disabled");
    $('#btnDepartmentQRPrint').attr('disabled', true);
}

function fetchValidation() {
    var _index;
    $('#DepartmentQRCodePrintTbl tr').each(function () {
        _index = $(this).index();
    });

    for (var i = 0; i <= _index; i++) {
        BlockId = $('#hdndeptblocknameId_' + i).val();


        if (BlockId == null || BlockId == 0 || BlockId == "") {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#QRDeptUserDept_' + i).parent().addClass('has-error');
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnDepartmentQRPrint').attr('disabled', false);
            return false;
        }
    }
}

//***************************************** Delete Valid ****************************************************



function BindGetByIdVal(Result) {
    var jqxhr = $.post("/api/DepartmentQRCode/GetModal", Result, function (response) {
        var getresult = JSON.parse(response);
        var DeptQRCodeList = getresult.DeptQRCodeListData;
        if (DeptQRCodeList == null || DeptQRCodeList == 0) {
            PushEmptyMessage();
        }
        else {
            $('#btnDepartmentQRPrint').attr('disabled', false);
            $('#chk_DepartmentQRCodePrintdet').prop("disabled", false);
            $("#emptymsg").hide();
            $("#addrowplus").show();
            // $("#DepartmentQRCodePrintTbl").empty();
            var existingNoOfRows = $('#DepartmentQRCodePrintTbl tr').length;
            $.each(getresult.DeptQRCodeListData, function (index, value) {
                var newIndex = existingNoOfRows + index;
                AddNewRowDepartmentQRCodePrint();

                //$("#hdndeptblocknameId_" + index).val(getresult.DeptQRCodeListData[index].BlockId);
                //$("#QRDeptBlock_" + index).val(getresult.DeptQRCodeListData[index].BlockName);
                //$("#hdndeptLevelId_" + index).val(getresult.DeptQRCodeListData[index].LevelId);
                //$("#QRDeptLevel_" + index).val(getresult.DeptQRCodeListData[index].LevelName);
                //$("#hdndeptUserDeptId_" + index).val(getresult.DeptQRCodeListData[index].UserAreaId);
                //$('#QRDeptUserDept_' + index).val(getresult.DeptQRCodeListData[index].UserAreaName);
                //$('#hdnDeptQRCodeId_' + index).val(getresult.DeptQRCodeListData[index].DeptQRCode);

                $("#hdndeptblocknameId_" + newIndex).val(getresult.DeptQRCodeListData[index].BlockId);
                $("#QRDeptBlock_" + newIndex).val(getresult.DeptQRCodeListData[index].BlockName).attr('title', getresult.DeptQRCodeListData[index].BlockName);
                $("#hdndeptLevelId_" + newIndex).val(getresult.DeptQRCodeListData[index].LevelId);
                $("#QRDeptLevel_" + newIndex).val(getresult.DeptQRCodeListData[index].LevelName).attr('title', getresult.DeptQRCodeListData[index].LevelName);
                $("#hdndeptUserDeptId_" + newIndex).val(getresult.DeptQRCodeListData[index].UserAreaId);
                $('#QRDeptUserDept_' + newIndex).val(getresult.DeptQRCodeListData[index].UserAreaName).prop("disabled", "disabled").attr('title', getresult.DeptQRCodeListData[index].UserAreaName);
                $('#hdnDeptQRCodeId_' + newIndex).val(getresult.DeptQRCodeListData[index].DeptQRCode);

            })

        }
            $('#myPleaseWait').modal('hide');
            $('#errorMsg').css('visibility', 'hidden');
    },
     "json")
       .fail(function (response) {
           $('#myPleaseWait').modal('hide');
           $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
           $('#errorMsg').css('visibility', 'visible');
       });

}

