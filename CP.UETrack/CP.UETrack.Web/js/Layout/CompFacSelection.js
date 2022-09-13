var LOVCusValues = {};
var LOVFacValues = {};

$(document).ready(function () {

    $('#myPleaseWait').modal('show');

    $('#NotoficationSection').css('visibility', 'hidden');
    $('#NotoficationSection').hide();

    $.get("/api/layout/LoadCustomer")
       .done(function (result) {
           var loadCustomerResult = JSON.parse(result);
           //LOVValues = loadCustomerResult;
           //window.Customers = loadCustomerResult.Customers

           //$('#hdnDevelopmentMode').val(loadCustomerResult.IsDevelopmentMode);
           //$('#hdnDateFormat').val(loadCustomerResult.DateFormat);
           //$('#hdnCurrency').val(loadCustomerResult.Currency);
           //$('.spnCurrencyName').text(loadCustomerResult.Currency);

           $.each(loadCustomerResult.Customers, function (index, value) {
               $('#selCustomerLayoutSel').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
           });

           var selectCommand = 'Select Customer And Facility';

           if (loadCustomerResult.Customers.length == 1) {
               selectCommand = 'Select Facility';
               $('#selCustomerLayoutSel option[value="' + loadCustomerResult.Customers[0].LovId + '"]').prop('selected', true);

               var SelCus = $("#selCustomerLayoutSel").val();
               SelCus = parseInt(SelCus);

               $.get("/api/layout/LoadFacility/" + SelCus)
                 .done(function (result) {
                     var loadCustomerResult = JSON.parse(result);
                     //LOVFacValues = loadCustomerResult;
                     //window.Facilities = loadCustomerResult.Facilities

                     $('#selFacilityLayoutSel').empty().append('<option value="0">Select</option>');

                     $.each(loadCustomerResult.Facilities, function (index, value) {
                         $('#selFacilityLayoutSel').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                     });

                     if (loadCustomerResult.Facilities.length == 1) {
                         $('#selFacilityLayoutSel option[value="' + loadCustomerResult.Facilities[0].LovId + '"]').prop('selected', true);
                     }

                     $('#myPleaseWait').modal('hide');
                 })
           .fail(function () {
               $('#myPleaseWait').modal('hide');
               // console.error("Error Loading Customer, Facility");
           });
           }
           
           $('#spnSelectCommand').text(selectCommand);

           //UETrackConstants.customerId = loadCustomerResult.CustomerId;
           //UETrackConstants.facilityId = loadCustomerResult.FacilityId;
           //$('#selCustomerLayout').val(UETrackConstants.customerId).prop("selected", true);
           //$('#selFacilityLayout').val(UETrackConstants.facilityId).prop("selected", true);
           //$('#hdnFacilityId').val(UETrackConstants.facilityId);

           //if (loadCustomerResult.Customers.length == 1) {
           //    $('#selCustomerLayout').attr('disabled', true);
           //}
           //if (loadCustomerResult.Facilities.length == 1) {
           //    $('#selFacilityLayout').attr('disabled', true);
           //}
           $('#myPleaseWait').modal('hide');
       })
 .fail(function () {
     $('#myPleaseWait').modal('hide');
     console.error("Error Loading Customer, Facility");
 });


    
    $("#selCustomerLayoutSel").change(function () {

        var SelCus = $("#selCustomerLayoutSel").val();
        SelCus =  parseInt(SelCus);
     //   if (SelCus > 0) {
            $.get("/api/layout/LoadFacility/" + SelCus)
              .done(function (result) {
                  var loadCustomerResult = JSON.parse(result);
                  //LOVFacValues = loadCustomerResult;
                 // window.Facilities = loadCustomerResult.Facilities

                  //$('#hdnDevelopmentMode').val(loadCustomerResult.IsDevelopmentMode);
                  //$('#hdnDateFormat').val(loadCustomerResult.DateFormat);
                  //$('#hdnCurrency').val(loadCustomerResult.Currency);
                  //$('.spnCurrencyName').text(loadCustomerResult.Currency);

                  $('#selFacilityLayoutSel').empty().append('<option value="0">Select</option>');

                  $.each(loadCustomerResult.Facilities, function (index, value) {
                      $('#selFacilityLayoutSel').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                  });

                  //UETrackConstants.customerId = loadCustomerResult.CustomerId;
                  //UETrackConstants.facilityId = loadCustomerResult.FacilityId;
                  //$('#selCustomerLayout').val(UETrackConstants.customerId).prop("selected", true);
                  //$('#selFacilityLayout').val(UETrackConstants.facilityId).prop("selected", true);
                  //$('#hdnFacilityId').val(UETrackConstants.facilityId);

                  //if (loadCustomerResult.Customers.length == 1) {
                  //    $('#selCustomerLayout').attr('disabled', true);
                  //}
                  //if (loadCustomerResult.Facilities.length == 1) {
                  //    $('#selFacilityLayout').attr('disabled', true);
                  //}
                  $('#myPleaseWait').modal('hide');
             })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
           // console.error("Error Loading Customer, Facility");
        });
        //}
        //else {

        //    $('#selFacilityLayoutSel').empty().append('<option value="0">Select</option>');
        //    $('#btnlogin').attr('disabled', false);
        //    $('#myPleaseWait').modal('hide');
        //}

    });


    $("#selFacilityLayoutSel").change(function () {

        var SelCus = $("#selCustomerLayoutSel").val();
        var SelCusname = $("#selCustomerLayoutSel option:selected").text();
        SelCus = parseInt(SelCus);

        var SelFac = $("#selFacilityLayoutSel").val();
        var SelFacname = $("#selFacilityLayoutSel option:selected").text();
        SelFac = parseInt(SelFac);

        var objs = {
            CustomerId: SelCus,
            CustomerName:SelCusname,
            FacilityId: SelFac,
            FacilityName: SelFacname
        }


        var jqxhr = $.post("/api/layout/SetCustomerFacilityDet", objs, function (response) {
            //var result = JSON.parse(response);
            var result = response;
            $('#myPleaseWait').modal('hide');

            var SelFac = $("#selFacilityLayoutSel").val();
            if(SelFac > 0){
                window.location.href = "/Home/DashboardYtd";
            }
           

        })
     .fail(function () {
         $('#myPleaseWait').modal('hide');
         $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
         $('#errorMsg').css('visibility', 'visible');
     });



       // $.get("/api/layout/GetCustomerFacilityDet/" + SelCus + "/" + SelFac)
       //      .done(function (result) {
       //          var loadCustomerResult = JSON.parse(result);


       //          $('#myPleaseWait').modal('hide');
       //      })
       //.fail(function () {
       //    $('#myPleaseWait').modal('hide');
       //    // console.error("Error Loading Customer, Facility");
       //});


    });

    

    //$('#selFacilityLayout').change(function () {
    //    var customerId = $('#selCustomerLayout').val();
    //    var facilityId = $('#selFacilityLayout').val();
    //    var controlName = $('#hdnControllerName1').val();
    //    var message = "You will be redirected to the dashboard. Are you sure you want to proceed?";
    //    bootbox.confirm(message, function (result) {
    //        if (result) {
    //            //Assigning to Constants
    //            UETrackConstants.facilityId = facilityId;

    //            $.get("/api/layout/GetMenus/" + customerId + "/" + facilityId)
    //               .done(function (result) {
    //                   window.location.href = "/Home/Dashboard";
    //                   $('#myPleaseWait').modal('hide');
    //               })
    //            .fail(function () {
    //                $('#myPleaseWait').modal('hide');
    //                console.error("Error Loading Menu");
    //            });
    //        } else {
    //            $('#selFacilityLayout').val(UETrackConstants.facilityId).prop("selected", true);
    //        }
    //    });
    //});

    ////set side menu active
    //var locationHrefArray = window.location.pathname.split('/');
    //if (locationHrefArray.length > 2) {
    //    var locationHref = locationHrefArray[1].toLowerCase() + '/' + locationHrefArray[2].toLowerCase();
    //    $('#divSidebarMenu ul li').find('a[href="/' + locationHref + '"]').parents('li').each(function (i) {
    //        if (i == 0)
    //            $(this).find('>a').addClass('active');
    //        else
    //            $(this).find('>a').addClass('open');
    //    });
    //}



});