$(document).ready(function(){
    var ctx = document.getElementById("myLineChart");
var myLineChart = new Chart(ctx, {
  type: 'line',
  data: {
    labels: ['1月','2月','3月','4月','5月','6月','7月','8月', '9月', '10月', '11月', '12月'],
    datasets: [
      {
        label:'発注金額',
        data: [3500, 3400, 3700, 3500, 3400, 3500, 3400, 2500, 3400, 3500, 3400, 2500],
        borderColor: "#FA1F6C",
        backgroundColor: "rgba(0,0,0,0)"
      },
    ],
  },
  options: {
    title: {
      display: false,
      text: '気温（8月1日~8月7日）',
    },
    legend: {
      display: false,
    },
    scales: {
      yAxes: [{
        ticks: {
          suggestedMax: 4000,
          suggestedMin: 0,
          stepSize: 1000,
          callback: function(value, index, values){
            return  value +  '円'
          }
        }
      }]
    },
  }
});
})