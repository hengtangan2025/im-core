class ChatRoom
  attr_accessor :type, :key

  # type %w{SINGLE ORGANIZATION}

  def initialize(option)
    @type = option[:type]
    @key = option[:key]
  end

  def receivers
    return _single_receivers if @type == 'SINGLE'
  end

  def data
    {
      type: @type,
      key: @key
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

  class << self
    # sender, receiver 可以颠倒
    def build_single(sender, receiver)
      new({
        type: 'SINGLE',
        key: get_single_key(sender, receiver)
      })
    end

    def get_single_key(member_a, member_b)
      ids = [member_a, member_b].map { |x|
        x.id.to_s
      }.sort.join('-')
    end
  end
end