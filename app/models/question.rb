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

  validates :content, :kind, :answer, presence: true

  def controller_data
    {
      kind: self.kind,
      content: self.content,
      answer: self.answer,
    }
  end
end