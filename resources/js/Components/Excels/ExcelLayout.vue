<template>
    <div class="excel-layout">
      <div class="overflow-auto">
        <table class="min-w-full border-collapse border border-gray-300">
          <thead class="bg-green-900 text-white">
            <tr>
              <th v-for="header in headers" :key="header" class="px-4 py-2 border border-gray-300">
                {{ header }}
              </th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(row, index) in data" :key="index">
              <td v-for="header in headers" :key="header" class="px-4 py-2 border border-gray-300">
                {{ row[header] }}
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </template>
  
  <script setup>
  import { exportExcel as excelExport } from '@/Utils/ExcelGenerator.js'; // ✅ named import
  
  // Props
  const props = defineProps({
    headers: { type: Array, required: true },
    data: { type: Array, required: true },
    title: { type: String, default: "Report" }
  });
  
  // Wrapper function to use in parent
  const exportExcel = () => {
    excelExport(props.data, props.headers, props.title);
  };
  </script>
  
  <style scoped>
  .excel-layout table { width: 100%; table-layout: fixed; }
  .excel-layout th, td { word-wrap: break-word; }
  </style>
  