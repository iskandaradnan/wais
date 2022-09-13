$('#liCurrnetMaintenance').click(function () {
    var primaryId = $('#hdnARPrimaryID').val();
    if (primaryId == 0) {
        return false;
    }

    $("div.errormsgcenter").text("");
    $('#errorMsgCurrentMaintenanceTab').css('visibility', 'hidden');

        if (primaryId != null && primaryId != "0") {
            $.get("/api/currentMaintenance/Get/" + primaryId)
            .done(function (result) {
                var result = JSON.parse(result);
                //$("#jQGridCollapse1").click();
                $('#tableCurrentMaintenancePPM > tbody').children('tr').remove();
                $('#tableCurrentMaintenanceUnschedule > tbody').children('tr').remove();

                var ppmTableRow = '';
                if (result.ppmMaintenance != null) {
                    $.each(result.ppmMaintenance, function (index, value) {
                        var workOrderDate = value.WorkOrderDate == '' ? null : moment(value.WorkOrderDate).format("DD-MMM-YYYY")
                        ppmTableRow += '<tr>' +
                                        '<td width="25%"><input type="text" onclick="RedirectToWorkOrder(' + value.WorkOrderId + ', ' + value.CategoryId + ')" class="form-control" style="color:#477ca9; cursor: pointer" id="txtPPMMaintenaceWorkNo_' + index + '" value="' + value.MaintenaceWorkNo + '"  readonly /></td>' +
                                        '<td width="25%"><input type="text" class="form-control" id="txtPPMworkOrderDate_' + index + '" value="' + workOrderDate + '"  disabled /></td>' +
                                        '<td width="25%"><input type="text" class="form-control" id="txtPPMWorkCategory_' + index + '" value="' + value.WorkCategory + '"  disabled /></td>' +
                                        '<td width="25%"><input type="text" class="form-control" id="txtPPMType_' + index + '" value="' + value.Type + '"  disabled /></td>' +
                                        '</tr>';
                    });

                }
                if (ppmTableRow != '') {
                    $('#tableCurrentMaintenancePPM > tbody').append(ppmTableRow);
                }

                var unscheduleTableRow = '';
                if (result.unScheduleMaintenance != null) {
                    $.each(result.unScheduleMaintenance, function (index, value) {
                        var workOrderDate = value.WorkOrderDate == null ? '' : moment(value.WorkOrderDate).format("DD-MMM-YYYY")
                        unscheduleTableRow += '<tr>' +
                                        '<td width="25%"><input type="text" onclick="RedirectToWorkOrder(' + value.WorkOrderId + ', ' + value.CategoryId + ')" style="color:#477ca9; cursor: pointer" class="form-control" id="txtUnscheduleMaintenaceWorkNo_' + index + '" value="' + value.MaintenaceWorkNo + '"  readonly /></td>' +
                                        '<td width="25%"><input type="text"  class="form-control" id="txtUnscheduleworkOrderDate_' + index + '" value="' + workOrderDate + '"  disabled /></td>' +
                                        '<td width="25%"><input type="text"  class="form-control" id="txtUnscheduleWorkCategory_' + index + '" value="' + value.WorkCategory + '"  disabled /></td>' +
                                        '<td width="25%"><input type="text"  class="form-control" id="txtUnscheduleType_' + index + '" value="' + value.Type + '"  disabled /></td>' +
                                        '</tr>';
                    });

                }
                if (unscheduleTableRow != '') {
                    $('#tableCurrentMaintenanceUnschedule > tbody').append(unscheduleTableRow);
                }
              
                $('#myPleaseWait').modal('hide');
            })
            .fail(function () {

                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                $('#errorMsgCurrentMaintenanceTab').css('visibility', 'visible');
            });
        }
        else {
            $('#myPleaseWait').modal('hide');
        }
});

$('#aCollapsePPM, #aCollapseUnschedule').on('click', function () {
    var iId = '';
    switch ($(this).attr('id')) {
        case 'aCollapsePPM': iId = 'iIndicatorPPM'; break;
        case 'aCollapseUnschedule': iId = 'iIndicatorUnschedule'; break;
    }
    var plus = $('#' + iId).hasClass('glyphicon-plus');
    var minus = $('#' + iId).hasClass('glyphicon-minus');

    $(".indicator").each(function (index, value) {
        if ($(this).attr('id') == iId) {
            if (plus) {
                $(this).addClass('glyphicon-minus').removeClass('glyphicon-plus');
            }
            if (minus) {
                $(this).addClass('glyphicon-plus').removeClass('glyphicon-minus');
            }
        } else {
            $(this).addClass('glyphicon-plus').removeClass('glyphicon-minus');
        }
    });
});


$("#btnCurrentMaintenanceCancel").click(function () {
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
    $(".content").scrollTop(0);
    $('input[type="text"], textarea').val('');
    $('#selARAssetClassification').val("null");
    $('#selARServiceId,.selARServiceId').val(2);
    $('#selARTypeofasset').val("null");
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
    $('.nav-tabs a:first').tab('show')
}