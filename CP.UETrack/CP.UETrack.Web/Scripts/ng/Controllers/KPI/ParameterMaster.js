$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    var loadResult = null;
    //******************************** Load DropDown ***************************************

    $.get("/api/ParameterMaster/Load")
   .done(function (result) {
       loadResult = JSON.parse(result);
       $("#jQGridCollapse1").click();
       $.each(loadResult.ParameterServiceTypeData, function (index, value) {
           $('#parameterservice').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
       });
       $.each(loadResult.ParameterGroupTypeData, function (index, value) {
           $('#parametergroup').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');          
       });       
       $.each(loadResult.ParameterIndicatorNoTypeData, function (index, value) {
           $('#parameterindicatorno').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
           
       });
       
   })
   .fail(function (response) {
       $('#myPleaseWait').modal('hide');
       $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
       $('#errorMsg').css('visibility', 'visible');
   });
    

    //******************************* Back ************************************

    $("#btnCancel").click(function () {
        var message = Messages.Reset_Alert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                EmptyFields();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });
});


//****************************** AddNewRow **********************************************


function AddNewRowParameterMst() {

    var inputpar = {
        inlineHTML: ' <tr> <td width="10%" style="text-align: center;" title=""> <div> <input type="hidden" class="form-control" id="slno_maxindexval" maxlength="3" readonly="readonly"> </div></td><td width="90%" style="text-align: center;" title=""> <div> <textarea type="text" id="parameter_maxindexval" class="form-control wt-resize" readonly style="width:100%; max-length:500;"></textarea> </div></td></tr> ',

        IdPlaceholderused: "maxindexval",
        TargetId: "#ParameterMstTbl",
        TargetElement: ["tr"]

    }
    AddNewRowToDataGrid(inputpar);    
}


//************************************** GetByGridOnchange ****************************************

$('#parameterservice,#parameterindicatorno').on('change', function () {   
    var parameterservice = $('#parameterservice').val();
    var parameterindicator = $('#parameterindicatorno').val();    
    var parametergroup = $('#parametergroup').val();
    if (parameterservice == 2 && parameterindicator != 0 && parametergroup != 0) {
       
        $.get("/api/ParameterMaster/getParameterList/" + parameterservice + "/" + parameterindicator)
            .done(function (result) {
                var result = JSON.parse(result);
                $('#parameterindicatordesc').val("");
                $("#ParameterMstTbl").empty();
                //$('#primaryID').val(result.ParameterListData[0].SubParameterId);
                //$('#parameterservice').val(result.ParameterListData[0].ServiceId);
                // $('#parameterindicatorno').val(result.ParameterListData[0].IndicatorDetId);
                //$('#parametergroup').val(result.ParameterListData[0].Group);
                $('#parameterindicatordesc').val(result.IndicatorDesc);

                var parameterList = result.ParameterListData;
                if (parameterList == null || parameterList==0) {
                    PushEmptyMessage();
                }
                else {

                    $("#ParameterMstTbl").empty();
                    $.each(result.ParameterListData, function (index, value) {

                        AddNewRowParameterMst();
                        //$("#slno_" + index).val(result.ParameterListData[index].SubParameterDetId).prop("disabled", "disabled");
                        $("#parameter_" + index).val(result.ParameterListData[index].SubParameter).prop("disabled", "disabled").attr('title', result.ParameterListData[index].SubParameter);

                    });

                    $('#myPleaseWait').modal('hide');
                }
            })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsg').css('visibility', 'visible');
            });


    }
    else {

        //var result = JSON.parse(result);
        //$('#primaryID').val(result.ParameterListData[0].SubParameterId);
        //$('#parameterservice').val(result.ParameterListData[0].ServiceId);
        //$('#parameterindicatorno').val(result.ParameterListData[0].IndicatorDetId);
        //$('#parametergroup').val(result.ParameterListData[0].Group);
        //$('#parameterindicatordesc').val(result.IndicatorDesc);

        $('#parameterindicatordesc').val("");
        $("#ParameterMstTbl").empty();


    }

});

function PushEmptyMessage() {    
    $("#ParameterMstTbl").empty();
    var emptyrow = '<tr class="norecord"><td width="100%"><h5 class="text-center">No records to display</h5></td></tr>'
    $("#ParameterMstTbl ").append(emptyrow);
}

function EmptyFields() {
    $("#ParameterMstTbl").empty();
    $("#parameterindicatordesc").val("");          
    $('select option:contains("Select")').prop('selected', true);
}