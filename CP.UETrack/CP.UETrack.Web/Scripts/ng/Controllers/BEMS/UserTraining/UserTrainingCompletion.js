var pageindex = 1, pagesize = 5;
var GridtotalRecords = 0;
var TotalPages = 1, FirstRecord, LastRecord = 0;
var ActionType = $('#ActionType').val();
var CurrentbtnID;
var Arearesult = [];
$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    $('#UserTrainCompEmail').attr('pattern', '^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$');
    formInputValidation("UserTraiCopmPage");
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnConfirmVerify').hide();
    $('#btnNextScreenSave').hide();
    $.get("/api/UserTraining/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            LOVlist = loadResult;
            $("#jQGridCollapse1").click();
            AddNewRowUserTraining();
            AddNewRowUserTrainingArea();
            $('#UserTrainAddrowArea').show();
            $('#UserTrainCompAreaPop_0').prop("disabled", false);
            //var facilityval = $('#selFacilityLayout option:selected').text();
            //var FacCode = loadResult.FacilityLovs

            $.each(loadResult.FacilityLovs, function (index, value) {
                $('#UserTrainCompFacCde').val(value.FieldValue);
            });
            //$('#UserTrainCompFacCde').val(FacCode);

            $.each(loadResult.ServiceLovs, function (index, value) {
                $('#UserTrainCompSer').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            $.each(loadResult.TrainingTypeLovs, function (index, value) {
                $('#UserTrainCompTraiTyp').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.QuarterLovs, function (index, value) {
                $('#UserTrainCompQuarter').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.TrainingStsLovs, function (index, value) {
                $('#UserTrainCompTraiSts').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.TrainingSourceLovs, function (index, value) {
                $('#UserTrainCompTraiSource').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $(LOVlist.RequestServiceList).each(function (_index, _data) {
                $('#selServices').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))
                //alert(RequestServiceList);
            });
            $('#UserTrainAddrow').hide();
            $('#UserTrainCompNotDat').css("background-color", "#fff");

            planedReq();
            //var TrainSchId = $('#primaryID').val();
            //if (TrainSchId > 0) {
            //    $('#TrainingCompSection').css('visibility', 'visible');
            //    $('#TrainingCompSection').show();
            //}
            //else {
            //    $('#TrainingCompSection').css('visibility', 'hidden');
            //    $('#TrainingCompSection').hide();
            //}
            $('#UserTrainCompParName_0').prop("required", false);
            //---------new code added for UET15-56 issue---------------START---
            var checkpoint = $("#UserTrainCompTraiTyp").val();
           
            if (checkpoint == 255)
            {
                $('#UserTrainCompQuarter').val(0);
                $('#UserTrainCompYear').val(0);
                $('#UserTrainCompPlndDte').val('');
                $("#UserTraiCopmPage :input:not(:button)").parent().removeClass('has-error');
                $('#UserTrainCompActDate').prop('required', false);
                $('#UserTrainCompVenue').prop("required", false);
                $('#UserTrainCompParName_0').prop("required", false);
                $("div.errormsgcenter").text("");
                $('#errorMsg').css('visibility', 'hidden');
                $('#UserTrainCompNotDat').val('');
                $('#UserTrainComptraiDesc').val('');
                $('#UserTrainComptraiMod').val('');
                $('#UserTrainCompMinPar').val('');
                $('#UserTrainCompPresTrainer').val('');
                $('#UserTrainCompExp').val('');
                $('#UserTrainCompDesig').val('');
                $('#UserTrainCompEmail').val('');


                $('#UserTrainCompTraiSource option[value="' + 0 + '"]').prop("selected", true);
                $('#UserTrainCompTraiSource').prop("disabled", false);
                $("#UserTrainCompTraiSource").val('').prop('disabled', false);
                $('#ExtEmail').css('visibility', 'hidden');
                $('#ExtEmail').hide();
                Arearesult = [];
                $("#UserTainAreaTableGrid").empty();
                AddNewRowUserTrainingArea();
                $('#TrainingCompSection').css('visibility', 'visible');
                $('#TrainingCompSection').show();
                $('#UserTrainCompReschDate').prop("disabled", true);
                // AddNewRowUserTraining();
                unplanedReq();
                SchduleSection();
                $('#UserTrainCompActDate').prop("required", true);
                $("#lblActDate").html("Actual Date <span class='red'>*</span>");
                $('#UserTrainCompVenue').prop("required", true);

                $('#UserTrainAddrow').show();
                $('#UserTrainCompParName_0').prop("required", true);
                //$('#UserTrainCompQuarter').prop("disabled", false);
                $('#UserTrainCompNotDat').prop("disabled", true);
                $('#UserTrainCompNotDat').css("background-color", "#eee");
                $('#UserTrainCompNotDat').prop("required", false);
                $("#lblNotDat").html("Notification Date");
                $('#UserTrainCompNotDat').val('');

            }
            else {
                $('#UserTrainCompVenue').prop("required", false);
            }
             //---------new code added for UET15-56 issue---------------END---
            $("#UserTrainCompTraiTyp").change(function () {
                $('#UserTrainCompQuarter').val(0);
                $('#UserTrainCompYear').val(0);
                $('#UserTrainCompPlndDte').val('');
                $("#UserTraiCopmPage :input:not(:button)").parent().removeClass('has-error');
                $('#UserTrainCompActDate').prop('required', false);
                $('#UserTrainCompVenue').prop("required", false);
                $('#UserTrainCompParName_0').prop("required", false);
                $("div.errormsgcenter").text("");
                $('#errorMsg').css('visibility', 'hidden');
                $('#UserTrainCompNotDat').val('');
                $('#UserTrainComptraiDesc').val('');
                $('#UserTrainComptraiMod').val('');
                $('#UserTrainCompMinPar').val('');
                $('#UserTrainCompPresTrainer').val('');
                $('#UserTrainCompExp').val('');
                $('#UserTrainCompDesig').val('');
                $('#UserTrainCompEmail').val('');


                $('#UserTrainCompTraiSource option[value="' + 0 + '"]').prop("selected", true);
                $('#UserTrainCompTraiSource').prop("disabled", false);
                $("#UserTrainCompTraiSource").val('').prop('disabled', false);
                $('#ExtEmail').css('visibility', 'hidden');
                $('#ExtEmail').hide();
                Arearesult = [];
                $("#UserTainAreaTableGrid").empty();
                AddNewRowUserTrainingArea();

                if (this.value == 254) {
                    $('#TrainingCompSection').css('visibility', 'hidden');
                    $('#TrainingCompSection').hide();
                    $('#UserTrainCompReschDate').prop("disabled", false);
                    planedReq();
                    completionSection();
                    $('#UserTrainAddrow').hide();
                    $('#UserTrainCompActDate').prop('required', false);
                    $('#UserTrainCompVenue').prop("required", false);
                    $('#UserTrainCompParName_0').prop("required", false);
                    $('#UserTrainCompNotDat').prop("disabled", false);
                    $('#UserTrainCompNotDat').css("background-color", "#fff");
                    $('#UserTrainCompNotDat').prop('required', true);
                    $("#lblNotDat").html("Notification Date <span class='red'>*</span>");
                    // $('#UserTrainCompQuarter option[value="' + 0 + '"]').prop('selected', true);

                    //$("#UserTrainingGrid").empty();
                }
                else {
                    $('#TrainingCompSection').css('visibility', 'visible');
                    $('#TrainingCompSection').show();
                    $('#UserTrainCompReschDate').prop("disabled", true);
                    // AddNewRowUserTraining();
                    unplanedReq();
                    SchduleSection();
                    $('#UserTrainCompActDate').prop("required", true);
                    $("#lblActDate").html("Actual Date <span class='red'>*</span>");
                    $('#UserTrainCompVenue').prop("required", false);

                    $('#UserTrainAddrow').show();
                    $('#UserTrainCompParName_0').prop("required", true);
                    //$('#UserTrainCompQuarter').prop("disabled", false);
                    $('#UserTrainCompNotDat').prop("disabled", true);
                    $('#UserTrainCompNotDat').css("background-color", "#eee");
                    $('#UserTrainCompNotDat').prop("required", false);
                    $("#lblNotDat").html("Notification Date");
                    $('#UserTrainCompNotDat').val('');
                }
            });

            $("#UserTrainCompTraiSource").change(function () {
                if (this.value == 265) {
                    $('#UserTrainCompExp').prop("disabled", false);
                    $('#UserTrainCompDesig').prop("disabled", false);
                    $('#UserTrainCompPresTrainer').parent().empty().append('<input type="text" class="form-control" autocomplete="off"  id="UserTrainCompPresTrainer" required/>');
                    $('#UserTrainCompExp').val("");
                    $('#UserTrainCompDesig').val("");
                    $('#UserTrainCompPresTrainer').val("");
                    $('#ExtEmail').css('visibility', 'visible');
                    $('#ExtEmail').show();
                    $('#UserTrainCompEmail').prop("required", true);
                    $('#UserTrainCompPresTrainer').prop("disabled", false);

                }
                else if (this.value == 264) {
                    $('#UserTrainCompPresTrainer').parent().empty().append('<input type="text" class="form-control" placeholder="Please Select" autocomplete="off" onkeyup="FetchTrainer(event)" onpaste="FetchTrainer(event)" onchange="FetchTrainer(event)" oninput="FetchTrainer(event)" id="UserTrainCompPresTrainer" required/>');
                    $('#trainerdiv').append('<div class="col-sm-6" id="CompStfFetch"></div>');
                    $('#UserTrainCompExp').prop("disabled", true);
                    $('#UserTrainCompDesig').prop("disabled", true);
                    $('#ExtEmail').css('visibility', 'hidden');
                    $('#ExtEmail').hide();
                    $('#UserTrainCompEmail').prop("required", false);
                    $('#UserTrainCompExp').val("");
                    $('#UserTrainCompDesig').val("");
                    $('#UserTrainCompPresTrainer').prop("disabled", false);
                }
                else {
                    $('#UserTrainCompExp').prop("disabled", false);
                    $('#UserTrainCompDesig').prop("disabled", false);
                    $('#UserTrainCompExp').val("");
                    $('#UserTrainCompDesig').val("");
                    $('#UserTrainCompPresTrainer').val("");
                    $('#ExtEmail').css('visibility', 'hidden');
                    $('#ExtEmail').hide();
                    $('#UserTrainCompEmail').prop("required", false);
                    $('#UserTrainCompPresTrainer').prop("disabled", true);
                    $('#UserTrainCompPresTrainer').parent().empty().append('<input type="text" class="form-control" autocomplete="off"  id="UserTrainCompPresTrainer" required disabled/>');
                }
            });


            $("#UserTrainCompPlndDte").on('change', function () {
                $('#UserTrainCompYear').empty();
                //alert($('#UserTrainCompPlndDte').val());
                //var plndDt = new Date($('#UserTrainCompPlndDte').val());
                var plndDt = Date.parse($('#UserTrainCompPlndDte').val());
                var yr = plndDt.getFullYear();
                var mnth = plndDt.getMonth() + 1;
                //if (!(yr && mnth)){
                if (yr > 0) {
                    $('#UserTrainCompYear').append('<option value="' + yr + '">' + yr + '</option>');

                    if (mnth >= 1 && mnth <= 3) {
                        var qrtrId = 256;
                    }
                    else if (mnth >= 4 && mnth <= 6) {
                        var qrtrId = 257;
                    }
                    else if (mnth >= 7 && mnth <= 9) {
                        var qrtrId = 258;
                    }
                    else if (mnth >= 10 && mnth <= 12) {
                        var qrtrId = 259;
                    }
                    $('#UserTrainCompQuarter option[value="' + qrtrId + '"]').prop('selected', true);
                }
            });

            $("#UserTrainCompActDate").on('change', function () {
                var isResh = $('#HdnIsRechDone').val();
                var ReshdateChk = $('#UserTrainCompReschDate').val();

                var ActdateConLd = $('#UserTrainCompActDate').val();

                //var plndDt = new Date($('#UserTrainCompPlndDte').val());
                var plndDt = Date.parse($('#UserTrainCompPlndDte').val());
                if (plndDt != null) {
                    var yr = plndDt.getFullYear();
                    var mnth = plndDt.getMonth() + 1;
                }


                //var ActDt = new Date($('#UserTrainCompActDate').val());
                var ActDt = Date.parse($('#UserTrainCompActDate').val());
                if (ActDt != null) {
                    var Acyr = parseInt(ActDt.getFullYear());
                    var Acmnth = ActDt.getMonth() + 1;
                }
                //var Acyr = parseInt(ActDt.getFullYear());
                //var Acmnth = ActDt.getMonth() + 1;

                if (isResh == "false") {
                    //if (Acyr != NaN) {
                    if (!isNaN(Acyr)) {
                        if (yr == Acyr) {
                            var qrtr1 = chkQrtr(mnth);
                            var qrtr2 = chkQrtr(Acmnth);

                            if (qrtr1 == qrtr2) {
                                $('#UserTrainCompTraiSts option[value="' + 260 + '"]').prop('selected', true);
                                $('#UserTrainCompReschDate').prop("disabled", true);
                            }
                            else {
                                $('#UserTrainCompTraiSts option[value="' + 261 + '"]').prop('selected', true);
                                $('#UserTrainCompReschDate').prop("disabled", true);
                            }

                        }
                        else if (yr != Acyr) {
                            $('#UserTrainCompTraiSts option[value="' + 261 + '"]').prop('selected', true);
                            $('#UserTrainCompReschDate').prop("disabled", true);
                        }
                    }
                    else {
                        bootbox.hideAll();
                        $('#UserTrainCompTraiSts option[value="' + 0 + '"]').prop('selected', true);
                        $('#UserTrainCompReschDate').prop("disabled", false);
                        bootbox.alert("Please Enter the value for Actual Training Date or Training Reschedule Date");

                    }


                    if (ReshdateChk != "") {

                        var resdate = $('#UserTrainCompReschDate').val();
                        if (resdate == ActdateConLd) {
                            $('#UserTrainCompTraiSts option[value="' + 260 + '"]').prop('selected', true);
                        }
                        else {
                            $('#UserTrainCompTraiSts option[value="' + 261 + '"]').prop('selected', true);
                        }
                    }


                }
                else if (isResh == "true") {
                    var resdate = $('#UserTrainCompReschDate').val();
                    if (resdate == ActdateConLd) {
                        $('#UserTrainCompTraiSts option[value="' + 260 + '"]').prop('selected', true);
                    }
                    else {
                        $('#UserTrainCompTraiSts option[value="' + 261 + '"]').prop('selected', true);
                    }
                }

                if (ActdateConLd == "") {
                    $('#btnConfirmVerify').prop('disabled', true);
                }
                else {
                    $('#btnConfirmVerify').prop('disabled', false);

                    $('#UserTrainCompActDate').prop('required', true);
                    $("#lblActDate").html("Actual Date <span class='red'>*</span>");
                    //$('#UserTrainCompTraiSource').prop('required', true);
                    //$("#lblTraiSource").html("Trainer Source <span class='red'>*</span>");
                    //$('#UserTrainCompPresTrainer').prop('required', true);
                    //$("#lblPresTrainer").html("Presenter (Trainer) <span class='red'>*</span>");
                    $('#UserTrainCompVenue').prop('required', false);
                    $("#lblVenue").html("Venue");
                    var _index;
                    $('#UserTrainingGrid tr').each(function () {
                        _index = $(this).index();
                        $('#UserTrainCompParName_' + _index).prop('required', true);
                        //   $('#UserTrainCompAreaCode_' + _index).prop('required', true);
                    });

                    $("#lblGrdPart").html("Name of Participants <span class='red'>*</span>");
                    $("#lblGrdArea").html("User Area Code <span class='red'>*</span>");

                }


                var TT = parseInt($("#UserTrainCompTraiTyp").val());
                if (TT == 255) {

                    var UnPnDt = Date.parse($('#UserTrainCompActDate').val());
                    var UnPlndyr = parseInt(UnPnDt.getFullYear());
                    var UnPlndmnth = UnPnDt.getMonth() + 1;


                    if (UnPlndmnth >= 1 && UnPlndmnth <= 3) {
                        var qrtrId = 256;
                    }
                    else if (UnPlndmnth >= 4 && UnPlndmnth <= 6) {
                        var qrtrId = 257;
                    }
                    else if (UnPlndmnth >= 7 && UnPlndmnth <= 9) {
                        var qrtrId = 258;
                    }
                    else if (UnPlndmnth >= 10 && UnPlndmnth <= 12) {
                        var qrtrId = 259;
                    }
                    $('#UserTrainCompQuarter option[value="' + qrtrId + '"]').prop('selected', true);
                    $('#UserTrainCompYear').append('<option value="' + UnPlndyr + '">' + UnPlndyr + '</option>');
                    $('#UserTrainCompYear option[value="' + UnPlndyr + '"]').prop('selected', true);
                }



            });


            function chkQrtr(mnt) {
                if (mnt >= 1 && mnt <= 3) {
                    var QtrVal = 256;
                }
                else if (mnt >= 4 && mnt <= 6) {
                    var QtrVal = 257;
                }
                else if (mnt >= 7 && mnt <= 9) {
                    var QtrVal = 258;
                }
                else if (mnt >= 10 && mnt <= 12) {
                    var QtrVal = 259;
                }
                return QtrVal;
            }

            //var primaryId = $('#primaryID').val();
            //if (parseInt(primaryId) > 0) {

            //    //$('#UserTrainAddrow').show();

            //    $('#UserTrainCompActDate').prop('required', true);
            //    $("#lblActDate").html("Actual Date <span class='red'>*</span>");
            //    $('#UserTrainCompTraiSource').prop('required', true);
            //    $("#lblTraiSource").html("Trainer Source <span class='red'>*</span>");
            //    $('#UserTrainCompPresTrainer').prop('required', true);
            //    $("#lblPresTrainer").html("Presenter (Trainer) <span class='red'>*</span>");
            //    $('#UserTrainCompVenue').prop('required', true);
            //    $("#lblVenue").html("Venue <span class='red'>*</span>");
            //}

            $("#UserTrainCompReschDate").on('change', function () {
                var Resch = $('#UserTrainCompReschDate').val();
                if (Resch != "") {
                    $('#UserTrainCompTraiSts option[value="' + 262 + '"]').prop('selected', true);
                    $('#UserTrainCompActDate').prop('required', false);
                    $("#lblActDate").html("Actual Date");
                    $('#UserTrainCompActDate').prop('disabled', true);
                    //$('#UserTrainCompTraiSource').prop('required', false);
                    //$("#lblTraiSource").html("Trainer Source ");
                    //$('#UserTrainCompPresTrainer').prop('required', false);
                    //$("#lblPresTrainer").html("Presenter (Trainer) ");
                    $('#UserTrainCompVenue').prop('required', false);
                    $("#lblVenue").html("Venue");

                    var _index;
                    $('#UserTrainingGrid tr').each(function () {
                        _index = $(this).index();

                        $('#UserTrainCompParName_' + _index).prop('required', false);
                        //  $('#UserTrainCompAreaCode_' + _index).prop('required', false);
                        $("#lblGrdPart").html("Name of Participants ");
                        $("#lblGrdArea").html("User Area Code ");
                    });
                    //$('#UserTrainCompParName_' + _index).prop('required', false);
                    //$('#UserTrainCompAreaCode_' + _index).prop('required', false);
                    //$("#lblGrdPart").html("Name of Participants ");
                    //$("#lblGrdArea").html("User Area Code ");
                }
                else {
                    $('#UserTrainCompTraiSts option[value="' + 0 + '"]').prop('selected', true);
                    $('#UserTrainCompReschDate').prop("disabled", false);


                    var _index;
                    $('#UserTrainingGrid tr').each(function () {
                        _index = $(this).index();

                        $('#UserTrainCompParName_' + _index).prop('required', true);
                        //  $('#UserTrainCompAreaCode_' + _index).prop('required', true);

                    });

                    $("#lblGrdPart").html("Name of Participants <span class='red'>*</span>");
                    $("#lblGrdArea").html("User Area Code <span class='red'>*</span>");

                    $('#UserTrainCompActDate').prop('required', true);
                    $("#lblActDate").html("Actual Date <span class='red'>*</span>");
                    $('#UserTrainCompActDate').prop('disabled', false);
                    //$('#UserTrainCompTraiSource').prop('required', true);
                    //$("#lblTraiSource").html("Trainer Source <span class='red'>*</span>");
                    //$('#UserTrainCompPresTrainer').prop('required', true);
                    //$("#lblPresTrainer").html("Presenter (Trainer) <span class='red'>*</span>");
                    $('#UserTrainCompVenue').prop('required', false);
                    $("#lblVenue").html("Venue");
                }

            });

            var Actdate = $('#UserTrainCompActDate').val();

            validation();

            //var primaryId = $('#primaryID').val();
            //if (primaryId != null && primaryId != "0") {
            //    $.get("/api/UserTraining/Get/" + primaryId + "/" + pagesize + "/" + pageindex)
            //      .done(function (result) {
            //          var getResult = JSON.parse(result);

            //          GetUserTrainingBind(getResult)

            //          $('#myPleaseWait').modal('hide');
            //})
            //     .fail(function () {
            //         $('#myPleaseWait').modal('hide');
            //         $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            //         $('#errorMsg').css('visibility', 'visible');
            //});
            //}
            //else {
            //    $('#myPleaseWait').modal('hide');
            //}
        })
  .fail(function () {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
      $('#errorMsg').css('visibility', 'visible');
  });

    //****************************************** Save *********************************************

    $("#btnSave, #btnEdit,#btnSaveandAddNew").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');
        CurrentbtnID = $(this).attr("Id");
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        UserTrainCompSave();
    });

    //$('#btnConfirmVerify').click(function () {
    //    UserTrainCompSave(j);
    //    //alert("j");
    //});

    $("#chk_UserTraining").change(function () {
        var Isdeletebool = this.checked;

        if (this.checked) {
            $('#UserTrainingGrid tr').map(function (i) {
                if ($("#Isdeleted_" + i).prop("disabled")) {
                    $("#Isdeleted_" + i).prop("checked", false);
                }
                else {
                    $("#Isdeleted_" + i).prop("checked", true);
                }
            });
        } else {
            $('#UserTrainingGrid tr').map(function (i) {
                $("#Isdeleted_" + i).prop("checked", false);
            });
        }
    });

    $("#btnCancel").click(function () {
        var message = Messages.Reset_Alert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                EmptyFields();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });

    //$("#btnConfirmVerify").click(function () {
    //    var Actdate = $('#UserTrainCompActDate').val();
    //    if(Actdate == "")
    //});


    //$(".nav-tabs > li:not(:first-child)").click(function () {
    //   // var rsdate = $('#UserTrainCompActDate').val()
    //    var rsdate= $('#hdnUserTraiGrid_0').val()

    //     if (rsdate == "") {
    //           $('#errorMsg').css('visibility', 'hidden');
    //           bootbox.alert("User Training Completion Details must be saved before entering additional information");
    //           return false;
    //       }
    //});

    $(".nav-tabs > li:eq(1)").click(function () {

        var rsdate = $('#hdnUserTraiGrid_0').val()

        if (rsdate == "") {
            $('#errorMsg').css('visibility', 'hidden');
            bootbox.alert("User Training Completion Details must be saved before entering additional information");
            return false;
        }

    });

    $('#AttachmentTab').click(function () {
        var status = $('#hdnIsConfim').val();
        var statusval = $('#UserTrainCompTraiSts').val();
        
        if (statusval == 263 || statusval == "263") {
            setTimeout(function () {
                $("#CommonAttachment :input").prop("disabled", true);
                $('#btnEditAttachmentAddNew').hide();

            }, 150)
        }

        if (status == true || status == "true") {
            setTimeout(function () {
                $("#CommonAttachment :input").prop("disabled", true);
                $('#btnEditAttachmentAddNew').hide();

            }, 150)
        }
        //if (status.indexOf('Closed') != -1) {
        //    setTimeout(function () {
        //        $("#CommonAttachment :input").prop("disabled", true);
        //    }, 150)
        //}
    });

    $("#jQGridCollapse1").click(function () {
        // $(".jqContainer").toggleClass("hide_container");
        var pro = new Promise(function (res, err) {
            $(".jqContainer").toggleClass("hide_container");
            res(1);
        })
        pro.then(
            function resposes() {
                setTimeout(() => $(".content").scrollTop(3000), 1);
            })
    })

    $("#btnSaveArea").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');
        // CurrentbtnID = $(this).attr("Id");
        $("div.errormsgcenter").text("");
        $('#errorMsgAreaPop').css('visibility', 'hidden');

        var isFormValid = formInputValidation("UserTrainAreaModal", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsgAreaPop').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        Arearesult = [];
        var _index;
        $('#UserTainAreaTableGrid tr').each(function () {
            _index = $(this).index();
        });

        //var Arearesult = [];
        for (var i = 0; i <= _index; i++) {
            var _AreaGrid = {

                TrainingScheduleAreaId: $('#UserTrainCompAreaPriIdPop_' + i).val(),
                UserAreaId: $('#UserTrainCompAreaIdPop_' + i).val(),
                CompRepEmail: $('#UserTrainCompComRepEmlPop_' + i).val(),
                FacRepEmail: $('#UserTrainCompFacRepEmlPop_' + i).val(),
                UserAreaName: $('#UserTrainCompAreaPop_' + i).val(),
                CompRepName: $('#UserTrainCompComRepPop_' + i).val(),
                FacRepName: $('#UserTrainCompFacRepPop_' + i).val(),
                // IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
            }

            if (_AreaGrid.UserAreaId == "" || _AreaGrid.UserAreaId == 0 || _AreaGrid.UserAreaId == null) {
                $("div.errormsgcenter").text("Valid Area required");
                $('#errorMsgAreaPop').css('visibility', 'visible');
                $('#btnlogin').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
                return false;
            }
            Arearesult.push(_AreaGrid);
        }

        var duplicateArea = false;
        for (i = 0; i < Arearesult.length; i++) {
            var UserAreaId = Arearesult[i].UserAreaId;
            for (j = i + 1; j < Arearesult.length; j++) {
                if (UserAreaId == Arearesult[j].UserAreaId) {
                    duplicateArea = true;
                }
            }
        }

        if (duplicateArea) {
            $("div.errormsgcenter").text("Area Name should be unique.");
            $('#errorMsgAreaPop').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }


        $('#UserTrainAreaModal').hide();
        $('.modal-backdrop').fadeOut(100);
        $('#myPleaseWait').modal('hide');

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
    });


    $("#btnSaveAreaClose").click(function () {
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
    });


});

function UserTrnpopup() {
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $("#UserTraiCopmPage :input:not(:button)").parent().removeClass('has-error');
    var Poplen = Arearesult.length;



    if (Arearesult.length == 0) {
        $("#UserTainAreaTableGrid").empty();
        AddNewRowArea();
    }

    if (Arearesult.length > 0) {
        $("#UserTainAreaTableGrid").empty();

        $.each(Arearesult, function (index, value) {
            AddNewRowArea();            
            $("#UserTrainCompAreaPriIdPop_" + index).val(Arearesult[index].TrainingScheduleAreaId);
            $("#UserTrainCompAreaPop_" + index).val(Arearesult[index].UserAreaName);
            $("#UserTrainCompAreaIdPop_" + index).val(Arearesult[index].UserAreaId);
            //$("#CRMReqRemHisRemarks_" + index).attr('title', getResult.UserTrainingAreaGridData[index].Remarks);
            $("#UserTrainCompComRepPop_" + index).val(Arearesult[index].CompRepName);
            $("#UserTrainCompComRepIdPop_" + index).val(Arearesult[index].CompRepId);
            $("#UserTrainCompComRepEmlPop_" + index).val(Arearesult[index].CompRepEmail);
            $("#UserTrainCompFacRepPop_" + index).val(Arearesult[index].FacRepName);
            $("#UserTrainCompFacRepIdPop_" + index).val(Arearesult[index].FacRepId);
            $("#UserTrainCompFacRepEmlPop_" + index).val(Arearesult[index].FacRepEmail);
        });
    }

    var con = $('#hdnIsConfim').val();
    var userstatuschk = $('#UserTrainCompTraiSts').val();
    if (userstatuschk == 263)
    {
        $("#UserTraiCopmPage :input:not(:button)").prop("disabled", true);
    }
    if (con == "true")
    {
        $("#UserTraiCopmPage :input:not(:button)").prop("disabled", true);
    }
    
}


function GetUserTrainingBind(getResult) {
    $("#UserTraiCopmPage :input:not(:button)").parent().removeClass('has-error');
    $('#chk_UserTraining').prop("disabled", false);
    $('#primaryID').val(getResult.TrainingScheduleId);

    $("#hdnAttachId").val(getResult.HiddenId);

    if (getResult.TrainingStatusId != 263) {
        $("#btnDelete").show();
    }
    var primaryId = $('#primaryID').val();
    if (getResult.TrainingTypeId == 255) {
        $('#UserTrainCompNotDat').prop("disabled", true);
        $('#UserTrainCompNotDat').css("background-color", "#eee");
        $('#UserTrainCompNotDat').prop("required", false);
        $("#lblNotDat").html("Notification Date");
    }
    var curdat = new Date();
    var curdatFormat = DateFormatter(curdat);
    curdatFormat = Date.parse(curdatFormat);
    // if (getResult.TrainingTypeId == 254) {
    if (primaryId > 0) {
        SchduleSection();
        $('#UserTrainCompTraiTyp').prop("disabled", true);
        $('#UserTrainCompPresTrainer').prop('required', true);

        $('#UserTrainCompActDate').prop('required', true);
        $("#lblActDate").html("Actual Date <span class='red'>*</span>");
    }

    $('#UserTrainCompFacCde').val(getResult.Facility);
    $('#selServices option[value="' + getResult.ServiceId + '"]').prop('selected', true);

    $('#UserTrainCompTraiTyp option[value="' + getResult.TrainingTypeId + '"]').prop('selected', true);
    $('#UserTrainCompPlndDte').val(DateFormatter(getResult.PlannedDate));
    if (getResult.IsPlanedOver == 0) {
        $('#UserTrainCompNotDat').val(DateFormatter(getResult.NotificationDate)).prop('disabled', true);
    }
    else {
        $('#UserTrainCompNotDat').val(DateFormatter(getResult.NotificationDate));
    }
    $('#UserTrainCompYear').empty();
    $('#UserTrainCompYear').append('<option value="' + getResult.Year + '">' + getResult.Year + '</option>').prop('selected', true);
    //$("#UserTrainCompYear").append($("<option></option>").val(getResult.Year).html(getResult.Year)).prop('selected', true);

    $('#UserTrainCompQuarter option[value="' + getResult.Quarter + '"]').prop('selected', true);
    $('#UserTrainComptraiSchNo').val(getResult.TrainingScheduleNo);
    $('#UserTrainComptraiDesc').val(getResult.TrainingDescription);
    $('#UserTrainComptraiMod').val(getResult.Trainingmodule);
    $('#UserTrainCompMinPar').val(getResult.MinNoOfParticipants);

    $('#UserTrainCompActDate').val(DateFormatter(getResult.ActualDate));

    if (getResult.ActualDate != null) {
        $('#btnConfirmVerify').prop('disabled', false);
    }
    else {
        $('#UserTrainCompActDate').on('change', function () {
            var ActdateCon = $('#UserTrainCompActDate').val();
            if (ActdateCon == "") {
                $('#btnConfirmVerify').prop('disabled', true);
            }
            else {
                $('#btnConfirmVerify').prop('disabled', false);
            }
        });
    }

    $('#UserTrainCompTraiSts option[value="' + getResult.TrainingStatusId + '"]').prop('selected', true);
    $('#UserTrainCompTraiSource option[value="' + getResult.TrainerSource + '"]').prop('selected', true);
    if (getResult.TrainerPresenterName == "") {
        $('#UserTrainCompTraiSource').prop("disabled", false);
    }
    else {
        $('#UserTrainCompTraiSource').prop("disabled", true);
    }

    $('#UserTrainCompPresTrainer').val(getResult.TrainerPresenterName);
    if (getResult.TrainerSource == 264) {
        $('#UserTrainCompExp').val(getResult.Experience).prop("disabled", true);
        $('#UserTrainCompDesig').val(getResult.Designation).prop("disabled", true);
        $('#HdnUserTrainCompPresTrainerEmail').val(getResult.Email);
        $('#HdnUserTrainCompPresTrainerId').val(getResult.TrainerPresenter);
    }
    else {
        $('#ExtEmail').show();
        $('#UserTrainCompExp').val(getResult.Experience).prop("disabled", false);
        $('#UserTrainCompDesig').val(getResult.Designation).prop("disabled", false);
        $('#UserTrainCompEmail').val(getResult.Email);
    }
    $('#UserTrainCompTotPart').val(getResult.TotalParticipants);
    $('#UserTrainCompVenue').val(getResult.venue).prop('required', false);
    $('#UserTrainCompReschDate').val(DateFormatter(getResult.TrainingRescheduleDate));
    $('#UserTrainCompEffect').val(getResult.OverallEffectiveness);
    $('#UserTrainCompRem').val(getResult.Remarks);
    $('#Timestamp').val(getResult.Timestamp);
    $('#HdnIsRechDone').val(getResult.IsRescheduled);

    if (getResult.IsRescheduled == true) {
        $('#UserTrainCompReschDate').prop("disabled", true);

        //$('#UserTrainCompTraiSource').prop('required', true);
        //$("#lblTraiSource").html("Trainer Source <span class='red'>*</span>");
        //$('#UserTrainCompPresTrainer').prop('required', true);
        //$("#lblPresTrainer").html("Presenter (Trainer) <span class='red'>*</span>");
        $('#UserTrainCompVenue').prop('required', false);
        $("#lblVenue").html("Venue");
        $("#lblGrdPart").html("Name of Participants <span class='red'>*</span>");
        $("#lblGrdArea").html("User Area Code <span class='red'>*</span>");
        $('#UserTrainCompActDate').prop("disabled", false);
        $('#UserTrainCompActDate').prop("required", true);

    }
    $('#hdnIsConfim').val(getResult.IsConfirmed);

    $("#UserTrainingGrid").empty();

    if (getResult.UserTrainingGridData.length == 0) {
        AddNewRowUserTraining();
    }


    $.each(getResult.UserTrainingGridData, function (index, value) {
        AddNewRowUserTraining();
        $('#paginationfooter').show();
        $("#hdnUserTraiGrid_" + index).val(getResult.UserTrainingGridData[index].TrainingScheduleDetId);
        $("#hdnUserTraiParNameId_" + index).val(getResult.UserTrainingGridData[index].ParticipantId);
        $("#UserTrainCompParName_" + index).val(getResult.UserTrainingGridData[index].ParticipantName);
        $("#UserTrainCompDesig_" + index).val(getResult.UserTrainingGridData[index].Designation);
        $("#hdnUserTraiIsConfirm_" + index).val(getResult.UserTrainingGridData[index].IsConfirmed);

        //  $("#hdnUserTraiAreaId_" + index).val(getResult.UserTrainingGridData[index].UserAreaId);
        // $("#UserTrainCompAreaCode_" + index).val(getResult.UserTrainingGridData[index].UserAreaCode);
        //  $("#UserTrainCompAreaName_" + index).val(getResult.UserTrainingGridData[index].UserAreaName);

        if (getResult.IsConfirmed == true) {
            disableFields();
            disableGridFields(index, null);
            $("#btnDelete").hide();
            $('#btnSaveFeedBk').hide();
            $('#UserTrainAddrow').hide();
        }

        if (getResult.TrainingStatusId == 263) {
            disableFields();
            disableGridFields(index, null);
        }
       // linkclicked1 = true;
    });

    if (getResult.IsConfirmed == false) {
        $('#UserTrainAddrow').show();
        $('#btnSaveandAddNew').show();
        $('#btnConfirmVerify').show();

    }

    if (ActionType == "VIEW") {
        $("#UserTraiCopmPage :input:not(:button)").prop("disabled", true);
    }

    if (getResult.TrainingStatusId == 263) {
        disableFields();
    }

    if ((getResult.UserTrainingGridData && getResult.UserTrainingGridData.length) > 0) {

        var CatSystemId = 0;
        if ((getResult.UserTrainingGridData && getResult.UserTrainingGridData.length) > 0) {
            TrainingScheduleId = getResult.UserTrainingGridData[0].TrainingScheduleId;
            GridtotalRecords = getResult.UserTrainingGridData[0].TotalRecords;
            TotalPages = getResult.UserTrainingGridData[0].TotalPages;
            LastRecord = getResult.UserTrainingGridData[0].LastRecord;
            FirstRecord = getResult.UserTrainingGridData[0].FirstRecord;
            pageindex = getResult.UserTrainingGridData[0].PageIndex;
        }

        var mapIdproperty = ["IsDeleted-Isdeleted_", "TrainingScheduleDetId-hdnUserTraiGrid_", "ParticipantId-hdnUserTraiParNameId_", "ParticipantName-UserTrainCompParName_", "Designation-UserTrainCompDesig_"];
        var htmltext = AddNewRowUserTrainingHtml();//Inline Html
        var obj = { formId: "#UserTraiCopmPage", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "Usertrainingdetails", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "UserTrainingGridData", tableid: '#UserTrainingGrid', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/UserTraining/Get/" + primaryId, pageindex: pageindex, pagesize: pagesize };

        CreateFooterPagination(obj)
    }

    $("#UserTainAreaTableGrid").empty();
    $.each(getResult.UserTrainingAreaGridData, function (index, value) {
        Arearesult = [];
        Arearesult = getResult.UserTrainingAreaGridData;
        AddNewRowArea();
        $("#UserTrainCompAreaPriIdPop_" + index).val(getResult.UserTrainingAreaGridData[index].TrainingScheduleAreaId);
        $("#UserTrainCompAreaPop_" + index).val(getResult.UserTrainingAreaGridData[index].UserAreaName);
        $("#UserTrainCompAreaIdPop_" + index).val(getResult.UserTrainingAreaGridData[index].UserAreaId);
        //$("#CRMReqRemHisRemarks_" + index).attr('title', getResult.UserTrainingAreaGridData[index].Remarks);
        $("#UserTrainCompComRepPop_" + index).val(getResult.UserTrainingAreaGridData[index].CompRepName);
        $("#UserTrainCompComRepIdPop_" + index).val(getResult.UserTrainingAreaGridData[index].CompRepId);
        $("#UserTrainCompComRepEmlPop_" + index).val(getResult.UserTrainingAreaGridData[index].CompRepEmail);
        $("#UserTrainCompFacRepPop_" + index).val(getResult.UserTrainingAreaGridData[index].FacRepName);
        $("#UserTrainCompFacRepIdPop_" + index).val(getResult.UserTrainingAreaGridData[index].FacRepId);
        $("#UserTrainCompFacRepEmlPop_" + index).val(getResult.UserTrainingAreaGridData[index].FacRepEmail);

        if (getResult.TrainingStatusId == 263) {
            disableGridFieldsArea(index, null);
            $('#UserTrainAddrowArea').hide();
            $('#btnSaveArea').hide();
        }
        if (getResult.IsConfirmed == true) {
            disableGridFieldsArea(index, null);
            $('#UserTrainAddrowArea').hide();
            $('#btnSaveArea').hide();
        }
    });

    if (getResult.TrainingStatusId == 263) {
        $("#btnDelete").hide();
    }

    if (getResult.IsConfirmed == true) {
        $('#UserTrainAddrow').hide();
    }

}

function Confirm() {
    //bootbox.confirm("Sorry!. You cannot delete all rows", function (result) {
    //    if (result) {
    //var isConfirmed = true;
    var object = { IsConfirmed: true }
    UserTrainingConfirmSave(object);
    //    }
    //    else {
    //        $('#myPleaseWait').modal('hide');
    //    }
    //});
}

function AddNewRow() {
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $("#chk_UserTraining").prop("checked", false)
    var rowCount = $('#UserTrainingGrid tr:last').index();
    var ParticiName = $('#UserTrainCompParName_' + rowCount).val();
    // var UsrArea = $('#UserTrainCompAreaCode_' + rowCount).val();
    if (rowCount < 0)
        AddNewRowUserTraining();
    else if (rowCount >= "0" && (ParticiName == "")) {
        bootbox.alert("Please enter values in existing row");
        //  $("div.errormsgcenter1").text();
        // $('#errorMsg1').css('visibility', 'visible');
    }
    else {
        AddNewRowUserTraining();
    }
}
var linkclicked1 = false;
function AddNewRowUserTraining() {

    var inputpar = {
        inlineHTML: AddNewRowUserTrainingHtml(),
        IdPlaceholderused: "maxindexval",
        TargetId: "#UserTrainingGrid",
        TargetElement: ["tr"]
    }

    AddNewRowToDataGrid(inputpar);
    var len = 0
    var resDone = $('#HdnIsRechDone').val();
    var resDate = $('#UserTrainCompReschDate').val();
    if (resDone == "false") {
        if (resDate != "") {
            var rowCount = $('#UserTrainingGrid tr:last').index();
            $('#UserTrainCompParName_' + rowCount).prop('required', false);
            //$('#UserTrainCompAreaCode_' + rowCount).prop('required', false);
            //if (!linkCliked1) {
                $('#UserTrainCompParName_' + rowCount).focus();
           // }
           // else {
             //   linkCliked1 = false;
           // }
        }
        else {
            var rowCount = $('#UserTrainingGrid tr:last').index();
            $('#UserTrainCompParName_' + rowCount).prop('required', true);
            // $('#UserTrainCompAreaCode_' + rowCount).prop('required', true);
          //  if (!linkCliked1) {
                $('#UserTrainCompParName_' + rowCount).focus();
         //   }
           // else {
             //   linkCliked1 = false;
           // }
        }
    }
    formInputValidation("UserTraiCopmPage");
}

function AddNewRowUserTrainingHtml() {

    return ' <tr class="ng-scope" style=""><td width="5%" title=""><div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" id="Isdeleted_maxindexval" value="false" autocomplete="off" onchange="IsDeleteCheckAll(UserTrainingGrid,chk_UserTraining)" class="ng-pristine ng-untouched ng-valid"> </label></div> \
                <input type="hidden" width="0%" id="hdnUserTraiGrid_maxindexval"></td> \
                <td width="55%" style="text-align:left;" title=""><div> <input type="text" id="UserTrainCompParName_maxindexval" class="form-control" placeholder="Please Select" autocomplete="off" onkeyup="FetchParticipant(event,maxindexval)" onpaste="FetchParticipant(event,maxindexval)" change="FetchParticipant(event,maxindexval)" oninput="FetchParticipant(UserTrainCompParName_maxindexval,maxindexval)" required></div> \
                    <input type="hidden" id="hdnUserTraiParNameId_maxindexval"/> <div class="col-sm-12" id="divPartFetch_maxindexval"></div> </td> \
                <td width="40%" style="text-align: left;" title=""><div> <input type="text" id="UserTrainCompDesig_maxindexval" class="form-control" autocomplete="off" disabled></div> <input type="hidden" width="0%" id="hdnUserTraiIsConfirm_maxindexval"></td> \
                </tr>'
}

function AddNewRowArea() {
    $("div.errormsgcenter").text("");
    $('#errorMsgAreaPop').css('visibility', 'hidden');

    var rowCount = $('#UserTainAreaTableGrid tr:last').index();
    var ParticiName = $('#UserTrainCompAreaPop_' + rowCount).val();
    if (rowCount < 0)
        AddNewRowUserTrainingArea();
    else if (rowCount >= "0" && (ParticiName == "")) {
        bootbox.alert("Please enter values in existing row");
        //  $("div.errormsgcenter1").text();
        // $('#errorMsg1').css('visibility', 'visible');
    }
    else {
        AddNewRowUserTrainingArea();
    }
}

function AddNewRowUserTrainingArea() {

    var inputpar = {
        inlineHTML: AddNewRowUserTrainingAreaHtml(),
        IdPlaceholderused: "maxindexval",
        TargetId: "#UserTainAreaTableGrid",
        TargetElement: ["tr"]
    }

    AddNewRowToDataGrid(inputpar);
    var len = 0
    //var resDone = $('#HdnIsRechDone').val();
    //var resDate = $('#UserTrainCompReschDate').val();
    //if (resDone == "false") {
    //    if (resDate != "") {
    //        var rowCount = $('#UserTrainingGrid tr:last').index();
    //        $('#UserTrainCompParName_' + rowCount).prop('required', false);
    //        $('#UserTrainCompAreaCode_' + rowCount).prop('required', false);
    //        $('#UserTrainCompParName_' + rowCount).focus();
    //    }
    //    else {
    //        var rowCount = $('#UserTrainingGrid tr:last').index();
    //        $('#UserTrainCompParName_' + rowCount).prop('required', true);
    //        $('#UserTrainCompAreaCode_' + rowCount).prop('required', true);
    //        $('#UserTrainCompParName_' + rowCount).focus();
    //    }
    //}

    var rowCount = $('#UserTainAreaTableGrid tr:last').index();
    $('#UserTrainCompAreaPop_' + rowCount).focus();
    formInputValidation("UserTraiCopmPage");
}

function AddNewRowUserTrainingAreaHtml() {

    return ' <tr class="ng-scope" style=""> <td width="40%" style="text-align:left;" title=""><div>  <input type="hidden" id="UserTrainCompAreaPriIdPop_maxindexval"/> \
                <input type="text" id="UserTrainCompAreaPop_maxindexval" class="form-control" placeholder="Please Select" autocomplete="off" onkeyup="FetchAreaCodePop(event,maxindexval)" onpaste="FetchAreaCodePop(event,maxindexval)" change="FetchAreaCodePop(event,maxindexval)" oninput="FetchAreaCodePop(UserTrainCompParName_maxindexval,maxindexval)" required></div> \
                    <input type="hidden" id="UserTrainCompAreaIdPop_maxindexval"/> <div class="col-sm-12" id="divAreaFetchPop_maxindexval"></div> </td> \
                <td width="30%" style="text-align: left;" title=""><div> <input type="text" id="UserTrainCompComRepPop_maxindexval" class="form-control" autocomplete="off" disabled></div> <input type="hidden" id="UserTrainCompComRepIdPop_maxindexval"/>  <input type="hidden" id="UserTrainCompComRepEmlPop_maxindexval"/> </td> \
                <td width="30%" style="text-align: left;" title=""><div> <input type="text" id="UserTrainCompFacRepPop_maxindexval" class="form-control" autocomplete="off" disabled></div> <input type="hidden" id="UserTrainCompFacRepIdPop_maxindexval"/>  <input type="hidden" id="UserTrainCompFacRepEmlPop_maxindexval"/> </td> \
                 </tr>'
}


function FetchTrainer(event) {    // Commonly using CompanyStaffFetch
    var ItemMst = {
        SearchColumn: 'UserTrainCompPresTrainer' + '-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId" + "-Primary Key", 'StaffName' + '-UserTrainCompPresTrainer', 'Designation' + '-UserTrainCompDesig', 'Experience' + '-UserTrainCompExp'],//Columns to be displayed
        FieldsToBeFilled: ["HdnUserTrainCompPresTrainerId" + "-StaffMasterId", 'UserTrainCompPresTrainer' + '-StaffName', 'UserTrainCompDesig' + '-Designation', 'UserTrainCompExp' + '-Experience', 'HdnUserTrainCompPresTrainerEmail' + '-Email']//id of element - the model property
    };
    DisplayFetchResult('CompStfFetch', ItemMst, "/api/Fetch/CompanyStaffFetch", "Ulfetch", event, 1);
}

function FetchParticipant(event, index) {    // Commonly using CompanyStaffFetch
    var primaryId = $('#primaryID').val();
    if (index > 0) {
        if ($('#divPartFetch_' + index + ' .not-found').length) {
            $('#divPartFetch_' + index).css({
                //'top': 0,
                'width': $('#UserTrainCompParName_' + index).outerWidth()
            });
        } else {
            $('#divPartFetch_' + index).css({
                'top': $('#UserTrainCompParName_' + index).offset().top - $('#UserTrainingTable').offset().top + $('#UserTrainCompParName_' + index).innerHeight(),
                'width': $('#UserTrainCompParName_' + index).outerWidth()
            });
        }
    }
    else {
        $('#divPartFetch_' + index).css({
            'width': $('#UserTrainCompParName_' + index).outerWidth()
        });
    }

    var ItemMst = {
        SearchColumn: 'UserTrainCompParName_' + index + '-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId" + "-Primary Key", 'StaffName' + '-UserTrainCompParName_' + index],//Columns to be displayed
        AdditionalConditions: ["TrainingScheduleId-primaryID", ],
        FieldsToBeFilled: ["hdnUserTraiParNameId_" + index + "-StaffMasterId", 'UserTrainCompParName_' + index + '-StaffName', 'UserTrainCompDesig_' + index + '-Designation']//id of element - the model property
    };
    DisplayFetchResult('divPartFetch_' + index, ItemMst, "/api/Fetch/UserTainingParticipantFetch", "Ulfetch1" + index, event, 1);
}

//function FetchAreaCode(event, index) {

//    if (index > 0) {
//        if ($('#divAreaFetch_' + index + ' .not-found').length) {
//            $('#divAreaFetch_' + index).css({
//                'top': 0,
//                 'width': $('#UserTrainCompAreaCode_' + index).outerWidth()
//            });
//        } else {
//            $('#divAreaFetch_' + index).css({
//                'top': $('#UserTrainCompAreaCode_' + index).offset().top - $('#UserTrainingTable').offset().top + $('#UserTrainCompAreaCode_' + index).innerHeight(),
//                'width': $('#UserTrainCompAreaCode_' + index).outerWidth()
//            });
//        }
//    }
//    else {
//        $('#divAreaFetch_' + index).css({
//            'width': $('#UserTrainCompAreaCode_' + index).outerWidth()
//        });
//    }

//    //var ItemMst = {
//    //    SearchColumn: 'UserTrainCompAreaCode' + '-UserAreaName',//Id of Fetch field
//    //    ResultColumns: ["UserAreaId" + "-Primary Key", 'UserAreaCode' + '-UserTrainCompAreaName', 'UserAreaName' + '-UserTrainCompAreaName'],//Columns to be displayed
//    //    FieldsToBeFilled: ["hdnUserTraiAreaId" + "-UserAreaId", 'UserTrainCompAreaCode' + '-UserAreaName', 'UserTrainCompAreaRep' + '-UserAreaName']//id of element - the model property
//    //};
//    //DisplayFetchResult('divAreaFetch', ItemMst, "/api/Fetch/UserAreaFetch", "Ulfetch2" + index, event, 1);
//    var ItemMst = {
//        SearchColumn: 'UserTrainCompAreaCode_' + index + '-UserAreaCode',//Id of Fetch field
//        ResultColumns: ["UserAreaId" + "-Primary Key", 'UserAreaId' + '-hdnUserTraiAreaId_' + index, 'UserAreaCode' + '-UserTrainCompAreaCode_' + index, 'UserAreaName' + '-UserTrainCompAreaName_' + index, ],//Columns to be displayed
//        FieldsToBeFilled: ["hdnUserTraiAreaId_" + index + "-UserAreaId", 'UserTrainCompAreaCode_' + index + '-UserAreaCode', 'UserTrainCompAreaName_' + index + '-UserAreaName']//id of element - the model property
//    };
//    DisplayFetchResult('divAreaFetch_' + index, ItemMst, "/api/Fetch/UserAreaFetch", "Ulfetch2" + index, event, 1);
//}

function FetchAreaCodePop(event, index) {

    if (index > 0) {
        if ($('#divAreaFetchPop_' + index + ' .not-found').length) {
            $('#divAreaFetchPop_' + index).css({
               // 'top': 0,
                'width': $('#UserTrainCompAreaPop_0').outerWidth()
            });
        } else {
            $('#divAreaFetchPop_' + index).css({
                'top': $('#UserTrainCompAreaPop_' + index).offset().top - $('#UserTainAreaTable').offset().top + $('#UserTrainCompAreaPop_' + index).innerHeight(),
                'width': $('UserTrainCompAreaPop_0').outerWidth()
            });
        }
    }
    else {
        $('#divAreaFetchPop_' + index).css({
            'width': $('#UserTrainCompAreaPop_0').outerWidth()
        });
    }

    var ItemMst = {
        SearchColumn: 'UserTrainCompAreaPop_' + index + '-UserAreaCode',//Id of Fetch field
        ResultColumns: ["UserAreaId" + "-Primary Key", 'UserAreaCode' + '-UserTrainCompAreaPop_' + index, 'UserAreaName' + '-UserTrainCompAreaPop_' + index, ],//Columns to be displayed
        FieldsToBeFilled: ["UserTrainCompAreaIdPop_" + index + "-UserAreaId", 'UserTrainCompAreaPop_' + index + '-UserAreaName', 'UserTrainCompComRepPop_' + index + '-CompRep', 'UserTrainCompComRepIdPop_' + index + '-CompRepId', 'UserTrainCompComRepEmlPop_' + index + '-CompRepEmail', 'UserTrainCompFacRepPop_' + index + '-FacRep', 'UserTrainCompFacRepIdPop_' + index + '-FacRepId', 'UserTrainCompFacRepEmlPop_' + index + '-FacRepEmail', ]//id of element - the model property
    };
    DisplayFetchResult('divAreaFetchPop_' + index, ItemMst, "/api/Fetch/UserAreaFetch", "Ulfetch3" + index, event, 1);
}



function validation() {
    $('.desc').on('input paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^&*_+|\\:{}\[\];?<>/\^]/g, ''));
        }, 5);
    });

    $('.digOnly').on('input paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[a-zA-Z~`!@#$%^&*_+|\\:{}\[\];-?<>\^\"\']/g, ''));
        }, 5);
    });
    $('.dig0nly').keypress(function (e) {
        if ((e.charCode < 48 || e.charCode > 57) && (e.charCode != 32) && (e.charCode != 0)) return false;
    });

    $('.name').on('paste input', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^&*_+=;:"',.|\\{}\[\]?<>\^]/g, ''));
        }, 5);
    });

    $('.ven').on('paste input', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^&*_+=;"'.|\\{}\[\]?<>\^]/g, ''));
        }, 5);
    });

    //$('.digOnly').each(function (index) {
    //    $(this).attr('id', 'UserTrainCompExp');
    //    var vrate = document.getElementById(this.id);
    //    vrate.addEventListener('input', function (prev) {
    //        return function (evt) {
    //            if ((!/^\d{0,8}(?:\.\d{0,2})?$/.test(this.value))) {
    //                this.value = prev;
    //            }
    //            else {
    //                prev = this.value;
    //            }
    //        };
    //    }(vrate.value), false);
    //});

}

function SchduleSection() {
    $('#UserTrainCompPlndDte').prop("disabled", true);
    //$('#UserTrainCompTraiTyp').prop("disabled", true);
    //$('#UserTrainComptraiDesc').prop("disabled", true);
    //$('#UserTrainComptraiMod').prop("disabled", true);
    $('#UserTrainCompMinPar').prop("disabled", false);
}

function completionSection() {
    $('#UserTrainCompPlndDte').prop("disabled", false);
    $('#UserTrainCompTraiTyp').prop("disabled", false);
    $('#UserTrainComptraiDesc').prop("disabled", false);
    $('#UserTrainComptraiMod').prop("disabled", false);
    $('#UserTrainCompMinPar').prop("disabled", false);
    // $('#UserTrainCompTraiTyp').prop("disabled", false);
}

function unplanedReq() {
    $('#UserTrainCompPlndDte').prop('required', false);
    $("#lblPlndDte").html("Planned Date");
    //$('#UserTrainComptraiDesc').prop('required', false);
    //$("#lbltraiDesc").html("Training Description ");
    //$('#UserTrainComptraiMod').prop('required', false);
    //$("#lbltraiMod").html("Training Module ");
    $('#UserTrainCompMinPar').prop('required', true);
    $("#lblMinPar").html("Minimum No. of Participants");
}

function planedReq() {
    $('#UserTrainCompPlndDte').prop('required', true);
    $("#lblPlndDte").html("Planned Date <span class='red'>*</span>");
    $('#UserTrainComptraiDesc').prop('required', true);
    $("#lbltraiDesc").html("Training Description <span class='red'>*</span>");
    $('#UserTrainComptraiMod').prop('required', true);
    $("#lbltraiMod").html("Training Module <span class='red'>*</span>");
    $('#UserTrainCompMinPar').prop('required', true);
    $("#lblMinPar").html("Minimum No. of Participants <span class='red'>*</span>");
}

function UserTraiCompTab() {

    var primaryId = $('#primaryID').val();
    $('#hdnUserTraiGrid_0').val('');
    if (primaryId != null && primaryId != "0" && primaryId != "") {
        $.get("/api/UserTraining/Get/" + primaryId + "/" + pagesize + "/" + pageindex)
          .done(function (result) {
              var getResult = JSON.parse(result);

              GetUserTrainingBind(getResult)

              $('#myPleaseWait').modal('hide');
          })
         .fail(function () {
             $('#myPleaseWait').modal('hide');
             $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
             $('#errorMsg').css('visibility', 'visible');
         });
    }
}







function UserTrainCompSave() {

    var _index;
    $('#UserTrainingGrid tr').each(function () {
        _index = $(this).index();
    });

    var TrainingScheduleId = $('#primaryID').val();
    var typeOfServiceReq = $('#selServices option:selected').val();
    var notiDate = $('#UserTrainCompNotDat').val();
    var traintyp = $('#UserTrainCompTraiTyp option:selected').val();
    var plndDte = $('#UserTrainCompPlndDte').val();
    var year = $('#UserTrainCompYear option:selected').text();
    var quarter = $('#UserTrainCompQuarter').val();
    var traiSchNo = $('#UserTrainComptraiSchNo').val();
    var traiDesc = $('#UserTrainComptraiDesc').val();
    var traiModule = $('#UserTrainComptraiMod').val();
    var MinPar = $('#UserTrainCompMinPar').val();

    var Actdate = $('#UserTrainCompActDate').val();
    var TraiSts = $('#UserTrainCompTraiSts option:selected').val();
    var ServiceReq = $('#selServices option:selected').val();
    var TraiSrc = $('#UserTrainCompTraiSource option:selected').val();
    var trainer = $('#UserTrainCompPresTrainer').val();
    var trainerid = $('#HdnUserTrainCompPresTrainerId').val();
    var exp = $('#UserTrainCompExp').val();
    var desig = $('#UserTrainCompDesig').val();

    if (TraiSrc == 265) {
        var email = $('#UserTrainCompEmail').val();
    }
    else if (TraiSrc == 264) {
        var email = $('#HdnUserTrainCompPresTrainerEmail').val();
    }

    var totPart = $('#UserTrainCompTotPart').val();
    var venue = $('#UserTrainCompVenue').val();
    var Rescdate = $('#UserTrainCompReschDate').val();
    var Traieff = $('#UserTrainCompEffect').val();
    var remarks = $("#UserTrainCompRem").val();
    var isRechDone = $("#HdnIsRechDone").val();
    //parseFloat(val);
    var timeStamp = $("#Timestamp").val();

    var result = [];
    if (traintyp == 254 && TrainingScheduleId == "0") {

    }
    else {
        for (var i = 0; i <= _index; i++) {
            var _UserTrainingGrid = {
                TrainingScheduleDetId: $('#hdnUserTraiGrid_' + i).val(),
                ParticipantId: $('#hdnUserTraiParNameId_' + i).val(),
                //UserAreaId: $('#hdnUserTraiAreaId_' + i).val(),
                ParticipantName: $('#UserTrainCompParName_' + i).val(),
                IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
            }

            //var isFormValid = formInputValidation("UserTraiCopmPage", 'save');
            //if (!isFormValid) {
            //    $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            //    $('#errorMsg').css('visibility', 'visible');

            //    $('#btnlogin').attr('disabled', false);
            //    $('#myPleaseWait').modal('hide');
            //    return false;
            //}


            //if (Rescdate == "") {
            //    if (_UserTrainingGrid.ParticipantId == "" && _UserTrainingGrid.ParticipantName != "" && _UserTrainingGrid.IsDeleted == false) {
            //        $("div.errormsgcenter").text("Valid Participants required.");
            //        $('#errorMsg').css('visibility', 'visible');
            //        $('#myPleaseWait').modal('hide');
            //        return false;
            //    }
                result.push(_UserTrainingGrid);
            //}

            //if (isRechDone == "true") {
            //    if (_UserTrainingGrid.ParticipantId == "" && _UserTrainingGrid.ParticipantName != "" && _UserTrainingGrid.IsDeleted == false) {
            //        $("div.errormsgcenter").text("Valid Participants required.");
            //        $('#errorMsg').css('visibility', 'visible');
            //        $('#myPleaseWait').modal('hide');
            //        return false;
            //    }
            //    result.push(_UserTrainingGrid);
           // }
        }
    }

    var duplicates = false;
    for (i = 0; i < result.length; i++) {
        var participantId = result[i].ParticipantId;
        for (j = i + 1; j < result.length; j++) {
            if (participantId == result[j].ParticipantId) {
                duplicates = true;
            }
        }
    }

    if (duplicates) {
        $("div.errormsgcenter").text("Name of Participants should be unique.");
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        return false;
    }

    function chkIsDeletedRow(i, delrec) {
        if (delrec == true) {
            $('#UserTrainCompParName_' + i).prop("required", false);
            // $('#UserTrainCompAreaCode_' + i).prop("required", false);
            return true;
        }
        else {
            return false;
        }
    }

    var isFormValid = formInputValidation("UserTraiCopmPage", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');

        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }

    if (traiDesc != "" && traiModule != "") {
        if (MinPar != "" && MinPar == 0) {
            $("div.errormsgcenter").text("Minimum No. Of Participants should be greater than zero.");
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }

    }


    //var CompareActDat = new Date($('#UserTrainCompActDate').val());
    //var ComparePlnDat = new Date($('#UserTrainCompPlndDte').val());
    //var CompareRchDat = new Date($('#UserTrainCompReschDate').val());

    var CompareActDat = Date.parse($('#UserTrainCompActDate').val());
    var ComparePlnDat = Date.parse($('#UserTrainCompPlndDte').val());
    var CompareRchDat = Date.parse($('#UserTrainCompReschDate').val());

    var date = Date.parse($('#UserTrainCompPlndDte').val());
    var NotifiyDat = Date.parse($('#UserTrainCompNotDat').val());


    var CompareRchDatFormatd = DateFormatter(CompareRchDat);
    var curdate = new Date();

    var curdateFormatd = DateFormatter(curdate);
    curdateFormatd = Date.parse(curdateFormatd);

    // var newdate = Date.parse(curdate);
    var Id = $("#primaryID").val();
    if (Id == 0 || Id == null || Id == "") {
        if (date != null && date != "" && date != undefined) {
            if (ComparePlnDat < curdateFormatd) {
                $("div.errormsgcenter").text("Planned Date must be greater than or equal to Current Date");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }
    }

    // if (Id == 0 || Id == null || Id == "") {
    //if (curdateFormatd <= ComparePlnDat) {
    //    if (NotifiyDat != null && NotifiyDat != "" && NotifiyDat != undefined) {
    //        if (NotifiyDat > ComparePlnDat) {
    //            $("div.errormsgcenter").text("Notofication Date must be Lesser than or equal to Planned Date");
    //            $('#errorMsg').css('visibility', 'visible');
    //            $('#myPleaseWait').modal('hide');
    //            return false;
    //        }
    //    }
    //  }
    // }

    if (traintyp == 254) {
        var today = GetCurrentDate();
        var Currentdate = Date.parse(today);
        if ((CompareActDat != null) && (CompareActDat > Currentdate)) {
            $("div.errormsgcenter").text(" 'Invalid Date'- Actual Date must be Lesser than or equal to Current Date");
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }
    }

    if (CompareRchDat != null) {
        var rchyr = CompareRchDat.getFullYear();
        var rchmnth = CompareRchDat.getMonth() + 1;
    }
    if (ComparePlnDat != null) {
        var plnyr = ComparePlnDat.getFullYear();
        var plnmnth = ComparePlnDat.getMonth() + 1;
    }

    //var rchyr = CompareRchDat.getFullYear();
    //var rchmnth = CompareRchDat.getMonth() + 1;
    //var plnyr = ComparePlnDat.getFullYear();
    //var plnmnth = ComparePlnDat.getMonth() + 1;


    if (TrainingScheduleId > 0) {
        if (CompareRchDat >= curdate) {
            if (plnyr == rchyr) {
                if (plnmnth != rchmnth) {
                    $("div.errormsgcenter").text("Reschedule Date should be within the planned month");
                    $('#errorMsg').css('visibility', 'visible');
                    $('#myPleaseWait').modal('hide');
                    return false;
                }
            }
            else if ((!isNaN(CompareRchDat)) && (CompareRchDat != "")) {
                $("div.errormsgcenter").text("Reschedule Date should be within the planned month");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }
        else if (CompareRchDatFormatd != "") {
            if (CompareRchDatFormatd < curdateFormatd) {
                $("div.errormsgcenter").text("Reschedule Date should be greater than or equal to Current Date");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }

    }

    if (Actdate != "") {
        //var TotalPages = 1;
        var deletedCount = Enumerable.From(result).Where(x=>x.IsDeleted).Count();
        var Isdeleteavailable = deletedCount > 0;
        if (deletedCount == result.length && (TotalPages == 1 || TotalPages == 0)) {
            bootbox.alert("Sorry!. You cannot delete all rows");
            $('#myPleaseWait').modal('hide');
            return false;
        }
    }

    var primaryId = $("#primaryID").val();
    if (primaryId == 0 && traintyp == 254) {
        $('#UserTrainCompParName_0').removeAttr('required');
        //  $('#UserTrainCompAreaCode_0').removeAttr('required');
    }

    var isFormValid = formInputValidation("UserTraiCopmPage", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');

        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }

    if (curdateFormatd <= ComparePlnDat) {
        if (NotifiyDat != null && NotifiyDat != "" && NotifiyDat != undefined) {
            if (NotifiyDat > ComparePlnDat) {
                $("div.errormsgcenter").text("Notofication Date must be Lesser than or equal to Planned Date");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }
    }

    if (Rescdate == "" || isRechDone == "true") {
        if (TraiSrc == 264 && trainerid == "") {
            $("div.errormsgcenter").text("Valid Presenter (Trainer) required");
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }
    }

    var Notdate = Date.parse($('#UserTrainCompNotDat').val());

    if (TrainingScheduleId == 0 && traintyp == 254 && notiDate != "") {
        if (Notdate < curdateFormatd) {
            $("div.errormsgcenter").text("Notification Date must be greater than or equal to Current Date");
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }
    }


    var primaryId = $("#primaryID").val();
    if (primaryId != null) {
        usertraingid = primaryId;
        timeStamp = timeStamp;
    }
    else {
        usertraingid = 0;
        timeStamp = "";
    }

    var obj = {

        TrainingScheduleId: usertraingid,
        ServiceId: typeOfServiceReq,
        NotificationDate: notiDate,
        TrainingTypeId: traintyp,
        PlannedDate: plndDte,
        Quarter: quarter,
        selServices: ServiceReq,
        Year: year,
        TrainingScheduleNo: traiSchNo,
        TrainingDescription: traiDesc,
        Trainingmodule: traiModule,
        MinNoOfParticipants: MinPar,
        Email: email,
        ActualDate: Actdate,
        TrainingStatusId: TraiSts,
        TrainerSource: TraiSrc,
        TrainerPresenterName: trainer,
        TrainerPresenter: trainerid,
        Experience: exp,
        Designation: desig,
        TotalParticipants: totPart,
        venue: venue,
        TrainingRescheduleDate: Rescdate,
        OverallEffectiveness: Traieff,
        Remarks: remarks,
        UserTrainingGridData: result,
        UserTrainingAreaGridData: Arearesult,
        Timestamp: timeStamp
    }

    if (obj.UserTrainingAreaGridData.length == 0) {
        $("div.errormsgcenter").text("Please save \"Area Name\" before proceeding");
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        return false;
    }

    //if (primaryId == 0 && traintyp == 254) {
    //    $('#UserTrainCompParName_0').removeAttr('required');
    //    $('#UserTrainCompAreaCode_0').removeAttr('required');
    //}

    //var isFormValid = formInputValidation("UserTraiCopmPage", 'save');
    //if (!isFormValid) {
    //    $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
    //    $('#errorMsg').css('visibility', 'visible');

    //    $('#btnlogin').attr('disabled', false);
    //    $('#myPleaseWait').modal('hide');
    //    return false;
    //}


    if (Isdeleteavailable == true) {
        bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (result) {
            if (result) {
                SaveUserTraiComp(obj);
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    }
    else {
        SaveUserTraiComp(obj);
    }

    function SaveUserTraiComp(obj) {
        var jqxhr = $.post("/api/UserTraining/Save", obj, function (response) {
            var result = JSON.parse(response);
            GetUserTrainingBind(result);

            $("#chk_UserTraining").prop("checked", false);
            $("#primaryID").val(result.TrainingScheduleId);
            $("#Timestamp").val(result.Timestamp);
            if (result.TrainingTypeId == 254) {
                $('#UserTrainAddrow').show();
            }
            $('#TrainingCompSection').css('visibility', 'visible');
            $('#TrainingCompSection').show();
            SchduleSection();
            $('#UserTrainCompTraiTyp').prop("disabled", true);
            if (result.TrainingScheduleId != 0) {
                $('#LevelCode').prop('disabled', true);
                $('#btnNextScreenSave').show();
                $('#btnEdit').show();
                $('#btnSave').hide();
                $('#btnDelete').show();
            }

            $(".content").scrollTop(0);
            showMessage('User Training', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            $("#grid").trigger('reloadGrid');
            if (CurrentbtnID == "btnSaveandAddNew") {
                EmptyFields();
            }
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
            $('#errorMsg').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });

    }



}


function UserTrainingConfirmSave(object) {

    var deletedCount;
    var _index;
    $('#UserTrainingGrid tr').each(function () {
        _index = $(this).index();
    });

    var TrainingScheduleId = $('#primaryID').val();
    var typeOfServiceReq = $('#selServices option:selected').val();
    var notiDate = $('#UserTrainCompNotDat').val();
    var traintyp = $('#UserTrainCompTraiTyp option:selected').val();
    var plndDte = $('#UserTrainCompPlndDte').val();
    var year = $('#UserTrainCompYear option:selected').text();
    var quarter = $('#UserTrainCompQuarter').val();
    var traiSchNo = $('#UserTrainComptraiSchNo').val();
    var traiDesc = $('#UserTrainComptraiDesc').val();
    var traiModule = $('#UserTrainComptraiMod').val();
    var MinPar = $('#UserTrainCompMinPar').val();
    var Actdate = $('#UserTrainCompActDate').val();
    var TraiSts = $('#UserTrainCompTraiSts option:selected').val();
    var TraiSrc = $('#UserTrainCompTraiSource option:selected').val();
    var trainer = $('#UserTrainCompPresTrainer').val();
    var trainerid = $('#HdnUserTrainCompPresTrainerId').val();
    var ServiceReq = $('#selServices option:selected').val();

    if (TraiSrc == 265) {
        var email = $('#UserTrainCompEmail').val();
    }
    else if (TraiSrc == 264) {
        var email = $('#HdnUserTrainCompPresTrainerEmail').val();
    }

    var exp = $('#UserTrainCompExp').val();
    var desig = $('#UserTrainCompDesig').val();
    var totPart = $('#UserTrainCompTotPart').val();
    var venue = $('#UserTrainCompVenue').val();
    var Rescdate = $('#UserTrainCompReschDate').val();
    var Traieff = $('#UserTrainCompEffect').val();
    var remarks = $("#UserTrainCompRem").val();
    var isRechDone = $("#HdnIsRechDone").val();


    var timeStamp = $("#Timestamp").val();

    var result = [];
    if (traintyp == 254 && TrainingScheduleId == "0") {

    }
    else {
        for (var i = 0; i <= _index; i++) {
            var _UserTrainingGrid = {
                TrainingScheduleDetId: $('#hdnUserTraiGrid_' + i).val(),
                ParticipantId: $('#hdnUserTraiParNameId_' + i).val(),
                //  UserAreaId: $('#hdnUserTraiAreaId_' + i).val(),
                ParticipantName: $('#UserTrainCompParName_' + i).val(),
                IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
            }

            //if (Rescdate == "") {
            //    if (_UserTrainingGrid.ParticipantId == "" && _UserTrainingGrid.ParticipantName != "" && _UserTrainingGrid.IsDeleted == false) {
            //        $("div.errormsgcenter").text("Valid Participants required.");
            //        $('#errorMsg').css('visibility', 'visible');
            //        $('#myPleaseWait').modal('hide');
            //        return false;
            //    }
                result.push(_UserTrainingGrid);
            //}

            //if (isRechDone == "true") {
            //    if (_UserTrainingGrid.ParticipantId == "" && _UserTrainingGrid.ParticipantName != "" && _UserTrainingGrid.IsDeleted == false) {
            //        $("div.errormsgcenter").text("Valid Participants required.");
            //        $('#errorMsg').css('visibility', 'visible');
            //        $('#myPleaseWait').modal('hide');
            //        return false;
            //    }
            //    result.push(_UserTrainingGrid);
            //}

        }
    }

    var duplicates = false;
    for (i = 0; i < result.length; i++) {
        var participantId = result[i].ParticipantId;
        for (j = i + 1; j < result.length; j++) {
            if (participantId == result[j].ParticipantId) {
                duplicates = true;
            }
        }
    }

    if (duplicates) {
        $("div.errormsgcenter").text("Name of Participants should be unique.");
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        return false;
    }

    function chkIsDeletedRow(i, delrec) {
        if (delrec == true) {
            $('#UserTrainCompParName_' + i).prop("required", false);
            //   $('#UserTrainCompAreaCode_' + i).prop("required", false);
            return true;
        }
        else {
            return false;
        }
    }

    var isFormValid = formInputValidation("UserTraiCopmPage", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');

        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }

    if (traiDesc != "" && traiModule != "") {
        if (MinPar != "" && MinPar == 0) {
            $("div.errormsgcenter").text("Minimum No. Of Participants should be greater than zero.");
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }

    }

    //if (traintyp == 254) {
    //    if (Actdate == "" || Rescdate == "") {
    //        $("div.errormsgcenter").text("Invalid Date. Actual Date must be greater than or equal to Planned Date");
    //        $('#errorMsg').css('visibility', 'visible');
    //        $('#myPleaseWait').modal('hide');
    //        return false;
    //    }
    //}

    //var CompareActDat = new Date($('#UserTrainCompActDate').val());
    //var ComparePlnDat = new Date($('#UserTrainCompPlndDte').val());
    //var CompareRchDat = new Date($('#UserTrainCompReschDate').val());

    var CompareActDat = Date.parse($('#UserTrainCompActDate').val());
    var ComparePlnDat = Date.parse($('#UserTrainCompPlndDte').val());
    var CompareRchDat = Date.parse($('#UserTrainCompReschDate').val());


    var date = Date.parse($('#UserTrainCompPlndDte').val());
    var NotifiyDat = Date.parse($('#UserTrainCompNotDat').val());

    var CompareRchDatFormatd = DateFormatter(CompareRchDat);
    var curdate = new Date();

    var curdateFormatd = DateFormatter(curdate);
    curdateFormatd = Date.parse(curdateFormatd);


    var Id = $("#primaryID").val();
    if (Id == 0 || Id == null || Id == "") {
        if (date != null && date != "" && date != undefined) {
            if (ComparePlnDat < curdateFormatd) {
                $("div.errormsgcenter").text("Planned Date must be greater than or equal to Current Date");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }
    }


    //if (traintyp == 254) {
    //    if ((CompareActDat != null) && (CompareActDat < ComparePlnDat)) {
    //        $("div.errormsgcenter").text("'Invalid Date'- Actual Date must be greater than or equal to Planned Date");
    //        $('#errorMsg').css('visibility', 'visible');
    //        $('#myPleaseWait').modal('hide');
    //        return false;
    //    }
    //}    
    if (traintyp == 254) {
        var today = GetCurrentDate();
        var Currentdate = Date.parse(today);
        if ((CompareActDat != null) && (CompareActDat > Currentdate)) {
            $("div.errormsgcenter").text(" 'Invalid Date'- Actual Date must be Lesser than or equal to Current Date");
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }
    }

    if (CompareRchDat != null) {
        var rchyr = CompareRchDat.getFullYear();
        var rchmnth = CompareRchDat.getMonth() + 1;
    }
    if (ComparePlnDat != null) {
        var plnyr = ComparePlnDat.getFullYear();
        var plnmnth = ComparePlnDat.getMonth() + 1;
    }

    //var rchyr = CompareRchDat.getFullYear();
    //var rchmnth = CompareRchDat.getMonth() + 1;
    //var plnyr = ComparePlnDat.getFullYear();
    //var plnmnth = ComparePlnDat.getMonth() + 1;


    if (TrainingScheduleId > 0) {
        if (CompareRchDat >= curdate) {
            if (plnyr == rchyr) {
                if (plnmnth != rchmnth) {
                    $("div.errormsgcenter").text("Reschedule Date should be within the planned month");
                    $('#errorMsg').css('visibility', 'visible');
                    $('#myPleaseWait').modal('hide');
                    return false;
                }
            }
            else if ((!isNaN(CompareRchDat)) && (CompareRchDat != "")) {
                $("div.errormsgcenter").text("Reschedule Date should be within the planned month");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }
        else if (CompareRchDatFormatd != "") {
            if (CompareRchDatFormatd < curdateFormatd) {
                $("div.errormsgcenter").text("Reschedule Date should be greater than or equal to Current Date");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }

    }

    if (Actdate != "") {
        deletedCount = Enumerable.From(result).Where(x=>x.IsDeleted).Count();
        var Isdeleteavailable = deletedCount > 0;
        if (deletedCount == result.length && (TotalPages == 1 || TotalPages == 0)) {
            bootbox.alert("Sorry!. You cannot delete all rows");
            $('#myPleaseWait').modal('hide');
            return false;
        }
    }

    var primaryId = $("#primaryID").val();
    if (primaryId == 0 && traintyp == 254) {
        $('#UserTrainCompParName_0').removeAttr('required');
        //  $('#UserTrainCompAreaCode_0').removeAttr('required');
    }

    var isFormValid = formInputValidation("UserTraiCopmPage", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');

        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }

    if (curdateFormatd <= ComparePlnDat) {
        if (NotifiyDat != null && NotifiyDat != "" && NotifiyDat != undefined) {
            if (NotifiyDat > ComparePlnDat) {
                $("div.errormsgcenter").text("Notofication Date must be Lesser than or equal to Planned Date");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }
    }

    if (Rescdate == "" || isRechDone == "true") {
        if (TraiSrc == 264 && trainerid == "") {
            $("div.errormsgcenter").text("Valid Presenter (Trainer) required");
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }
    }

    var Notdate = Date.parse($('#UserTrainCompNotDat').val());

    if (TrainingScheduleId == 0 && traintyp == 254 && notiDate != "") {
        if (Notdate < curdateFormatd) {
            $("div.errormsgcenter").text("Notification Date must be greater than or equal to Current Date");
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }
    }

    var primaryId = $("#primaryID").val();
    if (primaryId != null) {
        usertraingid = primaryId;
        timeStamp = timeStamp;
    }
    else {
        usertraingid = 0;
        timeStamp = "";
    }

    var obj = {

        TrainingScheduleId: usertraingid,
        ServiceId: typeOfServiceReq,
        NotificationDate: notiDate,
        TrainingTypeId: traintyp,
        PlannedDate: plndDte,
        Quarter: quarter,
        Year: year,
        TrainingScheduleNo: traiSchNo,
        TrainingDescription: traiDesc,
        Trainingmodule: traiModule,
        MinNoOfParticipants: MinPar,
        Email: email,
        selServices: ServiceReq,
        ActualDate: Actdate,
        TrainingStatusId: TraiSts,
        TrainerSource: TraiSrc,
        TrainerPresenterName: trainer,
        TrainerPresenter: trainerid,
        Experience: exp,
        Designation: desig,
        TotalParticipants: totPart,
        venue: venue,
        TrainingRescheduleDate: Rescdate,
        OverallEffectiveness: Traieff,
        Remarks: remarks,
        UserTrainingGridData: result,
        UserTrainingAreaGridData: Arearesult,
        Timestamp: timeStamp,
        IsConfirmed: true,
    }

    if (obj.UserTrainingAreaGridData.length == 0) {
        $("div.errormsgcenter").text("Please save \"Area Name\" before proceeding");
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        return false;
    }

    //if (primaryId == 0 && traintyp == 254) {
    //    $('#UserTrainCompParName_0').removeAttr('required');
    //    //   $('#UserTrainCompAreaCode_0').removeAttr('required');
    //}

    //var isFormValid = formInputValidation("UserTraiCopmPage", 'save');
    //if (!isFormValid) {
    //    $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
    //    $('#errorMsg').css('visibility', 'visible');

    //    $('#btnlogin').attr('disabled', false);
    //    $('#myPleaseWait').modal('hide');
    //    return false;
    //}

    var totalperson = 0;
    totalperson = obj.UserTrainingGridData.length
    totalperson = (parseInt(totalperson) - parseInt(deletedCount));
    var MinPar = $('#UserTrainCompMinPar').val();
    MinPar = parseInt(MinPar);
    if (totalperson < MinPar) {
        bootbox.confirm("Total number of participants are less than Minimum no. of participants, "
            + "After Confirmation no further changes will be allowed. Click Yes to confirm", function (result) {
                if (result) {

                    if (Isdeleteavailable == true) {
                        bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (result) {
                            if (result) {
                                SaveUserTraiCompWithConfirm(obj);
                            }
                            else {
                                $('#myPleaseWait').modal('hide');
                            }
                        });
                    }
                    else {
                        SaveUserTraiCompWithConfirm(obj);
                    }
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            });
    }
    else {
        //
        bootbox.confirm("After Confirmation, no further changes will be allowed. Click Yes to confirm!", function (result) {
            if (result) {

                if (Isdeleteavailable == true) {
                    bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (result) {
                        if (result) {
                            SaveUserTraiCompWithConfirm(obj);
                        }
                        else {
                            $('#myPleaseWait').modal('hide');
                        }
                    });
                }
                else {
                    SaveUserTraiCompWithConfirm(obj);
                }
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    }



    function SaveUserTraiCompWithConfirm(obj) {
        var jqxhr = $.post("/api/UserTraining/Save", obj, function (response) {
            var result = JSON.parse(response);
            GetUserTrainingBind(result);

            $("#primaryID").val(result.TrainingScheduleId);
            $("#Timestamp").val(result.Timestamp);
            if (result.TrainingTypeId == 254 && result.IsConfirmed == false) {
                $('#UserTrainAddrow').show();
            }


            $('#TrainingCompSection').css('visibility', 'visible');
            $('#TrainingCompSection').show();
            SchduleSection();
            $('#UserTrainCompTraiTyp').prop("disabled", true);
            $(".content").scrollTop(0);
            showMessage('User Training', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            $('#errorMsg').css('visibility', 'hidden');
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
            $('#errorMsg').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });

    }
}

function disableFields() {
    $("#UserTraiCopmPage :input:not(:button)").prop("disabled", true);
    $('#btnConfirmVerify').hide();
    $('#btnEdit').hide();
    $('#btnSave').hide();
    $('#btnSaveandAddNew').hide();
    $('#UserTrainAddrow').hide();
    $('#UserTrainCompNotDat').css("background-color", "#eee");

}

function disableGridFields(index, value) {
    $('#Isdeleted_' + index).prop('disabled', true);
    $('#UserTrainCompParName_' + index).prop('disabled', true);
    //  $('#UserTrainCompAreaCode_' + index).prop('disabled', true)

}

function disableGridFieldsArea(index, value) {
    $('#UserTrainCompAreaPop_' + index).prop('disabled', true);
}


//**** Grid merging ******\\

function LinkClicked(id) { 
    linkCliked1 = true;
    $(".content").scrollTop(1);
    $('.star').removeClass('selected');
    $('.noreqired').val('');
    $('#hdnUserTraiGrid_0').val('');
    $('#UserTrainFdBkRecom').val('');
    $('.nav-tabs a:first').tab('show');
    $("#UserTraiCopmPage :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#paginationfooter').hide();
    $('#UserTrainAddrowArea').show();
    $('#btnSaveArea').show();
    var action = "";
    $('#primaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission) {
        action = "Edit"

    }
    else if (!hasEditPermission) {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#btnDelete').show();
    }

    if (action == 'View') {
        $("#UserTraiCopmPage :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (parseInt(primaryId) > 0) {

        //$('#UserTrainAddrow').show();

        $('#UserTrainCompActDate').prop('required', true);
        $('#UserTrainCompVenue').prop('required', false);
        $("#lblActDate").html("Actual Date <span class='red'>*</span>");
        //$('#UserTrainCompTraiSource').prop('required', true);
        //$("#lblTraiSource").html("Trainer Source <span class='red'>*</span>");
        //$('#UserTrainCompPresTrainer').prop('required', true);
        //$("#lblPresTrainer").html("Presenter (Trainer) <span class='red'>*</span>");
        $('#UserTrainCompVenue').prop('required', false);
        $("#lblVenue").html("Venue");


        $('#UserTrainCompActDate').prop('disabled', false);
        $('#UserTrainCompTraiSource').prop('disabled', false);
        $('#UserTrainCompTraiSource option[value="' + "" + '"]').prop('selected', true);
        $('#UserTrainCompPresTrainer').prop('disabled', false);

        $('#UserTrainCompExp').prop('disabled', false);
        $('#UserTrainCompDesig').prop('disabled', false);
        $('#UserTrainCompVenue').prop('disabled', false);
        $('#UserTrainCompReschDate').prop('disabled', false);
        $('#UserTrainCompRem').prop('disabled', false);
        $('#UserTrainCompNotDat').prop('disabled', false);

        $('#UserTrainCompPlndDte').prop('required', false);
        //$('#UserTrainComptraiDesc').prop('required', false);
        //$('#UserTrainComptraiMod').prop('required', false);
        $('#UserTrainCompMinPar').prop('required', true);
        $("#lblPlndDte").html("Planned Date");
        //$("#lbltraiMod").html("Training Module");
       // $("#lbltraiDesc").html("Training Description");
        $("#lblMinPar").html("Minimum No. of Participants");

    }


    var TrainSchId = $('#primaryID').val();
    if (TrainSchId > 0) {
        $('#TrainingCompSection').css('visibility', 'visible');
        $('#TrainingCompSection').show();
    }
    else {
        $('#TrainingCompSection').css('visibility', 'hidden');
        $('#TrainingCompSection').hide();
    }

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/UserTraining/Get/" + primaryId + "/" + pagesize + "/" + pageindex)
          .done(function (result) {
              var getResult = JSON.parse(result);

              GetUserTrainingBind(getResult)

              $('#myPleaseWait').modal('hide');
          })
         .fail(function () {
             $('#myPleaseWait').modal('hide');
             $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
             $('#errorMsg').css('visibility', 'visible');
         });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }

}

$("#btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_CANCEL_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/UserTraining/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('User Training', CURD_MESSAGE_STATUS.CNS);
                 $('#myPleaseWait').modal('hide');
                 $("#grid").trigger('reloadGrid');
                 EmptyFields();
             })
             .fail(function () {
                 showMessage('User Training', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
        }

    });
}
$("#btnNextScreenSave").click(function () {
    window.location.href = "/bems/userarea";
});
function EmptyFields() {
    $(".content").scrollTop(0);
    $('input[type="text"], textarea').val('');
    $('#UserTrainCompQuarter').val("null");
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#UserTrainCompYear").val('null');
    $("#grid").trigger('reloadGrid');
    $("#UserTraiCopmPage :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#TrainingCompSection').css('visibility', 'visible');
    $('#TrainingCompSection').hide();
    $("#hdnUserTraiFeedbkId").val('');
    // SchduleSection();
    $('#UserTrainCompPlndDte').prop("disabled", false);
    $('#UserTrainCompTraiTyp option[value="' + 254 + '"]').prop("selected", true);
    $('#UserTrainCompTraiTyp').prop("disabled", false);
    $('#UserTrainComptraiDesc').prop("disabled", false);
    $('#UserTrainComptraiMod').prop("disabled", false);
    $('#UserTrainCompMinPar').prop("disabled", false);
    $("#paginationfooter").hide();
    $('#UserTrainCompActDate').prop("required", false);
    $('#UserTrainCompVenue').prop("required", false);
    $('#UserTrainCompParName_0').prop("required", false);
    $('.star').removeClass('selected');
    $("#primaryID").val(0);
    $('#UserTrainCompNotDat').prop("disabled", false);
    $('#UserTrainCompTraiSource option[value="' + 0 + '"]').prop("selected", true);
    $('#UserTrainCompTraiSource').prop("disabled", false);
    $("#UserTrainCompTraiSource").val('').prop('disabled', false);
    $('#UserTrainCompYear').empty().append('<option value="0">Select</option>');
    $('#UserTrainCompYear option[value="' + 0 + '"]').prop("selected", true);
    $('#UserTrainCompQuarter option[value="' + 0 + '"]').prop("selected", true);
    $('#UserTrainCompExp').prop("disabled", false);
    $('#UserTrainCompDesig').prop("disabled", false);
    $("#ExtEmail").hide();
    $('#UserTrainAddrowArea').show();
    $('#btnSaveArea').show();
    $("#UserTainAreaTableGrid").empty(); 
    $("#selServices").val('');
    AddNewRowArea();
    $('#UserTrainCompPresTrainer').prop("disabled", false);
    $('#btnConfirmVerify').show().prop("disabled", true);
    $('#btnSaveandAddNew').show();
    $("#UserTrainingGrid").empty();
    AddNewRowUserTraining();
    Arearesult = [];
    $('#UserTrainCompNotDat').css("background-color", "#fff");
    $("#lblNotDat").html("Notification Date <span class='red'>*</span>");
    $('#UserTrainCompAreaPop_0').prop("disabled", false);
    $('#UserTrainCompTraiSts').val('');
    $('#hdnIsConfim').val('');
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
        //$('#UserTrainCompFacCde').val(FacCode);

        //$.each(loadResult.ServiceLovs, function (index, value) {
        //    $('#UserTrainCompSer').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        //});

        //$.each(loadResult.TrainingTypeLovs, function (index, value) {
        //    $('#UserTrainCompTraiTyp').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        //});
        //$.each(loadResult.QuarterLovs, function (index, value) {
        //    $('#UserTrainCompQuarter').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        //});
        //$.each(loadResult.TrainingStsLovs, function (index, value) {
        //    $('#UserTrainCompTraiSts').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        //});
        //$.each(loadResult.TrainingSourceLovs, function (index, value) {
        //    $('#UserTrainCompTraiSource').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        //});

        $('#UserTrainAddrow').hide();
        $('.nav-tabs a:first').tab('show');
    })
.fail(function () {
    $('#myPleaseWait').modal('hide');
    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
    $('#errorMsg').css('visibility', 'visible');
});

}