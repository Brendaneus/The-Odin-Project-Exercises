# Flight Booker

From [The Odin Project](https://www.theodinproject.com/courses/ruby-on-rails/lessons/building-advanced-forms?ref=lnav)

Hosted @ [Heroku](https://intense-sea-16053.herokuapp.com)

### Plan:

**Airports, Flights, Bookings, Passengers, Payment Methods**

##### Airports
* **HAS_MANY** Flights, _alias: 'Departing'_
* **HAS_MANY** Flights, _alias: 'Arriving'_

##### Flights
* **BELONGS_TO** Airport, _alias: 'Origin'_
* **BELONGS_TO** Airport, _alias: 'Destination'_
* **HAS_MANY** Bookings
<details>
	<summary>_**IMPORTANT NOTE**_</summary>
	<p>The above two airport references have custom naming schemes in their table, but still enforces referential integrity with <code>foreign_key: {to_table: :airports }</code>.  The <code>to_table</code> part is important because the other table in the association does not match the naming scheme used for the foreign keys here.</p>
	<p>Rails generates this reference as <code>foreign_key: true</code> by default, expecting the column names to match their reference table (ie.- <code>destination_id</code> column associates with the table <code>destinations</code>), but here the naming scheme is aliased, so the <code>foreign_key: true</code> doesn't work right.  For some reason at the time of this writing, SQLite3 doesn't have a problem with this, but when pushing to Heroku and migrating, PostGreSQL hits an error finding the right table.  The solution -- to specify the actual table -- is in the <a href='https://github.com/Brendaneus/the_odin_project/blob/master/ruby_on_rails/odin-flight-booker/db/migrate/20190324203633_create_flights.rb'>Flights migration file</a>.</p>
	<p>See the docs for it <a href='https://apidock.com/rails/ActiveRecord/ConnectionAdapters/SchemaStatements/add_foreign_key'>here</a> (first sentence) and <a href='https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html#method-i-add_reference'>here</a> (bottom of section).  Make sure the format is like as shown -- a hash within a hash.</p>
</details>

##### Bookings
* **BELONGS_TO** Flight
* **HAS_MANY** Passengers

##### Passengers
* **BELONGS_TO** Booking
