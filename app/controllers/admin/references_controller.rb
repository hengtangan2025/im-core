class Admin::ReferencesController < ApplicationController
  def index
    @component_name = 'ReferencesIndexPage'
    @component_data = {
      
    }
  end
  
  def new
    chars = ("0".."9").to_a
    @component_name = 'RefNewEditPage'
    @component_data = {
      references: {
        name: nil,
        describe: nil,
        ref_type: chars.map{ |i| 
          {
            id: i,
            name: i
          }
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
    @component_name = 'RefNewEditPage'
    @component_data = {
      questions: {
        name: nil,
        answser: nil,
      },
      tags: {
        id: nil,
        name: nil,
      },
      submit_url: nil,
      cancel_url: nil,
    }
  end

end