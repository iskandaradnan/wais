$(document).ready(function () {
    $('#myPleaseWait').modal('show');

   
 //******************************** Load DropDown ***************************************

    $.get("/api/PenaltyMaster/Load")
   .done(function (result) {
       var loadResult = JSON.parse(result);
       $("#jQGridCollapse1").click();
       $.each(loadResult.PenaltyServiceTypeData, function (index, value) {
           $('#penaltyservice').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
       });
       $.each(loadResult.PenaltyCriteriaTypeData, function (index, value) {
           $('#penaltycriteria').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
       });
       window.StatusLoadData = loadResult.PenaltyStatusTypeData
       //AddNewRowPenaltyMst();
       
   })
   .fail(function () {
       $('#myPleaseWait').modal('hide');
       $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
       $('#errorMsg').css('visibility', 'visible');
   });   


    //****************************************** Save *********************************************

    $("#btnPenaltySave").click(function () {
        $('#btnPenaltySave').attr('disabled', true);
        //$('#btnEdit').attr('disabled', true);

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var _index;
        $('#PenaltyMstTbl tr').each(function () {
            _index = $(this).index();
        });    

        var result = [];
        for (var i = 0; i <= _index; i++) {

            var _PenaltyWO = {
                ServiceId: $('#penaltyservice').val(),
                CriteriaId: $('#penaltycriteria').val(),
                PenaltyId: $('#primaryID').val(),
                PenaltyDetId: $('#hdnPenaltyDetId_' + i).val(),
                PenaltyDescription: $('#event_' + i).val(),
                Status: $('#status_' + i).val(),
                ItemId: 1,
            }
            result.push(_PenaltyWO);
        }
        //var timeStamp = $("#Timestamp").val();        

        var obj = {

            PenaltyId: $('#primaryID').val(),
            ServiceId: $('#penaltyservice').val(),
            CriteriaId: $('#penaltycriteria').val(),
            PenaltyListData: result
        }

        var isFormValid = formInputValidation("KPIPenaltyMasterForm", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnPenaltySave').attr('disabled', false);
            //$('#btnEdit').attr('disabled', false);
            return false;
        }
        $('#myPleaseWait').modal('show');

        var jqxhr = $.post("/api/PenaltyMaster/Save", obj, function (response) {
            var result = JSON.parse(response);            
            $("#primaryID").val(result.PenaltyId);
            //$("#Timestamp").val(result.Timestamp);
            $(".content").scrollTop(0);
            showMessage('Penalty Master', CURD_MESSAGE_STATUS.SS);
            $('#btnPenaltySave').attr('disabled', false);
            //$('#btnEdit').attr('disabled', false);
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
            $("div.errormsgcenter").text(errorMessage).css('visibility', 'visible');
            $('#errorMsg').css('visibility', 'visible');

            $('#btnPenaltySave').attr('disabled', false);
            //$('#btnEdit').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
    });


    //******************************* Back *********************************************

    //$("#btnCancel").click(function () {
    //    window.location.href = "/KPI/PenaltyMaster";
    //});

    //************************************** GetByGridOnchange ****************************************

    $('#penaltycriteria,#penaltyservice').on('change', function () {
        var penaltycriteria = $('#penaltycriteria').val();
        var penaltyservice = $('#penaltyservice').val();
        // penaltyservice = parseInt(penaltyservice);                  Remove quotes

        if (penaltycriteria != "0" && penaltycriteria != "null" && penaltyservice != "0" && penaltyservice != "null") {
            $.get("/api/PenaltyMaster/getPenaltyList/" + penaltyservice + "/" + penaltycriteria)
                .done(function (result) {
                    var result = JSON.parse(result);
                    var penaltyList = result.PenaltyListData;
                    if (penaltyList == null || penaltyList == 0) {
                        PushEmptyMessage();
                    }
                        //$('#primaryID').val(result.PenaltyListData[0].PenaltyId);
                        // $('#penaltyservice').val(result.PenaltyListData[0].ServiceId);
                        // $('#penaltycriteria').val(result.PenaltyListData[0].CriteriaId);
                    else{
                    $("#PenaltyMstTbl").empty();
                    $.each(result.PenaltyListData, function (index, value) {
                        AddNewRowPenaltyMst();
                        $("#hdnPenaltyDetId_" + index).val(result.PenaltyListData[index].PenaltyDetId);
                        $("#event_" + index).val(result.PenaltyListData[index].PenaltyDescription).prop("disabled", "disabled");
                        $('#status_' + index + ' option[value="' + result.PenaltyListData[index].Status + '"]').prop('selected', true);
                    });
                }
                    $('#myPleaseWait').modal('hide');
                })
                .fail(function () {
                    $('#myPleaseWait').modal('hide');
                    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                    $('#errorMsg').css('visibility', 'visible');
                });
        }
        else {
            $("#PenaltyMstTbl").empty();
        }

    });



});

//****************************** AddNewRow **********************************************


function AddNewRowPenaltyMst() {

    var inputpar = {
        inlineHTML: ' <tr> <td width="10%" style="text-align:center;" title=""> <div> <input type="hidden" id="slno_maxindexval" style="text-align:center" maxlength="" class="form-control"> <input type="hidden" id="hdnPenaltyDetId_maxindexval" value=0> </div></td><td width="75%" style="text-align: center;" title=""> <div> <textarea type="text" id="event_maxindexval" class="form-control wt-resize" style="max-width:initial; width:100%; max-length:500;"></textarea> </div></td><td width="15%" style="text-align: center;" title=""> <div> <select id="status_maxindexval" class="form-control" maxlength="10"></select> </div></td></tr> ',

        IdPlaceholderused: "maxindexval",
        TargetId: "#PenaltyMstTbl",
        TargetElement: ["tr"]

    }
    AddNewRowToDataGrid(inputpar);

    var rowCount = $('#PenaltyMstTbl tr:last').index();
    $.each(window.StatusLoadData, function (index, value) {
        $('#status_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
}

function PushEmptyMessage() {
    $("#PenaltyMstTbl").empty();
    var emptyrow = '<tr><td width="100%"><h5 class="text-center">No records to display</h5></td></tr>'
    $("#PenaltyMstTbl ").append(emptyrow);
}



