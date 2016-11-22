class Reference
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic 
  extend Enumerize
  before_save :set_tag_ids

  field :name, type: String
  field :describe, type: String

  KINDS = ["文章", "文档", "视频", "链接"]
  enumerize :kind, in: KINDS
  
  
  has_and_belongs_to_many :tags

  def tags_name=(ary)
    @tags_name = ary 
    @tags_name ||= []
  end

   
  def set_tag_ids
    self.tag_ids = @tags_name.map do |tag|
      if !Tag.where(:name => tag).present?
        Tag.create(:name => tag).id
      else
        Tag.find(:name => tag).id
      end
    end
  end

end