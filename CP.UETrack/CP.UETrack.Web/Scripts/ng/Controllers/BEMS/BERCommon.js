$(document).ready(function () {
    var HiddenId = $('#hdnAttachId').val();


    //if cannot repair is not  ticked then Estimated Repair Cost (RM) is mandatory
    $("#cannotRepair").change(function () {
        $("#AfterRepairValue").parent().removeClass('has-error');
        if (this.checked) {
            $('#estimatedRepairCostlabelid').html("Estimated Repair Cost (RM)");
            $("#RepairEstimateCost").parent().removeClass('has-error');
            $('#RepairEstimateCost').removeAttr('required');
            // $('#AfterRepairValue').prop('disabled', true);
            //  $('#AfterRepairValue').val("");
        }
        else {
            $('#RepairEstimateCost').attr('required', true);
            $('#estimatedRepairCostlabelid').html("Estimated Repair Cost (RM) <span class='red'> *</span>");
            //$('#AfterRepairValue').prop('disabled', false);
        }
    });

    //if cannot repair is not  ticked then Estimated Repair Cost (RM) is mandatory
    $("#EstimatedCosttooExpensiveCheckboxId").change(function () {
        if (this.checked) {
            $('#estimatedCosttooLabelId').html("Estimated Repair Cost Too Expensive <span class='red'> *</span>");
            $('#EstimatedCosttooExpensive').prop('disabled', false);

        }
        else {
            $('#estimatedCosttooLabelId').html("Estimated Repair Cost Too Expensive");
            $('#EstimatedCosttooExpensive').prop('disabled', true);
            $('#EstimatedCosttooExpensive').val('');
        }
    });

    // BER1 rejected No fetch and Ber2 Approved 
    var BerRejectedFetchObj = {
        SearchColumn: 'txtOldBerNo-BERno',//Id of Fetch field
        ResultColumns: ["RejectedApplicationId-Primary Key", 'BERno-BER No.'],
        FieldsToBeFilled: ["hdnRejectedBERReferenceId-RejectedApplicationId", "txtOldBerNo-BERno"],
        AdditionalConditions: ["BERStage-BERStage"],
    };
    $('#txtOldBerNo').on('input propertychange paste keyup', function (event) {
        $('#ApplicationDate').val("");
        $('#RepairEstimateCost').val("");
        $('#estimatedDurationOfUsageAfterRepair').val("");
        $("input[name=EstimatedCosttooExpensive][value=" + 0 + "]").prop('checked', true);
        $("input[name=NotReliableId][value=" + 0 + "]").prop('checked', true);
        $("input[name=ObsolescenceId][value=" + 0 + "]").prop('checked', true);
        $("input[name=StatuaryRequirementsid][value=" + 0 + "]").prop('checked', true);
        DisplayFetchResult('divFetch1', BerRejectedFetchObj, "/api/Fetch/BERRejectedNoFetch", "UlFetch1", event, 1);
    });

    // BER1 rejected No and Approved No Search
    var BerRejectedSearch = {

        Heading: "Rejected BER No.",//Heading of the popup
        SearchColumns: ['BERno-BER No.'],
        ResultColumns: ["RejectedApplicationId-Primary Key", 'BERno-BER No.'],
        FieldsToBeFilled: ["hdnRejectedBERReferenceId-RejectedApplicationId", "txtOldBerNo-BERno"],
        AdditionalConditions: ["BERStage-BERStage"],
    };
    var BerApprovedSearch = {

        Heading: "Approved BER No.",//Heading of the popup
        SearchColumns: ['BERno-BER No.'],
        ResultColumns: ["RejectedApplicationId-Primary Key", 'BERno-BER No.'],
        FieldsToBeFilled: ["hdnRejectedBERReferenceId-RejectedApplicationId", "txtOldBerNo-BERno"],
        AdditionalConditions: ["BERStage-BERStage"],
    };

    $('#spnPopup-berNo').click(function () {

        var berStage = $('#BERStage').val();
        if (berStage == 1 || berStage == "1") {
            DisplaySeachPopup('divSearchPopup', BerRejectedSearch, "/api/Search/BERRejectedNoSearch");
        }
        else {
            DisplaySeachPopup('divSearchPopup', BerApprovedSearch, "/api/Search/BERRejectedNoSearch");
        }
    });

    // AssetNo fetch
    var AssetNoFetch = {
        SearchColumn: 'txtAssetNo-AssetNo',//Id of Fetch field
        ResultColumns: ["AssetId-Primary Key", 'AssetNo-Asset No.', 'AssetDescription-Asset Description', 'UserLocationCode-Location Code',
            'UserLocationName-Location Name', 'Manufacturer-Manufacturer', 'Model-Model', 'SupplierName-Supplier Name',
            'PurchaseCost-Purchase Cost', 'PurchaseDate-Purchase Date', 'CurrentValue-Current Value',
            'AssetAge-AssetAge'],
        FieldsToBeFilled: ["hdnAssetId-AssetId", "txtAssetNo-AssetNo", "txtassetDescription-AssetDescription", "UserLocationCode-UserLocationCode", "UserLocationName-UserLocationName", "Manufacturer-Manufacturer", "Model-Model", "SupplierName-SupplierName", "PurchaseCost-PurchaseCost", "PurchaseDate-PurchaseDate",

            "AssetAge-AssetAge",
            "StillwithInLifeSpan-StillwithInLifeSpan",

            "CurrentValue-CurrentValue"]
    };
    $('#txtAssetNo').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch2', AssetNoFetch, "/api/Fetch/BERAssetNoFetch", "UlFetch2", event, 1);//1 -- pageIndex
    });
    // Asset No Search
    var AssetSearchObj = {
        Heading: "Asset No.",
        SearchColumns: ['AssetNo-Asset No'],//ModelProperty - Space seperated label value
        ResultColumns: ['AssetId-Primary Key', 'AssetNo-Asset No.', 'AssetDescription-Asset Description', 'UserLocationCode-Location Code', 'UserLocationName-Location Name', 'Manufacturer-Manufacturer', 'Model-Model', 'SupplierName-Supplier Name', 'PurchaseCost-Purchase Cost', 'PurchaseDate-Purchase Date', 'CurrentValue-Current Value'],
        FieldsToBeFilled: ["hdnAssetId-AssetId", "txtAssetNo-AssetNo", "txtassetDescription-AssetDescription", "UserLocationCode-UserLocationCode",
            "UserLocationName-UserLocationName", "Manufacturer-Manufacturer", "Model-Model", "SupplierName-SupplierName", "PurchaseCost-PurchaseCost",
            "PurchaseDate-PurchaseDate", "CurrentValue-CurrentValue",
            "AssetAge-AssetAge",
            "StillwithInLifeSpan-StillwithInLifeSpan"]
    };
    $('#spnPopup-asset').click(function () {
        DisplaySeachPopup('divSearchPopup', AssetSearchObj, "/api/Search/BERAssetSearch");
    });

    // Company Staff fetch
    var CompanyStaffFetchObj = {
        SearchColumn: 'txtCompanyStaffName-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name', 'Designation-Designation'],
        FieldsToBeFilled: ["hdnCompanyStaffId-StaffMasterId", "txtCompanyStaffName-StaffName", "txtDesignation-Designation"]
    };
    $('#txtCompanyStaffName').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch3', CompanyStaffFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch3", event, 1);//1 -- pageIndex
    });

    // Hospital Staff Search
    var CompanySearchObj = {
        Heading: "Requestor Name",//Heading of the popup
        SearchColumns: ['StaffName-Staff Name'],//ModelProperty - Space seperated label value
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name', 'Designation-Designation'],//Columns to be returned for display
        FieldsToBeFilled: ["hdnCompanyStaffId-StaffMasterId", "txtCompanyStaffName-StaffName", "txtDesignation-Designation"]
    };

    $('#spnPopup-compStaff').click(function () {
        DisplaySeachPopup('divSearchPopup', CompanySearchObj, "/api/Search/CompanyStaffSearch");
    });

    $('#btnAddNew').click(function () {
        window.location.reload();
    });

    $("#aMaintenanceHistab").click(function () {
        var primaryId = $('#primaryID').val();
        $('#TotalContractCost').val('');
        if (primaryId == 0) {
            bootbox.alert(Messages.SAVE_FIRST_TABALERT);
            return false;
        }
        else {
            $("div.errormsgcenter5").text("");
            $('#errorMsg5').css('visibility', 'hidden');
            var ApplicationId = $('#primaryID').val();
            $('#HistorymBerNo').val($('#berNo').val());
            $('#HistorymApplicationDate').val($('#ApplicationDate').val());
            $.get("/api/BerOne/getMaintainanceHistory/" + ApplicationId)
                .done(function (result) {
                    var SNo = 0;
                    var getHistory = JSON.parse(result);
                    $("#MaintainanceHistoryId").empty();
                    if (getHistory != null && getHistory.BERMaintananceHistoryDets != null && getHistory.BERMaintananceHistoryDets.length > 0) {
                        var html = '';
                        $(getHistory.BERMaintananceHistoryDets).each(function (index, data) {
                            data.MaintenanceWorkDateTime = (data.MaintenanceWorkDateTime != null) ? moment(data.MaintenanceWorkDateTime).format("DD-MMM-YYYY HH:mm") : ""; //DateFormatter(data.MaintenanceWorkDateTime) : "";
                            data.DowntimeHoursMin = (data.DowntimeHoursMin != null) ? data.DowntimeHoursMin : "";


                            var totalContractCost = (data.TotalContractCost != null) ? addCommas(data.TotalContractCost) : data.TotalContractCost
                            $('#TotalContractCost').val(totalContractCost);
                            // SNo = 1 + index;
                            //html += '<tr class="ng-scope" style=""> <td width="15%" style="text-align: center;"> <div> <input type="text" class="form-control" id="MaintenanceWorkNo_' + index + '" value="' + data.MaintenanceWorkNo + '" readonly/> </div></td><td width="20%" style="text-align: center;"> <div> <input type="text" class="form-control" id="MaintenanceWorkDateTime_' + index + '" value="' + data.MaintenanceWorkDateTime + '" readonly/> </div></td><td width="20%" style="text-align: center;"> <div> <input type="text" class="form-control" id="MaintenanceWorkCategory_' + index + '" value="' + data.MaintenanceWorkCategory + '" readonly/> </div></td><td width="15%" style="text-align: center;"> <div> <input type="text" class="form-control" id="MaintenanceWorkType_' + index + '" value="' + data.MaintenanceWorkType + '" readonly/> </div></td><td width="15%" style="text-align: right;"> <div> <input type="text" class="form-control" id="DowntimeHoursMin_' + index + '" value="' + data.DowntimeHoursMin + '" readonly/> </div></td><td width="15%" style="text-align: right;"> <div> <input type="text" class="form-control" id="TotalCost_' + index + '" value="' + data.TotalCost + '" readonly/> </div></td></tr>';
                            html += ' <tr class="ng-scope" style="">' +
                                ' <td width="20%" style="text-align: center;"> <div> ' +
                                '<input type="text" class="form-control" title="' + data.MaintenanceWorkNo + '" id="MaintenanceWorkNo_' + index + '" value="' + data.MaintenanceWorkNo + '" readonly/> </div></td> ' +
                                '<td width="15%" style="text-align: center;"> <div>' +
                                ' <input type="text" class="form-control" id="MaintenanceWorkDateTime_' + index + '" value="' + data.MaintenanceWorkDateTime + '" readonly/> </div></td>' +
                                //'<td width="10%" style="text-align: center;"> <div> <input type="text" class="form-control" id="MaintenanceWorkCategory_' + index + '" value="' + data.MaintenanceWorkCategory + '" readonly/> </div></td>' +
                                '<td width="15%" style="text-align: center;"> <div>' +
                                ' <input type="text" class="form-control" id="MaintenanceWorkType_' + index + '" value="' + data.MaintenanceWorkType + '" readonly/> </div></td><td width="10%" style="text-align: right;"> <div>' +
                                ' <input type="text" class="form-control" id="DowntimeHoursMin_' + index + '" value="' + data.DowntimeHoursMin + '" readonly/> </div></td><td width="10%" style="text-align: right;"> <div>' +
                                //' <input type="text" class="form-control" id="TotalContractCost_' + index + '" value="' + totalContractCost + '" readonly/> </div></td><td width="10%" style="text-align: right;"> <div> ' +
                                ' <input type="text" class="form-control" id="TotalSpareCost_' + index + '" value="' + addCommas(data.TotalSpareCost) + '" readonly/> </div></td><td width="10%" style="text-align: right;"> <div>' +
                                ' <input type="text" class="form-control" id="TotalLabourCost_' + index + '" value="' + addCommas(data.TotalLabourCost) + '" readonly/> </div></td>' +
                                '<td width="10%" style="text-align: right;"> <div> ' +
                                '<input type="text" class="form-control" id="TotalVendorCost_' + index + '" value="' + addCommas(data.TotalVendorCost) + '" readonly/> </div></td>' +
                                '<td width="10%" style="text-align: right;"> <div> ' +
                                '<input type="text" class="form-control" id="TotalCost_' + index + '" value="' + addCommas(data.TotalCost) + '" readonly/> </div></td>' +
                                '</tr>';
                        });
                        $("#MaintainanceHistoryId").append(html);
                        $('#myPleaseWait').modal('hide');
                    }
                    else {
                        $('#myPleaseWait').modal('hide');
                        $("#EODParamMappingBody").empty();
                        var emptyrow = '<tr id="NoActRec" class="norecord"><td width="100%"><h5 class="text-center">No  records to display</h5></td></tr>'
                        $("#MaintainanceHistoryId ").append(emptyrow);
                    }

                })
                .fail(function () {
                    $('#myPleaseWait').modal('hide');
                    $("div.errormsgcenter1").text(Messages.COMMON_FAILURE_MESSAGE);
                    $('#errorMsg1').css('visibility', 'visible');
                });
        }
    });

    $("#aApplicationHistab").click(function () {
        var primaryId = $('#primaryID').val();

        if (primaryId == 0) {
            bootbox.alert(Messages.SAVE_FIRST_TABALERT);
            return false;
        }
        else {
            $("div.errormsgcenter1").text("");
            $('#errorMsg1').css('visibility', 'hidden');
            var ApplicationId = $('#primaryID').val();
            $('#HistoryBerNo').val($('#berNo').val());
            $('#HistoryApplicationDate').val($('#ApplicationDate').val());
            $.get("/api/BerOne/getApplicationHistiry/" + ApplicationId)
                .done(function (result) {
                    var SNo = 0;
                    var getHistory = JSON.parse(result);
                    $("#ApplicationHistoryId").empty();
                    if (getHistory != null && getHistory.BERApplicationHistoryTxns != null && getHistory.BERApplicationHistoryTxns.length > 0) {
                        var html = '';
                        $(getHistory.BERApplicationHistoryTxns).each(function (index, data) {
                            data.CreatedDate = (data.CreatedDate != null) ? DateFormatter(data.CreatedDate) : "";
                            SNo = 1 + index;
                            html += '<tr class="ng-scope" style="">' +
                                '<td width="5%" style="text-align: center;"><div> <input type="text" class="form-control" id="Sno_' + index + '" value="' + SNo + '" readonly /></div></td><td width="15%" style="text-align: center;" ><div> ' +
                                '<input type="text" class="form-control" id="StatusValue_' + index + '" value="' + data.StatusValue + '" readonly /></div></td><td width="20%" style="text-align: center;" ><div>' +
                                ' <input type="text" class="form-control" id="StaffName_' + index + '" value="' + data.StaffName + '" readonly /></div></td><td width="20%" style="text-align: center;" ><div> ' +
                                ' <input type="text" class="form-control" id="Designation_' + index + '" value="' + data.Designation + '" readonly /></div></td><td width="20%" style="text-align: center;" ><div> ' +
                                '<input type="text" class="form-control" id="CreatedDate_' + index + '" value="' + data.CreatedDate + '" readonly /></div></td> <td width="20%" style="text-align: center;" ><div>' +

                                ' <input type="text" class="form-control" id="RejectedBERNo_' + index + '" value="' + data.RejectedBERNo + '" readonly /></div></td> ' +
                                '</tr>';
                        });
                        $("#ApplicationHistoryId").append(html);
                        $('#myPleaseWait').modal('hide');
                    }
                    else {
                        //$('#myPleaseWait').modal('hide');
                        //$("div.errormsgcenter1").text("No Records Displayed");
                        //$('#errorMsg1').css('visibility', 'visible');
                        $("#ApplicationHistoryId").empty();
                        var emptyrow = '<tr id="BERApp" class="norecord"><td width="100%"><h5 class="text-center">No  records to display</h5></td></tr>'
                        $("#ApplicationHistoryId ").append(emptyrow);
                    }

                })
                .fail(function () {
                    $('#myPleaseWait').modal('hide');
                    $("div.errormsgcenter1").text(Messages.COMMON_FAILURE_MESSAGE);
                    $('#errorMsg1').css('visibility', 'visible');
                });
        }
    });




    // BER1 rejected No fetch and Ber2 Approved 
    var Ber2RejectedFetchObj = {
        SearchColumn: 'txtOldRejectedBerNo-BERno',//Id of Fetch field
        ResultColumns: ["RejectedApplicationId-Primary Key", 'BERno-BER No.'],
        FieldsToBeFilled: ["hdnRejectedBERReferenceId-RejectedApplicationId", "txtOldRejectedBerNo-BERno"],
        AdditionalConditions: ["BERStage-BerRejected"],
    };
    $('#txtOldRejectedBerNo').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch5', Ber2RejectedFetchObj, "/api/Fetch/BERRejectedNoFetch", "UlFetch5", event, 1);
    });

    // BER1 rejected No and Approved No Search
    var Ber2RejectedSearch = {
        Heading: "Rejected BER No.",//Heading of the popup
        SearchColumns: ['BERno-BER No.'],
        ResultColumns: ["RejectedApplicationId-Primary Key", 'BERno-BER No.'],
        FieldsToBeFilled: ["hdnRejectedBERReferenceId-RejectedBERReferenceId", "txtOldRejectedBerNo-BERno"],
        AdditionalConditions: ["BERStage-BERStage"],
    };

    $('#spnPopup-berRejectedNo').click(function () {
        DisplaySeachPopup('divSearchPopup', Ber2RejectedSearch, "/api/Search/BERRejectedNoSearch");
    });


});


