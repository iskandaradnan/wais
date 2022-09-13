$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $("#btnUserTrainRptCancel").click(function () {
        window.location.href = " ";
    });


    $.get("/api/UserTraining/Load")
       .done(function (result) {
           var loadResult = JSON.parse(result);
           //$("#jQGridCollapse1").click();
           //AddNewRowUserTraining();
          // AddNewRowUserTrainingArea();
           //$('#UserTrainAddrowArea').show();
          // $('#UserTrainCompAreaPop_0').prop("disabled", false);
           //var facilityval = $('#selFacilityLayout option:selected').text();
           //var FacCode = loadResult.FacilityLovs

           //$.each(loadResult.FacilityLovs, function (index, value) {
           //    $('#UserTrainCompFacCde').val(value.FieldValue);
           //});
           //$('#UserTrainCompFacCde').val(FacCode);

           //$.each(loadResult.ServiceLovs, function (index, value) {
           //    $('#UserTrainCompSer').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
           //});

           $.each(loadResult.TrainingTypeLovs, function (index, value) {
               $('#TrainingType').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
           });
       });




});

function getUserTrainReport() {

    $('#btnUserTrainRptFetch').attr('disabled', true);
    $("#Useryear").prop("disabled", true);
    $("#Userquarter").prop("disabled", true);
    $("#TrainingType").prop("disabled", true);
    $("#MinimumNoofParticipants").prop("disabled", true);
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');

    var isFormValid = true;
    isFormValid = formInputValidation("UserTrainingForm", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnUserTrainRptFetch').attr('disabled', false);
        $("#Useryear").prop("disabled", false);
        $("#Userquarter").prop("disabled", false);
        $("#TrainingType").prop("disabled", false);
        $("#MinimumNoofParticipants").prop("disabled", false);
        return false;
    }
    else {
        $('#myPleaseWait').modal('hide');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $('#Useryear').parent().removeClass('has-error');
    }

    var Useryear = $('#Useryear').val();
    var Userquarter = $('#Userquarter').val();
    var trainingType = $('#TrainingType').val();
    var minNoofParticipants  = $('#MinimumNoofParticipants').val();
    //if (Useryear != null && Useryear != "" && Useryear != "null") {


    //    if (ActiveFromDate > ActiveToDate) {
    //        $('#myPleaseWait').modal('hide');
    //        $('#CRMtodate').parent().addClass('has-error');
    //        $("div.errormsgcenter").text("To Date Should be greater than are equal to From Date");
    //        $('#errorMsg').css('visibility', 'visible');
    //        $('#btnCRMRptFetch').attr('disabled', false);
    //        $("#CRMfromdate").prop("disabled", false);
    //        $("#CRMtodate").prop("disabled", false);
    //        $("#txtCRMrequesttype").prop("disabled", false);
    //        return false;
    //    }
    //    else {
    //        $('#myPleaseWait').modal('hide');
    //        $("div.errormsgcenter").text("");
    //        $('#errorMsg').css('visibility', 'hidden');
    //        $('#CRMtodate').parent().removeClass('has-error');

    //    }
    //}
    var loc = '/Report/UserTrainingReport.aspx?UserYear=' + $('#Useryear').val() + '&UserQuarter=' + $('#Userquarter').val() + '&TrainingType=' + trainingType + '&MinNoofParticipants=' + minNoofParticipants;
    document.getElementById('ReportFrame').setAttribute('src', loc);
    $("#btnUserTrainRptCancel").css("visibility", "visible");
}

$('#Useryear').change(function () {

    var year = $('#Useryear').val();
    if (Useryear != null && Useryear != "" && Useryear != "null") {

        $('#Useryear').parent().removeClass('has-error');
    }

});

//function EmptyFields() {
//    $("#Useryear").val("");
//    $("#SPtodate").val("");
//    $("#txtspareparts").val("");
//    $('#btnSPReplacementRptFetch').attr('disabled', false);
//    $("#SPfromdate").prop("disabled", false);
//    $("#SPtodate").prop("disabled", false);
//    $("#txtspareparts").prop("disabled", false);
//    document.getElementById('ReportFrame').setAttribute('src', "");
//    $("#btnSPReplacementRptCancel").css("visibility", "hidden");
//}