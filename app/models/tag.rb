class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  
  def refs
    Reference.where(:tag_ids.in=>[self.id]).all.to_a
  end

  def faqs
    Faq.where(:tag_ids.in=>[self.id]).all.to_a
  end

  def change_faqs(arys)
    arys.each{|faq_id| Faq.find(faq_id).tag_ids.push(self.id).uniq}
  end

  def change_refs(arys)
    arys.each{|ref_id| Reference.find(ref_id).tag_ids.push(self.id).uniq}
  end

end