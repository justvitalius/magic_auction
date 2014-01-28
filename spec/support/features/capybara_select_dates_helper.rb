require 'xpath'

# TODO: есть ли готовые способы выбора даты-времени в capybara, а то вот я нашел и доделал эту заготовку
module Features
  module SelectDatesAndTimesHelper
    def select_date (date, options = {})
      date = Date.parse(date.to_s)

      # lookup id prefix by label
      id_prefix = id_prefix_for(options[:from])

      # select the appropriate date values
      select date.year, :from => "#{id_prefix}_1i"
      select I18n.l(date, format: ('%B')), :from => "#{id_prefix}_2i"
      select date.day, :from => "#{id_prefix}_3i"
    end

    def select_time (time, options = {})
      time = Time.parse(time.to_s)

      # lookup id prefix by label
      id_prefix = id_prefix_for(options[:from])

      # select the appropriate time values
      select(time.hour.to_s.rjust(2, '0'), :from => "#{id_prefix}_4i")
      select(time.min.to_s.rjust(2, '0'), :from => "#{id_prefix}_5i")
    end

    # TODO: имя select_datetime пересекатеся с классическим хэлпером в самих рельсах, как его можно вызывать в спеках,чтобы вызывался только этот метод? Я придумал добавить префикс только.
    def select_datetime (datetime, options = {})
      select_date(datetime, options)
      select_time(datetime, options)
    end

    protected
    def id_prefix_for (label_text)
      # lookup label by contents
      # determine the datetime fields' id prefix from the label's @for attribute
      # rails simple_form generate label for DateTime with label "model_attribute_3i" ...
      # maybe it's error and then we need gsubing label name to correct find date select
      find(:xpath, %Q{//form/*/label[contains(text(), "#{label_text}")]})[:for].gsub(/_\d+i/, '')
    end
  end
end