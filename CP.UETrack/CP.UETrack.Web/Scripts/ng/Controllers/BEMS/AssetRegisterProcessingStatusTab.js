function assetprocessstatusgridDetails() 
{
    if ($('#hdnARPrimaryID').val() == 0) {
        return false;
    }

    var _AssetId = $('#hdnARPrimaryID').val();//asset Id
    $('#txtARprocessAssetDescription').val($('#txtARTypeDescription').val());

    var jqxhr = $.post("/api/AssertregisterAssetProcessingStatus/AssetProcessingStatus", { AssetId: _AssetId }, function (response) {
        var result = JSON.parse(response);
        var htmlval = ""; $('#assetprocessstatustbody_id').empty();
        $.each(result, function (i, data) {
            var doneDate = data.DoneDate == null ? null : moment(result.DoneDate).format("DD-MMM-YYYY");
            htmlval = htmlval + ' <tr><td width="30%" style="text-align: center;" ><div><input type="text"  id="DocumentNo" value=' + data.DocumentNo + ' name="DocumentNo" class="form-control"  readonly="readonly"></div></td><td width="30%" style="text-align: center;" ><div><input id="ProcessName" value=' + data.ProcessName + '  type="text" class="form-control" name="ProcessName"  readonly="readonly"></div></td><td width="20%" style="text-align: center;" ><div><input id="DoneDate" value="' + doneDate + '"  type="text" class="form-control" name="DoneDate" readonly="readonly"></div></td><td width="20%" style="text-align: center;" ><div><input id="ProcessStatus" value="' + data.ProcessStatus + '" type="text" class="form-control" name="ProcessStatus" autocomplete="off" readonly="readonly"></div></td></tr>';

        });
        if (result.length != 0)
        {
            list = result;
           
        }
        else {
            PushEmptyMessage();
        }
        
        $('#assetprocessstatustbody_id').append(htmlval);      
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
     $('#errorMsg').css('visibility', 'visible');
     $('#btnSave').attr('disabled', false);
     $('#myPleaseWait').modal('hide');
 });

    //}
}

 //$("#btnARCancel").click(function () {
 //       window.location.href = "/bems/general";
 //});
 $("#btntab9Cancel").click(function () {
     //window.location.href = "/bems/general";
     var message = Messages.Reset_TabAlert_CONFIRMATION;
     bootbox.confirm(message, function (result) {
         if (result) {
             EmptyFieldsAssetprocess();
         }
         else {
             $('#myPleaseWait').modal('hide');
         }
     });
   
 });
 function EmptyFieldsAssetprocess() {

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


 function PushEmptyMessage() {
     $("#assetprocessstatustbody_id").empty();
     var emptyrow = '<tr class="norecord"><td width="100%"><h5 class="text-center">No records to display</h5></td></tr>'
     $("#assetprocessstatustbody_id").append(emptyrow);
 }