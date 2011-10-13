require 'json'

puts [{
  "id"       => 18919,
  "name"     => "Playstation",
  "photo"    => "http://s3.amazon.com/heypal/photo.jpg",
  "location" => {
    "country" => "United States",
    "city"   => "Detroit",
    "zip"    => "808288"
  },
  "condition" => 1,
  "pick_up"   => true,
  "deliver"   => true,
  "updated_on" => "2011-10-12 14:55:30 0800",
  "category_tree" => [
    {"id" => 31, "name" => "Consoles"     },
    {"id" => 13, "name" => "VideoGames"   },
    {"id" => 4,  "name" => "Electronics"  }
  ],

  "Transaction" => {
    "for_lend"          => false,
    "for_rent"          => true,
    "for_give"          => true,
    "for_sell"          => true,
    "currency "         => "USD",
    "for_rent_price"    => "1243", 
    "for_sell_price"    => "20000"
  },

  "user" => {
    "name"   => "Fer Martin",
    "photo"  => "http://s3.amazon.com/heypal/user/123/photo.png",
    "reviews" => 13,
    "badges" => 4
  }
},
{
  "id"       => 18828,
  "name"     => "Sports Bycicle",
  "photo"    => "http://s3.amazon.com/heypal/photo2.jpg",
  "location" => {
    "country" => "Canada",
    "city"   => "Toronto",
    "zip"    => "626611"
  },
  "condition" => 2,
  "pick_up"   => true,
  "deliver"   => false,
  "added_on" => "2011-10-12 14:55:30 0800",
  "category_tree" => [
    {"id" => 11, "name" => "Bicycles" },
    {"id" => 3,  "name" => "Sports"   }
  ],
  "Transaction" => {
    "for_lend"      => true,
    "for_rent"      => false,
    "for_give"      => false,
    "for_sell"      => true,
    "currency"      => "CAD",
    "for_sell_price" => "20000"
  },

  "user" => {
    "name"   => "Jeremy Snyder",
    "photo"  => "http://s3.amazon.com/heypal/user/11/photo.png",
    "reviews" => 23,
    "badges" => 9
  }
}
].to_json

