class ChatRoom
  attr_accessor :type, :key, :sender_id

  # type %w{SINGLE ORGANIZATION}

  def initialize(option)
    @type       = option[:type]
    @key        = option[:key]
    @sender_id  = option[:sender_id]
  end

  def receivers
    return _single_receivers if @type == 'SINGLE'
    return _organization_receivers if @type == 'ORGANIZATION'
  end

  def data
    {
      type: @type,
      key: @key,
      sender_id: @sender_id
    }
  end

  def ==(room)
    @type = room.type and @key == room.key
  end

  private
    def _single_receivers
      ids = @key.split('-')
      Member.where(:id.in => ids)
    end

    def _organization_receivers
      members = OrganizationNode.find(@key).members + [Member.find(@sender_id)]
      members.uniq
    end

  class << self
    # sender, receiver 可以颠倒
    def build_single(sender, receiver)
      new({
        type: 'SINGLE',
        key: get_single_key(sender, receiver),
        sender_id: sender.id.to_s
      })
    end

    def build_organization(sender, organization_node)
      new({
        type: 'ORGANIZATION',
        key: organization_node.id.to_s,
        sender_id: sender.id.to_s
      })
    end

    def get_single_key(member_a, member_b)
      ids = [member_a, member_b].map { |x|
        x.id.to_s
      }.sort.join('-')
    end
  end
end