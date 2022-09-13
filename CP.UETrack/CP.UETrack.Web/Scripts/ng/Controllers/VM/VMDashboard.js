$(document).ready(function () {


    //***************************************** Load DropDown ******************************************

    $.get("/api/VMDashboard/Load")
   .done(function (result) {
       var loadResult = JSON.parse(result);
       var date = new Date();
       var month = date.getMonth();
       var currentMonth = month + 1;

       $.each(loadResult.VMDashboardServiceTypeData, function (index, value) {
           $('#VMDashService').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
       });

       $.each(loadResult.Years, function (index, value) {
           $('#VMDashYear').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
       });
       $('#VMDashYear').val(loadResult.CurrentYear);

       $.each(loadResult.MonthListTypedata, function (index, value) {
           $('#VMDashMonth').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
       });
       $('#VMDashMonth option[value="' + currentMonth + '"]').prop('selected', true);

       var VMyear = $('#VMDashYear').val();
       var VMmonth = $('#VMDashMonth').val();
       getByVMDashboard(VMyear, VMmonth);

       var primaryId = $('#primaryID').val();
       if (primaryId != null && primaryId != "0") {
           getById(Year);

       }
       else {
           $('#myPleaseWait').modal('hide');

       }
   })
   .fail(function (response) {
       $('#myPleaseWait').modal('hide');
       var errorMessage = '';
       $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
       $('#errorMsg').css('visibility', 'visible');
   });

});



//****************************************** AddNewRow **********************************************

function AddNewRowVMDashboard() {

    var inputpar = {
        inlineHTML: ' <tr> <input type="hidden" id="hdnVMdashDetId_maxindexval"> <td width="60%" style="text-align: center;" title="Status"> <div> <input type="text" class="form-control" id="VMDashStatus_maxindexval" readonly="readonly"> </div></td><td width="40%" style="text-align: center;" title="Count"> <div> <input type="text" class="form-control" id="VMDashCount_maxindexval" readonly="readonly"> </div></td></tr> ',

        IdPlaceholderused: "maxindexval",
        TargetId: "#VMDashboardTbl",
        TargetElement: ["tr"]

    }
    AddNewRowToDataGrid(inputpar);
}


//************************************** Onchange Year & Month ***************************************


$('#VMDashYear,#VMDashMonth').on('change', function () {

    var vmyear = $('#VMDashYear').val();
    var vmmonth = $('#VMDashMonth').val();

    if (vmyear != '0' && vmyear != 'null' && vmmonth != '0' && vmmonth != 'null') {
        getByVMDashboard(vmyear, vmmonth);
    }
    else {
        $("#VMDashboardTbl").empty();
        $('#myPleaseWait').modal('hide');
    }
});

function getByVMDashboard(vmyear, vmmonth) {
    $.get("/api/VMDashboard/GetDate/" + vmyear + "/" + vmmonth)
            .done(function (result) {
                var loadResult = JSON.parse(result);

                $('#VMDashYear option[value="' + loadResult.Year + '"]').prop('selected', true);
                $('#VMDashMonth option[value="' + loadResult.Month + '"]').prop('selected', true);

                $("#VMDashboardTbl").empty();
                $.each(loadResult.VMDashboardListData, function (index, value) {
                    AddNewRowVMDashboard();
                    $("#hdnVMdashDetId_" + index).val(loadResult.VMDashboardListData[index].VMDashboardId);
                    $("#VMDashStatus_" + index).val(loadResult.VMDashboardListData[index].StatusName).prop("disabled", "disabled");
                    $("#VMDashCount_" + index).val(loadResult.VMDashboardListData[index].TotalCount).prop("disabled", "disabled");                    
                });
                $('#myPleaseWait').modal('hide');
            })
            .fail(function () {
                $('#myPleaseWait').modal('hide');
                var errorMessage = '';
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');
            });
}