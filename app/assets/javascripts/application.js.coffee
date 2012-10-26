//= require jquery
//= require jquery_ujs
//= require jquery.ui.core
//= require bootstrap

$ ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()