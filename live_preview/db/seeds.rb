# Web Development 101
web_101 = Course.create!(name: "Web Development 101")
web_101.projects.create!(name: "Google Mockup")
web_101.projects.create!(name: "Rock Paper Scissors", visible: false)
web_101.projects.create!(name: "Etch-a-Sketch", visible: false)
web_101.projects.create!(name: "Calculator", visible: false)
web_101.projects.create!(name: "Learn Ruby")
web_101.projects.create!(name: "Blogger")
web_101.projects.create!(name: "Pomodoro", visible: false)

# Ruby Programming
ruby_prog = Course.create!(name: "Ruby Programming")
ruby_prog.projects.create!(name: "Caesar Cipher")
ruby_prog.projects.create!(name: "Stock Picker")
ruby_prog.projects.create!(name: "Substrings")
ruby_prog.projects.create!(name: "Bubble Sort")
ruby_prog.projects.create!(name: "Enumerable Methods")
ruby_prog.projects.create!(name: "Tic Tac Toe (Ruby Version)")
ruby_prog.projects.create!(name: "Mastermind")
ruby_prog.projects.create!(name: "Event Manager")
ruby_prog.projects.create!(name: "Hangman")
ruby_prog.projects.create!(name: "Fibonacci")
ruby_prog.projects.create!(name: "Merge Sort")
ruby_prog.projects.create!(name: "Linked Lists")
ruby_prog.projects.create!(name: "Binary Search")
ruby_prog.projects.create!(name: "Knights Travails")
ruby_prog.projects.create!(name: "Time Traveling", visible: false)
ruby_prog.projects.create!(name: "TDD Connect Four", visible: false)
ruby_prog.projects.create!(name: "Chess", visible: false)

# Databases
database = Course.create!(name: "Databases", visible: false)

# Ruby on Rails
ruby_rails = Course.create!(name: "Ruby on Rails")
ruby_rails.projects.create!(name: "Caesar Cipher", visible: false)
ruby_rails.projects.create!(name: "Another Web-Game", visible: false)
ruby_rails.projects.create!(name: "Toy App")
ruby_rails.projects.create!(name: "Rest Client", visible: false)
ruby_rails.projects.create!(name: "Sample App")
ruby_rails.projects.create!(name: "Micro Reddit", visible: false)
ruby_rails.projects.create!(name: "Re-Former")
ruby_rails.projects.create!(name: "Members Only")
ruby_rails.projects.create!(name: "Private Events")
ruby_rails.projects.create!(name: "Flight Booker")
ruby_rails.projects.create!(name: "Kittens API")
ruby_rails.projects.create!(name: "Flickr API")
ruby_rails.projects.create!(name: "Odinbook", visible: false)

# HTML and CSS
html_css = Course.create!(name: "HTML and CSS")

# Javascript
javascript = Course.create!(name: "Javascript")
javascript.projects.create!(name: "Library")
javascript.projects.create!(name: "Tic Tac Toe (Javascript Version)")
javascript.projects.create!(name: "Restaurant Page")
javascript.projects.create!(name: "Todo List")

# Node.js (?)
node = Course.create!(name: "Node.js")

#SET VISIBILITY SCOPES