//********************************************* Pagination Grid ********************************************
var ckNewRowPaginationValidation = false;
var pageindex = 1, pagesize = 5;
var GridtotalRecords;
var TotalPages = 1, FirstRecord = 0, LastRecord = 0;
FromNotification = false;
//********************************************************************************

$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    //$("#jQGridCollapse1").click();
    var ActionType = $('#ActionType').val();
    var primaryId = $('#primaryID').val();
    formInputValidation("StockAdjustmentFrom");
    $('#btnDelete').hide();
    $('#btnAdjustmentEdit').hide();
    $('#btnAdjustmentVerify').hide();
    $('#btnAdjustmentApprove').hide();
    $('#btnAdjustmentReject').hide();
    var CurDate = GetCurrentDate();
    $('#Adjustdate').val(CurDate);    
    AddNewRowStkAdjustment();    
    //if (primaryId != null && primaryId != "0") {
    //    getById(primaryId, pagesize, pageindex)
    //}    
    
    ////******************************************** Getby ID ****************************************************

    //function getById(primaryId, pagesize, pageindex) {
    //    $.get("/api/StockAdjustment/get/" + primaryId + "/" + pagesize + "/" + pageindex)
    //            .done(function (result) {
    //                var result = JSON.parse(result);
    //                var primaryId = $('#primaryID').val();

    //                if (result.StockAdjustmentGridList[0].ApprovalStatus == 74) {       // status Open
    //                    $('#btnAdjustmentReject').hide(); 
    //                    $('#btnAdjustmentApprove').hide();
    //                    $('#btnAdjustmentEdit').show();
    //                    $('#btnAdjustmentVerify').show();
    //                }                    
    //                if (result.StockAdjustmentGridList[0].ApprovalStatus == 75) {       // status Submit
    //                    $('#addrowplus').hide();
    //                    $('#divStatus').show();
    //                    $('#btnStatusVal').prop('value', "Submitted");
    //                    $('#btnStatusVal').addClass("important btn btn-info");

    //                    //$('#btnAdjustmentReject').attr('disabled', false);
    //                    //$('#btnAdjustmentApprove').attr('disabled', false);
    //                    //$('#btnAdjustmentVerify').attr('disabled', true);
    //                    //$('#btnAdjustmentEdit').attr('disabled', true);

    //                    $('#btnAdjustmentReject').show(); 
    //                    $('#btnAdjustmentApprove').show();
    //                    $('#btnAdjustmentEdit').hide();
    //                    $('#btnAdjustmentVerify').hide();
    //                }
    //                if (result.StockAdjustmentGridList[0].ApprovalStatus == 76) {       // status Approve
    //                    $('#addrowplus').hide();
    //                    $('#divStatus').show();                        
    //                    $('#btnStatusVal').prop('value', "Approved");
    //                    $('#btnStatusVal').addClass("important btn btn-success");

    //                    $('#Approveby').val(result.StockAdjustmentGridList[0].ApprovedBy);
    //                    var approveDate = result.StockAdjustmentGridList[0].isApprovedDateNull ? "" : DateFormatter(result.StockAdjustmentGridList[0].ApprovedDate);
    //                    $('#Approvedate').val(approveDate).prop("disabled", "disabled");                        
    //                    $('#btnAdjustmentReject').hide(); 
    //                    $('#btnAdjustmentApprove').hide();
    //                    $('#btnAdjustmentEdit').hide();
    //                    $('#btnAdjustmentVerify').hide();
    //                }
    //                if (result.StockAdjustmentGridList[0].ApprovalStatus == 77) {       // status Reject
    //                    $('#addrowplus').hide();
    //                    $('#divStatus').show();
    //                    $('#btnStatusVal').prop('value', "Rejected");
    //                    $('#btnStatusVal').addClass("important btn btn-danger");                    
    //                    $('#btnAdjustmentReject').show(); 
    //                    $('#btnAdjustmentApprove').show();
    //                    $('#btnAdjustmentEdit').hide();
    //                    $('#btnAdjustmentVerify').hide();
    //                }

    //                $("#StkAdjustmentTbl").empty();

    //                if (result != null && result.StockAdjustmentGridList != null && result.StockAdjustmentGridList.length > 0) {
    //                    BindGridData(result);
    //                }
                    

    //                $('#myPleaseWait').modal('hide');
    //            })
    //            .fail(function () {
    //                $('#myPleaseWait').modal('hide');
    //                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
    //                $('#errorMsg').css('visibility', 'visible');
    //            });
    //}

    // **** Query String to get ID Begin****\\\

    var getUrlParameter = function getUrlParameter(sParam) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');

            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : sParameterName[1];
            }
        }
    };

    var ID = getUrlParameter('id');
    if (ID == null || ID == 0 || ID == '') {
            $("#jQGridCollapse1").click();
    }
    else {
        LinkClicked(ID, {});
        FromNotification = true;
    }
    // **** Query String to get ID  End****\\\




    //******************************************** Save *********************************************
  
    $("#btnAdjustmentSave, #btnAdjustmentEdit,#btnSaveandAddNew").click(function () {
        $('#btnAdjustmentSave').attr('disabled', true);
        $('#btnAdjustmentEdit').attr('disabled', true);
        $('#myPleaseWait').modal('show');
        var CurrentbtnID = $(this).attr("Id");
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var _index;
        $('#StkAdjustmentTbl tr').each(function () {
            _index = $(this).index();
        });
      
        var result = [];
        var primaryId = $('#primaryID').val();
        for (var i = 0; i <= _index; i++) {           

            var _StkAdjustmentWO = {
                StockAdjustmentId: primaryId,
                StockAdjustmentDetId: $('#hdnStkAdjustmentId_' + i).val(),
                PartNo: $('#partno_' + i).val(),
                PartDescription: $('#partdesc_' + i).val(),
                ItemCode: $('#itemcode_' + i).val(),
                ItemDescription: $('#itemdesc_' + i).val(),
                BinNo: $('#BinNo_' + i).val(),
                QuantityFacility: $('#qtyfacility_' + i).val(),
                PhysicalQuantity: $("#physicalqty_" + i).val(),
                Variance: $("#variance_" + i).val(),                
                AdjustedQuantity: $("#adjustqty_" + i).val(),
                Cost: $("#cstcurrency_" + i).val(),
                PurchaseCost: $("#purchasecst_" + i).val(),
                InvoiceNo: $("#invoiceno_" + i).val(),
                VendorName: $("#vendorname_" + i).val(),
                Remarks: $("#remarks_" + i).val(),
                SparePartsId: $("#SparePartsId_" + i).val(),
                StockUpdateDetId: $("#StockUpdateDetId_" + i).val(),
                IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
                ItemId: 1,
            }
            _StkAdjustmentWO.PurchaseCost = _StkAdjustmentWO.PurchaseCost.split(',').join('');
            _StkAdjustmentWO.Cost = _StkAdjustmentWO.Cost.split(',').join('');
            result.push(_StkAdjustmentWO);            
        }
        
        var deletedCount = Enumerable.From(result).Where(x=>x.IsDeleted).Count();
        var Isdeleteavailable = deletedCount > 0;
      //  if (deletedCount == result.length && TotalPages == 1) {
        if (deletedCount == result.length) {
            bootbox.alert("Sorry!. You cannot delete all rows");
            $('#btnAdjustmentSave').attr('disabled', false);
            $('#btnAdjustmentEdit').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var obj = {
            StockAdjustmentId: primaryId,
            StockAdjustmentNo: $('#StkadjustNo').val(),
            //ApprovedBy: $('#Approveby').val(),
            AdjustmentDate: $("#Adjustdate").val(),
            //ApprovedDate: $("#Approvedate").val(),            
            StockAdjustmentGridList: result
        }

        if (primaryId != null) {
            obj.StockAdjustmentId = primaryId;
            switch (ActionType) {
                case 'Add': obj.ApprovalStatus = 74; break;
                case 'Edit': obj.ApprovalStatus = 74; break;                    
                //case 'Verify': obj.Submitted = true; break;
                //case 'Approve': obj.Approved = true; break;
                //case 'Reject': obj.Rejected = true; break;
            }
        }
        else {
            obj.StockAdjustmentId = 0;            
        }
        
        var isFormValid = true;        
        isFormValid = formInputValidation("StockAdjustmentFrom", 'save');       
        if (!isFormValid) {            
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnAdjustmentSave').attr('disabled', false);
            $('#btnAdjustmentEdit').attr('disabled', false);            
            return false;
        }

        var ckfalse = 0;
        for (var j = 0; j <= _index; j++) {
            var SparePartsId = $("#SparePartsId_" + j).val();
            var IsDeleted = $('#Isdeleted_' + j).is(":checked");

            if (!IsDeleted) {
                if (SparePartsId == null || SparePartsId == 0 || SparePartsId == "") {
                    $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
                    $('#partno_' + j).parent().addClass('has-error');
                    $('#errorMsg').css('visibility', 'visible');
                    $('#myPleaseWait').modal('hide');
                    $('#btnAdjustmentSave').attr('disabled', false);
                    $('#btnAdjustmentEdit').attr('disabled', false);
                    ckfalse += 1;
                }
            }
            else {
                $('#partno_' + j).parent().removeClass('has-error');               
            }
        }
        if (ckfalse > 0) {
            return false;
        }
            
        if (Isdeleteavailable == true) {
            $('#myPleaseWait').modal('hide');
            bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (result) {
                if (result) {
                    SaveStkAdjustment(obj);
                }
                else {
                    $('#myPleaseWait').modal('hide');
                    $('#btnAdjustmentSave').attr('disabled', false);
                    $('#btnAdjustmentEdit').attr('disabled', false);
                }
            });
        }
        else {
            SaveStkAdjustment(obj);
        }

        function SaveStkAdjustment(obj) {
            var jqxhr = $.post("/api/StockAdjustment/Save", obj, function (response) {
                var result = JSON.parse(response);
                $("#primaryID").val(result.StockAdjustmentId);
                //$("#Timestamp").val(result.Timestamp);
              
                if (result != null && result.StockAdjustmentGridList != null && result.StockAdjustmentGridList.length > 0) {
                    BindGridData(result);
                   // $('#btnAdjustmentSubmit').show();
                }
                if (result.StockAdjustmentId != null)
                {
                    $('#btnAdjustmentEdit').show();
                    $('#btnAdjustmentSave').hide();                   
                    $('#btnAdjustmentVerify').show();
                    $('#btnDelete').show();
                }
                $(".content").scrollTop(0);
                showMessage('Stock Adjustment', CURD_MESSAGE_STATUS.SS);

                $('#btnAdjustmentSave').attr('disabled', false);
                $('#btnAdjustmentEdit').attr('disabled', false);                
                $('#btnAdjustmentVerify').show();
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
                $("div.errormsgcenter").text(errorMessage).css('visibility', 'visible');
                $('#errorMsg').css('visibility', 'visible');
                $('#btnAdjustmentSave').attr('disabled', false);
                $('#btnAdjustmentEdit').attr('disabled', false);                

                $('#myPleaseWait').modal('hide');
                $("#grid").trigger('reloadGrid');
            });
        }
    });

   
    //************************************ Grid Delete 

    $("#chk_stkadjustmentdet").change(function () {
        var Isdeletebool = this.checked;

        if (this.checked) {
            $('#StkAdjustmentTbl tr').map(function (i) {
                if ($("#Isdeleted_" + i).prop("disabled")) {
                    $("#Isdeleted_" + i).prop("checked", false);
                }
                else {
                    $("#Isdeleted_" + i).prop("checked", true);
                }
            });
        } else {
            $('#StkAdjustmentTbl tr').map(function (i) {
                $("#Isdeleted_" + i).prop("checked", false);
            });
        }
    });


    //********************************************** Submit btn

    $("#btnAdjustmentVerify").click(function () {        
        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');       

        var _index;
        $('#StkAdjustmentTbl tr').each(function () {
            _index = $(this).index();
        });

        var result = [];
        var primaryId = $('#primaryID').val();
        for (var i = 0; i <= _index; i++) {

            var _StkAdjustmentWO = {
                StockAdjustmentId: primaryId,
                StockAdjustmentDetId: $('#hdnStkAdjustmentId_' + i).val(),
                PartNo: $('#partno_' + i).val(),
                PartDescription: $('#partdesc_' + i).val(),
                ItemCode: $('#itemcode_' + i).val(),
                ItemDescription: $('#itemdesc_' + i).val(),
                BinNo: $('#BinNo_' + i).val(),
                QuantityFacility: $('#qtyfacility_' + i).val(),
                PhysicalQuantity: $("#physicalqty_" + i).val(),
                Variance: $("#variance_" + i).val(),                
                AdjustedQuantity: $("#adjustqty_" + i).val(),
                Cost: $("#cstcurrency_" + i).val(),
                PurchaseCost: $("#purchasecst_" + i).val(),
                InvoiceNo: $("#invoiceno_" + i).val(),
                VendorName: $("#vendorname_" + i).val(),
                Remarks: $("#remarks_" + i).val(),
                SparePartsId: $("#SparePartsId_" + i).val(),
                StockUpdateDetId: $("#StockUpdateDetId_" + i).val(),
                IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
                ItemId: 1,
            }
            _StkAdjustmentWO.PurchaseCost = _StkAdjustmentWO.PurchaseCost.split(',').join('');
            _StkAdjustmentWO.Cost = _StkAdjustmentWO.Cost.split(',').join('');
            result.push(_StkAdjustmentWO);
        }

        var deletedCount = Enumerable.From(result).Where(x=>x.IsDeleted).Count();
        var Isdeleteavailable = deletedCount > 0;
        if (deletedCount == result.length) {
            bootbox.alert("Sorry!. You cannot delete all rows");
            $('#btnAdjustmentVerify').attr('disabled', false);
            $('#btnQualityCauseSave').attr('disabled', false);
            $('#btnQualityCauseEdit').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }       

        var obj = {
            StockAdjustmentId: primaryId,
            StockAdjustmentNo: $('#StkadjustNo').val(),
            //ApprovedBy: $('#Approveby').val(),
            AdjustmentDate: $("#Adjustdate").val(),
           // ApprovedDate: $("#Approvedate").val(),            
            StockAdjustmentGridList: result
        }

        if (primaryId != null) {
            obj.StockAdjustmentId = primaryId;
            switch (ActionType) {
                case 'Add': obj.Submitted = true; break;
                //case 'EDIT': obj.ApprovalStatus = 74; break;
                case 'Edit': obj.Submitted = true; break;
                //case 'Approve': obj.Approved = true; break;
                //case 'Reject': obj.Rejected = true; break;
            }
        }
        else {
            obj.StockAdjustmentId = 0;
        }
        
        var isFormValid = true;
        isFormValid = formInputValidation("StockAdjustmentFrom", 'save');
        if (!isFormValid) {           
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnAdjustmentSave').attr('disabled', false);
            $('#btnAdjustmentEdit').attr('disabled', false);            
            $('#btnAdjustmentVerify').attr('disabled', false);
            return false;
        }

        var ckfalse = 0;
        for (var j = 0; j <= _index; j++) {
            var SparePartsId = $("#SparePartsId_" + j).val();
            var IsDeleted = $('#Isdeleted_' + j).is(":checked");

            if (!IsDeleted) {
                if (SparePartsId == null || SparePartsId == 0 || SparePartsId == "") {
                    $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
                    $('#partno_' + j).parent().addClass('has-error');
                    $('#errorMsg').css('visibility', 'visible');
                    $('#myPleaseWait').modal('hide');
                    $('#btnAdjustmentSave').attr('disabled', false);
                    $('#btnAdjustmentEdit').attr('disabled', false);
                    ckfalse += 1;
                }
            }
            else {
                $('#partno_' + j).parent().removeClass('has-error');
            }
        }
        if (ckfalse > 0) {
            return false;
        }
        
        if (Isdeleteavailable == true) {
            $('#myPleaseWait').modal('hide');
            bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (result) {
                if (result) {
                    $('#btnAdjustmentSave').attr('disabled', true);
                    $('#btnAdjustmentEdit').attr('disabled', true);
                    $('#btnAdjustmentVerify').hide();
                    $('#myPleaseWait').modal('show');
                    SaveStkAdjustmentSubmit(obj);
                }
                else {
                    $('#btnAdjustmentVerify').show();
                    $('#btnAdjustmentVerify').attr('disabled', false);
                    $('#btnAdjustmentSave').attr('disabled', false);
                    $('#btnAdjustmentEdit').attr('disabled', false);
                    $('#btnAddNew').attr('disabled', false);
                    $('#myPleaseWait').modal('hide');
                }
            });
        }
        else {
            $('#btnAdjustmentSave').attr('disabled', true);
            $('#btnAdjustmentEdit').attr('disabled', true);            
            $('#btnAdjustmentVerify').hide();
            $('#myPleaseWait').modal('show');
            SaveStkAdjustmentSubmit(obj);
        }

        function SaveStkAdjustmentSubmit(obj) {
            var jqxhr = $.post("/api/StockAdjustment/Save", obj, function (response) {
                var result = JSON.parse(response);
                $("#primaryID").val(result.StockAdjustmentId);
                //$("#Timestamp").val(result.Timestamp);
               
                if (result != null && result.StockAdjustmentGridList != null && result.StockAdjustmentGridList.length > 0) {
                    BindGridData(result);
                    //HideRemarks(result);
                }
                $(".content").scrollTop(0);
                showMessage('Stock Adjustment', CURD_MESSAGE_STATUS.SS);

                $('#btnDelete').hide(); 
                $('#btnSaveandAddNew').hide();
                $('#addrowplus').hide();
                $('#divStatus').show();
                $('#btnStatusVal').text("Submitted");
              //  $('#btnStatusVal').prop('value', "Submitted");
               // $('#btnStatusVal').addClass("important btn hover_effect btn-info");

                $('#btnAdjustmentSave').hide();
                $('#btnAdjustmentEdit').hide();
                $('#btnAdjustmentApprove').show();
                $('#btnAdjustmentReject').show();
                $('#btnAdjustmentApprove').attr('disabled', false);
                $('#btnAdjustmentReject').attr('disabled', false);
                $('#btnAdjustmentVerify').hide();
                $('#btnAddNew').attr('disabled', true);

                $('#myPleaseWait').modal('hide');
                $("#grid").trigger('reloadGrid');
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
                $("div.errormsgcenter").text(errorMessage).css('visibility', 'visible');
                $('#errorMsg').css('visibility', 'visible');
                $('#btnAdjustmentSave').attr('disabled', false);
                $('#btnAdjustmentEdit').attr('disabled', false);                
                $('#btnAdjustmentVerify').attr('disabled', false);

                $('#myPleaseWait').modal('hide');
            });
        }

    });


    //********************************************** Approved btn

    $("#btnAdjustmentApprove").click(function () {        
        $('#btnAdjustmentApprove').attr('disabled', true);
        $('#btnAdjustmentReject').attr('disabled', true);

        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var isFormValid = true;        
        isFormValid = formInputValidation("StockAdjustmentFrom", 'save');
        if (!isFormValid) {
            fetchValidation();
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');            
            $('#btnAdjustmentApprove').attr('disabled', false);
            $('#btnAdjustmentReject').attr('disabled', false);            
            return false;
        }

        var _index;
        $('#StkAdjustmentTbl tr').each(function () {
            _index = $(this).index();
        });

        var result = [];
        var primaryId = $('#primaryID').val();
        for (var i = 0; i <= _index; i++) {

            var _StkAdjustmentWO = {
                StockAdjustmentId: primaryId,
                StockAdjustmentDetId: $('#hdnStkAdjustmentId_' + i).val(),
                PartNo: $('#partno_' + i).val(),
                PartDescription: $('#partdesc_' + i).val(),
                ItemCode: $('#itemcode_' + i).val(),
                ItemDescription: $('#itemdesc_' + i).val(),
                BinNo: $('#BinNo_' + i).val(),
                QuantityFacility: $('#qtyfacility_' + i).val(),
                PhysicalQuantity: $("#physicalqty_" + i).val(),
                Variance: $("#variance_" + i).val(),                
                AdjustedQuantity: $("#adjustqty_" + i).val(),
                Cost: $("#cstcurrency_" + i).val(),
                PurchaseCost: $("#purchasecst_" + i).val(),
                InvoiceNo: $("#invoiceno_" + i).val(),
                VendorName: $("#vendorname_" + i).val(),
                Remarks: $("#remarks_" + i).val(),
                SparePartsId: $("#SparePartsId_" + i).val(),
                StockUpdateDetId: $("#StockUpdateDetId_" + i).val(),
                ItemId: 1,
            }
            _StkAdjustmentWO.PurchaseCost = _StkAdjustmentWO.PurchaseCost.split(',').join('');
            _StkAdjustmentWO.Cost = _StkAdjustmentWO.Cost.split(',').join('');
            result.push(_StkAdjustmentWO);
        }
        //var timeStamp = $("#Timestamp").val();        
        var CurDate = GetCurrentDate();
        var ApproveDate=$("#Approvedate").val(CurDate);
        var obj = {
            StockAdjustmentId: primaryId,
            StockAdjustmentNo: $('#StkadjustNo').val(),
            ApprovedBy: $('#Approveby').val(),
            AdjustmentDate: $("#Adjustdate").val(),
            ApprovedDate: $("#Approvedate").val(),
            StockAdjustmentGridList: result
        }

        if (primaryId != null) {
            obj.StockAdjustmentId = primaryId;
            switch (ActionType) {
                case 'Add': obj.Approved = true; break;
                //case 'EDIT': obj.ApprovalStatus = 74; break;
                //case 'Verify': obj.Submitted = true; break;
                case 'Edit': obj.Approved = true; break;
                //case 'Reject': obj.Rejected = true; break;
            }
        }
        else {
            obj.StockAdjustmentId = 0;
        }

        var jqxhr = $.post("/api/StockAdjustment/Save", obj, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.StockAdjustmentId);
         
            //$("#Timestamp").val(result.Timestamp);
            if (result != null && result.StockAdjustmentGridList != null && result.StockAdjustmentGridList.length > 0) {
                BindGridData(result);
            }
            $(".content").scrollTop(0);
            showMessage('Stock Adjustment', CURD_MESSAGE_STATUS.SS);
            $('#btnDelete').hide();
            $('#divStatus').show();
            $('#btnStatusVal').text('');
          //  $('#btnStatusVal').prop('value','');
            // $('#btnStatusVal').removeClass("important btn hover_effect btn-info");
            $('#btnStatusVal').text("Approved");
           // $('#btnStatusVal').prop('value', "Approved");
          //  $('#btnStatusVal').addClass("important btn hover_effect btn-success");
            
            $('#Approveby').val(result.StockAdjustmentGridList[0].ApprovedBy);
            var approveDate = result.StockAdjustmentGridList[0].isApprovedDateNull ? "" : DateFormatter(result.StockAdjustmentGridList[0].ApprovedDate);
            $('#Approvedate').val(approveDate).prop("disabled", "disabled");
            $('#btnAdjustmentApprove').hide();
            $('#btnAdjustmentReject').hide();

            $('#myPleaseWait').modal('hide');
            $("#grid").trigger('reloadGrid');
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
            $("div.errormsgcenter").text(errorMessage).css('visibility', 'visible');
            $('#errorMsg').css('visibility', 'visible');
            $('#btnAdjustmentApprove').attr('disabled', false);
            $('#btnAdjustmentReject').attr('disabled', false);            

            $('#myPleaseWait').modal('hide');
        });

    });


    //********************************************** Reject btn

    $("#btnAdjustmentReject").click(function () {       
        $('#btnAdjustmentApprove').attr('disabled', true);
        $('#btnAdjustmentReject').attr('disabled', true);

        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var isFormValid = true;        
        isFormValid = formInputValidation("StockAdjustmentFrom", 'save');
        if (!isFormValid) {
            fetchValidation();
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnAdjustmentApprove').attr('disabled', false);
            $('#btnAdjustmentReject').attr('disabled', false);
            return false;
        }

        var _index;
        $('#StkAdjustmentTbl tr').each(function () {
            _index = $(this).index();
        });

        var result = [];
        var primaryId = $('#primaryID').val();
        for (var i = 0; i <= _index; i++) {

            var _StkAdjustmentWO = {
                StockAdjustmentId: primaryId,
                StockAdjustmentDetId: $('#hdnStkAdjustmentId_' + i).val(),
                PartNo: $('#partno_' + i).val(),
                PartDescription: $('#partdesc_' + i).val(),
                ItemCode: $('#itemcode_' + i).val(),
                ItemDescription: $('#itemdesc_' + i).val(),
                BinNo: $('#BinNo_' + i).val(),
                QuantityFacility: $('#qtyfacility_' + i).val(),
                PhysicalQuantity: $("#physicalqty_" + i).val(),
                Variance: $("#variance_" + i).val(),
                AdjustedQuantity: $("#adjustqty_" + i).val(),
                Cost: $("#cstcurrency_" + i).val(),
                PurchaseCost: $("#purchasecst_" + i).val(),
                InvoiceNo: $("#invoiceno_" + i).val(),
                VendorName: $("#vendorname_" + i).val(),
                Remarks: $("#remarks_" + i).val(),
                SparePartsId: $("#SparePartsId_" + i).val(),
                StockUpdateDetId: $("#StockUpdateDetId_" + i).val(),
                ItemId: 1,
            }
            _StkAdjustmentWO.PurchaseCost = _StkAdjustmentWO.PurchaseCost.split(',').join('');
            _StkAdjustmentWO.Cost = _StkAdjustmentWO.Cost.split(',').join('');
            result.push(_StkAdjustmentWO);
        }
        //var timeStamp = $("#Timestamp").val();        

        var obj = {
            StockAdjustmentId: primaryId,
            StockAdjustmentNo: $('#StkadjustNo').val(),
            //ApprovedBy: $('#Approveby').val(),
            AdjustmentDate: $("#Adjustdate").val(),
            //ApprovedDate: $("#Approvedate").val(),
            StockAdjustmentGridList: result
        }
        if (primaryId != null) {
            obj.StockAdjustmentId = primaryId;
            switch (ActionType) {
                case 'Add': obj.Rejected = true; break;
                //case 'EDIT': obj.ApprovalStatus = 74; break;
                //case 'Verify': obj.Submitted = true; break;
                //case 'EDIT': obj.Approved = true; break;
                case 'Edit': obj.Rejected = true; break;
            }
        }
        else {
            obj.StockAdjustmentId = 0;
        }

        var jqxhr = $.post("/api/StockAdjustment/Save", obj, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.StockAdjustmentId);
          
            //$("#Timestamp").val(result.Timestamp);
            if (result != null && result.StockAdjustmentGridList != null && result.StockAdjustmentGridList.length > 0) {
                BindGridData(result);
            }
            $(".content").scrollTop(0);
            showMessage('Stock Adjustment', CURD_MESSAGE_STATUS.SS);
            $('#btnDelete').hide();
            $('#divStatus').show();
            $('#btnStatusVal').text('');
           // $('#btnStatusVal').prop('value', '');
            // $('#btnStatusVal').removeClass("important btn hover_effect btn-info");
            $('#btnStatusVal').text("Rejected");
          //  $('#btnStatusVal').prop('value', "Rejected");
          //  $('#btnStatusVal').addClass("important btn hover_effect btn-danger");
            $('#btnAdjustmentApprove').hide();
            $('#btnAdjustmentReject').hide();

            $('#myPleaseWait').modal('hide');
            $("#grid").trigger('reloadGrid');
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
            $("div.errormsgcenter").text(errorMessage).css('visibility', 'visible');
            $('#errorMsg').css('visibility', 'visible');
            $('#btnAdjustmentApprove').attr('disabled', false);
            $('#btnAdjustmentReject').attr('disabled', false);

            $('#myPleaseWait').modal('hide');           
        });

    });



    //---------------------------------------- Back & Addnew Button ----------------------------------


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


//********************************* Fetch *****************************************

function FetchFacilityCodeData(event) {
    var StockAdjustmentFtycodeFetchObj = {
        SearchColumn: 'Ftycode-FacilityCode',//Id of Fetch field
        ResultColumns: ["StockAdjustmentId-Primary Key", 'Ftycode-FacilityCode'],//Columns to be displayed
        FieldsToBeFilled: ["hdnFtycode-WorkOrderId", "FacilityCode-Ftycode", "FacilityName-Ftyname"]//id of element - the model property
    };
    var apiUrlForFetch = "/api/Fetch/FetchStockAdjustmentdetails";
    $('#Ftycode').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('FtycodeFetch', StockAdjustmentFtycodeFetchObj, apiUrlForFetch, "UlFetch", event, 1);//1 -- pageIndex
    });
}

function FetchPartNodataStockAdjustment(event, index) {
    $('#divFetch_' + index).css({
        'top': $('#partno_' + index).offset().top - $('#StockadjustmentdataTable').offset().top + $('#partno_' + index).innerHeight(),
        //'width': $('#partno_' + index).outerWidth()
    });    
    var StockAdjustmentFetchObj = {
        SearchColumn: 'partno_' + index + '-PartNo',    //Id of Fetch field
        ResultColumns: ["StockUpdateDetId" + "-Primary Key", 'PartNo' + '-partno_' + index, 'InvoiceNo' + '-invoiceno_' + index],
        FieldsToBeFilled: ["SparePartsId_" + index + "-SparePartsId", 'StockUpdateDetId_' + index + '-StockUpdateDetId', 'partno_' + index + '-PartNo', 'partdesc_' + index + '-PartDescription', 'itemcode_' + index + '-ItemCode', 'itemdesc_' + index + '-ItemDescription', 'BinNo_' + index + '-BinNo', 'qtyfacility_' + index + '-QuantityFacility', 'cstcurrency_' + index + '-Cost', 'purchasecst_' + index + '-PurchaseCost', 'invoiceno_' + index + '-InvoiceNo', 'vendorname_' + index + '-VendorName']//id of element - the model property
    };

    DisplayFetchResult('divFetch_' + index, StockAdjustmentFetchObj, "/api/Fetch/StockAdjustmentFetchModel", "UlFetch" + index, event, 1);
 
}

//****************************** AddNewRow **********************************************

var linkCliked1 = false;
function AddNewRowStkAdjustment() {

        var inputpar = {
            inlineHTML: BindNewRowHTML(),

            IdPlaceholderused: "maxindexval",
            TargetId: "#StkAdjustmentTbl",
            TargetElement: ["tr"]

        }
        AddNewRowToDataGrid(inputpar);
        ckNewRowPaginationValidation = true;
        $('#chk_stkadjustmentdet').prop("checked", false);
        if (!linkCliked1) {
            $('#StkAdjustmentTbl tr:last td:first input').focus();
        }
        else {
            linkCliked1 = false;
        }
        formInputValidation("StockAdjustmentFrom");

    //************************* Validation *****************************

        $('.digOnly').keypress(function (e) {
            var regex = new RegExp(/[^a-zA-Z]/, '');
            var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
            if (regex.test(str)) {
                return true;
            }
            e.preventDefault();
            return false;
        });
        $('.digOnly').on('paste', function (e) {
            var $this = $(this);
            setTimeout(function () {
                $this.val($this.val().replace(/[a-zA-Z0-9~`!@#$%^&*_+|\\:{}\[\];-?<>\^\"\']/g, ''));
            }, 5);
        });

        $('.detRemark').keypress(function (e) {
            var regex = new RegExp("^[a-zA-Z0-9'.'&quot;,:;/\(\),\-\s\!&#64;\#\$\%\&\*]+$");
            var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
            if (regex.test(str)) {
                return true;
            }
            e.preventDefault();
            return false;
        });
        $('.detRemark').on('paste', function (e) {
            var $this = $(this);
            setTimeout(function () {
                $this.val($this.val().replace(/[~`@^*_+|\\{}\[\]?<>/\^]/g, ''));
            }, 5);
        });
        $("input").keypress(function (e) {
            if (e.which === 32 && !this.value.length)
                e.preventDefault();
        });

    //***************************End ***********************************

}

function BindNewRowHTML() {
    return ' <tr> <td width="3%" title="Select All"> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(StkAdjustmentTbl,chk_stkadjustmentdet)"> </label> </div></td><td width="7%" style="text-align: center;" title=""> <div> <input type="text" id="partno_maxindexval" value="" placeholder="Please Select" onkeyup="FetchPartNodataStockAdjustment(event,maxindexval)" onpaste="FetchPartNodataStockAdjustment(event,maxindexval)" change="FetchPartNodataStockAdjustment(event,maxindexval)" oninput="FetchPartNodataStockAdjustment(event,maxindexval)" class="form-control" maxlength="25" required> <input type="hidden" id="SparePartsId_maxindexval"/> <input type="hidden" id="StockUpdateDetId_maxindexval"/> <input type="hidden" id="hdnStkAdjustmentId_maxindexval" value=0> <div class="col-sm-12" id="divFetch_maxindexval"></div></div></td><td width="7%" style="text-align: center;" title=""> <div> <input type="text" id="partdesc_maxindexval" maxlength="100" class="form-control" readonly disabled> </div></td><td width="6%" style="text-align: center;" title=""> <div> <input type="text" id="itemcode_maxindexval" class="form-control" maxlength="25" readonly disabled> </div></td><td width="7%" style="text-align: center;" title=""> <div> <input type="text" id="itemdesc_maxindexval" class="form-control" maxlength="100" readonly disabled> </div></td><td width="5%" style="text-align: center;" title=""> <div> <input type="text" id="BinNo_maxindexval" class="form-control" maxlength="25" readonly disabled> </div></td><td width="9%" style="text-align: center;" title=""> <div> <input type="text" id="qtyfacility_maxindexval" class="form-control text-right" readonly disabled> </div></td><td width="8%" style="text-align: center;" title=""> <div> <input type="text" id="physicalqty_maxindexval" maxlength="8" style="text-align: right;" class="form-control digOnly text-right" pattern="^((?!(0))[0-9]{1,15})$" required onchange="CostValidation()"> </div></td><td width="6%" style="text-align: center;" title=""> <div> <input type="text" id="variance_maxindexval" maxlength="8" class="form-control text-right" readonly disabled> </div></td><td width="8%" style="text-align: center;" title=""> <div> <input type="text" id="adjustqty_maxindexval" maxlength="8" class="form-control text-right" readonly disabled> </div></td><td width="7%" style="text-align: center;" title=""> <div> <input type="text" id="purchasecst_maxindexval" maxlength="8" class="form-control text-right commaSeperator" readonly disabled> </div></td><td width="8%" style="text-align: center;" title=""> <div> <input type="text" id="cstcurrency_maxindexval" maxlength="8" class="form-control digOnly text-right" readonly disabled> </div></td><td width="7%" style="text-align: center;" title=""> <div> <input type="text" id="invoiceno_maxindexval" class="form-control" maxlength="25" readonly disabled> </div></td><td width="6%" style="text-align: center;" title=""> <div> <input type="text" id="vendorname_maxindexval" maxlength="100" class="form-control" readonly disabled> </div></td><td width="6%" style="text-align: center;" title=""> <div> <input type="text" class="form-control detRemark" maxlength="250" id="remarks_maxindexval" autocomplete="off"> </div></td></tr> '
        
}

//***************************** Validation ***********************************************

function CostValidation() {
    var _index;
    $('#StkAdjustmentTbl tr').each(function () {
        _index = $(this).index();
    });
    for (var i = 0; i <= _index; i++) {
        var QuantityFacility = parseInt($('#qtyfacility_' + i).val());
        var PhysicalQuantity = parseInt($("#physicalqty_" + i).val());
        var Variance = document.getElementById("#variance_" + i);
        var AdjustedQuantity = document.getElementById("#adjustqty_" + i);

        Variance = QuantityFacility - PhysicalQuantity;
        //AdjustedQuantity = PhysicalQuantity - QuantityFacility;
        AdjustedQuantity = QuantityFacility - PhysicalQuantity;
        $('#variance_' + i).val(Variance);
        $('#adjustqty_' + i).val(AdjustedQuantity);
    }
}


//*********************** Empty Row Validation **************************************

function AddNewRow() {
    $("div.errormsgcenter1").text("");
    $('#errorMsg1').css('visibility', 'hidden');
    var rowCount = $('#StkAdjustmentTbl tr:last').index();    
    var PartNo = $('#partno_' + rowCount).val();
    if (rowCount < 0)
        AddNewRowStkAdjustment();
    else if (rowCount >= "0" && PartNo == "") {
        bootbox.alert("All fields are mandatory. Please enter details in existing row");
        //  $("div.errormsgcenter1").text();
        // $('#errorMsg1').css('visibility', 'visible');
    }
    else {
        AddNewRowStkAdjustment();
    }
}


//************************************************ Getbyid bind data *************************

function BindGridData(result) {
    var ActionType = $('#ActionType').val();
    $("#chk_stkadjustmentdet").prop("disabled", false);
    $('#primaryID').val(result.StockAdjustmentGridList[0].StockAdjustmentId);
    $('#StkadjustNo').val(result.StockAdjustmentGridList[0].StockAdjustmentNo).prop("disabled", "disabled");
    var adjustDate = result.StockAdjustmentGridList[0].isAdjustmentDateNull ? "" : DateFormatter(result.StockAdjustmentGridList[0].AdjustmentDate);
    $('#Adjustdate').val(adjustDate).prop("disabled", "disabled");    
    $('#Ftycode').val(result.StockAdjustmentGridList[0].FacilityCode);
    $('#Ftyname').val(result.StockAdjustmentGridList[0].FacilityName);

    $("#StkAdjustmentTbl").empty();
    $.each(result.StockAdjustmentGridList, function (index, value) {
        AddNewRowStkAdjustment();

        $("#hdnStkAdjustmentId_" + index).val(result.StockAdjustmentGridList[index].StockAdjustmentDetId);
        $("#partno_" + index).attr('title', result.StockAdjustmentGridList[index].PartNo);
        $("#partno_" + index).val(result.StockAdjustmentGridList[index].PartNo).prop("disabled", "disabled");
        $("#partdesc_" + index).val(result.StockAdjustmentGridList[index].PartDescription).attr('title', result.StockAdjustmentGridList[index].PartDescription);
        $('#itemcode_' + index).val(result.StockAdjustmentGridList[index].ItemCode).attr('title', result.StockAdjustmentGridList[index].ItemCode);
        $('#itemdesc_' + index).val(result.StockAdjustmentGridList[index].ItemDescription).attr('title', result.StockAdjustmentGridList[index].ItemDescription);
        $('#BinNo_' + index).val(result.StockAdjustmentGridList[index].BinNo).attr('title', result.StockAdjustmentGridList[index].BinNo);
        $("#qtyfacility_" + index).val(result.StockAdjustmentGridList[index].QuantityFacility).attr('title', result.StockAdjustmentGridList[index].QuantityFacility);
        $("#physicalqty_" + index).val(result.StockAdjustmentGridList[index].PhysicalQuantity).attr('title', result.StockAdjustmentGridList[index].PhysicalQuantity);
        $("#variance_" + index).val(result.StockAdjustmentGridList[index].Variance).attr('title', result.StockAdjustmentGridList[index].Variance);
        $("#adjustqty_" + index).val(result.StockAdjustmentGridList[index].AdjustedQuantity).attr('title', result.StockAdjustmentGridList[index].AdjustedQuantity);
        $("#cstcurrency_" + index).val(addCommas(result.StockAdjustmentGridList[index].Cost)).attr('title', result.StockAdjustmentGridList[index].Cost);
        $("#purchasecst_" + index).val(addCommas(result.StockAdjustmentGridList[index].PurchaseCost)).attr('title', result.StockAdjustmentGridList[index].PurchaseCost);
        $("#invoiceno_" + index).val(result.StockAdjustmentGridList[index].InvoiceNo).attr('title', result.StockAdjustmentGridList[index].InvoiceNo);
        $("#vendorname_" + index).val(result.StockAdjustmentGridList[index].VendorName).attr('title', result.StockAdjustmentGridList[index].VendorName);
        $("#remarks_" + index).val(result.StockAdjustmentGridList[index].Remarks).attr('title', result.StockAdjustmentGridList[index].Remarks);

        $("#SparePartsId_" + index).val(result.StockAdjustmentGridList[index].SparePartsId);
        $("#StockUpdateDetId_" + index).val(result.StockAdjustmentGridList[index].StockUpdateDetId);
        
        var appstatus = result.StockAdjustmentGridList[index].ApprovalStatus;
        if ((appstatus == 75) || (appstatus == 76) || (appstatus == 77)) {
            $("#chk_stkadjustmentdet").prop("disabled", "disabled");
            $("#Isdeleted_" + index).val(result.StockAdjustmentGridList[index].IsDeleted).prop("disabled", "disabled");
            $("#physicalqty_" + index).val(result.StockAdjustmentGridList[index].PhysicalQuantity).prop("disabled", "disabled");
           // $("#remarks_" + index).val(result.StockAdjustmentGridList[index].Remarks).prop("disabled", "disabled");
        }        

        if ((appstatus == 76) || (appstatus == 77)) {
            $("#remarks_" + index).val(result.StockAdjustmentGridList[index].Remarks).prop("disabled", "disabled");
        }

        if (ActionType == "View") {
            $("#chk_stkadjustmentdet").prop("disabled", "disabled");
            $('#divStatus').show();
            $("#form :input:not(:button)").prop("disabled", true);
            $("#physicalqty_" + index).val(result.StockAdjustmentGridList[index].PhysicalQuantity).prop("disabled", "disabled");             
            $("#remarks_" + index).val(result.StockAdjustmentGridList[index].Remarks).prop("disabled", "disabled");
            $("#Isdeleted_" + index).val(result.StockAdjustmentGridList[index].IsDeleted).prop("disabled", "disabled");
        }
        linkCliked1 = true;
        $(".content").scrollTop(0);
    });
    //************************************************ Grid Pagination *******************************************
    ckNewRowPaginationValidation = false;
    if ((result.StockAdjustmentGridList && result.StockAdjustmentGridList.length) > 0) {
        StockAdjustmentId = result.StockAdjustmentGridList[0].StockAdjustmentId;
        GridtotalRecords = result.StockAdjustmentGridList[0].TotalRecords;
        TotalPages = result.StockAdjustmentGridList[0].TotalPages;
        LastRecord = result.StockAdjustmentGridList[0].LastRecord;
        FirstRecord = result.StockAdjustmentGridList[0].FirstRecord;
        pageindex = result.StockAdjustmentGridList[0].PageIndex;
        linkCliked1 = true;
        $(".content").scrollTop(0);
    }
    $('#paginationfooter').show();
    var mapIdproperty = ["IsDeleted-Isdeleted_", "StockAdjustmentDetId-hdnStkAdjustmentId_", "PartNo-partno_", "PartDescription-partdesc_", "ItemCode-itemcode_", "ItemDescription-itemdesc_", "BinNo-BinNo_", "QuantityFacility-qtyfacility_", "PhysicalQuantity-physicalqty_", "Variance-variance_", "AdjustedQuantity-adjustqty_", "Cost-cstcurrency_", "PurchaseCost-purchasecst_", "InvoiceNo-invoiceno_", "VendorName-vendorname_", "Remarks-remarks_", "SparePartsId-SparePartsId_", "StockUpdateDetId-StockUpdateDetId_"];

    var htmltext = BindNewRowHTML();//Inline Html
    var primaryId = $('#primaryID').val();
    var obj = {
        formId: "#StockAdjustmentFrom", IsView: ($('#ActionType').val() == "View"), PageNumber: pageindex, flag: "Stockadjustmentflag", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "StockAdjustmentGridList", tableid: '#StkAdjustmentTbl', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/StockAdjustment/get/" + primaryId, pageindex: pageindex, pagesize: pagesize
    };

    CreateFooterPagination(obj)

    //************************************************ End *******************************************************
}


function HideRemarks(result) {
    $.each(result.StockAdjustmentGridList, function (index, value) {        
        $("#remarks_" + index).val(result.StockAdjustmentGridList[index].Remarks).prop("disabled", "disabled");
        linkCliked1 = true;
        $(".content").scrollTop(0);
    });
}
//************************************************* Delete ****************************************

function chkIsDeletedRow(i, delrec) {
    if (delrec == true) {
        $('#partno_' + i).prop("required", false);
        $('#physicalqty_' + i).prop("required", false);
        $('#cstcurrency_' + i).prop("required", false);
        $('#invoiceno_' + i).prop("required", false);
        return true;
    }
    else {
        return false;
    }
}

function fetchValidation() {
    var _index;
    $('#StkAdjustmentTbl tr').each(function () {
        _index = $(this).index();
    });    
    
    for (var i = 0; i <= _index; i++) {
        var SparePartsId = $("#SparePartsId_" + i).val();       

        if (SparePartsId == null || SparePartsId == 0 || SparePartsId == "") {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#partno_' + i).parent().addClass('has-error');
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnAdjustmentSave').attr('disabled', false);
            $('#btnAdjustmentEdit').attr('disabled', false);
            return false;
        }    
    }    
}

//**************************** Grid merging***************************//

function LinkClicked(id, rowData) {
    linkCliked1 = true;
    //console.log(rowData);
    //if (rowData.ApprovalStatusValue == "Open" || rowData.ApprovalStatusValue == "Submitted") {
    //    $('#btnAdjustmentEdit').show();
    //    $('#btnAdjustmentSave').hide();
    //    $('#btnAdjustmentApprove').show();
    //    $('#btnAdjustmentReject').show();
    //    $('#btnAdjustmentVerify').show();
    //    $('#btnSaveandAddNew').show();
    //    $('#btnDelete').show();
    //}
    //else
    //{
    //    $('#btnAdjustmentEdit').hide();
    //    $('#btnAdjustmentSave').hide();
    //    $('#btnAdjustmentApprove').hide();
    //    $('#btnAdjustmentReject').hide();
    //    $('#btnAdjustmentVerify').hide();
    //    $('#btnSaveandAddNew').hide();
    //    $('#btnDelete').hide();

        
    //}
    $(".content").scrollTop(1);
    $("#StockAdjustmentFrom :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");
    var hasApprovePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");
    var hasApprovePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Reject'");

    if (hasEditPermission && !hasViewPermission) {
        action = "Edit"

    }
    else if (!hasEditPermission && hasViewPermission) {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#btnDelete').show();
    }

    if (action == 'View') {
        $("#StockAdjustmentFrom :input:not(:button)").prop("disabled", true);
        $('#btnAdjustmentEdit').hide();
        $('#btnAdjustmentSave').hide();
        $('#btnAdjustmentApprove').hide();
        $('#btnAdjustmentReject').hide();
        $('#btnAdjustmentVerify').hide();
        $('#btnDelete').hide();
        $('#btnSaveandAddNew').hide();
    }
    else if (action != 'View' && rowData.ApprovalStatusValue == "Open") {
        $('#btnAdjustmentEdit').show();
        $('#btnAdjustmentSave').hide();
        $('#btnAdjustmentApprove').hide();
        $('#btnAdjustmentReject').hide();
        $('#btnAdjustmentVerify').show();
        $('#btnAdjustmentVerify').attr('disabled', false);
        $('#btnAdjustmentEdit').attr('disabled', false);
       // $('#btnDelete').hide();
        $('#btnSaveandAddNew').show();
    }
    else if (action != 'View' &&rowData.ApprovalStatusValue == "Submitted")
    {
        $('#btnAdjustmentEdit').hide();
        $('#btnAdjustmentSave').hide();
        $('#btnAdjustmentApprove').show();
        $('#btnAdjustmentReject').show();
        $('#btnAdjustmentVerify').hide();
        $('#btnDelete').hide();
        $('#btnSaveandAddNew').hide();
        $('#btnAdjustmentApprove').attr('disabled', false);
        $('#btnAdjustmentReject').attr('disabled', false);
    }
    else if (action != 'View' && rowData.ApprovalStatusValue == "Rejected") {
        $('#btnAdjustmentEdit').hide();
        $('#btnAdjustmentSave').hide();
        $('#btnAdjustmentApprove').hide();
        $('#btnAdjustmentReject').hide();
        $('#btnAdjustmentVerify').hide();
        $('#btnDelete').hide();
        $('#btnSaveandAddNew').hide();
    }
    else if (action != 'View' && rowData.ApprovalStatusValue == "Approved") {
        $('#btnAdjustmentEdit').hide();
        $('#btnAdjustmentSave').hide();
        $('#btnAdjustmentApprove').hide();
        $('#btnAdjustmentReject').hide();
        $('#btnAdjustmentVerify').hide();
        $('#btnDelete').hide();
        $('#btnSaveandAddNew').hide();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        getById(primaryId, pagesize, pageindex)
    }
    else {
           $('#myPleaseWait').modal('hide');
        }

    //********************************************** Getby ID ****************************************************

    function getById(primaryId, pagesize, pageindex) {
        $.get("/api/StockAdjustment/get/" + primaryId + "/" + pagesize + "/" + pageindex)
                .done(function (result) {
                    var result = JSON.parse(result);
                    var primaryId = $('#primaryID').val();
                    $('#divStatus').hide();
                    $('#addrowplus').show();
                    //$("#jQGridCollapse1").click();
                    if (result.StockAdjustmentGridList[0].ApprovalStatus == 74) {       // status Open
                        $('#btnAdjustmentReject').hide();
                        $('#btnAdjustmentApprove').hide();
                        $('#btnAdjustmentEdit').show();
                        $('#btnAdjustmentVerify').show();
                    }
                    if (result.StockAdjustmentGridList[0].ApprovalStatus == 75) {       // status Submit
                        $('#addrowplus').hide();
                        $('#divStatus').show();
                        $('#btnStatusVal').text("Submitted");
                      //  $('#btnStatusVal').prop('value', "Submitted");
                      //  $('#btnStatusVal').removeClass();
                      //  $('#btnStatusVal').addClass("important btn hover_effect btn-info");                          
                        
                        $('#btnAdjustmentReject').show();
                        $('#btnAdjustmentApprove').show();
                        $('#btnAdjustmentEdit').hide();
                        $('#btnAdjustmentVerify').hide();
                    }
                    if (result.StockAdjustmentGridList[0].ApprovalStatus == 76) {       // status Approve
                        $('#addrowplus').hide();
                        $('#divStatus').show();
                        $('#btnStatusVal').text("Approved");
                      //  $('#btnStatusVal').prop('value', "Approved");
                     //   $('#btnStatusVal').removeClass();
                     //   $('#btnStatusVal').addClass("important btn hover_effect btn-success");
                        

                        $('#Approveby').val(result.StockAdjustmentGridList[0].ApprovedBy);
                        var approveDate = result.StockAdjustmentGridList[0].isApprovedDateNull ? "" : DateFormatter(result.StockAdjustmentGridList[0].ApprovedDate);                    

                        $('#Approvedate').val(approveDate);
                        $('#btnAdjustmentReject').hide();
                        $('#btnAdjustmentApprove').hide();
                        $('#btnAdjustmentEdit').hide();
                        $('#btnAdjustmentVerify').hide();
                    }
                    if (result.StockAdjustmentGridList[0].ApprovalStatus == 77) {       // status Reject
                        $('#addrowplus').hide();
                        $('#divStatus').show();
                        $('#btnStatusVal').text("Rejected");
                     //   $('#btnStatusVal').prop('value', "Rejected");
                    //    $('#btnStatusVal').removeClass();
                    //    $('#btnStatusVal').addClass("important btn hover_effect btn-danger");

                        $('#Approveby').val(result.StockAdjustmentGridList[0].ApprovedBy);                        
                        $('#Approvedate').val("");
                        $('#btnAdjustmentReject').hide();
                        $('#btnAdjustmentApprove').hide();
                        $('#btnAdjustmentEdit').hide();
                        $('#btnAdjustmentVerify').hide();
                    }

                    $("#StkAdjustmentTbl").empty();

                    if (result != null && result.StockAdjustmentGridList != null && result.StockAdjustmentGridList.length > 0) {
                        BindGridData(result);
                    }
                    $('#myPleaseWait').modal('hide');
                })
                .fail(function (response) {
                    $('#myPleaseWait').modal('hide');
                    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                    $('#errorMsg').css('visibility', 'visible');
                });
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
            $.get("/api/StockAdjustment/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('Stock Adjustment', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 $("#grid").trigger('reloadGrid');
                 EmptyFields();
             })
             .fail(function (response) {
                 showMessage('Level', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
                 $("#grid").trigger('reloadGrid');
             });
        }
    });
}

function EmptyFields() {
    $('#myPleaseWait').modal('hide');    
    $('#errorMsg').css('visibility', 'hidden');
    $('#addrowplus').show();
    $('input[type="text"], textarea').val('');
    $('#StkAdjustmentTbl').empty();
    var CurDate = GetCurrentDate();
    $('#Adjustdate').val(CurDate);
    AddNewRowStkAdjustment();
    $('#LevelFacility').val("null");
    $('#LevelBlock').val("null");
    $('#LevelCode').prop('disabled', false);
    $('#btnSaveandAddNew').show();
    $('#btnAdjustmentEdit').hide();
    $('#btnAdjustmentSave').show();
    $('#btnDelete').hide();
    $('#btnAdjustmentVerify').hide();
    $('#btnAdjustmentApprove').hide();
    $('#btnAdjustmentReject').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#btnStatusVal").text('');
    $('#btnStatusVal').removeClass();
    $("#btnStatusVal").val('');
    $('#btnStatusVal').removeClass("important btn hover_effect btn-info");
    $('#btnStatusVal').removeClass("important btn hover_effect btn-success");
    $('#btnStatusVal').removeClass("important btn hover_effect btn-danger");
    $("#divStatus").hide();
    $('#btnAdjustmentSave').attr('disabled', false);
    $("#chk_stkadjustmentdet").prop("disabled", false);
    $("#grid").trigger('reloadGrid');
    $('#paginationfooter').hide();
}

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
});