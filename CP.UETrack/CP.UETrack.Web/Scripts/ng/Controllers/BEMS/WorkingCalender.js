
var DayListFialData;
var MonthListFinal;

$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    //var MinimumStock = document.getElementById("Remarks");
    //MinimumStock.addEventListener('input', function (prev) {
    //    return function (evt) {
    //        if (!/^[a-zA-Z0-9+'.'&quot;,:;=/\(\),\-\s]+$/.test(this.value)) {
    //            this.value = prev;
    //        }
    //        else {
    //            prev = this.value;
    //        }
    //        };
    //}(MinimumStock.value), false);
    formInputValidation("WcformId")
    $('#tblWorkingCalender').hide();
    var CurrentYear = new Date().getFullYear();
    $.get("/api/WorkingCalender/Load/" + CurrentYear)
          .done(function (result) {
              $('#myPleaseWait').modal('hide');
              var loadResult = result;
              $.each(loadResult.Year, function (index, val) {
                  $('#YearId').append('<option value="' + val + '">' + val + '</option>');
              });
              $("#FacilityId").val(loadResult.FacilityId);

          })
    .fail(function () {
        $('#myPleaseWait').modal('hide');
        $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
    });



    $("#YearId").change(function () {
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('display', 'none');
        var intYear = $("#YearId").val();
        var CurrentYear = new Date().getFullYear();
        var intFacilityId = $("#FacilityId").val();
        var intCopyFromFacilityId = $("#FacilityId").val();
        if (intYear != null && intFacilityId != null) {
            $.get("/api/WorkingCalender/GetWorkingDay/" + intYear + "/" + intFacilityId + "/" + intCopyFromFacilityId)
           .done(function (result) {
               var getResult = result;
               displayRows(getResult);
               if (intYear >= CurrentYear ) {
                   $('#btnSave').show();
               }
               else {
                   $('#btnSave').hide();
               }
              
               $('#myPleaseWait').modal('hide');
           })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });
        }

    });

    function displayRows(getResult) {

        $('#tblWorkingCalender').show();
        var markup = '';
        $('#YearId').prop('disabled', true);
        // $('#daylt').val(JSON.stringify(getResult.DayList))
        $('#workingcalendarlistid').html(null);
        MonthListFinal = getResult.Month;
        DayListFialData = getResult.DayList;
        $("#primaryID").val(getResult.CalenderId);
        $("#Timestamp").val(getResult.Timestamp);
        for (var i = 0; i < MonthListFinal.length; i++) {
            markup += '<tr style="" class="trItem">';
            markup += '<td style="width:7%; text-align:Left;">' + MonthListFinal[i].FieldValue;
            markup += '</td>';
            // alert(getResult.Month[i].LovId);
            var Daylist = Enumerable.From(DayListFialData[i]).Where("$.Month==" + MonthListFinal[i].LovId).ToArray();
            for (var j = 0; j < Daylist.length; j++) {

                var IsDayTicked = (Daylist[j].IsWorking == true) ? "checked" : "";
                if (IsDayTicked)
                {
                    Daylist[j].Remarks = ''; 
                } 

                var isremarksexists = (Daylist[j].Remarks == "" || Daylist[j].Remarks == null) ? "" : 'background-color: #61B329;';
                markup += '<td style="width:3%;' + isremarksexists + '">' + Daylist[j].DayName;
                var IsWorking = (Daylist[j].IsWorking == true) ? "checked" : "";
                var IsWorkingDisabled = (Daylist[j].DaysCheck == true) ? "disabled" : "";
                markup += '<input type="checkbox" ' + 'onclick="UpdateWorkingDay(' + Daylist[j].Month + ',' + Daylist[j].Day + ')"' + IsWorking + ' ' + IsWorkingDisabled + ' name="chkRowCheckAll' + Daylist[j].Month + Daylist[j].Day + '" id="chkRowCheckAll' + Daylist[j].Month + Daylist[j].Day + '" title="' + Daylist[j].Remarks + '" />';
                markup += '</td>';
            }
            markup += '</tr>'
        }

        $('#workingcalendarlistid').append(markup);
    }
    //function displayRows(getResult) {

    //    $('#tblWorkingCalender').show();
    //    var markup = '';
    //    $('#YearId').prop('disabled', true);
    //    // $('#daylt').val(JSON.stringify(getResult.DayList))
    //    $('#workingcalendarlistid').html(null);
    //    MonthListFinal = getResult.Month;
    //    DayListFialData = getResult.DayList;
    //    $("#primaryID").val(getResult.CalenderId);
    //    $("#Timestamp").val(getResult.Timestamp);
    //    for (var i = 0; i < MonthListFinal.length; i++) {
    //        markup += '<tr style="" class="trItem">';
    //        markup += '<td style="width:7%; text-align:Left;">' + MonthListFinal[i].FieldValue;
    //        markup += '</td>';
    //        // alert(getResult.Month[i].LovId);
    //        var Daylist = Enumerable.From(DayListFialData[i]).Where("$.Month==" + MonthListFinal[i].LovId).ToArray();
    //        for (var j = 0; j < Daylist.length; j++) {

    //            var isremarksexists = (Daylist[j].Remarks == "" || Daylist[j].Remarks == null) ? "" : 'background-color: #61B329;';
    //            markup += '<td style="width:3%;'+ isremarksexists+'">' + Daylist[j].DayName;
    //            var IsWorking = (Daylist[j].IsWorking == true) ? "checked" : "";
    //            var IsWorkingDisabled = (Daylist[j].DaysCheck == true) ? "disabled" : "";
    //            markup += '<input type="checkbox" ' + 'onclick="UpdateWorkingDay(' + Daylist[j].Month + ',' + Daylist[j].Day + ')"' + IsWorking + ' ' + IsWorkingDisabled + ' name="chkRowCheckAll' + Daylist[j].Month + Daylist[j].Day + '" id="chkRowCheckAll' + Daylist[j].Month + Daylist[j].Day + '" title="' + Daylist[j].Remarks + '" />';
    //            markup += '</td>';
    //        }
    //        markup += '</tr>'
    //    }

    //    $('#workingcalendarlistid').append(markup);
    //}

    $('#btnAddNew').click(function () {
        window.location.reload();
    });

    $("#btnCancel").click(function () {
        window.location.href = "/home/index";
    });



    $("#btnSave").click(function () {
        $('#btnSave').attr('disabled', true);
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('display', 'none');
        var isFormValid = formInputValidation("WcformId", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('display', 'block');
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            //$('#btnEdit').attr('disabled', false);
            return false;
        }
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var rowCount = $('#tblDataTable tr').length;
        if (rowCount == 2) {
            DisplayErrorMessage(Messages.NO_RECORDS_TO_SAVE);
            return false;
        }
        //var dets = [];
        //for (var i = 0; i < MonthListFinal.length; i++) {
        //    var Daylist = Enumerable.From(DayListFialData[i]).Where("$.Month==" + MonthListFinal[i].LovId).ToArray();
        //    $.each(Daylist, function (index, value) {
        //        var obj = {
        //            Year: $('#YearId').val(),
        //            Month: value.Month,
        //            Day: value.Day,
        //            IsWorking: value.IsWorking,
        //            Remarks: value.Remarks
        //        };
        //        dets.push(obj);
        //    });
        //}

        var primaryId = $("#primaryID").val();

        var workingCalendarData = {
            CustomerId: 1,
            FacilityId: $('#FacilityId').val(),
            Year: $('#YearId').val(),
            CalenderId: primaryId,
            Month: MonthListFinal,
            DayDetails: DayListFialData,
            Timestamp: (primaryId != 0 ? $('#Timestamp').val() : null)
        };
        $('#myPleaseWait').modal('show');

        var jqxhr = $.post("/api/WorkingCalender/Add", workingCalendarData, function (response) {

            var getResult = response;
      
            displayRows(getResult);
            $(".content").scrollTop(0);
            showMessage('Working Calendar', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").show();
            setTimeout(function () {
                $("#top-notifications").hide();
            }, 5000);

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        },
       "json")
        .fail(function (response) {
            var errorMessage = "";
            if (response.status == 400) {
                errorMessage = response.responseJSON;
            }
            else {
                errorMessage = Messages.COMMON_FAILURE_MESSAGE;
            }
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');
            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
    });
});

function UpdateWorkingDay(month, day) {

    var iswor = ($('#chkRowCheckAll' + month + day).prop('checked') == false) ? false : true;
    //alert(DayListFialData[month-1][day-1].Month + ", " + DayListFialData[month-1][day-1].Day + " ," + DayListFialData[month-1][day-1].DayName);
    DayListFialData[month - 1][day - 1].IsWorking = iswor;
    //DayListFialData[month][day].Remarks = "jana";
    $('#remarksmonth').val(month);
    $('#remarksday').val(day);

    $('#Remarks').val("");
    $('#Remarks').val(DayListFialData[month - 1][day - 1].Remarks);
    $('#Remarks').focus();
    $('body').on('shown.bs.modal', '#preview', function () {
        $('input:visible:enabled:first', this).focus();
    })
    if (!iswor)
    {
        $('#preview').modal("show");
    }
    $('#Remarks').parent().removeClass('has-error');

}
function SaveRemarks() {
    var month = parseInt($('#remarksmonth').val());
    var day = parseInt($('#remarksday').val());
    // alert(month + "," + day);
   var rem = $('#Remarks').val();
   if (rem  != "") {
       DayListFialData[month - 1][day - 1].Remarks = $('#Remarks').val();
    }
    //DayListFialData[month - 1][day - 1].Remarks = $('#Remarks').val();
    if ($('#Remarks').val() != "" && $('#Remarks').val() != null && $('#Remarks').val().trim() != "") {
      $('#Remarks').parent().removeClass('has-error');
        $('#preview').modal("hide");

    }
    else {
        $('#Remarks').parent().addClass('has-error');
       
    }
   
}
function RemarksCancel() {

    var month = parseInt($('#remarksmonth').val());
    var day = parseInt($('#remarksday').val());
    //  alert(month + "," + day);   
    DayListFialData[month - 1][day - 1].IsWorking = DayListFialData[month - 1][day - 1].IsWorking == true ? false : true;

    $('#chkRowCheckAll' + month + day).prop('checked', DayListFialData[month - 1][day - 1].IsWorking);
    //$('#chkRowCheckAll' + month + day).checked = DayListFialData[month - 1][day - 1].IsWorking == true ? false : true;
    $('#preview').modal("hide");
    //DayListFialData[month][day].Remarks = $('#Remarks').val();
}



$(document).ready(function () {

    $("#Remarks").keydown(function () {
        //valid form when user enter data to "validationField" fields

        if ($('#Remarks').val() != "" && $('#Remarks').val() != null) {
            $('#Remarks').parent().removeClass('has-error');         

        }
       
    });

});