window.UOMGloabal = [];
$(document).ready(function () {
    window.CategoryListGloabal = [];
    $('#myPleaseWait').modal('show');
    formInputValidation("ppmchecklistFormId");
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $('#spnPopup-Model').hide();
    $('#txtModel').attr('disabled', true);
    $.get("/api/PPMChecklist/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#jQGridCollapse1").click();
            $.each(loadResult.FrequencyList, function (index, value) {
                $('#PPMFrequency').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.Services, function (index, value) {
                $('#selServices').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            window.CategoryListGloabal = loadResult.PpmCategoryList;
            window.UOMGloabal = loadResult.UOMList;
            AddFirstGridRow();
            AddSecondGridRow();
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });

    function DisplayError() {
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        $('#btnSave').attr('disabled', false);
    }


    function validateQuantityList(list) {
        var count = 0;
        if (list != null && list.length > 0) {
            $.each(list, function (ind, data) {

                if (parseFloat(data.UOM) <= 0) {
                    $('#UOM_' + ind).parent().addClass('has-error');
                    count++;
                }
            });
        }

        return count > 0 ? false : true;
    }

    $("#btnSave,#btnEdit,#btnSaveandAddNew").click(function () {
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var CurrentbtnID = $(this).attr("Id");

        //first grid 

        var _index;        // var _indexThird;
        var result = [];
        $('#FirstGridId tr').each(function () {
            _index = $(this).index();
        });

        for (var i = 0; i <= _index; i++) {
            var active = true;
            var isDeletedcat = $('#IsDeletedCategory_' + i).prop('checked');
            var pPmCategoryDetId = $('#PPmCategoryDetId_' + i).val();

            //  if (!isDeleted && pPmCategoryDetId != "0")
            //  {

            var _tempObj = {
                PPmCategoryDetId: $('#PPmCategoryDetId_' + i).val(),
                PpmCategoryId: $('#PpmCategoryId_' + i).val(),
                SNo: $('#SNo_' + i).val(),
                Description: $('#Description_' + i).val(),
                Active: isDeletedcat ? false : true,
            }
            result.push(_tempObj);
            // }          
        }


        var _index1;        // var _indexThird;
        var result1 = [];
        $('#SecondGridId tr').each(function () {
            _index1 = $(this).index();
        });
        for (var i = 0; i <= _index1; i++) {
            var active = true;
            var isDeleted = $('#IsDeleted_' + i).prop('checked');
            var PPMCheckListQNId = $('#PPMCheckListQNId_' + i).val();
            //  if (!isDeleted && PPMCheckListQNId != "0") {
            var _tempObj1 = {
                PPMCheckListQNId: PPMCheckListQNId,
                PPMCheckListId: $("#primaryID").val(),
                QuantitativeTasks: $('#QuantitativeTasks_' + i).val(),
                UOM: $('#UOM_' + i).val(),
                SetValues: $('#SetValues_' + i).val(),
                LimitTolerance: $('#LimitTolerance_' + i).val(),
                Active: isDeleted ? false : true,
            }
            result1.push(_tempObj1);
        }


        var deleteCount = 0;
        if (result != null && result != '') {

            deleteCount = Enumerable.From(result).Where(function (x) { return x.Active == false }).Count();
        }

        var deleteQNCount = 0;
        if (result1 != null && result1 != '') {

            deleteQNCount = Enumerable.From(result1).Where(function (x) { return x.Active == false }).Count();
        }
        if (deleteCount > 0 || deleteQNCount > 0) {
            var message = "Record(s) selected for deletion. Do you want to proceed?";
            bootbox.confirm(message, function (result) {
                if (result) {

                    SubmitData(CurrentbtnID);

                }
                else {
                    bootbox.hideAll();
                    return false;
                }

            });
        }
        else {

            SubmitData(CurrentbtnID);
        }


    });


    function SubmitData(CurrentbtnID) {
       
        $('#myPleaseWait').modal('show');

        //$("div.errormsgcenter").text("");
        //$('#errorMsg').css('visibility', 'hidden');
        var primaryId = $("#primaryID").val();
        var AssetTypeCodeId = $('#hdnAssetTypeCodeId').val();
        var ServiceId = $('#selServices').val();
        var ManufacturerId = $('#hdnManufacturerId').val();
        var ModelId = $('#hdnModelId').val();
        var Timestamp = $('#Timestamp').val();


        //first grid 

        var _index;        // var _indexThird;
        var result = [];
        $('#FirstGridId tr').each(function () {
            _index = $(this).index();
        });

        for (var i = 0; i <= _index; i++) {
            var active = true;
            var isDeletedcat = $('#IsDeletedCategory_' + i).prop('checked');
            var pPmCategoryDetId = $('#PPmCategoryDetId_' + i).val();

            //  if (!isDeleted && pPmCategoryDetId != "0")
            //  {

            var _tempObj = {
                PPmCategoryDetId: $('#PPmCategoryDetId_' + i).val(),
                PpmCategoryId: $('#PpmCategoryId_' + i).val(),
                SNo: $('#SNo_' + i).val(),
                Description: $('#Description_' + i).val(),
                Active: isDeletedcat ? false : true,
            }
            result.push(_tempObj);
            // }          
        }
        var Categorycount = 0;
        //if (result != null && result != '') {
        //    Categorycount = Enumerable.From(result).Where(function (x) { return x.Active == true && x.PpmCategoryId != 0 && x.PpmCategoryId != "null" && x.Description != null && x.Description != '' }).Count();
        //}

        var _index1;        // var _indexThird;
        var result1 = [];
        $('#SecondGridId tr').each(function () {
            _index1 = $(this).index();
        });
        for (var i = 0; i <= _index1; i++) {
            var active = true;
            var isDeleted = $('#IsDeleted_' + i).prop('checked');
            var PPMCheckListQNId = $('#PPMCheckListQNId_' + i).val();
            //  if (!isDeleted && PPMCheckListQNId != "0") {
            var _tempObj1 = {
                PPMCheckListQNId: PPMCheckListQNId,
                PPMCheckListId: $("#primaryID").val(),
                QuantitativeTasks: $('#QuantitativeTasks_' + i).val(),
                UOM: $('#UOM_' + i).val(),
                SetValues: $('#SetValues_' + i).val(),
                LimitTolerance: $('#LimitTolerance_' + i).val(),
                Active: isDeleted ? false : true,
            }
            result1.push(_tempObj1);
        }
        var QuantityCount = 0;
        //if (result1 != null && result1 != '') {
        //    QuantityCount = Enumerable.From(result1).Where(function (x) {
        //        return x.Active == true && x.UOM != 0 && x.UOM != "null"
        //            && x.QuantitativeTasks != null && x.QuantitativeTasks != ''
        //           && x.SetValues != null && x.SetValues != ''
        //        && x.LimitTolerance != null && x.LimitTolerance != ''
        //    }).Count();
        //}

        var isFormValid = formInputValidation("ppmchecklistFormId", "ppmFormId", 'save');
        if (!isFormValid || result1 == '' || result == '' || result1 == null || result == null) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            DisplayError();
            return false;
        }
        //else if (QuantityCount == 0|| Categorycount = 0) {
        //    $("div.errormsgcenter").text("Grid should contain atleast one record");
        //    DisplayError();
        //    return false;

        //}
        else if (AssetTypeCodeId == 0 || AssetTypeCodeId == "0") {
            $('#txtAssetTypeCode').parent().addClass('has-error');
            $("div.errormsgcenter").text('Valid Asset Type Code is required');
            DisplayError();
            return false;
        }
        else if (ModelId == 0 || ModelId == "0") {
            $('#txtModel').parent().addClass('has-error');
            $("div.errormsgcenter").text('Valid Model is required');
            DisplayError();
            return false;
        }
        else if (ManufacturerId == 0 || ManufacturerId == "0") {
            $('#txtManufacturer').parent().addClass('has-error');
            $("div.errormsgcenter").text('Valid Manufacturer is required');
            DisplayError();
            return false;
        }
        //else if (!validateQuantityList(result1)) {
        //    $("div.errormsgcenter").text('Units / UOM cannot be 0');
        //    DisplayError();
        //    return false;
        //}


        var obj = {
            PPMCheckListId: primaryId,
            AssetTypeCodeId: $('#hdnAssetTypeCodeId').val(),
            Taskcode: $('#Taskcode').val(),
            TaskCodeDesc: $('#TaskCodeDesc').val(),
            ManufacturerId: ManufacturerId,
            ModelId: ModelId,
            ServiceId: $('#selServices').val(),
            PPMFrequency: $('#PPMFrequency').val(),
            PpmHours: $('#PPMhours').val(),
            SpecialPrecautions: $('#SpecialPrecautions').val(),
            Remarks: $('#Remarks').val(),
            PPMCheckListQuantasksMstDets: result1,
            PPmChecklistCategoryDets: result,
            Timestamp: (primaryId != 0 || primaryId != null) ? primaryId : 0,
        };
        var jqxhr = $.post("/api/PPMChecklist/Add", obj, function (response) {
            var res = JSON.parse(response);
            $("#grid").trigger('reloadGrid');
            if (response.PPMCheckListId != 0) {
                $('#btnEdit').show();
                $('#btnSave').hide();
                $('#btnDelete').show();
            }
            $('#FirstGridId').empty();
            $('#SecondGridId').empty();
            BindHeaderData(res);
            $('#hdnAttachId').val(res.HiddenId);
            if (res.PPmChecklistCategoryDets != null && res.PPmChecklistCategoryDets.length > 0)
                BindCategoryGrid(res.PPmChecklistCategoryDets);

            if (res.PPMCheckListQuantasksMstDets != null && res.PPMCheckListQuantasksMstDets.length > 0)
                BindQuantityGrid(res.PPMCheckListQuantasksMstDets);
            $(".content").scrollTop(0);
            showMessage('PPM Checklist', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            if (CurrentbtnID == "btnSaveandAddNew") {
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
                    errorMessage = Messages.COMMON_FAILURE_MESSAGE;
                }
                $("div.errormsgcenter").text(errorMessage);
                $('#errorMsg').css('visibility', 'visible');
                $('#btnSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            });

    }

    $('#btnAddNew').click(function () {
        window.location.reload();
    });

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


    //----------------------------------------


    
    $('#selServices').change(function () {
       
        var serviceid = $('#selServices').val();
       
        var obj = {
            id: serviceid,
        };

        $.ajax({
            url: '@Url.Action("AddToCart", "PPMChecklist")',
            type: 'GET',
            dataType: 'json',
            cache: false,
            data: { 'id': id },
            success: function (results) {
                alert(results)
            },
            error: function () {
                alert('Error occured');
            }
        });





        $.get("/api/PPMChecklist/SetDB/" + serviceid)
            .done(function (result) {
                alert('H');
            })
            .fail(function () {
                alert('FAIL');
            });
        
    }); 
    $('#hdnAssetTypeCodeId').change(function () {
        $('#txtModel').val("");
        $('#hdnModelId').val("");
        $('#hdnManufacturerId').val("");
        $('#txtManufacturer').val("");

        var hdnValue = $('#hdnAssetTypeCodeId').val();
        if (hdnValue != null && hdnValue != '') {
            $('#txtModel').attr('disabled', false);
            $('#spnPopup-Model').show();
        }
        else {
            $('#txtModel').attr('disabled', true);
            $('#spnPopup-Model').hide();
        }

    });
    //------------------------Fetch & Search -----------------------------
    var typeCodeFetchObj = {
        SearchColumn: 'txtAssetTypeCode-AssetTypeCode',//Id of Fetch field
        ResultColumns: ["AssetTypeCodeId-Primary Key", 'AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description'],//Columns to be displayed
        FieldsToBeFilled: ["hdnAssetTypeCodeId-AssetTypeCodeId", "txtAssetTypeCode-AssetTypeCode", "txtAssetTypeDescription-AssetTypeDescription"],//id of element - the model property
    };

    $('#txtAssetTypeCode').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch1', typeCodeFetchObj, "/api/Fetch/TypeCodeFetch", "UlFetch1", event, 1);//1 -- pageIndex
    });
    var typeCodeSearchObj = {
        Heading: "Type Code Details",//Heading of the popup
        SearchColumns: ['AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description'],//ModelProperty - Space seperated label value
        ResultColumns: ["AssetTypeCodeId-Primary Key", 'AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description'],//Columns to be returned for display
        FieldsToBeFilled: ["hdnAssetTypeCodeId-AssetTypeCodeId", "txtAssetTypeCode-AssetTypeCode", "txtAssetTypeDescription-AssetTypeDescription"], //id of element - the model property
    };
    $('#spnPopup-TypeCode').click(function () {


        //  alert($('#hdnAssetTypeCodeId').val());
        // $('#hdnAssetTypeCodeId').val('');
        DisplaySeachPopup('divSearchPopup', typeCodeSearchObj, "/api/Search/TypeCodeSearch");
    });



    //Fetch and search - Model
    var modelSearchObj = {
        Heading: "Model",
        SearchColumns: ['Model-Model'],
        ResultColumns: ["ModelId-Primary Key", 'Model-Model', 'Manufacturer-Manufacturer'],
        FieldsToBeFilled: ["hdnModelId-ModelId", "txtModel-Model", "hdnManufacturerId-ManufacturerId", "txtManufacturer-Manufacturer"],
        //  AdditionalConditions: ["TypeCodeId-hdnAssetTypeCodeId", "ScreenName-hdnScreenName"],
        AdditionalConditions: ["TypeCodeId-hdnAssetTypeCodeId"],
    };

    $('#spnPopup-Model').click(function () {
        DisplaySeachPopup('divSearchPopup', modelSearchObj, "/api/Search/ModelSearch");
    });

    $('#hdnModelId').change(function () {
        //  $('#txtModel').val("");
        $('#hdnManufacturerId').val("");
        $('#txtManufacturer').val("");

    });
    var modelObj = {
        SearchColumn: 'txtModel-Model',//Id of Fetch field
        ResultColumns: ["ModelId-Primary Key", 'Model-Model'],//Columns to be displayed
        FieldsToBeFilled: ["hdnModelId-ModelId", "txtModel-Model", "hdnManufacturerId-ManufacturerId", "txtManufacturer-Manufacturer"],//id of element - the model property
        // AdditionalConditions: ["TypeCodeId-hdnAssetTypeCodeId", "ScreenName-hdnScreenName"],
        AdditionalConditions: ["TypeCodeId-hdnAssetTypeCodeId"],
    };

    $('#txtModel').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch3', modelObj, "/api/Fetch/ModelFetch", "UlFetch3", event, 1);//1 -- pageIndex
    });

    //------------------------Fetch & Search -----------------------------------------------------------------------
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
});
//Checklist grid 
function Fetchdata(event, index) {
    var CheckList = {
        SearchColumn: 'name_' + index + '-Name',//Id of Fetch field
        ResultColumns: ["ChecklistItemId" + "-Primary Key", 'Name' + '-name_' + index],//Columns to be displayed
        FieldsToBeFilled: ["ChecklistItemId_" + index + "-ChecklistItemId", 'name_' + index + '-Name']//id of element - the model property
    };
    DisplayFetchResult('divFetch_' + index, CheckList, "/api/Fetch/FetchCheckListItemDetails", "Ulfetch" + index, event, 1);
    //$('#SaprePartType_0').val(37);
}
function LinkClicked(id) {
    linkCliked1 = true;
    linkCliked2 = true;
    $(".content").scrollTop(1);
    $("#ppmchecklistFormId :input:not(:button)").parent().removeClass('has-error');

    $('.nav-tabs a:first').tab('show');
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
        $("#ppmchecklistFormId :input:not(:button)").prop("disabled", true);
    }
    else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/PPMChecklist/Get/" + primaryId)
            .done(function (result) {
                var res = JSON.parse(result);
                var htmlval = "";
                $('#FirstGridId').empty();
                $('#SecondGridId').empty();
                var res = JSON.parse(result);
                BindHeaderData(res);
                $('#hdnAttachId').val(res.HiddenId);
                if (res.PPmChecklistCategoryDets != null && res.PPmChecklistCategoryDets.length > 0)
                    BindCategoryGrid(res.PPmChecklistCategoryDets);

                if (res.PPMCheckListQuantasksMstDets != null && res.PPMCheckListQuantasksMstDets.length > 0)
                    BindQuantityGrid(res.PPMCheckListQuantasksMstDets);
                $('#myPleaseWait').modal('hide');
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

$("#btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/PPMChecklist/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('PPM Checklist', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('PPM Checklist', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}
function EmptyFields() {
    $(".content").scrollTop(0);
    $('#chkCategory1DeleteAll').prop('checked', false);
    $('#chkQuantityDeleteAll').prop('checked', false);
    $('input[type="text"], textarea').val('');
    $('#PPMFrequency').val("null");
    $('#txtAssetTypeCode,#PPMFrequency').attr('disabled', false);
    $('#txtModel').attr('disabled', true);
    $('#FirstGridId').empty();
    $('#SecondGridId').empty();
    AddFirstGridRow();
    AddSecondGridRow();
    $('#AssetNoDiv').show();
    $('#popModelId').show();
    $('#hdnAttachId').val('');
    $('#selServices').val('');
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#grid").trigger('reloadGrid');
    $("#ppmchecklistFormId :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('.nav-tabs a:first').tab('show');
    $('#txtAssetTypeDescription').val('');
}

window.BindHeaderData = function (res) {
    $('#chkCategory1DeleteAll').prop('checked', false);
    $('#chkQuantityDeleteAll').prop('checked', false);
    $('#txtAssetTypeCode,#txtModel,#PPMFrequency').attr('disabled', true);
    $('#AssetNoDiv,#spnPopup-Model').hide();
    $('#popModelId').hide();
    $('#selServices').val(res.ServiceId);
    $('#hdnAssetTypeCodeId').val(res.AssetTypeCodeId);
    $('#txtAssetTypeCode').val(res.AssetTypeCode);
    $('#txtAssetTypeDescription').val(res.AssetTypeDescription);
    $('#Taskcode').val(res.TaskCode);
    $('#TaskCodeDesc').val(res.TaskCodeDesc);
    $('#PPMFrequency').val(res.PPMFrequency);
    $('#PPMhours').val(res.PpmHours);
    $('#SpecialPrecautions').val(res.SpecialPrecautions);
    $('#Remarks').val(res.Remarks);
    $('#hdnManufacturerId').val(res.ManufacturerId);
    $('#txtManufacturer').val(res.Manufacturer);
    $('#hdnModelId').val(res.ModelId);
    $('#txtModel').val(res.Model);
    $('#Timestamp').val(res.Timestamp);
    $('#PPMChecklistNo').val(res.PPMChecklistNo);
    $('#primaryID').val(res.PPMCheckListId);
    $('#hdnAttachId').val(res.HiddenId);
}
window.BindCategoryGrid = function (list) {
    if (list.length > 0) {
        $(list).each(function (index, data) {
            AddFirstGridRow();
            $('#PPmCategoryDetId_' + index).val(data.PPmCategoryDetId);

            $('#PpmCategoryId_' + index).val(data.PpmCategoryId);
            $('#SNo_' + index).val(data.SNo);
            $('#Description_' + index).val(data.Description);

            $('#PpmCategoryId_' + index).attr('disabled', true);
            linkCliked1 = true;
        });

    }
}
window.BindQuantityGrid = function (list) {
    if (list.length > 0) {
        $(list).each(function (index, data) {
            AddSecondGridRow();
            $('#PPMCheckListQNId_' + index).val(data.PPMCheckListQNId);
            $('#QuantitativeTasks_' + index).val(data.QuantitativeTasks);
            $('#UOM_' + index).val(data.UOM);
            $('#SetValues_' + index).val(data.SetValues);
            $('#LimitTolerance_' + index).val(data.LimitTolerance);
            linkCliked2 = true;
        });
    }
}

var linkCliked1 = false;

window.AddFirstGridRow = function () {

    var inputpar = {
        inlineHTML: '<tr><td width="5%" id="PPMCheckListDel" ><div class="checkbox text-center"> <label for="checkboxes-0"> ' +
            '<input type="hidden" id= "PPmCategoryDetId_maxindexval"/> ' +
            '         <input type="checkbox" class="CategoryClass"  name="TestApparatusDelete" onchange="deleteGrid1(maxindexval)" id="IsDeletedCategory_maxindexval" value="false" autocomplete="off" tabindex="0"> </label></div>' +
            '</td><td width="25%" style="text-align: center;"><div> ' +
            '<select id="PpmCategoryId_maxindexval" onchange="getDetails(maxindexval)" class="form-control" ><option value="null">Select</option> </select></div></td><td width="10%" style="text-align: center;" ><div> ' +
            '<input type="text" readonly id="SNo_maxindexval" name="SNo" class="form-control" autocomplete="off" tabindex="0" ></div></td><td width="60%" style="text-align: center;"><div> ' +
            '<input type="text" id="Description_maxindexval" name="TestApparatus" class="form-control" autocomplete="off" tabindex="0"  maxlength="100"></div></td></tr>',
        IdPlaceholderused: "maxindexval",
        TargetId: "#FirstGridId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    if (!linkCliked1) {
        $('#FirstGridId tr:last td:first input').focus();
    }
    else {
        linkCliked1 = false;
    }
    var rowCount = $('#FirstGridId tr:last').index();
    $.each(window.CategoryListGloabal, function (index, value) {
        $('#PpmCategoryId_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
    $("input[id^='Description_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');

    formInputValidation("ppmchecklistFormId");
}

var linkCliked2 = false;
window.AddSecondGridRow = function () {
    var inputpar = {
        inlineHTML: '<tr><td width="5%"><div class="checkbox text-center"> <label for="checkboxes-0"> ' +
            '<input type="hidden" id= "PPMCheckListQNId_maxindexval" />' +
            '<input type="checkbox" name="QuntityDelete" id="IsDeleted_maxindexval" onchange="deleteGrid2(maxindexval)" autocomplete="off" tabindex="0" > </label></div></td>' +
            '<td width="35%" style="text-align: center;" ><div> ' +
            ' <input type="text" id="QuantitativeTasks_maxindexval" name="Quantitative" class="form-control " autocomplete="off" maxlength="500" tabindex="0"  /></div></td><td width="15%" style="text-align: center;" ><div> ' +
            '<select id="UOM_maxindexval" class="form-control"><option value="null">Select</option> </select> </div></td><td width="20%" style="text-align: center;" ><div> ' +
            ' <input type="text"  id="SetValues_maxindexval" name="SetValues" class="form-control text-right decimalCheckSetvalues" autocomplete="off" tabindex="0" maxlength="10" ></div></td><td width="25%" style="text-align: center;" ><div> ' +
            ' <input type="text" id="LimitTolerance_maxindexval" name="Tolerance" class="form-control text-right decimalCheckSetvalues" autocomplete="off" tabindex="0"  maxlength="10" /></div></td></tr>',
        IdPlaceholderused: "maxindexval",
        TargetId: "#SecondGridId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    if (!linkCliked2) {
        $('#SecondGridId tr:last td:first input').focus();
    }
    else {
        linkCliked2 = false;
    }
    var rowCount = $('#SecondGridId tr:last').index();
    $.each(window.UOMGloabal, function (index, value) {
        $('#UOM_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });




    $("input[id^='QuantitativeTasks_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    //  $("input[id^='SetValues_']").attr('pattern', '^\d+(\.\d{0,2})?$');

    //$('.decimalCheck').each(function (index) {
    //    //$(this).attr('id', 'ParamMapMin_' + index);
    //    var vrate = document.getElementById(this.id);
    //    vrate.addEventListener('input', function (prev) {
    //        return function (evt) {
    //            if ((!/^\d{0,2}(?:\.\d{0,2})?$/.test(this.value))) {
    //                this.value = prev;
    //            }
    //            else {
    //                prev = this.value;
    //            }
    //        };
    //    }(vrate.value), false);
    //});
    $('.decimalCheckSetvalues').each(function (index) {
        //$(this).attr('id', 'ParamMapMin_' + index);
        var vrate = document.getElementById(this.id);
        vrate.addEventListener('input', function (prev) {
            return function (evt) {
                if ((!/^\d{0,6}(?:\.\d{0,3})?$/.test(this.value))) {
                    this.value = prev;
                }
                else {
                    prev = this.value;
                }
            };
        }(vrate.value), false);
    });
    formInputValidation("ppmchecklistFormId");
}


function getDetails(maxIndex) {
    var _index;        // var _indexThird;
    var result = [];
    $('#FirstGridId tr').each(function () {
        _index = $(this).index();
    });

    for (var i = 0; i <= _index; i++) {
        var active = true;
        var isDeletedcat = $('#IsDeletedCategory_' + i).prop('checked');
        var pPmCategoryDetId = $('#PPmCategoryDetId_' + i).val();

        //  if (!isDeleted && pPmCategoryDetId != "0")
        //  {
        var _tempObj = {
            PPmCategoryDetId: $('#PPmCategoryDetId_' + i).val(),
            PpmCategoryId: $('#PpmCategoryId_' + i).val(),
            SNo: $('#SNo_' + i).val(),
            Description: $('#Description_' + i).val(),
            Active: isDeletedcat ? false : true,
        }
        result.push(_tempObj);
        // }          
    }
    var currentCategoryId = $('#PpmCategoryId_' + maxIndex).val();
    var maxNo = 0;
    maxNo = Enumerable.From(result).Where("$.PpmCategoryId ==" + currentCategoryId).Select("$.SNo").Count();
    maxNo = parseInt(maxNo) - 1;
    maxNo = parseInt(maxNo) + 1;
    // $('#SNo_' + maxIndex).val(maxNo);

}

$('#FirstGrid').click(function () {

    var rowCount = $('#FirstGridId tr:last').index();
    var PpmCategoryId = $('#PpmCategoryId_' + rowCount).val();



    var Description = $('#Description_' + rowCount).val();
    if (rowCount < 0)
        AddFirstGridRow();
    //else if (rowCount >= "0" && (PpmCategoryId == "null" || Description == "")) {
    //    bootbox.alert("Please fill the last record");
    //}
    else {
        AddFirstGridRow();
    }
});

$('#SecondGrid').click(function () {

    var rowCount = $('#SecondGridId tr:last').index();
    var QuantitativeTasks = $('#QuantitativeTasks_' + rowCount).val();
    var UOM = $('#UOM_' + rowCount).val();
    var SetValues = $('#SetValues_' + rowCount).val();
    var LimitTolerance = $('#LimitTolerance_' + rowCount).val();
    if (rowCount < 0)
        AddSecondGridRow();
    else if (rowCount >= "0" && (QuantitativeTasks == "" || UOM == "" || SetValues == "" || LimitTolerance == "")) {
        bootbox.alert("Please fill the last record");
    }
    else {
        AddSecondGridRow();
    }
});

;

$("#historytabId").click(function () {
    //$('#FileUploadTable').empty();

    var primaryId = $('#primaryID').val();

    if (primaryId == 0) {
        bootbox.alert(Messages.SAVE_FIRST_TABALERT);
        return false;
    }
    else {
        $('#histPPMChecklistNo').val($('#PPMChecklistNo').val());
        $('#histAssetTypeCode').val($('#txtAssetTypeCode').val());
        $('#histAssetTypeDescription').val($('#txtAssetTypeDescription').val());
        $('#histTaskcode').val($('#Taskcode').val());
        $('#histTaskCodeDesc').val($('#TaskCodeDesc').val());


        if (primaryId != null && primaryId != "0" && primaryId != "" && primaryId != 0) {

            $.get("/api/PPMChecklist/GetHistory/" + primaryId)
                .done(function (result) {

                    var res = JSON.parse(result);
                    $('#HistCategoryId').empty();
                    // $('#HistQuantityId').empty();
                    if (res != null && res.CategoryHistoryList != null && res.CategoryHistoryList.length > 0) {
                        var html = '';
                        $.each(res.CategoryHistoryList, function (index, data) {

                            (data.EffectiveFromDate != "") ? DateFormatter(data.EffectiveFromDate) : "";
                            html += ' <tr class="ng-scope" style=""> <td width="25%" > <div>' +
                                ' <input type="text" id="Version_' + index + '" value="' + data.Version + '" style="text-align: right;" class="form-control" readonly> </div></td><td width="25%" style="text-align: center;" > <div> ' +
                                ' <input type="text" id="EffectiveFromDate_' + index + '" value="' + DateFormatter(data.EffectiveFromDate) + '"  class="form-control" readonly> </div></td><td width="25%" style="text-align: center;" data-original-title="" title=""> <div> ' +
                                '<input type="text" id="ModifiedBy_' + index + '" value="' + data.ModifiedBy + '" class="form-control" readonly> </div></td><td width="25%" style="text-align: center;" data-original-title="" title=""> <div> ' +
                                '<a data-toggle="modal" class="btn btn-sm btn-primary btn-info btn-lg" onclick="GetCategoryDetails(' + index + ')" data-target="#myModal"> <span class="glyphicon glyphicon-modal-window btn-info" role="button" tabindex="0"></span> </a> </div></td></tr>';


                        });
                        $('#HistCategoryId').append(html);
                        $('#myPleaseWait').modal('hide');
                    }
                    else {
                        $('#myPleaseWait').modal('hide');
                        var emptyrow = '<tr id="NoActRec" class="norecord"><td width="100%"><h5 class="text-center">No  records to display</h5></td></tr>'
                        $("#HistCategoryId ").append(emptyrow);
                    }
                    //if (res != null && res.QunantityHistoryList != null && res.QunantityHistoryList.length > 0) {
                    //    var html1 = '';
                    //    $.each(res.QunantityHistoryList, function (index, data) {


                    //        html1 += ' <tr class="ng-scope" style=""> <td width="25%" > <div>' +
                    //                ' <input type="text" id="Version_' + index + '" value="' + data.Version + '" style="text-align: right;" class="form-control" readonly> </div></td><td width="25%" style="text-align: center;" > <div> ' +
                    //                ' <input type="text" id="EffectiveFromDate_' + index + '" value="' + DateFormatter(data.EffectiveFromDate) + '"  class="form-control" readonly> </div></td><td width="25%" style="text-align: center;" data-original-title="" title=""> <div> ' +
                    //                '<input type="text" id="ModifiedBy_' + index + '" value="' + data.ModifiedBy + '" class="form-control" readonly> </div></td><td width="25%" style="text-align: center;" data-original-title="" title=""> <div> ' +
                    //                '<a data-toggle="modal" onclick="GetQuantityDetails(' + index + ')" class="btn btn-sm btn-primary btn-info btn-lg" data-target="#myModal1"> <span class="glyphicon glyphicon-modal-window btn-info" role="button" tabindex="0"></span> </a> </div></td></tr>';


                    //    });
                    //    $('#HistQuantityId').append(html1);
                    //}

                    $('#myPleaseWait').modal('hide');
                })
                .fail(function () {
                    $('#myPleaseWait').modal('hide');
                    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                    $('#errorMsg').css('visibility', 'visible');
                });
        }
    }
});


function GetCategoryDetails(index) {
    var Version = $('#Version_' + index).val();
    $('#HistPopupCategoryId').empty();
    GetPopUpDatails(Version, "1")
    // GetPopUpDatails(Version)
}

//function GetQuantityDetails(index) {
//    // $('#HistQuantityId').empty();
//    var Version = $('#Version_' + index).val();
//    GetPopUpDatails(Version, "2");
//}

//




function GetPopUpDatails(version, gridId) {
    var primaryId = $('#primaryID').val();

    if (primaryId != null && primaryId != "0" && primaryId != "" && primaryId != 0) {

        $.get("/api/PPMChecklist/GetPopupDetails/" + primaryId + "/" + version + "/" + gridId)
            .done(function (result) {
                $('#PopUpQuantityId').empty();
                $('#HistPopupCategoryId').empty();
                var res = JSON.parse(result);
                if (gridId == "1") {
                    if (res != null && res.CategoryPopupHistoryList != null && res.CategoryPopupHistoryList.length > 0) {
                        var html = '';
                        $('#HistPopupCategoryId').empty();
                        $.each(res.CategoryPopupHistoryList, function (index, data) {


                            html += '  <tr class="ng-scope"> <td width="35%" style="text-align: center;"> <div>' +

                                '<input type="text" id="CategoryName_' + index + '" value="' + data.PPmCategory + '" name="Version" class="form-control" readonly> </div></td><td width="15%" style="text-align: center;"> <div>' +
                                ' <input type="text" id="Sno_' + index + '" value="' + data.SNo + '" name="Version" style="text-align: right;" class="form-control" readonly> </div></td><td width="50%" style="text-align: center;" > <div> ' +
                                '<input type="text" id="Description_' + index + '" value="' + data.Description + '" name="Version" class="form-control" readonly> </div></td></tr>';


                        });
                        $('#HistPopupCategoryId').append(html);
                    }
                    if (res != null && res.QunantityPopupHistoryList != null && res.QunantityPopupHistoryList.length > 0) {
                        var html1 = '';
                        $('#PopUpQuantityId').empty();
                        $.each(res.QunantityPopupHistoryList, function (index, data) {


                            html1 += ' <tr class="ng-scope"> <td width="40%" style="text-align: center;"> <div>' +
                                ' <input type="hidden" id="PPMCheckListQNId_' + index + '" value="' + data.PPMCheckListQNId + '"/> ' +
                                '<input type="text" id="QTDescription_' + index + '" value="' + data.QuantitativeTasks + '" name="Version" class="form-control" readonly> </div></td><td width="15%" style="text-align: center;"> <div>' +
                                ' <input type="text" id="Units_' + index + '" value="' + data.UOMValue + '" style="text-align: center;" name="Version" class="form-control" readonly> </div></td><td width="20%" "> <div> ' +
                                ' <input type="text" id="SetValues_' + index + '" value="' + data.SetValues + '" name="Version" style="text-align: right;" class="form-control" readonly> </div></td><td width="25%"> <div> ' +
                                '<input type="text" id="LimitTolerance_' + index + '" value="' + data.LimitTolerance + '" name="Version" style="text-align: right;" class="form-control" readonly> </div></td></tr>';
                        });
                        $('#PopUpQuantityId').append(html1);
                    }

                }


                $('#myPleaseWait').modal('hide');
            })
            .fail(function () {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');
            });
    }

}





$('#chkCategory1DeleteAll').on('click', function () {
    var isChecked = $(this).prop("checked");
    //var index1; $('#chkContactDeleteAll').prop('checked', true);
    // var count = 0;
    $('#FirstGridId tr').each(function (index, value) {
        // if (index == 0) return;
        // index1 = index - 1;
        if (isChecked) {
            // if(!$('#chkContactDelete_' +index1).prop('disabled'))
            // {
            $('#IsDeletedCategory_' + index).prop('checked', true);
            // $('#IsDeletedCategory_' + index).parent().addClass('bgDelete');
            $('#PpmCategoryId_' + index).removeAttr('');
            $('#Description_' + index).removeAttr('');
            $('#PpmCategoryId_' + index).parent().removeClass('has-error');
            $('#Description_' + index).parent().removeClass('has-error');

        }
        else {
            //if(!$('#chkContactDelete_' +index1).prop('disabled'))
            //{
            $('#PpmCategoryId_' + index).attr('', true);
            $('#Description_' + index).attr('', true);
            $('#IsDeletedCategory_' + index).prop('checked', false);
            $//('#IsDeletedCategory_' + index).parent().removeClass('bgDelete');
            // }
        }
    });
    //if(count == 0){
    //    $(this).prop("checked", false);
    //}
});


function deleteGrid1(currentindex) {

    var rowCount = $('#FirstGridId tr:last').index() + 1;
    var _index;        // var _indexThird;
    var result = [];
    $('#FirstGridId tr').each(function () {
        _index = $(this).index();
    });

    for (var i = 0; i <= _index; i++) {
        var active = true;
        var isDeletedcat = $('#IsDeletedCategory_' + i).prop('checked');
        var pPmCategoryDetId = $('#PPmCategoryDetId_' + i).val();

        var _tempObj = {
            PPmCategoryDetId: $('#PPmCategoryDetId_' + i).val(),
            PpmCategoryId: $('#PpmCategoryId_' + i).val(),
            SNo: $('#SNo_' + i).val(),
            Description: $('#Description_' + i).val(),
            Active: isDeletedcat ? false : true,
        }
        result.push(_tempObj);
    }

    var count = Enumerable.From(result).Where(function (x) { return x.Active == false }).Count();

    if (count == rowCount) {
        $('#chkCategory1DeleteAll').prop('checked', true);
        // bootbox.alert(Messages.CAN_NOT_DELETE_ALL_RECORDS);
        //$('#IsDeletedCategory_' + currentindex).prop('checked', false);
    }
    else {
        $('#chkCategory1DeleteAll').prop('checked', false);
        if ($('#IsDeletedCategory_' + currentindex).is(":checked")) {

            //$('#IsDeletedCategory_' + currentindex).parent().addClass('bgDelete');
            $('#PpmCategoryId_' + currentindex).removeAttr('');
            $('#Description_' + currentindex).removeAttr('');
            $('#PpmCategoryId_' + currentindex).parent().removeClass('has-error');
            $('#Description_' + currentindex).parent().removeClass('has-error');
        }
        else {
            //$('#IsDeletedCategory_' + currentindex).parent().removeClass('bgDelete');
            $('#PpmCategoryId_' + currentindex).attr('', true);
            $('#Description_' + currentindex).attr('', true);
        }
    }
}


$('#chkQuantityDeleteAll').on('click', function () {
    var isChecked = $(this).prop("checked");
    //var index1; $('#chkContactDeleteAll').prop('checked', true);
    // var count = 0;
    $('#SecondGridId tr').each(function (index, value) {
        // if (index == 0) return;
        // index1 = index - 1;
        if (isChecked) {
            // if(!$('#chkContactDelete_' +index1).prop('disabled'))
            // {
            $('#IsDeleted_' + index).prop('checked', true);
            // $('#IsDeleted_' + index).parent().addClass('bgDelete');

            $('#QuantitativeTasks_' + index).removeAttr('');
            $('#UOM_' + index).removeAttr('');
            $('#SetValues_' + index).removeAttr('');
            $('#LimitTolerance_' + index).removeAttr('');

            $('#QuantitativeTasks_' + index).parent().removeClass('has-error');
            $('#UOM_' + index).parent().removeClass('has-error');

            $('#SetValues_' + index).parent().removeClass('has-error');
            $('#LimitTolerance_' + index).parent().removeClass('has-error');
            // count++;
            //  }
        }
        else {
            $('#QuantitativeTasks_' + index).attr('', true);
            $('#UOM_' + index).attr('', true);
            $('#SetValues_' + index).attr('', true);
            $('#LimitTolerance_' + index).attr('', true);
            $('#IsDeleted_' + index).prop('checked', false);
            //$('#IsDeleted_' + index).parent().removeClass('bgDelete');
            // }
        }
    });
    //if(count == 0){
    //    $(this).prop("checked", false);
    //}
});


function deleteGrid2(currentindex) {
    var rowCount = $('#SecondGridId tr:last').index() + 1;
    var _index1;        // var _indexThird;
    var result1 = [];
    $('#SecondGridId tr').each(function () {
        _index1 = $(this).index();
    });
    for (var i = 0; i <= _index1; i++) {
        var active = true;
        var isDeleted = $('#IsDeleted_' + i).prop('checked');
        var PPMCheckListQNId = $('#PPMCheckListQNId_' + i).val();
        //  if (!isDeleted && PPMCheckListQNId != "0") {
        var _tempObj1 = {
            PPMCheckListQNId: PPMCheckListQNId,
            PPMCheckListId: $("#primaryID").val(),
            QuantitativeTasks: $('#QuantitativeTasks_' + i).val(),
            UOM: $('#UOM_' + i).val(),
            SetValues: $('#SetValues_' + i).val(),
            LimitTolerance: $('#LimitTolerance_' + i).val(),
            Active: isDeleted ? false : true,
        }
        result1.push(_tempObj1);
        // }
    }

    var count = Enumerable.From(result1).Where(function (x) { return x.Active == false }).Count();
    if (count == rowCount) {

        $('#chkQuantityDeleteAll').prop('checked', true);
        //  bootbox.alert(Messages.CAN_NOT_DELETE_ALL_RECORDS);
        // $('#IsDeleted_' + currentindex).prop('checked', false);
    }
    else {
        $('#chkQuantityDeleteAll').prop('checked', false);
        if ($('#IsDeleted_' + currentindex).is(":checked")) {
            //$('#IsDeleted_' + currentindex).parent().addClass('bgDelete');
            $('#QuantitativeTasks_' + currentindex).removeAttr('');
            $('#UOM_' + currentindex).removeAttr('');
            $('#SetValues_' + currentindex).removeAttr('');
            $('#LimitTolerance_' + currentindex).removeAttr('');

            $('#QuantitativeTasks_' + currentindex).parent().removeClass('has-error');
            $('#UOM_' + currentindex).parent().removeClass('has-error');
            $('#SetValues_' + currentindex).parent().removeClass('has-error');
            $('#LimitTolerance_' + currentindex).parent().removeClass('has-error')
        }
        else {
            //$('#IsDeleted_' + currentindex).parent().removeClass('bgDelete');
            $('#QuantitativeTasks_' + currentindex).attr('', true);
            $('#UOM_' + currentindex).attr('', true);
            $('#SetValues_' + currentindex).attr('', true);
            $('#LimitTolerance_' + currentindex).attr('', true);
        }


    }
}
