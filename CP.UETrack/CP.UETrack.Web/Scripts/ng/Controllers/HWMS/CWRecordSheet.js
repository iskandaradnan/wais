var CollectionStatusValue = "";
var qualitycausecodeValue = "";
var SanitizeValue = "";
var SanitizeYesValue = 0;
var SantizeNoValue = 0;
var rowNum = 0;
var n1 = 0;
var n2 = 0;
var n3 = 0;
var FileTypeValues = "";
var filePrefix = "CWRS_";
var ScreenName = "CWRecordSheet";
var rowNum2 = 1;

$(document).ready(function () {

    qualitycausecodeValue = "<option value='0'>SELECT</option>";
    $.get("/api/CWRecordSheet/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
           
            for (var i = 0; i < loadResult.CollectionStatusLovs.length; i++) {              
                    CollectionStatusValue+= "<option value=" + loadResult.CollectionStatusLovs[i].LovId + ">" + loadResult.CollectionStatusLovs[i].FieldValue + "</option>"              
            }
            $("#ddlCollectionStatus1").append(CollectionStatusValue);
            for (var i = 0; i < loadResult.qualitycausecodeLovs.length; i++) {             
                    qualitycausecodeValue+= "<option value=" + loadResult.qualitycausecodeLovs[i].LovId + ">" + loadResult.qualitycausecodeLovs[i].FieldValue + "</option>"             
            }
            $("#ddlqualitycausecode1").append(qualitycausecodeValue);
            for (var i = 0; i < loadResult.SanitizeLovs.length; i++) {                
                if (loadResult.SanitizeLovs[i].FieldValue == 'Yes') {
                    SanitizeYesValue = loadResult.SanitizeLovs[i].LovId;
                } else {
                    SantizeNoValue = loadResult.SanitizeLovs[i].LovId;
                }

                SanitizeValue += "<option value=" + loadResult.SanitizeLovs[i].LovId + ">" + loadResult.SanitizeLovs[i].FieldValue + "</option>"               
            }
            $("#ddlSanitize1").append(SanitizeValue);

            FileTypeValues = "<option value='' Selected>" + "Select" + "</option>";
            FileTypeValues += "<option value='1'>" + "CWRS" + "</option>";
            $("#ddlFileType1").append(FileTypeValues);

            $('#myPleaseWait').modal('hide');
        })
        .fail(function (response) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            $('#errorMsgConfigAdditionalFields').css('visibility', 'visible');
        });

    $("#btnSave, #btnSaveandAddNew").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');  
        
        var isFormValid = formInputValidation("formCWRecordSheet", 'save');
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
            CWRecordSheetId: primaryId,
            CustomerId: $('#selCustomerLayout').val(),
            FacilityId: $('#selFacilityLayout').val(),
            Date: $('#txtDate').val(),
            TotalUserArea: $('#txtTotalUserArea').val(),
            TotalBagCollected: $('#txtTotalBagCollected').val(),
            TotalSanitized: $('#txtTotalsanitized').val(),
           
            CWRecordSheetCollectionDetailsList: [],          
        }
        
        $('#tbodyCollectionDetails  tr').each(function () {

            var CollectionObj = {};
            
            CollectionObj.CollectionDetailsId = $(this).find("[id^=hdnCollectionDetailsId]")[0].value;
            CollectionObj.UserAreaCode = $(this).find("[id^=txtUserAreaCode]")[0].value;
            CollectionObj.CollectionFrequency = $(this).find("[id^=txtCollectionFrequency]")[0].value;
            CollectionObj.FrequencyType = $(this).find("[id^=txtFequencyType]")[0].value;
            CollectionObj.CollectionTime = $(this).find("[id^=txtCollectionTime]")[0].value;
            CollectionObj.CollectionStatus = $(this).find("[id^=ddlCollectionStatus]")[0].value;
            CollectionObj.QC = $(this).find("[id^=ddlQC]")[0].value;
            CollectionObj.NoofBags = $(this).find("[id^=txtNoofBags]")[0].value;
            CollectionObj.NoofReceptaclesOnsite = $(this).find("[id^=txtNoofReceptacleOnsite]")[0].value;  
            CollectionObj.NoofReceptacleSanitize = $(this).find("[id^=txtNoofReceptacleSanitize]")[0].value;               
            CollectionObj.Sanitize = $(this).find("[id^=ddlSanitize]")[0].value;                    
            CollectionObj.isDeleted = $(this).find('input:checkbox[id^=isDelete]').prop("checked");
            
            obj.CWRecordSheetCollectionDetailsList.push(CollectionObj);

        });

            $('#myPleaseWait').modal('show');
                   
           $.post("/Api/CWRecordSheet/Save", obj, function (response) {
               $('#myPleaseWait').modal('hide');
                var result = JSON.parse(response);
               $("#primaryID").val(result.CWRecordSheetId);
               showMessage('CWRecordSheet', CURD_MESSAGE_STATUS.SS);

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
                    getTotalBags();
                    getTotalSanitized();
                   
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            }
        });

    });
     
    $("#CollectionDetailsFetch").click(function () {

        var Date = $('#txtDate').val();
        var Id = $("#primaryID").val();
        if (Date != 0) {

            $.get("/api/CWRecordSheet/CollectionDetailsFetch/" + Id, function (response) {

                var result = JSON.parse(response);
                var TotalUserAreas = result.CWRecordSheetCollectionDetailsList.length;
                $("#tbodyCollectionDetails").html('');
                if (result.CWRecordSheetCollectionDetailsList != null) {

                    if (result.CWRecordSheetCollectionDetailsList.length > 0) {
                        var RowNum2 = 1;
                       
                        for (var j = 0; j < result.CWRecordSheetCollectionDetailsList.length; j++) {
                            
                            var FrequencyNumber = parseInt(result.CWRecordSheetCollectionDetailsList[j].CollectionFrequency);
                            for (var i = 0; i < FrequencyNumber; i++) {
                               
                                var CheckBox = '<td style="text-align:center"><input type="checkbox" id="isDelete' + RowNum2+'" name="isDelete" /><input type="hidden" id="hdnCollectionDetailsId' + RowNum2 + '" value="0"</td>';
                                var UserAreaCode = '<td>  <input type="text" required class="form-control" id="txtUserAreaCode' + RowNum2 + '"  autocomplete="off" name="UserAreaCode" maxlength="25"  /></td>';
                                var FequencyType = '<td>  <input type="text"  class="form-control" id="txtFequencyType' + RowNum2 + '"  autocomplete="off" name="FequencyType" maxlength="25"  /></td>';
                                var CollectionFrequency = '<td> <input type="text" required class="form-control" id="txtCollectionFrequency' + RowNum2 + '"  autocomplete="off" name="CollectionFrequency" maxlength="25"  /></td>';
                                var CollectionTime = '<td>  <input type="Time" required class="form-control Time" id="txtCollectionTime' + RowNum2 + '"  autocomplete="off" name="CollectionTime" maxlength="25"  /></td>';
                                var CollectionStatus = '<td>  <select required class="form-control CollectionStatus"  id="ddlCollectionStatus' + RowNum2 + '">' + CollectionStatusValue + '</select></td>';
                                var QC = '<td>  <select  disabled class="form-control" id="ddlQC' + RowNum2 + '">' + qualitycausecodeValue + '</select></td>';
                                var NoofBags = '<td>  <input type="text" required class="form-control TotalBags" id="txtNoofBags' + RowNum2 + '"  autocomplete="off" name="FailureType" maxlength="25"  /></td>';
                                var NoofReceptacleOnsite = '<td>  <input type="text"  class="form-control" id="txtNoofReceptacleOnsite' + RowNum2 + '" autocomplete="off" name="FailureType" maxlength="25"  /></td>';
                                var NoofReceptacleSanitize = '<td>  <input type="text"  class="form-control Totalreceptacles" id="txtNoofReceptacleSanitize' + RowNum2 + '"  autocomplete="off" name="FailureType" maxlength="25"  /></td>';
                                var Sanitize = '<td> <select required class="form-control" id="ddlSanitize' + RowNum2 + '">' + SanitizeValue + '</select></td>';

                                $("#tbodyCollectionDetails ").append('<tr>' + CheckBox + UserAreaCode + FequencyType + CollectionFrequency + CollectionTime + CollectionStatus + QC + NoofBags + NoofReceptacleOnsite + NoofReceptacleSanitize + Sanitize + '</tr>');

                                $('#txtUserAreaCode' + RowNum2 + '').val(result.CWRecordSheetCollectionDetailsList[j].UserAreaCode);
                                $('#txtCollectionFrequency' + RowNum2 + '').val(i + 1);
                                $('#txtFequencyType' + RowNum2 + '').val(result.CWRecordSheetCollectionDetailsList[j].FrequencyType);
                                $('#txtNoofReceptacleOnsite' + RowNum2 + '').val(result.CWRecordSheetCollectionDetailsList[j].NoofReceptaclesOnsite);
                                $('#txtNoofReceptacleSanitize' + RowNum2 + '').val(result.CWRecordSheetCollectionDetailsList[j].NoofReceptacleSanitize);

                                RowNum2 = RowNum2 + 1;
                            }
                        }
                        n = $("#tbodyCollectionDetails").find("tr").length;
                        $('#txtTotalUserArea').val(n - 1);
                        $('#display').hide();

                    }

                    getTotalBags();
                    getTotalSanitized();
                }

            },
                "json")
                .fail(function (response) {
                    var errorMessage = "";
                    if (response.status == 400) {

                    }
                    else {

                    }

                    $('#btnFetch').attr('disabled', false);

                });
           
            $('#myPleaseWait').modal('hide');
        }
        else {

            var message = "Please Select Date";
            bootbox.confirm(message, function (result) {
                if (result) {
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            });

        }
                              
    });

    
 
    $("body").on('input', '.TotalBags', function () {
        getTotalBags();
    });

    $("body").on('input', '.CollectionStatus', function () {

        var CollectionStatusId = event.target.id;

        var QCId = $(this).closest('tr').find("[id^=ddlQC]")[0].id;

        if ($(this)[0].selectedOptions[0].innerText == 'Not Done') {                       
            $("#" + QCId).prop('disabled', false);
            $("#" + QCId).prop('required', true);
        }
        else {
            $("#" + QCId).prop('disabled', true);
            $("#" + QCId).prop('required', false);
        }

        
       
    });

    $("body").on('input', '.Totalreceptacles', function () {

        var TotalreceptacleslId = event.target.id;

        var Totalreceptacles = $("#" + TotalreceptacleslId).val();
        var OnSiteReceptacles = $(this).closest('tr').find("[id^=txtNoofReceptacleOnsite]")[0].value;
        var SanitizeId = $(this).closest('tr').find("[id^=ddlSanitize]")[0].id;
        //isNumeric(Totalreceptacles)
        if (parseInt(Totalreceptacles) >= parseInt(OnSiteReceptacles)) {
            $("#" + SanitizeId).val(SanitizeYesValue);
        }
        else {
            $("#" + SanitizeId).val(SantizeNoValue);
        }

        getTotalSanitized();
       
    });

   
    $("#addCollectionDetails").click(function () {
        rowNum += 1;
        addCollectionDetails(rowNum);            
    })
   
    $("#deleteCollectionDetails").click(function () {

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

                        $("#tbodyCollectionDetails").find('input[name="isDelete"]').each(function () {
                           
                            if ($(this).is(":checked")) {
                                if ($(this).closest("tr").find("[id^=hdnCollectionDetailsId]").val() == 0) {
                                    $(this).closest("tr").remove();
                                    n2 = $("#tbodyCollectionDetails").find("tr").length;
                                    n3 = n2;
                                    $('#txtTotalUserArea').val((n3));
                                    getTotalBags();
                                    getTotalSanitized();
                                                                      
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

    $('#txtDate').change('change', function () {

        //$('#Date1').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
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
    $("#formBemsBlock :input:not(:button)").parent().removeClass('has-error');
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
        $("#formBemsBlock :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();

        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/CWRecordSheet/Get/" + primaryId)
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
        
        var Date = getCustomDate(result.Date);
        $("#primaryID").val(result.CWRecordSheetId)
        $('#txtDate').val(Date);         
        $('#txtTotalUserArea').val(result.TotalUserArea);
        $('#txtTotalBagCollected').val(result.TotalBagCollected);
        $('#txtTotalsanitized').val(result.TotalSanitized);
        var rowNum1 = 1;
        $('#tbodyCollectionDetails').html('');
       
        if (result.CWRecordSheetCollectionDetailsList != null) {
            for (i = 0; i < result.CWRecordSheetCollectionDetailsList.length; i++) {

                addCollectionDetails(rowNum1);
                $('#display').hide();
                var Collectiontime = result.CWRecordSheetCollectionDetailsList[i].CollectionTime;
                $('#hdnCollectionDetailsId' + rowNum1).val(result.CWRecordSheetCollectionDetailsList[i].CollectionDetailsId);
                $('#txtUserAreaCode' + rowNum1).val(result.CWRecordSheetCollectionDetailsList[i].UserAreaCode);
                $('#txtFequencyType' + rowNum1).val(result.CWRecordSheetCollectionDetailsList[i].FrequencyType);
                $('#txtCollectionFrequency' + rowNum1).val(result.CWRecordSheetCollectionDetailsList[i].CollectionFrequency);
                $('#txtCollectionTime' + rowNum1).val(Collectiontime);
                $('#ddlCollectionStatus' + rowNum1).val(result.CWRecordSheetCollectionDetailsList[i].CollectionStatus);
                $('#ddlQC' + rowNum1).val(result.CWRecordSheetCollectionDetailsList[i].QC);
                $('#txtNoofBags' + rowNum1).val(result.CWRecordSheetCollectionDetailsList[i].NoofBags);
                $('#txtNoofReceptacleOnsite' + rowNum1).val(result.CWRecordSheetCollectionDetailsList[i].NoofReceptaclesOnsite);
                $('#txtNoofReceptacleSanitize' + rowNum1).val(result.CWRecordSheetCollectionDetailsList[i].NoofReceptacleSanitize);
                $('#ddlSanitize' + rowNum1).val(result.CWRecordSheetCollectionDetailsList[i].Sanitize);

                rowNum1 += 1;
            }
        }
        else {
            addCollectionDetails(rowNum1);
        }

        fillAttachment(result.AttachmentList);

        n2 = $("#tbodyCollectionDetails").find("tr").length;       
        $('#txtTotalUserArea').val((n2));
        getTotalBags();
        getTotalSanitized();

    }

}

function EmptyFields() {
    $(".content").scrollTop(0);
    $('#formCWRecordSheet')[0].reset();
    $('#primaryID').val(0);
    $('[id^=hdnCollectionDetailsId]').val(0);
    $('#txtDate').val('');
    $('#Date1').removeClass('has-error');
    $('#UserAreacode').removeClass('has-error');
    $('#Frequency').removeClass('has-error');
    $('#NoOfBags').removeClass('has-error');
    $('#errorMsg').css('visibility', 'hidden');
    $('#txtTotalUserArea').val('');
    var i = 1;
    $("#tbodyCollectionDetails").find('tr').each(function () {
        if (i > 1) {
            $(this).remove();
        }
        i += 1;
    });
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

function getTotalBags() {
    var calculated_total_sum = 0;

    $("#tbodyCollectionDetails .TotalBags").each(function () {
        var get_textbox_value = $(this).val();
        if ($.isNumeric(get_textbox_value)) {
            calculated_total_sum += parseFloat(get_textbox_value);
        }
    });
    $("#txtTotalBagCollected").val(calculated_total_sum);
}

function getTotalSanitized() {
    
    var calculated_total_sum1 = 0;
         
    //$("#tbodyCollectionDetails .Totalreceptacles").each(function () {
    //    var get_textbox_value1 = $(this).val();
    //    if ($.isNumeric(get_textbox_value1)) {
    //        calculated_total_sum1 += parseFloat(get_textbox_value1);
    //    }

    //});

    $("#tbodyCollectionDetails .Totalreceptacles").each(function () {

        // $('#ddlSanitize' )
        var ddlSanitize = $(this).parent().parent().children().find("[id^=ddlSanitize]");

        if (ddlSanitize[0][ddlSanitize[0].selectedIndex].innerText == "Yes") {

            calculated_total_sum1 += 1;
        }

    });
    $("#txtTotalsanitized").val(calculated_total_sum1);
}

function addCollectionDetails(num) {

    var CheckBox = '<td style="text-align:center"><input type="checkbox" id="isDelete' + num + '" name="isDelete" /> <input type="hidden" id="hdnCollectionDetailsId' + num + '" value="0" /></td>';
    var UserAreaCode = '<td id="UserAreacode">  <input type="text" required class="form-control" id="txtUserAreaCode' + num + '"  autocomplete="off" name="UserAreaCode" maxlength="25"  /></td>';
    var CollectionFrequency = '<td id="Frequency"> <input type="text" required class="form-control" id="txtCollectionFrequency' + num + '"  autocomplete="off" name="CollectionFrequency" maxlength="25"  /></td>';
    var FequencyType = '<td>  <input type="text"  class="form-control" id="txtFequencyType' + num + '"  autocomplete="off" name="FequencyType" maxlength="25"  /></td>';
    var CollectionTime = '<td>  <input type="Time" required class="form-control" id="txtCollectionTime' + num + '"  autocomplete="off" name="CollectionTime" maxlength="25"  /></td>';
    var CollectionStatus = '<td>  <select required class="form-control CollectionStatus"  id="ddlCollectionStatus' + num + '">' + CollectionStatusValue + '</select></td>';
    var QC = '<td>  <select disabled class="form-control" id="ddlQC' + num + '">' + qualitycausecodeValue + '</select></td>';
    var NoofBags = '<td id="NoOfBags">  <input type="text" required class="form-control TotalBags" id="txtNoofBags' + num + '"  autocomplete="off" name="FailureType" maxlength="25"  /></td>';
    var NoofReceptacleOnsite = '<td>  <input type="number"  class="form-control" id="txtNoofReceptacleOnsite' + num + '"  autocomplete="off" name="FailureType" maxlength="25"  /></td>';
    var NoofReceptacleSanitize = '<td>  <input type="number"  class="form-control Totalreceptacles" id="txtNoofReceptacleSanitize' + num + '"  autocomplete="off" name="FailureType" maxlength="25"  /></td>';
    var Sanitize = '<td> <select required class="form-control" id="ddlSanitize' + num + '">' + SanitizeValue + '</select></td>';

    $("#tbodyCollectionDetails").append('<tr>' + CheckBox + UserAreaCode + FequencyType + CollectionFrequency + CollectionTime + CollectionStatus + QC + NoofBags + NoofReceptacleOnsite + NoofReceptacleSanitize + Sanitize + '</tr>');
    $('#display').hide();
    //$('#txtTotalUserArea').val((n-1) + 1);

    var PrimaryId = $("#primaryID").val();
    if (PrimaryId == 0) {
        $('#txtTotalUserArea').val((n3 + 1));
        n1++;
        n3++;
    }
   
}






