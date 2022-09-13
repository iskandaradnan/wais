$('#liAssetRegisterSNF').click(function () {
    var primaryId = $('#hdnARPrimaryID').val();
    if (primaryId == 0) {
        return false;
    }
    $('#txtSNFAssetNo').val($('#txtARAssetNo').val());
    $('#txtSNFPurchaseDate').val($('#txtARPurchaseDate').val());
    $('#txtSNFPurchaseCost').val($('#txtARPurchaseCost').val());
    $('#txtServiceStartDate').val($('#txtARServiceStartDate').val());
    $('#txtARsnfAssetDescription').val($('#txtARTypeDescription').val());
    
    $("div.errormsgcenter").text("");
    $('#errorMsgSNFTab').css('visibility', 'hidden');

    var actionType = $('#hdnActionType').val();
    formInputValidation("frmSNF");
    $.get("/api/SNF/Load")
     .done(function (result) {
         var loadResult = JSON.parse(result);

         $('#selSNFVariationStatus').children('option:not(:first)').remove();
         $.each(loadResult.VariationStatus, function (index, value) {
             $('#selSNFVariationStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
         });

         $('#selWarrantyStatus').children('option:not(:first)').remove();
         $.each(loadResult.YesNoValues, function (index, value) {
             $('#selWarrantyStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
         });

         $('#hdnSNFAssetNoId').val($('#hdnARPrimaryID').val());
         var primaryId = $('#hdnARPrimaryID').val();
         if (primaryId != null && primaryId != "0") {
             $.get("/api/SNF/Get/" + primaryId)
               .done(function (result) {
                   var result = JSON.parse(result);
                   if (result.ServiceEndDate != null) {
                       $('#txtSNFDate').attr('disabled', true).val(result.TandCDate == null ? null : moment(result.TandCDate).format("DD-MMM-YYYY"));
                       $('#selSNFVariationStatus').attr('disabled', true).val(result.VariationStatus);
                       $('#txtServiceEndtDate').attr('disabled', true).val(result.ServiceEndDate == null ? null : moment(result.ServiceEndDate).format("DD-MMM-YYYY"));
                       $('#txaSNFRemarks').attr('disabled', true).val(result.SNFRemarks);
                       $('#txtSNFNo').val(result.SNFNo);

                       $('#btnSNFEdit').hide();
                   } else {
                       $('#txtSNFNo').val('');
                       $('#txtSNFDate').val('').attr('disabled', false);
                       $('#selSNFVariationStatus').val('null').attr('disabled', false);
                       $('#txtServiceEndtDate').val('').attr('disabled', false);
                       $('#txaSNFRemarks').val('').attr('disabled', false);
                       $('#btnSNFEdit').show();
                   }
                  
                   $('#myPleaseWait').modal('hide');
               })
              .fail(function () {
                  $('#txtSNFDate').attr('disabled', true);
                  $('#selSNFVariationStatus').attr('disabled', true);
                  $('#txtServiceEndtDate').attr('disabled', true);
                  $('#txaSNFRemarks').attr('disabled', true);
                  $('#btnSNFEdit').hide();

                  $('#myPleaseWait').modal('hide');
                  $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                  $('#errorMsgSNFTab').css('visibility', 'visible');
              });
         }
         else {
             $('#myPleaseWait').modal('hide');
         }
     })
   .fail(function () {
       $('#myPleaseWait').modal('hide');
       $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
       $('#errorMsgSNFTab').css('visibility', 'visible');
   });
});


$('#btnSNFEdit').click(function () { 

    $("div.errormsgcenter").text("");
    $('#errorMsgSNFTab').css('visibility', 'hidden');
    $('#btnEdit').attr('disabled', true);
    
    var isFormValid = formInputValidation("frmSNF", 'save');
    if (!isFormValid ) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsgSNFTab').css('visibility', 'visible');

        $('#btnEdit').attr('disabled', false);
        return false;
    }

    $('#myPleaseWait').modal('show');
    var purchasecost = $('#txtSNFPurchaseCost').val();
    purchasecost = purchasecost.split(',').join('');
    
    var isLoaner = false;
    isLoaner = $('#hdnIsLoaner').val() == "1" ? true: false;

    var saveObj = {
        ServiceId: 2,
        AssetNo: $('#txtSNFAssetNo').val(),
        TandCDate: $('#txtSNFDate').val(),
        VariationStatus: $('#selSNFVariationStatus').val(),
        PurchaseDate: $('#txtSNFPurchaseDate').val(),
        PurchaseCost: purchasecost,
        ServiceStartDate: $('#txtServiceStartDate').val(),
        ServiceEndDate: $('#txtServiceEndtDate').val(),
        AssetId: $('#hdnSNFAssetNoId').val(),
        SNFRemarks: $('#txaSNFRemarks').val(),
        IsLoaner: isLoaner
    };
    
    var jqxhr = $.post("/api/SNF/Save", saveObj, function (response) {
        var result = JSON.parse(response);
        
        $('#txtSNFDate').attr('disabled', true);
        $('#selSNFVariationStatus').attr('disabled', true);
        $('#txtServiceEndtDate').attr('disabled', true);
        $('#txaSNFRemarks').attr('disabled', true);
        $('#txtSNFNo').val(result.SNFNo);
        $('#txtAREffectiveDate').val(saveObj.ServiceEndDate == null ? null : moment(saveObj.ServiceEndDate).format("DD-MMM-YYYY"));
        $('#WarrantyEndDate').val();
        $('#btnSNFEdit').hide();
        $(".content").scrollTop(0);
        showMessage('Asset Register', CURD_MESSAGE_STATUS.SS);
        $('#myPleaseWait').modal('hide');
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
    $('#errorMsgSNFTab').css('visibility', 'visible');
    $('#btnEdit').attr('disabled', false);
    $('#myPleaseWait').modal('hide');
});
});


$("#btnSNFRstCancel").click(function () {
    //window.location.href = "/bems/general";
    var message = Messages.Reset_TabAlert_CONFIRMATION;
    bootbox.confirm(message, function (result) {
        if (result) {
            EmptyFieldsSNF();
        }
        else {
            $('#myPleaseWait').modal('hide');
        }
    });
    
});
function EmptyFieldsSNF() {

    $('input[type="text"], textarea').val('');
    $('#selARAssetClassification').val("null");
    $('#selARServiceId,.selARServiceId').val(2);
    $('#selARAssetStatus').val(1);
    $('#selARRiskRating').val(113);
    $('#selARPurchaseCategory').val("null");
    $('#selARAppliedPartType').val("null");
    $('#selAREquipmentClass').val("null");
    $('#selARPPM').val("null");
    $('#selAROther').val("null");
    $('#selARRI').val("null");
    $('#selARAssetTransferMode').val("null");

    $('#txtARAssetNo').attr('disabled', false);

    $('#txtARTypeCode').attr('disabled', false);
    $('#txtARAssetPreRegistrationNo').attr('disabled', false);
    $('#spnPopup-assetPreRegistration').unbind("click").attr('disabled', false).css('cursor', 'default');
    $('#spnPopup-typeCode').unbind("click").attr('disabled', false).css('cursor', 'default');
    $('#btnAREdit').hide();
    $('#btnARSave').show();
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#hdnARPrimaryID").val('');
    $("#grid").trigger('reloadGrid');
    $("#assetRegister :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#selARTypeofasset').val("null");
    $('.nav-tabs a:first').tab('show')
}
