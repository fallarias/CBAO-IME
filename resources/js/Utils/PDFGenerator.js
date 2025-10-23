// import jsPDF from "jspdf";
// import html2canvas from "html2canvas";
// import { nextTick } from "vue";

// // === Helper: format printed date ===
// export const formatPrintedDate = () => {
//     const now = new Date();
//     const year = now.getFullYear();
//     const month = String(now.getMonth() + 1).padStart(2, "0");
//     const day = String(now.getDate()).padStart(2, "0");

//     let hours = now.getHours();
//     const minutes = String(now.getMinutes()).padStart(2, "0");
//     const ampm = hours >= 12 ? "PM" : "AM";
//     hours = hours % 12 || 12;

//     return `${year}-${month}-${day} at ${hours}:${minutes} ${ampm}`;
// };

// // === Helper: generate random PDF title ===
// export const generatePdfTitle = (reportTitle = "Report") => {
//     const now = new Date();
//     const year = now.getFullYear();
//     const month = String(now.getMonth() + 1).padStart(2, "0");
//     const day = String(now.getDate()).padStart(2, "0");
//     const randomId = Math.random().toString(36).substring(2, 8).toUpperCase();

//     return `${year}-${month}-${day}_${reportTitle}_${randomId}`;
// };

// // === Main PDF Generator ===
// export const generatePDF = async ({
//     pdfSection,
//     reportTitle = "Report",
//     isExporting,
//     currentUser,
//     orientation = "p", // 'p' = portrait, 'l' = landscape
//     width_size = 190
// }) => {
//     isExporting.value = true;
//     await nextTick(); // Wait for content rendering

//     // === Init jsPDF with orientation ===
//     const doc = new jsPDF(orientation, "mm", "a4");
//     const pdfTitle = generatePdfTitle(reportTitle);
//     const pageWidth = doc.internal.pageSize.getWidth();
//     const pageHeight = doc.internal.pageSize.getHeight();

//     doc.setProperties({ title: pdfTitle });

//     const logo = new Image();
//     logo.src = "/storage/isu_seal.png"; // Ensure file exists

//     logo.onload = async () => {
//         const canvas = await html2canvas(pdfSection.value.$el, { scale: 2 });
//         const imgData = canvas.toDataURL("image/png");

//         const contentHeight = (canvas.height * 210) / canvas.width;
//         const totalPages = Math.ceil(contentHeight / pageHeight);

//         for (let i = 0; i < totalPages; i++) {
//             if (i !== 0) doc.addPage();

//             // === HEADER ===
//             doc.addImage(logo, "PNG", 15, 10, 18, 18);
//             doc.setFontSize(11);
//             doc.setTextColor(0);
//             doc.text("Republic of the Philippines", 40, 15);
//             doc.setFontSize(13);
//             doc.setFont("helvetica", "bold");
//             doc.text("ISABELA STATE UNIVERSITY", 40, 20);
//             doc.setFontSize(11);
//             doc.setFont("helvetica", "normal");
//             doc.text(`${currentUser.campus}, Isabela`, 40, 25);
//             doc.setLineWidth(0.1);
//             doc.line(10, 30, pageWidth - 10, 30);

//             // === CONTENT ===
//             doc.addImage(
//                 imgData,
//                 "PNG",
//                 10,
//                 35,
//                 width_size,
//                 0,
//                 "",
//                 "FAST",
//                 0,
//                 i * pageHeight * (canvas.width / 210)
//             );

//             // === FOOTER ===
//             doc.setFillColor(255, 255, 255);
//             doc.rect(0, pageHeight - 20, pageWidth, 20, "F");

//             const pageText = `Page ${i + 1} of ${totalPages}`;
//             doc.setFontSize(10);
//             doc.setTextColor(0);
//             doc.text(pageText, 10, pageHeight - 10);

//             const printedBy = `Printed by: ${currentUser.name}`.toUpperCase();
//             const printedDate = formatPrintedDate().toUpperCase();

//             doc.setFontSize(8);
//             doc.setTextColor(0);
//             const printedByWidth = doc.getTextWidth(printedBy);
//             doc.text(
//                 printedBy,
//                 pageWidth - printedByWidth - 10,
//                 pageHeight - 10
//             );

//             doc.setTextColor(160, 160, 160);
//             const printedDateWidth = doc.getTextWidth(printedDate);
//             doc.text(
//                 printedDate,
//                 pageWidth - printedDateWidth - 10,
//                 pageHeight - 6
//             );
//         }

//         doc.output("dataurlnewwindow"); // Open in new tab
//         isExporting.value = false;
//     };
// };

import jsPDF from "jspdf";
import autoTable from "jspdf-autotable";
import { nextTick } from "vue";

// === Helper: format printed date ===
export const formatPrintedDate = () => {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, "0");
    const day = String(now.getDate()).padStart(2, "0");
    let hours = now.getHours();
    const minutes = String(now.getMinutes()).padStart(2, "0");
    const ampm = hours >= 12 ? "PM" : "AM";
    hours = hours % 12 || 12;
    return `${year}-${month}-${day} at ${hours}:${minutes} ${ampm}`;
};

// === Helper: generate random PDF title ===
export const generatePdfTitle = (reportTitle = "Report") => {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, "0");
    const day = String(now.getDate()).padStart(2, "0");
    const randomId = Math.random().toString(36).substring(2, 8).toUpperCase();
    return `${year}-${month}-${day}_${reportTitle}_${randomId}`;
};

// === Main PDF Generator (AutoTable) ===
export const generatePDF = async ({
    reportTitle,
    isExporting,
    currentUser,
    headers = [],
    rows = [],
    orientation = "p", // 'p' = portrait | 'l' = landscape
    tableOptions = {},
    pageSize = "a4",
}) => {
    isExporting.value = true;
    await nextTick();

    // === Setup ===
    const doc = new jsPDF(orientation, "mm", pageSize);
    const pdfTitle = generatePdfTitle(reportTitle);
    const pageWidth = doc.internal.pageSize.getWidth();
    const pageHeight = doc.internal.pageSize.getHeight();

    doc.setProperties({ title: pdfTitle });

    // === HEADER ===
    const addHeader = () => {
        const logo = new Image();
        logo.src = "/storage/isu_seal.png";
        doc.addImage(logo, "PNG", 15, 10, 18, 18);
        doc.setFontSize(11);
        doc.text("Republic of the Philippines", 40, 15);
        doc.setFontSize(13);
        doc.setFont("helvetica", "bold");
        doc.text("ISABELA STATE UNIVERSITY", 40, 20);
        doc.setFontSize(11);
        doc.setFont("helvetica", "normal");
        doc.text(`${currentUser.campus}, Isabela`, 40, 25);
        doc.setLineWidth(0.1);
        doc.line(10, 30, pageWidth - 10, 30);

        doc.setFontSize(12);
        doc.setFont("helvetica", "bold");
        doc.text(reportTitle, pageWidth / 2, 38, { align: "center" });
    };

    // addHeader();

    // === TABLE ===
    autoTable(doc, {
        startY: 45,
        head: [headers],
        body: rows,
        theme: "grid",
        styles: { fontSize: 6, cellPadding: 2, halign: "left" },
        headStyles: {
            fillColor: [33, 37, 41],
            textColor: 255,
            fontStyle: "bold",
        },
        ...tableOptions,
        didDrawPage: function (data) {
            // Header on every page
            addHeader();

            // Footer
            const pageCount = doc.internal.getNumberOfPages();
            const pageNumber = doc.internal.getCurrentPageInfo().pageNumber;
            const printedBy = `Printed by: ${currentUser.name}`.toUpperCase();
            const printedDate = formatPrintedDate().toUpperCase();

            doc.setFontSize(6);
            doc.setTextColor(0);
            doc.text(`Page ${pageNumber} of ${pageCount}`, 10, pageHeight - 10);

            const printedByWidth = doc.getTextWidth(printedBy);
            doc.text(
                printedBy,
                pageWidth - printedByWidth - 10,
                pageHeight - 10
            );

            doc.setFontSize(8);
            doc.setTextColor(160, 160, 160);
            const printedDateWidth = doc.getTextWidth(printedDate);
            doc.text(
                printedDate,
                pageWidth - printedDateWidth - 10,
                pageHeight - 6
            );
        },
        margin: { top: 50, bottom: 20 },
    });

    doc.output("dataurlnewwindow");
    isExporting.value = false;
};
