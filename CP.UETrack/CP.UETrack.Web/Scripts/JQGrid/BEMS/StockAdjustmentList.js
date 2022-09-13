$(function () {
    var StockStatusValues = "Open:Open;Submitted:Submitted;Approved:Approved;Rejected:Rejected;";
    var StockMonthValues = "January:January; February:February; March:March; April:April; May:May; June:June; July:July; August:August; September:September;                               October:October; November:November; December:December ";
    genarateGrid(StockStatusValues, StockMonthValues);
});

function genarateGrid(StockStatusVal, StockMonthVal) {
    var isFromSave = false;
    var gridClicked = false;
    var ApprovalStatusVal = StockStatusVal.replace(/[,;]$/, '').toString();
    var ApprovalMonthVal = StockMonthVal.replace(/[,;]$/, '').toString();
    var grid = $("#grid"),
        prmSearch = { multipleSearch: true, overlay: false };
    grid.jqGrid({
        url: "/api/StockAdjustment/GetAll",
        datatype: 'json',
        mtype: 'Get',
        ajaxGridOptions: { contentType: 'application/json; charset=utf-8' },
        colNames: ['Id', 'Year', 'Month', 'Stock Adjustment No.', 'Adjustment Date', 'Item Description', 'Part Category', 'Approval Status', 'Approved By', 'Approved Date'],
        colModel: [
            { key: true, hidden: true, name: 'StockAdjustmentId', width: '0%' },
            { key: false, search: true, name: 'Year', width: '5%', searchoptions: { sopt: ['eq', 'ne', 'lt', 'gt', 'le', 'ge'] } },

            //{ key: false, search: true, name: 'Month', width: '6%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },

            { key: false, name: 'Month', width: '6%', stype: "select", searchoptions: { sopt: ["eq", "ne"], value: ApprovalMonthVal, defaultValue: "January" } },

            { key: false, search: true, name: 'StockAdjustmentNo', width: '18%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'AdjustmentDate', width: '13%', formatoptions: { srcformat: "d-M-Y H:i", newformat: "d-M-Y" }, formatter: "date", resizable: false, searchoptions: { dataInit: function (elem) { $(elem).datetimepicker({ timepicker: false, format: 'd-M-Y', step: 15, scrollInput: false }) }, sopt: ['eq', 'ne', 'lt', 'gt', 'le', 'ge'] } },
            { key: false, search: true, name: 'ItemDescription', width: '15%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'PartCategory', width: '15%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },

            //{ key: false, search: true, name: 'ApprovalStatusValue', width: '7%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, name: 'ApprovalStatusValue', width: '7%', stype: "select", searchoptions: { sopt: ["eq", "ne"], value: ApprovalStatusVal, defaultValue: "Open" } },

            { key: false, search: true, name: 'ApprovedBy', width: '8%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'ApprovedDate', width: '7%', formatoptions: { srcformat: "d-M-Y H:i", newformat: "d-M-Y" }, formatter: "date", resizable: false, searchoptions: { dataInit: function (elem) { $(elem).datetimepicker({ timepicker: false, format: 'd-M-Y', step: 15, scrollInput: false }) }, sopt: ['eq', 'ne', 'lt', 'gt', 'le', 'ge'] } },

            //{ name: 'edit', search: false, index: 'StockAdjustmentId', width: '5%', sortable: false, formatter: editLink },
            // { name: 'delete', search: false, index: 'StockAdjustmentId', width: '5%', sortable: false, formatter: deleteLink },
            // { name: 'view', search: false, index: 'StockAdjustmentId', width: '5%', sortable: false, formatter: viewLink },

        ],

        pager: jQuery('#pager'),
        rowNum: 5,
        rowList: [5, 10, 20, 50],
        height: 'auto',
        width: '100%',
        viewrecords: true,
        //caption: 'Stock Adjustment',
        sortname: 'ModifiedDateUTC',
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
            //$("#ExporttoPDF").removeClass('ui-state-disabled');
            $("#ExporttoCSV").removeClass('ui-state-disabled');
            $("tr.jqgrow:odd").css("background", "#F0F8FF");

            if ($('#sp_1_pager').text() == "0") {
                $("#sp_1_pager").text("1");
                $("#next_pager").addClass('ui-state-disabled');
                $("#last_pager").addClass('ui-state-disabled');
            }
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
                if ((!gridClicked) && (!isFromSave)) {
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
                //$("#ExporttoPDF").addClass('ui-state-disabled');
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
        }
    )
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

}

function editLink(cellValue, options, rowObject, action) {
    if (rowObject.ApprovalStatusValue == "Open" || rowObject.ApprovalStatusValue == "Submitted") {

        return "<a href='#' onclick=CheckMultipleTabs('/bems/StockAdjustment/Edit/" + rowObject.StockAdjustmentId + "') class='glyphicon glyphicon-edit' style='color:#477ca9;font-size: 13px;'></a>";
    }
    else {
        return "<a href='javascript:NotificationEditAlert()' class='glyphicon glyphicon-ban-circle' style='cursor:default;color:#477ca9;font-size: 13px;'></a>";
    }
}
function escapeShowTitle(title) {

    title = title.replace(/\\([\s\S])|(")/g, "\\$1$2");
    title = escape(title)
    return title
}

function deleteLink(cellValue, options, rowdata, action) {
    var gridID = 'gridTable';
    if (rowdata.ApprovalStatusValue == "Open") {

        return "<a href='javascript:confirmDelete(" + rowdata.StockAdjustmentId + ',' + '"' + rowdata.StockAdjustmentNo + '"' + ',' + '"'
            + rowdata.AdjustmentDate + '"' + ',' + '"' + gridID + '"'
            + ")' class='glyphicon glyphicon-remove' style='color:red;font-size: 13px;'></a>";
    }
    else {
        return "<a href='javascript:NotificationDeleteAlert()' class='glyphicon glyphicon-ban-circle' style='cursor:default;color:#477ca9;font-size: 13px;'></a>";
    }
}





function confirmDelete(Id, code, description, gridId) {
    if (code.length > 30) {
        code = code.substring(0, 30);
    }
    if (description.length > 30) {
        description = description.substring(0, 30) + '...';
    }
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION + code + " - " + description + "?";
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/StockAdjustment/Delete/" + Id)

                .done(function (result) {
                    filterGrid();
                    showMessage('Stock Adjustment', CURD_MESSAGE_STATUS.DS);
                    $("#top-notifications").show();
                    setTimeout(function () {
                        $("#top-notifications").hide();
                    }, 5000);

                    $('#myPleaseWait').modal('hide');
                })
                .fail(function () {
                    $('#myPleaseWait').modal('hide');
                });
        }
    });
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
        .append($("<input name='screenName' type='text'>").val("Stock_Adjustment"))
        .append($("<input name='spName' type='text'>").val("uspFM_EngStockAdjustmentTxn_Export"))
        .append($("<input name='exportType' type='text'>").val(exportType));

    $("body").append($downloadForm);
    var status = $downloadForm.submit();
    $downloadForm.remove();

}

function filterGrid() {
    var postDataValues = $("#grid").jqGrid('getGridParam', 'postData');

    var totalrecords = $("#grid").getGridParam("reccount");
    var Curentpage = $('#grid').getGridParam('page');
    // grab all the filter ids and values and add to the post object
    $('.filterItem').each(function (index, item) {
        postDataValues[$(item).attr('id')] = $(item).val();
    });
    if (totalrecords <= 1) {
        Curentpage = Curentpage - 1;
    }
    $('#grid').jqGrid().setGridParam({ postData: postDataValues, page: Curentpage }).trigger('reloadGrid');
}


function NotificationDeleteAlert() {
    bootbox.alert("Submitted/Approved/Rejected Record Cannot be Deleted.");
}
function NotificationEditAlert() {
    bootbox.alert("Submitted/Approved/Rejected Record Cannot be Edited.");
}