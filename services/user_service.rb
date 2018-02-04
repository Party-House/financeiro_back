require './models/user'

class UserService
  def getUsers ()
    result = []
    users = User.all
    users.each do | p |
      result << {
        :id => p.id,
        :name => p.name
      }
    end
  end
end