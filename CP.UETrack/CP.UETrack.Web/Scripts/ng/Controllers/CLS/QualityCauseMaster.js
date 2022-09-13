var statusdrodown = "";
var FailureTypedropdown = "";
var rowNum1 = 1;
$(document).ready(function () {
 
    $.get("/api/CLSQualityCauseMaster/Load")
        .done(function (result) {

            var loadResult = JSON.parse(result);
            $("#ddlFailureType1").append("<option value='' Selected>" + "Select" + "</option>");
          
            for (var i = 0; i < loadResult.FailureTypeLovs.length; i++) {
                    FailureTypedropdown += "<option value=" + loadResult.FailureTypeLovs[i].LovId + ">" + loadResult.FailureTypeLovs[i].FieldValue + "</option>"
            }
            for (var i = 0; i < loadResult.StatusLovs.length; i++) {
                statusdrodown += "<option value=" + loadResult.StatusLovs[i].LovId + ">" + loadResult.StatusLovs[i].FieldValue + "</option>";
            }
           
            $("#ddlFailureType1").append(FailureTypedropdown);
            $("#ddlStatus1").append(statusdrodown);
            $('#myPleaseWait').modal('hide');
        })
        .fail(function () {
    $('#myPleaseWait').modal('hide');
    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
    $('#errorMsg').css('visibility', 'visible');
});
    //CLS...
    $("#btnSave, #btnSaveAddNew").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');

        var CustomerId = $('#selCustomerLayout').val();
        var FacilityId = $('#selFacilityLayout').val();
        var FailureSymptomNo = $('#txtFailureSymptomCode').val();
        var DescriptionDetails = $('#txtDescription').val();
       
       
        var isFormValid = formInputValidation("formQualityCauseMaster", 'save');

        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }

        var arr = [];
        var isDuplicate = 0;
        $("[id^=txtFailureRootCauseCode]").each(function () {
            var value = $(this).val();
            if (arr.indexOf(value) == -1) {
                arr.push(value);
                $(this).addClass('has-error');
            }
            else {
                isDuplicate += 1;
            }
        });

        if (isDuplicate > 0) {
            $("div.errormsgcenter").text('Duplicate Failure Root Cause Code');
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }

        var primaryId = 0;        
        if ($("#primaryID").val() != null) {
            primaryId = $("#primaryID").val();    
        }

        var obj = {
            QualityCauseMasterId: primaryId,
            CustomerId: CustomerId,
            FacilityId: FacilityId,
            FailureSymptomCode: FailureSymptomNo,
            Description: DescriptionDetails,
            FailureList: []
        }

        $("#QualityCauseMastertable tbody tr").each(function () {

            var tbl = {};           
            tbl.QualityId = $(this).find("[id^=hdnFailureId]")[0].value;
            tbl.FailureType = $(this).find("[id^=ddlFailureType]")[0].value;
            tbl.FailureRootCauseCode = $(this).find("[id^=txtFailureRootCauseCode]")[0].value;
            tbl.Details = $(this).find("[id^=txtDetails]")[0].value;
            tbl.Status = $(this).find("[id^=ddlStatus]")[0].value;
            tbl.isDeleted = $(this).find('input:checkbox[id^=isDelete]').prop("checked");
            obj.FailureList.push(tbl);
        });

       
        $.post("/api/CLSQualityCauseMaster/Save", obj, function (response) {
            var result = JSON.parse(response);
            showMessage('QualityCauseMaster', CURD_MESSAGE_STATUS.SS);
            $("#primaryID").val(result.QualityCauseMasterId);                      

            $("#grid").trigger('reloadGrid');
            if (CurrentbtnID == "btnSaveAddNew") {
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

    function EmptyFields() {

        $('#formQualityCauseMaster')[0].reset();
        $("#primaryID").val(0);
        $('[id^=hdnFailureId]').val(0);

        $('#formQualityCauseMaster #Code').removeClass('has-error');
        $('#formQualityCauseMaster #descrpt').removeClass('has-error');
        $('#formQualityCauseMaster #Failure').removeClass('has-error');
        $('#formQualityCauseMaster #Causecode').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
        rowNum1 = 1;
        var i = 1;
        $("#tbodyFailureType").find('tr').each(function () {
            if (i > 1) {
                $(this).remove();
            }
            i += 1;
        });
    }
    $('#txtFailureSymptomCode').keypress(function () {
        $('#Code').removeClass('has-error');
    });
    $('#txtDescription').keypress(function () {
        $('#descrpt').removeClass('has-error');
    });
    $('#ddlFailureType').change(function () {
        $('#formQualityCauseMaster #Failure').removeClass('has-error');
    });
    $('#txtFailureRootCauseCode').keypress(function () {
        $('#formQualityCauseMaster #Causecode').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });
    //Reset Button Code....
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
        //Add Rows Code....
    
 
    $("#addFailureType").click(function () {
        rowNum1 += 1;
        addFailureType(rowNum1);
     
    });

    //Except initial row in a table Mutliple rows delete button code
    //Mutliple rows delete button code....
    $("#deleteFailureType").click(function () {

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
                        $("#tbodyFailureType tr").find('input[name="isDelete"]').each(function () {
                            if ($(this).is(":checked")) {
                                if ($(this).closest("tr").find("[id^=hdnFailureId]").val() == 0) {
                                    $(this).closest("tr").remove();
                                }
                            }
                        });
                    }
                    else
                        alert("Please select atleast one row !");
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
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
        $.get("/api/CLSQualityCauseMaster/Get/" + primaryId)
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

    if (result != null) {

        $('#primaryID').val(result.QualityCauseMasterId);
        $('#txtFailureSymptomCode').val(result.FailureSymptomCode);
        $('#txtDescription').val(result.Description);
        $('#ddlFailureType').val(result.FailureType);
        $('#txtFailureRootCauseCode').val(result.FailureRootCauseCode);
        $('#txtDetails').val(result.Details);
        $('#ddlStatus').val(result.Status);

        rowNum1 = 1;
        $("#tbodyFailureType").html('');

        if (result.FailureList != null) {

            for (var i = 0; i < result.FailureList.length; i++) {

                addFailureType(rowNum1);
                $('#hdnFailureId' + rowNum1).val(result.FailureList[i].QualityId);
                $('#ddlFailureType' + rowNum1).val(result.FailureList[i].FailureType);
                $('#txtFailureRootCauseCode' + rowNum1).val(result.FailureList[i].FailureRootCauseCode);
                $('#txtDetails' + rowNum1).val(result.FailureList[i].Details);
                $('#ddlStatus' + rowNum1).val(result.FailureList[i].Status);

                rowNum1 += 1;
            }
        }
        else {
            addFailureType(rowNum1);
        }

    }

    

}

function addFailureType(num) {

    var CheckBox = '<td style="text-align:center"> <input type="checkbox" id="isDelete' + num + '" name="isDelete" ><input type="hidden" id="hdnFailureId' + num + '"  value="0"   /> </td>';
    var FailureType = '<td id="Type"> <select type="text" required class="form-control" id="ddlFailureType' + num + '" autocomplete="off" name="FailureType" maxlength="25"  > <option value="">Select</option>' + FailureTypedropdown + '</td>';
    var FailureRootCauseCode = '<td  id="Causecode"><input type="text" required class="form-control" id="txtFailureRootCauseCode' + num + '" autocomplete="off" name="FailureRootCauseCode" maxlength="25"  /></td>';
    var Details = '<td> <input type="text"  class="form-control" id="txtDetails' + num + '" autocomplete="off" name="Details" maxlength="25"  /></td>';
    var Status = '<td> <select type="text" class="form-control" id="ddlStatus' + num + '" autocomplete="off"  name="Status" maxlength="25" >' + statusdrodown + '</td>';

    $("#tbodyFailureType").append('<tr class="tablerow">' + CheckBox + FailureType + FailureRootCauseCode + Details + Status + '</tr>');

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



