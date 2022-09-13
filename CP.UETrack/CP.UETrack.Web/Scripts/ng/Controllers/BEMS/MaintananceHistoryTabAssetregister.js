function loadMaintenancedetails()
{

    // if (event.keyCode == 40) {
    var _AssetId = $('#primaryid').val();
    $('#maitenancetablebody').empty();

    var jqxhr = $.post("/api/MaintananceHistoryTabAssetregisterController/fetchMaitenanceDetails", { AssetId: _AssetId }, function (response) {
        var result = JSON.parse(response);
        var htmlval = "";// $('#maitenancetablebody').empty();
        $.each(result, function (i, data) {
            htmlval = htmlval + ' <tr class="ng-scope" style=""><td width="20%" style="text-align: center;" data-original-title="" title=""><div><input type="text"  id="MaintenanceWorkNo" value='+data.MaintenanceWorkNo+' name="MaintenanceWorkNo" class="form-control"  readonly="readonly"></div></td><td width="10%" style="text-align: center;" data-original-title="" title=""><div><input id="WorkOrderDate" value='+data.WorkOrderDate+' type="text" class="form-control " name="WorkOrderDate"  readonly="readonly"></div></td><td width="20%" style="text-align: center;" data-original-title="" title=""><div><input id="WorkCategory" value='+data.WorkCategory+'  type="text" class="form-control" name="WorkCategory"  readonly="readonly"></div></td><td width="20%" style="text-align: center;" data-original-title="" title=""><div><input id="Type" value='+data.Type+'   type="text"  class="form-control  " name="Type"  readonly="readonly"></div></td><td width="15%" style="text-align: center;" data-original-title="" title=""><div><input id="TotalDowntime" value='+data.TotalDowntime+'  type="text" class="form-control " name="TotalDowntime"  readonly="readonly"></div></td><td width="15%" style="text-align: center;" data-original-title="" title=""><div><input id="TotalCost"  value='+data.TotalCost+'  type="text" class="form-control " name="TotalCost"  readonly="readonly"></div></td></tr>';

        });
        list = result;
        $('#maitenancetablebody').append(htmlval);
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