var ListModel = [];
var pageindex = 1; var pagesize = 5;
var TotalPages, FirstRecord, LastRecord = 0;
window.HistoryGlobalList = [];
var GridtotalRecords = [];
$(function () {
    $('#myPleaseWait').modal('show');
    formInputValidation("ppmregisterform");
    $.get("/api/PPMRegister/Load")
         .done(function (result) {
             var loadResult = JSON.parse(result);
             $("#jQGridCollapse1").click();
             $.each(loadResult.FrequencyList, function (index, value) {
                 $('#PPMFrequency').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
             });
             var primaryId = $('#primaryID').val();
             AddNewRow();
             $('#isRowAdded').val(1);
             $('#AttachmentNo_0').css('display', 'none');
             if (primaryId != null && primaryId != "0") {
                 $.get("/api/PPMRegister/Get/" + primaryId + "/" + pagesize + "/" + pageindex)
                   .done(function (result) {
                       var htmlval = "";
                       $('#HistoryGrid').empty();
                       var getResult = JSON.parse(result);
                       bindHeaderDate(getResult);
                       if (getResult.EngPPMRegisterHistoryMsts != null && getResult.EngPPMRegisterHistoryMsts.length > 0) {
                           window.HistoryGlobalList = getResult.EngPPMRegisterHistoryMsts;
                           $('#HistoryGrid').empty();
                           bindHistory(getResult);
                       }
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

    function bindHistory(getResult) {
        $('#HistoryGrid').empty();
        var html1 = '';
        $.each(getResult.EngPPMRegisterHistoryMsts, function (index, data) {
            AddNewRow();
            $('#histVersion_' + index).val(data.Version);
            $('#histEffectiveDate_' + index).val(DateFormatter(data.EffectiveDate));
            $('#DocumentId_' + index).val(data.DocumentId);
            $('#DocumentTitle_' + index).val(data.DocumentTitle);
            $('#histUploadDate_' + index).val(DateFormatter(data.UploadDate));
        });

        $('#HistoryGrid').append(html1);
        var PPMId = $('#primaryID').val();
        //html = '';

        GridtotalRecords = getResult.EngPPMRegisterHistoryMsts[0].TotalRecords;
        TotalPages = getResult.EngPPMRegisterHistoryMsts[0].TotalPages;
        LastRecord = getResult.EngPPMRegisterHistoryMsts[0].LastRecord;
        FirstRecord = getResult.EngPPMRegisterHistoryMsts[0].FirstRecord;
        pageindex = getResult.EngPPMRegisterHistoryMsts[0].PageIndex;

        var mapIdproperty = ["Version-histVersion_", "EffectiveDate-histEffectiveDate_-date", "UploadDate-histUploadDate_-date", "DocumentId-DocumentId_", "DocumentTitle-DocumentTitle_"];
        var htmltext = ' <tr> ' +
            '<td width="25%"> <div> ' +
            '<input type="text" id="histVersion_maxindexval"  name="Version" class="form-control" readonly/> </div>' +
            '</td>' +
            '<td width="25%"> <div> ' +
            '<input id="histEffectiveDate_maxindexval"  type="text" class="form-control" readonly/> </div>' +
            '</td>' +
            '<td width="30%" style="text-align: center;"> <div> <input type="hidden" id="DocumentId_maxindexval"/> ' +
            '<a class="glyphicon glyphicon-download-alt"   id="AttachmentNo_maxindexval" onclick="downloadfiles(maxindexval)"> </a> &nbsp; ' +
            '<input type="text" id="DocumentTitle_maxindexval"  readonly/>  </div>' +
            '</td>' +
            '<td width="20%" style="text-align: center;"> <div> ' +
            '<input id="histUploadDate_maxindexval"  type="text" class="form-control" readonly> </div>' +
            '</td> </tr>';
        var obj = { formId: "#ppmregisterform", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "EngPPMRegisterHistoryMsts", tableid: '#HistoryGrid', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/PPMRegister/Get/" + PPMId, pageindex: pageindex, pagesize: pagesize };

        CreateFooterPagination(obj);
    }
    function DisplayError() {

        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnSave').attr('disabled', false);
    }

    function bindHeaderDate(getResult) {
        $('#Version').val("");
        $('#EffectiveDate').val("");
        $('#UploadDate').val("");
        $('#ppmRegisterUploadAttachment').val("");
        $('#txtAssetTypeCode,#PPMFrequency').prop('disabled', true);
        $('#ServiceId').val(getResult.ServiceId);
        $('#hdnAssetTypeCodeId').val(getResult.AssetTypeCodeId);
        $('#txtAssetTypeCode').val(getResult.AssetTypeCode);
        $('#txtAssetTypeDesc').val(getResult.AssetTypeDescription);
        $('#hdnStandardTaskDetId').val(getResult.StandardTaskDetId);
        $('#BemsTaskCode').val(getResult.BemsTaskCode);
        $('#PPMChecklistNo').val(getResult.PPMChecklistNo);
        $('#hdnARManufacturerId').val(getResult.ManufacturerId);
        $('#txtARManufacturer').val(getResult.Manufacturer);
        $('#txtARModel').val(getResult.Model);
        $('#hdnARModelId').val(getResult.ModelId);
        $('#PPMFrequency').val(getResult.PPMFrequency);
        $('#PPMHours').val(getResult.PPMHours);
        $('#Timestamp').val(getResult.Timestamp);
        $('#primaryID').val(getResult.PPMId);
        $('#latestVersion').val(getResult.latestVersion);
        $('#latestEffectiveDate').val(getResult.latestEffectiveDate);
    }

    $("#btnSave,#btnEdit").click(function () {
        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var primaryId = $("#primaryID").val();
        var ServiceId = 2;
        var AssetTypeCodeId = $('#hdnAssetTypeCodeId').val();
        var AssetTypeCode = $('#txtAssetTypeCode').val();
        var StandardTaskDetId = $('#hdnStandardTaskDetId').val();
        var PPMChecklistNo = $('#txtPPMChecklistNo').val();
        var ManufacturerId = $('#hdnARManufacturerId').val();
        var Manufacturer = $('#txtARManufacturer').val();
        var ModelId = $('#hdnARModelId').val();
        var Model = $('#txtARModel').val();
        var PPMFrequency = $('#PPMFrequency').val();
        var PPMHours = $('#PPMHours').val();
        var BemsTaskCode = $('#BemsTaskCode').val();
        var Timestamp = $('#Timestamp').val();
        var version = $('#Version').val();
        var effectiveDate = $('#EffectiveDate').val();
        var attachedFileName = $("#ppmRegisterUploadAttachment").val();
        var latestVersion = $('#latestVersion').val();
        var latestEffectiveDate = $('#latestEffectiveDate').val();
        var currentDate = new Date();
        var UploadDate = currentDate;
        $('#UploadDate').val(DateFormatter(currentDate));
        var obj = {
            PPMId: primaryId,
            AssetTypeCodeId: AssetTypeCodeId,
            AssetTypeCode: AssetTypeCode,
            StandardTaskDetId: StandardTaskDetId,
            ServiceId: ServiceId,
            PPMChecklistNo: PPMChecklistNo,
            Manufacturer: Manufacturer,
            ManufacturerId: ManufacturerId,
            ModelId: ModelId,
            Model: Model,
            PPMFrequency: PPMFrequency,
            PPMHours: PPMHours,
            BemsTaskCode: BemsTaskCode,
            GuId: $('#GuId').val(),
            Timestamp: (primaryId != 0 || primaryId != null) ? Timestamp : 0,
            FileUploadList: ListModel,
            Version: version,
            EffectiveDate: effectiveDate,
            UploadDate: $('#UploadDate').val(),
        };

        var isFormValid = formInputValidation("ppmregisterform", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            DisplayError();
            return false;
        }
        else if (version == undefined || version == "" || effectiveDate == undefined || effectiveDate == "" || attachedFileName == "") {
            $("div.errormsgcenter").text(Messages.INVALID_EXISTINGROW_MESSAGE);
            DisplayError();
            return false;
        }
        else if (Version == '.' || version == 0) {
            $("div.errormsgcenter").text(Messages.GM_HEPPM_ValidationNotZero);
            DisplayError();
            return false;
        }
        else if (attachedFileName == "" || attachedFileName == null || attachedFileName == undefined) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            DisplayError();
            return false;
        }

        else if (latestVersion != "" && latestVersion != undefined && parseFloat(latestVersion) >= parseFloat(version)) {
            $("div.errormsgcenter").text(Messages.GM_HEPPM_VersionAndEffectiveDateValidation);
            DisplayError();
            return false;

        }
        else if (latestEffectiveDate != "" && latestEffectiveDate != undefined && new Date(latestEffectiveDate) >= new Date(effectiveDate)) {
            $("div.errormsgcenter").text(Messages.GM_HEPPM_VersionAndEffectiveDateValidation);
            DisplayError();
            return false;
        }
        var jqxhr = $.post("/api/PPMRegister/Add", obj, function (response) {
            var result = JSON.parse(response);
            var htmlval = "";
            $('#HistoryGrid').empty();
            bindHeaderDate(result);
            if (result.EngPPMRegisterHistoryMsts != null && result.EngPPMRegisterHistoryMsts.length > 0) {
                window.HistoryGlobalList = result.EngPPMRegisterHistoryMsts;
                $('#HistoryGrid').empty();
                bindHistory(result);
            }
            $(".content").scrollTop(0);
            showMessage('PPM Register', CURD_MESSAGE_STATUS.SS);
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
    });


    //fetch - type code 
    var typeCodeFetchObj = {
        SearchColumn: 'txtAssetTypeCode-AssetTypeCode',//Id of Fetch field
        ResultColumns: ["AssetTypeCodeId-Primary Key", 'AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description'],//Columns to be displayed
        FieldsToBeFilled: ["hdnAssetTypeCodeId-AssetTypeCodeId", "txtAssetTypeCode-AssetTypeCode", "txtAssetTypeDesc-AssetTypeDescription"]//id of element - the model property
    };
    $('#txtAssetTypeCode').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch', typeCodeFetchObj, "/api/Fetch/TypeCodeFetch", "UlFetch", event, 1);//1 -- pageIndex
    });

    //fetch - Manufacturer 

    var manufacturerFetchObj = {
        SearchColumn: 'txtARManufacturer-Manufacturer',//Id of Fetch field
        ResultColumns: ["ManufacturerId-Primary Key", 'Manufacturer-Manufacturer'],
        FieldsToBeFilled: ["hdnARManufacturerId-ManufacturerId", "txtARManufacturer-Manufacturer"]
    };

    $('#txtARManufacturer').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divARManufacturerFetch', manufacturerFetchObj, "/api/Fetch/ManufacturerFetch", "UlFetch2", event, 1);//1 -- pageIndex
    });

    //fetch - Model 
    var modelFetchObj = {
        SearchColumn: 'txtARModel-Model',//Id of Fetch field
        ResultColumns: ["ModelId-Primary Key", 'Model-Model'],
        FieldsToBeFilled: ["hdnARModelId-ModelId", "txtARModel-Model"]
    };

    $('#txtARModel').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divARModelFetch', modelFetchObj, "/api/Fetch/ModelFetch", "UlFetch3", event, 1);//1 -- pageIndex
    });

    //search - type code 
    var typeCodeSearchObj = {
        Heading: "Asset Type Code",//Heading of the popup
        SearchColumns: ['AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description', 'AssetClassificationCode-Asset Classification Code'],//ModelProperty - Space seperated label value
        ResultColumns: ["AssetTypeCodeId-Primary Key", 'AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description', 'AssetClassificationCode-Asset Classification Code'],//Columns to be returned for display
        FieldsToBeFilled: ["hdnAssetTypeCodeId-AssetTypeCodeId", "txtAssetTypeCode-AssetTypeCode", "txtAssetTypeDesc-AssetTypeDescription"]//id of element - the model property
    };

    $('#spnPopup-staff').click(function () {
        DisplaySeachPopup('divSearchPopup', typeCodeSearchObj, "/api/Search/TypeCodeSearch");
    });

    //search - Manufacturer
    var manufacturerSearchObj = {
        Heading: "Manufacturer",
        SearchColumns: ['Manufacturer-Manufacturer'],
        ResultColumns: ["ManufacturerId-Primary Key", 'Manufacturer-Manufacturer'],
        FieldsToBeFilled: ["hdnARManufacturerId-ManufacturerId", "txtARManufacturer-Manufacturer"]
    };

    $('#spnPopup-manufacturer').click(function () {
        DisplaySeachPopup('divSearchPopup', manufacturerSearchObj, "/api/Search/ManufacturerSearch");
    });


    var modelSearchObj = {
        Heading: "Model",
        SearchColumns: ['Model-Model'],
        ResultColumns: ["ModelId-Primary Key", 'Model-Model'],
        FieldsToBeFilled: ["hdnARModelId-ModelId", "txtARModel-Model"]
    };

    $('#spnPopup-model').click(function () {
        DisplaySeachPopup('divSearchPopup', modelSearchObj, "/api/Search/ModelSearch");
    });
    $('#btnAddNew').click(function () {
        window.location.reload();
    });

    $("#btnCancel").click(function () {
        window.location.href = "/BEMS/PPMRegister";
    });
    function displayErrorMsg() {
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnSave').attr('disabled', false);

    }
});



function getFileDetails(e, index) {

    var _index;
    var DocumentId = $('#hdnDocumentId_' + index).val();
    var FileType = $('#FileTypeId_' + index).val(); // bems 

    for (var i = 0; i < e.files.length; i++) {
        var f = e.files[i];
        var file = f;
        var blob = e.files[i].slice();
        var filetype = file.type;
        var filesize = file.size;
        var FileName = file.name;
        var totalSize = 0;
        var reader = new FileReader();

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

            var appType = ['application/pdf', 'application/x-download', 'application/doc', 'application/docx', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/tig'];
            var errMessage = "Please upload Pdf File.";

            var fileExtension = f.type.split('/');
            //  var newFileExt = fileExtension[1].replace("msword", "doc").replace("vnd.openxmlformats-officedocument.wordprocessingml.document", "docx")
            var filename = FileName; //+ "." + newFileExt; //".pdf";
            if (evt.target.readyState == FileReader.DONE) {
                var cont = evt.target.result;
                var base64String = getB64Str(cont);

                ListModelData = { contentType: filetype, contentAsBase64String: base64String, FileName: filename, FileType: FileType, DocumentId: DocumentId, index: index };

                ListModel.push(ListModelData);
            }

        };
        reader.readAsArrayBuffer(blob);
    }
}

function downloadfiles(maxindex) {
    var DocumentId = $('#DocumentId_' + maxindex).val();
    $.get("/api/Common/Download/" + DocumentId)
                .done(function (result) {
                    var data = JSON.parse(result);
                    var FileName = data.FileName;
                    var ContentType = "item.st"
                    var Gid = "";
                    // /bems/general/Print?Gid=BA9899AC-E7C6-4322-971A-0F30F64FCFCD&FileName=ba9899ac-e7c6-4322-971a-0f30f64fcfcd_fff.jpeg&ContentType={{item.st}}
                    window.location.href = "/BEMS/General/Print?Gid=" + Gid + "&FileName=" + FileName + "&ContentType=" + ContentType;
                    //  window.location.href = '@Url.Action("Add", "General", new { Gid = "", FileName =filename, ContentType= ctype })';
                    $('#myPleaseWait').modal('hide');

                })
               .fail(function () {
                   $('#myPleaseWait').modal('hide');
                   $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                   $('#errorMsg').css('visibility', 'visible');
               });
}
function AddNewRow() {

    var inputpar = {
        inlineHTML: ' <tr> ' +
                     '<td width="25%"> <div> ' +
                     '<input type="text" id="histVersion_maxindexval" name="Version" class="form-control" readonly/> </div>' +
                     '</td>' +
                     '<td width="25%"> <div> ' +
                     '<input id="histEffectiveDate_maxindexval" type="text" class="form-control" readonly/> </div>' +
                     '</td>' +
                     '<td width="30%" style="text-align: center;"> <div> <input type="hidden" id="DocumentId_maxindexval"/>' +
                     '<a class="glyphicon glyphicon-download-alt" id="AttachmentNo_maxindexval" onclick="downloadfiles(maxindexval)"></a> &nbsp; ' +
                     '<input type="text" id="DocumentTitle_maxindexval" readonly/> </div>' +
                     '</td>' +
                     '<td width="20%" style="text-align: center;"> <div> ' +
                     '<input id="histUploadDate_maxindexval" type="text" class="form-control" readonly> </div>' +
                     '</td>' +
                     '</tr>',
        IdPlaceholderused: "maxindexval",
        TargetId: "#HistoryGrid",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
}