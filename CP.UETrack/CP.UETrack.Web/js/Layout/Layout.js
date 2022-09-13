var pagesize = 5;
var pageindex = 1;
var GridtotalRecords;
var TotalPages = 1, FirstRecord, LastRecord = 0;
var FacilityId = 0;
var userId = 0;
$(document).ready(function () {

    LoadNotification();

    GetNotificationCount(0,0);

    var facilityId = $('#selFacilityLayout').val();
    if (facilityId == null)
    {
        $("#divSidebarMenu").children().prop("disabled", true);
    }

    $('#myPleaseWait').modal('show');

    $.get("/api/layout/GetCustomerAndFacilities")
       .done(function (result) {
           var loadCustomerResult = result;
           $('#hdnDevelopmentMode').val(loadCustomerResult.IsDevelopmentMode);
           $('#hdnDateFormat').val(loadCustomerResult.DateFormat);
           $('#hdnCurrency').val(loadCustomerResult.Currency);
           $('.spnCurrencyName').text(loadCustomerResult.Currency);

           $.each(loadCustomerResult.Customers, function (index, value) {
               $('#selCustomerLayout').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
           });
           $.each(loadCustomerResult.Facilities, function (index, value) {
                $('#selFacilityLayout').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
           });

           UETrackConstants.customerId = loadCustomerResult.CustomerId;
           UETrackConstants.facilityId = loadCustomerResult.FacilityId;
           $('#selCustomerLayout').val(UETrackConstants.customerId).prop("selected",true);
           $('#selFacilityLayout').val(UETrackConstants.facilityId).prop("selected", true);
           
           if (loadCustomerResult.Customers.length == 1) {
               $('#selCustomerLayout').attr('disabled', true);
           }
           if (loadCustomerResult.Facilities.length == 1) {
               $('#selFacilityLayout').attr('disabled', true);
           }
           $('#myPleaseWait').modal('hide');
       })
 .fail(function () {
     $('#myPleaseWait').modal('hide');
     console.error("Error Loading Customer, Facility");
    });

    $('#selCustomerLayout').change(function () {
        var customerId = $('#selCustomerLayout').val();
        if (customerId == "null") {
            return false;
        }

        var message = "You will be redirected to the dashboard. Are you sure you want to proceed?";
        bootbox.confirm(message, function (result) {
            if (result) {                
                $.get("/api/layout/GetFacilities/" + customerId).done(function (result) {

                    $('#selFacilityLayout').children().remove();
                    var loadFacilityResult = result;
                    $.each(loadFacilityResult.Facilities, function (index, value) {
                        $('#selFacilityLayout').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                    });

                    $('#selCustomerLayout').val(loadFacilityResult.CustomerId).prop("selected", true);
                    $('#selFacilityLayout').val(loadFacilityResult.FacilityId).prop("selected", true);
                    //Assigning to Constants
                    UETrackConstants.customerId = loadFacilityResult.CustomerId;
                    UETrackConstants.facilityId = loadFacilityResult.FacilityId;

                    window.location.href = "/Home/DashboardYtd";
                    $('#myPleaseWait').modal('hide');
                })
                .fail(function () {
                    $('#myPleaseWait').modal('hide');
                    console.error("Error Loading Facility");
                });
            } else {
                $('#selCustomerLayout').val(UETrackConstants.customerId).prop("selected", true);
                $('#selFacilityLayout').val(UETrackConstants.facilityId).prop("selected", true);
            }
        });
    });

    $('#selFacilityLayout').change(function () {
        var customerId = $('#selCustomerLayout').val();
        var facilityId = $('#selFacilityLayout').val();
        var controlName = $('#hdnControllerName1').val();
        var message = "You will be redirected to the dashboard. Are you sure you want to proceed?";
        bootbox.confirm(message, function (result) {
            if (result) {
                //Assigning to Constants
                UETrackConstants.facilityId = facilityId;

                $.get("/api/layout/GetMenus/" + customerId + "/" + facilityId)
                   .done(function (result) {
                       window.location.href = "/Home/DashboardYtd";
                       $('#myPleaseWait').modal('hide');
                   })
                .fail(function () {
                    $('#myPleaseWait').modal('hide');
                    console.error("Error Loading Menu");
                });
            } else {
                $('#selFacilityLayout').val(UETrackConstants.facilityId).prop("selected", true);
            }
        });
    });

    //set side menu active
    var locationHrefArray = window.location.pathname.split('/');
    if (locationHrefArray.length > 2) {
        if (locationHrefArray[2] == 'assetqrcodereport') {
            locationHrefArray[2] = 'assetqrcodeprint';
        }
        else if (locationHrefArray[2] == 'departmentqrcodereport') {
            locationHrefArray[2] = 'departmentqrcodeprinting';
        }
        else if (locationHrefArray[2] == 'userlocationqrcodereport') {
            locationHrefArray[2] = 'userlocationqrcodeprinting';
        }
        else if (locationHrefArray[2] == 'scheduleworkorderreport') {
            locationHrefArray[2] = 'scheduledworkorder';
        }
        else if (locationHrefArray[2] == 'unscheduleworkorderprint') {
            locationHrefArray[2] = 'unscheduledworkorder';
        }
        else if (locationHrefArray[2] == 'ppmchecklistprint') {
            locationHrefArray[2] = 'scheduledworkorder';
        }
        var locationHref = locationHrefArray[1].toLowerCase() + '/' + locationHrefArray[2].toLowerCase();
        $('#divSidebarMenu ul li').find('a[href="/' + locationHref + '"]').parents('li').each(function (i) {
            if (i == 0)
                $(this).find('>a').addClass('active');
            else
                $(this).find('>a').addClass('open');
        });
    }




    /*************************** Notification table**********************************/
    $("#NotoficationLink").click(function () {
        var pagesize = 5;
        var pageindex = 1;
        $.get("/api/layout/GetNotification/" + pagesize + "/" + pageindex)
          .done(function (result) {
              var getResult = JSON.parse(result);

              BindNotificationData(getResult);
              ClearNotification();
          });


    });

});



function LoadNotification() {
    setInterval(LoadNotificationCount, 30000)
}

function LoadNotificationCount() {

    var userid = 0;
    var facilityid = 0;

    GetNotificationCount(userid, facilityid);
}

function GetNotificationCount(userid, facilityid) {

    // alert();
    $.get("/api/layout/GetNotificationCount/" + facilityid + "/" + userid)
                  .done(function (result) {
                    
                      //var getResult = JSON.parse(result);
                      notificationCount(result);

                      //  $('#myPleaseWait').modal('hide');
                  });
    //.fail(function () {
    //    $('#myPleaseWait').modal('hide');
    //    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
    //    $('#errorMsg').css('visibility', 'visible');
    //});
}

function notificationCount(getResult) {
    if (getResult.TotalCount > 0) {
        $('#NotificationCountSpan').text(getResult.TotalCount);
    }    
}

function ClearNotification() {

    var _index;
    $('#NotoficationTableBody tr').each(function () {
        _index = $(this).index();
    });
    var result = [];
        for (var i = 0; i <= _index; i++) {

            var _notificationGrid = {
                NotificationId: $('#hdnDashboardNotificationId_' + i).val(),
                IsNew: false                
            }
            result.push(_notificationGrid);
        }

        var obj = {
            NotificationgridData: result,
        }

        var jqxhr = $.post("/api/layout/ReseteNotificationCount", obj, function (response) {
            var result = JSON.parse(response);
            $('#NotificationCountSpan').text('');
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
                        $('#myPleaseWait').modal('hide');
                    });

}

function BindNotificationData(getResult) {
    $("#NotoficationTableBody").empty();
    if (getResult.NotificationgridData && getResult.NotificationgridData.length > 0) {
        $.each(getResult.NotificationgridData, function (index, value) {
            AddNewRowNotofication();
            $("#hdnDashboardNotificationId_" + index).val(getResult.NotificationgridData[index].NotificationId);

            var a = moment.utc(getResult.NotificationgridData[index].NotificationDateTime).toDate();
            $("#DashboardNotificationDate_" + index).val(moment(a).format("DD-MMM-YYYY HH:mm"));

            //$("#DashboardNotificationDate_" + index).val(moment(getResult.NotificationgridData[index].NotificationDateTime).format("DD-MMM-YYYY HH:mm"));
            //$("#DashboardNotificationDate_" + index).val(getResult.NotificationgridData[index].NotificationDateTime == null ? null : moment(getResult.NotificationgridData[index].NotificationDateTime).format("DD-MMM-YYYY"));
            $("#hdnDashboardNotificationUrl_" + index).val(getResult.NotificationgridData[index].URL);
            $("#hdnDashboardNotificationUrl1_" + index).val(getResult.NotificationgridData[index].URL);
            $("#DashboardNotificationDesc_" + index).val(getResult.NotificationgridData[index].Remarks);

            $("#DashboardNotificationDesc_" + index).attr('title', getResult.NotificationgridData[index].Remarks);
            $("#DashboardModule_" + index).val(getResult.NotificationgridData[index].Module);            
            $("#DescLink_" + index).val(getResult.NotificationgridData[index].URL);
            $("#hdnDashboardNotificationIsNew_" + index).val(getResult.NotificationgridData[index].IsNew);
        });
        GridtotalRecords = getResult.NotificationgridData[0].TotalRecords;
        TotalPages = getResult.NotificationgridData[0].TotalPages;
        LastRecord = getResult.NotificationgridData[0].LastRecord;
        FirstRecord = getResult.NotificationgridData[0].FirstRecord;
        pageindex = getResult.NotificationgridData[0].PageIndex;
        if (getResult.NotificationgridData.length > 0 && getResult.NotificationgridData.length == 5) {
            $('#paginationfooterNotification').show();
        }
        else {
            $('#paginationfooterNotification').hide();
        }
    }
    else {
        $("#NotoficationTableBody").empty();
        var emptyrow = '<tr><td width="100%"><h5 class="text-center">No Notifications</h5></td></tr>'
        $('#paginationfooterNotification').hide();
        $("#NotoficationTableBody ").append(emptyrow);
    }
    var mapIdproperty = ["NotificationId-hdnDashboardNotificationId_", "NotificationDateTime-DashboardNotificationDate_", "Module-DashboardModule_", "Remarks-DashboardNotificationDesc_", "IsNew-hdnDashboardNotificationIsNew_", "URL-hdnDashboardNotificationUrl_", "URL-hdnDashboardNotificationUrl1_", "URL-DescLink_"];
    var htmltext = AddNewRowNotoficationHtml();
    var obj = { formId: "#frmUserRegistration", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "Notificationlayout", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "NotificationgridData", tableid: '#NotoficationTableBody', destionId: "#paginationfooterNotification", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/layout/GetNotification/", pageindex: pageindex, pagesize: pagesize };
    CreateFooterPagination(obj);
}

function AddNewRowNotofication() {
    var inputpar = {
        inlineHTML: AddNewRowNotoficationHtml(),
        IdPlaceholderused: "maxindexval",
        TargetId: "#NotoficationTableBody",
        TargetElement: ["tr"]
    }

    AddNewRowToDataGrid(inputpar);

}

function AddNewRowNotoficationHtml() {
    //var redirectUrl= $('#hdnDashboardNotificationUrl_maxindexval').val();
    var row = '<tr class="ng-scope" style=""> <td width="20%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" readonly id="DashboardNotificationDate_maxindexval" class="form-control" autocomplete="off"></div> \
                                                <input type="hidden" width="0%" class="navigate-val" id="hdnDashboardNotificationId_maxindexval"> </td> \
                <td width="15%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" readonly id="DashboardModule_maxindexval" class="form-control" autocomplete="off"></div> </td> \
                <td width="50%" style="text-align:left;" data-original-title="" title=""><div><input type="text" readonly id="DashboardNotificationDesc_maxindexval" class="form-control" autocomplete="off" ><input type="hidden" id="hdnDashboardNotificationUrl_maxindexval"></div> \
                         <input type="hidden" id="hdnDashboardNotificationIsNew_maxindexval"></td> \
                    <td width="15%" style="text-align:left;" data-original-title="" title=""><div><button type="button"  id="DashboardNotificationNavigationSave_maxindexval" class="btn btn-primary customButton navigate-btn" onclick="redirect($(this).next().val(), this)"> Navigate</button> <input type="hidden" id="hdnDashboardNotificationUrl1_maxindexval"></div>\
                         </td></tr>';

    return row
}
function redirect(url, self) {
    location.href = url;


    //var _index;
    //$('#NotoficationTableBody tr').each(function () {
    //    _index = $(this).index();
    //});

    var result = [];
    //for (var i = 0; i <= _index; i++) {
        
    var nav_value = $(self).parent().parent().parent().find('.navigate-val').val();
        var _notificationGrid = {
            NotificationId: nav_value,
            Isnavigated: false
        }
        result.push(_notificationGrid);
    //}


    var obj = {
        NotificationgridData: result,
    }

    var jqxhr = $.post("/api/layout/ClearNavigatedRec", obj, function (response) {
        var result = JSON.parse(response);
        //$('#NotificationCountSpan').text('');
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
                       $('#myPleaseWait').modal('hide');
                   });
}

$("#HelpDescriptionLink").click(function () {
    var ScreenUrl = window.location.pathname.replace('/', '');
    var PostData = { ScreenUrl: ScreenUrl };
    $.post("/api/Common/GetHelpDescription/", PostData)
      .done(function (result) {
          var getResult = JSON.parse(result);
          BindDescription(getResult);
      })
     .fail(function () {
         $('#myPleaseWait').modal('hide');
         $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
         $('#errorMsg').css('visibility', 'visible');
     });


});

function BindDescription(getResult) {
    if (getResult.LovMasterGridData.length > 0) {
        $('#divPageHelp').html(getResult.LovMasterGridData[0].HelpDescription);
        $('#divPageHelpContainer').modal('show');
    }
    else {
        $('#divPageHelpContainer').modal('show');
    }
}
$('#btnhelpCancel, #btnhelpCancel1').click(function () {
    $('#divPageHelpContainer').modal('hide');
});
