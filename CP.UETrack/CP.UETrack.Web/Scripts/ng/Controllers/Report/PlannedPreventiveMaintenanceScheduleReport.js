$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnPlanPreventiveRptCancel").click(function () {
        window.location.href = " ";
    });


    $.get("/api/PPMPlanner/Load")
      .done(function (result) {
          var loadResult = JSON.parse(result);
          $("#jQGridCollapse1").click();
          $.each(loadResult.ScheduleList, function (index, value) {
              $('#Schedule').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
          });
          $.each(loadResult.StatusList, function (index, value) {
              $('#Status').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
          });
          $.each(loadResult.TaskCodeOptionList, function (index, value) {
              $('#TaskCodeOption').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
          });

         
         
        
      })
.fail(function (response) {
    $('#myPleaseWait').modal('hide');
    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
    $('#errorMsg').css('visibility', 'visible');
});
});

function getPlanPreventiveScheduleReport() {
    $('#btnPlanPreventiveRptFetch').attr('disabled', true);
    $("#EODParamMapTypeCode").prop("disabled", true);
    $("#Year").prop("disabled", true);
    $("#Schedule").prop("disabled", true);
    $("#TaskCodeOption").prop("disabled", true);
    $("#Status").prop("disabled", true);
    

    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var typeCodeId = $('#hdnParamMapTypCdeId').val();
   
    var isFormValid = true;
    isFormValid = formInputValidation("PPMScheduleForm", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnPlanPreventiveRptFetch').attr('disabled', false);
        $("#EODParamMapTypeCode").prop("disabled", false);
  
        $("#Year").prop("disabled", false);
        $("#Schedule").prop("disabled", false);
        $("#TaskCodeOption").prop("disabled", false);
        $("#Status").prop("disabled", false);
        return false;
    }
    else if (parseInt(typeCodeId) == 0 || typeCodeId == '0' || typeCodeId == '') {
        $("div.errormsgcenter").text("Valid Asset Type Code required");
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnPlanPreventiveRptFetch').attr('disabled', false);
        $("#EODParamMapTypeCode").prop("disabled", false);
        $('#EODParamMapTypeCode').parent().addClass('has-error');
        $("#Year").prop("disabled", false);
        $("#Schedule").prop("disabled", false);
        $("#TaskCodeOption").prop("disabled", false);
        $("#Status").prop("disabled", false);
        return false;
    }
    else {
        $('#myPleaseWait').modal('hide');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $('#EODParamMapTypeCode').parent().removeClass('has-error');
        $('#Year').parent().removeClass('has-error');
        $('#Schedule').parent().removeClass('has-error');
        $('#TaskCodeOption').parent().removeClass('has-error');
    }


    var level = $('#Parameterlevel').val();
    level = 1;

    var loc = '/Report/PlannedPreventiveScheduleReport.aspx?TypeCodeId=' + typeCodeId 
    + '&Year=' + $('#Year').val()
    + '&Schedule=' + $('#Schedule').val()
    + '&TaskCodeOption=' + $('#TaskCodeOption').val() 
    + '&Status=' + $('#Status').val();

    document.getElementById('ReportFrame').setAttribute('src', loc);
    $("#btnPlanPreventiveRptCancel").css("visibility", "visible");
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