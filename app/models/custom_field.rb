class CustomField < ActiveRecord::Base
  as_enum :type, [:string, :integer]
end
