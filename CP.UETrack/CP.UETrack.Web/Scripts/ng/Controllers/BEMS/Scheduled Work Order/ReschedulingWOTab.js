function loadWOReschedulingTab(){
    $('#myPleaseWait').modal('show');

    var primaryId = 7;//$('#primaryID').val();
    $.get("/api/reschedulewo/get/" + primaryId)
    .done(function (result) {
        var result = JSON.parse(result);
        $("#jQGridCollapse1").click();
        if (result.RescheduleWOListData && result.RescheduleWOListData.length) {
            $('#WorkOrderNo').val(result.RescheduleWOListData[0].WorkOrderNo);
            $('#WorkOrderDate').val(DateFormatter(result.RescheduleWOListData[0].WorkOrderDate));
            $('#RescheduleAssetNo').val(result.RescheduleWOListData[0].AssetNo);
            $('#TargetDate').val(DateFormatter(result.RescheduleWOListData[0].TargetDate));
        }

        $("#rescheduleWOGrid").empty();
        $.each(result.RescheduleWOListData, function (index, value) {
            AddNewRow();
            $("#RescheduleDate_" + index).val(DateFormatter(value.RescheduleDate)).prop("disabled", "disabled");
            $("#RescheduleApprovedBy_" + index).val(value.RescheduleApprovedByName).prop("disabled", "disabled");
            $("#Reason_" + index).val(value.ReasonForRescheduleName).prop("disabled", "disabled");
        });

        $('#myPleaseWait').modal('hide');
    })
    .fail(function () {
        $('#myPleaseWait').modal('hide');
        $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
    });

    $("#btnCancel").click(function () {
        window.location.href = "/bems/reschedulewo";
    });
    $("#btnAddNew").click(function () {
        window.location.href = window.location.href;
    });
}

function errorMsg(errMsg) {
    $("div.errormsgcenter").text((!Messages[errMsg]) ? errMsg : Messages[errMsg]).css('visibility', 'visible');

    $('#btnlogin').attr('disabled', false);
    $('#myPleaseWait').modal('hide');
    InvalidFn();
    return false;
}

function DateFormatter(formatToDate) {
    var m_names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    var d = new Date(formatToDate);
    var format_date = d.getDate();
    var format_month = d.getMonth() + 1;
    var format_year = d.getFullYear();

    return format_date + "-" + m_names[format_month] + "-" + format_year;
}

function AddNewRow() {

    var inputpar = {
        inlineHTML: '<tr><td width="33%" style="text-align: center;" title=""><div><input id="RescheduleDate_maxindexval" type="text" class="form-control datatime" name="RescheduleDate" autocomplete="off"></div></td>' +
                     '<td width="33%" style="text-align: center;" title=""><div><input id="RescheduleApprovedBy_maxindexval" type="text" class="form-control" name="RescheduleApprovedBy" placeholder="Please Select" autocomplete="off">' +
                     '<td width="33%" style="text-align: center;" title=""><div><input id="Reason_maxindexval" type="text" class="form-control datatime" name="Reason" autocomplete="off"></div></td></tr>',
        TargetId: "#rescheduleWOGrid",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
}