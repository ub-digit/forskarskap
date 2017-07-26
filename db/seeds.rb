# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Locker.create(number: '1A')
Locker.create(number: '1B')
Locker.create(number: '2A')
Locker.create(number: '2B')
Locker.create(number: '3A')
Locker.create(number: '3B')
Locker.create(number: '4A')
Locker.create(number: '4B')
Locker.create(number: '5A')
Locker.create(number: '5B')
Locker.create(number: '6A')
Locker.create(number: '6B')
Locker.create(number: '7A')
Locker.create(number: '7B')
Locker.create(number: '8A')
Locker.create(number: '8B')

Person.create(name: "Karlsson, Extern", personnbr: 2862625055, cardnbr: "000", registrationDate: Date.today, locker_id: 1)

Person.create(name: "Danielsson", personnbr: "19580929gg", cardnbr: "111", registrationDate: Date.today, locker_id: 2)

