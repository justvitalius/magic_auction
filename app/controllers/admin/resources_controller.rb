class Admin::ResourcesController < Admin::BaseController
  inherit_resources
  helper_method :attributes, :form_attributes, :association_attributes, :associations

  respond_to :html
  actions :all, :except => [:show]

  private

  def attributes
    resource_class.attribute_names - %w(id created_at updated_at)
  end

  def form_attributes
    resource_class.attribute_names - %w(id created_at updated_at)
  end

  def association_attributes
    associations(:belongs_to).map { |a| a.options[:foreign_key] || "#{a.name}_id" }
  end

  def associations(macro=nil)
    assoc=resource_class.reflect_on_all_associations
    assoc.select! { |a| a.macro==macro.to_sym } unless macro.blank?
    assoc
  end

end