$ ->
  #   code from https://github.com/ryanb/nested_form/wiki/How-to:-limit-max-count-of-nested-fields
  toggleAddLink = ->
    $addLink.toggle fieldsCount < maxFieldsCount
    if fieldsCount >= maxFieldsCount
      $productSelect.prop('disabled', 'disabled')
    else
      $productSelect.prop('disabled', '')


  fieldsCount = 0
  maxFieldsCount = 1

  $addLink = $(".js-products-fields a.add_nested_fields")
  $productSelect = $('.js-auction-product-select')

  $(document).on "nested:fieldAdded", ->
    fieldsCount += 1
    toggleAddLink()

  $(document).on "nested:fieldRemoved", ->
    fieldsCount -= 1
    toggleAddLink()


  # count existing nested fields after page was loaded
  fieldsCount = $("form .fields").length
  toggleAddLink()
