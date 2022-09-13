$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnAssetRptCancel").click(function () {
        window.location.href = " ";
    });
    $.get("/api/testingAndCommissioning/Load")
   .done(function (result) {
       var loadResult = JSON.parse(result);      

       $.each(loadResult.TAndCTypes, function (index, value) {
           $('#selAssetCategory').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
       });
       $.each(loadResult.VariationStatus, function (index, value) {
           $('#selVariationStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
       });  
   })
.fail(function (response) {
    $('#myPleaseWait').modal('hide');
    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
    $('#errorMsg').css('visibility', 'visible');
});
});

function getAssetHistoryReport() {

    $('#btnAssetHistoryRptFetch').attr('disabled', true);
    $("#EODParamMapTypeCode").prop("disabled", true);
    $("#selAssetCategory").prop("disabled", true);
    $("#SelStatus").prop("disabled", true);
    $("#selVariationStatus").prop("disabled", true);

    $
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var typeCodeId = $('#hdnParamMapTypCdeId').val();
   
    var isFormValid = true;
    isFormValid = formInputValidation("AssetRegistrationHistoryForm", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnAssetHistoryRptFetch').attr('disabled', false);
        $("#EODParamMapTypeCode").prop("disabled", false);
        $("#selAssetCategory").prop("disabled", false);
        $("#SelStatus").prop("disabled", false);
        $("#selVariationStatus").prop("disabled", false);
        return false;
    }
    //else if (parseInt(typeCodeId) == 0 || typeCodeId == '0' || typeCodeId == '') {
    //    $("div.errormsgcenter").text("Valid Item No. required");
    //    $('#errorMsg').css('visibility', 'visible');
    //    $('#myPleaseWait').modal('hide');
    //    $('#btnAssetHistoryRptFetch').attr('disabled', false);
    //    $("#EODParamMapTypeCode").prop("disabled", false);
    //    $("#selAssetCategory").prop("disabled", false);
    //    $("#SelStatus").prop("disabled", false);
    //    $("#selVariationStatus").prop("disabled", false);
    //    return false;
    //}
    else {
        $('#myPleaseWait').modal('hide');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
    }
    var loc = '/Report/AssetRegistrationHistoryReport.aspx?AssetCategory=' + $('#selAssetCategory').val()
        + '&AssetStatus=' + $('#SelStatus').val()
    + '&Typecode=' + typeCodeId
    + '&VariationStatus=' + $('#selVariationStatus').val();

    document.getElementById('ReportFrame').setAttribute('src', loc);
    $("#btnAssetRptCancel").css("visibility", "visible");
}

function FetchTypeCode(event) {
    $('#TypecodeFetch').css({
        'width': $('#EODParamMapTypeCode').outerWidth()
    });
    var ItemMst = {
        SearchColumn: 'EODParamMapTypeCode' + '-AssetTypeCode',//Id of Fetch field
        ResultColumns: ["AssetTypeCodeId-Primary Key", 'AssetTypeCode-EODParamMapTypeCode', 'AssetTypeDescription-AssetTypeCodeDesc'],//Columns to be displayed
        AdditionalConditions: ["AssetClassificationId-EODParamMapClss", "AssetTypeCode-EODParamMapTypeCode"], //Filter conditions
        FieldsToBeFilled: ["hdnParamMapTypCdeId" + "-AssetTypeCodeId", 'EODParamMapTypeCode' + '-AssetTypeCode', 'EODParamMapTypCdeDesc' + '-AssetTypeDescription']//id of element - the model property
    };
    DisplayFetchResult('TypecodeFetch', ItemMst, "/api/Fetch/TypeCodeFetch", "Ulfetch", event, 1);
}




$('#selVariationStatus').change(function () {
    var cateogiory = $('#selVariationStatus').val();
    if (cateogiory != null && cateogiory != "null" && cateogiory != '')
    {
        $('#selVariationStatus').parent().removeClass('has-error');
    }
});
$('#selAssetCategory').change(function () {
    var cateogiory = $('#selAssetCategory').val();
    if (cateogiory != null && cateogiory != "null" && cateogiory != '') {
        $('#selAssetCategory').parent().removeClass('has-error');
    }
});