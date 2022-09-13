var aaa = [];

$(document).ready(function () {

    $('#myPleaseWait').modal('show');

    var StartYear;
    var StartMonth;
    var EndYear;
    var EndMonth;

    StartMonth = $("#StartMonth").val();
    StartYear = $("#StartYear").val();
    EndMonth = $("#EndMonth").val();
    EndYear = $("#EndYear").val();

    //StartYear = (new Date).getFullYear();
    //StartMonth = (new Date).getMonth() + 1;
    //EndYear = (new Date).getFullYear();
    //EndMonth = (new Date).getMonth() + 1;
    var FacilityId = 0;
    var UserId = 0;


    $.get("/api/Dashboard/LoadKPIChart/" + StartYear + "/" + StartMonth + "/" + EndYear + "/" + EndMonth + "/" + FacilityId + "/" + UserId)
              .done(function (result) {
                  var getResult = JSON.parse(result);

                  KPIChartCall(getResult);

              })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            var errorMessage = '';
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });

});

/********************************** KPI Chart ***********************************/

function KPIChartCall(loadResult) {
    var ChartOptions;

    (function () {
        ChartOptions = {
            ChartType: 'bar',
            RenderTo: 'KPIChart',
            Legend: { enabled: false },
            tooltip: {
                //formatter: function () {
                //    return '<span style="color:' + this.color + '">\u25CF</span> ' + this.key + ' : ' + addCommas(this.y) + ' %';
                //}
                formatter: function () {
                    return '<span style="color:' + this.color + '">\u25CF</span> ' + this.key + ' : ' + addCommas(this.y) +
                        '<br>' + '<span style="color:' + this.color + '">\u25CF</span> ' + 'Perc' + ' : ' + addCommas(this.point.perc) + ' %';
                }
            },
            Series: [{
                name: "KPI",
                color: "#8A8FEB",
                data: KPIChartdataOptions(loadResult)

            }]
        }
        CommonChart(ChartOptions);

    })();
}

function KPIChartdataOptions(loadResult) {

    var EquipmentCat = []; var ClassCount = []; var arr = []; var perc = [];
    for (ind = 0; ind < loadResult.KPIChartValueData.length; ind++) {
        EquipmentCat = loadResult.KPIChartValueData[ind].KPIName;
        ClassCount = loadResult.KPIChartValueData[ind].Cost;
        perc = loadResult.KPIChartValueData[ind].KPIPerc;
        Col = ChartColor(ind);
        arr.push({ name: EquipmentCat, y: ClassCount, perc: perc, color: Col });
    }
    return arr;
}

function ChartColor(ind) {
    var colors = ['#90ED7D', '#F7A35B', '#7CB5EC', '#434348', '#F45A5A', '#CB2326', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#CB2326',
        '#EEF475', '#C4C4B7', '#89EEB0', '#B5E678', '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
   '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1']

    return colors[ind];
}






//var aaa = [];

//$(document).ready(function () {

//    $('#myPleaseWait').modal('show');

//    var StartYear;
//    var StartMonth;
//    var EndYear;
//    var EndMonth;



//    StartYear = (new Date).getFullYear();
//    StartMonth = (new Date).getMonth() + 1;
//    EndYear = (new Date).getFullYear();
//    EndMonth = (new Date).getMonth() + 1;
//    var FacilityId = 0;


//    $.get("/api/Dashboard/LoadEquipUptimeChart/" + StartYear + "/" + StartMonth + "/" + EndYear + "/" + EndMonth + "/" + FacilityId)
//              .done(function (result) {
//                  var getResult = JSON.parse(result);

//                  InitChartCall(getResult);

//              })
//        .fail(function () {
//            $('#myPleaseWait').modal('hide');
//            var errorMessage = '';
//            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
//            $('#errorMsg').css('visibility', 'visible');
//        });

//});

///********************************** Work order Chart ***********************************/

//function InitChartCall(loadResult) {
//    var ChartOptions;

//    (function () {
//        ChartOptions = {
//            ChartType: 'column',
//            RenderTo: 'KPIChart',
//            Legend: { enabled: true },
//            tooltip: {
//                formatter: function () {
//                    return '<span style="color:' + this.color + '">\u25CF</span> ' + this.key + ' : ' + addCommas(this.y) + ' %';
//                }
//            },
//            Series: [{
//                name: "KPI",
//                color: "#8A8FEB",
//                data: dataOptions(loadResult)

//            }]
//        }
//        CommonChart(ChartOptions);

//    })();
//}

//function dataOptions(loadResult) {

//    var EquipmentCat = []; var ClassCount = []; var arr = [];
//    for (ind = 0; ind < loadResult.EquipmentUptimeChartData.length; ind++) {
//        EquipmentCat = loadResult.EquipmentUptimeChartData[ind].EquipCat;
//        ClassCount = loadResult.EquipmentUptimeChartData[ind].Count;
//        Col = ChartColor(ind);
//        arr.push({ name: EquipmentCat, y: ClassCount, color: Col });
//    }
//    return arr;
//}

//function ChartColor(ind) {
//    var colors = ['#90ED7D', '#F7A35B', '#7CB5EC', '#434348', '#F45A5A', '#CB2326', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#CB2326',
//        '#EEF475', '#C4C4B7', '#89EEB0', '#B5E678', '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
//   '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1']

//    return colors[ind];
//}






