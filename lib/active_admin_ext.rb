module ActiveAdmin::Views::Pages
  class Dashboard < Base
    def render_sections(sections)
      table :class => "dashboard" do
        sections.in_groups_of(2, false).each do |row|
          tr do
            row.each do |section|
              td do
                render_section(section)
              end
            end
          end
        end
      end
    end
  end
end
