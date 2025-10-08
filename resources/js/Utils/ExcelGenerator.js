// /Utils/ExcelLayout.js
import * as XLSX from "xlsx";
import { saveAs } from "file-saver";

/**
 * Export JSON data to Excel with styled headers and auto column width
 * @param {Array} data - array of objects
 * @param {Array} headers - array of strings for headers
 * @param {String} title - filename prefix
 */
export const exportExcel = (data, headers, title = "Report") => {
    if (!data || data.length === 0) return;

    // 1️⃣ Convert JSON to worksheet
    const ws = XLSX.utils.json_to_sheet(data, { header: headers });

    // 2️⃣ Style headers: bold, white text, green background
    headers.forEach((header, index) => {
        const cellAddress = XLSX.utils.encode_cell({ r: 0, c: index });
        if (!ws[cellAddress]) return;

        ws[cellAddress].s = {
            font: { bold: true, color: { rgb: "FFFFFFFF" } },
            fill: { fgColor: { rgb: "FF008000" } }, // green background
            alignment: { horizontal: "center", vertical: "center" },
        };
    });

    // 3️⃣ Auto-width: calculate max width per column
    const colWidths = headers.map((header, colIndex) => {
        const maxLength = Math.max(
            header.length,
            ...data.map((row) => {
                const val = row[header] ? String(row[header]) : "";
                return val.length;
            })
        );
        return { wch: maxLength + 2 }; // add some padding
    });
    ws["!cols"] = colWidths;

    // 4️⃣ Create workbook
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, "Sheet1");

    // 5️⃣ Export
    const wbout = XLSX.write(wb, { bookType: "xlsx", type: "array" });
    const filename = `${title}_${new Date().toISOString().slice(0, 10)}.xlsx`;
    saveAs(new Blob([wbout], { type: "application/octet-stream" }), filename);
};
