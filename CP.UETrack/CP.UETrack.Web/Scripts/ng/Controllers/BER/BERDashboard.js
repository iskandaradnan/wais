var pageindex = 1, pagesize = 5;
var GridtotalRecords = 0;
var TotalPages = 0, FirstRecord = 0, LastRecord = 0;

$(document).ready(function () {

    $('#myPleaseWait').modal('show');

    $.get("/api/BERDashboard/Load/")
       .done(function (result) {
           var getResult = JSON.parse(result);


           PendingItems(getResult);


           //var primaryId = $('#primaryID').val();
           //if (primaryId != null && primaryId != "0") {
           //$.get("/api/BERDashboard/LoadGrid/" + pagesize + "/" + pageindex)
           //      .done(function (result) {
           //          var getResult = JSON.parse(result);

           //          GetBerDashboardGridData(getResult);

           //          $('#myPleaseWait').modal('hide');
           //      })
           //     .fail(function () {
           //         $('#myPleaseWait').modal('hide');
           //         $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
           //         $('#errorMsg').css('visibility', 'visible');
           //     });
           //}
           //else {
           //    $('#myPleaseWait').modal('hide');
           //}
       })
 .fail(function () {
     $('#myPleaseWait').modal('hide');
     var errorMessage = '';
     $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
     $('#errorMsg').css('visibility', 'visible');
 });

});

/************************************ Get Pending Items ***************************************************/
function PendingItems(getResult) {

    $("#FistDivCount").text(getResult.FacMAnCount);
    $("#FistDivStatus").text(getResult.FacilityManager);
   
    $("#hdnFacilityManStsId").val(getResult.FacilityManagerSts);
    //var array = [];
    //var arr = [];

    //if (getResult.FacMAnCount > 0) {
    //    array = (getResult.FacilityManagerSts).split(",");

    //    var FacManSts;
    //    for (i = 0; i < array.length; i++) {

    //        var sts1 = array[i];
    //        arr.push(parseInt(sts1));

    //        //var FacManSts+i = array[i];
    //        FacManSts +=''+ i;

    //        this["FacManSts" + i] = (parseInt(sts1));
    //        //alert(FacManSts + i);
    //    }


    //}

 

    $("#SecDivCount").text(getResult.HosDirCount);
    $("#SecDivStatus").text(getResult.HospDir);
    $("#hdnHospDirStsId").val(getResult.HospDirSts);

    $("#ThirdDivCount").text(getResult.LiaOffCount);
    $("#ThirdivStatus").text(getResult.LiasonOff);
    $("#hdnLiaOffStsId").val(getResult.LiasonOffSts);
}




/************************************ Get Dashboard Grid ***************************************************/

//function GetBerDashboardGridData(getResult) {

//    $("#BerDashboardGrid").empty();

//    //$("#BerDashboardGrid").append('<tr><td colspan="4"><h4 class="text-center">No records to display</h4></td></tr>');

//    $.each(getResult.BERDashboardGridData, function (index, value) {
//        BERDashboardNewRow();
//        $("#BerDashNo_" + index).val(getResult.BERDashboardGridData[index].BerNo);
//        $("#BerDashStatus_" + index).val(getResult.BERDashboardGridData[index].BerStatus);
//        $("#BerDashDate_" + index).val(DateFormatter(getResult.BERDashboardGridData[index].RenewalDate));
//    });


//    if ((getResult.BERDashboardGridData && getResult.BERDashboardGridData.length) > 0) {
//        //ParameterMappingId = getResult.ParameterMappingId;
//        GridtotalRecords = getResult.BERDashboardGridData[0].TotalRecords;
//        TotalPages = getResult.BERDashboardGridData[0].TotalPages;
//        LastRecord = getResult.BERDashboardGridData[0].LastRecord;
//        FirstRecord = getResult.BERDashboardGridData[0].FirstRecord;
//        pageindex = getResult.BERDashboardGridData[0].PageIndex;
//    }

//    var mapIdproperty = ["BerNo-BerDashNo_", "BerStatus-BerDashStatus_", "RenewalDate-BerDashDate_-date"];
//    var htmltext = BERDashboardHtml();//Inline Html
//    var obj = { formId: "#BERDashboard", PageNumber: pageindex, flag: "BerDashboard", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "BERDashboardGridData", tableid: '#BerDashboardGrid', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/BERDashboard/LoadGrid", pageindex: pageindex, pagesize: pagesize };

//    CreateFooterPagination(obj)
//}

//function BERDashboardNewRow() {
//    var inputpar = {
//        inlineHTML: BERDashboardHtml(),
//        IdPlaceholderused: "maxindexval",
//        TargetId: "#BerDashboardGrid",
//        TargetElement: ["tr"]
//    }
//    AddNewRowToDataGrid(inputpar);
//}

//function BERDashboardHtml() {
//    return '<tr><td width="40%" style="text-align:center;"><div> <input type="text" id="BerDashNo_maxindexval" class="form-control borderNone" style="max-width:100%" readonly></div></td>' +
//                '<td width="40%" style="text-align:left;"><div> <input type="text" id="BerDashStatus_maxindexval" class="form-control borderNone" style="max-width:100%" readonly></div></td>' +
//                '<td width="20%" style="text-align:left;"><div> <input type="text" id="BerDashDate_maxindexval" class="form-control borderNone" style="max-width:100%" readonly></div></td>';
//}


/************************************ Get Dashboard Grid END***************************************************/



function Redirect(Flag) {
    window.location.replace("/ber/ber1application/index?" + Flag);
}



