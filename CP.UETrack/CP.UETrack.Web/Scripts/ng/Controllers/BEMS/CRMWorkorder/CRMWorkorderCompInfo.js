
$(document).ready(function () {

    //formInputValidation("CRMCompInfoPage");

    //****************************************** Save *********************************************

    $('#btnSaveComp,#btnEditComp').click(function () {
        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $('#errorMsgComInfo').css('visibility', 'hidden');

        var hdnCompInfoTabId = $('#hdncrmCompTabCompInfoId').val();
        var comsrtdat = $('#CRMWorkCompInfoSrtDat').val();
        var comenddat = $('#CRMWorkCompInfoEndDat').val();
        var compby = $('#CRMWorkCompInfoCompBy').val();
        var compbyid = $('#hdncrmCompTabCompbyId').val();
        var pos = $('#CRMWorkCompInfoPos').val();
        var posid = $('#hdncrmCompTabPosId').val();
        var comprem = $('#CRMWorkCompInfoCompRem').val();
        var comhandat = $('#CRMWorkCompInfoHanOvrDat').val();
        var accptby = $('#CRMWorkCompInfoAccBy').val();
        var accptbyid = $('#hdncrmCompTabAccbyId').val();
        var woAssigneeEmail = $('#hdncrmWorkStfEmail').val();
        var crmRequesterEmail = $('#hdncrmRequesterEmail').val();

        if (accptbyid == 0 || accptbyid == "" || accptbyid == undefined) {
            accptbyid = null;           
        }
        

        var closrem = $('#CRMWorkCompInfoRem').val();
        var timeStamp = $("#TimestampcrmCompTab").val();

        var isFormValid = formInputValidation("CRMCompInfoPage", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsgComInfo').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            //$('#btnEdit').attr('disabled', false);
            return false;
        }

        if (compbyid == '') {
            $("div.errormsgcenter").text("Valid Completed Staff is required.");
            $('#errorMsgComInfo').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }

        if (hdnCompInfoTabId > 0) {
            if (accptbyid == '' || accptbyid == null) {
                $("div.errormsgcenter").text("Valid Accepted By Staff is required.");
                $('#errorMsgComInfo').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }

        var CRMWOID = $("#primaryID").val();

        var primaryId = $("#hdncrmCompTabCompInfoId").val();
        if (primaryId != null) {
            CRMWoCompId = primaryId;
            timeStamp = timeStamp;
        }
        else {
            CRMWoCompId = 0;
            timeStamp = "";
        }

        //var CompareHndOvrDat = new Date($('#CRMWorkCompInfoHanOvrDat').val());

        //var checkStartDate = new Date($('#CRMWorkCompInfoSrtDat').val());
        //var checkEndDate = new Date($('#CRMWorkCompInfoEndDat').val());

        var WorkOrderCompinfoData = {
            CRMCompletionInfoId: CRMWoCompId,
            CRMRequestWOId: CRMWOID,
            StartDateTime: comsrtdat,
            EndDateTime: comenddat,
            CompletedById: compbyid,
            //CompbyPositionId: posid,
            CompletedRemarks: comprem,
            HandOverDateTime: comhandat,
            AcceptedById: accptbyid,
            Remarks: closrem,
            AssigneeEmail: woAssigneeEmail,
            RequesterEmail:crmRequesterEmail,
            Timestamp: timeStamp
        }

        //if (!(WorkOrderCompinfoData.CRMCompletionInfoId)) {
        //    $('#AcceptedBy').html("Accepted By")
        //}
        //else {
        //    $('#AcceptedBy').html("Accepted By <span class='red'>*</span>")
        //}

        //var CompareAssStrDat = new Date ($('#CRMWorkAssStartdatTime').val());
        //var CompareAssEndDat = new Date($('#CRMWorkAssEnddatTime').val());
        //var CompareHndOvrDat = new Date($('#CRMWorkCompInfoHanOvrDat').val());

        var CompareAssStrDat = Date.parse($('#CRMWorkAssStartdatTime').val());
        var CompareAssEndDat = Date.parse($('#CRMWorkAssEnddatTime').val());
        var CompareHndOvrDat = Date.parse($('#CRMWorkCompInfoHanOvrDat').val());

        //var checkStartDate = new Date((WorkOrderCompinfoData.StartDateTime));
        //var checkEndDate = new Date((WorkOrderCompinfoData.EndDateTime));

        var checkStartDate = Date.parse((WorkOrderCompinfoData.StartDateTime));
        var checkEndDate = Date.parse((WorkOrderCompinfoData.EndDateTime));

        if ((checkStartDate < CompareAssStrDat) && (checkStartDate < CompareAssEndDat)) {
            $("div.errormsgcenter").text("Completion Start Date/Time Should not be lesser than Assessment Start and End Date/Time");
            $('#errorMsgComInfo').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;            
        }

        if (checkEndDate < checkStartDate) {
            $("div.errormsgcenter").text("Completion End Date/Time Should be greater than Start Date/Time");
            $('#errorMsgComInfo').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }

        if (CompareHndOvrDat < checkEndDate) {
            $("div.errormsgcenter").text("Handover Date/Time Should be greater than Completion End Date/Time");
            $('#errorMsgComInfo').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var jqxhr = $.post("/api/CRMWorkorderTab/SaveCompInfo", WorkOrderCompinfoData, function (response) {
            var result = JSON.parse(response);
            $("#hdncrmCompTabCompInfoId").val(result.CRMCompletionInfoId);
            GetCRMWorkorderCompInfoTabData(result);
            //GetCRMWorkorderTabData(result.CRMRequestWOId);
            $('#CRMWorkCompInfoCompRem').parent().removeClass('has-error');
            $("#TimestampcrmCompTab").val(result.Timestamp);
            $('#crmWorkReqTyp option[value="' + result.TypeOfRequestId + '"]').prop('selected', true);
            $("#crmWorkReqTyp").prop("disabled", true);
            $(".content").scrollTop(0);
            showMessage('CRM Workorder Assessment', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#btnSaveComp').attr('disabled', false);
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
            $('#errorMsgComInfo').css('visibility', 'visible');

            $('#btnSaveComp').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
    });


    $("#btnCancelComp").click(function () {
        
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

});



function loadCompletionInfoTab() {
    $('#myPleaseWait').modal('show');

    $("div.errormsgcenter").text("");
    $('#errorMsgComInfo').css('visibility', 'hidden');

    //formInputValidation("CRMCompInfoPage");

    //if ($("#ActionType").val().trim() == "View") {
    //    $("#btnSaveComp").hide();
    //}

    var primaryId = $('#primaryID').val();  //CRMWorkorder Id

        $.get("/api/CRMWorkorderTab/GetCompInfo/" + primaryId)
       .done(function (result) {
           var result = JSON.parse(result);

           if (result.CRMCompletionInfoId > 0) {
               GetCRMWorkorderCompInfoTabData(result)
           }
           else {
               $('#myPleaseWait').modal('hide');
           }

           $('#myPleaseWait').modal('hide');
       })
       .fail(function (response) {
           $('#myPleaseWait').modal('hide');
           $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
           $('#errorMsgComInfo').css('visibility', 'visible');
       });
   // }

    $('#myPleaseWait').modal('hide');

}



function GetCRMWorkorderCompInfoTabData(getResult) {

    formInputValidation("CRMCompInfoPage");
    var primaryWorkorderId = $('#primaryID').val();

    

    $("#divWOStatus").text(getResult.WorkOrderStatus);
    $('#hdncrmCompTabCompInfoId').val(getResult.CRMCompletionInfoId);
    //$("#crmWorkWorkOrdNo").val(getResult.CRMRequestWOId);
    $("#CRMWorkCompInfoSrtDat").val(moment(getResult.StartDateTime).format("DD-MMM-YYYY HH:mm"));
    $("#CRMWorkCompInfoEndDat").val(moment(getResult.EndDateTime).format("DD-MMM-YYYY HH:mm"));
    $("#CRMWorkCompInfoCompBy").val(getResult.CompletedBy);
    $("#hdncrmCompTabCompbyId").val(getResult.CompletedById);
    $("#CRMWorkCompInfoPos").val(getResult.CompbyPosition);
    //$("#hdncrmCompTabPosId").val(getResult.CompbyPositionId);
    $("#CRMWorkCompInfoCompRem").val(getResult.CompletedRemarks);
    $("#CRMWorkCompInfoHanOvrDat").val(moment(getResult.HandOverDateTime).format("DD-MMM-YYYY HH:mm"));

    if (getResult.CRMCompletionInfoId > 0) {
        $("#AcceptedBy").html("Accepted By <span class='red'>*</span>");
        $("#CRMWorkCompInfoAccBy").val(getResult.AcceptedBy);
        $('#CRMWorkCompInfoAccBy').prop('required', true);
        $('#CRMWorkCompInfoAccBy').prop('disabled', false);
        $("#lblCRMWorkCompInfoClorem").html("Closing Remarks <span class='red'>*</span>");
        $("#CRMWorkCompInfoRem").val(getResult.AcceptedBy);
        $('#CRMWorkCompInfoRem').prop('required', true);
        $('#CRMWorkCompInfoRem').prop('disabled', false);
    }

    $("#CRMWorkCompInfoAccBy").val(getResult.AcceptedBy);
    $("#hdncrmCompTabAccbyId").val(getResult.AcceptedById);
    $("#CRMWorkCompInfoRem").val(getResult.Remarks);
    $('#TimestampcrmCompTab').val(getResult.Timestamp);

    if (getResult.AcceptedById > 0) {
        DisableFields();
    }
    formInputValidation("CRMCompInfoPage");
}



function FetchCompletedStaff(event) {    // Commonly using CompanyStaffFetch
    var ItemMst = {
        SearchColumn: 'CRMWorkCompInfoCompBy' + '-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId" + "-Primary Key", 'StaffName' + '-CRMWorkCompInfoCompBy'],//Columns to be displayed
        FieldsToBeFilled: ["hdncrmCompTabCompbyId" + "-StaffMasterId", 'CRMWorkCompInfoCompBy' + '-StaffName', 'CRMWorkCompInfoPos' + '-Designation', 'hdncrmCompTabPosId' + '-DesignationId' ]//id of element - the model property
    };
    DisplayFetchResult('CompStfFetch', ItemMst, "/api/Fetch/CompanyStaffFetch", "Ulfetch", event, 1);
}

function FetchAcceptedStaff(event) {    // Commonly using CompanyStaffFetch
    var ItemMst = {
        SearchColumn: 'CRMWorkCompInfoAccBy' + '-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId" + "-Primary Key", 'StaffName' + '-CRMWorkCompInfoAccBy'],//Columns to be displayed
        FieldsToBeFilled: ["hdncrmCompTabAccbyId" + "-StaffMasterId", 'CRMWorkCompInfoAccBy' + '-StaffName']//id of element - the model property
    };
    DisplayFetchResult('AccptStfFetch', ItemMst, "/api/Fetch/FetchRecords", "Ulfetch1", event, 1);
}


function DisableFields() {
    $(".content").scrollTop(0);
    $("#CRMCompInfoPage :input:not(:button)").prop("disabled", true);
    $("#CRMAssessmentPage :input:not(:button)").prop("disabled", true);
    $("#crmworkorderPage :input:not(:button)").prop("disabled", true);
    $("#CommonAttachment :input:not(:button)").prop("disabled", true);
    $("#btnEdit").hide();
    $("#btnSave").hide();
    $("#btnEditAssm").hide();
    $("#btnEditAssm").hide();
    $("#btnSaveAssm").hide();
    $("#btnEditComp").hide();
    $("#btnSaveComp").hide();

    $("#FileTypeId_0").prop("disabled", true);

}
