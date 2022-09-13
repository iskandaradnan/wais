$(document).ready(function () {
    var LOVlist = {};
    $('#myPleaseWait').modal('show');

    $("#btnCRMRptCancel").click(function () {
        window.location.href = " ";
    });
    var jqxhr = $.get("/api/CRMRequestApi/Load", function (response) {
        var result = response;
        LOVlist = result;
 
        $(LOVlist.RequestTypeList).each(function (_index, _data) {          
                $('#TypeOfRequest').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))
        });
    });
});

function EmptyFields() {
    $("#CRMfromdate").val("");
    $("#CRMtodate").val("");
    $("#TypeOfRequest").val("null");
    $('#btnCRMRptFetch').attr('disabled', false);
    $("#CRMfromdate").prop("disabled", false);
    $("#CRMtodate").prop("disabled", false);
    $("#TypeOfRequest").prop("disabled", false);
    document.getElementById('ReportFrame').setAttribute('src', "");
    $("#btnCRMRptCancel").css("visibility", "hidden");
}

function getCRMReport() {


    $('#btnCRMRptFetch').attr('disabled', true);
    $("#CRMfromdate").prop("disabled", true);
    $("#CRMtodate").prop("disabled", true);
    $("#TypeOfRequest").prop("disabled", true);

    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');

    var isFormValid = true;
    isFormValid = formInputValidation("CRMReportForm", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnCRMRptFetch').attr('disabled', false);
        $("#CRMfromdate").prop("disabled", false);
        $("#CRMtodate").prop("disabled", false);
        $("#TypeOfRequest").prop("disabled", false);
        return false;
    }


    var CRMfromdate = $('#CRMfromdate').val();
    var CRMtodate = $('#CRMtodate').val();
    var RequesttypeId = $('#TypeOfRequest').val();

    if (CRMfromdate != null && CRMfromdate != "" && CRMtodate != null && CRMtodate != "") {
        var ActiveFromDate = new Date(getDateToCompare($('#CRMfromdate').val()));
        var ActiveToDate = new Date(getDateToCompare($('#CRMtodate').val()));

        if (ActiveFromDate > ActiveToDate) {
            $('#myPleaseWait').modal('hide');
            $('#CRMtodate').parent().addClass('has-error');
            $("div.errormsgcenter").text("To Date Should be greater than are equal to From Date");
            $('#errorMsg').css('visibility', 'visible');
            $('#btnCRMRptFetch').attr('disabled', false);
            $("#CRMfromdate").prop("disabled", false);
            $("#CRMtodate").prop("disabled", false);
            $("#TypeOfRequest").prop("disabled", false);
            return false;
        }
        else {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');
            $('#CRMtodate').parent().removeClass('has-error');

        }
    }

    var loc = '/Report/CRMReport.aspx?CRMFromDate=' + $('#CRMfromdate').val() + '&CRMToDate=' + $('#CRMtodate').val() + '&CRMRequestType=' + $('#TypeOfRequest').val();

    document.getElementById('ReportFrame').setAttribute('src', loc);
    $("#btnCRMRptCancel").css("visibility", "visible");
}

//var RequestTypeMst = {
//    SearchColumn: 'txtCRMrequesttype-Partno',//Id of Fetch field
//    ResultColumns: ["LovId-Primary Key", 'CRMrequesttype-txtCRMrequesttype'],
//    FieldsToBeFilled: ["hdnLovId-LovId", 'txtCRMrequesttype-CRMrequesttype']
//};
//$('#txtCRMrequesttype').on('input propertychange paste keyup', function (event) {
//    DisplayFetchResult('divRequestTypeFetch', RequestTypeMst, "/api/Fetch/CRMFetchRequestTypedetais", "UlFetchSpareparts", event, 1);
//});


