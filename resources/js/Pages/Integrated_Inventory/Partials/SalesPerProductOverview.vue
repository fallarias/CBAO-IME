<template>
  <v-row>
    <v-col cols="12">
      <v-card elevation="0" class="pa-4 border border-gray-500 h-80">
        <Bar :data="data" :options="options" />
      </v-card>
    </v-col>
  </v-row>
</template>

<script lang="ts">
import axios from 'axios'
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js'
import { Bar } from 'vue-chartjs'

ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend)

export default {
  name: 'App',
  components: { Bar },
  data() {
    return {
      data: {
        labels: [],
        datasets: [
          {
            label: 'Monthly Income',
            backgroundColor: [],
            data: []
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
            display: false
            },
            tooltip: {
                callbacks: {
                    title: function(tooltipItems) {
                    // Product name (label)
                    return tooltipItems[0].label
                    },
                    label: function(tooltipItem) {
                    // Example: Total Sales: ₱30
                    const value = tooltipItem.raw
                    return `Total Sales: ₱${value}`
                    }
                }
            }
        },
        scales: {
            x: {
                ticks: {
                maxRotation: 45,
                minRotation: 45
                }
            },
            y: {
                ticks: {
                    // Format Y-axis numbers with pesos + commas
                    callback: function(value) {
                    return '₱' + value.toLocaleString('en-PH');
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
            const response = await axios.get('http://127.0.0.1:8000/integrated/inventory/sales-per-product/')
            console.log("Chart data:", response.data)

            this.data = {
                labels: response.data.labels,
                datasets: response.data.datasets.map(ds => ({
                    ...ds,
                    borderRadius: 10
                }))
            }

        } catch (error) {
            console.error('Error fetching chart data:', error)
        }
    }
  }
}
</script>

