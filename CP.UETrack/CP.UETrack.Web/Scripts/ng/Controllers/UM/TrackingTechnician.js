//$(document).ready(function () {
GetCustomerandFacility();
var TrackingID;
//var center = new google.maps.LatLng(12.8302196, 80.1982426);
var center = new google.maps.LatLng(3.6114778, 101.4662673);
var Facilityicon = {
    url: 'http://eduetrackweb01.southeastasia.cloudapp.azure.com/uetrack-commonimages/facility2.png', // url
    scaledSize: new google.maps.Size(25, 25), // scaled size
    origin: new google.maps.Point(0, 0), // origin
    anchor: new google.maps.Point(0, 0) // anchor
};
var Engineericon = {
    url: 'http://eduetrackweb01.southeastasia.cloudapp.azure.com/uetrack-commonimages/fe1.png', // url
    scaledSize: new google.maps.Size(25, 25), // scaled size
    origin: new google.maps.Point(0, 0), // origin
    anchor: new google.maps.Point(0, 0) // anchor
};
var DataEng = null;
var DataFci = null;
var FciClat;
var FciClong;
var infoWindow;
var zoomlevel = 9;
var engineerfetch = "No";
var Formrefresh = "No";

RefreshEngineers();
initiazemap(zoomlevel);
var showengineer = "Show";

function GetCustomerandFacility() {
    $.get("/api/layout/GetCustomerAndFacilities")
   .done(function (result) {
       //var loadCustomerResult = JSON.parse(result);
       var loadCustomerResult = result;


       $.each(loadCustomerResult.Customers, function (index, value) {
           $('#ddlCustomerLayout').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
       });
       $.each(loadCustomerResult.Facilities, function (index, value) {
           $('#ddlFacilityLayout').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
       });
       UETrackConstants.customerId = loadCustomerResult.CustomerId;
       UETrackConstants.facilityId = loadCustomerResult.FacilityId;
       $('#ddlCustomerLayout').val(UETrackConstants.customerId).prop("selected", true);
       $('#ddlFacilityLayout').val(UETrackConstants.facilityId).prop("selected", true);
       GetEngineers();
       //$('#hdnFacilityId').val(UETrackConstants.facilityId);

       //if (loadCustomerResult.Customers.length == 1) {
       //    $('#ddlCustomerLayout').attr('disabled', true);
       //}
       //if (loadCustomerResult.Facilities.length == 1) {
       //    $('#ddlFacilityLayout').attr('disabled', true);
       //}

   })
.fail(function () {
    $('#myPleaseWait').modal('hide');
    console.error("Error Loading Customer, Facility");
})
}

$('#ddlCustomerLayout').change(function () {
    var customerId = $('#selCustomerLayout').val();
    if (customerId == "null") {
        return false;
    }

    $.get("/api/layout/GetFacilities/" + customerId).done(function (result) {

        //var loadFacilityResult = JSON.parse(result);
        $('#ddlFacilityLayout').children().remove();
        var loadFacilityResult = result;
        $.each(loadFacilityResult.Facilities, function (index, value) {
            $('#ddlFacilityLayout').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });

        $('#ddlCustomerLayout').val(loadFacilityResult.CustomerId).prop("selected", true);
        $('#ddlFacilityLayout').val(loadFacilityResult.FacilityId).prop("selected", true);
        //Assigning to Constants
        UETrackConstants.customerId = loadFacilityResult.CustomerId;
        UETrackConstants.facilityId = loadFacilityResult.FacilityId;

        window.location.href = "/";
        $('#myPleaseWait').modal('hide');
    })
    .fail(function () {
        $('#myPleaseWait').modal('hide');
        console.error("Error Loading Facility");
    });

});

function filterengineers() {
    var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth() + 1; //January is 0!
    var hr = today.getHours();
    var mn = today.getMinutes();
    var sc = today.getSeconds();
    var ms = today.getMilliseconds();
    var yyyy = today.getFullYear();
    if (dd < 10) {
        dd = '0' + dd;
    }
    if (mm < 10) {
        mm = '0' + mm;
    }
    // var enddate = dd + '-' + mm + '-' + yyyy + ' ' + hr + ':' + mm + ':' + sc + '.' + ms;
    var enddate = yyyy + '-' + mm + '-' + dd + ' ' + hr + ':' + mm + ':' + sc + '.' + ms;
    var end_dd = dd - 5;
    var oneWeekAgo = new Date();
    oneWeekAgo.setDate(oneWeekAgo.getDate() - 5);
    mmm = oneWeekAgo.getMonth() + 1;
    ddd = oneWeekAgo.getDate();
    //  document.getElementById("DATE").value = today;
    //var startdate = yyyy + '-' + mm + '-' + end_dd + ' ' + hr + ':' + mm + ':' + sc + '.' + ms;

    var startdate = yyyy + '-' + mmm + '-' + ddd + ' ' + hr + ':' + mm + ':' + sc + '.' + ms;

    // var enddate = "2018-07-12 14:56:31.813";   
    var customerid = $('#ddlCustomerLayout').val();
    var facilityid = $('#ddlFacilityLayout').val();
    var staffname = $('#txtstaffname').val();
    var staffId = $('#hdnTrackTechStfAssId').val();
    var username = $('#txtusername').val();

    ;
    var Formrefresh = "No";
    //$.get("/api/TrackingTechnician/GetAll?starDate=" + startdate + "&endDate=" + enddate + "&customerid=" + customerid + "&facilityid=" + facilityid + "&staffname=" + staffname + "&username=" + username)
    $.get("/api/TrackingTechnician/GetAll?starDate=" + startdate + "&endDate=" + enddate + "&customerid=" + customerid + "&facilityid=" + facilityid + "&staffid=" + staffId)
             .done(function (result) {
                 engineerfetch = "Yes";


                 DataEng = JSON.parse(result);

                 GetFacility();
                 if (DataEng.length > 0) {

                 }
                 else {
                     bootbox.alert("Alert!. Technician not available Clock in");
                 }
                 engineerfetch = "No";
                 // $('#hdnTrackTechStfAssId').val('');
             })
             .fail(function () {
                 var today = new Date();
                 DataEng = null;
                 GetFacility();
             });
}
function RefreshEngineers() {
    setInterval(LoadRefreshEngineers, 30000)
}

function LoadRefreshEngineers() {
    Formrefresh = "Yes";
    GetEngineers();
}
function GetEngineers() {
    var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth() + 1; //January is 0!
    var hr = today.getHours();
    var mn = today.getMinutes();
    var sc = today.getSeconds();
    var ms = today.getMilliseconds();
    var yyyy = today.getFullYear();
    if (dd < 10) {
        dd = '0' + dd;
    }
    if (mm < 10) {
        mm = '0' + mm;
    }
    // var enddate = dd + '-' + mm + '-' + yyyy + ' ' + hr + ':' + mm + ':' + sc + '.' + ms;
    var enddate = yyyy + '-' + mm + '-' + dd + ' ' + hr + ':' + mm + ':' + sc + '.' + ms;
    var end_dd = dd - 5;
    var oneWeekAgo = new Date();
    oneWeekAgo.setDate(oneWeekAgo.getDate() - 5);
    mmm = oneWeekAgo.getMonth() + 1;
    ddd = oneWeekAgo.getDate();
    //  document.getElementById("DATE").value = today;
    var startdate = yyyy + '-' + mmm + '-' + ddd + ' ' + hr + ':' + mm + ':' + sc + '.' + ms;
    // var enddate = "2018-07-12 14:56:31.813";
    //var customerid = "";
    //var facilityid = "";
    //var staffname = "";
    //var username = "";
    var customerid = $('#ddlCustomerLayout').val();
    var facilityid = $('#ddlFacilityLayout').val();
    // var staffId = $('#hdnTrackTechStfAssId').val();
    //if (staffId == "") {
    staffId = 0;
    //  }

    //  $.get("/api/TrackingTechnician/GetAll?starDate=" + startdate + "&endDate=" + enddate + "&customerid=" + customerid + "&facilityid=" + facilityid + "&staffname=" + staffname + "&username=" + username)
    $.get("/api/TrackingTechnician/GetAll?starDate=" + startdate + "&endDate=" + enddate + "&customerid=" + customerid + "&facilityid=" + facilityid + "&staffid=" + staffId)
    .done(function (result) {

        DataEng = JSON.parse(result);
        GetFacility();
    })
             .fail(function () {
                 GetFacility();
                 var today = new Date();
             });
}
function GetFacility() {

    $.get("/api/TrackingTechnician/GetFacility")
             .done(function (result) {

                 DataFci = JSON.parse(result);
                 initialize();
             })
             .fail(function () {

             });
}

function myFunction() {

    var checkBox = document.getElementById("DisplayFacility");
    if (checkBox.checked == true) {
        showengineer = "Hide";
        initialize();
    }
    else {
        showengineer = "Show";
        initialize();
        //initializeHospital();

    }
}
function myFunctions() {

    var checkBox = document.getElementById("DisplayFacility");

    initializeHospitalRadius();

}
function initiazemap(zoomlevel) {

    var mapOptions = {
        zoom: zoomlevel,
        center: center,
        mapTypeId: 'terrain'
    };

    map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
    infoWindow = new google.maps.InfoWindow();

}


function initialize() {
    clearMarkers();
    if (DataEng.length > 0) {
        for (i = 0; i < DataEng.length; i++) {


            if (engineerfetch == "Yes") {
                center = new google.maps.LatLng(DataEng[i].Latitude, DataEng[i].Longitude);
                //zoomlevel = 12;
                //initiazemap(zoomlevel);
                map.setZoom(15);
                map.setCenter(center);
                engineerfetch = "No"
            }
            addMarkerEng(DataEng[i]);

        }
    }
    else {
        if (Formrefresh == "No") {
            //  bootbox.alert("Alert!. Technician not available Clock in");
        }

    }
    var checkBox = document.getElementById("DisplayFacility");
    if (checkBox.checked == true) {
        if (DataFci.length > 0) {
            for (i = 0; i < DataFci.length; i++) {
                addMarkerFci(DataFci[i]);
            }
        }

    }
    else {
        if (DataFci.length > 0) {
            for (i = 0; i < DataFci.length; i++) {
                var facilityid = $('#ddlFacilityLayout').val();
                var currentfacilityid = DataFci[i].FacilityId;
                if (facilityid == currentfacilityid) {
                    addMarkerFci(DataFci[i]);
                }

            }
        }
    }







}
function addMarkerEng(data) {
    var marker = new google.maps.Marker({
        position: new google.maps.LatLng(data.Latitude, data.Longitude),
        map: map,
        icon: Engineericon
    });
    markers.push(marker);
    marker.name = data.StaffName;

    google.maps.event.addListener(marker, 'click', function () {
        infoWindow.setContent('<div style="width:250px" class="infoWindowContent"><h5 style="color:#1a206d;background: #fff;height: 30px;"> ' + marker.name + '</h5><br><a onclick="Engineertracking()">View Tracking</a></div>');
        localStorage.setItem("id", data.UserRegistrationId);
        localStorage.setItem("MapcenterpointLat", data.Latitude);
        localStorage.setItem("MapcenterpointLong", data.Longitude);
        localStorage.setItem("Engineername", data.StaffName);
        infoWindow.open(marker.get('map-canvas'), marker);
    });

}
function addMarkerFci(data) {
    var marker = new google.maps.Marker({
        position: new google.maps.LatLng(data.Latitude, data.Longitude),
        map: map,
        icon: Facilityicon
    });
    markers.push(marker);
    marker.name = data.FacilityName;

    google.maps.event.addListener(marker, 'click', function () {
        infoWindow.setContent('<div style="width:250px" class="infoWindowContent"><h5 style="color:#1a206d;background: #fff;height: 30px;"> ' + marker.name + '</h5><a onclick="myFunctions()">View Radius</a></div>');
        FciClat = data.Latitude;
        FciClong = data.Longitude;


        //  infoWindow.setContent('<div style="width:250px" class="infoWindowContent"><h3 style="color:#1a206d;background: #fff;height: 30px;"> ' + marker.name + '</h3><br></div>');
        infoWindow.open(marker.get('map-canvas'), marker);
    });
}

var markers = [];
var circles = [];
function setMapOnAll(map) {
    for (var i = 0; i < markers.length; i++) {
        markers[i].setMap(map);
    }
}

// Removes the markers from the map, but keeps them in the array.
function clearMarkers() {
    setMapOnAll(null);
}
function showMarkers() {
    setMapOnAll(map);
}
function initializeHospitalRadius() {
    removeAllcircles();
    var cityCircle;
    // cityCircle.Setmap(null);
    cityCircle = new google.maps.Circle({
        strokeColor: '#FF0000',
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: '#FF0000',
        fillOpacity: 0.35,
        map: map,
        center: { lat: FciClat, lng: FciClong },
        radius: Math.sqrt(10000) * 100
    });
    center = new google.maps.LatLng(FciClat, FciClong);
    //zoomlevel = 12;
    //initiazemap(zoomlevel);
    map.setZoom(11);
    map.setCenter(center);
    circles.push(cityCircle);
    var createMarkerEng = function (data) {


        var marker = new google.maps.Marker({
            map: map,
            position: new google.maps.LatLng(data.Latitude, data.Longitude),
            icon: Engineericon

        });

        marker.name = data.StaffName;

        google.maps.event.addListener(marker, 'click', function () {
            infoWindow.setContent('<div style="width:250px" class="infoWindowContent"><h5 style="color:#1a206d;background: #fff;height: 30px;"> ' + marker.name + '</h5><br><a onclick="Engineertracking()">View Tracking</a></div>');
            localStorage.setItem("id", data.UserRegistrationId);
            localStorage.setItem("Engineername", data.StaffName);
            // infoWindow.setContent('<div style="width:250px" class="infoWindowContent"><h3 style="color:#1a206d;background: #fff;height: 30px;"> ' + marker.name + '</h3><br></div>');
            infoWindow.open(marker.get('map-canvas'), marker);
        });
    }
    var createMarkerFci = function (data) {


        var marker = new google.maps.Marker({
            map: map,
            position: new google.maps.LatLng(data.Latitude, data.Longitude),
            icon: Facilityicon

        });

        marker.name = data.FacilityName;

        google.maps.event.addListener(marker, 'click', function () {

            infoWindow.setContent('<div style="width:250px" class="infoWindowContent"><h5 style="color:#1a206d;background: #fff;height: 30px;"> ' + marker.name + '</h5><a onclick="myFunctions()">View Radius</a></div>');
            FciClat = data.Latitude;
            FciClong = data.Longitude;
            infoWindow.open(marker.get('map-canvas'), marker);
        });
    }



    if (checkBox.checked == true) {
        if (DataFci.length > 0) {
            for (i = 0; i < DataFci.length; i++) {
                createMarkerFci(DataFci[i]);
            }
        }

    }
    else {
        if (DataFci.length > 0) {
            for (i = 0; i < DataFci.length; i++) {
                var facilityid = $('#ddlFacilityLayout').val();
                var currentfacilityid = DataFci[i].FacilityId;
                if (facilityid == currentfacilityid) {
                    createMarkerFci(DataFci[i]);
                }

            }
        }
    }
    if (showengineer == "Show") {
        for (i = 0; i < DataEng.length; i++) {
            createMarkerEng(DataEng[i]);
        }
    }

}
function removeAllcircles() {
    for (var i in circles) {
        circles[i].setMap(null);
    }
    circles = []; // this is if you really want to remove them, so you reset the variable.
}
function initializeHospital() {
    clearMarkers();

    for (i = 0; i < DataEng.length; i++) {
        addMarkerEng(DataEng[i]);
    }
}

function Engineertracking() {
    window.location.href = "/um/TrackingTechnician/Tracking";
}

function FetchTTStaff(event) {

    $('#TrackTechStaffFetch').css({
        'width': $('#txtstaffname').outerWidth()
    });
    var ItemMst = {
        SearchColumn: 'txtstaffname' + '-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId" + "-Primary Key", 'StaffName' + '-txtstaffname'],//Columns to be displayed
        // AdditionalConditions: ["TypeOfRequest-crmWorkReqTyp"],
        FieldsToBeFilled: ["hdnTrackTechStfAssId" + "-StaffMasterId", 'txtstaffname' + '-StaffName']//id of element - the model property
    };
    DisplayFetchResult('TrackTechStaffFetch', ItemMst, "/api/Fetch/CompanyStaffFetch", "Ulfetch", event, 1);

}
//});