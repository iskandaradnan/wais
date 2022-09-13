var ListModel = [];

$(document).ready(function () {
    debugger;
    $('#btnEdit').hide();
    $('#btnClarify').hide();
    $('#btnVerify').hide();
    $('#btnApprove').hide();
    $('#btnApproveMoreinfo').hide();
    $('#btApproveForward').hide();
    $('#btnReject').hide();
    $('#btnRecommend').hide();
    $('#btnRecommendMoreInfo').hide();
    $('#btnDelete').hide();
    $('.status').html("");
    $('#radios1').attr('checked', false);
    $('#radios2').attr('checked', false);
    $('#radios3').attr('checked', false);
    $('#radios4').attr('checked', false);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasAddPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Add'");
    var hasVerifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Verify'");
    var hasApprovePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");
    var hasRejectPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Reject'");
    var hasRecommendPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Recommend'");
    var hasClarifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Clarify'");
    var primaryID = $('#primaryID').val();
    $('#txtOldBerNo,#txtOldRejectedBerNo').attr('disabled', true);
    $('#estimatedRepairCostlabelid').html("Estimated Repair Cost (RM) <span class='red'> *</span>");
    $('#rejectedBERDiv,#ApprovedBERDiv').hide();
    var actionType = $('#ActionType').val();
    if (hasApprovePermission || hasRejectPermission || hasVerifyPermission || hasRecommendPermission) {
        DisableFormFields();
        $('#btnCancel').hide();
        $('#btnCancelBER2').hide();
        $('#btnCancelAHistory').hide();
        $('#btnCancelMHistory').hide();
        $('#btnAdditionalInfoCancel1').hide();
        $('#btnEditBer2').hide();
        $('#btnSaveandAddNew,#spnPopup-compStaff').hide();
        $('#AssetNoDiv,#companypopup').hide();
        //$('#Remarks').attr('disabled', true);
    }
    else {
        $('#btnCancel').show();
        $('#btnCancelBER2').show();
        $('#btnCancelAHistory').show();
        $('#btnCancelMHistory').show();
        $('#btnAdditionalInfoCancel1').show();
        $('#btnSaveandAddNew').show();
    }
    $('#myPleaseWait').modal('show');
    formInputValidation("beroneformid");

    $.get("/api/BerOne/Load")
        .done(function (result) {
            //Bind drop down values 
            var loadResult = JSON.parse(result);
            $("#jQGridCollapse1").click();
            $.each(loadResult.ServiceList, function (index, value) {
                $('#ServiceId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.BER1StatusLovs, function (index, value) {
                $('#BER1status,#BER2status').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            debugger;
            $.each(loadResult.ServiceList, function (index, value) {
                $('#selServices').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            $('#Services').val(loadResult.Services);

            $('#CurrentDate').val(DateFormatter(loadResult.CurrentDate));
            $('#FacilityName').val(loadResult.FacilityName);
            $('#FacilityCode').val(loadResult.FacilityCode);
            if (primaryID == "0" || primaryID == 0) {
                $('#BERActionStatus').val(202);
                $('#BER1status,#BER2status').val(202); // New
                $('#hdnCompanyStaffId').val(loadResult.ApplicantStaffId);
                $('#txtCompanyStaffName').val(loadResult.ApplicantStaffName);
                $('#txtDesignation').val(loadResult.ApplicantDesignation);
            }
            $('#hdnApplicantStaffId').val(loadResult.ApplicantStaffId);
            $('#ApplicantName').val(loadResult.ApplicantStaffName);
            $('#ApplicantDesignation').val(loadResult.ApplicantDesignation);
            $('#myPleaseWait').modal('hide');
        })
  .fail(function () {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
      $('#errorMsg').css('visibility', 'visible');
  });

    $("#hdnRejectedBERReferenceId").change(function () {
        clearInputFields();
        $('#StillwithInLifeSpan').val("");
        $('#CurrentValue').val("");
        var ApplicationId = $('#hdnRejectedBERReferenceId').val();
        if (ApplicationId != null && ApplicationId != "0" && ApplicationId != "") {
            $.get("/api/BerOne/Get/" + ApplicationId)
              .done(function (result) {
                  var getResult = JSON.parse(result);
                  BindEquipmentData(getResult);
                  BindBER1HeaderDate(getResult, 2);
                  //  }
                  $('#myPleaseWait').modal('hide');
              })
             .fail(function () {
                 $('#myPleaseWait').modal('hide');
                 $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                 $('#errorMsg').css('visibility', 'visible');
             });
        }
    });

    $('#Ber2Remarks').on('input propertychange paste keyup', function (event) {
        var remarks = $('#Ber2Remarks').val();
        if (remarks != '' && remarks != null && remarks != undefined) {
            $('#Ber2Remarks').parent().removeClass('has-error');

        }
    })

    function clearInputFields() {
        $("#beroneformid :input:not(:button)").parent().removeClass('has-error');
        $('#txtAssetNo').val("");
        $('#txtassetDescription').val("");
        $('#hdnAssetId').val('null');
        $('#UserLocationCode').val("");
        $('#UserLocationName').val("");
        $('#Manufacturer').val("");
        $('#Model').val("");
        $('#SupplierName').val("");
        $('#PurchaseCost').val("");
        $('#PurchaseDate').val("");
        $('#AssetAge').val("");
        $('#StillwithInLifeSpan').val("");
        $('#CurrentValue').val("");
        $('#berNo').val("");
        $('#ApplicationDate').val("");
        $('#txtCompanyStaffName').val("");
        $('#txtDesignation').val("");
        $('#RepairEstimateCost').val("");
        $('#hdnCompanyStaffId').val("");
        $("input[name=EstimatedCosttooExpensive][value=" + 0 + "]").prop('checked', true);
        $("input[name=NotReliableId][value=" + 0 + "]").prop('checked', true);
        $("input[name=Obsolescence][value=" + 0 + "]").prop('checked', true);
        $("input[name=StatuaryRequirementsid][value=" + 0 + "]").prop('checked', true);
        $('#otherObservations').val("");
    }
    function DisplayError() {
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnSave').attr('disabled', false);
    }

    $("#ApprovedBER").change(function () {
        $('#rejectedBERDiv').hide();
        clearInputFields();
        $('#RejectedBER').attr('checked', false);
        if (this.checked) {
            $('#txtOldBerNo').attr('disabled', false);
            $('#ApprovedBERDiv').show();
            $('#txtAssetNo').attr('disabled', true);
            $('#AssetNoDiv').hide();
            $('#RejectedBER').attr('disabled', true);
            //Do stuff
        }
        else {
            $('#txtAssetNo').attr('disabled', false);
            $('#txtOldBerNo').attr('disabled', true);
            $('#txtOldBerNo').val('');
            $('#ApprovedBERDiv').hide();
            $('#hdnRejectedBERReferenceId').val(null);
            $('#AssetNoDiv').show();
            $('#RejectedBER').attr('disabled', false);
        }
    });


    $("#RejectedBER").change(function () {
        clearInputFields();
        $('#ApprovedBER').attr('checked', false);
        if (this.checked) {
            $('#txtOldRejectedBerNo').attr('disabled', false);
            $('#txtAssetNo').attr('disabled', true);
            $('#AssetNoDiv').hide();
            $('#ApprovedBER').attr('disabled', true);
            $('#rejectedBERDiv').show();
            // Do stuff
        }
        else {
            $('#txtAssetNo').attr('disabled', false);
            $('#txtOldRejectedBerNo').attr('disabled', true);
            $('#txtOldRejectedBerNo').val('');
            $('#hdnRejectedBERReferenceId').val(null);
            $('#AssetNoDiv').show();
            $('#ApprovedBER').attr('disabled', false);
            $('#rejectedBERDiv').hide();
        }
    });


    $('#btnVerify').click(function () {

        performAction("Submit");
    })
    $('#btnClarify').click(function () {

        performAction("ReSubmit");
    })
    $('#btnApprove').click(function () {

        performAction("Approve");
    })
    $('#btnReject').click(function () {

        performAction("Reject");
    });
    $('#btnApproveMoreinfo').click(function () {

        performAction("More Info HD");
    });
    $('#btApproveForward').click(function () {

        performAction("Forward");
    });
    $('#btnRecommendMoreInfo').click(function () {

        performAction("More Info LA");
    });
    $('#btnRecommend').click(function () {

        performAction("Recommend");
    });
    function DisplayBER1Error() {
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnSave').attr('disabled', false);
    }
    function DisplayBER2Error() {
        $('#errorMsg1').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnSave').attr('disabled', false);
    }

    function performAction(BerStatusText) {
        $("div.errormsgcenter1").text("");
        $('#errorMsg1').css('visibility', 'hidden');
        var BER1status = $('#BERActionStatus').val();
        var ber2Remarks = $('#Ber2Remarks').val();
        var isFormValid = formInputValidation("bertwoformid", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter1").text(Messages.INVALID_INPUT_MESSAGE);
            DisplayBER2Error();
            return false;
        }
        else {
            var status = 0;
            var x = BerStatusText;
            if (BerStatusText == "More Info HD" || BerStatusText == "More Info LA") {
                x = "More Info";
            }
            else
                x = BerStatusText;


            bootbox.confirm("Are you sure you want to " + x + "?", function (result) {
                var previousStatus = $('#BERActionStatus').val();
                if (result) {
                    switch (BerStatusText) {
                        case "Submit":
                            $('#BERActionStatus').val(203);
                            break;
                        case "More Info HD"://               
                            $('#BERActionStatus').val(204);
                            $('#BIL').val('CHD'); // clarification sought by HD 
                            break;
                        case "More Info LA"://               
                            $('#BERActionStatus').val(205);
                            $('#BIL').val('CLA');// clarification sought by LA  
                            break;
                        case "Approve"://
                            $('#BERActionStatus').val(206);
                            break;
                        case "Forward"://
                            $('#BERActionStatus').val(207);
                            break;
                        case "ReSubmit":
                            $('#BERActionStatus').val(209);
                            //clarified by applicant 

                            break;
                        case "Recommend":
                            $('#BERActionStatus').val(208);
                            //clarified by applicant                        
                            break;
                        case "Reject"://   
                            if (previousStatus == "202") {
                                $('#BIL').val('RFM'); // Rejected by FM 
                            }
                            else {
                                $('#BIL').val('RHD'); //// Rejected by HD 
                            }
                            $('#BERActionStatus').val(210);
                            break;

                        default:
                            $('#BERActionStatus').val($('#BER1status').val());

                    }
                    Submit('BEr2Save');
                }
            });
        }
    }

    $("#btnSave,#btnEdit,#btnSaveandAddNew").click(function () {
        debugger;
        var CurrentbtnID = $(this).attr("Id");
        Submit("Save", CurrentbtnID);
    });

    $("#btnEditBer2").click(function () {
        Submit("BEr2Save");
    });

    function Submit(buttontext, CurrentbtnID) {
        $('#myPleaseWait').modal('show');
        var primaryId = $("#primaryID").val();
        var date = getDateToCompare($('#CurrentDate').val());
        var applicationDate = getDateToCompare($('#ApplicationDate').val());
        $("div.errormsgcenter").text("");
        $("div.errormsgcenter1").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $('#errorMsg1').css('visibility', 'hidden');
        var BER1status = $('#BERActionStatus').val();
        var remarks = $('#Remarks').val();
        var ber2Remarks = $('#Ber2Remarks').val();

        //var CurrentValue = 0; 
        //if (CurrentbtnID == 'btnSave' || CurrentbtnID == 'btnEdit' || CurrentbtnID == 'btnSaveandAddNew')
        //{

        //}



        var CurrentValueBer2 = $('#CurrentValueBer2').val();
        var AssetId = $('#hdnAssetId').val();
        CurrentValueBer2 = CurrentValueBer2.split(',').join('');
        var RepairEstimateCost = $('#RepairEstimateCost').val();
        var cannotRepair = false;
        var checkBox = document.getElementById("cannotRepair");
        if (checkBox.checked) {
            cannotRepair = true;
        }
        else
            cannotRepair = false;
        var CurrentValue = $('#CurrentValue').val();
        CurrentValue = CurrentValue.split(',').join('');
        var items = [];
        $("input[name='BER2Syor[]']:checked").each(function () { items.push($(this).val()); });


        //  var estimatedCost = estcosttexp.checked ? true : false;
        if (buttontext == "Save") {
            var isFormValid = formInputValidation("beroneformid", 'save');
            if (!isFormValid || (parseInt(CurrentValue) == 0 || CurrentValue == '0')) {
                $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
                if (!cannotRepair && (RepairEstimateCost == 0 || RepairEstimateCost == "")) {
                    $('#RepairEstimateCost').parent().addClass('has-error');
                }
                if (parseInt(CurrentValue) == 0 || CurrentValue == '0') {
                    $('#CurrentValue').parent().addClass('has-error');
                }
                DisplayBER1Error();
                return false;
            }
            else if (parseInt(AssetId) == 0 || AssetId == '0' || AssetId == '') {

                $("div.errormsgcenter").text("Valid Asset No. required");
                $('#txtAssetNo').parent().addClass('has-error');
                DisplayError();
                return false;

            }
            else if ($('#hdnCompanyStaffId').val() == 0 || $('#hdnCompanyStaffId').val() == "0") {

                $("div.errormsgcenter").text("Valid Requestor Name required");
                $('#txtCompanyStaffName').parent().addClass('has-error');
                DisplayError();
                return false;
            }
            else if (!cannotRepair && (RepairEstimateCost == 0 || RepairEstimateCost == "")) {
                $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
                $('#RepairEstimateCost').parent().addClass('has-error');
                DisplayBER1Error();
                return false;
            }
        }

        else if (buttontext == "BEr2Save") {
            var isFormBer2Valid = formInputValidation("bertwoformid", 'save');
            if (!isFormBer2Valid) {

                $("div.errormsgcenter1").text(Messages.INVALID_INPUT_MESSAGE);
                DisplayBER2Error();
                return false;
            }
            else if ((BER1status == 209 || BER1status == "209" || BER1status == "210" || BER1status == 210 || BER1status == 204 || BER1status == '204' || BER1status == 205 || BER1status == '205' ||
                BER1status == 206 || BER1status == '206') && ber2Remarks.trim() == "") {
                $("div.errormsgcenter1").text(Messages.BER_RemarksMandatory);
                $('#Ber2Remarks').parent().addClass('has-error');
                DisplayBER2Error();
                return false;
            }

            else if (parseFloat(CurrentValueBer2) <= 0) {
                $("div.errormsgcenter1").text("Current Value should be greater than 0");
                $('#CurrentValueBer2').parent().addClass('has-error');
                DisplayBER2Error();
                return false;
            }
        }
        //input fieds
        var checkBox = document.getElementById("ApprovedBER");
        var OldberNo = $('#txtOldBerNo').val();
        var RejectedBERReferenceId = $('#hdnRejectedBERReferenceId').val();
        var BERNo = $('#BERNo').val();
        var ApplicationDate = $('#ApplicationDate').val();
        var FaciliName = $('#FaciliName').val();
        var FacilityCode = $('#FacilityCode').val();

        var AssetNo = $('#txtAssetNo').val();
        var AssetDescription = $('#txtassetDescription').val();
        var RepairEstimateCost = $('#RepairEstimateCost').val();
        RepairEstimateCost = RepairEstimateCost.split(',').join('');
        var AfterRepairValue = $('#AfterRepairValue').val();
        AfterRepairValue = AfterRepairValue.split(',').join('');
        //var CurrentValueBer2 = $('#CurrentValueBer2').val();
        if (CurrentValueBer2 != "" && CurrentValueBer2 != null) {
            CurrentValue = CurrentValueBer2;
        }

        //$('#selServices') = 2;

        var CurrentValueRemarks = $('#CurrentValueRemarks').val();
        var EstimatedDurationOfUsageAfterRepair = $('#estimatedDurationOfUsageAfterRepair').val();
        var requestorId = $('#hdnCompanyStaffId').val();
        var RequesterName = $('#RequesterName').val();
        var Designation = $('#Designation').val();
        var BER2SyorList = items;
        //Condition Appraisal of Equipment/Vehicle
        var EstimatedCosttooExpensive = $("input[name=EstimatedCosttooExpensive]:checked").val();
        var Obsolescence = $("input[name=ObsolescenceId]:checked").val();
        var NotReliableId = $("input[name=NotReliableId]:checked").val();
        var StatuaryRequirementsid = $("input[name=StatuaryRequirementsid]:checked").val();
        // var EstimatedCosttooExpensiveCheckboxId = document.getElementById("EstimatedCosttooExpensiveCheckboxId");
        //  var Obsolescence = $('#Obsolescence').val();
        var TechnicalSupportNo = $('#TechnicalSupportNo').val();
        var TechnicalSupportId = $('#TechnicalSupportId').val();
        var otherObservations = $('#otherObservations').val();
        var ApplicantId = $('#hdnApplicantStaffId').val();
        var ApplicantName = $('#txtCompanyStaffName').val();
        var Designation = $('#Designation').val();
        var ServiceName = $('#Services').val();
        var serviceId = 0;
        if(ServiceName=='BEMS')
            var serviceId = 2;
        else if (ServiceName == 'FEMS')
            var serviceId = 1;
        var timeStamp = $("#Timestamp").val();
        var currentRepairCost = $('#CurrentRepairCost').val();
        currentRepairCost = currentRepairCost.split(',').join('');

        var BerObj = {
            ServiceId: serviceId,
            BERno: BERNo,
            AssetId: AssetId,
            AssetNo: AssetNo,
            BIL: $('#BIL').val(),
            ValueAfterRepair: AfterRepairValue,
            EstDurUsgAfterRepair: EstimatedDurationOfUsageAfterRepair,
            EstRepcostToExpensive: (EstimatedCosttooExpensive == 1 || EstimatedCosttooExpensive == "1") ? true : false,
            Obsolescence: (Obsolescence == 1 || Obsolescence == "1") ? true : false,
            NotReliable: (NotReliableId == 1 || NotReliableId == "1") ? true : false,
            StatutoryRequirements: (StatuaryRequirementsid == 1 || StatuaryRequirementsid == "1") ? true : false,
            OtherObservations: otherObservations,
            ApplicantStaffId: ApplicantId,
            BERStatus: BER1status,
            BER1Remarks: remarks,
            ApplicationDate: ApplicationDate,
            RejectedBERReferenceId: RejectedBERReferenceId,
            BERStage: 2,
            EstimatedRepairCost: RepairEstimateCost,
            CurrentValue: CurrentValue,
            BER2TechnicalCondition: $('#BER2TechnicalCondition').val(),
            BER2RepairedWell: $('#BER2RepairedWell').val(),
            BER2SafeReliable: $('#BER2SafeReliable').val(),
            BER2EstimateLifeTime: $('#BER2EstimateLifeTime').val(),
            BER2SyorList: BER2SyorList,
            BER2Remarks: $('#Ber2Remarks').val(),
            CurrentValueRemarks: CurrentValueRemarks,
            RequestorId: requestorId,
            CurrentRepairCost: currentRepairCost,
            CannotRepair: (cannotRepair == 1 || cannotRepair == "1") ? true : false,
        };
        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            BerObj.ApplicationId = primaryId;
            BerObj.Timestamp = timeStamp;
        }
        else {
            BerObj.ApplicationId = 0;
            BerObj.Timestamp = "";
        }
        var jqxhr = $.post("/api/BerOne/Add", BerObj, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.ApplicationId);
            $("#Timestamp").val(result.Timestamp);
            BindEquipmentData(result);
            BindBER1HeaderDate(result, 1);

            if (result != null && result.BERApplicationRemarksHistoryTxns != null && result.BERApplicationRemarksHistoryTxns.length > 0) {
                BindRemarksHistory(result.BERApplicationRemarksHistoryTxns);
            }
            $(".content").scrollTop(0);
            showMessage('BERApplicationOne', CURD_MESSAGE_STATUS.SS);
            $("#grid").trigger('reloadGrid');
            if (result.ApplicationId != 0) {
                $('#ApprovedBERDiv').hide();
            }
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            if (CurrentbtnID == "btnSaveandAddNew") {
                EmptyFieldsBER2();
            }
        },
     "json")
      .fail(function (response) {
          var errorMessage = "";
          if (response.status == 400) {
              errorMessage = response.responseJSON;
          }
          else {
              errorMessage = Messages.COMMON_FAILURE_MESSAGE;
          }
          $("div.errormsgcenter").text(errorMessage);
          $('#errorMsg').css('visibility', 'visible');

          $('#btnSave').attr('disabled', false);
          $('#myPleaseWait').modal('hide');
      });
    }

    $("#ber2tab").click(function () {
        $("div.errormsgcenter1").text("");
        $('#errorMsg1').css('visibility', 'hidden');
        var primaryId = $('#primaryID').val();
        formInputValidation("bertwoformid");
        if (primaryId == 0) {
            bootbox.alert(Messages.SAVE_FIRST_TABALERT);
            return false;
        }
        else {
            BindValuesOnClickingTab();
        }
    })
});

$('#CurretnValHistory').click(function () {
    var primaryId = $('#primaryID').val();
    if (primaryId != 0 && primaryId != null) {
        $.get("/api/BerOne/GetBerCurrentValueHistory/" + primaryId)
       .done(function (result) {
           var getHistory = JSON.parse(result);
           $("#CurrentValueHistoryId").empty();
           if (getHistory != null && getHistory.BerCurrentValueHistoryTxnDets != null && getHistory.BerCurrentValueHistoryTxnDets.length > 0) {
               var html = '';
               $(getHistory.BerCurrentValueHistoryTxnDets).each(function (index, data) {
                   html += '<tr><td width="30%" style="text-align: center;"><div> ' +
                            ' <input type="text" class="form-control" id="CurrentValue_' + index + '" value="' + data.CurrentValue + '" readonly style="text-align:right;"/></div></td>' +
                             '<td width="35%" style="text-align: center;" ><div> ' +
                            '<input type="text" class="form-control" id="Remarks_' + index + '" value="' + data.Remarks + '" readonly /></div></td>' +
                            '<td width="35%" style="text-align: center;" ><div>' +
                            '<input type="text" class="form-control" id="UpdatedBy_' + index + '" value="' + data.UpdatedBy + '" readonly /></div></td>' +
                            '</tr>';
               });
               $("#CurrentValueHistoryId").append(html);
               $('#myPleaseWait').modal('hide');
           }
           else {
               $('#myPleaseWait').modal('hide');
               $("div.errormsgcenter1").text(Messages.COMMON_FAILURE_MESSAGE);
           }

       })
   .fail(function () {
       $('#myPleaseWait').modal('hide');
       $("div.errormsgcenter1").text(Messages.COMMON_FAILURE_MESSAGE);
   });
    }
});


$("#btnCancel,#btnCancelBER2,#btnCancelHist,#btnAttachmentCancel,#btnCancelAHistory,#btnCancelMHistory").click(function () {
    var message = Messages.Reset_Alert_CONFIRMATION;
    bootbox.confirm(message, function (result) {
        if (result) {
            EmptyFieldsBER2();
        }
        else {
            $('#myPleaseWait').modal('hide');
        }
    });
});

function goBack() {

    window.location.href = "/BER/BER2Application";
}
$("#jQGridCollapse1").click(function () {
    // $(".jqContainer").toggleClass("hide_container");
    var pro = new Promise(function (res, err) {
        $(".jqContainer").toggleClass("hide_container");
        res(1);
    })
    pro.then(
        function resposes() {
            setTimeout(() => $(".content").scrollTop(3000), 1);
        })
})

function BindRemarksHistory(list) {
    var IndNumber = 0;
    $('#RemarksGridId').empty();
    var html = '';
    $.each(list, function (index, data) {
        IndNumber = IndNumber + 1;
        html += ' <tr class="ng-scope" style=""><td width="10%" style="text-align: center;"><div> <input type="text"  class="form-control" id="No_maxindexval" value="' + IndNumber + '" readonly/></div></td><td width="45%" style="text-align: center;"><div> ' +
                ' <input type="text" id="Remarks_maxindexval" value="' + data.Remarks + '" style="max-width:100%;"   class="form-control" readonly /></div></td><td width="25%" style="text-align: center;"><div> ' +
                '<input type="text" id="EnteredBy_maxindexval" value="' + data.EnteredBy + '"  class="form-control" readonly /></div></td><td width="20%" style="text-align: center;"><div> ' +
                 '<input type="text" id="UpdatedDate_maxindexval" value="' + DateFormatter(data.UpdatedDate) + '" class="form-control" readonly /></div></td></tr> ';

    });
    $('#RemarksGridId').append(html);
}

// first header data 
function BindEquipmentData(getResult) {
    $('#ServiceId').val(getResult.ServiceId);
    $('#berNo').val(getResult.BERno);
    $('#hdnAssetId').val(getResult.AssetId);
    $('#txtassetDescription').val(getResult.AssetDescription);
    $('#txtAssetNo').val(getResult.AssetNo);
    $('#UserLocationCode').val(getResult.UserLocationCode);
    $('#UserLocationName').val(getResult.UserLocationName);
    $('#Model').val(getResult.Model);
    $('#Manufacturer').val(getResult.Manufacturer);
    $('#SupplierName').val(getResult.SupplierName);
    $('#BIL').val(getResult.BIL);
    if (getResult.PurchaseCost != null) {
        $('#PurchaseCost').val(addCommas(getResult.PurchaseCost));
    }
    else {
        $('#PurchaseCost').val(getResult.PurchaseCost);
    }
    $('#PurchaseDate').val(DateFormatter(getResult.PurchaseDate));
    if (getResult.CurrentValue != null) {
        var cvalue = (getResult.CurrentValue).toFixed(2);
        $('#CurrentValue').val(addCommas(cvalue));
    }
    else {
        $('#CurrentValue').val(getResult.CurrentValue);
    }
    if (getResult.PastMaintenanceCost != null) {

        var cval = (getResult.PastMaintenanceCost).toFixed(2);
        $('#PastMaintenanceCost').val(addCommas(cval));
    } else {
        $('#PastMaintenanceCost').val(cval);
    }
    $('#hdnApplicantStaffId').val(getResult.ApplicantStaffId);
    $('#ApplicantName').val(getResult.ApplicantStaffName);
    $('#ApplicantDesignation').val(getResult.ApplicantDesignation);
    $('#hdnAttachId').val(getResult.HiddenId);
}



// isApprovedRecord 1 : when get by id 
// isApprovedRecord 2 : when get by approved or rejected 
function BindBER1HeaderDate(getResult, isApprovedRecord) {
    if (getResult.ValueAfterRepair != null) {
        $('#AfterRepairValue').val(addCommas((getResult.ValueAfterRepair).toFixed(2)));
    }
    else {
        $('#AfterRepairValue').val(getResult.ValueAfterRepair);
    }
    $('#estimatedDurationOfUsageAfterRepair').val(getResult.EstDurUsgAfterRepair);

    if (getResult.EstRepcostToExpensive) {
        $("input[name=EstimatedCosttooExpensive][value=" + 1 + "]").prop('checked', true);
    }
    else {
        $("input[name=EstimatedCosttooExpensive][value=" + 0 + "]").prop('checked', true);
    }
    if (getResult.NotReliable) {
        $("input[name=NotReliableId][value=" + 1 + "]").prop('checked', true);
    }
    else {
        $("input[name=NotReliableId][value=" + 0 + "]").prop('checked', true);
    }
    if (getResult.StatutoryRequirements) {
        $("input[name=StatuaryRequirementsid][value=" + 1 + "]").prop('checked', true);
    }
    else {
        $("input[name=StatuaryRequirementsid][value=" + 0 + "]").prop('checked', true);
    }
    if (getResult.Obsolescence) {
        $("input[name=ObsolescenceId][value=" + 1 + "]").prop('checked', true);
    }
    else {
        $("input[name=ObsolescenceId][value=" + 0 + "]").prop('checked', true);
    }

    $('#otherObservations').val(getResult.OtherObservations);
    $('#hdnCompanyStaffId').val(getResult.RequestorId);
    $('#txtCompanyStaffName').val(getResult.RequestorName);
    $('#Remarks').val(getResult.BER1Remarks);
    $('#ApprovedDate').val(getResult.ApprovedDate);
    if (getResult.EstimatedRepairCost != null) {
        $('#RepairEstimateCost').val(addCommas(getResult.EstimatedRepairCost));
    }
    else {
        $('#RepairEstimateCost').val(getResult.EstimatedRepairCost);
    }

    if (getResult.CannotRepair) {
        $('#cannotRepair').prop('checked', true);
        $('#estimatedRepairCostlabelid').html("Estimated Repair Cost (RM)");
    }
    else {
        $('#estimatedRepairCostlabelid').html("Estimated Repair Cost (RM) <span class='red'> *</span>");
        $('#cannotRepair').prop('checked', false);
    }
    $('#txtAssetNo').prop('disabled', true);
    $('#rejectedBERDiv,#AssetNoDiv').hide();
    if (getResult.CurrentRepairCost != null) {
        $('#CurrentRepairCost').val(addCommas(getResult.CurrentRepairCost));
    }
    else {
        $('#CurrentRepairCost').val(getResult.CurrentRepairCost);
    }
    $('#Timestamp').val(getResult.Timestamp);
    $('#txtDesignation').val(getResult.RequestorDesignation);

    if (isApprovedRecord == 2) {
        $('#ParentApplicationId').val(getResult.ApplicationId);
        $('#BER1status,#BER2status,#BERActionStatus').val(202);
        $('#BERStatusValue').val("New");
        $('#BERStage').val(2);            //  DisableFormFields();
        $('#Remarks,#txtCompanyStaffName').prop('disabled', false);
        $('#ApplicationDate').val('');
        $('#ApplicationDate').prop('disabled', false);
    }
    else {
        $('#ApplicationDate').val(DateFormatter(getResult.ApplicationDate));
        $('#ApplicationDate').prop('disabled', true);
        $('#primaryID').val(getResult.ApplicationId);
        $('#BER1status,#BER2status').val(getResult.BERStatus);
        $('#BERActionStatus').val(getResult.BERStatus);
        $('#BERStatusValue').val(getResult.BERStatusValue);
        $('#BERStage').val(getResult.BERStage);
        $('#Ber2Remarks').val(getResult.BER2Remarks);

        if ($('#BERActionStatus').val() == 202 || $('#BERActionStatus').val() == 204 || $('#BERActionStatus').val() == 205) {

            if (getResult.RejectedBERReferenceId != null && getResult.RejectedBERReferenceId != 0 && getResult.RejectedBERReferenceId != '') {

                $("#beroneformid :input:not(:button)").prop("disabled", true);
                $('#Requestorpopup').hide();
            }
        }
        else {
            DisableFormFields();
            $('#Requestorpopup').hide();
            $('#btnEdit').hide();
        }
        $('#ApprovedBER,#RejectedBER').prop('disabled', false);
    }

    $('#BER2TechnicalCondition').val(getResult.BER2TechnicalCondition);
    $('#BER2EstimateLifeTime').val(getResult.BER2EstimateLifeTime);
    $('#BER2SafeReliable').val(getResult.BER2SafeReliable);
    $('#BER2RepairedWell').val(getResult.BER2RepairedWell);
    $('#CurrentValueRemarks').val(getResult.CurrentValueRemarks);
    $('#AssetAge').val(getResult.AssetAge);
    $('#StillwithInLifeSpan').val(getResult.StillwithInLifeSpan);
    var syorlist = getResult.BER2SyorList;
    $.each(syorlist, function (index, data) {
        if (data == 1 || data == '1') {
            $('#radios1').attr('checked', true);
        }
        else if (data == 2 || data == '2') {
            $('#radios2').attr('checked', true);
        }

        else if (data == 3 || data == '3') {
            $('#radios3').attr('checked', true);
        }

        else if (data == 4 || data == '4') {
            $('#radios4').attr('checked', true);

        }
    });
    DisableButtons();

    var ber2StatusId = $('#BERActionStatus').val();
    if (ber2StatusId == '202' || ber2StatusId == '203' || ber2StatusId == '204' || ber2StatusId == '205' || ber2StatusId == '207'
        || ber2StatusId == '208' || ber2StatusId == '209') {
        $('#Ber2Remarks').val('');
    }
    switch (ber2StatusId) {
        case "202":
            $('.status').html("Draft");
            break;
        case "203":
            $('.status').html("Submitted");
            break;
        case "204":
            $('.status').html("Clarification Sought By HD");
            break;
        case "205":
            $('.status').html("Clarification Sought By Liaison Officer");
            break;
        case "206":
            $('.status').html("Approved");
            break;
        case "207":
            $('.status').html("Forwarded to Liaison Officer");
            break;
        case "208":
            $('.status').html("Recommended");
            break;
        case "209":
            $('.status').html("Clarified By Applicant");
            break;
        case "210":
            $('.status').html("Rejected");
            break;
        default:
            $('.status').html("");
    }
    if (ber2StatusId == 202 || ber2StatusId == 204 || ber2StatusId == 205) {


        if (getResult.RejectedBERReferenceId != null && getResult.RejectedBERReferenceId != 0 && getResult.RejectedBERReferenceId != '') {
            $("#beroneformid :input:not(:button)").prop("disabled", true);
            $('#btnEdit').hide();
        }
        else {
            var hasAddPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Add'");
            if (hasAddPermission) {
                enableFields();
            }
        }

    }
    else {
        DisableFormFields();
        $('#companypopup').hide();
        $("#beroneformid :input:not(:button)").prop("disabled", true);
    }
    if (ber2StatusId == 206 || ber2StatusId == 210) {

        $('#Ber2Remarks').attr('disabled', true);
    }
    else {
        $('#Ber2Remarks').attr('disabled', false);
    }
    DisableButtons();

    //*************************** Attachment button hide **************************

    if ((ber2StatusId == "203" || ber2StatusId == 203 || ber2StatusId == "206" || ber2StatusId == 206 || ber2StatusId == "210" || ber2StatusId == 210)) {
        $('#AttachRowPlus').hide();
        $('#btnEditAttachment').hide();
    }
    else {
        $('#AttachRowPlus').show();
        $('#btnEditAttachment').show();
    }
    if (isApprovedRecord == 2) {
        $('#ApplicationDate').val('');
        $('#ApplicationDate').prop('disabled', false);
    }

}

function enableFields() {
    $('#RepairEstimateCost').prop('disabled', false);
    // $('#AfterRepairValue').prop('disabled', false);
    $('#cannotRepair').prop('disabled', false);
    $('#CurrentValue').prop('disabled', false);
    $('#estimatedDurationOfUsageAfterRepair').prop('disabled', false);
    $('#txtCompanyStaffName').prop('disabled', false);
    $('#Requestorpopup').show();
    $('#Remarks').prop('disabled', false);
    $('#otherObservations').prop('disabled', false);
    document.getElementById("EstimatedCosttooExpensive-1").disabled = false;
    document.getElementById("EstimatedCosttooExpensive-2").disabled = false;
    document.getElementById("radios-1").disabled = false;
    document.getElementById("radios-2").disabled = false;
    document.getElementById("NotReliableId-1").disabled = false;
    document.getElementById("NotReliableId-2").disabled = false;
    document.getElementById("StatuaryRequirementsid-1").disabled = false;
    document.getElementById("StatuaryRequirementsid-2").disabled = false;

    //tab2//
    document.getElementById("radio21").disabled = false;
    document.getElementById("radio22").disabled = false;
    $('#CurrentValueBer2').prop('disabled', false);
    $('#CurrentRepairCost').prop('disabled', false);
    $('#CurrentValueRemarks').prop('disabled', false);
    $('#BER2TechnicalCondition').prop('disabled', false);
    $('#BER2RepairedWell').prop('disabled', false);
    $('#BER2SafeReliable').prop('disabled', false);
    $('#BER2EstimateLifeTime').prop('disabled', false);

    $('#radios1').prop('disabled', false);
    $('#radios2').prop('disabled', false);
    $('#radios3').prop('disabled', false);
    $('#radios4').prop('disabled', false);
}

function LinkClicked(id, rowData) {

    $('.nav-tabs a:first').tab('show');
    $(".content").scrollTop(1);
    $("#beroneformid :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $("div.errormsgcenter1").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#errorMsg1').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");
    var hasApprovePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");
    var hasverifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Verify'");
    if (hasEditPermission) {
        action = "Edit";
    }
    else if (!hasEditPermission && hasViewPermission) {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#btnDelete').show();
    }

    if (action == 'View') {
        $("#beroneformid :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        $('#btnNextScreenSave').show();
    }
    $('#RejectedBER').prop('checked', false);
    $('#txtOldRejectedBerNo').val("");
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/BerOne/Get/" + primaryId)
          .done(function (result) {
              var getResult = JSON.parse(result);
              BindEquipmentData(getResult);
              BindBER1HeaderDate(getResult, 1);
              if (getResult != null && getResult.BERApplicationRemarksHistoryTxns != null && getResult.BERApplicationRemarksHistoryTxns.length > 0) {
                  BindRemarksHistory(getResult.BERApplicationRemarksHistoryTxns);
                  if (getResult.BERStatus != 202 || getResult.BERStatus != '202') {
                      $('.nav-tabs a[href="#ber2"]').tab('show');
                      BindValuesOnClickingTab();
                  }
              }

              $('#myPleaseWait').modal('hide');
          })
         .fail(function () {
             $('#myPleaseWait').modal('hide');
             $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
             $('#errorMsg').css('visibility', 'visible');
         });
    }
    else {

        $('#hdnApplicantStaffId').val(loadResult.ApplicantStaffId);
        $('#ApplicantName').val(loadResult.ApplicantStaffName);
        $('#ApplicantDesignation').val(loadResult.ApplicantDesignation);
        $('#myPleaseWait').modal('hide');
        $("#AssetCode,#AssetDesc").removeAttr("disabled");
    }
}
$("#btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/BerOne/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('BER2', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 EmptyFieldsBER2();
             })
             .fail(function () {
                 showMessage('BER2', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
        }

    });
}

// newly added code 

window.DisableFormFields = function () {
    $("#beroneformid :input:not(:button)").prop("disabled", false);
    $("#bertwoformid :input:not(:button)").prop("disabled", true);

}


window.DisableButtons = function () {

    var berstatus = $('#BERActionStatus').val();
    var primaryID = $('#primaryID').val();
    //var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    //var hasAddPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Add'");
    //var hasVerifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Verify'");
    //var hasApprovePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");
    //var hasClarifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Clarify'");
    //var hasRecommendPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Recommend'");






    var BerStatusText = parseInt(berstatus);


    $('#Remarks').attr('disabled', false);

    $('#btnCancel').hide();
    $('#btnAdditionalInfoCancel1').hide();
    $('#btnCancelAHistory').hide();
    $('#btnCancelMHistory').hide();







    $('#CurrentRepairCost').attr('disabled', false);
    $('#BER2TechnicalCondition').attr('disabled', false);
    $('#BER2RepairedWell').attr('disabled', false);
    $('#BER2SafeReliable').attr('disabled', false);
    $('#BER2EstimateLifeTime').attr('disabled', false);

    switch (BerStatusText) {
        case 202:// Draft 
            OnSave();
            break;
        case 203:// Submitted  
            PostDraft();
            break;
        case 204:// Clarification Sought By HD  
            PostClarificationSoughtByHD();
            break;
        case 205:// Clarification Sought By Liaison Officer  
            PostClarificationSoughtByLiaisonOfficer();
            break;
        case 206:// Approved  
            PostApproved();
            break;
        case 207:// Forwarded to Liaison Officer  
            PostForwardedtoLiaisonOfficer();

            break;
        case 208:// Recommended  
            PostRecommended();
            break;
        case 209:// Clarified By Applicant  
            PostClarifiedByApplicant();

            break;
        case 210:// Rejected  
            PostRejected();
            break;
    }




    //if (hasAddPermission) {
    //    $('#btnSave').hide();
    //    $('#btnEdit').hide();
    //    $('#btnClarify').hide();
    //    $('#btnVerify').hide();
    //    $('#btnRecommend').hide();
    //    $('#btnRecommendMoreInfo').hide();
    //    $('#btnApprove').hide();
    //    $('#btnApproveMoreinfo').hide();
    //    $('#btApproveForward').hide();
    //    $('#btnReject').hide();
    //    $('#btnApproveMoreinfo').hide();
    //    $('#btnDelete').hide();
    //    $('#btnEditBer2').hide();
    //    if (berstatus == '202') {
    //        $('#btnEdit').show();
    //        $('#btnDelete').show();
    //        $('#btnSaveandAddNew').show();
    //        $('#btnEditBer2').show();
    //    }
    //        //else if ((berstatus == '204' || berstatus == '205') && hasClarifyPermission) {
    //        //    $('#btnClarify').show();
    //        //    $('#btnSaveandAddNew').hide();
    //        //   // $('#btnCancel').hide();
    //        //    $('#btnEdit').show();
    //        //}
    //    else {
    //        $('#btnSaveandAddNew').hide();
    //        // $('#btnCancel').hide();

    //    }

    //    if (berstatus == '202') {
    //        $('#Ber2Remarks').attr('disabled', false);
    //    }
    //    else {
    //        $('#Ber2Remarks').attr('disabled', true);
    //    }
    //    $('#btnCancel').show();
    //    $('#btnCancelBER2').show();
    //    $('#btnAdditionalInfoCancel1').show();
    //}

    //else if (hasVerifyPermission) {
    //    $('#btnSave').hide();
    //    $('#btnEdit').hide();
    //    $('#btnClarify').hide();
    //    $('#btnVerify').hide();
    //    $('#btnRecommend').hide();
    //    $('#btnRecommendMoreInfo').hide();
    //    $('#btnApprove').hide();
    //    $('#btnApproveMoreinfo').hide();
    //    $('#btApproveForward').hide();
    //    $('#btnReject').hide();
    //    $('#btnApproveMoreinfo').hide();
    //    $('#btnSaveandAddNew').hide();
    //    $('#btnDelete').hide();
    //    if (berstatus == '202') {
    //        $('#btnVerify').show();
    //        $('#btnReject').show();
    //        $('#Ber2Remarks').attr('disabled', false);
    //    }
    //    else if (berstatus == '204' || berstatus == '205') {
    //        $('#btnClarify').show();
    //        $('#btnVerify').hide();
    //        $('#btnReject').hide();
    //        $('#Ber2Remarks').attr('disabled', false);
    //    }

    //    else if (berstatus == '209') // clarifed by applicant 
    //    {
    //        $('#btnVerify').hide();
    //        $('#btnReject').hide();
    //        $('#Ber2Remarks').attr('disabled', true);
    //    }
    //    else {
    //        $('#Ber2Remarks').attr('disabled', true);
    //    }
    //    $('#btnCancel').hide();
    //    $('#btnCancelBER2').hide();
    //    $('#btnCancelAHistory').show();
    //    $('#btnCancelMHistory').show();
    //    $('#btnAdditionalInfoCancel1').hide();
    //}
    //else if (hasApprovePermission) {
    //    $('#btnSave').hide();
    //    $('#btnEdit').hide();
    //    $('#btnClarify').hide();
    //    $('#btnVerify').hide();
    //    $('#btnRecommend').hide();
    //    $('#btnRecommendMoreInfo').hide();
    //    $('#btnApprove').hide();
    //    $('#btnApproveMoreinfo').hide();
    //    $('#btApproveForward').hide();
    //    $('#btnReject').hide();
    //    $('#btnApproveMoreinfo').hide();
    //    $('#btnDelete').hide();
    //    $('#btnSaveandAddNew').hide();
    //    if (berstatus == '203') { // submitted 
    //        $('#btnApprove').show();
    //        $('#btnApproveMoreinfo').show();
    //        $('#btApproveForward').show();
    //        $('#btnReject').show();
    //        $('#Ber2Remarks').attr('disabled', false);
    //    }
    //    else if (berstatus == '209') // clarifed by applicant 
    //    {
    //        var bil = $('#BIL').val();
    //        if (bil == 'CHD') {
    //            $('#btnApprove').show();
    //            $('#btnReject').show();
    //            $('#btnApproveMoreinfo').show();
    //            $('#btApproveForward').show();
    //            $('#Ber2Remarks').attr('disabled', false);
    //        }
    //        else {
    //            $('#btnApprove').hide();
    //            $('#btnReject').hide();
    //            $('#btnApproveMoreinfo').hide();
    //            $('#btApproveForward').hide();
    //            $('#Ber2Remarks').attr('disabled', true);
    //        }
    //    }

    //    else if (berstatus == '208') // Recommended
    //    {
    //        $('#btnApprove').show();
    //        $('#btnReject').show();
    //        $('#btnApproveMoreinfo').hide();
    //        $('#btApproveForward').show();
    //        $('#Ber2Remarks').attr('disabled', false);
    //    }
    //        //if (berstatus == '208' || berstatus == '203' || berstatus == '209') {
    //        //    $('#Ber2Remarks').attr('disabled', false);
    //        //}
    //    else {
    //        $('#Ber2Remarks').attr('disabled', true);
    //    }
    //    $('#btnCancel').hide();
    //    $('#btnCancelBER2').hide();
    //    $('#btnCancelAHistory').hide();
    //    $('#btnCancelMHistory').hide();
    //    $('#btnAdditionalInfoCancel1').hide();
    //}
    //else if (hasRecommendPermission) {
    //    $('#btnSave').hide();
    //    $('#btnEdit').hide();
    //    $('#btnClarify').hide();
    //    $('#btnVerify').hide();
    //    $('#btnRecommend').hide();
    //    $('#btnRecommendMoreInfo').hide();
    //    $('#btnApprove').hide();
    //    $('#btnApproveMoreinfo').hide();
    //    $('#btApproveForward').hide();
    //    $('#btnReject').hide();
    //    $('#btnApproveMoreinfo').hide();
    //    $('#btnDelete').hide();
    //    if (berstatus == '207') { // forwarded to liason officer  
    //        $('#btnRecommend').show();
    //        $('#btnRecommendMoreInfo').show();
    //        $('#Ber2Remarks').attr('disabled', false);
    //    }
    //    else if (berstatus == '209') {
    //        var bil = $('#BIL').val();
    //        if (bil == 'CLA') {
    //            $('#btnRecommend').show();
    //            $('#btnRecommendMoreInfo').show();
    //            $('#Ber2Remarks').attr('disabled', false);
    //        }
    //        else {
    //            $('#btnRecommend').hide();
    //            $('#btnRecommendMoreInfo').hide();
    //            $('#Ber2Remarks').attr('disabled', true);
    //        }

    //    } else {
    //        $('#Ber2Remarks').attr('disabled', true);
    //    }
    //    $('#btnCancel').hide();
    //    $('#btnCancelBER2').hide();
    //    $('#btnCancelAHistory').hide();
    //    $('#btnCancelMHistory').hide();
    //    $('#btnAdditionalInfoCancel1').hide();
    //}

}

window.BindValuesOnClickingTab = function () {
    $('#berNord').val($('#berNo').val());
    $('#ApplicationDaterd').val($('#ApplicationDate').val());
    $('#txtAssetNord').val($('#txtAssetNo').val());
    $('#txtassetDescriptionrd').val($('#txtassetDescription').val());
    $('#UserLocationCoderd').val($('#UserLocationCode').val());
    $('#UserLocationNamerd').val($('#UserLocationName').val());
    $('#Modelrd').val($('#Model').val());
    $('#Manufacturerrd').val($('#Manufacturer').val());
    $('#ApplicantNameBER').val($('#ApplicantName').val());
    $('#ApplicantNamerd').val($('#ApplicantName').val());
    $('#ApplicantDesignationrd').val($('#ApplicantDesignation').val());
    $('#AssetAgerd').val($('#AssetAge').val());
    $('#BER2status').val($('#BER1status').val());
    if ($('#StillwithInLifeSpan').val() == "99" || $('#StillwithInLifeSpan').val() == 99) {
        $('#radio21').attr('checked', true);
        $('#radio22').attr('checked', false);
    }
    else {
        $('#radio21').attr('checked', false);
        $('#radio22').attr('checked', true);
    }
    $('#CurrentValueBer2').val($('#CurrentValue').val());
}


window.EmptyFieldsBER2 = function () {
    $('#BIL').val('');
    $('#TotalContractCost').val('');
    $('#PastMaintenanceCost').val('');
    $(".content").scrollTop(0);
    $('.status').html("");
    $('input[type="text"], textarea').val('');
    $('.nav-tabs a:first').tab('show');
    $("input[name=EstimatedCosttooExpensive][value=" + 0 + "]").prop('checked', true);
    $("input[name=NotReliableId][value=" + 0 + "]").prop('checked', true);
    $("input[name=StatuaryRequirementsid][value=" + 0 + "]").prop('checked', true);
    $("input[name=ObsolescenceId][value=" + 0 + "]").prop('checked', true);
    $("input[name=EstimatedCosttooExpensive][value=" + 0 + "]").prop('disabled', false);
    $("input[name=EstimatedCosttooExpensive][value=" + 1 + "]").prop('disabled', false);
    $("input[name=NotReliableId][value=" + 0 + "]").prop('disabled', false);
    $("input[name=NotReliableId][value=" + 1 + "]").prop('disabled', false);
    $("input[name=StatuaryRequirementsid][value=" + 0 + "]").prop('disabled', false);
    $("input[name=StatuaryRequirementsid][value=" + 1 + "]").prop('disabled', false);
    $("input[name=ObsolescenceId][value=" + 0 + "]").prop('disabled', false);
    $("input[name=ObsolescenceId][value=" + 1 + "]").prop('disabled', false);
    $('#ApprovedBER').attr('checked', false);
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#grid").trigger('reloadGrid');
    $("#beroneformid :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    // $('#EstimatedCosttooExpensiveCheckboxId').val('');
    $('#RemarksGridId').empty();
    $('#service').val("BEMS");
    // $('#NotReliableId').val("null");
    //$('#StatuaryRequirementsid').val("null");
    $('#BERActionStatus').val(202);
    $('#BER1status').val(202);
    $('#AssetNoDiv').show();
    $('#companypopup').show();
    // $('#EstimatedCosttooExpensiveCheckboxId').prop('checked', false);
    ///*****To make Editable ******\\
    $('#RejectedBER').prop('disabled', false);
    $('#ApplicationDate').prop('disabled', false);
    $('#txtAssetNo').prop('disabled', false);
    $('#RepairEstimateCost').prop('disabled', false);
    // $('#AfterRepairValue').prop('disabled', false);
    $('#cannotRepair').prop('disabled', false);
    $('#CurrentValue').prop('disabled', false);
    $('#estimatedDurationOfUsageAfterRepair').prop('disabled', false);
    // $('#FrequencyBreakDown').prop('disabled', false);
    //  $('#TotalCostonImprovement').prop('disabled', false);
    $('#txtCompanyStaffName').prop('disabled', false);
    // $('#EstimatedCosttooExpensiveCheckboxId').prop('disabled', false);
    $('#radios-1').prop('disabled', false);
    $('#radios-2').prop('disabled', false);
    $('#otherObservations').prop('disabled', false);
    $('#Remarks').prop('disabled', false);
    $('#radios1').attr('checked', false);
    $('#radios2').attr('checked', false);
    $('#radios3').attr('checked', false);
    $('#radios4').attr('checked', false);
    $('#cannotRepair').prop('checked', false);
    $('#estimatedRepairCostlabelid').html("Estimated Repair Cost (RM) <span class='red'>*</span>");
    $('#ApprovedBER').attr('checked', false);
    $('#ApprovedBER').prop('checked', false);
    $('#RejectedBER').attr('checked', false);
    $('#RejectedBER').prop('checked', false);
    $('#txtAssetNo').attr('disabled', false);
    $('#txtOldBerNo').attr('disabled', true);
    $('#txtOldBerNo').val('');
    $('#ApprovedBERDiv').hide();
    // $('#rejectedBERDiv').show();
    $('#hdnRejectedBERReferenceId').val(null);
    $('#AssetNoDiv').show();
    $('#RejectedBER').attr('disabled', false);
    ///**** End****\\

    $.get("/api/BerOne/Load")
       .done(function (result) {
           //Bind drop down values 
           var loadResult = JSON.parse(result);
           $('#FacilityName').val(loadResult.FacilityName);
           $('#FacilityCode').val(loadResult.FacilityCode);

           $('#BERActionStatus').val(202);
           $('#BER1status,#BER2status').val(202); // New
           $('#hdnCompanyStaffId').val(loadResult.ApplicantStaffId);
           $('#txtCompanyStaffName').val(loadResult.ApplicantStaffName);
           $('#txtDesignation').val(loadResult.ApplicantDesignation);
           $('#hdnApplicantStaffId').val(loadResult.ApplicantStaffId);
           $('#ApplicantName').val(loadResult.ApplicantStaffName);
           $('#ApplicantDesignation').val(loadResult.ApplicantDesignation);
       })
 .fail(function () {
     $('#myPleaseWait').modal('hide');
     $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
     $('#errorMsg').css('visibility', 'visible');
 });

}



//var _service = $('#Services').val();
//var _berScreen = $('#BERScreen').val();
//var _screenPageId = 0;

//switch (_service) {
//    case "BEMS":  {_screenPageId = _berScreen=="BER1"? 91:92 ; break;}
//    case "FEMS": { _screenPageId = _berScreen == "BER1" ? 460 : 461; break; }
//    case "ICT": { _screenPageId = _berScreen == "BER1" ? 625 : 626; break; }

//}


var _EditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any(x=>x.ActionPermissionName == 'Edit');
var _AddPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any(x=>x.ActionPermissionName == 'Add');
var _DeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any(x=>x.ActionPermissionName == 'Delete');
var _VerifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any(x=>x.ActionPermissionName == 'Verify');
var _ApprovePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any(x=>x.ActionPermissionName == 'Approve');
var _ClarifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any(x=>x.ActionPermissionName == 'Clarify');
var _RecommendPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any(x=>x.ActionPermissionName == 'Recommend');
var _RejectPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any(x=>x.ActionPermissionName == 'Reject');

function hideall() {
    $('#btnEdit').hide();
    $('#btnDelete').hide();
    $('#btnSaveandAddNew').hide();
    $('#btnSave').hide();
    $('#btnClarify').hide();
    $('#btnVerify').hide();
    $('#btnRecommend').hide();
    $('#btnRecommendMoreInfo').hide();
    $('#btnApprove').hide();
    $('#btnApproveMoreinfo').hide();
    $('#btApproveForward').hide();
    $('#btnReject').hide();
}
function OnSave() {
    if (_AddPermission) {

        $('#btnSaveandAddNew').show();
    }
    if (_EditPermission) {
        $('#btnEdit').show();

    }
    if (_DeletePermission) {
        $('#btnDelete').show();
    }
    if (_VerifyPermission) {
        $('#btnVerify').show();
    }
    else {
        hideall();
    }


    //-------------------------------------------------


    $('#btnSave').hide();
    $('#btnClarify').hide();
    $('#btnRecommend').hide();
    $('#btnRecommendMoreInfo').hide();
    $('#btnApprove').hide();
    $('#btnApproveMoreinfo').hide();
    $('#btApproveForward').hide();
}
function PostDraft() {

    PostSubmitted();
}
function PostSubmitted() {

    if (_ApprovePermission) {


        $('#btnApprove').show();
        $('#btnApproveMoreinfo').show();
        $('#btApproveForward').show();


        //-------------------------------------------------

        $('#btnEdit').hide();
        $('#btnDelete').hide();
        $('#btnSaveandAddNew').hide();
        $('#btnSave').hide();
        $('#btnClarify').hide();
        $('#btnVerify').hide();
        $('#btnRecommend').hide();
        $('#btnRecommendMoreInfo').hide();

    }
    if (_RejectPermission) {
        $('#btnReject').show();
    }
    else {

        hideall();

    }


}
function PostClarifiedByApplicant() {

    if (_ApprovePermission) {



        $('#btnApprove').show();
        $('#btnApproveMoreinfo').show();
        $('#btApproveForward').show();


        //-------------------------------------------------

        $('#btnEdit').hide();
        $('#btnDelete').hide();
        $('#btnSaveandAddNew').hide();
        $('#btnSave').hide();
        $('#btnClarify').hide();
        $('#btnVerify').hide();
        $('#btnRecommend').hide();
        $('#btnRecommendMoreInfo').hide();

    }
    if (_RejectPermission) {
        $('#btnReject').show();
    }
    else {

        hideall();

    }



}
function PostClarificationSoughtByHD() {

    if (_ClarifyPermission) {
        $('#btnClarify').show();

        $('#btnEdit').hide();
        $('#btnDelete').hide();
        $('#btnSaveandAddNew').hide();
        $('#btnSave').hide();
        $('#btnVerify').hide();
        $('#btnRecommend').hide();
        $('#btnRecommendMoreInfo').hide();
        $('#btnApprove').hide();
        $('#btnApproveMoreinfo').hide();
        $('#btApproveForward').hide();
        $('#btnReject').hide();
    }

    else {
        hideall();
    }

}
function PostClarificationSoughtByLiaisonOfficer() {

    if (_ClarifyPermission) {
        $('#btnClarify').show();

        $('#btnEdit').hide();
        $('#btnDelete').hide();
        $('#btnSaveandAddNew').hide();
        $('#btnSave').hide();
        $('#btnVerify').hide();
        $('#btnRecommend').hide();
        $('#btnRecommendMoreInfo').hide();
        $('#btnApprove').hide();
        $('#btnApproveMoreinfo').hide();
        $('#btApproveForward').hide();
        $('#btnReject').hide();
    }

    else {
        hideall();
    }

}
function PostForwardedtoLiaisonOfficer() {
    if (_RecommendPermission) {

        $('#btnRecommend').show();
        $('#btnRecommendMoreInfo').show();


        $('#btnClarify').hide();
        $('#btnEdit').hide();
        $('#btnDelete').hide();
        $('#btnSaveandAddNew').hide();
        $('#btnSave').hide();
        $('#btnVerify').hide();
        $('#btnApprove').hide();
        $('#btnApproveMoreinfo').hide();
        $('#btApproveForward').hide();
        $('#btnReject').hide();

    }

    else { hideall() }
}
function PostRecommended() {

    if (_ApprovePermission) {
        $('#btnApprove').show();
        //$('#btApproveForward').show();
        //$('#btnApproveMoreinfo').show();

        $('#btnEdit').hide();
        $('#btnDelete').hide();
        $('#btnSaveandAddNew').hide();
        $('#btnSave').hide();
        $('#btnVerify').hide();
        $('#btnRecommend').hide();
        $('#btnRecommendMoreInfo').hide();
        $('#btnApproveMoreinfo').hide();


    }

    if (_RejectPermission) {
        $('#btnReject').show();
    }
    else {
        hideall();
    }
}
function PostApproved()
{ hideall(); }
function PostRejected()
{ hideall(); }






