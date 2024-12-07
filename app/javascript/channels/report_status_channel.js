import consumer from "./consumer";

consumer.subscriptions.create("ReportStatusChannel", {
    received(data) {
        console.log("Recebido:", data.message);

        const reportStatus = document.getElementById("report-status");
        if (reportStatus) {
            reportStatus.style.display = "block";
            reportStatus.innerText = data.message;
        }

        if (data.message === "Relatório pronto!") {
            location.reload();
        }
    }
});