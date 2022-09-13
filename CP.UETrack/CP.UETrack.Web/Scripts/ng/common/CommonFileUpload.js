
var HiddenId = $('#hdnAttachId').val();
var ListModelAttachment = [];

$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    var primaryId = $('#primaryID').val();
    var ActionType = $('#ActionType,#hdnARActionType').val();

    //  **************************** Dropdown Load add indicator API*****************************

    $.get("/api/Document/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            window.FileLoadData = loadResult.FileTypeData
            AddNewRowfileupload();
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });

    //************************************ Grid Delete **************************

    $("#chk_FileUploadAttachment").change(function () {
        var Isdeletebool = this.checked;

        if (this.checked) {
            $('#FileUploadTable tr').map(function (i) {
                if ($("#Isdeleted1_" + i).prop("disabled")) {
                    $("#Isdeleted1_" + i).prop("checked", false);
                }
                else {
                    $("#Isdeleted1_" + i).prop("checked", true);
                    $('#FileTypeId_' + i).removeAttr('required');
                    $('#FileName_' + i).removeAttr('required');
                    $('#Attachment_' + i).removeAttr('required');
                    $('#FileTypeId_' + i).prop("required", false);
                    $('#FileName_' + i).prop("required", false);
                    $('#Attachment_' + i).prop("required", false);
                }
            });
        } else {
            $('#FileUploadTable tr').map(function (i) {
                $("#Isdeleted1_" + i).prop("checked", false);
            });
        }
    });



});

//********************************* Delete Valid ***********************************

function chkIsDeletedRowAttachment(i, delrec) {
    if (delrec == true) {
        $('#FileTypeId_' + i).prop("required", false);
        $('#FileName_' + i).prop("required", false);
        $('#Attachment_' + i).prop("required", false);
        return true;
    }
    else {
        return false;
    }
}

function DisplayAttachmentError() {
    $('#errorMsg1').css('visibility', 'visible');
    $('#myPleaseWait').modal('hide');
    $('#btnSaveAttachment').attr('disabled', false);
    $('#btnEditAttachment').attr('disabled', false);
}

//  ****************************** AddNewRow *************************************

//function AddNewRowfileupload() {

//    var inputpar = {
//        inlineHTML: BindNewRowHTML(),
//        IdPlaceholderused: "maxindexval",
//        TargetId: "#FileUploadTable",
//        TargetElement: ["tr"]
//    }
//    AddNewRowToDataGrid(inputpar);
//    $('#chk_FileUploadAttachment').prop("checked", false);
//    $('#FileUploadTable tr:last td:first input').focus();

//    var rowCount = $('#FileUploadTable tr:last').index();
//    $.each(window.FileLoadData, function (index, value) {
//        $('#FileTypeId_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
//    });
//}

//function BindNewRowHTML() {
//    return ' <tr> <td width="3%" title="Select"> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" name="FileUploadCheckboxes" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(FileUploadTable,chk_FileUploadAttachment)"> </label> </div></td><td width="20%" title="File Type"> <input type="hidden" id="hdnDocumentId_maxindexval" value=0> <input type="hidden" id="hdnFileAttachId_maxindexval" value=0> <div> <select id="FileTypeId_maxindexval" class="form-control" required> <option value="null">Select</option> </select> </div></td><td width="30%" style="text-align: center;"> <div> <input id="FileName_maxindexval" type="text" maxlength="100" class="form-control" required> </div></td><td width="27%" style="text-align: center;" title="Choose File"> <div> <input type="hidden" id="hdnFileName_maxindexval" value=0> <input id="Attachment_maxindexval" onchange="getFileUploadDetails(this, maxindexval)" type="file" class="form-control" accept="application/pdf" required> </div></td><td width="20%" style="text-align: center;"> <div class="text-center"> <input type="hidden" id="hdnDownload_maxindexval" value=0> <a class="glyphicon glyphicon-download-alt" id="imageDownLoad_maxindexval" onclick="downloadfiles(maxindexval)" style="visibility: hidden;"></a> &nbsp; <a href="#" id="imageDownLoad_maxindexval" onclick="downloadfiles(maxindexval)"><span id="DownloadFileName_maxindexval"></span></a> </div></td></tr> ';

//}

//*********************** Empty Row Validation **************************************

function AddNewRowfile() {
    $("div.errormsgcenter1").text("");
    $('#errorMsg1').css('visibility', 'hidden');
    var rowCount = $('#FileUploadTable tr:last').index();
    var filecat = $('#FileTypeId_' + rowCount).val();
    var filecatname = $('#FileName_' + rowCount).val();
    var choosefile = $('#hdnFileName_' + rowCount).val();
    var filechoose = $('#Attachment_' + rowCount).val();
    if (rowCount < 0)
        AddNewRowfileupload();
    else if (rowCount >= "0" && filecat == "null") {
        bootbox.alert("All fields are mandatory. Please enter details in existing row");
    }
    else if (rowCount >= "0" && filecatname == "") {
        bootbox.alert("All fields are mandatory. Please enter details in existing row");
    }
    else if (rowCount >= "0" && choosefile == "0" && filechoose == "") {
        bootbox.alert("Please Attach File!");
    }
    else {
        AddNewRowfileupload();

    }
}

//*********************** Empty Row AddNewRowIndicator  Validation**************************************

//function AddNewRowIndicator() {
//    $("div.errormsgcenter1").text("");
//    $('#errorMsg1').css('visibility', 'hidden');
//    var rowCount = $('#FileUploadTable tr:last').index();
//    var filecat = $('#FileTypeId_' + rowCount).val();
//    var filecatname = $('#FileName_' + rowCount).val();
//    var choosefile = $('#hdnFileName_' + rowCount).val();
//    var filechoose = $('#Attachment_' + rowCount).val();
//    if (rowCount < 0)
//        AddNewRowfileupload();
//    else if (rowCount >= "0" && filecat == "null") {
//        bootbox.alert("All fields are mandatory. Please enter details in existing row");
//    }
//    else if (rowCount >= "0" && filecatname == "") {
//        bootbox.alert("All fields are mandatory. Please enter details in existing row");
//    }
//    //else if (rowCount >= "0" && choosefile == "0" && filechoose == "") {
//    //    bootbox.alert("Please Attach File!");
//    //}
//    else {
//        AddNewRowfileupload();
//    }
//}


//*********************************** File Attachment ******************************************


function getFileUploadDetails(e, index) {
    var _index;
    $('#FileUploadTable tr').each(function () {
        _index = $(this).index();
    });
    var FileCatName = $('#FileName_' + index).val();
    var DocumentId = $('#hdnDocumentId_' + index).val();
    var FileCatType = $('#FileTypeId_' + index).val();

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

        var FileappType = ["application/pdf", "pdf", "application/msword", "doc", "docx", "application/vnd.ms-excel", "xls", "xlsx", "application/vnd.ms-powerpoint", "ppt", "pptx", "csv", "image/jpg", "image/jpeg", "image/png", "image/gif", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"];

        //var FileMaxSize = 8388608;  //  - 8Mb;
        var FileMaxSize = 4194304;  //  - 4Mb;

        for (var i = 0; i < FileappType.length; i++) {
            if (filetype == FileappType[i]) {
                filetype = true;                
            }            
        }

        if (filetype == true) {
       // if (filetype == "application/pdf") {
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

                        if (DocumentId == 0 || DocumentId == null) {

                            var validcount = Enumerable.From(ListModelAttachment).Where(x=>x.index == index).Count();
                            if (validcount > 0) {
                                ListModelAttachment[index].DocumentTitle = FileCatName;
                                ListModelAttachment[index].DocumentExtension = filetype;
                                ListModelAttachment[index].FileType = FileCatType;
                                ListModelAttachment[index].ContentType = extension;
                                ListModelAttachment[index].contentAsBase64String = base64String;
                            }
                            else {
                                var ListModelAttachmentData = [{
                                    DocumentId: 0,
                                    GuId: '',
                                    DocumentNo: null,
                                    DocumentTitle: FileCatName,
                                    DocumentDescription: null,
                                    DocumentCategory: null,
                                    DocumentCategoryOthers: null,
                                    DocumentExtension: filetype,
                                    MajorVersion: null,
                                    MinorVersion: null,
                                    FileType: FileCatType,
                                    FilePath: null,
                                    FileName: null,
                                    Remarks: null,
                                    DocumentGuId: HiddenId,
                                    ContentType: extension,
                                    contentAsBase64String: base64String,
                                    index: index
                                }];
                                ListModelAttachment.push.apply(ListModelAttachment, ListModelAttachmentData);
                            }

                        }
                        else {
                            if (ListModelAttachment[index].DocumentId == DocumentId) {
                                ListModelAttachment[index].DocumentTitle = FileCatName;
                                ListModelAttachment[index].DocumentExtension = filetype;
                                ListModelAttachment[index].FileType = FileCatType;
                                ListModelAttachment[index].ContentType = extension;
                                ListModelAttachment[index].contentAsBase64String = base64String;
                            }
                        }

                    }
                };
                reader.readAsArrayBuffer(blob);

            }
            else {
                bootbox.alert("File size must be less than 4 MB.");
                $("#Attachment_" + _index).val("");
            }
        }
        else {
             //bootbox.alert("Please upload Pdf File.");
            bootbox.alert("It support doument type file only.");
            $("#Attachment_" + _index).val("");
        }

    }
}


//*************************************** File Download ***********************************************

function downloadfiles(index) {
    var DocumentId = $('#hdnDocumentId_' + index).val();
    if (ListModelAttachment[index].DocumentId == DocumentId) {
        var FileCatName = ListModelAttachment[index].DocumentTitle;
        var DocumentExtension = ListModelAttachment[index].DocumentExtension;
        var FilePath = ListModelAttachment[index].FilePath;
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



