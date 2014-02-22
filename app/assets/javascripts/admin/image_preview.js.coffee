jQuery ->
#  структура для работы
#  .form-group
#     .form-img
#         img
#     input type=file
#
  $(document).on 'change', 'input[type=file]', (e) ->
    console.log 'выбран новый файл'
    window.loadImage e.target.files[0], ((img) =>
      console.log $(e.target).parents('.form-group').children('.form-img').html(img)
    )