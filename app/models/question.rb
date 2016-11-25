  class Question
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Attributes::Dynamic 
    extend Enumerize
    KINDS = [:single_choice, :multi_choice, :bool]
    
    enumerize :kind, in: KINDS
    field :kind, type: String
    field :content, type: String

    field :answer
  end