//*Golbal variables decration section starts*//
var pageindex = 1, pagesize = 5;
var GridtotalRecords = 0;
var TotalPages = 0, FirstRecord = 0, LastRecord = 0;
//*Golbal variables decration section ends*//

$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    formInputValidation("formVMBulkAuthorization");

    $("#YearId").change(function () {
        var LoadData = GetYearMonth(this.value);

        $('#MonthId').empty();
        $('#MonthId').append('<option value="null">Select</option>');
        $.each(LoadData.MonthData, function (index , value) {
            $('#MonthId').append('<option value="' + (index + 1) + '">' + value[index + 1] + '</option>');
        });

    });

    var LoadData = GetYearMonth();
    $.each(LoadData.MonthData, function (index, value) {
        $('#MonthId').append('<option value="' + (index + 1) + '">' + value[index + 1] + '</option>');
    });
    $.each(LoadData.YearData, function (index, value) {
        $('#YearId').append('<option value="' + value + '">' + value + '</option>');
    });
  //  $('#YearId').val(LoadData.CurrentYear);

    $.get("/api/bulkauthorization/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            
            $.each(loadResult.ServiceData, function (index, value) {
               // if (value.LovId == 2)
                    $('#ServiceId').append('<option selected value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
        })
      .fail(function () {
          $('#myPleaseWait').modal('hide');
          $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
          $('#errorMsg').css('visibility', 'visible');
      });

    $("#btnFetchAdd").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
          $("#YearId").prop("required", true);

        var isFormValid = formInputValidation("formVMBulkAuthorization", 'save');
        if (!isFormValid) {
            errorMsg("INVALID_INPUT_MESSAGE");
            return false;
        }

        var UrlData = { Year: $('#YearId').val(), Month: $('#MonthId').val(), ServiceId: $('#ServiceId').val() }

        $.get("/api/bulkauthorization/Get/" + UrlData.Year + "/" + UrlData.Month + "/" + UrlData.ServiceId + "/" + pagesize + "/" + pageindex)
       .done(function (result) {
           var result = JSON.parse(result);
           
           $("#BulkAuthorizetbodyId").empty();
           $.each(result.BulkAuthorizationListData, function (index, value) {
               AddNewRow();
               $("#hdnVariationId_" + index).val(value.VariationId);
               $("#hdnAssetId_" + index).val(value.AssetId);
               $("#AssetNo_" + index).val(value.AssetNo).prop('title', value.AssetNo);
               $("#AssetDescription_" + index).val(value.AssetDescription).prop('title', value.AssetDescription);
               $("#UserLocationName_" + index).val(value.UserLocationName).prop('title', value.UserLocationName);
               $("#SNFDocumentNo_" + index).val(value.SNFDocumentNo).prop('title', value.SNFDocumentNo);
               $("#VariationStatus_" + index).val(value.VariationStatus).prop('title', value.VariationStatus); 
               $("#PurchaseProjectCost_" + index).val(value.PurchaseProjectCost).prop('title', value.PurchaseProjectCost);
               $("#CommissioningDate_" + index).val(value.CommissioningDate).prop('title', DateFormatter(value.CommissioningDate));
               $("#CommissioningDate_" + index).val(DateFormatter(value.CommissioningDate));
               $("#StartServiceDate_" + index).val(value.StartServiceDate).prop('title', DateFormatter(value.StartServiceDate));
               $("#StartServiceDate_" + index).val(DateFormatter(value.StartServiceDate));
               $("#WarrantyEndDate_" + index).val(value.WarrantyEndDate).prop('title', DateFormatter(value.WarrantyEndDate));
               $("#WarrantyEndDate_" + index).val(DateFormatter(value.WarrantyEndDate));
               $("#VariationDate_" + index).val(value.VariationDate).prop('title', DateFormatter(value.VariationDate));
               $("#VariationDate_" + index).val(DateFormatter(value.VariationDate));
               $("#ServiceStopDate_" + index).val(value.ServiceStopDate).prop('title', DateFormatter(value.ServiceStopDate));
               $("#ServiceStopDate_" + index).val(DateFormatter(value.ServiceStopDate));
               $("#IsAuthorizedStatus_" + index).prop("checked", value.AuthorizedStatus);
           });

           if ((result.BulkAuthorizationListData && result.BulkAuthorizationListData.length) > 0) {
               $("#HideGridSaveButtonDiv,#NoRecordsDiv").show();
               $("#HideFetchButtonDiv").hide();              
               $("#chk_AllGridIsAuthorize").prop("disabled", false);
               $("#YearId,#MonthId").prop("disabled", true);
               $("#paginationfooter").show();

               GridtotalRecords = result.BulkAuthorizationListData[0].TotalRecords;
               TotalPages = result.BulkAuthorizationListData[0].TotalPages;
               LastRecord = result.BulkAuthorizationListData[0].LastRecord;
               FirstRecord = result.BulkAuthorizationListData[0].FirstRecord;
               pageindex = result.BulkAuthorizationListData[0].PageIndex;
           } else {
               $("#paginationfooter").hide();
               $("#BulkAuthorizetbodyId").append('<tr id="NoRecordsDiv" aria-hidden="false"><td width="100%" data-original-title="" title="">' +
                                            '<h5 class="text-center"><span style="color:black;" href="#">No Records to Display</span></h5></td></tr>');
           }          
           var mapIdproperty = ["VariationId-hdnVariationId_", "AssetNo-AssetNo_", "AssetDescription-AssetDescription_", "UserLocationName-UserLocationName_", "SNFDocumentNo-SNFDocumentNo_",
                               "VariationStatus-VariationStatus_", "PurchaseProjectCost-PurchaseProjectCost_", "CommissioningDate-CommissioningDate_", "StartServiceDate-StartServiceDate_",
                               "WarrantyEndDate-WarrantyEndDate_", "VariationDate-VariationDate_", "ServiceStopDate-ServiceStopDate_", "AuthorizedStatus-IsAuthorizedStatus_"];
           var htmltext = BulkInlineGridHtml();//Inline Html
           var obj = {
               formId: "#form", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "BulkAuthorization", mapIdproperty: mapIdproperty, htmltext: htmltext,
               GridtotalRecords: GridtotalRecords, ListName: "BulkAuthorizationListData", tableid: '#BulkAuthorizetbodyId', destionId: "#paginationfooter",
               TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord,
               geturl: "/api/bulkauthorization/Get/" + UrlData.Year + "/" + UrlData.Month + "/" + UrlData.ServiceId, pageindex: pageindex, pagesize: pagesize
           };

           CreateFooterPagination(obj);

           $('#myPleaseWait').modal('hide');
       })
       .fail(function () {
           $('#myPleaseWait').modal('hide');
           $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
           $('#errorMsg').css('visibility', 'visible');
       });

    });

    $("#btnSave").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var BulkAuthorizationListData = [];
        $('#BulkAuthorizetbodyId tr').map(function (i) {
            var IsAuthorized = $('#IsAuthorizedStatus_' + i).is(":checked");
            if (IsAuthorized)
                BulkAuthorizationListData.push({
                    VariationId: $('#hdnVariationId_' + i).val(),
                    AuthorizedStatus: IsAuthorized,
                    SNFDocumentNo: $('#SNFDocumentNo_' + i).val(),
                    AssetId: $('#hdnAssetId_' + i).val(),
                });
        });

        var isFormValid = formInputValidation("formVMBulkAuthorization", 'save');
        if (!isFormValid) {
            errorMsg("INVALID_INPUT_MESSAGE");
            return false;
        } else if (BulkAuthorizationListData.length == 0) {
            errorMsg("Please select atleast one record to Authorize.");
            return false;
        }

        var UrlData = { Year: $('#YearId').val(), Month: $('#MonthId').val(), ServiceId: $('#ServiceId').val() }
        var BulkAuthorizationViewModel = {
            BulkAuthorizationListData: BulkAuthorizationListData,
            Month: UrlData.Month,
            Year: UrlData.Year,
            ServiceId: UrlData.ServiceId
        }

        $.post("/api/bulkauthorization/Save", BulkAuthorizationViewModel)
        .done(function (response) {
            var result = JSON.parse(response);
            
            $(".content").scrollTop(0);
            showMessage('Accessories', CURD_MESSAGE_STATUS.SS);
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
            $("div.errormsgcenter").text(errorMessage).css('visibility', 'visible');
            //$('#errorMsg').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
    });

    $("#chk_AllGridIsAuthorize").change(function () {
        var IsAuthorizebool = this.checked;
        $('#BulkAuthorizetbodyId tr').map(function (i) {
            if (IsAuthorizebool)
                $("#IsAuthorizedStatus_" + i).prop("checked", true);
            else
                $("#IsAuthorizedStatus_" + i).prop("checked", false);
        });
    });

   
    $("#btnAddNew").click(function () {
        window.location.href = window.location.href;
    });

});

function errorMsg(errMsg) {
    $("div.errormsgcenter").text((!Messages[errMsg]) ? errMsg : Messages[errMsg]).css('visibility', 'visible');

    $('#btnlogin').attr('disabled', false);
    $('#myPleaseWait').modal('hide');
    InvalidFn();
    return false;
}


function IsAuthorizedStatusCheckAll(tbodyId, IsAuthorizeHeaderId) {
    
    var IsAuthorize_ = [];
    tbodyId = '#' + tbodyId.id + ' tr';
    IsAuthorizeHeaderId = "#" + IsAuthorizeHeaderId.id;

    $(tbodyId).map(function (index, value) {
        var IsAuthorize = $("#IsAuthorizedStatus_" + index).is(":checked");
        if (IsAuthorize)
            IsAuthorize_.push(IsAuthorize);
    });

    if ($(tbodyId).length == IsAuthorize_.length)
        $(IsAuthorizeHeaderId).prop("checked", true);
    else
        $(IsAuthorizeHeaderId).prop("checked", false);
}

function BulkInlineGridHtml() {
    
    return '<tr><td width="8%" title=""><div><input id="hdnVariationId_maxindexval" type="hidden" class="form-control">' + 
            '<input id="hdnAssetId_maxindexval" type="hidden" class="form-control"><input id="AssetNo_maxindexval" type="text" disabled class="form-control" autocomplete="off"></div></td>' +
            '<td width="9%" style="text-align: center;"><div><input id="AssetDescription_maxindexval" disabled type="text" class="form-control" autocomplete="off"></div></td>' +
            '<td width="8%" style="text-align: center;"><div><input id="UserLocationName_maxindexval" disabled type="text" class="form-control" autocomplete="off"></div></td>' +
            '<td width="10%" style="text-align: center;"><div><input id="SNFDocumentNo_maxindexval" disabled type="text" class="form-control" autocomplete="off"></div></td>' +
            '<td width="7%" style="text-align: center;"><div><input id="VariationStatus_maxindexval" disabled type="text" class="form-control" autocomplete="off"></div></td>' +
            '<td width="11%" style="text-align: right;"><div><input id="PurchaseProjectCost_maxindexval" disabled type="text" class="form-control text-right" autocomplete="off"></div></td>' +
            '<td width="8%" style="text-align: center;"><div><input id="CommissioningDate_maxindexval" disabled type="text" class="form-control" autocomplete="off"></div></td>' +
            '<td width="8%" style="text-align: center;"><div><input id="StartServiceDate_maxindexval" disabled type="text" class="form-control" autocomplete="off"></div></td>' +
            '<td width="8%" style="text-align: center;"><div><input id="WarrantyEndDate_maxindexval" disabled type="text" class="form-control" autocomplete="off"></div></td>' +
            '<td width="8%" style="text-align: center;"><div><input id="VariationDate_maxindexval" disabled type="text" class="form-control" autocomplete="off"></div></td>' +
            '<td width="8%" style="text-align: center;"><div><input id="ServiceStopDate_maxindexval" disabled type="text" class="form-control" autocomplete="off"></div></td>' +
            '<td width="7%" style="text-align: center;"><div class="checkbox text-center"><label for="checkboxes-0"><input type="checkbox" id="IsAuthorizedStatus_maxindexval" onchange="IsAuthorizedStatusCheckAll(BulkAuthorizetbodyId,chk_AllGridIsAuthorize)" autocomplete="off" tabindex="0"></label></div></td>';
}

function AddNewRow() {

    var inputpar = {
        inlineHTML: BulkInlineGridHtml(),
        TargetId: "#BulkAuthorizetbodyId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
}