# Private Events

https://www.theodinproject.com/courses/ruby-on-rails/lessons/associations?ref=lnav#project-2-private-events

I used a has_and_belongs_to_many association to link users to their attended events and implemented a simple 'Attendances' controller because I only needed to create and destroy the attendances.  If you look in the routes, the two '/attend' and '/unattend' routes are nested in events, to set event_id as a parameter in the url by default, and user_id is added to find the user the linking was done for.  It's flexible because the two ids can be freely specified in the link.

Invitations would need all RESTful routes to scale properly as a resource, and because they might need forms in a future iteration, they use a has_many belongs_to association with a model.  The show action is a standard resource, but index, create, and destroy are nested in the events resource for event-based organization and automatic inclusion of an event_id in the params.

There was apparently a problem with the default rails migration generator:  The invitations weren't properly indexed as generated with foreign_keys, so the fix was to replace those with indices.

# TODO:  This thing needs tests badly

* Add automatic deletion of invitations upon accepting

* Make a difference between hosting and just creating

* Allow events to be set to have anyone create invitations

* Clean up views and make partials

* Move all querying, etc to controller

* Maybe add some extras like invitation messages, invite status in event views, etc.