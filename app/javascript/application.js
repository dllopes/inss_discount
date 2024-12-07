// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
// import "jquery"
// import "bootstrap"
// import "@popperjs/core"
import "chartkick"
import "Chart.bundle"
import Rails from "@rails/ujs";
import "./channels/report_status_channel";

Rails.start();