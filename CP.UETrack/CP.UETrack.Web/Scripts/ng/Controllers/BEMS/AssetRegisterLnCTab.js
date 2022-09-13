var list = {};

function loadLicenseCertificateTab(event, value) {
    if ($('#hdnARPrimaryID').val() == 0) {
        return false;
    }

    $('#txtARlicenseAssetDescription').val($('#txtARTypeDescription').val());
    RedirectLicenseAndCertificate = function (LicenseId) {
        var message = 'You will be redirected to the License & Certificate Details screen. Are you sure you want to proceed?';

        bootbox.confirm(message, function (result) {
            if (result) {
                var url = "/bems/licenseandcertificatedetails/Index/" + LicenseId;
                window.location.href = url;
            }
        });
    }

    var _AssetId = $('#hdnARPrimaryID').val();//asset Id


    var jqxhr = $.get("/api/AssetRegisterLicenseCertificateTab/Get/" + _AssetId, function (response) {
        var result = JSON.parse(response);
        var htmlval = ""; $('#aRLicenseCertGridTableBody').empty();
        $.each(result, function (i, data) {

            //AddNewRowLar();

            htmlval = htmlval + '<tr style=""> \
                <td width="20%" style="text-align: center;" data-original-title="" title=""><div> <input id="ARLiceCertLicenseNo" type="text" onclick="RedirectLicenseAndCertificate(' + data.LicenseId + ')"  title="' + data.LicenseNo + '" value="' + data.LicenseNo + '" class="form-control fetchField " style="color:#477ca9; cursor: pointer" name="LicenseNo" readonly ></div></td> \
                <td width="10%" style="text-align: center;" data-original-title="" title=""><div> <input id="ARLiceCertNotificationInspection" type="text" value="' + DateFormatter(data.NotificationForInspection) + '" class="form-control datetime" name="Notification" disabled></div></td> \
                <td width="10%" style="text-align: center;" data-original-title="" title=""><div> <input id="ARLiceCertInspectionDate" type="text" value="' + DateFormatter(data.InspectionConductedOn) + '" class="form-control fetchField mmmDateCalendar datetime" name="InspectionDate" disabled></div></td> \
                <td width="15%" style="text-align: center;" data-original-title="" title=""><div> <input id="ARLiceCertNewInspectionDate" type="text" value="' + DateFormatter(data.NextInspectionDate) + '" class="form-control fetchField mmmDateCalendar datetime"  name="NewInspectionDate" disabled></div></td> \
                <td width="10%" style="text-align: center;" data-original-title="" title=""><div> <input id="ExpiryDate" type="text" value="' + DateFormatter(data.ExpireDate) + '" class="form-control fetchField mmmDateCalendar datetime" name="ExpiryDate" disabled></div></td> \
                <td width="10%" style="text-align: center;" data-original-title="" title=""><div> <input id="IssuingBody" type="text" value="' + data.IssuingBodyName + '" class="form-control fetchField " name="IssuingBody" disabled></div></td> \
                <td width="10%" style="text-align: center;" data-original-title="" title=""><div> <input id="ARLiceCertIssueDate" type="text" value="' + DateFormatter(data.IssuingDate) + '" class="form-control fetchField mmmDateCalendar datetime" name="IssueDate" disabled></div></td> \
                <td width="15%" style="text-align: center;" data-original-title="" title=""><div> <input id="ARLiceCertRemarks_'+ i +'" type="text" class="form-control" name="Remarks" disabled></div></td></tr>';
        });
        //<td width="10%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="ARLiceCertFacilityName" value="' + data.FacilityName + '" class="form-control" disabled>  </div></td>
        list = result;
        $('#aRLicenseCertGridTableBody').append(htmlval);
        $.each(result, function (i, data) {
            $('#ARLiceCertRemarks_' + i).val(data.Remarks);
        });
        
        if (result.length == 0)
        {
            $("#aRLicenseCertGridTableBody").empty();
            //var emptyrow = '<tr><td colspan=7 ><h3> &nbsp;&nbsp;&nbsp;&nbsp;No records to display</h3></td></tr>'
           var emptyrow = ' <tr id="NoRecordsDiv">' +
                                '<td colspan="8" width="100%" data-original-title="" title="">' +
                                    '<h5 class="text-center">' +
                                        '<span style="color:black;" href="#">No Records to Display</span>' +
                                    '</h5>' +
                                '</td>' +
                            '</tr>';
            $("#aRLicenseCertGridTableBody ").append(emptyrow);
        }
        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);
        $('#btnSave').attr('disabled', false);
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
     $('#errorMsgLicetab').css('visibility', 'visible');
     $('#btnSave').attr('disabled', false);
     $('#myPleaseWait').modal('hide');
 });
}

$("#btntab6Cancel").click(function () {
    //window.location.href = "/bems/general";
    var message = Messages.Reset_TabAlert_CONFIRMATION;
    bootbox.confirm(message, function (result) {
        if (result) {
            EmptyFieldsLicensecertificate();
        }
        else {
            $('#myPleaseWait').modal('hide');
        }
    });
    
});
function EmptyFieldsLicensecertificate() {
    
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
//function backpage() {
//    window.location.href = "/bems/general";
//}


//$('body').on('click', ".datetime", function () {
//    $(this).datetimepicker({
//        format: 'd-M-Y',
//        timepicker: false,
//        step: 15,
//        scrollInput: false,
//        minDate: Date(),
//    });
//});
//function filldata(id) {
//    // alert();
//    //alert(list[id].SNFDocumentNo);
//    $('#id_fetchlist').empty();
//    if (list[id] != undefined) {
//        $('#VariationStatus_0').val(list[id].VariationStatusName);
//        $('#ProjectCost_0').val(list[id].PurchaseProjectCost);
//        $('#VariationDate_0').val(list[id].VariationDate);
//        $('#ServiceStartDate_0').val(list[id].ServiceStopDate);
//        $('#ServiceStopDate_0').val(list[id].StartServiceDate);
//        $('#CommissioningDate_0').val(list[id].CommissioningDate);
//        $('#WarrantyEndDate_0').val(list[id].WarrantyEndDate);
//        $('#VariationMonth_0').val(list[id].ClosingMonth);
//        $('#VariationYear_0').val(list[id].ClosingYear);//VariationId , 
//        $('#id_SNFReferenceNo_0').val(list[id].SNFDocumentNo);


//    }

//}