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
	The above two airport references have custom naming schemes in their table, but still enforce referential integrity (foreign_key: true).  Rails generates this by default, expecting the column names to match their reference table (ie.- destination_id column associates with the destination table), but here the naming scheme is aliased, so the foreign_keys don't work right.  For some reason, SQLite3 doesn't have a problem with this, but PostGreSQL won't migrate.  The solution -- to specify the actual table -- is in the Flights migration.  See the docs for it [here](https://apidock.com/rails/ActiveRecord/ConnectionAdapters/SchemaStatements/add_foreign_key) (first sentence) and [here](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html#method-i-add_reference) (bottom of section).  Make sure the format is like as shown -- a hash within a hash.
</details>

##### Bookings
* **BELONGS_TO** Flight
* **BELONGS_TO** Passenger
* **BELONGS_TO** Payment Method _(**Note:** This may be changed to HABTM for split transactions)_
Airport information can be gathered through the Flight associations here

##### Passengers
* **HAS_MANY** Payment Methods
* **BELONGS_TO** Bookings