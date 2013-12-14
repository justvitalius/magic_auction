class NullAttribute
  def initialize(template)
    @template=template
  end

  def to_s
    empty_tag
  end

  private
  def empty_tag
    @template.content_tag(:em, empty_text, :class=>'muted')
  end

  def empty_text
    I18n.t('attributes.missing_attribute')
  end
end