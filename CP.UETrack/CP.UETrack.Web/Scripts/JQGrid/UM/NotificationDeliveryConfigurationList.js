$(function () {
    var StatusVal = "Active:Active;Inactive:Inactive;";
    genarateGrid(StatusVal);
});
function genarateGrid(StatusVal) {
    var isFromSave = false;
    var gridClicked = false;
    var StatusValues = StatusVal.replace(/[,;]$/, '').toString();
    var grid = $("#grid"),
     prmSearch = { multipleSearch: true, overlay: false };
    grid.jqGrid({
        url: "/api/NotificationDeliveryConfiguration/GetAll",
        datatype: 'json',
        mtype: 'Get',
        ajaxGridOptions: { contentType: 'application/json; charset=utf-8' },
        colNames: ['NotificationTemplateId', 'Module', 'Notification Name', 'Subject', 'Notification Type', 'Status'],
        colModel: [
            { key: true, hidden: true, name: 'NotificationTemplateId', width: '0%' },
            { key: false, hidden: true, name: 'ModuleName', width: '0%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc'] } },
            { key: false, name: 'NotificationName', width: '30%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc'] } },
            { key: false, name: 'Subject', width: '25%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc'] } },
             { key: false, name: 'NotificationType', width: '25%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc'] } },
              { key: false, name: 'DisableNotification', width: '10%', stype: "select", searchoptions: { sopt: ["eq", "ne"], value: StatusValues, defaultValue: "Active" } },
            //{ name: 'edit', search: false, index: 'NotificationTemplateId', width: '5%', sortable: false, formatter: editLink },
            //{ name: 'view', search: false, index: 'NotificationTemplateId', width: '5%', sortable: false, formatter: viewLink },
        ],

        pager: jQuery('#pager'),
        rowNum: 5,
        rowList: [5, 10, 20, 50],
        height: 'auto',
        width: '100%',
        viewrecords: true,
        //caption: 'UserShiftLeaveDetailsList',
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
            // var rowData = $(this).jqGrid("getRowData", rowId);
            LinkClicked(rowId);
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
            if (!isFromSave) {
                $(".content").scrollTop(3000);
                isFromSave = true;
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
        },
        loadError: function (responce) {
            if (responce.status == 404) {
                $(this).clearGridData();
            }

            if ($('#sp_1_pager').text() == "0") {
                $("#sp_1_pager").text("1");
                $("#next_pager").addClass('ui-state-disabled');
                $("#last_pager").addClass('ui-state-disabled');

                $("#ExporttoExcel").addClass('ui-state-disabled');
                $("#ExporttoPDF").addClass('ui-state-disabled');
                $("#ExporttoCSV").addClass('ui-state-disabled');
            }
            $('#refresh_grid_top').hide();

        },
        emptyrecords: 'No records to Display',
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
        //        CheckMultipleTabs("/UM/NotificationDeliveryConfiguration/add");;
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

    return "<a href='#' onclick=CheckMultipleTabs('/UM/NotificationDeliveryConfiguration/Edit/" + rowObject.NotificationTemplateId + "') class='glyphicon glyphicon-edit' style='color:#477ca9;font-size: 13px;'></a>";
}
function escapeShowTitle(title) {

    title = title.replace(/\\([\s\S])|(")/g, "\\$1$2");
    title = escape(title)
    return title
}
//function deleteLink(cellValue, options, rowdata, action) {
//    var gridID = 'gridTable';


//    return "<a href='javascript:confirmDelete(" + rowdata.NotificationTemplateId + ',' + '"' + rowdata.NotificationTemplateId + '"' + ',' + '"'
//     + rowdata.QcCode + '"' + ',' + '"' + gridID + '"'
//     + ")' class='glyphicon glyphicon-remove' style='color:red;font-size: 13px;'></a>";


//}
function viewLink(cellValue, options, rowObject, action) {
    return "<a href='#' onclick=CheckMultipleTabs('/UM/NotificationDeliveryConfiguration/View/" + rowObject.NotificationTemplateId + "') class='glyphicon glyphicon-eye-open' style='color:#477ca9;font-size: 13px;'></a>";
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
        .append($("<input name='screenName' type='text'>").val("Notification_Delivery_Configuration"))
          .append($("<input name='spName' type='text'>").val("uspFM_NotificationTemplate_Export"))
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