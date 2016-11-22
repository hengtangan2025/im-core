class Faq
  include Mongoid::Document
  include Mongoid::Timestamps

  field :question, type: String
  field :answer, type: String

  before_save :set_tag_ids

  has_and_belongs_to_many :tags
  has_and_belongs_to_many :references



  def tags_name=(ary)
    @tags_name = ary 
    @tags_name ||= []
  end

  def set_tag_ids
    self.tag_ids = @tags_name.map do |tag|
      if !Tag.where(:name => tag).present?
        Tag.create(:name => tag).id
      else
        Tag.where(:name => tag).first.id
      end
    end
  end

end