$(document).ready(function () {

    //var qs = window.location.href;
    //if (qs != null && qs.split('?').length > 1) {
    //    qs = qs.split('?')[1].split('=');
    //    if (qs[0] == 'op') {
    //        if (qs[1] == 's') {
    //            //$("#top-notifications").modal('show');
    //            //$('#msg').addClass("success");
    //            //$('#hdr1').html("The user has been unblocked successfully");
    //            //setTimeout(function () {
    //            //    $("#top-notifications").modal('hide');
    //            //}, 5000);
    //            showMessage('User Role', CURD_MESSAGE_STATUS.UUB);
    //            //$("#top-notifications").modal('show');
    //            //setTimeout(function () {
    //            //    $("#top-notifications").modal('hide');
    //            //}, 5000);
    //        }
    //    }
    //}
 
    var result = document.cookie;
    if (result.indexOf('unblock=true') != -1)
    {
        document.cookie = 'unblock=; expires=Thu, 01 Jan 1970 00:00:00 UTC;path=/';
        showMessage('User Role', CURD_MESSAGE_STATUS.UUB);
    }
});



$(function () {
    var StatusValues = "Active:Active;Inactive:Inactive;";
    var UserTypeValues = "Company Admin User:Company Admin User;Company User:Company User;External User:External User;Facility User:Facility User;";
    genarateGrid(StatusValues, UserTypeValues);
});

function genarateGrid(statusValues, userTypeValues) {
    var isFromSave = false;
    var gridClicked = false;
    var hasAddPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Add'");

    var StatusValues = statusValues.replace(/[,;]$/, '').toString();
    var UserTypeValues = userTypeValues.replace(/[,;]$/, '').toString();
    var grid = $("#grid"),
    prmSearch = { multipleSearch: true, overlay: false };
    grid.jqGrid({
        url: "/api/unblockUser/GetAll",
        datatype: 'json',
        mtype: 'Get',
        ajaxGridOptions: { contentType: 'application/json; charset=utf-8' },
        colNames: ['Id', 'Customer Name', 'Staff Name', 'Username',  'User Type', 'Email', 'Status'],
        colModel: [
            { key: true, hidden: true, name: 'UserRegistrationId', width: '0%' },
            { key: false, search: true, name: 'CustomerName', width: '15%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'StaffName', width: '15%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'UserName', width: '15%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, name: 'UserTypeValue', width: '15%', stype: "select", searchoptions: { sopt: ["eq", "ne"], value: UserTypeValues, defaultValue: "Company Admin User" } },
            { key: false, search: true, name: 'Email', width: '15%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, name: 'StatusValue', width: '10%', stype: "select", searchoptions: { sopt: ["eq", "ne"], value: StatusValues, defaultValue: "Active" } },
            //{ name: 'edit', search: false, index: 'UserRegistrationId', width: '5%', sortable: false, formatter: editLink },
            //{ name: 'view', search: false, index: 'UserRegistrationId', width: '5%', sortable: false, formatter: viewLink },

        ],

        pager: jQuery('#pager'),
        rowNum: 5,
        rowList: [5, 10, 20, 50],
        height: 'auto',
        width: '100%',
        viewrecords: true,
        //caption: 'Unblock User',
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
                $("#ExporttoCSV").addClass('ui-state-disabled');
            }
            $('#refresh_grid_top').hide();
            $('#btnSave').hide();
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
        multiselect: true,
        toppager: true,
        toolbar: [true, "top"]
    }).navGrid('#pager', { cloneToTop: true, edit: false, add: false, del: false, search: false, refresh: true },
        {
            multipleSearch: true,
            multipleGroup: true,
        })

             .navButtonAdd('#pager_left', {
                 id: "refresh_grid_top",
                 caption: "",
                 buttonicon: "ui-icon-refresh1",
                 onClickButton: function () {
                     // $("#grid").trigger('reloadGrid');
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

    return "<a href='/um/unblockuser/edit/" + rowObject.UserRegistrationId + "' class='glyphicon glyphicon-edit' style='color:#477ca9;font-size: 13px;'></a>";
}
function escapeShowTitle(title) {

    title = title.replace(/\\([\s\S])|(")/g, "\\$1$2");
    title = escape(title)
    return title
}

function viewLink(cellValue, options, rowObject, action) {
    return "<a href='/um/unblockuser/view/" + rowObject.UserRegistrationId + "' class='glyphicon glyphicon-eye-open' style='color:#477ca9;font-size: 13px;'></a>";
}

function Export(exportType) {

    var grid = $('#grid');
    var filters = grid.getGridParam('postData').filters;
    var sortColumnName = $("#grid").jqGrid('getGridParam', 'sortname');
    var sortOrder = $("#grid").jqGrid('getGridParam', 'sortorder');
    var mymodel = $("#grid").getGridParam('colModel')

    var $downloadForm = $("<form method='POST'>")
         .attr("action", "/api/common/Export")
         .append($("<input name='filters' type='text'>").val(filters))
         .append($("<input name='sortOrder' type='text'>").val(sortOrder))
        .append($("<input name='sortColumnName' type='text'>").val(sortColumnName))
        .append($("<input name='screenName' type='text'>").val("Unblock_User"))
          .append($("<input name='spName' type='text'>").val("uspFM_UMBlockedUsers_Export"))
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