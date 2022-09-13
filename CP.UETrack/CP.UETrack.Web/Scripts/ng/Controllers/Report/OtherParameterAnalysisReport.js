$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnParameterRptCancel").click(function () {
        window.location.href = " ";
    });
 //   $.get("/api/EODParameterMapping/Load")
 //      .done(function (result) {
 //          var loadResult = JSON.parse(result);
 //          $.each(loadResult.Frequency, function (index, value) {
 //              $('#EODParamMapFrequency').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
 //          });
 //      })
 //.fail(function () {
 //    $('#myPleaseWait').modal('hide');
 //    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
 //    $('#errorMsg').css('visibility', 'visible');
 //});
});

function getParameterAnalysisReport() {
    $('#btnParameterRptFetch').attr('disabled', true);
    $("#EODParamMapTypeCode").prop("disabled", true);
    $("#fromdate").prop("disabled", true);
    $("#todate").prop("disabled", true);
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var typeCodeId = $('#hdnParamMapTypCdeId').val();
    var fromdate = $('#fromdate').val();
    var todate = $('#todate').val();
    var isFormValid = true;
    isFormValid = formInputValidation("OtherParameterAnalysisForm", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnParameterRptFetch').attr('disabled', false);
        $("#EODParamMapTypeCode").prop("disabled", false);
        //$("#txtPartNo").prop("disabled", false);
        $("#fromdate").prop("disabled", false);
        $("#todate").prop("disabled", false);
        return false;
    }
    else if (parseInt(typeCodeId) == 0 || typeCodeId == '0' || typeCodeId == '') {
        $("div.errormsgcenter").text("Valid Asset Type Code required");
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnParameterRptFetch').attr('disabled', false);
        $("#EODParamMapTypeCode").prop("disabled", false);
        $("#fromdate").prop("disabled", false);
        $("#todate").prop("disabled", false);
        $('#EODParamMapTypeCode').parent().addClass('has-error');
        $("#EODParamMapFrequency").prop("disabled", false);
        $("#todate").prop("disabled", false);
        return false;
    }
    else {
        $('#myPleaseWait').modal('hide');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $('#EODParamMapTypeCode').parent().removeClass('has-error');
        $('#EODParamMapTypeCode').parent().removeClass('has-error');
    }


    if (fromdate != null && fromdate != "" && todate != null && todate != "") {
        var ActiveFromDate = new Date(getDateToCompare($('#fromdate').val()));
        var ActiveToDate = new Date(getDateToCompare($('#todate').val()));

        if (ActiveFromDate > ActiveToDate) {
            $('#myPleaseWait').modal('hide');
            $('#todate').parent().addClass('has-error');
            $("div.errormsgcenter").text("To Date Should be greater than are equal to From Date");
            $('#errorMsg').css('visibility', 'visible');
            $('#btnParameterRptFetch').attr('disabled', false);
            $("#fromdate").prop("disabled", false);
            $("#todate").prop("disabled", false);
            $("#EODParamMapTypeCode").prop("disabled", false);
            return false;
        }
        else {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');
            $('#todate').parent().removeClass('has-error');
            $('#EODParamMapTypeCode').parent().removeClass('has-error');
        }
    }

    var level = $('#Parameterlevel').val();
    level = 1;


    var loc = '/Report/OtherParameterAnalysis.aspx?ParameterLevel=' + level
        + '&AssetTypeCode=' + typeCodeId
        + '&fromDate=' + $('#fromdate').val()
        + '&todate=' + $('#todate').val();

    document.getElementById('ReportFrame').setAttribute('src', loc);
    $("#btnParameterRptCancel").css("visibility", "visible");
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