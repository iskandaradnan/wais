var DayListFialData;
var MonthListFinal;

var LOVlist = {};
var SummaryDetails = [];
$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    formInputValidation("FrmCentral");
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $.get("/api/CentralCleanLinen/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);

            $.each(loadResult.StoreType, function (index, value) {
                $('#txtCentralCleanLinenStore').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            AddNewRowStkAdjustment();
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });
});

$(".btnSave").click(function () {
    $('#btnlogin').attr('disabled', true);
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');

    $('#txtCentralCleanLinenStore').attr('required', true);
    var CurrentbtnID = $(this).attr("Id");
    var _index;     
    var result = [];
    $('#SummaryResultId tr').each(function () {
        _index = $(this).index();
    });

    for (var i = 0; i <= _index; i++) {
        var active = true;
        var _tempObj = {
            LicenseTypeDetId: $('#LicenseTypeDetId_').val(),
            LicenseCode: $('#LicenseCode_' + i).val(),
            LicenseDescription: $('#LicenseDescription_' + i).val(),
            IssuingBody: $('#IssuingBody_' + i).val(),
        }
        result.push(_tempObj);
    }
    var timeStamp = $("#Timestamp").val();
    var MstLicenseType = {
        LicenseType: $('#txtCentralCleanLinenStore').val(),
        LicenseTypeModelListData: result
    };
    var primaryId = $("#primaryID").val();
    if (primaryId != null) {
        MstLicenseType.LicenseTypeId = primaryId;
        MstLicenseType.Timestamp = timeStamp;
    }
    else {
        MstLicenseType.LicenseTypeId = 0;
        MstLicenseType.Timestamp = "";
    }
    var jqxhr = $.post("/api/LicenseType/Save", MstLicenseType, function (response) {
        var result = JSON.parse(response);
        $("#primaryID").val(result.LicenseTypeId);
        if (result != null && result.LicenseTypeModelListData != null && result.LicenseTypeModelListData.length > 0) {
            BindGridData(result);
        }
        $("#Timestamp").val(result.Timestamp);
        $("#txtCentralCleanLinenStore").val(result.LicenseType);
        $('#hdnStatus').val(result.Active);
        $("#grid").trigger('reloadGrid');
        if (result.LicenseTypeId != 0) {
            $('#hdnAttachId').val(result.HiddenId);
            $('#btnNextScreenSave').show();
            $('#btnEdit').show();
            $('.btnSave').show();
            $('.btnDelete').show();
        }
        $(".content").scrollTop(0);
        showMessage('LicenseType', CURD_MESSAGE_STATUS.SS);
        $("#top-notifications").modal('show');
        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);

        $('.btnSave').attr('disabled', false);
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

            $('.btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            $("#grid").trigger('reloadGrid');
        });
});

$(".btnDepCancel").click(function () {
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



$("#txtCentralCleanLinenStore").change(function () {
    var TypeOfPlanner = $('#txtCentralCleanLinenStore').val();
    LinkClicked(TypeOfPlanner);
});

function SummaryData() {
   
    $('#myPleaseWait').modal('show');
    var ServiceId = 2;
    var WorkGroupId = 1;
    var TypeOfPlanner = $('#txtCentralCleanLinenStore').val();
    var Year = $("#SummaryYear option:selected").text();
    $.get("/api/CentralCleanLinen/Get/" + TypeOfPlanner)
        .done(function (result) {
            var getResult = JSON.parse(result);
            SummaryDetails = getResult.CentralCleanLinenStoreModelListData;
            if (SummaryDetails == null) {
                PushEmptyMessage();
                $("#paginationfooter").hide();
            }
            else {
                $("#paginationfooter").show();
                $("#SummaryResultId").empty();
                $.each(SummaryDetails, function (index, value) {
                    SummaryNewRow();
                    BindGridData(getResult);
                });

            }
            if ((SummaryDetails && SummaryDetails.length) > 0) {
                GridtotalRecords = SummaryDetails[0].TotalRecords;
                TotalPages = SummaryDetails[0].TotalPages;
                LastRecord = SummaryDetails[0].LastRecord;
                FirstRecord = SummaryDetails[0].FirstRecord;
                pageindex = SummaryDetails[0].PageIndex;
            }

            var mapIdproperty = ["LinenCode-LinenCode_", "LinenDescription-LinenDescription_", "StockLevel-StockLevel_", "StoreBalance-StoreBalance_", "ReorderQuantity-ReorderQuantity_", "Par1-Par1_", "Par2-Par2_"];
            /*"TotalRequirement-TotalRequirement_", "RepairQuantity-RepairQuantity_"*/
            var htmltext = SummaryGridHtml();//Inline Html
            var obj = { formId: "#form", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "CentralCleanLinenStoreModelListData", tableid: '#SummaryResultId', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/CentralCleanLinen/Get/" + TypeOfPlanner };

            CreateFooterPagination(obj);

            $('#myPleaseWait').modal('hide');
        })
        .fail(function (response) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            $('#errorMsg').css('visibility', 'visible');
        });
}

//************************************************ Getbyid bind data *************************

function BindGridData(getResult) {
    var ActionType = $('#ActionType').val();

    $("#SummaryResultId").empty();
    $.each(getResult.CentralCleanLinenStoreModelListData, function (index, value) {
        AddNewRowStkAdjustment();
        $('#txtCentralCleanLinenStore').val(getResult.StoreType);
        $("#LinenCode_" + index).val(value.LinenCode).prop("disabled", true);
        $("#LinenDescription_" + index).val(value.LinenDescription).prop("disabled", true);
        $("#StockLevel_" + index).val(value.StockLevel).prop("disabled", true);
        $("#Par2_" + index).val(value.Par2).prop("disabled", true);
        $("#Par1_" + index).val(value.Par1).prop("disabled", true);
        $("#StoreBalance_" + index).val(value.StoreBalance).prop("disabled", true);
        $("#ReorderQuantity_" + index).val(value.ReorderQuantity).prop("disabled", true);
        
        linkCliked1 = true;
        $(".content").scrollTop(0);
    });

    //************************************************ Grid Pagination *******************************************
    ckNewRowPaginationValidation = false;
    if ((getResult.UserAreaDetailsLocationGridList && getResult.UserAreaDetailsLocationGridList.length) > 0) {
        //StockAdjustmentId = result.UserAreaDetailsLocationGridList[0].StockAdjustmentId;
        GridtotalRecords = getResult.UserAreaDetailsLocationGridList[0].TotalRecords;
        TotalPages = getResult.UserAreaDetailsLocationGridList[0].TotalPages;
        LastRecord = getResult.UserAreaDetailsLocationGridList[0].LastRecord;
        FirstRecord = getResult.UserAreaDetailsLocationGridList[0].FirstRecord;
        pageindex = getResult.UserAreaDetailsLocationGridList[0].PageIndex;
        linkCliked1 = true;
        $(".content").scrollTop(0);
    }

    //************************************************ End *******************************************************
}

function AddNewRowStkAdjustment() {
    var inputpar = {
        inlineHTML: SummaryGridHtml(),
        IdPlaceholderused: "maxindexval",
        TargetId: "#SummaryResultId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    ckNewRowPaginationValidation = true;


}

function PushEmptyMessage() {
    $("#SummaryResultId").empty();
    var emptyrow = '<tr><td colspan=57 ><h3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;No records to display</h3></td></tr>'
    $("#SummaryResultId ").append(emptyrow);
}

function SummaryGridHtml() {

    return '<tr>' +
        '<td  width="10%" style="text-align: center;" title=""><div><input disabled id="LinenCode_maxindexval"  type="text" class="form-control" name="LinenCode" autocomplete="off"></div></td>' +
        '<td  width="20%" style="text-align: center;" title=""><div><input disabled id="LinenDescription_maxindexval" type="text" class="form-control" name="LinenDescription" autocomplete="off"></div></td>' +
        '<td  width="10%" style="text-align: center;" title=""><div><input disabled id="StockLevel_maxindexval"maxindex="150" type="text" class="form-control" name="StockLevel" autocomplete="off"></div></td>' +
        '<td  width="10%" style="text-align: center;" title=""><div><input disabled id="Par2_maxindexval"  maxindex="150" type="text" class="form-control" name="Par2" autocomplete="off"></div></td>' +
        '<td  width="10%" style="text-align: center;" title=""><div><input disabled id="Par1_maxindexval"  maxindex="150" type="text" class="form-control" name="Par1" autocomplete="off"></div></td>' +
        '<td  width="20%" style="text-align: center;" title=""><div><input disabled id="StoreBalance_maxindexval" maxindex="150" type="text" class="form-control" name="StoreBalance" autocomplete="off"></div></td>' +
        '<td  width="20%" style="text-align: center;" title=""><div><input disabled id="ReorderQuantity_maxindexval" maxindex="150" type="text" class="form-control" name="ReorderQuantity" autocomplete="off"></div></td>' 

    }

function SummaryNewRow() {

    var inputpar = {
        inlineHTML: SummaryGridHtml(),//Inline Html
        TargetId: "#SummaryResultId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
}

function Myfunction()
{
    txtCentralCleanLinenStore
}

function LinkClicked(id) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formotherplanner :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#primaryID').val(id);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/CentralCleanLinen/Get/" + primaryId)
            .done(function (result) {
                var htmlval = "";
                var getResult = JSON.parse(result);
                //$('#Service').val(getResult.ServiceId);
                $('#txtCentralCleanLinenStore').val(getResult.StoreType);
                // $('#WorkGroup').val(getResult.WorkGroup);
                $('#TypeOfPlanner').val(getResult.TypeOfPlanner);
                $('#hdnUserAreaId').val(getResult.UserAreaId);

                $('#primaryID').val(getResult.PlannerId);

                if (getResult != null && getResult.CentralCleanLinenStoreModelListData != null && getResult.CentralCleanLinenStoreModelListData.length > 0) {
                    BindGridData(getResult);
                }
                $('#myPleaseWait').modal('hide');
            })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsg').css('visibility', 'visible');
            });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}