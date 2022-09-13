$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    var ServiceValues = "1:Active;0:Inactive;";

    genarateGrid(ServiceValues);
    formInputValidation("assetclassFormid");
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $.get("/api/AssetClassification/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $.each(loadResult.Services, function (index, value)
            {
                $('#selServices').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
          
        })
  .fail(function () {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
      $('#errorMsg').css('visibility', 'visible');
  });

    $("#btnSave,#btnEdit,#btnSaveandAddNew").click(function () {

        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var CurrentbtnID = $(this).attr("Id");
        var code = $('#AssetCode').val();
        var description = $('#AssetDesc').val();
      //  var serviceid = $('#ServiceId').val();
        var Active = $('#Active').val();
        var services = $('#selServices').val();
        // var checkBox = document.getElementById("Active");
        var wordCount = 0; 
        if (description != '' && description != null)
        {
            description = description.trim();
            wordCount = description.length; 
        }

        var status = true;
        if (Active == 1) {
            status = true;
        } else {
            status = false;
        }
        var remarks = $('#Remarks').val();
        var timeStamp = $("#Timestamp").val();
        var isFormValid = formInputValidation("assetclassFormid", 'save');
        if (!isFormValid || wordCount < 1) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            if (wordCount < 1)
            {
                $('#AssetDesc').parent().addClass('has-error');
            }
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            //$('#btnEdit').attr('disabled', false);
            return false;
        }

        var AssetObj = {};
        AssetObj.AssetClassification = description;
        AssetObj.AssetClassificationCode = code;
        AssetObj.ServiceId = services;
        AssetObj.Active = status;
        AssetObj.Remarks = remarks;
        //AssetObj.Services = services;
        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            AssetObj.AssetClassificationId = primaryId;
            AssetObj.Timestamp = timeStamp;
        }
        else {
            AssetObj.AssetClassificationId = 0;
            AssetObj.Timestamp = "";
        }

        var jqxhr = $.post("/api/AssetClassification/Add", AssetObj, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.AssetClassificationId);
            $("#Timestamp").val(result.Timestamp);
            $('#AssetCode').val(result.AssetClassificationCode);
            $('#AssetDesc').val(result.AssetClassification);
           // $('#ServiceId').val(result.ServiceId);
            $('#selServices').val(result.ServiceId);
            if (result.Active) {
                $('#Active').val(1);
            }
            else {
                $('#Active').val(0);
            }
            $('#Remarks').val(result.Remarks);
           
            $("#AssetDesc").attr("disabled", "disabled");
            $("#selServices ").attr("disabled", "disabled");
            $("#grid").trigger('reloadGrid');
            if (result.AssetClassificationId != 0) {
                $("#AssetDesc").attr("disabled", "disabled");
                    $('#btnNextScreenSave').show();
                    $('#btnEdit').show();
                    $('#btnSave').hide();
                    $('#btnDelete').show();
            }
            $(".content").scrollTop(0);
            showMessage('Asset Classification', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            if (CurrentbtnID == "btnSaveandAddNew") {
                EmptyFields();
            }
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
    
    });
    // **** Query String to get ID Begin****\\\

    var getUrlParameter = function getUrlParameter(sParam) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');

            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : sParameterName[1];
            }
        }
    };
    var ID = getUrlParameter('id');
    if (ID == null || ID == undefined || ID == 0 || ID == '' || ID == "") {
        $("#jQGridCollapse1").click();
    }
    else {
        LinkClicked(ID);
    }
    // **** Query String to get ID  End****\\\
});


function LinkClicked(id) {
    $(".content").scrollTop(1);
    $("#assetclassFormid :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#ServiceId').val();
    $("#selServices").attr("disabled", "disabled");
    //$('#selServices').val();
    var action = "";
    $('#primaryID').val(id);
    debugger;
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission) {
        action = "Edit"

    }
    else if (!hasEditPermission && hasViewPermission) {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#btnDelete').show();
    }

    if (action == 'View') {
        $("#assetclassFormid :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/AssetClassification/Get/" + primaryId)
            .done(function (result) {
              var getResult = JSON.parse(result);
              $('#AssetCode').val(getResult.AssetClassificationCode);
              $('#AssetDesc').val(getResult.AssetClassification);
                //$('#ServiceId').val(getResult.ServiceId);
                $('#selServices option[value="' + getResult.ServiceId + '"]').prop('selected', true);
             // $('#selServices').val(getResult.Services);
              $('#btnDelete').show();
              if (getResult.Active) {
                  $('#Active').val(1);
              }
             
              else {
                  $('#Active').val(0);
              }
              $('#Remarks').val(getResult.Remarks);
              $('#Timestamp').val(getResult.Timestamp);
              $('#primaryID').val(getResult.AssetClassificationId);
              $("#AssetDesc").attr("disabled", "disabled");
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
        $("#AssetDesc").removeAttr("disabled");
        $("#selServices").removeAttr("disabled");
        
    }
   
}

$("#btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);
});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/AssetClassification/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('Asset Classification', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 EmptyFields();
             })
             .fail(function () {
                 showMessage('Asset Classification', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
        }

    });
}

function EmptyFields() {
    $(".content").scrollTop(0);
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#AssetClassificationId").val('');
    $('input[type="text"], textarea').val('');
    $('#selServices').val('');
    $('#TypeOfRequest').val('');
    $('#TypeOfServiceRequest').val('');
    $('#Active').val(1);
    $('#AssetDesc').prop("disabled", false);
    $('#selServices').prop("disabled", false);
    
    $("#grid").trigger('reloadGrid');
    $("#assetclassFormid :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
}


var table = $('#jQGridCollapse1').DataTable({
    ajax: "data.json"
});

setInterval(function () {
    table.ajax.reload();
}, 300);
