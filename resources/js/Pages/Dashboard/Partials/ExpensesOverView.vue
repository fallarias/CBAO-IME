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
        labels: ['January', 'February', 'March', 'April'],
        datasets: [
            { 
                label: 'Monthly Expenses',
                backgroundColor: '#f87979',
                data: [20381, 38602, 29705, 54398] 
            }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false
      }
    }
  }
}
</script>