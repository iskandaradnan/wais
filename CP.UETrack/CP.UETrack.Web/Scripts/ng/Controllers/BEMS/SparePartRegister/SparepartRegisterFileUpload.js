var ListModel = [];
var HiddenId = $('#hdnAttachId').val();



$(document).ready(function () {
     HideDelete();

    //$("#SparePartImageVideoTab").click(function () {

    //    var primaryId = $('#primaryID').val();
    //    var HiddenId = $('#hdnAttachId').val();
    //    alert(primaryId);
    //    if (primaryId == 0) {
    //        bootbox.alert(Messages.SAVE_FIRST_TABALERT);
    //        return false;
    //    }
    //    else {
    //        if (HiddenId != null && HiddenId != "0" && HiddenId != "" && HiddenId != 0) {
    //            GetById(HiddenId);

    //        }
    //    }
    //});
     



    //  ************************************Save *************************************

    $("#btnSPImageSave, #btnSPImageEdit").unbind('click');
    $("#btnSPImageSave, #btnSPImageEdit").click(function () {
        $('#btnSPImageSave').attr('disabled', true);
        $('#btnSPImageEdit').attr('disabled', true);
        $('#myPleaseWait').modal('show');

        if (ListModel.length == 0 || ListModel == null || ListModel == undefined) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text("Please Choose file");
            $('#errorMsg1').css('visibility', 'visible');
            $('#btnSPImageSave').attr('disabled', false);
            $('#btnSPImageEdit').attr('disabled', false);
        }
        else {
            $("div.errormsgcenter").text("");
            $('#errorMsg1').css('visibility', 'hidden');
            var primaryId = $('#primaryID').val();
            var HiddenId = $('#hdnAttachId').val();
            var Document = {
                SparePartsId: primaryId,
                DocumentGuId: HiddenId,
                ImageVideoUploadListData: ListModel
            };
            var data = JSON.stringify(Document);
            SaveImageVideoAttachMST();
        }
        function SaveImageVideoAttachMST() {

            ApiUrl = "/api/SpareParts/SPImageVideoSave"
            $.ajax({
                type: "POST",
                url: ApiUrl,
                data: Document,
                success: function (response) {

                    var getResult = JSON.parse(response);
                    BindGetbyIdVal(getResult);
                    showMessage('Image/Video Upload', CURD_MESSAGE_STATUS.SS);
                    $("#top-notifications").modal('show');

                    $('#btnSPImageSave').attr('disabled', false);
                    $('#btnSPImageEdit').attr('disabled', false);
                    $('#myPleaseWait').modal('hide');
                },
                error: function (error) {
                    $('#myPleaseWait').modal('hide');
                    $("div.errormsgcenter").text(error);
                    $('#errorMsg1').css('visibility', 'visible');
                    $('#btnSPImageSave').attr('disabled', false);
                    $('#btnSPImageEdit').attr('disabled', false);
                }
            });
        }

    });

    
    //************************************* Refresh & Cancel ***********************************

   
    
    $("#btnSPImageVideoCancel").unbind('click');
    $("#btnSPImageVideoCancel").click(function () {
        var message = Messages.Reset_Alert_CONFIRMATION;
        bootbox.confirm(message, function (resultdata) {
            if (resultdata) {
                ImageTabClearFields();
                ClearFields();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });


    function ImageTabClearFields() {
        $("input[type=text],textarea").val("");
        $('#primaryID').val('');
        $('#btnEdit').hide();
        $('#btnSave').show();
        $('#btnDelete').hide();
        $("#grid").trigger('reloadGrid');
        $("#SparePartImageVideoTab :input:not(:button)").parent().removeClass('has-error');
        $("div.errormsgcenter").text("");
        $('#errorMsg1').css('visibility', 'hidden');
        $('.nav-tabs a:first').tab('show');
        SPimageVideoTabClear();
    }


    //********************** Del img1

    $("#btnSPImg1Delete").click(function () {
        $('#btnSPImg1Delete').attr('disabled', true);
        var DocumentId = $("#hdnSPdocumentId1").val();
        var msg = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
        bootbox.confirm(msg, function (delresult) {
            if (delresult) {
                $('#SPblah1').attr('src', '');
                $("#SPimg1").val("");
                if (DocumentId != null && DocumentId != 0 && DocumentId != "") {
                    confirmDeleteSPImgVid(DocumentId);
                }
                else {
                    $.each(ListModel, function (index, value) {
                        if (ListModel[index].Remarks == "i1") {
                            ListModel[index].Remarks = "";
                            ListModel[index].base64String = "";
                            ListModel[index].contentAsBase64String = "";
                            ListModel[index].ContentType = "";
                            ListModel[index].DocumentGuId = "";
                            ListModel[index].DocumentExtension = "";
                            ListModel[index].DocumentTitle = "";
                        }
                    });
                }
                HideDelete();
                bootbox.hideAll();
            }
            bootbox.hideAll();
        });
        $('#btnSPImg1Delete').attr('disabled', false);
    });

    //********************** Del img2

    $("#btnSPImg2Delete").click(function () {
        $('#btnSPImg2Delete').attr('disabled', true);
        var DocumentId = $("#hdnSPdocumentId2").val();
        var msg = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
        bootbox.confirm(msg, function (delresult) {
            if (delresult) {
                $('#SPblah2').attr('src', '');
                $("#SPimg2").val("");
                if (DocumentId != null && DocumentId != 0 && DocumentId != "") {
                    confirmDeleteSPImgVid(DocumentId);
                }
                else {
                    $.each(ListModel, function (index, value) {
                        if (ListModel[index].Remarks == "i2") {
                            ListModel[index].Remarks = "";
                            ListModel[index].base64String = "";
                            ListModel[index].contentAsBase64String = "";
                            ListModel[index].ContentType = "";
                            ListModel[index].DocumentGuId = "";
                            ListModel[index].DocumentExtension = "";
                            ListModel[index].DocumentTitle = "";
                        }
                    });
                }
                HideDelete();
                bootbox.hideAll();
            }
            bootbox.hideAll();
        });
        $('#btnSPImg2Delete').attr('disabled', false);
    });

    //********************** Del img3

    $("#btnSPImg3Delete").click(function () {
        $('#btnSPImg3Delete').attr('disabled', true);
        var DocumentId = $("#hdnSPdocumentId3").val();
        var msg = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
        bootbox.confirm(msg, function (delresult) {
            if (delresult) {
                $('#SPblah3').attr('src', '');
                $("#SPimg3").val("");
                if (DocumentId != null && DocumentId != 0 && DocumentId != "") {
                    confirmDeleteSPImgVid(DocumentId);
                }
                else {
                    $.each(ListModel, function (index, value) {
                        if (ListModel[index].Remarks == "i3") {
                            ListModel[index].Remarks = "";
                            ListModel[index].base64String = "";
                            ListModel[index].contentAsBase64String = "";
                            ListModel[index].ContentType = "";
                            ListModel[index].DocumentGuId = "";
                            ListModel[index].DocumentExtension = "";
                            ListModel[index].DocumentTitle = "";
                        }
                    });
                }
                HideDelete();
                bootbox.hideAll();
            }
            bootbox.hideAll();
        });
        $('#btnSPImg3Delete').attr('disabled', false);
    });

    //********************** Del img4

    $("#btnSPImg4Delete").click(function () {
        $('#btnSPImg4Delete').attr('disabled', true);
        var DocumentId = $("#hdnSPdocumentId4").val();
        var msg = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
        bootbox.confirm(msg, function (delresult) {
            if (delresult) {
                $('#SPblah4').attr('src', '');
                $("#SPimg4").val("");
                if (DocumentId != null && DocumentId != 0 && DocumentId != "") {
                    confirmDeleteSPImgVid(DocumentId);
                }
                else {
                    $.each(ListModel, function (index, value) {
                        if (ListModel[index].Remarks == "i4") {
                            ListModel[index].Remarks = "";
                            ListModel[index].base64String = "";
                            ListModel[index].contentAsBase64String = "";
                            ListModel[index].ContentType = "";
                            ListModel[index].DocumentGuId = "";
                            ListModel[index].DocumentExtension = "";
                            ListModel[index].DocumentTitle = "";
                        }
                    });
                }
                HideDelete();
                bootbox.hideAll();
            }
            bootbox.hideAll();
        });
        $('#btnSPImg4Delete').attr('disabled', false);
    });

    //********************** Del img5

    $("#btnSPImg5Delete").click(function () {
        $('#btnSPImg5Delete').attr('disabled', true);
        var DocumentId = $("#hdnSPdocumentId5").val();
        var msg = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
        bootbox.confirm(msg, function (delresult) {
            if (delresult) {
                $('#SPblah5').attr('src', '');
                $("#SPimg5").val("");
                if (DocumentId != null && DocumentId != 0 && DocumentId != "") {
                    confirmDeleteSPImgVid(DocumentId);
                }
                else {
                    $.each(ListModel, function (index, value) {
                        if (ListModel[index].Remarks == "i5") {
                            ListModel[index].Remarks = "";
                            ListModel[index].base64String = "";
                            ListModel[index].contentAsBase64String = "";
                            ListModel[index].ContentType = "";
                            ListModel[index].DocumentGuId = "";
                            ListModel[index].DocumentExtension = "";
                            ListModel[index].DocumentTitle = "";
                        }
                    });
                }
                HideDelete();
                bootbox.hideAll();
            }
            bootbox.hideAll();
        });
        $('#btnSPImg5Delete').attr('disabled', false);
    });

    //********************** Del img6

    $("#btnSPImg6Delete").click(function () {
        $('#btnSPImg6Delete').attr('disabled', true);
        var DocumentId = $("#hdnSPdocumentId6").val();
        var msg = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
        bootbox.confirm(msg, function (delresult) {
            if (delresult) {
                $('#SPblah6').attr('src', '');
                $("#SPimg6").val("");
                if (DocumentId != null && DocumentId != 0 && DocumentId != "") {
                    confirmDeleteSPImgVid(DocumentId);
                }
                else {
                    $.each(ListModel, function (index, value) {
                        if (ListModel[index].Remarks == "i6") {
                            ListModel[index].Remarks = "";
                            ListModel[index].base64String = "";
                            ListModel[index].contentAsBase64String = "";
                            ListModel[index].ContentType = "";
                            ListModel[index].DocumentGuId = "";
                            ListModel[index].DocumentExtension = "";
                            ListModel[index].DocumentTitle = "";
                        }
                    });
                }
                HideDelete();
                bootbox.hideAll();
            }
            bootbox.hideAll();
        });
        $('#btnSPImg6Delete').attr('disabled', false);
    });

    //********************** Del Vid

    $("#btnSPVid7Delete").click(function () {
        $('#btnSPVid7Delete').attr('disabled', true);
        var DocumentId = $("#hdnSPdocumentId7").val();
        var msg = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
        bootbox.confirm(msg, function (delresult) {
            if (delresult) {
                $('#SPblah7').attr('src', '');
                $("#SPvid7").val("");
                $("#SPdivVideo video")[0].load();
                if (DocumentId != null && DocumentId != 0 && DocumentId != "") {
                    confirmDeleteSPImgVid(DocumentId);
                }
                else {
                    $.each(ListModel, function (index, value) {
                        if (ListModel[index].Remarks == "v7") {
                            ListModel[index].Remarks = "";
                            ListModel[index].base64String = "";
                            ListModel[index].contentAsBase64String = "";
                            ListModel[index].ContentType = "";
                            ListModel[index].DocumentGuId = "";
                            ListModel[index].DocumentExtension = "";
                            ListModel[index].DocumentTitle = "";
                        }
                    });
                }
                HideDelete();
                bootbox.hideAll();
            }
            bootbox.hideAll();
        });
        $('#btnSPVid7Delete').attr('disabled', false);
    });



});

//************************************* Delete ***********************************

function confirmDeleteSPImgVid(DocumentId) {
    $.get("/api/SpareParts/SPFileDelete/" + DocumentId)
        .done(function (delresult) {

            var HiddenId = $('#hdnAttachId').val();
            if (HiddenId != null && HiddenId != "0" && HiddenId != "" && HiddenId != 0) {
                GetById(HiddenId);
            }
            $(".content").scrollTop(0);
            showMessage('Image/Video', CURD_MESSAGE_STATUS.DS);
            $('#myPleaseWait').modal('hide');
        })
         .fail(function (response) {
             showMessage('Image/Video', CURD_MESSAGE_STATUS.DF);
             $('#myPleaseWait').modal('hide');
         });
}

//************************************* BindGetbyId ***********************************

window.GetById = function (HiddenId) {
    $.get("/api/SpareParts/SPGetUploadDetails/" + HiddenId)
      .done(function (result) {

          var getResult = JSON.parse(result);
          SPimageVideoTabClear();
          if (getResult != null && getResult.ImageVideoUploadListData != null && getResult.ImageVideoUploadListData.length > 0) {
              BindGetbyIdVal(getResult);
          }
          //ListModel.pop();
          HideDelete();
          $('#myPleaseWait').modal('hide');
      })
     .fail(function (response) {
         $('#myPleaseWait').modal('hide');
         $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
         $('#errorMsg1').css('visibility', 'visible');
     });
}

function BindGetbyIdVal(getResult) {
    HideDelete();
    var ActionType = $('#ActionType').val();

    ListModel = getResult.ImageVideoUploadListData;

    $.each(getResult.ImageVideoUploadListData, function (index, value) {
        if (getResult.ImageVideoUploadListData[index].Remarks == "i1") {
            $('#hdnSPdocumentId1').val(getResult.ImageVideoUploadListData[index].DocumentId)
            $('#SPblah1').attr('src', "/Attachments/" + getResult.ImageVideoUploadListData[index].FilePath);
            $("#SPimg1").val("");
        }
        else if (getResult.ImageVideoUploadListData[index].Remarks == "i2") {
            $('#hdnSPdocumentId2').val(getResult.ImageVideoUploadListData[index].DocumentId)
            $('#SPblah2').attr('src', "/Attachments/" + getResult.ImageVideoUploadListData[index].FilePath);
            $("#SPimg2").val("");
        }
        else if (getResult.ImageVideoUploadListData[index].Remarks == "i3") {
            $('#hdnSPdocumentId3').val(getResult.ImageVideoUploadListData[index].DocumentId)
            $('#SPblah3').attr('src', "/Attachments/" + getResult.ImageVideoUploadListData[index].FilePath);
            $("#SPimg3").val("");
        }
        else if (getResult.ImageVideoUploadListData[index].Remarks == "i4") {
            $('#hdnSPdocumentId4').val(getResult.ImageVideoUploadListData[index].DocumentId)
            $('#SPblah4').attr('src', "/Attachments/" + getResult.ImageVideoUploadListData[index].FilePath);
            $("#SPimg4").val("");
        }
        else if (getResult.ImageVideoUploadListData[index].Remarks == "i5") {
            $('#hdnSPdocumentId5').val(getResult.ImageVideoUploadListData[index].DocumentId)
            $('#SPblah5').attr('src', "/Attachments/" + getResult.ImageVideoUploadListData[index].FilePath);
            $("#SPimg5").val("");
        }
        else if (getResult.ImageVideoUploadListData[index].Remarks == "i6") {
            $('#hdnSPdocumentId6').val(getResult.ImageVideoUploadListData[index].DocumentId)
            $('#SPblah6').attr('src', "/Attachments/" + getResult.ImageVideoUploadListData[index].FilePath);
            $("#SPimg6").val("");
        }
        else if (getResult.ImageVideoUploadListData[index].Remarks == "v7") {
            $('#hdnSPdocumentId7').val(getResult.ImageVideoUploadListData[index].DocumentId)
            $('#SPblah7').attr('src', "/Attachments/" + getResult.ImageVideoUploadListData[index].FilePath);
            $("#SPdivVideo video")[0].load();
            // $("#SPdivVideo video")[0].play();
            $("#SPvid7").val("");
        }
    });

    if (ActionType == "View") {
        $("#btnSPImg1Delete").hide();
        $("#btnSPImg2Delete").hide();
        $("#btnSPImg3Delete").hide();
        $("#btnSPImg4Delete").hide();
        $("#btnSPImg5Delete").hide();
        $("#btnSPImg6Delete").hide();
        $("#btnSPVid7Delete").hide();
    }

}

//************************************* Upload files ***********************************

function getSPImageVideoUpload(e, id, type) {
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

                                }];

                                ListModel.push.apply(ListModel, ListModelData);
                            }
                        }
                    };
                    reader.readAsArrayBuffer(blob);
                    if (type == "i") {                        
                        var Ioutput = document.getElementById('SPblah' + id);
                        Ioutput.src = URL.createObjectURL(event.target.files[0]);
                        HideDelete();
                    }
                    else {                        
                        var Voutput = $('#SPblah' + id);
                        Voutput[0].src = URL.createObjectURL(event.target.files[0]);
                        Voutput.parent()[0].load();
                        $("#SPdivVideo video")[0].load();                        
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

        else if (type == "v") {
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

                                }];

                                ListModel.push.apply(ListModel, ListModelData);
                            }

                        }
                    };
                    reader.readAsArrayBuffer(blob);
                    if (type == "i") {
                        
                        var Ioutput = document.getElementById('SPblah' + id);
                        Ioutput.src = URL.createObjectURL(event.target.files[0]);
                        HideDelete();
                    }
                    else {
                        
                        var Voutput = $('#SPblah' + id);
                        Voutput[0].src = URL.createObjectURL(event.target.files[0]);
                        Voutput.parent()[0].load();
                        $("#SPdivVideo video")[0].load();                        
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


function ClearChoosefile(gettype) {
    if (gettype == "i1") {
        $('#SPblah1').attr('src', '');
        $("#SPimg1").val("");
        $('#btnSPImg1Delete').attr('disabled', true);
    }
    else if (gettype == "i2") {
        $('#SPblah2').attr('src', '');
        $("#SPimg2").val("");
        $('#btnSPImg2Delete').attr('disabled', true);
    }
    else if (gettype == "i3") {
        $('#SPblah3').attr('src', '');
        $("#SPimg3").val("");
        $('#btnSPImg3Delete').attr('disabled', true);
    }
    else if (gettype == "i4") {
        $('#SPblah4').attr('src', '');
        $("#SPimg4").val("");
        $('#btnSPImg4Delete').attr('disabled', true);
    }
    else if (gettype == "i5") {
        $('#SPblah5').attr('src', '');
        $("#SPimg5").val("");
        $('#btnSPImg5Delete').attr('disabled', true);
    }
    else if (gettype == "i6") {
        $('#SPblah6').attr('src', '');
        $("#SPimg6").val("");
        $('#btnSPImg6Delete').attr('disabled', true);
    }
    else if (gettype == "v7") {
        $('#SPblah7').attr('src', '');
        $("#SPdivVideo video")[0].load();
        $("#SPvid7").val("");
        $('#btnSPVid7Delete').attr('disabled', true);
    }
}

function HideDelete() {
    var delimg1 = $('#SPblah1').attr('src');
    var delimg2 = $('#SPblah2').attr('src');
    var delimg3 = $('#SPblah3').attr('src');
    var delimg4 = $('#SPblah4').attr('src');
    var delimg5 = $('#SPblah5').attr('src');
    var delimg6 = $('#SPblah6').attr('src');
    var delvid7 = $('#SPblah7').attr('src');

    if (delimg1 == "") {
        $('#btnSPImg1Delete').attr('disabled', true);
        $("#SPimg1").attr('disabled', false);
    }
    else {
        $('#btnSPImg1Delete').attr('disabled', false);
        $("#SPimg1").attr('disabled', true);
    }
    if (delimg2 == "") {
        $('#btnSPImg2Delete').attr('disabled', true);
        $("#SPimg2").attr('disabled', false);
    }
    else {
        $('#btnSPImg2Delete').attr('disabled', false);
        $("#SPimg2").attr('disabled', true);
    }
    if (delimg3 == "") {
        $('#btnSPImg3Delete').attr('disabled', true);
        $("#SPimg3").attr('disabled', false);
    }
    else {
        $('#btnSPImg3Delete').attr('disabled', false);
        $("#SPimg3").attr('disabled', true);
    }
    if (delimg4 == "") {
        $('#btnSPImg4Delete').attr('disabled', true);
        $("#SPimg4").attr('disabled', false);
    }
    else {
        $('#btnSPImg4Delete').attr('disabled', false);
        $("#SPimg4").attr('disabled', true);
    }
    if (delimg5 == "") {
        $('#btnSPImg5Delete').attr('disabled', true);
        $("#SPimg5").attr('disabled', false);
    }
    else {
        $('#btnSPImg5Delete').attr('disabled', false);
        $("#SPimg5").attr('disabled', true);
    }
    if (delimg6 == "") {
        $('#btnSPImg6Delete').attr('disabled', true);
        $("#SPimg6").attr('disabled', false);
    }
    else {
        $('#btnSPImg6Delete').attr('disabled', false);
        $("#SPimg6").attr('disabled', true);
    }
    if (delvid7 == "") {
        $('#btnSPVid7Delete').attr('disabled', true);
        $("#SPvid7").attr('disabled', false);
        $("#SPdivVideo video")[0].load();
    }
    else {
        $('#btnSPVid7Delete').attr('disabled', false);
        $("#SPvid7").attr('disabled', true);
    }
    if (delimg1 == "" && delimg2 == "" && delimg3 == "" && delimg4 == "" && delimg5 == "" && delimg6 == "" && delvid7 == "") {
        $('#myPleaseWait').modal('hide');
        $("div.errormsgcenter").text("");
        $('#errorMsg1').css('visibility', 'hidden');
        $('#btnSPImageSave').attr('disabled', true);
        $('#btnSPImageEdit').attr('disabled', true);
    }
    else {
        $('#myPleaseWait').modal('hide');        
        $('#btnSPImageSave').attr('disabled', false);
        $('#btnSPImageEdit').attr('disabled', false);
    }

}

function SPimageVideoTabClear() {
    $('#SPblah1').attr('src', '');
    $('#SPblah2').attr('src', '');
    $('#SPblah3').attr('src', '');
    $('#SPblah4').attr('src', '');
    $('#SPblah5').attr('src', '');
    $('#SPblah6').attr('src', '');
    $('#SPblah7').attr('src', '');
    HideDelete();
}
function ClearFields() {
    $('#spnPopup-ItemCode').show();
    $('#spnPopup-TypeCode').show();
    $('#txtAssetTypeCode,#LifespanOptionsId').prop('disabled', false);
    $('.Popdiv').show();
    $("input[type=text],textarea").val("");
    $('#UnitOfMeasurement').val('null');
    $('#PartSource').val('null');
    $('#Location').val('null');
    $('#Status').val(1);
    $('#SparePartType').val('null');
    //  $('#IsExpirydate').val(100);
    $('#LifespanOptionsId').val('null');
    $('#txtItemNo').removeAttr("disabled");
    $('#PartNo').removeAttr("disabled");
    $('#txtItemDescription').removeAttr("disabled");
    $('#PartDescription').removeAttr("disabled");
    $('#spnActionType').text('Add');
    $('#primaryID').val('');
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnDelete').hide();
    $("#grid").trigger('reloadGrid');
    $("#SparepartsFormId :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('.nav-tabs a:first').tab('show');
}