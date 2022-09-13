$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnSPReplacementRptCancel").click(function () {       
            var message = Messages.Reset_Alert_CONFIRMATION;
            bootbox.confirm(message, function (result) {
                if (result) {
                    EmptyFields();
                    $(".content").scrollTop(0);
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            });      
    });

});

function getSparePartsReplacementReport() {
    $('#btnSPReplacementRptFetch').attr('disabled', true);
    $("#SPfromdate").prop("disabled", true);
    $("#SPtodate").prop("disabled", true);
    $("#txtspareparts").prop("disabled", true);

    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
  
    var isFormValid = true;
    isFormValid = formInputValidation("SPReplacementReportForm", 'save');
    if (!isFormValid) {        
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnSPReplacementRptFetch').attr('disabled', false);
        $("#SPfromdate").prop("disabled", false);
        $("#SPtodate").prop("disabled", false);
        $("#txtspareparts").prop("disabled", false);
        return false;
    }

    var SPfromdate = $('#SPfromdate').val();
    var SPtodate = $('#SPtodate').val();
    var SPPart = $('#txtspareparts').val();

    if (SPfromdate != null && SPfromdate != "" && SPtodate != null && SPtodate != "") {
        var ActiveFromDate = new Date(getDateToCompare($('#SPfromdate').val()));
        var ActiveToDate = new Date(getDateToCompare($('#SPtodate').val()));

        if (ActiveFromDate > ActiveToDate) {
            $('#myPleaseWait').modal('hide');
            $('#SPtodate').parent().addClass('has-error');
            $("div.errormsgcenter").text("To Date Should be greater than are equal to From Date");
            $('#errorMsg').css('visibility', 'visible');
            $('#btnSPReplacementRptFetch').attr('disabled', false);
            $("#SPfromdate").prop("disabled", false);
            $("#SPtodate").prop("disabled", false);
            $("#txtspareparts").prop("disabled", false);
            return false;
        }
        else {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');
            $('#SPtodate').parent().removeClass('has-error');

        }
    }

    var loc = '/Report/SparePartsReplacementReport.aspx?SPSpareparts=' + $('#hdnSparepartsId').val() + '&SPFromDate=' + $('#SPfromdate').val() + '&SPToDate=' + $('#SPtodate').val();

    document.getElementById('ReportFrame').setAttribute('src', loc);
    $("#btnSPReplacementRptCancel").css("visibility", "visible");

}

    var ItemMst = {
        SearchColumn: 'txtspareparts-Partno',//Id of Fetch field
        ResultColumns: ["SparePartsId-Primary Key", 'Partno-txtspareparts'],
        FieldsToBeFilled: ["hdnSparepartsId-SparePartsId", 'txtspareparts-Partno']
    };
    $('#txtspareparts').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divSparepartsFetch', ItemMst, "/api/Fetch/FetchItemMstdetais", "UlFetchSpareparts", event, 1);
    });



    function EmptyFields() {
        $("#SPfromdate").val("");
        $("#SPtodate").val("");
        $("#txtspareparts").val("");
        $('#btnSPReplacementRptFetch').attr('disabled', false);
        $("#SPfromdate").prop("disabled", false);
        $("#SPtodate").prop("disabled", false);
        $("#txtspareparts").prop("disabled", false);
        document.getElementById('ReportFrame').setAttribute('src', "");
        $("#btnSPReplacementRptCancel").css("visibility", "hidden");
    }