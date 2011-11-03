module GoogleClient

  class Contact

    attr_reader   :id
    attr_accessor :name
    attr_accessor :email
    attr_accessor :phone_number
    attr_accessor :user

    def initialize(params = {})
      @id = params[:id]
      @name = params[:name]
      @email = params[:email]
      @phone_number = params[:phone_number]
      @user = params[:user]
    end

    def to_s
      "#{self.class.name} => { name: #{@name}, email: #{@email}, :phone_number => #{@phone_number} }"
    end


    def save

    end

    class << self
      def build_contact(data, user = nil)
        id = begin
          data["id"]["$t"].split("base/").last
        rescue
          nil
        end
        name = begin
          data["title"]["$t"].split("full/").last
        rescue
          ""
        end
        email = begin
          data["gd$email"].collect { |address| address.select { |item| item["address"] }.values }.flatten
        rescue
          []
        end
        phone_number = begin
          data["gd$phoneNumber"].collect { |number| number.select { |item| item["$t"] }.values }.flatten
        rescue
          []
        end
        Contact.new({:name => name, :email => email, :phone_number => phone_number, :user => user})
      end
    end

  end

end