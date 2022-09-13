
$(document).ready(function () {

    formInputValidation("CRMAssessmentPage");

    //****************************************** Save *********************************************

    $('#btnSaveAssm,#btnEditAssm').click(function () {
        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $('#errorMsgAssm').css('visibility', 'hidden');


        var sftId = $('#hdncrmAssTabStfId').val();

        var stfName = $('#CRMWorkAssStfName').val();
        var feedback = $('#CRMWorkAssFeedback').val();
        var srtdat = $('#CRMWorkAssStartdatTime').val();
        // srtdat = Date.parse($('#CRMWorkAssStartdatTime').val()).toUTCString();
        var enddat = $('#CRMWorkAssEnddatTime').val();
       //  enddat = Date.parse($('#CRMWorkAssEnddatTime').val()).toUTCString();
         requesterId =  $("#hdncrmRequesterId").val();
         requesterEmail = $("#hdncrmRequesterEmail").val();

        var timeStamp = $("#TimestampcrmAssTab").val();

        var isFormValid = formInputValidation("CRMAssessmentPage", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsgAssm').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSaveAssm').attr('disabled', false);
            //$('#btnEdit').attr('disabled', false);
            return false;
        }

        //var CompareWrkOrdDat = new Date($('#crmWorkWorkDat').val());
        //var CompareSrtDat = new Date($('#CRMWorkAssStartdatTime').val());
        //var CompareEndDat = new Date($('#CRMWorkAssEnddatTime').val());
        //var CurrDate = new Date();

        var CompareWrkOrdDat = Date.parse($('#crmWorkWorkDat').val());
        var CompareSrtDat = Date.parse($('#CRMWorkAssStartdatTime').val());
        var CompareEndDat = Date.parse($('#CRMWorkAssEnddatTime').val());
        var CurrDate = new Date();

        Date.parse($('#CRMWorkAssEnddatTime').val());

        if (CompareSrtDat < CompareWrkOrdDat) {
            $("div.errormsgcenter").text("Assessment Start Date/Time should be greater than Work Order Date/Time");
            $('#errorMsgAssm').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }

        if (CompareSrtDat > CompareEndDat) {
            $("div.errormsgcenter").text("Assessment End Date/Time should be greater than Assessment Start Date/Time");
            $('#errorMsgAssm').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var CRMWOID = $("#primaryID").val();

        var primaryId = $("#hdncrmAssTabAssId").val();
        if (primaryId != null) {
            CRMWoAssId = primaryId;
            timeStamp = timeStamp;
        }
        else {
            CRMWoAssId = 0;
            timeStamp = "";
        }

        var WorkOrderAssData = {
            CRMAssesmentId: CRMWoAssId,
            CRMRequestWOId: CRMWOID,
            StaffMasterId: sftId,
            StaffName: stfName,
            Feedback: feedback,
            AssessmentStartDate: srtdat,
            AssessmentEndDate: enddat,
            Timestamp: timeStamp,
            RequesterId: requesterId,
            RequesterEmail:requesterEmail
        }

        var jqxhr = $.post("/api/CRMWorkorderTab/SaveAssessment", WorkOrderAssData, function (response) {
            var result = JSON.parse(response);
            $("#hdncrmAssTabAssId").val(result.CRMAssesmentId);
            GetCRMWorkorderAssessTabData(result);
            //GetCRMWorkorderTabData(result.CRMRequestWOId);
            $('#crmWorkReqTyp option[value="' + result.TypeOfRequestId + '"]').prop('selected', true);
            $("#crmWorkReqTyp").prop("disabled", true);

            $("#TimestampcrmAssTab").val(result.Timestamp);
            $(".content").scrollTop(0);
            showMessage('CRM Workorder Assessment', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#btnSaveAssm').attr('disabled', false);
            $("#grid").trigger('reloadGrid');
            $('#myPleaseWait').modal('hide');

        },

       "json")
        .fail(function (response) {
            var errorMessage = "";
            if (response.status == 400) {
                errorMessage = response.responseJSON;
            }
            else {
                errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
            }
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsgAssm').css('visibility', 'visible');

            $('#btnSaveAssm').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
    });


    $("#btnCancelAssm").click(function () {
        var message = Messages.Reset_TabAlert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                window.location.href = "/bems/CRMWorkorder";
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
       
    });


    $(".nav-tabs > li:eq(2)").click(function () {
        var primaryId = $('#hdncrmAssTabAssId').val();
        var wrkordsts = $('#crmWorkWrkOrdSts').val();
        if (primaryId == 0 && wrkordsts != 143) {
            bootbox.alert("Work Order Assessment details must be saved before entering additional information.");
            return false;
        }
    });

});



function loadAssessmentTab() {

    $('#myPleaseWait').modal('show');
 
    $("div.errormsgcenter").text("");
    $('#errorMsgAssm').css('visibility', 'hidden');
    $('#errorMsg').css('visibility', 'hidden');
    var AssessmentTabPrimaryId = $('#hdncrmAssTabAssId').val();

    if ($("#ActionType").val().trim() == "View") {
        $("#CRMAssessmentPage :input:not(:button)").prop("disabled", true);
    }

        //formInputValidation("CRMAssessmentPage");

        //if ($("#ActionType").val().trim() == "View") {
        //    $("#btnSaveAssm").hide();
        //}

        var primaryId = $('#primaryID').val();      //Workorder Id

        $.get("/api/CRMWorkorderTab/GetAssessment/" + primaryId)
       .done(function (result) {
           var result = JSON.parse(result);
          // $("#jQGridCollapse1").click();
           if (result.CRMAssesmentId > 0) {
               GetCRMWorkorderAssessTabData(result)
           }
           else {
               //29-May-2018 11:46
               var today = new Date();
               var CurDate = GetCurrentDate();
               var hour = today.getHours();
               var time = today.getMinutes();

               if (time < 10) {
                   time = 0 + "" + time;
               }
                
               var gettime = hour + ":" + time;

               var CurDateTime = CurDate + " " + gettime;

               $('#CRMWorkAssStartdatTime').val(CurDateTime);
               $('#CRMWorkAssEnddatTime').val(CurDateTime);

                   /* Taking staff name from Work Order Tab and assigning in Assessment tab*/
                   var AssStf = $('#crmWorkStfAss').val();
                   var AssStfId = $('#hdncrmWorkStfAssId').val();
                   $('#CRMWorkAssStfName').val(AssStf).prop("disabled", true);
                   $('#hdncrmAssTabStfId').val(AssStfId);

                   $('#myPleaseWait').modal('hide');
           }

           $('#myPleaseWait').modal('hide');
       })
       .fail(function (response) {
           $('#myPleaseWait').modal('hide');
           $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
           $('#errorMsgAssm').css('visibility', 'visible');
       });

        $('#myPleaseWait').modal('hide');
}



function GetCRMWorkorderAssessTabData(getResult) {

    var primaryWorkorderId = $('#primaryID').val();
    $("#divWOStatus").text(getResult.WorkOrderStatus);
    $('#hdncrmAssTabAssId').val(getResult.CRMAssesmentId);
    //$("#crmWorkWorkOrdNo").val(getResult.CRMRequestWOId);
    $("#hdncrmAssTabStfId").val(getResult.StaffMasterId);
    $("#CRMWorkAssStfName").val(getResult.StaffName);
    $("#CRMWorkAssFeedback").val(getResult.Feedback);
    $("#CRMWorkAssStartdatTime").val(moment(getResult.AssessmentStartDate).format("DD-MMM-YYYY HH:mm"));
    $("#CRMWorkAssEnddatTime").val(moment(getResult.AssessmentEndDate).format("DD-MMM-YYYY HH:mm"));
    $('#TimestampcrmAssTab').val(getResult.Timestamp);

    if (getResult.WorkOrderStatusId == 142) {
        DisableFields();
    }

}



//function FetchStaff(event) {
//    var ItemMst = {
//        SearchColumn: 'crmWorkStfAss' + '-StaffName',//Id of Fetch field
//        ResultColumns: ["StaffMasterId" + "-Primary Key", 'StaffName' + '-crmWorkStfAss'],//Columns to be displayed
//        FieldsToBeFilled: ["hdncrmWorkStfAssId" + "-StaffMasterId", 'crmWorkStfAss' + '-StaffName']//id of element - the model property
//    };
//    DisplayFetchResult('StaffFetch', ItemMst, "/api/Fetch/CompanyStaffFetch", "Ulfetch3", event, 1);
//}



