class CustomField < ActiveRecord::Base
  as_enum :type, [:string, :integer, :dropdown, :checkbox, :yes_no, :yes_no_text]

  validates_presence_of :label, :name

  def options
    opt = case self.type
            when :yes_no, :yes_no_text
              self.class.YES_NO_HASH
            else
              self.values.split(',').collect { |opt| [opt.humanize, opt] }
          end
    opt
  end

  def name_extra
    "#{self.name}_extra"
  end

  def self.YES_NO_HASH
    #TODO have the no and yes labels translated?
    #Let's give no preference ;)
  {"No" => 0, "Yes" => 1}
  end
end
