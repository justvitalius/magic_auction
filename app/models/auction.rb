class Auction < ActiveRecord::Base

  belongs_to :product, inverse_of: :auctions

  validates :title, presence: true, length: { maximum: 64 }
  validates :product_id, presence: true, numericality: { only_integer: true }, unless: lambda{ |a| a.product.try(:valid?) }

  # ошибки валидации на product пробрасывается через nested_attrs. эта проверка не нужна для обязательности присутствия product.
  #validates :product, presence: true, if: lambda{ |a| a.product.try(:valid?) }

  validates :expire_date, presence: true, timeliness: { on_or_after: lambda{ DateTime.now - 1.minutes }, on_or_before: lambda{ DateTime.now + 1.year }, allow_blank: false }
  validates :start_date, presence: true, timeliness: { on_or_after: lambda{ DateTime.now - 2.minutes}, on_or_before: lambda{ |a| a.expire_date - 12.hours }, allow_blank: false }



  accepts_nested_attributes_for :product

  scope :active, -> { where('start_date <= ?', Time.now).where('expire_date > ?', Time.now) }
  scope :inactive, -> { where('expire_date <= ?', Time.now) }
  scope :futured, -> { where('start_date >= ?', Time.now) }

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
    product.images
  end

  def category
    product.category || nil
  end
end
