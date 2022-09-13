var rowNum = 1;

$(document).ready(function () {

    $.get("/api/WasteType/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#ddlWasteCategory").append("<option value='' Selected>" + "Select" + "</option>");
            $("#ddlWasteType").append("<option value='' Selected>" + "Select" + "</option>");
            for (var i = 0; i < loadResult.WasteCategoryLovs.length; i++) {
                $("#ddlWasteCategory").append(
                    "<option value=" + loadResult.WasteCategoryLovs[i].LovId + ">" + loadResult.WasteCategoryLovs[i].FieldValue + "</option>"
                );
            } 
            for (var i = 0; i < loadResult.WasteTypeLovs.length; i++) {
                $("#ddlWasteType").append(
                    "<option value=" + loadResult.WasteTypeLovs[i].LovId + ">" + loadResult.WasteTypeLovs[i].FieldValue + "</option>"
                );
            }
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
        var WasteCategory = $("#ddlWasteCategory").val();
        var Wastetype = $("#ddlWasteType").val();
        
        var isFormValid = formInputValidation("formWasteType", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }

        var arr = [];
        var isDuplicateWasteCode = 0;
        $("[id^=txtWasteCode]").each(function () {
            var value = $(this).val();
            if (arr.indexOf(value) == -1)
                arr.push(value);
            else {
                isDuplicateWasteCode += 1;
            }                
        });

        if (isDuplicateWasteCode > 0) {
            $("div.errormsgcenter").text('Duplicate Waste Codes');
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }
        var primaryId = 0;
        if ($("#primaryID").val() != null) {
            primaryId = $("#primaryID").val();
        }

        var obj = {
            WasteTypeId: primaryId,
            CustomerId: CustomerId,
            FacilityId: FacilityId,
            WasteCategory: WasteCategory,
            WasteOfType: Wastetype,          
            WasteTypeDetailsList: []
        }

        $("#tbodyWasteCode tr").each(function () {
            var tbl = {};
            tbl.WasteId = $(this).find("[id^=hdnWasteCodeId]")[0].value; 
            tbl.WasteCode = $(this).find("[id^=txtWasteCode]")[0].value;
            tbl.WasteDescription = $(this).find("[id^=txtWasteDescription]")[0].value;
            tbl.isDeleted = $(this).find('input:checkbox[id^=isDelete]').prop("checked");
            obj.WasteTypeDetailsList.push(tbl);
        });
             
         $.post("/api/WasteType/Save", obj, function (response) {

             var result = JSON.parse(response);
             showMessage('WasteType', CURD_MESSAGE_STATUS.SS);
                         
             $("#primaryID").val(result.WasteTypeId);

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

    //****************************************** Mutliple rows delete button code******************************************
    $("#deleteWasteCode").click(function () {
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
                        $("#tbodyWasteCode tr").find('input[name="isDelete"]').each(function () {
                            if ($(this).is(":checked")) {
                                if ($(this).closest("tr").find("[id^=hdnWasteCodeId]").val() == 0) {
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
        
    //*****************Reset Fields and Delete Rows*****************//

    $(body).on('input propertychange', '.form-control', function (event) {
        $(this).parent().removeClass('has-error');
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
    $("#addWasteCode").click(function () {
        rowNum += 1; 
        addWasteCode(rowNum);     
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
    $("#formWasteType :input:not(:button)").parent().removeClass('has-error');
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
        $("#formWasteType :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/WasteType/Get/" + primaryId)
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
});

function fillDetails(result) {

    if (result != undefined) {

        $('#primaryID').val(result.WasteTypeId);
        $('#ddlWasteCategory').val(result.WasteCategory);
        $('#ddlWasteType').val(result.WasteOfType);    
        $("#tbodyWasteCode").html('');

        rowNum = 1;
        if (result.WasteTypeDetailsList != null || result.WasteTypeDetailsList != undefined) {
            for (var i = 0; i < result.WasteTypeDetailsList.length; i++) {
                addWasteCode(rowNum);
                $('#hdnWasteCodeId' + rowNum).val(result.WasteTypeDetailsList[i].WasteId);
                $('#txtWasteCode' + rowNum).val(result.WasteTypeDetailsList[i].WasteCode);
                $('#txtWasteDescription' + rowNum).val(result.WasteTypeDetailsList[i].WasteDescription);
                rowNum += 1;
            }
        }
        else {
            addWasteCode(rowNum);
        }
    }
}
function addWasteCode(num) {
        
    var CheckBox = '<td style="text-align:center"> <input type="checkbox" id="isDelete' + num + '" name="isDelete"   ><input type="hidden" id="hdnWasteCodeId' + num + '" value="0" /></td>';
    var WasteCode = '<td id="code"> <input type="text" required class="form-control" id="txtWasteCode' + num + '" autocomplete="off" name="Waste Code" maxlength="25"  /></td>';
    var WasteDescription = '<td id="description"> <input type="text" required class="form-control" id="txtWasteDescription' + num + '" autocomplete="off" name="Waste Description" maxlength="25"  /></td>';

    $("#WasteTypeTable tbody").append('<tr class="table_row">' + CheckBox + WasteCode + WasteDescription + '</tr>');

}
function EmptyFields() {

    $("#primaryID").val('0');
    $('[id^=hdnWasteCodeId]').val(0);

    $('#formWasteType')[0].reset(); 
    $('#formWasteType #Category').removeClass('has-error');
    $('#formWasteType #Wastetype').removeClass('has-error');
    $('#formWasteType #Code').removeClass('has-error');
    $('#formWasteType #description').removeClass('has-error');   
    $('#errorMsg').css('visibility', 'hidden');

    var i = 1;
    $("#tbodyWasteCode").find('tr').each(function () {
        if (i > 1) {
            $(this).remove();
        }
        i += 1;
    });

}


