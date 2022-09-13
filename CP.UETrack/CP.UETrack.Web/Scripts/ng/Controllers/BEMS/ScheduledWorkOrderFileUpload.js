function FileattachmentTab(event, value) {

}

var ListModel = [];

$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    //  **************************** Dropdown Load *****************************

    $.get("/api/Document/Load")

        .done(function (result) {
            var loadResult = JSON.parse(result);
            window.FileLoadData = loadResult.FileTypeData
            AddNewRowfileupload();

            var primaryId = $('#primaryID').val();
            //  var primaryId = 27;
            if (primaryId != null && primaryId != "0") {
                $.get("/api/Document/Get/" + primaryId)
                  .done(function (result) {
                      var getResult = JSON.parse(result);
                      //$('#primaryID').val(result.FileUploadList.DocumentId);
                      $("#FileUploadTable").empty();
                      $.each(getResult.FileUploadList, function (index, value) {

                        //  $('#primaryID').val(getResult.FileUploadList.DocumentId);
                          $('#FileTypeId_' + index + ' option[value="' + getResult.FileUploadList[index].FileType + '"]').prop('selected', true);
                          $("#FileName_" + index).val(getResult.FileUploadList[index].FileName).prop("disabled", "disabled");
                      })

                      $('#myPleaseWait').modal('hide');
                  })
                 .fail(function () {
                     $('#myPleaseWait').modal('hide');
                     $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE).css('visibility', 'visible');
                     //$('#errorMsg').css('visibility', 'visible');
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



    //  ************************************Save *************************************

    ////  $("#btnfileSave, #btnEdit").click(function () {
    //$("#btnfileSave").click(function () {
    //    $('#btnlogin').attr('disabled', true);
    //    $('#myPleaseWait').modal('show');

    //    $("div.errormsgcenter").text("");
    //    $('#errorMsg').css('visibility', 'hidden');

    //    $('#FileUploadTable tr').each(function () {
    //        _index = $(this).index();
    //    });

    //    var status = false;
    //    alert(' hell ');
    //    if ($('#Active_' + index).is(":checked")) {


    //        status = false;
    //    }
    //    else {
    //        status = true;
    //    }

    //    var Document = { FileUploadList: ListModel };
    //    var data = JSON.stringify(Document);

    //    alert(data);
    //    URL = "/api/Document/UploadFile"
    //    $.ajax({
    //        type: "POST",
    //        url: URL,
    //        //contentType: false,
    //        //processData: false,
    //        data: Document,
    //        success: function () {
    //            showMessage('File Upload', CURD_MESSAGE_STATUS.SS);
    //            $("#top-notifications").modal('show');
    //            setTimeout(function () {
    //                $("#top-notifications").modal('hide');
    //            }, 5000);

    //            $('#btnfileSave').attr('disabled', false);
    //            $('#myPleaseWait').modal('hide');
    //            //console.log();
    //        },
    //        error: function (error) {
    //            $('#myPleaseWait').modal('hide');
    //            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
    //            $('#errorMsg').css('visibility', 'visible');
    //        }
    //    });
    //});



    //********************************* Download File *************************************

    //function getById(primaryId) {
    //    $.get("/api/Document/get/" + primaryId)
    //            .done(function (result) {
    //                var result = JSON.parse(result);

    //                $('#primaryID').val(result.FileUploadList[0].DocumentId);



    //              //  $("#IndicatorMstTbl").empty();
    //                $.each(result.FileUploadList, function (index, value) {
    //                    AddNewRowfile();
    //                    $("#hdnDocumentId_" + index).val(result.FileUploadList[index].DocumentId);
    //                    $("#FileName_" + index).val(result.FileUploadList[index].FileName).prop("disabled", "disabled");
    //                    $('#FileTypeId_' + index + ' option[value="' + result.FileUploadList[index].FileType + '"]').prop('selected', true);

    //                });

    //                $('#myPleaseWait').modal('hide');
    //            })
    //            .fail(function () {
    //                $('#myPleaseWait').modal('hide');
    //                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
    //                $('#errorMsg').css('visibility', 'visible');
    //            });
    //}

    $("#btnfileCancel").click(function () {
        window.location.href = "/BEMS/ScheduledWorkOrder";
    });


});

//  ****************************** AddNewRow **********************************************


function AddNewRowfileupload() {
    
    var inputpar = {
        inlineHTML: ' <tr> ' +
                      '<td width="3%" title="Select"> <div class="checkbox text-center"> <label for="checkboxes-0"> ' +
                      '<input type="checkbox" name="ActiveCheckboxs" id="Active_maxindexval"> </label> </div></td>' +
                      '<td width="22%" title="File Type"> ' +
                      '<input type="hidden" id="hdnDocumentId_maxindexval" value=0> ' +
                      '<select id="FileTypeId_maxindexval" class="form-control" required> <option value="null">Select</option> </select></div></td>' +
                      '<td width="25%" style="text-align: center;"> <div> ' +
                      '<input id="FileName_maxindexval" type="text" class="form-control" required> </div></td>' +

                      '<td width="25%" style="text-align: center;" title="Choose File"> <div> <input type="hidden" id="hdnFileName_maxindexval" >' +
                      '<input id="Attachment_maxindexval" onchange="getFileDetails(this, maxindexval)" type="file" class="form-control" required> </div></td>' +

                     '<td width="25%" style="text-align: center;"> <div class="text-center"> ' +
                     '<input type="hidden" id="hdnDownload_maxindexval" value=0> ' +
                     '<a class="glyphicon glyphicon-download-alt" id="imageDownLoad_maxindexval" onclick="downloadfiles(maxindexval)"></a> &nbsp;' +
                      '<a href="#" id="imageDownLoad_maxindexval" onclick="downloadfiles(maxindexval)" >Download file</a> </div></td></tr> ',

        IdPlaceholderused: "maxindexval",
        TargetId: "#FileUploadTable",
        TargetElement: ["tr"]

    }
    AddNewRowToDataGrid(inputpar);

    var rowCount = $('#FileUploadTable tr:last').index();
    $.each(window.FileLoadData, function (index, value) {
        $('#FileTypeId_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
}


//*********************** Empty Row Validation **************************************

function AddNewRowfile() {
    $("div.errormsgcenter1").text("");
    $('#errorMsg1').css('visibility', 'hidden');
    var rowCount = $('#FileUploadTable tr:last').index();
    var filecat = $('#FileTypeId_' + rowCount).val();
    if (rowCount < 0)
        AddNewRowfileupload();
    else if (rowCount >= "0" && filecat == "") {
        bootbox.alert("All fields are mandatory. Please enter details in existing row");
        //  $("div.errormsgcenter1").text();
        // $('#errorMsg1').css('visibility', 'visible');
    }
    else {
        AddNewRowfileupload();
    }
}


//************************ File Attachment ******************************************


function getFileDetails(e, index) {
   // ListModel = [];
    var _index;
    $('#FileUploadTable tr').each(function () {
        _index = $(this).index();
    });
    var FileName = $('#FileName_' + index).val();
    var DocumentId = $('#hdnDocumentId_' + index).val();
    var FileType = $('#FileTypeId_' + index).val();

    for (var i = 0; i < e.files.length; i++) {
        var f = e.files[i];
        var file = f;
        var blob = e.files[i].slice();
        var filetype = file.type;
        var filesize = file.size;
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

            //if (evt.target.readyState == FileReader.DONE) {
            //    //if (f.type == "application/pdf" || f.type == "application/x-download") {
            //    //if (appType.includes(f.type)) {
            //    if (appType.indexOf(f.type) != -1) {
            //        var maxSize = 8388608;//7340032 - 7MB 8388608 - 8Mb;
            //        var fileSize = f.size; // in bytes
            //        if (fileSize > maxSize) {
            //            bootbox.alert("File size must be less than 8MB.");//more than ' + maxSize + ' bytes' + fileSize);
            //            $(e).val('');
            //            return false;
            //        }
            //        else {

            var fileExtension = f.type.split('/');
            var newFileExt = fileExtension[1].replace("msword", "doc").replace("vnd.openxmlformats-officedocument.wordprocessingml.document", "docx")
            var filename = FileName + "." + newFileExt; //".pdf";
            
            if (evt.target.readyState == FileReader.DONE) {
                var cont = evt.target.result;
                var base64String = getB64Str(cont);

                ListModelData = [{ contentType: filetype, contentAsBase64String: base64String, FileName: filename, FileType: FileType, DocumentId: DocumentId, index: index }];
                
                ListModel.push.apply(ListModel, ListModelData);
              
            }

        };
        reader.readAsArrayBuffer(blob);
    }
}


function downloadfiles(maxindex) {
    var DocumentId = $('#hdnDocumentId_' + maxindex).val();
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



function ValidateRequiredFields()
{



}