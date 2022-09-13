var Temperaturedropdown = "";
var YearValues = "";
var MonthsValues = "";
var rowNum = 1;

var FileTypeValues = "";
var filePrefix = "DTL_";
var ScreenName = "DailyTemperatureLog";
var rowNum2 = 1;

$(document).ready(function () {

    $.get("/api/DailyTemperatureLog/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            Temperaturedropdown = "<option value='' Selected>" + "Select" + "</option>";          
            YearValues="<option value='' Selected>" + "Select" + "</option>";
            MonthsValues="<option value='' Selected>" + "Select" + "</option>";
           
            for (var i = 0; i < loadResult.TemperatureReadingValues.length; i++) {

                Temperaturedropdown += "<option value=" + loadResult.TemperatureReadingValues[i].LovId + ">" + loadResult.TemperatureReadingValues[i].FieldValue + "</option>"
            }
           

            for (var i = 0; i < loadResult.DailyYearValues.length; i++) {
               
                    YearValues+= "<option value=" + loadResult.DailyYearValues[i].LovId + ">" + loadResult.DailyYearValues[i].FieldValue + "</option>"               
            }
            $("#ddlYear").append(YearValues);
       
            for (var i = 0; i < loadResult.DailyMonthValues.length; i++) {
           
                    MonthsValues+= "<option value=" + loadResult.DailyMonthValues[i].LovId + ">" + loadResult.DailyMonthValues[i].FieldValue + "</option>"            
            }
            $("#ddlMonth").append(MonthsValues);

            FileTypeValues = "<option value='' Selected>" + "Select" + "</option>";
            FileTypeValues += "<option value='1'>" + "Daily Temperature Log" + "</option>";
            $("#ddlFileType1").append(FileTypeValues);

            $('#myPleaseWait').modal('hide');
        })

        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });   
     
    $("#btnSave").click(function () {
       
        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');

        var isFormValid = formInputValidation("formDailyTemperatureLog", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }

        var primaryId = 0;
        if ($("#primaryID").val() != null) {
            primaryId = $("#primaryID").val();

        } 
        var obj = {
            DailyId: primaryId,
            CustomerId: $('#selCustomerLayout').val(),
            FacilityId: $('#selFacilityLayout').val(),
            Year: $("#ddlYear").val(),
            Month: $("#ddlMonth").val(),
            Date: $("#txtDate").val(),
            TemperatureReading: $("#txtTemperatureReading").val(),  
            
            dailyTemperatureLogsList: []
        };

        var isDateValid = true;
        var Year = $("#ddlYear")[0][$("#ddlYear")[0].selectedIndex].innerText;
        var Month = $("#ddlMonth")[0][$("#ddlMonth")[0].selectedIndex].innerText;


        var monthArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ];
      

        $("#dailytemperaturelogtbody  tr").each(function () {
            var tbl = {};
          
            tbl.TemperatureId = $(this).find("[id^=hdndailytemperaturelogId]")[0].value;
            tbl.Date = $(this).find("[id^=txtDate]")[0].value;
            tbl.TemperatureReading = $(this).find("[id^=txtTemperatureReading]")[0].value;
            tbl.isDeleted = $(this).find('input:checkbox[id^=isDelete]').prop("checked");

            var nDate = new Date(tbl.Date);

            if (nDate.getFullYear() != Year || monthArray[nDate.getMonth()] != Month) {
                isDateValid = false;
            }

            obj.dailyTemperatureLogsList.push(tbl);
        });

        if (!isDateValid) {
            $("div.errormsgcenter").text("Date is not valid, Please check");
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }
              
        $.post("/Api/DailyTemperatureLog/Save", obj, function (response) {

            var result = JSON.parse(response);
            showMessage('Daily Temperature Log', CURD_MESSAGE_STATUS.SS);
            $("#primaryID").val(result.DailyId);

            $("#grid").trigger('reloadGrid');
            if (CurrentbtnID == "btnSaveandAddNew") {
                EmptyFields();
            }
            else {
                fillDetails(result);
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
            });
    });

    $("#addTemperatureRecords").click(function () {
        rowNum += 1;
        addTemperatureRecords(rowNum);
    });
       
    $("#deletetemperatureRecords").click(function () {

        bootbox.confirm({
            message: 'Do you want to delete a row?',
            buttons: {
                confirm: {
                    label: 'Yes',
                    className: 'btn-primary'
                },
                cancel: {
                    label: 'No',
                    className: 'btn-default'
                }
            },
            callback: function (result) {
                if (result) {
                    if ($("input[type='checkbox']:checked").length > 0) {

                        $("#dailytemperaturelogtbody ").find('input[name="isDelete"]').each(function () {
                            if ($(this).is(":checked")) {

                                if ($(this).closest("tr").find("[id^=hdndailytemperaturelogId]").val() == 0) {
                                    $(this).closest("tr").remove();

                                }
                            }
                        });
                    }
                    else
                        bootbox.alert("Please select atleast one row !");
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            }
        });

    });

    $("#btnCancel").click(function () {
        bootbox.confirm({
            message: Messages.Reset_Alert_CONFIRMATION,
            buttons: {
                confirm: {
                    label: 'Yes',
                    className: 'btn-primary'
                },
                cancel: {
                    label: 'No',
                    className: 'btn-default'
                }
            },
            callback: function (result) {
                if (result) {
                    EmptyFields();
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }

            }
        });
    });
});

$('#ddlMonth').on('change', function () {

    $('#MonthVal').removeClass('has-error');
    $('#errorMsg').css('visibility', 'hidden');

    if ($('#ddlMonth').val() != '') {

        var YearMonth = $('#ddlYear').val() + '-' + $('#ddlMonth').val()

        $.get("/api/DailyTemperatureLog/GetByYearMonth/" + YearMonth)
            .done(function (result) {
                var getResult = JSON.parse(result);
                fillDetails(getResult);

            })
            .fail(function () {
                //$('#myPleaseWait').modal('hide');
                //$("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                //$('#errorMsg').css('visibility', 'visible');

                rowNum = 1;
                $('#dailytemperaturelogtbody').html('');
                addTemperatureRecords(rowNum);
                $("#primaryID").val(0);
                
            });

    }
});
$('#ddlYear').on('change', function () {

    $('#YearVal').removeClass('has-error');
    $('#errorMsg').css('visibility', 'hidden');

    $('#ddlMonth').val('');
});
$('#txtDate1').on('change',function () {

    $('#DateVal').removeClass('has-error');
    $('#errorMsg').css('visibility', 'hidden');
});
$('#txtTemperatureReading1').on('change', function () {

    $('#TemperatureReadingVal').removeClass('has-error');
    $('#errorMsg').css('visibility', 'hidden');
});

function EmptyFields() {

    $('#formDailyTemperatureLog')[0].reset();
    $('#errorMsg').css('visibility', 'hidden');
    var i = 1;
    $("#dailytemperaturelogtbody").find('tr').each(function () {
        if (i > 1) {
            $(this).remove();
        }
        i += 1;
    });
    $('#YearVal').removeClass('has-error');
    $('#MonthVal').removeClass('has-error');
    $('#DateVal').removeClass('has-error');
    $('#TemperatureReadingVal').removeClass('has-error');   
    $(".content").scrollTop(0);   
    rowNum = 1;
}

function LinkClicked(id) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formDailyTemperatureLog :input:not(:button)").parent().removeClass('has-error');
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
        $("#formDailyTemperatureLog :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/DailyTemperatureLog/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                fillDetails(getResult);
               
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

function fillDetails(result) {

    if (result != undefined) {

        $("#primaryID").val(result.DailyId)
        $('#ddlYear').val(result.Year);
        $('#ddlMonth').val(result.Month);
     
        rowNum = 1;
        $('#dailytemperaturelogtbody').html('');

        if (result.dailyTemperatureLogsList != null) {

            for (var i = 0; i < result.dailyTemperatureLogsList.length; i++) {

                addTemperatureRecords(rowNum);

                $('#hdndailytemperaturelogId' + rowNum).val(result.dailyTemperatureLogsList[i].TemperatureId);
                var Date = getCustomDate(result.dailyTemperatureLogsList[i].Date);
                $('#txtDate' + rowNum).val(result.dailyTemperatureLogsList[i].Date);
                $('#txtTemperatureReading' + rowNum).val(result.dailyTemperatureLogsList[i].TemperatureReading);
                
                rowNum += 1;
            }
        }
        else {
            addTemperatureRecords(rowNum);
        }

        fillAttachment(result.AttachmentList);

    }
}

function addTemperatureRecords(num) {

    var CheckBox = '<td>  <input type="checkbox" id="isDelete' + num + '" name="isDelete"> <input type="hidden" id="hdndailytemperaturelogId' + num + '" value="0" /></td>';

    var Date = '<td id="DateVal"> <input type="datetime-local" required class="form-control" id="txtDate' + num+'" autocomplete="off" name="Date" maxlength="15"  /></td>';
    var TemperatureReading = '<td id="TemperatureReadingVal"><input type="number" required class="form-control" id="txtTemperatureReading' + num+'" autocomplete="off" name="Status" maxlength="25" ></td>';

    $("#dailytemperaturelogtbody ").append('<tr>' + CheckBox + Date + TemperatureReading + '</tr>');
}

function getCustomDate(date) {

    if (date == '' || date == null) {
        return '';
    }
    else {
        let monthNames = ["Zero", "Jan", "Feb", "Mar", "Apr",
            "May", "Jun", "Jul", "Aug",
            "Sep", "Oct", "Nov", "Dec"];

        var day = date.slice(8, 10);
        var monthindex = date.slice(5, 7);        if (monthindex >= 10) {            var month = monthNames[date.slice(5, 7)];        }        else {            var month = monthNames[date.slice(6, 7)];        }
        var year = date.slice(0, 4);
        return day + "-" + month + "-" + year;
    }
}

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
});