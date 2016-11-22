class Admin::FaqsController < ApplicationController
  def new
    chars = ("0".."9").to_a
    @component_name = 'NewAndEditPage'
    @component_data = {
      questions: {
        name: nil,
        answser: nil,
      },
      references: chars.map{ |i| 
        {
          id: i,
          name: i
        }
      },
      tags: chars.map{ |i| 
        {
          id: i,
          name: i
        }
      },
      submit_url: nil,
      cancel_url: nil,
    }
  end

  def edit
    @component_data = {
      questions: {
        name: nil,
        answser: nil,
      },
      references: chars.map{ |i| 
        {
          id: i,
          name: i
        }
      },
      tags: chars.map{ |i| 
        {
          id: i,
          name: i
        }
      },
      submit_url: nil,
      cancel_url: nil,
    }
  end
end