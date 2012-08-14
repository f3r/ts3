class CustomField < ActiveRecord::Base
  as_enum :type, [:string, :integer, :dropdown, :checkbox]

  validates_presence_of :label, :name

  def options
    self.values.split(',').collect{|opt| [opt.capitalize, opt]}
  end
end
