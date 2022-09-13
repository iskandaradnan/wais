var aaa=[];

$(document).ready(function () {

    $('#myPleaseWait').modal('show');

    var StartYear;
    var StartMonth;
    var EndYear;
    var EndMonth;
    
    

    StartYear = (new Date).getFullYear();
    StartMonth = (new Date).getMonth() + 1;
    EndYear = (new Date).getFullYear();
    EndMonth = (new Date).getMonth() + 1;
    var FacilityId = 0;


    $.get("/api/HomeDashboard/LoadWorkorderChart/" + StartYear + "/" + StartMonth + "/" + EndYear + "/" + EndMonth + "/" + FacilityId)
           .done(function (result) {
               var getResult = JSON.parse(result);

               WorkOrderChart(getResult);

               //$.get("/api/HomeDashboard/LoadMaintCostChart/" + StartYear + "/" + StartMonth + "/" + EndYear + "/" + EndMonth + "/" + FacilityId)
               //      .done(function (result) {
               //          var getResult = JSON.parse(result);

               //          MainCostChart(getResult);

               //     // $.get("/api/HomeDashboard/LoadMaintCostChart/" + StartYear + "/" + StartMonth + "/" + EndYear + "/" + EndMonth)


               //          $('#myPleaseWait').modal('hide');
               //      })
               //     .fail(function () {
               //         $('#myPleaseWait').modal('hide');
               //         $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
               //         $('#errorMsg').css('visibility', 'visible');
               //     });
           })
     .fail(function () {
         $('#myPleaseWait').modal('hide');
         var errorMessage = '';
         $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
         $('#errorMsg').css('visibility', 'visible');
     });

    /**************************************************************Load Maintenance Cost Chart ************************************************************************/

    $.get("/api/HomeDashboard/LoadMaintCostChart/" + StartYear + "/" + StartMonth + "/" + EndYear + "/" + EndMonth + "/" + FacilityId)
                    .done(function (result) {
                        var getResult = JSON.parse(result);

                        MainCostChart(getResult);

                        // $.get("/api/HomeDashboard/LoadMaintCostChart/" + StartYear + "/" + StartMonth + "/" + EndYear + "/" + EndMonth)


                        $('#myPleaseWait').modal('hide');
                    })
                   .fail(function () {
                       $('#myPleaseWait').modal('hide');
                       $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                       $('#errorMsg').css('visibility', 'visible');
                   });


    //(function () {
    //    ChartOptions = {
    //        ChartType: 'pie',
    //        RenderTo: 'MaintenanceCostChart',
    //        customDataLabels: "RM",
    //        Legend: { enabled: true },
    //        tooltip: {
    //            formatter: function () {
    //                return '<span style="color:' + this.color + '">\u25CF</span> ' + this.key + ' : ' + "RM " + addCommas(this.y.toFixed(2));
    //            }
    //        }
    //        }
    //        //Series: [{
    //        //    name: "Equipment Uptime",
    //        //    data: [{
    //        //        name: 'Genereal', y: 107, color: "#90ED7D"
    //        //    }, {
    //        //        name: 'Radialogy', y: 122, color: "#F7A35B"
    //        //    }, {
    //        //        name: 'Dialysis', y: 157, color: "#7CB5EC"
    //        //    }, {
    //        //        name: 'Life Support', y: 101, color: "#434348"
    //        //    }, {
    //        //        name: 'Therapeutic', y: 95, color: "#F45A5A"
    //        //    }]
    //        //}]
        
    //    //CommonChart(ChartOptions);

    //   $.get("/api/HomeDashboard/LoadMaintCostChart/" + StartYear + "/" + StartMonth + "/" + EndYear + "/" + EndMonth + "/" + FacilityId)
    //    .done(function (result) {
    //        var getResult = JSON.parse(result);
    //        ChartOptions.Series = MaintanenceCostDataFormation(getResult, "Maintanence Cost");
    //        ChartOptions.Err = ChartOptions.Series;
    //        CommonChart(ChartOptions);
    //    })
    //    .fail(function () {
    //        //ChartOptions.Err = 0;
    //        //CommonChart(ChartOptions);
    //    });

    //})();



    /**************************************************************Load Asset Chart ************************************************************************/
    $.get("/api/HomeDashboard/LoadAssetChart/" + StartYear + "/" + StartMonth + "/" + EndYear + "/" + EndMonth + "/" + FacilityId)
       .done(function (result) {
           var getResult = JSON.parse(result);

           LoadAssetChart(getResult);

       })
 .fail(function () {
     $('#myPleaseWait').modal('hide');
     var errorMessage = '';
     $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
     $('#errorMsg').css('visibility', 'visible');
 });

    /************************************************************** Load Equipment Chart ******************************************************************/
    $.get("/api/HomeDashboard/LoadEquipUptimeChart/" + StartYear + "/" + StartMonth + "/" + EndYear + "/" + EndMonth + "/" + FacilityId)
   .done(function (result) {
       var getResult = JSON.parse(result);

       EquipUptimeChart(getResult);

   })
.fail(function () {
    $('#myPleaseWait').modal('hide');
    var errorMessage = '';
    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
    $('#errorMsg').css('visibility', 'visible');
});

    /************************************************************** AssetAge Chart ******************************************************************/
    $.get("/api/HomeDashboard/LoadAssetAgeChart/" + StartYear + "/" + StartMonth + "/" + EndYear + "/" + EndMonth + "/" + FacilityId)
   .done(function (result) {
       var getResult = JSON.parse(result);

       AssetAgeChart(getResult);

   })
.fail(function () {
    $('#myPleaseWait').modal('hide');
    var errorMessage = '';
    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
    $('#errorMsg').css('visibility', 'visible');
});



    /************************************************************** Load Contract Chart ******************************************************************/
//    $.get("/api/HomeDashboard/LoadContChart/" + StartYear + "/" + StartMonth + "/" + EndYear + "/" + EndMonth + "/" + FacilityId)
//   .done(function (result) {
//       var getResult = JSON.parse(result);

//       ContChart(getResult);

//   })
//.fail(function () {
//    $('#myPleaseWait').modal('hide');
//    var errorMessage = '';
//    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
//    $('#errorMsg').css('visibility', 'visible');
//    });








    (function () {
        ChartOptions = {
            ChartType: 'variablepie',
            RenderTo: 'ContractorChart',
            Legend: { enabled: true },
            tooltip: {
                                formatter: function () {
                                    return '<span style="color:' + this.color + '">\u25CF</span> ' + this.key + ' : ' + addCommas(this.y);
                                }
                            }
            //Series: [{
            //    name: "Equipment Uptime",
            //    data: [{
            //        name: 'Genereal', y: 107, color: "#90ED7D"
            //    }, {
            //        name: 'Radialogy', y: 122, color: "#F7A35B"
            //    }, {
            //        name: 'Dialysis', y: 157, color: "#7CB5EC"
            //    }, {
            //        name: 'Life Support', y: 101, color: "#434348"
            //    }, {
            //        name: 'Therapeutic', y: 95, color: "#F45A5A"
            //    }]
            //}]
        }
        //CommonChart(ChartOptions);

        $.get("/api/HomeDashboard/LoadContChart/" + StartYear + "/" + StartMonth + "/" + EndYear + "/" + EndMonth + "/" + FacilityId)
        .done(function (result) {
            var getResult = JSON.parse(result);
            ChartOptions.Series = SeriesDataFormation(getResult);
            ChartOptions.Err = ChartOptions.Series;
            CommonChart(ChartOptions);
        })
        .fail(function () {
            //ChartOptions.Err = 0;
            //CommonChart(ChartOptions);
        });

    })();






});

/********************************** Work order Chart ***********************************/

function WorkOrderChart(getResult) {
    var ChartOptions;

    (function () {
        ChartOptions = {
            ChartType: 'bar',
            RenderTo: 'WorkOrderChart',
            Legend: { enabled: false },
            Series: [{
                name: "Work Order",
                //color: "#8A8FEB",
                data: WorkOrdChartdataOptions(getResult)
                //data: SeriesDataFormationNew(getResult)

            }]
        }
        CommonChart(ChartOptions);
    })();
}
function WorkOrdChartdataOptions(getResult) {

    var workOrdStstus = []; var year = []; var WorkorderCount = []; var Col = []; var arr = [];

   // var colors = ['#90ED7D', '#F7A35B', '#7CB5EC', '#434348', '#F45A5A', '#CB2326', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#CB2326',
   //     '#EEF475', '#C4C4B7', '#89EEB0', '#B5E678', '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
   //'#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1']

    for (ind = 0; ind < getResult.WorkorderChartData.length; ind++) {
        workOrdStstus = getResult.WorkorderChartData[ind].WorkOrdStatus;
        WorkorderCount = getResult.WorkorderChartData[ind].Count;
        Col = ChartColor(ind);
        arr.push({ name: workOrdStstus, y: WorkorderCount, color: Col });
    }
    return arr;
}


/********************************** Asset Maintenance Cost Chart ***********************************/

function MainCostChart(getResult) {
    var ChartOptions;

    (function () {
        ChartOptions = {
            ChartType: 'pie',
            RenderTo: 'MaintenanceCostChart',
            customDataLabels: "RM",
            Legend: { enabled: true },
            tooltip: {
                formatter: function () {
                    return '<span style="color:' + this.color + '">\u25CF</span> ' + this.key + ' : ' + "RM " + addCommas(this.y.toFixed(2));
                }
            },
            Series: [{
                name: "Active",
                //color: "#8A8FEB",
                data: MainCostChartdataOptions(getResult)
            }]
        }
        CommonChart(ChartOptions);
    })();
}
function MainCostChartdataOptions(getResult) {

    var MainCostCat = []; var MaintenCost = []; var arr = [];
    for (ind = 0; ind < getResult.MaintenanceCostChartData.length; ind++) {
        MainCostCat = getResult.MaintenanceCostChartData[ind].MaintenCat;
        MaintenCost = getResult.MaintenanceCostChartData[ind].Cost;
        Col = ChartColor(ind);
        arr.push({ name: MainCostCat, y: MaintenCost, color: Col });
    }
    return arr;
}

/********************************** Asset Chart ***********************************/

function LoadAssetChart(getResult) {
    var ChartOptions;

    (function () {
        ChartOptions = {
            ChartType: 'variablepie',
            RenderTo: 'AssetChart',
            Legend: { enabled: true },
            tooltip: {
                formatter: function () {
                    return '<span style="color:' + this.color + '">\u25CF</span> ' + this.key + ' : ' + addCommas(this.y);
                }
            },
            Series: [{
                innerSize: '70%',
                name: "Asset",

                data: AssetChartdataOptions(getResult)
            }]
        }
        CommonChart(ChartOptions);
    })();
}
function AssetChartdataOptions(getResult) {

    var AssetStat = []; var AssetCount = []; var arr = [];
    for (ind = 0; ind < getResult.AssetChartData.length; ind++) {
        AssetStat = getResult.AssetChartData[ind].AssetStatus;
        AssetCount = getResult.AssetChartData[ind].Count;
        Col = ChartColor(ind);
        arr.push({ name: AssetStat, y: AssetCount, color: Col });
    }
    return arr;
}

/********************************** EquipUptime Chart Chart ***********************************/

function EquipUptimeChart(getResult) {
    var ChartOptions;

    (function () {
        ChartOptions = {
            ChartType: 'column',
            RenderTo: 'EquipmentUptimeChart',
            Legend: { enabled: false },
            //tooltip: {
            //    formatter: function () {
            //        return '<span style="color:' + this.color + '">\u25CF</span> ' + this.key + ' : ' + addCommas(this.y);
            //    }
            //},
            Series: [{
                name: "Equipment Uptime",
                data: EquipUptimeChartdataOptions(getResult)
            }]
        }
        CommonChart(ChartOptions);
    })();
}
function EquipUptimeChartdataOptions(getResult) {

    var EquipmentCat = []; var ClassCount = []; var arr = [];
    for (ind = 0; ind < getResult.EquipmentUptimeChartData.length; ind++) {
        EquipmentCat = getResult.EquipmentUptimeChartData[ind].EquipCat;
        ClassCount = getResult.EquipmentUptimeChartData[ind].Count;
        Col = ChartColor(ind);
        arr.push({ name: EquipmentCat, y: ClassCount, color: Col });
    }
    return arr;
}

/********************************** Asset Age Chart ***********************************/

function AssetAgeChart(getResult) {
    var ChartOptions;

    (function () {
        ChartOptions = {
            ChartType: 'pie',
            RenderTo: 'PPMRegisterChart',
            //customDataLabels: "RM",
            Legend: {
                    enabled: true,
                    align: 'left'},
            tooltip: {
                formatter: function () {
                    return '<span style="color:' + this.color + '">\u25CF</span> ' + this.key + ' : ' + addCommas(this.y);
                }
            },
            Series: [{
                name: "",
                //color: "#8A8FEB",
                data: AssetAgeChartdataOptions(getResult)
            }]
        }
        CommonChart(ChartOptions);
    })();
}
function AssetAgeChartdataOptions(getResult) {

    var Age = []; var Agecount = []; var arr = [];
    for (ind = 0; ind < getResult.AssetAgeChartData.length; ind++) {
        Age = getResult.AssetAgeChartData[ind].AgeGroup;
        Agecount = getResult.AssetAgeChartData[ind].Count;
        Col = ChartColor(ind);
        arr.push({ name: Age, y: Agecount, color: Col });
    }
    return arr;
}

///********************************** Contract Chart ***********************************/
//function ContChart(getResult) {
//    var ChartOptions;

//    (function () {
//        ChartOptions = {
//            ChartType: 'variablepie',
//            RenderTo: 'ContractorChart',
//            Legend: { enabled: true },
//            tooltip: {
//                formatter: function () {
//                    return '<span style="color:' + this.color + '">\u25CF</span> ' + this.key + ' : ' + addCommas(this.y);
//                }
//            },
//            Series: [{
//                innerSize: '70%',
//                name: "Contract",

//                data: ContractChartdataOptions(getResult)
//            }]
//        }
//        CommonChart(ChartOptions);
//    })();
//}
//function ContractChartdataOptions(getResult) {

//    var ContStat = []; var ContCount = []; var arr = [];
//    for (ind = 0; ind < getResult.ContractorChartData.length; ind++) {
//        ContStat = getResult.ContractorChartData[ind].ConStatus;
//        ContCount = getResult.ContractorChartData[ind].Count;
//        Col = ChartColor(ind);
//        arr.push({ name: ContStat, y: ContCount, color: Col });
//    }
//    return arr;
//}




function ContractChartdataOptions(getResult) {

    var ContStat = []; var ContCount = []; var arr = [];
    if (getResult.ContractorChartData && getResult.ContractorChartData.length) {

        for (ind = 0; ind < getResult.ContractorChartData.length; ind++) {
            ContStat = getResult.ContractorChartData[ind].ConStatus;
            ContCount = getResult.ContractorChartData[ind].Count;
            Col = ChartColor(ind);
            arr.push({ name: ContStat, y: ContCount, color: Col });
        }
        return arr;
    }
    else {
        return [];
}
}




function ChartColor(ind) {
    var colors = ['#90ED7D', '#F7A35B', '#7CB5EC', '#434348', '#F45A5A', '#CB2326', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#CB2326',
        '#EEF475', '#C4C4B7', '#89EEB0', '#B5E678', '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
   '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1']

    return colors[ind];
}

function SeriesDataFormation(SeriesData, SeriesName) {

    var colors = ['#90ED7D', '#F7A35B', '#7CB5EC', '#434348', '#F45A5A', '#CB2326', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#CB2326',
        '#EEF475', '#C4C4B7', '#89EEB0', '#B5E678', '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
   '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1']
    var ar = [];
    var Series = [{
        name: SeriesName,
        data: dataObj(SeriesData)
    }];
    return Series;
}
function dataObj(SeriesData) {
    //var res;
    var result = [];
    if (SeriesData.ContractorChartData && SeriesData.ContractorChartData.length) {

        for (var i = 0; i < SeriesData.ContractorChartData.length; i++) {

            var colors = ['#90ED7D', '#F7A35B', '#7CB5EC', '#434348', '#F45A5A', '#CB2326', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#CB2326',
                    '#EEF475', '#C4C4B7', '#89EEB0', '#B5E678', '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
               '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1']

            //ar.push({ name: SeriesData.ContractorChartData[i].ConStatus, y: SeriesData.ContractorChartData[i].Count, color: colors[i] });
            //Series.data.name = SeriesData[i].MonthName;
            //Series.data.push(innerTemp);
            if (SeriesData.ContractorChartData[i].Count > 0) {
                result.push({ name: SeriesData.ContractorChartData[i].ConStatus, y: SeriesData.ContractorChartData[i].Count, color: colors[i] });
            }
            else {
                //aaa.push({});
            }


        }
        return result;
        }
    //else {
    //    return [];
    //}
}





function MaintanenceCostDataFormation(SeriesData, SeriesName) {
    var Series = [{
        name: SeriesName,
        data: dataObjMainCost(SeriesData)
    }];
    return Series;
}
function dataObjMainCost(SeriesData) {
    var MainCostresult = [];
    if (SeriesData.MaintenanceCostChartData && SeriesData.MaintenanceCostChartData.length) {

        for (var i = 0; i < SeriesData.MaintenanceCostChartData.length; i++) {

            var colors = ['#90ED7D', '#F7A35B', '#7CB5EC', '#434348', '#F45A5A', '#CB2326', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#CB2326',
                    '#EEF475', '#C4C4B7', '#89EEB0', '#B5E678', '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
               '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1']
            if (SeriesData.MaintenanceCostChartData[i].Cost > 0) {
                MainCostresult.push({ name: SeriesData.MaintenanceCostChartData[i].MaintenCat, y: SeriesData.MaintenanceCostChartData[i].Cost, color: ChartColor(i) });
            }
            else {
            }
        }
        return MainCostresult;
    }

}


