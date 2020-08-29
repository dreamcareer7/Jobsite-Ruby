Object.values = obj => Object.keys(obj).map(key => obj[key]) // Object.values shim

// Initialize the rivets object and bind it to the DOM
const rivetsObject = { stats: {} }
rivets.bind($('.js-admin-stats').eq(0), rivetsObject)

// Fetch the stats from the API, refresh the charts and update the rivets object

const fetchStats = ({ endpointModule }) => {
  const [fromDate, toDate] = $(".js-stats-time-range option:selected")[0].value.split('-')

  $('.js-stats-loading').show()

  $.get(`/admin/statistics/${endpointModule}.json?from=${fromDate}&to=${toDate}`, (res) => {
    $('.js-stats-loading').hide()

    // Update graph data
    charts.forEach((chart) => {
      const seriesName = $(chart.container).parent().data('series')
      const series = res[`${seriesName}_series`]

      series.forEach((serie, i) => {
        const serieData = Object.keys(serie.data).map((utc) => [+utc * 1000, serie.data[utc]])

        if (chart.series.length === i) {
          chart.addSeries({
            name: serie.name,
            color: serie.color,
            data: serieData,
            showInLegend: series.length > 1
          })
        } else {
          chart.series[i].setData(serieData)
        }
      })
    })

    // Update the rivets template
    rivetsObject.stats = res
  })
}


// Initialize all the charts and keep them in an array

const chartElements = Array.from(document.querySelectorAll('.js-stats-graph'))
const charts = chartElements.map(function(chartElement) {
  return new Highcharts.Chart({
    chart: {
      renderTo: chartElement
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
      allowDecimals: false,
      plotLines: [{
        value: 0,
        width: 1,
      }],
      title: '',
      minRange: 0.1
    },
    series: [],
    credits: {
      enabled: false
    }
  })
})

// This is called within the indivual stat pages to do the intial API fetch and bind the data range switcher

const initStats = ({ endpointModule }) => {
  const fetchSpecificStats = () => fetchStats({ endpointModule })
  $('.js-stats-time-range').change(fetchSpecificStats)
  fetchSpecificStats()
}