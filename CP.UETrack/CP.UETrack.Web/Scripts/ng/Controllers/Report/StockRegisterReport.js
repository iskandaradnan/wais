$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnStkRegRptCancel").click(function () {
        window.location.href = " ";
    });
    $("#txtPartNo").prop("disabled", true);
      var jqxhr = $.get("/api/StockUpdateRegisterApi/Load", function (response) {
        var result = response;  

        $.each(result.SparepartTypeList, function (index, value) {
            $('#SaprePartType').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(result.SparepartLocationList, function (index, value) {
            $('#SPLocation').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });               
    })
      .fail(function (response) {
          var errorMessage = "";         
          errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);          
          $("div.errormsgcenter").text(errorMessage);
          $('#errorMsg').css('visibility', 'visible');
          $('#btnSave').attr('disabled', false);
          $('#myPleaseWait').modal('hide');
      });
});

function getStockRegisterReport() {

    $('#btnStkRegRptFetch').attr('disabled', true);
    $("#txtItemNo").prop("disabled", true);
    $("#txtPartNo").prop("disabled", true);
    $("#SaprePartType").prop("disabled", true);
    $("#SPLocation").prop("disabled", true);
    $("#StkRegfromdate").prop("disabled", true);
    $("#StkRegtodate").prop("disabled", true);    
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var itemId= $('#hdnItemId').val();
    var isFormValid = true;
    isFormValid = formInputValidation("StockRegisterReportForm", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnStkRegRptFetch').attr('disabled', false);
        $("#txtItemNo").prop("disabled", false);
        //$("#txtPartNo").prop("disabled", false);
        $("#SaprePartType").prop("disabled", false);
        $("#SPLocation").prop("disabled", false);
        $("#StkRegfromdate").prop("disabled", false);
        $("#StkRegtodate").prop("disabled", false);
        return false;
    }
   

    else if (parseInt(itemId) == 0 || itemId == '0' || itemId == '') {

        $("div.errormsgcenter").text("Valid Item No. required");
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnStkRegRptFetch').attr('disabled', false);
        $("#txtItemNo").prop("disabled", false);
        $("#txtItemNo").parent().addClass("has-error");
        //$("#txtPartNo").prop("disabled", false);
        $("#SaprePartType").prop("disabled", false);
        $("#SPLocation").prop("disabled", false);
        $("#StkRegfromdate").prop("disabled", false);
        $("#StkRegtodate").prop("disabled", false);
        return false;
    }

    else {
        $('#myPleaseWait').modal('hide');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $('#txtItemNo').parent().removeClass('has-error');
    }

    var itemId = $('#hdnItemId').val();
    var partNo = $('#txtPartNo').val();
    var sparePartType = $('#SaprePartType').val();
    var sPLocation = $('#SPLocation').val();
    var stkRegfromdate = $('#StkRegfromdate').val();
    var stkRegtodate = $('#StkRegtodate').val();


    if (stkRegfromdate != null && stkRegfromdate != "" && stkRegtodate != null && stkRegtodate != "") {
        var ActiveFromDate = new Date(getDateToCompare(stkRegfromdate));
        var ActiveToDate = new Date(getDateToCompare(stkRegtodate));

        if (ActiveFromDate > ActiveToDate) {
            $('#myPleaseWait').modal('hide');
            $('#stkRegtodate').parent().addClass('has-error');
            $("div.errormsgcenter").text("To Date Should be greater than are equal to From Date");
            $('#errorMsg').css('visibility', 'visible');
            $('#btnStkRegRptFetch').attr('disabled', false);
            $("#txtItemNo").prop("disabled", false);
            //$("#txtPartNo").prop("disabled", false);
            $("#SaprePartType").prop("disabled", false);
            $("#SPLocation").prop("disabled", false);
            $("#StkRegfromdate").prop("disabled", false);
            $("#StkRegtodate").prop("disabled", false);
            return false;
        }
        else {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');
            $('#StkRegtodate').parent().removeClass('has-error');

        }
    }

    var loc = '/Report/StockRegisterReport.aspx?StkRegItemId=' + itemId + '&StkRegFromDate=' + $('#StkRegfromdate').val() + '&StkRegToDate=' + $('#StkRegtodate').val()

    + '&PartNo=' + partNo + '&SaprePartType=' + sparePartType + '&SPLocation=' + sPLocation;

    document.getElementById('ReportFrame').setAttribute('src', loc);
    $("#btnStkRegRptCancel").css("visibility", "visible");
}

var itemObj = {
    SearchColumn: 'txtItemNo-ItemCode',//Id of Fetch field
    //AdditionalConditions: [],
    ResultColumns: ["ItemId-Primary Key", 'ItemCode-Item Code'],
    FieldsToBeFilled: ["hdnItemId-ItemId", "txtItemNo-ItemCode"],
   // AdditionalConditions: ["TypeCodeId-hdnAssetTypeCodeId"],
};

$('#txtItemNo').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divItemFetch', itemObj, "/api/Fetch/FetchItemNo", "UlFetch3", event, 1);//1 -- pageIndex
});


var partNoObj = {
    SearchColumn: 'txtPartNo-Partno',//Id of Fetch field
    //AdditionalConditions: [],
    ResultColumns: ["SparePartsId-Primary Key", 'Partno-Part No'],
    FieldsToBeFilled: ["hdnSparePartsId-SparePartsId", "txtPartNo-Partno"],
    AdditionalConditions: ["ItemId-hdnItemId"],
};

$('#txtPartNo').on('input propertychange paste keyup', function (event) {
    DisplayFetchResult('divSparepartsFetch', partNoObj, "/api/Fetch/FetchPartNo", "UlFetch", event, 1);//1 -- pageIndex
});

//calls click event after a certain time
$('#hdnItemId').change(function () {
    var itemId = $('#hdnItemId').val();

    if (itemId != null && itemId != "" && itemId != "0" && itemId != 0)
    {
        $("#txtPartNo").prop("disabled", false);
    }
    else {
        $("#txtPartNo").prop("disabled", true);
        $("#txtPartNo").val("");
    }

});


