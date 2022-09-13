var StatusVal = "";
var FileTypeValues = "";
var filePrefix = "PWR_";
var ScreenName = "PeriodicWorkRecord";
var rowNum2 = 1;

$(document).ready(function () {

    $.get("/api/PeriodicWorkRecord/Load") 
        .done(function (result) {
            var loadResult = JSON.parse(result);
             //StatusVal = "<option value='0' >" + "Select" + "</option>"
            var MonthVal = "<option value='' Selected>" + "Select" + "</option>"
            var YearVal = "<option value='' Selected>" + "Select" + "</option>"

            for (var i = 0; i < loadResult.StatusLov.length; i++) {
                StatusVal += "<option value=" + loadResult.StatusLov[i].LovId + ">" + loadResult.StatusLov[i].FieldValue + "</option>"
            }

            for (var i = 0; i < loadResult.YearLov.length; i++) {
                YearVal += "<option value=" + loadResult.YearLov[i].LovId + ">" + loadResult.YearLov[i].FieldValue + "</option>"
            }
            $("#ddlYear").html(YearVal);

            for (var i = 0; i < loadResult.MonthLov.length; i++) {
                MonthVal += "<option value=" + loadResult.MonthLov[i].LovId + ">" + loadResult.MonthLov[i].FieldValue + "</option>"
            }
            $("#ddlMonth").html(MonthVal);

            FileTypeValues = "<option value='' Selected>" + "Select" + "</option>";
            FileTypeValues += "<option value='1'>" + "PWR form" + "</option>";
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


    $("#btnSave,#btnSaveandAddNew").click(function () {
        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');
        var SelCus = $("#selCustomerLayout").val();
        var SelFacility = $("#selFacilityLayout").val();
        var DocumentNo = $('#txtDocumentNo').val();
        var Year = $('#ddlYear').val();
        var Month = $('#ddlMonth').val();
        var UserAreaCode = $('#lblUserAreaCode').val();
        var Status = $('#ddlStatus').val();
        var ScopeofWorkA1 = $('#lblScopeofWorkA1').val();
        var ScopeofWorkA2 = $('#lblScopeofWorkA2').val();
        var ScopeofWorkA3 = $('#lblScopeofWorkA3').val();
        var ScopeofWorkA4 = $('#lblScopeofWorkA4').val();
        var ScopeofWorkA5 = $('#lblScopeofWorkA5').val();
        var ScopeofWorkA6 = $('#lblScopeofWorkA6').val();
        var ScopeofWorkA7 = $('#lblScopeofWorkA7').val();
        var ScopeofWorkA8 = $('#lblScopeofWorkA8').val();
        var ScopeofWorkA9 = $('#lblScopeofWorkA9').val();
        var ScopeofWorkA10 = $('#lblScopeofWorkA10').val();
        var ScopeofWorkA11 = $('#lblScopeofWorkA11').val();
        var ScopeofWorkA12 = $('#lblScopeofWorkA12').val();
        var ScopeofWorkA13 = $('#lblScopeofWorkA13').val();
        var ScopeofWorkA14 = $('#lblScopeofWorkA14').val();
        var ScopeofWorkA15 = $('#lblScopeofWorkA15').val();
        var ScopeofWorkA16 = $('#lblScopeofWorkA16').val();
        var ScopeofWorkA17 = $('#lblScopeofWorkA17').val();
        var ScopeofWorkA18 = $('#lblScopeofWorkA18').val();
        var ScopeofWorkA19 = $('#lblScopeofWorkA19').val();
        var ScopeofWorkA20 = $('#lblScopeofWorkA20').val();
        var ScopeofWorkA21 = $('#lblScopeofWorkA21').val();
        var ScopeofWorkA22 = $('#lblScopeofWorkA22').val();
        var ScopeofWorkA23 = $('#lblScopeofWorkA23').val();
        var ScopeofWorkA24 = $('#lblScopeofWorkA24').val();

        var primaryId = 0;
        if ($("#primaryID").val() != null) {
            primaryId = $("#primaryID").val();
        } 
        var isFormValid = formInputValidation("formPeriodicWorkRecord", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);

            $('#errorMsg').css('visibility', 'visible');

            return false;
        }

        var objSave = {
            PeriodicId: primaryId,
            CustomerId: SelCus,
            FacilityId: SelFacility,
            DocumentNo: DocumentNo,
            Year: Year,
            Month: Month,
            UserAreaCode: UserAreaCode,
            Status: Status,
            ScopeofWorkA1: ScopeofWorkA1,
            ScopeofWorkA2: ScopeofWorkA2,
            ScopeofWorkA3: ScopeofWorkA3,
            ScopeofWorkA4: ScopeofWorkA4,
            ScopeofWorkA5: ScopeofWorkA5,
            ScopeofWorkA6: ScopeofWorkA6,
            ScopeofWorkA7: ScopeofWorkA7,
            ScopeofWorkA8: ScopeofWorkA8,
            ScopeofWorkA9: ScopeofWorkA9,
            ScopeofWorkA10: ScopeofWorkA10,
            ScopeofWorkA11: ScopeofWorkA11,
            ScopeofWorkA12: ScopeofWorkA12,
            ScopeofWorkA13: ScopeofWorkA13,
            ScopeofWorkA14: ScopeofWorkA14,
            ScopeofWorkA15: ScopeofWorkA15,
            ScopeofWorkA16: ScopeofWorkA16,
            ScopeofWorkA17: ScopeofWorkA17,
            ScopeofWorkA18: ScopeofWorkA18,
            ScopeofWorkA19: ScopeofWorkA19,
            ScopeofWorkA20: ScopeofWorkA20,
            ScopeofWorkA21: ScopeofWorkA21,
            ScopeofWorkA22: ScopeofWorkA22,
            ScopeofWorkA23: ScopeofWorkA23,
            ScopeofWorkA24: ScopeofWorkA24,
            UserAreaDetailsList: []
        }
        $("#tblPeriodicCleaningDetails tbody tr").each(function () {
            var row = $(this);
            var PeriodicWorkRecordobj = {};
            PeriodicWorkRecordobj.UserAreaCode = row.children("td").find("text").eq(0).html();
            PeriodicWorkRecordobj.Status = row.children("td").find("select").children("option:selected").val();
            PeriodicWorkRecordobj.ScopeofWorkA1 = row.children("td").find("text").eq(1).html();
            PeriodicWorkRecordobj.ScopeofWorkA2 = row.children("td").find("text").eq(2).html();
            PeriodicWorkRecordobj.ScopeofWorkA3 = row.children("td").find("text").eq(3).html();
            PeriodicWorkRecordobj.ScopeofWorkA4 = row.children("td").find("text").eq(4).html();
            PeriodicWorkRecordobj.ScopeofWorkA5 = row.children("td").find("text").eq(5).html();
            PeriodicWorkRecordobj.ScopeofWorkA6 = row.children("td").find("text").eq(6).html();
            PeriodicWorkRecordobj.ScopeofWorkA7 = row.children("td").find("text").eq(7).html();
            PeriodicWorkRecordobj.ScopeofWorkA8 = row.children("td").find("text").eq(8).html();
            PeriodicWorkRecordobj.ScopeofWorkA9 = row.children("td").find("text").eq(9).html();
            PeriodicWorkRecordobj.ScopeofWorkA10 = row.children("td").find("text").eq(10).html();
            PeriodicWorkRecordobj.ScopeofWorkA11 = row.children("td").find("text").eq(11).html();
            PeriodicWorkRecordobj.ScopeofWorkA12 = row.children("td").find("text").eq(12).html();
            PeriodicWorkRecordobj.ScopeofWorkA13 = row.children("td").find("text").eq(13).html();
            PeriodicWorkRecordobj.ScopeofWorkA14 = row.children("td").find("text").eq(14).html();
            PeriodicWorkRecordobj.ScopeofWorkA15 = row.children("td").find("text").eq(15).html();
            PeriodicWorkRecordobj.ScopeofWorkA16 = row.children("td").find("text").eq(16).html();
            PeriodicWorkRecordobj.ScopeofWorkA17 = row.children("td").find("text").eq(17).html();
            PeriodicWorkRecordobj.ScopeofWorkA18 = row.children("td").find("text").eq(18).html();
            PeriodicWorkRecordobj.ScopeofWorkA19 = row.children("td").find("text").eq(19).html();
            PeriodicWorkRecordobj.ScopeofWorkA20 = row.children("td").find("text").eq(20).html();
            PeriodicWorkRecordobj.ScopeofWorkA21 = row.children("td").find("text").eq(21).html();
            PeriodicWorkRecordobj.ScopeofWorkA22 = row.children("td").find("text").eq(22).html();
            PeriodicWorkRecordobj.ScopeofWorkA23 = row.children("td").find("text").eq(23).html();
            PeriodicWorkRecordobj.ScopeofWorkA24 = row.children("td").find("text").eq(24).html();
            objSave.UserAreaDetailsList.push(PeriodicWorkRecordobj);
        });
        
        $.post("/api/PeriodicWorkRecord/Save", objSave, function (response) {
            var result = JSON.parse(response);
            showMessage('Periodic Work Record', CURD_MESSAGE_STATUS.SS);
            $("#primaryID").val(result.PeriodicId);
            $("#grid").trigger('reloadGrid');
           
            if (CurrentbtnID == "btnSaveandAddNew") {
                EmptyFieldsPeriodicWorkRecord();     
                showMessage('Periodic Work Record', CURD_MESSAGE_STATUS.SS);               
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

    $("#btnSaveAttachment").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg1').css('visibility', 'hidden');

        var FileType = $('#ddlFileType').val();
        var FileName = $('#txtFileName').val();
        var Attachment = $('#txtAttachment').val();
        var primaryId = $("#primaryID").val();

        var isFormValid = formInputValidation("formJi", 'save');

        if (!isFormValid) {

            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg1').css('visibility', 'visible');

            return false;
        }

        var obj = {

            FileType: FileType,
            FileName: FileName,
            Attachment: Attachment,
            DetailsId: primaryId,
            JIAttachmentSaveList: []

        }
        $('#AttachmentTable tbody tr').each(function () {
            var tbl = {};
            tbl.DetailsId = "1";
            tbl.FileType = $(this).find("[id^=ddlFileType]")[0].value;
            tbl.FileName = $(this).find("[id^=txtFileName]")[0].value;
            tbl.Attachment = $(this).find("[id^=txtAttachment]")[0].value;
            obj.JIAttachmentSaveList.push(tbl);
        });

        $.post("/api/PeriodicWorkRecord/AttachmentSave", obj, function (response) {
            showMessage('JiDetails', CURD_MESSAGE_STATUS.SS);
            var result = JSON.parse(response);
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
                $('#errorMsg1').css('visibility', 'hidden');

                $('#btnSaveAttachment').attr('disabled', false);

            });

    });

    $("#btnFetch").click(function () {

        var Year = $('#ddlYear').val();
        var Month = $('#ddlMonth').val();
        var primaryId = 0;
        if ($("#primaryID").val() != null) {
            primaryId = $("#primaryID").val();
        } 

        var objFetch = {
            PeriodicId: primaryId,
            Year: Year,
            Month: Month
        }
        $.post("/api/PeriodicWorkRecord/DocFetch", objFetch, function (response) {
                var result = JSON.parse(response);
                if (result.UserAreaDetailsList.length > 0) {
                    $('#table_data').hide();
                    $('#tbodyResult').show();
                    var trStru = "";
                    for (var i = 0; i < result.UserAreaDetailsList.length; i++) {

                        trStru += "<tr><td style='background:#eee;cursor:not-allowed'><text id='txtUserAreaCode" + i + "'>" + result.UserAreaDetailsList[i].UserAreaCode + "</text></td>"
                            + "<td><select id='ddlStatus" + i + "'>" + StatusVal + "</select ></td > "
                            + "<td><text id='txtScopeA1_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA1 + "</text></td>"
                            + "<td><text id='txtScopeA2_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA2 + "</text></td>"
                            + "<td><text id='txtScopeA3_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA3 + "</text></td>"
                            + "<td><text id='txtScopeA4_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA4 + "</text></td>"
                            + "<td ><text id='txtScopeA5_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA5 + "</text></td>"
                            + "<td><text id='txtScopeA6_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA6 + "</text></td>"
                            + "<td><text id='txtScopeA7_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA7 + "</text></td>"
                            + "<td><text id='txtScopeA8_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA8 + "</text></td>"
                            + "<td><text id='txtScopeA9_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA9 + "</text></td>"
                            + "<td><text id='txtScopeA10_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA10 + "</text></td>"
                            + "<td><text id='txtScopeA11_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA11 + "</text></td>"
                            + "<td><text id='txtScopeA12_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA12 + "</text></td>"
                            + "<td><text id='txtScopeA13_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA13 + "</text></td>"
                            + "<td><text id='txtScopeA14_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA14 + "</text></td>"
                            + "<td><text id='txtScopeA15_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA15 + "</text></td>"
                            + "<td><text id='txtScopeA16_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA16 + "</text></td>"
                            + "<td><text id='txtScopeA17_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA17 + "</text></td>"
                            + "<td><text id='txtScopeA18_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA18 + "</text></td>"
                            + "<td><text id='txtScopeA19_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA19 + "</text></td>"
                            + "<td><text id='txtScopeA20_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA20 + "</text></td>"
                            + "<td><text id='txtScopeA21_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA21 + "</text></td>"
                            + "<td><text id='txtScopeA22_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA22 + "</text></td>"
                            + "<td><text id='txtScopeA23_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA23 + "</text></td>"
                            + "<td><text id='txtScopeA24_P" + i + "'>" + result.UserAreaDetailsList[i].ScopeofWorkA24 + "</text></td>"
                            + "</tr>"
                    }
                    $('#tbodyResult').html(trStru);
                    $('#tbodyResult').find("select").addClass("form-control");
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
                    EmptyFieldsPeriodicWorkRecord();                  
                
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            }
        });
    });

    function EmptyFieldsPeriodicWorkRecord() {

        $('#formPeriodicWorkRecord')[0].reset();
        $('#primaryID').val(0); 
        $('#table_data').show();
        AutoGen(obj1);
        $('#errorMsg').css('visibility', 'hidden');
       
        $("#tbodyResult").find('tr').each(function () {           
                $(this).remove();           
        });
        $('#YearVal').removeClass('has-error');
        $('#MonthVal').removeClass('has-error');

        $(".content").scrollTop(0);
                      
    }

    //auto generated code for Document number
    var DocumentNo = $('#txtDocumentNo').val();

    var obj1 = {
        DocumentNo: DocumentNo
    }
    AutoGen(obj1);

    //------------------------------------------------------
    // validation red border removal

    $('#ddlYear').on('change', function () {
        $('#YearVal').removeClass('has-error');
    });

    $('#ddlMonth').on('change', function () {
        $('#MonthVal').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });
});

function AutoGen(obj1) {
    $.get("/api/PeriodicWorkRecord/AutoGeneratedCode", obj1, function (response) {

        var result = JSON.parse(response);             
        $('#txtDocumentNo').val(result.DocumentNo);

    });
}

$("#jQGridCollapse1").click(function () {
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
    $("#formPeriodicWorkRecord :input:not(:button)").parent().removeClass('has-error');
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
        $("#formPeriodicWorkRecord :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();

        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

     var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/PeriodicWorkRecord/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                var rowlength = getResult.UserAreaDetailsList.length;

                if (getResult != undefined) {

                    var Docno = getResult.DocumentNo;
                    var Year = getResult.Year;
                    var Month = getResult.Month;

                    $('#txtDocumentNo').val(Docno);
                    $('#ddlYear').val(Year);
                    $('#ddlMonth').val(Month);
                }
                var trStruGrid = "";
                $('#tbodyResult').html('');
                for (var i = 0; i < rowlength; i++) {
                    
                    trStruGrid = "<tr><td style='background:#eee;cursor:not-allowed'><text id='txtUserAreaCode" + i + "'>" + getResult.UserAreaDetailsList[i].UserAreaCode + "</text></td>"
                        + "<td><select id='ddlStatus" + i + "'>" + StatusVal + "</select ></td > "
                        + "<td><text id='txtScopeA1_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA1 + "</text></td>"
                        + "<td><text id='txtScopeA2_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA2 + "</text></td>"
                        + "<td><text id='txtScopeA3_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA3 + "</text></td>"
                        + "<td><text id='txtScopeA4_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA4 + "</text></td>"
                        + "<td><text id='txtScopeA5_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA5 + "</text></td>"
                        + "<td><text id='txtScopeA6_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA6 + "</text></td>"
                        + "<td><text id='txtScopeA7_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA7 + "</text></td>"
                        + "<td><text id='txtScopeA8_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA8 + "</text></td>"
                        + "<td><text id='txtScopeA9_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA9 + "</text></td>"
                        + "<td><text id='txtScopeA10_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA10 + "</text></td>"
                        + "<td><text id='txtScopeA11_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA11 + "</text></td>"
                        + "<td><text id='txtScopeA12_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA12 + "</text></td>"
                        + "<td><text id='txtScopeA13_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA13 + "</text></td>"
                        + "<td><text id='txtScopeA14_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA14 + "</text></td>"
                        + "<td><text id='txtScopeA15_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA15 + "</text></td>"
                        + "<td><text id='txtScopeA16_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA16 + "</text></td>"
                        + "<td><text id='txtScopeA17_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA17 + "</text></td>"
                        + "<td><text id='txtScopeA18_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA18 + "</text></td>"
                        + "<td><text id='txtScopeA19_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA19 + "</text></td>"
                        + "<td><text id='txtScopeA20_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA20 + "</text></td>"
                        + "<td><text id='txtScopeA21_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA21 + "</text></td>"
                        + "<td><text id='txtScopeA22_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA22 + "</text></td>"
                        + "<td><text id='txtScopeA23_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA23 + "</text></td>"
                        + "<td><text id='txtScopeA24_P" + i + "'>" + getResult.UserAreaDetailsList[i].ScopeofWorkA24 + "</text></td>"
                        + "</tr>"

                    $('#tbodyResult').append(trStruGrid);

                    var StatusValue = getResult.UserAreaDetailsList[i].Status;
                    $('#ddlStatus' + i).val(StatusValue);
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


