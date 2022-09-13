$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    $('#btnEdit').hide();
    formInputValidation("frmKPITransactionMapping");
    formInputValidation("frmGridDetails");

    var allMonths = null;
    var currentYear = null;
    var currentYearMonths = null;

    $.get("/api/kPITransactionMapping/Load")
    .done(function (result) {
        var loadResult = JSON.parse(result);
        $("#jQGridCollapse1").click();
        $.each(loadResult.Years, function (index, value) {
            $('#selYear').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        //$.each(loadResult.Services, function (index, value) {
        //    $('#selService').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        //});
        $.each(loadResult.CurrentYearMonths, function (index, value) {
            $('#selMonth').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(loadResult.Indicators, function (index, value) {
            $('#selIndicator').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });

        allMonths = loadResult.Months;
        currentYearMonths = loadResult.CurrentYearMonths;

        currentYear = loadResult.CurrentYear;
        $('#selYear').val(loadResult.CurrentYear);
        //$('#selService').val(2);

        //var primaryId = $('#hdnPrimaryID').val();
        //if (primaryId != null && primaryId != "0") {
        //    $('#btnAddFetch').hide();
        //    $.get("/api/kPITransactionMapping/Get/" + primaryId + "/1/5")
        //      .done(function (result) {
        //          var result1 = JSON.parse(result);
                 
        //            if (result1 != null && result1.Transactions != null && result1.Transactions.length > 0) {
        //                var result = result1.Transactions;
        //                var firstObject = $.grep(result, function (value0, index0) {
        //                    return index0 == 0;
        //                    });
        //                $('#hdnPrimaryID').val(firstObject[0].DedTxnMappingId);

        //                $('#selYear').val(firstObject[0].Year).prop("disabled",true);
        //                $('#selMonth').val(firstObject[0].Month).prop("disabled", true);
        //                //$('#selService').val(firstObject[0].ServiceId);
        //                $('#selIndicator').val(firstObject[0].IndicatorDetId).prop("disabled", true);

        //                BindData(result);
        //                $('#divPagination').html(null);
        //                $('#divPagination').html(paginationString);
        //                SetPaginationValues(result);
        //            }
                  
        //          $('#myPleaseWait').modal('hide');
        //      })
        //     .fail(function (response) {
        //         $('#myPleaseWait').modal('hide');
        //         $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
        //         $('#errorMsg2').css('visibility', 'visible');
        //     });
        //}
        //else {
        //    $('#myPleaseWait').modal('hide');
        //}
    })
.fail(function (response) {
    $('#myPleaseWait').modal('hide');
    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
    $('#errorMsg2').css('visibility', 'visible');
});

    $('#selYear, #selMonth, #selIndicator').change(function () {
        $('#tblKPITransactionMapping > tbody').empty();
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
 $('#btnAddFetch').click(function () {
    $('#btnAddFetch').attr('disabled', true);
    $('#tblKPITransactionMapping > tbody').empty();

    $("div.errormsgcenter").text("");
    $('#errorMsg1').css('visibility', 'hidden');
    $('#errorMsg2').css('visibility', 'hidden');
    
    var isFormValid = formInputValidation("frmKPITransactionMapping", 'save');
        
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg1').css('visibility', 'visible');

        $('#btnAddFetch').attr('disabled', false);
        return false;
    }

    $('#myPleaseWait').modal('show');

    var fetchObj = {
        Year: $('#selYear').val(),
        Month: $('#selMonth').val(),
        ServiceId: 2,
        IndicatorNo: $("#selIndicator option:selected").text()
    };

    var jqxhr = $.post("/api/kPITransactionMapping/FetchRecords", fetchObj, function (response) {
        var result = JSON.parse(response);
        if (result != null && result.length != 0) {
            BindData(result);
        }

        $('#btnAddFetch').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
    },
    "json")
    .fail(function (response) {
        var errorMessage = "";
        if (response.status == 400) {
            errorMessage = response.responseJSON;
        }
        

        $("div.errormsgcenter").text(errorMessage);
        $('#errorMsg1').css('visibility', 'visible');

        $('#btnAddFetch').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
    });
});

 

    $('#selYear').change(function () {
        var selectedYear = $('#selYear').val();
        if (selectedYear == currentYear) {
            $('#selMonth').children('option:not(:first)').remove();
            $.each(currentYearMonths, function (index, value) {
                $('#selMonth').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
        }
        else if (selectedYear == "null") {
            $('#selMonth').children('option:not(:first)').remove();
        }
        else {
            $('#selMonth').children('option:not(:first)').remove();
            $.each(allMonths, function (index, value) {
                $('#selMonth').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
        }
    });

    $("#btnSave, #btnEdit,#btnSaveandAddNew").click(function () {
        $('#btnSave').attr('disabled', true);
        $('#btnEdit').attr('disabled', true);

        $("div.errormsgcenter").text("");
        $('#errorMsg2').css('visibility', 'hidden');
        var CurrentbtnID = $(this).attr("Id");
        var isFormValid = formInputValidation("frmKPITransactionMapping", 'save');
        var isForm2Valid = formInputValidation("frmGridDetails", 'save');
        if (!isFormValid || !isForm2Valid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg2').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            $('#btnEdit').attr('disabled', false);
            return false;
        }

        saveObjList = [];
        
        $("#tblKPITransactionMapping tr").each(function (index, value) {
            if (index == 0) return;
            var index1 = index - 1;

            var saveObj = {
                ServiceWorkDate: $('#txtDate_' + index1).val(),
                ServiceWorkNo: $('#txtDocumentNo_' + index1).val(),
                AssetNo: $('#txtAssetNo_' + index1).val(),
                AssetDescription: $('#txtAssetDescription_' + index1).val(),
                ScreenName: $('#txtScreenName_' + index1).val(),
                GeneratedDemertiPoints: $('#txtGeneratedDemerit_' + index1).val(),
                FinalDemeritPoints: $('#txtFinalDemerit_' + index1).val(),
                IsValid: $('#chkIsValid_' + index1).prop('checked') ? 1 : 0,
                DisputedPendingResolution: $('#txtPendingResolution_' + index1).val(),
                Remarks: $('#txtRemarks_' + index1).val(),
                DeductionValue: $('#hdnDeductionValue_' + index1).val(),
                DedGenerationId: $('#hdnDedGenerationId_' + index1).val(),
                DedTxnMappingDetId: $('#hdnDedTxnMappingDetId_' + index1).val(),
                DedTxnMappingId: $('#hdnDedTxnMappingId_' + index1).val()
            };
            saveObjList.push(saveObj);
        });
        
        if (saveObjList.length == 0) {
            $("div.errormsgcenter").text('There are no records to save');
            $('#errorMsg2').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            $('#btnEdit').attr('disabled', false);
            return false;
        }

        var isInValid = false;
        for (i = 0; i < saveObjList.length; i++) {
            $('#txtFinalDemerit_' + i).parent().removeClass('has-error');
            var FDP = parseInt(saveObjList[i].FinalDemeritPoints);
            var GDP = parseInt(saveObjList[i].GeneratedDemertiPoints);
            if ((GDP < FDP))
            {
                $("div.errormsgcenter").text('final demerit points should be less than generated demerit points');
                $('#errorMsg2').css('visibility', 'visible');
                $('#txtFinalDemerit_' + i).parent().addClass('has-error');
                $('#btnSave').attr('disabled', false);
                $('#btnEdit').attr('disabled', false);
                return false;
            }
        }

        var transactionMapping = {
            Year: $('#selYear').val(),
            Month: $('#selMonth').val(),
            ServiceId: 2,
            IndicatorDetId: $("#selIndicator").val(),
            DedGenerationId: saveObjList[0].DedGenerationId,
            DedTxnMappingId: saveObjList[0].DedTxnMappingId
        };

        var KPITransactions = {
            Transactions: saveObjList,
            TranscationMapping: transactionMapping
        };
       
        $('#myPleaseWait').modal('show');

        var jqxhr = $.post("/api/kPITransactionMapping/Save", KPITransactions, function (response) {
            var result1 = JSON.parse(response);
            $("#grid").trigger('reloadGrid');
            if (result1 != null && result1.Transactions != null && result1.Transactions.length > 0)
            {
                var result = result1.Transactions;
                var firstObject = $.grep(result, function (value0, index0) {
                    return index0 == 0;
                });
                $('#hdnPrimaryID').val(firstObject[0].DedTxnMappingId);
                if (result1.DedTxnMappingId != 0) {
                    //$("#grid").trigger('reloadGrid');
                    $('#btnEdit').show();
                    $('#btnSave').hide();
                }
                BindData(result);
                $('#divPagination').html(null);
                $('#divPagination').html(paginationString);
                SetPaginationValues(result);
                //AttachPaginationEvents();
            } else if (result1 != null && result1.Transactions == null) {
                $('#hdnPrimaryID').val(result1.DedTxnMappingId);
            }
            $(".content").scrollTop(0);
            showMessage('', CURD_MESSAGE_STATUS.SS);
           
            $('#btnSave').attr('disabled', false);
            $('#btnEdit').attr('disabled', false);
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
        $('#errorMsg2').css('visibility', 'visible');

        $('#btnSave').attr('disabled', false);
        $('#btnEdit').attr('disabled', false);
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
});
function BindData(result) {
    var trString = '';
    var isAdjustmentSaved = result[0].IsAdjustmentSaved;
    for (i = 0; i < result.length; i++) {
        result[i].ServiceWorkDate = result[i].ServiceWorkDate == null ? '' : moment(result[i].ServiceWorkDate).format("DD-MMM-YYYY");
        trString += ' <tr>'
                        + '<td width="4%"><input type="text" id="txtSlNo_' + i + '" disabled value="' + result[i].SerialNo + '" class="form-control" /></td>'
                        + '<td width="10%"><input type="text" id="txtDate_' + i + '" disabled value="' + result[i].ServiceWorkDate + '" class="form-control" /></td>'
                        + '<td width="16%"><input type="text" id="txtDocumentNo_' + i + '" disabled value="' + result[i].ServiceWorkNo + '" class="form-control" /></td>'
                        + '<td width="8%"><input type="text" id="txtAssetNo_' + i + '" disabled value="' + result[i].AssetNo + '" class="form-control" /></td>'
                        + '<td width="8%"><input type="text" id="txtAssetDescription_' + i + '" disabled value="' + result[i].AssetDescription + '" class="form-control" /></td>'
                        + '<td width="11%"><input type="text" id="txtScreenName_' + i + '" disabled value="' + result[i].ScreenName + '" class="form-control" /></td>'
                        + '<td width="8%"><input type="text" id="txtGeneratedDemerit_' + i + '" disabled value="' + result[i].GeneratedDemertiPoints + '" class="form-control text-right" /></td>'
                        + '<td width="8%"><input type="text" id="txtFinalDemerit_' + i + '" value="' + result[i].FinalDemeritPoints + '" class="form-control text-right" required/></td>'
                        + '<td width="7%" style="text-align:center"><input type="checkbox" id="chkIsValid_' + i + '" /></td>'
                        + '<td width="8%"><input type="text" id="txtPendingResolution_' + i + '" disabled value="' + result[i].DisputedPendingResolution + '" class="form-control text-right" /></td>'
                        + '<td width="12%"><input type="text" id="txtRemarks_' + i + '" value="' + result[i].Remarks + '" class="form-control" maxlength="500"/>'
                        + '<input type="hidden" id="hdnDeductionValue_' + i + '" value="' + result[i].DeductionValue + '"/>'
                        + '<input type="hidden" id="hdnDedGenerationId_' + i + '" value="' + result[i].DedGenerationId + '"/>'
                        + '<input type="hidden" id="hdnDedTxnMappingDetId_' + i + '" value="' + result[i].DedTxnMappingDetId + '"/>'
                        + '<input type="hidden" id="hdnDedTxnMappingId_' + i + '" value="' + result[i].DedTxnMappingId + '"/>'
                        + '</td>'
                    + '</tr>';
    }
    $('#tblKPITransactionMapping > tbody').empty();
    $('#tblKPITransactionMapping > tbody').append(trString);
    for (i = 0; i < result.length; i++) {
        if (result[i].IsValid == 1) {
            $('#chkIsValid_' + i + '').prop('checked', true);
        }
        else {
            $('#chkIsValid_' + i + '').prop('checked', false);
        }
    }

    $("input[id^='txtGeneratedDemerit_'], input[id^='txtFinalDemerit_']").attr('pattern', '^[0-9]+$');
    $("input[id^='txtRemarks_']").attr('pattern', '^[a-zA-Z0-9\'.\'\",:;/\\(\\),\\-\\s!@#$%*"&]+$');

    if (isAdjustmentSaved) {
        $('#btnSave, #btnEdit, #btnSaveandAddNew').hide();
        $("input[id^='txtFinalDemerit_'], input[id^='txtRemarks_'], input[id^='chkIsValid_']").attr('disabled', true);
    } else {
        $('#btnSaveandAddNew').show();
        var primaryId = $('#hdnPrimaryID').val();
        if (primaryId != null && primaryId != 0 && primaryId != '') {
            $('#btnEdit').show();
            $('#btnSave').hide();
        } else {
            $('#btnSave').show();
            $('#btnEdit').hide();
        }
        $("input[id^='txtFinalDemerit_'], input[id^='txtRemarks_'], input[id^='chkIsValid_']").attr('disabled', false);
    }

    formInputValidation("frmGridDetails");

    $("input[id^='txtFinalDemerit_']").on('input propertychange paste keyup', function (event) {
        var id = $(this).attr('id');
        var index = id.substring(id.indexOf('_') + 1);
        var GeneratedDemeritPoints = parseInt($('#txtGeneratedDemerit_' + index + '').val());
        var finalDemeritPoints = $('#txtFinalDemerit_' + index + '').val();
        if (finalDemeritPoints == null || finalDemeritPoints == '' || isNaN($('#txtFinalDemerit_' + index + '').val())) {
            $('#txtPendingResolution_' + index + '').val(0);
        }
        else {
            var generatedDemeritPoints = parseInt($('#txtGeneratedDemerit_' + index + '').val());
            var finalDemeritPoints = parseInt($('#txtFinalDemerit_' + index + '').val());
            $('#txtPendingResolution_' + index + '').val(generatedDemeritPoints - finalDemeritPoints);
        }
      
    });

    $("input[id^='chkIsValid_']").on('click', function () {
        var id = $(this).attr('id');
        var index = id.substring(id.indexOf('_') + 1);
        var generatedDemeritPoints = parseInt($('#txtGeneratedDemerit_' + index + '').val());
        var isChecked = $(this).prop("checked");
        if (isChecked) {
            $('#txtRemarks_' + index + '').removeAttr('required');
            $('#txtRemarks_' + index + '').parent().removeClass('has-error');
            $('#txtFinalDemerit_' + index + '').val(generatedDemeritPoints);
            $('#txtPendingResolution_' + index + '').val(0);
            $('#txtFinalDemerit_' + index + '').parent().removeClass('has-error');
        }
        else {
            $('#txtRemarks_' + index + '').attr('required', true);
            $('#txtFinalDemerit_' + index + '').val(0);
            $('#txtPendingResolution_' + index + '').val(generatedDemeritPoints);
            $('#txtFinalDemerit_' + index + '').parent().removeClass('has-error');
        }
    });

    var actionType = $('#hdnActionType').val();
    if (actionType == 'View') {
        $("input[id^='txtFinalDemerit_'], input[id^='chkIsValid_'], input[id^='txtRemarks_']").attr('disabled', true);
    }
}
function SetPaginationValues(result) {
    var PageIndex = 0;
    var TotalRecords = 0;
    var FirstRecord = 0;
    var LastRecord = 0;
    var LastPageIndex = 0;

    var firstObject = $.grep(result, function (value0, index0) {
        return index0 == 0;
    });
    PageIndex = firstObject[0].PageIndex;
    PageSize = firstObject[0].PageSize;
    TotalRecords = firstObject[0].TotalRecords;
    FirstRecord = firstObject[0].FirstRecord;
    LastRecord = firstObject[0].LastRecord;
    LastPageIndex = firstObject[0].LastPageIndex;

    if (PageIndex == 1) {
        //$('#btnPreviousPage').removeClass('pagerEnabled');
        //$('#btnPreviousPage').addClass('pagerDisabled');
        //$('#btnFirstPage').removeClass('pagerEnabled');
        //$('#btnFirstPage').addClass('pagerDisabled');

        $('#btnPreviousPage').show();
        $('#btnPreviousPage').hide();
        $('#btnFirstPage').show();
        $('#btnFirstPage').hide();
    }
    else {
        //$('#btnPreviousPage').removeClass('pagerDisabled');
        //$('#btnPreviousPage').addClass('pagerEnabled');
        //$('#btnFirstPage').removeClass('pagerDisabled');
        //$('#btnFirstPage').addClass('pagerEnabled');

        $('#btnPreviousPage').hide();
        $('#btnPreviousPage').show();
        $('#btnFirstPage').hide();
        $('#btnFirstPage').show();
    }
    if (PageIndex == LastPageIndex) {
        //$('#btnNextPage').removeClass('pagerEnabled');
        //$('#btnNextPage').addClass('pagerDisabled');
        //$('#btnLastPage').removeClass('pagerEnabled');
        //$('#btnLastPage').addClass('pagerDisabled');

        $('#btnNextPage').show();
        $('#btnNextPage').hide();
        $('#btnLastPage').show();
        $('#btnLastPage').hide();
    }
    else {
        //$('#btnNextPage').removeClass('pagerDisabled');
        //$('#btnNextPage').addClass('pagerEnabled');
        //$('#btnLastPage').removeClass('pagerDisabled');
        //$('#btnLastPage').addClass('pagerEnabled');

        $('#btnNextPage').hide();
        $('#btnNextPage').show();
        $('#btnLastPage').hide();
        $('#btnLastPage').show();
    }

    $('#spnTotalRecords').text(TotalRecords);
    $('#spnFirstRecord').text(FirstRecord);
    $('#spnLastRecord').text(LastRecord);
    $('#spnTotalPages').text(LastPageIndex);
    $('#txtPageIndex').val(PageIndex);
    $('#hdnPageIndex').val(PageIndex);
    $('#selPageSize').val(PageSize);
    AttachPaginationEvents(LastPageIndex);
}

function AttachPaginationEvents(LastPageIndex) {
    $('#btnPreviousPage').unbind("click");
    $('#btnNextPage').unbind("click");
    $('#btnFirstPage').unbind("click");
    $('#btnLastPage').unbind("click");

    $('#btnPreviousPage, #btnNextPage, #btnFirstPage, #btnLastPage').click(function () {
        var id = $(this).attr('id');

        var currentPageIndex = parseInt($('#hdnPageIndex').val());
        if (id == "btnPreviousPage") {
            currentPageIndex -= 1;
        }
        else if (id == "btnNextPage") {
            currentPageIndex += 1;
        }
        else if (id == "btnFirstPage") {
            currentPageIndex = 1;
        }
        else if (id == "btnLastPage") {
            currentPageIndex = LastPageIndex;
        }
        PopulatePopupData(currentPageIndex);
    });

    $('#txtPageIndex').on("keypress", function (e) {
        if (e.keyCode == 13) {
            var pageindex1 = $('#txtPageIndex').val();
            if (pageindex1 == null || pageindex1 == '' || isNaN(pageindex1)) {
                bootbox.alert('Please enter valid page number.');
                $('#txtPageIndex').val($('#hdnPageIndex').val());
                return false;
            } else {
                pageindex1 = parseInt(pageindex1);
                if (pageindex1 > LastPageIndex) {
                    bootbox.alert('Please enter valid page number.');
                    $('#txtPageIndex').val($('#hdnPageIndex').val());
                    return false;
                } else {
                    PopulatePopupData(pageindex1);
                }
            }
        }
    });

    $('#selPageSize').on('change', function () {
        PopulatePopupData(1);
    });
}
function PopulatePopupData(pageIndex) {
    var pageSize = $('#selPageSize').val();
    var id = $('#hdnPrimaryID').val();
    $('#myPleaseWait').modal('show');
    $.get("/api/kPITransactionMapping/Get/" + id + "/" + pageIndex + "/" + pageSize)
    .done(function (response) {
        var result1 = JSON.parse(response);

        if (result1 != null && result1.Transactions != null && result1.Transactions.length > 0) {
            var result = result1.Transactions;
            var firstObject = $.grep(result, function (value0, index0) {
                return index0 == 0;
            });
            $('#hdnPrimaryID').val(firstObject[0].DedTxnMappingId);

            BindData(result);
            $('#divPagination').html(null);
            $('#divPagination').html(paginationString);
            SetPaginationValues(result);
        }
        $('#myPleaseWait').modal('hide');
    })
  .fail(function (response) {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
      $('#errorMsg2').css('visibility', 'visible');
  });
}
function LinkClicked(id) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#frmKPITransactionMapping :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg1').css('visibility', 'hidden');
    $('#errorMsg2').css('visibility', 'hidden');
    var action = "";
    $('#hdnPrimaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission ) {
        action = "Edit";

    }
    else if (!hasEditPermission && hasViewPermission) {
        action = "View";
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#btnDelete').show();
    }

    if (action == 'View') {
        $("#frmKPITransactionMapping :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#hdnPrimaryID').val();
    if (primaryId != null && primaryId != "0") {
        $('#btnAddFetch').hide();
        $.get("/api/kPITransactionMapping/Get/" + primaryId + "/1/5")
          .done(function (result) {
              var result1 = JSON.parse(result);

              if (result1 != null && result1.Transactions != null && result1.Transactions.length > 0) {
                  var result = result1.Transactions;
                  var firstObject = $.grep(result, function (value0, index0) {
                      return index0 == 0;
                  });
                  $('#hdnPrimaryID').val(firstObject[0].DedTxnMappingId);

                  $('#selYear').val(firstObject[0].Year).prop("disabled", true);
                  $('#selMonth').val(firstObject[0].Month).prop("disabled", true);
                  //$('#selService').val(firstObject[0].ServiceId);
                  $('#selIndicator').val(firstObject[0].IndicatorDetId).prop("disabled", true);

                  BindData(result);
                  $('#divPagination').html(null);
                  $('#divPagination').html(paginationString);
                  SetPaginationValues(result);
              }

              $('#myPleaseWait').modal('hide');
          })
         .fail(function (response) {
             $('#myPleaseWait').modal('hide');
             $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
             $('#errorMsg2').css('visibility', 'visible');
         });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}


function EmptyFields() {
    $(".content").scrollTop(0);
    $('input[type="text"], textarea').val(''); 
    $('#selYear').val(2018); 
    $('#selMonth').val("null"); 
    $('#selIndicator').val("null");
    $('#selYear').attr('disabled', false);
    $('#selMonth').prop('disabled', false);
    $('#selIndicator').prop('disabled', false);
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnAddFetch').show();
    $("#hdnPrimaryID").val('');
    $("#grid").trigger('reloadGrid');
    $("#frmKPITransactionMapping :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg1').css('visibility', 'hidden');
    $('#errorMsg2').css('visibility', 'hidden');
    $('.nav-tabs a:first').tab('show');
    $('#tbodyTransactionMapping').empty();
    $('#divPagination').hide();
    
}