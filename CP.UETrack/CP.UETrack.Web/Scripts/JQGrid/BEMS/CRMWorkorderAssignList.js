$(function () {
    genarateGrid();
});

function genarateGrid() {
    var isFromSave = false;
    var gridClicked = false;
    var grid = $("#grid"),
    prmSearch = { multipleSearch: true, overlay: false };
    grid.jqGrid({
        url: "/api/CRMWorkorderAssign/GetAll",
        datatype: 'json',
        mtype: 'Get',
        ajaxGridOptions: { contentType: 'application/json; charset=utf-8' },
        colNames: ['CRMRequestWOId', 'Work Order No.', 'Work Order Date / Time', 'Request Type'],
        colModel: [
            { key: true, hidden: true, name: 'CRMRequestWOId', width: '0%' },
            { key: false, search: true, name: 'CRMRequestWONo', width: '40%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            //{ key: false, search: true, name: 'CRMWorkOrderDateTime', width: '30%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'CRMWorkOrderDateTime', width: '30%', formatoptions: { srcformat: "d-M-Y H:i", newformat: "d-M-Y H:i" }, formatter: "date", resizable: true, searchoptions: { dataInit: function (elem) { $(elem).datetimepicker({ timepicker: true, format: 'd-M-Y H:i', step: 15, scrollInput: false }) }, sopt: ['eq', 'ne', 'lt', 'gt', 'le', 'ge'] } },
            { key: false, search: true, name: 'TypeOfRequest', width: '30%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            
            //{ name: 'edit', search: false, index: 'CRMRequestWOId', width: '5%', sortable: false, formatter: editLink },
            //{ name: 'delete', search: false, index: 'CRMRequestWOId', width: '5%', sortable: false, formatter: deleteLink },
            //{ name: 'view', search: false, index: 'CRMRequestWOId', width: '5%', sortable: false, formatter: viewLink }
        ],
        pager: jQuery('#pager'),
        rowNum: 5,
        rowList: [5, 10, 20, 50],
        height: 'auto',
        width: '100%',
        viewrecords: true,
        //caption: 'EOD Capture',
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
        }
        )
        //.navButtonAdd('#grid_toppager', {
        //    id: "Add",
        //    caption: "",
        //    buttonicon: "ui-icon-add",
        //    onClickButton: function () {
        //        window.location.href = "/bems/CRMWorkorder/add";
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
    //    id:"ExporttoPDF",
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

function activeText(cellValue, options, rowObject, action) {

    return rowObject.Active == 1 ? "Active" : "InActive";
}

function editLink(cellValue, options, rowObject, action) {

    if (rowObject.WorkOrderStatus === "Closed" || rowObject.WorkOrderStatus === "Cancelled") {
        return "<a  class='glyphicon glyphicon-ban-circle' style='cursor:default;color:#477ca9;font-size: 13px;'></a>";
    }

    return "<a href='/bems/CRMWorkorder/edit/" + rowObject.CRMRequestWOId + "' class='glyphicon glyphicon-edit' style='color:#477ca9;font-size: 13px;'></a>";
}

function escapeShowTitle(title) {

    title = title.replace(/\\([\s\S])|(")/g, "\\$1$2");
    title = escape(title)
    return title
}

//function deleteLink(cellValue, options, rowdata, action) {
//    var gridID = 'gridTable';
//    var Name = escapeShowTitle(rowdata.CategorySystemName);
//    if (rowdata.ServiceName != null && rowdata.ServiceName != "") {
//        var ServiceName = escapeShowTitle(rowdata.ServiceName);
//    }

//    return "<a href='javascript:confirmDelete(" + rowdata.CRMRequestWOId + ',' + '"' + ServiceName + '"' + ',' + '"'
//     + Name + '"' + ',' + '"' + gridID + '"'
//     + ")' class='glyphicon glyphicon-trash'></a>";
//}


function deleteLink(cellValue, options, rowdata, action) {
    var gridID = 'gridTable';

    if (rowdata.WorkOrderStatus === "Closed" || rowdata.WorkOrderStatus == "Cancelled") {
        return "<a  class='glyphicon glyphicon-ban-circle'  style='cursor:default;color:#477ca9;font-size: 13px;'></a>";
    }

    return "<a href='javascript:confirmDelete(" + rowdata.CRMRequestWOId + ',' + '"' + rowdata.CRMWorkOrderNo + '"' + ',' + '"'
     + rowdata.WorkOrderStatus + '"' + ',' + '"' + gridID + '"'
     + ")' class='glyphicon glyphicon-remove' style='color:red;font-size: 13px;'></a>";
}

function viewLink(cellValue, options, rowObject, action) {
    return "<a href='/bems/CRMWorkorderAssign/view/" + rowObject.CRMRequestWOId + "' class='glyphicon glyphicon-eye-open' style='color:#477ca9;font-size: 13px;' ></a>";
}

function confirmDelete(id, code, description, gridId) {
    if (code.length > 30) {
        code = code.substring(0, 30);
    }
    if (description.length > 30) {
        description = description.substring(0, 30) + '...';
    }
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION + code + " - " + description + "?";
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/CRMWorkorderAssign/Delete/" + id)
             .done(function (result) {
                 filterGrid();
                 showMessage('CRM Work Order', CURD_MESSAGE_STATUS.DS);

                 $("#top-notifications").modal('show');
                 setTimeout(function () {
                     $("#top-notifications").modal('hide');
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
        .append($("<input name='screenName' type='text'>").val("Work_Order_Assign"))
         .append($("<input name='screenName' type='text'>").val(screenTitle.split(" ").join('_')))
          .append($("<input name='spName' type='text'>").val("uspFM_CRMWorkOrderAssign_Export"))
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