//*Golbal variables decration section starts*//
var ckNewRowPaginationValidation = false;
var pageindex = 1; var pagesize = 5;
var LOVlist = {};
var GridtotalRecords;
var id = $('#primaryID').val();
var obj = {};
var TotalPages = 1, FirstRecord, LastRecord = 0;
var CurrentbtnID;
var hasApprovePermission =  Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");

//*Golbal variables decration section ends*//

$(document).ready(function () {
    formInputValidation("form");
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    var ActionType = $('#ActionType').val();
    var id = $('#primaryID').val();
    if (ActionType != "ADD") {
        $("#Date").prop("disabled", true);
        $("#addnewbtn").hide();
    }
    

    var jqxhr = $.get("/api/FemsStockUpdateRegisterApi/Load", function (response) {
        var result = response;
        LOVlist = result;
        var htmlval = ""; $('#tablebody').empty();
        AddNewRow();
        $("#jQGridCollapse1").click();        
    })
      .fail(function (response) {
          var errorMessage = "";         
          errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);          
          $("div.errormsgcenter").text(errorMessage);
          $('#errorMsg').css('visibility', 'visible');
          $('#btnSave').attr('disabled', false);
          $('#myPleaseWait').modal('hide');
      });

    $("#jQGridCollapse1").click(function () {      
        var pro = new Promise(function (res, err) {
            $(".jqContainer").toggleClass("hide_container");
            res(1);
        })
        pro.then(
            function resposes() {
                setTimeout(() => $(".content").scrollTop(3000), 1);
            })
    })

    
    //************************************ Grid Delete 

    $("#chk_stkUpdateregdet").change(function () {
        var Isdeletebool = this.checked;

        if (this.checked) {
            $('#myTable tr').map(function (i) {
                if ($("#Isdeleted_" + i).prop("disabled")) {
                    $("#Isdeleted_" + i).prop("checked", false);
                }
                else {
                    $("#Isdeleted_" + i).prop("checked", true);
                }
            });
        } else {
            $('#myTable tr').map(function (i) {
                $("#Isdeleted_" + i).prop("checked", false);
            });
        }
    });

});



function BindDatatoHeader(value) {
    $('#FacilityCode').val(value.FacilityCode);
    $('#primaryID').val(value.StockUpdateId);
    $('#CustomerId').val(value.CustomerId);
    $('#FacilityName').val(value.FacilityName);
    $('#ServiceId').val(value.ServiceId);
    $('#Date').val(DateFormatter(value.Date));
    if (value.TotalCost) {
        $('#TotalCost').val(addCommas(value.TotalCost));
    }
    else {
        $('#TotalCost').val(value.TotalCost);
    }
    $('#StockUpdateNo').val(value.StockUpdateNo);
}

function bindDatatoDatagrid(list) {

    $('#chk_stkUpdateregdet').prop("checked", false);
    if (list.length > 0) {
        $('#myTable').empty()
        var html = '';

        $(list).each(function (index, data) {                        

            html = ' <tr> <td width="3%"> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" onchange="IsDeleteCheckAll(myTable,chk_stkUpdateregdet)" id="Isdeleted_' + index + '"> </label> </div></td> \
                            <td width="6%" style="text-align: center;"> <div> <div> <input type="text" placeholder="Please select" required id="partno_' + index + '" value="' + data.Partno + '" title="' + data.Partno + '" class="form-control" onkeyup="Fetchdata(event,' + index + ')" onpaste="Fetchdata(event,' + index + ')" change="Fetchdata(event,' + index + ')" oninput="Fetchdata(event,' + index + ')"> </div><input type="hidden" id="SparePartsId_' + index + '" value="' + data.SparePartsId + '"/> <input type="hidden" id="IsExpirydate_' + index + '" value="' + data.IsExpirydate + '"/> <input type="hidden" id="hdnEstimatedlifespanId_' + index + '" value="' + data.EstimatedLifeSpanId + '"/> <div class="col-sm-12" id="divFetch_' + index + '"></div><input type="hidden" id="StockUpdateDetId_' + index + '" value="' + data.StockUpdateDetId + '"/> <div class="col-sm-12" id="divFetch_' + index + '"></div></div></td> \
                            <td width="7%" style="text-align: center;"> <div> <input type="text" disabled id="PartDescription_' + index + '" value="' + data.PartDescription + '" title="' + data.PartDescription + '" class="form-control"> </div></td> \
                            <td width="6%" style="text-align: center;"> <div> <select required id="SaprePartType_' + index + '" class="form-control " name="typeCodeDetailsMaintenanceFlag"></select> </div></td> \
                            <td width="6%" style="text-align: center;"> <div> <select required id="SPLocation_' + index + '" class="form-control " name="SPLocation"></select> </div></td> \
                            <td width="4%" style="text-align: center;"> <div> <input type="text" disabled id="ItemCode_' + index + '" value="' + data.ItemCode + '" title="' + data.ItemCode + '" class="form-control"> </div></td> \
                            <td width="6%" style="text-align: center;"> <div> <input type="text" disabled id="ItemDescription_' + index + '" value="' + data.ItemDescription + '" title="' + data.ItemDescription + '" class="form-control"> </div></td> \
                            <td width="5%" style="text-align: center;"> <div> <input type="text" disabled id="PartSource_' + index + '" value="' + data.PartSource + '" title="' + data.PartSource + '" class="form-control"> </div></td> \
                            <td width="6%" style="text-align: center;"> <div> <input type="text" disabled id="EstimatedlifespanType_' + index + '" value="' + data.EstimatedLifeSpanType + '" title="' + data.EstimatedLifeSpanType + '" class="form-control"> </div></td> \
                            <td width="6%" style="text-align: center;"> <div> <input type="text" pattern="^[0-9]+(.[0-9]{1,2})?$" id="EstimatedLifeSpan_' + index + '" class="form-control text-right decimalPointonly"> </div></td> \
                            <td width="5%" style="text-align: center;"> <div> <input type="text" id="StockExpiry_' + index + '" value="' + DateFormatter(data.StockExpDate) + '" title="' + DateFormatter(data.StockExpDate) + '" class="form-control datetime"> </div></td> \
                            <td width="6%" style="text-align: center;"> <div> <input type="text" name="Quantity" class="form-control text-right digOnly" required pattern="^((?!(0))[0-9]{1,15})$" maxlength="8" id="Quantity_' + index + '" value="' + data.Quantity + '" title="' + data.Quantity + '"> </div></td> \
                            <td width="8%" class="ApproveAcced" style="text-align: center;"> <div> <input type="text" class="form-control   text-right"  comma required number id="PurchaseCost_' + index + '" value="' + addCommas(data.PurchaseCost) + '" title="' + data.PurchaseCost + '"> </div></td> \
                            <td width="5%" class="ApproveAcced" style="text-align: center;"> <div> <input type="text" class="form-control decimalPointonly commaSeperator text-right" int-length="10" decimal-length="2" comma required number id="Cost_' + index + '" value="' + addCommas(data.Cost) + '" title="' + data.Cost + '"> </div></td> \
                            <td width="5%" style="text-align: center;"> <div> <input type="text" class="form-control" maxlength="25" id="InvoiceNo_' + index + '" value="' + data.InvoiceNo + '" title="' + data.InvoiceNo + '" required> </div></td> \
                            <td width="6%" style="text-align: center;"> <div> <input type="text" class="form-control" maxlength="100" required pattern="^[a-zA-Z0-9\-\(\)\/\\s&.]{3,100}$" id="VendorName_' + index + '" value="' + data.VendorName + '" title="' + data.VendorName + '"> </div></td> \
                            <td width="4%" style="text-align: center;"> <div> <input type="text" id="BinNo_' + index + '" class="form-control documentno" pattern="^[a-zA-Z0-9-//s]{3,}$" maxlength="25" required> </div></td> \
                            <td width="6%" style="text-align: center;"> <div> <input type="text" class="form-control remarks" maxlength="250" id="Remarks_' + index + '" value="' + data.Remarks + '" title="' + data.Remarks + '"> </div></td></tr> ';
            //html = ' <tr> <td width="3%"> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" onchange="IsDeleteCheckAll(myTable,chk_stkUpdateregdet)" id="Isdeleted_' + index + '"> </label> </div></td> \
            //                <td width="6%" style="text-align: center;"> <div> <div> <input type="text" placeholder="Please select" required id="partno_' + index + '" value="' + data.Partno + '" title="' + data.Partno + '" class="form-control" onkeyup="Fetchdata(event,' + index + ')" onpaste="Fetchdata(event,' + index + ')" change="Fetchdata(event,' + index + ')" oninput="Fetchdata(event,' + index + ')"> </div><input type="hidden" id="SparePartsId_' + index + '" value="' + data.SparePartsId + '"/> <input type="hidden" id="IsExpirydate_' + index + '" value="' + data.IsExpirydate + '"/> <input type="hidden" id="hdnEstimatedlifespanId_' + index + '" value="' + data.EstimatedLifeSpanId + '"/> <div class="col-sm-12" id="divFetch_' + index + '"></div><input type="hidden" id="StockUpdateDetId_' + index + '" value="' + data.StockUpdateDetId + '"/> <div class="col-sm-12" id="divFetch_' + index + '"></div></div></td> \
            //                <td width="7%" style="text-align: center;"> <div> <input type="text" disabled id="PartDescription_' + index + '" value="' + data.PartDescription + '" title="' + data.PartDescription + '" class="form-control"> </div></td> \
            //                <td width="6%" style="text-align: center;"> <div> <select required id="SaprePartType_' + index + '" class="form-control " name="typeCodeDetailsMaintenanceFlag"></select> </div></td> \
            //                <td width="6%" style="text-align: center;"> <div> <select required id="SPLocation_' + index + '" class="form-control " name="SPLocation"></select> </div></td> \
            //                <td width="4%" style="text-align: center;"> <div> <input type="text" disabled id="ItemCode_' + index + '" value="' + data.ItemCode + '" title="' + data.ItemCode + '" class="form-control"> </div></td> \
            //                <td width="6%" style="text-align: center;"> <div> <input type="text" disabled id="ItemDescription_' + index + '" value="' + data.ItemDescription + '" title="' + data.ItemDescription + '" class="form-control"> </div></td> \
            //                <td width="5%" style="text-align: center;"> <div> <input type="text" disabled id="PartSource_' + index + '" value="' + data.PartSource + '" title="' + data.PartSource + '" class="form-control"> </div></td> \
            //                <td width="6%" style="text-align: center;"> <div> <input type="text" disabled id="EstimatedlifespanType_' + index + '" value="' + data.EstimatedLifeSpanType + '" title="' + data.EstimatedLifeSpanType + '" class="form-control"> </div></td> \
            //                <td width="6%" style="text-align: center;"> <div> <input type="text" pattern="^[0-9]+(.[0-9]{1,2})?$" id="EstimatedLifeSpan_' + index + '" class="form-control text-right decimalPointonly"> </div></td> \
            //                <td width="5%" style="text-align: center;"> <div> <input type="text" id="StockExpiry_' + index + '" value="' + DateFormatter(data.StockExpDate) + '" title="' + DateFormatter(data.StockExpDate) + '" class="form-control datetime"> </div></td> \
            //                <td width="6%" style="text-align: center;"> <div> <input type="text" name="Quantity" class="form-control text-right digOnly" required pattern="^((?!(0))[0-9]{1,15})$" maxlength="8" id="Quantity_' + index + '" value="' + data.Quantity + '" title="' + data.Quantity + '"> </div></td> \
            //                <td width="8%" class="ApproveAcced" style="text-align: center;"> <div> <input type="text" class="form-control   text-right"  comma required number id="PurchaseCost_' + index + '" value="' + data.PurchaseCost + '" title="' + data.PurchaseCost + '"> </div></td> \
            //                <td width="5%" class="ApproveAcced" style="text-align: center;"> <div> <input type="text" class="form-control decimalPointonly commaSeperator text-right" int-length="10" decimal-length="2" comma required number id="Cost_' + index + '" value="' + data.Cost + '" title="' + data.Cost + '"> </div></td> \
            //                <td width="5%" style="text-align: center;"> <div> <input type="text" class="form-control" maxlength="25" id="InvoiceNo_' + index + '" value="' + data.InvoiceNo + '" title="' + data.InvoiceNo + '" required> </div></td> \
            //                <td width="6%" style="text-align: center;"> <div> <input type="text" class="form-control" maxlength="100" required pattern="^[a-zA-Z0-9\-\(\)\/\\s&.]{3,100}$" id="VendorName_' + index + '" value="' + data.VendorName + '" title="' + data.VendorName + '"> </div></td> \
            //                <td width="4%" style="text-align: center;"> <div> <input type="text" id="BinNo_' + index + '" class="form-control documentno" pattern="^[a-zA-Z0-9-//s]{3,}$" maxlength="25" required> </div></td> \
            //                <td width="6%" style="text-align: center;"> <div> <input type="text" class="form-control remarks" maxlength="250" id="Remarks_' + index + '" value="' + data.Remarks + '" title="' + data.Remarks + '"> </div></td></tr> ';
            $(html);
            $('#myTable').append(html);
            $(LOVlist.SparepartTypeList).each(function (_index, _data) {
                $('#SaprePartType_' + index + '').append('<option value="' + _data.LovId + '">' + _data.FieldValue + '</option>');

            });
            $(LOVlist.SparepartLocationList).each(function (_index, _data) {
                $('#SPLocation_' + index + '').append('<option value="' + _data.LovId + '">' + _data.FieldValue + '</option>');

            });
            $('#SaprePartType_' + index + '').val(data.SparePartType);
            $('#SPLocation_' + index + '').val(data.LocationId);
           

            if (data.IsDeleteReference == true) {
                $("#Isdeleted_" + index).prop("disabled", "disabled");                
            }
            else {
                $("#Isdeleted_" + index).prop("disabled", false);
            }

            $('#EstimatedLifeSpan_' + index + '').val(data.EstimatedLifeSpan).attr('title', data.EstimatedLifeSpan);
            var estimationspan = $('#EstimatedLifeSpan_' + index + '').val();
            if (estimationspan == null) {
                $('#EstimatedLifeSpan_' + index + '').val("");
            }
            $('#BinNo_' + index + '').val(data.BinNo).attr('title', data.BinNo);;
            //$("#BinNo_" + index).prop("disabled", "disabled");

            lifespanVal();

            $("#partno_" + index).prop("disabled", "disabled");
            $("#SaprePartType_" + index).prop("disabled", "disabled");
            $("#SPLocation_" + index).prop("disabled", "disabled");
            $("#EstimatedLifeSpan_" + index).prop("disabled", "disabled");
            $("#StockExpiry_" + index).prop("disabled", "disabled");
            $("#Quantity_" + index).prop("disabled", "disabled");
            $("#Cost_" + index).prop("disabled", "disabled");
            $("#PurchaseCost_" + index).prop("disabled", "disabled");
            $("#InvoiceNo_" + index).prop("disabled", "disabled");
            $("#VendorName_" + index).prop("disabled", "disabled");
            $("#BinNo_" + index).prop("disabled", "disabled");
            $("#Remarks_" + index).prop("disabled", "disabled");

            GridtotalRecords = data.TotalRecords;
            TotalPages = data.TotalPages;
            LastRecord = data.LastRecord;
            FirstRecord = data.FirstRecord;
            pageindex = data.PageIndex;

        });
        ckNewRowPaginationValidation = false;
        $('#paginationfooter').show();
        var mapIdproperty = ["Isdeleted-Isdeleted_", "Partno-partno_", "SparePartsId-SparePartsId_", 'IsExpirydate-IsExpirydate_', "StockUpdateDetId-StockUpdateDetId_", "PartDescription-PartDescription_", "SparePartType-SaprePartType_", "ItemCode-ItemCode_", "ItemDescription-ItemDescription_", "EstimatedLifeSpan-EstimatedLifeSpan_", "PartSource-PartSource_", "StockExpDate-StockExpiry_-date", "Quantity-Quantity_", "Cost-Cost_", "InvoiceNo-InvoiceNo_", "Remarks-Remarks_", "VendorName-VendorName_", "PurchaseCost-PurchaseCost_", "EstimatedLifeSpanType-EstimatedlifespanType_", "LocationId-SPLocation_", "BinNo-BinNo_", ];
        var htmltext = BindNewRowHTML();
        id = $('#primaryID').val();
        var obj = { formId: "#form", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "StockUpdateregBEMS", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "ItemMstFetchEntityList", tableid: '#myTable', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/StockUpdateRegisterApi/get/" + id, pageindex: pageindex, pagesize: pagesize };

        CreateFooterPagination(obj);


        var _index;
        $('#myTable tr').each(function () {
            _index = $(this).index();
        });


    }

    formInputValidation("form");
    //makeExpirydateMand();
    AffectBasedonApproveAccess();

    $('.remarks').keypress(function (e) {
        if ((e.charCode < 97 || e.charCode > 122) && (e.charCode < 48 || e.charCode > 57) && (e.charCode < 65 || e.charCode > 90) && (e.charCode != 32) && (e.charCode < 44 || e.charCode > 46) && (e.charCode < 40 || e.charCode > 41) && (e.charCode != 34) && (e.charCode != 39) && (e.charCode != 58) && (e.charCode != 59) && (e.charCode != 0))
            return false;
    });
    $('.remarks').on('paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^&*_+|\\{}\[\] ?<>\^\"\'\=\/]/g, ''));
        }, 5);
    });
   
    $('.decimalPointonly').each(function (index) {
        //$(this).attr('id', 'ParamMapMin_' + index);
        var vrate = document.getElementById(this.id);
        vrate.addEventListener('input', function (prev) {
            return function (evt) {
                if ((!/^\d{0,8}(?:\.\d{0,2})?$/.test(this.value))) {
                    this.value = prev;
                }
                else {
                    prev = this.value;
                }
            };
        }(vrate.value), false);
    });

    

}


function AddNewRow() {
    var _index;
    $('#myTable tr').each(function () {
        _index = $(this).index();

    });
    var flagAllow = 0;
    for (var i = 0; i <= _index; i++) {
        var partno = $("#partno_" + i).val();
        // var StockExpiry=$("#StockExpiry_" + i).val();
        var Quantity = $("#Quantity_" + i).val();
        var Cost = $("#Cost_" + i).val();
        var PurchaseCost = $("#PurchaseCost_" + i).val();
        var InvoiceNo = $("#InvoiceNo_" + i).val();
        var VendorName = $("#VendorName_" + i).val();
        if (hasApprovePermission) {
            if (VendorName && InvoiceNo && PurchaseCost && Cost && Quantity /*&& StockExpiry*/ && partno)
            { }
            else {
                flagAllow++;
            }
        }
        else {
            if (VendorName && InvoiceNo /*&& PurchaseCost && Cost*/ && Quantity /*&& StockExpiry*/ && partno)
            { }
            else {
                flagAllow++;
            }
        }
    }
    if (flagAllow != 0) {
        bootbox.alert("Please enter data for existing rows");
        return;
    }
    var inputpar = {
        inlineHTML: BindNewRowHTML(),
        //IdPlaceholderused: "maxindexval",
        TargetId: "#myTable",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    ckNewRowPaginationValidation = true;
    $('#chk_stkUpdateregdet').prop("checked", false);
    $('#myTable tr:last td:first input').focus();
    formInputValidation("form");
    //var nexindex = _index != undefined ? (_index + 1) : 0;
    //LoadLoV(LOVlist.SparepartTypeList, 'SaprePartType_' + nexindex, true);

    var rowCount = $('#myTable tr:last').index();
    $.each(LOVlist.SparepartTypeList, function (index, value) {
        $('#SaprePartType_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
    $.each(LOVlist.SparepartLocationList, function (index, value) {
        $('#SPLocation_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
    
    AffectBasedonApproveAccess();
    
    $('.remarks').keypress(function (e) {
        if ((e.charCode < 97 || e.charCode > 122) && (e.charCode < 48 || e.charCode > 57) && (e.charCode < 65 || e.charCode > 90) && (e.charCode != 32) && (e.charCode < 44 || e.charCode > 46) && (e.charCode < 40 || e.charCode > 41) && (e.charCode != 34) && (e.charCode != 39) && (e.charCode != 58) && (e.charCode != 59) && (e.charCode != 0))
            return false;
    });
    $('.remarks').on('paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^&*_+|\\{}\[\] ?<>\^\"\'\=\/]/g, ''));
        }, 5);
    });
    $('.decimalPointonly').each(function (index) {
        //$(this).attr('id', 'ParamMapMin_' + index);
        var vrate = document.getElementById(this.id);
        vrate.addEventListener('input', function (prev) {
            return function (evt) {
                if ((!/^\d{0,8}(?:\.\d{0,2})?$/.test(this.value))) {
                    this.value = prev;
                }
                else {
                    prev = this.value;
                }
            };
        }(vrate.value), false);
    });

   
}

function Fetchdata(event, index) {    
    $('#divFetch_' + index).css({
        'top': $('#partno_' + index).offset().top - $('#StkUpdateRegisterdataTable').offset().top + $('#partno_' + index).innerHeight(),
       // 'width': $('#partno_' + index).outerWidth()
    });

    var ItemMst = {
        SearchColumn: 'partno_' + index + '-Partno',//Id of Fetch field
        ResultColumns: ["SparePartsId" + "-Primary Key", 'Partno' + '-partno_' + index, 'PartDescription' + '-PartDescription_' + index, 'PartSource' + '-PartSource_' + index, 'LifeSpanOptionId' + '-hdnEstimatedlifespanId_' + index, 'EstimatedLifeSpanType' + '-EstimatedlifespanType_' + index],//Columns to be displayed
        FieldsToBeFilled: ["SparePartsId_" + index + "-SparePartsId", 'partno_' + index + '-Partno', 'PartDescription_' + index + '-PartDescription','ItemCode_' + index + '-ItemCode', 'ItemDescription_' + index + '-ItemDescription','PartSource_' + index + '-PartSource', 'hdnEstimatedlifespanId_' + index + '-LifeSpanOptionId', 'EstimatedlifespanType_' + index + '-EstimatedLifeSpanType']//id of element - the model property

    };    
    DisplayFetchResultstkupdate('divFetch_' + index, ItemMst, "/api/Fetch/FetchItemMstdetais", "Ulfetch" + index, event, 1);
    
}

function lifespanVal() {    
    var _index;
    $('#myTable tr').each(function () {
        _index = $(this).index();
    });
    var lifespan = $("#hdnEstimatedlifespanId_" + _index).val();

    if (lifespan == "" || lifespan == null || lifespan == "null" || lifespan == 0 || lifespan == "0") {
        $("#EstimatedLifeSpan_" + _index).prop("disabled", true);
        $("#StockExpiry_" + _index).prop("disabled", true);
        $("#EstimatedLifeSpan_" + _index).prop("required", false).parent().removeClass('has-error');
        $("#StockExpiry_" + _index).prop("required", false).parent().removeClass('has-error');       
    }
    else if (lifespan == "353" || lifespan == "354" || lifespan == "355" || lifespan == "356") {
        $("#EstimatedLifeSpan_" + _index).prop("disabled", false);
        $("#StockExpiry_" + _index).prop("disabled", true);
        $("#StockExpiry_" + _index).prop("required", false);
        $("#EstimatedLifeSpan_" + _index).prop("required", true);       
    }
    else if (lifespan == "357") {
        $("#EstimatedLifeSpan_" + _index).prop("disabled", true);
        $("#StockExpiry_" + _index).prop("disabled", false);
        $("#EstimatedLifeSpan_" + _index).prop("required", false);
        $("#StockExpiry_" + _index).prop("required", true);        
    }
    else if (lifespan == "358") {
        $("#EstimatedLifeSpan_" + _index).prop("disabled", true);
        $("#StockExpiry_" + _index).prop("disabled", true);
        $("#EstimatedLifeSpan_" + _index).prop("required", false).parent().removeClass('has-error');
        $("#StockExpiry_" + _index).prop("required", false).parent().removeClass('has-error');        
    }
}

function lifespanUpload() {
    var _index;
    $('#myTable tr').each(function () {
        _index = $(this).index();
    });
    var lifespan = $("#hdnEstimatedlifespanId_" + _index).val();

    if (lifespan == "" || lifespan == null || lifespan == "null" || lifespan == 0 || lifespan == "0") {
        $("#EstimatedLifeSpan_" + _index).prop("disabled", true);
        $("#StockExpiry_" + _index).prop("disabled", true);
        $("#EstimatedLifeSpan_" + _index).prop("required", false).parent().removeClass('has-error');
        $("#StockExpiry_" + _index).prop("required", false).parent().removeClass('has-error');
    }
    else if (lifespan == "353" || lifespan == "354" || lifespan == "355" || lifespan == "356") {
        $("#EstimatedLifeSpan_" + _index).prop("disabled", true);
        $("#StockExpiry_" + _index).prop("disabled", true);
        $("#StockExpiry_" + _index).prop("required", false);
        $("#EstimatedLifeSpan_" + _index).prop("required", true);
        $("#StockExpiry_" + _index).val("");
    }
    else if (lifespan == "357") {
        $("#EstimatedLifeSpan_" + _index).prop("disabled", true);
        $("#StockExpiry_" + _index).prop("disabled", true);
        $("#EstimatedLifeSpan_" + _index).prop("required", false);
        $("#StockExpiry_" + _index).prop("required", true);
        $("#EstimatedLifeSpan_" + _index).val("");
    }
    else if (lifespan == "358") {
        $("#EstimatedLifeSpan_" + _index).prop("disabled", true);
        $("#StockExpiry_" + _index).prop("disabled", true);
        $("#EstimatedLifeSpan_" + _index).prop("required", false).parent().removeClass('has-error');
        $("#StockExpiry_" + _index).prop("required", false).parent().removeClass('has-error');
        $("#StockExpiry_" + _index).val("");
        $("#EstimatedLifeSpan_" + _index).val("");
    }
}

$("#btnSave, #btnEdit,#btnSaveandAddNew").click(function () {
    $(".errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');    
    
     CurrentbtnID = $(this).attr("Id");
    var _index;
    $('#myTable tr').each(function () {
        _index = $(this).index();
    });

    var resultList = [];
    var _tempObj = [];
    if (hasApprovePermission) {
        for (var i = 0; i <= _index; i++) {
            // alert($('#Isdeleted_' + i).is(":checked"));
            _tempObj = {
                StockUpdateId: $("#primaryID").val(),
                StockUpdateDetId: $('#StockUpdateDetId_' + i).val(),
                EstimatedLifeSpanId: $('#hdnEstimatedlifespanId_' + i).val(),
                partno: $('#partno_' + i).val(),
                PartDescription: $('#PartDescription_' + i).val(),
                LocationId: $('#SPLocation_' + i).val(),
                SparePartType: $('#SaprePartType_' + i).val(),
                ItemCode: $('#ItemCode_' + i).val(),                
                ItemDescription: $('#ItemDescription_' + i).val(),
                EstimatedLifeSpanType: $('#EstimatedlifespanType_' + i).val(),
                EstimatedLifeSpan: $('#EstimatedLifeSpan_' + i).val(),
                StockExpDate: $('#StockExpiry_' + i).val(),//moment($('#StockExpiry_' + i).val()).format("YYYY-MMM-DD"),
                Quantity: $('#Quantity_' + i).val(),
                Cost: $('#Cost_' + i).val(),                
                PurchaseCost: $('#PurchaseCost_' + i).val(),
                InvoiceNo: $('#InvoiceNo_' + i).val(),
                Remarks: $('#Remarks_' + i).val(),
                VendorName: $('#VendorName_' + i).val(),
                BinNo: $('#BinNo_' + i).val(),
                SparePartsId: $('#SparePartsId_' + i).val(),
                IsExpirydate: $('#IsExpirydate_' + i).val(),
                IsDeleted: IsDeleteValidation(i, $('#Isdeleted_' + i).is(":checked")),
                ItemId: 1,
            }

            _tempObj.Cost = _tempObj.Cost.split(',').join('');
            _tempObj.PurchaseCost = _tempObj.PurchaseCost.split(',').join('');
            resultList.push(_tempObj);

        }
    }
    else {
        for (var i = 0; i <= _index; i++) {
            // alert($('#Isdeleted_' + i).is(":checked"));
            _tempObj = {
                StockUpdateId: $("#primaryID").val(),
                StockUpdateDetId: $('#StockUpdateDetId_' + i).val(),
                EstimatedLifeSpanId: $('#hdnEstimatedlifespanId_' + i).val(),
                partno: $('#partno_' + i).val(),
                PartDescription: $('#PartDescription_' + i).val(),
                SparePartType: $('#SaprePartType_' + i).val(),
                LocationId: $('#SPLocation_' + i).val(),
                ItemCode: $('#ItemCode_' + i).val(),                
                ItemDescription: $('#ItemDescription_' + i).val(),
                EstimatedLifeSpanType: $('#EstimatedlifespanType_' + i).val(),
                EstimatedLifeSpan: $('#EstimatedLifeSpan_' + i).val(),
                StockExpDate: $('#StockExpiry_' + i).val(),//moment($('#StockExpiry_' + i).val()).format("YYYY-MMM-DD"),
                Quantity: $('#Quantity_' + i).val(),
                // Cost: $('#Cost_' + i).val(),
                // PurchaseCost: $('#PurchaseCost_' + i).val(),
                InvoiceNo: $('#InvoiceNo_' + i).val(),
                Remarks: $('#Remarks_' + i).val(),
                VendorName: $('#VendorName_' + i).val(),
                BinNo: $('#BinNo_' + i).val(),
                SparePartsId: $('#SparePartsId_' + i).val(),
                IsExpirydate: $('#IsExpirydate_' + i).val(),
                IsDeleted: IsDeleteValidation(i, $('#Isdeleted_' + i).is(":checked")),
                ItemId: 1,
            }
            resultList.push(_tempObj);
        }
    }

   
    var deletedCount = Enumerable.From(resultList).Where(x=>x.IsDeleted).Count();
    var Isdeleteavailable = deletedCount > 0;
    if (deletedCount == resultList.length ) {

        bootbox.alert("Sorry!. You cannot delete all rows");
        $('#btnSave').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }

    var isFormValid = formInputValidation("form", 'save');
    if (!isFormValid) {
        $(".errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');

        $('#btnARSave').attr('disabled', false);
        $('#btnEdit').attr('disabled', false);
        return false;
    }

    else if (Isdeleteavailable) {
        message = "Are you sure that you want to delete the record(s)?";

        bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (result) {
            if (result) {
                submit(resultList);
            }
            else {

            }

        });
    }
    else {
        submit(resultList);
    }
})


function submit(result) {
    var obj1 = {
        StockUpdateId: $('#primaryID').val(),
        StockUpdateNo: $('#StockUpdateNo').val(),
        Date: $("#Date").val(),//moment($("#Date").val()).format("YYYY-MMM-DD"),// $('#Date').val(),
        DateUTC:$("#Date").val(),// moment($("#Date").val()).format("YYYY-MMM-DD"),//$('DateUTC')
        TotalCost: $('#TotalCost').val(),
        ItemMstFetchEntityList: result
    }
    //console.log(obj1);
    var ActionType = $('#ActionType').val();
    id = $('#primaryID').val();
    if ((id == 0 || id == null) && (CurrentbtnID == "btnSave" || CurrentbtnID == "btnSaveandAddNew")) {
        var jqxhr = $.post("/api/StockUpdateRegisterApi/save", obj1, function (response) {
            var result = JSON.parse(response);
           // console.log(result);
            var htmlval = ""; $('#tablebody').empty();
            $('#myTable').empty();
            $('#ActionType').val("EDIT");
             $("#grid").trigger('reloadGrid');
             if (result.StockUpdateId != 0) {
                $('#btnNextScreenSave').show();
                $('#btnEdit').show();
                $('#btnSave').hide();
            }
            BindDatatoHeader(result);
            bindDatatoDatagrid(result.ItemMstFetchEntityList);
            AffectBasedonApproveAccess();
            $('#btnDelete').show();
            $("#Date").prop("disabled", true);
            $("#Date").css("background-color", "");
            $('#errorMsg').css('visibility', 'hidden');
            showMessage('Stock Update Register', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');            
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);
            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        },
         "json")
          .fail(function (response) {
              var errorMessage = "";
              //if (response.status == 400) {
              //    errorMessage = response.responseJSON;
              //}
              //else {
              errorMessage = response.responseJSON;//Messages.COMMON_FAILURE_MESSAGE(response);
              //}
              $("div.errormsgcenter").text(errorMessage);
              $('#errorMsg').css('visibility', 'visible');
              $('#btnSave').attr('disabled', false);
              $('#myPleaseWait').modal('hide');
          });
    }
    else if ((id != 0) && (CurrentbtnID == "btnEdit" || CurrentbtnID == "btnSaveandAddNew")) {
        $('#myPleaseWait').modal('show');

        var jqxhr = $.post("/api/StockUpdateRegisterApi/update", obj1, function (response) {
            var result = JSON.parse(response);
            var htmlval = ""; $('#tablebody').empty();
            $('#myTable').empty();
            $('#ActionType').val("EDIT");

            BindDatatoHeader(result);

            bindDatatoDatagrid(result.ItemMstFetchEntityList);

            AffectBasedonApproveAccess();
            $("#Date").prop("disabled", true);
            $("#Date").css("background-color", "");
            showMessage('Stock Update Register', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            $('#errorMsg').css('visibility', 'hidden');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);
            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            $("#grid").trigger('reloadGrid');
            if (CurrentbtnID == "btnSaveandAddNew") {
                EmptyFields();
            }
        },
        "json")
         .fail(function (response) {
             var errorMessage = "";
             //if (response.status == 400) {
             //    errorMessage = response.responseJSON;
             //}
             //else {
             errorMessage = response.responseJSON;// Messages.COMMON_FAILURE_MESSAGE(response);
             //}
             $("div.errormsgcenter").text(errorMessage);
             $('#errorMsg').css('visibility', 'visible');
             $('#btnSave').attr('disabled', false);
             $('#myPleaseWait').modal('hide');
         });    
    }
}



$('#addnewbtn').on('click', function () {

    window.location.replace("/bems/StockUpdateRegister/add");
});

function IsDeleteValidation(index, delrec) {
    if (delrec == true) {
        $("#partno_" + index + ",#SaprePartType_" + index + ",#SPLocation_" + index + ",#StockExpiry_" + index + ",#EstimatedLifeSpan_" + index + ",#Quantity_" + index + ",#Cost_" + index + ",#PurchaseCost_" + index + ",#InvoiceNo_" + index + ",#VendorName_" + index + ",#BinNo_" + index).prop("required", false).parent().removeClass('has-error');
        //$("#partno_" + index)
        return true;
    }
    else {
        //if ($("#partno_" + index + ",#StockExpiry_" + index + ",#Quantity_" + index + ",#Cost_" + index + ",#PurchaseCost_" + index + ",#InvoiceNo_" + index + ",#VendorName_" + index).parent.hasClass('has-error'))
        //{
        //    $("#partno_" + index + ",#StockExpiry_" + index + ",#Quantity_" + index + ",#Cost_" + index + ",#PurchaseCost_" + index + ",#InvoiceNo_" + index + ",#VendorName_" + index).prop("required", true).parent().addClass('has-error');
        //}



        $("#partno_" + index + ",#SaprePartType_" + index + ",#SPLocation_" + index + ",#Quantity_" + index + ",#Cost_" + index + ",#PurchaseCost_" + index + ",#InvoiceNo_" + index + ",#VendorName_" + index + ",#BinNo_" + index).prop("required", true);//.parent().addClass('has-error');
        return false;


    }

}

function validateDec(index) {
    $(this).attr('id', 'Cost_' + index);
    var vrate = document.getElementById(this.id);
    vrate.addEventListener('input', function (prev) {
        return function (evt) {
            if ((!/^\d{0,3}(?:\.\d{0,2})?$/.test(this.value)) || this.value.length > 11) {
                this.value = prev;
            } else {
                prev = this.value;
            }
        };
    }(vrate.value), false);

}

$("#exportbtn").click(function () {

    //function Export(exportType) {
    var id = 0;
    var grid = $('#grid');
    var filters = JSON.stringify({
        groupop: "and",
        rules: [
            { field: "StockUpdateId", op: "eq", data: $('#primaryID').val() }//, { field: "AccessLevel", op: "eq", data: ScreenValue }
        ]
    });
    var headerColumnNames = ['Part No.', 'Part Description','Spare Part Type', 'Location', 'Item Code', 'Item Description', 'Part Source', 'Lifespan Options', 'Estimated Life Span', 'Expiry Date', 'Quantity',
    'ERP Purchase Cost / Pcs (Currency)', 'Cost / Pcs (Currency)', 'Invoice No.', 'Vendor Name', 'Bin No.', 'Remarks'];
    var mymodel = [
                    //{ key: false, hidden: false, label: 'Stock Update No.', name: 'StockUpdateNo', width: '10%' },
                  //  { key: false, hidden: false, label: 'Date', name: 'Date', width: '10%' },               
                    //{ key: true, label: 'Total Spare Part Cost (Currency)', name: 'TotalSparePartCost', width: '10%' },
                   // { key: true, label: 'Facility Code', name: 'FacilityCode', width: '10%' },
                  //  { key: true, label: 'Facility Name', name: 'FacilityName', width: '10%' },
                    { key: true, label: 'Part No.', name: 'PartNo', width: '10%' },
                    { key: true, label: 'Part Description', name: 'PartDescription', width: '10%' },
                    { key: true, label: 'Spare Part Type', name: 'SparePartType', width: '10%' },
                    { key: true, label: 'Location', name: 'Location', width: '10%' },
                    { key: true, label: 'Item Code', name: 'ItemCode', width: '10%' },
                    { key: true, label: 'Item Description', name: 'ItemDescription', width: '10%' },
                    { key: true, label: 'Part Source', name: 'PartSource', width: '10%' },
                    { key: true, label: 'Lifespan Options', name: 'PartSource', width: '10%' },
                    { key: true, label: 'Estimated Life Span', name: 'EstimatedLifeSpan', width: '10%' },                   
                    { key: true, label: 'Expiry Date', name: 'StockExpiryDate', width: '10%' },
                    { key: true, label: 'Quantity', name: 'Quantity', width: '10%' },                    
                    { key: true, label: 'Purchase Cost (Currency)', name: 'PurchaseCost', width: '10%' },
                    { key: true, label: 'Cost (Currency)', name: 'Cost', width: '10%' },
                    { key: true, label: 'Invoice No.', name: 'InvoiceNo', width: '10%' },
                    { key: true, label: 'Vendor Name', name: 'VendorName', width: '10%' },
                    { key: true, label: 'Bin No.', name: 'BinNo', width: '10%' },
                    { key: true, label: 'Remarks', name: 'Remarks', width: '10%' },
                  ];
    var columnNames = [];
    $.each(mymodel, function (i) {
        if (this.hidden != true) {
            columnNames.push(this.name);
        }
    });
    var sortColumnName = "ModifiedDateUTC";
    var sortOrder = "desc";
    //var mymodel = $("#grid").getGridParam('colModel')

    var screenTitle = $("#menu").find("li.active:last").text();
    var $downloadForm = $("<form method='POST'>")
         .attr("action", "/api/common/Export")
         .append($("<input name='filters' type='text'>").val(filters))
         .append($("<input name='sortOrder' type='text'>").val(sortOrder))
         .append($("<input name='columnNames' type='text'>").val(columnNames))
         .append($("<input name='sortColumnName' type='text'>").val(sortColumnName))
         .append($("<input name='headerColumnNames' type='text'>").val(headerColumnNames))
         .append($("<input name='screenName' type='text'>").val("Stock_Update"))
         .append($("<input name='spName' type='text'>").val("uspFM_EngStockUpdateRegisterTxn_Export_Template"))
         .append($("<input name='exportType' type='text'>").val("CSV"));

    $("body").append($downloadForm);
    var status = $downloadForm.submit();
    $downloadForm.remove();

    //}
});

function AffectBasedonApproveAccess()
{
    var _inde = 0;
    $('#myTable tr').each(function () {
        _inde = $(this).index();
    });
    if(hasApprovePermission)
    {
        for (var i = 0; i <= _inde; i++) {          
            $(".ApproveAcced").show();
            $("#Cost_" + i).show().attr("required",true);
            $("#PurchaseCost_" + i).show().attr("required", true);            
        }    
    }
    else
    {
        for (var i = 0; i <= _inde; i++) {            
            $(".ApproveAcced").hide();         
            $("#Cost_" + i).hide().attr("required", false);
            $("#PurchaseCost_" + i).hide().attr("required", false).parent().remove();                      
        }
    }    
}

function makeExpirydateMand()
{
    var _inde = 0;
    $('#myTable tr').each(function () {
        _inde = $(this).index();
    });
    for (var i = 0; i <= _inde; i++)
    {
        var ismand = $('#IsExpirydate_' + i).val();
        if (ismand == "true") {
            $('#StockExpiry_' + i).attr('required', true);
        }
        else {
            $('#StockExpiry_' + i).attr('required',false).parent().removeClass('has-error');
        }
    }
}

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

function LinkClicked(id) {
    $(".content").scrollTop(1);
    $("#form :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $("#Date").prop("disabled", false);
    var action = "";
    $('#primaryID').val(id);
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
        $("#form :input:not(:button)").prop("disabled", true);
        $("#chk_stkUpdateregdet").prop("disabled", "disabled");
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    if (ActionType !== "ADD") {
        var jqxhr = $.get("/api/StockUpdateRegisterApi/get/" + id + "/" + pagesize + "/" + pageindex, function (response) {
            var result = JSON.parse(response);
            var htmlval = ""; $('#tablebody').empty();
            $('#myTable').empty();
            BindDatatoHeader(result);
            bindDatatoDatagrid(result.ItemMstFetchEntityList);
            AffectBasedonApproveAccess();
            $("#Date").prop("disabled", true);
            $("#Date").css("background-color", "");
            if (ActionType == "VIEW") {
                $("#form :input:not(:button)").prop("disabled", true);
                $("#addnewrowbtn,#savebtn,#uploadbtn,#exportbtn,#addnewbtn").hide();
            }
            $("#uploadbtn").show();
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);
            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        })
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

    }
    else {
        AddNewRow();

    }
    setTimeout(function () {
        $("#top-notifications").modal('hide');
    }, 5000);
    $('#btnSave').attr('disabled', false);
    $('#myPleaseWait').modal('hide');

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
            $.get("/api/StockUpdateRegisterApi/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 showMessage('User Registration', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 $("#grid").trigger('reloadGrid');
                 EmptyFields();
             })
             .fail(function () {
                 showMessage('User Registration', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
        }

    });
}

function EmptyFields() {
    $('input[type="text"], textarea').val('');
    $('#Category').val(144);
    $('#ServiceId').val(2);
    $('#Type').val("null");
    $('#Status').val(1);
    $('#IssuingBody').val("null");
    $('#Date').prop('disabled', false);
    $("#Date").css("background-color", "white");
    $('#LicenseNo').prop('disabled', false);
    $('#Category').prop('disabled', false);
    $('#Type').prop('disabled', false);
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#grid").trigger('reloadGrid');
    $("#txtAssetNo").prop('disabled', false);
    $("#form :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#myTable').empty();
    $('#tablebody').empty();
    $('#paginationfooter').hide();
    AddNewRow();
}

function BindNewRowHTML() {
    return ' <tr> <td width="3%" data-original-title="" title=""> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="hidden" id="hdnIsdeleteReferenceId_maxindexval"/> <input type="checkbox" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(myTable,chk_stkUpdateregdet)" autocomplete="off"> </label> </div></td><td width="6%" style="text-align: center;" data-original-title="" title=""> <div> <div> <input type="text" placeholder="Please select" required id="partno_maxindexval" value="" class="form-control" onkeyup="Fetchdata(event,maxindexval)" onpaste="Fetchdata(event,maxindexval)" change="Fetchdata(event,maxindexval)" oninput="Fetchdata(event,maxindexval)"> </div><input type="hidden" id="SparePartsId_maxindexval"/> <input type="hidden" id="IsExpirydate_maxindexval"/> <div class="col-sm-12" id="divFetch_maxindexval"></div><input type="hidden" id="hdnEstimatedlifespanId_maxindexval"/> <input type="hidden" id="StockUpdateDetId_maxindexval"/> <div class="col-sm-12" id="divFetch_maxindexval"></div></div></td><td width="7%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled id="PartDescription_maxindexval" value="" class="form-control"> </div></td><td width="6%" style="text-align: center;" data-original-title="" title=""> <div> <input type="hidden" id="hdnSPTypeId_maxindexval"/> <select class="form-control" id="SaprePartType_maxindexval" required name="typeCodeDetailsMaintenanceFlag"> <option value="null">Select</option> </select> </div></td><td width="6%" style="text-align: center;" data-original-title="" title=""> <div> <input type="hidden" id="hdnSPLocationId_maxindexval"/> <select class="form-control" id="SPLocation_maxindexval" required name="SPLocation"> <option value="null">Select</option> </select> </div></td><td width="4%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled id="ItemCode_maxindexval" value="" class="form-control"> </div></td><td width="6%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled id="ItemDescription_maxindexval" class="form-control"> </div></td><td width="5%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled id="PartSource_maxindexval" value="" class="form-control"> </div></td><td width="6%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" disabled id="EstimatedlifespanType_maxindexval" value="" class="form-control"> </div></td><td width="6%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" pattern="^[0-9]+(.[0-9]{1,2})?$" id="EstimatedLifeSpan_maxindexval" value="" disabled class="form-control text-right decimalPointonly"> </div></td><td width="5%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" id="StockExpiry_maxindexval" disabled value="" class="form-control datetime"> </div></td><td width="6%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" class="form-control text-right digOnly" required pattern="^((?!(0))[0-9]{1,15})$" name="Quantity" maxlength="8" id="Quantity_maxindexval"> </div></td><td width="8%" class="ApproveAcced" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" class="form-control commaSeperator decimalPointonly text-right" maxlength="11" required pattern="^[0-9]+(\.[0-9]{1,2})?$" id="PurchaseCost_maxindexval"> </div></td><td width="5%" style="text-align: center;" data-original-title="" title="" class="ApproveAcced"> <div> <input type="text" class="form-control decimalPointonly commaSeperator text-right" maxlength="11" required pattern="^[0-9]+(\.[0-9]{1,2})?$" id="Cost_maxindexval"> </div></td><td width="5%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" class="form-control" maxlength="25" id="InvoiceNo_maxindexval" autocomplete="off"> </div></td><td width="6%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" class="form-control" maxlength="100" required pattern="^[a-zA-Z0-9\-\(\)\/\\s&.]{3,100}$" id="VendorName_maxindexval" autocomplete="off"> </div></td><td width="4%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" id="BinNo_maxindexval" value="" pattern="^[a-zA-Z0-9-//s]{3,}$" maxlength="25" class="form-control documentno" required> </div></td><td width="6%" style="text-align: center;" data-original-title="" title=""> <div> <input type="text" class="form-control remarks" maxlength="250" id="Remarks_maxindexval" autocomplete="off"> </div></td></tr> ';
}

$("#Exportbtnsss").click(function () {
    $("#fileUpLoad").val("");
    $("#fileUpLoad").click();
});

function getFileUploadDetails(e, index) {
    var _index;

    for (var i = 0; i < e.files.length; i++) {
        var f = e.files[i];
        var extension = f.name.split(".");
        if (extension.length > 0) {
            if ((extension[1] == 'csv')) {
                var maxSize = 8388608;//7340032 - 7MB 8388608 - 8Mb;
                var fileSize = f.size; // in bytes
                if (fileSize > maxSize) {
                    alert('file size is more then' + maxSize + ' bytes' + fileSize);
                    $("#fileUpLoad").replaceWith($("#fileUpLoad").val('').clone(true));
                    return false;
                }
                else {
                    var blob = e.files[i].slice();
                    filetype = "application/csv"; //f.type
                    filesize = f.size;
                    filename = f.name;
                    var reader = new FileReader();
                    function getB64Str(buffer) {
                        var binary = '';
                        var bytes = new Uint8Array(buffer);
                        var len = bytes.byteLength;
                        for (var i = 0; i < len; i++) {
                            binary += String.fromCharCode(bytes[i]);
                        }
                        return window.btoa(binary);
                    }

                    reader.onload = function (evt) {

                        if (evt.target.readyState == FileReader.DONE) {
                            var cont = evt.target.result;
                            base64String = getB64Str(cont);
                        }
                    };
                    reader.readAsArrayBuffer(blob);
                }
            }
            else {
                bootbox.alert("Please Upload csv File");
                $(e).val('');
            }
        }
    }

    reader.onloadend = function () {
        $("#myPleaseWait").modal("show");
     //   var id = $('#primaryID').val();
       // console.log(base64String);
        var obj1 = {
            contentType: filetype,
            contentAsBase64String: base64String,
            fileResponseName: filename,
         //  StockUpdateId:id
        };
       // console.log(obj1);

        var jqxhr = $.post("/api/StockUpdateRegisterApi/Upload", obj1, function (response) {
            var result = JSON.parse(response);
            var htmlval = "";
            $('#tablebody').empty();
                $('#myTable').empty();
               // BindDatatoHeader(result);
                bindDatatoDatagrid(result.ItemMstFetchEntityList);
               // AffectBasedonApproveAccess();
                $("#uploadbtn").show();
                $('#btnSaveandAddNew').hide();           
                lifespanUpload();
                $("div.errormsgcenter").text("");
                $('#errorMsg').css('visibility', 'hidden');
            showMessage('Stock Update Register', CURD_MESSAGE_STATUS.IM);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);
            $('#myPleaseWait').modal('hide');
        }, "json")
                 .fail(function (response) {
                     var errorMessage = "";
                     if (response.responseJSON == "[object Object]")
                         response.responseJSON = "Please Upload Valid CSV File!";
                     errorMessage = response.responseJSON;//Messages.COMMON_FAILURE_MESSAGE(response);
                     $("div.errormsgcenter").text(errorMessage);
                     $('#errorMsg').css('visibility', 'visible');
                     $('#btnSave').attr('disabled', false);
                     $('#myPleaseWait').modal('hide');
                 });
    };
}


//*************************** fetch

function DisplayFetchResultstkupdate(divFetch, fetchObject, apiUrl, UlFetch, event, pageIndex) {

    var divId = divFetch;
    var keyCode = 0;
    if (event != null) {
        keyCode = event.keyCode;
    }
    var key = $('#' + fetchObject.SearchColumn.split('-')[0]).val();

    var noRecordString = ' <ul class="dropdown-menu pull-right list-group col-sm-12 UlFetch" id="' + UlFetch + '">'
                     + '<li>'
                     + '<center> <b> <span class="records-start not-found">No Match Found</span></b></center>'
                     + '</li>'
                     + '</ul>';

    var conditionOk = false;
    if (keyCode == 40 && (key == null || key == "")) {
        conditionOk = true;
    }
    else {
        if (key.length > 0)
            conditionOk = true;
    }
    if (!conditionOk) {

        //To clear all the fetch values.
        $.each(fetchObject.FieldsToBeFilled, function (index3, value3) {
            var idValue = value3.split('-')[0];
            var resultValue = value3.split('-')[1];
            if (idValue != fetchObject.SearchColumn.split('-')[0]) {
                if (idValue.indexOf('sel') == 0) {
                    $('#' + idValue).val("null");
                }
                else if (idValue.indexOf('hdn') == 0) {
                    $('#' + idValue).val(null).trigger('change');
                }
                else {
                    $('#' + idValue).attr('title', '');
                    $('#' + idValue).val(null);
                }
            }
        });

        $('#' + divFetch).html(null);
        $('#' + divFetch).html(noRecordString);
        $('#' + UlFetch).show();
        lifespanVal();
        return false;
    }
    else {
        $.each(fetchObject.FieldsToBeFilled, function (index3, value3) {
            var idValue = value3.split('-')[0];
            var resultValue = value3.split('-')[1];
            if (idValue != fetchObject.SearchColumn.split('-')[0]) {
                //$('#' + idValue).val(null);
                if (idValue.indexOf('sel') == 0) {
                    $('#' + idValue).val("null");
                }
                else if (idValue.indexOf('hdn') == 0) {
                    $('#' + idValue).val(null).trigger('change');
                }
                else {
                    $('#' + idValue).attr('title', '');
                    $('#' + idValue).val(null);
                }
            }
        });
        lifespanVal();
    }
    var fetchObj = {};

    fetchObj[fetchObject.SearchColumn.split('-')[1]] = $('#' + fetchObject.SearchColumn.split('-')[0]).val(),
    fetchObj['PageIndex'] = pageIndex;

    if (fetchObject.AdditionalConditions != undefined && fetchObject.AdditionalConditions != null) {
        $.each(fetchObject.AdditionalConditions, function (index4, value4) {
            fetchObj[value4.split('-')[0]] = $('#' + value4.split('-')[1]).val();
        });
    }

    if (fetchObject.ScreenName != undefined && fetchObject.ScreenName != null) {
        fetchObj['ScreenName'] = fetchObject.ScreenName;
    }
    if (fetchObject.TypeCode != undefined) {
        fetchObj['TypeCode'] = fetchObject.TypeCode;
    }
    var jqxhr = $.post(apiUrl, fetchObj, function (response) {
        var result = JSON.parse(response);
        var primaryKey = "";
        var TotalRecords = 0;
        var FirstRecord = 0;
        var LastRecord = 0;
        var LastPageIndex = 0;

        var firstObject = $.grep(result, function (value0, index0) {
            return index0 == 0;
        });
        TotalRecords = firstObject[0].TotalRecords;
        FirstRecord = firstObject[0].FirstRecord;
        LastRecord = firstObject[0].LastRecord;
        LastPageIndex = firstObject[0].LastPageIndex;

        var prevButtonDisable = "";
        var nextButtonDisable = "";

        if (pageIndex == 1) {
            prevButtonDisable = "disabled";
        }
        if (pageIndex == LastPageIndex) {
            nextButtonDisable = "disabled";
        }

        var fetchResultString = '<ul class="dropdown-menu pull-right list-group col-sm-12 UlFetch" id="' + UlFetch + '">'
                                 + '<li class="table-responsive">';
        $.each(result, function (index, value) {
            fetchResultString += '<div>';
            var displayString = "";
            var len = fetchObject.ResultColumns.length;

            var numberOfColumns = 0;
            $.each(fetchObject.ResultColumns, function (index1, value1) {
                if (value1.split('-')[1] != "Primary Key") {
                    numberOfColumns++;
                    if (numberOfColumns <= 2) {
                        displayString += value[value1.split('-')[0]];
                        if (numberOfColumns != 2 && index1 != len - 1) displayString += " - ";
                    }
                }
                else {
                    primaryKey = value1.split('-')[0];
                }
            });
            fetchResultString += '<a class="list-group-item btn-default" id="aFetchResultItem-' + value[primaryKey] + '">' + displayString + '</a>';
            fetchResultString += '</div>';
        });

        fetchResultString += '</li>'
                                + '<li class="table-responsive fetchpagination">'
                                + 'Showing <span class="records-start">' + FirstRecord + '</span> to <span class="records-end">'
                                + '' + LastRecord + '&nbsp;'
                                + '</span> records of <span class="total-records">' + TotalRecords + '</span>&nbsp;&nbsp;'
                                + '<input type="hidden" id="hdnFetchPageIndex_' + UlFetch + '" value="' + pageIndex + '">'
                                + '<input type="button" class="prev-Page" value="<" id="btnFetchPrevPage" ' + prevButtonDisable + '/>&nbsp;'
                                + '<input type="button" class="next-Page" value=">" id="btnFetchNextPage" ' + nextButtonDisable + '/>'
                                + '</li>'
                                + '</ul>';
        $('#' + divFetch).html(null);
        $('#' + divFetch).html(fetchResultString);
        $('#' + divFetch).addClass("divfetch_dropdown_menu");
        $('#' + UlFetch).show();

        $("a[id^='aFetchResultItem']").click(function () {
            var primaryId1 = $(this).attr('id').split('-')[1];
            var obj = $.grep(result, function (value2, index2) {
                return value2[primaryKey] == primaryId1;
            });
            
            var returnObject = obj[0];
            $.each(fetchObject.FieldsToBeFilled, function (index3, value3) {
                var idValue = value3.split('-')[0];
                var resultValue = value3.split('-')[1];
                
                if (idValue.indexOf("hdn") == 0) {
                    $('#' + idValue).val(returnObject[resultValue]).trigger('change');
                }
                else if (idValue.indexOf("Date") != -1) {
                    $('#' + idValue).val(DateFormatter(returnObject[resultValue]));
                }
                else {
                    $('#' + idValue).val(returnObject[resultValue]);
                    $('#' + idValue).attr('title', returnObject[resultValue]);
                    $('#' + idValue).parent().removeClass('has-error');
                }
               
            });
            lifespanVal();
        });

        $('#btnFetchPrevPage, #btnFetchNextPage').click(function () {
            var id = $(this).attr('id');
            var currentPageIndex = parseInt($('#hdnFetchPageIndex_' + UlFetch).val());
            if (id == "btnFetchPrevPage") {
                if (currentPageIndex != 1) {
                    currentPageIndex -= 1;
                }
                else {
                    return false;
                }
            }
            else if (id == "btnFetchNextPage") {
                if (currentPageIndex != LastPageIndex) {
                    currentPageIndex += 1;
                }
                else {
                    return false;
                }
            }
            DisplayFetchResultstkupdate(divFetch, fetchObject, apiUrl, UlFetch, event, currentPageIndex)
        });
    },
   "json")
    .fail(function (response) {
        $('#' + divFetch).html(null);
        $('#' + divFetch).html(noRecordString);
        $('#' + UlFetch).show();
    });
}