
$(document).ready(function () {
    formInputValidation("frmSummaryofFeeReport");
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnVerify').hide();
    $('#btnApprove').hide();
    $('#btnReject').hide();
    $("#btnSave").hide();
    $("#ShowGrid").hide();
    $("#btnSaveandAddNew").hide();
    $("#btnCancel").hide();

    
    $.get("/api/SummaryofFeeReportAPI/Load")
        .done(function (result) {
            var loadResult = result;
             $("#jQGridCollapse1").click();
            console.log(loadResult.FMTimeMonth);
            LoadLoV(loadResult.Yearlist, 'Yearddl');
            LoadLoV(loadResult.FMTimeMonth, 'Monthddl');
            LoadLoV(loadResult.ServiceData, 'ServiceId');
            LoadLoV(loadResult.AssetClassificationList, 'AssetClassificationddl',true);
            var actiontype = $("#hdnActionType").val();
            var month = $('#Monthddl').val();
            var datee = new Date();
            var Currentmonth = datee.getMonth() + 1;
            $('#Monthddl').val(Currentmonth);
            //if (actiontype != "ADD")
            //{
            //    $("#btnFetch").hide();
            //    var getobj = { RollOverFeeId: $("#hdnPrimaryID").val() }
            //    var jqxhr = $.post("/api/SummaryofFeeReportAPI/GetDetails", getobj, function (response) {
            //        var result = JSON.parse(response);
            //        $("#Yearddl").prop("disabled",true).val(result.Year);
            //        $("#Monthddl").prop("disabled", true).val(result.Month);
            //        $("#AssetClassificationddl").prop("disabled", true).val(result.AssetClassificationId);
            //        $(result.SummaryList).each(function (i, data) {
            //            var html = '<tr><td><label id="HospitalName_' + i + '"></label></td><td><label id="DuringWarrantyCount_' + i + '"></label></td><td><label id="DuringWarrantytotalFee_' + i + '"></label></td><td><label id="PostWarrantyCount_' + i + '"></label></td><td><label id="PostWarrantyTotalFee_' + i + '"></label></td><td><label id="TotalFeePayable_' + i + '"></label></td></tr>';
            //            $("#DetailGrid").append(html);
            //            $('#HospitalName_' + i).text(data.HospitalName);
            //            $('#DuringWarrantyCount_' + i).text(data.DuringWarrantyCount);
            //            $('#DuringWarrantytotalFee_' + i).text(data.DuringWarrantytotalFee);
            //            $('#PostWarrantyCount_' + i).text(data.PostWarrantyCount);
            //            $('#PostWarrantyTotalFee_' + i).text(data.PostWarrantyTotalFee);
            //            $('#TotalFeePayable_' + i).text(data.TotalFeePayable);
            //        });
            //        $("#btnFetch").hide();
            //        $("#btnSave").show();
            //        $("#ShowGrid").show();

            //        $('#myPleaseWait').modal('hide');
            //    },
            //"json")
            //.fail(function (response) {
            //    var errorMessage = "";
            //    if (response.status == 400) {
            //        errorMessage = response.responseJSON;
            //    }
            //    else {
            //        errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
            //    }
            //    $("div.errormsgcenter").text(errorMessage);
            //    $('#errorMsg').css('visibility', 'visible');

            //    $('#btnSave').attr('disabled', false);
            //    $('#btnEdit').attr('disabled', false);
            //    $('#btnVerify').attr('disabled', false);
            //    $('#btnApprove').attr('disabled', false);
            //    $('#btnReject').attr('disabled', false);

            //    $('#myPleaseWait').modal('hide');
            //});


        
            ////});

            //}
           

        })
      .fail(function () {
          $('#myPleaseWait').modal('hide');
          $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
          $('#errorMsg').css('visibility', 'visible');
      });



    $("#btnFetch").on("click", function () {
        $("#DetailGrid").empty();
        var isFormValid = formInputValidation("frmSummaryofFeeReport", 'save');
        if (!isFormValid) {
            $(".errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#errorMsg').show();

            $('#btnARSave').attr('disabled', false);
            //$('#btnEdit').attr('disabled', false);
            return false;
        }
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $("#DetailGrid").hide();
        var getobj = {
            //AssetClassificationId:parseInt($('#AssetClassificationddl').val()),
            Year: $("#Yearddl").val(), 
            Month: $("#Monthddl").val(),
            ServiceId: $("#ServiceId").val()
        }
        var jqxhr = $.post("/api/SummaryofFeeReportAPI/GetDetails", getobj, function (response) {
            var result = JSON.parse(response);


                $(result.SummaryList).each(function (i, data) {
                
                    var html = '<tr><td><label id="HospitalName_' + i + '"></label></td><td style="text-align:right"><label id="DuringWarrantyCount_' + i + '"></label></td><td style="text-align:right"><label id="DuringWarrantytotalFee_' + i + '"></label></td><td style="text-align:right"><label id="PostWarrantyCount_' + i + '"></label></td><td style="text-align:right"><label id="PostWarrantyTotalFee_' + i + '"></label></td><td style="text-align:right"><label id="TotalFeePayable_' + i + '"></label></td></tr>';
                    $("#DetailGrid").append(html);
                    $('#HospitalName_' + i).text(data.HospitalName);
                    $('#DuringWarrantyCount_' + i).text(data.DuringWarrantyCount);
                    $('#DuringWarrantytotalFee_' + i).text(addCommas(data.DuringWarrantytotalFee));
                    $('#PostWarrantyCount_' + i).text(data.PostWarrantyCount);
                    $('#PostWarrantyTotalFee_' + i).text(addCommas(data.PostWarrantyTotalFee));
                    $('#TotalFeePayable_' + i).text(addCommas(data.TotalFeePayable));
                   
                });
                if (result.SummaryList != null) {
                    $("#btnFetch").hide();
                    $("#btnSave").show();
                    $("#ShowGrid").show();
                    $("#DetailGrid").show();
                    $("#btnSaveandAddNew").show();
                    $("#btnCancel").show();
                    $('#Yearddl').prop('disabled', true);
                    $('#Monthddl').prop('disabled', true);
                    $('#ServiceId').prop('disabled', true);
                    $('#AssetClassificationddl').prop('disabled', true);
                }
                else {
                    $("div.errormsgcenter").text("No records to display");
                    $('#errorMsg').css('visibility', 'visible');
                }
                
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
            $('#btnEdit').attr('disabled', false);
            $('#btnVerify').attr('disabled', false);
            $('#btnApprove').attr('disabled', false);
            $('#btnReject').attr('disabled', false);

            $('#myPleaseWait').modal('hide');
        });


        
    });
    //if ($("#hdnActionType").val() == "ADD")
    //{
    //    $("#btnSave").hide();
    //    $("#ShowGrid").hide();
    //    //ShowGrid
    //}
    $("#btnAddNew").on("Click", function () {
        window.location.replace("/vm/SummaryofFeeReport/add");
    })
    $("#jQGridCollapse1").click(function () {
        $(".jqContainer").toggleClass("hide_container");
    })
});


function performsave(flag)
{
    var isFormValid = formInputValidation("form", "save");
    if (!isFormValid) {
        $(".errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');

        $('#btnARSave').attr('disabled', false);
        //$('#btnEdit').attr('disabled', false);
        return false;
    }
    var postdata = {
        Year: $("#Yearddl").val(), Month: $("#Monthddl").val(), AssetClassificationId: null, ReportId: $("#hdnPrimaryID").val(), ServiceId: $("#ServiceId").val(), Flag: flag
    }
    postdata.Status = 1
    switch (flag) {
       
        case 'verify': postdata.Status = 9; break;
        case 'approve': postdata.Status = 7; break;
        case 'Reject': postdata.Status = 8; break;
    }
    var jqxhr = $.post("/api/SummaryofFeeReportAPI/Save", postdata, function (response) {
        var result = JSON.parse(response);
        console.log(result);
        $("#grid").trigger('reloadGrid');
        if (result.ReportId != 0 && result.Status == 1) {
            $('#btnEdit').show();
            $('#btnSave').hide();
            $('#btnDelete').show();
            $('#btnVerify').show();
            $('#btnApprove').show();
            $('#btnReject').show();
        }
        else if (result.ReportId != 0 && result.Status == 9)  /// Verify Btn
        {
            $('#btnEdit').hide();
            $('#btnSave').hide();
            $('#btnDelete').hide();
            $('#btnVerify').hide();
            $('#btnApprove').show();
            $('#btnReject').show();
            $('#btnCancel').show();
            
        }
        else if (result.ReportId != 0 && result.Status == 7)  /// Approve Btn
        {
            $('#btnEdit').hide();
            $('#btnSave').hide();
            $('#btnDelete').hide();
            $('#btnVerify').hide();
            $('#btnApprove').hide();
            $('#btnReject').hide();
            $('#btnCancel').show();

        }
        else if (result.ReportId != 0 && result.Status == 8)  /// Reject Btn
        {
            $('#btnEdit').hide();
            $('#btnSave').hide();
            $('#btnDelete').hide();
            $('#btnVerify').hide();
            $('#btnApprove').hide();
            $('#btnReject').hide();
            $('#btnCancel').show();

        }
        $(result.SummaryList).each(function (i, data) {
            $("#DetailGrid").empty();
            var html = '<tr><td><label id="HospitalName_' + i + '"></label></td><td style="text-align:right"><label id="DuringWarrantyCount_' + i + '"></label></td><td style="text-align:right"><label id="DuringWarrantytotalFee_' + i + '"></label></td><td style="text-align:right"><label id="PostWarrantyCount_' + i + '"></label></td><td style="text-align:right"><label id="PostWarrantyTotalFee_' + i + '"></label></td><td style="text-align:right"><label id="TotalFeePayable_' + i + '"></label></td></tr>';
            $("#DetailGrid").append(html);
            $('#HospitalName_' + i).text(data.HospitalName);
            $('#DuringWarrantyCount_' + i).text(data.DuringWarrantyCount);
            $('#DuringWarrantytotalFee_' + i).text(addCommas(data.DuringWarrantytotalFee));
            $('#PostWarrantyCount_' + i).text(data.PostWarrantyCount);
            $('#PostWarrantyTotalFee_' + i).text(addCommas(data.PostWarrantyTotalFee));
            $('#TotalFeePayable_' + i).text(addCommas(data.TotalFeePayable));
        });
        if (result.SummaryList != null) {
            $("#btnFetch").hide();
           // $("#btnSave").show();
            $("#ShowGrid").show();
            $("#DetailGrid").show();
            $("#btnSaveandAddNew").show();
            $("#btnCancel").show();
        }
        else {
            $("div.errormsgcenter").text("No records to display");
            $('#errorMsg').css('visibility', 'visible');
        }
        $(".content").scrollTop(0);
        showMessage('Summary Of Fee Report', CURD_MESSAGE_STATUS.SS);
        $("#top-notifications").modal('show');
        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);
        $('#btnSave').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        if (flag == "SaveandAdd") {
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


}
function LinkClicked(id, rowData) {
    $(".content").scrollTop(1);
    $("#frmSummaryofFeeReport :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#hdnPrimaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission) {
        action = "Edit"

    }
    //else if (!hasEditPermission && hasViewPermission) {
    //    action = "View"
    //}
    //if (action == "Edit" && hasDeletePermission) {
    //    $('#btnDelete').show();
    //}

    //if (action == 'View') {
    //    $("#frmSummaryofFeeReport :input:not(:button)").prop("disabled", true);
    //} else {
    //    $('#btnEdit').show();
    //    $('#btnSave').hide();
    //    //$('#btnSaveandAddNew').hide();
    //    $('#btnNextScreenSave').show();
    //}
    if (action == 'View') {
        $("#frmSummaryofFeeReport :input:not(:button)").prop("disabled", true);
        $('#btnEdit').hide();
        $('#btnSave').hide();
        $('#btnApprove').hide();
        $('#btnReject').hide();
        $('#btnVerify').hide();
        $('#btnDelete').hide();
        $('#btnSaveandAddNew').hide();
    }
    else if (action == 'Edit' && hasDeletePermission && rowData.Status == "Active") {
        $('#btnEdit').show();
        $('#btnSave').hide();
        $('#btnApprove').hide();
        $('#btnReject').hide();
        $('#btnAdjustmentSubmit').show();
        $('#btnDelete').show();
        $('#btnSaveandAddNew').show();
    }
    else if (action == 'Edit' && hasDeletePermission && rowData.Status == "Submit") {
        $('#btnEdit').show();
        $('#btnSave').hide();
        $('#btnApprove').show();
        $('#btnReject').show();
        $('#btnVerify').hide();
        $('#btnDelete').hide();
        $('#btnSaveandAddNew').hide();
    }
    else if (action == 'Edit' && hasDeletePermission && rowData.Status == "Reject") {
        $('#btnEdit').hide();
        $('#btnSave').hide();
        $('#btnApprove').hide();
        $('#btnReject').hide();
        $('#btnVerify').hide();
        $('#btnDelete').hide();
        $('#btnSaveandAddNew').hide();
    }
    else if (action == 'Edit' && hasDeletePermission && rowData.Status == "Approve") {
        $('#btnEdit').hide();
        $('#btnSave').hide();
        $('#btnApprove').hide();
        $('#btnReject').hide();
        $('#btnVerify').hide();
        $('#btnDelete').hide();
        $('#btnSaveandAddNew').hide();
    }
    else if (action == 'Edit' && hasDeletePermission && rowData.Status == "Verify") {
        $('#btnEdit').hide();
        $('#btnSave').hide();
        $('#btnApprove').show();
        $('#btnReject').show();
        $('#btnVerify').hide();
        $('#btnDelete').hide();
        $('#btnSaveandAddNew').hide();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#hdnPrimaryID').val();
    if (primaryId != null && primaryId != "0") {
        $("#btnFetch").hide();
        var getobj = { RollOverFeeId: $("#hdnPrimaryID").val(), ServiceId: $("#ServiceId").val() }
        var jqxhr = $.post("/api/SummaryofFeeReportAPI/GetDetails", getobj, function (response) {
            var result = JSON.parse(response);
            $("#Yearddl").prop("disabled", true).val(result.Year);
            $("#Monthddl").prop("disabled", true).val(result.Month);
            $('#ServiceId').prop('disabled', true);
          //  $("#AssetClassificationddl").prop("disabled", true).val(result.AssetClassificationId);
        
                $(result.SummaryList).each(function (i, data) {
                    $("#DetailGrid").empty();
                    var html = '<tr><td><label id="HospitalName_' + i + '"></label></td><td style="text-align:right"><label id="DuringWarrantyCount_' + i + '"></label></td><td style="text-align:right"><label id="DuringWarrantytotalFee_' + i + '"></label></td><td style="text-align:right"><label id="PostWarrantyCount_' + i + '"></label></td><td style="text-align:right"><label id="PostWarrantyTotalFee_' + i + '"></label></td><td style="text-align:right"><label id="TotalFeePayable_' + i + '"></label></td></tr>';
                    $("#DetailGrid").append(html);
                    $("#DetailGrid").show();
                    $('#HospitalName_' + i).text(data.HospitalName);
                    $('#DuringWarrantyCount_' + i).text(data.DuringWarrantyCount);
                    $('#DuringWarrantytotalFee_' + i).text(addCommas(data.DuringWarrantytotalFee));
                    $('#PostWarrantyCount_' + i).text(data.PostWarrantyCount);
                    $('#PostWarrantyTotalFee_' + i).text(addCommas(data.PostWarrantyTotalFee));
                    $('#TotalFeePayable_' + i).text(addCommas(data.TotalFeePayable));
                });
            
            if (result.SummaryList != null && result.SummaryList.length >0) {
                $('#VerifiedByDoneBy').text(result.SummaryList[0].VerifiedBy);
                $('#VerifiedByDate').text(result.SummaryList[0].VerifiedDate)
                $('#ApprovedByDoneBy').text(result.SummaryList[0].ApprovedBy)
                $('#ApprovedByDate').text(result.SummaryList[0].ApprovedDate)
            }
            $("#btnFetch").hide();
           // $("#btnSave").show();
            $("#ShowGrid").show();
            $("#btnSaveandAddNew").show();
            $("#btnCancel").show();
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
        $('#btnEdit').attr('disabled', false);
        $('#btnVerify').attr('disabled', false);
        $('#btnApprove').attr('disabled', false);
        $('#btnReject').attr('disabled', false);

        $('#myPleaseWait').modal('hide');
    });

        //});
    }
}

$("#btnDelete").click(function () {
    var ID = $('#hdnPrimaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/SummaryofFeeReportAPI/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('Summary Of Fee Report', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 EmptyFields();
             })
             .fail(function () {
                 showMessage('Summary Of Fee Report', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
        }

    });
}

function EmptyFields() {
    $(".content").scrollTop(0);
    $('input[type="text"], textarea').val('');   
    $('#Monthddl').val(1);
    $('#AssetClassificationddl').val("");
    $('#Yearddl').prop('disabled', false);
    $('#Monthddl').prop('disabled', false);
    $('#ServiceId').prop('disabled', false);
    $('#AssetClassificationddl').prop('disabled', false);
    $('#btnFetch').show();
    $('#btnEdit').hide();    
    $('#btnSave').hide();
    $('#btnDelete').hide();
    $("#btnSaveandAddNew").hide();
    $("#btnCancel").hide();
    $('#btnVerify').hide();
    $('#btnApprove').hide();
    $('#btnReject').hide();
    $('#spnActionType').text('Add');
    $("#hdnPrimaryID").val('');
    $("#DetailGrid").empty();
    $("#ShowGrid").hide();
    $("#DetailGrid").hide();
    $("#grid").trigger('reloadGrid');
    $("#frmSummaryofFeeReport :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var datee = new Date();
    var Currentmonth = datee.getMonth() + 1;
    $('#Monthddl').val(Currentmonth);
}
$("#btnCancel").click(function () {
    EmptyFields();
});

// Change Database based on ServiceId change

function ChangeService() {
    var ServiceId = $('#ServiceId').val();
    $.get("/api/SummaryofFeeReportAPI/ChangeService/" + ServiceId)
 .done(function (result) {
     var getResult = JSON.parse(result);
 })
 .fail(function (response) {
     $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
     $('#errorMsg').css('visibility', 'visible');
 });
}
