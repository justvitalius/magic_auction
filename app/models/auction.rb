class Auction < ActiveRecord::Base
  belongs_to :product, inverse_of: :auctions

  TIME_STEPS = [30, 60, 120]

  validates :title, presence: true, length: {maximum: 64}
  validates :product_id, presence: true, numericality: {only_integer: true}, unless: lambda { |a| a.product.try(:valid?) }

  validates :expire_date, presence: true, timeliness: {on_or_before: lambda { DateTime.now + 1.year }, allow_blank: false}
  validates :expire_date, timeliness: {on_or_after: lambda { DateTime.now - 1.minutes }}, on: :create

  validates :start_date, presence: true, timeliness: {on_or_before: lambda { |a| a.expire_date - 12.hours }, allow_blank: false}
  validates :start_date, timeliness: {on_or_after: lambda { DateTime.now - 2.minutes }}, on: :create

  validates :price_step, presence: true, numericality: {greater_than_or_equal_to: 0.00}
  validates :time_step, presence: true, numericality: {integer: true}, :inclusion => {:in => TIME_STEPS}

  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0.00}

  after_initialize :default_time_step, :default_price


  accepts_nested_attributes_for :product

  scope :active, -> { where('start_date <= ?', Time.now).where('expire_date > ?', Time.now) }
  scope :inactive, -> { where('expire_date <= ?', Time.now) }
  scope :futured, -> { where('start_date >= ?', Time.now) }


  def active?
    time_now = DateTime.now
    if self.start_date <= time_now && self.expire_date > time_now && self.finish_date > time_now
      true
    else
      false
    end
  end

  def images
    product.images
  end

  def category
    product.category || nil
  end

  def increase_finish_date
    self.finish_date ||= DateTime.now
    self.finish_date += self.time_step.seconds
    self.active?? self.save! : false
  end

  def increase_price
    self.price += self.price_step
    save!
  end

  protected
  def default_time_step
    self.time_step ||= TIME_STEPS.first
  end

  def default_price
    self.price ||= 0
  end
end
