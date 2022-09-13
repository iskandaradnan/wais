
$(document).ready(function () {
    $("#btnCancelback").click(function () {

        var message = Messages.Reset_TabAlert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                window.location.href = "/bems/eodparametermapping";
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });

    });
});

function loadParaMapHist() {
    $('#myPleaseWait').modal('show');

    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');

   // var AssessmentTabPrimaryId = $('#hdncrmAssTabAssId').val();

    //formInputValidation("CRMAssessmentPage");

    var primaryId = $('#primaryID').val();      //Workorder Id

    $.get("/api/EODParameterMapping/GetHistory/" + primaryId)
   .done(function (result) {
       var result = JSON.parse(result);
       //$("#jQGridCollapse1").click();
       //$.each(getResult.CRMProcessStatusData, function (index, value) {

       //if (result.CRMProcessStatusData > 0) {
       GetParamMapHistBind(result)
       //}
       //else {
       //    $('#myPleaseWait').modal('hide');
       //}
       // });

       $('#myPleaseWait').modal('hide');
   })
   .fail(function (response) {
       $('#myPleaseWait').modal('hide');
       $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
       $('#errorMsg').css('visibility', 'visible');
   });
    $('#myPleaseWait').modal('hide');
}


function GetParamMapHistBind(getResult) {

    //var primaryId = $('#primaryID').val();

    //$('#EODParamMapClssHis option[value="' + getResult.AssetClassificationId + '"]').prop('selected', true);
    $("#EODParamMapClssHis").val(getResult.AssetClassification);
    $("#EODParamMapTypeCodeHis").val(getResult.AssetTypeCode);
    $("#EODParamMapManuHis").val(getResult.Manufacturer);
    $("#EODParamMapModelHis").val(getResult.Model); 
    $("#EODParamMappingBodyHistory").empty();

    if (getResult.EODParameterMappingGridData.length > 0) {
        $.each(getResult.EODParameterMappingGridData, function (index, value) {
            AddNewRowParaMapHis();

            // $("#hdnEodParMapGrid_" + index).val(getResult.EODParameterMappingGridData[index].ParameterMappingDetId);
            $("#ParamMapParamHis_" + index).val(getResult.EODParameterMappingGridData[index].parameter);
            $("#ParamMapUomHis_" + index).val(getResult.EODParameterMappingGridData[index].UOM);
            //$('#ParamMapUomHis_' + index + ' option[value="' + getResult.EODParameterMappingGridData[index].UomId + '"]').prop('selected', true);
            //$('#ParamMapDataTypeHis_' + index + ' option[value="' + getResult.EODParameterMappingGridData[index].DatatypeId + '"]').prop('selected', true);
            $("#ParamMapDataTypeHis_" + index).val(getResult.EODParameterMappingGridData[index].DataType);
            $("#ParamMapAlphaNumHis_" + index).val(getResult.EODParameterMappingGridData[index].AlphanumDropdown);

            $("#ParamMapMinHis_" + index).val(getResult.EODParameterMappingGridData[index].Min);
            $("#ParamMapMaxHis_" + index).val(getResult.EODParameterMappingGridData[index].max);
            $('#ParamMapEffFromHis_' + index).val(DateFormatter(getResult.EODParameterMappingGridData[index].EffectiveFrom));
            //var EffDate = getResult.EODParameterMappingGridData[index].IsEffectiveDateNull ? "" : DateFormatter(getResult.EODParameterMappingGridData[index].EffectiveTo);
            $('#ParamMapEffToStatHis_' + index).val(getResult.EODParameterMappingGridData[index].Status);
            $("#ParamMapRemHis_" + index).val(getResult.EODParameterMappingGridData[index].Remarks);

        });
    }
    else {
        $("#EODParamMappingBodyHistory").empty();
        var emptyrow = '<tr class="norecord"><td width="100%"><h5 class="text-center">No records to display</h5></td></tr>'
        $("#EODParamMappingBodyHistory ").append(emptyrow);
    }


    //if ((getResult.EODParameterMappingGridData && getResult.EODParameterMappingGridData.length) > 0) {
    //    ParameterMappingId = getResult.ParameterMappingId;
    //    GridtotalRecords = getResult.EODParameterMappingGridData[0].TotalRecords;
    //    TotalPages = getResult.EODParameterMappingGridData[0].TotalPages;
    //    LastRecord = getResult.EODParameterMappingGridData[0].LastRecord;
    //    FirstRecord = getResult.EODParameterMappingGridData[0].FirstRecord;
    //    pageindex = getResult.EODParameterMappingGridData[0].PageIndex;
    //}

    //var mapIdproperty = ["IsDeleted-Isdeleted_", "ParameterMappingDetId-hdnEodParMapGrid_", "parameter-ParamMapParam_", "Standard-ParamMapStand_", "UomId-ParamMapUom_", "DatatypeId-ParamMapDataType_", "AlphanumDropdown-ParamMapAlphaNum_", "Min-ParamMapMin_", "max-ParamMapMax_", "FrequencyId-ParamMapFreq_", "EffectiveFrom-ParamMapEffFrom_-date", "EffectiveTo-ParamMapEffTo_-date", "Remarks-ParamMapRem_"];
    //var htmltext = EODParamMpaHtml();//Inline Html
    //var obj = { formId: "#EODParamMappingScreen", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "ParMapBEMS", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "EODParameterMappingGridData", tableid: '#EODParamMappingBody', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/EODParameterMapping/Get/" + primaryId, pageindex: pageindex, pagesize: pagesize };

    //CreateFooterPagination(obj)
    //$('#paginationfooter').show();

}

function AddNewRowParaMapHis() {
    var inputpar = {
        inlineHTML: ParaMapHisHtml(),
        IdPlaceholderused: "maxindexval",
        TargetId: "#EODParamMappingBodyHistory",
        TargetElement: ["tr"]
    }

    AddNewRowToDataGrid(inputpar);
    formInputValidation("CRMProcessStatusPage");
}

function ParaMapHisHtml() {

    return ' <tr class="ng-scope" style=""><td width="15%" data-original-title="" title=""> <div> <input type="text" id="ParamMapParamHis_maxindexval"                  class="form-control" autocomplete="off" disabled></div> </td> \
                <td width="10%" data-original-title="" title=""> <div> <input type="text" id="ParamMapUomHis_maxindexval" class="form-control" autocomplete="off" disabled></div> </td> \
                <td width="12%" data-original-title="" title=""> <div> <input type="text" id="ParamMapDataTypeHis_maxindexval" class="form-control" autocomplete="off" disabled></div> </td> \
                <td width="15%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="ParamMapAlphaNumHis_maxindexval"  class="form-control" disabled autocomplete="off" disabled/></div></td> \
                <td width="8%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" class="form-control decimalPointonly" id="ParamMapMinHis_maxindexval" style="text-align:right"  autocomplete="off" disabled/></div></td> \
                <td width="8%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" class="form-control decimalPointonly" autocomplete="off"  id="ParamMapMaxHis_maxindexval" style="text-align:right"  disabled/></div></td> \
                <td width="10%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" class="form-control datetimePastOnly" id="ParamMapEffFromHis_maxindexval"  autocomplete="off" disabled/></div></td> \
                <td width="10%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="ParamMapEffToStatHis_maxindexval"  class="form-control" disabled autocomplete="off" disabled/></div></td> \
                <td width="12%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" class="form-control Rem" id="ParamMapRemHis_maxindexval" maxlength="255" autocomplete="off" disabled/></div></td></tr>'
}