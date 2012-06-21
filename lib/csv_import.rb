require 'csv'
class CsvImport
  class << self
    def parse_file(model_name, data)
      parsed_file = CSV.parse(data.read)
      column_names = parsed_file[0]
      s = 0
      parsed_file.each_with_index do |row, i|
        next if i == 0
        new_object = model_name.new
        column_names.each_with_index do |column, i|
          new_object.send "#{column}=", row[i]
        end
        if new_object.save
          s = s + 1
        end
      end
      return s
    end
  end
end