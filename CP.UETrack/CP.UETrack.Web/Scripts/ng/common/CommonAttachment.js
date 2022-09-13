var ListModelAttachment = [];
var TotalPages = 0;
var primaryId;

$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    //  primaryId = $('#primaryID').val();
    var ActionType = $('#ActionType').val();
    //formInputValidation("CommonAttachment");
    $("#AttachmentTab").click(function () {
        $('#FileUploadTable').empty();
        $("div.errorMsgcenterAttachment").text("");
        $('#errorMsgAttachment').css('visibility', 'hidden');
        var AssetPrimaryid = $('#hdnARPrimaryID').val();
        if (AssetPrimaryid == "" || AssetPrimaryid == null || AssetPrimaryid == undefined || AssetPrimaryid == 0) {
            primaryId = $('#primaryID').val();
        }
        else {
            primaryId = AssetPrimaryid;
        }

        var HiddenId = $('#hdnAttachId').val();
        if (primaryId == 0 || primaryId == null || primaryId == undefined || primaryId == "") {
            bootbox.alert(Messages.SAVE_FIRST_TABALERT);
            return false;
        }
        else {
            formInputValidation("CommonAttachment");

            if (HiddenId != null && HiddenId != "0" && HiddenId != "" && HiddenId != 0) {

                $.get("/api/Document/getAttachmentDetails/" + HiddenId)
                  .done(function (result) {

                      var getResult = JSON.parse(result);
                      $('#FileUploadTable').empty();
                      if (getResult != null && getResult.FileUploadList != null && getResult.FileUploadList.length > 0) {

                          BindGetByIdVal(getResult);

                      }
                      else {
                          AddNewRowfileupload();

                      }
                      $('#myPleaseWait').modal('hide');
                  })
                 .fail(function () {
                     $('#myPleaseWait').modal('hide');
                     $("div.errorMsgcenterAttachment").text(Messages.COMMON_FAILURE_MESSAGE);
                     $('#errorMsgAttachment').css('visibility', 'visible');
                 });
            }
            else {
                AddNewRowfileupload();
            }
        }
    });
});

//  ************************************Save *************************************


$('#chk_FileUploadAttachment').change(function () {
    var a = $(this).is(':checked');
    var _indexx;
    $('#FileUploadTable tr').each(function () {
        _indexx = $(this).index();
    });

    if (a == true) {
        for (var i = 0; i <= _indexx; i++) {
            $('#FileTypeId_' + i).prop("required", false);
        }
    }
    else if (a == false) {
        for (var i = 0; i <= _indexx; i++) {
            $('#FileTypeId_' + i).prop("required", true);
        }
    }
});


$("#btnEditAttachment,.btnEditAttachment, #btnSaveAttachment").unbind('click');
$('#btnEditAttachment,.btnEditAttachment,#btnSaveAttachment').click(function () {
    $('#btnSaveAttachment').attr('disabled', true);
    $('#btnEditAttachment').attr('disabled', true);
    $('.btnEditAttachment').attr('disabled', true);
    $('#myPleaseWait').modal('show');


    $("div.errorMsgcenterAttachment").text("");
    $('#errorMsgAttachment').css('visibility', 'hidden');

    var primaryId = $('#primaryID').val();
    var HiddenId = $('#hdnAttachId').val();

    var isFormValid = formInputValidation("CommonAttachment", 'save');
    if (!isFormValid) {
        $("div.errorMsgcenterAttachment").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsgAttachment').css('visibility', 'visible');

        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        $('#btnSaveAttachment').attr('disabled', false);
        $('#btnEditAttachment').attr('disabled', false);
        $('.btnEditAttachment').attr('disabled', false);
        return false;
    }
    
    $.each(ListModelAttachment, function (index, data) {
        data.DocumentId = $('#hdnDocumentId_' + index).val();
        data.FileType = $('#FileTypeId_' + index).val();
        data.DocumentTitle = $('#FileName_' + index).val();
        data.IsDeleted = chkIsDeletedRowAttachment(index, $('#Isdeleted1_' + index).is(":checked"));
        data.AssetId = primaryId;
        data.DocumentGuId = HiddenId;
    });

    var _index;
    $('#FileUploadTable tr').each(function () {
        _index = $(this).index();
    });
    for (var i = 0; i <= _index; i++) {
        var choosefile = $('#hdnFileName_' + i).val();
        var filechoose = $('#Attachment_' + i).val();

        var Isdeleted = $('#Isdeleted1_' + i).is(":checked");
        if (Isdeleted == false) {
            if (choosefile == "0" && filechoose == "") {
                bootbox.alert("Please Attach File!");
                $('#myPleaseWait').modal('hide');
                $('#btnSaveAttachment').attr('disabled', false);
                $('#btnEditAttachment').attr('disabled', false);
                $('.btnEditAttachment').attr('disabled', false);
                return false;
            }
        }
    }
    var deletedCount = Enumerable.From(ListModelAttachment).Where(x=>x.IsDeleted).Count();
    var Isdeleteavailable = deletedCount > 0;
    //if (deletedCount == ListModelAttachment.length) {      
    //    bootbox.alert("Sorry!. You cannot delete all rows");
    //    $('#btnSaveAttachment').attr('disabled', false);
    //    $('#btnEditAttachment').attr('disabled', false);
    //    $('#myPleaseWait').modal('hide');
    //    return false;
    //}
    
    if (ListModelAttachment.length == 0)
    {
        var _index;
        $('#FileUploadTable tr').each(function () {
            _index = $(this).index();
        });
        for (var i = 0; i <= _index; i++) {         
            var FileName = $('#FileName_' + i).val();
            var FileType = $('#FileTypeId_' + i).val();
            var choosefile = $('#hdnFileName_' + i).val();
            var filechoose = $('#Attachment_' + i).val();
           // var Isdeleted = $('#Isdeleted_' + i).is(":checked");
            if ((FileName == "" || FileName == undefined || FileName == null) || (FileType == "" || FileType == undefined || FileType == "null") ||
                (choosefile == "0" || choosefile == undefined || choosefile == null) || (filechoose == "0" || filechoose == "" || filechoose == null)) {
                    bootbox.alert("Empty Record cannot be Deleted");
                    $('#myPleaseWait').modal('hide');
                    $('#btnSaveAttachment').attr('disabled', false);
                $('#btnEditAttachment').attr('disabled', false);
                $('.btnEditAttachment').attr('disabled', false);
                    return false;
                }
            
        }
    }
    var Document = {
        AssetId: primaryId,
        DocumentGuId: HiddenId,
        FileUploadList: ListModelAttachment
    };
    var data = JSON.stringify(Document);

    var isFormValid = formInputValidation("CommonAttachment", 'save');
    if (!isFormValid) {
        $("div.errorMsgcenterAttachment").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsgAttachment').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnSaveAttachment').attr('disabled', false);
        $('#btnEditAttachment').attr('disabled', false);
        $('.btnEditAttachment').attr('disabled', false);
        return false;
    }



    $('#FileUploadTable tr').each(function () {
        _index = $(this).index();
    });
    var Isdeleted = $('#Isdeleted1_' + _index).is(":checked");
    if (Isdeleted == true) {
        $('#myPleaseWait').modal('hide');
        bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (result) {
            if (result) {
                SaveFileAttachMST();
            }
            else {
                $('#myPleaseWait').modal('hide');
                $('#btnSaveAttachment').attr('disabled', false);
                $('#btnEditAttachment').attr('disabled', false);
                $('.btnEditAttachment').attr('disabled', false);
            }
        });
    }
    else {
        SaveFileAttachMST();
    }

    function SaveFileAttachMST() {
        ApiUrl = "/api/Document/Save"
        $.ajax({
            type: "POST",
            url: ApiUrl,
            //contentType: false,
            //processData: false,
            data: Document,
            success: function (response) {
                var getResult = JSON.parse(response);
                $('#FileUploadTable').empty();
                if (getResult != null && getResult.FileUploadList != null && getResult.FileUploadList.length > 0) {
                    BindGetByIdVal(getResult);
                }
                else {
                    $('#FileUploadTable').empty();
                    ListModelAttachment = [];
                    AddNewRowfileupload();
                }
                showMessage('File Upload', CURD_MESSAGE_STATUS.SS);
                $("#top-notifications").modal('show');
                $('#btnSaveAttachment').attr('disabled', false);
                $('#btnEditAttachment').attr('disabled', false);
                $('.btnEditAttachment').attr('disabled', false);
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
                $("div.errorMsgcenterAttachment").text(errorMessage);
                $('#errorMsgAttachment').css('visibility', 'visible');
                $('#btnSaveAttachment').attr('disabled', false);
                $('#btnEditAttachment').attr('disabled', false);
                $('.btnEditAttachment').attr('disabled', false);
            
            }
        });
    }
});


//************************************* Back **************************************

$('#btnAttachmentCancel').click(function () {
    $('input[type="text"], textarea').val('');
    $('#FileUploadTable').empty();
    AddNewRowfileupload();
    $('.nav-tabs a:first').tab('show');
    // window.location.href = "/BER/BER1Application";
});

function AddNewRowfileupload() {

    var inputpar = {
        inlineHTML: BindNewRowHTML(),
        IdPlaceholderused: "maxindexval",
        TargetId: "#FileUploadTable",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    formInputValidation("CommonAttachment");
    $('#chk_FileUploadAttachment').prop("checked", false);
    $('#FileUploadTable tr:last td:first input').focus();

    var rowCount = $('#FileUploadTable tr:last').index();
    $.each(window.FileLoadData, function (index, value) {
        $('#FileTypeId_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });



}

function BindNewRowHTML() {
    return ' <tr> <td width="3%" title="Select"> <div class="checkbox text-center"> <label for="checkboxes-0"> ' +
            '<input type="checkbox" name="FileUploadCheckboxes" id="Isdeleted1_maxindexval" onchange="IsDeleteCheckAllAttach(FileUploadTable,chk_FileUploadAttachment)"> </label> </div></td><td width="20%" title="File Type"> ' +
            ' <input type="hidden" id="hdnDocumentId_maxindexval" value=0> <input type="hidden" id="hdnFileAttachId_maxindexval" value=0> <div> ' +
            '<select id="FileTypeId_maxindexval" class="form-control" required> <option value="null">Select</option> </select> </div></td><td width="30%" style="text-align: center;"> <div> ' +
             '<input id="FileName_maxindexval" type="text" class="form-control" maxlength="50" required> </div></td><td width="27%" style="text-align: center;" title="Choose File"> <div>' +
            ' <input type="hidden" id="hdnFileName_maxindexval" value=0> ' +
             '<input id="Attachment_maxindexval" onchange="getFileUploadDetails(this, maxindexval)" type="file" class="form-control" accept=".xls,.xlsx,.doc,.docx,.ppt,.pptx,.csv,application/pdf, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/vnd.ms-excel,image/*" required> </div></td><td width="20%" style="text-align: center;"> <div class="text-center"> ' +
            '<input type="hidden" id="hdnDownload_maxindexval" value=0> ' +
            ' <a class="glyphicon glyphicon-download-alt" id="imageDownLoad_maxindexval" onclick="downloadfiles(maxindexval)" style="visibility: hidden;"></a> &nbsp; <a href="#" id="imageDownLoad_maxindexval" onclick="downloadfiles(maxindexval)"><span id="DownloadFileName_maxindexval"></span></a> </div></td></tr> ';

}
function BindGetByIdVal(getResult) {
    var ActionType = $('#ActionType').val();
    ListModelAttachment = [];
    ListModelAttachment = getResult.FileUploadList;

    $('#FileUploadTable').empty();
    $.each(getResult.FileUploadList, function (ind, data) {
        AddNewRowfileupload();

        $('#hdnFileAttachId_' + ind).val(data.AttachmentId);
        $('#hdnDocumentId_' + ind).val(data.DocumentId);
        $('#FileTypeId_' + ind).val(data.FileType);
        $('#FileName_' + ind).val(data.DocumentTitle);
        $('#hdnFileName_' + ind).val(data.FileName);
        $('#DownloadFileName_' + ind).text(data.DocumentTitle);
        $("#imageDownLoad_" + ind).css('visibility', 'visible');

        if (ActionType == "View") {
            $("#berattachmentformId :input:not(:button)").prop("disabled", true);
            $('#FileTypeId_' + ind).prop("disabled", "disabled");
            $('#FileName_' + ind).prop("disabled", "disabled");
            $('#hdnFileName_' + ind).prop("disabled", "disabled");
            $('#Attachment_' + ind).prop("disabled", "disabled");
        }
    });
}

/// To check header checkbox
function IsDeleteCheckAllAttach(tbodyId, IsDeleteHeaderId) {
    var count = 0;
    var Isdeleted_ = [];
    tbodyId = '#' + tbodyId.id + ' tr';
    IsDeleteHeaderId = "#" + IsDeleteHeaderId.id;

    $(tbodyId).map(function (index, value) {
        //if ($("#Isdeleted_" + index).prop("disabled")) {
        //    count++;
        //}
        var Isdelete = $("#Isdeleted1_" + index).is(":checked");
        if (Isdelete)
            Isdeleted_.push(Isdelete);
    });

    var rowlen = ($(tbodyId).length) - (count)

    if (rowlen == Isdeleted_.length)
        $(IsDeleteHeaderId).prop("checked", true);
    else
        $(IsDeleteHeaderId).prop("checked", false);
    var _indexx;
    $('#FileUploadTable tr').each(function () {
        _indexx = $(this).index();
    });
    CheckRequired(_indexx);
}

//*** To make reqired field based on checkbox clicked
function CheckRequired(currentindex) {

    if ($('#Isdeleted1_' + currentindex).is(":checked")) {
        $('#FileTypeId_' + currentindex).removeAttr('required');
        $('#FileName_' + currentindex).removeAttr('required');
        $('#Attachment_' + currentindex).removeAttr('required');

        $('#FileTypeId_' + currentindex).parent().removeClass('has-error');
        $('#FileName_' + currentindex).parent().removeClass('has-error');
        $('#Attachment_' + currentindex).parent().removeClass('has-error')
    }
    else {
        $('#FileTypeId_' + currentindex).attr('required', true);
        $('#FileName_' + currentindex).attr('required', true);
        $('#Attachment_' + currentindex).prop("required", true);
    }


}

//function IsDeleteCheckAllAttach(tbodyId, IsDeleteHeaderId) {

//    var count = 0;
//    var Isdeleted_ = [];
//    tbodyId = '#' + tbodyId.id + ' tr';
//    IsDeleteHeaderId = "#" + IsDeleteHeaderId.id;

//    $(tbodyId).map(function (index, value) {
//        if ($("#Isdeleted1_" + index).prop("disabled")) {
//            count++;
//        }
//        var Isdelete = $("#Isdeleted1_" + index).is(":checked");
//        if (Isdelete)
//            Isdeleted_.push(Isdelete);
//    });

//    var rowlen = ($(tbodyId).length) - (count)

//    if (rowlen == Isdeleted_.length)
//        $(IsDeleteHeaderId).prop("checked", true);
//    else
//        $(IsDeleteHeaderId).prop("checked", false);

//    //if($("#Isdeleted1_" + index).is(":checked") == false){
//    //    var _index;
//    //    $('#FileUploadTable tr').each(function () {
//    //        _index = $(this).index();
//    //    });
//    //    for (var i = 0; i <= _index; i++) {
//    //        $('#FileTypeId_' + i).prop("required", true);
//    //    }
//    //}
//}

var a = $('#chk_FileUploadAttachment').is(":checked");
function IsDeleteCheckAllAtt(i, a) {
    var _indexx;
    $('#FileUploadTable tr').each(function () {
        _indexx = $(this).index();
    });

    if(a == true){
        for (var i = 0; i <= _indexx; i++) {
            $('#FileTypeId_' + i).prop("required", false);
        }
    }
    else if(a == false){
        $('#FileTypeId_' + i).prop("required", true);
    }
}