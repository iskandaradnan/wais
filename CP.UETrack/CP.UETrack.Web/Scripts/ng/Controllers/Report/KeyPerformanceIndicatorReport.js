$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnKPRptCancel").click(function () {
        window.location.href = " ";
    });
  
});

function getKeyPerformanceReport() {
   
    $('#btnKPtFetch').attr('disabled', true);
    $("#EODParamMapTypeCode").prop("disabled", true);
    $("#FromYear").prop("disabled", true);
    $("#ToYear").prop("disabled", true);
    var fromYear = $("#FromYear").val(); 
    var toYear = $("#ToYear").val(); 
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var typeCodeId = $('#hdnParamMapTypCdeId').val();

    var isFormValid = true;
    isFormValid = formInputValidation("KeyPeformFormId", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnKPtFetch').attr('disabled', false);
        $("#EODParamMapTypeCode").prop("disabled", false);
        $("#FromYear").prop("disabled", false);
        $("#ToYear").prop("disabled", false);
       
        return false;
    }
    else if (parseInt(typeCodeId) == 0 || typeCodeId == '0' || typeCodeId == '') {
        $("div.errormsgcenter").text("Valid Asset Type Code required");
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $("#EODParamMapTypeCode").prop("disabled", false);
        $('#EODParamMapTypeCode').parent().addClass('has-error');
        $("#FromYear").prop("disabled", false);
        $("#ToYear").prop("disabled", false);
        return false;
    }
    else if (parseInt(fromYear) > parseInt(toYear))
    {
        $("div.errormsgcenter").text("From Year should be less than To Year");
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnKPtFetch').attr('disabled', false);
        $("#EODParamMapTypeCode").prop("disabled", false);
        $("#FromYear").prop("disabled", false);
        $("#ToYear").prop("disabled", false);
        $('#ToYear').parent().addClass('has-error');
        $('#FromYear').parent().addClass('has-error');
        return false;

    }
    else {
        $('#ToYear').parent().removeClass('has-error');
        $('#FromYear').parent().removeClass('has-error');
        $('#EODParamMapTypeCode').parent().removeClass('has-error');
        $('#myPleaseWait').modal('hide');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
    }


    var loc = '/Report/KeyPerformanceIndicatorReport.aspx?FromYear=' + $('#FromYear').val()
        + '&ToYear=' + $('#ToYear').val()
    + '&Typecode=' + typeCodeId;

    document.getElementById('ReportFrame').setAttribute('src', loc);
    $("#btnKPRptCancel").css("visibility", "visible");
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




$('#FromYear').change(function () {
    var cateogiory = $('#FromYear').val();
    if (cateogiory != null && cateogiory != "null" && cateogiory != '') {
        $('#FromYear').parent().removeClass('has-error');
    }
});
$('#ToYear').change(function () {
    var cateogiory = $('#ToYear').val();
    if (cateogiory != null && cateogiory != "null" && cateogiory != '') {
        $('#ToYear').parent().removeClass('has-error');
    }
});