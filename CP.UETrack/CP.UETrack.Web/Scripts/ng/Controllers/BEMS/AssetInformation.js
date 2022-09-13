$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    formInputValidation("formBemsAssetInfo");

    $.get("/api/assetinformation/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#jQGridCollapse1").click();
            $.each(loadResult.FacilityData, function (index, value) {
                if (value.LovId == 5 || value.LovId == 8)
                    $('#assetInfoTypeId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            //var urlPathname = window.location.pathname;
            //var assetInfoType = urlPathname.substring(urlPathname.length - 1);

            var primaryId = $('#primaryID').val();

            if (primaryId != null && primaryId != "0") {
                
                var assetInfoType = primaryId.substring(primaryId.length - 1);
                primaryId = primaryId.substring(0, primaryId.length - 1);

                $.get("/api/assetinformation/Get/" + primaryId + "/" + assetInfoType)
                  .done(function (result) {
                      var getResult = JSON.parse(result);
                      $("#primaryID").val(getResult.AssetInfoId);
                      $('#assetInfoTypeId option[value="' + getResult.AssetInfoType + '"]').prop('selected', true);
                      $("#assetInfoTypeId").trigger('change');
                      $("#assetTypeValue").val(getResult.AssetInfoValue);
                      $('#assetInfoTypeId').prop('disabled', true);

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

        }).fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });

    $("#assetInfoTypeId").change(function () {
        var typeName = $("#assetInfoTypeId option:selected").text();

        if (Number(this.value)) {
            $("#AssetTextboxId").show();
            $("#assetTypeLabelId").html(typeName + " Name <span class='red'>*</span>");
        } else {
            $("#AssetTextboxId").hide();
        }
    });

    $("#btnSave, #btnEdit").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var timeStamp = $("#Timestamp").val();

        var isFormValid = formInputValidation("formBemsAssetInfo", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var assetinformation = {
            AssetInfoType: $("#assetInfoTypeId option:selected").val(),
            AssetInfoValue: $('#assetTypeValue').val()
        }

        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            assetinformation.AssetInfoId = primaryId;
            assetinformation.Timestamp = timeStamp;
        }
        else {
            assetinformation.AssetInfoId = 0;
            assetinformation.Timestamp = "";
        }

        var jqxhr = $.post("/api/assetinformation/Save", assetinformation, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.AssetInfoId);
            $("#Timestamp").val(result.Timestamp);
            $(".content").scrollTop(0);
            showMessage('Asset Information', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#assetInfoTypeId').attr('disabled', true);

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
            $('#myPleaseWait').modal('hide');
        });
    });

    $('#btnAddNew').click(function () {
        window.location.reload();
    });

    $("#btnCancel").click(function () {
        window.location.href = "/BEMS/assetinformation";
    });
});