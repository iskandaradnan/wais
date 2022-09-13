var gridFetchRec = false;

$(document).ready(function () {

    $('#myPleaseWait').modal('show');

    formInputValidation("EODCaptureForm");
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();

    $.get("/api/EODCapture/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#jQGridCollapse1").click();
            window.UOM = loadResult.UOM
            window.DataType = loadResult.DataType
            window.Frequency = loadResult.Frequency

            actionType = $('#ActionType').val();

            //if (actionType == "EDIT" || actionType == "VIEW") {
            //    $('#EODCaptureTable').css('visibility', 'visible');
            //}

            $.each(loadResult.ServiceLovs, function (index, value) {
                if (value.LovId == 2)
                    $('#EodCapService').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
           // $("#EODCapClassifi").val('').empty().append('<option value="0">Select</option>')
            $.each(loadResult.CategorySystem, function (index, value) {
                $('#EODCapClassifi').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $('#btnSave').prop('disabled', true);
            $('#btnSaveandAddNew').prop('disabled', true);

             //To get current Datetime
            var today = new Date();
            var CurDate = GetCurrentDate();
            var hour = today.getHours();
            var time = today.getMinutes();
            var time = time.toString();

            if (time.length == 1) {
                time = 0 +''+ time;
            }

            var gettime = hour + ":" + time;

            var CurDateTime = CurDate + " " + gettime;

            $('#EodCapRecDate').val(CurDateTime);

            $("#EodCapRecDate").on('input change', function () {
                //$('#EODCapClassifi option[value="' + '' + '"]').prop('selected', true);
                //$('#EODCapAssetNo').val('');
                //$('#hdnEodCapAssetId').val('');
                //$('#EODCapAssetDesc').val('');
                //$('#EODCapUsrAreaCd').val('');
                //$('#EODCapUsrAreaNam').val('');
                //$('#EODCapUsrLocCde').val('');
                //$('#EODCapUsrLocNam').val('');
                //$('#EODCapTypCod').val('');
                $("#EODCapBody").empty();
                //$('#EODCaptureTable').css('visibility', 'visible');
                $('#EODCaptureTable').hide();
            });

            $("#EODCapAssetNo").on('input', function () {                
                $("#EODCapBody").empty();
                $('#EODCaptureTable').hide();
                $('#EodCapFreqDiv').css('visibility', 'hidden');
                $('#EodCapnxtCapDiv').css('visibility', 'hidden');
            });

            //$("#EODCapClassifi").on('change', function () {
            //    $('#EODCapAssetNo').val('');
            //    $('#hdnEodCapAssetId').val('');
            //    $('#EODCapAssetDesc').val('');
            //    $('#EODCapUsrAreaCd').val('');
            //    $('#EODCapUsrAreaNam').val('');
            //    $('#EODCapUsrLocCde').val('');
            //    $('#EODCapUsrLocNam').val('');
            //    $('#EODCapTypCod').val('');
            //    $("#EODCapBody").empty();
            //    $('#EODCaptureTable').hide();
            //});
            

            //var primaryId = $('#primaryID').val();
            //if (primaryId != null && primaryId != "0") {
            //    $.get("/api/EODCapture/Get/" + primaryId)
            //      .done(function (result) {
            //          var getResult = JSON.parse(result);

            //          GetEODData(getResult);

            //          $('#myPleaseWait').modal('hide');
            //      })
            //     .fail(function () {
            //         $('#myPleaseWait').modal('hide');
            //         $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            //         $('#errorMsg').css('visibility', 'visible');
            //     });
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




    /******************************************** Fetching grid data************************************************/


    var timeStamp = $("#Timestamp").val();

    var SerId = $('#EodCapService').val();
    var ClassId = $('#EODCapClassifi').val();

    $("#EODCapFetchAddBtn").click(function () {

        //formInputValidation("EODCaptureForm");

        //var SerId = $('#EodCapService').val();
        var AstId = $('#hdnEodCapAssetId').val();
        var clasification = $('#EODCapClassifi').val();
        var recdat = $('#EodCapRecDate').val();
        var TypCode = $('#hdnEODCapTypCodId').val();
        var AssetNo = $('#EODCapAssetNo').val();
        var recDate = Date.parse($('#EodCapRecDate').val());
        var curdate = new Date();

        if (recDate > curdate) {
            $("div.errormsgcenter").text("Record Date can't be a future Date / Time ");
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }


        var obj = {
            //ServiceId: SerId,
            AssetClassificationId: clasification,
            RecordDate: recdat,
            TypeCodeID: TypCode,
            AssetId: AstId
        }

        //if (SerId != null && SerId != "0" && Cat != null && Cat != "0" && recdat != null && recdat != "" && astId != null && astId != "") {
        if (recdat != null && recdat != "" && AstId != null && AstId != "") {
             //$.get("/api/EODCapture/BindDetGrid/" + SerId + "/" + Cat + "/" +recdat)
            $.post("/api/EODCapture/BindDetGrid" ,obj)
              .done(function (result) {
                  var getResult = JSON.parse(result);

                  if (getResult.EODCaptureGridData != null) {
                      $("#EODCaptureTable").show();
                      GetEODFechGrid(getResult);

                      $('#myPleaseWait').modal('hide');
                      $("div.errormsgcenter").css('visibility', 'hidden');
                      //$('#errorMsg').hide();
                      gridFetchRec = true;
                  }
                  else {                      
                      $("#EODCaptureTable").hide();
                      $("#EODCapBody").empty();
                      $("div.errormsgcenter").text("ER Parameters not defined for the Asset");
                          $('#errorMsg').css('visibility', 'visible');

                          $('#btnlogin').attr('disabled', false);
                          $('#myPleaseWait').modal('hide');
                          $('#EodCapFreqDiv').css('visibility', 'hidden');
                          //$('#EodCapFreqDiv').show();
                          $("#EODCapFreq").val('');
                  }
                  
              })
             .fail(function () {
                 $('#myPleaseWait').modal('hide');
                 $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
                 //$("div.errormsgcenter").text('Please enter mandatory values before fetching');

                 $('#errorMsg').css('visibility', 'visible');
             });
        }
        else if ((AssetNo !== "" && recDate !== "") && AstId == "") {
            bootbox.alert("Valid Asset No. is required");
        }
        else {
            bootbox.alert("Please Enter All Mandatory Values Before Fetching");
            //$('#myPleaseWait').modal('hide');
            //$("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            //$('#errorMsg').css('visibility', 'visible');
        }
    
    });


    /****************************************** Save *********************************************/

    $("#btnSave, #btnEdit,#btnSaveandAddNew").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');
        var CurrentbtnID = $(this).attr("Id");
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        //var isFormValid = formInputValidation("EODCaptureForm", 'save');
        //if (!isFormValid) {
        //    $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        //    $('#errorMsg').css('visibility', 'visible');

        //    $('#btnlogin').attr('disabled', false);
        //    $('#myPleaseWait').modal('hide');
        //    return false;
        //}

        var _index;
        $('#EODCapBody tr').each(function () {
            _index = $(this).index();
        });

        var CaptureId = $('#primaryID').val();
        var DocumentNo = $('#EodCapDocNo').val();
        var ServiceId = $('#EodCapService').val();
        var RecDate = $('#EodCapRecDate').val();
        var Clasisficationid = $('#EODCapClassifi').val();
        var AssetNo = $('#EODCapAssetNo').val();
        var AssetId = $('#hdnEodCapAssetId').val();
        var Assetdesc = $('#EODCapAssetDesc').val();
        var areaCode = $('#EODCapUsrAreaCd').val();
        var areaCodeId = $('#hdnEodCapUsrAreaCdId').val();
        var areaName = $('#EODCapUsrAreaNam').val();
        var LocCode = $('#EODCapUsrLocCde').val();
        var LocId = $('#hdnEodCapUsrLocCdeId').val();
        var LocName = $('#EODCapUsrLocNam').val();
        var Typecode = $('#EODCapTypCod').val();
        var TypecodeId = $('#hdnEODCapTypCodId').val();
        var nextCapDate = $('#EODCapNxtCapDt').val();
        var timeStamp = $("#Timestamp").val();

        var CompareRecDat = new Date($('#EodCapRecDate').val());
        var CurrDate = new Date();
        var curdateFormatd = DateFormatter(CurrDate);
        curdateFormatd = Date.parse(curdateFormatd);

        if (CompareRecDat > CurrDate) {
            DisplayErrorMessage("Record Date can't be a future Date / Time");
            return false;
        }

        var isFormValid = formInputValidation("EODCaptureForm", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text("");
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var NextCaptureDt = Date.parse($('#EODCapNxtCapDt').val());

        var nxtCapExp = $('#hdnEODCapNxtCapExp').val()
        if (nxtCapExp != 0) {
            if (curdateFormatd > NextCaptureDt) {
                $("div.errormsgcenter").text("Next Capture Date should be greater than or equal to Current Date");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }
        var priId = $('#primaryID').val();
        if (priId == "" || priId == "0" || priId == 0) {
            if (curdateFormatd > NextCaptureDt) {
                $("div.errormsgcenter").text("Next Capture Date should be greater than or equal to Current Date");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }

        var result = [];

        for (var i = 0; i <= _index; i++) {
            
            var _EODCapFetchGrid = {                
                CaptureId: $('#primaryID').val(),
                CaptureDetId: $('#hdnEodCapGrid_' + i).val(),
                ParamterValue: $('#EodCapParam_' + i).text(),
                ParameterMappingDetId: $('#hdnParMapDetId_' + i).val(),
               // Standard: $('#EodCapStand_' + i).text(),
                UOMId: $('#hdnCapUOMId_' + i).val(),
                Minimum: $('#EodCapMin_' + i).val(),
                Maximum: $('#EodCapMax_' + i).val(),
                DataTypeId: $('#hdnDataTypId_' + i).val(),
                ActualValue: chkActulaValue(i, $('#hdnDataTypId_' + i).val()),
                //Status: chkRadioButtonValur(i),
                Status: Validatedata(i, $('#hdnDataTypId_' + i).val()),
                Email: $('#hdnEmailId_' + i).val(),
            }
            var par = $('#EodCapParam_' + i).text();
            var stnd = $('#EodCapStand_' + i).text();
            var actval = $('#EodCapActualVal_' + i).val();
            actval = $.trim(actval);
            var actvaldrp = $('#EodCapActualValDrop_' + i).val();

            if (_EODCapFetchGrid.DataTypeId == 176) {
                if (actval == '') {
                    //DisplayErrorMessage('Please provide Actual Value for' + ' ' + par + ' ' + '-' + ' ' + stnd);
                    DisplayErrorMessage('Please provide Actual Value for' + ' - ' + par);
                    return false;
                }
            }

            if (_EODCapFetchGrid.Status == undefined) {
                //DisplayErrorMessage('Status is required for' + ' ' + par + ' ' + '-' + ' ' + stnd);
                DisplayErrorMessage('Status is required for' + ' - ' + par);
                return false;
            }

            if (_EODCapFetchGrid.DataTypeId == 176 || _EODCapFetchGrid.DataTypeId == 177) {
                if ((_EODCapFetchGrid.Status == 0 || _EODCapFetchGrid.Status == 1 || _EODCapFetchGrid.Status == 2) && (actval == '')) {
                    //DisplayErrorMessage('Please provide Actual Value for' +' ' + par + ' '+ '-' + ' '+ stnd);
                    DisplayErrorMessage('Please provide Actual Value for' + ' - ' + par);
                    return false;
                }
            }
            else if (_EODCapFetchGrid.DataTypeId == 178) {
                if ((_EODCapFetchGrid.Status == 0 || _EODCapFetchGrid.Status == 1 || _EODCapFetchGrid.Status == 2) && (actvaldrp == undefined || actvaldrp == 'Select' || actvaldrp == "")) {
                    //DisplayErrorMessage('Select dropdown value' + ' ' + par + ' ' + '-' + ' ' + stnd);
                    DisplayErrorMessage('Select dropdown value' + ' - ' + par);
                    return false;
                }
            }

        
            result.push(_EODCapFetchGrid);
        }


        function chkActulaValue(i, DataTypeId) {
            if (DataTypeId == 176 || DataTypeId == 177) {
                var val = $('#EodCapActualVal_' + i).val();
            }
            else if (DataTypeId == 178) {
                var val = $('#EodCapActualValDrop_' + i + ' option:selected').text();
            }
            return val;
        }

        function DisplayErrorMessage(errorMessage) {
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }

        //if (gridFetchRec == false) {
        //    $("div.errormsgcenter").text("ER Parameters not defined for the Asset");
        //    $('#errorMsg').css('visibility', 'visible');

        //    $('#btnlogin').attr('disabled', false);
        //    $('#myPleaseWait').modal('hide');
        //    return false;
        //}

        //if ( result.length == 0) {
        //    $("div.errormsgcenter").text("ER Parameters not defined for the Asset");
        //    $('#errorMsg').css('visibility', 'visible');

        //    $('#btnlogin').attr('disabled', false);
        //    $('#myPleaseWait').modal('hide');
        //    return false;
        //}

        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            CaptureId = primaryId;
            Timestamp = timeStamp;
        }
        else {
            CaptureId = 0;
            Timestamp = "";
        }

        var email = $('#hdnEmailId_0' + i).val();
        var obj = {
            CaptureId: CaptureId,
            ServiceId: ServiceId,
            CaptureDocumentNo: DocumentNo,
            RecordDate: RecDate,
            AssetClassificationId: Clasisficationid,
            AssetId: AssetId,
            UserAreaId: areaCodeId,
            UserLocationId: LocId,
            TypeCodeID: TypecodeId,
            NextCapdate: nextCapDate,
            EODCaptureGridData: result,
            Timestamp: timeStamp,
            Email: email
        }

        var isFormValid = formInputValidation("EODCaptureForm", 'save');
        if (!isFormValid) {
            //errorMsg("INVALID_INPUT_MESSAGE");
            $("div.errormsgcenter").text("");
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }



        if (obj.EODCaptureGridData.length == 0 && isFormValid) {
            $("div.errormsgcenter").text("ER Parameters not defined for the Asset");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
            return false;
        }
        else {

        }

        //if (result.length > 0) {
        var jqxhr = $.post("/api/EODCapture/Save", obj, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.CaptureId);
            $("#Timestamp").val(result.Timestamp);
            GetEODData(result);
            $("#grid").trigger('reloadGrid');
            $('#hdnAttachId').val(result.HiddenId);
            if (result.CaptureId != 0) {
                $('#btnNextScreenSave').show();
                $('#btnEdit').show();
                $('#btnSave').hide();
                $('#btnDelete').show();
            }
            $(".content").scrollTop(0);
            showMessage('EOD Capture', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
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
        //}
        //else {
        //    $('#myPleaseWait').modal('hide');
        //    $("div.errormsgcenter").text("not");
        //    $('#errorMsg').css('visibility', 'visible');
        //}
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
});


/************************************ Fetching Grid data***************************************************/

function GetEODFechGrid(getResult) {

        $('#EODCaptureTable').css('visibility', 'visible');
        $('#EODCaptureTable').show();
        $("#EODCapBody").empty();

        $('#btnSave').prop('disabled', false);
        $('#btnSaveandAddNew').prop('disabled', false);

        $.each(getResult.EODCaptureGridData, function (index, value) {
            NewRowEODCapture();

            //var CaptureDetId = $('#hdnEodCapGrid_' + i).val();
            //$("#hdnEodParMapGrid_" + index).val(getResult.EODParameterMappingGridData[index].ParameterMappingDetId);

            $("#hdnEmailId_" + index).val(getResult.EODCaptureGridData[index].Email);
            $("#hdnParMapDetId_" + index).val(getResult.EODCaptureGridData[index].ParameterMappingDetId);
            $("#EodCapParam_" + index).text(getResult.EODCaptureGridData[index].ParamterValue);
           // $("#EodCapStand_" + index).text(getResult.EODCaptureGridData[index].Standard);
            $("#EodCapUOM_" + index).text(getResult.EODCaptureGridData[index].UOM);
            $("#hdnCapUOMId_" + index).val(getResult.EODCaptureGridData[index].UOMId);
            $("#hdnDataTypId_" + index).val(getResult.EODCaptureGridData[index].DataTypeId);

            var array = [];
            if (getResult.EODCaptureGridData[index].DataTypeId == 178) {

                array = (getResult.EODCaptureGridData[index].AlphaNumDataval).split(",");
                $('#EodCapActualVal_' + index).parent().empty().append('<select id="EodCapActualValDrop_' + index + '" class="form-control" ><option value="">Select</option></select>');
                $.each(array, function (val, text) {
                    $('#EodCapActualValDrop_' + index).append($('<option></option>').val(text).html(text))
                });
            }
            else if (getResult.EODCaptureGridData[index].DataTypeId == 177) {
                $('#EodCapActualVal_' + index).parent().empty().append('<input type="text" class="form-control" autocomplete="off" maxlength="50"  id="EodCapActualVal_' + index + '" />');
                $("#EodCapActualVal_" + index).val(getResult.EODCaptureGridData[index].AlphaNumDataval);
            }
            else if (getResult.EODCaptureGridData[index].DataTypeId == 176) {
                $("#EodCapStspass_" + index).prop("disabled", "disabled");
                $("#EodCapStsfail_" + index).prop("disabled", "disabled");
                //$("#EodCapStsna_" + index).prop("disabled", "disabled");
                //$("#EodCapMin_" + index).val(getResult.EODCaptureGridData[index].Minimum == 0 ? null : getResult.EODCaptureGridData[index].Minimum);
                //$("#EodCapMax_" + index).val(getResult.EODCaptureGridData[index].Maximum == 0 ? null : getResult.EODCaptureGridData[index].Maximum);
                $("#EodCapMin_" + index).val(getResult.EODCaptureGridData[index].Minimum);
                $("#EodCapMax_" + index).val(getResult.EODCaptureGridData[index].Maximum);
            }
        });

        $('#EodCapnxtCapDiv').css('visibility', 'visible');
        $('#EodCapnxtCapDiv').show();
        $('#EODCapNxtCapDt').prop('required', true);
        $('#EodCapFreqDiv').css('visibility', 'visible');
        $('#EodCapFreqDiv').show();
        $("#EODCapFreq").val(getResult.EODCaptureGridData[0].Frequency);
}

/************************************ Get By ID ***************************************************/
function GetEODData(getResult) {
    $('#btnSaveandAddNew').prop('disabled', false);
    $("#EODCapFetchAddBtn").hide();
    var primaryId = $('#primaryID').val();

    $("#EodCapDocNo").val(getResult.CaptureDocumentNo).prop("disabled", "disabled");
    $("#EodCapService").prop("disabled", "disabled");
    $('#EodCapService option[value="' + getResult.ServiceId + '"]').prop('selected', true);
    $("#EodCapRecDate").val(moment(getResult.RecordDate).format("DD-MMM-YYYY HH:mm")).prop("disabled", "disabled");
    //$("#EodCapRecDate").val(DateFormatter(getResult.RecordDate)).prop("disabled", "disabled");
    $("#EODCapClassifi").prop("disabled", "disabled");
    $('#EODCapClassifi option[value="' + getResult.AssetClassificationId + '"]').prop('selected', true);
    $("#hdnEodCapAssetId").val(getResult.AssetId);
    $("#EODCapAssetNo").val(getResult.AssetNo).prop("disabled", "disabled");
    $("#EODCapAssetDesc").val(getResult.AssetDesc).prop("disabled", "disabled");
    $("#hdnEodCapUsrAreaCdId").val(getResult.UserAreaId);
    $("#EODCapUsrAreaCd").val(getResult.UserAreaCode).prop("disabled", "disabled");
    $("#EODCapUsrAreaNam").val(getResult.UserAreaName).prop("disabled", "disabled");
    $("#hdnEodCapUsrLocCdeId").val(getResult.UserLocationId);
    $("#EODCapUsrLocCde").val(getResult.UserLocationCode).prop("disabled", "disabled");
    $("#EODCapUsrLocNam").val(getResult.UserLocationName).prop("disabled", "disabled");
    $("#hdnEODCapTypCodId").val(getResult.TypeCodeID).prop("disabled", "disabled");
    $("#EODCapTypCod").val(getResult.TypeCode).prop("disabled", "disabled");

    $('#EodCapnxtCapDiv').css('visibility', 'visible');
    $('#EodCapnxtCapDiv').show();
    $('#EODCapNxtCapDt').prop('required', true);
    if (getResult.NextCapdate != null) {
        $("#EODCapNxtCapDt").val(DateFormatter(getResult.NextCapdate)).prop("disabled", "disabled");
        $("#hdnEODCapNxtCapExp").val(getResult.NextCapdateExpiry);
    } else {
        $("#EODCapNxtCapDt").val('').prop("disabled", false);
    }
    $('#EodCapFreqDiv').css('visibility', 'visible');
    $('#EodCapFreqDiv').show();
    $("#EODCapFreq").val(getResult.FrequencyVal);
   
    $('#Timestamp').val(getResult.Timestamp);
    $("#EODCapBody").empty();


    $.each(getResult.EODCaptureGridData, function (index, value) {
        $('#EODCaptureTable').css('visibility', 'visible');
        $('#EODCaptureTable').show();
        NewRowEODCapture();
        $("#hdnEodCapGrid_" + index).val(getResult.EODCaptureGridData[index].CaptureDetId);
        $("#hdnParMapDetId_" + index).val(getResult.EODCaptureGridData[index].ParameterMappingDetId);
        $("#EodCapParam_" + index).text(getResult.EODCaptureGridData[index].ParamterValue);
        //$("#EodCapStand_" + index).text(getResult.EODCaptureGridData[index].Standard);
        $("#EodCapUOM_" + index).text(getResult.EODCaptureGridData[index].UOM);
        $("#hdnCapUOMId_" + index).val(getResult.EODCaptureGridData[index].UOMId);
        $("#hdnDataTypId_" + index).val(getResult.EODCaptureGridData[index].DataTypeId);
        $("#EodCapMin_" + index).val(getResult.EODCaptureGridData[index].Minimum == 0 ? "-" : getResult.EODCaptureGridData[index].Minimum);
        $("#EodCapMax_" + index).val(getResult.EODCaptureGridData[index].Maximum == 0 ? "-" : getResult.EODCaptureGridData[index].Maximum);


        var array = [];
        var selectArray = "";
        if (getResult.EODCaptureGridData[index].DataTypeId == 178) {

            array = (getResult.EODCaptureGridData[index].dataValueDropdown).split(",");
            //selectArray = (getResult.EODCaptureGridData[index].ActualValue);
            //array.push(selectArray);
            $('#EodCapActualVal_' + index).parent().empty().append('<select id="EodCapActualValDrop_' + index + '" class="form-control" ><option>Select</option></select>');
            $.each(array, function (val, text) {
                $('#EodCapActualValDrop_' + index).append($('<option></option>').val(text).html(text))
            });
            if ($("#ActionType").val() == "VIEW") {
                $("#EodCapActualValDrop_" + index).prop("disabled", "disabled");
            }
        }
        else if (getResult.EODCaptureGridData[index].DataTypeId == 177) {
            $('#EodCapActualVal_' + index).parent().empty().append('<input type="text" class="form-control" autocomplete="off" maxlength="50"  id="EodCapActualVal_' + index + '" />');
            //ActualValuet = $.trim(getResult.EODCaptureGridData[index].ActualValue)
            $("#EodCapActualVal_" + index).val(getResult.EODCaptureGridData[index].ActualValue);
            if ($("#ActionType").val() == "VIEW") {
                $("#EodCapActualVal_" + index).prop("disabled", "disabled");
            }

        }
        else if (getResult.EODCaptureGridData[index].DataTypeId == 176) {
            $("#EodCapMin_" + index).val(getResult.EODCaptureGridData[index].Minimum == 0 ? null : getResult.EODCaptureGridData[index].Minimum);
            $("#EodCapMax_" + index).val(getResult.EODCaptureGridData[index].Maximum == 0 ? null : getResult.EODCaptureGridData[index].Maximum);
            $("#EodCapStspass_" + index).prop("disabled", "disabled");
            $("#EodCapStsfail_" + index).prop("disabled", "disabled");
            $("#EodCapStsna_" + index).prop("disabled", "disabled");
            if ($("#ActionType").val() == "VIEW") {
                $("#EodCapActualVal_" + index).prop("disabled", "disabled");
            }
        }

        if (getResult.EODCaptureGridData[index].DataTypeId == 176 || getResult.EODCaptureGridData[index].DataTypeId == 177) {
            $("#EodCapActualVal_" + index).val(getResult.EODCaptureGridData[index].ActualValue);
        }
        else if (getResult.EODCaptureGridData[index].DataTypeId == 178) {
            //$('#EodCapActualValDrop_' + index).val(getResult.EODCaptureGridData[index].ActualValue);
            $('#EodCapActualValDrop_' + index).val(getResult.EODCaptureGridData[index].ActualValue);
        }

        if (getResult.EODCaptureGridData[index].Status == 1) {
            if ($("#ActionType").val() == "VIEW") {
                $("#EodCapStspass_" + index).prop("disabled", "disabled");
                $("#EodCapStsfail_" + index).prop("disabled", "disabled");
                $("#EodCapStsna_" + index).prop("disabled", "disabled");
            }
            $("#EodCapStspass_" + index).prop('checked', true);
            $("#EodCapStsfail_" + index).prop('checked', false);
            $("#EodCapStsna_" + index).prop('checked', false);

            //$("input[name='status_" + index + "'][value='Pass']").attr('checked', 'checked');
        }
        else if (getResult.EODCaptureGridData[index].Status == 2) {
            if ($("#ActionType").val() == "VIEW") {
                $("#EodCapStspass_" + index).prop("disabled", "disabled");
                $("#EodCapStsfail_" + index).prop("disabled", "disabled");
                $("#EodCapStsna_" + index).prop("disabled", "disabled");
            }
            $("#EodCapStspass_" + index).prop('checked', false);
            $("#EodCapStsfail_" + index).prop('checked', true);
            $("#EodCapStsna_" + index).prop('checked', false);
        }
        else if (getResult.EODCaptureGridData[index].Status == 3) {
            if ($("#ActionType").val() == "VIEW") {
                $("#EodCapStspass_" + index).prop("disabled", "disabled");
                $("#EodCapStsfail_" + index).prop("disabled", "disabled");
                $("#EodCapStsna_" + index).prop("disabled", "disabled");
            }
            $("#EodCapStspass_" + index).prop('checked', false);
            $("#EodCapStsfail_" + index).prop('checked', false);
            $("#EodCapStsna_" + index).prop('checked', true);
        }

    });
}

function NewRowEODCapture() {
    var inputpar = {
        inlineHTML: EODCaptureHtml(),
        IdPlaceholderused: "maxindexval",
        TargetId: "#EODCapBody",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    var rowCount = $('#EODCapBody tr:last').index();

    formInputValidation("EODCaptureForm");
}

function EODCaptureHtml() {

    return ' <tr class="ng-scope" style=""> \
                <input type="hidden" id="hdnEodCapGrid_maxindexval" /> \
                <input type="hidden" id="hdnEmailId_maxindexval" />\
                <td width="25%" data-original-title="" title=""> <label for="EodCapParam_maxindexval" width="15%" class="control-label" id="EodCapParam_maxindexval"></label> \
                        <input type="hidden" id="hdnParMapDetId_maxindexval" /> </td> \
                <td width="20%" data-original-title="" title=""><div> <label for="EodCapUOM_maxindexval" class="control-label" width="15%" id="EodCapUOM_maxindexval"></label></div>   <input type="hidden" id="hdnCapUOMId_maxindexval" /></td> \
                <td width="10%" style="text-align: center;" data-original-title="" title=""><div> <input type="hidden" id="hdnDataTypeId_maxindexval" /> <input type="text" id="EodCapMin_maxindexval" style="text-align:right" class="form-control" disabled autocomplete="off" disabled/></div></td> \
                <td width="10%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" class="form-control" id="EodCapMax_maxindexval" style="text-align:right" autocomplete="off" disabled/></div></td> \
                    <input type="hidden" id="hdnDataTypId_maxindexval" /> \
                <td width="20%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" style="text-align:right" class="form-control decimalPointonly" autocomplete="off" onkeyup="Validatedata(maxindexval,hdnDataTypId_maxindexval)" maxlength="11"   id="EodCapActualVal_maxindexval"/></div></td> \
                <td width="15%" style="text-align: center;" data-original-title="" title=""><div> <input type="radio"  id="EodCapStspass_maxindexval" name="status_maxindexval" value="1" autocomplete="off"/><label>Pass</label> \
                                        <input type="radio"  id="EodCapStsfail_maxindexval" name="status_maxindexval" value="2" autocomplete="off"/><label>Fail</label> \
                                         <input type="hidden" id="hdnEodCapSts_maxindexval" /> \</div></td></tr>'

}


function FetchAssetNo(event) {
    $('#AssetFetch').css({
        'width': $('#EODCapAssetNo').outerWidth()
    });
    var ItemMst = {
        SearchColumn: 'EODCapAssetNo' + '-AssetNo',//Id of Fetch field
        ResultColumns: ["AssetId" + "-Primary Key", 'AssetNo' + '-EODCapAssetNo'],//Columns to be displayed
        FieldsToBeFilled: ["hdnEodCapAssetId" + "-AssetId", 'EODCapAssetNo' + '-AssetNo', 'EODCapAssetDesc' + '-AssetDescription', "hdnEodCapUsrAreaCdId" + "-UserAreaId", 'EODCapUsrAreaCd' + '-UserAreaCode', 'EODCapUsrAreaNam' + '-UserAreaName', "hdnEodCapUsrLocCdeId" + "-UserLocationId", 'EODCapUsrLocCde' + '-UserLocationCode', 'EODCapUsrLocNam' + '-UserLocationName', "hdnEODCapTypCodId" + "-TypeCodeID", 'EODCapTypCod' + '-TypeCode',   'EODCapClassifi' + '-AssetClarification']//id of element - the model property
    };
    DisplayFetchResult('AssetFetch', ItemMst, "/api/Fetch/ParentAssetNoFetch", "Ulfetch1", event, 1);
}

//function FetchAssetNo(event) {

//    var CatSystemId = $('#EODCapClassifi').val();
//    var RecDate = $('#EodCapRecDate').val();

//    if (CatSystemId != '' && RecDate!='') {
//        $("div.errormsgcenter").text("");
//        $('#errorMsg').css('visibility', 'hidden');

//        var ItemMst = {
//            SearchColumn: 'EODCapAssetNo' + '-AssetNo',//Id of Fetch field
//            ResultColumns: ["AssetId" + "-Primary Key", 'AssetNo' + '-EODCapAssetNo'],//Columns to be displayed
//            AdditionalConditions: ["CategorySystemId-EODCapClassifi", "RecordDate-EodCapRecDate"],
//            FieldsToBeFilled: ["hdnEodCapAssetId" + "-AssetId", 'EODCapAssetNo' + '-AssetNo', 'EODCapAssetDesc' + '-AssetDescription', "hdnEodCapUsrAreaCdId" + "-UserAreaId", 'EODCapUsrAreaCd' + '-UserAreaCode', 'EODCapUsrAreaNam' + '-UserAreaName', "hdnEodCapUsrLocCdeId" + "-UserLocationId", 'EODCapUsrLocCde' + '-UserLocationCode', 'EODCapUsrLocNam' + '-UserLocationName', "hdnEODCapTypCodId" + "-AssetTypeCodeId", 'EODCapTypCod' + '-AssetTypeCode']//id of element - the model property
//        };
//        DisplayFetchResult('AssetFetch', ItemMst, "/api/Fetch/EODCaptureAssetFetch", "Ulfetch1", event, 1);
//    }
//    else {
//            $("div.errormsgcenter").text("Please select Record Date and Category / System Name before proceed.");
//            $('#errorMsg').css('visibility', 'visible');
//            $('#myPleaseWait').modal('hide');
//            return false;
//    }
//  }

function Validatedata(index, dat) {

    //$('.digOnly').keypress(function (e) {
    //    var regex = new RegExp("^[0-9]*$");
    //    var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
    //    if (regex.test(str)) {
    //        return true;
    //    }
    //    e.preventDefault();
    //    return false;
    //});

    $('.decimalPointonly').on('input paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[a-zA-Z~`!@#$%^&*()_+|\\:{}\[\];-?<>\^\"\']/g, ''));
        }, 5);
    });

    //$('.decimalPointonly').keypress(function (e) {
    //    var regex = new RegExp("^[0-9.]*$");
    //    var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
    //    if (regex.test(str)) {
    //        return true;
    //    }
    //    e.preventDefault();
    //    return false;
    //});


    dat = $('#hdnDataTypId_' + index).val();
    if (dat == 176) {        
        var minval = $('#EodCapMin_' + index).val();
        minval = minval ? parseFloat(minval) : undefined;

        var maxval = $('#EodCapMax_' + index).val();
        //if (maxval != '') {
         //   maxval = parseFloat(maxval);
       // }
        
        maxval = maxval ? parseFloat(maxval) : undefined;

        var val = $('#EodCapActualVal_' + index).val();
        val = parseFloat(val);

        if (minval >= 0 && maxval >= 0) {
            //if (val != NaN) {
            if (!isNaN(val)) {
                if ((val >= minval) && (val <= maxval)) {
                    $("#EodCapStspass_" + index).prop('checked', true);
                    $("#EodCapStsfail_" + index).prop('checked', false);
                    $("#EodCapStsna_" + index).prop('checked', false);
                    $("#EodCapActualVal_" + index).css("background-color", "#fff");
                }
                else {
                    $("#EodCapStspass_" + index).prop('checked', false);
                    $("#EodCapStsfail_" + index).prop('checked', true);
                    $("#EodCapStsna_" + index).prop('checked', false);
                    $("#EodCapActualVal_" + index).css("background-color", "#e7f4ff");
                }
            }
            return $('input[name=status_' + index + ']:checked', '#EODCaptureForm').val()
        }
        else if ((minval == "" || minval == undefined || minval == null || minval == "NaN") && (maxval >= 0)) {
            if (val <= maxval) {
                $("#EodCapStspass_" + index).prop('checked', true);
                $("#EodCapStsfail_" + index).prop('checked', false);
                $("#EodCapStsna_" + index).prop('checked', false);
                $("#EodCapActualVal_" + index).css("background-color", "#fff");
            }
            else if (val > maxval) {
                $("#EodCapStspass_" + index).prop('checked', false);
                $("#EodCapStsfail_" + index).prop('checked', true);
                $("#EodCapStsna_" + index).prop('checked', false);
                $("#EodCapActualVal_" + index).css("background-color", "#e7f4ff");
            }
            return $('input[name=status_' + index + ']:checked', '#EODCaptureForm').val()
        }
        else if ((maxval == "" || maxval == undefined || maxval == null || maxval == NaN) && (minval >= 0)) {
            if (val < minval) {
                $("#EodCapStspass_" + index).prop('checked', false);
                $("#EodCapStsfail_" + index).prop('checked', true);
                $("#EodCapStsna_" + index).prop('checked', false);
                $("#EodCapActualVal_" + index).css("background-color", "#e7f4ff");
            }
            else if (val >= minval) {
                $("#EodCapStspass_" + index).prop('checked', true);
                $("#EodCapStsfail_" + index).prop('checked', false);
                $("#EodCapStsna_" + index).prop('checked', false);
                $("#EodCapActualVal_" + index).css("background-color", "#fff");
            }
            return $('input[name=status_' + index + ']:checked', '#EODCaptureForm').val()
        }
    }
    else {
        return $('input[name=status_' + index + ']:checked', '#EODCaptureForm').val()
    }
}
  

//****** Grid merging and Delete
function LinkClicked(id) {
    $(".content").scrollTop(1);
    $("#EODCaptureForm :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission) {
        action = "Edit"

    }
    else if (!hasEditPermission && hasViewPermission) {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#btnDelete').show();
    }

    if (action == 'View') {
        $("#EODCaptureForm :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    if (action == "Edit" || action == "View") {
        $('#EODCaptureTable').css('visibility', 'visible');
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/EODCapture/Get/" + primaryId)
          .done(function (result) {
              var getResult = JSON.parse(result);
              
              GetEODData(getResult);
              $('#hdnAttachId').val(getResult.HiddenId);
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
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/EODCapture/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('Type Code Mapping', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 EmptyFields();
             })
             .fail(function () {
                 showMessage('Type Code Mapping', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
        }

    });
}
function EmptyFields() {
    $(".content").scrollTop(0);
    $('input[type="text"], textarea').val('');
    $('#EODCapClassifi').val("null");
    $('#EODCapAssetNo').prop('disabled', false);
    $('#EodCapRecDate').prop('disabled', false);
       $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#grid").trigger('reloadGrid');
    $("#EODCaptureForm :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#EODCaptureTable').css('visibility', 'hidden');
    //$('#EODCaptureTable').empty();
    $("#EODCapFetchAddBtn").show();
    $('#EODCapNxtCapDt').prop('required', false);
    $('#EODCapNxtCapDt').prop('disabled', false);
    $('#EodCapnxtCapDiv').hide();
    var today = new Date();
    var CurDate = GetCurrentDate();
    var hour = today.getHours();
    var time = today.getMinutes();
    var time = time.toString();

    if (time.length == 1) {
        time = 0 + '' + time;
    }

    var gettime = hour + ":" + time;

    var CurDateTime = CurDate + " " + gettime;
    $('#EodCapRecDate').val(CurDateTime);
    $("#EODCapBody").empty();
}



