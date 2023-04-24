class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :pnumber, :balance, :password
end
