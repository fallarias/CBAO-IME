<template>
  <v-row>
    <v-col cols="12">
      <v-card elevation="0" class="pa-4 border border-gray-500 h-80">
        <Line :data="data" :options="options" />
      </v-card>
    </v-col>
  </v-row>
</template>

<script lang="ts">
import axios from 'axios'
import { Line } from 'vue-chartjs'

import { Chart as ChartJS, Title, Tooltip, Legend, LineElement, PointElement, CategoryScale, LinearScale, Filler } from 'chart.js'

ChartJS.register(CategoryScale, LinearScale, LineElement, PointElement, Title, Tooltip, Legend, Filler)


export default {
  name: 'App',
  components: { Line },
  data() {
    return {
      data: {
        labels: [],
        datasets: [
          {
            label: 'Monthly Sales',
            backgroundColor: [],
            data: []
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            tooltip: {
                callbacks: {
                    title: function(tooltipItems) {
                    // Product name (label)
                    return tooltipItems[0].label
                    },
                    label: function(tooltipItem) {
                    // Example: Total Sales: ₱30
                    const value = tooltipItem.raw
                    return `Monthly Sales: ₱${value}`
                    }
                }
            }
        }
      }
    }
  },
  mounted() {
    this.fetchChartData()
  },
  methods: {
    async fetchChartData() {
        try {
            const response = await axios.get('http://127.0.0.1:8000/integrated/inventory/monthly-sales/')
            console.log("Chart data:", response.data)

            const currentYear = new Date().getFullYear()

            const fullMonths = Array.from({ length: 12 }, (_, i) =>
            String(i + 1).padStart(2, "0")
            )

            const salesMap = {}

            response.data.labels.forEach((label, index) => {
            salesMap[label] = response.data.datasets[0].data[index]
            })

            const filledData = fullMonths.map(month => salesMap[month] ?? 0)

            this.data = {
                labels: fullMonths.map(m => `${currentYear} - ${m}`),
                datasets: [
                    {
                        label: "Monthly Sales (₱)",
                        data: filledData,
                        borderColor: '#2ecc71',
                        pointBackgroundColor: '#2ecc71',
                        pointBorderColor: '#2ecc71',
                        borderWidth: 3,
                        fill: true,
                        backgroundColor: 'rgba(46, 204, 113, 0.25)',
                        tension: 0.4
                    }
                ]
            }


        } catch (error) {
            console.error('Error fetching chart data:', error)
        }
    }
  }
}
</script>

