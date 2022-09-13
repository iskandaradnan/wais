$(document).ready(function () {

    $('#btnDelete').hide();
    $('#btnEditFeedBk').hide();
    $('#btnNextScreenSave').hide();
   
    /*======================================================= Rating Star Process Start ==========================================================*/

    /* 1. Visualizing things on Hover - See next part for action on click */
    $('.stars li').on('mouseover', function () {

        var actiontype = $('#ActionType').val().toUpperCase();
        var isconfirm = $('#hdnIsConfim').val();
        if (actiontype == "ADD" || actiontype == "EDIT") {
            Usrstatus = $("#UserTrainCompTraiSts").val();
            if (Usrstatus != 263) {
                if (isconfirm == "false") {
                    var onStar = parseInt($(this).data('value'), 10); // The star currently mouse on

                    // Now highlight all the stars that's not after the current hovered star
                    $(this).parent().children('li.star').each(function (e) {
                        if (e < onStar) {
                            $(this).addClass('hover');
                        }
                        else {
                            $(this).removeClass('hover');
                        }
                    });
                }
            }
        }
    }).on('mouseout', function () {
        $(this).parent().children('li.star').each(function (e) {
            $(this).removeClass('hover');
        });
    });


    /* 2. Action to perform on click */


    $('.stars li').on('click', function () {
        var actiontype = $('#ActionType').val().toUpperCase();
        var isconfirm = $('#hdnIsConfim').val();
        if (actiontype == "ADD" || actiontype == "EDIT") {
            Usrstatus = $("#UserTrainCompTraiSts").val();
            if (Usrstatus != 263) {
                if (isconfirm == "false") {
                    var onStar = parseInt($(this).data('value'), 10); // The star currently selected
                    var stars = $(this).parent().children('li.star');
                    var ulCount = $(this).parent().data('count');

                    for (i = 0; i < stars.length; i++) {
                        $(stars[i]).removeClass('selected');
                    }

                    for (i = 0; i < onStar; i++) {
                        $(stars[i]).addClass('selected');
                    }

                    // JUST RESPONSE (Not needed)
                    var ratingValue = parseInt($('.stars').eq(ulCount).find('li.selected').last().data('value'), 10);
                    var msg = "";
                    if (ratingValue > 1) {
                        msg = ratingValue;
                    }
                    else {
                        msg = ratingValue;
                    }
                    $('.success-box').fadeIn(200);
                    // $('.success-box div.text-message').eq(ulCount).html("<span id=row" + ulCount + ">" + msg + "</span>");
                    $('#Curr' + ulCount).val(msg);

                }
            }
        }
        });
    


/*======================================================= Rating Star Process End ==========================================================*/


    $('#btnSaveFeedBk,#btnEditFeedBk').click(function () {
        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $('#errorMsgFeedBk').css('visibility', 'hidden');


        var Cur1 = $('#Curr0').val();
        var Cur2 = $('#Curr1').val();
        var Cur3 = $('#Curr2').val();
        var Cur4 = $('#Curr3').val();
        var Cur5 = $('#Curr4').val();

        var Course1 = $('#Curr5').val();
        var Course2 = $('#Curr6').val();
        var Course3 = $('#Curr7').val();

        var Del1 = $('#Curr8').val();
        var Del2 = $('#Curr9').val();
        var Del3 = $('#Curr10').val();
        var Recom = $('#UserTrainFdBkRecom').val();

        var timeStamp = $("#TimestampUserTraiFeedbkTab").val();

        var isFormValid = formInputValidation("UserTrainingFeedBackpg", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsgFeedBk').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSaveFeedBk').attr('disabled', false);
            //$('#btnEdit').attr('disabled', false);
            return false;
        }

        var UserTraiID = $("#primaryID").val();

        var TraifdBkId = $("#hdnUserTraiFeedbkId").val();
        if (TraifdBkId != null) {
            TraifeedBkId = TraifdBkId;
            timeStamp = timeStamp;           
        }
        else {
            TraifeedBkId = 0;
            timeStamp = "";
        }

        var UserTraiFeedbackData = {
            TrainingFeedbackId: TraifeedBkId,
            TrainingScheduleId: UserTraiID,
            Curriculum1: Cur1,
            Curriculum2: Cur2,
            Curriculum3: Cur3,
            Curriculum4: Cur4,
            Curriculum5: Cur5,
            CourseIntructors1: Course1,
            CourseIntructors2: Course2,
            CourseIntructors3: Course3,
            TrainingDelivery1: Del1,
            TrainingDelivery2: Del2,
            TrainingDelivery3: Del3,
            Recommendation:Recom,
            Timestamp: timeStamp
        }

        var jqxhr = $.post("/api/UserTraining/SaveFeedback", UserTraiFeedbackData, function (response) {
            var result = JSON.parse(response);
            $("#hdnUserTraiFeedbkId").val(result.TrainingFeedbackId);
            //GetCRMWorkorderAssessTabData(result);
            $("#TimestampUserTraiFeedbkTab").val(result.Timestamp);
            $(".content").scrollTop(0);
            showMessage('User Training feedback', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);
            if(result.TrainingFeedbackId!=null)
            {
            //$('#btnEditFeedBk').show();
                $('#btnSaveFeedBk').show();

            }

            $('#btnSaveFeedBk').attr('disabled', false);
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
            $('#errorMsgFeedBk').css('visibility', 'visible');

            $('#btnSaveFeedBk').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
    });

    //$("#btnCancelFeedBk").click(function () {
    //    window.location.href = "/BEMS/usertraining";
    //});

});


function UserTraiFeedBackTab() {
    var action = "";
    $('#myPleaseWait').modal('show');
    $("#btnSaveFeedBk").show();
    $("#UserTrainFdBkRecom").prop('disabled', false);

    $("div.errormsgcenter").text("");
    $('#errorMsgFeedBk').css('visibility', 'hidden');

    var FeedbackTabPrimaryId = $('#hdnUserTraiFeedbkId').val();
    var Usrstatus = $("#UserTrainCompTraiSts").val();
    if (Usrstatus == 263) {
        $("#UserTrainFdBkRecom").prop('disabled', true);
        $("#btnSaveFeedBk").hide();
        $("#btnEditFeedBk").hide();

    }
    var iscon = $('#hdnIsConfim').val();
    if (iscon == "true") {
        $("#UserTrainFdBkRecom").prop('disabled', true);
        $("#btnSaveFeedBk").hide();
        $("#btnEditFeedBk").hide();
        
    }
    
    //if ($("#ActionType").val().trim() == "View") {
    //    $("#CRMAssessmentPage :input:not(:button)").prop("disabled", true);
    //}

    //formInputValidation("CRMAssessmentPage");
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");


    if (!hasEditPermission ) {
        action = "View"
    }
   // var actiontype = $('#ActionType').val()
    if (action == 'View') {
        $('.noreqired').prop('required', false);
        $("#UserTrainingFeedBackpg :input:not(:button)").prop("disabled", true);

    }
    


    var primaryId = $('#primaryID').val();      //Workorder Id
    if (primaryId > 0) {


        $.get("/api/UserTraining/GetFeedback/" + primaryId)
       .done(function (result) {
           var result = JSON.parse(result);

           if (result.TrainingFeedbackId > 0) {
               GetFeedbackTabData(result)
           }
           else {
               var traiSchNo = $('#UserTrainComptraiSchNo').val();
               $('#UserTrainFdBkSchNo').val(traiSchNo);
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
    else {
        $('#myPleaseWait').modal('hide');
    }
}



function GetFeedbackTabData(getResult) {

    var TrainingScheduleId = $('#primaryID').val();
    var Ser = $('#UserTrainCompSer option:selected').text();
    var traiSchNo = $('#UserTrainComptraiSchNo').val();

    //$('#UserTrainFdBkSer option[value="' + 2 + '"]' + Ser + '').prop('selected', true);
    $('#UserTrainFdBkSer').append('<option value="' + 2 + '">' + Ser + '</option>');
    $('#UserTrainFdBkSchNo').val(traiSchNo);

    $('#hdnUserTraiFeedbkId').val(getResult.TrainingFeedbackId);
    $('').eq
    $("#Curr0").val(getResult.Curriculum1);
    $("#Curr1").val(getResult.Curriculum2);
    $("#Curr2").val(getResult.Curriculum3);
    $("#Curr3").val(getResult.Curriculum4);
    $("#Curr4").val(getResult.Curriculum5);
    $("#Curr5").val(getResult.CourseIntructors1);
    $('#Curr6').val(getResult.CourseIntructors2);
    $("#Curr7").val(getResult.CourseIntructors3);
    $("#Curr8").val(getResult.TrainingDelivery1);
    $("#Curr9").val(getResult.TrainingDelivery2);
    $("#Curr10").val(getResult.TrainingDelivery3);
    $('.stars').each(function () {
        $(this).find('li:lt(' + $('#Curr' + $(this).data('count')).val() + ')').addClass('selected');
    })
    $("#UserTrainFdBkRecom").val(getResult.Recommendation);

}


$("#btnCancelFeedBk").click(function () {
    var message = Messages.Reset_Alert_CONFIRMATION;
    bootbox.confirm(message, function (result) {
        if (result) {
            EmptyFieldsfedbck();
        }
        else {
            $('#myPleaseWait').modal('hide');
        }
    });
});


function EmptyFieldsfedbck() {
    $(".content").scrollTop(0);
    $('input[type="text"], textarea').val('');
    $('#UserTrainCompQuarter option[value="' + 0 + '"]').prop('selected', true)
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#grid").trigger('reloadGrid');
    $("#UserTraiCopmPage :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#TrainingCompSection').css('visibility', 'visible');
    $('#TrainingCompSection').hide();
    $("#hdnUserTraiFeedbkId").val('');
    // SchduleSection();
    $('#UserTrainCompPlndDte').prop("disabled", false);
   // $('#UserTrainCompTraiTyp option[value="' + 254 + '"]').prop("disabled", false);

    $('#UserTrainCompTraiTyp option[value="' + 254 + '"]').prop('selected', true);
    $('#UserTrainComptraiDesc').prop("disabled", false);
    $('#UserTrainComptraiMod').prop("disabled", false);
    $('#UserTrainCompMinPar').prop("disabled", false);
    $("#paginationfooter").hide();
    $('.star').removeClass('selected');
    //// To refresh Called load
    $.get("/api/UserTraining/Load")
    .done(function (result) {
        var loadResult = JSON.parse(result);
        planedReq();
        validation();
        // AddNewRowUserTraining();
        $.each(loadResult.FacilityLovs, function (index, value) {
            $('#UserTrainCompFacCde').val(value.FieldValue);
        });
     
        $('#UserTrainAddrow').hide();
        $('.nav-tabs a:first').tab('show');
    })
.fail(function () {
    $('#myPleaseWait').modal('hide');
    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
    $('#errorMsg').css('visibility', 'visible');
});

}
//****************************** MonthlyServiceFee GetById *********************************


function getById(primaryId) {
    $.get("/api/MonthlyServiceFee/get/" + primaryId)
            .done(function (result) {
                var result = JSON.parse(result);

                $('#primaryID').val(result.MonthlyFeeId);
                $('#Timestamp').val(result.Timestamp);
                $('#monthlyfacility').val(result.FacilityName);
                $('#monthlyyear option[value="' + result.Year + '"]').prop('selected', true);
                $('#monthlyyear').prop("disabled", "disabled");

                //$("#MonthlyServiceFeeTbl").empty();
                if (result != null && result.MonthlyServiceFeeListData != null && result.MonthlyServiceFeeListData.length > 0) {
                    BindGridData(result);
                }

                $('#myPleaseWait').modal('hide');
            })
            .fail(function () {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');
            });
}