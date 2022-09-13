var StatusVal = "";
var FileTypeValues = "";
var filePrefix = "DCA_";
var ScreenName = "DailyCleaningActivity";
var rowNum2 = 1;

$(document).ready(function () {

    $.get("/api/DailyCleaningActivity/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);            

            for (var i = 0; i < loadResult.StatusLov.length; i++) {
                StatusVal += "<option value=" + loadResult.StatusLov[i].LovId + " >" + loadResult.StatusLov[i].FieldValue + "</option>"
            }

            FileTypeValues = "<option value='' Selected>" + "Select" + "</option>";
            FileTypeValues += "<option value='1'>" + "DCA form" + "</option>";
            $("#ddlFileType1").append(FileTypeValues);

              $('#myPleaseWait').modal('hide');
        })
        .fail(function (response) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            $('#errorMsgConfigAdditionalFields').css('visibility', 'visible');
        });   

    //clicking on 2nd tab restrict
    $(".nav-tabs").click(function () {
        var primaryId = $('#primaryID').val();
        if (primaryId == 0 || primaryId == null || primaryId == undefined || primaryId == "" || primaryId == "0") {
            bootbox.alert(Messages.SAVE_FIRST_TABALERT);
            return false;
        }
    });
        
    /******************************************* Save *****************************************/
    $("#btnSave, #btnSaveandAddNew").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');
        var SelCus = $("#selCustomerLayout").val();
        var SelFacility = $("#selFacilityLayout").val();        

        var isFormValid = formInputValidation("formDailyCleaningActivity", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }

        var primaryId = 0;
        if ($("#primaryID").val() != null) {
            primaryId = $("#primaryID").val();
        } 

        var objSave = {
            DailyActivityId: primaryId,
            CustomerId: SelCus,
            FacilityId: SelFacility,
            DocumentNo: $('#txtDocumentNo').val(),
            Date: $('#txtDate').val(),
            TotalDone: $('#txtTotalDone').val(),
            TotalNotDone: $('#txtTotalNotDone').val(),            
            fetchList: []
        }

        $("#tbodyResult tr").each(function () {

            var row = $(this);
            var dailyCleaningActivityObj = {};
            dailyCleaningActivityObj.UserAreaCode = row.children("td").find("text").eq(0).html();
            dailyCleaningActivityObj.Status = $(this).children("td").find("select").children("option:selected").val();
            dailyCleaningActivityObj.A1 = row.children("td").find("text").eq(1).html();
            dailyCleaningActivityObj.A2 = row.children("td").find("text").eq(2).html();
            dailyCleaningActivityObj.A3 = row.children("td").find("text").eq(3).html();
            dailyCleaningActivityObj.A4 = row.children("td").find("text").eq(4).html();
            dailyCleaningActivityObj.A5 = row.children("td").find("text").eq(5).html();
            dailyCleaningActivityObj.B1 = row.children("td").find("text").eq(6).html();
            dailyCleaningActivityObj.C1 = row.children("td").find("text").eq(7).html();
            dailyCleaningActivityObj.D1 = row.children("td").find("text").eq(8).html();
            dailyCleaningActivityObj.D2 = row.children("td").find("text").eq(9).html();
            dailyCleaningActivityObj.D3 = row.children("td").find("text").eq(10).html();
            dailyCleaningActivityObj.D4 = row.children("td").find("text").eq(11).html();
            dailyCleaningActivityObj.E1 = row.children("td").find("text").eq(12).html();
            objSave.fetchList.push(dailyCleaningActivityObj);
        });
        

        $.post("/api/DailyCleaningActivity/Save", objSave, function (response) {
              
            var result = JSON.parse(response);
            showMessage('Daily cleaning schedule', CURD_MESSAGE_STATUS.SS);
            $("#primaryID").val(result.DailyActivityId);
            $("#grid").trigger('reloadGrid');
          
            if (CurrentbtnID == "btnSaveandAddNew") {
                EmptyFields();
                showMessage('Daily cleaning schedule', CURD_MESSAGE_STATUS.SS);
            }
            else {
               // fillDetails(result);
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

/******************************************* Fetch *****************************************/
    $("#btnFetch").click(function () {
             

        var objFetch = {
            DocumentNo: $('#txtDocumentNo').val()
        }
     
        $.post("/api/DailyCleaningActivity/DocFetch", objFetch, function (response) {
        
            var result = JSON.parse(response);
      
            if (result.fetchList.length > 0) {
                $('#table_data').hide();
                $('#tbodyResult').show();
                var trStru = "";
                for (var i = 0; i < result.fetchList.length; i++) {                
               
                    trStru += "<tr>" + "<td style='background:#eee;cursor:not-allowed'>" + "<text id='lblUserAreaCode" + i + "'>" + result.fetchList[i].UserAreaCode + "</text>" + "</td>"
                        + "<td><select class='DailyStatus' id='jobItemStatus" + i + "'>" + StatusVal + "</select >" + "</td > "
                        + "<td><text id='lblA1_P" + i + "'>" + result.fetchList[i].A1 + "</text></td>"
                        + "<td><text id='lblA2_P" + i + "'>" + result.fetchList[i].A2 + "</text></td>"
                        + "<td><text id='lblA3_P" + i + "'>" + result.fetchList[i].A3 + "</text></td>"
                        + "<td><text id='lblA4_P" + i + "'>" + result.fetchList[i].A4 + "</text></td>"
                        + "<td><text id='lblA5_P" + i + "'>" + result.fetchList[i].A5 + "</text></td>"
                        + "<td><text id='lblB1_P" + i + "'>" + result.fetchList[i].B1 + "</text></td>"
                        + "<td><text id='lblC1_P" + i + "'>" + result.fetchList[i].C1 + "</text></td>"
                        + "<td><text id='lblD1_P" + i + "'>" + result.fetchList[i].D1 + "</text></td>"
                        + "<td><text id='lblD2_P" + i + "'>" + result.fetchList[i].D2 + "</text></td>"
                        + "<td><text id='lblD3_P" + i + "'>" + result.fetchList[i].D3 + "</text></td>"
                        + "<td><text id='lblD4_P" + i + "'>" + result.fetchList[i].D4 + "</text></td>"
                        + "<td><text id='lblE1_P" + i + "'>" + result.fetchList[i].E1 + "</text></td>"          
                        + "</tr>"
                }
               
                $('#tbodyResult').html(trStru);
                $('#tbodyResult').find("select").addClass("form-control");
                $('#txtTotalDone').val(result.fetchList.length);
                $('#txtTotalNotDone').val('0');
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

            });        
    });

    $('body').on('change', '.DailyStatus', function (event) {

        var Totaldone = 0;
        var TotalNotdone = 0;       

        $('.DailyStatus').each(function () {

            var AttachIdId = $(this)[0].id;
            var daily = $("#" + AttachIdId)[0];
            if (daily.options[daily.options.selectedIndex].text == "Done") {
                Totaldone = Totaldone + 1;
            }
            if (daily.options[daily.options.selectedIndex].text == "Not Done") {
                TotalNotdone = TotalNotdone + 1;
            }
        })

        $("#txtTotalDone").val(Totaldone);
        $("#txtTotalNotDone").val(TotalNotdone);    
    });

    //****************************************** Cancel *********************************************
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
                    $('#table_data').show();
                    $('#daily').hide();                   
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            }
        });
    });
   
    //validation red  color border
    $('#txtDate').on('change', function () {
        $('#date').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });   

    /***************** Auto Generated Code**************/

    var DocumentNo = $('#txtDocumentNo').val();

    var objdaily = {
        DocumentNo: DocumentNo
    }
    AutoGen(objdaily);
    
});  

function AutoGen(objdaily) {

    $.get("/api/DailyCleaningActivity/AutoGeneratedCode", objdaily, function (response) {

        var result = JSON.parse(response);       
        $('#txtDocumentNo').val(result.DocumentNo);
    });
}

function EmptyFields() {
        

    $('#primaryID').val(0);
    $('#formDailyCleaningActivity')[0].reset();

    var i = 1;
    $("#tbodyResult").find('tr').each(function () {
        if (i >= 1) {
            $(this).remove();
        }
        i += 1;
    });

    var DocumentNo = $('#txtDocumentNo').val();

    var objdaily = {
        DocumentNo: DocumentNo
    }
    AutoGen(objdaily);

    $('#errorMsg').css('visibility', 'hidden');
    $('#daily').html('');
    $(".content").scrollTop(0);
    $('#date').removeClass('has-error');
    $('#formDailyCleaningActivity #txtDate').val('');
   
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

function LinkClicked(id) {

    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formDailyCleaningActivity :input:not(:button)").parent().removeClass('has-error');
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
        $("#formDailyCleaningActivity :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();

        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/DailyCleaningActivity/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                let monthNames = ["Zero", "Jan", "Feb", "Mar", "Apr",
                    "May", "Jun", "Jul", "Aug",
                    "Sep", "Oct", "Nov", "Dec"];
                var rowlength = getResult.fetchList.length;

                if (getResult != undefined) {

                    var Docno = getResult.DocumentNo;
                    var DateTime = getResult.Date;
                    var Date = DateTime.slice(0, 10);
                    var year = Date.slice(0, 4);
                    var monthindex = Date.slice(5, 7)
                    if (monthindex >= 10) {

                        var month = monthNames[Date.slice(5, 7)];
                    }
                    else {
                        var month = monthNames[Date.slice(6, 7)];
                    }

                    var date1 = Date.slice(8, 10);
                    var DateFormat = date1 + "-" + month + "-" + year;
                    var TotalDone = getResult.TotalDone;
                    var TotalNotDone = getResult.TotalNotDone;

                    $('#txtDocumentNo').val(Docno);
                    $('#txtDate').val(DateFormat);
                    $('#txtTotalDone').val(TotalDone);
                    $('#txtTotalNotDone').val(TotalNotDone);
                }
                var trStruGrid = "";
                $('#tbodyResult').html('');
                for (var i = 0; i < rowlength; i++) { 
                    
                    trStruGrid = "<tr><td style='background:#eee;cursor:not-allowed'>" + "<text id='lblUserAreaCode" + i + "'>" + getResult.fetchList[i].UserAreaCode + "</text>" + "</td>"
                        + "<td><select class='DailyStatus' id='jobItemStatus" + i + "'>" + StatusVal + "</select >" + "</td > "                   
                        + "<td><text id='lblA1_P" + i + "'>" + getResult.fetchList[i].A1 + "</text></td>"
                        + "<td><text id='lblA2_P" + i + "'>" + getResult.fetchList[i].A2 + "</text></td>"
                        + "<td><text id='lblA3_P" + i + "'>" + getResult.fetchList[i].A3 + "</text></td>"
                        + "<td><text id='lblA4_P" + i + "'>" + getResult.fetchList[i].A4 + "</text></td>"
                        + "<td><text id='lblA5_P" + i + "'>" + getResult.fetchList[i].A5 + "</text></td>"
                        + "<td><text id='lblB1_P" + i + "'>" + getResult.fetchList[i].B1 + "</text></td>"
                        + "<td><text id='lblC1_P" + i + "'>" + getResult.fetchList[i].C1 + "</text></td>"
                        + "<td><text id='lblD1_P" + i + "'>" + getResult.fetchList[i].D1 + "</text></td>"
                        + "<td><text id='lblD2_P" + i + "'>" + getResult.fetchList[i].D2 + "</text></td>"
                        + "<td><text id='lblD3_P" + i + "'>" + getResult.fetchList[i].D3 + "</text></td>"
                        + "<td><text id='lblD4_P" + i + "'>" + getResult.fetchList[i].D4 + "</text></td>"
                        + "<td><text id='lblE1_P" + i + "'>" + getResult.fetchList[i].E1 + "</text></td>"
                        + "</tr>"

                    $('#tbodyResult').append(trStruGrid);
                    $('#jobItemStatus' + i).val(getResult.fetchList[i].Status);                    
                    
                }


                
                fillAttachment(getResult.AttachmentList);
                

                $('#table_data').hide();                
                $('#tbodyResult').find("select").addClass("form-control");
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