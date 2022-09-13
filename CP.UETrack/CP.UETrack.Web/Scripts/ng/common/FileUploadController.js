appUETrack.controller("FileUploadController", function ($scope, $window, companyProfileService, $element, $timeout) {

    var ActionPermissionValues = $('#ActionPermissionValues').val();
    var ActionPermissions = JSON.parse(ActionPermissionValues);
    $scope.IsPrintPermission = Enumerable.From(ActionPermissions).Any("$.ActionPermissionName=='Print'");

    $scope.init = function () {
        $scope.$parent.fileServiceId = parseInt($("#moduleServiceId").val());
        $scope.$parent.fileMenuId = parseInt($("#screenIdforDocument").val());
        if ((!$scope.$parent.Manpowernorms) && (!$scope.$parent.Audit) && (!$scope.$parent.pd))
            $scope.isFileRequired = true;
        if ($scope.$parent.CompanyProfile) {
            $scope.IsEffectiveDateShow = true
            //$("#attachmentHeader").css("width", "27%");
            //$("#fileth").css({ 'width': "27%" });
            //$("#fileth").attr('style', 'width: 10% !important');
            //setTimeout(function () { $("#fileth").attr('style', 'width: 10% !important'); }, 100);
            //$("#fileth").css("width", "+=10");
        }
        if ($scope.$parent.CommonUpload) {
            $scope.IsShortDescriptionShow = $scope.IsUploadedByShow = true;
            $scope.isShortDescriptionShowRequired = true;
        }
        if ($scope.$parent.nameLength)
            $scope.nameLength = $scope.$parent.nameLength;
        if ($scope.warrantySharedData != null && $scope.warrantySharedData != undefined) {
            $scope.isWMFiletypeRequired = false;
        }
        else {
            $scope.isWMFiletypeRequired = true;
        }
        var tabMode = $scope.$parent.modeTab2;
        var actionType;
        try {
            actionType = $scope.$parent.actionType;
            var verfyobject = actionType.value;
        }
        catch (e) {
            actionType = $scope.$parent.ActionType;
        }
        var FileTypes = $scope.$parent.FileTypes;
        $scope.$parent.totalSize = 0;
    }
    /** Summary:  Grid row create and validation  **/
    $scope.addFormField = function () {
        if ($scope.$parent.ScreenName !== undefined) {
            if ($scope.$parent.ScreenName == "AuditPlaning" || $scope.$parent.ScreenName == "Warranty Management") {
                var validator = CheckfileOptional();
            }
            else {
                var validator = CheckfileUpload();
            }
        }
        else {
            var validator = CheckfileUpload();
        }

        if (validator == false) {
            if ($scope.isFileRequired) {

                var added = false;

                $.map($scope.fileAttachList, function (attach, indexInArray) {
                    if (attach.IsDeleted != undefined) {
                        if (attach.FileFlag == 0 && attach.IsDeleted == false && attach.FileName != '' && attach.FileType != '') {
                            added = true;
                            $scope.files.splice(indexInArray, 1);
                        }
                    }
                    else {
                        if (attach.FileFlag == 0 && attach.FileName != '' && attach.FileType != '') {
                            added = true;
                        }
                    }
                });
                if (added) {
                    bootbox.alert("Please Attach File!");
                    $scope.isDisabled2 = false;
                    return false;
                }
                else {
                    bootbox.alert("All fields are mandatory. Please enter details in existing row");
                    $timeout(function () {
                        $element[0].querySelector('[is-last=true]').focus();
                    })
                }
            }
            else {
                bootbox.alert("Please enter details in existing row");
            }
        }
        else {
            var copyRes;
            var model = {
                contentType: "",
                contentAsBase64String: "",
                fileName: "",
                index: 0,
                id: "" // this index row index value , It is use checking file existing ,If file exsiting replace file or add file .
            };
            if ($scope.spFile !== undefined && $scope.spFile == 'spProfileFile') {
                // console.log($scope.copyRes);
                copyRes = { HospitalId: null, DocumentId: 0, AttachId: 0, FileName: "", FileType: $scope.FileTypes[0].LovId, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
                return;
            }
            $scope.IsAtttachmentSelected = false;

            if ($scope.hospital !== undefined) {
                copyRes = { HospitalId: $scope.hospital.HospitalProfileId, DocumentId: 0, AttachmentId: 0, AttachId: 0, FileName: "", FileType: "", DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
            }
            else if ($scope.$parent.ScreenName !== undefined) {
                if ($scope.$parent.ScreenName == "AuditPlaning") {
                    var result;
                    if (!($scope.$parent.Audit.ClosureDate == null || $scope.$parent.Audit.ClosureDate == undefined || $scope.$parent.Audit.ClosureDate == ""))
                        result = true;
                    else
                        result = false;
                    var copyRes = {
                        HospitalId: 0, DocumentId: 0, AuditId: 0, AttachmentId: 0, FileName: "", FileType: "",
                        DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "",
                        FileFlag: 0, BaseFileModel: model, IsDeleted: false, isFileTypeRequired: result, isFileNamepRequired: result, ShortDescription: false
                    };
                    $scope.fileAttachList.push(copyRes);

                    // Select_Grid.Reset_All_Chk($scope,$scope.fileAttachList);
                }
                if ($scope.$parent.ScreenName == "FEMS" || $scope.$parent.ScreenName == "BEMS" || $scope.$parent.ScreenName == "CLS" || $scope.$parent.ScreenName == "HWMS" || $scope.$parent.ScreenName == "WP") {
                    copyRes = { TrainingId: $scope.TrainingId, DocumentId: 0, AttachmentId: 0, FileName: "", FileType: $scope.FileTypes[0].LovId, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                    $scope.fileAttachList.push(copyRes);

                }
                if ($scope.$parent.ScreenName == "LLS") {
                    var copyRes = { DocumentId: 0, AttachmentId: 0, FileName: "", FileType: "", DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, IsDeleted: false, isFileTypeRequired: true, isFileNamepRequired: true, Used: false };
                    $scope.fileAttachList.push(copyRes);
                    $scope.IsHeaderDisableForLLS();


                }
                if ($scope.$parent.ScreenName == "WPMNCR") {
                    copyRes = { HospitalId: null, DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: 551, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false, Isolddata: false };
                    $scope.fileAttachList.push(copyRes);


                }
                if ($scope.$parent.ScreenName == "Hospital") /*$scope.StaffDetails !== undefined*/ {
                    var Attachmentrow = { StaffMasterId: $scope.manpower.StaffMasterId, DocumentId: 0, AttachmentId: 0, FileName: "", FileType: 551, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, IsDeleted: false, BaseFileModel: model, isFileNamepRequired: true, isFileTypeRequired: true };
                    $scope.fileAttachList.push(Attachmentrow);
                    //$scope.FileTypes[0].LovId = "";
                }
                if ($scope.$parent.ScreenName == "Company")  //$scope.CompanyStaffMasterDetails !== undefined
                {
                    var Attachmentrow = { StaffMasterId: $scope.manpower.StaffMasterId, DocumentId: 0, AttachmentId: 0, FileName: "", FileType: 551, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, IsDeleted: false, BaseFileModel: model, isFileNamepRequired: true, isFileTypeRequired: true };
                    $scope.fileAttachList.push(Attachmentrow);
                }
                if ($scope.$parent.ScreenName == "Warranty Management") {

                    var Attachmentrow = {
                        DocumentId: 0, AttachmentId: 0, FileName: "", FileType: $scope.FileTypes[2].LovId, isFileTypeRequired: true, isFileNamepRequired: true, isFileNamepRequired: true,
                        DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, IsDeleted: false, BaseFileModel: model
                    };
                    $scope.fileAttachList.push(Attachmentrow);
                }
            }
            else if ($scope.DEAudit !== undefined) {
                copyRes = { HospitalId: $scope.DEAudit.HospitalId, AuditId: $scope.DEAudit.DetailedEnergyAuditId, DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: $scope.FileTypes[0].LovId, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
            }
            else if ($scope.ComplaintFileAttachList !== undefined) {
                copyRes = { IAQComplaintFormId: $scope.SpIAQComplaint.IAQComplaintFormId, DocumentId: 0, AttachmentId: 0, AttachId: 0, FileName: "", FileType: $scope.FileTypes[0].LovId, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, IsDeleted: false, isFileTypeRequired: true, isFileNamepRequired: true };
                $scope.fileAttachList.push(copyRes);
            }
            else if ($scope.License !== undefined) {
                copyRes = { HospitalId: $scope.License.HospitalId, LicenseId: $scope.License.LicenseId, DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: "", DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
                $scope.FileTypes[0].LovId = "";
            }
            else if ($scope.License !== undefined) {
                copyRes = { HospitalId: $scope.License.HospitalId, LicenseId: $scope.License.LicenseId, DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: "", DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
                $scope.FileTypes[0].LovId = "";
            }
            else if ($scope.Driver !== undefined) {
                copyRes = { HospitalId: $scope.Driver.HospitalId, DriverId: $scope.Driver.DriverId, DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: 3077, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
                $scope.FileTypes[1].LovId = 3077;
            }
            else if ($scope.Vehicle !== undefined) {
                copyRes = { HospitalId: $scope.Vehicle.HospitalId, VehicleId: $scope.Vehicle.VehicleId, DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: 1166, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
                $scope.FileTypes[1].LovId = 1166;
            }
            else if ($scope.LinenCompilanceTest !== undefined) {
                copyRes = { HospitalId: $scope.LinenCompilanceTest.HospitalId, LinenComplianceTestId: $scope.LinenCompilanceTest.LinenComplianceTestId, DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: $scope.FileTypes[0].LovId, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
                $scope.FileTypes[0].LovId;
            }
            else if ($scope.LaundryPlantFacility !== undefined) {
                copyRes = { HospitalId: $scope.LaundryPlantFacility.HospitalId, FacilityCodeId: $scope.LaundryPlantFacility.FacilityCodeId, DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: $scope.FileTypes[5].LovId, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
                //$scope.FileTypes[5].LovId = '';
            }
            else if ($scope.LinenItem !== undefined) {
                copyRes = { HospitalId: $scope.LinenItem.HospitalId, LinenItemId: $scope.LinenItem.LinenItemId, DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: "", DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false, Used: false };
                $scope.fileAttachList.push(copyRes);
                $scope.FileTypes[0].LovId = "";
            }
            else if ($scope.assetRegister !== undefined) {
                copyRes = { HospitalId: $scope.assetRegister.HospitalId, AssetRegisterId: $scope.assetRegister.AssetRegisterId, DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: 551, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false, FileTextBox: false, FileDropdown: true, Isolddata: false };
                $scope.fileAttachList.push(copyRes);

            }
            else if ($scope.CompanyProfile !== undefined) {
                copyRes = { HospitalId: $scope.CompanyProfile.hospitalID, CompanyProfileId: $scope.CompanyProfile.companyProfileId, DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: "", DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
                $scope.FileTypes[0].LovId = "";
            }
            else if ($scope.ContractorAndVendor !== undefined) {
                copyRes = { HospitalId: $scope.ContractorAndVendor.HospitalId, ContractorId: $scope.ContractorAndVendor.ContractorId, DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: "", DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false, IsRowDisabled: false };
                $scope.fileAttachList.push(copyRes);
                $scope.FileTypes[0].LovId = "";
            }
            else if ($scope.Manpowernorms !== undefined) {
                copyRes = { DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: "", DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: false, isFileNamepRequired: false, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
                $scope.FileTypes[0].LovId = "";
            }
            else if ($scope.pd !== undefined) {
                copyRes = { HospitalId: $scope.pd.HospitalId, ProjectId: $scope.pd.ProjectId, DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: "", DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
                $scope.FileTypes[0].LovId = "";
            }
            else if ($scope.Tracing !== undefined) {
                copyRes = { HospitalId: $scope.Tracing.HospitalId, TracingId: $scope.Tracing.TracingId, DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: "", DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
                //$scope.FileTypes[0].LovId = "";
            }
            else if ($scope.ProposalCode !== undefined) {
                copyRes = { HospitalId: null, DocumentId: 0, AttachId: 0, GmProposalId: $scope.GmProposalId, AttachmentId: 0, FileName: "", FileType: 551, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
            }
            else if ($scope.AssetAuditFindings !== undefined) {
                copyRes = { HospitalId: null, DocumentId: 0, AttachId: 0, AssetAuditId: $scope.AssetAuditFindings.AssetAuditId, AttachmentId: 0, FileName: "", FileType: "", DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
            }
            else if ($scope.AssetAuditFindingsList !== undefined) {
                copyRes = { HospitalId: null, DocumentId: 0, AttachId: 0, AssetAuditId: $scope.AssetAuditFindingsList.AssetAuditId, AttachmentId: 0, FileName: "", FileType: "", DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
            }
            else if ($scope.warrantySharedData != null && $scope.warrantySharedData != undefined) {
                copyRes = { HospitalId: null, DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: 2835, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
            }
            else if ($scope.Accident != null && $scope.Accident != undefined) {
                copyRes = { HospitalId: null, DocumentId: 0, AccidentIncidentId: $scope.Accident.AccidentIncidentId, AttachmentId: 0, FileName: "", FileType: '', DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
            }
            else if ($scope.TechnicalSupportLetter !== undefined) {
                copyRes = { TechnicalSupportId: $scope.TechnicalSupportLetter.TechnicalSupportId, DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: 551, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: false, isFileNamepRequired: false, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
                //$scope.FileTypes[0].LovId = "";
            }
            else if ($scope.LinenArrangement !== undefined) {
                copyRes = { LinenArrangementId: $scope.LinenArrangement.LinenArrangementId, DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: "", DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
                $scope.FileTypes[0].LovId = "";
                //$scope.FileTypes[1].LovId = 1166;
            }
            else if ($scope.SPPoliciesAttachList !== undefined) {
                copyRes = { DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: "", DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
            }
            else if ($scope.EmCommitteeDetails !== undefined) {
                copyRes = { EnergyManagementId: $scope.EmCommitteeDetails[0].EnergyManagementId, DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: "", DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
            }
            else if ($scope.SpProfileFileAttach != undefined) {
                var copyRes = { HospitalId: null, DocumentId: 0, AttachId: 0, FileName: "", FileType: $scope.FileTypes[0].LovId, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
            }
            else if ($scope.Sp3rProjectsFileAttach != undefined) {
                copyRes = { SP3RProjectId: $scope.Sp3rManagement3rProjects.SP3RProjectId, HospitalId: null, DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: 551, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
            }
            else if ($scope.Sp3rReduceReuseActivityFileAttach != undefined) {
                copyRes = { ReduceReuseId: $scope.Sp3rReduceReuseActivity.ReduceReuseId, HospitalId: null, DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: 551, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
            }
            else if ($scope.Payment != undefined) {
                var copyRes = { Sp3RReceiptId: $scope.Payment.Sp3RReceiptId, HospitalId: null, DocumentId: 0, AttachId: 0, FileName: "", FileType: $scope.FileTypes[0].LovId, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false, IsFileTypeDisabled: true };
                $scope.fileAttachList.push(copyRes);
            }
            else if ($scope.SpIaqDetailFileAttach != undefined) {
                var copyRes = { HospitalId: null, DocumentId: 0, AttachId: 0, FileName: "", FileType: $scope.FileTypes[0].LovId, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
            }
            else if ($scope.DEAudit != undefined) {
                var copyRes = { HospitalId: null, DocumentId: 0, AttachId: 0, FileName: "", FileType: $scope.FileTypes[0].LovId, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
            }
            else if ($scope.ReemReportGen != undefined) {
                var copyRes = { HospitalId: null, DocumentId: 0, AttachId: 0, FileName: "", FileType: $scope.FileTypes[0].LovId, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false, ReemType: $scope.AttachReemTypeId };
                $scope.fileAttachList.push(copyRes);
            }
            else if ($scope.ServiceRequestMst != undefined) {
                var copyRes = { ServiceRequestId: $scope.ServiceRequestId, DocumentId: 0, AttachmentId: 0, FileName: "", FileType: $scope.FileTypes[0].LovId, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, IsDeleted: false, BaseFileModel: model, isFileNamepRequired: true };
                $scope.fileAttachList.push(copyRes);
            }
            else if ($scope.CemReportGenAttach != undefined) {
                var copyRes = { HospitalId: null, DocumentId: 0, AttachId: 0, FileName: "", FileType: $scope.FileTypes[0].LovId, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
            }
            else if ($scope.RC != undefined) {
                var copyRes = { RouteId: null, DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: 551, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
            }
            else if ($scope.ReportId != undefined) {
                var date = new Date().toISOString();
                copyRes = { ReportId: $scope.ReportId, UserRegistrationId: 0, DocumentId: 0, CreatedDate: new Date().toISOString(), AttachId: 0, AttachmentId: 0, FileName: "", FileType: 551, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false, Isolddata: false };
                $scope.fileAttachList.push(copyRes);
            }
            else if ($scope.SpEnergyConsumptionFileAttach != undefined) {
                var copyRes = { HospitalId: null, DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: $scope.FileTypes[0].LovId, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);
            }
            else if ($scope.CommonUpload != undefined) {
                var copyRes = { HospitalId: null, DocumentId: 0, AttachId: 0, FileName: "", FileType: $scope.FileTypes[0].LovId, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsShortDescriptionRequired: true, IsDeleted: false, UploadedPerson: $("#hdnUserName").val() };
                $scope.fileAttachList.push(copyRes);
            }

            else if ($scope.StaffDetails !== undefined) {
                var Attachmentrow = { StaffMasterId: $scope.manpower.StaffMasterId, DocumentId: 0, AttachmentId: 0, FileName: "", FileType: 551, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, IsDeleted: false, BaseFileModel: model, isFileNamepRequired: true, isFileTypeRequired: true };
                $scope.fileAttachList.push(Attachmentrow);
                //$scope.FileTypes[0].LovId = "";
            }
            else if ($scope.CompanyStaffMasterDetails !== undefined) {
                var Attachmentrow = { StaffMasterId: $scope.manpower.StaffMasterId, DocumentId: 0, AttachmentId: 0, FileName: "", FileType: 551, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, IsDeleted: false, BaseFileModel: model, isFileNamepRequired: true, isFileTypeRequired: true };
                $scope.fileAttachList.push(Attachmentrow);
            }
            else if ($scope.TC != undefined && $scope.TC.TestingandCommissioningId !== "" && $scope.TC.TestingandCommissioningId !== 0) {
                var Attachmentrow = { DocumentId: 0, TestingAndcommissioningId: $scope.TC.TestingandCommissioningId, AttachmentId: 0, FileName: "", FileType: "", DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, IsDeleted: false, isFileTypeRequired: true, isFileNamepRequired: true };
                $scope.fileAttachList.push(Attachmentrow);
            }
            else if ($scope.Chemical !== undefined) {
                var Attachmentrow = {
                    ChemicalId: $('#primaryId').val(), DocumentId: 0, AttachmentId: 0, FileName: "", FileType: "", DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, IsDeleted: false, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true,
                };
                $scope.fileAttachList.push(Attachmentrow);
            }
            else if ($scope.TFComplianceTest !== undefined) {
                copyRes = { DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: 551, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);

            }
            else if ($scope.ServiceWorkAttachment !== undefined) {
                copyRes = { DocumentId: 0, AttachId: 0, AttachmentId: 0, WorkOrderId: 0, FileName: "", FileType: 551, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);

            }
            else if ($scope.WasteTreatment !== undefined) {
                copyRes = { DocumentId: 0, AttachId: 0, AttachmentId: 0, WorkOrderId: 0, FileName: "", FileType: 551, DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false };
                $scope.fileAttachList.push(copyRes);

            }
            else {
                copyRes = { HospitalId: null, DocumentId: 0, AttachId: 0, AttachmentId: 0, FileName: "", FileType: "", DownloadName: "", DownloadUrl: "", MajorVersion: 1, MinorVersion: 0, FileKey: "", FileFlag: 0, BaseFileModel: model, isFileTypeRequired: true, isFileNamepRequired: true, IsDeleted: false, Isolddata: false };
                $scope.fileAttachList.push(copyRes);
            }

            $timeout(function () {
                $element[0].querySelector('[is-last=true]').focus();
            });

        }
    };

    $scope.IsFileNameRequired = function (obj) {
        if ($scope.$parent.ScreenName !== undefined) {
            if ($scope.$parent.ScreenName == "AuditPlaning" || $scope.$parent.ScreenName == "Warranty Management") {
                var result;
                if (!($scope.$parent.Audit.ClosureDate == null || $scope.$parent.Audit.ClosureDate == undefined || $scope.$parent.Audit.ClosureDate == "")) {
                    result = true;
                }
                else {
                    result = false;
                }
                if (obj.IsDeleted) {
                    obj.isFileNamepRequired = false;
                    obj.isFileTypeRequired = false;
                }
                else {
                    obj.isFileNamepRequired = result;
                }
            }
        }
    }

    //$scope.IsFileTypeRequired = function (obj) {
    //    if ($scope.$parent.ScreenName !== undefined) {
    //        if ($scope.$parent.ScreenName == "AuditPlaning") {
    //            var result;
    //            if (!($scope.$parent.Audit.ClosureDate == null || $scope.$parent.Audit.ClosureDate == undefined || $scope.$parent.Audit.ClosureDate == "")) {
    //                result = true;
    //            }
    //            else {
    //                result = false;
    //            }
    //            if (obj.IsDeleted) {
    //                obj.isFileTypeRequired = false;
    //                obj.isFileTypeRequired = false;
    //            }
    //            else if(obj.FileName.length > 0) {
    //                obj.isFileTypeRequired = result;
    //            }
    //        }
    //    }
    //}

    /**
    Summary: File upload validate and add file list's. Here,File upload pdf only ,Other type not allowed,
    Single File size 8Mb maximum allowed .
    **/
    //Multiple Delete Mandatory Check
    $scope.MultipleDelete = function (Value, NgCollection) {
        //  var Collection = Enumerable.From(NgCollection).Where("x=>x.IsCheckboxDisabled==false").ToArray();
        var List = $scope.fileAttachList;
        var index = Value.$index;
        var S = List[index];

        if ((!$scope.$parent.Manpowernorms) && (!$scope.$parent.Audit) && (!$scope.$parent.pd)) {
            var SelectedDelete = List.filter(function (ch) { return ch.IsDeleted; }).length;
            var TotalLength = List.length;

            if (SelectedDelete == TotalLength) {
                $scope.isAssetAllSelected = true;
                $('#fileuploadcheck').attr('checked', true);
            }
            else {
                $scope.isAssetAllSelected = false;
                $('#fileuploadcheck').attr('checked', false);
            }
            //if (SelectedDelete >= TotalLength) {
            //    S.IsDeleted = false;
            //    bootbox.alert(Messages.CAN_NOT_DELETE_ALL_RECORDS);
            //}
            //else {
            if (S.IsDeleted == true) {
                $('#FileUploaddel_' + index).addClass('bgDelete');
                //Required Fields
                S.isFileTypeRequired = false;
                S.isFileNamepRequired = false;

                if ($scope.IsShortDescriptionShow == true) {
                    S.IsShortDescriptionRequired = false;
                }
            }
            else {
                $('#FileUploaddel_' + index).removeClass('bgDelete');
                //Required Fields
                S.isFileTypeRequired = true;
                S.isFileNamepRequired = true;
                if ($scope.IsShortDescriptionShow == true) {
                    S.IsShortDescriptionRequired = true;
                }
            }
            //}
        }
        else {
            if (S.IsDeleted == true) {
                $('#FileUploaddel_' + index).addClass('bgDelete');
                //Required Fields
                S.isFileTypeRequired = false;
                S.isFileNamepRequired = false;
                S.IsShortDescriptionRequired = false;
            }
            else {
                $('#FileUploaddel_' + index).removeClass('bgDelete');
                //Required Fields
                S.isFileTypeRequired = true;
                S.isFileNamepRequired = true;
                if ($scope.IsShortDescriptionShow == true) {
                    S.IsShortDescriptionRequired = true;
                }
            }
        }
        // Deselect  - Header Rows
        De_Select();
        SelectAll_DeselectAll(NgCollection, "IsAtttachmentSelected");

        //
    }

    function De_Select() {
        if ($scope.$parent.ScreenName !== undefined) {
            if ($scope.$parent.ScreenName == "AuditPlaning") {
                angular.forEach($scope.fileAttachList, function (files, index) {
                    files.IsShortDescriptionRequired = false;
                });

            }
        }
        if ($scope.$parent.ScreenName == "Warranty Management") {
            angular.forEach($scope.fileAttachList, function (files, index) {
                files.isFileNamepRequired = false;
            });
        }
    }


    $scope.IsHeaderDisable = function () {
        return $('#ActionType').val() == "View" || $('#ActionType').val() == "VIEW" ? true : false;
    }

    $scope.getFileDetails = function (e, index, fileAttach) {
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

    $scope.getFileDetailsSP = function (e, index, fileAttach) {//Function for fileupload upto 50mb per file
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
                function getB64StrSP(buffer) {
                    var bufView = new Uint16Array(buffer);
                    var length = bufView.length;
                    var result = '';
                    var addition = Math.pow(2, 16) - 1;

                    for (var i = 0; i < length; i += addition) {

                        if (i + addition > length) {
                            addition = length - i;
                        }
                        result += String.fromCharCode.apply(null, bufView.subarray(i, i + addition));
                    }
                    return result;
                }
                reader.onloadend = function (evt) {
                    try {
                        actionType = actionType;
                        var verfyobject = actionType.value;
                    }
                    catch (e) {
                        actionType = ActionType;
                    }
                    if (evt.target.readyState == FileReader.DONE) {
                        if (f.type == "application/pdf" || f.type == "application/x-download") {
                            var maxSize = 8388608;//7340032 - 7MB / 8388608 - 8Mb;/52428800 - 50mb
                            var fileSize = f.size; // in bytes
                            if (fileSize > maxSize) {
                                bootbox.alert("File size must be less than 8 MB.");//more than ' + maxSize + ' bytes' + fileSize);
                                $(e).val('');
                                return false;
                            }
                            else {
                                var totalMaxSize = 52428800;//18874368 - 20MB //52428800-50mb
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
                                    bootbox.alert("Total Files size must be less than 50MB.");//more than ' + maxSize + ' bytes' + fileSize);
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
                                            var name = fileAttach.FileName + ".pdf";
                                            var baseName = data.BaseFileModel.fileName;
                                            return name.toUpperCase() == baseName.toUpperCase();
                                        }
                                        else if (actionType.value.toUpperCase() == 'EDIT') {
                                            if (data.BaseFileModel.fileTitle === undefined) {
                                                var name = fileAttach.FileName + ".pdf";
                                                var baseName = data.BaseFileModel.fileName;
                                                return name.toUpperCase() == baseName.toUpperCase();
                                            }
                                            else {
                                                var name = fileAttach.FileName;
                                                var baseName = data.BaseFileModel.fileName;
                                                return name.toUpperCase() == baseName.toUpperCase();
                                            }
                                        }
                                    }
                                });
                                //var filenameconditionCheck = ($scope.IIR == undefined)? FileName.length > 0: false;
                                if (FileName.length > 0) {
                                    bootbox.alert("File name " + fileAttach.FileName + " is already entered.  Please enter different file Name");
                                    $(e).val('');
                                    $scope.$parent.totalSize = $scope.$parent.totalSize - f.size;
                                    $(e).parent().prev().find('input').val('');
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
                                    //var base64String = getB64StrSP(cont);
                                    filename = fileAttach.FileName + ".pdf";
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
                            bootbox.alert("Please upload Pdf file");
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
    /** Summary: Validate row filed's empty **/
    function CheckfileUpload() {
        var flag = false;
        // var attachList = $scope.fileAttachList;
        var attachList = Enumerable.From($scope.fileAttachList)
                                                .Where("$.IsDeleted == false").ToArray();
        console.log($scope.fileAttachList);
        if (attachList.length != 0) {
            $.each(attachList, function (index, data) {
                if ((data.FileName == null || data.FileName == '') || (data.FileType == null || data.FileType == '') || (data.FileFlag == null || data.FileFlag == 0)) {
                    return flag = false;
                }
                else {
                    return flag = true;
                }

            });
            return flag;
        }
        else {
            var attachCount = $scope.fileAttachList.length;
            var attachTrueList = Enumerable.From($scope.fileAttachList)
                                               .Where("$.IsDeleted == true").ToArray();
            if (attachCount == attachTrueList.length) {
                //flag = true;
                $.each(attachTrueList, function (index, data) {
                    if ((data.FileName == null || data.FileName == '') || (data.FileType == null || data.FileType == '') || (data.FileFlag == null || data.FileFlag == 0)) {
                        return flag = true;
                    }
                    else {
                        return flag = true;
                    }

                });
            }
            console.log($scope.fileAttachList);
        }
        return flag;
    }

    function CheckfileOptional() {
        var flag = false;
        var attachList = $scope.fileAttachList;
        console.log($scope.fileAttachList);
        if (attachList != null) {

            $.each(attachList, function (index, data) {
                if (((data.FileName == null || data.FileName == '') || (data.FileType == null || data.FileType == '') || (data.FileFlag == null || data.FileFlag == 0)) && data.IsDeleted == false) {
                    return flag = false;
                }
                else {
                    return flag = true;
                }
            });
            return flag;
        }
        return flag;
    }
    //Download the Attached files
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

    function SelectAll_DeselectAll(NgCollection, Ng_Modal_Name) {
        Select_Grid.Deselect_All_Attachments($scope, NgCollection, Ng_Modal_Name); // these methods comes from Common
    }

    function ValidateNg_Grid(NgCollections) {
        // False  helps to Delete All Rows 
        // True helps you can not Delete All Rows atleast one Row is needed in Grid . Sorry!. You cannot delete all rows
        return Select_Grid.Validate_Ng_Grid_With_Out_Pagination(NgCollections, true);
    }

    $scope.IsSelectAll = function (NgCollections) {
        De_Select();
        Select_Grid.SelectAll_With_Ng_Model($scope, NgCollections, $scope.IsAtttachmentSelected, '#FileUploaddel_'); // its comes from common 


        if ($scope.$parent.ScreenName == "HWMS" || $scope.$parent.FileAttachScreen == "LicenceAndCertificate") {

            angular.forEach(NgCollections, function (S, index) {

                if (S.IsDeleted == true) {
                    $('#FileUploaddel_' + index).addClass('bgDelete');
                    //Required Fields
                    S.isFileTypeRequired = false;
                    S.isFileNamepRequired = false;

                    if ($scope.IsShortDescriptionShow == true) {
                        S.IsShortDescriptionRequired = false;
                    }
                }
                else {
                    $('#FileUploaddel_' + index).removeClass('bgDelete');
                    //Required Fields
                    S.isFileTypeRequired = true;
                    S.isFileNamepRequired = true;
                    if ($scope.IsShortDescriptionShow == true) {
                        S.IsShortDescriptionRequired = true;
                    }
                }
            });
        }

    }

    //Code for LLS-Linen Item Details Screen Attachment:
    /*Because of disable function in file upload*/
    $scope.IsSelectAllForLLS = function (fileAttachList) {
        var AttachmentDetails = Enumerable.From($scope.fileAttachList).Where("x=>x.Used==false").ToArray();
        $scope.IsAtttachmentSelected = undefined;
        if (AttachmentDetails.length != 0) {
            $scope.IsSelectAll(AttachmentDetails);
        }
        else {
            $scope.IsSelectAll(fileAttachList);
        }
    }
    $scope.IsHeaderDisableForLLS = function () {
        var Attachment = Enumerable.From($scope.fileAttachList).Where("x=>x.Used==false").Count();
        if (Attachment != 0) {
            return $('#ActionType').val() == "EDIT" || $('#ActionType').val() == "ADD" ? false : true;
        }
        else {
            return $('#ActionType').val() == "EDIT" || $('#ActionType').val() == "ADD" ? true : false;
        }

    }
    $scope.MultipleDeleteForLLS = function (Value, NgCollection) {
        var AttachmentDetails = Enumerable.From(NgCollection).Where("x=>x.Used==false").ToArray();
        var List = $scope.fileAttachList;
        var index = Value.$index;
        var S = List[index];

        if ((!$scope.$parent.Manpowernorms) && (!$scope.$parent.Audit) && (!$scope.$parent.pd)) {
            var SelectedDelete = List.filter(function (ch) { return ch.IsDeleted && ch.Used == false; }).length;
            var TotalLength = AttachmentDetails.length;

            if (SelectedDelete == TotalLength) {
                $scope.isAllSelected = true;
                $('#fileuploadcheck').attr('checked', true);
            }
            else {
                $scope.IsAtttachmentSelected = false;
                $('#fileuploadcheck').attr('checked', false);
            }
            if (S.IsDeleted == true) {
                $('#FileUploaddel_' + index).addClass('bgDelete');
                //Required Fields
                S.isFileTypeRequired = false;
                S.isFileNamepRequired = false;

                if ($scope.IsShortDescriptionShow == true) {
                    S.IsShortDescriptionRequired = false;
                }
            }
            else {
                $('#FileUploaddel_' + index).removeClass('bgDelete');
                //Required Fields
                S.isFileTypeRequired = true;
                S.isFileNamepRequired = true;
                if ($scope.IsShortDescriptionShow == true) {
                    S.IsShortDescriptionRequired = true;
                }
            }
            //}
        }
        else {
            if (S.IsDeleted == true) {
                $('#FileUploaddel_' + index).addClass('bgDelete');
                //Required Fields
                S.isFileTypeRequired = false;
                S.isFileNamepRequired = false;
                S.IsShortDescriptionRequired = false;
            }
            else {
                $('#FileUploaddel_' + index).removeClass('bgDelete');
                //Required Fields
                S.isFileTypeRequired = true;
                S.isFileNamepRequired = true;
                if ($scope.IsShortDescriptionShow == true) {
                    S.IsShortDescriptionRequired = true;
                }
            }
        }
        // Deselect  - Header Rows
        De_Select();
        SelectAll_DeselectAll(AttachmentDetails, "IsAtttachmentSelected");
    }

    $scope.IsSelectAllSubList = function (NgCollections, value) {
        //var s=  $("#DeleteAll").val;
        var Attachment = Enumerable.From(NgCollections).Where("x=>x.Used==false").ToArray();
        if (value == true) {
            angular.forEach(Attachment, function (data, Index) {
                data.IsDeleted = true;
                data.isFileTypeRequired = false;
                data.isFileNamepRequired = false;
                data.IsShortDescriptionRequired = false;
            });
        }
        else {
            angular.forEach(Attachment, function (data, Index) {
                data.IsDeleted = false;
                data.isFileTypeRequired = true;
                data.isFileNamepRequired = true;
                data.IsShortDescriptionRequired = true;
            });

        }

    }
    /*End -LLS Linen Item Details Screen Attachment*/
});