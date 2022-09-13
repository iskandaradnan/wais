//********************************************* Pagination Grid ********************************************

var pageindex = 1, pagesize = 5;
var TotalPages = 1

//********************************************************************************

$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    
//******************************** Load DropDown ***************************************

    $.get("/api/MonthlyStockRegister/Load")
   .done(function (result) {
       var loadResult = JSON.parse(result);
       $("#jQGridCollapse1").click();
       var date = new Date();
       var month = date.getMonth();
       var currentMonth = month + 1;
       var hidemonth = currentMonth - 1;

       $.each(loadResult.SparePartTypedata, function (index, value) {
           $('#monthstkSPtype').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
       });

       $.each(loadResult.Years, function (index, value) {
           $('#monthstkyear').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
       });
       $('#monthstkyear').val(loadResult.CurrentYear);
       
       $.each(loadResult.MonthListTypedata, function (index, value) {           
           $('#monthstkmonth').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
       });       
       $('#monthstkmonth option[value="' + currentMonth + '"]').prop('selected', true);      
       $('#monthstkmonth option:gt(' + hidemonth + ')').prop('disabled', true);

      
       $('#monthstkyear').on('change', function () {
           var val = $('#monthstkyear option:selected').val();           
           if (val != loadResult.CurrentYear) {
               $('#monthstkmonth option:gt(' + hidemonth + ')').prop('disabled', false);
           }
           else {
               $('#monthstkmonth option[value="' + currentMonth + '"]').prop('selected', true);
               $('#monthstkmonth option:gt(' + hidemonth + ')').prop('disabled', true);
           }           
           
       });   

   })
   .fail(function (response) {
       $('#myPleaseWait').modal('hide');
       $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
       $('#errorMsg').css('visibility', 'visible');
   });
    

//******************************************** Getby ID ****************************************************

    $('#monthstkFetch').click(function () {

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var spareparttype = $('#monthstkSPtype').val();
        if (spareparttype == "null" || spareparttype == null) {            
            spareparttype = "";
        }
        else {
            spareparttype = $('#monthstkSPtype option:selected').text();
        }

        var objs = {
            Year: $('#monthstkyear').val(),
            Month: $('#monthstkmonth').val(),
            PartNo: $('#monthstkpartno').val(),
            PartDescription: $('#monthstkPdesc').val(),
            ItemCode: $('#monthstkIcode').val(),
            ItemDescription: $('#monthstkIdesc').val(),
            SparePartTypeName: spareparttype,
            PageSize: $('#selPageSize').val(),
            PageIndex: pageindex,
            PageSize:pagesize
        }

        var stkYear = $('#monthstkyear').val();
        var stkMonth = $('#monthstkmonth').val();

        if (stkYear != "null" && stkYear != "0" && stkMonth != "null" && stkMonth != "0") {

            MonthlyStkBind(objs);

        }
        else {
            $('#MonthlyStockRegisterTbl').empty();
        }
    }); 

   
//*********************************************** Export *********************************************** no need

    $('#btnMstkExport11').click(function () {

        var spareparttype = $('#monthstkSPtype').val();
        if (spareparttype == "null" || spareparttype == null) {
            spareparttype = "";
        }
        else {
            spareparttype = $('#monthstkSPtype option:selected').text();
        }

        var filterlist = [
                { field: "Year", op: "eq", data: $('#monthstkyear').val() },
                { field: "Month", op: "eq", data: $('#monthstkmonth').val() }
               
        ];
        if ($("#monthstkpartno").val()) {
            filterlist.push({ field: "PartNo", op: "eq", data: $('#monthstkpartno').val() })
        }
        else if ($("#monthstkPdesc").val()) {
            filterlist.push({ field: "PartDescription", op: "eq", data: $('#monthstkPdesc').val() })
        }
        else if ($("#monthstkIcode").val()) {
            filterlist.push({ field: "ItemCode", op: "eq", data: $('#monthstkIcode').val() })
        }
        else if ($("#monthstkIdesc").val()) {
            filterlist.push({ field: "ItemDescription", op: "eq", data: $('#monthstkIdesc').val() })
        }
        else if ($("#monthstkSPtype").val()) {
            filterlist.push({ field: "SparePartTypeName", op: "eq", data: spareparttype })
        }        

        //function Export(exportType) {
        var id = 0;
        var grid = $('#grid');
        var filters = JSON.stringify({
            groupop: "and",
            rules: filterlist
        });
        var sortColumnName = "ModifiedDate";
        var sortOrder = "desc";
        var mymodel = $("#grid").getGridParam('colModel')

        var screenTitle = $("#menu").find("li.active:last").text();
        var $downloadForm = $("<form method='POST'>")
             .attr("action", "/api/common/Export")
             .append($("<input name='filters' type='text'>").val(filters))
             .append($("<input name='sortOrder' type='text'>").val(sortOrder))
             .append($("<input name='sortColumnName' type='text'>").val(sortColumnName))
             .append($("<input name='screenName' type='text'>").val("Monthly_Stock_Register"))
             .append($("<input name='spName' type='text'>").val("uspFM_EngStockMonthlyRegisterTxn_Export"))
             .append($("<input name='exportType' type='text'>").val("Excel"));

        $("body").append($downloadForm);
        var status = $downloadForm.submit();
        $downloadForm.remove();
    });    

    $('#btnMstkExport').click(function () {
        MonthltStkExportBind();
    });
});

//************************************************** Fetch *************************************************** No Need

function FetchFacilityCodeData(event) {
    var MonthlyStockRegFtycodeFetchObj = {
        SearchColumn: 'monthstkFcode-FacilityCode',//Id of Fetch field
        ResultColumns: ["StockAdjustmentId-Primary Key", 'monthstkFcode-FacilityCode'],//Columns to be displayed
        FieldsToBeFilled: ["FacilityCode-monthstkFcode", "FacilityName-monthstkFname"]//id of element - the model property
    };
    var apiUrlForFetch = "/api/Fetch/FetchStockAdjustmentdetails";
    $('#FacilityCode').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('FtycodeFetch', MonthlyStockRegFtycodeFetchObj, apiUrlForFetch, "UlFetch", event, 1);//1 -- pageIndex
    });
}

function FetchPartNodataMonthlyStockReg(event) {
    var MonthlyStockRegFetchObj = {
        SearchColumn: 'monthstkpartno-PartNo',//Id of Fetch field
        ResultColumns: ["SparePartsId" + "-Primary Key", 'PartNo-monthstkpartno'],//Columns to be displayed
        FieldsToBeFilled: ["monthstkpartno-PartNo", "monthstkPdesc-PartDescription", "monthstkIcode-ItemCode", "monthstkIdesc-ItemDescription", "monthstkSPtype-SparePartTypeName"]//id of element - the model property
    };
    DisplayFetchResult('PartnumberFetch', MonthlyStockRegFetchObj, "/api/Fetch/StockAdjustmentFetchModel", "UlFetch", event, 1);
}

//***************************************************** End **************************************************************

function AddNewRowMonthlyStockRegister() {

    var inputpar = {
        inlineHTML: BindNewRowHTML(),       
        IdPlaceholderused: "maxindexval",
        TargetId: "#MonthlyStockRegisterTbl",
        TargetElement: ["tr"]
    }   
    AddNewRowToDataGrid(inputpar);

    $("input").keypress(function (e) {
        if (e.which === 32 && !this.value.length)
            e.preventDefault();
    });
}

function BindNewRowHTML() {
    return ' <tr> <input type="hidden" id="hdnGmonthstkDId_maxindexval"> <td width="8%" style="text-align: center;"> <div> <input type="text" class="form-control" id="GmonthstkFacilityName_maxindexval" disabled> </div></td><td width="7%" style="text-align: center;"> <div> <input type="text" class="form-control" id="GmonthstkFacilityCode_maxindexval" disabled> </div></td><td width="8%" style="text-align: center;"> <div> <input type="hidden" id="hdnGmonthstkPNo_maxindexval"> <input type="text" class="form-control" id="GmonthstkPNo_maxindexval" disabled> </div></td><td width="10%" style="text-align: center;"> <div> <input type="text" class="form-control" id="GmonthstkPDesc_maxindexval" disabled> </div></td><td width="8%" style="text-align: center;"> <div> <input type="text" class="form-control" id="GmonthstkICode_maxindexval" disabled> </div></td><td width="10%" style="text-align: center;"> <div> <input type="text" class="form-control" id="GmonthstkIDesc_maxindexval" disabled> </div></td><td width="6%" style="text-align: center;"> <div> <input type="text" class="form-control" id="GmonthstkUOM_maxindexval" disabled> </div></td><td width="7%" style="text-align: center;"> <div> <input type="text" style="text-align: right;" class="form-control" id="GmonthstkMinLevel_maxindexval" disabled> </div></td><td width="9%" style="text-align: center;"> <div> <input type="text" class="form-control" id="GmonthstkSPType_maxindexval" disabled> </div></td><td width="5%" style="text-align: center;"> <div> <input type="text" class="form-control" id="GmonthstkBinNo_maxindexval" disabled> </div></td><td width="13%" style="text-align: center;"> <div class="col-sm-8"> <input type="text" style="text-align: right;" class="form-control" id="GmonthstkCurrentQty_maxindexval" disabled> </div><div class="col-sm-1"> <input type="hidden" id="hdnModalQty_maxindexval"/> <div> <a data-toggle="modal" class="btn btn-sm btn-primary btn-info btn-lg" onclick="getModaldetails(maxindexval)" title="Real Time History" tabindex="0" data-target="#myModalquantity"> <span class="glyphicon glyphicon-modal-window"></span> </a> </div></div></td><td width="9%" style="text-align: center;"> <div> <input type="text" style="text-align: right;" class="form-control" id="GmonthstkClosingQty_maxindexval" disabled> </div></td></tr>'
}

function AddNewRowMonthlyStockRegisterModal(){
    var inputpar = {
        inlineHTML: BindNewRowHTMLModal(),

    IdPlaceholderused: "maxindexval",
    TargetId: "#MonthlyStockRegisterModalTbl",
    TargetElement: ["tr"]

}
AddNewRowToDataGrid(inputpar);
}

function BindNewRowHTMLModal() {
    return ' <tr> <td width="12%" style="text-align: center;"> <div> <div> <input type="text" class="form-control" id="ModalmonthstkPNo_maxindexval" disabled> </div></div></td><td width="17%" style="text-align: center;"> <div> <input type="text" class="form-control" id="ModalmonthstkPDesc_maxindexval" disabled> </div></td><td width="13%" style="text-align: right;"> <div> <input type="text" class="form-control text-right" id="ModalmonthstkQty_maxindexval" disabled> </div></td><td width="18%" style="text-align: right;"> <div> <input type="text" class="form-control text-right" id="ModalmonthstkPurchaseCst_maxindexval" disabled> </div></td><td width="15%" style="text-align: right;"> <div> <input type="text" class="form-control text-right" id="ModalmonthstkCost_maxindexval" disabled> </div></td><td width="12%" style="text-align: center;"> <div> <input type="text" class="form-control" id="ModalmonthstkInvoiceno_maxindexval" disabled> </div></td><td width="13%" style="text-align: center;"> <div> <input type="text" class="form-control" id="ModalmonthstkVendorname_maxindexval" disabled> </div></td></tr> '
}

//******************************************** Getby ModalID ****************************************************

function getModaldetails(index) {

    $("div.errormsgcenter").text("");
    $('#errorMsg1').css('visibility', 'hidden');

    var _index;
    $('#MonthlyStockRegisterTbl tr').each(function () {
        _index = $(this).index();
    });

    var SparePartsId = $('#hdnGmonthstkPNo_' + index).val();
    var _MStkRegisterWO = {
        SparePartsId: $('#hdnGmonthstkPNo_' + index).val(),
        BinNo: $('#GmonthstkBinNo_' + index).val(),
        Year: $('#monthstkyear').val(),
        Month: $('#monthstkmonth').val(),
        }
   
    var stkYear = $('#monthstkyear').val();
    var stkMonth = $('#monthstkmonth').val();

    if (stkYear != "null" && stkYear != "0" && stkMonth != "null" && stkMonth != "0") {
        var jqxhr = $.post("/api/MonthlyStockRegister/GetModal", _MStkRegisterWO, function (response) {
            var result = JSON.parse(response);

            $("#MonthlyStockRegisterModalTbl").empty();
            $.each(result.MonthlyStockRegisterModalData, function (index, value) {
                AddNewRowMonthlyStockRegisterModal();
                $("#ModalmonthstkPNo_" + index).val(result.MonthlyStockRegisterModalData[index].PartNo).attr('title', result.MonthlyStockRegisterModalData[index].PartNo);
                $("#ModalmonthstkPDesc_" + index).val(result.MonthlyStockRegisterModalData[index].PartDescription).attr('title', result.MonthlyStockRegisterModalData[index].PartDescription);
                $("#ModalmonthstkQty_" + index).val(result.MonthlyStockRegisterModalData[index].CurrentQuantity).attr('title', result.MonthlyStockRegisterModalData[index].CurrentQuantity);
                $("#ModalmonthstkCost_" + index).val(result.MonthlyStockRegisterModalData[index].Cost).attr('title', result.MonthlyStockRegisterModalData[index].Cost);
                $("#ModalmonthstkPurchaseCst_" + index).val(result.MonthlyStockRegisterModalData[index].PurchaseCost).attr('title', result.MonthlyStockRegisterModalData[index].PurchaseCost);
                $("#ModalmonthstkInvoiceno_" + index).val(result.MonthlyStockRegisterModalData[index].InvoiceNo).attr('title', result.MonthlyStockRegisterModalData[index].InvoiceNo);
                $("#ModalmonthstkVendorname_" + index).val(result.MonthlyStockRegisterModalData[index].VendorName).attr('title', result.MonthlyStockRegisterModalData[index].VendorName);
            });           

            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text("");
            $('#errorMsg1').css('visibility', 'hidden');
        })
         .fail(function (response) {
             var errorMessage = "";
             if (response.status == 400) {
                 errorMessage = response.responseJSON;
             }
             else {
                 errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
             }
             $("div.errormsgcenter").text(errorMessage);
             $('#errorMsg1').css('visibility', 'visible');
             $('#myPleaseWait').modal('hide');           
             
         });
    }
    else {
        $('#MonthlyStockRegisterTbl').empty();
    }
   
}

function PushEmptyMessage() {   
    $("#MonthlyStockRegisterTbl").empty();
    var emptyrow = '<tr><td width="100%"><h5 class="text-center">No records to display</h5></td></tr>'
    $('#divPagination').hide();
    $("#MonthlyStockRegisterTbl ").append(emptyrow);
}

//******************************************* GetBy Id Bind **************************************

function MonthlyStkBind(obj) {
    var jqxhr = $.post("/api/MonthlyStockRegister/Get", obj, function (response) {
        var result = JSON.parse(response);
        var monthstkList = result.MonthlyStockRegisterListData;
        if (monthstkList == null || monthstkList == 0) {
            $("#btnMstkExport").prop("disabled", true);
            PushEmptyMessage();            
        }
        else {
            $("#btnMstkExport").prop("disabled",false);
            $("#MonthlyStockRegisterTbl").empty();
            $.each(result.MonthlyStockRegisterListData, function (index, value) {
                $('#divPagination').show();
                AddNewRowMonthlyStockRegister();
                $('#hdnGmonthstkPNo_' + index).val(result.MonthlyStockRegisterListData[index].SparePartsId).prop("disabled", "disabled");
                $("#GmonthstkFacilityName_" + index).val(result.MonthlyStockRegisterListData[index].FacilityName).attr('title', result.MonthlyStockRegisterListData[index].FacilityName);
                $("#GmonthstkFacilityCode_" + index).val(result.MonthlyStockRegisterListData[index].FacilityCode).attr('title', result.MonthlyStockRegisterListData[index].FacilityCode);
                $("#GmonthstkPNo_" + index).val(result.MonthlyStockRegisterListData[index].PartNo).attr('title', result.MonthlyStockRegisterListData[index].PartNo);
                $("#GmonthstkPDesc_" + index).val(result.MonthlyStockRegisterListData[index].PartDescription).attr('title', result.MonthlyStockRegisterListData[index].PartDescription);
                $("#GmonthstkICode_" + index).val(result.MonthlyStockRegisterListData[index].ItemCode).attr('title', result.MonthlyStockRegisterListData[index].ItemCode);
                $("#GmonthstkIDesc_" + index).val(result.MonthlyStockRegisterListData[index].ItemDescription).attr('title', result.MonthlyStockRegisterListData[index].ItemDescription);
                $("#GmonthstkUOM_" + index).val(result.MonthlyStockRegisterListData[index].UOM).attr('title', result.MonthlyStockRegisterListData[index].UOM);
                $("#GmonthstkMinLevel_" + index).val(result.MonthlyStockRegisterListData[index].MinimumLevel).attr('title', result.MonthlyStockRegisterListData[index].MinimumLevel);
                $("#GmonthstkSPType_" + index).val(result.MonthlyStockRegisterListData[index].SparePartTypeName).attr('title', result.MonthlyStockRegisterListData[index].SparePartTypeName);
                $("#GmonthstkBinNo_" + index).val(result.MonthlyStockRegisterListData[index].BinNo).attr('title', result.MonthlyStockRegisterListData[index].BinNo);
                $("#GmonthstkCurrentQty_" + index).val(result.MonthlyStockRegisterListData[index].CurrentQuantity).attr('title', result.MonthlyStockRegisterListData[index].CurrentQuantity);
                $("#GmonthstkClosingQty_" + index).val(result.MonthlyStockRegisterListData[index].ClosingMonthQuantity).attr('title', result.MonthlyStockRegisterListData[index].ClosingMonthQuantity);
            });

            $('#divPagination').html(null);
            $('#divPagination').html(paginationString);
            SetPaginationValues(result);

            $('#myPleaseWait').modal('hide');            
            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');
        }

    })
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
         $('#myPleaseWait').modal('hide');         
         
     });
}


function MonthltStkExportBind() {

    var spareparttype = $('#monthstkSPtype').val();
    if (spareparttype == "null" || spareparttype == null) {
        spareparttype = "";
    }
    else {
        spareparttype = $('#monthstkSPtype option:selected').text();
    }

    var exportType = "Excel";
    var sortOrder = "asc";
    var screenTitle = $("#menu").find("li.active:last").text();

    var $downloadForm = $("<form method='POST'>")
      .attr("action", "/api/common/Export")
       .append($("<input name='filters' type='text'>").val(""))
       .append($("<input name='sortOrder' type='text'>").val(""))
        .append($("<input name='sortColumnName' type='text'>").val(""))
       .append($("<input name='screenName' type='text'>").val("Monthly_Stock_Register"))
       .append($("<input name='exportType' type='text'>").val(exportType))
       .append($("<input name='Year' type='text'>").val($('#monthstkyear').val()))
       .append($("<input name='Month' type='text'>").val($('#monthstkmonth').val()))
       .append($("<input name='PartNo' type='text'>").val($('#monthstkpartno').val()))
       .append($("<input name='PartDescription' type='text'>").val($('#monthstkPdesc').val()))
        .append($("<input name='ItemCode' type='text'>").val($('#monthstkIcode').val()))
       .append($("<input name='ItemDescription' type='text'>").val($('#monthstkIdesc').val()))
       .append($("<input name='SparePartType' type='text'>").val(spareparttype))
       .append($("<input name='spName' type='text'>").val(""))

    $("body").append($downloadForm);
    var status = $downloadForm.submit();
    $downloadForm.remove();
}

//*************************************** Pagination *******************************************

function SetPaginationValues(result) {
    var PageIndex = 0;
    var TotalRecords = 0;
    var FirstRecord = 0;
    var LastRecord = 0;
    var LastPageIndex = 0;

    var firstObject = $.grep(result.MonthlyStockRegisterListData, function (value0, index0) {
        return index0 == 0;
    });
    PageIndex = firstObject[0].PageIndex;
    PageSize = firstObject[0].PageSize;
    TotalRecords = firstObject[0].TotalRecords;
    FirstRecord = firstObject[0].FirstRecord;
    LastRecord = firstObject[0].LastRecord;
    LastPageIndex = firstObject[0].LastPageIndex;

    if (PageIndex == 1) {
        //$('#btnPreviousPage').removeClass('pagerEnabled');
        //$('#btnPreviousPage').addClass('pagerDisabled');
        //$('#btnFirstPage').removeClass('pagerEnabled');
        //$('#btnFirstPage').addClass('pagerDisabled');

        $('#btnPreviousPage').show();
        $('#btnPreviousPage').hide();
        $('#btnFirstPage').show();
        $('#btnFirstPage').hide();        
    }
    else {
        //$('#btnPreviousPage').removeClass('pagerDisabled');
        //$('#btnPreviousPage').addClass('pagerEnabled');
        //$('#btnFirstPage').removeClass('pagerDisabled');
        //$('#btnFirstPage').addClass('pagerEnabled');

        $('#btnPreviousPage').hide();
        $('#btnPreviousPage').show();
        $('#btnFirstPage').hide();
        $('#btnFirstPage').show();        
    }
    if (PageIndex == LastPageIndex) {
        //$('#btnNextPage').removeClass('pagerEnabled');
        //$('#btnNextPage').addClass('pagerDisabled');
        //$('#btnLastPage').removeClass('pagerEnabled');
        //$('#btnLastPage').addClass('pagerDisabled');

        $('#btnNextPage').show();
        $('#btnNextPage').hide();
        $('#btnLastPage').show();
        $('#btnLastPage').hide();        
    }
    else {
        //$('#btnNextPage').removeClass('pagerDisabled');
        //$('#btnNextPage').addClass('pagerEnabled');
        //$('#btnLastPage').removeClass('pagerDisabled');
        //$('#btnLastPage').addClass('pagerEnabled');

        $('#btnNextPage').hide();
        $('#btnNextPage').show();
        $('#btnLastPage').hide();
        $('#btnLastPage').show();      
    }

    $('#spnTotalRecords').text(TotalRecords);
    $('#spnFirstRecord').text(FirstRecord);
    $('#spnLastRecord').text(LastRecord);
    $('#spnTotalPages').text(LastPageIndex);
    $('#txtPageIndex').val(PageIndex);
    $('#hdnPageIndex').val(PageIndex);
    $('#selPageSize').val(PageSize);
    AttachPaginationEvents(LastPageIndex);
}

function AttachPaginationEvents(LastPageIndex) {
    $('#btnPreviousPage').unbind("click");
    $('#btnNextPage').unbind("click");
    $('#btnFirstPage').unbind("click");
    $('#btnLastPage').unbind("click");

    $('#btnPreviousPage, #btnNextPage, #btnFirstPage, #btnLastPage').click(function () {
        var id = $(this).attr('id');

        var currentPageIndex = parseInt($('#hdnPageIndex').val());
        if (id == "btnPreviousPage") {
            currentPageIndex -= 1;
        }
        else if (id == "btnNextPage") {
            currentPageIndex += 1;
        }
        else if (id == "btnFirstPage") {
            currentPageIndex = 1;
        }
        else if (id == "btnLastPage") {
            currentPageIndex = LastPageIndex;
        }
        PopulatePopupData(currentPageIndex);
    });

    $('#txtPageIndex').on("keypress", function (e) {
        if (e.keyCode == 13) {
            var pageindex1 = $('#txtPageIndex').val();
            if (pageindex1 == null || pageindex1 == '' || isNaN(pageindex1)) {
                bootbox.alert('Please enter valid page number.');
                $('#txtPageIndex').val($('#hdnPageIndex').val());
                return false;
            } else {
                pageindex1 = parseInt(pageindex1);
                if (pageindex1 > LastPageIndex) {
                    bootbox.alert('Please enter valid page number.');
                    $('#txtPageIndex').val($('#hdnPageIndex').val());
                    return false;
                } else {
                    PopulatePopupData(pageindex1);
                }
            }
        }
    });

    $('#selPageSize').on('change', function () {
        PopulatePopupData(1);
    });
}

function PopulatePopupData(pageIndex) {

    var spareparttype = $('#monthstkSPtype').val();
    if (spareparttype == "null" || spareparttype == null) {
        spareparttype = "";
    }
    else {
        spareparttype = $('#monthstkSPtype option:selected').text();
    }

    var objs = {
        Year: $('#monthstkyear').val(),
        Month: $('#monthstkmonth').val(),
        PartNo: $('#monthstkpartno').val(),
        PartDescription: $('#monthstkPdesc').val(),
        ItemCode: $('#monthstkIcode').val(),
        ItemDescription: $('#monthstkIdesc').val(),
        SparePartTypeName: spareparttype,
        PageSize: $('#selPageSize').val(),
        PageIndex: pageIndex
    }

    var stkYear = $('#monthstkyear').val();
    var stkMonth = $('#monthstkmonth').val();

    if (stkYear != "null" && stkYear != "0" && stkMonth != "null" && stkMonth != "0") {

        MonthlyStkBind(objs);

    }
    else {
        $('#MonthlyStockRegisterTbl').empty();
    }
}

