var ListModel = [];
var TotalPages = 0;

$(document).ready(function () {  
    $('#myPleaseWait').modal('show');
    var primaryId = $('#hdnPrimaryID').val();
    var ActionType = $('#hdnActionType').val();
    formInputValidation("TandCAttachmentForm");

    $("#TAndCAttachmentTab").click(function () {
        $('#FileUploadTable').empty();
        
        var primaryId = $('#hdnPrimaryID').val();
        var HiddenId = $('#hdnAttachId').val();
        if (primaryId == 0) {
            bootbox.alert(Messages.SAVE_FIRST_TABALERT);
            return false;
        }
        else {
            formInputValidation("TandCAttachmentForm");

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
                     $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                     $('#errorMsg').css('visibility', 'visible');
                 });
            }
        }
    });
        

    //  ************************************Save *************************************

    $('#btnEditAttachment,#btnSaveAttachment').click(function () {
        $('#btnSaveAttachment').attr('disabled', true);
        $('#btnEditAttachment').attr('disabled', true);
        $('#myPleaseWait').modal('show');

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var primaryId = $('#hdnARPrimaryID').val();
        var HiddenId = $('#hdnAttachId').val();

        $.each(ListModel, function (index, data) {            
                        data.DocumentId = $('#hdnDocumentId_' + index).val();
                        data.FileType = $('#FileTypeId_' + index).val();
                        data.DocumentTitle = $('#FileName_' + index).val();
                        data.IsDeleted = chkIsDeletedRowAttachment(index, $('#Isdeleted_' + index).is(":checked"));
                        data.AssetId = primaryId;
                        data.DocumentGuId = HiddenId;
        });

        var isFormValid = formInputValidation("TandCAttachmentForm", 'save');
        if (!isFormValid) {
            $("div.errormsgcenterattach").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsgattach').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSaveAttachment').attr('disabled', false);
            $('#btnEditAttachment').attr('disabled', false);
            return false;
        }

        var _index;
        $('#FileUploadTable tr').each(function () {
            _index = $(this).index();
        });       
        for (var i = 0; i <= _index; i++) {
            var choosefile = $('#hdnFileName_' + i).val();
            var filechoose = $('#Attachment_' + i).val();        
        }       

        var deletedCount = Enumerable.From(ListModel).Where(x=>x.IsDeleted).Count();
        var Isdeleteavailable = deletedCount > 0;

        if (Isdeleteavailable == false) {
            if (choosefile == "0" && filechoose == "") {
                bootbox.alert("Please Attach File!");
                $('#myPleaseWait').modal('hide');
                $('#btnSaveAttachment').attr('disabled', false);
                $('#btnEditAttachment').attr('disabled', false);
                return false;
            }
        }

        if (deletedCount == ListModel.length && TotalPages == 0) {
            bootbox.alert("Sorry!. You cannot delete all rows");
            $('#btnSaveAttachment').attr('disabled', false);
            $('#btnEditAttachment').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var Document = {
            AssetId: primaryId,
            DocumentGuId: HiddenId,
            FileUploadList: ListModel                     
        };
        var data = JSON.stringify(Document);

        
        
        
        if (Isdeleteavailable == true) {
            $('#myPleaseWait').modal('hide');
            bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (result) {
                if (result) {
                    SaveFileAttachMST();
                }
                else {
                    $('#myPleaseWait').modal('hide');
                    $('#btnSaveAttachment').attr('disabled', false);
                    $('#btnEditAttachment').attr('disabled', false);
                }
            });
        }
        else {
            SaveFileAttachMST();
        }

        function SaveFileAttachMST() {            
            URL = "/api/Document/Save"
            $.ajax({
                type: "POST",
                url: URL,
                //contentType: false,
                //processData: false,
                data: Document,
                success: function (response) {                
                    var getResult = JSON.parse(response);
                    $('#FileUploadTable').empty();
                    if (getResult != null && getResult.FileUploadList != null && getResult.FileUploadList.length > 0) {
                        BindGetByIdVal(getResult);
                    }
                    showMessage('File Upload', CURD_MESSAGE_STATUS.SS);
                    $("#top-notifications").modal('show'); 
                    $('#btnSaveAttachment').attr('disabled', false);
                    $('#btnEditAttachment').attr('disabled', false);
                    $('#myPleaseWait').modal('hide');                    
                },
                error: function (error) {
                    $('#myPleaseWait').modal('hide');
                    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                    $('#errorMsg').css('visibility', 'visible');
                }
            });
        }
    });


    //************************************* Back **************************************

    $('#btnAttachmentCancel').click(function () {
        window.location.href = "/bems/testingandcommissioning";
    });

});

function BindGetByIdVal(getResult) {
    var ActionType = $('#hdnActionType').val();
    ListModel = [];
    ListModel = getResult.FileUploadList;

    $('#FileUploadTable').empty();
    $.each(getResult.FileUploadList, function (ind, data) {
        AddNewRowfileupload();

        $('#hdnFileAttachId_' + ind).val(data.AttachmentId);
        $('#hdnDocumentId_' + ind).val(data.DocumentId);
        $('#FileTypeId_' + ind).val(data.FileType);
        $('#FileName_' + ind).val(data.DocumentTitle);
        $('#hdnFileName_' + ind).val(data.FileName);
        $('#DownloadFileName_' + ind).text(data.DocumentTitle);
        $("#imageDownLoad_" + ind).css('display', '');

        if (ActionType == "View") {
            $("#TandCAttachmentForm :input:not(:button)").prop("disabled", true);
            $('#FileTypeId_' + ind).prop("disabled", "disabled");
            $('#FileName_' + ind).prop("disabled", "disabled");
            $('#hdnFileName_' + ind).prop("disabled", "disabled");
            $('#Attachment_' + ind).prop("disabled", "disabled");
        }
    });
}