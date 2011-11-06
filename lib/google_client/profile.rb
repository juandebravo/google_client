module GoogleClient
  class Profile
    attr_accessor :email
    attr_accessor :external_id

    def initialize(params ={})
      @email = params[:email]
      @external_id = params[:external_id]
    end

    def to_s
      "#{self.class.name} => { email: #{@email}, external_id: #{@external_id} }"
    end
  end
end