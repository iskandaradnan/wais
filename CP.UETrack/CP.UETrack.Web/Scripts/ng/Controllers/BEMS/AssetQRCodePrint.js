//********************************************* Pagination Grid ********************************************

var pageindex = 1, pagesize = 5;
var TotalPages = 1;
//***********************************************************************************************

$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    var ActionType = $('#ActionType').val();
    var primaryId = $('#primaryID').val();
    $('#jQGridCollapse1').click();
    $("#addrowplus").show();
    AddNewSearchRow();
    $('#chk_AssetQRCodePrintdet').prop("disabled", true);
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
        var rowcount = $("#AssetQRCodePrintTbl tr:last").index();
        $('#QRAssetNo_' + rowcount).parent().removeClass('has-error');

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
               sqlQueryExpressionListData: totalstring              
              
        }

        var QueryWhereCondition = strstring;              

        BindGetByIdVal(Assetobj);
      
    });

    //******************************************** Getby Reset ****************************************************

    $('#btnAssetQRReset').click(function () {
        $('#searchTbl').empty();
        $("#AssetQRCodePrintTbl").empty();
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        AddNewSearchRow();
        $("#addrowplus").show();
        $('#btnAssetQRPrint').attr('disabled', true);
        $('#chk_AssetQRCodePrintdet').prop("checked", false);
        $('#chk_AssetQRCodePrintdet').prop("disabled", true);
    });

    //********************************************** print *******************************************

    $("#btnAssetQRPrint").click(function () {
        $('#btnAssetQRPrint').attr('disabled', true);        
        $('#myPleaseWait').modal('show');

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var _index;
        var _indexfetch;
        var result = [];
        var ckfalse = 0;
        var primaryId = $('#primaryID').val();       

        $('#AssetQRCodePrintTbl tr').each(function () {
            _index = $(this).index();

        });
        
       
        for (var i = 0; i <= _index; i++) {
            var IsDeleted = $('#Isdeleted_' + i).is(":checked");
            
            if (IsDeleted) {
                var _AssetQRCodeWOdet = {
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
                    ContractType: $('#QRContractType_' + i).val(),
                    AssetQRCode: $('#hdnAssetQRCodeId_' + i).val(),
                    IsDeleted: $('#Isdeleted_' + i).is(":checked"),
                }
                result.push(_AssetQRCodeWOdet);
            }
            //else {
            //    $("div.errormsgcenter").text("Select records to print");
            //    $('#errorMsg').css('visibility', 'visible');
            //    $('#btnDepartmentQRPrint').attr('disabled', false);
            //    $('#myPleaseWait').modal('hide');
            //    return false;
            //}
            
        }          

            //var isFormValid = formInputValidation("AssetQRCodePrintingForm", 'save');
            //if (!isFormValid) {
            //    fetchValidation();
            //    $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            //    $('#errorMsg').css('visibility', 'visible');
            //    $('#myPleaseWait').modal('hide');
            //    $('#btnAssetQRPrint').attr('disabled', false);
            //    return false;
            //}
            
            //for (var j = 0; j <= _index; j++) {
                
            //    if (result[j].IsDeleted) {
            //        if (result[j].AssetId == "" || result[j].AssetId == null || result[j].AssetId == 0) {
            //            $("div.errormsgcenter").text("Invalid AssetNo.");
            //            $('#QRAssetNo_' + j).parent().addClass('has-error');
            //            $('#errorMsg').css('visibility', 'visible');
            //            ckfalse += 1;
            //            $('#myPleaseWait').modal('hide');
            //            $('#btnAssetQRPrint').attr('disabled', false);
            //        }
            //    }
            //}
            //if (ckfalse > 0) {
            //    return false;
            //}
       

        var obj = {
            AssetQRCodeListData: result
        }
        if (obj.AssetQRCodeListData.length == 0) {
            $("div.errormsgcenter").text("Select records to print").css('visibility', 'visible');
            $('#errorMsg').css('visibility', 'visible');
           // formInputValidation("AssetQRCodePrintingForm");
            $('#btnAssetQRPrint').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var ckfalse = 0;
        var cktrue = 0;
        for (var j = 0; j <= _index; j++) {
            var IsDeleted = $('#Isdeleted_' + j).is(":checked");
            var AssetQRCode = $('#hdnAssetQRCodeId_' + j).val();
            var AssetNo = $('#QRAssetNo_' + j).val();
            
            if (IsDeleted) {
                if (AssetNo == "") {
                    $("div.errormsgcenter").text("Some fields are incorrect or have not been filled in. Please correct this to proceed.");
                    $('#QRAssetNo_' + j).parent().addClass('has-error');
                    $('#errorMsg').css('visibility', 'visible');
                    $('#myPleaseWait').modal('hide');
                    $('#btnAssetQRPrint').attr('disabled', false);
                    ckfalse += 1;
                }
                else {
                    $('#QRAssetNo_' + j).parent().removeClass('has-error');
                }               
            }
            else {
                $('#QRAssetNo_' + j).parent().removeClass('has-error');
            }            
        }

        if (ckfalse > 0) {
            return false;
        }

        for (var k = 0; k <= _index; k++) {
            var IsDeleted = $('#Isdeleted_' + k).is(":checked");
            var AssetQRCode = $('#hdnAssetQRCodeId_' + k).val();
            var AssetNo = $('#QRAssetNo_' + k).val();

            if (IsDeleted) {
                 if (AssetQRCode == "" || AssetQRCode == null || AssetQRCode == 0) {
                    $("div.errormsgcenter").text("QR Code not generated for that Asset No.");
                    $('#QRAssetNo_' + k).parent().addClass('has-error');
                    $('#errorMsg').css('visibility', 'visible');
                    $('#myPleaseWait').modal('hide');
                    $('#btnAssetQRPrint').attr('disabled', false);
                    cktrue += 1;
                 }
                 else {
                     $('#QRAssetNo_' + k).parent().removeClass('has-error');
                 }
            }
            else {
                $('#QRAssetNo_' + k).parent().removeClass('has-error');
            }
        }

        if (cktrue > 0) {
            return false;
        }
        
            SaveAssetQRCodeMST(obj);
        

        function SaveAssetQRCodeMST(obj) {            
            var jqxhr = $.post("/api/AssetQRCode/Save", obj, function (response) {
                var result = JSON.parse(response);
                var QRCodeId = [];                
                $.each(result.AssetQRCodeListData, function (index, value) {
                    QRCodeId = result.AssetQRCodeListData[index].QRCodeAssetId;                     
                });                
                if (QRCodeId != 0) {
                    $('#myPleaseWait').modal('show');
                    //showMessage('Asset QRCode', CURD_MESSAGE_STATUS.SS); 
                      window.location.href = "/bems/assetqrcodereport";                                     
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
                    errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
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


   
    $("#btnAddNew").click(function () {
        window.location.href = window.location.href;
    });    
    $("#btnCancel").click(function () {
        window.location.href = "";
    });

    $("#btnAssetReportCancel").click(function () {
        window.location.href = "/bems/assetqrcodeprint";
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
    $('#chk_AssetQRCodePrintdet').prop("disabled", false);
    $('#AssetQRCodePrintTbl tr:last td:first input').focus();
    formInputValidation("AssetQRCodePrintingForm");
    $('#btnAssetQRPrint').attr('disabled', false);

}

function BindNewRowHTML() {
    return '<tr> <td width="3%" title="Select"> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" name="AssetQRCodePrintCheckboxes" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(AssetQRCodePrintTbl,chk_AssetQRCodePrintdet)"> </label> </div></td><td width="20%" style="text-align: center;" title=""> <div> <input type="text" placeholder="Please Select" id="QRAssetNo_maxindexval" onkeyup="FetchAssetNoQRCode(event,maxindexval)" onpaste="FetchAssetNoQRCode(event,maxindexval)" change="FetchAssetNoQRCode(event,maxindexval)" oninput="FetchAssetNoQRCode(event,maxindexval)" class="form-control" required/> <div class="col-sm-12" id="divFetch_maxindexval"></div><input type="hidden" id="hdnAssetnoId_maxindexval" value=0> <input type="hidden" id="hdnAssetQRCodeId_maxindexval" value=0> </div></td><td width="10%" style="text-align: center;" title=""> <div> <input id="QRAssettypecode_maxindexval" type="text" class="form-control" disabled readonly/> </div></td><td width="10%" style="text-align: center;" title=""> <div> <input id="QRAssetdesc_maxindexval" type="text" class="form-control" disabled readonly/> </div></td><td width="10%" style="text-align: center;" title=""> <div> <input type="text" id="QRManufacturer_maxindexval" class="form-control" disabled readonly/> </div></td><td width="10%" style="text-align: center;" title=""> <div> <input id="QRModel_maxindexval" type="text" class="form-control" readonly disabled/> </div></td><td width="13%" style="text-align: center;" title=""> <div> <input id="QRUserarea_maxindexval" type="text" class="form-control" disabled readonly/> <input type="hidden" id="hdnUserAreaId_maxindexval" value=0> </div></td><td width="14%" style="text-align: center;" title=""> <div> <input id="QRUserLoc_maxindexval" type="text" class="form-control" disabled readonly/> <input type="hidden" id="hdnUserLocId_maxindexval" value=0> </div></td><td width="10%" style="text-align: center;" title=""> <div> <input id="QRContractType_maxindexval" type="text" class="form-control" readonly disabled/> </div></td></tr>';
}

//******************************************** AddNewRow Fetch ****************************************************


function AddNewRow() {
    $("div.errormsgcenter1").text("");
    $('#errorMsg1').css('visibility', 'hidden');
    var rowCount = $('#AssetQRCodePrintTbl tr:last').index();
    var AssetNo = $('#QRUserarea_' + rowCount).val();
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

    $('#divFetch_' + index).css({
        'top': $('#QRAssetNo_' + index).offset().top - $('#AssetQRCodePrintingdataTable').offset().top + $('#QRAssetNo_' + index).innerHeight(),
        'width': $('#QRAssetNo_' + index).outerWidth()
    });

    var AssetQRCodeFetchObj = {
        SearchColumn: 'QRAssetNo_' + index + '-AssetNo',//Id of Fetch field
        ResultColumns: ["AssetId" + "-Primary Key", 'AssetNo' + '-QRAssetNo_' + index],//Columns to be displayed
        FieldsToBeFilled: ['QRAssetNo_' + index + '-AssetNo', "QRUserarea_" + index + "-UserAreaName", 'QRUserLoc_' + index + '-UserLocationName', 'QRAssetdesc_' + index + '-AssetDescription', 'QRAssettypecode_' + index + '-AssetTypeCode', 'QRManufacturer_' + index + '-Manufacturer', 'QRModel_' + index + '-Model', 'hdnAssetnoId_' + index + '-AssetId', 'hdnUserAreaId_' + index + '-UserAreaId', 'hdnUserLocId_' + index + '-UserLocationId', 'hdnAssetQRCodeId_' + index + '-AssetQRCode', 'QRContractType_' + index + '-ContractType']//id of element - the model property
    };
    DisplayFetchResult('divFetch_' + index, AssetQRCodeFetchObj, "/api/Fetch/AssetQRCodePrintFetchModel", "UlFetch" + index, event, 1);
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
    return ' <tr id="Delrow_maxindexval"> <td class="col-sm-1"> <div class="form-group"> <div class="col-sm-12"> <select class="custom_search" id="GridList_maxindexval"> <option value="AssetNo" selected="selected">Asset No.</option> <option value="AssetTypeCode">Asset Type Code</option> <option value="AssetDescription">Asset Description</option> <option value="Manufacturer">Manufacturer</option> <option value="Model">Model</option> <option value="UserAreaName">Department Name</option> <option value="UserLocationName">Location Name</option> </select> </div></div></td><td class="col-sm-1"> <div class="form-group"> <div class="col-sm-12"> <select class="custom_search" id="FilterList_maxindexval"> <option value="cn" selected="selected">contains</option> <option value="eq">equal</option> <option value="ne">not equal</option> <option value="bw">begins with</option> <option value="ew">ends with</option> </select> </div></div></td><td class="col-sm-1"> <div class="form-group"> <div class="col-sm-12"> <input type="text" class="custom_search" id="UserValue_maxindexval" placeholder=""> </div></div></td><td class="col-sm-5"> <div class="form-group"> <div class="col-sm-12"> <a class="btn btn-primary btnDelete">-</a> </div></div></td></tr> ';
}

function PushEmptyMessage() {
    $("#AssetQRCodePrintTbl").empty();
    var emptyrow = '<tr id="emptymsg"><td width="100%"><h5 class="text-center">No records to display</h5></td></tr>'
    $("#AssetQRCodePrintTbl").append(emptyrow);
    $("#addrowplus").hide();
    $('#chk_AssetQRCodePrintdet').prop("disabled", "disabled");
    $('#btnAssetQRPrint').attr('disabled', true);
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

//***************************************** BindGetById Valid ****************************************************



function BindGetByIdVal(Assetobj) {
    var jqxhr = $.post("/api/AssetQRCode/GetModal", Assetobj, function (response) {
        var getresult = JSON.parse(response);
        var AssetQRcodeList = getresult.AssetQRCodeListData;
        if (AssetQRcodeList == null || AssetQRcodeList == 0) {
            PushEmptyMessage();            
        }
        else {
            $('#btnAssetQRPrint').attr('disabled', false);
            $('#chk_AssetQRCodePrintdet').prop("disabled", false);
            $("#emptymsg").hide();
            $("#addrowplus").show();
           //  $("#AssetQRCodePrintTbl").empty();
            var existingNoOfRows = $('#AssetQRCodePrintTbl tr').length;
            
            $.each(getresult.AssetQRCodeListData, function (index, value) {
                var newIndex = existingNoOfRows + index;
                AddNewRowAssetQRCodePrint();

                //$("#hdnAssetnoId_" + index).val(getresult.AssetQRCodeListData[index].AssetId);
                //$("#QRAssetNo_" + index).val(getresult.AssetQRCodeListData[index].AssetNo);
                //$("#hdnUserAreaId_" + index).val(getresult.AssetQRCodeListData[index].UserAreaId);
                //$("#hdnUserLocId_" + index).val(getresult.AssetQRCodeListData[index].UserLocationId);
                //$("#QRUserarea_" + index).val(getresult.AssetQRCodeListData[index].UserAreaName);
                //$('#QRUserLoc_' + index).val(getresult.AssetQRCodeListData[index].UserLocationName);
                //$('#QRAssetdesc_' + index).val(getresult.AssetQRCodeListData[index].AssetDescription);
                //$("#QRAssettypecode_" + index).val(getresult.AssetQRCodeListData[index].AssetTypeCode);
                //$("#QRManufacturer_" + index).val(getresult.AssetQRCodeListData[index].Manufacturer);
                //$("#QRModel_" + index).val(getresult.AssetQRCodeListData[index].Model);
                //$("#hdnAssetQRCodeId_" + index).val(getresult.AssetQRCodeListData[index].AssetQRCode);
                                        

                $("#hdnAssetnoId_" + newIndex).val(getresult.AssetQRCodeListData[index].AssetId);
                $("#QRAssetNo_" + newIndex).val(getresult.AssetQRCodeListData[index].AssetNo).prop("disabled", "disabled").attr('title', getresult.AssetQRCodeListData[index].AssetNo);
                $("#hdnUserAreaId_" + newIndex).val(getresult.AssetQRCodeListData[index].UserAreaId);
                $("#hdnUserLocId_" + newIndex).val(getresult.AssetQRCodeListData[index].UserLocationId);
                $("#QRUserarea_" + newIndex).val(getresult.AssetQRCodeListData[index].UserAreaName).attr('title', getresult.AssetQRCodeListData[index].UserAreaName);
                $('#QRUserLoc_' + newIndex).val(getresult.AssetQRCodeListData[index].UserLocationName).attr('title', getresult.AssetQRCodeListData[index].UserLocationName);
                $('#QRAssetdesc_' + newIndex).val(getresult.AssetQRCodeListData[index].AssetDescription).attr('title', getresult.AssetQRCodeListData[index].AssetDescription);
                $("#QRAssettypecode_" + newIndex).val(getresult.AssetQRCodeListData[index].AssetTypeCode).attr('title', getresult.AssetQRCodeListData[index].AssetTypeCode);
                $("#QRManufacturer_" + newIndex).val(getresult.AssetQRCodeListData[index].Manufacturer).attr('title', getresult.AssetQRCodeListData[index].Manufacturer);
                $("#QRModel_" + newIndex).val(getresult.AssetQRCodeListData[index].Model).attr('title', getresult.AssetQRCodeListData[index].Model);
                $("#hdnAssetQRCodeId_" + newIndex).val(getresult.AssetQRCodeListData[index].AssetQRCode);
                $("#QRContractType_" + newIndex).val(getresult.AssetQRCodeListData[index].ContractType).attr('title', getresult.AssetQRCodeListData[index].ContractType);
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
         $('#btnAssetQRPrint').attr('disabled', false);
     });
}


