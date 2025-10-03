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
  data() {
    return {
      data: {
        labels: ['Echague', 'Cauayan', 'Cabagan', 'Ilagan', 'Roxas', 'Angadanan', 'Jones'],
        datasets: [
          { 
            label: 'Monthly Income',  // This label appears in the chart legend, no icon is needed
            backgroundColor: [
              '#f87979',  // Echague
              '#42a5f5',  // Cauayan
              '#66bb6a',  // Cabagan
              '#ffeb3b',  // Ilagan
              '#ff7043',  // Roxas
              '#8e24aa',  // Angadanan
              '#26c6da'   // Jones
            ],
            data: [10381, 28602, 39705, 34398, 54678, 37594, 24637]
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
                // Return a custom label without any icons
                return chart.data.labels.map((label, i) => ({
                  text: label,  // Only show the label text
                  fillStyle: chart.data.datasets[0].backgroundColor[i],  // Use corresponding colors
                  hidden: false,
                  lineWidth: 0,
                  strokeStyle: ''
                }))
              }
            }
          }
        }
      }
    }
  }
}
</script>
