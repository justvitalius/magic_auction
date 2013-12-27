jQuery ->
#  структура для работы
#  .form-group
#     .form-img
#         img
#     input type=file
#  
  $('input[type=file]').on 'change',  (e) ->
    console.log 'выбран новый файл'
    window.loadImage e.target.files[0], ((img) =>
      console.log $(e.target).parents('.form-group').children('.form-img').html(img)
    )