class MigrateRouteAs < ActiveRecord::Migration
  def up
     execute "UPDATE `cmspages` SET `route_as`= 'home_how' where `page_url` ='how'" 
     execute "UPDATE `cmspages` SET `route_as`= 'home_why' where `page_url` ='why'" 
     execute "UPDATE `cmspages` SET `route_as`= 'cityguide_sg' where `page_url` ='sg'" 
     execute "UPDATE `cmspages` SET `route_as`= 'cityguide_hk' where `page_url` ='hk'" 
     execute "UPDATE `cmspages` SET `route_as`= 'cityguide_kl' where `page_url` ='kl'" 
  end

  def down
  end
end
