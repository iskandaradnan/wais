//*Golbal variables decration section starts*//
var pageindex = 1, pagesize = 5;
var GridtotalRecords = 0;
var TotalPages = 0, FirstRecord = 0, LastRecord = 0;
var action = "";
var ListModelAccAttachment = [];
var HiddenId = $('#hdnAttachId').val();
//*Golbal variables decration section ends*//

$(document).ready(function () {
    
    $("#btnAccTabSave").click(function () {       
        //$('#btnAccTabSave').attr('disabled', true);
        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $('#errorMsgAccTab').css('visibility', 'hidden');
       
        var primaryId = $('#hdnARPrimaryID').val();

        if ($('#AccessoriesDescGrid_' + 0).val() == "" && ($('#hdnAccTabModelId_' + 0).val() == "0" || $('#hdnAccTabModelId_' + 0).val() == "") && ($('#hdnAccTabManufacturerId_' + 0).val() == "0" || $('#hdnAccTabManufacturerId_' + 0).val() == "") && $('#SerialNoGrid_' + 0).val() == "") {
            $("div.errormsgcenter").text("Atleast one record should be there to Save!");
            $('#errorMsgAccTab').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnAccTabSave').attr('disabled', false);
            return false;
        }

        var ARAccessoriesDetModel = [];
        $('#AccessoriestbodyId tr').map(function (i) {
            var contenttype = null;
            var documentextension = null;
            var contentAsbase64string = null;
            if (ListModelAccAttachment != null && ListModelAccAttachment[i] != null)
            {
                contenttype = ListModelAccAttachment[i].ContentType;
                documentextension = ListModelAccAttachment[i].DocumentExtension;
                contentAsbase64string = ListModelAccAttachment[i].ContentAsBase64String;
            }
            ARAccessoriesDetModel.push({
                AccessoriesId: $('#hdnAccessoriesIdGrid_' + i).val(),
                AssetId: primaryId,
                AccessoriesDescription: $('#AccessoriesDescGrid_' + i).val(),
                SerialNo: $('#SerialNoGrid_' + i).val(),
                IsDeleted: chkIsDeletedRowRequired(i, $('#Isdeleted_' + i).is(":checked")),
                ManufacturerName: $('#hdnAccTabManufacturerId_' + i).val(),
                ModelName: $('#hdnAccTabModelId_' + i).val(),
                DocumentTitle: $('#AccFileName_' + i).val(),
                DocumentGuId: HiddenId,
                ContentType: contenttype,
                DocumentExtension: documentextension,
                ContentAsBase64String: contentAsbase64string                
            });
        });
             

        var allChecked = $('#chk_AccTabGridIsDelete').prop('checked');
        var totalPages = $('#hdnAccessoriesPageCount').val();
        if (allChecked && totalPages < 2) {
            $('#myPleaseWait').modal('hide');
            bootbox.alert(Messages.CAN_NOT_DELETE_ALL_RECORDS);
            return false;
        }

        $('#btnAccTabSave').attr('disabled', true);
        var AssetRegisterAccessoriesMstModel = {
            AssetRegisterAccessoriesDetModel: ARAccessoriesDetModel
        }

   

        //for (var j = 0 ; j < ARAccessoriesDetModel.length; j++) {
        //    var ModelHiddenValue = $('#hdnAccTabModelId_' + j).val();
        //    var ModelValue = $('#txtAccTabModel_' + j).val();
        //    if (ModelValue != "" && ModelHiddenValue == "") {
        //            $("div.errormsgcenter").text("Valid Model Required!");
        //            $('#errorMsgAccTab').css('visibility', 'visible');
        //            //bootbox.alert("End Date should be greater than Start Date!");
        //            $('#myPleaseWait').modal('hide');
        //            $('#btnAccTabSave').attr('disabled', false);
        //            return false;          
        //    }
        //}

        //for (var j = 0 ; j < ARAccessoriesDetModel.length; j++) {
        //    var ManufacturerHiddenValue = $('#hdnAccTabManufacturerId_' + j).val();
        //    var ManufacturerValue = $('#txtAccTabManufacturer_' + j).val();
        //    if (ManufacturerValue != "" && ManufacturerHiddenValue == "") {
        //        $("div.errormsgcenter").text("Valid Manufacturer Required!");
        //        $('#errorMsgAccTab').css('visibility', 'visible');
        //        //bootbox.alert("End Date should be greater than Start Date!");
        //        $('#myPleaseWait').modal('hide');
        //        $('#btnAccTabSave').attr('disabled', false);
        //        return false;
        //    }
        //}

        if (ARAccessoriesDetModel.length > 1)
        {
            if (ARAccessoriesDetModel[0].AccessoriesDescription == ARAccessoriesDetModel[1].AccessoriesDescription) {
                $("div.errormsgcenter").text("Duplicate Records available!");
                $('#errorMsgAccTab').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                $('#btnAccTabSave').attr('disabled', false);
                return false;
            }
        }

        var isFormValid = formInputValidation("AssetAccessoriesTabForm", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsgAccTab').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnAccTabSave').attr('disabled', false);
            return false;
        }       
        if (IsEmptyRecordExists())
        {
            $("div.errormsgcenter").text("Cannot save empty record");
            $('#errorMsgAccTab').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnAccTabSave').attr('disabled', false);
            return false;
        }

        var countDet = Enumerable.From(ARAccessoriesDetModel).Where(x=>!x.IsDeleted).Count();
        if (countDet > 20) {
            $("div.errormsgcenter").text("Maximum 20 Records Can be Added.");
            $('#errorMsgAccTab').css('visibility', 'visible');
            $('#btnAccTabSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var deletedCount = Enumerable.From(ARAccessoriesDetModel).Where(x=>x.IsDeleted).Count();
        if (deletedCount > 0) {
            $('#myPleaseWait').modal('hide');
            var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
            bootbox.confirm(message, function (result) {
                if (result) {
                    SaveAccessoriesTab(AssetRegisterAccessoriesMstModel);
                } else {
                    $('#btnAccTabSave').attr('disabled', false);
                    $('#myPleaseWait').modal('hide');
                }
            });
        }
        else {
            SaveAccessoriesTab(AssetRegisterAccessoriesMstModel);
        }   
    });

    function IsEmptyRecordExists()
    {
         var emptyRowExists = false;
        $('#AccessoriesdataTable tr').each(function (j1, val) {
            if (j1 == 0) return;
            var j = j1 - 1;

            var isDeleted = $('#Isdeleted_' + j).is(":checked");
            var accessoriesDescription = $('#AccessoriesDescGrid_' + j).val();
            var modelName = $('#hdnAccTabModelId_' + j).val();
            var manufacturername = $('#hdnAccTabManufacturerId_' + j).val();
            var serialno = $('#SerialNoGrid_' + j).val();
            var filename = $('#AccFileName_' + j).val();
            if (!isDeleted && (accessoriesDescription == null || accessoriesDescription == '') && (modelName == null || modelName == '' || modelName ==undefined) && (manufacturername == null || manufacturername == '' || manufacturername == undefined) && (serialno == null || serialno == '') && (filename == null || filename == ''))
                emptyRowExists = true;
        });
        return emptyRowExists;
        
    }

    function SaveAccessoriesTab(AssetRegisterAccessoriesMstModel)
    {
        ApiUrl = "/api/assetregister/SaveAccessoriesGridData"
        $.ajax({
            type: "POST",
            url: ApiUrl,
            //contentType: false,
            //processData: false,
            data: AssetRegisterAccessoriesMstModel,
            success: function (response) {
                var getResult = JSON.parse(response);
                $('#AccessoriestbodyId').empty();
                if (getResult != null && getResult.AssetRegisterAccessoriesDetModel != null && getResult.AssetRegisterAccessoriesDetModel.length > 0) {
                    GetSaveAccTabResultBind(getResult);
                }
                else {
                    $('#AccessoriestbodyId').empty();
                    ListModelAccAttachment = [];
                    AccTabAddNewRow();
                }
                $('#chk_AccTabGridIsDelete').prop('checked', false);
                $(".content").scrollTop(0);
                showMessage('Accessories', CURD_MESSAGE_STATUS.SS);
                $("#top-notifications").modal('show');
                setTimeout(function () {
                    $("#top-notifications").modal('hide');
                }, 5000);

                $('#btnAccTabSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            },
            error: function (error) {
                var errorMessage = "";
                if (error.status == 400) {
                    errorMessage = error.responseJSON;
                }
                else {
                    errorMessage = Messages.COMMON_FAILURE_MESSAGE(error);
                }
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(errorMessage);
                $('#errorMsgAccTab').css('visibility', 'visible');
                $('#btnAccTabSave').attr('disabled', false);              
            }     
        });
    } 


    $("#chk_AccTabGridIsDelete").change(function () {
        var Isdeletebool = this.checked;
        $('#AccessoriestbodyId tr').map(function (i) {
            if (Isdeletebool)
                $("#Isdeleted_" + i).prop("checked", true);
            else
                $("#Isdeleted_" + i).prop("checked", false);
        });
    });

    $("#bttab2Cancel").click(function () {
        // window.location.href = "/bems/general";
        var message = Messages.Reset_TabAlert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                EmptyFieldsAccessories();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });
    $("#btnAddNew").click(function () {
        window.location.href = window.location.href;
    });

});

function loadAccessoriesTab() {
     if ($('#hdnARPrimaryID').val() == 0) {
            return false;
     }

    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsgAccTab').css('visibility', 'hidden');
    $('#txtAsAssetDescription').val($('#txtARTypeDescription').val());
    formInputValidation("AssetAccessoriesTabForm");
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission) {
        action = "Edit"
    }
    else if (!hasEditPermission ) {
        action = "View"
    }
    if (action == "View") {
        $("#btnAccTabSave").hide();
        $('#anchorAccessoriesPlus').attr('disabled', true).css('cursor', 'default');
        $('#anchorAccessoriesPlus').removeAttr('onclick');
    }
    var primaryId = $('#hdnARPrimaryID').val();//asset Id

    $.get("/api/assetregister/GetAccessoriesGridData/" + primaryId + "/" + pagesize + "/" + pageindex)
        .done(function (result) {
            var result = JSON.parse(result);
            
            GetSaveAccTabResultBind(result)

            if ( action == "View")
            {
                $("#AssetAccessoriesTabForm :input:not(:button)").prop("disabled", true);
            }

            $('#myPleaseWait').modal('hide');
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsgAccTab').css('visibility', 'visible');
        });
}

function errorMsg(errMsg) {
    $("div.errormsgcenter").text((!Messages[errMsg]) ? errMsg : Messages[errMsg]).css('visibility', 'visible');
    $('#btnAccTabSave').attr('disabled', false);
    $('#myPleaseWait').modal('hide');
   // InvalidFn();
    return false;
}

function GetSaveAccTabResultBind(result) {
    ListModelAccAttachment = [];
    ListModelAccAttachment = result.AssetRegisterAccessoriesDetModel;
    $("#AccessoriestbodyId").empty();
    $.each(result.AssetRegisterAccessoriesDetModel, function (index, value) {
        AccTabAddNewRow();
        $("#hdnAccessoriesIdGrid_" + index).val(value.AccessoriesId);
        $("#AccessoriesDescGrid_" + index).val(value.AccessoriesDescription);
        $("#SerialNoGrid_" + index).val(value.SerialNo);
       // $("#txtAccTabManufacturer_" + index).val(value.ManufacturerName).prop('disabled',true);
        $("#hdnAccTabManufacturerId_" + index).val(value.ManufacturerName);
        //$("#txtAccTabModel_" + index).val(value.ModelName);
        $("#hdnAccTabModelId_" + index).val(value.ModelName);

        if (value.DocumentTitle == "" || value.DocumentTitle == null) {
            $('#AccFileName_' + index).val(value.DocumentTitle).prop("disabled", true);
            $("#AccimageDownLoad_" + index).css('visibility', 'hidden');            
        }
        else {
            $('#AccFileName_' + index).val(value.DocumentTitle).prop("disabled", true);
            $('#AccDownloadFileName_' + index).text(value.DocumentTitle);
            $("#AccimageDownLoad_" + index).css('visibility', 'visible');
        }
    });

    var AssetId = 0;
    if ((result.AssetRegisterAccessoriesDetModel && result.AssetRegisterAccessoriesDetModel.length) > 0) {
        AssetId = result.AssetId;
        GridtotalRecords = result.AssetRegisterAccessoriesDetModel[0].TotalRecords;
        TotalPages = result.AssetRegisterAccessoriesDetModel[0].TotalPages;
        LastRecord = result.AssetRegisterAccessoriesDetModel[0].LastRecord;
        FirstRecord = result.AssetRegisterAccessoriesDetModel[0].FirstRecord;
        pageindex = result.AssetRegisterAccessoriesDetModel[0].PageIndex;
    } else {
        AccTabAddNewRow();
    }

    var mapIdproperty = ["Isdeleted-Isdeleted_", "AccessoriesId-hdnAccessoriesIdGrid_", "AccessoriesDescription-AccessoriesDescGrid_", "ModelName-hdnAccTabModelId_", "ManufacturerName-hdnAccTabManufacturerId_", "SerialNo-SerialNoGrid_", "DocumentTitle-AccFileName_", "DocumentTitle-AccDownloadFileName_"];
    var htmltext = AccTabInlineGridHtml();//Inline Html
    var obj = { formId: "#form", IsView: (  action  == "View"), PageNumber: pageindex, flag: "", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "AssetRegisterAccessoriesDetModel", tableid: '#AccessoriestbodyId', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/assetregister/GetAccessoriesGridData/" + AssetId, pageindex: pageindex, pagesize: pagesize };

    $('#hdnAccessoriesPageCount').val(obj.TotalPages);
    CreateFooterPagination(obj);
    formInputValidation("AssetAccessoriesTabForm");
}

$('#anchorAccessoriesPlus').unbind('click');
$('#anchorAccessoriesPlus').click(function () {
    var emptyRowExists = false;
    $('#AccessoriesdataTable tr').each(function (j1, val) {
        if (j1 == 0) return;
        var j = j1 - 1;

        var isDeleted = $('#Isdeleted_' + j).is(":checked");
        var accessoriesDescription = $('#AccessoriesDescGrid_' + j).val();
        var modelName = $('#hdnAccTabModelId_' + j).val();
        var manufacturername = $('#hdnAccTabManufacturerId_' + j).val();
        var serialno = $('#SerialNoGrid_' + j).val();
        var filename = $('#AccFileName_' + j).val();
        if (!isDeleted && (accessoriesDescription == null || accessoriesDescription == '') && (modelName == null || modelName == '' || modelName ==undefined) && (manufacturername == null || manufacturername == '' || manufacturername == undefined) && (serialno == null || serialno == '') && (filename == null || filename == ''))
            emptyRowExists = true;
    });
    if (emptyRowExists) {
        bootbox.alert("Please enter values in existing row");
        return false;
    }
    AccTabAddNewRow();
});

function AccTabAddNewRow() {
    var rowCount = $('#AccessoriestbodyId tr:last').index();
    var AccessoriesDescGrid = $('#AccessoriesDescGrid_' + rowCount).val();
    var SerialNoGrid = $('#SerialNoGrid_' + rowCount).val();
    var Manufacturer = $('#txtAccTabManufacturer_' + rowCount).val();
    var ManufacturerId = $('#hdnAccTabManufacturerId_' + rowCount).val();
    var Model = $('#txtAccTabModel_' + rowCount).val();
    var ModelId = $('#hdnAccTabModelId_' + rowCount).val();
    if (rowCount < 0)
    {
        var inputpar = {
            inlineHTML: AccTabInlineGridHtml(),//Inline Html
            TargetId: "#AccessoriestbodyId",
            TargetElement: ["tr"]
        }
        AddNewRowToDataGrid(inputpar);
        formInputValidation("AssetAccessoriesTabForm");
    }
    //else if (rowCount >= "0" && (AccessoriesDescGrid == "" || SerialNoGrid == "" || ManufacturerId == "0" || ManufacturerId == 0 || ModelId == "0" || ModelId == 0)) {
    //    bootbox.alert("Please fill the details for the last  record");
    //}
    else {
        var inputpar = {
            inlineHTML: AccTabInlineGridHtml(),//Inline Html
            TargetId: "#AccessoriestbodyId",
            TargetElement: ["tr"]
        }
        AddNewRowToDataGrid(inputpar);
        formInputValidation("AssetAccessoriesTabForm");
    }
    var rowCount = $('#AccessoriestbodyId tr:last').index();
    if (rowCount > 1) {
        $('#AccessoriesDescGrid_' + rowCount).focus();
    }
    $('#chk_AccTabGridIsDelete').prop('checked', false);
}

function AccTabInlineGridHtml() {

    return '<tr> <td width="3%" data-original-title="" title=""> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(AccessoriestbodyId,chk_AccTabGridIsDelete)" autocomplete="off" tabindex="0"> </label> </div></td><td width="15%" style="text-align: center;" title=""> <div> <input id="AccessoriesDescGrid_maxindexval" pattern="^[a-zA-Z0-9\\-\\(\\)\\,.\&#39;&quot;\\s]+$" type="text" class="form-control" name="Accessories Decription" maxlength="150"> </div><input id="hdnAccessoriesIdGrid_maxindexval" type="hidden" value="0" class="form-control"> </td><td width="15%" style="text-align: center;" title=""> <div> <input id="hdnAccTabModelId_maxindexval" maxindex="150" type="text" pattern="^[a-zA-Z0-9\\-\\(\\)\\,.\&#39;&quot;\\s]+$" class="form-control" name="Model"></div></td><td width="15%" style="text-align: center;" title=""> <div> <input id="hdnAccTabManufacturerId_maxindexval" maxindex="150"  type="text" class="form-control" pattern="^[a-zA-Z0-9\\-\\(\\)\\,.\&#39;&quot;\\s]+$" name="Manufacturer"></div></td><td width="15%" style="text-align: center;" title=""> <div> <input id="SerialNoGrid_maxindexval" pattern="^[a-zA-Z0-9\\-\\/]+$" type="text" maxlength="25" class="form-control" name="Serial Number"> </div></td><td width="10%" style="text-align: center;"> <div> <input id="AccFileName_maxindexval" type="text" class="form-control" maxlength="50" disabled> </div></td><td width="17%" style="text-align: center;" title=""> <div> <input type="hidden" id="hdnAccFileName_maxindexval" value=0> <input id="AccAttachment_maxindexval" onchange="getAccessoriesFileUploadDetails(this, maxindexval)" type="file" class="form-control" accept="application/pdf"> </div></td><td width="10%" style="text-align: center;"> <div class="text-center"> <input type="hidden" id="hdnAccDownload_maxindexval" value=0> <a class="glyphicon glyphicon-download-alt" id="AccimageDownLoad_maxindexval" onclick="Accessoriesdownloadfiles(maxindexval)" style="visibility: hidden;"></a> &nbsp; <a href="#" id="AccimageDownLoad_maxindexval" onclick="Accessoriesdownloadfiles(maxindexval)"><span id="AccDownloadFileName_maxindexval"></span></a> </div></td></tr>';
}

//--------------- Fetch for Accessories Tab Manufacturer -----------------
//function AccTabManufacturerData(event, index) {
//    var ModelValue = $('#txtAccTabModel_' + index).val();
//    if (ModelValue == "" || ModelValue == null)
//    {
//        $("div.errormsgcenter").text("Please Choose Model!");
//        $('#errorMsgAccTab').css('visibility', 'visible');
//        return false;
//    }
//    else {
//        $("div.errormsgcenter").text("");
//        $('#errorMsgAccTab').css('visibility', 'hidden');
//    }
//    var manufacturerFetchObj = {
//        SearchColumn: 'txtAccTabManufacturer_' + index + '-Manufacturer',//Id of Fetch field
//        ResultColumns: ["ManufacturerId-Primary Key", 'Manufacturer-txtAccTabManufacturer_' + index],
//        FieldsToBeFilled: ["hdnAccTabManufacturerId_" + index + "-ManufacturerId", "txtAccTabManufacturer_" + index + "-Manufacturer"]
//    };
    
//    DisplayFetchResult('divAccTabManufacturerFetch_' + index, manufacturerFetchObj, "/api/Fetch/ManufacturerFetch", "UlFetchAccTabManufacturer_" + index, event, 1);//1 -- pageIndex
//}

////--------------- Fetch for Accessories Tab Model -----------------
//function AccTabModelData(event, index) {
//    var modelFetchObj = {
//        SearchColumn: 'txtAccTabModel_' + index + '-Model',//Id of Fetch field
//        ResultColumns: ["ModelId-Primary Key", 'Model-txtAccTabModel_' + index],
//        FieldsToBeFilled: ["hdnAccTabModelId_" + index + "-ModelId", "txtAccTabModel_" + index + "-Model", "hdnAccTabManufacturerId_" + index + "-ManufacturerId", "txtAccTabManufacturer_" + index + "-Manufacturer"]
//    };
//    DisplayFetchResult('divAccTabModelFetch_' + index, modelFetchObj, "/api/Fetch/ModelFetch", "UlFetchAccTabModel_" + index, event, 1);//1 -- pageIndex
//}

function EmptyFieldsAccessories() {
    $(".content").scrollTop(0);
    $('.nav-tabs a:first').tab('show')
    $('input[type="text"], textarea').val('');
    $('#selARAssetClassification').val("null");
    $('#selARServiceId,.selARServiceId').val(2);
    $('#selARAssetStatus').val(1);
    $('#selARRiskRating').val(113);
    $('#selARPurchaseCategory').val("null");
    $('#selARAppliedPartType').val("null");
    $('#selAREquipmentClass').val("null");
    $('#selARPPM').val("null");
    $('#selAROther').val("null");
    $('#selARRI').val("null");
    $('#selARAssetTransferMode').val("null");
    $('#txtARAssetNo').attr('disabled', false);
    $('#txtARTypeCode').attr('disabled', false);
    $('#txtARAssetPreRegistrationNo').attr('disabled', false);
    $('#spnPopup-assetPreRegistration').unbind("click").attr('disabled', false).css('cursor', 'default');
    $('#spnPopup-typeCode').unbind("click").attr('disabled', false).css('cursor', 'default');
    $('#btnAREdit').hide();
    $('#btnARSave').show();
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#hdnARPrimaryID").val('');
    $("#grid").trigger('reloadGrid');
    $("#assetRegister :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
  
}

function chkIsDeletedRowRequired(i, delrec) {
    if (delrec == true) {
        $('#AccFileName_' + i).prop("required", false);
        return true;
    }
    else {
        return false;
    }
}


//*********************************** File Attachment ******************************************


function getAccessoriesFileUploadDetails(e, index) {
    var _index;
    $('#AccessoriestbodyId tr').each(function () {
        _index = $(this).index();
    });
    var FileCatName = $('#AccFileName_' + index).val();
    var AccessoriesId = $('#hdnAccessoriesIdGrid_' + index).val();

    var HiddenId = $('#hdnAttachId').val();

    for (var i = 0; i < e.files.length; i++) {
        var f = e.files[i];
        var file = f;
        var blob = e.files[i].slice();
        var filetype = file.type;
        var filesize = file.size;
        var filename = file.name;
        var extension = filename.replace(/^.*\./, '');
        var totalSize = 0;
        var reader = new FileReader();

        if (filetype == "") {
            filetype = extension;
        }

        var FileappType = ['application/pdf'];
        var FileMaxSize = 8388608; //  - 8Mb;

        if (filetype == "application/pdf") {
            if (FileMaxSize >= filesize) {

                function getB64Str(buffer) {
                    var binary = '';
                    var bytes = new Uint8Array(buffer);
                    var len = bytes.byteLength;
                    for (var i = 0; i < len; i++) {
                        binary += String.fromCharCode(bytes[i]);
                    }
                    return window.btoa(binary);
                }
                reader.onloadend = function (evt) {

                    if (evt.target.readyState == FileReader.DONE) {
                        var cont = evt.target.result;
                        var base64String = getB64Str(cont);

                        if (AccessoriesId == 0 || AccessoriesId == null) {

                            var validcount = Enumerable.From(ListModelAccAttachment).Where(x=>x.index == index).Count();
                            if (validcount > 0) {
                                ListModelAccAttachment[index].DocumentTitle = FileCatName;
                                ListModelAccAttachment[index].DocumentExtension = filetype;
                                ListModelAccAttachment[index].ContentType = extension;
                                ListModelAccAttachment[index].ContentAsBase64String = base64String;
                            }
                            else {
                                var ListModelAccAttachmentData = [{
                                    AccessoriesId: 0,
                                    GuId: '',                                  
                                    DocumentTitle: FileCatName,                                  
                                    DocumentExtension: filetype,                                                                     
                                    FilePath: null,
                                    FileName: null,                                   
                                    DocumentGuId: HiddenId,
                                    ContentType: extension,
                                    ContentAsBase64String: base64String,
                                    index: index
                                }];
                                if (ListModelAccAttachment != null && ListModelAccAttachment.length > 0) {

                                    ListModelAccAttachment.push.apply(ListModelAccAttachment, ListModelAccAttachmentData);
                                }
                                else {
                                    ListModelAccAttachment = ListModelAccAttachmentData;
                                }                                
                            }
                        }
                        else {
                            if (ListModelAccAttachment[index].AccessoriesId == AccessoriesId) {
                                ListModelAccAttachment[index].DocumentTitle = FileCatName;
                                ListModelAccAttachment[index].DocumentExtension = filetype;
                                ListModelAccAttachment[index].ContentType = extension;
                                ListModelAccAttachment[index].ContentAsBase64String = base64String;
                            }
                        }

                    }
                };
                reader.readAsArrayBuffer(blob);
                $('#AccFileName_' + index).prop("disabled", false);
                $('#AccFileName_' + index).prop("required", true);
            }
            else {
                bootbox.alert("File size must be less than 8 MB.");
                $("#AccAttachment_" + _index).val("");
                $('#AccFileName_' + index).prop("disabled", true);
                $('#AccFileName_' + index).prop("required", false);
            }
        }
        else {
            bootbox.alert("Please upload Pdf File.");
            $("#AccAttachment_" + _index).val("");
            $('#AccFileName_' + index).prop("disabled", true);
            $('#AccFileName_' + index).prop("required", false);
        }

    }
}


//*************************************** File Download ***********************************************

function Accessoriesdownloadfiles(index) {
    var DocumentId = $('#hdnAccessoriesIdGrid_' + index).val();
    if (ListModelAccAttachment[index].AccessoriesId == DocumentId) {
        var FileCatName = ListModelAccAttachment[index].DocumentTitle;
        var DocumentExtension = ListModelAccAttachment[index].DocumentExtension;
        var FilePath = ListModelAccAttachment[index].FilePath;
        var date = new Date();
        var Currentdate = DateFormatter(date);
        var $downloadForm = $("<form method='POST'>")
        .attr("action", "/bems/AttachmentPartialView/CommonDownLoad")
        .append($("<input name='FileName' type='text'>").val(FileCatName))
        .append($("<input name='ContentType' type='text'>").val(DocumentExtension))
        .append($("<input name='FilePath' type='text'>").val(FilePath))

        $("body").append($downloadForm);
        var status = $downloadForm.submit();
        $downloadForm.remove();

    }
}