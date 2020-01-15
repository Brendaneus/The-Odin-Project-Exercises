# Where's Waldo
## Point and click image search

This is a Rails 6 application.  Source code tree may differ significantly from other Odin Project examples.  The most noticable differences are the dedicated javascript folder seperate from the rest of Rails' assets folder and the use of ActiveStorage in place of any outsourced image hosting solutions.

This was mostly an exercise in meshing Rails views with Vue -- and in hindsight, Turbolinks should probably be avoided on a first pass.  It could definitely use some cleaning, reorganizing, and pulling up states in the components used.  At least everything works as it should (mostly); I will have to come through on another pass to flesh out the rest of the application too.

Final note here: beware of Turbolinks, it will break your javascript.

## TODO
- [ ] **SECOND PASS, START HERE** Refactor scores#index into pictures#show, pictures#show into scores#show, and clean up all links and redirects

### Features
- [ ] Add profanity filter and guest score names
- [ ] Add a bio for each of the characters (use the fandom wikia for reference)
- [ ] Add sidebar for tracking all locations
- [ ] Add deletion to scoreboards, link_to users while admin, display finished status (and location count out of total)
- [ ] Add users#index
- [ ] Allow users to make their own albums and pictures

### Tests
- [ ] Add ActiveStorage support to unit tests
- [ ] Improve score [timekeeping] support in controller tests(?)
- [ ] Remove redundant PUT/PATCH alternative tests

### Bugs
- [ ] Remove anomalous red bar from bottom of image
- [ ] Change selection.selectedCharacter to default *safely* to only character in array if only one is left (set id, emit event once, etc)

### Performance
- [ ] Clean up all database actions

### Blockers
- [ ] **IMPORTANT:** History (back/forward button) breaks javascript!
- [ ] **IMPORTANT:** When deleting locations from a picture, the scores must reflect this change (edge case).
- [ ] **IMPORTANT:** Production resets local ActiveStorage on every push.  Set up a bucket using AWS.
