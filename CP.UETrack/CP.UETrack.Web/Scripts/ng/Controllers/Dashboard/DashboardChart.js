$(document).ready(function () {
    InitChartCall();
});

function InitChartCall() {
    var ChartOptions;

    //Work Order Chart
    (function () {
        ChartOptions = {
            ChartType: 'bar',
            RenderTo: 'WorkOrderChart',
            Legend: { enabled: false },
            Series: [{
                name: "Work Order",
                data: [{
                    name: 'Active', y: 107, color: "#90ED7D"
                }, {
                    name: 'In-Active', y: 122, color: "#F7A35B"
                }, {
                    name: 'In-Progress', y: 157, color: "#7CB5EC"
                }, {
                    name: 'Closed', y: 101, color: "#434348"
                }]
            }]
        }
        CommonChart(ChartOptions);
    })();

    //Maintenance Cost Chart
    (function () {
        ChartOptions = {
            ChartType: 'pie',
            RenderTo: 'MaintenanceCostChart',
            customDataLabels: "RM",
            tooltip: {
                formatter: function () {
                    return '<span style="color:' + this.color+ '">\u25CF</span> ' + this.key + ' : ' + "RM " + addCommas(this.y.toFixed(2));
                }
            },
            Series: [{
                name: "Maintenance Cost",
                data: [{
                    name: 'Labour Cost', y: 107, color: "#90ED7D"
                }, {
                    name: 'Sparepart Cost', y: 122, color: "#F7A35B"
                }, {
                    name: 'Contractor Cost', y: 157, color: "#7CB5EC"
                }]
            }]
        }
        CommonChart(ChartOptions);
    })();

    //Equipment Uptime Chart
    (function () {
        ChartOptions = {
            ChartType: 'column',
            RenderTo: 'EquipmentUptimeChart',
            Legend: { enabled: false },
            Series: [{
                name: "Equipment Uptime",
                data: [{
                    name: 'Genereal', y: 107, color: "#90ED7D"
                }, {
                    name: 'Radialogy', y: 122, color: "#F7A35B"
                }, {
                    name: 'Dialysis', y: 157, color: "#7CB5EC"
                }, {
                    name: 'Life Support', y: 101, color: "#434348"
                }, {
                    name: 'Therapeutic', y: 95, color: "#F45A5A"
                }]
            }]
        }
        CommonChart(ChartOptions);

        //$.get("/api/companystaffmst/Load")
        //.done(function (result) {
        //    var getResult = JSON.parse(result);
        //    ChartOptions.Series = SeriesDataFormation(getResult,"Equipment Uptime");
        //    ChartOptions.Err = ChartOptions.Series;
        //    CommonChart(ChartOptions);
        //})
        //.fail(function () {
        //    ChartOptions.Err = 0;
        //    CommonChart(ChartOptions);
        //});
        
    })();

    //Asset Chart
    (function () {
        ChartOptions = {
            ChartType: 'variablepie',
            RenderTo: 'AssetChart',
            tooltip: {
                formatter: function () {
                    return '<span style="color:' + this.color + '">\u25CF</span> ' + this.key + ' : ' + addCommas(this.y);
                }
            },
            Series: [{
                innerSize: '70%',
                name: 'Asset',
                data: [{
                    name: 'Active',
                    y: 505,
                    color: "#90ED7D"
                }, {
                    name: 'In-Active',
                    y: 551,
                    color: "#F7A35B"
                }]
            }]
        }
        CommonChart(ChartOptions);
    })();

    //PPM Register Chart
    (function () {
        ChartOptions = {
            ChartType: 'line',
            RenderTo: 'PPMRegisterChart',
            Legend: { enabled: true },
            Series: [{
                name: "Active",
                color: "#90ED7D",
                data: [{
                    name: 'Jan', y: 107
                }, {
                    name: 'Feb', y: 122
                }, {
                    name: 'Mar', y: 157
                }, {
                    name: 'Apr', y: 101
                }]
            },
            {
                name: "Closed",
                color: "#434348",
                data: [{
                    name: 'Jan', y: 155
                }, {
                    name: 'Feb', y: 111
                }, {
                    name: 'Mar', y: 198
                }, {
                    name: 'Apr', y: 155
                }]
            }]
        }
        CommonChart(ChartOptions);
    })();

    //Contractor Chart
    (function () {
        ChartOptions = {
            ChartType: 'variablepie',
            RenderTo: 'ContractorChart',
            tooltip: {
                formatter: function () {
                    return '<span style="color:' + this.color + '">\u25CF</span> ' + this.key + ' : ' + addCommas(this.y);
                }
            },
            Series: [{
                innerSize: '70%',
                name: 'Contractor',
                data: [{
                    name: 'Renewed',
                    y: 5454,
                    color: "#434348",
                }, {
                    name: 'Awaiting Renewal',
                    y: 1898,
                    color: "#7CB5EC",
                }]
            }]
        }
        CommonChart(ChartOptions);
    })();
}

function SeriesDataFormation(SeriesData, SeriesName) {

    var colors = ['#90ED7D', '#F7A35B', '#7CB5EC', '#434348', '#F45A5A', '#CB2326', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#CB2326',
        '#EEF475', '#C4C4B7', '#89EEB0', '#B5E678', '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
   '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1']

    var Series = [{
        name: SeriesName,
        data: []
    }];

    if (SeriesData && SeriesData.length) {
        for (var i = 0; i < SeriesData.length; i++) {
            var innerTemp = {
                name: SeriesData[i].ItemName,
                y: SeriesData[i].ItemValues,
                color: colors[i],
            }

            Series.data.push(innerTemp);
        }
        return Series;
    } else {
        return [];
    }

}