
//clicking on 2nd tab restrict

$(".nav-tabs").click(function () {
    var primaryId = $('#primaryID').val();
    if (primaryId == 0 || primaryId == null || primaryId == undefined || primaryId == "" || primaryId == "0") {
        bootbox.alert(Messages.SAVE_FIRST_TABALERT);
        return false;
    }
});

$("#addAttachment").click(function () {
    rowNum2 = rowNum2 + 1;
    addAttachmentRow(rowNum2);

});

$("#deleteAttachment").click(function () {

    bootbox.confirm({
        message: 'Do you want to delete a row?',
        buttons: {
            confirm: {
                label: 'Yes',
                className: 'btn-primary'
            },
            cancel: {
                label: 'No',
                className: 'btn-default'
            }
        },
        callback: function (result) {
            if (result) {
                if ($("input[type='checkbox']:checked").length > 0) {
                    $("#tbodyAttachments tr").find('input[name="isDelete"]').each(function () {
                        if ($(this).is(":checked")) {
                            if ($(this).closest("tr").find("[id^=hdnAttachmentId]").val() == 0) {
                                $(this).closest("tr").remove();
                            }
                        }
                    });
                }
                else
                    bootbox.alert("Please select atleast one row !");
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        }
    });
});

$("#btnSaveAttachment").click(function () {

    $("div.errormsgcenter").text("");    
    $('#errorMsg1').css('visibility', 'hidden');
    var isFormValid = formInputValidation("formAttachment", 'save');

    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg1').css('visibility', 'visible');
        return false;
    }

    var isValidAttachments = true;
    $('#tbodyAttachments tr').each(function () {
        if ($(this).find("[id^=icon]")[0] == undefined) {
            isValidAttachments = false;
            return;
        }
    });

    if (isValidAttachments == false) {
        $("div.errormsgcenter").text(' Please select the file to proceed. ');
        $('#errorMsg1').css('visibility', 'visible');
        return false;
    }

    var primaryId = 0;
    if ($("#primaryID").val() != null) {
        primaryId = $("#primaryID").val();
    }
        
    var objAttachmentList = [];    

    $('#tbodyAttachments  tr').each(function () {

        var AttachmentName = "";

        if ($(this).find("[id^=txtAttachment]")[0].files.length != 0) {
            AttachmentName = $(this).find("[id^=txtAttachment]")[0].files[0].name;
        }

        var att = {
            "ScreenName": ScreenName,
            "primaryId": primaryId,
            "AttachmentId": $(this).find("[id^=hdnAttachmentId]")[0].value,
            "FileType": $(this).find("[id^=ddlFileType]")[0].value,
            "FileName": $(this).find("[id^=txtFileName]")[0].value,
            "AttachmentName": AttachmentName,
            "FilePath" : $(this).find("[id^=icon]")[0].pathname,
            "isDeleted" : $(this).find('input:checkbox[id^=isDelete]').prop("checked")
        };
               
        objAttachmentList.push(att);
    });

    $.ajax({
        url: "/api/Common/AttachmentSave",
        type: 'POST',
        data: JSON.stringify(objAttachmentList),
        dataType: 'json',
        contentType: 'application/json',
        crossDomain: true,
        cache: false,
        success: function (response) {

            $("div.errormsgcenter").text("");
            $('#errorMsg1').css('visibility', 'hidden');

            var result = JSON.parse(response);
            showMessage('Attachmentment', CURD_MESSAGE_STATUS.SS);
            fillAttachment(result);
        },
        fail: function (response) {
            var errorMessage = "";
            if (response.status == 400) {
                errorMessage = response.responseJSON;
            }
            else {
                errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
            }
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg1').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
        }

    });
});

$('body').on('change', '.fileAttachment', function (e) {

    var id = event.target.id.slice(13, 15);
    var fileUpload = $(this).get(0);
    var files = fileUpload.files;

    var fileData = new FormData();

    var d = new Date();
    var day = d.getDate();
    var month = d.getMonth() + 1;
    var year = d.getFullYear();
    if (day < 10) {
        day = "0" + day;
    }
    if (month < 10) {
        month = "0" + month;
    }
    var fileName = filePrefix + year + month + day + "_" + Math.floor(Math.random() * 100000);

    fileData.append(fileName, files[0]);

    $.ajax({
        url: '/api/Common/FileUpload',
        type: "POST",
        contentType: false, // Not to set any content header  
        processData: false, // Not to process data  
        data: fileData,
        success: function (result) {

            if (result == "File Uploaded Successfully!") {

                $('#icon' + id).remove();
                $('#cell' + id).append(
                    '<a href="" style="color:cornflowerblue" download="" id="icon' + id + '"><span style="text-align:center"><i class="fa fa-download" style="font-size:15px;"></i></span> </a>'
                );

                var testFileName = $('#txtAttachment' + id).val();
                var extn = testFileName.split('.').pop();

                $("#icon" + id).attr("href", "../uploads/attachments/" + fileName + "." + extn);
            }
        },
        error: function (err) {

            var errorMessage = "";
            if (err.status == 400) {
                errorMessage = response.responseJSON;
            }
            else {
                errorMessage = Messages.COMMON_FAILURE_MESSAGE(err);
            }
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');
            $('#btnSave').attr('disabled', false);
        }
    });

});

function addAttachmentRow(num) {

    var CheckBox = '<td style="text-align:center"><input type="checkbox" id="isDelete' + num + '" name="isDelete" />	<input type="hidden" id="hdnAttachmentId' + num + '" value="0" /></td>';
    var FileType = '<td id="filetypee"> <select type="text" required class="form-control" id="ddlFileType' + num + '" autocomplete="off" name="FileType" maxlength="25" >    ' + FileTypeValues + '</td>';
    var FileName = '<td id="fname"><input type="text" required class="form-control" id="txtFileName' + num + '" autocomplete="off" name="FileName" maxlength="25"  /></td>';
    var Attachment = '<td id="attachment"> <input type="file" id="txtAttachment' + num + '" name="fileAttachment" required class="form-control fileAttachment" /></td>';
    var Download = '<td style="text-align:center" id="cell' + num + '">  </td>';

    $("#tbodyAttachments").append('<tr>' + CheckBox + FileType + FileName + Attachment + Download + '</tr>');
}

function fillAttachment(result) {

    $('#tbodyAttachments').html('');
    rowNum2 = 1;

    if (result != null) {

        $('#table_data').hide();

        for (var k = 0; k < result.length; k++) {

            addAttachmentRow(rowNum2);

            $('#hdnAttachmentId' + rowNum2).val(result[k].AttachmentId);
            $('#ddlFileType' + rowNum2).val(result[k].FileType);
            $('#txtFileName' + rowNum2).val(result[k].FileName);                     

            var FilePath = result[k].FilePath
            $('#cell' + rowNum2).append(
                '<a href="' + FilePath + '" style="color:cornflowerblue" download="" id="icon' + rowNum2 + '"><span style="text-align:center"><i class="fa fa-download" style="font-size:15px;"></i></span> </a>'
            );

            rowNum2 += 1;
        }
    }
    else {
        addAttachmentRow(1);
    }

}

