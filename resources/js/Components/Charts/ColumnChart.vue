<script setup>
import { onMounted, watch, ref } from "vue";

const props = defineProps({
  series: {
    type: Array, // ✅ should be Array, not Object
    required: true,
  },
});

let chart = null; // store chart instance
const chartEl = ref(null);

const getChartOptions = (series) => ({
  series,
  chart: {
    type: "bar",
    height: "320px",
    fontFamily: "Inter, sans-serif",
    toolbar: { show: false },
  },
  plotOptions: {
    bar: {
      horizontal: false,
      columnWidth: "70%",
      borderRadiusApplication: "end",
      borderRadius: 8,
    },
  },
  tooltip: {
    shared: true,
    intersect: false,
    y: {
      formatter: (val) => {
        return new Intl.NumberFormat("en-PH", {
          style: "currency",
          currency: "PHP",
          minimumFractionDigits: 2,
        }).format(val);
      },
    },
    style: { fontFamily: "Inter, sans-serif" },
  },
  states: {
    hover: { filter: { type: "darken", value: 1 } },
  },
  stroke: {
    show: true,
    width: 0,
    colors: ["transparent"],
  },
  grid: {
    show: false,
    strokeDashArray: 4,
    padding: { left: 2, right: 2, top: -14 },
  },
  dataLabels: { 
    enabled: false,
    formatter: (val) => {
      return new Intl.NumberFormat("en-PH", {
        style: "currency",
        currency: "PHP",
        minimumFractionDigits: 0,
      }).format(val);
    }, 
  },
  legend: { show: false },
  xaxis: {
    floating: false,
    labels: {
      show: true,
      style: {
        fontFamily: "Inter, sans-serif",
        cssClass: "text-xs font-normal fill-gray-500 dark:fill-gray-400",
      },
    },
    axisBorder: { show: false },
    axisTicks: { show: false },
  },
  yaxis: { show: false },
  fill: { opacity: 1 },
});

onMounted(() => {
  if (typeof ApexCharts !== "undefined" && chartEl.value) {
    chart = new ApexCharts(chartEl.value, getChartOptions(props.series));
    chart.render();
  }
});

// ✅ Re-render chart whenever `series` changes
watch(
  () => props.series,
  (newSeries) => {
    if (chart) {
      chart.updateSeries(newSeries);
    }
  },
  { deep: true }
);
</script>

<template>
  <div ref="chartEl" class="w-full h-[320px]"></div>
</template>
