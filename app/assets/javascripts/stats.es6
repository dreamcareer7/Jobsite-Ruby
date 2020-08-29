Object.values = obj => Object.keys(obj).map(key => obj[key])

const fetchImpressions = () => {
  const [fromDate, toDate] = $(".js-stats-time-range option:selected")[0].value.split('-')

  $.get(`/business/stats.json?from=${fromDate}&to=${toDate}`, (res) => {
    const { impressions } = res

    // Impression graph
    const impressionData = Object.keys(impressions).map(utc =>
      [moment(utc, "YYYY-MM-DD HH:mm Z").utc().unix() * 1000, impressions[utc]]
    )

    chart.series[0].setData(impressionData)

    // Basic stats
    $('.js-stat').each(function() {
      $(this).text(res[$(this).data('stat')])
    })
  })
}

const chart = new Highcharts.Chart({
  chart: {
    renderTo: document.querySelector('.js-impressions-graph')
  },
  xAxis: {
    type: 'datetime',
    dateTimeLabelFormats: {
      month: '%b',
      day: '%b %e',
    }
  },
  title: '',
  yAxis: {
    plotLines: [{
      value: 0,
      width: 1,
    }],
    title: ''
  },
  tooltip: {
    valueSuffix: ' impressions'
  },
  series: [{
    showInLegend: false,
    data: [],
    color: '#BE3E26'
  }],
  credits: {
    enabled: false
  }
})

$('.js-stats-time-range').change(fetchImpressions)
fetchImpressions()
