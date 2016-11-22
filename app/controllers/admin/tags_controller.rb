class Admin::TagsController < ApplicationController
  def new
    chars = ("0".."9").to_a
    @component_name = 'EditPage'
    @component_data = {
      id: nil,
      name: "TAG1",
      faqs: chars.map{ |i| 
        {
          id: i,
          name: i,
        }
      },
      references:  chars.map{ |i| 
        {
          id: i,
          name: i,
        }
      },
      submit_url: nil,
      cancel_url: nil,
    }
  end
end
