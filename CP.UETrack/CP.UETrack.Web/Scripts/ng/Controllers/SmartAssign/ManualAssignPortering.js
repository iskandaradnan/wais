var pageindex = 1, pagesize = 5;
var GridtotalRecords = 0;
var TotalPages = 0, FirstRecord = 0, LastRecord = 0;
var LOVData = {};

var ActionType = $('#ActionType').val();

$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    formInputValidation("MAPortering");
    $('#btnDelete').hide();
   // $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $.get("/api/ManualAssignPortering/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#jQGridCollapse1").click();
            //$('#btnSave').show();
            //$('#btnEdit').hide();
            //$("#btnSave").prop("disabled", true);
            
        })
  .fail(function () {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
      $('#errorMsg').css('visibility', 'visible');
  });

    //****************************************** Save *********************************************

    $("#btnSave, #btnEdit,#btnSaveandAddNew").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');
        var CurrentbtnID = $(this).attr("Id");
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');


        var porteringId = $('#primaryID').val();
        var hdnAssigneId = $('#hdnMAPAssingnId').val();
       // var timeStamp = $("#Timestamp").val();



        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            PorteringId = primaryId;
        }
        else {
            PorteringId = 0;
        }

 

        var isFormValid = formInputValidation("MAPortering", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        if (hdnAssigneId == '') {
            DisplayErrorMessage("Valid Assign is required.");
            return false;
        }

        var obj = {
            PorteringId: PorteringId,
            MAPAssigneId: hdnAssigneId
        }

        function DisplayErrorMessage(errorMessage) {
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }


        var jqxhr = $.post("/api/ManualAssignPortering/Save", obj, function (response) {
            var result = JSON.parse(response);
            $("#btnEdit").prop("disabled", true);
           // GetSMPBind(result);
            $('#btnEdit').hide();
            $('#btnSave').hide();
            $(".content").scrollTop(0);
            showMessage('CRM Workorder Assessment', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);
            $("#grid").trigger('reloadGrid');

            $('#btnSaveAssm').attr('disabled', false);
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
            $('#errorMsgAssm').css('visibility', 'visible');

            $('#btnSaveAssm').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });

    });


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
    $("#jQGridCollapse1").click(function () {
        // $(".jqContainer").toggleClass("hide_container");
        var pro = new Promise(function (res, err) {
            $(".jqContainer").toggleClass("hide_container");
            res(1);
        })
        pro.then(
            function resposes() {
                setTimeout(() => $(".content").scrollTop(3000), 1);
            })
    })
});

function GetSMPBind(getResult) {
    $("#btnSave").prop("disabled", false);
    $("#btnEdit").prop("disabled", false);
    var primaryId = $('#primaryID').val();
    $("#MAPtxtAssignee").prop("disabled", false);
    $("#primaryID").val(getResult.PorteringId);
    $("#MAPtxtAssetNo").val(getResult.AssetNo);
   // $("#hdnMAPAssetId").val(getResult.AssetTypeCodeId);
    $("#MAPtxtMaintenanceWorkNo").val(getResult.WorkOrderNo);

    $("#MAPPorteringNo").val(getResult.PorteringNo);
    $("#MAPPorteringDate").val(moment(getResult.PorteringDate).format("DD-MMM-YYYY"));
    $("#MAPFromFacilityName").val(getResult.FacilityName);
    $("#MAPFromBlockName").val(getResult.BlockName);
    $("#MAPFromLevelName").val(getResult.LevelName);
    $("#MAPFromUserAreaName").val(getResult.UserAreaName);
    $('#MAPFromUserLocationName').val(getResult.UserLocationName);


    if (ActionType == "VIEW") {
        $("#EODParamMappingScreen :input:not(:button)").prop("disabled", true);
        //$("#addnewrowbtn,#savebtn,#uploadbtn,#exportbtn,#addnewbtn").hide();
    }

}


function FetchAssigne(event) {
    $('#divAssigneeFetch').css({
        'width': $('#MAPtxtAssignee').outerWidth()
    });
    var ItemMst = {
        SearchColumn: 'MAPtxtAssignee' + '-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId" + "-Primary Key", 'StaffName' + '-MAPtxtAssignee'],//Columns to be displayed
       // AdditionalConditions: ["AssetClassificationId-EODParamMapClss", "AssetTypeCode-EODParamMapTypeCode"], //Filter conditions
        FieldsToBeFilled: ["hdnMAPAssingnId" + "-StaffMasterId", 'MAPtxtAssignee' + '-StaffName']//id of element - the model property
    };
    DisplayFetchResult('divAssigneeFetch', ItemMst, "/api/Fetch/CompanyStaffFetch", "Ulfetch", event, 1);
}


//***********Grid merging************//

function LinkClicked(id) {
    $(".content").scrollTop(1);
    $("#MAPortering :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission ) {
        action = "Edit"

    }
    else if (!hasEditPermission && hasViewPermission) {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#btnDelete').show();
    }

    if (action == 'View') {
        $("#MAPortering :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/ManualAssignPortering/Get/" + primaryId)
          .done(function (result) {
              var getResult = JSON.parse(result);
              if (ActionType == "VIEW" || ActionType == "View") {
                  $("#MAPortering :input:not(:button)").prop("disabled", true);
                  //$("#addnewrowbtn,#savebtn,#uploadbtn,#exportbtn,#addnewbtn").hide();
              }
              GetSMPBind(getResult);

              $('#myPleaseWait').modal('hide');
          })
         .fail(function () {
             $('#myPleaseWait').modal('hide');
             $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
             $('#errorMsg').css('visibility', 'visible');
         });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }

}

//$("#btnDelete").click(function () {
//    var ID = $('#primaryID').val();
//    confirmDelete(ID);

//});
//function confirmDelete(ID) {
//    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
//    var pageId = $('.ui-pg-input').val();
//    bootbox.confirm(message, function (result) {
//        if (result) {
//            $.get("/api/EODParameterMapping/Delete/" + ID)
//             .done(function (result) {
//                 filterGrid();
//                 showMessage('Parameter Mapping BEMS', CURD_MESSAGE_STATUS.DS);
//                 $('#myPleaseWait').modal('hide');
//                 EmptyFields();
//             })
//             .fail(function () {
//                 showMessage('Parameter Mapping BEMS', CURD_MESSAGE_STATUS.DF);
//                 $('#myPleaseWait').modal('hide');
//             });
//        }

//    });
//}
function EmptyFields() {
    $(".content").scrollTop(0);
    $('input[type="text"], textarea').val('');
    $('#EODParamMapClss').val("null");
    $('#btnEdit').hide();
    $('#btnSave').hide();
    $('#btnDelete').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $('#EODParamMapClss').attr('disabled', false);
    $('#EODParamMapModel').attr('disabled', true);
    $('#EODParamMapManu').attr('disabled', true);
    $("#grid").trigger('reloadGrid');
    $("#MAPortering :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');

    $('#paginationfooter').hide();
    $("#MAPtxtAssignee").prop("disabled", true);
    $("#btnSave").prop("disabled", true);
    $("#btnEdit").prop("disabled", true);
    
}

