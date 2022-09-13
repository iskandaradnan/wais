var geocoder;
var map;
var locations = [];
var directionsDisplay;
var directionsService = new google.maps.DirectionsService();
//var locations = [
//  ['Manly Beach', -33.80010128657071, 151.28747820854187, 2],
//  ['Bondi Beach', -33.890542, 151.274856, 4],
//  ['Coogee Beach', -33.923036, 151.259052, 5],
//  ['Maroubra Beach', -33.950198, 151.259302, 1],
//  ['Cronulla Beach', -34.028249, 151.157507, 3]
//];

function initialize1() {
    directionsDisplay = new google.maps.DirectionsRenderer();


    var map = new google.maps.Map(document.getElementById('map-canvas'), {
        zoom: 14,
        center: center,
        //center: new google.maps.LatLng(-33.92, 151.25),
        mapTypeId: google.maps.MapTypeId.ROADMAP
    });
    directionsDisplay.setMap(map);
    var infowindow = new google.maps.InfoWindow();

    var marker, i;
    var request = {
        travelMode: google.maps.TravelMode.DRIVING
    };
    for (i = 0; i < locations.length; i++) {
        marker = new google.maps.Marker({
            position: new google.maps.LatLng(locations[i].lat, locations[i].lng),
           // position: new google.maps.LatLng(locations[i][1], locations[i][2]),
            map: map
        });

        google.maps.event.addListener(marker, 'click', (function (marker, i) {
            return function () {
                infowindow.setContent(locations[i].DateTime);
                infowindow.open(map, marker);
            }
        })(marker, i));
        if (i == 0) request.origin = marker.getPosition();
        else if (i == locations.length - 1) request.destination = marker.getPosition();
        else {
            if (!request.waypoints) request.waypoints = [];
            request.waypoints.push({
                location: marker.getPosition(),
                stopover: true
            });
        }

    }
    var createMarkerFirst = function (data) {
        var marker = new google.maps.Marker({
            map: map,
            position: new google.maps.LatLng(data.lat, data.lng),
            icon: 'http://maps.google.com/mapfiles/ms/icons/green-dot.png'

        });


        // marker.name = data.StaffName;


        google.maps.event.addListener(marker, 'click', function () {
            infowindow.setContent('Start');
            infowindow.open(marker.get('map-canvas'), marker);
        });
    }
    var createMarkerLast = function (data) {
        var marker = new google.maps.Marker({
            map: map,
            position: new google.maps.LatLng(data.lat, data.lng),
            icon: 'http://maps.google.com/mapfiles/ms/icons/red.png'

        });


        // marker.name = data.StaffName;


        google.maps.event.addListener(marker, 'click', function () {
            infowindow.setContent('End');
            infowindow.open(marker.get('map-canvas'), marker);
        });
    }

    createMarkerFirst(First);
    createMarkerLast(Last);
    directionsService.route(request, function (result, status) {
        if (status == google.maps.DirectionsStatus.OK) {
            directionsDisplay.setDirections(result);
            var route = result.routes[0];
            var summaryPanel = document.getElementById('directions-panel');
            summaryPanel.innerHTML = '';
            // For each route, display summary information.
            for (var i = 0; i < route.legs.length; i++) {
                var routeSegment = i + 1;
                summaryPanel.innerHTML += '<b>Route Segment: ' + routeSegment +
                    '</b><br>';
                summaryPanel.innerHTML += route.legs[i].start_address + ' to ';
                summaryPanel.innerHTML += route.legs[i].end_address + '<br>';
                summaryPanel.innerHTML += route.legs[i].distance.text + '<br><br>';
            }
        }
    });
}


var EngineermappointLat = localStorage.getItem("MapcenterpointLat");
var EngineermappointLong = localStorage.getItem("MapcenterpointLong");
var center = new google.maps.LatLng(EngineermappointLat, EngineermappointLong);
var Data = [
      {
          name: 'UETrack - Karthick ',
          lat: 37.772,
          long: -122.214,
          address: 'Start'
      },

      {
          name: 'UETrack - Karthick ',
          lat: -27.467,
          long: 153.027,
          address: 'End'
      }
];
var Coordinates;
var First;
var Last;
var flightPlanCoordinates;
//flightPlanCoordinates = [
// { lat: 12.830789000000000, lng: 80.222404000000000, address: 'End', name: 'UETrack - Karthick '},
// { lat: 12.827316000000000, lng: 80.219282000000000, address: 'End', name: 'UETrack - Karthick ' },
// { lat: 12.844773000000000, lng: 80.225463000000000, address: 'End', name: 'UETrack - Karthick ' },
// { lat: 12.900987700000000, lng: 80.227930099999980, address: 'End', name: 'UETrack - Karthick ' }
//];

var Engineername = localStorage.getItem("Engineername");
document.getElementById("Engineername").innerHTML = 'UserName: ' + Engineername;
Engineertracking();
function Engineertracking() {
   
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
    var end_dd = dd - 2;

    var oneWeekAgo = new Date();
    oneWeekAgo.setDate(oneWeekAgo.getDate() - 2);
    mmm = oneWeekAgo.getMonth() + 1;
    ddd = oneWeekAgo.getDate();
    //  document.getElementById("DATE").value = today;
    //var startdate = yyyy + '-' + mm + '-' + end_dd + ' ' + hr + ':' + mm + ':' + sc + '.' + ms;
    var startdate = yyyy + '-' + mmm + '-' + ddd + ' ' + hr + ':' + mm + ':' + sc + '.' + ms;
    // var enddate = "2018-07-12 14:56:31.813";
    var ids = localStorage.getItem("id");
    var Engineerid = ids;
    $.get("/api/TrackingTechnician/GetEngineerByid?Engineerid=" + Engineerid + "&starDate=" + startdate + "&endDate=" + enddate)
                 .done(function (result) {
                  
                     flightPlanCoordinates = JSON.parse(result);

                     //
                     locations = JSON.parse(result);
                     Last = locations[locations.length - 1];
                     First = locations[0];
                     BindData(locations);
                     initialize1();
                 })
                 .fail(function () {

                 });
}
function initialize() {
    //  map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
    var map = new google.maps.Map(document.getElementById('map-canvas'),
        {
            zoom: 5,
            center: center,
            mapTypeId: 'terrain'
        });


    var flightPath = new google.maps.Polyline({
        path: flightPlanCoordinates,
        geodesic: true,
        strokeColor: '#FF0000',
        strokeOpacity: 1.0,
        strokeWeight: 4
    });

    flightPath.setMap(map);
    var infoWindow = new google.maps.InfoWindow();
    var createMarkerFirst = function (data) {
        var marker = new google.maps.Marker({
            map: map,
            position: new google.maps.LatLng(data.lat, data.lng),
            icon: 'http://maps.google.com/mapfiles/ms/icons/green-dot.png'

        });


        // marker.name = data.StaffName;


        google.maps.event.addListener(marker, 'click', function () {
            infoWindow.setContent('Start');
            infoWindow.open(marker.get('map-canvas'), marker);
        });
    }
    var createMarkerLast = function (data) {
        var marker = new google.maps.Marker({
            map: map,
            position: new google.maps.LatLng(data.lat, data.lng),
            icon: 'http://maps.google.com/mapfiles/ms/icons/red.png'

        });


        // marker.name = data.StaffName;


        google.maps.event.addListener(marker, 'click', function () {
            infoWindow.setContent('End');
            infoWindow.open(marker.get('map-canvas'), marker);
        });
    }

    createMarkerFirst(First);
    createMarkerLast(Last);

}
//google.maps.event.addDomListener(window, 'load', initialize);

function BindData(flightPlanCoordinates) {

    $.each(flightPlanCoordinates, function (index, value) {
        AddNewRowTrackDet();

        $('#Trackingdetaillon_' + index).val(flightPlanCoordinates[index].lat);
        $('#TrackingdetailLat_' + index).val(flightPlanCoordinates[index].lng);
        $('#TrackingdetailDate_' + index).val(flightPlanCoordinates[index].DateTime);


    });
}

function AddNewRow() {
    // $("div.errormsgcenter1").text("");
    // $('#errorMsg').css('visibility', 'hidden');
    // var rowCount = $('#EODTypeCodeMappingBody tr:last').index();
    AddNewRowTrackDet();
}

function AddNewRowTrackDet() {
    var inputpar = {
        inlineHTML: AddNewRowTrackDetHtml(),
        IdPlaceholderused: "maxindexval",
        TargetId: "#TrackingdetailTableGrid",
        TargetElement: ["tr"]
    }

    AddNewRowToDataGrid(inputpar);

    // formInputValidation("EODTypeCodeMappingScreen");
}

function AddNewRowTrackDetHtml() {

    return ' <tr class="ng-scope" style=""> <td width="40%" style="text-align: center;"><div> <input id="TrackingdetailDate_maxindexval"type="text" disabled class="form-control" name="SystemTypeDescription1" autocomplete="off" ></div></td>\
        <td width="30%" style="text-align: center;"><div> <input type="text" id="Trackingdetaillon_maxindexval" disabled name="SystemTypeCode" class="form-control" autocomplete="off"></div></td> \
                <td width="30%" style="text-align: center;"><div> <input id="TrackingdetailLat_maxindexval"type="text" disabled class="form-control" name="SystemTypeDescription" autocomplete="off" ></div></td>  </tr>'

}
