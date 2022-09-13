appUETrack.controller("FileUploadController", function ($scope, companyProfileService) {
    $scope.init = function () {

        var tabMode = $scope.$parent.modeTab2;
        var actionType = $scope.$parent.actionType;
        var FileTypes = $scope.$parent.FileTypes;
        // $scope.hospitalFileAttachList = $scope.$parent.hospitalFileAttachList;
        // $scope.FileTypes = $scope.$parent.FileTypes;
        //if ((tabMode !== undefined && tabMode !== null) && (actionType !== undefined && actionType !== null)) {
        //  $scope.FileTypes = FileTypes;
        //    var copyRes;
        //    if ($scope.hospitalFileAttachList.length === 0 || $scope.hospitalFileAttachList===undefined)
        //    {
        //        if ($scope.hospital !== undefined) {
        //            copyRes = { HospitalId: $scope.hospital.HospitalId, DocumentId: 0, AttachId: 0, FileName: "", FileType: "" };
        //            $scope.hospitalFileAttachList.push(copyRes);
        //        }
        //        else {
        //             copyRes = { HospitalId:null, DocumentId: 0, AttachId: 0, FileName: "", FileType: "" };
        //            $scope.hospitalFileAttachList.push(copyRes);
        //        }
        //    }
        //}
        //else {
        //    /***** Load Start ****/
        //    var promiseGet = hospitalService.load();
        //    promiseGet.then(function (response) {
        //        var s = response.data;
        //        $scope.FileTypes = s.HospitalFileAttach;
        //        var copyRes = { HospitalId: $scope.hospital.HospitalId, DocumentId: 0, AttachId: 0, FileName: "", FileType: "" };
        //        $scope.hospitalFileAttachList.push(copyRes);
        //    },
        //   function (errorPl) {
        //       $scope.error = 'Failed to load data! ' + errorPl.data.ExceptionMessage;
        //   });
        //    /***** Load End ****/
        //}
    }

    /** Summary:  Grid row create and validation  **/

    $scope.addFormField = function () {

        var validator = CheckfileUpload();

        if (validator == false) {
            bootbox.alert("All fields are mandatory. Please enter details in existing row");
        }
        else {
            var copyRes;
            if ($scope.hospital !== undefined) {
                copyRes = { HospitalId: $scope.hospital.HospitalProfileId, DocumentId: 0, AttachId: 0, FileName: "", FileType: "", DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, basemod:"" };
                $scope.fileAttachList.push(copyRes);
            }
            else if ($scope.ContractorAndVendor !== undefined) {
                copyRes = { HospitalId: $scope.ContractorAndVendor.HospitalProfileId, DocumentId: 0, AttachId: 0, FileName: "", FileType: "", DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, basemod: "" };
                $scope.fileAttachList.push(copyRes);
            }
            else {
                copyRes = { HospitalId: null, DocumentId: 0, AttachId: 0, FileName: "", FileType: "", DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, basemod: "" };
                $scope.fileAttachList.push(copyRes);
            }
            // setTimeout(dateTimeCalendar, 1000);
        }
    };

    /**
         Summary: File upload validate and add file list's. Here,File upload pdf only ,Other type not allowed,
            Single File size 8Mb maximum allowed .
    **/

    $scope.getFileDetails = function (e, index, fileAttach) {
        console.log(fileAttach);
        $scope.$apply(function () {

            // STORE THE FILE OBJECT IN AN ARRAY.
            for (var i = 0; i < e.files.length; i++) {
                var f = e.files[i];
               
                var model;
             

                var attach = $scope.fileAttachList;
                var columnValues = attach[i];
                var file = f;
                var blob = e.files[i].slice();

              //  var filecontent = file.slice();
                var filetype = file.type;
                var filesize = file.size;
                var filename = file.name;

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

                    if (evt.target.readyState == FileReader.DONE) {

                        var cont = evt.target.result
                        //var base64String = btoa(String.fromCharCode.apply(null, new Uint8Array(cont)));
                        var base64String = getB64Str(cont);
                        
                      

                         model = {
                            contentType: filetype,
                            contentAsBase64String: base64String,
                            fileName: filename,
                            columnValues: columnValues
                         };
                         console.log(base64String);
                        // var columnValues = $scope.fileAttachList[i];
                         //$.each(attachList, function (index, data) {
                         //    if ((data.FileName == null || data.FileName == '') || (data.FileType == null || data.FileType == '') || (data.FileFlag == null || data.FileFlag == 0)) {
                         //        // alert('False');
                         //        return flag = true;
                         //    }
                         //    else {
                         //        // alert('true');
                         //        return flag = true;
                         //    }
                         //});
                         console.log(model);
                        
                         var filed = { id: index, fileValue: f, DocumentId: fileAttach.DocumentId,basemodel:model };
                         
                         $scope.files.push(filed);
                         

                    }
                };

                //reader.readAsBinaryString(blob); //not supported in IE as its removed from spec
                //reader.readAsText(blob);
                reader.readAsArrayBuffer(blob);
           // var s=fileAttach.model;

                if (f.type == "application/pdf" || f.type == "application/x-download") {
                    var maxSize = 8388608;//7340032 - 7MB 8388608 - 8Mb;
                    var fileSize = f.size; // in bytes
                    if (fileSize > maxSize) {
                        bootbox.alert('file size is more then' + maxSize + ' bytes' + fileSize);
                        return false;
                    } else {
                        var exists = $.grep($scope.files, function (data, index) {
                            return f.name == data.fileValue.name;
                        });
                        //if (exists.length > 0) {
                        //    bootbox.alert("This file already uploaded.");
                        //    $(e).val('');
                        //    return false;
                        //}
                        //else {
                            var file = { id: index, fileValue: f, DocumentId:1 };
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
                                    $scope.files[i].fileValue = f;
                                    $scope.files[i].DocumentId = fileAttach.DocumentId;
                                }
                                fileAttach.FileFlag = 1;
                            }
                            else {
                                $scope.files.push(file);
                                fileAttach.FileFlag = 1;
                            }
                            console.log($scope.files);
                        }
                    }
               // }
                else {
                    bootbox.alert("Please upload Pdf file");
                    $(e).val('');
                }

       }

      });
   };

    /** Summary: Validate row filed's empty **/

    function CheckfileUpload() {
        var flag = false;
        var attachList = $scope.fileAttachList;
        console.log($scope.fileAttachList);

        if (attachList != null) {
            $.each(attachList, function (index, data) {
                if ((data.FileName == null || data.FileName == '') || (data.FileType == null || data.FileType == '') || (data.FileFlag == null || data.FileFlag == 0)) {
                    // alert('False');
                    return flag = false;
                }
                else {
                    // alert('true');
                    return flag = true;
                }
            });
            return flag;
        }
        return flag;
    }
});