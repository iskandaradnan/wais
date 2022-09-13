//*Global variables decration section starts*//
var pageindex = 1, pagesize = 5;
var GridtotalRecords = 0;
var TotalPages = 0, FirstRecord = 0, LastRecord = 0;
//*Golbal variables decration section ends*//
var montharray = new Array();
var weekarray = new Array();
var dayarray = new Array();
var SummaryDetails = [];
$('#textFemsTaskCode').hide();

var MonthIds = [
    "CheckJan",
    "CheckFeb",
    "CheckMar",
    "CheckApr",
    "CheckMay",
    "CheckJun",
    "CheckJul",
    "CheckAug",
    "CheckSep",
    "CheckOct",
    "CheckNov",
    "CheckDec"
];

var currentYear = 0;
var currentMonth = 0;

$(function () {
    $('#Date').multiselect();
})
$(function () {
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    formInputValidation("formppmplanner");

    $.get("/api/PPMPlanner/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#jQGridCollapse1").click();
            $.each(loadResult.YearList, function (index, value) {
                $('#Year').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.WorkOrderTypeList, function (index, value) {
                $('#WorkOrderType').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.AssetClarificationList, function (index, value) {
                $('#AssetClarification').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.WarrentyTypeList, function (index, value) {
                $('#WarrentyType').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.ScheduleList, function (index, value) {
                $('#Schedule').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.StatusList, function (index, value) {
                $('#Status').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.TaskCodeOptionList, function (index, value) {
                $('#TaskCodeOption').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            $.each(loadResult.FrequencyList, function (index, value) {
                $('#PPMFrequencyValue').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            }
           
            );
            currentYear = loadResult.CurrentYear;
            currentMonth = loadResult.CurrentMonth;

            $('#Year').val(currentYear);
            DisableEnableMonthCheckBoxes();

            var options = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"];
            $('#Date').empty();
            var optionHtml = "";
            $.each(options, function (i, p) {
                optionHtml += '<option value="' + p + '">' + p + '</option>';
            });
            $("#Date").html(optionHtml);
            setTimeout(multiSelectshow, 10);

            $.each(loadResult.YearList, function (index, value) {
                $('#SummaryYear').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            $('#Status').val(1);
            $('#TaskCodeOption').val(364);
            $('#Schedule').val(78);
            WarrentyChange();
            ScheduleChange();
            TaskCodeType();
            SummaryData();
            $('#textFemsTaskCode').hide();
           
        })
        .fail(function (response) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            $('#errorMsg').css('visibility', 'visible');
        });


    $("#btnSave,#btnEdit,#btnSaveandAddNew").click(function () {
        debugger;
        var Schedule = $('#Schedule').val();
        var MonthString = montharray.toString();
        var WeekString = weekarray.toString();
        var DayString = dayarray.toString();
        var DateList = Multiselect($("#Date option:selected"));
        var TypeCodeHiddenValue = $('#hdnAssetTypeCodeId').val();
        var TypeCodeValue = $('#txtAssetTypeCode').val();
        var TaskCodeType = $('#TaskCodeOption').val();
        var AgreedDate = $('#txtAgreedDate').val();
        var PPMFrequencyValue = $('#PPMFrequencyValue').val();


        if (TaskCodeType === "364") {
            if ((Schedule == "78") && (MonthString == "" || DateList == "")) {
                bootbox.alert("Month & Date Should not be empty!")
                return false;
            }
        }

        if (TaskCodeType === "364") {
            if ((Schedule == "79") && (MonthString == "" || WeekString == "" || DayString == "")) {
                bootbox.alert("Month,Week & Day Should not be empty!")
                return false;
            }
        }

        if (TypeCodeValue != "" && TypeCodeHiddenValue == "") {
            bootbox.alert("Valid Type Code required!");
            return false;
        }

        var dummy = CheckFeb();
        var dummyDay = CheckDays();
        if (dummy == false) {
            return false;
        }
        if (dummyDay == false) {
            return false;
        }

        var assetId = $('#hdnAssetId').val();
        var assetNo = $('#txtAssetNo').val();
        if (assetId == '' && assetNo != '') {
            $("div.errormsgcenter").text("Please enter valid Asset No.");
            $('#errorMsg').css('visibility', 'visible');

            $('#myPleaseWait').modal('hide');
            return false;
        }

        var assigneeId = $('#hdnEngineerId').val();
        var assigneeName = $('#txtEngineer').val();
        if (assigneeId == '' && assigneeName != '') {
            $("div.errormsgcenter").text("Please enter valid Assignee");
            $('#errorMsg').css('visibility', 'visible');

            $('#myPleaseWait').modal('hide');

            return false;
        }

        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var CurrentbtnID = $(this).attr("Id");
        function Multiselect(selectID) {
            var selectedCompData = $.map(selectID, function (el, i) { return $(el).val(); })
            return selectedCompData.join();
        }

        var isFormValid = formInputValidation("formppmplanner", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var primaryId = $("#primaryID").val();
        var ServiceId = 2;
        var WorkGroupId = 1;
        var Year = $('#Year').val();
        var WorkOrderType = $('#WorkOrderType').val();
        // var UserAreaId = $('#hdnUserAreaId').val();
        var AssigneeId = $('#hdnEngineerId').val();
        // var HospitalRepresentativeId = $('#hdnHospitalRepresentativeId').val();
        var AssetClassification = $('#AssetClarification').val();
        var WarrentyType = $('#WarrentyType').val();
        var AssetTypeCodeId = $('#hdnAssetTypeCodeId').val();
        var AssetId = $('#hdnAssetId').val();
        var labelid = document.getElementById('Labelid').value;
        if (labelid == 2) {
            var StandardTaskDetId = $('#txtFemsTaskCode').val();
        }
        else {
            var StandardTaskDetId = $('#hdnStandardTaskDetId').val();
        }
        var Status = $('#Status').val();
        var EngineerId = null;
        var Timestamp = $('#Timestamp').val();
        var GenerationType = $('#TaskCodeOption').val();
        var AgreedDate = $('#txtAgreedDate').val();
        var FirstDate = $('#txtFirstDate').val();
        var FrequencyId = $('#PPMFrequencyValue').val();
   
        if (TaskCodeType === "365") {
            MonthString = null;
            WeekString = null;
            DayString = null;
            DateList = null;

        }
        else if (TaskCodeType === "364") {
            FirstDate = null;
        }


        var obj = {
            PlannerId: primaryId,
            ServiceId: ServiceId,
            WorkGroup: WorkGroupId,
            Year: Year,
            WorkOrderType: WorkOrderType,
            UserAreaId: null,
            AssigneeId: AssigneeId,
            TypeOfPlanner: 34,
            HospitalRepresentativeId: null,
            AssetClarification: AssetClassification,
            WarrentyType: WarrentyType,
            AssetTypeCodeId: AssetTypeCodeId,
            AssetRegisterId: AssetId,
            StandardTaskDetId: StandardTaskDetId,
            Schedule: Schedule,
            Status: Status,
            EngineerId: EngineerId,
            Month: MonthString,
            Date: DateList,
            Week: WeekString,
            Day: DayString,
            Timestamp: Timestamp,
            TaskCodeOption: GenerationType,
            FirstDate: FirstDate,
            AgreedDate: AgreedDate,
            FrequencyId: FrequencyId,
            TaskCodeType: TaskCodeType,
            //Timestamp: (primaryId != 0 || primaryId != null) ? primaryId : 0,
        };


        var jqxhr = $.post("/api/PPMPlanner/Add", obj, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.PlannerId);
            $("#Timestamp").val(result.Timestamp);
            $("#grid").trigger('reloadGrid');
            if (result.PlannerId != 0) {
                $('#txtAgreedDate').val(moment(result.AgreedDate).format("DD-MMM-YYYY"));
                if (result.FirstDate == "0001-01-01T00:00:00")
                    result.FirstDate = null;
                if (result.NextDate == "0001-01-01T00:00:00")
                    result.NextDate = null;
                if (result.LastDate == "0001-01-01T00:00:00")
                    result.LastDate = null;
                if (result.FirstDate != null)
                    $('#txtFirstDate').val(moment(result.FirstDate).format("DD-MMM-YYYY"));
                if (result.NextDate != null)
                    $('#txtNextDate').val(moment(result.NextDate).format("DD-MMM-YYYY"));
                if (result.LastDate != null)
                    $('#txtLastDate').val(moment(result.LastDate).format("DD-MMM-YYYY"));
                $('#WarrentyType').attr('disabled', true);
                $('#TaskCodeOption').attr('disabled', true);
                $('#txtAssetNo').attr('disabled', true);
                $('#spnPopup-assetNo').hide();
                $('#txtFirstDate').prop('disabled', true);
                $('#Year').attr('disabled', true);
                $('#Schedule').attr('disabled', true);

                $('#CheckJan').attr('disabled', true);
                $('#CheckFeb').attr('disabled', true);
                $('#CheckMar').attr('disabled', true);
                $('#CheckApr').attr('disabled', true);
                $('#CheckMay').attr('disabled', true);
                $('#CheckJun').attr('disabled', true);
                $('#CheckJul').attr('disabled', true);
                $('#CheckAug').attr('disabled', true);
                $('#CheckSep').attr('disabled', true);
                $('#CheckOct').attr('disabled', true);
                $('#CheckNov').attr('disabled', true);
                $('#CheckDec').attr('disabled', true);

                $('#CheckWeek1').attr('disabled', true);
                $('#CheckWeek2').attr('disabled', true);
                $('#CheckWeek3').attr('disabled', true);
                $('#CheckWeek4').attr('disabled', true);
                $('#CheckWeek5').attr('disabled', true);

                $('#CheckSun').attr('disabled', true);
                $('#CheckMon').attr('disabled', true);
                $('#CheckTue').attr('disabled', true);
                $('#CheckWed').attr('disabled', true);
                $('#CheckThu').attr('disabled', true);
                $('#CheckFri').attr('disabled', true);
                $('#CheckSat').attr('disabled', true);
                $('#txtFemsTaskCode').attr('disabled', true);

                $('#btnEdit').show();
                $('#btnSave').hide();
                $("#btnDelete").show();
                
            }

            setTimeout(function () {
                $('.multiSelectDDLwithoutSearch').multiselect('rebuild');
                $(".multiselect-container").find("input").prop("disabled", true);
            }, 500)

            $(".content").scrollTop(0);
            showMessage('PPM Planner', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            if (CurrentbtnID == "btnSaveandAddNew") {
                EmptyFields();
                ScheduleChange();
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

                $('#btnSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            });
    });

    //fetch - type code 
    var typeCodeFetchObj = {
        SearchColumn: 'txtAssetTypeCode-AssetTypeCode',//Id of Fetch field
        ResultColumns: ["AssetTypeCodeId-Primary Key", 'AssetTypeCode-AssetTypeCode', 'AssetTypeDescription-AssetTypeDescription'],//Columns to be displayed
        AdditionalConditions: ["TypeOfPlanner-TypeOfPlanner", "AssetClassificationId-AssetClarification"],
        FieldsToBeFilled: ["hdnAssetTypeCodeId-AssetTypeCodeId", "txtAssetTypeCode-AssetTypeCode", "txtTypeCodeDetails-AssetTypeDescription"]//id of element - the model property
    };

    var apiUrlForTypeCodeFetch = "/api/Fetch/TypeCodeFetch";

    $('#txtAssetTypeCode').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divTypeCodeFetch', typeCodeFetchObj, apiUrlForTypeCodeFetch, "UlFetch", event, 1);//1 -- pageIndex
    });

    //fetch - user area 

    //var UserAreaFetchObj = {
    //    SearchColumn: 'txtUserAreaCode-UserAreaCode',//Id of Fetch field
    //    ResultColumns: ["UserAreaId-Primary Key", 'UserAreaCode-UserAreaCode', 'UserAreaName-UserAreaName'],
    //    FieldsToBeFilled: ["hdnUserAreaId-UserAreaId", "txtUserAreaCode-UserAreaCode", "txtUserAreaName-UserAreaName"]
    //};

    //$('#txtUserAreaCode').on('input propertychange paste keyup', function (event) {
    //    DisplayFetchResult('divUserAreaFetch', UserAreaFetchObj, "/api/Fetch/UserAreaFetch", "UlFetch2", event, 1);//1 -- pageIndex
    //});

    //fetch - Assignee 
    var AssigneeFetchObj = {
        SearchColumn: 'txtAssignee-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-StaffName'],
        FieldsToBeFilled: ["hdnAssigneeId-StaffMasterId", "txtAssignee-StaffName"]
    };

    $('#txtAssignee').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divtAssigneeFetch', AssigneeFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch3", event, 1);//1 -- pageIndex
    });


    //fetch - Hospital Rep 
    //var HospitalRepFetchObj = {
    //    SearchColumn: 'txtHospitalRepresentative-StaffName',//Id of Fetch field
    //    ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-StaffName'],
    //    FieldsToBeFilled: ["hdnHospitalRepresentativeId-StaffMasterId", "txtHospitalRepresentative-StaffName"]
    //};

    //$('#txtHospitalRepresentative').on('input propertychange paste keyup', function (event) {
    //    DisplayFetchResult('divHospitalRepresentativeFetch', HospitalRepFetchObj, "/api/Fetch/FacilityStaffFetch", "UlFetch4", event, 1);//1 -- pageIndex
    //});

    //fetch - Asset No 
    
    var AssetNoFetchObj = {
        SearchColumn: 'txtAssetNo-AssetNo',//Id of Fetch field
        ResultColumns: ["AssetId-Primary Key", 'AssetNo-AssetNo'],
        AdditionalConditions: ["TypeOfPlanner-TypeOfPlanner", "Year-Year"],
        FieldsToBeFilled: ["hdnAssetId-AssetId", "txtAssetNo-AssetNo", "txtModel-Model", "txtManufacturer-Manufacturer",
            "txtSerialNumber-SerialNumber", "txtWarrentyEndDate-WarrentyEndDate", "txtSupplierName-SupplierName",
            "txtContractEndDate-ContractEndDate", "txtContractorName-ContractorName", "txtContactNumber-ContactNumber", 'WarrentyType-WarrentyType',
            'AssetClarification-AssetClarification', 'txtAssetTypeCode-TypeCode', 'hdnAssetTypeCodeId-TypeCodeID', 'txtTypeCodeDetails-TypeCodeDescription',
            'WorkOrderType-WorkOrderType', 'hdnStandardTaskDetId-TaskCodeId', 'txtTaskCode-TaskCode', 'txtFemsTaskCode-PPMFrequencyValue', 'PPMFrequencyValue-PPMFrequencyValue']
    };
   
   
    $('#txtAssetNo').on('input propertychange paste keyup', function (event) {
        AssetNoFetchObj.TypeCode = $('#hdnAssetTypeCodeId').val();
        DisplayPPMFetchResult('divAssetNoFetch', AssetNoFetchObj, "/api/Fetch/ParentAssetNoFetch", "UlFetch5", event, 1);//1 -- pageIndex
    });

    AssetNoSearchObj = {
        Heading: "Asset No Details",
        SearchColumns: ['AssetNo-Asset No.', 'AssetDescription-Asset Description'],
        ResultColumns: ["AssetId-Primary Key", 'AssetNo-Asset No.', 'AssetDescription-Asset Description'],
        AdditionalConditions: ["TypeOfPlanner-TypeOfPlanner", "Year-Year"],
        FieldsToBeFilled: ["hdnAssetId-AssetId", "txtAssetNo-AssetNo", "txtModel-Model", "txtManufacturer-Manufacturer",
            "txtSerialNumber-SerialNumber", "txtWarrentyEndDate-WarrentyEndDate", "txtSupplierName-SupplierName",
            "txtContractEndDate-ContractEndDate", "txtContractorName-ContractorName", "txtContactNumber-ContactNumber",
            'WarrentyType-WarrentyType', 'AssetClarification-AssetClarification', 'txtAssetTypeCode-TypeCode',
            'hdnAssetTypeCodeId-TypeCodeID', 'txtTypeCodeDetails-TypeCodeDescription',
            'WorkOrderType-WorkOrderType', 'hdnStandardTaskDetId-TaskCodeId','PPMFrequencyValue-PPMFrequencyValue']
    };

    $('#spnPopup-assetNo').click(function () {
        DisplaySeachPopup('divSearchPopup', AssetNoSearchObj, "/api/Search/ParentAssetNoSearch");
    }).attr('disabled', false).css('cursor', 'pointer');

    //fetch - Task Code 
    //var TaskCodeFetchObj = {
    //    SearchColumn: 'txtTaskCode-TaskCode',//Id of Fetch field
    //    ResultColumns: ["StandardTaskDetId-Primary Key", 'TaskCode-TaskCode'],
    //    AdditionalConditions: ["TypeOfPlanner-TypeOfPlanner", "hdnAssetTypeCodeId-hdnAssetTypeCodeId"],
    //    FieldsToBeFilled: ["hdnStandardTaskDetId-StandardTaskDetId", "txtTaskCode-TaskCode", 'PPMFrequency-PPMFrequency', 'PPMFrequencyValue-PPMFrequencyValue']
    //};

    //$('#txtTaskCode').on('input propertychange paste keyup', function (event) {
    //    DisplayFetchResult('divTaskCodeFetch', TaskCodeFetchObj, "/api/Fetch/FetchTaskCode", "UlFetch6", event, 1);//1 -- pageIndex
    //});

    //fetch - Engineer 
    var EngineerFetchObj = {
        SearchColumn: 'txtEngineer-Engineer',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-StaffName'],
        FieldsToBeFilled: ["hdnEngineerId-StaffMasterId", "txtEngineer-StaffName", "txtContactNumber-ContactNumber"]
    };

    $('#txtEngineer').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divEngineerFetch', EngineerFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch7", event, 1);//1 -- pageIndex
    });
    AssigneeSearchObj = {
        Heading: "Assignee Details",//Heading of the popup
        SearchColumns: ['StaffName-Staff Name'],//ModelProperty - Space seperated label value
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name'],//Columns to be returned for display
        FieldsToBeFilled: ["hdnEngineerId-StaffMasterId", "txtEngineer-StaffName", "txtContactNumber-ContactNumber"]//id of element - the model property--, , 
    };

    $('#spnPopup-assignee').click(function () {
        DisplaySeachPopup('divSearchPopup', AssigneeSearchObj, "/api/Search/CompanyStaffSearch");
    });
    //search - type code 
    var typeCodeSearchObj = {
        Heading: "Type Code Details",//Heading of the popup
        SearchColumns: ['AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description', 'AssetClassificationCode-Asset Classification Code'],//ModelProperty - Space seperated label value
        ResultColumns: ["AssetTypeCodeId-Primary Key", 'AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description', 'AssetClassificationCode-Asset Classification Code'],//Columns to be returned for display
        FieldsToBeFilled: ["hdnAssetTypeCodeId-AssetTypeCodeId", "txtAssetTypeCode-AssetTypeCode", "txtAssetTypeDesc-AssetTypeDescription"] //id of element - the model property
    };

    $('#spnPopup-staff').click(function () {
        DisplaySeachPopup('divSearchPopup', typeCodeSearchObj, "/api/Fetch/TypeCodeFetch");
    });

    //search - Manufacturer
    var manufacturerSearchObj = {
        Heading: "Manufacturer Details",
        SearchColumns: ['Manufacturer-Manufacturer'],
        ResultColumns: ["ManufacturerId-Primary Key", 'Manufacturer-Manufacturer'],
        FieldsToBeFilled: ["hdnARManufacturerId-ManufacturerId", "txtARManufacturer-Manufacturer"]
    };

    $('#spnPopup-manufacturer').click(function () {
        DisplaySeachPopup('divSearchPopup', manufacturerSearchObj, "/api/Search/ManufacturerSearch");
    });


    var modelSearchObj = {
        Heading: "Model Details",
        SearchColumns: ['Model-Model'],
        ResultColumns: ["ModelId-Primary Key", 'Model-Model'],
        FieldsToBeFilled: ["hdnARModelId-ModelId", "txtARModel-Model"]
    };

    $('#spnPopup-model').click(function () {
        DisplaySeachPopup('divSearchPopup', modelSearchObj, "/api/Search/ModelSearch");
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


    $("#SummarybtnCancel").click(function () {
        var message = Messages.Reset_TabAlert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                EmptyFields();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
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

});



//============Addding for Bind Frequency+TaskCode============
function FunctionUserAssetFrequencyTaskCode(AssetNo, AssetId) {
    var labelid = document.getElementById('Labelid').value;

    if (labelid == 2) {
        $.get("/api/PPMPlanner/AssetFrequencyTaskCode/" + AssetNo)
            .done(function (result) {
                var getResult = JSON.parse(result);
                $("#txtFemsTaskCode").empty();
                $('#txtFemsTaskCode').append('<option value="' +0+ '">' + 'Select' + '</option>');
                $.each(getResult.ServiceList, function (index, value) {
                    $('#txtFemsTaskCode').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                });

            })
            .fail(function () {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');
            });

    }
}

$('#txtFemsTaskCode').change(function () {
    var TaskCodeid = document.getElementById('txtFemsTaskCode').value;
    var AssetId = document.getElementById('hdnAssetId').value;
    var AssetNo = document.getElementById('txtAssetNo').value;

    $('#TaskCodeOption').val(365);
  /*  $('#TaskCodeOption').attr('disabled', true);*/
    $('#ScheduleTypeHide').hide();
    $('#Schedule').prop('required', false);
    $('#HideMonth').hide();
    $('#HideDate').hide();
    $('#HideDay').hide();
    $('#HideWeek').hide();
    $('#FirstDateHide').show();
    $('#txtFirstDate').prop('required', true);
    $('#LastDateHide').show();
    $('#Year').attr('disabled', true);
    $.get("/api/PPMPlanner/AssetTypeCodeFrequency/" + TaskCodeid)
        .done(function (result) {
            var getResult = JSON.parse(result);

            var test = getResult.PPFrequency;
          
            $('#PPMFrequencyValue').val(test);

        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });



   
});


//=============End Here..=================


function DisableEnableMonthCheckBoxes() {
    var selectedYear = $('#Year').val();
    var monthCurrent = currentMonth - 1;
    for (i = 0; i < MonthIds.length; i++) {
        $('#' + MonthIds[i]).prop('checked', false);
        if (selectedYear == currentYear) {
            if (i < monthCurrent) {
                $('#' + MonthIds[i]).attr('disabled', true);
            }
        } else {
            $('#' + MonthIds[i]).attr('disabled', false);
        }
    }
}






$('#Year').change(function () {
    DisableEnableMonthCheckBoxes();
});






function WarrentyChange() {
    var Value = $("#WarrentyType option:selected").text();
    if (Value == "Warranty") {
        $("#WarrentyHide").show();
        $("#ContractHide").hide();
        $("#EngineerHide").hide();
        $('#txtEngineer').prop('required', true);
    }
    else if (Value == "Contract") {
        $("#ContractHide").show();
        $("#WarrentyHide").hide();
        $("#EngineerHide").hide();
        $('#txtEngineer').prop('required', true);
    }
    else if (Value == "None") {
        $("#EngineerHide").show();
        $('#txtEngineer').prop('required', true);
        $("#WarrentyHide").hide();
        $("#ContractHide").hide();
    }
    else if (Value == "Select ") {
        $("#EngineerHide").show();
        $("#WarrentyHide").show();
        $("#ContractHide").show();
    }
}
//---------------------------------------------------------------------------//

//----------------Fields hide & show based on Schedule Type Lov-----------------

function ScheduleChange() {
    var Input = $("#Schedule option:selected").text();

    if (Input === ' Monthly - Date') {
        $('#HideWeek').hide();
        $('#HideDay').hide();
        $('#HideDate').show();
    }
    else if (Input === ' Monthly - Day') {
        $('#HideWeek').show();
        $('#HideDay').show();
        $('#HideDate').hide();
    }
    else {
        $('#HideWeek').show();
        $('#HideDay').show();
        $('#HideDate').show();
    }

    
}

//---------------------------------------------------------------------------//

//----------------Load month values to save------------------------------------

function LoadMonth(MonthParam, Flag) {
    if ($('#Check' + MonthParam).prop('checked') == true) {
        var result = getmonth(MonthParam, Flag);
        montharray.push(result);
    }
    else {
        var result = getmonth(MonthParam, Flag);
        var index = montharray.indexOf(result);
        montharray.splice(index, 1);
    }

}

function getmonth(MonthName, Flag) {
    var result = null;
    var MonthList = [{ Month: "Jan", value: 1 }, { Month: "Feb", value: 2 }, { Month: "Mar", value: 3 }, { Month: "Apr", value: 4 }, { Month: "May", value: 5 }, { Month: "Jun", value: 6 },
    { Month: "Jul", value: 7 }, { Month: "Aug", value: 8 }, { Month: "Sep", value: 9 }, { Month: "Oct", value: 10 }, { Month: "Nov", value: 11 }, { Month: "Dec", value: 12 }];

    if (Flag == "String")
        result = Enumerable.From(MonthList).Where("x=>x.Month =='" + MonthName + "'").Select("x=>x.value").FirstOrDefault();
    else if (Flag == "Int")
        result = Enumerable.From(MonthList).Where("x=>x.value == " + MonthName).Select("x=>x.Month").FirstOrDefault();

    return result;
}


//----------------Load Week values to save------------------------------------

function LoadWeek(WeekParam, Flag) {
    if ($('#Check' + WeekParam).prop('checked') == true) {
        var result = getweek(WeekParam, Flag);
        weekarray.push(result);
    }
    else {
        var result = getweek(WeekParam, Flag);
        var index = weekarray.indexOf(result);
        weekarray.splice(index, 1);
    }

}

function getweek(WeekName, Flag) {
    var result = null;
    var WeekList = [{ Week: "Week1", value: 1 }, { Week: "Week2", value: 2 }, { Week: "Week3", value: 3 }, { Week: "Week4", value: 4 }, { Week: "Week5", value: 5 }];
    if (Flag == "String")
        result = Enumerable.From(WeekList).Where("x=>x.Week =='" + WeekName + "'").Select("x=>x.value").FirstOrDefault();
    else if (Flag == "Int")
        result = Enumerable.From(WeekList).Where("x=>x.value == " + WeekName).Select("x=>x.Week").FirstOrDefault();

    return result;
}



//----------------Load Day values to save------------------------------------

function LoadDay(DayParam, Flag) {
    if ($('#Check' + DayParam).prop('checked') == true) {
        var result = getday(DayParam, Flag);
        dayarray.push(result);
    }
    else {
        var result = getday(DayParam, Flag);
        var index = dayarray.indexOf(result);
        dayarray.splice(index, 1);
    }

}

function getday(DayName, Flag) {
    var result = null;
    var DayList = [{ Day: "Sun", value: 1 }, { Day: "Mon", value: 2 }, { Day: "Tue", value: 3 }, { Day: "Wed", value: 4 }, { Day: "Thu", value: 5 }, { Day: "Fri", value: 6 }, { Day: "Sat", value: 7 }];
    if (Flag == "String")
        result = Enumerable.From(DayList).Where("x=>x.Day =='" + DayName + "'").Select("x=>x.value").FirstOrDefault();
    else if (Flag == "Int")
        result = Enumerable.From(DayList).Where("x=>x.value == " + DayName).Select("x=>x.Day").FirstOrDefault();

    return result;
}



//----------------------------Month & Date Validation------------------------------

function CheckDays() {
    var message = "";
    var DateSelected = Multiselect($("#Date option:selected")).split(",");
    function Multiselect(selectID) {
        var selectedCompData = $.map(selectID, function (el, i) { return $(el).val(); })
        return selectedCompData.join();
    }

    if (Enumerable.From(montharray).Any("$ == 4 || $ == 6 || $ == 9 || $ == 11")) {
        if (Enumerable.From(montharray).Any("$ == 4")) {
            message = "April";
        }
        if (Enumerable.From(montharray).Any("$ == 6")) {
            message = message + " " + ',' + "June";
        }
        if (Enumerable.From(montharray).Any("$ == 9")) {
            message = message + " " + ',' + "September";
        }
        if (Enumerable.From(montharray).Any("$ == 11")) {
            message = message + " " + ',' + "November";
        }
        if (Enumerable.From(DateSelected).Any("$ > 30")) {
            message = message.indexOf(',') == 1 ? message.replace(",", "") : message;
            bootbox.alert(message + " " + "has only 30 Days!")
            return false;
        }

    }

}

function CheckFeb() {
    var temp = $("#Year option:selected").text();
    var Year = parseInt(temp);
    var IsLeap = FindLeap(Year);
    var DateSelected = Multiselect($("#Date option:selected")).split(",");
    function Multiselect(selectID) {
        var selectedCompData = $.map(selectID, function (el, i) { return $(el).val(); })
        return selectedCompData.join();
    }
    function FindLeap(Year) {
        var result = false;
        if (Year % 4 == 0)
            result = true;
        return result;
    }

    if (Enumerable.From(montharray).Any("$ == 2")) {
        if (IsLeap == true && Enumerable.From(DateSelected).Any("$ > 29")) {
            bootbox.alert("February has only 29 Days!")
            return false;
        }
        if (IsLeap == false && Enumerable.From(DateSelected).Any("$ > 28")) {
            bootbox.alert("February has only 28 Days!")
            return false;
        }

    }
}

// Summary Tab

function SummaryData() {
    $('#myPleaseWait').modal('show');
    var ServiceId = 2;
    var WorkGroupId = 1;
    var TypeOfPlanner = 34;
    var Year = $("#SummaryYear option:selected").text();
    $.get("/api/PPMPlanner/Summary/" + ServiceId + "/" + WorkGroupId + "/" + Year + "/" + TypeOfPlanner + "/" + pagesize + "/" + pageindex)
        .done(function (result) {
            var getResult = JSON.parse(result);
            SummaryDetails = getResult.SummaryDets;
            if (SummaryDetails == null) {
                PushEmptyMessage();
            }
            else {
                $("#SummaryResultId").empty();
                $.each(SummaryDetails, function (index, value) {
                    SummaryNewRow();

                    $("#AssetNo_" + index).val(value.AssetNo).prop("disabled", true);
                    $("#AssetDescription_" + index).val(value.AssetDescription).prop("disabled", true);
                    $("#TaskCode_" + index).val(value.TaskCode).prop("disabled", true);
                    $("#Week1_" + index).prop('checked', value.Week1);
                    $("#Week2_" + index).prop('checked', value.Week2);
                    $("#Week3_" + index).prop('checked', value.Week3);
                    $("#Week4_" + index).prop('checked', value.Week4);
                    $("#Week5_" + index).prop('checked', value.Week5);
                    $("#Week6_" + index).prop('checked', value.Week6);
                    $("#Week7_" + index).prop('checked', value.Week7);
                    $("#Week8_" + index).prop('checked', value.Week8);
                    $("#Week9_" + index).prop('checked', value.Week9);
                    $("#Week10_" + index).prop('checked', value.Week10);
                    $("#Week11_" + index).prop('checked', value.Week11);
                    $("#Week12_" + index).prop('checked', value.Week12);
                    $("#Week13_" + index).prop('checked', value.Week13);
                    $("#Week14_" + index).prop('checked', value.Week14);
                    $("#Week15_" + index).prop('checked', value.Week15);
                    $("#Week16_" + index).prop('checked', value.Week16);
                    $("#Week17_" + index).prop('checked', value.Week17);
                    $("#Week18_" + index).prop('checked', value.Week18);
                    $("#Week19_" + index).prop('checked', value.Week19);
                    $("#Week20_" + index).prop('checked', value.Week20);
                    $("#Week21_" + index).prop('checked', value.Week21);
                    $("#Week22_" + index).prop('checked', value.Week22);
                    $("#Week23_" + index).prop('checked', value.Week23);
                    $("#Week24_" + index).prop('checked', value.Week24);
                    $("#Week25_" + index).prop('checked', value.Week25);
                    $("#Week26_" + index).prop('checked', value.Week26);
                    $("#Week27_" + index).prop('checked', value.Week27);
                    $("#Week28_" + index).prop('checked', value.Week28);
                    $("#Week29_" + index).prop('checked', value.Week29);
                    $("#Week30_" + index).prop('checked', value.Week30);
                    $("#Week31_" + index).prop('checked', value.Week31);
                    $("#Week32_" + index).prop('checked', value.Week32);
                    $("#Week33_" + index).prop('checked', value.Week33);
                    $("#Week34_" + index).prop('checked', value.Week34);
                    $("#Week35_" + index).prop('checked', value.Week35);
                    $("#Week36_" + index).prop('checked', value.Week36);
                    $("#Week37_" + index).prop('checked', value.Week37);
                    $("#Week38_" + index).prop('checked', value.Week38);
                    $("#Week39_" + index).prop('checked', value.Week39);
                    $("#Week40_" + index).prop('checked', value.Week40);
                    $("#Week41_" + index).prop('checked', value.Week41);
                    $("#Week42_" + index).prop('checked', value.Week42);
                    $("#Week43_" + index).prop('checked', value.Week43);
                    $("#Week44_" + index).prop('checked', value.Week44);
                    $("#Week45_" + index).prop('checked', value.Week45);
                    $("#Week46_" + index).prop('checked', value.Week46);
                    $("#Week47_" + index).prop('checked', value.Week47);
                    $("#Week48_" + index).prop('checked', value.Week48);
                    $("#Week49_" + index).prop('checked', value.Week49);
                    $("#Week50_" + index).prop('checked', value.Week50);
                    $("#Week51_" + index).prop('checked', value.Week51);
                    $("#Week52_" + index).prop('checked', value.Week52);
                    $("#Week53_" + index).prop('checked', value.Week53);
                });
            }
            if ((SummaryDetails && SummaryDetails.length) > 0) {
                GridtotalRecords = SummaryDetails[0].TotalRecords;
                TotalPages = SummaryDetails[0].TotalPages;
                LastRecord = SummaryDetails[0].LastRecord;
                FirstRecord = SummaryDetails[0].FirstRecord;
                pageindex = SummaryDetails[0].PageIndex;
            }

            var mapIdproperty = ["AssetNo-AssetNo_", "AssetDescription-AssetDescription_", "TaskCode-TaskCode_",
                "Week1-Week1_-checkbox", "Week2-Week2_-checkbox", "Week3-Week3_-checkbox", "Week4-Week4_-checkbox", "Week5-Week5_-checkbox", "Week6-Week6_-checkbox", "Week7-Week7_-checkbox", "Week8-Week8_-checkbox", "Week9-Week9_-checkbox", "Week10-Week10_-checkbox",
                "Week11-Week11_-checkbox", "Week12-Week12_-checkbox", "Week13-Week13_-checkbox", "Week14-Week14_-checkbox", "Week15-Week15_-checkbox", "Week16-Week16_-checkbox", "Week17-Week17_-checkbox", "Week18-Week18_-checkbox", "Week19-Week19_-checkbox", "Week20-Week20_-checkbox",
                "Week21-Week21_-checkbox", "Week22-Week22_-checkbox", "Week23-Week23_-checkbox", "Week24-Week24_-checkbox", "Week25-Week25_-checkbox", "Week26-Week26_-checkbox", "Week27-Week27_-checkbox", "Week28-Week28_-checkbox", "Week29-Week29_-checkbox", "Week30-Week30_-checkbox",
                "Week31-Week31_-checkbox", "Week32-Week32_-checkbox", "Week33-Week33_-checkbox", "Week34-Week34_-checkbox", "Week35-Week35_-checkbox", "Week36-Week36_-checkbox", "Week37-Week37_-checkbox", "Week38-Week38_-checkbox", "Week39-Week39_-checkbox", "Week40-Week40_-checkbox",
                "Week41-Week41_-checkbox", "Week42-Week42_-checkbox", "Week43-Week43_-checkbox", "Week44-Week44_-checkbox", "Week45-Week45_-checkbox", "Week46-Week46_-checkbox", "Week47-Week47_-checkbox", "Week48-Week48_-checkbox", "Week49-Week49_-checkbox", "Week50-Week50_-checkbox",
                "Week51-Week51_-checkbox", "Week52-Week52_-checkbox", "Week53-Week53_-checkbox"];
            var htmltext = SummaryGridHtml();//Inline Html
            var obj = { formId: "#form", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "SummaryDets", tableid: '#SummaryResultId', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/PPMPlanner/Summary/" + ServiceId + "/" + WorkGroupId + "/" + Year + "/" + TypeOfPlanner, pageindex: pageindex, pagesize: pagesize };

            CreateFooterPagination(obj);

            $('#myPleaseWait').modal('hide');
        })
        .fail(function (response) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            $('#errorMsg').css('visibility', 'visible');
        });
}

//Summary Tab Functions
function SummaryNewRow() {

    var inputpar = {
        inlineHTML: SummaryGridHtml(),//Inline Html
        TargetId: "#SummaryResultId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
}

function PushEmptyMessage() {
    $("#SummaryResultId").empty();
    var emptyrow = '<tr><td colspan=57 ><h3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;No records to display</h3></td></tr>'
    $("#SummaryResultId ").append(emptyrow);
}

function SummaryGridHtml() {

    return '<tr>' +
        '<td " style="text-align: center;" title=""><div><input disabled id="AssetNo_maxindexval"  type="text" class="form-control" name="AssetNo" autocomplete="off"></div></td>' +
        '<td " style="text-align: center;" title=""><div><input disabled id="AssetDescription_maxindexval" type="text" class="form-control" name="AssetDescription" autocomplete="off"></div></td>' +
        '<td " style="text-align: center;" title=""><div><input disabled id="TaskCode_maxindexval" maxindex="150" type="text" class="form-control" name="TaskCode" autocomplete="off"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week1_maxindexval"  type="checkbox" class="form-control" name="Week1_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week2_maxindexval"  type="checkbox" class="form-control" name="Week2_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week3_maxindexval"  type="checkbox" class="form-control" name="Week3_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week4_maxindexval"  type="checkbox" class="form-control" name="Week4_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week5_maxindexval"  type="checkbox" class="form-control" name="Week5_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week6_maxindexval"  type="checkbox" class="form-control" name="Week6_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week7_maxindexval"  type="checkbox" class="form-control" name="Week7_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week8_maxindexval"  type="checkbox" class="form-control" name="Week8_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week9_maxindexval"  type="checkbox" class="form-control" name="Week9_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week10_maxindexval" type="checkbox" class="form-control" name="Week10"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week11_maxindexval" type="checkbox" class="form-control" name="Week11_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week12_maxindexval" type="checkbox" class="form-control" name="Week12_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week13_maxindexval" type="checkbox" class="form-control" name="Week13_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week14_maxindexval" type="checkbox" class="form-control" name="Week14_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week15_maxindexval" type="checkbox" class="form-control" name="Week15_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week16_maxindexval" type="checkbox" class="form-control" name="Week16_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week17_maxindexval" type="checkbox" class="form-control" name="Week17_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week18_maxindexval" type="checkbox" class="form-control" name="Week18_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week19_maxindexval" type="checkbox" class="form-control" name="Week19_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week20_maxindexval" type="checkbox" class="form-control" name="Week20"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week21_maxindexval" type="checkbox" class="form-control" name="Week21_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week22_maxindexval" type="checkbox" class="form-control" name="Week22_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week23_maxindexval" type="checkbox" class="form-control" name="Week23_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week24_maxindexval" type="checkbox" class="form-control" name="Week24_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week25_maxindexval" type="checkbox" class="form-control" name="Week25_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week26_maxindexval" type="checkbox" class="form-control" name="Week26_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week27_maxindexval" type="checkbox" class="form-control" name="Week27_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week28_maxindexval" type="checkbox" class="form-control" name="Week28_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week29_maxindexval" type="checkbox" class="form-control" name="Week29_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week30_maxindexval" type="checkbox" class="form-control" name="Week30"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week31_maxindexval" type="checkbox" class="form-control" name="Week31_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week32_maxindexval" type="checkbox" class="form-control" name="Week32_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week33_maxindexval" type="checkbox" class="form-control" name="Week33_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week34_maxindexval" type="checkbox" class="form-control" name="Week34_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week35_maxindexval" type="checkbox" class="form-control" name="Week35_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week36_maxindexval" type="checkbox" class="form-control" name="Week36_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week37_maxindexval" type="checkbox" class="form-control" name="Week37_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week38_maxindexval" type="checkbox" class="form-control" name="Week38_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week39_maxindexval" type="checkbox" class="form-control" name="Week39_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week40_maxindexval" type="checkbox" class="form-control" name="Week40"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week41_maxindexval" type="checkbox" class="form-control" name="Week41_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week42_maxindexval" type="checkbox" class="form-control" name="Week42_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week43_maxindexval" type="checkbox" class="form-control" name="Week43_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week44_maxindexval" type="checkbox" class="form-control" name="Week44_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week45_maxindexval" type="checkbox" class="form-control" name="Week45_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week46_maxindexval" type="checkbox" class="form-control" name="Week46_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week47_maxindexval" type="checkbox" class="form-control" name="Week47_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week48_maxindexval" type="checkbox" class="form-control" name="Week48_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week49_maxindexval" type="checkbox" class="form-control" name="Week49_"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week50_maxindexval" type="checkbox" class="form-control" name="Week50"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week51_maxindexval" type="checkbox" class="form-control" name="Week51"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week52_maxindexval" type="checkbox" class="form-control" name="Week52"></div></td>' +
        '<td   style="text-align: center;" title=""><div><input disabled id="Week53_maxindexval" type="checkbox" class="form-control" name="Week53"></div></td>'
}

function LinkClicked(id) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formppmplanner :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission) {
        action = "Edit"

    }
    else if (!hasEditPermission) {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#btnDelete').show();
    }

    if (action == 'View') {
        $("#formBemsBlock :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/PPMPlanner/Get/" + primaryId)
            .done(function (result) {
                debugger;
                var htmlval = "";
                var getResult = JSON.parse(result);
           
                $('#Year').val(getResult.Year);
                // $('#WorkGroup').val(getResult.WorkGroup);
                $('#WorkOrderType').val(getResult.WorkOrderType);
                //$('#hdnUserAreaId').val(getResult.UserAreaId);
                //$('#txtUserAreaCode').val(getResult.UserAreaCode);
                //$('#txtUserAreaName').val(getResult.UserAreaName);
                $('#hdnAssigneeId').val(getResult.AssigneeId);
                //    $('#txtAssignee').val(getResult.Assignee);
                //$('#hdnHospitalRepresentativeId').val(getResult.HospitalRepresentativeId);
                //$('#txtHospitalRepresentative').val(getResult.HospitalRepresentative);
                $('#AssetClarification').val(getResult.AssetClarification);
                $('#WarrentyType').val(getResult.WarrentyType);
                $('#hdnAssetTypeCodeId').val(getResult.AssetTypeCodeId);
                $('#txtAssetTypeCode').val(getResult.AssetTypeCode);
                $('#txtTypeCodeDetails').val(getResult.AssetTypeDescription);
                $('#PPMFrequencyValue').val(getResult.PPMFrequencyValue);
                $('#hdnAssetId').val(getResult.AssetRegisterId);
                $('#txtAssetNo').val(getResult.AssetNo);
                $('#txtModel').val(getResult.Model);
                $('#txtManufacturer').val(getResult.Manufacturer);
                $('#txtSerialNumber').val(getResult.SerialNumber);
                $('#hdnStandardTaskDetId').val(getResult.StandardTaskDetId);
               $('#Service').val(getResult.ServiceId);
                if (getResult.ServiceId == 1) {
                    $("#PPMFrequencyValue").val(getResult.PPMFrequency);
                    $('#textFemsTaskCode').show();
                    $('#textFemsTaskCode').css("visibility", 'visible');
                    $("#txtFemsTaskCode").hide();
                    $('#textFemsTaskCode').val(getResult.PPMTaskCode).prop("disabled", true);
                    $("#txtFemsTaskCode").attr("disabled", true);
                }
                    //$('#txtFemsTaskCode').append('<option value="' + value.LovId + '">' + txtFemsTaskCode + '</option>');
                
                else {
                    $('#txtTaskCode').val(getResult.PPMTaskCode);
                }
                $('#TaskCodeOption').val(getResult.TaskCodeOption);
                $('#txtAgreedDate').val(moment(getResult.AgreedDate).format("DD-MMM-YYYY")).prop("disabled", true);
                if (getResult.FirstDate == "0001-01-01T00:00:00")
                    getResult.FirstDate = null;
                if (getResult.NextDate == "0001-01-01T00:00:00")
                    getResult.NextDate = null;
                if (getResult.LastDate == "0001-01-01T00:00:00")
                    getResult.LastDate = null;
                if (getResult.FirstDate != null)
                    $('#txtFirstDate').val(moment(getResult.FirstDate).format("DD-MMM-YYYY"));
                if (getResult.NextDate != null)
                    $('#txtNextDate').val(moment(getResult.NextDate).format("DD-MMM-YYYY"));
                if (getResult.LastDate != null)
                    $('#txtLastDate').val(moment(getResult.LastDate).format("DD-MMM-YYYY"));
                $('#txtWarrentyEndDate').val(DateFormatter(getResult.WarrentyEndDate));
                $('#txtSupplierName').val(getResult.SupplierName);
                $('#txtContractEndDate').val(DateFormatter(getResult.ContractEndDate));
                $('#txtContractorName').val(getResult.ContractorName);
                $('#hdnEngineerId').val(getResult.AssigneeId);
                $('#txtEngineer').val(getResult.Assignee);
                $('#txtContactNumber').val(getResult.ContactNumber);
                $('#Schedule').val(getResult.Schedule);
                $('#Status').val(getResult.Status);
                $('#primaryID').val(getResult.PlannerId);

                var Date = getResult.Date && getResult.Date.split(',');
                //$.each(Date, function (i) {
                //    $('#Date option[value="' + Date[i] + '"]').prop('selected', true);
                //});
                $('#Date').val(Date);
                $("#Date").multiselect("refresh");

                setTimeout(function () {
                    $('.multiSelectDDLwithoutSearch').multiselect('rebuild');
                    $(".multiselect-container").find("input").prop("disabled", true);
                }, 500)

                var Months = (getResult.Month).split(",");
                for (i = 0; i < Months.length; i++) {
                    var result = getmonth(parseInt(Months[i]), 'Int');
                    $('#Check' + result).prop('checked', true);
                    montharray.push(parseInt(Months[i]));
                }

                var Weeks = (getResult.Week).split(",");
                for (i = 0; i < Weeks.length; i++) {
                    var result1 = getweek(parseInt(Weeks[i]), 'Int');
                    $('#Check' + result1).prop('checked', true);
                    weekarray.push(parseInt(Weeks[i]));
                }

                var Days = (getResult.Day).split(",");
                for (i = 0; i < Days.length; i++) {
                    var result2 = getday(parseInt(Days[i]), 'Int');
                    $('#Check' + result2).prop('checked', true);
                    dayarray.push(parseInt(Days[i]));
                }

                WarrentyChange();
                ScheduleChange();
                TaskCodeType();
                $('#WarrentyType').attr('disabled', true);
                $('#TaskCodeOption').attr('disabled', true);
                $('#txtAssetNo').attr('disabled', true);
                $('#spnPopup-assetNo').hide();
                $('#txtFirstDate').prop('disabled', true);
                $('#Year').attr('disabled', true);
                $('#Schedule').attr('disabled', true);

                $('#CheckJan').attr('disabled', true);
                $('#CheckFeb').attr('disabled', true);
                $('#CheckMar').attr('disabled', true);
                $('#CheckApr').attr('disabled', true);
                $('#CheckMay').attr('disabled', true);
                $('#CheckJun').attr('disabled', true);
                $('#CheckJul').attr('disabled', true);
                $('#CheckAug').attr('disabled', true);
                $('#CheckSep').attr('disabled', true);
                $('#CheckOct').attr('disabled', true);
                $('#CheckNov').attr('disabled', true);
                $('#CheckDec').attr('disabled', true);

                $('#CheckWeek1').attr('disabled', true);
                $('#CheckWeek2').attr('disabled', true);
                $('#CheckWeek3').attr('disabled', true);
                $('#CheckWeek4').attr('disabled', true);
                $('#CheckWeek5').attr('disabled', true);

                $('#CheckSun').attr('disabled', true);
                $('#CheckMon').attr('disabled', true);
                $('#CheckTue').attr('disabled', true);
                $('#CheckWed').attr('disabled', true);
                $('#CheckThu').attr('disabled', true);
                $('#CheckFri').attr('disabled', true);
                $('#CheckSat').attr('disabled', true);

                // $('.form-control multiSelectDDLwithoutSearch multi-check').attr('disabled', true);

                $('#myPleaseWait').modal('hide');
            })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsg').css('visibility', 'visible');
            });
    }
    else {
        $('#myPleaseWait').modal('hide');
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
            $.get("/api/PPMPlanner/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('PPMPlanner', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('PPMPlanner', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}

function EmptyFields() {
    $('#btnDelete').hide();
    $('input[type="text"], textarea').val('');
    $('input[type="hidden"]').val('');
    $('#txtAssetNo').attr('title', '');
    $("#Year").val(currentYear).trigger('change');
    $("#SummaryYear").val(currentYear);
    $('#WorkOrderType,#AssetClarification').val('null');
    $('#WarrentyType').val(0);
    $('#TypeOfPlanner').val(34);
    $('#Schedule').val(78);
    $('#Status').val(1);
    $('#TaskCodeOption').val(364);
    $('#txtAgreedDate').val('');
    $('#Date').val(null);
    $("#Date").multiselect("refresh");
    $('#CheckJan,#CheckFeb,#CheckMar,#CheckApr').prop('checked', false);
    $('#CheckMay,#CheckJun,#CheckJul,#CheckAug').prop('checked', false);
    $('#CheckSep,#CheckOct,#CheckNov,#CheckDec').prop('checked', false);
    $('#CheckWeek1,#CheckWeek2,#CheckWeek3,#CheckWeek4,#CheckWeek5').prop('checked', false);
    $('#CheckSun,#CheckMon,#CheckTue,#CheckWed,#CheckThu,#CheckFri,#CheckSat').prop('checked', false);
    $('#txtAgreedDate').attr('disabled', false);
    $('#CheckWeek1').attr('disabled', false);
    $('#CheckWeek2').attr('disabled', false);
    $('#CheckWeek3').attr('disabled', false);
    $('#CheckWeek4').attr('disabled', false);
    $('#CheckWeek5').attr('disabled', false);

    $('#CheckSun').attr('disabled', false);
    $('#CheckMon').attr('disabled', false);
    $('#CheckTue').attr('disabled', false);
    $('#CheckWed').attr('disabled', false);
    $('#CheckThu').attr('disabled', false);
    $('#CheckFri').attr('disabled', false);
    $('#CheckSat').attr('disabled', false);
    $('#txtAssetNo').attr('disabled', false);
    $('#spnPopup-assetNo').show();
    $('#Year').attr('disabled', false);
    $('#TaskCodeOption').attr('disabled', false);

    $('#blockCode,#Schedule').removeAttr("disabled")
    $('#spnActionType').text('Add');
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#primaryID').val('');
    $("#grid").trigger('reloadGrid');
    $("#formppmplanner :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('.nav-tabs a:first').tab('show');
    
    $("#txtFemsTaskCode").empty();

    WarrentyChange();
    ScheduleChange();
    TaskCodeType();
    $('#textFemsTaskCode').hide();
    $('#txtFemsTaskCode').show();
    
    $('#txtFirstDate').attr('disabled', false);
}

window.multiSelectshow = function () {
    $('select[name=Flag]').multiselect('destroy');
    $('select[name=Flag]').multiselect({ maxHeight: 200, maxWidth: 500, buttonWidth: '100%', includeSelectAllOption: true });

}

$("#exportbtn").click(function () {

    var id = 0;
    var grid = $('#grid');
    var filters = JSON.stringify({
        groupop: "and",
        rules: [
            { field: "PlannerId", op: "eq", data: $('#primaryID').val() }
        ]
    });
    var headerColumnNames = ['Work Order Type', 'Year', 'Assignee', 'Asset Classification', 'PPM Type', 'Type Code', 'Type Code Description', 'Asset No.', 'PPM Task Code',
        'Schedule', 'Status', 'Month', 'Date', 'Week', 'Day'];
    var mymodel = [{ key: true, label: 'Work Order Type', name: 'WorkOrderType', width: '10%' },
    { key: true, label: 'Year', name: 'Year', width: '10%' },
    { key: true, label: 'Assignee', name: 'Assignee', width: '10%' },
    { key: true, label: 'Asset Classification', name: 'AssetClassification', width: '14%' },
    { key: true, label: 'PPM Type', name: 'PPMType', width: '14%' },
    { key: true, label: 'Type Code', name: 'TypeCode', width: '14%' },
    { key: true, label: 'Type Code Description', name: 'TypeCodeDescription', width: '14%' },
    { key: true, label: 'Asset No.', name: 'AssetNo', width: '14%' },
    { key: true, label: 'PPM Task Code', name: 'PPMTaskCode', width: '14%' },
    { key: true, label: 'Schedule', name: 'Schedule', width: '14%' },
    { key: true, label: 'Status', name: 'Status', width: '14%' },
    { key: true, label: 'Month', name: 'Month', width: '14%' },
    { key: true, label: 'Date', name: 'Date', width: '14%' },
    { key: true, label: 'Week', name: 'Week', width: '14%' },
    { key: true, label: 'Day', name: 'Day', width: '14%' }
    ];
    var columnNames = [];
    $.each(mymodel, function (i) {
        if (this.hidden != true) {
            columnNames.push(this.name);
        }
    });
    var sortColumnName = "ModifiedDateUTC";
    var sortOrder = "desc";

    var screenTitle = $("#menu").find("li.active:last").text();
    var $downloadForm = $("<form method='POST'>")
        .attr("action", "/api/common/Export")
        .append($("<input name='filters' type='text'>").val(filters))
        .append($("<input name='sortOrder' type='text'>").val(sortOrder))
        .append($("<input name='columnNames' type='text'>").val(columnNames))
        .append($("<input name='sortColumnName' type='text'>").val(sortColumnName))
        .append($("<input name='headerColumnNames' type='text'>").val(headerColumnNames))
        .append($("<input name='screenName' type='text'>").val("PPMPlanner"))
        .append($("<input name='spName' type='text'>").val("uspFM_EngPlannerTxn_Export"))
        .append($("<input name='exportType' type='text'>").val("CSV"));

    $("body").append($downloadForm);
    var status = $downloadForm.submit();
    $downloadForm.remove();

    //}
});


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
        console.log(base64String);
        var obj1 = {
            contentType: filetype,
            contentAsBase64String: base64String,
            fileResponseName: filename
        };
        console.log(obj1);

        var jqxhr = $.post("/api/PPMPlanner/Upload", obj1, function (response) {
            $('#errorMsg').css('visibility', 'hidden');
            $(".content").scrollTop(0);
            showMessage('PPM Planner', CURD_MESSAGE_STATUS.IM);
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

function TaskCodeType() {
    var TaskCodeType = $('#TaskCodeOption').val();

    if (TaskCodeType === "365") {
        $('#ScheduleTypeHide').hide();
        $('#Schedule').prop('required', false);
        $('#HideMonth').hide();
        $('#HideDate').hide();
        $('#HideDay').hide();
        $('#HideWeek').hide();
        $('#FirstDateHide').show();
        $('#txtFirstDate').prop('required', true);
        $('#LastDateHide').show();
        $('#Year').attr('disabled', true);
        $('#txtFemsTaskCode').attr('disabled', false);
       
        
    }
    else if (TaskCodeType === "364") {
        $('#ScheduleTypeHide').show();
        $('#Schedule').prop('required', true);
        $('#FirstDateHide').hide();
        $('#txtFirstDate').prop('required', false);
        $('#LastDateHide').hide();
        $('#Year').attr('disabled', false);
        var Input = $("#Schedule option:selected").text();
        $('#txtFemsTaskCode').attr('disabled', true);
        $('#txtFemsTaskCode').val(0);
        $('#PPMFrequencyValue').val(0);
        
        if (Input === ' Monthly - Date') {
            $('#HideWeek').hide();
            $('#HideDay').hide();
            $('#HideDate').show();
            $('#HideMonth').show();
        }
        else if (Input === ' Monthly - Day') {
            $('#HideWeek').show();
            $('#HideDay').show();
            $('#HideMonth').show();
            $('#HideDate').hide();
        }
    }
}

