$(document).ready ->
  $forms = $(".js-lists-api-form")

  $forms.on "ajax:beforeSend", (e, xhr, settings) ->
    xhr.setRequestHeader "X-Lists-Api-Token", Lists.globals.apiToken

  $forms.on "ajax:success", (event, data, status, xhr) ->
    console.log(data)

  $forms.on "ajax:error", (e, xhr, status, ajaxError) ->
    $form = $(@)
    response = xhr.responseJSON
    if response
      for error, messages of response.errors
        $form.find(".js-lists-api-form-error[data-input-name='#{response.class}[#{error}]']").html(messages.join(", ")).removeClass("hide")

  $forms.find("input[data-dependent=true]").change ->
    $(@).closest("form").submit()

  $forms.each ->
    $form = $(@)
    $dependentInputs = $form.find("input[data-dependent=true]")
    if $dependentInputs.length
      $form.submit ->
        submit = true
        $dependentInputs.each ->
          if $(@).val().length == 0
            $($(@).data("dependent-on-form")).submit()
            submit = false
        submit
      $dependentInputs.each ->
        $input = $(@)
        $dependentOnForm = $($(@).data("dependent-on-form"))
        $dependentOnInput = $dependentOnForm.find("input[name='#{$input.data("dependent-on-input")}']")
        $dependentOnInput.change ->
          $input.val($(@).val()).change()

  $(".js-lists-api-form-submit").click ->
    $(@).closest("form").submit()

  $(".js-lists-api-submit-on-change").change ->
    $(@).closest("form").submit()

  $(".js-lists-api-submit-on-enter").keydown (e) ->
    if e.keyCode == 13  && !e.shiftKey
      e.preventDefault()
      $(@).closest("form").submit()
      $(@).val("")

  $(".js-lists-form-search").each ->
    $form = $(@)
    searchDelay = ""
    $(@).find(".js-lists-form-search-q").on "keydown", (e) ->
      window.clearTimeout(searchDelay)
      searchDelay = setTimeout =>
        $form.submit()
      , 500

  $(".js-lists-api-foreign-input").change ->
    console.log($($(@).data("target-form")))
    $($(@).data("target-form")).find("input[name='#{$(@).data("target-input")}']").val($(@).val()).change()
