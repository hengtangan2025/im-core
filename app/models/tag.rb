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

  def change_faqs(ary)
    del_ids_ary = self.faqs.map{|obj| obj.id.to_s} - ary
    add_ids_ary = ary - self.faqs.map{|obj| obj.id.to_s}
    del_ids_ary.each{|faq_id| Faq.find(faq_id).tag_ids - [self.id]}
    add_ids_ary.each{|faq_id| Faq.find(faq_id).tag_ids + [self.id]}
  end

  def change_refs(ary)
    del_ids_ary = self.refs.map{|obj| obj.id.to_s} - ary
    add_ids_ary = ary - self.refs.map{|obj| obj.id.to_s}
    del_ids_ary.each{|ref_id| Faq.find(ref_id).tag_ids - [self.id]}
    add_ids_ary.each{|ref_id| Faq.find(ref_id).tag_ids + [self.id]}
  end
end