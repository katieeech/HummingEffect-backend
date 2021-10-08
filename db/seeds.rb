puts "Deleting seeds! 🗑"
User.destroy_all

puts "Creating seeds! 🌸"
User.create(
  username: "Sean",
  password: "sean",
  point: 30,
)
User.create(
  username: "Katie",
  password: "katie",
  point: 30,
)
User.create(
  username: "Jenna",
  password: "jenna",
  point: 30,
)
User.create(
  username: "Michelle",
  password: "michelle",
  point: 50,
)
User.create(
  username: "David",
  password: "david",
  point: 55,
)
User.create(
  username: "Isaac",
  password: "isaac",
  point: 55,
)
User.create(
  username: "Corey",
  password: "corey",
  point: 45,
)
User.create(
  username: "Itche",
  password: "itche",
  point: 35,
)
User.create(
  username: "Nicholas",
  password: "nicholas",
  point: 25,
)
User.create(
  username: "Yosef",
  password: "yosef",
  point: 15,
)

puts "Done creating seeds ✅"
