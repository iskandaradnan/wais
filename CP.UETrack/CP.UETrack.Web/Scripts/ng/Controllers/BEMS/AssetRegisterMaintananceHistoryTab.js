//function loadMaintenancedetails()
//{
$('#liMaintenanceHistory').click(function () {
        var primaryId = $('#hdnARPrimaryID').val();
        if (primaryId == 0) {
            return false;
        }
        var maintenanceHistoryList = null;
        var _AssetId = $('#hdnARPrimaryID').val();
        $('#txtARmaintenanceAssetDescription').val($('#txtARTypeDescription').val());
        $('#myPleaseWait').modal('show');
        var jqxhr = $.post("/api/MaintananceHistoryTabAssetregisterController/fetchMaitenanceDetails", { AssetId: _AssetId }, function (response) {
            var result = JSON.parse(response);
            maintenanceHistoryList = result;
            
            $('#maitenancetablebody').empty();
    
            var tableRow = '';
            if (result.maintenanceHistory != null && result.maintenanceHistory.length > 0) {
                $.each(result.maintenanceHistory, function (index, value) {
                    var workOrderDate = value.WorkOrderDate == null ? '' : moment(value.WorkOrderDate).format("DD-MMM-YYYY")
                    //var totalDowntime = value.TotalDownTime == null || value.TotalDownTime == 0 ? '' : value.TotalDownTime;
                    var totalDowntime = GetDownTime(value.TotalDownTime);
                    var sparepartsCost = value.SparepartsCost == null || value.SparepartsCost == 0 ? '' : value.SparepartsCost;
                    var labourCost = value.LabourCost == null || value.LabourCost == 0 ? '' : value.LabourCost;
                    var totalCost = value.TotalCost == null || value.TotalCost == 0 ? '' : value.TotalCost;

                    tableRow += '<tr>' +
                                    '<td width="12%"><input type="hidden" id="hdnMHWorkOrderId_' + index + '" value="' + value.WorkOrderId + '"/>' +
                                    '<input type="text" onclick="RedirectToWorkOrder(' + value.WorkOrderId + ', ' + value.CategoryId + ')" class="form-control" style="color:#477ca9; cursor: pointer" id="txtMHMaintenaceWorkNo_' + index + '" value="' + value.MaintenaceWorkNo + '" title="' + value.MaintenaceWorkNo + '"  readonly /></td>' +
                                    '<td width="12%"><input type="text"  class="form-control" id="txtMHworkOrderDate_' + index + '" value="' + workOrderDate + '" disabled /></td>' +
                                    '<td width="12%"><input type="text"  class="form-control" id="txtMHWorkCategory_' + index + '" value="' + value.WorkCategory + '"  disabled /></td>' +
                                    '<td width="16%"><div class="col-sm-8"><input type="text"  class="form-control" id="txtMHType_' + index + '" value="' + value.Type + '"  disabled /></div><div class="col-sm-1"><span id="spn-partsdetails_' + index + '" class="btn btn-sm btn-primary btn-info btn-lg glyphicon glyphicon-modal-window"></span></div></td>' +
                                    '<td width="12%"><input type="text"  class="form-control text-right" id="txtMHTotalDownTime_' + index + '" value="' + totalDowntime + '"  disabled /></td>' +
                                    '<td width="12%"><input type="text"  class="form-control text-right" id="txtMHSparepartsCost_' + index + '" value="' +addCommas(sparepartsCost) + '"  disabled /></td>' +
                                    '<td width="12%"><input type="text"  class="form-control text-right" id="txtMHLabourCost_' + index + '" value="' +addCommas(labourCost)+ '"  disabled /></td>' +
                                    '<td width="12%"><input type="text"  class="form-control text-right" id="txtMHTotalCost_' + index + '" value="' +addCommas(totalCost) + '"  disabled /></td>' +
                                    '</tr>';
                });
                $('#btnMHExport').show();
            } else {
                $('#btnMHExport').hide();
            }
            if (tableRow == '') {
                tableRow = ' <tr id="NoRecordsDiv">'+
                                    '<td colspan="8" width="100%" data-original-title="" title="">' + 
                                        '<h5 class="text-center">' +
                                            '<span style="color:black;" href="#">No Records to Display</span>' +
                                        '</h5>' +
                                    '</td>' +
                                '</tr>';
            }

            $('#maitenancetablebody').append(tableRow);
            $('[id^=spn-partsdetails_]').unbind('click');
            $('[id^=spn-partsdetails_]').click(function () {
                var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");

                if (!hasEditPermission) {
                    $('#thMHCostPerUnit').hide();
                    $('#thMHStockType').css('width', '22%');
                }

                $('#tbodyPartsDetails').empty();

                var rowIndex = $(this).attr('id').split('_')[1];
                var partsDetails = [];
                if (result.partsDetails != null) {                 
                    var workOrderId = $('#hdnMHWorkOrderId_' + rowIndex).val();
                    partsDetails = Enumerable.From(result.partsDetails).Where("x=>x.WorkOrderId==" + workOrderId).ToArray();
                }

                var tablePartsDetailsRow = '';
                if (partsDetails.length != 0) {
                    $.each(partsDetails, function (index, value) {
                        tablePartsDetailsRow += '<tr>' +
                                        '<td width="9%"><input type="text"  class="form-control" id="txtMHPartNo_' + index + '" value="' + value.PartNo + '"  disabled /></td>' +
                                        '<td width="13%"><input type="text"  class="form-control" id="txtMHPartDescription_' + index + '" value="' + value.PartDescription + '"  disabled /></td>' +
                                        '<td width="9%"><input type="text"  class="form-control" id="txtMHItemNo_' + index + '" value="' + value.ItemNo + '"  disabled /></td>' +
                                        '<td width="14%"><input type="text"  class="form-control" id="txtMHItemDescription_' + index + '" value="' + value.ItemDescription + '"  disabled /></td>' +
                                        '<td width="11%"><input type="text"  class="form-control text-right" id="txtMHMinCost_' + index + '" value="' + value.MinCost + '"  disabled /></td>' +
                                        '<td width="11%"><input type="text"  class="form-control text-right" id="txtMHMaxCost_' + index + '" value="' + value.MaxCost + '"  disabled /></td>' +
                                        '<td width="11%"><input type="text"  class="form-control text-right"" id="txtMHQuantity_' + index + '" value="' + value.Quantity + '"  disabled /></td>';

                        if (hasEditPermission) {
                            tablePartsDetailsRow += '<td width="11%"><input type="text"  class="form-control text-right" id="txtMHCostPerUnit_' + index + '" value="' + value.CostPerUnit + '"  disabled /></td>' +
                                '<td width="11%"><input type="text"  class="form-control" id="txtMHStockType_' + index + '" value="' + value.StockType + '"  disabled /></td>';
                        } else {
                            tablePartsDetailsRow +=  '<td width="22%"><input type="text"  class="form-control" id="txtMHStockType_' + index + '" value="' + value.StockType + '"  disabled /></td>';
                        }
                                        
                        //tablePartsDetailsRow += 
                          tablePartsDetailsRow += '</tr>';
                    });
                }
                if (tablePartsDetailsRow == '') {
                    tablePartsDetailsRow = ' <tr id="NoRecordsDiv">' +
                                        '<td colspan="9" width="100%" data-original-title="" title="">' +
                                            '<h5 class="text-center">' +
                                                '<span style="color:black;" href="#">No Records to Display</span>' +
                                            '</h5>' +
                                        '</td>' +
                                    '</tr>';
                }
                $('#tbodyPartsDetails').append(tablePartsDetailsRow);
                $('#divPartDetailsList').modal('show');
            });
            
            $('#myPleaseWait').modal('hide');
        },
    "json")
     .fail(function (response) {
         $('#btnMHExport').hide();
         var errorMessage = "";
         if (response.status == 400) {
             errorMessage = response.responseJSON;
         }
         else {
             errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
         }
         $("div.errorMsgMaintenanceHistoryTab").text(errorMessage);
         $('#errorMsg').css('visibility', 'visible');
         $('#btnSave').attr('disabled', false);
         $('#myPleaseWait').modal('hide');
     });
});

function GetDownTime(DownTimeHours) {
    if (DownTimeHours != null && DownTimeHours != 0) {
        var hours = Math.floor(DownTimeHours / 60);
        var minutes = DownTimeHours % 60;

        var hoursStr = hours.toString();
        var minutesStr = minutes.toString();

        hoursStr = hoursStr.length == 1 ? '0' + hoursStr : hoursStr;
        minutesStr = minutesStr.length == 1 ? '0' + minutesStr : minutesStr;

        var downtimeString = hoursStr + ':' + minutesStr;
        return downtimeString;
    } else {
        return '';
    }
}

$('#btnPartDetailsListCancel, #btnPartDetailsListCancel1').click(function () {
    $('#divPartDetailsList').modal('hide');
});

$('#btnMHExport').click(function () {
    var exportType = "Excel";
    var sortOrder = "asc";
    var screenName = "Maintenance_History";

    var $downloadForm = $("<form method='POST'>")
      .attr("action", "/api/common/Export")
       .append($("<input name='filters' type='text'>").val(""))
       .append($("<input name='sortOrder' type='text'>").val(""))
        .append($("<input name='sortColumnName' type='text'>").val(""))
       .append($("<input name='screenName' type='text'>").val(screenName))
       .append($("<input name='exportType' type='text'>").val(exportType))
       .append($("<input name='AssetId' type='text'>").val($('#hdnARPrimaryID').val()))
       .append($("<input name='spName' type='text'>").val("uspFM_EngAssetMaintenanceHistory_Export"))

    $("body").append($downloadForm);
    var status = $downloadForm.submit();
    $downloadForm.remove();
});

$("#btntab10Cancel").click(function () {
    $('#selARTypeofasset').val("null");
    var message = Messages.Reset_TabAlert_CONFIRMATION;
    bootbox.confirm(message, function (result) {
        if (result) {
            EmptyFieldsMaintanence();
        }
        else {
            $('#myPleaseWait').modal('hide');
        }
    });
});
function EmptyFieldsMaintanence() {

    $('input[type="text"], textarea').val('');
    $('#selARAssetClassification').val("null");
    $('#selARServiceId,.selARServiceId').val(2);
    $('#selARAssetStatus').val(1);
    $('#selARRiskRating').val(113);
    //$('#selARTypeofasset').val("null");
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
    $("div.errorMsgMaintenanceHistoryTab").text("");
    $('#errorMsg').css('visibility', 'hidden');
    
    $('.nav-tabs a:first').tab('show')
}
