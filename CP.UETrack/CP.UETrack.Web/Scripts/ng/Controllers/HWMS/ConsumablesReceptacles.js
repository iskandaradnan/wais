var Itemdropdown = "";
var UOMValues = "";
var rowNum = 1;

$(document).ready(function () {
    //**************************************Changing Dropdown Values**************************************************//    
    $.get("/api/ConsumablesReceptacles/Load")
        .done(function (result) {

            var loadResult = JSON.parse(result);
            Itemdropdown = "<option value=''>" + "Select" + "</option>";
            UOMValues = "<option value=''>" + "Select" + "</option>";
            $("#ddlWasteType").append("<option value='' Selected>" + "Select" + "</option>");
            $("#ddlWasteCategory").append("<option value='' Selected>" + "Select" + "</option>");

            for (var i = 0; i < loadResult.ItemTypeConsumables.length; i++) {
                Itemdropdown += "<option value=" + loadResult.ItemTypeConsumables[i].LovId + ">" + loadResult.ItemTypeConsumables[i].FieldValue + "</option>";
            }
            for (var i = 0; i < loadResult.WasteTypeConsumables.length; i++) {
                $("#ddlWasteType").append(
                    "<option value=" + loadResult.WasteTypeConsumables[i].LovId + ">" + loadResult.WasteTypeConsumables[i].FieldValue + "</option>"
                );
            }
            for (var i = 0; i < loadResult.WasteCategoryLovs.length; i++) {
                $("#ddlWasteCategory").append(
                    "<option value=" + loadResult.WasteCategoryLovs[i].LovId + ">" + loadResult.WasteCategoryLovs[i].FieldValue + "</option>"
                );
            }

            $("#ddlItemType1").append(Itemdropdown);

            for (var i = 0; i < loadResult.UOMLovs.length; i++) {             
                UOMValues += "<option value=" + loadResult.UOMLovs[i].LovId + ">" + loadResult.UOMLovs[i].FieldValue + "</option>"               
            }

            $("#ddlUOM1").append(UOMValues);

            $('#myPleaseWait').modal('hide');
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });

    //*****************************************Save Functionality*******************************************//

    $("#btnSave, #btnSaveAddNew").click(function () {
        
        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');

        var isFormValid = formInputValidation("formConsumablesRece", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }

        var arr = [];
        var isDuplicateItmeCode = 0;
        $("[id^=txtItemCode]").each(function () {
            var value = $(this).val();
            if (arr.indexOf(value) == -1)
                arr.push(value);
            else {
                isDuplicateItmeCode += 1;
            }
        });

        if (isDuplicateItmeCode > 0) {
            $("div.errormsgcenter").text('Duplicate Item Codes');
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }

        var primaryId = 0;
        if ($("#primaryID").val() != null) {
            primaryId = $("#primaryID").val();
        }        

        var obj = {
            ConsumablesId: primaryId,
            CustomerId: $('#selCustomerLayout').val(),
            FacilityId: $('#selFacilityLayout').val(),
            WasteCategory: $("#ddlWasteCategory").val(),
            WasteType: $("#ddlWasteType").val(),          
            ItemList: []
        };
        $("#tbodyItems tr").each(function () {
            var tbl = {};          
            tbl.ItemCodeId = $(this).find("[id^=hdnItemCodeId]")[0].value;
            tbl.ItemCode = $(this).find("[id^=txtItemCode]")[0].value;
            tbl.ItemName = $(this).find("[id^=txtItemName]")[0].value;
            tbl.ItemType = $(this).find("[id^=ddlItemType]")[0].value;
            tbl.Size = $(this).find("[id^=txtSize]")[0].value;
            tbl.UOM = $(this).find("[id^=ddlUOM]")[0].value;
            tbl.isDeleted = $(this).find('input:checkbox[id^=isDelete]').prop("checked");

            obj.ItemList.push(tbl);
        });
       
        $.post("/Api/ConsumablesReceptacles/Save", obj, function (response) {
            showMessage('Consumables & Receptacles', CURD_MESSAGE_STATUS.SS);

            var result = JSON.parse(response);                       
            $("#grid").trigger('reloadGrid'); 
            $("#primaryID").val(result.ConsumablesId);
                   
            if (CurrentbtnID == "btnSaveAddNew") {
                EmptyFields();
                $('#Insert').hide();
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

    //***************************************Button Cancel*******************************************//
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

    //********************************Reset Fields and Delete Rows*************************************//

    $(body).on('input propertychange', '.form-control', function (event) {
        $(this).parent().removeClass('has-error');
    });
    
    $("#addItems").click(function () {
        rowNum += 1;
        addItems(rowNum);
    });

    //****************************************Mutliple rows delete button code*****************************************//  
   
    $("#deleteItems").click(function () {
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
                        $("#tbodyItems tr").find('input[name="isDelete"]').each(function () {
                            if ($(this).is(":checked")) {
                                if ($(this).closest("tr").find("[id^=hdnItemCodeId]").val() == 0) {
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
    $("#formConsumablesRece :input:not(:button)").parent().removeClass('has-error');
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
        $("#formConsumablesRece :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();     
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/ConsumablesReceptacles/Get/" + primaryId)
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

        $('#primaryID').val(result.ConsumablesId);
        $('#ddlWasteCategory').val(result.WasteCategory);
        $('#ddlWasteType').val(result.WasteType);
        $("#tbodyItems").html('');
        rowNum = 1;
        if (result.ItemList != null) {
            for (var i = 0; i < result.ItemList.length; i++) {

                addItems(rowNum);

                $('#hdnItemCodeId' + rowNum).val(result.ItemList[i].ItemCodeId);
                $('#txtItemCode' + rowNum).val(result.ItemList[i].ItemCode);
                $('#txtItemName' + rowNum).val(result.ItemList[i].ItemName);
                $('#ddlItemType' + rowNum).val(result.ItemList[i].ItemType);
                $('#txtSize' + rowNum).val(result.ItemList[i].Size);
                $('#ddlUOM' + rowNum).val(result.ItemList[i].UOM);

                rowNum += 1;
            }
        }
    }

}

function addItems(num)
{
    var CheckBox = '<td style="text-align:center"><input type="checkbox" name="isDelete"  id="isDelete' + num + '" /><input type="hidden" value="0" id="hdnItemCodeId' + num + '" /></td>';
    var ItemCode = '<td id="ItemCode"> <input type="text" required class="form-control" id="txtItemCode' + num + '" autocomplete="off" name="ItemCode" maxlength="25"  /></td>';
    var ItemName = '<td id="ItemName"> <input type="text" required class="form-control" id="txtItemName' + num + '" autocomplete="off" name="ItemName" maxlength="25"  /></td>';
    var itemtype = '<td id="ItemType"><select type="text" required class="form-control" id="ddlItemType' + num + '" autocomplete="off" name="Status" maxlength="25" >' + Itemdropdown + '</td>';
    var Size = '<td id="Size"> <input type="text" required class="form-control" id="txtSize' + num + '" autocomplete="off" name="Size" maxlength="25"  /></td>';

    var UOM = '<td id="UOM">  <select required class="form-control" id="ddlUOM' + num + '">' + UOMValues + '</select></td>';

    $("#tbodyItems").append('<tr class="table_row">' + CheckBox + ItemCode + ItemName + itemtype + Size + UOM + '</tr>');
}

function EmptyFields() {

    $('#primaryID').val(0);
    $('[id^=hdnItemCodeId]').val(0);

    $('#formConsumablesRece')[0].reset();    
    $('#errorMsg').css('visibility', 'hidden');
    $('#formConsumablesRece #WasteCode').removeClass('has-error');
    $('#formConsumablesRece #WasteType').removeClass('has-error');
    $('#formConsumablesRece #ItemCode').removeClass('has-error');
    $('#formConsumablesRece #ItemName').removeClass('has-error');
    $('#formConsumablesRece #ItemType').removeClass('has-error');
    $('#formConsumablesRece #Size').removeClass('has-error');
    $('#formConsumablesRece #UOM').removeClass('has-error');

    var i = 1;
    $("#tbodyItems").find('tr').each(function () {
        if (i > 1) {
            $(this).remove();
        }
        i += 1;
    });

    

}  

