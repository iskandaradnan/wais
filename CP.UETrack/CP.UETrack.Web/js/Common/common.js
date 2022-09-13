window.UETrackConstants = {
    customerId: 0,
    facilityId: 0
}

//----------- Input validation ------------------------
var formInputValidation = function (formid, save) {


    var isFormValid = true;
    $.each($('#' + formid + ' :input'), function (index, value) {
        var ind = index;
        var val = value;
        var events = '';

        switch (value.type) {
            case "text":
            case "hidden":
            case "textarea":
            case "password":
                events = 'input propertychange paste';
                break;
            case "select-one":
                events = 'change';
                break;
            case "select-multiple":
                events = 'change';
                break;
        }
        if (value.type == "text" || value.type == "select-one" || value.type == "select-multiple" || value.type == "hidden"
            || value.type == "textarea" || value.type == "password") {
            if (save == "save") {
                if ($(this).prop('required')) {
                    if ($('#' + value.id).val() == "" || $('#' + value.id).val() == "null" || $('#' + value.id).val() == null || (value.type != "select-multiple" && $('#' + value.id).val().trim() == "")) {
                        $(this).parent().addClass('has-error');
                        isFormValid = false;
                    }
                    //else {
                    //    if ($(this).attr('id').indexOf('hdn') != 0)
                    //    $(this).parent().removeClass('has-error');
                    //}
                }

                if ($(this).attr('pattern') != "" && $(this).attr('pattern') != null) {
                    var regEx = $(this).attr('pattern')
                    if ($(this).val() != null && $(this).val() != "") {
                        // code to be written 

                        var inputClass = $(this).attr('class');
                        var decimalClass = "commaSeperator";
                        if (inputClass.indexOf(decimalClass) > -1) {

                            var value = $(this).val();
                            // value = value.replace(/[_\W]+/g, "");
                            value = value.split(',').join('');
                            if (!value.match(regEx)) {
                                $(this).parent().addClass('has-error');
                                isFormValid = false;
                            }

                        }
                        else {
                            if (!$(this).val().match(regEx)) {
                                $(this).parent().addClass('has-error');
                                isFormValid = false;
                            }
                        }
                    }
                }

            }
            else {
                if (value && value.id) {
                    $('#' + value.id).on(events, function (e) {

                        if ($(this).prop('required')) {
                            if (e.target.value == "" || e.target.value == "null" || e.target.value == null) {
                                $(this).parent().addClass('has-error');
                            }
                            else {
                                if ($(this).attr('id').indexOf('hdn') != 0)
                                    $(this).parent().removeClass('has-error');
                            }
                        }
                        if ($(this).attr('pattern') != "" && $(this).attr('pattern') != null) {
                            var regEx = $(this).attr('pattern')
                            if ($(this).val() != null && $(this).val() != "") {

                                // 

                                var inputClass = $(this).attr('class');
                                var decimalClass = "commaSeperator";
                                if (inputClass.indexOf(decimalClass) > -1) {
                                    var value = $(this).val();
                                    //value = value.replace(/[_\W]+/g, "");
                                    value = value.split(',').join('');
                                    if (!value.match(regEx)) {
                                        $(this).parent().addClass('has-error');
                                    }
                                    else {
                                        $(this).parent().removeClass('has-error');
                                    }

                                }
                                else {
                                    if (!$(this).val().match(regEx)) {
                                        $(this).parent().addClass('has-error');
                                    }
                                    else {
                                        $(this).parent().removeClass('has-error');
                                    }
                                }

                                //code to be written 

                            }
                            else {
                                if (!$(this).prop('required')) {
                                    $(this).parent().removeClass('has-error');
                                }
                            }
                        }
                    });
                }
            }
        }
    });
    return isFormValid;
}
//-----------------------------------------------------
 $('.commaSeperator').change(function () {
        var id = $(this).attr('id');
        var x = $('#' + id).val();

        $('#hdn_' + id).val(x);

        if (parseInt(x) > 0) {
            $('#' + id).val(addCommas(x));
        }

 });

 $('body').on('change', ".commaSeperator", function () {
     var id = $(this).attr('id');
     var x = $('#' + id).val();

     $('#hdn_' + id).val(x);

     if (parseInt(x) > 0) {
         $('#' + id).val(addCommas(x));
     }
 });

$(document).ready(function () {

    // Comma
   

    $('.commaSeperator').focusout(function () {
        var id = $(this).attr('id');
        var x = $('#' + id).val();

        $('#hdn_' + id).val(x);

        if (parseInt(x) > 0)
        {
            $('#' + id).val(addCommas(x));
        }
       
    });

    $('.commaSeperator').on('click', function (event) {
        // alert('hihi');
        var id = $(this).attr('id');
        var val = $('#' + id).val();
        var result = val.split(',').join('');
        // var result = val.replace(/[_\W]+/g, "");
        $('#' + id).val(result);
    });
    function addCommas(x) {
        var parts = x.toString().split(".");
        parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        return parts.join(".");
    }


    //Hide Input,select box for action type view
    if ($("#ActionType").val() == "VIEW") {
        $("form textarea,select,input:not(:button)").prop("disabled", true);
    }
    $('.datetimepicker').datetimepicker({
        //maxDate: Date(),
        format: 'd-M-Y',
        timepicker: false,
        step: 15,
        onChangeDateTime: function (dp, $input) {
            if ($input.val() !== "")
                $($input).parent().removeClass('has-error');
        },
        scrollInput: false
    });
    $('.myDateTimePicker').datetimepicker({
        format: 'dd.mm.yyyy',
        minView: 2,
        maxView: 4,
        autoclose: true
    });
    $('.datatimepickerNoFuture, .datatimeNoFuture, .datatimepickerFuture, .datatimeFuture,.bookingDate,.datetimePastOnly,.datatimeAll,.dateAll,.myDateTimePicker').focus(function () {
        $('body').addClass('no_scroll');
    })

    $('.datatimepickerNoFuture, .datatimeNoFuture, .datatimepickerFuture, .datatimeFuture,.bookingDate,.datetimePastOnly,.datatimeAll,.dateAll,.myDateTimePicker').blur(function () {
        $('body').removeClass('no_scroll');

    })
    $('.datatimeNoFuture, .datatimeFuture,.bookingDate,.datetimePastOnly,.datatimeAll,.dateAll').blur(function () {
        var id = $(this).attr('id');
        var m_names = { "Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "Jun": 6, "Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12 };
        var vala = $('#' + id).val();
        var actualval = vala.split(' ');
        var bits = actualval[0].split('-');
        var d = new Date(bits[2] + '-' + m_names[bits[1]] + '-' + bits[0]);
        // return ;

        if (actualval[1]) {
            var actualvalue = actualval[1].split(':');//? actualval[1].split(':') : '';
            // var hours = actualvalue[0]
            var condition = (!!actualvalue[0] && !!actualvalue[1] && !!parseInt(actualvalue[0]) && (!!parseInt(actualvalue[1]) || actualvalue[1] == "00") && (parseInt(actualvalue[0]) < 24) && (actualvalue[1] < 61));
            if (!!(d && (d.getMonth() + 1) == m_names[bits[1]] && d.getDate() == Number(bits[0])) && condition) {
                $('#' + id).val(vala);
                // alert(vala);

            }
            else {
                $('#' + id).val('');
            }
        }
        else {

            if (!!(d && (d.getMonth() + 1) == m_names[bits[1]] && d.getDate() == Number(bits[0]))) {
                $('#' + id).val(vala);
                // alert(vala);

            }
            else {
                $('#' + id).val('');
            }
        }
        //$('body').removeClass('no_scroll');

    });


    /*Added for setting current date when any changes done in date field*/
    $('.datatimeNoFutureCurr').blur(function () {
        var id = $(this).attr('id');
        var m_names = { "Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "Jun": 6, "Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12 };
        var vala = $('#' + id).val();
        var actualval = vala.split(' ');
        var bits = actualval[0].split('-');
        var d = new Date(bits[2] + '-' + m_names[bits[1]] + '-' + bits[0]);
        var today = new Date();
        // return ;

        if (actualval[1]) {
            var actualvalue = actualval[1].split(':');//? actualval[1].split(':') : '';
            // var hours = actualvalue[0]
            var condition = (!!actualvalue[0] && !!actualvalue[1] && !!parseInt(actualvalue[0]) && (!!parseInt(actualvalue[1]) || actualvalue[1] == "00") && (parseInt(actualvalue[0]) < 24) && (actualvalue[1] < 61));
            if (!!(d && (d.getMonth() + 1) == m_names[bits[1]] && d.getDate() == Number(bits[0])) && condition) {
                $('#' + id).val(vala);
                // alert(vala);

            }
            else {

                $('#' + id).val(today);
            }
        }
        else {

            if (!!(d && (d.getMonth() + 1) == m_names[bits[1]] && d.getDate() == Number(bits[0]))) {
                $('#' + id).val(vala);
                // alert(vala);

            }
            else {
                $('#' + id).val(today);
            }
        }

    });



    $('body').on('blur', '.datetime', function () {//.datatimeNoFuture,.datatimeFuture
        var id = $(this).attr('id');
        var m_names = { "Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "Jun": 6, "Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12 };
        var vala = $('#' + id).val();
        var bits = vala.split('-');
        var d = new Date(bits[2] + '-' + m_names[bits[1]] + '-' + bits[0]);
        // return ;
        if (!!(d && (d.getMonth() + 1) == m_names[bits[1]] && d.getDate() == Number(bits[0]))) {
            $('#' + id).val(vala);
            // alert(vala);

        }
        else {
            $('#' + id).val('');
        }
        $('body').removeClass('no_scroll');

    });


    $('body').on('blur', '.datetimeNoFuture', function () {//.datatimeNoFuture,.datatimeFuture
        var id = $(this).attr('id');
        var m_names = { "Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "Jun": 6, "Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12 };
        var vala = $('#' + id).val();
        var bits = vala.split('-');
        var d = new Date(bits[2] + '-' + m_names[bits[1]] + '-' + bits[0]);
        // return ;
        if (!!(d && (d.getMonth() + 1) == m_names[bits[1]] && d.getDate() == Number(bits[0]))) {
            $('#' + id).val(vala);
            // alert(vala);

        }
        else {
            $('#' + id).val('');
        }
        $('body').removeClass('no_scroll');
    });


    $('body').on('blur', '.datetimePastOnly', function () {//.datatimeNoFuture,.datatimeFuture
        var id = $(this).attr('id');
        var m_names = { "Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "Jun": 6, "Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12 };
        var vala = $('#' + id).val();
        var bits = vala.split('-');
        var d = new Date(bits[2] + '-' + m_names[bits[1]] + '-' + bits[0]);
        if (!!(d && (d.getMonth() + 1) == m_names[bits[1]] && d.getDate() == Number(bits[0]))) {
            $('#' + id).val(vala);
        }
        else {
            $('#' + id).val('');
        }
    });

    $('body').on('blur', '.dateAll', function () {//.datatimeNoFuture,.datatimeFuture
        var id = $(this).attr('id');
        var m_names = { "Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "Jun": 6, "Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12 };
        var vala = $('#' + id).val();
        var bits = vala.split('-');
        var d = new Date(bits[2] + '-' + m_names[bits[1]] + '-' + bits[0]);
        if (!!(d && (d.getMonth() + 1) == m_names[bits[1]] && d.getDate() == Number(bits[0]))) {
            $('#' + id).val(vala);
        }
        else {
            $('#' + id).val('');
        }
    });
    //Allow past dates 
    //disable future dates 
    $('.datatimeNoFuture').datetimepicker({
        maxDate: Date(),
        format: 'd-M-Y',
        timepicker: false,
        step: 15,
        onChangeDateTime: function (dp, $input) {
            if ($input.val() !== "")
                $($input).parent().removeClass('has-error');
        },
        scrollInput: false
    });
    //added by vijay
    //Allow pFutureast dates 
    //disable past dates 
    $('.datatimeFuture').datetimepicker({
        minDate: Date(),
        format: 'd-M-Y',
        timepicker: false,
        step: 15,
        onChangeDateTime: function (dp, $input) {
            if ($input.val() !== "")
                $($input).parent().removeClass('has-error');
        },
        scrollInput: false
    });



    $('.datatimeAll').datetimepicker({
        //minDate: Date(),
        format: 'd-M-Y H:i',
        timepicker: true,
        onChangeDateTime: function (dp, $input) {
            if ($input.val() !== "") {
                $($input).parent().removeClass('has-error');
                $input.val(ReplaceInvalidMinute($input.val()));
            }
        },
        scrollInput: false
    });

    $('.dateAll').datetimepicker({
        //minDate: Date(),
        format: 'd-M-Y',
        timepicker: false,
        onChangeDateTime: function (dp, $input) {
            if ($input.val() !== "") {
                $($input).parent().removeClass('has-error');
                $input.val(ReplaceInvalidMinute($input.val()));
            }
        },
        scrollInput: false
    });

    $('.datatimepickerFuture').datetimepicker({
        minDate: Date(),
        format: 'd-M-Y H:i',
        timepicker: true,
        onChangeDateTime: function (dp, $input) {
            if ($input.val() !== "") {
                $($input).parent().removeClass('has-error');
                $input.val(ReplaceInvalidMinute($input.val()));
            }
        },
        scrollInput: false
    });

    $('.datatimepickerNoFuture').datetimepicker({
        maxDate: Date(),
        format: 'd-M-Y H:i',
        timepicker: true,
        onChangeDateTime: function (dp, $input) {
            if ($input.val() !== "") {
                $($input).parent().removeClass('has-error');
                $input.val(ReplaceInvalidMinute($input.val()));
            }
        },
        scrollInput: false
    });

    $('.datatimepicker').datetimepicker({
        format: 'd-M-Y H:i',
        timepicker: true,
        onChangeDateTime: function (dp, $input) {
            if ($input.val() !== "") {
                $($input).parent().removeClass('has-error');
                $input.val(ReplaceInvalidMinute($input.val()));
            }
        },
        scrollInput: false
    });

    $('.datatimeNoFutureCurr').datetimepicker({
        maxDate: Date(),
        format: 'd-M-Y',
        timepicker: false,
        step: 15,
        onChangeDateTime: function (dp, $input) {
            if ($input.val() !== "")
                $($input).parent().removeClass('has-error');
        },
        scrollInput: false
    });

    function ReplaceInvalidMinute(dateTimeValue) {
        var indexOfColon = dateTimeValue.indexOf(':');
        var substr = dateTimeValue.substring(indexOfColon + 1);
        if (parseInt(substr) >= 60) {
            dateTimeValue = dateTimeValue.replace(substr, "00");
        }
        return dateTimeValue;
    }

    $('body').on('click', ".datetime", function () {
        $(this).datetimepicker({
            format: 'd-M-Y',
            timepicker: false,
            step: 15,
            scrollInput: false,
            onChangeDateTime: function (dp, $input) {
                if ($input.val() !== "")
                    $($input).parent().removeClass('has-error');
            }
        });
        $(this).datetimepicker('show');
        $('body').addClass('no_scroll');
    });

    $('body').on('click', ".datetimeNoFuture", function () {
        $(this).datetimepicker({
            format: 'd-M-Y',
            timepicker: false,
            step: 15,
            scrollInput: false,
            minDate: Date(),
            onChangeDateTime: function (dp, $input) {
                if ($input.val() !== "")
                    $($input).parent().removeClass('has-error');
            }
        });
        $(this).datetimepicker('show');
        $('body').addClass('no_scroll');
    });
    $('body').on('click', ".datatimepicker", function () {
        $(this).datetimepicker({
            format: 'd-M-Y H:i',
            timepicker: true,
            step: 15,
            scrollInput: false,
            onChangeDateTime: function (dp, $input) {
                if ($input.val() !== "")
                    $($input).parent().removeClass('has-error');
            }
        });
        $(this).datetimepicker('show');
    });

    $('body').on('click', ".datatimepickerNoFut", function () {
        $(this).datetimepicker({
            format: 'd-M-Y H:i',
            timepicker: true,
            step: 15,
            scrollInput: false,
            maxDate: Date(),
            onChangeDateTime: function (dp, $input) {
                if ($input.val() !== "")
                    $($input).parent().removeClass('has-error');
            }
        });
        $(this).datetimepicker('show');
    });

    $('body').on('click', ".datetimePastOnly", function () {
        $(this).datetimepicker({
            format: 'd-M-Y',
            timepicker: false,
            step: 15,
            scrollInput: false,
            maxDate: Date(),
            onChangeDateTime: function (dp, $input) {
                if ($input.val() !== "")
                    $($input).parent().removeClass('has-error');
            }
        });
        $(this).datetimepicker('show');
    });

    $('.fa fa-home').on('click', function () {
        $('.fa fa-home').removeAttr("href");
        window.location.href = "/home/dashboard";
    })
    $('body').on('blur', ".form-control", function () {
        var id = $(this).attr('id');
        var val = $('#' + id).val();
        var result = $.trim(val);
        // var result = val.replace(/[_\W]+/g, "");
        $('#' + id).val(result);
        //console.log(result);
          if ($(this).attr('pattern') != "" && $(this).attr('pattern') != null) {
            var regEx = $(this).attr('pattern')
            if ($(this).val() != null && $(this).val() != "") {

                // 

                var inputClass = $(this).attr('class');
                var decimalClass = "commaSeperator";
                if (inputClass.indexOf(decimalClass) > -1) {
                    var value = $(this).val();
                    //value = value.replace(/[_\W]+/g, "");
                    value = value.split(',').join('');
                    if (!value.match(regEx)) {
                        $(this).parent().addClass('has-error');
                    }
                    else {
                        $(this).parent().removeClass('has-error');
                    }

                }
                else {
                    if (!$(this).val().match(regEx)) {
                        $(this).parent().addClass('has-error');
                    }
                    else {
                        $(this).parent().removeClass('has-error');
                    }
                }

                //code to be written 

            }
            else {
                if (!$(this).prop('required')) {
                    $(this).parent().removeClass('has-error');
                }
            }
        }
    });
    $('.form-control').blur(function () {
        var id = $(this).attr('id');
        var val = $('#' + id).val();
        var result = $.trim(val);
        // var result = val.replace(/[_\W]+/g, "");
        $('#' + id).val(result);
        //console.log(result);
        if ($(this).attr('pattern') != "" && $(this).attr('pattern') != null) {
            var regEx = $(this).attr('pattern')
            if ($(this).val() != null && $(this).val() != "") {

                // 

                var inputClass = $(this).attr('class');
                var decimalClass = "commaSeperator";
                if (inputClass.indexOf(decimalClass) > -1) {
                    var value = $(this).val();
                    //value = value.replace(/[_\W]+/g, "");
                    value = value.split(',').join('');
                    if (!value.match(regEx)) {
                        $(this).parent().addClass('has-error');
                    }
                    else {
                        $(this).parent().removeClass('has-error');
                    }

                }
                else {
                    if (!$(this).val().match(regEx)) {
                        $(this).parent().addClass('has-error');
                    }
                    else {
                        $(this).parent().removeClass('has-error');
                    }
                }

                //code to be written 

            }
            else {
                if (!$(this).prop('required')) {
                    $(this).parent().removeClass('has-error');
                }
            }
        }
    });



});

//Common Delete check all for Detail Grid
//function IsDeleteCheckAll(tbodyId, IsDeleteHeaderId) {

//    var Isdeleted_ = [];
//    tbodyId = '#' + tbodyId.id + ' tr';
//    IsDeleteHeaderId = "#" + IsDeleteHeaderId.id;

//    $(tbodyId).map(function (index, value) {
//        var Isdelete = $("#Isdeleted_" + index).is(":checked");
//        if (Isdelete)
//            Isdeleted_.push(Isdelete);
//    });

//    if ($(tbodyId).length == Isdeleted_.length)
//        $(IsDeleteHeaderId).prop("checked", true);
//    else
//        $(IsDeleteHeaderId).prop("checked", false);
//}

/* Function to check and uncheck checkbox based on disabled checkbox condition */

function IsDeleteCheckAll(tbodyId, IsDeleteHeaderId) {

    var count = 0;
    var Isdeleted_ = [];
    tbodyId = '#' + tbodyId.id + ' tr';
    IsDeleteHeaderId = "#" + IsDeleteHeaderId.id;

    $(tbodyId).map(function (index, value) {
        if ($("#Isdeleted_" + index).prop("disabled")) {
            count++;
        }
        var Isdelete = $("#Isdeleted_" + index).is(":checked");
        if (Isdelete)
            Isdeleted_.push(Isdelete);
    });

    var rowlen = ($(tbodyId).length) - (count)

    if (rowlen == Isdeleted_.length)
        $(IsDeleteHeaderId).prop("checked", true);
    else
        $(IsDeleteHeaderId).prop("checked", false);
}

//Dependecy Dropdown Fill for Year and Month
function GetYearMonth(YearValue) {
    var date = new Date();
    YearValue = !YearValue ? date.getFullYear() : YearValue;

    var YearData = [(date.getFullYear() - 1), date.getFullYear()];
    var MonthData = [{ 1: "January" }, { 2: "February" }, { 3: "March" }, { 4: "April" }, { 5: "May" }, { 6: "June" }, { 7: "July" }, { 8: "August" }, { 9: "September" }, { 10: "October" }, { 11: "November" }, { 12: "December" }];

    if (date.getFullYear() == YearValue)
        MonthData = MonthData.slice(0, date.getMonth() + 1);

    return { YearData: YearData, MonthData: MonthData }
}

function CreateDateTimeObject(dateTimeObject) {
    var newDateTimeObj = new Date(dateTimeObject);
    var month = parseInt(newDateTimeObj.getMonth()) + 1;
    if (month.toString().length == 1) month = "0" + month.toString();
    var hour = newDateTimeObj.getHours();
    if (hour.toString().length == 1) hour = "0" + hour.toString();
    var minutes = newDateTimeObj.getMinutes();
    if (minutes.toString().length == 1) minutes = "0" + minutes.toString();
    var returnObj = newDateTimeObj.getFullYear() + "-" + month + "-" + newDateTimeObj.getDate() + "T" + hour + ":" + minutes;
    return returnObj;
}

//Format as DD-MMM-YYYY
function DateFormatter(formatToDate) {
    var m_names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    var d = new Date(formatToDate);
    var format_date = ("0" + d.getDate()).slice(-2);
    var format_month = d.getMonth();
    var format_year = d.getFullYear();

    return (!formatToDate ? "" : (format_date + "-" + m_names[format_month] + "-" + format_year));
}
function DateTimeFormatter(formatToDate) {
    var m_names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    var d = new Date(formatToDate);
    var format_date = ("0" + d.getDate()).slice(-2);
    var format_month = d.getMonth();
    var format_year = d.getFullYear();
    var hours = d.getHours();
    var min = d.getMinutes();

    return (!formatToDate ? "" : (format_date + "-" + m_names[format_month] + "-" + format_year + " " + hours + ":" + ((min < 11) ? ("0") + min : min)));
}


function getDateToCompare(inputDate) {
    var m_names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    var dateArray = inputDate.split("-");

    var year = dateArray[2];
    var pos = getPosition(m_names, dateArray[1]);
    var month = pos + 1;
    var date = dateArray[0];
    var formattedDate = new Date(year, month, date);

    return formattedDate;


}

function getPosition(arrayName, arrayItem) {
    for (var i = 0; i < arrayName.length; i++) {
        if (arrayName[i] == arrayItem) {
            return i;
        }

    }
}
// To Get Current Date
function GetCurrentDate() {
    var m_names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    var d = new Date();
    var format_date = ("0" + d.getDate()).slice(-2);
    var format_month = d.getMonth();
    var format_year = d.getFullYear();

    return format_date + "-" + m_names[format_month] + "-" + format_year;
}


$(function () {
    //Allow special characters like ‘Space’, ‘-‘, ‘/’ and ‘()’
    $('.nameVal').keypress(function (e) {
        var regex = new RegExp("^[a-zA-Z0-9\\-\(\)\/\\s]+$");
        var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
        if (regex.test(str)) {
            return true;
        }
        e.preventDefault();
        return false;
    });

    // Allow special characters like  ‘-‘ and  ‘/’
    $('.codeVal').keypress(function (e) {
        var regex = new RegExp("^[a-zA-Z0-9\\-\/\]+$");
        var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
        if (regex.test(str)) {
            return true;
        }
        e.preventDefault();
        return false;
    });

    // Allow digits only ‘/’
    $('.digOnly').keypress(function (e) {
        var regex = new RegExp("^[0-9]*$");
        var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
        if (regex.test(str)) {
            return true;
        }
        e.preventDefault();
        return false;
    });

    $('.decimalPointonly').keypress(function (e) {
        var regex = new RegExp("^[0-9.]*$");
        var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
        if (regex.test(str)) {
            return true;
        }
        e.preventDefault();
        return false;
    });


    //Allow Special characters like space '-','( )','/'
    $('.name').keypress(function (e) {
        if ((e.charCode < 97 || e.charCode > 122) && (e.charCode < 48 || e.charCode > 57) && (e.charCode < 65 || e.charCode > 90) && (e.charCode != 32) && (e.charCode != 45) && (e.charCode != 47) && (e.charCode < 40 || e.charCode > 42) && (e.charCode != 0))
            return false;
    });

    $('.name').on('paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^&*_+|\\:{}\[\];-?<>\^\"\']/g, ''));
        }, 5);
    });
    //Allow Special characters Like '/','-'
    $('.documentno').keypress(function (e) {
        if ((e.charCode < 97 || e.charCode > 122) && (e.charCode < 48 || e.charCode > 57) && (e.charCode < 65 || e.charCode > 90) && (e.charCode != 45) && (e.charCode != 47) && (e.charCode != 0))
            return false;
    });
    $('.documentno').on('paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/ [~`!@#$%^&*_+|\\:{}\[\];-?<>\^\"\'] /g, ''));
        }, 5);
    });
    $('.avoidPaste').on('paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/\s/g, ''));
        }, 5);
    });
    $('.description').keypress(function (e) {
        if ((e.charCode < 97 || e.charCode > 122) && (e.charCode < 48 || e.charCode > 57) && (e.charCode < 65 || e.charCode > 90) && (e.charCode != 32) && (e.charCode < 44 || e.charCode > 46) && (e.charCode < 40 || e.charCode > 41) && (e.charCode = 38) && (e.charCode != 34) && (e.charCode != 39) && (e.charCode != 38) && (e.charCode != 0))
            return false;
    });

    $('.description').on('paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^*_+|\\:{}\[\];-?<>\^\"\'\/]/g, ''));
        }, 5);
    });

    $('.address').keypress(function (e) {
        if ((e.charCode < 97 || e.charCode > 122) && (e.charCode < 48 || e.charCode > 57) && (e.charCode < 65 || e.charCode > 90) && (e.charCode != 32) && (e.charCode < 44 || e.charCode > 46) && (e.charCode != 47) && (e.charCode != 58) && (e.charCode != 0))
            return false;
    });

    $('.address').on('paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^&*_+|\\{}\[\];-?<>\^\"\']/g, ''));
        }, 5);
    });
    $('.telephoneno').keypress(function (e) {
        if ((e.charCode < 97 || e.charCode > 122) && (e.charCode < 48 || e.charCode > 57) && (e.charCode < 65 || e.charCode > 90) && (e.charCode != 43) && (e.charCode != 45) && (e.charCode < 40 || e.charCode > 42) && (e.charCode != 0))
            return false;
    });
    $('.telephoneno').on('paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^&*_|\\{}\[\];-?<>\^\"\']/g, ''));
        }, 5);
    });

    $('.email').keypress(function (e) {
        if ((e.charCode < 97 || e.charCode > 122) && (e.charCode < 48 || e.charCode > 57) && (e.charCode < 65 || e.charCode > 90) && (e.charCode != 46) && (e.charCode != 95) && (e.charCode != 64) && (e.charCode != 0))
            return false;
    });
    $('.email').on('paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^&*|\\{}\[\];-?<>\^\"\']/g, ''));
        }, 5);
    });
    $('.website').keypress(function (e) {
        if ((e.charCode < 97 || e.charCode > 122) && (e.charCode < 48 || e.charCode > 57) && (e.charCode < 65 || e.charCode > 90) && (e.charCode != 45) && (e.charCode != 47) && (e.charCode != 46) && (e.charCode != 58) && (e.charCode != 0))
            return false;
    });
    $('.website').on('paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^&*_+|\\{}\[\];?<>\^\"\']/g, ''));
        }, 5);
    });

    $('.remarks').keypress(function (e) {
        if ((e.charCode < 97 || e.charCode > 122) && (e.charCode < 48 || e.charCode > 57) && (e.charCode < 65 || e.charCode > 90) && (e.charCode != 32) && (e.charCode < 44 || e.charCode > 46) && (e.charCode < 40 || e.charCode > 41) && (e.charCode != 34) && (e.charCode != 39) && (e.charCode != 38) && (e.charCode != 58) && (e.charCode != 59) && (e.charCode != 0))
            return false;
    });
    $('.remarks').on('paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^*_+|\\{}\[\] ?<>\^\"\'\=\/]/g, ''));
        }, 5);
    });


})

function AssetTabEventChange(DivId) {
    var Div = "#" + DivId;
    $('Div').children().each(function () {
        $(this).on('keyup', function () {
            if ($(this).data('c_val') != $(this).val()) {
                alert('value changed!');
                //bootbox.alert()
                //do other stuff
            }
            $(this).data('c_val', $(this).val());
        }).data('c_val', $(this).val());
    });
}
function GetDefaultId(LovList) {//Returns Index with IsDefault==true
    var _Select = 0;
    if (LovList == null || LovList.length == 0)
        return 0;

    for (var i = 0; i < LovList.length; i++) {
        if (LovList[i].IsDefault) {
            return (i);
        }
        else if (LovList[i].FieldValue == 'Select') {
            _Select = i;
        }


    }
    return _Select;

}

function GetSelectVal(list) {//to get the index of the list with FieldValue As "Select"

    var _Select = 0;
    for (var i = 0; i < list.length; i++) {

        if (list[i].FieldValue == 'Select') {
            _Select = i;
        }


    }
    return _Select;

}



function GetDefaultLovId(LovList) {//Returns Index with IsDefault==true
    var _Select = 0;
    if (LovList == null || LovList.length == 0)
        return 0;

    for (var i = 0; i < LovList.length; i++) {
        if (LovList[i].IsDefault) {
            return (LovList[i].LovId);
        }
        if (LovList[i].FieldValue == 'Select') {
            _Select = i;
        }


    }
    return LovList[_Select].LovId;

}

$(function () {
    $("#advanceSearch").on("click", function () {
        $("#searchmodfbox_grid").toggle();
    });
});


$("#top-notifications .glyphicon-remove").click(function () {
    $("#top-notifications").modal('hide');
});

$(function () {
    var search = $("#advanceSearch").length;
    if (search > 0) {
        $("#searchmodfbox_grid").hide();
    }
});

$('#jQGridCollapse1').on('click', function () {
    var plus = $('#iJQGridIndicator1').hasClass('glyphicon-plus');
    var minus = $('#iJQGridIndicator1').hasClass('glyphicon-minus');
    if (plus) {
        $('#iJQGridIndicator1').addClass('glyphicon-minus').removeClass('glyphicon-plus');
    }
    if (minus) {
        $('#iJQGridIndicator1').addClass('glyphicon-plus').removeClass('glyphicon-minus');
    }
});
//Ticket
$(function () {
    $("#advanceSearchTicket").on("click", function () {
        $("#searchmodfbox_gridTicket").toggle();
    });
});
$(function () {
    var search = $("#advanceSearchTicket").length;
    if (search > 0) {
        $("#searchmodfbox_gridTicket").hide();
    }
});
//Ticket

//Asset
$(function () {
    $("#advanceSearchAsset").on("click", function () {
        $("#searchmodfbox_gridAsset").toggle();
    });
});
$(function () {
    var search = $("#advanceSearchAsset").length;
    if (search > 0) {
        $("#searchmodfbox_gridAsset").hide();
    }
});
//Asset

/* Added by Hazarath to support dd/MMM/yyyy date formats

/*
    To convert dd/mm/yyyy format to mm/dd/yyyy date format
*/
function convertToDataBaseDateFormatMMM(date) {

    if (typeof date == 'undefined' || date == null) {
        return null;
    }
    if (typeof date == 'object' && date != null) {
        return date;
    }
    else {

        // Nullable date format coming like dd/mm/yyyyT0. so converting to iso format dd/mm/yyyyT00:00:00
        if (date.length == 12) {
            date = date.replace(/\//g, "-");
            date = date + "0:00:00";
        }
        var utcDate = new Date(Date.UTC(new Date(date).getFullYear(), new Date(date).getMonth(), new Date(date).getDate(), 0, 0, 0));
        //var date = new Date(from[2], from[1] - 1, from[0]);
        //date.setDate(date.getDate() + 1);
        return utcDate;
    }
}


function convertDateObjectToDisplayFormatMMM(dateObject) {

    var dd = dateObject.getDate();
    var mm = dateObject.getMonth(); //January is 0!

    var yyyy = dateObject.getFullYear();
    if (dd < 10) {
        dd = '0' + dd
    }
    if (mm < 10) {
        mm = '0' + mm
    }
    var today = dd + '-' + mm + '-' + yyyy;
    console.log(today);
    return new Date(Date.UTC(yyyy, mm, dd, 0, 0, 0));
    // return convertToDataBaseDateFormat(today);
}

/*
    To convert dd/mm/yyyy format to mm/dd/yyyy date format
*/
function convertToDataBaseDateFormat(date) {

    var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    var DateNew = date.split('-');
    var Month = new Date(DateNew);
    var DynMonth = parseInt(Month.getMonth()) + 1;

    if (typeof date == 'undefined' || date == null) {
        return null;
    }
    if (typeof date == 'object' && date != null) {
        return date;
    }
    else {
        from = date.split("-");
        from[1] = DynMonth;
        var utcDate = new Date(Date.UTC(from[2], from[1] - 1, from[0], 0, 0, 0));
        //var date = new Date(from[2], from[1] - 1, from[0]);
        //date.setDate(date.getDate() + 1);
        // var utcDate = new Date(Date.UTC(new Date(date).getFullYear(), new Date(date).getMonth(), new Date(date).getDate(), 0, 0, 0));
        return utcDate;
    }
}


function convertToDataBaseDateFormatCustom(date) {


    var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    var DateNew = date.split('-');
    var Month = new Date(DateNew);
    var DynMonth = parseInt(Month.getMonth()) + 1;


    if (typeof date == 'undefined' || date == null) {
        return null;
    }
    if (typeof date == 'object' && date != null) {
        return date;
    }
    else {
        from = date.split("-");
        from[1] = DynMonth;

        var utcDate = new Date(Date.UTC(from[2], from[1] - 1, from[0], 0, 0, 0));
        //var date = new Date(from[2], from[1] - 1, from[0]);
        //date.setDate(date.getDate() + 1);
        //var utcDate = new Date(Date.UTC(new Date(date).getFullYear(), new Date(date).getMonth(), new Date(date).getDate(), 0, 0, 0));
        return utcDate;
    }
}
function DateDisplayJqGrid(date) {
    var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    if (typeof date == 'undefined' || date == null) {
        return null;
    }
    if (typeof date == 'object' && date != null) {
        return date;
    }
    else {
        var NewDate = date.split('/');
        var year = NewDate[2].split(' ');
        var NewdateValue = NewDate[0] + "-" + monthNames[parseInt(NewDate[1] - 1)] + "-" + year[0];
        return NewdateValue;
    }
}
/*
   To convert dd/mm/yyyy H:i format to dd/mm/yyyy date format
*/
function convertToDisplayDateFormat(date) {

    if (typeof date == 'undefined' || date == null) {
        return null;
    }
    else {
        return date.substr(0, 10);
    }
}


function getDate() {
    var today = moment(new Date()).format("DD-MMM-YYYY");
    $("#todayDate").text(today);
    return today;

}

function convertDateObjectToDisplayFormat(dateObject) {

    var dd = dateObject.getDate();
    var mm = dateObject.getMonth() + 1; //January is 0!

    var yyyy = dateObject.getFullYear();
    if (dd < 10) {
        dd = '0' + dd
    }
    if (mm < 10) {
        mm = '0' + mm
    }
    var today = dd + '-' + mm + '-' + yyyy;
    return today;
    // return convertToDataBaseDateFormat(today);
}

// Add function

function addRow(tableID) {

    var table = document.getElementById(tableID);
    var rowCount = table.rows.length;
    var row = table.insertRow(rowCount);
    var colCount = table.rows[0].cells.length;
    for (var i = 0; i < colCount; i++) {
        var newcell = row.insertCell(i);
        newcell.innerHTML = table.rows[1].cells[i].innerHTML;
        newcell.childNodes[1].id = newcell.childNodes[1].id + "_" + rowCount;
        //var att = document.createAttribute("ng-model");
        //att.value = "attachmentTable."+newcell.childNodes[1].id;
        //newcell.childNodes[1].setAttributeNode(att);
        switch (newcell.childNodes[1].type) {
            case "text": newcell.childNodes[1].value = "";

                break;
            case "checkbox": newcell.childNodes[1].checked = false;
                break;
            case "select-one": newcell.childNodes[1].selectedIndex = 0;
                break;
        }
    }
    dateTimeCalendar();

}

// Delete Function

function deleteRow(tableID) {

    try {
        var table = document.getElementById(tableID);
        var rowCount = table.rows.length;
        for (var i = 1; i < rowCount; i++) {
            var row = table.rows[i];
            var chkbox = row.cells[0].childNodes[1].childNodes[1].childNodes[1];
            if (null != chkbox && true == chkbox.checked) {
                if (rowCount <= 2) {
                    alert("Cannot delete all the rows.");
                    break;
                }
                table.deleteRow(i);
                rowCount--;
                i--;
            }
        }
    }
    catch (e) {
        alert(e);
    }
}


function setMenuCount() {

    $(".navigable li.with-right-arrow").each(function () {

        var menuCount = $(this).children('.big-menu').find('li').not('.with-right-arrow').length;
        $(this).find('.list-count').text(menuCount);
    });

}
function EffectivedateTime() {

    $('.dateCalendar').each(function () {

        $(this).datetimepicker({
            timepicker: false,
            // minDate: 0,
            format: 'd-m-Y',
            //format: 'm/d/Y',
            scrollInput: false
        });
    })


    $('.dateCalendar').each(function () {

        $(this).datetimepicker({
            timepicker: false,
            // minDate: 0,
            format: 'd-m-Y',
            //format: 'm/d/Y',
            scrollInput: false
        });
    })

    $('.timeCalendar').each(function () {

        $(this).datetimepicker({
            datepicker: false,
            // minTime: 0,
            format: 'H:i',
            step: 15,
            scrollInput: false
        });
    })

    $('.dateTimeCalendar').each(function () {

        $(this).datetimepicker({
            minTime: 0,
            minDate: 0,
            format: 'd-m-Y H:i',
            // format: 'm/d/Y H:i',
            step: 15,
            scrollInput: false

        });
    })

}

function dateTimeCalendar() {

    initializeMMMDateControls();



    $('.dateCalendar').each(function () {

        $(this).datetimepicker({
            timepicker: false,
            minDate: 0,
            format: 'd-M-Y',
            //format: 'm/d/Y',
            scrollInput: false
        });
    })
    $('.dateEffectiveCalendar').each(function () {

        $(this).datetimepicker({
            timepicker: false,
            // minDate: 0,
            format: 'd-m-Y',
            //format: 'm/d/Y',
            scrollInput: false
        });
    })
    $('.dateCalendarFuture').each(function () {

        $(this).datetimepicker({
            timepicker: false,
            maxDate: 0,
            format: 'd-m-Y',
            //format: 'm/d/Y',
            scrollInput: false
        });
    })
    $('.dateCalendarpast').each(function () {

        $(this).datetimepicker({
            timepicker: false,
            maxDate: 0,
            format: 'd/m/Y',
            //format: 'm/d/Y',
            scrollInput: false
        });
    })
    $('.timeCalendar').each(function () {

        $(this).datetimepicker({
            datepicker: false,
            // minTime: 0,
            format: 'H:i',
            step: 15,
            scrollInput: false
        });
    })

    $('.dateTimeCalendar').each(function () {

        $(this).datetimepicker({
            minTime: 0,
            minDate: 0,
            format: 'd-m-Y H:i',
            // format: 'm/d/Y H:i',
            step: 15,
            scrollInput: false

        });

    })


    $('.dateTimePastCalendar').each(function () {

        $(this).datetimepicker({
            maxDate: 0,
            format: 'd-m-Y H:i',
            // format: 'm/d/Y H:i',
            step: 15,
            scrollInput: false

        });

    })

    $('.dateTimeCalendarPast').each(function () {

        $(this).datetimepicker({
            //minTime: 0,

            //minDate: 0,
            format: 'd-m-Y H:i',
            // format: 'm/d/Y H:i',
            step: 15,
            scrollInput: false

        });
    })

    $('.dateTimeCalendarFuture').each(function () {

        $(this).datetimepicker({
            //minTime: 0,
            //minDate: 0,
            maxDate: 0,
            format: 'd-m-Y H:i',
            // format: 'm/d/Y H:i',
            step: 15,
            scrollInput: false

        });
    })

    $('.dateCalendarAll').each(function () {

        $(this).datetimepicker({
            timepicker: false,
            format: 'd-m-Y',
            step: 15,
            scrollInput: false

        });
    })

    $('.dateTimeCalendarAll').each(function () {

        $(this).datetimepicker({
            format: 'd-m-Y H:i',
            step: 15,
            scrollInput: false

        });
    })


    $('.decimalValidation').each(function (index) {
        $(this).attr('id', 'rentalSpace_' + index);
        var FloorArea = document.getElementById(this.id);
        FloorArea.addEventListener('input', function (prev) {
            return function (evt) {
                if ((!/^\d{0,10}(?:\.\d{0,2})?$/.test(this.value)) || this.value.length > 11) {
                    this.value = prev;
                }
                else {
                    prev = this.value;
                }
            };
        }(FloorArea.value), false);
    })

    $('.dateCalendaryear').each(function () {
        $(this).datetimepicker({
            timepicker: false,
            changeYear: false,
            minDate: new Date((new Date).getFullYear(), 0, 1),
            maxDate: new Date((new Date).getFullYear(), 11, 31),
            format: 'd-m-Y',
            yearStart: (new Date).getFullYear(),
            yearEnd: (new Date).getFullYear(),
            monthStart: 0,
            monthEnd: 11,
            prevButton: false,
            nextButton: false,
            onChangeDateTime: function (date, $el) {
                var selectYear = date.getFullYear();

                if (selectYear != (new Date).getFullYear())
                { $el.context.value = ""; }
                //d is selected date.
                //var m = date.getMonth() + 1; //+1 because .getMonth() returns 0-11
                //m is selected month.
                //console.log(date)
                //console.log($el)
            }
        });
    })

    $('.dateCalendarNextDay').each(function () {

        $(this).datetimepicker({
            timepicker: false,
            minDate: new Date((new Date).getFullYear(), (new Date).getMonth(), (new Date).getDate() + 1),
            format: 'd-m-Y',
            //format: 'm/d/Y',
            scrollInput: false
        });
    })

}

function initializeMMMDateControls() {

    /* Added By Hazarath */

    $('.mmmdateCalendarFuture').each(function () {

        $(this).datetimepicker({
            timepicker: false,
            maxDate: 0,
            format: 'd-M-Y',
            //format: 'm/d/Y',
            scrollInput: false
        });
    })

    $('.mmmdateCalendaryear').each(function () {
        $(this).datetimepicker({
            timepicker: false,
            changeYear: false,
            minDate: new Date((new Date).getFullYear(), 0, 1),
            maxDate: new Date((new Date).getFullYear(), 11, 31),
            format: 'd-M-Y',
            yearStart: (new Date).getFullYear(),
            yearEnd: (new Date).getFullYear(),
            monthStart: 0,
            monthEnd: 11,
            prevButton: false,
            nextButton: false,
            onChangeDateTime: function (date, $el) {
                var selectYear = date.getFullYear();

                if (selectYear != (new Date).getFullYear())
                { $el.context.value = ""; }
                //d is selected date.
                //var m = date.getMonth() + 1; //+1 because .getMonth() returns 0-11
                //m is selected month.
                //console.log(date)
                //console.log($el)
            }
        });
    })

    $('.mmmDateCalendar').each(function () {

        $(this).datetimepicker({
            timepicker: false,
            format: 'd-M-Y',
            scrollInput: false
        });
    });

    $('.mmmDateCalendarForNextDay').each(function () {

        $(this).datetimepicker({
            timepicker: false,
            minDate: new Date((new Date).getFullYear(), (new Date).getMonth(), (new Date).getDate() + 1),
            format: 'd-M-Y',
            scrollInput: false
        });
    });

    $('.mmmDateEffectiveCalendar').each(function () {

        $(this).datetimepicker({
            timepicker: false,
            // minDate: 0,
            format: 'd-M-Y',
            //format: 'm/d/Y',
            scrollInput: false
        });
    });

    $('.mmmDateCalendarFuture').each(function () {

        $(this).datetimepicker({
            timepicker: false,
            maxDate: 0,
            format: 'd-M-Y',
            //format: 'm/d/Y',
            scrollInput: false
        });
    })

    $('.mmmDateCalendarpast').each(function () {

        $(this).datetimepicker({
            timepicker: false,
            maxDate: 0,
            format: 'd-M-Y',
            //format: 'm/d/Y',
            scrollInput: false
        });
    });

    $('.mmmDateCalendarCurrentDate').each(function () {
        var TodayDate = new Date();
        $(this).datetimepicker({
            timepicker: false,
            maxDate: TodayDate,
            minDate: TodayDate,
            format: 'd-M-Y',
            //format: 'm/d/Y',
            scrollInput: false
        });
    })
    $('.mmmDateCalendarNoPast').each(function () {

        $(this).datetimepicker({
            timepicker: false,
            minDate: 0,
            format: 'd-M-Y',
            //format: 'm/d/Y',
            scrollInput: false
        });
    });
    $('.mmmDateTimeCalendarNoPast').each(function () {

        $(this).datetimepicker({
            timepicker: true,
            minDate: 0,
            format: 'd-M-Y H:i',
            //format: 'm/d/Y',
            scrollInput: false
        });
    });
    $('.mmmTimeCalendar').each(function () {

        $(this).datetimepicker({
            datepicker: false,
            // minTime: 0,
            format: 'H:i',
            step: 15,
            scrollInput: false
        });
    })

    $('.mmmDateTimeCalendar').each(function () {

        $(this).datetimepicker({
            minTime: 0,
            minDate: 0,
            format: 'd-M-Y H:i',
            // format: 'm/d/Y H:i',
            step: 15,
            scrollInput: false

        });

    });

    $('.mmmDateTimeCalendarVerify').each(function () {

        $(this).datetimepicker({
            //minTime: 0,
            /// minDate: 0,
            format: 'd-M-Y H:i',
            // format: 'm/d/Y H:i',
            step: 15,
            scrollInput: false

        });

    });


    $('.mmmDateTimePastCalendar').each(function () {

        $(this).datetimepicker({
            maxDate: 0,
            format: 'd-M-Y H:i',
            // format: 'm/d/Y H:i',
            step: 15,
            scrollInput: false

        });

    });

    $('.mmmDateTimeCalendarPast').each(function () {

        $(this).datetimepicker({
            //minTime: 0,
            //minDate: 0,
            format: 'd-M-Y H:i',
            // format: 'm/d/Y H:i',
            step: 15,
            scrollInput: false

        });
    })

    //$('.mmmDateTimeCalendarNoPast').each(function () {

    //     $(this).datetimepicker({
    //         timepicker: true,
    //          maxDate: 0,
    //         format: 'd/M/Y H:i',
    //         //format: 'm/d/Y',
    //         scrollInput: false
    //     });
    // });

    $('.mmmDateTimeCalendarFuture').each(function () {

        $(this).datetimepicker({
            //minTime: 0,
            //minDate: 0,
            maxDate: 0,
            format: 'd-M-Y H:i',
            // format: 'm/d/Y H:i',
            step: 15,
            scrollInput: false

        });
    });

    $('.mmmDateCalendarAll').each(function () {

        $(this).datetimepicker({
            timepicker: false,
            format: 'd-M-Y',
            step: 15,
            scrollInput: false

        });
    });

    $('.mmmDateTimeCalendarAll').each(function () {

        $(this).datetimepicker({
            format: 'd-M-Y H:i',
            step: 15,
            scrollInput: false
        });
    });
    $('.mmmDateTimeCalendarDelivery').each(function () {

        $(this).datetimepicker({
            format: 'd-M-Y H:i',
            step: 15,
            scrollInput: false,
            maxDate: 0,
        });
    });
    $('.mmmDateCalendarCurrentMonth').each(function () {

        $(this).datetimepicker({
            timepicker: false,
            minDate: new Date((new Date).getFullYear(), (new Date).getMonth(), 1),
            format: 'd-M-Y',
            scrollInput: false
        });
    });
}

function gridFields() {

    var topPagerDiv = $("#grid_toppager")[0];
    $("#grid_toppager_center", topPagerDiv).remove();
    $(".ui-paging-info", topPagerDiv).remove();
    $("#edit_grid_top", topPagerDiv).remove();
    $("#del_grid_top", topPagerDiv).remove();

    var bottomPagerDiv = $("div#pager")[0];
    $("#add_grid", bottomPagerDiv).remove();
    $("#edit_grid", bottomPagerDiv).remove();
    $("#del_grid", bottomPagerDiv).remove();
    $("#search_grid", bottomPagerDiv).remove();
    $("#refresh_grid", bottomPagerDiv).remove();

    $("#grid_toppager_center").hide();
    $("#grid_toppager_right").hide();
    $("#grid_toppager_left").attr("colspan", "3");
}


//DB Format - to /
function convertDatesToDisplayFormat(data) {

    for (var key in data) {
        // skip loop if the property is from prototype
        if (!data.hasOwnProperty(key)) continue;

        // Check for parent 
        var obj = data[key];
        if (typeof (obj) == "string") {
            //if (key == "CreatedDate" || key == "ModifiedDate") {
            //    //return false;
            //}
            if (obj.length == 16) {
                if (obj.split("-").length > 2) {
                    data[key] = obj.substring(0, 10);
                }
            }
        }

        // check for child 
        if (typeof (obj) == "object" && obj != null) {

            for (var item in obj) {
                var child = obj[item];
                for (var key1 in child) {
                    var obj1 = child[key1];
                    if (typeof (obj1) == "string") {
                        //if (key1 == "CreatedDate" || key1 == "ModifiedDate") {
                        //    //return false;
                        //}
                        if (obj1.length == 16) {
                            if (obj1.split("-").length > 2) {
                                child[key1] = obj1.substring(0, 10);
                            }
                        }
                    }

                    // check for subchild 
                    if (typeof (obj1) == "object" && obj1 != null) {

                        for (var item2 in obj1) {
                            var child2 = obj1[item2];
                            for (var key2 in child2) {
                                var obj2 = child2[key2];
                                if (typeof (obj2) == "string") {
                                    //if (key2 == "CreatedDate" || key2 == "ModifiedDate") {
                                    //                                //return false;
                                    //                            }
                                    if (obj2.length == 16) {
                                        if (obj2.split("-").length > 2) {
                                            child2[key2] = obj2.substring(0, 10);
                                        }
                                    }
                                }
                            }
                        };
                    }
                }
            };
        }
    }
    return data;
}

function GetPager(totalItems, currentPage, pageSize) {
    // default to first page
    currentPage = currentPage || 1;

    // default page size is 5
    pageSize = 5;

    // calculate total pages
    var totalPages = Math.ceil(totalItems / pageSize);

    var startPage, endPage;

    // calculate start and end item indexes
    var startIndex = totalItems == 0 ? 0 : ((currentPage - 1) * pageSize) + 1;
    var endIndex = (startIndex + pageSize) - 1;
    if (totalItems < endIndex) {
        endIndex = totalItems;
    }
    startPage = Math.ceil(startIndex / pageSize);
    endPage = Math.ceil(totalItems / pageSize);
    // create an array of pages to ng-repeat in the pager control

    console.log(endPage, totalPages);
    // return object with all pager properties required by the view
    return {
        totalItems: totalItems,
        currentPage: currentPage,
        pageSize: pageSize,
        totalPages: totalPages,
        startPage: startPage,
        endPage: endPage,
        startIndex: startIndex,
        endIndex: endIndex

    };
}

/*  Function To get Next date 
    Date : Input date should be in DD/MM/YYYY Foramt
*/

function getNextDate(date) {
    var renewStartDate = convertToDataBaseDateFormat(date);
    return moment(renewStartDate).add(1, 'day');
}

/*  Function To get Prevoius date 
    Date : Input date should be in DD/MM/YYYY Foramt
*/

function getPreviousDate(date) {
    var renewStartDate = convertToDataBaseDateFormat(date);
    return moment(renewStartDate).add(-1, 'day');
}

//Fetch Hide
$(document).click(function () {
    $('.UlFetch').hide();
});
$(".UlFetch").click(function (e) {
    e.stopPropagation();
    return false;
});
$("tbody").scroll(function () {
    $('.UlFetch').hide();
});

/********Print functionality **************/
(function () {
    var form = $('#printRequest'),
     cache_width = form.width(),
     a4 = [595.28, 841.89];  // for a4 size paper width and height

    $('#btnAddPrint').on('click', function () {
        $('form').scrollTop(0);
        createPDF();
    });
    //create pdf
    function createPDF() {
        getCanvas().then(function (canvas) {
            form.width(cache_width);
            //var img = canvas.toDataURL("image/png"),
            //doc = new jsPDF({
            //    unit: 'px',
            //    format: 'a4'
            //});
            //doc.addImage(img, 'JPEG', 20, 20);
            //doc.save('techumber-html-to-pdf.pdf');
            //form.width(cache_width);
            var imgData = canvas.toDataURL('image/png');
            var imgWidth = 210;
            var pageHeight = 295;
            var imgHeight = canvas.height * imgWidth / canvas.width;
            var heightLeft = imgHeight;

            var doc = new jsPDF('p', 'mm');
            var position = 0;

            doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
            heightLeft -= pageHeight;

            while (heightLeft >= 0) {
                position = heightLeft - imgHeight;
                doc.addPage();
                doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
                heightLeft -= pageHeight;
            }
            doc.save('Print.pdf');
            form.width(cache_width);
        });
    }

    // create canvas object
    function getCanvas() {
        form.width((a4[0] * 1.33333) - 80).css('max-width', 'none');
        return html2canvas(form, {
            imageTimeout: 2000,
            removeContainer: true
        });
    }
}());
/*Print Functunality dynamic Filename*/
function getCanvass() {
    var form = $('#printRequest'),
 cache_width = form.width(),
 a4 = [595.28, 841.89];
    form.width((a4[0] * 1.33333) - 80).css('max-width', 'none');
    return html2canvas(form, {
        imageTimeout: 2000,
        removeContainer: true
    });
}
function createPDFs(Filename) {
    var form = $('#printRequest'),
 cache_width = form.width(),
 a4 = [595.28, 841.89];
    getCanvass().then(function (canvas) {
        form.width(cache_width);
        var imgData = canvas.toDataURL('image/png');
        var imgWidth = 210;
        var pageHeight = 295;
        var imgHeight = canvas.height * imgWidth / canvas.width;
        var heightLeft = imgHeight;
        var doc = new jsPDF('p', 'mm');
        var position = 0;
        doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
        heightLeft -= pageHeight;
        while (heightLeft >= 0) {
            position = heightLeft - imgHeight;
            doc.addPage();
            doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
            heightLeft -= pageHeight;
        }
        var d = new Date();
        var s = d.toDateString();
        var date = s.split(' ');
        doc.save(Filename + '_' + date[2] + '_' + date[1] + '_' + date[3] + '.pdf');
        form.width(cache_width);
    });
}
/*End*/
//Print Pdf using Iframe
//function ReportPrint(url)
//    {
//   // alert('');

////    window.open('~images/loading16_anthracite.gifl', '_blank', 'fullscreen=yes')
//    //have a div in your html somewhere with this id. height=0 width=0
//    var div = document.getElementById('pdfDiv');
//    //we make a new iframe every time we print or the DOM manipulation below breaks
//    div.innerHTML = '<iframe width="0" height="0" id="pdfFrame" name="pdfFrame"></iframe>';
//    var frame = document.getElementById('pdfFrame');
//    frame.contentWindow.document.open();
//    //add a <body> to the iframe so we can add a form to it below
//    frame.contentWindow.document.write("<body ></body>");
//    frame.contentWindow.document.close();

//    //make a form to call the url above and return the pdf
//    var form = frame.contentWindow.document.createElement("form");
//    form.setAttribute("id", "pdfForm");
//    form.setAttribute("method", "post");
//    form.setAttribute("action", url);
//    //add as many input fields as your service needs
//    var field = document.createElement("input");       
//    form.appendChild(field);
//    //add the form to the new iframe body
//    frame.contentWindow.document.body.appendChild(form);
//    //wait until the pdf has loaded until printing just this hidden frame, not the surrounding page
//    frame.onload = function ()
//    {
//      //  frame.printMe();
//        frame.contentWindow.focus();
//        frame.contentWindow.print();
//        //try {
//        //   // window.frame.contentWindow.focus();
//        //    //window.print();
//        //   // frame.printMe();
//        //   // frame.contentWindow.document.execCommand('print', false, null);
//        //    //frame.focus();
//        //   // frame.contentWindow.print();
//        //}
//        //catch (e) {
//        //     window.print()
//        //         window.frames.loyaltyBadge.focus();
//        //       window.frames.loyaltyBadge.print();

//        //    frame.contentWindow.focus();
//        //    frame.contentWindow.print();
//        //}
//        //frame.printMe()
//     // window.print()
//   //     window.frames.loyaltyBadge.focus();
//     //   window.frames.loyaltyBadge.print();
//        //$(form).print();
//    };
//    //start loading the pdf from the server
//    form.submit();
//  //  $("#pdfFrame").contents().find("#printPage").trigger("click");
//}




//var tabName = "PdfDisplayTab";
//var form = document.createElement("form");
//form.setAttribute("id", "noid");
//form.setAttribute("method", "post");
//form.setAttribute("action", url);
//form.setAttribute("target", tabName);
//form.setAttribute("style", "display: none;");

//var field = document.createElement("input"); //add a post data value
//field.setAttribute("name", 'token');
//field.setAttribute("value", AccountService.GetAuthenticationToken());
//form.appendChild(field);

//document.body.appendChild(form);
//window.open('about:blank', tabName); //open form in new window
//form.submit();
// alert('');

//// window.open('C:\Shares\SharedFiles\Temp\Current_Version', '_blank', 'fullscreen=yes')
//   //have a div in your html somewhere with this id. height=0 width=0

function ReportPrint(url) {
    var tabName = "PdfDisplayTab";
    var div = document.getElementById('pdfDiv');
    //we make a new iframe every time we print or the DOM manipulation below breaks
    div.innerHTML = '<iframe width="0" height="0" id="pdfFrame" name="pdfFrame"></iframe>';
    var frame = document.getElementById('pdfFrame');
    frame.contentWindow.document.open();
    //add a <body> to the iframe so we can add a form to it below
    frame.contentWindow.document.write("<body ></body>");
    frame.contentWindow.document.close();

    //make a form to call the url above and return the pdf
    var form = frame.contentWindow.document.createElement("form");
    form.setAttribute("id", "pdfForm");
    form.setAttribute("method", "post");
    form.setAttribute("target", tabName);
    form.setAttribute("action", url);
    //add as many input fields as your service needs
    var field = document.createElement("input");
    form.appendChild(field);
    //add the form to the new iframe body
    frame.contentWindow.document.body.appendChild(form);

    //frame.onload = function () {

    //}



    window.open('about:blank', tabName); //open form in new window
    form.submit();

















    //var printContents = document.getElementById('pdfDiv').innerHTML;
    //var originalContents = document.body.innerHTML;
    //if (navigator.userAgent.toLowerCase().indexOf('chrome') > -1) {
    //    var popupWin = window.open('', '_blank', 'width=600,height=600,scrollbars=no,menubar=no,toolbar=no,location=no,status=no,titlebar=no');
    //    popupWin.window.focus();
    //    popupWin.document.write('<!DOCTYPE html><html><head>' +
    //        '<link rel="stylesheet" type="text/css" href="style.css" />' +
    //        '</head><body onload="window.print()"><div class="reward-body">' + printContents + '</div></html>');
    //    popupWin.onbeforeunload = function (event) {
    //        popupWin.close();
    //        return '.\n';
    //    };
    //    popupWin.onabort = function (event) {
    //        popupWin.document.close();
    //        popupWin.close();
    //    }
    //} else {
    //    var popupWin = window.open('', '_blank', 'width=800,height=600');
    //    popupWin.document.open();
    //    popupWin.document.write('<html><head><link rel="stylesheet" type="text/css" href="style.css" /></head><body onload="window.print()">' + printContents + '</html>');
    //    popupWin.document.close();
    //}
    //popupWin.document.close();



    // window.open('about:blank', tabName);
    //window.open(url, tabName);
    //   form.submit();

    // window.open(url, "pdfForm")

    //wait until the pdf has loaded until printing just this hidden frame, not the surrounding page
    // frame.onload = function ()
    // {


    //     window.open(url1, "pdfFrame");
    //   //  frame.printMe();
    //   //  frame.contentWindow.focus();
    //   //  frame.contentWindow.print();
    //  //   frame.contentWindow.open();
    //     //try {
    //     //   // window.frame.contentWindow.focus();
    //     //    //window.print();
    //     //   // frame.printMe();
    //     //   // frame.contentWindow.document.execCommand('print', false, null);
    //     //    //frame.focus();
    //     //   // frame.contentWindow.print();
    //     //}
    //     //catch (e) {
    //     //     window.print()
    //     //         window.frames.loyaltyBadge.focus();
    //     //       window.frames.loyaltyBadge.print();

    //     //    frame.contentWindow.focus();
    //     //    frame.contentWindow.print();
    //     //}
    //     //frame.printMe()
    //  // window.print()
    ////     window.frames.loyaltyBadge.focus();
    //  //   window.frames.loyaltyBadge.print();
    //     //$(form).print();
    // };
    //start loading the pdf from the server

    //  $("#pdfFrame").contents().find("#printPage").trigger("click");
}
/********Print functionality end **************/





//$scope.Print = function () {
//       var printContents = document.getElementById('PrintArea').innerHTML;
//       var originalContents = document.body.innerHTML;
//       if (navigator.userAgent.toLowerCase().indexOf('chrome') > -1) {
//           var popupWin = window.open('', '_blank', 'width=600,height=600,scrollbars=no,menubar=no,toolbar=no,location=no,status=no,titlebar=no');
//           popupWin.window.focus();
//           popupWin.document.write('<!DOCTYPE html><html><head>' +
//               '<link rel="stylesheet" type="text/css" href="style.css" />' +
//               '</head><body onload="window.print()"><div class="reward-body">' + printContents + '</div></html>');
//           popupWin.onbeforeunload = function (event) {
//               popupWin.close();
//               return '.\n';
//           };
//           popupWin.onabort = function (event) {
//               popupWin.document.close();
//               popupWin.close();
//           }
//       } else {
//           var popupWin = window.open('', '_blank', 'width=800,height=600');
//           popupWin.document.open();
//           popupWin.document.write('<html><head><link rel="stylesheet" type="text/css" href="style.css" /></head><body onload="window.print()">' + printContents + '</html>');
//           popupWin.document.close();
//       }
//       popupWin.document.close();

//       return true;
//   }








$(function () {
    function printMe() {
        window.print()
    }
});




/********Print functionality end **************/

//$(function () {
//    function printMe() {
//        window.print()
//    }
//});

/*For fetch using both key down and length*/


function AllowFetchKeyUpEvent(SearchKey, ControlId, event) {

    if ((SearchKey == undefined || SearchKey == "" || SearchKey == '' || SearchKey == null) && (event.keyCode == 40)) {
        return false;
    }
    else if (SearchKey != undefined && SearchKey != "" && SearchKey != '' && SearchKey != null) {

        //ctrlKey = 17,
        //cmdKey = 91,
        //vKey = 86,
        //cKey = 67;

        /* for Restricting Paste search key
         if ((event.ctrlKey && event.keyCode == 86))
          {
          return true;
  
          }
         else*/
        if (event.ctrlKey && event.keyCode == 67)   // for Restricting Paste search key
        {
            return true;
        }
        else {
            if (SearchKey.length <= Fetch.Filter_Char_Length) {
                $(ControlId).hide();
                return true;
            }
            else {
                return false;
            }

        }


    }
    else {
        $(ControlId).hide();
        return true;
    }
}


//  This code for common jqGrid bootbox.hideAll
$(function () {
    $(document).on('keydown', '.ui-pg-input,#Id_PageNumber', function (event, element) {
        if (event.keyCode == 13) {
            var pageNumber = Number($(this).val());
            var pageSize = Number($(this).next().text().replace(/[^0-9\.]/g, ''));
            if (pageNumber === 0 || pageSize < pageNumber) {
                bootbox.hideAll();
                bootbox.alert(Messages.PAGE_NUMBER_ALERT_MESSAGE);
                return false;
            }
        }
    });

});



AssessmentStatus =
{
    Draft: 5653,
    Submitted: 5654,
    Clarified: 5655,
    Recommended: 5656,
    ClarificationSoughtByHD: 5657,
    Approved: 5658,
    ClarificationSoughtByJKN: 5659
};

CommonMonth =
{
    January: 10,
    February: 11,
    March: 12,
    April: 13,
    May: 14,
    June: 15,
    July: 16,
    August: 17,
    September: 18,
    October: 19,
    November: 20,
    December: 21
};

MonthsNumber =
{
    January: 1,
    February: 2,
    March: 2,
    April: 4,
    May: 5,
    June: 6,
    July: 7,
    August: 8,
    September: 9,
    October: 10,
    November: 21,
    December: 12
};



function GetMonthLovId(monthId) {
    var monthLovId = 0;
    switch (monthId) {
        case 1: monthLovId = Number(CommonMonth.January); break;
        case 2: monthLovId = Number(CommonMonth.February); break;
        case 3: monthLovId = Number(CommonMonth.March); break;
        case 4: monthLovId = Number(CommonMonth.April); break;
        case 5: monthLovId = Number(CommonMonth.May); break;
        case 6: monthLovId = Number(CommonMonth.June); break;
        case 7: monthLovId = Number(CommonMonth.July); break;
        case 8: monthLovId = Number(CommonMonth.August); break;
        case 9: monthLovId = Number(CommonMonth.September); break;
        case 10: monthLovId = Number(CommonMonth.October); break;
        case 11: monthLovId = Number(CommonMonth.November); break;
        case 11: monthLovId = Number(CommonMonth.December); break;
    }
    return monthLovId;
}

/*VM Common Functionalities Prototype*/
VariationWFStatusList =
{
    Open: 5598,
    VVF_Submitted: 5575,
    VVF_Verified: 5576,
    VVF_Rejected: 5577,
    VVF_Approved: 5578,
    VVF_RejectedbyHD: 5579,
    VVF_ReSubmitted: 5580,
    SVR_Verified: 5581,
    SVR_Rejected: 5582,
    SVR_Approved: 5583,
    SVR_RejectedbyJKN: 5584,
    SVR_ReSubmitted: 5585,
    SVR_Draft: 5963,
    Rejected_By_BPK: 6073,
    ROFR_Prepared: 6074,
    ROFR_Verified: 6075,
    ROFR_Rejected: 6076,
    ROFR_Acknowledged: 6077,
    SOFR_Open: 6078,
    SOFR_Endorsement_Submission: 6079,
    SOFR_Correction: 6080,
    SOFR_Corrected: 6081,
    SOFR_KSU_Approval_Submission: 6082,
    SOFR_KSU_Approved: 6083,
    ST_Offer_Letter_Generated: 6084
};
VMTables =
    {
        BuildingandSystems: 4467,
        EquipmentandVehicles: 4468,
        LandArea: 4469,
        Equipment: 4470,
        CleansingArea: 4471
    };
YesNoValue =
    {
        Select: 0,
        Yes: 145,
        No: 146
    };

VariationMenuIds =
{
    VVF: 619,
    VVFRejection: 624,
    SummaryReports: 621,
    SummaryRejection: 623
};
VOStatusValueList =
    {
        V1: 2648,
        V2: 2649,
        V3: 2650,
        V4: 2651,
        V5: 2652,
        V6: 2653,
        V7: 2654,
        V8: 2655,
        V9: 2656,
        V10: 2657,
        V11: 2658,
        V12: 2659
    };

VMSNFStatusList =
{
    OPEN: 4283,
    VERIFIED: 4284,
    REJECTED: 4285,
    APPROVED: 4286,
    ISSUED: 4287,
    CLARIFICATION_SOUGHT_BY_HE: 5524,
    CLARIFICATION_SOUGHT_BY_HD: 6030,
    CLARIFIED_BY_HE: 6031,
    CLARIFIED_BY_AO: 6032,
    CANCELLED: 6034

};

TCTypeValueList = {
    Project: 2818,
    Asset: 2819
};

ENGStakeholderTypeValueList = {
    Prepared: 4012,
    Checked: 4013,
    Approved: 4014,
    Recommended: 4015,
    Conclusion: 4016,
    Rejected: 5172,
    Draft: 5404,
    ClarificationSought: 5431,
    Clarified: 6022
};

ENGASConclusionValueList = {
    Acknowledged: 4008,
    ApprovedforExemption: 4009,
    ApprovedforReimbursableWorks: 4010,
    ApprovedforDecommisioning: 4011
};

ENGObjectiveList = {
    Foracknowledgment: 2998,
    ConsiderationforReimbursableWorks: 2999,
    ConsiderationforExemption: 3000,
    ConsiderationforDecommissioning: 3001,
    Others: 3002
};

ENGAdvisoryServicesTypes = {
    CA: 4200,
    TA: 4201,
    PTA: 4202,
    BER: 4203
};


SNFAssetCategory = {
    Select: null,
    AsetTakAlih: 6071,
    AsetAlih: 6070
};

paginationString = '<div class="row">'
    + '<div class="col-sm-12">'
       + '<div class="well">'
          + '<div class="col-sm-3">&nbsp;</div>'
           + '<div class="col-sm-6 text-center">'
                + '<span class="glyphicon glyphicon-fast-backward" id="btnFirstPage">'
                + '</span>'
                + '<span class="glyphicon glyphicon-backward" id="btnPreviousPage">'
                + '</span>&nbsp;&nbsp;&nbsp;&nbsp;'
                + '<span>Page&nbsp;</span>'
                + '<input type="text" size="2" id="txtPageIndex" maxlength="10" />'
                + '<input type="hidden" id="hdnPageIndex" value="1" /> of '
                + '<span id="spnTotalPages"></span>&nbsp;&nbsp;&nbsp;&nbsp;'
                + '<span class="glyphicon glyphicon-forward" id="btnNextPage">'
                + '</span>'
                + '<span class="glyphicon glyphicon-fast-forward" id="btnLastPage">'
                + '</span>&nbsp;&nbsp;&nbsp;&nbsp;'
                + '<select id="selPageSize">'
				+ '<option value="5">5</option>'
				+ '<option value="10">10</option>'
				+ '<option value="20">20</option>'
				+ '<option value="50">50</option>'
				+ '</select>'
            + '</div>'
            + '<div class="col-sm-3 text-right">View <span id="spnFirstRecord"></span> to <span id="spnLastRecord"></span> of <span id="spnTotalRecords"></span></div>'
            + '<div class="clearfix"></div>'
        + '</div>'
    + '</div>'
+ '</div>';

var tableInputValidation = function (formid, save, deleteid) {


    var isFormValid = true;
    $.each($('#' + formid + ' :input'), function (index, value) {
        var ind = index;
        var val = value;
        var events = '';

        switch (value.type) {
            case "text":
            case "hidden":
            case "textarea":
            case "password":
                events = 'input propertychange paste';
                break;
            case "select-one":
                events = 'change';
                break;
            case "select-multiple":
                events = 'change';
                break;
        }
        if (value.type == "text" || value.type == "select-one" || value.type == "select-multiple" || value.type == "hidden"
            || value.type == "textarea" || value.type == "password") {
            if (save == "save") {

                var id = value.id;
                var index = id.split('_')[1];
                var deleteId = deleteid + "_" + index;
                var Isdelete = $("#" + deleteId).is(":checked");
                if (!Isdelete) {
                    if ($(this).prop('required')) {
                        if ($('#' + value.id).val() == "" || $('#' + value.id).val() == "null" || $('#' + value.id).val() == null || (value.type != "select-multiple" && $('#' + value.id).val().trim() == "")) {
                            $(this).parent().addClass('has-error');
                            isFormValid = false;
                        }
                        else {
                            if ($(this).attr('id').indexOf('hdn') != 0)
                                $(this).parent().removeClass('has-error');
                        }
                    }

                    if ($(this).attr('pattern') != "" && $(this).attr('pattern') != null) {
                        var regEx = $(this).attr('pattern')
                        if ($(this).val() != null && $(this).val() != "") {
                            if (!$(this).val().match(regEx)) {
                                $(this).parent().addClass('has-error');
                                isFormValid = false;
                            }
                            //else {
                            //    $(this).parent().removeClass('has-error');
                            //}
                        }
                    }
                }
            }
            else {
                if (value && value.id) {
                    $('#' + value.id).on(events, function (e) {

                        if ($(this).prop('required')) {
                            if (e.target.value == "" || e.target.value == "null" || e.target.value == null) {
                                $(this).parent().addClass('has-error');
                            }
                            else {
                                if ($(this).attr('id').indexOf('hdn') != 0)
                                    $(this).parent().removeClass('has-error');
                            }
                        }
                        if ($(this).attr('pattern') != "" && $(this).attr('pattern') != null) {
                            var regEx = $(this).attr('pattern')
                            if ($(this).val() != null && $(this).val() != "") {
                                if (!$(this).val().match(regEx)) {
                                    $(this).parent().addClass('has-error');
                                }
                                else {
                                    $(this).parent().removeClass('has-error');
                                }
                            }
                            else {
                                if (!$(this).prop('required')) {
                                    $(this).parent().removeClass('has-error');
                                }
                            }
                        }
                    });
                }
            }
        }
    });
    return isFormValid;
}
//-----------------------------------------------------

$(function () {
    $('.nav-tabs').scrollingTabs();
    $('.back_track').click(function () {
        setTimeout(function () {
            $('.nav-tabs').scrollingTabs('refresh');
        }, 400)

    })
});