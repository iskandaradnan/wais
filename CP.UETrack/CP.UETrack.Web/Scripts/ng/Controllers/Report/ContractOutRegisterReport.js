$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnContractRegRptCancel").click(function () {
        window.location.href = " ";
    });

});

function getContractOutRegReport() {


    $('#btnContractRegRptFetch').attr('disabled', true);
    $("#txtcontractCode").prop("disabled", true);
    $("#fromdate").prop("disabled", true);
    $("#todate").prop("disabled", true);
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var contractorId = $('#hdnContractorId').val();
    var fromdate = $('#fromdate').val();
    var todate = $('#todate').val();
    var isFormValid = true;
    isFormValid = formInputValidation("ContractOutRegisterForm", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnContractRegRptFetch').attr('disabled', false);
        $("#txtcontractCode").prop("disabled", false);
        $("#fromdate").prop("disabled", false);
        $("#todate").prop("disabled", false);
        return false;
    }
    //else if (parseInt(contractorId) == 0 || contractorId == '0' || contractorId == '') {
    //    $('#txtcontractCode').parent().removeClass('has-error');
    //    $("div.errormsgcenter").text("Valid Contractor Code required");
    //    $('#errorMsg').css('visibility', 'visible');
    //    $('#myPleaseWait').modal('hide');
    //    $('#btnContractRegRptFetch').attr('disabled', false);
    //    $("#txtcontractCode").prop("disabled", false);
    //    $("#fromdate").prop("disabled", false);
    //    $("#todate").prop("disabled", false);
    //    return false;
    //}
    else {
        $('#myPleaseWait').modal('hide');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $('#txtcontractCode').parent().removeClass('has-error');
       
    }


    if (fromdate != null && fromdate != "" && todate != null && todate != "") {
        var ActiveFromDate = new Date(getDateToCompare($('#fromdate').val()));
        var ActiveToDate = new Date(getDateToCompare($('#todate').val()));

        if (ActiveFromDate > ActiveToDate) {
            $('#myPleaseWait').modal('hide');
            $('#todate').parent().addClass('has-error');
            $("div.errormsgcenter").text("To Date Should be greater than are equal to From Date");
            $('#errorMsg').css('visibility', 'visible');
            $('#btnContractRegRptFetch').attr('disabled', false);
            $("#fromdate").prop("disabled", false);
            $("#todate").prop("disabled", false);
            $("#contractCode").prop("disabled", false);
            return false;
        }
        else {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');
            $('#todate').parent().removeClass('has-error');
            $('#contractCode').parent().removeClass('has-error');
        }
    }







    var loc = '/Report/ContractOutRegisterReport.aspx?Fromdate=' + $('#fromdate').val() 
    + '&Todate=' + $('#todate').val()
     + '&contractorId=' + contractorId;

    document.getElementById('ReportFrame').setAttribute('src', loc);
    $("#btnContractRegRptCancel").css("visibility", "visible");
}

//var Contractorobj = {
//    SearchColumn: 'txtcontractCode-SSMNo',//Id of Fetch field
//    ResultColumns: ["ContractorId-Primary Key", 'SSMNo-contractCode'],//Columns to be displayed
//    FieldsToBeFilled: ["hdnContractorId-ContractorId", "txtcontractCode-SSMNo"]//id of element - the model property
//};
//$('#txtcontractCode').on('input propertychange paste keyup', function (event) {
//    DisplayFetchResult('divFetch111', Contractorobj, "/api/Fetch/FetchWarrantyProvider", "UlFetch2", event, 1);//1 -- pageIndex
//});

// Block Code fetch
var BlockCodeFetchObj = {
    SearchColumn: 'txtcontractCode-SSMNo',//Id of Fetch field
    ResultColumns: ["ContractorId-Primary Key", 'SSMNo-BlockSSMNo'],//Columns to be displayed
    FieldsToBeFilled: ["hdnContractorId-ContractorId", "txtcontractCode-SSMNo"]//id of element - the model property
};
$('#txtcontractCode').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divFetch111', BlockCodeFetchObj, "/api/Fetch/FetchWarrantyProvider", "UlFetch1", event, 1);//1 -- pageIndex
});