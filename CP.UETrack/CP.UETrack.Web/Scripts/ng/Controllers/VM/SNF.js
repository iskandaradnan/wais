

$(document).ready(function () {
    var actionType = $('#hdnActionType').val();
    formInputValidation("frmSNF");
    $.get("/api/SNF/Load")
     .done(function (result) {
         var loadResult = JSON.parse(result);

         //$.each(loadResult.Services, function (index, value) {
         //    $('#selService').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
         //});
         //$.each(loadResult.TAndCTypes, function (index, value) {
         //    $('#selTAndCType').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
         //});
         $.each(loadResult.VariationStatus, function (index, value) {
             $('#selVariationStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
         });
         $.each(loadResult.YesNoValues, function (index, value) {
             $('#selWarrantyStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
         });

         var primaryId = $('#hdnPrimaryID').val();
         if (primaryId != null && primaryId != "0") {
             $.get("/api/SNF/Get/" + primaryId)
               .done(function (result) {
                   var Result = JSON.parse(result);
                   BindData(Result);
                   $('#myPleaseWait').modal('hide');
               })
              .fail(function () {
                  $('#myPleaseWait').modal('hide');
                  $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                  $('#errorMsg').css('visibility', 'visible');
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
});


function save() {
    

    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');

    var actionType = $('#hdnActionType').val();
    var isFormValid = formInputValidation("frmSNF", 'save');


    var _ServiceStartDate=new Date($('#txtServiceStartDate').val());
    var _ServiceEndDate = new Date($('#txtServiceEndtDate').val());
    if (_ServiceStartDate > _ServiceEndDate)
    {
        $("div.errormsgcenter").text("Service Start Date has to be less than Service End Date");
        $('#errorMsg').css('visibility', 'visible');
        return;
    }
    
    
    $('#btnSave').attr('disabled', true);
    $('#btnEdit').attr('disabled', true);
    $('#btnVerify').attr('disabled', true);
    $('#btnApprove').attr('disabled', true);
    $('#btnReject').attr('disabled', true);

    if (!isFormValid ) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');

        $('#btnSave').attr('disabled', false);
        $('#btnEdit').attr('disabled', false);
        $('#btnVerify').attr('disabled', false);
        $('#btnApprove').attr('disabled', false);
        $('#btnReject').attr('disabled', false);
        return false;
    }

    $('#myPleaseWait').modal('show');

    var saveObj = {
        ServiceId: 2,
        TandCType: $('#selTAndCType').val(),
        TandCDate: $('#txtSNFDate').val(),
        AssetNo: $('#txtAssetNo').val(),
        AssetNoId: $("#TxtAssetNoId").val(),
        PurchaseDate: $('#txtPurchaseDate').val(),
        PurchaseCost: $('#txtPurchaseCost').val(),
        VariationStatus: $('#selVariationStatus').val(),
        ContractLPONo: $('#txtContractNo').val(),
        ServiceStartDate: $('#txtServiceStartDate').val(),
        ServiceEndDate: $('#txtServiceEndtDate').val(),
        MainSupplierCode: $('#txtMainSupplierCode').val(),
        MainSupplierName: $('#txtMainSupplierName').val(),
        WarrantyStartDate: $('#txtWarrantyStartDate').val(),
        WarrantyDuration: $('#txtWarrantyDuration').val(),
        WarrantyStatus: $('#selWarrantyStatus').val(),
        SNFRemarks: $('#txaSNFRemarks').val(),
        //Remarks: $('#txaRemarks').val(),
        WarrantyEndDate: $('#txtWarrantyEndDate').val(),







        AssetPreRegistrationNo: $('#txtARAssetPreRegistrationNo').val(),

        TandCCompletedDate: CreateDateTimeObject($('#txtTCCompletedDate').val()),
        HandoverDate: CreateDateTimeObject($('#txtHandoverDate').val()),



        TandCContractorRepresentative: $('#txtContractorRepresentative').val(),
        FmsCustomerRepresentativeId: $('#hdnCompanyRepresentative').val(),
        FmsFacilityRepresentativeId: $('#hdnHospitalRepresentative').val(),
       



        WarrantyEndDate: $('#txtWarrantyEndDate').val(),
    };
    
    var primaryId = $("#hdnPrimaryID").val();
    if (primaryId != null) {
        saveObj.TestingandCommissioningId = primaryId;
        saveObj.Timestamp = $('#hdnTimestamp').val();
        switch (actionType) {
            case 'ADD':
                //if (tandCStatus == "71")
                //    saveObj.Status = 2;
                //else saveObj.Status = 1
                saveObj.Status = 1;
                break;
            case 'EDIT':
                //if (tandCStatus == "71")
                //    saveObj.Status = 2;
                //else
                    saveObj.Status = 1
                break;
            case 'VERIFY': saveObj.Status = 9; break;
            case 'APPROVE': saveObj.Status = 7; break;
            case 'REJECT': saveObj.Status = 8; break;
        }
    }
    else {
        saveObj.TestingandCommissioningId = 0;
        saveObj.Timestamp = "";
        saveObj.Status = 1;
    }

    var jqxhr = $.post("/api/SNF/Save", saveObj, function (response) {
        var result = JSON.parse(response);
        
        $("#hdnPrimaryID").val(result.TestingandCommissioningId);
        $("#hdnTimestamp").val(result.Timestamp);
        $('#txtTCDocumnetNo').val(result.TandCDocumentNo);
        $('#txtARAssetPreRegistrationNo').val(result.AssetPreRegistrationNo);
        $('#selWarrantyStatus').val(result.WarrantyStatus == null ? "null" : result.WarrantyStatus);
        BindData(result);
        $(".content").scrollTop(0);
        showMessage('Asset Register', CURD_MESSAGE_STATUS.SS);

        $('#btnSave').attr('disabled', false);
        $('#btnEdit').attr('disabled', false);
        $('#btnVerify').attr('disabled', false);
        $('#btnApprove').attr('disabled', false);
        $('#btnReject').attr('disabled', false);

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
    $('#errorMsg').css('visibility', 'visible');

    $('#btnSave').attr('disabled', false);
    $('#btnEdit').attr('disabled', false);
    $('#btnVerify').attr('disabled', false);
    $('#btnApprove').attr('disabled', false);
    $('#btnReject').attr('disabled', false);

    $('#myPleaseWait').modal('hide');
});
}

$('#txtAssetNo').on('input propertychange paste keyup', function (event) {
    var ItemMst = {
        SearchColumn: 'txtAssetNo-AssetNo',//Id of Fetch field
        ResultColumns: ["AssetId-Primary Key", 'AssetNo' + '-txtAssetNo'],//Columns to be displayed
        FieldsToBeFilled: ["TxtAssetNoId-AssetId", 'txtAssetNo-AssetNo', 'txtPurchaseDate-PurchaseDate', 'txtPurchaseCost-PurchaseCostRM', 'txtServiceStartDate-ServiceStartDate', 'txtMainSupplierCode-MainSupplierCode', 'txtMainSupplierName-MainSupplier', 'txtWarrantyStartDate-WarrantyStartDate', 'selWarrantyStatus-WarrantyStatus', 'txtWarrantyEndDate-WarrantyEndDate', 'txtWarrantyDuration-WarrantyDuration']//id of element - the model property
    };
    DisplayFetchResult('divAssetnoFetch', ItemMst, "/api/Fetch/SNFAssetFetch", "Ulfetch", event, 1);
});

function BindData(getResult)
{
    var actionType = $("#hdnActionType").val();

 $('#txtTCDocumnetNo').val(getResult.TandCDocumentNo);
                   $('#txtTCDate').val(moment(getResult.TandCDate).format("DD-MMM-YYYY"));
                   $('#selTAndCType').val(getResult.TandCType);
                   $('#hdnTypeCodeId').val(getResult.AssetTypeCodeId);
                   $('#txtTypeCode').val(getResult.AssetTypeCode);
                   $('#txtTypeDescription').val(getResult.AssetTypeDescription);
                   if (getResult.TandCStatus == 71) $("#rdbPassed").prop("checked", true);
                   else if (getResult.TandCStatus == 72) $("#rdbFailed").prop("checked", true);

                   if (getResult.TandCStatus == 71) {
                       $.each($('#frmTestingAndCommissioning :input'), function (index, value) {
                           $(this).attr('disabled', true);
                       });
                       $("#anchorCreateTypeCode").unbind("click");
                       $("#anchorCreateTypeCode").css('cursor', 'default');
                   }

                   if (actionType == 'EDIT' && getResult.TandCStatus == 72) {
                       $.each($('#frmSNF :input:not(:button)'), function (index, value) {
                           $(this).attr('disabled', true);
                       });
                   }
                   if (actionType != 'ADD' && getResult.TandCStatus == 71) {
                       formInputValidation("frmSNF");
                   }
                   $("#txtSNFNo").val(getResult.SNFNo);
                   $("#txtSNFDate").val(moment(getResult.TandCDate).format("DD-MMM-YYYY"));
                   $("#txtAssetNo").val(getResult.AssetNo);
                   $("#TxtAssetNoId").val(getResult.AssetNoId);
                   $('#txtPurchaseDate').val(getResult.PurchaseDate == null ? null : moment(getResult.PurchaseDate).format("DD-MMM-YYYY"));
                   $('#txtPurchaseCost').val(getResult.PurchaseCost == 0 ? null : getResult.PurchaseCost);
                   $('#txtPurchaseCost').val(getResult.PurchaseCost);
                   $('#txtContractNo').val(getResult.ContractLPONo);
                   $('#selVariationStatus').val(getResult.VariationStatus);
                   $('#txtServiceStartDate').val(getResult.ServiceStartDate == null ? null : moment(getResult.ServiceStartDate).format("DD-MMM-YYYY"));
                   $('#txtServiceEndtDate').val(getResult.ServiceEndDate == null ? null : moment(getResult.ServiceEndDate).format("DD-MMM-YYYY"));
                   $('#txtMainSupplierCode').val(getResult.MainSupplierCode);
                   $('#txtMainSupplierName').val(getResult.MainSupplierName);
                   $('#txtWarrantyStartDate').val(getResult.WarrantyStartDate == null ? null : moment(getResult.WarrantyStartDate).format("DD-MMM-YYYY"));
                   $('#txtWarrantyDuration').val(getResult.WarrantyDuration);
                   $('#selWarrantyStatus').val(getResult.WarrantyStatus == null ? "null" : getResult.WarrantyStatus);
                   $('#txtWarrantyEndDate').val(getResult.WarrantyEndDate == null ? null : moment(getResult.WarrantyEndDate).format("DD-MMM-YYYY"));
                   $('#txaSNFRemarks').val(getResult.SNFRemarks);





                   //$('#txtARAssetPreRegistrationNo').val(getResult.AssetPreRegistrationNo);
                   //$('#txtTCCompletedDate').val(moment(getResult.TandCCompletedDate).format("DD-MMM-YYYY HH:mm"));
                   //$('#txtHandoverDate').val(moment(getResult.HandoverDate).format("DD-MMM-YYYY HH:mm"));
                   //$('#txtContract').val(getResult.ContractLPONo);
                   //$('#txtContractorRepresentative').val(getResult.TandCContractorRepresentative);
                   //$('#hdnCompanyRepresentative').val(getResult.FmsCustomerRepresentativeId);
                   //$('#txtCompanyRepresentative').val(getResult.CustomerRepresentativeName);
                   //$('#hdnHospitalRepresentative').val(getResult.FmsFacilityRepresentativeId);
                   //$('#txtHospitalRepresentative').val(getResult.FacilityRepresentativeName);


                   $('#hdnTimestamp').val(getResult.Timestamp);

                   //switch (actionType) {
                   //    case 'ADD':
                   //        //if (tandCStatus == "71")
                   //        //    saveObj.Status = 2;
                   //        //else saveObj.Status = 1
                   //        saveObj.Status = 1;
                   //        break;
                   //    case 'EDIT':
                   //        //if (tandCStatus == "71")
                   //        //    saveObj.Status = 2;
                   //        //else
                   //        saveObj.Status = 1
                   //        break;
                   //    case 'VERIFY': saveObj.Status = 9; break;
                   //    case 'APPROVE': saveObj.Status = 7; break;
                   //    case 'REJECT': saveObj.Status = 8; break;
                   //}
                   if (actionType == "VERIFY" && getResult.Status == 9) {
                       $("#btnVerify").hide();

                   }
                   if ((actionType == "APPROVE" || actionType == "REJECT") && (getResult.Status == 7 || getResult.Status == 8)) {
                       $("#btnApprove").hide();
                       $("#btnReject").hide();

                   }
}

$("#btnCancel").click(function ()
{
    window.location.replace("/vm/snf");
});

$("#btnAddNew").click(function () {
    window.location.replace("/vm/snf/add");
});