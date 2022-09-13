function assetprocessstatusgridDetails() 
{

    // if (event.keyCode == 40) {
    var _AssetId = $('#primaryid').val();


    var jqxhr = $.post("/api/AssertregisterAssetProcessingStatus/AssetProcessingStatus", { AssetId: _AssetId }, function (response) {
        var result = JSON.parse(response);
        var htmlval = ""; $('#assetprocessstatustbody_id').empty();
        $.each(result, function (i, data) {
            htmlval = htmlval + ' <tr><td width="30%" style="text-align: center;" ><div><input type="text"  id="DocumentNo" value=' + data.DocumentNo + ' name="DocumentNo" class="form-control"  readonly="readonly"></div></td><td width="30%" style="text-align: center;" ><div><input id="ProcessName" value=' + data.ProcessName + '  type="text" class="form-control" name="ProcessName"  readonly="readonly"></div></td><td width="20%" style="text-align: center;" ><div><input id="DoneDate" value="' + data.DoneDate + '"  type="text" class="form-control" name="DoneDate" readonly="readonly"></div></td><td width="20%" style="text-align: center;" ><div><input id="ProcessStatus" value="' + data.ProcessStatus + '" type="text" class="form-control" name="ProcessStatus" autocomplete="off" readonly="readonly"></div></td></tr>';

        });
        list = result;
        $('#assetprocessstatustbody_id').append(htmlval);
        setTimeout(function () {
            $("#top-notifications").hide();
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