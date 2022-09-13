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
//    var UserId = 0;


//    (function () {
//        ChartOptions = {
//           // ChartType: 'variablepie',
//            ChartType: 'column',
            
//            RenderTo: 'AssetCategoryChart',
//            Legend: { enabled: true },
//            tooltip: {
//                formatter: function () {
//                    return '<span style="color:' + this.color + '">\u25CF</span> ' + this.key + ' : ' + addCommas(this.y);
//                }
//            }
//            //Series: [{
//            //    name: "Equipment Uptime",
//            //    data: [{
//            //        name: 'Genereal', y: 107, color: "#90ED7D"
//            //    }, {
//            //        name: 'Radialogy', y: 122, color: "#F7A35B"
//            //    }, {
//            //        name: 'Dialysis', y: 157, color: "#7CB5EC"
//            //    }, {
//            //        name: 'Life Support', y: 101, color: "#434348"
//            //    }, {
//            //        name: 'Therapeutic', y: 95, color: "#F45A5A"
//            //    }]
//            //}]
//        }
//        //CommonChart(ChartOptions);

//        $.get("/api/Dashboard/LoadAssetCategoryChart/" + StartYear + "/" + StartMonth + "/" + EndYear + "/" + EndMonth + "/" + FacilityId + "/" + UserId)
//        .done(function (result) {
//            var getResult = JSON.parse(result);
//            ChartOptions.Series = AssetCategorySeriesDataFormation(getResult);
//            ChartOptions.Err = ChartOptions.Series;
//            CommonChart(ChartOptions);
//        })
//        .fail(function () {
//            //ChartOptions.Err = 0;
//            //CommonChart(ChartOptions);
//        });

//    })();


//});

//function AssetCategorySeriesDataFormation(SeriesData, SeriesName) {

//    var colors = ['#90ED7D', '#F7A35B', '#7CB5EC', '#434348', '#F45A5A', '#CB2326', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#CB2326',
//        '#EEF475', '#C4C4B7', '#89EEB0', '#B5E678', '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
//   '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1']
//    var ar = [];
//    var Series = [{
//        name: SeriesName,
//        data: AssetCategorydataObj(SeriesData)
//    }];
//    return Series;
//}
//function AssetCategorydataObj(SeriesData) {
//    //var res;
//    var result = [];
//    if (SeriesData.AssetCategoryChartData && SeriesData.AssetCategoryChartData.length) {

//        for (var i = 0; i < SeriesData.AssetCategoryChartData.length; i++) {

//            var colors = ['#90ED7D', '#F7A35B', '#7CB5EC', '#434348', '#F45A5A', '#CB2326', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#CB2326',
//                    '#EEF475', '#C4C4B7', '#89EEB0', '#B5E678', '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
//               '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1']

//            //ar.push({ name: SeriesData.ContractorChartData[i].ConStatus, y: SeriesData.ContractorChartData[i].Count, color: colors[i] });
//            //Series.data.name = SeriesData[i].MonthName;
//            //Series.data.push(innerTemp);

//           //if (SeriesData.ContractorChartData[i].Count > 0) {
//            result.push({ name: SeriesData.AssetCategoryChartData[i].ConStatus, y: SeriesData.AssetCategoryChartData[i].Count, color: colors[i] });
//            //}
//            //else {
//            //    //aaa.push({});
//            //}


//        }
//        return result;
//    }
//    //else {
//    //    return [];
//    //}
//}

//function ChartColor(ind) {
//    var colors = ['#90ED7D', '#F7A35B', '#7CB5EC', '#434348', '#F45A5A', '#CB2326', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#CB2326',
//        '#EEF475', '#C4C4B7', '#89EEB0', '#B5E678', '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
//   '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1']

//    return colors[ind];
//}




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


    $.get("/api/Dashboard/LoadAssetCategoryChart/" + StartYear + "/" + StartMonth + "/" + EndYear + "/" + EndMonth + "/" + FacilityId + "/" + UserId)
              .done(function (result) {
                  var getResult = JSON.parse(result);

                  AssetCatChart(getResult);

              })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            var errorMessage = '';
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });

});

/********************************** Work order Chart ***********************************/

function AssetCatChart(loadResult) {
    var ChartOptions;

    (function () {
        ChartOptions = {
            ChartType: 'column',
            RenderTo: 'AssetCategoryChart',
            Legend: { enabled: false },
            tooltip: {
                formatter: function () {
                    return '<span style="color:' + this.color + '">\u25CF</span> ' + this.key + ' : ' + addCommas(this.y) +
                        '<br>'+ '<span style="color:' + this.color + '">\u25CF</span> ' + 'Perc' + ' : ' + addCommas(this.point.per) + ' %';
                }
            },
            Series: [{
                name: "Asset Category",
                color: "#8A8FEB",
                data: AssetCatdataOptions(loadResult)


            }]
        }
        CommonChart(ChartOptions);

    })();
}

function AssetCatdataOptions(loadResult) {

    var EquipmentCat = []; var ClassCount = []; var arr = []; var perc = [];
    for (ind = 0; ind < loadResult.AssetCategoryChartData.length; ind++) {
        EquipmentCat = loadResult.AssetCategoryChartData[ind].category;
        ClassCount = loadResult.AssetCategoryChartData[ind].Count;
        perc = loadResult.AssetCategoryChartData[ind].Percentage;
        Col = ChartColor(ind);
        arr.push({ name: EquipmentCat, y: ClassCount, per:perc,  color: Col });
    }
    return arr;
}

function ChartColor(ind) {
    var colors = ['#90ED7D', '#F7A35B', '#7CB5EC', '#434348', '#F45A5A', '#CB2326', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#CB2326',
        '#EEF475', '#C4C4B7', '#89EEB0', '#B5E678', '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
   '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1']

    return colors[ind];
}






