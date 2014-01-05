class Admin::ResourcesController < Admin::BaseController
  inherit_resources
  helper_method :attributes, :form_attributes, :sort_column, :sort_direction, :association_attributes, :associations,
                :searchable?, :scope_badges

  respond_to :html
  actions :all, :except => [ :show ]
  #has_scope :page, default:1

  private
  def end_of_association_chain
    super.order(sort_column_full_name + " " + sort_direction)
  end

  def sort_column
    resource_class.column_names.include?(params[:sort]) ? params[:sort] : "updated_at"
  end

  def sort_column_full_name
    [resource_class.table_name,sort_column].join('.')
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def attributes
    resource_class.attribute_names - %w(id created_at updated_at)
  end

  def form_attributes
    resource_class.attribute_names - %w(id created_at updated_at)
  end

  def association_attributes
    associations(:belongs_to).map{|a| a.options[:foreign_key] || "#{a.name}_id"}
  end

  def associations(macro=nil)
    assoc=resource_class.reflect_on_all_associations
    assoc.select!{|a| a.macro==macro.to_sym} unless macro.blank?
    assoc
  end

  def searchable?
    resource_class.respond_to? :searchable
  end

  def read_written_by
    can? :read
  end

  def taken_scopes
    @taken_scopes||=[:page,:search]
  end

  def scope_badges
    @scope_badges ||=current_scopes.except(*taken_scopes)
  end

end