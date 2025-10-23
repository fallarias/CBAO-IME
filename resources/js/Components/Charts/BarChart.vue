<script setup>
import { onMounted, watch, ref, onBeforeUnmount } from "vue";

const props = defineProps({
  data: {
    type: Object,
    required: true,
    default: () => ({
      categories: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
      incomes: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
      expenses: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
    }),
  },
});

const chart = ref(null);

const renderChart = () => {
  const options = {
    series: [
      { name: "Income", color: "#31C48D", data: props.data.incomes },
      { name: "Expense", color: "#F05252", data: props.data.expenses },
    ],
    chart: {
      type: "bar",
      width: "100%",
      height: 400,
      toolbar: { show: false },
    },
    plotOptions: {
      bar: {
        horizontal: true,
        columnWidth: "100%",
        borderRadius: 6,
      },
    },
    legend: { show: true, position: "bottom" },
    dataLabels: { enabled: false },
    tooltip: {
      shared: true,
      intersect: false,
      y: { formatter: (val) => `₱${val.toLocaleString()}` },
    },
    xaxis: {
      categories: props.data.categories,
      labels: {
        style: {
          fontFamily: "Inter, sans-serif",
          cssClass: "text-xs font-normal fill-gray-500 dark:fill-gray-400",
        },
      },
      axisTicks: { show: false },
      axisBorder: { show: false },
    },
    yaxis: {
      labels: {
        style: {
          fontFamily: "Inter, sans-serif",
          cssClass: "text-xs font-normal fill-gray-500 dark:fill-gray-400",
        },
      },
    },
    grid: {
      show: true,
      strokeDashArray: 4,
      padding: { left: 2, right: 2, top: -20 },
    },
    fill: { opacity: 1 },
  };

  const el = document.getElementById("bar-chart");
  if (el) {
    if (chart.value) {
      chart.value.destroy(); // 🧹 destroy existing chart to avoid stale data
    }
    chart.value = new ApexCharts(el, options);
    chart.value.render();
  }
};

onMounted(() => {
  renderChart();
});

// 🧠 Watch for any prop changes and re-render chart completely
watch(
  () => props.data,
  (newData) => {
    if (!chart.value) return;
    // Re-render chart completely when data structure changes
    renderChart();
  },
  { deep: true }
);

onBeforeUnmount(() => {
  if (chart.value) {
    chart.value.destroy();
    chart.value = null;
  }
});
</script>

<template>
  <div id="bar-chart" class="w-full h-[400px]"></div>
</template>
