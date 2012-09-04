class CustomField < ActiveRecord::Base
  as_enum :type, [:string, :integer, :dropdown, :checkbox, :yes_no]

  validates_presence_of :label, :name

  has_one :linked_field, :class_name => 'CustomField', :foreign_key => 'linked_field_id'

  scope :level1, where(:linked_field_id => nil)

  def options
    opt = case self.type
            when :yes_no
              self.class.YES_NO_HASH
            else
              self.values.split(',').collect { |opt| [opt.humanize, opt] }
          end
    opt
  end

  def self.YES_NO_HASH
    #TODO have the no and yes labels translated?
    #Let's give no preference ;)
  {"No" => 0, "Yes" => 1}
  end
end
