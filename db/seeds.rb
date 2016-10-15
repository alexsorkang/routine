# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = User.new
user.email = 'test@test.com'
user.password = 'password123'
user.save!

# exercise = Routine.new
# exercise.name = 'stronglift 5x5'
# exercise.description = 'test text'
# exercise.routine = {'split':2, 'list':[[['bench', 5,5],['rows', 3,8]],[['ohp',5,5],['deadlift',1,5]]]}
# exercise.difficulty = 'novice'
# exercise.save!

exercise = Routine.create(name:'stronglift 5x5',description:'test text',routine:{'split':2, 'list':[[['bench', 5,5],['rows', 3,8]],[['ohp',5,5],['deadlift',1,5]]]},difficulty:'novice')
# exercise1 = Routine.create(name:'test\'s routine',description:'test text',routine:{'split':2, 'list':[[['bench', 5,5],['rows', 3,8]],[['ohp',5,5],['deadlift',1,5]]]},difficulty:'novice')

user.routines.create(name:'tests routine',description:'test text',routine:{'split':2, 'list':[[['bench', 5,5],['rows', 3,8]],[['ohp',5,5],['deadlift',1,5]]]},difficulty:'novice')
user.routines.create(name:'second text routine',description:'this is another test text',routine:{'split':2, 'list':[[['bench', 5,5],['rows', 3,8]],[['ohp',5,5],['deadlift',1,5]]]},difficulty:'novice')