var pageindex = 1, pagesize = 5;
var GridtotalRecords = 0;
var TotalPages = 1, FirstRecord = 0, LastRecord = 0;
var ActionType = $('#ActionType').val();

$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    formInputValidation("EODTypeCodeMappingScreen");
    $.get("/api/eodtypecodemapping/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
             $("#jQGridCollapse1").click();
            AddNewRowEODTypeCode();

            $.each(loadResult.ServiceLovs, function (index, value) {
                if (value.LovId == 2)
                    $('#EODTypeCodeService').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $("#EODTypeCodeSystemCategory").val('').empty().append('<option value="">Select</option>')
            $.each(loadResult.CategorySystem, function (index, value) {
                $('#EODTypeCodeSystemCategory').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            
            var primaryId = $('#primaryID').val();
            if (primaryId != null && primaryId != "0") {
                $.get("/api/eodtypecodemapping/Get/" + primaryId + "/" + pagesize + "/" + pageindex)
                  .done(function (result) {
                      var getResult = JSON.parse(result);

                      GetTypeCodeMappingBind(getResult)

                      $('#myPleaseWait').modal('hide');
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
        })
  .fail(function () {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
      $('#errorMsg').css('visibility', 'visible');
  });

    //****************************************** Save *********************************************

    $("#btnSave, #btnEdit").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var _index;
        $('#EODTypeCodeMappingBody tr').each(function () {
            _index = $(this).index();
        });

        actionType = $('#ActionType').val();
        var EntryModeChkMode
        if (actionType == "ADD") {
            var EntryModeChkMode = 1;            
        }
        else {
            EntryModeChkMode = 0;
        }

        var CategorySystemDetId = $('#primaryID').val();
        var ServiceId = $('#EODTypeCodeService').val();
        var CatSystemId = $('#EODTypeCodeSystemCategory').val();
        var CategorySystem = $('#EODTypeCodeSystemCategory option:selected').text();
        var timeStamp = $("#Timestamp").val();

        var result = [];
        for (var i = 0; i <= _index; i++) {
            var _EODTypecodeGrid = {
                CategorySystemDetId: $('#hdnEodDetGrid_' + i).val(),
                CategorySystemId: CatSystemId,
                AssetTypeCodeId: $('#hdnEodSystemTypeCodeId_' + i).val(),
                ServiceId: ServiceId,
                //IsDeleted: $('#Isdeleted_' + i).is(":checked"),
                IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
            }
            result.push(_EODTypecodeGrid);
        }

        function chkIsDeletedRow(i, delrec) {
            if (delrec == true) {
                $('#SystemTypeCode_' + i).prop("required", false);
                return true;
            }
            else {
                return false;
            }
        }

        var deletedCount = Enumerable.From(result).Where(x=>x.IsDeleted).Count();
        var Isdeleteavailable = deletedCount > 0;
        if (deletedCount == result.length && TotalPages == 1) {         
            bootbox.alert("Sorry!. You cannot delete all rows");
            $('#myPleaseWait').modal('hide');
            return false;
        }

        $('#EODTypeCodeMappingBody tr').each(function () {
            _indexLar = $(this).index();
        });
        for (var i = 0; i <= _indexLar; i++) {
            var LarConId = $('#hdnEodSystemTypeCodeId_' + i).val();
            if (result[i].IsDeleted == false) {
                if (LarConId == '') {
                    DisplayErrorMessage("Valid System/Asset Type Code is required.");
                    return false;
                }
            }
        }

        function DisplayErrorMessage(errorMessage) {
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var obj = {
            EODTypeCodeMappingGridData: result,
            CategorySystemId: CatSystemId,
            CategorySystemName:CategorySystem,
            ServiceId: ServiceId,
            EntryModeChk:EntryModeChkMode,
            Timestamp: timeStamp
        }

        //var primaryId = $("#primaryID").val();
        //if (primaryId != null) {
        //    EODCategorySystemMst.CategorySystemId = primaryId;
        //    EODCategorySystemMst.Timestamp = timeStamp;
        //}
        //else {
        //    EODCategorySystemMst.CategorySystemId = 0;
        //    EODCategorySystemMst.Timestamp = "";
        //}



        var isFormValid = formInputValidation("EODTypeCodeMappingScreen", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        if (Isdeleteavailable == true) {
            bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (result) {
                if (result) {
                    SaveEodtypecodemapping(obj);
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }

            });
        }
        else {
            SaveEodtypecodemapping(obj);
        }

        function SaveEodtypecodemapping(obj) {
            var jqxhr = $.post("/api/eodtypecodemapping/Save", obj, function (response) {
                var result = JSON.parse(response);
                $("#primaryID").val(result.CategorySystemId);
                $("#Timestamp").val(result.Timestamp);

                GetTypeCodeMappingBind(result);

                $(".content").scrollTop(0);
                showMessage('Category / System Master', CURD_MESSAGE_STATUS.SS);
                $("#top-notifications").modal('show');
                setTimeout(function () {
                    $("#top-notifications").modal('hide');
                }, 5000);

                $('#btnSave').attr('disabled', false);
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

            }

    });

    $("#chk_typeCodeDetails").change(function () {
        var Isdeletebool = this.checked; 
       
        if (this.checked) {
            $('#EODTypeCodeMappingBody tr').map(function (i) {
                if ($("#Isdeleted_" + i).prop("disabled")) {
                    $("#Isdeleted_" + i).prop("checked", false);
                }
                else {
                    $("#Isdeleted_" + i).prop("checked", true);
                }
            });
        } else {
            $('#EODTypeCodeMappingBody tr').map(function (i) {               
                    $("#Isdeleted_" + i).prop("checked", false);
            });
        }
    });

    $('#btnAddNew').click(function () {
        window.location.reload();
    });

    $("#btnCancel").click(function () {
        window.location.href = "/BEMS/eodtypecodemapping";
    });
});

/* Function to check and uncheck checkbox based on disabled checkbox condition */
//function IsDeleteCheckAllTyp(tbodyId, IsDeleteHeaderId) {
//    var count = 0;
//    var Isdeleted_ = [];
//    tbodyId = '#' + tbodyId.id + ' tr';
//    IsDeleteHeaderId = "#" + IsDeleteHeaderId.id;

//    $(tbodyId).map(function (index, value) {       
//        if ($("#Isdeleted_" + index).prop("disabled")) {
//            count++;
//        }
//            var Isdelete = $("#Isdeleted_" + index).is(":checked");
//            if (Isdelete)
//                Isdeleted_.push(Isdelete);
//    });

//    var rowlen = ($(tbodyId).length) - (count)

//    if (rowlen == Isdeleted_.length)
//        $(IsDeleteHeaderId).prop("checked", true);
//    else
//        $(IsDeleteHeaderId).prop("checked", false);
//}

function GetTypeCodeMappingBind(getResult) {
    var primaryId = $('#primaryID').val();

    $('#EODTypeCodeService option[value="' + getResult.EODTypeCodeMappingGridData[0].ServiceId + '"]').prop('selected', true);
    $("#EODTypeCodeSystemCategory").prop("disabled", "disabled");
    $('#EODTypeCodeSystemCategory option[value="' + getResult.EODTypeCodeMappingGridData[0].CategorySystemId + '"]').prop('selected', true);
    $("#EODTypeCodeMappingBody").empty();

    $.each(getResult.EODTypeCodeMappingGridData, function (index, value) {
        AddNewRowEODTypeCode();

        if (getResult.EODTypeCodeMappingGridData[index].Isreferenced == true) {
            $("#Isdeleted_" + index).prop("disabled", "disabled")
            $("#SystemTypeCode_" + index).val(getResult.EODTypeCodeMappingGridData[index].AssetTypeCode).prop("disabled", "disabled");
        }
        else {
            $("#Isdeleted_" + index).prop("disabled", false)
            $("#SystemTypeCode_" + index).val(getResult.EODTypeCodeMappingGridData[index].AssetTypeCode).prop("disabled", false);
        }
        
        $("#hdnEodDetGrid_" + index).val(getResult.EODTypeCodeMappingGridData[index].CategorySystemDetId);
        $("#hdnEodSystemTypeCodeId_" + index).val(getResult.EODTypeCodeMappingGridData[index].AssetTypeCodeId);
        //$("#SystemTypeCode_" + index).val(getResult.EODTypeCodeMappingGridData[index].AssetTypeCode);
        $("#SystemTypeDescription_" + index).val(getResult.EODTypeCodeMappingGridData[index].AssetTypeDescription);
    });

    if (ActionType == "VIEW") {
        $("#EODTypeCodeMappingScreen :input:not(:button)").prop("disabled", true);
        //$("#addnewrowbtn,#savebtn,#uploadbtn,#exportbtn,#addnewbtn").hide();
    }

    var CatSystemId = 0;
    if ((getResult.EODTypeCodeMappingGridData && getResult.EODTypeCodeMappingGridData.length) > 0) {
        CategorySystemId = getResult.EODTypeCodeMappingGridData[0].CategorySystemId;
        GridtotalRecords = getResult.EODTypeCodeMappingGridData[0].TotalRecords;
        TotalPages = getResult.EODTypeCodeMappingGridData[0].TotalPages;
        LastRecord = getResult.EODTypeCodeMappingGridData[0].LastRecord;
        FirstRecord = getResult.EODTypeCodeMappingGridData[0].FirstRecord;
        pageindex = getResult.EODTypeCodeMappingGridData[0].PageIndex;
    }

    var mapIdproperty = ["IsDeleted-Isdeleted_", "CategorySystemDetId-hdnEodDetGrid_", "AssetTypeCodeId-hdnEodSystemTypeCodeId_", "AssetTypeCode-SystemTypeCode_", "AssetTypeDescription-SystemTypeDescription_"];
    var htmltext = AddNewRowEODTypeCodeHtml();//Inline Html
    var obj = { formId: "#EODTypeCodeMappingScreen", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "EODTypeCodeMappingGridData", tableid: '#EODTypeCodeMappingBody', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/eodtypecodemapping/Get/" + primaryId, pageindex: pageindex, pagesize: pagesize };

    CreateFooterPagination(obj)
}

function AddNewRow() {
    $("div.errormsgcenter1").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var rowCount = $('#EODTypeCodeMappingBody tr:last').index();
    var TypecodeCount = $('#SystemTypeCode_' + rowCount).val();
    if (rowCount < 0)
        AddNewRowEODTypeCode();
    else if (rowCount >= "0" && TypecodeCount == "") {
        bootbox.alert("Please enter values in existing row");
        //  $("div.errormsgcenter1").text();
        // $('#errorMsg1').css('visibility', 'visible');
    }
    else {
        AddNewRowEODTypeCode();
    }
}

function AddNewRowEODTypeCode() {
    var inputpar = {        
        inlineHTML : AddNewRowEODTypeCodeHtml(),
        IdPlaceholderused: "maxindexval",
        TargetId: "#EODTypeCodeMappingBody",
        TargetElement: ["tr"]
    }

    AddNewRowToDataGrid(inputpar);

    var rowCount = $('#EODTypeCodeMappingBody tr:last').index();
    $('#SystemTypeCode_' + rowCount).focus();
    formInputValidation("EODTypeCodeMappingScreen");
}

function AddNewRowEODTypeCodeHtml() {

    return ' <tr class="ng-scope" style=""><td width="6%" id="typeCodeDetailsDel"><div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" name="CategorySystemTypeCodeMappingCheckboxes" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(EODTypeCodeMappingBody,chk_typeCodeDetails)" value="false" > </label></div></td> \
                          <input type="hidden" width="0%" id="hdnEodDetGrid_maxindexval">  \
                        <td width="47%" style="text-align: center;"><div> <input type="text" id="SystemTypeCode_maxindexval" name="SystemTypeCode" style="max-width:100%" class="form-control" autocomplete="off" placeholder="Please Select" onkeyup="FetchTypeCode(event,maxindexval)" onpaste="FetchTypeCode(event,maxindexval)" onchange="FetchTypeCode(event,maxindexval)" oninput="FetchTypeCode(SystemTypeCode_maxindexval,maxindexval)" required></div> \
                                <input type="hidden" id="hdnEodSystemTypeCodeId_maxindexval"> <div class="col-sm-12" id="TypeCodeFetch_maxindexval"></div></td> \
                        <td width="47%" style="text-align: center;"><div> <input id="SystemTypeDescription_maxindexval" type="text" style="max-width:100%" class="form-control" name="SystemTypeDescription" autocomplete="off" disabled></div></td></tr>'
}


function FetchTypeCode(event, index) {
    $('#TypeCodeFetch_' + index).css({
        'top': $('#SystemTypeCode_' + index).offset().top - $('#CategorySystemTypeCodeMapping').offset().top + $('#SystemTypeCode_' + index).innerHeight(),
        'width': $('#SystemTypeCode_' + index).outerWidth()
    });
    var ItemMst = {
        SearchColumn: 'SystemTypeCode_' + index + '-AssetTypeCode',//Id of Fetch field
        ResultColumns: ["AssetTypeCodeId" + "-Primary Key", 'AssetTypeCode' + '-SystemTypeCode_' + index],//Columns to be displayed
        FieldsToBeFilled: ["hdnEodSystemTypeCodeId_" + index + "-AssetTypeCodeId", 'SystemTypeCode_' + index + '-AssetTypeCode', 'SystemTypeDescription_' + index + '-AssetTypeDescription']//id of element - the model property
    };
    DisplayFetchResult('TypeCodeFetch_' + index, ItemMst, "/api/Fetch/TypeCodeFetch", "Ulfetch" + index, event, 1);
}