
$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    var primaryId = $('#primaryID').val();
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');

    //******************************** Load DropDown ***************************************

    $.get("/api/IndicatorMaster/Load")
   .done(function (result) {
       var loadResult = JSON.parse(result);
        $("#jQGridCollapse1").click();
       $.each(loadResult.IndicatorServiceTypeData, function (index, value) {
           $('#indicatorservice').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');          
       });
       $.each(loadResult.IndicatorGroupTypeData, function (index, value) {           
           $('#indicatorgroup').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
       });
       window.FrequencyLoadData = loadResult.IndicatorFrequencyTypeData
      
       $.each(loadResult.ItemData, function (index, value) {
           AddNewRowIndicatorMst();
           $("#hdnIndicatorDetId_" + index).val(loadResult.ItemData[index].IndicatorDetId);
           $("#IndicatorNo_" + index).val(loadResult.ItemData[index].IndicatorNo).prop("disabled", "disabled").attr('title', loadResult.ItemData[index].IndicatorNo);
           $("#IndicatorName_" + index).val(loadResult.ItemData[index].IndicatorName).prop("disabled", "disabled").attr('title', loadResult.ItemData[index].IndicatorName);
           $("#IndicatorDesc_" + index).val(loadResult.ItemData[index].IndicatorDesc).prop("disabled", "disabled").attr('title', loadResult.ItemData[index].IndicatorDesc);
           $('#frequency_' + index + ' option[value="' + loadResult.ItemData[index].Frequency + '"]').prop('selected', true);

       });
       $('#myPleaseWait').modal('hide');
       $("div.errormsgcenter").text("");
       $('#errorMsg').css('visibility', 'hidden');
   })
   .fail(function (response) {
       $('#myPleaseWait').modal('hide');
       $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
       $('#errorMsg').css('visibility', 'visible');
   });


    //************************************** GetById **************************************** No Need

    function getById(primaryId) {
        $.get("/api/IndicatorMaster/get/" + primaryId)
                .done(function (result) {
                    var result = JSON.parse(result);
                    BindGetByIdVal(result);
                    $('#myPleaseWait').modal('hide');
                })
                .fail(function (response) {
                    $('#myPleaseWait').modal('hide');
                    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                    $('#errorMsg').css('visibility', 'visible');
                });
    }


    //****************************************** Save *********************************************

    $("#btnSave").click(function () {
        $('#btnSave').attr('disabled', true);
        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var _index;
        $('#IndicatorMstTbl tr').each(function () {
            _index = $(this).index();
        });

        var result = [];
        for (var i = 0; i <= _index; i++) {

            var _IndicatorWO = {

                IndicatorId: $('#primaryID').val(),
                IndicatorDetId: $('#hdnIndicatorDetId_' + i).val(),
                IndicatorNo: $('#IndicatorNo_' + i).val(),
                IndicatorName: $('#IndicatorName_' + i).val(),
                IndicatorDesc: $('#IndicatorDesc_' + i).val(),
                Frequency: $('#frequency_' + i).val(),

                ItemId: 1,

            }
            result.push(_IndicatorWO);
        }
        //var timeStamp = $("#Timestamp").val();        
        var primaryId = $('#primaryID').val();
        var obj = {

            IndicatorId: primaryId,
            ServiceId: $('#indicatorservice').val(),
            Group: $('#indicatorgroup').val(),            
            IndicatorListData: result
        }

        var isFormValid = formInputValidation("KPIIndicatorMasterForm", 'save');
        
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            //$('#btnEdit').attr('disabled', false);
            return false;
        }
        else {


            var jqxhr = $.post("/api/IndicatorMaster/Save", obj, function (response) {
                var result = JSON.parse(response);
                BindGetByIdVal(result);
                $(".content").scrollTop(0);
                showMessage('Indicator Master', CURD_MESSAGE_STATUS.SS);
                $("#top-notifications").modal('show');

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
               errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
           }
           $("div.errormsgcenter").text(errorMessage);
           $('#errorMsg').css('visibility', 'visible');
           $('#btnSave').attr('disabled', false);
           //$('#btnEdit').attr('disabled', false);
           $('#myPleaseWait').modal('hide');

       });


        }
       
    });


 //******************** Back****************

    $("#btnCancel").click(function () {
        window.location.href = "";
    });
});


//****************************** AddNewRow **********************************************


function AddNewRowIndicatorMst() {

    var inputpar = {
        inlineHTML: ' <tr> <td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" id="IndicatorNo_maxindexval" class="form-control" maxlength="10"> <input type="hidden" id="hdnIndicatorDetId_maxindexval" value=0> </div></td><td width="25%" style="text-align: center;" data-original-title="" title=""> <div> <textarea type="text" id="IndicatorName_maxindexval" class="form-control wt-resize" style="max-width:initial; width:100%; max-length:255;"></textarea> </div></td><td width="50%" style="text-align: center;" data-original-title="" title=""> <div> <textarea type="text" id="IndicatorDesc_maxindexval" class="form-control wt-resize" style="max-width:initial; width:100%; max-length:500;"></textarea> </div></td><td width="15%" style="text-align: center;" data-original-title="" title=""> <div> <select id="frequency_maxindexval" class="form-control"></select> </div></td></tr> ',

        IdPlaceholderused: "maxindexval",
        TargetId: "#IndicatorMstTbl",
        TargetElement: ["tr"]

    }
    AddNewRowToDataGrid(inputpar);

    var rowCount = $('#IndicatorMstTbl tr:last').index();
    $.each(window.FrequencyLoadData, function (index, value) {
        $('#frequency_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
}

//********************************* Bind GetbyIdVal *********************************************

function BindGetByIdVal(result) {

    $('#primaryID').val(result.IndicatorId);
    $('#indicatorservice').val(result.ServiceId);
    $('#indicatorgroup').val(result.Group);

    $("#IndicatorMstTbl").empty();
    $.each(result.IndicatorListData, function (index, value) {
        AddNewRowIndicatorMst();
        $("#hdnIndicatorDetId_" + index).val(result.IndicatorListData[index].IndicatorDetId);
        $("#IndicatorNo_" + index).val(result.IndicatorListData[index].IndicatorNo).prop("disabled", "disabled").attr('title', result.IndicatorListData[index].IndicatorNo);
        $("#IndicatorName_" + index).val(result.IndicatorListData[index].IndicatorName).prop("disabled", "disabled").attr('title',result.IndicatorListData[index].IndicatorName);
        $("#IndicatorDesc_" + index).val(result.IndicatorListData[index].IndicatorDesc).prop("disabled", "disabled").attr('title',result.IndicatorListData[index].IndicatorDesc);
        $('#frequency_' + index + ' option[value="' + result.IndicatorListData[index].Frequency + '"]').prop('selected', true);

    });
    $('#myPleaseWait').modal('hide');
    //$("div.errormsgcenter").text("");
    //$('#errorMsg').css('visibility', 'hidden');
}
