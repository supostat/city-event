# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

EventOptionType.delete_all


event_options = EventOptionType.create([
                                   { title: 'Base Price',
                                     description:'These are an option (price) that applies to entire registration, regardless of who registers. For instance, there may be an event that has a base family price of $10, regardless of family size.' },
                                   { title: 'Variable registration options',
                                     description:'These are options that change from one registration to another, but not from one registrant to another. For instance, a registration might have 3 adult tickets and 2 student tickets without specifying whose is whose.' },
                                   { title: 'Registrant options',
                                     description:'These are options that change from one registrant to another. For instance, if we were putting on an ice cream social registrants might be asked whether they want chocolate or vanilla ice cream.' }
                               ])
puts "#{event_options.count} - Event Options has been created."

@start_date=Time.now + 1.day
@end_date=Time.now + 1.day

Event.delete_all
#Create Event  Annual Dinner
event = Event.create( title: 'Annual Dinner',start_date: @start_date,end_date: @end_date,start_time: '19:00',end_time: '21:00',base_price: '5',max_price: '20')
  #Create Add-Ons for Annual Dinner
  addon=event.addons.create(title: 'Which toppings do you want? ',addon_type: 'Addons::Checkbox')
    addon.choices.create([
                                 {title: 'Sprinkles',price:0.10},
                                 {title: 'Caramel',price:0.10},
                                 {title: 'Chocolate sauce',price:0.10},
                             ])

  addon=event.addons.create( title: 'What is your gender? ',addon_type: 'Addons::Dropdown')
    addon.choices.create([
                       {title: 'Male',price:0.00},
                       {title: 'Female',price:0.00}
                   ])

  addon=event.addons.create( title: 'How many tickets do you need?',addon_type: 'Addons::Scale')
    addon.choices.create([
                             {title: 'Adults',price:10.00,range_from:0,range_to: 10},
                             {title: 'Students',price:5.00,range_from:0,range_to: 15},
                             {title: 'Childcare',price:1.00,range_from:0,range_to: 3}
                         ])

  addon=event.addons.create(title: 'Are there any allergies we should know about? ',addon_type: 'Addons::Text')

@start_date=@start_date + 1.day
@end_date=@end_date + 1.day
#End Event  Annual Dinner
event = Event.create(
        title: 'Cricket Match',
        start_date: @start_date,
        end_date: @end_date,
        start_time: '08:00',
        end_time: '14:00',
        base_price: '2',
        max_price: '4'
      )

event.addons.create([
                        {  title: 'In which area you are good? ',addon_type: 'Addons::Checkbox'},
                        {  title: 'Are you a?',addon_type: 'Addons::Dropdown'},
                        {  title: 'Where will you rate your self? ',addon_type: 'Addons::Scale'},
                        {  title: 'Which Awards you have? ',addon_type: 'Addons::Text'}
                    ])

@start_date=@start_date + 1.day
@end_date=@end_date + 1.day

event = Event.create(
        title: 'Get Together',
        start_date: @start_date,
        end_date: @end_date,
        start_time: '14:00',
        end_time: '15:00',
        base_price: '10',
        max_price: '15'
        )

event.addons.create([
                        {  title: 'Which toppings do you want? ',addon_type: 'Addons::Checkbox'},
                        {  title: 'Which toppings do you want? ',addon_type: 'Addons::Text'}
                    ])
