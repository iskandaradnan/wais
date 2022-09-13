var ActionList = [];
var LOVlist = [];
var pageindex = 1, pagesize = 5;
var TotalPages=1, FirstRecord=0, LastRecord = 0;
var GridtotalRecords;
$("#showHideTable,#saveEditrefreshbtn,#Savebtn,#btnExportToEXCEL").hide();
$(document).ready(function () {
 //   formInputValidation("form","save");
    $("#selVariationYear").change(function () {
        var LoadData = GetYearMonth(this.value);

        $('#selVariationMonth').empty();
        $('#selVariationMonth').append('<option value="null">Select</option>');
        $.each(LoadData.MonthData, function (index, value) {
            $('#selVariationMonth').append('<option value="' + (index + 1) + '">' + value[index + 1] + '</option>');
        });

    });

    var LoadData = GetYearMonth();
    $.each(LoadData.MonthData, function (index, value) {
        $('#selVariationMonth').append('<option value="' + (index + 1) + '">' + value[index + 1] + '</option>');
    });
    $.each(LoadData.YearData, function (index, value) {
        $('#selVariationYear').append('<option value="' + value + '">' + value + '</option>');
    });
   
    $.get("/api/VVFApi/Load")
     .done(function (result) {
         var loadResult = result;

         
         LOVlist = loadResult;

         //$.each(loadResult.FMTimeMonth, function (index, value) {
         //    $('#selVariationMonth').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
         //});
         //$.each(loadResult.Yearlist, function (index, value) {
         //    $('#selVariationYear').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
         //});
         $.each(loadResult.VariationStatusValue, function (index, value) {
             $('#ddlVariationStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
         });
         $.each(loadResult.WorkFlowStatuslist, function (index, value) {
             $('#ddlWorkFlowStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
         });
         $.each(loadResult.ServiceData, function (index, value) {
             // if (value.LovId == 2)
             $('#ServiceId').append('<option selected value="' + value.LovId + '">' + value.FieldValue + '</option>');
         });
         ActionList = loadResult.ActionList;
         LoadLoV(loadResult.ActionList, 'Action');
        // LoadLoV(loadResult.VariationStatusValue, 'ddlVariationStatus', true);
         LoadLoV(loadResult.WorkFlowStatusList, 'ddlWorkFlowStatus', true);
         
        // $("#selVariationYear").val(2019);
         //$("#selVariationYear").val(result.CurrentYear);
        // $("#selVariationMonth").val(result.PreviousMonth);
     })
   .fail(function () {
       $('#myPleaseWait').modal('hide');
       $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
       $('#errorMsg').css('visibility', 'visible');
   });
})
function ToRemoveMonthRequired() {
    var year = $('#selVariationMonth').val();
    if(year != null || year !="")
    {
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $('#fetchbtn').attr('disabled', false);
        $("#selVariationMonth").parent().removeClass('has-error');
    }
}
function ToRemoveApprovalRequired() {
    var Approvalstatus = $('#ddlWorkFlowStatus').val();
    if (Approvalstatus != null || Approvalstatus != "") {
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $('#fetchbtn').attr('disabled', false);
        $("#ddlWorkFlowStatus").parent().removeClass('has-error');
    }
}





function FetchData()
{
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $("#VVFGrid").empty();
        
    var isFormValid = formInputValidation("form", "save");
     if (!isFormValid) {
         $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
         $('#errorMsg').css('visibility', 'visible');
         $('#fetchbtn').attr('disabled', false);
         //$('#btnEdit').attr('disabled', false);
         return false;
     }
     var getobj = { Month: $("#selVariationMonth").val(), Year: $("#selVariationYear").val(), VariationStatusId: $("#ddlVariationStatus").val(), WorkFlowStatusId: $("#ddlWorkFlowStatus").val(), ServiceId: $("#ServiceId").val(), PageIndex: 1, PageSize: 5 }


    var jqxhr = $.post("/api/VVFApi/Get", getobj, function (response) {
        var result = JSON.parse(response);

        if (result.ErrorMsg) {
            $("div.errormsgcenter").text(result.ErrorMsg);
            $('#errorMsg').css('visibility', 'visible');
        }
        else
            BuidDatagrid(result.VatiationDetailList);

        $('#myPleaseWait').modal('hide');
    },
 "json")
 .fail(function (response) {
     var errorMessage = "";
     //$('#myPleaseWait').modal('hide');
     //$("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
     //$('#errorMsg').css('visibility', 'visible');
     if (response.status == 400) {
         errorMessage = response.responseJSON;
     }
     else {
         errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
     }
     $("div.errormsgcenter").text(errorMessage);
     $('#errorMsg').css('visibility', 'visible');

     $('#btnSave').attr('disabled', false);
     $('#btnEdit').attr('disabled', false);
     $('#btnVerify').attr('disabled', false);
     $('#btnApprove').attr('disabled', false);
     $('#btnReject').attr('disabled', false);

     $('#myPleaseWait').modal('hide');
 });

}


function BuidDatagrid(list)
{
    $("#VVFGrid").empty();
    $("#fetchbtn").hide();
    $("#showHideTable,#Savebtn,#saveEditrefreshbtn,#btnExportToEXCEL").show();
    $("#selVariationYear,#selVariationMonth,#ServiceId,#ddlWorkFlowStatus,#ddlVariationStatus").prop("disabled", true);
    $(list).each(function (i, data) {
        var html = '<tr><td width="6%"><input type="hidden" disabled class="form-control" id="VariationId_' + i + '" value=""><input  disabled class="form-control" id="UserAreaName_' + i + '" value=""></td><td width="5%"><input disabled class="form-control" id="AssetNo_' + i + '" value=""></td><td width="7%"><input  disabled class="form-control" id="Manufacturer_' + i + '" value=""></td><td width="4%"><input  disabled class="form-control" id="Model_' + i + '" value=""></td><td width="5%"><input  disabled class="form-control" style="text-align:right" id="PurchaseCost_' + i + '" value=""></td><td width="5%"><input  disabled class="form-control" id="VariationStatus_' + i + '" value=""></td><td width="6%"><input  disabled class="form-control" id="StartServiceDate_' + i + '" value=""></td><td width="6%"><input  disabled class="form-control" id="WarrantyExpiryDate_' + i + '" value=""></td><td width="6%"><input disabled class="form-control" id="StopServiceDate_' + i + '" value=""></td><td width="8%"><input  disabled class="form-control" style="text-align:right" id="MaintenanceRateDW_' + i + '" value=""></td><td width="8%"><input  disabled class="form-control" style="text-align:right" id="MaintenanceRatePW_' + i + '" value=""></td><td width="9%"><input  disabled class="form-control commaSeperator"  style="text-align:right" id="MonthlyProposedFeeDW_' + i + '" value=""></td><td width="9%"><input  disabled class="form-control" style="text-align:right" id="MonthlyProposedFeePW_' + i + '" value=""></td><td width="5%"><input  disabled class="form-control" style="text-align:right" id="CountingDays_' + i + '" value=""></td><td width="6%">' +
            '<select class="form-control"  onchange="RemarksReq(' + i + ')" id="Action_' + i + '" value=""></select></td><td width="5%"><input  class="form-control" id="Remarks_' + i + '" value="" required></td><td width="204px"><input style="width: 204px;" class="form-control" onchange="getFileUploadDetails(this, ' + i + ')" type="file" name="file" id="Attachment_' + i + '" value="" required /></td></tr>';
        $("#VVFGrid").append(html);
        $("#VariationId_" + i).val(data.VariationId);
        $("#UserAreaName_" + i).val(data.UserAreaName);
        $('#UserAreaName_' + i).attr('title', data.UserAreaName);
        $("#EquipmentDescription_"+i).val(data.EquipmentDescription);
        $("#EquipmentCode_"+i).val(data.EquipmentCode);
        $("#AssetNo_" + i).val(data.AssetNo);
        $("#AssetNo_" + i).attr('title', data.AssetNo);
        $("#Manufacturer_" + i).val(data.Manufacturer);
        $("#Manufacturer_" + i).attr('title', data.Manufacturer);
        $("#Model_" + i).val(data.Model);
        $("#Model_" + i).attr('title', data.Model);
        $("#PurchaseCost_" + i).val(data.PurchaseCost);
        $("#PurchaseCost_" + i).attr('title', data.PurchaseCost);
        $("#VariationStatus_" + i).val(data.VariationStatus);
        $("#VariationStatus_" + i).attr('title', data.VariationStatus);
        $("#StartServiceDate_" + i).val(DateFormatter(data.StartServiceDate));
        $("#StartServiceDate_" + i).attr('title', DateFormatter(data.StartServiceDate));
        $("#WarrantyExpiryDate_"+i).val(DateFormatter(data.WarrantyExpiryDate));
        $("#WarrantyExpiryDate_" + i).attr('title', DateFormatter(data.WarrantyExpiryDate));
            $("#StopServiceDate_" + i).val(DateFormatter(data.StopServiceDate));
            $("#StopServiceDate_" + i).attr('title', DateFormatter(data.StopServiceDate));
            $("#MaintenanceRateDW_" + i).val(data.MaintenanceRateDW);
            $("#MaintenanceRateDW_" + i).attr('title', data.MaintenanceRateDW);
            $("#MaintenanceRatePW_" + i).val(data.MaintenanceRatePW);
            $("#MaintenanceRatePW_" + i).attr('title', data.MaintenanceRatePW);
            $("#MonthlyProposedFeeDW_" + i).val(addCommas(data.MonthlyProposedFeeDW));
            $("#MonthlyProposedFeeDW_" + i).attr('title', data.MonthlyProposedFeeDW);
            $("#MonthlyProposedFeePW_" + i).val(addCommas(data.MonthlyProposedFeePW));
            $("#MonthlyProposedFeePW_" + i).attr('title', data.MonthlyProposedFeePW);
            $("#CountingDays_" + i).val(data.CountingDays);
            $("#CountingDays_" + i).attr('title', data.CountingDays);
        LoadLoV(ActionList, "Action_" + i);
        $("#Action_" + i).val(371);
      
        $("#Remarks_" + i).val(data.Remarks);
        $("#Remarks_" + i).attr('title', data.Remarks);
        LoadLoV(ActionList, "Attachment_" + i);
        $("#Attachment_" + i).val();
        
        //$("#"+i).val(data.);
        //$("#"+i).val(data.);
        //$("#"+i).val(data.);
        //$("#"+i).val(data.);
        //$("#"+i).val(data.);
        //$("#"+i).val(data.);
        //$("#"+i).val(data.);
        GridtotalRecords = data.TotalRecords;
        TotalPages = data.TotalPages;
        LastRecord = data.LastRecord;
        FirstRecord = data.FirstRecord;
        pageindex = data.PageIndex;
       // pagesize = data.PageSize;
   

    });

    var mapIdproperty = ["VariationId-VariationId_", "UserAreaName-UserAreaName_", "EquipmentDescription-EquipmentDescription_", "EquipmentCode-EquipmentCode_", "AssetNo-AssetNo_", "Manufacturer-Manufacturer_", "Model-Model_", "PurchaseCost-PurchaseCost_", "VariationStatus-VariationStatus_", "StartServiceDate-StartServiceDate_-date", "WarrantyExpiryDate-WarrantyExpiryDate_-date", "StopServiceDate-StopServiceDate_-date", "MaintenanceRateDW-MaintenanceRateDW_", "MaintenanceRatePW-MaintenanceRatePW_", "MonthlyProposedFeeDW-MonthlyProposedFeeDW_", "MonthlyProposedFeePW-MonthlyProposedFeePW_", "CountingDays-CountingDays_", "Action-Action_", "Remarks-Remarks_", "Attachment-Attachment_"];
    var htmltext = '<tr><td width="6%"><input type="hidden" disabled class="form-control" id="VariationId_maxindexval" value=""><input disabled class="form-control" id="UserAreaName_maxindexval" value=""></td><td width="5%"><input  disabled class="form-control" id="AssetNo_maxindexval" value=""></td><td width="7%"><input  disabled class="form-control" id="Manufacturer_maxindexval" value=""></td><td width="4%"><input disabled class="form-control" id="Model_maxindexval" value=""></td><td width="5%"><input disabled class="form-control" style="text-align:right" id="PurchaseCost_maxindexval" value=""></td><td width="5%"><input disabled class="form-control" id="VariationStatus_maxindexval" value=""></td><td width="6%"><input disabled class="form-control" id="StartServiceDate_maxindexval" value=""></td><td width="6%"><input disabled class="form-control" id="WarrantyExpiryDate_maxindexval" value=""></td><td width="6%"><input disabled class="form-control" id="StopServiceDate_maxindexval" value=""></td><td width="8%"><input disabled class="form-control" style="text-align:right" id="MaintenanceRateDW_maxindexval" value=""></td><td width="8%"><input disabled class="form-control" style="text-align:right" id="MaintenanceRatePW_maxindexval" value=""></td><td width="9%"><input disabled class="form-control" style="text-align:right" id="MonthlyProposedFeeDW_maxindexval" value=""></td><td  width="9%"><input disabled class="form-control"  style="text-align:right" id="MonthlyProposedFeePW_maxindexval" value=""></td><td width="5%"><input disabled class="form-control" style="text-align:right" id="CountingDays_maxindexval" value=""></td><td width="6%"><select class="form-control" id="Action_maxindexval" value=""></select></td><td width="5%"><input class="form-control" id="Remarks_maxindexval" value=""></td><td width="5%"><input class="form-control" id="Attachment_maxindexval" type="file" name="file" value=""></td></tr>';

       
    var getobj = { Month: $("#selVariationMonth").val(), Year: $("#selVariationYear").val(), VariationStatusId: $("#ddlVariationStatus").val(), WorkFlowStatusId: $("#ddlWorkFlowStatus").val(), pageindex: pageindex, pagesize: pagesize }
    var obj = { formId: "#form", IsView: false, PageNumber: pageindex, flag: "VVFflag", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "VatiationDetailList", tableid: '#VVFGrid', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/VVFApi/Get", pageindex: pageindex, pagesize: pagesize, getobj: getobj, IsPostType: true };

    CreateFooterPagination(obj);
    formInputValidation("form");

}


function ChanceAction()
{
    var Actionval = $("#Action").val();
    $("#VVFGrid tr").each(function (i) {
        $("#Action_" + i).val(Actionval);
        if (Actionval == 372) // Reject 
        {
            $("#Remarks_" + i).attr("required", true);
        }
        else {
            $("#Remarks_" + i).removeAttr("required").parent().removeClass('has-error');
        }
    });

}
function RemarksReq(i) {    
    var action = $("#Action_" + i).val();
    if (action == 372) // Reject 
    {
        $("#Remarks_" + i).attr("required", true);
    }
    else {
        $("#Remarks_" + i).removeAttr("required").parent().removeClass('has-error');
    }
}
//function RemoveRequired(i) {
//    var Remarks= $("#Remarks_" + i).val();
//    if (Remarks == null || Remarks == 0 || Remarks == "" ||Remarks==undefined)
//    {
//        $("#Remarks_" + i).attr("required", true).parent().addClass('has-error');;

//    }
//    else {
//        $("#Remarks_" + i).attr("required", false).parent().removeClass('has-error');;

//    }
//}

function save()
{
    debugger;
    var isFormValid = formInputValidation("form", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#btnSave').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }

    var fileuploadLst = [];

    fileuploadLst = ListModelAttachment;

    var PostList = [];
    var Listlength = 0;
    $("#VVFGrid tr").each(function (i) {
        Listlength = ++i;

    });
    if (Listlength == 0)
    {
        return;
    }
    for (var i = 0 ; i <Listlength; i++)
    {
        var strDocuments = $("#Attachment_" + i).val()

        if (strDocuments == "")
        {
            bootbox.alert("Please Attach File!");
            return;
        }

        var postlist = {
            WorkFlowStatus: $("#ddlWorkFlowStatus").val(), VariationId: $("#VariationId_" + i).val(), CountingDays: $("#CountingDays_" + i).val()
        , Action: $("#Action_" + i).val(), Attachment: $("#Attachment_" + i).val(), Remarks: $("#Remarks_" + i).val(), MonthlyProposedFeePW: $("#MonthlyProposedFeePW_" + i).val(),
        MonthlyProposedFeeDW: $("#MonthlyProposedFeeDW_" + i).val(), MaintenanceRatePW: $("#MaintenanceRatePW_" + i).val(), MaintenanceRateDW: $("#MaintenanceRateDW_" + i).val()
        }
        postlist.MonthlyProposedFeeDW = postlist.MonthlyProposedFeeDW.split(',').join('');
        postlist.MonthlyProposedFeePW = postlist.MonthlyProposedFeePW.split(',').join('');
        PostList.push(postlist);
    }
    var postdata = { Month: $("#selVariationMonth").val(), Year: $("#selVariationYear").val(), WorkFlowStatusId: $("#ddlWorkFlowStatus").val(), VariationStatusId: $("#ddlVariationStatus").val(), ServiceId: $("#ServiceId").val(), VatiationDetailList: PostList, FileUploadList: fileuploadLst };

    
    var jqxhr = $.post("/api/VVFApi/Update", postdata, function (response) {
        var result = JSON.parse(response);
        //if (result.ErrorMsg)
        //{
        //    $("div.errormsgcenter").text(result.ErrorMsg);
        //    $('#errorMsg').css('visibility', 'visible');
        //}
        //else
        BuidDatagrid(result.VatiationDetailList);
        $('#Action').val(371);

        var numberOfRecords = $("#VVFGrid tr").length;
        if (numberOfRecords == 0) {
            $('#btnExportToEXCEL').attr('disabled', true);
        }

        $(".content").scrollTop(0);
        showMessage('VVF', CURD_MESSAGE_STATUS.SS);
        $('#myPleaseWait').modal('hide');
        $('#errorMsg').css('visibility', 'hidden');
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
    $('#btnEdit').attr('disabled', false);
    $('#btnVerify').attr('disabled', false);
    $('#btnApprove').attr('disabled', false);
    $('#btnReject').attr('disabled', false);

    $('#myPleaseWait').modal('hide');
});

}


$("#saveEditrefreshbtn").click(function ()
{
    location.reload(true);

});
//$("#btnExportToEXCEL").click(function () {
//    var VVFStatusval = $("#ddlVariationStatus").val();
//    //var VVFWFStatusval = $("#ddlWorkFlowStatus").val();
//    //var filterlist = [
//    //        { field: "Year", op: "eq", data: $('#selVariationYear').val() },
//    //        { field: "Month", op: "eq", data: $('#selVariationMonth').val() }
//    //       //, { field: "VariationWFStatusId", op: "eq", data: $('#ddlWorkFlowStatus').val() }
//    //];
//    //if (VVFStatusval != "null")
//    //{
//    //    filterlist.push({ field: "VariationStatusId", op: "eq", data: $('#ddlVariationStatus').val() })
//    //}
//    //if (VVFWFStatusval != "") {
//    //    filterlist.push({ field: "VariationWFStatusId", op: "eq", data: $('#ddlWorkFlowStatus').val() })
//    //}

//    //function Export(exportType) {
   

//    var filterlist = [
//            { field: "Year", op: "eq", data: $('#selVariationYear').val() },
//            { field: "Month", op: "eq", data: $('#selVariationMonth').val() }

//    ];
//    if ($("#ddlVariationStatus").val()) {
//        filterlist.push({ field: "VariationStatusId", op: "eq", data: $('#ddlVariationStatus').val() })
//    }
//    var id = 0;
//    var grid = $('#grid');
//    var filters = JSON.stringify({
//        groupop: "and",
//        rules: filterlist
//    });
//    var sortColumnName = "ModifiedDate";
//    var sortOrder = "desc";
//    var mymodel = $("#grid").getGridParam('colModel')

//    var screenTitle = $("#menu").find("li.active:last").text();
//    var $downloadForm = $("<form method='POST'>")
//         .attr("action", "/api/common/Export")
//         .append($("<input name='filters' type='text'>").val(filters))
//         .append($("<input name='sortOrder' type='text'>").val(sortOrder))
//        .append($("<input name='sortColumnName' type='text'>").val(sortColumnName))
//        .append($("<input name='screenName' type='text'>").val("Verification_Of_Variations"))
//          .append($("<input name='spName' type='text'>").val("uspFM_VmVariationTxnVVF_Export"))
//         .append($("<input name='exportType' type='text'>").val("Excel"));

//    $("body").append($downloadForm);
//    var status = $downloadForm.submit();
//    $downloadForm.remove();

//    //}

   
//});



$('#btnExportToEXCEL').click(function () {
    VVFExportBind();
});

function VVFExportBind() {
    var VVFStatusval = $("#ddlVariationStatus").val();
    if (VVFStatusval == "null" || VVFStatusval == null) {
        VVFStatusval = "";
    }
    else {
        VVFStatusval = $('#ddlVariationStatus option:selected').text();
    }
    var exportType = "Excel";
    var sortOrder = "asc";
    var screenTitle = $("#menu").find("li.active:last").text();

    var $downloadForm = $("<form method='POST'>")
      .attr("action", "/api/common/Export")
       .append($("<input name='filters' type='text'>").val(""))
       .append($("<input name='sortOrder' type='text'>").val(""))
        .append($("<input name='sortColumnName' type='text'>").val(""))
       .append($("<input name='screenName' type='text'>").val("Verification_Of_Variations"))
       .append($("<input name='exportType' type='text'>").val(exportType))
       .append($("<input name='Year' type='text'>").val($('#selVariationYear').val()))
       .append($("<input name='Month' type='text'>").val($('#selVariationMonth').val()))
       .append($("<input name='VariationStatusValue' type='text'>").val(VVFStatusval))
       .append($("<input name='spName' type='text'>").val(""))

    $("body").append($downloadForm);
    var status = $downloadForm.submit();
    $downloadForm.remove();
}