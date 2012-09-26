ActiveAdmin.register_page "Admin Faq" do
  menu :label => "Help", :title => "FAQ", :priority => 11
  content do
    div :class => "info", :id => "admin_help_faq" do
      div :class => "intro span16" do
        h3 "Frequently Asked Questions"
        para "This FAQ section helps Site Administrator's to configure site settings."
      end
      div :class => "span16" do
        Faq.all.each_with_index do |faq,index|
          div :class => "well expandable collapsed" do
            h4 "#{index+1}. #{faq.title}"
            a "read more", "#",:class => "read-more",:style => "display: block;"
            div :class => "inner" do
               pre faq.content
            end
          end
        end
      end
    end
  end
end
