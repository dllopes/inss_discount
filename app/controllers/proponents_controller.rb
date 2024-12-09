# frozen_string_literal: true

class ProponentsController < ApplicationController
  before_action :set_proponent, only: %i[show edit update destroy]

  def index
    @proponents = Proponent.includes(:address)

    if params[:report_id].present?
      report = ProponentSalaryReport.find(params[:report_id])
      @proponents = @proponents.where(id: report.proponent_ids)
      @filter_message = "Exibindo proponentes na faixa salarial: #{report.salary_range}"
    end

    @proponents = @proponents.page(params[:page]).per(5)
  end

  def show; end

  def new
    @proponent = Proponent.new
    @proponent.build_address
  end

  def edit
    @proponent.build_address unless @proponent.address
  end

  def create
    @proponent = Proponent.new(proponent_params)

    if @proponent.save
      redirect_to @proponent, notice: 'Proponent was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @proponent.update(proponent_params)
      redirect_to @proponent, notice: 'Proponent was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @proponent.destroy
    redirect_to proponents_url, notice: 'Proponent was successfully deleted.'
  end

  def calculate_discount
    salary = params[:salary].to_f
    inss_discount = SalaryCalculator.new(salary).calculate_inss_discount

    render json: { inss_discount: inss_discount }
  end

  private

  def set_proponent
    @proponent = Proponent.find(params[:id])
  end

  def proponent_params
    params.require(:proponent).permit(
      :name, :cpf, :birth_date, :personal_phone, :reference_phone, :salary,
      address_attributes: %i[street number neighborhood city state zip_code]
    )
  end
end
