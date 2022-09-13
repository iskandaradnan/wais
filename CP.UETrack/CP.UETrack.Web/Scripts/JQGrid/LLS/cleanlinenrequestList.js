$(function () {
    var IssueStatusValue = "Pending:Pending;Issued:Issued;";
    var PriorityValue = "Normal:Normal;Emergency:Emergency;";
    genarateGrid(IssueStatusValue, PriorityValue);
});

function genarateGrid(issueStatusValue, priorityValue, ) {
    var isFromSave = false;
    var gridClicked = false;
    var hasAddPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Add'");

    var IssueStatusValue = issueStatusValue.replace(/[,;]$/, '').toString();
    var PriorityValue = priorityValue.replace(/[,;]$/, '').toString();

    var grid = $("#grid"),
        prmSearch = { multipleSearch: true, overlay: false };
    grid.jqGrid({
        url: "/api/CleanLinenRequest/GetAll",
        datatype: 'json',
        mtype: 'Get',
        ajaxGridOptions: { contentType: 'application/json; charset=utf-8' },
        colNames: ['Id', 'DocumentNo', 'RequestDateTime', 'UserAreaCode', 'UserLocationCode', 'RequestedBy', 'Priority', 'IssueStatus', 'TotalItemRequested', 'LinenCode', 'LinenDescription', 'AgreedShelfLevel', 'BalanceOnShelf', 'DeliveryIssuedQty1st', 'DeliveryIssuedQty2nd', 'Shortfall', 'StoreBalance'],
        colModel: [
            { key: true, hidden: true, name: 'CleanLinenRequestId', width: '0%' },
            { key: true, search: true, name: 'DocumentNo', width: '13%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            //{ key: false, search: true, name: 'RequestDateTime', width: '15%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'RequestDateTime', width: '12%', formatoptions: { srcformat: "d-M-Y H:i", newformat: "d-M-Y H:i" }, formatter: "date", resizable: true, searchoptions: { dataInit: function (elem) { $(elem).datetimepicker({ timepicker: true, format: 'd-M-Y H:i', step: 15, scrollInput: false }) }, sopt: ['eq', 'ne', 'lt', 'gt', 'le', 'ge'] } },
            { key: false, search: true, name: 'UserAreaCode', width: '15%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'UserLocationCode', width: '15%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'RequestedBy', width: '10%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'Priority', width: '10%', stype: "select", searchoptions: { sopt: ["eq", "ne"], value: PriorityValue, defaultValue: "Normal" } },
            { key: false, search: true, name: 'IssueStatus', width: '10%', stype: "select", searchoptions: { sopt: ["eq", "ne"], value: IssueStatusValue, defaultValue: "Pending" } },
            { key: false, search: true, name: 'TotalItemRequested', width: '10%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'LinenCode', width: '10%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'LinenDescription', width: '10%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'AgreedShelfLevel', width: '10%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, hidden: true, name: 'BalanceOnShelf', width: '0%' },
            { key: false, hidden: true, name: 'DeliveryIssuedQty1st', width: '0%' },
            { key: false, hidden: true, name: 'DeliveryIssuedQty2nd', width: '0%' },
            { key: false, hidden: true, name: 'Shortfall', width: '0%' },
            { key: false, hidden: true, name: 'StoreBalance', width: '0%' },

        ],
        pager: jQuery('#pager'),
        rowNum: 5,
        rowList: [5, 10, 20, 50],
        height: 'auto',
        width: '100%',
        viewrecords: true,
        // caption: 'Block',
        sortname: 'ModifiedDateUTC',
        sortorder: 'desc',
        excel: true,
        subGrid: false,
        subGridOptions: {
            "plusicon": "ui-icon-triangle-1-e", "minusicon": "ui-icon-triangle-1-s", "openicon": "ui-icon-arrowreturn-1-e",
            "reloadOnExpand": false,
            "selectOnExpand": true,
        },
        onCellSelect: function (CleanLinenRequestId, iCol, content, event) {
            var rowData = $(this).jqGrid("getRowData", CleanLinenRequestId);
            //console.log(rowData);
            LinkClicked(CleanLinenRequestId);
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
            $("tr.jqgrow:odd").css("background", "#F0F8FF");
            totalPage = $("#sp_1_pager").text();// total pages
            curPage = $(".ui-pg-input").val();// current page
            $(".ExporttoExcel").removeClass('ui-state-disabled');
            $("#ExporttoPDF").removeClass('ui-state-disabled');
            $(".ExporttoCSV").removeClass('ui-state-disabled');

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
            if (!isFromSave) {
                $(".content").scrollTop(3000);
                isFromSave = true;
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
            if (!hasAddPermission) {
                $("#Add").hide();
            }
            setGridPermission(data);
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

                $(".ExporttoExcel").addClass('ui-state-disabled');
                $("#ExporttoPDF").addClass('ui-state-disabled');
                $(".ExporttoCSV").addClass('ui-state-disabled');
            }
            $('#refresh_grid_top').hide();
            if (!hasAddPermission) {
                $("#Add").hide();
            }
            setGridPermission(responce);
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
            class: "ExporttoExcel",
            caption: "",
            buttonicon: "ui-icon-excel",
            onClickButton: function () {
                debugger;
                Export("Excel");
            }
        })

        .navButtonAdd('#pager_left', {
            class: "ExporttoCSV",
            caption: "",
            buttonicon: "ui-icon-csv",
            onClickButton: function () {
                Export("CSV");
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
    //.navButtonAdd('#grid_toppager', {
    //    id: "ExporttoCSV",
    //    caption: "Export to CSV",
    //    buttonicon: "ui-icon-disk",
    //    onClickButton: function () {
    //        Export("CSV");
    //    }
    //});



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


function escapeShowTitle(title) {

    title = title.replace(/\\([\s\S])|(")/g, "\\$1$2");
    title = escape(title)
    return title
}




function confirmDelete(id, code, description, gridId) {
    //if (code.length > 30) {
    //    code = code.substring(0, 30);
    //}
    //if (description.length > 30) {
    //    description = description.substring(0, 30) + '...';
    //}
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION + code + " - " + description + "?";
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/CleanLinenRequest/Delete/" + id)
                .done(function (result) {
                    filterGrid();
                    showMessage('CleanLinenIssue Details', CURD_MESSAGE_STATUS.DS);

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
    var mymodel = $("#grid").getGridParam('colModel')

    var screenTitle = $("#menu").find("li.active:last").text();
    var $downloadForm = $("<form method='POST'>")
        .attr("action", "/api/common/Export")
        .append($("<input name='filters' type='text'>").val(filters))
        .append($("<input name='sortOrder' type='text'>").val(sortOrder))
        .append($("<input name='sortColumnName' type='text'>").val(sortColumnName))
        .append($("<input name='screenName' type='text'>").val("CleanLinenRequest_Details"))
        .append($("<input name='spName' type='text'>").val("LLSCleanLinenRequestTxn_Export"))
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