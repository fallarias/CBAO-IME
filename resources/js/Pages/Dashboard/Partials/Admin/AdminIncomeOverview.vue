

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
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  PointElement,
  LineElement,
  CategoryScale,
  LinearScale,
} from 'chart.js'
import { Bar, Line } from 'vue-chartjs'

ChartJS.register(CategoryScale, LinearScale, BarElement, PointElement, LineElement, Title, Tooltip, Legend)

export default {
  name: 'App',
  components: {
    Bar, Line
  },

  // ✅ Define props here
  props: {
    chartTitle: {
      type: String,
      default: 'Monthly Income'
    },
    chartData: {
      type: Array as () => number[],
    },
    chartLabels: {
      type: Array as () => string[],
    },
    chartColor: {
      type: Array as () => string[],
    }
  },

  data() {
    return {
      data: {
        labels: this.chartLabels,
        datasets: [
          { 
            label: this.chartTitle,
            backgroundColor: this.chartColor,
            data: this.chartData
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            labels: {
              generateLabels: (chart) => {
                return chart.data.labels.map((label, i) => ({
                  text: label,
                  fillStyle: chart.data.datasets[0].backgroundColor[i],
                  hidden: false,
                  lineWidth: 0,
                  strokeStyle: ''
                }))
              }
            }
          }
        }
      },
    }
  }
}
</script>

