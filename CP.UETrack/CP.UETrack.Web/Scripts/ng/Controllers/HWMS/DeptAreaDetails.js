var FrequencyLovVal = "<option value=>" + "Select" + "</option>";
var CollectionLovVal = "<option value=>" + "Select" + "</option>";
var WasteTypeLovVal = "<option value=>" + "Select" + "</option>";
var Dropdownvalues = "<option value=>" + "Select" + "</option>";
var UOMValues = "<option value=''>" + "Select" + "</option>";

var rowNum1 = 1;
var rowNum2 = 1;

$(document).ready(function () {

    $.get("/api/DeptAreaDetail/Load")
        .done(function (result) {

            var loadResult = JSON.parse(result);
            $("#ddlOperationalDays").append("<option value='' Selected>" + "Select" + "</option>");
            $("#ddlCategory").append("<option value='' Selected>" + "Select" + "</option>");
            Frequency = "<option value='' Selected>" + "Select" + "</option>"
            Collection = "<option value='0' Selected>" + "Select" + "</option>"
            for (var i = 0; i < loadResult.StatusLovs.length; i++) {
                $("#ddlStatus").append(
                    "<option value=" + loadResult.StatusLovs[i].LovId + ">" + loadResult.StatusLovs[i].FieldValue + "</option>"
                );
            } 
            for (var i = 0; i < loadResult.CategoryLovs.length; i++) {
                $("#ddlCategory").append(
                    "<option value=" + loadResult.CategoryLovs[i].LovId + ">" + loadResult.CategoryLovs[i].FieldValue + "</option>"
                );
            }
            for (var i = 0; i < loadResult.OperatingDaysLovs.length; i++) {
                $("#ddlOperationalDays").append(
                    "<option value=" + loadResult.OperatingDaysLovs[i].LovId + ">" + loadResult.OperatingDaysLovs[i].FieldValue + "</option>"
                );
            }
            for (var i = 0; i < loadResult.FrequencyTypeLovs.length; i++) {
                FrequencyLovVal += "<option value=" + loadResult.FrequencyTypeLovs[i].LovId + ">" + loadResult.FrequencyTypeLovs[i].FieldValue + "</option>"
            }            
            for (var i = 0; i < loadResult.CollectionFrequencyLovs.length; i++) {
                CollectionLovVal += "<option value=" + loadResult.CollectionFrequencyLovs[i].LovId + ">" + loadResult.CollectionFrequencyLovs[i].FieldValue + "</option>";
            }            
            for (var i = 0; i < loadResult.WasteTypeLovs.length; i++) {
                WasteTypeLovVal += "<option value=" + loadResult.WasteTypeLovs[i].LovId + ">" + loadResult.WasteTypeLovs[i].FieldValue + "</option>";
            }
            for (var i = 0; i < loadResult.UOMLovs.length; i++) {
                UOMValues += "<option value=" + loadResult.UOMLovs[i].LovId + ">" + loadResult.UOMLovs[i].FieldValue + "</option>"
            }

            $("#ddlFrequencyType1").html(FrequencyLovVal);
            $("#ddlCollectionFrequency1").html(CollectionLovVal);
            $("#ddlWasteTypeConsumables1").html(WasteTypeLovVal);
            $("#ddlWasteTypeCollection1").html(WasteTypeLovVal);
            $("#ddlUOM1").append(UOMValues);
            $('#myPleaseWait').modal('hide');
        })
        .fail(function (response) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            $('#errorMsgConfigAdditionalFields').css('visibility', 'visible');
        });
    //******************************************AutoPopulate UserAreaCode******************************************

    var UserAreaFetchObj = {
        SearchColumn: 'txtUserAreaCode-UserAreaCode',//Id of Fetch field
        ResultColumns: ["UserAreaId-Primary Key", 'UserAreaCode-UserAreaCode'],
        FieldsToBeFilled: ["hdnUserAreaId-UserAreaId", "txtUserAreaCode-UserAreaCode", "txtUserAreaName-UserAreaName", "txtEffectiveFromDate-ActiveFromDate", "txtEffectiveToDate-ActiveToDate" ]
    };

    $('#txtUserAreaCode').on('input propertychange paste keyup', function (event) {       
        DisplayFetchResult('divUserAreaFetch', UserAreaFetchObj, "/Api/Fetch/UserAreaFetch", "UlFetch1", event, 1);//1 -- pageIndex
    });

    $('input[type=time]').css('padding', '0px');

    //******************************************AutoPopulate ItemCode******************************************
   
   
    $(body).on('input propertychange paste keyup', '.HWMSItem', function (event) {
        var controlId = event.target.id;
        var id = controlId.slice(11, 13);
        var ItemCodeFetchObj = {
            AdditionalConditions: ['WasteTypeCode-ddlWasteTypeConsumables' + id],
            SearchColumn: 'txtItemCode' + id + '-ItemCode',//Id of Fetch field
            ResultColumns: ['ItemCodeId-Primary Key', 'ItemCode-ItemCode'],
            FieldsToBeFilled: ['hdnItemCodeId' + id + '-ItemCodeId', 'txtItemCode' + id + '-ItemCode', 'txtItemName' + id + '-ItemName', 'txtSize' + id + '-Size', 'ddlUOM' + id + '-UOM']
        };
        DisplayFetchResult('divItemCode' + id, ItemCodeFetchObj, "/Api/DeptAreaDetail/ItemCodeFetch", 'UlFetch2' + id, event, 1);//1 -- pageIndex
    });

   
    //******************************************Display UserAreaName based on UserAreaCode******************************************

    //$("#txtUserAreaCode").focusout(function () {

    //    var Areacode = $('#txtUserAreaCode').val();
    //    if (Areacode != "") {
    //        var jqxhr = $.get("/Api/DeptAreaDetail/UserAreaNameData/" + Areacode, function (response) {
    //            var result = JSON.parse(response);                               
    //            $('#txtUserAreaName').val(result.UserAreaName);
    //            $('#txtEffectiveFromDate').val(getCustomDate(result.EffectiveFromDate));
    //            $('#txtEffectiveToDate').val(getCustomDate(result.EffectiveToDate));           
    //        },
    //            "json")
    //            .fail(function (response) {
    //                var errorMessage = "";
    //                if (response.status == 400) {
    //                    errorMessage = response.responseJSON;
    //                }
    //                else {
    //                    errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
    //                }
    //            });
    //    }
    //});

    //******************************************Enabling StartTime and EndTime based On Collection Frequency******************************************

    $(body).on('input propertychange', '.HWCollectionFrequency', function (event) {
                
        var selectedIndex = event.target.selectedIndex;
        var rowId = event.target.id.slice(22, 24);

        $('#txtStartTime1' + rowId).prop("disabled", true);
        $('#txtEndTime1' + rowId).prop("disabled", true);
        $('#txtStartTime2' + rowId).prop("disabled", true);
        $('#txtEndTime2' + rowId).prop("disabled", true);
        $('#txtStartTime3' + rowId).prop("disabled", true);
        $('#txtEndTime3' + rowId).prop("disabled", true);
        $('#txtStartTime4' + rowId).prop("disabled", true);
        $('#txtEndTime4' + rowId).prop("disabled", true);

        if (selectedIndex == 1) {

            $('#txtStartTime1' + rowId).prop("disabled", false);
            $('#txtEndTime1' + rowId).prop("disabled", false);   

            $('#txtStartTime2' + rowId).val('');
            $('#txtEndTime2' + rowId).val('');
            $('#txtStartTime3' + rowId).val('');
            $('#txtEndTime3' + rowId).val('');
            $('#txtStartTime4' + rowId).val('');
            $('#txtEndTime4' + rowId).val('');
        }
        else if (selectedIndex == 2) {

            $('#txtStartTime1' + rowId).prop("disabled", false);
            $('#txtEndTime1' + rowId).prop("disabled", false);
            $('#txtStartTime2' + rowId).prop("disabled", false);
            $('#txtEndTime2' + rowId).prop("disabled", false);            

            $('#txtStartTime3' + rowId).val('');
            $('#txtEndTime3' + rowId).val('');
            $('#txtStartTime4' + rowId).val('');
            $('#txtEndTime4' + rowId).val('');
        }
        else if (selectedIndex == 3) {

            $('#txtStartTime1' + rowId).prop("disabled", false);
            $('#txtEndTime1' + rowId).prop("disabled", false);
            $('#txtStartTime2' + rowId).prop("disabled", false);
            $('#txtEndTime2' + rowId).prop("disabled", false);
            $('#txtStartTime3' + rowId).prop("disabled", false);
            $('#txtEndTime3' + rowId).prop("disabled", false);
            $('#txtStartTime4' + rowId).prop("disabled", true);
            $('#txtEndTime4' + rowId).prop("disabled", true);

            $('#txtStartTime4' + rowId).val('');
            $('#txtEndTime4' + rowId).val('');
        }
        else if (selectedIndex == 4) {

            $('#txtStartTime1' + rowId).prop("disabled", false);
            $('#txtEndTime1' + rowId).prop("disabled", false);
            $('#txtStartTime2' + rowId).prop("disabled", false);
            $('#txtEndTime2' + rowId).prop("disabled", false);
            $('#txtStartTime3' + rowId).prop("disabled", false);
            $('#txtEndTime3' + rowId).prop("disabled", false);
            $('#txtStartTime4' + rowId).prop("disabled", false);
            $('#txtEndTime4' + rowId).prop("disabled", false);
        }

    });

   
  //******************************************Save and SaveAndNew Buttons Code******************************************

    $("#btnSave, #btnSaveandAddNew").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');

        var isFormValid = formInputValidation("formDeptAreaDetail", 'save');
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
            DeptAreaId: primaryId,
            CustomerId: $('#selCustomerLayout').val(),
            FacilityId: $('#selFacilityLayout').val(),
            UserAreaId: $("#hdnUserAreaId").val(),
            UserAreaCode: $('#txtUserAreaCode').val(),
            UserAreaName: $('#txtUserAreaName').val(),
            EffectiveFromDate: $('#txtEffectiveFromDate').val(),
            EffectiveToDate: $('#txtEffectiveToDate').val(),
            OperatingDays: $('#ddlOperationalDays').val(),
            Status: $('#ddlStatus').val(),
            Category: $('#ddlCategory').val(),
            Remarks: $('#txtRemarks').val(),
            DDConsumablesList: [],
            DDCollectionList: []
        }

        $("#tbodyConsumablesReceptacles tr").each(function () {
            var DeptObj = {};

            DeptObj.ReceptaclesId = $(this).find("[id^=hdnReceptaclesId]")[0].value;
            DeptObj.WasteTypeConsumables = $(this).find("[id^=ddlWasteTypeConsumables]")[0].value;
            DeptObj.ItemCode = $(this).find("[id^=txtItemCode]")[0].value;
            DeptObj.ItemName = $(this).find("[id^=txtItemName]")[0].value;
            DeptObj.Size = $(this).find("[id^=txtSize]")[0].value;
            DeptObj.UOM = $(this).find("[id^=ddlUOM]")[0].value;
            DeptObj.ShelfLevelQuantity = $(this).find("[id^=txtShelfLevelQuantity]")[0].value;
            DeptObj.isDeleted = $(this).find('input:checkbox[id^=isDelete]').prop("checked");
            obj.DDConsumablesList.push(DeptObj);
        });

        var isStartEndTime = 0;
        $("#tbodyCollectionFrequency tr").each(function () {

            var Dept1Obj = {};
            Dept1Obj.FrequencyId = $(this).find("[id^=hdnCollectionFrequencyId]")[0].value;
            Dept1Obj.WasteTypeCollection = $(this).find("[id^=ddlWasteTypeCollection]")[0].value;
            Dept1Obj.FrequencyType = $(this).find("[id^=ddlFrequencyType]")[0].value;
            Dept1Obj.CollectionFrequency = $(this).find("[id^=ddlCollectionFrequency]")[0].value;
            Dept1Obj.StartTime1 = $(this).find("[id^=txtStartTime1]")[0].value;
            Dept1Obj.EndTime1 = $(this).find("[id^=txtEndTime1]")[0].value;
            Dept1Obj.StartTime2 = $(this).find("[id^=txtStartTime2]")[0].value;
            Dept1Obj.EndTime2 = $(this).find("[id^=txtEndTime2]")[0].value;
            Dept1Obj.StartTime3 = $(this).find("[id^=txtStartTime3]")[0].value;
            Dept1Obj.EndTime3 = $(this).find("[id^=txtEndTime3]")[0].value;
            Dept1Obj.StartTime4 = $(this).find("[id^=txtStartTime4]")[0].value;
            Dept1Obj.EndTime4 = $(this).find("[id^=txtEndTime4]")[0].value;
            Dept1Obj.isDeleted = $(this).find('input:checkbox[id^=isDelete]').prop("checked");
            obj.DDCollectionList.push(Dept1Obj);

            if (Dept1Obj.StartTime1 != '') {
                if (Dept1Obj.StartTime1 > Dept1Obj.EndTime1) {
                    isStartEndTime += 1;
                }
            }
            if (Dept1Obj.StartTime2 != '') {
                if (Dept1Obj.StartTime2 > Dept1Obj.EndTime2) {
                    isStartEndTime += 1;
                }
            }
            if (Dept1Obj.StartTime3 != '') {
                if (Dept1Obj.StartTime3 > Dept1Obj.EndTime3) {
                    isStartEndTime += 1;
                }
            }
            if (Dept1Obj.StartTime4 != '') {
                if (Dept1Obj.StartTime4 > Dept1Obj.EndTime4) {
                    isStartEndTime += 1;
                }
            }

            //if (Dept1Obj.StartTime1 > Dept1Obj.EndTime1 || Dept1Obj.EndTime1 > Dept1Obj.StartTime2 || Dept1Obj.StartTime2 > Dept1Obj.EndTime2 || Dept1Obj.EndTime2 > Dept1Obj.StartTime3 || Dept1Obj.StartTime3 > Dept1Obj.EndTime3 || Dept1Obj.EndTime3 > Dept1Obj.StartTime4 || Dept1Obj.StartTime4 > Dept1Obj.EndTime4) {
            //    isStartEndTime += 1;
            //}
        });

        if (isStartEndTime > 0) {
            bootbox.alert("Start time must be less than the EndTime and Start time must be later than end time of previous shecdule.");
            return false;
        }

       
        $.post("/Api/DeptAreaDetail/Save", obj, function (response) {
            var result = JSON.parse(response);
            showMessage('Dept/AreaDetails', CURD_MESSAGE_STATUS.SS);

            $("#tbodyConsumablesReceptacles").find('input[name="isDelete"]').each(function () {
                if ($(this).is(":checked")) {
                    $(this).closest("tr").remove();
                }
            });

            $("#tbodyCollectionFrequency").find('input[name="isDelete"]').each(function () {
                if ($(this).is(":checked")) {
                    $(this).closest("tr").remove();
                }
            });
                                   
            $("#grid").trigger('reloadGrid');            
            if (CurrentbtnID == "btnSaveandAddNew") {
                EmptyFields();
                showMessage('Dept/AreaDetails', CURD_MESSAGE_STATUS.SS);
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
    $("#deleteConsumablesReceptacles").click(function () {
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
                        $("#tbodyConsumablesReceptacles tr").find('input[name="isDelete"]').each(function () {
                            if ($(this).is(":checked")) {
                                if ($(this).closest("tr").find("[id^=hdnReceptaclesId]").val() == 0) {
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

    $("#deleteCollectionFrequency").click(function () {
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
                        $("#tbodyCollectionFrequency tr").find('input[name="isDelete"]').each(function () {
                            if ($(this).is(":checked")) {
                                if ($(this).closest("tr").find("[id^=hdnCollectionFrequencyId]").val() == 0) {
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

    //******************************************Adding rows and Incrementing index values in Table 1***********************
    
    $("#addConsumablesReceptacles").click(function () {   
        rowNum1 += 1;
        addConsumablesReceptacles(rowNum1); 
    });
   
    //******************************************Adding rows and Incrementing index values for Table 2**********************
   
    $("#addCollectionFrequency").click(function () {
        rowNum2 += 1;
        addCollectionFrequency(rowNum2);
    });

 //******************************************Removing Required Fields for TextBoxes****************************************

    $(body).on('input propertychange', '.form-control', function (event) {
        $(this).parent().removeClass('has-error');
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
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            }
        });
    });

//******************************************JQGrid LinkClicked************************************************************

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

function EmptyFields() {

    $('#primaryID').val(0);
    $('[id^=hdnReceptaclesId]').val(0);
    $('[id^=hdnCollectionFrequencyId]').val(0);

    $('#formDeptAreaDetail')[0].reset();

    $('#UserareaCode').removeClass('has-error');
    $('#OperatingDays').removeClass('has-error');
    $('#Category').removeClass('has-error');
    $('#formDeptAreaDetail #WasteType').removeClass('has-error');
    $('#ItemCode').removeClass('has-error');
    $('#ShelfLevel').removeClass('has-error');
    $('#WasteTypeCollection').removeClass('has-error');
    $('#FrequencyType').removeClass('has-error');
    $("#txtStartTime1").prop("disabled", true);
    $("#txtEndTime1").prop("disabled", true);
    $("#txtStartTime2").prop("disabled", true);
    $("#txtEndTime2").prop("disabled", true);
    $("#txtStartTime3").prop("disabled", true);
    $("#txtEndTime3").prop("disabled", true);
    $("#txtStartTime4").prop("disabled", true);
    $("#txtEndTime4").prop("disabled", true);
   
    $('#errorMsg').css('visibility', 'hidden');

    var i = 1;
    $("#tbodyConsumablesReceptacles").find('tr').each(function () {
        if (i > 1) {
            $(this).remove();
        }
        i += 1;
    });

    i = 1;
    $("#tbodyCollectionFrequency").find('tr').each(function () {
        if (i > 1) {
            $(this).remove();
        }
        i += 1;
    });
}

//******************************************LinkClicked for JQGrid****************************************************

function LinkClicked(id) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formDeptAreaDetail :input:not(:button)").parent().removeClass('has-error');
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
        $("#formDeptAreaDetail :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnNextScreenSave').show();
    }


    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/DeptAreaDetail/Get/" + primaryId)
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

function fillDetails(getResult) {

    if (getResult != undefined) {

        $('#primaryID').val(getResult.DeptAreaId);
        $('#txtUserAreaCode').val(getResult.UserAreaCode);
        $('#txtUserAreaName').val(getResult.UserAreaName);
        $('#txtEffectiveFromDate').val(getCustomDate(getResult.EffectiveFromDate));
        $('#txtEffectiveToDate').val(getCustomDate(getResult.EffectiveToDate));
        $('#ddlOperationalDays').val(getResult.OperatingDays);
        $('#ddlStatus').val(getResult.Status);
        $('#ddlCategory').val(getResult.Category);
        $('#txtRemarks').val(getResult.Remarks);

        if (getResult.DDConsumablesList != null || getResult.DDConsumablesList != undefined) {

            $("#tbodyConsumablesReceptacles").html('');
            rowNum1 = 1;
            for (var i = 0; i < getResult.DDConsumablesList.length; i++) {

                addConsumablesReceptacles(rowNum1);

                $('#hdnReceptaclesId' + rowNum1).val(getResult.DDConsumablesList[i].ReceptaclesId);
                $('#ddlWasteTypeConsumables' + rowNum1).val(getResult.DDConsumablesList[i].WasteTypeConsumables);
                $('#txtItemCode' + rowNum1).val(getResult.DDConsumablesList[i].ItemCode);
                $('#txtItemName' + rowNum1).val(getResult.DDConsumablesList[i].ItemName);
                $('#txtSize' + rowNum1).val(getResult.DDConsumablesList[i].Size);
                $('#ddlUOM' + rowNum1).val(getResult.DDConsumablesList[i].UOM);
                $('#txtShelfLevelQuantity' + rowNum1).val(getResult.DDConsumablesList[i].ShelfLevelQuantity);

                rowNum1 += 1;
            }
        }              

        if (getResult.DDCollectionList != null || getResult.DDCollectionList != undefined) {

            $("#tbodyCollectionFrequency").html('');
            rowNum2 = 1;
            for (var i = 0; i < getResult.DDCollectionList.length; i++) {

                addCollectionFrequency(rowNum2);

                $('#hdnCollectionFrequencyId' + rowNum2).val(getResult.DDCollectionList[i].FrequencyId);
                $('#ddlWasteTypeCollection' + rowNum2).val(getResult.DDCollectionList[i].WasteTypeCollection);
                $('#ddlFrequencyType' + rowNum2).val(getResult.DDCollectionList[i].FrequencyType);
                $('#ddlCollectionFrequency' + rowNum2).val(getResult.DDCollectionList[i].CollectionFrequency);

                var startTime1 = getResult.DDCollectionList[i].StartTime1;
                var endTime1 = getResult.DDCollectionList[i].EndTime1;
                var startTime2 = getResult.DDCollectionList[i].StartTime2;
                var endTime2 = getResult.DDCollectionList[i].EndTime2;
                var startTime3 = getResult.DDCollectionList[i].StartTime3;
                var endTime3 = getResult.DDCollectionList[i].EndTime3;
                var startTime4 = getResult.DDCollectionList[i].StartTime4;
                var endTime4 = getResult.DDCollectionList[i].EndTime4;

                if (startTime1 != "" && endTime1 != "") {
                    $('#txtStartTime1' + rowNum2).val(startTime1);
                    $('#txtEndTime1' + rowNum2).val(endTime1);
                    $('#txtStartTime1' + rowNum2).prop("disabled", false);
                    $('#txtEndTime1' + rowNum2).prop("disabled", false);
                }
                else {
                    $('#txtStartTime1' + rowNum2).prop("disabled", true);
                    $('#txtEndTime1' + rowNum2).prop("disabled", true);
                }

                if (startTime2 != "" && endTime2 != "") {
                    $('#txtStartTime2' + rowNum2).val(startTime2);
                    $('#txtEndTime2' + rowNum2).val(endTime2);
                    $('#txtStartTime2' + rowNum2).prop("disabled", false);
                    $('#txtEndTime2' + rowNum2).prop("disabled", false);
                }
                else {
                    $('#txtStartTime2' + rowNum2).prop("disabled", true);
                    $('#txtEndTime2' + rowNum2).prop("disabled", true);
                }

                if (startTime3 != "" && endTime4 != "") {
                    $('#txtStartTime3' + rowNum2).val(startTime3);
                    $('#txtEndTime3' + rowNum2).val(endTime3);
                    $('#txtStartTime3' + rowNum2).prop("disabled", false);
                    $('#txtEndTime3' + rowNum2).prop("disabled", false);
                }
                else {
                    $('#txtStartTime3' + rowNum2).prop("disabled", true);
                    $('#txtEndTime3' + rowNum2).prop("disabled", true);
                }

                if (startTime4 != "" && endTime1 != "") {
                    $('#txtStartTime4' + rowNum2).val(startTime4);
                    $('#txtEndTime4' + rowNum2).val(endTime4);
                    $('#txtStartTime4' + rowNum2).prop("disabled", false);
                    $('#txtEndTime4' + rowNum2).prop("disabled", false);
                }
                else {
                    $('#txtStartTime4' + rowNum2).prop("disabled", true);
                    $('#txtEndTime4' + rowNum2).prop("disabled", true);
                }

                rowNum2 += 1;
            }
        }
    }
    $('input[type=time]').css('padding', '0px');
}

function addConsumablesReceptacles(num) {

    var CheckBox = '<td style="text-align:center"><input type="checkbox" id="isDelete' + num + '" name="isDelete"/> <input type="hidden" id="hdnReceptaclesId' + num + '" value="0" /></td>';
    var WasteType = '<td id="WasteType"> <select required class="form-control" id="ddlWasteTypeConsumables' + num + '">' + WasteTypeLovVal + '</select></td>';
    var ItemCode = '<td id="ItemCode"> <input type="text" required class="form-control HWMSItem" placeholder="Please Select" id="txtItemCode' + num + '" autocomplete="off" name="ItemCode" maxlength="25"  /><input type = "hidden" id="hdnItemCodeId' + num + '" />   <div class="col-sm-12" id="divItemCode' + num + '">   </div></td> ';
    var ItemName = '<td> <input type="text"  class="form-control" disabled  id="txtItemName' + num + '" autocomplete="off" name="ItemName" maxlength="25"  /></td>';
    var Size = '<td> <input type="text"  class="form-control" disabled  id="txtSize' + num + '" autocomplete="off" name="Size" maxlength="25"  /></td>';
    var UOM = '<td> <select  class="form-control" disabled  id="ddlUOM' + num + '" autocomplete="off" name="UOM"> ' + UOMValues + '</select></td>';
    var ShelfLevelQuantity = '<td id="ShelfLevel"> <input type="text" required class="form-control" id="txtShelfLevelQuantity' + num + '" autocomplete="off" name="ShelfLevelQuantity" maxlength="25"  /></td>';

    $("#tbodyConsumablesReceptacles").append('<tr>' + CheckBox + WasteType + ItemCode + ItemName + Size + UOM + ShelfLevelQuantity + '</tr>');
        
}

function addCollectionFrequency(num) {

    var CheckBox = '<td style="text-align:center"><input type="checkbox" id="isDelete' + num + '" name="isDelete"/> <input type="hidden" id="hdnCollectionFrequencyId' + num + '" value="0" /></td>';
    var WasteType = '<td id="WasteTypeCollection"> <select required class="form-control" style="width: 100px;" id="ddlWasteTypeCollection' + num + '">' + WasteTypeLovVal + '</select></td>';
    var FrequencyType = '<td id="FrequencyType"><select type="text" required class="form-control" style="width: 100px;" id="ddlFrequencyType' + num + '" autocomplete="off" name="FrequncyType" maxlength="25" >' + FrequencyLovVal + '</select ></td>';
    var CollectionFrequency = '<td><select type="text"  class="form-control HWCollectionFrequency" style="width: 100px;" id="ddlCollectionFrequency' + num + '" autocomplete="off" name="FrequncyType" maxlength="25" >' + CollectionLovVal + '</select ></td>';
    var StartTime1 = '<td> <input type="time" class="form-control" id="txtStartTime1' + num + '" disabled autocomplete="off" name="StartTime1" maxlength="25"  /></td>';
    var EndTime1 = '<td> <input type="time" class="form-control" id="txtEndTime1' + num + '" disabled autocomplete="off" name="EndTime1" maxlength="25"  /></td>';
    var StartTime2 = '<td>  <input type="time" class="form-control" id="txtStartTime2' + num + '" disabled autocomplete="off" name="StartTime2" maxlength="25"  /></td>';
    var EndTime2 = '<td>  <input type="time" class="form-control" id="txtEndTime2' + num + '" disabled autocomplete="off" name="EndTime2" maxlength="25"  /></td>';
    var StartTime3 = '<td> <input type="time" class="form-control" id="txtStartTime3' + num + '" disabled autocomplete="off" name="StartTime3" maxlength="25"  /></td>';
    var EndTime3 = '<td>  <input type="time" class="form-control" id="txtEndTime3' + num + '" disabled autocomplete="off" name="EndTime3" maxlength="25"  /></td>';
    var StartTime4 = '<td> <input type="time" class="form-control" id="txtStartTime4' + num + '" disabled  autocomplete="off" name="StartTime4" maxlength="25"  /></td>';
    var EndTime4 = '<td>  <input type="time" class="form-control" id="txtEndTime4' + num + '" disabled autocomplete="off" name="EndTime4" maxlength="25"  /></td>';

    $("#tbodyCollectionFrequency").append('<tr>' + CheckBox + WasteType + FrequencyType + CollectionFrequency + StartTime1 + EndTime1 + StartTime2 + EndTime2 + StartTime3 + EndTime3 + StartTime4 + EndTime4 + '</tr>');       

    $('input[type=time]').css('padding', '0px');

   
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

        return  day + "-" + month + "-" + year;        
    }    
}