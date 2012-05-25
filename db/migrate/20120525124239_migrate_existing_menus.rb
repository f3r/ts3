class MigrateExistingMenus < ActiveRecord::Migration
  def up
    hw = MenuSection.create(name: 'how-it-works', display_name: 'How it Works?', mtype: 1, location: 1)
    p = Cmspage.find_by_url 'how-it-works'
    hw.cmspages << p
    
    why = MenuSection.create(name: 'why-squarestays', display_name: 'Why SquareStays?', mtype: 1, location: 1)
    p = Cmspage.find_by_url 'why'
    why.cmspages << p
    
    help = MenuSection.create(name: 'help', display_name: 'Help', mtype: 2, location: 2)
    p = Cmspage.find_by_url 'how-it-works'
    help.cmspages << p
    p = Cmspage.find_by_url 'why'
    help.cmspages << p
    p = Cmspage.find_by_url 'singapore-city-guide'
    help.cmspages << p
    p = Cmspage.find_by_url 'hong-kong-city-guide'
    help.cmspages << p
    p = Cmspage.find_by_url 'kuala-lumpur-city-guide'
    help.cmspages << p
  end

  def down
  end
end
