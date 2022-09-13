var BindFetchEventsForResponsiblePerson = null;
var LovValues = {};
var BindDateTimePicker;
var SetPaginationValues;
var BindEvensForCheckBox;
var BindFetchEventsForPerson;

var companyRepresentativeAssigneeSearchObj = null;
var companyRepresentativeIssuerSearchObj = null;
var companyRepresentativeVerifierSearchObj = null;
var followupCARSearchObj = null;
var AddnewRowClicked = null;

FailureSymptomCodeLovs = [];
FromNotification = false;
GlobalIndicators = [];
GlobalSelectedIndicators = [];

$(document).ready(function ()
{
    $('#errorMsg').css('visibility', 'hidden');
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnApprove').hide();
    $('#btnReject').hide();
    $('#myPleaseWait').modal('show');

    formInputValidation("frmCorrectiveActionReport");

            $.get("/api/correctiveActionReport/Load")
            .done(function(result) {
                var loadResult = JSON.parse(result);
                $.each(loadResult.Indicators, function (index, value) {
                    $('#selQAPIndicatorId2, #selQAPIndicatorIdHistory').append('<option value="' + value.LovId + '">' +value.FieldValue + '</option>');
                });
                
                   $.each(loadResult.ServiceData, function (index, value) {
                    $('#ServiceId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                });
                GlobalIndicators = loadResult.Indicators;
                GlobalSelectedIndicators = loadResult.SelectedIndicators;

                $.each(loadResult.SelectedIndicators, function (index, value) {
                    $('#selQAPIndicatorId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                });

                $.each(loadResult.QAPPriorityValue, function (index, value) {
                    $('#selPriorityLovId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                });
                $.each(loadResult.QAPStatusValue, function (index, value) {
                    $('#selStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                });
                $.each(loadResult.Responsibilities, function (index, value) {
                    $('#selResponsibilityId_0').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                });

                LovValues.Responsibilities = loadResult.Responsibilities;

                FailureSymptomCodeLovs = loadResult.FailureSymptomCodes;
                
                $('#selStatus').val(300);
                $('#selStatus').attr('disabled', true);
                $('#txtTypeOfCAR').val('Manual CAR');

                $('#txtFollowupCARNo').attr('disabled', true);
                $('#spnPopup-followupCAR').hide();

                DisableVerifyFields();

                DisableGridFieldsForSubmit();
            })
  .fail(function(response) {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
      $('#errorMsg').css('visibility', 'visible');
});


    SetPaginationValues = function(result) {
        var PageIndex = 0;
        var TotalRecords = 0;
        var FirstRecord = 0;
        var LastRecord = 0;
        var LastPageIndex = 0;

        var firstObject = $.grep(result, function (value0, index0) {
            return index0 == 0;
        });
        PageIndex = firstObject[0].PageIndex;
        PageSize = firstObject[0].PageSize;
        TotalRecords = firstObject[0].TotalRecords;
        FirstRecord = firstObject[0].FirstRecord;
        LastRecord = firstObject[0].LastRecord;
        LastPageIndex = firstObject[0].LastPageIndex;

        if (PageIndex == 1) {
            $('#btnPreviousPage').removeClass('pagerEnabled');
            $('#btnPreviousPage').addClass('pagerDisabled');
            $('#btnFirstPage').removeClass('pagerEnabled');
            $('#btnFirstPage').addClass('pagerDisabled');
            }
            else {
            $('#btnPreviousPage').removeClass('pagerDisabled');
            $('#btnPreviousPage').addClass('pagerEnabled');
            $('#btnFirstPage').removeClass('pagerDisabled');
            $('#btnFirstPage').addClass('pagerEnabled');
            }
        if (PageIndex == LastPageIndex) {
            $('#btnNextPage').removeClass('pagerEnabled');
            $('#btnNextPage').addClass('pagerDisabled');
            $('#btnLastPage').removeClass('pagerEnabled');
            $('#btnLastPage').addClass('pagerDisabled');
            }
            else {
            $('#btnNextPage').removeClass('pagerDisabled');
            $('#btnNextPage').addClass('pagerEnabled');
            $('#btnLastPage').removeClass('pagerDisabled');
            $('#btnLastPage').addClass('pagerEnabled');
            }

        $('#spnTotalRecords').text(TotalRecords);
        $('#spnFirstRecord').text(FirstRecord);
        $('#spnLastRecord').text(LastRecord);
        $('#spnTotalPages').text(LastPageIndex);
        $('#txtPageIndex').val(PageIndex);
        $('#hdnPageIndex').val(PageIndex);
        $('#selPageSize').val(PageSize);
        AttachPaginationEvents(LastPageIndex);
}

function AttachPaginationEvents(LastPageIndex) {
    $('#btnPreviousPage').unbind("click");
    $('#btnNextPage').unbind("click");
    $('#btnFirstPage').unbind("click");
    $('#btnLastPage').unbind("click");

    $('#btnPreviousPage, #btnNextPage, #btnFirstPage, #btnLastPage').click(function () {
        var id = $(this).attr('id');

    var currentPageIndex = parseInt($('#hdnPageIndex').val());
        if(id == "btnPreviousPage") {
                currentPageIndex -= 1;
        }
        else if (id == "btnNextPage") {
             currentPageIndex += 1;
             }
             else if(id == "btnFirstPage") {
            currentPageIndex = 1;
            }
            else if (id == "btnLastPage") {
            currentPageIndex = LastPageIndex;
        }
        PopulatePaginationGrid(currentPageIndex);
        });

    $('#txtPageIndex').on("keypress", function (e) {
        if (e.keyCode == 13) {
            var pageindex1 = $('#txtPageIndex').val();
            if (pageindex1 == null || pageindex1 == '' || isNaN(pageindex1)) {
                bootbox.alert('Please enter valid page number.');
                $('#txtPageIndex').val($('#hdnPageIndex').val());
                return false;
                } else {
                pageindex1 = parseInt(pageindex1);
                if(pageindex1 > LastPageIndex) {
                    bootbox.alert('Please enter valid page number.');
                    $('#txtPageIndex').val($('#hdnPageIndex').val());
                    return false;
                } else {
                    PopulatePaginationGrid(pageindex1);
                    }
                 }
                }
                });

                    $('#selPageSize').on('change', function () {
                    PopulatePaginationGrid(1);
           });
           }

    function PopulatePaginationGrid(pageIndex)
    {
        var pageSize = $('#selPageSize').val();
        var id = $('#primaryID').val();
        $('#myPleaseWait').modal('show');
        $.get("/api/correctiveActionReport/Get/" + id + "/" + pageIndex + "/" +pageSize)
        .done(function (response) {
             var result = JSON.parse(response);

         //if (result1 != null && result1.Transactions != null && result1.Transactions.length > 0) {
                //var result = result1.Transactions;
                //var firstObject = $.grep(result, function (value0, index0) {
                //    return index0 == 0;
                //});
                //$('#primaryID').val(firstObject[0].DedTxnMappingId);

            //BindData(result);
             BindGridRecords(result);

                //$('#divPagination').html(null);
                //    $('#divPagination').html(paginationString);
                //    SetPaginationValues(result);
                //}
                $('#myPleaseWait').modal('hide');
         })
      .fail(function (response) {
        $('#myPleaseWait').modal('hide');
        $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
        $('#errorMsg2').css('visibility', 'visible');
        });
        }

    
    function DisplayErrorMessage(errorMessage, id, currentbtnId) {
        $("div.errormsgcenter").text(errorMessage);
        $('#errorMsg').css('visibility', 'visible');

        //$('#btnSave').attr('disabled', false);
        //$('#btnEdit').attr('disabled', false);
        //$('#btnSaveandAddNew').attr('disabled', false);
        $('#' + currentbtnId).attr('disabled', false);
        $('#' + id).parent().addClass('has-error');
    }

 $("#btnSave,#btnEdit,#btnSaveandAddNew,#btnApprove,#btnReject").click(function () {// #btnEdit,
        //$('#btnSave').attr('disabled', true);
        //$('#btnEdit').attr('disabled', true);
        //$('#btnSaveandAddNew').attr('disabled', true);
     var currentbtnId = $(this).attr("Id");
     $('#' + currentbtnId).attr('disabled', true);
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        //var failureSymptomId = $('#hdnFailureSymptomId').val();
        //var failureSymptomCode = $('#txtFailureSymptomCode').val();
        //if (failureSymptomId == '' && failureSymptomCode != '') {
        //    DisplayErrorMessage("Please enter valid Failure Symptom Code", 'txtFailureSymptomCode', currentbtnId);
        //    return false;
        //}

        var followupCARId = $('#hdnFollowupCARId').val();
        var followupCARCode = $('#txtFollowupCARNo').val();
        if (followupCARId == '' && followupCARCode != '') {
            DisplayErrorMessage("Please enter valid Follow-up CAR", 'txtFollowupCARNo', currentbtnId);
            return false;
        }

        var assigneeId = $('#hdnAssignedUserId').val();
        var assigneeName = $('#txtAssignee').val();
        if(assigneeId == '' && assigneeName != '') {
            DisplayErrorMessage("Please enter valid Assignee", 'txtAssignee', currentbtnId);
            return false;
        }

        var issuerId = $('#hdnIssuerUserId').val();
        var issuerName = $('#txtIssuer').val();
        if(issuerId == '' && issuerName != '') {
            DisplayErrorMessage("Please enter valid Issuer", 'txtIssuer', currentbtnId);
            return false;
        }

        var verifiedById = $('#hdnVerifiedBy').val();
        var verifiedByName = $('#txtVerifiedBy').val();
        if(verifiedById == '' && verifiedByName != '') {
            DisplayErrorMessage("Please enter valid Verified By", 'txtVerifiedBy', currentbtnId);
            return false;
        }

        var isResponsiblePersonInvalid = false;
        $('#tableActivities tr').each(function (index, value)
        {
        if (isResponsiblePersonInvalid) {
        return;
        }
        var responsiblePersonId = $('#hdnResponsiblePersonUserId_' + index).val();
        var responsiblePersonName = $('#txtResponsiblePerson_' + index).val();
        if(responsiblePersonId == '' && responsiblePersonName != '') {
            isResponsiblePersonInvalid = true;
            DisplayErrorMessage("Please enter valid Responsible Person", 'txtResponsiblePerson_' + index, currentbtnId);
            return false;
        }
        });
        if (isResponsiblePersonInvalid) {
        return false;
        }

        var isFormValid = formInputValidation("frmCorrectiveActionReport", 'save');
        if (!isFormValid)
        {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            //$('#btnSave').attr('disabled', false);
            //$('#btnEdit').attr('disabled', false);
            //$('#btnSaveandAddNew').attr('disabled', false);
            $('#' + currentbtnId).attr('disabled', false);
            return false;
        }

        var allChecked = $('#chkActivitiesDeleteAll').prop('checked');
        var totalPages = $('#spnTotalPages').text();

        if ((totalPages == 1 || totalPages == '')  && allChecked) {
            bootbox.alert(Messages.CAN_NOT_DELETE_ALL_RECORDS);

            //$('#btnSave').attr('disabled', false);
            //$('#btnEdit').attr('disabled', false);
            //$('#btnSaveandAddNew').attr('disabled', false);
            $('#' + currentbtnId).attr('disabled', false);
            return false;
        }
       
        var CARAcitvity = [];

        var saveObj = {
                QAPIndicatorId: $('#selQAPIndicatorId').val(),
                CARDate: $('#txtCARDate').val(),
                FromDate: $('#txtFromDate').val(),
                ToDate: $('#txtToDate').val(),
               // FailureSymptomId: $('#hdnFailureSymptomId').val(),
                FollowupCARId: $('#hdnFollowupCARId').val(),
                AssignedUserId: $('#hdnAssignedUserId').val(),
                ProblemStatement: $('#txtProblemStatement').val(),
                RootCause: $('#txtRootCause').val(),
                Solution: $('#txtSolution').val(),
                PriorityLovId: $('#selPriorityLovId').val(),
                Status: $('#selStatus').val(),
                IssuerUserId: $('#hdnIssuerUserId').val(),
                CARTargetDate: $('#txtCARTargetDate').val(),
                VerifiedDate: $('#txtVerifiedDate').val(),
                VerifiedBy: $('#hdnVerifiedBy').val(),
                Remarks: $('#txtRemarks').val(),
        };

        var isRecordSelectedForDelete = false;

        $('#tableActivities tr').each(function (index, value) {
             if (index == 0) return;
            var index1 = index -1;

            var isDeleted = $('#chkActivitiesDelete_' + index1).prop('checked');
            if (isDeleted) {
                isRecordSelectedForDelete = true;
            }
            var carDetId = $('#hdnCarDetId_' + index1).val();
            if (!isDeleted || (isDeleted && carDetId != null && carDetId != '')) {
            CARAcitvity.push({
                CarDetId: $('#hdnCarDetId_' + index1).val(),
                CarId: $('#primaryID').val(),
                Activity: $('#txtActivity_' + index1).val(),
                StartDate: $('#txtStartDate_' + index1).val(),
                TargetDate: $('#txtTargetDate_' + index1).val(),
                CompletedDate: $('#txtCompletedDate_' + index1).val(),
                ResponsibilityId: $('#selResponsibilityId_' + index1).val(),
                ResponsiblePersonUserId: $('#hdnResponsiblePersonUserId_' + index1).val(),
                IsDeleted: $('#chkActivitiesDelete_' + index1).prop('checked')
            });
        }
        });
            saveObj.activities = CARAcitvity;

            var primaryId = $("#primaryID").val();
            if (primaryId != null) {
                saveObj.CarId = primaryId;
                saveObj.Timestamp = $('#hdnTimestamp').val();
            }
            else {
                saveObj.CarId = 0;
                saveObj.Timestamp = "";
            }
            if (currentbtnId == 'btnSave' || currentbtnId == 'btnSaveandAddNew' || currentbtnId == 'btnEdit') {
                saveObj.CarStatus = 367;
            } else if (currentbtnId == 'btnApprove') {
                saveObj.CarStatus = 369;
                saveObj.Status = 301;
            } else if (currentbtnId == 'btnReject') {
                saveObj.CarStatus = 368;
                saveObj.Status = 301;
            }

            if (isRecordSelectedForDelete) {
                var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
                bootbox.confirm(message, function (result) {
                    if (result) {
                        SaveCAR(saveObj, currentbtnId);
                    } else {
                        //$('#btnSave').attr('disabled', false);
                        //$('#btnEdit').attr('disabled', false);
                        //$('#btnSaveandAddNew').attr('disabled', false);
                        $('#' + currentbtnId).attr('disabled', false);
                    }
                });
            }
            else {
                SaveCAR(saveObj, currentbtnId);
            }
        });

        function SaveCAR(saveObj, currentbtnId)
        {
                $('#myPleaseWait').modal('show');
                var jqxhr = $.post("/api/correctiveActionReport/Save", saveObj, function (response) {
                var result = JSON.parse(response);
                $("#primaryID").val(result.CarId);
                $("#hdnTimestamp").val(result.Timestamp);
                $('#txtCARNumber').val(result.CARNumber);
                $('#hdnAttachId').val(result.HiddenId);
                $('#hdnIsAutoCarEdit').val(result.IsAutoCarEdit);
                $('#hdnCARStatus').val(result.CARStatus);
                $('#divCARStatusName').text(result.CARStatusValue);
                $('#selStatus').val(saveObj.Status);

                var carStatus = saveObj.CarStatus;
                if (carStatus != 369 && carStatus != 368) {
                    $('#txtRootCause').val('');
                    $('#txtSolution').val('');
                    $('#txtRemarks').val('');
                }

                $("#grid").trigger('reloadGrid');
                BindGridRecords(result);
               
                EnableDisable(saveObj.CarStatus);

                if (carStatus == 367) {
                    EnableGridFieldsForApproveReject();
                    EnableVerifyFields();
                } else {
                    $('#spnPopup-VerifiedBy').hide();
                }

                $(".content").scrollTop(0);
                showMessage('', CURD_MESSAGE_STATUS.SS);
                $('#' + currentbtnId).attr('disabled', false);

                $('#myPleaseWait').modal('hide');
                if (currentbtnId == "btnSaveandAddNew") {
                    ClearFields();
                } 
            },
      "json")
       .fail(function (response) {
           var errorMessage = "";
           if (response.status == 400) {
               errorMessage = response.responseJSON;
           }
           else {
               errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
           }
           $("div.errormsgcenter").text(errorMessage);
           $('#errorMsg').css('visibility', 'visible');
           $('#' + currentbtnId).attr('disabled', false);
           $('#myPleaseWait').modal('hide');
       });
    }

    //------------------------Search----------------------------
    companyRepresentativeAssigneeSearchObj = {
        Heading: "Assignee Details",//Heading of the popup
        SearchColumns: ['StaffName-Staff Name'],//ModelProperty - Space seperated label value
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name'],//Columns to be returned for display
        FieldsToBeFilled: ["hdnAssignedUserId-StaffMasterId", "txtAssignee-StaffName"]//id of element - the model property--, , 
    };

    $('#spnPopup-Assignee').click(function () {
        DisplaySeachPopup('divSearchPopup', companyRepresentativeAssigneeSearchObj, "/api/Search/CompanyStaffSearch");
    });
    companyRepresentativeIssuerSearchObj = {
        Heading: "Issuer Details",//Heading of the popup
        SearchColumns: ['StaffName-Staff Name'],//ModelProperty - Space seperated label value
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name'],//Columns to be returned for display
        FieldsToBeFilled: ["hdnIssuerUserId-StaffMasterId", "txtIssuer-StaffName"]//id of element - the model property--, , 
    };

    $('#spnPopup-Issuer').click(function () {
        DisplaySeachPopup('divSearchPopup', companyRepresentativeIssuerSearchObj, "/api/Search/CompanyStaffSearch");
    });
    companyRepresentativeVerifierSearchObj = {
        Heading: "Verifier Details",//Heading of the popup
        SearchColumns: ['StaffName-Staff Name'],//ModelProperty - Space seperated label value
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name'],//Columns to be returned for display
        FieldsToBeFilled: ["hdnVerifiedBy-StaffMasterId", "txtVerifiedBy-StaffName"]//id of element - the model property--, , 
    };

    $('#spnPopup-VerifiedBy').click(function () {
        DisplaySeachPopup('divSearchPopup', companyRepresentativeVerifierSearchObj, "/api/Search/CompanyStaffSearch");
    });
    //failureSymptomCodeSearchObj = {
    //    Heading: "Filure Symptom Code Details",//Heading of the popup
    //    SearchColumns: ['FailureSymptomCode-Failure Symptom Code'],//ModelProperty - Space seperated label value
    //    ResultColumns: ["QualityCauseId-Primary Key", 'FailureSymptomCode-Failure Symptom Code'],//Columns to be returned for display
    //    FieldsToBeFilled: ["hdnFailureSymptomId-QualityCauseId", "txtFailureSymptomCode-FailureSymptomCode"]//id of element - the model property--, , 
    //};

    //$('#spnPopup-failureSymptomCode').click(function () {
    //    DisplaySeachPopup('divSearchPopup', failureSymptomCodeSearchObj, "/api/Search/FilureSymptomCodeFetch");
    //});
    followupCARSearchObj = {
        Heading: "Follow-up CAR Details",//Heading of the popup
        SearchColumns: ['CARNumber-CAR Number'],//ModelProperty - Space seperated label value
        ResultColumns: ["CarId-Primary Key", 'CARNumber-CAR Number'],//Columns to be returned for display
        AdditionalConditions: ["CarIdOriginal-primaryID", "IndicatorId-selQAPIndicatorId"],
        FieldsToBeFilled: ["hdnFollowupCARId-CarId", "txtFollowupCARNo-CARNumber", "txtFromDate-FromDate", "txtToDate-ToDate"]
    };

    $('#spnPopup-followupCAR').click(function () {
        DisplaySeachPopup('divSearchPopup', followupCARSearchObj, "/api/Search/FollowupCarFetch");
    });
    //----------------------------------------------------------

    //------------------------Fetch-----------------------------

    var companyRepresentativeAssigneeFetchObj = {
        SearchColumn: 'txtAssignee-StaffName',
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name'],
        FieldsToBeFilled: ["hdnAssignedUserId-StaffMasterId", "txtAssignee-StaffName"]
    };

    $('#txtAssignee').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divAssignee', companyRepresentativeAssigneeFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch1", event, 1);//1 -- pageIndex
    });
    var companyRepresentativeIssuerFetchObj = {
        SearchColumn: 'txtIssuer-StaffName',
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name'],
        FieldsToBeFilled: ["hdnIssuerUserId-StaffMasterId", "txtIssuer-StaffName"]
    };

    $('#txtIssuer').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divIssuer', companyRepresentativeIssuerFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch2", event, 1);//1 -- pageIndex
    });

    var companyRepresentativeVerifierFetchObj = {
        SearchColumn: 'txtVerifiedBy-StaffName',
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name'],
        FieldsToBeFilled: ["hdnVerifiedBy-StaffMasterId", "txtVerifiedBy-StaffName"]
    };

    $('#txtVerifiedBy').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divVerifiedBy', companyRepresentativeVerifierFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch3", event, 1);//1 -- pageIndex
    });
    //var failureSymptomCodeFetchObj = {
    //    SearchColumn: 'txtFailureSymptomCode-FailureSymptomCode',
    //    ResultColumns: ["QualityCauseId-Primary Key", 'FailureSymptomCode-Failure Symptom Code'],
    //    FieldsToBeFilled: ["hdnFailureSymptomId-QualityCauseId", "txtFailureSymptomCode-FailureSymptomCode"]
    //};

    //$('#txtFailureSymptomCode').on('input propertychange paste keyup', function (event) {
    //    DisplayFetchResult('divFailureSymptonCodeFetch', failureSymptomCodeFetchObj, "/api/Fetch/FilureSymptomCodeFetch", "UlFetch4", event, 1);//1 -- pageIndex
    //});
    var followupCARFetchObj = {
        SearchColumn: 'txtFollowupCARNo-CARNumber',
        ResultColumns: ["CarId-Primary Key", 'CARNumber-CAR Number'],
        AdditionalConditions: ["CarIdOriginal-primaryID", "IndicatorId-selQAPIndicatorId"],
        FieldsToBeFilled: ["hdnFollowupCARId-CarId", "txtFollowupCARNo-CARNumber", "txtFromDate-FromDate", "txtToDate-ToDate"]
    };

    $('#txtFollowupCARNo').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFollowupCARId', followupCARFetchObj, "/api/Fetch/FollowupCarFetch", "UlFetch5", event, 1);//1 -- pageIndex
    });
    //--------------------------------------------------------------------
    //-------------------------------------------Asset No Grid ---------------------------------

    AddnewRowClicked = function() {
        $("div.errormsgcenter").text('');
        $('#errorMsg').css('visibility', 'hidden');

        var errorMessage = '';

        $('#tableActivities tr').each(function (index, value) {
            if (index == 0) return;
            var index1 = index - 1;

            if (!tableInputValidation('tableActivities', 'save', 'chkActivitiesDelete')) {
                errorMessage = Messages.ENTER_VALUES_EXISTING_ROW;
                }
                });
        if (errorMessage != '') {
            bootbox.alert(errorMessage);
            return false;
            }
        else {
            $('#chkActivitiesDeleteAll').prop('checked', false);
            var index1 = $('#tableActivities tr').length - 1;
            var tableRow = '<tr>' +
                           '<td width="5%" style="text-align:center">' +
                           '<input type="checkbox" id="chkActivitiesDelete_' + index1 + '" />' +
                           '<input type="hidden" id="hdnCarDetId_' + index1 + '"/></td>' +
                           '<td width="20%"><input id="txtActivity_' +index1 + '" class="form-control" type="text"  maxlength="500" required/></td>' +
                           '<td width="14%"><input id="txtStartDate_' +index1 + '" class="form-control datatimeNoFuture" type="text" maxlength="11" required /></td>' +
                           '<td width="14%"><input id="txtTargetDate_' +index1 + '" class="form-control dateAll" type="text" maxlength="11" required/></td>' +
                           '<td width="17%"><input id="txtCompletedDate_' +index1 + '" class="form-control dateAll" type="text" maxlength="11" required/></td>' +
                           '<td width="15%"><select id="selResponsibilityId_' +index1 + '" class="form-control" required><option value="null">Select</option></select></td>' +
                           '<td width="15%"><input type="text" id="txtResponsiblePerson_' + index1 + '" class="form-control" placeholder="Please Select" maxlength="75" autocomplete="off" pattern="^[a-zA-Z0-9\\-\\(\\)\\/\\s]+$" required disabled/>' +
                           '<input type="hidden" id="hdnResponsiblePersonUserId_' + index1 + '" required/><div class="col-sm-12" id="divResponsiblePersonFetch_' + index1 + '"></div>' +
                           '</td></tr>';
                               $('#tableActivities > tbody').append(tableRow);
                               $("#txtActivity_" + index1).attr('pattern', '^[a-zA-Z0-9\'.\'\",:;/\\(\\),\\-\\s!@#$%*"&]+$');
          
                               $.each(LovValues.Responsibilities, function(index2, value2) {
                                    $('#selResponsibilityId_' + index1).append('<option value="' +value2.LovId + '">' +value2.FieldValue + '</option>');
                                    });

                               //$('#UlPersonFetch_' + index1).css('display', 'block');
            BindFetchEventsForPerson();
            BindEvensForCheckBox();
            BindDateTimePicker();
            BindEventsForResponsibility();
            tableInputValidation('tableActivities');
            $('#txtActivity_' +index1).focus();

            var carStatus = $('#divCARStatusName').text();
            if (carStatus == null || carStatus == '') {
                DisableGridFieldsForSubmit();
            }
            //var status = $('#selStatus').val();
            //if (status == 300) {
            //    DisableGridFieldsForSubmit();
            //} else if (status == 301) {
            //    EnableGridFieldsForApproveReject();
            //}
         }
        }

    $('#anchorActivitiesAddNew').unbind('click');
    $('#anchorActivitiesAddNew').click(AddnewRowClicked);

    BindFetchEventsForPerson = function () {
        $("input[id^='txtResponsiblePerson_']").unbind('input propertychange paste keyup');
        tableInputValidation('tableActivities');
        $("input[id^='txtResponsiblePerson_']").on('input propertychange paste keyup', function (event) {
            var index = $(this).attr('id').split('_')[1];
            if (index > 0) {
                if ($('#divResponsiblePersonFetch_' + index + ' .not-found').length && index == 0) {
                    $('#divResponsiblePersonFetch_' + index).css({
                        'top': 0,
                        'width': $('#txtResponsiblePerson_' + index).outerWidth()
                    });
                } else {
                    $('#divResponsiblePersonFetch_' + index).css({
                        'top': $('#txtResponsiblePerson_' + index).offset().top - $('#tableActivities').offset().top + $('#txtResponsiblePerson_' + index).innerHeight(),
                        'width': $('#txtResponsiblePerson_' + index).outerWidth()
                    });
                }
            }
            else {
                $('#divResponsiblePersonFetch_' + index).css({
                    'width': $('#txtResponsiblePerson_' + index).outerWidth()
                });
            }

            var personFetchObj = {
                SearchColumn: 'txtResponsiblePerson_' + index + '-StaffName',
                ResultColumns: ['StaffMasterId-Primary Key', 'StaffName-Staff Name'],
                FieldsToBeFilled: ['hdnResponsiblePersonUserId_' + index + '-StaffMasterId', 'txtResponsiblePerson_' + index + '-StaffName']
            };
            var responsibilityId1 = $('#selResponsibilityId_' + index).val();
            if(responsibilityId1 == 333) {
                DisplayFetchResult('divResponsiblePersonFetch_' + index, personFetchObj, "/api/Fetch/CompanyStaffFetch", "UlPersonFetch_" + index + "", event, 1);
            } else if (responsibilityId1 == 334) {
               DisplayFetchResult('divResponsiblePersonFetch_' + index, personFetchObj, "/api/Fetch/FacilityStaffFetch", "UlPersonFetch_" +index + "", event, 1);
            }
        });
    }

    $('#chkActivitiesDeleteAll').on('click', function () {
        var isChecked = $(this).prop("checked");
        var index1;
        $('#tableActivities tr').each(function (index, value) {
            if (index == 0) return;
            index1 = index - 1;
            if (isChecked) {
                $('#chkActivitiesDelete_' + index1).prop('checked', true);
                $('#chkActivitiesDelete_' + index1).parent().addClass('bgDelete');

                $('#txtActivity_' +index1).removeAttr('required');
                $('#txtStartDate_' + index1).removeAttr('required');
                $('#txtTargetDate_' +index1).removeAttr('required');
                $('#txtCompletedDate_' +index1).removeAttr('required');
                $('#selResponsibilityId_' +index1).removeAttr('required');
                $('#txtResponsiblePerson_' + index1).removeAttr('required');
                $('#hdnResponsiblePersonUserId_' +index1).removeAttr('required');

                $('#txtActivity_' +index1).parent().removeClass('has-error');
                $('#txtStartDate_' +index1).parent().removeClass('has-error');
                $('#txtTargetDate_' +index1).parent().removeClass('has-error');
                $('#txtCompletedDate_' +index1).parent().removeClass('has-error');
                $('#selResponsibilityId_' +index1).parent().removeClass('has-error');
                $('#txtResponsiblePerson_' +index1).parent().removeClass('has-error');
            }
            else {
                $('#chkActivitiesDelete_' + index1).prop('checked', false);
                $('#chkActivitiesDelete_' + index1).parent().removeClass('bgDelete');

                $('#txtActivity_' +index1).attr('required', true);
                $('#txtStartDate_' + index1).attr('required', true);
                $('#txtTargetDate_' + index1).attr('required', true);
                $('#txtCompletedDate_' + index1).attr('required', true);
                $('#selResponsibilityId_' + index1).attr('required', true);
                $('#txtResponsiblePerson_' + index1).attr('required', true);
                $('#hdnResponsiblePersonUserId_' +index1).attr('required', true);
            }
        });
    });

    BindEvensForCheckBox = function () {
        $("input[id^='chkActivitiesDelete_']").unbind('click');
        $("input[id^='chkActivitiesDelete_']").on('click', function () {
            var index2 = $(this).attr('id').split('_')[1];
            var allChecked = true;
            var isChecked = $(this).prop('checked');
            if (isChecked) {
                $(this).parent().addClass('bgDelete');

                $('#txtActivity_' +index2).removeAttr('required');
                $('#txtStartDate_' +index2).removeAttr('required');
                $('#txtTargetDate_' +index2).removeAttr('required');
                $('#txtCompletedDate_' +index2).removeAttr('required');
                $('#selResponsibilityId_' +index2).removeAttr('required');
                $('#txtResponsiblePerson_' + index2).removeAttr('required');
                $('#hdnResponsiblePersonUserId_' +index2).removeAttr('required');

                $('#txtActivity_' +index2).parent().removeClass('has-error');
                $('#txtStartDate_' +index2).parent().removeClass('has-error');
                $('#txtTargetDate_' +index2).parent().removeClass('has-error');
                $('#txtCompletedDate_' +index2).parent().removeClass('has-error');
                $('#selResponsibilityId_' +index2).parent().removeClass('has-error');
                $('#txtResponsiblePerson_' +index2).parent().removeClass('has-error');
            }
            else {
                $(this).parent().removeClass('bgDelete');

                $('#txtActivity_' + index2).attr('required', true);
                $('#txtStartDate_' +index2).attr('required', true);
                $('#txtTargetDate_' +index2).attr('required', true);

                //var status = $('#selStatus').val();
                //if (status == 301) {
                    $('#txtCompletedDate_' +index2).attr('required', true);
                    $('#selResponsibilityId_' +index2).attr('required', true);
                    $('#txtResponsiblePerson_' +index2).attr('required', true);
                    $('#hdnResponsiblePersonUserId_' +index2).attr('required', true);
                //}
                
            }
            var id = $(this).attr('id');
            var index1;
            $('#tableActivities tr').each(function (index, value) {
                if (index == 0) return;
                index1 = index - 1;
                if (!$('#chkActivitiesDelete_' + index1).prop('checked')) {
                    allChecked = false;
                }
            });
            if (allChecked) {
                $('#chkActivitiesDeleteAll').prop('checked', true);
            }
            else {
                $('#chkActivitiesDeleteAll').prop('checked', false);
            }
        });
    }
    BindFetchEventsForPerson();
    BindEvensForCheckBox();
    BindEventsForResponsibility();

    BindDateTimePicker = function () {
     $('.datatimeNoFuture').datetimepicker({
        maxDate: Date(),
        format: 'd-M-Y',
        timepicker: false,
        step: 15,
        onChangeDateTime: function (dp, $input) {
            if ($input.val() !== "")
                $($input).parent().removeClass('has-error');
        },
        scrollInput: false
     });

 $('.dateAll').datetimepicker({
        //minDate: Date(),
        format: 'd-M-Y',
        timepicker: false,
        onChangeDateTime: function (dp, $input) {
            if ($input.val() !== "") {
                $($input).parent().removeClass('has-error');
                $input.val(ReplaceInvalidMinute($input.val()));
            }
        },
        scrollInput: false
    });

$('.datatimeNoFuture, .datatimeFuture, .datetimePastOnly, .datatimeAll, .dateAll').blur(function () {
        var id = $(this).attr('id');
        var m_names = {"Jan":1, "Feb":2, "Mar":3, "Apr":4, "May":5, "Jun":6, "Jul":7, "Aug":8, "Sep":9, "Oct":10, "Nov":11, "Dec":12};
        var vala = $('#' + id).val();
        var actualval= vala.split(' ');
        var bits = actualval[0].split('-');
        var d = new Date(bits[2] + '-' + m_names[bits[1]] + '-' + bits[0]);
        // return ;

        if (actualval[1]) {
            var actualvalue = actualval[1].split(':') ;//? actualval[1].split(':') : '';
           // var hours = actualvalue[0]
            var condition = (!!actualvalue[0] && !!actualvalue[1] && !!parseInt(actualvalue[0]) && (!!parseInt(actualvalue[1]) || actualvalue[1]=="00") && (parseInt(actualvalue[0]) < 24) && (actualvalue[1] < 61));
            if (!!(d && (d.getMonth() + 1) == m_names[bits[1]] && d.getDate() == Number(bits[0])) && condition) {
                $('#' + id).val(vala);
                // alert(vala);

            }
            else {
                $('#' + id).val('');
            }
        }
        else {

            if (!!(d && (d.getMonth() + 1) == m_names[bits[1]] && d.getDate() == Number(bits[0]))) {
                $('#' + id).val(vala);
                // alert(vala);

            }
            else {
                $('#' + id).val('');
            }
        }

    });

}

    function ReplaceInvalidMinute(dateTimeValue)
    {
        var indexOfColon = dateTimeValue.indexOf(':');
        var substr = dateTimeValue.substring(indexOfColon + 1);
        if (parseInt(substr) >= 60) {
            dateTimeValue = dateTimeValue.replace(substr, "00");
        }
        return dateTimeValue;
    }

    $("#btnCancel").click(function () {
        var message = Messages.Reset_Alert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                ClearFields();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });

    $("#jQGridCollapse1").click(function () {
        var pro = new Promise(function (res, err) {
            $(".jqContainer").toggleClass("hide_container");
            res(1);
        })
        pro.then(
            function resposes() {
                setTimeout(() => $(".content").scrollTop(3000), 1);
            })
    })

   // **** Query String to get ID Begin****\\\

    var getUrlParameter = function getUrlParameter(sParam) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');

            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : sParameterName[1];
            }
        }
    };
    var ID = getUrlParameter('id');
    if (ID == null || ID == 0 || ID == '') {
        $("#jQGridCollapse1").click();
    }
    else {
        LinkClicked(ID);
        FromNotification = true;
    }
    // **** Query String to get ID  End****\\\
});

function LinkClicked(id) {
    $(".content").scrollTop(1);
    var action = "";
    $('.nav-tabs a:first').tab('show');
    $("#frmCorrectiveActionReport :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#primaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");
    var hasApprovePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");
    var hasRejectPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Reject'");

    if (hasEditPermission) {
        action = "Edit"
    }
    else if (!hasEditPermission && !hasDeletePermission && !hasApprovePermission && !hasRejectPermission && hasViewPermission) {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#btnDelete').show();
    }

    if (action == 'View') {
        $("#frmCorrectiveActionReport :input:not(:button)").prop("disabled", true);
        $("#frmCARWorkOrderList :input:not(:button)").prop("disabled", true);
        $('#divActivitiesAddNew').hide();
        $('#btnSave,#btnEdit,#btnSaveandAddNew,#btnApprove,#btnReject,#btnWorkOrderListSave').hide();
    } 

    $('#spnActionType').text(action);
    $('#chkActivitiesDeleteAll').prop('checked', false);

    fillAllIndicators();

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $('#myPleaseWait').modal('show');
        $.get("/api/correctiveActionReport/Get/" + primaryId + "/1/5")
      .done(function (result) {
          var getResult = JSON.parse(result);
          $('#hdnAttachId').val(getResult.HiddenId);
          $('#txtTypeOfCAR').val(getResult.CARGeneration);
          $('#txtCARNumber').val(getResult.CARNumber);
          $('#selQAPIndicatorId').val(getResult.QAPIndicatorId);
          $('#txtCARDate').val(getResult.CARDate == null ? null : moment(getResult.CARDate).format("DD-MMM-YYYY"));
          $('#txtFromDate').val(getResult.FromDate == null ? null : moment(getResult.FromDate).format("DD-MMM-YYYY"));
          $('#txtToDate').val(getResult.ToDate == null ? null : moment(getResult.ToDate).format("DD-MMM-YYYY"));
          $('#hdnFollowupCARId').val(getResult.FollowupCARId);
          $('#txtFollowupCARNo').val(getResult.FollowUpCARNumber);
          $('#hdnAssignedUserId').val(getResult.AssignedUserId);
          $('#txtAssignee').val(getResult.AssignedUserName);
          $('#txtProblemStatement').val(getResult.ProblemStatement);
          $('#txtRootCause').val(getResult.RootCause);
          $('#txtSolution').val(getResult.Solution);
          $('#selPriorityLovId').val(getResult.PriorityLovId == null || getResult.PriorityLovId == 0 ? 'null' : getResult.PriorityLovId);
          $('#selStatus').val(getResult.Status == null || getResult.Status == 0 ? 'null' : getResult.Status).trigger('change');
          $('#hdnIssuerUserId').val(getResult.IssuerUserId);
          $('#txtIssuer').val(getResult.IssuerUserName);
          $('#txtCARTargetDate').val(getResult.CARTargetDate == null ? null : moment(getResult.CARTargetDate).format("DD-MMM-YYYY")),
          $('#txtVerifiedDate').val(getResult.VerifiedDate == null ? null : moment(getResult.VerifiedDate).format("DD-MMM-YYYY"));
          $('#hdnVerifiedBy').val(getResult.VerifiedBy);
          $('#txtVerifiedBy').val(getResult.VerifiedByName);
          $('#txtRemarks').val(getResult.Remarks);
          $('#hdnIsAutoCarEdit').val(getResult.IsAutoCarEdit);
          $('#hdnCARStatus').val(getResult.CARStatus);
          $('#divCARStatusName').text(getResult.CARStatusValue);
          $('#hdnTimestamp').val(getResult.Timestamp);

          $('#txtCARDate').attr('disabled', true);
          $('#txtProblemStatement').attr('disabled', true);
          $('#txtFromDate').attr('disabled', true);
          $('#txtToDate').attr('disabled', true);
          $('#selQAPIndicatorId').attr('disabled', true);
          
          if (getResult.CARGeneration == 'Manual CAR') {
              $('#spnFollowUpCAR').show();
              //$('#txtFollowupCARNo').attr('required', true);
              //$('#hdnFollowupCARId').attr('required', true);
              //$('#txtFollowupCARNo').attr('disabled', false);

              //$('#spnPopup-Assignee').show();
              //$('#txtAssignee').attr('placeholder', 'Please Select');
              //$('#spnAssignee').show();

          } else if (getResult.CARGeneration == 'Auto Generation CAR') {
              $('#spnFollowUpCAR').hide();
              $('#txtFollowupCARNo').val('').removeAttr('required');
              $('#hdnFollowupCARId').val('').removeAttr('required');
              
              if (getResult.CARStatus == null) {
                  $('#selPriorityLovId').attr('disabled', false);
                  $('#txtCARTargetDate').attr('disabled', false);
                  //$('#txtVerifiedDate').attr('disabled', false);
                  //$('#txtVerifiedBy').attr('disabled', false);
              }
          }

          BindGridRecords(getResult);
          EnableDisable(getResult.CARStatus);

          if (getResult.CARStatus == null) {
              DisableGridFieldsForSubmit();
          }

          if (getResult.CARStatus == 367) {
              EnableGridFieldsForApproveReject();
          }

          if (getResult.CARStatus == 367) {
              EnableVerifyFields();
          } else {
              DisableVerifyFields();
              if (getResult.CARStatus == 369 || getResult.CARStatus == 368)
              {
                  $('#spnVerifiedDate').css('visibility', 'visible');
                  $('#spnVerifiedBy').css('visibility', 'visible');
              }
          }

          $('#myPleaseWait').modal('hide');
      })
     .fail(function (response) {
         $('#myPleaseWait').modal('hide');
         $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
         $('#errorMsg').css('visibility', 'visible');
     });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}
$("#btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/correctiveActionReport/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('correctiveActionReport', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 $('#btnDelete').hide();
                 ClearFields();
             })
             .fail(function () {
                 showMessage('correctiveActionReport', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });

        }
    });
}
function ClearFields() {
    $(".content").scrollTop(0);
    $('input[type="text"], textarea').val('');
    $('#txtAssignee').attr('placeholder', 'Please Select');
    $('#divCARStatusName').text('');
    $('#btnSave').show();
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#selQAPIndicatorId").val('null');
    $("#selPriorityLovId").val('null');
    $("#selStatus").val(300);
    
    EnableDisableForReset();
    $("#selStatus").attr('disabled', true);
    $('#divActivitiesAddNew').show();
    $('#tableActivities > tbody').children('tr:not(:first)').remove();
    $('#selResponsibilityId_0').val('null');
    $('#txtResponsiblePerson_0').attr('disabled', true);

    $('#txtTypeOfCAR').val('Manual CAR');

    DisableGridFieldsForSubmit();
    $('#btnApprove').hide();
    $('#btnReject').hide();
    $('#btnSaveandAddNew').show();

    $("#grid").trigger('reloadGrid');
    $("#frmCorrectiveActionReport :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('.nav-tabs a:first').tab('show');
    fillSelectedIndicators();
}

function fillSelectedIndicators()
{
    $('#selQAPIndicatorId').children('option:not(:first)').remove();
    $.each(GlobalSelectedIndicators, function (index, value) {
        $('#selQAPIndicatorId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
}

function fillAllIndicators() {
    $('#selQAPIndicatorId').children('option:not(:first)').remove();
    $.each(GlobalIndicators, function (index, value) {
        $('#selQAPIndicatorId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
}

function BindGridRecords(getResult) {
    $('#chkActivitiesDeleteAll').prop('checked', false);
    if (getResult != null && getResult.activities != null) {
        $('#tableActivities > tbody').children('tr').remove();

        $.each(getResult.activities, function (index, value) {
            var tableRow = '';
            var startDate = value.StartDate == null ? '' : moment(value.StartDate).format("DD-MMM-YYYY");
            var targetDate = value.TargetDate == null ? '' : moment(value.TargetDate).format("DD-MMM-YYYY");
            var completedDate = value.CompletedDate == null ? '' : moment(value.CompletedDate).format("DD-MMM-YYYY");
            var responsiblePerson = value.ResponsiblePerson == null ? '' : value.ResponsiblePerson;

            tableRow = '<tr>' +
            '<td width="5%" style="text-align:center">' +
            '<input type="checkbox" id="chkActivitiesDelete_' + index + '" />' +
            '<input type="hidden" id="hdnCarDetId_' + index + '" value="' + value.CarDetId + '" /></td>' +
            '<td width="20%"><input id="txtActivity_' + index + '" class="form-control" type="text"  maxlength="500" value="' + value.Activity + '" required/></td>' +
            '<td width="14%"><input id="txtStartDate_' + index + '" class="form-control datatimeNoFuture" type="text" maxlength="11" value="' + startDate + '" required /></td>' +
            '<td width="14%"><input id="txtTargetDate_' + index + '" class="form-control dateAll" type="text" maxlength="11" value="' + targetDate + '" required/></td>' +
            '<td width="17%"><input id="txtCompletedDate_' + index + '" class="form-control dateAll" type="text" maxlength="11" value="' + completedDate + '" required/></td>' +
            '<td width="15%"><select id="selResponsibilityId_' + index + '" class="form-control" required><option value="null">Select</option></select></td>' +
            '<td width="15%"><input type="text" id="txtResponsiblePerson_' + index + '" class="form-control" placeholder="Please Select" maxlength="75" autocomplete="off" pattern="^[a-zA-Z0-9\\-\\(\\)\\/\\s]+$" value="' + responsiblePerson + '" required />' +
            '<input type="hidden" id="hdnResponsiblePersonUserId_' + index + '" value="' + value.ResponsiblePersonUserId + '" required/><div class="col-sm-12" id="divResponsiblePersonFetch_' + index + '"></div>' +
            '</td></tr>';

            $('#tableActivities > tbody').append(tableRow);
            $.each(LovValues.Responsibilities, function (index2, value2) {
                $('#selResponsibilityId_' + index).append('<option value="' + value2.LovId + '">' + value2.FieldValue + '</option>');
            });
            $('#selResponsibilityId_' + index).val(value.ResponsibilityId == null ? 'null': value.ResponsibilityId);
        });

        $("input[id^='txtActivity_']").attr('pattern', '^[a-zA-Z0-9\'.\'\",:;/\\(\\),\\-\\s!@#$%*"&]+$');

        BindFetchEventsForPerson();
        BindEvensForCheckBox();
        BindDateTimePicker();
        BindEventsForResponsibility();
        tableInputValidation('tableActivities');

        //$('#divPagination').html(null);
        //$('#divPagination').html(paginationString);
        //SetPaginationValues(getResult.activities);

        //EnableDisableFields(getResult.Status);
    } else {
        $('#tableActivities > tbody').children('tr:not(:first)').remove();
        $('#hdnCarDetId_0').val('');
         $('#txtActivity_0').val('');
         $('#txtStartDate_0').val('');
         $('#txtTargetDate_0').val('');
         $('#txtCompletedDate_0').val('');
         $('#selResponsibilityId_0').val('null');
         $('#txtResponsiblePerson_0').val('');
         $('#hdnResponsiblePersonUserId_0').val('');

         $('#chkActivitiesDeleteAll').prop('checked', false);
         $('#chkActivitiesDelete_0').prop('checked', false);
    }
}

function EnableDisable(carStatus) {
   
    if (carStatus != null) {
        $("#frmCorrectiveActionReport :input:not(:button)").prop("disabled", true);
        //$('#spnPopup-failureSymptomCode').hide();
        $('#spnPopup-followupCAR').hide();
        $('#spnPopup-Assignee').hide();
        $('#spnPopup-Issuer').hide();
        //$('#spnPopup-VerifiedBy').hide();
        $('#divActivitiesAddNew').hide();
    } else {
        //$('#txtFailureSymptomCode').attr('disabled', false);
        //$('#spnPopup-failureSymptomCode').show();
        $('#spnPopup-followupCAR').hide();
        $('#spnPopup-Assignee').hide();
        //$('#spnPopup-Issuer').show();
        //$('#spnPopup-VerifiedBy').show();
        $('#divActivitiesAddNew').show();
        EnableTableRow();
    }

    if (carStatus != 369 && carStatus != 368) {
        $('#txtRootCause').attr('disabled', false);
        $('#txtSolution').attr('disabled', false);
        $('#txtRemarks').attr('disabled', false);
    }
    
    if (carStatus == null) {
        $('#btnEdit').show();
        $('#btnSaveandAddNew').show();
        $('#btnSave').hide();
        $('#btnApprove').hide();
        $('#btnReject').hide();
    }
    else if (carStatus == 367) {
        $('#btnEdit').hide();
        $('#btnSaveandAddNew').hide();
        $('#btnSave').hide();
        $('#btnApprove').show();
        $('#btnReject').show();
    } else if (carStatus == 369 || carStatus == 368) {
        $('#btnEdit').hide();
        $('#btnSaveandAddNew').hide();
        $('#btnSave').hide();
        $('#btnApprove').hide();
        $('#btnReject').hide();
        $('#btnDelete').hide();
    }
}

function EnableTableRow() {
    $('#chkActivitiesDeleteAll').attr('disabled', false);
    $('#chkActivitiesDelete_0').attr('disabled', false);
    $('#txtActivity_0').attr('disabled', false);
    $('#txtStartDate_0').attr('disabled', false);
    $('#txtTargetDate_0').attr('disabled', false);
    $('#txtCompletedDate_0').attr('disabled', false);
    $('#selResponsibilityId_0').attr('disabled', false);
}

function EnableDisableForReset() {
            $("form :input:not(:button)").prop("disabled", false);
            $('#txtTypeOfCAR').attr('disabled', true);
            $('#txtCARNumber').attr('disabled', true);
            
            $("#txtFromDate").attr('disabled', true);
            $("#txtToDate").attr('disabled', true);

            $('#spnPopup-followupCAR').show();
            $('#spnPopup-Assignee').show();
            $('#spnPopup-Issuer').show();

            $('#spnPopup-VerifiedBy').show();

            $('#anchorActivitiesAddNew').attr('disabled', false);
            $('#anchorActivitiesAddNew').unbind('click');
            $('#anchorActivitiesAddNew').click(AddnewRowClicked);

            DisableVerifyFields();

            if (!(primaryId != null && primaryId != "0")) {
                $('#txtProblemStatement').attr('disabled', false);
            }
           
            $('#spnFollowUpCAR').show();
            $('#txtFollowupCARNo').attr('required', true);
            $('#hdnFollowupCARId').attr('required', true);
}

function DisableVerifyFields()
{
    $('#txtVerifiedDate').removeAttr('required');
    $('#txtVerifiedBy').removeAttr('required');
    $('#hdnVerifiedBy').removeAttr('required');
    $('#spnVerifiedDate').css('visibility', 'hidden');
    $('#spnVerifiedBy').css('visibility', 'hidden');
    $('#txtVerifiedDate').attr('disabled', true);
    $('#txtVerifiedBy').attr('disabled', true);
    $('#spnPopup-VerifiedBy').hide();
}

function EnableVerifyFields() {
    $('#txtVerifiedDate').attr('required', true);
    $('#txtVerifiedBy').attr('required', true);
    $('#hdnVerifiedBy').attr('required', true);
    $('#spnVerifiedDate').css('visibility', 'visible');
    $('#spnVerifiedBy').css('visibility', 'visible');
    $('#txtVerifiedDate').attr('disabled', false);
    $('#txtVerifiedBy').attr('disabled', false);
    $('#spnPopup-VerifiedBy').show();
}

$('#selQAPIndicatorId').change(function () {
    var indicatorId = $('#selQAPIndicatorId').val();
    switch(indicatorId){
        case 'null':
            $('#txtFollowupCARNo').attr('disabled', true);
            $('#txtFollowupCARNo').val('');
            $('#hdnFollowupCARId').val('');
            $('#spnPopup-followupCAR').hide();
            break;
        case '1': 
        case '2':
            $('#txtFollowupCARNo').attr('disabled', false);
            $('#txtFollowupCARNo').val('');
            $('#hdnFollowupCARId').val('');
            $('#spnPopup-followupCAR').show();
            break;
    }
});

function BindEventsForResponsibility() {

$("[id^=selResponsibilityId_]").change(function () {
        var id = $(this).attr('id');
        var index = id.split('_')[1];
        var responsibilityId = $('#' + id).val();
        if (responsibilityId == 'null') {
            $('#txtResponsiblePerson_' + index).val('').removeAttr('placeholder');
            $('#hdnResponsiblePersonUserId_' + index).val('');
            $('#txtResponsiblePerson_' + index).attr('disabled', true);
        } else if (responsibilityId == 333 || responsibilityId == 334) {//customer
            $('#txtResponsiblePerson_' +index).attr('placeholder', 'Please Select');
            $('#txtResponsiblePerson_' +index).attr('disabled', false);
        }
});
}

$('#AttachmentTab').click(function () {
    var status = $('#divCARStatusName').text();
    if (status == 'Approved' || status == 'Rejected') {
        $('#btnEditAttachment').hide();
        $('#btnEditAttachmentAddNew').hide();
        setTimeout(function () {
            $("#CommonAttachment :input").prop("disabled", true);
        }, 150)
        
    } else {
        $('#btnEditAttachment').show();
        $('#btnEditAttachmentAddNew').show();
        setTimeout(function () {
            $("#CommonAttachment :input").prop("disabled", false);
        }, 150)
    }
    
});

function DisableGridFieldsForSubmit() {
    $('#spnActualCompletionDate').hide();
    $('#spnResponsibilty').hide();
    $('#spnResponsiblePerson').hide();

    $("input[id^='txtCompletedDate_']").val('');
    $("input[id^='txtResponsiblePerson_']").val('');

    $("input[id^='txtCompletedDate_']").val('').attr('disabled', true);
    //$("input[id^='txtResponsiblePerson_']").val('').attr('disabled', true);
    //$("input[id^='txtResponsiblePerson_']").removeAttr('placeholder');

    $("input[id^='txtCompletedDate_']").removeAttr('required');
    $("[id^=selResponsibilityId_]").removeAttr('required');
    $("input[id^='txtResponsiblePerson_']").removeAttr('required');
    $("input[id^='hdnResponsiblePersonUserId_']").removeAttr('required');

    $("input[id^='txtCompletedDate_']").parent().removeClass('has-error');
    $("input[id^='selResponsibilityId_']").parent().removeClass('has-error');
    $("input[id^='txtResponsiblePerson_']").parent().removeClass('has-error');
}

function EnableGridFieldsForApproveReject() {
    $('#spnActualCompletionDate').show();
    $('#spnResponsibilty').show();
    $('#spnResponsiblePerson').show();

    $("input[id^='txtCompletedDate_']").attr('disabled', false);
    $("[id^=selResponsibilityId_]").attr('disabled', false);

    $('#tableActivities tr').each(function (index, value) {
        if (index == 0) return;
        var index1 = index - 1;
        if ($('#selResponsibilityId_' + index1).val() == 'null') {
            $('#txtResponsiblePerson_' + index1).attr('disabled', true);
        } else {
            $('#txtResponsiblePerson_' + index1).attr('disabled', false);
            if ($('#txtResponsiblePerson_' + index1).val() == '' || $('#txtResponsiblePerson_' + index1).val() == null) {
                $('#txtResponsiblePerson_' + index1).attr('placeholder', 'Please Select');
            }
        }
    });

    //$("input[id^='txtResponsiblePerson_']").attr('disabled', false);
    //$("input[id^='txtResponsiblePerson_']").attr('placeholder', 'Please Select');

    $("input[id^='txtCompletedDate_']").attr('required', true);
    $("[id^=selResponsibilityId_]").attr('required', true);
    $("input[id^='txtResponsiblePerson_']").attr('required', true);
    $("input[id^='hdnResponsiblePersonUserId_']").attr('required', true);
}


// get database based on service 
function ChangeService() { 
    var ServiceId = $('#ServiceId').val();
    $.get("/api/correctiveActionReport/ChangeService/" + ServiceId)
 .done(function (result) {
    debugger;
     $("#grid").trigger('reloadGrid');
     $('#selQAPIndicatorId').empty();
     $('#selQAPIndicatorId').append('<option value="0">Select</option>');
     $('#selQAPIndicatorId2').empty();
     $('#selQAPIndicatorIdHistory').empty();
     $('#selPriorityLovId').empty();
     $('#selStatus').empty();
     $('#selResponsibilityId_0').empty();
     var loadResult = JSON.parse(result);
     $.each(loadResult.Indicators, function (index, value) {
         $('#selQAPIndicatorId2, #selQAPIndicatorIdHistory').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
     });

     GlobalIndicators = loadResult.Indicators;
     GlobalSelectedIndicators = loadResult.SelectedIndicators;

     $.each(loadResult.SelectedIndicators, function (index, value) {
         $('#selQAPIndicatorId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
     });

     $.each(loadResult.QAPPriorityValue, function (index, value) {
         $('#selPriorityLovId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
     });
     $.each(loadResult.QAPStatusValue, function (index, value) {
         $('#selStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
     });
     $.each(loadResult.Responsibilities, function (index, value) {
         $('#selResponsibilityId_0').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
     });

     LovValues.Responsibilities = loadResult.Responsibilities;

     FailureSymptomCodeLovs = loadResult.FailureSymptomCodes;

     $('#selStatus').val(300);
     $('#selStatus').attr('disabled', true);
     $('#txtTypeOfCAR').val('Manual CAR');

     $('#txtFollowupCARNo').attr('disabled', true);
     $('#spnPopup-followupCAR').hide();

     DisableVerifyFields();

     DisableGridFieldsForSubmit();


 })
 .fail(function (response) {
     $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
     $('#errorMsg').css('visibility', 'visible');
 });
}