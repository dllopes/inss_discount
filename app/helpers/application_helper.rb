# frozen_string_literal: true

module ApplicationHelper
  def format_cpf(cpf)
    return '' if cpf.blank?

    cpf.to_s.gsub(/\D/, '').rjust(11, '0').gsub(/(\d{3})(\d{3})(\d{3})(\d{2})/, '\1.\2.\3-\4')
  end
end
