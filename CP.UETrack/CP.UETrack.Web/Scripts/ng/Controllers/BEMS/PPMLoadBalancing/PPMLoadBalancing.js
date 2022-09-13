$(document).ready(function ()
{
    $('#myPleaseWait').modal('show');

    var currentYear = null;


    formInputValidation("frmPPMLoadBalancing");

    $('.tdNos').parent().css('text-align', 'center');

    $.get("/api/pPMLoadBalancing/Load")
    .done(function (result) {
        $("#jQGridCollapse1").click();
        var loadResult = JSON.parse(result);
        $.each(loadResult.Years, function (index, value) {
            $('#selYear').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $('#selYear').val(loadResult.CurrentYear);
        currentYear = loadResult.CurrentYear;
        $('#myPleaseWait').modal('hide');
    })
  .fail(function (response) {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
      $('#errorMsg').css('visibility', 'visible');
  });
    
  
    $("#btnAddFetch").click(function () {
        $('#btnAddFetch').attr('disabled', true);
        ClearData();

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var isFormValid = formInputValidation("frmPPMLoadBalancing", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnAddFetch').attr('disabled', false);
            return false;
        }

        var assetClassification = $('#txtAssetClassification').val();
        var assetClassificationId = $('#hdnAssetClassificationId').val();
        if (assetClassification != null && assetClassification != '' && assetClassificationId == "")
        {
            $("div.errormsgcenter").text('Asset classification is invalid');
            $('#errorMsg').css('visibility', 'visible');

            $('#btnAddFetch').attr('disabled', false);
            return false;
        }

        var assigneeName = $('#txtAssignee').val();
        var assigneeId = $('#hdnStaffMasterId').val();
        if (assigneeName != null && assigneeName != '' && assigneeId == "") {
            $("div.errormsgcenter").text('Assignee is invalid');
            $('#errorMsg').css('visibility', 'visible');

            $('#btnAddFetch').attr('disabled', false);
            return false;
        }

        var userArea = $('#txtUserArea').val();
        var userAreaId = $('#hdnUserAreaId').val();
        if (userArea != null && userArea != '' && userAreaId == "") {
            $("div.errormsgcenter").text('User Area is invalid');
            $('#errorMsg').css('visibility', 'visible');

            $('#btnAddFetch').attr('disabled', false);
            return false;
        }

        var userLocation = $('#txtUserLocation').val();
        var userLocationId = $('#hdnUserLocationId').val();
        if (userLocation != null && userLocation != '' && userLocationId == "") {
            $("div.errormsgcenter").text('User Location is invalid');
            $('#errorMsg').css('visibility', 'visible');

            $('#btnAddFetch').attr('disabled', false);
            return false;
        }

        //if (assetClassificationId == "" && assigneeId == "" && userAreaId == "" && userLocationId == "") {
        //    $("div.errormsgcenter").text('Please select at least one condition (Asset Classification / Assignee / Area / Location)');
        //    $('#errorMsg').css('visibility', 'visible');

        //    $('#btnAddFetch').attr('disabled', false);
        //    return false;
        //}

        $('#myPleaseWait').modal('show');

        var fetchObj = {
            Year: $('#selYear').val(),
            AssetClassificationId: $('#hdnAssetClassificationId').val(),
            StaffMasterId: $('#hdnStaffMasterId').val(),
            UserAreaId: $('#hdnUserAreaId').val(),
            UserLocationId: $('#hdnUserLocationId').val()
        };

        var jqxhr = $.post("/api/pPMLoadBalancing/GetWorkOrderDetails", fetchObj, function (response) {
            var result = JSON.parse(response);
            FillData(result);
            ModifyCursorForZero();

            $('#btnAddFetch').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        },
   "json")
    .fail(function (response) {
        $("div.errormsgcenter").text(Messages.NO_RECORDS_TO_DISPLAY);
        RemoveBackgroundColor();
        $('#errorMsg').css('visibility', 'visible');
        $('#btnAddFetch').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
    });
    });

    function RemoveBackgroundColor() {
        $('#col1').css('background-color', '#ffffff')
        $('#col2').css('background-color', '#ffffff')
        $('#col3').css('background-color', '#ffffff')
        $('#col4').css('background-color', '#ffffff')
        $('#col5').css('background-color', '#ffffff')
        $('#col6').css('background-color', '#ffffff')
        $('#col7').css('background-color', '#ffffff')
        $('#col8').css('background-color', '#ffffff')
        $('#col9').css('background-color', '#ffffff')
        $('#col10').css('background-color', '#ffffff')
        $('#col11').css('background-color', '#ffffff')
        $('#col12').css('background-color', '#ffffff')
    }

    //$('#btnWorkOrderDetails, #btnWorkOrderDetails1').click(function () {
    //    $('#divWorkOrderDetails').modal('hide');
    //});

    $('.tdNos').click(function () {
        if ($(this).text() == "0")
        {
            return false;
        }
        var id = $(this).attr('id');
        var splitId = id.split('_');
        var month = splitId[1];
        var week = splitId[2];

        //if (week == 6) return false;

        var workOrdreObj = {
            Heading: "Work Order Details",
            ResultColumns: ["WorkOrderId-Primary Key", 'MaintenanceWorkNo-Work Order No.',
                            'AssetNo-Asset No.', 'AssetDescription-Asset Description',
                            'WorkOrderStatusValue-Status','Assignee-Assignee',
                            'TargetDateTime-Target Date', 'Timestamp-Timestamp'],
            Month: month,
            Week: week
        };

        DisplayEditablePopup('divWorkOrderPopup', workOrdreObj, "/api/pPMLoadBalancing/GetWorkOrders");
    });

    function ModifyCursorForZero()
    {
        $.each($('.tdNos'), function (index, value) {
            var id = '#' + value.id;

            var splitId = id.split('_');
            var month = splitId[1];
            var week = splitId[2];
            //if (week == 6) {
            //    $(id).css('cursor', 'default');
            //}
            //else {
                if ($(id).text() == "0") {
                    //$(id).unbind("click");
                    $(id).css('cursor', 'default');
                }
                else {
                    //$(id).bind("click");
                    $(id).css('cursor', 'pointer');
                }
            //}
        });
    }

    function FillData(result)
    {
        $('#txtTotalWorkOrders').val(result.TotalNoOfWorkOrders);
        $('#txtAverageWorkOrders').val(result.AverageNoOfWorkOrders);

        $('#Jan_1_1').text(result.Jan1);
        $('#Jan_1_2').text(result.Jan2);
        $('#Jan_1_3').text(result.Jan3);
        $('#Jan_1_4').text(result.Jan4);
        $('#Jan_1_5').text(result.Jan5);
        $('#Jan_1_6').text(result.Total1);

        $('#Feb_2_1').text(result.Feb1);
        $('#Feb_2_2').text(result.Feb2);
        $('#Feb_2_3').text(result.Feb3);
        $('#Feb_2_4').text(result.Feb4);
        $('#Feb_2_5').text(result.Feb5);
        $('#Feb_2_6').text(result.Total2);

        $('#Mar_3_1').text(result.Mar1);
        $('#Mar_3_2').text(result.Mar2);
        $('#Mar_3_3').text(result.Mar3);
        $('#Mar_3_4').text(result.Mar4);
        $('#Mar_3_5').text(result.Mar5);
        $('#Mar_3_6').text(result.Total3);

        $('#Apr_4_1').text(result.Apr1);
        $('#Apr_4_2').text(result.Apr2);
        $('#Apr_4_3').text(result.Apr3);
        $('#Apr_4_4').text(result.Apr4);
        $('#Apr_4_5').text(result.Apr5);
        $('#Apr_4_6').text(result.Total4);

        $('#May_5_1').text(result.May1);
        $('#May_5_2').text(result.May2);
        $('#May_5_3').text(result.May3);
        $('#May_5_4').text(result.May4);
        $('#May_5_5').text(result.May5);
        $('#May_5_6').text(result.Total5);

        $('#Jun_6_1').text(result.Jun1);
        $('#Jun_6_2').text(result.Jun2);
        $('#Jun_6_3').text(result.Jun3);
        $('#Jun_6_4').text(result.Jun4);
        $('#Jun_6_5').text(result.Jun5);
        $('#Jun_6_6').text(result.Total6);

        $('#Jul_7_1').text(result.Jul1);
        $('#Jul_7_2').text(result.Jul2);
        $('#Jul_7_3').text(result.Jul3);
        $('#Jul_7_4').text(result.Jul4);
        $('#Jul_7_5').text(result.Jul5);
        $('#Jul_7_6').text(result.Total7);

        $('#Aug_8_1').text(result.Aug1);
        $('#Aug_8_2').text(result.Aug2);
        $('#Aug_8_3').text(result.Aug3);
        $('#Aug_8_4').text(result.Aug4);
        $('#Aug_8_5').text(result.Aug5);
        $('#Aug_8_6').text(result.Total8);

        $('#Sep_9_1').text(result.Sep1);
        $('#Sep_9_2').text(result.Sep2);
        $('#Sep_9_3').text(result.Sep3);
        $('#Sep_9_4').text(result.Sep4);
        $('#Sep_9_5').text(result.Sep5);
        $('#Sep_9_6').text(result.Total9);

        $('#Oct_10_1').text(result.Oct1);
        $('#Oct_10_2').text(result.Oct2);
        $('#Oct_10_3').text(result.Oct3);
        $('#Oct_10_4').text(result.Oct4);
        $('#Oct_10_5').text(result.Oct5);
        $('#Oct_10_6').text(result.Total10);

        $('#Nov_11_1').text(result.Nov1);
        $('#Nov_11_2').text(result.Nov2);
        $('#Nov_11_3').text(result.Nov3);
        $('#Nov_11_4').text(result.Nov4);
        $('#Nov_11_5').text(result.Nov5);
        $('#Nov_11_6').text(result.Total11);

        $('#Dec_12_1').text(result.Dec1);
        $('#Dec_12_2').text(result.Dec2);
        $('#Dec_12_3').text(result.Dec3);
        $('#Dec_12_4').text(result.Dec4);
        $('#Dec_12_5').text(result.Dec5);
        $('#Dec_12_6').text(result.Total12);

        if(result.Total1 == result.AverageNoOfWorkOrders)
        {
            $('#col1').css('background-color', '#dbfccf')
        }
        if (result.Total1 > result.AverageNoOfWorkOrders) {
            $('#col1').css('background-color', '#ffa5a5')
        }
        if (result.Total1 < result.AverageNoOfWorkOrders) {
            $('#col1').css('background-color', '#fffbce')
        }

        if (result.Total2 == result.AverageNoOfWorkOrders) {
            $('#col2').css('background-color', '#dbfccf')
        }
        if (result.Total2 > result.AverageNoOfWorkOrders) {
            $('#col2').css('background-color', '#ffa5a5')
        }
        if (result.Total2 < result.AverageNoOfWorkOrders) {
            $('#col2').css('background-color', '#fffbce')
        }

        if (result.Total3 == result.AverageNoOfWorkOrders) {
            $('#col3').css('background-color', '#dbfccf')
        }
        if (result.Total3 > result.AverageNoOfWorkOrders) {
            $('#col3').css('background-color', '#ffa5a5')
        }
        if (result.Total3 < result.AverageNoOfWorkOrders) {
            $('#col3').css('background-color', '#fffbce')
        }

        if (result.Total4 == result.AverageNoOfWorkOrders) {
            $('#col4').css('background-color', '#dbfccf')
        }
        if (result.Total4 > result.AverageNoOfWorkOrders) {
            $('#col4').css('background-color', '#ffa5a5')
        }
        if (result.Total4 < result.AverageNoOfWorkOrders) {
            $('#col4').css('background-color', '#fffbce')
        }

        if (result.Total5 == result.AverageNoOfWorkOrders) {
            $('#col5').css('background-color', '#dbfccf')
        }
        if (result.Total5 > result.AverageNoOfWorkOrders) {
            $('#col5').css('background-color', '#ffa5a5')
        }
        if (result.Total5 < result.AverageNoOfWorkOrders) {
            $('#col5').css('background-color', '#fffbce')
        }

        if (result.Total6 == result.AverageNoOfWorkOrders) {
            $('#col6').css('background-color', '#dbfccf')
        }
        if (result.Total6 > result.AverageNoOfWorkOrders) {
            $('#col6').css('background-color', '#ffa5a5')
        }
        if (result.Total6 < result.AverageNoOfWorkOrders) {
            $('#col6').css('background-color', '#fffbce')
        }

        if (result.Total7 == result.AverageNoOfWorkOrders) {
            $('#col7').css('background-color', '#dbfccf')
        }
        if (result.Total7 > result.AverageNoOfWorkOrders) {
            $('#col7').css('background-color', '#ffa5a5')
        }
        if (result.Total7 < result.AverageNoOfWorkOrders) {
            $('#col7').css('background-color', '#fffbce')
        }

        if (result.Total8 == result.AverageNoOfWorkOrders) {
            $('#col8').css('background-color', '#dbfccf')
        }
        if (result.Total8 > result.AverageNoOfWorkOrders) {
            $('#col8').css('background-color', '#ffa5a5')
        }
        if (result.Total8 < result.AverageNoOfWorkOrders) {
            $('#col8').css('background-color', '#fffbce')
        }

        if (result.Total9 == result.AverageNoOfWorkOrders) {
            $('#col9').css('background-color', '#dbfccf')
        }
        if (result.Total9 > result.AverageNoOfWorkOrders) {
            $('#col9').css('background-color', '#ffa5a5')
        }
        if (result.Total9 < result.AverageNoOfWorkOrders) {
            $('#col9').css('background-color', '#fffbce')
        }

        if (result.Total10 == result.AverageNoOfWorkOrders) {
            $('#col10').css('background-color', '#dbfccf')
        }
        if (result.Total10 > result.AverageNoOfWorkOrders) {
            $('#col10').css('background-color', '#ffa5a5')
        }
        if (result.Total10 < result.AverageNoOfWorkOrders) {
            $('#col10').css('background-color', '#fffbce')
        }

        if (result.Total11 == result.AverageNoOfWorkOrders) {
            $('#col11').css('background-color', '#dbfccf')
        }
        if (result.Total11 > result.AverageNoOfWorkOrders) {
            $('#col11').css('background-color', '#ffa5a5')
        }
        if (result.Total11 < result.AverageNoOfWorkOrders) {
            $('#col11').css('background-color', '#fffbce')
        }

        if (result.Total12 == result.AverageNoOfWorkOrders) {
            $('#col12').css('background-color', '#dbfccf')
        }
        if (result.Total12 > result.AverageNoOfWorkOrders) {
            $('#col12').css('background-color', '#ffa5a5')
        }
        if (result.Total12 < result.AverageNoOfWorkOrders) {
            $('#col12').css('background-color', '#fffbce')
        }

    }

    function ClearData() {
        $('#txtTotalWorkOrders').val(null);
        $('#txtAverageWorkOrders').val(null);

        $('#Jan_1_1').text(null);
        $('#Jan_1_2').text(null);
        $('#Jan_1_3').text(null);
        $('#Jan_1_4').text(null);
        $('#Jan_1_5').text(null);
        $('#Jan_1_6').text(null);
                        
        $('#Feb_2_1').text(null);
        $('#Feb_2_2').text(null);
        $('#Feb_2_3').text(null);
        $('#Feb_2_4').text(null);
        $('#Feb_2_5').text(null);
        $('#Feb_2_6').text(null);
                        
        $('#Mar_3_1').text(null);
        $('#Mar_3_2').text(null);
        $('#Mar_3_3').text(null);
        $('#Mar_3_4').text(null);
        $('#Mar_3_5').text(null);
        $('#Mar_3_6').text(null);
                        
        $('#Apr_4_1').text(null);
        $('#Apr_4_2').text(null);
        $('#Apr_4_3').text(null);
        $('#Apr_4_4').text(null);
        $('#Apr_4_5').text(null);
        $('#Apr_4_6').text(null);
                        
        $('#May_5_1').text(null);
        $('#May_5_2').text(null);
        $('#May_5_3').text(null);
        $('#May_5_4').text(null);
        $('#May_5_5').text(null);
        $('#May_5_6').text(null);
                        
        $('#Jun_6_1').text(null);
        $('#Jun_6_2').text(null);
        $('#Jun_6_3').text(null);
        $('#Jun_6_4').text(null);
        $('#Jun_6_5').text(null);
        $('#Jun_6_6').text(null);
                        
        $('#Jul_7_1').text(null);
        $('#Jul_7_2').text(null);
        $('#Jul_7_3').text(null);
        $('#Jul_7_4').text(null);
        $('#Jul_7_5').text(null);
        $('#Jul_7_6').text(null);
                        
        $('#Aug_8_1').text(null);
        $('#Aug_8_2').text(null);
        $('#Aug_8_3').text(null);
        $('#Aug_8_4').text(null);
        $('#Aug_8_5').text(null);
        $('#Aug_8_6').text(null);
                        
        $('#Sep_9_1').text(null);
        $('#Sep_9_2').text(null);
        $('#Sep_9_3').text(null);
        $('#Sep_9_4').text(null);
        $('#Sep_9_5').text(null);
        $('#Sep_9_6').text(null);
                        
        $('#Oct_10_1').text(null);
        $('#Oct_10_2').text(null);
        $('#Oct_10_3').text(null);
        $('#Oct_10_4').text(null);
        $('#Oct_10_5').text(null);
        $('#Oct_10_6').text(null);
                        
        $('#Nov_11_1').text(null);
        $('#Nov_11_2').text(null);
        $('#Nov_11_3').text(null);
        $('#Nov_11_4').text(null);
        $('#Nov_11_5').text(null);
        $('#Nov_11_6').text(null);
                        
        $('#Dec_12_1').text(null);
        $('#Dec_12_2').text(null);
        $('#Dec_12_3').text(null);
        $('#Dec_12_4').text(null);
        $('#Dec_12_5').text(null);
        $('#Dec_12_6').text(null);
    }                   

    //------------------------Search----------------------------
    var assetClassificationSearchObj = {
        Heading: "Asset Classification Details",//Heading of the popup
        SearchColumns: ['AssetClassificationCode-Asset Classification Code', 'AssetClassificationDescription-Asset Classification Description'],
        ResultColumns: ["AssetClassificationId-Primary Key", 'AssetClassificationCode-Asset Classification Code', 'AssetClassificationDescription-Asset Classification Description'],
        FieldsToBeFilled: ["hdnAssetClassificationId-AssetClassificationId", "txtAssetClassification-AssetClassificationCode"]
    };

    $('#spnPopup-assetClassification').click(function ()
    {
        DisplaySeachPopup('divSearchPopup', assetClassificationSearchObj, "/api/Search/AssetClassificationCodeSearch");
    });

    var locationCodeSearchObj = {
        Heading: "Location Code Details",
        SearchColumns: ['UserLocationCode- Location Code', 'UserLocationName- Location Name'],
        ResultColumns: ["UserLocationId-Primary Key", 'UserLocationCode- Location Code', 'UserLocationName- Location Name', 'UserAreaCode- Area Code', 'UserAreaName- Area Name'],
        AdditionalConditions: ["UserAreaId-hdnUserAreaId"],
        FieldsToBeFilled: ["hdnUserLocationId-UserLocationId", "txtUserLocation-UserLocationName"]
    };

    $('#spnPopup-userLocation').click(function () {
        DisplaySeachPopup('divSearchPopup', locationCodeSearchObj, "/api/Search/LocationCodeSearch");
    });

    var userAreaSearchObj = {
        Heading: "User Area Details",//Heading of the popup
        SearchColumns: ['UserAreaCode- Area Code', 'UserAreaName- Area Name'],
        ResultColumns: ["UserAreaId-Primary Key", 'UserAreaCode- Area Code', 'UserAreaName- Area Name'],
        FieldsToBeFilled: ["hdnUserAreaId-UserAreaId", "txtUserArea-UserAreaName"]
    };

    $('#spnPopup-userArea').click(function () {
        DisplaySeachPopup('divSearchPopup', userAreaSearchObj, "/api/Search/UserAreaSearch");
    });
    

    var staffSearchObj = {
        Heading: "Staff Details",//Heading of the popup
        SearchColumns: ['StaffName-Staff Name', 'Designation-Designation'],//ModelProperty - Space seperated label value
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name', 'Designation-Designation'],//Columns to be returned for display
        FieldsToBeFilled: ["hdnStaffMasterId-StaffMasterId", "txtAssignee-StaffName"]//id of element - the model property
    };

    $('#spnPopup-assignee').click(function () {
        DisplaySeachPopup('divSearchPopup', staffSearchObj, "/api/Search/CompanyStaffSearch");
    });
    //----------------------------------------------------------

    //------------------------Fetch-----------------------------
    var assetClassificationFetchObj = {
        SearchColumn: 'txtAssetClassification-AssetClassificationCode',
        ResultColumns: ["AssetClassificationId-Primary Key", 'AssetClassificationCode-Asset Classification Code', 'AssetClassificationDescription-Asset Classification Description'],
        FieldsToBeFilled: ["hdnAssetClassificationId-AssetClassificationId", "txtAssetClassification-AssetClassificationCode"]
    };

    $('#txtAssetClassification').on('input propertychange paste keyup', function (event)
    {
        DisplayFetchResult('divAssetClassificationFetch', assetClassificationFetchObj, "/api/Fetch/AssetClassificationCodeFetch", "UlFetch", event, 1);
    });

    var userAreaFetchObj = {
        SearchColumn: 'txtUserArea-UserAreaCode',
        ResultColumns: ["UserAreaId-Primary Key", 'UserAreaCode-User Area Code', 'UserAreaName-User Area Name'],
        FieldsToBeFilled: ["hdnUserAreaId-UserAreaId", "txtUserArea-UserAreaName"]
    };

    $('#txtUserArea').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divUserAreaFetch', userAreaFetchObj, "/api/Fetch/UserAreaFetch", "UlFetch1", event, 1);
    });

    var locationCodeFetchObj = {
        SearchColumn: 'txtUserLocation-UserLocationCode',
        ResultColumns: ["UserLocationId-Primary Key", 'UserLocationCode-User Location Code', 'UserLocationName-User Location Name'],
        AdditionalConditions: ["UserAreaId-hdnUserAreaId"],
        FieldsToBeFilled: ["hdnUserLocationId-UserLocationId", "txtUserLocation-UserLocationName"]
    };

    $('#txtUserLocation').on('input propertychange paste keyup', function (event) {
        var userAreaId = $('#hdnUserAreaId').val();
        if (userAreaId != "null" && userAreaId != null) {
            var AdditionalConditions = ["UserAreaId-" + userAreaId]
        }
        DisplayFetchResult('divUserLocationFetch', locationCodeFetchObj, "/api/Fetch/LocationCodeFetch", "UlFetch2", event, 1);
    });

    var staffFetchObj = {
        SearchColumn: 'txtAssignee-StaffName',
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name', 'Designation-Designation'],
        FieldsToBeFilled: ["hdnStaffMasterId-StaffMasterId", "txtAssignee-StaffName"]
    };

    $('#txtAssignee').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divStaffMasterFetch', staffFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch3", event, 1);
    });
    //--------------------------------------------------------------------

    $('#hdnAssetClassificationId, #hdnUserAreaId, #hdnUserLocationId, #selYear').change(function () {
        ClearData();
    });

    $('#hdnUserAreaId').change(function () {
        $('#hdnUserLocationId').val(null);
        $('#txtUserLocation').val(null);
    });

    //$('#btnAddNew').click(function ()
    //    {
    //        window.location.reload();
    //    });

    $("#btnCancel").click(function ()
    {
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

    function EmptyFields() {
        $(".content").scrollTop(0);
        $('#hdnAssetClassificationId').val('');
        $('#txtAssetClassification').val('');
        $('#hdnStaffMasterId').val('');
        $('#txtAssignee').val('');
        $('#hdnUserAreaId').val('');
        $('#txtUserArea').val('');
        $('#hdnUserLocationId').val('');
        $('#txtUserLocation').val('');
        $("#selYear").val(currentYear);
        ClearData();
        RemoveBackgroundColor();
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
    }
 
});