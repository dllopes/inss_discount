import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["salaryInput", "discountInput"]
    static values = {
        url: String
    }

    connect() {
        console.log("SalaryController conectado!");
        this.calculate = this.debounce(this.calculate.bind(this), 500)
    }

    calculate() {
        const salary = this.salaryInputTarget.value

        // Exibir mensagem de carregamento
        this.discountInputTarget.value = "Calculando..."

        fetch(this.urlValue, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            },
            body: JSON.stringify({ salary: salary })
        })
            .then(response => response.json())
            .then(data => {
                // Atualizar o campo de desconto com o valor recebido
                const formattedDiscount = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(data.inss_discount)
                this.discountInputTarget.value = formattedDiscount
            })
            .catch(error => {
                console.error('Error:', error)
                this.discountInputTarget.value = "Erro"
            })
    }

    debounce(func, wait) {
        let timeout
        return (...args) => {
            clearTimeout(timeout)
            timeout = setTimeout(() => func.apply(this, args), wait)
        }
    }
}