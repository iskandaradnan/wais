$(document).ready(function () {

    $("#btnFetch").click(function () {

        var Year = $('#ddlYear').val();
        var SelFacility = $("#selFacilityLayout").val();

        if (Year != 0) {

            $('#primaryID').val(Year);

            $.get("/api/WeekCalendar/GetStartDateEndDate?FacilityId=" + SelFacility + "&Year=" + Year)
                .done(function (result) {
                    var result = JSON.parse(result);
                    fillWeekCalenderDates(result);
                })
                .fail(function (response) {
                    $('#myPleaseWait').modal('hide');
                    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                    $('#errorMsgAssm').css('visibility', 'visible');
                });

            $('#myPleaseWait').modal('hide');
        }
        else {

            var message = "Please Select Year";
            bootbox.confirm(message, function (result) {
                if (result) {                    
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            });

        }
      
    });

    


    $("#btnSave").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');
        var SelCus = $("#selCustomerLayout").val();
        var SelFacility = $("#selFacilityLayout").val();
        var Year = $('#ddlYear').val();         
        var isFormValid = formInputValidation("formWeekCalendar", 'save');
        $('#myPleaseWait').modal('show');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            return false;   
        }
        
        var lstWeekCalendar = [];          
        $("#Week tbody tr").each(function () {  
            lstWeekCalendar.push({
                CustomerId: SelCus,
                FacilityId: SelFacility,
                Year: Year,
                Month: $.trim($(this).find('input').eq(1).val()),    
                WeekNo: $.trim($(this).find('input').eq(0).val()),                            
                StartDate: $.trim($(this).find('input').eq(2).val()),
                EndDate: $.trim($(this).find('input').eq(3).val())
            });
        });
                      
       
        $.ajax({
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                type: 'POST',
                url: '/api/WeekCalendar/Save',
                data: JSON.stringify(lstWeekCalendar)                
            })
            .done(function (response) {

                var result = JSON.parse(response);

                if (result.Year != 0) {

                    showMessage('WeekCalendar', CURD_MESSAGE_STATUS.SS);

                    $("#primaryID").val(result.Year);
                    $("#grid").trigger('reloadGrid');
                }

                $('#myPleaseWait').modal('hide');
            })
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

       
        
    });        

    //Reset Button Code....
     
    $("#btnCancel").click(function () {
        var message = Messages.Reset_Alert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                EmptyFields();
            }
            else {
                    
            }
        });
    });
      
     

    var getUrlParameter = function getUrlParameter(sParam) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');

            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : sParameterName[1];
            }
        }
    };
    var ID = getUrlParameter('id');
    if (ID == null || ID == undefined || ID == 0 || ID == '' || ID == "") {
        $("#jQGridCollapse1").click();
    }
    else {
        LinkClicked(ID);
    }

});


function LinkClicked(id) {

    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formWeekCalendar :input:not(:button)").parent().removeClass('has-error');
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
        $("#formWeekCalendar :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        //$('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }

    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();

    if (primaryId != null && primaryId != "0") {

        var SelFacility = $("#selFacilityLayout").val();
        var CustomerId = $('#selCustomerLayout').val();
            

        $.get("/api/WeekCalendar/Get?CustomerId=" + CustomerId + "&FacilityId=" + SelFacility + "&Year=" + primaryId)
            .done(function (result) {
                var result = JSON.parse(result);
                $("#ddlYear").val(primaryId);
                fillWeekCalenderDates(result);
            })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsgAssm').css('visibility', 'visible');
            });
        //fillWeekCalenderDates(SelFacility, primaryId);
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}

function fillWeekCalenderDates(result) {

    var rowNum = 1;
    var startDate = '';
    var endDate = '';
    let monthNames = ["Zero", "Jan", "Feb", "Mar", "Apr",
        "May", "Jun", "Jul", "Aug",
        "Sep", "Oct", "Nov", "Dec"];

    $("#Week tbody").html('');

    for (var i = 0; i < result.length; i++) {

        var d = result[i].StartDate.slice(0, 10);
        var year = d.slice(0, 4);
        var month = monthNames[parseInt(d.slice(5, 7))];
        var date = d.slice(8, 10);
        startDate = date + "-" + month + "-" + year;

        var d1 = result[i].EndDate.slice(0, 10);
        var year1 = d1.slice(0, 4);
        var month1 = monthNames[parseInt(d1.slice(5, 7))];
        var date1 = d1.slice(8, 10);
        endDate = date1 + "-" + month1 + "-" + year1;

        //var Id = '<td> <input type="text" class="form-control" id="txtWeekNo' + rowNum + '" value=' + result[i].WeekCalendarId + ' disabled  name="weekno"/></td>';

        var WeekNo = '<td> <input type="text" class="form-control" id="txtWeekNo' + rowNum + '" value=' + result[i].WeekNo + ' disabled  name="weekno"/></td>';
        var Month = '<td> <input type= "text" class="form-control" id="txtMonth' + rowNum + '" value=' + result[i].Month + ' disabled  name = "weekMonth" /> </td >';
        var StartDate = '<td> <input type="text" class="form-control datetime" id="txtStartDate' + rowNum + '" value=' + startDate + '   name="startdate" disabled /></td>';
        var EndDate = '<td> <input type="text" class="form-control datetime" id="txtEndDate' + rowNum + '" value=' + endDate + '   name="enddate" disabled /></td>';

        $("#Week tbody").append('<tr class="Weekrow">' + WeekNo + Month + StartDate + EndDate + '</tr>');

        rowNum = rowNum + 1;
    }

}



function EmptyFields() {
    $('#formWeekCalendar')[0].reset();   
    $("#ddlYear").val('0');
    $("#Week tbody").html('');
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
})
