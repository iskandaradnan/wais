function FileattachmentTab(event, value) {

}

//$(document).ready(function () {

//    $("#btnfileSave, #btnEdit").click(function () {

//        var data = new FormData();
        
//        var files = $("#fileUpload").get(0).files;       
//        if (files.length > 0) {
//            data.append("UploadedImage", files[0]);
//        }

//        URL = "/api/Document/UploadFile"       
//        $.ajax({
//            type: "POST",
//            url: URL,
//            contentType: false,
//            processData: false,
//            data: data,
//            success: function (result) {
//                console.log(result);
//            },
//        error: function (xhr, status, p3, p4) {
//            var err = "Error " + " " + status + " " + p3 + " " + p4;
//            if (xhr.responseText && xhr.responseText[0] == "{")
//                err = JSON.parse(xhr.responseText).Message;
//            console.log(err);
//        }
//    });

//            });
//});
        

  

$(document).ready(function () {
    $('#myPleaseWait').modal('show');    

    //  **************************** Dropdown Load *****************************

    $.get("/api/Document/Load")      

        .done(function (result) {
            var loadResult = JSON.parse(result);
            window.FileLoadData = loadResult.FileTypeData
            AddNewRowfile();      
             

            var primaryId = $('#primaryID').val();
            //  var primaryId = 27;
            if (primaryId != null && primaryId != "0")   {  
                $.get("/api/Document/Get/" + primaryId)
                  .done(function (result) {
                      var getResult = JSON.parse(result);
                      //$('#primaryID').val(result.FileUploadList.DocumentId);
                      $("#FileUploadTable").empty();
                      $.each(getResult.FileUploadList, function (index, value) {
                          
                          $('#primaryID').val(getResult.FileUploadList.DocumentId);
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

    $("#btnfileSave, #btnEdit").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var data = new FormData();
        var _index;
        $('#FileUploadTable tr').each(function () {
            _index = $(this).index();
        });

        //var Mstfile = [];
        for (var i = 0; i <= _index; i++) {
            var _tempObj = [{
                DocumentId: $('#hdnDocumentId_' + i).val(),
                FileType: $('#FileTypeId_' + i).val(),
                FileName: $('#FileName_' + i).val(),

            }];

            var files = $("#AssetAttachment_"+i).get(0).files;
            if (files.length > 0) {
                data.append("UploadedImage", files[0]);
            }
        }              

        data.append('tags', JSON.stringify(_tempObj));

        URL = "/api/Document/UploadFile"       
        $.ajax({
            type: "POST",
            url: URL,
            contentType: false,
            processData: false,
            data: data,
            success: function (result) {
                console.log(result);
            },
            error: function (error) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');
            }
        });
    });



    //********************************* Download File *************************************

    function getById(primaryId) {
        $.get("/api/Document/Download/" + primaryId)
                .done(function (result) {
                    var result = JSON.parse(result);

                    $('#primaryID').val(result.DocumentId);
                    

                    $("#QualityCauseMstTbl").empty();
                    $.each(result.FileUploadList, function (index, value) {
                        AddNewRowQualityCauseMst();
                        $("#hdnDownload_" + index).val(result.FileUploadList[index].FileType);         

                    });
                    $('#myPleaseWait').modal('hide');
                })
                .fail(function () {
                    $('#myPleaseWait').modal('hide');
                    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                    $('#errorMsg').css('visibility', 'visible');
                });
    }


    
});

//  ****************************** AddNewRow **********************************************


function AddNewRowfile() {
    
    //var flag = RequiredValidation();
    //if (flag) {
    //    alert("pleasse enter values");
    //}
    //else {

    var inputpar = {
        inlineHTML: ' <tr> <td width="3%" title=""> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" name="AssetEquipmentAttachmentCheckboxes" id="Isdeleted_maxindexval"> </label> </div></td><td width="20%" data-original-title="" title=""> <div> <input type="hidden" id="hdnDocumentId_maxindexval" value=0> <div class="col-sm-6"> <select id="FileTypeId_maxindexval" class="form-control"> <option value="0">Select</option> </select> </div></div></td><td width="20%" style="text-align: center;" data-original-title="" title=""> <div> <input id="FileName_maxindexval" type="text" class="form-control " name="FileName"> </div></td><td width="20%" style="text-align: center;" data-original-title="" title=""> <div> <input id="AssetAttachment_maxindexval" type="file" class="form-control" name="AsAttachmentfile"> </div></td><td width="20%" style="text-align: center;" data-original-title="" title=""> <div class="text-center"> <input type="hidden" id="hdnDownload_maxindexval" value=0> <a class="glyphicon glyphicon-download-alt" id="imageDownLoad_maxindexval"></a> &nbsp; <a href="#" id="imageDownLoad_maxindexval" style="">Download file</a> </div></td></tr> ',

        IdPlaceholderused: "maxindexval",
        TargetId: "#FileUploadTable",
        TargetElement: ["tr"]

    }
    AddNewRowToDataGrid(inputpar);


    $("a[id^='imageDownLoad_']").click(function () {
        URL = "/api/Document/Download"
        $.ajax({
            type: "GET",
            url: URL,
            contentType: false,
            processData: false,                   
            success: function (result) {
                console.log(result);
            },
            error: function (error) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');
            }
        });
    });

    var rowCount = $('#FileUploadTable tr:last').index();
    $.each(window.FileLoadData, function (index, value) {
        $('#FileTypeId_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
}
        
 

//    function RequiredValidation(index,value) {
//        var flag = false;
//        var filevalid = {
//            FileType: $('#FileTypeId_' + index).val(),
//            FileName: $('#FileName_' + index).val(),
//            FilePath: $('#AssetAttachment_' + index).val()
//        }
//        if (filevalid == 0 || filevalid == undefined || filevalid == null) {
//            flag=true
//        }       
//        return flag;
//}

function getFileDetails(e, index) {

    var FileName = $("#FileName").val();

    var _index;
    $('#FileUploadTable tr').each(function () {
        _index = $(this).index();
    });

    //var Mstfile = [];
    for (var i = 0; i <= _index; i++) {

        var DocumentId = $('#hdnDocumentId_' + i).val();
        var FileType= $('#FileTypeId_' + i).val();
        var FileName= $('#FileName_' + i).val();
    }


    for (var i = 0; i < e.files.length; i++) {
        var f = e.files[i];
        var file = f;
        var blob = e.files[i].slice();
        var filetype = file.type;
        var filesize = file.size;       

        function getB64Str(buffer) {
            var binary = '';
            var bytes = new Uint8Array(buffer);
            var len = bytes.byteLength;
            for (var i = 0; i < len; i++) {
                binary += String.fromCharCode(bytes[i]);
            }
            return window.btoa(binary);
        }
        var reader = new FileReader();
        reader.onloadend = function (evt) {
            //try {
            //    actionType = actionType;
            //    var verfyobject = actionType.value;
            //}
            //catch (e) {
            //    actionType = ActionType;
            //}
            var appType = appType = ['application/pdf', 'application/x-download', 'application/doc', 'application/docx', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/tig'];
            var errMessage = "Please upload Pdf File.";

            if (evt.target.readyState == FileReader.DONE) {
                var cont = evt.target.result;
                var base64String = getB64Str(cont);
                ListModelData = [{ contentType: filetype, contentAsBase64String: base64String, FileName: FileName, fileType: filetype, fileFormat: "sadas" }];

                ListModel.push.apply(ListModel, ListModelData);
                $("#BindList").val(JSON.stringify(ListModel));
            }

        };

        reader.readAsArrayBuffer(blob);

    }


}





//public async Task<HttpResponseMessage> UploadFile(AssetRegisterAttachment Document)
//{
//            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
//if (HttpContext.Current.Request.Files.AllKeys.Any())
//{
//    // Get the uploaded image from the Files collection
//    var httpPostedFile = HttpContext.Current.Request.Files["UploadedImage"];
//    var Document = JsonConvert.DeserializeObject<List<AssetRegisterAttachment>>(HttpContext.Current.Request.Form.Get("tags"));

//    if (httpPostedFile != null)
//    {
//        //for (var i=0; i<= httpPostedFile.ContentLength;i++)
//        //foreach(var val in httpPostedFile)
//        //{
//            // Get the complete file path
//            var fileSavePath = Path.Combine(HttpContext.Current.Server.MapPath("~/File Upload"), httpPostedFile.FileName);
//            httpPostedFile.SaveAs(fileSavePath);
//            Document[0].FilePath = fileSavePath;
//       // }
//        // Save the uploaded file to "UploadedFiles" folder

//    }
//    var result = await RestHelper.ApiPost("Document/Save", Document[0]);
//    Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());                
//}

//}


//***********video upload
function getVideoDetails(e, id) {   

    for (var i = 0; i < e.files.length; i++) {
        var f = e.files[i];
        var file = f;
        var blob = e.files[i].slice();
        var filetype = file.type;
        var filesize = file.size;
        var FileName = file.name;
        var totalSize = 0;
        
        var $source = $('#blah'+id);        
        $source[0].src = URL.createObjectURL(e.files[0]);
        $source.parent()[0].load();
            
        var filename = FileName.substr(0, FileName.lastIndexOf('.')) || FileName;
            

        ListModelData = [{ contentType: filetype,  FileName: filename }];

        ListModel.push.apply(ListModel, ListModelData);
        // $("#BindList").val(JSON.stringify(ListModel));
    }  
        
         
}



$scope.downloadFiles = function (documentId, typeId) {
    if (typeId == undefined || typeId == null) {
        typeId = 0;
    }

    if (parseInt($("#screenIdforDocument").val()) === 551 && !$scope.IsPrintPermission) {
        return false;
    }

    //typeId = 1;
    var promiseAction = companyProfileService.download(documentId);
    promiseAction.then(function (response, status, headers) {
        //config: Objectdata: ArrayBufferheaders: function (name) {status: 200statusText: "OK"
        var data = response.data;
        var octetStreamMime = 'application/octet-stream';
        var success = false;
        // Get the headers
        headers = response.headers();
        // Get the filename from the x-filename header or default to "download.bin"
        // var filename = headers['x-filename'] || 'download.bin';
        var disposition = headers['content-disposition'];
        if (disposition && disposition.indexOf('attachment') !== -1) {
            var filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
            var matches = filenameRegex.exec(disposition);
            if (matches != null && matches[1]) filename = matches[1].replace(/['"]/g, '');
        }
        // Determine the content type from the header or default to "application/octet-stream"
        var contentType = headers['content-type'] || octetStreamMime;
        try {
            //console.log(filename);
            // Try using msSaveBlob if supported
            //console.log("Trying saveBlob method ...");
            var blob = new Blob([data], { type: contentType });
            if (navigator.msSaveBlob)
                navigator.msSaveBlob(blob, filename);
            else {
                // Try using other saveBlob implementations, if available
                var saveBlob = navigator.webkitSaveBlob || navigator.mozSaveBlob || navigator.saveBlob;
                if (saveBlob === undefined) throw "Not supported";
                saveBlob(blob, filename);
            }
            //console.log("saveBlob succeeded");
            success = true;
        } catch (ex) {
            //console.log("saveBlob method failed with the following exception:");
            //console.log(ex);
        }
        if (!success) {
            // Get the blob url creator
            //var urlCreator = window.URL || window.webkitURL || window.mozURL || window.msURL;
            var browserName = getBrowwerName();
            if (browserName === "Chrome" || browserName === "Netscape") {
                var urlCreator = window.webkitURL || window.mozURL || window.msURL; //window.URL ||
            } else if (browserName === "Firefox") {
                //var url = window.URL;
                //var originalUrl = URL;
                //if(url != originalUrl){
                //    url = originalUrl;
                //}
                var urlCreator = window.URL || window.webkitURL || window.mozURL || window.msURL;
            }
            if (urlCreator) {
                // Try to use a download link
                var link = document.createElement('a');
                if ('download' in link) {
                    // Try to simulate a click
                    try {
                        // Prepare a blob URL
                        //console.log("Trying download link method with simulated click ...");
                        if (contentType == "application/jpg") {
                            contentType = "image/jpeg";
                        }
                        var blob = new Blob([data], { type: contentType });
                        var url = urlCreator.createObjectURL(blob);
                        if (typeId == 0) {
                            link.setAttribute('href', url);
                            // Set the download attribute (Supported in Chrome 14+ / Firefox 20+)
                            link.setAttribute("download", filename);
                            // Simulate clicking the download link
                            var event = document.createEvent('MouseEvents');
                            event.initMouseEvent('click', true, true, window, 1, 0, 0, 0, 0, false, false, false, false, 0, null);
                            link.dispatchEvent(event);
                        }
                        else {
                            $window.open(url);
                        }
                        //console.log("Download link method with simulated click succeeded");
                        success = true;
                    } catch (ex) {
                        //console.log("Download link method with simulated click failed with the following exception:");
                        //console.log(ex);
                    }
                }
                if (!success) {
                    // Fallback to window.location method
                    try {
                        // Prepare a blob URL
                        // Use application/octet-stream when using window.location to force download
                        //console.log("Trying download link method with window.location ...");
                        var blob = new Blob([data], { type: octetStreamMime });
                        var url = urlCreator.createObjectURL(blob);
                        window.location = url;
                        if (typeId > 0) {
                            $window.open(url);
                        }
                        //console.log("Download link method with window.location succeeded");
                        success = true;
                    } catch (ex) {
                        //console.log("Download link method with window.location failed with the following exception:");
                        //console.log(ex);
                    }
                }
            }
        }
        if (!success) {
            // Fallback to window.open method
            //console.log("No methods worked for saving the arraybuffer, using last resort window.open");
            window.open(httpPath, '_blank', '');
        }
        /******************/
    },
    function (errorPl, status) {
        $scope.errorList = errorPl.data.ReturnMessage;
        $scope.error = errorPl.statusText;
        //console.log("Request failed with status: " + status);
    });
}
$scope.getFileDetails = function (e, index, fileAttach) {
    var actionType = { value: 'ADD' };
    //try {
    //    actionType = 'ADD';
    //    var verfyobject = actionType.value;
    //}
    //catch (e) {
    //    actionType = 'ADD';
    //}
    $scope.$apply(function () {
        // STORE THE FILE OBJECT IN AN ARRAY.
        for (var i = 0; i < e.files.length; i++) {
            var f = e.files[i];
            var file = f;
            var blob = e.files[i].slice();
            var filetype = file.type;
            var filesize = file.size;
            var filename;//;= file.name;
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
                try {
                    actionType = actionType;
                    var verfyobject = actionType.value;
                }
                catch (e) {
                    actionType = ActionType;
                }
                var appType = ['application/pdf', 'application/x-download'];
                var errMessage = "Please upload Pdf File.";
                if ($scope.$parent.fileServiceId === 10) {
                    appType = ['application/pdf', 'application/x-download', 'application/doc', 'application/docx', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/tig'];
                    errMessage = "Please upload Pdf/Docx/jpg/png/gif File.";
                }
                if (evt.target.readyState == FileReader.DONE) {
                    //if (f.type == "application/pdf" || f.type == "application/x-download") {
                    //if (appType.includes(f.type)) {
                    if (appType.indexOf(f.type) != -1) {
                        var maxSize = 8388608;//7340032 - 7MB 8388608 - 8Mb;
                        var fileSize = f.size; // in bytes
                        if (fileSize > maxSize) {
                            bootbox.alert("File size must be less than 8 MB.");//more than ' + maxSize + ' bytes' + fileSize);
                            $(e).val('');
                            return false;
                        }
                        else {
                            var totalMaxSize = 18874368;//18874368 - 20MB
                            //if(parseInt($("#screenIdforDocument").val()) === 551)
                            //{
                            //	totalMaxSize = 47185920; //47185920 - 50MB
                            //}                                
                            $scope.$parent.totalSize = $scope.$parent.totalSize + f.size;
                            //if ($scope.$parent.totalSize > totalMaxSize) {
                            //    bootbox.alert("Total Files size must be less than 20MB");//more than ' + maxSize + ' bytes' + fileSize);
                            //    $(e).val('');
                            //    $scope.$parent.totalSize = $scope.$parent.totalSize - f.size;
                            //    return false;
                            var totalSize = 0;
                            angular.forEach($scope.files, function (data, thisId) {
                                if (thisId != index)
                                    totalSize += data.fileValue.size
                            });
                            totalSize = totalSize + f.size;
                            if (totalSize > totalMaxSize) {
                                bootbox.alert("Total Files size must be less than 20MB.");//more than ' + maxSize + ' bytes' + fileSize);
                                $(e).val('');
                                // $scope.$parent.totalSize = $scope.$parent.totalSize - f.size;
                                return false;
                            }
                            var exists = $.grep($scope.files, function (data, index) {
                                return f.name == data.fileValue.name;
                            });
                            if (false) {//exists.length > 0) {
                                bootbox.alert("This file already uploaded.");
                                $(e).val('');
                                $scope.$parent.totalSize = $scope.$parent.totalSize - f.size;
                                //  $(e).parent().prev().find('input').val('');
                                return false;
                            }
                            var FileName = $.grep($scope.fileAttachList, function (data, pos) {
                                if (index == pos) {
                                    return false;
                                }
                                else {
                                    if (actionType.value.toUpperCase() == 'ADD') {
                                        var name = fileAttach.FileName;// + ".pdf";
                                        var baseName = data.FileName;
                                        name = (name == undefined || name == null) ? "" : name
                                        baseName = (baseName == undefined || baseName == null) ? "" : baseName
                                        return name.toUpperCase() == baseName.toUpperCase();
                                    }
                                    else if (actionType.value.toUpperCase() == 'EDIT') {
                                        if (data.BaseFileModel.fileTitle === undefined) {
                                            var name = fileAttach.FileName;// + ".pdf";
                                            var baseName = data.FileName;
                                            name = (name == undefined || name == null) ? "" : name
                                            baseName = (baseName == undefined || baseName == null) ? "" : baseName
                                            return name.toUpperCase() == baseName.toUpperCase();
                                        }
                                        else {
                                            var name = fileAttach.FileName;
                                            var baseName = data.FileName;
                                            name = (name == undefined || name == null) ? "" : name
                                            baseName = (baseName == undefined || baseName == null) ? "" : baseName
                                            return name.toUpperCase() == baseName.toUpperCase();
                                        }
                                    }
                                }
                            });
                            //var filenameconditionCheck = ($scope.IIR == undefined) ? FileName.length > 0 : false;
                            if (FileName.length > 0) {
                                bootbox.alert("File Name " + fileAttach.FileName + " is already entered.  Please enter different File Name");
                                //console.log(fileAttach);
                                $(e).val('');
                                $scope.$parent.totalSize = $scope.$parent.totalSize - f.size;
                                //$('#fileName' + index).val('');
                                return false;
                            }
                            else {
                                var file = { id: index, fileValue: f };
                                if ($scope.files.length !== 0) {
                                    var added = false;
                                    $.map($scope.files, function (fileList, indexInArray) {
                                        if (fileList.id == index) {
                                            added = true;
                                        }
                                    });
                                    if (!added) {
                                        $scope.files.push(file);
                                    }
                                    else {
                                        $scope.files[index].fileValue = f;
                                    }
                                }
                                else {
                                    $scope.files.push(file);
                                }
                                console.log($scope.files);
                                var cont = evt.target.result
                                //var base64String = btoa(String.fromCharCode.apply(null, new Uint8Array(cont)));
                                var base64String = getB64Str(cont);
                                var fileExtension = f.type.split('/');
                                var newFileExt = fileExtension[1].replace("msword", "doc").replace("vnd.openxmlformats-officedocument.wordprocessingml.document", "docx")
                                filename = fileAttach.FileName + "." + newFileExt; //".pdf";
                                var serviceId = parseInt($("#moduleServiceId").val());
                                fileAttach.ServiceId = serviceId;
                                var model = {
                                    contentType: filetype,
                                    contentAsBase64String: base64String,
                                    fileName: filename,
                                    index: 1,
                                    id: index, // this index row index value , It is use checking file existing ,If file exsiting replace file or add file .
                                    ServiceId: serviceId,
                                    ScreenPageId: parseInt($("#screenIdforDocument").val())
                                };
                                fileAttach.BaseFileModel = model;
                                fileAttach.FileFlag = 1;
                            }
                        }
                    }
                    else {
                        //console.log($scope.fileAttachList);
                        bootbox.alert(errMessage);
                        $(e).val('');

                        if (angular.isUndefined(fileAttach.AttachmentId) || fileAttach.AttachmentId == "" || fileAttach.AttachmentId == null || fileAttach.AttachmentId == 0) {
                            fileAttach.FileFlag = 0;
                        }

                        $scope.$parent.totalSize = $scope.$parent.totalSize - f.size;
                    }
                }
            };
            //reader.readAsBinaryString(blob); //not supported in IE as its removed from spec
            //reader.readAsText(blob);
            reader.readAsArrayBuffer(blob);
        }
    });
};

//************** file upload latest

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

    //  $("#btnfileSave, #btnEdit").click(function () {
    $("#btnfileSave").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        $('#FileUploadTable tr').each(function () {
            _index = $(this).index();
        });

        var Document = { FileUploadList: ListModel };
        var data = JSON.stringify(Document);

        alert(data);
        URL = "/api/Document/UploadFile"
        $.ajax({
            type: "POST",
            url: URL,
            //contentType: false,
            //processData: false,
            data: Document,
            success: function () {
                showMessage('File Upload', CURD_MESSAGE_STATUS.SS);
                $("#top-notifications").modal('show');
                setTimeout(function () {
                    $("#top-notifications").modal('hide');
                }, 5000);

                $('#btnfileSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
                //console.log();
            },
            error: function (error) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');
            }
        });
    });



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



    //************************************ Grid Delete 

    $("#chk_FileUploadAttachment").change(function () {
        var Isdeletebool = this.checked;

        if (this.checked) {
            $('#FileUploadTable tr').map(function (i) {
                if ($("#Isdeleted_" + i).prop("disabled")) {
                    $("#Isdeleted_" + i).prop("checked", false);
                }
                else {
                    $("#Isdeleted_" + i).prop("checked", true);
                }
            });
        } else {
            $('#FileUploadTable tr').map(function (i) {
                $("#Isdeleted_" + i).prop("checked", false);
            });
        }
    });


});

//  ****************************** AddNewRow **********************************************


function AddNewRowfileupload() {

    var inputpar = {
        inlineHTML: BindNewRowHTML(),

        IdPlaceholderused: "maxindexval",
        TargetId: "#FileUploadTable",
        TargetElement: ["tr"]

    }
    AddNewRowToDataGrid(inputpar);
    $('#chk_FileUploadAttachment').prop("checked", false);
    $('#FileUploadTable tr:last td:first input').focus();

    var rowCount = $('#FileUploadTable tr:last').index();
    $.each(window.FileLoadData, function (index, value) {
        $('#FileTypeId_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
}


function BindNewRowHTML() {
    return ' <tr> <td width="3%" title="Select"> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="hidden" name="ActiveCheckboxs" id="Active_maxindexval"> <input type="checkbox" name="FileUploadCheckboxes" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(FileUploadTable,chk_FileUploadAttachment)"> </label> </div></td><td width="20%" title="File Type"> <input type="hidden" id="hdnDocumentId_maxindexval" value=0> <div> <select id="FileTypeId_maxindexval" class="form-control" required> <option value="null">Select</option> </select> </div></td><td width="30%" style="text-align: center;" title=""> <div> <input id="FileName_maxindexval" type="text" class="form-control" required> </div></td><td width="27%" style="text-align: center;" title="Choose File"> <div> <input type="hidden" id="hdnFileName_maxindexval"> <input id="Attachment_maxindexval" onchange="getFileDetailsattach(this, maxindexval)" type="file" class="form-control" required> </div></td><td width="20%" style="text-align: center;" title=""> <div class="text-center"> <input type="hidden" id="hdnDownload_maxindexval" value=0> <a class="glyphicon glyphicon-download-alt" id="imageDownLoad_maxindexval" onclick="downloadfiles(maxindexval)"></a> &nbsp; <a href="#" id="imageDownLoad_maxindexval" onclick="downloadfiles(maxindexval)">Download file</a> </div></td></tr> ';
}



//*********************** Empty Row Validation **************************************

function AddNewRowfile() {
    $("div.errormsgcenter1").text("");
    $('#errorMsg1').css('visibility', 'hidden');
    var rowCount = $('#FileUploadTable tr:last').index();
    var filecat = $('#FileTypeId_' + rowCount).val();
    if (rowCount < 0)
        AddNewRowfileupload();
    else if (rowCount >= "0" && filecat == "null") {
        bootbox.alert("All fields are mandatory. Please enter details in existing row");
        //  $("div.errormsgcenter1").text();
        // $('#errorMsg1').css('visibility', 'visible');
    }
    else {
        AddNewRowfileupload();
    }
}


//************************ File Attachment ******************************************


function getFileDetailsattach(e, index) {
    // ListModel = [];
    var _index;
    $('#FileUploadTable tr').each(function () {
        _index = $(this).index();
    });
    var FileNameVal = $('#FileName_' + index).val();
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
            // var newFileExt = fileExtension[1].replace("msword", "doc").replace("vnd.openxmlformats-officedocument.wordprocessingml.document", "docx")
            // var filename = FileName + "." + newFileExt; //".pdf";

            if (evt.target.readyState == FileReader.DONE) {
                var cont = evt.target.result;
                var base64String = getB64Str(cont);

                ListModelData = [{
                    contentType: filetype,
                    contentAsBase64String: base64String,
                    DocumentExtension: filetype,
                    DocumentTitle: FileNameVal,
                    FileName: FileNameVal,
                    FileType: FileType,
                    DocumentId: DocumentId,
                    index: index
                }];

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



function ValidateRequiredFields() {



}