//*Golbal variables decration section starts*//
var pageindex = 1; var pagesize = 5;
var LOVlist = {};
var GridtotalRecords;
var TotalPages, FirstRecord, LastRecord = 0;
//*Golbal variables decration section ends*//


$(document).ready(function () {

    formInputValidation("WarrantyManagementForm");
    $.get("/api/WarrantyManagement/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#jQGridCollapse1").click();
            var CurDate = GetCurrentDate();
            $('#WarrantyManDocDate').val(CurDate);
            $.each(loadResult.ServiceLovs, function (index, value) {
                if (value.LovId == 2)
                    $('#WarrantymanService').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            validation();

 //******************************************** Getby ID ****************************************************
            var primaryId = $('#primaryID').val();
            if (primaryId != null && primaryId != "0") {
                $.get("/api/WarrantyManagement/Get/" + primaryId)
                  .done(function (result) {


                      var getResult = JSON.parse(result);

                      if ($('#ActionType').val() != "ADD") {
                          $("#lblAssetNo").html("Asset No.");
                          $("#lblWarrantyDate").html("Warranty Document Date");
                      }

                      //var warDate = getResult.IsWarrantyDateNull ? "" : DateFormatter(getResult.WarrantyDate);
                      //$('#WarrantyManDocDate').val(warDate).prop("disabled", "disabled");

                      //var warstDate = getResult.IsWarrStartDateNull ? "" : DateFormatter(getResult.WarrantyStartDate);
                      //$('#WarrantymanWarSrtDate').val(warstDate);

                      //var warendDate = getResult.IsWarrEndDateNull ? "" : DateFormatter(getResult.WarrantyEndDate);
                      //$('#WarrantymanWarEndDate').val(warendDate);

                      //$('#WarrantyManDocNo').val(getResult.WarrantyNo).prop("disabled","disabled");
                      ////$('#WarrantyManDocDate').val(DateFormatter(getResult.WarrantyDate)).prop("disabled", "disabled");
                      //$('#WarrantyManTCNo').val(getResult.TnCRefNo);
                      //$('#WarrantymanService option[value="' + getResult.ServiceId + '"]').prop('selected', true);
                      //$('#WarrantymanAssetClassification').val(getResult.AssetClassification);
                      //$('#WarrantymanAssetNo').val(getResult.AssetNo).prop("disabled", "disabled");
                      //$('#hdnWarrantymanAssetId').val(getResult.AssetId);
                      //$('#WarrantymanAssetTypeCode').val(getResult.TypeCode);
                      //$('#WarrantymanAssetDesc').val(getResult.AssetDescription);
                      ////$('#WarrantymanWarSrtDate').val(DateFormatter(getResult.WarrantyStartDate));
                      ////$('#WarrantymanWarEndDate').val(DateFormatter(getResult.WarrantyEndDate));
                      //$('#WarrantymanWarPer').val(getResult.WarrantyPeriod);
                      //$('#WarrantymanPurCost').val(getResult.PurchaseCost);
                      //$('#WarrantymanDWFee').val(getResult.DWFee);
                      //$('#WarrantymanPWFee').val(getResult.PWFee);
                      //$('#WarrantymanDownTime').val(getResult.WarrantyDownTime);
                      //$('#WarrantymanRem').val(getResult.Remarks);
                      //$('#primaryID').val(getResult.WarrantyMgmtId);
                      GetWarrantyData(getResult);

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


 //****************************************** Save *********************************************

    $('#btnEdit,#btnSave').click(function () {
        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var DocumentNo = $('#WarrantyManDocNo').val();
        var DocumentDate = $('#WarrantyManDocDate').val();
        var ServiceId = $('#WarrantymanService').val();
        var DocumentDateUTC = $('#WarrantyManDocDate').val();
        var Assetno = $('#WarrantymanAssetNo').val();
        var Assetid = $('#hdnWarrantymanAssetId').val();        
        var Remarks = $('#WarrantymanRem').val();
        var timeStamp = $("#Timestamp").val();

        //var operation = $('#primaryID').val() == 0 ? "Save" : "Update";


        //var isFormValid = formInputValidation("WarrantyManagementForm", 'save');
        //if (!isFormValid) {
        //    $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        //    $('#errorMsg').css('visibility', 'visible');
        //    $('#myPleaseWait').modal('hide');
        //    $('#btnSave').attr('disabled', false);
        //    //$('#btnEdit').attr('disabled', false);
        //    return false;
        //}

        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            WarrantyManId = primaryId;
            timeStamp = timeStamp;
        }
        else {
            WarrantyManId = 0;
            timeStamp = "";
        }

        var WarManData = {
            WarrantyMgmtId: WarrantyManId,
            WarrantyNo: DocumentNo,
            WarrantyDate: DocumentDate,
            ServiceId: ServiceId,
            WarrantyDateUtc: DocumentDateUTC,
            //AssetNo: Assetno,
            AssetId: Assetid,
            Remarks: Remarks,
            Timestamp: timeStamp
        }

        var isFormValid = formInputValidation("WarrantyManagementForm", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            //$('#btnEdit').attr('disabled', false);
            return false;
        }

        if (Assetid == '') {
            DisplayErrorMessage("Valid Asset No. is required.");
            return false;
        }
        function DisplayErrorMessage(errorMessage) {
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var jqxhr = $.post("/api/WarrantyManagement/Save", WarManData, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.WarrantyMgmtId);
            $("#Timestamp").val(result.Timestamp);
            GetWarrantyData(result);
            $(".content").scrollTop(0);
            showMessage('WarrantyManagement', CURD_MESSAGE_STATUS.US);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');

            //Enabling Nxt tab after saving
           /// $('#DefectDetailstab').prop('href', '#WarrantyManagementDD');

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
        window.location.href = "/bems/WarrantyManagement";
    });
    $("#btnAddNew").click(function () {
        window.location.href = window.location.href;
    });

    $(".nav-tabs > li:not(:first-child)").click(function () {
        //var primaryId = $('#primaryID').val();
        var priId = $('#primaryID').val();
        if (priId == 0) {
            bootbox.alert("Warranty Management details must be Saved before entering additional information");
            return false;
        }
    });


    //******************************************** Get Work Order Details By ID ****************************************************

    $("#Workordertab").click(function () {
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/WarrantyManagement/GetWO/" + primaryId + "/" + pagesize + "/" + pageindex)
          .done(function (result) {
              var getResult = JSON.parse(result);
              var wrkordr = getResult.WMWorkorderGriddata;

              $('#WMWODocNo').val($('#WarrantyManDocNo').val()).prop("disabled", "disabled");
              $('#WMWODocDate').val($('#WarrantyManDocDate').val()).prop("disabled", "disabled");
              $('#WMWOAssetNo').val($('#WarrantymanAssetNo').val()).prop("disabled", "disabled");
              $('#WMWOAssetDesc').val($('#WarrantymanAssetDesc').val()).prop("disabled", "disabled");

              $("#WMworkordertabgrid").empty();
              $.each(wrkordr, function (index, value) {
                  AddNewRowWorkorder();

                  //GridtotalRecords = value.TotalRecords;
                  //TotalPages = value.TotalPages;
                  //LastRecord = value.LastRecord;
                  //FirstRecord = value.FirstRecord;
                  //pageindex = value.PageIndex;

                  $("#WMWOWorkorderno_" + index).val(wrkordr[index].WorkorderNo).prop("disabled", "disabled");
                  $("#WMWoWorkorderType_" + index).val(wrkordr[index].WorkorderType).prop("disabled", "disabled");

                  var resdate = wrkordr[index].IsResposeDateNull ? "" : DateFormatter(wrkordr[index].ResponseDate);
                  $('#WMWOResponseDate_' + index).val(resdate).prop("disabled", "disabled");

                  var tardate = wrkordr[index].IsTargetDateNull ? "" : DateFormatter(wrkordr[index].TargetDate);
                  $('#WMWOTargetDate_' + index).val(tardate).prop("disabled", "disabled");

                  var comdate = wrkordr[index].IsCompDateNull ? "" : DateFormatter(wrkordr[index].CompletionDate);
                  $('#WMWOCompDate_' + index).val(comdate).prop("disabled", "disabled");

                  //$("#WMWOResponseDate_" + index).val(DateFormatter(wrkordr[index].ResponseDate)).prop("disabled", "disabled");
                  //$('#WMWOTargetDate_' + index).val(DateFormatter(wrkordr[index].TargetDate)).prop("disabled", "disabled");
                  //$('#WMWOCompDate_' + index).val(DateFormatter(wrkordr[index].CompletionDate)).prop("disabled", "disabled");
                  $("#WMWOStatus_" + index).val(wrkordr[index].WorkorderStatus).prop("disabled", "disabled");
              });

              if ((wrkordr && wrkordr.length) > 0) {
                  //AssetId = result.AssetId;
                  GridtotalRecords = wrkordr[0].TotalRecords;
                  TotalPages = wrkordr[0].TotalPages;
                  LastRecord = wrkordr[0].LastRecord;
                  FirstRecord = wrkordr[0].FirstRecord;
                  pageindex = wrkordr[0].PageIndex;
              }

              else if (wrkordr == null) {
                  GridtotalRecords = 0;
                  TotalPages = 1;
                  LastRecord = 0;
                  FirstRecord = 0;
                  pageindex = 1;
              }

              // Added for pagination purpose to select html
              var mapIdproperty = ["WorkorderNo-WMWOWorkorderno_", "WorkorderType-WMWoWorkorderType_", "ResponseDate-WMWOResponseDate_", "TargetDate-WMWOTargetDate_", "CompletionDate-WMWOCompDate_", "WorkorderStatus-WMWOStatus_"];
              var inlineHTML = ' <tr class="ng-scope" style=""><td width="20%" style="text-align:left;" data-original-title="" title=""><div> <input type="text" id="WMWOWorkorderno_maxindexval" value="" class="form-control fetchField "></div></td> \
                        <td width="15%" style="text-align: left;" data-original-title="" title=""><div> <input type="text" id="WMWoWorkorderType_maxindexval" value="" class="form-control fetchField "></div></td> \
                        <td width="15%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="WMWOResponseDate_maxindexval" value="" class="form-control fetchField "></div></td> \
                        <td width="15%" style="text-align:center;" data-original-title="" title=""><div> <input type="text" id="WMWOTargetDate_maxindexval" value="" class="form-control fetchField "></div></td> \
                        <td width="15%" style="text-align:center;" data-original-title="" title=""><div> <input type="text" id="WMWOCompDate_maxindexval" value="" class="form-control fetchField "></div></td> \
                        <td width="20%" style="text-align:center;" data-original-title="" title=""><div> <input type="text" id="WMWOStatus_maxindexval" value="" class="form-control fetchField "></div></td></tr>';
              var obj = { formId: "#WarrantyManagementWOForm", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "WarrantyManagement", mapIdproperty: mapIdproperty, htmltext: inlineHTML, GridtotalRecords: GridtotalRecords, ListName: "WMWorkorderGriddata", tableid: '#WMworkordertabgrid', destionId: "#paginationfooterWorkorder", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/WarrantyManagement/GetWO/" + primaryId, pageindex: pageindex, pagesize: pagesize };
              CreateFooterPagination(obj);

             // $('#primaryID').val(wrkordr.WarrantyMgmtId);
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
    });
    $("#workordertabBack").click(function () {
        window.location.href = "/bems/WarrantyManagement";
    });

    //******************************************** Get Defect Details By ID ****************************************************

    $("#DefectDetailstab").click(function () {
        var primaryId = $('#primaryID').val();
        if (primaryId != null && primaryId != "0") {
            $.get("/api/WarrantyManagement/GetDD/" + primaryId + "/" + pagesize + "/" + pageindex)
              .done(function (result) {
                  var getResult = JSON.parse(result);
                  var defdet = getResult.WMDefectDetailsGriddata;

                  $('#WMDDDocNo').val($('#WarrantyManDocNo').val()).prop("disabled", "disabled");
                  $('#WMDDDocDate').val($('#WarrantyManDocDate').val()).prop("disabled", "disabled");

                  $("#WMDefDetailstabgrid").empty();
                  $.each(defdet, function (index, value) {
                      AddNewRowDefDet();

                      //GridtotalRecords = value.TotalRecords;
                      //TotalPages = value.TotalPages;
                      //LastRecord = value.LastRecord;
                      //FirstRecord = value.FirstRecord;
                      //pageindex = value.PageIndex;

                      var defdate = defdet[index].IsDefectDateNull ? "" : DateFormatter(defdet[index].DefectDate);
                      $('#WMDDDefectDate_' + index).val(defdate).prop("disabled", "disabled");


                      //$("#WMDDDefectDate_" + index).val(DateFormatter(defdet[index].DefectDate)).prop("disabled", "disabled");
                      $("#WMDDDefectDet_" + index).val(defdet[index].DefectDetails).prop("disabled", "disabled");

                      var srtdat = defdet[index].IsStartDateNull ? "" : DateFormatter(defdet[index].StartDate);
                      $('#WMDDStartDate_' + index).val(srtdat).prop("disabled", "disabled");

                      //$("#WMDDStartDate_" + index).val(DateFormatter(defdet[index].StartDate)).prop("disabled", "disabled");
                      $('#WMDDIsComp_' + index).prop('checked', defdet[index].IsCompleted);
                      $('#WMDDIsComp_' + index).val(defdet[index].IsCompleted).prop("disabled", "disabled");

                      var comdat = defdet[index].IsCompletionDateNull ? "" : DateFormatter(defdet[index].CompletionDate);
                      $('#WMDDCompDate_' + index).val(comdat).prop("disabled", "disabled");

                      //$('#WMDDCompDate_' + index).val(DateFormatter(defdet[index].CompletionDate)).prop("disabled", "disabled");
                      $("#WMDDActionTakn_" + index).val(defdet[index].ActionTaken).prop("disabled", "disabled");
                  });

                  if ((defdet && defdet.length) > 0) {
                      //ParameterMappingId = defdet.ParameterMappingId;
                      GridtotalRecords = defdet[0].TotalRecords;
                      TotalPages = defdet[0].TotalPages;
                      LastRecord = defdet[0].LastRecord;
                      FirstRecord = defdet[0].FirstRecord;
                      pageindex = defdet[0].PageIndex;
                  }

                  else if (defdet == null) {
                      GridtotalRecords = 0;
                      TotalPages = 1;
                      LastRecord = 0;
                      FirstRecord = 0;
                      pageindex = 1;
                  }
                  
                  // Added for pagination purpose to select html
                  var mapIdproperty = ["DefectDate-WMDDDefectDate", "DefectDetails-WMDDDefectDet_", "StartDate-WMDDStartDate_", "IsCompleted-WMDDIsComp_", "CompletionDate-WMDDCompDate_", "ActionTaken-WMDDActionTakn_"];
                  var inlineHTML = ' <tr class="ng-scope" style=""><td width="15%" style="text-align:left;" data-original-title="" title=""><div> <input type="text" id="WMDDDefectDate_maxindexval" value="" class="form-control fetchField "></div></td> \
                                        <td width="25%" style="text-align: left;" data-original-title="" title=""><div> <input type="text" id="WMDDDefectDet_maxindexval" class="form-control fetchField "></div></td> \
                                        <td width="15%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="WMDDStartDate_maxindexval" class="form-control fetchField "></div></td> \
                                        <td width="10%" style="text-align:center;" data-original-title="" title=""><div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" id="WMDDIsComp_maxindexval" autocomplete="off" class="ng-pristine ng-untouched ng-valid" disabled> </label></div></td> \
                                        <td width="15%" style="text-align:center;" data-original-title="" title=""><div> <input type="text" id="WMDDCompDate_maxindexval" class="form-control fetchField "></div></td> \
                                        <td width="20%" style="text-align:center;" data-original-title="" title=""><div> <input type="text" id="WMDDActionTakn_maxindexval" class="form-control fetchField "></div></td></tr>';
                  var obj = { formId: "#WarrantyManagementDDForm", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "WarrantyManagement", mapIdproperty: mapIdproperty, htmltext: inlineHTML, GridtotalRecords: GridtotalRecords, ListName: "WMDefectDetailsGriddata", tableid: '#WMDefDetailstabgrid', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/WarrantyManagement/GetDD/" + primaryId, pageindex: pageindex, pagesize: pagesize };

                  CreateFooterPagination(obj);

                //  $('#primaryID').val(defdet.WarrantyMgmtId);
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
    });
    $("#defdettabBack").click(function () {
        window.location.href = "/bems/WarrantyManagement";
    });

});

function GetWarrantyData(getResult) {
    var warDate = getResult.IsWarrantyDateNull ? "" : DateFormatter(getResult.WarrantyDate);
    $('#WarrantyManDocDate').val(warDate).prop("disabled", "disabled");

    var warstDate = getResult.IsWarrStartDateNull ? "" : DateFormatter(getResult.WarrantyStartDate);
    $('#WarrantymanWarSrtDate').val(warstDate);

    var warendDate = getResult.IsWarrEndDateNull ? "" : DateFormatter(getResult.WarrantyEndDate);
    $('#WarrantymanWarEndDate').val(warendDate);

    $('#WarrantyManDocNo').val(getResult.WarrantyNo).prop("disabled", "disabled");
    //$('#WarrantyManDocDate').val(DateFormatter(getResult.WarrantyDate)).prop("disabled", "disabled");
    $('#WarrantyManTCNo').val(getResult.TnCRefNo);
    $('#WarrantymanService option[value="' + getResult.ServiceId + '"]').prop('selected', true);
    $('#WarrantymanAssetClassification').val(getResult.AssetClassification);
    $('#WarrantymanAssetNo').val(getResult.AssetNo).prop("disabled", "disabled");
    $('#hdnWarrantymanAssetId').val(getResult.AssetId);
    $('#WarrantymanAssetTypeCode').val(getResult.TypeCode);
    $('#WarrantymanAssetDesc').val(getResult.AssetDescription);
    //$('#WarrantymanWarSrtDate').val(DateFormatter(getResult.WarrantyStartDate));
    //$('#WarrantymanWarEndDate').val(DateFormatter(getResult.WarrantyEndDate));
    $('#WarrantymanWarPer').val(getResult.WarrantyPeriod);
    $('#WarrantymanPurCost').val(getResult.PurchaseCost);
    $('#WarrantymanDWFee').val(getResult.DWFee);
    $('#WarrantymanPWFee').val(getResult.PWFee);
    $('#WarrantymanDownTime').val(getResult.WarrantyDownTime);
    $('#WarrantymanRem').val(getResult.Remarks);
    $('#primaryID').val(getResult.WarrantyMgmtId);
    $("#Timestamp").val(getResult.Timestamp)

}

function FetchAssetData(event) {
    var ItemMst = {
        SearchColumn: 'WarrantymanAssetNo' + '-AssetNo',//Id of Fetch field
        ResultColumns: ["AssetId-Primary Key", "AssetNo-WarrantymanAssetNo"],//Columns to be displayed
        FieldsToBeFilled: ["hdnWarrantymanAssetId-AssetId", 'WarrantymanAssetNo-AssetNo', 'WarrantyManTCNo-TnCRefNo', 'WarrantymanAssetClassification-AssetClassification', 'WarrantymanAssetTypeCode-TypeCode', 'WarrantymanAssetDesc-AssetDescription',
                            'WarrantymanWarSrtDate-WarrantyStartDate', 'WarrantymanWarEndDate-WarrantyEndDate', 'WarrantymanWarPer-WarrantyPeriod', 'WarrantymanPurCost-PurchaseCost', 'WarrantymanDWFee-DWFee', 'WarrantymanPWFee-PWFee', 'WarrantymanDownTime-WarrantyDownTime']//id of element - the model property
    };
    DisplayFetchResult('AssetDetailsFetch', ItemMst, "/api/Fetch/AssetNoFetch", "Ulfetch", event, 1);
}

function AddNewRowWorkorder() {
    var inputpar = {
        inlineHTML: ' <tr class="ng-scope" style=""><td width="20%" style="text-align:left;" data-original-title="" title=""><div> <input type="text" id="WMWOWorkorderno_maxindexval" value="" class="form-control fetchField "></div></td> \
                        <td width="15%" style="text-align: left;" data-original-title="" title=""><div> <input type="text" id="WMWoWorkorderType_maxindexval" value="" class="form-control fetchField "></div></td> \
                        <td width="15%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="WMWOResponseDate_maxindexval" value="" class="form-control fetchField "></div></td> \
                        <td width="15%" style="text-align:center;" data-original-title="" title=""><div> <input type="text" id="WMWOTargetDate_maxindexval" value="" class="form-control fetchField "></div></td> \
                        <td width="15%" style="text-align:center;" data-original-title="" title=""><div> <input type="text" id="WMWOCompDate_maxindexval" value="" class="form-control fetchField "></div></td> \
                        <td width="20%" style="text-align:center;" data-original-title="" title=""><div> <input type="text" id="WMWOStatus_maxindexval" value="" class="form-control fetchField "></div></td></tr>',
        IdPlaceholderused: "maxindexval",
        TargetId: "#WMworkordertabgrid",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    formInputValidation("WarrantyManagementWOForm");
}

function AddNewRowDefDet() {
    var inputpar = {
        inlineHTML: '<tr class="ng-scope" style=""><td width="15%" style="text-align:left;" data-original-title="" title=""><div> <input type="text" id="WMDDDefectDate_maxindexval" value="" class="form-control fetchField "></div></td> \
                        <td width="25%" style="text-align: left;" data-original-title="" title=""><div> <input type="text" id="WMDDDefectDet_maxindexval" class="form-control fetchField "></div></td> \
                        <td width="15%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="WMDDStartDate_maxindexval" class="form-control fetchField "></div></td> \
                        <td width="10%" style="text-align:center;" data-original-title="" title=""><div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" id="WMDDIsComp_maxindexval" autocomplete="off" class="ng-pristine ng-untouched ng-valid" disabled> </label></div></td> \
                        <td width="15%" style="text-align:center;" data-original-title="" title=""><div> <input type="text" id="WMDDCompDate_maxindexval" class="form-control fetchField "></div></td> \
                        <td width="20%" style="text-align:center;" data-original-title="" title=""><div> <input type="text" id="WMDDActionTakn_maxindexval" class="form-control fetchField "></div></td></tr>',
        IdPlaceholderused: "maxindexval",
        TargetId: "#WMDefDetailstabgrid",
        TargetElement: ["tr"]
    }


    AddNewRowToDataGrid(inputpar);

    formInputValidation("WarrantyManagementDDForm");
}

function validation() {
    $('.Rem').on('input paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^&*_+=|\\{}\[\]?<>/\^]/g, ''));
        }, 5);
    });
}
