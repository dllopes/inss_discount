class ReportStatusChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info "Cliente conectado ao canal: report_status_channel"
    stream_from "report_status_channel"
  end

  def unsubscribed
    Rails.logger.info "Cliente desconectado do canal: report_status_channel"
  end
end