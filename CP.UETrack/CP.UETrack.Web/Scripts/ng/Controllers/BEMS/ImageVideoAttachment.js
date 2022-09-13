var ListModel = [];
var HiddenId = $('#hdnAttachId').val();

$(document).ready(function () {

    $("#ImageVideoTab").click(function () {
        
        var primaryId = $('#hdnARPrimaryID').val();
        var HiddenId = $('#hdnAttachId').val();
        HideDelete()
        if (primaryId == 0) {
            bootbox.alert(Messages.SAVE_FIRST_TABALERT);
            return false;
        }
        else {

            if (HiddenId != null && HiddenId != "0" && HiddenId != "" && HiddenId != 0) {
                GetById(HiddenId);
                
            }
        }
    });



    //  ************************************Save *************************************

    $("#btnARImageSave, #btnARImageEdit").unbind('click');
    $("#btnARImageSave, #btnARImageEdit").click(function () {
        $('#btnARImageSave').attr('disabled', true);
        $('#btnARImageEdit').attr('disabled', true);
        $('#myPleaseWait').modal('show');

        if (ListModel.length == 0 || ListModel == null || ListModel == undefined) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text("Please Choose file");
            $('#errorMsg1').css('visibility', 'visible');
            $('#btnARImageSave').attr('disabled', false);
            $('#btnARImageEdit').attr('disabled', false);
        }
        else {

            $("div.errormsgcenter").text("");
            $('#errorMsg1').css('visibility', 'hidden');

            var primaryId = $('#hdnARPrimaryID').val();
            var HiddenId = $('#hdnAttachId').val();
            var Document = {
                AssetId: primaryId,
                DocumentGuId: HiddenId,
                ImageVideoUploadListData: ListModel
            };
            var data = JSON.stringify(Document);
            SaveImageVideoAttachMST(Document);
        }
        
    });

    function SaveImageVideoAttachMST(Document) {

        ApiUrl = "/api/ImageVideoUpload/Save"
        $.ajax({
            type: "POST",
            url: ApiUrl,
            data: Document,
            success: function (response) {

                var getResult = JSON.parse(response);
                BindGetbyIdVal(getResult);
                showMessage('Image/Video Upload', CURD_MESSAGE_STATUS.SS);
                $("#top-notifications").modal('show');

                $('#btnARImageSave').attr('disabled', false);
                $('#btnARImageEdit').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            },
            error: function (error) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                $('#errorMsg1').css('visibility', 'visible');
                $('#btnARImageSave').attr('disabled', false);
                $('#btnARImageEdit').attr('disabled', false);
            }
        });
    }

    //************************************* Refresh & Cancel ***********************************

    $("#btntab12Cancel").click(function () {
        //window.location.href = "/bems/general";
        var message = Messages.Reset_TabAlert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                EmptyFieldsImageUpload();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
        
    });
    //$("#btnCancel").click(function () {
    //    window.location.href = "bems/assetregister";
    //});
    
    //********************** Del img1

    $("#btnARImg1Delete").click(function () {
        $('#btnARImg1Delete').attr('disabled', true);
        var DocumentId = $("#hdnARdocumentId1").val();
        var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
        bootbox.confirm(message,function (result) {
            if(result){
                $('#ARblah1').attr('src', '');
                $("#ARimg1").val("");
                if (DocumentId != null && DocumentId != 0 && DocumentId != "") {
                    confirmDeleteImgVideo(DocumentId);
                }
                else {
                    $.each(ListModel, function (index, value) {
                        if (ListModel[index].Remarks == "i1") {
                            ListModel[index].contentAsBase64String = "";
                            ListModel[index].Remarks = "";
                        }
                    });
                }
                HideDelete();
            }            
        });
        $('#btnARImg1Delete').attr('disabled', false);
    });

    //********************** Del img2

    $("#btnARImg2Delete").click(function () {
        $('#btnARImg2Delete').attr('disabled', true);
        var DocumentId = $("#hdnARdocumentId2").val();
        var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                $('#ARblah2').attr('src', '');
                $("#ARimg2").val("");
                if (DocumentId != null && DocumentId != 0 && DocumentId != "") {
                    confirmDeleteImgVideo(DocumentId);
                }
                else {
                    $.each(ListModel, function (index, value) {
                        if (ListModel[index].Remarks == "i2") {
                            ListModel[index].contentAsBase64String = "";
                            ListModel[index].Remarks = "";
                        }
                    });
                }
                HideDelete();
            }
        });
        $('#btnARImg2Delete').attr('disabled', false);
    });

    //********************** Del img3

    $("#btnARImg3Delete").click(function () {
        $('#btnARImg3Delete').attr('disabled', true);
        var DocumentId = $("#hdnARdocumentId3").val();
        var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                $('#ARblah3').attr('src', '');
                $("#ARimg3").val("");
                if (DocumentId != null && DocumentId != 0 && DocumentId != "") {
                    confirmDeleteImgVideo(DocumentId);
                }
                else {
                    $.each(ListModel, function (index, value) {
                        if (ListModel[index].Remarks == "i3") {
                            ListModel[index].contentAsBase64String = "";
                            ListModel[index].Remarks = "";
                        }
                    });
                }
                HideDelete();
            }
        });
        $('#btnARImg3Delete').attr('disabled', false);
    });

    //********************** Del img4

    $("#btnARImg4Delete").click(function () {
        $('#btnARImg4Delete').attr('disabled', true);
        var DocumentId = $("#hdnARdocumentId4").val();
        var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                $('#ARblah4').attr('src', '');
                $("#ARimg4").val("");
                if (DocumentId != null && DocumentId != 0 && DocumentId != "") {
                    confirmDeleteImgVideo(DocumentId);
                }
                else {
                    $.each(ListModel, function (index, value) {
                        if (ListModel[index].Remarks == "i4") {
                            ListModel[index].contentAsBase64String = "";
                            ListModel[index].Remarks = "";
                        }
                    });
                }
                HideDelete();
            }
        });
        $('#btnARImg4Delete').attr('disabled', false);
    });

    //********************** Del img5

    $("#btnARImg5Delete").click(function () {
        $('#btnARImg5Delete').attr('disabled', true);
        var DocumentId = $("#hdnARdocumentId5").val();
        var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                $('#ARblah5').attr('src', '');
                $("#ARimg5").val("");
                if (DocumentId != null && DocumentId != 0 && DocumentId != "") {
                    confirmDeleteImgVideo(DocumentId);
                }
                else {
                    $.each(ListModel, function (index, value) {
                        if (ListModel[index].Remarks == "i5") {
                            ListModel[index].contentAsBase64String = "";
                            ListModel[index].Remarks = "";
                        }
                    });
                }
                HideDelete();
            }
        });
        $('#btnARImg5Delete').attr('disabled', false);
    });

    //********************** Del img6

    $("#btnARImg6Delete").click(function () {
        $('#btnARImg6Delete').attr('disabled', true);
        var DocumentId = $("#hdnARdocumentId6").val();
        var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                $('#ARblah6').attr('src', '');
                $("#ARimg6").val("");
                if (DocumentId != null && DocumentId != 0 && DocumentId != "") {
                    confirmDeleteImgVideo(DocumentId);
                }
                else {
                    $.each(ListModel, function (index, value) {
                        if (ListModel[index].Remarks == "i6") {
                            ListModel[index].contentAsBase64String = "";
                            ListModel[index].Remarks = "";
                        }
                    });
                }
                HideDelete();
            }
        });
        $('#btnARImg6Delete').attr('disabled', false);
    });

    //********************** Del img7

    $("#btnARVid7Delete").click(function () {
        $('#btnARVid7Delete').attr('disabled', true);
        var DocumentId = $("#hdnARdocumentId7").val();
        var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                $('#ARblah7').attr('src', '');
                $("#ARvid7").val("");
                $("#divVideo video")[0].load();
                if (DocumentId != null && DocumentId != 0 && DocumentId != "") {
                    confirmDeleteImgVideo(DocumentId);
                }
                else {
                    $.each(ListModel, function (index, value) {
                        if (ListModel[index].Remarks == "v7") {
                            ListModel[index].contentAsBase64String = "";
                            ListModel[index].Remarks = "";
                        }
                    });
                }
                HideDelete();
            }
        });
        $('#btnARVid7Delete').attr('disabled', false);
    });

});

//************************************* Delete ***********************************

function confirmDeleteImgVideo(DocumentId) {
    $.get("/api/ImageVideoUpload/Delete/" + DocumentId)
        .done(function (result) {

            var HiddenId = $('#hdnAttachId').val();
            if (HiddenId != null && HiddenId != "0" && HiddenId != "" && HiddenId != 0) {
                GetById(HiddenId);
            }            
            showMessage('Image/Video', CURD_MESSAGE_STATUS.DS);
            $('#myPleaseWait').modal('hide');            
         })
         .fail(function () {
            showMessage('Image/Video', CURD_MESSAGE_STATUS.DF);
            $('#myPleaseWait').modal('hide');
         });
}  
  
//************************************* BindGetbyId ***********************************

function GetById(HiddenId) {
    $.get("/api/ImageVideoUpload/GetUploadDetails/" + HiddenId)
      .done(function (result) {

          var getResult = JSON.parse(result);
          ARImageVideoTabClear();
          if (getResult != null && getResult.ImageVideoUploadListData != null && getResult.ImageVideoUploadListData.length > 0) {
              BindGetbyIdVal(getResult);
          }
          //ListModel.pop();
          HideDelete();
          $('#myPleaseWait').modal('hide');
      })
     .fail(function () {
         $('#myPleaseWait').modal('hide');
         $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
         $('#errorMsg1').css('visibility', 'visible');
     });
}



function BindGetbyIdVal(getResult) {
    HideDelete();
    var ActionType = $('#hdnARActionType').val();
    
    ListModel = getResult.ImageVideoUploadListData;    
    
    $.each(getResult.ImageVideoUploadListData, function (index, value) {
        if (getResult.ImageVideoUploadListData[index].Remarks == "i1") {
            $('#hdnARdocumentId1').val(getResult.ImageVideoUploadListData[index].DocumentId)
            $('#ARblah1').attr('src', "/Attachments/" + getResult.ImageVideoUploadListData[index].FilePath);
            $("#ARimg1").val("");
        }
        else if (getResult.ImageVideoUploadListData[index].Remarks == "i2") {
            $('#hdnARdocumentId2').val(getResult.ImageVideoUploadListData[index].DocumentId)
            $('#ARblah2').attr('src', "/Attachments/" + getResult.ImageVideoUploadListData[index].FilePath);
            $("#ARimg2").val("");
        }
        else if (getResult.ImageVideoUploadListData[index].Remarks == "i3") {
            $('#hdnARdocumentId3').val(getResult.ImageVideoUploadListData[index].DocumentId)
            $('#ARblah3').attr('src', "/Attachments/" + getResult.ImageVideoUploadListData[index].FilePath);
            $("#ARimg3").val("");
        }
        else if (getResult.ImageVideoUploadListData[index].Remarks == "i4") {
            $('#hdnARdocumentId4').val(getResult.ImageVideoUploadListData[index].DocumentId)
            $('#ARblah4').attr('src', "/Attachments/" + getResult.ImageVideoUploadListData[index].FilePath);
            $("#ARimg4").val("");
        }
        else if (getResult.ImageVideoUploadListData[index].Remarks == "i5") {
            $('#hdnARdocumentId5').val(getResult.ImageVideoUploadListData[index].DocumentId)
            $('#ARblah5').attr('src', "/Attachments/" + getResult.ImageVideoUploadListData[index].FilePath);
            $("#ARimg5").val("");
        }
        else if (getResult.ImageVideoUploadListData[index].Remarks == "i6") {
            $('#hdnARdocumentId6').val(getResult.ImageVideoUploadListData[index].DocumentId)
            $('#ARblah6').attr('src', "/Attachments/" + getResult.ImageVideoUploadListData[index].FilePath);
            $("#ARimg6").val("");
        }
        else if (getResult.ImageVideoUploadListData[index].Remarks == "v7") {
            $('#hdnARdocumentId7').val(getResult.ImageVideoUploadListData[index].DocumentId)
            $('#ARblah7').attr('src', "/Attachments/" + getResult.ImageVideoUploadListData[index].FilePath);
            $("#divVideo video")[0].load();            
            // $("#divVideo video")[0].play();
            $("#ARvid7").val("");

        }               
    });
    
    if (ActionType == "View") {
        $("#btnARImg1Delete").hide();
        $("#btnARImg2Delete").hide();
        $("#btnARImg3Delete").hide();
        $("#btnARImg4Delete").hide();
        $("#btnARImg5Delete").hide();
        $("#btnARImg6Delete").hide();
        $("#btnARVid7Delete").hide();
    }
}

//************************************* Upload files ***********************************

function getARImageVideoDetails(e,id,type) {     
    var gettype = type + id;    
    var HiddenId = $('#hdnAttachId').val();
    for (var i = 0; i < e.files.length; i++) {
        var f = e.files[i];
        var file = f;
        var blob = e.files[i].slice();
        var filetype = file.type;
        var filesize = file.size;
        var FileName = file.name;
        var extension = FileName.replace(/^.*\./, '');
        var reader = new FileReader();

        var VideoappType = ['video/mp4'];
        var ImgappType = ['image/jpeg', 'image/jpg', 'image/png'];
        var VideoMaxSize = 8388608; //  - 8Mb;
        var ImgMaxSize = 4194304;   //  - 4Mb;
       
        if (type == "i") {
            if ((filetype == "image/jpeg") || (filetype == "image/jpg") || (filetype == "image/png")) {
                if (ImgMaxSize >= filesize) {

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
                            var Icount = Enumerable.From(ListModel).Where(x=>x.Remarks == gettype).Count();
                            if (Icount > 0) {
                                $.each(ListModel, function (value) {
                                    if (value.Remarks == gettype) {
                                        value.DocumentTitle = FileName;
                                        value.DocumentExtension = filetype;
                                        value.Remarks = gettype;
                                        value.ContentType = extension;
                                        value.contentAsBase64String = base64String;
                                    }
                                });
                            }
                            else {
                                ListModelData = [{
                                    DocumentId: 0,
                                    GuId: '',
                                    DocumentNo: null,
                                    DocumentTitle: FileName,
                                    DocumentDescription: null,
                                    DocumentCategory: null,
                                    DocumentCategoryOthers: null,
                                    DocumentExtension: filetype,
                                    MajorVersion: null,
                                    MinorVersion: null,
                                    FileType: null,
                                    FilePath: null,
                                    FileName: null,
                                    Remarks: gettype,
                                    DocumentGuId: HiddenId,
                                    ContentType: extension,
                                    contentAsBase64String: base64String,
                                    // index: index   

                                }];

                                ListModel.push.apply(ListModel, ListModelData);
                            }                            
                        }
                    };
                    reader.readAsArrayBuffer(blob);
                    if (type == "i") {
                        var Ioutput = document.getElementById('ARblah' + id);
                        Ioutput.src = window.URL.createObjectURL(event.target.files[0]);                        
                        HideDelete();
                    }
                    else {
                        var Voutput = $('#ARblah' + id);
                        Voutput[0].src = URL.createObjectURL(event.target.files[0]);
                        Voutput.parent()[0].load();
                        $("#divVideo video")[0].load();
                        HideDelete();
                    }
                }
                else {
                    bootbox.alert("File size must be less than 4MB.");
                    ClearChoosefile(gettype);
                }
            }
            else {
                bootbox.alert("Please upload jpeg/jpg/png format Only.");
                ClearChoosefile(gettype);
            }
        }
        else if(type=="v")
        {
            if (filetype == "video/mp4") {
                if (VideoMaxSize >= filesize) {

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

                            var Vcount = Enumerable.From(ListModel).Where(x=>x.Remarks == gettype).Count();
                            if (Vcount > 0) {
                                $.each(ListModel, function (value) {
                                    if (value.Remarks == gettype) {
                                        value.DocumentTitle = FileName;
                                        value.DocumentExtension = filetype;
                                        value.Remarks = gettype;
                                        value.ContentType = extension;
                                        value.contentAsBase64String = base64String;
                                    }
                                });
                            }
                            else {
                                ListModelData = [{
                                    DocumentId: 0,
                                    GuId: '',
                                    DocumentNo: null,
                                    DocumentTitle: FileName,
                                    DocumentDescription: null,
                                    DocumentCategory: null,
                                    DocumentCategoryOthers: null,
                                    DocumentExtension: filetype,
                                    MajorVersion: null,
                                    MinorVersion: null,
                                    FileType: null,
                                    FilePath: null,
                                    FileName: null,
                                    Remarks: gettype,
                                    DocumentGuId: HiddenId,
                                    ContentType: extension,
                                    contentAsBase64String: base64String,
                                    // index: index   

                                }];

                                ListModel.push.apply(ListModel, ListModelData);
                            }                           
                        }
                    };
                    reader.readAsArrayBuffer(blob);
                    if (type == "i") {
                        var Ioutput = document.getElementById('ARblah' + id);
                        Ioutput.src = URL.createObjectURL(event.target.files[0]);
                        HideDelete();
                    }
                    else {
                        var Voutput = $('#ARblah' + id);
                        Voutput[0].src = URL.createObjectURL(event.target.files[0]);
                        Voutput.parent()[0].load();
                        $("#divVideo video")[0].load();
                        HideDelete();
                    }
                }
                else {
                    bootbox.alert("File size must be less than 8 MB.");
                    ClearChoosefile(gettype);
                }
            }
            else {
                bootbox.alert("Please upload MP4 format Only.");
                ClearChoosefile(gettype);
            }

        }       

    }
}

function ClearChoosefile(gettype)
{
    if (gettype == "i1") {
        $('#ARblah1').attr('src', '');
        $("#ARimg1").val("");
        $('#btnARImg1Delete').attr('disabled', true);
    }
    else if (gettype == "i2") {
        $('#ARblah2').attr('src', '');
        $("#ARimg2").val("");
        $('#btnARImg2Delete').attr('disabled', true);
    }
    else if (gettype == "i3") {
        $('#ARblah3').attr('src', '');
        $("#ARimg3").val("");
        $('#btnARImg3Delete').attr('disabled', true);
    }
    else if (gettype == "i4") {
        $('#ARblah4').attr('src', '');
        $("#ARimg4").val("");
        $('#btnARImg4Delete').attr('disabled', true);
    }
    else if (gettype == "i5") {
        $('#ARblah5').attr('src', '');
        $("#ARimg5").val("");
        $('#btnARImg5Delete').attr('disabled', true);
    }
    else if (gettype == "i6") {
        $('#ARblah6').attr('src', '');
        $("#ARimg6").val("");
        $('#btnARImg6Delete').attr('disabled', true);
    }
    else if (gettype == "v7") {
        $('#ARblah7').attr('src', '');
        $("#divVideo video")[0].load(); 
        $("#ARvid7").val("");
        $('#btnARVid7Delete').attr('disabled', true);
    }
}


function EmptyFieldsImageUpload() {

    $('input[type="text"], textarea').val('');
    $('#selARAssetClassification').val("null");
    $('#selARTypeofasset').val("null");
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
    $('#errorMsg1').css('visibility', 'hidden');
    $('.nav-tabs a:first').tab('show')
    ARImageVideoTabClear();
   
}

function HideDelete() {
    var delimg1 = $('#ARblah1').attr('src');
    var delimg2 = $('#ARblah2').attr('src');
    var delimg3 = $('#ARblah3').attr('src');
    var delimg4 = $('#ARblah4').attr('src');
    var delimg5 = $('#ARblah5').attr('src');
    var delimg6 = $('#ARblah6').attr('src');
    var delvid1 = $('#ARblah7').attr('src');

    if (delimg1 == "") {
        $('#btnARImg1Delete').attr('disabled', true);
        $("#ARimg1").attr('disabled', false);
    }
    else {
        $('#btnARImg1Delete').attr('disabled', false);
        $("#ARimg1").attr('disabled', true);
    }
    if (delimg2 == "") {
        $('#btnARImg2Delete').attr('disabled', true);
        $("#ARimg2").attr('disabled', false);
    }
    else {
        $('#btnARImg2Delete').attr('disabled', false);
        $("#ARimg2").attr('disabled', true);
    }
    if (delimg3 == "") {
        $('#btnARImg3Delete').attr('disabled', true);
        $("#ARimg3").attr('disabled', false);
    }
    else {
        $('#btnARImg3Delete').attr('disabled', false);
        $("#ARimg3").attr('disabled', true);
    }
    if (delimg4 == "") {
        $('#btnARImg4Delete').attr('disabled', true);
        $("#ARimg4").attr('disabled', false);
    }
    else {
        $('#btnARImg4Delete').attr('disabled', false);
        $("#ARimg4").attr('disabled', true);
    }
    if (delimg5 == "") {
        $('#btnARImg5Delete').attr('disabled', true);
        $("#ARimg5").attr('disabled', false);
    }
    else {
        $('#btnARImg5Delete').attr('disabled', false);
        $("#ARimg5").attr('disabled', true);
    }
    if (delimg6 == "") {
        $('#btnARImg6Delete').attr('disabled', true);
        $("#ARimg6").attr('disabled', false);
    }
    else {
        $('#btnARImg6Delete').attr('disabled', false);
        $("#ARimg6").attr('disabled', true);
    }
    if (delvid1 == "") {
        $('#btnARVid7Delete').attr('disabled', true);
        $("#ARvid7").attr('disabled', false);
        $("#divVideo video")[0].load();
    }
    else {
        $('#btnARVid7Delete').attr('disabled', false);
        $("#ARvid7").attr('disabled', true);
    }
    if (delimg1 == "" && delimg2 == "" && delimg3 == "" && delimg4 == "" && delimg5 == "" && delimg6 == "" && delvid1 == "") {
        $('#myPleaseWait').modal('hide');
        $("div.errormsgcenter").text("");
        $('#errorMsg1').css('visibility', 'hidden');
        $('#btnARImageSave').attr('disabled', true);
        $('#btnARImageEdit').attr('disabled', true);
    }
    else {
        $('#myPleaseWait').modal('hide');
        $('#btnARImageSave').attr('disabled', false);
        $('#btnARImageEdit').attr('disabled', false);
    }
}

function ARImageVideoTabClear() {
    $('#ARblah1').attr('src', '');
    $('#ARblah2').attr('src', '');
    $('#ARblah3').attr('src', '');
    $('#ARblah4').attr('src', '');
    $('#ARblah5').attr('src', '');
    $('#ARblah6').attr('src', '');
    $('#ARblah7').attr('src', '');
    HideDelete();
}