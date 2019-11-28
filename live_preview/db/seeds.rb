# Web Development 101
web_development_101 = Course.create!(
	slug: "web-development-101",
	name: "Web Development 101",
	source: "https://github.com/Brendaneus/the_odin_project/tree/master/web_development_101",
	tutorial: "https://www.theodinproject.com/courses/web-development-101"
)

google_mockup = web_development_101.projects.create!(
	slug: "google-mockup",
	name: "Google Mockup",
	notes: "Created using visual reference only (good luck trying to navigate Google's mess of divs).",
	tutorial: "https://www.theodinproject.com/courses/web-development-101/lessons/html-css",
	source: "https://github.com/Brendaneus/the_odin_project/tree/master/web_development_101/google-homepage",
	url: "https://the-odin-projects-live.s3.us-east-1.amazonaws.com/web_development_101/google-homepage/index.html"
)

rock_paper_scissors = web_development_101.projects.create!(
	complete: false,
	visible: false,
	slug: "rock-paper-scissors",
	name: "Rock Paper Scissors",
	tutorial: "https://www.theodinproject.com/courses/web-development-101/lessons/rock-paper-scissors",
	source: "",
	url: ""
)

etch_a_sketch = web_development_101.projects.create!(
	complete: false,
	visible: false,
	slug: "etch-a-sketch",
	name: "Etch-a-Sketch",
	tutorial: "https://www.theodinproject.com/courses/web-development-101/lessons/etch-a-sketch-project",
	source: "",
	url: ""
)

calculator = web_development_101.projects.create!(
	complete: false,
	visible: false,
	slug: "calculator",
	name: "Calculator",
	tutorial: "https://www.theodinproject.com/courses/web-development-101/lessons/calculator",
	source: "",
	url: ""
)

learn_ruby = web_development_101.projects.create!(
	complete: false,
	slug: "learn-ruby",
	name: "Learn Ruby",
	tutorial: "https://www.theodinproject.com/courses/web-development-101/lessons/ruby",
	source: "https://github.com/Brendaneus/the_odin_project/tree/master/web_development_101/learn_ruby",
	url: ""
)

blogger = web_development_101.projects.create!(
	complete: false,
	slug: "blogger",
	name: "Blogger",
	notes: "Currently, this app does not support image uploads in production, and is awaiting a fix.",
	tutorial: "https://www.theodinproject.com/courses/web-development-101/lessons/ruby-on-rails",
	source: "https://github.com/Brendaneus/the_odin_project/tree/master/web_development_101/blogger",
	url: "https://odin-blogger-live.herokuapp.com/"
)

pomodoro = web_development_101.projects.create!(
	complete: false,
	visible: false,
	slug: "pomodoro",
	name: "Pomodoro",
	tutorial: "https://www.theodinproject.com/courses/web-development-101/lessons/pairing-project",
	source: "",
	url: ""
)

# Ruby Programming
ruby_programming = Course.create!(
	slug: "ruby-programming",
	name: "Ruby Programming",
	source: "https://github.com/Brendaneus/the_odin_project/blob/master/ruby_programming",
	tutorial: "https://www.theodinproject.com/courses/ruby-programming"
)

caesar_cipher = ruby_programming.projects.create!(
	complete: false,
	slug: "caesar-cipher",
	name: "Caesar Cipher (Ruby)",
	notes: "Relies on Rspec; awaiting implementation.",
	tutorial: "https://www.theodinproject.com/courses/ruby-programming/lessons/building-blocks#project-1-caesar-cipher",
	source: "https://github.com/Brendaneus/the_odin_project/tree/master/ruby_programming/caesar_cipher",
	url: ""
)

stock_picker = ruby_programming.projects.create!(
	slug: "stock-picker",
	name: "Stock Picker",
	tutorial: "https://www.theodinproject.com/courses/ruby-programming/lessons/building-blocks#project-2-stock-picker",
	source: "https://github.com/Brendaneus/the_odin_project/blob/master/ruby_programming/stock_picker.rb",
	url: "https://repl.it/@Brendaneus/Stock-Picker?lite=true"
)

substrings = ruby_programming.projects.create!(
	slug: "substrings",
	name: "Substrings",
	tutorial: "https://www.theodinproject.com/courses/ruby-programming/lessons/building-blocks#project-3-substrings",
	source: "https://github.com/Brendaneus/the_odin_project/blob/master/ruby_programming/substrings.rb",
	url: "https://repl.it/@Brendaneus/Substrings?lite=true"
)

bubble_sort = ruby_programming.projects.create!(
	slug: "bubble-sort",
	name: "Bubble Sort",
	tutorial: "https://www.theodinproject.com/courses/ruby-programming/lessons/advanced-building-blocks#project-1-bubble-sort",
	source: "https://github.com/Brendaneus/the_odin_project/blob/master/ruby_programming/bubble_sort.rb",
	url: "https://repl.it/@Brendaneus/Bubble-Sort?lite=true"
)

enumerable_methods = ruby_programming.projects.create!(
	complete: false,
	slug: "enumerable-methods",
	name: "Enumerable Methods",
	notes: "Relies on Rspec; awaiting implementation.",
	tutorial: "https://www.theodinproject.com/courses/ruby-programming/lessons/advanced-building-blocks#project-2-enumerable-methods",
	source: "https://github.com/Brendaneus/the_odin_project/tree/master/ruby_programming/enumerable_methods",
	url: ""
)

tic_tac_toe_ruby = ruby_programming.projects.create!(
	complete: false,
	slug: "tic-tac-toe-(ruby)",
	name: "Tic Tac Toe (Ruby Version)",
	notes: "Seems to have some matching bugs; awaiting fix.",
	tutorial: "https://www.theodinproject.com/courses/ruby-programming/lessons/oop#project-1-tic-tac-toe",
	source: "https://github.com/Brendaneus/the_odin_project/blob/master/ruby_programming/tic_tac_toe.rb",
	url: "https://repl.it/@Brendaneus/Tic-Tac-Toe?lite=true"
)

mastermind = ruby_programming.projects.create!(
	slug: "mastermind",
	name: "Mastermind",
	tutorial: "https://www.theodinproject.com/courses/ruby-programming/lessons/oop#project-2-mastermind",
	source: "https://github.com/Brendaneus/the_odin_project/blob/master/ruby_programming/mastermind.rb",
	url: "https://repl.it/@Brendaneus/Mastermind?lite=true"
)

event_manager = ruby_programming.projects.create!(
	complete: false,
	slug: "event-manager",
	name: "Event Manager",
	notes: "Relies on Rspec; awaiting implementation.",
	tutorial: "https://www.theodinproject.com/courses/ruby-programming/lessons/event-manager",
	source: "https://github.com/Brendaneus/the_odin_project/tree/master/ruby_programming/event_manager",
	url: ""
)

hangman = ruby_programming.projects.create!(
	slug: "hangman",
	name: "Hangman",
	tutorial: "https://www.theodinproject.com/courses/ruby-programming/lessons/file-i-o-and-serialization",
	source: "https://github.com/Brendaneus/the_odin_project/tree/master/ruby_programming/hangman",
	url: "https://repl.it/@Brendaneus/Hangman?lite=true"
)

fibonacci = ruby_programming.projects.create!(
	slug: "fibonacci",
	name: "Fibonacci",
	tutorial: "https://www.theodinproject.com/courses/ruby-programming/lessons/recursion#warmup-fibonacci",
	source: "https://github.com/Brendaneus/the_odin_project/blob/master/ruby_programming/fibonacci.rb",
	url: "https://repl.it/@Brendaneus/Fibonacci?lite=true"
)

merge_sort = ruby_programming.projects.create!(
	slug: "merge-sort",
	name: "Merge Sort",
	tutorial: "https://www.theodinproject.com/courses/ruby-programming/lessons/recursion#project-merge-sort",
	source: "https://github.com/Brendaneus/the_odin_project/blob/master/ruby_programming/merge_sort.rb",
	url: "https://repl.it/@Brendaneus/Merge-Sort?lite=true"
)

linked_lists = ruby_programming.projects.create!(
	slug: "linked-lists",
	name: "Linked Lists",
	tutorial: "https://www.theodinproject.com/courses/ruby-programming/lessons/linked-lists",
	source: "https://github.com/Brendaneus/the_odin_project/blob/master/ruby_programming/linked_list.rb",
	url: "https://repl.it/@Brendaneus/Linked-Lists?lite=true"
)

binary_search = ruby_programming.projects.create!(
	slug: "binary-search",
	name: "Binary Search",
	complete: false,
	visible: false,
	tutorial: "https://www.theodinproject.com/courses/ruby-programming/lessons/data-structures-and-algorithms#project-1-binary-search-trees",
	source: "",
	url: ""
)

knights_travails = ruby_programming.projects.create!(
	slug: "knights-travails",
	name: "Knights Travails",
	notes: "Very slow, could use a check for visited spaces.",
	tutorial: "https://www.theodinproject.com/courses/ruby-programming/lessons/data-structures-and-algorithms#project-2-knights-travails",
	source: "https://github.com/Brendaneus/the_odin_project/blob/master/ruby_programming/knights_travails.rb",
	url: "https://repl.it/@Brendaneus/Knights-Travails?lite=true"
)

time_traveling = ruby_programming.projects.create!(
	complete: false,
	visible: false,
	slug: "time-traveling",
	name: "Time Traveling",
	tutorial: "https://www.theodinproject.com/courses/ruby-programming/lessons/testing-your-ruby-code#warmup-time-traveling",
	source: "",
	url: ""
)

connect_four = ruby_programming.projects.create!(
	complete: false,
	visible: false,
	slug: "connect-four",
	name: "Connect Four",
	tutorial: "https://www.theodinproject.com/courses/ruby-programming/lessons/testing-your-ruby-code#project-tdd-connect-four",
	source: "",
	url: ""
)

chess = ruby_programming.projects.create!(
	complete: false,
	visible: false,
	slug: "chess",
	name: "Chess",
	tutorial: "https://www.theodinproject.com/courses/ruby-programming/lessons/ruby-final-project",
	source: "",
	url: ""
)

# Databases (necessary???)
database = Course.create!(
	visible: false,
	slug: "databases",
	name: "Databases",
	tutorial: "https://www.theodinproject.com/courses/databases"
)

# Ruby on Rails
ruby_on_rails = Course.create!(
	slug: "ruby-on-rails",
	name: "Ruby on Rails",
	source: "https://github.com/Brendaneus/the_odin_project/tree/master/ruby_on_rails",
	tutorial: "https://www.theodinproject.com/courses/ruby-on-rails"
)

caesar_cipher_reloaded = ruby_on_rails.projects.create!(
	complete: false,
	visible: false,
	slug: "caesar-cipher-reloaded",
	name: "Caesar Cipher Reloaded",
	tutorial: "https://www.theodinproject.com/courses/ruby-on-rails/lessons/sinatra-project#project-1-caesar-cipher-reloaded",
	source: "",
	url: ""
)

another_web_game = ruby_on_rails.projects.create!(
	complete: false,
	visible: false,
	slug: "another-web-game",
	name: "Another Web-Game",
	tutorial: "https://www.theodinproject.com/courses/ruby-on-rails/lessons/sinatra-project#project-2-another-web-game",
	source: "",
	url: ""
)

toy_app = ruby_on_rails.projects.create!(
	slug: "toy-app",
	name: "Toy App",
	notes: "A bare-bones Rails test app.",
	tutorial: "https://www.theodinproject.com/courses/ruby-on-rails/lessons/getting-your-feet-wet#project-starting-the-ror-tutorial",
	source: "https://github.com/Brendaneus/the_odin_project/tree/master/ruby_on_rails/toy_app",
	url: "https://odin-toy-app-live.herokuapp.com/"
)

rest_client = ruby_on_rails.projects.create!(
	complete: false,
	visible: false,
	slug: "rest-client",
	name: "Rest Client",
	tutorial: "https://www.theodinproject.com/courses/ruby-on-rails/lessons/let-s-get-building#warmup-restclient",
	source: "",
	url: ""
)

sample_app = ruby_on_rails.projects.create!(
	complete: false,
	slug: "sample-app",
	name: "Sample App",
	notes: "Awaiting Carrierwave debugging.",
	tutorial: "https://www.theodinproject.com/courses/ruby-on-rails/lessons/let-s-get-building#project-ruby-on-rails-tutorial",
	source: "https://github.com/Brendaneus/the_odin_project/tree/master/ruby_on_rails/sample_app",
	url: "https://odin-sample-app-live.herokuapp.com/"
)

micro_reddit = ruby_on_rails.projects.create!(
	complete: false,
	slug: "micro-reddit",
	name: "Micro Reddit",
	notes: "This app is currently lacking a front-end.",
	tutorial: "https://www.theodinproject.com/courses/ruby-on-rails/lessons/building-with-active-record-ruby-on-rails#project-2-micro-reddit",
	source: "https://github.com/Brendaneus/the_odin_project/tree/master/ruby_on_rails/micro-reddit",
	url: "https://odin-micro-reddit-live.herokuapp.com/"
)

re_former = ruby_on_rails.projects.create!(
	complete: false,
	slug: "re-former",
	name: "Re-Former",
	notes: "This app is currently lacking a front-end.",
	tutorial: "https://www.theodinproject.com/courses/ruby-on-rails/lessons/forms#project-1-bare-metal-forms-and-helpers",
	source: "https://github.com/Brendaneus/the_odin_project/tree/master/ruby_on_rails/re-former",
	url: ""
)

members_only = ruby_on_rails.projects.create!(
	slug: "members-only",
	name: "Members Only",
	notes: "An exercise in custom authentication/authorization",
	tutorial: "https://www.theodinproject.com/courses/ruby-on-rails/lessons/authentication#project-2-members-only",
	source: "https://github.com/Brendaneus/the_odin_project/tree/master/ruby_on_rails/members-only",
	url: "https://odin-members-only-live.herokuapp.com/posts/"
)

private_events = ruby_on_rails.projects.create!(
	slug: "private-events",
	name: "Private Events",
	tutorial: "https://www.theodinproject.com/courses/ruby-on-rails/lessons/associations#project-2-private-events",
	source: "https://github.com/Brendaneus/the_odin_project/tree/master/ruby_on_rails/private-events",
	url: "https://odin-private-events-live.herokuapp.com/events/"
)

flight_booker = ruby_on_rails.projects.create!(
	slug: "flight-booker",
	name: "Flight Booker",
	tutorial: "https://www.theodinproject.com/courses/ruby-on-rails/lessons/building-advanced-forms#project-flight-booker",
	source: "https://github.com/Brendaneus/the_odin_project/tree/master/ruby_on_rails/odin-flight-booker",
	url: "https://odin-flight-booker-live.herokuapp.com/"
)

kittens_api = ruby_on_rails.projects.create!(
	slug: "kittens-api",
	name: "Kittens API",
	tutorial: "https://www.theodinproject.com/courses/ruby-on-rails/lessons/apis#project-1-building-a-simple-kittens-api",
	source: "https://github.com/Brendaneus/the_odin_project/tree/master/ruby_on_rails/odin-kittens",
	url: "https://odin-kittens-api-live.herokuapp.com/"
)

flickr_api = ruby_on_rails.projects.create!(
	slug: "flickr-api",
	name: "Flickr API",
	notes: "An app demonstrating use of the Flickr API to find an account's photos by id",
	tutorial: "https://www.theodinproject.com/courses/ruby-on-rails/lessons/apis#project-2-using-a-third-party-api",
	source: "https://github.com/Brendaneus/the_odin_project/tree/master/ruby_on_rails/flickr-api",
	url: "https://odin-flickr-api-live.herokuapp.com/"
)

odinbook = ruby_on_rails.projects.create!(
	complete: false,
	visible: false,
	slug: "odinbook",
	name: "Odinbook",
	tutorial: "https://www.theodinproject.com/courses/ruby-on-rails/lessons/final-project",
	source: "",
	url: ""
)

# HTML and CSS
html_css = Course.create!(
	slug: "html-and-css",
	name: "HTML and CSS",
	tutorial: "https://www.theodinproject.com/courses/html5-and-css3"
)

# Javascript
javascript = Course.create!(
	slug: "javascript",
	name: "Javascript",
	source: "https://github.com/Brendaneus/the_odin_project/tree/master/javascript",
	tutorial: "https://www.theodinproject.com/courses/javascript"
)

library = javascript.projects.create!(
	slug: "library",
	name: "Library",
	tutorial: "https://www.theodinproject.com/courses/javascript/lessons/library",
	source: "https://github.com/Brendaneus/the_odin_project/tree/master/javascript/library",
	url: "https://the-odin-projects-live.s3.us-east-1.amazonaws.com/javascript/library/index.html"
)

tic_tac_toe_javascript = javascript.projects.create!(
	complete: false,
	slug: "tic-tac-toe-(javascript)",
	name: "Tic Tac Toe (Javascript Version)",
	notes:  "Seems to have some matching bugs; awaiting fix.",
	tutorial: "https://www.theodinproject.com/courses/javascript/lessons/tic-tac-toe-javascript",
	source: "https://github.com/Brendaneus/the_odin_project/tree/master/javascript/tic_tac_toe",
	url: "https://the-odin-projects-live.s3.us-east-1.amazonaws.com/javascript/tic_tac_toe/index.html"
)

restaurant_page = javascript.projects.create!(
	slug: "restaurant-page",
	name: "Restaurant Page",
	tutorial: "https://www.theodinproject.com/courses/javascript/lessons/restaurant-page",
	source: "https://github.com/Brendaneus/the_odin_project/tree/master/javascript/restaurant_page",
	url: "https://the-odin-projects-live.s3.us-east-1.amazonaws.com/javascript/restaurant_page/dist/index.html"
)

todo_list = javascript.projects.create!(
	complete: false,
	slug: "todo-list",
	name: "Todo List",
	notes: "Looks like there are still a few bugs to work out.  Fix coming soon-ish.",
	tutorial: "https://www.theodinproject.com/courses/javascript/lessons/todo-list",
	source: "https://github.com/Brendaneus/the_odin_project/tree/master/javascript/todo_list",
	url: "https://the-odin-projects-live.s3.us-east-1.amazonaws.com/javascript/todo_list/dist/index.html"
)

# Node.js (?)
node = Course.create!(
	slug: "node-js",
	name: "Node.js",
	tutorial: "https://www.theodinproject.com/courses/nodejs"
)
