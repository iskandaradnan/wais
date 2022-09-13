﻿var GlobalController = null;
$(function () {
    var controllerName = '';
    var qs = window.location.href;
    var len = [];
    len = qs.split("/");
    controllerName = len[len.length - 1];
    GlobalController = controllerName;
    genarateGrid(controllerName);
});

function genarateGrid(controllerName) {
    var isFromSave = false;
    var gridClicked = false;
    var SearchBoxSelectFilterData = {
        WorkOrderPriority: "Critical:Critical;Normal:Normal;".replace(/[,;]$/, '').toString(),
        WorkOrderCategory: "Breakdown:Breakdown;Corrective:Corrective;Insurance:Insurance;Others:Others;RW work:RW work;Emergency:Emergency,Proactive:Proactive;".replace(/[,;]$/, '').toString()
    }
    var grid = $("#grid"),
    prmSearch = { multipleSearch: true, overlay: false };



    grid.jqGrid({
        url: "/api/ScheduledWorkOrder/GetAll",
        datatype: 'json',
        mtype: 'Get',
        ajaxGridOptions: { contentType: 'application/json; charset=utf-8' },
        colNames: ['Id', 'Work Order No.', 'Work Order Date / Time', 'Response Date / Time', 'Asset No.', 'Department', 'Work Order Category', 'Work Order Priority', 'Work Order Status', 'Count Of Days', 'Response Duration', 'HandOver Date / Time','Work Group'],
        colModel: [
            { key: true, hidden: true, name: 'WorkOrderId', width: '0%' },
            { key: false, search: true, name: 'MaintenanceWorkNo', width: '16%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            //{ key: false, search: true, name: 'MaintenanceWorkDateTime', width: '10%', formatoptions: { srcformat: "d-M-Y", newformat: "d-M-Y" }, formatter: "date", resizable: false, searchoptions: { dataInit: function (elem) { $(elem).datetimepicker({ timepicker: true, format: 'd-M-Y', step: 15, scrollInput: false }) }, sopt: ['eq', 'ne', 'lt', 'gt', 'le', 'ge'] } },
            { key: false, search: true, name: 'MaintenanceWorkDateTime', width: '10%', formatoptions: { srcformat: "d-M-Y H:i", newformat: "d-M-Y" }, formatter: "date", resizable: false, searchoptions: { dataInit: function (elem) { $(elem).datetimepicker({ timepicker: false, format: 'd-M-Y', step: 15, scrollInput: false }) }, sopt: ['eq', 'ne', 'lt', 'gt', 'le', 'ge'] } },
            { key: false, search: true, name: 'AssessmentResponsedate', width: '12%', formatoptions: { srcformat: "d-M-Y H:i", newformat: "d-M-Y H:i" }, formatter: "date", resizable: false, searchoptions: { dataInit: function (elem) { $(elem).datetimepicker({ timepicker: true, format: 'd-M-Y H:i', step: 15, scrollInput: false }) }, sopt: ['eq', 'ne', 'lt', 'gt', 'le', 'ge'] } },
            { key: false, search: true, name: 'AssetNo', width: '10%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
             //{ key: false, search: true, name: 'UserArea', width: '10%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'Department', width: '10%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            //{ key: false, search: true, name: 'WorkOrderCategoryGrid', width: '12%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'WorkOrderCategoryGrid', stype: "select", width: '10%', formatter: TypeCat, searchoptions: { sopt: ['eq', 'ne'], value: SearchBoxSelectFilterData.WorkOrderCategory, defaultValue: "Breakdown" } },
            //{ key: false, search: true, name: 'WorkGroupCode', width: '10%', searchoptions: { sopt: ['cn', 'eq'] } },
            //{ key: false, search: true, name: 'TargetDateTime', width: '9%', formatoptions: { srcformat: "d-M-Y H:i", newformat: "d-M-Y H:i" }, formatter: "date", resizable: false, searchoptions: { dataInit: function (elem) { $(elem).datetimepicker({ timepicker: false, format: 'd-M-Y', step: 15, scrollInput: false }) }, sopt: ['eq', 'ne', 'lt', 'gt', 'le', 'ge'] } },
           // { key: false, search: true, name: 'WorkOrderPriorityGrid', width: '12%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'WorkOrderPriorityGrid', stype: "select", width: '12%', formatter: StatusCat, searchoptions: { sopt: ['eq', 'ne'], value: SearchBoxSelectFilterData.WorkOrderPriority, defaultValue: "Critical" } },
            { key: false, search: true, name: 'WorkOrderStatusGrid', width: '12%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'CountingDays', width: '8%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
          //  { key: false, search: true, name: 'ResponseDateTime', align: 'right', width: '9%', searchoptions: { srcformat: "d-M-Y H:i", newformat: "d-M-Y H:i" }, formatter: "date", resizable: false, searchoptions: { dataInit: function (elem) { $(elem).datetimepicker({ timepicker: true, format: 'd-M-Y H:i', step: 15, scrollInput: false }) }, sopt: ['eq', 'ne', 'lt', 'gt', 'le', 'ge'] } },
            { key: false, search: true, name: 'ResponseDuration', align: 'right', width: '9%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'HandOverDate', align: 'right', width: '9%', formatoptions: { srcformat: "d-M-Y H:i", newformat: "d-M-Y H:i" }, formatter: "date", resizable: false, searchoptions: { dataInit: function (elem) { $(elem).datetimepicker({ timepicker: true, format: 'd-M-Y H:i', step: 15, scrollInput: false }) }, sopt: ['eq', 'ne', 'lt', 'gt', 'le', 'ge'] } },
            { key: false, search: true, name: 'WorkGroup',  width: '9%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },


        ],

        pager: jQuery('#pager'),
        rowNum: 5,
        rowList: [5, 10, 20, 50],
        height: 'auto',
        width: '100%',
        viewrecords: true,
        // caption: 'Scheduled Work Order',
        sortname: 'Test',
        sortorder: 'desc',
        excel: true,
        subGrid: false,
        subGridOptions: {
            "plusicon": "ui-icon-triangle-1-e", "minusicon": "ui-icon-triangle-1-s", "openicon": "ui-icon-arrowreturn-1-e",
            "reloadOnExpand": false,
            "selectOnExpand": true
        },
        onCellSelect: function (rowId, iCol, content, event) {
            var rowData = $(this).jqGrid("getRowData", rowId);
            LinkClicked(rowId, rowData);
            
        },
        onPaging: function (pgButton) {
            curPage = $(".ui-pg-input").val();// current page
            if (pgButton == "user") {
                if (parseInt(totalPage) < parseInt(curPage) || parseInt(curPage) == 0) {
                    bootbox.alert(Messages.PAGE_NUMBER_ALERT_MESSAGE);
                    return "stop";
                }
            }
        },
        loadComplete: function (data) {
            totalPage = $("#sp_1_pager").text();// total pages
            curPage = $(".ui-pg-input").val();// current page
            $("#ExporttoExcel").removeClass('ui-state-disabled');
            $("#ExporttoPDF").removeClass('ui-state-disabled');
            $("#ExporttoCSV").removeClass('ui-state-disabled');

            if ($('#sp_1_pager').text() == "0") {
                $("#sp_1_pager").text("1");
                $("#next_pager").addClass('ui-state-disabled');
                $("#last_pager").addClass('ui-state-disabled');
            }
            $("tr.jqgrow:odd").css("background", "#F0F8FF");
            $('#refresh_grid_top').hide();
            $('.ui-icon-csv').prop('title', 'Export To CSV');
            $('.ui-icon-excel').prop('title', 'Export To Excel');
            $('.ui-icon-refresh1').prop('title', 'Reload Grid');
            if (!isFromSave && !FromNotification) {
                $(".content").scrollTop(3000);
                isFromSave = true;
                FromNotification = false;
            }
            else {
                if ((!gridClicked) &&(!isFromSave)){
                    $(".content").scrollTop(0);
                } else {
                    gridClicked = false;
                }
            }
            $('#fbox_grid_search, #fbox_grid_reset,#first_pager,#prev_pager,#next_pager,#last_pager,#refresh_grid_top').click(function () {
                gridClicked = true;
            });
            $('.ui-pg-selbox').change(function () {
                gridClicked = true;
            });
            //if (!hasAddPermission) {
            //    $("#Add").hide();
            //}
            //setGridPermission(data);
        },
        loadError: function (responce) {
            if (responce.status == 404) {
                $(this).clearGridData();
            }
            // if (responce.status === 406) {
            //        window.location.href = "/home?r=mts";
            //    }
            //if (responce.status === 409) {
            //        window.location.href = "/account/Logout";
            //    }
            if ($('#sp_1_pager').text() == "0") {
                $("#sp_1_pager").text("1");
                $("#next_pager").addClass('ui-state-disabled');
                $("#last_pager").addClass('ui-state-disabled');

                $("#ExporttoExcel").addClass('ui-state-disabled');
                $("#ExporttoPDF").addClass('ui-state-disabled');
                $("#ExporttoCSV").addClass('ui-state-disabled');
            }
            $('#refresh_grid_top').hide();
            //if (!hasAddPermission) {
            //    $("#Add").hide();
            //}
            // setGridPermission(responce);
        },
        emptyrecords: 'No records to display',
        jsonReader: {
            root: "rows",
            page: "page",
            total: "total",
            records: "records",
            repeatitems: false,
            Id: "0"
        },
        autowidth: true,
        multiselect: false,
        toppager: true,
        toolbar: [true, "top"]
    }).navGrid('#pager', { cloneToTop: true, edit: false, add: false, del: false, search: false, refresh: true },
        {
            multipleSearch: true,
            multipleGroup: true,
        })
        //.navButtonAdd('#grid_toppager', {
        //    id: "Add",
        //    caption: "",
        //    buttonicon: "ui-icon-add",
        //    onClickButton: function () {
        //        CheckMultipleTabs("/bems/" + controllerName + "/add");
        //    }
        //})

        .navButtonAdd('#pager_left', {
            id: "refresh_grid_top",
            caption: "",
            buttonicon: "ui-icon-refresh1",
            onClickButton: function () {
                $('#grid').jqGrid().setGridParam({ page: 1 }).trigger('reloadGrid');
            }
        })
        .navButtonAdd('#pager_left', {
            id: "ExporttoExcel",
            caption: "",
            buttonicon: "ui-icon-excel",
            onClickButton: function () {
                Export("Excel");
            }
        })
    //.navButtonAdd('#grid_toppager', {
    //    id: "ExporttoPDF",
    //    caption: "Export to Pdf",
    //    buttonicon: "ui-icon-disk",
    //    onClickButton: function () {
    //        Export("Pdf");
    //    }
    //})
    .navButtonAdd('#pager_left', {
        id: "ExporttoCSV",
        caption: "",
        buttonicon: "ui-icon-csv",
        onClickButton: function () {
            Export("CSV");
        }
    });

    $.jgrid.jqModal = $.jgrid.jqModal || {};
    $.extend(true, $.jgrid.jqModal, { toTop: true });

    // create the searching dialog
    grid.searchGrid(prmSearch);

    // find the div which contain the searching dialog
    var searchDialog = $("#searchmodfbox_" + grid[0].id);
    // make the searching dialog non-popup
    searchDialog.css({ position: "relative", "z-index": "auto", float: "left" });

    var gbox = $("#gbox_" + grid[0].id);
    gbox.before(searchDialog);
    gbox.css({ clear: "left" });
    $("#searchmodfbox_grid,#refresh_grid").hide();
    if (GlobalController == "external_unscheduledworkorder") {
        $('#Add').hide();
    }

}

function TypeCat(cellValue, options, rowObject, action) {
    if (rowObject.WorkOrderCategoryLovId == 273) {
        var cat = "Breakdown";
    }
    else if (rowObject.WorkOrderCategoryLovId == 270) {
        var cat = "Corrective";
    }
    else if (rowObject.WorkOrderCategoryLovId == 272) {
        var cat = "Insurance";
    }
    else if (rowObject.WorkOrderCategoryLovId == 274) {
        var cat = "Others";
    }
    else if (rowObject.WorkOrderCategoryLovId == 271) {
        var cat = "RW work";
    }
    else if (rowObject.WorkOrderCategoryLovId == 275) {
        var cat = "Emergency";
    }
    else if (rowObject.WorkOrderCategoryLovId == 390) {
        var cat = "Proactive";
    }
    else
    {
        var cat = "Hai";
    }
    return cat;
}

function StatusCat(cellValue, options, rowObject, action) {
    if (rowObject.WorkOrderPriorityLovId == 228) {
        var cat = "Critical";
    }
    else if (rowObject.WorkOrderPriorityLovId == 227) {
        var cat = "Normal";
    }
    return cat;
}


function Export(exportType) {

    var grid = $('#grid');
    var filters = grid.getGridParam('postData').filters;
    var sortColumnName = $("#grid").jqGrid('getGridParam', 'sortname');
    var sortOrder = $("#grid").jqGrid('getGridParam', 'sortorder');

    var screenTitle = $("#menu").find("li.active:last").text();
    var $downloadForm = $("<form method='POST'>")
         .attr("action", "/api/common/Export")
         .append($("<input name='filters' type='text'>").val(filters))
         .append($("<input name='sortOrder' type='text'>").val(sortOrder))
        .append($("<input name='sortColumnName' type='text'>").val(sortColumnName))
        .append($("<input name='screenName' type='text'>").val("UnScheduled_Work_Order"))
      //  .append($("<input name='screenName' type='text'>").val(screenTitle.split(" ").join('_')))
          .append($("<input name='spName' type='text'>").val("uspFM_EngMaintenanceWorkOrderTxn_UnSchedule_Export"))
         .append($("<input name='exportType' type='text'>").val(exportType));

    $("body").append($downloadForm);
    var status = $downloadForm.submit();
    $downloadForm.remove();

}

//function filterGrid() {
//    var postDataValues = $("#grid").jqGrid('getGridParam', 'postData');
//    // grab all the filter ids and values and add to the post object
//    $('.filterItem').each(function (index, item) {
//        postDataValues[$(item).attr('id')] = $(item).val();
//    });
//    $('#grid').jqGrid().setGridParam({ postData: postDataValues, page: 1 }).trigger('reloadGrid');
//}
function filterGrid() {
    var postDataValues = $("#grid").jqGrid('getGridParam', 'postData');
    var totalrecords = $("#grid").getGridParam("reccount");
    var Curentpage = $('#grid').getGridParam('page');
    $('.filterItem').each(function (index, item) {
        postDataValues[$(item).attr('id')] = $(item).val();
    });
    if (totalrecords <= 1) {
        Curentpage = Curentpage - 1;
    }
    $('#grid').jqGrid().setGridParam({ postData: postDataValues, page: Curentpage }).trigger('reloadGrid');
}