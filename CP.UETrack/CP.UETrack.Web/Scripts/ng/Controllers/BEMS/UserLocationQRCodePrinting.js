//********************************************* Pagination Grid ********************************************

var pageindex = 1, pagesize = 5;
var TotalPages = 1;

//********************************************************************************

$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    var ActionType = $('#ActionType').val();
    var primaryId = $('#primaryID').val();
    $("#addrowplus").show();
    $('#jQGridCollapse1').click();
    AddNewLocationSearchRow();
    $('#chk_UserLocQRCodePrintdet').prop("disabled", true);
    $("#LocationSearchTbl").on('click', '.btnDelete', function () {
        $(this).closest('tr').remove();
    });
    formInputValidation("UserLocationQRCodePrintingForm");

    //******************************************** Getby Search ****************************************************

    $('#btnLocationQRSearch').click(function () {
        //debugger;
        var strstring = "";
        var totalstring = [];
        var _index;

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');      
        var rowcount = $("#UserLocationQRCodePrintTbl tr:last").index();
        $('#QRLocUserLoc_' + rowcount).parent().removeClass('has-error');

        $('#LocationSearchTbl tr').each(function () {
            _index = $(this).index();
        });

        var searchcondition = $("#LocationQRCodeSearchCondition").val();
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
            sqlQueryExpressionListData: totalstring
            
        }

        BindGetByIdVal(Result);        
        
    });

    //******************************************** Getby Reset ****************************************************

    $("#btnLocationQRReset").click(function () {
        $("#LocationSearchTbl").empty();
        $("#UserLocationQRCodePrintTbl").empty();
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        AddNewLocationSearchRow();
        $("#addrowplus").show();
        $('#btnLocationQRPrint').attr('disabled', true);
        $('#chk_UserLocQRCodePrintdet').prop("checked", false);
        $('#chk_UserLocQRCodePrintdet').prop("disabled", true);
    });


    //*********************************************** Print ****************************************
    $("#btnLocationQRPrint").click(function () {
        $('#btnLocationQRPrint').attr('disabled', true);
        $('#myPleaseWait').modal('show');

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var primaryId = $('#primaryID').val();
        var _index;
        
        var result = [];

        $('#UserLocationQRCodePrintTbl tr').each(function () {
            _index = $(this).index();
        });
               
       
        for (var i = 0; i <= _index; i++) {
            var IsDeleted = $('#Isdeleted_' + i).is(":checked");
            if (IsDeleted) {
                var _UserLocQRCodeWO = {
                    BlockId: $('#hdnblocknameId_' + i).val(),
                    BlockName: $('#QRLocBlock_' + i).val(),
                    LevelId: $('#hdnLevelId_' + i).val(),
                    LevelName: $('#QRLocLevel_' + i).val(),
                    UserAreaId: $('#hdnUserAreaId_' + i).val(),
                    UserAreaName: $('#QRLocUserDept_' + i).val(),
                    UserLocationId: $('#hdnUserLocId_' + i).val(),
                    UserLocationName: $('#QRLocUserLoc_' + i).val(),
                    UserLocationQRCode: $('#hdnUserLocQRCodeId_' + i).val(),
                    IsDeleted: $('#Isdeleted_' + i).is(":checked"),

                }
                result.push(_UserLocQRCodeWO);
            }            
        }          
        
       // fetchValidation();
        var obj = {
            LocationQRCodeListData: result
        }        
        if (obj.LocationQRCodeListData.length == 0) {
            $("div.errormsgcenter").text("Select records to print");
            $('#errorMsg').css('visibility', 'visible');
           // formInputValidation("UserLocationQRCodePrintingForm");
            $('#btnLocationQRPrint').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var ckfalse = 0;
        var cktrue = 0;
        for (var j = 0; j <= _index; j++) {
            var IsDeleted = $('#Isdeleted_' + j).is(":checked");
            var UserLocationQRCode = $('#hdnUserLocQRCodeId_' + j).val();
            var UserLocationName = $('#QRLocUserLoc_' + j).val();

            if (IsDeleted) {
                if (UserLocationName == "") {
                    $("div.errormsgcenter").text("Some fields are incorrect or have not been filled in. Please correct this to proceed.");
                    $('#QRLocUserLoc_' + j).parent().addClass('has-error');
                    $('#errorMsg').css('visibility', 'visible');
                    $('#myPleaseWait').modal('hide');
                    $('#btnLocationQRPrint').attr('disabled', false);
                    ckfalse += 1;
                }
                else {
                    $('#QRLocUserLoc_' + j).parent().removeClass('has-error');
                }
            }
            else {
                $('#QRLocUserLoc_' + j).parent().removeClass('has-error');
            }
        }
        if (ckfalse > 0) {
            return false;
        }

        for (var k = 0; k <= _index; k++) {
            var IsDeleted = $('#Isdeleted_' + k).is(":checked");
            var UserLocationQRCode = $('#hdnUserLocQRCodeId_' + k).val();
            var UserLocationName = $('#QRLocUserLoc_' + k).val();

            if (IsDeleted) {
                if (UserLocationQRCode == "" || UserLocationQRCode == null || UserLocationQRCode == 0) {
                    $("div.errormsgcenter").text("QR Code not generated that for Location Name");
                    $('#QRLocUserLoc_' + k).parent().addClass('has-error');
                    $('#errorMsg').css('visibility', 'visible');
                    $('#myPleaseWait').modal('hide');
                    $('#btnLocationQRPrint').attr('disabled', false);
                    cktrue += 1;
                }
                else {
                    $('#QRLocUserLoc_' + k).parent().removeClass('has-error');
                }
            }
            else {
                $('#QRLocUserLoc_' + k).parent().removeClass('has-error');
            }
        }
        if (cktrue > 0) {
            return false;
        }

            SaveUserLocQRCodeMST(obj);       

        function SaveUserLocQRCodeMST(obj) {
           
            var jqxhr = $.post("/api/UserLocationQRCode/Save", obj, function (response) {
                var result = JSON.parse(response);
                var QRCodeId = [];
                $.each(result.LocationQRCodeListData, function (index, value) {
                    QRCodeId = result.LocationQRCodeListData[index].QRCodeUserLocationId;
                });
                if (QRCodeId != 0) {
                    //showMessage('UserLocation QRCode', CURD_MESSAGE_STATUS.SS);
                    $('#myPleaseWait').modal('show');
                    window.location.href = "/bems/userlocationqrcodereport";
                }

                $('#btnLocationQRPrint').attr('disabled', false);
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

                $('#btnLocationQRPrint').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            });
        }

    });

    //************************************ Grid Delete 

    $("#chk_UserLocQRCodePrintdet").change(function () {
        var Isdeletebool = this.checked;

        if (this.checked) {
            $('#UserLocationQRCodePrintTbl tr').map(function (i) {
                if ($("#Isdeleted_" + i).prop("disabled")) {
                    $("#Isdeleted_" + i).prop("checked", false);
                }
                else {
                    $("#Isdeleted_" + i).prop("checked", true);
                }
            });
        } else {
            $('#UserLocationQRCodePrintTbl tr').map(function (i) {
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

    $("#btnUserLocReportCancel").click(function () {
        window.location.href = "bems/userlocationqrcodeprinting";
    });

});

//******************************************** AddNewRow Grid ****************************************************

function AddNewRowUserLocationQRCodePrint() {

    var inputpar = {
        inlineHTML: BindNewRowHTML(),

        IdPlaceholderused: "maxindexval",
        TargetId: "#UserLocationQRCodePrintTbl",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    $('#UserLocationQRCodePrintTbl tr:last td:first input').focus();
    $('#chk_UserLocQRCodePrintdet').prop("checked", false);
    $('#chk_UserLocQRCodePrintdet').prop("disabled", false);
    formInputValidation("UserLocationQRCodePrintingForm");
    $('#btnLocationQRPrint').attr('disabled', false);
}

function BindNewRowHTML() {
    return '<tr> <td width="3%" title="Select"> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" name="UserLocQRCodePrintCheckboxes" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(UserLocationQRCodePrintTbl,chk_UserLocQRCodePrintdet)"> </label> </div></td><td width="22%" style="text-align: center;" title=""> <div> <input id="QRLocUserLoc_maxindexval" type="text" placeholder="Please Select" class="form-control" onkeyup="FetchLocBlockNameQRCode(event,maxindexval)" onpaste="FetchLocBlockNameQRCode(event,maxindexval)" change="FetchLocBlockNameQRCode(event,maxindexval)" oninput="FetchLocBlockNameQRCode(event,maxindexval)" required/> <div class="col-sm-12" id="divFetch_maxindexval"></div><input type="hidden" id="hdnUserLocId_maxindexval" value=0> <input type="hidden" id="hdnUserLocQRCodeId_maxindexval" value=0> </div></td><td width="25%" style="text-align: center;" title=""> <div> <input type="text" id="QRLocBlock_maxindexval" class="form-control" disabled readonly/> <input type="hidden" id="hdnblocknameId_maxindexval" value=0> </div></td><td width="25%" style="text-align: center;" title=""> <div> <input id="QRLocLevel_maxindexval" type="text" class="form-control" disabled readonly/> <input type="hidden" id="hdnLevelId_maxindexval" value=0> </div></td><td width="25%" style="text-align: center;" title=""> <div> <input id="QRLocUserDept_maxindexval" type="text" class="form-control" readonly disabled/> <input type="hidden" id="hdnUserAreaId_maxindexval" value=0> </div></td></tr>';
}

//******************************************** AddNewRow Fetch ****************************************************



function BindNewRowFetchHTML() {
    return '<tr> <td width="3%" title="Select"> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" name="UserLocQRCodePrintCheckboxes" id="IsdeletedFetch_maxindexval" onchange="IsDeleteCheckAllFetch(UserLocationQRCodePrintFetchTbl,chk_UserLocQRCodePrintdetFetch)"> </label> </div></td><td width="25%" style="text-align: center;" title="Block Name"> <div> <input type="text" id="QRLocBlockFetch_maxindexval" onkeyup="FetchLocBlockNameQRCode(event,maxindexval)" onpaste="FetchLocBlockNameQRCode(event,maxindexval)" change="FetchLocBlockNameQRCode(event,maxindexval)" oninput="FetchLocBlockNameQRCode(event,maxindexval)" class="form-control" required/> <div class="col-sm-12" id="divFetch_maxindexval"></div><input type="hidden" id="hdnblocknameIdFetch_maxindexval" value=0> <input type="hidden" id="hdnUserLocQRCodeIdFetch_maxindexval" value=0> </div></td><td width="25%" style="text-align: center;" title="Level Name"> <div> <input id="QRLocLevelFetch_maxindexval" type="text" class="form-control" readonly/> <input type="hidden" id="hdnLevelIdFetch_maxindexval" value=0> </div></td><td width="25%" style="text-align: center;" title="User Area/Department"> <div> <input id="QRLocUserDeptFetch_maxindexval" type="text" class="form-control" readonly/> <input type="hidden" id="hdnUserAreaIdFetch_maxindexval" value=0> </div></td><td width="22%" style="text-align: center;" title="User Location"> <div> <input id="QRLocUserLocFetch_maxindexval" type="text" class="form-control" readonly/> <input type="hidden" id="hdnUserLocIdFetch_maxindexval" value=0> </div></td></tr>';
}

function AddNewRow() {
    $("div.errormsgcenter1").text("");
    $('#errorMsg1').css('visibility', 'hidden');
    var rowCount = $('#UserLocationQRCodePrintTbl tr:last').index();
    var LocBlock = $('#QRLocBlock_' + rowCount).val();
    if (rowCount < 0)
        AddNewRowUserLocationQRCodePrint();
    else if (rowCount >= "0" && LocBlock == "") {
        bootbox.alert("All fields are mandatory. Please enter details in existing row");        
    }
    else {
        AddNewRowUserLocationQRCodePrint();
    }
}

//******************************************** Fetch ****************************************************

function FetchLocBlockNameQRCode(event, index) {

    $('#divFetch_' + index).css({
        'top': $('#QRLocUserLoc_' + index).offset().top - $('#UserLocQRCodePrintingdataTable').offset().top + $('#QRLocUserLoc_' + index).innerHeight(),
        'width': $('#QRLocUserLoc_' + index).outerWidth()
    });

    var LocationQRCodeFetchObj = {
        SearchColumn: 'QRLocUserLoc_' + index + '-UserLocationName',//Id of Fetch field
        ResultColumns: ["UserLocationId" + "-Primary Key", 'UserLocationName' + '-QRLocUserLoc_' + index],//Columns to be displayed
        FieldsToBeFilled: ['QRLocBlock_' + index + '-BlockName', "QRLocLevel_" + index + "-LevelName", 'QRLocUserDept_' + index + '-UserAreaName', 'QRLocUserLoc_' + index + '-UserLocationName', 'hdnblocknameId_' + index + '-BlockId', 'hdnLevelId_' + index + '-LevelId', 'hdnUserAreaId_' + index + '-UserAreaId', 'hdnUserLocId_' + index + '-UserLocationId', 'hdnUserLocQRCodeId_' + index + '-UserLocQRCode']//id of element - the model property
    };
    DisplayFetchResult('divFetch_' + index, LocationQRCodeFetchObj, "/api/Fetch/UserLocationQRCodePrintingFetchModel", "UlFetch" + index, event, 1);
}

//******************************************** AddNewRow Search ****************************************************

function AddNewLocationSearchRow() {
    var inputpar = {
        inlineHTML: BindNewLocationSearchRowHTML(),

        IdPlaceholderused: "maxindexval",
        TargetId: "#LocationSearchTbl",
        TargetElement: ["tr"]

    }
    AddNewRowToDataGrid(inputpar);
}

function BindNewLocationSearchRowHTML() {
    return ' <tr id="Delrow_maxindexval"> <td class="col-sm-1"> <div class="form-group"> <div class="col-sm-12"> <select class="custom_search" id="GridList_maxindexval"> <option value="UserLocationName" selected="selected">Location Name</option><option value="BlockName">Block Name</option> <option value="LevelName">Level Name</option> <option value="UserAreaName">Department Name</option>  </select> </div></div></td><td class="col-sm-1"> <div class="form-group"> <div class="col-sm-12"> <select class="custom_search" id="FilterList_maxindexval"> <option value="cn" selected="selected">contains</option> <option value="eq">equal</option> <option value="ne">not equal</option> <option value="bw">begins with</option> <option value="ew">ends with</option> </select> </div></div></td><td class="col-sm-1"> <div class="form-group"> <div class="col-sm-12"> <input type="text" class="custom_search" id="UserValue_maxindexval" placeholder=""> </div></div></td><td class="col-sm-5"> <div class="form-group"> <div class="col-sm-12"> <a class="btn btn-primary btnDelete">-</a> </div></div></td></tr> ';
}

function PushEmptyMessage() {
    $("#UserLocationQRCodePrintTbl").empty();
    var emptyrow = '<tr id="emptymsg"><td width="100%"><h5 class="text-center">No records to display</h5></td></tr>'
    $("#UserLocationQRCodePrintTbl").append(emptyrow);
    $("#addrowplus").hide();
    $('#chk_UserLocQRCodePrintdet').prop("disabled", "disabled");
    $('#btnLocationQRPrint').attr('disabled', true);
}

function fetchValidation() {
    var _index;
    $('#UserLocationQRCodePrintTbl tr').each(function () {
        _index = $(this).index();
    });

    for (var i = 0; i <= _index; i++) {
        BlockId = $('#hdnblocknameId_' + i).val();

        var IsDeleted = $('#Isdeleted_' + i).is(":checked");
        if (IsDeleted) {

            if (BlockId == null || BlockId == 0 || BlockId == "") {
                $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
                $('#QRLocUserLoc_' + i).parent().addClass('has-error');
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                $('#btnLocationQRPrint').attr('disabled', false);
                return false;
            }

            var isFormValid = formInputValidation("UserLocationQRCodePrintingForm", 'save');
            if (!isFormValid) {
                $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                $('#btnLocationQRPrint').attr('disabled', false);
                return false;
            }
        }
        return true;
    }
}

//***************************************** Delete Valid ****************************************************

function BindGetByIdVal(Result) {
    var jqxhr = $.post("/api/UserLocationQRCode/GetModal", Result, function (response) {
        var getresult = JSON.parse(response);
        var LocationQRCodeList = getresult.LocationQRCodeListData;
        if (LocationQRCodeList == null || LocationQRCodeList == 0) {
            PushEmptyMessage();
        }
        else {
            $('#btnLocationQRPrint').attr('disabled', false);
            $('#chk_UserLocQRCodePrintdet').prop("disabled", false);
            $("#emptymsg").hide();
            $("#addrowplus").show();
            // $("#UserLocationQRCodePrintTbl").empty();
            var existingNoOfRows = $('#UserLocationQRCodePrintTbl tr').length;
            $.each(getresult.LocationQRCodeListData, function (index, value) {
                var newIndex = existingNoOfRows + index;
                AddNewRowUserLocationQRCodePrint();

                //$("#hdnblocknameId_" + index).val(getresult.LocationQRCodeListData[index].BlockId);
                //$("#QRLocBlock_" + index).val(getresult.LocationQRCodeListData[index].BlockName);
                //$("#hdnLevelId_" + index).val(getresult.LocationQRCodeListData[index].LevelId);
                //$("#QRLocLevel_" + index).val(getresult.LocationQRCodeListData[index].LevelName);
                //$("#hdnUserAreaId_" + index).val(getresult.LocationQRCodeListData[index].UserAreaId);
                //$('#QRLocUserDept_' + index).val(getresult.LocationQRCodeListData[index].UserAreaName);
                //$("#hdnUserLocId_" + index).val(getresult.LocationQRCodeListData[index].UserLocationId);
                //$('#QRLocUserLoc_' + index).val(getresult.LocationQRCodeListData[index].UserLocationName);
                //$('#hdnUserLocQRCodeId_' + index).val(getresult.LocationQRCodeListData[index].UserLocationQRCode)

                $("#hdnblocknameId_" + newIndex).val(getresult.LocationQRCodeListData[index].BlockId);
                $("#QRLocBlock_" + newIndex).val(getresult.LocationQRCodeListData[index].BlockName).attr('title', getresult.LocationQRCodeListData[index].BlockName);
                $("#hdnLevelId_" + newIndex).val(getresult.LocationQRCodeListData[index].LevelId);
                $("#QRLocLevel_" + newIndex).val(getresult.LocationQRCodeListData[index].LevelName).attr('title', getresult.LocationQRCodeListData[index].LevelName);
                $("#hdnUserAreaId_" + newIndex).val(getresult.LocationQRCodeListData[index].UserAreaId);
                $('#QRLocUserDept_' + newIndex).val(getresult.LocationQRCodeListData[index].UserAreaName).attr('title', getresult.LocationQRCodeListData[index].UserAreaName);
                $("#hdnUserLocId_" + newIndex).val(getresult.LocationQRCodeListData[index].UserLocationId).prop("disabled", "disabled");
                $('#QRLocUserLoc_' + newIndex).val(getresult.LocationQRCodeListData[index].UserLocationName).prop("disabled", "disabled").attr('title', getresult.LocationQRCodeListData[index].UserLocationName);;
                $('#hdnUserLocQRCodeId_' + newIndex).val(getresult.LocationQRCodeListData[index].UserLocationQRCode);

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


