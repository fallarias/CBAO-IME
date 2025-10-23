<script setup>
import { onMounted, watch } from "vue";

const props = defineProps({
  id: {
    type: String,
    default: () => `pie-chart-${Math.random().toString(36).substring(2, 9)}`,
  },
  data: {
    type: Object,
    default: () => ({
      series: [],
      colors: [],
      labels: [],
    }),
  },
});

let chart = null;

const getChartOptions = () => ({
  series: props.data?.series ?? [],
  colors: props.data?.colors ?? [],
  chart: {
    height: 320,
    width: "100%",
    type: "pie",
  },
  stroke: {
    colors: ["white"],
    lineCap: "",
  },
  plotOptions: {
    pie: {
      size: "100%",
      dataLabels: {
        offset: -25,
      },
    },
  },
  labels: props.data?.labels ?? [],
  dataLabels: {
    enabled: true,
    style: {
      fontFamily: "Inter, sans-serif",
    },
  },
  legend: {
    position: "bottom",
    fontFamily: "Inter, sans-serif",
  },
});

onMounted(() => {
  const el = document.getElementById(props.id);
  if (el && typeof ApexCharts !== "undefined" && props.data.series.length) {
    chart = new ApexCharts(el, getChartOptions());
    chart.render();
  }
});

watch(
  () => props.data,
  (newVal) => {
    if (!chart) {
      const el = document.getElementById(props.id);
      if (el && typeof ApexCharts !== "undefined" && newVal.series.length) {
        chart = new ApexCharts(el, getChartOptions());
        chart.render();
      }
    } else {
      chart.updateOptions(getChartOptions());
    }
  },
  { deep: true }
);
</script>

<template>
  <div :id="id" class="w-full"></div>
</template>
