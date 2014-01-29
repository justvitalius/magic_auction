class Auction < ActiveRecord::Base
  belongs_to :product, inverse_of: :auctions

  validates :title, presence: true, length: { maximum: 64 }

  # TODO: так валидация на обязательное наличие product нормальна?
  validates :product_id, presence: true, numericality: { only_integer: true }, unless: lambda{ |a| a.product.try(:valid?) }
  validates :product, presence: true, if: lambda{ |a| a.product.try(:valid?) }

  # TODO: как валидировать дату? Я вот нашел gem, он как?
  # как написать валидацию, чтобы expire_date был позднее start_date и наоборот, если не задана последовательность задания этих значений, т.е.оба могут быть nil при сохранении
  # эту валидацию можно оформить по другому?
  validates :expire_date, presence: true, timeliness: { on_or_after: lambda{ DateTime.now }, on_or_before: lambda{ DateTime.now + 1.year }, allow_blank: false }

  # TODO: как лучше быть с датой? Она вообще не должна быть в прошлом? Но если пользователь укажет дату,то при сохранеии она окажется в прошлом.
  # почему в этом геме on_or_after не работает в случае если дата равна DateTime.now
  # почему при выполнении тестов, он вставляет время -4часа ? вместо 00:40 он пишет 20:40 в результатах тестирования и после save_and_open_page
  validates :start_date, presence: true, timeliness: { on_or_after: lambda{ DateTime.now }, on_or_before: lambda{ |a| a.expire_date - 12.hours }, allow_blank: false }

  # TODO: как сделать правильно статусы аукционы? Через state-machine? Они вообще нужны?
  # TODO: стоит ли писать в миграциях свойства типа default: или null:false


  accepts_nested_attributes_for :product

  # TODO: вообще есть разница что использовать DateTime, Time или еще что-то
  scope :active, -> { where('expire_date > ?', Time.now) }
  scope :inactive, -> { where('expire_date <= ?', Time.now) }

  # TODO: в контроллере будет выполняться логика типа «если у пользователя есть ставки, то сделай set_rate у модели»
  # а здесь просто описать действия типа:
  # 1. данный статус дает делать ставку?
  # 2. если статус позволяет, то изменяем временной интервал и
  # 3. записываем в этой же таблице новый "временной интервал" и "время окончания временного интервала"
  # 4. после записи возвращает true, false и текст ошибки
  #
  # но по идее нужно еще сохранить в отдельной таблице «кто сделал ставку» и «время совершения ставки» и «стоимость ставки»
  # где это лучше делать? Тут или в контроллере?
  def set_rate
  end

  def images
    product.images || []
  end

  def category
    product.category || nil
  end
end
