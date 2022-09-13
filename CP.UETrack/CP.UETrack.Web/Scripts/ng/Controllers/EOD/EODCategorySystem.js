$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    $.get("/api/eodcategorysystem/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#jQGridCollapse1").click();
            $.each(loadResult.ServiceData, function (index, value) {
                if (value.LovId == 2)
                    $('#ServiceId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            var primaryId = $('#primaryID').val();
            if (primaryId != null && primaryId != "0") {
                $.get("/api/eodcategorysystem/Get/" + primaryId)
                  .done(function (result) {
                      var getResult = JSON.parse(result);
                      $('#ServiceId option[value="' + getResult.ServiceId + '"]').prop('selected', true);
                      $('#CategorySystemName').val(getResult.CategorySystemName).prop('disabled', 'disabled');
                      $('#remarkstextarea').val(getResult.Remarks);

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
        })
  .fail(function () {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
      $('#errorMsg').css('visibility', 'visible');
  });

    $("#btnSave, #btnEdit").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var timeStamp = $("#Timestamp").val();

        var EODCategorySystemMst = {
            Remarks: $('#remarkstextarea').val(),
            CategorySystemName: $('#CategorySystemName').val(),
            ServiceId: $("#ServiceId option:selected").val()
        }

        if (!(EODCategorySystemMst.CategorySystemName)) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            EODCategorySystemMst.CategorySystemId = primaryId;
            EODCategorySystemMst.Timestamp = timeStamp;
        }
        else {
            EODCategorySystemMst.CategorySystemId = 0;
            EODCategorySystemMst.Timestamp = "";
        }

        var jqxhr = $.post("/api/eodcategorysystem/Save", EODCategorySystemMst, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.CategorySystemId);
            $("#Timestamp").val(result.Timestamp);
            $(".content").scrollTop(0);
            showMessage('Category / System Master', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

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
        window.location.href = "/BEMS/eodcategorysystem";
    });
});