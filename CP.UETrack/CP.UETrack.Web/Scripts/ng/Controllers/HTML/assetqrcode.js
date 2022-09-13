//********************************************* Pagination Grid ********************************************

var pageindex = 1, pagesize = 5;
var TotalPages = 1;
//***********************************************************************************************

$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    var ActionType = $('#ActionType').val();
    var primaryId = $('#primaryID').val();
    AddNewSearchRow();
    $("#searchTbl").on('click', '.btnDelete', function () {
        $(this).closest('tr').remove();
    });
    formInputValidation("AssetQRCodePrintingForm");

    //******************************************** Getby Search ****************************************************

    $('#btnAssetQRSearch').click(function () {

        var strstring = "";
        var totalstring = [];
        var _index;

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $('#searchTbl tr').each(function () {
            _index = $(this).index();
        });

        var searchcondition = $("#QRCodeSearchCondition").val();
        for (var i = 0; i <= _index; i++) {
            var ModelVal = $("#GridList_" + i).val();
            var ConditionVal = $("#FilterList_" + i).val();
            var TextVal = $("#UserValue_" + i).val();

            //if (searchcondition == 'AND')
            //{
            //    if (i != 0) { strstring += ' and '};
            //}
            //if (searchcondition == 'OR') {
            //    if (i != 0) { strstring += ' or ' };
            //}

            //if (ConditionVal == "ne") {
            //    strstring += ("(" + "[" + ModelVal + "]" + " != " + "(\'" + TextVal + "\')" + ")");
            //} 
            //else if (ConditionVal == "cn") {
            //    strstring += ("(" + "[" + ModelVal + "]" + " LIKE " + "("+"\'"+"%" + TextVal + "%"+"\'"+")" + ")");
            //}
            //else if (ConditionVal == "eq") {
            //    strstring += ("(" + "[" + ModelVal + "]" + " = " + "(\'" + TextVal + "\')" + ")");
            //}

            var querystr = {
                ModelName: ModelVal,
                ConditionName: ConditionVal,
                TextName: TextVal,
                GroupOp: searchcondition,
            };

            totalstring.push(querystr);

        }
        var Assetobj = {
            sqlQueryExpressionListData: totalstring,
            // QueryWhereCondition: strstring,
            PageSize: $('#selPageSize').val(),
            PageIndex: pageindex,
            PageSize: pagesize

        }

        var QueryWhereCondition = strstring;

        BindGetByIdVal(Assetobj);

    });

    //******************************************** Getby Reset ****************************************************

    $('#btnAssetQRReset').click(function () {
        $('#searchTbl').empty();
        AddNewSearchRow();

    });

    //********************************************** print *******************************************

    $("#btnAssetQRPrint").click(function () {
        $('#btnAssetQRPrint').attr('disabled', true);
        $('#myPleaseWait').modal('show');

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var _index;
        var _indexFetch;
        var result = [];
        var primaryId = $('#primaryID').val();

        $('#AssetQRCodePrintTbl tr').each(function () {
            _index = $(this).index();
        });

        $('#AssetQRCodePrintFetchTbl tr').each(function () {
            _indexFetch = $(this).index();
        });

        for (var i = 0; i <= _index; i++) {

            var _AssetQRCodeWO = {
                AssetId: $('#hdnAssetnoId_' + i).val(),
                AssetNo: $('#QRAssetNo_' + i).val(),
                UserAreaId: $('#hdnUserAreaId_' + i).val(),
                UserAreaName: $('#QRUserarea_' + i).val(),
                UserLocationId: $('#hdnUserLocId_' + i).val(),
                UserLocationName: $('#QRUserLoc_' + i).val(),
                AssetDescription: $('#QRAssetdesc_' + i).val(),
                AssetTypeCode: $('#QRAssettypecode_' + i).val(),
                Manufacturer: $('#QRManufacturer_' + i).val(),
                Model: $('#QRModel_' + i).val(),
                AssetQRCode: $('#hdnAssetQRCodeId_' + i).val(),
                IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),

            }
            result.push(_AssetQRCodeWO);
        }


        for (var j = 0; j <= _indexFetch; j++) {

            var _AssetQRCodeWOFetch = {
                AssetId: $('#hdnAssetnoIdfetch_' + j).val(),
                AssetNo: $('#QRAssetNofetch_' + j).val(),
                UserAreaId: $('#hdnUserAreaIdfetch_' + j).val(),
                UserAreaName: $('#QRUserareafetch_' + j).val(),
                UserLocationId: $('#hdnUserLocIdfetch_' + j).val(),
                UserLocationName: $('#QRUserLocfetch_' + j).val(),
                AssetDescription: $('#QRAssetdescfetch_' + j).val(),
                AssetTypeCode: $('#QRAssettypecodefetch_' + j).val(),
                Manufacturer: $('#QRManufacturerfetch_' + j).val(),
                Model: $('#QRModelfetch_' + j).val(),
                AssetQRCode: $('#hdnAssetQRCodeIdfetch_' + j).val(),
                IsDeleted: chkIsDeletedRowFetch(j, $('#IsdeletedFetch_' + j).is(":checked")),

            }
            result.push(_AssetQRCodeWOFetch);
        }

        var deletedCount = Enumerable.From(result).Where(x=>x.IsDeleted).Count();
        var Isdeleteavailable = deletedCount > 0;
        //if (deletedCount == result.length && result.length > 0 && TotalPages == 1) {
        //    bootbox.alert("Sorry!. You cannot delete all rows");
        //    $('#btnAssetQRPrint').attr('disabled', false);

        //    $('#myPleaseWait').modal('hide');
        //    return false;
        //}      

        if (Isdeleteavailable == false) {

            var isFormValid = formInputValidation("AssetQRCodePrintingForm", 'save');
            if (!isFormValid) {
                fetchValidation();
                $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                $('#btnAssetQRPrint').attr('disabled', false);
                return false;
            }

            var ckfalse = 0;
            for (var j = 0; j <= _indexFetch; j++) {
                if (result[j].AssetId == "" || result[j].AssetId == null || result[j].AssetId == 0) {
                    $("div.errormsgcenter").text("Invalid AssetNo.");
                    $('#QRAssetNofetch_' + j).parent().addClass('has-error');
                    $('#errorMsg').css('visibility', 'visible');
                    ckfalse += 1;
                    $('#myPleaseWait').modal('hide');
                    $('#btnAssetQRPrint').attr('disabled', false);
                }
            }
            if (ckfalse > 0) {
                return false;
            }
        }

        var obj = {
            AssetQRCodeListData: result
        }

        if (Isdeleteavailable == true) {
            $('#myPleaseWait').modal('hide');
            $('#errorMsg').css('visibility', 'hidden');
            bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (result) {
                if (result) {
                    for (var i = 0; i <= _index; i++) {
                        var IsDeleted = chkIsRemovedRow(i, $('#Isdeleted_' + i).is(":checked"));
                    }
                    for (var j = 0; j <= _indexFetch; j++) {
                        var IsDeletedFetch = chkIsRemovedRowFetch(j, $('#IsdeletedFetch_' + j).is(":checked"));
                    }
                    SaveAssetQRCodeMST(obj);
                }
                else {
                    $('#myPleaseWait').modal('hide');
                    $('#btnAssetQRPrint').attr('disabled', false);
                }
            });
        }
        else {
            SaveAssetQRCodeMST(obj);
        }

        function SaveAssetQRCodeMST(obj) {

            var jqxhr = $.post("/api/AssetQRCode/Save", obj, function (response) {
                var result = JSON.parse(response);
                var QRCodeId = [];
                $.each(result.AssetQRCodeListData, function (index, value) {

                    QRCodeId = result.AssetQRCodeListData[index].QRCodeAssetId;

                });

                if (QRCodeId != 0) {
                    //showMessage('Asset QRCode', CURD_MESSAGE_STATUS.SS); 
                    window.location.href = "/bems/AssetQRCodeReport";
                }

                $('#btnAssetQRPrint').attr('disabled', false);
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
                $("div.errormsgcenter").text(errorMessage).css('visibility', 'visible');
                $('#errorMsg').css('visibility', 'visible');

                $('#btnAssetQRPrint').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            });
        }

    });

    //************************************ Grid Delete 

    $("#chk_AssetQRCodePrintdet").change(function () {
        var Isdeletebool = this.checked;

        if (this.checked) {
            $('#AssetQRCodePrintTbl tr').map(function (i) {
                if ($("#Isdeleted_" + i).prop("disabled")) {
                    $("#Isdeleted_" + i).prop("checked", false);
                }
                else {
                    $("#Isdeleted_" + i).prop("checked", true);
                }
            });
        } else {
            $('#AssetQRCodePrintTbl tr').map(function (i) {
                $("#Isdeleted_" + i).prop("checked", false);
            });
        }
    });


    //*********************************** Fetch Delete

    $("#chk_AssetQRCodePrintdetFetch").change(function () {
        var Isdeletebool = this.checked;

        if (this.checked) {
            $('#AssetQRCodePrintFetchTbl tr').map(function (j) {
                if ($("#IsdeletedFetch_" + j).prop("disabled")) {
                    $("#IsdeletedFetch_" + j).prop("checked", false);
                }
                else {
                    $("#IsdeletedFetch_" + j).prop("checked", true);
                }
            });
        } else {
            $('#AssetQRCodePrintFetchTbl tr').map(function (j) {
                $("#IsdeletedFetch_" + j).prop("checked", false);
            });
        }
    });


    $("#btnAddNew").click(function () {
        window.location.href = window.location.href;
    });
    $("#btnCancel").click(function () {
        window.location.href = "";
    });

    $("#btnAssetReportCancel").click(function () {
        window.location.href = "/bems/AssetQRCodePrint";
    });

});

//******************************************** AddNewRow Grid ****************************************************

function AddNewRowAssetQRCodePrint() {

    var inputpar = {
        inlineHTML: BindNewRowHTML(),

        IdPlaceholderused: "maxindexval",
        TargetId: "#AssetQRCodePrintTbl",
        TargetElement: ["tr"]

    }
    AddNewRowToDataGrid(inputpar);
    $('#chk_AssetQRCodePrintdet').prop("checked", false);
    $('#AssetQRCodePrintTbl tr:last td:first input').focus();
    formInputValidation("AssetQRCodePrintingForm");

}

function BindNewRowHTML() {
    return '<tr> <td width="3%" title="Select"> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" name="AssetQRCodePrintCheckboxes" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(AssetQRCodePrintTbl,chk_AssetQRCodePrintdet)"> </label> </div></td><td width="20%" style="text-align: center;" title="Asset No."> <div> <input type="text" id="QRAssetNo_maxindexval" class="form-control" /> <input type="hidden" id="hdnAssetnoId_maxindexval" value=0> <input type="hidden" id="hdnAssetQRCodeId_maxindexval" value=0> </div></td><td width="15%" style="text-align: center;" title="User Area/Department"> <div> <input id="QRUserarea_maxindexval" type="text" class="form-control" readonly/> <input type="hidden" id="hdnUserAreaId_maxindexval" value=0> </div></td><td width="14%" style="text-align: center;" title="User Location"> <div> <input id="QRUserLoc_maxindexval" type="text" class="form-control" readonly/> <input type="hidden" id="hdnUserLocId_maxindexval" value=0> </div></td><td width="15%" style="text-align: center;" title="Asset Description"> <div> <input id="QRAssetdesc_maxindexval" type="text" class="form-control" readonly/> </div></td><td width="13%" style="text-align: center;" title="Asset Type Code"> <div> <input id="QRAssettypecode_maxindexval" type="text" class="form-control" readonly/> </div></td><td width="10%" style="text-align: center;" title="Manufacturer"> <div> <input type="text" id="QRManufacturer_maxindexval" class="form-control" readonly/> </div></td><td width="10%" style="text-align: center;" title="Model"> <div> <input id="QRModel_maxindexval" type="text" class="form-control" readonly/> </div></td></tr>';
}

//******************************************** AddNewRow Fetch ****************************************************

function AddNewRowAssetQRCodePrintFetch() {

    var inputpar = {
        inlineHTML: BindNewRowFetchHTML(),

        IdPlaceholderused: "maxindexval",
        TargetId: "#AssetQRCodePrintFetchTbl",
        TargetElement: ["tr"]

    }
    AddNewRowToDataGrid(inputpar);
    $('#chk_AssetQRCodePrintdetFetch').prop("checked", false);
    $('#AssetQRCodePrintFetchTbl tr:last td:first input').focus();
    formInputValidation("AssetQRCodePrintingForm");

}

function BindNewRowFetchHTML() {
    return '<tr> <td width="3%" title="Select"> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" name="AssetQRCodePrintCheckboxes" id="IsdeletedFetch_maxindexval" onchange="IsDeleteCheckAllFetch(AssetQRCodePrintFetchTbl,chk_AssetQRCodePrintdetFetch)"> </label> </div></td><td width="20%" style="text-align: center;" title="Asset No."> <div> <input type="text" id="QRAssetNofetch_maxindexval" onkeyup="FetchAssetNoQRCode(event,maxindexval)" onpaste="FetchAssetNoQRCode(event,maxindexval)" onchange="FetchAssetNoQRCode(event,maxindexval)" oninput="FetchAssetNoQRCode(event,maxindexval)" class="form-control" required/> <div class="col-sm-12" id="divFetch_maxindexval"></div><input type="hidden" id="hdnAssetnoIdfetch_maxindexval" value=0> <input type="hidden" id="hdnAssetQRCodeIdfetch_maxindexval" value=0> </div></td><td width="15%" style="text-align: center;" title="User Area/Department"> <div> <input id="QRUserareafetch_maxindexval" type="text" class="form-control" readonly/> <input type="hidden" id="hdnUserAreaIdfetch_maxindexval" value=0> </div></td><td width="14%" style="text-align: center;" title="User Location"> <div> <input id="QRUserLocfetch_maxindexval" type="text" class="form-control" readonly/> <input type="hidden" id="hdnUserLocIdfetch_maxindexval" value=0> </div></td><td width="15%" style="text-align: center;" title="Asset Description"> <div> <input id="QRAssetdescfetch_maxindexval" type="text" class="form-control" readonly/> </div></td><td width="13%" style="text-align: center;" title="Asset Type Code"> <div> <input id="QRAssettypecodefetch_maxindexval" type="text" class="form-control" readonly/> </div></td><td width="10%" style="text-align: center;" title="Manufacturer"> <div> <input type="text" id="QRManufacturerfetch_maxindexval" class="form-control" readonly/> </div></td><td width="10%" style="text-align: center;" title="Model"> <div> <input id="QRModelfetch_maxindexval" type="text" class="form-control" readonly/> </div></td></tr>';
}

function AddNewRow() {
    $("div.errormsgcenter1").text("");
    $('#errorMsg1').css('visibility', 'hidden');
    var rowCount = $('#AssetQRCodePrintTbl tr:last').index();
    var AssetNo = $('#QRAssetNo_' + rowCount).val();
    if (rowCount < 0)
        AddNewRowAssetQRCodePrint();
    else if (rowCount >= "0" && AssetNo == "") {
        bootbox.alert("All fields are mandatory. Please enter details in existing row");
    }
    else {
        AddNewRowAssetQRCodePrint();
    }
}

//******************************************** Fetch ****************************************************

function FetchAssetNoQRCode(event, index) {
    var AsserQRCodeFetchObj = {
        SearchColumn: 'QRAssetNo_' + index + '-AssetNo',//Id of Fetch field
        ResultColumns: ["AssetId" + "-Primary Key", 'AssetNo' + '-QRAssetNo_' + index],//Columns to be displayed
        FieldsToBeFilled: ['QRAssetNo_' + index + '-AssetNo', "QRUserarea_" + index + "-UserAreaName", 'QRUserLoc_' + index + '-UserLocationName', 'QRAssetdesc_' + index + '-AssetDescription', 'QRAssettypecode_' + index + '-AssetTypeCode', 'QRManufacturer_' + index + '-Manufacturer', 'QRModel_' + index + '-Model', 'hdnAssetnoId_' + index + '-AssetId', 'hdnUserAreaId_' + index + '-UserAreaId', 'hdnUserLocId_' + index + '-UserLocationId', 'hdnAssetQRCodeId_' + index + '-AssetQRCode']//id of element - the model property
    };
    DisplayFetchResult('divFetch_' + index, AsserQRCodeFetchObj, "/api/Fetch/AssetQRCodePrintFetchModel", "UlFetch" + index, event, 1);
}

//******************************************** AddNewRow Search ****************************************************

function AddNewSearchRow() {
    var inputpar = {
        inlineHTML: BindNewSearchRowHTML(),

        IdPlaceholderused: "maxindexval",
        TargetId: "#searchTbl",
        TargetElement: ["tr"]

    }
    AddNewRowToDataGrid(inputpar);
}

function BindNewSearchRowHTML() {
    return ' <tr id="Delrow_maxindexval"> <td class="col-sm-1"> <div class="form-group"> <div class="col-sm-12"> <select class="custom_search" id="GridList_maxindexval"> <option value="AssetNo" selected="selected">Asset No</option> <option value="UserAreaName">User Area/Department</option> <option value="UserLocationName">User Location</option> <option value="AssetDescription">Asset Description</option> <option value="AssetTypeCode">Asset Type Code</option> <option value="Manufacturer">Manufacturer</option> <option value="Model">Model</option> </select> </div></div></td><td class="col-sm-1"> <div class="form-group"> <div class="col-sm-12"> <select class="custom_search" id="FilterList_maxindexval"> <option value="cn" selected="selected">contains</option> <option value="eq">equal</option> <option value="ne">not equal</option> <option value="bw">begins with</option> <option value="ew">ends with</option> </select> </div></div></td><td class="col-sm-1"> <div class="form-group"> <div class="col-sm-12"> <input type="text" class="custom_search" id="UserValue_maxindexval" placeholder="Enter Value"> </div></div></td><td class="col-sm-5"> <div class="form-group"> <div class="col-sm-12"> <a class="btn btn-primary btnDelete">-</a> </div></div></td></tr> ';
}

function PushEmptyMessage() {
    $("#AssetQRCodePrintTbl").empty();
    var emptyrow = '<tr><td width="100%"><h5 class="text-center">No records to display</h5></td></tr>'
    $("#AssetQRCodePrintTbl").append(emptyrow);
}

function fetchValidation() {
    var _index;
    $('#AssetQRCodePrintTbl tr').each(function () {
        _index = $(this).index();
    });

    for (var i = 0; i <= _index; i++) {
        AssetId = $('#hdnAssetnoId_' + i).val();

        if (AssetId == null || AssetId == 0 || AssetId == "") {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#QRAssetNo_' + i).parent().addClass('has-error');
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnAssetQRPrint').attr('disabled', false);
            return false;
        }
    }
}

//***************************************** Delete Valid ****************************************************

function chkIsDeletedRow(i, delrec) {
    if (delrec == true) {
        $('#QRAssetNo_' + i).prop("required", false);
        return true;
    }
    else {
        return false;
    }
}

function chkIsDeletedRowFetch(i, delrec) {
    if (delrec == true) {
        $('#QRAssetNofetch_' + i).prop("required", false);
        $('#QRAssetNofetch_' + i).parent().removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
        return true;
    }
    else {
        return false;
    }
}

function chkIsRemovedRow(i, delrec) {
    if (delrec == true) {
        $('#QRAssetNo_' + i).prop("required", false);
        $('#QRAssetNo_' + i).parent().removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
        $('#QRAssetNo_' + i).closest('tr').remove();
        $('#chk_AssetQRCodePrintdet').prop("checked", false);
        return true;
    }
    else {
        return false;
    }
}

function chkIsRemovedRowFetch(j, delrec) {
    if (delrec == true) {
        $('#QRAssetNofetch_' + j).prop("required", false);
        $('#QRAssetNofetch_' + j).parent().removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
        $('#QRAssetNofetch_' + j).closest('tr').remove();
        $('#chk_AssetQRCodePrintdetFetch').prop("checked", false);
        return true;
    }
    else {
        return false;
    }
}

function IsDeleteCheckAllFetch() {
    var Isdeleted_ = [];
    $('#AssetQRCodePrintFetchTbl tr').map(function (index, value) {
        var Isdelete = $("#IsdeletedFetch_" + index).is(":checked");
        if (Isdelete)
            Isdeleted_.push(Isdelete);
    });

    if ($('#AssetQRCodePrintFetchTbl tr').length == Isdeleted_.length)
        $("#chk_AssetQRCodePrintdetFetch").prop("checked", true);
    else
        $("#chk_AssetQRCodePrintdetFetch").prop("checked", false);

}

function BindGetByIdVal(Assetobj) {
    var jqxhr = $.post("/api/AssetQRCode/GetModal", Assetobj, function (response) {
        var getresult = JSON.parse(response);
        var AssetQRcodeList = getresult.AssetQRCodeListData;
        if (AssetQRcodeList == null || AssetQRcodeList == 0) {
            PushEmptyMessage();
        }
        else {
            $("#AssetQRCodePrintTbl").empty();
            var existingNoOfRows = $('#AssetQRCodePrintTbl tr').length;

            $.each(getresult.AssetQRCodeListData, function (index, value) {
                var newIndex = existingNoOfRows + index;
                AddNewRowAssetQRCodePrint();

                $("#hdnAssetnoId_" + index).val(getresult.AssetQRCodeListData[index].AssetId);
                $("#QRAssetNo_" + index).val(getresult.AssetQRCodeListData[index].AssetNo);
                $("#hdnUserAreaId_" + index).val(getresult.AssetQRCodeListData[index].UserAreaId);
                $("#hdnUserLocId_" + index).val(getresult.AssetQRCodeListData[index].UserLocationId);
                $("#QRUserarea_" + index).val(getresult.AssetQRCodeListData[index].UserAreaName);
                $('#QRUserLoc_' + index).val(getresult.AssetQRCodeListData[index].UserLocationName);
                $('#QRAssetdesc_' + index).val(getresult.AssetQRCodeListData[index].AssetDescription);
                $("#QRAssettypecode_" + index).val(getresult.AssetQRCodeListData[index].AssetTypeCode);
                $("#QRManufacturer_" + index).val(getresult.AssetQRCodeListData[index].Manufacturer);
                $("#QRModel_" + index).val(getresult.AssetQRCodeListData[index].Model);
                $("#hdnAssetQRCodeId_" + index).val(getresult.AssetQRCodeListData[index].AssetQRCode);

                //$("#hdnAssetnoId_" + newIndex).val(getresult.AssetQRCodeListData[index].AssetId);
                //$("#QRAssetNo_" + newIndex).val(getresult.AssetQRCodeListData[index].AssetNo);                

            })

            $('#divPagination').html(null);
            $('#divPagination').html(paginationString);
            SetPaginationValues(getresult);
        }

        $('#myPleaseWait').modal('hide');
        $('#errorMsg').css('visibility', false);
    },
     "json")
     .fail(function () {
         $('#myPleaseWait').modal('hide');
         $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
         $('#errorMsg').css('visibility', 'visible');
     });
}

//***************************************** Pagination *******************************************

function SetPaginationValues(result) {
    var PageIndex = 0;
    var TotalRecords = 0;
    var FirstRecord = 0;
    var LastRecord = 0;
    var LastPageIndex = 0;

    var firstObject = $.grep(result.AssetQRCodeListData, function (value0, index0) {
        return index0 == 0;
    });
    PageIndex = firstObject[0].PageIndex;
    PageSize = firstObject[0].PageSize;
    TotalRecords = firstObject[0].TotalRecords;
    FirstRecord = firstObject[0].FirstRecord;
    LastRecord = firstObject[0].LastRecord;
    LastPageIndex = firstObject[0].LastPageIndex;

    if (PageIndex == 1) {
        $('#btnPreviousPage').removeClass('pagerEnabled');
        $('#btnPreviousPage').addClass('pagerDisabled');
        $('#btnFirstPage').removeClass('pagerEnabled');
        $('#btnFirstPage').addClass('pagerDisabled');
    }
    else {
        $('#btnPreviousPage').removeClass('pagerDisabled');
        $('#btnPreviousPage').addClass('pagerEnabled');
        $('#btnFirstPage').removeClass('pagerDisabled');
        $('#btnFirstPage').addClass('pagerEnabled');
    }
    if (PageIndex == LastPageIndex) {
        $('#btnNextPage').removeClass('pagerEnabled');
        $('#btnNextPage').addClass('pagerDisabled');
        $('#btnLastPage').removeClass('pagerEnabled');
        $('#btnLastPage').addClass('pagerDisabled');
    }
    else {
        $('#btnNextPage').removeClass('pagerDisabled');
        $('#btnNextPage').addClass('pagerEnabled');
        $('#btnLastPage').removeClass('pagerDisabled');
        $('#btnLastPage').addClass('pagerEnabled');
    }

    $('#spnTotalRecords').text(TotalRecords);
    $('#spnFirstRecord').text(FirstRecord);
    $('#spnLastRecord').text(LastRecord);
    $('#txtPageIndex').val(PageIndex);
    $('#hdnPageIndex').val(PageIndex);
    $('#selPageSize').val(PageSize);
    AttachPaginationEvents(LastPageIndex);
}

function AttachPaginationEvents(LastPageIndex) {
    $('#btnPreviousPage').unbind("click");
    $('#btnNextPage').unbind("click");
    $('#btnFirstPage').unbind("click");
    $('#btnLastPage').unbind("click");

    $('#btnPreviousPage, #btnNextPage, #btnFirstPage, #btnLastPage').click(function () {
        var id = $(this).attr('id');

        var currentPageIndex = parseInt($('#hdnPageIndex').val());
        if (id == "btnPreviousPage") {
            currentPageIndex -= 1;
        }
        else if (id == "btnNextPage") {
            currentPageIndex += 1;
        }
        else if (id == "btnFirstPage") {
            currentPageIndex = 1;
        }
        else if (id == "btnLastPage") {
            currentPageIndex = LastPageIndex;
        }
        PopulatePopupData(currentPageIndex);
    });

    $('#txtPageIndex').on("keypress", function (e) {
        if (e.keyCode == 13) {
            var pageindex1 = $('#txtPageIndex').val();
            if (pageindex1 == null || pageindex1 == '' || isNaN(pageindex1)) {
                bootbox.alert('Please enter valid page number.');
                $('#txtPageIndex').val($('#hdnPageIndex').val());
                return false;
            } else {
                pageindex1 = parseInt(pageindex1);
                if (pageindex1 > LastPageIndex) {
                    bootbox.alert('Please enter valid page number.');
                    $('#txtPageIndex').val($('#hdnPageIndex').val());
                    return false;
                } else {
                    PopulatePopupData(pageindex1);
                }
            }
        }
    });

    $('#selPageSize').on('change', function () {
        PopulatePopupData(1);
    });
}

function PopulatePopupData(pageIndex) {

    var strstring = "";
    var totalstring = [];
    var _index;

    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#searchTbl tr').each(function () {
        _index = $(this).index();
    });
    var searchcondition = $("#QRCodeSearchCondition").val();
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
    var Assetobj = {
        sqlQueryExpressionListData: totalstring,
        PageSize: $('#selPageSize').val(),
        PageIndex: pageIndex        
    }      

        BindGetByIdVal(Assetobj);

}
