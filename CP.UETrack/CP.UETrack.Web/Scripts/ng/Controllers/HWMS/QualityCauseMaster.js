var statusdrodown = "";
var FailureTypedropdown = "";
var rowNum1 = 1;
$(document).ready(function () {

    $.get("/api/HWMSQualityCauseMaster/Load")
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
    //HWMS...
    $("#btnSave, #btnSaveAddNew").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');
        var CustomerId = $('#selCustomerLayout').val();
        var FacilityId = $('#selFacilityLayout').val();
        var FailureSymptomCode = $('#txtFailureSymptomCode').val();
        var Description = $('#txtDescription').val();

        var isFormValid = formInputValidation("formQualityCauseMaster", 'save');
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
            QualityCauseMasterId: primaryId,
            CustomerId: CustomerId,
            FacilityId: FacilityId,
            FailureSymptomCode: FailureSymptomCode,
            Description: Description,         
            FailureList: []
        }
       
        $("#QualityCauseMastertable tbody tr").each(function () {
            var tbl = {};
            tbl.QualityId = $(this).find("[id^=hdnFailureId]")[0].value;
            tbl.FailureType = $(this).find("[id^=ddlFailureType]")[0].value;
            tbl.FailureRootCauseCode = $(this).find("[id^=txtFailureRootCauseCode]")[0].value;
            tbl.Details = $(this).find("[id^=txtDetails]")[0].value;
            tbl.Status = $(this).find("[id^=ddlStatus]")[0].value;
            tbl.isDeleted = $(this).find('input:checkbox[id^=chkDelete]').prop("checked");
            obj.FailureList.push(tbl);
        });
       
        $.post("/api/HWMSQualityCauseMaster/Save", obj, function (response) {
            var result = JSON.parse(response);
            showMessage('QualityCauseMaster', CURD_MESSAGE_STATUS.SS);
            $("#primaryID").val(result.QualityCauseMasterId);

            $("#QualityCauseMastertable tbody").find('[id^=chkDelete]').each(function () {
                if ($(this).is(":checked")) {
                    $(this).closest("tr").remove();
                }
            });
            $("#grid").trigger('reloadGrid');
            if (CurrentbtnID == "btnSaveAddNew") {
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

            });
    });

    function EmptyFields() {
        $("#primaryID").val(0);
        $('[id^=hdnFailureId]').val(0);
        $('#formQualityCauseMaster')[0].reset();
          
        $('#formQualityCauseMaster #Code').removeClass('has-error');
        $('#formQualityCauseMaster #descrpt').removeClass('has-error');
        $('#formQualityCauseMaster #Failure').removeClass('has-error');
        $('#formQualityCauseMaster #Causecode').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');

        var i = 1;
        $("#tbodyFailure").find('tr').each(function () {
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

    $("#add").click(function () {

        rowNum1 += 1;
        var CheckBox = '<td style="text-align:center"> <input type="checkbox" id="chkDelete' + rowNum1 + '" name="record"><input type="hidden" id="hdnFailureId' + rowNum1 + '"  /> </td>';
        var FailureType = '<td id="Type"> <select type="text" required class="form-control" id="ddlFailureType' + rowNum1 + '" autocomplete="off" name="FailureType" maxlength="25"  > <option value="">Select</option>' + FailureTypedropdown + '  </td>';
        var FailureRootCauseCode = '<td  id="Causecode"><input type="text" required class="form-control" id="txtFailureRootCauseCode' + rowNum1 + '" autocomplete="off" name="FailureRootCauseCode" maxlength="25"  /></td>';
        var Details = '<td> <input type="text"  class="form-control" id="txtDetails' + rowNum1 + '" autocomplete="off" name="Details" maxlength="25"  /></td>';
        var Status = '<td> <select type="text" class="form-control" id="ddlStatus' + rowNum1 + '" autocomplete="off"  name="Status" maxlength="25" >' + statusdrodown + '</td>';

        $("#QualityCauseMastertable tbody").append('<tr class="tablerow">' + CheckBox + FailureType + FailureRootCauseCode + Details + Status + '</tr>');

    });
    
    //Mutliple rows delete button code....
    $("#delete").click(function () {

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

                        $("#QualityCauseMastertable tbody").find('input[name="record"]').each(function () {

                            if ($(this).is(":checked")) {

                                $(this).closest("tr").remove();
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
        $.get("/api/HWMSQualityCauseMaster/Get/" + primaryId)
            .done(function (result) {

                var getResult = JSON.parse(result);

                $('#txtFailureSymptomCode').val(getResult.FailureSymptomCode);
                $('#txtDescription').val(getResult.Description);
                $('#ddlFailureType').val(getResult.FailureType);
                $('#txtFailureRootCauseCode').val(getResult.FailureRootCauseCode);
                $('#txtDetails').val(getResult.Details);
                $('#ddlStatus').val(getResult.Status);

                rowNum1 = 1;
                $("#QualityCauseMastertable tbody").html('');

                if (getResult.FailureList != null) {

                    for (var i = 0; i < getResult.FailureList.length; i++) {

                        var CheckBox = '<td style="text-align:center"> <input type="checkbox" id="chkDelete' + rowNum1 + '" name="record"> <input type="hidden" id="hdnFailureId' + rowNum1 + '"  /> </td>';
                        var FailureType = '<td id="Type"> <select type="text" required class="form-control" id="ddlFailureType' + rowNum1 + '" autocomplete="off" name="FailureType" maxlength="25"  > <option value="">Select</option>' + FailureTypedropdown + '  </td>';
                        var FailureRootCauseCode = '<td  id="Causecode"><input type="text" required class="form-control" id="txtFailureRootCauseCode' + rowNum1 + '" autocomplete="off" name="FailureRootCauseCode" maxlength="25"  /></td>';
                        var Details = '<td> <input type="text"  class="form-control" id="txtDetails' + rowNum1 + '" autocomplete="off" name="Details" maxlength="25"  /></td>';
                        var Status = '<td> <select type="text" class="form-control" id="ddlStatus' + rowNum1 + '" autocomplete="off"  name="Status" maxlength="25" >' + statusdrodown + '</td>';

                        $("#QualityCauseMastertable tbody").append('<tr class="tablerow">' + CheckBox + FailureType + FailureRootCauseCode + Details + Status + '</tr>');


                        $('#hdnFailureId' + rowNum1).val(getResult.FailureList[i].QualityId);
                        $('#ddlFailureType' + rowNum1).val(getResult.FailureList[i].FailureType);
                        $('#txtFailureRootCauseCode' + rowNum1).val(getResult.FailureList[i].FailureRootCauseCode);
                        $('#txtDetails' + rowNum1).val(getResult.FailureList[i].Details);
                        $('#ddlStatus' + rowNum1).val(getResult.FailureList[i].Status);

                        rowNum1 += 1;
                    }
                }
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


