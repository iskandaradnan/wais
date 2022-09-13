$(document).ready(function () {
  
    $('#myPleaseWait').modal('show');
    formInputValidation("formMasterLevel");
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();

    $.get("/api/MasterBlock/Load")
        .done(function (result) {
            
            var loadResult = JSON.parse(result);
            var blockId = $('#blockId').val();
            //window.alert("blockId");
            //document.write(blockId);
            if (blockId != null && blockId != 0 && blockId != '') {

            }
            else {
                $("#jQGridCollapse1").click();
            }
            $.each(loadResult.FacilityData, function (index, value) {
                $('#LevelFacility').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $('#LevelFacility').val(loadResult.FacilityId);
            getBlockList(loadResult.FacilityId);
            var primaryId = $('#primaryID').val();

        })
  .fail(function () {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
      $('#errorMsg').css('visibility', 'visible');
  });

    function getBlockList(levelFacilityId) {
       var blockId = $("#blockId").val();
       if (levelFacilityId !== "null") {
            $.get("/api/MasterLevel/GetBlockData/" + levelFacilityId)
            .done(function (result) {
                var loadResult = JSON.parse(result);
                var LevelBlockId = $('#LevelBlock');

                LevelBlockId.empty();
                LevelBlockId.append('<option value="null">Select</option>');
                if (loadResult.BlockData.length) {
                    $.each(loadResult.BlockData, function (index, value) {
                        LevelBlockId.append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                    });
                }

                if (blockId != null && blockId != '') {
                    $('#LevelBlock').val(blockId);
                    $('#LevelBlock').attr('disabled', true);
                }
                else {
                    $('#LevelBlock').attr('disabled', false);
                }
            }).fail(function () {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');
            });
        }
    };

    $("#btnSave, #btnEdit,#btnSaveandAddNew").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');
        var CurrentbtnID = $(this).attr("Id");
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var timeStamp = $("#Timestamp").val();

        var isFormValid = formInputValidation("formMasterLevel", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var MstLevel = {
            LevelName: $('#LevelName').val(),
            FacilityId: $('#LevelFacility').val(),
            ShortName: $('#ShortName').val(),
            LevelCode: $('#LevelCode').val(),
            BlockId: $('#LevelBlock').val(),
            Active: $("#SelStatus option:selected").val()
        }

        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            MstLevel.LevelId = primaryId;
            MstLevel.Timestamp = timeStamp;
        }
        else {
            MstLevel.LevelId = 0;
            MstLevel.Timestamp = "";
        }

        var jqxhr = $.post("/api/MasterLevel/Save", MstLevel, function (response) {
            
            var result = JSON.parse(response);
            $("#primaryID").val(result.LevelId);
            $("#Timestamp").val(result.Timestamp);
            $('#hdnStatus').val(result.Active);
            $("#grid").trigger('reloadGrid');
            if (result.LevelId != 0) {
                $('#hdnAttachId').val(result.HiddenId);
                $('#LevelCode').prop('disabled', true);
                $('#btnNextScreenSave').show();
                $('#LevelBlock').attr('disabled', true);
                $('#btnEdit').show();

                $('#btnSave').hide();
                $('#btnDelete').show();
            }
            $(".content").scrollTop(0);
            showMessage('Level', CURD_MESSAGE_STATUS.SS);
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
                errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
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
    })
});

function LinkClicked(id) {
   
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formMasterLevel :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('.nav-tabs a:first').tab('show');
    var action = "";
    $('#primaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

 
    if (hasEditPermission) {
        action = "Edit";

    }
    else if (!hasEditPermission && hasViewPermission) {
        action = "View";
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#btnDelete').show();
    }

    if (action == 'View') {
        $("#formMasterLevel :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
      
        $.get("/api/MasterLevel/Get/" + primaryId)
          .done(function (result) {
              var getResult = JSON.parse(result);
              $('#LevelBlock').attr('disabled', true);
              $('#primaryID').val(getResult.LevelId);
              $('#LevelName').val(getResult.LevelName);
              $('#LevelFacility').val(getResult.FacilityId);
              $('#hdnStatus').val(getResult.Active);
              $("#LevelFacility").trigger('change');
              $('#SelStatus option[value="' + getResult.Active + '"]').prop('selected', true);
              $('#ShortName').val(getResult.ShortName);
              $('#LevelCode').val(getResult.LevelCode).prop('disabled', true);
              $('#hdnAttachId').val(getResult.HiddenId);
              setTimeout(function () {
                  $('#LevelBlock option[value="' + getResult.BlockId + '"]').prop('selected', true);
              }, 200)
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

$("#btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/MasterLevel/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('Level', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 EmptyFields();
             })
             .fail(function () {
                 showMessage('Level', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
        }

    });
}
$("#btnNextScreenSave").click(function () {

    var msg = 'Do you want to proceed to Area screen?';
    var primaryId = $("#primaryID").val();
    var hdnStatus = $("#hdnStatus").val();

    if (hdnStatus == 0 || hdnStatus == '0') {
        bootbox.alert('Only Active Level can be navigated to Area Screen');

    }
    else if (primaryId != null && primaryId != 0 && primaryId != "0" && primaryId != '') {
        bootbox.confirm(msg, function (Conform) {
            if (Conform) {
                window.location.href = "/master/MasterUserArea/Add/" + primaryId;
            }
            else {
                bootbox.hideAll();
                return false;
            }
        });
    }
});
function EmptyFields() {
    $(".content").scrollTop(0);
    $('#hdnAttachId').val('');
    $('input[type="text"], textarea').val('');
    //  $('#LevelFacility').val("null");
    // window.location.replace("/bems/Level/");
    //var blockId = $('#blockId').val();

    //if (blockId != null && blockId != 0 && blockId != '') {
    //    $('#LevelBlock').val(blockId);
    //    $('#LevelBlock').attr('disabled', true);
    //}
    //else {
    $('#LevelBlock').val("null");
    $('#LevelBlock').attr('disabled', false);
    //  }
   
    $('#LevelCode').prop('disabled', false);
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnDelete').hide();
    $('#SelStatus').val(1);
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#grid").trigger('reloadGrid');
    $("#formMasterLevel :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#divCommonPagination').html(null);
    $('.nav-tabs a:first').tab('show');
}