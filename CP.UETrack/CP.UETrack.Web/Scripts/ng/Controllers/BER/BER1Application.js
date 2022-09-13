var ListModel = [];


$(document).ready(function () {
    
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
   
    //$('#HealthyandSafetyHazards').attr('disabled', false);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasAddPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Add'");
    var hasVerifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Verify'");
    var hasApprovePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");
    var hasRejectPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Reject'");
    var hasRecommendPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Recommend'");
    var hasClarifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Clarify'");
    var primaryID = $('#primaryID').val();
    $('#txtOldBerNo,#EstimatedCosttooExpensive').attr('disabled', true);
    $('#txtOldBerNo,#ConditionAppraisalofEquipment').attr('disabled', false);
    // var actionType = $('#ActionType').val();
    $('#rejectedBERDiv').hide();
    // if (actionType == 'Approve' || actionType == 'Reject' || actionType == 'Verify') {
    if (hasApprovePermission || hasRejectPermission || hasVerifyPermission || hasRecommendPermission) {
        DisableFormFields();
        $('#btnCancel').hide();
        $('#btnAdditionalInfoCancel1').hide();
        $('#btnCancelAHistory').hide();
        $('#btnCancelMHistory').hide();
        $('#btnSaveandAddNew').hide();
        $('#AssetNoDiv,#companypopup').hide();
        $('#Remarks').attr('disabled', false);
        $('#btnDelete').hide();
    }
    else {
        $('#btnSaveandAddNew').show();
        $('#btnAdditionalInfoCancel1').show();
        $('#btnCancel').show();
        $('#btnCancelAHistory').show();
        $('#btnCancelMHistory').show();

    }
    $('#estimatedRepairCostlabelid').html("Estimated Repair Cost (RM) <span class='red'>*</span>");
    $('#myPleaseWait').modal('show');
    formInputValidation("beroneformid");

    $.get("/api/BerOne/Load")
        .done(function (result) {            
            //Bind drop down values 
            var loadResult = JSON.parse(result);
            $.each(loadResult.ServiceList, function (index, value) {
                $('#ServiceId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.HealthSafetyLovs, function (index, value) {
                $('#healthysafetyHazardsId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.MajorBreakdownLovs, function (index, value) {
                $('#MajorBreakdownId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.BER1StatusLovs, function (index, value) {
                $('#BER1status').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });            
            $('#Services').val(loadResult.Services);

            $('#FacilityName').val(loadResult.FacilityName);
            $('#FacilityCode').val(loadResult.FacilityCode);
            if (primaryID == "0" || primaryID == 0) {
                $('#BERActionStatus').val(202);
                $('#BER1status').val(202); // New
                $('#hdnCompanyStaffId').val(loadResult.ApplicantStaffId);
                $('#txtCompanyStaffName').val(loadResult.ApplicantStaffName);
                $('#txtDesignation').val(loadResult.ApplicantDesignation);
            }
            $('#CurrentDate').val(DateFormatter(loadResult.CurrentDate));
            $('#hdnApplicantStaffId').val(loadResult.ApplicantStaffId);
            $('#ApplicantName').val(loadResult.ApplicantStaffName);
            $('#ApplicantDesignation').val(loadResult.ApplicantDesignation);


            $('#myPleaseWait').modal('hide');
        }).fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });



    // first header data 

    $("#btnSave,#btnEdit,#btnSaveandAddNew").click(function () {
        
        var CurrentbtnID = $(this).attr("Id");
        Submit("Save", CurrentbtnID);
    });

    function Submit(buttontext, CurrentbtnID) {
        
        $('#myPleaseWait').modal('show');
        var primaryId = $("#primaryID").val();
        var date = getDateToCompare($('#CurrentDate').val());
        var applicationDate = getDateToCompare($('#ApplicationDate').val());
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var BER1status = $('#BERActionStatus').val();
        var remarks = $('#Remarks').val();
        var RepairEstimateCost = $('#RepairEstimateCost').val();
        RepairEstimateCost = RepairEstimateCost.split(',').join('');
        var CurrentValue = $('#CurrentValue').val();
        var AssetId = $('#hdnAssetId').val();
        CurrentValue = CurrentValue.split(',').join('');
        var cannotRepair = false;
        var checkBox = document.getElementById("cannotRepair");
        if (checkBox.checked) {
            cannotRepair = true;
        }
        else
            cannotRepair = false;
        var isFormValid = formInputValidation("beroneformid", 'save');
        if (!isFormValid || (parseInt(CurrentValue) == 0 || CurrentValue == '0')) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            if (!cannotRepair && (RepairEstimateCost == 0 || RepairEstimateCost == "")) {

                $('#RepairEstimateCost').parent().addClass('has-error');
            }
            if (parseInt(CurrentValue) == 0 || CurrentValue == '0') {
                $('#CurrentValue').parent().addClass('has-error');
            }
            DisplayError();
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
            DisplayError();
            return false;
        }


        else if ((BER1status == 209 || BER1status == 210 || BER1status == 204 || BER1status == 205) && remarks.trim() == "") {
            $("div.errormsgcenter").text(Messages.BER_RemarksMandatory);
            DisplayError();
            $('#Remarks').parent().addClass('has-error');
            return false;
        }

        //input fieds

        var OldberNo = $('#txtOldBerNo').val();
        var RejectedBERReferenceId = $('#hdnRejectedBERReferenceId').val();
        var BERNo = $('#BERNo').val();
        var ApplicationDate = $('#ApplicationDate').val();
        var FaciliName = $('#FaciliName').val();
        var FacilityCode = $('#FacilityCode').val();

        var AssetNo = $('#txtAssetNo').val();
        var AssetDescription = $('#txtassetDescription').val();

        var AfterRepairValue = $('#AfterRepairValue').val();
        AfterRepairValue = AfterRepairValue.split(',').join('');
        //var cannotRepair = document.getElementById("cannotRepair");

        var EstimatedDurationOfUsageAfterRepair = $('#estimatedDurationOfUsageAfterRepair').val();
        // var FrequencyBreakDown = $('#FrequencyBreakDown').val();
        // var TotalCostonImprovement = $('#TotalCostonImprovement').val();
        var requestorId = $('#hdnCompanyStaffId').val();
        var RequesterName = $('#RequesterName').val();
        var Designation = $('#Designation').val();

        //Condition Appraisal of Equipment/Vehicle

        var EstimatedCosttooExpensive = $("input[name=EstimatedCosttooExpensive]:checked").val();
        var ConditionAppraisalofEquipment = $("input[name=ConditionAppraisalofEquipment]:checked").val();
        var Obsolescence = $("input[name=ObsolescenceId]:checked").val();
        var NotReliableId = $("input[name=NotReliableId]:checked").val();
        var StatuaryRequirementsid = $("input[name=StatuaryRequirementsid]:checked").val();

        // var Obsolescence = $("input[name='radios']:checked").val();
        var TechnicalSupportNo = $('#TechnicalSupportNo').val();
        var TechnicalSupportId = $('#TechnicalSupportId').val();
        // var NotReliableId = $('#NotReliableId').val();
        // var StatuaryRequirementsid = $('#StatuaryRequirementsid').val();
        var otherObservations = $('#otherObservations').val();
        var ApplicantId = $('#hdnApplicantStaffId').val();
        var ApplicantName = $('#txtCompanyStaffName').val();
        var Designation = $('#Designation').val();
        var serviceId = 2;
        var timeStamp = $("#Timestamp").val();
        var BerObj = {
            // BERno: $('#berNo').val(),
            ServiceId: 2,
            BERno: BERNo,
            AssetId: AssetId,
            AssetNo: AssetNo,
            BIL: $('#BIL').val(),
            EstRepcostToExpensive: (EstimatedCosttooExpensive == 1 || EstimatedCosttooExpensive == "1") ? true : false,
            ConditionAppraisalofEquipment: (ConditionAppraisalofEquipment == 1 || ConditionAppraisalofEquipment == "1") ? true : false,
            Obsolescence: (Obsolescence == 1 || Obsolescence == "1") ? true : false,
            NotReliable: (NotReliableId == 1 || NotReliableId == "1") ? true : false,
            StatutoryRequirements: (StatuaryRequirementsid == 1 || StatuaryRequirementsid == "1") ? true : false,
            // RepairEstimate: RepairEstimateCost,
            ValueAfterRepair: AfterRepairValue,
            EstDurUsgAfterRepair: EstimatedDurationOfUsageAfterRepair,
            //  NotReliable: NotReliableId,
            // StatutoryRequirements: StatuaryRequirementsid,
            OtherObservations: otherObservations,
            ApplicantStaffId: ApplicantId,
            BERStatus: BER1status,
            BER1Remarks: remarks,
            ApplicationDate: ApplicationDate,
            RejectedBERReferenceId: RejectedBERReferenceId,
            BERStage: 1,
            EstimatedRepairCost: RepairEstimateCost,
            CurrentValue: CurrentValue,
            RequestorId: requestorId,
            CannotRepair: (cannotRepair == 1 || cannotRepair == "1") ? true : false, 
        };


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
            BindBER1HeaderData(result, 1);
            $('#txtOldBerNo').attr('disabled', true);
            if (result != null && result.BERApplicationRemarksHistoryTxns != null && result.BERApplicationRemarksHistoryTxns.length > 0) {
                BindRemarksHistory(result.BERApplicationRemarksHistoryTxns);
            }
            $(".content").scrollTop(0);
            showMessage('BERApplicationOne', CURD_MESSAGE_STATUS.SS);
            $("#grid").trigger('reloadGrid');
            if (result.ApplicationId != 0) {
            }
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            if (CurrentbtnID == "btnSaveandAddNew") {
                EmptyFields();
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

          //if (errorMessage = "Application Date cannot be Future Date") {
          //    $('#ApplicationDate').parent().addClass('has-error');
          //}
          $("div.errormsgcenter").text(errorMessage);
          $('#errorMsg').css('visibility', 'visible');
          $('#btnSave').attr('disabled', false);
          $('#myPleaseWait').modal('hide');
      });
    }

    $("#btnCancel").click(function () {
        var message = Messages.Reset_Alert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                EmptyFields();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });

    $("#btnCancelHist,#AttachCancel,#btnCancelAHistory,#btnCancelMHistory").click(function () {
        //window.location.href = "/BER/BER1Application";
        var message = Messages.Reset_TabAlert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                EmptyFields();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });

    $("#hdnRejectedBERReferenceId").change(function () {
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

        var ApplicationId = $('#hdnRejectedBERReferenceId').val();

        if (ApplicationId != null && ApplicationId != "0" && ApplicationId != "") {
            $.get("/api/BerOne/Get/" + ApplicationId)
              .done(function (result) {

                  var getResult = JSON.parse(result);
                  BindEquipmentData(getResult);
                  BindBER1HeaderData(getResult, 2);
                  $('#myPleaseWait').modal('hide');
              })
             .fail(function () {
                 $('#myPleaseWait').modal('hide');
                 $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                 $('#errorMsg').css('visibility', 'visible');
             });
        }
    });


    $("#RejectedBER").change(function () {
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
        $('#ApplicationDate').val("");
        $('#RepairEstimateCost').val("");
        $('#AfterRepairValue').val("");
        $('#CurrentValue').val("");
        $('#estimatedDurationOfUsageAfterRepair').val("");

        $('#AssetAge').val("");
        $('#StillwithInLifeSpan').val("");
        $('#CurrentValue').val("");
        if (this.checked) {
            $('#txtOldBerNo').attr('disabled', false);
            // $('#ApplicationDate').attr('disabled', true);

            $('#txtAssetNo').attr('disabled', true);
            $('#AssetNoDiv').hide();
            $('#rejectedBERDiv').show();
            //Do stuff
        }
        else {
            $('#txtAssetNo').attr('disabled', false);
            $('#txtOldBerNo').attr('disabled', true);
            //$('#ApplicationDate').attr('disabled', false);
            $('#txtOldBerNo').val('');
            $('#hdnRejectedBERReferenceId').val(null);
            $('#AssetNoDiv').show();
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
    function DisplayError() {
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnSave').attr('disabled', false);
    }
    function performAction(BerStatusText) {
        var isFormValid = formInputValidation("beroneformid", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            DisplayError();
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
                    Submit('UPDATEAPPROVE');
                }
            });

        }


    }

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
    if (ID == null || ID == undefined || ID == 0 || ID == '' || ID == "") {
        $("#jQGridCollapse1").click();
    }
    else {
        LinkClicked(ID);
    }
    // **** Query String to get ID  End****\\\
});
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


//  ************************************Save *************************************



// Insert records in the previous row



//function goBack() {
//    window.location.href = "/BER/BER1Application";
//}
function BindRemarksHistory(list) {
    var IndNumber = 0;
    $('#RemarksGridId').empty();
    var html = '';
    var sno = parseInt(list.length);

    $.each(list, function (index, data) {
        IndNumber = sno - index;
        html += ' <tr class="ng-scope" style=""><td width="10%" style="text-align: center;"><div> <input type="text"  class="form-control" id="No_maxindexval" value="' + IndNumber + '" readonly/></div></td><td width="45%" style="text-align: center;"><div> ' +
                ' <input type="text" id="Remarks_maxindexval" value="' + data.Remarks + '" style="max-width:100%;"   class="form-control" readonly /></div></td><td width="25%" style="text-align: center;"><div> ' +
                '<input type="text" id="EnteredBy_maxindexval" value="' + data.EnteredBy + '"  class="form-control" readonly /></div></td><td width="20%" style="text-align: center;"><div> ' +
                 '<input type="text" id="UpdatedDate_maxindexval" value="' + DateFormatter(data.UpdatedDate) + '" class="form-control" readonly /></div></td></tr> ';

    });
    $('#RemarksGridId').append(html);
}

function BindEquipmentData(getResult) {
    $(".content").scrollTop(1);
    $('#ServiceId').val(getResult.ServiceId);
    $('#berNo').val(getResult.BERno);
    $('#hdnAssetId').val(getResult.AssetId);
    $('#txtassetDescription').val(getResult.AssetDescription);
    $('#txtAssetNo').val(getResult.AssetNo);
    $('#UserLocationCode').val(getResult.UserLocationCode);
    $('#UserLocationName').val(getResult.UserLocationName);
    $('#Model').val(getResult.Model);
    $('#BIL').val(getResult.BIL);
    $('#Manufacturer').val(getResult.Manufacturer);
    $('#SupplierName').val(getResult.SupplierName);
    if (getResult.PurchaseCost != null) {
        $('#PurchaseCost').val(addCommas(getResult.PurchaseCost));
    }
    else {
        $('#PurchaseCost').val(getResult.PurchaseCost);
    }

    $('#PurchaseDate').val(DateFormatter(getResult.PurchaseDate));

    if (getResult.CurrentValue != null) {

        var cval = (getResult.CurrentValue).toFixed(2);
        $('#CurrentValue').val(addCommas(cval));
    } else {
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
    // $('#FrequencyBreakDown').val(getResult.FreqDamSincPurchased);
}


function BindBER1HeaderData(getResult, rejectedreocrd) {

    if (getResult.EstRepcostToExpensive) {
        $("input[name=EstimatedCosttooExpensive][value=" + 1 + "]").prop('checked', true);

    }
   
    else {
        $("input[name=EstimatedCosttooExpensive][value=" + 0 + "]").prop('checked', true);
    }
    if (getResult.ConditionAppraisalofEquipment) {
        $("input[name=ConditionAppraisalofEquipment][value=" + 1 + "]").prop('checked', true);

    }
    else {
        $("input[name=ConditionAppraisalofEquipment][value=" + 0 + "]").prop('checked', true);
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

    $('#RepairEstimateCost').val(getResult.RepairEstimate);

    if (getResult.ValueAfterRepair != null) {
        $('#AfterRepairValue').val(addCommas(getResult.ValueAfterRepair));
    }
    else {
        $('#AfterRepairValue').val(getResult.ValueAfterRepair);
    }
    $('#estimatedDurationOfUsageAfterRepair').val(getResult.EstDurUsgAfterRepair);
    //$('#NotReliableId').val(getResult.NotReliable);
    $('#otherObservations').val(getResult.OtherObservations);
    //$('#StatuaryRequirementsid').val(getResult.StatutoryRequirements);
    $('#BERStatusValue').val(getResult.BERStatusValue);
    $('#Remarks').val(getResult.BER1Remarks);
    $('#ApprovedDate').val(getResult.ApprovedDate);
    // $('#ApplicationDate').val(DateFormatter(getResult.ApplicationDate));
    // $('#BERStage').val(getResult.BERStage);
    $('#hdnRejectedBERReferenceId').val(getResult.RejectedBERReferenceId);

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
    $('#Timestamp').val(getResult.Timestamp);
    $('#RejectedBER').attr('disabled', true);
    $('#hdnCompanyStaffId').val(getResult.RequestorId);
    $('#txtCompanyStaffName').val(getResult.RequestorName);
    $('#txtDesignation').val(getResult.RequestorDesignation);
    $('#hdnAttachId').val(getResult.HiddenId);

    //rejected record 
    if (rejectedreocrd == 2) {
        $('#ParentApplicationId').val(getResult.ApplicationId);
        $('#hdnRejectedBERReferenceId').val(getResult.ApplicationId);
        $('#BER1status,#BERActionStatus').val(202);
        $('#berNo').val('');
        $('#RejectedBER').attr('disabled', false);
        $('#ApplicationDate').val('');
        $('#ApplicationDate').prop('disabled', false);
    }

    else {
        $('#ApplicationDate').prop('disabled', true);
        $('#ApplicationDate').val(DateFormatter(getResult.ApplicationDate));
        $('#primaryID').val(getResult.ApplicationId);
        $('#BER1status').val(getResult.BERStatus);
        $('#BERActionStatus').val(getResult.BERStatus);
    }

    $('#txtAssetNo').prop('disabled', true);
    //$('#txtAssetNo,#ApplicationDate').prop('disabled', true);
    $('#rejectedBERDiv,#AssetNoDiv').hide();
    var berstatus = $('#BERActionStatus').val();
    if (berstatus == '202' || berstatus == '203' || berstatus == '204' || berstatus == '205' || berstatus == '207' || berstatus == '208' || berstatus == '209') {
        $('#Remarks').val('');
    }

    if (berstatus == 202 || berstatus == 204 || berstatus == 205) {

    }
    else {

        DisableFormFields();
        $('#companypopup').hide();
    }

    //if (berstatus != 202 ) {
    //    DisableFormFields();
    //    $('#companypopup').hide();
    //}
    if (berstatus == 206 || berstatus == 210) {

        $('#Remarks').attr('disabled', true);
    }
    else {
        $('#Remarks').attr('disabled', false);
    }
    $('.status').html("");
    DisableButtons();

    //*************************** Attachment button hide **************************

    if ((berstatus == "203" || berstatus == 203 || berstatus == "206" || berstatus == 206 || berstatus == "210" || berstatus == 210)) {
        $('#AttachRowPlus').hide();
        $('#btnEditAttachment').hide();
    }
    else {
        $('#AttachRowPlus').show();
        $('#btnEditAttachment').show();
    }

    switch (berstatus) {
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

}
function DisableFormFields() {
    $("#beroneformid :input:not(:button)").prop("disabled", false);
    $("#CommonAttachment :input:not(:button)").prop("disabled", true);
}
function LinkClicked(id, rowData) {
    
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show')
    $("#beroneformid :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");
    var hasApprovePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");

    var hasverifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Verify'");
    if (hasEditPermission) {
        action = "Edit"

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
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/BerOne/Get/" + primaryId)
          .done(function (result) {
              var getResult = JSON.parse(result);
              BindEquipmentData(getResult);
              BindBER1HeaderData(getResult, 1);
              if (getResult != null && getResult.BERApplicationRemarksHistoryTxns != null && getResult.BERApplicationRemarksHistoryTxns.length > 0) {
                  BindRemarksHistory(getResult.BERApplicationRemarksHistoryTxns);
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
                 showMessage('BER1', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 EmptyFields();
             })
             .fail(function () {
                 showMessage('BER1', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
        }

    });
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






    var BerStatusText= parseInt(berstatus);
   
       
    $('#Remarks').attr('disabled', false);

    $('#btnCancel').hide();
    $('#btnAdditionalInfoCancel1').hide();
    $('#btnCancelAHistory').hide();
    $('#btnCancelMHistory').hide();

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








    // if (hasAddPermission || hasClarifyPermission) {

 

            


   //   if (hasAddPermission) {
   //     $('#btnSave').hide();
   //     $('#btnEdit').hide();
   //     $('#btnClarify').hide();
   //     $('#btnVerify').hide();
   //     $('#btnRecommend').hide();
   //     $('#btnRecommendMoreInfo').hide();
   //     $('#btnApprove').hide();
   //     $('#btnApproveMoreinfo').hide();
   //     $('#btApproveForward').hide();
   //     $('#btnReject').hide();
   //     $('#btnApproveMoreinfo').hide();
   //     $('#btnDelete').hide();
   //     if (berstatus == '202') {
   //         $('#btnEdit').show();
   //         $('#btnDelete').show();
   //         $('#btnSaveandAddNew').show();

   //     }

   //     else {
   //         $('#btnSaveandAddNew').hide();
   //     }

   //     if (berstatus == '202') {
   //         $('#Remarks').attr('disabled', false);
   //     }
   //     else {
   //         $('#Remarks').attr('disabled', true);
   //     }
   //     $('#btnCancel').show();
   //     $('#btnAdditionalInfoCancel1').show();
   //     $('#btnCancelAHistory').show();
   //     $('#btnCancelMHistory').show();
   // }

   //else  if (hasVerifyPermission) {
   //     $('#btnSave').hide();
   //     $('#btnEdit').hide();
   //     $('#btnClarify').hide();
   //     $('#btnVerify').hide();
   //     $('#btnRecommend').hide();
   //     $('#btnRecommendMoreInfo').hide();
   //     $('#btnApprove').hide();
   //     $('#btnApproveMoreinfo').hide();
   //     $('#btApproveForward').hide();
   //     $('#btnReject').hide();
   //     $('#btnApproveMoreinfo').hide();
   //     $('#btnSaveandAddNew').hide();
   //     $('#btnDelete').hide();
   //     if (berstatus == '202') {
   //         $('#btnVerify').show();
   //         $('#btnReject').show();
   //         $('#Remarks').attr('disabled', false);
   //     }
   //     else if (berstatus == '204' || berstatus == '205') {
   //         $('#btnClarify').show();
   //         $('#btnVerify').hide();
   //         $('#btnReject').hide();
   //         $('#Remarks').attr('disabled', false);
   //     }
   //     else if (berstatus == '209') // clarifed by applicant 
   //     {
   //         $('#btnVerify').hide();
   //         $('#btnReject').hide();
   //         $('#Remarks').attr('disabled', true);
   //     }

   //     else {
   //         // $('#btnClarify').hide();
   //         $('#Remarks').attr('disabled', true);
   //     }
   //     $('#btnCancel').hide();
   //     $('#btnAdditionalInfoCancel1').hide();
   //     $('#btnCancelAHistory').hide();
   //     $('#btnCancelMHistory').hide();
   //  }

   //else  if (hasApprovePermission) {
   //     $('#Remarks').attr('disabled', true);
   //     $('#btnSave').hide();
   //     $('#btnEdit').hide();
   //     $('#btnClarify').hide();
   //     $('#btnVerify').hide();
   //     $('#btnRecommend').hide();
   //     $('#btnRecommendMoreInfo').hide();
   //     $('#btnApprove').hide();
   //     $('#btnApproveMoreinfo').hide();
   //     $('#btApproveForward').hide();
   //     $('#btnReject').hide();
   //     $('#btnApproveMoreinfo').hide();
   //     $('#btnDelete').hide();
   //     $('#btnSaveandAddNew').hide();
   //     if (berstatus == '203') { // submitted 
   //         $('#btnApprove').show();
   //         $('#btnApproveMoreinfo').show();
   //         $('#btApproveForward').show();
   //         $('#btnReject').show();
   //         $('#Remarks').attr('disabled', false);
   //     }
   //     else if (berstatus == '209') // clarifed by applicant 
   //     {

   //         var bil = $('#BIL').val();
   //         if (bil == 'CHD') {
   //             $('#btnApprove').show();
   //             $('#btnReject').show();
   //             $('#btnApproveMoreinfo').show();
   //             $('#btApproveForward').show();
   //             $('#Remarks').attr('disabled', false);
   //         }
   //         else {


   //             $('#btnApprove').hide();
   //             $('#btnReject').hide();
   //             $('#btnApproveMoreinfo').hide();
   //             $('#btApproveForward').hide();
   //             $('#Remarks').attr('disabled', true);
   //         }


   //     }

   //     else if (berstatus == '208') // Recommended
   //     {
   //         $('#btnApprove').show();
   //         $('#btnReject').show();
   //         $('#btnApproveMoreinfo').hide();
   //         $('#btApproveForward').show();
   //         $('#Remarks').attr('disabled', false);
   //     }
   //     //if (berstatus == '208' || berstatus == '203') {
   //     //    $('#Remarks').attr('disabled', false);
   //     //}
   //     //else {
   //     //    $('#Remarks').attr('disabled', true);
   //     //}
   //     $('#btnCancel').hide();
   //     $('#btnAdditionalInfoCancel1').hide();
   //     $('#btnCancelAHistory').hide();
   //     $('#btnCancelMHistory').hide();
   //  }
            
   //else if (hasRecommendPermission) {
   //     $('#btnSave').hide();
   //     $('#btnEdit').hide();
   //     $('#btnClarify').hide();
   //     $('#btnVerify').hide();
   //     $('#btnRecommend').hide();
   //     $('#btnRecommendMoreInfo').hide();
   //     $('#btnApprove').hide();
   //     $('#btnApproveMoreinfo').hide();
   //     $('#btApproveForward').hide();
   //     $('#btnReject').hide();
   //     $('#btnApproveMoreinfo').hide();
   //     $('#btnDelete').hide();
   //     if (berstatus == '207') { // forwarded to liason officer  
   //         $('#btnRecommend').show();
   //         $('#btnRecommendMoreInfo').show();
   //         $('#Remarks').attr('disabled', false);
   //     }
   //     else if (berstatus == '209') {
   //         var bil = $('#BIL').val();
   //         if (bil == 'CLA') {
   //             $('#btnRecommend').show();
   //             $('#btnRecommendMoreInfo').show();
   //             $('#Remarks').attr('disabled', false);
   //         }
   //         else {
   //             $('#btnRecommend').hide();
   //             $('#btnRecommendMoreInfo').hide();
   //             $('#Remarks').attr('disabled', true);
   //         }
   //     }

   //     else {
   //         $('#Remarks').attr('disabled', true);
   //     }
   //     $('#btnCancel').hide();
   //     $('#btnCancelAHistory').hide();
   //     $('#btnCancelMHistory').hide();
   //     $('#btnAdditionalInfoCancel1').hide();
   //  }



}

window.EmptyFields = function () {
    $('#TotalContractCost').val('');
    $(".content").scrollTop(0);
    $('#PastMaintenanceCost').val('');
    $('.status').html("");
    $('input[type="text"], textarea').val('');
    $('#BIL').val('');
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnSaveandAddNew').show();
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#grid").trigger('reloadGrid');
    $("#beroneformid :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('.nav-tabs a:first').tab('show');
    $('#RemarksGridId').empty();
    $('#service').val("BEMS");

    $("input[name=EstimatedCosttooExpensive][value=" + 0 + "]").prop('checked', true);
    $("input[name=ConditionAppraisalofEquipment][value=" + 0 + "]").prop('checked', true);
    $("input[name=NotReliableId][value=" + 0 + "]").prop('checked', true);
    $("input[name=StatuaryRequirementsid][value=" + 0 + "]").prop('checked', true);
    $("input[name=ObsolescenceId][value=" + 0 + "]").prop('checked', true);
    //ConditionAppraisalofEquipment


    $("input[name=EstimatedCosttooExpensive][value=" + 0 + "]").prop('disabled', false);
    $("input[name=EstimatedCosttooExpensive][value=" + 1 + "]").prop('disabled', false);
    $("input[name=ConditionAppraisalofEquipment][value=" + 0 + "]").prop('disabled', false);
    $("input[name=ConditionAppraisalofEquipment][value=" + 1 + "]").prop('disabled', false);
    $("input[name=NotReliableId][value=" + 0 + "]").prop('disabled', false);
    $("input[name=NotReliableId][value=" + 1 + "]").prop('disabled', false);

    $("input[name=StatuaryRequirementsid][value=" + 0 + "]").prop('disabled', false);
    $("input[name=StatuaryRequirementsid][value=" + 1 + "]").prop('disabled', false);

    $("input[name=ObsolescenceId][value=" + 0 + "]").prop('disabled', false);
    $("input[name=ObsolescenceId][value=" + 1 + "]").prop('disabled', false);

    $('#BERActionStatus').val(202);
    $('#BER1status').val(202);
    $('#AssetNoDiv').show();
    $('#companypopup').show();
    ///*****To make Editable ******\\
    $('#RejectedBER').prop('disabled', false);
    $('#RejectedBER').prop('checked', false);
    $('#ApplicationDate').prop('disabled', false);
    $('#txtAssetNo').prop('disabled', false);
    $('#RepairEstimateCost').prop('disabled', false);
   // $('#AfterRepairValue').prop('disabled', false);
    $('#cannotRepair').prop('disabled', false);
    $('#cannotRepair').prop('checked', false);
    $('#estimatedRepairCostlabelid').html("Estimated Repair Cost (RM) <span class='red'>*</span>");
    $('#CurrentValue').prop('disabled', false);
    $('#estimatedDurationOfUsageAfterRepair').prop('disabled', false);
    $('#txtCompanyStaffName').prop('disabled', false);
    $('#radios-1').prop('disabled', false);
    $('#radios-2').prop('disabled', false);
    $('#otherObservations').prop('disabled', false);
    $('#Remarks').prop('disabled', false);

    ///**** End****\\

    $.get("/api/BerOne/Load")
       .done(function (result) {
           //Bind drop down values 
           var loadResult = JSON.parse(result);
           $('#FacilityName').val(loadResult.FacilityName);
           $('#FacilityCode').val(loadResult.FacilityCode);


           $('#BERActionStatus').val(202);
           $('#BER1status').val(202); // New
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

var _EditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any(x=>x.ActionPermissionName == 'Edit' );
var _AddPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any(x=>x.ActionPermissionName == 'Add');
var _DeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any(x=>x.ActionPermissionName == 'Delete');
var _VerifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any(x=>x.ActionPermissionName == 'Verify' );
var _ApprovePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any(x=>x.ActionPermissionName == 'Approve' );
var _ClarifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any(x=>x.ActionPermissionName == 'Clarify' );
var _RecommendPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any(x=>x.ActionPermissionName == 'Recommend' );
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
     if (_VerifyPermission)
        {
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
function PostRecommended   () {

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
