window.page_loaded = (func)->
  if Turbolinks?
    jQuery(document).on 'page:change', func
  else
    jQuery(document).ready func