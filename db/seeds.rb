# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# create some users
User.create(name: 'Alice', email: 'alice@example.com', pnumber: 123456789, password: 'password', balance:0)
User.create(name: 'Bob', email: 'bob@example.com', pnumber: 2345678901, password: 'password', balance:0)
User.create(name: 'Charlie', email: 'charlie@example.com', pnumber: 3456789012, password: 'password', balance:0)
