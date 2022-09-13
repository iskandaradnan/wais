$(function () {
    genarateGrid();
});

function genarateGrid() {
    var isFromSave = false;
    var gridClicked = false;
    var grid = $("#grid"),
    prmSearch = { multipleSearch: true, overlay: false };
    grid.jqGrid({
        url: "/api/SNF/GetAll",
        datatype: 'json',
        mtype: 'Get',
        ajaxGridOptions: { contentType: 'application/json; charset=utf-8' },
        colNames: ['Id', 'SNF No.', 'Asset No', 'Variation Status', 'SNF Date', 'Edit', 'Verify', 'Approve', 'Reject', 'Delete', 'View'],
        colModel: [
            { key: true, hidden: true, name: 'TestingandCommissioningId', width: '0%' },
            { key: false, search: true, name: 'SNFNo', width: '15%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'AssetNo', width: '15%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'VariationStatus', width: '15%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, name: 'SNFDate', width: '15%', formatoptions: { srcformat: "d-M-Y H:i", newformat: "d-M-Y" }, formatter: "date", resizable: true, searchoptions: { dataInit: function (elem) { $(elem).datetimepicker({ timepicker: false, format: 'd-M-Y', step: 15, scrollInput: false }) }, sopt: ['eq', 'ne', 'lt', 'gt', 'le', 'ge'] } },
            //{ key: false, search: true, name: 'ContractEndDate', width: '15%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
           // { key: false, search: true, name: 'Status', width: '15%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
           { name: 'edit', search: false, index: 'TestingandCommissioningId', width: '5%', sortable: false, formatter: editLink },
            { name: 'verify', search: false, index: 'TestingandCommissioningId', width: '5%', sortable: false, formatter: verifyLink },
            { name: 'approve', search: false, index: 'TestingandCommissioningId', width: '5%', sortable: false, formatter: approveLink },
            { name: 'reject', search: false, index: 'TestingandCommissioningId', width: '5%', sortable: false, formatter: rejectLink },
            { name: 'delete', search: false, index: 'TestingandCommissioningId', width: '5%', sortable: false, formatter: deleteLink },
            { name: 'view', search: false, index: 'TestingandCommissioningId', width: '5%', sortable: false, formatter: viewLink },

        ],

        pager: jQuery('#pager'),
        rowNum: 5,
        rowList: [5, 10, 20, 50],
        height: 'auto',
        width: '100%',
        viewrecords: true,
       // caption: 'SNF',
        sortname: 'ModifiedDateUTC',
        sortorder: 'desc',
        excel: true,
        subGrid: false,
        subGridOptions: {
            "plusicon": "ui-icon-triangle-1-e", "minusicon": "ui-icon-triangle-1-s", "openicon": "ui-icon-arrowreturn-1-e",
            "reloadOnExpand": false,
            "selectOnExpand": true
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
            $("#ExporttoExcel").removeClass('ui-state-disabled');
            $("#ExporttoPDF").removeClass('ui-state-disabled');
            $("#ExporttoCSV").removeClass('ui-state-disabled');

            if ($('#sp_1_pager').text() == "0") {
                $("#sp_1_pager").text("1");
                $("#next_pager").addClass('ui-state-disabled');
                $("#last_pager").addClass('ui-state-disabled');
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
            }
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
        ).navButtonAdd('#grid_toppager', {
            id: "Add",
            caption: "",
            buttonicon: "ui-icon-add",
            onClickButton: function () {
                window.location.href = "/vm/SNF/add";
            }
        }
        )
        .navButtonAdd('#grid_toppager', {
            id: "ExporttoExcel",
            caption: "",
            buttonicon: "ui-icon-excel",
            onClickButton: function () {
                Export("Excel");
            }
        })
    
    .navButtonAdd('#grid_toppager', {
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
    if (rowObject.Status == "Edit" || rowObject.Status == "Add")
        return "<a href='/vm/SNF/edit/" + rowObject.TestingandCommissioningId + "' class='glyphicon glyphicon-edit' style='color:#477ca9;font-size: 13px;'></a>";
    else
        return "<a href='javascript:NotificationAlert()'class='glyphicon glyphicon-ban-circle' style='cursor:default;color:#477ca9;font-size: 13px;'";
}
function verifyLink(cellValue, options, rowObject, action) {
    if (rowObject.Status == "Edit" || rowObject.Status == "Add")
        return "<a href='/vm/SNF/verify/" + rowObject.TestingandCommissioningId + "' class='glyphicon glyphicon-edit' style='color:#477ca9;font-size: 13px;'></a>";
    else
        return "<a href='javascript:NotificationAlert()' class='glyphicon glyphicon-ban-circle' style='cursor:default;color:#477ca9;font-size: 13px;'";
}
function approveLink(cellValue, options, rowObject, action) {
    if (rowObject.Status == "Verify")
        return "<a href='/vm/SNF/approved/" + rowObject.TestingandCommissioningId + "' class='glyphicon glyphicon-edit' style='color:#477ca9;font-size: 13px;'></a>";
    else
        return "<a href='javascript:NotificationAlert()' class='glyphicon glyphicon-ban-circle' style='cursor:default;color:#477ca9;font-size: 13px;'";
}
function rejectLink(cellValue, options, rowObject, action) {
    if (rowObject.Status == "Verify")
        return "<a href='/vm/SNF/reject/" + rowObject.TestingandCommissioningId + "' class='glyphicon glyphicon-edit' style='color:#477ca9;font-size: 13px;'></a>";
    else
        return "<a href='javascript:NotificationAlert()' class='glyphicon glyphicon-ban-circle' style='cursor:default;color:#477ca9;font-size: 13px;'";
}
function escapeShowTitle(title) {

    title = title.replace(/\\([\s\S])|(")/g, "\\$1$2");
    title = escape(title)
    return title
}

function deleteLink(cellValue, options, rowdata, action) {
    var gridID = 'gridTable';
    //var Name = escapeShowTitle(rowdata.CustomerName);
    // var staffName = escapeShowTitle(rowdata.StaffName);

    return "<a href='javascript:confirmDelete(" + rowdata.TestingandCommissioningId + ',' + '"' + rowdata.SNFNo + '"' + ',' + '"'
     + rowdata.AssetNo + '"' + ',' + '"' + gridID + '"'
     + ")' class='glyphicon glyphicon-remove' style='color:red;font-size: 13px;'></a>";
}
function viewLink(cellValue, options, rowObject, action) {
    return "<a href='/vm/SNF/view/" + rowObject.TestingandCommissioningId + "' class='glyphicon glyphicon-eye-open' style='color:#477ca9;font-size: 13px;'></a>";
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
            $.get("/api/SNF/Delete/" + id)
             .done(function (result) {
                 filterGrid();
                 showMessage('User Registration', CURD_MESSAGE_STATUS.DS);

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
        .append($("<input name='screenName' type='text'>").val(screenTitle.split(" ").join('_')))
          .append($("<input name='spName' type='text'>").val("uspFM_EngTestingandCommissioningTxnSNF_Export"))
         .append($("<input name='exportType' type='text'>").val(exportType));

    $("body").append($downloadForm);
    var status = $downloadForm.submit();
    $downloadForm.remove();

}

function filterGrid() {
    var postDataValues = $("#grid").jqGrid('getGridParam', 'postData');
    // grab all the filter ids and values and add to the post object
    $('.filterItem').each(function (index, item) {
        postDataValues[$(item).attr('id')] = $(item).val();
    });
    $('#grid').jqGrid().setGridParam({ postData: postDataValues, page: 1 }).trigger('reloadGrid');
}