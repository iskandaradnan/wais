var issue = "";
var rowNum = 1;
var FileTypeValues = "";
var filePrefix = "LT_";
var ScreenName = "LicenseType";
var rowNum2 = 1;

$(document).ready(function () {
    
    $.get("/api/HWMSLicenseType/Load")
        .done(function (result) {

            var loadResult = JSON.parse(result);
            $("#ddlLicenseType").append("<option value='' Selected>" + "Select" + "</option>");
            $("#ddlIssuingBody1").append("<option value='' Selected>" + "Select" + "</option>");
            $("#ddlWasteType").append("<option value='' Selected>" + "Select" + "</option>");
            $("#ddlWasteCategory").append("<option value='' Selected>" + "Select" + "</option>");

            for (var i = 0; i < loadResult.LicenseTypeeLovs.length; i++) {

                $("#ddlLicenseType").append(
                    "<option value=" + loadResult.LicenseTypeeLovs[i].LovId + ">" + loadResult.LicenseTypeeLovs[i].FieldValue + "</option>"
                );
            }
            for (var i = 0; i < loadResult.IssuingBodyLovs.length; i++) {

                issue += "<option value=" + loadResult.IssuingBodyLovs[i].LovId + ">" + loadResult.IssuingBodyLovs[i].FieldValue + "</option>"
            }

            for (var i = 0; i < loadResult.WasteTypeLovs.length; i++) {
                $("#ddlWasteType").append(
                    "<option value=" + loadResult.WasteTypeLovs[i].LovId + ">" + loadResult.WasteTypeLovs[i].FieldValue + "</option>"
                );
            }
            for (var i = 0; i < loadResult.WasteCategoryLovs.length; i++) {
                $("#ddlWasteCategory").append(
                    "<option value=" + loadResult.WasteCategoryLovs[i].LovId + ">" + loadResult.WasteCategoryLovs[i].FieldValue + "</option>"
                );
            }
            $("#ddlIssuingBody1").append(issue);
            $('#myPleaseWait').modal('hide');

            FileTypeValues = "<option value='' Selected>" + "Select" + "</option>";
            FileTypeValues += "<option value='1'>" + "License Type" + "</option>";
            $("#ddlFileType1").append(FileTypeValues);
        })
        .fail(function (response) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            $('#errorMsgConfigAdditionalFields').css('visibility', 'visible');
        });

    $("#btnSave, #btnSaveAddNew").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');

        var CustomerId = $('#selCustomerLayout').val();
        var FacilityId = $('#selFacilityLayout').val();
        var Licensetype = $('#ddlLicenseType').val();
        var WasteCategory = $('#ddlWasteCategory').val();
        var WasteType = $('#ddlWasteType').val();
   
        var isFormValid = formInputValidation("formLicenseType", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }

        var arr = [];
        var isDuplicates = 0;
        $("[id^=txtLicenseCode]").each(function () {
            var value = $(this).val();
            if (arr.indexOf(value) == -1)
                arr.push(value);
            else {
                isDuplicates += 1;
            }
        });

        if (isDuplicates > 0) {
            $("div.errormsgcenter").text('Duplicate License  Codes');
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }

        var primaryId = 0;
        if ($("#primaryID").val() != null) {
            primaryId = $("#primaryID").val();
        }
        var obj = {
            LicenseTypeId: primaryId,                    
            CustomerId: CustomerId,
            FacilityId: FacilityId,
            LicenseOfType: Licensetype,
            WasteCategory: WasteCategory,
            WasteType: WasteType,          
            licenseCodeList: []
        };       
        $("#LicenseTable tbody tr").each(function () {
            var tbl = {};            
            tbl.LicenseId = $(this).find("[id^=hdnLicenseId]")[0].value; 
            tbl.LicenseCode = $(this).find("[id^=txtLicenseCode]")[0].value;
            tbl.LicenseDescription = $(this).find("[id^=txtLicenseDescription]")[0].value;
            tbl.IssuingBody = $(this).find("[id^=ddlIssuingBody]")[0].value;            
            tbl.isDeleted = $(this).find('input:checkbox[id^=isDelete]').prop("checked");
            obj.licenseCodeList.push(tbl);
        });
             
        $.post("/api/HWMSLicenseType/Save", obj, function (response) {

            var result = JSON.parse(response);
            showMessage('LicenseType', CURD_MESSAGE_STATUS.SS);
            $("#primaryID").val(result.LicenseTypeId); 

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
   
    $(body).on('input propertychange', '.form-control', function (event) {
        $(this).parent().removeClass('has-error');
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

    //****************************************Mutliple rows delete button code*****************************************//  

    $("#deleteLicenseCode").click(function () {
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
                        $("#tbodyLicenseCode tr").find('input[name="isDelete"]').each(function () {
                            if ($(this).is(":checked")) {
                                if ($(this).closest("tr").find("[id^=hdnLicenseId]").val() == 0) {
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

    //Add Rows Code.... 
    $("#addRowLicenseCode").click(function () {

        rowNum += 1;
        addRowLicenseCode(rowNum);

           
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
    $("#formLicenseType :input:not(:button)").parent().removeClass('has-error');
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
        $.get("/api/HWMSLicenseType/Get/" + primaryId)
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

function fillDetails(result)
{
    if (result != undefined) {

        $('#ddlLicenseType').val(result.LicenseOfType);
        $('#ddlWasteCategory').val(result.WasteCategory);
        $('#ddlWasteType').val(result.WasteType);

        $("#tbodyLicenseCode").html('');
        rowNum = 1;

        if (result.licenseCodeList != null) {
            for (var i = 0; i < result.licenseCodeList.length; i++) {

                addRowLicenseCode(rowNum);

                $('#hdnLicenseId' + rowNum).val(result.licenseCodeList[i].LicenseId);
                $('#txtLicenseCode' + rowNum).val(result.licenseCodeList[i].LicenseCode);
                $('#txtLicenseDescription' + rowNum).val(result.licenseCodeList[i].LicenseDescription);
                $('#ddlIssuingBody' + rowNum).val(result.licenseCodeList[i].IssuingBody);

                rowNum += 1;
            }
        }
        else {
            addRowLicenseCode(rowNum);
        }

        fillAttachment(result.AttachmentList);
        
    }   
}

function addRowLicenseCode(num) {

    var CheckBox = '<td style="text-align:center"> <input type="checkbox" name="isDelete" id="isDelete' + num + '" ><input type="hidden" id="hdnLicenseId' + num + '" value="0" /></td>';
    var LicenseCode = '<td id="Code"> <input type="text" required class="form-control" id="txtLicenseCode' + num + '" autocomplete="off" name="LicenseCode" maxlength="25"  /></td>';
    var LicenseDescription = '<td id="Description"> <input type="text" required  class="form-control" id="txtLicenseDescription' + num + '" autocomplete="off" name="LicenseDescription" maxlength="25"  /></td>';
    var IssuingBody = '<td id="body"><select type="text" required class="form-control" id="ddlIssuingBody' + num + '" autocomplete="off" name="IssuingBody" maxlength="25"  ><option value="">Select </option>' + issue + '</td>';

    $("#tbodyLicenseCode").append('<tr class="tablerow">' + CheckBox + LicenseCode + LicenseDescription + IssuingBody + '</tr>');
   
}


//*****************Reset Fields and Delete Rows*****************//
function EmptyFields() {

    $("#primaryID").val(0);
    $('[id^=hdnLicenseId]').val(0);

    $('#formLicenseType')[0].reset();    
    $('#formLicenseType #License').removeClass('has-error');
    $('#formLicenseType #Category').removeClass('has-error');
    $('#formLicenseType #WasteType').removeClass('has-error');
    $('#formLicenseType #Code').removeClass('has-error');
    $('#formLicenseType #Description').removeClass('has-error');
    $('#formLicenseType #body').removeClass('has-error');    
    $('#errorMsg').css('visibility', 'hidden');

    var i = 1;
    $("#tbodyLicenseCode").find('tr').each(function () {
        if (i > 1) {
            $(this).remove();
        }
        i += 1;
    });
}

