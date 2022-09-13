var VariationValues = "";
var ToiletTypeValues = "";
var ToiletFrequencyValues = "";
var ToiletDetailsValues = "";

var rowNum1 = 1;
var rowNum2 = 1;

$(document).ready(function () {

    //#region Dept Area Details ------------------------------------------------------------

    $.get("/api/DeptAreaDetails/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            var AreaofCategory = "<option value='0' Selected>" + "Select" + "</option>"
            var statusval = "";
            var OperatingDays = "<option value='0' Selected>" + "Select" + "</option>"
            var WorkingHours = "<option value='0' Selected>" + "Select" + "</option>"
            var JIshedule = "<option value='' Selected>" + "Select" + "</option>"
            var PeriodicWork = "<option value='0' Selected>" + "Select" + "</option>"
            ToiletFrequencyValues = "<option value='0' Selected>" + "Select" + "</option>"  
            ToiletTypeValues = "<option value='0' Selected >" + "Select" + "</option>"  
            ToiletDetailsValues = "<option value='0' Selected>" + "Select" + "</option>"  
            VariationValues = "<option value='0' Selected>" + "Select" + "</option>"

           
            for (var i = 0; i < loadResult.CategoryOfAreaLovs.length; i++) {
                AreaofCategory += "<option value=" + loadResult.CategoryOfAreaLovs[i].LovId + ">" + loadResult.CategoryOfAreaLovs[i].FieldValue + "</option>"
            }
            $("#CArea").html(AreaofCategory);

            for (var i = 0; i < loadResult.StatusLovs.length; i++) {
                statusval += "<option value=" + loadResult.StatusLovs[i].LovId + ">" + loadResult.StatusLovs[i].FieldValue + "</option>"
            }
            $("#status").html(statusval);

            for (var i = 0; i < loadResult.OperatingDateLovs.length; i++) {
                OperatingDays += "<option value=" + loadResult.OperatingDateLovs[i].LovId + ">" + loadResult.OperatingDateLovs[i].FieldValue + "</option>"
            }
            $("#ODays").html(OperatingDays);

            for (var i = 0; i < loadResult.WorkingHoursLovs.length; i++) {
                WorkingHours += "<option value=" + loadResult.WorkingHoursLovs[i].LovId + ">" + loadResult.WorkingHoursLovs[i].FieldValue + "</option>"
            }
            $("#WHours").html(WorkingHours);

            for (var i = 0; i < loadResult.JIScheduleLovs.length; i++) {
                JIshedule += "<option value=" + loadResult.JIScheduleLovs[i].LovId + ">" + loadResult.JIScheduleLovs[i].FieldValue + "</option>"
            }
            $("#JIS").html(JIshedule);

            for (var i = 0; i < loadResult.PeriodicWorkLovs.length; i++) {
                PeriodicWork += "<option value=" + loadResult.PeriodicWorkLovs[i].LovId + ">" + loadResult.PeriodicWorkLovs[i].FieldValue + "</option>"
            }
            $("#ddlContainer").html(PeriodicWork);
            $("#ddlCeiling").html(PeriodicWork);
            $("#ddlLightsAir").html(PeriodicWork);
            $("#ddlFloorScrubbing").html(PeriodicWork);
            $("#ddlFloorPolishing").html(PeriodicWork);
            $("#ddlFloorBuffing").html(PeriodicWork);
            $("#ddlFloorCarpet").html(PeriodicWork);
            $("#ddlFloorCarpetShampooing").html(PeriodicWork);
            $("#ddlFloorHeatExtraction").html(PeriodicWork);
            $("#ddlWallWiping").html(PeriodicWork);
            $("#ddlWindowdDoor").html(PeriodicWork);
            $("#ddlPerimeterDrain").html(PeriodicWork);
            $("#ddlToiletDescaling").html(PeriodicWork);
            $("#ddlHighRiseNettting").html(PeriodicWork);
            $("#ddlExternalFacade").html(PeriodicWork);
            $("#ddlExternalHighGlass").html(PeriodicWork);
            $("#ddlInternetGlass").html(PeriodicWork);
            $("#ddlFlatRoof").html(PeriodicWork);
            $("#ddlStainlessSteel").html(PeriodicWork);
            $("#ddlExposeCeiling").html(PeriodicWork);
            $("#ddlLedgesDamp").html(PeriodicWork);
            $("#ddlSkylightDusting").html(PeriodicWork);
            $("#ddlSignagesWiping").html(PeriodicWork);
            $("#ddlDecksDusting").html(PeriodicWork);

           
            for (var i = 0; i < loadResult.ToiletTypeLovs.length; i++) {
                ToiletTypeValues += "<option value=" + loadResult.ToiletTypeLovs[i].LovId + ">" + loadResult.ToiletTypeLovs[i].FieldValue + "</option>"
            }

            for (var i = 0; i < loadResult.ToiletLovs.length; i++) {
                ToiletFrequencyValues += "<option value=" + loadResult.ToiletLovs[i].LovId + ">" + loadResult.ToiletLovs[i].FieldValue + "</option>"
            }

            for (var i = 0; i < loadResult.ToiletDetailsLovs.length; i++) {
                ToiletDetailsValues += "<option value=" + loadResult.ToiletDetailsLovs[i].LovId + ">" + loadResult.ToiletDetailsLovs[i].FieldValue + "</option>"
            }

            $("#txtType1").html(ToiletTypeValues);
            $("#ddlFrequency1").html(ToiletFrequencyValues);
            $("#ddlDetails1").html(ToiletDetailsValues);
           

            for (var i = 0; i < loadResult.VariationDetailsLovs.length; i++) {
                VariationValues += "<option value=" + loadResult.VariationDetailsLovs[i].LovId + ">" + loadResult.VariationDetailsLovs[i].FieldValue + "</option>"
            }
            $("#ddlVariation1").html(VariationValues);

            $('#myPleaseWait').modal('hide');
        })
        .fail(function (response) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            $('#errorMsgConfigAdditionalFields').css('visibility', 'visible');
        });

    //clicking on 2nd tab restrict
    $(".nav-tabs").click(function () {
        var primaryId = $('#primaryID').val();
        if (primaryId == 0 || primaryId == null || primaryId == undefined || primaryId == "" || primaryId == "0") {
            bootbox.alert(Messages.SAVE_FIRST_TABALERT);
            return false;
        }
        else {
            $('[id^=txtAreaCodeVariation]').val($('#txtUserAreaCode').val());
            $('[id^=txtAreaNameVariation]').val($('#txtUserAreaName').val());
            $('[id^=txtService]').val($('#txtEffectiveFromDate').val());
            $('[id^=txtSS]').val($('#txtEffectiveToDate').val());
        }

    });

    //AutoDisplay
    var UserAreaFetchObj = {
        SearchColumn: 'txtUserAreaCode-UserAreaCode',//Id of Fetch field
        ResultColumns: ["UserAreaId-Primary Key", 'UserAreaCode-UserAreaCode'],
        FieldsToBeFilled: ["hdnUserAreaId-UserAreaId", "txtUserAreaCode-UserAreaCode", "txtUserAreaName-UserAreaName", "txtEffectiveFromDate-ActiveFromDate", "txtEffectiveToDate-ActiveToDate"]
    };
    $('#txtUserAreaCode').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divUserAreaFetch', UserAreaFetchObj, "/api/Fetch/UserAreaFetch", "UlFetch1", event, 1);//1 -- pageIndex
    });


    var HospitalStaffFetchObj = {
        SearchColumn: 'txtHospitalRepresentative-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name'],//Columns to be displayed
        FieldsToBeFilled: ["hdnHospitalStaffId-StaffMasterId", "txtHospitalRepresentative-StaffName", "txtHospitalRepresentativeDesignation-Designation"]//id of element - the model property
    };
    $('#txtHospitalRepresentative').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch4', HospitalStaffFetchObj, "/api/Fetch/FacilityStaffFetch", "UlFetch4", event, 1);//1 -- pageIndex
    });

    var CompanyStaffFetchObj = {
        SearchColumn: 'txtCompanyRepresentative-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name'],//Columns to be displayed
        FieldsToBeFilled: ["hdnCompanyStaffId-StaffMasterId", "txtCompanyRepresentative-StaffName", "txtCompanyRepresentativeDesignation-Designation"]//id of element - the model property
    };
    $('#txtCompanyRepresentative').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch5', CompanyStaffFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch5", event, 1);//1 -- pageIndex
    });

    $("#btnSave, #btnSaveandAddNew").click(function () {

        var SelCus = $("#selCustomerLayout").val();
        var SelFacility = $("#selFacilityLayout").val(); 
        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");

        var isFormValid = formInputValidation("formDeptAreaDetails", 'save');

        if(!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');
               
        var primaryId = 0;
        if ($("#primaryID").val() != "" || $("#primaryID").val() != null) {
            primaryId = $("#primaryID").val();           
        }
        

        var obj = {
            CustomerId: SelCus,
            FacilityId: SelFacility,
            DeptAreaId: primaryId,
            UserAreaId: $("#hdnUserAreaId").val(),
            UserAreaCode: $('#txtUserAreaCode').val(),
            UserAreaName: $('#txtUserAreaName').val(),
            CategoryOfArea: $('#CArea').val(),
            Status: $('#status').val(),
            OperatingDays: $('#ODays').val(),
            WorkingHours: $('#WHours').val(),
            TotalReceptacles: $('#txtTotalReceptacles').val(),
            CleanableArea: $('#txtCleanableArea').val(),
            NoOfHandWashingFacilities: $('#txtNoofHandWashingFacilities').val(),
            NoOfBeds: $('#txtNoofBeds').val(),
            TotalNoOfUserLocations: $('#TotalNoofUserLocations').val(),
            HospitalRepresentative: $('#txtHospitalRepresentative').val(),
            HospitalRepresentativeDesignation: $('#txtHospitalRepresentativeDesignation').val(),
            CompanyRepresentative: $('#txtCompanyRepresentative').val(),
            CompanyRepresentativeDesignation: $('#txtCompanyRepresentativeDesignation').val(),
            EffectiveFromDate: $('#txtEffectiveFromDate').val(),
            EffectiveToDate: $('#txtEffectiveToDate').val(),
            JISchedule: $('#JIS').val(),
            Remarks: $('#txtRemarks').val(), 
            LocationCode: $('#lblLocationCode').val(),            
            LocationDetailsList: []
        }
        var i = 0;
        $("#tblDeptJI tbody tr").each(function () {
            var row = $(this);
            var tbl = {};            
            tbl.LocationId = row.children("td").find('[id^=hdnLocationId]')[0].value;
            tbl.LocationCode = row.children("td").find('[id^=lblLocationCode]')[0].innerText;
            tbl.Status = row.children("td").find("select").children("option:selected").val();
            tbl.Floor = row.children("td").find('input:checkbox[id^=CheckboxFloorActive]').prop("checked");
            tbl.Walls = row.children("td").find('input:checkbox[id^=CheckboxWallsActive]').prop("checked");
            tbl.Celling = row.children("td").find('input:checkbox[id^=CheckboxCellingActive]').prop("checked");
            tbl.WindowsDoors = row.children("td").find('input:checkbox[id^=CheckboxWDActive]').prop("checked");
            tbl.ReceptaclesContainers = row.children("td").find('input:checkbox[id^=CheckboxRCActive]').prop("checked");
            tbl.FurnitureFixtureEquipments = row.children("td").find('input:checkbox[id^=CheckboxFFEActive]').prop("checked");
            obj.LocationDetailsList.push(tbl);
            i++;
        });
       


        $.post("/Api/DeptAreaDetails/Save", obj, function (response) {

            $('#errorMsg').css('visibility', 'hidden');
            showMessage('Dept Area Details', CURD_MESSAGE_STATUS.SS);

            $('#txtUserAreaCode').attr('disabled', true);           
            $('#myPleaseWait').modal('hide');

            var result = JSON.parse(response);
            $('#primaryID').val(result.DeptAreaId);
            $('#DeptAreaIdHidden').val(result);

            if (CurrentbtnID == "btnSaveandAddNew") {
                showMessage('Dept Area Details', CURD_MESSAGE_STATUS.SS);
                EmptyFieldsDeptAreaDetails();                
                $('#table_data').show();
            }
        },"json")
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
                $('#myPleaseWait').modal('hide');
                $('#btnSave').attr('disabled', false);
            });
    });

    $("#btnFetch").click(function () {
        var deptVal = $('#hdnUserAreaId').val();

        var obj = {
            UserAreaId: deptVal
        }
        if (deptVal !== "") {

            $.post("/api/DeptAreaDetails/UserAreaCodeFetch", obj, function (response) {

                var result = JSON.parse(response);
                if (result.LocationDetailsList.length > 0) {
                    $('#table_data').hide();
                    var fetch = "";
                    $('#myDIV').html('');
                    for (var i = 0; i < result.LocationDetailsList.length; i++) {

                        var idNum = i + 1;

                        fetch = "<tr><td><input type='hidden' id='hdnLocationId" + idNum + "' value=" + result.LocationDetailsList[i].LocationId + " />"
                            + "<label id='lblLocationCode" + idNum + "' >" + result.LocationDetailsList[i].LocationCode + "</label></td>"
                            + "<td><select id='ddlStatus" + idNum + "'><option selected value = '1' > " + 'Active' + "</option>"
                            + " <option value = '0'>" + 'Inactive' + "</option> " + "</select ></td>"
                            + "<td><input type='checkbox' id=\'CheckboxFloorActive" + idNum + "\'></input></td>"
                            + "<td><input type='checkbox' id=\'CheckboxWallsActive" + idNum + "\'></input></td>"
                            + "<td><input type='checkbox' id=\'CheckboxCellingActive" + idNum + "\'></input></td>"
                            + "<td><input type='checkbox' id=\'CheckboxWDActive" + idNum + "\'></input></td>"
                            + "<td><input type='checkbox' id=\'CheckboxRCActive" + idNum + "\'></input></td>"
                            + "<td><input type='checkbox' id=\'CheckboxFFEActive" + idNum + "\'></input></td></tr>"


                        $("#myDIV").append(fetch);

                        $("#ddlStatus" + idNum).val(result.LocationDetailsList[i].Status);
                        $("#CheckboxFloorActive" + idNum).prop('checked', result.LocationDetailsList[i].Floor);
                        $("#CheckboxWallsActive" + idNum).prop('checked', result.LocationDetailsList[i].Walls);
                        $("#CheckboxCellingActive" + idNum).prop('checked', result.LocationDetailsList[i].Ceiling);
                        $("#CheckboxWDActive" + idNum).prop('checked', result.LocationDetailsList[i].WindowsDoors);
                        $("#CheckboxRCActive" + idNum).prop('checked', result.LocationDetailsList[i].ReceptaclesContainers);
                        $("#CheckboxFFEActive" + idNum).prop('checked', result.LocationDetailsList[i].FurnitureFixtureEquipments);  

                    }
                                        
                    $('#myDIV').find("select").addClass("form-control");
                    $('#TotalNoofUserLocations').val(result.LocationDetailsList.length);
                }
                else {
                    $('#table_data').show();
                }

            },
                "json")
                .fail(function (response) {
                    $('#myPleaseWait').modal('hide');
                    $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
                    $('#errorMsg').css('visibility', 'visible');
                });
        }
        else {
            bootbox.alert("Please select  User Area Code");
        }
    });

    $("#btnCancel").click(function () {

        bootbox.confirm({
            message: Messages.Reset_Alert_CONFIRMATION,
            buttons: {
                confirm: {
                    label: 'yes',
                    classname: 'btn-primary'
                },
                cancel: {
                    label: 'No',
                    classname: 'btn-default'
                }
            },
            callback: function (result) {
                if (result) {
                    EmptyFieldsDeptAreaDetails();                    
                    $('#table_data').show();
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }

            }
        });

    });

    function EmptyFieldsDeptAreaDetails() {

        $('#primaryID').val(0);
        $('#formDeptAreaDetails')[0].reset();
        $('#errorMsg').css('visibility', 'hidden');
        $('#txtUserAreaCode').attr('disabled', false);
        $('#myDIV').html('');
        $('#Dept').html('');
        $('#Areacode').removeClass('has-error');
        $('#CategoryArea').removeClass('has-error');
        $('#OD').removeClass('has-error');
        $('#CA').removeClass('has-error');
        $('#HWF').removeClass('has-error');
        $('#HR').removeClass('has-error');
        $('#CR').removeClass('has-error');
        $('#JI').removeClass('has-error');
    }

    //#endregion Dept Area Details ------------------------------------------------------------
    
    //#region remove errors  ----------------------------------------------------------------

    //$('#txtUserAreaCode').keypress(function () {

    //    $('#Areacode').removeClass('has-error');
    //});

    //$('#CArea').on('change', function () {

    //    $('#CategoryArea').removeClass('has-error');
    //});

    //$('#ODays').on('change', function () {

    //    $('#OD').removeClass('has-error');
    //});

    //$('#txtCleanableArea').keypress(function () {

    //    $('#CA').removeClass('has-error');
    //});

    //$('#txtNoofHandWashingFacilities').keypress(function () {

    //    $('#HWF').removeClass('has-error');
    //});

    //$('#txtHospitalRepresentative').keypress(function () {

    //    $('#HR').removeClass('has-error');
    //});

    //$('#txtCompanyRepresentative').keypress(function () {

    //    $('#CR').removeClass('has-error');
    //});

    //$('#JIS').on('change', function () {

    //    $('#JI').removeClass('has-error');
    //});

    
    //#endregion  remove error -----------------------------------------------------------------------
    
    //#region Receptacles ----------------------------------------------------------------------

    $("#btnSaveRece").click(function () {

        var deptVal = $('#hdnUserAreaId').val();

        if (deptVal !== "") {
        }
        else {
            bootbox.alert("Please select User Area Code");
            return false;
        }

        var primaryId = 0;
        if ($("#primaryID").val() != "" || $("#primaryID").val() != null) {
            primaryId = $("#primaryID").val();
        }

        var obj = {
            DeptAreaId: primaryId,
            UserAreaId: $('#hdnUserAreaId').val(),
            Bin660L: $('#txtBin660L').val(),
            Bin240L: $('#txtBin240L').val(),
            WastePaperBasket: $('#txtWastePaperBucket').val(),
            PedalBin: $('#txtPedalBin').val(),
            BedsideBin: $('#txtBedsideBin').val(),
            FilpFlop: $('#txtFlipFlopSwingTopBin').val(),
            FoodBin: $('#txtFoodBin').val()
        }


        var jqxhr = $.post("/Api/DeptAreaDetails/SaveRecp", obj, function (response) {

            $('#errorMsgRece').css('visibility', 'hidden');
            var result = JSON.parse(response);

            if (result != null) {
                showMessage('Receptacles', CURD_MESSAGE_STATUS.SS);
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
                $('#errorMsg').css('visibility', 'visible');

            });

    })

    $("#btnCancelRece").click(function () {
        bootbox.confirm({
            message: Messages.Reset_Alert_CONFIRMATION,
            buttons: {
                confirm: {
                    label: 'yes',
                    classname: 'btn-primary'
                },
                cancel: {
                    label: 'No',
                    classname: 'btn-default'
                }
            },
            callback: function (result) {
                if (result) {
                    EmptyFieldsRece();
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            }
        });
    });

    function EmptyFieldsRece() {

        $('#errorMsgRece').css('visibility', 'hidden');
        $('#Rece').html('');
        $(".content").scrollTop(0);
        $("#txtBin660L").val('');
        $("#txtBin240L").val('');
        $("#txtWastePaperBucket").val('');
        $("#txtPedalBin").val('');
        $("#txtBedsideBin").val('');
        $("#txtFlipFlopSwingTopBin").val('');
        $("#txtFoodBin").val('');
    }

    //#endregion  Receptacles --------------------------------------------------------------


    //#region Daily Cleaning Schedule -----------------------------------------------------------

    $("#btnSaveDCS").click(function () {
        var deptVal = $('#hdnUserAreaId').val();

        if (deptVal !== "") {
        }
        else {
            bootbox.alert("Please select  User Area Code");
            return false;
        }
       

        var obj = {
            DeptAreaId: $("#primaryID").val(),
            UserAreaId: $('#hdnUserAreaId').val(),
            Dustmop: $('#txtDustMop').val(),
            Dampmop: $('#txtDampMop').val(),
            Vacuum: $('#txtVacuum').val(),
            Washing: $('#txtWashing').val(),
            Sweeping: $('#txtSweeping').val(),
            Wiping: $('#txtWiping').val(),
            Washing1: $('#txtWashing1').val(),
            PaperHandTowel: $('#txtPHT').val(),
            ToiletJumbo: $('#txtTJR').val(),
            HandSoap: $('#txtHS').val(),
            Deodorisers: $('#txtDeodorisers').val(),
            DomesticWasteCollection: $('#txtDWC').val()
        }

        var jqxhr = $.post(" /Api/DeptAreaDetails/SaveDailyClean", obj, function (response) {
            $('#errorMsgDCS').css('visibility', 'hidden');
            var result = JSON.parse(response);
            showMessage('Daily Cleaning Schedule', CURD_MESSAGE_STATUS.SS);
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

            });

    });

    $("#btnCancelDCS").click(function () {
        bootbox.confirm({
            message: Messages.Reset_Alert_CONFIRMATION,
            buttons: {
                confirm: {
                    label: 'yes',
                    classname: 'btn-primary'
                },
                cancel: {
                    label: 'No',
                    classname: 'btn-default'
                }
            },
            callback: function (result) {
                if (result) {
                    EmptyFieldsDCS();
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }

            }
        });
    });

    function EmptyFieldsDCS() {
        // $('#formDeptAreaDetailsDCS')[0].reset();
        $('#errorMsgDCS').css('visibility', 'hidden');
        $('#DCS').html('');
        $(".content").scrollTop(0);
        $("#txtDustMop").val('');
        $("#txtDampMop").val('');
        $("#txtVacuum").val('');
        $("#txtWashing").val('');
        $("#txtSweeping").val('');
        $("#txtWiping").val('');
        $("#txtWashing1").val('');
        $("#txtPHT").val('');
        $("#txtTJR").val('');
        $("#txtHS").val('');
        $("#txtDeodorisers").val('');
        $("#txtDWC").val('');
    }

    //#endregion  Daily Cleaning Schedule ----------------------------------------------------


    //#region Periodic Work Schedule -----------------------------------------------------------

    $("#btnSavePWS").click(function () {
        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsgPWS').css('visibility', 'hidden');

        var isFormValid = formInputValidation("formDeptAreaDetailsPWS", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsgPWS').css('visibility', 'visible');
            return false;
        }

        var obj = {
            DeptAreaId: $("#primaryID").val(),
            UserAreaId: $('#hdnUserAreaId').val(),
            ContainerReceptaclesWashing: $('#ddlContainer').val(),
            CeilingHighDusting: $('#ddlCeiling').val(),
            LightsAirCondOutletFanWiping: $('#ddlLightsAir').val(),
            FloorNonPolishableScrubbing: $('#ddlFloorScrubbing').val(),
            FloorPolishablePolishing: $('#ddlFloorPolishing').val(),
            FloorPolishableBuffing: $('#ddlFloorBuffing').val(),
            FloorCarpetBonnetBuffing: $('#ddlFloorCarpet').val(),
            FloorCarpetShampooing: $('#ddlFloorCarpetShampooing').val(),
            FloorCarpetHeatSteamExtraction: $('#ddlFloorHeatExtraction').val(),
            WallWiping: $('#ddlWallWiping').val(),
            WindowDoorWiping: $('#ddlWindowdDoor').val(),
            PerimeterDrainWashScrub: $('#ddlPerimeterDrain').val(),
            ToiletDescaling: $('#ddlToiletDescaling').val(),
            HighRiseNetttingHighDusting: $('#ddlHighRiseNettting').val(),
            ExternalFacadeCleaning: $('#ddlExternalFacade').val(),
            ExternalHighLevelGlassCleaning: $('#ddlExternalHighGlass').val(),
            InternetGlass: $('#ddlInternetGlass').val(),
            FlatRoofWashScrub: $('#ddlFlatRoof').val(),
            StainlessSteelPolishing: $('#ddlStainlessSteel').val(),
            ExposeCeilingTruss: $('#ddlExposeCeiling').val(),
            LedgesDampWipe: $('#ddlLedgesDamp').val(),
            SkylightHighDusting: $('#ddlSkylightDusting').val(),
            SignagesWiping: $('#ddlSignagesWiping').val(),
            DecksHighDusting: $('#ddlDecksDusting').val()
        }

        var jqxhr = $.post("/Api/DeptAreaDetails/SavePeriodicWork", obj, function (response) {
            $('#errorMsgPWS').css('visibility', 'hidden');
            showMessage('Periodic Work Schedule', CURD_MESSAGE_STATUS.SS);
            var result = JSON.parse(response);
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
                $('#errorMsgPWS').css('visibility', 'visible');

                $('#btnSavePWS').attr('disabled', false);
            });

    });

    $("#btnCancelPWS").click(function () {

        //  var message = Messages.Reset_Alert_CONFIRMATION;

        bootbox.confirm({
            message: Messages.Reset_Alert_CONFIRMATION,
            buttons: {
                confirm: {
                    label: 'yes',
                    classname: 'btn-primary'
                },
                cancel: {
                    label: 'No',
                    classname: 'btn-default'
                }
            },
            callback: function (result) {
                if (result) {
                    EmptyFieldsPWS();
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }

            }
        });
    });

    function EmptyFieldsPWS() {

        $('#errorMsgPWS').css('visibility', 'hidden');
        //$('#formDeptAreaDetailsPWS')[0].reset();
        $(".content").scrollTop(0);
        $('#ddlContainer').val('');
        $('#ddlCeiling').val('');
        $('#ddlFloorScrubbing').val('');
        $('#ddlLightsAir').val('');
        $('#ddlFloorPolishing').val('');
        $('#ddlFloorBuffing').val('');
        $('#ddlFloorCarpet').val('');
        $('#ddlFloorCarpetShampooing').val('');
        $('#ddlFloorHeatExtraction').val('');
        $('#ddlWallWiping').val('');
        $('#ddlWindowdDoor').val('');
        $('#ddlPerimeterDrain').val('');
        $('#ddlToiletDescaling').val('');
        $('#ddlHighRiseNettting').val('');
        $('#ddlExternalFacade').val('');
        $('#ddlExternalHighGlass').val('');
        $('#ddlInternetGlass').val('');
        $('#ddlFlatRoof').val('');
        $('#ddlStainlessSteel').val('');
        $('#ddlExposeCeiling').val('');
        $('#ddlLedgesDamp').val('');
        $('#ddlSkylightDusting').val('');
        $('#ddlSignagesWiping').val('');
        $('#ddlDecksDusting').val('');
    }

    //#endregion Periodic Work Schedule ----------------------------------------------------


    //#region Toilets -----------------------------------------------------------------------------

    $(body).on('input propertychange paste keyup', '.receptacles', function (event) {

        var totalReceptacles = 0;
        var controlValue = 0;
        $('.receptacles').each(function () {

            if (isNaN(parseInt($(this).val()))) {
                controlValue = 0;
            }
            else {
                controlValue = parseInt($(this).val());
            }
            
            totalReceptacles += controlValue;
        });
       
        $('#txtTotalReceptacles').val(totalReceptacles);
       
    });

    $(body).on('input propertychange paste keyup', '.cssLocationCode', function (event) {
        var controlId = event.target.id;
        var id = controlId.slice(15, 17);

        var UserAreaFetchObj = {
            SearchColumn: 'txtLocationCode' + id + '-UserLocationCode', //Id of Fetch field
            ResultColumns: ['UserLocationId-Primary Key', 'UserLocationCode-UserLocationCode'],
            FieldsToBeFilled: ['hdnLocationCodeId' + id + '-UserLocationId', 'txtLocationCode' + id + '-UserLocationCode'],
            AdditionalConditions: ['UserAreaId-hdnUserAreaId']
        };

        DisplayFetchResult('divUserAreaFetchT' + id, UserAreaFetchObj, "/Api/CLSFetch/LocationCodeFetch", 'UlFetchT' + id, event, 1); //1 -- pageIndex
    });

        
    $("#addToiletRow").click(function () {

        rowNum1 = rowNum1 + 1;

        addToiletRow(rowNum1);

    });

    $("#btnSaveToilet").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg1').css('visibility', 'hidden');


        var isFormValid = formInputValidation("formDeptAreaDetailsToilet", 'save');

        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg1').css('visibility', 'visible');

            return false;
        }
        
        
        var _lsttoilets = [];     
        var _DuplicateLocations = [];
        var _isDuplicates = 0;

        $("#AssetEquipmentAttachmentT tbody tr").each(function () {

            if (_DuplicateLocations.indexOf($(this).find("[id^=txtLocationCode]")[0].value) == -1)
                _DuplicateLocations.push($(this).find("[id^=txtLocationCode]")[0].value);
            else {
                _isDuplicates += 1;
            }
        });

        if (_isDuplicates > 0) {
            bootbox.alert("Duplicate Location Codes");         
            return false;
        }
        else {

            $("#AssetEquipmentAttachmentT tbody tr").each(function () {

                var tbl = {
                    "DeptAreaId": $("#primaryID").val(),
                    "UserAreaId": $('#hdnUserAreaId').val(),
                    "LocationId": $(this).find("[id^=hdnLocationCodeId]")[0].value,
                    "LocationCode": $(this).find("[id^=txtLocationCode]")[0].value,
                    "Type": $(this).find("[id^=txtType]")[0].value,
                    "Frequency": $(this).find("[id^=ddlFrequency]")[0].value,
                    "Details": $(this).find("[id^=ddlDetails]")[0].value,
                    "Mirror": $(this).find('input:checkbox[id^=CheckboxM]').prop("checked"),
                    "Floor": $(this).find('input:checkbox[id^=CheckboxF]').prop("checked"),
                    "Wall": $(this).find('input:checkbox[id^=CheckboxW]').prop("checked"),
                    "Urinal": $(this).find('input:checkbox[id^=CheckboxU]').prop("checked"),
                    "Bowl": $(this).find('input:checkbox[id^=CheckboxBW]').prop("checked"),
                    "Basin": $(this).find('input:checkbox[id^=CheckboxBS]').prop("checked"),
                    "ToiletRoll": $(this).find('input:checkbox[id^=CheckboxTR]').prop("checked"),
                    "SoapDispenser": $(this).find('input:checkbox[id^=CheckboxSP]').prop("checked"),
                    "AutoAirFreshner": $(this).find('input:checkbox[id^=CheckboxAA]').prop("checked"),
                    "Waste": $(this).find('input:checkbox[id^=CheckboxWaste]').prop("checked"),
                    "isDeleted": $(this).find('input:checkbox[id^=isDelete]').prop("checked")
                };

                _lsttoilets.push(tbl);

            });

            $.ajax({
                url: "/api/DeptAreaDetails/SaveToilet",
                type: 'POST',
                data: JSON.stringify(_lsttoilets),
                dataType: 'json',
                contentType: 'application/json',
                crossDomain: true,
                cache: false,
                success: function (response) {

                    $('#errorMsg1').css('visibility', 'hidden');
                    showMessage('Toilet', CURD_MESSAGE_STATUS.SS);
                    var result = JSON.parse(response);

                    fillToilets(result);
                },
                fail: function (response) {
                    var errorMessage = "";
                    if (response.status == 400) {
                        errorMessage = response.responseJSON;
                    }
                    else {
                        errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
                    }
                    $("div.errormsgcenter").text(errorMessage);
                    $('#errorMsg1').css('visibility', 'visible');

                    $('#btnSave1').attr('disabled', false);
                }

            });

        }
        
       
      
    });

    $("#btnCancelToilet").click(function () {

        bootbox.confirm({
            message: Messages.Reset_Alert_CONFIRMATION,
            buttons: {
                confirm: {
                    label: 'yes',
                    classname: 'btn-primary'
                },
                cancel: {
                    label: 'No',
                    classname: 'btn-default'
                }
            },
            callback: function (result) {
                if (result) {
                    EmptyFieldsToilet();
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }

            }
        });

    });

   

    $("#deleteToilets").click(function () {
        bootbox.confirm({
            message: 'Do you want to delete a row?',
            buttons: {
                confirm: {
                    label: 'Yes',
                    className: 'btn-primary'
                },
                cancel: {
                    label: 'No',
                    className: 'btn-default'
                }
            },
            callback: function (result) {
                if (result) {
                    if ($("input[type='checkbox']:checked").length > 0) {
                        $("#tbodyToilet tr").find('input[name="isDelete"]').each(function () {
                            if ($(this).is(":checked")) {
                                if ($(this).closest("tr").find("[id^=toiletId]").val() == 0) {
                                    $(this).closest("tr").remove();
                                }
                            }
                        });
                    }
                    else
                        bootbox.alert("Please select atleast one row !");
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            }
        });
    });
    function EmptyFieldsToilet() {

        $('#formDeptAreaDetailsToilet')[0].reset();
        $('#errorMsg1').css('visibility', 'hidden');
        
    }

    //#endregion Toilets ----------------------------------------------------


    //#region Dispenser ---------------------------------------------------------------------------

    $("#btnSaveDis").click(function () {
        var deptVal = $('#hdnUserAreaId').val();
        if (deptVal !== "") {
        }
        else {
            bootbox.alert("Please select  User Area Code");
            return false;
        }

        var obj =
        {
            DeptAreaId: $("#primaryID").val(),
            UserAreaId: $('#hdnUserAreaId').val(),
            HandPaperTowel: $('#txtHPT').val(),
            JumboRollToiletRoll: $('#txtJR').val(),
            HandSoapLiquidSoapDispenser: $('#txtHS1').val(),
            Deodorant: $('#txtD').val(),
            FootPumpNonContactTypeDispenser: $('#txtFP').val(),
            HandDryers: $('#txtHD').val(),
            AutoTimerDeodorizerAirFreshenerDispenser: $('#txtAT').val()
        }

        var jqxhr = $.post("/Api/DeptAreaDetails/SaveDispenser", obj, function (response) {
            $('#errorMsgDis').css('visibility', 'hidden');
            var result = JSON.parse(response);

            showMessage('Dispenser', CURD_MESSAGE_STATUS.SS);

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

            });
    });

    $("#btnCancelDis").click(function () {

        //  var message = Messages.Reset_Alert_CONFIRMATION;

        bootbox.confirm({
            message: Messages.Reset_Alert_CONFIRMATION,
            buttons: {
                confirm: {
                    label: 'yes',
                    classname: 'btn-primary'
                },
                cancel: {
                    label: 'No',
                    classname: 'btn-default'
                }
            },
            callback: function (result) {
                if (result) {
                    EmptyFieldsDispenser();
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }

            }
        });
    });

   

    function EmptyFieldsDispenser() {
        $('#formDeptAreaDetailsDispenser')[0].reset();
        $('#errorMsgDis').css('visibility', 'hidden');
        $('#Dis').html('');
    }



    //#endregion Dispenser ---------------------------------------------------------


    //#region Variation -------------------------------------------------------------------   
    

    //$(body).on('input propertychange paste keyup', '.cssAreaCodeVariation', function (event) {
    //    var controlId = event.target.id;
    //    var id = controlId.slice(20, 21);

    //    var UserAreaFetchObj4 = {
    //        SearchColumn: 'txtAreaCodeVariation' + id + '-UserAreaCode',//Id of Fetch field
    //        ResultColumns: ['UserAreaId-Primary Key', 'UserAreaCode-UserAreaCode'],
    //        FieldsToBeFilled: ['hdnAreaCodeId' + id + '-UserAreaId', 'txtAreaCodeVariation' + id + '-UserAreaCode', 'txtAreaNameVariation' + id + '-UserAreaName']
    //    };

    //    DisplayFetchResult('divFetchVar' + id, UserAreaFetchObj4, "/Api/Fetch/UserAreaFetch", 'UlFetchVer' + id, event, 1); //1 -- pageIndex
    //});

    //$(body).on('input propertychange paste keyup', '.cssReferenceNoVariation', function (event) {
    //    var controlId = event.target.id;
    //    var id = controlId.slice(12, 13);

    //    var ReferenceNoObj = {
    //        SearchColumn: 'txtReference' + id + '-SNFDocNo',//Id of Fetch field
    //        ResultColumns: ['AssetId-Primary Key', 'SNFDocNo-SNFDocNo'],
    //        FieldsToBeFilled: ['hdnReferenceNo' + id + '-AssetId', 'txtReference' + id + '-SNFDocNo', 'txtCommisioning' + id + '-CommissioningDate', 'txtService' + id + '-StartServiceDate', 'txtWarranty' + id + '-WarrantyEndDate', 'txtVD' + id + '-VariationDate', 'txtSS' + id +'-StopServiceDate' ]
    //    };

    //    DisplayFetchResult('divFetchRef' + id, ReferenceNoObj, "/Api/Fetch/FetchSNFDetails", 'UlFetchRef' + id, event, 1); //1 -- pageIndex
    //});


    $("#btnSaveVar").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsgDis').css('visibility', 'hidden');

        var isFormValid = formInputValidation("formDeptAreaDetailsVariationDetails", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsgVariation').css('visibility', 'visible');
            return false;
        }
        
        var _lstVariationDetails = [];
        var _DuplicateAreas = [];
        var _isDuplicates = 0;

        $("#AssetEquipmentAttachmentVar tbody tr").each(function () {

            if (_DuplicateAreas.indexOf($(this).find("[id^=txtAreaCodeVariation]")[0].value) == -1)
                _DuplicateAreas.push($(this).find("[id^=txtAreaCodeVariation]")[0].value);
            else {
                _isDuplicates += 1;
            }
        });

        if (_isDuplicates > 0) {
            bootbox.alert("Duplicate Area Codes");
            return false;
        }
        else {
            $("#AssetEquipmentAttachmentVar tbody tr").each(function () {
                var tbl = {
                    //"VariationDetailsId": $(this).find("[id^=hdnLocationCodeVariationId]")[0].value,
                    "DeptAreaId": $("#primaryID").val(),
                    "UserAreaId": $("#hdnUserAreaId").val(),
                    "AreaCode": $(this).find("[id^=txtAreaCodeVariation]")[0].value,
                    "AreaName": $(this).find("[id^=txtAreaNameVariation]")[0].value,
                    "SNFReference": $(this).find("[id^=txtReference]")[0].value,
                    "VariationStatus": $(this).find("[id^=ddlVariation]")[0].value,
                    "Sqft": $(this).find("[id^=txtSq]")[0].value,
                    "Price": $(this).find("[id^=txtPrice]")[0].value,
                    "CommissioningDate": $(this).find("[id^=txtCommisioning]")[0].value,
                    "ServiceStartDate": $(this).find("[id^=txtService]")[0].value,
                    "WarrantyEndDate": $(this).find("[id^=txtWarranty]")[0].value,
                    "VariationDate": $(this).find("[id^=txtVD]")[0].value,
                    "ServiceStopDate": $(this).find("[id^=txtSS]")[0].value,
                    "isDeleted": $(this).find('input:checkbox[id^=isDelete]').prop("checked")
                };
                _lstVariationDetails.push(tbl);

            });
            $.ajax({
                url: "/api/DeptAreaDetails/SaveVariationDetails",
                type: 'POST',
                data: JSON.stringify(_lstVariationDetails),
                dataType: 'json',
                contentType: 'application/json',
                crossDomain: true,
                cache: false,
                success: function (response) {
                    $('#errorMsg1').css('visibility', 'hidden');
                    showMessage('Toilet', CURD_MESSAGE_STATUS.SS);
                    var result = JSON.parse(response);

                    fillVariationDetails(result);

                },
                fail: function (response) {
                    var errorMessage = "";
                    if (response.status == 400) {
                        errorMessage = response.responseJSON;
                    }
                    else {
                        errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
                    }
                    $("div.errormsgcenter").text(errorMessage);
                    $('#errorMsg1').css('visibility', 'visible');

                    $('#btnSave1').attr('disabled', false);
                }
            });
        }
        
    });


    

    $("#addVar").click(function () {
        rowNum2 = rowNum2 + 1;
        addVariation(rowNum2);    
    });
    

    $("#deleteVar").click(function () {
        bootbox.confirm({
            message: 'Do you want to delete a row?',
            buttons: {
                confirm: {
                    label: 'Yes',
                    className: 'btn-primary'
                },
                cancel: {
                    label: 'No',
                    className: 'btn-default'
                }
            },
            callback: function (result) {
                if (result) {
                    if ($("input[type='checkbox']:checked").length > 0) {
                        $("#tbodyVariation tr").find('input[name="isDelete"]').each(function () {
                            if ($(this).is(":checked")) {
                                if ($(this).closest("tr").find("[id^=hdnLocationCodeVariationId]").val() == 0) {
                                    $(this).closest("tr").remove();
                                }
                            }
                        });
                    }
                    else
                        bootbox.alert("Please select atleast one row !");
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            }
        });
    });

    $("#btnCancelVar").click(function () {
        bootbox.confirm({
            message: Messages.Reset_Alert_CONFIRMATION,
            buttons: {
                confirm: {
                    label: 'yes',
                    classname: 'btn-primary'
                },
                cancel: {
                    label: 'No',
                    classname: 'btn-default'
                }
            },
            callback: function (result) {
                if (result) {
                    EmptyFieldsVariationDetails();
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }

            }
        });
    });
    

    $('#txtCommisioning').datetimepicker({
        timepicker: false,
        format: 'm/d/Y'
    });


    function EmptyFieldsVariationDetails() {

        $("#AssetEquipmentAttachmentVar tbody").find('input[name="recordVariation"]').each(function () {
            $(this).closest("tr").remove();
        });

        $('#formDeptAreaDetailsVariationDetails')[0].reset();
        $('#errorMsgVariation').css('visibility', 'hidden');
       
    }

    //#endregion Variation -----------------------------------------------------------  

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
    if (ID == null || ID == undefined || ID == 0 || ID == '' || ID == "") {
        $("#jQGridCollapse1").click();
    }
    else {
        LinkClicked(ID);
    }

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

function LinkClicked(id) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formBemsBlock :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(id);
    //$('#hdnUserAreaId').val(id);
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
        $("#formBemsBlock :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        //$('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryID = $('#primaryID').val();

    if (primaryID != null && primaryID != "0") {

        $.get("/api/DeptAreaDetails/Get/" + id)
            .done(function (result) {
            var getResult = JSON.parse(result);

            /** Dept Area details **/
            //$('#primaryID').val(getResult.DeptAreaId);              
            //$('#selCustomerLayout').val(getResult.CustomerId);
            //$('#selFacilityLayout').val(getResult.FacilityId);

            $('#txtUserAreaCode').attr('disabled', true);

             $('#hdnUserAreaId').val(getResult.UserAreaId);
            $('#txtUserAreaCode').val(getResult.UserAreaCode);
            $('#txtUserAreaName').val(getResult.UserAreaName);
            $('#CArea').val(getResult.CategoryOfArea);
            $('#status').val(getResult.Status);
            $('#ODays').val(getResult.OperatingDays);
            $('#WHours').val(getResult.WorkingHours);
            $('#txtTotalReceptacles').val(getResult.TotalReceptacles);
            $('#txtCleanableArea').val(getResult.CleanableArea);
            $('#txtNoofHandWashingFacilities').val(getResult.NoOfHandWashingFacilities);
            $('#txtNoofBeds').val(getResult.NoOfBeds);
            $('#TotalNoofUserLocations').val(getResult.TotalNoOfUserLocations);
            $('#txtHospitalRepresentative').val(getResult.HospitalRepresentative);
            $('#txtHospitalRepresentativeDesignation').val(getResult.HospitalRepresentativeDesignation);
            $('#txtCompanyRepresentative').val(getResult.CompanyRepresentative);
            $('#txtCompanyRepresentativeDesignation').val(getResult.CompanyRepresentativeDesignation);
            var EffectiveFromDate = getCustomDate(getResult.EffectiveFromDate);
            var EffectiveToDate = getCustomDate(getResult.EffectiveToDate);
            $('#txtEffectiveFromDate').val(EffectiveFromDate);
            $('#txtEffectiveToDate').val(EffectiveToDate);

            $('#JIS').val(getResult.JISchedule);
                $('#txtRemarks').val(getResult.Remarks);
                $('#table_data').hide();
            /** Location details **/

                $('#myDIV').html('');

                if (getResult.LocationDetailsList != null) {

                    var fetch = "";

                    for (i = 0; i < getResult.LocationDetailsList.length; i++) {

                        //var StatusActiveSelected = "", StatusInActiveSelected = "";
                        //StatusActiveSelected = getResult.LocationDetailsList[i].Status == "1" ? "selected" : "";
                        //StatusInActiveSelected = getResult.LocationDetailsList[i].Status == "0" ? "selected" : "";                       
                        var idNum = i + 1;

                        fetch = "<tr><td><input type='hidden' id='hdnLocationId" + idNum + "' value=" + getResult.LocationDetailsList[i].LocationId + " />"
                            + "<label id='lblLocationCode" + idNum + "' >" + getResult.LocationDetailsList[i].LocationCode + "</label></td>"
                            + "<td><select id='ddlStatus" + idNum + "'><option value='1' >Active</option>"
                            + " <option value='0'>Inactive</option></select ></td>"
                            + "<td><input type='checkbox'  id=\'CheckboxFloorActive" + idNum + "\'></input></td>"
                            + "<td><input type='checkbox'  id=\'CheckboxWallsActive" + idNum + "\'></input></td>"
                            + "<td><input type='checkbox' id=\'CheckboxCellingActive" + idNum + "\'></input></td>"
                            + "<td><input type='checkbox' id=\'CheckboxWDActive" + idNum + "\'></input></td>"
                            + "<td><input type='checkbox' id=\'CheckboxRCActive" + idNum + "\'></input></td>"
                            + "<td><input type='checkbox' id=\'CheckboxFFEActive" + idNum + "\'></input></td></tr>"   

                        $("#myDIV").append(fetch);

                        $("#ddlStatus" + idNum).val(getResult.LocationDetailsList[i].Status);
                        $("#CheckboxFloorActive" + idNum).prop('checked', getResult.LocationDetailsList[i].Floor);
                        $("#CheckboxWallsActive" + idNum).prop('checked', getResult.LocationDetailsList[i].Walls);
                        $("#CheckboxCellingActive" + idNum).prop('checked', getResult.LocationDetailsList[i].Celling);
                        $("#CheckboxWDActive" + idNum).prop('checked', getResult.LocationDetailsList[i].WindowsDoors);
                        $("#CheckboxRCActive" + idNum).prop('checked', getResult.LocationDetailsList[i].ReceptaclesContainers);
                        $("#CheckboxFFEActive" + idNum).prop('checked', getResult.LocationDetailsList[i].FurnitureFixtureEquipments);      

                    }

                    $('#myDIV').find("select").addClass("form-control");
                    
                }

            /** Recepticals details **/

                if (getResult.receptacles != null) {

                    $('#txtBin660L').val(getResult.receptacles.Bin660L);
                    $('#txtBin240L').val(getResult.receptacles.Bin240L);
                    $('#txtWastePaperBucket').val(getResult.receptacles.WastePaperBasket);
                    $('#txtPedalBin').val(getResult.receptacles.PedalBin);
                    $('#txtBedsideBin').val(getResult.receptacles.BedsideBin);
                    $('#txtFlipFlopSwingTopBin').val(getResult.receptacles.FilpFlop);
                    $('#txtFoodBin').val(getResult.receptacles.FoodBin);
                }
                else {
                    $('#txtBin660L').val('');
                    $('#txtBin240L').val('');
                    $('#txtWastePaperBucket').val('');
                    $('#txtPedalBin').val('');
                    $('#txtBedsideBin').val('');
                    $('#txtFlipFlopSwingTopBin').val('');
                    $('#txtFoodBin').val('');
                }

            /** Daily Cleaning details **/

                if (getResult.dailyCleaningSchedule != null) {

                    $('#txtDustMop').val(getResult.dailyCleaningSchedule.Dustmop);
                    $('#txtDampMop').val(getResult.dailyCleaningSchedule.Dampmop);
                    $('#txtVacuum').val(getResult.dailyCleaningSchedule.Vacuum);
                    $('#txtWashing').val(getResult.dailyCleaningSchedule.Washing);
                    $('#txtSweeping').val(getResult.dailyCleaningSchedule.Sweeping);
                    $('#txtWiping').val(getResult.dailyCleaningSchedule.Wiping);
                    $('#txtPHT').val(getResult.dailyCleaningSchedule.PaperHandTowel);
                    $('#txtTJR').val(getResult.dailyCleaningSchedule.ToiletJumbo);
                    $('#txtHS').val(getResult.dailyCleaningSchedule.HandSoap);
                    $('#txtDeodorisers').val(getResult.dailyCleaningSchedule.Deodorisers);
                    $('#txtDWC').val(getResult.dailyCleaningSchedule.DomesticWasteCollection);
                }
                else {
                    $('#txtDustMop').val('');
                    $('#txtDampMop').val('');
                    $('#txtVacuum').val('');
                    $('#txtWashing').val('');
                    $('#txtSweeping').val('');
                    $('#txtWiping').val('');
                    $('#txtPHT').val('');
                    $('#txtTJR').val('');
                    $('#txtHS').val('');
                    $('#txtDeodorisers').val('');
                    $('#txtDWC').val('');
                }

            /** Periodic Work Shedule details **/

                if (getResult.periodicWorkSchedule != null) {

                    $('#ddlContainer').val(getResult.periodicWorkSchedule.ContainerReceptaclesWashing);
                    $('#ddlCeiling').val(getResult.periodicWorkSchedule.CeilingHighDusting);
                    $('#ddlLightsAir').val(getResult.periodicWorkSchedule.LightsAirCondOutletFanWiping);
                    $('#ddlFloorScrubbing').val(getResult.periodicWorkSchedule.FloorPolishableBuffing);
                    $('#ddlFloorPolishing').val(getResult.periodicWorkSchedule.FloorPolishablePolishing);
                    $('#ddlFloorBuffing').val(getResult.periodicWorkSchedule.FloorPolishableBuffing);
                    $('#ddlFloorCarpet').val(getResult.periodicWorkSchedule.FloorCarpetBonnetBuffing);
                    $('#ddlFloorCarpetShampooing').val(getResult.periodicWorkSchedule.FloorCarpetShampooing);
                    $('#ddlFloorHeatExtraction').val(getResult.periodicWorkSchedule.FloorCarpetHeatSteamExtraction);
                    $('#ddlWallWiping').val(getResult.periodicWorkSchedule.WallWiping);
                    $('#ddlWindowdDoor').val(getResult.periodicWorkSchedule.WindowDoorWiping);
                    $('#ddlPerimeterDrain').val(getResult.periodicWorkSchedule.PerimeterDrainWashScrub);
                    $('#ddlToiletDescaling').val(getResult.periodicWorkSchedule.ToiletDescaling);
                    $('#ddlHighRiseNettting').val(getResult.periodicWorkSchedule.HighRiseNetttingHighDusting);
                    $('#ddlExternalFacade').val(getResult.periodicWorkSchedule.ExternalFacadeCleaning);
                    $('#ddlExternalHighGlass').val(getResult.periodicWorkSchedule.ExternalHighLevelGlassCleaning);
                    $('#ddlInternetGlass').val(getResult.periodicWorkSchedule.InternetGlass);
                    $('#ddlFlatRoof').val(getResult.periodicWorkSchedule.FlatRoofWashScrub);
                    $('#ddlStainlessSteel').val(getResult.periodicWorkSchedule.StainlessSteelPolishing);
                    $('#ddlExposeCeiling').val(getResult.periodicWorkSchedule.ExposeCeilingTruss);
                    $('#ddlLedgesDamp').val(getResult.periodicWorkSchedule.LedgesDampWipe);
                    $('#ddlSkylightDusting').val(getResult.periodicWorkSchedule.SkylightHighDusting);
                    $('#ddlSignagesWiping').val(getResult.periodicWorkSchedule.SignagesWiping);
                    $('#ddlDecksDusting').val(getResult.periodicWorkSchedule.DecksHighDusting);

                }
                else {

                    $('#ddlContainer').val(0);
                    $('#ddlCeiling').val(0);
                    $('#ddlLightsAir').val(0);
                    $('#ddlFloorScrubbing').val(0);
                    $('#ddlFloorPolishing').val(0);
                    $('#ddlFloorBuffing').val(0);
                    $('#ddlFloorCarpet').val(0);
                    $('#ddlFloorCarpetShampooing').val(0);
                    $('#ddlFloorHeatExtraction').val(0);
                    $('#ddlWallWiping').val(0);
                    $('#ddlWindowdDoor').val(0);
                    $('#ddlPerimeterDrain').val(0);
                    $('#ddlToiletDescaling').val(0);
                    $('#ddlHighRiseNettting').val(0);
                    $('#ddlExternalFacade').val(0);
                    $('#ddlExternalHighGlass').val(0);
                    $('#ddlInternetGlass').val(0);
                    $('#ddlFlatRoof').val(0);
                    $('#ddlStainlessSteel').val(0);
                    $('#ddlExposeCeiling').val(0);
                    $('#ddlLedgesDamp').val(0);
                    $('#ddlSkylightDusting').val(0);
                    $('#ddlSignagesWiping').val(0);
                    $('#ddlDecksDusting').val(0);
                }


            /** Toilet details **/               
                if (getResult.toilets != null) {
                    fillToilets(getResult.toilets);
                }
                else {

                }

            /** Dispenser details **/
                if (getResult.dispenser != null) {

                    $('#txtHPT').val(getResult.dispenser.HandPaperTowel);
                    $('#txtJR').val(getResult.dispenser.JumboRollToiletRoll);
                    $('#txtHS1').val(getResult.dispenser.HandSoapLiquidSoapDispenser);
                    $('#txtD').val(getResult.dispenser.Deodorant);
                    $('#txtFP').val(getResult.dispenser.FootPumpNonContactTypeDispenser);
                    $('#txtHD').val(getResult.dispenser.HandDryers);
                    $('#txtAT').val(getResult.dispenser.AutoTimerDeodorizerAirFreshenerDispenser);
                }
                else {
                    $('#txtHPT').val(0);
                    $('#txtJR').val(0);
                    $('#txtHS1').val(0);
                    $('#txtD').val(0);
                    $('#txtFP').val(0);
                    $('#txtHD').val(0);
                    $('#txtAT').val(0);
                }

            /** Variation details **/
               
                if (getResult.variationDetails != null) {
                    fillVariationDetails(getResult.variationDetails);                    
                }

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
}

function addToiletRow(rum)
{
    var CheckBox = '<td style="text-align:center"><input type="checkbox" id="isDelete' + rum + '" name="isDelete" /><input type="hidden" id="toiletId' + rum + '" value="0" /></td>';
    var Locationcode = '<td><input type="text" class="form-control cssLocationCode" required placeholder="Please Select" id="txtLocationCode' + rum + '" autocomplete="off" name="AreaCodeNo" maxlength="25" /><input type="hidden" id="hdnLocationCodeId' + rum + '" /><div class="col-sm-12" id ="divUserAreaFetchT' + rum + '"></div></td>';
    var type = '<td> <select type="text"  class="form-control" id="txtType' + rum + '" autocomplete="off" name="Status" maxlength="25" >' + ToiletTypeValues + ' </select></td>';
    var frequncy = '<td><select type="text" class="form-control" id="ddlFrequency' + rum + '" autocomplete="off" name="Frequency" maxlength="25" >' + ToiletFrequencyValues + '</select></td>';
    var details = '<td> <select type="text"  class="form-control" id="ddlDetails' + rum + '" autocomplete="off" name="Status" maxlength="25" >' + ToiletDetailsValues + '</select></td>';
    var M = '<td style="text-align:center"><input type="checkbox" name="recordM" id="CheckboxM' + rum + '" /></td>';
    var F = '<td style="text-align:center"><input type="checkbox" name="recordF" id="CheckboxF' + rum + '" /></td>';
    var W = '<td style="text-align:center"><input type="checkbox" name="recordW" id="CheckboxW' + rum + '" /></td>';
    var U = '<td style="text-align:center"><input type="checkbox" name="recordU" id="CheckboxU' + rum + '" /></td>';
    var BW = '<td style="text-align:center"><input type="checkbox" name="recordBW" id="CheckboxBW' + rum + '" /></td>';
    var BS = '<td style="text-align:center"><input type="checkbox" name="recordBS" id="CheckboxBS' + rum + '" /></td>';
    var TR = '<td style="text-align:center"><input type="checkbox" name="recordTR" id="CheckboxTR' + rum + '" /></td>';
    var SP = '<td style="text-align:center"><input type="checkbox" name="recordSP" id="CheckboxSP' + rum + '" /></td>';
    var AA = '<td style="text-align:center"><input type="checkbox" name="recordAA" id="CheckboxAA' + rum + '" /></td>';
    var Waste = '<td style="text-align:center"><input type="checkbox" name="recordWaste" id="CheckboxWaste' + rum + '" /></td>';

    $("#AssetEquipmentAttachmentT tbody").append('<tr>' + CheckBox + Locationcode + type + frequncy + details + M + F + W + U + BW + BS + TR + SP + AA + Waste + '</tr>');
}

function fillToilets(result)
{

    $("#tbodyToilet").html('');

    rowNum1 = 1;
    for (i = 0; i < result.length; i++) {

        addToiletRow(rowNum1);

        $("#toiletId" + rowNum1).val(result[i].ToiletId);
        $("#hdnLocationCodeId" + rowNum1).val(result[i].LocationId);
        $("#txtLocationCode" + rowNum1).val(result[i].LocationCode);
        $("#txtType" + rowNum1).val(result[i].Type);
        $("#ddlFrequency" + rowNum1).val(result[i].Frequency);
        $("#ddlDetails" + rowNum1).val(result[i].Details);
        $("#CheckboxM" + rowNum1).prop('checked', result[i].Mirror);
        $("#CheckboxF" + rowNum1).prop('checked', result[i].Floor);
        $("#CheckboxW" + rowNum1).prop('checked', result[i].Wall);
        $("#CheckboxU" + rowNum1).prop('checked', result[i].Urinal);
        $("#CheckboxBW" + rowNum1).prop('checked', result[i].Bowl);
        $("#CheckboxBS" + rowNum1).prop('checked', result[i].Basin);
        $("#CheckboxTR" + rowNum1).prop('checked', result[i].ToiletRoll);
        $("#CheckboxSP" + rowNum1).prop('checked', result[i].SoapDispenser);
        $("#CheckboxAA" + rowNum1).prop('checked', result[i].AutoAirFreshner);
        $("#CheckboxWaste" + rowNum1).prop('checked', result[i].Waste);

        rowNum1 = rowNum1 + 1;
    }
}

function fillVariationDetails(result)
{

    $("#tbodyVariation").html('');
    rowNum2 = 1;
    for (i = 0; i < result.length; i++) {

        addVariation(rowNum2);

        $('#hdnLocationCodeVariationId' + rowNum2).val(result[i].VariationDetailsId);
        $('#hdnAreaCodeId' + rowNum2).val(result[i].UserAreaId);
        $('#txtAreaCodeVariation' + rowNum2).val(result[i].AreaCode);
        $('#txtAreaNameVariation' + rowNum2).val(result[i].AreaName);
        $('#txtReference' + rowNum2).val(result[i].SNFReference);
        $('#ddlVariation' + rowNum2).val(result[i].VariationStatus);
        $('#txtSq' + rowNum2).val(result[i].Sqft);
        $('#txtPrice' + rowNum2).val(result[i].Price);
        $('#txtCommisioning' + rowNum2).val(result[i].CommissioningDate);
        $('#txtService' + rowNum2).val(result[i].ServiceStartDate);
        $('#txtWarranty' + rowNum2).val(result[i].WarrantyEndDate);
        $('#txtVD' + rowNum2).val(result[i].VariationDate);
        $('#txtSS' + rowNum2).val(result[i].ServiceStopDate);

        rowNum2 = rowNum2 + 1;
    }

}


function addVariation(rum) {

    var CheckBox = '<td style="text-align:center"><input type="checkbox" id="isVarDelete' + rum + '" name="isDelete" /><input type="hidden" id="hdnLocationCodeVariationId' + rum + '" value="0"/></td>';
    var AA = '<td><input type="text"  class="form-control cssAreaCodeVariation" disabled placeholder="Please Select" id="txtAreaCodeVariation' + rum + '" autocomplete="off" name="AreaCodeNo" maxlength="25"  /><input type="hidden" id="hdnAreaCodeId' + rum + '" /><div class="col-sm-12" id ="divFetchVar' + rum + '"></div></td>';
    var AN = '<td> <input type="text"  class="form-control" disabled id="txtAreaNameVariation' + rum + '"   autocomplete="off" name="AreaCodeNo" maxlength="25"  /></td>';
    var SNF = '<td><input type="text"  class="form-control cssReferenceNoVariation" id="txtReference' + rum + '" autocomplete="off" name="AreaCodeNo" maxlength="25"  /><input type="hidden" id="hdnReferenceNo' + rum + '" /><div class="col-sm-12" id ="divFetchRef' + rum + '"></div></td>';
    var VS = '<td><select type="text" class="form-control" id="ddlVariation' + rum + '" autocomplete="off" name="Type" maxlength="25" tabindex="5">' + VariationValues + '</select></td>';
    var Sq = '<td><input type="text"  class="form-control"  id="txtSq' + rum + '"  autocomplete="off" name="AreaCodeNo" maxlength="25"  /></td>';
    var Price = '<td><input type="text"  class="form-control" placeholder="" id="txtPrice' + rum + '" autocomplete="off" name="AreaCodeNo" maxlength="25"  /></td>';
    var Commisioning = '<td><input type="text"  class="form-control datetime" placeholder=" " id="txtCommisioning' + rum + '" autocomplete="off" name="AreaCodeNo" maxlength="25"  /></td>';
    var Servicestart = '<td><input type="text"  class="form-control datetime" disabled id="txtService' + rum + '" autocomplete="off" name="AreaCodeNo" maxlength="25"  /></td>';
    var Warrenty = '<td><input type="text"  class="form-control datetime"  id="txtWarranty' + rum + '" autocomplete="off" name="AreaCodeNo" maxlength="25"  /></td>';
    var VD1 = '<td><input type="text"  class="form-control datetime" id="txtVD' + rum + '" autocomplete="off" name="AreaCodeNo" maxlength="25"  /></td>';
    var Servicestop = '<td><input type="text"  class="form-control datetime" disabled id="txtSS' + rum + '" autocomplete="off" name="AreaCodeNo" maxlength="25"  /></td>';
    $("#AssetEquipmentAttachmentVar tbody").append('<tr>' + CheckBox + AA + AN + SNF + VS + Sq + Price + Commisioning + Servicestart + Warrenty + VD1 + Servicestop + '</tr>');


    $('#txtAreaCodeVariation' + rum).val($('#txtUserAreaCode').val());
    $('#txtAreaNameVariation' + rum).val($('#txtUserAreaName').val());
    $('#txtService' + rum).val($('#txtEffectiveFromDate').val());
    $('#txtSS' + rum).val($('#txtEffectiveToDate').val());

}

function getCustomDate(date) {

    if (date == '' || date == null) {
        return '';
    }
    else {
        let monthNames = ["Zero", "Jan", "Feb", "Mar", "Apr",
            "May", "Jun", "Jul", "Aug",
            "Sep", "Oct", "Nov", "Dec"];

        var day = date.slice(8, 10);
        var monthindex = date.slice(5, 7);        if (monthindex >= 10) {            var month = monthNames[date.slice(5, 7)];        }        else {            var month = monthNames[date.slice(6, 7)];        }
        var year = date.slice(0, 4);
        return day + "-" + month + "-" + year;
    }
}
