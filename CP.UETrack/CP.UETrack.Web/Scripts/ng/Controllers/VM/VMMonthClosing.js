$(document).ready(function () {
    $.get("/api/VMMonthClosingAPI/Load")
     .done(function (result) {
         var loadResult = result;


         $.each(loadResult.FMTimeMonth, function (index, value) {
             $('#selVariationMonth').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
         });
         $.each(loadResult.Yearlist, function (index, value) {
             $('#selVariationYear').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
         });
         $("#selVariationYear").val(result.CurrentYear);
         $("#selVariationMonth").val(result.PreviousMonth);

         //$("#CutOffDate").val(moment(result.CutoffDate).format("DD-MMM-YYYY")); 
         $("#CutOffDate").val(result.CutoffDate);
         var getobj = { PageSize: null, Flag: '', PageIndex: null, ServiceId: 2, Month: $("#selVariationMonth").val(), Year : $("#selVariationYear").val()};


         var jqxhr = $.post("/api/VMMonthClosingAPI/Get", getobj, function (response) {
             var result = JSON.parse(response);

             var VariationList = result.VariationList
             $(VariationList).each(function (index, data) {
                 if (data.VariationStatus == "V1 - Existing")
                 {
                     $("#V1Authorizedid").text(data.Authorised);
                     $("#V1Unuthorizedid").text(data.UnAuthorised);
                     //if (data.Authorised == 0)
                     //{
                     //    $("#V1Authorizeszero").hide();
                     //    $("#V1AuthorizesNotzero").show();
                     //}
                     //else
                     //{
                     //   $("#V1Authorizeszero").show();
                     //    $("#V1AuthorizesNotzero").hide();
                     //}
                     //if (data.UnAuthorised == 0) {
                     //    $("#V1Unuthorizeszero").show();
                     //    $("#V1UnuthorizesNotzero").hide();
                     //}
                     //else {
                     //    $("#V1Unuthorizeszero").hide();
                     //    $("#V1UnuthorizesNotzero").show();
                     //}

                 }
                 else if (data.VariationStatus == "V2 - Addition") {
                     $("#V2Authorizedid").text(data.Authorised);
                     $("#V2Unuthorizedid").text(data.UnAuthorised);
                     //if (data.Authorised == 0) {
                     //    $("V2Authorizeszero").show();
                     //    $("V2AuthorizesNotzero").hide();
                     //}
                     //else {
                     //    $("V2Authorizeszero").hide();
                     //    $("V2AuthorizesNotzero").show();
                     //}

                 }
                 else if (data.VariationStatus == "V3 - Deletion") {
                     $("#V3Authorizedid").text(data.Authorised);
                     $("#V3Unuthorizedid").text(data.UnAuthorised);
                     //if (data.Authorised == 0) {
                     //    $("V3Authorizeszero").show();
                     //    $("V3AuthorizesNotzero").hide();
                     //}
                     //else {
                     //    $("V3Authorizeszero").hide();
                     //    $("V3AuthorizesNotzero").show();
                     //}


                 }
                 else if (data.VariationStatus == "V4 - BER") {
                     $("#V4Authorizedid").text(data.Authorised);
                     $("#V4Unuthorizedid").text(data.UnAuthorised);
                     //if (data.Authorised == 0) {
                     //    $("V4Authorizeszero").show();
                     //    $("V4AuthorizesNotzero").hide();
                     //}
                     //else {
                     //    $("V4Authorizeszero").hide();
                     //    $("V4AuthorizesNotzero").show();
                     //}


                 }
                 else if (data.VariationStatus == "V5 - Transfer From") {
                     $("#V5Authorizedid").text(data.Authorised);
                     $("#V5Unuthorizedid").text(data.UnAuthorised);
                     //if (data.Authorised == 0) {
                     //    $("V5Authorizeszero").show();
                     //    $("V5AuthorizesNotzero").hide();
                     //}
                     //else {
                     //    $("V5Authorizeszero").hide();
                     //    $("V5AuthorizesNotzero").show();
                     //}


                 }
                 else if (data.VariationStatus == "V6 - Transfer To") {
                     $("#V6Authorizedid").text(data.Authorised);
                     $("#V6Unuthorizedid").text(data.UnAuthorised);
                     //if (data.Authorised == 0) {
                     //    $("V6Authorizeszero").show();
                     //    $("V6AuthorizesNotzero").hide();
                     //}
                     //else {
                     //    $("V6Authorizeszero").hide();
                     //    $("V6AuthorizesNotzero").show();
                     //}


                 }
                 else if (data.VariationStatus == "V7 - Upgrade") {
                     $("#V7Authorizedid").text(data.Authorised);
                     $("#V7Unuthorizedid").text(data.UnAuthorised);
                     //if (data.Authorised == 0) {
                     //    $("V7Authorizeszero").show();
                     //    $("V7AuthorizesNotzero").hide();
                     //}
                     //else {
                     //    $("V7Authorizeszero").hide();
                     //    $("V7AuthorizesNotzero").show();
                     //}


                 }
                 else if (data.VariationStatus == "V8 - Donated by others") {
                     $("#V8Authorizedid").text(data.Authorised);
                     $("#V8Unuthorizedid").text(data.UnAuthorised);
                     //if (data.Authorised == 0) {
                     //    $("V8Authorizeszero").show();
                     //    $("V8AuthorizesNotzero").hide();
                     //}
                     //else {
                     //    $("V8Authorizeszero").hide();
                     //    $("V8AuthorizesNotzero").show();
                     //}


                 }
                
             })

             $('#myPleaseWait').modal('hide');
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

     })
   .fail(function () {
       $('#myPleaseWait').modal('hide');
       $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
       $('#errorMsg').css('visibility', 'visible');
   });
})


function PopUpAuthorizeCount(str)
{
    //$scope.PopUpVoStatus = $scope.FetchResult[idx].VariationName;
    var VariationStausID = str;

    var Status = "Authorised";

    $("#thirdIndex").children().remove()
    $("#thirdIndex").append('<table id="grid"></table>')
    $("#thirdIndex").append('<div id="pager"></div>')
    genarateGrid(VariationStausID, Status);
}

function PopUpUnAuthorizeCount(str)
{
   // $scope.PopUpVoStatus = $scope.FetchResult[idx].VariationName;
    var VariationStausID = str;
   
    var Status = "UnAuthorised";

    $("#thirdIndex").children().remove()
    $("#thirdIndex").append('<table id="grid"></table>')
    $("#thirdIndex").append('<div id="pager"></div>')
    genarateGrid(VariationStausID, Status);
}
//----------------------------jQGrid Begin-----------------------------------------------------------------------------------------------//////
function genarateGrid(VariationStausID,  Status) {

    var VarVariationID = VariationStausID;

  
    var ISMonthClose = 1;
   // var AssetClassificationID = $scope.Service == 3 ? 0 : $scope.Clasification;
    var ServiceId = 2;
    var DateValue = new Date($('#selVariationYear').val(), $('#selVariationMonth').val() , 0);
    var VariationLastdateOfMonth = DateValue.toString("dd-MMM-yyyy");
    var WhereCondition = [
                               { field: "ServiceId", op: "eq", data: ServiceId },
                           { field: "VariationStatus", op: "eq", data: VarVariationID },
                         //   { field: "VariationMonth", op: "le", data: MonthFinal },
                         //  { field: "VariationYear", op: "le", data: YearFinal },
                         //{ field: "VariationRaisedDate", op: "le", data: VariationLastdateOfMonth },
                            //{ field: "VariationYear", op: "eq", data: YearFinal },
                             //{ field: "AssetClassificationID", op: "eq", data: AssetClassificationID },
                          // { field: "IsMonthClosed", op: "ne", data: true }  // ISMonthClosed not Closed

    ];

    if (Status == "Authorised") {
        WhereCondition = [
                           { field: "ServiceId", op: "eq", data: ServiceId },
                           { field: "VariationStatus", op: "eq", data: VarVariationID },
                        //  { field: "VariationMonth", op: "le", data: MonthFinal },
                         //  { field: "VariationYear", op: "le", data: YearFinal },
                         //{ field: "VariationRaisedDate", op: "le", data: VariationLastdateOfMonth },
                           // { field: "AssetClassificationID", op: "eq", data: AssetClassificationID },
                          // { field: "IsMonthClosed", op: "ne", data: true },  // ISMonthClosed not Closed
                            { field: "AuthorizedStatus", op: "eq", data: true }   // Take Only AuthorizedStatus
        ];
    }
    else if (Status == "UnAuthorised") {
        WhereCondition = [
                             { field: "ServiceId", op: "eq", data: ServiceId },
                           { field: "VariationStatus", op: "eq", data: VarVariationID },
                         // { field: "VariationMonth", op: "le", data: MonthFinal },
                         //  { field: "VariationYear", op: "le", data: YearFinal },
                         // { field: "VariationRaisedDate", op: "le", data: VariationLastdateOfMonth },

                           // { field: "AssetClassificationID", op: "eq", data: AssetClassificationID },
                          // { field: "IsMonthClosed", op: "ne", data: true },  // ISMonthClosed not Closed
                            { field: "AuthorizedStatus", op: "eq", data: false }  // Take Only UnAuthorizedStatus
        ];

    }




    var AssetNoOrUserAreaCode =  "Asset No.";
    var AssetDescriptionOrUserAreaName =  "Asset Description";




    var grid = $("#grid"),

    prmSearch = { multipleSearch: true, overlay: false };
    grid.jqGrid({
        url: "/api/VMMonthClosingAPI/getall",
        datatype: 'json',
        mtype: 'Get',
        ajaxGridOptions: {
            contentType: 'application/json; charset=utf-8',
            complete: function (data) {
            }
        },
        colNames: [AssetNoOrUserAreaCode, AssetDescriptionOrUserAreaName, 'SNF Reference No.', 'VariationStatusName'],
        colModel: [
             //{ key: true, hidden: true, key: true, name: 'AccreditationId', width: '0%' },
            { key: false, name: 'AssetNo', width: '25%', resizable: false, searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, name: 'AssetDescription', width: '25%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
              { key: false, name: 'SNFDocumentNo', width: '25%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] }, formatter: printLink },

            { key: false, hidden: true, name: 'VariationStatusName', width: '24%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },



        ],

        pager: jQuery('#pager'),
        rowNum: Messages.PAGE_GRID_ROWNUM_DEFAULT,
        rowList: Messages.PAGE_GRID_ROWLIST,
        height: 'auto',
        width: '100%',
        viewrecords: true,
        caption: 'Variation Month Closing Details',
        sortname: 'AssetNo',
        sortorder: 'desc',
        postData: {
            defaultFilters: JSON.stringify({
                groupop: "and",
                rules: WhereCondition

            }), Flag: Status, Year: $('#selVariationYear').val(), Month: $('#selVariationMonth').val(), ServiceId: 2,  VariationStatus: VariationStausID
        },
        excel: true,
        subGrid: false,
        subGridOptions: {
            "plusicon": "ui-icon-triangle-1-e", "minusicon": "ui-icon-triangle-1-s", "openicon": "ui-icon-arrowreturn-1-e",
            "reloadOnExpand": false,
            "selectOnExpand": true
        },
        loadError: function (responce) {
            if (responce.status == 404) {
                $(this).clearGridData();
            }
            if ($('#sp_1_pager').text() == "0") {
                $("#sp_1_pager").text("1");
                $("#next_pager").addClass('ui-state-disabled');
                $("#last_pager").addClass('ui-state-disabled');
            }
        },
        loadComplete: function (data) {
            $('#pager_left').attr('style', 'left: 30px')
            if ($('#sp_1_pager').text() == "0") {
                $("#sp_1_pager").text("1");
                $("#next_pager").addClass('ui-state-disabled');
                $("#last_pager").addClass('ui-state-disabled');


            }
        },
        emptyrecords: Messages.EMPTY_RECORD,
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
        //toolbar: [true, "top"]
    }).navGrid('#pager', { cloneToTop: true, edit: false, add: false, del: false, search: false, refresh: false },
        {
            multipleSearch: true,
            multipleGroup: true,
        }
        )





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
    $("#searchmodfbox_grid").hide();
}

function printLink(cellValue, options, rowObject, action) {
    return "<a onclick='printSNF(" + rowObject.SNFDocumentId + ")' target='_blank' style='color:blue;  text-decoration:underline;cursor: pointer;'>" + rowObject.SNFDocumentNo + "</a>";
}

//////////////////-----------jQGrid END-----------------------------------------------------------------------------------------------//////


function MonthSubmit()
{
    var postobj = { Month: $("#selVariationMonth").val(), Year: $("#selVariationYear").val() }

    var jqxhr = $.post("/api/VMMonthClosingAPI/MonthClose", postobj, function (response) {
      
        showMessage('Month closing', CURD_MESSAGE_STATUS.SS);
        $("#top-notifications").modal('show');
        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);
        $('#btnSave').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
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
function printSNF(SNFid) {

    window.open('/RdlReports/Common/CommonRptViewer.aspx?Rdl=VM_SNF&Module=VM&SNFId=' + SNFid, 'SNF REPORT', 'width=680,height=600,scrollbars=yes, resizable=no');
}