$(document).ready(function ()
{
    //$('#myPleaseWait').modal('show');
    $('#txtEmailId').attr('pattern', '^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$');
    formInputValidation("frmForgotPassword");

  //          $.get("/api/forgotPassword/Load")
  //          .done(function(result) {
  //              var loadResult = JSON.parse(result);
  //          $.each(loadResult.AssetClassifications, function(index, value) {
  //              $('#selAssetClassification').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
  //              });
          
  //              var primaryId = $('#hdnPrimaryID').val();
  //              if (primaryId != null && primaryId != "0")
  //              {
  //              $.get("/api/forgotPassword/Get/" + primaryId)
  //                .done(function(result) {
  //                      var getResult = JSON.parse(result);
  //              $('#').val(getResult.Username);
  //              $('#').val(getResult.Password);
  //              $('#').val(getResult.StaffName);
  //              $('#').val(getResult.Email);$('#myPleaseWait').modal('hide');
  //                  })
  //               .fail(function(response) {
  //                   $('#myPleaseWait').modal('hide');
  //                   $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
  //                   $('#errorMsg').css('visibility', 'visible');
  //                  });
  //              }
  //              else
  //              {
  //              $('#myPleaseWait').modal('hide');
  //              }
  //          })
  //.fail(function(response) {
  //    $('#myPleaseWait').modal('hide');
  //    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
  //    $('#errorMsg').css('visibility', 'visible');
  //          });

    $("#btnSave").click(function() {
        $('#btnSave').attr('disabled', true);
        
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

            var isFormValid = formInputValidation("frmForgotPassword", 'save');
            if (!isFormValid)
            {
                $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');

                $('#btnSave').attr('disabled', false);
                return false;
            }

        $('#myPleaseWait').modal('show');

               var saveObj = {
                   Email: $('#txtEmailId').val(),
                };

            var jqxhr = $.post("/api/forgotPassword/Save", saveObj, function(response) {
           
            showMessage('', CURD_MESSAGE_STATUS.MS);
          
            $('#btnSave').hide();
          
            $('#myPleaseWait').modal('hide');
            },
       "json")
        .fail(function(response) {
                var errorMessage = "";
                if (response.status == 400)
                {
                    errorMessage = response.responseJSON;
                }
                else
                {
                    errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
                }
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            
            $('#myPleaseWait').modal('hide');
            });
        });

  $("#btnCancel").click(function ()  {
        window.location.href = "/Account/Login";
  });
 
});